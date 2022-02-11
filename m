Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7234B2088
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 09:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348189AbiBKIsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 03:48:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348187AbiBKIsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 03:48:07 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E9C7E54
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 00:48:06 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nIRb2-0001XS-Ha
        for netdev@vger.kernel.org; Fri, 11 Feb 2022 09:48:04 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nIRb2-005vqV-2k
        for netdev@vger.kernel.org; Fri, 11 Feb 2022 09:48:04 +0100
Date:   Fri, 11 Feb 2022 09:48:04 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     netdev@vger.kernel.org
Subject: packet stats validation
Message-ID: <YgYixOmTSI7jxALK@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:40:05 up 106 days, 15:07, 90 users,  load average: 1.72, 1.88,
 1.18
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

I'm implementing stats64 for the ksz switch and by validating my
implementation found different by count methods in different sub
systems. For example, i send 64 byte packet with:

mausezahn enp1s0f3 -c 1 -a rand -p 64

- tshark is recognizing 64 byte frame with 50 byte data
- Intel igb is counting it as 64 byte
- ksz9477 switch HW counter is counting it as 68 bytes packet
- linux bridge is counting it as 50 byte packet

Can you please help me to understand this differences?
Do linux bridge is doing it correct or it is a bug?
ksz9477 is probably adding a tag and counting tagged packets. Should
this number be provided to stats64?

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
