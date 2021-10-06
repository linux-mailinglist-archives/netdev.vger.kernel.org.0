Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4B8423D43
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 13:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238509AbhJFLuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 07:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238586AbhJFLuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 07:50:02 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD20C06176C;
        Wed,  6 Oct 2021 04:48:03 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id f4so3430946edr.8;
        Wed, 06 Oct 2021 04:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x/buBl4AuOHTTf2T2EtYPGmei4Zsgh/gX2u7OvPsDeQ=;
        b=QWp5NIXjPg70ai7Pwvbkba40OOmeeCA5+bDct2+UxMElXql1PMufvNuaJc/N5u/Kps
         2cFLw2SjWwWsSr7o+RRzqG/yzKFId1jFqoe+aE4mwhTLCdNU98Zm3ea+bXZ3u2fQmLIZ
         h2kHuOtYNxH74BeYXe0jObCQ8RIWZd6o4BkFGYLubGlanaUvm5/ikIiV5oGwrFn/58cI
         B87HzVhnlhyKD/sF1i904+xWhFxElI7SIPZXT4JJZL3Gcprluvaauu5DzuFLVCeDbjOf
         IklZ0g0F/u/bf4ispGoNxIvHLJTMuzNmeT/FhKDidgsDcznehk4PHwZmzYrygWAxMGa/
         3IWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x/buBl4AuOHTTf2T2EtYPGmei4Zsgh/gX2u7OvPsDeQ=;
        b=OYuJ8FhY4W7V/GuJN8D7b64YGklOQACXhwTszFxIDSqx5Hm1CLcnCJ4a5yjcuv0bqe
         jMbgqqbbdHSrjodTsXnxmRFiaV/0o8BtsWJh1/SX30nfa5As18wc3alWoEqLVwPZdPL/
         /EVmSBKAnWv9m2BqtHl8GrhC7RfJ5z3kAs+PJWyBzZFNPQ9iFLc4nwJisUJZYJlq2bOL
         5Lk+45T02jZ8aqUMRzwSvTlXEu9sl18L5jjTbb9CShcgItvAMjf2U9KRQrzaWafbU5RE
         FQ23gmiXWG8qQUqf+uEP/m563X3SfHRxi3KGhrvxUbVaY2d057LjmrhelPV8bGpkCb4j
         TJ/A==
X-Gm-Message-State: AOAM532aswMSlPvvTcGDsek0A2hN/fGNDtPfhs1T1W+REBLSCUWoppIA
        U3ZiS9AI0ArpUXRZxtx35MQ=
X-Google-Smtp-Source: ABdhPJwFEBJ9PfUW9LCZW+MRTgVRObBZhLpB+kZCFZlpl/scUGJ9LpyhJU++kKKtXHCRCyYV0T40Xw==
X-Received: by 2002:a05:6402:4305:: with SMTP id m5mr30754060edc.277.1633520881655;
        Wed, 06 Oct 2021 04:48:01 -0700 (PDT)
Received: from localhost.localdomain ([95.76.3.69])
        by smtp.gmail.com with ESMTPSA id y40sm1402187ede.31.2021.10.06.04.48.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 04:48:01 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>, Shuah Khan <shuah@kernel.org>,
        David Ahern <dsahern@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>,
        Seth David Schoen <schoen@loyalty.org>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/11] selftests: net/fcnal: Replace sleep after server start with -k
Date:   Wed,  6 Oct 2021 14:47:24 +0300
Message-Id: <ec40bd7128a30e93b90ba888f3468f394617a010.1633520807.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1633520807.git.cdleonard@gmail.com>
References: <cover.1633520807.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The -k switch makes the server fork into the background after the listen
call is succesful, this can be used to replace most of the `sleep 1`
statements in this script.

Change performed with a vim command:

s/nettest \(.*-s.*\) &\n\s*sleep 1\n/nettest \1 -k\r

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 tools/testing/selftests/net/fcnal-test.sh | 641 ++++++++--------------
 1 file changed, 219 insertions(+), 422 deletions(-)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 09cb35e16219..e73aeb3884c5 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -804,63 +804,56 @@ ipv4_tcp_md5_novrf()
 	# single address
 	#
 
 	# basic use case
 	log_start
-	run_cmd nettest -s -M ${MD5_PW} -m ${NSB_IP} &
-	sleep 1
+	run_cmd nettest -s -M ${MD5_PW} -m ${NSB_IP} -k
 	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_PW}
 	log_test $? 0 "MD5: Single address config"
 
 	# client sends MD5, server not configured
 	log_start
 	show_hint "Should timeout due to MD5 mismatch"
-	run_cmd nettest -s &
-	sleep 1
+	run_cmd nettest -s -k
 	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_PW}
 	log_test $? 2 "MD5: Server no config, client uses password"
 
 	# wrong password
 	log_start
 	show_hint "Should timeout since client uses wrong password"
-	run_cmd nettest -s -M ${MD5_PW} -m ${NSB_IP} &
-	sleep 1
+	run_cmd nettest -s -M ${MD5_PW} -m ${NSB_IP} -k
 	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_WRONG_PW}
 	log_test $? 2 "MD5: Client uses wrong password"
 
 	# client from different address
 	log_start
 	show_hint "Should timeout due to MD5 mismatch"
-	run_cmd nettest -s -M ${MD5_PW} -m ${NSB_LO_IP} &
-	sleep 1
+	run_cmd nettest -s -M ${MD5_PW} -m ${NSB_LO_IP} -k
 	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_PW}
 	log_test $? 2 "MD5: Client address does not match address configured with password"
 
 	#
 	# MD5 extension - prefix length
 	#
 
 	# client in prefix
 	log_start
-	run_cmd nettest -s -M ${MD5_PW} -m ${NS_NET} &
-	sleep 1
+	run_cmd nettest -s -M ${MD5_PW} -m ${NS_NET} -k
 	run_cmd_nsb nettest  -r ${NSA_IP} -X ${MD5_PW}
 	log_test $? 0 "MD5: Prefix config"
 
 	# client in prefix, wrong password
 	log_start
 	show_hint "Should timeout since client uses wrong password"
-	run_cmd nettest -s -M ${MD5_PW} -m ${NS_NET} &
-	sleep 1
+	run_cmd nettest -s -M ${MD5_PW} -m ${NS_NET} -k
 	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_WRONG_PW}
 	log_test $? 2 "MD5: Prefix config, client uses wrong password"
 
 	# client outside of prefix
 	log_start
 	show_hint "Should timeout due to MD5 mismatch"
-	run_cmd nettest -s -M ${MD5_PW} -m ${NS_NET} &
-	sleep 1
+	run_cmd nettest -s -M ${MD5_PW} -m ${NS_NET} -k
 	run_cmd_nsb nettest -c ${NSB_LO_IP} -r ${NSA_IP} -X ${MD5_PW}
 	log_test $? 2 "MD5: Prefix config, client address not in configured prefix"
 }
 
 #
@@ -872,127 +865,112 @@ ipv4_tcp_md5()
 	# single address
 	#
 
 	# basic use case
 	log_start
-	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NSB_IP} &
-	sleep 1
+	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NSB_IP} -k
 	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_PW}
 	log_test $? 0 "MD5: VRF: Single address config"
 
 	# client sends MD5, server not configured
 	log_start
 	show_hint "Should timeout since server does not have MD5 auth"
-	run_cmd nettest -s -I ${VRF} &
-	sleep 1
+	run_cmd nettest -s -I ${VRF} -k
 	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_PW}
 	log_test $? 2 "MD5: VRF: Server no config, client uses password"
 
 	# wrong password
 	log_start
 	show_hint "Should timeout since client uses wrong password"
-	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NSB_IP} &
-	sleep 1
+	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NSB_IP} -k
 	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_WRONG_PW}
 	log_test $? 2 "MD5: VRF: Client uses wrong password"
 
 	# client from different address
 	log_start
 	show_hint "Should timeout since server config differs from client"
-	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NSB_LO_IP} &
-	sleep 1
+	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NSB_LO_IP} -k
 	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_PW}
 	log_test $? 2 "MD5: VRF: Client address does not match address configured with password"
 
 	#
 	# MD5 extension - prefix length
 	#
 
 	# client in prefix
 	log_start
-	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET} &
-	sleep 1
+	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET} -k
 	run_cmd_nsb nettest  -r ${NSA_IP} -X ${MD5_PW}
 	log_test $? 0 "MD5: VRF: Prefix config"
 
 	# client in prefix, wrong password
 	log_start
 	show_hint "Should timeout since client uses wrong password"
-	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET} &
-	sleep 1
+	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET} -k
 	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_WRONG_PW}
 	log_test $? 2 "MD5: VRF: Prefix config, client uses wrong password"
 
 	# client outside of prefix
 	log_start
 	show_hint "Should timeout since client address is outside of prefix"
-	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET} &
-	sleep 1
+	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET} -k
 	run_cmd_nsb nettest -c ${NSB_LO_IP} -r ${NSA_IP} -X ${MD5_PW}
 	log_test $? 2 "MD5: VRF: Prefix config, client address not in configured prefix"
 
 	#
 	# duplicate config between default VRF and a VRF
 	#
 
 	log_start
-	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NSB_IP} &
-	run_cmd nettest -s -M ${MD5_WRONG_PW} -m ${NSB_IP} &
-	sleep 1
+	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NSB_IP} -k
+	run_cmd nettest -s -M ${MD5_WRONG_PW} -m ${NSB_IP} -k
 	run_cmd_nsb nettest  -r ${NSA_IP} -X ${MD5_PW}
 	log_test $? 0 "MD5: VRF: Single address config in default VRF and VRF, conn in VRF"
 
 	log_start
-	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NSB_IP} &
-	run_cmd nettest -s -M ${MD5_WRONG_PW} -m ${NSB_IP} &
-	sleep 1
+	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NSB_IP} -k
+	run_cmd nettest -s -M ${MD5_WRONG_PW} -m ${NSB_IP} -k
 	run_cmd_nsc nettest  -r ${NSA_IP} -X ${MD5_WRONG_PW}
 	log_test $? 0 "MD5: VRF: Single address config in default VRF and VRF, conn in default VRF"
 
 	log_start
 	show_hint "Should timeout since client in default VRF uses VRF password"
-	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NSB_IP} &
-	run_cmd nettest -s -M ${MD5_WRONG_PW} -m ${NSB_IP} &
-	sleep 1
+	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NSB_IP} -k
+	run_cmd nettest -s -M ${MD5_WRONG_PW} -m ${NSB_IP} -k
 	run_cmd_nsc nettest -r ${NSA_IP} -X ${MD5_PW}
 	log_test $? 2 "MD5: VRF: Single address config in default VRF and VRF, conn in default VRF with VRF pw"
 
 	log_start
 	show_hint "Should timeout since client in VRF uses default VRF password"
-	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NSB_IP} &
-	run_cmd nettest -s -M ${MD5_WRONG_PW} -m ${NSB_IP} &
-	sleep 1
+	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NSB_IP} -k
+	run_cmd nettest -s -M ${MD5_WRONG_PW} -m ${NSB_IP} -k
 	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_WRONG_PW}
 	log_test $? 2 "MD5: VRF: Single address config in default VRF and VRF, conn in VRF with default VRF pw"
 
 	log_start
-	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET} &
-	run_cmd nettest -s -M ${MD5_WRONG_PW} -m ${NS_NET} &
-	sleep 1
+	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET} -k
+	run_cmd nettest -s -M ${MD5_WRONG_PW} -m ${NS_NET} -k
 	run_cmd_nsb nettest  -r ${NSA_IP} -X ${MD5_PW}
 	log_test $? 0 "MD5: VRF: Prefix config in default VRF and VRF, conn in VRF"
 
 	log_start
