Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F61544C292
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 14:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232107AbhKJN5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 08:57:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbhKJN5r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 08:57:47 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC545C061764;
        Wed, 10 Nov 2021 05:54:59 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id z21so10894472edb.5;
        Wed, 10 Nov 2021 05:54:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pnMFfXSIK0gOJzgv9P5Q3bFjh2yOHD/Py3xNzbx7liI=;
        b=DaxEKeeveuNPHWXUsWLoMCZ8nmM+HOI2l1fjVKdlYWIXJuMEOW9uRYYwlOZGwIMOyI
         hCb9fUe42nlb5hHD7orsrNzw/p/pOB4ktH9LcO4fUr9QQqqFGdp+P5+Z4E5+8LRjSbNl
         kRqfYyozQ5ItH1rm0daNJh0WQJswbIa6BcVWWY3azBWgdkrhELwEz6qjdctqpw+zP035
         zNrulUsTZXp3v/LQ3T4TtyVD4FxxqN6r6V8svZmSBAYMruH3kZGnm2ttr0ruae3Lto8t
         BUEiil7G04L3g2e9g/ZSBe6dAtJI7KbQGqaZQdWDf7QXl/ePj8pCo9eKNX+yuhgme2H/
         QFKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pnMFfXSIK0gOJzgv9P5Q3bFjh2yOHD/Py3xNzbx7liI=;
        b=Eaoy822zazT6IaohRcfm7qBZyFld4cwLLy+LCpUbOyuT0k+/moKSxEsFV+MV5fZUJC
         TofsMAz0L/RGtSlN3niXoO3VkVvg5rjS4QxITIrf+Ez+e4CCEq4O7dyzAugAqmr9Xw6Z
         ahD0ecWDDc80r/8tTPHKvXWmTKHAgwDGEWFaqUc6uqQei6P/LEIBOnJFg050kYBIJEBM
         5ryNBjH1ktEy541AhJLHVuZvO3xXx2uaKrshVG9ksUPki/Ty0EIFp/G8n9JiSLSgJeQ5
         7eMjbFT7wF19Zf0tgYw5jrZ+fMyLWcW5JBOiNDS+foqlttL/kXKyujoIJqqqvN5FqEdv
         3kuA==
X-Gm-Message-State: AOAM532bPj4vruYGBLKWXIGFVALeezZcn4ZK5DvGDBt8c5MPqc7uKKi9
        DCw+tzk9o+EoKl3+nuBktF69JMmQt24=
X-Google-Smtp-Source: ABdhPJwhIJzOJkK/C0bDxYm/p+QeitAzm+e4vWnx+JQV2GArHBogz96153yOdjZxIXlTTfuL7XheLA==
X-Received: by 2002:a05:6402:280f:: with SMTP id h15mr22110633ede.286.1636552498156;
        Wed, 10 Nov 2021 05:54:58 -0800 (PST)
Received: from ?IPv6:2a04:241e:501:3870:96c9:d70f:c1d:e56? ([2a04:241e:501:3870:96c9:d70f:c1d:e56])
        by smtp.gmail.com with ESMTPSA id hb36sm8983687ejc.73.2021.11.10.05.54.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Nov 2021 05:54:57 -0800 (PST)
From:   Leonard Crestez <cdleonard@gmail.com>
Subject: Re: [PATCH 08/11] selftests: net/fcnal: Replace sleep after server
 start with -k
To:     David Ahern <dsahern@gmail.com>, Shuah Khan <shuah@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>,
        Seth David Schoen <schoen@loyalty.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        linux-kselftest@vger.kernel.org
References: <cover.1633520807.git.cdleonard@gmail.com>
 <ec40bd7128a30e93b90ba888f3468f394617a010.1633520807.git.cdleonard@gmail.com>
 <43210038-b04b-3726-1355-d5f132f6c64e@gmail.com>
 <d6882c3f-4ecf-4b4e-c20e-09b88da4fbd6@gmail.com>
 <888962dc-8d55-4875-cf44-c0b8ebaa1978@gmail.com>
Message-ID: <dfe10fec-b2d8-16c0-ae20-6839f47b2809@gmail.com>
Date:   Wed, 10 Nov 2021 15:54:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <888962dc-8d55-4875-cf44-c0b8ebaa1978@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/7/21 4:22 AM, David Ahern wrote:
> On 10/6/21 3:35 PM, Leonard Crestez wrote:
>>
>> I counted the [FAIL] or [ OK ] markers but not the output of nettest
>> itself. I don't know what to look for, I guess I could diff the outputs?
>>
>> Shouldn't it be sufficient to compare the exit codes of the nettest client?
> 
> mistakes happen. The 700+ tests that exist were verified by me when I
> submitted the script - that each test passes when it should and fails
> when it should. "FAIL" has many reasons. I tried to have separate exit
> codes for nettest.c to capture the timeouts vs ECONNREFUSED, etc., but I
> could easily have made a mistake. scanning the output is the best way.
> Most of the 'supposed to fail' tests have a HINT saying why it should fail.

It is not good to have a test for which correctness is ambiguous to such 
an extent, it makes reliable future changes difficult. In theory an 
uniform TAP format is supposed to solve this but it is not applied 
inside selftests/net.

I attempted to write a script to compare two logs in their current 
format: https://gitlab.com/cdleonard/kselftest-parse-nettest-fcnal

It does a bunch of nasty scrubbing of irrelevant behavior and got it to 
the point where no diffs are found between repeated runs on the same 
machine.

One nasty issue was that many tests kill processes inside log_test so 
relevant output may be shown either before or after the "TEST: " result 
line. This was solved by associating output until the next ### with 
previous test.

>> The output is also modified by a previous change to not capture server
>> output separately and instead let it be combined with that of the
>> client. That change is required for this one, doing out=$(nettest -k)
>> does not return on fork unless the pipe is also closed.
>>
>> I did not look at your change, mine is relatively minimal because it
>> only changes who decide when the server goes into the background: the
>> shell script or the server itself. This makes it work very easily even
>> for tests with multiple server instances.
> 
> The logging issue is why I went with 1 binary do both server and client
> after nettest.c got support for changing namespaces.

It's possible to just compare the "client" and "server" logs separately 
by sorting them on their prefix.

I think a decent approach would be to do a bulk replace for all 
"run_cmd{,_nsb,_nsc} nettest" with a new "run_nettest" function that 
passes all arguments to nettest itself. That run_nettest function could 
include a leading common "-t" arg that is parsed at the top of 
fcnal-test.sh.

--
Regards,
Leonard
