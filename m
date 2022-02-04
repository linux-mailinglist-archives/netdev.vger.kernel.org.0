Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 460904A9C31
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 16:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241200AbiBDPq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 10:46:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbiBDPq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 10:46:57 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 376D3C061714
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 07:46:57 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id ah7so20547443ejc.4
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 07:46:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OBzhmbzrOAY/aLu1KT+JvuqQwH2N0TlEC2WQ/HrrWLQ=;
        b=aDuhJglcvNYbeZ2+HLhTL+BuOoVUSdS7ebzWm5IAY9nFdHEdgiyv9kg1jKiSuZIhPU
         QwgkGcyEaF3OVKFkI18rtu7Jrir3gvolJFC3YwlJdXS4txAklnsrSimN5zBP/VSAW043
         2iTELPBOTu1wohKyLNB88Pmaq8DuMSDe62l7hQ/okdzJGcW9mEzfqe1sj2ChXoN/rawe
         00ZwwyWw3gydUpHZutKiktZ4mhQDOJ9A2pjvGxnk8cmG9svTCF+ZTDARuZtTBq667FxU
         SmvDKPM2zzZJQHFiNQYpjiu2snaiPA47pFYkbX03BePvyx58Wsi7W5AKJ/PWCUqf5xxB
         1EPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OBzhmbzrOAY/aLu1KT+JvuqQwH2N0TlEC2WQ/HrrWLQ=;
        b=hJ+GSolMj7kT/GSex508EbAFEcyGTMBFD92ehnsbEVI3/3A0ULyp9tndlHppn4/jnE
         7xPB0427bbOon+2gGn8ZWraZK2g9LEFLbQPuTZzycObHjq5qkTfYTw3Hn9he8wXrp3pM
         C7ZgGAJYtlRi384TpYvcUX8SBx1IRq/itZvx/gW7vwYGHl27Ou+n6uNQ6F6Xg2im+TZE
         0Psi9Vt+TPu7MBqI3kapH4IodzHUi7fWEWdY56KMqzeijouBe/RyyNFzmzHWLSnq2Sc4
         sDcfBIDC5/+wC+K03zAHVydrL20BqUiKH8sUYE9Fl+JMZXz1tn5Avz4+/QcHJZAr5qq1
         3dsA==
X-Gm-Message-State: AOAM5303w76OVDZFD/b64hM4vVMHzLK5Pe2paW8f1YKux7cWLAI8jV/x
        y2C+kRIzAH+W088ab/M3DCkROlHdfnIb8lZBJEQAVjWeqZE=
X-Google-Smtp-Source: ABdhPJzVjuEFYDVQr8g3EX4bZ1Nfi6R1iinbVsrI8zB+fCYLYcYzBebGWj+3BEDxxyCaIaihNBssRb1+n0QFCi1BwMY=
X-Received: by 2002:a17:906:c154:: with SMTP id dp20mr2894678ejc.184.1643989615523;
 Fri, 04 Feb 2022 07:46:55 -0800 (PST)
MIME-Version: 1.0
References: <20220203015140.3022854-1-eric.dumazet@gmail.com>
 <20220203015140.3022854-10-eric.dumazet@gmail.com> <ee1fedeb33cd989379b72faac0fd6a366966f032.camel@gmail.com>
 <CANn89iKxGvbXQqoRZZ5j22-5YkpiCLS13EGoQ1OYe3EHjEss6A@mail.gmail.com>
 <CAKgT0UeTvj_6DWUskxxaRiQQxcwg6j0u+UHDaougJSMdkogKWA@mail.gmail.com> <11f331492498494584f171c4ab8dc733@AcuMS.aculab.com>
In-Reply-To: <11f331492498494584f171c4ab8dc733@AcuMS.aculab.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 4 Feb 2022 07:46:43 -0800
Message-ID: <CAKgT0UdyApTnBOr9rdsdoh4==orpxNEuhkLngX2MuEhOzqdh0w@mail.gmail.com>
Subject: Re: [PATCH net-next 09/15] net: increase MAX_SKB_FRAGS
To:     David Laight <David.Laight@aculab.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 4, 2022 at 2:18 AM David Laight <David.Laight@aculab.com> wrote:
>
> From: Alexander Duyck
> > Sent: 03 February 2022 17:57
> ...
> > > > So a big issue I see with this patch is the potential queueing issues
> > > > it may introduce on Tx queues. I suspect it will cause a number of
> > > > performance regressions and deadlocks as it will change the Tx queueing
> > > > behavior for many NICs.
> > > >
> > > > As I recall many of the Intel drivers are using MAX_SKB_FRAGS as one of
> > > > the ingredients for DESC_NEEDED in order to determine if the Tx queue
> > > > needs to stop. With this change the value for igb for instance is
> > > > jumping from 21 to 49, and the wake threshold is twice that, 98. As
> > > > such the minimum Tx descriptor threshold for the driver would need to
> > > > be updated beyond 80 otherwise it is likely to deadlock the first time
> > > > it has to pause.
> > >
> > > Are these limits hard coded in Intel drivers and firmware, or do you
> > > think this can be changed ?
> >
> > This is all code in the drivers. Most drivers have them as the logic
> > is used to avoid having to return NETIDEV_TX_BUSY. Basically the
> > assumption is there is a 1:1 correlation between descriptors and
> > individual frags. So most drivers would need to increase the size of
> > their Tx descriptor rings if they were optimized for a lower value.
>
> Maybe the drivers can be a little less conservative about the number
> of fragments they expect in the next message?
> There is little point requiring 49 free descriptors when the workload
> never has more than 2 or 3 fragments.
>
> Clearly you don't want to re-enable things unless there are enough
> descriptors for an skb that has generated NETDEV_TX_BUSY, but the
> current logic of 'trying to never actually return NETDEV_TX_BUSY'
> is probably over cautious.

The problem is that NETDEV_TX_BUSY can cause all sorts of issues in
terms of the flow of packets. Basically when you start having to push
packets back from the device to the qdisc you can essentially create
head-of-line blocking type scenarios which can make things like
traffic shaping that much more difficult.

> Does Linux allow skb to have a lot of short fragments?
> If dma_map isn't cheap (probably anything with an iommu or non-coherent
> memory) them copying/merging short fragments into a pre-mapped
> buffer can easily be faster.

I know Linux skbs can have a lot of short fragments. The i40e has a
workaround for cases where more than 8 fragments are needed to
transmit a single frame for instance, see __i40e_chk_linearize().

> Many years ago we found it was worth copying anything under 1k on
> a sparc mbus+sbus system.
> I don't think Linux can generate what I've seen elsewhere - the mac
> driver being asked to transmit something with 1000+ one byte fragmemts!
>
>         David

Linux cannot generate the 1000+ fragments, mainly because it is
limited by the frags. However as I pointed out above it isn't uncommon
to see an skb composed of a number of smaller fragments.

That said, I don't know if we really need to be rewriting the code for
NETDEV_TX_BUSY handling on the drivers. It would just be a matter of
reserving more memory in the descriptor rings since the counts would
be going from 42 to 98 in order to unblock a Tx queue in the case of
igb for instance, and currently the minimum ring size is 80. So in
this case it would just be a matter of increasing the minimum so that
it cannot be configured into a deadlock.

Ultimately that is the trade-off with this approach. What we are doing
is increasing the memory footprint of the drivers and skbs in order to
allow for more buffering in the skb to increase throughput. I wonder
if it wouldn't make sense to just make MAX_SKB_FRAGS a driver level
setting like gso_max_size so that low end NICs out there aren't having
to reserve a ton of memory to store fragments they will never use.

- Alex
