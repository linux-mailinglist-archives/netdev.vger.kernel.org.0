Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC6F823A035
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 09:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725884AbgHCHWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 03:22:40 -0400
Received: from mail-eopbgr50072.outbound.protection.outlook.com ([40.107.5.72]:18333
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725270AbgHCHWk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 03:22:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZFtTb4T9j/hpoZ5uai6ImZxmD198G109yF+XnYMC0D1WHx/4UW6b2FO/861xmBSqKE2c4AiSMb7qzXF/d/Zgoxvh9OMkbZpXO69p7ZgQSjk5vUHMX+jz7XVssEXQ5x4MNI4u5O3giCHBSwcTBQfqc9G21Yt8KbnMZp3kDmAiHLSezhJ7SkoVAldv9vdh/HsQOVIP3i2wlyNguMA6G++tZZiIVuDl+JyC3ZSL7fHZQ6yt6iC11K8vcMF7yi9BXNugw86+J/k9BJkLJmR0wy2EokbV0svjBSUQft9yHuI3X1kNM4Ik27gZlH0uXzwf5/VcieMC8t9xCvN2rJHPKFHakA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fqhHSqjFZHAiHyRv9w1GY5it/g/iMwfASPyCwZeHD6c=;
 b=e3UAdL0x7nF4XRn1xu7chJR6sIMfXThseCvJHrPPM0OluRgBjyuLS+bfpymM1OQtPxXFFO++bySWGSL3ap+BUFqDuxgLvtbZRRnV8wVZWwJXx+45AJ0ToACnQbOds2aOa+o8E/xBle3YqCdsfypVqxqaXQMCvqZ2pYUQpHqKnZ6frzwpEfOkSKLD5JpOh4UqtDyVvHrXhY6cOsfcZONBvpj44mXnXdJEbWgG1LC9zZRRnisMt1kjNvTX5ppXxXGgh/70Ss1Tn9A/CHHYehvbzaLm/3mQAZrYYfFNB0SUqBpCleUj9ikau/c+0GXIX4US3IBYHp1ASTqwYAxEMw4u9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fqhHSqjFZHAiHyRv9w1GY5it/g/iMwfASPyCwZeHD6c=;
 b=jsDgve5oEgYtWNDr2mqlHHufi2kiD6Mrr5DNpVs14MFX4BBr4eYA3DnHGTEmgpvpDSwbFANnV/qrBX9d/Td3qaSq3CJi9IPYNdZtwHs0xdent//l0vbxWujlRtTa8yLaLfGaUR/RJ4p3LDoYkO9itaUNNd6yJXYNqexr9K9n5To=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from DB7PR05MB4156.eurprd05.prod.outlook.com (2603:10a6:5:18::21) by
 DB7PR05MB5803.eurprd05.prod.outlook.com (2603:10a6:10:8f::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3239.20; Mon, 3 Aug 2020 07:22:36 +0000
Received: from DB7PR05MB4156.eurprd05.prod.outlook.com
 ([fe80::84:f8d2:972:d110]) by DB7PR05MB4156.eurprd05.prod.outlook.com
 ([fe80::84:f8d2:972:d110%7]) with mapi id 15.20.3239.021; Mon, 3 Aug 2020
 07:22:35 +0000
Subject: Re: [PATCH net 2/2] net/sched: act_ct: Set offload timeout when
 setting the offload bit
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     netdev@vger.kernel.org, pablo@netfilter.org,
        Paul Blakey <paulb@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>
References: <20200728115759.426667-1-roid@mellanox.com>
 <20200728115759.426667-3-roid@mellanox.com>
 <20200728144249.GC3398@localhost.localdomain>
 <c33a4437-8a7d-10fe-7020-94cec26d5aca@mellanox.com>
 <20200729171044.GI3307@localhost.localdomain>
From:   Roi Dayan <roid@mellanox.com>
Message-ID: <a865491c-70c9-c87a-9e8e-fd3db380e0a8@mellanox.com>
Date:   Mon, 3 Aug 2020 10:21:21 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200729171044.GI3307@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0P190CA0028.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::38) To DB7PR05MB4156.eurprd05.prod.outlook.com
 (2603:10a6:5:18::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.170] (176.231.115.41) by AM0P190CA0028.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:190::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17 via Frontend Transport; Mon, 3 Aug 2020 07:22:34 +0000
X-Originating-IP: [176.231.115.41]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 50d5c5c6-da0f-4485-55c5-08d8377dfeb3
X-MS-TrafficTypeDiagnostic: DB7PR05MB5803:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR05MB58031160534A336A73871FCAB54D0@DB7PR05MB5803.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: En6lyzBGc24BLHiquOOxDfCfaKTsPxvzYsUTdu0mvnCbwbsksNFD3Ehk4eZgZeW7A1YfuhhRneYzZUTCwJ1voWbmKyBiSJ+nCzklFM9dvh8QlYwkReAafm4oN0wGHWRmGHzp1GLmkojB4y0uZIdMblRd3IkOObMJirLnlTGQwErVl/Ee8Q6h5VN/8M7u6q9Dz2fceCc16YECM+qmxWfT/s0Vg6GbZF+yR3T1jQ4xEaatoM4S85nBeLwFHkwL3SosHbSy5Jon8AbYmPL7q/iMpJfkOWuYVSlTa4Km4qkkIvr7eFkVfDub3CN8/+dUsaU3DHx4zDDwXcs6lQ//mzUnAVkwoJn/T6ORV/DqoZ6sNjO7o6hKWWHkzQE/srufXQyQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR05MB4156.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(396003)(39860400002)(366004)(136003)(66946007)(31696002)(6486002)(86362001)(6916009)(66556008)(66476007)(53546011)(16576012)(316002)(16526019)(8676002)(186003)(2906002)(26005)(8936002)(36756003)(107886003)(2616005)(956004)(83380400001)(54906003)(52116002)(478600001)(6666004)(31686004)(4326008)(5660300002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: EDW0vIQd4AxztTqxTa1T+3xVJhtz0ZkV7Rl9eyUzc0C+UPbo6AO1l6zkQTFp3R8SKsncfRq1/x6c/x53OrBhz+bWyAbThE/oPjGrtJx9R5VIUXatN3WDN+RQWg7OF9cHLeIeePDkTZL3+gelD3wk9RtLYDBIzWLh7hADxdh2I/DOLYfgfggsxXKXnRgK2NF9POUN7nrujGLPxNCBXT90VHsG+41HuvOwq5qO6MAQpiO+hb56mLHSvQdV3qyckXVDQqBdih8drfVNUB9lis7uerkgQzkrDDea7zPPtRAqtc6S54+1Xdan5RGW7TBmUgh4wV8S4h73Xx5O5venaBwUTAIMeG+ll2KFzpq0P3UpMrgZgY9/InBzLbI9ZqaatzGlXOYhDDAdDwFZX8CzhIKsqMpvwByQZ1gOwHNf7T82s+8dg/JYZLN6f2HWBeOFFsW4zVkh5j0XJclMZ28LUT9tYnzmMV4VdClJnor0ODQK1wHa7uXkWY/5bQ7fJ6TjSrMwBWsNRqQX6BCd//0ISXhhaAg7MdO51mHlVOfstMQIQy4qynnUHQCef6tphs5I+SvmPQqoiC3TCtWbO7STVhRPIfxU/zfHFPI0zlN/VQxqeawjuuiiJCvp/DX5VgeC4dpUL2D2fkBBr8jbU9jOg9XdlQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50d5c5c6-da0f-4485-55c5-08d8377dfeb3
X-MS-Exchange-CrossTenant-AuthSource: DB7PR05MB4156.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2020 07:22:35.8789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /zlC8Vvx1HkPCPyeCyZ/wmJiq4W+Zs86d7k/SN70BiYN9TpqYIWzljgvCnNpMiavjIvwYkQ/R6xUkKQeIBRyMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR05MB5803
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020-07-29 8:10 PM, Marcelo Ricardo Leitner wrote:
> On Wed, Jul 29, 2020 at 03:55:53PM +0300, Roi Dayan wrote:
>>
>>
>> On 2020-07-28 5:42 PM, Marcelo Ricardo Leitner wrote:
>>> On Tue, Jul 28, 2020 at 02:57:59PM +0300, Roi Dayan wrote:
>>>> On heavily loaded systems the GC can take time to go over all existing
>>>> conns and reset their timeout. At that time other calls like from
>>>> nf_conntrack_in() can call of nf_ct_is_expired() and see the conn as
>>>> expired. To fix this when we set the offload bit we should also reset
>>>> the timeout instead of counting on GC to finish first iteration over
>>>> all conns before the initial timeout.
>>>>
>>>> Fixes: 64ff70b80fd4 ("net/sched: act_ct: Offload established connections to flow table")
>>>> Signed-off-by: Roi Dayan <roid@mellanox.com>
>>>> Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
>>>> ---
>>>>  net/sched/act_ct.c | 2 ++
>>>>  1 file changed, 2 insertions(+)
>>>>
>>>> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
>>>> index e9f3576cbf71..650c2d78a346 100644
>>>> --- a/net/sched/act_ct.c
>>>> +++ b/net/sched/act_ct.c
>>>> @@ -366,6 +366,8 @@ static void tcf_ct_flow_table_add(struct tcf_ct_flow_table *ct_ft,
>>>
>>> Extra context line:
>>> 	err = flow_offload_add(&ct_ft->nf_ft, entry);
>>>>  	if (err)
>>>>  		goto err_add;
>>>>  
>>>> +	nf_ct_offload_timeout(ct);
>>>> +
>>>
>>> What about adding this to flow_offload_add() instead?
>>> It is already adjusting the flow_offload timeout there and then it
>>> also effective for nft.
>>>
>>
>> As you said, in flow_offload_add() we adjust the flow timeout.
>> Here we adjust the conn timeout.
>> So it's outside flow_offload_add() which only touch the flow struct.
>> I guess it's like conn offload bit is set outside here and for nft.
> 
> Right, but
> 
>> What do you think?
> 
> I don't see why it can't update both. flow_offload_fixup_ct_timeout(),
> called by flow_offload_del(), is updating ct->timeout already. It
> looks consistent to me to update it in _add as well then. 
> 

I don't mind. just add is not consistent with del.
del also clears the ips_offload_bit but add doesn't add it.
i'll send v2 with your suggestion.

>>
>>>>  	return;
>>>>  
>>>>  err_add:
>>>> -- 
>>>> 2.8.4
>>>>
