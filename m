Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 817463EA729
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 17:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237871AbhHLPI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 11:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238375AbhHLPIz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 11:08:55 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AEACC0613D9
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 08:08:30 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id n12so7021886plf.4
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 08:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jqs4O3v7cLO7mth15lIh47ggmIf8qUdBLrOa/zfjQ7M=;
        b=Qo5mq7jeValO8oUpdJxN/rE298JUfAii4Fcmnvym/3rdP1Zc9bDIgeSYb0OnQbcKwV
         ZaRq15YmHDn+Pf234AIV2SnEDNWcS2x0wEwkETDVU8bIE0nY8QAc5HFcDECjP+k8/S8n
         pIxIThZO/JsK4nynYhuZPvuTykqZm8CdeE9ozzE20FCQVQqnzEwJj3mFnDO58sQQBJWJ
         I9pnBoIhpA0aaphIleszIDbcKOKgNK4e4rjbt6K6syqIS+KP1m1zAzUWqOyS1aATZ+sH
         0WSh0NUuLk2qBEUB3SiFzP822zrm8UnwTVjBTudvs/Xp/MeC4gHa/Xy3dY2aW0JG/x9A
         eLaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jqs4O3v7cLO7mth15lIh47ggmIf8qUdBLrOa/zfjQ7M=;
        b=H2BMJUtqiGkjtRzwEkQKkR8INTEeAQwGT0/dI2rEkusd7mxzPzBsRH6yYivhuHbJdW
         JeSbJGKv6C+vXeo6OvkabF71CUhPhVQ1ujRTacT9BjIbZlFcGIyOkrgyamBJvHJVkcDW
         myfFWYLxHZYindYuHq6ztnX6iUAyHk2MaXV0fR8TJDxl+EkkyKTRBTN3aR05DSJ4gGbX
         DtzzP6KS/2+1Bd+CuEqLsgqubXgBgphVCi1sMDcMDPGVOzdDd+11fYvXmj762C6VneSD
         EULE+XOnkzs0NzlG49PKvUbVeyjdx8HfYkzOOMe4csupTJA2+C00Na/n3j/gMYY6JHkd
         CEDQ==
X-Gm-Message-State: AOAM530ZupeFe3nJc32I6W1//1xvHg/QeIxe25CS6kNCjBI6J+5rfNGm
        8EGOBWnpCcuObMqaTXFmLzs=
X-Google-Smtp-Source: ABdhPJx2ju29vjOiNr5sw2dwY47xJr+WmK9tX/0f3zNzPNXpc4+7Wa4j+ip5mlgbie5hXkF+2mTHtQ==
X-Received: by 2002:a17:902:b193:b029:11a:a179:453a with SMTP id s19-20020a170902b193b029011aa179453amr3832717plr.69.1628780909846;
        Thu, 12 Aug 2021 08:08:29 -0700 (PDT)
Received: from MASTER.. ([58.76.185.115])
        by smtp.gmail.com with ESMTPSA id w130sm3914261pfd.118.2021.08.12.08.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 08:08:29 -0700 (PDT)
From:   Juhee Kang <claudiajkang@gmail.com>
To:     hawk@kernel.org, brouer@redhat.com, davem@davemloft.net,
        toke@redhat.com, toke@toke.dk
