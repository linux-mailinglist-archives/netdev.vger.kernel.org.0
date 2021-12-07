Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48B1B46C33B
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 19:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240791AbhLGTCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 14:02:25 -0500
Received: from mail-dm6nam11on2056.outbound.protection.outlook.com ([40.107.223.56]:34113
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231778AbhLGTCY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 14:02:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UvciYHvRPGNz0Cj2A7ZE6v50mo8APivk61WO0sZCKR0nRikUQ+wZCH/X+8b2d2RdF7bEt5qedSdbSFaTPAHJ3K5qpNZxbp0fPEpNf2n76Ab7GdPJcXZXu7RguJNBYazFTWfzYOjqL5oEkyJdCSHl6isqleBErWZvsVmHbR4Bu+s90uc1wKPwim7WPSaAmvHJtlTnvlByQAclhD0c3OREB3BrCzGXM467rhZfSaS6L4IVi44Trjjv1EbqwlwMuuCaOyIOypiDvgq3UCeU2Vm9zHxX6DpC7DNZqsiOXAQF6H+8hzWmzRqOuFPRcQRLiVlbtheh/II8Sh888FPYZZX4Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D1xDlLn7OtbxWiFLhytif42tAWtAwrHyXlvYPL5Mugw=;
 b=ErJVwgMkhOkoa6rU6iLxLT+vc3E77buqXgIt6apFYR3rzQt9AdFEHbzw2Qgsaqs9gQ4btdJBAD4qeF/kyg2FzRGjaAkIX2mJgMufLSQ3VENZ/ETsN/wUomO3pfokIpac2qB2MnnwyItFrxJ6IPTa/WJe7A3imqfo9ZCDUXBmirbdvYa/i4tLWTy0Uo7uzxOppTbZ49u0Ez0Z1R7R9vPuq5AT9aitoAEh18LzLEB5C3jr29DMy1f2FkqaWw4a8oebOnoUoJv7RvvKMycJZiuWxSSgx2mWFjmFLEWZ9SVLzLDy7NkGb1TYtyQVYRe2gLB+dd3LnntPWsTYWJ3G9VE8Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D1xDlLn7OtbxWiFLhytif42tAWtAwrHyXlvYPL5Mugw=;
 b=i2rn/Oe1yIO0Mx/v1S/PWz7GnwueL+CHGiuCF/AVSce8/cQhsfF998wjXML1CKEMb/FKJiUn9zr2JKp0W95Uj6lDXe+4AFVPOIeG/0TwU2v4WKHHGpcwkYs2Z/Qm6iuOUYbYhIhLKWyXpRN/U01+X+eV2GyRqQkRO+N8S5ypLCFhxFIYbQqAFp2iMn4t0TqBxT8SQow35pAHCiS1RlWgmrqjNQ6LAVHprDUpDYVOvrYy+PcNWwvzx3v9DhQmec5URByYAC12ByYcvQH7fD5469rvAXxSqv+Pm6JQ/avL/0/19DBJH/RrAliekreg0GWL6BQwJ4deeW1EzmP1PRjxPQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.15; Tue, 7 Dec
 2021 18:58:52 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11%5]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 18:58:52 +0000
Date:   Tue, 7 Dec 2021 14:58:49 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH mlx5-next 0/4] Add support to multiple RDMA priorities
 for FDB rules
