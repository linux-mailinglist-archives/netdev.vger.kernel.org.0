Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F05566A4C4
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 22:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbjAMVHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 16:07:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbjAMVHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 16:07:02 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2066.outbound.protection.outlook.com [40.107.94.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89A23714B8;
        Fri, 13 Jan 2023 13:07:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l7lvbuFgsXCwdTOOw8RSXBeWGkoUql8Zk1CE33pDed9e8t79W8VFXRbFY2QqmOTikEq1/RhtSJiI8QX/OAJYE6xVbZX441KVVPSzJyZgpdfsxkm1oaqsuexKDqG2nWTVl2Hu+J4lp6wEtKC4CFJhT2G3KAXSjVTN9IXLkPAdtBSSMOkevXqVEDdxZsrh1N0vr7VjOrYWdDfQMlLaxIwZ+scrkDYCTbD0GNOidFm8xG458EqcLRQhG0lEUDP3ot702BoluYOvuaXyS+DrGFpGbAJpKdhDDwIef2rz+ZicKIFtc5olZn3+I0WJyubrgdCZ9Yo8pyy4r8ftes+2DE/sJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UjMArUINWnpNAhJPpIk3//aE3ySqWicefnsFV4V4R9I=;
 b=aXIBDc3rMPthak7posdC8Xu7Jq0t60NNlgyZK+Bo66w5wIE2Ri140jjxlWF5FCRrgccsbLfDFL57A0/mUwwPMXIPAThmSKYUaDc5ykxtiPzpBQQzqJ4DC26UqnsMuLcD/lEOBwogRJ3bPXCnLGv+IO0nAjSc60AZPfJ1gSNSvBPei0KpxDgjfZzHOu8p4pgCoH5bbRXzdMh4skqRvBQw1MGeK6/tazdK5pZtx8tGGj12XHeZN9oALO7s5PiWlUvWR7pO+L3wKVZDHx1dg7gzbOnOYlIKPGDHFsPiZZ5vuIJmG4yXmCEwez3NZXiVUcN41J1AXBw6l2n8hGEOYSHgsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UjMArUINWnpNAhJPpIk3//aE3ySqWicefnsFV4V4R9I=;
 b=kZDlvbg9g5pPSRtQu8KjL5gw6VW1TlB3mc1Uo5fZZMp/tFP0obJHKbdrqBKxRCbi7IfTNzKKnPYag98XZaGTU8llTYq4mlCHcqngm0ieQaF9Un/DJTm+Eu0QYmDIN9yKZb5CFGLgqTjK5LqqIS4TcC+7y+dttUaGdSr6bGmJmlOh03mC6onN2OF5jNjG2bi7jIdk4yeIOXoump+Zg0DvxNL/CzgRK3UmGoWIMu94x2uNMBiraxlIMK/LeHysbNfikDv3sOKT2RpzpKqyXZ4h88CdNHvDqMNWs5AhWA+7LKzl7219673zTPVBOCswlmzxbFJjEwm6T9k1MqelxhETyg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by MW4PR12MB5643.namprd12.prod.outlook.com (2603:10b6:303:188::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Fri, 13 Jan
 2023 21:07:00 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::8031:8093:2f25:f2ab]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::8031:8093:2f25:f2ab%7]) with mapi id 15.20.5986.018; Fri, 13 Jan 2023
 21:06:59 +0000
From:   Rahul Rameshbabu <rrameshbabu@nvidia.com>
To:     Maxim Mikityanskiy <maxtram95@gmail.com>
Cc:     Hariprasad Kelam <hkelam@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com, sgoutham@marvell.com,
        lcherian@marvell.com, gakula@marvell.com, jerinj@marvell.com,
        sbhatta@marvell.com, Naveen Mamindlapalli <naveenm@marvell.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>
Subject: Re: [net-next PATCH 1/5] sch_htb: Allow HTB priority parameter in
 offload mode
References: <20230112173120.23312-1-hkelam@marvell.com>
        <20230112173120.23312-2-hkelam@marvell.com>
        <Y8FMWs3XKuI+t0zW@mail.gmail.com>
