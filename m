Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C35B2463841
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 15:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243851AbhK3O65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 09:58:57 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50812 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238321AbhK3O5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 09:57:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2A21B81A42;
        Tue, 30 Nov 2021 14:53:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E4BC53FC7;
        Tue, 30 Nov 2021 14:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638284018;
        bh=Xo2gsgyROap7QOttu0XsXfMsEq+ZGFwbLGW3XIFrExc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lePRmLYW1els49i4ZYQehK2JTmavy16s3iO9nn7ALrhHcn/bhjEru4I7+3u/9I2D0
         IVJ7DNQgHcXdjmdLqDm8nxW8u94uwdusrE5JY5TbRpenpuxCDzESt4EVaC+UCQguAn
         D8MhpRqLovWwVwmlhTDrRllekIDYkxm8s7LzUshGs/sOOtLHSTOr+49+ImeZOaGb7C
         MRa0FFDVQSxkBilJaIZb2q/WRKmOtigvg7TlxKtzqlJKnPJZx0qYwaKMeWV9Xh8A9T
         0A1VQCt6m75nv/u43aoBWAjBivyjv4xnL3e72vMaY/CyxN02t1lLMURgi8id4e5Wjr
         qBKufgvv8+e4Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 13/14] net: ptp: add a definition for the UDP port for IEEE 1588 general messages
Date:   Tue, 30 Nov 2021 09:53:14 -0500
Message-Id: <20211130145317.946676-13-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145317.946676-1-sashal@kernel.org>
References: <20211130145317.946676-1-sashal@kernel.org>
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

