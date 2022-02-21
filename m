Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7364BE367
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358854AbiBUNTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 08:19:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232982AbiBUNTP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 08:19:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0982C1EEF7;
        Mon, 21 Feb 2022 05:18:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91E5D6137C;
        Mon, 21 Feb 2022 13:18:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE45C340E9;
        Mon, 21 Feb 2022 13:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645449530;
        bh=zZBPLOwN6VC415V5nh8joz0veP6og+pbcOBCbahM5NY=;
        h=From:To:Cc:Subject:Date:From;
        b=tII7+LMLdbC5SVB2FtWb7FEzAeHIwAAc7hck7Mk5k7BIJa5ZC+l5QzIHp0AGiq0X2
         UR80X/ciAYECVR636j0ilnAmXMdL2J+P21y9xkwTnjAKd+yVPiDKfUtgqqPewazSl+
         WX7Lo+qrwPdXkRF48WdblnbBPHYqYB9U6l3HREEmvkInODlHDJ3MHC43sIXxtV6Jpq
         7Uz3S64nVyhSZOtRLoKFXK72a7+q9wo6upqb/OLFv8kjDQBlQO3PhzzNxiLWaqW0/Z
         oUf/Xudcffgr4uj9hBRtO5kuwJ6Th8voIrviv0OwXKFDWkIJ7TWzdT4dqkMIFQEyYA
         2serFy4vZWSPA==
From:   broonie@kernel.org
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Geliang Tang <geliang.tang@suse.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Date:   Mon, 21 Feb 2022 13:18:42 +0000
Message-Id: <20220221131842.468893-1-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  tools/testing/selftests/net/mptcp/mptcp_join.sh

between commit:

  6ef84b1517e08 ("selftests: mptcp: more robust signal race test")

from the net tree and commit:

  34aa6e3bccd86 ("selftests: mptcp: add ip mptcp wrappers")

from the net-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

diff --cc tools/testing/selftests/net/mptcp/mptcp_join.sh
index 0c8a2a20b96cf,725924012b412..0000000000000
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@@ -1163,20 -1287,17 +1302,21 @@@ signal_address_tests(
  
  	# signal addresses race test
  	reset
- 	ip netns exec $ns1 ./pm_nl_ctl limits 4 4
- 	ip netns exec $ns2 ./pm_nl_ctl limits 4 4
- 	ip netns exec $ns1 ./pm_nl_ctl add 10.0.1.1 flags signal
- 	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
- 	ip netns exec $ns1 ./pm_nl_ctl add 10.0.3.1 flags signal
- 	ip netns exec $ns1 ./pm_nl_ctl add 10.0.4.1 flags signal
- 	ip netns exec $ns2 ./pm_nl_ctl add 10.0.1.2 flags signal
- 	ip netns exec $ns2 ./pm_nl_ctl add 10.0.2.2 flags signal
- 	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags signal
- 	ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags signal
++
+ 	pm_nl_set_limits $ns1 4 4
+ 	pm_nl_set_limits $ns2 4 4
+ 	pm_nl_add_endpoint $ns1 10.0.1.1 flags signal
+ 	pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+ 	pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
+ 	pm_nl_add_endpoint $ns1 10.0.4.1 flags signal
+ 	pm_nl_add_endpoint $ns2 10.0.1.2 flags signal
+ 	pm_nl_add_endpoint $ns2 10.0.2.2 flags signal
+ 	pm_nl_add_endpoint $ns2 10.0.3.2 flags signal
+ 	pm_nl_add_endpoint $ns2 10.0.4.2 flags signal
 -	run_tests $ns1 $ns2 10.0.1.1
 +
 +	# the peer could possibly miss some addr notification, allow retransmission
 +	ip netns exec $ns1 sysctl -q net.mptcp.add_addr_timeout=1
 +	run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow
  	chk_join_nr "signal addresses race test" 3 3 3
  
  	# the server will not signal the address terminating
