Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B92F75750D9
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 16:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239415AbiGNOaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 10:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238984AbiGNOax (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 10:30:53 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9D0962A6D;
        Thu, 14 Jul 2022 07:30:51 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id j22so3781794ejs.2;
        Thu, 14 Jul 2022 07:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=mhxl6eN4n1/eHRsFI0/DaV3ApKNuqLo+yTBdClbFgTQ=;
        b=TRd/5gS0532BsVfScibV1uknLn8y47TMMuLa7gwdQAKuLDNlCEsP0nT6ca5h0H0O3h
         sAqkBYDeAzqvn9z6p9TMeJvmxNuq0eCctO4umtMKnEZiqGxC3YPLThAuHG0kPdQgPAI2
         D1W8bUUbbhu/7xeVG/MGXxE8zc0wI47LoiKqQr4rOZeNdL634tqBdhmeelD3hpV3nAkl
         ygsJRG3qQKpA4C9A9CEFQGTyE6AIiruq7pq1xSYYxVfcGA7Z6zaRhc3Qf6HQyhjWcOTT
         6nS0NHlZ60uBewd0uGUvja2HYjAJTVMXHaq1Y+xv8STcnwlapEwghUcHH+lb0jgVFhZ4
         9bow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mhxl6eN4n1/eHRsFI0/DaV3ApKNuqLo+yTBdClbFgTQ=;
        b=Z+EpSa2TlxJ9U7t3LOtmZPY3wMhZf+AShTD1krQdh8WqHJc1+oGnRWAPcUN+dox60y
         KND9BDLucHagLo+z9YMD0E03B0AwGQXsYZQLKyZS+XAK7ZEXvCqA2k8xbzcp7uv3Wlmz
         urnpWFCztbNHtTI/STuGw1wz02H2PM4CqEolz6U9+uZSlDyJS6kOcDOgwRIifDYzjfrl
         rQOUrQiRMU9kJs9/e9gRiEzzJqtU8vaaJB6zTvzDCMFolHO383FfGxTxJBpeghuMNG5T
         G0Pu/La5ygVkBIS893VOjKj1EEfQDd8O7+wCmCN/VfO2KXyYnA3f1oAiOgyVrKlepVLz
         HfPw==
X-Gm-Message-State: AJIora/HUZrI3mUeQ9o9748XTeGNA+9FzVQ5ZuoFIZ5oia/QZAFEbypi
        EYxQ4Tjvnh2iBalkFoMJ2eI=
X-Google-Smtp-Source: AGRyM1vCHoOBnx8lHPDEQ6erOmD8PP6lAMuCwxcVYKikQmjy12ujMqVxUfcL4ttkRL10Axsyh3zxrQ==
X-Received: by 2002:a17:906:cc45:b0:72b:313b:f3ee with SMTP id mm5-20020a170906cc4500b0072b313bf3eemr8854277ejb.362.1657809050339;
        Thu, 14 Jul 2022 07:30:50 -0700 (PDT)
Received: from debian64.daheim (p5b0d78f3.dip0.t-ipconnect.de. [91.13.120.243])
        by smtp.gmail.com with ESMTPSA id r14-20020aa7cfce000000b0043a4de1d421sm1134425edy.84.2022.07.14.07.30.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 07:30:49 -0700 (PDT)
Received: from localhost.daheim ([127.0.0.1])
        by debian64.daheim with esmtp (Exim 4.96)
        (envelope-from <chunkeey@gmail.com>)
        id 1oBxyj-0006LN-2D;
        Thu, 14 Jul 2022 16:30:49 +0200
Message-ID: <5d4c944e-005e-a443-cb87-230c4e097f93@gmail.com>
Date:   Thu, 14 Jul 2022 16:30:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH v2] p54: add missing parentheses in p54_flush()
Content-Language: de-DE, en-US
To:     Rustam Subkhankulov <subkhankulov@ispras.ru>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        ldv-project@linuxtesting.org
References: <20220714134831.106004-1-subkhankulov@ispras.ru>
From:   Christian Lamparter <chunkeey@gmail.com>
In-Reply-To: <20220714134831.106004-1-subkhankulov@ispras.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/07/2022 15:48, Rustam Subkhankulov wrote:
> The assignment of the value to the variable total in the loop
> condition must be enclosed in additional parentheses, since otherwise,
> in accordance with the precedence of the operators, the conjunction
> will be performed first, and only then the assignment.
> 
> Due to this error, a warning later in the function after the loop may
> not occur in the situation when it should.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Signed-off-by: Rustam Subkhankulov <subkhankulov@ispras.ru>
> Fixes: 0d4171e2153b ("p54: implement flush callback")

For reference: This is the "warning" the commit message talks about:
| WARN(total, "tx flush timeout, unresponsive firmware");
| } // this is right at the end of the p54_flush() function


from what I can tell, the difference between:

|	while ((total = p54_flush_count(priv) && i--)) {

and

|	while ((total = p54_flush_count(priv)) && i--) {

boils down to what that "total" ends up being after the
while() has run through.

In the original code it can either be 0 (for everything is ok)
or 1 (still pending - this is bad / firmware is on the fritz).

In the patched version "total" will be 0 or the value of
p54_flush_count(priv).

I think both the current and the patched version behave
the same way and produce the same output.

However I think (since the variable is named "total")
the returned value of p54_flush_count() is indeed more
precise here.

Acked-by: Christian Lamparter <chunkeey@gmail.com>

> ---
>   drivers/net/wireless/intersil/p54/main.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/intersil/p54/main.c b/drivers/net/wireless/intersil/p54/main.c
> index a3ca6620dc0c..8fa3ec71603e 100644
> --- a/drivers/net/wireless/intersil/p54/main.c
> +++ b/drivers/net/wireless/intersil/p54/main.c
> @@ -682,7 +682,7 @@ static void p54_flush(struct ieee80211_hw *dev, struct ieee80211_vif *vif,
>   	 * queues have already been stopped and no new frames can sneak
>   	 * up from behind.
>   	 */
> -	while ((total = p54_flush_count(priv) && i--)) {
> +	while ((total = p54_flush_count(priv)) && i--) {
>   		/* waste time */
>   		msleep(20);
>   	}

