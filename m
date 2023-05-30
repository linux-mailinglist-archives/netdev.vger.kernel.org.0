Return-Path: <netdev+bounces-6475-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F762716707
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 17:29:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB5202811AF
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 15:29:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA36824E8D;
	Tue, 30 May 2023 15:29:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A3717AD4
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 15:29:16 +0000 (UTC)
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A361411C;
	Tue, 30 May 2023 08:29:13 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-64d24136685so3155257b3a.1;
        Tue, 30 May 2023 08:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685460553; x=1688052553;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2SJp+Uv1RpHV3xgAECW4BbCiVPS6daBLkdIv88EsssY=;
        b=INdZ3vvUBHUo9v5GYo09wvuKyHUEohSnMh3K4lkdOlTtC6CZIBE6WjDfXawBNpRXrj
         qgOqFpmcOS+EfVJZjDo8CZWmjFUn6fbuuxei9YV+YY61pufddxKnAru2CvSvkTAVaHtD
         fMrAsOCrrk5dwLUm1arzxNPHcnbSFcXiyowkv/ev/zeygouXqakO6wCOh0yzvg4EZP1K
         y00qGWqdbTy9EjdGTW6l3F4YvWhd0gJC4EqPMoBr6+Hpy38CmLlXFtz6wE138bujQ6d9
         sDY9Clt7NDjURoE8V1dakc+GJlGpuwcRjZUpbNo0aTqDDGQWKTz0l6L1wAKonaOfDtcs
         DUPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685460553; x=1688052553;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2SJp+Uv1RpHV3xgAECW4BbCiVPS6daBLkdIv88EsssY=;
        b=XKg+5+/ouIGBJaD4LA+gRjzU7LbrgOeukFT+G7LDyuzurvLGCss+fXZU/1FOnhGmjf
         /+6+Lw3QaeDfLxxAd75lAO1rs5skl0PPKKO3r+XxTnP1hXK1k5T0MVo04VzNQXmc2yC4
         y754RW1qsBgifxBZ/o/0wb/VpeAm3cK0QZe3CN3ASbmu5ymvisFMPwo9c7dx2g6obtdT
         M19EbHpVS9MsdY41rCwsdtGseX/l9B1DEN6ihdg1nNtPp8/opBAUfFUmHmusgZLt7Jz1
         iuHriLFW4TG7mGRvpwMVigitPdoqOQz6uJLS9iGlhxcUYfhyMM3aFh5ksRnn8+JKci0B
         KZag==
X-Gm-Message-State: AC+VfDw4kwdkB20WgDbpQBOqVXhtdw6dtQfSkto49Mh5q4ssBIt+PEV2
	wH5DZua8RYI5TYUwo1nSEz8=
X-Google-Smtp-Source: ACHHUZ6I4dCo42pqcRR5FvrO5e8hYEpJ7NRXK4X/W0UzOn3fN27G7WK/zXzU6nqQ+Vg1OyuGCecyKQ==
X-Received: by 2002:a05:6a20:918d:b0:111:52a4:7fab with SMTP id v13-20020a056a20918d00b0011152a47fabmr6033942pzd.26.1685460552886;
        Tue, 30 May 2023 08:29:12 -0700 (PDT)
Received: from ?IPv6:2605:59c8:448:b800:82ee:73ff:fe41:9a02? ([2605:59c8:448:b800:82ee:73ff:fe41:9a02])
        by smtp.googlemail.com with ESMTPSA id t62-20020a632d41000000b0053fb37fb626sm1583890pgt.43.2023.05.30.08.29.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 08:29:12 -0700 (PDT)
Message-ID: <09254e7cd6fd20f899f8a4ad3fbaabf223802503.camel@gmail.com>
Subject: Re: [PATCH net-next v2 02/12] iavf: kill "legacy-rx" for good
From: Alexander H Duyck <alexander.duyck@gmail.com>
To: Alexander Lobakin <aleksander.lobakin@intel.com>, "David S. Miller"
	 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Maciej Fijalkowski <maciej.fijalkowski@intel.com>, Magnus Karlsson
 <magnus.karlsson@intel.com>, Michal Kubiak <michal.kubiak@intel.com>,
 Larysa Zaremba <larysa.zaremba@intel.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Christoph Hellwig <hch@lst.de>, Paul Menzel <pmenzel@molgen.mpg.de>,
 netdev@vger.kernel.org,  intel-wired-lan@lists.osuosl.org,
 linux-kernel@vger.kernel.org
Date: Tue, 30 May 2023 08:29:10 -0700
In-Reply-To: <20230525125746.553874-3-aleksander.lobakin@intel.com>
References: <20230525125746.553874-1-aleksander.lobakin@intel.com>
	 <20230525125746.553874-3-aleksander.lobakin@intel.com>
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

On Thu, 2023-05-25 at 14:57 +0200, Alexander Lobakin wrote:
> Ever since build_skb() became stable, the old way with allocating an skb
> for storing the headers separately, which will be then copied manually,
> was slower, less flexible and thus obsolete.
>=20
> * it had higher pressure on MM since it actually allocates new pages,
>   which then get split and refcount-biased (NAPI page cache);
> * it implies memcpy() of packet headers (40+ bytes per each frame);
> * the actual header length was calculated via eth_get_headlen(), which
>   invokes Flow Dissector and thus wastes a bunch of CPU cycles;
> * XDP makes it even more weird since it requires headroom for long and
>   also tailroom for some time (since mbuf landed). Take a look at the
>   ice driver, which is built around work-arounds to make XDP work with
>   it.
>=20
> Even on some quite low-end hardware (not a common case for 100G NICs) it
> was performing worse.
> The only advantage "legacy-rx" had is that it didn't require any
> reserved headroom and tailroom. But iavf didn't use this, as it always
> splits pages into two halves of 2k, while that save would only be useful
> when striding. And again, XDP effectively removes that sole pro.
>=20

The "legacy-rx" was never about performance. It was mostly about
providing a fall back in the event of an unexpected behavior. Keep in
mind that in order to enable this we are leaving the page mapped and
syncing it multiple times. In order to enable support for this we had
to add several new items that I had deemed to be a bit risky such as
support for DMA pages that were synced by the driver instead of on
map/unmap and the use of the build_skb logic.

My main concern was that if we ever ran into  header corruption we
could switch this on and then the pages would only be writable by the
device.

> There's a train of features to land in IAVF soon: Page Pool, XDP, XSk,
> multi-buffer etc. Each new would require adding more and more Danse
> Macabre for absolutely no reason, besides making hotpath less and less
> effective.
> Remove the "feature" with all the related code. This includes at least
> one very hot branch (typically hit on each new frame), which was either
> always-true or always-false at least for a complete NAPI bulk of 64
> frames, the whole private flags cruft and so on. Some stats:
>=20
> Function: add/remove: 0/2 grow/shrink: 0/7 up/down: 0/-774 (-774)
> RO Data: add/remove: 0/1 grow/shrink: 0/0 up/down: 0/-40 (-40)
>=20
> Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>

I support this 100%. The legacy-rx flag was meant as more of a fall-
back in the event that the build_skb code wasn't present or was broken
in some way. It wasn't really meant to be carried forward into drivers
as the last one I had added this to was i40e over 6 years ago.

Since it has been about 6 years without any issues I would say we are
safe to remove it.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>

