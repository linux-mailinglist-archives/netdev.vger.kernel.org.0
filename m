Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 412F13493D4
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 15:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbhCYON6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 10:13:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbhCYONX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 10:13:23 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56861C06174A;
        Thu, 25 Mar 2021 07:13:20 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id n138so2758742lfa.3;
        Thu, 25 Mar 2021 07:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=VAvP7bHgJVthEA6tXep78PEg1OIgagyy2ck803C3+C8=;
        b=QmBr4F3dyAhpQDZi73XbNsQ2sHduQfoFXI2Q2/+dUFFqxAipew/I6QUdQ4Z5pNWc54
         cIuUbg1Y0GHU5u3D/DICn8ZEkxXhVOz/AT9Lz3/lYf0MXLT9qhqSK8ta6yTphtcujRVx
         S+p4sBF/LODeJo9pAJL8vq4+g3o6iJkkARj6XD+Sh2Vh7jz9mb8ohU/4ton2D9HDs40F
         SrKsBKYlJAUfN1oPgmxk/YyAF0Cu3vNyIKzZI2rWosl5RXWJF94hSqIWa937GHh0xqCQ
         sumd6+0yML8dmVr/rGB6xl1gSEWUb0ld+lMqL+cm+YLN8IoAiGKykZQDYkVCQw2NFH1F
         Fn6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VAvP7bHgJVthEA6tXep78PEg1OIgagyy2ck803C3+C8=;
        b=HDZnq8MmO9LEkUXi9zLP2XnJcVKZ+6ofCWG7gDzosGeNmxPnkb+i1Bm5Lv4x87hYzG
         qdRUKAhVWG0ms1UbPi1H3ZIFdd6yfSyJe0iAdq0XURNXXOL2SBlx6s4FNx/Rk1Wp3lCu
         HT/wmJ/jgpZ2Ciccnjs49N3S3oskUYS9ouDZJErxtd1fqlc6414N7yGEUAh7gHqKZPAK
         L97Q6RSMtOB9pQi+fnN3TKzs2CJDSNZHg3gv7Aw2J3gW2izgTMlKFLoFqpJpyYt0RBOi
         qblWEKItem7OZ9TeEEdSYLX67mYGILb3/4KpcZoijZuxAOZZmQjhogQcTtitQRXif0hD
         bV3w==
X-Gm-Message-State: AOAM533fYmoJcUZYoe6TbSoIUEHJ2sAmufIOJknZC4kEbmKC0Puiwr3D
        SlnTDsXkkdOJEt3WeHWjars=
X-Google-Smtp-Source: ABdhPJxoNKK13uTKp11JZ98lxY1Zh1fctCxAwf6AVllaevDLbiGzUpnEJIgZXQcof0kFpWiNxS2ooA==
X-Received: by 2002:ac2:520f:: with SMTP id a15mr4921497lfl.223.1616681598809;
        Thu, 25 Mar 2021 07:13:18 -0700 (PDT)
Received: from pc638.lan (h5ef52e3d.seluork.dyn.perspektivbredband.net. [94.245.46.61])
        by smtp.gmail.com with ESMTPSA id m8sm562303lfa.274.2021.03.25.07.13.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 07:13:18 -0700 (PDT)
From:   Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc638.lan>
Date:   Thu, 25 Mar 2021 15:13:16 +0100
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Uladzislau Rezki <urezki@gmail.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 0/9 v6] Introduce a bulk order-0 page allocator with two
 in-tree users
Message-ID: <20210325141316.GA2558@pc638.lan>
References: <20210325114228.27719-1-mgorman@techsingularity.net>
 <20210325125001.GW1719932@casper.infradead.org>
 <20210325132556.GS3697@techsingularity.net>
 <20210325140657.GA1908@pc638.lan>
 <20210325140927.GX1719932@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210325140927.GX1719932@casper.infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 02:09:27PM +0000, Matthew Wilcox wrote:
> On Thu, Mar 25, 2021 at 03:06:57PM +0100, Uladzislau Rezki wrote:
> > For the vmalloc we should be able to allocating on a specific NUMA node,
> > at least the current interface takes it into account. As far as i see
> > the current interface allocate on a current node:
> > 
> > static inline unsigned long
> > alloc_pages_bulk_array(gfp_t gfp, unsigned long nr_pages, struct page **page_array)
> > {
> >     return __alloc_pages_bulk(gfp, numa_mem_id(), NULL, nr_pages, NULL, page_array);
> > }
> > 
> > Or am i missing something?
> 
> You can call __alloc_pages_bulk() directly; there's no need to indirect
> through alloc_pages_bulk_array().
>
OK. It is accessible then.

--
Vlad Rezki
