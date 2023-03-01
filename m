Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 591B86A6677
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 04:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbjCADZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 22:25:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjCADZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 22:25:03 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8725C2A9AF
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 19:24:59 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id 6-20020a17090a190600b00237c5b6ecd7so11317002pjg.4
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 19:24:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677641099;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bb5srTTxnYhg6tlMOKd7a38GxX4ZsEvHnTUQ0s3Mz4E=;
        b=a8eIsseyIXV0mEp+tIHvoZmkvAKPg4h0nSLZisEOymOINOZfBIM2gy2RHNYzYSkN54
         3X7fQrkYB6Ra0MC1B/2/RF2C6c3SFEY3NHwrbp3/2HsFdhC/tDfkPwwVTNMjdv1gSr/u
         11fRAHN1l8n/bjoauicn/NguzQAkx7Q6XSfHVS9kERfNt/T0EukE7Kz0RV/iLhhNvYdN
         LWLSKIbLQ5xT17ZuGNrPvARTmsRTnx+7rH+eu/DhOPK6RireZFn8gEbhqEsm0hG07EUh
         +DNsyDQpcIs/DpNunapF2D9aB7Nd8d62HF8k43ppjIdw0GYoPevE3YU6sDcnkCUoMSrF
         8gVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677641099;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bb5srTTxnYhg6tlMOKd7a38GxX4ZsEvHnTUQ0s3Mz4E=;
        b=lF/rrpwyb9hUAohsy7ZGZCdQJwC31c/B/14moqEcO4Qb8kNuKZkmC6nzTF5j5KRl1P
         TjvzkHlT/qfFuVTov+wbvBV8aofRZpEQZ9ScAFopTdfHDN7ixKlBmhu+yjfRY+fIQwol
         JNuaPWH3jvjs7ZHTxORlMPHyTHRve8Qh9dOHfK7ZTtaP27b9brUI3EEOUaw3ifF9Cmp+
         TjWkQ7uHoNrUj5wGdS4+qdt/XhFdg/w+WrVfSa4wI16YhQOQ35s78uH7rjP+lSt/Sj0C
         mYmhgPDDhugnQ8SmBAfYy4mwmIE87ofs0tUnbldoeF7pM4DQ65naNV1PXa8QfDakL96M
         CIPw==
X-Gm-Message-State: AO0yUKVdM5B4sPdtZIetstwq2kt0AOB7Y4NMl1cMJ83Ll77gwP4y/KL7
        2JzAvRT6jHH+WqD96gKxzZ0=
X-Google-Smtp-Source: AK7set8lc1sJRsTF2AjgnwWlHA4S7go4C8Sz6ADu2lX4zSClwkL27GM6lnrQXEn8GOcKJW16gY1xbg==
X-Received: by 2002:a05:6a21:7885:b0:c7:5d84:d6e0 with SMTP id bf5-20020a056a21788500b000c75d84d6e0mr5901594pzc.31.1677641098969;
        Tue, 28 Feb 2023 19:24:58 -0800 (PST)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id v20-20020aa78514000000b00592eb6f239fsm6728784pfn.40.2023.02.28.19.24.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 19:24:58 -0800 (PST)
Date:   Wed, 1 Mar 2023 11:24:55 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH iproute2] u32: fix TC_U32_TERMINAL printing
Message-ID: <Y/7FhwxnrPq74RWb@Laptop-X1>
References: <20230228034955.1215122-1-liuhangbin@gmail.com>
 <CAM0EoM=-sSuZbgjEH_KH8WTqTXYSagN0E6JLF+MKBFDSG_z9Hw@mail.gmail.com>
 <Y/7CIiBcHabfFaD6@Laptop-X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/7CIiBcHabfFaD6@Laptop-X1>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 01, 2023 at 11:10:30AM +0800, Hangbin Liu wrote:
> On Tue, Feb 28, 2023 at 05:55:30AM -0500, Jamal Hadi Salim wrote:
> > Hangbin,
> > Can you please run tdc tests on all tc (both for iproute2 and kernel)
> > changes you make and preferably show them in the commit log? If you
> > introduce something new then add a new tdc test case to cover it.
> 
> OK, the patch fixed an issue I found when run tdc u32 test.
> 
> 1..11
> not ok 1 afa9 - Add u32 with source match
> 	Could not match regex pattern. Verify command output:
> filter protocol ip pref 1 u32 chain 0 
> filter protocol ip pref 1 u32 chain 0 fh 800: ht divisor 1 
> filter protocol ip pref 1 u32 chain 0 fh 800::800 order 2048 key ht 800 bkt 0 *flowid 1:1 not_in_hw 
>   match 7f000001/ffffffff at 12
> 	action order 1: gact action pass
> 	 random type none pass val 0
> 	 index 1 ref 1 bind 1
> 
> After the fix, the u32.json test passed
> 
> All test results:
> 
> 1..11
> ok 1 afa9 - Add u32 with source match
> ok 2 6aa7 - Add/Replace u32 with source match and invalid indev
> ok 3 bc4d - Replace valid u32 with source match and invalid indev
> ok 4 648b - Add u32 with custom hash table
> ok 5 6658 - Add/Replace u32 with custom hash table and invalid handle
> ok 6 9d0a - Replace valid u32 with custom hash table and invalid handle
> ok 7 1644 - Add u32 filter that links to a custom hash table
> ok 8 74c2 - Add/Replace u32 filter with invalid hash table id
> ok 9 1fe6 - Replace valid u32 filter with invalid hash table id
> ok 10 0692 - Test u32 sample option, divisor 256
> ok 11 2478 - Test u32 sample option, divisor 16
> 
> 
> When I post the patch, I though this issue is a clear logic one, so I didn't
>  paste the test result.

Should I re-post the patch?

Hangbin
