Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 742F057E9EA
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 00:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236851AbiGVWlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 18:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237093AbiGVWlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 18:41:02 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76AFAA8952;
        Fri, 22 Jul 2022 15:39:38 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id ss3so10787728ejc.11;
        Fri, 22 Jul 2022 15:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SCIfLHRilSVARYAnKntWH0eWDAY/YIifl2pwBJ48Xcg=;
        b=pNlk5uj1juo5th8sz1EcjU7HHLiktAi8JL1ltlInGl+uGwsu+ojWI7HxdEboJt87hM
         B9sA417XmtObSJXVCkMB91laT1NrSutSJBgcSfso3MvT9dvtII937mzq2BN+Op45CgBD
         M0CSZfvKLwjg7m5t4CCtsz+yDGpKP265U1chM/n5VGc8L47NVTNWxZh1tmU5uEAy2GVq
         w8klKSV+pKs5L3aXV+Lqf/xcmbaVDIK868eDd15UEBCG441kwEST63F/vPMBRjoQvWR0
         DPjPTQdOVuU6ll8zMmCWypHik1EwKJsDu2Su9Evh9+wMtQ9YlvwX/SjKiksrOUToZne9
         bUhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SCIfLHRilSVARYAnKntWH0eWDAY/YIifl2pwBJ48Xcg=;
        b=B31Uux7SrxVKpHc+IBebU0RUe/qXDUdgYDAtWjRakVbBlVcGcOzI8ZCPutG/No8Gxt
         Hh6uY4slQuSrGWyfLMQTgXyrLXUHLCbp5LPuVDY8Xb2hDZyeguu+hV/MYpDWdlm6q2e3
         rev2VbfHUe0Ox/VfZxAe2bkVMtRdI0618zJZz2d8SzhYhf+JjkWUQP4e3qUpTk2LrNO4
         nPBjtHy5AaSP2KPK2QRvXEYqYFBovUHKvuLWRwglaKM4wpfB0moLR+dYymJvbBlFYIAH
         tLIiuEAZi+uIAHfXVfe22o6Vx/FdrcJfJnA4uAe+DaS4LcjCZ9E6dCKMQtPv9yonX6OY
         JOCA==
X-Gm-Message-State: AJIora+O4BZFPsbp3Nv2UjKiA/GfDOVqMEhfm9ocGV4T3gKfpJX+Enj0
        t1H+KjP6VNMWTUyPjFLNLVg=
X-Google-Smtp-Source: AGRyM1teCUXOn6Gq6vH6tia+wR4Z3XGKf8xLDBoY6esTK8NiEwU20u/c7G0/XowCcVoGCw8LNFtTTA==
X-Received: by 2002:a17:907:2ccc:b0:72b:6907:fce6 with SMTP id hg12-20020a1709072ccc00b0072b6907fce6mr1590457ejc.115.1658529576656;
        Fri, 22 Jul 2022 15:39:36 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id nc19-20020a1709071c1300b00722d5b26ecesm2462199ejc.205.2022.07.22.15.39.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 15:39:36 -0700 (PDT)
Date:   Sat, 23 Jul 2022 01:39:32 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
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
Message-ID: <20220722223932.poxim3sxz62lhcuf@skbuf>
References: <YtnBmFm8Jhokgp7Q@shell.armlinux.org.uk>
 <20220721213645.57ne2jf7f6try4ec@skbuf>
 <YtpfmF37FmfY6BV5@shell.armlinux.org.uk>
 <20220722105238.qhfq5myqa4ixkvy4@skbuf>
 <YtqNkSDLRDtuooy/@shell.armlinux.org.uk>
 <20220722124629.7y3p7nt6jmm5hecq@skbuf>
 <YtqjFKUTsH4CK0L+@shell.armlinux.org.uk>
 <20220722165600.lldukpdflv7cjp4j@skbuf>
 <YtsUhdg3a2rT3NJC@shell.armlinux.org.uk>
 <YtsUhdg3a2rT3NJC@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtsUhdg3a2rT3NJC@shell.armlinux.org.uk>
 <YtsUhdg3a2rT3NJC@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 22, 2022 at 10:20:05PM +0100, Russell King (Oracle) wrote:
