Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19B7A18904D
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 22:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgCQVZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 17:25:18 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:45668 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726388AbgCQVZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 17:25:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=EYkrmVZKJc55hiH7sahW+IAVzSPmzWr7Qzpmj6OO7ck=; b=OcMUooOuEFc9/BCd9EWQtOByp
        PrnDA9RFRWkQZ9p6tqyoGJHcDZOhnqJT2J5yZHnVjAD40kznbyRXO3Q3yIbszpdtM0TI2N+n4EWhw
        UCQHPKYAzDvObCbRvHYMrKSbegUTlYS6huJ9bDoHeecUF8sxyD1R6JdbvX1z8YIT1CtIYrMSRC71/
        8B9BjLQMTp4AuT6tk5okW73DFQKCs431s9hbUbxknK/3Oajn0T4CIy/qiiEPptBfdMbi0bjlR+4pa
        Qmb0yt0E/xqv6n3UHxhAIdrJBqktQzLT0l4AwdpkGZ68fHO3JQl5+xuHOVN5xSAPxF7PsMPKwbY2k
        X5L+y8S+Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:37816)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jEJhp-0000yI-Jo; Tue, 17 Mar 2020 21:24:57 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jEJhl-00039D-8Z; Tue, 17 Mar 2020 21:24:53 +0000
Date:   Tue, 17 Mar 2020 21:24:53 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ido Schimmel <idosch@idosch.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ivan Vecera <ivecera@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/3] VLANs, DSA switches and multiple bridges
Message-ID: <20200317212453.GV25745@shell.armlinux.org.uk>
References: <CA+h21hrjAT4yCh=UgJJDfv3=3OWkHUjMRB94WuAPDk-hkhOZ6w@mail.gmail.com>
 <15ce2fae-c2c8-4a36-c741-6fef58115604@gmail.com>
 <20200219231528.GS25745@shell.armlinux.org.uk>
 <e9b51f9e-4a8f-333d-5ba9-3fcf220ace7c@gmail.com>
 <20200221002110.GE25745@shell.armlinux.org.uk>
 <20200316111524.GE5827@shell.armlinux.org.uk>
 <20200317120044.GH5827@shell.armlinux.org.uk>
 <CA+h21hpGvhgxdNid8OMG15Zyp6uzGjAq_xmGgz2Udvo3sHuZ0g@mail.gmail.com>
 <20200317151238.GQ25745@shell.armlinux.org.uk>
 <20200317144906.GB3155670@t480s.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200317144906.GB3155670@t480s.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 17, 2020 at 02:49:06PM -0400, Vivien Didelot wrote:
> Hi Russell,
> 
> On Tue, 17 Mar 2020 15:12:38 +0000, Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
> > On Tue, Mar 17, 2020 at 04:21:00PM +0200, Vladimir Oltean wrote:
> > > Hi Russell,
> > > 
> > > On Tue, 17 Mar 2020 at 14:00, Russell King - ARM Linux admin
> > > <linux@armlinux.org.uk> wrote:
> > > >
> > > > On Mon, Mar 16, 2020 at 11:15:24AM +0000, Russell King - ARM Linux admin wrote:
> > > > > On Fri, Feb 21, 2020 at 12:21:10AM +0000, Russell King - ARM Linux admin wrote:
> > > > > > On Thu, Feb 20, 2020 at 10:56:17AM -0800, Florian Fainelli wrote:
> > > > > > > Let's get your patch series merged. If you re-spin while addressing
> > > > > > > Vivien's comment not to use the term "vtu", I think I would be fine with
> > > > > > > the current approach of having to go after each driver and enabling them
> > > > > > > where necessary.
> > > > > >
> > > > > > The question then becomes what to call it.  "always_allow_vlans" or
> > > > > > "always_allow_vlan_config" maybe?
> > > > >
> > > > > Please note that I still have this patch pending (i.o.w., the problem
> > > > > with vlans remains unfixed) as I haven't received a reply to this,
> > > > > although the first two patches have been merged.
> > > >
> > > > Okay, I think three and a half weeks is way beyond a reasonable time
> > > > period to expect any kind of reply.
> > > >
> > > > Since no one seems to have any idea what to name this, but can only
> > > > offer "we don't like the vtu" term, it's difficult to see what would
> > > > actually be acceptable.  So, I propose that we go with the existing
> > > > naming.
> > > >
> > > > If you only know what you don't want, but not what you want, and aren't
> > > > even willing to discuss it, it makes it very much impossible to
> > > > progress.
> > > >
> > > > --
> > > > RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> > > > FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
> > > 
> > > As I said, I know why I need this blocking of bridge vlan
> > > configuration for sja1105, but not more. For sja1105 in particular, I
> > > fully admit that the hardware is quirky, but I can work around that
> > > within the driver. The concern is for the other drivers where we don't
> > > really "remember" why this workaround is in place. I think, while your
> > > patch is definitely a punctual fix for one case that doesn't need the
> > > workaround, it might be better for maintenance to just see exactly
> > > what breaks, instead of introducing this opaque property.
> > > While I don't want to speak on behalf of the maintainers, I think that
> > > may be at least part of the reason why there is little progress being
> > > made. Introducing some breakage which is going to be fixed better next
> > > time might be the more appropriate thing to do.
> > 
> > The conclusion on 21st February was that all patches should be merged,
> > complete with the boolean control, but there was an open question about
> > the name of the boolean used to enable this behaviour.
> > 
> > That question has not been resolved, so I'm trying to re-open discussion
> > of that point.  I've re-posted the patch.
> > 
> > -- 
> > RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> > FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
> 
> In response to your 3/3 patch, I suggested commands to test setting up a
> VLAN filtering aware bridge with your own default PVID before enslaving
> DSA ports. Unfortunately you left this unanswered.

I don't believe I left it unanswered.  However, I'm not about to rip
apart my network to try an experiment with specific set of commands.
I did, however, experiment a lot to work out what was going on, so I
already have the knowledge.

I believe I explained in the series description that the problem only
happens when vlan filtering is enabled with a pre-existing vlan
configuration present, even the default configuration.

Enabling vlan filtering *immediately* blocks all traffic on the Marvell
switch, whether it has vlan tags or not.  Any *new* vlan modifications
then get entered into the VTU, and the Marvell switch then behaves
accordingly with those new entries as one would expect.

Any setup done *before* vlan filtering is enabled is not present in the
VTU, and so remains non-existent as far as the DSA switch is concerned.

As soon as vlan filtering is enabled, the ports are switched to "802.1Q
secure" state, which means:

- The switch will consult the VTU for the incoming packet; if no entry
  is found for the vlan number either tagged to the packet, or the
  default vlan if not, then the packet will be discarded by the switch.

So, the setup done *before* vlan filtering is enabled, which is not
programmed into the VTU, results in that traffic being lost.

> I think this would be
> much more interesting in order to tackle the issue you're having here with
> mv88e6xxx and bridge, instead of pointing out the lack of response regarding
> an alternative boolean name.

It is my understanding that Florian actively wants this merged.  No
one objected to his email.

It seems there's a disconnect *between* the DSA maintainers - I think
you need to be more effectively communicating with each other and
reading each other's emails, and pro-actively replying to stuff you
may have other views on.

> That being said, "force_vlan_programming",
> "always_allow_vlans", or whatever explicit non-"vtu" term is fine by me.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
