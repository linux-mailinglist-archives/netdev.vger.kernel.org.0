Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 873B2174D59
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 13:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbgCAMjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 07:39:31 -0500
Received: from mail-eopbgr60061.outbound.protection.outlook.com ([40.107.6.61]:51015
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725874AbgCAMjb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Mar 2020 07:39:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MWB2DD63TDE2rXiBNsFsiNpidC2Aqv1sN+rRRLWognTa1GbSy7fNDikFGc9kFq7QWuoR3kXUNGw5aQZs52+1OSVwF0mz0ofMNQ+++lTh4Y3hcToDNOo5GuBT6X0lMyUhEKz4NxIDKwmSiiOjiiAQuQlg05oVBK558GwwtSlzMIObLxHqVF7GXW1lsV2dLcC9vc3ibLQlXzeUnmU8vgawjdO13Z1VScWnvZE+O/KQuVQsF4eVZuXkg/4jRIE7Wbkq2j/xAHIU3PHJ0mfKldoLS6VJ6kNC7unUWfT+V2e6EmGLuYmwXWEuZqLS21q96mbjtzQQ8RIEZesVp9zxCnrTOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o6H+KxPVzFKWrC+W4E/LAeXrIFECu8xPV/YVbkq35KU=;
 b=bWO9S6syALVEuSt1DJZfTJwfB9hihe8C1ftM/XxnshE+paIGDXmwoi5QOgDLnehpxa3ZJHPyaG/Qop5N6KIN8/icH6neJZ0VAZhmCWVkERZ5nX5hQhTCpnZF4R7UO1ixeqc019poOzUf7CjmJpbgUtjz1kUYqhgJYST0KrOnO/7OP2TyYDvwVP+g1IMD8IKA8u1zExDGOg56cDyBTfMW2Dd++mY3KJIsU1kbn3t4j2XBmY4p4powXM5t3WHA7g1tC/M3XLsveP/GZ1UO3C8CFZL120A6DrLBJTHmTAiAAziQdrpekuTD6tkHKSdcNsyvugk0y18HiYjTkJuCoz5b3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o6H+KxPVzFKWrC+W4E/LAeXrIFECu8xPV/YVbkq35KU=;
 b=cZFSflrPX3e9yVl/1F+ZVJbA3qnfhXVhdPupaaGlu+Dnt2TQKNiLwu8cVkK9JTwjQrD+zFFi7iDv9J979PMNZnuz1YLISZBgeZfq/xpZIxBUxYsRVeWp8aUROAxt6z144IFu0QyKWqO0xpOltrwp0Esg8rApH0jPgxgo2VSpX3g=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com (20.177.36.78) by
 AM6PR05MB6231.eurprd05.prod.outlook.com (20.178.86.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.18; Sun, 1 Mar 2020 12:39:27 +0000
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::41cb:73bc:b2d3:79b4]) by AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::41cb:73bc:b2d3:79b4%7]) with mapi id 15.20.2772.019; Sun, 1 Mar 2020
 12:39:27 +0000
Subject: Re: [PATCH net-next 4/6] net/sched: act_ct: Create nf flow table per
 zone
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
References: <1582458307-17067-1-git-send-email-paulb@mellanox.com>
 <1582458307-17067-5-git-send-email-paulb@mellanox.com>
 <20200228134517.GA2546@localhost.localdomain>
