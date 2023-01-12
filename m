Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 277C26686B1
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 23:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbjALWS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 17:18:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232521AbjALWSW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 17:18:22 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3A936B5DB
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 14:10:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R4E4WO91wymUOBzdQ/7lEdlZB46ij00tEwiyCZ/NyZ3j5cVgMU3hXbgKksrNKO+0YwgupHO3FYt2UNITcHJ4J3Tx6MIdvnhuQ+ZR8NmHM4ZbkKAtUui7k1Rr37hKsM1Tsj/ihRf+BLBzgZVWFH1lnWI+nIH8cLcOVFC39bIir715/t17Ng4+Lvu2u2csPpoje6hWcvO4sUnVty24k8x7BS/Z/1xyxmV9Z6qP//TGZnbMdTQ4cfgUqz3WXdyYNLq5ZOfiQQzOJtGGNYLAecQV0n7IKTEI3Ng+uYzKfbMQuttKokbk6zfoVVHo8tajnqz9MuuTWYYUnM6/Gq8RagJrKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NAdmeIT7nl0AA6UONsTd9HUml3H/lYIcISxACklypts=;
 b=YwkTU3aNVk5ux59BJyL5IhajAZDulEqk0k70TbVljSQ2xFCJ5RbyZXAHQOKtLf3uIeY/0AdG3/3I388MaPUnw+/pc4asW8uQ3t+wFeBslR8kFmCrCJ2cfDzXWOsx4XQzbEG3Iqt2A68qjsFXNEHSa0qow2mTklJsBmhWbdQd+hPQX+bfCWgQv4BvqpA9rCWJyR/J6J5YrFS0XE0iaMSCcu0PmE731wvTUfliJk+AQf49tdm3ZAAVDeyLuRw+w++zLCpdI8gWoqcGwe38wFFg7vg/xjUiPkTt3pwoa1pMHtOGcojRKEqXUBdqiiaXLgjn0P3csU6Qb8gp8JRe1/sBsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NAdmeIT7nl0AA6UONsTd9HUml3H/lYIcISxACklypts=;
 b=J/MmsTz/qPxbh+KkZ2g9VGXwfjKZkK7VvBpw1Z1qpWR0jP7ra7PPXzoGP02+JXgV03ZR8NcatHhLdElnYBohJvxzItDict13joVzkxUq5ompFxM88Vvr+otLaiHSNmmADF9L7R6N3nXJcS75gkg5OcCVa2EqXj9BQFmEV7a6yhOLmTekc+TH6aHk4scvbyCiqrtJSUCtn61vF1+Klyfx+yaH0FPtOqrDx3rcvFpra3mqG9dai4O6zEGobFD8/NLsjUpoiJaBQfJ5INjaX1KDk9EvW/8S8J0Sl3TwIL9bbWmczmuj++6cpW59o86Owjx0Zmnka3XK16h56RWOmRpJxA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by IA1PR12MB7687.namprd12.prod.outlook.com (2603:10b6:208:421::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Thu, 12 Jan
 2023 22:10:15 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::8031:8093:2f25:f2ab]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::8031:8093:2f25:f2ab%7]) with mapi id 15.20.5986.018; Thu, 12 Jan 2023
 22:10:15 +0000
From:   Rahul Rameshbabu <rrameshbabu@nvidia.com>
To:     Maxim Mikityanskiy <maxtram95@gmail.com>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net v2] sch_htb: Avoid grafting on
 htb_destroy_class_offload when destroying htb
References: <20230111203732.51363-1-rrameshbabu@nvidia.com>
        <Y7/8rXHmchlG2qqE@mail.gmail.com>
Date:   Thu, 12 Jan 2023 14:10:01 -0800
In-Reply-To: <Y7/8rXHmchlG2qqE@mail.gmail.com> (Maxim Mikityanskiy's message
        of "Thu, 12 Jan 2023 14:27:25 +0200")
