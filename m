Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6240F62A322
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 21:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbiKOUk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 15:40:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbiKOUkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 15:40:25 -0500
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AFBFE0A9
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 12:40:23 -0800 (PST)
Received: by mail-qk1-x734.google.com with SMTP id d7so7960105qkk.3
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 12:40:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7iYGXPjCmD+hOJN/hkZTaijhi0DrfdkinZFcCdyRXH8=;
        b=CwW9FhNKOaob37FQNRtH3IIpJJVYfCXdcm7NLENGdMxI2xxBXN6UNxxUcIkzynTxRo
         hEC4O6/Til1SAoNo0oxicCs4PwnePNgu023EFWUwVHTRfqtU3ZTJGA+g7PHjP83IcpBf
         pcVAB36gt92psfUNxZGQLABAYO0yihlXbtsKmfgztmNvidCUF7/T4lScA/xqUNz1nqby
         OGLw06kWxaR+2D8kJFCiA7PHjIx2Hc/49se95miUisA09qZELk4NJ/jhSIF7RX7EtvSY
         iNHt5UdqUawk/uLQy6AWdnLh7KUq7IU1Rs77JQpC80X+tcmsPPU0HvcPjyh+PfrpL4PL
         CEnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7iYGXPjCmD+hOJN/hkZTaijhi0DrfdkinZFcCdyRXH8=;
        b=DvfIWa2eLK/i7vlS/xspf88txjdP9nYv4FP1hXQ0exoTJGSPA9M8cbFSR7rK4DpfIp
         cRhNTtasl3PYaYntdVMAacbMW6AYTTfC69+W/FQNgAY9ghs06nL1teO2LSExpaLsxmcN
         uwxL+wOkQX/YiOScGAIxm5DD67TeL6bMe5oUk5KeH76AYLa6H7oQnITpHNb3XZ0Hz713
         lDOVJXn0FEu46Iam95AQBor6hV8Z0Z4bcibD3pa4HNCV/JSMc4+dj5LzcBTn+a08i36X
         vPTkfYo6EKkgl756m0L1MFRNWw9OfRgt1atxr/LiFCon2Kxt7TdMzZxUfOqZ4LI2ROON
         l3ow==
X-Gm-Message-State: ANoB5pkgHRZn6i/DCaSVT2khqsS85PiHSwarICGVSJroSMc2HnKBiF2R
        y6M0TNfOqHXShuFrRYwV6uXKSQ==
X-Google-Smtp-Source: AA0mqf6zvK1xRL3Tl3X3Az/h3DyNifOOA6ALfwSSuf97W778gOs/xLwq0pgU+qMVs85p3UoBcFP0jQ==
X-Received: by 2002:a37:2c03:0:b0:6fa:2cb5:8b4b with SMTP id s3-20020a372c03000000b006fa2cb58b4bmr16273452qkh.348.1668544822672;
        Tue, 15 Nov 2022 12:40:22 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-122-23.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.122.23])
        by smtp.gmail.com with ESMTPSA id i15-20020a05620a248f00b006fb3884e10bsm8883738qkn.24.2022.11.15.12.40.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 12:40:21 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1ov2jF-004k62-6h;
        Tue, 15 Nov 2022 16:40:21 -0400
Date:   Tue, 15 Nov 2022 16:40:21 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Russell King <linux@armlinux.org.uk>,
        Robin Murphy <robin.murphy@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-rdma@vger.kernel.org,
        iommu@lists.linux.dev, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 3/7] RDMA/qib: don't pass bogus GFP_ flags to
 dma_alloc_coherent
Message-ID: <Y3P5NWZNLo2+sdnn@ziepe.ca>
References: <20221113163535.884299-1-hch@lst.de>
 <20221113163535.884299-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221113163535.884299-4-hch@lst.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 13, 2022 at 05:35:31PM +0100, Christoph Hellwig wrote:
> dma_alloc_coherent is an opaque allocator that only uses the GFP_ flags
> for allocation context control.  Don't pass GFP_USER which doesn't make
> sense for a kernel DMA allocation or __GFP_COMP which makes no sense
> for an allocation that can't in any way be converted to a page pointer.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/infiniband/hw/qib/qib_iba6120.c |  2 +-
>  drivers/infiniband/hw/qib/qib_init.c    | 21 ++++-----------------
>  2 files changed, 5 insertions(+), 18 deletions(-)

Same same

Acked-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
