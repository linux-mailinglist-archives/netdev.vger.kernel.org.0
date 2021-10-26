Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B62443B216
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 14:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235781AbhJZMQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 08:16:22 -0400
Received: from mail-bn8nam12on2049.outbound.protection.outlook.com ([40.107.237.49]:43841
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232736AbhJZMQV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 08:16:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QY+3e7i1xvTCrMIilD5SK4cjEfsiPTBY2PZvLXLtqCHlz3WUictVa24sO/OBpYYEaSXge+OYAPfp9jxlXQbMEzsZKuC7f2dCBIiS1Nj151sUVpGq+sMlrBjXOfl6Xdf8l2Egr5wTEULmLbYjcf6JoNJXUPVBujsqSlDidry/LN/okl9zuAFW4u9tam3KBlbgCFqoA7AXKawa3Co+DkFGIvqyYS92wnw9/+Qadsqkpu/I8HKybMq7nmHC0B4/HviF/d1QYxn3FicU3TVjOB/r9vYLOFy44fWeqelzsVT4EiquDM9KyHBiYDVcifHnQNEapP8/qiSOOw5BhXhgZKm9nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aQJ0lS5JTeulImAcKrSWECoDse0r+OiTTVVKgout/4Q=;
 b=lHToC/ykE/VvZblsf0E+shpVJvRaENeLZvVUZ/iE87HGGAoKIcUJ2fdphjUxcI5EksgXGyzoHrFQfMhkOwVAUacLQZ4l8r2phaP2dIzkjKF4GTsnYq/jwrlbAx97wjrGp1D5Hbd9SnsOSUHgr7yrVDk9N7Cv/M79Xy5+2oPnt0Z/C33eS9oGfN8e6dv9ubu/9MfaNMvn6MfaFwixuVs9SLnuPfUW2KHtChCMea1O9ykDj86nl1FjT0Es9dZzXJbUttMjR2Hk7cK1n9HsjkBFpemxErXO6ASe5bH7NOMrmhckU9nIgmnpSF5moafdxUatHlhxed9dK8fVKvvHFedbrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aQJ0lS5JTeulImAcKrSWECoDse0r+OiTTVVKgout/4Q=;
 b=W5YPJMgbqT301wzafeQfpXOHM3Da8SvCcaJ+u7MNP73zp8oAMvTMztgJrZr16WelKEclUqtt1FfOXVbtJ5xpGytya3FS3GZCEqT/1JvR9OEGIueflJCJRr+o1vnHcjhIL09yIIhtbBzk6kG9JL2jMWZMbnBLYT3yOXd5AcikFAC0nV8fR94TOIasFrZbkMVv7spVI4owWwZLKkiSTEVXkYJSbvlo6pJ7CSFm/kszykvqzdim7KydCC3xn4usRDfNA1ks14Zgyey/OfaDsPwLmHSt107R3m0Oa5MFvaADg3jwK76dXQwQMh+xS5hSjQ/fVFk7L+xKYALWAONh3VAvkw==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5554.namprd12.prod.outlook.com (2603:10b6:208:1cd::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Tue, 26 Oct
 2021 12:13:56 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4649.014; Tue, 26 Oct 2021
 12:13:56 +0000
Date:   Tue, 26 Oct 2021 09:13:53 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Message-ID: <20211026121353.GP2744544@nvidia.com>
References: <20211019192328.GZ2744544@nvidia.com>
 <20211019145856.2fa7f7c8.alex.williamson@redhat.com>
 <20211019230431.GA2744544@nvidia.com>
 <5a496713-ae1d-11f2-1260-e4c1956e1eda@nvidia.com>
 <20211020105230.524e2149.alex.williamson@redhat.com>
 <YXbceaVo0q6hOesg@work-vm>
 <20211025115535.49978053.alex.williamson@redhat.com>
 <YXb7wejD1qckNrhC@work-vm>
 <20211025191509.GB2744544@nvidia.com>
 <YXe/AvwQcAxJ/hXQ@work-vm>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXe/AvwQcAxJ/hXQ@work-vm>
X-ClientProxiedBy: YT3PR01CA0106.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:85::17) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by YT3PR01CA0106.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:85::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Tue, 26 Oct 2021 12:13:55 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mfLKz-00248u-MH; Tue, 26 Oct 2021 09:13:53 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9eebe8fd-f118-45c6-1623-08d9987a1516
X-MS-TrafficTypeDiagnostic: BL0PR12MB5554:
X-Microsoft-Antispam-PRVS: <BL0PR12MB55546664BFB99136AB37B21EC2849@BL0PR12MB5554.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: od3Sd1fvn3ldbPK4wSEXD0pk7wJXPLasFw44XVwS70eDrHmFSaq3XVB5AJqK82NjB4UU4QOkTiZ4jJvbgUCAi86PuDAxZEdEVAO2+nMtKXnNGb7gQGznqAnnuI403sie7UztVCM+B4/LeQUHBJ8ZF5GSheQ4Qgk8XGPFkegylC3hUcaKkb/Vgxhd6yrEUUigeuicbRL2dxgksA5ciOIqnOHqSJsTrrOHtyI3MpAH9grQMAFhx9PzJaLmfdt961tPPEzt2hqUo3iA9FbheFcbXc2NagFnFn/bsp201IRDHZZbtjhV8mO/myuynTFR7fef2OAOhDPqZjLpj9Flwbh8VIEDFoe2vEwXiGjCr2Fj79KhPv0L+i0NmFUY4b87mAdRTYgO2YC+CLOZqjAQkVL/AQH4IuX13zP1S9Qc8ULyfubJXQouCpJEXLQUZRkGFrc5cr/f99nQR9MNphsjTMbhk6RcVdjlUKJCUDx5jxb7MrVb8yukQsuIUea7du5ZUo5Qqm0Gs9HcT4+O2JVFQDhlzw/06B9FVaice9QinOHGg+Zmek7q6KW3Wc4dFWgSCaHV+dRrz+CG3SLkyCTs5IzJGWFmHT4Bc14h2tsNRQr0jvOX+6hV7MHS0CdVotg2NMsU1/qXm7esQn4Ov5XW+/LM7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(54906003)(186003)(1076003)(508600001)(38100700002)(66556008)(66476007)(33656002)(86362001)(4744005)(26005)(316002)(426003)(8936002)(8676002)(4326008)(9786002)(36756003)(9746002)(6916009)(5660300002)(2906002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6pchqK2tyEaerzbJoOEEH6ZLXsX4bol6srv4BnwrofDc0HzHWTNPYlwOVx5p?=
 =?us-ascii?Q?KXP/B2ritmKHXiN3ZwyU2cfXMXtcvj4lakd+Ig3DmeoOSWSmWfzywRwqEVXY?=
 =?us-ascii?Q?SGGtBct2fTdwXzPQ0foCtD6GhFvNXgKchpcOS7ih4sop4erWQz+0xIdEtSNG?=
 =?us-ascii?Q?5OY3DQnHaNr6beL4zwylJuAR4Ms+nVh1i3dWIFsVxFyffkbceJKqozzqO+p1?=
 =?us-ascii?Q?upmQwZC5nKGyMM9G/Zl53aQw/oYNI/OaUuaSU/tgk2YJnLeULDRFP9NdIPE9?=
 =?us-ascii?Q?FARnmjUeYktD9HQLqT8ymHIaewRBPQmbh9kElnxTi5NoUxV8WgUnKyHLEOpg?=
 =?us-ascii?Q?R/gNiuuacgCA6aFjEY9dnmz/O8iSxelT5Fpz0NrdtGginmdk802gDM2jnRxF?=
 =?us-ascii?Q?yO7vXAmggeh2vF+S5u0q8Rj47HZjSymF3G0Tdl9Dob66boyoVNt3kMotKwwB?=
 =?us-ascii?Q?EjCVYLN422WLDiqVkg/yjDLYH7uC4KctI965OxyjpqfyvIlO8pElr7E0jA/A?=
 =?us-ascii?Q?XNONPq7wVl7YPrIvsnYyldhA8ReLBpr4itmotdWsKWvrAyjIWakljCPZvr0u?=
 =?us-ascii?Q?WRwYLogyhhcTj7h8G0p0pCD/xcU9BuGxhekR6pzprO3SAXJ2zhU8KySanxCN?=
 =?us-ascii?Q?/tQdnWjgfO+7LTHAzXzuc+bkRSGjU+yFULH7c85tEltypAbwvM5MnTwn0ZoK?=
 =?us-ascii?Q?VKmAOd5tZBFkgBjmfGoJ+b0jsGdHuFTKGE1VUC8OqkibrGgVoiFOtV/YbEF7?=
 =?us-ascii?Q?rk5nEsZeGxiWDKHI1JzAfvSPqgun2mHcbGffdjVFT4L7U9ZeGxo3QVEnW1Ow?=
 =?us-ascii?Q?TeEpv0b1RT+7QAHGoIy8tUcxDkymJ8VRCj3ArojcdcCybrce46TogHNqEVx4?=
 =?us-ascii?Q?auIWYVJtZD3fXdygnRuPnULS88r9Jy6kv60Zjins22x4A/WAvMJ7M7PyzFEO?=
 =?us-ascii?Q?lYRYz7jiaV/6npX6W65DLgZNDyBkl0KLF1zaqNq5OSUqtFbrQiEgsQjAMUoj?=
 =?us-ascii?Q?DYlRkfwkJYo320trRoiy0+QoM5Gg3PHC8+sfHCG78/9LacBnlV80v41CnY/V?=
 =?us-ascii?Q?m7Bf+b4yyVHDYSpGBRgg9U1yksXnjNh/G5HkLi+GmjabYjGDUwDxqhAYRKGX?=
 =?us-ascii?Q?d0L82lGaZyPnhxpAXnonfT6Miyex1ZRCf+6sIag1U/xvhXb/AmEXOkEFHCyD?=
 =?us-ascii?Q?DBWOUwTf7EI/X1PE2z2CFvZhFilm+JFP/llgxqCPnBAMguE+MRNikp0RwCud?=
 =?us-ascii?Q?coqOeqTVrBVGjoXhPAFStA/2I5bGgpn6mmd7yFFUZpawTt6PIxLfoSyR0ix9?=
 =?us-ascii?Q?E8F3eqAYyaAq4m23rGPICu/88L8jUTc1cxQVHvrrFNZ68YZ7HwesPfp4p64g?=
 =?us-ascii?Q?r5n4Pyficv6PJJrGJBzIrwm+mESdJlUjm0xxlzmyVN8qe+PtCpfHqfsv80g/?=
 =?us-ascii?Q?2YtHRYIQqaQ+W5dWN2tjbgDyHGK+pGD/xjZC3MG2PZsXDk154U9C23JS2lCR?=
 =?us-ascii?Q?xNwdvp2fnhX17qY/9Jd+ZpIJpurivJTx3pkaf/WyRDlKjTWAljEwatkugiJi?=
 =?us-ascii?Q?OAZ8eAe4UHZOTLYAmOU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9eebe8fd-f118-45c6-1623-08d9987a1516
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 12:13:55.8360
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ttx3jGqGJg005++sYwb+Ist1tkQyNebzR4p85KpIYSvse6l9Ztas9VIgeRxvbooj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5554
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 09:40:34AM +0100, Dr. David Alan Gilbert wrote:
> * Jason Gunthorpe (jgg@nvidia.com) wrote:
> > On Mon, Oct 25, 2021 at 07:47:29PM +0100, Dr. David Alan Gilbert wrote:
> > 
> > > It may need some further refinement; for example in that quiesed state
> > > do counters still tick? will a NIC still respond to packets that don't
> > > get forwarded to the host?
> > 
> > At least for the mlx5 NIC the two states are 'able to issue outbound
> > DMA' and 'all internal memories and state are frozen and unchanging'.
> 
> Yeh, so my point was just that if you're adding a new state to this
> process, you need to define the details like that.

We are not planning to propose any patches/uAPI specification for this
problem until after the mlx5 vfio driver is merged..

Jason
