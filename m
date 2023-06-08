Return-Path: <netdev+bounces-9364-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DA4C7289C0
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 22:59:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 588312816BA
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 20:59:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F03831F19;
	Thu,  8 Jun 2023 20:59:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0211DCDC;
	Thu,  8 Jun 2023 20:59:49 +0000 (UTC)
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00DB6E61;
	Thu,  8 Jun 2023 13:59:46 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id 4fb4d7f45d1cf-514924ca903so1632085a12.2;
        Thu, 08 Jun 2023 13:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686257985; x=1688849985;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d9qacWQXjA+oXDojChRddTQg/JrgJ/B2FSoCeX7QaMc=;
        b=Oe7AliTTcF0PiFzkRTryhGWLn/qUosUz8ReQD3qORJW2YhPYEmuR9dQAqwzh5kM2WL
         3yEZiAVnnbFZoI8Nhj5hPHKhrt+aIIPQ2Gt6X6rU+hjqdaj3bCwjyIEinD4OmHUwFLnY
         Yr5jgu5k5BsecAqLKoT/I3zEg7E9cw9DvlTFmR/xFWCyvXN5gchbZ4TLyLezyFfHNVso
         R2Hqbs8I/KLM0QzzaOa+5yckX8x/ZQHnnEXN4ExK9R3PM8ZKwstveXQsddWKYuFozQu3
         E7JZiHv3HZmc5A1p4AjHbJAB+YgOxpfNnHSZ/184WC3hL4Jy3twgFZLl987Q3ttFS/fp
         L9oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686257985; x=1688849985;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d9qacWQXjA+oXDojChRddTQg/JrgJ/B2FSoCeX7QaMc=;
        b=GtetEHTLKV8wvo9cV3BKhrXBQ4VMpeGuEbh2gHjBYno3deRz7ywL0BwESMWpZPXaeB
         Yq8TSa9BUO/d+gK+J3wYxilIICVctnuQbYJbz+QfUSxzzkHo/oEl+d2P1HkJqaWrYE9+
         /IyH6OCa+ImPQ2D3iXYCivm+eET+V2CS3x41+WGkcCsFl2iNYiFLBtztu14pyoDb9fWe
         h/5XNN/ZjLY5vncAUZ8ODQRSKkV/K85RAFTq6D8+L1PnaEYJsw4ByZrQd+pzN0F/9Rjf
         mFOD+uHlh5d/XdJoLah8iF2G+SXzWnZ5A2GroTudBZ2OaoocF661DqXh0UuHnydVWhMA
         0DBw==
X-Gm-Message-State: AC+VfDwGnFLmb9OV8MpKx2UeFWypYWMPKGubvWO/A8d+q6XIX8lpY6AU
	83KYuYQs6nMyMyhfymReCDOi461Gcccr+iDwUUk=
X-Google-Smtp-Source: ACHHUZ5YVB42WK80yd3Kga+IY012KPKfFwpi0ilrpO21+Rf+ICcsiP7xFOl9HLENB9sUKe0d2fxUwN1WOVE+fyPyrNU=
X-Received: by 2002:a17:907:805:b0:92b:3c78:91fa with SMTP id
 wv5-20020a170907080500b0092b3c7891famr277683ejb.28.1686257984719; Thu, 08 Jun
 2023 13:59:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230607192625.22641-1-daniel@iogearbox.net> <20230607192625.22641-2-daniel@iogearbox.net>
 <ZIIOr1zvdRNTFKR7@google.com>
In-Reply-To: <ZIIOr1zvdRNTFKR7@google.com>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Thu, 8 Jun 2023 13:59:33 -0700
Message-ID: <CAEf4BzbEf+U53UY6o+g5OZ6rg+T65_Aou4Nvrdbo-8sAjmdJmA@mail.gmail.com>
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

On Thu, Jun 8, 2023 at 10:24=E2=80=AFAM Stanislav Fomichev <sdf@google.com>=
 wrote:
