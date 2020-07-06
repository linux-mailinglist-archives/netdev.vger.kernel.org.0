Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 981C2215D79
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 19:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729652AbgGFRxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 13:53:22 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:6787 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729413AbgGFRxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 13:53:22 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f0365050000>; Mon, 06 Jul 2020 10:53:09 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Mon, 06 Jul 2020 10:53:21 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Mon, 06 Jul 2020 10:53:21 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 6 Jul
 2020 17:53:16 +0000
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (104.47.45.58) by
 HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 6 Jul 2020 17:53:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hBJmslzDP3wHQ3x+5sRFs1J2knljI4Vb3+sPSQa/mOSYFWmSWKKCJbn9hAVuMMJ54BffIIgvWmMcfZ9LobY24Aaah5OInOHnXEK2ysORQTo8TTs3hrgmfHuIwwbqQDQGTVQaIo5Zq9s4MhRIPKya+WSzrVb1Uj9XD5sjprzwM7PGlRVPAlDFmgTidXsUeodk0VeR9Ch5+r+qU4TRVQZjdMeHosuHd1AFt2HiS5z8HifWOHXNEu07+X055EgmrA0HRxQwHggSU+LQBBiDHclT4zma/SekIn8ND2O6zYq4cPr+KgZuxbJ8S/2YM6lMeLol3sICjgUonqSqZW35523H8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B1gXs6X9ThK6/kh1DWszFBOIQ2TsDfINa8Uw2LIPBVM=;
 b=jRxBCVb4V/JtkddKvbPJrG3PTaSIDAcbCaoUHxV/eSP4wrRWr44ScRavn5/KK0turA3+5F4xunj6R8lCNn3UiJZuuWasSiKgWWKuWdY4Ay3UBU28tGliinFgEmFfJyTXuUV4ZlIh6YXsvU3fHqU7HKuwcTCyru5zvIBIAOOJrtJK4DxWlY1zrfdj0h3or6p227od7nWXXAtOWOjdfFyq8B7Cu5DCHVTUmVzigLaDSeJTkOoKZNmL5i3CvkGxfff8u1Rx5hBC052etIn9dMAFl3zxg6+vWqFY4Aq7+QJwywgPvwL5KBXKlMHP2ayU5c+gcb9z2jlTmXXWImaEKetnzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB2603.namprd12.prod.outlook.com (2603:10b6:5:49::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.24; Mon, 6 Jul
 2020 17:53:14 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1d53:7cb4:c3d7:2b54]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1d53:7cb4:c3d7:2b54%6]) with mapi id 15.20.3153.029; Mon, 6 Jul 2020
 17:53:14 +0000
Date:   Mon, 6 Jul 2020 14:53:12 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Feras Daoud <ferasda@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>, <linux-rdma@vger.kernel.org>,
        Michael Guralnik <michaelgur@mellanox.com>,
        <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH rdma-next 0/2] Create IPoIB QP with specific QP number