-	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET} &
-	run_cmd nettest -s -M ${MD5_WRONG_PW} -m ${NS_NET} &
-	sleep 1
+	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET} -k
+	run_cmd nettest -s -M ${MD5_WRONG_PW} -m ${NS_NET} -k
 	run_cmd_nsc nettest  -r ${NSA_IP} -X ${MD5_WRONG_PW}
 	log_test $? 0 "MD5: VRF: Prefix config in default VRF and VRF, conn in default VRF"
 
 	log_start
 	show_hint "Should timeout since client in default VRF uses VRF password"
-	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET} &
-	run_cmd nettest -s -M ${MD5_WRONG_PW} -m ${NS_NET} &
-	sleep 1
+	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET} -k
+	run_cmd nettest -s -M ${MD5_WRONG_PW} -m ${NS_NET} -k
 	run_cmd_nsc nettest -r ${NSA_IP} -X ${MD5_PW}
 	log_test $? 2 "MD5: VRF: Prefix config in default VRF and VRF, conn in default VRF with VRF pw"
 
 	log_start
 	show_hint "Should timeout since client in VRF uses default VRF password"
-	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET} &
-	run_cmd nettest -s -M ${MD5_WRONG_PW} -m ${NS_NET} &
-	sleep 1
+	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET} -k
+	run_cmd nettest -s -M ${MD5_WRONG_PW} -m ${NS_NET} -k
 	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_WRONG_PW}
 	log_test $? 2 "MD5: VRF: Prefix config in default VRF and VRF, conn in VRF with default VRF pw"
 
 	#
 	# negative tests
@@ -1015,20 +993,18 @@ ipv4_tcp_novrf()
 	# server tests
 	#
 	for a in ${NSA_IP} ${NSA_LO_IP}
 	do
 		log_start
-		run_cmd nettest -s &
-		sleep 1
+		run_cmd nettest -s -k
 		run_cmd_nsb nettest -r ${a}
 		log_test_addr ${a} $? 0 "Global server"
 	done
 
 	a=${NSA_IP}
 	log_start
-	run_cmd nettest -s -I ${NSA_DEV} &
-	sleep 1
+	run_cmd nettest -s -I ${NSA_DEV} -k
 	run_cmd_nsb nettest -r ${a}
 	log_test_addr ${a} $? 0 "Device server"
 
 	# verify TCP reset sent and received
 	for a in ${NSA_IP} ${NSA_LO_IP}
@@ -1043,18 +1019,16 @@ ipv4_tcp_novrf()
 	# client
 	#
 	for a in ${NSB_IP} ${NSB_LO_IP}
 	do
 		log_start
-		run_cmd_nsb nettest -s &
-		sleep 1
+		run_cmd_nsb nettest -s -k
 		run_cmd nettest -r ${a} -0 ${NSA_IP}
 		log_test_addr ${a} $? 0 "Client"
 
 		log_start
-		run_cmd_nsb nettest -s &
-		sleep 1
+		run_cmd_nsb nettest -s -k
 		run_cmd nettest -r ${a} -d ${NSA_DEV}
 		log_test_addr ${a} $? 0 "Client, device bind"
 
 		log_start
 		show_hint "Should fail 'Connection refused'"
@@ -1071,54 +1045,48 @@ ipv4_tcp_novrf()
 	# local address tests
 	#
 	for a in ${NSA_IP} ${NSA_LO_IP} 127.0.0.1
 	do
 		log_start
-		run_cmd nettest -s &
-		sleep 1
+		run_cmd nettest -s -k
 		run_cmd nettest -r ${a} -0 ${a} -1 ${a}
 		log_test_addr ${a} $? 0 "Global server, local connection"
 	done
 
 	a=${NSA_IP}
 	log_start
-	run_cmd nettest -s -I ${NSA_DEV} &
-	sleep 1
+	run_cmd nettest -s -I ${NSA_DEV} -k
 	run_cmd nettest -r ${a} -0 ${a}
 	log_test_addr ${a} $? 0 "Device server, unbound client, local connection"
 
 	for a in ${NSA_LO_IP} 127.0.0.1
 	do
 		log_start
 		show_hint "Should fail 'Connection refused' since addresses on loopback are out of device scope"
-		run_cmd nettest -s -I ${NSA_DEV} &
-		sleep 1
+		run_cmd nettest -s -I ${NSA_DEV} -k
 		run_cmd nettest -r ${a}
 		log_test_addr ${a} $? 1 "Device server, unbound client, local connection"
 	done
 
 	a=${NSA_IP}
 	log_start
-	run_cmd nettest -s &
-	sleep 1
+	run_cmd nettest -s -k
 	run_cmd nettest -r ${a} -0 ${a} -d ${NSA_DEV}
 	log_test_addr ${a} $? 0 "Global server, device client, local connection"
 
 	for a in ${NSA_LO_IP} 127.0.0.1
 	do
 		log_start
 		show_hint "Should fail 'No route to host' since addresses on loopback are out of device scope"
-		run_cmd nettest -s &
-		sleep 1
+		run_cmd nettest -s -k
 		run_cmd nettest -r ${a} -d ${NSA_DEV}
 		log_test_addr ${a} $? 1 "Global server, device client, local connection"
 	done
 
 	a=${NSA_IP}
 	log_start
-	run_cmd nettest -s -I ${NSA_DEV} -3 ${NSA_DEV} &
-	sleep 1
+	run_cmd nettest -s -I ${NSA_DEV} -3 ${NSA_DEV} -k
 	run_cmd nettest  -d ${NSA_DEV} -r ${a} -0 ${a}
 	log_test_addr ${a} $? 0 "Device server, device client, local connection"
 
 	log_start
 	show_hint "Should fail 'Connection refused'"
@@ -1142,24 +1110,21 @@ ipv4_tcp_vrf()
 	#
 	for a in ${NSA_IP} ${VRF_IP}
 	do
 		log_start
 		show_hint "Should fail 'Connection refused' since global server with VRF is disabled"
-		run_cmd nettest -s &
-		sleep 1
+		run_cmd nettest -s -k
 		run_cmd_nsb nettest -r ${a}
 		log_test_addr ${a} $? 1 "Global server"
 
 		log_start
-		run_cmd nettest -s -I ${VRF} -3 ${VRF} &
-		sleep 1
+		run_cmd nettest -s -I ${VRF} -3 ${VRF} -k
 		run_cmd_nsb nettest -r ${a}
 		log_test_addr ${a} $? 0 "VRF server"
 
 		log_start
-		run_cmd nettest -s -I ${NSA_DEV} -3 ${NSA_DEV} &
-		sleep 1
+		run_cmd nettest -s -I ${NSA_DEV} -3 ${NSA_DEV} -k
 		run_cmd_nsb nettest -r ${a}
 		log_test_addr ${a} $? 0 "Device server"
 
 		# verify TCP reset received
 		log_start
@@ -1171,12 +1136,11 @@ ipv4_tcp_vrf()
 	# local address tests
 	# (${VRF_IP} and 127.0.0.1 both timeout)
 	a=${NSA_IP}
 	log_start
 	show_hint "Should fail 'Connection refused' since global server with VRF is disabled"
-	run_cmd nettest -s &
-	sleep 1
+	run_cmd nettest -s -k
 	run_cmd nettest -r ${a} -d ${NSA_DEV}
 	log_test_addr ${a} $? 1 "Global server, local connection"
 
 	# run MD5 tests
 	ipv4_tcp_md5
@@ -1189,19 +1153,17 @@ ipv4_tcp_vrf()
 
 	for a in ${NSA_IP} ${VRF_IP}
 	do
 		log_start
 		show_hint "client socket should be bound to VRF"
-		run_cmd nettest -s -3 ${VRF} &
-		sleep 1
+		run_cmd nettest -s -3 ${VRF} -k
 		run_cmd_nsb nettest -r ${a}
 		log_test_addr ${a} $? 0 "Global server"
 
 		log_start
 		show_hint "client socket should be bound to VRF"
-		run_cmd nettest -s -I ${VRF} -3 ${VRF} &
-		sleep 1
+		run_cmd nettest -s -I ${VRF} -3 ${VRF} -k
 		run_cmd_nsb nettest -r ${a}
 		log_test_addr ${a} $? 0 "VRF server"
 
 		# verify TCP reset received
 		log_start
@@ -1211,40 +1173,36 @@ ipv4_tcp_vrf()
 	done
 
 	a=${NSA_IP}
 	log_start
 	show_hint "client socket should be bound to device"
-	run_cmd nettest -s -I ${NSA_DEV} -3 ${NSA_DEV} &
-	sleep 1
+	run_cmd nettest -s -I ${NSA_DEV} -3 ${NSA_DEV} -k
 	run_cmd_nsb nettest -r ${a}
 	log_test_addr ${a} $? 0 "Device server"
 
 	# local address tests
 	for a in ${NSA_IP} ${VRF_IP}
 	do
 		log_start
 		show_hint "Should fail 'Connection refused' since client is not bound to VRF"
-		run_cmd nettest -s -I ${VRF} &
-		sleep 1
+		run_cmd nettest -s -I ${VRF} -k
 		run_cmd nettest -r ${a}
 		log_test_addr ${a} $? 1 "Global server, local connection"
 	done
 
 	#
 	# client
 	#
 	for a in ${NSB_IP} ${NSB_LO_IP}
 	do
 		log_start
-		run_cmd_nsb nettest -s &
-		sleep 1
+		run_cmd_nsb nettest -s -k
 		run_cmd nettest -r ${a} -d ${VRF}
 		log_test_addr ${a} $? 0 "Client, VRF bind"
 
 		log_start
-		run_cmd_nsb nettest -s &
-		sleep 1
+		run_cmd_nsb nettest -s -k
 		run_cmd nettest -r ${a} -d ${NSA_DEV}
 		log_test_addr ${a} $? 0 "Client, device bind"
 
 		log_start
 		show_hint "Should fail 'Connection refused'"
@@ -1258,39 +1216,34 @@ ipv4_tcp_vrf()
 	done
 
 	for a in ${NSA_IP} ${VRF_IP} 127.0.0.1
 	do
 		log_start
-		run_cmd nettest -s -I ${VRF} -3 ${VRF} &
-		sleep 1
+		run_cmd nettest -s -I ${VRF} -3 ${VRF} -k
 		run_cmd nettest -r ${a} -d ${VRF} -0 ${a}
 		log_test_addr ${a} $? 0 "VRF server, VRF client, local connection"
 	done
 
 	a=${NSA_IP}
 	log_start
-	run_cmd nettest -s -I ${VRF} -3 ${VRF} &
-	sleep 1
+	run_cmd nettest -s -I ${VRF} -3 ${VRF} -k
 	run_cmd nettest -r ${a} -d ${NSA_DEV} -0 ${a}
 	log_test_addr ${a} $? 0 "VRF server, device client, local connection"
 
 	log_start
 	show_hint "Should fail 'No route to host' since client is out of VRF scope"
-	run_cmd nettest -s -I ${VRF} &
-	sleep 1
+	run_cmd nettest -s -I ${VRF} -k
 	run_cmd nettest -r ${a}
 	log_test_addr ${a} $? 1 "VRF server, unbound client, local connection"
 
 	log_start
-	run_cmd nettest -s -I ${NSA_DEV} -3 ${NSA_DEV} &
-	sleep 1
+	run_cmd nettest -s -I ${NSA_DEV} -3 ${NSA_DEV} -k
 	run_cmd nettest -r ${a} -d ${VRF} -0 ${a}
 	log_test_addr ${a} $? 0 "Device server, VRF client, local connection"
 
 	log_start
-	run_cmd nettest -s -I ${NSA_DEV} -3 ${NSA_DEV} &
-	sleep 1
+	run_cmd nettest -s -I ${NSA_DEV} -3 ${NSA_DEV} -k
 	run_cmd nettest -r ${a} -d ${NSA_DEV} -0 ${a}
 	log_test_addr ${a} $? 0 "Device server, device client, local connection"
 }
 
 ipv4_tcp()
