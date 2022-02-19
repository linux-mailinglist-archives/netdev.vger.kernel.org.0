Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 899204BC821
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 12:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237014AbiBSLSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 06:18:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbiBSLSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 06:18:50 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 280CB1405E5;
        Sat, 19 Feb 2022 03:18:32 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id h125so10045052pgc.3;
        Sat, 19 Feb 2022 03:18:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=T9wL2HNOoTgBZyR7LnzekNWG1kIrAc5CB3FyMF90in4=;
        b=AKr/HZtB3nquxX/MtfbxTPxV12bTXOYvn238/PxnW0MXFPvwUMuvQm4pSP2ByR4afp
         7CRauKL6AyW537CotJWum8uw+2DBwxh4qfpI3VJiasOdQ5vQkfjRksY1TdFYiT2Y8GIK
         rFRwatWTqK3t/5sVFaAFX5oQNyf0CNvBXAsN9kSosKZaUkl0a5nNH8t2UvnT84Y8xQGm
         v6eaNilBb2nDcNkPir3151J48dq4KTWHlCWpy2pWtzQU2A8HR+ALSLt5NbaD7Ol2vhBp
         UWTjX1b64stJNYWfl3sYgLdfsymPU3IIPFIkdfDtdPyi4+6CT10rN0Ov+HrZ1Bsg5w9U
         om4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=T9wL2HNOoTgBZyR7LnzekNWG1kIrAc5CB3FyMF90in4=;
        b=GmUXQht2qqYNXUaGam/P7LaUTd2ZoXKiCBVRqStkNLgSJV2GbpDWQXYFZL/oRlK+zM
         FM68gYpzO3/rG2lL+po9bIO7HE8ETQufO1xwFldiO/zRz+Y0ZmarhpdRXjAEYCMoonYH
         k7CIflbTP4edt0X52poNy9/nbwPlqa5s1htxeaSbYlZZFbji7Bq+2WelYu6odBVZXWT8
         RQDQqUnioPckUe/VQWMtcMOyP1xcwvExYsyYQe/cOVjmAId3myw9zx9I8qW8mjQRVCE8
         W7swQ/jYzHYCDI5I4dBPUwPeUPy1NQ7TJE5zR1VbfFa7m+F925Ww04RHVirfWTjtnwRp
         jalg==
X-Gm-Message-State: AOAM530uo2sumkBYD+/Sh6ivh6VuSarWBCcM9vB///NVloU1h/KnNR8C
        LXd/DBgXgxMzRE+Xm+ORLdY=
X-Google-Smtp-Source: ABdhPJzJHg6MUMNmql+V4RRtwfXePN6ptFHUaPpMP1plEFbEbnlYUEQw7bbCjNbrsib/NZlMXZNZZA==
X-Received: by 2002:a05:6a00:1995:b0:4e1:a7dd:96d6 with SMTP id d21-20020a056a00199500b004e1a7dd96d6mr11666406pfl.16.1645269511646;
        Sat, 19 Feb 2022 03:18:31 -0800 (PST)
Received: from ip-172-31-19-208.ap-northeast-1.compute.internal (ec2-18-181-137-102.ap-northeast-1.compute.amazonaws.com. [18.181.137.102])
        by smtp.gmail.com with ESMTPSA id y191sm6523542pfb.78.2022.02.19.03.18.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Feb 2022 03:18:31 -0800 (PST)
Date:   Sat, 19 Feb 2022 11:18:24 +0000
From:   Hyeonggon Yoo <42.hyeyoo@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Baoquan He <bhe@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org, cl@linux.com,
        penberg@kernel.org, rientjes@google.com, iamjoonsoo.kim@lge.com,
        vbabka@suse.cz, David.Laight@aculab.com, david@redhat.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, steffen.klassert@secunet.com,
        netdev@vger.kernel.org, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
        svens@linux.ibm.com, linux-s390@vger.kernel.org, michael@walle.cc,
        linux-i2c@vger.kernel.org, wsa@kernel.org
Subject: Re: [PATCH 22/22] mtd: rawnand: Use dma_alloc_noncoherent() for dma
 buffer
Message-ID: <YhDSAJG+LksZSnLP@ip-172-31-19-208.ap-northeast-1.compute.internal>
References: <20220219005221.634-1-bhe@redhat.com>
 <20220219005221.634-23-bhe@redhat.com>
 <20220219071900.GH26711@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220219071900.GH26711@lst.de>
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 19, 2022 at 08:19:00AM +0100, Christoph Hellwig wrote:
> On Sat, Feb 19, 2022 at 08:52:21AM +0800, Baoquan He wrote:
> > Use dma_alloc_noncoherent() instead of directly allocating buffer
> > from kmalloc with GFP_DMA. DMA API will try to allocate buffer
> > depending on devices addressing limitation.
> 
> I think it would be better to still allocate the buffer at allocation
> time and then just transfer ownership using dma_sync_single* in the I/O
> path to avoid the GFP_ATOMIC allocation.

This driver allocates the buffer at initialization step and maps the buffer
for DMA_TO_DEVICE and DMA_FROM_DEVICE when processing IO.

But after making this driver to use dma_alloc_noncoherent(), remapping
dma_alloc_noncoherent()-ed buffer is strange So I just made it to allocate
the buffer in IO path.

At this point I thought we need an API that allocates based on
address bit mask (like dma_alloc_noncoherent()), which does not maps buffer
into dma address. __get_free_pages/kmalloc(GFP_DMA) has been so confusing..

Hmm.. for this specific case, What about allocating two buffers
for DMA_TO_DEVICE and DMA_FROM_DEVICE at initialization time?

Thanks,
Hyeonggon

