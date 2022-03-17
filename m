Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 872EA4DC96A
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 15:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235449AbiCQO6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 10:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233311AbiCQO6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 10:58:42 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D0B2203A70;
        Thu, 17 Mar 2022 07:57:23 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 033ED5C0164;
        Thu, 17 Mar 2022 10:57:21 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 17 Mar 2022 10:57:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=dn5WetjsAweDFdDrV
        E4l3jAwTI6fbXOJu2TtvBSryHA=; b=LPpPYa+uaec9c9tSWDa/a1qlX0DXYY3jS
        RzshbqmdO7dVF5xENoH4gUmkN1VmVq71AeGh5/2aKK3C3/wkIQ3ltbJ3zZ3ZNI0q
        RCzcsWxvFuG2hNRV9pgsfdRmzrFDnPUMZqmgKSF9/pD5PDg9Mc9rS7x5iCccEqFt
        RWORpzNXsgm1ZJuULqEpBFfmU6cjr7dYAHL8lNt5o7Ew26AISo6jHxUpdUYb2+Y7
        kHivUhf54VhAKl40e7KSIMzPOlUsMHx9xNm2VB073ZQbUKxcIiI3QJoWjkCrQm8W
        V0fLprnZFEnyIdy86Tnd0+8u7nTPvEfOsHnBUgEctlov3U1h2LCYA==
X-ME-Sender: <xms:UEwzYnx8imVwNadmf9T5wmcXeTk_PiuAmRVc_L5qdXd0OBqYxo6VVw>
    <xme:UEwzYvSEFDr2fBOQb0O0fO831TEMLfAxbOq_lkPNefK3AQalsIsrg27K70Hw7braY
    _zttmgu50q2p8A>
X-ME-Received: <xmr:UEwzYhUsgErk4upt7LyYekkhnE6P3mZhbi0qGRKL4FOIWudK7tyjYZmCjs-rL1IwHxzr5h1RLr1UPSVqdMJTVuZb2ms>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudefgedgieelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:UEwzYhgPbf42vYVNC2Lp84jwwoa8QY0GAZ9udVRHc52zl5coCa5FUg>
    <xmx:UEwzYpDBYkbViPfRJK2TYF3eECYQ-bXa8oRvhq9e_I0RStB2Xa0VtA>
    <xmx:UEwzYqJmmoNuj_puZPQYNtACEfbiLNnTgz6c3WfPmyaZrPOMmdvQrg>
    <xmx:UEwzYrxsnMax2EWyvttA0B0uHw6-yv4e3EhSltgziVUXynPmsm0FiQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 17 Mar 2022 10:57:19 -0400 (EDT)
Date:   Thu, 17 Mar 2022 16:57:15 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 net-next 4/4] selftests: forwarding: add test of
 MAC-Auth Bypass to locked port tests
Message-ID: <YjNMS6aFG+93ejj5@shredder>
References: <20220317093902.1305816-1-schultz.hans+netdev@gmail.com>
 <20220317093902.1305816-5-schultz.hans+netdev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220317093902.1305816-5-schultz.hans+netdev@gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 17, 2022 at 10:39:02AM +0100, Hans Schultz wrote:
> Verify that the MAC-Auth mechanism works by adding a FDB entry with the
> locked flag set. denying access until the FDB entry is replaced with a
> FDB entry without the locked flag set.
> 
> Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>
> ---
>  .../net/forwarding/bridge_locked_port.sh      | 29 ++++++++++++++++++-
>  1 file changed, 28 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/net/forwarding/bridge_locked_port.sh b/tools/testing/selftests/net/forwarding/bridge_locked_port.sh
> index 6e98efa6d371..2f9519e814b6 100755
> --- a/tools/testing/selftests/net/forwarding/bridge_locked_port.sh
> +++ b/tools/testing/selftests/net/forwarding/bridge_locked_port.sh
> @@ -1,7 +1,7 @@
>  #!/bin/bash
>  # SPDX-License-Identifier: GPL-2.0
>  
> -ALL_TESTS="locked_port_ipv4 locked_port_ipv6 locked_port_vlan"
> +ALL_TESTS="locked_port_ipv4 locked_port_ipv6 locked_port_vlan locked_port_mab"
>  NUM_NETIFS=4
>  CHECK_TC="no"
>  source lib.sh
> @@ -170,6 +170,33 @@ locked_port_ipv6()
>  	log_test "Locked port ipv6"
>  }
>  
> +locked_port_mab()
> +{
> +	RET=0
> +	check_locked_port_support || return 0
> +
> +	ping_do $h1 192.0.2.2
> +	check_err $? "MAB: Ping did not work before locking port"
> +
> +	bridge link set dev $swp1 locked on
> +	bridge link set dev $swp1 learning on
> +
> +	ping_do $h1 192.0.2.2
> +	check_fail $? "MAB: Ping worked on port just locked"
> +
> +	if ! bridge fdb show | grep `mac_get $h1` | grep -q "locked"; then
> +		RET=1
> +		retmsg="MAB: No locked fdb entry after ping on locked port"
> +	fi

bridge fdb show | grep `mac_get $h1 | grep -q "locked"
check_err $? "MAB: No locked fdb entry after ping on locked port"

> +
> +	bridge fdb del `mac_get $h1` dev $swp1 master
> +	bridge fdb add `mac_get $h1` dev $swp1 master static

bridge fdb replace `mac_get $h1` dev $swp1 master static

> +
> +	ping_do $h1 192.0.2.2
> +	check_err $? "MAB: Ping did not work with fdb entry without locked flag"
> +
> +	log_test "Locked port MAB"

Clean up after the test to revert to initial state:

bridge fdb del `mac_get $h1` dev $swp1 master
bridge link set dev $swp1 locked off


> +}
>  trap cleanup EXIT
>  
>  setup_prepare
> -- 
> 2.30.2
> 
