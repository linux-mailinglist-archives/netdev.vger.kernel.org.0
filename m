Return-Path: <netdev+bounces-5894-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D81547134B7
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 14:33:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 86A851C20A02
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 12:33:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4B3679CF;
	Sat, 27 May 2023 12:33:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B1017FD
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 12:33:45 +0000 (UTC)
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 534ACF3;
	Sat, 27 May 2023 05:33:44 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id 38308e7fff4ca-2b03d3e41fcso31837011fa.0;
        Sat, 27 May 2023 05:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685190822; x=1687782822;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=luEVOxwc+hf1I6vnh0OMg4uHH06RianYGAZT40fbv6Q=;
        b=B36wSsFQrmHI133lMAzYbT/95M8XFCG5dcna7rLtoQT7qTWUkLxMO9uDXQfa0JpkFz
         faXPMxbI+2Uq5rE3ruOQKeEI200212EZZlFde2tAf5QjLGFO1UeVLw0S2NdhHu6MIDDf
         yKZgePb7HQxDP0XudTRIylVRhogwCRfW12v8BUAP0c4FGRZjnuXCYf6cddQcmbEejMiP
         BGNs8G2CeK5h4CehPTvq5KNkwcpubHCJlDU3ZZ4BsrvVCSEWmNZNcYDDTLVYWKhhJi2Z
         EUBkj+jfKLkkg9G4ktk+rfkZgm9QhLL5xhQv+N9t3guIB4lqB7b8+fRe2zKg0Kb7YEcQ
         lBVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685190822; x=1687782822;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=luEVOxwc+hf1I6vnh0OMg4uHH06RianYGAZT40fbv6Q=;
        b=ezV5LTnn0jyL9sHYvCanxJJrcpszlIs0SdgCLsm+cbL8k25FvEu1sqWTQ87D0ZSpsF
         e6N9ytndh6gTJ4lTsqgVUbJgoe7GqG1FUR3J25v5+/bNF5LNYLowONpmsve5Jp5xzWvb
         IVJ6TM1dXJqNAGFDtuE0KBLAoZzyNC7ISwjxyx2LoOuxoM6YERMu91hkDKQsAkP47Onb
         7t/toQH8EHFXnw4wJukiaD38HDpHjXNuukQfzG77zcB91ZPRVE2qDOR961lYjhBP8Okl
         b6j3rI77ZsSR+0oTpR0PeSQvNBqczVWiSy8lNSqljbAMZlvqMYxIyg3uCtoDgkOTwVpN
         piRg==
X-Gm-Message-State: AC+VfDwRA4BatJxeP1zgtcP7sytRMZTnc3B3Ud79Z9toanVKMeXbD7uo
	f9O2cX6OZw1txAdbw9HNQi/nVfbGJmV3F5tGviE=
X-Google-Smtp-Source: ACHHUZ687E19sFwfiVTq1KucDmWlzuq9ui7gdIxsrM7EyejJ5muKnlmEMqvbDs1wA7jDUKIkelHwH8HSxz4eb/Sp06w=
X-Received: by 2002:a2e:b94a:0:b0:2a7:b0b2:29 with SMTP id 10-20020a2eb94a000000b002a7b0b20029mr723614ljs.22.1685190822334;
 Sat, 27 May 2023 05:33:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230526054621.18371-1-liangchen.linux@gmail.com> <CACGkMEuUTNfHXQPg29eUZFnVBRJEmjjKN4Jmr3=Qnkgjj0B9PQ@mail.gmail.com>
In-Reply-To: <CACGkMEuUTNfHXQPg29eUZFnVBRJEmjjKN4Jmr3=Qnkgjj0B9PQ@mail.gmail.com>
From: Liang Chen <liangchen.linux@gmail.com>
Date: Sat, 27 May 2023 20:33:30 +0800
Message-ID: <CAKhg4tKGnXh32a8M1V-r7sP8uCSnyMYhoFXZTv3ixJOcJ1mWOg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/5] virtio_net: Fix an unsafe reference to the
 page chain
To: Jason Wang <jasowang@redhat.com>
Cc: mst@redhat.com, virtualization@lists.linux-foundation.org, 
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

On Fri, May 26, 2023 at 2:39=E2=80=AFPM Jason Wang <jasowang@redhat.com> wr=
ote:
>
> On Fri, May 26, 2023 at 1:46=E2=80=AFPM Liang Chen <liangchen.linux@gmail=
.com> wrote:
> >
> > "private" of buffer page is currently used for big mode to chain pages.
> > But in mergeable mode, that offset of page could mean something else,
> > e.g. when page_pool page is used instead. So excluding mergeable mode t=
o
> > avoid such a problem.
>
> If this issue happens only in the case of page_pool, it would be
> better to squash it there.
>
> Thanks

Sure, thanks!


>
> >
> > Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
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
> >                         return NULL;
> >
> >                 page =3D (struct page *)page->private;
> > -               if (page)
> > +               if (!vi->mergeable_rx_bufs && page)
> >                         give_pages(rq, page);
> >                 goto ok;
> >         }
> > --
> > 2.31.1
> >
>

