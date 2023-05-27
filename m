Return-Path: <netdev+bounces-5923-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B39D9713581
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 17:54:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5EEC72815FD
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 15:54:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95E1E134BD;
	Sat, 27 May 2023 15:54:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A70A1078A
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 15:54:40 +0000 (UTC)
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 022BDBA;
	Sat, 27 May 2023 08:54:39 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-64d426e63baso2309457b3a.0;
        Sat, 27 May 2023 08:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685202878; x=1687794878;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=l+G4puGLv1p8z/Hlge1/6NOCJbk0UrLfWek2Xulcb84=;
        b=gQhLpA9ZJ3MsbjBLRHKg/Bu7sQtUuFnFo0w9+0BYJ9KOLiAmaHm/m4Y4E06NNRB1dl
         0q6K6DFbWeTb5Z/iyCZr4tT1ppDQtz7yJeeBl9m8r9FuOoRb1xD5m3BqBek2b4tbNxxa
         pA67T941mfHhp1dUVfT2Jr+DVuBy/2445xXa8FHpcG7rg9eZAqCVjK74O2s10v+F/6ug
         hMy8q4g8ddP/1iBz/DlNKwpEJann3ERIFh3Wn4PR1+/YgtOpHJkf01XWT69+1N+oMzVG
         cQNsioSb+HO7UB/dsiirhUAhze1c1ZFpySoti411TJ3f8G7crCWmFMZf6m+agVEApcpW
         vz+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685202878; x=1687794878;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=l+G4puGLv1p8z/Hlge1/6NOCJbk0UrLfWek2Xulcb84=;
        b=WTPzrS2QWir+LV+XT/8Atb4wF6jyotde2UUpSUxFuc33Oo+BjdhCCA5O7BCjq6uKzo
         RKcwRWhdwkzEoWLpuuiW8QXIyIwZZJuNNn1R+xB3E2GcIEwS+ksgsVKGkG8ufUf2/pnM
         hWnNCwIMcp25uvyH0ppOqloRsvMGRZ6DYDvtPKwDmwnodcGREJrqovxi720HmPz9GMLl
         akrB0/5heuXRzXyd8qWd1crdxa3gDepJjf6u8n5YPIfLaZfb4kagqWWh0PYcOhby3M0J
         G+687oTuAPAI2EuwqnfZW6RTfuzCR1z1z2ZWB28dQV6TID5VL/3Y35rR+fBervn6LHLo
         iXJQ==
X-Gm-Message-State: AC+VfDw9ZAL0YicsVRX+bjaFqdHMYje1VNW2fQeCy60Gjnaj5cbu4zOW
	nyCrA5GkRbNVYEMv06uXUqQ=
X-Google-Smtp-Source: ACHHUZ4eTm+gSTcfMJyzZbWF/OB3D5r515LcsPPvEz9Qas5w+qwp4srtHFosGb4KBrd58salPotjYw==
X-Received: by 2002:a05:6a21:338b:b0:d5:73ad:87c2 with SMTP id yy11-20020a056a21338b00b000d573ad87c2mr3545769pzb.56.1685202878254;
        Sat, 27 May 2023 08:54:38 -0700 (PDT)
Received: from ?IPv6:2605:59c8:448:b800:82ee:73ff:fe41:9a02? ([2605:59c8:448:b800:82ee:73ff:fe41:9a02])
        by smtp.googlemail.com with ESMTPSA id v12-20020a62a50c000000b0063f1430dd57sm4201560pfm.49.2023.05.27.08.54.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 May 2023 08:54:37 -0700 (PDT)
Message-ID: <51161740e832334594960ed43430b868a6f892c3.camel@gmail.com>
Subject: Re: [PATCH net-next 03/12] mm: Make the page_frag_cache allocator
 alignment param a pow-of-2
From: Alexander H Duyck <alexander.duyck@gmail.com>
To: David Howells <dhowells@redhat.com>, netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>,  Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
 <pabeni@redhat.com>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 David Ahern <dsahern@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Jens Axboe <axboe@kernel.dk>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Jeroen de Borst <jeroendb@google.com>, 
 Catherine Sullivan <csully@google.com>, Shailend Chand
 <shailend@google.com>, Felix Fietkau <nbd@nbd.name>, John Crispin
 <john@phrozen.org>, Sean Wang <sean.wang@mediatek.com>, Mark Lee
 <Mark-MC.Lee@mediatek.com>, Lorenzo Bianconi <lorenzo@kernel.org>, Matthias
 Brugger <matthias.bgg@gmail.com>,  AngeloGioacchino Del Regno
 <angelogioacchino.delregno@collabora.com>, Keith Busch <kbusch@kernel.org>,
 Jens Axboe <axboe@fb.com>,  Christoph Hellwig <hch@lst.de>, Sagi Grimberg
 <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>, Andrew Morton
 <akpm@linux-foundation.org>,  linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org,  linux-nvme@lists.infradead.org
Date: Sat, 27 May 2023 08:54:34 -0700
In-Reply-To: <20230524153311.3625329-4-dhowells@redhat.com>
References: <20230524153311.3625329-1-dhowells@redhat.com>
	 <20230524153311.3625329-4-dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-3.fc36) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, 2023-05-24 at 16:33 +0100, David Howells wrote:
> Make the page_frag_cache allocator's alignment parameter a power of 2
> rather than a mask and give a warning if it isn't.
>=20
> This means that it's consistent with {napi,netdec}_alloc_frag_align() and
> allows __{napi,netdev}_alloc_frag_align() to be removed.
>=20

This goes against the original intention of these functions. One of the
reasons why this is being used is because when somebody enables
something like 2K jumbo frames they don't necessarily want to have to
allocate 4K SLABs. Instead they can just add a bit of overhead and get
almost twice the utilization out of an order 3 page.

The requirement should only be cache alignment, not power of 2
alignment. This isn't meant to be a slab allocator. We are just
sectioning up pages to handle mixed workloads. In the case of
networking we can end up getting everything from 60B packets, to 1514B
in the standard cases. That was why we started sectioning up pages in
the first place so putting a power of 2 requirement on it doens't fit
our use case at all and is what we were trying to get away from with
the SLAB allocators.

