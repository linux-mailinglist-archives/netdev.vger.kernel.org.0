Return-Path: <netdev+bounces-9388-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 92C72728AFA
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 00:13:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D8CFB1C21069
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 22:13:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A85C34D7F;
	Thu,  8 Jun 2023 22:13:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10DE37464;
	Thu,  8 Jun 2023 22:13:27 +0000 (UTC)
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E96E1E61;
	Thu,  8 Jun 2023 15:13:24 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-9745ba45cd1so175611166b.1;
        Thu, 08 Jun 2023 15:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686262403; x=1688854403;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7sd3s3BJEp56KTFaaUzoT7lxnrFJVfkt96oZ+We3NHE=;
        b=TbNRK59VwF2Lr0E62g3Ga2RPAlckxlgJH7bvikWaz4U2qtMoSE2X1hk6rlCuJXs1p0
         IarzdfYiEaAe7Bpew/chHlyjVWyZt8HyTShApkbSP1QsXSWHqyvat3PBItDyWO8wHE8K
         rO8Z6kLcZ1hKlOIl/Adtgz8DW5RGn+sV8MBtm24Arg5Mrp/x1I4R3eIqzoTPLYOBVtQ/
         hdZKnbi2Hp0wxJVrTxhoKTewbnapN132FCCWMzapXr7z3sEfv7fBZ2sZYC0B8/tMnEqM
         gO21n21bCbbDGGDeQSMnIpZ9OeDKuNB4GjVc28gZrmFt71PfvmwVwpUcLO/S7KcILuhm
         stMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686262403; x=1688854403;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7sd3s3BJEp56KTFaaUzoT7lxnrFJVfkt96oZ+We3NHE=;
        b=YbsmJxYyIDKjzuxDOxas71bQmLz/gxKBzWP+PwX+5RPBXiaP/GHcBeNA+rPE5EjVxD
         3zbOTtUPIq/dOCUcw39fPErZN5At5SGrVOJ9couYaJwcGj38ylC3QF2NI0OBVf9eALUS
         iypB34w7j8BH31Ix5G4Gue9LUd9Fbb5rOF//m8Glm7YC052fG4v60WKUvA39h3IoWOXe
         1Pb+aSLbUZeBgRL6rg408yMDSnzjzs9cX2H7a4Gh1POGRNpyHBraDvRnEUqucFKHQPzt
         zIyGre846N2VTe10rGAh7qKDYdzjQFroSI+q3wKJIzbXZKnqrDn+gqCue06miYL75gZp
         y5cw==
X-Gm-Message-State: AC+VfDzbWS6MaA/7Lcei0HKM+NgmKidq4nfw/kkl0Ii2R2xMCylolEiX
	BH4MNm5TAidxZI31wxQOYISfNrbHdmtzR5CNotk=
X-Google-Smtp-Source: ACHHUZ4yT23R37SDX/2nAQ5RXWJFWHdU69fKb3vrqFWML95lB6VPeZTVTLrmNHEVTjYlG1btAmynUODFpPKRZTbTEDE=
X-Received: by 2002:a17:907:6e23:b0:971:9364:f8cd with SMTP id
 sd35-20020a1709076e2300b009719364f8cdmr331394ejc.44.1686262403107; Thu, 08
 Jun 2023 15:13:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230607192625.22641-1-daniel@iogearbox.net> <20230607192625.22641-2-daniel@iogearbox.net>
 <ZIIOr1zvdRNTFKR7@google.com> <CAEf4BzbEf+U53UY6o+g5OZ6rg+T65_Aou4Nvrdbo-8sAjmdJmA@mail.gmail.com>
 <ZIJNlxCX4ksBFFwN@google.com>
In-Reply-To: <ZIJNlxCX4ksBFFwN@google.com>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Thu, 8 Jun 2023 15:13:10 -0700
Message-ID: <CAEf4BzYbr5G8ZGnWEndiZ1-7_XqYfKFTorDvvafwZY0XJUn7cw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/7] bpf: Add generic attach/detach/query API
 for multi-progs
To: Stanislav Fomichev <sdf@google.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>, ast@kernel.org, andrii@kernel.org, 
	martin.lau@linux.dev, razor@blackwall.org, john.fastabend@gmail.com, 
	kuba@kernel.org, dxu@dxuuu.xyz, joe@cilium.io, toke@kernel.org, 
	davem@davemloft.net, bpf@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 8, 2023 at 2:52=E2=80=AFPM Stanislav Fomichev <sdf@google.com> =
wrote:
>
> On 06/08, Andrii Nakryiko wrote:
> > On Thu, Jun 8, 2023 at 10:24=E2=80=AFAM Stanislav Fomichev <sdf@google.=
com> wrote:
> > >
> > > On 06/07, Daniel Borkmann wrote:
> > > > This adds a generic layer called bpf_mprog which can be reused by d=
ifferent
> > > > attachment layers to enable multi-program attachment and dependency=
 resolution.
> > > > In-kernel users of the bpf_mprog don't need to care about the depen=
dency
> > > > resolution internals, they can just consume it with few API calls.
> > > >
> > > > The initial idea of having a generic API sparked out of discussion =
[0] from an
> > > > earlier revision of this work where tc's priority was reused and ex=
posed via
> > > > BPF uapi as a way to coordinate dependencies among tc BPF programs,=
 similar
