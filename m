Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E926A5777FF
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 21:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbiGQTap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 15:30:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232124AbiGQTao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 15:30:44 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7F4D10561
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 12:30:43 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id q13-20020a17090a304d00b001f1af9a18a2so2213162pjl.5
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 12:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=DQtPzp98XVPnkOc4LIwy5mlS8kzxZaSp/636o/XKzaw=;
        b=MvYhjQf5TZyNI4GmEthjMsvH8cD5xEtwpW4dH1mEwfWkxPOHPyElkOIQ2PKbJCiTcy
         HFBMxN4TCW5R494cRRqEZS7Cx0Wn8OIaP0swD+kYFWPZ+1yuhYrcrpLmTITy8uG9unVH
         8Fzeg5hXmIySMuHWjo0zL8F1BBR+Y+PL/+XATXFYaU1+dd0qd+p481wTmMQA1wA8VuVF
         jMUIFIwJE+FRmmqdhxlYpXOcA5faNBkvckZwJs1SN3ZbKiv6m4nKIZYEr0NRImtqNUQp
         2xnRYCAWMFp68fNdtMUSzaag1qq18ncFTJFSzQ7+MDeg8ydyLM5YGi5QSa2G7j/lpB17
         jWrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DQtPzp98XVPnkOc4LIwy5mlS8kzxZaSp/636o/XKzaw=;
        b=wHQI9hkF4ynPeaQyMXIgwRUPj2yNuGLTC1a6voOQzZr3GzPu00DGRyGin++Kc5U/m5
         Z7OYszVmMOeTJj4zctfQXYWFN4Emed2dxwHHYQGxhFCd6RuTd+25VzK0qTtCMnWBss98
         2GE9OzDbXywWklWbgtjMLh0CYbvT6L65w7+RxA4ZYpGnj3cR1/STZw85gUoLlOnJW/vh
         e8/kS37AZr56x7IT4lAEv+7gUlnh719hLRAHoIg8iqrofGgwQa4WhuIgogKMD4/AJoiZ
         yliOqLWNXGwFgAIe17N3KGDjUlWaglMlNG9KTuYRvfIZK5CDzmj3xJpkpYMQeIVW4PfG
         fPdw==
X-Gm-Message-State: AJIora+qx5hrnGx+x7Hg9Jq5uWQcpbJWw7YSBCLiWEfjv+xNC1Zy9YID
        ZK2eC4mgjbJTzJOmv5NZEnN2iid424I=
X-Google-Smtp-Source: AGRyM1uxY5c0ZKl1xJPouzZ8XR0UakaZy5l3Kaq/RkNnW+kTigJ8qneC3tmiraH8hzyzRD6i/DdABQ==
X-Received: by 2002:a17:902:eccf:b0:16b:f555:d42e with SMTP id a15-20020a170902eccf00b0016bf555d42emr24362242plh.75.1658086243155;
        Sun, 17 Jul 2022 12:30:43 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:c1c9:5ca7:2a60:8cc5? ([2600:8802:b00:4a48:c1c9:5ca7:2a60:8cc5])
        by smtp.gmail.com with ESMTPSA id i31-20020a63131f000000b00419fc2c27d8sm2841967pgl.43.2022.07.17.12.30.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Jul 2022 12:30:42 -0700 (PDT)
Message-ID: <0e432ed4-79a4-1285-68c9-45772eccff31@gmail.com>
Date:   Sun, 17 Jul 2022 12:30:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net 09/15] docs: net: dsa: remove
 port_bridge_tx_fwd_offload
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20220716185344.1212091-1-vladimir.oltean@nxp.com>
 <20220716185344.1212091-10-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220716185344.1212091-10-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/16/2022 11:53 AM, Vladimir Oltean wrote:
> We've changed the API through which we can offload the bridge TX
> forwarding process. Update the documentation in light of the removal of
> 2 DSA switch ops.
> 
> Fixes: b079922ba2ac ("net: dsa: add a "tx_fwd_offload" argument to ->port_bridge_join")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
