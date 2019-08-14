Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3898D727
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 17:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbfHNP0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 11:26:09 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41712 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726585AbfHNP0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 11:26:09 -0400
Received: by mail-wr1-f65.google.com with SMTP id j16so9225275wrr.8
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 08:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PzzvNs4PF4Zxlh6j6DtCEByuXelmlmCNLf8ywQl2K+U=;
        b=byhz4zfRWexcYchSfh6h+yqtwvtZN1aiKnPSyRQP+jEBRQVgcfKKypluYORHsDTOBa
         Y3PPFRFtx05kz//NE/6GaUZYne+5rnBX2Y5GlRXvHPMJsasgb9GkYCnXqnVz0NvAcXkG
         O+jsVA0/NlxRASKxSniRMWPOr9mYuTK2M8msm9aakBmShHem4YCejue58kxvP67YOOE0
         DZJlkYf9zCyZhOIDdtr21sOrIVyiS/HiMr9oI0UU4cV9U1ADsin6W40WnMdXB3S9TuBO
         MPnTwqv8wbh9qwWt3Gm+ZmltqxracexAdVb8s0RbocFVq9ejgLbX9LEoEmwwGYMP7Hx9
         aBUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PzzvNs4PF4Zxlh6j6DtCEByuXelmlmCNLf8ywQl2K+U=;
        b=hRo7Xdu5E+mtyo+dbxG8jD5L8FzyLGzRlAL8HiyKJqeRuAxucRSVIpKgcrf29Q5EZ0
         GzShmnudQMe2nDFtnp+aZNSjzofN3SPiwgNIQO6/pN3TLZU9SLFk2IF1g7TXaEjWzsVl
         ksRN3LNZfxRLBYFwCZjxYS2zEaI7B5zflQlyur+TFDDsTHSDvNWT3xfj5fdLXk0YXUKM
         T7z0H1CRo4oRXmF2Opn4LwJDnJtya6ZvPZE1gKTpIdWgcMgVHyCpLTT3+CmoxqklI72R
         J3v4zmTFlnkLVulJnnvkFzzWvMmAGEkjuXT0AsHT4B1G98P3DT9H0NkKZv/L54ySixGI
         N0dA==
X-Gm-Message-State: APjAAAVS9t0E3PVY/6itam1O8X88H+DCJ6nQZmxZZ//iARSHrIHKqdvS
        4l7LZ+uQrAVCu7Q8IaS5uRia0cYLcaI=
X-Google-Smtp-Source: APXvYqyVzUrOwC+IgzUsYj3rWWQsCB8LXgYFqdu9tzbqXJb4Lxm1vhaj5cURZv/hdDvM8N941rn3rQ==
X-Received: by 2002:adf:eb52:: with SMTP id u18mr272408wrn.174.1565796366816;
        Wed, 14 Aug 2019 08:26:06 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id z8sm9581wmi.7.2019.08.14.08.26.06
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 14 Aug 2019 08:26:06 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        mlxsw@mellanox.com
Subject: [patch net-next v2 1/2] selftests: net: push jq workaround into separate helper
Date:   Wed, 14 Aug 2019 17:26:03 +0200
Message-Id: <20190814152604.6385-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190814152604.6385-1-jiri@resnulli.us>
References: <20190814152604.6385-1-jiri@resnulli.us>
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
v1->v2:
-new patch
---
 tools/testing/selftests/net/forwarding/lib.sh   | 16 ++++++++++++++++
 .../selftests/net/forwarding/tc_common.sh       | 17 ++++-------------
 2 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 9385dc971269..9d78841efef6 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -250,6 +250,22 @@ setup_wait()
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
+	# workaround the jq bug which causes jq to return 0 in case input is ""
+	ret=$?
+	if [[ $ret -ne 0 ]]; then
+		return $ret
+	fi
+	echo $output | jq -r -e "$jq_exp"
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

