Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0FB29AB59
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 13:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1750446AbgJ0MAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 08:00:50 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:12366 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2897312AbgJ0MAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 08:00:49 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f980bf70009>; Tue, 27 Oct 2020 05:00:55 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 27 Oct
 2020 12:00:44 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 27 Oct 2020 12:00:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g2FwqwmxJ2w/YMUeqxlS/RgBqC7+pqc8Y5WrTpJpxT1GW/9Cefi/yeUzr9VZQPj9KMrYRlSTgL4ZEo4Hjzr92c42arJZ6r66cQ0qRubZ63GWcSQ2sxRPvjbWwsbXfPWeNvCwUinsUIeVmdN0a2cSJIsgIGRkWvRSkOOy3yUpLYpaQ1dWoYVH9nLg3G0ya4jU4QQ6FeGZYHR+2KUyQtlbKDWuztrR9ALuSCA1HqqYwWrMcxtlKKgkHagRi2P/qLTK5lvd6vS0r8H6gOkGP/evwkVzmGteSinFSLrzU3fxY0r2PQm2uSlydIFPme3S874KPVKfVAkPwr3Hjdrrpi96hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qVjL38duaU6sTOh08XTelj0txgnpIU7gLTO6m7WrnCM=;
 b=aFR8GvjzcxB1OMTKHHibPgcm6MmqbLgx8R7bN9g4AbuniUa8CV4H7PGBVd7DX4m12WiaU7cFcSk3sexEDTTbjWNIp3D1JR7P+pG2gUdAS/apUtgl2+wBrBLZr3A3YDKxH2sSZVcg/C6bfeioGpW1R1/SNtw6CX/kXPh1sKkQN8nXcftfeTTZE9hoNSQ+XpiL2vXMlRA0NkyadLBl1QMiUbTqrqY1pnvWoTsVL9PXvlVU+oMphcZEkmxu33DN67EG1oR31jmF6psxZqK6p4gpygfhYss922ypLkCFtN2nwjB49zyonTxrglPRGvSg76VIga7oQx6xyg1FpS3PjlqJAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR1201MB0201.namprd12.prod.outlook.com (2603:10b6:4:5b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Tue, 27 Oct
 2020 12:00:43 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3477.028; Tue, 27 Oct 2020
 12:00:43 +0000
Date:   Tue, 27 Oct 2020 09:00:41 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Chao Leng <lengchao@huawei.com>
CC:     Danil Kipnis <danil.kipnis@cloud.ionos.com>,
        Doug Ledford <dledford@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Keith Busch <kbusch@kernel.org>,
        <linux-nvme@lists.infradead.org>, <linux-rdma@vger.kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>, <netdev@vger.kernel.org>,
        <rds-devel@oss.oracle.com>, Sagi Grimberg <sagi@grimberg.me>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: Re: [PATCH] RDMA: Add rdma_connect_locked()
Message-ID: <20201027120041.GI1523783@nvidia.com>
References: <0-v1-75e124dbad74+b05-rdma_connect_locking_jgg@nvidia.com>
 <e13ec119-3cc6-87ab-bc76-d2d3de7631e4@huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e13ec119-3cc6-87ab-bc76-d2d3de7631e4@huawei.com>
X-ClientProxiedBy: MN2PR11CA0023.namprd11.prod.outlook.com
 (2603:10b6:208:23b::28) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR11CA0023.namprd11.prod.outlook.com (2603:10b6:208:23b::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Tue, 27 Oct 2020 12:00:42 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kXNeb-009GRY-SB; Tue, 27 Oct 2020 09:00:41 -0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603800055; bh=qVjL38duaU6sTOh08XTelj0txgnpIU7gLTO6m7WrnCM=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=ntYWLwfLUxG88YLiEwTYaRecEr1b29TXd+4lQG3FRXrOw0cSffingX5XQMrK45mgl
         50WI+Uy6P+UEJrAgEOsrUItYg8DxX0MyyuWH9suSK+xow4DqP074KUfXu5Vz369BKA
         7DPOmO5Nk5Fy+Te4GODCD5JnQrgoYg9BzluUMwdHQOd3ozOi1mzqh6QIpcns1FiEA5
         cPSdDGm0ooptbHRfX85cRvGwo2S6pD7BS+7Fna3CqBo3wBPvBz+saeHeazmK0dka/Y
         uYcDvgQ6dseaFhQhUw0yKRjeBAYMKiMDADjaxBFiwuUF3ejqh1iYtfSCUSG7JFh9bN
         8oGH7Ke9qsVNA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 10:01:00AM +0800, Chao Leng wrote:
> > diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
> > index aad829a2b50d0f..f488dc5f4c2c61 100644
> > +++ b/drivers/nvme/host/rdma.c
> > @@ -1730,11 +1730,10 @@ static void nvme_rdma_process_nvme_rsp(struct nvme_rdma_queue *queue,
> >   	req->result = cqe->result;
> >   	if (wc->wc_flags & IB_WC_WITH_INVALIDATE) {
> > -		if (unlikely(!req->mr ||
> > -			     wc->ex.invalidate_rkey != req->mr->rkey)) {
> > +		if (unlikely(wc->ex.invalidate_rkey != req->mr->rkey)) {
> >   			dev_err(queue->ctrl->ctrl.device,
> >   				"Bogus remote invalidation for rkey %#x\n",
> > -				req->mr ? req->mr->rkey : 0);
> > +				req->mr->rkey);
> Maybe the code version is incorrect, cause falsely code rollback.

Oh wow, thanks for noticing that, I made a git fumble when doing this
:(

Jason
