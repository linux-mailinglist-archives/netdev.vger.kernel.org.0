Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2986D4638E8
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243828AbhK3PGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 10:06:24 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51952 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238457AbhK3O5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 09:57:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE1E8B81A65;
        Tue, 30 Nov 2021 14:54:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D47E4C53FCD;
        Tue, 30 Nov 2021 14:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638284056;
        bh=Xo2gsgyROap7QOttu0XsXfMsEq+ZGFwbLGW3XIFrExc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GKB2DiVs/36Z0yP5inuNFIjw3mYtD3ds8/oWm3UmJImMuXT4JPr5KcCaaIaeGj/pz
         9ReYRQKnBbmpOMqolUiWYZrsrdvMchOmBfdcpWevrUyrmj+tef+kaZq03DfKDDmvg0
         iXQNkCv3LLSnC1e+t8ntET/z1nLTgSuA9JvkUSPaCtpeyLrc1oEmiltqj8RESe7YAU
         4FL2JoBf8fS5roE3aTHtvNm/lyVkzosp2YzHYlvAtWvsS7++81lD1XHOaJP/0KznMZ
         dai5ZLmdQ2Z9YzTu76VGCZScpMm9H96UKBoYXG3KeyW0YvvEP2dF/B+vzStsBAo0ap
         SgdDgGF7NGE6g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 8/9] net: ptp: add a definition for the UDP port for IEEE 1588 general messages
Date:   Tue, 30 Nov 2021 09:54:01 -0500
Message-Id: <20211130145402.947049-8-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145402.947049-1-sashal@kernel.org>
References: <20211130145402.947049-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit ec15baec3272bbec576f2ce7ce47765a8e9b7b1c ]

As opposed to event messages (Sync, PdelayReq etc) which require
timestamping, general messages (Announce, FollowUp etc) do not.
In PTP they are part of different streams of data.

IEEE 1588-2008 Annex D.2 "UDP port numbers" states that the UDP
destination port assigned by IANA is 319 for event messages, and 320 for
general messages. Yet the kernel seems to be missing the definition for
general messages. This patch adds it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ptp_classify.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/ptp_classify.h b/include/linux/ptp_classify.h
index a079656b614cd..c0a02aa7ed9bd 100644
--- a/include/linux/ptp_classify.h
+++ b/include/linux/ptp_classify.h
@@ -45,6 +45,7 @@
 #define PTP_CLASS_L4      (PTP_CLASS_IPV4 | PTP_CLASS_IPV6)
 
 #define PTP_EV_PORT 319
+#define PTP_GEN_PORT 320
 #define PTP_GEN_BIT 0x08 /* indicates general message, if set in message type */
 
 #define OFF_PTP_SOURCE_UUID	22 /* PTPv1 only */
-- 
2.33.0

