Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B03103D4E47
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 17:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbhGYOlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 10:41:53 -0400
Received: from smtpbg587.qq.com ([113.96.223.105]:54020 "EHLO smtpbg587.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231239AbhGYOlh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Jul 2021 10:41:37 -0400
X-Greylist: delayed 436 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Jul 2021 10:41:18 EDT
X-QQ-mid: bizesmtp54t1627226040t2bpwom7
Received: from ficus.lan (unknown [171.223.99.141])
        by esmtp6.qq.com (ESMTP) with 
        id ; Sun, 25 Jul 2021 23:13:59 +0800 (CST)
X-QQ-SSF: 0100000000800090B000B00A0000000
X-QQ-FEAT: xoP0AY8I4TJUmwcRsbE7pBWYXEm4E2ijZJadpRWTUKwv3GB4OvT4zWwB4WNah
        RCL9yYnMHWKajf7vx8uiNVbc5w6RznxVIiYqdDQHh1fQ9YHCwUt46mFBctLWsFNz1jqRq+V
        taYkKksWdNFwOvyS06cICYt0xwRhruS4SF3rDmE25+m61XIisDWvhAcwoZsoA7O3zwwaCmq
        O+nFo0i91VyzlY9us+mG+sN8U7VSoRQ/zt1m334sIZq1ctS76PzC9BNWECvbD+B6JZTWwi7
        eau7HSUZW9mHepAPdQC0iPI332wKrEX8mV6xfMB3Zq2tAQxrBm7uD9EThLuaSWnjns2IOjG
        rC96F3D5gNF5wVRASM=
X-QQ-GoodBg: 0
From:   Jason Wang <wangborong@cdjrlc.com>
To:     aelior@marvell.com
Cc:     GR-everest-linux-l2@marvell.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Wang <wangborong@cdjrlc.com>
Subject: [PATCH] net: qed: remove unneeded return variables
Date:   Sun, 25 Jul 2021 23:13:53 +0800
Message-Id: <20210725151353.109586-1-wangborong@cdjrlc.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some return variables are never changed until function returned.
These variables are unneeded for their functions. Therefore, the
unneeded return variables can be removed safely by returning their
initial values.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
---
 drivers/net/ethernet/qlogic/qed/qed_dcbx.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_dcbx.c b/drivers/net/ethernet/qlogic/qed/qed_dcbx.c
index e81dd34a3cac..dc93ddea8906 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dcbx.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dcbx.c
@@ -741,7 +741,6 @@ static int
 qed_dcbx_read_local_lldp_mib(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 {
 	struct qed_dcbx_mib_meta_data data;
-	int rc = 0;
 
 	memset(&data, 0, sizeof(data));
 	data.addr = p_hwfn->mcp_info->port_addr + offsetof(struct public_port,
@@ -750,7 +749,7 @@ qed_dcbx_read_local_lldp_mib(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 	data.size = sizeof(struct lldp_config_params_s);
 	qed_memcpy_from(p_hwfn, p_ptt, data.lldp_local, data.addr, data.size);
 
-	return rc;
+	return 0;
 }
 
 static int
@@ -810,7 +809,6 @@ static int
 qed_dcbx_read_local_mib(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 {
 	struct qed_dcbx_mib_meta_data data;
-	int rc = 0;
 
 	memset(&data, 0, sizeof(data));
 	data.addr = p_hwfn->mcp_info->port_addr +
@@ -819,7 +817,7 @@ qed_dcbx_read_local_mib(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 	data.size = sizeof(struct dcbx_local_params);
 	qed_memcpy_from(p_hwfn, p_ptt, data.local_admin, data.addr, data.size);
 
-	return rc;
+	return 0;
 }
 
 static int qed_dcbx_read_mib(struct qed_hwfn *p_hwfn,
-- 
2.32.0

