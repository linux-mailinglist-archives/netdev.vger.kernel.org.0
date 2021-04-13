Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 848B935E628
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 20:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236781AbhDMSSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 14:18:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:50136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229730AbhDMSSu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 14:18:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CF0F613B1;
        Tue, 13 Apr 2021 18:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618337909;
        bh=lnhhbqIc2W4LnVDiQzj8jL+mMwuaFEZs0tlPsrc89xs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KFTlFkPUKo8X091jFtxiYypMGba/b0J+tgufnl0B8BHVtqHnXJ1V3TuJxjye2Ojew
         eJ+ol4wZlfARl80mkeuJIC87q5ZpBbQv1Q3hHaztNAXhgv5sDLV7hr6dcJxPXNsHuQ
         KQ7oBQxDxZZ+1kRK58catB2fWQ5j1t6D8FQr9wHA=
Date:   Tue, 13 Apr 2021 11:18:28 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        drbd-dev@tron.linbit.com, Jiri Pirko <jiri@nvidia.com>,
        netdev@vger.kernel.org, Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] lib: remove "expecting prototype" kernel-doc warnings
Message-Id: <20210413111828.365dcbcb2e24bfaa91e855ff@linux-foundation.org>
In-Reply-To: <20210411221756.15461-1-rdunlap@infradead.org>
References: <20210411221756.15461-1-rdunlap@infradead.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 11 Apr 2021 15:17:56 -0700 Randy Dunlap <rdunlap@infradead.org> wrote:

> Fix various kernel-doc warnings in lib/ due to missing or
> erroneous function names.
> Add kernel-doc for some function parameters that was missing.
> Use kernel-doc "Return:" notation in earlycpio.c.
> 
> Quietens the following warnings:
> 
> ../lib/earlycpio.c:61: warning: expecting prototype for cpio_data find_cpio_data(). Prototype was for find_cpio_data() instead
> 
> ../lib/lru_cache.c:640: warning: expecting prototype for lc_dump(). Prototype was for lc_seq_dump_details() instead
> lru_cache.c:90: warning: Function parameter or member 'cache' not described in 'lc_create'

I'm still seeing this.

> lru_cache.c:90: warning: Function parameter or member 'cache' not described in 'lc_create'

But it looks OK:

/**
 * lc_create - prepares to track objects in an active set
 * @name: descriptive name only used in lc_seq_printf_stats and lc_seq_dump_details
 * @cache: cache root pointer
 * @max_pending_changes: maximum changes to accumulate until a transaction is required
 * @e_count: number of elements allowed to be active simultaneously
 * @e_size: size of the tracked objects
 * @e_off: offset to the &struct lc_element member in a tracked object
 *
 * Returns a pointer to a newly initialized struct lru_cache on success,
 * or NULL on (allocation) failure.
 */
struct lru_cache *lc_create(const char *name, struct kmem_cache *cache,
		unsigned max_pending_changes,
		unsigned e_count, size_t e_size, size_t e_off)
{

