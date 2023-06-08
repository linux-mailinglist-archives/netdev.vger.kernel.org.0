Return-Path: <netdev+bounces-9390-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B20EF728B84
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 01:06:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CFDFC1C20D83
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 23:06:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D14331F00;
	Thu,  8 Jun 2023 23:06:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD5224120
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 23:06:16 +0000 (UTC)
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C3A2D7F
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 16:06:14 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-2568caac092so130259a91.1
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 16:06:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686265574; x=1688857574;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4Y4JegzAWuFynGZLge6PJMJFKrExQgtlY9V5Ns1zPbQ=;
        b=uk0Vz+/5MZyaxTCNs1ZqD7IBGcqJHLLYefakL1PERz6rbhfAsJMAgCf1UnyUVzdOzM
         MylpLXAw3w/zPT/7l3ptr15Vp2f1J0rYBjdCZ4eg93GWm0Vp5ZZ7d8JRyh7soYDwa86Y
         P8lwHlJZWMlpImzRBkQC+S7jDzGmY25AI2VH7IweCwHCUZpzbKGmfOcWW5sellAHWY1x
         vgr1+n2H3MQA24yHv20181Nc/yNUzqHLxVnKE/ILLt9TYSG9rOjg0Hep9NN7/6jnMXU8
         7emA/XvwZrL9AQUykvZthV6XqdE456HhTF1yi4AbFIuM+j4Omorf5ApmLdSMC5hxyi3M
         YNpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686265574; x=1688857574;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4Y4JegzAWuFynGZLge6PJMJFKrExQgtlY9V5Ns1zPbQ=;
        b=OBgSr8vWglanJwRcw89jXn7nTpOFs9bm1NJgQ57MyXbLv/W7fw4crzIY3jKh5yoyiN
         UFPS7A6dUBb+Fpb3mUDWeS7Xcr0kvukxYhUGi2d2o/zMXoaIujGiTXtBJXeVZ0kdZQFe
         4yhoh3xDAYi9JoPzpNhbVAlrjDOgDAYJfokb/sdu7gL1/p7NIa9kZnXS3jqaAiNX+Wik
         1mVcjCdSByt7U/o4JNIOBXlnj7mM+Efm1FoIRxbBPY+gYH3ae1LErHPcAnTgE7Jn+1jl
         ptvECqV2hddVKsbQfKoHZ1XSCGnMAaNx1SI4NIf0VfUKxS8sosgm3RwKtXDpc2VXFZVg
         h78g==
X-Gm-Message-State: AC+VfDwUSPXNnMtfQuFRyCwfGWgGzA0D2zFMZdcCl0KEyMw+JLcE6U4O
	Lz5TDBJGfHufYR9y+7Hqek12kLI=
X-Google-Smtp-Source: ACHHUZ44bfUthN6q1C0cxJIrGEFc9F13583xTDHFFydjX8t/twWLSQjts1KYhyuxaM0uAnvqvIpLVhM=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:90a:ba10:b0:244:9147:ee20 with SMTP id
 s16-20020a17090aba1000b002449147ee20mr2398713pjr.0.1686265574139; Thu, 08 Jun
 2023 16:06:14 -0700 (PDT)
Date: Thu, 8 Jun 2023 16:06:12 -0700
In-Reply-To: <CAEf4BzYbr5G8ZGnWEndiZ1-7_XqYfKFTorDvvafwZY0XJUn7cw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230607192625.22641-1-daniel@iogearbox.net> <20230607192625.22641-2-daniel@iogearbox.net>
 <ZIIOr1zvdRNTFKR7@google.com> <CAEf4BzbEf+U53UY6o+g5OZ6rg+T65_Aou4Nvrdbo-8sAjmdJmA@mail.gmail.com>
 <ZIJNlxCX4ksBFFwN@google.com> <CAEf4BzYbr5G8ZGnWEndiZ1-7_XqYfKFTorDvvafwZY0XJUn7cw@mail.gmail.com>
