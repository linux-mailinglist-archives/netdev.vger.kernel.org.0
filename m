Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE8EE1E009B
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 18:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387682AbgEXQfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 12:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728316AbgEXQfI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 May 2020 12:35:08 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C43C061A0E
        for <netdev@vger.kernel.org>; Sun, 24 May 2020 09:35:07 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id yc10so18188562ejb.12
        for <netdev@vger.kernel.org>; Sun, 24 May 2020 09:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ozBbKWjBkt05QLra2qsRECxpCHo+rFaakDDdTAOzwmY=;
        b=eK4hYc9hyNu4lmHLVnL0n1f+n1CbvMfmdEkiz5Nc7a3YyBR1RWhsSnEa4UyhX3ue9v
         TjSzsdoaWNZsrgeAfuo9Put8IHAKCBFRKtNIhhz5k3ViLJcfLPo0aX89yi/ZcHPD6+y7
         eoPeviGw9T8qPMDDul3xpnffFTbj8LNf6LZD6QoEIyJ6JO3LRT1H3TIQWV/vbRWzV5OJ
         ukNv8hcRYEQYNsEFwwIt7LgGl70ZtD2ULd+rQR9U+s0Kdfch3uVw81YTTy+/PtJV1qDo
         8MVXIXadhSgY+dj0pxXTZSsWSuQ1zbAn/fBdUweRoY6nKKXKl4JTj9AgkbKtOygE2gx7
         QugQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ozBbKWjBkt05QLra2qsRECxpCHo+rFaakDDdTAOzwmY=;
        b=J4b0bG4lvOu19315+p9jAUe+TM1/q3A6M3YsyTSEmUlHOMppuMRzLSjpP81eMytGEv
         6/412KbdV2n1Qp9A7Jjuw2iM5bc1SmLlohN+X0sHwk5mjfDwceNoNJLdD8KGDy5lohfF
         a5kGVSc9fozIOcXCGmwg/QRbc3RPNQD8hcSVdxzeqKisJzKpDkKjdMFzJa6EKf4mT42a
         Gg3vLD9UOHToXbaSdcT7oLzK9iBkhrmT20caXKvkz/LPfPHj+JMSy37oaUeXaWRXhpTN
         x9BtgIC7MxQH58Pt1kf7I61pI6GDIFsY3NFfFKx+ncoM40P3y/vW3RMhAhx+ksDGK+P0
         VrNw==
X-Gm-Message-State: AOAM531BVJiPFd/7h8yAMHpWXHvQQ+o53Z3UXZSPSzZubzjntUtPteDb
        5SAs6+eccetAdLiU8SOmUff5uPzluS/PLZ64Xrk=
X-Google-Smtp-Source: ABdhPJxwLVagfyCHQx587mGrCskm5p31UwhlhAEWIqmhGdLXWHtPupdWwYDMUX5RrMemJmN3P/ZVqDN7IHIcI0E0SGM=
X-Received: by 2002:a17:906:a0c2:: with SMTP id bh2mr15618239ejb.406.1590338105827;
 Sun, 24 May 2020 09:35:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200521211036.668624-1-olteanv@gmail.com> <f51e89a0-b481-e0e1-0e87-f803f116f684@gmail.com>
In-Reply-To: <f51e89a0-b481-e0e1-0e87-f803f116f684@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sun, 24 May 2020 19:34:54 +0300
Message-ID: <CA+h21hqHnH3BwyQp-SDk-=aV+7Ms+08b+Rzw1=OpXEhha+Nh0Q@mail.gmail.com>
Subject: Re: [PATCH RFC net-next 00/13] RX filtering for DSA switches
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Ivan Vecera <ivecera@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Sun, 24 May 2020 at 19:13, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> Hi Vladimir,
>
> On 5/21/2020 2:10 PM, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > This is a WIP series whose stated goal is to allow DSA and switchdev
> > drivers to flood less traffic to the CPU while keeping the same level of
> > functionality.
> >
> > The strategy is to whitelist towards the CPU only the {DMAC, VLAN} pairs
> > that the operating system has expressed its interest in, either due to
> > those being the MAC addresses of one of the switch ports, or addresses
> > added to our device's RX filter via calls to dev_uc_add/dev_mc_add.
> > Then, the traffic which is not explicitly whitelisted is not sent by the
> > hardware to the CPU, under the assumption that the CPU didn't ask for it
> > and would have dropped it anyway.
> >
> > The ground for these patches were the discussions surrounding RX
> > filtering with switchdev in general, as well as with DSA in particular:
> >
> > "[PATCH net-next 0/4] DSA: promisc on master, generic flow dissector code":
> > https://www.spinics.net/lists/netdev/msg651922.html
> > "[PATCH v3 net-next 2/2] net: dsa: felix: Allow unknown unicast traffic towards the CPU port module":
> > https://www.spinics.net/lists/netdev/msg634859.html
> > "[PATCH v3 0/2] net: core: Notify on changes to dev->promiscuity":
> > https://lkml.org/lkml/2019/8/29/255
> > LPC2019 - SwitchDev offload optimizations:
> > https://www.youtube.com/watch?v=B1HhxEcU7Jg
> >
> > Unicast filtering comes to me as most important, and this includes
> > termination of MAC addresses corresponding to the network interfaces in
> > the system (DSA switch ports, VLAN sub-interfaces, bridge interface).
> > The first 4 patches use Ivan Khoronzhuk's IVDF framework for extending
> > network interface addresses with a Virtual ID (typically VLAN ID). This
> > matches DSA switches perfectly because their FDB already contains keys
> > of the {DMAC, VID} form.
> >
> > Multicast filtering was taken and reworked from Florian Fainelli's
> > previous attempts, according to my own understanding of multicast
> > forwarding requirements of an IGMP snooping switch. This is the part
> > that needs the most extra work, not only in the DSA core but also in
> > drivers. For this reason, I've left out of this patchset anything that
> > has to do with driver-level configuration (since the audience is a bit
> > larger than usual), as I'm trying to focus more on policy for now, and
> > the series is already pretty huge.
>
>
> First off, thank you very much for collecting the various patches and
> bringing them up to date, so far I only had a cursory look at your
> patches and they do look good to me in principle. I plan on testing this
> next week with the b53/bcm_sf2 switches and give you some more detailed
> feedback.
>
> Which of UC or MC filtering do you value the most for your use cases?
> For me it would be MC filtering because the environment is usually
> Set-top-box and streaming devices.
> --
> Florian

Actually one of my main motivations has to do with the fact that with
sja1105, I can only deliver up to 32 unique VLANs to the CPU. But I do
want to be able to use the other ~2000 VLANs in an
autonomous-forwarding manner. So I need to do very strict bookkeeping
of {DMAC, VLAN} addresses that the operating system needs to see,
because the CPU port will not be a member of the
autonomously-forwarded VLANs.
So it's not that I value unicast filtering more than multicast
filtering - I need to do both before I can achieve this goal, but at
the moment I have some trouble setting up IGMP snooping to work
properly on a device that doesn't look beyond L2 headers. With
Ocelot/Felix that is easier, but it has some challenges of its own.

Thanks,
-Vladimir
