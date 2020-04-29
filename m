Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1759D1BD194
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 03:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726493AbgD2BRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 21:17:01 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3372 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726353AbgD2BRA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 21:17:00 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B1B0B10286A24FE3DAA6;
        Wed, 29 Apr 2020 09:16:56 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Wed, 29 Apr 2020
 09:16:50 +0800
From:   Zheng Bin <zhengbin13@huawei.com>
To:     <aviad.krawczyk@huawei.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH -next] hinic: remove set but not used variable 'func_id'
Date:   Wed, 29 Apr 2020 09:23:57 +0800
Message-ID: <20200429012358.30007-1-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.26.0.106.g9fadedd
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/ethernet/huawei/hinic/hinic_sriov.c:792:6: warning: variable ‘func_id’ set but not used [-Wunused-but-set-variable]

It is introduced by commit 7dd29ee12865 ("hinic:
add sriov feature support"), but never used,
so remove it.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_sriov.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
index b24788e9733c..d78ccef992ed 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
@@ -789,9 +789,7 @@ static int hinic_init_vf_infos(struct hinic_func_to_io *nic_io, u16 vf_id)
 void hinic_clear_vf_infos(struct hinic_dev *nic_dev, u16 vf_id)
 {
 	struct vf_data_storage *vf_infos;
-	u16 func_id;

-	func_id = hinic_glb_pf_vf_offset(nic_dev->hwdev->hwif) + vf_id;
 	vf_infos = nic_dev->hwdev->func_to_io.vf_infos + HW_VF_ID_TO_OS(vf_id);
 	if (vf_infos->pf_set_mac)
 		hinic_port_del_mac(nic_dev, vf_infos->vf_mac_addr, 0);
--
2.26.0.106.g9fadedd

