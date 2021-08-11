Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2EF3E8BD1
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 10:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235867AbhHKIaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 04:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233167AbhHKIae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 04:30:34 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F34B6C061765
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 01:30:10 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id m18so3295319ljo.1
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 01:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kXsO2GxNZ8ToAJGHNyUvwHw1p9HxZpyyxvjjDlzScCQ=;
        b=HKkbBBgjYQPv4VKA346A6QDUcAIjuF4fw8QH7N28tq8RbsqKifOOXtaNO8xH6aWNdK
         0X52rmc/GXAHlfHiRBu7rz65QyAbo18wzCtOX/GRU7Q8wXkrM912bz522AxmnaOdXkQY
         D4W1zq5klbffQTuHfWJw5ekxWFRykLx785CGK/puKmA5VBFZNocj5SNpCIBFSUR0kXe6
         zSkI0AaDIrphYpSG+GSwD58/x7yw2im9rBjb5oGl4uCN0QXnXFhI26ormQhGu8OSnWgy
         9CYwTw6o4XfQgvgmYFGyaDDbQbIlVoo3rqU70IDFfHtWpeAqTxlIgGMIFsCRsAxoHb37
         kACQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kXsO2GxNZ8ToAJGHNyUvwHw1p9HxZpyyxvjjDlzScCQ=;
        b=UvF3Ca42988RBjYIy+qxXpopvqikJArDRaQm0ZwrpyjxzP2/waeEvUS82R+utMDcd4
         KsqG8w7vOGiVogtvQrk9RvTT7s7Z1elWcfu6LaM1YNnJCxhDABRA+gSBNDNa1jnpwUfP
         nfiG4xm9cidN9Um5BpqowWl68OsEtSiXKuWGm1BvI1M5MppfWIaoWbRxIn0w9UgR4hLC
         I2LHbqVJwEDx3ZamsGMDZZbB5db0KTJuzbSL4GSBRefd/shK7Avr37IVXS2zU5Uliyc0
         MsLSg26pnamokLPqU3Elj1XlHxSS21eGVBOD2/5pkHUc2LOQCBeE7PzKTrYp2kCJCqEf
         GnTQ==
X-Gm-Message-State: AOAM532IOh9jxKs12Y0sUrA+lIt7nmMaud/u7SLqRRY5YDeS9vRQL/K2
        KYkH8mUm3BVhmvFyO3wr+tM=
X-Google-Smtp-Source: ABdhPJy+pa62AIYs5Nbz0bpiPduEbDB83yqJYrpaaKuFYE8MZwdfywvYT+k+J2bLfJ4uYGrEaVLgZg==
X-Received: by 2002:a2e:bf09:: with SMTP id c9mr22289826ljr.128.1628670609313;
        Wed, 11 Aug 2021 01:30:09 -0700 (PDT)
Received: from localhost.localdomain ([46.61.204.60])
        by smtp.gmail.com with ESMTPSA id o7sm71651lfg.218.2021.08.11.01.30.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 01:30:08 -0700 (PDT)
Subject: Re: [PATCH] net:sched fix array-index-out-of-bounds in taprio_change
To:     Eric Dumazet <eric.dumazet@gmail.com>, tcs.kernel@gmail.com,
        vinicius.gomes@intel.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Cc:     Haimin Zhang <tcs_kernel@tencent.com>
References: <1628658609-1208-1-git-send-email-tcs_kernel@tencent.com>
 <303b095e-3342-9461-16ae-86d0923b7dc7@gmail.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
Message-ID: <1852afdd-7c93-fdbc-404f-a5c76b9bc5d7@gmail.com>
Date:   Wed, 11 Aug 2021 11:30:07 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <303b095e-3342-9461-16ae-86d0923b7dc7@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/11/21 10:44 AM, Eric Dumazet wrote:
> 
> 
> On 8/11/21 7:10 AM, tcs.kernel@gmail.com wrote:
>> From: Haimin Zhang <tcs_kernel@tencent.com>
>> 
>> syzbot report an array-index-out-of-bounds in taprio_change
>> index 16 is out of range for type '__u16 [16]'
>> that's because mqprio->num_tc is lager than TC_MAX_QUEUE,so we check
>> the return value of netdev_set_num_tc.
>> 
>> Reported-by: syzbot+2b3e5fb6c7ef285a94f6@syzkaller.appspotmail.com
>> Signed-off-by: Haimin Zhang <tcs_kernel@tencent.com>
>> ---
>>  net/sched/sch_taprio.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>> 
>> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
>> index 9c79374..1ab2fc9 100644
>> --- a/net/sched/sch_taprio.c
>> +++ b/net/sched/sch_taprio.c
>> @@ -1513,7 +1513,9 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
>>  	taprio_set_picos_per_byte(dev, q);
>>  
>>  	if (mqprio) {
>> -		netdev_set_num_tc(dev, mqprio->num_tc);
>> +		err = netdev_set_num_tc(dev, mqprio->num_tc);
>> +		if (err)
>> +			goto free_sched;
>>  		for (i = 0; i < mqprio->num_tc; i++)
>>  			netdev_set_tc_queue(dev, i,
>>  					    mqprio->count[i],
>> 
> 
> When was the bug added ?
> 
> Hint: Please provide a Fixes: tag
> 
> taprio_parse_mqprio_opt() already checks :
> 
> /* Verify num_tc is not out of max range */
> if (qopt->num_tc > TC_MAX_QUEUE) {
>      NL_SET_ERR_MSG(extack, "Number of traffic classes is outside valid range");
>      return -EINVAL;
> }
> 
> So what is happening exactly ?
> 
> 

Hi, Eric!

I've looked into this bug, but I decided to write a reproducer for it 
first. Unfortunately, I didn't finish it yesterday, but I have an idea 
about what happened:

taprio_parse_mqprio_opt() may return 0 before qopt->num_tc check:

	/* If num_tc is already set, it means that the user already
	 * configured the mqprio part
	 */
	if (dev->num_tc)
		return 0;

Then taprio_mqprio_cmp() fails here:

	if (!mqprio || mqprio->num_tc != dev->num_tc)
		return -1;

That's why we won't get shift-out-of-bound in taprio_mqprio_cmp().

And finally taprio_change() gets to buggy for with wrong mqprio->num_tc.
I don't know how to reproduce it, but I'll try to finish my reproducer 
this evening.


Does above makes any sense?



With regards,
Pavel Skripkin
