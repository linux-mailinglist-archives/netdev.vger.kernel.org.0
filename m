Return-Path: <netdev+bounces-9655-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6375972A214
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 20:24:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E9DF928191B
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 18:24:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEDC021063;
	Fri,  9 Jun 2023 18:24:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A6C14262;
	Fri,  9 Jun 2023 18:24:05 +0000 (UTC)
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC17935A9;
	Fri,  9 Jun 2023 11:24:03 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-977d0ee1736so310313766b.0;
        Fri, 09 Jun 2023 11:24:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686335042; x=1688927042;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g+A8wixS0zjvyB9FSD1Erdd296FgN5bJlGC3/Xdlkho=;
        b=jgNDUp5BePly7KqpLWqI5CHYUr1iXuk7PkNIWSIi9i8hk0Lj0f4LLl8feCzvtS2ahP
         eQ7oGkdmWsAdXXjfmnosYFXZqoXR8c7Pn4eiNjrVouH9nWh7+GFim3wL9vrO/nbK6Cx2
         Olr1mxHD+6F0HBxkMitvCNEX6YeVWponr+mjPi5cKQ5NvYUzFJTK5TrtewxaG5QxlcAX
         ENk4X36LeMbtXxHny0HsHHxdfNmjOigp8L/MP+wmydf1VGw3GN63zGZgShBuMLZtTvbW
         7ivgFxsml90jULinc8Ks+4k7bk53UD/KKU9Duuijr8+i1msMp9ZsFu0SIXoYkagOaHxp
         xbFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686335042; x=1688927042;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g+A8wixS0zjvyB9FSD1Erdd296FgN5bJlGC3/Xdlkho=;
        b=AfCttxPT9ofHeFlk+tROodtQmP8QoTqpB6g3bZK/1jo9kRxJzbrdPAHLBViyskNqme
         CwtqrIVdK3NB989v2mf5bk341ipKAUd+NeOEs9PCIqTTln1NNPdKOAc/WQAgMnZb07yr
         mmYqZk85z+LUfcrsgEvkKnCsnY7adJd6IN/kJzcu4FwV7ZiU+aPy7dCJ1M9xUIW2mikW
         Ht8+b+2ktXmDM5Jo4oFjhucux61qohab0Obxw2Y3nqicGa90wc0pPmwDUeZFyhodpzqr
         4qZ2QVPy55H7W4wEdmCnY23jYC4LgYsOlmPb212ZeD3qze0g8mBI1jX0vWn/ctgM/9fi
         CuvA==
X-Gm-Message-State: AC+VfDyXz02rEloB9Ta366NEd/Jm6YTV6NRy0YWq17D4k5FlPOzTcTqd
	NKFRRlnKn1O2eqAhQ7q2aG7aIgTEWsf0vVgAnY8=
X-Google-Smtp-Source: ACHHUZ41grNXcAaSN/FbUbD/K3aeEdP27CBX3nRFj/kMa6Hcz0aQbohBZXCBjHCNLTgPsIBWfvjirkFsOb5wWtHjXr8=
X-Received: by 2002:a17:906:ef01:b0:94f:395b:df1b with SMTP id
 f1-20020a170906ef0100b0094f395bdf1bmr2458080ejs.21.1686335042073; Fri, 09 Jun
 2023 11:24:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAEf4Bzb2_THiWkqNRnbN5LsOif6+9=GY7LrtEbQf6o24cihhMQ@mail.gmail.com>
 <20230609093625.727490-1-zhangmingyi5@huawei.com> <CAKH8qBu0AiB_0SZgU5N8EOmm4=hp5BRe=Yp5PHbyT1ZbRjdeOw@mail.gmail.com>
