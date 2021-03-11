Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7799337EFD
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 21:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbhCKUWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 15:22:48 -0500
Received: from mail-mw2nam12on2040.outbound.protection.outlook.com ([40.107.244.40]:35680
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229555AbhCKUWi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 15:22:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U0KK9hOyof0k7EsRt1T23BQIoWMlYHk5LEnQHWhxSCOQ0Cn9GEMRplITUO/3Wpjt3b2+m1B5EAPdkbIpeg3u++5IoIAt1QhzkymNd3eFU97InBwqGPHpN6Xs1GlVrihrCV0pwYUCw348mu1YwvxhTcZy5kDyUXH/650xI7doMVaQeKiz08k9/z+wtEe4Ui7JfsqSz5U18yYlvOhDbH/udVX8dmVibyM5h8VueHthjLVfJp4o2W3KzKiIrCzbxDbtAweW+W2Tsni8oPon1DPhZe0k8NRqFHEcO+IqLJrNOD+3VranO2qWKrUBy/IzDutb2g8FYtJkpWL/0efQmlOX4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tdOilMvabcmq8WWYmkbRYKWrGM2eTamMB+giWWoiQm0=;
 b=cKqiyg/OmAokGZWPKMJ7EOEq4eBc92qId0r2bDRji01wI4iMgJbMJUkIK4Js+lpqgIITAB2j56OcdJXTULivHOcooQ+25AamRnGvnsFc9NiUGZhRkigmUv8W2Z9LNLG6dvwRVcpjBZNqsI34utsjMqCaacjGVUNgV/9bI//ZgOVoXBcembHWBeqYL+iYMbFCUDTu7d51CHUj3axNxct9h9fMxsMADZPY7ncNbYCD0StmeXnIE86ytV9TRPhoWV8zEqrDl4EuED0CN8Vwh4bMs9/5R7ty42+cDgcnPVw1lpNw+JyshqHxEa0qATzLjURe7/6GFHGQ69SPoDpv0GUGIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tdOilMvabcmq8WWYmkbRYKWrGM2eTamMB+giWWoiQm0=;
 b=ilV+yEdp7v9KQE21Xnk/bPCzS0msJsyj99cCCHTaHK6DpTLPVTkTs8+4WkpatOX5wNjpWvttZFiua1zven/k2Cc6J9kujv43rsZu/eMYKC7qQZULXRqfItbeEOOxULmOQTykIWhSaAyk9F/VNODaLtwkiO71KfwWizTqfDxzmSX3clizsVajZugXy9ppeyHnmCaCKzpuNBTCJFaqf3S2c/tGILaRB4XtQVDUWQqFgeKPTIvVjUGn2grU/6TaOisTpLfZn62DKuM9fQJCjodc5YwRIldGVtccbSlFTcsgcDRvL6ecccNIB8mpZzpmVhXMb3ckrjva0HPhZiSK2g0vGQ==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1337.namprd12.prod.outlook.com (2603:10b6:3:6e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.27; Thu, 11 Mar
 2021 20:22:36 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3933.031; Thu, 11 Mar 2021
 20:22:36 +0000
Date:   Thu, 11 Mar 2021 16:22:34 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Keith Busch <kbusch@kernel.org>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Leon Romanovsky <leon@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH mlx5-next v7 0/4] Dynamically assign MSI-X vectors count
Message-ID: <20210311202234.GO2356281@nvidia.com>
References: <CAKgT0UevrCLSQp=dNiHXWFu=10OiPb5PPgP1ZkPN1uKHfD=zBQ@mail.gmail.com>
 <20210311181729.GA2148230@bjorn-Precision-5520>
 <20210311191602.GA36893@C02WT3WMHTD6>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311191602.GA36893@C02WT3WMHTD6>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR16CA0007.namprd16.prod.outlook.com
 (2603:10b6:208:134::20) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR16CA0007.namprd16.prod.outlook.com (2603:10b6:208:134::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Thu, 11 Mar 2021 20:22:35 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lKRpK-00BVnc-92; Thu, 11 Mar 2021 16:22:34 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 41ea9d36-a3f7-403c-72d9-08d8e4cb6882
X-MS-TrafficTypeDiagnostic: DM5PR12MB1337:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1337E5191203B03B5A0626C3C2909@DM5PR12MB1337.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ABMP47jfZnUNKjvTWOUMhdGgZ8c9ty8gWDBwyLozMrm5ZkUZnlLwoJinWQTJ5brbDLdivsorW0Wz9suhS5QsBg5zpE/z7N5rXmyPTErRedzKsgCmNSjcKrw4dwUhSdtwR5hIULbZSRL2VFRKTnwEQ32EZFrXsPEcrELz6VO+b1s7EmwTaDUP9Txt1fJ+54kKW1+oqV9xh4CUoGcTF0+IFQ6LlSwqILu3ldfWmzAhMS8bDA5i59TUJKcHO3HHvLJtYpyDFgZtF2l6uWm1v2YQ5s2JzHfyHAwludS3ArhPBy2Qk5KZfwemmqbhyHuwyUVS/Uur1Mpssq1l1AFgf/dBdFr+eBwxPTz8fKxYlMwjF7WVRTs94B9C8Bf2REP44YYYYgcESPvJFYXGfo07zCQPrAyua5hjmDR1RzNH4o+SPcDqNlofU2nMVcmJNS93c2H6QwaexUhybipkR3ncLh5t5Zv8jmtEA0yspt3O+JQF9iSe2qpUVY2ySbK8UDPyfecnk5lCuo3zHFEiRh1JcMMiKg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(376002)(346002)(136003)(39860400002)(9786002)(54906003)(186003)(36756003)(7416002)(478600001)(8936002)(4326008)(316002)(8676002)(426003)(2906002)(9746002)(6916009)(33656002)(26005)(66946007)(5660300002)(1076003)(66476007)(2616005)(66556008)(86362001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?3KKSYGmtnKDNQyDvV+E29rV3KT3XfL2YuoPUANXe9G9LgLQ9VpEKGFHFRMMK?=
 =?us-ascii?Q?PPZjK/hX54qVI92oDCWBX6nmP3paJyWbywLLCVip+N90lhkjEiwHHPA/T4Zh?=
 =?us-ascii?Q?Ft5JHmzGBhDMSzvBIZBsLqFi4RJIyYyEJ9CFrXPkhJ62VrgT5VMs+7vvLOSe?=
 =?us-ascii?Q?KsBSuWx0no2nHK0J01yZVvXFpVEJE/gAeXPpVtohi8tYQbh3twgaVCp5x74x?=
 =?us-ascii?Q?P6LTpC/VUbtNQ8GE1zOXgOdsJr/ENcrZKe3nxouMvGaYZJgD093lrsXfC7qW?=
 =?us-ascii?Q?gpkocW+jdN78rpAkhVeCmkJxu8aJdw5KSd9WLt6Mf/iPkBAWBt6VgNFD3nCc?=
 =?us-ascii?Q?jCQDlDN+NZYv8I0vQVXtqQvbs7wNlHuKhatHsGMWGQbH5lVd30GLKWb/DkQp?=
 =?us-ascii?Q?GuU0UcfYR2wBIU2UrhyP3b+JVKnQ/wh/V+/4MRL5NyYxHMei9fw8kUuT0zxt?=
 =?us-ascii?Q?4EAcByANx1oN7j8IffIpgIBjG34KiJnB+JXtI29G6+lNaD/TrIcU9tr3X5Fx?=
 =?us-ascii?Q?ZTB1OuNBeP3PhsgQ6x6WdD2qYiNyRf6Zugc7zhV8S6hZY67o0jcPWcCehkZg?=
 =?us-ascii?Q?joeBaZL5oLgYHbJzyYz4HXX5Szecxd/Cbt/4Cu1tlO30u00MyrbOHQNcV3QB?=
 =?us-ascii?Q?sU26/4+s1+g70NWJOwFLUfm6Zq7OY6o4ud4ZprTxxyq9dKuiSfxvTvLKBEjt?=
 =?us-ascii?Q?Zlmy2RN2fuBRg7ttJaaQgYbkIdHltoVpSeh7xX9uFJVp4HfzWnjbnDSr8rih?=
 =?us-ascii?Q?MaKax5ejV0Jen1kDzdqhlUVdHyRyME6+//ssTE8g+CXCZ3VOcKLyIPRWVD7s?=
 =?us-ascii?Q?awjs7cCIBYV8FIU5rceEm6Qt2F+7ib0NEawlvbYK+suWcdam2lxyvpBR+oJ2?=
 =?us-ascii?Q?IQx9IWT8S4kNY8PCQB5R+/Iu4jiKNVQ4nGoMPLurCuESfVShRTh5e/QPLwjK?=
 =?us-ascii?Q?/RsPzSFmohQVPIHkppaV5LhCMHSDOVZZcU9SxQLuWwJ7lJrfq64iE/XXbTdO?=
 =?us-ascii?Q?4EcVlOGgDoL/gqRdiFB8IcJf2IX25bjrkuE9jLC/Wn11S9xaVd1lNTgn3jpG?=
 =?us-ascii?Q?RFwg+aref4NOf/+ImXLTjCwlKo7zggDCkh5tIDZcCyQ8TcLtVn3VEYaUjH6j?=
 =?us-ascii?Q?1n/uQbvLGbhYPnB819QqGfSSCKZnKIYw0xk7Rq88y7llLPqZYrj5H2y5I4FY?=
 =?us-ascii?Q?s9jV1dcptjqB6hlaipG+s+xAY1JQn3YrL+Q/zJmU9GntrURDPc+OmHthY7Re?=
 =?us-ascii?Q?SeRbUTUtR253AWztqxZZb549386RtjZswiUvQzWYR6TtCJuU8cETnYAeozcH?=
 =?us-ascii?Q?6OSK+Rlugk1oXIXB/ASNCJEdiRp9W8oN1HM+N1TKJ7am3Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41ea9d36-a3f7-403c-72d9-08d8e4cb6882
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 20:22:36.1945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yA6gi3p0QevMZVkovEPlnHH+8tjASlJSyBFc31j7p7KGENpVYbB+VeRz8Bv9Oy0x
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1337
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 12:16:02PM -0700, Keith Busch wrote:
> On Thu, Mar 11, 2021 at 12:17:29PM -0600, Bjorn Helgaas wrote:
> > On Wed, Mar 10, 2021 at 03:34:01PM -0800, Alexander Duyck wrote:
> > > 
> > > I'm not so much worried about management software as the fact that
> > > this is a vendor specific implementation detail that is shaping how
> > > the kernel interfaces are meant to work. Other than the mlx5 I don't
> > > know if there are any other vendors really onboard with this sort of
> > > solution.
> > 
> > I know this is currently vendor-specific, but I thought the value
> > proposition of dynamic configuration of VFs for different clients
> > sounded compelling enough that other vendors would do something
> > similar.  But I'm not an SR-IOV guy and have no vendor insight, so
> > maybe that's not the case?
> 
> NVMe has a similar feature defined by the standard where a PF controller can
> dynamically assign MSIx vectors to VFs. The whole thing is managed in user
> space with an ioctl, though. I guess we could wire up the driver to handle it
> through this sysfs interface too, but I think the protocol specific tooling is
> more appropriate for nvme.

Really? Why not share a common uAPI?

Do you have a standards reference for this?

Jason
