Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3372D75B5
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 13:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404581AbgLKMfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 07:35:50 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:1423 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387487AbgLKMf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 07:35:29 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fd367690000>; Fri, 11 Dec 2020 04:34:49 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 11 Dec
 2020 12:34:45 +0000
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 11 Dec 2020 12:34:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oVG+2A29GTy2I/X7D0G82G39HgArE99YJGYEl40znXOJ22SXgf3c6t54IAWGtxaJDvhlBTgFvfrV0htpQT6+xYEesvZyriQ20apqPUswUjG0Q3YKoepQV6tHLbwHCWO5gtD1xrkVYYIrHBjNgcgsVyO1OGXnWVUP62cff6pmaYFB5SJdaiaXNyITxi/GjuUnH51IArFbNbkCUcJiwbllOi7EMMCR9ZwHS1YB/t1rSp23gCErssYh/xQ+tJwb2HkCKKpZLr+wXpSL4UJS/iTMWxFBFk7dJxYxz9OOZeOC5rs5026SG88PWNd7bPIVrS2GApC4HQ0vMZrj1q7Mi0JEqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a4dDkkvVeV8U82GM+m61Hub3z40BxGAHtYxTCYbI0/c=;
 b=f9CFAObqnh946u2XpHd7jRGSmo/gIVaRDrdtsC/WYgQPvsB24KmAWekX/bu0huqbThJkIB/qwIhNPl7u6ak8+cnmzb2bcypU3clXqpig4hv1FdIXeTs3jbjJuFleGk29w4mEpgeZVlsU2cJPmweWWenW0lBIK+KQQoU88bMgiuDHgoAKOwWRrNjYqGY1SV9o4z4WdiCtKQa7O8YctqtfWy0i4w46gQZTSwVMM6h9wFQbO3YVj2GrEzlALaPYKKK4FowRFsV1BTQ+t12u/J8wCoO4Ock5eLi7AICrjQfz16COq0siOUOcJCO2FwxsPLXCn3bs9+nKNX0MBYM27d2jqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1356.namprd12.prod.outlook.com (2603:10b6:3:74::18) by
 DM6PR12MB4926.namprd12.prod.outlook.com (2603:10b6:5:1bb::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3632.17; Fri, 11 Dec 2020 12:34:42 +0000
Received: from DM5PR12MB1356.namprd12.prod.outlook.com
 ([fe80::3cc2:a2d6:2919:6a5a]) by DM5PR12MB1356.namprd12.prod.outlook.com
 ([fe80::3cc2:a2d6:2919:6a5a%6]) with mapi id 15.20.3654.015; Fri, 11 Dec 2020
 12:34:42 +0000
Subject: Re: [PATCH v2] net: bridge: Fix a warning when del bridge sysfs
To:     Wang Hai <wanghai38@huawei.com>, <kuba@kernel.org>,
        <davem@davemloft.net>, <roopa@nvidia.com>
CC:     <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20201211122921.40386-1-wanghai38@huawei.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <ca27bd77-a679-b410-386e-f7cbd4fe1960@nvidia.com>
Date:   Fri, 11 Dec 2020 14:34:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
In-Reply-To: <20201211122921.40386-1-wanghai38@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0065.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::16) To DM5PR12MB1356.namprd12.prod.outlook.com
 (2603:10b6:3:74::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.216] (213.179.129.39) by ZR0P278CA0065.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:21::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Fri, 11 Dec 2020 12:34:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 410a998b-b700-41de-cff3-08d89dd12246