> > > > as-is for classic tc BPF. The feedback was that priority provides a=
 bad user
> > > > experience and is hard to use [1], e.g.:
> > > >
> > > >   I cannot help but feel that priority logic copy-paste from old tc=
, netfilter
> > > >   and friends is done because "that's how things were done in the p=
ast". [...]
> > > >   Priority gets exposed everywhere in uapi all the way to bpftool w=
hen it's
> > > >   right there for users to understand. And that's the main problem =
with it.
> > > >
> > > >   The user don't want to and don't need to be aware of it, but uapi=
 forces them
> > > >   to pick the priority. [...] Your cover letter [0] example proves =
that in
> > > >   real life different service pick the same priority. They simply d=
on't know
> > > >   any better. Priority is an unnecessary magic that apps _have_ to =
pick, so
> > > >   they just copy-paste and everyone ends up using the same.
> > > >
> > > > The course of the discussion showed more and more the need for a ge=
neric,
> > > > reusable API where the "same look and feel" can be applied for vari=
ous other
> > > > program types beyond just tc BPF, for example XDP today does not ha=
ve multi-
> > > > program support in kernel, but also there was interest around this =
API for
> > > > improving management of cgroup program types. Such common multi-pro=
gram
> > > > management concept is useful for BPF management daemons or user spa=
ce BPF
> > > > applications coordinating about their attachments.
> > > >
> > > > Both from Cilium and Meta side [2], we've collected the following r=
equirements
> > > > for a generic attach/detach/query API for multi-progs which has bee=
n implemented
> > > > as part of this work:
> > > >
> > > >   - Support prog-based attach/detach and link API
> > > >   - Dependency directives (can also be combined):
> > > >     - BPF_F_{BEFORE,AFTER} with relative_{fd,id} which can be {prog=
,link,none}
> > > >       - BPF_F_ID flag as {fd,id} toggle
> > > >       - BPF_F_LINK flag as {prog,link} toggle
> > > >       - If relative_{fd,id} is none, then BPF_F_BEFORE will just pr=
epend, and
> > > >         BPF_F_AFTER will just append for the case of attaching
> > > >       - Enforced only at attach time
> > > >     - BPF_F_{FIRST,LAST}
> > > >       - Enforced throughout the bpf_mprog state's lifetime
> > > >       - Admin override possible (e.g. link detach, prog-based BPF_F=
_REPLACE)
> > > >   - Internal revision counter and optionally being able to pass exp=
ected_revision
> > > >   - User space daemon can query current state with revision, and pa=
ss it along
> > > >     for attachment to assert current state before doing updates
> > > >   - Query also gets extension for link_ids array and link_attach_fl=
ags:
> > > >     - prog_ids are always filled with program IDs
> > > >     - link_ids are filled with link IDs when link was used, otherwi=
se 0
> > > >     - {prog,link}_attach_flags for holding {prog,link}-specific fla=
gs
> > > >   - Must be easy to integrate/reuse for in-kernel users
> > > >
> > > > The uapi-side changes needed for supporting bpf_mprog are rather mi=
nimal,
> > > > consisting of the additions of the attachment flags, revision count=
er, and
> > > > expanding existing union with relative_{fd,id} member.
> > > >
> > > > The bpf_mprog framework consists of an bpf_mprog_entry object which=
 holds
> > > > an array of bpf_mprog_fp (fast-path structure) and bpf_mprog_cp (co=
ntrol-path
> > > > structure). Both have been separated, so that fast-path gets effici=
ent packing
> > > > of bpf_prog pointers for maximum cache efficieny. Also, array has b=
een chosen
> > > > instead of linked list or other structures to remove unnecessary in=
directions
> > > > for a fast point-to-entry in tc for BPF. The bpf_mprog_entry comes =
as a pair
> > > > via bpf_mprog_bundle so that in case of updates the peer bpf_mprog_=
entry
> > > > is populated and then just swapped which avoids additional allocati=
ons that
> > > > could otherwise fail, for example, in detach case. bpf_mprog_{fp,cp=
} arrays are
> > > > currently static, but they could be converted to dynamic allocation=
 if necessary
