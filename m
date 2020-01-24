Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAD10148848
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 15:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405215AbgAXOVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 09:21:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:42554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405194AbgAXOVH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 09:21:07 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C915121556;
        Fri, 24 Jan 2020 14:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875666;
        bh=vKij6Y45XIhgwMlTLXauI4SVPVx4+gAtVsS62H2QVBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sj/OND7mgNv+Je8BiaI0goUas3xCXWW/i77NdglGiEeGOzZvDDdCCdw0L+Zn1Sm8f
         zCG1fbQORU5wZkSLzbyopm6CABG1hAxSoFpAegzJoaxJzqB8M3XxhgZ9dYlR0hI634
         GRS66lsRIIdCuFDgsxZew/ZpVfnQ6fN3TCzZ/G0k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 46/56] net/wan/fsl_ucc_hdlc: fix out of bounds write on array utdm_info
Date:   Fri, 24 Jan 2020 09:20:02 -0500
Message-Id: <20200124142012.29752-46-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124142012.29752-1-sashal@kernel.org>
References: <20200124142012.29752-1-sashal@kernel.org>
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
index 0212f576a838c..daeab33f623e7 100644
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

