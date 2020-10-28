Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D213429D2D2
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 22:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726737AbgJ1VfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 17:35:18 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:28258 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726700AbgJ1VfK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 17:35:10 -0400
Received: from HKMAIL101.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f9960b90000>; Wed, 28 Oct 2020 20:14:49 +0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 28 Oct
 2020 12:14:43 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 28 Oct 2020 12:14:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OCSDZgL05dyDiIyyctUaDs9bPa/AMR7fcRlj8gDV4gonXgS3mVisqdbR1RonXkd/J8/SXu1ED2TtELTt2rVeHwyforKVvtElXsIDJ2oNIzVVsmeaEvjDlmErIQh8Amt2rDKLxR3CzcoLlRucbUo/04zjSNGey5dBLI6fU+MUJUlxa2lQI56q4ccQfqG6wAX91EpgijO1MopwnxxZPRM6UI59kG1pAo4esvmYcT01ldn/doMQdLU+dBglpjebvqos/jdE459rqUmWGVgG6xSTfGrbtsZQzyP8Qnn+/pokqVmYnpuPMRJb+7suQfBIRF6AJ/RD3V0dhVsIXy5QrIHXEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GDsk0pGeWll3uhXmO7tKPci2CWy4O4fCJM6xIer31Ao=;
 b=cE2azgy6OKXmje4H1nnHi/maQfbOzS/R02IW8EEemRbE62+ZPZyvcGDhdlRKxT7dRp2b6p1f2r4rwC2Tj+8mJqix+xgVe706hhDzMOZCYH+QMUPWYN5I8PoUtTgwrqntP69YyKJZy+d/ZoayFUygxJsbw71p/QS1d4hGmRkjzFeu0mNuDONyV1w2IUdwQ5lKlRzcHXx30xtdIDqR2hbkn6YoRBGl8YTVp7F19Im4NUzIJItJpHRP9DdkeaAaW7Lo5Rmh2Q9DOMLRU3C03M9VGh5SCFSEz0gGa0t4Vi26O7/OP/YIZi9FZpTwJgPs7hp6L1ZwdFpRAczSlXg17KSlgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from CH2PR12MB3831.namprd12.prod.outlook.com (2603:10b6:610:29::13)
 by CH2PR12MB4021.namprd12.prod.outlook.com (2603:10b6:610:2b::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.25; Wed, 28 Oct
 2020 12:14:40 +0000
Received: from CH2PR12MB3831.namprd12.prod.outlook.com
 ([fe80::304d:bd84:52d9:7f74]) by CH2PR12MB3831.namprd12.prod.outlook.com
 ([fe80::304d:bd84:52d9:7f74%6]) with mapi id 15.20.3477.028; Wed, 28 Oct 2020
 12:14:40 +0000
Date:   Wed, 28 Oct 2020 09:14:37 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Maor Gottlieb <maorg@nvidia.com>
CC:     <linux-rdma@vger.kernel.org>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Christoph Hellwig <hch@lst.de>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Chao Leng <lengchao@huawei.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Keith Busch <kbusch@kernel.org>,
        <linux-nvme@lists.infradead.org>,
        "Max Gurtovoy" <mgurtovoy@nvidia.com>, <netdev@vger.kernel.org>,
        <rds-devel@oss.oracle.com>, Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH rdma v2] RDMA: Add rdma_connect_locked()
Message-ID: <20201028121437.GU1523783@nvidia.com>
References: <0-v2-53c22d5c1405+33-rdma_connect_locking_jgg@nvidia.com>
 <4401b7b1-5d05-a715-4701-957fd09f34c9@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4401b7b1-5d05-a715-4701-957fd09f34c9@nvidia.com>
X-ClientProxiedBy: MN2PR08CA0008.namprd08.prod.outlook.com
 (2603:10b6:208:239::13) To CH2PR12MB3831.namprd12.prod.outlook.com
 (2603:10b6:610:29::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR08CA0008.namprd08.prod.outlook.com (2603:10b6:208:239::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Wed, 28 Oct 2020 12:14:40 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kXkLd-009vvx-Mn; Wed, 28 Oct 2020 09:14:37 -0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603887289; bh=GDsk0pGeWll3uhXmO7tKPci2CWy4O4fCJM6xIer31Ao=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=aS+R9tss6LVVb5Qv8AxvF/SbcIZwtLAToMUBdozqBpZyM0nbXaAnYELa8HsvV+2nn
         JfH07a9NeE6PAjWd+KdiGzKdWm3Qw2MPTKZaYG5yZptJ4l1rW9at+lE6BQpjxtrIjp
         P3CWHAGi1+B6IbQl2FENZOjXX/yzOTEt0W7BS+jsGtnDUAccNgaqlvBb0c45Sl3xw5
         uV/xxyFWQWJa4GZ4aH/f7XjQn5WXmYWISnue1aG5SaYaXNAftDSAEzOQvm9wY4an4Z
         DCPFV3BZHPIi2AiXbNr80XgZP92UEX7KjzCs2intun9fljaj7glWNN1qtRdAwfeeCJ
         v4oikr2yYOAqA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 11:19:14AM +0200, Maor Gottlieb wrote:
> > +			struct rdma_conn_param *conn_param)
> >   {
> >   	struct rdma_id_private *id_priv =
> >   		container_of(id, struct rdma_id_private, id);
> >   	int ret;
> > -	mutex_lock(&id_priv->handler_mutex);
> 
> You need to delete the mutex_unlock in success path too.

Gaaaaah. Just goes to prove I shouldn't write patches with a child on
my lap :\

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index f58d19881524dc..a77750b8954db0 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -4072,7 +4072,6 @@ int rdma_connect_locked(struct rdma_cm_id *id,
 		ret = -ENOSYS;
 	if (ret)
 		goto err_state;
-	mutex_unlock(&id_priv->handler_mutex);
 	return 0;
 err_state:
 	cma_comp_exch(id_priv, RDMA_CM_CONNECT, RDMA_CM_ROUTE_RESOLVED);

Thanks,
Jason
