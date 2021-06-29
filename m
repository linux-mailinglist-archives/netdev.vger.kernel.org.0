Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83ECA3B6EC5
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 09:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232284AbhF2HgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 03:36:13 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:51476 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232233AbhF2HgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 03:36:11 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 997AA2260E;
        Tue, 29 Jun 2021 07:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1624952023; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=geQ8X9AXOnUE02C9Qq1it11DiCym9pX59BDvz1OzC7k=;
        b=P+tiQH5rW0/Dloy//w95TmLcNMu6BCsUHKys9M41li+NI8D8wXbiar2U1j2u5U0n0lEZFn
        u7k9rjUSbQ6384+6ASh8ezwuBUq+T1Ru2HxAjHYFwR9HLX0GQu3qQ0GfEth+yDNjgUABse
        z8bxmXM/5iE4VkgL4s3CxT2u8unwIPg=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 478CEA3B8F;
        Tue, 29 Jun 2021 07:33:43 +0000 (UTC)
Date:   Tue, 29 Jun 2021 09:33:42 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Tanner Love <tannerlove.kernel@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <maheshb@google.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        John Ogness <john.ogness@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Wei Wang <weiwan@google.com>, Taehee Yoo <ap420073@gmail.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Willem de Bruijn <willemb@google.com>,
        Tanner Love <tannerlove@google.com>
Subject: Re: [PATCH net-next v3 1/2] once: implement DO_ONCE_LITE for
 non-fast-path "do once" functionality
Message-ID: <YNrM1neBRdjkRf02@alley>
References: <20210628135007.1358909-1-tannerlove.kernel@gmail.com>
 <20210628135007.1358909-2-tannerlove.kernel@gmail.com>
 <20210628111446.357b2418@oasis.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210628111446.357b2418@oasis.local.home>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 2021-06-28 11:14:46, Steven Rostedt wrote:
> On Mon, 28 Jun 2021 09:50:06 -0400
> Tanner Love <tannerlove.kernel@gmail.com> wrote:
> 
> > Certain uses of "do once" functionality reside outside of fast path,
> > and so do not require jump label patching via static keys, making
> > existing DO_ONCE undesirable in such cases.
> > 
> > Replace uses of __section(".data.once") with DO_ONCE_LITE(_IF)?
> 
> I hate the name "_LITE" but can't come up with something better.
> 
> Maybe: DO_ONCE_SLOW() ??

Or rename the original DO_ONCE() to DO_ONCE_FAST() because it is
more tricky to be fast. And call the "normal" implementation DO_ONCE().

> Anyway, besides my bike-shedding comment above...

Same here :-)

Acked-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr
