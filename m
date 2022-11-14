Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C49E6289E0
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 20:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237110AbiKNTxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 14:53:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237062AbiKNTxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 14:53:31 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D81419F;
        Mon, 14 Nov 2022 11:53:26 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id y14so30964653ejd.9;
        Mon, 14 Nov 2022 11:53:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xgkgU+XJK79fNtmiiykE65yOYhyetkrTOcQMcl/CZJ8=;
        b=dDYVgHhmha1NxtiYQrt/rWBs0feFsx2LKpDZacWco2+/xjuJ4i9EdLPZYJrls6b6hE
         JOsOMx9dQU5J7msJp3jJetYQxd3p2PuK7qyVYct893G8pZfSzcuZ9SoEjZvdqwxFJ0Zv
         dST309VowM/mHEKLOFPG03JI+Wvh+CLiFP/HzNoYFvStwCBLjavOVujZOME86uio4LTS
         P9EmujlrnSVtl7H3DWpzSLSWl4SCreFHTQNBAwGkUKhIlZnNLyewd7wkvIeEYFgGFiNz
         cFV1w/AiZGZguTCqwVDomg9EUuxkLFfsEkek4XqKvB9C8FjQHqSZKVEiFv1L+OEag6X0
         9B8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xgkgU+XJK79fNtmiiykE65yOYhyetkrTOcQMcl/CZJ8=;
        b=6SkEHo0f2nBDOR87Exr/4hQ6Fd8ExrTvZS53pdvTYJWDgvDfHwwkZyKmeis/bij8Qx
         QLnMbmJVkmvddcRQZfGp2KTT/loZd+GVdelLYAvY2cbMWSR6PgnbFfW+n3JEQdCYyEDH
         OhrdtpXV/IXajWFOririw+eRfEuR0K1fg0kpuVj6MqtyNvN34PxMeqNU+PE+xC1gazwZ
         YPRZpnyfFDgO1Nbsw1YdD36NecYnVDuHhx0CHONLA0WMRs8hjcooTY3suCbehvgngWBZ
         N2m3Fb42OmH1KMn3V3xMPtlxVnyeSIHJYyk6QPv2Ehl+06zW5MbMRy5TM0GSCmNLawev
         tWTA==
X-Gm-Message-State: ANoB5pmC62IUsYN9k8f0qSgnJatzAD5tw1gZJsmvXp9Etj2410McuYGc
        /fNa6OiG6SC8nl8BrCXdqYE=
X-Google-Smtp-Source: AA0mqf5NrXQC9j3yvaQxmK6T+GZXv6adycdupZEpJskbybTG3KPOSJYuASy86evhxQ7UbgdKGMG3IA==
X-Received: by 2002:a17:906:c00c:b0:7ae:e6ac:2427 with SMTP id e12-20020a170906c00c00b007aee6ac2427mr7498440ejz.345.1668455604968;
        Mon, 14 Nov 2022 11:53:24 -0800 (PST)
Received: from skbuf ([188.25.170.202])
        by smtp.gmail.com with ESMTPSA id v17-20020a1709067d9100b0074134543f82sm4614809ejo.90.2022.11.14.11.53.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 11:53:24 -0800 (PST)
Date:   Mon, 14 Nov 2022 21:53:21 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Leo Li <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Rob Herring <robh+dt@kernel.org>,
        Saravana Kannan <saravanak@google.com>,
        Shawn Guo <shawnguo@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH net-next v2 00/11] net: pcs: Add support for devices
 probed in the "usual" manner
