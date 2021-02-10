Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54E683172B2
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 22:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233035AbhBJVul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 16:50:41 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:41070 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbhBJVue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 16:50:34 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11ALiej9044025;
        Wed, 10 Feb 2021 21:49:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : references : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=IjeoqzhGJEmEwPeoDAEaDlWQzKW/7TddGIZUgTixWOk=;
 b=MvHrkiO2lEgfGX1hJ3GI6PUlUPtuupm0rgdc03GbNNUlDWGmYhhwJhIgwN/QVYU/T8e9
 qlAI9v502I+aMSMUnEk+GDoWqPdixBQSH4X5o69dEwN2rUoMy7uuh1CpdBeshmmkr4dP
 fgM0UVjAON1X82aPVTjjFrXp8eGy0fZ5oPHIwgG0egEKQaEIyNY2ep0EVIi2N53SLU6E
 2idplvj6Y5C7L00cExPhT0IxJ7g2hIld+0Y/Fcudy3PaAJWT7aGEA/6sSNWYKYT1dv0Q
 ixsRCnKPaW1qGeMrnGMiZ4PpuMlfcx2eixc1wwiwge7Q4rIWPlEmhKoIQ82y3k2ZPgj8 Jw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 36hjhqw80y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 21:49:48 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11ALk0oZ103978;
        Wed, 10 Feb 2021 21:49:47 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 36j4pqpxr7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 21:49:46 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 11ALnj0S009743;
        Wed, 10 Feb 2021 21:49:45 GMT
Received: from ban25x6uut24.us.oracle.com (/10.153.73.24) by default (Oracle
 Beehive Gateway v4.0) with ESMTP ; Wed, 10 Feb 2021 13:48:44 -0800
MIME-Version: 1.0
Message-ID: <1612993680-29454-4-git-send-email-si-wei.liu@oracle.com>
Date:   Wed, 10 Feb 2021 13:48:00 -0800 (PST)
From:   Si-Wei Liu <si-wei.liu@oracle.com>
To:     mst@redhat.com, jasowang@redhat.com, elic@nvidia.com
Cc:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        si-wei.liu@oracle.com
Subject: [PATCH v2 3/3] vdpa/mlx5: defer clear_virtqueues to until DRIVER_OK
References: <1612993680-29454-1-git-send-email-si-wei.liu@oracle.com>
In-Reply-To: <1612993680-29454-1-git-send-email-si-wei.liu@oracle.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain; charset=ascii
Content-Transfer-Encoding: 7bit
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9891 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102100189
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9891 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102100189
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
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 7c1f789..ce6aae8 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1777,7 +1777,6 @@ static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
 	if (!status) {
 		mlx5_vdpa_info(mvdev, "performing device reset\n");
 		teardown_driver(ndev);
-		clear_virtqueues(ndev);
 		mlx5_vdpa_destroy_mr(&ndev->mvdev);
 		ndev->mvdev.status = 0;
 		++mvdev->generation;
@@ -1786,6 +1785,7 @@ static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
 
 	if ((status ^ ndev->mvdev.status) & VIRTIO_CONFIG_S_DRIVER_OK) {
 		if (status & VIRTIO_CONFIG_S_DRIVER_OK) {
+			clear_virtqueues(ndev);
 			err = setup_driver(ndev);
 			if (err) {
 				mlx5_vdpa_warn(mvdev, "failed to setup driver\n");
-- 
1.8.3.1

