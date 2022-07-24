Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF52357F635
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 19:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbiGXRj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 13:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiGXRj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 13:39:26 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D009FE00A;
        Sun, 24 Jul 2022 10:39:23 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id sz17so16692130ejc.9;
        Sun, 24 Jul 2022 10:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=SmBrzHw52bwH7Xn41Pzy7T17rp33HWokWawPue7k8iA=;
        b=LNq9KSvvzv7j/HJKV866FauvJfpMaWj4iIoojhYCd7zy8/fAlfdhqDLztzmMAYneot
         gdKldSWu0TkLVoCamWoFDnwI5Zz5JGTwMXjtTbxFkTdH3+391C4MOS0Ow1atKSS9bPug
         Zt/3pFwjHtp9P3wj1DhYAsT4uhe3QO+3WU6Rd2w0aLZ+7M/45VZngYlw7Twpws0miflh
         MDtaKwdHba838HLOL0ByV7Xk9LHJsh6u1VuTV2FSR3ilv1k3tgwBH/Pp4Nsk5lIY9Dlg
         nmU3Ceyn3ovTxXZENH+htyqqddX1rpxXaKECZo10hcE7UXVxaoHecoQPiW2f2EEFncIB
         IaVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=SmBrzHw52bwH7Xn41Pzy7T17rp33HWokWawPue7k8iA=;
        b=RIlNXCLW1HlCNbe4oW+vot+q2/jwqPyW/gU5drGmypFz+bjsez8WjzlgBnp/P6CFen
         bXYehE5odI9YqZ0dLxEmZx6ZCdb9V0v1tGi2mIputfJTOuTk0nYThL/SqgipN6x5IlXE
         yqoNm/Ee6amR2gcjYw3MXJB30IjcdivmTnEDDEmSSnrbEm44i0v3fqPIGnFWRGD4osH5
         9ufKXm3kceHuy9urETSouXC7A4OFCgD4/hjPY8n0Lg0pZ+AUDK11BUMcmsez188F2aLX
         EETfv1ZTL/bZZfKFdohEOwiMNhlfXi/QnFvg5apuhKJHE7eLB6Gn6tenVYtLT0ANENb0
         yJFA==
X-Gm-Message-State: AJIora/qojy39QHGkdM96wyT3W+rbGGKylwARtV1vXbN+xki5Y41en9u
        IZQT3FkKbFoP3c+gC1qKK7A=
X-Google-Smtp-Source: AGRyM1vTTCYwH5W6U6Fg8IDwjOqz8S2dcUwFkhAR9C2Db19F6GyrIoCWMXAbpPi4n1Jq9tEf0F5ulQ==
X-Received: by 2002:a17:906:7310:b0:72f:cad0:d436 with SMTP id di16-20020a170906731000b0072fcad0d436mr4380014ejc.751.1658684362088;
        Sun, 24 Jul 2022 10:39:22 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id g6-20020a17090669c600b0072a815f569bsm4397182ejs.185.2022.07.24.10.39.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jul 2022 10:39:19 -0700 (PDT)
Date:   Sun, 24 Jul 2022 20:39:16 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin __ipraga <alsi@bang-olufsen.dk>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH net-next 3/6] net: dsa: add support for retrieving the
 interface mode
Message-ID: <20220724173916.lebsvaqveqwus4xj@skbuf>
References: <YtpfmF37FmfY6BV5@shell.armlinux.org.uk>
 <20220722105238.qhfq5myqa4ixkvy4@skbuf>
 <YtqNkSDLRDtuooy/@shell.armlinux.org.uk>
 <20220722124629.7y3p7nt6jmm5hecq@skbuf>
 <YtqjFKUTsH4CK0L+@shell.armlinux.org.uk>
 <20220722165600.lldukpdflv7cjp4j@skbuf>
 <YtsUhdg3a2rT3NJC@shell.armlinux.org.uk>
 <YtsUhdg3a2rT3NJC@shell.armlinux.org.uk>
 <20220722223932.poxim3sxz62lhcuf@skbuf>
 <20220723192655.46de7cae@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220723192655.46de7cae@thinkpad>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 23, 2022 at 07:26:55PM +0200, Marek Behún wrote:
