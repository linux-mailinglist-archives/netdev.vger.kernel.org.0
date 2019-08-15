Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2F488ED27
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 15:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732431AbfHONmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 09:42:35 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33807 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732423AbfHONme (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 09:42:34 -0400
Received: by mail-wm1-f67.google.com with SMTP id e8so1054086wme.1
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 06:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tAzzVVZmRA3f54OeTuZNMQXmuAAjzsltCYmnHv7IDZ4=;
        b=0c4cHB+F+/gaiTXpQIIAL0QCvUWtCwEpFzlZmS0NuKY7LZi+RXb3Ylps75k6IDLTAe
         x0an6hOZs42/UA2dTC4f6A+aL5Pbt50+ONE5pBYBHdpf4I4JkGIMeaZlBcRlVS23D61W
         cLAisd5NMQycAWdceHMCGJ6VwiAHAjVvdGxeMc7FQqocxX24/Xy/2aJFFXqz6HEMPYrN
         A9igG1lwX6jgSYpovMwmOKn/FKBN48XC7OJhmJQkO9uFBfaA3x1RXLbd1lw+UKbrB6MH
         bdwq/0BDOs1mAwgvstcl4nbOXMlrc4OoDlHrJIezUM1/SNUKauuSSb6P5jOoUsvVsUIt
         VQaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tAzzVVZmRA3f54OeTuZNMQXmuAAjzsltCYmnHv7IDZ4=;
        b=sQBpD1/ZMpv8T5Kyam51OTtBGPvQmbVMap4KDbEv3BJezNeFG+Df6fs44T5pW2pgU4
         gpFiLtEFHpPDVVwASHJDJwp1pzcbkQFQkKCJKoE1m7nCKjflC2AZ3T+QzKXB1yYNeuOP
         muH73g+DrTHCv6zehP2joZNPcIIyI6bF+ng466jVrTD+XeHhYLhaTr42YAwGxiSGiBXs
         FbajABo19VIB9X6KMQIr5eh4ftzfRjufdgpFJ4chlf4a54QiuoGp19vIldYuZL6z7dzj
         8WICq/wZ0SexBzYf6HC9cvh/PrigINAdxgUtNyFAOgaTIwhOUnKkWN4qg92Z3c90AsZR
         D6qA==
X-Gm-Message-State: APjAAAW3mLzWDn0GFZxxwiYuLKwCEDVWD7dejYMza9AZY2dxBXSFUwAr
        6Sw+X7fM4uG06xlPrxqr87aUOoAYVUo=
X-Google-Smtp-Source: APXvYqxC2qlgMXT/fQSb0jFbwo7a4oShkewCAuafP+72klwI7OM42p3/jMN/RBhpCOkpPemFlyY02g==
X-Received: by 2002:a05:600c:21d3:: with SMTP id x19mr2802791wmj.45.1565876552219;
        Thu, 15 Aug 2019 06:42:32 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id x6sm1377849wmf.6.2019.08.15.06.42.31
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 15 Aug 2019 06:42:31 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        mlxsw@mellanox.com
Subject: [patch net-next v3 1/2] selftests: net: push jq workaround into separate helper
Date:   Thu, 15 Aug 2019 15:42:28 +0200
Message-Id: <20190815134229.8884-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190815134229.8884-1-jiri@resnulli.us>
References: <20190815134229.8884-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Push the jq return value workaround code into a separate helper so it
could be used by the rest of the code.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v2->v3:
-remove -e jq option and rather check for empty output and return error
v1->v2:
-new patch
---
 tools/testing/selftests/net/forwarding/lib.sh | 19 +++++++++++++++++++
 .../selftests/net/forwarding/tc_common.sh     | 17 ++++-------------
 2 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 9385dc971269..85c587a03c8a 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -250,6 +250,25 @@ setup_wait()
 	sleep $WAIT_TIME
 }
 
+cmd_jq()
+{
+	local cmd=$1
+	local jq_exp=$2
+	local ret
+	local output
+
+	output="$($cmd)"
+	# it the command fails, return error right away
+	ret=$?
+	if [[ $ret -ne 0 ]]; then
+		return $ret
+	fi
+	output=$(echo $output | jq -r "$jq_exp")
+	echo $output
+	# return success only in case of non-empty output
+	[ ! -z "$output" ]
+}
+
 lldpad_app_wait_set()
 {
 	local dev=$1; shift
diff --git a/tools/testing/selftests/net/forwarding/tc_common.sh b/tools/testing/selftests/net/forwarding/tc_common.sh
index 9d3b64a2a264..315e934358d4 100644
--- a/tools/testing/selftests/net/forwarding/tc_common.sh
+++ b/tools/testing/selftests/net/forwarding/tc_common.sh
@@ -8,18 +8,9 @@ tc_check_packets()
 	local id=$1
 	local handle=$2
 	local count=$3
-	local ret
 
-	output="$(tc -j -s filter show $id)"
-	# workaround the jq bug which causes jq to return 0 in case input is ""
-	ret=$?
-	if [[ $ret -ne 0 ]]; then
-		return $ret
-	fi
-	echo $output | \
-		jq -e ".[] \
-		| select(.options.handle == $handle) \
-		| select(.options.actions[0].stats.packets == $count)" \
-		&> /dev/null
-	return $?
+	cmd_jq "tc -j -s filter show $id" \
+	       ".[] | select(.options.handle == $handle) | \
+	              select(.options.actions[0].stats.packets == $count)" \
+	       &> /dev/null
 }
-- 
2.21.0