Message-ID: <20211207185849.GA119105@nvidia.com>
References: <20211201193621.9129-1-saeed@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211201193621.9129-1-saeed@kernel.org>
X-ClientProxiedBy: SJ0PR03CA0207.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::32) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by SJ0PR03CA0207.namprd03.prod.outlook.com (2603:10b6:a03:2ef::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20 via Frontend Transport; Tue, 7 Dec 2021 18:58:52 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mufft-000V02-7Z; Tue, 07 Dec 2021 14:58:49 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc3953cb-48f1-4dc2-4434-08d9b9b39c39
X-MS-TrafficTypeDiagnostic: BL0PR12MB5506:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB5506015AD152848B575B6B99C26E9@BL0PR12MB5506.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P5/Weedv1nv/W+0mAP65NirwBa+wFlZV6iS/ASUYLlSw/4f4c/ry0WFx7s3cGrHNuAVWxySwpN0az2CbXhIdZQozAi7rrq+6XzJChApiRKq1umR2ilVmqwwwj3mu60sfg/1il85iaD+rw9GUifAQmiLTVL5rfOcJA8ru5t4jqi39hDA150fMv10s66lR3KLTiOWxeZ/B4WptXNwjoE3lMRMBOPt0ygkRSPxEY9hHJJqS4nJMSOigbxBJ8l419ErK5TN0CArOkUVlodhacF0PPwoWRncS+fN6NzgobVkuLiSVughg/0NQt1aOL8YbRCnQPu29U1G0c4ai7+CsTtosIj9IP2Xop6TP1YtbrEppprPTiDg4M6COhb5WPVYjGzVT68A3h04WgV1oU1XJ2zsaRJNjUxga4K9ObvjS0VDjUVwXm+QkPh8Nkmd6nJJMsguhm8z5H4P6yn6+0viRQjhjW+g+MfQbYyTbbSelqnswNbjVkYcVYmdM9ywdwGm6rY0aB5DvlxfSFqxRNdT9486vDVnU6UYKqvQ9E5VVUSTfOGmQaUHFcmQYrkBJ4TzxBREHKo9QtubFcC38TAG7G2CC7KJ3qQrna0w30+DhMreJSThbCXTRLnISvQ4BuTKpWpMTClW3PtVrgHJs6lqmyN/6Q4TEyhF57jMqdSTeiZ53seRHVoeeliV9iFl1DRTZKSvyTjD7uMx50A66wy+OChDNbA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(4744005)(4326008)(426003)(33656002)(1076003)(6916009)(26005)(9786002)(36756003)(9746002)(66556008)(186003)(66946007)(66476007)(38100700002)(316002)(508600001)(5660300002)(8676002)(54906003)(2906002)(2616005)(8936002)(86362001)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NEJduoSYaVJbLaEaCH0XMmSTw6q1G1SpljUypyuOK55KBIB0a3VxojR79dxo?=
 =?us-ascii?Q?lPgb24Jwte7Qi+Q2aDaGeAqKO/DKkagx1OR8JlNPQsqf59mbOxwqkSEs/cUw?=
 =?us-ascii?Q?moXeMKMYIb0ve22W7+5CGfnZQaAVGT3O0NYN8gNuqK2vWjbl1NP9U3Vm1p7e?=
 =?us-ascii?Q?pEz/2ubHhmuskQZXy6zDnlhM9J3EppoUyEFvz8JpVeVtxv8tU1I8lAcgEQdH?=
 =?us-ascii?Q?nUjxTki/BFKfYABYIUX79+ztufdlsgx33SlZ97XSNGcgL7a+WnfGvl3upJdi?=
 =?us-ascii?Q?lMhIOt0wImbagU8h2oaqgycRUke8XHza+21Z29T4w/Gc3wINc7CBzz6F+7mS?=
 =?us-ascii?Q?sgUNCleMipzOZiirQrxRhIXxa0gKpoZSGVaOWzJUPh8l0Ir04H1GyNVubejY?=
 =?us-ascii?Q?4bHlFcwMOsFg4MFh9XlYHCKrnIrYUnRgYOZqqDwS4WetAyd8LXzB/Yf2D8GV?=
 =?us-ascii?Q?zjSzQxjJdOkZANvY9jsU02XCS57AUQ6qG6SAs8c4CwBAg/IOicve+GSH07lm?=
 =?us-ascii?Q?Nfkiu3ucQXBCjYImfJ84xdHJN31n+/RvTLTBIG7VvegicFZV9/XdtVO0o2Tj?=
 =?us-ascii?Q?KXgMmg/jlXdC0n7Ivl8M48dXPypXM9pmznTezV3qPsmrbBZBmO8bjlRU5f2r?=
 =?us-ascii?Q?VNR2pndolkcgJfMnZLaReSdym5Dc6gehSZzqPXUzsNYZsT4377U3iNSi5xm4?=
 =?us-ascii?Q?zwqAlVTkfzTA78JZLKlZPKYOZbVQ3GsKgGH59tiGnZnZeQ3p5fKmsTVEFPZN?=
 =?us-ascii?Q?WuCOvbuq+NaUp0w6cA1ITddASDr9jeFo/yBlKfaPVqx2R8c3eIXIXGLQAJ0b?=
 =?us-ascii?Q?zXHnRrt6aXY7R9SZPK+92iETGeeMqiX4bAWhtYb08Bko/0ccysaCe+PQFjRb?=
 =?us-ascii?Q?fAQBmHENmPo8kMlOjm5OFvD6NApoeu0X9wBVL++xzGaE5u/ay9u9CSauOQ6e?=
 =?us-ascii?Q?AR/X8XIED07f5KBnmasdZnupzoBRUoPOsJz89t6SUtVZCveYYY3Xj5+0blPE?=
 =?us-ascii?Q?lOwUv2JqRAWxQumRCCU17ZuPHIxC6jM9fG/IkE548umYQPt9F9NUoAtIVMzB?=
 =?us-ascii?Q?7vgpJWEr6KgvwCfCYsi7t52RAq5kZq4JCL1vT1bDA8wsVLTePH6yYYqBi8NJ?=
 =?us-ascii?Q?g0DG3NA6oKnuk03Au0nKkBe/iL8DC4uQd0jckB1BbLoad3SVqB8drxj+QLIe?=
 =?us-ascii?Q?7o3jFxeWdDlNfrXs1Bhedmkrr+sSmnpcPn506RzCb5zEn98FZTkoq5E302EN?=
 =?us-ascii?Q?/3hdyycXPJSlHjM0G4j9RY0qkzkDEIfyNQlNmflJhT8yAHfe5VWyf7gNvgNf?=
 =?us-ascii?Q?/CcFtdcHN4iSbpzl4nS5WSrJUDCeFjQk9FjYdEhsr8+jZDXAYbsdJf5i0l+F?=
 =?us-ascii?Q?RIV0qGy836RUq4NuynSiOkqyJlsDg/yCppGpBf3kV2OfZai7bubfB9T9iH/I?=
 =?us-ascii?Q?legEyuFDzP/ZU+FTmycyb7yfB5XQE3Xzb9SX9iR08wAGpZOkk1cY/C8gw6cS?=
 =?us-ascii?Q?J+ejkOLRVItM+HoX35FNFi6A3yIyH12XLzAdkF9qu7tCOmOhROW4dAyCsBM9?=
 =?us-ascii?Q?9E519OueLVpUu3etdnA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc3953cb-48f1-4dc2-4434-08d9b9b39c39
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 18:58:52.3106
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6l+BQ+yq5uxF8YMeFI2ELtLAv47emLTjUKVJ4H0/dc2p1carw43n6VzUWogE5WiK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5506
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 01, 2021 at 11:36:17AM -0800, Saeed Mahameed wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> Currently, the driver ignores the user's priority for flow steering
> rules in FDB namespace. Change it and create the rule in the right
> priority.
> 
> It will allow to create FDB steering rules in up to 16 different
> priorities.
> 
> Maor Gottlieb (4):
>   net/mlx5: Separate FDB namespace
>   net/mlx5: Refactor mlx5_get_flow_namespace
>   net/mlx5: Create more priorities for FDB bypass namespace
>   RDMA/mlx5: Add support to multiple priorities for FDB rules
> 
>  drivers/infiniband/hw/mlx5/fs.c               | 18 ++---
>  drivers/infiniband/hw/mlx5/mlx5_ib.h          |  3 +-
>  .../net/ethernet/mellanox/mlx5/core/fs_cmd.c  |  4 +-
>  .../net/ethernet/mellanox/mlx5/core/fs_core.c | 76 +++++++++++++++----
>  include/linux/mlx5/fs.h                       |  1 +
>  5 files changed, 75 insertions(+), 27 deletions(-)

Did you want this to go to the rdma tree? If so it seems fine, please
update the shared branch

Thanks,
Jason
