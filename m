Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4752068B1
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 01:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387927AbgFWXx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 19:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387520AbgFWXxV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 19:53:21 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD92DC061573
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 16:53:20 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id s10so410997pgm.0
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 16:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oVqHSGOhKG+9IlvOmWEwYbNMnXG+ER7Ea8ZB6SrIrIE=;
        b=InWBSjVQuIh3Eivof/DucaViKu8S8abTxZWq5RHTqDqtDp4Oj+trbYiA8fXwnHir9p
         ymeGfeY14IMYpjref5Jc1qv2UcIiXyeGO6FODiVlP8kkNDp/nretd98Hal40xQYQ6OOc
         drkzu6qiUW8NMhYMe+yozkJGNdH3B7m/EXil4Dwp05tGWM2r2WcMzzDi6xRqhIrFL5es
         CP8R52ANnys0aNBmjTQQJv7QrLOQXCDPk6o9thS0YLCzexoLzWm9RwpxVllI/yhpXBCD
         OGLfTAyUMafvhDAYAhdu270PmNfYqsVEA6oIFYW1giDC+Br/+Y3tyRGGRBz3es2iUdSp
         uXqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oVqHSGOhKG+9IlvOmWEwYbNMnXG+ER7Ea8ZB6SrIrIE=;
        b=a8GNp9fRMX5LvqaOr+zNo+tCvSo2IukdgP3iGKGxJVAD7kTrgUQHkYrw2hDzp9VMOx
         CCB66wkqql+drcJC1VSG2KPJyKWUu2UwZ7QNlcwph6fWL7ngjkpRo5Ad9jcj11N5X/cr
         2YQjqJ68L+Vkcxmh1CdJPbjl410rtqo8qQEMSIpeOQjb1VwBGrKitpGPKXFURWL7X7ac
         yvawqEYodnfsB+kAIS0TsYTDetj/viQNxN8BEDXbF1mTdtr9noqsGSLIeo76j2a4HpEn
         s9FIobjOaj7qPsjeAB7jzE2YTGnsIL6e9greDeoRpKUEFLTif13d0E+8SgXcYAC1Axhd
         G23w==
X-Gm-Message-State: AOAM532jcsT9TilnkWefNpK79CPbK323sgPVoEm2DJTvfw15UjRvqdDC
        FIF9No5n8RdIG9JoTtuiEWcwAPRXdBs=
X-Google-Smtp-Source: ABdhPJyxnHU2IXFKCxWunoEtBdXSOBAOVobCi0m7DJCeYSyLk1c7wCgt0saOOXDHbIryPs6vYOSf4g==
X-Received: by 2002:aa7:9d01:: with SMTP id k1mr27862814pfp.6.1592956399938;
        Tue, 23 Jun 2020 16:53:19 -0700 (PDT)
Received: from hermes.corp.microsoft.com (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id 23sm18096521pfy.199.2020.06.23.16.53.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 16:53:19 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 3/5] testsuite: replace Enslave with Insert
Date:   Tue, 23 Jun 2020 16:53:05 -0700
Message-Id: <20200623235307.9216-4-stephen@networkplumber.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200623235307.9216-1-stephen@networkplumber.org>
References: <20200623235307.9216-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the term insert instead of enslave because it is
more descriptive and less offensive.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 testsuite/tests/bridge/vlan/show.t       | 4 ++--
 testsuite/tests/bridge/vlan/tunnelshow.t | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/testsuite/tests/bridge/vlan/show.t b/testsuite/tests/bridge/vlan/show.t
index 3def202226a4..1f0ac9a9870b 100755
--- a/testsuite/tests/bridge/vlan/show.t
+++ b/testsuite/tests/bridge/vlan/show.t
@@ -12,13 +12,13 @@ ts_ip "$0" "Add $BR_DEV bridge interface" link add $BR_DEV type bridge
 
 ts_ip "$0" "Add $VX0_DEV vxlan interface" \
 	link add $VX0_DEV type vxlan dstport 4789 external
-ts_ip "$0" "Enslave $VX0_DEV under $BR_DEV" \
+ts_ip "$0" "Insert $VX0_DEV under $BR_DEV" \
 	link set dev $VX0_DEV master $BR_DEV
 ts_bridge "$0" "Delete default vlan from $VX0_DEV" \
 	vlan del dev $VX0_DEV vid 1
 ts_ip "$0" "Add $VX1_DEV vxlan interface" \
 	link add $VX1_DEV type vxlan dstport 4790 external
-ts_ip "$0" "Enslave $VX1_DEV under $BR_DEV" \
+ts_ip "$0" "Insert $VX1_DEV under $BR_DEV" \
 	link set dev $VX1_DEV master $BR_DEV
 
 # Test that bridge ports without vlans do not appear in the output
diff --git a/testsuite/tests/bridge/vlan/tunnelshow.t b/testsuite/tests/bridge/vlan/tunnelshow.t
index 3e9c12a21a9c..2cec8d03b47a 100755
--- a/testsuite/tests/bridge/vlan/tunnelshow.t
+++ b/testsuite/tests/bridge/vlan/tunnelshow.t
@@ -11,7 +11,7 @@ ts_ip "$0" "Add $BR_DEV bridge interface" link add $BR_DEV type bridge
 
 ts_ip "$0" "Add $VX_DEV vxlan interface" \
 	link add $VX_DEV type vxlan dstport 4789 external
-ts_ip "$0" "Enslave $VX_DEV under $BR_DEV" \
+ts_ip "$0" "Insert $VX_DEV under $BR_DEV" \
 	link set dev $VX_DEV master $BR_DEV
 ts_ip "$0" "Set vlan_tunnel on $VX_DEV" \
 	link set dev $VX_DEV type bridge_slave vlan_tunnel on
-- 
2.26.2

