Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A70CB2ED30B
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 15:51:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728831AbhAGOuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 09:50:03 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:44523 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727416AbhAGOuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 09:50:02 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 753C3183D;
        Thu,  7 Jan 2021 09:49:16 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Thu, 07 Jan 2021 09:49:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=L40mCiwgJXo5Vhobmz4hiW/1sO+CQGG7S3ktrQu4KmI=; b=o+Q+RZFa
        oQGOdMfyPA3WsAYJ0UDqzjQyLe9YzFc3gSC0kU4eUB2xnFu9cQhMIfrLSuWunMS3
        C4MfY4gT+ZH7S44E7jyHctsdVdWMPKhAOnlIGH8PeacTLKy329RpnHhnhioKCIU2
        IVu7jViURI/bnY8OWWMiG2uw2U3vYoC6iJxcA2GTyQzRTCCQJIrBZenjzxH+2iRi
        SuEeq5nERNUmMayb3IPcDcaJEthQHeWYL8hmptTGxn/4mGBrLTEdPou6JsrEZ+5v
        K3coxlPJGICRQGWSBpKCuTWY6GCvUCoJeqghofcH98yWRgMmivSPMloFX+PW63U4
        Qtu6nf9Ei3iB9Q==
X-ME-Sender: <xms:ax_3X_mKzvIyIPyeiVBeF1l-BO3_1_Uz7iUH1OTezz7l9sSpwPdtvA>
    <xme:ax_3Xyxjzma2tcOryDmBnHg4wPgV8S9Rlf7FKAPsBGJkZeWlIdZxVCZSiGUTc5O-d
    gSfp7I2zyNW4BI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdegvddgieelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:ax_3Xyi3rmg5F27Z2yOyHwu3Aih8Ht7_Q7pJDCqnpUlF3j6xGPNP4g>
    <xmx:ax_3X_XYfNUR8QcEPyCVeKkeocTdg_1P5dtKeq_1On04281sdZnEgA>
    <xmx:ax_3X82H75ciZ-VoSPoYAr8PgUbc60cdHdZmcf6Jwsmb-xSLWHKTkg>
    <xmx:bB_3X6jsuhqCGjoXCFsE3chK9G-yKbR16m40h9oaAuYHZ_hvjzMAlw>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id C1E771080064;
        Thu,  7 Jan 2021 09:49:13 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        dsahern@gmail.com, roopa@nvidia.com, nikolay@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 4/4] selftests: fib_nexthops: Fix wrong mausezahn invocation
Date:   Thu,  7 Jan 2021 16:48:24 +0200
Message-Id: <20210107144824.1135691-5-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210107144824.1135691-1-idosch@idosch.org>
References: <20210107144824.1135691-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

For IPv6 traffic, mausezahn needs to be invoked with '-6'. Otherwise an
error is returned:

 # ip netns exec me mausezahn veth1 -B 2001:db8:101::2 -A 2001:db8:91::1 -c 0 -t tcp "dp=1-1023, flags=syn"
 Failed to set source IPv4 address. Please check if source is set to a valid IPv4 address.
  Invalid command line parameters!

Fixes: 7c741868ceab ("selftests: Add torture tests to nexthop tests")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 tools/testing/selftests/net/fib_nexthops.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index eb693a3b7b4a..4c7d33618437 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -869,7 +869,7 @@ ipv6_torture()
 	pid3=$!
 	ip netns exec me ping -f 2001:db8:101::2 >/dev/null 2>&1 &
 	pid4=$!
-	ip netns exec me mausezahn veth1 -B 2001:db8:101::2 -A 2001:db8:91::1 -c 0 -t tcp "dp=1-1023, flags=syn" >/dev/null 2>&1 &
+	ip netns exec me mausezahn -6 veth1 -B 2001:db8:101::2 -A 2001:db8:91::1 -c 0 -t tcp "dp=1-1023, flags=syn" >/dev/null 2>&1 &
 	pid5=$!
 
 	sleep 300
-- 
2.29.2

