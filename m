Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFC85225451
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 23:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgGSVwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 17:52:04 -0400
Received: from lists.nic.cz ([217.31.204.67]:35082 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726126AbgGSVwE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Jul 2020 17:52:04 -0400
Received: from localhost (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id AC0E9140A89;
        Sun, 19 Jul 2020 23:52:02 +0200 (CEST)
Date:   Sun, 19 Jul 2020 23:52:02 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Chris Healy <cphealy@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>
Subject: Re: bug: net: dsa: mv88e6xxx: serdes Unable to communicate on fiber
 with vf610-zii-dev-rev-c
Message-ID: <20200719235202.6ee120b9@nic.cz>
In-Reply-To: <CAFXsbZrHRexg5zAsR1cah4p8HAZVc3tjKdMGKWO6Ha4jXux3QA@mail.gmail.com>
References: <CAFXsbZodM0W87aH=qeZCRDSwyNOAXwF=aO8zf1UpkhwNkSAczA@mail.gmail.com>
        <20200718164239.40ded692@nic.cz>
        <CAFXsbZoMcOQTY8HE+E359jT6Vsod3LiovTODpjndHKzhTBZcTg@mail.gmail.com>
        <20200718150514.GC1375379@lunn.ch>
        <20200718172244.59576938@nic.cz>
        <CAFXsbZrHRexg5zAsR1cah4p8HAZVc3tjKdMGKWO6Ha4jXux3QA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WHITELIST shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 19 Jul 2020 14:43:49 -0700
Chris Healy <cphealy@gmail.com> wrote:

> > Hmm.
> >
> > What about the errata setup?
> > It says:
> > /* The 6390 copper ports have an errata which require poking magic
> >  * values into undocumented hidden registers and then performing a
> >  * software reset.
> >  */
> > But then the port_hidden_write function is called for every port in the
> > function mv88e6390_setup_errata, not just for copper ports. Maybe Chris
> > should try to not write this hidden register for SerDes ports.  
> 
> I just disabled the mv88e6390_setup_errata all together and this did
> not result in any different behaviour on this broken fiber port.

:-( In that case I really have no idea what could be the problem.

Another thing you could try is resoldering resistors on the board so
that the switches configure themselves into NOCPU mode and the port you
are talking about configures itself into the cmode you need
(was it 1000base-x or sgmii?). Disable DSA, write yourself sysfs API
via which you can read/write switch registers by yourself. Then you can
chech if the problem on the RX path occurs. If no, read all the
registers and compare their values with the ones the mv88e6xxx driver
configures. If yes, then we know that the problem is there even if the
switch is NOCPU mode and you can inform Marvell about the bug.

Marek
