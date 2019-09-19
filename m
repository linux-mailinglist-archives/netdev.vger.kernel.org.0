Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61A89B7A9A
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 15:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389492AbfISNfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 09:35:55 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:43345 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388819AbfISNfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 09:35:55 -0400
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=localhost)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <jlu@pengutronix.de>)
        id 1iAwbB-00085P-U4; Thu, 19 Sep 2019 15:35:54 +0200
Message-ID: <5369a4b61692ad8c1cd35ee96e04db53780cadfe.camel@pengutronix.de>
Subject: Re: dsa traffic priorization
From:   Jan =?ISO-8859-1?Q?L=FCbbe?= <jlu@pengutronix.de>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Cc:     netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        kernel@pengutronix.de, Andrew Lunn <andrew@lunn.ch>
Date:   Thu, 19 Sep 2019 15:35:53 +0200
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

On Wed, 2019-09-18 at 10:41 -0700, Florian Fainelli wrote:
> > > The other part of the problem seems to be that the CPU port has no network device
> > > representation in Linux, so there's no interface to configure the egress limits via tc.
> > > This has been discussed before, but it seems there hasn't been any consensous regarding how
> > > we want to proceed?
> 
> You have the DSA master network device which is on the other side of the
> switch,

We thought it might be intutive to allow configuration of this via tc
on the DSA master device (eth0, the i.MX FEC in our case). You'd
specify ingress policing via tc, and the kernel would try to hw-offload 
that to the switch's CPU egress side first, maybe fall back to offload
on the SoC's network controler and finally use the normal SW
implementation.

If that sounds reasonable, the next question would be how to express
matching on switchdev information (such as the ingress port or vlan
priority).

Regards,
Jan

