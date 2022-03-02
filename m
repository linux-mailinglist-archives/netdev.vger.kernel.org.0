Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 544764CA285
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 11:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241139AbiCBKxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 05:53:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241144AbiCBKxk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 05:53:40 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C3F8434A4;
        Wed,  2 Mar 2022 02:52:53 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 2225aJ6e005800;
        Wed, 2 Mar 2022 02:52:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=WkRmWOAwWTwynXg9XKkCoCA2XLxhcKbUkxumf0L7QTA=;
 b=AE0liRpAsCoBpPAjwYw/VfFQRX0oeNaQKed5L9A0rJQ+Pl2IFLUxSySbAHHV/fBLsB3Q
 NOwduzzqOFgteR/6KGoTOTXaqB0WYxr9f5cQK12eFLx4b3YV5tr7Z/09Yit8nzNrMvjT
 7PHuV2LHW7xZSMbsi5Nc+komae83puJSRGZRZD/rG3eXpHyVT/UzHzL+75Hie4udZZqx
 uMSCocERzf2TWUmXipp01XgelwP1DaTkrrstC/hsGSEkQdr9BhlaYAmHgPHNzvWw/pIJ
 jBuML83l4ZioZoLRy9ql2iiW+jNhScxo7Jr3lzeqlZNsaePWUUiv9ktau1VUId6bAwtf hQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3ej2k496jj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 02 Mar 2022 02:52:46 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Mar
 2022 02:52:44 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 2 Mar 2022 02:52:44 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 8461167387;
        Wed,  2 Mar 2022 02:52:44 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 222AqYP6008238;
        Wed, 2 Mar 2022 02:52:39 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 222AqNdv008237;
        Wed, 2 Mar 2022 02:52:23 -0800
From:   Manish Chopra <manishc@marvell.com>
To:     <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <palok@marvell.com>, <stable@vger.kernel.org>
Subject: [PATCH v2 net-next 1/2] qed: display VF trust config
Date:   Wed, 2 Mar 2022 02:52:21 -0800
Message-ID: <20220302105222.8201-1-manishc@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: wIVxiUJ9S0k6YM2PKnzHBg0wFm7OJ_K7
X-Proofpoint-GUID: wIVxiUJ9S0k6YM2PKnzHBg0wFm7OJ_K7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-02_01,2022-02-26_01,2022-02-23_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Driver does support SR-IOV VFs trust configuration but
it does not display it when queried via ip link utility.

Cc: stable@vger.kernel.org
Fixes: f990c82c385b ("qed*: Add support for ndo_set_vf_trust")
Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---

v1->v2: add Cc and Fixes tags for stable inclusion

 drivers/net/ethernet/qlogic/qed/qed_sriov.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_sriov.c b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
index 8ac38828ba45..c5abfb28cf3f 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sriov.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
@@ -4715,6 +4715,7 @@ static int qed_get_vf_config(struct qed_dev *cdev,
 	tx_rate = vf_info->tx_rate;
 	ivi->max_tx_rate = tx_rate ? tx_rate : link.speed;
 	ivi->min_tx_rate = qed_iov_get_vf_min_rate(hwfn, vf_id);
+	ivi->trusted = vf_info->is_trusted_request;

 	return 0;
 }
--
2.35.1.273.ge6ebfd0

