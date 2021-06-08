Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9E3E39F706
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 14:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232723AbhFHMqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 08:46:42 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:43613 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232705AbhFHMqi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 08:46:38 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id F3CF85C0143;
        Tue,  8 Jun 2021 08:44:44 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 08 Jun 2021 08:44:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=Nu7J7pNvpqCFJZuLTkkTkmiCN1pIlz+BJJUdl4RN+cQ=; b=gR1wlwYn
        gY8P5p8GvYUOhrLbTU1sjYq+XnJZPRTIj/W69XZ5ej+xOfcdXJhyGAlMLnLqp9Bx
        2S5l6sclSubTBMkw/RGMNJVTb1KN+13/RghJJWGjSMePgQxA4D9QaSlU6f0G5aV4
        T29biQeOKY9wJiZU4J5ZoRfTYhqxvYAxXlx7nxAya2JGvRxeH8SMmU1egRfLNJuy
        V/Z/NL/KGZcjmWuX2TMZtwLWLjTabN+qjFWr08/2vbz0GAAQvBFF7yZavkbM45Fh
        X1hPpDgq7KMzfUDC8MYm1UMqi9NJSPhSQpQQ+zGcPeRxQlMREcoM5uCKDHxbZUrD
        W5nuzQ15V9BHYg==
X-ME-Sender: <xms:PGa_YHZOiShXFUmjha4nksgfl5_KCxreTzTZIEum24SuGW9S65Y9pg>
    <xme:PGa_YGaIso8wzV4TdJNqeqwshMlfPn8SxdutoAaeVmNT27H15LqNvCHQEP95tDqzv
    7MIpENu1PNEYw8>
X-ME-Received: <xmr:PGa_YJ8P-L5VD_p54ynt-KfbWo704paCSXJyqAM-Kl0aZhq56rSWs6v1KUumLYLZ9FUAazyvGP4VcSulY5zJ8veo95a3GLKZmRZqQDeOEnIlRA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtledgfeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:PGa_YNrsHrtOKSubUijMG5Xil0Iz1yBoqe5mg1B0DofeciZxH4geiA>
    <xmx:PGa_YCp5Mhb4dQkbLTypw5-O2BWo5sjQR2W3OAnIZaTZ8rZlVr9wpA>
    <xmx:PGa_YDTv92vFWtzpIqEmRmpIrYw1PPpEFrN9yPhF80o3w_IXv445Jg>
    <xmx:PGa_YCL4BuKPIaBrv4vh1Rq6p8EGHUNA8FvcSfHr7pN9tNQxce2Nwg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Jun 2021 08:44:42 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, amcohen@nvidia.com, vadimp@nvidia.com,
        c_mykolak@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/8] selftests: router_scale: Do not count failed routes
Date:   Tue,  8 Jun 2021 15:44:08 +0300
Message-Id: <20210608124414.1664294-3-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210608124414.1664294-1-idosch@idosch.org>
References: <20210608124414.1664294-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

To check how many routes are installed in hardware, the test runs "ip
route" and greps for "offload", which includes routes with state
"offload_failed".

Till now, this wrong check was not found because after one failure in
route insertion, the driver moved to "abort" mode, which means that user
cannot try to add more routes.

The previous patch removed the abort mechanism and now failed routes are
counted as offloaded.

Fix this by not considering routes with "offload_failed" flag as
offloaded.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 tools/testing/selftests/drivers/net/mlxsw/router_scale.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/router_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/router_scale.sh
index e93878d42596..683759d29199 100644
--- a/tools/testing/selftests/drivers/net/mlxsw/router_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/router_scale.sh
@@ -68,7 +68,7 @@ wait_for_routes()
 	local t0=$1; shift
 	local route_count=$1; shift
 
-	local t1=$(ip route | grep -o 'offload' | wc -l)
+	local t1=$(ip route | grep 'offload' | grep -v 'offload_failed' | wc -l)
 	local delta=$((t1 - t0))
 	echo $delta
 	[[ $delta -ge $route_count ]]
-- 
2.31.1

