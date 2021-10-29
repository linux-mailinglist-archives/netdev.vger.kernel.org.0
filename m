Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 628A443FC1E
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 14:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbhJ2MSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 08:18:31 -0400
Received: from mail-mw2nam08on2062.outbound.protection.outlook.com ([40.107.101.62]:25229
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230273AbhJ2MSa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 08:18:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RNzardo45XK1FRpaRcLL/cGrEDa7W+7eFkcEBrATuzme9xCWLbQQo5E8TAs0xl/XznM/BIQzJo20c3kRgn+/bN+W09e0hwxhgp/a/fIH6T7JctHY4eu93ouQBavudf6mz2vCHwiBdBSxBn8EaGgqjb8gR5XiqeOPNc9TAQq//wP1McZ4FUeY336WudAUKkCfcsrXVnLq5oqaWzAqUB1POMYE/Mk2CM+KRlb/jE3Psy6/vCmuuAPtjdjfUddhl2GNZyBMMK8ZybbCQUuAsrKeGCpYN4LS/iHgO10pjyKGRWYWx6CnEShlI0abFcoa05O3K0B+fn+Y80WYmG0tHlitoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2szVzSvSrXYwLvnFCSeNlh6gzkgRif0Cv3vTrhdPmb0=;
 b=JxEZ2gjZE26ttUAGImfoWqGcaaNaJr8iM39etlg8pCH+STtFxWFsaWx0MOFdFT0yWVR6mCFmaWwZJGaKXdkC5wjIX6D234rlBlMxAbAhRcPltQjhbfyS4NooalxhWLi2phYs+QQwNPFAWqVLDYo66lE5upmcDkNhH5BeNPAFg4At1WmvsAPLJe3FoOghWu4TK/J3ySwPNhQk/cQMqpjnY4tqNGn6aIYkEdnqs2TosgleBVshbhvqRHmjxYzD+O7AdJsDk0B640HK2uobgDwWtNlF+vcvDNKt4VCus/S+K7sto6gtmnIUONlfYW/m5KUX1XOIAO6oUQyt538/v6kAeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2szVzSvSrXYwLvnFCSeNlh6gzkgRif0Cv3vTrhdPmb0=;
 b=U4LSxwO1st6BuNYY3zoWi1JClACGfnrRb7BjJ3dIIeGrqso0ao9Lq73em+7vR6BEGfGduhVE8YZ7CvoEFZkFV6X2OWfIxkjK52BxMQL6+ZOUa6nVABORZXcplyu0unspczFXd0LpSTtn5g5YkbgY2AABei3oQrgw/3Ea0OWmLOTOTR2S+A4WITa8RDMWRVIfcyFunh0w304m4/hBeqUHreHsN01UllUWb6TaC92vP9AZya5mMmVsrLSnIIdH99kkWLF+pJX6kg/cQ9pmh7aQyF8h0fjJZj3NHSuJaqYapyKvLGwLgpr9u4NBcXycSI3lCF06ERy/PN42vN1UVdXSFA==
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5223.namprd12.prod.outlook.com (2603:10b6:208:315::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Fri, 29 Oct
 2021 12:16:00 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4649.015; Fri, 29 Oct 2021
 12:16:00 +0000
Date:   Fri, 29 Oct 2021 09:15:58 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Message-ID: <20211029121558.GU2744544@nvidia.com>
References: <20211025145646.GX2744544@nvidia.com>
 <20211026084212.36b0142c.alex.williamson@redhat.com>
 <20211026151851.GW2744544@nvidia.com>
 <20211026135046.5190e103.alex.williamson@redhat.com>
 <20211026234300.GA2744544@nvidia.com>
 <20211027130520.33652a49.alex.williamson@redhat.com>
 <20211027192345.GJ2744544@nvidia.com>
 <20211028093035.17ecbc5d.alex.williamson@redhat.com>
 <20211028234750.GP2744544@nvidia.com>
 <9db8d3e50a6f4fcc860e5500b899eeec@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9db8d3e50a6f4fcc860e5500b899eeec@huawei.com>
X-ClientProxiedBy: YT2PR01CA0010.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:38::15) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by YT2PR01CA0010.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:38::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Fri, 29 Oct 2021 12:16:00 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mgQne-003Raw-Of; Fri, 29 Oct 2021 09:15:58 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a9584b1a-e610-4628-c801-08d99ad5de96
X-MS-TrafficTypeDiagnostic: BL1PR12MB5223:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5223CC8F729ED03CC0359D35C2879@BL1PR12MB5223.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2+upSEpv8xrjIpCZUFqewrGKN7IopxHE9t/aAsJWis56dsC0T3jf5pE5B9miXqr4qvG+HWM0N7qlraSFxfF7zSVFfY2EG5ohDPhKPeJils/dhFWdlB66mrg6FAU5+y2TrmtFBxQtJu9V21Tp33Mv4QRFyMfomxGiv4IRNEIZaUHRdjmHl1iitTyfFL50gG1n7AVXDNlKUkRZaVqdhfhK6x6JZ009HAwoLheKGvM4OTyuPXKuCXHeDyaApFM9GtQdzcEfFhsV6U4jWo1WJoVVV73rT6IKwCMbq8dJR9Hew+HYu9qrmX+2M6oewLk4jbRSBox8iwFsd50zeTt7lq3xlYKiJnxGRRaDBgdetNOuWU/yRt6fyVKE6dbblYi7pQI8eLjjthDYr7ouJxNZOjkz+vQuOqB/a1VCA9p21n+qeWqVtGFdXdtbw/eM9ehp0dSW4CO6c/1fpUwvooLtxQ26F6jfZi7+xNQLQISUHRZsa3ggbPtStxWlVSX6puisjNFDqFzMJyY6GKeWThGMy8quYpW6MWFUpTANiPRHGqeFK3dJrb3ryQc1oSCiyIoYbKT8nxFT1CtM+k/wUGwPz79KWjZ8o1VvNE/rGSgKUzZ6Yo1eIESl3P8DqenmGRor5HdW+aAvGmtJtKxA2bFcLJhzjg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(2906002)(6916009)(5660300002)(66556008)(186003)(8676002)(54906003)(316002)(36756003)(66476007)(38100700002)(4326008)(66946007)(9746002)(4744005)(26005)(9786002)(86362001)(426003)(33656002)(1076003)(508600001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EompPoXodTrYPJbIjPL4JE6khp3BwBHACgXSmwxn2IVR4/MXT09wQ+5Lewor?=
 =?us-ascii?Q?VDGgEVKPHazP+AcBQSV20gXSTEQvXhanvTUIhFm8iOuMGma7s9IP8fAgHmys?=
 =?us-ascii?Q?OB4uaIGBlMPfrkh+LfT3XLUbBV8W3z4sfh3EXtAk80qnkUKWpnKgB6Zi68HU?=
 =?us-ascii?Q?a3t6DbXfFRXcrJdRL7Ug5OAYmrZHH7+eOi7IIKZIx4NEN9cdU6zpjSRx5HKL?=
 =?us-ascii?Q?areHVg+ccCgYzmDZx1xaznGouAPe1w2XSq4O8CjLc7LNvMN5PnUYUnr0R29S?=
 =?us-ascii?Q?/OJ7n2TywZJs9qvpV6D06WqTn8KDuzTUsi4EU9m8rYlMOySgXmVp4Gu3+F8n?=
 =?us-ascii?Q?EVRBYXl2ic9Q0O6Lac6gZTbn4CTTCbuVl8GOSl+hYN91iWN9R8I4kYC0NADd?=
 =?us-ascii?Q?MyQGmV5/Bz3P7jawyefDYdjsM42rCV3VpvTW/0zHR8H4DFwl50BwDrJyMCVp?=
 =?us-ascii?Q?K5zQKqGIgFeC2O72uQdAZAdf3Gb5H+hbSvbxtihbDeEQAYytaOOkWrYH/BN3?=
 =?us-ascii?Q?yNPcK9CJ/rgqncGHuEGOWH5ahoTY2tgbwXO/+6wxjqM/4ybbK9eOlkSfIB1F?=
 =?us-ascii?Q?pF6a3gqwxDegaCAIg80rkra0D50Xtret7HEV7aZEPWmk+hxLEHZyZUR2xDf2?=
 =?us-ascii?Q?H8kBigKgi+AMwqMOr9Hl1+kqO4E6vkjFn/bIWmWF+xztl4rdQ+eE13hwRPYR?=
 =?us-ascii?Q?17KPIGiKPLoMuw5lVRuwKX1CI9ZxB1W2SU+WMO1F/Nto1zJXBLduldqwwvdr?=
 =?us-ascii?Q?xviO5QUYMqyMYEBQOaq4XMdAH+tlqLSb4nRdjdeDSUI2fD5YIvP69VG2h35f?=
 =?us-ascii?Q?Mxk3dHSEvhS8T4dTNKuoyW7a42FjMW+NWCwoX9dJfnt+AeB6cJplkVVpPDcz?=
 =?us-ascii?Q?DLCfDScicChIUP/pn7bYHpavbe5IoSoBvRPl861opM7rPutKrycxkW9kPWOL?=
 =?us-ascii?Q?SiR5PavG9c83feP0ggjwx8L0+PEFaXIviYsYEFvIrT17FfSsCf1s1BC+Qsx9?=
 =?us-ascii?Q?fA7+u0dwyOHMi9DtxC/8PbwEaeuITpc/A2rm9OQQz/rjHMuXSqOXCcczVVAg?=
 =?us-ascii?Q?JrVLr60VX6TYLfnafb27CGG21eo6OfVz8G65TFrcjTDxH4rj0IP3CU8PIsTo?=
 =?us-ascii?Q?IoF/D0eu5ZVenSLnz4eCcccgO+0vm8WdFatbbenhtsvT9JSAlMeaFK3pcjaa?=
 =?us-ascii?Q?x5/5UDhhbQqGRyJOTHqUwwAWhW4Zsz5FNadgoHG7dmv9lSAXg+Mdq8JZfUaN?=
 =?us-ascii?Q?5cPbTdo04D+lzFFwiQ94RkXbG+B1uu9L0b10hR2+frZPWJiIJOaM81n4oPyL?=
 =?us-ascii?Q?XB3rCdgTOr/tAkcm9gvYL431qrjgE6AflWlog/UVhKuS5tZiK+NU/mk3eCCG?=
 =?us-ascii?Q?XczuT1a9Br0t/ia7wtFfsRmc5g31RAjOqoNt3pn++e99SOEtXIssBBKiFqJU?=
 =?us-ascii?Q?Q5GZiVbcjg+Mo+2RoZENd6n52ieXSVTxQhj5sXsnjM7JQDQoly9CXRwuMddl?=
 =?us-ascii?Q?INkrNATrhZViHBxus/BXwhZ0+oaqROBRb6tw/Rkm3K9snwFx2v7i2WPu7xEs?=
 =?us-ascii?Q?+W7KZQahZVrlQ/8R5zs=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9584b1a-e610-4628-c801-08d99ad5de96
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2021 12:16:00.4423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4vzKQkVn862uQclVPSFevMmY/g6IyVYtkAvxb894k3gXVZtoA0KlVt6GnNbpFNbc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5223
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 29, 2021 at 10:32:03AM +0000, Shameerali Kolothum Thodi wrote:
> Just trying to follow the thread here. The above situation where MMIOs can be
> further poked in the !RUNNING state, do you mean poking through P2P or
> Guest/Qemu can still do that? I am just trying to see if the current uAPI fits well
> within the use case where we don't have any P2P scenario and the assigned dev
> is behind the IOMMU.

The way it is today any VFIO user can poke MMIO while in the !RUNNING
state, no P2P needed, just write to the mmap.

Jason
