Return-Path: <netdev+bounces-10379-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 12B4F72E31D
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 14:33:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C2E4828127C
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 12:33:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C31BB107BE;
	Tue, 13 Jun 2023 12:32:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89288BFE
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 12:32:59 +0000 (UTC)
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 317E3173F
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 05:32:51 -0700 (PDT)
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 2F3303F271
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 12:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1686659569;
	bh=kHrI60HGgHX5jqkZGeWx9fzAxW6E9mR4OgwfiGnOAxQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version;
	b=Po+PW+5vTbT7HS4AlEQdC9ynxyK4jBPrLfKZ9DfPZxWOwLjPOpezkZBxRTbrTB3AJ
	 ZmkaU2f05i1uWNN1FH25EtHSJfLa8+2uORDl5HWtj6tIiBYiNiDVPLi19+ma6/gR9q
	 j7v28ytB7J5i//CJunj2BNQcEm9NGJybWVfqxy50cAQXf14FDlFsx8EiYExtB6+8Nv
	 3YUGbIbt8K+d81lrvJyu0ueZgKAWAjfDSsh33oE+ik/2L8j8fYTaveGAITfJOjkDUu
	 J/x31873r+wS+PJiebkfOMxy4mQMS7dguBegbjv1YJUO7faCxDnxg1wfPSU9rf/5zM
	 sYayoDFmavGNQ==
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-39cdb840b72so1684083b6e.0
        for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 05:32:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686659568; x=1689251568;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kHrI60HGgHX5jqkZGeWx9fzAxW6E9mR4OgwfiGnOAxQ=;
        b=SMDyRZ1VZULHbeZZMZgxePAPzQGO5JHbstx2UPIm5rV04BdBQZIMZoH+hpIG2YMEkJ
         y3c4+EHxmUnYyVi3bcaEu+8effRUOZP1Rfv7wLKe71CY0l1aEFGNd5LuOgw/WWK5yWk3
         1rxiyDUctkUJfXJQ7mujXxSYMRgk+uPwUtmGjoMWVlFp5b5ClLMmpw5Y3Lk8Tg42t4Sj
         82K8v52G1u8qkVspPEoqpppyeu/xfAy35QHwRaP60ZkyiWtca4Cne41pmnCN1xDccGcr
         abIxTrGaHd5JXjzBgCdUV1RwXyAnrXIEKLZwFy/ocyB7kx7EufWOvjf0FrMwSrcHhvrb
         K3iw==
X-Gm-Message-State: AC+VfDxpXwQQTK2No6HdOXO/exkgt0RZXyv3QaenVuk1irKiW+fgVqWa
	QSfifHnseE5qBgtiK6hn7v3Vu8BPxVMA5+8sLSn9EHw8ob62JLoF7WM/4S/VMkB9snGf+tWCD2q
	ipu/BnN688Olm2L438Y9JKrxDItpxZfay1w==
X-Received: by 2002:a54:4808:0:b0:39b:7ba7:bd1e with SMTP id j8-20020a544808000000b0039b7ba7bd1emr6763073oij.11.1686659567822;
        Tue, 13 Jun 2023 05:32:47 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6OQeh1b10s7ZGLTmJ0pP4jyvk53jHubefHpSrwjFFh9fL4c+WcRZ7ueDOIk1giyyKHQPXWpQ==
X-Received: by 2002:a54:4808:0:b0:39b:7ba7:bd1e with SMTP id j8-20020a544808000000b0039b7ba7bd1emr6763057oij.11.1686659567593;
        Tue, 13 Jun 2023 05:32:47 -0700 (PDT)
Received: from magali.. ([2804:14c:bbe3:4606:ac1a:e505:990c:70e9])
        by smtp.gmail.com with ESMTPSA id z26-20020a056808049a00b0039c532c9ae1sm4838116oid.55.2023.06.13.05.32.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 05:32:47 -0700 (PDT)
From: Magali Lemes <magali.lemes@canonical.com>
To: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	shuah@kernel.org,
	dsahern@gmail.com
Cc: andrei.gherzan@canonical.com,
	netdev@vger.kernel.org,
	David Ahern <dsahern@kernel.org>,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 4/4] selftests: net: fcnal-test: check if FIPS mode is enabled
Date: Tue, 13 Jun 2023 09:32:22 -0300
Message-Id: <20230613123222.631897-5-magali.lemes@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230613123222.631897-1-magali.lemes@canonical.com>
References: <20230613123222.631897-1-magali.lemes@canonical.com>
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
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

There are some MD5 tests which fail when the kernel is in FIPS mode,
since MD5 is not FIPS compliant. Add a check and only run those tests
if FIPS mode is not enabled.

Fixes: f0bee1ebb5594 ("fcnal-test: Add TCP MD5 tests")
Fixes: 5cad8bce26e01 ("fcnal-test: Add TCP MD5 tests for VRF")
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Magali Lemes <magali.lemes@canonical.com>
---
No change in v4.
No change in v3.
 
Changes in v2:
 - Add R-b tag.

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


