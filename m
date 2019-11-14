Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4A7FC770
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 14:29:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfKNN3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 08:29:06 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:2638 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbfKNN3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 08:29:06 -0500
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id xAEDSrwn014754;
        Thu, 14 Nov 2019 05:28:54 -0800
Date:   Thu, 14 Nov 2019 18:50:43 +0530
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nirranjan@chelsio.com,
        vishal@chelsio.com, dt@chelsio.com
Subject: Re: [PATCH net-next 1/2] cxgb4: add TC-MATCHALL classifier egress
 offload
Message-ID: <20191114132041.GA12021@chelsio.com>
References: <cover.1573656040.git.rahul.lakkireddy@chelsio.com>
 <faa43582f7a038fb835051e0473866b325a5a6e1.1573656040.git.rahul.lakkireddy@chelsio.com>
 <20191113191402.27dbba26@cakuba>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191113191402.27dbba26@cakuba>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday, November 11/13/19, 2019 at 19:14:02 -0800, Jakub Kicinski wrote:
> On Wed, 13 Nov 2019 20:09:20 +0530, Rahul Lakkireddy wrote:
> > Add TC-MATCHALL classifier offload with TC-POLICE action applied for all
> > outgoing traffic on the underlying interface. Split flow block offload
> > to support both egress and ingress classification.
> > 
> > For example, to rate limit all outgoing traffic to 1 Gbps:
> > 
> > $ tc qdisc add dev enp2s0f4 clsact
> > $ tc filter add dev enp2s0f4 egress matchall skip_sw \
> > 	action police rate 1Gbit burst 8Kbit
> > 
> > Note that skip_sw is important. Otherwise, both stack and hardware
> > will end up doing policing. 
> 
> You also can't offload policers from shared blocks (well, shared
> actions in general, but let's say checking shared blocks is enough).
> 

Ok. Will add a check in v2 to reject police action offload for shared
blocks.

> > Only 1 egress matchall rule can be active
> > at a time on the underlying interface.
> > 
> > Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>

Thanks,
Rahul
