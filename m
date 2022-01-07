Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1A9487314
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 07:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231961AbiAGGav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 01:30:51 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:43572 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231627AbiAGGau (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 01:30:50 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 2072WuTe025962;
        Thu, 6 Jan 2022 22:30:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=F4J/o7aAm2fvjr6s0GaM6Lg3QuMQha1o8wNVps3VtCg=;
 b=h3+F6SERR1nbsFpcyNHCvkEZ6Jkmk+zhqfZcPlbrxR79ltr7VZ7z0rRF/opIUrqBLe6a
 NOmUkFDwDryrszlJm+fl7wGFNc8RbHt32UeqtD8ID9UiCqNLM24b3H4aaJOgZtzJL1h7
 txoaZfkkFVnKcPUpc4qmsWc5Fg8LIbKikfFeyA+jGW4Ix/JegpLLlzwp8hNSzBV3u3Kq
 MIFjfZPJZ84MsDLtnqyT+pJt39xdBXn05M1UrRb9ZydTRD8/1qNQH2xJg4kAJWxRE5H1
 leF2nBTdXkK8aOL+iyPo1iBTt3JcpPjmyaqXWEKqsr8qPGrvXyYi5J6E5HK3cY9u+mHJ UA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3de4vqt3t4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 06 Jan 2022 22:30:42 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 6 Jan
 2022 22:30:41 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 6 Jan 2022 22:30:41 -0800
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 1D5163F7068;
        Thu,  6 Jan 2022 22:30:38 -0800 (PST)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <hkelam@marvell.com>, <gakula@marvell.com>, <sgoutham@marvell.com>,
        <rsaladi2@marvell.com>, Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net PATCH 2/2] octeontx2-nicvf: Free VF PTP resources.
Date:   Fri, 7 Jan 2022 12:00:30 +0530
Message-ID: <1641537030-27911-3-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1641537030-27911-1-git-send-email-sbhatta@marvell.com>
References: <1641537030-27911-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: -evcPnnLA-kyNFr-B3Z65h7ZhqrHFSDL
X-Proofpoint-ORIG-GUID: -evcPnnLA-kyNFr-B3Z65h7ZhqrHFSDL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-07_01,2022-01-06_01,2021-12-02_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rakesh Babu Saladi <rsaladi2@marvell.com>

When a VF is removed respective PTP resources are not
being freed currently. This patch fixes it.

Fixes: 43510ef4ddad ("octeontx2-nicvf: Add PTP hardware clock support to NIX VF")
Signed-off-by: Rakesh Babu Saladi <rsaladi2@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 78944ad..d75f3a7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -684,7 +684,7 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	err = register_netdev(netdev);
 	if (err) {
 		dev_err(dev, "Failed to register netdevice\n");
-		goto err_detach_rsrc;
+		goto err_ptp_destroy;
 	}
 
 	err = otx2_wq_init(vf);
@@ -709,6 +709,8 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 err_unreg_netdev:
 	unregister_netdev(netdev);
+err_ptp_destroy:
+	otx2_ptp_destroy(vf);
 err_detach_rsrc:
 	if (test_bit(CN10K_LMTST, &vf->hw.cap_flag))
 		qmem_free(vf->dev, vf->dync_lmt);
@@ -742,6 +744,7 @@ static void otx2vf_remove(struct pci_dev *pdev)
 	unregister_netdev(netdev);
 	if (vf->otx2_wq)
 		destroy_workqueue(vf->otx2_wq);
+	otx2_ptp_destroy(vf);
 	otx2vf_disable_mbox_intr(vf);
 	otx2_detach_resources(&vf->mbox);
 	if (test_bit(CN10K_LMTST, &vf->hw.cap_flag))
-- 
2.7.4

