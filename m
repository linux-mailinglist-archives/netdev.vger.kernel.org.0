Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4620B3D6D18
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 06:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234679AbhG0EEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 00:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233760AbhG0EDX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 00:03:23 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9EAFC0613CF
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 21:03:22 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id w6so13636507oiv.11
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 21:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fTzo6vxMfYlgbUOwSMawZfNKJyreGjClP9wAsvVTm1E=;
        b=UD6VtD2nxoM4yb0LGkCOvaX/zF9yrw4fA6tqSCoTSL82aBwK6yqzv0t2Hz5VkIh/da
         U7yhPJqRFbxApmj84K1i+pXiVe6aku3GXsqXD1Gr0E24zeni9vl8X2Ft59zum4tg7ABv
         RrVdeW5K4K/YjAP3pmiafa7WtuBsVd0+fZX5olSmVMK1nHp8tsPBxPm6G7+7eGn9ZFlP
         7QR+rmk3sAqSdk47QNGEv0p5waWj28vyuS07t6VnIvCCZr3ShLf4G62vnrE7edmJgc/L
         Gcwk1m4LZIpMUGOrRG4xWX95uINhn33c5huopzBpkKNnX1oTDbgg4cVNeuZjHsHCufPR
         57SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fTzo6vxMfYlgbUOwSMawZfNKJyreGjClP9wAsvVTm1E=;
        b=EzMLAGX76kt10usExVyd3oHMn9M7ucV4H1GR+aoLN/vFIBECkMjmbjsKqKvCNq34RD
         GQeHkGvoWf8FiSLwPAbM6SH000hpwOS6TEbmqR9pxTs2R7kzxnVS9Hu3RfKuXwgRqk3v
         Nb0PMsG7rok0Kzb0w3OjwLyEffu7y98z3inh8sIKv5GHIbWYXJ6KN7aXi5XbpWC9jzKV
         nf+moJqUdpaPtf1eBgEpAsKoteUjyqBumH96WUwiePgqMKgNpHxw+nMZygFHL6ArPgjT
         r9wK/iTDQ3k9VRurnQIJzxVdwO1aXCWwh4NC697vGpYbdO4NYq5ouWWL+NYDDEftX8Ux
         D7zQ==
X-Gm-Message-State: AOAM531I+Hjvv0KHWkoDAWz4Bl9W9rBwS5dnAq2xO1bBUHtQ7UpnJ+B4
        2zSZwh+wJBWoPQLDnrxNkzyF623uovOENcTOTDLGTA==
X-Google-Smtp-Source: ABdhPJw+jVLOBD8BsPXzGNdeDNl26ZITTDr1jQEW6mn0yo21vve5G56PdP7KPn7IkR9wNjAU5XZ6SguuPw+dYD0C/Eo=
X-Received: by 2002:aca:abd4:: with SMTP id u203mr13772228oie.13.1627358602134;
 Mon, 26 Jul 2021 21:03:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210721162403.1988814-1-vladimir.oltean@nxp.com>
 <20210721162403.1988814-6-vladimir.oltean@nxp.com> <CA+G9fYtaM=hexrmMvDXzeHZKuLCp53kRYyyvbBXZzveQzgDSyA@mail.gmail.com>
 <YP7ByrIz4LvrvIY5@lunn.ch>
In-Reply-To: <YP7ByrIz4LvrvIY5@lunn.ch>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 27 Jul 2021 09:33:10 +0530
Message-ID: <CA+G9fYtxDUJLRG7sv0aHox=+i7fFaCnLEjA0aaDRXPh+3h57hA@mail.gmail.com>
Subject: Re: [PATCH v6 net-next 5/7] net: bridge: switchdev: let drivers
 inform which bridge ports are offloaded
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Jul 2021 at 19:38, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Mon, Jul 26, 2021 at 07:21:20PM +0530, Naresh Kamboju wrote:
> > On Wed, 21 Jul 2021 at 21:56, Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
> > >
> > > On reception of an skb, the bridge checks if it was marked as 'already
> > > forwarded in hardware' (checks if skb->offload_fwd_mark == 1), and if it
> > > is, it assigns the source hardware domain of that skb based on the
> > > hardware domain of the ingress port. Then during forwarding, it enforces
> > > that the egress port must have a different hardware domain than the
> > > ingress one (this is done in nbp_switchdev_allowed_egress).
>
> > [Please ignore if it is already reported]
> >
> > Following build error noticed on Linux next 20210723 tag
> > with omap2plus_defconfig on arm architecture.
>
> Hi Naresh
>
> Please trim emails when replying. It is really annoying to have to
> page down and down and down to find your part in the email, and you
> always wonder if you accidentally jumped over something when paging
> down at speed.

It was my bad,
I will follow your suggestions in future reports.
Thank you !

>
>      Andrew

- Naresh
