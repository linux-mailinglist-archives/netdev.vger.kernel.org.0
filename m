Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA3F576802
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 22:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbiGOULu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 16:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbiGOULe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 16:11:34 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15CE267C89;
        Fri, 15 Jul 2022 13:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657915890; x=1689451890;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=FKJ/dIF3JDEjcdCfFHYJXRw3fJQKzGLSXIktrmv9EfU=;
  b=A9l5ZG6HkNzBX0AhxkYFsEvQyzgCfpu15884ol65Ff+dTI4Pk4AMqa11
   CxVuhdNMoCcV7DmHU81mde/hrLoXdG7Eow23EnqmvEQOZ5kLUhnaKphQM
   HMwCx1FKSgyVRtaYXv1pT8eAtbH17jMhFWIxIRSndBMOjktPxkx4k5u7v
   aB2SwiXr4MprHmSc/6ox5RDNP+n4Q2QrtU9E/USbJLH1f2TfVfccZibVB
   eWByHHNrORafRmUNnECPDbIvpZTDUc9jCgtnhN+VvS5PovH1Q55L2jeTm
   pJipBLEkjouYYkyN7CAzrjTanuYEd4D26t6/Opf0TVxbmnvtV09s5uAw7
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10409"; a="283449910"
X-IronPort-AV: E=Sophos;i="5.92,274,1650956400"; 
   d="scan'208";a="283449910"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 13:11:29 -0700
X-IronPort-AV: E=Sophos;i="5.92,274,1650956400"; 
   d="scan'208";a="686087461"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 13:11:22 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1oCReg-001JEh-2D;
        Fri, 15 Jul 2022 23:11:18 +0300
Date:   Fri, 15 Jul 2022 23:11:18 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
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
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: Re: [PATCH net-next 5/6] net: dsa: use swnode fixed-link if using
 default params
Message-ID: <YtHJ5rfxZ+icXrkC@smile.fi.intel.com>
References: <YtGPO5SkMZfN8b/s@shell.armlinux.org.uk>
 <E1oCNlE-006e3z-3T@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E1oCNlE-006e3z-3T@rmk-PC.armlinux.org.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 15, 2022 at 05:01:48PM +0100, Russell King (Oracle) wrote:
> Create and use a swnode fixed-link specification for phylink if no
> parameters are given in DT for a fixed-link. This allows phylink to
> be used for "default" cases for DSA and CPU ports. Enable the use
> of phylink in all cases for DSA and CPU ports.

> Co-developed by Vladimir Oltean and myself.

Why not to use

  Co-developed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

?

> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Marek Behún <kabel@kernel.org>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

...

> +static struct {
> +	unsigned long mask;
> +	int speed;
> +	int duplex;
> +} phylink_caps_params[] = {
> +	{ MAC_400000FD, SPEED_400000, DUPLEX_FULL },
> +	{ MAC_200000FD, SPEED_200000, DUPLEX_FULL },
> +	{ MAC_100000FD, SPEED_100000, DUPLEX_FULL },
> +	{ MAC_56000FD,  SPEED_56000,  DUPLEX_FULL },
> +	{ MAC_50000FD,  SPEED_50000,  DUPLEX_FULL },
> +	{ MAC_40000FD,  SPEED_40000,  DUPLEX_FULL },
> +	{ MAC_25000FD,  SPEED_25000,  DUPLEX_FULL },
> +	{ MAC_20000FD,  SPEED_20000,  DUPLEX_FULL },
> +	{ MAC_10000FD,  SPEED_10000,  DUPLEX_FULL },
> +	{ MAC_5000FD,   SPEED_5000,   DUPLEX_FULL },
> +	{ MAC_2500FD,   SPEED_2500,   DUPLEX_FULL },
> +	{ MAC_1000FD,   SPEED_1000,   DUPLEX_FULL },
> +	{ MAC_100FD,    SPEED_100,    DUPLEX_FULL },
> +	{ MAC_10FD,     SPEED_10,     DUPLEX_FULL },
> +	{ MAC_1000HD,   SPEED_1000,   DUPLEX_HALF },
> +	{ MAC_100HD,    SPEED_100,    DUPLEX_HALF },
> +	{ MAC_10HD,     SPEED_10,     DUPLEX_HALF },
> +};
> +
> +static int dsa_port_find_max_speed(unsigned long caps, int *speed, int *duplex)
> +{
> +	int i;
> +
> +	*speed = SPEED_UNKNOWN;
> +	*duplex = DUPLEX_UNKNOWN;
> +
> +	for (i = 0; i < ARRAY_SIZE(phylink_caps_params); i++) {
> +		if (caps & phylink_caps_params[i].mask) {
> +			*speed = phylink_caps_params[i].speed;
> +			*duplex = phylink_caps_params[i].duplex;

> +			break;

With the below check it's way too protective programming.

			return 0;

> +		}
> +	}
> +
> +	return *speed == SPEED_UNKNOWN ? -EINVAL : 0;

	return -EINVAL;

> +}