Message-ID: <ZIJe5Ml6ILFa6tKP@google.com>
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
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 06/08, Andrii Nakryiko wrote:
> On Thu, Jun 8, 2023 at 2:52=E2=80=AFPM Stanislav Fomichev <sdf@google.com=
> wrote:
> >
> > On 06/08, Andrii Nakryiko wrote:
> > > On Thu, Jun 8, 2023 at 10:24=E2=80=AFAM Stanislav Fomichev <sdf@googl=
e.com> wrote:
> > > >
> > > > On 06/07, Daniel Borkmann wrote:
> > > > > This adds a generic layer called bpf_mprog which can be reused by=
 different
> > > > > attachment layers to enable multi-program attachment and dependen=
cy resolution.
> > > > > In-kernel users of the bpf_mprog don't need to care about the dep=
endency
> > > > > resolution internals, they can just consume it with few API calls=
.
> > > > >
> > > > > The initial idea of having a generic API sparked out of discussio=
n [0] from an
> > > > > earlier revision of this work where tc's priority was reused and =
exposed via
> > > > > BPF uapi as a way to coordinate dependencies among tc BPF program=
s, similar
> > > > > as-is for classic tc BPF. The feedback was that priority provides=
 a bad user
> > > > > experience and is hard to use [1], e.g.:
> > > > >
> > > > >   I cannot help but feel that priority logic copy-paste from old =
tc, netfilter
> > > > >   and friends is done because "that's how things were done in the=
 past". [...]
> > > > >   Priority gets exposed everywhere in uapi all the way to bpftool=
 when it's
> > > > >   right there for users to understand. And that's the main proble=
m with it.
> > > > >
> > > > >   The user don't want to and don't need to be aware of it, but ua=
pi forces them
> > > > >   to pick the priority. [...] Your cover letter [0] example prove=
s that in
> > > > >   real life different service pick the same priority. They simply=
 don't know
> > > > >   any better. Priority is an unnecessary magic that apps _have_ t=
o pick, so
> > > > >   they just copy-paste and everyone ends up using the same.
> > > > >
> > > > > The course of the discussion showed more and more the need for a =
generic,
> > > > > reusable API where the "same look and feel" can be applied for va=
rious other
> > > > > program types beyond just tc BPF, for example XDP today does not =
have multi-
> > > > > program support in kernel, but also there was interest around thi=
s API for
> > > > > improving management of cgroup program types. Such common multi-p=
rogram
> > > > > management concept is useful for BPF management daemons or user s=
pace BPF
> > > > > applications coordinating about their attachments.
> > > > >
> > > > > Both from Cilium and Meta side [2], we've collected the following=
 requirements
> > > > > for a generic attach/detach/query API for multi-progs which has b=
een implemented
> > > > > as part of this work:
> > > > >
> > > > >   - Support prog-based attach/detach and link API
> > > > >   - Dependency directives (can also be combined):
> > > > >     - BPF_F_{BEFORE,AFTER} with relative_{fd,id} which can be {pr=
og,link,none}
> > > > >       - BPF_F_ID flag as {fd,id} toggle
> > > > >       - BPF_F_LINK flag as {prog,link} toggle
> > > > >       - If relative_{fd,id} is none, then BPF_F_BEFORE will just =
prepend, and
> > > > >         BPF_F_AFTER will just append for the case of attaching
> > > > >       - Enforced only at attach time
> > > > >     - BPF_F_{FIRST,LAST}
> > > > >       - Enforced throughout the bpf_mprog state's lifetime
> > > > >       - Admin override possible (e.g. link detach, prog-based BPF=
_F_REPLACE)
> > > > >   - Internal revision counter and optionally being able to pass e=
xpected_revision
> > > > >   - User space daemon can query current state with revision, and =
pass it along
> > > > >     for attachment to assert current state before doing updates
> > > > >   - Query also gets extension for link_ids array and link_attach_=
flags:
> > > > >     - prog_ids are always filled with program IDs
> > > > >     - link_ids are filled with link IDs when link was used, other=
wise 0
> > > > >     - {prog,link}_attach_flags for holding {prog,link}-specific f=
lags
> > > > >   - Must be easy to integrate/reuse for in-kernel users
> > > > >
> > > > > The uapi-side changes needed for supporting bpf_mprog are rather =
minimal,
> > > > > consisting of the additions of the attachment flags, revision cou=
nter, and
> > > > > expanding existing union with relative_{fd,id} member.
> > > > >
> > > > > The bpf_mprog framework consists of an bpf_mprog_entry object whi=
ch holds
> > > > > an array of bpf_mprog_fp (fast-path structure) and bpf_mprog_cp (=
control-path
> > > > > structure). Both have been separated, so that fast-path gets effi=
cient packing
> > > > > of bpf_prog pointers for maximum cache efficieny. Also, array has=
 been chosen
