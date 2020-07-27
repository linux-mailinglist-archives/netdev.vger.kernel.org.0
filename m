Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E983022F402
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 17:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730914AbgG0Pli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 11:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730905AbgG0Plh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 11:41:37 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62AB6C061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 08:41:37 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id v15so4716016lfg.6
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 08:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wIjDVPKqdkF+6aYtOIQ3W6Li/YJL+puMmH4ZvB1VMNM=;
        b=mjU15NemkSZjw+n/lyfiQtFYkFUqUoXPGQ6FfBVa1UKAuG1RjscBFDbAcPuBdHR9YE
         E4mAnt3JXDyx4RIU4uQ5sCLy9R/R+QfkZRsc9DFynW8vUXJZMTrnnKYlaBaJ95dmLyJV
         tgZBM0GtVmwbBMVU3ITJWuTDA0QQTEzvkwCblCnFWw7Y8QBrzsHygdh3szgl8hidA+uf
         0sbzSlbT2g9AwxQ4OppT/R7t1T9wkKhASpOjWOiHHu4KVIKwJr2oHD5jsp1OtPJOpgM1
         QcsoUk+R+COQAzMtLZFhwpkK1Z++rN0dP70PtVpvXAUcyTYBMwSBvDJxkK44v1vofPwP
         6bxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wIjDVPKqdkF+6aYtOIQ3W6Li/YJL+puMmH4ZvB1VMNM=;
        b=P/ySrbXD0EUO3DmtsxDnAPCDe2lLb8BUH05Dr9UECilxpFmXMmK09vMLeJ4HuAf/4W
         rwoenZnCMrT8RRvEmIzwPBHhZ9U8FEFBcFLSdMeHMusSVLs0K8fLkpGlmrP/H32q+xmE
         g7w2PXC6H19q5xUXyoPBl3q95c5+3D6pMaRKmjS0xBJtR3zM0f0dIeRIV3TqxgpBI3LD
         SPHP7v0qxqbNr1M4/mi9y9Jg9/XPH+1ECvRzkZ7bpS2ugfwQzsArt9pjOgyNkUuYzW3n
         fjIFGs9JYHudDUHihRkMQzyuu/VA5uQhCmOqFXGXZ/kvBsF50kpQw+JO+3p2eI9ifupd
         Fe7A==
X-Gm-Message-State: AOAM5328iMYYre1K0C6mr2h71hENK6JBjYlPqYz/jhMoWlC+0fcpYXk7
        DLI4LyouAuQYOEdq1t8C/PYCjDfqPktBXuEicYQ=
X-Google-Smtp-Source: ABdhPJytldLJhrei4pxIcauyJ0+KSsu5hsnCAhII0TB61jVHehTStZVzkTVTPZmT2+AYd+wXvDBqICPCtYYAf4ANGU4=
X-Received: by 2002:a19:c197:: with SMTP id r145mr11938012lff.41.1595864494933;
 Mon, 27 Jul 2020 08:41:34 -0700 (PDT)
MIME-Version: 1.0
References: <1587996484-3504-1-git-send-email-fugang.duan@nxp.com>
 <20200727012354.GT28704@pendragon.ideasonboard.com> <20200727020631.GW28704@pendragon.ideasonboard.com>
 <20200727021432.GM1661457@lunn.ch> <20200727023310.GA23988@pendragon.ideasonboard.com>
 <CAFXsbZrf11Nj4rzLJfisPr-fFo-+stt-G3-XQ_Mwus_2z0nsAg@mail.gmail.com>
 <CAFXsbZrysb6SGisEhgXHzj8NZ5o_EjY-rtiqg3gypgr0w-d-dw@mail.gmail.com>
 <CAFXsbZpBP_kzsC_dLYezJWo7+dQufoRmaFpJgKJbnn6T=sc5QA@mail.gmail.com>
 <20200727120545.GN1661457@lunn.ch> <20200727152434.GF20890@pendragon.ideasonboard.com>
In-Reply-To: <20200727152434.GF20890@pendragon.ideasonboard.com>
From:   Chris Healy <cphealy@gmail.com>
Date:   Mon, 27 Jul 2020 08:41:23 -0700
Message-ID: <CAFXsbZo5ufE0v_dmzQU9oWBeeRj+DKzDoiMj6OjuiER0O7nFfQ@mail.gmail.com>
Subject: Re: [RESENT PATCH net--stat 1/1] net: ethernet: fec: Revert "net:
 ethernet: fec: Replace interrupt driven MDIO with polled IO"
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Martin Fuzzey <martin.fuzzey@flowbird.group>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 8:24 AM Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> Hi Andrew,
>
> On Mon, Jul 27, 2020 at 02:05:45PM +0200, Andrew Lunn wrote:
> > On Sun, Jul 26, 2020 at 08:01:25PM -0700, Chris Healy wrote:
> > > It appears quite a few boards were affected by this micrel PHY driver change:
> > >
> > > 2ccb0161a0e9eb06f538557d38987e436fc39b8d
> > > 80bf72598663496d08b3c0231377db6a99d7fd68
> > > 2de00450c0126ec8838f72157577578e85cae5d8
> > > 820f8a870f6575acda1bf7f1a03c701c43ed5d79
> > >
> > > I just updated the phy-mode with my board from rgmii to rgmii-id and
> > > everything started working fine with net-next again:
> >
> > Hi Chris
> >
> > Is this a mainline supported board? Do you plan to submit a patch?
> >
> > Laurent, does the change also work for your board? This is another one
> > of those cases were a bug in the PHY driver, not respecting the
> > phy-mode, has masked a bug in the device tree, using the wrong
> > phy-mode. We had the same issue with the Atheros PHY a while back.
>
> Yes, setting the phy-mode to rgmii-id fixes the issue.
>
> Thank you everybody for your quick responses and very useful help !
>
> On a side note, when the kernel boots, there's a ~10s delay for the
> ethernet connection to come up:
>
> [    4.050754] Micrel KSZ9031 Gigabit PHY 30be0000.ethernet-1:01: attached PHY driver [Micrel KSZ9031 Gigabit PHY] (mii_bus:phy_addr=30be0000.ethernet-1:01, irq=POLL)
> [   15.628528] fec 30be0000.ethernet eth0: Link is Up - 1Gbps/Full - flow control rx/tx
> [   15.676961] Sending DHCP requests ., OK
> [   15.720925] IP-Config: Got DHCP answer from 192.168.2.47, my address is 192.168.2.210
>
> The LED on the connected switch confirms this, it lits up synchronously
> with the "Link is up" message. It's not an urgent issue, but if someone
> had a few pointers on how I could debug that, it would be appreciated.

Here's a few suggestions that could help in learning more:

1) Review the KSZ9031 HW errata and compare against the PHY driver
code.  There's a number of errata that could cause this from my quick
review.
2) Based on what I read in the HW errata, try different link partners
that utilize different copper PHYs to see if it results in different
behaviour.
3) Try setting your autonegotiate advertisement to only advertise
100Mbps and see if this affects the timing.  Obviously this would not
be a solution but might help in better understanding the issue.

>
> --
> Regards,
>
> Laurent Pinchart
