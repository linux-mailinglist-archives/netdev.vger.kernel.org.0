Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD8E5637D72
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 17:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiKXQEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 11:04:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiKXQEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 11:04:14 -0500
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 467211CFE8
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 08:04:13 -0800 (PST)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id F13D85C00C5;
        Thu, 24 Nov 2022 11:04:10 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 24 Nov 2022 11:04:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1669305850; x=1669392250; bh=SJFiCo+vmdPavID5t9cPzNlj6UDs
        m3rBnIS7KfRjC5U=; b=QNtXbqgHs6WT8pcoQ7YFhf/0W3z1ltdU9bB7vPxfcpET
        f3lmrAnku4LtKk9bA4BJ82C4+RfkfRcG9YBKbR9XvU82+m7Uq11QKo5zAOEa1ibw
        9ZSjlYrcOjlegOJgNTu9zqd5TkgtaOk7/2BtzKpwiXSAhHjJB3PxJZBBnwFb7PgQ
        nnTj5aeL9yJ/oqA5/H8NwvWBkXit5I0tQW6a3b+EH7LVaygzv7V7pc/wPNvAvD5J
        qLiwYglzSdFhafc+Liss/8+9voCiILXr9NpLscr4b+mZ31TctzWJWeU3J0XeifsO
        5yBq6KoIctqLeMltw8cvRKZ4HbtJ/iI9cyPnl0OWtQ==
X-ME-Sender: <xms:-pV_Y-nCtL1YvEPO3d_1qOIj_uESIPssgcN0O9nGJ2Co8z9knCLNrA>
    <xme:-pV_Y11v1jEpzkDO_q_v911YMNgNomj4-Yr1Nc5Xd55n9vYrXI1-YvrOlKSWqrFuo
    XUAxQza_EvVokI>
X-ME-Received: <xmr:-pV_Y8pQdycDIh7dhYKfQ5IoJDRaw8vE3V-rfKGGB_UQQ_WeV70gmEo96dhcotAtMh11p4fkdYaktSCk_BphZtZIs00>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrieefgdekgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedvudefveekheeugeeftddvveefgfduieefudeifefgleekheegleegjeejgeeg
    hfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:-pV_YylOfutk5X85BC1K2Y3E8lme1NEYq2nDDj9TVxc4t2wohH36jg>
    <xmx:-pV_Y83hD5fl4WeyGtifTWTNq5sCksfnUW9wZhUyIlWlRDjV2xBD2Q>
    <xmx:-pV_Y5vugwZuHMhQcb9Av7Lo-TBob2VcZ53z7AtaK0RWvQaYb15-ew>
    <xmx:-pV_Yx_9DX3GycmcvcMfncTntgtf9ROh0B4SlHORp-8gexcXe2sKiQ>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 24 Nov 2022 11:04:09 -0500 (EST)
Date:   Thu, 24 Nov 2022 18:04:06 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jonas Gorski <jonas.gorski@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>
Subject: Re: RTM_DELROUTE not sent anymore when deleting (last) nexthop of
 routes in 6.1
Message-ID: <Y3+V9gu4NUQ7P0mL@shredder>
References: <CAOiHx==ddZr6mvvbzgoAwwhJW76qGNVOcNsTG-6m79Ch+=aA5Q@mail.gmail.com>
 <Y39me56NhhPYewYK@shredder>
 <CAOiHx=kRew115+43rkPioe=wWNg1TNx5u9F3+frNkOK1M9PySw@mail.gmail.com>
 <CAOiHx=n2O1m24ZbMRbfD1=PCs-yYajpjNWR1y1oBP8Rz-8wA5A@mail.gmail.com>
 <Y3+Evdg9ODFVM9/w@shredder>
 <CAOiHx=mi-M+dWj-Y1ZZJ_xSY_-n0=xy9u1Gmx3Yw=zJHeuiS+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOiHx=mi-M+dWj-Y1ZZJ_xSY_-n0=xy9u1Gmx3Yw=zJHeuiS+A@mail.gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 24, 2022 at 04:20:49PM +0100, Jonas Gorski wrote:
> We have an integration test using FRR that got broken by this, so I
> can also easily test anything you throw at me (assuming CET working
> hours).

Please test the following fix [1]. Tested manually using [2]. With the
fix or 61b91eb33a69 reverted the route is successfully deleted. Without
the fix I get:

RTNETLINK answers: No such process
198.51.100.0/24 nhid 1 via 192.0.2.2 dev dummy10

If the fix is OK, I will submit it along with a selftest to make
sure it does not regress in the future.

Thanks

[1]
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index f721c308248b..19a662003eef 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -888,9 +888,11 @@ int fib_nh_match(struct net *net, struct fib_config *cfg, struct fib_info *fi,
                return 1;
        }
 
-       /* cannot match on nexthop object attributes */
-       if (fi->nh)
-               return 1;
+       if (fi->nh) {
+               if (cfg->fc_oif || cfg->fc_gw_family || cfg->fc_mp)
+                       return 1;
+               return 0;
+       }
 
        if (cfg->fc_oif || cfg->fc_gw_family) {
                struct fib_nh *nh;

[2]
#!/bin/bash

ip link del dev dummy10 &> /dev/null

ip link add name dummy10 up type dummy
ip address add 192.0.2.1/24 dev dummy10
ip nexthop add id 1 via 192.0.2.2 dev dummy10
ip route add 198.51.100.0/24 nhid 1
ip route del 198.51.100.0/24
ip route show 198.51.100.0/24
