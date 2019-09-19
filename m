Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7E9BB7A59
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 15:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388910AbfISNVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 09:21:55 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:48301 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388620AbfISNVy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 09:21:54 -0400
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=localhost)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <jlu@pengutronix.de>)
        id 1iAwNd-0006WT-35; Thu, 19 Sep 2019 15:21:53 +0200
Message-ID: <06d2ca7441c899b4da8475f82dc706351edd0976.camel@pengutronix.de>
Subject: Re: dsa traffic priorization
From:   Jan =?ISO-8859-1?Q?L=FCbbe?= <jlu@pengutronix.de>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Cc:     netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        kernel@pengutronix.de, Andrew Lunn <andrew@lunn.ch>
Date:   Thu, 19 Sep 2019 15:21:50 +0200
In-Reply-To: <1b80f9ed-7a62-99c4-10bc-bc1887f80867@gmail.com>
References: <20190918140225.imqchybuf3cnknob@pengutronix.de>
         <CA+h21hpG52R6ScGpGX86Q7MuRHCgGNY-TxzaQGu2wZR8EtPtbA@mail.gmail.com>
         <1b80f9ed-7a62-99c4-10bc-bc1887f80867@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: jlu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, 2019-09-18 at 10:41 -0700, Florian Fainelli wrote:
> > Technically, configuring a match-all rxnfc rule with ethtool would
> > count as 'default priority' - I have proposed that before. Now I'm not
> > entirely sure how intuitive it is, but I'm also interested in being
> > able to configure this.
> 
> That does not sound too crazy from my perspective.

Sascha and myself aren't that familiar with that part of ethtool.
You're talking about using ethtool --config-nfc/--config-ntuple on the
(external) sw1p1, sw1p2 ports? Something like this (completely untested
from the manpage):
ethtool --config-nfc sw1p1 flow-type ether queue 2 # high prio queue for ethercat
ethtool --config-nfc sw1p2 flow-type ether queue 1 # normal for rest

Currently, there seems to be no "match-all" option.

Alternatives to "queue X" might be "action" or "context", but I don't
know enough about the details to prefer one above the other.

Regards,
Jan

