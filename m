Return-Path: <netdev+bounces-9386-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AD4A728A6D
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 23:52:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6F4B31C21012
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 21:52:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9AE534D69;
	Thu,  8 Jun 2023 21:52:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD47B7464
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 21:52:27 +0000 (UTC)
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49F87272A
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 14:52:25 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-256419413a3so80915a91.0
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 14:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686261144; x=1688853144;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o2/mJuKKwEzhj5rP6Nndnt1rHMLpGrH4IMcX/CyKnpg=;
        b=sevwABcEzLU1Wktao7zYoqTuiUGAir1CywEDFI+mHvMRkj1X9TeS5CodTc3O+ilrKx
         VB/NXx29b7vuzGA+Ye8ju31O7Uh4IyuBsDHhWo2uw34tdFrEbHYDTtex/4Jtc5x072vO
         q5+lhPtLk1GGlSvnZlVEZUx7Bw6cccDp+5w+B1xpJmwNlW5zEI2+Q5r2Bd1lyqIQU16q
         ZoHXnYFUbtEVZ0xR7ofiK5M/4VIav2Hk1boWR6C2uuTEdtVjLQ4bugK8aemBucQXBy5c
         wVabmFS9oYEuTI2jcxU3pxPfRM3TTjzLX88ic4fw2R8rVLwscualuW88ZtI2Sm0q33pL
         cGGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686261144; x=1688853144;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=o2/mJuKKwEzhj5rP6Nndnt1rHMLpGrH4IMcX/CyKnpg=;
        b=H1HmmBOwbZfuJGYYLm5o8jzjPYSZTkDh6coHohTotHuB7aCpMHwBgfXP9zDOwdwA0m
         xkDTo/Lw69dpSCc8VUNbF959vYTXBsqIwnI0VoxIKZNK/48NzpHnuTuba4gs1B6b815k
         oTyR/lkdH9EVHcB+Zhj0bnjUh+gH3WKuOTUw84mSPA1G3gnn7Z+lPJAbbIDd223Hz5/2
         YPlW2VZShr+Hzl0oLWLzLGW6zq1485nZCpBAYP1gukxsQ2U/qql65hST2+q9w8YrsIFR
         HKVtRq5ObmT1+U8xRZdTgwx35fGvW9xPeF0TmxocVY1+7yhGS+5QkXJglyY4BI2cnPa9
         Ck7g==
X-Gm-Message-State: AC+VfDzPgVsQCNrbh4s+aai/mjNTmeqrP7ym6M+Wh9p1EXFx7Sg3WgyQ
	W/diRZj2r4khuviSzRpabI/VY+8=
X-Google-Smtp-Source: ACHHUZ6vBmpOEzQNHoG4jnJnkJm8UPc2vYfWips8WYvBpMLfm1/lvF0dogmGpAW6J3CEF/Vbfyj3SCk=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:90a:6342:b0:253:3b5f:fde1 with SMTP id
 v2-20020a17090a634200b002533b5ffde1mr801752pjs.1.1686261144590; Thu, 08 Jun
 2023 14:52:24 -0700 (PDT)
Date: Thu, 8 Jun 2023 14:52:23 -0700
In-Reply-To: <CAEf4BzbEf+U53UY6o+g5OZ6rg+T65_Aou4Nvrdbo-8sAjmdJmA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230607192625.22641-1-daniel@iogearbox.net> <20230607192625.22641-2-daniel@iogearbox.net>
 <ZIIOr1zvdRNTFKR7@google.com> <CAEf4BzbEf+U53UY6o+g5OZ6rg+T65_Aou4Nvrdbo-8sAjmdJmA@mail.gmail.com>
Message-ID: <ZIJNlxCX4ksBFFwN@google.com>
Subject: Re: [PATCH bpf-next v2 1/7] bpf: Add generic attach/detach/query API
 for multi-progs
From: Stanislav Fomichev <sdf@google.com>
To: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>, ast@kernel.org, andrii@kernel.org, 
	martin.lau@linux.dev, razor@blackwall.org, john.fastabend@gmail.com, 
	kuba@kernel.org, dxu@dxuuu.xyz, joe@cilium.io, toke@kernel.org, 
	davem@davemloft.net, bpf@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 06/08, Andrii Nakryiko wrote:
