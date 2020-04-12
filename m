Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9571A6127
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 01:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgDLXvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Apr 2020 19:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:43046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbgDLXvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Apr 2020 19:51:19 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9491C0A3BE0
        for <netdev@vger.kernel.org>; Sun, 12 Apr 2020 16:51:19 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id k1so1397819wrx.4
        for <netdev@vger.kernel.org>; Sun, 12 Apr 2020 16:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3vVs1E7UHTn0qFWpHVjJfj3Yg5EEEdEauL9jrtLL/FE=;
        b=OBnBT803wg2FVKuPO+d+4QlHJgISSd9xq6rCczrflZGOZGzLhuV1kKu9aeobyP9Yy/
         M8pWgD+D4Jw5dIa7uw6CgqMu5Y8FPAKvlu4OCY7coCqT6Itcolxju0jh+7OUCK6Jf1Ax
         0Rw823LTgd0viHeYJUh83m1m/qt5Z5zo/2C6IerGxYiy58V+AbQPIzwVuWBtugyCaW4L
         C0OF2vkINsTdJE7xloRm6dazoW1Ak08dQTVeRLGT3Lqr18UZzHLj/YS+w29Fy6Rlf07J
         Mr0dAjiar0ddrV8WIAn0FFpCiwzyNgnKeQj8HB0fZI1OMgsenVP0iynRhPq4/is8rfy8
         vb4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3vVs1E7UHTn0qFWpHVjJfj3Yg5EEEdEauL9jrtLL/FE=;
        b=SfxQQTjIP/6EqSpvHJ6w+V42fWz/pLQL1EnZhAuw9bwvdu6xY19RSO2n+c8WzpjAvB
         z5jGB8lU5jXRc5rWpOMjYOSnibiQEVGEu4iF6JcHb8o2PPbs5pqMrX/gKwzcLaN5csxC
         BqzyrBJhVzRb19Y6MSoPzlhrHEDmpXg2YtQiAOhz1A4wtct9b2c+cYXlB58Ci7c80YTm
         rn7dlRfTxD1/7t85nr3lu6Np96x0r2EwHlb8vzHKtVHGUZI9l09x1cRAKypSOtczyaAY
         RyxsfncxBdKF0XC7+8hp4PbCGn38PMM5Nkv5T3FIieokasVjmVCt6IR9ABrs30hk3AsD
         bWpQ==
X-Gm-Message-State: AGi0PubLRDeS3JlTu3hHUuTXpNJAg+zUvxYtnP9yBfbMA2U5msGfnFJQ
        9xcIBHeWnJSWdtJcfOfHNtzAXewx
X-Google-Smtp-Source: APiQypJGp8IQH6BcoCUFRnF88C0JUdEqzzW9qnZ9UVO21h0CX2Q7zGwGSYbvH8HcrnZSIVyMcpaIvQ==
X-Received: by 2002:adf:97d0:: with SMTP id t16mr16148043wrb.343.1586735477943;
        Sun, 12 Apr 2020 16:51:17 -0700 (PDT)
Received: from localhost ([2a01:e35:2f01:a61:fc49:14b:88c:2a9c])
        by smtp.gmail.com with ESMTPSA id w83sm12690804wmb.37.2020.04.12.16.51.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Apr 2020 16:51:16 -0700 (PDT)
From:   roucaries.bastien@gmail.com
X-Google-Original-From: rouca@debian.org
To:     netdev@vger.kernel.org
Cc:     sergei.shtylyov@cogentembedded.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        =?UTF-8?q?Bastien=20Roucari=C3=A8s?= <rouca@debian.org>
Subject: [PATCH 6/6] State of bridge STP port are now case insensitive
Date:   Mon, 13 Apr 2020 01:50:38 +0200
Message-Id: <20200412235038.377692-7-rouca@debian.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200412235038.377692-1-rouca@debian.org>
References: <20200405134859.57232-1-rouca@debian.org>
 <20200412235038.377692-1-rouca@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bastien Roucariès <rouca@debian.org>

Improve use experience

Signed-off-by: Bastien Roucariès <rouca@debian.org>
---
 bridge/link.c     |  2 +-
 man/man8/bridge.8 | 16 ++++++++--------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/bridge/link.c b/bridge/link.c
index 074edf00..3bc7af20 100644
--- a/bridge/link.c
+++ b/bridge/link.c
@@ -378,7 +378,7 @@ static int brlink_modify(int argc, char **argv)
 			state = strtol(*argv, &endptr, 10);
 			if (!(**argv != '\0' && *endptr == '\0')) {
 				for (state = 0; state < nstates; state++)
-					if (strcmp(port_states[state], *argv) == 0)
+					if (strcasecmp(port_states[state], *argv) == 0)
 						break;
 				if (state == nstates) {
 					fprintf(stderr,
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index ff6a5cc9..5efbd466 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -293,29 +293,29 @@ droot port selectio algorithms.
 
 .TP
 .BI state " STATE "
-the operation state of the port. Except state 0 (disabled),
+the operation state of the port. Except state 0 (disable STP or BPDU filter feature),
 this is primarily used by user space STP/RSTP
-implementation. One may enter a lowercased port state name, or one of the
+implementation. One may enter port state name (case insensitive), or one of the
 numbers below. Negative inputs are ignored, and unrecognized names return an
 error.
 
 .B 0
-- port is in
+- port is in STP
 .B DISABLED
-state. Make this port completely inactive. This is also called
+state. Make this port completely inactive for STP. This is also called
 BPDU filter and could be used to disable STP on an untrusted port, like
 a leaf virtual devices.
 .sp
 
 .B 1
-- STP
+- port is in STP
 .B LISTENING
 state. Only valid if STP is enabled on the bridge. In this
 state the port listens for STP BPDUs and drops all other traffic frames.
 .sp
 
 .B 2
-- STP
+- port is in STP
 .B LEARNING
 state. Only valid if STP is enabled on the bridge. In this
 state the port will accept traffic only for the purpose of updating MAC
@@ -323,13 +323,13 @@ address tables.
 .sp
 
 .B 3
-- STP
+- port is in STP
 .B FORWARDING
 state. Port is fully active.
 .sp
 
 .B 4
-- STP
+- port is in STP
 .B BLOCKING
 state. Only valid if STP is enabled on the bridge. This state
 is used during the STP election process. In this state, port will only process
-- 
2.25.1

