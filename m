Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8E962951B
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 11:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238231AbiKOKAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 05:00:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238170AbiKOJ74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 04:59:56 -0500
Received: from mail-ed1-x54a.google.com (mail-ed1-x54a.google.com [IPv6:2a00:1450:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA6CD12635
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 01:59:47 -0800 (PST)
Received: by mail-ed1-x54a.google.com with SMTP id f20-20020a0564021e9400b00461ea0ce17cso9718314edf.16
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 01:59:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FTQ23B2MPYm/xTCyBXCoyWZGN4LbfmWfydRT6HS/aY8=;
        b=ckIN8YvHQE/sxX5Hmrd1QGUyr2FepfDNVEZWfKxjly1gmUVG4CDit+7LWz73pM4TBr
         yvVT3x8eN7QsPk3m1pO04qYdjqB8edoCFZgFBoE5ukKEPH+bg8uW4z6QuIs3P2wQ+IeB
         637/xPvL4mHvv3uinpHrbDj6VGwG/pCbxnilGMeyyFeFZm+FdJKCS/9rTfrxSVh+xBCe
         5Ve6j6tpiKrkRuhaf906Nv3H2lZAedxF7XOjoJCBz7DlKVR3tbwxbR7om8EX8Q930YsB
         JhmmKpsRPMjh0tLvDtcT/B+DXqFFZ6XZu3ZoRXoWlnNcVUMLtq+A/5DWeHQLgrSJwnYk
         ZtMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FTQ23B2MPYm/xTCyBXCoyWZGN4LbfmWfydRT6HS/aY8=;
        b=Yo4vNQZGLCd86H8ftgx3LqELUktv3SannR6azIjKX1e5KTjgbhQ5kG3TpSTtJv6L3d
         RY8HyBEScR4Cmbvu56fjWqZyqLFiBpx9EzLT91eDHu1ylLpN8issSKFuYYgJT9ddHBCQ
         SE3LVoOj6CyBn9OQ5d9WjbBaY3329xEPrWhGO4SyT/GJELRMHB5/Rs5YG9uT3Pyca+Sq
         jznwSkmUV0lhBEUE9gty/cpSdikprq1z3TKBOjwCs2Rj2uxgrMgwXK4LyQkfSO+VDy7J
         YWkb+uTzU3G2Zu7vapH9OQM/4MezX4mZRzeegCSnZdcklJWjq+ka5audG6nm/ey/Aary
         lqWw==
X-Gm-Message-State: ANoB5pnOjoL3DBvSPh1+lBJNNL/pXm1tsdw97B1nDkTYTLtT3rSzMTPM
        cLspstjYFkWesf45T4hNCyjoO7oQuhUs
X-Google-Smtp-Source: AA0mqf5uRSwXRfQLVhEMT2E3nAMlxn3xkDDTPzRQ6zTyXc0I1wyTeTAJ3m2vV2mq97Dp38YCQGyKUu/gZFCZ
X-Received: from dvyukov-desk.muc.corp.google.com ([2a00:79e0:9c:201:45dd:dca2:ac94:b937])
 (user=dvyukov job=sendgmr) by 2002:a05:6402:1859:b0:468:51b0:295 with SMTP id
 v25-20020a056402185900b0046851b00295mr803137edy.319.1668506386210; Tue, 15
 Nov 2022 01:59:46 -0800 (PST)
Date:   Tue, 15 Nov 2022 10:59:41 +0100
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221115095941.787250-1-dvyukov@google.com>
Subject: [PATCH net-next] NFC: nci: Extend virtual NCI deinit test
From:   Dmitry Vyukov <dvyukov@google.com>
To:     bongsu.jeon@samsung.com, krzysztof.kozlowski@linaro.org,
        netdev@vger.kernel.org
Cc:     syzkaller@googlegroups.com, Dmitry Vyukov <dvyukov@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend the test to check the scenario when NCI core tries to send data
to already closed device to ensure that nothing bad happens.

Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Bongsu Jeon <bongsu.jeon@samsung.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
---
 tools/testing/selftests/nci/nci_dev.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/selftests/nci/nci_dev.c b/tools/testing/selftests/nci/nci_dev.c
index 162c41e9bcae8..272958a4ad102 100644
--- a/tools/testing/selftests/nci/nci_dev.c
+++ b/tools/testing/selftests/nci/nci_dev.c
@@ -888,6 +888,16 @@ TEST_F(NCI, deinit)
 			   &msg);
 	ASSERT_EQ(rc, 0);
 	EXPECT_EQ(get_dev_enable_state(&msg), 0);
+
+	// Test that operations that normally send packets to the driver
+	// don't cause issues when the device is already closed.
+	// Note: the send of NFC_CMD_DEV_UP itself still succeeds it's just
+	// that the device won't actually be up.
+	close(self->virtual_nci_fd);
+	self->virtual_nci_fd = -1;
+	rc = send_cmd_with_idx(self->sd, self->fid, self->pid,
+			       NFC_CMD_DEV_UP, self->dev_idex);
+	EXPECT_EQ(rc, 0);
 }
 
 TEST_HARNESS_MAIN

base-commit: f12ed9c04804eec4f1819097a0fd0b4800adac2f
prerequisite-patch-id: 214c5357c652cee65ee803d0f45f4b15cfcc9861
-- 
2.38.1.431.g37b22c650d-goog

