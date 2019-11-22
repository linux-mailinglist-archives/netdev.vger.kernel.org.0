Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 922CF105DA1
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 01:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbfKVAXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 19:23:07 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:42092 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfKVAXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 19:23:07 -0500
Received: by mail-pl1-f194.google.com with SMTP id j12so2329404plt.9;
        Thu, 21 Nov 2019 16:23:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jHfmWhwDjTayWt4cceCFKWOx1QwC3hTKJWD9ujUx5bs=;
        b=oBszi96y6fM/ZiBIdMZ609SCa+TwIwvWlrzIBRDVIDDNlYQPuLq6rN5Svd9+UWzOvz
         GPBasngyqqWhGIaYnK7T3aPingNmU+KNhJmKeaQlDbLjqvsy++wvl6PuxCcUBMMx3lin
         Wwy2VjfHLuLx6Rdu29sfY8D1b93eSmqiWZRT/ahCzYNhC/SXFqmR9xrXentAGwjf7y9Z
         ic/yV3zKq9CCatomoT251SyuBaB7Tcywxsw0KsMti8ezIZR6P9Ulcqob9dpY8eFCLeCu
         sTNmoasKjm2QqDFCYQbtr4DcPOh++4rAdLaq1qbJ6SXDB7CMdFJvRZNt7rbL2+5Uijmq
         abKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jHfmWhwDjTayWt4cceCFKWOx1QwC3hTKJWD9ujUx5bs=;
        b=U0+k/aG/HmNfk+nhDk6bdQlUg2pe0VqgNQ9Jxto7VzsRQMZHD05JlxyeueE6/HMtIR
         3LFFd6ADRjuLD61ZpsPTNW2EGaP53qBFMVlTc4BlDuUnDhkN/uHElGe4iEWi6IlyZ1RQ
         caLS8KUBTjfyY83MYht6wKumRiMyyIzx8dYXxhDvJSVZEfKJDoMFooCxU+vD2KsDmWSS
         LpjOfP32sO3X2vdWJm/BtfFbqLsI29xv3JqI4CoUGCJzA6Q+HbpTAo3KjM2Fb5YC5gnJ
         Jgzbh9ZVouyLuHpx34vh5P48P/oBuvWnELhD0iFUkjVFGCKGVJ7Vr8X4REM7MhLh0AS9
         2YoA==
X-Gm-Message-State: APjAAAV2AbUJn5eAQ3FZEv6xxbawhRToB97Gijf1v08PX7qMXmWvs+bT
        YzcDW6NpQKUJB1X9fQs1xRo=
X-Google-Smtp-Source: APXvYqwIAD2d23t3wkiXDlurwxuEr+VIkFxuxQRG4nhY2AY9BJDYHvJ1pUObdT7cFCAcAuTBD23uCA==
X-Received: by 2002:a17:902:820f:: with SMTP id x15mr11623453pln.125.1574382185655;
        Thu, 21 Nov 2019 16:23:05 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::dee3])
        by smtp.gmail.com with ESMTPSA id em16sm622342pjb.21.2019.11.21.16.23.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Nov 2019 16:23:03 -0800 (PST)
Date:   Thu, 21 Nov 2019 16:22:59 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     linux-audit@redhat.com, Jiri Olsa <jolsa@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Steve Grubb <sgrubb@redhat.com>,
        David Miller <davem@redhat.com>,
        Eric Paris <eparis@redhat.com>, Jiri Benc <jbenc@redhat.com>
Subject: Re: [PATCH] bpf: emit audit messages upon successful prog load and
 unload
Message-ID: <20191122002257.4hgui6pylpkmpwac@ast-mbp.dhcp.thefacebook.com>
References: <20191120213816.8186-1-jolsa@kernel.org>
 <8c928ec4-9e43-3e2a-7005-21f40fcca061@iogearbox.net>
 <CAADnVQKu-ZgFTaSMH=Q-jMOYYvE32TF2b2hq1=dmDV8wAf18pg@mail.gmail.com>
 <CAHC9VhQbQoXacbTCNJPGNzFOv30PwLeiWu4ROQFU46=saTeTNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhQbQoXacbTCNJPGNzFOv30PwLeiWu4ROQFU46=saTeTNQ@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 21, 2019 at 06:41:31PM -0500, Paul Moore wrote:
