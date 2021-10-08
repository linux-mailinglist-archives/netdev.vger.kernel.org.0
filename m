Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECA142710E
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 20:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239447AbhJHS7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 14:59:36 -0400
Received: from mail-bn8nam11on2051.outbound.protection.outlook.com ([40.107.236.51]:20960
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231316AbhJHS7f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 14:59:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iOO6LI5BhKZavrTu3PhseRZ9CUQOc1ayORjVSKsTQDHBvkp1rlbl11jm+CRdO4vBamJqT/Pr039yFQIppcpGNmm+GrioohaF0tlTizwXuGDict5AhT+wuAJfKRRFRTwJmTgZA8l4j81ARYaQKzTg7psA98wJ+sZvaj+qO764vru2IME9SqQa8dUvKoPAP5YclEtV7rKtCv5dTNLN6jZcLY6MXi0hh/I0b4HRRXEaBHGphLiHSEQ7yFwgmTW3qY/tDWjMi8YU+3cNCm3FDERfWAw7pkKMUaXQUo5rIvKfSiu+iXOigID6zfR0Y2JBwBko8Lj0uL7viduMHgniZE6FEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xbvQvwbS5uT5TuQWOdowjl71nYw2FyNAzhl29jjcIbI=;
 b=jyZ0tR+DiAJubBVqvzO+H3JHtLb8Xb6S4VDRaAM4vJxePR4WOEWsgiKZTpGL8JnwNRODeatw7mY5OqGnoslar0oeEq7Cyx2NtNELqXEFXXVGWROlxV8aHOkyo7I8sUe2CtFZey2mBJMZMmTj/6Pey+3sNY5Mzdt7Ev8qLUYrCCf/AMq3POWj+NUBC1OE6GYPulrmw2xN/pQBtMpTFByHEWpYBj9T/+lPl8kvaimDXTXkPvB6pfiPTIQzdcQFoE8XPbHfOsXQ9sjlmEwI8wv8otPBn0XBc1Z9y2y9Vyo1Jz+yIk58347/0BJH8ob57sPF4GTMhnnhXNCY6FTDECmUXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xbvQvwbS5uT5TuQWOdowjl71nYw2FyNAzhl29jjcIbI=;
 b=XDQzqR+7gWf8L7G2el2Oh0T7A3zmaEkX4sW/pZ2UeOJ3Ph0fd5x30JOt7aRSks3L+6tUFNI2ogXQXYJj3HLsYBsskCSHv0EDgpkRAIX/r5PLm+W5NuhSGrS+J0QQo8xIXny0hjDBzrSkzC87ILMbPDoXIJZPFbUlidudo8DbQ9Ht6Zu3frpodgdPpzmtPQf+7A32odasFQBvnA4zhp/SFGO+QPhEWyaJTN3amdhcpEb2Q7BON4Zo3g/riYRzInAqbgGrvbcYltdiKGtTFyfRGSbpzdv2ehiLWjxbl5ZICYbajicpMgsMlwxs0wONQafEkBeT4xbJoQiynhnfzOxIKA==
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB5520.namprd12.prod.outlook.com (2603:10b6:5:208::9) by
 DM4PR12MB5038.namprd12.prod.outlook.com (2603:10b6:5:389::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.20; Fri, 8 Oct 2021 18:57:38 +0000
Received: from DM6PR12MB5520.namprd12.prod.outlook.com
 ([fe80::3817:44ce:52ad:3c0b]) by DM6PR12MB5520.namprd12.prod.outlook.com
 ([fe80::3817:44ce:52ad:3c0b%6]) with mapi id 15.20.4587.022; Fri, 8 Oct 2021
 18:57:38 +0000
Date:   Fri, 8 Oct 2021 15:57:36 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Mark Zhang <markzhang@nvidia.com>, leonro@nvidia.com
Cc:     dledford@redhat.com, saeedm@nvidia.com, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, aharonl@nvidia.com, netao@nvidia.com,
        dennis.dalessandro@cornelisnetworks.com, galpress@amazon.com,
        kuba@kernel.org, maorg@nvidia.com,
        mike.marciniszyn@cornelisnetworks.com, mustafa.ismail@intel.com,
        bharat@chelsio.com, selvin.xavier@broadcom.com,
        shiraz.saleem@intel.com, yishaih@nvidia.com, zyjzyj2000@gmail.com
Subject: Re: [PATCH rdma-next v4 00/13] Optional counter statistics support
Message-ID: <20211008185736.GP2744544@nvidia.com>
References: <20211008122439.166063-1-markzhang@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211008122439.166063-1-markzhang@nvidia.com>
X-ClientProxiedBy: MN2PR01CA0047.prod.exchangelabs.com (2603:10b6:208:23f::16)
 To DM6PR12MB5520.namprd12.prod.outlook.com (2603:10b6:5:208::9)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR01CA0047.prod.exchangelabs.com (2603:10b6:208:23f::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.16 via Frontend Transport; Fri, 8 Oct 2021 18:57:37 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mYv3o-00CkY7-7J; Fri, 08 Oct 2021 15:57:36 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 14d89de7-20dd-4737-80ca-08d98a8d7f02
X-MS-TrafficTypeDiagnostic: DM4PR12MB5038:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB50388D08DC04996AC300CA07C2B29@DM4PR12MB5038.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fUsgRWrGyfXPBslZuu9BXBqy++p58KLIt67y7cuyanD5rb+geqAmuP8xtJ4o/adVyJrQ/gCEpEeyBGaGd8mz/doR0kpis9zHzCQyaB+f3HNb2pgIJ7H2f4j0CtzeR8cFkr7OPtli0RrfuH0I//qEySJuwpc0Bvm7co5axWBo9HcwrHZ4BjL3VBA+Cw73PuFwVZoGQU42dkDtfpPk23owPmgVOpR+HsAYHK0VLOeLMDRsAfM7p5ovQwL1eV5XWIhScsMVmTUjNCzqY0VheiCNuuQEoDuLVLUN18KlX5T8Rgc5MMZQwKgtOgfxiAACiK2OtPC1eC2c98KssytuymZnpkTX+HXtFK1FjPHKRSkW1uE8muiCO9FIbwF8s+fbGoepiQKCzcMtkCQRoGMzsHhbii2KLREAmlvG79RqPGjKi+k4o6+ec1VmE0NV8mYxPDs34PIo9X84+s+6s6xSQo6XxA+a8pePy0Ivct/hFGTf6wuxrySBJl6GZhxtkhIawAJNzwxdM7kvRJU53Cyd0VTbPuQ2KOs2vYrQPzCXw4rIUOyXVaSM2T0pj6UFK7e6ta3wC9mwNjO8XnxniBDlB+QirHuK1Qn7GgG7FuNmeiQNmucl4uyQL0MCvzZmQrWbM+2e0fF4fdUU7Za2Fbni6dk1BQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5520.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(9786002)(8936002)(4744005)(9746002)(26005)(2616005)(66556008)(66476007)(66946007)(508600001)(1076003)(186003)(6636002)(4326008)(5660300002)(316002)(7416002)(33656002)(83380400001)(426003)(86362001)(2906002)(36756003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?00TyItsp2iq/u9NLMEO0RHm4uybU1qmJnbNk9LmjY1SeH+6zKuFmi2RpkMap?=
 =?us-ascii?Q?4m2rKfgS20XpuNn0Beeh7MQb7Ib2IUwo4mfWPHJG/uAhs4hemVO0oNQtaW5L?=
 =?us-ascii?Q?n8d9Gc7n1bXBvzjnz4DVgdUFPD5L141Kdh0YEZl4NiROdaEQ4ktn0zpokzvC?=
 =?us-ascii?Q?goCMbRO854M0ycefX7FR7pNv83e3064s5YLkSe3IO5QjpXBSgJtgGuHk7kmV?=
 =?us-ascii?Q?YzbaZWlf1nCxs2JjnfQq442VKAVKh+ftlL3l6DATfNsZ5wzdo5tM2FugsBZK?=
 =?us-ascii?Q?9zgOxXBRr0Ds3GbGoe03OIrOoVyiQWkpchbMzo0aZ2tx+FAHcmtgEmm9L5rm?=
 =?us-ascii?Q?LYbF69QXkSdEWDmtjXeSf+tZSBRRQByg7f9KDAE/7YNtH7jstnVO5wCwx+8f?=
 =?us-ascii?Q?31M/MYhTEmr9BaEQB0XxR5eBpqrsRbSt/EtRc1gVc2WNlzkZcreUJx/ycm06?=
 =?us-ascii?Q?IWNjfCD1HOlPB2D3xV17Lk2YshLi4gXLvPRq/4jxrJK9TeQg1YqhxVTsIKVi?=
 =?us-ascii?Q?pEtymJOZxJJbJkdl1vM936oWiZ3c23CV/8NDh4eglI3nWgBKR4/V4Nk8E2Z9?=
 =?us-ascii?Q?gMHb6D9ChB2gfZjEzjDUeQAaEgwVUcIB7CX1bGbU++YYBpEggcOyDSG+qGTb?=
 =?us-ascii?Q?mXGJyw/l22B5LrkuB1xNGUmehfzmzpG9XyM05wiKmBWa3++lCaQ7ZLaDaeEx?=
 =?us-ascii?Q?hLcRhep/6fr5QxwX43rXN8abOuhLo7mrLRAKOPaVmgo7ILhbwouv9pqYRkey?=
 =?us-ascii?Q?BtXKTpORSQqW/GveyVJLYPrVg8j7fDRn3kbh/NOpAUUGNepa/uKyLVEqj+aV?=
 =?us-ascii?Q?dupTzAb6+zJ1GP22Fm+A9tPsP+Wf/vCZgvUTg7Sj8J3KD3Y6VBOT7g3PIBPp?=
 =?us-ascii?Q?lU2jONaRmvciYcuOMyNFWAtKBwHiZcsK7xv1a74mYsDTlJERyCYAq1vZZUnJ?=
 =?us-ascii?Q?gUCOno4La3XwujimvINZWIzyHeV4wlUbalumyW0ES4zLwW3nEdWsMDwvicYy?=
 =?us-ascii?Q?kWp/l3+yqGg1DXV6Y1+OnZpuij9dkFPjP5zoE80ELfA6Xzm1qj90m9znQiYA?=
 =?us-ascii?Q?6zC7W4GkCJPey29KRyztu8XHyvENeVepTJ6Tyx33Yn38EdhYq+wZkhmKpj/0?=
 =?us-ascii?Q?U4BaZ4OqqRLZ8pd3zvuLkHk+WzgDLh78+UYV3+G2OTKreiv+x8LV8ULAxAL1?=
 =?us-ascii?Q?BJNCs1frQOy/crIOEkxNHwiaIc2qXCbJn26NvHfuA/ztaGJXIPJ0/r+XvPHP?=
 =?us-ascii?Q?lPoAVk4Mar20jELgHkulSiefWyAIuDW19U4hEQisL6cP0mHVl+5Hd6W8hQUt?=
 =?us-ascii?Q?zE45opZg9soLVWlDNtnUMZgo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14d89de7-20dd-4737-80ca-08d98a8d7f02
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB5520.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2021 18:57:37.9560
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2RM7f3RMYNarXLFb6OxVvqCXaZU/A4PIJrs//JZ/Kghk6TCmzgtCDWaL18M+Lu0Q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5038
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 08, 2021 at 03:24:26PM +0300, Mark Zhang wrote:
> 
> Aharon Landau (12):
>   net/mlx5: Add ifc bits to support optional counters
>   net/mlx5: Add priorities for counters in RDMA namespaces
>   RDMA/counter: Add a descriptor in struct rdma_hw_stats
>   RDMA/counter: Add an is_disabled field in struct rdma_hw_stats
>   RDMA/counter: Add optional counter support
>   RDMA/nldev: Add support to get status of all counters
>   RDMA/nldev: Split nldev_stat_set_mode_doit out of nldev_stat_set_doit
>   RDMA/nldev: Allow optional-counter status configuration through RDMA
>     netlink
>   RDMA/mlx5: Support optional counters in hw_stats initialization
>   RDMA/mlx5: Add steering support in optional flow counters
>   RDMA/mlx5: Add modify_op_stat() support
>   RDMA/mlx5: Add optional counter support in get_hw_stats callback
> 
> Mark Zhang (1):
>   RDMA/core: Add a helper API rdma_free_hw_stats_struct

This seems fine now, please update the shared branch

Jason