@@ -1324,12 +1277,11 @@ ipv4_udp_novrf()
 	# server tests
 	#
 	for a in ${NSA_IP} ${NSA_LO_IP}
 	do
 		log_start
-		run_cmd nettest -D -s -3 ${NSA_DEV} &
-		sleep 1
+		run_cmd nettest -D -s -3 ${NSA_DEV} -k
 		run_cmd_nsb nettest -D -r ${a}
 		log_test_addr ${a} $? 0 "Global server"
 
 		log_start
 		show_hint "Should fail 'Connection refused' since there is no server"
@@ -1337,41 +1289,36 @@ ipv4_udp_novrf()
 		log_test_addr ${a} $? 1 "No server"
 	done
 
 	a=${NSA_IP}
 	log_start
-	run_cmd nettest -D -I ${NSA_DEV} -s -3 ${NSA_DEV} &
-	sleep 1
+	run_cmd nettest -D -I ${NSA_DEV} -s -3 ${NSA_DEV} -k
 	run_cmd_nsb nettest -D -r ${a}
 	log_test_addr ${a} $? 0 "Device server"
 
 	#
 	# client
 	#
 	for a in ${NSB_IP} ${NSB_LO_IP}
 	do
 		log_start
-		run_cmd_nsb nettest -D -s &
-		sleep 1
+		run_cmd_nsb nettest -D -s -k
 		run_cmd nettest -D -r ${a} -0 ${NSA_IP}
 		log_test_addr ${a} $? 0 "Client"
 
 		log_start
-		run_cmd_nsb nettest -D -s &
-		sleep 1
+		run_cmd_nsb nettest -D -s -k
 		run_cmd nettest -D -r ${a} -d ${NSA_DEV} -0 ${NSA_IP}
 		log_test_addr ${a} $? 0 "Client, device bind"
 
 		log_start
-		run_cmd_nsb nettest -D -s &
-		sleep 1
+		run_cmd_nsb nettest -D -s -k
 		run_cmd nettest -D -r ${a} -d ${NSA_DEV} -C -0 ${NSA_IP}
 		log_test_addr ${a} $? 0 "Client, device send via cmsg"
 
 		log_start
-		run_cmd_nsb nettest -D -s &
-		sleep 1
+		run_cmd_nsb nettest -D -s -k
 		run_cmd nettest -D -r ${a} -d ${NSA_DEV} -S -0 ${NSA_IP}
 		log_test_addr ${a} $? 0 "Client, device bind via IP_UNICAST_IF"
 
 		log_start
 		show_hint "Should fail 'Connection refused'"
@@ -1388,83 +1335,73 @@ ipv4_udp_novrf()
 	# local address tests
 	#
 	for a in ${NSA_IP} ${NSA_LO_IP} 127.0.0.1
 	do
 		log_start
-		run_cmd nettest -D -s &
-		sleep 1
+		run_cmd nettest -D -s -k
 		run_cmd nettest -D -r ${a} -0 ${a} -1 ${a}
 		log_test_addr ${a} $? 0 "Global server, local connection"
 	done
 
 	a=${NSA_IP}
 	log_start
-	run_cmd nettest -s -D -I ${NSA_DEV} -3 ${NSA_DEV} &
-	sleep 1
+	run_cmd nettest -s -D -I ${NSA_DEV} -3 ${NSA_DEV} -k
 	run_cmd nettest -D -r ${a}
 	log_test_addr ${a} $? 0 "Device server, unbound client, local connection"
 
 	for a in ${NSA_LO_IP} 127.0.0.1
 	do
 		log_start
 		show_hint "Should fail 'Connection refused' since address is out of device scope"
-		run_cmd nettest -s -D -I ${NSA_DEV} &
-		sleep 1
+		run_cmd nettest -s -D -I ${NSA_DEV} -k
 		run_cmd nettest -D -r ${a}
 		log_test_addr ${a} $? 1 "Device server, unbound client, local connection"
 	done
 
 	a=${NSA_IP}
 	log_start
-	run_cmd nettest -s -D &
-	sleep 1
+	run_cmd nettest -s -D -k
 	run_cmd nettest -D -d ${NSA_DEV} -r ${a}
 	log_test_addr ${a} $? 0 "Global server, device client, local connection"
 
 	log_start
-	run_cmd nettest -s -D &
-	sleep 1
+	run_cmd nettest -s -D -k
 	run_cmd nettest -D -d ${NSA_DEV} -C -r ${a}
 	log_test_addr ${a} $? 0 "Global server, device send via cmsg, local connection"
 
 	log_start
-	run_cmd nettest -s -D &
-	sleep 1
+	run_cmd nettest -s -D -k
 	run_cmd nettest -D -d ${NSA_DEV} -S -r ${a}
 	log_test_addr ${a} $? 0 "Global server, device client via IP_UNICAST_IF, local connection"
 
 	# IPv4 with device bind has really weird behavior - it overrides the
 	# fib lookup, generates an rtable and tries to send the packet. This
 	# causes failures for local traffic at different places
 	for a in ${NSA_LO_IP} 127.0.0.1
 	do
 		log_start
 		show_hint "Should fail since addresses on loopback are out of device scope"
-		run_cmd nettest -D -s &
-		sleep 1
+		run_cmd nettest -D -s -k
 		run_cmd nettest -D -r ${a} -d ${NSA_DEV}
 		log_test_addr ${a} $? 2 "Global server, device client, local connection"
 
 		log_start
 		show_hint "Should fail since addresses on loopback are out of device scope"
-		run_cmd nettest -D -s &
-		sleep 1
+		run_cmd nettest -D -s -k
 		run_cmd nettest -D -r ${a} -d ${NSA_DEV} -C
 		log_test_addr ${a} $? 1 "Global server, device send via cmsg, local connection"
 
 		log_start
 		show_hint "Should fail since addresses on loopback are out of device scope"
-		run_cmd nettest -D -s &
-		sleep 1
+		run_cmd nettest -D -s -k
 		run_cmd nettest -D -r ${a} -d ${NSA_DEV} -S
 		log_test_addr ${a} $? 1 "Global server, device client via IP_UNICAST_IF, local connection"
 	done
 
 	a=${NSA_IP}
 	log_start
-	run_cmd nettest -D -s -I ${NSA_DEV} -3 ${NSA_DEV} &
-	sleep 1
+	run_cmd nettest -D -s -I ${NSA_DEV} -3 ${NSA_DEV} -k
 	run_cmd nettest -D -d ${NSA_DEV} -r ${a} -0 ${a}
 	log_test_addr ${a} $? 0 "Device server, device client, local conn"
 
 	log_start
 	run_cmd nettest -D -d ${NSA_DEV} -r ${a}
@@ -1484,63 +1421,55 @@ ipv4_udp_vrf()
 	#
 	for a in ${NSA_IP} ${VRF_IP}
 	do
 		log_start
 		show_hint "Fails because ingress is in a VRF and global server is disabled"
-		run_cmd nettest -D -s &
-		sleep 1
+		run_cmd nettest -D -s -k
 		run_cmd_nsb nettest -D -r ${a}
 		log_test_addr ${a} $? 1 "Global server"
 
 		log_start
-		run_cmd nettest -D -I ${VRF} -s -3 ${NSA_DEV} &
-		sleep 1
+		run_cmd nettest -D -I ${VRF} -s -3 ${NSA_DEV} -k
 		run_cmd_nsb nettest -D -r ${a}
 		log_test_addr ${a} $? 0 "VRF server"
 
 		log_start
-		run_cmd nettest -D -I ${NSA_DEV} -s -3 ${NSA_DEV} &
-		sleep 1
+		run_cmd nettest -D -I ${NSA_DEV} -s -3 ${NSA_DEV} -k
 		run_cmd_nsb nettest -D -r ${a}
 		log_test_addr ${a} $? 0 "Enslaved device server"
 
 		log_start
 		show_hint "Should fail 'Connection refused' since there is no server"
 		run_cmd_nsb nettest -D -r ${a}
 		log_test_addr ${a} $? 1 "No server"
 
 		log_start
 		show_hint "Should fail 'Connection refused' since global server is out of scope"
-		run_cmd nettest -D -s &
-		sleep 1
+		run_cmd nettest -D -s -k
 		run_cmd nettest -D -d ${VRF} -r ${a}
 		log_test_addr ${a} $? 1 "Global server, VRF client, local connection"
 	done
 
 	a=${NSA_IP}
 	log_start
-	run_cmd nettest -s -D -I ${VRF} -3 ${NSA_DEV} &
-	sleep 1
+	run_cmd nettest -s -D -I ${VRF} -3 ${NSA_DEV} -k
 	run_cmd nettest -D -d ${VRF} -r ${a}
 	log_test_addr ${a} $? 0 "VRF server, VRF client, local conn"
 
 	log_start
-	run_cmd nettest -s -D -I ${VRF} -3 ${NSA_DEV} &
-	sleep 1
+	run_cmd nettest -s -D -I ${VRF} -3 ${NSA_DEV} -k
 	run_cmd nettest -D -d ${NSA_DEV} -r ${a}
 	log_test_addr ${a} $? 0 "VRF server, enslaved device client, local connection"
 
 	a=${NSA_IP}
 	log_start
-	run_cmd nettest -s -D -I ${NSA_DEV} -3 ${NSA_DEV} &
-	sleep 1
+	run_cmd nettest -s -D -I ${NSA_DEV} -3 ${NSA_DEV} -k
 	run_cmd nettest -D -d ${VRF} -r ${a}
 	log_test_addr ${a} $? 0 "Enslaved device server, VRF client, local conn"
 
 	log_start
-	run_cmd nettest -s -D -I ${NSA_DEV} -3 ${NSA_DEV} &
-	sleep 1
+	run_cmd nettest -s -D -I ${NSA_DEV} -3 ${NSA_DEV} -k
 	run_cmd nettest -D -d ${NSA_DEV} -r ${a}
 	log_test_addr ${a} $? 0 "Enslaved device server, device client, local conn"
 
 	# enable global server
 	log_subsection "Global server enabled"
@@ -1550,24 +1479,21 @@ ipv4_udp_vrf()
 	# server tests
 	#
 	for a in ${NSA_IP} ${VRF_IP}
 	do
 		log_start
-		run_cmd nettest -D -s -3 ${NSA_DEV} &
-		sleep 1
+		run_cmd nettest -D -s -3 ${NSA_DEV} -k
 		run_cmd_nsb nettest -D -r ${a}
 		log_test_addr ${a} $? 0 "Global server"
 
 		log_start
-		run_cmd nettest -D -I ${VRF} -s -3 ${NSA_DEV} &
-		sleep 1
+		run_cmd nettest -D -I ${VRF} -s -3 ${NSA_DEV} -k
 		run_cmd_nsb nettest -D -r ${a}
 		log_test_addr ${a} $? 0 "VRF server"
 
 		log_start
-		run_cmd nettest -D -I ${NSA_DEV} -s -3 ${NSA_DEV} &
-		sleep 1
+		run_cmd nettest -D -I ${NSA_DEV} -s -3 ${NSA_DEV} -k
 		run_cmd_nsb nettest -D -r ${a}
 		log_test_addr ${a} $? 0 "Enslaved device server"
 
 		log_start
 		show_hint "Should fail 'Connection refused'"
@@ -1577,18 +1503,16 @@ ipv4_udp_vrf()
 
 	#
 	# client tests
 	#
 	log_start
-	run_cmd_nsb nettest -D -s &
-	sleep 1
+	run_cmd_nsb nettest -D -s -k
 	run_cmd nettest -d ${VRF} -D -r ${NSB_IP} -1 ${NSA_IP}
 	log_test $? 0 "VRF client"
 
 	log_start
