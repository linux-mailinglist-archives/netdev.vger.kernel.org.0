Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C58F83172B3
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 22:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232274AbhBJVuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 16:50:54 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35454 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232350AbhBJVug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 16:50:36 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11ALjOiM090661;
        Wed, 10 Feb 2021 21:49:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=Tdndnpd4eEExL2M0vXU8tvqQad0Lunj0ISddzhpccyE=;
 b=d7zvhFgaPGvV2yvUgnNVbXqvrSPC/c8VNfwGrudzxt8Phy9o4eJC32mqC3zzYIVECc2R
 1Nm2Molv8569RL54H/LFumt8ZJiPS3R5c1OHTLu3rfsmGCQRgbjqOq6+FeY+/riiWNXR
 SvJD+P73BGc8wOTMdW4h9x4EDcptGNBDdhvYIkYC1ViOvHkYTpKvCIJ2mb5iCW8sPejN
 HrqEYpiv/vqsRu14l50dF1/+FOXZM4ZJrxvp2PSGpltwlIPr0kdbtRW0kex47zno8boS
 mh4M/cOYmn0VdrZ9OWstGfmlitkw/F3QGl1nIRh7Ws7TspfsmUPwpyNmjYj1OKl2OEK0 2w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 36m4upurgx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 21:49:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11ALk1vB104194;
        Wed, 10 Feb 2021 21:49:48 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 36j4pqpxrs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 21:49:47 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 11ALnjtO002810;
        Wed, 10 Feb 2021 21:49:45 GMT
Received: from ban25x6uut24.us.oracle.com (/10.153.73.24) by default (Oracle
 Beehive Gateway v4.0) with ESMTP ; Wed, 10 Feb 2021 13:48:42 -0800
MIME-Version: 1.0
Message-ID: <1612993680-29454-1-git-send-email-si-wei.liu@oracle.com>
Date:   Wed, 10 Feb 2021 13:47:57 -0800 (PST)
From:   Si-Wei Liu <si-wei.liu@oracle.com>
To:     mst@redhat.com, jasowang@redhat.com, elic@nvidia.com
Cc:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        si-wei.liu@oracle.com
Subject: [PATCH v2 0/3] mlx5_vdpa bug fixes
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
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 spamscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 suspectscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102100189
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set attempts to fix a few independent issues recently found
in mlx5_vdpa driver. Please find details for each in the commit
message.

Patch 1 and patch 3 are already Ack'ed by Jason Wang. Patch 2 is
reworked to move virtio feature capability query to mlx5v_probe()
as suggested by Eli.

--
v1->v2: move feature capability query to probing (Eli)

Si-Wei Liu (3):
  vdpa/mlx5: should exclude header length and fcs from mtu
  vdpa/mlx5: fix feature negotiation across device reset
  vdpa/mlx5: defer clear_virtqueues to until DRIVER_OK

 drivers/vdpa/mlx5/core/mlx5_vdpa.h |  4 ++++
 drivers/vdpa/mlx5/net/mlx5_vnet.c  | 42 +++++++++++++++++++++++++++-----------
 2 files changed, 34 insertions(+), 12 deletions(-)

-- 
1.8.3.1

