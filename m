Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7ED6C0B4D
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 08:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbjCTHZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 03:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjCTHZH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 03:25:07 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48DE61CAE4;
        Mon, 20 Mar 2023 00:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679297106; x=1710833106;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=sckrP9DIwS5nXONc32/B3DuRvwTDeY7P3PNd34uwKrc=;
  b=J1/Q4IL1YY9vEXAgBwR34VF7uHoziVlHDatzQ2dmgUZFL5rl3FxsmlW3
   5+z3dXA8BnxVerG9o+Wb7EQXOxTErozoAe1ThgidnaHGYgmHhoZZ87bdH
   Ai2KYUxU5XG11x2ALijX44SFlP7bew5py5JmvfvDHrmKoOZquyxJ13P9F
   suYiXy3OC7k5caPWEe1sT5eNIg7DlASNyNbjoJwn4AsHBecSjGYwBUmlo
   qMyBtS0f6z792fxRsWv0VOB8tKjCFYkUontzxpmVqOZY9VSeOlwcnD69b
   riQQCsqctllN+g7xzldt6ERYK3z5xeDVXsCHi4diem4+ZFVEJyh6ROCGI
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="403465133"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="403465133"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 00:25:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="711221338"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="711221338"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 00:25:02 -0700
Date:   Mon, 20 Mar 2023 08:24:58 +0100
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     Peter Hong <peter_hong@fintek.com.tw>
Cc:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        mailhol.vincent@wanadoo.fr, frank.jungclaus@esd.eu,
        linux-kernel@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, hpeter+linux_kernel@gmail.com
Subject: Re: [PATCH] can: usb: f81604: add Fintek F81604 support
Message-ID: <ZBgKSqaFiImtTThv@localhost.localdomain>
References: <20230317093352.3979-1-peter_hong@fintek.com.tw>
 <ZBRoCVHV3S3ugEoO@localhost.localdomain>
 <186901f9-5d52-2315-f532-26471adcfb55@fintek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <186901f9-5d52-2315-f532-26471adcfb55@fintek.com.tw>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 10:59:33AM +0800, Peter Hong wrote:
> Hi,
> 
> Michal Swiatkowski 於 2023/3/17 下午 09:15 寫道:
> > On Fri, Mar 17, 2023 at 05:33:52PM +0800, Ji-Ze Hong (Peter Hong) wrote:
> > 
> > --- a/drivers/net/can/usb/Kconfig
> > +++ b/drivers/net/can/usb/Kconfig
> > @@ -147,4 +147,13 @@ config CAN_UCAN
> >   	          from Theobroma Systems like the A31-ÂľQ7 and the RK3399-Q7
> >   	          (https://www.theobroma-systems.com/rk3399-q7)
> > Hi,
> > 
> > I am not familiar with CAN, so only style review :)
> 
> Thanks for your reviews :D
> > +
> > +	if (status) {
> > +		dev_err(&dev->dev, "%s: reg: %x data: %x failed: %d\n",
> > +			__func__, reg, data, status);
> > +	}
> > The { and } aren't needed as inside if is only one line.
> 
> Could I remove the { and } when the logical line to split multi-line ?
> 

Yes You can, and You should :)

> > > +static int f81604_set_normal_mode(struct net_device *netdev)
> > > +{
> > > +	struct f81604_port_priv *priv = netdev_priv(netdev);
> > > +	int status, i;
> > > +	u8 mod_reg_val = 0x00;
> > RCT, mod_reg should be one line above
> 
> What mean about "RCT"?
> 
> Is this section should change to above like ??
> 
>     u8 mod_reg_val;
>     ...
> 
>     mod_reg_val = 0;

reverse christmas tree, it is about how variable definition should look
like. In Your case:

struct f81604_port_priv *priv = netdev_priv(netdev);
u8 mod_reg_val = 0x00;
int status, i;

instead of


struct f81604_port_priv *priv = netdev_priv(netdev);
int status, i;
u8 mod_reg_val = 0x00;

Cosmetic Linux style rule

> > > +static int f81604_register_urbs(struct net_device *netdev)
> > > +{
> > > +	struct f81604_port_priv *priv = netdev_priv(netdev);
> > > +	int status, i;
> > > +
> > > +	for (i = 0; i < F81604_MAX_RX_URBS; ++i) {
> > > +		status = usb_submit_urb(priv->read_urb[i], GFP_KERNEL);
> > > +		if (status) {
> > > +			netdev_warn(netdev, "%s: submit rx urb failed: %d\n",
> > > +				    __func__, status);
> > > +			return status;
> > Don't know usb subsytem, but shouldn't previously submitted urb be
> > killed?
> 
> Yes, I had made kill operations in
>     f81604_start()
>         -> f81604_unregister_urbs()
>

Ok, thanks

> > > +static void f81604_process_rx_packet(struct urb *urb)
> > > +{
> > > +	struct net_device_stats *stats;
> > > +	struct net_device *netdev;
> > > +	struct can_frame *cf;
> > > +	struct sk_buff *skb;
> > > +	u8 *data;
> > > +	u8 *ptr;
> > > +	int i;
> > > +	int count;
> > RCT
> > 
> > > +
> > > +	netdev = urb->context;
> > > +	stats = &netdev->stats;
> > > +	data = urb->transfer_buffer;
> > netdev and data can be set in declaration
> 
> why only netdev & data ?? Could I set netdev, stats & data in declaration ?
> 

You can, but it will be hard to still have declaration as RCT (netdev
declaration have to be before stats declaration).

> 
> > > +/* Called by the usb core when driver is unloaded or device is removed */
> > > +static void f81604_disconnect(struct usb_interface *intf)
> > > +{
> > > +	struct f81604_priv *priv = usb_get_intfdata(intf);
> > > +	int i;
> > > +
> > > +	for (i = 0; i < F81604_MAX_DEV; ++i) {
> > > +		if (!priv->netdev[i])
> > > +			continue;
> > > +
> > > +		unregister_netdev(priv->netdev[i]);
> > > +		free_candev(priv->netdev[i]);
> > > +	}
> > What about closing USB device? It is called brefore disconnect or it
> > should be done here?
> 
> When candev close in f81604_close(), It will call f81604_set_reset_mode() to
> make candev to reset mode.
> 

Understand, thanks

> Thanks