-	run_cmd_nsb nettest -D -s &
-	sleep 1
+	run_cmd_nsb nettest -D -s -k
 	run_cmd nettest -d ${NSA_DEV} -D -r ${NSB_IP} -1 ${NSA_IP}
 	log_test $? 0 "Enslaved device client"
 
 	# negative test - should fail
 	log_start
@@ -1604,53 +1528,46 @@ ipv4_udp_vrf()
 	#
 	# local address tests
 	#
 	a=${NSA_IP}
 	log_start
-	run_cmd nettest -D -s -3 ${NSA_DEV} &
-	sleep 1
+	run_cmd nettest -D -s -3 ${NSA_DEV} -k
 	run_cmd nettest -D -d ${VRF} -r ${a}
 	log_test_addr ${a} $? 0 "Global server, VRF client, local conn"
 
 	log_start
-	run_cmd nettest -s -D -I ${VRF} -3 ${NSA_DEV} &
-	sleep 1
+	run_cmd nettest -s -D -I ${VRF} -3 ${NSA_DEV} -k
 	run_cmd nettest -D -d ${VRF} -r ${a}
 	log_test_addr ${a} $? 0 "VRF server, VRF client, local conn"
 
 	log_start
-	run_cmd nettest -s -D -I ${VRF} -3 ${NSA_DEV} &
-	sleep 1
+	run_cmd nettest -s -D -I ${VRF} -3 ${NSA_DEV} -k
 	run_cmd nettest -D -d ${NSA_DEV} -r ${a}
 	log_test_addr ${a} $? 0 "VRF server, device client, local conn"
 
 	log_start
-	run_cmd nettest -s -D -I ${NSA_DEV} -3 ${NSA_DEV} &
-	sleep 1
+	run_cmd nettest -s -D -I ${NSA_DEV} -3 ${NSA_DEV} -k
 	run_cmd nettest -D -d ${VRF} -r ${a}
 	log_test_addr ${a} $? 0 "Enslaved device server, VRF client, local conn"
 
 	log_start
-	run_cmd nettest -s -D -I ${NSA_DEV} -3 ${NSA_DEV} &
-	sleep 1
+	run_cmd nettest -s -D -I ${NSA_DEV} -3 ${NSA_DEV} -k
 	run_cmd nettest -D -d ${NSA_DEV} -r ${a}
 	log_test_addr ${a} $? 0 "Enslaved device server, device client, local conn"
 
 	for a in ${VRF_IP} 127.0.0.1
 	do
 		log_start
-		run_cmd nettest -D -s -3 ${VRF} &
-		sleep 1
+		run_cmd nettest -D -s -3 ${VRF} -k
 		run_cmd nettest -D -d ${VRF} -r ${a}
 		log_test_addr ${a} $? 0 "Global server, VRF client, local conn"
 	done
 
 	for a in ${VRF_IP} 127.0.0.1
 	do
 		log_start
-		run_cmd nettest -s -D -I ${VRF} -3 ${VRF} &
-		sleep 1
+		run_cmd nettest -s -D -I ${VRF} -3 ${VRF} -k
 		run_cmd nettest -D -d ${VRF} -r ${a}
 		log_test_addr ${a} $? 0 "VRF server, VRF client, local conn"
 	done
 
 	# negative test - should fail
@@ -1807,12 +1724,11 @@ ipv4_rt()
 	# server tests
 	#
 	for a in ${NSA_IP} ${VRF_IP}
 	do
 		log_start
-		run_cmd nettest ${varg} -s &
-		sleep 1
+		run_cmd nettest ${varg} -s -k
 		run_cmd_nsb nettest ${varg} -r ${a} &
 		sleep 3
 		run_cmd ip link del ${VRF}
 		sleep 1
 		log_test_addr ${a} 0 0 "${desc}, global server"
@@ -1821,12 +1737,11 @@ ipv4_rt()
 	done
 
 	for a in ${NSA_IP} ${VRF_IP}
 	do
 		log_start
-		run_cmd nettest ${varg} -s -I ${VRF} &
-		sleep 1
+		run_cmd nettest ${varg} -s -I ${VRF} -k
 		run_cmd_nsb nettest ${varg} -r ${a} &
 		sleep 3
 		run_cmd ip link del ${VRF}
 		sleep 1
 		log_test_addr ${a} 0 0 "${desc}, VRF server"
@@ -1834,12 +1749,11 @@ ipv4_rt()
 		setup ${with_vrf}
 	done
 
 	a=${NSA_IP}
 	log_start
-	run_cmd nettest ${varg} -s -I ${NSA_DEV} &
-	sleep 1
+	run_cmd nettest ${varg} -s -I ${NSA_DEV} -k
 	run_cmd_nsb nettest ${varg} -r ${a} &
 	sleep 3
 	run_cmd ip link del ${VRF}
 	sleep 1
 	log_test_addr ${a} 0 0 "${desc}, enslaved device server"
@@ -1848,23 +1762,21 @@ ipv4_rt()
 
 	#
 	# client test
 	#
 	log_start
-	run_cmd_nsb nettest ${varg} -s &
-	sleep 1
+	run_cmd_nsb nettest ${varg} -s -k
 	run_cmd nettest ${varg} -d ${VRF} -r ${NSB_IP} &
 	sleep 3
 	run_cmd ip link del ${VRF}
 	sleep 1
 	log_test_addr ${a} 0 0 "${desc}, VRF client"
 
 	setup ${with_vrf}
 
 	log_start
-	run_cmd_nsb nettest ${varg} -s &
-	sleep 1
+	run_cmd_nsb nettest ${varg} -s -k
 	run_cmd nettest ${varg} -d ${NSA_DEV} -r ${NSB_IP} &
 	sleep 3
 	run_cmd ip link del ${VRF}
 	sleep 1
 	log_test_addr ${a} 0 0 "${desc}, enslaved device client"
@@ -1875,12 +1787,11 @@ ipv4_rt()
 	# local address tests
 	#
 	for a in ${NSA_IP} ${VRF_IP}
 	do
 		log_start
-		run_cmd nettest ${varg} -s &
-		sleep 1
+		run_cmd nettest ${varg} -s -k
 		run_cmd nettest ${varg} -d ${VRF} -r ${a} &
 		sleep 3
 		run_cmd ip link del ${VRF}
 		sleep 1
 		log_test_addr ${a} 0 0 "${desc}, global server, VRF client, local"
@@ -1889,12 +1800,11 @@ ipv4_rt()
 	done
 
 	for a in ${NSA_IP} ${VRF_IP}
 	do
 		log_start
-		run_cmd nettest ${varg} -I ${VRF} -s &
-		sleep 1
+		run_cmd nettest ${varg} -I ${VRF} -s -k
 		run_cmd nettest ${varg} -d ${VRF} -r ${a} &
 		sleep 3
 		run_cmd ip link del ${VRF}
 		sleep 1
 		log_test_addr ${a} 0 0 "${desc}, VRF server and client, local"
@@ -1902,34 +1812,31 @@ ipv4_rt()
 		setup ${with_vrf}
 	done
 
 	a=${NSA_IP}
 	log_start
-	run_cmd nettest ${varg} -s &
-	sleep 1
+	run_cmd nettest ${varg} -s -k
 	run_cmd nettest ${varg} -d ${NSA_DEV} -r ${a} &
 	sleep 3
 	run_cmd ip link del ${VRF}
 	sleep 1
 	log_test_addr ${a} 0 0 "${desc}, global server, enslaved device client, local"
 
 	setup ${with_vrf}
 
 	log_start
-	run_cmd nettest ${varg} -I ${VRF} -s &
-	sleep 1
+	run_cmd nettest ${varg} -I ${VRF} -s -k
 	run_cmd nettest ${varg} -d ${NSA_DEV} -r ${a} &
 	sleep 3
 	run_cmd ip link del ${VRF}
 	sleep 1
 	log_test_addr ${a} 0 0 "${desc}, VRF server, enslaved device client, local"
 
 	setup ${with_vrf}
 
 	log_start
-	run_cmd nettest ${varg} -I ${NSA_DEV} -s &
-	sleep 1
+	run_cmd nettest ${varg} -I ${NSA_DEV} -s -k
 	run_cmd nettest ${varg} -d ${NSA_DEV} -r ${a} &
 	sleep 3
 	run_cmd ip link del ${VRF}
 	sleep 1
 	log_test_addr ${a} 0 0 "${desc}, enslaved device server and client, local"
@@ -2268,63 +2175,56 @@ ipv6_tcp_md5_novrf()
 	# single address
 	#
 
 	# basic use case
 	log_start
-	run_cmd nettest -6 -s -M ${MD5_PW} -m ${NSB_IP6} &
-	sleep 1
+	run_cmd nettest -6 -s -M ${MD5_PW} -m ${NSB_IP6} -k
 	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_PW}
 	log_test $? 0 "MD5: Single address config"
 
 	# client sends MD5, server not configured
 	log_start
 	show_hint "Should timeout due to MD5 mismatch"
-	run_cmd nettest -6 -s &
-	sleep 1
+	run_cmd nettest -6 -s -k
 	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_PW}
 	log_test $? 2 "MD5: Server no config, client uses password"
 
 	# wrong password
 	log_start
 	show_hint "Should timeout since client uses wrong password"
-	run_cmd nettest -6 -s -M ${MD5_PW} -m ${NSB_IP6} &
-	sleep 1
+	run_cmd nettest -6 -s -M ${MD5_PW} -m ${NSB_IP6} -k
 	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_WRONG_PW}
 	log_test $? 2 "MD5: Client uses wrong password"
 
 	# client from different address
 	log_start
 	show_hint "Should timeout due to MD5 mismatch"
-	run_cmd nettest -6 -s -M ${MD5_PW} -m ${NSB_LO_IP6} &
-	sleep 1
+	run_cmd nettest -6 -s -M ${MD5_PW} -m ${NSB_LO_IP6} -k
 	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_PW}
 	log_test $? 2 "MD5: Client address does not match address configured with password"
 
 	#
 	# MD5 extension - prefix length
 	#
 
 	# client in prefix
 	log_start
-	run_cmd nettest -6 -s -M ${MD5_PW} -m ${NS_NET6} &
-	sleep 1
+	run_cmd nettest -6 -s -M ${MD5_PW} -m ${NS_NET6} -k
 	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_PW}
 	log_test $? 0 "MD5: Prefix config"
 
 	# client in prefix, wrong password
 	log_start
 	show_hint "Should timeout since client uses wrong password"
-	run_cmd nettest -6 -s -M ${MD5_PW} -m ${NS_NET6} &
-	sleep 1
+	run_cmd nettest -6 -s -M ${MD5_PW} -m ${NS_NET6} -k
 	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_WRONG_PW}
 	log_test $? 2 "MD5: Prefix config, client uses wrong password"
 
 	# client outside of prefix
 	log_start
 	show_hint "Should timeout due to MD5 mismatch"
-	run_cmd nettest -6 -s -M ${MD5_PW} -m ${NS_NET6} &
-	sleep 1
+	run_cmd nettest -6 -s -M ${MD5_PW} -m ${NS_NET6} -k
 	run_cmd_nsb nettest -6 -c ${NSB_LO_IP6} -r ${NSA_IP6} -X ${MD5_PW}
 	log_test $? 2 "MD5: Prefix config, client address not in configured prefix"
 }
 
 #
@@ -2336,127 +2236,112 @@ ipv6_tcp_md5()
 	# single address
 	#
 
 	# basic use case
 	log_start
-	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NSB_IP6} &
-	sleep 1
+	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NSB_IP6} -k
 	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_PW}
 	log_test $? 0 "MD5: VRF: Single address config"
 
 	# client sends MD5, server not configured
 	log_start
 	show_hint "Should timeout since server does not have MD5 auth"
