Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1DE624EC21
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 10:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728531AbgHWIID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 04:08:03 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:40879 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728462AbgHWIH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 04:07:56 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id E80585C008C;
        Sun, 23 Aug 2020 04:07:54 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 23 Aug 2020 04:07:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=7odKLliOtxcwkZ27IUXNRTxOsIZfg8r0KFD0KvL/d2M=; b=Wjqk9Bf0
        h8HFSAAppJ3Vp4yR6WAdDFV72Xoy1waCsYtaPbuavKdXnpVUBS+SQ5MhB5z6HgBP
        2PHZ8M9GiDRyfDy3DnJgZIXIEKP98dtwc8Yq2J7x6R8Iekd90hiOWqHdnoSFWhEB
        pI5HXKKk3N62LvTsWkF5Ha6pbVD5ZltIkrj4/hqDFPzXRG4/HQD4/u6+KajLeWCe
        L22WoGUta4k+5tlM/RI0ihy2kzECd0b6iY3QRBsR1fE89R8QWAsyrB76ULhl9LFS
        nO5VTZLjqqKru3DGg5BjvEFnLTc377F+edPQqYD0IjLFI+BboeSWAmAf0fYDRxGo
        sxOV9VkihMbS/Q==
X-ME-Sender: <xms:2iNCX6BgSnQ3u4ticDrr8XfjXKiHucXX1JidpuOT6dxAosbAK0v2cQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudduiecutefuodetggdotefrodftvfcurf
    hrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepkfguohcuufgthhhi
    mhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvghrnh
    epudetieevffffveelkeeljeffkefhkeehgfdtffethfelvdejgffghefgveejkefhnecu
    kfhppeejledrudejkedrudefuddrfeehnecuvehluhhsthgvrhfuihiivgepfeenucfrrg
    hrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:2iNCX0gA8XE_q_B394oUvk_5XLRvJbBs69sqCcvWs1tORMOMFdi2iw>
    <xmx:2iNCX9kmnrOO1T8HOHxUfm2hBP387ESIxYZqgx7VY-Leo9PT9qm5nw>
    <xmx:2iNCX4zsLNSnUWY3sW_OBauEmQz5RxNssNVOp32KzEzpNh9ZQXiouA>
    <xmx:2iNCX6dbhhMegeJdD5cIJ0Irg7Os9ZCq5Fxk6hBmODxUwVYGOi0zNA>
Received: from shredder.mtl.com (bzq-79-178-131-35.red.bezeqint.net [79.178.131.35])
        by mail.messagingengine.com (Postfix) with ESMTPA id DDA663280059;
        Sun, 23 Aug 2020 04:07:52 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Danielle Ratson <danieller@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 5/7] selftests: forwarding: Fix mausezahn delay parameter in mirror_test()
Date:   Sun, 23 Aug 2020 11:06:26 +0300
Message-Id: <20200823080628.407637-6-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200823080628.407637-1-idosch@idosch.org>
References: <20200823080628.407637-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@mellanox.com>

Currently, mausezahn delay parameter in mirror_test() is specified with
'ms' units.

mausezahn versions before 0.6.5 interpret 'ms' as seconds and therefore
the tests that use mirror_test() take a very long time to complete.

Resolve this by specifying 'msec' units.

Signed-off-by: Danielle Ratson <danieller@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 tools/testing/selftests/net/forwarding/mirror_lib.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/mirror_lib.sh b/tools/testing/selftests/net/forwarding/mirror_lib.sh
index c33bfd7ba214..13db1cb50e57 100644
--- a/tools/testing/selftests/net/forwarding/mirror_lib.sh
+++ b/tools/testing/selftests/net/forwarding/mirror_lib.sh
@@ -31,7 +31,7 @@ mirror_test()
 
 	local t0=$(tc_rule_stats_get $dev $pref)
 	$MZ $vrf_name ${sip:+-A $sip} -B $dip -a own -b bc -q \
-	    -c 10 -d 100ms -t icmp type=8
+	    -c 10 -d 100msec -t icmp type=8
 	sleep 0.5
 	local t1=$(tc_rule_stats_get $dev $pref)
 	local delta=$((t1 - t0))
-- 
2.26.2

