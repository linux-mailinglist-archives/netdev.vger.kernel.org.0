Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89A202523EF
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 01:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgHYXA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 19:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbgHYXA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 19:00:29 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B300BC061574
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 16:00:28 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id m200so153663ybf.10
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 16:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3mA873LhI1Y1Qe0CQ/4bq5opkboo49VuC1XekRaaT0I=;
        b=IaQjuvx2mKZumoUJDDw0O+hDTp+I0mOAeAPXWwhoLL6QyD5/oCEm/OQtsZCbmrlqzf
         RQ29hN4+ki8UnFm/+V26Vi5V2DxWv2JOKrWuaO4uNeLJfnrQ3HdJXvVrVGqoq9rFTHHM
         x+995rWQlo1tXGVWsLKz3McfvwO2U1WQ9PPT2JZiinnHmSnyMfWf1Qs8VAwbesrnbsGn
         ALhCOsxZUzQ5SJZfqunM7Yn1btO5OY6fQrVYxKIK27oE+X+DMkhLHUrgFvqSEFR+BZ2Z
         PIGHE4EfiwxJH7BpgnN/zwEruRZaL1o7S9KAihLNO5dw7reR9W39vCR5FVLc4xgQgARA
         3feQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3mA873LhI1Y1Qe0CQ/4bq5opkboo49VuC1XekRaaT0I=;
        b=binm0766cBvFgwiEYZK0l2E58eYLURTqUtKc5HDLTBnw38T65r2OXZtncvCW9I7ZHA
         B9P8r8NGB/Xa4LpT0peELEHWwMgw8RKXf7S+ClUXuk0fgrpRyWYEwrboWCEybM2LwyqH
         5kkC9jqdK99tu+1ixIjwm4iVppRK9TKcYuwU09KuFC20iQvnKDdwLdrNmbPj2MNOuDuO
         p6FnWtISBN9laG37dYLgfksJAu7U0GP6RQTjp0n+yErPZeG5USZyEVwZVuIgqyPyyRqr
         xnaKsGfzEoLh7RIrFTZwUuqu1A5owUGQ7R7lMMehe5ECaWzvUJEnEU+qBc12U6LPXwkT
         xq6Q==
X-Gm-Message-State: AOAM530welgEyebQTU/jBnfR+J591ZZBWSTKSlHriSGlFMkdkDBqy87m
        I8P0LJwho9AySKPNUbOdGbr9KdAgj2rit8ZETdJGYQ==
X-Google-Smtp-Source: ABdhPJzm0lL9gaapPF9+4b0B213qAjSwkdtTqRZE3hwgDQ3YLZoG1AXHOkXVULuMIR3M9z5o8xX953dR1odffG/c44Q=
X-Received: by 2002:a25:d285:: with SMTP id j127mr17027289ybg.505.1598396427536;
 Tue, 25 Aug 2020 16:00:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200825224208.1268641-1-maheshb@google.com> <9fce7d7e-aa33-a451-ab4a-a297b1317310@infradead.org>
In-Reply-To: <9fce7d7e-aa33-a451-ab4a-a297b1317310@infradead.org>
From:   =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Date:   Tue, 25 Aug 2020 16:00:10 -0700
Message-ID: <CAF2d9jiwH=GO3zd1sK-mURRV_W-_bfihbmc+ud=ZdV_SvYAuvg@mail.gmail.com>
Subject: Re: [PATCHv2 next] net: add option to not create fall-back tunnels in
 root-ns as well
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <mahesh@bandewar.net>,
        Maciej Zenczykowski <maze@google.com>,
        Jian Yang <jianyang@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 25, 2020 at 3:47 PM Randy Dunlap <rdunlap@infradead.org> wrote:
>
> On 8/25/20 3:42 PM, Mahesh Bandewar wrote:
> > The sysctl that was added  earlier by commit 79134e6ce2c ("net: do
> > not create fallback tunnels for non-default namespaces") to create
> > fall-back only in root-ns. This patch enhances that behavior to provide
> > option not to create fallback tunnels in root-ns as well. Since modules
> > that create fallback tunnels could be built-in and setting the sysctl
> > value after booting is pointless, so added a kernel cmdline options to
> > change this default. The default setting is preseved for backward
> > compatibility. The kernel command line option of fb_tunnels=initns will
> > set the sysctl value to 1 and will create fallback tunnels only in initns
> > while kernel cmdline fb_tunnels=none will set the sysctl value to 2 and
> > fallback tunnels are skipped in every netns.
> >
> > Signed-off-by: Mahesh Bandewar <maheshb@google.com>
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: Maciej Zenczykowski <maze@google.com>
> > Cc: Jian Yang <jianyang@google.com>
> > ---
> > v1->v2
> >   Removed the Kconfig option which would force rebuild and replaced with
> >   kcmd-line option
> >
> >  .../admin-guide/kernel-parameters.txt         |  5 +++++
> >  Documentation/admin-guide/sysctl/net.rst      | 20 +++++++++++++------
> >  include/linux/netdevice.h                     |  7 ++++++-
> >  net/core/sysctl_net_core.c                    | 17 ++++++++++++++--
> >  4 files changed, 40 insertions(+), 9 deletions(-)
> >
> > diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> > index a1068742a6df..09a51598c792 100644
> > --- a/Documentation/admin-guide/kernel-parameters.txt
> > +++ b/Documentation/admin-guide/kernel-parameters.txt
> > @@ -801,6 +801,11 @@
> >
> >       debug_objects   [KNL] Enable object debugging
> >
> > +     fb_tunnels=     [NET]
> > +                     Format: { initns | none }
> > +                     See Documentation/admin-guide/sysctl/net.rst for
> > +                     fb_tunnels_only_for_init_ns
> > +
>
> Not at this location in this file.
> Entries in this file are meant to be in alphabetical order (mostly).
>
> So leave debug_objects and no_debug_objects together, and insert fb_tunnels
> between fail_make_request= and floppy=.
>
I see. I'll fix it in the next revision.
thanks for the suggestion.
--mahesh..

> Thanks.
>
> >       no_debug_objects
> >                       [KNL] Disable object debugging
> >
>
> --
> ~Randy
>
