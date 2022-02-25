Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB31D4C4CDD
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 18:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiBYRva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 12:51:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiBYRv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 12:51:28 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on2087.outbound.protection.outlook.com [40.107.102.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 795F3223101
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 09:50:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QBHv20/39z5He71OoGPMQYjXukfu1B9mhsAThmaeShajFmk9k17sauExEih/1wDS8h/jyAVAgFqnAYiQPWP+FFicdlA4EdzY3jk5A2Rk0We7BWhz+QrfwCrAws8a8OlB6cgE1yUvR6AdK26FcTmujWG07Rl69aBfMvpOR2aiAd3acJmJelfG5YwqDoBD4C9KHZXeGcl/wB445UTV3G3FsI0WtORQ4AhuF/u9Emb5fb9rvrwuIsNZdTQSDz80UPgxsWaD3lNJ9u1cZFjR0QPGdp5ocXqn35PZ3JO/lG7rlX0s+dn89jDnXCrW6dBLvDrfr8tXmCLCS30zpuG8WxpFzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=deyZzI8dLaFroyjLlg3lNoSVaI6maOLKHI8usDd/2ps=;
 b=URdyB1EfZTgAOYODyW6ZnkNZoSs0izgnT/0Q2iCZ9/ZvxibS3xigZKW/Iyc/flTFTZdtuZ6G9O3BHInERExeKbm7T9xBWtvpjm4S2/jHbZEom46M4HszNnI4HcgUm8Wy8pcoGSvP+Za6+I67X+dpW0GS50oGGS2HGVxx8FFNztEyzEj8COPpZLKygJwShPY2q7I1QQqiXlIcB7yloltDrYGb46TmT6NkhaAzt7nniU67jtlkzVlHfwMhQssDuzhpFYjS+Ra1cUezYE+4N76jBMzI5qwEbo9Y3HpHANNwIQGFaZSTjldSxmgf7bYeXGW/neo/NaBwFfl7bamySAE/Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=deyZzI8dLaFroyjLlg3lNoSVaI6maOLKHI8usDd/2ps=;
 b=Ua6Ckd+OCk+V/VMmYHGam5KQC9OaLbmhGNmhQMjsxLCt8PYj8FWP9Q7ZlNCTofdokxB6X1uhMFDKJBWGGtkv5yODRkP0gxqp17U3LOiIJmPaXmvUa4v/y7A+uGhzG9+3E3NqfffKpewat7IoZGdgeFWwNWwdTf24gTk2X0sA7WU9yUauOMIpoX2/Q86UCY7kKKMsMquOxqTkVN6aXh+uPx31tQfq6g7vyj6mN1zgqykUGfQbqvmo2Ii6tgs5PW3szVIKOaHuE5FfGn8tNvXuwKLJqTVuAJPMVcM3K4kbWVr3OongeVjK5qCxvwvbxaGpAHyZPJ0FCl5Puy96/iSorw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com (2603:10b6:a03:3ad::24)
 by CH0PR12MB5345.namprd12.prod.outlook.com (2603:10b6:610:d4::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Fri, 25 Feb
 2022 17:50:54 +0000
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::9cc:9f51:a623:30c6]) by SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::9cc:9f51:a623:30c6%7]) with mapi id 15.20.5017.026; Fri, 25 Feb 2022
 17:50:54 +0000
Message-ID: <da46955d-711f-1ebc-156c-be7f1d089085@nvidia.com>
Date:   Fri, 25 Feb 2022 09:50:53 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v2 09/12] vxlan: vni filtering support on collect
 metadata device
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        stephen@networkplumber.org, nikolay@cumulusnetworks.com,
        idosch@nvidia.com, dsahern@gmail.com, bpoirier@nvidia.com
References: <20220222025230.2119189-1-roopa@nvidia.com>
 <20220222025230.2119189-10-roopa@nvidia.com>
 <20220223200413.6fd5e491@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Roopa Prabhu <roopa@nvidia.com>
