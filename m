Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 434DB1C5CCD
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 18:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729777AbgEEQA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 12:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729695AbgEEQA5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 12:00:57 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A771C061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 09:00:57 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id d197so1535399ybh.6
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 09:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ORJwrAAwnpoHqLqwdK95lxsUlCDtaaRCVzNicAVFK9Q=;
        b=nhNrbnjfR6QYiydMzB+2Zg1gss9xSUkVPcDk/hIKxB3JreekfD7jPisLqPr+ZtnhtY
         vFBPr83g2DbXb387d3P4r0hJMkdiSUfwXrQHjAm9su6PU0iELhjn5hfh0cTDdSgbAzW+
         UH0SRMil6UjWMRGp+yBxX7aFGMOa3j8dNLGXoYo8YHR/jlZQGyY8Jn4m32kpkh1vZDUP
         RLtmV63YHi+ooBlWy7erEOR0taKW4UTSKF3AAN+Ij6RVd10rzTtDzrsqOyWNDHod91aq
         +pBHCr7jx1Fsu7ZzCrPY7FJRIfh4H9zrQS+t56Ohxb92FBiRDH9NJ2dXq++AC5MwDTH/
         FLcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ORJwrAAwnpoHqLqwdK95lxsUlCDtaaRCVzNicAVFK9Q=;
        b=tchTpEUxUUZqSvPjZSE1dr42Jsb17N8ug13DRjw4g61kPsrSsVgl2hLG4evYTQr9A4
         IiBUp9Qdq+m0dYIXi/Pgu6t/XGGoN5OJgQo6mi6oOsDMxEz4RK0Uc8MfayN6uLdUrale
         fgD5sPjogNTp36pTofh8zlc3Re36jYB8p5AY79G8KlDKRfcQmYgTIcv0MDbkOfk3gabZ
         yufbrU3UYGlB2PJzN7/vB2WfOoCn9U5SZ271vsVpKYneJdFLEwqu9c7lLf5XRidG16QB
         H6qmXYqFUqqn1RidnUoAuOd7HBSmC2pKzIfSBgY6Sj5gwld/qJT5TD3FnFLSItC/wRNz
         6wWA==
X-Gm-Message-State: AGi0PuZRuKUQuEywacY6ghB7xudNl29o0xU/U0CG2K388Yb9dtilNCln
        09AuF6A3Qr9Mc1ZgHIQgrZ5hC7c489ChcCvjdzR/ag==
X-Google-Smtp-Source: APiQypIMaAW9Xq0PmO+ItBBc/hPsz72qqCag9yC+T74EMR2STsOZlVRrHFkAljXR65MPzOEFNwalv+CLofTDx8F+C4c=
X-Received: by 2002:a25:6f86:: with SMTP id k128mr5689837ybc.520.1588694455583;
 Tue, 05 May 2020 09:00:55 -0700 (PDT)
MIME-Version: 1.0
References: <a8510327-d4f0-1207-1342-d688e9d5b8c3@gmail.com> <20200505154644.18997-1-sjpark@amazon.com>
In-Reply-To: <20200505154644.18997-1-sjpark@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 5 May 2020 09:00:44 -0700
Message-ID: <CANn89iLHV2wyhk6-d6j_4=Ns01AEE5HSA4Qu3LO0gqKgcG81vQ@mail.gmail.com>
Subject: Re: Re: [PATCH net v2 0/2] Revert the 'socket_alloc' life cycle change
To:     SeongJae Park <sjpark@amazon.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>,
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

On Tue, May 5, 2020 at 8:47 AM SeongJae Park <sjpark@amazon.com> wrote:
>
> On Tue, 5 May 2020 08:20:50 -0700 Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> >
> >
> > On 5/5/20 8:07 AM, SeongJae Park wrote:
> > > On Tue, 5 May 2020 07:53:39 -0700 Eric Dumazet <edumazet@google.com> wrote:
> > >
> >
> > >> Why do we have 10,000,000 objects around ? Could this be because of
> > >> some RCU problem ?
> > >
> > > Mainly because of a long RCU grace period, as you guess.  I have no idea how
> > > the grace period became so long in this case.
> > >
> > > As my test machine was a virtual machine instance, I guess RCU readers
> > > preemption[1] like problem might affected this.
> > >
> > > [1] https://www.usenix.org/system/files/conference/atc17/atc17-prasad.pdf
> > >
> > >>
> > >> Once Al patches reverted, do you have 10,000,000 sock_alloc around ?
> > >
> > > Yes, both the old kernel that prior to Al's patches and the recent kernel
> > > reverting the Al's patches didn't reproduce the problem.
> > >
> >
> > I repeat my question : Do you have 10,000,000 (smaller) objects kept in slab caches ?
> >
> > TCP sockets use the (very complex, error prone) SLAB_TYPESAFE_BY_RCU, but not the struct socket_wq
> > object that was allocated in sock_alloc_inode() before Al patches.
> >
> > These objects should be visible in kmalloc-64 kmem cache.
>
> Not exactly the 10,000,000, as it is only the possible highest number, but I
> was able to observe clear exponential increase of the number of the objects
> using slabtop.  Before the start of the problematic workload, the number of
> objects of 'kmalloc-64' was 5760, but I was able to observe the number increase
> to 1,136,576.
>
>           OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
> before:   5760   5088  88%    0.06K     90       64       360K kmalloc-64
> after:  1136576 1136576 100%    0.06K  17759       64     71036K kmalloc-64
>

Great, thanks.

How recent is the kernel you are running for your experiment ?

Let's make sure the bug is not in RCU.

After Al changes, RCU got slightly better under stress.
