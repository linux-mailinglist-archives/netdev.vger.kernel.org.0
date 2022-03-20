Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF6284E1AB3
	for <lists+netdev@lfdr.de>; Sun, 20 Mar 2022 08:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237855AbiCTHyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Mar 2022 03:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbiCTHyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Mar 2022 03:54:04 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7929B1F0453;
        Sun, 20 Mar 2022 00:52:40 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id E8DB85C0116;
        Sun, 20 Mar 2022 03:52:37 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Sun, 20 Mar 2022 03:52:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=5S1Qz9qa8y5v6pn+6
        hPiVyR9fbOW9nCX+ik34wPrsIw=; b=GR4U9PbXRmwKlG+92UM35IdYDLE1UnrK7
        Ld0eXeTAX/uq+p5Fc/9ZoksjqPgGZiSpV6ROvs5hTVAqwg7Tr2+I9ClVUMIf1gw6
        Nd4Q5VhefO0IaNXa2OzHrlr4va1hUuM+J6dmJMWx1rQk1pNLLoUPar4yqWHhGchI
        tDdBttofIPw+uIPGAhN4loJ50CoPyybCcFjoZ5qHUL9iFqXOQ643z7LP889vGkPq
        v+3Pmq2E7OXWZv0cSKl/f8Ffr1jVvO3a7Y/rbIHN0fDTkP7v58BS07KKMCkskUG7
        rTPrp+jinp67KmciT0vJHFrcQsbAicJn7KXknDl2WEjI12WPUEW+Q==
X-ME-Sender: <xms:Rd02YlAJD1ycEJbkLRMM0KRY1lDvwGfvGBClIeKGAwuYgY-HM9HNnQ>
    <xme:Rd02YjjzevJC-HgUmG0HrhVAfVILN18yq7Bv5tw05ggk4d7STE8NnJpO4lvR_lBim
    6Hj4eVHk4KKHzk>
X-ME-Received: <xmr:Rd02Ygk33nNO4FUMv2-vySsaqev1qpuzZW2Jcu9_5dkPG_NIAUjrvAqpmRucXTs56jsnzw_cEy4BVHAsY8Zm4h4Tjbw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudegtddgtdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:Rd02YvzwPsopQaTOv0s9xyRhEaTH9tDkKCEJi5ru5QmnSzqjeBupcw>
    <xmx:Rd02YqTH4pWwiDel8_YY2xrIDSeh4juCtvRvBHVZb5Tj7qDdvxXDeA>
    <xmx:Rd02Yib1AlUzy3TCPVkOFvuapZ5IVI5hvwqvgtuVH6Nzs_K2gOkNig>
    <xmx:Rd02YvhB7qS8uctbcKFyh_JQZBVebQgpvrp2AY-Z7P6OicfFSEMiYQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 20 Mar 2022 03:52:36 -0400 (EDT)
Date:   Sun, 20 Mar 2022 09:52:33 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
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
Message-ID: <YjbdQUVYkhkbdp3L@shredder>
References: <20220317093902.1305816-1-schultz.hans+netdev@gmail.com>
 <20220317093902.1305816-5-schultz.hans+netdev@gmail.com>
 <YjNMS6aFG+93ejj5@shredder>
 <86mthnw9gr.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86mthnw9gr.fsf@gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 18, 2022 at 04:45:24PM +0100, Hans Schultz wrote:
> On tor, mar 17, 2022 at 16:57, Ido Schimmel <idosch@idosch.org> wrote:
> > On Thu, Mar 17, 2022 at 10:39:02AM +0100, Hans Schultz wrote:
> >> Verify that the MAC-Auth mechanism works by adding a FDB entry with the
> >> locked flag set. denying access until the FDB entry is replaced with a
> >> FDB entry without the locked flag set.
> >> 
> >> Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>
> >> ---
> >>  .../net/forwarding/bridge_locked_port.sh      | 29 ++++++++++++++++++-
> >>  1 file changed, 28 insertions(+), 1 deletion(-)
> >> 
> >> diff --git a/tools/testing/selftests/net/forwarding/bridge_locked_port.sh b/tools/testing/selftests/net/forwarding/bridge_locked_port.sh
> >> index 6e98efa6d371..2f9519e814b6 100755
> >> --- a/tools/testing/selftests/net/forwarding/bridge_locked_port.sh
> >> +++ b/tools/testing/selftests/net/forwarding/bridge_locked_port.sh
> >> @@ -1,7 +1,7 @@
> >>  #!/bin/bash
> >>  # SPDX-License-Identifier: GPL-2.0
> >>  
> >> -ALL_TESTS="locked_port_ipv4 locked_port_ipv6 locked_port_vlan"
> >> +ALL_TESTS="locked_port_ipv4 locked_port_ipv6 locked_port_vlan locked_port_mab"
> >>  NUM_NETIFS=4
> >>  CHECK_TC="no"
> >>  source lib.sh
> >> @@ -170,6 +170,33 @@ locked_port_ipv6()
> >>  	log_test "Locked port ipv6"
> >>  }
> >>  
> >> +locked_port_mab()
> >> +{
> >> +	RET=0
> >> +	check_locked_port_support || return 0
> >> +
> >> +	ping_do $h1 192.0.2.2
> >> +	check_err $? "MAB: Ping did not work before locking port"
> >> +
> >> +	bridge link set dev $swp1 locked on
> >> +	bridge link set dev $swp1 learning on
> >> +
> >> +	ping_do $h1 192.0.2.2
> >> +	check_fail $? "MAB: Ping worked on port just locked"
> >> +
> >> +	if ! bridge fdb show | grep `mac_get $h1` | grep -q "locked"; then
> >> +		RET=1
> >> +		retmsg="MAB: No locked fdb entry after ping on locked port"
> >> +	fi
> >
> > bridge fdb show | grep `mac_get $h1 | grep -q "locked"
> > check_err $? "MAB: No locked fdb entry after ping on locked port"
> >
> >> +
> >> +	bridge fdb del `mac_get $h1` dev $swp1 master
> >> +	bridge fdb add `mac_get $h1` dev $swp1 master static
> >
> > bridge fdb replace `mac_get $h1` dev $swp1 master static
> >
> Unfortunately for some reason 'replace' does not work in several of the
> tests, while when replaced with 'del+add', they work.

Is it because the 'locked' flag is not removed following the replace? At
least I don't see where it's handled in fdb_add_entry(). If so, please
fix it and use "bridge fdb replace" in the test.

> 
> >> +
> >> +	ping_do $h1 192.0.2.2
> >> +	check_err $? "MAB: Ping did not work with fdb entry without locked flag"
> >> +
> >> +	log_test "Locked port MAB"
> >
> > Clean up after the test to revert to initial state:
> >
> > bridge fdb del `mac_get $h1` dev $swp1 master
> > bridge link set dev $swp1 locked off
> >
> >
> >> +}
> >>  trap cleanup EXIT
> >>  
> >>  setup_prepare
> >> -- 
> >> 2.30.2
> >> 
