Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D02C83658ED
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 14:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232087AbhDTM2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 08:28:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40607 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbhDTM2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 08:28:05 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lYpTX-000086-3y; Tue, 20 Apr 2021 12:27:31 +0000
From:   Colin King <colin.king@canonical.com>
To:     "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net: mana: remove redundant initialization of variable err
Date:   Tue, 20 Apr 2021 13:27:30 +0100
Message-Id: <20210420122730.379835-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable err is being initialized with a value that is
never read and it is being updated later with a new value.  The
initialization is redundant and can be removed

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/microsoft/mana/hw_channel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index 462bc577692a..0cf0322702ed 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -55,7 +55,7 @@ static void mana_hwc_handle_resp(struct hw_channel_context *hwc, u32 resp_len,
 				 const struct gdma_resp_hdr *resp_msg)
 {
 	struct hwc_caller_ctx *ctx;
-	int err = -EPROTO;
+	int err;
 
 	if (!test_bit(resp_msg->response.hwc_msg_id,
 		      hwc->inflight_msg_res.map)) {
-- 
2.30.2

