Return-Path: <netdev+bounces-11327-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 318227329F1
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 10:35:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 270B91C20F97
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 08:35:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0883D1FCB;
	Fri, 16 Jun 2023 08:35:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB1A2ED8
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 08:35:20 +0000 (UTC)
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51C7F2D73;
	Fri, 16 Jun 2023 01:35:19 -0700 (PDT)
Received: by mail-ua1-x92f.google.com with SMTP id a1e0cc1a2514c-78cee27c08aso173222241.2;
        Fri, 16 Jun 2023 01:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686904518; x=1689496518;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xa0JZc7eBphPjsXnzUOS1pvJAQWh4xP/KX2Ib2VBPQc=;
        b=PaMEZ4R4/1Ok/v4fJso/HMXK85VCk6S31L705oon/fa/KcK+g3rxM3sHUI4cqguHTb
         wDLPXvWXNo3AK21asnnslRvBI5UMMZT0Qg8xHvBFsx1dUdoH0R4JwPWy42z/r/giE6ws
         kB8/HxnW49NzobU5t5aGItCi1xg/FtvFoodsLywozf21nFzK23JzlCWq6WZLKTA1Vc8E
         mw8OyNQaUgVyZiNU+2+8L18ngYgalv6/ovXVqh3cFSX32gcbP3H19v6uOm339afFVXgA
         elNaI/8laQJcTP1BGm6i4FhaEAr6cCZHtkMV7eVsx0xHu81cAG3AltTkD1WQj1hin/1H
         2QKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686904518; x=1689496518;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xa0JZc7eBphPjsXnzUOS1pvJAQWh4xP/KX2Ib2VBPQc=;
        b=dL6L05bvNlkOwKX1yaG3oea6UwfFy0zYTvGT0hyOtIG0RaCxurLR4u8tOcvKZfcbn8
         hc430QZA8vSwl8S2LV/Vnpdx9OQGRcXS462X1WecBrkR8cxl74Pz7p+LEm/vH6RFWAjW
         IEpI9nz3FcS912/qyy+MnPBsur43t/9zoJshz2Nmz+aD/WhZPI9lem1KsDn4twDD8jiI
         61d1kEDHL78kB+IVEmY/CY31tWD3hDXH1qRKHQRXxyffyhHL/xkSk0AFnWxNu96zIjmM
         UDAEUp8zb03ky3+DoKntYGPMuMkzxwRnSS/Sdft73d6ruHPehsMA07CxabrKs52jH2Ti
         pVYQ==
X-Gm-Message-State: AC+VfDwOV+sQXBuQerHgLwrKu4Xz2iQRK+tXWBGwxWvyOpcWJUimyMB9
	nbqSXNButiQ35voTGcO1/7+ge4TuBddZtkl1Hb23fGqKQ/pUAw==
X-Google-Smtp-Source: ACHHUZ7llVomytPOl1BgEXNKtBoZYysnpYTW0U21yb1BzS0kyaBZfnlhFESmq9dBDoQ8ShS/ydF3v/N4ZO7Am03CJic=
X-Received: by 2002:a05:6102:390:b0:434:6958:cdc6 with SMTP id
 m16-20020a056102039000b004346958cdc6mr1277986vsq.19.1686904518329; Fri, 16
 Jun 2023 01:35:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1410156.1686729856@warthog.procyon.org.uk> <20230615222327.15e85c55@kernel.org>
In-Reply-To: <20230615222327.15e85c55@kernel.org>
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Fri, 16 Jun 2023 10:34:41 +0200
Message-ID: <CAF=yD-LLCoSTH1Jb+EFmpmTVO+Oo7Hjg6xcF4T2wR96QkjHZRw@mail.gmail.com>
Subject: Re: [PATCH net-next] ip, ip6: Fix splice to raw and ping sockets
To: Jakub Kicinski <kuba@kernel.org>
Cc: David Howells <dhowells@redhat.com>, netdev@vger.kernel.org, 
	syzbot+d8486855ef44506fd675@syzkaller.appspotmail.com, 
	David Ahern <dsahern@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Jens Axboe <axboe@kernel.dk>, 
	Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 16, 2023 at 7:23=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Wed, 14 Jun 2023 09:04:16 +0100 David Howells wrote:
> > Splicing to SOCK_RAW sockets may set MSG_SPLICE_PAGES, but in such a ca=
se,
> > __ip_append_data() will call skb_splice_from_iter() to access the 'from=
'
> > data, assuming it to point to a msghdr struct with an iter, instead of
> > using the provided getfrag function to access it.
> >
> > In the case of raw_sendmsg(), however, this is not the case and 'from' =
will
> > point to a raw_frag_vec struct and raw_getfrag() will be the frag-getti=
ng
> > function.  A similar issue may occur with rawv6_sendmsg().
> >
> > Fix this by ignoring MSG_SPLICE_PAGES if getfrag !=3D ip_generic_getfra=
g as
> > ip_generic_getfrag() expects "from" to be a msghdr*, but the other getf=
rags
> > don't.  Note that this will prevent MSG_SPLICE_PAGES from being effecti=
ve
> > for udplite.
> >
> > This likely affects ping sockets too.  udplite looks like it should be =
okay
> > as it expects "from" to be a msghdr.
>
> Willem, looks good?

Reviewed-by: Willem de Bruijn <willemb@google.com>

Disabling splicing if not ip_generic_getfrag sounds great to me.

