Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB238105DCA
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 01:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbfKVAme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 19:42:34 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:40816 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfKVAmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 19:42:33 -0500
Received: by mail-lj1-f194.google.com with SMTP id q2so5328013ljg.7
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 16:42:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YzYTuPfhNF+6hAQ8DRw50vXORP/WZWzxXXw+iGKNMpw=;
        b=Ek1ZOoMsHvCHSH/GLQWhU47W8IhazdULoSW9K4cQTjFSbZjnS8Cl6Sy7D8qQ0ZQy5G
         WHpqtk9u63+dG9f5EdRHJA6muPZT/JiVAkkQmsYxfKHWZm5GHt+OHWRfAn40pCUGNplq
         mpqiSDMQFc4znojygS6YXnVVf+mX6LBpupzaH1Ig8s0xbFxyVtUzxINylWAdXaXFHovz
         xIqvHTwxmSGuY/5nCGyyBjHJqzFHsZ4kPs/iGjZwaClg8+qqxKOFTgbOv5sq9NherYeU
         OgKJX3RpekIekRM+C0GpWFtEkYBwaQrjNJsvXSxeKRp61mW8560D8r2Tr5vKv12HBHOC
         fAVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YzYTuPfhNF+6hAQ8DRw50vXORP/WZWzxXXw+iGKNMpw=;
        b=s/jd4n33Wx80qwFbaZcH5Vr7wzgu2vV2fE3ht01iE1AqmOzbvn1ZCHaDB6dm2oSLu1
         qm0mIgJQrXprNPFZ/n0Th83lggCHuZWDye3y6dCUKM5P0mV39kdgDZqV8moXP+5OhOuo
         o6BqWRj9DWjCIYmuy6CARpVgvaLHETe3GPFGON9Mo9+X2xf8Nw8CWjWNViicNMri0HVK
         riij0XBq30Z3EpVm7jWExRSZ1+edXFYKV+2Io2s3jq8mjW4XgIL0iCf3Mm/CrXPjN+MH
         f+putsG0JaVV4E19EIbb1jFjzMiJOYzkNtrGoqr0rNGkoARnJuGxKlOK7fbsX+gViGVE
         IZvg==
X-Gm-Message-State: APjAAAWQW/r6PWjkv+T6V+Wca0gtgJDI6WAPVHQYrHd3JB7rDHIAbDFl
        kaILttwwA+hbb2edecigi4UJZ6V+lpJjPHUAcF6o
X-Google-Smtp-Source: APXvYqxHINm8pj5hHObN5FfogVwDQsXbF6iabxRdRu8W/YON+dxEFj3FPP1741tdwyk7vPn0EjxORYxieY+pfttr9EM=
X-Received: by 2002:a2e:970e:: with SMTP id r14mr9681041lji.57.1574383349234;
 Thu, 21 Nov 2019 16:42:29 -0800 (PST)
MIME-Version: 1.0
References: <20191120213816.8186-1-jolsa@kernel.org> <8c928ec4-9e43-3e2a-7005-21f40fcca061@iogearbox.net>
 <CAADnVQKu-ZgFTaSMH=Q-jMOYYvE32TF2b2hq1=dmDV8wAf18pg@mail.gmail.com>
 <CAHC9VhQbQoXacbTCNJPGNzFOv30PwLeiWu4ROQFU46=saTeTNQ@mail.gmail.com> <b8a79ac0-a7d3-8d7b-1e31-33f477b30503@iogearbox.net>
In-Reply-To: <b8a79ac0-a7d3-8d7b-1e31-33f477b30503@iogearbox.net>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 21 Nov 2019 19:42:18 -0500
Message-ID: <CAHC9VhR7_n9MpoNx8A8QWzNMOZwMG6H6xegdYt5qxAf-xbwXCA@mail.gmail.com>
Subject: Re: [PATCH] bpf: emit audit messages upon successful prog load and unload
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        linux-audit@redhat.com, Jiri Olsa <jolsa@kernel.org>,
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

On Thu, Nov 21, 2019 at 7:25 PM Daniel Borkmann <daniel@iogearbox.net> wrot=
e:
> On 11/22/19 12:41 AM, Paul Moore wrote:
> > On Wed, Nov 20, 2019 at 4:49 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> >> On Wed, Nov 20, 2019 at 1:46 PM Daniel Borkmann <daniel@iogearbox.net>=
 wrote:
