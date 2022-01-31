Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51E304A4AE3
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 16:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379866AbiAaPrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 10:47:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379821AbiAaPrN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 10:47:13 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64CCCC06173B
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 07:47:12 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id t9so19946567lji.12
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 07:47:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=oi9yvU3XKTdc5uhXdMEKWVeiea3s3v3BWMJvFWzqoII=;
        b=TAh0C2wliAYjMd4G1rAPxd/DFTr3IOIZa1naAEywf9trhKvRPRrNYFhN+R2+nFtnnf
         9dC8Fxiv09pGPLaUC7kv4Qb2jWaeOUFfpc8zhviw7bSWy2EnvMVIF5MFFheCw4LFob7N
         BqX9W2bCzfIa2Am3hkOr5nYSbkC/Eo1kNXWPBX0XHfFv0jBNvqo5KhFG8JmVtGZVd52A
         ih8KTtrXhhbTtizICgog7Kk9GEE8DO/PS8PL8eBKnXwCaYRRzuHoEA4aDHDwmZ3rnh0s
         Y0dR6NwKUGZnj+JSbwOXd+fJfs/2jclqvGudIcMNoCTfrKiMoNEfNN/Xbu1JkCAf6oKp
         ApSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=oi9yvU3XKTdc5uhXdMEKWVeiea3s3v3BWMJvFWzqoII=;
        b=4FlYGiQ5EEGXMLTNTU25RtUppPCNLhvQfLNCHFVPzrpxT8WfmKg058UNQlKU3hYpZ/
         6d4QJ6DnVXQqcFE01zI380M7uppUTM8S0rE7/AEVsEJAbFpdZUt5BDD1Vxmz783wVLPh
         B3wxl3OWBX2+5x71cVANq7+JhICy93zvZ5ZsFIWu47guuAo/LOD0b20C6IQJkyXKMp88
         r2FEQgK+uX+2fFHIuvAzQlhtAb3vWmeZ17iQm1eohhF/27EnC9xHaboGaHvnqey9fdvl
         RpIagwc/VYEgE/yxcocF+IRRcaAUXqwmJ5Wc1mRg0t7LkIdFiyrrpCZqdyidpTSwBkpJ
         wwZA==
X-Gm-Message-State: AOAM5322dlATIkK4e32MsondX2OWRhRGfCLxnK6ddThhtkhqXFw7/4Le
        rMoOajSxpuzBDt5Fa010BX9MpQ==
X-Google-Smtp-Source: ABdhPJyQQfbSWV9V3EsbXhsuEJCNUlwB19GG+Vcl3voDZSZwcVMWvgDaeQzvVe++yfXD/cZJKwGaaw==
X-Received: by 2002:a2e:9d96:: with SMTP id c22mr10537327ljj.293.1643644030741;
        Mon, 31 Jan 2022 07:47:10 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id y36sm3374769lfa.82.2022.01.31.07.47.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 07:47:10 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>,
        David Ahern <dsahern@kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Stephen Suryaputra <ssuryaextr@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Guillaume Nault <gnault@redhat.com>,
        Po-Hsu Lin <po-hsu.lin@canonical.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/5] selftests: net: bridge: Parameterize ageing timeout
Date:   Mon, 31 Jan 2022 16:46:55 +0100
Message-Id: <20220131154655.1614770-6-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220131154655.1614770-1-tobias@waldekranz.com>
References: <20220131154655.1614770-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow the ageing timeout that is set on bridges to be customized from
forwarding.config. This allows the tests to be run on hardware which
does not support a 10s timeout (e.g. mv88e6xxx).

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 tools/testing/selftests/net/forwarding/bridge_vlan_aware.sh  | 5 +++--
 .../testing/selftests/net/forwarding/bridge_vlan_unaware.sh  | 5 +++--
 .../selftests/net/forwarding/forwarding.config.sample        | 2 ++
 tools/testing/selftests/net/forwarding/lib.sh                | 1 +
 4 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_vlan_aware.sh b/tools/testing/selftests/net/forwarding/bridge_vlan_aware.sh
index b90dff8d3a94..64bd00fe9a4f 100755
--- a/tools/testing/selftests/net/forwarding/bridge_vlan_aware.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_vlan_aware.sh
@@ -28,8 +28,9 @@ h2_destroy()
 
 switch_create()
 {
-	# 10 Seconds ageing time.
-	ip link add dev br0 type bridge vlan_filtering 1 ageing_time 1000 \
+	ip link add dev br0 type bridge \
+		vlan_filtering 1 \
+		ageing_time $LOW_AGEING_TIME \
 		mcast_snooping 0
 
 	ip link set dev $swp1 master br0
diff --git a/tools/testing/selftests/net/forwarding/bridge_vlan_unaware.sh b/tools/testing/selftests/net/forwarding/bridge_vlan_unaware.sh
index c15c6c85c984..1c8a26046589 100755
--- a/tools/testing/selftests/net/forwarding/bridge_vlan_unaware.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_vlan_unaware.sh
@@ -27,8 +27,9 @@ h2_destroy()
 
 switch_create()
 {
-	# 10 Seconds ageing time.
-	ip link add dev br0 type bridge ageing_time 1000 mcast_snooping 0
+	ip link add dev br0 type bridge \
+		ageing_time $LOW_AGEING_TIME \
+		mcast_snooping 0
 
 	ip link set dev $swp1 master br0
 	ip link set dev $swp2 master br0
diff --git a/tools/testing/selftests/net/forwarding/forwarding.config.sample b/tools/testing/selftests/net/forwarding/forwarding.config.sample
index b0980a2efa31..4a546509de90 100644
--- a/tools/testing/selftests/net/forwarding/forwarding.config.sample
+++ b/tools/testing/selftests/net/forwarding/forwarding.config.sample
@@ -41,6 +41,8 @@ NETIF_CREATE=yes
 # Timeout (in seconds) before ping exits regardless of how many packets have
 # been sent or received
 PING_TIMEOUT=5
+# Minimum ageing_time (in centiseconds) supported by hardware
+LOW_AGEING_TIME=1000
 # Flag for tc match, supposed to be skip_sw/skip_hw which means do not process
 # filter by software/hardware
 TC_FLAG=skip_hw
diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 7da783d6f453..e7e434a4758b 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -24,6 +24,7 @@ PING_COUNT=${PING_COUNT:=10}
 PING_TIMEOUT=${PING_TIMEOUT:=5}
 WAIT_TIMEOUT=${WAIT_TIMEOUT:=20}
 INTERFACE_TIMEOUT=${INTERFACE_TIMEOUT:=600}
+LOW_AGEING_TIME=${LOW_AGEING_TIME:=1000}
 REQUIRE_JQ=${REQUIRE_JQ:=yes}
 REQUIRE_MZ=${REQUIRE_MZ:=yes}
 
-- 
2.25.1