> > > > at a point in future. Locking is deferred to the in-kernel user of =
bpf_mprog,
> > > > for example, in case of tcx which uses this API in the next patch, =
it piggy-
> > > > backs on rtnl. The nitty-gritty details are in the bpf_mprog_{repla=
ce,head_tail,
> > > > add,del} implementation and an extensive test suite for checking al=
l aspects
> > > > of this API for prog-based attach/detach and link API as BPF selfte=
sts in
> > > > this series.
> > > >
> > > > Kudos also to Andrii Nakryiko for API discussions wrt Meta's BPF ma=
nagement daemon.
> > > >
> > > >   [0] https://lore.kernel.org/bpf/20221004231143.19190-1-daniel@iog=
earbox.net/
> > > >   [1] https://lore.kernel.org/bpf/CAADnVQ+gEY3FjCR=3D+DmjDR4gp5bOYZ=
UFJQXj4agKFHT9CQPZBw@mail.gmail.com
> > > >   [2] http://vger.kernel.org/bpfconf2023_material/tcx_meta_netdev_b=
orkmann.pdf
> > > >
> > > > Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> > > > ---
> > > >  MAINTAINERS                    |   1 +
> > > >  include/linux/bpf_mprog.h      | 245 +++++++++++++++++
> > > >  include/uapi/linux/bpf.h       |  37 ++-
> > > >  kernel/bpf/Makefile            |   2 +-
> > > >  kernel/bpf/mprog.c             | 476 +++++++++++++++++++++++++++++=
++++
> > > >  tools/include/uapi/linux/bpf.h |  37 ++-
> > > >  6 files changed, 781 insertions(+), 17 deletions(-)
> > > >  create mode 100644 include/linux/bpf_mprog.h
> > > >  create mode 100644 kernel/bpf/mprog.c
> > > >
> >
> > [...]
> >
> > > > diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/li=
nux/bpf.h
> > > > index a7b5e91dd768..207f8a37b327 100644
> > > > --- a/tools/include/uapi/linux/bpf.h
> > > > +++ b/tools/include/uapi/linux/bpf.h
> > > > @@ -1102,7 +1102,14 @@ enum bpf_link_type {
> > > >   */
> > > >  #define BPF_F_ALLOW_OVERRIDE (1U << 0)
> > > >  #define BPF_F_ALLOW_MULTI    (1U << 1)
> > > > +/* Generic attachment flags. */
> > > >  #define BPF_F_REPLACE                (1U << 2)
> > > > +#define BPF_F_BEFORE         (1U << 3)
> > > > +#define BPF_F_AFTER          (1U << 4)
> > >
> > > [..]
> > >
> > > > +#define BPF_F_FIRST          (1U << 5)
> > > > +#define BPF_F_LAST           (1U << 6)
> > >
> > > I'm still not sure whether the hard semantics of first/last is really
> > > useful. My worry is that some prog will just use BPF_F_FIRST which
> > > would prevent the rest of the users.. (starting with only
> > > F_BEFORE/F_AFTER feels 'safer'; we can iterate later on if we really
> > > need first/laste).
> >
> > Without FIRST/LAST some scenarios cannot be guaranteed to be safely
> > implemented. E.g., if I have some hard audit requirements and I need
> > to guarantee that my program runs first and observes each event, I'll
> > enforce BPF_F_FIRST when attaching it. And if that attachment fails,
> > then server setup is broken and my application cannot function.
> >
> > In a setup where we expect multiple applications to co-exist, it
> > should be a rule that no one is using FIRST/LAST (unless it's
> > absolutely required). And if someone doesn't comply, then that's a bug
> > and has to be reported to application owners.
> >
> > But it's not up to the kernel to enforce this cooperation by
> > disallowing FIRST/LAST semantics, because that semantics is critical
> > for some applications, IMO.
>
> Maybe that's something that should be done by some other mechanism?
> (and as a follow up, if needed) Something akin to what Toke
> mentioned with another program doing sorting or similar.

The goal of this API is to avoid needing some extra special program to
do this sorting

>
> Otherwise, those first/last are just plain simple old priority bands;
> only we have two now, not u16.

I think it's different. FIRST/LAST has to be used judiciously, of
course, but when they are needed, they will have no alternative.

Also, specifying FIRST + LAST is the way to say "I want my program to
be the only one attached". Should we encourage such use cases? No, of
course. But I think it's fair  for users to be able to express this.

>
> I'm mostly coming from the observability point: imagine I have my fancy
> tc_ingress_tcpdump program that I want to attach as a first program to de=
bug
> some issue, but it won't work because there is already a 'first' program
> installed.. Or the assumption that I'd do F_REPLACE | F_FIRST ?

If your production setup requires that some important program has to
be FIRST, then yeah, your "let me debug something" program shouldn't
interfere with it (assuming that FIRST requirement is a real
requirement and not someone just thinking they need to be first; but
that's up to user space to decide). Maybe the solution for you in that
case would be freplace program installed on top of that stubborn FIRST
program? And if we are talking about local debugging and development,
then you are a sysadmin and you should be able to force-detach that
program that is getting in the way.


>
> > > But if everyone besides myself is on board with first/last, maybe at =
least
> > > put a comment here saying that only a single program can be first/las=
t?
> > > And the users are advised not to use these unless they really really =
really
> > > need to be first/last. (IOW, feels like first/last should be reserved
> > > for observability tools/etc).
> >
> > +1, we can definitely make it clear in API that this will prevent
> > anyone else from being attached as FIRST/LAST, so it's not cooperative
> > in nature and has to be very consciously evaluated.
> >
> > >
> > > > +#define BPF_F_ID             (1U << 7)
> > > > +#define BPF_F_LINK           BPF_F_LINK /* 1 << 13 */
> > > >
> > > >  /* If BPF_F_STRICT_ALIGNMENT is used in BPF_PROG_LOAD command, the
> > > >   * verifier will perform strict alignment checking as if the kerne=
l
> >
> > [...]

