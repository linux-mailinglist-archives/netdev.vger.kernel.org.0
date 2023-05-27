Return-Path: <netdev+bounces-5924-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 86287713589
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 17:55:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D514281680
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 15:55:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 850A6134C3;
	Sat, 27 May 2023 15:55:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D573FEF
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 15:55:28 +0000 (UTC)
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B45BA2;
	Sat, 27 May 2023 08:55:27 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-64d2a613ec4so1441198b3a.1;
        Sat, 27 May 2023 08:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685202926; x=1687794926;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qZ/1f+H9JrSTH8ywSfAAbH2Cj7OIgM+7OnWkNZ9G6/M=;
        b=rWmpr8DkC1PTeJ+ruz6WeYjVl72SKKE6L1OzdPejDPoSAW7zXmZBUw05Qrt26S9C9K
         U8JnJZ5vNM2ey8vstjtpFowukp0q7XfWY2JXtuYDLVNZoKAmgGFXv3AH3K5cpcaz6yzA
         tx91B1UH6oX8Yj1XcUfOG7FXKm07iJHD7w0wWjDwLfpPsf1Ztx3fCMZZCZ1yRYuid12c
         hZjLS5sLbyBGPteYx+LmLRsBwT2IK3Km1i7IeAe/4St8n9Um0UQ5B5cMIWj/X1fsPudq
         wfXqVoiC2glYv8qzoHIMH8l1e1p/1kUSfdOSTb1NwubYxiVsbSN+YVuhQB/kWWU02/Dt
         K3hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685202927; x=1687794927;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qZ/1f+H9JrSTH8ywSfAAbH2Cj7OIgM+7OnWkNZ9G6/M=;
        b=QJRJIPppE+x5vJGs64GkBr0meoomSkN21EV5VDLppttTjBpd6/QQz4ezMSc322AK1F
         QtUlokUNBWWyTZmVkmeeUdVoJFFgYIVK5zux5N8EHhMAf8x+8TWjehsR2zH9ol3/GlwA
         zsQrIwywuuVkMUZoQotav9IZh29J0vy7juUNQKBY7dpOirXg+v/epgWsgyklkgAWhOd9
         +KLXvmHQakftYgkLVHIW7rqA04QturrAbEe/JRcZdexDqr0t9O0TwT5smhOlIlHmzlcU
         N5elto6w4XfxZ8fo860PdAYmoXaWL6QlgbDxEBvB2DnypAJ5MgtuDTbSTojN1tYuj0KA
         ceeQ==
X-Gm-Message-State: AC+VfDxQ3a0xcRbv+xi7QPAQq6aLI8KC8AImEXh0tCOGdd6pwcgLtV/v
	tA2/dpY/ADy4HyAwRUyBmx7yMG39pVcapi5FHNQ=
X-Google-Smtp-Source: ACHHUZ64JnVWGNRmG/FMmCXkRK9umouxfNu5WSYpfqhZWb1yayLJ0QzFvBLSS7/j3llpZaEueVjiGE/MaMAjTCqEuek=
X-Received: by 2002:a05:6a20:4428:b0:ff:a820:e060 with SMTP id
 ce40-20020a056a20442800b000ffa820e060mr4237395pzb.20.1685202926525; Sat, 27
 May 2023 08:55:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230524153311.3625329-1-dhowells@redhat.com> <20230524153311.3625329-6-dhowells@redhat.com>
 <20230526175736.7e75dcf9@kernel.org>
In-Reply-To: <20230526175736.7e75dcf9@kernel.org>
From: Alexander Duyck <alexander.duyck@gmail.com>
Date: Sat, 27 May 2023 08:54:50 -0700
Message-ID: <CAKgT0Uf2rPRZqQxGDZGkmdUA2j2=2cw0X1k8i0RpKgNxX0tcCw@mail.gmail.com>
Subject: Re: [PATCH net-next 05/12] mm: Make the page_frag_cache allocator
 handle __GFP_ZERO itself
To: Jakub Kicinski <kuba@kernel.org>
Cc: David Howells <dhowells@redhat.com>, netdev@vger.kernel.org, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
	David Ahern <dsahern@kernel.org>, Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Jeroen de Borst <jeroendb@google.com>, Catherine Sullivan <csully@google.com>, 
	Shailend Chand <shailend@google.com>, Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>, 
	Sean Wang <sean.wang@mediatek.com>, Mark Lee <Mark-MC.Lee@mediatek.com>, 
	Lorenzo Bianconi <lorenzo@kernel.org>, Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, Keith Busch <kbusch@kernel.org>, 
	Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	Chaitanya Kulkarni <kch@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, 
	linux-nvme@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 5:57=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Wed, 24 May 2023 16:33:04 +0100 David Howells wrote:
> > Make the page_frag_cache allocator handle __GFP_ZERO itself rather than
> > passing it off to the page allocator.  There may be a mix of callers, s=
ome
> > specifying __GFP_ZERO and some not - and even if all specify __GFP_ZERO=
, we
> > might refurbish the page, in which case the returned memory doesn't get
> > cleared.
>
> I think it's pretty clear that page frag allocator was never supposed
> to support GFP_ZERO, as we don't need it in networking.. So maybe
> you're better off adding the memset() in nvme?
>
> CCing Alex, who I think would say something along those lines :)
> IDK how much we still care given that most networking drivers are
> migrating to page_poll these days.

Yeah, the page frag allocator wasn't meant to handle things like this.
Generally the cache was meant to be used within one context so that
the GFP flags used were consistent between calls. Currently the only
thing passed appears to be GFP_ATOMIC.

Also I am not a big fan of pulling this out of page_alloc.c The fact
is that is where the allocation functions live so it makes sense to
just leave it there. It isn't as if there is enough code added in my
point of view to create yet another file and make it harder to track
git history as a result.

