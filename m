Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47439535094
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 16:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344710AbiEZO14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 10:27:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbiEZO1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 10:27:55 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AAB2C5E76;
        Thu, 26 May 2022 07:27:52 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id BBC6A3200258;
        Thu, 26 May 2022 10:27:49 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Thu, 26 May 2022 10:27:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1653575269; x=1653661669; bh=StrlpIYajUUCDicQmIv6vQpHKNJZ
        suJXBuDoYzce0XU=; b=mnurwjAcVnldsgZxi5JsRrqsPfBzzO+n+pBlmvIxIEGS
        kCvlFvVteXMu2KLrIDvuFFxLoIOYwZEkZQag4qZizXF1Z1w7TqZzqZnmjhkto+Cj
        NAQRgqf6yPtmOuTNvU8WpivNyc0eKwfhfWyvXlRnY5VyWzfAxN/0rpB7sAqH0DD/
        C5sibS8yfugBPbOuVPNnwgH/hoSUawgsItougUcqFjjubuiGMTyj+DGgLNuF00Pp
        TjwtixybLl7hvTYO5a6tIOTnWwa1qaO8H71ToAicqxlrOAqa2TKMTSjNZjRlV/5d
        rvzxH+MHDNkGPcjUH2Ky9FZuUjs9Zh9KqTI4RvdOQw==
X-ME-Sender: <xms:ZI6PYsj9-lGfCcktnJMYvwdjZJvG-R2VgT54-_H3pFkLd0dP1yj52Q>
    <xme:ZI6PYlDaNRT0UvC2JuNaSIM9S42hecCUg_zdfnpKWRRjHS7nM5N8tJjGOrGqV_-Wn
    wHPvVOZzB5v6XE>
X-ME-Received: <xmr:ZI6PYkEsMpaEriXO3REaQVKHsCZnqGnfAi7zrGMUtPEtngRdCmFwsF4JprAdGkEfIEFTyCXDBJXPdj2GtKNINHTHoatEiQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrjeejgdejhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedvudefveekheeugeeftddvveefgfduieefudeifefgleekheegleegjeejgeeg
    hfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:ZI6PYtSp7nXI7Me_4H6_3FIgV29oSnLPHc7lIxggZUJ-QoXD5O-2mQ>
    <xmx:ZI6PYpyL5kbIvBmI00ulXuEbzBlZFEELdV3mR1DzhVvmLJm0nCXiMQ>
    <xmx:ZI6PYr41Ts6Tco_zDGOk7gfVM-N2_G698tfN5utgWoJkDZ6O9h4WLA>
    <xmx:ZY6PYqohC4uJX-0Kk2MNsWzIYvaiCq9AtC0t5NZIZeUn1ClV6zay5w>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 26 May 2022 10:27:47 -0400 (EDT)
Date:   Thu, 26 May 2022 17:27:44 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH V3 net-next 4/4] selftests: forwarding: add test of
 MAC-Auth Bypass to locked port tests
Message-ID: <Yo+OYN/rjdB7wfQu@shredder>
References: <20220524152144.40527-1-schultz.hans+netdev@gmail.com>
 <20220524152144.40527-5-schultz.hans+netdev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220524152144.40527-5-schultz.hans+netdev@gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 24, 2022 at 05:21:44PM +0200, Hans Schultz wrote:
> Verify that the MAC-Auth mechanism works by adding a FDB entry with the
> locked flag set. denying access until the FDB entry is replaced with a
> FDB entry without the locked flag set.
> 
> Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>
> ---
>  .../net/forwarding/bridge_locked_port.sh      | 42 ++++++++++++++++---
>  1 file changed, 36 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/testing/selftests/net/forwarding/bridge_locked_port.sh b/tools/testing/selftests/net/forwarding/bridge_locked_port.sh
> index 5b02b6b60ce7..50b9048d044a 100755
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
> @@ -94,13 +94,13 @@ locked_port_ipv4()
>  	ping_do $h1 192.0.2.2
>  	check_fail $? "Ping worked after locking port, but before adding FDB entry"
>  
> -	bridge fdb add `mac_get $h1` dev $swp1 master static
> +	bridge fdb replace `mac_get $h1` dev $swp1 master static
>  
>  	ping_do $h1 192.0.2.2
>  	check_err $? "Ping did not work after locking port and adding FDB entry"
>  
>  	bridge link set dev $swp1 locked off
> -	bridge fdb del `mac_get $h1` dev $swp1 master static
> +	bridge fdb del `mac_get $h1` dev $swp1 master
>  
>  	ping_do $h1 192.0.2.2
>  	check_err $? "Ping did not work after unlocking port and removing FDB entry."
> @@ -124,13 +124,13 @@ locked_port_vlan()
>  	ping_do $h1.100 198.51.100.2
>  	check_fail $? "Ping through vlan worked after locking port, but before adding FDB entry"
>  
> -	bridge fdb add `mac_get $h1` dev $swp1 vlan 100 master static
> +	bridge fdb replace `mac_get $h1` dev $swp1 master static
>  
>  	ping_do $h1.100 198.51.100.2
>  	check_err $? "Ping through vlan did not work after locking port and adding FDB entry"
>  
>  	bridge link set dev $swp1 locked off
> -	bridge fdb del `mac_get $h1` dev $swp1 vlan 100 master static
> +	bridge fdb del `mac_get $h1` dev $swp1 vlan 100 master
>  
>  	ping_do $h1.100 198.51.100.2
>  	check_err $? "Ping through vlan did not work after unlocking port and removing FDB entry"
> @@ -153,7 +153,8 @@ locked_port_ipv6()
>  	ping6_do $h1 2001:db8:1::2
>  	check_fail $? "Ping6 worked after locking port, but before adding FDB entry"
>  
> -	bridge fdb add `mac_get $h1` dev $swp1 master static
> +	bridge fdb replace `mac_get $h1` dev $swp1 master static
> +
>  	ping6_do $h1 2001:db8:1::2
>  	check_err $? "Ping6 did not work after locking port and adding FDB entry"
>  
> @@ -166,6 +167,35 @@ locked_port_ipv6()
>  	log_test "Locked port ipv6"
>  }

Why did you change s/add/replace/? Also, from the subject and commit
message I understand the patch is about adding a new test, not changing
existing ones.

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
> +	bridge fdb del `mac_get $h1` dev $swp1 master

Why the delete is needed? Aren't you getting errors on trying to delete
a non-existing entry? In previous test cases learning is disabled and it
seems the FDB entry is cleaned up.

> +
> +	ping_do $h1 192.0.2.2
> +	check_fail $? "MAB: Ping worked on locked port without FDB entry"
> +
> +	bridge fdb show | grep `mac_get $h1` | grep -q "locked"
> +	check_err $? "MAB: No locked fdb entry after ping on locked port"
> +
> +	bridge fdb replace `mac_get $h1` dev $swp1 master static
> +
> +	ping_do $h1 192.0.2.2
> +	check_err $? "MAB: Ping did not work with fdb entry without locked flag"
> +
> +	bridge fdb del `mac_get $h1` dev $swp1 master

bridge link set dev $swp1 learning off

> +	bridge link set dev $swp1 locked off
> +
> +	log_test "Locked port MAB"
> +}
>  trap cleanup EXIT
>  
>  setup_prepare
> -- 
> 2.30.2
> 
