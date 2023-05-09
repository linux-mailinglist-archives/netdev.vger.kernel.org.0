Return-Path: <netdev+bounces-1103-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 160CC6FC333
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 11:51:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 40B231C20AF2
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 09:51:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16C5CAD4E;
	Tue,  9 May 2023 09:51:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C9753B2
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 09:51:09 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A7744EC3
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 02:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683625867;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nzNQ5/X/zC8NejG+wY02LgX0k1DWjcVt5NxJO9a2/p0=;
	b=NqE8x9I0omP+9wi05jqtI2LEEZ2EUwHk+sMe22eto6mBmPJsjWQDmAjZw4SUPkgXoiHzM0
	4P//D0QbS3LPRstY/8OfGl3grlbdp0QCVtlEW6NKTW3L3FOKppxI/lGJCcRoEInLjckphX
	gpcSTl2sAN43w5cK3HW7Macjryf5VZc=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-513-pBQjG0PENCCnsSracyy9ag-1; Tue, 09 May 2023 05:51:06 -0400
X-MC-Unique: pBQjG0PENCCnsSracyy9ag-1
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-3f38280ec63so6430471cf.1
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 02:51:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683625866; x=1686217866;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nzNQ5/X/zC8NejG+wY02LgX0k1DWjcVt5NxJO9a2/p0=;
        b=GGmeTIUWOAVLqFUVKVEcYVMHceJY3uHwZkQEYzJ6lyv53bganvzx4KcNc465N2esK/
         XpDf1XtYaTTzNH7bWsilWV5Obxvtk4bxIWXz01WsSONb0yeThqrO0u/DvjuQDm040LEC
         QLKHSvq1iMT6Mb/4gnF/JM84kgngTXL8JlJ5h7+FR1tIGMeyxlz7fmbaNudJEucmT6bw
         fz8I/WkoiliPKmonOdoqhp3/Bpb4jCV0CHZND3LYleCtuOpT3YpOIwTPd73w3D+1CMte
         kcnI2Jrwk8P5ZRb988dr6I+DKAGMqLzARQVXuBzWIZceEzb8XrBi4RZFC1kLjyrgTjD5
         pCdQ==
X-Gm-Message-State: AC+VfDyH5jr/1y6/JKonpc5ZyRR7+lo++8nwJzbYm8uFGSpCr0Doh4yQ
	a1eQaAPNxY17UNnNvGzWLICPOHM7ScwERR/1srdiKX/dqyjhKkQvnHJVS5aQaEx8mf56GXgazWK
	lPYsxAZrTOm1k3uQQ
X-Received: by 2002:ac8:5805:0:b0:3e3:1d31:e37 with SMTP id g5-20020ac85805000000b003e31d310e37mr16043158qtg.1.1683625865911;
        Tue, 09 May 2023 02:51:05 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7lrjP9tjOO1YWj6jNA9+zgbjNsZIOniT/fl0ZXCaAzIwsBiz1PtCifE/9mCE+9kiWhHxi7yQ==
X-Received: by 2002:ac8:5805:0:b0:3e3:1d31:e37 with SMTP id g5-20020ac85805000000b003e31d310e37mr16043134qtg.1.1683625865616;
        Tue, 09 May 2023 02:51:05 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-255-65.dyn.eolo.it. [146.241.255.65])
        by smtp.gmail.com with ESMTPSA id s13-20020a05620a16ad00b0074dfd9283afsm867741qkj.79.2023.05.09.02.51.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 02:51:05 -0700 (PDT)
Message-ID: <3887b08ac0e55e27a24d2f66afcfff1961ed9b13.camel@redhat.com>
Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
From: Paolo Abeni <pabeni@redhat.com>
To: Cathy Zhang <cathy.zhang@intel.com>, edumazet@google.com, 
	davem@davemloft.net, kuba@kernel.org
Cc: jesse.brandeburg@intel.com, suresh.srinivas@intel.com,
 tim.c.chen@intel.com,  lizhen.you@intel.com, eric.dumazet@gmail.com,
 netdev@vger.kernel.org
Date: Tue, 09 May 2023 11:51:02 +0200
In-Reply-To: <20230508020801.10702-2-cathy.zhang@intel.com>
References: <20230508020801.10702-1-cathy.zhang@intel.com>
	 <20230508020801.10702-2-cathy.zhang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, 2023-05-07 at 19:08 -0700, Cathy Zhang wrote:
> Before commit 4890b686f408 ("net: keep sk->sk_forward_alloc as small as
> possible"), each TCP can forward allocate up to 2 MB of memory and
> tcp_memory_allocated might hit tcp memory limitation quite soon. To
> reduce the memory pressure, that commit keeps sk->sk_forward_alloc as
> small as possible, which will be less than 1 page size if SO_RESERVE_MEM
> is not specified.
>=20
> However, with commit 4890b686f408 ("net: keep sk->sk_forward_alloc as
> small as possible"), memcg charge hot paths are observed while system is
> stressed with a large amount of connections. That is because
> sk->sk_forward_alloc is too small and it's always less than
> sk->truesize, network handlers like tcp_rcv_established() should jump to
> slow path more frequently to increase sk->sk_forward_alloc. Each memory
> allocation will trigger memcg charge, then perf top shows the following
> contention paths on the busy system.
>=20
>     16.77%  [kernel]            [k] page_counter_try_charge
>     16.56%  [kernel]            [k] page_counter_cancel
>     15.65%  [kernel]            [k] try_charge_memcg

I'm guessing you hit memcg limits frequently. I'm wondering if it's
just a matter of tuning/reducing tcp limits in
/proc/sys/net/ipv4/tcp_mem.

Cheers,

Paolo


