Return-Path: <netdev+bounces-9310-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C9D0728673
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 19:38:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D33BF1C2103B
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 17:38:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99E331DCC7;
	Thu,  8 Jun 2023 17:38:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F3A18011;
	Thu,  8 Jun 2023 17:38:51 +0000 (UTC)
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E281D2D55;
	Thu,  8 Jun 2023 10:38:46 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-977d7bdde43so191834866b.0;
        Thu, 08 Jun 2023 10:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686245925; x=1688837925;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ff0sWLws5Xaq7O24yT6WqYHWuKSh3wtpXB/C2lu5Ovk=;
        b=mu/l35IYxUbQLaIyq4ylFKbzYLiErz85A9NiSRiqQOfX9yUdP7jIYoc1h4f9gVsNmW
         LwBPOjDW46jPLbBpZUOpoF8FSaKaFImNKIda/d6A8E7wwo71DZ/C8KhRJv9K1UfQ+IWe
         Ch6Pqei1KFgLqFYAdwCLFFF9LWuvqqKJQtWyShFOqO1rCA6cLu5YBr2wP8R+nRT11/UK
         P53xP0aaXmFc/RGmZyh51K7UrBJI2RhqUWY6OW9etGsAGFvsEY+Oxdz/I56PoYW9VWrK
         5PS6PctZSbQ3nY7sYM3x2hsVt0yyLADscCysobVbMvhdqtJdf+sqMlhjqvrlf1qwAqnx
         aw3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686245925; x=1688837925;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ff0sWLws5Xaq7O24yT6WqYHWuKSh3wtpXB/C2lu5Ovk=;
        b=i5T/nUSyrnPrXd1OVWkD8yIW07rypRlV6qK7NrxEnm6eW4ya3DTYS9kAGMGyLufiDY
         CzDeTumdc9IG4lR3e2Spa3pCN3ppF3TMerkuDyCaEaU/r7w0HwUJig9shJwxgQxV78b2
         tgf3uOC9dzTDVOy8yy+keibfDrjp/7djUMb8mSXnVX6kbHElU0NzsoUnrae6WTGNbSDF
         DZ+76jHgh0VsXzrqPceJmBv0swRRBxNnBFQ3JNvbbG1Pg640S8rxtQPeGYHgOEmR7dDX
         ertHiTqLBJpUIlw1qeSNkcqwQzf5+yfPHVkNWTbxakFGAkQyArLwgeN9zqPaCLrUFpw3
         TwkA==
X-Gm-Message-State: AC+VfDwylnSTv2jKa43DOxagUY+E8GqnIbX+x9N1lRix/665o49Reu60
	oDZCEz9ZXmhaGOFLf05Z203r0w0L/NrKJaaf/PA=
X-Google-Smtp-Source: ACHHUZ6A6ALkrrYZIfKPIjiS+4jEmJ2VMv12VuJ+B5kUum8b8htMh10NQ9KfQkviuKvmjuiqVUPeNbhWSf+dOYXJWjI=
X-Received: by 2002:a17:906:58d5:b0:977:e501:cc01 with SMTP id
 e21-20020a17090658d500b00977e501cc01mr288236ejs.24.1686245925056; Thu, 08 Jun
 2023 10:38:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZH4a1l1pfG8ewo3v@google.com> <20230608125820.726340-1-zhangmingyi5@huawei.com>
 <CAKH8qBunUNSHDHQysavzS2PwXuro8aHanS8_3=8GYSEvib=5SQ@mail.gmail.com>
In-Reply-To: <CAKH8qBunUNSHDHQysavzS2PwXuro8aHanS8_3=8GYSEvib=5SQ@mail.gmail.com>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Thu, 8 Jun 2023 10:38:32 -0700
Message-ID: <CAEf4Bzb2_THiWkqNRnbN5LsOif6+9=GY7LrtEbQf6o24cihhMQ@mail.gmail.com>
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

On Thu, Jun 8, 2023 at 9:27=E2=80=AFAM Stanislav Fomichev <sdf@google.com> =
wrote:
>
> On Thu, Jun 8, 2023 at 6:00=E2=80=AFAM zhangmingyi <zhangmingyi5@huawei.c=
om> wrote:
> >
> > On 06/06,Stanislav Fomichev wrote:
> >
> > > On 06/05, Xin Liu wrote:
> > > > From: zhangmingyi <zhangmingyi5@huawei.com>
> > >
> > > > The sample_cb of the ring_buffer__new interface can transfer NULL. =
However,
> > > > the system does not check whether sample_cb is NULL during
> > > > ring_buffer__poll, null pointer is used.
> >
> > > What is the point of calling ring_buffer__new with sample_cb =3D=3D N=
ULL?
> >
> > Yes, as you said, passing sample_cb in ring_buffer__new to NULL doesn't
> > make sense, and few people use it that way, but that doesn't prevent th=
is
> > from being a allowed and supported scenario. And when ring_buffer__poll=
 is
> > called, it leads to a segmentation fault (core dump), which I think nee=
ds
> > to be fixed to ensure the security quality of libbpf.
>
> I dunno. I'd argue that passing a NULL to ring_buffer__new is an API
> misuse. Maybe ring_buffer__new should return -EINVAL instead when
> passed NULL sample_cb? Although, we don't usually have those checks
> for the majority of the arguments in libbpf...

Right. I'd say we should add a proper doc comment specifying all
arguments and which ones are optional or not. And make it explicit
that callback is not optional. If we start checking every possible
pointer for NULL, libbpf will be littered with NULL checks, I'm not
sure that's good.

