Return-Path: <netdev+bounces-272-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 725AC6F6A31
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 13:40:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 14ABF280D32
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 11:40:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD5BA10EC;
	Thu,  4 May 2023 11:40:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBDC21876
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 11:40:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 391C359D5
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 04:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683200401;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1dAUD/YyKYtBDGXLrqbHGpjW1303Qwg+dgZM70sjvJ4=;
	b=hRgB8GGQHUWvOU+tk4Zfk9YKnBvbGRSYi58nHesN+9EzKW+WmBqLuO+XXIfcxue66rXOA9
	qIo/I75XcNOuc5boxeCCij8sRMgAKjamy6TDUzTxp8jF56HtPX7n264d5J4F3k+chI/jhJ
	hkXWja2k9o1hHB8q5LLqq+Vq1qvEUBk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-348-sT5EZTO9PZqo53PRxatKhA-1; Thu, 04 May 2023 07:40:00 -0400
X-MC-Unique: sT5EZTO9PZqo53PRxatKhA-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3f08900caadso579895e9.0
        for <netdev@vger.kernel.org>; Thu, 04 May 2023 04:39:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683200399; x=1685792399;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1dAUD/YyKYtBDGXLrqbHGpjW1303Qwg+dgZM70sjvJ4=;
        b=L2qF5x0P4jf3aYDKa8AhC4i6c/mFGgPkuLIN+4SYXrAT7XDg436T7QtLOsMWHKQmms
         WG+GvxMnzHr1j8bxNGtv6IwhU6HgfoP4FMkSvQP3dqYaMnEY+b+NXWFQ2LUmNrV9sGCr
         x7w+6mqN3Hgo19X5ao3k3mfzGZKX+gi8j1+Fj+HzBSaerLYDM3Xp1M/0O9BYu8BDlEy5
         GRoqsaDoOxUsruSMliSayNnQsoSHL+umAY42BSdR7+VQbOSO57tr4ffcUuNDuYqDv05e
         yPB0vp8mGbj9XTdYPZnw0x33+SsZwTe8LQ2gGq3SEgr4aVG7t794p54inZ6eNnSYzrIO
         9bDw==
X-Gm-Message-State: AC+VfDwpf18HxISmmdhfm51s3FNc0YFkkhjFSEhyNe3A+W0/5Ce/UnRX
	FZYu8JbnHwqx2+08KPo+HyOAyLK1JE4aB7+8Hz0Wz6Lb9HuBBQS0hqYAyJp4dS86lZWRUKwutJQ
	TfKvJ77UD40HX2aYb
X-Received: by 2002:a05:600c:538d:b0:3f1:7332:40d9 with SMTP id hg13-20020a05600c538d00b003f1733240d9mr6738146wmb.0.1683200399086;
        Thu, 04 May 2023 04:39:59 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ63AwDBCWc4WjL+ZzpDQNmewmPocR+z2qi0OemrHZ1uXpPUOdx5ljTHrrhKdYb/UlwjpVFolg==
X-Received: by 2002:a05:600c:538d:b0:3f1:7332:40d9 with SMTP id hg13-20020a05600c538d00b003f1733240d9mr6738133wmb.0.1683200398753;
        Thu, 04 May 2023 04:39:58 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-244-79.dyn.eolo.it. [146.241.244.79])
        by smtp.gmail.com with ESMTPSA id i6-20020a05600c290600b003f18992079dsm4610657wmd.42.2023.05.04.04.39.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 May 2023 04:39:58 -0700 (PDT)
Message-ID: <19409d2b4222b3a5c6fc0cedbfa7844b6eb3440f.camel@redhat.com>
Subject: Re: [PATCH] atlantic: Remove unnecessary (void*) conversions
From: Paolo Abeni <pabeni@redhat.com>
To: Leon Romanovsky <leon@kernel.org>, wuych <yunchuan@nfschina.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
 irusskikh@marvell.com, netdev@vger.kernel.org,
 kernel-janitors@vger.kernel.org
Date: Thu, 04 May 2023 13:39:57 +0200
In-Reply-To: <20230504110304.GX525452@unreal>
References: <20230504100253.74932-1-yunchuan@nfschina.com>
	 <20230504110304.GX525452@unreal>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, 2023-05-04 at 14:03 +0300, Leon Romanovsky wrote:
> On Thu, May 04, 2023 at 06:02:53PM +0800, wuych wrote:
> > Pointer variables of void * type do not require type cast.
> >=20
> > Signed-off-by: wuych <yunchuan@nfschina.com>
> > ---
> >  .../net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c | 12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
>=20
> There is same thing in drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_=
atl2_utils_fw.c too.

Also this looks like material for net-next: the next version will have
to wait a bit, see below.

Next time please include the target tree into the email subj, thanks!

## Form letter - net-next-closed

The merge window for v6.3 has begun and therefore net-next is closed
for new drivers, features, code refactoring and optimizations.
We are currently accepting bug fixes only.

Please repost when net-next reopens after May 8th.

RFC patches sent for review only are obviously welcome at any time.

See:
https://www.kernel.org/doc/html/next/process/maintainer-netdev.html#develop=
ment-cycle


