Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72523365AC6
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 16:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232584AbhDTOFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 10:05:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:55310 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232359AbhDTOFj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 10:05:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1618927506; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N6JmTAHOdm3EBKzZL5WzHZUZAVTtx4LYm8/9OAbOF4I=;
        b=ew4B6zpLgm7CnWgrZy5ZalklxOHOI4v6mQdTC0jd8h5GfQImJbMaPOEGLsGl7ig/z9vbMu
        bESXKgEeT55ecoIIJ7whzdn0Q1nLOkLEWmvDf1fqwPTwAaFFS5KgerwM/fCj4bGcBUbez3
        tmxzrHozEeNEGp+/qGyPBaZrJ/el3J8=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BAF81B061;
        Tue, 20 Apr 2021 14:05:06 +0000 (UTC)
Date:   Tue, 20 Apr 2021 16:05:05 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Mike Rapoport <rppt@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mike Rapoport <rppt@linux.ibm.com>, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] docs: proc.rst: meminfo: briefly describe gaps in
 memory accounting
Message-ID: <YH7fkblsuxbHlUZn@dhcp22.suse.cz>
References: <20210420121354.1160437-1-rppt@kernel.org>
 <20210420132430.GB3596236@casper.infradead.org>
 <YH7ds1YOAOQt8Mpf@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YH7ds1YOAOQt8Mpf@dhcp22.suse.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 20-04-21 15:57:08, Michal Hocko wrote:
[...]
> Usual memory consumption is usually something like LRU pages + Slab
> memory + kernel stack + vmalloc used + pcp.
> 
> > But I know that KernelStack is allocated through vmalloc these days,
> > and I don't know whether VmallocUsed includes KernelStack or whether I
> > can sum them.  Similarly, is Mlocked a subset of Unevictable?

Forgot to reply to these two. Yes they do. So if we want to be precise
then you have to check the stack allocation configuration. There are
just so many traps lurking here. Something you get used to over time
but this is certainly far far away from an ideal state. What else we can
expect from an ad hoc approach to providing data to userspace that was
historically applied to this and many other proc interfaces. We are
trying to be strict for some time but some mistakes are simply hard to
fix up (e.g. accounting shmem as a page cache to name some more).

-- 
Michal Hocko
SUSE Labs
