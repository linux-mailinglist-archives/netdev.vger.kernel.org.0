Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2632A1487CD
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 15:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392265AbgAXOVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 09:21:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:43918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392248AbgAXOVx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 09:21:53 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F385B22464;
        Fri, 24 Jan 2020 14:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875712;
        bh=FlUt13n0ZSjMNOryK1Y2wVF0CQSoGTmos4XtbuAoqrM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tQeEXF+QaA9MdEBTDKAVo9azfrixmDgtcva+ZswIJ3PQihmDJi/eTq/SYBLATf2+x
         pfiwbS/eDJRsVpbQ/WUD2PyOzrN8wiGF9HmPvMdt6a8fNL4HBJjCuPoiKwMFPDyrKB
         3l0dQ04CDu4Wl5VMuzehtqevIOW7VyaBTCJKFY6s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 28/32] net/wan/fsl_ucc_hdlc: fix out of bounds write on array utdm_info
Date:   Fri, 24 Jan 2020 09:21:15 -0500
Message-Id: <20200124142119.30484-28-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124142119.30484-1-sashal@kernel.org>
References: <20200124142119.30484-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit ddf420390526ede3b9ff559ac89f58cb59d9db2f ]

Array utdm_info is declared as an array of MAX_HDLC_NUM (4) elements
however up to UCC_MAX_NUM (8) elements are potentially being written
to it.  Currently we have an array out-of-bounds write error on the
last 4 elements. Fix this by making utdm_info UCC_MAX_NUM elements in
size.

Addresses-Coverity: ("Out-of-bounds write")
Fixes: c19b6d246a35 ("drivers/net: support hdlc function for QE-UCC")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/fsl_ucc_hdlc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wan/fsl_ucc_hdlc.c b/drivers/net/wan/fsl_ucc_hdlc.c
index 289dff262948d..571a1ff8f81f2 100644
--- a/drivers/net/wan/fsl_ucc_hdlc.c
+++ b/drivers/net/wan/fsl_ucc_hdlc.c
@@ -76,7 +76,7 @@ static struct ucc_tdm_info utdm_primary_info = {
 	},
 };
 
-static struct ucc_tdm_info utdm_info[MAX_HDLC_NUM];
+static struct ucc_tdm_info utdm_info[UCC_MAX_NUM];
 
 static int uhdlc_init(struct ucc_hdlc_private *priv)
 {
-- 
2.20.1

