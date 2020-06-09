Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65B391F322F
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 04:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgFICIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 22:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726749AbgFICIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 22:08:37 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A429C03E969
        for <netdev@vger.kernel.org>; Mon,  8 Jun 2020 19:08:37 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 14055128A5EDF;
        Mon,  8 Jun 2020 19:08:37 -0700 (PDT)
Date:   Mon, 08 Jun 2020 19:08:36 -0700 (PDT)
Message-Id: <20200608.190836.147361780330392366.davem@davemloft.net>
To:     akpm@linux-foundation.org
Cc:     arjunroy@google.com, edumazet@google.com, jgg@ziepe.ca,
        netdev@vger.kernel.org, sfr@canb.auug.org.au, soheil@google.com,
        willy@infradead.org
Subject: Re: [patch 1/1] net-zerocopy: use vm_insert_pages() for tcp rcv
 zerocopy
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200608015441._rpcs9Om6%akpm@linux-foundation.org>
References: <20200608015441._rpcs9Om6%akpm@linux-foundation.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 08 Jun 2020 19:08:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: akpm@linux-foundation.org
Date: Sun, 07 Jun 2020 18:54:41 -0700

> From: Arjun Roy <arjunroy@google.com>
> Subject: net-zerocopy: use vm_insert_pages() for tcp rcv zerocopy
> 
> Use vm_insert_pages() for tcp receive zerocopy.  Spin lock cycles (as
> reported by perf) drop from a couple of percentage points to a fraction of
> a percent.  This results in a roughly 6% increase in efficiency, measured
> roughly as zerocopy receive count divided by CPU utilization.
> 
> The intention of this patchset is to reduce atomic ops for tcp zerocopy
> receives, which normally hits the same spinlock multiple times
> consecutively.
> 
> [akpm@linux-foundation.org: suppress gcc-7.2.0 warning]
> Link: http://lkml.kernel.org/r/20200128025958.43490-3-arjunroy.kdev@gmail.com
> Signed-off-by: Arjun Roy <arjunroy@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
> Cc: David Miller <davem@davemloft.net>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Applied, thank you.
