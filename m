Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7321A1C5A1D
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 16:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729604AbgEEOxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 10:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729264AbgEEOxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 10:53:52 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA73C061A41
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 07:53:52 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id l5so1420882ybf.5
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 07:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YG6y8orYpJzDQB8e1eZa9Fuhz3Q8PhX0LEqRw9jpFUg=;
        b=tjSAZq8c7g1WZfAE9R+g+hnNv/rcciTbeuQNP3UR//p0LVE48OMSS48KOloIX8wuQl
         3GF5y9fIy2K7J/RyZsL7k6Y+njHlllGeEY24dnbzffYJUhuOwW0C6KMEDkGbJRWZixjj
         PEiNAIKAk0L08NRjz3eMU3QTOdsqG2RKyrdSO28IQsrNvqjTV9SNhWTsjlk/BErxBXkk
         MtkDYNfHSPUYKEIfuZxW2yaWCKM95pQeGE5qiPeVJdcUKzN407bqXp1YPgzvCAdGGvnC
         XfFs/WosYwgBSWiB7X0FFnZ0utQb6LeNXQlYZScQl5n8fkycSCnrL1Pc0YKRfXLr3hhO
         qKyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YG6y8orYpJzDQB8e1eZa9Fuhz3Q8PhX0LEqRw9jpFUg=;
        b=rVqPc5mJ0a7G197Q9Egz4z/eOASY+4/Ues1rSci250mc51GWnfOLQl5+q52eV/OZhU
         fDAqhCm1SYdM60xxD99vTtVkj9Mvo1qSyjrj3le5s/cSEjTAWMiTlo9YE+Msu87kKT3r
         60QgCHm3RdjD6uyjzArzaHyFZOQDOphXfIJf2CtAmGPZszbGOm/IZYqsuxGa69NhhqdK
         FuYtnCut2s/vq1EGRSu6DHI0bfbxzy+y/YCLAjmFRzKSEuhNKh+ZyNQYkfC581LJYdcG
         fIP0a+I1GQ4TG3nf4XpDrhbDXWn8lf8pwu0RvxNwo1RpYJfOnleK06qeS5tcwg+eFW70
         SOPQ==
X-Gm-Message-State: AGi0PuYcZnjTCBEoLqG/Y0yNnVozinBI50pbEPqK7ESD9BnNJEiqjIaN
        4beJnV+ZGBqGGyRHR6IG4FPJk6HQMfnrxupuijfh/A==
X-Google-Smtp-Source: APiQypJE3/NAOndb253iP3iislRRnAogVWKw3Bp6NrwNIK8nvTjsZebtJUhCZwR2Z3oy4k4A9w5KuzfI7Vp9mnFUBiM=
X-Received: by 2002:a25:1484:: with SMTP id 126mr5292169ybu.380.1588690430999;
 Tue, 05 May 2020 07:53:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200505081035.7436-1-sjpark@amazon.com> <20200505115402.25768-1-sjpark@amazon.com>
In-Reply-To: <20200505115402.25768-1-sjpark@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 5 May 2020 07:53:39 -0700
Message-ID: <CANn89iJ6f=x9XSfjSCFc0KNcjSXop3QMEgAfh9PLJ6khTbXrnQ@mail.gmail.com>
Subject: Re: [PATCH net v2 0/2] Revert the 'socket_alloc' life cycle change
To:     SeongJae Park <sjpark@amazon.com>
Cc:     David Miller <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        sj38.park@gmail.com, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        SeongJae Park <sjpark@amazon.de>, snu@amazon.com,
        amit@kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 5, 2020 at 4:54 AM SeongJae Park <sjpark@amazon.com> wrote:
>
> CC-ing stable@vger.kernel.org and adding some more explanations.
>
> On Tue, 5 May 2020 10:10:33 +0200 SeongJae Park <sjpark@amazon.com> wrote:
>
> > From: SeongJae Park <sjpark@amazon.de>
> >
> > The commit 6d7855c54e1e ("sockfs: switch to ->free_inode()") made the
> > deallocation of 'socket_alloc' to be done asynchronously using RCU, as
> > same to 'sock.wq'.  And the following commit 333f7909a857 ("coallocate
> > socket_sq with socket itself") made those to have same life cycle.
> >
> > The changes made the code much more simple, but also made 'socket_alloc'
> > live longer than before.  For the reason, user programs intensively
> > repeating allocations and deallocations of sockets could cause memory
> > pressure on recent kernels.
>
> I found this problem on a production virtual machine utilizing 4GB memory while
> running lebench[1].  The 'poll big' test of lebench opens 1000 sockets, polls
> and closes those.  This test is repeated 10,000 times.  Therefore it should
> consume only 1000 'socket_alloc' objects at once.  As size of socket_alloc is
> about 800 Bytes, it's only 800 KiB.  However, on the recent kernels, it could
> consume up to 10,000,000 objects (about 8 GiB).  On the test machine, I
> confirmed it consuming about 4GB of the system memory and results in OOM.
>
> [1] https://github.com/LinuxPerfStudy/LEBench

To be fair, I have not backported Al patches to Google production
kernels, nor I have tried this benchmark.

Why do we have 10,000,000 objects around ? Could this be because of
some RCU problem ?

Once Al patches reverted, do you have 10,000,000 sock_alloc around ?

Thanks.

>
> >
> > To avoid the problem, this commit reverts the changes.
>
> I also tried to make fixup rather than reverts, but I couldn't easily find
> simple fixup.  As the commits 6d7855c54e1e and 333f7909a857 were for code
> refactoring rather than performance optimization, I thought introducing complex
> fixup for this problem would make no sense.  Meanwhile, the memory pressure
> regression could affect real machines.  To this end, I decided to quickly
> revert the commits first and consider better refactoring later.
>
>
> Thanks,
> SeongJae Park
>
> >
> > SeongJae Park (2):
> >   Revert "coallocate socket_wq with socket itself"
> >   Revert "sockfs: switch to ->free_inode()"
> >
> >  drivers/net/tap.c      |  5 +++--
> >  drivers/net/tun.c      |  8 +++++---
> >  include/linux/if_tap.h |  1 +
> >  include/linux/net.h    |  4 ++--
> >  include/net/sock.h     |  4 ++--
> >  net/core/sock.c        |  2 +-
> >  net/socket.c           | 23 ++++++++++++++++-------
> >  7 files changed, 30 insertions(+), 17 deletions(-)
> >
> > --
> > 2.17.1
