Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9432260769
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 02:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbgIHAHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 20:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727058AbgIHAHa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 20:07:30 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11D5FC061573;
        Mon,  7 Sep 2020 17:07:29 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id c196so3993066pfc.0;
        Mon, 07 Sep 2020 17:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vz3cuK28svOZPnhCoZFGAJ1iHJ+oq8uAsj8UZuAV9AQ=;
        b=adQfRvGujXsDFIcFGwS50H+CpaFf0MLimM2eCW9xUsWsgQsgxIe41lCs/JRVVtqgge
         szKv3a7YjI+rVqujsQ8wIqpC/qiPTNE8H2K7sU+MhMOaGEuajhd+9Z38KOLnKnXpKxZn
         gLwnmBm8SjjwHMoA0sio3dJ5g3NTVAPSRFB3A7WOeXgshisiOvhXJDAEo+6QUAXlOU8A
         OK+tbbTrekEjvB4RfElpNUsKcbElpouA7mRU0gwYUayCBnzgBGCim7pTsY5Ll9UAuR+z
         kyUU/MiPo1G2cVBJcEq3fvTIvJnN9K5Lau5f9l93wYcOMMdAvrieXZO65LZXZloNRuYz
         L3Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vz3cuK28svOZPnhCoZFGAJ1iHJ+oq8uAsj8UZuAV9AQ=;
        b=UEC94F+aYEgo7NSr8wAUUM7SZVLwDpPlYfnUFcGvvMgF6KwUgmhm0Z2aX43Glop8nv
         403O/RmCeKzL76ZgBbQWedtcsxu5LTzxXySM3n1k6aBxPbL5AuLmjE8JpqDhfXAibkU7
         Zlnbu66TkJdQjFj00dm965vsiVub6YNkWCLZUmqPk2OJfrqmY3Cfx6mPLiFAXILH2r1R
         xFiBFN3UmqQ2JPId7y/MYUJPfipvl1ifPzXHp1A81yKu2deVe5+7+YaMsN37O3q7GO3d
         aqHsi7A03aX4XxhGxxV6AgVii/dcv/MUyx9jF94D43Nsy9oMGRomsrGXoZ7T969Xc2vb
         nH8Q==
X-Gm-Message-State: AOAM530ZXrRJc0HGDdIpKRqTnHZYuEDWRjliVUddyXq0x5chJVT4ntrv
        irIN5uAnPfNvwUE5Y98WAjGbcWVebssdmnMMKR0=
X-Google-Smtp-Source: ABdhPJzj5PB769OQ1za3X5AWPdeDF3Md+vAq8OR4nXR6wAMUVBkJWNg6Nck6ycmE6wRdV2YKCSUCP/trOcyViMhR/x8=
X-Received: by 2002:a63:4923:: with SMTP id w35mr17818837pga.368.1599523648346;
 Mon, 07 Sep 2020 17:07:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200906031827.16819-1-xie.he.0141@gmail.com> <CA+FuTSfOeMB7Wv1t12VCTOqPYcTLq2WKdG4AJUO=gxotVRZiQw@mail.gmail.com>
In-Reply-To: <CA+FuTSfOeMB7Wv1t12VCTOqPYcTLq2WKdG4AJUO=gxotVRZiQw@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Mon, 7 Sep 2020 17:07:17 -0700
Message-ID: <CAJht_EO13aYPXBV7sEgOTuUhuHFTFFfdg7NBN2cEKAo6LK0DMQ@mail.gmail.com>
Subject: Re: [PATCH net] net/packet: Fix a comment about hard_header_len and
 headroom allocation
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Ogness <john.ogness@linutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        Or Cohen <orcohen@paloaltonetworks.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        Cong Wang <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thank you for your comment!

On Mon, Sep 7, 2020 at 2:41 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Sun, Sep 6, 2020 at 5:18 AM Xie He <xie.he.0141@gmail.com> wrote:
> >
> > This comment is outdated and no longer reflects the actual implementation
> > of af_packet.c.
>
> If it was previously true, can you point to a commit that changes the behavior?

This is my understanding about the history of "af_packet.c":

1. Pre git history

