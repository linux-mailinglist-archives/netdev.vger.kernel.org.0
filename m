Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6164FBD6B
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 15:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346596AbiDKNlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 09:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346591AbiDKNlM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 09:41:12 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B561C2251A
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 06:38:58 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id b21so26707932lfb.5
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 06:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=8qjm9wLjph4c7kZ9jfundVdGQ8PpnhtD4gzzvkqBGsw=;
        b=o88XnttxQH1grWq83aF2OyYu/OVtodv2bsFld55tVD1cJ7zPXGbYuugXvLyv7S+paa
         w0T63kWHbWtByKFbWpp1T7hfyoGLYImSlR+vYNnTiDx2UYFt/91qCMm3I/6XbtZgNuZo
         KQf3aXihjAxbi5uLLb0AEs63L+PANYYdNk0sAdnZCVm9cWq50FBqGHxSb0hAYyViqc/r
         a0YxqHm8hwzcwD6Vw/R33J0quvtAa0l4q2EeuW5scdocpR8W7MQtgM/U/zebSyh4nUXB
         AI0f2RRWbVh9JOQLwldxiBlXthrz5wUHe/pRZ3NY2yji2tiI5xNpSH5wKQ2qTWNTYvpp
         gU6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=8qjm9wLjph4c7kZ9jfundVdGQ8PpnhtD4gzzvkqBGsw=;
        b=2YczwTiAgjwERqdVKr9vi983fMYow7i/w2MxNaS2Qq7/iJY+TEBgg7K3Vn9NubhtVe
         5MwWRftnnxxPn49R1YoefRmGgl8EcYUojjf9Sgtu+K/SuDEC3XTQD0nqtFBS02bEeWwo
         hhA999zzMkHVKRwyraoBBSCi+oupANj0ecRBz2CKSULYpRZQdHSKGbhBM4i5wROj5m3E
         w11LrT6CFqibqBZQTz2vreuLDQ/9RIYhSSlUs0QKl0NVR9GMnudduDCnS0ENUlaHCJnS
         ybo0AYznx5zgql6QrNKcQu6HhEyEawlHU11iyochm4VI5j7jkEEoX52ecctUw9IJTzSU
         MFdg==
X-Gm-Message-State: AOAM533MVnL0lXBqQVo870LlqSff1CIhYgSnKDR23NtvxJubV2pte91A
        XirSMh/9DtDgH03F6aHXKSZxKWIXHSplIQkM
X-Google-Smtp-Source: ABdhPJwEOg1f2YmvXtYOnsziJ1SVjzWn4o3G3iIGap8DrSs5yqqUzx3XzMrdEHCraarWTUKt67rZ1w==
X-Received: by 2002:a05:6512:24a:b0:46b:ad98:88db with SMTP id b10-20020a056512024a00b0046bad9888dbmr1816704lfo.304.1649684336982;
        Mon, 11 Apr 2022 06:38:56 -0700 (PDT)
Received: from wbg.labs.westermo.se (h-158-174-22-128.NA.cust.bahnhof.se. [158.174.22.128])
        by smtp.gmail.com with ESMTPSA id p12-20020a056512138c00b0044833f1cd85sm3336847lfa.62.2022.04.11.06.38.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 06:38:56 -0700 (PDT)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joachim Wiberg <troglobit@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH RFC net-next 05/13] selftests: forwarding: add TCPDUMP_EXTRA_FLAGS to lib.sh
Date:   Mon, 11 Apr 2022 15:38:29 +0200
Message-Id: <20220411133837.318876-6-troglobit@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220411133837.318876-1-troglobit@gmail.com>
References: <20220411133837.318876-1-troglobit@gmail.com>
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For some use-cases we may want to change the tcpdump flags used in
tcpdump_start().  For instance, observing interfaces without the PROMISC
flag, e.g. to see what's really being forwarded to the bridge interface.

Signed-off-by: Joachim Wiberg <troglobit@gmail.com>
---
 tools/testing/selftests/net/forwarding/lib.sh | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)
 mode change 100644 => 100755 tools/testing/selftests/net/forwarding/lib.sh

diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
old mode 100644
new mode 100755
index 664b9ecaf228..00cdcab7accf
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -1369,7 +1369,13 @@ tcpdump_start()
 		capuser="-Z $SUDO_USER"
 	fi
 
-	$ns_cmd tcpdump -e -n -Q in -i $if_name \
+	if [ -z $TCPDUMP_EXTRA_FLAGS ]; then
+		extra_flags=""
+	else
+		extra_flags="$TCPDUMP_EXTRA_FLAGS"
+	fi
+
+	$ns_cmd tcpdump $extra_flags -e -n -Q in -i $if_name \
 		-s 65535 -B 32768 $capuser -w $capfile > "$capout" 2>&1 &
 	cappid=$!
 
-- 
2.25.1

