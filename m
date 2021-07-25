Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 355FA3D4F5A
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 19:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbhGYRSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 13:18:16 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:58376 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229545AbhGYRSP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Jul 2021 13:18:15 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16PHpicd020329;
        Sun, 25 Jul 2021 17:58:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2021-07-09; bh=Ygb71Ej7t4/iCOSbs3hi14+PKz2VeCjb05VDTH4vhug=;
 b=f48Vh/5Fhn9LTxlZo/KWQL2syByztQFnkMY0lC+g5AM1HggwCKFy0ogQVlcib/u2WU/j
 Y4mGfZlMQUcfUU6gGHY9Zgk31Nw48/53q0cp3t/G8NoFuE4E4OeZ3VmCwVbNeyNwOY7i
 2Gtgxuf7H5pcmnvj4JUaKDexHYIkuwobI+De5lPaIhAjUHV+Wm7crTggzdiQb6bbx38b
 kKowfy06TuhTOEUnM6Sd0qdxE36rsZzjH9JRaGUk7RTuuWhFQUDCW15Xkr2emfV2JWB9
 8Oy4Pgbrjn3c5Igwc3avBk1wMsPmPgBhI9r63aAAUz0utBKib2NSwDn7IW9RwYj4b/4q wQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=Ygb71Ej7t4/iCOSbs3hi14+PKz2VeCjb05VDTH4vhug=;
 b=jMnhItR6Ba+v5wuRAInW15nDU+kyMPXDQlVGxNXmTNX7sCBciuuUICURfVmOOJt6hfTV
 /7qypz2+MYIvdzf/+UWMpjVECGkG/PPLjYKhMOu12oJb6kbM+jRGry828HqcW3MC71e6
 GngsAYrG6cSTmJgviMTo5IonXFLRecNisx0iAngxrlR+K9WTpcVRyDCJBBOh6aOuMk3w
 w9w4ZwE3IM4DpptYbDlFlC50Fpa5OHyzOaY8ek3I0JOTso5FKxO0Y2h+ONr3JyUomGlh
 7KfpCg7nV+mo8q1M5BtEysv6ilMfBvW6hSQ3EL5L1vA1ABv4YqnIj3bjSOs8yiIDuJm2 5w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a09n31n0s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 25 Jul 2021 17:58:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16PHoeJC179201;
        Sun, 25 Jul 2021 17:58:28 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 3a0vmrhnjk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 25 Jul 2021 17:58:28 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 16PHwRWB193976;
        Sun, 25 Jul 2021 17:58:27 GMT
Received: from manjaro.in.oracle.com (dhcp-10-191-232-135.vpn.oracle.com [10.191.232.135])
        by userp3020.oracle.com with ESMTP id 3a0vmrhner-1;
        Sun, 25 Jul 2021 17:58:27 +0000
From:   Harshvardhan Jha <harshvardhan.jha@oracle.com>
To:     aelior@marvell.com
Cc:     GR-everest-linux-l2@marvell.com, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Harshvardhan Jha <harshvardhan.jha@oracle.com>
Subject: [PATCH net] net: qede: Fix end of loop tests for list_for_each_entry
Date:   Sun, 25 Jul 2021 23:28:04 +0530
Message-Id: <20210725175803.60559-1-harshvardhan.jha@oracle.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: wXNOiNO1AF_db4ZP1-y7SxLtEvl7nt0u
X-Proofpoint-ORIG-GUID: wXNOiNO1AF_db4ZP1-y7SxLtEvl7nt0u
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The list_for_each_entry() iterator, "vlan" in this code, can never be
NULL so the warning will never be printed.

Signed-off-by: Harshvardhan Jha <harshvardhan.jha@oracle.com>
---
From static analysis.  Not tested.
---
 drivers/net/ethernet/qlogic/qede/qede_filter.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_filter.c b/drivers/net/ethernet/qlogic/qede/qede_filter.c
index c59b72c90293..a2e4dfb5cb44 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
@@ -831,7 +831,7 @@ int qede_configure_vlan_filters(struct qede_dev *edev)
 int qede_vlan_rx_kill_vid(struct net_device *dev, __be16 proto, u16 vid)
 {
 	struct qede_dev *edev = netdev_priv(dev);
-	struct qede_vlan *vlan = NULL;
+	struct qede_vlan *vlan;
 	int rc = 0;
 
 	DP_VERBOSE(edev, NETIF_MSG_IFDOWN, "Removing vlan 0x%04x\n", vid);
@@ -842,7 +842,7 @@ int qede_vlan_rx_kill_vid(struct net_device *dev, __be16 proto, u16 vid)
 		if (vlan->vid == vid)
 			break;
 
-	if (!vlan || (vlan->vid != vid)) {
+	if (list_entry_is_head(vlan, &edev->vlan_list, list)) {
 		DP_VERBOSE(edev, (NETIF_MSG_IFUP | NETIF_MSG_IFDOWN),
 			   "Vlan isn't configured\n");
 		goto out;
-- 
2.32.0