Date:   Fri, 13 Jan 2023 13:06:52 -0800
In-Reply-To: <Y8FMWs3XKuI+t0zW@mail.gmail.com> (Maxim Mikityanskiy's message
        of "Fri, 13 Jan 2023 14:19:38 +0200")
Message-ID: <87k01q400j.fsf@nvidia.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.1 (gnu/linux)
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0014.namprd08.prod.outlook.com
 (2603:10b6:a03:100::27) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|MW4PR12MB5643:EE_
X-MS-Office365-Filtering-Correlation-Id: 961dfa00-007f-4a96-8288-08daf5aa1c5f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HfePTsKU46uS5oYYEMgfeshB5hez8aZE9pOnOqFG2PMk0Oo+gIQJxFvRBqAgQnN94Pi7pDWYQID6li2d5ZqQ2ML9EWh4YsBvH11hqLgVrMetktOOFkizCNuHJqjaBFSxKSJrJE/I+09GVq14ilRBu/iUw0KkdvbJio5Jf9iprvbgW/FcJ1ZmTLU/vEbbvGLY0bKWHa4He9mpy4K31QO46lYCo3mGWeAY3kaE/nzL+0e9WFtd/L3soO1ZQWWlf4Zm3jgrD1d+AIhzha2iGB9/2cBziJIwltRgmyw7rRB36G3rcQ1PvDQkdUD8mb0yrbZkxAPySJvdTtRvEpG0s61NSQcn/xxYYRbTXV5kuM8/A2c7wkhYpwugPd3JkOFVkf89+CYkHj18GGQ2UNRixqzvbM7t14B6eAMf/rIvPXW7EnENTIgB0YzX9MeQq2k1r9f5pgK5htMSc+gMC6AJ1uXHXg49QG5N2P9QeO6R1TjsFP6gjMKBcC+O4tjp1Fd4y6BpIGvpjgAQHMY6Z4Ciqa7xTqLNP1wnz6WYGzLAMdHVIvoECpnBNrYVvXWQf4Cwk98i1nGYorTYKLyHUvdHXp+wn/eaeRpoTKhAtoSevBJtNqE4sibacqciJ++srwAoHRpzMy02+PHIBdYWelGtmj5tFw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(366004)(39860400002)(346002)(376002)(451199015)(6916009)(66946007)(66476007)(66556008)(8676002)(4326008)(316002)(54906003)(2906002)(8936002)(5660300002)(41300700001)(7416002)(83380400001)(36756003)(107886003)(478600001)(6486002)(6666004)(6506007)(2616005)(38100700002)(6512007)(186003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?82YKmyRJCNJXY0Cu3BxhcXBJGqoejSXCScb7ja41MPTdEGKGZwHCmYLiSMTR?=
 =?us-ascii?Q?gStDG4f09CCTCw+G3VHDQ/W5Mk2MhAYaHhz/c9JEo4V4jX73XsGPJPR8sqz/?=
 =?us-ascii?Q?7VdWt4U4Ho62P6j1l3DV6m4oODEdX5MZNz/4morbCCVot02W/j4ub/LCn8TK?=
 =?us-ascii?Q?Zal51U6osyleX+a9ByY32/74rMlPtmg3R2ujOEynTudkFzH18xAP7Yf690d2?=
 =?us-ascii?Q?YFb1gUsMofAmK6OJvvHAdUlunbG90I8JdIi5DpHC3siKEaRvLGCFcGLu+IHX?=
 =?us-ascii?Q?CCFaswNrdZfXUgWOLL4CfXQFgtrYhXWZYJqArb+dTumINUr26weFP6Qi62TL?=
 =?us-ascii?Q?seOvGCAZ3yn6hVtoSKjHaPhQYszYZoi5O5kgDnYX03gYvFBubxI2SfWeUhPN?=
 =?us-ascii?Q?9xqnNh1EVf+GPXe14+giGNewOkzH/DkfWpV3Faj5XBu+YWgng3AZKTmkWG8z?=
 =?us-ascii?Q?6gl4v5WqjhawDx6KW0wpRCE5WYNwSxS6dpRRv+9MV9RLOuIQDH1+5etXVmnZ?=
 =?us-ascii?Q?dMmtJmqhP9guO/0+bHIspuc8dH0Vgb6f7ZQie4MZlWVG7e5WTKTB8ysJZfdm?=
 =?us-ascii?Q?PSYPh3XzH3w4vL0BXqSAkBa7FKOfQleEtFUeIrxDzvCXT3qnQZdkX+EVXP+a?=
 =?us-ascii?Q?EYUcod1kU09pfamHKi+XMF2Cw1rS0rhYzRMOYh8/beemKSzpYDptP8PtYfyU?=
 =?us-ascii?Q?nBqHrHrgHe0ZTlsemA/gxiiNvah0ryEcufkmq6CEQQI1Ti4aK2qkQbm25hnR?=
 =?us-ascii?Q?qYDIRlRgeUhnKtRol/8Zw7f8bzPyHiTodo7oWjMHZ29TAdoggoCrTpeaZz8i?=
 =?us-ascii?Q?Z43XsGtCUEhmT+2F91zDgzkzfrvm0dSWBsftJlNkO9aMIRe7D2I9VLYcY0UT?=
 =?us-ascii?Q?FOKo14JNisl3qp5Xv9/3YFvE+zbj8x9eYeSDLEVz1JzpoohmayFmt2dmf+XI?=
 =?us-ascii?Q?ChgFx/d8G7onwchzlb9PXxmdopMCywS5kSBEn/LHcOjDts1sUxsjAj/DUkfP?=
 =?us-ascii?Q?z9pO1ZgprMYqLnJs0ScVFvtgQzc3AVq09yoZeNqBnBsbj4IzMkRH7ni7NN2q?=
 =?us-ascii?Q?G0yD5Cyd0n1h80WdbEm6LfEjQEhM51vwFWiO0uT8RsGrmvrE/BhKwlB+M5Ss?=
 =?us-ascii?Q?7ci6dy0MfxjA9t+9UQh0HV3jejChdziprYGQA5Ac8ZgUd7zStZ6wDxuyWYGV?=
 =?us-ascii?Q?wwVUfCrd9bZ0JSwA2tHdngSdxS5jBG4D31rizPIlcVodAUHGZ2OQWYW2M+Gy?=
 =?us-ascii?Q?4CZlZavao+7UBLzJv4c/TQAKxRk2+n++bJduIjr3bXJ0pSbaQcBw/Q9gGtl0?=
 =?us-ascii?Q?s0jMxFnNehjNU8SlYPul8jCqsG0y7m5GeasbkZOnzONtVX3ngOiG8hwc1hnS?=
 =?us-ascii?Q?LGsO0u3UKP1ISU+vl0gF2QsQAo0+DrqC+C5mIAAb+BDaWTgeDINBxxR8zvdw?=
 =?us-ascii?Q?PCnVso1ib39P+8hRBHwWRvWdqXfamNAHdEi922ctEbJFN/yXuVGuGS4leoE5?=
 =?us-ascii?Q?zkySTRUZNZWmyubaekcIg9y61wH5BRgNr2gZWQpaSSC2vjYziH26vvCqhVC0?=
 =?us-ascii?Q?JtsjIcHxDbYK4mxBMAVITr4tMY1IgrMwhBTMW11GXchRhL+OZVrlSptC6w73?=
 =?us-ascii?Q?cemMV08MUf8uhK5zSPD3VF+vthWcoesP/UmK+poq+dK4TwkaaKxcVCyN6m+1?=
 =?us-ascii?Q?3+Ca8w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 961dfa00-007f-4a96-8288-08daf5aa1c5f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 21:06:59.7800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qs8R3T866K31zi/9T6wDz6n9eZPgKi7JnOcYcrsrS1NjuwuevMod4pe1OW3FxqzLx1+Pm+YuaQIh9UqRdNblYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5643
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Jan, 2023 14:19:38 +0200 Maxim Mikityanskiy <maxtram95@gmail.com> wrote:
> On Thu, Jan 12, 2023 at 11:01:16PM +0530, Hariprasad Kelam wrote:
>> From: Naveen Mamindlapalli <naveenm@marvell.com>
>> 
>> The current implementation of HTB offload returns the EINVAL error
>> for unsupported parameters like prio and quantum. This patch removes
>> the error returning checks for 'prio' parameter and populates its
>> value to tc_htb_qopt_offload structure such that driver can use the
>> same.
>> 
>> Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
>> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
>> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
>> ---
>>  include/net/pkt_cls.h | 1 +
>>  net/sched/sch_htb.c   | 7 +++----
>>  2 files changed, 4 insertions(+), 4 deletions(-)
>> 
>> diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
>> index 4cabb32a2ad9..02afb1baf39d 100644
>> --- a/include/net/pkt_cls.h
>> +++ b/include/net/pkt_cls.h
>> @@ -864,6 +864,7 @@ struct tc_htb_qopt_offload {
>>  	u16 qid;
>>  	u64 rate;
>>  	u64 ceil;
>> +	u8 prio;
>>  };
>>  
>>  #define TC_HTB_CLASSID_ROOT U32_MAX
>> diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
>> index 2238edece1a4..f2d034cdd7bd 100644
>> --- a/net/sched/sch_htb.c
>> +++ b/net/sched/sch_htb.c
>> @@ -1806,10 +1806,6 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
>>  			NL_SET_ERR_MSG(extack, "HTB offload doesn't support the quantum parameter");
>>  			goto failure;
>>  		}
>> -		if (hopt->prio) {
>> -			NL_SET_ERR_MSG(extack, "HTB offload doesn't support the prio parameter");
>> -			goto failure;
>> -		}
>
> The check should go to mlx5e then.
>

