Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 880D363A618
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 11:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbiK1KaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 05:30:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbiK1KaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 05:30:12 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8014316580
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 02:30:11 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1ozbOl-0006ch-65; Mon, 28 Nov 2022 11:30:03 +0100
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1ozbOi-0000Jf-Qm; Mon, 28 Nov 2022 11:30:00 +0100
Date:   Mon, 28 Nov 2022 11:30:00 +0100
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Neo Jou <neojou@gmail.com>,
        Hans Ulli Kroll <linux@ulli-kroll.de>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Johannes Berg <johannes@sipsolutions.net>,
        Alexander Hochbaum <alex@appudo.com>,
        Da Xue <da@libre.computer>, Bernie Huang <phhuang@realtek.com>,
        Viktor Petrenko <g0000ga@gmail.com>,
        neo_jou <neo_jou@realtek.com>
Subject: Re: [PATCH v3 07/11] rtw88: Add common USB chip support
Message-ID: <20221128103000.GC29728@pengutronix.de>
References: <20221122145226.4065843-1-s.hauer@pengutronix.de>
 <20221122145226.4065843-8-s.hauer@pengutronix.de>
 <1f7aa964766c4f65b836f7e1d716a1e3@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f7aa964766c4f65b836f7e1d716a1e3@realtek.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 28, 2022 at 02:00:54AM +0000, Ping-Ke Shih wrote:
> 
> 
> > -----Original Message-----
> > From: Sascha Hauer <s.hauer@pengutronix.de>
> > Sent: Tuesday, November 22, 2022 10:52 PM
> > To: linux-wireless@vger.kernel.org
> > Cc: Neo Jou <neojou@gmail.com>; Hans Ulli Kroll <linux@ulli-kroll.de>; Ping-Ke Shih <pkshih@realtek.com>;
> > Yan-Hsuan Chuang <tony0620emma@gmail.com>; Kalle Valo <kvalo@kernel.org>; netdev@vger.kernel.org;
> > linux-kernel@vger.kernel.org; Martin Blumenstingl <martin.blumenstingl@googlemail.com>;
> > kernel@pengutronix.de; Johannes Berg <johannes@sipsolutions.net>; Alexander Hochbaum <alex@appudo.com>;
> > Da Xue <da@libre.computer>; Bernie Huang <phhuang@realtek.com>; Viktor Petrenko <g0000ga@gmail.com>;
> > Sascha Hauer <s.hauer@pengutronix.de>; neo_jou <neo_jou@realtek.com>
> > Subject: [PATCH v3 07/11] rtw88: Add common USB chip support
> > 
> > Add the common bits and pieces to add USB support to the RTW88 driver.
> > This is based on https://github.com/ulli-kroll/rtw88-usb.git which
> > itself is first written by Neo Jou.
> > 
> > Signed-off-by: neo_jou <neo_jou@realtek.com>
> > Signed-off-by: Hans Ulli Kroll <linux@ulli-kroll.de>
> > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > ---
> > 
> > Notes:
> >     Changes since v2:
> >     - Fix buffer length for aggregated tx packets
> >     - Increase maximum transmit buffer size to 20KiB as found in downstream drivers
> >     - Change register write functions to synchronous accesses instead of just firing
> >       a URB without waiting for its completion
> >     - requeue rx URBs directly in completion handler rather than having a workqueue
> >       for it.
> > 
> >     Changes since v1:
> >     - Make checkpatch.pl clean
> >     - Drop WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL flag
> >     - Use 'ret' as variable name for return values
> >     - Sort variable declarations in reverse Xmas tree order
> >     - Change potentially endless loop to a limited loop
> >     - Change locking to be more obviously correct
> >     - drop unnecessary check for !rtwdev
> >     - make sure the refill workqueue is not restarted again after we have
> >       cancelled it
> > 
> >  drivers/net/wireless/realtek/rtw88/Kconfig  |   3 +
> >  drivers/net/wireless/realtek/rtw88/Makefile |   2 +
> >  drivers/net/wireless/realtek/rtw88/mac.c    |   3 +
> >  drivers/net/wireless/realtek/rtw88/main.c   |   4 +
> >  drivers/net/wireless/realtek/rtw88/main.h   |   4 +
> >  drivers/net/wireless/realtek/rtw88/reg.h    |   1 +
> >  drivers/net/wireless/realtek/rtw88/tx.h     |  31 +
> >  drivers/net/wireless/realtek/rtw88/usb.c    | 918 ++++++++++++++++++++
> >  drivers/net/wireless/realtek/rtw88/usb.h    | 107 +++
> >  9 files changed, 1073 insertions(+)
> >  create mode 100644 drivers/net/wireless/realtek/rtw88/usb.c
> >  create mode 100644 drivers/net/wireless/realtek/rtw88/usb.h
> > 
> > diff --git a/drivers/net/wireless/realtek/rtw88/Kconfig b/drivers/net/wireless/realtek/rtw88/Kconfig
> > index e3d7cb6c12902..1624c5db69bac 100644
> > --- a/drivers/net/wireless/realtek/rtw88/Kconfig
> > +++ b/drivers/net/wireless/realtek/rtw88/Kconfig
> > @@ -16,6 +16,9 @@ config RTW88_CORE
> >  config RTW88_PCI
> >  	tristate
> > 
> > +config RTW88_USB
> > +	tristate
> > +
> >  config RTW88_8822B
> >  	tristate
> > 
> > diff --git a/drivers/net/wireless/realtek/rtw88/Makefile b/drivers/net/wireless/realtek/rtw88/Makefile
> > index 834c66ec0af9e..9e095f8181483 100644
> > --- a/drivers/net/wireless/realtek/rtw88/Makefile
> > +++ b/drivers/net/wireless/realtek/rtw88/Makefile
> > @@ -45,4 +45,6 @@ obj-$(CONFIG_RTW88_8821CE)	+= rtw88_8821ce.o
> >  rtw88_8821ce-objs		:= rtw8821ce.o
> > 
> >  obj-$(CONFIG_RTW88_PCI)		+= rtw88_pci.o
> > +obj-$(CONFIG_RTW88_USB)		+= rtw88_usb.o
> >  rtw88_pci-objs			:= pci.o
> > +rtw88_usb-objs			:= usb.o
> 
> nit: I prefer not interleaving with PCI.

