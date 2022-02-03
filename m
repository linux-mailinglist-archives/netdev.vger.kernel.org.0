Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E43F4A8B07
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 18:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238524AbiBCR47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 12:56:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238071AbiBCR44 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 12:56:56 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57543C061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 09:56:55 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id c24so7767329edy.4
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 09:56:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lKKjFalvn1DW4DTk7hbvOquqWW+wJvzeXkVUR6QWTMI=;
        b=hoTZCIYLS1Pmk1MKCttyMeVJw1ylzff/yi4FrrYD3RBbBa3/ng7UPiTUoFGJ7NNsYV
         3kF4ePr7Y+7JbwDGxM7hqhFBttbj3/tVByJBR4wosm9q4nFVnkXWun8QtA7hMVitWb2g
         FZm8p++hKTRMwYUs9bCVagvzmSIk0QBHolPEbr+tfhfzTw+qJefwmmDftZRbkAq75T14
         ILyIzVal0JFHBw/SZmn41WWM0zgNDoQqA40+eIIOgJECVd6/SdjS+wImR8aazWe6Ce0n
         OvNmPj34zZvAvNh5Yo8cYAF6g6uNAjE/MCvQho3MyO+lPQIxPcu/A9LlinFp1hEa0NJ4
         0ubg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lKKjFalvn1DW4DTk7hbvOquqWW+wJvzeXkVUR6QWTMI=;
        b=1nQbEb3O3q0eOlyZCiD6DEMl0+goapyM2gNbecF6XksKU0XstsISX6I4KkcJsXaNxp
         5opUnEIE38TkTtEgY7rRdhJmWcQFWx7XtVlbdqMWskXll3nIgdH+OecatplWDC4+ppjN
         9Y8CxYbAiTUW1MwO+7VC+EAjgmqbDXPu3vq6nFok56nuw07/9OXXjJv0QSVbD5Gp83hd
         GQpZRSBxyAdGKuvD8+gi0Wu6dru5Y1qGmMB/EuHMN7Vpy6jSEQQDIEqOJBhPrnzYgOu4
         dpgDOhPqnoeP9g+JYd8/5FNwNQxeLcUR3MyimALm0H5C41tqzJffu5OMrIKduyyDyGsT
         NH8g==
X-Gm-Message-State: AOAM533Gqn5TFAmQj70XdjoCg6kJeZBapb+GakQqVVJTAwQPh5reQ6LQ
        9w8K01/sXMcL9i549aYsN2WIPZXz9ceq0wFSaaY=
X-Google-Smtp-Source: ABdhPJxZshxm01D6H6xy2diQPjWPCO6PXZ1FUcSp0HhAQdNF8iyF8SpBGxg7mk6iHqylg6Hga+4Z2SJlql+Uf8szZ+w=
X-Received: by 2002:a05:6402:3c6:: with SMTP id t6mr31996963edw.21.1643911013578;
 Thu, 03 Feb 2022 09:56:53 -0800 (PST)
MIME-Version: 1.0
References: <20220203015140.3022854-1-eric.dumazet@gmail.com>
 <20220203015140.3022854-10-eric.dumazet@gmail.com> <ee1fedeb33cd989379b72faac0fd6a366966f032.camel@gmail.com>
 <CANn89iKxGvbXQqoRZZ5j22-5YkpiCLS13EGoQ1OYe3EHjEss6A@mail.gmail.com>
In-Reply-To: <CANn89iKxGvbXQqoRZZ5j22-5YkpiCLS13EGoQ1OYe3EHjEss6A@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 3 Feb 2022 09:56:42 -0800
Message-ID: <CAKgT0UeTvj_6DWUskxxaRiQQxcwg6j0u+UHDaougJSMdkogKWA@mail.gmail.com>
Subject: Re: [PATCH net-next 09/15] net: increase MAX_SKB_FRAGS
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 3, 2022 at 9:34 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Thu, Feb 3, 2022 at 9:26 AM Alexander H Duyck
> <alexander.duyck@gmail.com> wrote:
> >
> > On Wed, 2022-02-02 at 17:51 -0800, Eric Dumazet wrote:
> > > From: Eric Dumazet <edumazet@google.com>
> > >
> > > Currently, MAX_SKB_FRAGS value is 17.
> > >
> > > For standard tcp sendmsg() traffic, no big deal because tcp_sendmsg()
> > > attempts order-3 allocations, stuffing 32768 bytes per frag.
> > >
> > > But with zero copy, we use order-0 pages.
> > >
> > > For BIG TCP to show its full potential, we increase MAX_SKB_FRAGS
> > > to be able to fit 45 segments per skb.
> > >
> > > This is also needed for BIG TCP rx zerocopy, as zerocopy currently
> > > does not support skbs with frag list.
> > >
> > > We have used this MAX_SKB_FRAGS value for years at Google before
> > > we deployed 4K MTU, with no adverse effect.
> > > Back then, goal was to be able to receive full size (64KB) GRO
> > > packets without the frag_list overhead.
> > >
> > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> >
> > So a big issue I see with this patch is the potential queueing issues
> > it may introduce on Tx queues. I suspect it will cause a number of
> > performance regressions and deadlocks as it will change the Tx queueing
> > behavior for many NICs.
> >
> > As I recall many of the Intel drivers are using MAX_SKB_FRAGS as one of
> > the ingredients for DESC_NEEDED in order to determine if the Tx queue
> > needs to stop. With this change the value for igb for instance is
> > jumping from 21 to 49, and the wake threshold is twice that, 98. As
> > such the minimum Tx descriptor threshold for the driver would need to
> > be updated beyond 80 otherwise it is likely to deadlock the first time
> > it has to pause.
>
> Are these limits hard coded in Intel drivers and firmware, or do you
> think this can be changed ?

This is all code in the drivers. Most drivers have them as the logic
is used to avoid having to return NETIDEV_TX_BUSY. Basically the
assumption is there is a 1:1 correlation between descriptors and
individual frags. So most drivers would need to increase the size of
their Tx descriptor rings if they were optimized for a lower value.

The other thing is that most of the tuning for things like interrupt
moderation assume a certain fill level on the queues and those would
likely need to be updated to account for this change.

> I could make  MAX_SKB_FRAGS a config option, and default to 17, until
> all drivers have been fixed.
>
> Alternative is that I remove this patch from the series and we apply
> it to Google production kernels,
> as we did before.

A config option would probably be preferred. The big issue as I see it
is that changing MAX_SKB_FRAGS is going to have ripples throughout the
ecosystem as the shared info size will be increasing and the queueing
behavior for most drivers will be modified as a result.
