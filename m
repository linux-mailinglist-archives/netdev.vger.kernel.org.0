Return-Path: <netdev+bounces-11702-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6DAD733F43
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 09:45:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 601A11C21055
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 07:45:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D3D26FB3;
	Sat, 17 Jun 2023 07:45:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410C01C33
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 07:45:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA8E426BE
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 00:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686987903;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QSqZn9QpuYGjBKZIP5tPfM6PUFXTeXl41pLP2tW5TZM=;
	b=d/0UKapCGQelOZ/TguUlmVDlVZ4VG751u8vGd6GdJl9Ym71KZHObR5g1Crcu+0g0zZIKs2
	XFprlyzSqMDzUpf+L3cn4iT2hbI9LxSpQ84kJQrbh/yIZZN7e1vXG/UM8P2fI0SO0UCT63
	bqezxqz1/mry3/SXgl6lSQ1ekO3Ouh8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-274-7b0n0D-dOOqh7JoOgrqgBw-1; Sat, 17 Jun 2023 03:45:01 -0400
X-MC-Unique: 7b0n0D-dOOqh7JoOgrqgBw-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f5fa06debcso7607805e9.0
        for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 00:45:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686987899; x=1689579899;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QSqZn9QpuYGjBKZIP5tPfM6PUFXTeXl41pLP2tW5TZM=;
        b=CjOV2TZ6r5TYFpGKL694pRQmyjJZ2t4SINSbxObYegRgZbFXNsOXo6p6EhgSBJAQ4A
         vJuPjKJCblCMniUp/j6zkY1Tk7ztt9b+E7sNggN1Up8tKqtqtViNPz026gUsM3j6Zpsx
         wqnICdYjE1uLkafqb5OF/Gd5o8bn2glx6n7X0bTa3LhSuLPl47GBE1j555x3gZ4u4+HF
         NkJLX/PmZi8n1MbphQKhvNk3Hv1o1ncRr02GQjDysAhjv7kV7wTYFVZwBdvBTL2f+iEA
         GS9u0BnXuvYotZAHxE/fEdXEDk9ZiaIdxJl/s9XMbmb8F4aQQ49Gm1+UO3KNqXJioTKP
         3Slw==
X-Gm-Message-State: AC+VfDyM7/LpWDrj6ZT7sPgHisgiT+svCPlZsYTxR21JsbbZTNJWZOwK
	OPfyGCTmCseozDj/tThdMciCP+cHwqf1pLqDhmAo9njFq+btcRSxsbCkW9R4oGiIxV5Nn4xMeVR
	zJr7eATOhLKk2rh0d
X-Received: by 2002:a7b:c419:0:b0:3f8:575:4a9b with SMTP id k25-20020a7bc419000000b003f805754a9bmr3605857wmi.30.1686987899599;
        Sat, 17 Jun 2023 00:44:59 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ74ufbuUC360emgyQVJbIbar3zy9bMaJtCH9tng2Qd93aLJgFUFNSlVu+3Budf5dG/gRmpAeA==
X-Received: by 2002:a7b:c419:0:b0:3f8:575:4a9b with SMTP id k25-20020a7bc419000000b003f805754a9bmr3605842wmi.30.1686987899341;
        Sat, 17 Jun 2023 00:44:59 -0700 (PDT)
Received: from redhat.com (46-223-98.internethome.cytanet.com.cy. [46.199.223.98])
        by smtp.gmail.com with ESMTPSA id x4-20020a05600c21c400b003f42a75ac2asm4183876wmj.23.2023.06.17.00.44.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jun 2023 00:44:58 -0700 (PDT)
Date: Sat, 17 Jun 2023 03:44:56 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc: jasowang@redhat.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, xuanzhuo@linux.alibaba.com
Subject: Re: [RFC PATCH net 0/3] virtio-net: allow usage of small vrings
Message-ID: <20230617034425-mutt-send-email-mst@kernel.org>
References: <20230430131518.2708471-1-alvaro.karsz@solid-run.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230430131518.2708471-1-alvaro.karsz@solid-run.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, Apr 30, 2023 at 04:15:15PM +0300, Alvaro Karsz wrote:
> At the moment, if a virtio network device uses vrings with less than
> MAX_SKB_FRAGS + 2 entries, the device won't be functional.
> 
> The following condition vq->num_free >= 2 + MAX_SKB_FRAGS will always
> evaluate to false, leading to TX timeouts.
> 
> This patchset attempts this fix this bug, and to allow small rings down
> to 4 entries.
> 
> The first patch introduces a new mechanism in virtio core - it allows to
> block features in probe time.
> 
> If a virtio drivers blocks features and fails probe, virtio core will
> reset the device, re-negotiate the features and probe again.
> 
> This is needed since some virtio net features are not supported with
> small rings.
> 
> This patchset follows a discussion in the mailing list [1].
> 
> This fixes only part of the bug, rings with less than 4 entries won't
> work.
> My intention is to split the effort and fix the RING_SIZE < 4 case in a
> follow up patchset.
> 
> Maybe we should fail probe if RING_SIZE < 4 until the follow up patchset?
> 
> I tested the patchset with SNET DPU (drivers/vdpa/solidrun), with packed
> and split VQs, with rings down to 4 entries, with and without
> VIRTIO_NET_F_MRG_RXBUF, with big MTUs.
> 
> I would appreciate more testing.
> Xuan: I wasn't able to test XDP with my setup, maybe you can help with
> that?
> 
> [1] https://lore.kernel.org/lkml/20230416074607.292616-1-alvaro.karsz@solid-run.com/

the work is orphaned for now. Jason do you want to pick this up?
Related to all the hardening I guess ...

> Alvaro Karsz (3):
>   virtio: re-negotiate features if probe fails and features are blocked
>   virtio-net: allow usage of vrings smaller than MAX_SKB_FRAGS + 2
>   virtio-net: block ethtool from converting a ring to a small ring
> 
>  drivers/net/virtio_net.c | 161 +++++++++++++++++++++++++++++++++++++--
>  drivers/virtio/virtio.c  |  73 +++++++++++++-----
>  include/linux/virtio.h   |   3 +
>  3 files changed, 212 insertions(+), 25 deletions(-)
> 
> -- 
> 2.34.1


