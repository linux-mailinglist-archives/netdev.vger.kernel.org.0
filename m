Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E44E52D668
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 16:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239940AbiESOsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 10:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239923AbiESOsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 10:48:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 66B559E9F6
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 07:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652971689;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1OAuMmOz0HL+Uy2U9iB8Am39R1ctikhJNEflzxuIzxs=;
        b=THEFu1p75ij2yqnzvzlvt9WzA+J3HLgsHf8t3oOpxLa+DijOWp/Kwr2bgC0lGx9Nku7XjA
        Y/53xSdLNeBtiE2q2xCtUuhB9J3Py+udceoBq2WYQEEKi0Qptt1HGbNi1DbvKUpFsaWoxm
        Ghw08vYwTGjApTRkDO9q8MnzjVI4EaU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-EijL88PdOQWiU9XSFSIPjQ-1; Thu, 19 May 2022 10:48:08 -0400
X-MC-Unique: EijL88PdOQWiU9XSFSIPjQ-1
Received: by mail-wm1-f71.google.com with SMTP id q128-20020a1c4386000000b003942fe15835so2123579wma.6
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 07:48:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=1OAuMmOz0HL+Uy2U9iB8Am39R1ctikhJNEflzxuIzxs=;
        b=VvSXqlDyNwzRVrPXUyQsdfEG1hozjNsFjDTU1jcnlBlX0XjeWXf2hs6lPninmupNMA
         c3wVgl40ILY7xGy3W46BOrQR8eaUVvccykvQLCDkIBkC68W6YeDWu6ZxkAcpIRf5aqFZ
         uXZvboLD0PSogDosmJZv9td0JqVJS5yUv0OkxNfT+JLmXkvM0HTfk1D2e6VezCFxRJUx
         cvWWjiR3b0gqtGOQuQUAa+ETYdo7WXO9s9uZeYeEs/z96Ak5ntD8NzNrgPNpSkgzp3HP
         aVp/oS0eGiARCNWBTx0ktsfbDnUGk8sSzDMnydWFEgt7kMjpKVVDWkbcp0bioZNJ2bfl
         ekmQ==
X-Gm-Message-State: AOAM530Au1QwCCDRMNJqAf2HQO7yFPbmfW+QYx6YPHTX72O0OEscaRjM
        LslZeiNWv4iv9dt0OHJvJ6i3Lexyrx5M6kWG0cLPIr/rdXbk+djREiPD8cDdCH/POlpWCD+PvJu
        nCpjEIX72D7jWDbmU
X-Received: by 2002:a05:600c:198f:b0:394:952d:9a72 with SMTP id t15-20020a05600c198f00b00394952d9a72mr4627448wmq.72.1652971687156;
        Thu, 19 May 2022 07:48:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwrkzJZYLrUDEogMR26ucPZYo2pitwKWmbuBkCcZMZ+f7N5rGYODtRfu066599B6CWYFRn8fg==
X-Received: by 2002:a05:600c:198f:b0:394:952d:9a72 with SMTP id t15-20020a05600c198f00b00394952d9a72mr4627423wmq.72.1652971686920;
        Thu, 19 May 2022 07:48:06 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-25-16.business.telecomitalia.it. [87.12.25.16])
        by smtp.gmail.com with ESMTPSA id 189-20020a1c02c6000000b00397342bcfb7sm787758wmc.46.2022.05.19.07.48.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 07:48:06 -0700 (PDT)
Date:   Thu, 19 May 2022 16:48:01 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>
Cc:     mst@redhat.com, jasowang@redhat.com, linux-kernel@vger.kernel.org,
        gdawar@xilinx.com, lingshan.zhu@intel.com, kvm@vger.kernel.org,
        lulu@redhat.com, netdev@vger.kernel.org, lvivier@redhat.com,
        eli@mellanox.com, virtualization@lists.linux-foundation.org,
        parav@nvidia.com
Subject: Re: [PATCH] vdpasim: allow to enable a vq repeatedly
Message-ID: <20220519144801.m7ioxoa5beo5jzv7@sgarzare-redhat>
References: <20220519143145.767845-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220519143145.767845-1-eperezma@redhat.com>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 19, 2022 at 04:31:45PM +0200, Eugenio Pérez wrote:
>Code must be resilient to enable a queue many times.
>
>At the moment the queue is resetting so it's definitely not the expected
>behavior.
>
>Fixes: 2c53d0f64c06 ("vdpasim: vDPA device simulator")
>Cc: stable@vger.kernel.org
>Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
>---
> drivers/vdpa/vdpa_sim/vdpa_sim.c | 5 +++--
> 1 file changed, 3 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
>index ddbe142af09a..b53cd00ad161 100644
>--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
>+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
>@@ -355,9 +355,10 @@ static void vdpasim_set_vq_ready(struct vdpa_device *vdpa, u16 idx, bool ready)
> 	struct vdpasim_virtqueue *vq = &vdpasim->vqs[idx];
>
> 	spin_lock(&vdpasim->lock);
>-	vq->ready = ready;
>-	if (vq->ready)
>+	if (!vq->ready) {
>+		vq->ready = ready;
> 		vdpasim_queue_ready(vdpasim, idx);
>+	}

But this way the first time vq->ready is set to true, then it will never 
be set back to false.

Should we leave the assignment out of the block?
Maybe after the if block to avoid the problem we are fixing.

Thanks,
Stefano

