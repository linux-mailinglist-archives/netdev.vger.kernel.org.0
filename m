Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40FF11CD95D
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 14:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729618AbgEKMIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 08:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727873AbgEKMIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 08:08:02 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E8F2C061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 05:08:00 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id t3so7310571otp.3
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 05:08:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=re50DF1Ln8r/SxBNgJA8/mMByt252ccww4yVo/OtRBE=;
        b=TjjF3QGq8GGb3yvxh2TsOm9R//KQdvTcHcWocnTc5BHzPlktYFsAjKwnTf25BwVX9O
         8+747k/1VHimYwVwq8fzTUtxouBvsbbOs8l6BJzFpJSZSBvI/joycP/+cKN3Ock8rzrg
         sOMpOa/ViYOIZFbgaCFqfb2XzyxHn0nMnULTCnNiOsbNkQZEZ0Zr1Dw1UU5pY1bXsThX
         tu9TPJyFNM/KxOnQBnWNlwdhLjqf8ejtOjy5Ovz6rPa6TidfVZNopRZGhl6JDm89ODy2
         FTVHmS85GKMRXkKcViWYrZCor1AKAit6hm5wj/2a5NCT0ops7Ne4wayjjMPBY5r+urp/
         5RWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=re50DF1Ln8r/SxBNgJA8/mMByt252ccww4yVo/OtRBE=;
        b=pcZSrQp3FqZ81cY/W9QmjkeILh1xXQOuR9vClMn60pr+vqBbTjAUnppoNQrfnjaqP1
         EuYJizJyouO7URZibnWTU6Jur+/HbOOj3Z6bTKsyw8kTCWFTh8LK84UyObYGEgW6RE7Y
         weZ6/fgf8prK7va9wqRjCu/YKaoVOvdiw1hToL5DUsV4kXeDMCbZVQ76uMR16bBtqyU7
         /ip3FH5BAI2/z6imYGjwkeNuka/JojcsEzjW3/0bXlW9EY/Mv57PWGyGsyv7Rc6mrjva
         FeWCTTqnHeUfpETHG4NZ5/iXaZDyxAplvBqyhxkgOl5elxR5/jTKzCVttIbjSwBoCGsm
         1cNQ==
X-Gm-Message-State: AGi0PuarGWwOe23UroiUnpBvMShCIkkliRodzhA/pu24NLvtBqHibXhb
        B/CnrJbwiNaTm26WNd5rFetSXzFSv2BuDT4esBAQPR6CgkM=
X-Google-Smtp-Source: APiQypJSQLRCHa48T1CmDhXjBOc7FejVPamQan1fa6beITQSeRFA5AsHIiJ/qno7F88plkuso8LUoREK+hetKx2fWvo=
X-Received: by 2002:a9d:66a:: with SMTP id 97mr11655721otn.181.1589198879861;
 Mon, 11 May 2020 05:07:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200425120207.5400-1-dqfext@gmail.com> <CA+h21hpeJK8mHduKoWn5rbmz=BEz_6HQdz3Xf63NsXpZxsky0A@mail.gmail.com>
In-Reply-To: <CA+h21hpeJK8mHduKoWn5rbmz=BEz_6HQdz3Xf63NsXpZxsky0A@mail.gmail.com>
From:   Chuanhong Guo <gch981213@gmail.com>
Date:   Mon, 11 May 2020 20:07:48 +0800
Message-ID: <CAJsYDVJL-uGvfFpfvF9yC394PJZNdBJj=z_hctywn8DAT7ohmw@mail.gmail.com>
Subject: Re: [RFC PATCH net-next] net: dsa: mt7530: fix roaming from DSA user ports
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        riddlariddla@hotmail.com, Paul Fertser <fercerpav@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Russell King <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        Stijn Segers <foss@volatilesystems.org>,
        Szabolcs Hubai <szab.hu@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, Tom James <tj17@me.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

On Mon, May 4, 2020 at 6:23 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> I think enabling learning on the CPU port would fix the problem
> sometimes, but not always. (actually nothing can solve it always, see
> below)
> The switch learns the new route only if it receives any packets from
> the CPU port, with a SA equal to the station you're trying to reach.
> But what if the station is not sending any traffic at the moment,
> because it is simply waiting for connections to it first (just an
> example)?
> Unless there is any traffic already coming from the destination
> station too, your patch won't work.

This is just the limitation of connecting two bridges together.

> I am currently facing a similar situation with the ocelot/felix
> switches, but in that case, enabling SA learning on the CPU port is
> not possible.
> The way I dealt with it is by forcing a flush of the FDB entries on
> the port, in the following scenarios:
> - link goes down
> - port leaves its bridge
> So traffic towards a destination that has migrated away will
> temporarily be flooded again (towards the CPU port as well).

In previous discussion in thread:
"net: bridge: fix client roaming from DSA user port"
It's currently established that linux treats a DSA switch with
forwarding offload capability as its own bridge.

If the switch can't learn from cpu port, you either need
to propose a change of this already established behaviour
so that software bridge can sync its fdb with hardware
(making sw bridge and hardware switch behave as
one bridge instead of two) or write extra code to help
managing hardware fdb. (so that the switch matches
current behaviour.)

> There is still one case which isn't treated using this approach: when
> the station migrates away from a switch port that is not directly
> connected to this one. So no "link down" events would get generated in
> that case. We would still have to wait until the address expires in
> that case. I don't think that particular situation can be solved.
> My point is: if we agree that this is a larger problem, then DSA
> should have a .port_fdb_flush method and schedule a workqueue whenever
> necessary. Yes, it is a costly operation, but it will still probably
> take a lot less than the 300 seconds that the bridge configures for
> address ageing.

I think flushing fdb on port topology changes doesn't solve the
problem targeted by this patch.
Anyway, this mt7530 patch is proposed because current
mt7530 driver failed to match the established behaviour for
DSA/switchdev. I think it's better to start a new thread if
you'd like to propose these fundamental behaviour changes,
because this patch is already a result of previously proposed
behaviour changes being rejected.

-- 
Regards,
Chuanhong Guo
