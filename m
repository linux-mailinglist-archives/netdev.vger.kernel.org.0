Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B450F36E314
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 03:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235956AbhD2Bvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 21:51:39 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:36696 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235520AbhD2Bvi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 21:51:38 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13T1mkHg009817;
        Thu, 29 Apr 2021 01:50:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=CEhFXbkeV5jb4Bwi3UMetDKwSUynvsvV1cHuD5gAY6A=;
 b=vRzuye4UEHqr2A54aSqyzq4bTMIfuAr/6Cwr3V/bSxOBkGubiNHwpqNvbhYERZbv9UFs
 sKsLSlHGbtykAD+/m7s4FL92vlGtmyBo+ymnO1Dm0blIRy1jdrMAmnhjw8Mv/CBmv0pf
 wBKtGNtrVr2l8lSadVNkOLlHsSbUemFfGbzlx2bmiM8rdW7BFXzNQwPvFlaVpnwW8pWD
 mYgnYFBUF7r7Q+nSmjiuLR5Gl+5PqiRxrpDmI2Ymp8uS7VGFpcZKcorwlEN4jMI/SQlx
 OUAkgXu7RX4elZbzMQlOh/CTBnQM8Tcj1hIYeFqZ+ZDsQu4iVQ84Ra9TQfX0+BeMTma5 2w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 385afq2ty9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Apr 2021 01:50:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13T1oZIn023971;
        Thu, 29 Apr 2021 01:50:37 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 384w3vhppu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Apr 2021 01:50:37 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 13T1oaYp024126;
        Thu, 29 Apr 2021 01:50:36 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 384w3vhpmy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Apr 2021 01:50:36 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 13T1oQGa007139;
        Thu, 29 Apr 2021 01:50:26 GMT
Received: from ban25x6uut24.us.oracle.com (/10.153.73.24)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 28 Apr 2021 18:50:26 -0700
From:   Si-Wei Liu <si-wei.liu@oracle.com>
To:     mst@redhat.com, jasowang@redhat.com, elic@nvidia.com
Cc:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        si-wei.liu@oracle.com
Subject: [PATCH v3 0/1] mlx5_vdpa bug fix for feature negotiation
Date:   Wed, 28 Apr 2021 21:48:53 -0400
Message-Id: <1619660934-30910-1-git-send-email-si-wei.liu@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-ORIG-GUID: rrt_UaoDzYl39b02gY1zZs7WqvyHmeBO
X-Proofpoint-GUID: rrt_UaoDzYl39b02gY1zZs7WqvyHmeBO
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9968 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 clxscore=1015 suspectscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 malwarescore=0 impostorscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104290011
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This v3 consisting of one single patch only is a follow-up 
to the v2 of mlx5_vdpa bug fix series as in:

https://lore.kernel.org/virtualization/1612993680-29454-1-git-send-email-si-wei.liu@oracle.com

which initially attempted to fix a few independent issues in the
mlx5_vdpa driver.

Presently Patch #1 in the original series was piggybacked and got
merged through a separate patchset:

https://lore.kernel.org/virtualization/20210406170457.98481-13-parav@nvidia.com/

and the issue Patch #3 tried to fix was addressed by another patch,

https://lore.kernel.org/virtualization/a5356a13-6d7d-8086-bfff-ff869aec5449@redhat.com/

that leaves Patch #2 in the original v2 series unmerged. Since it
was already Ack'ed by Jason and Eli in v2, just get it reposted
while dropping others after syncing with the current vhost tree.

Thanks,

--
v2->v3: drop merged patches from previous series;
        repost with updated commit message
v1->v2: move feature capability query to probing (Eli)

Si-Wei Liu (1):
  vdpa/mlx5: fix feature negotiation across device reset

 drivers/vdpa/mlx5/net/mlx5_vnet.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

-- 
1.8.3.1