> >>> On 11/20/19 10:38 PM, Jiri Olsa wrote:
> >>>> From: Daniel Borkmann <daniel@iogearbox.net>
> >>>>
> >>>> Allow for audit messages to be emitted upon BPF program load and
> >>>> unload for having a timeline of events. The load itself is in
> >>>> syscall context, so additional info about the process initiating
> >>>> the BPF prog creation can be logged and later directly correlated
> >>>> to the unload event.
> >>>>
> >>>> The only info really needed from BPF side is the globally unique
> >>>> prog ID where then audit user space tooling can query / dump all
> >>>> info needed about the specific BPF program right upon load event
> >>>> and enrich the record, thus these changes needed here can be kept
> >>>> small and non-intrusive to the core.
> >>>>
> >>>> Raw example output:
> >>>>
> >>>>     # auditctl -D
> >>>>     # auditctl -a always,exit -F arch=3Dx86_64 -S bpf
> >>>>     # ausearch --start recent -m 1334
> >>>>     [...]
> >>>>     ----
> >>>>     time->Wed Nov 20 12:45:51 2019
> >>>>     type=3DPROCTITLE msg=3Daudit(1574271951.590:8974): proctitle=3D"=
./test_verifier"
> >>>>     type=3DSYSCALL msg=3Daudit(1574271951.590:8974): arch=3Dc000003e=
 syscall=3D321 success=3Dyes exit=3D14 a0=3D5 a1=3D7ffe2d923e80 a2=3D78 a3=
=3D0 items=3D0 ppid=3D742 pid=3D949 auid=3D0 uid=3D0 gid=3D0 euid=3D0 suid=
=3D0 fsuid=3D0 egid=3D0 sgid=3D0 fsgid=3D0 tty=3Dpts0 ses=3D2 comm=3D"test_=
verifier" exe=3D"/root/bpf-next/tools/testing/selftests/bpf/test_verifier" =
subj=3Dunconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=3D(null)
> >>>>     type=3DUNKNOWN[1334] msg=3Daudit(1574271951.590:8974): auid=3D0 =
uid=3D0 gid=3D0 ses=3D2 subj=3Dunconfined_u:unconfined_r:unconfined_t:s0-s0=
:c0.c1023 pid=3D949 comm=3D"test_verifier" exe=3D"/root/bpf-next/tools/test=
ing/selftests/bpf/test_verifier" prog-id=3D3260 event=3DLOAD
> >>>>     ----
> >>>>     time->Wed Nov 20 12:45:51 2019
> >>>> type=3DUNKNOWN[1334] msg=3Daudit(1574271951.590:8975): prog-id=3D326=
0 event=3DUNLOAD
> >>>>     ----
> >>>>     [...]
> >>>>
> >>>> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> >>>> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> >>>
> >>> LGTM, thanks for the rebase!
> >>
> >> Applied to bpf-next. Thanks!
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
> Fair enough, up to you guys. My impression was that this is mainly coming
> from RHEL use case [0] and given that the original patch was back in Oct
> 2018 [1] that you've sorted it out by now RH internally and agreed to pro=
ceed
> with this patch for BPF given the rebase + resend ... seems not then. :(

For the record, I am not currently employed by RH and thus not part of
any RH internal discussions.  Although, even when I was, I would still
bristle at the idea of audit patches going in without CC'ing the audit
list and getting an ACK from the audit folks.  Internal discussions
within a company are fine, but the final discussion and debate should
happen on the public list.

> Given the change is mostly trivial, are there any major objections for Ji=
ri
> to follow-up? Otherwise worst case probably easier to revert in net-next.

See my previous response for more info.  However, for starters the use
of audit_log_task() looks like the wrong thing to do here.  I also
want to see a test for our test suite so we can catch when someone
invariably breaks this in future and fix it.

>    [0] slide 11, https://linuxplumbersconf.org/event/4/contributions/460/=
attachments/244/426/xdp-distro-view.pdf
>    [1] https://lore.kernel.org/netdev/20181004135038.2876-1-daniel@iogear=
box.net/

--=20
paul moore
www.paul-moore.com
