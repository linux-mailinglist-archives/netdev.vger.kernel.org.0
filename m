Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE6B56C6D96
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 17:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbjCWQbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 12:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232034AbjCWQbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 12:31:32 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A2036FFE;
        Thu, 23 Mar 2023 09:30:54 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id g19so2090983qts.9;
        Thu, 23 Mar 2023 09:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679589053;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vNEodOLpwGq1qEFMa9cE+bSHiYqipnFFUac1/whHCvU=;
        b=MZ84MofQJKn1V+IhgGddG62wUqrXfSw8i4xTv7RFRRuuWu0u01NQt0v5vdXkOljnyA
         JpDDIE96DBxpckg6BYTvZzYVOev7XydCbdDgiutfJkFX6MPawu+q3BYawygNKLA4llQh
         NXn0O1N3baAo92RA/eCWDvQ3sOc10aW6b+fNUWk3LvUJfB6z6cy+EipfOI/Vf0HnvN/T
         8eKJB5YAOzjPtTheglmgrPDriLwqXpySDWSdiic8573/e3J1SBSRxWlVTFChngfpDBOG
         k685mpn3oyisF/jQH1VHdNshDnJNEySRiOhTf60WUqW1kka7xxcW5+a3GiUPYcmoDbwg
         vmjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679589053;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vNEodOLpwGq1qEFMa9cE+bSHiYqipnFFUac1/whHCvU=;
        b=z4xFalTT5cKmMNW4LQXINHdvEhNmf7paLzagRZVCxkOrgpKRiIorSSyJ4MYwNij7EI
         786FpgpB7OJWq9GVEKlW/N/LTjVZCfylsEQESJrQMfuzEyaYPgDwgj+EPk+3403dOy7H
         4G1NO59GEs23DPhhmzZg/REun2Ygbz9jtVp9C7p7l72Z1/MF6kIgbttq54YgyLc7naEK
         nFRHgDJMc5jwF4U/Hsya7e8lrbXzx9Y23gOvpE5XLqdyy7i4Dt+lsqwcZpJwCYwDQP55
         8oZYUNT81nx8zi89u8TvbVnKdcum9yyZa9daOfnLgZf8b8+n6pzTduaR4Mid8sQKCqQy
         xjRA==
X-Gm-Message-State: AO0yUKVMgbQfQcuuKjhCuvhDHbuK6TiuTvc7+aH9/0iGsW1yrQEXcVMc
        d9Ps0COhQ0wg0xQlFn9GCtI=
X-Google-Smtp-Source: AK7set8VsQN5M9kM0OfwAvJwITXAzHHgQVuVJCA5Euh0Y0mv5MPeI9FT6zBSFQOh2V7dQ22NQ8Z1Qw==
X-Received: by 2002:a05:622a:242:b0:3bf:da83:f8d6 with SMTP id c2-20020a05622a024200b003bfda83f8d6mr12333398qtx.28.1679589053656;
        Thu, 23 Mar 2023 09:30:53 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id q17-20020a05620a025100b00746b3eab0fdsm2831876qkn.44.2023.03.23.09.30.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 09:30:53 -0700 (PDT)
Message-ID: <c93e6d64-1120-fee2-3d1f-139b99735956@gmail.com>
Date:   Thu, 23 Mar 2023 09:30:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next 1/9] net: vlan: don't adjust MAC header in
 __vlan_insert_inner_tag() unless set
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org
References: <20230322233823.1806736-1-vladimir.oltean@nxp.com>
 <20230322233823.1806736-2-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230322233823.1806736-2-vladimir.oltean@nxp.com>
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
> This is a preparatory change for the deletion of skb_reset_mac_header(skb)
> from __dev_queue_xmit(). After that deletion, skb_mac_header(skb) will
> no longer be set in TX paths, from which __vlan_insert_inner_tag() can
> still be called (perhaps indirectly).
> 
> If we don't make this change, then an unset MAC header (equal to ~0U)
> will become set after the adjustment with VLAN_HLEN.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

