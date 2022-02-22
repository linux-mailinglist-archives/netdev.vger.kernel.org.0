Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 775454BFDF0
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 16:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233858AbiBVQAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 11:00:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232976AbiBVQAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 11:00:16 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BBE6D8858;
        Tue, 22 Feb 2022 07:59:51 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id D23FE68B05; Tue, 22 Feb 2022 16:59:47 +0100 (CET)
Date:   Tue, 22 Feb 2022 16:59:47 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Baoquan He <bhe@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org, cl@linux.com,
        42.hyeyoo@gmail.com, penberg@kernel.org, rientjes@google.com,
        iamjoonsoo.kim@lge.com, vbabka@suse.cz, David.Laight@aculab.com,
        david@redhat.com, herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, steffen.klassert@secunet.com,
        netdev@vger.kernel.org, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
        svens@linux.ibm.com, linux-s390@vger.kernel.org, michael@walle.cc,
        linux-i2c@vger.kernel.org, wsa@kernel.org
Subject: Re: [PATCH 2/2] kernel/dma: rename dma_alloc_direct and
 dma_map_direct
Message-ID: <20220222155947.GB13323@lst.de>
References: <20220219005221.634-1-bhe@redhat.com> <20220219005221.634-22-bhe@redhat.com> <20220219071730.GG26711@lst.de> <20220220084044.GC93179@MiWiFi-R3L-srv> <20220222084530.GA6210@lst.de> <YhSpaGfiQV8Nmxr+@MiWiFi-R3L-srv> <20220222131120.GB10093@lst.de> <YhToPpeuTqdQgC80@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YhToPpeuTqdQgC80@MiWiFi-R3L-srv>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 09:42:22PM +0800, Baoquan He wrote:
> In the old dma mapping, coherent mapping uses dma_alloc_coherent() to
> allocate DMA buffer and mapping; while streaming mapping can only get
> memory from slab or buddy allocator, then map with dma_map_single().
> In that situation, dma_alloc_direct() checks a direct mapping for
> coherent DMA, dma_map_direct() checks a direct mapping for streaming
> DMA.
> 
> However, several new APIs have been added for streaming mapping, e.g
> dma_alloc_pages(). These new APIs take care of DMA buffer allocating
> and mapping which are similar with dma_alloc_coherent(). So we should
> rename both of them to reflect their real intention to avoid confusion.
> 
>        dma_alloc_direct()  ==>  dma_coherent_direct()
>        dma_map_direct()    ==>  dma_streaming_direct()

No, these new names are highly misleading.
