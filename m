Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE873481BA
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 20:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238074AbhCXTQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 15:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238099AbhCXTQA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 15:16:00 -0400
Received: from mail.netfilter.org (mail.netfilter.org [IPv6:2001:4b98:dc0:41:216:3eff:fe8c:2bda])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2D208C0613E2;
        Wed, 24 Mar 2021 12:15:57 -0700 (PDT)
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id CD90F630B3;
        Wed, 24 Mar 2021 20:15:45 +0100 (CET)
Date:   Wed, 24 Mar 2021 20:15:52 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     netfilter-devel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH net-next,v2 01/24] net: resolve forwarding path from
 virtual netdevice and HW destination address
Message-ID: <20210324191552.GA17651@salvia>
References: <20210324013055.5619-1-pablo@netfilter.org>
 <20210324013055.5619-2-pablo@netfilter.org>
 <20210324072711.2835969-1-dqfext@gmail.com>
 <20210324100354.GA8040@salvia>
 <20210324160702.3056-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210324160702.3056-1-dqfext@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, Mar 25, 2021 at 12:07:02AM +0800, DENG Qingfang wrote:
> On Wed, Mar 24, 2021 at 11:03:54AM +0100, Pablo Neira Ayuso wrote:
> > 
> > For this scenario specifically, it should be possible extend the
> > existing flowtable netlink API to allow hostapd to flush entries in
> > the flowtable for the client changing AP.
> 
> The APs are external, are we going to install hostapd to them, and
> let them inform the gateway? They may not even run Linux.

This falls within the scenario that Jakub described already. These
limitations are described in patch 24/24.

> Roaming can happen in a wired LAN too, see Vladimir's commit message
> 90dc8fd36078 ("net: bridge: notify switchdev of disappearance of old FDB entry upon migration").
> I think the fastpath should monitor roaming (called "FDB migration" in
> that commit) events, and update/flush the flowtable accordingly.

Why does this need to happen in this batch? Is there anything that
makes you think dealing with roaming cannot be done incrementally on
top of this series?

This patchset is already useful for a good number of use-cases
regardless the roaming scenario you describe.

FDB hardware offload was added years ago and the roaming mitigation
that you refer to was added just a few months ago.
