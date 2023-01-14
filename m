Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C441466A89A
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 03:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbjANCTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 21:19:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231451AbjANCSz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 21:18:55 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2069.outbound.protection.outlook.com [40.107.223.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 749A38BF0B;
        Fri, 13 Jan 2023 18:18:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e5gd2PPLzFnfdYn4T1/FcWNE8bEFsXbnno5PdSH6vDkdAiTrbxBzowdpeZcs8PgvgTnZCYuToJWYEMteuJyz/tzf9vLdVQMw/kbrgzhfYah0FRcEkeKAssK5/u9ZZGJQzQ7zIW7o+NIqc1wX6vWuhyblcyD2ChNMWs80zUzlk9rwg1XPPMH8HKnnA9jN98mu7SNIaxXud7ZkBj7w1t2YBFTJD2EcDsgOUGcfN8xC/3UOHu7lmMHLoMtNUragWGBNB6iFlNvW9eL9QynOXBVRJFp2HR15NgnJsxv6Vmu0jnIkauiL03OLvnvuh/OIoZEtimy9FBkAdcOtDNv4CLL0vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wco5Vs9pqoK/Vt2mHx5mEy34QK6MTVlY1flCRaFqZ6o=;
 b=PXoKFC6uRQdmrcrIWuRk18GDMcHceWfSP49efh7n2nQdhaS4bqo6+MRIKQjW4Y6Df0kSUJo9gU/XxGg9VuVmG1idCKrFCmZkalGjr+yEhLlDZUjNNHfdJCkl5brh7+vFCb/6AdGRTEj0fx33nE88PO2qOm7zslk0lASDU5cx9g2nXjGCwZQUn8kj6yxu7bwb7iQZ+hbFCJ1Q3gvdVO4zgT89+tkWbuplytLWuycBEbgO4yG7rheBv33b7mIWOCaswBILs6iyQUWHdTERVX7e/BZex2iY7+McTaudXNFec3NicHJq6zMJq3x9Uzd/XXvubCSgtEMekd1ttPHp43zHyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wco5Vs9pqoK/Vt2mHx5mEy34QK6MTVlY1flCRaFqZ6o=;
 b=Vfo9sUFV/CLXz0eFkAllXZvA2k5w6TUIg7KgdTuLqqq5frSIZKpiOAoShiSMz9ug5JJekNvuslcsI3tBFcdWcqKXKs4WW6Vtp1jILKQEBl+VDviLw9tg9IdAfjtEHMpbeu63Zlo8nvOQM//eiH7MUa897KZ5uznJPk5Ka8/CcG1XURpAwPkYegFBXSkkWPpXqbbWaiImdnVB6G6rc7UhduLZ6wTihxo+lTPe804xoNwY99tXIQpgfI5Qj+baZHXsStU54khxFuVn6noQCoewvVv0NlPe6JZd7Fi5vTi/YugQ623Sn7vC0sBuPwQ0RXJmGVVNTh2V8NVQAkBFc/to1A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by BL1PR12MB5255.namprd12.prod.outlook.com (2603:10b6:208:315::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Sat, 14 Jan
 2023 02:18:49 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::8031:8093:2f25:f2ab]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::8031:8093:2f25:f2ab%7]) with mapi id 15.20.5986.018; Sat, 14 Jan 2023
 02:18:49 +0000
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
        <Y8FMWs3XKuI+t0zW@mail.gmail.com> <87k01q400j.fsf@nvidia.com>
        <Y8IKTP1hf21oLYvL@mail.gmail.com>
Date:   Fri, 13 Jan 2023 18:18:37 -0800
In-Reply-To: <Y8IKTP1hf21oLYvL@mail.gmail.com> (Maxim Mikityanskiy's message
        of "Sat, 14 Jan 2023 03:50:04 +0200")
Message-ID: <87fscd505e.fsf@nvidia.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.1 (gnu/linux)
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0175.namprd03.prod.outlook.com
 (2603:10b6:a03:338::30) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|BL1PR12MB5255:EE_