> Does Lynx PCS support 1000base-x with AN?

Yes, that would be the intention.

> Because if so, it may be possible to somehow hack working AN for
> 2500base-x, as I managed it for 88E6393X in the commit I mentioned (by
> configuring 1000base-x and then hacking the PHY speed to 2.5x).

I would need to try and see. For Lynx, to dynamically change from
1000base-x to 2500base-x essentially means to move the SERDES lane from
a PLL that can provide the 1.25 GHz required for 1000base-x to a PLL
that can provide the 3.125 GHz required for 2500base-x. The procedure
itself doesn't involve resetting the PCS, but to be honest with you,
I don't know whether the state of the PCS registers is going to be
preserved across the PLL change. Maybe it isn't, but this is entirely
masked out by the phylink major reconfig process, I don't know.

The alternative to dynamic reconfiguration is to program some bits that
instruct the SoC what to do on power-on reset, and these bits include
the initial SERDES protocols and PLL assignments too. I only tried to
experiment with in-band autoneg in this mode (with the lane being
configured for 2.5G out of reset, rather than dynamically switching it
to 2.5G).

> Anyway, I am now looking at the standards, and it seems that all the X
> and R have K variant: 1000base-kx, 2500base-kx, 5gbase-kr and
> 10gbase-kr. These modes have mandatory clause 73 autonegotiation.

The X in BASE-X stands for 8b/10b coding, the R stands for 64b/66b coding.
Whereas the K stands for bacKplane, i.e. the medium (compare this with
the T in BASE-T, for twisted pair copper cable). Or with 1000BASE-SX and
1000BASE-LX, the S stands for Short wavelength laser and the L for Long
wavelength.

What I'm trying to say, the 'X' in BASE-X doesn't stand for anything
having to do with fiber, I guess 1000BASE-X is just a generic name for
the coding scheme (PCS level) rather than something about the medium
(PMD level). The terminology is pretty much a mess.

> So either we need to add these as different modes of the
> phy_interface_t type, or we need to differentiate whether clause 37 or
> clause 73 AN should be used by another property.
> 
> But since 1000base-x supports clause 37 and 1000base-kx clause 73, the
> one property that we have, managed="in-band-status" is not enough, if
> we keep calling both modes '1000base-x'.
> 
> So maybe we really need to add K variants as separate
> PHY_INTERFACE_MODED_ constants. That way we can keep assuming clause 37
> for 2500base-x, and try to implement it for as much drivers as
> possible, by hacking it up...

Well, for good or bad, 10GBase-KR does have its own phy-mode string,
and Sean Anderson is sending a patch to add 1000base-KX now too.
https://patchwork.kernel.org/project/netdevbpf/patch/20220719235002.1944800-3-sean.anderson@seco.com/
(I still don't understand what that has to do with the topic of his
series, but anyway)

More at the end.

> 
> And I still don't understand this clause 73 AN at all. For example, if
> one PHY supports only up to 2.5g speeds, will it complete AN with
> another PHY that supports up to 10g speeds, if the second PHY will
> (maybe?) try at higher frequency?

Define what you mean by "one PHY supports only up to 2.5G speeds".
My copy of IEEE 802.3-2018 doesn't list in Table 73–4—Technology Ability
Field encoding any signaling mode that is capable of 2.5G, but rather
1000BASE-KX, 10GBASE-KR, 25GBASE-KR and so on. So you'd have to express
your question in terms of bits that are actually advertised through the
Technology Ability field.

Then, clause 73 AN, very much like the clause 28/40 AN of BASE-T (to
which it is most directly comparable) has a priority resolution function,
meaning that if 2 link partners advertise support for multiple
technologies, Table 73–5—Priority Resolution will decide which one of
the commonly advertised technologies gets used.

