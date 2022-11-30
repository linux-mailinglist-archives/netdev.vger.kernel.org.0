Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE7263D02B
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 09:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234433AbiK3INh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 30 Nov 2022 03:13:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233439AbiK3INe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 03:13:34 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA8614FFA1
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 00:13:33 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1p0IDe-0008Il-7F; Wed, 30 Nov 2022 09:13:26 +0100
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1p0IDb-000671-Bb; Wed, 30 Nov 2022 09:13:23 +0100
Date:   Wed, 30 Nov 2022 09:13:23 +0100
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
Subject: Re: [PATCH v4 07/11] wifi: rtw88: Add common USB chip support
Message-ID: <20221130081323.GE29728@pengutronix.de>
References: <20221129100754.2753237-1-s.hauer@pengutronix.de>
 <20221129100754.2753237-8-s.hauer@pengutronix.de>
 <4eee82341ef84d4aa063edeb6f23a70d@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <4eee82341ef84d4aa063edeb6f23a70d@realtek.com>
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
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 30, 2022 at 01:40:36AM +0000, Ping-Ke Shih wrote:
> 
> 
> > -----Original Message-----
> > From: Sascha Hauer <s.hauer@pengutronix.de>
> > Sent: Tuesday, November 29, 2022 6:08 PM
> > To: linux-wireless@vger.kernel.org
> > Cc: Neo Jou <neojou@gmail.com>; Hans Ulli Kroll <linux@ulli-kroll.de>; Ping-Ke Shih <pkshih@realtek.com>;
> > Yan-Hsuan Chuang <tony0620emma@gmail.com>; Kalle Valo <kvalo@kernel.org>; netdev@vger.kernel.org;
> > linux-kernel@vger.kernel.org; Martin Blumenstingl <martin.blumenstingl@googlemail.com>;
> > kernel@pengutronix.de; Johannes Berg <johannes@sipsolutions.net>; Alexander Hochbaum <alex@appudo.com>;
> > Da Xue <da@libre.computer>; Bernie Huang <phhuang@realtek.com>; Viktor Petrenko <g0000ga@gmail.com>;
> > Sascha Hauer <s.hauer@pengutronix.de>; neo_jou <neo_jou@realtek.com>
> > Subject: [PATCH v4 07/11] wifi: rtw88: Add common USB chip support
> > 
> > Add the common bits and pieces to add USB support to the RTW88 driver.
> > This is based on https://github.com/ulli-kroll/rtw88-usb.git which
> > itself is first written by Neo Jou.
> > 
> > Signed-off-by: neo_jou <neo_jou@realtek.com>
> > Signed-off-by: Hans Ulli Kroll <linux@ulli-kroll.de>
> > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > ---
> 
> > +static void rtw_usb_write_port_tx_complete(struct urb *urb)
> > +{
> > +	struct rtw_usb_txcb *txcb = urb->context;
> > +	struct rtw_dev *rtwdev = txcb->rtwdev;
> > +	struct ieee80211_hw *hw = rtwdev->hw;
> > +	int max_iter = RTW_USB_MAX_XMITBUF_SZ;
> > +
> > +	while (true) {
> > +		struct sk_buff *skb = skb_dequeue(&txcb->tx_ack_queue);
> > +		struct ieee80211_tx_info *info;
> > +		struct rtw_usb_tx_data *tx_data;
> > +
> > +		if (!skb)
> > +			break;
> > +
> > +		if (!--max_iter) {
> 
> Don't you need to free 'skb'? or you should not dequeue skb in this situation?

My first reaction here was to call skb_queue_purge(), but that is
implemented as:

	while ((skb = skb_dequeue(list)) != NULL)
		kfree_skb(skb);

So basically it brings us into the same endless loop we are trying to
break out here.

If it was me I would just remove this check. *txcb is allocated once
in rtw_usb_tx_agg_skb(), &txcb->tx_ack_queue is added the number of skbs
that fit into RTW_USB_MAX_XMITBUF_SZ and here we dequeue these skbs
again. No other code even has the pointer to add skbs to this queue
concurrently.

Sascha


-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