At first, before "needed_headroom" was introduced, "hard_header_len"
was the only way for a driver to request headroom. However,
"hard_header_len" was also used in "af_packet.c" for processing the
header. There was a confusion / disagreement between "af_packet.c"
developers and driver developers about the use of "hard_header_len".
"af_packet.c" developers would assume that all headers were visible to
them through dev->header_ops (called dev->hard_header at that time?).
But the developers of some drivers were not able to expose all their
headers to "af_packet.c" through header_ops (for example, in tunnel
drivers). These drivers still requested the headroom via
"hard_header_len" but this created bugs for "af_packet.c" because
"af_packet.c" would assume "hard_header_len" was the length of the
header visible to them through header_ops.

Therefore, in Linux version 2.1.43pre1, the FIXME comment was added.
In this comment, "af_packet.c" developers clearly stated that not
exposing the header through header_ops was a bug that needed to be
fixed in the drivers. But I think driver developers were not able to
agree because some drivers really had a need to add their own header
without using header_ops (for example in tunnel drivers).

In Linux version 2.1.68, the developer of "af_packet.c" compromised
and recognized the use of "hard_header_len" even when there is no
header_ops, by adding the comment I'm trying to change now. But I
guess some other developers of "af_packet.c" continued to treat
"hard_header_len" to be the length of header of header_ops and created
a lot of problems.

2. Introduction of "needed_headroom"

Because this issue has troubled for developers for long, in 2008,
developers introduced "needed_headroom" to solve this problem.
"needed_headroom" has only one purpose - reserve headroom. It is not
used in af_packet.c for processing so drivers can safely use it to
request headroom without exposing the header via header_ops.

The commit was:
commit f5184d267c1a ("net: Allow netdevices to specify needed head/tailroom")

After "needed_headroom" was introduced, all drivers that needed to
reserve the headroom but didn't want "af_packet.c" to interfere should
change to "needed_headroom".

From this point on, "af_packet.c" developers were able to assume
"hard_header_len" was only used for header processing purposes in
"af_packet.c".

3. Not reserving the headroom of hard_header_len for RAW sockets

Another very important point in history is these two commits in 2018:
commit b84bbaf7a6c8 ("packet: in packet_snd start writing at link
layer allocation")
commit 9aad13b087ab ("packet: fix reserve calculation")

These two commits changed packet_snd to the present state and made it
no long reserve the headroom of hard_header_len for RAW sockets. This
made drivers' switching from hard_header_len to needed_headroom became
urgent because otherwise they might have a kernel panic when used with
RAW sockets.

> > In this file, the function packet_snd first reserves a headroom of
> > length (dev->hard_header_len + dev->needed_headroom).
> > Then if the socket is a SOCK_DGRAM socket, it calls dev_hard_header,
> > which calls dev->header_ops->create, to create the link layer header.
> > If the socket is a SOCK_RAW socket, it "un-reserves" a headroom of
> > length (dev->hard_header_len), and checks if the user has provided a
> > header of length (dev->hard_header_len) (in dev_validate_header).
>
> Not entirely, a header greater than dev->min_header_len that passes
> dev_validate_header.

Yes, I understand. The function checks both hard_header_len and
min_header_len. I want to explain the role of hard_header_len in
dev_validate_header. But I feel a little hard to concisely explain
this without simplifying a little bit.

> >  /*
> >     Assumptions:
> > -   - if device has no dev->hard_header routine, it adds and removes ll header
> > -     inside itself. In this case ll header is invisible outside of device,
> > -     but higher levels still should reserve dev->hard_header_len.
> > -     Some devices are enough clever to reallocate skb, when header
> > -     will not fit to reserved space (tunnel), another ones are silly
> > -     (PPP).
> > +   - If the device has no dev->header_ops, there is no LL header visible
> > +     outside of the device. In this case, its hard_header_len should be 0.
>
> Such a constraint is more robustly captured with a compile time
> BUILD_BUG_ON check. Please do add a comment that summarizes why the
> invariant holds.

I'm not sure how to do this. I guess both header_ops and
hard_header_len are assigned at runtime. (Right?) I guess we are not
able to check this at compile-time.

> More about the older comment, but if reusing: it's not entirely clear
> to me what "outside of the device" means. The upper layers that
> receive data from the device and send data to it, including
> packet_snd, I suppose? Not the lower layers, clearly. Maybe that can
> be more specific.

Yes, right. If a header is visible "outside of the device", it means
the header is exposed to upper layers via "header_ops". If a header is
not visible "outside of the device" and is only used "internally", it
means the header is not exposed to upper layers via "header_ops".
Maybe we can change it to "outside of the device driver"? We can
borrow the idea of encapsulation in object-oriented programming - some
things that happen inside a software component should not be visible
outside of that software component.