Side note: contrast this with flow control, which annoyingly was
designed by IEEE to not have a priority resolution, in other words you
don't get a graceful falloff of the resolved pause modes depending on
what you and the link partner advertised, instead you need to
preconfigure both ends if you want to achieve a particular result;
this is IMO as useless as not having AN at all.

There is of course no guarantee that two backplane link partners will
have any technology ability in common, for example one may advertise
only 1000Base-KX and the other only 10GBase-KR. In that case, autoneg
will complete, but the link will simply not come up.

The clause 73 autoneg signaling takes place using a predetermined, low-speed
encoding. The medium transitions to the highest negotiated technology,
and performs clause 74 link training on that medium, only after both
ends agree that clause 73 autoneg has completed. This kind of implies
that they will agree on the frequency being used for the data traffic.

If you're asking whether 2 backplane devices will advertise 10GBase-KR
but one of them supports a data rate of only up to 2.5Gbps over that 10G
link, I think this is vendor-dependent and IEEE doesn't say anything
about it. For example this is where rate adaptation could come into
play, either through flow control, or there could be an extension to
clause 73 similar to what Cisco did with USXGMII, where the lane
operates at 10GBaud but via symbol replication your data rate can
actually be only 2.5Gbps. I'm not aware of real life applications of
rate adaptation over backplane links.


I hinted earlier that clause 73 autoneg is most directly comparable to
BASE-T autoneg (these 2 are even situated at different layers if you
look at the IEEE OSI stack pictures, compared to where clause 37 AN is).
The problem is that the Linux kernel support for new physical technologies
grew organically, and we don't have a structure in place that scales
naturally to all the places in which these technologies may appear in
the stack. For example we have the phy-mode, and this represents the

...

/goes searching for the documentation, I don't want to be making this up/

...

  phy-connection-type:
    description:
      Specifies interface type between the Ethernet device and a physical
      layer (PHY) device.

There you go, pretty vague. What's the Ethernet device, and what's the
PHY device?

For example SGMII connects a MAC to a PHY, but to speak SGMII to reach
to your PHY, you need another PHY that does the parallel GMII to serial
translation for you. So to say that the phy-mode is SGMII, you need to
ignore that the MAC has a PHY too.

10GBase-KR is similar in a way, it can be placed at multiple layers, and
traditionally, where you put it makes a difference to how we describe it
in Linux.

Maybe you have a 10GBase-T PHY chip with a backplane host-side PHY, it
supports clause 73 declaring the 10GBase-KR technology, then it supports
clause 74 link training, the whole shebang. These things exist. How would
you describe this? You'd say the phy-mode is "10gbase-kr", according to
precedent. Would that be the best thing to do, in the spirit of clause 73?
I don't think it would. Essentially what would need to happen as a
consequence of this description is that your PCS would essentially
populate its Technology Ability with a single bit, corresponding to what
you put in phy-mode, because that's how we shoehorned this. Then we'd
say what, that managed = "in-band-status" decides whether to bypass
clause 73 AN or not? I don't think so.

Truth is, a 10G-KR "PCS" (what we mean when we say a PHY integrated into a MAC)
is much more similar to a dedicated 10G-KR PHY, to the point that it's
indistinguishable (what Linux thinks of a phy_device is actually 2 PHYs
back to back, one for the host side and one for the medium side), and it
*needs* to be treated by Linux in the same way regardless of where it's
placed. You *need* to be able to control the backplane PCS' advertisement,
whether to use FEC or not, regardless if it's your medium facing device,
or an in-between device.

The discussion is much, much bigger than this, but in summary, I think
it would be quite short-sighted to expand managed = "in-band-status" for
anything related to clause 73, or for much more than what it means right
now (the problem is, what _does_ it mean and what _doesn't_ it?).

This, plus I think development needs to be driven by someone with real
world needs and a sense for what's practical. I am quite well outside of
the sphere of 10-gig-and-higher networking, I'm just looking from the
peanut gallery, so that won't be me.
