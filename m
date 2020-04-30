Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA221BF5EF
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 12:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbgD3Kz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 06:55:56 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:58981 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726413AbgD3Kzz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 06:55:55 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id B8D2992F;
        Thu, 30 Apr 2020 06:55:54 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 30 Apr 2020 06:55:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=E0tSeJ
        Qs4F49nhcw9h7Mq+DKRjdkwObVDd0dqiIADY4=; b=R+TgxK9IVLXPfsFxwzjCn3
        pKROOzjEmF5C3sDu2C6mFoczn8Xw7i2LK3qILvRrY6V7/xjJifh9gf/kAwR+HiIK
        RaI1i6G/HOddiYK0L+ESRamP88qXgDePICiPyx/sM0rgxW72d9mRZHxl2j0QA5i+
        B+QngtHzhw3co11KaZ0KOe2n0kzGtyBsOW7X4XXVLY2mv+lTp/+BeZGcCtWq2Qz+
        J1XzGdPFraGjB+5tIU/GsimbkMt50kxTxMaWNrpGobdDO9OvAsr2l9NJy5SREL8e
        +POuOWARPQrv4yYxNHjVHLeen3yILL8IjLSFWVocjHS6ihiMyBWmy0CFDTKDvXfA
        ==
X-ME-Sender: <xms:ua6qXruVq4mj3Dpb77jFPJ2JdOMwEvNVRFvw8T7YQBTc2UYqbPv78Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrieehgdefgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necukfhppeejledrudektddrheegrdduudeinecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:uq6qXn50KsPxK9ng7IOjp6mYoBW7SVXrWgCCQ1TkqY3VOLIzoV17DQ>
    <xmx:uq6qXiVjfba8LpGEAg3AcBmVVUzrg5a2lsH5JxsZ6BJv6PIactHQ7Q>
    <xmx:uq6qXjOUmakUXpv5pG_WsxOduNEqqgr_E38SEJ7xl6_r7VarnXUTCg>
    <xmx:uq6qXuFvhzck0CbTtboVopAPOgGQWKrlzPI2Oc6ffrp1P0kQ0frslg>
Received: from localhost (bzq-79-180-54-116.red.bezeqint.net [79.180.54.116])
        by mail.messagingengine.com (Postfix) with ESMTPA id 97EDF3280064;
        Thu, 30 Apr 2020 06:55:53 -0400 (EDT)
Date:   Thu, 30 Apr 2020 13:55:51 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc:     roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        davem@davemloft.net,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>, netdev@vger.kernel.org
Subject: Re: BUG: soft lockup while deleting tap interface from vlan aware
 bridge
Message-ID: <20200430105551.GA4068275@splinter>
References: <85b1e301-8189-540b-b4bf-d0902e74becc@profihost.ag>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85b1e301-8189-540b-b4bf-d0902e74becc@profihost.ag>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 29, 2020 at 10:52:35PM +0200, Stefan Priebe - Profihost AG wrote:
> Hello,
> 
> while running a stable vanilla kernel 4.19.115 i'm reproducably get this
> one:
> 
> watchdog: BUG: soft lockup - CPU#38 stuck for 22s! [bridge:3570653]
> 
> ...
> 
> Call
> Trace:nbp_vlan_delete+0x59/0xa0br_vlan_info+0x66/0xd0br_afspec+0x18c/0x1d0br_dellink+0x74/0xd0rtnl_bridge_dellink+0x110/0x220rtnetlink_rcv_msg+0x283/0x360

Nik, Stefan,

My theory is that 4K VLANs are deleted in a batch and preemption is
disabled (please confirm). For each VLAN the kernel needs to go over the
entire FDB and delete affected entries. If the FDB is very large or the
FDB lock is contended this can cause the kernel to loop for more than 20
seconds without calling schedule().

To reproduce I added mdelay(100) in br_fdb_delete_by_port() and ran
this:

ip link add name br10 up type bridge vlan_filtering 1
ip link add name dummy10 up type dummy
ip link set dev dummy10 master br10
bridge vlan add vid 1-4094 dev dummy10 master
bridge vlan del vid 1-4094 dev dummy10 master

Got a similar trace to Stefan's. Seems to be fixed by attached:

diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index a774e19c41bb..240e260e3461 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -615,6 +615,7 @@ int br_process_vlan_info(struct net_bridge *br,
                                               v - 1, rtm_cmd);
                                v_change_start = 0;
                        }
+                       cond_resched();
                }
                /* v_change_start is set only if the last/whole range changed */
                if (v_change_start)

WDYT?
