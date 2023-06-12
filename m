Return-Path: <netdev+bounces-10116-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65AEB72C50D
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 14:52:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AEC921C20B46
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 12:52:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF16718C1B;
	Mon, 12 Jun 2023 12:51:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA04168B4
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 12:51:43 +0000 (UTC)
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 567E3171E
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 05:51:34 -0700 (PDT)
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 2D1643F376
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 12:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1686574293;
	bh=omMsUqmf+wDARTSBLeWKvRxM4zligfqqpbMttBMt0pg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version;
	b=UA/fdTTAIioDD+O770I8naogOwvF/EA0aLYblU1j+xnd6Z1Tj5UqYXMsJ/eShk1/X
	 D13BJQ4A8RMETmWj0NJYefoaCrhikX5Ygov0W1zmEidfrS9q8BjabQEe/6LR6WZNza
	 Ob36v2TOKP8ov88b1BxBbcCodNuGGOT07eIyBByBtpkX+DwaIKJCGmiEUkqUMft1r/
	 u+ylTox6X7SrBCyZOqgL3hwvIaMFRZ7MLkZD8mjfzSRBLSpKgi67HEpf67QFK9+WXW
	 u7hreeTeFeHdqGHLR/3ZBb76RYD+jQ1QLX9LPcfu5bHqkmBnTIgHgs9iRpSUe5qgEe
	 R84EcMbX9VLVw==
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-558df3fa320so2940306eaf.2
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 05:51:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686574292; x=1689166292;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=omMsUqmf+wDARTSBLeWKvRxM4zligfqqpbMttBMt0pg=;
        b=St8ldt6j2lfGLNTb9QYHP/MWrP0hKMakEy5VaV+4RKFFr9ycRAOST3vUOVqgSBG1Ks
         oMJ08D9PjtDILY3u4IsuM1/m/21kJYXoqTTLSSW9gRSZbXhUozg1u3EqcuSa0TCiWNFk
         un/IR5hDv8pNG8un0GTUCyOc8lMJhKlWg5wHgmGRMMwLCp1ouSWaE2wksptM51l9EZHL
         lgAIjUAwdnzSAyq93CjNFQSnIam19i51RFDwxL1k3wqVm4H+Q0v9kBoEtiP+czqsWHDq
         v7UBT73oK0OBnjii19MezDrD6Z+uQNBzIsx1D2M61eFNJs6L9H7KiN7PLgh43mKji+mq
         ZyFQ==
X-Gm-Message-State: AC+VfDwLoymTVrkBOKBeHg9ln93BR69r2jRKLIBTT7Mk8pYee6dPcdp1
	D4k2HxDlICsENolU35M+8Mv4zOw8x1W1mvE3gz8u83UeihbbtaYBOLoS9LphRlZ5bLatIsEnpro
	arfjphNu0bKb0av6j92O2QK6mVakpIiAImA==
X-Received: by 2002:a4a:dccc:0:b0:54b:ce85:490a with SMTP id h12-20020a4adccc000000b0054bce85490amr4906214oou.0.1686574292103;
        Mon, 12 Jun 2023 05:51:32 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7zLTOWJnv96ffTmwdgO+vzkEG8P4Mwm7wW1mYTKkUTXLGwXHNy9GMezl/BTJdLH++Nny4/Vg==
X-Received: by 2002:a4a:dccc:0:b0:54b:ce85:490a with SMTP id h12-20020a4adccc000000b0054bce85490amr4906211oou.0.1686574291870;
        Mon, 12 Jun 2023 05:51:31 -0700 (PDT)
Received: from magali.. ([2804:14c:bbe3:4606:d612:b95d:6bdc:8f6d])
        by smtp.gmail.com with ESMTPSA id j22-20020a4ad196000000b00529cc3986c8sm3157193oor.40.2023.06.12.05.51.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 05:51:31 -0700 (PDT)
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
Subject: [PATCH v3 4/4] selftests: net: fcnal-test: check if FIPS mode is enabled
Date: Mon, 12 Jun 2023 09:51:07 -0300
Message-Id: <20230612125107.73795-5-magali.lemes@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230612125107.73795-1-magali.lemes@canonical.com>
References: <20230612125107.73795-1-magali.lemes@canonical.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
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