X-MS-Office365-Filtering-Correlation-Id: 9eb7bce2-ff23-4fcb-265a-08daf5d5ac11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3bXn7RMoYa8UD9gx7l6APikiIzpAFYO0lYXikNO/p4cLsdO7I5uLfAJWikiIFIbxOvjGqi/3DDUNtW8kJdo0WaL1RGYycUJ6Ros+YkbP2dZDgs/5z44yuRBn9fRyKn4JgoY8fLHeDyLy5VVTuR4AHbT1MkUW/RW8Pm3YfiXPaW84YSJrqL3/caNOiFEYYSeqZYYqK+hWHnajxT4OOG39k1t+kFcfLPNXIl33IzkCjcTs4mn8GblO9cQt5CLoI/3VDOnSVspinetVUz1BmIifPRfCzLjGwvWrYYYkgaSj0MyqEG8uGDSLMYnmt7TBadpkYHFFXZK6cFNiV4xXndgRJEDEO7YEpVD9B6V1O1olQfG5hNyqdrluc1bp7TYoaIyrMg9jcP3IDXs1dP2TBFi/dpiRaPEr9RXQmwG6VBLvMoTX6TxynGphtHUGE90jkC/jOe6mRZQs+aYYKbTkkUjl4Ard3vmHEPmTxzoPXcPEmbGzI6E7knBIbxN7AwxGhY0nTCJFHoe4AU63Mbx7xlkpir8sRvvYtC2dG6MywH9oTqUxat68bfSMOYIvjEwWXduwBaJShXYWXNbae0gGPoYCk6yctCkO5AK4vtYOwNg7hwJjSxEjtfmmw0MBnB44Ynxlz4HT53e9gE71xP03EQfds424gtrZDTuxjPQEwmkCnHHTElnzLnrAK89NM6namYNMjfAUClQxhfi8O0dy9q4hyGoaBY5GFD4Wam+NAypBfdtkZT9G+JaQAIpe1F8CF77VayOAxCQYvXxZWJHHUn8gkA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(366004)(346002)(136003)(396003)(451199015)(4326008)(41300700001)(6486002)(966005)(38100700002)(478600001)(54906003)(2616005)(316002)(66946007)(86362001)(186003)(8676002)(6666004)(6916009)(6506007)(7416002)(107886003)(5660300002)(2906002)(83380400001)(66556008)(66476007)(6512007)(36756003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UMGA8B3LFUZxHjvv6FGoYeG5gUh6xUA09L9pAX6gwZOggoJfTZPbvCpJpX0R?=
 =?us-ascii?Q?rbfvscdEryzch3ZV62+uUhiv7Tn6ZLbpkRl7OyJ5jvwcoSNwUf2NsQZYB/po?=
 =?us-ascii?Q?gGUgsqIbFY0E/dZ61tOjQNvY3TZIgSsun+dSWph5i06nQtESQB7YQQ98cRFt?=
 =?us-ascii?Q?IeL1dE4KdCnSDd3UtEcihbkNakM1Nh1wsYOVpTu07Zpdbs5VWXpGcSQB7Jjw?=
 =?us-ascii?Q?htd8WhoYv/2Pr/Im6Ia+Uvk+3E0IAn+rTUmjqSxjVZLD+i/GGgUe5st5i5iY?=
 =?us-ascii?Q?voCmHzlBwz0Sg+8Q/koHeK4t1EBYHLzGfgn/uNJa4Thl9aU2iBN7R0Yzlkgd?=
 =?us-ascii?Q?oCyFcNdainPy0xVNdgNUbrlMauvHY7gcdcMzzmOUVvhHpiPtBp24RtV+dwHI?=
 =?us-ascii?Q?JRHPZT/BhS8xCevtMHEVFL9DEPMBzq1InJsqzIk1E3MWL5r52CI0X3mn4AlB?=
 =?us-ascii?Q?7bvTLHzBdJkZe68DEV+3QcWxgdY3AAZtD7aae+6CtLlx6kduxxY0AGImjMQK?=
 =?us-ascii?Q?AfhKxdEbaFy094viyIfsedMpsN+x6DepmJsUbkMQOcyYZbzKJfwzcpjfCzCp?=
 =?us-ascii?Q?YeUOtQiGeYL3p0zaJagiTCVsfsj9+BmGRiYQ1JYw7Igay+8UKUto3yHEvnk3?=
 =?us-ascii?Q?sWs4hnM1YkdLsn8RklVEqDxj4wygQq8mT2p/ugnM3MpGaNtBUxxg+lgMN7YC?=
 =?us-ascii?Q?bB112rGZdZw802yO6BZk3GQPiIBJ+vLPbMsu2ygHHGo8hNGpcV1RuSGLgc98?=
 =?us-ascii?Q?9v0RrF32z2eKN2BnB3G/PIq0oTL2vRA9ILhgUxIQWztr3lpFcYlOMaSkai4r?=
 =?us-ascii?Q?/J3ynrQvUIdeYUnMyiejalJuX4qBBKFMzeT/GhLEjFcH7yrE7csKoVg7S9Bn?=
 =?us-ascii?Q?mi/MxG3FTsD4v1iPAMlcBwNm4hdKJWuHwdeo61gzYTLKIiQC5wGmzNeS0vug?=
 =?us-ascii?Q?LrADS9CE43pjdSk6Ln2elrT6QOSrIvhsycwEiH0dIM/eYTJ1Ei2huv0fMY3R?=
 =?us-ascii?Q?3AiEVoCWbkCKahp8NaUIL4qOlRhkI7z0aVn7OQhYZv1+xNDFirxhjdC3QUQs?=
 =?us-ascii?Q?88WV8rmJRfW/1Y/etdHqHYTeqEAPzAoAuaI4JLAU0W67FIAmvxtcNuaDc1ts?=
 =?us-ascii?Q?a7jCNsGHT9ApIY3Il9TXO5/ioUiBgfMUIEvxLG+6vHbqQTsZo6kejxNbVQZE?=
 =?us-ascii?Q?2y6kcq/6OT8XVcfpkM+EPVJVWZnDNowBlV6WwyGOuOQwQpNiezKV3W6ok7dQ?=
 =?us-ascii?Q?7lpGznY5TPjT2n/Fib1uB0gLEd5YSVkVTrDOjeMkbshBbsORFFqfkMq0d85D?=
 =?us-ascii?Q?F173lgS0uqx0JiPov8w3Cstz2GNzCEkk+tX1HxRqA9ZMkC96xb4DGtScWiFI?=
 =?us-ascii?Q?xa9dFollAv+7yWEP+AZkTo6Ejm9hc2aHvSLd/RUwB9sBM7Wo7bi+wfSs5bWB?=
 =?us-ascii?Q?5NPNRexkNFIdHLGwnzXb0x+okTfn1Aypoas1+9i/6kHGfIiosFk+zI0YqkXP?=
 =?us-ascii?Q?NLC/lt+l9ao6G4w0o26ENSXyJkTXjMGmQvhZiXhP5fp/Q0ZEY99JGlbdWkyi?=
 =?us-ascii?Q?+tPCJipqFD76dxJC/ijEbbEZ0zqW2t8+HZ38Wi+C3z71FIqjOXXnrk+7/Alg?=
 =?us-ascii?Q?k/jbkUSsvaJwlddZbiW/PQF/GngVVXQoruHSMYgz4TZSQiVTLF4Lc5gg43ql?=
 =?us-ascii?Q?dER3Xw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9eb7bce2-ff23-4fcb-265a-08daf5d5ac11
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2023 02:18:49.2490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vzb9Jmq6Ea5hT7QcSVSC5SM6gPqR3y6urBCE2UqrBPLioJhC76l9O1wNPiaOKMH4RLSRZ4YKwdNz6BcWjzAyEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5255
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 14 Jan, 2023 03:50:04 +0200 Maxim Mikityanskiy <maxtram95@gmail.com> wrote:
> On Fri, Jan 13, 2023 at 01:06:52PM -0800, Rahul Rameshbabu wrote:
>> On Fri, 13 Jan, 2023 14:19:38 +0200 Maxim Mikityanskiy <maxtram95@gmail.com> wrote:
>> > On Thu, Jan 12, 2023 at 11:01:16PM +0530, Hariprasad Kelam wrote:
>> >> From: Naveen Mamindlapalli <naveenm@marvell.com>
>> >> 
>> >> The current implementation of HTB offload returns the EINVAL error
>> >> for unsupported parameters like prio and quantum. This patch removes
>> >> the error returning checks for 'prio' parameter and populates its
>> >> value to tc_htb_qopt_offload structure such that driver can use the
>> >> same.
>> >> 
>> >> Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
>> >> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
>> >> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
>> >> ---
>> >>  include/net/pkt_cls.h | 1 +
>> >>  net/sched/sch_htb.c   | 7 +++----
>> >>  2 files changed, 4 insertions(+), 4 deletions(-)
>> >> 
>> >> diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
>> >> index 4cabb32a2ad9..02afb1baf39d 100644
>> >> --- a/include/net/pkt_cls.h
>> >> +++ b/include/net/pkt_cls.h
>> >> @@ -864,6 +864,7 @@ struct tc_htb_qopt_offload {
>> >>  	u16 qid;
>> >>  	u64 rate;
>> >>  	u64 ceil;
>> >> +	u8 prio;
>> >>  };
>> >>  
>> >>  #define TC_HTB_CLASSID_ROOT U32_MAX
>> >> diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
>> >> index 2238edece1a4..f2d034cdd7bd 100644
>> >> --- a/net/sched/sch_htb.c
>> >> +++ b/net/sched/sch_htb.c
>> >> @@ -1806,10 +1806,6 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
>> >>  			NL_SET_ERR_MSG(extack, "HTB offload doesn't support the quantum parameter");
>> >>  			goto failure;
>> >>  		}
>> >> -		if (hopt->prio) {
>> >> -			NL_SET_ERR_MSG(extack, "HTB offload doesn't support the prio parameter");
>> >> -			goto failure;
>> >> -		}
>> >
>> > The check should go to mlx5e then.
>> >
>> 
>> Agreed. Also, I am wondering in general if its a good idea for the HTB
>> offload implementation to be dictating what parameters are and are not
>> supported.
>> 
>> 	if (q->offload) {
>> 		/* Options not supported by the offload. */
>> 		if (hopt->rate.overhead || hopt->ceil.overhead) {
>> 			NL_SET_ERR_MSG(extack, "HTB offload doesn't support the overhead parameter");
>> 			goto failure;
>> 		}
>> 		if (hopt->rate.mpu || hopt->ceil.mpu) {
>> 			NL_SET_ERR_MSG(extack, "HTB offload doesn't support the mpu parameter");
>> 			goto failure;
>> 		}
>> 		if (hopt->quantum) {
>> 			NL_SET_ERR_MSG(extack, "HTB offload doesn't support the quantum parameter");
>> 			goto failure;
>> 		}
>> 	}
>
> Jakub asked for that [1], I implemented it [2].
>
> [1]: https://lore.kernel.org/all/20220113110801.7c1a6347@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net/
> [2]: https://lore.kernel.org/all/20220125100654.424570-1-maximmi@nvidia.com/
>
> I think it's a good idea, unless you want to change the API to pass all
> HTB parameters to drivers, see the next paragraph.
>
>> Every time a vendor introduces support for a new offload parameter,
>> netdevs that cannot support said parameter are affected. I think it
>> would be better to remove this block and expect each driver to check
>> what parameters are and are not supported for their offload flow.
>
> How can netdevs check unsupported parameters if they don't even receive
> them from HTB? The checks in HTB block parameters that aren't even part
> of the API. If you extend the API (for example, with a new parameter),
> you have to make sure existing drivers are not broken.

