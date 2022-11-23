Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC0A636134
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 15:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238263AbiKWOML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 09:12:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237333AbiKWOMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 09:12:09 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72C31B7A
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 06:12:08 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id 5so13142075wmo.1
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 06:12:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Bws7Utd85LMsHk1OFS5y1Jt3azqf33BIHbl8d6KTHuQ=;
        b=D+wYqLDP1MEA7jCYynzAsSVMjisFupGWEdxCzQFgAuLl/j7P7VMONsmjag6HspHkDv
         2Hb7jLfBYBKn7EXSFEe3S39UkuY40vBMpDWg4yQJ4DUQJ2YzXHc5fdHK/JikDPxeLKxO
         echf0BlGjUZhObFuWaVKRFMbuGyKOaQyUfzZ5RSdHkDArwX/vjxyuFeGEnfPpd2yOQz5
         s6JTEbHITuLdXFNGDf8zpWu7spCPT+9jtpiRGHW4pmypT2XUM/EKUobQXJYypI6Vm0Ol
         b0rOtA2VPArOraLFkReBtfw21uDCV+3qXlv6/BoK+zYCKDvGg/JYisGHDWZ3Nx59gFVi
         1P0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Bws7Utd85LMsHk1OFS5y1Jt3azqf33BIHbl8d6KTHuQ=;
        b=nQwBNlhsqHdwzR5bxaAu5GlDWdBTRkXrhzfTVfOBy0L+nkagEJS89AWZt6vCoP7Mgt
         9/U8mBTLugxUmD9FvZVCa+IMRzP3ANSakxP6wXHb/ai7im0SBKm99wew2nk8v57s1Joc
         lblPrwI4WtctL7nYLUWXpYXnM7c2oS+whPlb33PzdFCyQzPLHA/x3DWg8AvRM7CPQjDt
         64IwNiRPBsx9rW3brCYefwklzsS0dof6R564rOzXqUDqH5LbrMMKgAdQdgPabjsgDqQq
         B5i72BGVNf/gK7uCFgF7C0kxyYL5kKQYieaGioiFdvrGNHwGsprCWbs6CqpkPi+yZsaJ
         XaLw==
X-Gm-Message-State: ANoB5pnLwDvf8qg2UJUM3SxUYgG7nHaW8tPHZKww9M58Ly6EEvqwGt54
        vhlffqYC7bkrRDIoLcYKI9Tt8g==
X-Google-Smtp-Source: AA0mqf6Y0ju2xImGL+9QBlfOHXw/7y97CmSePiN/N1bGOjf5pSx013+27gKxLKN4IqD5oXnpuuoyFA==
X-Received: by 2002:a05:600c:2302:b0:3cf:a3c4:59b3 with SMTP id 2-20020a05600c230200b003cfa3c459b3mr12643453wmo.198.1669212726904;
        Wed, 23 Nov 2022 06:12:06 -0800 (PST)
Received: from [10.83.37.24] ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id y7-20020a1c4b07000000b003b4c979e6bcsm2345676wma.10.2022.11.23.06.12.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Nov 2022 06:12:06 -0800 (PST)
Message-ID: <9e730aaf-9bbb-38d4-c26f-dfc58c4a9352@arista.com>
Date:   Wed, 23 Nov 2022 14:11:59 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v5 1/5] jump_label: Prevent key->enabled int overflow
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Baron <jbaron@akamai.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Steven Rostedt <rostedt@goodmis.org>, netdev@vger.kernel.org
References: <20221122185534.308643-1-dima@arista.com>
 <20221122185534.308643-2-dima@arista.com>
 <Y33uEHIHwPZ/5IiA@hirez.programming.kicks-ass.net>
From:   Dmitry Safonov <dima@arista.com>
In-Reply-To: <Y33uEHIHwPZ/5IiA@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/23/22 09:55, Peter Zijlstra wrote:
> On Tue, Nov 22, 2022 at 06:55:30PM +0000, Dmitry Safonov wrote:
> 
>> +/***
>> + * static_key_fast_inc_not_negative - adds a user for a static key
>> + * @key: static key that must be already enabled
>> + *
>> + * The caller must make sure that the static key can't get disabled while
>> + * in this function. It doesn't patch jump labels, only adds a user to
>> + * an already enabled static key.
>> + *
>> + * Returns true if the increment was done.
>> + */
> 
> I don't normally do kerneldoc style comments, and this is the first in
> the whole file. The moment I get a docs person complaining about some
> markup issue I just take the ** off.

The only reason I used kerneldoc style is that otherwise usually someone
would come and complain. I'll convert it to a regular comment.

> One more thing; it might be useful to point out that unlike refcount_t
> this thing does not saturate but will fail to increment on overflow.

Will add it as well.

> 
>> +static bool static_key_fast_inc_not_negative(struct static_key *key)
>>  {
>> +	int v;
>> +
>>  	STATIC_KEY_CHECK_USE(key);
>> +	/*
>> +	 * Negative key->enabled has a special meaning: it sends
>> +	 * static_key_slow_inc() down the slow path, and it is non-zero
>> +	 * so it counts as "enabled" in jump_label_update().  Note that
>> +	 * atomic_inc_unless_negative() checks >= 0, so roll our own.
>> +	 */
>> +	v = atomic_read(&key->enabled);
>> +	do {
>> +		if (v <= 0 || (v + 1) < 0)
>> +			return false;
>> +	} while (!likely(atomic_try_cmpxchg(&key->enabled, &v, v + 1)));
>> +
>> +	return true;
>> +}
> 
> ( vexing how this function and the JUMP_LABEL=n static_key_slow_inc() are
>   only a single character different )

Yeah, also another reason for it was that when JUMP_LABEL=y jump_label.h
doesn't include <linux/atomic.h> and <linux/bug.h> because of the
inclusion hell:
commit 1f69bf9c6137 ("jump_label: remove bug.h, atomic.h dependencies
for HAVE_JUMP_LABEL")
and I can't move JUMP_LABEL=n version of static_key_slow_inc() to
jump_label.c as it is not being built without the config set.

So, in result I was looking into macro-define for both cases, but that
adds quite some ugliness and has no type checks for just reusing 10
lines, where 1 differs...

> So while strictly accurate, I dislike this name (and I see I was not
> quick enough responding to your earlier suggestion :/). The whole
> negative thing is an implementation detail that should not spread
> outside of jump_label.c.
> 
> Since you did not like the canonical _inc_not_zero(), how about
> inc_not_disabled() ?

Ok, that sounds good, I'll rename in v6.

> Also, perhaps expose this function in this patch, instead of hiding that
> in patch 3?

Will do.

> Otherwise, things look good.
> 
> Thanks!
Thanks again for the review,
          Dmitry

