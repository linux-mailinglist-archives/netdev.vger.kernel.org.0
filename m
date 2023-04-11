Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4C76DDD1A
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 16:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbjDKOBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 10:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230471AbjDKOBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 10:01:08 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2087.outbound.protection.outlook.com [40.107.243.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFFC5121;
        Tue, 11 Apr 2023 07:01:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kH8wFAkrE4qZliL5c3gW+619oyLeiJY3+Aj22gVafvOXNGUOlpo/O+ndXof+YpIKVZj+S3VU+jekoD3T6SJ7vGo+AyZn+5j2VIR/hcz4yqzLGXobLEhVJ3YJB254Z4ZWX4r2+eOuTFft07Ph/FT7lhU27biif/KyvoLYpUNMRJi+Jhtj83vB7z2B8zL8OfZu+qLGzjQ0ZrQ5Gn5LrRsUdOPDA84EddJXuS/VIJtMb+SnqP/BlFa9w8DvvOLGzfQUMIyrq8q6Ctihv3YOGQiWflPtYkqQFqVLb5mK3LABs79pY4reTQTXriSHYi46x9jPJYrbRwNHKNx4+7KC3NZKzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ST+0aIr4HCS7shAG0Xxk1aGPdBb0zd56Sh+Cr48R2q8=;
 b=dBA4OvebaQqnbQ06fi7dNbjkFblNk0YvwxLNpawuglMqf/w0RTkdGdkv5MHSuCjO70QlrOWlamAaTCoYVIlGrblkMD4XnOhh5qFXF923XLBkABOl0o6e1uo9ibRhB2rAZfZo5spUj4MKSYe54URawgvm+40Sdn4wqS5cdd9gxfY3X32kvwhiVahm435HxQ44ChXU4ttuO+LVwE/w9dRLIYrM0Y1VylcaqJZBS8qSg/bVIHa+ZBkSceNgKjN/z3OC2z4yqiGdzWixkgMbx+qaNhyyW9T5So+WX8WfTvrOyGVYV6blFOHSlLhrIY5xLQMCOw48AxTsr2uH24BaqUJlMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ST+0aIr4HCS7shAG0Xxk1aGPdBb0zd56Sh+Cr48R2q8=;
 b=rrMQTT6E/3DMOWunCKxx8VtvfQWq7PkQBZ7UxLnYB/2UPRxufHLkbuL7XiZiLiKZqPYOVfUQDTX+XHHU/mUgozsgcWogsn/D9nfi+M+82AigClGYYLIvUzaynnZYSZ8ILxfblq1wNchPx3GNuBA7Hc20k9KfPqL/5S6FrrOA1MBFD3dtxC/O4h79Holv/cFZX8JSROv9yBI2McIE1IQjrauslSDQ53VW1XoKe2mmZAZW9YEcrlsRl9Af1nU0tRBRMvauSJkJ4AO7vnMEEklMoG4oEVs1uPWMQzcdf5qVYK7qYlSoHRn7DAMYNHB2TVc9StQFKuMppZWd5DQ7JPh5rQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM6PR12MB4927.namprd12.prod.outlook.com (2603:10b6:5:20a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Tue, 11 Apr
 2023 14:01:05 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2%9]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 14:01:04 +0000
Date:   Tue, 11 Apr 2023 11:01:03 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Avihai Horon <avihaih@nvidia.com>, Aya Levin <ayal@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Meir Lichtinger <meirl@mellanox.com>,
        Michael Guralnik <michaelgur@mellanox.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
Subject: Re: [PATCH rdma-next 0/4] Allow relaxed ordering read in VFs and VMs
Message-ID: <ZDVoH0W27xo6mAbW@nvidia.com>
References: <cover.1681131553.git.leon@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1681131553.git.leon@kernel.org>
X-ClientProxiedBy: YT4PR01CA0090.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ff::16) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM6PR12MB4927:EE_
X-MS-Office365-Filtering-Correlation-Id: 2be22f36-2011-409a-5fd1-08db3a9530cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2WKgrqelUymq0JqHByL2cNGijgNMs+TQqYBjTv9sMcXStpPvKVBYlO2z8gmn0w8exvBIXD/Y/kZzFjB1WDFaanoHL4VvMiNd9fYzdPl5VHFOCzTjSSaJfdkulfiKc4s43VSNsjOJMG/QYacyz2qLGDgFP9NS8cbdH/1rjPWdi2dU2KtxeobU61d73TGVaa1Pz1VuRZvg6CewBRlW65pX3wRCjiyHWKXOHw/0WF/tWnz8Dsy0zbPYUHALDv+CtKt3tx6eInG5uAdZXmgWkrYVFEU/u9UTCs21rFuXRpvLTBTS5QUyOUXEhhp7++LnStckHdN0d+zf7lYpc/run7zTgswutCa/PSRQnEl+GWL999h7hTrF9H2Ly3Xlt1kYhzMnEKDngnvMzfl/v5EjxTM/tE9C7ZQuUCZe6c5gQ3t6NDRotLvv0EsOknQ+/IGNwrzEG0BelhbtQtL+xIMSZacOcuSgr7M7vmtGhT59VZvuYqEiEa6u/y4pJ3rh4Je0pzl4LGc8hSemxI2Fgqmrzg/zBRCa/68hC36ACVkJrUCWwoMAQ7E2h5P6uBQajYRrtdZl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(376002)(346002)(39860400002)(136003)(451199021)(478600001)(6512007)(316002)(26005)(6506007)(186003)(54906003)(6486002)(2906002)(5660300002)(4326008)(66946007)(107886003)(41300700001)(8676002)(6916009)(66476007)(8936002)(66556008)(86362001)(83380400001)(36756003)(2616005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JFmWWngR1YYKJYso++hekIDiRF2pEiqsxZG51sTv8eBsNPzNHw2RsThEpRmd?=
 =?us-ascii?Q?iiM1AWB8AXGU2MLqIBPzPiwpkjyOGuzN4WMkyMNw1LanPsTMjEogkKPZMeXk?=
 =?us-ascii?Q?PbBR6jgugAGZTKzL3VNxOgpqW4bqbQlx83ZcfyT/47yJLKe2Ces/L+Vsd6EE?=
 =?us-ascii?Q?hyQQvyCJm4NRmfx1GzxdYnWBjbcoWfxChxJJfSn0K7Hhafn117S+zLBlY/qU?=
 =?us-ascii?Q?+NZI9kT0kn3aNpbSHYiO4g8cNvMAMVwP8vluCxLqEHEASPdklguwb6mV4jCY?=
 =?us-ascii?Q?aE7stmSTB30nj+F4gp2yBZJvbvrivNaOFoz2nIbfxxD1g6PMxmjMsGDu7eT9?=
 =?us-ascii?Q?w9G4q2tHX5nQigmoTAdO7wOIeGa2OfxpNlBj2nCNMcM7zbBOWgLxyV892xvw?=
 =?us-ascii?Q?4BMaRD0XBl4vaQVa2p8JuG5il7sSSGDtKh7YmUn7+5RrbhrPmN9wFEJnZNgd?=
 =?us-ascii?Q?PW4ID82qlg2i1SfMvfH+4LWJz3RWsrIndKZbC5wR4R+Tg2MFdqPvPQQZY25i?=
 =?us-ascii?Q?jF8QycAt/5sAOM5jhPRtRvDRr9nBeTM/yi5f6M17I0kAATGfXLOD1Vcp0nr2?=
 =?us-ascii?Q?k38U83Fl15C07+I6gL/GDv4yWISVFQE0IXLePdHLx4Dh2IN5rPdyze0vcMxC?=
 =?us-ascii?Q?//lpuKR1bP5NvyncoqFCJpF+amEvrgy8YwWCM0LyPdCxYDj6UmtfICZ9F5tl?=
 =?us-ascii?Q?8nTFFtHPAu42ZG/cWu3GnIzwxjtNUA0yh367MMeBnyvVV3xGqGSRNlliIugh?=
 =?us-ascii?Q?JJWqq1kdB+RqR41a7cgtsNTEKN0P+cuQxnFJMvZkwmhcFKYNGtzZmfMFyQLd?=
 =?us-ascii?Q?eip00I16J6Xh/BhYTi/KIhxtFUWTAH9qWzW8iBvlrhRLUk63/YKXtHOU0wA1?=
 =?us-ascii?Q?TfI8a4lT5PNmULwM0kbGNWaRSpirxKBiz7kv3uy+lCxCNSa6TbQA+icacdAn?=
 =?us-ascii?Q?/w26e32o7Sbq2nN2oH+0rSAUVHp64Wa5LVL6y4hul3zLNJPnXdpD9j6ZgcOS?=
 =?us-ascii?Q?NJVOftYWBUFwvJtaN/Z+biDABEaTrx5gh4XKcYUr0Q3Z7pePPP7K2wuRIbZk?=
 =?us-ascii?Q?vRRkLVuZeS53828W81HQRhMTuxTxFZbwDNx9t0g4bsO1bkjFJKZNbqje/cb9?=
 =?us-ascii?Q?7bIVPhYxsEjMMHNotPsxHw4KCxDFmGWp2J+bAGwNXUiajbyvJvoRdUtj+zI7?=
 =?us-ascii?Q?w/iHKSdQNn6iKFI40ZOFJV80r/ja5e+sqKJtkKMvDHmflL3DE9YH5UbK3R8r?=
 =?us-ascii?Q?bamPE9hgMYxrFhfM2QDQ+/REMpTG+xVm8DoFs8bQQQVuaz9AxdVJf+6iGnAO?=
 =?us-ascii?Q?9z9abc3Dsu1b2BB1s2yI9M3JObWY9vkgyjZy/iFb8AGPGXxsRMwcxQi+iuHD?=
 =?us-ascii?Q?o+SOsTRohs2FpyQwW94ZkDrw6zRoDLdh2oh6UmpEG2s3iKO0PeNH5B3iNWTv?=
 =?us-ascii?Q?qBXfteErEvpKeHRFGgnd4Wv1i9DRNWS2rNapvLND7JOlwgaElY8+8AreW59H?=
 =?us-ascii?Q?LQn9Apv2sVQvCFD8/hLDkpYpA2XC+5uhuOUScBdLux+qQMwniKTrhOOiqZK4?=
 =?us-ascii?Q?AeQabbwoXTINu/rKb/Xu6Xix/rA/h4c8sD1P62qN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2be22f36-2011-409a-5fd1-08db3a9530cf
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 14:01:04.8346
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xlj5sXJyupgMiTJuAS7qTOaMF0WY4X4uO3FTPZ5qYIusPBv4Y2wm0auz3+eSurhK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4927
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 10, 2023 at 04:07:49PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> From Avihai,
> 
> Currently, Relaxed Ordering (RO) can't be used in VFs directly and in
> VFs assigned to QEMU, even if the PF supports RO. This is due to issues
> in reporting/emulation of PCI config space RO bit and due to current
> HCA capability behavior.
> 
> This series fixes it by using a new HCA capability and by relying on FW
> to do the "right thing" according to the PF's PCI config space RO value.
> 
> Allowing RO in VFs and VMs is valuable since it can greatly improve
> performance on some setups. For example, testing throughput of a VF on
> an AMD EPYC 7763 and ConnectX-6 Dx setup showed roughly 60% performance
> improvement.
> 
> Thanks
> 
> Avihai Horon (4):
>   RDMA/mlx5: Remove pcie_relaxed_ordering_enabled() check for RO write
>   RDMA/mlx5: Check pcie_relaxed_ordering_enabled() in UMR
>   net/mlx5: Update relaxed ordering read HCA capabilities
>   RDMA/mlx5: Allow relaxed ordering read in VFs and VMs

This looks OK, but the patch structure is pretty confusing.

It seems to me there are really only two patches here, the first is to
add some static inline

'mlx5 supports read ro'

which supports both the cap bits described in
the PRM, with a little comment to explain that old devices only set
the old cap.

And a second patch to call it in all the places we need to check before
setting the mkc ro read bit.

Maybe a final third patch to sort out that mistake in the write side.

But this really doesn't have anything to do with VFs and VMs, this is
adjusting the code to follow the current PRM because the old one was
mis-desgined.

Jason
