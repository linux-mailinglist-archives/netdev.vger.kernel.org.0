Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A78870AD4
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 22:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728981AbfGVUkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 16:40:01 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:35334 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728712AbfGVUkA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 16:40:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Ne22EWsQCya/Sht+tb93SyFz7IV55NdinkNdfa9LLYM=; b=MIL5ds92vgR6qWcoxTqHZCFhj
        +bqXrwJoXxwfOlqki80udrKBylbacfdiWVPwyyCPnuDYd/TQzWPguwwB8DwbP/zXVJT6HJ6Y6d9G7
        hLfLrBsEFTV4VZ+uUM+nTnipDH9u+q59dgLzzQ0TAunih4nheNfP5/cpe+I6Vl++IzyaEvQsdI7IH
        tg9So93gfIQyqxtrJj04SA1zyTO0lDZbqrE4YH9dLwo5/y/2FYgVpWlhtWnH+IoaA0zWJWp7h11Jp
        rbl0x16NQUNjgNfzsCDWaJ1q1uCLMfnQDVfDCaWi2bwGNpH7gL7DJL5dAcKCAQR9jZAMmiiIZFN5X
        TrtXlujyg==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hpf6F-0000Vx-Oa; Mon, 22 Jul 2019 20:39:59 +0000
Date:   Mon, 22 Jul 2019 13:39:59 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     David Miller <davem@davemloft.net>
Cc:     hch@lst.de, netdev@vger.kernel.org
Subject: Re: [PATCH v3 0/7] Convert skb_frag_t to bio_vec
Message-ID: <20190722203959.GH363@bombadil.infradead.org>
References: <20190712134345.19767-1-willy@infradead.org>
 <20190712.112707.1312895410671986857.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190712.112707.1312895410671986857.davem@davemloft.net>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 12, 2019 at 11:27:07AM -0700, David Miller wrote:
> From: Matthew Wilcox <willy@infradead.org>
> Date: Fri, 12 Jul 2019 06:43:38 -0700
> 
> > From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> > 
> > The skb_frag_t and bio_vec are fundamentally the same (page, offset,
> > length) tuple.  This patch series unifies the two, leaving the
> > skb_frag_t typedef in place.  This has the immediate advantage that
> > we already have iov_iter support for bvecs and don't need to add
> > support for iterating skbuffs.  It enables a long-term plan to use
> > bvecs more broadly within the kernel and should make network-storage
> > drivers able to do less work converting between skbuffs and biovecs.
> > 
> > It will consume more memory on 32-bit kernels.  If that proves
> > problematic, we can look at ways of addressing it.
> > 
> > v3: Rebase on latest Linus with net-next merged.
> >   - Reorder the uncontroversial 'Use skb accessors' patches first so you
> >     can apply just those two if you want to hold off on the full
> >     conversion.
> >   - Convert all the users of 'struct skb_frag_struct' to skb_frag_t.
> 
> I have no objections to this series, please resubmit it (taking into
> consideration any more feedback you get) when net-next opens back
> up.

No further feedback received, and the patches still apply cleanly to
Linus' head.  Do you want the patch series resent, or does your workflow
let you just pick these patches up now?