-	run_cmd nettest -6 -s -I ${VRF} &
-	sleep 1
+	run_cmd nettest -6 -s -I ${VRF} -k
 	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_PW}
 	log_test $? 2 "MD5: VRF: Server no config, client uses password"
 
 	# wrong password
 	log_start
 	show_hint "Should timeout since client uses wrong password"
-	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NSB_IP6} &
-	sleep 1
+	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NSB_IP6} -k
 	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_WRONG_PW}
 	log_test $? 2 "MD5: VRF: Client uses wrong password"
 
 	# client from different address
 	log_start
 	show_hint "Should timeout since server config differs from client"
-	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NSB_LO_IP6} &
-	sleep 1
+	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NSB_LO_IP6} -k
 	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_PW}
 	log_test $? 2 "MD5: VRF: Client address does not match address configured with password"
 
 	#
 	# MD5 extension - prefix length
 	#
 
 	# client in prefix
 	log_start
-	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET6} &
-	sleep 1
+	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET6} -k
 	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_PW}
 	log_test $? 0 "MD5: VRF: Prefix config"
 
 	# client in prefix, wrong password
 	log_start
 	show_hint "Should timeout since client uses wrong password"
-	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET6} &
-	sleep 1
+	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET6} -k
 	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_WRONG_PW}
 	log_test $? 2 "MD5: VRF: Prefix config, client uses wrong password"
 
 	# client outside of prefix
 	log_start
 	show_hint "Should timeout since client address is outside of prefix"
-	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET6} &
-	sleep 1
+	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET6} -k
 	run_cmd_nsb nettest -6 -c ${NSB_LO_IP6} -r ${NSA_IP6} -X ${MD5_PW}
 	log_test $? 2 "MD5: VRF: Prefix config, client address not in configured prefix"
 
 	#
 	# duplicate config between default VRF and a VRF
 	#
 
 	log_start
-	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NSB_IP6} &
-	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -m ${NSB_IP6} &
-	sleep 1
+	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NSB_IP6} -k
+	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -m ${NSB_IP6} -k
 	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_PW}
 	log_test $? 0 "MD5: VRF: Single address config in default VRF and VRF, conn in VRF"
 
 	log_start
-	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NSB_IP6} &
-	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -m ${NSB_IP6} &
-	sleep 1
+	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NSB_IP6} -k
+	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -m ${NSB_IP6} -k
 	run_cmd_nsc nettest -6 -r ${NSA_IP6} -X ${MD5_WRONG_PW}
 	log_test $? 0 "MD5: VRF: Single address config in default VRF and VRF, conn in default VRF"
 
 	log_start
 	show_hint "Should timeout since client in default VRF uses VRF password"
-	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NSB_IP6} &
-	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -m ${NSB_IP6} &
-	sleep 1
+	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NSB_IP6} -k
+	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -m ${NSB_IP6} -k
 	run_cmd_nsc nettest -6 -r ${NSA_IP6} -X ${MD5_PW}
 	log_test $? 2 "MD5: VRF: Single address config in default VRF and VRF, conn in default VRF with VRF pw"
 
 	log_start
 	show_hint "Should timeout since client in VRF uses default VRF password"
-	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NSB_IP6} &
-	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -m ${NSB_IP6} &
-	sleep 1
+	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NSB_IP6} -k
+	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -m ${NSB_IP6} -k
 	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_WRONG_PW}
 	log_test $? 2 "MD5: VRF: Single address config in default VRF and VRF, conn in VRF with default VRF pw"
 
 	log_start
-	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET6} &
-	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -m ${NS_NET6} &
-	sleep 1
+	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET6} -k
+	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -m ${NS_NET6} -k
 	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_PW}
 	log_test $? 0 "MD5: VRF: Prefix config in default VRF and VRF, conn in VRF"
 
 	log_start
-	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET6} &
-	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -m ${NS_NET6} &
-	sleep 1
+	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET6} -k
+	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -m ${NS_NET6} -k
 	run_cmd_nsc nettest -6 -r ${NSA_IP6} -X ${MD5_WRONG_PW}
 	log_test $? 0 "MD5: VRF: Prefix config in default VRF and VRF, conn in default VRF"
 
 	log_start
 	show_hint "Should timeout since client in default VRF uses VRF password"
-	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET6} &
-	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -m ${NS_NET6} &
-	sleep 1
+	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET6} -k
+	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -m ${NS_NET6} -k
 	run_cmd_nsc nettest -6 -r ${NSA_IP6} -X ${MD5_PW}
 	log_test $? 2 "MD5: VRF: Prefix config in default VRF and VRF, conn in default VRF with VRF pw"
 
 	log_start
 	show_hint "Should timeout since client in VRF uses default VRF password"
-	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET6} &
-	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -m ${NS_NET6} &
-	sleep 1
+	run_cmd nettest -6 -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET6} -k
+	run_cmd nettest -6 -s -M ${MD5_WRONG_PW} -m ${NS_NET6} -k
 	run_cmd_nsb nettest -6 -r ${NSA_IP6} -X ${MD5_WRONG_PW}
 	log_test $? 2 "MD5: VRF: Prefix config in default VRF and VRF, conn in VRF with default VRF pw"
 
 	#
 	# negative tests
@@ -2479,12 +2364,11 @@ ipv6_tcp_novrf()
 	# server tests
 	#
 	for a in ${NSA_IP6} ${NSA_LO_IP6} ${NSA_LINKIP6}%${NSB_DEV}
 	do
 		log_start
-		run_cmd nettest -6 -s &
-		sleep 1
+		run_cmd nettest -6 -s -k
 		run_cmd_nsb nettest -6 -r ${a}
 		log_test_addr ${a} $? 0 "Global server"
 	done
 
 	# verify TCP reset received
@@ -2500,21 +2384,19 @@ ipv6_tcp_novrf()
 	# client
 	#
 	for a in ${NSB_IP6} ${NSB_LO_IP6} ${NSB_LINKIP6}%${NSA_DEV}
 	do
 		log_start
-		run_cmd_nsb nettest -6 -s &
-		sleep 1
+		run_cmd_nsb nettest -6 -s -k
 		run_cmd nettest -6 -r ${a}
 		log_test_addr ${a} $? 0 "Client"
 	done
 
 	for a in ${NSB_IP6} ${NSB_LO_IP6} ${NSB_LINKIP6}%${NSA_DEV}
 	do
 		log_start
-		run_cmd_nsb nettest -6 -s &
-		sleep 1
+		run_cmd_nsb nettest -6 -s -k
 		run_cmd nettest -6 -r ${a} -d ${NSA_DEV}
 		log_test_addr ${a} $? 0 "Client, device bind"
 	done
 
 	for a in ${NSB_IP6} ${NSB_LO_IP6} ${NSB_LINKIP6}%${NSA_DEV}
@@ -2529,55 +2411,49 @@ ipv6_tcp_novrf()
 	# local address tests
 	#
 	for a in ${NSA_IP6} ${NSA_LO_IP6} ::1
 	do
 		log_start
-		run_cmd nettest -6 -s &
-		sleep 1
+		run_cmd nettest -6 -s -k
 		run_cmd nettest -6 -r ${a}
 		log_test_addr ${a} $? 0 "Global server, local connection"
 	done
 
 	a=${NSA_IP6}
 	log_start
-	run_cmd nettest -6 -s -I ${NSA_DEV} -3 ${NSA_DEV} &
-	sleep 1
+	run_cmd nettest -6 -s -I ${NSA_DEV} -3 ${NSA_DEV} -k
 	run_cmd nettest -6 -r ${a} -0 ${a}
 	log_test_addr ${a} $? 0 "Device server, unbound client, local connection"
 
 	for a in ${NSA_LO_IP6} ::1
 	do
 		log_start
 		show_hint "Should fail 'Connection refused' since addresses on loopback are out of device scope"
-		run_cmd nettest -6 -s -I ${NSA_DEV} &
-		sleep 1
+		run_cmd nettest -6 -s -I ${NSA_DEV} -k
 		run_cmd nettest -6 -r ${a}
 		log_test_addr ${a} $? 1 "Device server, unbound client, local connection"
 	done
 
 	a=${NSA_IP6}
 	log_start
-	run_cmd nettest -6 -s &
-	sleep 1
+	run_cmd nettest -6 -s -k
 	run_cmd nettest -6 -r ${a} -d ${NSA_DEV} -0 ${a}
 	log_test_addr ${a} $? 0 "Global server, device client, local connection"
 
 	for a in ${NSA_LO_IP6} ::1
 	do
 		log_start
 		show_hint "Should fail 'Connection refused' since addresses on loopback are out of device scope"
-		run_cmd nettest -6 -s &
-		sleep 1
+		run_cmd nettest -6 -s -k
 		run_cmd nettest -6 -r ${a} -d ${NSA_DEV}
 		log_test_addr ${a} $? 1 "Global server, device client, local connection"
 	done
 
 	for a in ${NSA_IP6} ${NSA_LINKIP6}
 	do
 		log_start
-		run_cmd nettest -6 -s -I ${NSA_DEV} -3 ${NSA_DEV} &
-		sleep 1
+		run_cmd nettest -6 -s -I ${NSA_DEV} -3 ${NSA_DEV} -k
 		run_cmd nettest -6  -d ${NSA_DEV} -r ${a}
 		log_test_addr ${a} $? 0 "Device server, device client, local conn"
 	done
 
 	for a in ${NSA_IP6} ${NSA_LINKIP6}
@@ -2605,38 +2481,34 @@ ipv6_tcp_vrf()
 	#
 	for a in ${NSA_IP6} ${VRF_IP6} ${NSA_LINKIP6}%${NSB_DEV}
 	do
 		log_start
 		show_hint "Should fail 'Connection refused' since global server with VRF is disabled"
-		run_cmd nettest -6 -s &
-		sleep 1
+		run_cmd nettest -6 -s -k
 		run_cmd_nsb nettest -6 -r ${a}
 		log_test_addr ${a} $? 1 "Global server"
 	done
 
 	for a in ${NSA_IP6} ${VRF_IP6}
 	do
 		log_start
-		run_cmd nettest -6 -s -I ${VRF} -3 ${VRF} &
-		sleep 1
+		run_cmd nettest -6 -s -I ${VRF} -3 ${VRF} -k
 		run_cmd_nsb nettest -6 -r ${a}
 		log_test_addr ${a} $? 0 "VRF server"
 	done
 
 	# link local is always bound to ingress device
 	a=${NSA_LINKIP6}%${NSB_DEV}
 	log_start
-	run_cmd nettest -6 -s -I ${VRF} -3 ${NSA_DEV} &
-	sleep 1
+	run_cmd nettest -6 -s -I ${VRF} -3 ${NSA_DEV} -k
 	run_cmd_nsb nettest -6 -r ${a}
 	log_test_addr ${a} $? 0 "VRF server"
 
 	for a in ${NSA_IP6} ${VRF_IP6} ${NSA_LINKIP6}%${NSB_DEV}
 	do
 		log_start
-		run_cmd nettest -6 -s -I ${NSA_DEV} -3 ${NSA_DEV} &
-		sleep 1
+		run_cmd nettest -6 -s -I ${NSA_DEV} -3 ${NSA_DEV} -k
 		run_cmd_nsb nettest -6 -r ${a}
 		log_test_addr ${a} $? 0 "Device server"
 	done
 
 	# verify TCP reset received
@@ -2650,12 +2522,11 @@ ipv6_tcp_vrf()
 
 	# local address tests
 	a=${NSA_IP6}
 	log_start
 	show_hint "Should fail 'Connection refused' since global server with VRF is disabled"
-	run_cmd nettest -6 -s &
-	sleep 1
+	run_cmd nettest -6 -s -k
 	run_cmd nettest -6 -r ${a} -d ${NSA_DEV}
 	log_test_addr ${a} $? 1 "Global server, local connection"
 
 	# run MD5 tests
 	ipv6_tcp_md5
