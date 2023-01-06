Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35EB96601EE
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 15:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234636AbjAFOST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 09:18:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232680AbjAFOSO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 09:18:14 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C48E4BD71;
        Fri,  6 Jan 2023 06:18:13 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id t17so3774059eju.1;
        Fri, 06 Jan 2023 06:18:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uPf4J3Yh6O7BgQhfJyLueQrOIKOPG28GziMEJr4vd9U=;
        b=jiS2pDOUqGASh6LJShwQQqHJPcX+pidKTmmw763IH8goHdLSdjJdYMCny7jyvBBdW4
         jdGvE7D+kXuXtXacWWef3InLgnl1nxB7/+DdBRwDhBus+F6m/jKrBp+s2b5XndLz1lrR
         Mq7vfv/C0X/rHgbS2EHafRRjUbDQhdsCzs+y1DOfADiHpKIMFrMleOSpinEeaZAO7MVS
         QbqZX0ewVl4YKWG/Fw6zW4Dkwjz8MhYt1UELuxkDfvc39xChgMUUw6F4B/KNcAImbpEv
         LjvmzT4gPg2TmMo7hC0zEjc9zs1Rkx/DYpZY41WYrxf3Vm9D9aP+CgZFCApdLMSZumUK
         hKjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uPf4J3Yh6O7BgQhfJyLueQrOIKOPG28GziMEJr4vd9U=;
        b=xRJOHGKYc4zalsBLT2Gha9+DWimhYtZEj7L3axE/0jVqn6/EHBJBE/gFd6P6pb+XLq
         Yib4C3KRPzwwIjGcMR8tbT8MJYTzyl6rW8IAHDdtSW0ESq+lwXnTA9S97UU3mpSo6b0u
         Iqf3JXr6qIybC4wzbNM7A/dodi2enVxP4ktLugf4ECf7mRFEk6XZt5RmebakMA4Yu14U
         yWZIVMyKblZF4q74bJH8uGBjNrU7g8Hiir6RZYUPcu9vmwTXsPHwf6BPGka5XPS79L13
         Djbu8/wbQqNfp7Vokh5IEZpEj1mcDZ89uvljdtWGuHhxh7qBK1js+bWa1wO/7lPpkMQl
         FPFg==
X-Gm-Message-State: AFqh2kpan3IMrd7kfQI85kCpq8owXFGz3cZbA/PrEsUdj1xeB/D9CjbM
        URAmupiH/nySaQyonX+hNdA=
X-Google-Smtp-Source: AMrXdXsRBgX3gvNEfVIj7vKjBpGC4KWNJ8h72e1KP0Gp56gLhxnHgkVrwhkAhW6R6dR8jxrmonzg7Q==
X-Received: by 2002:a17:907:7ea1:b0:7c4:f752:e95c with SMTP id qb33-20020a1709077ea100b007c4f752e95cmr60888138ejc.1.1673014691890;
        Fri, 06 Jan 2023 06:18:11 -0800 (PST)
Received: from skbuf ([188.26.184.223])
        by smtp.gmail.com with ESMTPSA id gv7-20020a170906f10700b007aec1b39478sm436834ejb.188.2023.01.06.06.18.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 06:18:11 -0800 (PST)
Date:   Fri, 6 Jan 2023 16:18:09 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Sean Anderson <sean.anderson@seco.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Tim Harvey <tharvey@gateworks.com>
Subject: Re: [PATCH net-next v5 4/4] phy: aquantia: Determine rate adaptation
 support from registers
Message-ID: <20230106141809.ohfbmptdnbtn4kfv@skbuf>
References: <20230103220511.3378316-1-sean.anderson@seco.com>
 <20230103220511.3378316-5-sean.anderson@seco.com>
 <20230105140421.bqd2aed6du5mtxn4@skbuf>
 <Y7bhctPZoyNnw1ay@shell.armlinux.org.uk>
 <20230105174342.jldjjisgzs6dmcpd@skbuf>
 <Y7ccNSSnPxTR2AQs@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7ccNSSnPxTR2AQs@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 05, 2023 at 06:51:33PM +0000, Russell King (Oracle) wrote:
