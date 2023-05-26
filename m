Return-Path: <netdev+bounces-5603-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EF2D47123CD
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 11:37:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB1191C21268
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 09:37:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3449A111B5;
	Fri, 26 May 2023 09:37:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23712111A9
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:37:14 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C839B3;
	Fri, 26 May 2023 02:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=lx0ds+NA3xAdktV/+qI+uQjfPSAugxF64sbR87ZVzHk=; b=rSkZTa8PVO25aZ9VHo8dGT4BdR
	pD+JQ7m3gCrXtuFQ2HT9Z27UNYPc5wwXoqySM9RqPOs33KqBLbu/cU5SPkzJw+r7a3Y4L2tfmxY6z
	H1H+sQbV/72vqFjDQI4mWg25VtciFObD1uAji1iw1ra2e7erNCfC+4i0yzKwcxj0kk5+SJiXV85EQ
	XiEdgv/QhOMHyoFtSbYt3lApDyuRqc32dURx1M3hA+7z1OsoN7b6jECFihI6cA6ylWphAW6CIs2lV
	NGevqKAKJUIjA90dGIoMiT8IKeCIr3J+SFfV47gQIv4TljovH9wzVIWHlNNo98J116SlVHLxDoJca
	BeZJ3tfg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:40724)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q2Tsi-0005Jl-FV; Fri, 26 May 2023 10:37:08 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q2Tse-0003c9-R4; Fri, 26 May 2023 10:37:04 +0100
Date: Fri, 26 May 2023 10:37:04 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Jiawen Wu <jiawenwu@trustnetic.com>
Cc: 'Jakub Kicinski' <kuba@kernel.org>, netdev@vger.kernel.org,
	jarkko.nikula@linux.intel.com, andriy.shevchenko@linux.intel.com,
	mika.westerberg@linux.intel.com, jsd@semihalf.com,
	Jose.Abreu@synopsys.com, andrew@lunn.ch, hkallweit1@gmail.com,
	linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
	mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next v9 8/9] net: txgbe: Implement phylink pcs
Message-ID: <ZHB9wJSgfQctd2aX@shell.armlinux.org.uk>
References: <20230524091722.522118-1-jiawenwu@trustnetic.com>
 <20230524091722.522118-9-jiawenwu@trustnetic.com>
 <20230525211403.44b5f766@kernel.org>
 <022201d98f9a$4b4ccc00$e1e66400$@trustnetic.com>
 <ZHBxJP4DXevPNpab@shell.armlinux.org.uk>
 <026901d98fb0$b5001d80$1f005880$@trustnetic.com>
 <ZHB2vXBP1B2iHXBl@shell.armlinux.org.uk>
 <026a01d98fb3$97e3d8b0$c7ab8a10$@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <026a01d98fb3$97e3d8b0$c7ab8a10$@trustnetic.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 05:22:29PM +0800, Jiawen Wu wrote:
