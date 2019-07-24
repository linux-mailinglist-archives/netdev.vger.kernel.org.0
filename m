Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A272723B4
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 03:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728069AbfGXBa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 21:30:58 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:56858 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727398AbfGXBa6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 21:30:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=N+8BhM7aTLz6GyAe7hTi6zVDHMkceW2amlsc99Za87Y=; b=e/0L1jQtz8rHDDcAIDoIEUvAQ
        O3RvnCEEFWN0Th5pYZdBPgquckQHGecAUcnVGoDoDNb5VJK2oQyRbSWCju6Al10Jf2rer9jUT5enx
        frPMrZLvWGJoDerNOYkjxSk8uJCFVxica1sw58SxljCHymQfqdTn8Sm2NLP55sa/rrD59TFR0DPvs
        8RhJrAphEWUbZZp+M7dsTR6VKzViz1GS3q9AJgj2dzdQ4P5w33MRLHn+aaZlkDUY2IunQlCFkJuRM
        3SmCVmjYaGDcDBWFPE11QhJj6lBEUfJvmRVjGgJk2SSnUvVogUV+wYHHHnyaQLp61pa3lCGTNe0tr
        2bJPFYVdA==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hq67L-0006l7-TX; Wed, 24 Jul 2019 01:30:55 +0000
Date:   Tue, 23 Jul 2019 18:30:55 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "hch@lst.de" <hch@lst.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 6/7] net: Rename skb_frag_t size to bv_len
Message-ID: <20190724013055.GR363@bombadil.infradead.org>
References: <20190712134345.19767-1-willy@infradead.org>
 <20190712134345.19767-7-willy@infradead.org>
 <267e43638c85447a5251ce9ca33356da4a8aa3f3.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <267e43638c85447a5251ce9ca33356da4a8aa3f3.camel@mellanox.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 23, 2019 at 10:33:59PM +0000, Saeed Mahameed wrote:
> >  struct skb_frag_struct {
> >  	struct page *bv_page;
> > -	__u32 size;
> > +	unsigned int bv_len;
> >  	__u32 page_offset;
> 
> Why do you keep page_offset name and type as is ? it will make the last
> patch much cleaner if you change it to "unsigned int bv_offset".

We don't have an accessor for page_offset, so there are about 280
occurrences of '>page_offset' in drivers/net/

Feel free to be the hero who does that cleanup.
