Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B67F6C6DB1
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 17:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231793AbjCWQe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 12:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbjCWQd4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 12:33:56 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F81733CD9;
        Thu, 23 Mar 2023 09:32:43 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id bz27so15488248qtb.1;
        Thu, 23 Mar 2023 09:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679589162;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gQ/65gDGq3+1pjKQZ0fWq2F2Rh6nvrUOZSoWkysxM04=;
        b=bAHsQe3lkzk3IHWM/bzc4Cr+jxeNMMMwwUMUiYkcq+EtiGkRIdz76r8Y3UDf+zoj/t
         07uBNm0TAbADC5wXyR7equ9n0wwZ77PdbE/27X6Zs28Zel4lk1IdRlJtS5PRI5vT76TL
         D0X+ze4IWmPv/tSjdyJPhN3vzJ+rfcT2ZfllYDAhryQWpSpWpLLpJTqlVcmz4PvbDRuC
         umT2RBAGiLCuwlNZT+tNiNR8s2bS/ymNgFph30lrsgGQqshZ+AbFT7fBd1qhtU2KOUFA
         vtUcF7HQKBj9WhfT3jC183gsQg6+h2MBGm3xpaaMBO9lWXOmrvwEWkLZGa8LX8QqcoX0
         AACA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679589162;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gQ/65gDGq3+1pjKQZ0fWq2F2Rh6nvrUOZSoWkysxM04=;
        b=juGh0/96xeImwOldUINoAygHkv7YPZqFZkfFgCsCVqXuwvvEYgx3Q2vMI6BEReBLJG
         eazmTcOBo15xY4gdDGw1zQrGezAQ2qdciosL4uiSoKkW6N2VWv/yJoPzrJ/gUnlITGW8
         kFQ4QaJQMW74ekUSgCHb+zplX7t4G93931/b4VVyHQGRN2YFtmtpkqlMch1qfLsI0AbZ
         Y93IM8vO1Bt5BxhUQFn9wgF9afD0rZZIRrPzh//czgiuGsH2vY/KBx/QMQEZ16TUerYX
         1aMOvKeS3V5Rck7rRC1flMKwJtu/ja3Qrg2fINojIEUW6nK+cxkk9J/yZIItlwigTxHe
         Rwmw==
X-Gm-Message-State: AO0yUKXMbjSbrSoafpCjXCGVlSGfTmx3HgAUca6ZpghKZxRNs6WKAj53
        oQjH47cx6wayOxnfgE4SCyUmUXHMZRU=
X-Google-Smtp-Source: AK7set8qOz3B11rFdsSoYu3EaktoO1jYcxj9aGpTWjc/ZreEtlyiZpWxy091zxbGXi+m0eID0eSwvw==
X-Received: by 2002:a05:622a:10d:b0:3e1:90e4:c1d with SMTP id u13-20020a05622a010d00b003e190e40c1dmr11817604qtw.58.1679589162476;
        Thu, 23 Mar 2023 09:32:42 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id r1-20020ac87941000000b003e1f984c9f3sm7095483qtt.93.2023.03.23.09.32.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 09:32:41 -0700 (PDT)
Message-ID: <510fc25a-6df0-df50-ed93-ebf3c2bbf423@gmail.com>
Date:   Thu, 23 Mar 2023 09:32:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next 6/9] net: dsa: tag_sja1105: don't rely on
 skb_mac_header() in TX paths
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org
References: <20230322233823.1806736-1-vladimir.oltean@nxp.com>
 <20230322233823.1806736-7-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230322233823.1806736-7-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/22/23 16:38, Vladimir Oltean wrote:
> skb_mac_header() will no longer be available in the TX path when
> reverting commit 6d1ccff62780 ("net: reset mac header in
> dev_start_xmit()"). As preparation for that, let's use
> skb_vlan_eth_hdr() to get to the VLAN header instead, which assumes it's
> located at skb->data (assumption which holds true here).
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