Message-ID: <87v8lbtneu.fsf@nvidia.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.1 (gnu/linux)
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0121.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::6) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|IA1PR12MB7687:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ad26a85-2a59-4468-7893-08daf4e9c828
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oo7sBVO7GQ8sW8YqYkC159W0ZWwrFNiMDq3EMXFpRwejkUxMlIqzEUYyIvAFXamS/axUsbcki5QM8iEbfdCR9gvnkZDs34/ggqvgL3Vs7Up42zTWq3GUaHeVyNZIv352THeNJ1xK3xVPX+UkW/gIsiBxNoXNwUhPE6oMN1ixNhSBnqeac+AeMDzqM/zPT7RBcaornrguh2TmPC5AgN8ClMyJumBDdGSP9yWcGyuSRZK+i+hbd/cLaikSsq2DblQc4L+yN8RP9LjrhCnFBEqTCi1cpzumqW0xx4/wdGL8L7gTGravkmj7otx4uDIvjVDs4oihBQf3bjul0hSiAHvfZJXw1AZo7RjbadgSa/RzmjXNW9EwZPK2VpaebmD6rPwad5k9/jKg3KpOYHFyU3n5bPirTfpkNT5NV77VPTJgyo9dIbTWnCW+EeL1iGoRxjqY62se8BYB2UQfC4icHGfbzuKq7OE1MIpsyKXsUJU6yhWh9uVti9BguPAZFFfGt7eVYLNhxYW22lF8qhT918jdGEy3jdVuybeYjYglFwqWl8kf4+BZrgB5ONjjP3SeTYHfbmJ/h8rXDCHkFy3XUadDq8ovb9d5mraVgPPSu2Q0VKHbETPhPCGbgUQeuRg6+dhGG5h/nunqkHd74mEw4ywrCHWP3Gs5sxktbe3T5Fi8QUT/ZM+sb4R71Ed6saXQ4gahYNb2bBQKEd7f6B1jtQBZgvXNNqPZJOo7iyfVngwTxw8errgXkFJo7L8IUfDSSbALRFOn7zNdSt6/gBdW0terdA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(376002)(396003)(39860400002)(366004)(451199015)(41300700001)(4326008)(2616005)(8676002)(83380400001)(66946007)(6916009)(54906003)(36756003)(66476007)(316002)(66556008)(86362001)(5660300002)(8936002)(38100700002)(2906002)(6506007)(6486002)(966005)(6512007)(6666004)(478600001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T5YE32JMXiBwtCgopRsjmICcdATjC+j8jcJBVSRV2S+qNCr+9MVhf+v97BBV?=
 =?us-ascii?Q?/orjf4KjkeNcEjN+KaAI0wCkiUJxz4SgPHvHsVtbmB2dd5y51Uzttu1saUIo?=
 =?us-ascii?Q?UMqyL7Upo6uGWetVEHHwzdOjp5p5Q0pXjQItpyfGhitid0CYY/pl9stCnRus?=
 =?us-ascii?Q?BpRxIRmNaGUyyWIgjSf5TF9K/hFXA3emlPaaz5hpu8alw9/kc6CpzV+QaTKx?=
 =?us-ascii?Q?L4WOlDXzynraL5wBHZ6aw5C7qfqvc3vIJo6y2SHGgzlkZKxWt2exXKZkC56C?=
 =?us-ascii?Q?eEXnNDhQC9pQT/nBj267/vw41ADoH1p9nBbMd5LdmeuDe7kW4KpEJRpXyRhH?=
 =?us-ascii?Q?9LRQec7iAhopZGQuof+kiRGeQ+2T87XIr64bkHO2YtFcT4Lv1wZLlk1xTLb/?=
 =?us-ascii?Q?VJUkrp9ArNY47VHkEiccIEBpobRZm0SquGO8Uf6GAHzudLu5GJEKMxosf/uS?=
 =?us-ascii?Q?7MH9tY78HgpF3bYxZVvXYQaT8LUEY0UfDlT8MGrKzLx37A56RHamFxgOViNV?=
 =?us-ascii?Q?MGxP0F8pXOt/1folNLYN1FWNfGR1Xgn2lXlNBFlQuDNPb6kTb7m7ogSr0zWe?=
 =?us-ascii?Q?tjKDuZ8T1pMplnWs5tYUjzM0x7fvaBsF/JNXjw76XxosoaEyqgM/+QWKFGMy?=
 =?us-ascii?Q?xXKDu2Sw+JxozeXYk7qtT2kotGUDqNt8XFhRyDVBI12WP866M6XeSjGgGMFN?=
 =?us-ascii?Q?7lIA+HYmZwbj9ZPgZqglLtNw/a0Tym0Q1xI8PEHLgABPlXcedNrr0cR/8Iym?=
 =?us-ascii?Q?1RVDeTQl3Gu/lqpDIJUXqZwBWPhX1VyTPXB2qnS9NYyVGip0QgpE0HQVbpuu?=
 =?us-ascii?Q?tWyl/X7qQqO7ZzOdWbnd4MOiLFpF7vXOiXLmuroyCCNQRJ3Dw/axTBaQSV8Q?=
 =?us-ascii?Q?MB79aFEtzTx4Llsuu8Xi8kLZ/v9fFM5ycxW7V9nKMGVOXFf2Sw94jYl9Q76Q?=
 =?us-ascii?Q?juM8GGfWgU2wmrN9fezidGD29Sie+CLnrbCL5U9K7vIKOu9PYWisRoHfXTNi?=
 =?us-ascii?Q?ECzf8hooI7XImKeiLw2NkFSAOvyxX4FDRc8Ei0iGktln2w5fR0S0jotJv6y7?=
 =?us-ascii?Q?DbDL8+7YdpWioN1RdexeOXUkico46Fjiwgh2b40XMsHg2IluvlJ6vVY12IHh?=
 =?us-ascii?Q?DVlhVm3BWa7GVAmvfBQXIXsZY8skO86ymoM0Ecq1NLZXct8HPicPZ3jQ3F8O?=
 =?us-ascii?Q?+k/S6/XS3PvK3/0nv5dYFWzONMt443fck6wEh8hy+oOwa+lvrmwze67x1RYp?=
 =?us-ascii?Q?hAR0aAGRK5lmc8D0sGF6S2X0YWW5VQboD56mI0guxRNi9Axayp9m00MpJKuA?=
 =?us-ascii?Q?4dKEgev64uwkGkJ6jAiyCSTvbfLEwjY7K9r52fuXGEtWcOnpXnx6+uZBr1v/?=
 =?us-ascii?Q?2DHpCZ9A0L2wYyZbACzs96nrPvsrNHHaIN7plvohLJWVxgyp+51CW9ShoO8h?=
 =?us-ascii?Q?uxqTZwHgD3NWU+Y5o6YUg7NVcpe+QB0mCV049Y1oPLtHeoj+wiJMExwixLnd?=
 =?us-ascii?Q?LzzNDS38gZJHqSAOmkbjDOuNhkChgeevcxT0hGnCh4duXOsmW3uyzIjt2r/c?=
 =?us-ascii?Q?vAo59j36JDzJQLj2bS6aG3FP08bmw67/Oa5bY8RUFkgHTHeJJQayL6eLE+jp?=
 =?us-ascii?Q?HdZpzpP4N9VKybtwOPmsVj8Nj1NR1YqR1bHmCKTZ8M6fq0rwNV7Zle0xaXc/?=
 =?us-ascii?Q?BKRC7w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ad26a85-2a59-4468-7893-08daf4e9c828
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 22:10:15.0874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nt+IJilSyZj9+QFC1gFG/tXoCQOSF9NqffVQvih2NwKag71KMSGFqoIEDFJibuwhxrcF9XJlCHjLl/xGnACP6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7687
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maxim Mikityanskiy <maxtram95@gmail.com> writes:

> On Wed, Jan 11, 2023 at 12:37:33PM -0800, Rahul Rameshbabu wrote:
>> When destroying the htb, the caller may already have grafted a new qdisc
>> that is not part of the htb structure being destroyed.
>> htb_destroy_class_offload should not peek at the qdisc of the netdev queue.
>> Peek at old qdisc and graft only when deleting a leaf class in the htb,
>> rather than when deleting the htb itself.
>> 
>> This fix resolves two use cases.
>> 
>>   1. Using tc to destroy the htb.
>>   2. Using tc to replace the htb with another qdisc (which also leads to
>>      the htb being destroyed).
>
> Please elaborate in the commit message what exactly was broken in these
> cases, i.e. premature dev_activate in both cases, and also accidental
> overwriting of the qdisc in case 2.

Ack.

>
>> 
>> Fixes: d03b195b5aa0 ("sch_htb: Hierarchical QoS hardware offload")
>> Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
>> Cc: Eric Dumazet <edumazet@google.com>
>> Cc: Maxim Mikityanskiy <maxtram95@gmail.com>
>> ---
>>  net/sched/sch_htb.c | 23 +++++++++++++----------
>>  1 file changed, 13 insertions(+), 10 deletions(-)
>> 
>> diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
>> index 2238edece1a4..360ce8616fd2 100644
>> --- a/net/sched/sch_htb.c
>> +++ b/net/sched/sch_htb.c
>> @@ -1557,14 +1557,13 @@ static int htb_destroy_class_offload(struct Qdisc *sch, struct htb_class *cl,
>>  
>>  	WARN_ON(!q);
>>  	dev_queue = htb_offload_get_queue(cl);
>> -	old = htb_graft_helper(dev_queue, NULL);
>> -	if (destroying)
>> -		/* Before HTB is destroyed, the kernel grafts noop_qdisc to
>> -		 * all queues.
>> +	if (!destroying) {
>> +		old = htb_graft_helper(dev_queue, NULL);
>> +		/* Last qdisc grafted should be the same as cl->leaf.q when
>> +		 * calling htb_destroy
>
> Did you mean "when calling htb_delete"?
>
> Worth also commenting that on destroying, graft is done by qdisc_graft,
> and the latter also qdisc_puts the old one. Just to explain why we skip
> steps on destroying.
>

Yes, I did mean htb_delete. Ack.

>>  		 */
>> -		WARN_ON(!(old->flags & TCQ_F_BUILTIN));
>> -	else
>>  		WARN_ON(old != q);
>> +	}
>>  
>>  	if (cl->parent) {
>>  		_bstats_update(&cl->parent->bstats_bias,
>> @@ -1581,10 +1580,14 @@ static int htb_destroy_class_offload(struct Qdisc *sch, struct htb_class *cl,
>>  	};
>>  	err = htb_offload(qdisc_dev(sch), &offload_opt);
>>  
>> -	if (!err || destroying)
>> -		qdisc_put(old);
>> -	else
>> -		htb_graft_helper(dev_queue, old);
>> +	/* htb_offload related errors when destroying cannot be handled */
>> +	WARN_ON(err && destroying);
>
> Not sure whether we want to WARN on this error...
>
> On destroying, we call htb_offload with TC_HTB_LEAF_DEL_LAST_FORCE,
> which makes the mlx5e driver proceed with deleting the node even if it
> failed to create a replacement node. Normally it cancels the deletion to
> keep the integrity of hardware structures, but on htb_destroy it doesn't
> matter, because everything is going to be torn down anyway. An error is
> still returned by the driver, but it's safe to ignore it, not worth a
> WARN at all.

I see. This makes sense to me.

>
> Another error flow, when the firmware command to delete a node fails for
> some reason, doesn't even lead to returning an error, because the worst
> that happens is a leak of hardware resources, and we can't do anything
> meaningful about it at that stage.

This was what I was trying to catch with the WARN_ON, with the hope that
at worst it wouldn't have any false positives. However, if there are
errors due to certain operation modes like TC_HTB_LEAF_DEL_LAST_FORCE
where the htb is still destroyed, this WARN_ON seems to be problematic
more than helpful. Will remove in my next revision.

>
> So, I don't think this WARN_ON is helpful, unless you also want to
> change the way mlx5e returns errors.
>
>> +	if (!destroying) {
>> +		if (!err)
>> +			qdisc_put(old);
>> +		else
>> +			htb_graft_helper(dev_queue, old);
>> +	}
>
> Looks good. I also suggest removing NULL-initialization of old to make
> sure one will get a compiler warning about an uninitialized variable if
> one changes the code in the future and accidentally uses old in the
> destroying flow.

Ack.

>
>>  
>>  	if (last_child)
>>  		return err;
>> -- 
>> 2.36.2
>> 
>> Previous related discussions
>> 
>> [1] https://lore.kernel.org/netdev/20230110202003.25452-1-rrameshbabu@nvidia.com/
>> [2] https://lore.kernel.org/netdev/20230104174744.22280-1-rrameshbabu@nvidia.com/
>> [3] https://lore.kernel.org/all/CANn89iJSsFPBp5dYm3y6Jbbpuwbb9P+X3gmqk6zow0VWgx1Q-A@mail.gmail.com/
