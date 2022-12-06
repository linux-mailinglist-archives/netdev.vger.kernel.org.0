Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33FDC643F65
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 10:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233748AbiLFJJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 04:09:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234227AbiLFJJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 04:09:16 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26D511EC4E;
        Tue,  6 Dec 2022 01:09:10 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id ay14-20020a05600c1e0e00b003cf6ab34b61so13799035wmb.2;
        Tue, 06 Dec 2022 01:09:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wogN9C7RWZNU/Wy3nByzxZkp+anhft0pVA7JBEmovgU=;
        b=GHQis90EL85d9JJwmm6l9HPfyEHuRZEZq0DzjVo4I8lt7CYhJRekmmpFafIUWBFQDq
         erY0lCmdeAufJL8Fr+94mag35WTOEW5x6yog3jd/I/N+w05vYzii4q5xqB5LBea1YAok
         Kb569aEdGGSFuQAG5IIHl6XKQ5Gdkf3TLOv17KKSMmJbphRVATryfecgm8opFYC4/YKi
         D0dqSovj9UJbw+dDUSyoSaDTf8/R/dlmkJ6ANyHLSERrlmaBGo8h0u/gvtyMw3+2g96M
         eArA0K0MtgrFEs3Oj2TJaDHBJO7LNVT4bB4IbMTX9+o098Xok4FjAQeyOUezb5bNleTc
         dISg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wogN9C7RWZNU/Wy3nByzxZkp+anhft0pVA7JBEmovgU=;
        b=G0zsEthvpQp+znBJ18Yuq08SKegY/doXSRygNzD5ToExsbm3pcpx7eYO9idYzcBY69
         Gye+3T9wJK6DDppHpYYoMHgDIsxmwC+QZUOAf2dOFFDdqaTJyKBEyAHWqRNnlx/VClFE
         Y0en0INXeyqqBsqyebCyXd637a9/5XZT4wNfzpg7I7HECxMOLre9foMYuHLNz6lPJLau
         BjOMbhTUmdCBfC4Fk573yNAWn+OiuEf8lWnTljX6BPVutqS8r3HDJiR1DJ0pAOFug4Uh
         5JQJr46+boHA9fncnPXaW/42pf5iD//VLDZpPpcSvdq7ETTsFG/Xg2WtfT77HKGxpdSZ
         nrsg==
X-Gm-Message-State: ANoB5plyNoBDzUXrLXGvmpTIvYokCQGVk+3EaAxsqyxKgUMqij2cYe2x
        vjreTqeRZTUTCICC+1fFr1I=
X-Google-Smtp-Source: AA0mqf4oTHykPtBaIgHKoKanSboKQMMVGuE7v0LfafQWY5CBJbC43Tepmh/rbFUHw0aWXi5w3ffNZA==
X-Received: by 2002:a05:600c:5014:b0:3cf:72d9:10b0 with SMTP id n20-20020a05600c501400b003cf72d910b0mr48693874wmr.26.1670317749392;
        Tue, 06 Dec 2022 01:09:09 -0800 (PST)
Received: from localhost.localdomain (c-5eea761b-74736162.cust.telenor.se. [94.234.118.27])
        by smtp.gmail.com with ESMTPSA id j23-20020a05600c1c1700b003cf57329221sm25065690wms.14.2022.12.06.01.09.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Dec 2022 01:09:08 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org
Cc:     jonathan.lemon@gmail.com
Subject: [PATCH bpf-next 06/15] selftests/xsk: add debug option for creating netdevs
Date:   Tue,  6 Dec 2022 10:08:17 +0100
Message-Id: <20221206090826.2957-7-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221206090826.2957-1-magnus.karlsson@gmail.com>
References: <20221206090826.2957-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Add a new option to the test_xsk.sh script that only creates the two
veth netdevs and the extra namespace, then exits without running any
tests. The failed test can then be executed in the debugger without
having to create the netdevs and namespace manually. For ease-of-use,
the veth netdevs to use are printed so they can be copied into the
debugger.

Here is an example how to use it:

> sudo ./test_xsk.sh -d

veth10 veth11

> gdb xskxceiver

In gdb:

run -i veth10 -i veth11

And now the test cases can be dugged with gdb.

If you want to debug the test suite on a real NIC in loopback mode,
there is no need to use this feature as you already know the netdev of
your NIC.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/test_xsk.sh | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_xsk.sh b/tools/testing/selftests/bpf/test_xsk.sh
index d821fd098504..cb315d85148b 100755
--- a/tools/testing/selftests/bpf/test_xsk.sh
+++ b/tools/testing/selftests/bpf/test_xsk.sh
@@ -74,6 +74,9 @@
 # Run and dump packet contents:
 #   sudo ./test_xsk.sh -D
 #
+# Set up veth interfaces and leave them up so xskxceiver can be launched in a debugger:
+#   sudo ./test_xsk.sh -d
+#
 # Run test suite for physical device in loopback mode
 #   sudo ./test_xsk.sh -i IFACE
 
@@ -81,11 +84,12 @@
 
 ETH=""
 
-while getopts "vDi:" flag
+while getopts "vDi:d" flag
 do
 	case "${flag}" in
 		v) verbose=1;;
 		D) dump_pkts=1;;
+		d) debug=1;;
 		i) ETH=${OPTARG};;
 	esac
 done
@@ -174,6 +178,11 @@ statusList=()
 
 TEST_NAME="XSK_SELFTESTS_${VETH0}_SOFTIRQ"
 
+if [[ $debug -eq 1 ]]; then
+    echo "-i" ${VETH0} "-i" ${VETH1},${NS1}
+    exit
+fi
+
 exec_xskxceiver
 
 if [ -z $ETH ]; then
-- 
2.34.1