In-Reply-To: <CAKH8qBu0AiB_0SZgU5N8EOmm4=hp5BRe=Yp5PHbyT1ZbRjdeOw@mail.gmail.com>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Fri, 9 Jun 2023 11:23:50 -0700
Message-ID: <CAEf4BzZdpL3k5G4kY2t0xPs2YALz45O+MEmY672b409CvfL4NQ@mail.gmail.com>
Subject: Re: [PATCH] libbpf:fix use empty function pointers in ringbuf_poll
To: Stanislav Fomichev <sdf@google.com>
Cc: zhangmingyi <zhangmingyi5@huawei.com>, andrii@kernel.org, ast@kernel.org, 
	bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net, 
	edumazet@google.com, hsinweih@uci.edu, jakub@cloudflare.com, 
	john.fastabend@gmail.com, kongweibin2@huawei.com, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, liuxin350@huawei.com, netdev@vger.kernel.org, 
	pabeni@redhat.com, syzbot+49f6cef45247ff249498@syzkaller.appspotmail.com, 
	syzkaller-bugs@googlegroups.com, wuchangye@huawei.com, xiesongyang@huawei.com, 
	yanan@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 9, 2023 at 9:55=E2=80=AFAM Stanislav Fomichev <sdf@google.com> =
wrote:
>
> On Fri, Jun 9, 2023 at 2:38=E2=80=AFAM zhangmingyi <zhangmingyi5@huawei.c=
om> wrote:
> >
> > On Fri, Jun 9, 2023 at 1:39 AM Andrii Nakryiko <andrii.nakryiko@gmail.c=
om> wrote:
> >
> > > On Thu, Jun 8, 2023 at 9:27=E2=80=AFAM Stanislav Fomichev <sdf@google=
.com> wrote:
> > > >
> > > > On Thu, Jun 8, 2023 at 6:00=E2=80=AFAM zhangmingyi <zhangmingyi5@hu=
awei.com> wrote:
> > > > >
> > > > > On 06/06,Stanislav Fomichev wrote:
> > > > >
> > > > > > On 06/05, Xin Liu wrote:
> > > > > > > From: zhangmingyi <zhangmingyi5@huawei.com>
> > > > > >
> > > > > > > The sample_cb of the ring_buffer__new interface can transfer =
NULL. However,
> > > > > > > the system does not check whether sample_cb is NULL during
> > > > > > > ring_buffer__poll, null pointer is used.
> > > > >
> > > > > > What is the point of calling ring_buffer__new with sample_cb =
=3D=3D NULL?
> > > > >
> > > > > Yes, as you said, passing sample_cb in ring_buffer__new to NULL d=
oesn't
> > > > > make sense, and few people use it that way, but that doesn't prev=
ent this
> > > > > from being a allowed and supported scenario. And when ring_buffer=
__poll is
> > > > > called, it leads to a segmentation fault (core dump), which I thi=
nk needs
> > > > > to be fixed to ensure the security quality of libbpf.
> > > >
> > > > I dunno. I'd argue that passing a NULL to ring_buffer__new is an AP=
I
> > > > misuse. Maybe ring_buffer__new should return -EINVAL instead when
> > > > passed NULL sample_cb? Although, we don't usually have those checks
> > > > for the majority of the arguments in libbpf...
> > >
> > > Right. I'd say we should add a proper doc comment specifying all
> > > arguments and which ones are optional or not. And make it explicit
> > > that callback is not optional. If we start checking every possible
> > > pointer for NULL, libbpf will be littered with NULL checks, I'm not
> > > sure that's good.
> >
> > I agree, we should add a proper doc comment specifying all
> > arguments and which ones are optional or not.
> > However, why does the external interface API in libbpf not verify input
> > parameters or add verification where risky operations may exist?
> > What's more, i think sample_cb=3DNULL is not strictly a mistake or
> > prohibited use, and is meaningless.
>
> It's not really customary in C to do it? So maybe you can follow up
> with the update to the doc?

Yep, we do not check every `struct bpf_object *` pointer to be non-NULL.

Having said that, I don't think it's such a big deal to make this
callback optional by assigning a no-op callback.

So let's definitely update doc comments to be explicit about one way
or the other. For the callback, let's just not do it on every record.
Just once during initialization would be better.

>
> The kindergarten is over, you pass NULL you get SIGSEGV :-D

