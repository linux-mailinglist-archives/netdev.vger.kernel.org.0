Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA465A9D0A
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 18:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234994AbiIAQ0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 12:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234925AbiIAQ0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 12:26:52 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B63E5A8B5
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 09:26:51 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id bh13so16857700pgb.4
        for <netdev@vger.kernel.org>; Thu, 01 Sep 2022 09:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=A5e32fasLl3Y+jwVTEFZbCI5JVS0Dg7Fg5+D9kpz9KY=;
        b=Sk+Dco3CJs/V7bkClUrtUzFnSUsj2US4aJCpK9Suzt2vOwWPhJPqMAo03z6L9a/YOR
         F8vhPvCVjz51VlyyOnT3/Ji4F1ktWUc2dkvkurOyuaiDxkqtEoYzbtqfG1cGs90CTk3i
         ZXG+PislW91EoQ80cK6rR55/CcRC2gVVvwCB6LI7FqBN/xOvJaXYajYeZT21JvXRmgm6
         cd9lRG7/1UYZf+9BKC2hR7Sv0X3kiakmUhkP1QZ2vWly83YpSZamY+25TlAZ4iGURPIW
         PmVDdq4+fXlIG2ymPSAIQcb6Lq4g9TRbRKwUsgb7Lum8aA5L8O3psXtejvCj2GYbgPmI
         ApQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=A5e32fasLl3Y+jwVTEFZbCI5JVS0Dg7Fg5+D9kpz9KY=;
        b=REemUmsrkDIOSlov3Qs/RctjUd/VawOqgqNEqQqgasJleBDbl9AQt+PzWDL2tuW8ar
         ZUqAHJuUOKPsNmUTkTuUgiNpjOZ4+i1bQVoVStM9m9Fk+Dq5+5UsLxjfJqcx30xNYEYl
         zeYImCwta/WWSTETieQ1rNGFmzx0NlAsbQU5M5VbY+zzWxfICrXnPNR1L0gc3sDHNF/g
         rlluj+SGFhlYSPODB7sYJdPoOLK1iFuN7388DLjCYK+b1oU8a1ixRdtVb3hcPBSWdsqv
         lBqI7DUgL5CQ07ouxBByrvghfeLAVyIKHTt6nEQtxn7V7izXPCZ+DmLgSd1Kngwn7eoB
         W/IQ==
X-Gm-Message-State: ACgBeo13q8gZlRi0CMQIMKgODoN9ulYTk/xUxDbccb0P6EtgKR2yXkem
        bgVPYVJVVCZpgaOv5FZvpek=
X-Google-Smtp-Source: AA6agR6qDmvEuPjXMIGZDKhuMtffTz5B+iQgK4C5gmPR5noLr0cQQu0YZAH5Br0A1XrHlqVl7+5NPg==
X-Received: by 2002:a63:dd51:0:b0:430:18d9:edf8 with SMTP id g17-20020a63dd51000000b0043018d9edf8mr8263542pgj.163.1662049610486;
        Thu, 01 Sep 2022 09:26:50 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:a5f9:a2b6:fad0:5599? ([2600:8802:b00:4a48:a5f9:a2b6:fad0:5599])
        by smtp.gmail.com with ESMTPSA id y3-20020aa78f23000000b00535e49245d6sm8359475pfr.12.2022.09.01.09.26.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Sep 2022 09:26:50 -0700 (PDT)
Message-ID: <80f9cb5b-0e02-a367-5263-4fbffec055bb@gmail.com>
Date:   Thu, 1 Sep 2022 09:26:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH v2] net: fec: Use a spinlock to guard `fep->ptp_clk_on`
To:     =?UTF-8?B?Q3PDs2vDoXMgQmVuY2U=?= <csokas.bence@prolan.hu>,
        netdev@vger.kernel.org
Cc:     Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Andrew Lunn <andrew@lunn.ch>, kernel@pengutronix.de,
        Marc Kleine-Budde <mkl@pengutronix.de>
References: <20220901140402.64804-1-csokas.bence@prolan.hu>
Content-Language: en-US
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220901140402.64804-1-csokas.bence@prolan.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/1/2022 7:04 AM, Csókás Bence wrote:
> Mutexes cannot be taken in a non-preemptible context,
> causing a panic in `fec_ptp_save_state()`. Replacing
> `ptp_clk_mutex` by `tmreg_lock` fixes this.
> 
> Fixes: 6a4d7234ae9a ("net: fec: ptp: avoid register access when ipg clock is disabled")
> Fixes: f79959220fa5 ("fec: Restart PPS after link state change")
> Reported-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Link: https://lore.kernel.org/all/20220827160922.642zlcd5foopozru@pengutronix.de/
> Signed-off-by: Csókás Bence <csokas.bence@prolan.hu>
> ---

[snip]

>   	schedule_delayed_work(&fep->time_keep, HZ);
>   }
> @@ -599,8 +593,6 @@ void fec_ptp_init(struct platform_device *pdev, int irq_idx)
>   	}
>   	fep->ptp_inc = NSEC_PER_SEC / fep->cycle_speed;
>   
> -	spin_lock_init(&fep->tmreg_lock);

This change needs to be kept as there is no other code in the driver 
that would initialize the tmreg_lock otherwise. Try building a kernel 
with spinlock debugging enabled and you should see it barf with an 
incorrect spinlock bad magic.
-- 
Florian
