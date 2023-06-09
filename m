Return-Path: <netdev+bounces-9403-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F0212728C8A
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 02:38:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5B6E61C2102C
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 00:38:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18324806;
	Fri,  9 Jun 2023 00:38:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E657E9
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 00:38:54 +0000 (UTC)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81ECC2697
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 17:38:53 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-babb7aaa605so1702248276.3
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 17:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686271132; x=1688863132;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IMv7bVkUUcnqwhmfoR0ZF7SphueySjqoo8TOSh1kHkk=;
        b=1JQbaKRTWFImc9BL3qs6yXQrMrYGdCcjhMSAAbJa7+Ixd9ClbytA/SQHUgfBBJIlTp
         K8zsU6ZwCEYsVtf/LQl3RXJvOR/cPRHvhhn3MIxNUE/u0G1Gy0E2yYwmkRTZ02H6vn2h
         Ga5lxvqcBHR/5Z9wCn3CGfhkEFfl9oxThJTqBcfNJEISEpt9Kncq7ZdWodW0XCj3gh96
         +w0xxCVk+IJy5eEuRZDs7bwt9Pje1MdTP4WYpp9eMbB6ARvbgoGtJIfghdR1Msc4mllZ
         QCYnxiVUZWTgJsIr6OfQA2kFhdWhNViGfae3/6swkGpBY4mHyL29d9aa9nI4tYOqWUwN
         PWrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686271132; x=1688863132;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=IMv7bVkUUcnqwhmfoR0ZF7SphueySjqoo8TOSh1kHkk=;
        b=i4BxCMu0LnjPRdIf6Dgz5OpxSq3ZqdjgpiZPzrP6bUiF+5FtODC1kmsb6s0TriUUhA
         nGcmJS4CWQE7vB9wulXUiUm4Uv4YBz0mJaf0Db3YvuPZ0pXetEbCWkdWx248F4eAdzgm
         Ut2B2VOKc6bzd3CZaHl7z3CdbQoSoPYNZ53HJPYbPq7JmBBlhgqmcJi8r2IoBoacIn9G
         90R23tmvsx9cUrtQyrBu4rOWI7OucUNFUmQbBup17cAx5u8qpQCaqxoCQb9s8+9AD20M
         aVn7qKLu9UkXNeM85CecqFgdX2kbY5AfoAS4V9ZYmU0Mx3olMXQQNkhXLKmfmYAOqNTX
         1wPA==
X-Gm-Message-State: AC+VfDwEtuSxka9JJ5cIErfe3f/cYBIZH7BOUY8HdRCzDQpaeUUoVKKK
	Rvu05J/59KLEpUamO4DXuSKGo10=
X-Google-Smtp-Source: ACHHUZ76QV07vrx86ltGwNfeS8PZp0AVgn6T17uviRY9Ua8GIp1Pn1CG/0dpzfOLrA2vIUwTot2EHA0=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a25:ba4e:0:b0:ba8:1e83:af32 with SMTP id
 z14-20020a25ba4e000000b00ba81e83af32mr654101ybj.1.1686271132771; Thu, 08 Jun
 2023 17:38:52 -0700 (PDT)
Date: Thu, 8 Jun 2023 17:38:50 -0700
In-Reply-To: <CAEf4Bza9Dwi0_75CGPjdoirg97aoygLkChu-6q2DbOnRwZKGZQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230607192625.22641-1-daniel@iogearbox.net> <20230607192625.22641-2-daniel@iogearbox.net>
 <ZIIOr1zvdRNTFKR7@google.com> <CAEf4BzbEf+U53UY6o+g5OZ6rg+T65_Aou4Nvrdbo-8sAjmdJmA@mail.gmail.com>
 <ZIJNlxCX4ksBFFwN@google.com> <CAEf4BzYbr5G8ZGnWEndiZ1-7_XqYfKFTorDvvafwZY0XJUn7cw@mail.gmail.com>
 <ZIJe5Ml6ILFa6tKP@google.com> <CAADnVQLL8bQxXkGfwc4BTTkjoXx2k_dANhwa0u0kbnkVgm730A@mail.gmail.com>
 <CAEf4Bza9Dwi0_75CGPjdoirg97aoygLkChu-6q2DbOnRwZKGZQ@mail.gmail.com>
Message-ID: <ZIJ0mk8JQiJ2nvzp@google.com>
Subject: Re: [PATCH bpf-next v2 1/7] bpf: Add generic attach/detach/query API
 for multi-progs
From: Stanislav Fomichev <sdf@google.com>
To: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>, Daniel Borkmann <daniel@iogearbox.net>, 
	Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Nikolay Aleksandrov <razor@blackwall.org>, 
	John Fastabend <john.fastabend@gmail.com>, Jakub Kicinski <kuba@kernel.org>, Daniel Xu <dxu@dxuuu.xyz>, 
	Joe Stringer <joe@cilium.io>, 
	"Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?=" <toke@kernel.org>, "David S. Miller" <davem@davemloft.net>, bpf <bpf@vger.kernel.org>, 
	Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 06/08, Andrii Nakryiko wrote:
> On Thu, Jun 8, 2023 at 4:55=E2=80=AFPM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Thu, Jun 8, 2023 at 4:06=E2=80=AFPM Stanislav Fomichev <sdf@google.c=
om> wrote:
> > >
> > > I'm not really concerned about our production environment. It's prett=
y
> > > controlled and restricted and I'm pretty certain we can avoid doing
> > > something stupid. Probably the same for your env.
> > >
> > > I'm mostly fantasizing about upstream world where different users don=
't
> > > know about each other and start doing stupid things like F_FIRST wher=
e
> > > they don't really have to be first. It's that "used judiciously" part
> > > that I'm a bit skeptical about :-D
> > >
> > > Because even with this new ordering scheme, there still should be
> > > some entity to do relative ordering (systemd-style, maybe CNI?).
> > > And if it does the ordering, I don't really see why we need
> > > F_FIRST/F_LAST.
> >
> > +1.
> > I have the same concerns as expressed during lsfmmbpf.
> > This first/last is a foot gun.
> > It puts the whole API back into a single user situation.
> > Without "first api" the users are forced to talk to each other
> > and come up with an arbitration mechanism. A daemon to control
> > the order or something like that.
> > With "first api" there is no incentive to do so.
>=20
> If Cilium and some other company X both produce, say, anti-DDOS
> solution which cannot co-exist with any other anti-DDOS program and
> either of them needs to guarantee that their program runs first, then
> FIRST is what would be used by both to prevent accidental breakage of
> each other (which is basically what happened with Cilium and some
> other networking solution, don't remember the name). It's better for
> one of them to loudly fail to attach than silently break other
> solution with end users struggling to understand what's going on.
>=20
> You and Stanislav keep insisting that any combination of any BPF
> programs should co-exist, and I don't understand why we can or should
> presume that. I think we are conflating generic API (and kernel *not*
> making any assumptions about such API usage) with encouraging
> collaborative BPF attachment policies. They are orthogonal and are not
> in conflict with each other.
>=20
> But we lived without FIRST/LAST guarantees till now, that's fine, I'll
> stop fighting this.

I'm not saying this situation where there are several incompatible programs
doesn't exist. All I'm saying is that imo this is a policy that doesn't
belong to the kernel. Or maybe even let's put it that way: F_FIRST and
F_LAST isn't flexible enough to express this policy. External
systemd-like arbiter should express the dependencies/ordering/conflicts/etc=
.
And F_BEFORE and F_AFTER is enough for that sysmted-like entity to do the
rest.

