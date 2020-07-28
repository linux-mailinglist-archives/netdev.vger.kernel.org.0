Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E75B72310D5
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 19:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731929AbgG1R1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 13:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731684AbgG1R1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 13:27:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C04AC061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 10:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=FEtvrqnVlKXW6hngQTjeslLlcxFEzPlZsAIDGrW3MaI=; b=tMh2VOcymAzIoY1T4JhaKXadO0
        WFjcEzqiIo4LmCoW+P3qZctIJ463Fg5IbmRbTPqCBLA4RAG6oI3wA41mkdx0WLktY/7ifQ4EkREgk
        e2HEg+LZJuQNU7OZy+Z35HDPIcs/g9UdOzkgAbzD+Na917Fzp5Xr1hvWO89TiHYXu/aUSHMULf3qP
        GLyPKrbc5O+q+TMtILM/QebJHR5aqMzno6ScV3hpGA5Mt+yhFh9ihfC8qMXFQldplOwpDlr/NdkK7
        tEWlZns5WI9INHSiMKwpBA9ekNfiWQ5154laIOdFbZQy2hgw7GiTfflO6exbNvscwiX+iOQuRSFhQ
        6WXjzJ4Q==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k0TNX-0001e5-Cg; Tue, 28 Jul 2020 17:27:03 +0000
Date:   Tue, 28 Jul 2020 18:27:03 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Chris Mason <clm@fb.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [RFC PATCH v2 21/21] netgpu/nvidia: add Nvidia plugin for netgpu
Message-ID: <20200728172703.GA5667@infradead.org>
References: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
 <20200727224444.2987641-22-jonathan.lemon@gmail.com>
 <20200728163100.GD4181352@kroah.com>
 <A2C3C5F0-D86F-4D0C-8402-822063D2C6D1@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A2C3C5F0-D86F-4D0C-8402-822063D2C6D1@fb.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 01:18:48PM -0400, Chris Mason wrote:
> > come after in the future.
> 
> Jonathan, I think we need to do a better job talking about patches that are
> just meant to enable possible users vs patches that we actually hope the
> upstream kernel to take.  Obviously code that only supports out of tree
> drivers isn???t a good fit for the upstream kernel.  From the point of view
> of experimenting with these patches, GPUs benefit a lot from this
> functionality so I think it does make sense to have the enabling patches
> somewhere, just not in this series.

Sorry, but his crap is built only for this use case, and that is what
really pissed people off as it very much looks intentional.

> We???re finding it more common to have pcie switch hops between a [ GPU, NIC
> ] pair and the CPU, which gives a huge advantage to out of tree drivers or
> extensions that can DMA directly between the GPU/NIC without having to copy
> through the CPU.  I???d love to have an alternative built on TCP because
> that???s where we invest the vast majority of our tuning, security and
> interoperability testing.  It???s just more predictable overall.
> 
> This isn???t a new story, but if we can layer on APIs that enable this
> cleanly for in-tree drivers, we can work with the vendors to use better
> supported APIs and have a more stable kernel.  Obviously this is an RFC and
> there???s a long road ahead, but as long as the upstream kernel doesn???t
> provide an answer, out of tree drivers are going to fill in the weak spots.
> 
> Other possible use cases would include also include other GPUs or my
> favorite:
> 
> NVME <-> filesystem <-> NIC with io_uring driving the IO and without copies.

And we have all that working with the existing p2pdma infrastructure (at
least if you're using RDMA insted of badly reinventing it, but it could
be added to other users easily).

That infrastructure is EXPORT_SYMBOL_GPL as it should be for
infrastructure like that, and a lot of his crap just seems to be because
he's working around that.

So I really agree with Gred, this very much looks like a deliberate
trolling attempt.
