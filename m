Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9F7D696381
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 13:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbjBNMbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 07:31:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbjBNMbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 07:31:17 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2086.outbound.protection.outlook.com [40.107.95.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38D14C144
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 04:31:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lx3oUYtw19hnjP9DQLHSccCTOXto3duZ9N3ICgcHEigF6AZdOM8O6gAifr2Ih1ll0vOX75xybFRNdan8VnIQVpZityYkOcTw46EKGPMzseSE1HDBtlM+ND5jWTM2iMRt7lAS7d0fHakJQA6KDk5jyKMeBBM/ypO0IDob1Gp3DUZojp9YHurcnp4rwV0HGVZODpTTyoPnt8XPl1v2KzwprZECaG59riDtHfdB9MMmsP89F3GzlANEt0WRdu/p4eHsVyJwEPlgPWPYOSXo/rdWpYkljnXcyolBtqNsS6gtr4pi/fQxcaRhcDsSjKLUDCW/O7eb0SlGZKcEzcX2ubRv+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iiusrwTwGVgoMvtrW1D01Ru0WVNNIBqGOLTDu9cvnjU=;
 b=XsBhddU8BCp4teVKiph0Do5+aBG3e6TUF5uWFrrwai24ZkD71hHX3r2B8/BejLYfIR3HGujtlU9or20cNzPdbHaxj8kGDiDCJZVZQryItwEjbznzDj40GViAWNrHOxdE7Gi+YU4PgcwldoZt3hw2f7GuRK6vlqX3zAvIgkFFO6fqI6L+LMoo0iHvXiE8vy1CTOV2y1NhNpqkf6BVtWppRnzVIxGXnn6hsMt/0biwb/4EKJRc9Veiexn5huqYIk3S+0eS8bJLjTqnPXuYdYQqGqQVL64Eyqaewp/zKOiRZpoN9XcJbW1HYqNpTn/Ce5tyF/09De5dCGkx5PlGxIlKZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iiusrwTwGVgoMvtrW1D01Ru0WVNNIBqGOLTDu9cvnjU=;
 b=KiN33UhbTOgAfDFC/+Xb5vSehtp+yMl4o6ZJbiqng7G7zxVgCY3cRsCjEoly7xnShn9VfFSJx2y5vxzdq1GkxZN6Fxb/39KXGj4jSFhP1eNhLKOly7+wMLh7kZ/2GAfFde9XBRZbqVt8ZAkbAaKhFmpHbnHGsXrQp8gwjScthSbBmhj5iFveA0dCY0K3NJRyk3Fmf2WJxwxuOJMNA+X4mdK6TuR6tCEGOahz4Uzes6/QtCgFlkTfBDHcYm3Z1L5vNOPgBwrj3EEHmf6KUwhR9MPL7G8TP/mxr1hpTnAeTj8nVejfXBmlPA0yXGTsxOhFdtmLWWlCEmtXvz7wPxSxTA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1307.namprd12.prod.outlook.com (2603:10b6:3:79::21) by
 CH0PR12MB5266.namprd12.prod.outlook.com (2603:10b6:610:d1::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.26; Tue, 14 Feb 2023 12:31:14 +0000
Received: from DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::85c0:24e1:600e:1cda]) by DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::85c0:24e1:600e:1cda%3]) with mapi id 15.20.6086.024; Tue, 14 Feb 2023
 12:31:14 +0000
Message-ID: <8232a755-fea4-6701-badc-a684c5b22b20@nvidia.com>
Date:   Tue, 14 Feb 2023 14:31:06 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next v9 1/7] net/sched: cls_api: Support hardware miss
 to tc action
Content-Language: en-US
To:     Paul Blakey <paulb@nvidia.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>
References: <20230206174403.32733-1-paulb@nvidia.com>
 <20230206174403.32733-2-paulb@nvidia.com>
 <20230210022108.xb5wqqrvpqa5jqcf@t14s.localdomain>
 <5de276c8-c300-dc35-d1a6-3b56a0f754ee@nvidia.com>
 <Y+qE66i7R01QnvNk@t14s.localdomain>
 <a3f14d60-578f-bd00-166d-b8be3de1de20@nvidia.com>
