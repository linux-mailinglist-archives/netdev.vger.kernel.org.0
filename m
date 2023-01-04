Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78D4965D257
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 13:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239228AbjADMTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 07:19:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239147AbjADMSv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 07:18:51 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D42812AAD;
        Wed,  4 Jan 2023 04:18:50 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id m3so16510712wmq.0;
        Wed, 04 Jan 2023 04:18:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qonjO6fwHai+1vqnkGhP0g8VfUs0/wqGy9OAw4kIqb4=;
        b=RS07iq+61/f4WB2RJ/IP907ghaHVhjSJTN9NhLTv7M4ddgnJWsiiFTs3sUlkcM2nkh
         IDXfDue2wcHv7F3QQccwekQ85uK9Fu0lqwTc3wrTf+5iblki73ecJHQy/ffMx5bI70CW
         14vsAQ7YGKpdGrT6KF6fuzVDA3VyDYpalm65GwF/K2FcKlX9cqbcFS+kaBeYO51eFCLR
         a4YsqqCmIOH7cltFWKs6n15WgN4R0XwY1kfqUzMqVPBF4GfpkSbTY6QPJ1F6hU0Zk7dH
         Rwg7Tj0IYLTv2tc5Z1WqPK8W+cY2RatAuw6mrA/mmnWlKozAMY23WIeHyxeo3oLjcrDb
         nQFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qonjO6fwHai+1vqnkGhP0g8VfUs0/wqGy9OAw4kIqb4=;
        b=2mhv4Y3n3PdDGUK/RK/yQ7PztZck1QtIx/Q5ZidxIul2SlabCmkTihVtH4NDGFG+LR
         bcBqjx38QfReU6wFvblstt4oJk2JPxbrNL45fJKRzPiFhnGbnARaH/tDJP8cSi5xtQE/
         PqwH3KtSmqXODihcWmegIXlnpkxcBdwoFpNXm4/zkJU2FrUyT/mx8IIYHXpJN1fLj9Ti
         efhCsaO9pFFqSnlcct7uESQbI3wrRJPtmMd4z7AOfHPb2Vk1+hnQ8zz3TiObc5jPryzg
         L7p2tSBFUhjqEvTrb8vt8lbicFwvOkKonew6sGrZxNSe2145HgtUasNwhdnMFCx1wRaP
         2uxA==
X-Gm-Message-State: AFqh2kqxumOCBU6RF252UF5hMXh8iYNLdFq+Cp1mJ1GP1KFxeEeB6m22
        rxrOlFWGNPdf0ndFWpHYm7uD9fGQrlkNRqueJA8=
X-Google-Smtp-Source: AMrXdXuCOqsws+Vin9Izo/qDzalbWW1yvPBVvc7+OZ+C8VEablE/CQFdGAl4GFvFs6NOduBFYIYYgQ==
X-Received: by 2002:a05:600c:224b:b0:3cf:ae53:b1e0 with SMTP id a11-20020a05600c224b00b003cfae53b1e0mr34280782wmm.9.1672834728713;
        Wed, 04 Jan 2023 04:18:48 -0800 (PST)
Received: from localhost.localdomain (h-176-10-254-193.A165.priv.bahnhof.se. [176.10.254.193])
        by smtp.gmail.com with ESMTPSA id w12-20020a05600c474c00b003d04e4ed873sm35013749wmo.22.2023.01.04.04.18.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Jan 2023 04:18:48 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, tirthendu.sarkar@intel.com
Cc:     jonathan.lemon@gmail.com
Subject: [PATCH bpf-next v2 06/15] selftests/xsk: add debug option for creating netdevs
Date:   Wed,  4 Jan 2023 13:17:35 +0100
Message-Id: <20230104121744.2820-7-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230104121744.2820-1-magnus.karlsson@gmail.com>
References: <20230104121744.2820-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

And now the test cases can be debugged with gdb.

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

