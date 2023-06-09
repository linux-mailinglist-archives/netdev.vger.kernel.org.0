Return-Path: <netdev+bounces-9623-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9F2C72A071
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 18:44:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 957022819DF
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 16:44:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 677CC19E6D;
	Fri,  9 Jun 2023 16:43:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B75117AC2
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 16:43:53 +0000 (UTC)
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC3A62D71
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 09:43:49 -0700 (PDT)
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 49B0C3F513
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 16:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1686329028;
	bh=bcQsjAMHkUSKApX68ZuYeihjuMej/C2tdQeqg1IYyqk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version;
	b=WN7X8Otwe4suha9jy/rgf1uUshqQZzimPp31tySHzLM0fD377AT5qHRhLEIn/4cgn
	 P+FN61YaLUxSLLPg4g9Beosc2ymCC2IwYGwcFzQ3QjHQqwZWRCrhuYe8I2cZ84s1py
	 YSB+OAnrb08f8Yledo2JA1frDfoR2A3Xs3N8EaEzIcpYuKra7Ub8q0S571tX6xmMLZ
	 3LtfLTwvVK0X1Jv7xzc0rYxs+LDz2UeudnsBJqYbRtYo3DMuX/kASFptQmy4YA23Rb
	 cbaFzoj4lmikHBYJa2k68AwYqb9ayrViOueL/MqvI7fVJhx6Mz1wagEYcMifT+8RLu
	 FMADzMlWPAotw==
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-55b03c5f56bso1642446eaf.1
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 09:43:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686329026; x=1688921026;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bcQsjAMHkUSKApX68ZuYeihjuMej/C2tdQeqg1IYyqk=;
        b=V0JlGxwlE393yXhKmZeKufHhBI6p+hF6uiPATPHrRzdIbPdmikzQ+uILXW2vF04Jsn
         EIwsz13ixeVeHjd7mBncdllnMyWoNbMbnAr1fbTOFAIKwymeotbaFMz2dLlIqpKhYDZ9
         65xaR1/irq5lBFgYGaDU7EP6uFhuOZkfHLhpDixFCWo8d3vgFrtiMjWosFo6YDLi826V
         p3R4sAGhWrWH4MTSkbJrWgKSQjHdl96HK1mBW/l7TBhYcXARAx3mPvoUrWRj1R5JNEMh
         LI0ngjhrvSrBK0whXMTdPeDomEVm3qX+AQGX6MpUcDNDYnK2D8eE+ncuN3JMw3AVqlHk
         gO0A==
X-Gm-Message-State: AC+VfDxcv4uqfUWY7fMpVHZ4LBK5olE8rbhiYj5FKtbtZP+QF26cnU1f
	NZRCDNteVkYd2hzhIyGLoECKnETIoeHgvzyHo4wM7faUVVk1W4JeetG3AJUM4ldBOU01z56IuXw
	fIi3k16nxfAu1P15xbdovJbKDxw7gn32hOg==
X-Received: by 2002:a05:6870:d8a5:b0:1a3:5bb2:8e98 with SMTP id dv37-20020a056870d8a500b001a35bb28e98mr1489060oab.47.1686329025952;
        Fri, 09 Jun 2023 09:43:45 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4UB4ZzJdwHORXrTeXhKVpTBySccm2pIJnH4b0ycLeDnxw0Yx/fCbGcBs3FEC93LCefV2pmrg==
X-Received: by 2002:a05:6870:d8a5:b0:1a3:5bb2:8e98 with SMTP id dv37-20020a056870d8a500b001a35bb28e98mr1489044oab.47.1686329025687;
        Fri, 09 Jun 2023 09:43:45 -0700 (PDT)
Received: from magali.. ([2804:14c:bbe3:4606:db64:8f3b:3c73:e436])
        by smtp.gmail.com with ESMTPSA id g17-20020a056870c39100b001726cfeea97sm2360707oao.29.2023.06.09.09.43.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 09:43:45 -0700 (PDT)
From: Magali Lemes <magali.lemes@canonical.com>
To: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	shuah@kernel.org,
	dsahern@gmail.com
Cc: andrei.gherzan@canonical.com,
	David Ahern <dsahern@kernel.org>,
	netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net v2 3/3] selftests: net: fcnal-test: check if FIPS mode is enabled
Date: Fri,  9 Jun 2023 13:43:24 -0300
Message-Id: <20230609164324.497813-4-magali.lemes@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230609164324.497813-1-magali.lemes@canonical.com>
References: <20230609164324.497813-1-magali.lemes@canonical.com>
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


