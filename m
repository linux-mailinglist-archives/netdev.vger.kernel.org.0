Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47320F34DD
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389663AbfKGQna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:43:30 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:44791 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389585AbfKGQn2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 11:43:28 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id A27E221B55;
        Thu,  7 Nov 2019 11:43:27 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 07 Nov 2019 11:43:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=O3WpDLprjN7mqVOtaK5sI25pWrjZsgNTlaWquIAU72Q=; b=o5oDVh2h
        Cc+2lXvy/JJ+gNh6UBOIKXvuWjbKQyCzrmCZodbxBVjVorGyaxFmYgcaQYBC1yzY
        fYNgcCs96TmK6utB8TJelqBTMuFHnhviUg82HlI8CwsKRto5oga45O6lQ4oS0ye8
        tQvhTy9CrWEr+mtpPxiVfTvCWJ+ON0DDCjwPFDligVRZX2H9bVy6LwsweI4HtHHF
        zjifhtpU5dJ37590xsZ8RocqyqI6TMzz5+b1CnKFAkgWukGf2vHXGrHhDHSgTSeK
        ry/kWBjw+ab2QCPiWj/vm6jwmb/6IiE7cFIorkjEBH9pcumxVNCFTg3/6cO3Jf4e
        SLBY7X0HDfrGCg==
X-ME-Sender: <xms:r0nEXRw8T8J6cTH0_aWCGJkIxa0v5qZx96iNH4iZ0Yw3am6LnzKIfQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudduledgleduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeei
X-ME-Proxy: <xmx:r0nEXav1zkqgFN-UXu46WD-ed3Bx7SXXr6k_gyrTG-asGVn43hTVVA>
    <xmx:r0nEXa6JEN0m2YPplZXhm0LLm3b3bTJM_4NmZ-oxrR3Uua-bUU5lPA>
    <xmx:r0nEXZQGEFS3THCFl64aUX13BX4KzeS1Zbhnnw_C7VizchckJtOzqw>
    <xmx:r0nEXQHAVrfx4TadaJLXaou0jTOvVFSbek-MFdf9CfmhB4E1-UQK7g>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 228C58005C;
        Thu,  7 Nov 2019 11:43:25 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, amitc@mellanox.com,
        dsahern@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 10/12] selftests: forwarding: devlink: Add functionality for trap exceptions test
Date:   Thu,  7 Nov 2019 18:42:18 +0200
Message-Id: <20191107164220.20526-11-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191107164220.20526-1-idosch@idosch.org>
References: <20191107164220.20526-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

Add common part of all the tests - check devlink status to ensure that
packets were trapped.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../testing/selftests/net/forwarding/devlink_lib.sh  | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/devlink_lib.sh b/tools/testing/selftests/net/forwarding/devlink_lib.sh
index cbc38cc61873..40b076983239 100644
--- a/tools/testing/selftests/net/forwarding/devlink_lib.sh
+++ b/tools/testing/selftests/net/forwarding/devlink_lib.sh
@@ -356,6 +356,18 @@ devlink_trap_group_stats_idle_test()
 	fi
 }
 
+devlink_trap_exception_test()
+{
+	local trap_name=$1; shift
+	local group_name=$1; shift
+
+	devlink_trap_stats_idle_test $trap_name
+	check_fail $? "Trap stats idle when packets should have been trapped"
+
+	devlink_trap_group_stats_idle_test $group_name
+	check_fail $? "Trap group idle when packets should have been trapped"
+}
+
 devlink_trap_drop_test()
 {
 	local trap_name=$1; shift
-- 
2.21.0

