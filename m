Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55FC739C821
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 14:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbhFEM3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 08:29:45 -0400
Received: from mail-ej1-f54.google.com ([209.85.218.54]:38573 "EHLO
        mail-ej1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbhFEM3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 08:29:45 -0400
Received: by mail-ej1-f54.google.com with SMTP id og14so13323441ejc.5;
        Sat, 05 Jun 2021 05:27:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=yxAwoHb9R5ZBIZwDJsuyJCDfJDe34rxlobdXTwB9+cg=;
        b=EuPUMxteWITDkddFMz6iypixhTrnTgPv+5col3X6LpXxQyHv4sxTxI0+Gku7F3ADRg
         rS04VRxy3/Wt+fHwvUGeoU6AkjqAiJ01Rx/20pEamrxxoLemnL4baumDdTjVguFWJpEx
         EkWa78i8YcwD/Ip77FmkdEgz3s20Ezre0P2TJ8wGWKkitWYx9yHDqSnYurs7ecvmYF2j
         9JIiWuxdM7w0umqmbFm0SIcpG6qzuYmdq+p3/ODyZpyZANci9fifPEb9ovUb+Dkfr7GT
         KMsEm1s9tF6whb4U8HYHEGMW9bdHbkOnEwEyH+uyIKrrxtkKlAIN1tSFAlbe42y61DQ6
         5gEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=yxAwoHb9R5ZBIZwDJsuyJCDfJDe34rxlobdXTwB9+cg=;
        b=EJ0NDHNAmmw0phCGqiuIp6vWHYnO2rzUzjyWp0UYMcMlNMssk0fmRFbTdYaXINlAJc
         WhkZ8zaegadi2E+Fe8/hd2uhbbkMaR+9FtEsuYyCCf+Vh96KOnrZhkmkEX13VmcexAMF
         Pb9xwaHNUiPp3pPfCFDcfm5Sq7op/fF5VbYk3aVyVolClClJ4pzdf4qrjimh6ICkb/HN
         o+WwUOM+8eZQXbKrDB+vnzSSmT6tPznjYB5YZ0buGuaBSg5X/8b2f1j82vHs+BX3+S1H
         s1FyJPBQcMznCRzk5+JEnaztcQmL0auGvxXSVknG1aoek8uMhu1peE12Lhveav1rDogx
         OwHA==
X-Gm-Message-State: AOAM532omfX2RBE5S1p3flL34G9KGeYyyLT05Z4BwuOgHqQaNpfQdoZ9
        3KV6s73T17tq2k9ukraq7rDNb9Z3FQQ=
X-Google-Smtp-Source: ABdhPJxA3NxXaF5z1JamjWtO8AvUfHjVciOQ+kfNmGvIVQZkQRE8eAwBjoxUcpxeHWC7+VXYYGbf+w==
X-Received: by 2002:a17:907:10cc:: with SMTP id rv12mr8894741ejb.533.1622896001179;
        Sat, 05 Jun 2021 05:26:41 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id v1sm4079274ejg.22.2021.06.05.05.26.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Jun 2021 05:26:40 -0700 (PDT)
Date:   Sat, 5 Jun 2021 15:26:39 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Igal Liberman <Igal.Liberman@freescale.com>,
        Shruti Kanetkar <Shruti@freescale.com>,
        Emil Medve <Emilian.Medve@freescale.com>,
        Scott Wood <oss@buserror.net>,
        Rob Herring <robh+dt@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Camelia Alexandra Groza (OSS)" <camelia.groza@oss.nxp.com>
Subject: Re: Unsupported phy-connection-type sgmii-2500 in
 arch/powerpc/boot/dts/fsl/t1023rdb.dts
Message-ID: <20210605122639.4lpox5bfppoyynl3@skbuf>
References: <20210603143453.if7hgifupx5k433b@pali>
 <YLjxX/XPDoRRIvYf@lunn.ch>
 <20210603194853.ngz4jdso3kfncnj4@pali>
 <AM6PR04MB3976B62084EC462BA02F0C4CEC3B9@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <20210604192732.GW30436@shell.armlinux.org.uk>
 <AM6PR04MB39768A569CE3CC4EC61A8769EC3B9@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <YLqLzOltcb6jan+B@lunn.ch>
 <AM6PR04MB39760B986E86BA9169DEECC5EC3B9@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <20210604233455.fwcu2chlsed2gwmu@pali>
 <20210605003306.GY30436@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210605003306.GY30436@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 05, 2021 at 01:33:07AM +0100, Russell King (Oracle) wrote:
> On Sat, Jun 05, 2021 at 01:34:55AM +0200, Pali Rohár wrote:
> > But as this is really confusing what each mode means for Linux, I would
> > suggest that documentation for these modes in ethernet-controller.yaml
> > file (or in any other location) could be extended. I see that it is
> > really hard to find exact information what these modes mean and what is
> > their meaning in DTS / kernel.
>
> We have been adding documentation to:
>
> Documentation/networking/phy.rst
>
> for each of the modes that have had issues. The 2500base-X entry
> hasn't been updated yet, as the question whether it can have in-band
> signaling is unclear (there is no well defined standard for this.)
>
> Some vendors state that there is no in-band signalling in 2500base-X.
> Others (e.g. Xilinx) make it clear that it is optional. Others don't
> say either way, and when testing hardware, it appears to be functional.
>
> So, coming up with a clear definition for this, when we have no real
> method in the DT file to say "definitely do not use in-band" is a tad
> difficult.

If you use phylink, doesn't the lack of
	managed = "in-band-status";
mean "definitely do not use in-band"?

> It started out as described - literally, 1000base-X multiplied by 2.5x.
> There are setups where that is known to work - namely GPON SFPs that
> support 2500base-X. What that means is that we know the GPON SFP
> module negotiates in-band AN with 2500base-X. However, we don't know
> whether the module will work if we disable in-band AN.

Pardon my ignorance, but what is inside a GPON ONT module? Just a laser
and some amplifiers? So it would still be the MAC PCS negotiating flow
control with the remote link partner? That's a different use case from a
PHY transmitting the negotiated link modes to the MAC.

> There is hardware out there as well which allows one to decide whether
> to use in-band AN with 2500base-X or not. Xilinx is one such vendor
> who explicitly documents this. Marvell on the other hand do not
> prohibit in-band AN with mvneta, neither to they explicitly state it
> is permitted. In at least one of their PHY documents, they suggest it
> isn't supported if the MAC side is operating in 2500base-X.
>
> Others (NXP) take the position that in-band AN is not supported at
> 2500base-X speeds. I think a few months ago, Vladimir persuaded me
> that we should disable in-band AN for 2500base-X - I had forgotten
> about the Xilinx documentation I had which shows that it's optional.
> (Practically, it's optional in hardware with 1000base-X too, but then
> it's not actually conforming with 802.3's definition of 1000base-X.)

I don't think it is me who persuaded you, but rather the reality exposed
by Marek Behun that the Marvell switches and PHYs don't support clause
37 in-band AN either, at least when connected to one another, just the
mvneta appears to do something with the GPON modules:

https://lore.kernel.org/netdev/20210113011823.3e407b31@kernel.org/

I tend to agree, though. We should prevent in-band AN from being
requested on implementations where we know it will not work. That
includes any NXP products. In the case of DPAA1, this uses the same PCS
block as DPAA2, ENETC, Felix and Seville, so if it were to use phylink
and the common drivers/net/pcs/pcs-lynx.c driver, then the comment near
the lynx_pcs_link_up_2500basex() function would equally apply to it too
(I hope this answers Pali's original question).

> The result is, essentially, a total mess. 2500base-X is not a standards
> defined thing, so different vendors have gone off and done different
> things.

Correct, I can not find any document mentioning what 2500base-x is either,
while I can find documents mentioning SGMII at 2500Mbps.
https://patents.google.com/patent/US7356047B1/en

This Cisco patent does say a few things, like the fact that the link for
10/100/1000/2500 SGMII should operate at 3.125 Gbaud, and there should
be a rate adaptation unit separate from the PCS block, which should
split a frame into 2 segments, and say for 1Gbps, the first segment
should have its octets repeated twice, and the second segment should
have its octets repeated 3 times.

This patent also does _not_ say how the in-band autonegotiation code
word should be adapted to switch between 10/100/1000/2500. Which makes
the whole patent kind of useless as the basis for a standard for real
life products.

NXP does _not_ follow that patent (we cannot perform symbol replication
in that way, and in fact I would be surprised if anyone does, given the
lack of a way to negotiate between them), and with the limited knowledge
I currently have, that is the only thing I would call "SGMII-2500".
So Cisco "SGMII-2500" does in theory exist, but in practice it is a bit
mythical given what is currently public knowledge.

By the "genus proximum et differentia specifica" criterion, what we have
according to Linux terminology is 2500base-x (whatever that might be, we
at least know the baud rate and the coding scheme) without in-band AN.
We don't seem to have any characteristic that would make the "genus
proximum" be Cisco SGMII (i.e. we can't operate at any other speeds via
symbol replication). But that is ok given the actual use, for example
we achieve the lower speeds using PAUSE frames sent by the PHY.

> Sometimes it's amazing that you can connect two devices together and
> they will actually talk to each other!

This is not so surprising to me, if you consider the fact that these
devices were built to common sense specs communicated over email between
engineers at different companies. There aren't really that many
companies building these things. The fact that the standards bodies
haven't kept up and unified the implementations is a different story.

I can agree that the chosen name is confusing. What it is is an overclocked
serial GMII (in the sense that it is intended as a MAC-to-PHY link),
with no intended relation to Cisco SGMII. Being intended as a MAC-to-PHY
link, clause 37 AN does not make sense because flow control is 100%
managed by the PHY (negotiated over the copper side, as well as used for
rate adaptation). So there _is_ some merit in calling it something with
"serial" and "GMII" in the name, it is just describing what it is.
Using this interface type over a PHY-less fiber SFP+ module (therefore
using it to its BASE-X name) works by virtue of the fact that the
signaling/coding is compatible, but it wasn't intended that way,
otherwise it would have had support for clause 37 flow control resolution.