> On Thu, Jun 8, 2023 at 10:24=E2=80=AFAM Stanislav Fomichev <sdf@google.co=
m> wrote:
> >
> > On 06/07, Daniel Borkmann wrote:
> > > This adds a generic layer called bpf_mprog which can be reused by dif=
ferent
> > > attachment layers to enable multi-program attachment and dependency r=
esolution.
> > > In-kernel users of the bpf_mprog don't need to care about the depende=
ncy
> > > resolution internals, they can just consume it with few API calls.
> > >
> > > The initial idea of having a generic API sparked out of discussion [0=
] from an
> > > earlier revision of this work where tc's priority was reused and expo=
sed via
> > > BPF uapi as a way to coordinate dependencies among tc BPF programs, s=
imilar
> > > as-is for classic tc BPF. The feedback was that priority provides a b=
ad user
> > > experience and is hard to use [1], e.g.:
> > >
> > >   I cannot help but feel that priority logic copy-paste from old tc, =
netfilter
> > >   and friends is done because "that's how things were done in the pas=
t". [...]
> > >   Priority gets exposed everywhere in uapi all the way to bpftool whe=
n it's
> > >   right there for users to understand. And that's the main problem wi=
th it.
> > >
> > >   The user don't want to and don't need to be aware of it, but uapi f=
orces them
> > >   to pick the priority. [...] Your cover letter [0] example proves th=
at in
> > >   real life different service pick the same priority. They simply don=
't know
> > >   any better. Priority is an unnecessary magic that apps _have_ to pi=
ck, so
> > >   they just copy-paste and everyone ends up using the same.
> > >
> > > The course of the discussion showed more and more the need for a gene=
ric,
> > > reusable API where the "same look and feel" can be applied for variou=
s other
> > > program types beyond just tc BPF, for example XDP today does not have=
 multi-
> > > program support in kernel, but also there was interest around this AP=
I for
> > > improving management of cgroup program types. Such common multi-progr=
am
> > > management concept is useful for BPF management daemons or user space=
 BPF
> > > applications coordinating about their attachments.
> > >
> > > Both from Cilium and Meta side [2], we've collected the following req=
uirements
> > > for a generic attach/detach/query API for multi-progs which has been =
implemented
> > > as part of this work:
> > >
> > >   - Support prog-based attach/detach and link API
> > >   - Dependency directives (can also be combined):
> > >     - BPF_F_{BEFORE,AFTER} with relative_{fd,id} which can be {prog,l=
ink,none}
> > >       - BPF_F_ID flag as {fd,id} toggle
> > >       - BPF_F_LINK flag as {prog,link} toggle
> > >       - If relative_{fd,id} is none, then BPF_F_BEFORE will just prep=
end, and
> > >         BPF_F_AFTER will just append for the case of attaching
> > >       - Enforced only at attach time
> > >     - BPF_F_{FIRST,LAST}
> > >       - Enforced throughout the bpf_mprog state's lifetime
> > >       - Admin override possible (e.g. link detach, prog-based BPF_F_R=
EPLACE)
> > >   - Internal revision counter and optionally being able to pass expec=
ted_revision
> > >   - User space daemon can query current state with revision, and pass=
 it along
> > >     for attachment to assert current state before doing updates
> > >   - Query also gets extension for link_ids array and link_attach_flag=
s:
> > >     - prog_ids are always filled with program IDs
> > >     - link_ids are filled with link IDs when link was used, otherwise=
 0
> > >     - {prog,link}_attach_flags for holding {prog,link}-specific flags
> > >   - Must be easy to integrate/reuse for in-kernel users
> > >
> > > The uapi-side changes needed for supporting bpf_mprog are rather mini=
mal,
> > > consisting of the additions of the attachment flags, revision counter=
, and
> > > expanding existing union with relative_{fd,id} member.
> > >
> > > The bpf_mprog framework consists of an bpf_mprog_entry object which h=
olds
> > > an array of bpf_mprog_fp (fast-path structure) and bpf_mprog_cp (cont=
rol-path
> > > structure). Both have been separated, so that fast-path gets efficien=
t packing
> > > of bpf_prog pointers for maximum cache efficieny. Also, array has bee=
n chosen
> > > instead of linked list or other structures to remove unnecessary indi=
rections
> > > for a fast point-to-entry in tc for BPF. The bpf_mprog_entry comes as=
 a pair
> > > via bpf_mprog_bundle so that in case of updates the peer bpf_mprog_en=
try
> > > is populated and then just swapped which avoids additional allocation=
s that
> > > could otherwise fail, for example, in detach case. bpf_mprog_{fp,cp} =
arrays are
> > > currently static, but they could be converted to dynamic allocation i=
f necessary
> > > at a point in future. Locking is deferred to the in-kernel user of bp=
f_mprog,
> > > for example, in case of tcx which uses this API in the next patch, it=
 piggy-
