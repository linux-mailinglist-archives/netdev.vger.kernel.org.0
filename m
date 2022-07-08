Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31B1456B2F0
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 08:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236950AbiGHGuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 02:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236471AbiGHGuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 02:50:22 -0400
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EAF867599;
        Thu,  7 Jul 2022 23:50:21 -0700 (PDT)
Received: by mail-ed1-f50.google.com with SMTP id r6so14337490edd.7;
        Thu, 07 Jul 2022 23:50:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+/ZsZEkzPw0eYeUwGLX4xLCdhSTPfzJLZOs5yae4prU=;
        b=nDNdbO1yPixnJNT2jqq2V1+W3JxqKSjyhEPP2zKztpG8YFD5w6SVAXLu3tIQNfaUaO
         VpSiuiNReaEu0duWnqEsGU18K6evA5t+UXjOCHHMVrt3O8hfCG1wz0l/zo7UzxWDKRZv
         SrqyM4lFTI4pKHuBZgUNEk+vn7zq0DEv0Xrx43ZaXQZFlfRr9dL6XqeeaAEWahfqgD7G
         0Ehtn5aaZOB42cl6+GXTycUnLkLuw96nhSdooGkZdBT8m/V6hFRHX8q2QT046rrU7pOo
         MqlpTUD5Zs4rP8cNWNvqGOySF3mLzEIeKqMYlq71Y8dxBKXtLqPreTwpXSRrbozjLPuS
         S/ow==
X-Gm-Message-State: AJIora91iIPHqQnQEGjywtVK4cKehYVLM3JX+sKRTg634xYEjOYmIaM9
        SCLlN2u49S4ABWPuFZpA4CuF7X/mckg=
X-Google-Smtp-Source: AGRyM1u1HScerSMocfufpmRxwy9I7MUBqToNtEWUoc+1wV00utccbUf8MBD3C0UtThQ46XdKa4vSdQ==
X-Received: by 2002:a05:6402:5409:b0:42a:a643:4eb8 with SMTP id ev9-20020a056402540900b0042aa6434eb8mr2711015edb.71.1657263020214;
        Thu, 07 Jul 2022 23:50:20 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id u17-20020a056402111100b0043a6e807febsm9568316edv.46.2022.07.07.23.50.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Jul 2022 23:50:19 -0700 (PDT)
Message-ID: <1d708abb-4ab1-3af3-3952-2ebc9be33297@kernel.org>
Date:   Fri, 8 Jul 2022 08:50:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] ath5k: Use swap() instead of open coding it
Content-Language: en-US
To:     Tan Zhongjun <tanzhongjun@coolpad.com>, mickflemm@gmail.com,
        mcgrof@kernel.org, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220704130614.37467-1-tanzhongjun@coolpad.com>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20220704130614.37467-1-tanzhongjun@coolpad.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04. 07. 22, 15:06, Tan Zhongjun wrote:
> Use swap() instead of open coding it.

This still holds:
https://lore.kernel.org/all/0c3acbd4-6ab2-5cc5-6293-54e30093cce2@kernel.org/

> Signed-off-by: Tan Zhongjun

This is a wrong S-O-B line.

> ---
> drivers/net/wireless/ath/ath5k/phy.c | 4 +---
> 1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath5k/phy.c 
> b/drivers/net/wireless/ath/ath5k/phy.c
> index 5797ef9c73d7..c2cf4b79dd95 100644
> --- a/drivers/net/wireless/ath/ath5k/phy.c
> +++ b/drivers/net/wireless/ath/ath5k/phy.c
> @@ -1569,9 +1569,7 @@ ath5k_hw_get_median_noise_floor(struct ath5k_hw *ah)
> for (i = 0; i < ATH5K_NF_CAL_HIST_MAX - 1; i++) {
> for (j = 1; j < ATH5K_NF_CAL_HIST_MAX - i; j++) {
> if (sort[j] > sort[j - 1]) {
> - tmp = sort[j];
> - sort[j] = sort[j - 1];
> - sort[j - 1] = tmp;
> + swap(sort[j], sort[j - 1]);
> }
> }
> }
> -- 
> 2.29.0
> 


-- 
js
