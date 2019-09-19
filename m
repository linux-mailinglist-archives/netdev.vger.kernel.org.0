Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6C96B753C
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 10:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388450AbfISIgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 04:36:41 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:58193 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387617AbfISIgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 04:36:40 -0400
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1iArvb-0000Tl-IW; Thu, 19 Sep 2019 10:36:39 +0200
Received: from ukl by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ukl@pengutronix.de>)
        id 1iArva-0005Yc-TR; Thu, 19 Sep 2019 10:36:38 +0200
Date:   Thu, 19 Sep 2019 10:36:38 +0200
From:   Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Sascha Hauer <s.hauer@pengutronix.de>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Florian Fainelli <f.fainelli@gmail.com>, kernel@pengutronix.de,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: dsa traffic priorization
Message-ID: <20190919083638.wgxrrgtqxwpjcsu3@pengutronix.de>
References: <20190918140225.imqchybuf3cnknob@pengutronix.de>
 <CA+h21hpG52R6ScGpGX86Q7MuRHCgGNY-TxzaQGu2wZR8EtPtbA@mail.gmail.com>
 <20190919080051.mr3cszpyypwqjwu4@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190919080051.mr3cszpyypwqjwu4@pengutronix.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 19, 2019 at 10:00:51AM +0200, Sascha Hauer wrote:
> Hi Vladimir,
> 
> On Wed, Sep 18, 2019 at 05:36:08PM +0300, Vladimir Oltean wrote:
> > Hi Sascha,
> > 
> > On Wed, 18 Sep 2019 at 17:03, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> > >
> > > Hi All,
> > >
> > > We have a customer using a Marvell 88e6240 switch with Ethercat on one port and
> > > regular network traffic on another port. The customer wants to configure two things
> > > on the switch: First Ethercat traffic shall be priorized over other network traffic
> > > (effectively prioritizing traffic based on port). Second the ethernet controller
> > > in the CPU is not able to handle full bandwidth traffic, so the traffic to the CPU
> > > port shall be rate limited.
> > >
> > 
> > You probably already know this, but egress shaping will not drop
> > frames, just let them accumulate in the egress queue until something
> > else happens (e.g. queue occupancy threshold triggers pause frames, or
> > tail dropping is enabled, etc). Is this what you want?
> 
> If I understand correctly then the switch has multiple output queues per
> port. The Ethercat traffic will go to a higher priority queue and on
> congestion on other queues, frames designated for that queue will be
> dropped. I just talked to our customer and he verified that their
> Ethercat traffic still goes through even when the ports with the general
> traffic are jammed with packets. So yes, I think this is what I want.

Moreover egressing the cpu port has the advantage that network
participants on other ports that might be able to process packet quicker
are not limited.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
