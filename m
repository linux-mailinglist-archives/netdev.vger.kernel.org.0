Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F976601434
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 19:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbiJQRDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 13:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbiJQRDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 13:03:24 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2077.outbound.protection.outlook.com [40.107.220.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A786F24C;
        Mon, 17 Oct 2022 10:03:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WDPnJWxNyikFSP1JxvP7cuNzVd9wJbWkE5gc5AM1f8NYOy6w0deMXthag6JWROSMnI349xLAk/mXQEngWu9+5eYU2RLoshT7GpgmY0IgyD8n0iS7Xlib+hDvWKzc2SH0YG16xZZ5fqKhTxXrAjobdVIQht2zF0Pgu2TrlNmCZZz5+rxoOdFJjbAagZLMuxD3OeJTp2WwBbV8aayY+LFdFWuetCOkRTndzdI3Pn6unR2BGMjLg2qyzKwgt8bHW6WVlqTTyOd6TwbSkkvjZQZgHrRZ/hp9TLLspecbaxt/uTHH84UE8EY4lk8s1u4XevzBEZdffoHomn5BzBqIVYwgkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sJndO+WYzbz5is5kB3zdIkNOVtirp5H2I1z+a+edfSs=;
 b=Yw/qGHHCE92nivX0g9yKaquUyatg8yEntI3o6YEh1NOO8u2/5uxp/6PUl0ILRxPykQmfFNwTV+VlWHUgL9QYX8wzj7szGZFQgXM8r5jOb/BbT2wVd0K0k92Fb1wDYkrZMecaNt4Qb1c92FGscKyMhzfzkilfPwXXJ/y+2qb5Kkl6CYJ0qOTjl5knHH1HzBDRNARdm0G3sMREfSw0MjXSDyq4bGdESi8AjhKEqiZZ2+xjaHGWXkJGsiQNJUeFUkgJ7isRAMf1xtsuTMcXS0BIvlpXvj93bVXXYOiiC98czccMXBr2ZPJ4eh79K5Rn1BpeHUAeRuVnfynoH4045qDeqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sJndO+WYzbz5is5kB3zdIkNOVtirp5H2I1z+a+edfSs=;
 b=Q7bzqYh9T7iCqAwgqDlEPD5jetxV3x9K+QPBFZSdezBHLZ1Yq2hdJuSvcw7iP+vxhUx+z9nKWcSLUSP+Lux4ZFwJxmQZolwVpLGvzYqHL9qcaS7o41BfJyTlXDS/N08UpR2jlcDaWVEAjyuKoAV5dfDqMPWODRL4znZGyd23p3jje+unNhZkbeNJUtZmSnG7ZYb+fKKWOJuz9W9ydtsNC1BPjotCnb6CAFVf4ZJkO5+mvWhw69tmZ95nbbUlqyNcZcagV/wfOXA0MJW5EcFWF7BHjd1inwVUbNkHTm9D5onuqJV90TkTNdfbHPJU1Sb3e8+IgUorBKk5b52KhbkbCg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BN9PR12MB5384.namprd12.prod.outlook.com (2603:10b6:408:105::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30; Mon, 17 Oct
 2022 17:03:15 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%6]) with mapi id 15.20.5723.033; Mon, 17 Oct 2022
 17:03:14 +0000
Date:   Mon, 17 Oct 2022 14:03:11 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Nikolay Kichukov <nikolay@oldum.net>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: Re: [PATCH v6 11/11] net/9p: allocate appropriate reduced message
 buffers
Message-ID: <Y02Kz2xuntFrKXhV@nvidia.com>
References: <cover.1657920926.git.linux_oss@crudebyte.com>
 <3f51590535dc96ed0a165b8218c57639cfa5c36c.1657920926.git.linux_oss@crudebyte.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f51590535dc96ed0a165b8218c57639cfa5c36c.1657920926.git.linux_oss@crudebyte.com>
