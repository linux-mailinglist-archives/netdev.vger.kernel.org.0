Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7280E104608
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 22:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbfKTVtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 16:49:10 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:46155 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfKTVtK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 16:49:10 -0500
Received: by mail-lf1-f66.google.com with SMTP id a17so758102lfi.13;
        Wed, 20 Nov 2019 13:49:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IqWvbI85foXB2tMi8++iH5gdZ4/mMi6Zfv03IvvR9P8=;
        b=rx+sqppEQ0sP4Ou4xkvZVXNG2RbISHlRVU5LbZZS/LRBLr9tx6bM2IuY9vsxDz9NMU
         F2ZudgbHLTwGeOuqIoQYO80/M6rDE8MMaAjxZ0bKmZ6Zs7zeC42vvNqbHeOJH1f4PlLz
         PsGwd7j3b1dgGAY4CK+yPRq0rjmoYQrqgnF5JjDxhz7yNqZ5HKm5QACFYIpLm2g1dCsG
         Ee9o5aLmIQmYoCG6pItat+5fZ2bi+gGv2ln0GM3O0IM1lqllC4ZfLSca6YcUQ/vKR82z
         wqUFALdK5DXulO9Obe2lPvxJpMiuJKCFiDF5qqg2Y1KP/a4KwZSYP/Dly0EOkgG2V5WA
         JoYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IqWvbI85foXB2tMi8++iH5gdZ4/mMi6Zfv03IvvR9P8=;
        b=ALQ35/BDJY9dJsKMF/nfPcLO4W7h041T3CA9dI767Rpid6Oq5UpQ7+7Vw2Zj/bF2OC
         juBSiyJXhkiz3wgiR78c8AWlSWTPZ0g5jO7czIAwoxwPsCCt6NpZ28J0D+lDbm1nxPnp
         Sv5xkBmuVy+hWK0jPugnAjXPFLBKPaU+wcYl6H6gv4R+Ge0xmUQ+NKdUtqDBzuAVRe5R
         629hiVLtBLGamzaWpTe01oV6mdTLtRfwUeS7Ie79ogH29LJGBQyUNTdIq33Kt0/Wj5m0
         N/O0AK2dQ8tT41kc0mBnNyFh1qQiNHWhsmaVR0uLXnsiTUBuNmWqTXbPTVUvyQ/u62dQ
         65BQ==
X-Gm-Message-State: APjAAAVeG03fMCMadmdqxV8fIpZf3uVasdxNSnEyxJC/2MKjVZL2OvDl
        KXimAuI24endKJMPlKOK1NYSDyl46IhiVfdArRk=
X-Google-Smtp-Source: APXvYqxJ679uUeT4jErpXKpTt+NoyNlLXhqh0v6We4OpY+B56ogc4PtKTP5b8ryx/+bJzEUYobyXShKyFgL7tg+tH4o=
X-Received: by 2002:ac2:5453:: with SMTP id d19mr4944939lfn.181.1574286547649;
 Wed, 20 Nov 2019 13:49:07 -0800 (PST)
MIME-Version: 1.0
References: <20191120213816.8186-1-jolsa@kernel.org> <8c928ec4-9e43-3e2a-7005-21f40fcca061@iogearbox.net>
In-Reply-To: <8c928ec4-9e43-3e2a-7005-21f40fcca061@iogearbox.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 20 Nov 2019 13:48:56 -0800
Message-ID: <CAADnVQKu-ZgFTaSMH=Q-jMOYYvE32TF2b2hq1=dmDV8wAf18pg@mail.gmail.com>
Subject: Re: [PATCH] bpf: emit audit messages upon successful prog load and unload
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Steve Grubb <sgrubb@redhat.com>,
        David Miller <davem@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@redhat.com>, Jiri Benc <jbenc@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 20, 2019 at 1:46 PM Daniel Borkmann <daniel@iogearbox.net> wrot=
e:
>
> On 11/20/19 10:38 PM, Jiri Olsa wrote:
> > From: Daniel Borkmann <daniel@iogearbox.net>
> >
> > Allow for audit messages to be emitted upon BPF program load and
> > unload for having a timeline of events. The load itself is in
> > syscall context, so additional info about the process initiating
> > the BPF prog creation can be logged and later directly correlated
> > to the unload event.
> >
> > The only info really needed from BPF side is the globally unique
> > prog ID where then audit user space tooling can query / dump all
> > info needed about the specific BPF program right upon load event
> > and enrich the record, thus these changes needed here can be kept
> > small and non-intrusive to the core.
> >
> > Raw example output:
> >
> >    # auditctl -D
> >    # auditctl -a always,exit -F arch=3Dx86_64 -S bpf
> >    # ausearch --start recent -m 1334
> >    [...]
> >    ----
> >    time->Wed Nov 20 12:45:51 2019
> >    type=3DPROCTITLE msg=3Daudit(1574271951.590:8974): proctitle=3D"./te=
st_verifier"
> >    type=3DSYSCALL msg=3Daudit(1574271951.590:8974): arch=3Dc000003e sys=
call=3D321 success=3Dyes exit=3D14 a0=3D5 a1=3D7ffe2d923e80 a2=3D78 a3=3D0 =
items=3D0 ppid=3D742 pid=3D949 auid=3D0 uid=3D0 gid=3D0 euid=3D0 suid=3D0 f=
suid=3D0 egid=3D0 sgid=3D0 fsgid=3D0 tty=3Dpts0 ses=3D2 comm=3D"test_verifi=
er" exe=3D"/root/bpf-next/tools/testing/selftests/bpf/test_verifier" subj=
=3Dunconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=3D(null)
> >    type=3DUNKNOWN[1334] msg=3Daudit(1574271951.590:8974): auid=3D0 uid=
=3D0 gid=3D0 ses=3D2 subj=3Dunconfined_u:unconfined_r:unconfined_t:s0-s0:c0=
.c1023 pid=3D949 comm=3D"test_verifier" exe=3D"/root/bpf-next/tools/testing=
/selftests/bpf/test_verifier" prog-id=3D3260 event=3DLOAD
> >    ----
> >    time->Wed Nov 20 12:45:51 2019
> > type=3DUNKNOWN[1334] msg=3Daudit(1574271951.590:8975): prog-id=3D3260 e=
vent=3DUNLOAD
> >    ----
> >    [...]
> >
> > Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
>
> LGTM, thanks for the rebase!

Applied to bpf-next. Thanks!
