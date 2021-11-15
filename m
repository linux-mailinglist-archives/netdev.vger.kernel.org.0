Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CAB04504B9
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 13:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbhKOM47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 07:56:59 -0500
Received: from mail-dm6nam12on2065.outbound.protection.outlook.com ([40.107.243.65]:33504
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229568AbhKOM46 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 07:56:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KcFKaA1wOo0yop5pA/osJsn0RuLpUg2HZzdgdS+XkQFfZd9p/9dvU8xbT5b3EcQx2DZ7ubREjrfAOlPCGap5POJuDmXR6q/x0XWwapq5HPhUhRwMpX0GMtbl8rxDtBVO8ohX+jvZqY7qL1E4oue3MTzX3MvzknBnynMrm9hr6GG86ljU1MEgXbu6uo7ZGhPr3uOdqqSDYolbSPfEQbLLGo3H2PZ8/1hIhJc2aPXcXXenvJZs6GaxkpvQNLgaK9g2TbYYaBlFtKYE+SYDTvhe0/lmhXDOxne8Dga/coVpK0VrFQB3Kni95NpVHTc6Oo86vAkogaT6RLHMXFGbz6b6xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PH8LIgiAUOK2fhoJ+J8uWls25pIpPBQKqPTDQs2mHyg=;
 b=KBOW0o02RrXJ1KMusCERE36/V2DB23OKJtgNCyddTeHEJdfiS1E6xST/WJmKZ9vcAixzNLjxPN/7H85I2O/8OhalyU1AjV6hPdPrwhvP0v7kxXxlopn4MKK5H100NHxZyYkh9Xl5nIOLZYhHs9q28JUFiqzDdO8OGzh5moOIZKH83pMp+BdSwU9ZHpcwzp0ZkzOab3a5poBNAMQRbm6ocVXGelyUTvKBSaZu9pGf+KBWYY9qCj2RNBKUanjVulVny0hUKiLLf+dxEGMDl/wef0xmtvLlt+WS6+/jepfQ794emezCOZSPKx9BJaNYoLyqRN0NhXg6P9bYYbL3HF7bmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PH8LIgiAUOK2fhoJ+J8uWls25pIpPBQKqPTDQs2mHyg=;
 b=GDmbgdUIUaTCZP0P+/EqCferL2zeZmCnFOd9PZB3H9cEznv5ncgz5ZHwWYNgOUBUdgEltROaN7iK7nKPa3gm8DlYTuZZdzIB5kLH6xQ2nev7xQY03CAQKiOnCyXrN/jHQWEbtrwUehWBTA2ipuLTc5S+BGmearydYV0VsC5HIYw8e96JLcP8iLOndpY5TiD26jqYXrCJJx7vltDozvALr/7isQ8mwPP9m8SDUzh6GbpYs2WUf4zOWQdc/gEtWsUfrdL0B54XNzz8x1zVCuhh7rseiWub5DCCQmy+HmBiVK48BsVZveKgjxXkh0NSiRYh5QaLT+WnkQIK1LyAiidDXQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5286.namprd12.prod.outlook.com (2603:10b6:208:31d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Mon, 15 Nov
 2021 12:54:01 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909%7]) with mapi id 15.20.4690.027; Mon, 15 Nov 2021
 12:54:01 +0000
Date:   Mon, 15 Nov 2021 08:53:59 -0400
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
Message-ID: <20211115125359.GM2105516@nvidia.com>
References: <20211109144358.GA1824154@nvidia.com>
 <20211109070702.17364ec7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211109153335.GH1740502@nvidia.com>
 <20211109082042.31cf29c3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211109182427.GJ1740502@nvidia.com>
 <YY0G90fJpu/OtF8L@nanopsycho>
 <YY0J8IOLQBBhok2M@unreal>
 <YY4aEFkVuqR+vauw@nanopsycho>
 <YZCqVig9GQi/o1iz@unreal>
 <YZJCdSy+wzqlwrE2@nanopsycho>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZJCdSy+wzqlwrE2@nanopsycho>
