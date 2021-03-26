Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E848434AD5D
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 18:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbhCZRbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 13:31:35 -0400
Received: from mail-dm6nam11on2086.outbound.protection.outlook.com ([40.107.223.86]:4705
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230046AbhCZRba (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 13:31:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UQQLEJFQDLumMR7fRipKfrBJRa16J57x7FWaAvzZ0OdhwDvFWhKYU4/5QHt4lOgjWcO4gMNH0L8kR5O5qIIq7jb0+OqKWnEwZyR5ehS6KCqjdVoc16s+blkRdlv3stwtj/2jjEr/xbBTB6VEesSzzPEkkdpdEI0tZsxM47kOFdBospwUwwVAcjY4ZBy8Mm4tV3pD4+TXEp6CMTAjjcCWBwRlpIh8yg3YclZ/k71aoY8O9YKn7qH4NrNzaJjsGpX1vUsvcvr/mylIcrlT9h0y7ip364L51sh3oOJkApX+tFsEwLWdfxq5EzVIQlUGkWWg7F7BiRiqVnSKgHJrP/01ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a69MX+Z0FcRqspSjDgX5qdKG221B0DeFIsf6Ay6XJ3E=;
 b=MMRXLG/zM3B8c4i2emg7A6zOknpByHcM+zRudoXTHzXnAgmX48QBi+qJwRCgC8ETtgO6m1RUcM9soXBTN3OjXgpPE4ZUs7gXsuqj7WrEorpr8fcHVl44k+u2D0a0JUc7p/9AukGCfem5ZD1wd8NIL8Yfdsm4k9inTtfi7Iakopla9XcmogEjA5ICxdcVs7Ph8HKLv4WrtMsxEeDbYeNPFHm771L0gKa6hYSuVjiLpcKtrMUFcArUcSd3/+WW58k3m0RsfPbr4wfFG5XYbqhiRK+QeE6z8uVWXvbx0YgBmL6ZsQhtmCM9IUU4Mxn+ezt6I4b4okZnY/Z+CjwsB26iTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a69MX+Z0FcRqspSjDgX5qdKG221B0DeFIsf6Ay6XJ3E=;
 b=HuEMbzletme26zcQrwRun0tl9PI6yd/YbV8wZgjusAybimqPsfujjupI9P5e4f82kvMKayCzX48497smWPXeb1kvX16nqBD8vp1s5iG3P0MF/xj7DatvpdzQAwpRX7NTzSf0JfXH1XDxMkq45OVgBX3l+LF+vLS5ZZY8WilpRoYxbFL90Ri6yPG+ik/ljNJ29PqDGQubLxf57/8bsIh/mW3EZ2IrDRTkyedITnW3FU/bArCOR6ATVhVRmdWEQfdwMEi5LxBPD4SBC5M8fVEirP8H2bb2LzTVlK36gMV2SptuIziMHOPMA9rlYXA6uppShGtimyvv26WHhAmsf3cFkQ==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4299.namprd12.prod.outlook.com (2603:10b6:5:223::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.30; Fri, 26 Mar
 2021 17:31:29 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3977.029; Fri, 26 Mar 2021
 17:31:29 +0000
Date:   Fri, 26 Mar 2021 14:31:28 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Keith Busch <kbusch@kernel.org>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Leon Romanovsky <leon@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH mlx5-next v7 0/4] Dynamically assign MSI-X vectors count
Message-ID: <20210326173128.GQ2356281@nvidia.com>
References: <CAKgT0UfK3eTYH+hRRC0FcL0rdncKJi=6h5j6MN0uDA98cHCb9A@mail.gmail.com>
 <20210326170831.GA890834@bjorn-Precision-5520>
 <20210326172900.GA4611@redsun51.ssa.fujisawa.hgst.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210326172900.GA4611@redsun51.ssa.fujisawa.hgst.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR05CA0031.namprd05.prod.outlook.com
 (2603:10b6:208:c0::44) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR05CA0031.namprd05.prod.outlook.com (2603:10b6:208:c0::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.16 via Frontend Transport; Fri, 26 Mar 2021 17:31:29 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lPqIy-003flA-2R; Fri, 26 Mar 2021 14:31:28 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1cdebe43-064b-4be2-50a0-08d8f07cfd97
X-MS-TrafficTypeDiagnostic: DM6PR12MB4299:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB42997F5C41D8FE6F1ED536C8C2619@DM6PR12MB4299.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mdu1rWerzQkwLmxPnfMZLwOenJvOkUOjz16FJaX/qX9cH7yVrhsYxLIUi21fotoc8CfNCTGlmgme95Hiv6+uvTHfMjjfOQqAgSVptzr6lukay0LSCDKlf2ZcrqS7zXcDHlmq01eZaHny6fnHriI8GWPzfCAStNftlKWYa6q/mqESYay605pkQmuVyzQh1DgUYrqUo5hKcg54nSv6QcfxHfZfv71DMpmvqMdrpMmpd+YZm5DWUgNn69xuowMsZgYedWOlCRIDGxy3OEGYWlQN8MxHtf3pOKcZSaetZznzeSyp4xe+fv9Fu2vCfbj3o/HnjpTV5MGXPFL4sNp1kDmrr/Av4W5+d5sFmhBaQzGx7u+76U1vyCwnpI1p6SG7440wtAVROHk0VFVvhfRDY+FMZyjYrT4m31AWaEgUFUVz5fGBIFWWg/9LFIQL3MabUuVeZP7k/aQWJt4qeiM6Unzc7M8SfJvqoegnhCaPNCnSRoT9ckOslb8r3utd0YMXocxt2rHMoA+2mTNnMB2VDHJq5SOLMP7MEvcCeNBcNZ0egvCF93wyUZlrNkNqhPuRV5eGQi2J29FhmERKeKOkaDLaCp8MvfbZuaXkugBlR+eh/Qo/+GR1X9OGft3wo7aZyxiptzVog+jdGMPRqoA2JPxMlwXihXyWRkpedJjHyhgK3vA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(136003)(376002)(39860400002)(9746002)(9786002)(316002)(36756003)(33656002)(54906003)(86362001)(186003)(4326008)(7416002)(2906002)(6916009)(5660300002)(4744005)(1076003)(66946007)(66476007)(8936002)(66556008)(38100700001)(8676002)(2616005)(26005)(478600001)(83380400001)(426003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Om2D2OadXy+7De/63UH/rK1x5D8FHfp9QCONUc5wuLAZDod4nMQ1z2YjHJTv?=
 =?us-ascii?Q?AOiCvUMnrMr3U3IG5c+NQ6tAo7cRxz7DtJc303DDfxJxXVfx3QsRhxqJwcXf?=
 =?us-ascii?Q?HrF7F7Za7RlORxtZAawGys/fMfU53KL5uVABtF4jlVFmboYL75CwE4iheOMR?=
 =?us-ascii?Q?6yXk8ORkssisAbnntug1y7R9JN4luX7gWMe79kw9E18AF4LNf2XqgbgEoft8?=
 =?us-ascii?Q?SHwIapuDx5V+d7ZZtF947BPQGYG8u5o/fWRSjyXvpH9AuytlBUS7Pq98FZZK?=
 =?us-ascii?Q?QL7fbbc4Mg49eetw3J6h61ImWYAGvOUAkf4zKQ9LCp0NAwzIxfRFfnuMhM8e?=
 =?us-ascii?Q?Zc3FxsECgFZWIcDCMiCzsOPojpz5QkV7+eldUts95rg1qPPzD8/DC0iu8Muh?=
 =?us-ascii?Q?mqK+ZjYLB34BJILqWafulZl2VMYez833nN26dTSPCBx2NzTLzh3+he2MgsLU?=
 =?us-ascii?Q?h4bqN6w17VGRzoTkut2x56KjZouGelgufTQypYfxdP1CKICcyK3/L5dGxR3E?=
 =?us-ascii?Q?mec8rGd+J6KTLlOB2XBhOll3oC7c2B+f0SZeWgNfgPvPgWqENprbBjJUAaVC?=
 =?us-ascii?Q?wOEX5rshNpBgOt4I0I/mQHBVl42A1ymAHuBD/SDmLH8XGaMtuBp2fykqmOoT?=
 =?us-ascii?Q?VFHz5iMjSP1dHcXeuuL9eKHdyfrqDzEHBdS0XdmJJPzC7iYEVLJCVIhg4alR?=
 =?us-ascii?Q?i9mTmGqj/lq6Vd8BE4HaZq06b7EzdcwMrN77JJXXqBBNDqqkSsIAVHcbdiND?=
 =?us-ascii?Q?++JQtb7woCTyytd7jNI668LXOT4J4DOitGuC8PsrV9ibc0oRyqxUVtYPyubG?=
 =?us-ascii?Q?CFEWCoVn8sr5u5E8E7Bya+z+MFJEL0jG5KgtiPLGKwVdoJEj+TDVYOtJH6+w?=
 =?us-ascii?Q?5460v84oE6/Te8k9jrThSYWr9D4MXUw5gQjA8jcGkPkjVrzPj0kk+zRfezxQ?=
 =?us-ascii?Q?YFZdjD/4SM70HHs3k5zpPw4pArAvSuDrUN7wB2pBAC7U06iIwvsaul65lwOU?=
 =?us-ascii?Q?y0Os2S7FoLAHZbPKfsE/fYCEtlLlwjsu9hWcHYdlILPEsDnxp5MlUyI+DNbx?=
 =?us-ascii?Q?swl40g5hWkE2QlFb0x9FjqC7fGQ2+6BNGAw2bzrrwV8Lvq0bnvRBhC+JIrAB?=
 =?us-ascii?Q?oCQlNn2XTj8IoN4mY9KZKbE3m/5Dpd6Uw5po+zUNKTrdyQ/Ow9EA7v2IYfEB?=
 =?us-ascii?Q?dJ65KEZK0k++zYPwqsy/NJOpfMvQhz+WlOgGHVgvU7mjsNxFC3gV7sCXR92w?=
 =?us-ascii?Q?Y1dc3fd/JKFtH9PtTblNsAIU5r5W02WpUUOFttDvfncaePFntQmIpDspmWb3?=
 =?us-ascii?Q?iV/7Xbwtbh48TTJUnnW1Yx8LzocBZ2oZ2i3uUpanwanCAw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cdebe43-064b-4be2-50a0-08d8f07cfd97
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 17:31:29.4937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 85EvXmUaccbbnP0lEZNL/JGu6QLBpfnv5DikWwQQQEXNQzCxlvU8Y9+KJm8NXN5E
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4299
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 27, 2021 at 02:29:00AM +0900, Keith Busch wrote:
> On Fri, Mar 26, 2021 at 12:08:31PM -0500, Bjorn Helgaas wrote:
> > I also want to resurrect your idea of associating
> > "sriov_vf_msix_count" with the PF instead of the VF.  I really like
> > that idea, and it better reflects the way both mlx5 and NVMe work.
> 
> That is a better match for nvme: we can assign resources to VFs with
> the PF's "VF Enable" set to '0', so configuring VFs without requiring
> them be enumerated in sysfs is a plus. 

If the VF is not in sysfs already in the normal place, why would it be
in the special configuration directory? Do you want the driver to
somehow provide the configuration directory content?

I'm confused what you mean

As I said to Alex configuring things before they even get plugged in
sounds like the right direction..

Jason
