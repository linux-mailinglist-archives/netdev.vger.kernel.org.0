Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B91F170786
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 19:22:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbgBZSWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 13:22:02 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:40029 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726867AbgBZSWC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 13:22:02 -0500
Received: by mail-ed1-f68.google.com with SMTP id p3so4982558edx.7;
        Wed, 26 Feb 2020 10:21:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ovPhpjCazhkBuPF/3ZKvkZXEB2wEDICs1R4JyVb9o08=;
        b=OI9iBUUhfV6cJMJ9vJ68G9/cgbTv1wHVcLG3LksGDJejAEymTYAcHNfYaJykBuoCYe
         87vy3ZZP1+u0TaBtMLFbjh8l7ziIjEh+V4M8f3I/wxUqb7Ew7PxoqQKRR4ZT048Ejzju
         wyU8A8YVqsth1rJFgn/NB5jkfes01W6LkbdTqYBI3MdZ3P4j2c9kTfU1x/BUFK72+5IV
         JHmXKtnRhNimBUw3yac7D0HrmV6Y9w5aJcXVxQLAIsogWJzBZqOeGnjOwt/ZvdBqUHO5
         x7txNWnt26x8UvtluXLhrabAHgxXnevK2t8iE7HXNw6RDu5P2EuMWsvI9OG7e6P2h/P+
         cEig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ovPhpjCazhkBuPF/3ZKvkZXEB2wEDICs1R4JyVb9o08=;
        b=FZKMudeYv9lA/0/sBT1KSh4wYi/yLZefo/nA/uhSkJ6O4tNcOK9NbvaKTbJXElKhrW
         epQv9Zd0QupfzarqOct+KnXxds3JHAZ1pPRbktTlcPJ7PKjeN6R2KVx3W8jWo3meI/C5
         yQ8Nkd6c0apyu/kAd7KPU8RoqxYPXgCFegD7B9CqiMWEmI5JPUGdpV4NZOuq+3RPWEoR
         j32dzrqt1udkUD/909GdCc59GD5UmN6gsfgguMy+8PcU8CwW5cYy/ytjoy9FOh7s7X3y
         aqBi5rXHZ+UeRj04OzBaynROrOp7u6u/w3rgjg7Fxnpj5V8CKIOOXOhF5SRwzUlMaokC
         kseg==
X-Gm-Message-State: APjAAAWxO6jcdTHdc0fkKP2pP692e6jxKqPPryY+EI5LP3k+nhGZssnj
        6NwGGwf31iEd8UfP5+E8HdQKHWyBaBlwWxYo6Pw=
X-Google-Smtp-Source: APXvYqyWWHDLBD74C4KrlGNwJKHlt0Sr7+Pr/k5MqDzX2pGa8p/QrMHHNyTSgjdqd2CIME9nHLlZVrItPU00x+MTPeA=
X-Received: by 2002:a05:6402:128c:: with SMTP id w12mr643997edv.368.1582741318899;
 Wed, 26 Feb 2020 10:21:58 -0800 (PST)
MIME-Version: 1.0
References: <20200226102312.GX25745@shell.armlinux.org.uk> <E1j6tqv-0003G6-BO@rmk-PC.armlinux.org.uk>
 <CA+h21hrR1Xkx9gwAT2FHqcH38L=xjWiPxmF2Er7-4fHFTrA8pQ@mail.gmail.com>
 <20200226115549.GZ25745@shell.armlinux.org.uk> <CA+h21hqjMBjgQDee8t=Csy5DXVUk9f=PP0hHSDfkuA746ZKzSQ@mail.gmail.com>
 <20200226133614.GA25745@shell.armlinux.org.uk>
In-Reply-To: <20200226133614.GA25745@shell.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 26 Feb 2020 20:21:47 +0200
Message-ID: <CA+h21hqHfC0joRDhCQP6MntFdVaApFiC51xk=tUf3+y-C7sX_Q@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/8] net: phylink: propagate resolved link
 config via mac_link_up()
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        John Crispin <john@phrozen.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Feb 2020 at 15:36, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
>
> dpaa2 is complicated by the firmware, and that we can't switch the
> interface mode between (SGMII,1000base-X) and 10G.
>
> If the firmware is in "DPMAC_LINK_TYPE_PHY" mode, it expects to be told
> the current link parameters via the dpmac_set_link_state() call - it
> isn't clear whether that needs to be called for other modes with the
> up/down state (firmware API documentation is poor.)
>

With PCS control in Linux, I am pretty sure that you don't want
anything other than DPMAC_LINK_TYPE_PHY anyway.
Basically in DPMAC_LINK_TYPE_FIXED, the MC firmware is in control of
the PCS and polls its link state to emit link notifications to objects
connected to the DPMAC. So Linux control of PCS would class with
firmware control of the PCS, leading to undesirable side-effects to
say the least.

> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> According to speedtest.net: 11.9Mbps down 500kbps up

Regards,
-Vladimir