> On Thu, Jan 05, 2023 at 07:43:42PM +0200, Vladimir Oltean wrote:
> > On Thu, Jan 05, 2023 at 02:40:50PM +0000, Russell King (Oracle) wrote:
> > > > If the PHY firmware uses a combination like this: 10GBASE-R/XFI for
> > > > media speeds of 10G, 5G, 2.5G (rate adapted), and SGMII for 1G, 100M
> > > > and 10M, a call to your implementation of
> > > > aqr107_get_rate_matching(PHY_INTERFACE_MODE_10GBASER) would return
> > > > RATE_MATCH_NONE, right? So only ETHTOOL_LINK_MODE_10000baseT_Full_BIT
> > > > would be advertised on the media side?
> > > 
> > > No, beause of the special condition in phylink that if it's a clause 45
> > > PHY and we use something like 10GBASE-R, we don't limit to just 10G
> > > speed, but try all interface modes - on the assumption that the PHY
> > > will switch its host interface.
> > > 
> > > RATE_MATCH_NONE doesn't state anything about whether the PHY operates
> > > in a single interface mode or not - with 10G PHYs (and thus clause 45
> > > PHYs) it seems very common from current observations for
> > > implementations to do this kind of host-interface switching.
> > 
> > So you mention commits
> > 7642cc28fd37 ("net: phylink: fix PHY validation with rate adaption") and
> > df3f57ac9605 ("net: phylink: extend clause 45 PHY validation workaround").
> > 
> > IIUC, these allow the advertised capabilities to be more than 10G (based
> > on supported_interfaces), on the premise that it's possible for the PHY
> > to switch SERDES protocol to achieve lower speeds.
> 
> I didn't mention any commits, but yes, it's ever since the second commit
> you list above, which was necessary to get PHYs which switch their
> interface mode to work sanely. It essentially allows everything that
> the combination of host and PHY supports, because we couldn't do much
> better at the time that commit was written.
> 
> > This does partly correct the last part of my question, but I believe
> > that the essence of it still remains. We won't make use of PAUSE rate
> > adaptation to support the speeds which aren't directly covered by the
> > supported_interfaces. Aren't we interpreting the PHY provisioning somewhat
> > too conservatively in this case, or do you believe that this is just an
> > academic concern?
> 
> Do you have a better idea how to come up with a list of link modes that
> the PHY should advertise to its link partner and also report as
> supported given the combination of:
> 
> - PHYs that switch their host interface
> - PHYs that may support some kind of rate adaption
> - PCS/MACs that may support half-duplex at some speeds
> - PCS/MACs that might support pause modes, and might support them only
>   with certain interface modes
> 
> Layered on top of that is being able to determine which interface a PHY/
> PCS/MAC should be using when e.g. a 10G copper PHY is inserted (which
> could be inserted into a host which only supports up to 1G.)
> 
> I've spent considerable time trying to work out a solution to this, and
> even before we had rate adaption, it isn't easy to solve. I've
> experimented with several different solutions, and it's from numerous
> trials that led to this host_interfaces/mac_capabilities structure -
> but that still doesn't let us solve the problems I mention above since
> we have no idea what the PHY itself is capable of, or how it's going to
> behave, or really which interface modes it might switch between if it's
> a clause 45 PHY.
> 
> I've experimented with adding phy->supported_interfaces so a phylib
> driver can advertise what interfaces it supports. I've also
> experimented with phy->possible_interfaces which reports the interface
> modes that the PHY _is_ going to switch between having selected its
> operating mode. I've not submitted them because even with this, it all
> still seems rather inadequate - and there is a huge amount of work to
> update all the phylib drivers to provide even that basic information,
> let alone have much confidence that it is correct.
> 
> You can find these experiments, as normal, in my net-queue branch in
> my git tree. These date from before we had rate adaption, so they take
> no account of the recent addition of this extra variable.

Don't we actually need an API for the PHY resembling the following?

struct phy_host_cfg {
	phy_interface_t interface;
	int rate_matching;
};

/* Caller must kfree() @host_cfg */
int phy_get_host_cfg_for_linkmode(struct phy_device *phydev,
				  enum ethtool_link_mode_bit_indices linkmode,
				  struct phy_host_cfg **host_cfg,
				  int *num_host_cfg)
{
	if (!phydev->drv->get_host_cfg_for_linkmode) {
		/* Assume that PHYs can't change host interface and don't
		 * support rate matching
		 */
		*host_cfg = kcalloc(sizeof(*host_cfg), GFP_KERNEL);
		*num_host_cfg = 1;
		*host_cfg[0].interface = phydev->interface;
		*host_cfg[0].rate_matching = RATE_MATCH_NONE;

		return 0;
	}

	return phydev->drv->get_host_cfg_for_linkmode(phydev, linkmode,
						      host_cfg, num_host_cfg);
}

/* Calling this is only necessary if @num_host_cfg returned by
 * phy_get_host_cfg_for_linkmode() is larger than 1.
 */
int phy_set_host_cfg_for_linkmode(struct phy_device *phydev,
				  enum ethtool_link_mode_bit_indices linkmode,
				  const struct phy_host_cfg *host_cfg)
{
	if (!phydev->drv->set_host_cfg_for_linkmode)
		return -EOPNOTSUPP;

	return phydev->drv->set_host_cfg_for_linkmode(phydev, linkmode,
						      host_cfg);
}

Based on the host_cfg array returned by the PHY for each link mode,
phylink could figure out (by intersecting with the MAC/PCS's
host_interfaces/mac_capabilities) what should be advertised and what
shouldn't.
