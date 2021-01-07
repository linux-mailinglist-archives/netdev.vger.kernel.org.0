Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92AC42EC7D5
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 02:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbhAGBt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 20:49:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:34790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726371AbhAGBt7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 20:49:59 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B75702223E;
        Thu,  7 Jan 2021 01:49:16 +0000 (UTC)
Date:   Wed, 6 Jan 2021 20:49:14 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Matthew Wilcox <willy@infradead.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: [BUG] from x86: Support kmap_local() forced debugging
Message-ID: <20210106204914.40eaf49a@oasis.local.home>
In-Reply-To: <CAHk-=wh2895wXEXYtb70CTgW+UR7jfh6VFhJB_bOrF0L7UKoEg@mail.gmail.com>
References: <20201118194838.753436396@linutronix.de>
        <20201118204007.169209557@linutronix.de>
        <20210106180132.41dc249d@gandalf.local.home>
        <CAHk-=wh2895wXEXYtb70CTgW+UR7jfh6VFhJB_bOrF0L7UKoEg@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 Jan 2021 17:03:48 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -366,7 +366,7 @@ static inline void skb_frag_size_sub(skb_frag_t *frag, int delta)
>  static inline bool skb_frag_must_loop(struct page *p)
>  {
>  #if defined(CONFIG_HIGHMEM)
> -	if (PageHighMem(p))
> +	if (IS_ENABLED(CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP) || PageHighMem(p))
>  		return true;
>  #endif
>  	return false;

I applied this and I haven't been able to crash it again.

Thanks,

-- Steve
