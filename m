Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB6E47BC52
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 10:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235957AbhLUJAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 04:00:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233983AbhLUJAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 04:00:25 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BCF5C061574;
        Tue, 21 Dec 2021 01:00:25 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id z6so10224345plk.6;
        Tue, 21 Dec 2021 01:00:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9NGcNjPFQFwNukGSQ3BCeKUkpyszlG6cgJNyzICTwHs=;
        b=HCidw9eDvVV7QUE/F/UMe5W/+yBsyX5d+ko8CJBX4Na2MLrUUKLBQb/mzQ/jlLxnaQ
         xoVCB95T8jxgZfb3I91EgUZ6gqIh1qUJID4uHNc2lR3GmawcOjXwXLBZKrjUKy9tjq/M
         5cbBQq8D7w3vbODgHixlz1ISsjgowk7fuxwaasrTPWvmpigr+y/+++3PRHhhzbemOP6Y
         z8b7XznzfgLsrQfFJ6E6hWDxZLzODqqI04RB18/BL76TNxjJA5A/GSe4iXMyABZJqwKn
         R0gPHsdc4efhUkhyq8bG65SfqAb2dl6Jt4+9FqYyo2fMrkVypBKXUkp8Kf/6eb0NFbAS
         oOew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9NGcNjPFQFwNukGSQ3BCeKUkpyszlG6cgJNyzICTwHs=;
        b=iUNhOWlK5inaxLR1HMbuir6ZxevR/GmnRemCztJi7meUF11Eb3fRF/dUdTKwkjdoMf
         7HqJeFAQ/XZ0QE7wfR2BiMZ96KLl4jfZspc6kiTUR9V2pfMADE3WJ8SQtUb4Q/TvFq7r
         LwgArjt/SnFvq0rXkLR5c6Ftbe2f+gjfkk9AFMWph+1RU4f7Svfh1rhaagbWiS3kDLdH
         vHeV9oPtcR5eXDzNZePfr5H39/JxmLYkPsZ7vuLeTkolTb0ybbZlR9BLisiMtiKv3fFh
         u9sg/KNti3yVBP+MgWZOzu9osJnM1a2eR4gGKMVCXShXijgswa3a815wvszg69gQMIo7
         utNA==
X-Gm-Message-State: AOAM533zscEW94M3ENzABamxoA9Z7vrDje0xjcjnYCq3zRMyuP7YBT8y
        67ogxoRpB3ORfzc9kDcRit2YJYeiWYWbZQE4rN8=
X-Google-Smtp-Source: ABdhPJzdvFfM8gZi0xrs5NbFks9pLPXkVitAfxH4N8wvWeKkrpJIzERjI2t5e2oGoGt4AH44L8tuscPD15xbj9Vt9gs=
X-Received: by 2002:a17:902:b197:b0:148:a2e7:fb4d with SMTP id
 s23-20020a170902b19700b00148a2e7fb4dmr2295269plr.142.1640077224799; Tue, 21
 Dec 2021 01:00:24 -0800 (PST)
MIME-Version: 1.0
References: <20211220155250.2746-1-ciara.loftus@intel.com> <CAJ8uoz2-jZTqT_XkP6T2c0VAzC=QcENr2dJrE5ZivUx8Ak_6ZA@mail.gmail.com>
 <PH0PR11MB479171AF2D4CE0B118B47A208E7C9@PH0PR11MB4791.namprd11.prod.outlook.com>
In-Reply-To: <PH0PR11MB479171AF2D4CE0B118B47A208E7C9@PH0PR11MB4791.namprd11.prod.outlook.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 21 Dec 2021 10:00:13 +0100
Message-ID: <CAJ8uoz3HYUO_NK+GCHtDWiczp-pDqpk6V+f5X5KkAJqN70nAnQ@mail.gmail.com>
Subject: Re: [PATCH bpf] xsk: Initialise xskb free_list_node
To:     "Loftus, Ciara" <ciara.loftus@intel.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 21, 2021 at 9:32 AM Loftus, Ciara <ciara.loftus@intel.com> wrote:
>
> > On Mon, Dec 20, 2021 at 9:10 PM Ciara Loftus <ciara.loftus@intel.com>
> > wrote:
> > >
> > > This commit initialises the xskb's free_list_node when the xskb is
> > > allocated. This prevents a potential false negative returned from a call
> > > to list_empty for that node, such as the one introduced in commit
> > > 199d983bc015 ("xsk: Fix crash on double free in buffer pool")
> > >
> > > In my environment this issue caused packets to not be received by
> > > the xdpsock application if the traffic was running prior to application
> > > launch. This happened when the first batch of packets failed the xskmap
> > > lookup and XDP_PASS was returned from the bpf program. This action is
> > > handled in the i40e zc driver (and others) by allocating an skbuff,
> > > freeing the xdp_buff and adding the associated xskb to the
> > > xsk_buff_pool's free_list if it hadn't been added already. Without this
> > > fix, the xskb is not added to the free_list because the check to determine
> > > if it was added already returns an invalid positive result. Later, this
> > > caused allocation errors in the driver and the failure to receive packets.
> >
> > Thank you for this fix Ciara! Though I do think the Fixes tag should
> > be the one above: 199d983bc015 ("xsk: Fix crash on double free in
> > buffer pool"). Before that commit, there was no test for an empty list
> > in the xp_free path. The entry was unconditionally put on the list and
> > "initialized" in that way, so that code will work without this patch.
> > What do you think?
>
> Agree - that makes sense.
> Can the fixes tag be updated when pulled into the tree with:
> Fixes: 199d983bc015 ("xsk: Fix crash on double free in buffer pool")

On the other hand, this was a fix for 2b43470add8c ("xsk: Introduce
AF_XDP buffer allocation API"), the original tag you have in your
patch. What should the Fixes tag point to in this case? Need some
advice please.

> If I need to submit a v2 with the change please let me know.
>
> Thanks,
> Ciara
>
> >
> > Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
> >
> > > Fixes: 2b43470add8c ("xsk: Introduce AF_XDP buffer allocation API")
> > >
> > > Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
> > > ---
> > >  net/xdp/xsk_buff_pool.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
> > > index bc4ad48ea4f0..fd39bb660ebc 100644
> > > --- a/net/xdp/xsk_buff_pool.c
> > > +++ b/net/xdp/xsk_buff_pool.c
> > > @@ -83,6 +83,7 @@ struct xsk_buff_pool
> > *xp_create_and_assign_umem(struct xdp_sock *xs,
> > >                 xskb = &pool->heads[i];
> > >                 xskb->pool = pool;
> > >                 xskb->xdp.frame_sz = umem->chunk_size - umem->headroom;
> > > +               INIT_LIST_HEAD(&xskb->free_list_node);
> > >                 if (pool->unaligned)
> > >                         pool->free_heads[i] = xskb;
> > >                 else
> > > --
> > > 2.17.1
> > >
