Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4CF337F09
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 21:32:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbhCKUbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 15:31:55 -0500
Received: from mail-mw2nam12on2056.outbound.protection.outlook.com ([40.107.244.56]:54240
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230231AbhCKUbo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 15:31:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l4piK3p25L38y+KmqK+XB+zkPhCdHU7kDyZIqQ7TTrvj/5tnYpiNpc9jwrP/cI1I6cslq22RBB7QdszC6U60bb5U8SnCpg1pth0qRMIpM03bpjXa7mtn1VbS+MEXQG7Nc3LqAYbjiOumuv7KrU+C45H4Hqu84TeA1BFBd50Bo4/0pJVLXLP/4FWE0o/ee0nBdsGdswkhMQJ0TYIMABO0eVkQ7PBq3l4Al3U/IkLN0xDOrC1w00OZGpHXTOx+ColOvsYpv46Y0xMIlOCoTp5mhnL8X+vFydt87CqHhdBuuK82zoCpI7JqQ1JpYHOb9+cao2vza3pYLT9fwMpJk2yjog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GDv8KHYwRQGt8Z9p8C2cHbrdScMypinj/Mxr+8NVvhM=;
 b=B1mh1coRHX7YhxZslktrvKYh9x2zjkepVAa9zEqwem3uq6llfYzDFQzzhSd9lohqXHUXCEVNc4JRrmtNaIvzTafyQSMokq0iHceBaMLNr/DjEOsltEl0lUWPTH39+KnHSvCrRmbNNDuRVikyUnZBYxXC6ufjoGrMCWolrZo1BtjUxMRkVadyxUtE7v+u1hfM2XuGit411mu3r7szLx7QlS+GS+w/1x+Vix12WLkaTLOgW2tVqjdFQMT5p3vFY0WrB9W7NPQuPya3Gro+z5EaVZnnx6+/3rVIMg5DVdtnHh7iLCaeSv0v2Tk9w+bFk7zs8UsmUIe21268gb2GPQVH6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GDv8KHYwRQGt8Z9p8C2cHbrdScMypinj/Mxr+8NVvhM=;
 b=TL1cUQrDP4vW7cKB5/3LSOb84dyubSsPco+yP/3Fh5rduu6knnwOBe0RcmxZyLFT20It6fMsWQm2csfzSxrFuCDhO0RSVmic10yzBvgcUq5AbCVNf4dtAPJT2QQH/NdZ1IVrcEMw9Zrf9SSi2/mq7jDBQNGF8R5rp2x7Bze28IJ0utuEAjMKUiSb8HiHK3R+f7lEJ70xYzWfs6p1XVIByseNETzygUS0yRTiswqb9j4fNWbbtpytRT9w6Krtwh5Fyz/dtUgaczdR+JQpEBTSjoJWKmPZ8Tjc3PmpST3o+8kkMoikkJnz5DH3bwnNh+HCfGFnnzOsKJZljCounnqL4A==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1515.namprd12.prod.outlook.com (2603:10b6:4:6::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3912.17; Thu, 11 Mar 2021 20:31:42 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3933.031; Thu, 11 Mar 2021
 20:31:42 +0000
Date:   Thu, 11 Mar 2021 16:31:40 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
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
Message-ID: <20210311203140.GP2356281@nvidia.com>
References: <CAKgT0UevrCLSQp=dNiHXWFu=10OiPb5PPgP1ZkPN1uKHfD=zBQ@mail.gmail.com>
 <20210311181729.GA2148230@bjorn-Precision-5520>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311181729.GA2148230@bjorn-Precision-5520>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR22CA0011.namprd22.prod.outlook.com
 (2603:10b6:208:238::16) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR22CA0011.namprd22.prod.outlook.com (2603:10b6:208:238::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Thu, 11 Mar 2021 20:31:42 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lKRy8-00BVzx-SU; Thu, 11 Mar 2021 16:31:40 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 66c9db98-0d69-4414-c0d2-08d8e4ccae40
X-MS-TrafficTypeDiagnostic: DM5PR12MB1515:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB15150B1A9F47E6E677739C17C2909@DM5PR12MB1515.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KrnAL0B18ohHBDMFHfa2xaIECPOROxHR1r6V1T9shUjcBcJDSDik5cLVBhC8pTDroUQfy2tHioZheBHN2zWv9sHoZhJ5rPvrZ+VJoRzzAL5tIiikxvLQNRnOAYYgcsxM1Ni8Asc9xp7BdcXz8MmsUOeTQhpCimIRFx+FuObGFgG8QrVwA+kNCX+IehZmeAcAMkwbAy3MbYIzH75hoL0nC/rzgvwwgNN3mUVEQbL3xLIn2YlT8hNYLp8rPoSjnu6e54M+I8xdaxUXL/yUJUvpl01M1bgCy1Dc0TpX0sKw3pQoU+Tu8fn+J9zC742toR1htgPe2Y+hJj3QvF0axRrgEqA9hW5aMgAp9LPO7rd/BT+7a3nCHr6JYPHsVod6fLlbhimVUO/X6bgmI08fxmarxccUfQAcnfPqhw3mWSpo8IMLgItJHRhT3DbwnTlpfUnFTwYjzydg30uduqY47+mTN7i6/dklioWzW7XpLyCkmdF5hoeDftCTkDmD0XlPGd9x4Z6q/IKqGjPtdovyu5NTnQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(366004)(39860400002)(136003)(5660300002)(33656002)(54906003)(2616005)(66476007)(426003)(7416002)(316002)(4744005)(66556008)(66946007)(86362001)(4326008)(8936002)(26005)(8676002)(186003)(1076003)(478600001)(36756003)(2906002)(9786002)(9746002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?nW7zB0zPzp3ei5zCJq68IsvDUUUSTJ+tQmbephMUghU0rycbI3k8IddqzuGP?=
 =?us-ascii?Q?nn8heMgq0Pz8obqIMpcg5zLkCMqe/jK2UU8+Z0Cm7FlVlqftLlq4TRoZ6y0i?=
 =?us-ascii?Q?tA5GzDlnjIhZXoWZc9OHZgbcUe4hbsLWaXNCg76sL97i3YW7vy3jCt24pwdi?=
 =?us-ascii?Q?xXfJnH+hqG2LPFcpRJEfzF80QHsldt2BN5bOdFGbTDGoUbmBPrGs+OtPQP5S?=
 =?us-ascii?Q?nKjZDPbizV5PIwqGN/pOA4Y2Ii1zSRtdoN/pYT6zexDRv/1Nmy/cRYLgluWf?=
 =?us-ascii?Q?Lz1wm0J4QW9CZk4GiyUNW/U+RAVfgHsvwCGyaU/bPU6wRrtlubQirvjftBTK?=
 =?us-ascii?Q?W5I1UmX5Y/thU68+VoH4BqQUP1zelJ+MW2pFGXiXay4jNg1iY0Wz5hJaNKv+?=
 =?us-ascii?Q?kbb1yrHIFCFCsvovpkmKgFcoXrhoaiA6gFnC/ulfcvy50SfLzfY/8M76SB1a?=
 =?us-ascii?Q?NZ/nyoMQGeMD1uO859PkteCTxY3AJpegrLj9AXQKHt7Md2g0VugiOeHBIc1i?=
 =?us-ascii?Q?RKQNSiqcRWlxcUUJ394QtNDmHWIDHixBdzWWEHVQiWwxpjz2FH9qL8fg+KEA?=
 =?us-ascii?Q?w/gN7wytvRp9lvaY/np9IgoApDsPXDaP/GCZBeO0fsX2O9IHG+bJtfWl3WG5?=
 =?us-ascii?Q?ILQpzMOcppU2+qaNXei3B/APRM/keQJDgK2aRI3Aj34YL6x58O6qfTNvdte1?=
 =?us-ascii?Q?e3Rc5Ru0uATwhGMUIjEFTBcmNguloy5xhpK94vqqgYWRkbxO1uHY3m2xEpmz?=
 =?us-ascii?Q?cIillKJvwtnKASPT6fQrK4oMR7nHquEZOCvDlYs7igNMeSAXNvWonJeJxl2Q?=
 =?us-ascii?Q?yT5GwgYzIhbsicstZlfI6Y0Svtb2gX3S+8aBP972VL52GCtA+H9MQRnXgPv4?=
 =?us-ascii?Q?9rkeaccPfeSB2oP8E4TyPAAAUxt8+TzSYxw0XQaeW0FLZ7YpjMqFwQyVDo9o?=
 =?us-ascii?Q?I7TBw9oi4I4DwXD8lYHPNRuUn0jthe2GlKlJjfkE7JFC9B9cRHs4v8aoFmnS?=
 =?us-ascii?Q?YyHyf0UqgdJutKP5Mqd5uvsFsO6ddyaCVUx8w+PjgsRTKzexttTIYV/z1hOt?=
 =?us-ascii?Q?ZZZUshpTjIMuVqvVM/Hwu24qW+SFvcW19nydyVcfh0+580+cJXvkXmNyUTWz?=
 =?us-ascii?Q?bVP4iq2Z1tpV9u3Ob5ZtkmV5E8ltY1p7BH/qpI4QFgf/5+iUVp8Moz5r2OaP?=
 =?us-ascii?Q?e4b1Wc1k08dCHG+btwQZAyIPuhKkvQAjMEIUiZe+joyg7S4i9ISEUhwzZClx?=
 =?us-ascii?Q?gm0ZiZh6zLKij3em6ULOoZn94082nGg61aGAmYqbR7l4EacFIOrnEK1/OA8k?=
 =?us-ascii?Q?/pAWIL7KfUjA7/pN9+xcfd8hfYUc9VxMPNKPu6iVua0MPg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66c9db98-0d69-4414-c0d2-08d8e4ccae40
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 20:31:42.2634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q8kfruGHccDWq37P0gzdVSLINOEOnoRYQy0Ioke5ngsm7cwYIhjZ68cX3IgX5iN2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1515
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 12:17:29PM -0600, Bjorn Helgaas wrote:

> > In addition it still feels rather hacky to be modifying read-only PCIe
> > configuration space on the fly via a backdoor provided by the PF. It
> > almost feels like this should be some sort of quirk rather than a
> > standard feature for an SR-IOV VF.
> 
> I agree, I'm not 100% comfortable with modifying the read-only Table
> Size register.  Maybe there's another approach that would be better?
> It *is* nice that the current approach doesn't require changes in the
> VF driver.

Right, that is the whole point here - if we wanted to change every
driver we could do that in some other way. Changing the table size
register is the only way to keep existing drivers working.

Jason