> > > > > instead of linked list or other structures to remove unnecessary =
indirections
> > > > > for a fast point-to-entry in tc for BPF. The bpf_mprog_entry come=
s as a pair
> > > > > via bpf_mprog_bundle so that in case of updates the peer bpf_mpro=
g_entry
> > > > > is populated and then just swapped which avoids additional alloca=
tions that
> > > > > could otherwise fail, for example, in detach case. bpf_mprog_{fp,=
cp} arrays are
> > > > > currently static, but they could be converted to dynamic allocati=
on if necessary
> > > > > at a point in future. Locking is deferred to the in-kernel user o=
f bpf_mprog,
> > > > > for example, in case of tcx which uses this API in the next patch=
, it piggy-
> > > > > backs on rtnl. The nitty-gritty details are in the bpf_mprog_{rep=
lace,head_tail,
> > > > > add,del} implementation and an extensive test suite for checking =
all aspects
> > > > > of this API for prog-based attach/detach and link API as BPF self=
tests in
> > > > > this series.
> > > > >
> > > > > Kudos also to Andrii Nakryiko for API discussions wrt Meta's BPF =
management daemon.
> > > > >
> > > > >   [0] https://lore.kernel.org/bpf/20221004231143.19190-1-daniel@i=
ogearbox.net/
> > > > >   [1] https://lore.kernel.org/bpf/CAADnVQ+gEY3FjCR=3D+DmjDR4gp5bO=
YZUFJQXj4agKFHT9CQPZBw@mail.gmail.com
> > > > >   [2] http://vger.kernel.org/bpfconf2023_material/tcx_meta_netdev=
_borkmann.pdf
> > > > >
> > > > > Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> > > > > ---
> > > > >  MAINTAINERS                    |   1 +
> > > > >  include/linux/bpf_mprog.h      | 245 +++++++++++++++++
> > > > >  include/uapi/linux/bpf.h       |  37 ++-
> > > > >  kernel/bpf/Makefile            |   2 +-
> > > > >  kernel/bpf/mprog.c             | 476 +++++++++++++++++++++++++++=
++++++
> > > > >  tools/include/uapi/linux/bpf.h |  37 ++-
> > > > >  6 files changed, 781 insertions(+), 17 deletions(-)
> > > > >  create mode 100644 include/linux/bpf_mprog.h
> > > > >  create mode 100644 kernel/bpf/mprog.c
> > > > >
> > >
> > > [...]
> > >
> > > > > diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/=
linux/bpf.h
> > > > > index a7b5e91dd768..207f8a37b327 100644
> > > > > --- a/tools/include/uapi/linux/bpf.h
> > > > > +++ b/tools/include/uapi/linux/bpf.h
> > > > > @@ -1102,7 +1102,14 @@ enum bpf_link_type {
> > > > >   */
> > > > >  #define BPF_F_ALLOW_OVERRIDE (1U << 0)
> > > > >  #define BPF_F_ALLOW_MULTI    (1U << 1)
> > > > > +/* Generic attachment flags. */
> > > > >  #define BPF_F_REPLACE                (1U << 2)
> > > > > +#define BPF_F_BEFORE         (1U << 3)
> > > > > +#define BPF_F_AFTER          (1U << 4)
> > > >
> > > > [..]
> > > >
> > > > > +#define BPF_F_FIRST          (1U << 5)
> > > > > +#define BPF_F_LAST           (1U << 6)
> > > >
> > > > I'm still not sure whether the hard semantics of first/last is real=
ly
> > > > useful. My worry is that some prog will just use BPF_F_FIRST which
> > > > would prevent the rest of the users.. (starting with only
> > > > F_BEFORE/F_AFTER feels 'safer'; we can iterate later on if we reall=
y
> > > > need first/laste).
> > >
> > > Without FIRST/LAST some scenarios cannot be guaranteed to be safely
> > > implemented. E.g., if I have some hard audit requirements and I need
> > > to guarantee that my program runs first and observes each event, I'll
> > > enforce BPF_F_FIRST when attaching it. And if that attachment fails,
> > > then server setup is broken and my application cannot function.
> > >
> > > In a setup where we expect multiple applications to co-exist, it
> > > should be a rule that no one is using FIRST/LAST (unless it's
> > > absolutely required). And if someone doesn't comply, then that's a bu=
g
> > > and has to be reported to application owners.
> > >
> > > But it's not up to the kernel to enforce this cooperation by
> > > disallowing FIRST/LAST semantics, because that semantics is critical
> > > for some applications, IMO.
> >
> > Maybe that's something that should be done by some other mechanism?
> > (and as a follow up, if needed) Something akin to what Toke
> > mentioned with another program doing sorting or similar.
>=20
> The goal of this API is to avoid needing some extra special program to
> do this sorting
>=20
> >
> > Otherwise, those first/last are just plain simple old priority bands;
> > only we have two now, not u16.
>=20
> I think it's different. FIRST/LAST has to be used judiciously, of
> course, but when they are needed, they will have no alternative.
>=20
> Also, specifying FIRST + LAST is the way to say "I want my program to
> be the only one attached". Should we encourage such use cases? No, of
> course. But I think it's fair  for users to be able to express this.
>=20
> >
> > I'm mostly coming from the observability point: imagine I have my fancy
> > tc_ingress_tcpdump program that I want to attach as a first program to =
debug
> > some issue, but it won't work because there is already a 'first' progra=
m
> > installed.. Or the assumption that I'd do F_REPLACE | F_FIRST ?
>=20
> If your production setup requires that some important program has to
> be FIRST, then yeah, your "let me debug something" program shouldn't
> interfere with it (assuming that FIRST requirement is a real
> requirement and not someone just thinking they need to be first; but
> that's up to user space to decide). Maybe the solution for you in that
> case would be freplace program installed on top of that stubborn FIRST
> program? And if we are talking about local debugging and development,
> then you are a sysadmin and you should be able to force-detach that
> program that is getting in the way.

I'm not really concerned about our production environment. It's pretty
controlled and restricted and I'm pretty certain we can avoid doing
something stupid. Probably the same for your env.

I'm mostly fantasizing about upstream world where different users don't
know about each other and start doing stupid things like F_FIRST where
they don't really have to be first. It's that "used judiciously" part
that I'm a bit skeptical about :-D

Because even with this new ordering scheme, there still should be
some entity to do relative ordering (systemd-style, maybe CNI?).
And if it does the ordering, I don't really see why we need
F_FIRST/F_LAST.

But, if you think you need F_FIRST/F_LAST, let's have them. I just
personally don't see us using them (nor do I see why they have to
be used upstream). The only thing that makes sense is probably for
cilium to do F_FIRST|F_LAST to prevent other things from breaking it?

