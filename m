Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6709723AE
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 03:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728218AbfGXB2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 21:28:33 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:55292 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727716AbfGXB2c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 21:28:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=zK0MQKBuRm5eJyPW8isSrHF1S8sYIVd055jis7yH33Y=; b=M0W3mvfpFb3UVN8RsIxzKBmjV
        NCtWXY23fq1PEDmA4H0cmP9ZoRf4+o675ZjXtU+C9oAAy9nS0DBxGEoOWOc7d/eyXQnOxt5Gmj19+
        atCVUGGQH17T/LQuMh50lxXWAm7NdUZxNQaivoFcUzKsEc1XylbxYyhqexlanky3ebesot5xGaoMo
        XMlDcj4bP1MFaLD4kDoJSZ5TFeFF1+E/+ZOpc6jsC+d95IhuKo72VQeM+pvl8Q9dSQGUgXKBw0Pfi
        FCuURpD7UfvFappVLfd9PM48bCOKgrxvRmwkSIJhtivRGzpfLJis5JLup+wH8+KZ9kY7hPeNaxa4j
        rejDK9d3g==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hq64y-0005Dx-FE; Wed, 24 Jul 2019 01:28:28 +0000
Date:   Tue, 23 Jul 2019 18:28:28 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "hch@lst.de" <hch@lst.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 4/7] net: Reorder the contents of skb_frag_t
Message-ID: <20190724012828.GQ363@bombadil.infradead.org>
References: <20190712134345.19767-1-willy@infradead.org>
 <20190712134345.19767-5-willy@infradead.org>
 <2b45504e005f88a033405225b04fba0b5dcf2e92.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b45504e005f88a033405225b04fba0b5dcf2e92.camel@mellanox.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 23, 2019 at 10:29:06PM +0000, Saeed Mahameed wrote:
> On Fri, 2019-07-12 at 06:43 -0700, Matthew Wilcox wrote:
> > From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> > 
> > Match the layout of bio_vec.
> > 
> > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > ---
> >  include/linux/skbuff.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index 7910935410e6..b9dc8b4f24b1 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -314,8 +314,8 @@ struct skb_frag_struct {
> >  	struct {
> >  		struct page *p;
> >  	} page;
> > -	__u32 page_offset;
> >  	__u32 size;
> > +	__u32 page_offset;
> >  };
> >  
> 
> Why do you need this patch? this struct is going to be removed
> downstream eventually ..

If there's a performance regression, this is the perfect patch to include
as part of the bisection.  You'd think that this change could have no
effect, but I've seen weirder things.
