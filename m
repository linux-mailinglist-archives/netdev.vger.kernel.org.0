Return-Path: <netdev+bounces-6003-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 413A4714568
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 09:25:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E01471C20975
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 07:25:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D3C5EC1;
	Mon, 29 May 2023 07:25:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221E020E1
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 07:25:36 +0000 (UTC)
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75482AF;
	Mon, 29 May 2023 00:25:31 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id 38308e7fff4ca-2af1e290921so30115681fa.3;
        Mon, 29 May 2023 00:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685345129; x=1687937129;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fuA6Mx7qZk6GEXujcE9++nuvrgV08ZyqT/8PAv9VpyQ=;
        b=E+CGf+hSlas2ziMgKKa6jlYK0xVOwshz/Sz6tFHIvkH+2c2Sf06OVcWnyv3eFsh5LO
         xv7MLLUghSxQ3ASwLN2a853fG3gq89bwejLL/Q2oomoxGxFfGNuJirlLsb42Pr2J+WB+
         7hHsxD5ckzCRvIyqWo2VDSRuQFe/rAE/d+PHamsWvIFyn2mtQpFbjhSFW3OI/IBmqOZJ
         ng4Th1aQI1IUHLr1ob4xiD+a1l0PKm0DSm12Iu8uekGM76S9J7Jko0G8Y7rq0iWJJrB5
         wZUhcKyHdJCUnFZkmqFOOF9G3ELP8+LiT+EXDwXntA/b+HcoqMXlQKvdU8ezF/4dOQk+
         9hIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685345129; x=1687937129;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fuA6Mx7qZk6GEXujcE9++nuvrgV08ZyqT/8PAv9VpyQ=;
        b=Y/gOpDyX1eT/PFjf59hFX/RS0nscuaCjodZyc0amoTbMS4FH5NBzzv9771pXtB4cjN
         vZYQkEtsO+D5mFdDRRjJs7Nh7yUYPebQa9mMf4F4LBh2EORq8OC1io4PZKl+nC/G0fwU
         +QZ+LpdgYTkhgGEaFkXHV6actAk9sWTWvutvszy/sQUbPPKzkG1koGjXQnOCwIppZcem
         HPk+sZK5sxQ2IHFV+5aPwwhnOgAbdasGwul9CxTwkJ7ms9+0kgS2WLw5WKY49Ovr7JBp
         6bWzrrfXwH4BFm5GhaW1jwNQp+UkDctqUyzD2crYhg1E4SB7dW8qDI7en9b6TFGuuCds
         FewQ==
X-Gm-Message-State: AC+VfDwBZEJ55at8/WsfzkbLMDkNBXdFv5cfzmUtDAwPdj5u/kYYOgZX
	RtArX41X3W7H1S3G9m7nNE6tIxNzufS+qJWkALI=
X-Google-Smtp-Source: ACHHUZ6WwUCBaQyc2mmNPx0qmJK6CBQV/NW72H05zZW5Tej2BIzwSvwr6Vpj0zCrsm5svhM9IR7t/+qbyA0PaQiPooU=
X-Received: by 2002:a2e:6a18:0:b0:2ab:e50:315a with SMTP id
 f24-20020a2e6a18000000b002ab0e50315amr3293876ljc.51.1685345129439; Mon, 29
 May 2023 00:25:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230526054621.18371-1-liangchen.linux@gmail.com>
 <CACGkMEuUTNfHXQPg29eUZFnVBRJEmjjKN4Jmr3=Qnkgjj0B9PQ@mail.gmail.com> <20230528022737-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230528022737-mutt-send-email-mst@kernel.org>
From: Liang Chen <liangchen.linux@gmail.com>
Date: Mon, 29 May 2023 15:25:16 +0800
Message-ID: <CAKhg4tL1fkb8JR5+XH_toVDx_c79uH4-fXv8XTDe4gpOFc92VA@mail.gmail.com>
Subject: Re: [PATCH net-next 1/5] virtio_net: Fix an unsafe reference to the
 page chain
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>, virtualization@lists.linux-foundation.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	xuanzhuo@linux.alibaba.com, kuba@kernel.org, edumazet@google.com, 
	davem@davemloft.net, pabeni@redhat.com, alexander.duyck@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, May 28, 2023 at 2:29=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Fri, May 26, 2023 at 02:38:54PM +0800, Jason Wang wrote:
> > On Fri, May 26, 2023 at 1:46=E2=80=AFPM Liang Chen <liangchen.linux@gma=
il.com> wrote:
> > >
> > > "private" of buffer page is currently used for big mode to chain page=
s.
> > > But in mergeable mode, that offset of page could mean something else,
> > > e.g. when page_pool page is used instead. So excluding mergeable mode=
 to
> > > avoid such a problem.
> >
> > If this issue happens only in the case of page_pool, it would be
> > better to squash it there.
> >
> > Thanks
>
>
> This is a tiny patch so I don't care. Generally it's ok
> to first rework code then change functionality.
> in this case what Jason says os right especially because
> you then do not need to explain that current code is ok.
>

Sure. it will be squashed into the page pool enablement patch. Thanks!

> > >
> > > Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
> > > ---
> > >  drivers/net/virtio_net.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index 5a7f7a76b920..c5dca0d92e64 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -497,7 +497,7 @@ static struct sk_buff *page_to_skb(struct virtnet=
_info *vi,
> > >                         return NULL;
> > >
> > >                 page =3D (struct page *)page->private;
> > > -               if (page)
> > > +               if (!vi->mergeable_rx_bufs && page)
> > >                         give_pages(rq, page);
> > >                 goto ok;
> > >         }
> > > --
> > > 2.31.1
> > >
>