They can if tc_htb_qopt_offload contains placeholders for every
unsupported parameter. Then, the responsibility of indicating whether
those parameters are supported in an offload or not moves to the drivers
that should look at those parameters and see if they are set with
non-default values.

My concern is that, if another driver implementer decides to introduce
support for one of the other parameters, this becomes a growing chain of
maintainers that need to review since every driver that chooses to adopt
htb offload is subject to being impacted by future parameters supported.
I agree this is unavoidable, if a new parameter is added for htb
altogether, but if netdev drivers adopt a practice of checking these
parameters, it becomes very easy for a feature author to just add
another check in those drivers that already make use of htb offload.

In the patch you authored and linked, you mention the following.

  If future drivers support more offload parameters, the checks can be moved
  to the driver side.

I think this is good opportunity to make that move.

Btw, as you previously pointed, this is the change in behavior seen but
the mlx5 netdevs do not support the prio parameter, so we will need to
add a driver side check.

  /opt/mellanox/iproute2/sbin/tc class add dev eth2 classid 1:3 parent 1: htb rate 3596mbit burst 89900kbit cburst 89900kbit prio 8
  Error: HTB offload doesn't support the prio parameter.

  /opt/mellanox/iproute2/sbin/tc class add dev eth2 classid 1:3 parent 1: htb rate 3596mbit burst 89900kbit cburst 89900kbit prio 8
  # No error since support is being added in the htb offload API

