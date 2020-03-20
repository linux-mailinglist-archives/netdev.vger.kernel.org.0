Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0C5D18D70C
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 19:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgCTSay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 14:30:54 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34983 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726773AbgCTSay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 14:30:54 -0400
Received: by mail-pf1-f193.google.com with SMTP id u68so3726938pfb.2;
        Fri, 20 Mar 2020 11:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=dT4M7L+LYpadBT0G7V+iaK+TR0lq4STBaiZgCsLJN2s=;
        b=ZPOOTVG7Wo1HzdTr+H/awdh68U9Zi42wM8eJBAHitKvfJ1DKlGDj17SSoNkDtBJjHq
         BTAB+vC+AVDLJOIegqeZQ9rYzOTjxbN7u230L1QUhsQoa333jEsk5qiW+EH/mr1RpF41
         3tgzNErGcH5Jt+YATq0FvhcdHub80gbTbfJKp9/62dvoM7HhkkLLJyhabUjJ7NjsKMTo
         l+QFpi7SOexum8fYVf8zLeDjGfjWKKVheMq8ZQoMgURQABg4oL2Q2xMp++hi2T1v3IKM
         +Y0tRewlLxfS4OFmsDvQzJNPFP4Xt9Se1uVxeTyTP1+OwUTRDGFP1fAEEfGv9zmyM5Ln
         K+wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=dT4M7L+LYpadBT0G7V+iaK+TR0lq4STBaiZgCsLJN2s=;
        b=mLzs6B8rVPKxFLdjWGvKevFGfhRzqF32oQg8sXJb5jLiSqJhRnME4q+JiaS0VsJBKJ
         yA9JN415ahLhy7NlV44GLbecM9z/wubn8mMEpcwCHk8KcTq/oHc53Q1hMazN4dORzqqb
         tb9ftKak30MjpPCdoY/bXLonsM3cYom8nJkmodJV+iGNptN/TJrW7sxJInwva+OO2cm9
         eLpt6J3E0Hw18yCEb5mDFGZ6elc05+PsiIDqaP+dVg9EeY5KGG/KmowBj21YTQ4u4rId
         gg++sf12z6tlyF+TrL44IJAMb9ZTLwQdgmFIq+qzcyGUwLjfAuml7UQceiskCYx8MC3a
         +XdQ==
X-Gm-Message-State: ANhLgQ3XYOhYm/4QR533nAhyGVXmvEH9Oxqfi1JalR6bUYp7SLxfGQP+
        /ecO5lv9/k+QAiu6ZgmrF74=
X-Google-Smtp-Source: ADFU+vt6o0fr0sZAyGw8oZWtkH/IdniTXWOGXKvW7rFXmLK+fhaudVPkQZNbQippooGfyecu1E5XaQ==
X-Received: by 2002:aa7:94b9:: with SMTP id a25mr11353406pfl.193.1584729052905;
        Fri, 20 Mar 2020 11:30:52 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id u12sm6090858pfm.165.2020.03.20.11.30.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 11:30:52 -0700 (PDT)
Date:   Fri, 20 Mar 2020 11:30:44 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Message-ID: <5e750bd4ebf8d_233f2ab4c81425c4ce@john-XPS-13-9370.notmuch>
In-Reply-To: <20200320103530.2853c573@kicinski-fedora-PC1C0HJN>
References: <158462359206.164779.15902346296781033076.stgit@toke.dk>
 <158462359315.164779.13931660750493121404.stgit@toke.dk>
 <20200319155236.3d8537c5@kicinski-fedora-PC1C0HJN>
 <875zez76ph.fsf@toke.dk>
 <20200320103530.2853c573@kicinski-fedora-PC1C0HJN>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote:
> On Fri, 20 Mar 2020 09:48:10 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wro=
te:
> > Jakub Kicinski <kuba@kernel.org> writes:
> > > On Thu, 19 Mar 2020 14:13:13 +0100 Toke H=C3=B8iland-J=C3=B8rgensen=
 wrote:  =

> > >> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> > >> =

> > >> While it is currently possible for userspace to specify that an ex=
isting
> > >> XDP program should not be replaced when attaching to an interface,=
 there is
> > >> no mechanism to safely replace a specific XDP program with another=
.
> > >> =

> > >> This patch adds a new netlink attribute, IFLA_XDP_EXPECTED_FD, whi=
ch can be
> > >> set along with IFLA_XDP_FD. If set, the kernel will check that the=
 program
> > >> currently loaded on the interface matches the expected one, and fa=
il the
> > >> operation if it does not. This corresponds to a 'cmpxchg' memory o=
peration.
> > >> =

> > >> A new companion flag, XDP_FLAGS_EXPECT_FD, is also added to explic=
itly
> > >> request checking of the EXPECTED_FD attribute. This is needed for =
userspace
> > >> to discover whether the kernel supports the new attribute.
> > >> =

> > >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> =
 =

> > >
> > > I didn't know we wanted to go ahead with this...  =

> > =

> > Well, I'm aware of the bpf_link discussion, obviously. Not sure what'=
s
> > happening with that, though. So since this is a straight-forward
> > extension of the existing API, that doesn't carry a high implementati=
on
> > cost, I figured I'd just go ahead with this. Doesn't mean we can't ha=
ve
> > something similar in bpf_link as well, of course.
> =

> I'm not really in the loop, but from what I overheard - I think the
> bpf_link may be targeting something non-networking first.

My preference is to avoid building two different APIs one for XDP and ano=
ther
for everything else. If we have userlands that already understand links a=
nd
pinning support is on the way imo lets use these APIs for networking as w=
ell.

Would a link_swap() API (proposed by Andrii iirc) resolve this use case a=
s
well? If not why? If it can it seems like the more general and consistent=

solution. I can imagine swapping links is useful in tracing as well and
likely other cases I haven't thought about.=
