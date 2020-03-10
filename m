Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09F7C17F14E
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 08:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbgCJHzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 03:55:05 -0400
Received: from mail-am6eur05on2075.outbound.protection.outlook.com ([40.107.22.75]:58369
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725919AbgCJHzE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 03:55:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hNXOH0gejRTNKEgp6eSj/PrPshGQ8rm4vLsJcXx6QzlCC64aw8uN+JbBIQk0Cn9DNw7HQyHhrXaQUFJqEYL6QRIfvDkJa7Z5wCDEMPkRGQmUaMOsXUyY7fAUAOtFUXLNDCgK/2ISfOiegkDybjvC+UBwdJCyTbKcUrd+/K7ac0eJMC9UACDzOK+ERfJnLmVZtXx3EM6ddK9LFS6Kh9rubvY3V753iwnNL+2JTYtvootacWn+wjCMgef4c3aTnTtdUNHv6MCjNBz5FOCjioAYlfroRhkRe/wojmVJK13RzowBW06Yr7glft487xHBlkWe6BMF4iNTmbjeC5VjSq1aAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=quXXEiufPkOICqXaYxWBkSpInDlSWRZNuoHbosVuQBM=;
 b=RDYzLLqjFkPnORgRWqAajOmO8tOe2hLG4NJrZnfhB5zuBAAoYAECzYx1VcBCg/0SRjHk0t5LGDL5q7IFC6Kr2m12f3SD8Ky6QUKKMrSQ3N8hqVqw2BXSyf2HGiL+QVK80BeA5gUHR/8h3GRgxWcBMVrTiX4xpg4pWQRHla0sCz9dG8rVp4gzROdj3jRSf4fUQo0urOUMnf+PJw654u0tIEYNtbvosPesWDwVZfv+y7GwgvSitc+yZdbDUXDShtlXa4v1AjU2s+yn0w3cD1ab/fkcS+HuVtCj/MsIDMM28hxGi/LW9cTfk1FSEYUw5mdut2vAMYZbDuPtZHoCRUjmeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=quXXEiufPkOICqXaYxWBkSpInDlSWRZNuoHbosVuQBM=;
 b=GFWd3kMovv5GDPMaWI8BHqe7EVVRo+EIIHdo+nzBSk6lmRnImRZ1k1we+2z+nDxEk+RsPbHhlIKSzN2B6dFG8CGI6x05YosmNBoAzEKgVzqXVMOiu5mWqOhQ9s0TEpsB3uxdK966n5IP8QrC/GIjmzrjLDa7iskW3qbHW8XRsR8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com (20.177.36.78) by
 AM6PR05MB5427.eurprd05.prod.outlook.com (20.177.118.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Tue, 10 Mar 2020 07:55:01 +0000
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::41cb:73bc:b2d3:79b4]) by AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::41cb:73bc:b2d3:79b4%7]) with mapi id 15.20.2772.019; Tue, 10 Mar 2020
 07:55:01 +0000
Subject: Re: [PATCH net-next ct-offload v2 06/13] net/mlx5: E-Switch,
 Introduce global tables
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "marcelo.leitner@gmail.com" <marcelo.leitner@gmail.com>
Cc:     Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roi Dayan <roid@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <1583676662-15180-1-git-send-email-paulb@mellanox.com>
 <1583676662-15180-7-git-send-email-paulb@mellanox.com>
 <20200309224013.GK2546@localhost.localdomain>
 <428981006305a063a196e8b51ab2161b1b1d897c.camel@mellanox.com>
From:   Paul Blakey <paulb@mellanox.com>
Message-ID: <9c044a2b-c4b1-7811-fcbd-dcae17b91553@mellanox.com>
Date:   Tue, 10 Mar 2020 09:54:59 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
In-Reply-To: <428981006305a063a196e8b51ab2161b1b1d897c.camel@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: FR2P281CA0018.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::28) To AM6PR05MB5096.eurprd05.prod.outlook.com
 (2603:10a6:20b:11::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.223.6.3] (193.47.165.251) by FR2P281CA0018.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:a::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.14 via Frontend Transport; Tue, 10 Mar 2020 07:55:00 +0000
