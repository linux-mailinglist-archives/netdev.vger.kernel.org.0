Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BACA68D0E6
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 08:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbjBGHuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 02:50:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230478AbjBGHuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 02:50:10 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2056.outbound.protection.outlook.com [40.107.243.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE95231E09
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 23:50:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fhr+d1HcHtI4tUtQJ2HQQZlpYTu7PQ7BA9Py+s1wBe+Baty3cf+duw/7M41/9k48/l0yCgQgn0v4YB+R8mfpzj0Hquydsy+gFH3A26bhvFzZuMZ/dylh8BcV9lGU0En5OoLwFDnyXVRyl9mR5Lqe3cMe2YQL6J0xCgnBJmw1EfWJg/Bp5lXgaaVpncAujAxDvQSkI74tdaAv+9hAyjaTPTSMyfaR3BTggnv4yvZL+tqHEn/bBYzDqfB/y9ItXMb/4VWd7kePNIZq5n4UN5eCFu9bRkbiwC9LpVzDt3rCPkAwK5+qEcO1CMmE9wN6Wf7sj6XCaNau7MF/KXId/CRaOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bMy0tTXzdmTm5sy7JBiFRFPEwj29BI6HrFeHApih0b0=;
 b=ZAB2FPg4eIf55hkzaYwppxz3CxxnrjwmhWbfmNsHlKaIgPnjor+hnt5V0VN7UQy7737/drM70eQtXRWtpSflZG8d8IMS1TGT82fyDndX7NrBubb/Wau0t6/RxIHzP9IJ2ap5KYayAPO47OJiprckFuq8mkXNRLWGwQ+w4wtelJqVEuqtlWMO7DtOr+L7yTBQfwdSeSbs8qBOm6qm8fLbK3OL9x1bsZFOrne0QJtZJnSx3RarcRihSJHrXjv+BMnt9CYGhD/86vwhDGYpIUEiksEqbiDdvnDJB7d2P0Tek9WNyfNeYP5Q700VAvm7WJGz3FQKQdO0DUWjt5E3ywWjtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bMy0tTXzdmTm5sy7JBiFRFPEwj29BI6HrFeHApih0b0=;
 b=pTPdhLLp9Ij20+2TxcIKcKMRse+5QFhjQ2HOsC2Su+9Dq2Qr4IeGQV73hSjjcDpc+LqvvmmjfSvjlG225ZLk3MP3Lw2o+hUjh0cZIyPhy9jyxtIpNAybTczyXUXaJc5ZOuklOGw+AchNeV5Vl+gIPyBZgmn/zsRUNTJ4Mpt0VAdBpw1rM2NAfWJOFAE0q9Dw1isIFxuinKhRrkt76kCgqvidpmmWFIMxXduB7iBCA2ykcv+F7JsGHPz3ZpPtwrHWySXcnDaz/UF5X/bZTm+PgRf2PgtRGWNoIPVSjCBnUg3sUqSVlS4YEjpzVQ1w8/VOFCrsMyvtwwnz7kVFzeqjHQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DS0PR12MB8453.namprd12.prod.outlook.com (2603:10b6:8:157::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Tue, 7 Feb
 2023 07:50:07 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab%9]) with mapi id 15.20.6064.035; Tue, 7 Feb 2023
 07:50:07 +0000
Date:   Tue, 7 Feb 2023 09:50:00 +0200
From:   Ido Schimmel <idosch@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: Re: [PATCH iproute2-next 3/3] man: man8: bridge: Describe
 mcast_max_groups
Message-ID: <Y+ICqOZwDnzJz2ZK@shredder>
References: <cover.1675705077.git.petrm@nvidia.com>
 <924ecbb716124faa45ffb204b68b679634839293.1675705077.git.petrm@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <924ecbb716124faa45ffb204b68b679634839293.1675705077.git.petrm@nvidia.com>