> > > backs on rtnl. The nitty-gritty details are in the bpf_mprog_{replace=
,head_tail,
> > > add,del} implementation and an extensive test suite for checking all =
aspects
> > > of this API for prog-based attach/detach and link API as BPF selftest=
s in
> > > this series.
> > >
> > > Kudos also to Andrii Nakryiko for API discussions wrt Meta's BPF mana=
gement daemon.
> > >
> > >   [0] https://lore.kernel.org/bpf/20221004231143.19190-1-daniel@iogea=
rbox.net/
> > >   [1] https://lore.kernel.org/bpf/CAADnVQ+gEY3FjCR=3D+DmjDR4gp5bOYZUF=
JQXj4agKFHT9CQPZBw@mail.gmail.com
> > >   [2] http://vger.kernel.org/bpfconf2023_material/tcx_meta_netdev_bor=
kmann.pdf
> > >
> > > Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> > > ---
> > >  MAINTAINERS                    |   1 +
> > >  include/linux/bpf_mprog.h      | 245 +++++++++++++++++
> > >  include/uapi/linux/bpf.h       |  37 ++-
> > >  kernel/bpf/Makefile            |   2 +-
> > >  kernel/bpf/mprog.c             | 476 +++++++++++++++++++++++++++++++=
++
> > >  tools/include/uapi/linux/bpf.h |  37 ++-
> > >  6 files changed, 781 insertions(+), 17 deletions(-)
> > >  create mode 100644 include/linux/bpf_mprog.h
> > >  create mode 100644 kernel/bpf/mprog.c
> > >
>=20
> [...]
>=20
> > > diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linu=
x/bpf.h
> > > index a7b5e91dd768..207f8a37b327 100644
> > > --- a/tools/include/uapi/linux/bpf.h
> > > +++ b/tools/include/uapi/linux/bpf.h
> > > @@ -1102,7 +1102,14 @@ enum bpf_link_type {
> > >   */
> > >  #define BPF_F_ALLOW_OVERRIDE (1U << 0)
> > >  #define BPF_F_ALLOW_MULTI    (1U << 1)
> > > +/* Generic attachment flags. */
> > >  #define BPF_F_REPLACE                (1U << 2)
> > > +#define BPF_F_BEFORE         (1U << 3)
> > > +#define BPF_F_AFTER          (1U << 4)
> >
> > [..]
> >
> > > +#define BPF_F_FIRST          (1U << 5)
> > > +#define BPF_F_LAST           (1U << 6)
> >
> > I'm still not sure whether the hard semantics of first/last is really
> > useful. My worry is that some prog will just use BPF_F_FIRST which
> > would prevent the rest of the users.. (starting with only
> > F_BEFORE/F_AFTER feels 'safer'; we can iterate later on if we really
> > need first/laste).
>=20
> Without FIRST/LAST some scenarios cannot be guaranteed to be safely
> implemented. E.g., if I have some hard audit requirements and I need
> to guarantee that my program runs first and observes each event, I'll
> enforce BPF_F_FIRST when attaching it. And if that attachment fails,
> then server setup is broken and my application cannot function.
>=20
> In a setup where we expect multiple applications to co-exist, it
> should be a rule that no one is using FIRST/LAST (unless it's
> absolutely required). And if someone doesn't comply, then that's a bug
> and has to be reported to application owners.
>=20
> But it's not up to the kernel to enforce this cooperation by
> disallowing FIRST/LAST semantics, because that semantics is critical
> for some applications, IMO.

Maybe that's something that should be done by some other mechanism?
(and as a follow up, if needed) Something akin to what Toke
mentioned with another program doing sorting or similar.

Otherwise, those first/last are just plain simple old priority bands;
only we have two now, not u16.

I'm mostly coming from the observability point: imagine I have my fancy
tc_ingress_tcpdump program that I want to attach as a first program to debu=
g
some issue, but it won't work because there is already a 'first' program
installed.. Or the assumption that I'd do F_REPLACE | F_FIRST ?

> > But if everyone besides myself is on board with first/last, maybe at le=
ast
> > put a comment here saying that only a single program can be first/last?
> > And the users are advised not to use these unless they really really re=
ally
> > need to be first/last. (IOW, feels like first/last should be reserved
> > for observability tools/etc).
>=20
> +1, we can definitely make it clear in API that this will prevent
> anyone else from being attached as FIRST/LAST, so it's not cooperative
> in nature and has to be very consciously evaluated.
>=20
> >
> > > +#define BPF_F_ID             (1U << 7)
> > > +#define BPF_F_LINK           BPF_F_LINK /* 1 << 13 */
> > >
> > >  /* If BPF_F_STRICT_ALIGNMENT is used in BPF_PROG_LOAD command, the
> > >   * verifier will perform strict alignment checking as if the kernel
>=20
> [...]

