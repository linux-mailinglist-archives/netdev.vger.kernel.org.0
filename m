Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 736C2431824
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 13:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbhJRLxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 07:53:22 -0400
Received: from mail-bn7nam10on2085.outbound.protection.outlook.com ([40.107.92.85]:16821
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229569AbhJRLxV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 07:53:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EMAfjh1Ot/SuDQMh9L0YOAu5VvM2t2ZKDEK+IvXw06rEZX2IUgkL5cfgBaBVZZdA4vkSXayOQurtuIaXnXl3XstqFZ2MZ8tou8UzrETpNEccCc1S8J121XVaZiFixXymuDFEwb3GWaLRI722tTv5UTRu2qp5Fv2kycGXXVIuHM0eXdOau3DMHG/LXonDF9HteT+bzPFwCNA5yhP6+UHvnvsio1WteUVuVK9MO+sOf/LpyBBifw/G1zJBU7nDL+EohD44AKbDZWaHokkOBmJWd3cH7JqQPMOnlNzgN7wG1HtQXjMqI71WE2mt87pPkpn1XAaF4RA2Ym8rHYKsNMFbyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l1aKkvd4m1RF/M8NQ6yZqzophLFrD1SUrHetj0Ib9T8=;
 b=Qfb4TsxEaB50uI3plWPRPXjG3gA7kyhG8zf2zX4sjpqmSpTas7pQYTnpKQ7bnf4FU+sWvS6ftQBgc6g0HESipOsE1JjzmfIUGRNfYDO0G2FZ/ShMvBa/7AM1crw5JHa9Ylpy2aowsVnTvl9iiBHuibAlS28iOHyXi1DW1ezm3m0Jms03UIQltfUMwZ81xH6CDNvne5pYDvZ0wcTAKukC/bKQJ6+J/1Wb5eWJtLBIMHdH+2z6XpSh2XIqVbMDaA9Tv6QZkgltB91Q5V+a5sXeWY+UKD+09Do4Q67tGyV8Nrh1jCZ3eE/KZOWT+J9DSCOfCGoBB5A0zGP6sKmBJEBl/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l1aKkvd4m1RF/M8NQ6yZqzophLFrD1SUrHetj0Ib9T8=;
 b=TJdFadyb3Q2S9Tgw7jTvypQtEzPMqZfNIL98Z5xUBF0NRjRZS3Z2lagR2EX6eRpHcyfxNtsqYlrge4ZE+mroEUwDahdHj1ag0jMcF9nz5n8WUe7BLD1BUysXIkZIGJYZCojDEmBJm24IOzc7GrdHK7G+gz6Y0HCayrMuaW8Zb0Gp0G73wY4SmrfpWkKwAEsgNbJrjan2EXfIqyTbnNxpVgiU9fCIToUCT369UZoKWxhPwA60eko74jjzGjS1mdeOhwpPgvqWrmlp9sRSHC3xw+QSomf4BWHyaa4DrAfblIZpbv9ETw/+pcnE6ERnNIx9l0aGDkaO+CJ7uz4WkSXeKQ==
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5080.namprd12.prod.outlook.com (2603:10b6:208:30a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Mon, 18 Oct
 2021 11:51:08 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%6]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 11:51:08 +0000
Date:   Mon, 18 Oct 2021 08:51:07 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V1 mlx5-next 11/13] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Message-ID: <20211018115107.GM2744544@nvidia.com>
References: <20211013094707.163054-1-yishaih@nvidia.com>
 <20211013094707.163054-12-yishaih@nvidia.com>
 <20211015134820.603c45d0.alex.williamson@redhat.com>
 <20211015195937.GF2744544@nvidia.com>
 <20211015141201.617049e9.alex.williamson@redhat.com>
 <20211015201654.GH2744544@nvidia.com>
 <20211015145921.0abf7cb0.alex.williamson@redhat.com>
 <6608853f-7426-7b79-da1a-29c8fcc6ffc3@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6608853f-7426-7b79-da1a-29c8fcc6ffc3@nvidia.com>
