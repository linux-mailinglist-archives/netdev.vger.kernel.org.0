Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB904C79C1
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 21:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbiB1UI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 15:08:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbiB1UIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 15:08:24 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9CED583B8
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 12:07:33 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21SB9nvd026791;
        Mon, 28 Feb 2022 12:07:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=tRfqVz/Qr9sw3iJntM3vuyS2g6V6PwSDAFv2AIHQFiQ=;
 b=aQqgSsnYkiEkyeBSiaRJSODwAwjRFXJzPVaR6e5Oc3O4iZZQhcnHrQv9I6w90/xP3Mbs
 rsJcQImPh/fyXk0rISYf516D4gY92Gw+mnB1nPm6lDIpLdtXHkoyV3Motkh1Ir0EANiH
 lNhlsAYulxe3l3crUrDg/ImnydpURLiPyXH84gi0InMk/Vf6zR4wULwX/K8l8ncmCHoR
 GoROrH0qJL5OE/LzCjKCXg+1FSrfIhd93l2GiIMqP6dfT6Uop0UIKt+Z5El8WEi/UfPE
 0za59XKs47EQXuanoxNqqMfmyMpNtwoT/WRnYBli5a6ELneF6Q+i/kGXHpTGtZKcYdRg ww== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3eghebmc0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 28 Feb 2022 12:07:26 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 28 Feb
 2022 12:07:25 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 28 Feb 2022 12:07:25 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id C956E3F704C;
        Mon, 28 Feb 2022 12:07:25 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 21SK7KSP004349;
        Mon, 28 Feb 2022 12:07:20 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 21SK7A42004348;
        Mon, 28 Feb 2022 12:07:10 -0800
From:   Manish Chopra <manishc@marvell.com>
To:     <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <aelior@marvell.com>, <palok@marvell.com>
Subject: [PATCH net-next 1/2] qed: display VF trust config
Date:   Mon, 28 Feb 2022 12:07:07 -0800
Message-ID: <20220228200708.4312-1-manishc@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: 27-axhPgAQYdsJZSg9NbIsmRNvWYuvaY
X-Proofpoint-ORIG-GUID: 27-axhPgAQYdsJZSg9NbIsmRNvWYuvaY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-28_09,2022-02-26_01,2022-02-23_01
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

Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---
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

