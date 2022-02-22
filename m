Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4594BFF86
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 18:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233658AbiBVRBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 12:01:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbiBVRBS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 12:01:18 -0500
Received: from new2-smtp.messagingengine.com (new2-smtp.messagingengine.com [66.111.4.224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E8E16E7CB;
        Tue, 22 Feb 2022 09:00:51 -0800 (PST)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 797D65803B7;
        Tue, 22 Feb 2022 12:00:50 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 22 Feb 2022 12:00:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=HtCItNyhGVUgQ9zYx
        8y8HwkSSNP7qG6erjhX3gp1Vas=; b=GtZc3a+Qfwr7g0xbB/r/BXPgspmACWS5G
        0OGqRVvN6z11OqHVovHGRWCIY+6qwMtxF85hTXbUfkCrF+fnjHoeZnPCv0XXOJla
        0JkgBu9WCWEnKJottlEKs/Q4JTZdyLmnRmhTbDr+/rVr0IPN2yxgwBw/wMgTVpG8
        C9DoX4S/LL3KjKX65DZDCRznCURUQokspAfI6u2Fi3Fx8wU6QTNyq8N5GoT7nieO
        Yhhv/C7ifwD/9umjdWpzeNwMitCll2oBCOj6sJ8t/mdGGx5OHFJ+xV/TdaC/1R0N
        6AUjtVDxl/Y72YPEjJVL0il7EKgeRDlxX1hKjl3laKNHeOagby5aA==
X-ME-Sender: <xms:wRYVYiV488PJ8dsyWXC2-qZX4Ec6K41Dsf4gR_5L-9d82sciAItPsQ>
    <xme:wRYVYumBrUxVr8yJp28gXjHjH6idO1Ji3PhD6ODs9V4bVAf8CwKGf-myJP2AHBedc
    jQyhpQuubrzuUs>
X-ME-Received: <xmr:wRYVYmb-w1BGYM1gutgPONq5dR0QQG6p26CwXhoUD4DKQDnERE5vPOkh4d_7pU4ztW3VGAKMjf_r8oAuyqgkzbGcag0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrkeekgdelfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:whYVYpVh7rh-btnjQECit2ixdjjH1xEQgpb0OQe732sLUJXzafy88w>
    <xmx:whYVYskuy1ClagUaAi7TsEOtjRvTRcRyXCCXBfOPZhK_9PsMx-ELbw>
    <xmx:whYVYucdvuL-RBwSfTBPxtNiwaIxsdnMxtpGFdKjt1-cJflnmCUyjw>
    <xmx:whYVYqpPNokjYGIilBHrkHosAHqdWOFV-0p14_H7TjNh5i0VZ3gNjw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 22 Feb 2022 12:00:48 -0500 (EST)
Date:   Tue, 22 Feb 2022 19:00:46 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Shuah Khan <shuah@kernel.org>,
        Stephen Suryaputra <ssuryaextr@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>,
        Po-Hsu Lin <po-hsu.lin@canonical.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next v4 5/5] selftests: forwarding: tests of locked
 port feature
Message-ID: <YhUWvhkhRVY+/Osd@shredder>
References: <20220222132818.1180786-1-schultz.hans+netdev@gmail.com>
 <20220222132818.1180786-6-schultz.hans+netdev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220222132818.1180786-6-schultz.hans+netdev@gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 02:28:18PM +0100, Hans Schultz wrote:
> diff --git a/tools/testing/selftests/net/forwarding/bridge_locked_port.sh b/tools/testing/selftests/net/forwarding/bridge_locked_port.sh
> new file mode 100755
> index 000000000000..a8800e531d07
> --- /dev/null
> +++ b/tools/testing/selftests/net/forwarding/bridge_locked_port.sh
> @@ -0,0 +1,180 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +
> +ALL_TESTS="locked_port_ipv4 locked_port_ipv6 locked_port_vlan"
> +NUM_NETIFS=4
> +CHECK_TC="no"
> +source lib.sh
> +
> +h1_create()
> +{
> +	simple_if_init $h1 192.0.2.1/24 2001:db8:1::1/64
> +	vrf_create "vrf-vlan-h1"
> +	ip link set dev vrf-vlan-h1 up
> +	vlan_create $h1 100 vrf-vlan-h1 198.51.100.1/24 ::ffff:c633:6401/64

Hi,

Why did you change it from 2001:db8:3::1/64 to ::ffff:c633:6401/64? It
was actually OK the first time...

Anyway, looking at locked_port_vlan() I see that you are only testing
IPv4 so you can just drop this address:

vlan_create $h1 100 vrf-vlan-h1 198.51.100.1/24

Same for $h2

LGTM otherwise. Feel free to add my tag to the next version


> +}
