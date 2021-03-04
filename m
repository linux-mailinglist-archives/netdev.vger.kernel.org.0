Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE69632CF31
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 10:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237284AbhCDI7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 03:59:44 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:43027 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237271AbhCDI7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 03:59:36 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id A93DF5C0108;
        Thu,  4 Mar 2021 03:58:30 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 04 Mar 2021 03:58:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=S4nwVKHfekbNYrlZ2oFN9cxA36UZOWfUGlxaX62//Sg=; b=uwnh2djy
        i3rkZ3N+n1DsdDbg/UFwWB+wselYM0CtouaOSZ0TpnmDaaPcxQwVxQX+p0jIiWIC
        rVFxUFJILIzp6FnK1axLeohRYcpp7DYGHNP4LdN1gxyQRilJjfwmZg3IQwX0ihHo
        Rb2Hc3xIqo/62OumDYTeJOVpwtUTG2EyMXRL1YS2WF1jgyPykcphDUS7rp+cLAnk
        pFTN5AQVO6255ReAVQ9AlGkCL9U/OQTQFPkzPUdglBtpXYQpjXO+ZuUPrbXxMNTZ
        fRjWtt+s4RvIq5cxxky9v000lr4m5PZfCPkaVt6KD0TXMKgMO5HOTD/emhuUJyS4
        itJpcfsf2EgL2w==
X-ME-Sender: <xms:NqFAYLQB36cc6yN8ewdI143ccGe5WujK-JBLvJk2woZuEZjHh4btbg>
    <xme:NqFAYMyNYcdDhrKjqjFY0eE39p2DcxKW2VLWihEDLg-PsekaTHkhFc0hcSuwDts9T
    Pkuo0xss-r6RHc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddtfedguddugecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheefrdeg
    geenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:NqFAYA0AXyF0duiy4IaCShvV_CXjA4f6oDZyUcGErqA16TUld_buVg>
    <xmx:NqFAYLAfXiZqymQqitXSxTl0LhOEbzJyTtnZLtUf_plZa_hhT8jViQ>
    <xmx:NqFAYEhiD_keAjlERNIz71mwdSYc5x1u1ecrIrBMDkVeHP5Evvr0BA>
    <xmx:NqFAYMcBFEYNHs7g8TWWaBSwH0AZf4CXEpmPNsIcV8VQvqrc9vL2Jg>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 95F9F1080059;
        Thu,  4 Mar 2021 03:58:28 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        roopa@nvidia.com, sharpd@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 2/2] selftests: fib_nexthops: Test blackhole nexthops when loopback goes down
Date:   Thu,  4 Mar 2021 10:57:54 +0200
Message-Id: <20210304085754.1929848-3-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210304085754.1929848-1-idosch@idosch.org>
References: <20210304085754.1929848-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Test that blackhole nexthops are not flushed when the loopback device
goes down.

Output without previous patch:

 # ./fib_nexthops.sh -t basic

 Basic functional tests
 ----------------------
 TEST: List with nothing defined                                     [ OK ]
 TEST: Nexthop get on non-existent id                                [ OK ]
 TEST: Nexthop with no device or gateway                             [ OK ]
 TEST: Nexthop with down device                                      [ OK ]
 TEST: Nexthop with device that is linkdown                          [ OK ]
 TEST: Nexthop with device only                                      [ OK ]
 TEST: Nexthop with duplicate id                                     [ OK ]
 TEST: Blackhole nexthop                                             [ OK ]
 TEST: Blackhole nexthop with other attributes                       [ OK ]
 TEST: Blackhole nexthop with loopback device down                   [FAIL]
 TEST: Create group                                                  [ OK ]
 TEST: Create group with blackhole nexthop                           [FAIL]
 TEST: Create multipath group where 1 path is a blackhole            [ OK ]
 TEST: Multipath group can not have a member replaced by blackhole   [ OK ]
 TEST: Create group with non-existent nexthop                        [ OK ]
 TEST: Create group with same nexthop multiple times                 [ OK ]
 TEST: Replace nexthop with nexthop group                            [ OK ]
 TEST: Replace nexthop group with nexthop                            [ OK ]
 TEST: Nexthop group and device                                      [ OK ]
 TEST: Test proto flush                                              [ OK ]
 TEST: Nexthop group and blackhole                                   [ OK ]

 Tests passed:  19
 Tests failed:   2

Output with previous patch:

 # ./fib_nexthops.sh -t basic

 Basic functional tests
 ----------------------
 TEST: List with nothing defined                                     [ OK ]
 TEST: Nexthop get on non-existent id                                [ OK ]
 TEST: Nexthop with no device or gateway                             [ OK ]
 TEST: Nexthop with down device                                      [ OK ]
 TEST: Nexthop with device that is linkdown                          [ OK ]
 TEST: Nexthop with device only                                      [ OK ]
 TEST: Nexthop with duplicate id                                     [ OK ]
 TEST: Blackhole nexthop                                             [ OK ]
 TEST: Blackhole nexthop with other attributes                       [ OK ]
 TEST: Blackhole nexthop with loopback device down                   [ OK ]
 TEST: Create group                                                  [ OK ]
 TEST: Create group with blackhole nexthop                           [ OK ]
 TEST: Create multipath group where 1 path is a blackhole            [ OK ]
 TEST: Multipath group can not have a member replaced by blackhole   [ OK ]
 TEST: Create group with non-existent nexthop                        [ OK ]
 TEST: Create group with same nexthop multiple times                 [ OK ]
 TEST: Replace nexthop with nexthop group                            [ OK ]
 TEST: Replace nexthop group with nexthop                            [ OK ]
 TEST: Nexthop group and device                                      [ OK ]
 TEST: Test proto flush                                              [ OK ]
 TEST: Nexthop group and blackhole                                   [ OK ]

 Tests passed:  21
 Tests failed:   0

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
---
 tools/testing/selftests/net/fib_nexthops.sh | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index 4c7d33618437..d98fb85e201c 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -1524,6 +1524,14 @@ basic()
 	run_cmd "$IP nexthop replace id 2 blackhole dev veth1"
 	log_test $? 2 "Blackhole nexthop with other attributes"
 
+	# blackhole nexthop should not be affected by the state of the loopback
+	# device
+	run_cmd "$IP link set dev lo down"
+	check_nexthop "id 2" "id 2 blackhole"
+	log_test $? 0 "Blackhole nexthop with loopback device down"
+
+	run_cmd "$IP link set dev lo up"
+
 	#
 	# groups
 	#
-- 
2.29.2