X-ClientProxiedBy: CH0PR04CA0028.namprd04.prod.outlook.com
 (2603:10b6:610:76::33) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by CH0PR04CA0028.namprd04.prod.outlook.com (2603:10b6:610:76::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.19 via Frontend Transport; Mon, 15 Nov 2021 12:54:01 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mmbUl-009ykI-RP; Mon, 15 Nov 2021 08:53:59 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dddac47e-fd9b-43fc-bc1d-08d9a836ff31
X-MS-TrafficTypeDiagnostic: BL1PR12MB5286:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5286D835D5EF4B0FDE10AE95C2989@BL1PR12MB5286.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:331;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PA/Vg/nARhocKa26RvV4QSykfel9+6rZxMTOydfZ9MCmJgJ2N9dc0GPqjo+lVKIhYtnDFis4b2FJgPMBH9LGmMAJJuLvmueT/avvqgpzfIOhVFQeBZDJ5OUf4MKKygp7j/af9o5zqBv0dp/p/PI357DCYBs5EdIar2ebXmS7iabvCvOkqTaPMZ5eNUoTjKNdSegn82riRc1Sbbm0+UHTtjTY0t+2VnhjAnQrhW8damq5rfQdA+sPFBVe6gQY61bHSUzY5x8BA3Hucis6R6b4Pwt03GBUPpXyeLXeDZ7xOCRdg2thUl0S8iCn65DfUbgfqWvYaBGuVSH8nT23Z0EwG+7I/0MIBxZl3YOFeHEbSJhQFGXTZCZLOx5zFgCZQV3zZ34aCT/XIGO+xsk+mEyuS08eVqjcY1yo+jk8D9SQsTWakcAYcY2ekZxOp9LBM339YQxweQNAzWk2buxpsSZhrXDNqFNcdpTeKbVV4JvVoSReOtqzI/Z6JQLSrvhsAdrb6LTBakjVp8nAzkGraqcfP4g55hOOmgcuzCWuYO6oYmkCYyRvxiCwmFPkIoZpmBWUSqqx70brBV+ZXt4bsC6pTRrCFdHvPUAaaYxFDq3Wj0iaSHnSpMxNVjW03sNc40F9lDXzqd3z20Vts1awATC8EQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(83380400001)(36756003)(66556008)(66476007)(66946007)(4326008)(54906003)(86362001)(38100700002)(8936002)(316002)(26005)(1076003)(2906002)(2616005)(5660300002)(33656002)(9786002)(426003)(9746002)(6916009)(186003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7NdKhx4DMvRSsN2O8bIxHeGZW3eKbeaF0Xv8dKIJ+9HW0YGZFfvJ8n6hEdjH?=
 =?us-ascii?Q?iW7si/meslFxjdzDDHYYdBn+UtpNZQDL1mLR264BkaH35T2Jd2YiY+TVDQ2l?=
 =?us-ascii?Q?rt7G6mIjTkn8D+UX2vRIB3/jUZ0+mfYfUjdkwd36XhZVRj5wDnxezweSvf4q?=
 =?us-ascii?Q?T04n4q5+9ESvtBvE6XzDuNISsS9HgaopkNqwTRS/ui0fEDnl7Gyo594oPDoO?=
 =?us-ascii?Q?MN+3ZzI7PPyZ9Y2q3gaTOHpuk6rjgZor2LdH/ybFEk7t9FSeIG7sPWgnEM1E?=
 =?us-ascii?Q?5OXb3YYrIVhVUrH4xxtJBFQH6CbXMkZLzcEtmXKyat9V3QegwpV0XCyQtcff?=
 =?us-ascii?Q?qtFUe8m2zTjKTxF6kQarotBu18GTU2dnXCRgJ7sC2F2V9efn3NYbhbryvC8N?=
 =?us-ascii?Q?EWjWhRF780+HtQM4Eoa9u1iW5oaKJxmvsZw9/8AyJYXt7Agfo1fu00BH34kt?=
 =?us-ascii?Q?EXKq601ov4C7JubwfJxoBv4roVrtCx1KOyuNL2kBAp45yIUrhnQNb79yRO8s?=
 =?us-ascii?Q?91ACc+q23TZECtk7TRzWI/41i98HBt3bEji1SIlOpQq4k3PxxqY7/Jpynay0?=
 =?us-ascii?Q?oYy0WWUJzWB1n5rqLl7XTFGdanQ41ZdBmWoqYmvvJw8rhp2iVZGZ2OhxKINg?=
 =?us-ascii?Q?9GumtnbO5sjRBaqNOjVVOOK+yc4J7oCI4vA4ipL4s5rcTWGiqhJmd5HAQW0H?=
 =?us-ascii?Q?+rmnfRrs/JTTsqsjyMoxc5bWardRyf+M4/WZCZjxbERvOjVhKfGCDbQ3ZE2M?=
 =?us-ascii?Q?XtPorakv8hkCmO4fxdzXCzaM0C5Y276HQjOACQsl0AjDh4bmzIxp1CQZEXhG?=
 =?us-ascii?Q?U4lWTdZ3Go7/wSx0k0jvcm4ECVgjjDxKo8FZHbguVBWmu5d51o2ALwIWYKIk?=
 =?us-ascii?Q?yp4anCgxHVKl0UVqGZYl1mUEnu15PfSwICwzp17YWKxDoyzWWrHfPBUBaqYI?=
 =?us-ascii?Q?B6z+x8FgixrhrEBpZPYl5N8ECLF05xSSggyzZtiXCOXTbK7TCXEwudNmdMEV?=
 =?us-ascii?Q?5Ld9uhBIBGyqndCZtnnxUxiViPF9HCzkbVpx0fUDjx98Fn4DKexin0a82pPX?=
 =?us-ascii?Q?Gdzjv8xUnfTaVA4pCX9U71Q5qRlphBiO8eKXnZbR6O9HTf8U4k3d92t7Dh4V?=
 =?us-ascii?Q?W4a7iliPn7yZ/P3dHceifmmLBk46xP5kWxIsLQt2V6+I09jG5ujLiDNImb7N?=
 =?us-ascii?Q?dKJyZHgE9kU/lJWVOFFi19UMmBHbK+/W1ZpvmDlwQlYOlCPT0y/XhJRxv/3q?=
 =?us-ascii?Q?omjV8ZVffzUDY050WEIdD8eCi/yHrTBXz83cZNmpzWNjDeTWnUIb+t+d0hNx?=
 =?us-ascii?Q?y/3JeMCrRbNQlnppSyj1A5xJxIFnMx6cTq4h30G8sG7w2hWfmDR2bSDlwnvn?=
 =?us-ascii?Q?YoaebbTV3NSrwN8UWo4IjjzwyKWC2b4SnMbjBvtxChFKN33oLJD4XwUGIuFs?=
 =?us-ascii?Q?XHf0nFPAu5QmV177/MkYmRKD4lFIfalMV/f03bNEob0WUOXjSrBwDGGF+N+j?=
 =?us-ascii?Q?CdCq/eqSzQr7hsiIMd97jvb6bRxadARrqJStn43IeugtGskxeGSvU4iRQk6d?=
 =?us-ascii?Q?OIM5GBmq01B7z+VU5H0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dddac47e-fd9b-43fc-bc1d-08d9a836ff31
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2021 12:54:01.4986
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iPsZ708prHau76K42UyoyLPpuHfOFbv+72sHeqdXXdMMTchaxTpC0jDZAHTl7j2m
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5286
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 15, 2021 at 12:20:21PM +0100, Jiri Pirko wrote:
> Sun, Nov 14, 2021 at 07:19:02AM CET, leon@kernel.org wrote:
> >On Fri, Nov 12, 2021 at 08:38:56AM +0100, Jiri Pirko wrote:
> >> Thu, Nov 11, 2021 at 01:17:52PM CET, leon@kernel.org wrote:
> >> >On Thu, Nov 11, 2021 at 01:05:11PM +0100, Jiri Pirko wrote:
> >> >> Tue, Nov 09, 2021 at 07:24:27PM CET, jgg@nvidia.com wrote:
> >> >> >On Tue, Nov 09, 2021 at 08:20:42AM -0800, Jakub Kicinski wrote:
> >> >> >> On Tue, 9 Nov 2021 11:33:35 -0400 Jason Gunthorpe wrote:
> >> >> >> > > > I once sketched out fixing this by removing the need to hold the
> >> >> >> > > > per_net_rwsem just for list iteration, which in turn avoids holding it
> >> >> >> > > > over the devlink reload paths. It seemed like a reasonable step toward
> >> >> >> > > > finer grained locking.  
> >> >> >> > > 
> >> >> >> > > Seems to me the locking is just a symptom.  
> >> >> >> > 
> >> >> >> > My fear is this reload during net ns destruction is devlink uAPI now
> >> >> >> > and, yes it may be only a symptom, but the root cause may be unfixable
> >> >> >> > uAPI constraints.
> >> >> >> 
> >> >> >> If I'm reading this right it locks up 100% of the time, what is a uAPI
> >> >> >> for? DoS? ;)
> >> >> >> 
> >> >> >> Hence my questions about the actual use cases.
> >> >> >
> >> >> >Removing namespace support from devlink would solve the crasher. I
> >> >> >certainly didn't feel bold enough to suggest such a thing :)
> >> >> >
> >> >> >If no other devlink driver cares about this it is probably the best
> >> >> >idea.
> >> >> 
> >> >> Devlink namespace support is not generic, not related to any driver.
> >> >
> >> >What do you mean?
> >> >
> >> >devlink_pernet_pre_exit() calls to devlink reload, which means that only
> >> >drivers that support reload care about it. The reload is driver thing.
> >> 
> >> However, Jason was talking about "namespace support removal from
> >> devlink"..
> >
> >The code that sparkles deadlocks is in devlink_pernet_pre_exit() and
> >this will be nice to remove. I just don't know if it is possible to do
> >without ripping whole namespace support from devlink.
> 
> As discussed offline, the non-standard mlx5/IB usage of network
> namespaces requires non standard mlx5/IB workaround. Does not make any
> sense to remove the devlink net namespace support removal.

Sorry, I don't agree that registering a net notifier in an aux device
probe function is non-standard or wrong.

This model must be supported sanely somehow in the netdev area and
cannot be worked around in leaf drivers.

Intel ice will have the same problem, as would broadcom if they ever
get their driver modernized.

Jason
