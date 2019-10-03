Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F581CAECC
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 21:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732346AbfJCTE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 15:04:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47376 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729702AbfJCTE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 15:04:58 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D96AC146D0431;
        Thu,  3 Oct 2019 12:04:57 -0700 (PDT)
Date:   Thu, 03 Oct 2019 12:04:57 -0700 (PDT)
Message-Id: <20191003.120457.1626857609490915856.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: Allow port mirroring to the CPU port
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191002233750.13566-1-olteanv@gmail.com>
References: <20191002233750.13566-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 03 Oct 2019 12:04:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Thu,  3 Oct 2019 02:37:50 +0300

> On a regular netdev, putting it in promiscuous mode means receiving all
> traffic passing through it, whether or not it was destined to its MAC
> address. Then monitoring applications such as tcpdump can see all
> traffic transiting it.
> 
> On Ethernet switches, clearly all ports are in promiscuous mode by
> definition, since they accept frames destined to any MAC address.
> However tcpdump does not capture all frames transiting switch ports,
> only the ones destined to, or originating from the CPU port.
> 
> To be able to monitor frames with tcpdump on the CPU port, extend the tc
> matchall classifier and mirred action to support the DSA master port as
> a possible mirror target.
> 
> Tested with:
> tc qdisc add dev swp2 clsact
> tc filter add dev swp2 ingress matchall skip_sw \
> 	action mirred egress mirror dev eth2
> tcpdump -i swp2
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Andrew and co., please review.