> On Wed, Nov 20, 2019 at 4:49 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> > On Wed, Nov 20, 2019 at 1:46 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > > On 11/20/19 10:38 PM, Jiri Olsa wrote:
> > > > From: Daniel Borkmann <daniel@iogearbox.net>
> > > >
> > > > Allow for audit messages to be emitted upon BPF program load and
> > > > unload for having a timeline of events. The load itself is in
> > > > syscall context, so additional info about the process initiating
> > > > the BPF prog creation can be logged and later directly correlated
> > > > to the unload event.
> > > >
> > > > The only info really needed from BPF side is the globally unique
> > > > prog ID where then audit user space tooling can query / dump all
> > > > info needed about the specific BPF program right upon load event
> > > > and enrich the record, thus these changes needed here can be kept
> > > > small and non-intrusive to the core.
> > > >
> > > > Raw example output:
> > > >
> > > >    # auditctl -D
> > > >    # auditctl -a always,exit -F arch=x86_64 -S bpf
> > > >    # ausearch --start recent -m 1334
> > > >    [...]
> > > >    ----
> > > >    time->Wed Nov 20 12:45:51 2019
> > > >    type=PROCTITLE msg=audit(1574271951.590:8974): proctitle="./test_verifier"
> > > >    type=SYSCALL msg=audit(1574271951.590:8974): arch=c000003e syscall=321 success=yes exit=14 a0=5 a1=7ffe2d923e80 a2=78 a3=0 items=0 ppid=742 pid=949 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts0 ses=2 comm="test_verifier" exe="/root/bpf-next/tools/testing/selftests/bpf/test_verifier" subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=(null)
> > > >    type=UNKNOWN[1334] msg=audit(1574271951.590:8974): auid=0 uid=0 gid=0 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 pid=949 comm="test_verifier" exe="/root/bpf-next/tools/testing/selftests/bpf/test_verifier" prog-id=3260 event=LOAD
> > > >    ----
> > > >    time->Wed Nov 20 12:45:51 2019
> > > > type=UNKNOWN[1334] msg=audit(1574271951.590:8975): prog-id=3260 event=UNLOAD
> > > >    ----
> > > >    [...]
> > > >
> > > > Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> > > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > >
> > > LGTM, thanks for the rebase!
> >
> > Applied to bpf-next. Thanks!
> 
> [NOTE: added linux-audit to the To/CC line]
> 
> Wait a minute, why was the linux-audit list not CC'd on this?  Why are
> you merging a patch into -next that adds to the uapi definition *and*
> creates a new audit record while we are at -rc8?
> 
> Aside from that I'm concerned that you are relying on audit userspace
> changes that might not be okay; I see the PR below, but I don't see
> any comment on it from Steve (it is his audit userspace).  I also
> don't see a corresponding test added to the audit-testsuite, which is
> a common requirement for new audit functionality (link below).  I'm
> also fairly certain we don't want this new BPF record to look like how
> you've coded it up in bpf_audit_prog(); duplicating the fields with
> audit_log_task() is wrong, you've either already got them via an
> associated record (which you get from passing non-NULL as the first
> parameter to audit_log_start()), or you don't because there is no
> associated syscall/task (which you get from passing NULL as the first
> parameter).  Please revert, un-merge, etc. this patch from bpf-next;
> it should not go into Linus' tree as written.

Sorry I didn't realize there was a disagreement.

Dave, could you please revert it in net-next?

> Audit userspace PR:
> * https://github.com/linux-audit/audit-userspace/pull/104

This PR does not use this new audit. It's doing everything via existing
perf_event notification. My understanding of Jiri's email was that netlink
style is preferred vs perf_event. Did I get it wrong?

