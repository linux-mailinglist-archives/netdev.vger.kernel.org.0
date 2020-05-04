Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66F551C3D87
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 16:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729179AbgEDOuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 10:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727833AbgEDOuA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 10:50:00 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B4C8C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 07:50:00 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id k6so12576684iob.3
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 07:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b/g+R1fDSmMSuxtLGeYcAV97ESR2gO90b6gQaER1uUA=;
        b=K73aK+3h8ByTePqEK2rSx6EASzMwrdGbT8R6QT+4oF8kK3oGc1gUHKD3n8ObF5qr7v
         CBbrBDhwfxv+AWWM6QTjfPhZsMzifL5EIHZPM5qK2FSH25CsUMMZ4Ssk1k4b+XX+3OGZ
         3ox5bQ6QPt4id0llvbe8R5x7hWlhmibWwd1HRLaWdXO1kn5Z/CGwBqIOspAa1lU4PY/0
         6ppkMqNjd9OG/KvaFNYm3+5AD1CVxSw961Xi4SBC/kBxFuQ5woYRwOOuCdENMNgoncCa
         plrTVIosXU1f75VJe8hJYGiuGoDdiusoIYWz4aRMlzJFUTHA/mA2lOOLEouyF4UCb8QY
         BnXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b/g+R1fDSmMSuxtLGeYcAV97ESR2gO90b6gQaER1uUA=;
        b=UnSfbB0YOD7/Oeaud0Nh2+eVgxTFs16sQ73oKEwhNhYl1oktlnhJ5Fb9w1Dzul6IQp
         7XnqFXrrxpjKHVUJbdoWIvXt9mV9ckwq/8LChJOhuV1qOL9B0An33cDGRkkJXxpUlO7x
         SpSIb50145LsQ320Fgi/u5mk7WI5LMDv4KYeSAqW+ElbN1VBtMMGN9FlbXuxa2Z13lyQ
         /M6FmhnnEZrwZy1YoRQkjPGU5or0kp/EBy1q2GU8+EO4SwZg9cMXcwDWxShbnaDy5Kyg
         +1Z6XhBSO0FGgNWkTzqt3HJVVql/rlkXbGDLaQ1ML5InExZtpjR8QsWMIoD4eBWJJCPZ
         8DWQ==
X-Gm-Message-State: AGi0PuZMtLhnCbbPz8a4sD/1iEQiK9TknUEhuDxvIO0/rBb43koBMVVv
        mqtkNSHz/pPPyHXg+R3XWbiPWS1QoM3UjXp9+qk=
X-Google-Smtp-Source: APiQypIUunA/C7JtFZKuCl06GpCLRGSjHQpeo66/A6o4dchQzdz+j40TdiWgquMUWFcQWzBWW6wr2tQi8Bl20CIUxP0=
X-Received: by 2002:a02:5bc9:: with SMTP id g192mr15615436jab.136.1588603799448;
 Mon, 04 May 2020 07:49:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200425120207.5400-1-dqfext@gmail.com> <CA+h21hpeJK8mHduKoWn5rbmz=BEz_6HQdz3Xf63NsXpZxsky0A@mail.gmail.com>
 <CALW65jb_n49+jTo8kd6QT7AwXdCxJOR1bOFA72fyhjReM2688Q@mail.gmail.com> <CA+h21hrhcqpF+nTmG6057ckB+CzHQGC+F5_bbAK7TXxmpvzNBQ@mail.gmail.com>
In-Reply-To: <CA+h21hrhcqpF+nTmG6057ckB+CzHQGC+F5_bbAK7TXxmpvzNBQ@mail.gmail.com>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Mon, 4 May 2020 22:49:50 +0800
Message-ID: <CALW65ja9+pCMkd_1VGYnxwwLdDnS1ZBamB-KWT=fFTdT51B64Q@mail.gmail.com>
Subject: Re: [RFC PATCH net-next] net: dsa: mt7530: fix roaming from DSA user ports
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>,
        Tom James <tj17@me.com>,
        Stijn Segers <foss@volatilesystems.org>,
        riddlariddla@hotmail.com, Szabolcs Hubai <szab.hu@gmail.com>,
        Paul Fertser <fercerpav@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Mon, May 4, 2020 at 9:15 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> Hi Qingfang,
