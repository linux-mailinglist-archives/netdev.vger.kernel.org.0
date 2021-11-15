Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 786F84507E6
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 16:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236472AbhKOPMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 10:12:35 -0500
Received: from mail-mw2nam12on2061.outbound.protection.outlook.com ([40.107.244.61]:15809
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236507AbhKOPMb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 10:12:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X3Lo/XCeqAmgPvEzwrEYaU1EWHx4eEjFuga+5M/dQYu7HgdhqhVNm/cKPKch6XS+imUKaQVYBMfVhxMqPHHky4Ljp5e8NAuEAhL3tMBGjGy0UDH0y4gNdDaeE6U9o/vFz6rN/iRtFtfFUcDbxe+nGnfnWd8C/AJ8escnC6yT6ozzK3Jyupbe/iJz7AVBM+WhMZHwsKxPtJP5T4XmwetUAUDhJwkb2N5/Czt/LGLOQ+sHKF9nOa5phmtC5oJwD5Vd0dOO1o6plbGZuEo4wWsaxDwCFBL79uHE4pk9P1Rmm9xCCJ+QZUp4Kf1PbQku9MDAFoXPwugp3tU1RHqedzefBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=elqeNjFXcpeu8+TMzux20j5tpH35irf1FxKhvZW1E4U=;
 b=KjeDxu1BmEx4pVeVfpQjRnuj9S4cWfQF+CgsSQgfxmMrQmryycmGqIj3c7B/KOBzO2dEs6dyd9+lhasGav0EDANHEGP+L6nGmJ93uJZjXHchVYWou1+nSwZ/IReGDIdjm91rSFyUBWKXupCv6y7xyuFpYrV8Ng/u5FxF3rh+0H5Yqebqs/ctY+S3/szWgvzkX/wR/4TvS7pGrSt3ij9X5SYnXhKtQRnfDiF/JHCMN3sKJBj+HOsI5KV73h9QCrzUWHbjDj/fSdIZECk/dE7L9RCIIq17sJqj2TPhehKeWX6qpclaR6M4voTn2uH9ElgaizSRTUFt3dsknzaIzjCsOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=elqeNjFXcpeu8+TMzux20j5tpH35irf1FxKhvZW1E4U=;
 b=MrVfT3J+7B2RHC5S3TR4UF6jiXo8VrwPAOIvSALCdUZKZb5WQJITw/6z7ZJ/5IQW+PRj8dB6iT7iCpklV1Y0JFNryMDjmpbOeAnIR3oIsRXO39lkXdOBNl34u1v2rNKiUQByHxpoJTMwnuk3FhJoVP8l/rnJVY7Lo4tlGawVZltYVow/MI4hliBB+4iVCyVImKl+MmksnhAZb2N9x11pD0FuHmZewH/4E3Ob1JTQ9V0T0y0Bouo/rrDxizuvTZvhhgPlpd0KCRgj4pzkPBtFrQJu3tkxuuSSp4opwZJYoH+XqhPe+HRbmX2NK/nz5NmhwYpzHeYmzszwGwLK8ykjWw==
Authentication-Results: resnulli.us; dkim=none (message not signed)
 header.d=none;resnulli.us; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5191.namprd12.prod.outlook.com (2603:10b6:208:318::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.16; Mon, 15 Nov
 2021 15:09:34 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909%7]) with mapi id 15.20.4690.027; Mon, 15 Nov 2021
 15:09:34 +0000
Date:   Mon, 15 Nov 2021 11:09:31 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@idosch.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        edwin.peer@broadcom.com
Subject: Re: [PATCH net-next] devlink: Require devlink lock during device
 reload
Message-ID: <20211115150931.GA2386342@nvidia.com>
References: <20211109153335.GH1740502@nvidia.com>
 <20211109082042.31cf29c3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211109182427.GJ1740502@nvidia.com>
 <YY0G90fJpu/OtF8L@nanopsycho>
 <YY0J8IOLQBBhok2M@unreal>
 <YY4aEFkVuqR+vauw@nanopsycho>
 <YZCqVig9GQi/o1iz@unreal>
 <YZJCdSy+wzqlwrE2@nanopsycho>
 <20211115125359.GM2105516@nvidia.com>
 <YZJx8raQt+FkKaeY@nanopsycho>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZJx8raQt+FkKaeY@nanopsycho>
