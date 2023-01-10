Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5573C664BA7
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 19:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234967AbjAJSw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 13:52:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235073AbjAJSwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 13:52:33 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C06CF4FCC8
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 10:47:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=i/9o7iNl6zIhJocKYwkxzObk5xjtVqd6JUFtOY8FyKQ=; b=AELf9y87WqHFA8TfIY326rRMk5
        Jr+ZcgRGBSwPm19GtkO7qNAS9E4q8pY+DcVleHVEQuFxit9tsYl1No0w8Wwj0XipdcLEU+xrqzwct
        pTy9wDqKztiLytpcUIeVN9MTgQxnNUX/nAJoHDuqz8FtEuRI/8+uJDvDHvoL4HogPy2b3e5SRWPAN
        Gl+6R1Z0KYr3IKWbdtTbAcHeIULTXCLVCxUM1aIQWQcwHpem20AMWnhlubqjN8SQ6omPOdXzwTHAi
        Y6GTs462QeuHu1yTT7T2AoL80KXaxIRCVnU859fvFoX6pv7AXBXi+vyx9XDGmzMRvXvNEW09u2Q+4
        9si2KJuA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pFJem-003SHj-Qf; Tue, 10 Jan 2023 18:47:32 +0000
Date:   Tue, 10 Jan 2023 18:47:32 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>, netdev@vger.kernel.org,
        linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 04/24] page_pool: Convert page_pool_release_page() to
 page_pool_release_netmem()
Message-ID: <Y72yxN065TaMm0ua@casper.infradead.org>
References: <20230105214631.3939268-1-willy@infradead.org>
 <20230105214631.3939268-5-willy@infradead.org>
 <Y70vqm/HlRvqL2Uv@hera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y70vqm/HlRvqL2Uv@hera>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 10, 2023 at 11:28:10AM +0200, Ilias Apalodimas wrote:
> > -static inline void page_pool_release_page(struct page_pool *pool,
> > -					  struct page *page)
> > +static inline void page_pool_release_netmem(struct page_pool *pool,
> > +					  struct netmem *nmem)
> >  {
> >  }
> >
> > @@ -378,6 +378,12 @@ static inline void page_pool_put_page_bulk(struct page_pool *pool, void **data,
> >  }
> >  #endif
> >
> 
> I think it's worth commenting here that page_pool_release_page() is
> eventually going to be removed once we convert all drivers and shouldn't
> be used anymore

OK.  How about I add this to each function in this category:

/* Compat, remove when all users gone */

and then we can find them all by grepping for 'Compat'?
