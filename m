Return-Path: <netdev+bounces-5538-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 931FB71208A
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 08:57:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EE0AB2815D2
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 06:57:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A8EA566A;
	Fri, 26 May 2023 06:57:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2993B53A0
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 06:57:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFAEA95
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 23:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685084263;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ze1eBV4qRCm3f7jG4VXgl0UZTu4+F/diGmfSJICaiCw=;
	b=ebjjImzTZhmZ5rGqtY62W7s+H345nM13zCHW4k8LIonNpIX3aFHgSan8DCjMHjYBPGImga
	7GHbjgeR61EeAx72sXl5ZH10wfbBJqW1rwNj1xeMWo2o3p2o1M8y0zTgmuw75Z9ttHfQB/
	2uNhuh4c8oLJ0ZVV3TsekkNr/zdYBl0=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-116-P9e36ENDPa2LOf_8tavzRA-1; Fri, 26 May 2023 02:57:39 -0400
X-MC-Unique: P9e36ENDPa2LOf_8tavzRA-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2af222cc3a1so1832021fa.3
        for <netdev@vger.kernel.org>; Thu, 25 May 2023 23:57:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685084258; x=1687676258;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ze1eBV4qRCm3f7jG4VXgl0UZTu4+F/diGmfSJICaiCw=;
        b=VYVlaKTqeckNXnOrgO1kASssBqRgXc/9WYuPz8diU6ABLY3uGlqqdleGHdvd5COqaB
         axCP5eb0tn0Ogta/kxJFrMRI9QZsWU3ZRT/wrBiEhZ9d5qa8tD1cYbpyBieZNItPefcH
         /BAO6sDOzzMbUEwNFZ34mWLAAk8e1bqkhbEBqcpcSTwN2RlaIY5CHqnIxzFmQFxiuuoF
         85FdrXxvL5zMVYzfF1nEwilAkNvN6KJrFuP6sT/1jAmwXtKTD9eIXhFVrvbB+f711wbO
         hm40ZfVUF+Su2lg1rCdZp/6+fi9NY8+p70Dv07prkOTi6YNU+VRGKEvkYVwV4tvVNHJw
         clAQ==
X-Gm-Message-State: AC+VfDwvtAgK89DedPFNgYMqW0bXFPsnplccCkpKqJVRemNgaCTcSf+r
	6JSgOl9Cdx8oSaQW77NMt7wyzW5Y8Bn3PVjzNg9M+0jHqyt+D39VDsoaBik88oSeiAokbtOSZ6K
	JMARABZ0WHVhXXlT3KiqBQuA1H+U+6+Uy
X-Received: by 2002:a2e:988a:0:b0:2af:19dd:ecda with SMTP id b10-20020a2e988a000000b002af19ddecdamr270642ljj.45.1685084258239;
        Thu, 25 May 2023 23:57:38 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6RUV+CPVbAikpmqLlt9KyfhEdW/YgA62KOwWCN81f6RByJJ2V+wLWEBsXzQPG8RpdaSOEsVayioAzSUl9FlpE=
X-Received: by 2002:a2e:988a:0:b0:2af:19dd:ecda with SMTP id
 b10-20020a2e988a000000b002af19ddecdamr270630ljj.45.1685084257924; Thu, 25 May
 2023 23:57:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230526054621.18371-1-liangchen.linux@gmail.com> <20230526054621.18371-4-liangchen.linux@gmail.com>
In-Reply-To: <20230526054621.18371-4-liangchen.linux@gmail.com>
From: Jason Wang <jasowang@redhat.com>
Date: Fri, 26 May 2023 14:57:26 +0800
Message-ID: <CACGkMEsnto9APpDo1uzVJAWBwk9f8pt6D=J41tdf1ZQ63ADK9Q@mail.gmail.com>
Subject: Re: [PATCH net-next 4/5] virtio_ring: Introduce DMA pre-handler
To: Liang Chen <liangchen.linux@gmail.com>
Cc: mst@redhat.com, virtualization@lists.linux-foundation.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	xuanzhuo@linux.alibaba.com, kuba@kernel.org, edumazet@google.com, 
	davem@davemloft.net, pabeni@redhat.com, alexander.duyck@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 1:47=E2=80=AFPM Liang Chen <liangchen.linux@gmail.c=
om> wrote:
>
> Currently, DMA operations of virtio devices' data buffer are encapsulated
> within the underlying virtqueue implementation. DMA map/unmap operations
> are performed for each data buffer attached to/detached from the virtqueu=
e,
> which is transparent and invisible to the higher-level virtio device
> drivers. This encapsulation makes it not viable for device drivers to
> introduce certain mechanisms, such as page pool, that require explicit
> management of DMA map/unmap. Therefore, by inserting a pre-handler before
> the generic DMA map/unmap operations, virtio device drivers have the
> opportunity to participate in DMA operations.
>
> Signed-off-by: Liang Chen <liangchen.linux@gmail.com>

So Xuan is doing AF_XDP for the virtio-net that allows the DMA to be
mapped at least by the virtio-net.

It looks like a way to allow virtio-net to map and unmap the DMA
buffer by itself, but this patch goes into another way which seems to
query the address from the virtio core.

Personally, I think map and sync by the virtio-net driver seems clean.
But we can see.

Thanks


