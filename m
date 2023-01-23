Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64E1867874F
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 21:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232821AbjAWULx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 15:11:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233060AbjAWULv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 15:11:51 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF58936478;
        Mon, 23 Jan 2023 12:11:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Ngc+CXDl+DsRbq3lWnI7piUsiNzsOROjyFJIUEysZJs=; b=bzGhtmRO6jbeOsswarmJVeMnGJ
        PR20MTV7RYmNRA5+zVjh3RcdblbYIX4PfGRdkeeHrOAAV7hgxTnV1765Sf+h/I8B4try7AX2xbAMH
        kX6i05ioo31SJlQy0wRDHcgHiNtCRQXKQCMqs/zCWD3tGqW94g9gx8HCkkuLKi4yAzCjaYVc8fBGr
        TWgqD8jt+62nusrZ/wgiFi56Ux+3t2Bnaj3HTWys8MriCwhBHt6Y24JfixJ/WPUoRUIGNwMsRNnj1
        pCw2z0L/V4dWwjgEkLiqcH7V47hwyDBHv0XTxRr5vJ7mL8PdD0MVQdl9hXxA/GnuUlUlTGr9i8bf+
        Nd/0SwTA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pK3AE-004Uoy-A2; Mon, 23 Jan 2023 20:11:34 +0000
Date:   Mon, 23 Jan 2023 20:11:34 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Jason Gunthorpe via Lsf-pc <lsf-pc@lists.linux-foundation.org>,
        lsf-pc@lists.linuxfoundation.org, linux-mm@kvack.org,
        iommu@lists.linux.dev, linux-rdma@vger.kernel.org,
        nvdimm@lists.linux.dev, John Hubbard <jhubbard@nvidia.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        dri-devel@lists.freedesktop.org, netdev@vger.kernel.org,
        Joao Martins <joao.m.martins@oracle.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [Lsf-pc] [LSF/MM/BPF proposal]: Physr discussion
Message-ID: <Y87p9i0vCZo/3Qa0@casper.infradead.org>
References: <Y8v+qVZ8OmodOCQ9@nvidia.com>
 <63cee1d3eaaef_3a36e529488@dwillia2-xfh.jf.intel.com.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63cee1d3eaaef_3a36e529488@dwillia2-xfh.jf.intel.com.notmuch>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 23, 2023 at 11:36:51AM -0800, Dan Williams wrote:
> Jason Gunthorpe via Lsf-pc wrote:
> > I would like to have a session at LSF to talk about Matthew's
> > physr discussion starter:
> > 
> >  https://lore.kernel.org/linux-mm/YdyKWeU0HTv8m7wD@casper.infradead.org/
> > 
> > I have become interested in this with some immediacy because of
> > IOMMUFD and this other discussion with Christoph:
> > 
> >  https://lore.kernel.org/kvm/4-v2-472615b3877e+28f7-vfio_dma_buf_jgg@nvidia.com/
> 
> I think this is a worthwhile discussion. My main hangup with 'struct
> page' elimination in general is that if anything needs to be allocated

You're the first one to bring up struct page elimination.  Neither Jason
nor I have that as our motivation.  But there are reasons why struct page
is a bad data structure, and Xen proves that you don't need to have such
a data structure in order to do I/O.

> When I read "general interest across all the driver subsystems" it is
> hard not to ask "have all possible avenues to enable 'struct page' been
> exhausted?"

Yes, we should definitely expend yet more resources chasing a poor
implementation.
