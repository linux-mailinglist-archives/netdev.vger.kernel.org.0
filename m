Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 562FE1265BD
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 16:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbfLSP2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 10:28:49 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46657 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726813AbfLSP2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 10:28:47 -0500
Received: by mail-wr1-f65.google.com with SMTP id z7so6359481wrl.13
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 07:28:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=i3mTBRS7AQPPgtvaPLT01gq1ez3hV630kHrfvTiVFPY=;
        b=bm2Q7yg+XRagohMcZJ+2XrM/uCM9GAtEzSd4ya8LC/HNvy5X+Bd0n2QownQFzu+gaG
         082Spvr/Qi1OVjiUgfOhT9A/dLFbCHIN9w+0oWh7CPTPrQWXW+4zOSt4NBto0qZWhBCU
         jYxG4PamMc0zwTV3GzSdyH7hWpopVt7qIhLs/NwbPOGL5bybP8W/2RtSYmeg7Caagr70
         dIWDkg3A4LDmm7zCPBCPDGWIGpF3ZWps3uWLTkrdN5U3Q2nTNKTsn8mDsp78F3AY1Ypg
         Y9Qk4tCc5N6wd/qHToksiQZ9unnQ4nC42T8Zbx23aOdOpnaYIgv+Ou9/3/Kx6aHuSuoo
         mQAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=i3mTBRS7AQPPgtvaPLT01gq1ez3hV630kHrfvTiVFPY=;
        b=GngPddvdzHklGw1Rvc0B8jRvIusVphRtRHIz/fPG859I+WeRyUZgQhbhT6WRM7wjTr
         gi/OHiEXa2Hxpu2kPkeq+j2vTPG+a1/DPsZf9yXCkcH6aSXCareCd3zgtBlg7nIdmBAF
         X6LvWSPrG4qdwe1JmivJIzG5x4Q/8l+ZoHPtNgF0Ep07UaCq7GS+y1sRnmsaYS7BcYeb
         osRjmVK/AIH6WB7nVRXi3B5hO4MrgKOlIKwy6tRYd8lbWtDOY5MzWsIm0nh5InKb+z35
         /qm/blSAQSE2c/xWNt5/m6OYNj+XkGnKph3GpXuhdDlM/5Knsdxhyt5f1Mx5ABiIXg0y
         3JBw==
X-Gm-Message-State: APjAAAVUv6pd6eltLJ0U+XOQbTs3uubzN4ob1qGX64phzaOASy2W2Now
        /oaPZeuhwz7Ak0R+SI+AbeK3Rg==
X-Google-Smtp-Source: APXvYqziKLCATaCMCodRy6HwZfmyktzfE1GJqDQbMRumFaq9FlvUFmD50TLTlNoKXZl+bbctvtlFvg==
X-Received: by 2002:adf:ffc7:: with SMTP id x7mr10016255wrs.159.1576769325750;
        Thu, 19 Dec 2019 07:28:45 -0800 (PST)
Received: from apalos.home (ppp-94-64-118-170.home.otenet.gr. [94.64.118.170])
        by smtp.gmail.com with ESMTPSA id t190sm6506919wmt.44.2019.12.19.07.28.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 07:28:44 -0800 (PST)
Date:   Thu, 19 Dec 2019 17:28:41 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Michal Hocko <mhocko@kernel.org>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        lirongqing@baidu.com, linyunsheng@huawei.com,
        Saeed Mahameed <saeedm@mellanox.com>, peterz@infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next v4 PATCH] page_pool: handle page recycle for
 NUMA_NO_NODE condition
Message-ID: <20191219152841.GA6889@apalos.home>
References: <20191218084437.6db92d32@carbon>
 <157665609556.170047.13435503155369210509.stgit@firesoul>
 <20191219120925.GD26945@dhcp22.suse.cz>
 <20191219143535.6c7bc880@carbon>
 <20191219145206.GE26945@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191219145206.GE26945@dhcp22.suse.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 03:52:06PM +0100, Michal Hocko wrote:
> On Thu 19-12-19 14:35:35, Jesper Dangaard Brouer wrote:
> > On Thu, 19 Dec 2019 13:09:25 +0100
> > Michal Hocko <mhocko@kernel.org> wrote:
> > 
> > > On Wed 18-12-19 09:01:35, Jesper Dangaard Brouer wrote:
> > > [...]
> > > > For the NUMA_NO_NODE case, when a NIC IRQ is moved to another NUMA
> > > > node, then ptr_ring will be emptied in 65 (PP_ALLOC_CACHE_REFILL+1)
> > > > chunks per allocation and allocation fall-through to the real
> > > > page-allocator with the new nid derived from numa_mem_id(). We accept
> > > > that transitioning the alloc cache doesn't happen immediately.  
> > 
> > Oh, I just realized that the drivers usually refill several RX
> > packet-pages at once, this means that this is called N times, meaning
> > during a NUMA change this will result in N * 65 pages returned.
> > 
> > 
> > > Could you explain what is the expected semantic of NUMA_NO_NODE in this
> > > case? Does it imply always the preferred locality? See my other email[1] to
> > > this matter.
> > 
> > I do think we want NUMA_NO_NODE to mean preferred locality.
> 

Why? wouldn't it be clearer if it meant "this is not NUMA AWARE"?
The way i see it iyou have drivers that sit on specific SoCs, 
like the ti one, or the netsec one can declare 'NUMA_NO_NODE' since they 
know beforehand what hardware they'll be sitting on.
On PCI/USB pluggable interfaces mlx5 example should be followed.

> I obviously have no saying here because I am not really familiar with
> the users of this API but I would note that if there is such an implicit
> assumption then you make it impossible to use the numa agnostic page
> pool allocator (aka fast reallocation). This might be not important here
> but future extension would be harder (you can still hack it around aka
> NUMA_REALLY_NO_NODE). My experience tells me that people are quite
> creative and usually require (or worse assume) semantics that you
> thought were not useful.
> 
> That being said, if the NUMA_NO_NODE really should have a special
> locality meaning then document it explicitly at least.

Agree, if we treat it like this we have to document it somehow

> -- 
> Michal Hocko
> SUSE Labs

Thanks
/Ilias