> > > > What is hard for me to comprehend is how we ever came to conclude that
> > > > for SERDES protocols where clause 37 is possible (2500base-x should be
> > > > part of this group), managed = "in-band-status" does not imply in-band
> > > > autoneg, considering the mvneta precedent.
> > > 
> > > That is a recent addition, since the argument was made that when using
> > > a 1000base-X fibre transceiver, using ethtool to disable autoneg is a
> > > reasonable thing to do - and something that was supported with
> > > mvneta_ethtool_set_link_ksettings() as it stands at the point in the
> > > commit above.
> > 
> > I'm sorry, I don't understand. What is the recent addition, and recent
> > relative to what? The 2500base-x link mode? Ok, but this is only
> > tangentially related to the point overall, more below.
> 
> I'm talking about how we handle 1000base-X autoneg - specifically this
> commit:
> 
> 92817dad7dcb net: phylink: Support disabling autonegotiation for PCS
> 
> where we can be in 1000base-X with managed = "in-band-status" but we
> have autoneg disabled. I thought that is what you were referring to.

So the correction you're persistently trying to make is:
managed = "in-band-status" does *not* necessarily imply in-band autoneg
being enabled, because the user can still run "ethtool -s eth0 autoneg off"
?

Yeah, ok, I wasn't trying to build any argument upon ethtool being able
to toggle autoneg. You can disable it, but it should still come up as
enabled. What I was saying was as a (possibly too generic) response to
this:

| | The way I understand what you're saying is that there is no guarantee
| | that the DSA master and CPU port will agree whether to use in-band
| | autoneg or not here (and implicitly, there is no guarantee that this
| | link will work):
| |
| |       &eth0 {
| |               phy-mode = "2500base-x";
| |               managed = "in-band-status";
| |       };
| |
| |       &switch_cpu_port {
| |               ethernet = <&eth0>;
| |               phy-mode = "2500base-x";
| |               managed = "in-band-status";
| |       };
| 
| Today, there is no guarantee - because it depends on how people have
| chosen to implement 2500base-X, and whether the hardware requires the
| use of in-band AN or prohibits it. This is what happens when stuff
| isn't standardised - one ends up with differing implementations doing
| different things, and this has happened not _only_ at hardware level
| but also software level as well.

If there is no guarantee that the above will (at least try) to use in-band
autoneg, it means that there is someone who decided, when he coded up
the driver, that managed = "in-band-status" doesn't imply using in-band
autoneg. That's what I was complaining about: I don't understand how we
got here. In turn, this came from an observation about the inband/10gbase-r
not having any actual in-band autoneg (more about this at the very end).

> As for 2500base-X, I had been raising the issue of AN in the past, for
> example (have I said it's really difficult to find old emails even with
> google?):
> 
> https://lwn.net/ml/netdev/20200618140623.GC1551@shell.armlinux.org.uk/

Why is this old conversation relevant? You said you suspect the hardware
is capable of AN at 2500base-x. It isn't - I had tested that on LS1028A
when I wrote the comment, and the check - all part of the code that was
being moved.

> and eventually I stopped caring about it, as it became pointless to
> raise it anymore when we had an established mixture of behaviours. This
> is why we have ended up with PCS drivers configuring for no AN for a
> firmware description of:
> 
> 	managed = "in-band-status";
> 	phy-mode = "2500base-x";

Sorry, I don't get why?

> and hence now have unclean semantics for this - some such as mvneta
> and mvpp2 will have AN enabled. Others such as pcs-lynx will not.

You mean in general, or with the firmware description you posted above?
Because the Lynx PCS does the best it can (considering it does this from
a function that returns void) to complain that you shouldn't put
MLO_AN_INBAND for 2500base-x.

