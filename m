Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D54866AD2A
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 18:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjANR6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 12:58:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbjANR6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 12:58:52 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34B0FBB9F
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 09:58:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=LOcK5I7s4zlfeQqM7F+nIX/LNQKIkcTPp0wfB3PD3ug=; b=uvUkpi65TEsnVBIjavFKyoWDCW
        tXGRd/bqF9xPQsmLTeBYIOCXOopCb070FFWQYM2h3s/e3cIvb7JtfrGoNJ5jvozzfFPMX8YSm6i8S
        26UWzNU+KSf3/gB9KrmzK9u7ukzTpZC73GUVP2ebazcXKIQZd0g9RM40a/iKyH5RtLuzMCK29efLu
        LhYlZAMpUsn/wXTFdo3YbWJun0bAEneVNxzC2+f0ZS7TWY1XfR98vrslozmePxfNaOfRYUj7g30ET
        DShmBMRnEi2Rv9iHrMZ4PeDhlCgJTzwM2plVfm62R5eaKhevSPmySNd4LVmi74uqDYDPXdIDTblap
        VCskmg5w==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pGknw-007CGP-SW; Sat, 14 Jan 2023 17:58:56 +0000
Date:   Sat, 14 Jan 2023 17:58:56 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [PATCH v3 08/26] page_pool: Convert pp_alloc_cache to contain
 netmem
Message-ID: <Y8LtYEfdrN+cWiVm@casper.infradead.org>
References: <20230111042214.907030-1-willy@infradead.org>
 <20230111042214.907030-9-willy@infradead.org>
 <pj41zlwn5p1eom.fsf@u570694869fb251.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pj41zlwn5p1eom.fsf@u570694869fb251.ant.amazon.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 14, 2023 at 02:28:50PM +0200, Shay Agroskin wrote:
> >  	memset(&pool->alloc.cache, 0, sizeof(void *) * bulk);
> >    	nr_pages = alloc_pages_bulk_array_node(gfp, pool->p.nid,  bulk,
> > -					       pool->alloc.cache);
> > +					(struct page **)pool->alloc.cache);
> 
> Can you fix the alignment here (so that the '(struct page **)' would align
> the the 'gfp' argument one line above) ?

No, that makes the line too long.
