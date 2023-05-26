Return-Path: <netdev+bounces-5641-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D43AF7124C5
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 12:34:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8FAE61C21048
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 10:34:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 448BB290EF;
	Fri, 26 May 2023 10:30:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C2F290EC
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:30:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB091B0
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685097018;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Mg7/ojhaSlvyz/vXgtSMO2mGG83UKNLR01zwLceFGek=;
	b=QcUPxN3xtd+24baPvOtker6r8DYzyGnxxOjse6mdiSoaRWl/gSRoS8yij0OFqqfECZTJMK
	mLCKkeWUQ4xV2oVUz593nHax42IwRXmnZ9hIZ3YHiCQqTmhAp2lZvh5v/jQ+6iiRBPyHfW
	D3o5eHR/yltcZUEbC2T7wGR7Wem4wxc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-344-oOwqix7aN8iENdbUETzXHg-1; Fri, 26 May 2023 06:30:16 -0400
X-MC-Unique: oOwqix7aN8iENdbUETzXHg-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3f60481749eso4002065e9.1
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:30:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685097015; x=1687689015;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mg7/ojhaSlvyz/vXgtSMO2mGG83UKNLR01zwLceFGek=;
        b=C66dkNFnz4ZCBkHVSJEHdDP8VvHUpP0EGzKPn4hyiKAeVTyhj9MTSAzn7T0/JVOHZp
         LW08Iwg4SqqISJ5GrPz/n6EBFIfci/BFBvFCdKuBrmHsoaD0tCzrpwxnoqDb8u7vMHTr
         bcQNkHGTMfQPiOs41sQDWkVrWOrN++3He800zxUSV4m0MIcPXb8Auk4Qfne6Bv7skRz+
         RgP7b68j14ocz97mqddUCacyVsbdwKeBy/ckflPQqJ4xVkHvIAvmCcDD9fl9aYMp22Xv
         8ELNTQtMDYsi43ioYwWBFAkT1K26E8Q+UMOh2ch/kLeI2nULfRXE1H7eQmwHIsjTA8jP
         9ofg==
X-Gm-Message-State: AC+VfDyvr0nkngmoSQYP3ZWqNAp3ccbhpx5ivE+aCdK2P7jW8yX4601i
	nYnAdrFR4JGDlZsYMNZJArVeLad57Fot0w1U/q65xTri43AohXgEvgG4spqHCbzULdJ7cQ28n+l
	gWvszcQfVc/9htgxu
X-Received: by 2002:a05:600c:3b13:b0:3f6:f81:385e with SMTP id m19-20020a05600c3b1300b003f60f81385emr4386158wms.17.1685097015596;
        Fri, 26 May 2023 03:30:15 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7azWOTs7u22NKP+c/72YjQZNnbnYXTsbR5Iqy6Gxd/0ppYvVT8VSjnd/KLYwpjJ1ml7uASbg==
X-Received: by 2002:a05:600c:3b13:b0:3f6:f81:385e with SMTP id m19-20020a05600c3b1300b003f60f81385emr4386137wms.17.1685097015327;
        Fri, 26 May 2023 03:30:15 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-25-16.business.telecomitalia.it. [87.12.25.16])
        by smtp.gmail.com with ESMTPSA id v7-20020a05600c214700b003f4f89bc48dsm8530412wml.15.2023.05.26.03.30.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 03:30:14 -0700 (PDT)
Date: Fri, 26 May 2023 12:30:11 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Arseniy Krasnov <avkrasnov@sberdevices.ru>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Bobby Eshleman <bobby.eshleman@bytedance.com>, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel@sberdevices.ru, 
	oxffffaa@gmail.com
Subject: Re: [RFC PATCH v3 00/17] vsock: MSG_ZEROCOPY flag support
Message-ID: <y5tgyj5awrd4hvlrsxsvrern6pd2sby2mdtskah2qp5hemmo2a@72nhcpilg7v2>
References: <20230522073950.3574171-1-AVKrasnov@sberdevices.ru>
 <76270fab-8af7-7597-9193-64cb553a543e@sberdevices.ru>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <76270fab-8af7-7597-9193-64cb553a543e@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 25, 2023 at 06:56:42PM +0300, Arseniy Krasnov wrote:
>
>
>On 22.05.2023 10:39, Arseniy Krasnov wrote:
>
>This patchset is unstable with SOCK_SEQPACKET. I'll fix it.

Thanks for let us know!

I'm thinking if we should start split this series in two, because it
becomes too big.

But let keep this for RFC, we can decide later. An idea is to send
the first 7 patches with a preparation series, and the next ones with a
second series.

Thanks,
Stefano


