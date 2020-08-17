Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCA3124749D
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 21:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392011AbgHQTMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 15:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730690AbgHQTM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 15:12:26 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C642FC061389;
        Mon, 17 Aug 2020 12:12:25 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id q14so15501476ilj.8;
        Mon, 17 Aug 2020 12:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NnKCBhQp2Gdr4n0TX2Bi3YpuER7JXpHBIDQP8R6n9AI=;
        b=GvMzuAxS6elmKSXxwtmwDg4ZABKQ94RBoIywyhmFuxzOvYj70kocfV6jjnvsD6xJUG
         TDoxSm0valHIzQ+TX5vr9M31BeFGUFSufYX4P6oEOMp0EM+3WgULq2SPTUHCgsOIRxuI
         fDyMPGMz+v+4byLbGWFj/UVM5255nK7fua7CeNib7oKaPFCl1EXmMDRODEX3VnP75fLd
         grnlAHLzvu/8yvLB6wGOmLG/dhoY8pJbKuZoJFz1OrzTsTTMBng+mF7Yb3wcndmk68im
         uw4FgY0JdtfocFKOeNcsRmidTCINPH/bEXdOXIZv0ihpFzBXEJoD1Qtei9Vvrm3Cod6j
         Eglg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NnKCBhQp2Gdr4n0TX2Bi3YpuER7JXpHBIDQP8R6n9AI=;
        b=VWAHb/g8D5UURwdhTs2KJ3iPt66p3RPHgiSwFuTRl6+q2LEhQVFLlqk1wuR66+8KpB
         06KL1LRdLwwxwbyLcS8Ou/j4EhmIhrpPt6Qj+dgkNbhT05jBfmtgUqowKE05yA0CgLU1
         UCA/QDq9ATyXYc/pL1wtA/58rqkilEA+iXOg6BJSk90xA9TS7ljmD44O+2twcekHMG/7
         iMw4sjqJZx/IhPeWhXKdZrtwMg11nG/VliCxHK22Q3tyYSyiEj5DjVfIQZj5emz1VrEh
         0Ru2u3M1v1Okae6XLll76NauQa0BlEjMfKiaf4rgBAjakw9WVBrrNoWP9EN88TRC+wYz
         2FuQ==
X-Gm-Message-State: AOAM532D8bjdrDJMSznm/TotFkZy+GZH+iJo0LZaFO2okhm+PrnkbpHB
        YbwIYpQCjFEp8/zW6DfiDf1JiehC0Ps7T5Fv80c=
X-Google-Smtp-Source: ABdhPJzXgU+DNHNKO8z9tSqkcxA+YPlJ5aCtnpEUqz2sSEapV34xuQepCaVuriNJ1z06vI0ZEuk2ZLoKyfGEp42KQIo=
X-Received: by 2002:a05:6e02:5c7:: with SMTP id l7mr15394166ils.268.1597691543350;
 Mon, 17 Aug 2020 12:12:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200816071518.6964-1-colyli@suse.de> <CAM_iQpUFtZdrhfUbuYYODNeSVqPOqx8mio6Znp6v3Q5iDZeyqg@mail.gmail.com>
 <20200817054538.GA11705@lst.de>
In-Reply-To: <20200817054538.GA11705@lst.de>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 17 Aug 2020 12:12:12 -0700
Message-ID: <CAM_iQpWnzm=cQZvZMcjKXez1L55tSVfWyadP3d0CUaT=D4nOhw@mail.gmail.com>
Subject: Re: [PATCH v5 1/3] net: introduce helper sendpage_ok() in include/linux/net.h
To:     Christoph Hellwig <hch@lst.de>
Cc:     Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Hannes Reinecke <hare@suse.de>, Jan Kara <jack@suse.com>,
        Jens Axboe <axboe@kernel.dk>,
        Mikhail Skorzhinskii <mskorzhinskiy@solarflare.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Vlastimil Babka <vbabka@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 16, 2020 at 10:45 PM Christoph Hellwig <hch@lst.de> wrote:
>
> On Sun, Aug 16, 2020 at 10:55:09AM -0700, Cong Wang wrote:
> > On Sun, Aug 16, 2020 at 1:36 AM Coly Li <colyli@suse.de> wrote:
> > >
> > > The original problem was from nvme-over-tcp code, who mistakenly uses
> > > kernel_sendpage() to send pages allocated by __get_free_pages() without
> > > __GFP_COMP flag. Such pages don't have refcount (page_count is 0) on
> > > tail pages, sending them by kernel_sendpage() may trigger a kernel panic
> > > from a corrupted kernel heap, because these pages are incorrectly freed
> > > in network stack as page_count 0 pages.
> > >
> > > This patch introduces a helper sendpage_ok(), it returns true if the
> > > checking page,
> > > - is not slab page: PageSlab(page) is false.
> > > - has page refcount: page_count(page) is not zero
> > >
> > > All drivers who want to send page to remote end by kernel_sendpage()
> > > may use this helper to check whether the page is OK. If the helper does
> > > not return true, the driver should try other non sendpage method (e.g.
> > > sock_no_sendpage()) to handle the page.
> >
> > Can we leave this helper to mm subsystem?
> >
> > I know it is for sendpage, but its implementation is all about some
> > mm details and its two callers do not belong to net subsystem either.
> >
> > Think this in another way: who would fix it if it is buggy? I bet mm people
> > should. ;)
>
> No.  This is all about a really unusual imitation in sendpage, which

So netdev people will have to understand and support PageSlab() or
page_count()?

If it is unusual even for mm people, how could netdev people suppose
to understand this unusual mm bug? At least not any better.

> is pretty much unexpected.  In fact the best thing would be to make
> sock_sendpage do the right thing and call sock_no_sendpage based
> on this condition, so that driver writers don't have to worry at all.

Agreed, but kernel_sendpage() still relies on mm to provide a helper
to make the decision and ensure this helper is always up-to-date.

In short, it is all about ownership.

Thanks.