X-Originating-IP: [193.47.165.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 205f6d5c-c705-4ac9-3284-08d7c4c855ec
X-MS-TrafficTypeDiagnostic: AM6PR05MB5427:|AM6PR05MB5427:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB5427CD125E83534F7533260DCFFF0@AM6PR05MB5427.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 033857D0BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39850400004)(376002)(346002)(136003)(396003)(189003)(199004)(6486002)(316002)(5660300002)(16576012)(31686004)(2616005)(186003)(36756003)(26005)(956004)(16526019)(2906002)(52116002)(86362001)(53546011)(54906003)(66556008)(66476007)(66946007)(31696002)(8936002)(81156014)(110136005)(478600001)(4326008)(8676002)(81166006)(309714004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5427;H:AM6PR05MB5096.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YtrLEgG6qmRn5XLJV4SxI21lCTgGUdd4q8SKyuCak+9GgKR8kINfU86P0Fb84XAmJC7d4TZxdyHR1Elt4jUchQ0Y9z3vwc0dg+XG3JSap9hsciC6Jf7wVeg7lH9jJ4b8v6RdcvhGRbybUObd93eAxEWIT3S54k4lh6znOLk1dlye0GwPY10cGwLEGyrDxHBk3ne/9eUO+o2alMsI2Jf66cDq+Hs40nx+i6u5dyZsfFsiZhW41fHVStX5BRMRw0YuKjbBrcn6w5+cP45r0MN9H8Re6/Wn1/PHLZJP3081mILMilWJtIBFUbxoeFx1SYLjGUBSPnqrwsPp6yrQ8hdbBZKoh/B1bJg2mJRRAGWlRhjn2C0bbZb9cZaeysD3uy3l4fSmZWy7aEZj1R/xn0eSfgoqHgsVRj0e+e5WGcBncTbW4s30Cw+kDvVtlW7x/xFgu5vqsgFfBzZ11jxDZhypYbp6cN6Cqu70IZInADAhHc4UjNEWtBfZO9jR4PMHwVdp
X-MS-Exchange-AntiSpam-MessageData: hak5aHk0gl4eHX/EsBTOC6XnHA2ulZu9K4cRNxsxTsiSLJM8naqdQpKww9IoIXROnQy3bsq2Z76xGgElDCBKl8OXoLs/Sri3Kkp2PIT3Rq/rZhNE/lr3Y2JthyNJcbrXeBl658uYzH28zmgCfAvLYg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 205f6d5c-c705-4ac9-3284-08d7c4c855ec
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 07:55:01.1969
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QPjYpzJq7V6x6ivk+2YHrHq2A62s5eLxmw/oHZEwwGa+scauux53tYpy8gy82Aw8VzCbwD4BsbpkWf0SblKr5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5427
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/10/2020 3:54 AM, Saeed Mahameed wrote:
> On Mon, 2020-03-09 at 19:40 -0300, Marcelo Ricardo Leitner wrote:
>> On Sun, Mar 08, 2020 at 04:10:55PM +0200, Paul Blakey wrote:
>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
>>> @@ -149,7 +149,12 @@ struct mlx5_flow_handle *
>>>  	if (flow_act.action & MLX5_FLOW_CONTEXT_ACTION_FWD_DEST) {
>>>  		struct mlx5_flow_table *ft;
>>>  
>>> -		if (attr->flags & MLX5_ESW_ATTR_FLAG_SLOW_PATH) {
>>> +		if (attr->dest_ft) {
>>> +			flow_act.flags |= FLOW_ACT_IGNORE_FLOW_LEVEL;
>>> +			dest[i].type =
>>> MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
>>> +			dest[i].ft = attr->dest_ft;
>>> +			i++;
>>> +		} else if (attr->flags & MLX5_ESW_ATTR_FLAG_SLOW_PATH)
>>> {
>>>  			flow_act.flags |= FLOW_ACT_IGNORE_FLOW_LEVEL;
>>>  			dest[i].type =
>>> MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
>>>  			dest[i].ft =
>>> mlx5_esw_chains_get_tc_end_ft(esw);
>>> @@ -202,8 +207,11 @@ struct mlx5_flow_handle *
>>>  	if (flow_act.action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
>>>  		flow_act.modify_hdr = attr->modify_hdr;
>>>  
>>> -	fdb = mlx5_esw_chains_get_table(esw, attr->chain, attr->prio,
>>> -					!!split);
>>> +	if (attr->chain || attr->prio)
>>> +		fdb = mlx5_esw_chains_get_table(esw, attr->chain, attr-
>>>> prio,
>>> +						!!split);
>>> +	else
>>> +		fdb = attr->fdb;
>> I'm not sure how these/mlx5 patches are supposed to propagate to
>> net-next, but AFAICT here it conflicts with 
>> 96e326878fa5 ("net/mlx5e: Eswitch, Use per vport tables for
>> mirroring")
>>
> Paul, as we agreed, this should have been rebased on top
> latest net-next + ct-offloads from
> git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git
>
> Pleas rebase V3 and once the review is done on this series, i will ask
> Dave to pull 
> ct-offloads from
> git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git
>
> which was already reviewed and acked on netdev mailing list.
will do.
>
> Thanks,
> Saeed.
>