static void lynx_pcs_link_up_2500basex(struct mdio_device *pcs,
				       unsigned int mode,
				       int speed, int duplex)
{
	u16 if_mode = 0;

	if (mode == MLO_AN_INBAND) {
		dev_err(&pcs->dev, "AN not supported for 2500BaseX\n");
		return;
	}

I noticed just earlier today that I made a blunder while upstreaming some
riser cards for some LS1028A-QDS development boards, and I did just that
(left 2500base-x with in-band-status). But the system just errors out.
I need to boot a board and fix that up. They're just NXP development
systems so not a big issue. Otherwise I'm not aware of what you're
talking about.

> However, both will request link status from the PCS side and use that
> to determine whether the link is up, and use the parameters that the
> PCS code returns for the link. Since 2500base-X can only operate at
> 2.5G, PCS code always reports SPEED_2500, and as half duplex is
> virtually never supported above 1G, DUPLEX_FULL.

If you're saying this just because Lynx implements pcs_get_state for
2500base-x, it's extremely likely that this simply originates from
vsc9959_pcs_link_state_2500basex(), which was deleted in ocelot in
commit 588d05504d2d ("net: dsa: ocelot: use the Lynx PCS helpers in
Felix and Seville"), and it was always dead code. It wasn't the only
dead code, remember commit b4c2354537b4 ("net: dsa: felix: delete
.phylink_mac_an_restart code").

Since the Lynx PCS prints error messages in inband/2500base-x mode,
and so did Felix/Ocelot before the code became common, I'm pretty sure
no one relies on this mode.

> > > > And why would we essentially redefine its meaning by stating that no,
> > > > it is only about the status, not about the autoneg, even though the
> > > > status comes from the autoneg for these protocols.
> > > 
> > > I'm not sure I understand what you're getting at there.
> > 
> > Sorry if I haven't made my point clear.
> > 
> > My point is that drivers may have more restrictive interpretations of
> > managed = "in-band-status", and the current logic of automatically
> > create a fixed-link for DSA's CPU ports is going to cause problems when
> > matched up with a DSA master that expects in-band autoneg for whatever
> > SERDES protocol.
> > 
> > What I'd like to happen as a result is that no DSA driver except Marvell
> > opts into this by default, and no driver opts into it without its maintainer
> > understanding the implications. Otherwise we're going to normalize the
> > expectation that a managed = "in-band-status" DSA master should be able
> > to interoperate with a fixed-link CPU port, but during this discussion
> > there was no argument being brought that a strict interpretation of
> > "in-band-status" as "enable autoneg" is incorrect in any way.
> 
> I still don't understand your point - because you seem to be conflating
> two different things (at least as I understand it.)
> 
> We have this:
> 
> 		port@N {
> 			reg = <N>;
> 			label = "cpu";
> 			ethernet = <&ethX>;
> 		};
> 
> This specifies that the port operates at whatever interface mode and
> settings gives the maximum speed. There is no mention of a "managed"
> property, and therefore (Andrew, correct me if I'm wrong) in-band
> negotiation is not expected to be used.
> 
> The configuration of the ethX parameters on the other end of the link
> are up to the system integrator to get right, and the actual behaviour
> would depend on the ethernet driver. As I've said in previous emails,
> there is such a thing as "AN bypass" that can be implemented,

Not everyone has AN bypass, try to assume that no one except mvneta does.

> and it can default to be enabled, and drivers can ignore that such a
> bit even exists. So, it's possible that even with "managed" set to
> "in-band-status" in DT, a link to such a DSA switch will still come up
> even though we've requested in DT for AN to be used.
> 
> If an ethernet driver is implemented to strictly require in-band AN in
> this case, then the link won't come up, and the system integrator would
> have to debug the problem.
> 
> I think this is actually true on Clearfog - if one specifies the CPU
> port as I have above, and requests in-band on the host ethernet, then
> the link doesn't come up, because mvneta turns off AN bypass.

So what am I conflating in this case?

> > Thanks for this explanation, if nothing else, it seems to support the
> > way in which I was interpreting managed = "in-band-status" to mean
> > "enable in-band autoneg", but to be clear, I wasn't debating something
> > about the way in which mvneta was doing things. But rather, I was
> > debating why would *other* drivers do things differently such as to come
> > to expect that a fixed-link master + an in-band-status CPU port, or the
> > other way around, may be compatible with each other.
> 
> Please note that phylink makes a DT specification including both a
> fixed-link descriptor and a managed in-band-status property illegal
> because these are two different modes of operating the link, and they
> conflict with each other.

Ok, thank you for this information which I already knew, what is the context?

> The fact that the of_fixed_link_whateveritwas() function (sorry I can't
> remember the name) returns true for both indicating that they're both

of_phy_is_fixed_link()

> fixed-link is a historic artifact that has not been changed. As the
> fixed-PHY code supporting that way was dropped, I suppose that should
> have been cleaned up at some point, but I never got around to it
> (remember, development in this space is a very slow process.) There
> were always more pressing matters to be dealt with.
> 
> Maybe we should now make of_fixed_link_whateveritwas() no longer return
> true, and introduce of_managed_in_band() or something like that which
> drivers can test that separately. I'm not sure it's worth the driver
> churn to make such a change, I'm not sure what the benefit would be.

If we were to split of_phy_is_fixed_link() into of_phy_is_fixed_link()
and of_managed_in_band(), we'd effectively need to replace every
instance of "if (of_phy_is_fixed_link(np))" with
"if (of_phy_is_fixed_link(dp) || of_managed_in_band(np))" unless
instructed otherwise by maintainers. And maintainers will think:
"whoa, I had no idea...". Indeed, there are better uses of time.

> > Then I studied MVNETA_GMAC_AUTONEG_CONFIG and I noticed that the bit
> > you're talking about, MVNETA_GMAC_AN_BYPASS_ENABLE (bit 3) is indeed set
> > by default (the driver doesn't set it).
> 
> Correct - because of history, and changing it could break setups that
> have been working since before DT. The driver has never changed the
> bypass bit, so playing with that when phylink was introduced risked
> regressions.

No, as mentioned, it's good that it exists, just please don't come to
assume that everyone has something like it, and use it as a justification
that hey, I can create a fixed-link willy-nilly, and that will disable
in-band AN on the switch side, and then the system integrator will come
to debug, he'll see what happened there and he'll enable the AN bypass
bit in his other driver. That's not what's going to happen.

> > So what this is telling me is that mvneta has some built-in resilience
> > to in-band autoneg mismatches, via MVNETA_GMAC_AN_BYPASS_ENABLE. But that
> > (a) doesn't make it valid to mix and match a fixed-link with a managed =
> >     "in-band-status" mode
> > (b) doesn't mean it's unspecified whether managed = "in-band-status"
> >     should dictate whether to enable in-band autoneg or not
> > (c) doesn't mean that other devices/drivers support "AN bypass" to save
> >     the day and make an invalid DT description appear to work just fine
> > 
> > This further supports my idea that we should make a better attempt of
> > matching the DSA master's mode with the node we're faking in DSA for
> > phylink. For Marvell hardware you or Andrew are surely more knowledgeable
> > to be able to say whether that's needed right now or not. But in the
> > general case please don't push this to everyone, it just muddies the
> > waters.
> 
> I really don't get this.
> 
> For a mv88e6xxx port which supports 1000base-X, with these patches
> applied, then these are all effectively equivalent:
> 
> 		port@N {
> 			reg = <N>;
> 			label = "cpu";
> 			ethernet = <&ethX>;
> 		};
> 
> 		port@N {
> 			reg = <N>;
> 			label = "cpu";
> 			ethernet = <&ethX>;
> 			phy-mode = "1000base-x";
> 		};
> 
> 		port@N {
> 			reg = <N>;
> 			label = "cpu";
> 			ethernet = <&ethX>;
> 			fixed-link {
> 				speed = <1000>;
> 				full-duplex;
> 			};
> 		};
> 
> 		port@N {
> 			reg = <N>;
> 			label = "cpu";
> 			ethernet = <&ethX>;
> 			phy-mode = "1000base-x";
> 			fixed-link {
> 				speed = <1000>;
> 				full-duplex;
> 			};
> 		};
> 
> and all _should_ lead to inband AN being disabled.
> 
> That is my understanding of Andrew's statements on the defaulting
> parameters for both the inter-switch and CPU ports. (Maybe Andrew can
> clarify whether this is correct or not.)
> 
> However, this would not equivalent to any of the above:
> 
> 		port@N {
> 			reg = <N>;
> 			label = "cpu";
> 			ethernet = <&ethX>;
> 			managed = "in-band-status";
> 		};
> 
> The reason this is not equivalent is - as you've recently spotted -
> of_phy_is_fixed_link() will return true, and therefore phylink gets
> passed the above node to work with - and we do not generate a swnode
> fixed-link stanza for it. The behaviour in this case is completely
> unaffected by these patches.

Thank you for this explanation, it is correct and I don't disagree with it.

> If a DSA driver defaults to AN enabled on the DSA/CPU ports, and makes
> use of the defaulting firmware description, then this will break with
> these patches, since we setup a fixed-link specifier that states that
> no AN should be used.

Bingo, you hit the nail on the head. I was saying that we don't know
whether in-band should be used or not. We could take as a vague hint the
managed = 'in-band-status' property of the DSA master. Additionally,
if the DSA master is mvneta-like, in-band AN could be broken and no one
might even notice. But chances are it might not be mvneta-like.
Only you or Andrew know the chances of that, and maybe you're willing to
take the gamble of unconditionally creating a fixed-link (no in-band AN)
as you're doing now, when in fact, correctness and all, a managed =
"in-band-status" OF property is what should have been auto-created.
My feedback is - if you're willing to take that gamble, do it just for
mv88e6xxx and the boards that got integrated into, I'm not willing to
opt other drivers into it.

> That's why I've been trying to get these tested, and that's why
> there's a risk with them. However, that's got nothing to do with
> whether the driver implements filling in this new "default_interface"
> field.
> 
> We could go delving into the node pointed to by the phandle and retrieve
> whatever parameters from there, but that is an entirely new behaviour
> and would be a functional change to the behaviour that Andrew has been
> promoting - and is itself not free of a risk of regressions caused by
> that approach. What if there's an interface converter in the path between
> the# CPU ethernet device and the DSA that hasn't needed to be described?
> Digging out the phy-mode from the CPU side could be the wrong thing to
> do.
> 
> Then there's the question whether DSA should have been validating that
> the description on both ends of the link are compatible with each other.
> The problem with that is just the same as the above - an undescribed
> interface converter would make such validation problematical.

Not on both ends, but individual drivers could validate their own
bindings to be perfectly honest with you. I think we should prioritize
on that. If driver maintainers don't know that there are defaulting DT
blobs in the wild, don't give them ideas.

> So, I don't think we could rely on the description on the other end of
> the link to be capable of describing the setup on the DSA port end.

If you go back in our conversation, I wasn't saying you should, either.
It was just a comment about the impossibility of the situation - it's is
a guessing game that shouldn't in any circumstance be generalized and
will never become perfect. I've been saying this a million times.
Move to phylink no more than what you need; assume everything else
works; add validation to what you don't have proof uses defaulting mode;
wait.

Now consider what originally triggered me. cn9130-crb.dtsi has a
defaulting CPU port of a 6393X, where the DSA master uses inband/10gbase-r
mode. What is DSA even supposed to make of that, beats me, if it were to
hypothetically follow the 'ethernet' phandle to determine whether the
master wants in-band AN or doesn't...
