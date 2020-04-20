Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0191B1534
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 20:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbgDTS41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 14:56:27 -0400
Received: from mail-eopbgr70083.outbound.protection.outlook.com ([40.107.7.83]:12854
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726017AbgDTS41 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 14:56:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FMEh9/QoyPMZhFpxfaB2vMZNAlTNRkgpR7CegWrF8ybP8GOVLOel9tBAp9l+EoSsQ/hHlSXoGgZRhnoNJmREw3Sg+K/ghzS1YqtDNopPJ6bARwfmH1KQCJZ3ptU1dM/1Rvzik7rmo8+IJlp1mkNWTgkFKDoHr8UxMPCvmaR/5pZg5L+Oz5VnTWFhL0/Ep6z8p0QNlOC3kettcQlBPMjB/TevFnkG/vkVh/iFgxX/9uVcVTYXOhx72aaoYKLswKIYRZPtMOjQRAZY5HaqWxDht/oU9c3jE9ZaleZSgzHTwEEUnhHm/sDJQcZZ8lpd42scAHdu+K8S5Ll47upA4VYvpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=94TKUF2hG+GRh39AO3ol7+KbShQ60OqFgFTtedpvfdc=;
 b=ZasO0jZHjpsMKA2Dw4k3K6NzoUhR8R+Zn7DY9LVkkFfMCIyOK3UVrvmnb8tok+4oWGJ/F4kh8suOAdByGdgqBLr7bhTMd5AELlFciTcETIsUJnGVfKCyQ2X5XrIQ6HcSkNrmixvZk7C0U8xs7hUJK1nNUhbrkVlOfzbnlOK1IjhTltrybmjmveKeygSbZWTrcJuAadpNuOm8MTffGFWTBJ+6izVVafMy5IJoPkUNMZGiHVHsd6mzJVg7CG3bhny7smF0s9JCJyy+79t+kJo1SbclfthfoFST+xvj668ey8FSqoRimgDGQzJGLCFeoXn0sEhaQgOewlH9ecvGXdlonA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=94TKUF2hG+GRh39AO3ol7+KbShQ60OqFgFTtedpvfdc=;
 b=EtVT7y6jJYLE6EPXNNdw+HJarN0kGxGwCyXpoZh+elo6IhSRcjurAk9aQsHQpY8JVX0o6zz3NEkNz0pNvAUrtAEaQRMX6rDSIiyTyWGNOiiMIdeOlV9tlzzjE6RjL4SJ8wJaeToALyOqit+wCzYLke0MVntW01ayAi13W7q/Zxs=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=maorg@mellanox.com; 
Received: from AM0PR05MB5873.eurprd05.prod.outlook.com (2603:10a6:208:125::25)
 by AM0PR05MB6420.eurprd05.prod.outlook.com (2603:10a6:208:13f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.27; Mon, 20 Apr
 2020 18:56:23 +0000
Received: from AM0PR05MB5873.eurprd05.prod.outlook.com
 ([fe80::3401:44fa:caa1:8d41]) by AM0PR05MB5873.eurprd05.prod.outlook.com
 ([fe80::3401:44fa:caa1:8d41%6]) with mapi id 15.20.2921.027; Mon, 20 Apr 2020
 18:56:23 +0000
Subject: Re: [PATCH V2 mlx5-next 01/10] net/core: Introduce
 master_xmit_slave_get
To:     Jiri Pirko <jiri@resnulli.us>, David Ahern <dsahern@gmail.com>
Cc:     davem@davemloft.net, jgg@mellanox.com, dledford@redhat.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, leonro@mellanox.com, saeedm@mellanox.com,
        jiri@mellanox.com, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, alexr@mellanox.com
References: <20200420075426.31462-1-maorg@mellanox.com>
 <20200420075426.31462-2-maorg@mellanox.com>
 <20200420140118.GJ6581@nanopsycho.orion>
 <a9e00f31-2f4e-1dfc-2464-d3d25376a4b8@gmail.com>
 <20200420175421.GU6581@nanopsycho.orion>
 <916ab047-3b50-7104-311a-6dcf604bcf6d@gmail.com>
 <20200420180144.GV6581@nanopsycho.orion>
 <75dffa6a-c14f-45c9-44e1-bf5b5c650a9b@gmail.com>
 <20200420184811.GW6581@nanopsycho.orion>
From:   Maor Gottlieb <maorg@mellanox.com>
Message-ID: <60467948-041c-5de1-d365-4f21030683e7@mellanox.com>
Date:   Mon, 20 Apr 2020 21:56:18 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
In-Reply-To: <20200420184811.GW6581@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM3PR07CA0130.eurprd07.prod.outlook.com
 (2603:10a6:207:8::16) To AM0PR05MB5873.eurprd05.prod.outlook.com
 (2603:10a6:208:125::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.100.102.4] (89.138.210.166) by AM3PR07CA0130.eurprd07.prod.outlook.com (2603:10a6:207:8::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.6 via Frontend Transport; Mon, 20 Apr 2020 18:56:21 +0000
X-Originating-IP: [89.138.210.166]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8676c697-5bff-469e-b511-08d7e55c8520
X-MS-TrafficTypeDiagnostic: AM0PR05MB6420:|AM0PR05MB6420:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB64201D52C6F87CB1FE3B1621D3D40@AM0PR05MB6420.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 03793408BA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5873.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(366004)(376002)(39860400002)(396003)(346002)(31686004)(5660300002)(31696002)(2616005)(4744005)(478600001)(186003)(956004)(16526019)(4326008)(107886003)(6666004)(86362001)(8936002)(8676002)(66556008)(66476007)(66946007)(6486002)(110136005)(52116002)(2906002)(16576012)(81156014)(316002)(36756003)(53546011)(7416002)(26005);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SFIR59H6wJhq/ovkDKqe9ARjvAPeKPdCG7SxjOT0EXIGLdbS1yq+DiM8N9OKNSLfpaMk2QNYsdBRcqGSAFvmIceRfNK95Kzno8D45BE9MHYJTRVFO61u8rorITBfP1uNrE9eXrWo1MVl+iVzwFbRW6B9bj4j8CF/D3N/1dR1jPqFUaJ2i/MU3d34NzqWPkYzkF7xHhaJkgW1V6w9NzQ3Bi7rPl7HoMrljlZj7KDvDWdqzHcKJqVixtwtTJcGzZGkoG4poX2lMwJldMA/g1OeaBo7hPtIvFpuqCyCOBOPpGokrY1X/fxBFnc0r+AByzuY4pnDeReIyWlQBaQnpFJwmvGtNd5SUPbPA1l6KkHn3nsohZG3w1uZSfU0o6fEuTiLQ2FJMtosD4B4DQ1v7dzK86aag4I8plG+aAXohmDMsOYVpASLhKYY/colNN5k7fMQ
X-MS-Exchange-AntiSpam-MessageData: 18CqnzOTnDIS7XpEycMYRAAGVK1BT1xi+qJquf52TLAJ5o74y6bh16ngFGUhT7pYaa/YHKdMU/oqkaO6cNjHh1sfecVqGn53KjZNCKTjYb6OAetRx+Ge5Bj9YTlbxWVGzzNkYqqdV1c9wDvzC00qZg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8676c697-5bff-469e-b511-08d7e55c8520
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2020 18:56:23.0898
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XF9jWOLweqWlVRmobZ6sWhN2YPkBZvraB3990UUHoKm7BgiC88A9CMNb/DFoNOstwPkc7eAC5I68fW6GCVEv+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6420
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/20/2020 9:48 PM, Jiri Pirko wrote:
> Mon, Apr 20, 2020 at 08:04:01PM CEST, dsahern@gmail.com wrote:
>> On 4/20/20 12:01 PM, Jiri Pirko wrote:
>>> Generic ndo with lag-specific arg? Odd. Plus, there is a small chance
>>> this is ever going to be used for other master. And if so, could be very
>>> easily renamed then...
>> core code should be generic, not specific and renamed at a later date
>> when a second use case arises.
> Yeah, I guess we just have to agree to disagree :)

So I am remaining with the flags. Any suggestion for better name for the 
enum? Should I move master_xmit_get_slave from lag.h to netdevice.h?
>