@@ -2667,44 +2538,39 @@ ipv6_tcp_vrf()
 	set_sysctl net.ipv4.tcp_l3mdev_accept=1
 
 	for a in ${NSA_IP6} ${VRF_IP6}
 	do
 		log_start
-		run_cmd nettest -6 -s -3 ${VRF} &
-		sleep 1
+		run_cmd nettest -6 -s -3 ${VRF} -k
 		run_cmd_nsb nettest -6 -r ${a}
 		log_test_addr ${a} $? 0 "Global server"
 	done
 
 	for a in ${NSA_IP6} ${VRF_IP6}
 	do
 		log_start
-		run_cmd nettest -6 -s -I ${VRF} -3 ${VRF} &
-		sleep 1
+		run_cmd nettest -6 -s -I ${VRF} -3 ${VRF} -k
 		run_cmd_nsb nettest -6 -r ${a}
 		log_test_addr ${a} $? 0 "VRF server"
 	done
 
 	# For LLA, child socket is bound to device
 	a=${NSA_LINKIP6}%${NSB_DEV}
 	log_start
-	run_cmd nettest -6 -s -3 ${NSA_DEV} &
-	sleep 1
+	run_cmd nettest -6 -s -3 ${NSA_DEV} -k
 	run_cmd_nsb nettest -6 -r ${a}
 	log_test_addr ${a} $? 0 "Global server"
 
 	log_start
-	run_cmd nettest -6 -s -I ${VRF} -3 ${NSA_DEV} &
-	sleep 1
+	run_cmd nettest -6 -s -I ${VRF} -3 ${NSA_DEV} -k
 	run_cmd_nsb nettest -6 -r ${a}
 	log_test_addr ${a} $? 0 "VRF server"
 
 	for a in ${NSA_IP6} ${NSA_LINKIP6}%${NSB_DEV}
 	do
 		log_start
-		run_cmd nettest -6 -s -I ${NSA_DEV} -3 ${NSA_DEV} &
-		sleep 1
+		run_cmd nettest -6 -s -I ${NSA_DEV} -3 ${NSA_DEV} -k
 		run_cmd_nsb nettest -6 -r ${a}
 		log_test_addr ${a} $? 0 "Device server"
 	done
 
 	# verify TCP reset received
@@ -2719,12 +2585,11 @@ ipv6_tcp_vrf()
 	# local address tests
 	for a in ${NSA_IP6} ${VRF_IP6}
 	do
 		log_start
 		show_hint "Fails 'Connection refused' since client is not in VRF"
-		run_cmd nettest -6 -s -I ${VRF} &
-		sleep 1
+		run_cmd nettest -6 -s -I ${VRF} -k
 		run_cmd nettest -6 -r ${a}
 		log_test_addr ${a} $? 1 "Global server, local connection"
 	done
 
 
@@ -2732,29 +2597,26 @@ ipv6_tcp_vrf()
 	# client
 	#
 	for a in ${NSB_IP6} ${NSB_LO_IP6}
 	do
 		log_start
-		run_cmd_nsb nettest -6 -s &
-		sleep 1
+		run_cmd_nsb nettest -6 -s -k
 		run_cmd nettest -6 -r ${a} -d ${VRF}
 		log_test_addr ${a} $? 0 "Client, VRF bind"
 	done
 
 	a=${NSB_LINKIP6}
 	log_start
 	show_hint "Fails since VRF device does not allow linklocal addresses"
-	run_cmd_nsb nettest -6 -s &
-	sleep 1
+	run_cmd_nsb nettest -6 -s -k
 	run_cmd nettest -6 -r ${a} -d ${VRF}
 	log_test_addr ${a} $? 1 "Client, VRF bind"
 
 	for a in ${NSB_IP6} ${NSB_LO_IP6} ${NSB_LINKIP6}
 	do
 		log_start
-		run_cmd_nsb nettest -6 -s &
-		sleep 1
+		run_cmd_nsb nettest -6 -s -k
 		run_cmd nettest -6 -r ${a} -d ${NSA_DEV}
 		log_test_addr ${a} $? 0 "Client, device bind"
 	done
 
 	for a in ${NSB_IP6} ${NSB_LO_IP6}
@@ -2774,42 +2636,37 @@ ipv6_tcp_vrf()
 	done
 
 	for a in ${NSA_IP6} ${VRF_IP6} ::1
 	do
 		log_start
-		run_cmd nettest -6 -s -I ${VRF} -3 ${VRF} &
-		sleep 1
+		run_cmd nettest -6 -s -I ${VRF} -3 ${VRF} -k
 		run_cmd nettest -6 -r ${a} -d ${VRF} -0 ${a}
 		log_test_addr ${a} $? 0 "VRF server, VRF client, local connection"
 	done
 
 	a=${NSA_IP6}
 	log_start
-	run_cmd nettest -6 -s -I ${VRF} -3 ${VRF} &
-	sleep 1
+	run_cmd nettest -6 -s -I ${VRF} -3 ${VRF} -k
 	run_cmd nettest -6 -r ${a} -d ${NSA_DEV} -0 ${a}
 	log_test_addr ${a} $? 0 "VRF server, device client, local connection"
 
 	a=${NSA_IP6}
 	log_start
 	show_hint "Should fail since unbound client is out of VRF scope"
-	run_cmd nettest -6 -s -I ${VRF} &
-	sleep 1
+	run_cmd nettest -6 -s -I ${VRF} -k
 	run_cmd nettest -6 -r ${a}
 	log_test_addr ${a} $? 1 "VRF server, unbound client, local connection"
 
 	log_start
-	run_cmd nettest -6 -s -I ${NSA_DEV} -3 ${NSA_DEV} &
-	sleep 1
+	run_cmd nettest -6 -s -I ${NSA_DEV} -3 ${NSA_DEV} -k
 	run_cmd nettest -6 -r ${a} -d ${VRF} -0 ${a}
 	log_test_addr ${a} $? 0 "Device server, VRF client, local connection"
 
 	for a in ${NSA_IP6} ${NSA_LINKIP6}
 	do
 		log_start
-		run_cmd nettest -6 -s -I ${NSA_DEV} -3 ${NSA_DEV} &
-		sleep 1
+		run_cmd nettest -6 -s -I ${NSA_DEV} -3 ${NSA_DEV} -k
 		run_cmd nettest -6 -r ${a} -d ${NSA_DEV} -0 ${a}
 		log_test_addr ${a} $? 0 "Device server, device client, local connection"
 	done
 }
 
@@ -2844,26 +2701,23 @@ ipv6_udp_novrf()
 	# server tests
 	#
 	for a in ${NSA_IP6} ${NSA_LINKIP6}%${NSB_DEV}
 	do
 		log_start
-		run_cmd nettest -6 -D -s -3 ${NSA_DEV} &
-		sleep 1
+		run_cmd nettest -6 -D -s -3 ${NSA_DEV} -k
 		run_cmd_nsb nettest -6 -D -r ${a}
 		log_test_addr ${a} $? 0 "Global server"
 
 		log_start
-		run_cmd nettest -6 -D -I ${NSA_DEV} -s -3 ${NSA_DEV} &
-		sleep 1
+		run_cmd nettest -6 -D -I ${NSA_DEV} -s -3 ${NSA_DEV} -k
 		run_cmd_nsb nettest -6 -D -r ${a}
 		log_test_addr ${a} $? 0 "Device server"
 	done
 
 	a=${NSA_LO_IP6}
 	log_start
-	run_cmd nettest -6 -D -s -3 ${NSA_DEV} &
-	sleep 1
+	run_cmd nettest -6 -D -s -3 ${NSA_DEV} -k
 	run_cmd_nsb nettest -6 -D -r ${a}
 	log_test_addr ${a} $? 0 "Global server"
 
 	# should fail since loopback address is out of scope for a device
 	# bound server, but it does not - hence this is more documenting
@@ -2888,30 +2742,26 @@ ipv6_udp_novrf()
 	# client
 	#
 	for a in ${NSB_IP6} ${NSB_LO_IP6} ${NSB_LINKIP6}%${NSA_DEV}
 	do
 		log_start
-		run_cmd_nsb nettest -6 -D -s &
-		sleep 1
+		run_cmd_nsb nettest -6 -D -s -k
 		run_cmd nettest -6 -D -r ${a} -0 ${NSA_IP6}
 		log_test_addr ${a} $? 0 "Client"
 
 		log_start
-		run_cmd_nsb nettest -6 -D -s &
-		sleep 1
+		run_cmd_nsb nettest -6 -D -s -k
 		run_cmd nettest -6 -D -r ${a} -d ${NSA_DEV} -0 ${NSA_IP6}
 		log_test_addr ${a} $? 0 "Client, device bind"
 
 		log_start
-		run_cmd_nsb nettest -6 -D -s &
-		sleep 1
+		run_cmd_nsb nettest -6 -D -s -k
 		run_cmd nettest -6 -D -r ${a} -d ${NSA_DEV} -C -0 ${NSA_IP6}
 		log_test_addr ${a} $? 0 "Client, device send via cmsg"
 
 		log_start
-		run_cmd_nsb nettest -6 -D -s &
-		sleep 1
+		run_cmd_nsb nettest -6 -D -s -k
 		run_cmd nettest -6 -D -r ${a} -d ${NSA_DEV} -S -0 ${NSA_IP6}
 		log_test_addr ${a} $? 0 "Client, device bind via IPV6_UNICAST_IF"
 
 		log_start
 		show_hint "Should fail 'Connection refused'"
@@ -2928,80 +2778,70 @@ ipv6_udp_novrf()
 	# local address tests
 	#
 	for a in ${NSA_IP6} ${NSA_LO_IP6} ::1
 	do
 		log_start
-		run_cmd nettest -6 -D -s &
-		sleep 1
+		run_cmd nettest -6 -D -s -k
 		run_cmd nettest -6 -D -r ${a} -0 ${a} -1 ${a}
 		log_test_addr ${a} $? 0 "Global server, local connection"
 	done
 
 	a=${NSA_IP6}
 	log_start
-	run_cmd nettest -6 -s -D -I ${NSA_DEV} -3 ${NSA_DEV} &
-	sleep 1
+	run_cmd nettest -6 -s -D -I ${NSA_DEV} -3 ${NSA_DEV} -k
 	run_cmd nettest -6 -D -r ${a}
 	log_test_addr ${a} $? 0 "Device server, unbound client, local connection"
 
 	for a in ${NSA_LO_IP6} ::1
 	do
 		log_start
 		show_hint "Should fail 'Connection refused' since address is out of device scope"
-		run_cmd nettest -6 -s -D -I ${NSA_DEV} &
-		sleep 1
+		run_cmd nettest -6 -s -D -I ${NSA_DEV} -k
 		run_cmd nettest -6 -D -r ${a}
 		log_test_addr ${a} $? 1 "Device server, local connection"
 	done
 
 	a=${NSA_IP6}
 	log_start
-	run_cmd nettest -6 -s -D &
-	sleep 1
+	run_cmd nettest -6 -s -D -k
 	run_cmd nettest -6 -D -d ${NSA_DEV} -r ${a}
 	log_test_addr ${a} $? 0 "Global server, device client, local connection"
 
 	log_start
-	run_cmd nettest -6 -s -D &
-	sleep 1
+	run_cmd nettest -6 -s -D -k
 	run_cmd nettest -6 -D -d ${NSA_DEV} -C -r ${a}
 	log_test_addr ${a} $? 0 "Global server, device send via cmsg, local connection"
 
 	log_start
-	run_cmd nettest -6 -s -D &
-	sleep 1
+	run_cmd nettest -6 -s -D -k
 	run_cmd nettest -6 -D -d ${NSA_DEV} -S -r ${a}
 	log_test_addr ${a} $? 0 "Global server, device client via IPV6_UNICAST_IF, local connection"
 
 	for a in ${NSA_LO_IP6} ::1
 	do
 		log_start
 		show_hint "Should fail 'No route to host' since addresses on loopback are out of device scope"
