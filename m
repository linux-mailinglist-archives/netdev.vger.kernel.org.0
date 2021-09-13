Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF6C4097C8
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 17:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242514AbhIMPud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 11:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238348AbhIMPuD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 11:50:03 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95AD7C06119D
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 08:34:28 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id qq21so16074910ejb.10
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 08:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wjXNpwq2pWc65/d15zbPXUVq3RDJ2S2nbr99RYsLLsI=;
        b=cEygAp2MrFu6vcJQODmHdqbQNUGU4DabmMYPAMvYPC1ScAEK5y5Oo0Oh8ZeaPIQq3p
         QfK51vnSolWHI61RS36x9qwdirB33xCCduOpGekNxldcTeXX9DMaAIfIU2WV28Sb3WDN
         coegSSv94Za+hjS1pjGVtMlbq8cLCNhpJTV75L+sbrydEO8Uta26cc4LeY01uxGVRhYi
         xtZwWNSdjqrFMkeH8LUiamn3wX++43cVbydEkZZewdo7OcaPU8r60yQ1hFNRTBPXQgJh
         nPi0XC+uUk4+F5gGejZz4Us0ejEp8+s2mAGjRqrQ9bE7HqPKyFH8SVIgqpD1gR3N0Oud
         eC6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wjXNpwq2pWc65/d15zbPXUVq3RDJ2S2nbr99RYsLLsI=;
        b=r3+U5gNenVpzDUK3fI6sTLiNRYHV5D/Q8iL+pg/Jb4lQAHjn6w26k5E05leC4TMd2D
         Ib8tscV86cFXds1FY+gpkYSdg2Mp0jiHkKABdwli9TtB3pXWfmsZ9OcRZu1wphkEIAWO
         6ASw4NGefTiFTb+YgnZHYZdYdSwPmp3cUln4XFucwuqpCBS7Oj1fHep6T6Ihka1G6S5y
         vhmrN8Atyd67ZH1FOS4rR50a13F+mdBpPcENHqGiuNB1Hy4FkNcDUdoLA3D/ZuPgzsw6
         +990r6zOpcd5rybJpCVOLD+bf7kCcCGR19zMq7STQrHNS85368mVAIwFXWgzRRi8AlkV
         sYNA==
X-Gm-Message-State: AOAM530m0IazVsB/kobN3/j+eTfnICKF/xb9yVb1NOO32/z/LHCqRYIH
        8ixzqXZZzGbhErVp0RVEy08=
X-Google-Smtp-Source: ABdhPJwvq0fMhhK7z3XQEjY53Mwd9CLpHjBr2SeHLkM4DxQjgbtwrVY8H3UCKIbNIJ8sQCEDWFnMEg==
X-Received: by 2002:a17:906:b1d5:: with SMTP id bv21mr13413861ejb.346.1631547267118;
        Mon, 13 Sep 2021 08:34:27 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id f21sm1120908ejc.18.2021.09.13.08.34.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 08:34:26 -0700 (PDT)
Date:   Mon, 13 Sep 2021 18:34:25 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Mauri Sandberg <sandberg@mailfence.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [PATCH net-next 5/8] net: dsa: rtl8366: Disable "4K" VLANs
Message-ID: <20210913153425.pgm2zs4vgtnzzyps@skbuf>
References: <20210913144300.1265143-1-linus.walleij@linaro.org>
 <20210913144300.1265143-6-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210913144300.1265143-6-linus.walleij@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 13, 2021 at 04:42:57PM +0200, Linus Walleij wrote:
> I have to disable this feature to have working VLANs on the
> RTL8366RB at least, probably on all of them.
> 
> It appears that the very custom VLAN set-up was using this
> feature by setting up one VLAN per port for a reason: when
> using "4K" VLAN, every frame transmitted by the switch
> MUST have a VLAN tag.
> 
> This is the reason that every port had its own VLAN,
> including the CPU port, and all of them had PVID turned on:
> this way every frame going in or out of the switch will
> indeed have a VLAN tag.
> 
> However the way Linux userspace like to use VLANs such as
> by default assigning all ports on a bridge to the same VLAN
> this does not work at all because PVID is not set for these,
> and all packets get lost.
> 
> Therefore we have to do with 16 VLAN for now, the "4K"
> 4096 VLAN feature is clearly only for switches in
> environments where everything is a VLAN.
> 
> This was discovered when testing with OpenWrt that join
> the LAN ports lan0 ... lan3 into a bridge and then assign
> each of them into VLAN 1 with PVID set on each port: without
> this patch this will not work and the bridge goes numb.

It is important to explain _why_ the switch will go "numb" and not pass
packets if the Linux bridge assigns all ports to VLAN ID 1 as pvid. It
is certainly not expected for that to happen.

The purpose of the PVID feature is specifically to classify untagged
packets to a port-based VLAN ID. So "everything is a VLAN" even for
Linux user space, not sure what you're talking about.

When the Linux bridge has the vlan_filtering attribute set to 1, the
hardware should follow suit by making untagged packets get classified to
the VLAN ID that the software bridge wants to see, on the ports that are
members of that bridge.

When the Linux bridge has the vlan_filtering attribute set to 0, the
software bridge very much ignores any VLAN tags from packets, and does
not perform any VLAN-based ingress admission checks. If the hardware
classifies all packets to a VLAN even when VLAN "filtering" (i.e.
ingress dropping on mismatch) is disabled, that is perfectly fine too,
although the software bridge doesn't care. You need to set up a private
VLAN ID for your VLAN-unaware ports, and make it the pvid on those ports,
and somehow force the hardware to classify any packet towards that pvid
on those VLAN-unaware ports, regardless of whether the packets are
untagged or 802.1Q-tagged or 802.1ad-tagged or whatever. That is simply
the way things are supposed to work.

VLAN ID 0 and 4095 are good candidates to use privately within your
driver as the pvid on VLAN-unaware ports, and you can/must manually
bring up these VLANs, since the bridge will refuse to install these
VLANs in its database.

Other VLAN IDs like the range 4000-4094 are also potentially ok as long
as you document the fact that your driver crops that range out of the
usable range of the bridge, and you make sure that no packet leaks
inside or outside of those private VLANs are possible ("attackers" could
still try to send a packet tagged with VLAN ID 4094 towards a port that
is under a VLAN-aware bridge. Since that port is VLAN-aware, it will
recognize the VLAN ID as 4094, so unless you configure that port to drop
VLAN ID 4094, it might well leak into the VLAN domain 4094 which is
privately used by your driver to ensure VLAN-unaware forwarding between
the ports of a nearby VLAN-unaware bridge.

I know there are lots of things to think about, but this patch is way
too simplistic and does not really offer solid explanations.
