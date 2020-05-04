Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAA821C3B0E
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 15:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbgEDNPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 09:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726445AbgEDNPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 09:15:23 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0B1DC061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 06:15:21 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id a8so13468958edv.2
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 06:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xXEa0UDgr6Sm1oxU98rlFxrrOQrsTyDffYdHdbwRax0=;
        b=PpXTUOs5creydWHMCtoXQcyYihf8bhTtsnUlZf4q8R8MS7trUpZfbPOVaF37dAufN4
         tOqP/8bW9H05mZfBvbMRWeBnXRjddOgvWR5yvtg8GBnmfAP+JD94/omczqFibmsMOokg
         IRFya0xN9uRvtki/VZc8NeY5XJkwLeJyKauqDRL7a+BTdXi1fpbGBFCBWWMImWXz5BPy
         shvjBf+KAeinPX5AA35qbn45d4pMYT5/DF2+uYqJ/jPhiav0J498liEumEa8wwUkFAf8
         pGeGf+2fVnEN1E+1ym8aKEVExU2Yj3ac91wu6pFfsg0BOMEfF4JuTnN9tAsNg+/NCdRB
         N95A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xXEa0UDgr6Sm1oxU98rlFxrrOQrsTyDffYdHdbwRax0=;
        b=njzZOOW1Yd8I1x/RuCgoOUCZe0ZkvHotIhoPZR868MvFjn6ov623fasRVXKkG0wPJd
         RNlBtmL16h6wocGzZtjcAYrdLSXPR4UTIZNXMNsY/KGWaJ8Aysmth5bnOyoUgty6NiPU
         /tNlf3sStMGibqBLFRL1BEj2Auy5nRfqXbVzzOb+BDVsTLp7oZNOnO11YN0XdzPOoOtr
         noe1XgGLCcYelCM4K6BF1LqMo/Kga+oS2kt+ICYhT1jTqoszN1Jr+pvqAs4vf/3j5fbV
         tdJFbMBUI0AtKTjUkqAhiniAEjC0YgwO4a/YRnlk/W73rPZO7m4boGDZzvxUcm6GZPiD
         ZHHQ==
X-Gm-Message-State: AGi0PuZFjIOyVls3XDydeNGDfrCNUtwjb0A4fLMUmJ01mZGC3dQJt2vm
        xJCDg4V391Vzf/odo2gvroNyJZRXa8jnRNun4zY=
X-Google-Smtp-Source: APiQypKXiDanSVgOWaslcdJGl6DeLhTEFB8aK0dXtclxWxdNhm3Tvkglp60pS3/QEJQaMCiem82V+RzJp14r0AKVxts=
X-Received: by 2002:a50:8dc2:: with SMTP id s2mr15190448edh.318.1588598120565;
 Mon, 04 May 2020 06:15:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200425120207.5400-1-dqfext@gmail.com> <CA+h21hpeJK8mHduKoWn5rbmz=BEz_6HQdz3Xf63NsXpZxsky0A@mail.gmail.com>
 <CALW65jb_n49+jTo8kd6QT7AwXdCxJOR1bOFA72fyhjReM2688Q@mail.gmail.com>
In-Reply-To: <CALW65jb_n49+jTo8kd6QT7AwXdCxJOR1bOFA72fyhjReM2688Q@mail.gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 4 May 2020 16:15:09 +0300
Message-ID: <CA+h21hrhcqpF+nTmG6057ckB+CzHQGC+F5_bbAK7TXxmpvzNBQ@mail.gmail.com>
Subject: Re: [RFC PATCH net-next] net: dsa: mt7530: fix roaming from DSA user ports
To:     DENG Qingfang <dqfext@gmail.com>
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

Hi Qingfang,

On Mon, 4 May 2020 at 15:47, DENG Qingfang <dqfext@gmail.com> wrote:
>
> Hi Vladimir,
>
> On Mon, May 4, 2020 at 6:23 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> >
> > Hi Qingfang,
> >
> > On Sat, 25 Apr 2020 at 15:03, DENG Qingfang <dqfext@gmail.com> wrote:
> > >
> > > When a client moves from a DSA user port to a software port in a bridge,
> > > it cannot reach any other clients that connected to the DSA user ports.
> > > That is because SA learning on the CPU port is disabled, so the switch
> > > ignores the client's frames from the CPU port and still thinks it is at
> > > the user port.
> > >
> > > Fix it by enabling SA learning on the CPU port.
> > >
> > > To prevent the switch from learning from flooding frames from the CPU
> > > port, set skb->offload_fwd_mark to 1 for unicast and broadcast frames,
> > > and let the switch flood them instead of trapping to the CPU port.
> > > Multicast frames still need to be trapped to the CPU port for snooping,
> > > so set the SA_DIS bit of the MTK tag to 1 when transmitting those frames
> > > to disable SA learning.
> > >
> > > Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
> > > Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> > > ---
> >
> > I think enabling learning on the CPU port would fix the problem
> > sometimes, but not always. (actually nothing can solve it always, see
> > below)
> > The switch learns the new route only if it receives any packets from
> > the CPU port, with a SA equal to the station you're trying to reach.
> > But what if the station is not sending any traffic at the moment,
> > because it is simply waiting for connections to it first (just an
> > example)?
> > Unless there is any traffic already coming from the destination
> > station too, your patch won't work.
> > I am currently facing a similar situation with the ocelot/felix
> > switches, but in that case, enabling SA learning on the CPU port is
> > not possible.
>
> Why is it not possible?
>

Because learning on the CPU port is not supported on this hardware.

> Then try my previous RFC patch
> "net: bridge: fix client roaming from DSA user port"
> It tries removing entries from the switch when the client moves to another port.
>

Your patch only deletes FDB entries of packets received in the
fastpath by the software bridge, which as I said, won't work if the
software bridge doesn't receive packets in the first place due to a
stale FDB entry.

> > The way I dealt with it is by forcing a flush of the FDB entries on
> > the port, in the following scenarios:
> > - link goes down
> > - port leaves its bridge
> > So traffic towards a destination that has migrated away will
> > temporarily be flooded again (towards the CPU port as well).
> > There is still one case which isn't treated using this approach: when
> > the station migrates away from a switch port that is not directly
> > connected to this one. So no "link down" events would get generated in
> > that case. We would still have to wait until the address expires in
> > that case. I don't think that particular situation can be solved.
>
> You're right. Every switch has this issue, even Linux bridge.
>
> > My point is: if we agree that this is a larger problem, then DSA
> > should have a .port_fdb_flush method and schedule a workqueue whenever
> > necessary. Yes, it is a costly operation, but it will still probably
> > take a lot less than the 300 seconds that the bridge configures for
> > address ageing.
> >
> > Thoughts?
> >

> >
> > Thanks,
> > -Vladimir

Regards,
-Vladimir
