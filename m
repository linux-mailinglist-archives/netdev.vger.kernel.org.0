Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9152C777AB
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 10:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbfG0IgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 04:36:07 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40464 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727624AbfG0IgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 04:36:07 -0400
Received: by mail-wr1-f68.google.com with SMTP id r1so56665868wrl.7
        for <netdev@vger.kernel.org>; Sat, 27 Jul 2019 01:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=COFqX+qUZsRZbf17gzlQncHajngroeTnweM2ftVbM5c=;
        b=A+/ZGxKJMnwyOEeL1Bej8aIbqNs+bSrCK8OcyWCwS1Uhbp4WvmzIcdjn4bfply0sbC
         pql4XsagS8DXMaf40junUvjwlcJiB+4CWhb8jVBG53QWEwij0KBuf/bLHnX9x9ofUXcM
         qib+bmz/1y21nbJP8NmkbmpIW2Ctg8h76nQ+HinynxqXXEZIYQG9Nq6alkzg0RbfaDvg
         ttdLrJ+++I8FndWg2VZLz1Qze+8qO4nGwyYt3VAlDyNV7ufz2TEgOiKpPx6hsCm1i1TY
         D8c6xvqcc12RCFCARWSUsI1KRlLSiWYuOuUOie1cWO0LxhvcmwDQx63EwG1RTjOAgyeB
         tHeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=COFqX+qUZsRZbf17gzlQncHajngroeTnweM2ftVbM5c=;
        b=rBSh2bEjKTKVZfDpuH7hiZzbJC1q9+RmOA0urvlenhDzrs/O0hQaOsdVaS2VBNXGhI
         HzaYSfumQD20k7RmzgqZa5MtPybUUbIgm7HAoBYOIgYjeLBZ44JqGKtKZmU7NA0pTfxR
         vHi3VcQnQ3k54ZRbqYAQ+3pqUgl72Hsin9lPB0RJW7UVTgegTive2WQm6eHn5VJ3bfuK
         vbWwEVRJGmh6N9Z9WYy2sJOjaivWRmnlBTqn8qUbveFYDOw3hSNnhQeph4hikz5gozcc
         kPcZEc2jwEaPVlie/Fwlpgpuc17aSACE7opVJRgG0GLcX8KBpaOVcSZybfJIa/nlLXrG
         2ziQ==
X-Gm-Message-State: APjAAAUBV+im3+M+8LBzE0Lvatt6dThpcc9V8hvU15saLI8JM+348hxL
        +EnNwFl9UgfEDEgCL5LeMjo=
X-Google-Smtp-Source: APXvYqx+d7rT1ZEv/tCwvf0n6t4ICqBmXgZeeH6pjVWi4u+2woC2Dhrz77fLPxrEfRv4blV2GPJzag==
X-Received: by 2002:adf:b64e:: with SMTP id i14mr95473934wre.248.1564216564781;
        Sat, 27 Jul 2019 01:36:04 -0700 (PDT)
Received: from localhost (ip-78-102-222-119.net.upcbroadband.cz. [78.102.222.119])
        by smtp.gmail.com with ESMTPSA id y16sm115138689wrg.85.2019.07.27.01.36.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 27 Jul 2019 01:36:04 -0700 (PDT)
Date:   Sat, 27 Jul 2019 10:36:03 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     chrims@mellanox.com, netdev@vger.kernel.org,
        sthemmin@microsoft.com, dsahern@gmail.com, alexanderk@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [patch iproute2 1/2] tc: action: fix crash caused by incorrect
 *argv check
Message-ID: <20190727083603.GB2843@nanopsycho>
References: <20190723112538.10977-1-jiri@resnulli.us>
 <20190726124707.2c53d6a4@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190726124707.2c53d6a4@hermes.lan>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jul 26, 2019 at 09:47:07PM CEST, stephen@networkplumber.org wrote:
>On Tue, 23 Jul 2019 13:25:37 +0200
>Jiri Pirko <jiri@resnulli.us> wrote:
>
>> From: Jiri Pirko <jiri@mellanox.com>
>> 
>> One cannot depend on *argv being null in case of no arg is left on the
>> command line. For example in batch mode, this is not always true. Check
>> argc instead to prevent crash.
>> 
>> Reported-by: Alex Kushnarov <alexanderk@mellanox.com>
>> Fixes: fd8b3d2c1b9b ("actions: Add support for user cookies")
>> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
>> ---
>>  tc/m_action.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/tc/m_action.c b/tc/m_action.c
>> index ab6bc0ad28ff..0f9c3a27795d 100644
>> --- a/tc/m_action.c
>> +++ b/tc/m_action.c
>> @@ -222,7 +222,7 @@ done0:
>>  				goto bad_val;
>>  			}
>>  
>> -			if (*argv && strcmp(*argv, "cookie") == 0) {
>> +			if (argc && strcmp(*argv, "cookie") == 0) {
>>  				size_t slen;
>>  
>>  				NEXT_ARG();
>
>
>The logic here is broken at end of file.
>
>	do {
>		if (getcmdline(&line_next, &len, stdin) == -1)
>			lastline = true;
>
>		largc_next = makeargs(line_next, largv_next, 100);
>		bs_enabled_next = batchsize_enabled(largc_next, largv_next);
>		if (bs_enabled) {
>			struct batch_
>
>
>getcmdline() will return -1 at end of file.
>The code will call make_args on an uninitialized pointer.
>
>I see lots of other unnecessary complexity in the whole batch logic.
>It needs to be rewritten.
>
>Rather than me fixing the code, I am probably going to revert.

I agree. This is a mess :(


>
>commit 485d0c6001c4aa134b99c86913d6a7089b7b2ab0
>Author: Chris Mi <chrism@mellanox.com>
>Date:   Fri Jan 12 14:13:16 2018 +0900
>
>    tc: Add batchsize feature for filter and actions