X-ClientProxiedBy: MN2PR15CA0011.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::24) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR15CA0011.namprd15.prod.outlook.com (2603:10b6:208:1b4::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Mon, 18 Oct 2021 11:51:08 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mcRAZ-00GFJi-7o; Mon, 18 Oct 2021 08:51:07 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7b18491-b35e-465d-0df3-08d9922d92de
X-MS-TrafficTypeDiagnostic: BL1PR12MB5080:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB50807F27176CEF9A8520EA32C2BC9@BL1PR12MB5080.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ACOw/G6/CD5s850dDHeGqK7NgX6LikhKVynHBtWU5VGwJxyzYSKO23gJ9duOEl+5GP+A/FrLeEqzDSsu2QmnpMMkjSZIp5JurX8zSRdIoMhtRA3Q8vwJLRPXLLhreXem7c7FLvVu/kn9Df+axpTtQ7FeX13py7n/r4ps8a0FAHXVntp4JPEKTba6T9H48WKn+CD14sqYO+DHR1cgFCh8tTd46r2Otb60gImDAlsj3ZQSU231qlTG1BZ2oS1P/hhPSiQQMIbWcQSn//bdGxrkcwa/a4grOjR4x4Wf0sC6ZiGmptU+xCAfAAf+2PZpnBo0tlxwsmf5dq5EwuWzEBbm1J/XJBXyYm7Gx9LkvPRIqSqbglh2T550CuazUf2ivXTCkj9RIsYm1jH0+s/mmIuBBZ81wqZ1q4296cCQ9H7uwuxQMaVRRUayHH4bISostOU1/WkdxkNg9yWZKXCuOV+phkFDNrifGIKCDJ7BDFcdKNEI9q3hbuc0ClY8Ue+VlcHW15WrVDL9xDImM17ftIwZZTCRNls7earTOM095OOq1L/nywozpVj90gvct42Bn2IPxZbhagu6q+2+1Z7hluz2z2oboqjA9YhdTQt0HWQMo0L9Cc7F9wG0cmCiVJfL5UHRbez8kgqOa31hBN4oB5qTig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(66476007)(66556008)(2616005)(107886003)(6862004)(508600001)(33656002)(9786002)(6636002)(5660300002)(426003)(2906002)(316002)(26005)(38100700002)(36756003)(186003)(37006003)(9746002)(4326008)(1076003)(53546011)(86362001)(8936002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n9NIR19rGQVU5vOtlhgOkWLvm6qRBCo7M1fs34P6ZCQZdfIBkdjvP2striYr?=
 =?us-ascii?Q?zrWDRgYRwJAnfUKAGiVYc/Jp7Eyc1wAMztXEEKjV84ZetL4KXUNuL3Ilv7ua?=
 =?us-ascii?Q?fkFpfDQyNktf9tvmO5SIipVWI1dWxboN/zXrHR1AAtIiTlg5tVmSqaf1XerW?=
 =?us-ascii?Q?+JyHt2VsNnblDQWQWRNsxzYjbkf5l3wea4XjSNdWMOtSLnUXmH8DTsQICpZy?=
 =?us-ascii?Q?w1C3RPz4phtlqof0XQj2a3RzlZgaba3Ceykd4SCjuMZ2Iw8UVWkGk1DXotdF?=
 =?us-ascii?Q?O8lFnND4H2aZZox7EArf+rJBllKntSzWbA9SceTKfyMNtmy5m8uImh5BBoAs?=
 =?us-ascii?Q?9t79vcYjw0k2q9jlpTQNYN+g8nT06s2mDEPl5laSTx6a6SSAiDqspyExgH7D?=
 =?us-ascii?Q?QtHNwtu+1XsHR3q3yBMYla/1bX9pHqbUh0H60FRpdAK+37FMTcjzJIYPw2zH?=
 =?us-ascii?Q?VnOkYeBNmhmMyVX0FaDvEgMPyokS51LDgxbJz+8bx7G/bgfwjENiL2fsARWE?=
 =?us-ascii?Q?LSC8HKqFFZGoe6F5TgstOYtx0TnYKPYCVKg4GqFriFVQOjwccBWwh8EJjGsE?=
 =?us-ascii?Q?EUARgJ7MggH8lxf1RRGD3GXjo/setNJGt48el9OvJCU8Ib1xalws+675kl/r?=
 =?us-ascii?Q?+M5nhrqbA9jLUtmnH3qAThimc8zYdZeiEw6y28dZu4VH8HstQ/6h8GTwFFZ/?=
 =?us-ascii?Q?xLyQk1rfptvSnuhlMwuHbTuAmZ4tTB8YFZJaLqT59EBGkfVFhD+5k3PKg/3g?=
 =?us-ascii?Q?OJIdUbxqBsHfJbKRqFS50AdxJXGT+NFNzJ0Ak4bR0VsY7/KEHHHziiGuJoME?=
 =?us-ascii?Q?qr60HPjJqEUV4igzSPGrA1orJp2SPidYk8alNuDIvzjN6QfGVASkAVaaz1NB?=
 =?us-ascii?Q?Xkh6X5AT//Vo6tZ546pKAREtPD8ZY9/jRNejLNut6Io7Y0ud/ybqv8VYtqKR?=
 =?us-ascii?Q?xZXjDghDKiPWxzBEF0IZPArFy2Tbq2+JwirpDkcIq8BOPwJGuuB2KqwE1Ny1?=
 =?us-ascii?Q?fzpdS4aDtPN53xUkJu5PFEesdIkljoIesUmLNz9LU96kBwLisEI5T2+Pzu4k?=
 =?us-ascii?Q?2Sbb+vqgzYcdHxHQElhCWWVOpNbx7wKAAWKHGBsO3lF/AT97cYnVNROq9jDm?=
 =?us-ascii?Q?4IpU9i4YLolZiPKxIztlJUlJf+7j68H87Wv7WavTPNQHQ9D8PWbV6Y6I4Z3j?=
 =?us-ascii?Q?ikoqdAQhBGbuXvKKjFKHKAaq88UFyrjyEG6C+0djVSh+CmYbv1d7qpAWaR8C?=
 =?us-ascii?Q?LCBi86ndKV/9SAQU+wDr5N4GQ8lg7S/QYXO1d+obM7JJBGuRTOL8JZiJKNij?=
 =?us-ascii?Q?jji7gZ6puh6/1sXqjuYislco?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7b18491-b35e-465d-0df3-08d9922d92de
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 11:51:08.6667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hOhkfY349nl2OmsvvxcJK3wbz/mScre6Nkk7ia8lUrbzaFDnFqAOSH+CFrHK+lio
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5080
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 17, 2021 at 05:03:28PM +0300, Yishai Hadas wrote:
> On 10/15/2021 11:59 PM, Alex Williamson wrote:
> > On Fri, 15 Oct 2021 17:16:54 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> > 
> > > On Fri, Oct 15, 2021 at 02:12:01PM -0600, Alex Williamson wrote:
> > > > On Fri, 15 Oct 2021 16:59:37 -0300
> > > > Jason Gunthorpe <jgg@nvidia.com> wrote:
> > > > > On Fri, Oct 15, 2021 at 01:48:20PM -0600, Alex Williamson wrote:
> > > > > > > +static int mlx5vf_pci_set_device_state(struct mlx5vf_pci_core_device *mvdev,
> > > > > > > +				       u32 state)
> > > > > > > +{
> > > > > > > +	struct mlx5vf_pci_migration_info *vmig = &mvdev->vmig;
> > > > > > > +	u32 old_state = vmig->vfio_dev_state;
> > > > > > > +	int ret = 0;
> > > > > > > +
> > > > > > > +	if (vfio_is_state_invalid(state) || vfio_is_state_invalid(old_state))
> > > > > > > +		return -EINVAL;
> > > > > > if (!VFIO_DEVICE_STATE_VALID(old_state) || !VFIO_DEVICE_STATE_VALID(state))
> > > > > AFAICT this macro doesn't do what is needed, eg
> > > > > 
> > > > > VFIO_DEVICE_STATE_VALID(0xF000) == true
> > > > > 
> > > > > What Yishai implemented is at least functionally correct - states this
> > > > > driver does not support are rejected.
> > > > 
> > > > if (!VFIO_DEVICE_STATE_VALID(old_state) || !VFIO_DEVICE_STATE_VALID(state)) || (state & ~VFIO_DEVICE_STATE_MASK))
> > > > 
> > > > old_state is controlled by the driver and can never have random bits
> > > > set, user state should be sanitized to prevent setting undefined bits.
> > > In that instance let's just write
> > > 
> > > old_state != VFIO_DEVICE_STATE_ERROR
> > > 
> > > ?
> > Not quite, the user can't set either of the other invalid states
> > either.
> 
> 
> OK so let's go with below as you suggested.
> if (!VFIO_DEVICE_STATE_VALID(old_state) ||
>      !VFIO_DEVICE_STATE_VALID(state) ||
>       (state & ~VFIO_DEVICE_STATE_MASK))
>            return -EINVAL;

This is my preference:

if (vmig->vfio_dev_state != VFIO_DEVICE_STATE_ERROR ||
    !vfio_device_state_valid(state) ||
    (state & !MLX5VF_SUPPORTED_DEVICE_STATES))


> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index b53a9557884a..37376dadca5a 100644
> +++ b/include/linux/vfio.h
> @@ -15,6 +15,8 @@
>  #include <linux/poll.h>
>  #include <uapi/linux/vfio.h>
> 
> +static const int VFIO_DEVICE_STATE_ERROR = VFIO_DEVICE_STATE_SAVING |
> + VFIO_DEVICE_STATE_RESUMING;

Do not put static variables in header files

Jason