X-ClientProxiedBy: YT3PR01CA0109.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:85::10) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by YT3PR01CA0109.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:85::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Mon, 15 Nov 2021 15:09:33 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mmdbv-00A0s7-T1; Mon, 15 Nov 2021 11:09:31 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 39ab99da-2465-48ac-acfe-08d9a849ee8c
X-MS-TrafficTypeDiagnostic: BL1PR12MB5191:
X-Microsoft-Antispam-PRVS: <BL1PR12MB51910DCB52C9C61D3BD7057AC2989@BL1PR12MB5191.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 429+yN8Xl01xszfUeWcQ+0LmOFIydpt0xersc3gth+BZU+ot1LdFOBnFlks9LwGaIN/lDM6oVg3vHqmDphKpg7mp2TS23VLjyr319eYEGtE3fDTwVRDIP2tJYoJceHuGSDMYPFpKPX7HlH7qXLWwWXP3NGHJtHhLSvg7kdkWmrp55niFfL56CzCjEkjN5EhxXaYEkPwR6RLFKfLmsi4Qq2L4e0n5zIsIif5aIl/wtbliOttl7fcMm/73j9pcC0JOXbNW/Quii9/HBR4ROGqC0T3fr50870kY3Gs26v4XYLRUGCJbdb0JFUJR8QTSbkeTt8eyKvrpoPx+ZsAvcEhuhicQftoke0zYzzg7q2OiGUNwkVSpUR89tNP5hjGeEdLQxVZqYOeztUQD0DmdeyFEcARbVrld4B0QkHpNeAoY7+xflEIlESBozy7irOieQ2VHTonTEsDW1dshBfM2/4e3FCjg8ltFFzfjhNmBsLeBvqBobDewTUS4cyyFBR4N2mfx31FTWrYWHFJc1Rqq8xPFYVrhpK/V89QtX40S80rDe5xszWqMoFcMa2ktoARSb1KTiWhc5mWBpVMk0aDvynpzeG05eV2kKfJCCmdT207gPyEMgn17I/P+rmrpIJuE1NxMLjLw7sEaiBxE46nQpvNOaw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(9786002)(9746002)(426003)(8676002)(66476007)(2616005)(6916009)(316002)(86362001)(54906003)(1076003)(66556008)(66946007)(508600001)(38100700002)(83380400001)(186003)(4326008)(26005)(2906002)(8936002)(5660300002)(36756003)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WV3MCbCyJLBZTyLTOiDfRyISr3gy+gMML7uN1S9qus1RNWTXRbuNSaGssULn?=
 =?us-ascii?Q?DD4eQzVYZVRx1Yg+t5EJRNtTpTzYMgC7i/YEsBoJhCrkDuzYVpPMIA3jQyMh?=
 =?us-ascii?Q?OZEYwiCOY+e5an13g4u2jWusxTtXu/byZn9e6r6xTRE8GpHyoWgQaffPdx2K?=
 =?us-ascii?Q?ipZkqisM+LCNQLcL73LSPWff8UY/hLYRDUU9QCyEwoG7B22lQR7OqMAuHxp5?=
 =?us-ascii?Q?rvQVSYpz5XG7VlqFr/xIuIoieF8yyxC/xLBkCh1+8459js5V+6+sGLoxlyBe?=
 =?us-ascii?Q?cbRpdKTwUEQIqYoyQYuj1aGv5/RgSjE1SEnVchb8bX+I5uPjhFStavdpBdM0?=
 =?us-ascii?Q?klYMyjCQ5rZiTfmHgF1/jv0mau0+gBtGsrtHYcGgzH7c4glwHZTXuDVoZg+h?=
 =?us-ascii?Q?5vZG8i9AQh2s4OYS2hbDCEnlxCmonlOSip3q9p7T1JbZR3QQ3FOb6mhvEO2w?=
 =?us-ascii?Q?swe4AOU1JI2d+12DPgmtqSP6xijv976MkpiwmwyvI+dpIuc+Ox/G7UJCvCpu?=
 =?us-ascii?Q?qgimEAGy4yqw9rLKDKojf0AGIvwX18n38+4ejGZf34m9VmxswewUphpDv7py?=
 =?us-ascii?Q?SS8cGXZRwdrf/v+JA1Ez8pPzLTCFK8AvQUaqFflIX2oy6P0/fFcfQb5/h8vU?=
 =?us-ascii?Q?vt6vTud+n86jO01BSEBuEgIZj4yCAVlAO7ZRwUdcbniz8vg0tN+RDFXbmn/Q?=
 =?us-ascii?Q?pTq8ZjDnN5uT0/QgRlkqXcjVzCh9Z0YnrFD26GyJjUShuNa+5IvGSvX04y+Y?=
 =?us-ascii?Q?6glga/xpCFp6WwLvLbMdiksMywAPr85Pu+HM1Nx4DX5JcBLB8BWT53Renaq9?=
 =?us-ascii?Q?V3pVroJ2qq0wgc9TkPBC/A7zshW7MFbcuFEAxcT7I8SVnR+aXXlaBBqXpmFN?=
 =?us-ascii?Q?/knphwZlZbos4i1JeQh9n4K6SpbeVKWBjAsFDu9YAJegVzaCHmq3IGUekgvw?=
 =?us-ascii?Q?QBZVhswfaFuuKhB62lZPVQKIGaLWLo7SRkVm9p2wJWRWbPRqzR7M0z2tfY0+?=
 =?us-ascii?Q?iXhrj8spDU9/fBKFiUoTrJB7dNcym7pwJ1hRAG/IcGXnufOaeqlkfEFhZgSY?=
 =?us-ascii?Q?T19NKmB8uhtOLLeTvv+ti27j8bk8P8j5ViWlq+e3/sTp8HEgDqKc4cizpW6q?=
 =?us-ascii?Q?s/X0bMQywPv4AdyyeUbf8voH13laeFJEUFXvnt9s4K5CQLQhe4/ik7Tt50Cv?=
 =?us-ascii?Q?3YF/+5wtKZ14eamefFMvro1gb+TD5bC4S+HvYVFps1KaDdePnj61qULcJ9ah?=
 =?us-ascii?Q?91VjOYYT9FZaKjh8GCcfNIYmyfTtvENKUKlxqnzQcBJjBslDUycpmleh5GW+?=
 =?us-ascii?Q?m5hMkiCeOhL27weDzvagkD7DLif/6moy1W9TXRKoSAiTn1B54Rs1VWDJ+/IQ?=
 =?us-ascii?Q?sE2MgqA43lyppMBVkEhOLjgxzU3TwEtYASCIr5yJZGM0Sj/MOVRjjBjf2o0A?=
 =?us-ascii?Q?NqCJSCRoEPG/HqhWy3OBFxqEdYB80mHUeCrtA7di8xs/EWGog6mtGhQMfxiY?=
 =?us-ascii?Q?H9Wrtm+zsvEzLX2QiOnoHYhDeM4g6/KhYJKWmrA5CYLxClMxkeIlOnE0zgzj?=
 =?us-ascii?Q?l88Vw5SvmxtiPVbrO5Q=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39ab99da-2465-48ac-acfe-08d9a849ee8c
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2021 15:09:33.9474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Lo4dDW5djThlW3GyZEuxDQaDWcWPbvtMvetz5+DcSJ9wka/mY94CUY4soQuZaMj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5191
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 15, 2021 at 03:42:58PM +0100, Jiri Pirko wrote:

> >Sorry, I don't agree that registering a net notifier in an aux device
> >probe function is non-standard or wrong.
> 
> Listening to events which happen in different namespaces and react to
> them is the non-standard behaviour which I refered to. If you would not
> need to do it, you could just use netns notofier which would solve your
> issue. You know it.

Huh?

It calls the bog standard

 register_netdevice_notifier() 

Like hundreds of other drivers do from their probe functions

Which does:

int register_netdevice_notifier(struct notifier_block *nb)
{
	struct net *net;
	int err;

	/* Close race with setup_net() and cleanup_net() */
	down_write(&pernet_ops_rwsem);

And deadlocks because devlink hols the pernet_ops_rwsem when it
triggers reload in some paths.

There is nothing wrong with a driver doing this standard pattern.

There is only one place in the entire kernel calling the per-ns
register_netdevice_notifier_dev_net() and it is burred inside another
part of mlx5 for some reason..

I believe Parav already looked at using that in rdma and it didn't
work for some reason I've forgotten. 

It is not that we care about events in different namespaces, it is
that rdma, like everything else, doesn't care about namespaces and
wants events from the netdev no matter where it is located.

Jason