X-MS-TrafficTypeDiagnostic: DM6PR12MB4926:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB492651168FC190A05EF806B1DFCA0@DM6PR12MB4926.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OX+frAQAF7VOGmU4wcOTza191yaU/gBf+Euuo3GDJ62g+yyFJM+cG5WTkKQBXl/g5QIYEsp/YbIHBa9hSkFd9FcDFbgYlJ0ZAurJwIJeoynmWAj1zLLhhZRwuuqgGcz8Se64Uor+gMnf7Fw5QC8vyAae1tJtQo8NwXUsMADXNNrXy5efHoAq752+ftM5XsIErnNXGJy4AIubj2nSBqdiSWmAv2KoHxlr3WtcroqnZvtkgH09viLsyDTBKsUT9UxTsSuACLDPeEOhXL06Pf2DUUxFB6Bglh/vKLjlKqSa+WztqGt4Ah/Nxq76roLfHX7dU7Unz03mY3ftmLA3erkQR17KpA2rLEwtW+K1/mfsNq5jfFKcV5rZUppwmoDB2GY99orie87LnflKtQj/6hPvR7CPUAS/ZBL79u2JjEHbjt8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(376002)(346002)(5660300002)(66556008)(66476007)(6666004)(31696002)(16576012)(83380400001)(36756003)(6486002)(66946007)(2906002)(53546011)(508600001)(26005)(2616005)(6636002)(4326008)(45080400002)(86362001)(8676002)(31686004)(186003)(16526019)(956004)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?V1duSCtqMlR1bC9yb1RKcU5qLzhpdFNtUmVLcFFJUFk1T1NpaGZ0dVVQcExC?=
 =?utf-8?B?cWZ0OFZKc3lEVkJTUXNlK3U1RVMzalF5OXR6Z2E5d1V3UGUxVVJ6WUxsdHph?=
 =?utf-8?B?R1RoS05xTzJjYlBsNnJxTXpDdUw4eXlnUms3RFB2bE5YVEx5aVo0N2l6OU5p?=
 =?utf-8?B?ZDlIMXBXa0U2bi9aQmtsQlhFdWN5WlFrbUgwRmN6cDE4WkJrUjUwUFhPd3Rn?=
 =?utf-8?B?NHdmSFN1RERZd1E3dEMrbWRzK1FVeXlXS3R2dmJFd2lpQytFVlp5NlgwUWEx?=
 =?utf-8?B?eHBWSVNKN29NbDFCWExJSy9QTFA1M2pTMjN1YldKRG9pdCtFWWw1R2Y1VXJs?=
 =?utf-8?B?WGxwM1gvb1QvbmJoRTQvbDNoeEloblY5UWdNbEIvRUI0dEFMcGt1WGhKMXZ6?=
 =?utf-8?B?TjJRd2FKb2tPY2doV2ZRMG45Qms5ZVRQQzlNQWVvTHc1YmgxbURwU0pjOXhG?=
 =?utf-8?B?L0lvRzJhZUl2bUphMkt6bkd1V2VsQU8vOFVWdEJVQ292UnRVY0Z5V3JBWXFT?=
 =?utf-8?B?R05ucW9WVENlMDkxbzBlSHJzRFdRQ3pCOHc1VWxzajloV1ZWN2l5ZFMvZGxF?=
 =?utf-8?B?OTZBcE1qNzE5MEZPMVFrZzFuQTV4WUZHSjRHL0JXeHJVTDVRZnUrQVhoaHYr?=
 =?utf-8?B?TU55S1hpeVRwd1ZpNURxMFc3RWlxK3ZFWElZSmJSWW8zcy9yYjFYeHZiU3NH?=
 =?utf-8?B?YnRsMFJqRUJXem1SbXc5bmdZU2VhVm1kaXlyYkVMYVVvRjV3TzBENzQ1OWRa?=
 =?utf-8?B?empsNExLRk12S3RSOEthaTdGUWNqTFJHQXpXU0JHdDdyU2wyY0ZiYis4Qk96?=
 =?utf-8?B?dGF6cEhxQ0lWVHBHTnpBMTdHbWZONTZoVGowaEpLRGYxdGxIMEszWW8zeEI1?=
 =?utf-8?B?ZzErMVEvdDhhdWhmN0dYS2RaY1czclFEcGZvaEowQ21uM1QvS1FDZ0RkVDlW?=
 =?utf-8?B?dTJkaDJybTFaaUc1OUlpTERFaXBBZzFBWVNuMExzUGJLQjA4VW5xVTY5OHZl?=
 =?utf-8?B?YnR4MzAxUTlhbUhiU3orRktrLzFlYlAyemlleHZWREtQOS9YVDE2NFFRc2Jn?=
 =?utf-8?B?TlJ5TjdNZ2ZLYUF5ZEFOK2p6T1lScGNyNVR6QWg5bXZnSzYrM08rT21wYVU5?=
 =?utf-8?B?U0xYMXdubVNzM3RlQUdCOHVZMmxnM1UwaDRDNVpZZHhuK2NoR2tuQWJWSWY2?=
 =?utf-8?B?dkFiTFdDTDJoaTdGSkxsOVMyMm0vYm5rSXVWRWFZY01VblBpTUcvdTcrZk1V?=
 =?utf-8?B?NFhPNk1QL0x6RFBWYkZGRXZybXF1anRTQVVxLzJtUzFuRDNCWkpYMEUxRW5I?=
 =?utf-8?Q?daZmAd9E6wvbFoUtGkWLjb/EWiGviB8QYQ?=
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2020 12:34:42.0727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-Network-Message-Id: 410a998b-b700-41de-cff3-08d89dd12246
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bTH1qtjAzITBRWzLYOrc5zLjRqpSMX9JWmhGk4XiKLHHurB6ARdo2jNPbxzYv4esMxrlhj2HOHnwpzmFxXZrqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4926
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1607690089; bh=a4dDkkvVeV8U82GM+m61Hub3z40BxGAHtYxTCYbI0/c=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:
         Authentication-Results:Subject:To:CC:References:From:Message-ID:
         Date:User-Agent:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy:
         MIME-Version:X-MS-Exchange-MessageSentRepresentingType:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-MS-Exchange-Transport-Forked:
         X-Microsoft-Antispam-PRVS:X-MS-Oob-TLC-OOBClassifiers:
         X-MS-Exchange-SenderADCheck:X-Microsoft-Antispam:
         X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
         X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=n6VFr8g0caEeltIArqEojWcJHQ9DGQH4cUKWakIcFXTK5jQAmZx6Yf4zhA7qMaQx6
         4PXMRxWlcpgtz1aNDbOazszzwc5ZsQbRBYOIHHiGMRZd8FsihwnbVzbVShsbVO2JE/
         O3tMX791HcYB5kkenUVmanof6cg9o5nRKrIwhkhqxTRKnHg2W2ZfO6xrvKR29fMWiD
         G4DWC9SlQrCayInJbPlzWr+0vsGyzIHN7hv96tWDAUDMTfVy3Dz5Iq6reywoUzOJ1B
         cOdMhVTRYuzt4yakmEkUYd9ubQyTByn3CFj7ieX1Ea61/uNfbSSQ/vl7QwcZQxSOAP
         LshxdtCPm9R6w==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/12/2020 14:29, Wang Hai wrote:
