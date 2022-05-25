Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4D5534220
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 19:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245313AbiEYRU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 13:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233601AbiEYRU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 13:20:27 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B0CAE271;
        Wed, 25 May 2022 10:20:26 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id l82so13244865qke.3;
        Wed, 25 May 2022 10:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YfBPEciL5G7knzd6QMjS+T5tcQUuK2HPFFm47OcA2Rk=;
        b=SDNuq+CpL9mwhliv/HCa2205mkKlLFnNO+bi5V221Xkf2P4zQ0OCDi03/bpZSTZN6I
         qGU0oMfOP1x4OArMNUxmnEHIjr/i6AhyKwMM5KO35xkmUYKSqae+LxXSRDVsRJg3POOD
         1heLb6R1u1wRDho4dxMc80pexy03gXaONqVTHtkp/iRf4HLOD+t/ODIgXRr23jky8ojq
         oYtxDdiRvm7Grs+v0P++Kj1sM9Vc+mWhn2QNTVeGF6XvURNO+/xDOJW3/Q/NPHnTzFMp
         KrOahJEPjGyPa2gShpPmIeTBW7Ms/s+c1rRc80U0uKAsBb4xVhGipRb10pBipHBfEfxi
         4l5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YfBPEciL5G7knzd6QMjS+T5tcQUuK2HPFFm47OcA2Rk=;
        b=PxN3eicUM/W11FLC2ImYYbtnSdZ8j5V7WcOrspUKe4CLFafKebhYqEYAqa5a3FJpzL
         n6mpw+85GFHQEaScNjxhxk0B/VxiQBlQCHQkYM6QE443LRcNLnl9P4nOpCP9aqDOlGOr
         t3E7K7DIWNkli6EbT2HY7gIRsYscGAeEJbh9+E5P0ldb7v09HIgMSpGuskEv2Z48adgM
         izO/mFvzoHy95Gt8YNtLsCTVEiUAcqnL2WAuxW5hwNJfu68JZyMZTI3NSWBddMtglpJG
         a1/S0MrEj7XBgE13hitunZ4D6QNpZHtk5prZAedIbytvYM9K0Gi7Fi+/Axd/Tci31lgW
         6VKw==
X-Gm-Message-State: AOAM530r+G+gLZq2tiNu3scoMTVtG41BFWUVfOfkadysmm2KU1dUcRTE
        Al8x2TsI82VL61MWUn5xQA==
X-Google-Smtp-Source: ABdhPJxJtiJd73drvBnS+M39DznexShMWDDD0/WY8tbqvBv1sZqUR2r2Ytvsnek6D/zQiR9lKS31NQ==
X-Received: by 2002:a05:620a:44c4:b0:6a5:a827:d86c with SMTP id y4-20020a05620a44c400b006a5a827d86cmr437283qkp.624.1653499225424;
        Wed, 25 May 2022 10:20:25 -0700 (PDT)