In-Reply-To: <20220223200413.6fd5e491@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0065.namprd07.prod.outlook.com
 (2603:10b6:a03:60::42) To SJ0PR12MB5504.namprd12.prod.outlook.com
 (2603:10b6:a03:3ad::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a1138bd-edd6-47cf-4c99-08d9f8875e8e
X-MS-TrafficTypeDiagnostic: CH0PR12MB5345:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB5345BE003D5FBBFB99DFBBE4CB3E9@CH0PR12MB5345.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bUyUBdrZpwb7cw2yefaxAVdYcZWS9Ymi2ELDFDmQnQlRu+YBkH+KnN8kQHl/0PgtF2Vl8iyi0sKGPDZOb5xalwJSAD0tyD8d5s2h+HwyYFOoO8Odl7FxloT7MzlOC/E/tTH5Aycc2o5SSi2dXRdn1gLlU8XzCqA+ZIAH7rM+VoNOjJlOG2COr+rTBDPd3AMADRKrpOqD08u/8KjyOZ0GJqbiRDOp/qcQo2KFbrsU5z9qm5yS8Q3hx2QTSEBXFdoER9uga15JoGMNZ5Q3meZ28+iIA+nVzSADWF0bYLw0V4+HOmcx5CDzz5xZySByfJmLQJ9Oj/L5cx8q+ed0FqJzF4rrqUiG6Pw7GnK7cXSRQ/oDk6SkZ7Zkgq02vK2CwQ/XDjOypuG3ab9WjBNUFJ+M5eXpa4KosLS3KuerhhMoURJQnGVOT0CSQ04C5l7t71Ji2alyYgIQfoqsSX5DabR2g6LU0zYIUnxuIjFifFKw57UZgk40f0NSSFbIr1GtBoMFZJAKY1FdlMbPI8RkIbBUersR6Y34mUd2WrQSbpmSD4w1DbX47y9919+R8JyIKt6FKkDbCqxqdz/hZDItpgMzjCj18jxoa1pqKRYOkVZ6HV8+vDTtaA/bqsQoTydY1f3jV6E+dLzZ2ebOEXIbN2I/ZzCHQcuMzDMXtqsEsE0KE7I4a9yzrEutUv3TQtNv4vWMpYOarwmfCNUvG7JEHtIPgZsiwJ/3vxWvwjNWQ1wtsr9RuaY6NejrF9F9bStU8R2m
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB5504.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(5660300002)(4326008)(31696002)(86362001)(186003)(53546011)(2906002)(8936002)(6512007)(6506007)(2616005)(6486002)(38100700002)(107886003)(31686004)(508600001)(6916009)(316002)(66476007)(66946007)(66556008)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QjcyenFISlY5ZllOQ1ZyS2MwaEI2ZmJ1d2Y0NG9VM1hJNGxsb3V2YU50d2FG?=
 =?utf-8?B?aWEyU2svYUttbXU3MzZjd0pCb2FWbEhPcWZvWTJnOGN5MVluMWxHM1hSY2px?=
 =?utf-8?B?c013V0JsYklvdEppOE1meFJnc0JxMXZMTHc3RVRkZDhBOG5xNGNqV2kreGdi?=
 =?utf-8?B?YzFYdTNwUDdtdmF5cHpEVlVPdjhSbzJSWUpadjgyK1JRMHJRKy9jWGNCeVU4?=
 =?utf-8?B?SkpYMHFFTXJqS2lEUnlEUi9vYVRBSGtEYTZhUFZMR1FqSWJxMjB2TkdDZndH?=
 =?utf-8?B?OU9vUEFhYndaV2d6NC9WQ2p6WGFYSDlnYTMvRHhSRlBBbkl6eUs2cWJTbG1N?=
 =?utf-8?B?OGFkOUtUTnhXbW5iNUhMa0FoaHpkU2hVdmVxUlk3dHNLSnJ0RVQ1YS9mcy9w?=
 =?utf-8?B?YmxVcVVnaVFydjlYNStSYnpWUU40c3I2R3p0NFRhOEswZEpzK1Q3dWZxa0hz?=
 =?utf-8?B?QTROaTZ6NmpOMVFtMERaRzIwNUNTSU9ZL1FsOVI1alVCbXVHN3E4LzN4VVB6?=
 =?utf-8?B?MjBkdCtPSkhYVE1hakJpZmUrU3dKQXpjTGYyRDlGMlhZd3JQMFM1c1BRSjVB?=
 =?utf-8?B?alpSWTZjejl0SnZIRE1IS0JGRC9RSUt1RjJYSW9RbndRMzByRUREaGl3Skh1?=
 =?utf-8?B?bTdqNHhweW5ESnRweUpaelNFZ3dsTzZYTGVDNnM5OXBwcjdJUGkvOGtWaTEz?=
 =?utf-8?B?SmFnMGw3WE1PS2RJcDJweXZKNFNVd2cxWkN3eGUzSmZucWFDVlM2dFo5aUJR?=
 =?utf-8?B?MmxCQ3RxTGR5T1hUTkRVVlZhSlh2MXRmR3d4WSt6Ti9LMktHMG1xRVRtQTli?=
 =?utf-8?B?Vk92VXVoREtTdCtaRHRINXVTSkduanNLekRzMkxodStnZlEwMWZQVHhGSWIz?=
 =?utf-8?B?SjJOdUQ5K2ZWUnN6RjkrRlA3VC9lV2R1V3k2SEk4TGhWaXhpNHJsYTc1eGtr?=
 =?utf-8?B?Tmk4bEtXY0lEUjQ3ellvYnNWWjl1OGZnRGFkNC9qanRZU21jMlJYeXJLZzJo?=
 =?utf-8?B?UCtvYWRrNjBrOU9tcmFrOUo1NG5nNDJUZEtLZnhVR2NMN2Uwd1BSM09BTVNq?=
 =?utf-8?B?NE1rYUg1MlljVENsaDd6YzN5WWxWRks5dzVnRlFYVTRlbFVRRHRjazAzd25w?=
 =?utf-8?B?QytmRjhMdWhzSHlBUVRkU1YrUG81b25IT1ZCcUQrbUN5VExicEZhV2NmSnFm?=
 =?utf-8?B?eXd3SGlET3ByOTVqVitGTUk3MUNJUXpRcXllSENwcEtkQWNrK0NiUGFFUGNi?=
 =?utf-8?B?RHkzM2tJUWJEVEthR1pvaGFaTnB2VkxSM2dzQ2VJUHdyRk56ZUdIbkRXUzdr?=
 =?utf-8?B?THc4TVAxQ2krMXJrMWVldTBPSXJ0R05WQXY0SldTN1U2Wjh0MGdMNWwwNUVk?=
 =?utf-8?B?TzZEWkdURGdJZ3M4NWJEOTBaOXdqUEtHS2Y1UlRrakM2M2czYmtySFRCTzRB?=
 =?utf-8?B?OFNzYnVHcWV5VkZzU0RyUDVxU1hVcWx1d2ZUc2ZVejZsTEhkYm9Cc2dmYU5U?=
 =?utf-8?B?eHBEMHRtQmd1MksrN09JQlU1bkJ5MVcyUWIvR1lsa0p4NURYUUt6M0s0ZWtv?=
 =?utf-8?B?L3NNSDY1bkVEdVpXYTROWk5CakdFdktvMmo0T28zbTlPTFVZQnNCckNmUFhw?=
 =?utf-8?B?UldoWW5yd0pGMTBwSUJLWDBhT0R2ZUs2Mi9odGpYaDM0SHNtanU0blVMRmhp?=
 =?utf-8?B?QlRuYWdqeGJWYWZBR1hCRnBMWTk4dzJoQTE1SGNxNFhhdXlpWGNGUVB5NkZI?=
 =?utf-8?B?WW1zRFF5S2JpMk5aYk1hUTNYZlhRUXRsRk8vWXRUQUZEZ1hOOWFBVjdXUkc5?=
 =?utf-8?B?ZkI5N3EzeWhQNkhQQnZ6eVluQXBxNWJsbzZlR0N4NkF3NS95MFlPNGZyckw1?=
 =?utf-8?B?ODRxTHE3MG5lMU5UQ0RqVG5rMXBjYTRPWEpiWmxmNG9RbGZyMW80ZFZQVExR?=
 =?utf-8?B?RXQzZ0FLYzM0TGU1ZFhwZjhIU2dsQm91clc1VFN3cGFCOGJwZ2V0Y1hQTGRK?=
 =?utf-8?B?YUExKzgxY1BDeVB6WU1LM3hsbkxKbXQ3SHp6WjFIM3g5UmdEKzYwem9pTUxE?=
 =?utf-8?B?NFRpQ0JIQ2lXay9XeEN3U3lpMndDN3ZBdVhvSEROZENwcHVWdndZN1Z5QmhR?=
 =?utf-8?B?YzdVbTVGOWVHVHcrdDVubDVaN0VXNXY1dytvb2F0QTh3dTJtU0kzaHAvOUpB?=
 =?utf-8?B?dUx3Z0RqV3FUcEJTRWJlVjFoajdEa1hoS0pyT2xLeVpodGRZditxRWNGcFF3?=
 =?utf-8?Q?16j86aHYefxNrXXrZ+A96Po2HqO0ESA7EVqQKorChQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a1138bd-edd6-47cf-4c99-08d9f8875e8e
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB5504.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2022 17:50:54.2949
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /zxhOdRvKxxS9iv69XyeQl84pXX9Q4pLlR3UfRap5Wu4NU52Ts4pHz1s7e8s2fvSuIs/NgBGgdnclaDXr0Yq8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5345
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/23/22 20:04, Jakub Kicinski wrote:
> On Tue, 22 Feb 2022 02:52:27 +0000 Roopa Prabhu wrote:
>> diff --git a/drivers/net/vxlan/vxlan_private.h b/drivers/net/vxlan/vxlan_private.h
>> index 7a946010a204..d697d6c51cb5 100644
>> --- a/drivers/net/vxlan/vxlan_private.h
>> +++ b/drivers/net/vxlan/vxlan_private.h
>> @@ -7,6 +7,8 @@
>>   #ifndef _VXLAN_PRIVATE_H
>>   #define _VXLAN_PRIVATE_H
>>   
>> +#include <linux/rhashtable.h>
>> +
>>   extern unsigned int vxlan_net_id;
>>   extern const u8 all_zeros_mac[ETH_ALEN + 2];
>>   
>> @@ -92,6 +94,38 @@ bool vxlan_addr_equal(const union vxlan_addr *a, const union vxlan_addr *b)
>>   
>>   #endif
>>   
>> +static inline int vxlan_vni_cmp(struct rhashtable_compare_arg *arg,
>> +				const void *ptr)
>> +{
>> +	const struct vxlan_vni_node *vnode = ptr;
>> +	__be32 vni = *(__be32 *)arg->key;
>> +
>> +	return vnode->vni != vni;
>> +}
> This one is called thru a pointer so can as well move to a C source
> with the struct, see below.
>
>> +static const struct rhashtable_params vxlan_vni_rht_params = {
>> +	.head_offset = offsetof(struct vxlan_vni_node, vnode),
>> +	.key_offset = offsetof(struct vxlan_vni_node, vni),
>> +	.key_len = sizeof(__be32),
>> +	.nelem_hint = 3,
>> +	.max_size = VXLAN_N_VID,
>> +	.obj_cmpfn = vxlan_vni_cmp,
>> +	.automatic_shrinking = true,
>> +};
> struct definition in the header? Shouldn't it be an extern and
> definition in a C file?

dont remember why i accidentally moved it to the header file a few 
internal revisions back.

you are correct. Will fix. thanks.

