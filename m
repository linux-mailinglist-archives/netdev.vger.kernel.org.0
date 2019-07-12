Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA4B67519
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 20:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbfGLS1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 14:27:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59838 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726811AbfGLS1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 14:27:11 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8783614DE3031;
        Fri, 12 Jul 2019 11:27:10 -0700 (PDT)
Date:   Fri, 12 Jul 2019 11:27:07 -0700 (PDT)
Message-Id: <20190712.112707.1312895410671986857.davem@davemloft.net>
To:     willy@infradead.org
Cc:     hch@lst.de, netdev@vger.kernel.org
Subject: Re: [PATCH v3 0/7] Convert skb_frag_t to bio_vec
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190712134345.19767-1-willy@infradead.org>
References: <20190712134345.19767-1-willy@infradead.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 12 Jul 2019 11:27:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthew Wilcox <willy@infradead.org>
Date: Fri, 12 Jul 2019 06:43:38 -0700

> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> The skb_frag_t and bio_vec are fundamentally the same (page, offset,
> length) tuple.  This patch series unifies the two, leaving the
> skb_frag_t typedef in place.  This has the immediate advantage that
> we already have iov_iter support for bvecs and don't need to add
> support for iterating skbuffs.  It enables a long-term plan to use
> bvecs more broadly within the kernel and should make network-storage
> drivers able to do less work converting between skbuffs and biovecs.
> 
> It will consume more memory on 32-bit kernels.  If that proves
> problematic, we can look at ways of addressing it.
> 
> v3: Rebase on latest Linus with net-next merged.
>   - Reorder the uncontroversial 'Use skb accessors' patches first so you
>     can apply just those two if you want to hold off on the full
>     conversion.
>   - Convert all the users of 'struct skb_frag_struct' to skb_frag_t.

I have no objections to this series, please resubmit it (taking into
consideration any more feedback you get) when net-next opens back
up.
