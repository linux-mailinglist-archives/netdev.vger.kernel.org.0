Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 986F4AB707
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 13:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731471AbfIFLTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 07:19:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37425 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbfIFLTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 07:19:46 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1i6CHI-0005FY-0W; Fri, 06 Sep 2019 11:19:44 +0000
From:   Colin King <colin.king@canonical.com>
To:     Sathya Perla <sathya.perla@broadcom.com>,
        Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] be2net: make two arrays static const, makes object smaller
Date:   Fri,  6 Sep 2019 12:19:43 +0100
Message-Id: <20190906111943.5285-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Don't populate the arrays on the stack but instead make them
static const. Makes the object code smaller by 281 bytes.

Before:
   text	   data	    bss	    dec	    hex	filename
  87553	   5672	      0	  93225	  16c29	benet/be_cmds.o

After:
   text	   data	    bss	    dec	    hex	filename
  87112	   5832	      0	  92944	  16b10	benet/be_cmds.o

(gcc version 9.2.1, amd64)

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/emulex/benet/be_cmds.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_cmds.c b/drivers/net/ethernet/emulex/benet/be_cmds.c
index 323976c811e9..701c12c9e033 100644
--- a/drivers/net/ethernet/emulex/benet/be_cmds.c
+++ b/drivers/net/ethernet/emulex/benet/be_cmds.c
@@ -2756,7 +2756,7 @@ static int be_flash_BEx(struct be_adapter *adapter,
 	bool crc_match;
 	const u8 *p;
 
-	struct flash_comp gen3_flash_types[] = {
+	static const struct flash_comp gen3_flash_types[] = {
 		{ BE3_ISCSI_PRIMARY_IMAGE_START, OPTYPE_ISCSI_ACTIVE,
 			BE3_COMP_MAX_SIZE, IMAGE_FIRMWARE_ISCSI},
 		{ BE3_REDBOOT_START, OPTYPE_REDBOOT,
@@ -2779,7 +2779,7 @@ static int be_flash_BEx(struct be_adapter *adapter,
 			BE3_PHY_FW_COMP_MAX_SIZE, IMAGE_FIRMWARE_PHY}
 	};
 
-	struct flash_comp gen2_flash_types[] = {
+	static const struct flash_comp gen2_flash_types[] = {
 		{ BE2_ISCSI_PRIMARY_IMAGE_START, OPTYPE_ISCSI_ACTIVE,
 			BE2_COMP_MAX_SIZE, IMAGE_FIRMWARE_ISCSI},
 		{ BE2_REDBOOT_START, OPTYPE_REDBOOT,
-- 
2.20.1