Cc:     netdev@vger.kernel.org, Juhee Kang <claudiajkang@gmail.com>
Subject: [PATCH net-next 2/2] samples: pktgen: add missing IPv6 option to pktgen scripts
Date:   Fri, 13 Aug 2021 00:08:13 +0900
Message-Id: <20210812150813.53124-3-claudiajkang@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210812150813.53124-1-claudiajkang@gmail.com>
References: <20210812150813.53124-1-claudiajkang@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, "sample04" and "sample05" are not working properly when
running with an IPv6 option("-6"). The commit 0f06a6787e05 ("samples:
Add an IPv6 "-6" option to the pktgen scripts") has omitted the addition
of this option at "sample04" and "sample05".

In order to support IPv6 option, this commit adds logic related to IPv6
option.

Fixes: 0f06a6787e05 ("samples: Add an IPv6 "-6" option to the pktgen scripts")

Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
---
 samples/pktgen/pktgen_sample04_many_flows.sh      | 12 +++++++-----
 samples/pktgen/pktgen_sample05_flow_per_thread.sh | 12 +++++++-----
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/samples/pktgen/pktgen_sample04_many_flows.sh b/samples/pktgen/pktgen_sample04_many_flows.sh
index 56c5f5af350f..cff51f861506 100755
--- a/samples/pktgen/pktgen_sample04_many_flows.sh
+++ b/samples/pktgen/pktgen_sample04_many_flows.sh
@@ -13,13 +13,15 @@ root_check_run_with_sudo "$@"
 # Parameter parsing via include
 source ${basedir}/parameters.sh
 # Set some default params, if they didn't get set
-[ -z "$DEST_IP" ]   && DEST_IP="198.18.0.42"
+if [ -z "$DEST_IP" ]; then
+    [ -z "$IP6" ] && DEST_IP="198.18.0.42" || DEST_IP="FD00::1"
+fi
 [ -z "$DST_MAC" ]   && DST_MAC="90:e2:ba:ff:ff:ff"
 [ -z "$CLONE_SKB" ] && CLONE_SKB="0"
 [ -z "$COUNT" ]     && COUNT="0" # Zero means indefinitely
 if [ -n "$DEST_IP" ]; then
-    validate_addr $DEST_IP
-    read -r DST_MIN DST_MAX <<< $(parse_addr $DEST_IP)
+    validate_addr${IP6} $DEST_IP
+    read -r DST_MIN DST_MAX <<< $(parse_addr${IP6} $DEST_IP)
 fi
 if [ -n "$DST_PORT" ]; then
     read -r UDP_DST_MIN UDP_DST_MAX <<< $(parse_ports $DST_PORT)
@@ -62,8 +64,8 @@ for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do

     # Single destination
     pg_set $dev "dst_mac $DST_MAC"
-    pg_set $dev "dst_min $DST_MIN"
-    pg_set $dev "dst_max $DST_MAX"
+    pg_set $dev "dst${IP6}_min $DST_MIN"
+    pg_set $dev "dst${IP6}_max $DST_MAX"

     if [ -n "$DST_PORT" ]; then
 	# Single destination port or random port range
diff --git a/samples/pktgen/pktgen_sample05_flow_per_thread.sh b/samples/pktgen/pktgen_sample05_flow_per_thread.sh
index 6e0effabca59..3578d0aa4ac5 100755
--- a/samples/pktgen/pktgen_sample05_flow_per_thread.sh
+++ b/samples/pktgen/pktgen_sample05_flow_per_thread.sh
@@ -17,14 +17,16 @@ root_check_run_with_sudo "$@"
 # Parameter parsing via include
 source ${basedir}/parameters.sh
 # Set some default params, if they didn't get set
-[ -z "$DEST_IP" ]   && DEST_IP="198.18.0.42"
+if [ -z "$DEST_IP" ]; then
+    [ -z "$IP6" ] && DEST_IP="198.18.0.42" || DEST_IP="FD00::1"
+fi
 [ -z "$DST_MAC" ]   && DST_MAC="90:e2:ba:ff:ff:ff"
 [ -z "$CLONE_SKB" ] && CLONE_SKB="0"
 [ -z "$BURST" ]     && BURST=32
 [ -z "$COUNT" ]     && COUNT="0" # Zero means indefinitely
 if [ -n "$DEST_IP" ]; then
-    validate_addr $DEST_IP
-    read -r DST_MIN DST_MAX <<< $(parse_addr $DEST_IP)
+    validate_addr${IP6} $DEST_IP
+    read -r DST_MIN DST_MAX <<< $(parse_addr${IP6} $DEST_IP)
 fi
 if [ -n "$DST_PORT" ]; then
     read -r UDP_DST_MIN UDP_DST_MAX <<< $(parse_ports $DST_PORT)
@@ -52,8 +54,8 @@ for ((thread = $F_THREAD; thread <= $L_THREAD; thread++)); do

     # Single destination
     pg_set $dev "dst_mac $DST_MAC"
-    pg_set $dev "dst_min $DST_MIN"
-    pg_set $dev "dst_max $DST_MAX"
+    pg_set $dev "dst${IP6}_min $DST_MIN"
+    pg_set $dev "dst${IP6}_max $DST_MAX"

     if [ -n "$DST_PORT" ]; then
 	# Single destination port or random port range
--
2.30.2

