Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00334DA5D2
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 08:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407854AbfJQG4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 02:56:16 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:33897 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407840AbfJQG4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 02:56:14 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 1728721E29;
        Thu, 17 Oct 2019 02:56:14 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 17 Oct 2019 02:56:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=uDVl0436XZC/s20UySMrcqlEzp9F/jiNL5Ss+11krKA=; b=VlcB3dmD
        GTmEqg11OnfhrexRffhCi1gjn9E9np3ohF1PcHhLHtxvRMJiPTnHusF71UnMxWu0
        Ak2cDuJXxsOAl+RL69u1jaYuArgKKyhh3Sn4UsWSZvw9nF/TH4lDPubjrGLgWkZ3
        x5klXgFdCWnwXnIuPUJGvjGe+bLpgwclDe4n/MY4MxIBVXJ4363SlGiaemZQTSw6
        fcBRQRQwcjcWIdsPWhz7RSqf+cSjNYwQ8BijM1iXi0Fe8V0ItL80IeZbSONZkcOC
        XgHcJ8kKi+m4GbzP9g4OFGygzbLLWrbWR4cTQKFrkAMU4W8dYN/pVJpXrrwD7Wr3
        Tkd0CIVYrP6lEQ==
X-ME-Sender: <xms:jRCoXS68YlwdS-jlX_CSbQNEyjPTuGGXLRXzfXsbb15cNDN0sMPO1A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrjeeigdduudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:jRCoXSWVTXPRFnvbAStbuYFv6wz4q2PIyiXjXmYPk_NTKACvCCPe4g>
    <xmx:jRCoXe9yMipS19-tOCT1_f2XyEXQmHnygempdEt6yq0-coyaGdyRkg>
    <xmx:jRCoXXi3y_-2LN8rP24Stw5LrpJANiIZzDFNfHHA0MH28kv9IAwwEw>
    <xmx:jhCoXfwnEQDH1n-0kJihpNIm9XwfjCfCMsT6cD5feR3nT5e_xG2-Lg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id C537AD6005B;
        Thu, 17 Oct 2019 02:56:12 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, danieller@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 3/5] selftests: mlxsw: Add Spectrum-2 mirror-to-gretap target scale test
Date:   Thu, 17 Oct 2019 09:55:16 +0300
Message-Id: <20191017065518.27008-4-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191017065518.27008-1-idosch@idosch.org>
References: <20191017065518.27008-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@mellanox.com>

Like in Spectrum, use the number of analyzers taken from the devlink
command.

Signed-off-by: Danielle Ratson <danieller@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/mlxsw/spectrum-2/mirror_gre_scale.sh     | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)
 create mode 100644 tools/testing/selftests/drivers/net/mlxsw/spectrum-2/mirror_gre_scale.sh

diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/mirror_gre_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/mirror_gre_scale.sh
new file mode 100644
index 000000000000..f7c168decd1e
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/mirror_gre_scale.sh
@@ -0,0 +1,16 @@
+# SPDX-License-Identifier: GPL-2.0
+source ../mirror_gre_scale.sh
+
+mirror_gre_get_target()
+{
+	local should_fail=$1; shift
+	local target
+
+	target=$(devlink_resource_size_get span_agents)
+
+	if ((! should_fail)); then
+		echo $target
+	else
+		echo $((target + 1))
+	fi
+}
-- 
2.21.0

