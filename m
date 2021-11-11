Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEF7044DBA6
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 19:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234076AbhKKSkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 13:40:20 -0500
Received: from relay03.th.seeweb.it ([5.144.164.164]:50263 "EHLO
        relay03.th.seeweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233705AbhKKSkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 13:40:19 -0500
Received: from localhost.localdomain (83.6.165.118.neoplus.adsl.tpnet.pl [83.6.165.118])
        by m-r1.th.seeweb.it (Postfix) with ESMTPA id 79FFC20215;
        Thu, 11 Nov 2021 19:37:28 +0100 (CET)
From:   Konrad Dybcio <konrad.dybcio@somainline.org>
To:     ~postmarketos/upstreaming@lists.sr.ht
Cc:     martin.botka@somainline.org,
        angelogioacchino.delregno@somainline.org,
        marijn.suijten@somainline.org, jamipkettunen@somainline.org,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Alex Elder <elder@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] net/ipa: ipa_resource: Fix wrong for loop range
Date:   Thu, 11 Nov 2021 19:37:24 +0100
Message-Id: <20211111183724.593478-1-konrad.dybcio@somainline.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The source group count was mistakenly assigned to both dst and src loops.
Fix it to make IPA probe and work again.

Fixes: 4fd704b3608a ("net: ipa: record number of groups in data")
Acked-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
Reviewed-by: Marijn Suijten <marijn.suijten@somainline.org>
Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
---
Changes since v1:
- Add a "Fixes:" tag, R-b, A-b and fix up the commit message
 drivers/net/ipa/ipa_resource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ipa/ipa_resource.c b/drivers/net/ipa/ipa_resource.c
index e3da95d69409..06cec7199382 100644
--- a/drivers/net/ipa/ipa_resource.c
+++ b/drivers/net/ipa/ipa_resource.c
@@ -52,7 +52,7 @@ static bool ipa_resource_limits_valid(struct ipa *ipa,
 				return false;
 	}
 
-	group_count = data->rsrc_group_src_count;
+	group_count = data->rsrc_group_dst_count;
 	if (!group_count || group_count > IPA_RESOURCE_GROUP_MAX)
 		return false;
 
-- 
2.33.0