>
> On Mon, 4 May 2020 at 15:47, DENG Qingfang <dqfext@gmail.com> wrote:
> >
> > Hi Vladimir,
> >
> > On Mon, May 4, 2020 at 6:23 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> > >
> > > Hi Qingfang,
> > >
> > > On Sat, 25 Apr 2020 at 15:03, DENG Qingfang <dqfext@gmail.com> wrote:
> > > >
> > > > When a client moves from a DSA user port to a software port in a bridge,
> > > > it cannot reach any other clients that connected to the DSA user ports.
> > > > That is because SA learning on the CPU port is disabled, so the switch
> > > > ignores the client's frames from the CPU port and still thinks it is at
> > > > the user port.
> > > >
> > > > Fix it by enabling SA learning on the CPU port.
> > > >
> > > > To prevent the switch from learning from flooding frames from the CPU
> > > > port, set skb->offload_fwd_mark to 1 for unicast and broadcast frames,
> > > > and let the switch flood them instead of trapping to the CPU port.
> > > > Multicast frames still need to be trapped to the CPU port for snooping,
> > > > so set the SA_DIS bit of the MTK tag to 1 when transmitting those frames
> > > > to disable SA learning.
> > > >
> > > > Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
> > > > Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> > > > ---
> > >
> > > I think enabling learning on the CPU port would fix the problem
> > > sometimes, but not always. (actually nothing can solve it always, see
> > > below)
> > > The switch learns the new route only if it receives any packets from
> > > the CPU port, with a SA equal to the station you're trying to reach.
> > > But what if the station is not sending any traffic at the moment,
> > > because it is simply waiting for connections to it first (just an
> > > example)?
> > > Unless there is any traffic already coming from the destination
> > > station too, your patch won't work.
> > > I am currently facing a similar situation with the ocelot/felix
> > > switches, but in that case, enabling SA learning on the CPU port is
> > > not possible.
> >
> > Why is it not possible?
> >
>
> Because learning on the CPU port is not supported on this hardware.
>
> > Then try my previous RFC patch
> > "net: bridge: fix client roaming from DSA user port"
> > It tries removing entries from the switch when the client moves to another port.
> >
>
> Your patch only deletes FDB entries of packets received in the
> fastpath by the software bridge, which as I said, won't work if the
> software bridge doesn't receive packets in the first place due to a
> stale FDB entry.

As I said before, ALL switches including software linux bridge have this issue.
In this case, you'd better ensure the client sends packets first after
migration, which
most clients already do in switches + wireless APs setup.

>
> > > The way I dealt with it is by forcing a flush of the FDB entries on
> > > the port, in the following scenarios:
> > > - link goes down
> > > - port leaves its bridge
> > > So traffic towards a destination that has migrated away will
> > > temporarily be flooded again (towards the CPU port as well).
> > > There is still one case which isn't treated using this approach: when
> > > the station migrates away from a switch port that is not directly
> > > connected to this one. So no "link down" events would get generated in
> > > that case. We would still have to wait until the address expires in
> > > that case. I don't think that particular situation can be solved.
> >
> > You're right. Every switch has this issue, even Linux bridge.
> >
> > > My point is: if we agree that this is a larger problem, then DSA
> > > should have a .port_fdb_flush method and schedule a workqueue whenever
> > > necessary. Yes, it is a costly operation, but it will still probably
> > > take a lot less than the 300 seconds that the bridge configures for
> > > address ageing.
> > >
> > > Thoughts?
> > >
>
> > >
> > > Thanks,
> > > -Vladimir
>
> Regards,
> -Vladimir

Regards,
Qingfang