>
> On 06/07, Daniel Borkmann wrote:
> > This adds a generic layer called bpf_mprog which can be reused by diffe=
rent
> > attachment layers to enable multi-program attachment and dependency res=
olution.
> > In-kernel users of the bpf_mprog don't need to care about the dependenc=
y
> > resolution internals, they can just consume it with few API calls.
> >
> > The initial idea of having a generic API sparked out of discussion [0] =
from an
> > earlier revision of this work where tc's priority was reused and expose=
d via
> > BPF uapi as a way to coordinate dependencies among tc BPF programs, sim=
ilar
> > as-is for classic tc BPF. The feedback was that priority provides a bad=
 user
> > experience and is hard to use [1], e.g.:
> >
> >   I cannot help but feel that priority logic copy-paste from old tc, ne=
tfilter
> >   and friends is done because "that's how things were done in the past"=
. [...]
> >   Priority gets exposed everywhere in uapi all the way to bpftool when =
it's
> >   right there for users to understand. And that's the main problem with=
 it.
> >
> >   The user don't want to and don't need to be aware of it, but uapi for=
ces them
> >   to pick the priority. [...] Your cover letter [0] example proves that=
 in
> >   real life different service pick the same priority. They simply don't=
 know
> >   any better. Priority is an unnecessary magic that apps _have_ to pick=
, so
> >   they just copy-paste and everyone ends up using the same.
> >
> > The course of the discussion showed more and more the need for a generi=
c,
> > reusable API where the "same look and feel" can be applied for various =
other
> > program types beyond just tc BPF, for example XDP today does not have m=
ulti-
> > program support in kernel, but also there was interest around this API =
for
> > improving management of cgroup program types. Such common multi-program
> > management concept is useful for BPF management daemons or user space B=
PF
> > applications coordinating about their attachments.
> >
> > Both from Cilium and Meta side [2], we've collected the following requi=
rements
> > for a generic attach/detach/query API for multi-progs which has been im=
plemented
> > as part of this work:
> >
> >   - Support prog-based attach/detach and link API
> >   - Dependency directives (can also be combined):
> >     - BPF_F_{BEFORE,AFTER} with relative_{fd,id} which can be {prog,lin=
k,none}
> >       - BPF_F_ID flag as {fd,id} toggle
> >       - BPF_F_LINK flag as {prog,link} toggle
> >       - If relative_{fd,id} is none, then BPF_F_BEFORE will just prepen=
d, and
> >         BPF_F_AFTER will just append for the case of attaching
> >       - Enforced only at attach time
> >     - BPF_F_{FIRST,LAST}
> >       - Enforced throughout the bpf_mprog state's lifetime
> >       - Admin override possible (e.g. link detach, prog-based BPF_F_REP=
LACE)
> >   - Internal revision counter and optionally being able to pass expecte=
d_revision
> >   - User space daemon can query current state with revision, and pass i=
t along
> >     for attachment to assert current state before doing updates
> >   - Query also gets extension for link_ids array and link_attach_flags:
> >     - prog_ids are always filled with program IDs
> >     - link_ids are filled with link IDs when link was used, otherwise 0
> >     - {prog,link}_attach_flags for holding {prog,link}-specific flags
> >   - Must be easy to integrate/reuse for in-kernel users
> >
> > The uapi-side changes needed for supporting bpf_mprog are rather minima=
l,
> > consisting of the additions of the attachment flags, revision counter, =
and
> > expanding existing union with relative_{fd,id} member.
> >
> > The bpf_mprog framework consists of an bpf_mprog_entry object which hol=
ds
> > an array of bpf_mprog_fp (fast-path structure) and bpf_mprog_cp (contro=
l-path
> > structure). Both have been separated, so that fast-path gets efficient =
packing
> > of bpf_prog pointers for maximum cache efficieny. Also, array has been =
chosen
> > instead of linked list or other structures to remove unnecessary indire=
ctions
> > for a fast point-to-entry in tc for BPF. The bpf_mprog_entry comes as a=
 pair
