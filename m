Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6FC73BD1FF
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236626AbhGFLlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:41:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:47558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236914AbhGFLfr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8DC8613E1;
        Tue,  6 Jul 2021 11:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570681;
        bh=Ib7sEEJvwC0+6Ag2k1f1hUDsiJIxyQ/RFvMSMVofKl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XA3Z39AFHeCivVGrZKarau69ci9EcaoVs5yl/B8nPIQQiwaDb+y2fA3Ym4zKqTEpi
         cWV0FJ4PRbdlxQp0ls4pJp/9rNajFQpDb/xAyLeHWnXAQNG2SKXf3HESMXKxD4VPmj
         VxumAtCadcEx8eGrVgzuSpIDnfKGCs1Y42fALLUTTWZ8zLjUJHzKvUo15++SFdndfP
         z48pd8I0VKxRuQo1Ikpf39liGrKOIc9+5dwpQ9F08fJw6mkeBFGcyFyNOZK6m6wu3P
         1ULFz4Hwp0Ssq5dUCmXHptBd2zCII5qS5UZKX4GQorQ1bcaYpuaTga0sGhkaDY2iDA
         rXXk7p9gPT2Bg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yu Liu <yudiliu@google.com>, Miao-chen Chou <mcchou@chromium.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 122/137] Bluetooth: Fix the HCI to MGMT status conversion table
Date:   Tue,  6 Jul 2021 07:21:48 -0400
Message-Id: <20210706112203.2062605-122-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yu Liu <yudiliu@google.com>

[ Upstream commit 4ef36a52b0e47c80bbfd69c0cce61c7ae9f541ed ]

0x2B, 0x31 and 0x33 are reserved for future use but were not present in
the HCI to MGMT conversion table, this caused the conversion to be
incorrect for the HCI status code greater than 0x2A.

Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
Signed-off-by: Yu Liu <yudiliu@google.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 12d7b368b428..b20944e6d274 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -247,12 +247,15 @@ static const u8 mgmt_status_table[] = {
 	MGMT_STATUS_TIMEOUT,		/* Instant Passed */
 	MGMT_STATUS_NOT_SUPPORTED,	/* Pairing Not Supported */
 	MGMT_STATUS_FAILED,		/* Transaction Collision */
+	MGMT_STATUS_FAILED,		/* Reserved for future use */
 	MGMT_STATUS_INVALID_PARAMS,	/* Unacceptable Parameter */
 	MGMT_STATUS_REJECTED,		/* QoS Rejected */
 	MGMT_STATUS_NOT_SUPPORTED,	/* Classification Not Supported */
 	MGMT_STATUS_REJECTED,		/* Insufficient Security */
 	MGMT_STATUS_INVALID_PARAMS,	/* Parameter Out Of Range */
+	MGMT_STATUS_FAILED,		/* Reserved for future use */
 	MGMT_STATUS_BUSY,		/* Role Switch Pending */
+	MGMT_STATUS_FAILED,		/* Reserved for future use */
 	MGMT_STATUS_FAILED,		/* Slot Violation */
 	MGMT_STATUS_FAILED,		/* Role Switch Failed */
 	MGMT_STATUS_INVALID_PARAMS,	/* EIR Too Large */
-- 
2.30.2