>
>> 
>> >>  	}
>> >>  
>> >>  	/* Keeping backward compatible with rate_table based iproute2 tc */
>> >> @@ -1905,6 +1901,7 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
>> >>  					TC_HTB_CLASSID_ROOT,
>> >>  				.rate = max_t(u64, hopt->rate.rate, rate64),
>> >>  				.ceil = max_t(u64, hopt->ceil.rate, ceil64),
>> >> +				.prio = hopt->prio,
>> >>  				.extack = extack,
>> >>  			};
>> >>  			err = htb_offload(dev, &offload_opt);
>> >> @@ -1925,6 +1922,7 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
>> >>  					TC_H_MIN(parent->common.classid),
>> >>  				.rate = max_t(u64, hopt->rate.rate, rate64),
>> >>  				.ceil = max_t(u64, hopt->ceil.rate, ceil64),
>> >> +				.prio = hopt->prio,
>> >>  				.extack = extack,
>> >>  			};
>> >>  			err = htb_offload(dev, &offload_opt);
>> >> @@ -2010,6 +2008,7 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
>> >>  				.classid = cl->common.classid,
>> >>  				.rate = max_t(u64, hopt->rate.rate, rate64),
>> >>  				.ceil = max_t(u64, hopt->ceil.rate, ceil64),
>> >> +				.prio = hopt->prio,
>> >>  				.extack = extack,
>> >>  			};
>> >>  			err = htb_offload(dev, &offload_opt);
>> >> -- 
>> >> 2.17.1
>> >> 
