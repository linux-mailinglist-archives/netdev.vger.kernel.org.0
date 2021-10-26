Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE03343B6F8
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 18:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237446AbhJZQVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 12:21:14 -0400
Received: from mail-dm6nam10on2067.outbound.protection.outlook.com ([40.107.93.67]:40502
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237458AbhJZQUf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 12:20:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XUstDOblQaIBB0Hh4Nlmkc+330Kz/xb1AW4X7yBUjsFht6Sdwi6KmvA1Un55avUHx27auvDm0IELvjXC5CWZQszkKobq6j8P03EWx8dJW/iJ8fibohjruZ0BS5cwdoKbgoebVD2mYCp3PG8MEg9miwzLJcUPP3XbPVtcp9TtSsMUOZ9A9MjodbhXilYa92Awv8FzzG0QRHzLNawyncY494593Zj/Raymqd0J7qrjZ2c8+V7aLRrztWVfDlAAncb9jDcI70TyXih3Er8wTDDxAfXCUMfi/xphMVr7UvYj3wqsYW2sAUdf3CjtfeDKMti5OJQc1WGYnc0K3iNLlLpbOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d0ODQ78RHOVo7bgYr67q2uiVIITOMbeFoQ3l9WqApRc=;
 b=IzPzpguTmfK+pOeM4EBm3PWW0pI87Sg/gr4sQO9WsD2BZ+mIurWchbaFVAVGLbIVX04Cx++A8ZhNnS+mQjI3VPDbiw2HvkpsmrlxhQd7h6hVjvSnLDkKp//z+BZSegQkozzTSljn1ZuY2LLmEon7zx9pCoSayvzI/1mJzEF/0wY/VJJNd2ua6p4hvG9xqPrgdzDdRvu7vcdkp3UUL9UoY5Bir8hT5Y7DnkAUOTNcyByPH9Fvf4mLfQL51mQ75OzbkR/GI0FbQ+AiUq0lAp6oI4FQf+ituiX/Dhwu74FYoXUGPAkO3LJVf6OHcUh3WNCVUkClbIFLI+ySVeaX0UdYHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d0ODQ78RHOVo7bgYr67q2uiVIITOMbeFoQ3l9WqApRc=;
 b=U7HdZXFMbGi6MVez/fRxRxgR+oBs5eHWcXhNks+2tbtnx8sP5HuuROWincWkf7qfDiHm+PaWBAN7w9eFj/DknYVPq328TjrgbB7SwZCo5l6Buph5toNRA6JW+ln36Cz5n3h3PjoTzv1LAlVidW0WBtJqXuCsn5rh3IgzW4PDccvBarxfMn+3q9t5ACWmwsSL0ltd4QchOdFx63sT/DVNqMLFlGmBIMrQ2NXq+WvWpe6BRUglql5/MYrEMaJXmk2xqwHNFIF0jOgPs5THzzd1rGCsQNZQu3qVs9h2keUPIqJyeI/h7g0Uobb0TEBh22YwU76iaA0aHQBZwLCUTX18KQ==
Received: from BN9P222CA0012.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::17)
 by BN8PR12MB3585.namprd12.prod.outlook.com (2603:10b6:408:49::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Tue, 26 Oct
 2021 16:18:10 +0000
Received: from BN8NAM11FT007.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10c:cafe::5d) by BN9P222CA0012.outlook.office365.com
 (2603:10b6:408:10c::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend
 Transport; Tue, 26 Oct 2021 16:18:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT007.mail.protection.outlook.com (10.13.177.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Tue, 26 Oct 2021 16:18:09 +0000
Received: from localhost (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 26 Oct
 2021 16:18:08 +0000
Date:   Tue, 26 Oct 2021 19:18:03 +0300
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
CC:     Yishai Hadas <yishaih@nvidia.com>, <alex.williamson@redhat.com>,
        <bhelgaas@google.com>, <jgg@nvidia.com>, <saeedm@nvidia.com>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>, <maorg@nvidia.com>
Subject: Re: [PATCH V4 mlx5-next 06/13] vfio: Fix VFIO_DEVICE_STATE_SET_ERROR
 macro
Message-ID: <YXgqO0/jUFvDWVHv@unreal>
References: <20211026090605.91646-1-yishaih@nvidia.com>
 <20211026090605.91646-7-yishaih@nvidia.com>
 <87pmrrdcos.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87pmrrdcos.fsf@redhat.com>
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a91d2cd-0961-450f-4e43-08d9989c33da
X-MS-TrafficTypeDiagnostic: BN8PR12MB3585:
X-Microsoft-Antispam-PRVS: <BN8PR12MB358571BBB942B48BD8760C06BD849@BN8PR12MB3585.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GiBO6fAvA4166Zzq33KxQzltAJqe2rZAk3ahyIult5nrq60yECEOg+r0qjt77R3cgjOvzg3HwNZgkUtrZfKcJ4YBDr31bhM182np0UeSKTDsG14I/MzC0H5IIghkDZtQptPujQw7iNM1+GzZeqSyPDudaOfizyN34IFRJJ0ZE37zvqFzLrkpwzqsGOzj2cnP1PkfzDL0tFq01b5Aha4Kj6p3T1+WLw3TwYy7M7v2o88Z7tfCMVgR4OOrpeQ5hUzHMW2vwAoRClbd6Vo5BXsn7Z1zB8C5trcCb0B/wuRV4j+cmPkaCfznbuLmhxCgha1gygUz0g0UOhZETE2rjRawUVNz9B6EiMPwReWNZOUGElw3kzo4aIxDEpX3sZgfsi/3mfk6EJZ4PkUwfpr/ISzGIfTbiJJ0qS2YqSwnQAjlGAKQWt6gW76DaoEWkAgwRpB0MJ0O0hh/KFH4lpZKiCqnt3YMfC1gIN3Qda1u+Y8fWjJQQr+qO7mvQVtqx1ATCQ9kpZ2VzvEeMvgt4u/Colj2RBz6noxa1sCautNGWOwCIU9dGUYJJWvouaXunLmIE2C1DRbXqNY5Ic7Ihxwewt1pjQ2ej9SnuzkoKhi8yA49NxLWVMOy+zjE48e+OCWl35PPYmE4+D5fZi7XOS2POGwcvK56gRFYhGgXjrBaqvm0V+jdRqnBfN/XbdIo6eSqRH+BwcXDwpW40no/lHLZmzIg9w==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(7916004)(4636009)(46966006)(36840700001)(16526019)(7636003)(316002)(36906005)(356005)(9686003)(186003)(26005)(8936002)(336012)(54906003)(107886003)(6916009)(33716001)(8676002)(82310400003)(86362001)(426003)(4326008)(508600001)(6666004)(70586007)(70206006)(4744005)(47076005)(5660300002)(2906002)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 16:18:09.9812
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a91d2cd-0961-450f-4e43-08d9989c33da
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT007.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3585
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 05:32:19PM +0200, Cornelia Huck wrote:
> On Tue, Oct 26 2021, Yishai Hadas <yishaih@nvidia.com> wrote:
> 
> > Fixed the non-compiled macro VFIO_DEVICE_STATE_SET_ERROR (i.e. SATE
> > instead of STATE).
> >
> > Fixes: a8a24f3f6e38 ("vfio: UAPI for migration interface for device state")
> > Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> 
> This s-o-b chain looks weird; your s-o-b always needs to be last.

It is not such clear as it sounds.

Yishai is author of this patch and at some point of time, this patch passed
through my tree and it will pass again, when we will merge it. This is why
my SOB is last and not Yishai's.

Thanks
