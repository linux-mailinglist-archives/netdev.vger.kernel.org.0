Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B201106402
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 07:15:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729684AbfKVGOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 01:14:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:51720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729657AbfKVGOM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 01:14:12 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5320E20707;
        Fri, 22 Nov 2019 06:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574403252;
        bh=64j4seBtU2BgtBMuT/TmYWkYcog1hhKB+5Xq/rBFpZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z+pr2cBr9UqPthk0KE1FNvSjkyYZ/tzggWWeNdWda7xodV8FAM59p5bjmehPNwJzI
         2PPANcK92pN9Zm49QOyfPQRGR7/7z558ASmpepg5MyOo6gvwY9lP6o87bXLGe5M/H2
         Ag2uBOusWt0q8ViCHEyqjdTzxEh6kQDVw9TU10mA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bert Kenward <bkenward@solarflare.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 61/68] sfc: initialise found bitmap in efx_ef10_mtd_probe
Date:   Fri, 22 Nov 2019 01:12:54 -0500
Message-Id: <20191122061301.4947-60-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122061301.4947-1-sashal@kernel.org>
References: <20191122061301.4947-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bert Kenward <bkenward@solarflare.com>

[ Upstream commit c65285428b6e7797f1bb063f33b0ae7e93397b7b ]

The bitmap of found partitions in efx_ef10_mtd_probe was not
initialised, causing partitions to be suppressed based off whatever
value was in the bitmap at the start.

Fixes: 3366463513f5 ("sfc: suppress duplicate nvmem partition types in efx_ef10_mtd_probe")
Signed-off-by: Bert Kenward <bkenward@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/ef10.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 79a1031c3ef77..6dcd436e6e323 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -4499,7 +4499,7 @@ static int efx_ef10_mtd_probe_partition(struct efx_nic *efx,
 static int efx_ef10_mtd_probe(struct efx_nic *efx)
 {
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_NVRAM_PARTITIONS_OUT_LENMAX);
-	DECLARE_BITMAP(found, EF10_NVRAM_PARTITION_COUNT);
+	DECLARE_BITMAP(found, EF10_NVRAM_PARTITION_COUNT) = { 0 };
 	struct efx_mcdi_mtd_partition *parts;
 	size_t outlen, n_parts_total, i, n_parts;
 	unsigned int type;
-- 
2.20.1