X-ClientProxiedBy: BYAPR05CA0090.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::31) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BN9PR12MB5384:EE_
X-MS-Office365-Filtering-Correlation-Id: 84275d8c-183a-472e-708c-08dab0617adb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1IinCNpJ+Jh5MPezwnaNA1P/sGtXgnUhMjpAVcHvcyNyPIboVYRnb9R7EX0BUp7xlljUj78dWIq29oRc+4cD/gHXs490VIkqKCjiJ2VXudObrJc7kvTPtNbxw4raQKhtyXJSyG3u5/kwySkJOSlNQ0hXKsEoVDK69v/bW1uspIb3NVVDeCYuK5BZIarxnYAr9H0DXwz5YEAglHGN1OXyL68UXgVtl/aHEClSHB6SPlSneHvMMtagfBk/Dduq6ajXFpNt3fwG29iuj9QpwcZp0vLBp+3rSDcCyMjiFTNci+HfFXa4IS3Zh5B9eJ+/JPaJn8yCtuxtXVhYV3ak9tnRFDWPbpTDpYb+q0lcpe1WpVF6LwdXdry0qLxuAuAZXgY3s2y+Us7yk/AoYy64gyj64ixpmVdb2wtil+EVjy3xz43sg8tRElOuJ68RnOrBZcCC4+xskKh9ZMSCsmjjWphnnoPGFHqTNHNxP8G9qJJxWmiFrJB4SAE3irIMnglFUehASy1ejRpepGy+ZK0WPe7ZXR/Jtrm+Qk3OSehcK3JbwWGC6r+YTCleRXhpvDP70J7vdRTliMdIogqAzup8zw4dsj1+5kCG5dFr9ynA9qtUGN9NGrmt6AnoTBRyY+WNJ2pfcbBV+ynuZBRboHQALslsGD1qLtCot3Yp2L1jNYlZ48FH22Mhn5Rf1viARafXVEz4CffTeAJ1hdzC3WNr7N5yyJlSc0ShwizBw0qh6HRuSZ/ABmXNbeJPZ4HmfNmJ6zGX5KkuZPk87KgZmocgz5Mhn+ls5LsfbJBOwyshkZPqgeLeabN8/fYOkCEmdcdMamsXFO3jlTeP7ih//JKDqOb4tw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(396003)(346002)(366004)(39860400002)(451199015)(54906003)(6916009)(66476007)(66946007)(66556008)(6666004)(107886003)(8676002)(4326008)(316002)(2616005)(15650500001)(186003)(2906002)(86362001)(83380400001)(26005)(41300700001)(6506007)(36756003)(5660300002)(6512007)(8936002)(966005)(6486002)(478600001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BpMlDZcESj5Ky3gdtz07V/6+rE4qFUhCzedopRZ8ss33PisdkQDat6vek5LS?=
 =?us-ascii?Q?LUnwo1LQ2A0EaEEd7OQN7ToCU8pjqbjrMKo563Fw3TxoPG1D1JFQAKlesMjH?=
 =?us-ascii?Q?UuQ0xTrM4jmxYoZZDpigIIo5pUVz7d7tBF6X9iEl08tg75EwezrNipdS7xMR?=
 =?us-ascii?Q?vauui+QFKsOsdCHqbJm7h3u70BVvdg1NYOhgJ/4iq+pmYyG5UqT6hvHe1iwZ?=
 =?us-ascii?Q?TP+oGmcZt26jwv14L5r9FLwtHExR7ioKbmveruvh0Welhyu7yNdxQifKPgin?=
 =?us-ascii?Q?JN97gb4R3UfqysgBojEd4GlLaJM8/dPF7Mk7qWpgQWySs0+iCIIBjCMs5a0k?=
 =?us-ascii?Q?6x2mBZL5ZXjJKVz0odLI4Hhv2/BmLbbWSJDfWlKF4UzZpkPheja44ndijs0V?=
 =?us-ascii?Q?O7h/MBhXv/RX/QldRwCTx/L2kq7b8F7dlXJUl1054OX1xti4jwfjT9w0tCi7?=
 =?us-ascii?Q?jheL7M4SHm4YzIeskfLaaE/N9iorGcUgqyJz5lpSSrq1ANnOTTWiEqtFiubH?=
 =?us-ascii?Q?Ys2b0zkbfiQUWFntwNzob88ZPAVZSa9CkOvpXwYcfBkM7l4zx+kKNq2G+ZOa?=
 =?us-ascii?Q?6L4VxgSQ7B0adlUgYdWDQ8+1wKJV52fRs0V2+qP/BddVZsQf1XTTleENFYff?=
 =?us-ascii?Q?6M8p5auH1/5xPBpRHFjaHjxMOMVqxrlonuq6U0k+tzo2kW1Z81SAvgEDw0Ds?=
 =?us-ascii?Q?SRwbd2H2GWn4RGGvs+BwA1dyT843TpWHzcJVwumYLzpRh3GlPVc/IvKCKDlo?=
 =?us-ascii?Q?ScM1EUi7sx8liITiUXqftUOn1rVHukkKNrvTcYdaCErZsImR0W0P14xO4ojW?=
 =?us-ascii?Q?dlWXDEsf0hIyBbJzkd6tZpcvPlbWbX20NiHCwLWrhIKoyDsF3GrOfa6FG1iI?=
 =?us-ascii?Q?p/xclC5exJhQNq1F8klmTvNF+5ASDWlzXyZ/x7QhDonfK47HGHOrgPYem00X?=
 =?us-ascii?Q?w/di/mcHqb3i5q8hajKbvEIcjiDe+WVZ1fjURNieSqmDhf5caXMl4+8Df0u0?=
 =?us-ascii?Q?masFN5glEiZsn/LmDqY/Md8jT3Bic1Q/9Zho+djZiXHzd2wSdIB5tBMhJnRo?=
 =?us-ascii?Q?ponpQfCwpIM2R6N+ctNj2yjeujBm4nUFPJ4IMcF+63+peMDVMUvr5D3Emtpe?=
 =?us-ascii?Q?KdiSIGoNOkJGOZRYw6IB8WPD2HqVm8SPvHbClpXOQKPMzOklK28qDCNwo1Dp?=
 =?us-ascii?Q?w/QPsc4R5CiqkRZnMBKT3OZTKWuaKKn26p0znBsYGfgoTT0WcdSqtDSVET9O?=
 =?us-ascii?Q?X3m4ezlFZw2vLiEPG+ymBR4xb0rVx/65cPm+j/zSImRXWKkfYbn6pohgrKXN?=
 =?us-ascii?Q?CQhDdWY1kqSHf/XuLr3FKJCaY5JdUVrJEJ6j19+BQJKtMqQlxNTgGc+Htyo3?=
 =?us-ascii?Q?dc/AK86dM/I1oH7rgUOydZuVno6aUDPEQPWTTPbTWXh3leWNRcE8iZWauu6d?=
 =?us-ascii?Q?z25uoJBS3tYTLiPstd+0CisMz1i6cppjm8TMBXOkRZaR/LMSIY4WJRxazdqA?=
 =?us-ascii?Q?465p69kncQQ8nwpGPRoOzLcr0QlwMVM7suzbS0gU8P713O9lkermxfJnILEd?=
 =?us-ascii?Q?WCuxwMpc3iH66JC2MDg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84275d8c-183a-472e-708c-08dab0617adb
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2022 17:03:14.7895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZRqX8ZoZfxqil7IyCoYZfYygBWNvdxic3fmetTNJ8OzeCdbFgOtbrb/4m5zhsEIY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5384
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 15, 2022 at 11:33:56PM +0200, Christian Schoenebeck wrote:
> So far 'msize' was simply used for all 9p message types, which is far
> too much and slowed down performance tremendously with large values
> for user configurable 'msize' option.
> 
> Let's stop this waste by using the new p9_msg_buf_size() function for
> allocating more appropriate, smaller buffers according to what is
> actually sent over the wire.
> 
> Only exception: RDMA transport is currently excluded from this message
> size optimization - for its response buffers that is - as RDMA transport
> would not cope with it, due to its response buffers being pulled from a
> shared pool. [1]
> 
> Link: https://lore.kernel.org/all/Ys3jjg52EIyITPua@codewreck.org/ [1]
> Signed-off-by: Christian Schoenebeck <linux_oss@crudebyte.com>
> ---
>  net/9p/client.c | 42 +++++++++++++++++++++++++++++++++++-------
>  1 file changed, 35 insertions(+), 7 deletions(-)

It took me a while to sort out, but for any others - this patch is
incompatible with qemu 5.0. It starts working again after this qemu
patch:

commit cf45183b718f02b1369e18c795dc51bc1821245d
Author: Stefano Stabellini <stefano.stabellini@xilinx.com>
Date:   Thu May 21 12:26:25 2020 -0700

    Revert "9p: init_in_iov_from_pdu can truncate the size"
    
    This reverts commit 16724a173049ac29c7b5ade741da93a0f46edff7.
    It causes https://bugs.launchpad.net/bugs/1877688.
    
    Signed-off-by: Stefano Stabellini <stefano.stabellini@xilinx.com>
    Reviewed-by: Christian Schoenebeck <qemu_oss@crudebyte.com>
    Message-Id: <20200521192627.15259-1-sstabellini@kernel.org>
    Signed-off-by: Greg Kurz <groug@kaod.org>

It causes something like this:

# modprobe ib_cm
qemu-system-x86_64: VirtFS reply type 117 needs 17 bytes, buffer has 17, less than minimum

Jason
