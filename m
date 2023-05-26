Return-Path: <netdev+bounces-5799-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B14F4712C5D
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 20:20:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 663AD1C210F9
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 18:20:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBE7D290FE;
	Fri, 26 May 2023 18:20:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0FD715BD
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 18:20:23 +0000 (UTC)
Received: from fgw22-7.mail.saunalahti.fi (fgw22-7.mail.saunalahti.fi [62.142.5.83])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B5DD3
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 11:20:22 -0700 (PDT)
Received: from localhost (88-113-26-95.elisa-laajakaista.fi [88.113.26.95])
	by fgw22.mail.saunalahti.fi (Halon) with ESMTP
	id f7b7cffa-fbf1-11ed-a9de-005056bdf889;
	Fri, 26 May 2023 21:20:19 +0300 (EEST)
From: andy.shevchenko@gmail.com
Date: Fri, 26 May 2023 21:20:17 +0300
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/6] net: mdio: add mdio_device_get() and
 mdio_device_put()
Message-ID: <ZHD4Yaf7fgtgOgTS@surfacebook>
References: <ZHCGZ8IgAAwr8bla@shell.armlinux.org.uk>
 <E1q2USm-008PAO-Gx@rmk-PC.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1q2USm-008PAO-Gx@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
	SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Fri, May 26, 2023 at 11:14:24AM +0100, Russell King (Oracle) kirjoitti:
> Add two new operations for a mdio device to manage the refcount on the
> underlying struct device. This will be used by mdio PCS drivers to
> simplify the creation and destruction handling, making it easier for
> users to get it correct.

...

> +static inline void mdio_device_get(struct mdio_device *mdiodev)
> +{
> +	get_device(&mdiodev->dev);

Dunno what is the practice in net, but it makes sense to have the pattern as

	if (mdiodev)
		return to_mdiodev(get_device(&mdiodev->dev));

which might be helpful in some cases. This approach is used in many cases in
the kernel.

> +}

P.S. Just my 2c, you may ignore the above comment.

-- 
With Best Regards,
Andy Shevchenko