X-ClientProxiedBy: VI1P195CA0050.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:5a::39) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DS0PR12MB8453:EE_
X-MS-Office365-Filtering-Correlation-Id: 7213af8c-0bff-4af3-4c79-08db08dfee11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PMbCtg+IPveyjLSM0JeaLYARsFvYc7S9J0k+mWvfWKgHArJgqb+XrN2RorFzpMqGJ34+rrRraShlAMxJIWhJyZX1geX6PxJyO0lX9ngG7lMbWbhFzXnfuanrXP+nUUGC7Y6oIEyTCA+HbSOP2qfwW/mWt9ZF4xU/HgoJaZ9YvEoXA5ypT1+m6tK1e8F8LLUKmMuoKIClQ314EKoc7BOytss4U6S24S2alXwhx94oQYXW/cqfp6xI6pdzsRiCPCxruqUXlmkLuzqU08LK6/CaVXzRb+fHLU/z1fxZuPxlvNowM7s7Zaeejb0uI8fg0vMkhLFSVup4PhxgZUnMIDIORtBOI4InQiTOrZvezW8gZZd23LvDiYmYskg+2YBtL5kLBbCTJS8h/bwZr9n8hBVjbS+bXpTLh2TXJA7iLpLWpS5LX4FLblsgMdPXJKkQSlsGdORJ9jOnwpmzi8O9wRJKVF5AYThsR07KLsoXeK0LfAabOENS3r2HRQOBi7YqjeJGnB+uBNNZYZz91zLhRa8sxgi11VnSqiLLuMJde5xgkTrMaFK61wjtvcLPR1c5+E+aGKRrZxpB6eHiVH5zXc/MhEfk+zs2hQPdFuq2VddNqlnbGFmuTay8qgfji1Z3GO2eudkj2zE9FT2PngPONdMh6yh9qFEldgiak6QigMsFBcKy4F8MSD7/IbwA+ttH52LK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(39860400002)(396003)(136003)(346002)(376002)(366004)(451199018)(6666004)(6486002)(478600001)(26005)(6636002)(186003)(6506007)(316002)(41300700001)(9686003)(6512007)(2906002)(5660300002)(6862004)(8936002)(66476007)(66946007)(8676002)(38100700002)(66556008)(558084003)(4326008)(86362001)(33716001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ky0cdWrgx7kUIjdRxtrWm96pB32YMqN9nyoCRSZxg4B0Z6Z6H8ZjqFesYQT0?=
 =?us-ascii?Q?noQsdoNfiWCR3DquiFlrGCBwlLXl3/6nvUEpELsIGA167PKYnh1v0+zxmRg2?=
 =?us-ascii?Q?TX6BbptDOSwB/Gt0ui/o0FhQTFroQCLaSDu3VmrDCoQaEtGleEOl3xzkyvvA?=
 =?us-ascii?Q?99ds+bU8EoGrFUCOiGRbsfiyt4SW6JpImeerFvUgUdtHeHOORHqAE8Jv99Ck?=
 =?us-ascii?Q?5oO5okmG5fROC/5k+X5d7AXV5J80DGrqR/vykWkNu0gZh1MKqtvUe7Q5pNYh?=
 =?us-ascii?Q?hx/PT9hHqz7lKGVoXzx35BJb415FCTnVogz0RkCmcJo36KE8JsyhVEZhT/oq?=
 =?us-ascii?Q?/U/qBvOkvfZzJ3p48NA22xAeUxW/mu517WA9j2pjLltp9BnGxQ1daw32Wkcp?=
 =?us-ascii?Q?BYHsbuJtuiaRDfY6+y+28cTTngQcfjPjfEY/j6k4M8ij6UO0xq993LKfKrAG?=
 =?us-ascii?Q?QBK97ePvxOEWU/WgStpO/B01lUe20G8+OoQBzEm3yOwNLK5FNj8YWi3lgB1Y?=
 =?us-ascii?Q?ZBU8eIZAEnICHUnaJpOIVFRtjQSP9Pgxq8NRLxdVDGogKKtQsbSqlmmMaX4Z?=
 =?us-ascii?Q?6MoB89NngHpnH99TYR8piSnV/C2/ahgd5bEujKmu6K6BpGEjsbchewHU52es?=
 =?us-ascii?Q?LAL+Vix6e9Xx2JQube5Td4iZBwEabEhn1RzNn0J+oPUsllFfmLuZp0h47xbp?=
 =?us-ascii?Q?1svLmYXasVH0lC/G9UfmCYMpVxCovc4g+Duf76U28ewVSD843bu9tQErFKfo?=
 =?us-ascii?Q?r6Ruwjmk870CnbpEAOKgvu7mQVY24NOhZLrBMrjZuF3hTRnG3mZ4OqWieVhM?=
 =?us-ascii?Q?s9KtTIZzEu59pamuz54D1f1ravul4Ojhv5+uZd1kCgyX+NGWH+hmx5oRO6wd?=
 =?us-ascii?Q?szz1nco/f82oXJzTAws3B7GK9xlkvlKxALnjGtw2qxfvXHWUNJH+BCZ1r0hk?=
 =?us-ascii?Q?xBnKTYC2vDkhH/W+i74qSyWpLArFGQ/3IeoUvMUrluha00iSg03Nv9vsltkM?=
 =?us-ascii?Q?f9XIw08GhBtwX+sFIfcOhMtA+83LUWu94VV434P6nzeWmZGRryaSUiMN/UCT?=
 =?us-ascii?Q?8/MKzqvLf9qvM+D27IA0opUamqk17BtG/zhCtK8HgQ0V+WlPTjfIFmhEqdxE?=
 =?us-ascii?Q?WAElh9PQWa3sh4/GBhThbBY4WXpe04W2ydwVhZjTRn53hvFLsRe+oCK7XZT5?=
 =?us-ascii?Q?dSHpbpXWMOBoZ9wNdSuALgHYXeFJrYNA7Zztvcfgy6YRb1sdn0RRBIEJeezI?=
 =?us-ascii?Q?L9EK7xq22zG/GU8SPXjWycglPZYtDZDHnE5V0dKkv3MQrnSFKC0LjeqF62z+?=
 =?us-ascii?Q?TyVZ5lHP3nbNCOHCCQSMazZcCBnmDgDxGU5iP8WZQcMr6Fj38CxkQ4YAVbs9?=
 =?us-ascii?Q?vc31IWtF6eCFrwJU/+YhSFdGFtplYfr0535wvbt7Fqc5fZX/UexMDHJ3nSZY?=
 =?us-ascii?Q?z8cz7FbcUS4vWq29he0OI3KpJ2UD8OrFO5Ki2sBSyXpyV2GbnM+Ppp+UMXI/?=
 =?us-ascii?Q?7k9nqW9IwSwuZSFsa8oYQs27PF1odlxigXvTuh/eH0wtES0msNqanXyhQfyM?=
 =?us-ascii?Q?fl553ebtuu01C/lCrFI8iIer3cpq9rk3uyGkeEST?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7213af8c-0bff-4af3-4c79-08db08dfee11
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 07:50:06.9314
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RBnewb05VsggnHKHd8ZlzbzJsOluGZi/3HD/svAOlwob3sCdL0iJB0YTnmctREtii2M7X/0ptO422mHDMJFHYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8453
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 06:50:27PM +0100, Petr Machata wrote:
> Add documentation for per-port and port-port-vlan option mcast_max_groups.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>

With Nik's comment fixed:

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
