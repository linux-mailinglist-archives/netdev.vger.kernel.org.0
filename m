Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D4829AD2D
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 14:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1752089AbgJ0NXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 09:23:37 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:26842 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752083AbgJ0NXg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 09:23:36 -0400
Received: from HKMAIL104.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f981f560001>; Tue, 27 Oct 2020 21:23:34 +0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 27 Oct
 2020 13:23:32 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 27 Oct 2020 13:23:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c4lBRwh6KkG02Ch90NKhCjo9AeOyL7nnpOAkb6OPnPyeBnERAoProL2gcrwu6GexT1codYmeVmFx1cBt3eCdQqfQZMrHk5eKVHLe00hraNXKEvIpma5sY3Jkb+lMPA9yqXkxb2ba0Dj0a/XRHDakzOPg0/wlR3TZGqENxwZrOX9+XXAxmVqMMxcxMef40VbgUCzhZ6Fw6lM1pBLp9xzggzFStaXfArQpHn/cPYPAa52q4atjyttCXKbam3KT0x1ovbu85ZfCmJVb5gNsMjUjb/TiZo51ahZaRGYVpibHTJI/YJ+2p4RzFlxGEz0sB/NAgR3zdsmtp4VBnyqRPaNb3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vO+N/jDgb0eszrDJcGQyjQ5CdeTguL3b1ZF6FMF8r2g=;
 b=dACuIg0wq98ez83vX71Bki+pABMLVqMu+ZJwA4XGAWQJtU9FR76kjR/wTkrixal7XKCX1Pe427ljNJdZo1VHqcs8O7SzmKhFkCdVEd8RxITnlbwH6pZscy/ysNLkU8wC/nBDL0A+Zqze6snw4obiiLexsqy1StsUBw7D9LFL3eCuXI5MmAnWPsA8VHAXH15yC93LtzCSGtpuq7fYinp91Y9Z2FuArrNstkhEZzFYGeKORN0iGAgoC5q0noK0IxMq9EbWUMFAFKxPQ0MNuueFmqPI6ohuNXA9vG0RyieOi/LPVIovMKV9nHDNjmwv2swnrwylFMP+gbitMECusGSGzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4619.namprd12.prod.outlook.com (2603:10b6:5:7c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Tue, 27 Oct
 2020 13:23:27 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3477.028; Tue, 27 Oct 2020
 13:23:27 +0000
Date:   Tue, 27 Oct 2020 10:23:26 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leonro@nvidia.com>
CC:     <linux-rdma@vger.kernel.org>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Christoph Hellwig <hch@lst.de>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Chao Leng <lengchao@huawei.com>,
        "Santosh Shilimkar" <santosh.shilimkar@oracle.com>,
        Keith Busch <kbusch@kernel.org>,
        <linux-nvme@lists.infradead.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>, <netdev@vger.kernel.org>,
        <rds-devel@oss.oracle.com>, Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH rdma v2] RDMA: Add rdma_connect_locked()
Message-ID: <20201027132326.GK1523783@nvidia.com>
References: <0-v2-53c22d5c1405+33-rdma_connect_locking_jgg@nvidia.com>
 <20201027131936.GD1763578@unreal>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201027131936.GD1763578@unreal>
X-ClientProxiedBy: BL0PR03CA0005.namprd03.prod.outlook.com
 (2603:10b6:208:2d::18) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by BL0PR03CA0005.namprd03.prod.outlook.com (2603:10b6:208:2d::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Tue, 27 Oct 2020 13:23:27 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kXOwg-009KaE-0U; Tue, 27 Oct 2020 10:23:26 -0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603805014; bh=vO+N/jDgb0eszrDJcGQyjQ5CdeTguL3b1ZF6FMF8r2g=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=h5HwtLjuOaUZf6apBG1d5jF7BDxVb3Gq1Di+HeNipjgbl59tCyuyDdOOqWt9Ki93H
         zeDmOz0U/k8MWjD8iXfveRlPpjyf4+LW7AjU4T0r5uqhj3LE4Se00xkeY89aJufeB8
         4kjP9S2DkVCSqYaRaFqKJWJPGuAKpXYQbhWg6scClsEroR5CaQwqAqnNQzA4wwCZyC
         iYZBLScxnlbr6jUhG6KX8Q82btkxt8dw7C+7WGu0W17hJuiJiA8U7qhzUWpI2egN9u
         bxrIQcPxYwMIET+nFyklnQVaTx97Oqu2rc66P/qtzFeezol9Rrr6Pzz+TW8/pT4gKr
         WFQ68/3OvZF1w==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 03:19:36PM +0200, Leon Romanovsky wrote:

> > +int rdma_connect_locked(struct rdma_cm_id *id,
> > +			struct rdma_conn_param *conn_param)
> >  {
> >  	struct rdma_id_private *id_priv =
> >  		container_of(id, struct rdma_id_private, id);
> >  	int ret;
> >
> > -	mutex_lock(&id_priv->handler_mutex);
> >  	if (!cma_comp_exch(id_priv, RDMA_CM_ROUTE_RESOLVED, RDMA_CM_CONNECT)) {
> >  		ret = -EINVAL;
> >  		goto err_unlock;
> 
> Not a big deal, but his label is not correct anymore.

Oh, yep

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 193c8902b9db26..f58d19881524dc 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -4053,10 +4053,8 @@ int rdma_connect_locked(struct rdma_cm_id *id,
 		container_of(id, struct rdma_id_private, id);
 	int ret;
 
-	if (!cma_comp_exch(id_priv, RDMA_CM_ROUTE_RESOLVED, RDMA_CM_CONNECT)) {
-		ret = -EINVAL;
-		goto err_unlock;
-	}
+	if (!cma_comp_exch(id_priv, RDMA_CM_ROUTE_RESOLVED, RDMA_CM_CONNECT))
+		return -EINVAL;
 
 	if (!id->qp) {
 		id_priv->qp_num = conn_param->qp_num;
@@ -4078,7 +4076,6 @@ int rdma_connect_locked(struct rdma_cm_id *id,
 	return 0;
 err_state:
 	cma_comp_exch(id_priv, RDMA_CM_CONNECT, RDMA_CM_ROUTE_RESOLVED);
-err_unlock:
 	return ret;
 }
 EXPORT_SYMBOL(rdma_connect_locked);