-		run_cmd nettest -6 -D -s &
-		sleep 1
+		run_cmd nettest -6 -D -s -k
 		run_cmd nettest -6 -D -r ${a} -d ${NSA_DEV}
 		log_test_addr ${a} $? 1 "Global server, device client, local connection"
 
 		log_start
 		show_hint "Should fail 'No route to host' since addresses on loopback are out of device scope"
-		run_cmd nettest -6 -D -s &
-		sleep 1
+		run_cmd nettest -6 -D -s -k
 		run_cmd nettest -6 -D -r ${a} -d ${NSA_DEV} -C
 		log_test_addr ${a} $? 1 "Global server, device send via cmsg, local connection"
 
 		log_start
 		show_hint "Should fail 'No route to host' since addresses on loopback are out of device scope"
-		run_cmd nettest -6 -D -s &
-		sleep 1
+		run_cmd nettest -6 -D -s -k
 		run_cmd nettest -6 -D -r ${a} -d ${NSA_DEV} -S
 		log_test_addr ${a} $? 1 "Global server, device client via IP_UNICAST_IF, local connection"
 	done
 
 	a=${NSA_IP6}
 	log_start
-	run_cmd nettest -6 -D -s -I ${NSA_DEV} -3 ${NSA_DEV} &
-	sleep 1
+	run_cmd nettest -6 -D -s -I ${NSA_DEV} -3 ${NSA_DEV} -k
 	run_cmd nettest -6 -D -d ${NSA_DEV} -r ${a} -0 ${a}
 	log_test_addr ${a} $? 0 "Device server, device client, local conn"
 
 	log_start
 	show_hint "Should fail 'Connection refused'"
@@ -3010,12 +2850,11 @@ ipv6_udp_novrf()
 
 	# LLA to GUA
 	run_cmd_nsb ip -6 addr del ${NSB_IP6}/64 dev ${NSB_DEV}
 	run_cmd_nsb ip -6 ro add ${NSA_IP6}/128 dev ${NSB_DEV}
 	log_start
-	run_cmd nettest -6 -s -D &
-	sleep 1
+	run_cmd nettest -6 -s -D -k
 	run_cmd_nsb nettest -6 -D -r ${NSA_IP6}
 	log_test $? 0 "UDP in - LLA to GUA"
 
 	run_cmd_nsb ip -6 ro del ${NSA_IP6}/128 dev ${NSB_DEV}
 	run_cmd_nsb ip -6 addr add ${NSB_IP6}/64 dev ${NSB_DEV}
@@ -3034,30 +2873,27 @@ ipv6_udp_vrf()
 	#
 	for a in ${NSA_IP6} ${VRF_IP6}
 	do
 		log_start
 		show_hint "Should fail 'Connection refused' since global server is disabled"
-		run_cmd nettest -6 -D -s &
-		sleep 1
+		run_cmd nettest -6 -D -s -k
 		run_cmd_nsb nettest -6 -D -r ${a}
 		log_test_addr ${a} $? 1 "Global server"
 	done
 
 	for a in ${NSA_IP6} ${VRF_IP6}
 	do
 		log_start
-		run_cmd nettest -6 -D -I ${VRF} -s -3 ${NSA_DEV} &
-		sleep 1
+		run_cmd nettest -6 -D -I ${VRF} -s -3 ${NSA_DEV} -k
 		run_cmd_nsb nettest -6 -D -r ${a}
 		log_test_addr ${a} $? 0 "VRF server"
 	done
 
 	for a in ${NSA_IP6} ${VRF_IP6}
 	do
 		log_start
-		run_cmd nettest -6 -D -I ${NSA_DEV} -s -3 ${NSA_DEV} &
-		sleep 1
+		run_cmd nettest -6 -D -I ${NSA_DEV} -s -3 ${NSA_DEV} -k
 		run_cmd_nsb nettest -6 -D -r ${a}
 		log_test_addr ${a} $? 0 "Enslaved device server"
 	done
 
 	# negative test - should fail
@@ -3074,48 +2910,42 @@ ipv6_udp_vrf()
 	#
 	for a in ${NSA_IP6} ${VRF_IP6}
 	do
 		log_start
 		show_hint "Should fail 'Connection refused' since global server is disabled"
-		run_cmd nettest -6 -D -s &
-		sleep 1
+		run_cmd nettest -6 -D -s -k
 		run_cmd nettest -6 -D -d ${VRF} -r ${a}
 		log_test_addr ${a} $? 1 "Global server, VRF client, local conn"
 	done
 
 	for a in ${NSA_IP6} ${VRF_IP6}
 	do
 		log_start
-		run_cmd nettest -6 -D -I ${VRF} -s &
-		sleep 1
+		run_cmd nettest -6 -D -I ${VRF} -s -k
 		run_cmd nettest -6 -D -d ${VRF} -r ${a}
 		log_test_addr ${a} $? 0 "VRF server, VRF client, local conn"
 	done
 
 	a=${NSA_IP6}
 	log_start
 	show_hint "Should fail 'Connection refused' since global server is disabled"
-	run_cmd nettest -6 -D -s &
-	sleep 1
+	run_cmd nettest -6 -D -s -k
 	run_cmd nettest -6 -D -d ${NSA_DEV} -r ${a}
 	log_test_addr ${a} $? 1 "Global server, device client, local conn"
 
 	log_start
-	run_cmd nettest -6 -D -I ${VRF} -s -3 ${NSA_DEV} &
-	sleep 1
+	run_cmd nettest -6 -D -I ${VRF} -s -3 ${NSA_DEV} -k
 	run_cmd nettest -6 -D -d ${NSA_DEV} -r ${a}
 	log_test_addr ${a} $? 0 "VRF server, device client, local conn"
 
 	log_start
-	run_cmd nettest -6 -D -I ${NSA_DEV} -s -3 ${NSA_DEV} &
-	sleep 1
+	run_cmd nettest -6 -D -I ${NSA_DEV} -s -3 ${NSA_DEV} -k
 	run_cmd nettest -6 -D -d ${VRF} -r ${a}
 	log_test_addr ${a} $? 0 "Enslaved device server, VRF client, local conn"
 
 	log_start
-	run_cmd nettest -6 -D -I ${NSA_DEV} -s -3 ${NSA_DEV} &
-	sleep 1
+	run_cmd nettest -6 -D -I ${NSA_DEV} -s -3 ${NSA_DEV} -k
 	run_cmd nettest -6 -D -d ${NSA_DEV} -r ${a}
 	log_test_addr ${a} $? 0 "Enslaved device server, device client, local conn"
 
 	# disable global server
 	log_subsection "Global server enabled"
@@ -3125,30 +2955,27 @@ ipv6_udp_vrf()
 	# server tests
 	#
 	for a in ${NSA_IP6} ${VRF_IP6}
 	do
 		log_start
-		run_cmd nettest -6 -D -s -3 ${NSA_DEV} &
-		sleep 1
+		run_cmd nettest -6 -D -s -3 ${NSA_DEV} -k
 		run_cmd_nsb nettest -6 -D -r ${a}
 		log_test_addr ${a} $? 0 "Global server"
 	done
 
 	for a in ${NSA_IP6} ${VRF_IP6}
 	do
 		log_start
-		run_cmd nettest -6 -D -I ${VRF} -s -3 ${NSA_DEV} &
-		sleep 1
+		run_cmd nettest -6 -D -I ${VRF} -s -3 ${NSA_DEV} -k
 		run_cmd_nsb nettest -6 -D -r ${a}
 		log_test_addr ${a} $? 0 "VRF server"
 	done
 
 	for a in ${NSA_IP6} ${VRF_IP6}
 	do
 		log_start
-		run_cmd nettest -6 -D -I ${NSA_DEV} -s -3 ${NSA_DEV} &
-		sleep 1
+		run_cmd nettest -6 -D -I ${NSA_DEV} -s -3 ${NSA_DEV} -k
 		run_cmd_nsb nettest -6 -D -r ${a}
 		log_test_addr ${a} $? 0 "Enslaved device server"
 	done
 
 	# negative test - should fail
@@ -3161,23 +2988,21 @@ ipv6_udp_vrf()
 
 	#
 	# client tests
 	#
 	log_start
-	run_cmd_nsb nettest -6 -D -s &
-	sleep 1
+	run_cmd_nsb nettest -6 -D -s -k
 	run_cmd nettest -6 -D -d ${VRF} -r ${NSB_IP6}
 	log_test $? 0 "VRF client"
 
 	# negative test - should fail
 	log_start
 	run_cmd nettest -6 -D -d ${VRF} -r ${NSB_IP6}
 	log_test $? 1 "No server, VRF client"
 
 	log_start
-	run_cmd_nsb nettest -6 -D -s &
-	sleep 1
+	run_cmd_nsb nettest -6 -D -s -k
 	run_cmd nettest -6 -D -d ${NSA_DEV} -r ${NSB_IP6}
 	log_test $? 0 "Enslaved device client"
 
 	# negative test - should fail
 	log_start
@@ -3187,32 +3012,28 @@ ipv6_udp_vrf()
 	#
 	# local address tests
 	#
 	a=${NSA_IP6}
 	log_start
-	run_cmd nettest -6 -D -s -3 ${NSA_DEV} &
-	sleep 1
+	run_cmd nettest -6 -D -s -3 ${NSA_DEV} -k
 	run_cmd nettest -6 -D -d ${VRF} -r ${a}
 	log_test_addr ${a} $? 0 "Global server, VRF client, local conn"
 
 	#log_start
-	run_cmd nettest -6 -D -I ${VRF} -s -3 ${NSA_DEV} &
-	sleep 1
+	run_cmd nettest -6 -D -I ${VRF} -s -3 ${NSA_DEV} -k
 	run_cmd nettest -6 -D -d ${VRF} -r ${a}
 	log_test_addr ${a} $? 0 "VRF server, VRF client, local conn"
 
 
 	a=${VRF_IP6}
 	log_start
-	run_cmd nettest -6 -D -s -3 ${VRF} &
-	sleep 1
+	run_cmd nettest -6 -D -s -3 ${VRF} -k
 	run_cmd nettest -6 -D -d ${VRF} -r ${a}
 	log_test_addr ${a} $? 0 "Global server, VRF client, local conn"
 
 	log_start
-	run_cmd nettest -6 -D -I ${VRF} -s -3 ${VRF} &
-	sleep 1
+	run_cmd nettest -6 -D -I ${VRF} -s -3 ${VRF} -k
 	run_cmd nettest -6 -D -d ${VRF} -r ${a}
 	log_test_addr ${a} $? 0 "VRF server, VRF client, local conn"
 
 	# negative test - should fail
 	for a in ${NSA_IP6} ${VRF_IP6}
@@ -3223,64 +3044,57 @@ ipv6_udp_vrf()
 	done
 
 	# device to global IP
 	a=${NSA_IP6}
 	log_start
-	run_cmd nettest -6 -D -s -3 ${NSA_DEV} &
-	sleep 1
+	run_cmd nettest -6 -D -s -3 ${NSA_DEV} -k
 	run_cmd nettest -6 -D -d ${NSA_DEV} -r ${a}
 	log_test_addr ${a} $? 0 "Global server, device client, local conn"
 
 	log_start
-	run_cmd nettest -6 -D -I ${VRF} -s -3 ${NSA_DEV} &
-	sleep 1
+	run_cmd nettest -6 -D -I ${VRF} -s -3 ${NSA_DEV} -k
 	run_cmd nettest -6 -D -d ${NSA_DEV} -r ${a}
 	log_test_addr ${a} $? 0 "VRF server, device client, local conn"
 
 	log_start
