Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E330D6657C9
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 10:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232284AbjAKJjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 04:39:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231797AbjAKJh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 04:37:27 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60930271F;
        Wed, 11 Jan 2023 01:36:11 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id az7so14416193wrb.5;
        Wed, 11 Jan 2023 01:36:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UDCZ3v5xjfPza65hFSrOf+b/rATi2tno/cf7eEa6NwU=;
        b=Ngi+/FCQ49wfwRA/eGPotA2wlgSv+PH5DpVzVvxwNSW7qlLOrdh2KWUWaQqthYzcr3
         313js8e27JVU+eKfB3+EgS0Tl+pa91DEDVZTckhz3cFMjmsm5TlQf39bg1ss4OerYI6I
         VuvB16sPyCx00F1Vkhm3/7kYFD6WZ8K///qdtPgsf/veCKQCWbyvQZqbeQYqTgasGZA+
         oEbC6qBrTeYAwzdqD3wimXPoV75D49l1SEhFXHYV7SrvcdBVrjpCiVVXcDLcNQEVtXHH
         GlhJ60HQEeLkWYWsv8iCzecl9qyL6OQmY9E8uScORJd40gmVgQBMMWyOsem36OrYXUEF
         X6rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UDCZ3v5xjfPza65hFSrOf+b/rATi2tno/cf7eEa6NwU=;
        b=VNzvY5FWHHXMaKhMyXrwYqRYa8sos2sQYZzMEc7NKreSFZxqFXhWOXf/hkN2oKMKp0
         Wl/hZP6H4Qt8hV43foMvyviCT/WZTlTE5TZx4HGPETV/SKlXVquy3BzXCNSUkPiWaHBd
         DKOAAZKjysz0O8sCKBHvNHmsKo+uxr+lbeX34fcWuXU5ruLVAVwQShAmFzFJFLJj3Ij2
         YzbsnqRyu0OMT5y2jabmVLVh2Fz2JKrgFXQ70PzxO6pz/QW/maL3yhyAkQmPHRqrTsnu
         rX6yLmgzIIoAJ69EBWxfQaO8jJ5OfmjdDpLwF144iSdIy6abpPytOZla/tvIJWUrHPTW
         3SMQ==
X-Gm-Message-State: AFqh2kq7IZB9eWiSmsqvJyDstkocBBMpgq4VB8ITcAN7kcOJqL9pPmHO
        3T3tBN9KeEAv7g59L+NRruc=
X-Google-Smtp-Source: AMrXdXvinzLGHJLv+JAVrKanE1y2XIhNmvldV2NJh1wsrVdmQY5Ek3MOciKmuUFzGruK6T7sjXH7aw==
X-Received: by 2002:adf:f5c6:0:b0:29f:ebd1:6a5 with SMTP id k6-20020adff5c6000000b0029febd106a5mr20281265wrp.14.1673429769841;
        Wed, 11 Jan 2023 01:36:09 -0800 (PST)
Received: from localhost.localdomain (h-176-10-254-193.A165.priv.bahnhof.se. [176.10.254.193])
        by smtp.gmail.com with ESMTPSA id c18-20020adffb52000000b0025e86026866sm15553069wrs.0.2023.01.11.01.36.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Jan 2023 01:36:09 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, tirthendu.sarkar@intel.com
Cc:     jonathan.lemon@gmail.com
Subject: [PATCH bpf-next v3 06/15] selftests/xsk: add debug option for creating netdevs
Date:   Wed, 11 Jan 2023 10:35:17 +0100
Message-Id: <20230111093526.11682-7-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230111093526.11682-1-magnus.karlsson@gmail.com>
References: <20230111093526.11682-1-magnus.karlsson@gmail.com>
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
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
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