Received: from moria.home.lan (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
        by smtp.gmail.com with ESMTPSA id r126-20020ae9dd84000000b0069ffe63228fsm1508826qkf.121.2022.05.25.10.20.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 10:20:24 -0700 (PDT)
Date:   Wed, 25 May 2022 13:20:22 -0400
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, netdev@vger.kernel.org,
        mcgrof@kernel.org
Subject: Re: RFC: Ioctl v2
Message-ID: <20220525172022.ml7lhby2igxtlm7a@moria.home.lan>
References: <20220520161652.rmhqlvwvfrvskg4w@moria.home.lan>
 <YogoI6Augr1V6AHn@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YogoI6Augr1V6AHn@mit.edu>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 20, 2022 at 07:45:39PM -0400, Theodore Ts'o wrote:
> On Fri, May 20, 2022 at 12:16:52PM -0400, Kent Overstreet wrote:
> > 
> > Where the lack of real namespacing bites us more is when ioctls get promoted
> > from filesystem or driver on up. Ted had a good example of an ext2 ioctl getting
> > promoted to the VFS when it really shouldn't have, because it was exposing ext2
> > specific data structures.
> > 
> > But because this is as simple as changing a #define EXT2_IOC to #define FS_IOC,
> > it's really easy to do without adequate review - you don't have to change the
> > ioctl number and break userspace, so why would you?
> > 
> > Introducing real namespacing would mean that promoting an ioctl to the VFS level
> > would really have to be a new ioctl, and it'll get people to think more about
> > what the new ioctl would be.
> 
> It's not clear that making harder not to break userspace is a
> *feature*.  If existing programs are using a particular ioctl
> namespace, being able to have other file systems adopt it has
> historically been considered a *feature* not a *bug*.
> 
> At the time, we had working utilities, chattr and lsattr, which were
> deployed on all Linux distributions, and newer file systems, such as
> xfs, reiserfs, btrfs, etc., decided they wanted to piggy-back on those
> existing utilities.  Forcing folks to deploy new utilities just
> because it's the best way to force "adequate review" might be swinging
> the pendulum too far in the straight-jacket direction.

But back in those days, users updating those core utilities was a much bigger
hassle. That's changing, we don't really have users compiling from source
anymore, and we're slowly but steadily moving towards the rolling releases
world: slackware -> debian -> nixos.

And on the developer side of things, historically developers have worked on a
few packages where they were comfortable with the process, and packages tended
more towards giant monorepos, but the younger generation is more used to working
across multiple packages/repositories as necessary (this is where github has
been emphatically a good thing, despite being proprietary; it's standardized a
lot of the friction-y "how do I submit to this repo" stuff).

So I understand where you're coming from but I think this is worth rethinking.

Additionally, bikeshedding gets really painful when people are trying to plan
for all eventualities and think too far ahead. Having multiple stages of review
is _helpful_ with this. If an ioctl is filesystem-private, it's perfectly fine
for it embed filesystem specific data structures - if we can ensure that that
won't get lifted to the VFS layer without anyone noticing!

> ...
>
> In the case of extended attributes, we had perfectly working userspace
> tools that would have ***broken*** if we adhered to a doctrinaire,
> when you promote an interface, we break the userspace interface Just
> Because it's the Good Computer Science Thing To Do.

Not broken, though - it just would've needed updating to support additional
filesystems, and when the ioctls don't need changing the patches would be
trivial:

ret = ioctl_xfs_goingdown(..);
becomes
ret = ioctl_fs_goingdown(...) ?:
      ioctl_xfs_goingdown(...);

(I'm the only one I know who does that chaining syntax in C, but I like it :)

> So this approach requires that someone has to actually implement the
> wrapper library.  Who will that be?  The answer could be, "let libc do
> it", but then we need to worry about all the C libraries out there
> actually adopting the new ioctl, which takes a long time, and
> historically, some C library maintainers have had.... opinionated
> points of view about the sort of "value add that should be done at the
> C Library level".

Not libc, and we definitely don't want to have to update that library for every
new ioctl - I'm imagining that library just being responsible for the "query
kernel for ioctl numbers" part, the ioctl definitions themselves will still come
from kernel headers.

> For example, I have an ext2fs library function
> ext2fs_get_device_size2(), which wraps not only the BLKGETSIZE and
> BLKGETSIZE64 ioctls, but also the equivalents for Apple Darwin
> (DKIOCGETBLOCKCOUNT), FreeBSD/NetBSD (DIOCGDINFO and later
> DIOCGMEDIASIZE), and the Window's DeviceIoControl()'s
> IOCTL_DISK_GET_DRIVE_GEOMETRY call.  The point is that wrapper
> functions are very much orthogonal to the ioctl interface; we're all
> going to have wrapper functions, and we'll create them where they are
> needed.

This seems unrelated to the ioctl v2 discussion, but - it would be _great_ if we
could get that in a separate repository where others could make use of it :)
