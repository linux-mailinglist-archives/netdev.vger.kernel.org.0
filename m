Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F59E2D3720
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 00:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730428AbgLHXsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 18:48:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbgLHXsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 18:48:06 -0500
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB717C0613CF
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 15:47:26 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id C07BF4D248DBC;
        Tue,  8 Dec 2020 15:47:25 -0800 (PST)
Date:   Tue, 08 Dec 2020 15:47:25 -0800 (PST)
Message-Id: <20201208.154725.480819428827291417.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, amcohen@nvidia.com, mlxsw@nvidia.com,
        idosch@nvidia.com
Subject: Re: [PATCH net-next 00/13] mlxsw: Add support for Q-in-VNI
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201208092253.1996011-1-idosch@idosch.org>
References: <20201208092253.1996011-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 08 Dec 2020 15:47:26 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Tue,  8 Dec 2020 11:22:40 +0200

> From: Ido Schimmel <idosch@nvidia.com>
> 
> This patch set adds support for Q-in-VNI over Spectrum-{2,3} ASICs.
> Q-in-VNI is like regular VxLAN encapsulation with the sole difference
> that overlay packets can contain a VLAN tag. In Linux, this is achieved
> by adding the VxLAN device to a 802.1ad bridge instead of a 802.1q
> bridge.
> 
> From mlxsw perspective, Q-in-VNI support entails two main changes:
> 
> 1. An outer VLAN tag should always be pushed to the overlay packet
> during decapsulation
> 
> 2. The EtherType used during decapsulation should be 802.1ad (0x88a8)
> instead of the default 802.1q (0x8100)
> 
> Patch set overview:
> 
> Patches #1-#3 add required device registers and fields
> 
> Patch #4 performs small refactoring to allow code re-use
> 
> Patches #5-#7 make the EtherType used during decapsulation a property of
> the tunnel port (i.e., VxLAN). This leads to the driver vetoing
> configurations in which VxLAN devices are member in both 802.1ad and
> 802.1q/802.1d bridges. Will be handled in the future by determining the
> overlay EtherType on the egress port instead
> 
> Patch #8 adds support for Q-in-VNI for Spectrum-2 and newer ASICs
> 
> Patches #9-#10 veto Q-in-VNI for Spectrum-1 ASICs due to some hardware
> limitations. Can be worked around, but decided not to support it for now
> 
> Patch #11 adjusts mlxsw to stop vetoing addition of VXLAN devices to
> 802.1ad bridges
> 
> Patch #12 adds a generic forwarding test that can be used with both veth
> pairs and physical ports with a loopback
> 
> Patch #13 adds a test to make sure mlxsw vetoes unsupported Q-in-VNI
> configurations

Series applied, thank you.
