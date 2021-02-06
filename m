Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4C9311D6C
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 14:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbhBFNSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 08:18:12 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:42208 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbhBFNSD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Feb 2021 08:18:03 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 116DAA7b058414;
        Sat, 6 Feb 2021 13:17:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : references : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=iBieoUlmovjvu5MaIJ9cX8BhQE205Z9HXYbmJPk/bDk=;
 b=qS/UJStC/nkTVP/7CzekK8ci4FqXC+RyAqJRpDbmo9Xv+t4hMztZTr4iUy6llQ/LjW9M
 3NH+O+TFJQdKARJ6YpvnKfGpLxl3mv+4Fo4HiXkvJXarBX+0OEROCCuEvaglUbQFROvu
 oWuXhPwM1rKlnyYK1nytJ8fqOfa5uYr0Y2oIBJ1mYBaZgwZUtIBumykl7xdYBpU9CNFA
 JLgEh8n/cbGYPIjPDOqJUUrykouJUMGff33r1svR6q0H05AYdc+d9TTPYgv0G3hKOfSg
 VXBaHNKK2uqQg61uC3MKrifipl87bsThi52vgkphIn4rBJ1bQrWnb5T2kqjVLP7rVisk jQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 36hjhqgn9f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 06 Feb 2021 13:17:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 116DARWr028459;
        Sat, 6 Feb 2021 13:17:09 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 36hjeh3f5y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 06 Feb 2021 13:17:09 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 116DH89E018854;
        Sat, 6 Feb 2021 13:17:08 GMT
Received: from ban25x6uut24.us.oracle.com (/10.153.73.24) by default (Oracle
 Beehive Gateway v4.0) with ESMTP ; Sat, 06 Feb 2021 05:16:17 -0800
MIME-Version: 1.0
Message-ID: <1612614564-4220-3-git-send-email-si-wei.liu@oracle.com>
Date:   Sat, 6 Feb 2021 04:29:24 -0800 (PST)
From:   Si-Wei Liu <si-wei.liu@oracle.com>
To:     mst@redhat.com, jasowang@redhat.com, elic@nvidia.com
Cc:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        si-wei.liu@oracle.com
Subject: [PATCH 3/3] mlx5_vdpa: defer clear_virtqueues to until DRIVER_OK
References: <1612614564-4220-1-git-send-email-si-wei.liu@oracle.com>
In-Reply-To: <1612614564-4220-1-git-send-email-si-wei.liu@oracle.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain; charset=ascii
Content-Transfer-Encoding: 7bit
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9886 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102060093
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9886 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102060093
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While virtq is stopped,  get_vq_state() is supposed to
be  called to  get  sync'ed  with  the latest internal
avail_index from device. The saved avail_index is used
to restate  the virtq  once device is started.  Commit
b35ccebe3ef7 introduced the clear_virtqueues() routine
to  reset  the saved  avail_index,  however, the index
gets cleared a bit earlier before get_vq_state() tries
to read it. This would cause consistency problems when
virtq is restarted, e.g. through a series of link down
and link up events. We  could  defer  the  clearing of
avail_index  to  until  the  device  is to be started,
i.e. until  VIRTIO_CONFIG_S_DRIVER_OK  is set again in
set_status().

Fixes: b35ccebe3ef7 ("vdpa/mlx5: Restore the hardware used index after change map")
Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index aa6f8cd..444ab58 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1785,7 +1785,6 @@ static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
 	if (!status) {
 		mlx5_vdpa_info(mvdev, "performing device reset\n");
 		teardown_driver(ndev);
-		clear_virtqueues(ndev);
 		mlx5_vdpa_destroy_mr(&ndev->mvdev);
 		ndev->mvdev.status = 0;
 		++mvdev->generation;
@@ -1794,6 +1793,7 @@ static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
 
 	if ((status ^ ndev->mvdev.status) & VIRTIO_CONFIG_S_DRIVER_OK) {
 		if (status & VIRTIO_CONFIG_S_DRIVER_OK) {
+			clear_virtqueues(ndev);
 			err = setup_driver(ndev);
 			if (err) {
 				mlx5_vdpa_warn(mvdev, "failed to setup driver\n");
-- 
1.8.3.1

