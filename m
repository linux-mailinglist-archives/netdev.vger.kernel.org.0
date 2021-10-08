Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3718F426B87
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 15:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242507AbhJHNPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 09:15:06 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41723 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242499AbhJHNPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 09:15:05 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 722F35C00E0;
        Fri,  8 Oct 2021 09:13:10 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 08 Oct 2021 09:13:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=Zy3T1abwhqeS/8cXqMqvRbE2ZHy4i5ttc0U1mCLzJkM=; b=nLoUwx3r
        ahIqqvsv8DRrfsqtGypblzu2x+5uAGusqjn+kfvbsw/n8z/Qep3+rVu8nPlWhh39
        gpdYupGYacveB08P3RbpB6fcrHHfHL0onUgOnM3bGU6pevTR+3kh6F9+1pi0wZYl
        RfRNXAYf/3qweXF+3x4XB6kKJToviLmmibb8eTMpmVutoxOgEMS/9oXwUTId0VJ5
        F9EYu1JXObdUG7aXEwa1BXGvjnaQCxrwesTy84WWlmBJgSMqgr7osTogrzTL/TeG
        j2q9aL9dF7uBJpwiH1d5PNVmkm70b6Ch5rU6I2Erq/aORalpDr4tG5mXUxqxOOlv
        zwP3Ckpb/P9vwQ==
X-ME-Sender: <xms:5kNgYVV10UrbLW4hhhl-heUbKicURV785_EIpPdLU5A9WcG-KGztYg>
    <xme:5kNgYVlv6zI0w7PjuXvpHKLTTifLI4o2hz2vRT87F2Pr01zPkh9gM-MeCti8vF6ji
    7X1kooO_mkwTJ8>
X-ME-Received: <xmr:5kNgYRa3tP-dFNk_qqSoAlEOnwlynXatxKEwXVeV_3pWtLHQz6crw92rupVab07V2rkqVVPgQVfSA-bpXu7qj8Y4BJ2GQrazVYOSnvsfIcT2kw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddttddgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:5kNgYYUkm11_pk8uk-TPgutCjIqnIQ7V5qCNKRQu-2epRS18N5aWFw>
    <xmx:5kNgYfnOvXpqtIutw_ilujqY4DW1wL1mtLzft40O_n6G34OLlwe4GQ>
    <xmx:5kNgYVdyNwc_J6smZ3E8toaxiWVOCTUno-oqRWezFzXl-R4y4ITwBQ>
    <xmx:5kNgYYBaK3ukm0FwCzcoZRv2vUPYG_QJ8leLr5N4wyi0Od6Z_frZsQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 8 Oct 2021 09:13:08 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/8] testing: selftests: tc_common: Add tc_check_at_least_x_packets()
Date:   Fri,  8 Oct 2021 16:12:35 +0300
Message-Id: <20211008131241.85038-3-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008131241.85038-1-idosch@idosch.org>
References: <20211008131241.85038-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Add function that checks that at least X packets hit the tc rule.
There are cases that it is not possible to catch only the interesting
packets, so then, it is possible to send many packets and verify that at
least this amount of packets hit the rule.

This function will be used in the next patch for general tc rule that
can be used to test both software and hardware.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 tools/testing/selftests/net/forwarding/tc_common.sh | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/tc_common.sh b/tools/testing/selftests/net/forwarding/tc_common.sh
index 0e18e8be6e2a..bce8bb8d2b6f 100644
--- a/tools/testing/selftests/net/forwarding/tc_common.sh
+++ b/tools/testing/selftests/net/forwarding/tc_common.sh
@@ -16,6 +16,16 @@ tc_check_packets()
 		 tc_rule_handle_stats_get "$id" "$handle" > /dev/null
 }
 
+tc_check_at_least_x_packets()
+{
+	local id=$1
+	local handle=$2
+	local count=$3
+
+	busywait "$TC_HIT_TIMEOUT" until_counter_is ">= $count" \
+		 tc_rule_handle_stats_get "$id" "$handle" > /dev/null
+}
+
 tc_check_packets_hitting()
 {
 	local id=$1
-- 
2.31.1

