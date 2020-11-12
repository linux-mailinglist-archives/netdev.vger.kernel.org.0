Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD2972AFFBC
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 07:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgKLGke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 01:40:34 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:13589 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbgKLGkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 01:40:31 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5facd8e60000>; Wed, 11 Nov 2020 22:40:38 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 12 Nov
 2020 06:40:30 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <virtualization@lists.linux-foundation.org>
CC:     <mst@redhat.com>, <jasowang@redhat.com>, <parav@nvidia.com>,
        <elic@nvidia.com>, <netdev@vger.kernel.org>
Subject: [PATCH 2/7] vdpa: Use simpler version of ida allocation
Date:   Thu, 12 Nov 2020 08:40:00 +0200
Message-ID: <20201112064005.349268-3-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201112064005.349268-1-parav@nvidia.com>
References: <20201112064005.349268-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605163239; bh=obxQ+8CkZMWkGpFrT7wuL+J6qEJIL2OCsM+PzwuIu98=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=FTdm7feQL1zGlazsOD1efEw5oJ8haRvqmBTGZcs2EC3wm3StoPvxSn3AkbbEigwC6
         KegA4W+NIxFwo2LjwiJ11Zl8u9UBgESdg4GR13HMYeyOSWWXdPGOvqKZtEEsIc0sju
         M33ikb6LGk9DQryqPmSr0QKGg2cGf9V2la6RbnlCxdG3aS7ojfa5r+delagU1zS3BW
         7vIm+rizY/4v3NUvnXDgWgXsHVWuFlCb4WTp1/pc6Zn7Vje6+TK/pn3xi/Zl2Uso4W
         oi5sBsQU8lclXIJp+0hO3jvqEKeLZQ/Fge4Ugtdt/gvSLfBAhp2H5HthHt69PL0Yco
         6Nt4z3fsGAFNA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vdpa doesn't have any specific need to define start and end range of the
device index.
Hence use the simper version of the ida allocator.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Eli Cohen <elic@nvidia.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vdpa/vdpa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index a69ffc991e13..c0825650c055 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -89,7 +89,7 @@ struct vdpa_device *__vdpa_alloc_device(struct device *pa=
rent,
 	if (!vdev)
 		goto err;
=20
-	err =3D ida_simple_get(&vdpa_index_ida, 0, 0, GFP_KERNEL);
+	err =3D ida_alloc(&vdpa_index_ida, GFP_KERNEL);
 	if (err < 0)
 		goto err_ida;
=20
--=20
2.26.2

