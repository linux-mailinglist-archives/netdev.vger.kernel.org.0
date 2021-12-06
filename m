Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A523346AE8C
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 00:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352918AbhLFXsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 18:48:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbhLFXsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 18:48:16 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44571C061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 15:44:47 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id r11so49359600edd.9
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 15:44:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7Q0/lkCZtd+6W1ZN3wf5lP1fZAjnFUtgBEM/ACRVsDk=;
        b=lmaeCIfG4LAgvBTG9TaAPlEoWbXfVWbBGavkMyZUOhO8Tgx2ian5CPx85i0gnGb+b6
         NzLOmFHVypSN8BQE/SVnnKtFnwvZ4saJpQf4QJIb5V42knFKN5g8dqzd5xrgtGTMNWO/
         uHdwntyo0twwImmB5ORo3AdjFnzv4by+UepQZvP61yU/U5H9Up+AmyIJa/JVc4wNGApb
         FNv96KYv5YxRGGPornmNPk7fu8g4LtVJ0Dy1TiACwfMhqXttWw9sSzlXL2KQuT/NGoNO
         ImgMZJiwAxwgo+MKF2Y345BMcZteqbUzJ0UbqdwNa39Fic7OwZjmIipLhZcqpdai3jst
         LzUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7Q0/lkCZtd+6W1ZN3wf5lP1fZAjnFUtgBEM/ACRVsDk=;
        b=ib6Qt8vQtRqr6q5TQcLCxpX/jFCGN6M8uijB/0qdtJUZ71xbZg7U3akuxAXU2rpoW4
         aXqz79wx09RRONc+z1cW4d9RnZic9lV4zvywQaWaRNlKFaN3fhZUSxcYu1ckMirLIbZf
         7H89SXjolIOria+WN82NYjIzj7Yw6UUjGNdM8Ym3omjQpjzFp6ni7BIJoOZnUZQ6Wmd5
         Z8RaevYfkL1H4VterwnszPjTNbeAH9XRXhWHX3Iv121UbndGjhEL8tnK7MAkRZQLW6Mf
         nwv99RA3+Ze32WpMbCFwTJxySMRyoc1OxlAljLEypS4upQQybrB1v+qboavbQQtAXG9F
         0Y0w==
X-Gm-Message-State: AOAM531scaz3sS3aKaKAR0fo6cQNoY2xttKsNPKSw1SuxvpELljjHq+4
        Ugi12HnVFbulIL59rQaGFu4=
X-Google-Smtp-Source: ABdhPJyLQ52c97Yw9qXlv1bt0S0kHZ0zPXK/S0AukUQ0V78wNL+7HDJ8M2isCg8ZYBW1j1ooQ26s3w==
X-Received: by 2002:a17:906:9750:: with SMTP id o16mr48956849ejy.263.1638834285647;
        Mon, 06 Dec 2021 15:44:45 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id f7sm8660630edw.44.2021.12.06.15.44.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 15:44:45 -0800 (PST)
Date:   Tue, 7 Dec 2021 01:44:43 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Martyn Welch <martyn.welch@collabora.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, kernel@collabora.com
Subject: Re: mv88e6240 configuration broken for B850v3
Message-ID: <20211206234443.ar567ocqvmudpckj@skbuf>
References: <20211206185008.7ei67jborz7tx5va@skbuf>
 <3d6c6226e47374cf92d604bc6c711e59d76e3175.camel@collabora.com>
 <20211206193730.oubyveywniyvptfk@skbuf>
 <Ya5tkXU3AXalFRg2@shell.armlinux.org.uk>
 <20211206202308.xoutfymjozfyhhkl@skbuf>
 <Ya53vXp7Wz5YPf7Y@shell.armlinux.org.uk>
 <20211206211341.ppllxa7ve2jdyzt4@skbuf>
 <Ya6ARQBGl2C4Z3il@shell.armlinux.org.uk>
 <20211206215139.fv7xzqbnupk7pxfx@skbuf>
 <Ya6NF9OxSmLO9hv+@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ya6NF9OxSmLO9hv+@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 10:22:15PM +0000, Russell King (Oracle) wrote:
