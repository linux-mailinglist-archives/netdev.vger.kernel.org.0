Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03DDC309A10
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 04:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbhAaDQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 22:16:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbhAaDQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 22:16:52 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E180AC061573;
        Sat, 30 Jan 2021 19:16:11 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id i7so9599126pgc.8;
        Sat, 30 Jan 2021 19:16:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ohey/n9HC50LcT9SfB1APHEExDxmpN/T94GswSnA44U=;
        b=NQTJszeGFJ+SLfhMg24MZxPuqDcRn8iY0x6u0pvyOTcY7L3qThofp937GjRnHBtwyd
         GT9s01S9jxE4Wf2eQYuO6Kc29cIwkcnuDIcBQZE00zAquyuylJBYNWBIjYd8nOUmCc9n
         JvjTqHtDKkeDNQZIQveJycwgupWWZ3vId/nSy/Z+uXlsv7Gn40wdLIdlkpQy9W6TuQfW
         V2ckBfRWm9AdsPj+rQ8HU8qIfrgS80SeHd113c8Mgsci8mZOuCiaVOaJx1oLOoU8RwWS
         N5lLQHZvGkURl0la4UnDmwI+PVUa/NGM6JcOzWq4PMGzulwYOCjAQyOz1tyUteIN18id
         HCog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ohey/n9HC50LcT9SfB1APHEExDxmpN/T94GswSnA44U=;
        b=d/8ccOlI9VhK+sEAC2Lza6to5ZMeResGhuv4ATT8niAsSWXAIDDv/fcLh0Dj3NW+eV
         BPdbianXzsvvy4k+gYUX1rhCnJtFeT8lUFhTMGhVElVY083h72vhUZsDs4VbaNNUOQOc
         mNKXiUi0mqLm/3bvWX9+31IcRaGMk//Ix3k4yOOWEQiSI0ZVCCYOp/2sPo+dMpwNdfTs
         Swn4/CrPSF/Gbgq+AdnYv+PI8ROqevxxs3c3WaRo931t8GP61eLKmf5l6pBGjT3vJuI0
         L/V91BPBtVZZt+RLUzPK4EwLszWJpXVlWRiYf6QlzjyJhDWcaPxobftXnxItgDqZxxsn
         qPLQ==
X-Gm-Message-State: AOAM531krJwbzMyW5wDoIyxzLoh+SK/jnA2DLAhof84G13nbJdFln3wn
        30f62ta0CV6EnJQ+MrCsuiZ3PUurHM+lgDdtKL73mF1vxFU=
X-Google-Smtp-Source: ABdhPJwgerOH4DnC1TMIe7Yiht7v/g2PsLME1FUL0MQV21tZK2DJ5FIC8WweeEARatrH/Zw2RHWpb8OWTV8WuwZ55zg=
X-Received: by 2002:a62:503:0:b029:1c0:aed7:c88 with SMTP id
 3-20020a6205030000b02901c0aed70c88mr4913844pff.76.1612062971326; Sat, 30 Jan
 2021 19:16:11 -0800 (PST)
MIME-Version: 1.0
References: <20210127090747.364951-1-xie.he.0141@gmail.com>
 <20210128114659.2d81a85f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAJht_EOSB-m--Ombr6wLMFq4mPy8UTpsBri2CPsaRTU-aks7Uw@mail.gmail.com>
 <3f67b285671aaa4b7903733455a730e1@dev.tdt.de> <20210129173650.7c0b7cda@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAJht_EPMtn5E-Y312vPQfH2AwDAi+j1OP4zzpg+AUKf46XE1Yw@mail.gmail.com> <20210130111618.335b6945@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210130111618.335b6945@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Sat, 30 Jan 2021 19:16:00 -0800
Message-ID: <CAJht_EMQVaKFx7Wjj75F2xVBTCdpmho64wP0bfX6RhFnzNXAZA@mail.gmail.com>
Subject: Re: [PATCH net] net: hdlc_x25: Use qdisc to queue outgoing LAPB frames
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Martin Schiller <ms@dev.tdt.de>,
        "David S. Miller" <davem@davemloft.net>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 30, 2021 at 11:16 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Sounds like too much afford for a sub-optimal workaround.
> The qdisc semantics are borken in the proposed scheme (double
> counting packets) - both in term of statistics and if user decides
> to add a policer, filter etc.

Hmm...

Another solution might be creating another virtual device on top of
the HDLC device (similar to what "hdlc_fr.c" does), so that we can
first queue L3 packets in the virtual device's qdisc queue, and then
queue the L2 frames in the actual HDLC device's qdisc queue. This way
we can avoid the same outgoing data being queued to qdisc twice. But
this would significantly change the way the user uses the hdlc_x25
driver.

> Another worry is that something may just inject a packet with
> skb->protocol == ETH_P_HDLC but unexpected structure (IDK if
> that's a real concern).

This might not be a problem. Ethernet devices also allow the user to
inject raw frames with user constructed headers. "hdlc_fr.c" also
allows the user to bypass the virtual circuit interfaces and inject
raw frames directly on the HDLC interface. I think the receiving side
should be able to recognize and drop invalid frames.

> It may be better to teach LAPB to stop / start the internal queue.
> The lower level drivers just needs to call LAPB instead of making
> the start/wake calls directly to the stack, and LAPB can call the
> stack. Would that not work?

I think this is a good solution. But this requires changing a lot of
code. The HDLC subsystem needs to be changed to allow HDLC Hardware
Drivers to ask HDLC Protocol Drivers (like hdlc_x25.c) to stop/wake
the TX queue. The hdlc_x25.c driver can then ask the LAPB module to
stop/wake the queue.

So this means new APIs need to be added to both the HDLC subsystem and
the LAPB module, and a number of HDLC Hardware Drivers need to be
changed to call the new API of the HDLC subsystem.

Martin, do you have any suggestions?
