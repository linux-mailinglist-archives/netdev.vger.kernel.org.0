Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66E446A7269
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 18:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjCARzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 12:55:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjCARzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 12:55:42 -0500
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E56F6474D6
        for <netdev@vger.kernel.org>; Wed,  1 Mar 2023 09:55:40 -0800 (PST)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-1763e201bb4so352371fac.1
        for <netdev@vger.kernel.org>; Wed, 01 Mar 2023 09:55:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lW9USzRjSNKQcr3Hd3xJSw/v5dVfuxODJ3A3WZVp0uU=;
        b=AFs2vJWDFrLqGzqYeUdTXRhtZoHCVXhHUhHyeMISPRpXjEyXTreLl02HGOCiIsMevE
         aXBD8Fv0f67yGbYPaUPZJkRH9iXg2bPc0VlNdsyhPj4plM8plBFG7OPpXE23OQr7zAao
         7Q5bFJLVIb3jGdYXggB3Wx9a6kj7vKvVPKZCVL75oS1J3REUKp+Uj94yNhBEubImQJLL
         AdxlKYrXp/SpFdTO+C8MbMo8ypXVgLfuI1Ell1iX650mt5EhY+Gm2+3IoIxAZa4a7/CB
         yMgvffw8n86PuLHcJUieiJa+IscckXLtp2J9mSED+D7rb5aLUlktMz6fi+5RuyNZm5Y3
         HpyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lW9USzRjSNKQcr3Hd3xJSw/v5dVfuxODJ3A3WZVp0uU=;
        b=aK0yF9+vNOfusZ+IjmNIF7xCx96hYYmbaOFg6qhC7mfm5W4RrdL99XcacbgcSOjw7v
         quA5ajwjUYq3LwCd1uDbQIb7UNFYwCvnTgmHhEjw6ZhpNZMz5cN7IJ3KD6yD+QiyXDtl
         CCDUm0ZJyVUKLIgKn2ZkkaPMEifUIdDjUTywmB1m3msvmkjPNW/Q23DI49T+e4jrB9Wq
         sGvn4tXJphJ9XpPVz5PXrhm37JOkZjJc4LURmVLnxpj7pSzykTMG9YICHzq+leoKtWve
         vQ4w+Gj+X17H48RnJUxnZeqC2iBtF7k2toiVx8qBYOmU0jflaquXiIXr1flwYxBMboX1
         WfIA==
X-Gm-Message-State: AO0yUKVtZBVl25zyy7mzwVpSfYBmZzmpPjjVfEf/+HhSqRg1PGNxIGtn
        gJxvT+FzX//PNNrMqZo2Y3mG0pDUUUqob+eI
X-Google-Smtp-Source: AK7set95LKBtipZzpYbeJfd95ANJd4uwmQb29UZ+jkIclSkzBVeNqAhQtdUvLivzlUxFhGGL0ubw5Q==
X-Received: by 2002:a05:6870:c1ce:b0:163:1b4d:d58a with SMTP id i14-20020a056870c1ce00b001631b4dd58amr4642478oad.33.1677693340232;
        Wed, 01 Mar 2023 09:55:40 -0800 (PST)
Received: from ?IPV6:2804:1b3:7000:b7ef:4775:7234:d5d9:b9b4? ([2804:1b3:7000:b7ef:4775:7234:d5d9:b9b4])
        by smtp.gmail.com with ESMTPSA id q3-20020a056870730300b0017289a068c0sm4566794oal.46.2023.03.01.09.55.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Mar 2023 09:55:39 -0800 (PST)
Message-ID: <02d77548-3257-0293-60c5-2b1a13079922@mojatatu.com>
Date:   Wed, 1 Mar 2023 14:55:37 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCHv2 iproute2] u32: fix TC_U32_TERMINAL printing
Content-Language: en-US
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>
References: <20230301142100.1533509-1-liuhangbin@gmail.com>
From:   Victor Nogueira <victor@mojatatu.com>
In-Reply-To: <20230301142100.1533509-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/03/2023 11:21, Hangbin Liu wrote:
> We previously printed an asterisk if there was no 'sel' or 'TC_U32_TERMINAL'
> flag. However, commit 1ff22754 ("u32: fix json formatting of flowid")
> changed the logic to print an asterisk only if there is a 'TC_U32_TERMINAL'
> flag. Therefore, we need to fix this regression.
> 
> Before the fix, the tdc u32 test failed:
> 
> 1..11
> not ok 1 afa9 - Add u32 with source match
>          Could not match regex pattern. Verify command output:
> filter protocol ip pref 1 u32 chain 0
> filter protocol ip pref 1 u32 chain 0 fh 800: ht divisor 1
> filter protocol ip pref 1 u32 chain 0 fh 800::800 order 2048 key ht 800 bkt 0 *flowid 1:1 not_in_hw
>    match 7f000001/ffffffff at 12
>          action order 1: gact action pass
>           random type none pass val 0
>           index 1 ref 1 bind 1
> 
> After fix, the test passed:
> 1..11
> ok 1 afa9 - Add u32 with source match
> 
> Fixes: 1ff227545ce1 ("u32: fix json formatting of flowid")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Reviewed-by: Victor Nogueira <victor@mojatatu.com>

> ---
> v2: add tdc test result in the commit description
> ---
>   tc/f_u32.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tc/f_u32.c b/tc/f_u32.c
> index bfe9e5f9..de2d0c9e 100644
> --- a/tc/f_u32.c
> +++ b/tc/f_u32.c
> @@ -1273,7 +1273,7 @@ static int u32_print_opt(struct filter_util *qu, FILE *f, struct rtattr *opt,
>   	if (tb[TCA_U32_CLASSID]) {
>   		__u32 classid = rta_getattr_u32(tb[TCA_U32_CLASSID]);
>   		SPRINT_BUF(b1);
> -		if (sel && (sel->flags & TC_U32_TERMINAL))
> +		if (!sel || !(sel->flags & TC_U32_TERMINAL))
>   			print_string(PRINT_FP, NULL, "*", NULL);
>   
>   		print_string(PRINT_ANY, "flowid", "flowid %s ",

