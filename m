Return-Path: <netdev+bounces-782-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F7326F9F3A
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 07:51:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6F7831C2094A
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 05:51:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08FC013AD9;
	Mon,  8 May 2023 05:51:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21DB7E
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 05:51:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75623AD1F
	for <netdev@vger.kernel.org>; Sun,  7 May 2023 22:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683525103;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VLTbeT6jM0D3RVqr2zdpg7Y25T3gfeDdrcPX2lOqsbs=;
	b=gYxcNL9kkn4qyu4RES3516HrgCUe0tPSpfE4mTrdMQGwNUxGr7sLChDVL2EZIOvyl/WXJ2
	jhaiZS7t5DrDsK/2cuNN9FVH13kQkqN+7sF2Lq7qtey1+BKzH/rfLhNzPdDCDmobMDO2fz
	KhsKsHQgRo6UVED15V72CRiVPlGF0ak=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-DyEVAQD0MxauoWItIS_TQw-1; Mon, 08 May 2023 01:51:40 -0400
X-MC-Unique: DyEVAQD0MxauoWItIS_TQw-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f17352d605so3988185e9.0
        for <netdev@vger.kernel.org>; Sun, 07 May 2023 22:51:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683525099; x=1686117099;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VLTbeT6jM0D3RVqr2zdpg7Y25T3gfeDdrcPX2lOqsbs=;
        b=SQqo3e3W5Gt7fdQybqMEKcxOqbhWFZPSIdTC7AC8Zb8PLrfe9lKsimtGfIQsVD4RUR
         V7m+Ka86yocC2G+wtGryDJLkHKk/6CQMH/H5bpvltm4fDZ4g4mpzapapmN1nti6b0FYe
         HZ8MycIxRvGiWSO1lc04cIc7MIA3sJQNw13kslIUaGkQL4pTqcjQej27RBBc8Ub2Kk1t
         5lpRKdBiSdz6NBDVaKdETKO38j5SjXuga5n5YoyowKHySTzgwuc4+NVsaeN2XCIF0oyU
         vIt/T2mesONUndIHJzVBj44Jc2JaQYUZp/TvNRIVoglK1pYhVvBPQ4m1gTVkMpUpeurk
         2xvw==
X-Gm-Message-State: AC+VfDzKZwStLC401+STFUTj1JGoBc7CRjZRO+CLVFbc9/XIX6qvO7eM
	lSXQk615nDhzmrjZip6xKKqzo61wh727b6yHbMaDWUMua65te9CKssQaBCSw+uU8gpqvbRE1JH4
	89dVJ8w6wHWoHDTdr
X-Received: by 2002:a05:600c:6020:b0:3f4:2297:f263 with SMTP id az32-20020a05600c602000b003f42297f263mr2347840wmb.0.1683525099292;
        Sun, 07 May 2023 22:51:39 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6EJJzFIVde559fQuvadWrh3eK1CRiflB/aYXJl0mZli70VE7/t+Atm1oTInJ/O0P9bIfEeIQ==
X-Received: by 2002:a05:600c:6020:b0:3f4:2297:f263 with SMTP id az32-20020a05600c602000b003f42297f263mr2347831wmb.0.1683525098996;
        Sun, 07 May 2023 22:51:38 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-244-175.dyn.eolo.it. [146.241.244.175])
        by smtp.gmail.com with ESMTPSA id n22-20020a7bcbd6000000b003f41bb52834sm6097334wmi.38.2023.05.07.22.51.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 May 2023 22:51:38 -0700 (PDT)
Message-ID: <1809df1d8507120dbca5c500ec00784478ec701f.camel@redhat.com>
Subject: Re: [PATCH 0/5] Bug fixes for net/handshake
From: Paolo Abeni <pabeni@redhat.com>
To: Jakub Kicinski <kuba@kernel.org>, Chuck Lever <cel@kernel.org>
Cc: kernel-tls-handshake@lists.linux.dev, netdev@vger.kernel.org, 
	dan.carpenter@linaro.org
Date: Mon, 08 May 2023 07:51:37 +0200
In-Reply-To: <20230505164715.55a12c77@kernel.org>
References: 
	<168321371754.16695.4217960864733718685.stgit@oracle-102.nfsv4bat.org>
	 <20230505133918.3c7257e8@kernel.org>
	 <ZFWOWErJ6eR/RX/X@manet.1015granger.net>
	 <20230505164715.55a12c77@kernel.org>
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

On Fri, 2023-05-05 at 16:47 -0700, Jakub Kicinski wrote:
> On Fri, 5 May 2023 19:16:40 -0400 Chuck Lever wrote:
> > On Fri, May 05, 2023 at 01:39:18PM -0700, Jakub Kicinski wrote:
> > > On Thu, 04 May 2023 11:24:12 -0400 Chuck Lever wrote: =20
> > > > I plan to send these as part of a 6.4-rc PR. =20
> > >=20
> > > Can you elaborate?  You'll send us the same code as PR?
> > > I'm about to send the first batch of fixes to Linus,
> > > I was going to apply this series. =20
> >=20
> > Since I am listed as a maintainer/supporter of net/handshake, I
> > assumed I can and should be sending changes through nfsd or some
> > other repo I can commit to.
> >=20
> > netdev@ is also listed in MAINTAINERS, so I Cc'd you all on this
> > series. I did not intend for you to be responsible for merging the
> > series. We'll need to agree on a workflow going forward.
>=20
> Let me talk to DaveM and Paolo -- with NFS being the main user
> taking it via your trees is likely fine. But if it's a generic TLS
> handshake and other users will appear - netdev trees may be a more
> natural central point :S DaveM and Paolo are more familiar with
> existing cases of similar nature (rxrpc?)..

Really, I' not ;)

My guess is that net/handshake is going to be dependent more on core
networking changes than anything else. If later developments will
require/use/leverage a new core net helper, it would be quite straight-
forward going trough the netdev trees. Otherwise such changes will
require extra coordination and/or an additional RTT WRT kernel
releases.

All the above very much IMHO ;)

/P