From:   Paul Blakey <paulb@mellanox.com>
Message-ID: <22b32308-ce26-95cb-cf35-442465fbdbc8@mellanox.com>
Date:   Sun, 1 Mar 2020 14:38:48 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
In-Reply-To: <20200228134517.GA2546@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR02CA0053.eurprd02.prod.outlook.com
 (2603:10a6:208:d2::30) To AM6PR05MB5096.eurprd05.prod.outlook.com
 (2603:10a6:20b:11::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.223.6.3] (193.47.165.251) by AM0PR02CA0053.eurprd02.prod.outlook.com (2603:10a6:208:d2::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.18 via Frontend Transport; Sun, 1 Mar 2020 12:39:26 +0000
X-Originating-IP: [193.47.165.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 944acb02-c093-45f8-bb07-08d7bddd9462
X-MS-TrafficTypeDiagnostic: AM6PR05MB6231:|AM6PR05MB6231:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB62310720ADC2A648EA3B5A1CCFE60@AM6PR05MB6231.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 0329B15C8A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(136003)(366004)(39860400002)(376002)(199004)(189003)(26005)(4326008)(2906002)(5660300002)(6486002)(53546011)(478600001)(186003)(31686004)(16526019)(6666004)(31696002)(2616005)(54906003)(66556008)(66946007)(66476007)(8936002)(6916009)(8676002)(86362001)(81166006)(81156014)(36756003)(16576012)(52116002)(107886003)(956004)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB6231;H:AM6PR05MB5096.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +FoHKubw06ec5x0Etn3RY5MemZHu6ZrbVPrWVjJUog4ea3nA+bJurLz2WFEPzjKtmj2WuaTiWcmIaApKza6q2xdu/HVy+iazFfRB/Kn0fXicaZfNAK9MwgbNfPjfZj0GVQ+TQpQLtJWeLN5IpXHSo2GRazOSKfOyU1IyQDU5L+jjAm2vUVg4WG09c1lH9OmtgowDQVwvDNaut/lSXWLKjQ3WvgEogrIiCMJbPDfPcqDE4Cfw9e2Ts6h/u4nqhSPzsi8e+6BFcPESfGHJOjsBYBor0UyY9bEyY3owI4u/+meKt/g2WiSkysaZKKvwC2f2BoJy8sir5ks/cQpQaMjMH+7L8S4s9yC51lS6/8/9UIfgoszNTUZD7QuMbWYGQeneozeNxMobfFUM6XLXtWa/qTCyi9LuSGlaxIC31Cis6Xi+73V2mMYo743w+s8IJofS
X-MS-Exchange-AntiSpam-MessageData: XXGA6q5fX0BUC6/n07+jPmSTv7gAiJutPyp+4plYbagZs2BAx99V1hKwVt9MtVRlRcL94drD+J8yvsGOVBnoC8lYVJzqgWTj/CZLGr/ossmNLeajMgJYdhrKItoyPtAQLLrGay+uxMMb6u5Rzhw/uA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 944acb02-c093-45f8-bb07-08d7bddd9462
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2020 12:39:27.4333
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wEOI60VQL0Lmc61oTe2/iQZ3QIyxSXlg0WEcliUb2IsO0QQF59v13lD2J+UM9fB9IyOIjuPDfaLaA1qM2YD6mQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6231
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/28/2020 3:45 PM, Marcelo Ricardo Leitner wrote:
> Hi,
>
> On Sun, Feb 23, 2020 at 01:45:05PM +0200, Paul Blakey wrote:
>> Use the NF flow tables infrastructure for CT offload.
>>
>> Create a nf flow table per zone.
>>
>> Next patches will add FT entries to this table, and do
>> the software offload.
>>
>> Signed-off-by: Paul Blakey <paulb@mellanox.com>
>> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
>> ---
>>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c |   1 +
>>  include/net/tc_act/tc_ct.h                      |   2 +
>>  net/sched/Kconfig                               |   2 +-
>>  net/sched/act_ct.c                              | 159 +++++++++++++++++++++++-
>>  4 files changed, 162 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>> index 70b5fe2..eb16136 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>> @@ -45,6 +45,7 @@
>>  #include <net/tc_act/tc_tunnel_key.h>
>>  #include <net/tc_act/tc_pedit.h>
>>  #include <net/tc_act/tc_csum.h>
>> +#include <net/tc_act/tc_ct.h>
>>  #include <net/arp.h>
>>  #include <net/ipv6_stubs.h>
>>  #include "en.h"
> This chunk is not really needed for this patchset, right?
Removed thanks
