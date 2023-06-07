Return-Path: <netdev+bounces-8986-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B43E77267AA
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 19:44:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6EF7E28144B
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 17:43:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0ACD238CB0;
	Wed,  7 Jun 2023 17:43:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FA01772E
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 17:43:28 +0000 (UTC)
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF841FF9
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 10:43:24 -0700 (PDT)
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 5A9E33F166
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 17:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1686159801;
	bh=29oAQXm1vubqWw6n+W3ki/F3nkC70PmxLYid2aXxsMY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version;
	b=gunoR96OY32OQEnMV7heg+DK0R2m0MUwZC3MIT5LE4erTMbSm4BP2yV+0MoGVVh4j
	 dp8Vo5tYKku0u7OYkm7xzlBslf0Lt07muL3OQ0NzCbooepluPaHi65UKhQk62Hcd4M
	 OophgjNq70T6NuDHAodmIN2+KZN2T3POcWW+PodejhrZNjdDFfSe+BIRIv3vZfWYbg
	 NOe/5ux4y9WSP5gxZQORzhdi5CXWV6nxFKQKO3WWRYLMH+kg/6585rljsl5ORdwZMq
	 6pLJXZ9iMaTOZYlhJUifXeeGtH2iKhy36NNiZ4JtbZzT4pu/0ZBTRGNDaWRcF6NfFn
	 NuSuWzIuT6htg==
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-6af6e80d24aso6998101a34.1
        for <netdev@vger.kernel.org>; Wed, 07 Jun 2023 10:43:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686159800; x=1688751800;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=29oAQXm1vubqWw6n+W3ki/F3nkC70PmxLYid2aXxsMY=;
        b=PjfjBYN+dsaN2zBaqftCW2UXq34BBtpI1HBnqfeBmJAZXJcYcgs9MZTSlWbrvfJaNV
         ek0miKr+Bn+x/BYocaZFYP+nHljHQU4uvdEDeMayf89ZWAeMf6AZUV87FJd+sA/a2rcH
         b2EznXdIWcvKCP+G7xjYySPndsG3ED3gIHc6RtW59AjZe6p4phqv2J2HyJ6BbiLfa5TX
         kLxx8RvBl2cNC7cfjBQD9OGd3W/iVLZTMS4I38nSONscalpPc+NcouqzFDTOD/FJosu+
         zzoerMcnMyGwkLkNyuP1X4WJbbJZvyEFhzkPCAOq2KOC3tLzbkxARanlaYffJMb+LoCo
         B1Rw==
X-Gm-Message-State: AC+VfDzm26p00w4mdLt4hGJq45SnF7u2GxFJS/SdS/FJDxn7koZ/RIZY
	+JHyHQMzbWNMI5a5QJCXzAGQAhcvXGjGZs/RI9I9iHbfCynR8nmAR3pltfQUTI5bPYweql1qJoi
	ojiitj4FE/BwSyMqEhb18KbsROgGhdUsbdg==
X-Received: by 2002:a05:6870:d343:b0:1a3:b43:9c88 with SMTP id h3-20020a056870d34300b001a30b439c88mr5870243oag.34.1686159800625;
        Wed, 07 Jun 2023 10:43:20 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ766oAJ56zMbU7HSmkwtI2C3rOqyJHM8UGEwfRspDmam1gxj9T7PZk5HFQWFzUo+t+bKzFXUg==
X-Received: by 2002:a05:6870:d343:b0:1a3:b43:9c88 with SMTP id h3-20020a056870d34300b001a30b439c88mr5870234oag.34.1686159800416;
        Wed, 07 Jun 2023 10:43:20 -0700 (PDT)
Received: from mingau.. ([2804:7f0:b443:8cea:efdc:2496:54f7:d884])
        by smtp.gmail.com with ESMTPSA id c10-20020a9d75ca000000b006ac75cff491sm2176016otl.3.2023.06.07.10.43.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 10:43:20 -0700 (PDT)
From: Magali Lemes <magali.lemes@canonical.com>
To: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	shuah@kernel.org,
	dsahern@gmail.com
Cc: andrei.gherzan@canonical.com,
	netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net 3/3] selftests: net: fcnal-test: check if FIPS mode is enabled
Date: Wed,  7 Jun 2023 14:43:02 -0300
Message-Id: <20230607174302.19542-4-magali.lemes@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230607174302.19542-1-magali.lemes@canonical.com>
References: <20230607174302.19542-1-magali.lemes@canonical.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

There are some MD5 tests which fail when the kernel is in FIPS mode,
since MD5 is not FIPS compliant. Add a check and only run those tests
if FIPS mode is not enabled.

Fixes: f0bee1ebb5594 ("fcnal-test: Add TCP MD5 tests")
Fixes: 5cad8bce26e01 ("fcnal-test: Add TCP MD5 tests for VRF")
Signed-off-by: Magali Lemes <magali.lemes@canonical.com>
---
 tools/testing/selftests/net/fcnal-test.sh | 27 ++++++++++++++++-------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 21ca91473c09..ee6880ac3e5e 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -92,6 +92,13 @@ NSC_CMD="ip netns exec ${NSC}"
 
 which ping6 > /dev/null 2>&1 && ping6=$(which ping6) || ping6=$(which ping)
 
+# Check if FIPS mode is enabled
+if [ -f /proc/sys/crypto/fips_enabled ]; then
+	fips_enabled=`cat /proc/sys/crypto/fips_enabled`
+else
+	fips_enabled=0
+fi
+
 ################################################################################
 # utilities
 
@@ -1216,7 +1223,7 @@ ipv4_tcp_novrf()
 	run_cmd nettest -d ${NSA_DEV} -r ${a}
 	log_test_addr ${a} $? 1 "No server, device client, local conn"
 
-	ipv4_tcp_md5_novrf
+	[ "$fips_enabled" = "1" ] || ipv4_tcp_md5_novrf
 }
 
 ipv4_tcp_vrf()
@@ -1270,9 +1277,11 @@ ipv4_tcp_vrf()
 	log_test_addr ${a} $? 1 "Global server, local connection"
 
 	# run MD5 tests
-	setup_vrf_dup
-	ipv4_tcp_md5
-	cleanup_vrf_dup
+	if [ "$fips_enabled" = "0" ]; then
+		setup_vrf_dup
+		ipv4_tcp_md5
+		cleanup_vrf_dup
+	fi
 
 	#
 	# enable VRF global server
@@ -2772,7 +2781,7 @@ ipv6_tcp_novrf()
 		log_test_addr ${a} $? 1 "No server, device client, local conn"
 	done
 
-	ipv6_tcp_md5_novrf
+	[ "$fips_enabled" = "1" ] || ipv6_tcp_md5_novrf
 }
 
 ipv6_tcp_vrf()
@@ -2842,9 +2851,11 @@ ipv6_tcp_vrf()
 	log_test_addr ${a} $? 1 "Global server, local connection"
 
 	# run MD5 tests
-	setup_vrf_dup
-	ipv6_tcp_md5
-	cleanup_vrf_dup
+	if [ "$fips_enabled" = "0" ]; then
+		setup_vrf_dup
+		ipv6_tcp_md5
+		cleanup_vrf_dup
+	fi
 
 	#
 	# enable VRF global server
-- 
2.34.1


