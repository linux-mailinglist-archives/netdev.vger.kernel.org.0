Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6C0B520522
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 21:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240499AbiEITUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 15:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240474AbiEITUB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 15:20:01 -0400
X-Greylist: delayed 711 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 09 May 2022 12:16:04 PDT
Received: from relay-b03.edpnet.be (relay-b03.edpnet.be [212.71.1.220])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A361A54BE3
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 12:16:03 -0700 (PDT)
X-ASG-Debug-ID: 1652123048-15c435381a966b00001-BZBGGp
Received: from srv21.vandijck-laurijssen.be (77.109.97.42.adsl.dyn.edpnet.net [77.109.97.42]) by relay-b03.edpnet.be with ESMTP id evQvZkMsT4fx48c7; Mon, 09 May 2022 21:04:08 +0200 (CEST)
X-Barracuda-Envelope-From: dev.kurt@vandijck-laurijssen.be
X-Barracuda-Effective-Source-IP: 77.109.97.42.adsl.dyn.edpnet.net[77.109.97.42]
X-Barracuda-Apparent-Source-IP: 77.109.97.42
Received: from x1.vandijck-laurijssen.be (x1.vandijck-laurijssen.be [IPv6:fd01::1a1d:eaff:fe02:d339])
        by srv21.vandijck-laurijssen.be (Postfix) with ESMTPSA id 0E1DA1063BE;
        Mon,  9 May 2022 21:04:08 +0200 (CEST)
Date:   Mon, 9 May 2022 21:04:06 +0200
From:   Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
To:     Devid Antonio Filoni <devid.filoni@egluetechnologies.com>
Cc:     Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
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
Message-ID: <YnllpntZ8V5CD07v@x1.vandijck-laurijssen.be>
X-ASG-Orig-Subj: Re: [PATCH RESEND] can: j1939: do not wait 250ms if the same addr
 was already claimed
Mail-Followup-To: Devid Antonio Filoni <devid.filoni@egluetechnologies.com>,
        Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-can@vger.kernel.org, Oleksij Rempel <linux@rempel-privat.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Maxime Jayat <maxime.jayat@mobile-devices.fr>,
        kbuild test robot <lkp@intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220509170303.29370-1-devid.filoni@egluetechnologies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220509170303.29370-1-devid.filoni@egluetechnologies.com>
X-Barracuda-Connect: 77.109.97.42.adsl.dyn.edpnet.net[77.109.97.42]
X-Barracuda-Start-Time: 1652123048
X-Barracuda-URL: https://212.71.1.220:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 1034
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.97894
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On ma, 09 mei 2022 19:03:03 +0200, Devid Antonio Filoni wrote:
> This is not explicitly stated in SAE J1939-21 and some tools used for
> ISO-11783 certification do not expect this wait.

IMHO, the current behaviour is not explicitely stated, but nor is the opposite.
And if I'm not mistaken, this introduces a 250msec delay.

1. If you want to avoid the 250msec gap, you should avoid to contest the same address.

2. It's a balance between predictability and flexibility, but if you try to accomplish both,
as your patch suggests, there is slight time-window until the current owner responds,
in which it may be confusing which node has the address. It depends on how much history
you have collected on the bus.

I'm sure that this problem decreases with increasing processing power on the nodes,
but bigger internal queues also increase this window.

It would certainly help if you describe how the current implementation fails.

Would decreasing the dead time to 50msec help in such case.

Kind regards,
Kurt
