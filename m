Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89EE01BD14F
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 02:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgD2Anp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 20:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726345AbgD2Ano (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 20:43:44 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EA4EC03C1AC;
        Tue, 28 Apr 2020 17:43:43 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id x2so233274pfx.7;
        Tue, 28 Apr 2020 17:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RvqZbBmOCcvhvbgQtK+K4Xthj6qL4q5feZtQD4t/pE8=;
        b=p/GeeMzXhI3N7BU3iPEvsR1OciIWpneXBZIz3qTGp3NQrt0J+NzdaHwixEXVp1Q4+t
         1Q6PrVFlWYynYzR9JitKNSsu+boP2B5i7ZP73uYPnvyObaHEtsD57fyaJuxcf6rV59vN
         /687cmgHkR01//aefnlk2EJ8/+xiiFlIcKzlZwvbkJldUhE/q7R8Zn9yFbQYYvs7k0D+
         LZcFpFkuwDfU3qugBYlppJruZTZklingDLhKmPQw1nNNRx2BmmMOEAIa78zJ6nwVsk4Z
         9DDtRgB8Xz1Sas2UZKc8RTYsrTwF/LH07gTRyEF8SxWCtd3685ptlcL6mcgZIjkQadFw
         WvpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RvqZbBmOCcvhvbgQtK+K4Xthj6qL4q5feZtQD4t/pE8=;
        b=FtZJYpe3RQFamHu1POYYn9GLNCVEaycuIJKWI55Js3aIwTw9aXC5T0l0tOE5ZyRIny
         iL043qt2kXQcP5VVZAuV4nUyreDNRjwxgXRDH0SpMyDjrbs1NGO6EDjQ0BrHZhRkkh/G
         ZLvMWPeq2nz8MsV2jaUVo7o1zSYAeqBUrzT87+Cg3lS2nqfnbDLeA8ZWmawIX+1II7jD
         YMUMCI57eJvMVQSk0DZqOnizCQcVtV26ds2k6dS/fhPNH16aGQoCbk77U4/h5HJEsQ4z
         Yi67xZBzblIFZ3L1GwvgYSoJ9+0cYgjncdJ/CvjGJdRugG6/48UoJ1y7PwN7QNFaesSr
         1nsw==
X-Gm-Message-State: AGi0PuaYU4AptDf23hnUz1F99fbKGyzzr1ZeFScbjqSXkGTAmDMuIRDP
        IwqLrndhqiMDlCoPzMvGsHQ=
X-Google-Smtp-Source: APiQypJaRL6a96aG9HCl4bkVbyOv8ha1yz2qpVVbzwUqURTQAW3iM/5txXWxKTyhdMHz0WpVkWbGUw==
X-Received: by 2002:aa7:948f:: with SMTP id z15mr25237288pfk.129.1588121022733;
        Tue, 28 Apr 2020 17:43:42 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:9061])
        by smtp.gmail.com with ESMTPSA id u3sm15946904pfn.217.2020.04.28.17.43.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 17:43:41 -0700 (PDT)
Date:   Tue, 28 Apr 2020 17:43:40 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Song Liu <songliubraving@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kernel-team@fb.com
Subject: Re: [PATCH v6 bpf-next 3/3] bpf: add selftest for BPF_ENABLE_STATS
Message-ID: <20200429004340.5y2c3rkr64u43sfg@ast-mbp.dhcp.thefacebook.com>
References: <20200429002922.3064669-1-songliubraving@fb.com>
 <20200429002922.3064669-4-songliubraving@fb.com>
 <290a94fb-f3ee-227c-ffa0-66629ce8327a@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <290a94fb-f3ee-227c-ffa0-66629ce8327a@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 05:33:54PM -0700, Yonghong Song wrote:
> 
> 
> On 4/28/20 5:29 PM, Song Liu wrote:
> > Add test for  BPF_ENABLE_STATS, which should enable run_time_ns stats.
> > 
> > ~/selftests/bpf# ./test_progs -t enable_stats  -v
> > test_enable_stats:PASS:skel_open_and_load 0 nsec
> > test_enable_stats:PASS:get_stats_fd 0 nsec
> > test_enable_stats:PASS:attach_raw_tp 0 nsec
> > test_enable_stats:PASS:get_prog_info 0 nsec
> > test_enable_stats:PASS:check_stats_enabled 0 nsec
> > Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED
...
> > +static int val = 1;
> > +
> > +SEC("raw_tracepoint/sys_enter")
> > +int test_enable_stats(void *ctx)
> > +{
> > +	__u32 key = 0;
> > +	__u64 *val;
> 
> The above two declarations (key/val) are not needed,
> esp. "val" is shadowing.
> Maybe the maintainer can fix it up before merging
> if there is no other changes for this patch set.
> 
> > +
> > +	val += 1;

I think 'PASSED' above is quite misleading.
How it can pass when it wasn't incremented?
The user space test_enable_stats() doesn't check this val.
Please fix.

usleep(1000); needs an explanation as well.
Why 1000 ? It should work with any syscall. like getpid ?
and with value 1 ?
Since there is bpf_obj_get_info_by_fd() that usleep()
is unnecessary. What am I missing?