> > via bpf_mprog_bundle so that in case of updates the peer bpf_mprog_entr=
y
> > is populated and then just swapped which avoids additional allocations =
that
> > could otherwise fail, for example, in detach case. bpf_mprog_{fp,cp} ar=
rays are
> > currently static, but they could be converted to dynamic allocation if =
necessary
> > at a point in future. Locking is deferred to the in-kernel user of bpf_=
mprog,
> > for example, in case of tcx which uses this API in the next patch, it p=
iggy-
> > backs on rtnl. The nitty-gritty details are in the bpf_mprog_{replace,h=
ead_tail,
> > add,del} implementation and an extensive test suite for checking all as=
pects
> > of this API for prog-based attach/detach and link API as BPF selftests =
in
> > this series.
> >
> > Kudos also to Andrii Nakryiko for API discussions wrt Meta's BPF manage=
ment daemon.
> >
> >   [0] https://lore.kernel.org/bpf/20221004231143.19190-1-daniel@iogearb=
ox.net/
> >   [1] https://lore.kernel.org/bpf/CAADnVQ+gEY3FjCR=3D+DmjDR4gp5bOYZUFJQ=
Xj4agKFHT9CQPZBw@mail.gmail.com
> >   [2] http://vger.kernel.org/bpfconf2023_material/tcx_meta_netdev_borkm=
ann.pdf
> >
> > Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> > ---
> >  MAINTAINERS                    |   1 +
> >  include/linux/bpf_mprog.h      | 245 +++++++++++++++++
> >  include/uapi/linux/bpf.h       |  37 ++-
> >  kernel/bpf/Makefile            |   2 +-
> >  kernel/bpf/mprog.c             | 476 +++++++++++++++++++++++++++++++++
> >  tools/include/uapi/linux/bpf.h |  37 ++-
> >  6 files changed, 781 insertions(+), 17 deletions(-)
> >  create mode 100644 include/linux/bpf_mprog.h
> >  create mode 100644 kernel/bpf/mprog.c
> >

[...]

> > diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/=
bpf.h
> > index a7b5e91dd768..207f8a37b327 100644
> > --- a/tools/include/uapi/linux/bpf.h
> > +++ b/tools/include/uapi/linux/bpf.h
> > @@ -1102,7 +1102,14 @@ enum bpf_link_type {
> >   */
> >  #define BPF_F_ALLOW_OVERRIDE (1U << 0)
> >  #define BPF_F_ALLOW_MULTI    (1U << 1)
> > +/* Generic attachment flags. */
> >  #define BPF_F_REPLACE                (1U << 2)
> > +#define BPF_F_BEFORE         (1U << 3)
> > +#define BPF_F_AFTER          (1U << 4)
>
> [..]
>
> > +#define BPF_F_FIRST          (1U << 5)
> > +#define BPF_F_LAST           (1U << 6)
>
> I'm still not sure whether the hard semantics of first/last is really
> useful. My worry is that some prog will just use BPF_F_FIRST which
> would prevent the rest of the users.. (starting with only
> F_BEFORE/F_AFTER feels 'safer'; we can iterate later on if we really
> need first/laste).

Without FIRST/LAST some scenarios cannot be guaranteed to be safely
implemented. E.g., if I have some hard audit requirements and I need
to guarantee that my program runs first and observes each event, I'll
enforce BPF_F_FIRST when attaching it. And if that attachment fails,
then server setup is broken and my application cannot function.

In a setup where we expect multiple applications to co-exist, it
should be a rule that no one is using FIRST/LAST (unless it's
absolutely required). And if someone doesn't comply, then that's a bug
and has to be reported to application owners.

But it's not up to the kernel to enforce this cooperation by
disallowing FIRST/LAST semantics, because that semantics is critical
for some applications, IMO.

>
> But if everyone besides myself is on board with first/last, maybe at leas=
t
> put a comment here saying that only a single program can be first/last?
> And the users are advised not to use these unless they really really real=
ly
> need to be first/last. (IOW, feels like first/last should be reserved
> for observability tools/etc).

+1, we can definitely make it clear in API that this will prevent
anyone else from being attached as FIRST/LAST, so it's not cooperative
in nature and has to be very consciously evaluated.

>
> > +#define BPF_F_ID             (1U << 7)
> > +#define BPF_F_LINK           BPF_F_LINK /* 1 << 13 */
> >
> >  /* If BPF_F_STRICT_ALIGNMENT is used in BPF_PROG_LOAD command, the
> >   * verifier will perform strict alignment checking as if the kernel

[...]

