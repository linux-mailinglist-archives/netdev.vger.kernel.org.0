Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03E6243FB18
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 12:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231788AbhJ2K43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 06:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231719AbhJ2K42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 06:56:28 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D2FDC061570
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 03:54:00 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id r4so36655570edi.5
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 03:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b3qSGM0p6y4ZgfnoAyiZzzlY57n4MzHUR7ioYeiIdMs=;
        b=HR/oSlud9C/7XG9RmGUmGigozqBYikJPozqCKVTuoaq6kIWCJw2MFOpbB3ssr/CRNk
         WAGbgtsjODRJXLZPoQpy901q8DIa+vjwrw7CQTzFZOWybWWfWoCep1/BLCwFHnf+aXi2
         LWMGfcjinxI/mS7ORW78vIgo+Opma2ED2kqI+8fDe43NnELBAvzxuoK8gvcv6Y8efMSy
         FML03VWSWDG0YEoGLLfBbSsmCcDgGlXSbHKqScpet+/ucvFXA12KeZoEN773cPor44Jj
         /untbboy1Ora7/FEphwWqs8Gs00/xq1x2UtzQonFsyZtY8TDl6FdVtgwPeh+ZCAR08Pd
         M7Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b3qSGM0p6y4ZgfnoAyiZzzlY57n4MzHUR7ioYeiIdMs=;
        b=tnvRP5tTdTvl6d6egpttl5K3crIoD4egYTYTPAQ/uvCWim9f/Rx0GzJcPx9TEojXFo
         ZcrT+4SGNTO9YxR4+DY1t7Aisunu/xJsHmNXzhwXmvgIkYxzJS6/0ZPPNsJzT4rPnC8x
         ZWdF8PbCRI8pBO97lReSSCR9cNV2H56d/FbbbYOCrdZvg5IEzQxSkCbTbQYM4XiakIKh
         3tRUR1diDQWQn0g4zBS++m5zpeSoO3LUCE7iHqYYNdTJjvm4Qe7436jsP7pCeHk6LCLA
         XyYoa3mc6YCYc4C1HuqMZ4sedavUhKeTlCsnCSGRNC9ab98p1jAfyiUyjtMhM9EUkTcN
         JRIw==
X-Gm-Message-State: AOAM531ZC7dU9eFDShRdTtT/1XUId/6+FAXk5gmh4OKkE3nOskYRfqSj
        7rr3rIILZ+M/HSmc7euLT/ONTJuLFT/bhBel
X-Google-Smtp-Source: ABdhPJxCgRbaze6v8TWXYqiqM8WGL+XAmUxXWSIJc9pWXHzQnpJw2lKHd34kQ2bAR0xOl9O0+2CdUg==
X-Received: by 2002:a17:906:3a0e:: with SMTP id z14mr13126655eje.55.1635504837085;
        Fri, 29 Oct 2021 03:53:57 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id he17sm2842640ejc.58.2021.10.29.03.53.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Oct 2021 03:53:56 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net] selftests: net: bridge: update IGMP/MLD membership interval value
Date:   Fri, 29 Oct 2021 13:53:43 +0300
Message-Id: <20211029105343.2705436-1-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

When I fixed IGMPv3/MLDv2 to use the bridge's multicast_membership_interval
value which is chosen by user-space instead of calculating it based on
multicast_query_interval and multicast_query_response_interval I forgot
to update the selftests relying on that behaviour. Now we have to
manually set the expected GMI value to perform the tests correctly and get
proper results (similar to IGMPv2 behaviour).

Fixes: fac3cb82a54a ("net: bridge: mcast: use multicast_membership_interval for IGMPv3")
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 tools/testing/selftests/net/forwarding/bridge_igmp.sh | 3 +++
 tools/testing/selftests/net/forwarding/bridge_mld.sh  | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/bridge_igmp.sh b/tools/testing/selftests/net/forwarding/bridge_igmp.sh
index 675eff45b037..da031892ffd2 100755
--- a/tools/testing/selftests/net/forwarding/bridge_igmp.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_igmp.sh
@@ -483,9 +483,12 @@ v3exc_timeout_test()
 
 	# GMI should be 3 seconds
 	ip link set dev br0 type bridge mcast_query_interval 100 mcast_query_response_interval 100
+	ip link set dev br0 type bridge mcast_membership_interval 300
 
 	v3exclude_prepare $h1 $ALL_MAC $ALL_GROUP
 	ip link set dev br0 type bridge mcast_query_interval 500 mcast_query_response_interval 500
+	ip link set dev br0 type bridge mcast_membership_interval 1500
+
 	$MZ $h1 -c 1 -b $ALL_MAC -B $ALL_GROUP -t ip "proto=2,p=$MZPKT_ALLOW2" -q
 	sleep 3
 	bridge -j -d -s mdb show dev br0 \
diff --git a/tools/testing/selftests/net/forwarding/bridge_mld.sh b/tools/testing/selftests/net/forwarding/bridge_mld.sh
index ffdcfa87ca2b..96fdaa84606f 100755
--- a/tools/testing/selftests/net/forwarding/bridge_mld.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_mld.sh
@@ -480,9 +480,12 @@ mldv2exc_timeout_test()
 
 	# GMI should be 3 seconds
 	ip link set dev br0 type bridge mcast_query_interval 100 mcast_query_response_interval 100
+	ip link set dev br0 type bridge mcast_membership_interval 300
 
 	mldv2exclude_prepare $h1
 	ip link set dev br0 type bridge mcast_query_interval 500 mcast_query_response_interval 500
+	ip link set dev br0 type bridge mcast_membership_interval 1500
+
 	$MZ $h1 -c 1 $MZPKT_ALLOW2 -q
 	sleep 3
 	bridge -j -d -s mdb show dev br0 \
-- 
2.31.1