Message-ID: <20221114195321.uludij5x747uzcxr@skbuf>
References: <20221103210650.2325784-1-sean.anderson@seco.com>
 <20221109224110.erfaftzja4fybdbc@skbuf>
 <bcb87445-d80d-fea0-82f2-a15b20baaf06@seco.com>
 <20221110152925.3gkkp5opf74oqrxb@skbuf>
 <7b4fb14f-1ca0-e4f8-46ca-3884392627c2@seco.com>
 <20221110160008.6t53ouoxqeu7w7qr@skbuf>
 <ce6d6a26-4867-6385-8c64-0f374d027754@seco.com>
 <20221114172357.hdzua4xo7wixtbgs@skbuf>
 <209a0d25-f109-601f-d6f6-1adc44103aee@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <209a0d25-f109-601f-d6f6-1adc44103aee@seco.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 14, 2022 at 01:08:03PM -0500, Sean Anderson wrote:
> On 11/14/22 12:23, Vladimir Oltean wrote:
> > On Thu, Nov 10, 2022 at 11:56:15AM -0500, Sean Anderson wrote:
> >> these will probably be in device trees for a year before the kernel
> >> starts using them. But once that is done, we are free to require them.
> > 
> > Sorry, you need to propose something that is not "we can break compatibility
> > with today's device trees one year from now".
> 
> But only if the kernel gets updated and not the device tree. When can
> such a situation occur? Are we stuck with this for the next 10 years all
> because someone may have a device tree which they compiled in 2017, and
> *insist* on using the latest kernel with? Is this how you run your
> systems?

I'm a developer (and I work on other platforms than the ones you're
planning to break), so the answer to this question doesn't mean a thing.

> We don't get the device tree from firmware on this platform; usually it
> is bundled with the kernel in a FIT or loaded from the same disk
> partition as the kernel. I can imagine that they might not always be
> updated at exactly the same time, but this is nuts.

What does "this" platform mean exactly? There are many platforms to
which you've added compatible strings to keep things working assuming a
dtb update, many of them very old. And those to which you did are not by
far all that exist. There is no requirement that all platform device
trees are upstreamed to the Linux kernel.

> The original device tree is broken because it doesn't include compatible
> strings for devices on a generic bus. There's no way to fix that other
> than hard-coding the driver. This can be done for some buses, but this
> is an MDIO bus and we already assume devices without compatibles are
> PHYs.

Let's be clear about this. It's "broken" in the sense that you don't like
the way in which it works, not in the sense that it results in a system
that doesn't work. And not having a compatible string is just as broken
as it is for other devices with detectable device IDs, like Ethernet
PHYs in general, PCI devices, etc.

The way in which that works here, specifically, is that a generic PHY driver
is bound to the Lynx PCS devices, driver which does nothing since nobody
calls phy_attach_direct() to it. Then, using fwnode_mdio_find_device(),
you follow the pcsphy-handle and you get a reference to the mdio_device
(parent class of phy_device) object that resulted from the generic PHY
driver probing on the PCS, and you program the PCS to do what you want.

The PHY core does assume that mdio_devices without compatible strings
are phy_devices, but also makes exceptions (and warns about it) - see
commit ae461131960b ("of: of_mdio: Add a whitelist of PHY compatibilities.").
Maybe the reverse exception could also be made, and a warning for that
be added as well.

> In the next version of this series, I will include a compatibility
> function which can bind a driver automatically if one is missing when
> looking up a phy. But I would really like to have an exit strategy.

You'll have to get agreement from higher level maintainers than me that
the strategy "wait one year, break old device trees" is okay. Generally
we wouldn't have answers to this kind of questions that depend on whom
you ask. Otherwise.. we would all know whom to ask and whom not to ;)

Sadly I haven't found anything "official" in either Documentation/devicetree/usage-model.rst
or Documentation/process/submitting-patches.rst. Maybe I missed it?

I've added Arnd Bergmann for an ack, and also Marc Zyngier, not because
of any particular connection to what's being changed here, but because
I happen to know that he might have strong opinions on the topic :)

Full context here:
https://patchwork.kernel.org/project/netdevbpf/cover/20221103210650.2325784-1-sean.anderson@seco.com/

If I'm the only one opposing this, I guess I'll look elsewhere.
