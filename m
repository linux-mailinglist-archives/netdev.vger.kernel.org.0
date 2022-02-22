Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6D254BF8EB
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 14:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232251AbiBVNQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 08:16:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232231AbiBVNQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 08:16:43 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 226CE15C9C0;
        Tue, 22 Feb 2022 05:16:18 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id C982468BEB; Tue, 22 Feb 2022 14:16:10 +0100 (CET)
Date:   Tue, 22 Feb 2022 14:16:10 +0100
From:   'Christoph Hellwig' <hch@lst.de>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Christoph Hellwig' <hch@lst.de>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Baoquan He <bhe@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "cl@linux.com" <cl@linux.com>,
        "penberg@kernel.org" <penberg@kernel.org>,
        "rientjes@google.com" <rientjes@google.com>,
        "iamjoonsoo.kim@lge.com" <iamjoonsoo.kim@lge.com>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "david@redhat.com" <david@redhat.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "steffen.klassert@secunet.com" <steffen.klassert@secunet.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hca@linux.ibm.com" <hca@linux.ibm.com>,
        "gor@linux.ibm.com" <gor@linux.ibm.com>,
        "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "svens@linux.ibm.com" <svens@linux.ibm.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "michael@walle.cc" <michael@walle.cc>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "wsa@kernel.org" <wsa@kernel.org>
Subject: Re: [PATCH 22/22] mtd: rawnand: Use dma_alloc_noncoherent() for
 dma buffer
Message-ID: <20220222131610.GA10464@lst.de>
References: <20220219005221.634-1-bhe@redhat.com> <20220219005221.634-23-bhe@redhat.com> <20220219071900.GH26711@lst.de> <YhDSAJG+LksZSnLP@ip-172-31-19-208.ap-northeast-1.compute.internal> <20220222084652.GB6210@lst.de> <fe8deb6dd0b44a8a839820747451c37c@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe8deb6dd0b44a8a839820747451c37c@AcuMS.aculab.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 09:06:48AM +0000, David Laight wrote:
> From: Christoph Hellwig
> > Sent: 22 February 2022 08:47
> ...
> > > Hmm.. for this specific case, What about allocating two buffers
> > > for DMA_TO_DEVICE and DMA_FROM_DEVICE at initialization time?
> > 
> > That will work, but I don't see the benefit as you'd still need to call
> > dma_sync_single* before and after each data transfer.
> 
> For systems with an iommu that should save all the iommu setup
> for every transfer.

So does allocating a single buffer as in the patch we are replying to.
