Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED89257958D
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 10:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237109AbiGSIus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 04:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237092AbiGSIui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 04:50:38 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F46FD20;
        Tue, 19 Jul 2022 01:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658220637; x=1689756637;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2JAJzcpzppdk8+5vwNAE1GhAxpYQx+69osAyMGcV9+w=;
  b=LznMufkKV6tn+AsL8Pcp6zDsJmcxF1WbpzngdeuHIFYVyCRVq+nxXMkT
   CAurvrK5QZIVmkJIVHoZ6ACy+TlsF5NiembV77ZLSTq2+U8dAiZaoF7XS
   kwFCOVjd9F9YEsWa8xuQMqLoHc7vb5abwOCw7F9VyOy4R+hb3YSkf7ko1
   2j/Dpdp5fqOlUcCbm0xpXWrrAYeNvDWSsIOQNLeKAa7Z20P0Mz8sU2QRf
   2WO2SKlyxebHwaJBhyLJwvsi8Vd1AgGbYBB+J3CXIvPJLGu8JuODicL6Y
   jfq+brmZ4GKFdpAqXoKQ/aYhr03BCkivhpwp0bPA63cymBSrLB8IsaVHr
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10412"; a="283999834"
X-IronPort-AV: E=Sophos;i="5.92,283,1650956400"; 
   d="scan'208";a="283999834"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 01:50:37 -0700
X-IronPort-AV: E=Sophos;i="5.92,283,1650956400"; 
   d="scan'208";a="700361257"
Received: from punajuuri.fi.intel.com (HELO paasikivi.fi.intel.com) ([10.237.72.43])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 01:50:29 -0700
Received: from paasikivi.fi.intel.com (localhost [127.0.0.1])
        by paasikivi.fi.intel.com (Postfix) with SMTP id 9E6EB202EA;
        Tue, 19 Jul 2022 11:50:27 +0300 (EEST)
Date:   Tue, 19 Jul 2022 08:50:27 +0000
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin __ipraga <alsi@bang-olufsen.dk>,
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
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: Re: [PATCH net-next 2/6] software node: allow named software node to
 be created
Message-ID: <YtZwU9BKAO/WSRmK@paasikivi.fi.intel.com>
References: <YtHGwz4v7VWKhIXG@smile.fi.intel.com>
 <20220715201715.foea4rifegmnti46@skbuf>
 <YtHPJNpcN4vNfgT6@smile.fi.intel.com>
 <20220715204841.pwhvnue2atrkc2fx@skbuf>
 <YtVSQI5VHtCOTCHc@smile.fi.intel.com>
 <YtVfppMtW77ICyC5@shell.armlinux.org.uk>
 <YtWp3WkpCtfe559l@smile.fi.intel.com>
 <YtWwbMucEyO+W8/Y@shell.armlinux.org.uk>
 <YtW9goFpOLGvIDog@smile.fi.intel.com>
 <YtXE0idsKe6FZ+n4@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtXE0idsKe6FZ+n4@shell.armlinux.org.uk>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell, Andy,

On Mon, Jul 18, 2022 at 09:38:42PM +0100, Russell King (Oracle) wrote:
> On Mon, Jul 18, 2022 at 11:07:30PM +0300, Andy Shevchenko wrote:
> > On Mon, Jul 18, 2022 at 08:11:40PM +0100, Russell King (Oracle) wrote:
> > > Good point - I guess we at least need to attach the swnode parent to the
> > > device so its path is unique, because right now that isn't the case. I'm
> > > guessing that:
> > > 
> > >         new_port_fwnode = fwnode_create_software_node(port_props, NULL);
> > > 
> > > will create something at the root of the swnode tree, and then:
> > > 
> > >         fixed_link_fwnode = fwnode_create_named_software_node(fixed_link_props,
> > >                                                               new_port_fwnode,
> > >                                                               "fixed-link");
> > > 
> > > will create a node with a fixed name. I guess it in part depends what
> > > pathname the first node gets (which we don't specify.) I'm not familiar
> > > with the swnode code to know what happens with the naming for the first
> > > node.
> > 
> > First node's name will be unique which is guaranteed by IDA framework. If we
> > have already 2B nodes, then yes, it would be problematic (but 2^31 ought to be
> > enough :-).
> > 
> > > However, it seems sensible to me to attach the first node to the device
> > > node, thus giving it a unique fwnode path. Does that solve the problem
> > > in swnode land?
> > 
> > Yes, but in the driver you will have that as child of the device, analogue in DT
> > 
> >   my_root_node { // equal the level of device node you attach it to
> > 	  fixed-link {
> > 	  }
> >   }
> > 
> > (Sorry, I don't know the DT syntax by heart, but I hope you got the idea.)
> 
> Yes, that looks about right.
> 
> What we're attempting to do here is create the swnode equivalent of this
> DT description:
> 
> 	some_node {
> 		phy-mode = "foo";
> 
> 		fixed-link {
> 			speed = X;
> 			full-duplex;
> 		};
> 	};
> 
> and the some_node fwnode handle gets passed into phylink for it to
> parse - we never attach it to the firmware tree itself. Once phylink
> has parsed it, we destroy the swnode tree since it's no longer useful.
> 
> This would get used in this situation as an example:
> 
> 	switch@4 {
> 		compatible = "marvell,mv88e6085";
> 
> 		ports {
> 			port@0 {
> 				reg = <0>;
> 				phy-mode = "internal";
> 				phy-handle = <&sw_phy_0>;
> 			};
> 			...
> 			port@5 {
> 				reg = <5>;
> 				label = "cpu";
> 				ethernet = <&eth1>;
> 			};
> 		};
> 	};
> 
> The DSA driver knows the capabilities of the chip, so it knows what the
> fastest "phy-mode" and speed would be, and whether full or half duplex
> are supported.
> 
> We need to get this information into phylink some how, and my initial
> approach was to add a new function to phylink to achieve that.
> 
> We would normally have passed the "port@5" node to phylink, just as we
> pass the "port@0" node. However, because the "port@5" operates as a
> fixed-link as determined by the hardware/driver, we need some way to
> get that into phylink.
> 
> So, Vladimir's approach is to create a swnode tree that reflects the
> DT layout, and rather than passing the "port@5" as a fwnode to phylink,
> we instead pass that "some_node" swnode instead. Phylink then uses
> normal fwnode APIs to parse the swnode tree it's been given, resulting
> in it picking up the fixed-link specification as if it had been in the
> original DT.
> 
> We don't augment the existing firmware tree for "port@5", we are
> effectively creating a small sub-tree and using it as a subsitute
> description.
> 
> I hope that clarifies what is going on here and why.

Basically what your patch is doing is adding a helper function that creates
an fwnode with a given name. This functionality was there previously through
software_node_register_nodes(), with node allocation responsibility residing
on the caller. It's used e.g. here:
drivers/media/pci/intel/ipu3/cio2-bridge.c .

The larger question is perhaps when can you safely remove software nodes.
And which of these two APIs would be preferred. I haven't checked how many
users each has. There's no refcounting nor locking for software nodes, so
once made visible to the rest of the kernel, they're always expected to be
there, unchanged, or at least it needs to be known when they can be removed.

-- 
Kind regards,

Sakari Ailus
