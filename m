Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC1533D670
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 16:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237760AbhCPPFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 11:05:01 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:57145 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237702AbhCPPEY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 11:04:24 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 6A5ED5C01C0;
        Tue, 16 Mar 2021 11:04:24 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 16 Mar 2021 11:04:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=htVvhrM4qSemkBvdeFXed0xX1L9JqLlFqArkENQJfVU=; b=MzvAVja4
        EdASmUIHEe00O0mcS87vYDizlketFC+qaOX+VEKqjWnCacK2G3XX4EAbk/VtRV9N
        yOauKCR/bkfJ+CLGpLW7cdJc8VV1on5HTLuaFI0ZfXLicOvUiOD2yudkO5QMgj9v
        XW8oBzISSVBTzy6LVJHA+6H4l8TxbmBg1iBANhSRBK/pGaDtW8ZQ6E2IU8J7Y7ws
        kPhN7G67hKzyOIkT8Ez6W9LFkTG0IHcL0Z6D5kMrVzqkmL6eh/bt7GXjpiSexDXn
        GGzA8cFM0RuXGjDnWHfvUs+m6ky8RNma5u15SyUItTdxXjn7F8tJ8pe2msDxwxbd
        /ZUEdEI2xTJcKg==
X-ME-Sender: <xms:-MhQYMQ8sGsn9SqR80cJirAo7p8b-0rGet7wHhgNss8qJYkj8cW0Kw>
    <xme:-MhQYJwTSHWK1RYBSxsVdnTjOAeKYUuP5f53A82Cfguz11iHP5YeNL_bxC0gsO7i_
    8qAY7ERtlyB7co>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudefvddgjeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:-MhQYJ3ZfgQb2OxWpzwzKw70N8_yM4FFwCVsVST-eilvWGtUCsrcwg>
    <xmx:-MhQYAAiJenk_T_YoSRGCkEfKmmD1_C-rPU2LPy27QYb2mpjrUhJZA>
    <xmx:-MhQYFg-nzWaXgpWl1TbMEyCZkXQ00r8Sk6F3n5d9RcgzOcSCuR4ow>
    <xmx:-MhQYDbzUjVOSKfmWrUFAQ9Rlvx_WpgIulRdFALMbqNdCCkhtTTI2Q>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 091EB1080063;
        Tue, 16 Mar 2021 11:04:21 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        roopa@nvidia.com, peter.phaal@inmon.com, neil.mckee@inmon.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 10/10] selftests: mlxsw: Test egress sampling limitation on Spectrum-1 only
Date:   Tue, 16 Mar 2021 17:03:03 +0200
Message-Id: <20210316150303.2868588-11-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210316150303.2868588-1-idosch@idosch.org>
References: <20210316150303.2868588-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Make sure egress sampling configuration only fails on Spectrum-1, given
that mlxsw now supports it on Spectrum-{2,3}.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 tools/testing/selftests/drivers/net/mlxsw/tc_restrictions.sh | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/tc_restrictions.sh b/tools/testing/selftests/drivers/net/mlxsw/tc_restrictions.sh
index 553cb9fad508..b4dbda706c4d 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/tc_restrictions.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/tc_restrictions.sh
@@ -18,6 +18,7 @@ NUM_NETIFS=2
 
 source $lib_dir/tc_common.sh
 source $lib_dir/lib.sh
+source $lib_dir/devlink_lib.sh
 
 switch_create()
 {
@@ -166,7 +167,8 @@ matchall_sample_egress_test()
 	RET=0
 
 	# It is forbidden in mlxsw driver to have matchall with sample action
-	# bound on egress
+	# bound on egress. Spectrum-1 specific restriction
+	[[ "$DEVLINK_VIDDID" != "15b3:cb84" ]] && return
 
 	tc qdisc add dev $swp1 clsact
 
-- 
2.29.2