> I got a warining report:
> 
> br_sysfs_addbr: can't create group bridge4/bridge
> ------------[ cut here ]------------
> sysfs group 'bridge' not found for kobject 'bridge4'
> WARNING: CPU: 2 PID: 9004 at fs/sysfs/group.c:279 sysfs_remove_group fs/sysfs/group.c:279 [inline]
> WARNING: CPU: 2 PID: 9004 at fs/sysfs/group.c:279 sysfs_remove_group+0x153/0x1b0 fs/sysfs/group.c:270
> Modules linked in: iptable_nat
> ...
> Call Trace:
>   br_dev_delete+0x112/0x190 net/bridge/br_if.c:384
>   br_dev_newlink net/bridge/br_netlink.c:1381 [inline]
>   br_dev_newlink+0xdb/0x100 net/bridge/br_netlink.c:1362
>   __rtnl_newlink+0xe11/0x13f0 net/core/rtnetlink.c:3441
>   rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3500
>   rtnetlink_rcv_msg+0x385/0x980 net/core/rtnetlink.c:5562
>   netlink_rcv_skb+0x134/0x3d0 net/netlink/af_netlink.c:2494
>   netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
>   netlink_unicast+0x4a0/0x6a0 net/netlink/af_netlink.c:1330
>   netlink_sendmsg+0x793/0xc80 net/netlink/af_netlink.c:1919
>   sock_sendmsg_nosec net/socket.c:651 [inline]
>   sock_sendmsg+0x139/0x170 net/socket.c:671
>   ____sys_sendmsg+0x658/0x7d0 net/socket.c:2353
>   ___sys_sendmsg+0xf8/0x170 net/socket.c:2407
>   __sys_sendmsg+0xd3/0x190 net/socket.c:2440
>   do_syscall_64+0x33/0x40 arch/x86/entry/common.c:46
>   entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> In br_device_event(), if the bridge sysfs fails to be added,
> br_device_event() should return error. This can prevent warining
> when removing bridge sysfs that do not exist.
> 
> Fixes: bb900b27a2f4 ("bridge: allow creating bridge devices with netlink")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> ---
> v1->v2: Fix this by check br_sysfs_addbr() return value as Nik's suggestion
>  net/bridge/br.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/net/bridge/br.c b/net/bridge/br.c
> index 401eeb9142eb..1b169f8e7491 100644
> --- a/net/bridge/br.c
> +++ b/net/bridge/br.c
> @@ -43,7 +43,10 @@ static int br_device_event(struct notifier_block *unused, unsigned long event, v
>  
>  		if (event == NETDEV_REGISTER) {
>  			/* register of bridge completed, add sysfs entries */
> -			br_sysfs_addbr(dev);
> +			err = br_sysfs_addbr(dev);
> +			if (err)
> +				return notifier_from_errno(err);
> +
>  			return NOTIFY_DONE;
>  		}
>  	}
> 

Patch looks good, I also tested it with a notifier error injecting.
Tested-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