Agreed. Also, I am wondering in general if its a good idea for the HTB
offload implementation to be dictating what parameters are and are not
supported.

	if (q->offload) {
		/* Options not supported by the offload. */
		if (hopt->rate.overhead || hopt->ceil.overhead) {
			NL_SET_ERR_MSG(extack, "HTB offload doesn't support the overhead parameter");
			goto failure;
		}
		if (hopt->rate.mpu || hopt->ceil.mpu) {
			NL_SET_ERR_MSG(extack, "HTB offload doesn't support the mpu parameter");
			goto failure;
		}
		if (hopt->quantum) {
			NL_SET_ERR_MSG(extack, "HTB offload doesn't support the quantum parameter");
			goto failure;
		}
	}

Every time a vendor introduces support for a new offload parameter,
netdevs that cannot support said parameter are affected. I think it
would be better to remove this block and expect each driver to check
what parameters are and are not supported for their offload flow.

>>  	}
>>  
>>  	/* Keeping backward compatible with rate_table based iproute2 tc */
>> @@ -1905,6 +1901,7 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
>>  					TC_HTB_CLASSID_ROOT,
>>  				.rate = max_t(u64, hopt->rate.rate, rate64),
>>  				.ceil = max_t(u64, hopt->ceil.rate, ceil64),
>> +				.prio = hopt->prio,
>>  				.extack = extack,
>>  			};
>>  			err = htb_offload(dev, &offload_opt);
>> @@ -1925,6 +1922,7 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
>>  					TC_H_MIN(parent->common.classid),
>>  				.rate = max_t(u64, hopt->rate.rate, rate64),
>>  				.ceil = max_t(u64, hopt->ceil.rate, ceil64),
>> +				.prio = hopt->prio,
>>  				.extack = extack,
>>  			};
>>  			err = htb_offload(dev, &offload_opt);
>> @@ -2010,6 +2008,7 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
>>  				.classid = cl->common.classid,
>>  				.rate = max_t(u64, hopt->rate.rate, rate64),
>>  				.ceil = max_t(u64, hopt->ceil.rate, ceil64),
>> +				.prio = hopt->prio,
>>  				.extack = extack,
>>  			};
>>  			err = htb_offload(dev, &offload_opt);
>> -- 
>> 2.17.1
>> 
