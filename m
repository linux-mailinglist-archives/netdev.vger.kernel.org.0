Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD26231ED5
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 14:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbgG2M4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 08:56:02 -0400
Received: from mail-eopbgr130083.outbound.protection.outlook.com ([40.107.13.83]:38542
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726353AbgG2M4B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 08:56:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QnqAPsSUqWwxUCSERJd2vf+KvZvWJPBVbET+WAvjkNRm90cls369bVp9VrsI3WUo2bskY4StljfOXFOavq4q1D7N0Tf85RuSQE6tdxwC/iqb+EA9ZBkAjBG1wruFdDX9DN/85cD4ROQBJ9+6v1mXT4nf50/IQBFtImhg2lcuZV7oYQMlig3GGH4NkAIpSvcJSoVF8fFoG3zCHi9nJHmW6mxGqVe02/2s67tzlBYG/2ZQCbBjV1Es+yKDBGnt/mWH6NpvkrkvvaYwXlL/FzguXCNuT0spZQqzsEIZvgtOwn5HHCEiwpZNrOVRjXPebdEB8CeeDlgcg42Cbwvr56o4eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7cOMW+1+YGX7aAYtmWzQR04pSQxF5ccSQYfz0c7WSIs=;
 b=DKMBBzkUG+p74ME47FbvTLhEeu/sNxWj7lK6u4c5OTgA0i/jJ2aUKI/89EJrbbLNCI265UFA6quX51jLt8LyeCc+6+cAyDlHKa249QljOXKXS0SWQ3j1cFr7pA1OmkeBUW537ptfmUVu8CCfrYePkT+4smVRXM2BYqILUK2dsmtx6GA6A48sw6E2UrbH4yLYcPVgfKcFRooGq4OqnTHUm6x++yuL1fhmVCCr3q7n5jek1VTFw5duo4ZA8RMeo/PR15m2tk99epYdikwqYDcKq0ker4syLHB4iLS7kzYq4Q6eqdP2r7zCs4aWkkH3Tl/nsqxHSbEmpkw2G7daWNshlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7cOMW+1+YGX7aAYtmWzQR04pSQxF5ccSQYfz0c7WSIs=;
 b=GtFUZ3/CPyxr372zw7moZqI/AI/3veSStuYFHk2zOPMUsB9csS2lBmcfk2+N9nfrW2cZADnYkAU6Ac43dhKsUNsi7L3kqjJF+nVKlP5tTUj1NiOM7j0ARmIAwNORR0stqS33/yFFNn+WbVqbAGYcF+UEeUKp0gaPFtbA+/OTr78=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from DB7PR05MB4156.eurprd05.prod.outlook.com (2603:10a6:5:18::21) by
 DBAPR05MB7031.eurprd05.prod.outlook.com (2603:10a6:10:189::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3216.24; Wed, 29 Jul 2020 12:55:58 +0000
Received: from DB7PR05MB4156.eurprd05.prod.outlook.com
 ([fe80::84:f8d2:972:d110]) by DB7PR05MB4156.eurprd05.prod.outlook.com
 ([fe80::84:f8d2:972:d110%7]) with mapi id 15.20.3216.033; Wed, 29 Jul 2020
 12:55:58 +0000
Subject: Re: [PATCH net 2/2] net/sched: act_ct: Set offload timeout when
 setting the offload bit
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     netdev@vger.kernel.org, pablo@netfilter.org,
        Paul Blakey <paulb@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>
References: <20200728115759.426667-1-roid@mellanox.com>
 <20200728115759.426667-3-roid@mellanox.com>
 <20200728144249.GC3398@localhost.localdomain>
From:   Roi Dayan <roid@mellanox.com>
Message-ID: <c33a4437-8a7d-10fe-7020-94cec26d5aca@mellanox.com>
Date:   Wed, 29 Jul 2020 15:55:53 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200728144249.GC3398@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR10CA0088.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:15::41) To DB7PR05MB4156.eurprd05.prod.outlook.com
 (2603:10a6:5:18::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.170] (176.231.115.41) by AM0PR10CA0088.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:15::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17 via Frontend Transport; Wed, 29 Jul 2020 12:55:57 +0000
X-Originating-IP: [176.231.115.41]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c92f3612-8217-4e1e-5478-08d833bebd4d
X-MS-TrafficTypeDiagnostic: DBAPR05MB7031:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR05MB7031ED634E5F4E1787AC07F1B5700@DBAPR05MB7031.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YWF9zDvu/WJ/J77XUOt+/XQDN0HN5uAlrx8015usqTZsPOWlSRe/UMw6Y8HBBCqGgOYPKi+qjYI+Fg+xWMt5cxY9eTmYZNT/sdns0eLMs2Ru6xFpLAFmIAeYH5f4Cfxl0IgCsYWuO2Fd/XRg6twANi8jSnyZBWiIEROCkx+U+Mhi2PGbqcU9BMsY+x3PPWOOlZM2Rm6FVW7LBMAs+Wv2YqshssDfAtPjK31vodzqpx5AQ5LpIIlATBXBmTGP/mkz5u63Ct6PbEqQO+IMhaLhJFEcInYJXeCFbF8FZA3JyQZjY8aadIiDrr8UT1PxIdAHjRLLjGX6SWUjigiLW/NlUUCGG1Qr7+XmFkbcWBdsSfGMRtNFGR7a2PlrLGGtG6Zu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR05MB4156.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(366004)(136003)(39860400002)(396003)(31686004)(4326008)(83380400001)(26005)(86362001)(16526019)(186003)(52116002)(478600001)(66476007)(53546011)(8676002)(6916009)(36756003)(66556008)(107886003)(956004)(6666004)(2616005)(5660300002)(8936002)(31696002)(66946007)(2906002)(54906003)(6486002)(16576012)(316002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 7UiN/aa169OWtiDw2/nKBKuKfpLxGyrA8O4ZX2S/X+SURgyiflFRDLqdjnHQ7HAU4MF3/2cxeb/V3Za9FWyN3SLchAgoqQ4j8XpMIWxiNp7fi9Zhi2sLv3zKyRh/kDIH/Z7IwOTfCU9aipa9QvIC662v/ENNyEMb4HIX1vEgGolcQ65OCdKcgG8kRDz9U3vtI+KMaxgL7uKA9sGVVqYeJIDeag4f8LR3D4Aoz/LcoMvFxpEYavrNGaxFwSNf/DeWA+YhkL13esO2GF6Eg4kDXGM8T+EViDn3kfyZ7lOLGEPQp9bGU+nBVQaxjSgEhuohj40IcJkmkNRviep+8baAt+rspqp5QBcCHXKaSCWX14QeRZ5TRA6voAcTu+PSvPtCdv1pL7aErYkq9eHJIVDGKkhrPRSyvl/u5fRBscaGhLvUBMUvIAfM0eCycabddbkT9XR4UA5T5i+iidEbDIJ68Y0+D/l4b3FqnRUHTgdCkwsblg9y6fvnlsksT1evuNEy
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c92f3612-8217-4e1e-5478-08d833bebd4d
X-MS-Exchange-CrossTenant-AuthSource: DB7PR05MB4156.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2020 12:55:58.8148
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kDWegmEsLDQ7YSLdFRYOSD/oBacaPD0JcoOicA0kjkFEtcf6ephwJOXkbtylJ8rBdbebWoMJCK3rrdOMm7m7iA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR05MB7031
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020-07-28 5:42 PM, Marcelo Ricardo Leitner wrote:
> On Tue, Jul 28, 2020 at 02:57:59PM +0300, Roi Dayan wrote:
>> On heavily loaded systems the GC can take time to go over all existing
>> conns and reset their timeout. At that time other calls like from
>> nf_conntrack_in() can call of nf_ct_is_expired() and see the conn as
>> expired. To fix this when we set the offload bit we should also reset
>> the timeout instead of counting on GC to finish first iteration over
>> all conns before the initial timeout.
>>
>> Fixes: 64ff70b80fd4 ("net/sched: act_ct: Offload established connections to flow table")
>> Signed-off-by: Roi Dayan <roid@mellanox.com>
>> Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
>> ---
>>  net/sched/act_ct.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
>> index e9f3576cbf71..650c2d78a346 100644
>> --- a/net/sched/act_ct.c
>> +++ b/net/sched/act_ct.c
>> @@ -366,6 +366,8 @@ static void tcf_ct_flow_table_add(struct tcf_ct_flow_table *ct_ft,
> 
> Extra context line:
> 	err = flow_offload_add(&ct_ft->nf_ft, entry);
>>  	if (err)
>>  		goto err_add;
>>  
>> +	nf_ct_offload_timeout(ct);
>> +
> 
> What about adding this to flow_offload_add() instead?
> It is already adjusting the flow_offload timeout there and then it
> also effective for nft.
> 

As you said, in flow_offload_add() we adjust the flow timeout.
Here we adjust the conn timeout.
So it's outside flow_offload_add() which only touch the flow struct.
I guess it's like conn offload bit is set outside here and for nft.
What do you think?

>>  	return;
>>  
>>  err_add:
>> -- 
>> 2.8.4
>>
