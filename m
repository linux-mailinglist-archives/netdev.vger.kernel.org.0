Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 564F8178622
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 00:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbgCCXKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 18:10:19 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37060 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727274AbgCCXKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 18:10:19 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B536D15A17746;
        Tue,  3 Mar 2020 15:10:18 -0800 (PST)
Date:   Tue, 03 Mar 2020 15:10:18 -0800 (PST)
Message-Id: <20200303.151018.37007344507132802.davem@davemloft.net>
To:     paulb@mellanox.com
Cc:     saeedm@mellanox.com, ozsh@mellanox.com,
        jakub.kicinski@netronome.com, vladbu@mellanox.com,
        netdev@vger.kernel.org, jiri@mellanox.com, roid@mellanox.com
Subject: Re: [PATCH net-next v4 0/3] act_ct: Software offload of
 conntrack_in
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1583240871-27320-1-git-send-email-paulb@mellanox.com>
References: <1583240871-27320-1-git-send-email-paulb@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 03 Mar 2020 15:10:19 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>
Date: Tue,  3 Mar 2020 15:07:48 +0200

> This series adds software offload of connections with an established
> ct state using the NF flow table offload infrastructure, so
> once such flows are offloaded, they will not pass through conntrack
> again, and instead act_ct will restore the conntrack info metadata
> on the skb to the state it had on the offload event - established.
> 
> Act_ct maintains an FT instance per ct zone. Flow table entries
> are created, per ct connection, when connections enter an established
> state and deleted otherwise. Once an entry is created, the FT assumes
> ownership of the entry, and manages it's aging.
> 
> On the datapath, first lookup the skb in the zone's FT before going
> into conntrack, and if a matching flow is found, restore the conntrack
> info metadata on the skb, and skip calling conntrack.
> 
> Note that this patchset is part of the connection tracking offload feature.
> Hardware offload of connections with an established ct state series will follow
> this one.
> 
> Changelog:
>    v1->v2:
>      Removed now unused netfilter patches

Series applied to net-next, thanks.
