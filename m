Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 933396C6DAC
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 17:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbjCWQeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 12:34:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbjCWQdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 12:33:43 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A9E62A16D;
        Thu, 23 Mar 2023 09:32:33 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id s12so27199722qtq.11;
        Thu, 23 Mar 2023 09:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679589152;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jXoBBxFMsJczFH9bpzVDlikxesZHgShklnWmbKV32x8=;
        b=pNG1AORFOm3s5cO6JEloApL1y3GOxUu8NVrsJSPooWZYuV8zoBH8noemN4zyW5lJhF
         TQP80zQG/UPBBU6IR5eLy8TdjOigWA58st4Ii33A41oJwKRGKD15mNqNbvZHHE0e3Os9
         dyq4kOHnwGgHLtz7qzyVDLnifuH9eHJhaxtcuUkgaScAV5HWjyihQnMO+QjKo5eHkFk1
         nJ2AvYO8wcvGH1XS5ygrOvhI9Ffh+PDAslwHlWjuR5HFwgMe4laE3xTyvrLYWR+qw73O
         7xvKN9R93zZw8P5KGI/8UB6rLB8l7ve+yNiz/aU8yPmIXJUdCsrWWFtGmCKgIU+1C2di
         87yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679589152;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jXoBBxFMsJczFH9bpzVDlikxesZHgShklnWmbKV32x8=;
        b=US6JFZNtogpRSMjNJ9LQqSvXI4Qd4pLetI0+UTCeE7AuzTWH46eI6RFgkQoctA83U8
         Zxtxy8qouGEu5CtefA+MmOxwH7cPg3yr/N6kXKfqw6dZZL3Ea5iOm29JpFfsm42HJ+75
         msRPrZ8wYpaac/fBWsikjZkA7kgBa7O2crlx5Fqv1j+Jpk6F+0v7DO+yv2frqPd2OXIJ
         xPyVWeZbS/VoNGy0CRgnW0tuUvJmkANIh30IRmFecfnxd6VzEMVkSH/FE6NufM9TBARm
         hSb5jjR4EhXhpwKdk5xmszMHL4CkE2VLEGJPnmT47e7rhDBW1BFg1imMinsOCqzlWmFV
         bvGQ==
X-Gm-Message-State: AO0yUKWhvw2HHcl+JS6PjL8nNATMKSuUSIMZyNiwfeJfZZB+gwzlbuIP
        ZiXAhdCS0NNyu15I4V1gzmo=
X-Google-Smtp-Source: AK7set+SkPaPKTZN4uU3iMiYPLR+yOlu+8GvrK+NIY+6PNeQSWCRuymsJYJ7nuK8LBJ3TmpWQ6UWzQ==
X-Received: by 2002:a05:622a:1304:b0:3e2:4280:bc5d with SMTP id v4-20020a05622a130400b003e24280bc5dmr11900228qtk.23.1679589152085;
        Thu, 23 Mar 2023 09:32:32 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id i8-20020ac84888000000b003e38e2815a5sm2363470qtq.22.2023.03.23.09.32.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 09:32:31 -0700 (PDT)
Message-ID: <05edcae4-37c5-4466-7716-da592c99ffc4@gmail.com>
Date:   Thu, 23 Mar 2023 09:32:25 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next 5/9] net: dsa: tag_ksz: do not rely on
 skb_mac_header() in TX paths
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org
References: <20230322233823.1806736-1-vladimir.oltean@nxp.com>
 <20230322233823.1806736-6-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230322233823.1806736-6-vladimir.oltean@nxp.com>
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
> dev_start_xmit()"). As preparation for that, let's use skb_eth_hdr() to
> get to the Ethernet header's MAC DA instead, helper which assumes this
> header is located at skb->data (assumption which holds true here).
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

