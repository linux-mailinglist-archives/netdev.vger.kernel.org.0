Return-Path: <netdev+bounces-6002-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 15800714564
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 09:25:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A94AE280DF4
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 07:25:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0EE7EC1;
	Mon, 29 May 2023 07:25:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2084A5B
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 07:25:20 +0000 (UTC)
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E92CA7;
	Mon, 29 May 2023 00:25:19 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id 38308e7fff4ca-2af2602848aso29915771fa.2;
        Mon, 29 May 2023 00:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685345117; x=1687937117;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7dbJswxuikSdGXOWoUBNPK1HqbQyPIndcOVtASk695c=;
        b=d3e3ndgdfD6fKBWEdpcCFSfICCQiSidpzlKnI/vYKnkIi4znfmdBzgcBTXv776E0tS
         uMXUFP+7uojCP3A0cxMlt9p71bELw+AoqDWf/O+Fnecp+6y5MXbMSTpW+bm9CJAIvQPl
         8IEpA7OZtWb0VoCgiMJdR49quBJaJXnvRE+mLuX1pMTyTgmdNOLF5v1hnlZvoq0cKriC
         XOBsBQ1pHVVzGwhXSHkKOoENz03VO3WfMdhOuLuLAOvDPgkb8Lk8DUEiPMbykLDENjMu
         q6l1vCOJe7Cl4LVJEVP2N36t5abtJPiZ2ShxtrCgVQYK7+1PF2o+som5hBD+ZGFzPFNf
         wLzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685345117; x=1687937117;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7dbJswxuikSdGXOWoUBNPK1HqbQyPIndcOVtASk695c=;
        b=fS9CAZQ/gCW9vXgAEly80zyX35QJsNFsirVBKc25ippklxVetNN6gNPRcM/0C3uOmd
         sTBbCVM5kjEE7hfOzldOqieXfcIsmQtVq2INLouexYc+myj+i0ghV3ERmQlzLk9U+VIi
         xZqT4BcngKhuMWOfCGOQO5TVyDD0FL0YmrjikDkf4zOzhERkyuOY8ChvnjpJveYH84ow
         +wezfFj7NGWOl3mwDqmezSp/rJA6JSBkx42xjXI7mcldAOZPd3+FYPiKUNkU/YT8eEqv
         5UOgxmLCk9sDDxe9zIRC3C7dC5EQb90p8+nfsVxtO++nyP4IF8+HvVKRtKryqBW03bV8
         nVbw==
X-Gm-Message-State: AC+VfDxjfG7LU1UBoFcDiJaIdmJLxcAPF5mNbWGGxj7Kl0BbM/B0nEkV
	FeOuOsM5uYX3a1gGWAdmmsFOr4aTIp8W72WegTE=
X-Google-Smtp-Source: ACHHUZ52xFgAKpl/EmO2rDkI6Nn8eyjYwvFWa7SRSG7SY1gEZCSW9S5AmsC8FWr+kNxgngXqcOo0ahzZ8W9QKCbZXZM=
X-Received: by 2002:a05:651c:d0:b0:2a8:b7e9:82ee with SMTP id
 16-20020a05651c00d000b002a8b7e982eemr3451083ljr.1.1685345117194; Mon, 29 May
 2023 00:25:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230526054621.18371-1-liangchen.linux@gmail.com> <20230528021008-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230528021008-mutt-send-email-mst@kernel.org>
From: Liang Chen <liangchen.linux@gmail.com>
Date: Mon, 29 May 2023 15:25:04 +0800
Message-ID: <CAKhg4tLA9z0rMEzRJ8tRt+1jQtS9z74Se2Wvwc5SKEk=WgSd2Q@mail.gmail.com>
Subject: Re: [PATCH net-next 1/5] virtio_net: Fix an unsafe reference to the
 page chain
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: jasowang@redhat.com, virtualization@lists.linux-foundation.org, 
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

On Sun, May 28, 2023 at 2:16=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Fri, May 26, 2023 at 01:46:17PM +0800, Liang Chen wrote:
> > "private" of buffer page is currently used for big mode to chain pages.
> > But in mergeable mode, that offset of page could mean something else,
> > e.g. when page_pool page is used instead. So excluding mergeable mode t=
o
> > avoid such a problem.
> >
> > Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
>
> Ugh the subject makes it looks like current code has a problem
> but I don't think so because I don't think anything besides
> big packets uses page->private.
>
> The reason patch is needed is because follow up patches
> use page_pool.
> pls adjust commit log and subject to make all this clear.
>
>
> > ---
> >  drivers/net/virtio_net.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 5a7f7a76b920..c5dca0d92e64 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -497,7 +497,7 @@ static struct sk_buff *page_to_skb(struct virtnet_i=
nfo *vi,
> >                       return NULL;
> >
> >               page =3D (struct page *)page->private;
> > -             if (page)
> > +             if (!vi->mergeable_rx_bufs && page)
>
> To be safe let's limit to big packets too:
>
>         if (!vi->mergeable_rx_bufs && vi->big_packets && page)
>
>
>

Sure, thanks!

> >                       give_pages(rq, page);
> >               goto ok;
> >       }
> > --
> > 2.31.1
>

