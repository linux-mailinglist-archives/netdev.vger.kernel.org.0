Return-Path: <netdev+bounces-6645-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 546E07172B3
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 02:43:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EFDE7281391
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 00:43:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FA80EA2;
	Wed, 31 May 2023 00:43:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4456DA2C
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 00:43:47 +0000 (UTC)
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67D249C
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 17:43:45 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id 3f1490d57ef6-ba81deea9c2so4270895276.2
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 17:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1685493824; x=1688085824;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1/oAwJGlwKSXBBQEzawNWNQ9i/zt5Pzts7gvYFvtYC0=;
        b=lhD1lOYekmBuEsLK5qYKmk71HbSkznThmTtG8JQmnRRe7zRY9blED2v2Q5u1YDSjOT
         wuYbkClIr0SmN9ImQFMYfiMEvmWECmDTJqzhaIkj+Rd1xf5SzbVjtuLa6mYPRR1pcgvh
         f6teQyZqEhWnUW6TcaJt5tvhD/1mR3MsCybrWHMNRkb0QzpEQ/FyAln8ZbKy+bXt8SxA
         mdve213afEVOCwUznD/E5okkkoM+7wU/TEX0DTakyEvLbi9Ei3w7TK80nUvyU/wi+t9q
         sANWWFtpeoYehrJdUuONNoDTB/4aa9/ild9WAElh2+5Ci/SfPIY/NxfLfHX1Md6KDaPR
         risw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685493824; x=1688085824;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1/oAwJGlwKSXBBQEzawNWNQ9i/zt5Pzts7gvYFvtYC0=;
        b=LyXlXhFRwZ0oq4J/+Xqc8/oTuoBfAcCSWhJTOr5Sw7BQPeVtxdolGv9+PfwcF857CT
         4eKUnrZmHuaHkcOVWm6MP2qCZD2srfOr2hzVh554VTCPflqgAQfKzAiTba8lYv3R3l0X
         OU02KZmZHKYNlYHbIeaaqamV/d9KG8F913WZ+yGwA2jmR+HBZDvXANTzuUqqoQ3tKR8X
         4mbyXXvTSTNpJ6e7OSDI+z/4UQ2P59nBW0JkRee6EpAq3OJ/513JYfJfrg2MZBdcha+p
         2WEoaO+jU6F9tXzc9u7hd/R2vduX7qHSl7Jak/VZgNtq3k5O7jc8nuHtE3ayGXB0yB2C
         W5+w==
X-Gm-Message-State: AC+VfDwsNCYPTh8EOpFLLDAqgDYFDSJqq4UVPUIR3rtyz5pbFA2SSbTk
	QO732XJq9EFd+1rVcbeKOIus69Y+kWpukp13GCWMKw==
X-Google-Smtp-Source: ACHHUZ4ifpQxY8Tm2dCr8bNiyE+/CQ/2ypZOjUvOOPqLWVyZw9Fs0Xs+4qCQzEXy70k1RSsB68o9Ak/UFMabKnC3Xxg=
X-Received: by 2002:a0d:d58d:0:b0:565:9fc5:f0a1 with SMTP id
 x135-20020a0dd58d000000b005659fc5f0a1mr4247736ywd.36.1685493824612; Tue, 30
 May 2023 17:43:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230527093747.3583502-1-shaozhengchao@huawei.com>
 <CAM0EoMkrpShprVbWSFN3FpFWtK9494Hyo+mOSNOJmXCFoieN7Q@mail.gmail.com>
 <c135ae5a-37ff-aa89-a3f7-976799181a04@huawei.com> <ZHRpfB2NatdM6fHJ@C02FL77VMD6R.googleapis.com>
 <CAM0EoMk+zO0RcnJ4Uie7jU+MNdFz7Mc37W223jVZip62QMRdzQ@mail.gmail.com>
 <ZHVAlCtzFeJrwKvc@C02FL77VMD6R.googleapis.com> <9cf98c8ae48c99850a0a25ae7919420ce5dfa7b4.camel@redhat.com>
In-Reply-To: <9cf98c8ae48c99850a0a25ae7919420ce5dfa7b4.camel@redhat.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Tue, 30 May 2023 20:43:33 -0400
Message-ID: <CAM0EoMkLUPLJgiJBpdVWqH_-tOT4ijgvq-jT5D3hV-vW4k6niQ@mail.gmail.com>
Subject: Re: [PATCH net] net: sched: fix NULL pointer dereference in mq_attach
To: Paolo Abeni <pabeni@redhat.com>
Cc: Peilin Ye <yepeilin.cs@gmail.com>, shaozhengchao <shaozhengchao@huawei.com>, 
	netdev@vger.kernel.org, xiyou.wangcong@gmail.com, jiri@resnulli.us, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
	weiyongjun1@huawei.com, yuehaibing@huawei.com, wanghai38@huawei.com, 
	peilin.ye@bytedance.com, cong.wang@bytedance.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 6:16=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wro=
te:
>
> On Mon, 2023-05-29 at 17:17 -0700, Peilin Ye wrote:
> > On Mon, May 29, 2023 at 09:53:28AM -0400, Jamal Hadi Salim wrote:
> > > On Mon, May 29, 2023 at 4:59=E2=80=AFAM Peilin Ye <yepeilin.cs@gmail.=
com> wrote:
> > > > Ack, they are different: patch [4/6] prevents ingress (clsact) Qdis=
cs
> > > > from being regrafted (to elsewhere), and Zhengchao's patch prevents=
 other
> > > > Qdiscs from being regrafted to ffff:fff1.
> > >
> > > Ok, at first glance it was not obvious.
> > > Do we catch all combinations? for egress (0xffffffff) allowed minor i=
s
> > > 0xfff3 (clsact::) and 0xffff. For ingress (0xfffffff1) allowed minor
> > > is 0xfff1 and 0xfff2(clsact).
> >
> > ffff:fff1 is special in tc_modify_qdisc(); if minor isn't fff1,
> > tc_modify_qdisc() thinks user wants to graft a Qdisc under existing ing=
ress
> > or clsact Qdisc:
> >
> >       if (clid !=3D TC_H_INGRESS) {     /* ffff:fff1 */
> >               p =3D qdisc_lookup(dev, TC_H_MAJ(clid));
> >               if (!p) {
> >                       NL_SET_ERR_MSG(extack, "Failed to find specified =
qdisc");
> >                       return -ENOENT;
> >               }
> >               q =3D qdisc_leaf(p, clid);
> >       } else if (dev_ingress_queue_create(dev)) {
> >               q =3D dev_ingress_queue(dev)->qdisc_sleeping;
> >       }
> >
> > This will go to the "parent !=3D NULL" path in qdisc_graft(), and
> > sch_{ingress,clsact} doesn't implement cl_ops->graft(), so -EOPNOTSUPP =
will
> > be returned.
> >
> > In short, yes, I think ffff:fff1 is the only case should be fixed.
> >
> > By the way I just noticed that currently it is possible to create a e.g=
.
> > HTB class with a class ID of ffff:fff1...
> >
> >   $ tc qdisc add dev eth0 root handle ffff: htb default fff1
> >   $ tc class add dev eth0 \
> >             parent ffff: classid ffff:fff1 htb rate 100%
> >
> > Regrafting a Qdisc to such classes won't work as intended at all.  It's=
 a
> > separate issue though.
>
> Jamal, are you ok with the above explanation? Perhaps it would be
> worthy to add a specific test-case under tc-testing for this issue?
>

I am fine with this one going in as is and then adding tests. I will ACK it=
.

cheers,
jamal

> Thanks!
>
> Paolo
>

