Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E392F520CEB
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 06:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236193AbiEJEdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 00:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236675AbiEJEbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 00:31:36 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2C334C7A4
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 21:26:28 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1noHRr-00070V-Nc; Tue, 10 May 2022 06:26:11 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1noHRp-0007KV-SV; Tue, 10 May 2022 06:26:09 +0200
Date:   Tue, 10 May 2022 06:26:09 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Devid Antonio Filoni <devid.filoni@egluetechnologies.com>,
        Robin van der Gracht <robin@protonic.nl>,
        kernel@pengutronix.de, linux-can@vger.kernel.org,
        Oleksij Rempel <linux@rempel-privat.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Jayat <maxime.jayat@mobile-devices.fr>,
        kbuild test robot <lkp@intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] can: j1939: do not wait 250ms if the same addr
 was already claimed
Message-ID: <20220510042609.GA10669@pengutronix.de>
References: <20220509170303.29370-1-devid.filoni@egluetechnologies.com>
 <YnllpntZ8V5CD07v@x1.vandijck-laurijssen.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YnllpntZ8V5CD07v@x1.vandijck-laurijssen.be>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 06:19:23 up 40 days, 16:49, 62 users,  load average: 0.01, 0.09,
 0.08
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, May 09, 2022 at 09:04:06PM +0200, Kurt Van Dijck wrote:
> On ma, 09 mei 2022 19:03:03 +0200, Devid Antonio Filoni wrote:
> > This is not explicitly stated in SAE J1939-21 and some tools used for
> > ISO-11783 certification do not expect this wait.

It will be interesting to know which certification tool do not expect it and
what explanation is used if it fails?

> IMHO, the current behaviour is not explicitely stated, but nor is the opposite.
> And if I'm not mistaken, this introduces a 250msec delay.
> 
> 1. If you want to avoid the 250msec gap, you should avoid to contest the same address.
> 
> 2. It's a balance between predictability and flexibility, but if you try to accomplish both,
> as your patch suggests, there is slight time-window until the current owner responds,
> in which it may be confusing which node has the address. It depends on how much history
> you have collected on the bus.
> 
> I'm sure that this problem decreases with increasing processing power on the nodes,
> but bigger internal queues also increase this window.
> 
> It would certainly help if you describe how the current implementation fails.
> 
> Would decreasing the dead time to 50msec help in such case.
> 
> Kind regards,
> Kurt
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