From:   Oz Shlomo <ozsh@nvidia.com>
In-Reply-To: <a3f14d60-578f-bd00-166d-b8be3de1de20@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P302CA0035.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:317::11) To DM5PR12MB1307.namprd12.prod.outlook.com
 (2603:10b6:3:79::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR12MB1307:EE_|CH0PR12MB5266:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a136af1-701c-4a06-5594-08db0e875c6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4EeMAZcT7ceOE0FVHEs2ek6tdGCXjkGPjbBsmY7CtUlJS732UnCLiH5UtN2PU4xacD4E0PsFL5kyqA/Y8KVVtxV6QJmyjpsRFThcSqCPuqFHwBDswELiqCHTYRPiBQuZYBGXEoCIkD2eAVRY70rljJ5teCwI3jv9BWzHzRJ32XpdClXoyJn0E6YYLvt+4FX250ZdypjIMfBYbaAOIkfi0Di0TOSBXRZ24hsRORxQepPARTh+5RRu09LFe3nCtdJ/KZS3N8cMsSO/f/gZxoDs2hl+2X9BM+6XOksH6Mn2aitOpCfbfalHWikhxt+Rjpb9mtae9O6LP/DWzW2DEE3JZ34o09uQtDyOrIkKLF8SEwq2S0gxPdMVb+ylWgpluap7F+iGDB6GkuGVXc0Z+g20uzo7egZSvOyL66PmKEHJZ9aFC7o4pMyR8B3R4bp5I2mZw9geXgx2Q2He2CJdK0WiqumVXKKCBOv1UUSl3fCla1N+AIwa/8yF7eUqVTYaskfOjiZDisMhhalXRFjKe60gGUSGpyMk6yfwHEdellzFQysU+COCytfnMtwIy7ok/iBrWXGTYOk7jhXdEMTI4ZtbfhSPL6tsID+bh/jsFHjj0SMFpM6UWxOK67//gpK7Ld3Ulg1xrdZLhkBSYyDUtb81XqQGu65lNRU+QgssovtI7Infit/dAF/ambl+RnRnDde4+1JPLHFU4tlXfIb7c8LiPv8RV0CC9cm6YkCrHAZDhGc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1307.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(136003)(396003)(346002)(39860400002)(451199018)(38100700002)(5660300002)(6486002)(8936002)(478600001)(41300700001)(36756003)(2616005)(2906002)(6666004)(186003)(53546011)(26005)(6512007)(6506007)(31686004)(316002)(86362001)(4326008)(66556008)(8676002)(66476007)(66946007)(54906003)(31696002)(110136005)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TVQ3WlZNUEIxbkF2VVFSM1JHOEJkdUFjQ244Z3ZkZjFQVDYxQmtlZjI4Mmhk?=
 =?utf-8?B?OHpHT0xxU0NUcW5Tdi9aWElQME5qVFlvNEovR2JQdklLNXc2YVQ3TVRKVXNK?=
 =?utf-8?B?TUlidVNpNkM1ZFI5RGtnbHJoVWU0dW93eFYxZk9tRHducEhPU25rQmVHTHli?=
 =?utf-8?B?eSt3MGlGYkVVaCt6d0NoaFlqbURHdkVIY3lQUXNFUDZ0REZrTzIxdXU4NnRo?=
 =?utf-8?B?QjN0VU5weEJFcmhJYkMyT3QycENTMGc1aXlrYmZ6RDE2OTZvd094VkY2WHpy?=
 =?utf-8?B?dTNlTmZJb1p5U2tqajJ0L3l3aysvdkM0bE1OZGMrT0tjUVA0NDJVRVEyUC9V?=
 =?utf-8?B?VXpVYS9paG5wc2lwdlFZT2Z5eFFSNmg3bzUybU1uM2Y1dUpWV3BKZHpXVGk2?=
 =?utf-8?B?MUJvSmd3TExMTGFaMnBCWDcxN2NKalV6T0xQVzY2VWlVN1ZtY09mcVl4RXcv?=
 =?utf-8?B?TWJOQ3VzNXU4ZjFaVmIyT2lMbzdmVTE3WUFubHMvYUY1azhZSTd4dzh2N2dT?=
 =?utf-8?B?ZldVbk9YNHhkcXpaZmhBanY0RHBDb3doZUJsQnVGd1FFZ3hzTlBrQTZGUU1D?=
 =?utf-8?B?T3NaQ1A0R3hpZE0xaDFhZlhnWmRkZ1NmMWpBczgyN0N1WHE1b0hIdnJuaURW?=
 =?utf-8?B?QVFwRG5SZ3lpei9KMzhFSktrOWdVZzJINlJvdjBnRWoxQVpROGtBaDNUazNV?=
 =?utf-8?B?SmVmYmR6QS9BR29NMU5LNGcrUGlxd3V6ZVdMMlRRUnBwYjNhbDBwZ3NIaU0r?=
 =?utf-8?B?QjJWNjlDKzRoaUNEbHh1QzNaQWFLbXlidWdHVW52MjkwdWNjb1M2YnNwVlg0?=
 =?utf-8?B?cVlJTzdoQ0NzWW0yUXRDRmt5WnIwdGhwMURKelA0dFJDS2xETmRWdGVvbjZx?=
 =?utf-8?B?eDJaM244VU9yYlU1aWExanNmNE1BMDJoZkhlR2tKK3NOY3g1UzNsSGE3clpj?=
 =?utf-8?B?Ym1wSU9GVjI3S2F3dEJNRDBGN3doa3hSamdzY3pkajlNTGlMNXBGbHNObng3?=
 =?utf-8?B?TmpYaDlhUFRqN1ZCM0N5RkJFY3ZlUmY3cTM3VmwxRnBOZDhiZ2VJWXN3bXZX?=
 =?utf-8?B?ODhBRlpleVVSdFFqQjFkd3k4WUNndi9Na1BLUzNLblpnOGp5Q3VEeGNaR1BX?=
 =?utf-8?B?MFk3RkQxWGZFTXFnZlh1RGh0SkNTVjUzaEZBVTRjWnFXWVp6OVNGelJydVV4?=
 =?utf-8?B?R2hycWpaWG1nUGE2R3E0V2JEaDZwTGY4YVNLbVdobUNjK1JCNzQxaWdXdk1T?=
 =?utf-8?B?djFWa2JrUnBiVHF5TU9UeDZWSjlBYURkeUNVSkhvMkRNbERFMnN6WklscnVZ?=
 =?utf-8?B?YXdWWVhtbEd1VHM1UFV4N1FVM25IV1ZrRytKaWkwVkRSZlMvSXNzUVlJcVl6?=
 =?utf-8?B?UXlRRFBMdnhnREVlbmpGTXRlUXdsNEk0UWhJZUVKVWt5VXYza1I4REtmaEkr?=
 =?utf-8?B?ZEs0VjhsdTdVajFMM3JRV0RuREFiRFNUWjZQZldZOHZ0Q3ltR0hUSjFGNHBh?=
 =?utf-8?B?dGNLbm1ESUpBdFIyTzNxbnVnckl5M09UdmtMUmQ0ZjJwL1NLZFBPRm9ybEwx?=
 =?utf-8?B?SzU2OVJ0aE4zOVdUb0ZvSGdoaFNWT3duYUNON1YyUW9waHdETUw0OTFla0Zx?=
 =?utf-8?B?MnBRSEpSTG5henI1NThsSkZwck5uN2I1d0t6TWFNSjUxK1BPU2dST29xSk5a?=
 =?utf-8?B?MnVKeVZubkJHclVVN1Z3eWIzOXd4cmRlU1lZOFVJUkNNa01ldFhOZjFlakFk?=
 =?utf-8?B?UDhKbmswdFhRVEpoRVR3ZjRUb3J4bGlZZGFUVzc0SlJkVWNoa3pvOGtjL3Q2?=
 =?utf-8?B?UjFqZTNpZGU0c3hsdkozL0c2RURlWVZsT3o4MHhpQWpRVEtiOVNjbHhrUVhR?=
 =?utf-8?B?REZCZUpSNHNZc252d3d4MUFvL3ZhWkpoaUhNbWRJMmpxWEJqWmU1bTZMVEZv?=
 =?utf-8?B?ZHJjNlhJcW9hOUhpRmFHVjBnNmI0UDVORG1RSVhqVmgvMXZtU0Z4bnhCZE8r?=
 =?utf-8?B?YW9aOXQ0UjFIUnFmY3ZZSmJ3ZzBJcFIreTlTcVc5dUFhV21ZMFJhYi9LMjNX?=
 =?utf-8?B?eGlJZzUyR3Eyb0o0WE5NNjNGaTNrZkFCRXZUU3YwYlczUWlkNWkxU0FDUUtP?=
 =?utf-8?Q?lk/IyUJL204h9wy0t5Vdom/QS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a136af1-701c-4a06-5594-08db0e875c6e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1307.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 12:31:13.9977
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QHVnPnPgGVqKFvDA+Gg8hWpo2L9cCRGuWMXIdzM3Cs/raZ2MPJM1vGZOjPEN6hnR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5266
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 14/02/2023 14:14, Paul Blakey wrote:
> On 13/02/2023 20:43, Marcelo Ricardo Leitner wrote:
>> On Mon, Feb 13, 2023 at 06:13:34PM +0200, Paul Blakey wrote:
>>> On 10/02/2023 04:21, Marcelo Ricardo Leitner wrote:
>>>> On Mon, Feb 06, 2023 at 07:43:57PM +0200, Paul Blakey wrote:
>>>>> For drivers to support partial offload of a filter's action list,
>>>>> add support for action miss to specify an action instance to
>>>>> continue from in sw.
>>>>>
>>>>> CT action in particular can't be fully offloaded, as new connections
>>>>> need to be handled in software. This imposes other limitations on
>>>>> the actions that can be offloaded together with the CT action, such
>>>>> as packet modifications.
>>>>>
>>>>> Assign each action on a filter's action list a unique miss_cookie
>>>>> which drivers can then use to fill action_miss part of the tc skb
>>>>> extension. On getting back this miss_cookie, find the action
>>>>> instance with relevant cookie and continue classifying from there.
>>>>>
>>>>> Signed-off-by: Paul Blakey <paulb@nvidia.com>
>>>>> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
>>>>> Reviewed-by: Simon Horman <simon.horman@corigine.com>
>>>>> Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
>>>>> ---
>>>>>    include/linux/skbuff.h     |   6 +-
>>>>>    include/net/flow_offload.h |   1 +
>>>>>    include/net/pkt_cls.h      |  34 +++---
>>>>>    include/net/sch_generic.h  |   2 +
>>>>>    net/openvswitch/flow.c     |   3 +-
>>>>>    net/sched/act_api.c        |   2 +-
>>>>>    net/sched/cls_api.c        | 213 +++++++++++++++++++++++++++++++++++--
>>>>>    7 files changed, 234 insertions(+), 27 deletions(-)
>>>>>
>>>>> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
>>>>> index 1fa95b916342..9b9aa854068f 100644
>>>>> --- a/include/linux/skbuff.h
>>>>> +++ b/include/linux/skbuff.h
>>>>> @@ -311,12 +311,16 @@ struct nf_bridge_info {
>>>>>     * and read by ovs to recirc_id.
>>>>>     */
>>>>>    struct tc_skb_ext {
>>>>> -	__u32 chain;
>>>>> +	union {
>>>>> +		u64 act_miss_cookie;
>>>>> +		__u32 chain;
>>>>> +	};
>>>>>    	__u16 mru;
>>>>>    	__u16 zone;
>>>>>    	u8 post_ct:1;
>>>>>    	u8 post_ct_snat:1;
>>>>>    	u8 post_ct_dnat:1;
>>>>> +	u8 act_miss:1; /* Set if act_miss_cookie is used */
>>>>>    };
>>>>>    #endif
>>>>> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
>>>>> index 0400a0ac8a29..88db7346eb7a 100644
>>>>> --- a/include/net/flow_offload.h
>>>>> +++ b/include/net/flow_offload.h
>>>>> @@ -228,6 +228,7 @@ void flow_action_cookie_destroy(struct flow_action_cookie *cookie);
>>>>>    struct flow_action_entry {
>>>>>    	enum flow_action_id		id;
>>>>>    	u32				hw_index;
>>>>> +	u64				miss_cookie;
>>>> The per-action stats patchset is adding a cookie for the actions as
>>>> well, and exactly on this struct:
>>>>
>>>> @@ -228,6 +228,7 @@ struct flow_action_cookie *flow_action_cookie_create(void *data,
>>>>    struct flow_action_entry {
>>>>           enum flow_action_id             id;
>>>>           u32                             hw_index;
>>>> +       unsigned long                   act_cookie;
>>>>           enum flow_action_hw_stats       hw_stats;
>>>>           action_destr                    destructor;
>>>>           void                            *destructor_priv;
>>>>
>>>> There, it is a simple value: the act pointer itself. Here, it is already more
>>>> complex. Can them be merged into only one maybe?
>>>> If not, perhaps act_cookie should be renamed to stats_cookie then.
>>> I don't think it can be shared, actions can be shared between multiple
>>> filters, while the miss cookie would be different for each used instance
>>> (takes the filter in to account).
>> Good point. So it would at best be a masked value that part A works
>> for the miss here and part B for the stats, which is pretty much what
>> the two cookies are giving, just without having to do bit gymnasics,
>> yes.
> act cookie is using 64 bits (to store the pointer and void a mapping), and I'm using at least
>
> 32bits, so there is not simple type that will contain both.
>
> So I'll rename the act_cookie to stats_cookie once I rebase.
>
The current act_cookie uniquely identifies the action instance.

I think it might be used in other use cases and not just for stats.

Actually, I think the current naming scheme of act_cookie and 
miss_cookie makes sense.

