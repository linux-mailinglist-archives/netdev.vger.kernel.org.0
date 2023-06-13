Return-Path: <netdev+bounces-10505-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EF68872EBF9
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 21:30:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1E6D81C20947
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 19:30:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C7FD3D391;
	Tue, 13 Jun 2023 19:30:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FD017FE6;
	Tue, 13 Jun 2023 19:30:37 +0000 (UTC)
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0C8F19F;
	Tue, 13 Jun 2023 12:30:32 -0700 (PDT)
Received: by mail-ua1-x92f.google.com with SMTP id a1e0cc1a2514c-78a03acc52aso559338241.3;
        Tue, 13 Jun 2023 12:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686684631; x=1689276631;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fqoXuAD76sA/z06oNkvyQVKnlwn98lfYWJQruP8R3vs=;
        b=HeOYCeB3N4cLjVzNTcVuJ2DoHwzJkAzY1bcl0t2nYV65yU8fCeoDW0MBtJXN0FDngH
         iPcJLtngbJ6Htn6I/Z9wXe6OLOOFWI5/HH7wgeYfdE40ex1ylmmNxRMdH/JkrjxFygDf
         bK/WyNUQqdCqdF0q12HtToLb4uAj+lY3CiARvyrYIPuSDpJHHsiRH8tFsBjTgKKj4940
         FWZNkqXbzeSXQKpkzBbYOHyH939BvCXkC2LJCEazArswka0FCSq8Zk+UgHdMHupMVId5
         HWXLOpQDVoM7QgQgVkk/40GtdcXeeiaRH5mUQNk9SpoVgLIbbTyh72Rv/YwQ5JB6EXiR
         cgRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686684631; x=1689276631;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fqoXuAD76sA/z06oNkvyQVKnlwn98lfYWJQruP8R3vs=;
        b=glv5Cc4qNipbXjTP4jy9JYpN7qLttpEUaBt4T9glRNb22XjoAffNSmh7G76UQi06dI
         kOEGCN5CJj0gm/L9SfvDLyoMkuOVyzv8JTzyTmxB8xda2IIuP4h5DU7x4T7giXCsZmBE
         FVjqZuV4AKU/Bi0zB38msprsqIO5T0HKTKl94xLSfbol0vfqzsTkLLg58NTMHR/sZbvd
         18ORuWcarectIbEbWe4eaN0DMZoNs5QZl+bYfE7wMVl3XqYIpq9BrDGOP4zGabFrL4u6
         29sj+J0a7JmtRew6RFsLZ8BAjGtBOnJ94DQ+V2fCx2bjoPcCDBFc90NorpwXE0JMxi4l
         yqog==
X-Gm-Message-State: AC+VfDzAASoTacX9IENFM/yeIX2Hw08km5sesuBepmKkCDE/XwuM3dg+
	AA2TAGBLvOFXLvqYe4S16BUx+McSZ+nVi3QWbIM=
X-Google-Smtp-Source: ACHHUZ6NWHNb9pkP3XWHyC+31NH655Moq+4ZvXobRglhk0xC0Rvr9GdYcJ93KOnfLYznj8hnty48oMgr49sXdXFv68Q=
X-Received: by 2002:a67:ff91:0:b0:43b:3ad8:6886 with SMTP id
 v17-20020a67ff91000000b0043b3ad86886mr6311584vsq.16.1686684631661; Tue, 13
 Jun 2023 12:30:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230612172307.3923165-1-sdf@google.com> <20230612172307.3923165-4-sdf@google.com>
 <CAF=yD-LtxC8BeCyTWpqwziKto5DVjeg7maMjCkOZcWoihFHKzw@mail.gmail.com> <CAKH8qBvrTbY_jV-1qg2r9C3yXE3Rk4uN8B+fRm=XaZF5OAU-BA@mail.gmail.com>
In-Reply-To: <CAKH8qBvrTbY_jV-1qg2r9C3yXE3Rk4uN8B+fRm=XaZF5OAU-BA@mail.gmail.com>
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Tue, 13 Jun 2023 21:29:55 +0200
Message-ID: <CAF=yD-LA3VuLkj9YqbLH+SczOe+HzaUii_OdLdB6Ue=fm30eew@mail.gmail.com>
Subject: Re: [RFC bpf-next 3/7] bpf: implement devtx hook points
To: Stanislav Fomichev <sdf@google.com>
Cc: bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net, 
	andrii@kernel.org, martin.lau@linux.dev, song@kernel.org, yhs@fb.com, 
	john.fastabend@gmail.com, kpsingh@kernel.org, haoluo@google.com, 
	jolsa@kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 13, 2023 at 9:00=E2=80=AFPM Stanislav Fomichev <sdf@google.com>=
 wrote:
>
> On Tue, Jun 13, 2023 at 7:55=E2=80=AFAM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > On Mon, Jun 12, 2023 at 7:24=E2=80=AFPM Stanislav Fomichev <sdf@google.=
com> wrote:
> > >
> > > devtx is a lightweight set of hooks before and after packet transmiss=
ion.
> > > The hook is supposed to work for both skb and xdp paths by exposing
> > > a light-weight packet wrapper via devtx_frame (header portion + frags=
).
> > >
> > > devtx is implemented as a tracing program which has access to the
> > > XDP-metadata-like kfuncs. The initial set of kfuncs is implemented
> > > in the next patch, but the idea is similar to XDP metadata:
> > > the kfuncs have netdev-specific implementation, but common
> > > interface. Upon loading, the kfuncs are resolved to direct
> > > calls against per-netdev implementation. This can be achieved
> > > by marking devtx-tracing programs as dev-bound (largely
> > > reusing xdp-dev-bound program infrastructure).
> > >
> > > Attachment and detachment is implemented via syscall BPF program
> > > by calling bpf_devtx_sb_attach (attach to tx-submission)
> > > or bpf_devtx_cp_attach (attach to tx completion). Right now,
> > > the attachment does not return a link and doesn't support
> > > multiple programs. I plan to switch to Daniel's bpf_mprog infra
> > > once it's available.
> > >
> > > Cc: netdev@vger.kernel.org
> > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> >
> >
> > > @@ -2238,6 +2238,8 @@ struct net_device {
> > >         unsigned int            real_num_rx_queues;
> > >
> > >         struct bpf_prog __rcu   *xdp_prog;
> > > +       struct bpf_prog __rcu   *devtx_sb;
> > > +       struct bpf_prog __rcu   *devtx_cp;
> >
> > nit/subjective: non-obvious two letter acronyms are nr. How about tx
> > and txc (or txcomp)
>
> devtx and devtxc? I was using devtxs vs devtxc initially, but that
> seems confusing. I can probably spell them out here:
> devtx_submit
> devtx_complete
>
> Should probably be better?

That's more clear, thanks.