> On Friday, May 26, 2023 5:07 PM, Russell King (Oracle) wrote:
> > On Fri, May 26, 2023 at 05:01:49PM +0800, Jiawen Wu wrote:
> > > On Friday, May 26, 2023 4:43 PM, Russell King (Oracle) wrote:
> > > > On Fri, May 26, 2023 at 02:21:23PM +0800, Jiawen Wu wrote:
> > > > > On Friday, May 26, 2023 12:14 PM, Jakub Kicinski wrote:
> > > > > > On Wed, 24 May 2023 17:17:21 +0800 Jiawen Wu wrote:
> > > > > > > +	ret = devm_mdiobus_register(&pdev->dev, mii_bus);
> > > > > > > +	if (ret)
> > > > > > > +		return ret;
> > > > > > > +
> > > > > > > +	mdiodev = mdio_device_create(mii_bus, 0);
> > > > > > > +	if (IS_ERR(mdiodev))
> > > > > > > +		return PTR_ERR(mdiodev);
> > > > > > > +
> > > > > > > +	xpcs = xpcs_create(mdiodev, PHY_INTERFACE_MODE_10GBASER);
> > > > > > > +	if (IS_ERR(xpcs)) {
> > > > > > > +		mdio_device_free(mdiodev);
> > > > > > > +		return PTR_ERR(xpcs);
> > > > > > > +	}
> > > > > >
> > > > > > How does the mdiodev get destroyed in case of success?
> > > > > > Seems like either freeing it in case of xpcs error is unnecessary
> > > > > > or it needs to also be freed when xpcs is destroyed?
> > > > >
> > > > > When xpcs is destroyed, that means mdiodev is no longer needed.
> > > > > I think there is no need to free mdiodev in case of xpcs error,
> > > > > since devm_* function leads to free it.
> > > >
> > > > If you are relying on the devm-ness of devm_mdiobus_register() then
> > > > it won't. Although mdiobus_unregister() walks bus->mdio_map[], I
> > > > think you are assuming that the mdio device you've created in
> > > > mdio_device_create() will be in that array. MDIO devices only get
> > > > added to that array when mdiobus_register_device() has been called,
> > > > which must only be called from mdio_device_register().
> > > >
> > > > Please arrange to call mdio_device_free() prior to destroying the
> > > > XPCS in every case.
> > >
> > > Get it.
> > 
> > It seems this is becoming a pattern, so I think we need to solve it
> > differently. How about something like this, which means you only have
> > to care about calling xpcs_create_mdiodev() and xpcs_destroy() ?
> > 
> > diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
> > index b87c69c4cdd7..802222581feb 100644
> > --- a/drivers/net/pcs/pcs-xpcs.c
> > +++ b/drivers/net/pcs/pcs-xpcs.c
> > @@ -1240,6 +1240,7 @@ struct dw_xpcs *xpcs_create(struct mdio_device *mdiodev,
> >  	if (!xpcs)
> >  		return ERR_PTR(-ENOMEM);
> > 
> > +	mdio_device_get(mdiodev);
> >  	xpcs->mdiodev = mdiodev;
> > 
> >  	xpcs_id = xpcs_get_id(xpcs);
> > @@ -1272,6 +1273,7 @@ struct dw_xpcs *xpcs_create(struct mdio_device *mdiodev,
> >  	ret = -ENODEV;
> > 
> >  out:
> > +	mdio_device_put(mdiodev);
> >  	kfree(xpcs);
> > 
> >  	return ERR_PTR(ret);
> > @@ -1280,8 +1282,33 @@ EXPORT_SYMBOL_GPL(xpcs_create);
> > 
> >  void xpcs_destroy(struct dw_xpcs *xpcs)
> >  {
> > +	mdio_device_put(mdiodev);
> >  	kfree(xpcs);
> >  }
> >  EXPORT_SYMBOL_GPL(xpcs_destroy);
> > 
> > +struct dw_xpcs *xpcs_create_mdiodev(struct mii_bus *bus, int addr,
> > +				    phy_interface_t interface)
> > +{
> > +	struct mdio_device *mdiodev;
> > +	struct dw_xpcs *xpcs;
> > +
> > +	mdiodev = mdio_device_create(bus, addr);
> > +	if (IS_ERR(mdiodev))
> > +		return ERR_CAST(mdiodev);
> > +
> > +	xpcs = xpcs_create(mdiodev, interface);
> > +
> > +	/* xpcs_create() has taken a refcount on the mdiodev if it was
> > +	 * successful. If xpcs_create() fails, this will free the mdio
> > +	 * device here. In any case, we don't need to hold our reference
> > +	 * anymore, and putting it here will allow mdio_device_put() in
> > +	 * xpcs_destroy() to automatically free the mdio device.
> > +	 */
> > +	mdio_device_put(mdiodev);
> > +
> > +	return xpcs;
> > +}
> > +EXPORT_SYMBOL_GPL(xpcs_create_mdiodev);
> > +
> >  MODULE_LICENSE("GPL v2");
> > diff --git a/include/linux/mdio.h b/include/linux/mdio.h
> > index 1d7d550bbf1a..537b62330c90 100644
> > --- a/include/linux/mdio.h
> > +++ b/include/linux/mdio.h
> > @@ -108,6 +108,16 @@ int mdio_driver_register(struct mdio_driver *drv);
> >  void mdio_driver_unregister(struct mdio_driver *drv);
> >  int mdio_device_bus_match(struct device *dev, struct device_driver *drv);
> > 
> > +static inline void mdio_device_get(struct mdio_device *mdiodev)
> > +{
> > +	get_device(&mdiodev->dev);
> > +}
> > +
> > +static inline void mdio_device_put(struct mdio_device *mdiodev)
> > +{
> > +	mdio_device_free(mdiodev);
> > +}
> > +
> >  static inline bool mdio_phy_id_is_c45(int phy_id)
> >  {
> >  	return (phy_id & MDIO_PHY_ID_C45) && !(phy_id & ~MDIO_PHY_ID_C45_MASK);
> 
> Looks great, it can eliminate to create mdiodev in the ethernet driver, this device
> only be used in xpcs.

I'm just creating a patch series for both xpcs and lynx, which this
morning have had patches identifying similar problems with creation
and destruction.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

