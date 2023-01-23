Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C180677D35
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 14:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbjAWN6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 08:58:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjAWN6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 08:58:13 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2086.outbound.protection.outlook.com [40.107.102.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2330123DB5;
        Mon, 23 Jan 2023 05:58:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IzSvkLGaIkVSEtSuwrY34UdEjX6y3wtqBzlbItXmeq17gZ5aJFrFPza7lBAkSGFI4IpPTAyO0tK7PPHOW9K0J+4zGe0kSm/ygem67qCA0DLPyLWhBtlMz6yatRxuJnOqGZFLCgLKSZdyofru+FhN9l/vcWvhOXvFjSv1//cj/byzT9IxQLh74muwhP96n63tYPz49+H16qpL4/JZ6joyZTxlNqRiIPJHsOicxt50aYbJyIxawg9wgFEuUsCBTwYinkXQoKymNKfAF8sgtFKFXQOjIYl/YYm1pbwaxyQcYO6E9A3HYbnR6aL6Fk8WxvnKodkw5AXz3NiNosfEp17d4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mj98Z75UNQKF66vjw4gK1EqUjFg9UDVV6Ux+4paRpcU=;
 b=UtQQ5rcDA/bvIjSaTBeAvE0jS+qxGfnA9NIWi0Ut3KULCYUv5nHPMbYdXaEGHZctdxv4TLKgY1nlWj2cI6QAK6RlZ/w2LgOnRnJ+LNPsKJliJwzjyc+WUrTNc62zX5w2SodaWStJw0s5ptvnevOwcoSrQNT83GW39AwIJQ0F0VunWcsppLCh1a4GELYlKe6vyybUcw01NZkrq1N765y6uiAIvdoNPoCCGkvrfEXvnxP3eBoI03ObYgdUlsHg2gCupsIuPoZgjDEpjiFCo4zD65nEpV+D07vs/dR2nir24PErW2TpMMiYAqqR7LgDAEhlkq9eyGp+oP46b4OUmdeE1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mj98Z75UNQKF66vjw4gK1EqUjFg9UDVV6Ux+4paRpcU=;
 b=iEGHAqMpRgd0MYMXKnKDCgL1/YWn/iXIIMwcyB/qNIdjMElKvdzv5oz6DWOyfc2N8DE1DFiaPtfPQqh8/kTHpLgLcOYvQwOKJ57lHSlQ51RKbcmZyE7KN4jUSvgb+tHDn0Sq0r4FzXTUE+PU4k6lFT+nPbXLINdA/3v2lBdve7qhwSDnXGj8F9LF1pyFZP5RfdFDn2Wwl3kMb+OSyr56y1xVMyioZmtfii+JJEPW/vDPzIGSZbySL2z1Tk5eJ+gh7ZxTcXhU2V1rKYFIE7yutCYKM8+1gqFUyN0lFSIqIU+HWkCdW/6sFYWX7pCY3tLFAadKI7lJNbQv+vlJooiA5Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SN7PR12MB6957.namprd12.prod.outlook.com (2603:10b6:806:263::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 13:58:09 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 13:58:09 +0000
Date:   Mon, 23 Jan 2023 09:58:08 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        ath10k@lists.infradead.org, ath11k@lists.infradead.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-media@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-s390@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-tegra@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, nouveau@lists.freedesktop.org,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v2 04/10] iommu/dma: Use the gfp parameter in
 __iommu_dma_alloc_noncontiguous()
Message-ID: <Y86ScGA7kY7gQ8qQ@nvidia.com>
References: <4-v2-ce66f632bd0d+484-iommu_map_gfp_jgg@nvidia.com>
 <f24fcba7-2fcb-ed43-05da-60763dbb07bf@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f24fcba7-2fcb-ed43-05da-60763dbb07bf@arm.com>
X-ClientProxiedBy: MN2PR06CA0006.namprd06.prod.outlook.com
 (2603:10b6:208:23d::11) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SN7PR12MB6957:EE_
X-MS-Office365-Filtering-Correlation-Id: 34cf5123-2953-489e-ca52-08dafd49dc1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1w/pe4b0h/yebbslug8aF/a3spvZPo9JvH5FhPtE2iMd+Eq/OovJovV+lDXLdFaFZqUF+bMvwGUIab9bB7X29pUAv5EFsr3oQYOYbkL+tVU4YT1VrmpfHF0y/tcXg4IGHkUQnkCfhavZtVvVLcjh2In8CsjMRjwnPbrVrxis9UO/0+oXa1F0E7o/CdEEwYGbfW7xqk+6sU2U5qGgb1N3PwhDLNWJ1qeDul9aREBL8jurCDLYpqOfdqhuNKxU4FMc86tIJ8WQRc17hWhWqxZqQ43v/RFzq5tFUCa5K9JqgWd9Z+Bd9DoOv00vzhj40UJ5ZY/WXU79KIpYP5CJzIb5LbboEyHZ4JnutNMWrgCHNe7qzVe3/7Ch+nlvWF65PnldB4KbxaFJGtFHquymSmBhN92UThs6g/RtMjH8n/14/MDGzz1HIndOp8uj28U6HMAOQbarEP/tYyZuplhrHEitK1UvVQQ1/EloTkvyn7JKtfyXC/VYRZ28wTq3EXIwv47oXbFu4ejWRN35VWd8M2SQDnl5WVEhEeXHlqpLwxhUYNVfPk1PZkvcfcLUxOk1PQJlofnMTrETeBn2flSwhMxb1mUxrSBn5bG/p+0BzHdAz8WR1MnpuU4ptxvhoJ0QXIUtrpWH3XUu4+O+aaeCLeNIyw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(376002)(39860400002)(346002)(396003)(136003)(451199015)(6916009)(66556008)(8676002)(66476007)(86362001)(66946007)(54906003)(36756003)(316002)(4326008)(26005)(6512007)(186003)(6506007)(83380400001)(478600001)(6486002)(2616005)(7416002)(5660300002)(8936002)(41300700001)(2906002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aXYry39Icpl9qdcuguvOO3EqbE+jXVKyUaLnoLjIHV7Bpp7Wq/D/O8Y7MhG0?=
 =?us-ascii?Q?/WSr/qFtB5AuLZS3aLC2nmX3YydtvAQ7Pv8LwV0SgmwqwN9876JonsktjSr5?=
 =?us-ascii?Q?8yqvjao8Qdodjfk23kihf771VtLUudjaZoACfNsPZEskpF3WiSYQ+QifG+JN?=
 =?us-ascii?Q?Fz3ULeMQbXMWHikzQNWw8Yw0Sut5xx4eEMFmPWSDKyc+Bhmiyptkf2JusxN9?=
 =?us-ascii?Q?P9RHMSkuDNZFAl+Gy6opGQtWIWtIZq+0zNZ6y9AajCG6A4shi4nxR/CtaGWH?=
 =?us-ascii?Q?zdLxkEXyuiB7ruofiffXZH7F6kSfBptSKuZ9eerMHIGHEAk8sLHAd6guuet9?=
 =?us-ascii?Q?6JpbJ/n3ignDGa8zmHULj91rd9IrQAHSB+Vs6meCjYtX/bViO6E/Sb8kfWW1?=
 =?us-ascii?Q?qwOSe2panSLyyTFsvY8JHXWcfkYIkYpLaubA16sz4ql44ydl6ADy/TLeISIA?=
 =?us-ascii?Q?HALsDzyrYWQtEEciWGDMcdfoqQSGJsFRcao5kac5lOrkp7ftbFSYqEZrYrBh?=
 =?us-ascii?Q?InTJdk82cZF1Q9lxYRG/viBCM/DVvOdL48juI0HRx3QATxuofcDNU+IG8u2+?=
 =?us-ascii?Q?9cKWCB8NrktvSnNZYsYYBCkR8rjUXEn441wbaf2kyqGcsfKr2zt3SIemvUYq?=
 =?us-ascii?Q?Ey4Iw0tY6qS8KbV8Zz1rOq9n6w0ALt1Azzqv3gUhGPeIaY5rN7WTg47FDi8R?=
 =?us-ascii?Q?5btK5Z7uLwp4V09/Xuxr4szuJ9MVxwUsns0DmRnVgpP0txNkzclKBuDzDXCq?=
 =?us-ascii?Q?6Gv+lvspCKAMwWd6q0PLdhMMHB+GevS0bpNWepgRWQLXSpZChN9P8Iu5j38g?=
 =?us-ascii?Q?+4e3UH20+8JHfQ7fCDH3c2APeSLR3JlnfNL5Edzj8hzUYXnE2Js79iDg9b3V?=
 =?us-ascii?Q?x5yXcgt/cu0JdXSzK4qH9xmd/9Ub0BPjQIqijwqAnlrG7kgclry/2lfnx2zX?=
 =?us-ascii?Q?C+3wPR2wCfMurVnGYzT9k0luqZWsUbNGhjktcVXQCY04wjZ80sd+neZ4pM+x?=
 =?us-ascii?Q?tz/5qS+7vnjeYQ3c0yyMQw6pXY/KYR7hs7nRK8l5IfuK8OV5RRJKWxh0HoNM?=
 =?us-ascii?Q?9uXLqXG3uM0q00ic0dpGVOyk4jktRmNfmNMx615NSemCqB/h2y1ViO02OCez?=
 =?us-ascii?Q?Tzy9cHwSmcPhbaFINTAosmDIS2AgP4Kui7n9Kxyz6E+O3lbD3jKQXKddonUC?=
 =?us-ascii?Q?4T6VVLgY/xvwx8U5PlI4TZqLKdAtqLAXkBotDkyWlKO8O4HfO0LrUZuh2LAs?=
 =?us-ascii?Q?kzeo6PRwt3nJnpLPSdy09dl2f2ob3tkVKx9JcLv3JE6IfnOf/I50xaoeVISm?=
 =?us-ascii?Q?LJLJtKvhuxQRC164uiU+pUhUkL2AuzfNwoT8l0cH1y2tILME/NoC/O4cRkKp?=
 =?us-ascii?Q?5I202/PhXjoO6YPvk8kXOGHnuBKLiuDJ/qFD+Ek1eL7jpuGOjRDDwwz0qmfo?=
 =?us-ascii?Q?aiKKhPzWzx3HqrG7JJneOkE9pD55UScNUGD9vcvnHQYyNC6L6NVP6Gev1zET?=
 =?us-ascii?Q?jdfGftb5e+bGdo6Pxt08gof7qszpnqTuUh+WuJofdEmxJ04n5uVnEK+m1a8J?=
 =?us-ascii?Q?0b/N/khTwTnJUXTBGDEpxe0nhiFonmD+TxPG4922?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34cf5123-2953-489e-ca52-08dafd49dc1b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 13:58:09.6543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /ZmXuKK2hDYRrh/Fl3ERyQSAeofeJpqnXtVJoedV0D7/bItE4IRQAMITISCEMZop
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6957
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 20, 2023 at 07:28:19PM +0000, Robin Murphy wrote:

> Overall I'm starting to wonder if it might not be better to stick a "use
> GFP_KERNEL_ACCOUNT if you allocate" flag in the domain for any level of the
> API internals to pick up as appropriate, rather than propagate per-call gfp
> flags everywhere. 

I was thinking about this some more, and I don't thinking hiding the
GFP_KERNEL_ACCOUNT in the iommu driver will be very maintainable.

The GFP_KERNEL_ACCOUNT is sensitive to current since that is where it
gets the cgroup from, if we start putting it in driver code directly
it becomes very hard to understand if the call chains are actually
originating from a syscall or not. I'd prefer we try to keep thing so
that iommufd provides the GFP_KERNEL_ACCOUNT on a call-by-call basis
where it is clearer what call chains originate from a system call vs
not.

So, I think we will strive for adding a gfp flag to the future 'alloc
domain iommufd' and pass GFP_KERNEL_ACCOUNT there. Then we can see
what is left.

Jason