> On Mon, Dec 06, 2021 at 11:51:39PM +0200, Vladimir Oltean wrote:
> > On Mon, Dec 06, 2021 at 09:27:33PM +0000, Russell King (Oracle) wrote:
> > > On Mon, Dec 06, 2021 at 11:13:41PM +0200, Vladimir Oltean wrote:
> > > > On Mon, Dec 06, 2021 at 08:51:09PM +0000, Russell King (Oracle) wrote:
> > > > > With a bit of knowledge of how Marvell DSA switches work...
> > > > > 
> > > > > The "ppu" is the PHY polling unit. When the switch comes out of reset,
> > > > > the PPU probes the MDIO bus, and sets the bit in the port status
> > > > > register depending on whether it detects a PHY at the port address by
> > > > > way of the PHY ID values. This bit is used to enable polling of the
> > > > > PHY and is what mv88e6xxx_port_ppu_updates() reports. This bit will be
> > > > > set for all internal PHYs unless we explicitly turn it off (we don't.)
> > > > > Therefore, this is a reasonable assumption to make.
> > > > > 
> > > > > So, given that mv88e6xxx_port_ppu_updates() is most likely true as
> > > > > I stated, it is also true that mv88e6xxx_phy_is_internal() is
> > > > > "don't care".
> > > > 
> > > > And the reason why you bring the PPU into the discussion is because?
> > > > If the issue manifests itself with or without it, and you come up with a
> > > > proposal to set LINK_UNFORCED in mv88e6xxx_mac_config if the PPU is
> > > > used, doesn't that, logically speaking, still leave the issue unsolved
> > > > if the PPU is _not_ used for whatever reason?
> > > > The bug has nothing to do with the PPU. It can be solved by checking for
> > > > PPU in-band status as you say. Maybe. But I've got no idea why we don't
> > > > address the elephant in the room, which is in dsa_port_link_register_of()?
> > > 
> > > I think I've covered that in the other sub-thread.
> > > 
> > > It could be that a previous configuration left the port forced down.
> > > For example, if one were to kexec from one kernel that uses a
> > > fixed-link that forced the link down, into the same kernel with a
> > > different DT that uses PHY mode.
> > > 
> > > The old kernel may have called mac_link_down(MLO_AN_FIXED), and the
> > > new kernel wouldn't know that. It comes along, and goes through the
> > > configuration process and calls mac_link_up(MLO_AN_PHY)... and from
> > > what you're suggesting, because these two calls use different MLO_AN_xxx
> > > constants that's a bug.
> > 
> > Indeed I don't have detailed knowledge of Marvell hardware, but I'm
> > surprised to see kexec being mentioned here as a potential source of
> > configurations which the driver does not expect to handle. My belief was
> > that kexec's requirements would be just to silence the device
> > sufficiently such that it doesn't cause any surprises when things such
> > interrupts are enabled (DMA isn't relevant for DSA switches).
> > It wouldn't be responsible for leaving the hardware in any other state
> > otherwise.
> > 
> > I see this logic in the driver, does it not take care of bringing the
> > ports to a known state, regardless of what a previous boot stage may
> > have done?
> > 
> > static int mv88e6xxx_switch_reset(struct mv88e6xxx_chip *chip)
> > {
> > 	int err;
> > 
> > 	err = mv88e6xxx_disable_ports(chip);
> > 	if (err)
> > 		return err;
> > 
> > 	mv88e6xxx_hardware_reset(chip);
> > 
> > 	return mv88e6xxx_software_reset(chip);
> > }
> > 
> > So unless I'm fooled by mentally putting an equality sign between
> > mv88e6xxx_switch_reset() and getting rid of whatever a previous kernel
> > may have done, I don't think at all that the two cases are comparable:
> > kexec and a previous call to mv88e6xxx_mac_link_down() initiated by
> > dsa_port_link_register_of() from this kernel.
> 
> If the hardware reset is not wired to be under software control or is
> not specified, then mv88e6xxx_hardware_reset() is a no-op.
> 
> mv88e6xxx_software_reset() does not fully reinitialise the switch.
> To quote one switch manual for the SWReset bit "Register values are not
> modified." That means if the link was forced down previously by writing
> to the port control register, the port remains forced down until
> software changes that register to unforce the link, or to force the
> link up.

Ouch, this is pretty unfortunate if true. But please allow me to suggest
that not all DSA switches are like this, and that this is a pretty weak
justification for the placement of a phylink_mac_link_down call in no
other place than dsa_port_link_register_of. If this is an indication of
anything, the two DSA drivers that I maintain have worked just fine in
the time frame between the DSA conversion to forcing the link in
mac_link_up and the DSA change to force a mac_link_down before
connecting to phylink, therefore do not need that change.
Therefore, I believe that it isn't fair to create avoidable baggage for
other drivers, that may end up depending without even realizing on this
non-standard arrangement of phylink calls. If the mac_link_down would
have been in phylink I wouldn't have had any problem. Same if the same
call would have been initiated by mv88e6xxx itself.
Is there any technical reason why the mv88e6xxx driver (or others if
others exist) cannot turn off its ports by itself and needs to be driven
by an external phylink_mac_link_down call to do that (with extra care
taken that the port is able to be turned back on again by phylink if
needed)? It can't be that can't compute the arguments to call the
function with - because they aren't correct in the current form of the
code either. It also can't be due to the timing, because we are here:

static int dsa_tree_setup_switches(struct dsa_switch_tree *dst)
{
	struct dsa_port *dp;
	int err;

	list_for_each_entry(dp, &dst->ports, list) {
		err = dsa_switch_setup(dp->ds);
		-> calls ->setup()
		if (err)
			goto teardown;
	}

	list_for_each_entry(dp, &dst->ports, list) {
		err = dsa_port_setup(dp);
		-> calls dsa_port_link_register_of()
		   -> calls phylink_mac_link_down()
		if (err) {
			err = dsa_port_reinit_as_unused(dp);
			if (err)
				goto teardown;
		}
	}

So since we are positioned where we are in the DSA initialization
sequence, forcing the CPU ports down at the end of ->setup() should be
close enough temporally to where it is currently done now?
