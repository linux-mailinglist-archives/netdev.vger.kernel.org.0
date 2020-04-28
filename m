Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF5EC1BCD8B
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 22:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbgD1Uis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 16:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726291AbgD1Uir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 16:38:47 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AFFEC03C1AB;
        Tue, 28 Apr 2020 13:38:47 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id n24so8950619plp.13;
        Tue, 28 Apr 2020 13:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+0nSyArU9UaiIxUvX09JAVc0Ve+OPi3IfSrMnDgA5DM=;
        b=YWlug5DtKJ8qaZSp6aTks0Q6KBYDQoxzgZcshQXIZ/ShONgJmAcWNCeHnnQ9V/g0LB
         PUSvCfEe1wyAfcmVW6AqSldelAnTbuckqV4rR16qUZVBwhARIArNzCAsh9abtJg3VfIW
         xskabgrSiVsjzEt4GqWpNpr2w/MFTxA5LDBOzrA+W4ExToOJvzwYvG/RPqjJNRhDDqms
         ibav8hX9Oa6mmh8OPISr43qtqpTyYboVKONbTK+IjQd7zQpCxAPSR4y1Z7s+or+eLT+m
         72Cg/p26F+O7YnfIoh7qV2vZD/tsxp0C2igRU+EcmiqMKNkcVZlxAopI2ENf4Zl5Ek3g
         xv0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+0nSyArU9UaiIxUvX09JAVc0Ve+OPi3IfSrMnDgA5DM=;
        b=ACMvobuWQZDAp82sDgMWQ4pC1fR5cmy02nWmuYY3+DvHODMH01VMYwsYYSLUa46QBP
         1i6SVDJBk1Jx1oDhpTW6EH14qGnGOrgdO3dgG6WnPVJ3wqgUvfZQ2X6H5OxiuvVhvf78
         tPbqvPVtPTpYs+em8mYWTZIDnUTMCftWH8iX5JrngoNphGv5kn7IdxwkA8/xWjOFPnzw
         h7izsivkcT+FnHbCxa7bFzqaz+qcc7QU+jnM16VIrgXp0WzgVqLId18hGcR6KIbmKQZD
         jQQLxc6dYwfmACuhmDB5MW/1D3ZxaCD70Fh91MEqX9PEStmHhyA87lJZJFpein3tPUt3
         sYwQ==
X-Gm-Message-State: AGi0Puaizrg5iFdXFo4f9zyF2ftWPEX1lZ1WtCDTIWXZUcLpeTbgypCY
        fQWoyhyiFOPwuOstAE9U5ln40RqI
X-Google-Smtp-Source: APiQypLa7sIrLlkQTekoj8xATnY8tbdYHwfxbOXxgcnl73CU1BzWr9yqpQOxB1W55Mi75+6Mng5jKA==
X-Received: by 2002:a17:90a:37a3:: with SMTP id v32mr7673447pjb.2.1588106326817;
        Tue, 28 Apr 2020 13:38:46 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:9061])
        by smtp.gmail.com with ESMTPSA id 6sm14534227pgz.0.2020.04.28.13.38.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 13:38:45 -0700 (PDT)
Date:   Tue, 28 Apr 2020 13:38:43 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 02/10] bpf: allocate ID for bpf_link
Message-ID: <20200428203843.pe7d4zbki2ihnq2m@ast-mbp.dhcp.thefacebook.com>
References: <20200428054944.4015462-1-andriin@fb.com>
 <20200428054944.4015462-3-andriin@fb.com>
 <20200428173120.lof25gzz75bx5ot7@ast-mbp.dhcp.thefacebook.com>
 <CAEf4Bza-gqQHz3_9RyX7pKo_2kYeh7cCmNRAxExx48JQdOpfDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bza-gqQHz3_9RyX7pKo_2kYeh7cCmNRAxExx48JQdOpfDQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 11:56:52AM -0700, Andrii Nakryiko wrote:
> On Tue, Apr 28, 2020 at 10:31 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Mon, Apr 27, 2020 at 10:49:36PM -0700, Andrii Nakryiko wrote:
> > > +int bpf_link_settle(struct bpf_link_primer *primer)
> > > +{
> > > +     /* make bpf_link fetchable by ID */
> > > +     WRITE_ONCE(primer->link->id, primer->id);
> >
> > what does WRITE_ONCE serve here?
> 
> To prevent compiler reordering this write with fd_install. So that by
> the time FD is exposed to user-space, link has properly set ID.

if you wanted memory barrier then it should have been barrier(),
but that wouldn't be enough, since patch 2 and 3 race to read and write
that 32-bit int.

> > bpf_link_settle can only be called at the end of attach.
> > If attach is slow than parallel get_fd_by_id can get an new FD
> > instance for link with zero id.
> > In such case deref of link->id will race with above assignment?
> 
> Yes, it does race, but it can either see zero and assume bpf_link is
> not ready (which is fine to do) or will see correct link ID and will
> proceed to create new FD for it. By the time we do context switch back
> to user-space and return link FD, ID will definitely be visible due to
> context switch and associated memory barriers. If anyone is guessing
> FD and trying to create FD_BY_ID before LINK_CREATE syscall returns --
> then returning failure due to link ID not yet set is totally fine,
> IMO.
> 
> > But I don't see READ_ONCE in patch 3.
> > It's under link_idr_lock there.
> 
> It doesn't need READ_ONCE because it does read under spinlock, so
> compiler can't re-order it with code outside of spinlock.

spin_lock in patch 3 doesn't guarantee that link->id deref in that patch
will be atomic.
So WRITE_ONCE in patch 2 into link->id is still racy with plain
read in patch 3.
Just wait and see kmsan complaining about it.

> > How about grabbing link_idr_lock here as well ?
> > otherwise it's still racy since WRITE_ONCE is not paired.
> 
> As indicated above, seems unnecessary? But I also don't object
> strongly, I don't expect this lock for links to be a major bottleneck
> or anything like that.

Either READ_ONCE has to be paired with WRITE_ONCE
(or even better smp_load_acquire with smp_store_release)
or use spin_lock.

> >
> > The mix of spin_lock_irqsave(&link_idr_lock)
> > and spin_lock_bh(&link_idr_lock) looks weird.
> > We do the same for map_idr because maps have complicated freeing logic,
> > but prog_idr is consistent.
> > If you see the need for irqsave variant then please use it in all cases.
> 
> No, my bad, I don't see any need to intermix them. I'll stick to
> spin_lock_bh, thanks for catching!

I think that should be fine.
Please double check that situation described in
commit 930651a75bf1 ("bpf: do not disable/enable BH in bpf_map_free_id()")
doesn't apply to link_idr.
