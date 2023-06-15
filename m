Return-Path: <netdev+bounces-11182-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D4847731DE3
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 18:33:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F873281547
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 16:33:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4744A19904;
	Thu, 15 Jun 2023 16:31:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33EF34822C
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 16:31:37 +0000 (UTC)
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A9E52954
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 09:31:32 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id 98e67ed59e1d1-25bbaa393aaso3436926a91.0
        for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 09:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686846691; x=1689438691;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=StOUn5CkgiaIm0+Mbc2tJlEIy8qTJlaWhOHnzQnHiCY=;
        b=Jd5tJBsLD7PrFMbhb+uEo9bE/EdJdQwwylYO/WV9Z5O5EUlhu4X64C5S6ngnKELWXB
         4d089T9fI/HTjGO64QoI4sk6AUVAtB6FWcNK9WGo3Cm9/M6H48lWmeZ0vkMSDR5ZJ7HI
         GeZLq/p1r1h+G0MSXvBnNp8V3gTbOoOUd0Cm52ScTnIew8u4SSJORBqvF4JEiXPuNYxH
         k3xH9MWM8SvGlfY9ki7qUefzEnbsZE9xsrQetXaBoWW7/rJXtdMCGfp+O1j9rp7rSc5S
         PRXBJI43tC6Hu7ULEjTStPkU8H7lw2ZseoSNBLxOvWjHMF0XQYMae1sa4FdWrZAYE3be
         Ax5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686846691; x=1689438691;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=StOUn5CkgiaIm0+Mbc2tJlEIy8qTJlaWhOHnzQnHiCY=;
        b=g5gRslmo6umrH5ZcnyrGbcu7eeip1QKXqc4ykmCsaMYL1yYRInxxKcxCbcrwlKbmLV
         eODWLBrv6qPTPfJBnypjfmGUpzZFwb6hIB+7z+UkEPuDxxvHu7MNnzXgNIG5j75jPvdU
         kASt71cqIZp5oWhedWqocYOKQBobZ/fTXNTfia+MGJK5q3AZI5CBk+Lfj/GhGO+sx4db
         6nGUmLZDZeY3rC3gAlYHtcz6VF0zamaj9FD1MZdVj8mowCRTmRI5IBSWj9GqRMVKCyoi
         tsAsWLCcWHpyh6F6dS/pcE+hRSRuL7W8Kkyz2rhGB+/gkq59aPtZeJeFRqzMESosjO5H
         bCrQ==
X-Gm-Message-State: AC+VfDwJ+b8/Ey98WSs3/07ojeaFpgWkTo+29W7fVejmifOOoXygssLE
	sspFMr6O4wv30NPCoGcIZtFbpbxmMRjaiMeGxhaO3w==
X-Google-Smtp-Source: ACHHUZ6E8ivTFcwkdSxRHbJXksdl7I2+53a5Ye+DOt4QZ/CT6V1sDbjlmmgKAr/PFzP178uRb1F0/FqiYKkIJJRGKz4=
X-Received: by 2002:a17:90b:1109:b0:259:ae9b:9fd6 with SMTP id
 gi9-20020a17090b110900b00259ae9b9fd6mr4456564pjb.32.1686846691217; Thu, 15
 Jun 2023 09:31:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230612172307.3923165-1-sdf@google.com> <87cz20xunt.fsf@toke.dk>
 <ZIiaHXr9M0LGQ0Ht@google.com> <877cs7xovi.fsf@toke.dk> <CAKH8qBt5tQ69Zs9kYGc7j-_3Yx9D6+pmS4KCN5G0s9UkX545Mg@mail.gmail.com>
 <87v8frw546.fsf@toke.dk> <CAKH8qBtsvsWvO3Avsqb2PbvZgh5GDMxe2fok-jS4DrJM=x2Row@mail.gmail.com>
 <CAADnVQKFmXAQDYVZxjvH8qbxk+3M2COGbfmtd=w8Nxvf9=DaeA@mail.gmail.com>
 <CAKH8qBvAMKtfrZ1jdwVS2pF161UdeXPSpY4HSzKYGTYNTupmTg@mail.gmail.com>
 <CAADnVQ+CCOw9_LbCAaFz0593eydKNb7RxnGr6_FatUOKmvPmBg@mail.gmail.com>
 <877cs6l0ea.fsf@toke.dk> <CAADnVQJM6ttxLjj2FGCO1DKOwHdj9eqcz75dFpsfwJ_4b3iqDw@mail.gmail.com>
 <87pm5wgaws.fsf@toke.dk> <CAADnVQKvn-6xio0DyO8EDJktHKtWykfEQc3VosO7oji+Fk1oMA@mail.gmail.com>
In-Reply-To: <CAADnVQKvn-6xio0DyO8EDJktHKtWykfEQc3VosO7oji+Fk1oMA@mail.gmail.com>
From: Stanislav Fomichev <sdf@google.com>
Date: Thu, 15 Jun 2023 09:31:19 -0700
Message-ID: <CAKH8qBuLG=k0dF+3X0fM-1vmJ318B-UCzYOpcCYseWW14_w2NA@mail.gmail.com>
Subject: Re: [RFC bpf-next 0/7] bpf: netdev TX metadata
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@kernel.org>, 
	bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>, 
	John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, 
	Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>, 
	Willem de Bruijn <willemb@google.com>, David Ahern <dsahern@kernel.org>, 
	"Karlsson, Magnus" <magnus.karlsson@intel.com>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>, 
	"Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>, Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 15, 2023 at 9:10=E2=80=AFAM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Jun 15, 2023 at 5:36=E2=80=AFAM Toke H=C3=B8iland-J=C3=B8rgensen =
<toke@kernel.org> wrote:
> >
> > Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> >
> > > On Wed, Jun 14, 2023 at 5:00=E2=80=AFAM Toke H=C3=B8iland-J=C3=B8rgen=
sen <toke@kernel.org> wrote:
> > >>
> > >> >>
> > >> >> It's probably going to work if each driver has a separate set of =
tx
> > >> >> fentry points, something like:
> > >> >>   {veth,mlx5,etc}_devtx_submit()
> > >> >>   {veth,mlx5,etc}_devtx_complete()
> > >>
> > >> I really don't get the opposition to exposing proper APIs; as a
> > >> dataplane developer I want to attach a program to an interface. The
> > >> kernel's role is to provide a consistent interface for this, not to
> > >> require users to become driver developers just to get at the require=
d
> > >> details.
> > >
> > > Consistent interface can appear only when there is a consistency
> > > across nic manufacturers.
> > > I'm suggesting to experiment in the most unstable way and
> > > if/when the consistency is discovered then generalize.
> >
> > That would be fine for new experimental HW features, but we're talking
> > about timestamps here: a feature that is already supported by multiple
> > drivers and for which the stack has a working abstraction. There's no
> > reason why we can't have that for the XDP path as well.
>
> ... has an abstraction to receive, but has no mechanism to set it
> selectively per packet and read it on completion.

Timestamp might be a bit of an outlier here where it's just setting
some bit in some existing descriptor.
For some features, the drivers might have to reserve extra descriptors
and I'm not sure how safe it would be to let the programs arbitrarily
mess with the descriptor queues like that.
I'll probably keep this kfunc approach for v2 rfc for now (will try to
get rid of the complicated attachment at least), but let's keep
discussing.