Message-ID: <20200706175312.GA1213856@nvidia.com>
References: <20200623110105.1225750-1-leon@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200623110105.1225750-1-leon@kernel.org>
X-ClientProxiedBy: BL0PR02CA0106.namprd02.prod.outlook.com
 (2603:10b6:208:51::47) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by BL0PR02CA0106.namprd02.prod.outlook.com (2603:10b6:208:51::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.21 via Frontend Transport; Mon, 6 Jul 2020 17:53:13 +0000
Received: from jgg by mlx with local (Exim 4.93)        (envelope-from <jgg@nvidia.com>)        id 1jsVIm-0055nB-8r; Mon, 06 Jul 2020 14:53:12 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f20ec05b-965a-4bb2-4595-08d821d57457
X-MS-TrafficTypeDiagnostic: DM6PR12MB2603:
X-Microsoft-Antispam-PRVS: <DM6PR12MB26033EB889720B706DD8277EC2690@DM6PR12MB2603.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 04569283F9
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6+vkrofMJuwDjMBRv/pcbK0DrK2+cBwK545r52hslPngbdRZwOJphVaBiruEqot35CYp0KuOTvZ2bucLbXHwMSzEW9UfU6oetI2mCaXs7Fd5VrmlFGWwSTxJq0glZ7yg27AkZvXu8ELz0LnQW702JQ1NKM17WyjgU2jwuAQn5YHUT0fMJ9cg2LOsFuOLvB8xBSWuGymKn4NC62RxY2orqcxoXv2AMBCpjWJVRQRb8EyNR2fTLsqexcZj7MGOQdKrnJevyhlzfCdHAA6GR29BZNxggkhV6hAfMREOrRUkpgYm4ewwyesjH4g8nLwrveYfugJZTqd+iODtM0RMd1OUbw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(376002)(366004)(396003)(39860400002)(9746002)(9786002)(478600001)(33656002)(26005)(86362001)(426003)(4326008)(1076003)(2616005)(186003)(5660300002)(83380400001)(8676002)(8936002)(66556008)(36756003)(66476007)(316002)(66946007)(2906002)(54906003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: mbsLwAJTmbMvfx/2L5gx62Rj1eGSGHoZYdxsmuRPe+5QFVDf9mKd1VwpBE3AOzfT14hl1qQNNyxCtLV+DJD2MHfaDXepPy4H3u2Qo9L/FvMSIgnVaKrGJSzuHs5HM5HW7wQo2gLmAYaQJH+uHMDVgwyMErFuejS7mHB1C9VLPIkYU51mMFI8lsrZggKbcN4attxl4VswCtAtDC9whV42EVkdAr3rIXqGf1Q3A7SQsO9RO4Qieo0uNk0ToiD/htELTlIrzg/JfRzc3Y9WTMAHLoHW/gCQBLqIHJuj8CPcnzhcfX771uzT1WJbsL2/9wfAxYNXE1t4FCUBBvrHPYbB73IJANZL/RbtQP9LfKIUk84e6o3bPyxDnEfQyBdKC2M/bjpMBUULgmWVX8Jj/uTJ7mIGqcUAaS2kQFlJcxQJ3LwzUQWfbi2EJp3829EtCrDISo30op+nMBL+AVilp2XwILnghEX8pNMUe4oJZ3YA61A=
X-MS-Exchange-CrossTenant-Network-Message-Id: f20ec05b-965a-4bb2-4595-08d821d57457
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2020 17:53:14.0000
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EXdqg9OB369cWXUFn+lIsPx1zFDm8xHizmavZpz5Z9Yg5GDyJS4NZ4zBflNy4i4v
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2603
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1594057989; bh=B1gXs6X9ThK6/kh1DWszFBOIQ2TsDfINa8Uw2LIPBVM=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:Authentication-Results:Date:From:To:CC:
         Subject:Message-ID:References:Content-Type:Content-Disposition:
         In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Originating-IP:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-Microsoft-Antispam-PRVS:
         X-MS-Oob-TLC-OOBClassifiers:X-Forefront-PRVS:
         X-MS-Exchange-SenderADCheck:X-Microsoft-Antispam:
         X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
         X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=o1B8uv+EFSupzHNI+yPzjzHMyBeXun1VTwHoLI7nMoVMZQkW4Fgm6l0/jVFCy5bpV
         9tvbQ46XuW5G3QcrQ7MBLZ+nvdzsCwk+yb8TRnUzIda+uiIQGruWFkKRGcyETt7E4b
         9nWgLVVZGMnyRpsL99bNiq/A/siIOP1WWUKCP4rBozd5suDRWghO9iFjQwLD9z5+tV
         3xfImYlV7ikIPQ9nt8M8KRuoKAWrEcrztjpnbXiDK8dKeFXchEsqEzLXEcE+FyVtdF
         CjdNHxU5E9/2Ninc/2xfehbcHsUH0io1baeU8pm330sWYTt96IFIw0FryccTHQUPps
         KGP/al2eO6bxA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 02:01:03PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> >From Michael,
> 
> This series handles IPoIB child interface creation with setting
> interface's HW address.
> 
> In current implementation, lladdr requested by user is ignored and
> overwritten. Child interface gets the same GID as the parent interface
> and a QP number which is assigned by the underlying drivers.
> 
> In this series we fix this behavior so that user's requested address is
> assigned to the newly created interface.
> 
> As specific QP number request is not supported for all vendors, QP
> number requested by user will still be overwritten when this is not
> supported.
> 
> Behavior of creation of child interfaces through the sysfs mechanism or
> without specifying a requested address, stays the same.
> 
> Thanks
> 
> Michael Guralnik (2):
>   net/mlx5: Enable QP number request when creating IPoIB underlay QP
>   RDMA/ipoib: Handle user-supplied address when creating child
> 
>  drivers/infiniband/ulp/ipoib/ipoib_main.c             | 11 +++++++++--
>  drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c |  7 +++++++
>  drivers/net/ethernet/mellanox/mlx5/core/main.c        |  3 +++
>  include/linux/mlx5/mlx5_ifc.h                         |  9 +++++++--
>  4 files changed, 26 insertions(+), 4 deletions(-)

Applied to for-next, thanks

Jason