Ok.

> > +static u32 rtw_usb_read(struct rtw_dev *rtwdev, u32 addr, u16 len)
> > +{
> > +	struct rtw_usb *rtwusb = rtw_get_usb_priv(rtwdev);
> > +	struct usb_device *udev = rtwusb->udev;
> > +	__le32 *data;
> > +	unsigned long flags;
> > +	int ret;
> > +	static int count;
> > +
> > +	spin_lock_irqsave(&rtwusb->usb_lock, flags);
> > +
> > +	rtwusb->usb_data_index++;
> > +	rtwusb->usb_data_index &= (RTW_USB_MAX_RXTX_COUNT - 1);
> > +
> > +	spin_unlock_irqrestore(&rtwusb->usb_lock, flags);
> > +
> > +	data = &rtwusb->usb_data[rtwusb->usb_data_index];
> 
> Don't you need to hold &rtwusb->usb_lock to access rtwusb->usb_data_index?
> rtw_usb_write() has similar code.

Right. Will rewrite to:

	spin_lock_irqsave(&rtwusb->usb_lock, flags);

	idx = rtwusb->usb_data_index;
	rtwusb->usb_data_index = (idx + 1) & (RTW_USB_MAX_RXTX_COUNT - 1);

	spin_unlock_irqrestore(&rtwusb->usb_lock, flags);

	data = &rtwusb->usb_data[idx];

> > +static void rtw_usb_write_port_tx_complete(struct urb *urb)
> > +{
> > +	struct rtw_usb_txcb *txcb = urb->context;
> > +	struct rtw_dev *rtwdev = txcb->rtwdev;
> > +	struct ieee80211_hw *hw = rtwdev->hw;
> > +
> > +	while (true) {
> 
> Is it possible to have a hard limit to prevent unexpected infinite loop?

Yes, that would be possible, but do you think it's necessary?

Each *txcb is used only once, It's allocated in rtw_usb_tx_agg_skb() and
&txcb->tx_ack_queue is filled with a limited number of skbs there. These
skbs is then iterated over in rtw_usb_write_port_tx_complete(), so I don't
see a way how we could end up in an infinite loop here.

It's not that &txcb->tx_ack_queue is filled in a concurrent thread while we
try to catch up in rtw_usb_write_port_tx_complete().

> > +	skb_head = dev_alloc_skb(RTW_USB_MAX_XMITBUF_SZ);
> > +	if (!skb_head) {
> > +		skb_head = skb_iter;
> > +		goto queue;
> > +	}
> > +
> > +	data_ptr = skb_head->data;
> > +
> > +	while (skb_iter) {
> > +		unsigned long flags;
> > +
> > +		memcpy(data_ptr, skb_iter->data, skb_iter->len);
> > +		skb_put(skb_head, skb_iter->len + align_next);
> 
> skb_put(skb_head, align_next);
> skb_put_data(skb_head, skb_iter->data, skb_iter->len);
> 
> Then, don't need to maintain 'data_ptr'.

Right. Looks much better this way.

> > +	error = usb_submit_urb(rxcb->rx_urb, GFP_ATOMIC);
> > +	if (error) {
> > +		kfree_skb(rxcb->rx_skb);
> > +		if (error != -ENODEV)
> > +			rtw_err(rtwdev, "Err sending rx data urb %d\n",
> > +				error);
> 
> nit: straighten rtw_err()

Ok.

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
