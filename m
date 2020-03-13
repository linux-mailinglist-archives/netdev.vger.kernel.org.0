Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A95E18472E
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 13:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgCMMsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 08:48:09 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:38360 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbgCMMsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 08:48:09 -0400
Received: by mail-qt1-f196.google.com with SMTP id e20so7323260qto.5;
        Fri, 13 Mar 2020 05:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4Wtym2YpAZl93It7kAZtFwQHk1xaqjgeb6Ayg9t19Y8=;
        b=hP3abGFm6IO3Gax7hTipVqI4ommOPDEojXy+lJDXZtoOYohtpeZI5zKln5lKv4Gr+J
         vHJEdpfBF92MaOInJoUSvxhMaJmhFeYfJNVgxwQoKKtsNKPF8rYYs7s8eBtdOulXJ/5n
         6LgDn1NPaQ5IRDEoGcAh7DhgpKcuHjGIHVaBSem/I7M3RbLdyqJlDNMZlMx5FQpUgRrx
         8EbGFD9IRDCqIbdbMmomh9BScdHrWEtnCZYS+HYRhEnYRnbglrnidI1E/WBt+8xPmCpG
         WtroHqURvBzbTSrbUF5r3F7gqNm4ZQnyIiJRr1qOazlrkxgO5gNFDw+jwCWVNyUE9Bhb
         9tlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4Wtym2YpAZl93It7kAZtFwQHk1xaqjgeb6Ayg9t19Y8=;
        b=ZfprLtTpC2aBj/TyryzC4ic2y8so2B/1kiCuNG4WuKxd3aBBz4l6AUUkBSgQc+1BVo
         esd0UMiM6v2xYeQ7fncLC8PHBjPqmO3XP7lK7x9/CFpaa3FV03Te+1TM4SxYiJAGHjIh
         J1EatheI+2rJnuVBBKfjZ0ZmxwWRHfH9ZDbeQ5ZWpFf6FFHil3oeDhb4TNQPZ+Xdb2ZP
         vGdShQkioKz8gYulbS5gLgoOvFvjv+0tXSO3Furr0rvTfYFcVj9f5Nm2ppNvPEHEZTLm
         B42lFy1mpNOdtSbClmTlWpsoIzIjfXDgaX9QrV2mJGtb6v8E2AfxKzo3AzYxZ3PI2sH5
         dXfw==
X-Gm-Message-State: ANhLgQ1QiJhZ6Q2XqQwD0f5Dyxan9eU/miSmWtA2pX6Z4oyejG2dtMFZ
        8Cy7NipI86SQI0utVDoCims=
X-Google-Smtp-Source: ADFU+vsmR6tgaz/whYXSoJ6nLmlZTE1LKH95FJdyBqxQMM81A8OiPpLua9lXuIbQeXcCnqUnBThEqg==
X-Received: by 2002:ac8:1114:: with SMTP id c20mr11913640qtj.126.1584103687781;
        Fri, 13 Mar 2020 05:48:07 -0700 (PDT)
Received: from bpf-dev (pc-184-104-160-190.cm.vtr.net. [190.160.104.184])
        by smtp.gmail.com with ESMTPSA id h25sm8721532qkg.87.2020.03.13.05.48.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 05:48:07 -0700 (PDT)
Date:   Fri, 13 Mar 2020 09:48:03 -0300
From:   Carlos Antonio Neira Bustos <cneirabustos@gmail.com>
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH v17 0/3] BPF: New helper to obtain namespace data from
 current task
Message-ID: <20200313124802.GB1309@bpf-dev>
References: <20200304204157.58695-1-cneirabustos@gmail.com>
 <CAADnVQL4GR2kOoiLE0aTorvYzTPWrOCV4yKMh1BasYTVHkKxcg@mail.gmail.com>
 <33447490-7fa2-f56d-3622-d61c9c2046e5@isovalent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33447490-7fa2-f56d-3622-d61c9c2046e5@isovalent.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 13, 2020 at 10:39:41AM +0000, Quentin Monnet wrote:
> 2020-03-12 17:45 UTC-0700 ~ Alexei Starovoitov <alexei.starovoitov@gmail.com>
> > On Wed, Mar 4, 2020 at 12:42 PM Carlos Neira <cneirabustos@gmail.com> wrote:
> >>
> >> Currently bpf_get_current_pid_tgid(), is used to do pid filtering in bcc's
> >> scripts but this helper returns the pid as seen by the root namespace which is
> >> fine when a bcc script is not executed inside a container.
> >> When the process of interest is inside a container, pid filtering will not work
> >> if bpf_get_current_pid_tgid() is used.
> >> This helper addresses this limitation returning the pid as it's seen by the current
> >> namespace where the script is executing.
> >>
> >> In the future different pid_ns files may belong to different devices, according to the
> >> discussion between Eric Biederman and Yonghong in 2017 Linux plumbers conference.
> >> To address that situation the helper requires inum and dev_t from /proc/self/ns/pid.
> >> This helper has the same use cases as bpf_get_current_pid_tgid() as it can be
> >> used to do pid filtering even inside a container.
> > 
> > Applied. Thanks.
> > There was one spurious trailing whitespace that I fixed in patch 3
> > and missing .gitignore update for test_current_pid_tgid_new_ns.
> > Could you please follow up with another patch to fold
> > test_current_pid_tgid_new_ns into test_progs.
> > I'd really like to consolidate all tests into single binary.
> > 
> 
> Compiling bpftool (with libbpf now relying on bpf_helper_defs.h
> generated from helpers documentation), I observe the following
> warning:
> 
>     .output/bpf_helper_defs.h:2834:72: warning: declaration of 'struct bpf_pidns_info' will not be visible outside of this function [-Wvisibility]
>     static int (*bpf_get_ns_current_pid_tgid)(__u64 dev, __u64 ino, struct bpf_pidns_info *nsdata, __u32 size) = (void *) 120;
> 
> Would it be possible to address this as part of the follow-up too,
> please? I think the fix would be to add "struct bpf_pidns_info"
> to type_fds (I see it was added to known_types already) in
> scripts/bpf_helpers_doc.py.
> 
> Thanks,
> Quentin

Thanks for checking this out Quentin,
I'm sorry I'll start working on this follow-up patch to fix this.

Bests
