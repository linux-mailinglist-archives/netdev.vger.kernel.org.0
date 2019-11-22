Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31B84105DC2
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 01:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbfKVAgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 19:36:44 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:33938 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbfKVAgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 19:36:44 -0500
Received: by mail-lj1-f195.google.com with SMTP id 139so5348672ljf.1
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 16:36:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ssYpMX2MrYa5cZrb9J08z0A37+V+3LLndprxjHmeMv0=;
        b=K/3dOLU3Whw6nOt5Wq/zQdNwEQK727xZkW/ZPbL3ZJh54vIMry6PwQDxOva6lepGk/
         IyVWjoafGKtta+CYlDYfg+3P2HTzLiiVXumGMbcwtEsgF8meuJLvA8IxCv8vNYxf1zhy
         m/hLDiHJ+sTOsNxmYl5nDJKkGVYw786NrT8Kp/SYCqzxHMJZCxnA9DLE1OuS/uGC5KUA
         mzLC/2W0mMsTC7E4MeylOY9D8RoiryFRxDoNW47a4pVdLpKd8cvD+z3wTyViaOFK/TUC
         6ROCTQ6H76ftwabq3xKRxRWmRkdeodjNiZgUlGFy9uIAMSd5e4Ja0Pp83ka3noEHHRQt
         ErLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ssYpMX2MrYa5cZrb9J08z0A37+V+3LLndprxjHmeMv0=;
        b=C+ALwXvIhDTsmk4EoXR6MU7DNJNDF8GolpLwJYD2DRTAcqFiuBSg/cevbyYJWD5aLW
         iIkhjZZY54J3hnPm45++lRwcd5JppLQ9RHQfRJ0TpJPRoPD4Ew6/RDAnk6vXcDwPRIpb
         +HMXFSMiuZqTVJZZntemzVbumlT7ZlBJVGGPdLzhLCaitg/bSguq9/W74U8WU1LTFjwB
         W0dSXCdgVRETxKWblaBb07bl//8AJS6aWaVciQtcY4SqPwXDnLYUBBJBMMR1ezql1uJo
         vkrHwHB2RNTUzwzhyNHIQ9sHkoMnTZaRRHy3V63JQF74MVMcT6VozJj5FsKuu6HhjrVW
         ZdLQ==
X-Gm-Message-State: APjAAAWh6joQ2iQcTtW4kM9R+49S/XNlrMf0tMImq7FQe/i+Ays3sPDa
        aPsJ/Dh5flJywBUlmDk2722049tUohx199dQbDLi
X-Google-Smtp-Source: APXvYqyK0IC3Ufsh7Ivd3NjOoGIvpal8xESx2JMA5UpxyGvFS3bv20z5yuxOK9i+Cl0c7qivRA13cE2yY7ruALWrky4=
X-Received: by 2002:a2e:85d5:: with SMTP id h21mr9851090ljj.243.1574383000344;
 Thu, 21 Nov 2019 16:36:40 -0800 (PST)
MIME-Version: 1.0
References: <20191120213816.8186-1-jolsa@kernel.org> <8c928ec4-9e43-3e2a-7005-21f40fcca061@iogearbox.net>
 <CAADnVQKu-ZgFTaSMH=Q-jMOYYvE32TF2b2hq1=dmDV8wAf18pg@mail.gmail.com>
 <CAHC9VhQbQoXacbTCNJPGNzFOv30PwLeiWu4ROQFU46=saTeTNQ@mail.gmail.com> <20191122002257.4hgui6pylpkmpwac@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191122002257.4hgui6pylpkmpwac@ast-mbp.dhcp.thefacebook.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 21 Nov 2019 19:36:29 -0500
