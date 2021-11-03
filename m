Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58A37444590
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 17:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232693AbhKCQOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 12:14:14 -0400
Received: from mail-dm6nam11on2043.outbound.protection.outlook.com ([40.107.223.43]:64097
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232845AbhKCQOM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 12:14:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BaiYFj6iPG/+hovVYzLYZEoe0bUu86PBIvxpRwcAKe4/ymemX46XlxB+bUCNFFtKCKDlcZJKZGyFp0LJ6TFVCsLz/bg2Uhfa9z8NV9VWfIY3JYsF/lSDtZzp/RbZGpEOPriI1kFHadH22ArklohRNnZ3i97+IS+D979YKW/C0bVubttud+sGh9lBTqE4q0F/EnSqMlXm4wXUqotmRNL9df5t/cxN4XWy8BraJKO7vEx9qODu+Ra8xTDS4xlZVU0XbOqZYHYLX8LdeiArHiRNyMzPTcya7WJlYlcju5mJ4OPuaeX6GPtwaWeVPOstOM8JshcE9KCALegCfXexnluUVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fto1Y+iDZsW+u8Uprp2mgJE+KeLFPXTIISvD6Ww9Bd4=;
 b=d3Xle8PUaaHtH4PWniFEJVi0Vu3rrd2IgGZeDnhMnCCkXRxGxsaVN9j6vUPBq/G4VKF+dCfdFrUxcQ2fy+KTd+eh8K4LUCLF+yJEDFJ9NUPQPA/agLdFdB9GVseeDVID4WU313MWfRc8v1ygkXC1D+Ioj1oQqlNmMPNe+x+SViw7azCsyZ7PokLOp0GomlM7skCSupV1+wsBFHQLl3Gi11DEyc3BFO+ulDd+UkBT5ORuLkbQCRZkLjZd6HucvIvGMjF56lQFBzCAqnFZEUsuLgEGKB/OaWUHFT+sbbbQpc70w0QsF2LPnaWQKG63eM2rC8jNPEg6wp2uldqpra+n6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fto1Y+iDZsW+u8Uprp2mgJE+KeLFPXTIISvD6Ww9Bd4=;
 b=i3KWA2x/ECliGaNnUP1G7qGhQHXWWnLrY06afLwRONdDdmAwWDsP0rMqwJRRxGuFGFH46tAcUb/OEyvJDznIQq7v5VDybIsMbJEQs3wTPUvSqJMCIEy0IDIWi+hSdWPkLozjy+8dmAeLAf09k7r+OD0MuZcQvNxj40KD2mFruFMAbLadmGLNHAq4y7kzBMJ9053+7pgDgVK82v5q7ze2cZEk61XUhxWLe/Uso4Fot5q05NZqfZhkYvacoFCBeTgDhfpWYyERK4ouPatcIWNUGZmYamjT5+PRUFhjzagJddgYtcZ+W5y3PX8wMSTLWh9XZX3KAqZyKeoE1qTaiefpjw==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB5520.namprd12.prod.outlook.com (2603:10b6:5:208::9) by
 DM8PR12MB5462.namprd12.prod.outlook.com (2603:10b6:8:24::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4669.11; Wed, 3 Nov 2021 16:11:35 +0000
Received: from DM6PR12MB5520.namprd12.prod.outlook.com
 ([fe80::8817:6826:b654:6944]) by DM6PR12MB5520.namprd12.prod.outlook.com
 ([fe80::8817:6826:b654:6944%6]) with mapi id 15.20.4649.020; Wed, 3 Nov 2021
 16:11:34 +0000
Date:   Wed, 3 Nov 2021 13:11:33 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ziyang Xuan <william.xuanziyang@huawei.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] net: vlan: fix a UAF in vlan_dev_real_dev()
Message-ID: <20211103161133.GS2744544@nvidia.com>
References: <20211102021218.955277-1-william.xuanziyang@huawei.com>
 <20211103135034.GP2744544@nvidia.com>
 <20211103084746.2ae1c324@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211103084746.2ae1c324@kicinski-fedora-PC1C0HJN>
X-ClientProxiedBy: MN2PR20CA0036.namprd20.prod.outlook.com
 (2603:10b6:208:e8::49) To DM6PR12MB5520.namprd12.prod.outlook.com
 (2603:10b6:5:208::9)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR20CA0036.namprd20.prod.outlook.com (2603:10b6:208:e8::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Wed, 3 Nov 2021 16:11:34 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1miIrN-005gTn-L9; Wed, 03 Nov 2021 13:11:33 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2463bafa-d139-4f1b-307a-08d99ee49b6e
X-MS-TrafficTypeDiagnostic: DM8PR12MB5462:
X-Microsoft-Antispam-PRVS: <DM8PR12MB54620431C2D2653780464EFBC28C9@DM8PR12MB5462.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rslWJagRGhkBXznYmkfOMsgjO7XXoY0626t9Ust2jf2o7LdOy8aKmoFSQB7Asd8cmzJ5HhVGVKZOs5zAo+QhyT5Ro3jYjrUK7Pv+2DaHKjt4DnMpZOwfcxfgNQk+pFhY7pd63dXPZYZzDk06yB6CIOML/iycyWzgUR4JmPUUoMUCZTIhddU1n3kIRKhdnyB0Y+nnAfVEkH2SuqEWsgA8xGupNU+W7CBFvs9oVthS47ltQ9taSqL6hvuavCt2pL5szXYw5EXUFtXJk4fO+IGM4r+9PdP/2OBqF9Xh9sR5mGldwW1ZOwXBv8DrnUrhxg/OZHaWy0S2BB/Le0C6W38mOZ1QkfRAWywDutclhvu0RjYwEmCOJXoyX6QCywY8E6kV/Keue1luXjfN5UI7ZPu2W9ix/Zs2OwK5joj5KPQTMYMVawIfUOBoyoLzKwyKOiu2D6x2naiCWUAe/TV/GgroOycjhsVpn43YEkbeTGv6japU9cNbWRMoG5UQXTpJyDj2cJLxrrynYMM16nXs6SfkQpYPlN4Elyh2/FI3R+ca0qVxaTb4a/GxSixp7HCeApYnePD6D6XfKFGX+pZ6zCEa3ECtog5iFcybb2hHfnRQTxX+L6uCHC/xEsws2AJHw63r9g7KFo3u7Z9gj9+90i5ZMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5520.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(9786002)(4326008)(66476007)(66556008)(5660300002)(508600001)(9746002)(4744005)(316002)(66946007)(2906002)(426003)(1076003)(2616005)(33656002)(186003)(8936002)(8676002)(26005)(38100700002)(36756003)(6916009)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cTFpd+40/eoMrkJSVKEftdugvUghu1Od9/iEJfaVoQ3UhwtMKH8lo1NZebw5?=
 =?us-ascii?Q?bXDvaf7+gXo20lAQRR7wiZDsLYDEX+/uObWpPertHh5/H7qjJyx0s8LklBt5?=
 =?us-ascii?Q?xB5fJ7RrXsNIsmL9OdsMhp8AHxF/Bt0cZpJy1v343aMqS57pWRsfro/CsFYf?=
 =?us-ascii?Q?TOW1cZ9MqBP2ZYgplINxUjlW/zCYO/zQ6WyN5FLeQ9ClMn2DTs5GvAMoq+qH?=
 =?us-ascii?Q?VZ2eQu8smdoN8fDXpnyPP/d7vRSqsU3AFSMtR7BuqdgHm14dLfR7hJgGYF/z?=
 =?us-ascii?Q?5myxfNNeC17YVsPaJn0zSafqTnTlDcZtwDHOrQRZrQQJR7q411HbbDU19Hws?=
 =?us-ascii?Q?7YosK39GGyVAK3z38SBm7Znhl39XlfnUzKA2RoOu9FHu5Lyu3Vs3GyVfHoYu?=
 =?us-ascii?Q?eEBfjsDfopWcW6XUZ3dyslZ7N1K/+x/6So/mHmS62fRIjXwW88UKoHiraEBn?=
 =?us-ascii?Q?w+P0mvvgqhFhNAy5wFr2A6+iZ4BTytYSbDZ6m7sc7qXLO95gdu0u1GaHmQCh?=
 =?us-ascii?Q?CKpnUwUcYE7qpQXj7ediTz1sRzJI1AkjUAJbL3hbvJhpriDNbhQuBFSxi5fv?=
 =?us-ascii?Q?Mjm9bLKW4WARL2AOiyta12479YpYAK7bVkmqWthr1J4CyBbvFkckwSpGCdJe?=
 =?us-ascii?Q?14weAjayMiOXn3kb+bV0ZrKqgTcbefAXnVcTE+xceM8DS7Hd7NQYrEayPUT3?=
 =?us-ascii?Q?4H/mig53OnvtWU6s56oTrszQ8tGdw/42dmS4gJrP4W0uBUr/dVgKDd2Ic8p1?=
 =?us-ascii?Q?clgsiR+CpXAa+o3ciaA6MSNtcEXiOUv9lciMgZQnn0EbxlwmNqvJABsfq0mz?=
 =?us-ascii?Q?QAFhvp+06QNJb0zgpKzZosOCsGW6WadWdBM9/eyh6f2RtTuzErlRPluMrnBS?=
 =?us-ascii?Q?SQ/ifvWh4FYgHUjdGApqHnRFWzvwxqO658BGuZoaw8ZawVnKScf2mhFdQJc2?=
 =?us-ascii?Q?/YCCRORHMjZnmIHPjHuT0tMGMGEAR/ckN9WJQV8tcg7kZUJ29qFkfOgclkGR?=
 =?us-ascii?Q?2OAXqmP7qtGPcT+LF5oNR/c0DK3lvK/SBYcdQQNuQRiABWOoWaEUb1U+V6BT?=
 =?us-ascii?Q?Ms567URbA402iKBN3X6lyNfF5YOjG/La5RvCvtf6NLITnnOvXZAYycBfc1SV?=
 =?us-ascii?Q?jje0M6FtRthmHJsPm9e5YkrUOiwALtTgUoaaarWwBTVd7JtLlXYFssCbWHFm?=
 =?us-ascii?Q?Nl2phEDLqzn0Vr086WLBrPlaGLq3/AcSljL0wmbt2ZwNwWherGedU8wJV/uD?=
 =?us-ascii?Q?35tWJXArl1b3OroKedMj09u1vIE6JdiEJbwfdIESVzSzHHWJiHKgjmLHIMaj?=
 =?us-ascii?Q?3BWBujB+j0U0tuOy+ggVir/H8TDdpPShXIu66B7hxPQJpGpQ2ruxEIJR6dht?=
 =?us-ascii?Q?TrT9MhbHgEgHLDG14+sYjgyc3ki5f9uPNw1mlxFrzknbZ7pnlavkeQSt3Wfc?=
 =?us-ascii?Q?y1WzFhOGb3D4H9NZAvLTpk6msnSyB/ubjNo26WrTrha1NWr35lseATDZoUAg?=
 =?us-ascii?Q?wRtxI3iaMhzP5dzVczaN5NswwL3QlWVq16Ef+4AsPU/amIU7pmcLIC2CnMFM?=
 =?us-ascii?Q?tUY/+By3JJMI5WGLN+M=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2463bafa-d139-4f1b-307a-08d99ee49b6e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB5520.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2021 16:11:34.8093
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OBW8l+/p4qAEIm/RG+QL/vtEd4SAVT5CzMK/Oxu1FztSzyUDPlujGgD2gkfa86fv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5462
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 03, 2021 at 08:47:46AM -0700, Jakub Kicinski wrote:
> On Wed, 3 Nov 2021 10:50:34 -0300 Jason Gunthorpe wrote:
> > (though I can't tell either if there is a possiblecircular dep problem
> > in some oddball case)
> 
> Same, luckily we're just starting a new dev cycle and syzbot can have
> at it. 
> 
> We should probably not let this patch get into stable right away -
> assuming you agree - would you mind nacking the selection if it happens?
> I'm not sure I'll get CCed since it doesn't have my tags.

I will make an effort, sure. It is hard to be confident due to all the
stable selection emails I get :|

Thanks,
Jason
