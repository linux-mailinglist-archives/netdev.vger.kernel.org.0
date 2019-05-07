Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9B7315B6A
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 07:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728896AbfEGFx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 01:53:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:58382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727702AbfEGFih (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 01:38:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C5C0205ED;
        Tue,  7 May 2019 05:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207517;
        bh=DJuL2ejuLOji21RwsU2T4+wD8kSXrsBUmaAO2NFzV3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cZ1t9xw+MlDxv1T+U0ycok+z1SiHenfh663J6MGyXrP59TS0CLiCkx2UTOPbm5JB9
         1LjRKEDE2wM0gf8L5dkSXMp5S8uif7lyYECJnQqirUA/9mYogBDCOWHMdYyNurnfZg
         8exa8vH+vSvD9a46mS0mXvEVstfeo6feBcaAZeQk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 09/95] mac80211: Increase MAX_MSG_LEN
Date:   Tue,  7 May 2019 01:36:58 -0400
Message-Id: <20190507053826.31622-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053826.31622-1-sashal@kernel.org>
References: <20190507053826.31622-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

[ Upstream commit 78be2d21cc1cd3069c6138dcfecec62583130171 ]

Looks that 100 chars isn't enough for messages, as we keep getting
warnings popping from different places due to message shortening.
Instead of trying to shorten the prints, just increase the buffer size.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/trace_msg.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/trace_msg.h b/net/mac80211/trace_msg.h
index 366b9e6f043e..40141df09f25 100644
--- a/net/mac80211/trace_msg.h
+++ b/net/mac80211/trace_msg.h
@@ -1,4 +1,9 @@
 /* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Portions of this file
+ * Copyright (C) 2019 Intel Corporation
+ */
+
 #ifdef CONFIG_MAC80211_MESSAGE_TRACING
 
 #if !defined(__MAC80211_MSG_DRIVER_TRACE) || defined(TRACE_HEADER_MULTI_READ)
@@ -11,7 +16,7 @@
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM mac80211_msg
 
-#define MAX_MSG_LEN	100
+#define MAX_MSG_LEN	120
 
 DECLARE_EVENT_CLASS(mac80211_msg_event,
 	TP_PROTO(struct va_format *vaf),
-- 
2.20.1

