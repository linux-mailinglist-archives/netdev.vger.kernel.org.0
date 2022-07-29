Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 806FB585377
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 18:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234338AbiG2Qca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 12:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiG2Qc2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 12:32:28 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A1C811C2E
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 09:32:27 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oHSuU-0000YK-3x; Fri, 29 Jul 2022 18:32:22 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oHSuS-00013U-EU; Fri, 29 Jul 2022 18:32:20 +0200
Date:   Fri, 29 Jul 2022 18:32:20 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        Eric Dumazet <edumazet@google.com>, kernel@pengutronix.de,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net v1 1/1] net: dsa: microchip: KSZ9893: do not write to
 not supported Output Clock Control Register
Message-ID: <20220729163220.GE10850@pengutronix.de>
References: <20220728131852.41518-1-o.rempel@pengutronix.de>
 <20220728222316.1d538cb3@kernel.org>
 <20220729094840.GB10850@pengutronix.de>
 <20220729084149.5a061772@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220729084149.5a061772@kernel.org>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 29, 2022 at 08:41:49AM -0700, Jakub Kicinski wrote:
> On Fri, 29 Jul 2022 11:48:40 +0200 Oleksij Rempel wrote:
> > On Thu, Jul 28, 2022 at 10:23:16PM -0700, Jakub Kicinski wrote:
> > > On Thu, 28 Jul 2022 15:18:52 +0200 Oleksij Rempel wrote:  
> > > > KSZ9893 compatible chips do not have "Output Clock Control Register 0x0103".
> > > > So, avoid writing to it.  
> > > 
> > > Respin will be needed regardless of the answer to Andrew - patch does
> > > not apply.  
> > 
> > Hm, this driver was hardly refactored in net-next. I'll better send it
> > against net-next otherwise things will break.
> 
> Probably fine either way, with the net-next patch (i.e. this patch) 
> on the list we shouldn't have problems resolving the conflict correctly.
> 
> The real question is whether it's okay for 5.19 to not have this patch.
> It'd be good to have the user-visible impact specified in the commit
> message.

So far I'm not aware about issues related to this, only warning in the data
sheet:
"RESERVED address space must not be written under any circumstances. Failure
to heed this warning may result in untoward operation and unexpected results."

I have send this patch as part of register access validation patch set.
There are move fixes any way.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
