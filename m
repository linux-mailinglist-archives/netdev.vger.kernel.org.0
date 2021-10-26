Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2760B43B050
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 12:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbhJZKm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 06:42:59 -0400
Received: from mail-bn8nam11on2056.outbound.protection.outlook.com ([40.107.236.56]:59329
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230213AbhJZKmu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 06:42:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IuRiEr6g6rn3AjaLKFdajFVj3/4+vHRKEVQ9OsJG10Op3os02lYXaKQAONm7hz+aYD2o+rAGIkOqZ/wXKZhs2Cc4f+P6eL4dFWZzXkkxXJLiOV87neghC5Pfvt2kGb9qeCYe4M3y010wKVvqnbXvgr8f16AYa987ibtSkE2YDhSUBuX+S/bEBOJpPn5a5WDsKHBR6mTTtIiKGmqbyZhoEu5IPbLBCL5I/MgNcgIO2M5S3EgL3V9WcNSa/Y31sQ0CEMVrVNfqnEmyek4zq+jyLw8mNBVL0B9m9IYBh6Nsc0loYhqiVJSqIyAW1az8e4OAXdfMDS0gGGoH72aiuM/0Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xPa31r3Z0YGac3xs+SfQJNJdrSjhAgNSNsW6UKt20P4=;
 b=hPMksZ034v2QB2J/vuCNP6eYlIBOk8zL2DXqrlW+N+8cRra9zZMiPWm0GlkOnkaJxYgG71UoF0tQkZHDYVxc6PyxABcoJYmeyfXbDcNfGF0mC54+X9U4i43aGEjRpYL5Cm4qaET1xLeCM8uNfcv5tm768ybjTHhTzzbKYPyMlPzZ59zv0h+O9+UcUMk+FG4u0pcbbTO7f4eIgAAkfAH/kZEg41iV5NFvlL5dKYjrZAbIB9RdsC4KkjnpPVWn2O/NSg0pQ/ycfcjiar4U5wF2F+EVt5lLviwNfSFxpEfx/nVKsb/JXQ+9E2xnNuQN+QRPtpAEFrOITO1N3ixIa3eL8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xPa31r3Z0YGac3xs+SfQJNJdrSjhAgNSNsW6UKt20P4=;
 b=PAfWQpJDAggo3eTn9cvH9FHBgpZFbbOHUiXOBRkW4ViYojmTYxoyZER6bLWLirsgwrd282EOHTtbkRKe7BSn//l1GXupbkkbk9JA7kHtNSkW4zj3sJ6O36dEV/UNVEbc58+0DqqHOO+uSBysVo/hqPYcKkJyqMPcQro0wa/KTPCVZ87h2pGMPup7wBjGzD4ODkXn0NxyzC4ks8Yehv7OmFxCIje/ezRXySN/js3YHIrKycbKDypcft+fsrx4W4Z6XSbsm5HLqeo3zW8bUStB/gacA9ekehjuuO7HcJ00yJORLhcwfyzEXmw/ezcttU6gUxkTCa0g3qVCCNbUujUuTg==
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5197.namprd12.prod.outlook.com (2603:10b6:5:394::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Tue, 26 Oct
 2021 10:40:25 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea%8]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 10:40:25 +0000
Message-ID: <531e75e8-d5d1-407b-d665-aec2a66bf432@nvidia.com>
Date:   Tue, 26 Oct 2021 13:40:15 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [RFC PATCH net-next 00/15] Synchronous feedback on FDB add/del
 from switchdev to the bridge
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>
References: <20211025222415.983883-1-vladimir.oltean@nxp.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20211025222415.983883-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0096.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:23::11) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.241.50] (213.179.129.39) by ZR0P278CA0096.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:23::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Tue, 26 Oct 2021 10:40:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bef4213f-fd97-4bcb-269f-08d9986d04d3
X-MS-TrafficTypeDiagnostic: DM4PR12MB5197:
X-Microsoft-Antispam-PRVS: <DM4PR12MB5197DCEAE39282006B7D188DDF849@DM4PR12MB5197.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W1h5G9kgMsYwgeRREUqo9JHBVT/1gNIDmsirofFGLQ/nRikZ4UMQdOZeX29Xyzzb3NmSyVOwgbNQsUb/k8m6hJSr+eaSSH9R0PXuUgrczenHSH6R5ey6Xy093vaOn3BJynfmzYFwh/BXm8sgZB0DLc1qn2wL3n2rxMPRwtkPGp4FZEVh6e8T7X5EA0HOgjonJ5B77FGugVXsiVvCY3nf6cV/fMypKaFgIlPc64MkeDYjJPPu5urkCr7iM3gI304fqeiI+hjSVIpv+QcaFPJMhwoP3Ezeli2jPyNpFducT0NiItdhe0xHUifOYFRZLipzNQpudMOSMyu5GQrFkh4SJNXNCs2gy1qRmEKFHpJwxCDK98ZuTEu+G8o4ZNPvZoCdmyo+vUnlDETtxjC86f4G5ZT7IF2OFgEQxOA5mInCd9/3JkkxnYLezZnxNHzBRjaZ8JDLv88QEOpmYRlJKBS3oGEL8jduQ/FasSDczotcTwxGX3ve1ZlVmaiooER5cVySBRHdIrLZwhBr2h6o2KHiEgOQTuARsQj8D3O/bLs6Jz9LNthyTLIxwaCSogZ6BMdK/C8kH1CMAQuH3FXM6m1fH0e2fewPGSvLvdDpcydWZQVFUJgroBHerXPrBb6PC3P5x8zcCjiqCfSbcQcFd0NGlCXTLv/yVzt9kzAtyFP5wdQoFmvM0tdl9ycQgr02JGFO1jXmQuHiqf3WMYse46k6QxTIrN4LuLxGwVUH5C9k3s9gCwyQSHNOrKFJiyb/PLtNOfVCJoKH9gNncKBsX4LjDrtuCIda8Fiz302+AGVmTWdVsBnD7EUNKwMO2SOcCUE+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(107886003)(956004)(66556008)(6636002)(31686004)(83380400001)(508600001)(316002)(5660300002)(6486002)(8676002)(16576012)(6666004)(4326008)(26005)(110136005)(2906002)(66946007)(966005)(38100700002)(186003)(54906003)(8936002)(2616005)(66476007)(36756003)(31696002)(86362001)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eHRKT2RYNVNybTduV21WcUZXcTNoNjd5ZGRsQWJ3d0l6WFhOaXlWbHFrVkdr?=
 =?utf-8?B?aGcwN2o4bkpUY2FvQzRqdW83akhxaklKTVNIbGIwUjN3RjB2VjBjUFVoNGM2?=
 =?utf-8?B?dERERGZjTHdvK3ZGeTBrSjdFdkdNV0JaME9sRXJ2bXJZbUZ5ckFVbVV2TzJ6?=
 =?utf-8?B?R0Z5a0Fkd0hMTnBGTXlPTnFSNWpKK21GTk1zVE9NcFprYzdLK3Q2U0xhZFJm?=
 =?utf-8?B?Zy8yck92TUhrSUZIWXh3TmViWlF2YXZnSkJsMDBlc1pRRzJwVWFOSEJ0dkkz?=
 =?utf-8?B?ZFhtdGQybGVYNGJCcCtPcFBycEJ1R1FmNGFLVVRySktwWFVkaDJQQnplS2Y5?=
 =?utf-8?B?S3JhN2hhNWNvN2tLdUxYZGVIU1pINFJJMDZKa2xtYnFGakpDYy9EVml1TDFX?=
 =?utf-8?B?aEE4QVIyUnV3Y1FhTEcyQU5udTg1eG8xV2RNVDkxQWxjWkZEUm04QStYUnZ5?=
 =?utf-8?B?RzV2c0JyRG9oQUo0QklsenQ4QXpLYXp6Z0o1K1Y2REFGZ3gwbE03bzNVWnRw?=
 =?utf-8?B?cjFHcllCQXBZWjVLZGhHcjFDZExaTDBIemZZR0hWaTZsWld5R3dLUmpCM3pY?=
 =?utf-8?B?V0FHcWYwNWdxSlcyMFhvTndaVVErVWtFbTduQkU5V1VXeXFLaSsrWlBkRWZP?=
 =?utf-8?B?NTdwSW5ac01NYlI5YmU5Rk9EVGxQY0tpWWxTR1Z6bWZNQ1R5S3hYNDRxTTlF?=
 =?utf-8?B?b2lIbkdwVUdQM2Z0dGpwaTNFSkNtV1ZFK3lsN29VSzV6Qnh3TDdMbzk2cTlQ?=
 =?utf-8?B?R0ZaMHpJaU5FMHVLQkdyMEdVenl2SmFUdUFTcjJJbFl6QVUvM0xvUlNjOHVq?=
 =?utf-8?B?YXJXKzY5emd3TnlFTVRXNmx3a0d2dWdYamZRTGFnMHRjMVhhOWM5a3pIdEo5?=
 =?utf-8?B?ZHhYRDBoVmFPKytGd01FdDNWaHh0MTBHVzYydUN5OW9rdUlRU3NKRFZoUm5w?=
 =?utf-8?B?dnZsWW5Kblo5djV5NDlGdjlodkZudzNoQlNqQmJVbDRmSHUzM2NEUzBmWDQv?=
 =?utf-8?B?YmU5eGdyWFpROFB3NGRkRGhnRFdTNy9BV0ExQlR2S2ljVjFTNTd5eW95RzRI?=
 =?utf-8?B?R2NGQ0ErbU00Vm9nYkR0TVFXditSZ01qVjk4ZXdRY0lRT2w5b01ZSnYrNG5r?=
 =?utf-8?B?VFVWUzUvSytYeW9FQ1ZJTjRTa3pBTXFabDljQjFCNkY5a0NSeFNkM1JlMFlu?=
 =?utf-8?B?RnJjWmFOZmtEYzZ5dGJFQ2VJZTNtOXQyUWovaGJ0MGtaOGtmRDRCQ21IeTNU?=
 =?utf-8?B?R1NFY2VOK3VlR3VMTzFkd3REU1VoV01NclUrTTRENzFSU1k4MVZFYmdEQzNO?=
 =?utf-8?B?VVdVZHpwMng3aStjY2pQa09rRVRGemZjbTlNVG43dlNQU0tMTUFid01XZjdp?=
 =?utf-8?B?R015cnNsN3lxbmNDcmNzUnE5eDZHc21seHJmTlZjMGNZY2ZFd1NsL0xXODBT?=
 =?utf-8?B?NVlhaVF2VzZFRlJUT0ZXd09LU242MFplM0FKcDdEN2ZvTUY2NURwWml4Nm83?=
 =?utf-8?B?TTh6ck1RR1VaQ0FCaUJMWHpWeXdONTRTTDIxWGF0ZG1icUswU0ZucXhseXJL?=
 =?utf-8?B?K285QXF2THBXQ2k1OUlJUXA3N3p4aG1rYWhmamw1a3k1VG9MUzR3RFpjcUll?=
 =?utf-8?B?WnNzWVhoaFhCM2NQTGs0cUR1RHQvUlBVZWdDZHYra1JIQms3T3lsdWhNcCt3?=
 =?utf-8?B?ZlB6bkgzcEh6Y3NFTXhTdVN2VjIweFl0YjNPK0w4SGliY2hYRVo1NTVMTFZo?=
 =?utf-8?B?YmdRMW1oSVMxdThnYjU1TWV5dFhkdk5sTHM2bmR1YlU3bXk2TzFPcnhWSEIw?=
 =?utf-8?B?ckw2UFFvQ0dMMGtaN3gyR1lwVGpSajI0dkIxNDhKc25NeE5CSUhaS0N4UGwy?=
 =?utf-8?B?NDl5UlFTOGlMSk9raEFadnViVEczZzAvREdUaTBMa0llZ0JvRksrRkdEbGVE?=
 =?utf-8?B?Zkt0cEhFazJtRFdDcEVvQ0c0M29TVmJnMFBydlFqN3Z2REExZVZBbmdKbHlM?=
 =?utf-8?B?Z2UxMWhDVHpxWXFtZlRCK0p2S0MwcUVGdXJ2L0xueFFldW5WK2ZlZTNHcVZG?=
 =?utf-8?B?Z3NSMUc2S0dVR1J0MEdxVXhuMlhxWXdCUXcwMTBVVVpXWHY1cVl6SVM3ZTkv?=
 =?utf-8?B?bVA0UWdOMzdhNVhGZHQ1eGxYTjduSWUvdVhUeDFkdXNkZk9DNHJERVA5TXI0?=
 =?utf-8?Q?StRAg0AIZvQIGqcD1KzKzSc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bef4213f-fd97-4bcb-269f-08d9986d04d3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 10:40:25.1680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mRkGgc2DwNLy8UEc5f/toQ+FAUh0D2CsjbyMNlVbcBvgPrZBf25SOsc0pDOluw4m/TBUSIfmLETt3LT2yEBWyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5197
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/10/2021 01:24, Vladimir Oltean wrote:
> Hello, this is me bombarding the list with switchdev FDB changes again.
> 
> This series attempts to address one design limitation in the interaction
> between the bridge and switchdev: error codes returned from the
> SWITCHDEV_FDB_ADD_TO_DEVICE and SWITCHDEV_FDB_DEL_TO_DEVICE handlers are
> completely ignored.
> 
> There are multiple aspects to that. First of all, drivers have a portion
> that handles those switchdev events in atomic context, and a portion
> that handles them in a private deferred work context. Errors reported
> from both calling contexts are ignored by the bridge, and it is
> desirable to actually propagate both to user space.
> 
> Secondly, it is in fact okay that some switchdev errors are ignored.
> The call graph for fdb_notify() is not simple, it looks something like
> this (not complete):
> 
> IFLA_BRPORT_FLUSH                                                              RTM_NEWNEIGH
>    |                                                                               |
>    | {br,nbp}_vlan_delete                 br_fdb_change_mac_address                v
>    |   |  |                                                  |     fast      __br_fdb_add
>    |   |  |  del_nbp, br_dev_delete       br_fdb_changeaddr  |     path         /  |  \
>    |   |  |      |                                        |  |    learning     /   |   \
>    \   |   -------------------- br_fdb_find_delete_local  |  |       |        /    |    \     switchdev event
>     \  |         |                                     |  |  |       |       /     |     \     listener
>      -------------------------- br_fdb_delete_by_port  |  |  |       |      /      |      \       |
>                                                  |  |  |  |  |       |     /       |       \      |
>                                                  |  |  |  |  |       |    /        |        \     |
>                                                  |  |  |  |  |    br_fdb_update    |        br_fdb_external_learn_add
>            (RTM_DELNEIGH)  br_fdb_delete         |  |  |  |  |       |             |              |
>                                      |           |  |  |  |  |       |             |              |    gc_work        netdevice
>                                      |           |  |  |  |  |       |      fdb_add_entry         |     timer          event
>                                      |           | fdb_delete_local  |             |              |        |          listener
>                          __br_fdb_delete         |  |                |             |              /  br_fdb_cleanup      |
>                                      |           |  |                |             |             /         |             |     br_stp_change_bridge_id
>                                      |           |  |                \             |            /          | br_fdb_changeaddr      |
>                                      |           |  |                 \            |           /           |     |                  |
>                      fdb_delete_by_addr_and_port |  | fdb_insert       \           |          /       ----/      | br_fdb_change_mac_address
>                                               |  |  |  |                \          |         /       /           |  |
>                    br_fdb_external_learn_del  |  |  |  | br_fdb_cleanup  \         |        /       /            |  | br_fdb_insert
>                                           |   |  |  |  |  |               \        |       /   ----/             |  | |
>                                           |   |  |  |  |  |                \       |      /   /                 fdb_insert
>                           br_fdb_flush    |   |  |  |  |  |                 \      |     /   /            --------/
>                                  \----    |   |  |  |  |  |                  \     |    /   /      ------/
>                                       \----------- fdb_delete --------------- fdb_notify ---------/
> 
> There's not a lot that the fast path learning can do about switchdev
> when that returns an error.
> 
> So this patch set mainly wants to deal with the 2 code paths that are
> triggered by these regular commands:
> 
> bridge fdb add dev swp0 00:01:02:03:04:05 master static # __br_fdb_add
> bridge fdb del dev swp0 00:01:02:03:04:05 master static # __br_fdb_delete
> 
> In some other, semi-related discussions, Ido Schimmel pointed out that
> it would be nice if user space got some feedback from the actual driver,
> and made some proposals about how that could be done.
> https://patchwork.kernel.org/project/netdevbpf/cover/20210819160723.2186424-1-vladimir.oltean@nxp.com/
> One of the proposals was to call fdb_notify() from sleepable context,
> but Nikolay disliked the idea of introducing deferred work in the bridge
> driver (seems like nobody wants to deal with it).
> 
> And since all proposals of dealing with the deferred work inside
> switchdev were also shot down for valid reasons, we are basically left
> as a baseline with the code that we have today, with the deferred work
> being private to the driver, and somehow we must propagate an err and an
> extack from there.
> 
> So the approach taken here is to reorganize the code a bit and add some
> hooks in:
> (a) some callers of the fdb_notify() function to initialize a completion
>     structure
> (b) some drivers that catch SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE and mark
>     that completion structure as done
> (c) some bridge logic that I believe is fairly safe (I'm open to being
>     proven wrong) that temporarily drops the &br->hash_lock in order to
>     sleep until the completion is done.
> 
> There are some further optimizations that can be made. For example, we
> can avoid dropping the hash_lock if there is no switchdev response pending.
> And we can move some of that completion logic in br_switchdev.c such
> that it is compiled out on a CONFIG_NET_SWITCHDEV=n build. I haven't
> done those here, since they aren't exactly trivial. Mainly searching for
> high-level feedback first and foremost.
> 
> The structure of the patch series is:
> - patches 1-6 are me toying around with some code organization while I
>   was trying to understand the various call paths better. I like not
>   having forward declarations, but if they exist for a reason, I can
>   drop these patches.
> - patches 7-10 and 12 are some preparation work that can also be ignored.
> - patches 11 and 13 are where the meat of the series is.
> - patches 14 and 15 are DSA boilerplate so I could test what I'm doing.
> 

Hi,
Interesting way to work around the asynchronous notifiers. :) I went over
the patch-set and given that we'll have to support and maintain this fragile
solution (e.g. playing with locking, possible races with fdb changes etc) I'm
inclined to go with Ido's previous proposition to convert the hash_lock into a mutex
with delayed learning from the fast-path to get a sleepable context where we can
use synchronous switchdev calls and get feedback immediately. That would be the
cleanest and most straight-forward solution, it'd be less error-prone and easier
to maintain long term. I plan to convert the bridge hash_lock to a mutex and then
you can do the synchronous switchdev change if you don't mind and agree of course.

By the way patches 1-6 can stand on their own, feel free to send them separately. 

Thanks,
 Nik

