Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64C4B1BEDAB
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 03:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbgD3BfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 21:35:22 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3342 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726338AbgD3BfV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 21:35:21 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 6CFCD98E0594281B511E;
        Thu, 30 Apr 2020 09:35:16 +0800 (CST)
Received: from localhost (10.166.215.154) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Thu, 30 Apr 2020
 09:35:08 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <aviad.krawczyk@huawei.com>, <davem@davemloft.net>,
        <luobin9@huawei.com>, <yuehaibing@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] hinic: make a bunch of functions static
Date:   Thu, 30 Apr 2020 09:32:45 +0800
Message-ID: <20200430013245.35028-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.166.215.154]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These fucntions is used only in hinic_sriov.c,
so make them static to fix sparse warnings.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 .../net/ethernet/huawei/hinic/hinic_sriov.c   | 91 ++++++++++---------
 1 file changed, 48 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
index b24788e9733c..0d44af9dce2a 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
@@ -23,8 +23,8 @@ MODULE_PARM_DESC(set_vf_link_state, "Set vf link state, 0 represents link auto,
 #define HINIC_VLAN_PRIORITY_SHIFT 13
 #define HINIC_ADD_VLAN_IN_MAC 0x8000
 
-int hinic_set_mac(struct hinic_hwdev *hwdev, const u8 *mac_addr, u16 vlan_id,
-		  u16 func_id)
+static int hinic_set_mac(struct hinic_hwdev *hwdev, const u8 *mac_addr,
+			 u16 vlan_id, u16 func_id)
 {
 	struct hinic_port_mac_cmd mac_info = {0};
 	u16 out_size = sizeof(mac_info);
@@ -84,7 +84,7 @@ void hinic_notify_all_vfs_link_changed(struct hinic_hwdev *hwdev,
 	}
 }
 
-u16 hinic_vf_info_vlanprio(struct hinic_hwdev *hwdev, int vf_id)
+static u16 hinic_vf_info_vlanprio(struct hinic_hwdev *hwdev, int vf_id)
 {
 	struct hinic_func_to_io *nic_io = &hwdev->func_to_io;
 	u16 pf_vlan, vlanprio;
@@ -97,8 +97,8 @@ u16 hinic_vf_info_vlanprio(struct hinic_hwdev *hwdev, int vf_id)
 	return vlanprio;
 }
 
-int hinic_set_vf_vlan(struct hinic_hwdev *hwdev, bool add, u16 vid,
-		      u8 qos, int vf_id)
+static int hinic_set_vf_vlan(struct hinic_hwdev *hwdev, bool add, u16 vid,
+			     u8 qos, int vf_id)
 {
 	struct hinic_vf_vlan_config vf_vlan = {0};
 	u16 out_size = sizeof(vf_vlan);
@@ -163,9 +163,9 @@ static int hinic_init_vf_config(struct hinic_hwdev *hwdev, u16 vf_id)
 	return 0;
 }
 
-int hinic_register_vf_msg_handler(void *hwdev, u16 vf_id,
-				  void *buf_in, u16 in_size,
-				  void *buf_out, u16 *out_size)
+static int hinic_register_vf_msg_handler(void *hwdev, u16 vf_id,
+					 void *buf_in, u16 in_size,
+					 void *buf_out, u16 *out_size)
 {
 	struct hinic_register_vf *register_info = buf_out;
 	struct hinic_hwdev *hw_dev = hwdev;
@@ -192,9 +192,9 @@ int hinic_register_vf_msg_handler(void *hwdev, u16 vf_id,
 	return 0;
 }
 
-int hinic_unregister_vf_msg_handler(void *hwdev, u16 vf_id,
-				    void *buf_in, u16 in_size,
-				    void *buf_out, u16 *out_size)
+static int hinic_unregister_vf_msg_handler(void *hwdev, u16 vf_id,
+					   void *buf_in, u16 in_size,
+					   void *buf_out, u16 *out_size)
 {
 	struct hinic_hwdev *hw_dev = hwdev;
 	struct hinic_func_to_io *nic_io;
@@ -209,9 +209,9 @@ int hinic_unregister_vf_msg_handler(void *hwdev, u16 vf_id,
 	return 0;
 }
 
-int hinic_change_vf_mtu_msg_handler(void *hwdev, u16 vf_id,
-				    void *buf_in, u16 in_size,
-				    void *buf_out, u16 *out_size)
+static int hinic_change_vf_mtu_msg_handler(void *hwdev, u16 vf_id,
+					   void *buf_in, u16 in_size,
+					   void *buf_out, u16 *out_size)
 {
 	struct hinic_hwdev *hw_dev = hwdev;
 	int err;
@@ -227,9 +227,9 @@ int hinic_change_vf_mtu_msg_handler(void *hwdev, u16 vf_id,
 	return 0;
 }
 
-int hinic_get_vf_mac_msg_handler(void *hwdev, u16 vf_id,
-				 void *buf_in, u16 in_size,
-				 void *buf_out, u16 *out_size)
+static int hinic_get_vf_mac_msg_handler(void *hwdev, u16 vf_id,
+					void *buf_in, u16 in_size,
+					void *buf_out, u16 *out_size)
 {
 	struct hinic_port_mac_cmd *mac_info = buf_out;
 	struct hinic_hwdev *dev = hwdev;
@@ -246,9 +246,9 @@ int hinic_get_vf_mac_msg_handler(void *hwdev, u16 vf_id,
 	return 0;
 }
 
-int hinic_set_vf_mac_msg_handler(void *hwdev, u16 vf_id,
-				 void *buf_in, u16 in_size,
-				 void *buf_out, u16 *out_size)
+static int hinic_set_vf_mac_msg_handler(void *hwdev, u16 vf_id,
+					void *buf_in, u16 in_size,
+					void *buf_out, u16 *out_size)
 {
 	struct hinic_port_mac_cmd *mac_out = buf_out;
 	struct hinic_port_mac_cmd *mac_in = buf_in;
@@ -280,9 +280,9 @@ int hinic_set_vf_mac_msg_handler(void *hwdev, u16 vf_id,
 	return err;
 }
 
-int hinic_del_vf_mac_msg_handler(void *hwdev, u16 vf_id,
-				 void *buf_in, u16 in_size,
-				 void *buf_out, u16 *out_size)
+static int hinic_del_vf_mac_msg_handler(void *hwdev, u16 vf_id,
+					void *buf_in, u16 in_size,
+					void *buf_out, u16 *out_size)
 {
 	struct hinic_port_mac_cmd *mac_out = buf_out;
 	struct hinic_port_mac_cmd *mac_in = buf_in;
@@ -312,9 +312,9 @@ int hinic_del_vf_mac_msg_handler(void *hwdev, u16 vf_id,
 	return err;
 }
 
-int hinic_get_vf_link_status_msg_handler(void *hwdev, u16 vf_id,
-					 void *buf_in, u16 in_size,
-					 void *buf_out, u16 *out_size)
+static int hinic_get_vf_link_status_msg_handler(void *hwdev, u16 vf_id,
+						void *buf_in, u16 in_size,
+						void *buf_out, u16 *out_size)
 {
 	struct hinic_port_link_cmd *get_link = buf_out;
 	struct hinic_hwdev *hw_dev = hwdev;
@@ -339,7 +339,7 @@ int hinic_get_vf_link_status_msg_handler(void *hwdev, u16 vf_id,
 	return 0;
 }
 
-struct vf_cmd_msg_handle nic_vf_cmd_msg_handler[] = {
+static struct vf_cmd_msg_handle nic_vf_cmd_msg_handler[] = {
 	{HINIC_PORT_CMD_VF_REGISTER, hinic_register_vf_msg_handler},
 	{HINIC_PORT_CMD_VF_UNREGISTER, hinic_unregister_vf_msg_handler},
 	{HINIC_PORT_CMD_CHANGE_MTU, hinic_change_vf_mtu_msg_handler},
@@ -351,6 +351,7 @@ struct vf_cmd_msg_handle nic_vf_cmd_msg_handler[] = {
 
 #define CHECK_IPSU_15BIT	0X8000
 
+static
 struct hinic_sriov_info *hinic_get_sriov_info_by_pcidev(struct pci_dev *pdev)
 {
 	struct net_device *netdev = pci_get_drvdata(pdev);
@@ -372,8 +373,8 @@ static int hinic_check_mac_info(u8 status, u16 vlan_id)
 
 #define HINIC_VLAN_ID_MASK	0x7FFF
 
-int hinic_update_mac(struct hinic_hwdev *hwdev, u8 *old_mac, u8 *new_mac,
-		     u16 vlan_id, u16 func_id)
+static int hinic_update_mac(struct hinic_hwdev *hwdev, u8 *old_mac,
+			    u8 *new_mac, u16 vlan_id, u16 func_id)
 {
 	struct hinic_port_mac_update mac_info = {0};
 	u16 out_size = sizeof(mac_info);
@@ -416,8 +417,8 @@ int hinic_update_mac(struct hinic_hwdev *hwdev, u8 *old_mac, u8 *new_mac,
 	return 0;
 }
 
-void hinic_get_vf_config(struct hinic_hwdev *hwdev, u16 vf_id,
-			 struct ifla_vf_info *ivi)
+static void hinic_get_vf_config(struct hinic_hwdev *hwdev, u16 vf_id,
+				struct ifla_vf_info *ivi)
 {
 	struct vf_data_storage *vfinfo;
 
@@ -455,7 +456,8 @@ int hinic_ndo_get_vf_config(struct net_device *netdev,
 	return 0;
 }
 
-int hinic_set_vf_mac(struct hinic_hwdev *hwdev, int vf, unsigned char *mac_addr)
+static int hinic_set_vf_mac(struct hinic_hwdev *hwdev, int vf,
+			    unsigned char *mac_addr)
 {
 	struct hinic_func_to_io *nic_io = &hwdev->func_to_io;
 	struct vf_data_storage *vf_info;
@@ -504,7 +506,8 @@ int hinic_ndo_set_vf_mac(struct net_device *netdev, int vf, u8 *mac)
 	return 0;
 }
 
-int hinic_add_vf_vlan(struct hinic_hwdev *hwdev, int vf_id, u16 vlan, u8 qos)
+static int hinic_add_vf_vlan(struct hinic_hwdev *hwdev, int vf_id,
+			     u16 vlan, u8 qos)
 {
 	struct hinic_func_to_io *nic_io = &hwdev->func_to_io;
 	int err;
@@ -521,7 +524,7 @@ int hinic_add_vf_vlan(struct hinic_hwdev *hwdev, int vf_id, u16 vlan, u8 qos)
 	return 0;
 }
 
-int hinic_kill_vf_vlan(struct hinic_hwdev *hwdev, int vf_id)
+static int hinic_kill_vf_vlan(struct hinic_hwdev *hwdev, int vf_id)
 {
 	struct hinic_func_to_io *nic_io = &hwdev->func_to_io;
 	int err;
@@ -543,8 +546,8 @@ int hinic_kill_vf_vlan(struct hinic_hwdev *hwdev, int vf_id)
 	return 0;
 }
 
-int hinic_update_mac_vlan(struct hinic_dev *nic_dev, u16 old_vlan, u16 new_vlan,
-			  int vf_id)
+static int hinic_update_mac_vlan(struct hinic_dev *nic_dev, u16 old_vlan,
+				 u16 new_vlan, int vf_id)
 {
 	struct vf_data_storage *vf_info;
 	u16 vlan_id;
@@ -651,7 +654,8 @@ int hinic_ndo_set_vf_vlan(struct net_device *netdev, int vf, u16 vlan, u8 qos,
 	return set_hw_vf_vlan(nic_dev, cur_vlanprio, vf, vlan, qos);
 }
 
-int hinic_set_vf_trust(struct hinic_hwdev *hwdev, u16 vf_id, bool trust)
+static int hinic_set_vf_trust(struct hinic_hwdev *hwdev, u16 vf_id,
+			      bool trust)
 {
 	struct vf_data_storage *vf_infos;
 	struct hinic_func_to_io *nic_io;
@@ -697,8 +701,8 @@ int hinic_ndo_set_vf_trust(struct net_device *netdev, int vf, bool setting)
 }
 
 /* pf receive message from vf */
-int nic_pf_mbox_handler(void *hwdev, u16 vf_id, u8 cmd, void *buf_in,
-			u16 in_size, void *buf_out, u16 *out_size)
+static int nic_pf_mbox_handler(void *hwdev, u16 vf_id, u8 cmd, void *buf_in,
+			       u16 in_size, void *buf_out, u16 *out_size)
 {
 	struct vf_cmd_msg_handle *vf_msg_handle;
 	struct hinic_hwdev *dev = hwdev;
@@ -786,7 +790,7 @@ static int hinic_init_vf_infos(struct hinic_func_to_io *nic_io, u16 vf_id)
 	return 0;
 }
 
-void hinic_clear_vf_infos(struct hinic_dev *nic_dev, u16 vf_id)
+static void hinic_clear_vf_infos(struct hinic_dev *nic_dev, u16 vf_id)
 {
 	struct vf_data_storage *vf_infos;
 	u16 func_id;
@@ -807,8 +811,8 @@ void hinic_clear_vf_infos(struct hinic_dev *nic_dev, u16 vf_id)
 	hinic_init_vf_infos(&nic_dev->hwdev->func_to_io, HW_VF_ID_TO_OS(vf_id));
 }
 
-int hinic_deinit_vf_hw(struct hinic_sriov_info *sriov_info, u16 start_vf_id,
-		       u16 end_vf_id)
+static int hinic_deinit_vf_hw(struct hinic_sriov_info *sriov_info,
+			      u16 start_vf_id, u16 end_vf_id)
 {
 	struct hinic_dev *nic_dev;
 	u16 func_idx, idx;
@@ -908,7 +912,8 @@ void hinic_vf_func_free(struct hinic_hwdev *hwdev)
 	}
 }
 
-int hinic_init_vf_hw(struct hinic_hwdev *hwdev, u16 start_vf_id, u16 end_vf_id)
+static int hinic_init_vf_hw(struct hinic_hwdev *hwdev, u16 start_vf_id,
+			    u16 end_vf_id)
 {
 	u16 i, func_idx;
 	int err;
-- 
2.17.1