-	run_cmd nettest -6 -D -I ${NSA_DEV} -s -3 ${NSA_DEV} &
-	sleep 1
+	run_cmd nettest -6 -D -I ${NSA_DEV} -s -3 ${NSA_DEV} -k
 	run_cmd nettest -6 -D -d ${VRF} -r ${a}
 	log_test_addr ${a} $? 0 "Device server, VRF client, local conn"
 
 	log_start
-	run_cmd nettest -6 -D -I ${NSA_DEV} -s -3 ${NSA_DEV} &
-	sleep 1
+	run_cmd nettest -6 -D -I ${NSA_DEV} -s -3 ${NSA_DEV} -k
 	run_cmd nettest -6 -D -d ${NSA_DEV} -r ${a}
 	log_test_addr ${a} $? 0 "Device server, device client, local conn"
 
 	log_start
 	run_cmd nettest -6 -D -d ${NSA_DEV} -r ${a}
 	log_test_addr ${a} $? 1 "No server, device client, local conn"
 
 
 	# link local addresses
 	log_start
-	run_cmd nettest -6 -D -s &
-	sleep 1
+	run_cmd nettest -6 -D -s -k
 	run_cmd_nsb nettest -6 -D -d ${NSB_DEV} -r ${NSA_LINKIP6}
 	log_test $? 0 "Global server, linklocal IP"
 
 	log_start
 	run_cmd_nsb nettest -6 -D -d ${NSB_DEV} -r ${NSA_LINKIP6}
 	log_test $? 1 "No server, linklocal IP"
 
 
 	log_start
-	run_cmd_nsb nettest -6 -D -s &
-	sleep 1
+	run_cmd_nsb nettest -6 -D -s -k
 	run_cmd nettest -6 -D -d ${NSA_DEV} -r ${NSB_LINKIP6}
 	log_test $? 0 "Enslaved device client, linklocal IP"
 
 	log_start
 	run_cmd nettest -6 -D -d ${NSA_DEV} -r ${NSB_LINKIP6}
 	log_test $? 1 "No server, device client, peer linklocal IP"
 
 
 	log_start
-	run_cmd nettest -6 -D -s &
-	sleep 1
+	run_cmd nettest -6 -D -s -k
 	run_cmd nettest -6 -D -d ${NSA_DEV} -r ${NSA_LINKIP6}
 	log_test $? 0 "Enslaved device client, local conn - linklocal IP"
 
 	log_start
 	run_cmd nettest -6 -D -d ${NSA_DEV} -r ${NSA_LINKIP6}
@@ -3288,12 +3102,11 @@ ipv6_udp_vrf()
 
 	# LLA to GUA
 	run_cmd_nsb ip -6 addr del ${NSB_IP6}/64 dev ${NSB_DEV}
 	run_cmd_nsb ip -6 ro add ${NSA_IP6}/128 dev ${NSB_DEV}
 	log_start
-	run_cmd nettest -6 -s -D &
-	sleep 1
+	run_cmd nettest -6 -s -D -k
 	run_cmd_nsb nettest -6 -D -r ${NSA_IP6}
 	log_test $? 0 "UDP in - LLA to GUA"
 
 	run_cmd_nsb ip -6 ro del ${NSA_IP6}/128 dev ${NSB_DEV}
 	run_cmd_nsb ip -6 addr add ${NSB_IP6}/64 dev ${NSB_DEV}
@@ -3443,12 +3256,11 @@ ipv6_rt()
 	# server tests
 	#
 	for a in ${NSA_IP6} ${VRF_IP6}
 	do
 		log_start
-		run_cmd nettest ${varg} -s &
-		sleep 1
+		run_cmd nettest ${varg} -s -k
 		run_cmd_nsb nettest ${varg} -r ${a} &
 		sleep 3
 		run_cmd ip link del ${VRF}
 		sleep 1
 		log_test_addr ${a} 0 0 "${desc}, global server"
@@ -3457,12 +3269,11 @@ ipv6_rt()
 	done
 
 	for a in ${NSA_IP6} ${VRF_IP6}
 	do
 		log_start
-		run_cmd nettest ${varg} -I ${VRF} -s &
-		sleep 1
+		run_cmd nettest ${varg} -I ${VRF} -s -k
 		run_cmd_nsb nettest ${varg} -r ${a} &
 		sleep 3
 		run_cmd ip link del ${VRF}
 		sleep 1
 		log_test_addr ${a} 0 0 "${desc}, VRF server"
@@ -3471,12 +3282,11 @@ ipv6_rt()
 	done
 
 	for a in ${NSA_IP6} ${VRF_IP6}
 	do
 		log_start
-		run_cmd nettest ${varg} -I ${NSA_DEV} -s &
-		sleep 1
+		run_cmd nettest ${varg} -I ${NSA_DEV} -s -k
 		run_cmd_nsb nettest ${varg} -r ${a} &
 		sleep 3
 		run_cmd ip link del ${VRF}
 		sleep 1
 		log_test_addr ${a} 0 0 "${desc}, enslaved device server"
@@ -3486,23 +3296,21 @@ ipv6_rt()
 
 	#
 	# client test
 	#
 	log_start
-	run_cmd_nsb nettest ${varg} -s &
-	sleep 1
+	run_cmd_nsb nettest ${varg} -s -k
 	run_cmd nettest ${varg} -d ${VRF} -r ${NSB_IP6} &
 	sleep 3
 	run_cmd ip link del ${VRF}
 	sleep 1
 	log_test  0 0 "${desc}, VRF client"
 
 	setup ${with_vrf}
 
 	log_start
-	run_cmd_nsb nettest ${varg} -s &
-	sleep 1
+	run_cmd_nsb nettest ${varg} -s -k
 	run_cmd nettest ${varg} -d ${NSA_DEV} -r ${NSB_IP6} &
 	sleep 3
 	run_cmd ip link del ${VRF}
 	sleep 1
 	log_test  0 0 "${desc}, enslaved device client"
@@ -3514,12 +3322,11 @@ ipv6_rt()
 	# local address tests
 	#
 	for a in ${NSA_IP6} ${VRF_IP6}
 	do
 		log_start
-		run_cmd nettest ${varg} -s &
-		sleep 1
+		run_cmd nettest ${varg} -s -k
 		run_cmd nettest ${varg} -d ${VRF} -r ${a} &
 		sleep 3
 		run_cmd ip link del ${VRF}
 		sleep 1
 		log_test_addr ${a} 0 0 "${desc}, global server, VRF client"
@@ -3528,12 +3335,11 @@ ipv6_rt()
 	done
 
 	for a in ${NSA_IP6} ${VRF_IP6}
 	do
 		log_start
-		run_cmd nettest ${varg} -I ${VRF} -s &
-		sleep 1
+		run_cmd nettest ${varg} -I ${VRF} -s -k
 		run_cmd nettest ${varg} -d ${VRF} -r ${a} &
 		sleep 3
 		run_cmd ip link del ${VRF}
 		sleep 1
 		log_test_addr ${a} 0 0 "${desc}, VRF server and client"
@@ -3541,34 +3347,31 @@ ipv6_rt()
 		setup ${with_vrf}
 	done
 
 	a=${NSA_IP6}
 	log_start
-	run_cmd nettest ${varg} -s &
-	sleep 1
+	run_cmd nettest ${varg} -s -k
 	run_cmd nettest ${varg} -d ${NSA_DEV} -r ${a} &
 	sleep 3
 	run_cmd ip link del ${VRF}
 	sleep 1
 	log_test_addr ${a} 0 0 "${desc}, global server, device client"
 
 	setup ${with_vrf}
 
 	log_start
-	run_cmd nettest ${varg} -I ${VRF} -s &
-	sleep 1
+	run_cmd nettest ${varg} -I ${VRF} -s -k
 	run_cmd nettest ${varg} -d ${NSA_DEV} -r ${a} &
 	sleep 3
 	run_cmd ip link del ${VRF}
 	sleep 1
 	log_test_addr ${a} 0 0 "${desc}, VRF server, device client"
 
 	setup ${with_vrf}
 
 	log_start
-	run_cmd nettest ${varg} -I ${NSA_DEV} -s &
-	sleep 1
+	run_cmd nettest ${varg} -I ${NSA_DEV} -s -k
 	run_cmd nettest ${varg} -d ${NSA_DEV} -r ${a} &
 	sleep 3
 	run_cmd ip link del ${VRF}
 	sleep 1
 	log_test_addr ${a} 0 0 "${desc}, device server, device client"
@@ -3622,12 +3425,11 @@ netfilter_tcp_reset()
 	local a
 
 	for a in ${NSA_IP} ${VRF_IP}
 	do
 		log_start
-		run_cmd nettest -s &
-		sleep 1
+		run_cmd nettest -s -k
 		run_cmd_nsb nettest -r ${a}
 		log_test_addr ${a} $? 1 "Global server, reject with TCP-reset on Rx"
 	done
 }
 
@@ -3640,12 +3442,11 @@ netfilter_icmp()
 	[ "${stype}" = "UDP" ] && arg="-D"
 
 	for a in ${NSA_IP} ${VRF_IP}
 	do
 		log_start
-		run_cmd nettest ${arg} -s &
-		sleep 1
+		run_cmd nettest ${arg} -s -k
 		run_cmd_nsb nettest ${arg} -r ${a}
 		log_test_addr ${a} $? 1 "Global ${stype} server, Rx reject icmp-port-unreach"
 	done
 }
 
@@ -3679,12 +3480,11 @@ netfilter_tcp6_reset()
 	local a
 
 	for a in ${NSA_IP6} ${VRF_IP6}
 	do
 		log_start
-		run_cmd nettest -6 -s &
-		sleep 1
+		run_cmd nettest -6 -s -k
 		run_cmd_nsb nettest -6 -r ${a}
 		log_test_addr ${a} $? 1 "Global server, reject with TCP-reset on Rx"
 	done
 }
 
@@ -3697,12 +3497,11 @@ netfilter_icmp6()
 	[ "${stype}" = "UDP" ] && arg="$arg -D"
 
 	for a in ${NSA_IP6} ${VRF_IP6}
 	do
 		log_start
-		run_cmd nettest -6 -s ${arg} &
-		sleep 1
+		run_cmd nettest -6 -s ${arg} -k
 		run_cmd_nsb nettest -6 ${arg} -r ${a}
 		log_test_addr ${a} $? 1 "Global ${stype} server, Rx reject icmp-port-unreach"
 	done
 }
 
@@ -3893,17 +3692,15 @@ use_case_snat_on_vrf()
 	local port="12345"
 
 	run_cmd iptables -t nat -A POSTROUTING -p tcp -m tcp --dport ${port} -j SNAT --to-source ${NSA_LO_IP} -o ${VRF}
 	run_cmd ip6tables -t nat -A POSTROUTING -p tcp -m tcp --dport ${port} -j SNAT --to-source ${NSA_LO_IP6} -o ${VRF}
 
-	run_cmd_nsb nettest -s -l ${NSB_IP} -p ${port} &
-	sleep 1
+	run_cmd_nsb nettest -s -l ${NSB_IP} -p ${port} -k
 	run_cmd nettest -d ${VRF} -r ${NSB_IP} -p ${port}
 	log_test $? 0 "IPv4 TCP connection over VRF with SNAT"
 
-	run_cmd_nsb nettest -6 -s -l ${NSB_IP6} -p ${port} &
-	sleep 1
+	run_cmd_nsb nettest -6 -s -l ${NSB_IP6} -p ${port} -k
 	run_cmd nettest -6 -d ${VRF} -r ${NSB_IP6} -p ${port}
 	log_test $? 0 "IPv6 TCP connection over VRF with SNAT"
 
 	# Cleanup
 	run_cmd iptables -t nat -D POSTROUTING -p tcp -m tcp --dport ${port} -j SNAT --to-source ${NSA_LO_IP} -o ${VRF}
-- 
2.25.1