...

> +static struct fwnode_handle *dsa_port_get_fwnode(struct dsa_port *dp,
> +						 phy_interface_t mode)
> +{

> +	struct property_entry fixed_link_props[3] = { };
> +	struct property_entry port_props[3] = {};

A bit of consistency in the assignments?

Also it seems you are using up to 2 for the first one and only 1 in the second
one. IIUC it requires a terminator entry, so it means 3 and 2. Do we really
need 3 in the second case?

> +	struct fwnode_handle *fixed_link_fwnode;
> +	struct fwnode_handle *new_port_fwnode;
> +	struct device_node *dn = dp->dn;
> +	struct device_node *phy_node;
> +	int err, speed, duplex;
> +	unsigned long caps;
> +
> +	phy_node = of_parse_phandle(dn, "phy-handle", 0);

fwnode in the name, why not to use fwnode APIs?

	fwnode_find_reference();

> +	of_node_put(phy_node);
> +	if (phy_node || of_phy_is_fixed_link(dn))
> +		/* Nothing broken, nothing to fix.
> +		 * TODO: As discussed with Russell, maybe phylink could provide
> +		 * a more comprehensive helper to determine what constitutes a
> +		 * valid fwnode binding than this guerilla kludge.
> +		 */
> +		return of_fwnode_handle(dn);
> +
> +	if (mode == PHY_INTERFACE_MODE_NA)
> +		dsa_port_find_max_caps(dp, &mode, &caps);
> +	else
> +		caps = dp->pl_config.mac_capabilities &
> +		       phylink_interface_to_caps(mode);
> +
> +	err = dsa_port_find_max_speed(caps, &speed, &duplex);
> +	if (err)
> +		return ERR_PTR(err);
> +
> +	fixed_link_props[0] = PROPERTY_ENTRY_U32("speed", speed);
> +	if (duplex == DUPLEX_FULL)
> +		fixed_link_props[1] = PROPERTY_ENTRY_BOOL("full-duplex");
> +
> +	port_props[0] = PROPERTY_ENTRY_STRING("phy-mode", phy_modes(mode));
> +
> +	new_port_fwnode = fwnode_create_software_node(port_props, NULL);
> +	if (IS_ERR(new_port_fwnode))
> +		return new_port_fwnode;
> +
> +	/* Node needs to be named so that phylink's call to
> +	 * fwnode_get_named_child_node() finds it.
> +	 */
> +	fixed_link_fwnode = fwnode_create_named_software_node(fixed_link_props,
> +							      new_port_fwnode,
> +							      "fixed-link");
> +	if (IS_ERR(fixed_link_fwnode)) {
> +		fwnode_remove_software_node(new_port_fwnode);
> +		return fixed_link_fwnode;
> +	}
> +
> +	return new_port_fwnode;
> +}

-- 
With Best Regards,
Andy Shevchenko


