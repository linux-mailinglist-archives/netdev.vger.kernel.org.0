Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 118384638F9
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245088AbhK3PGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 10:06:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244222AbhK3PAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 10:00:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBF49C08C5F1;
        Tue, 30 Nov 2021 06:52:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3551B81A58;
        Tue, 30 Nov 2021 14:52:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1019C8D185;
        Tue, 30 Nov 2021 14:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283959;
        bh=Eno3k74wAgLZnpkW6eivOSTbm1o2UlUFSDWadbqhAk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DpFNyki7zEVr00LIm5IlBYVMY8ira3EQs202+uztZmEoUlkUULZ4SN/JAU66oNoAA
         lZ0HjxpX1SnS8U1A5BNsTadPA7MOnpfWWAChppwDbyxhRKS0P4eBhU4FEQtt57DZIE
         somnfYvv2MuhfARSkNLTKBYwX4XH9b5sQq8NpeUfdsNybs8l9umPxF+4jrBFTZJmYL
         vUcqcuBe5T4M1Qe5SqxQ1EgXqFosVlN2vYy0MtQhNFUtJHO90Pdh/RCEciWNWHgT+8
         ieBpDBL55MUePN1vchOahcSPNIilsdiiplY26u7MhAgUjt7sdVpYo3sa67NioMJWMw
         pb5UVgQ7ajW+g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 24/25] net: ptp: add a definition for the UDP port for IEEE 1588 general messages
Date:   Tue, 30 Nov 2021 09:51:54 -0500
Message-Id: <20211130145156.946083-24-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145156.946083-1-sashal@kernel.org>
References: <20211130145156.946083-1-sashal@kernel.org>
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
index dd00fa41f7e79..58c4d51d76f0c 100644
--- a/include/linux/ptp_classify.h
+++ b/include/linux/ptp_classify.h
@@ -32,6 +32,7 @@
 #define PTP_CLASS_L4      (PTP_CLASS_IPV4 | PTP_CLASS_IPV6)
 
 #define PTP_EV_PORT 319
+#define PTP_GEN_PORT 320
 #define PTP_GEN_BIT 0x08 /* indicates general message, if set in message type */
 
 #define OFF_PTP_SOURCE_UUID	22 /* PTPv1 only */
-- 
2.33.0