Message-ID: <CAHC9VhRihMi_d-p+ieXyuVBcGMs80SkypVxF4gLE_s45GKP0dg@mail.gmail.com>
Subject: Re: [PATCH] bpf: emit audit messages upon successful prog load and unload
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 21, 2019 at 7:23 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
> On Thu, Nov 21, 2019 at 06:41:31PM -0500, Paul Moore wrote:
> > On Wed, Nov 20, 2019 at 4:49 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > > On Wed, Nov 20, 2019 at 1:46 PM Daniel Borkmann <daniel@iogearbox.net=
> wrote:
> > > > On 11/20/19 10:38 PM, Jiri Olsa wrote:
> > > > > From: Daniel Borkmann <daniel@iogearbox.net>
> > > > >
> > > > > Allow for audit messages to be emitted upon BPF program load and
> > > > > unload for having a timeline of events. The load itself is in
> > > > > syscall context, so additional info about the process initiating
> > > > > the BPF prog creation can be logged and later directly correlated
> > > > > to the unload event.
> > > > >
> > > > > The only info really needed from BPF side is the globally unique
> > > > > prog ID where then audit user space tooling can query / dump all
> > > > > info needed about the specific BPF program right upon load event
> > > > > and enrich the record, thus these changes needed here can be kept
> > > > > small and non-intrusive to the core.
> > > > >
> > > > > Raw example output:
> > > > >
> > > > >    # auditctl -D
> > > > >    # auditctl -a always,exit -F arch=3Dx86_64 -S bpf
> > > > >    # ausearch --start recent -m 1334
> > > > >    [...]
> > > > >    ----
> > > > >    time->Wed Nov 20 12:45:51 2019
> > > > >    type=3DPROCTITLE msg=3Daudit(1574271951.590:8974): proctitle=
=3D"./test_verifier"
> > > > >    type=3DSYSCALL msg=3Daudit(1574271951.590:8974): arch=3Dc00000=
3e syscall=3D321 success=3Dyes exit=3D14 a0=3D5 a1=3D7ffe2d923e80 a2=3D78 a=
3=3D0 items=3D0 ppid=3D742 pid=3D949 auid=3D0 uid=3D0 gid=3D0 euid=3D0 suid=
=3D0 fsuid=3D0 egid=3D0 sgid=3D0 fsgid=3D0 tty=3Dpts0 ses=3D2 comm=3D"test_=
verifier" exe=3D"/root/bpf-next/tools/testing/selftests/bpf/test_verifier" =
subj=3Dunconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=3D(null)
> > > > >    type=3DUNKNOWN[1334] msg=3Daudit(1574271951.590:8974): auid=3D=
0 uid=3D0 gid=3D0 ses=3D2 subj=3Dunconfined_u:unconfined_r:unconfined_t:s0-=
s0:c0.c1023 pid=3D949 comm=3D"test_verifier" exe=3D"/root/bpf-next/tools/te=
sting/selftests/bpf/test_verifier" prog-id=3D3260 event=3DLOAD
> > > > >    ----
> > > > >    time->Wed Nov 20 12:45:51 2019
> > > > > type=3DUNKNOWN[1334] msg=3Daudit(1574271951.590:8975): prog-id=3D=
3260 event=3DUNLOAD
> > > > >    ----
> > > > >    [...]
> > > > >
> > > > > Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> > > > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > >
> > > > LGTM, thanks for the rebase!
> > >
> > > Applied to bpf-next. Thanks!
> >
> > [NOTE: added linux-audit to the To/CC line]
> >
> > Wait a minute, why was the linux-audit list not CC'd on this?  Why are
> > you merging a patch into -next that adds to the uapi definition *and*
> > creates a new audit record while we are at -rc8?
> >
> > Aside from that I'm concerned that you are relying on audit userspace
> > changes that might not be okay; I see the PR below, but I don't see
> > any comment on it from Steve (it is his audit userspace).  I also
> > don't see a corresponding test added to the audit-testsuite, which is
> > a common requirement for new audit functionality (link below).  I'm
> > also fairly certain we don't want this new BPF record to look like how
> > you've coded it up in bpf_audit_prog(); duplicating the fields with
> > audit_log_task() is wrong, you've either already got them via an
> > associated record (which you get from passing non-NULL as the first
> > parameter to audit_log_start()), or you don't because there is no
> > associated syscall/task (which you get from passing NULL as the first
> > parameter).  Please revert, un-merge, etc. this patch from bpf-next;
> > it should not go into Linus' tree as written.
>
> Sorry I didn't realize there was a disagreement.
>
> Dave, could you please revert it in net-next?
>
> > Audit userspace PR:
> > * https://github.com/linux-audit/audit-userspace/pull/104
>
> This PR does not use this new audit. It's doing everything via existing
> perf_event notification. My understanding of Jiri's email was that netlin=
k
> style is preferred vs perf_event. Did I get it wrong?

Perhaps confusion on my part regarding the audit-userspace PR.  The
commit description mentioned the audit userspace (the daemon most
likely) fetching additional info about the BPF program and this was
the only outstanding audit-userspace PR that had any mention of BPF.

However, getting back to netlink vs perf_event, if you want to
generate an audit record, it should happen via the audit subsystem
(and go up to the audit daemon via netlink).

--=20
paul moore
www.paul-moore.com
