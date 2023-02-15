Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3AD869798A
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 11:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233567AbjBOKKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 05:10:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjBOKKI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 05:10:08 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2076.outbound.protection.outlook.com [40.107.93.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C9DBBBB
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 02:10:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DLydeTVrzWCy5J1zuklpWWDC0TCNMOaROifZqX3y9X5r6uX2LvkNZfaMGKqwZO/Bgl2E7XmZ9PGS+h5+rIkVFYdVcRSSLmygwIuLZXQ4GPQnsHtqFtz9xzDUy89Aa/roPnpDEH9Etx2uro6iWAWwXfk2JaLCMVZLdeV7fXnGrrAD6Dexs9ZUGBB9PIC01/o1mxQrHmP9E+oeoNtIlpYWKFp0+nYzczTFa99o/ME/xlyB7p9u1SfW+WUpppxsnXbqSSA6bkMYU5Ei/CT/+/UXxdO2bDcaxIzEZIa7R41pY0bQVJiF+A9/CPQmBv0QEAfXe4LNtWc1Ejt9/QAbwMVZHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IxHVxxi+AKg77F6DVsXExKKlwfhOaB3JsaBs8SfbYDc=;
 b=m2L/xy6veEpqdGExMbDROEQNbKIMz1I1x9EnuhYxufM4MWX4YaKSKpM4ypW7S1uHs2AfutxP5jm4MlrLmktEVnTJy0qpISb4D9ElN/HNGvSPql53HA6ggWUc8USOPw2R/mbP5mQh2dscBVA0tCA2gIs0ABwXWH9/SZODqIep6BtAzIqYk7v+WR9i8BovFVHBM7FfxLS4BttLdUzRGZMiWh5mxY2pz6RUo23YV/UvJ947FUyYJNtGbRDoeHXTs/DdXRs65l+LVa+uvUW+tUF46pKHHgX9UO8JlGpsOqL+vufFDfZlucv7eZP41d2yfGYWFEBSpfLzy7rQgsVOhqmn4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IxHVxxi+AKg77F6DVsXExKKlwfhOaB3JsaBs8SfbYDc=;
 b=KA7mRhUAo2r2P92dod3xD7peAyU0PTEwBZHwHQkKaL7fT+A4ptZaEGMjM5b+Cf7zKeWN93tym+xIQ02kjJDpsvPhvfC4t0RxfT+DZ3+tL55qy3CVZ7vc4YF8L5bsraNWu7VxKMM5JwK1XkxJ3ZwZeL5wSRfwBL1I+d4WlzWxpndCXTVepS1ZIjuVsF4gs3nn/2orBtVo0RzbpokwQVfQpiN3OSM5p1cCs0dPtJdRw60JNlvTWP06FlLQ1zFT/21HxtLpi+wmVAk2JWqHa0ykDu2Pg52o2q4O1qjg27U+MkqjgGvpEy4IZJIyL2f8OXWHYgn50IxHIojw88I7YKMsXg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH0PR12MB5629.namprd12.prod.outlook.com (2603:10b6:510:141::10)
 by CH0PR12MB5331.namprd12.prod.outlook.com (2603:10b6:610:d6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 10:10:04 +0000
Received: from PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::9af2:d4fc:43e2:cacd]) by PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::9af2:d4fc:43e2:cacd%8]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 10:10:03 +0000
Message-ID: <18a4244f-ee30-0e42-f3ac-444849203731@nvidia.com>
Date:   Wed, 15 Feb 2023 12:09:51 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next v9 1/7] net/sched: cls_api: Support hardware miss
 to tc action
Content-Language: en-US
To:     Edward Cree <ecree.xilinx@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Oz Shlomo <ozsh@nvidia.com>
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
 <8232a755-fea4-6701-badc-a684c5b22b20@nvidia.com>
 <Y+vXhDvkFL3DBqJu@t14s.localdomain>
 <c060bf5f-4598-8a12-91d4-6340ecd24e14@gmail.com>
From:   Paul Blakey <paulb@nvidia.com>
In-Reply-To: <c060bf5f-4598-8a12-91d4-6340ecd24e14@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0047.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4a::10) To PH0PR12MB5629.namprd12.prod.outlook.com
 (2603:10b6:510:141::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB5629:EE_|CH0PR12MB5331:EE_
X-MS-Office365-Filtering-Correlation-Id: 3cbf27f7-cbfa-4055-15fe-08db0f3ccdbf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sd8bbydurZuj702R04zgxloODM7Vif5WdmWvEbcLTI/FvEPsrHEczb725Wq8uBYQw+kdjy3yILHwyKkp77I6Tu5h1kvD4sPmFGnMpRH7ECFao9/YpH0qvLJmfc+9vJnMaJu2fTn7anoLh8n3dUaXqYVEyoOqYFWR6mV0ZEADoldQcqAqRz+v3JhE6xsA7rQTH6+MzU3IthpViU3E/FjvyPfyknJRDHpjIo4cg+fSKblpFsKgMKnTh4ltXVwKc1VCq6JSA3XO9Sf07NLCX54h95np3Z3ftxdogEksebTfUAphJA6Ee4Y5TCl2sOLmLSZcA5AJgUMLnQRxM51QNcDH7DLzrwtmF91FHpQ2S2+7y8yEJHocmeWUvKuJiMmawWeBIZNDGxI5VJNFtWMmSpywZGIATopZO3lQbg492C0FLwmN7Gp5BN7TrXhCByibP8e/u7viM5tG6CRkrVGaQTJRFx84bHSQgyBWdhT4OZqOCDpbp8Pm2fwLRwz+iqhPZdvbsHE4RZwysV551/iW3+MotY0qFmlmoPe27LJGx34TJXuYG3E6btS6wLMFv5XrAth4+kRyzGtO6K/kQ9vLY9kSwPBIK5iFTdAim5O2Jo+cXl6xeCvQtISj4da1FJHxQoF828E012TP1DZ2NjFV94XckdkCbhevhdXvhiqgd00Iqy34TQrGtszZB7HItD0S/FH/0PLsKcQ/lHLh53SQ8SPcQGb64S0H5TV4g0u1Oon5OiU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5629.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(136003)(366004)(346002)(376002)(451199018)(83380400001)(31696002)(86362001)(38100700002)(6486002)(478600001)(6666004)(6512007)(186003)(26005)(2616005)(36756003)(6506007)(53546011)(41300700001)(8676002)(66556008)(2906002)(66946007)(66899018)(4326008)(66476007)(5660300002)(8936002)(7416002)(31686004)(6636002)(54906003)(110136005)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N2VzTTFUa0NuSWFldFdSZjlmdlJlTzl1NFlhY1FEeHlJYXgyTGZGRW02amNV?=
 =?utf-8?B?YnhUWGJ2aTJFdUhxOGpObjhzeUtnL3YvOXlPeXBOVllzcjhsZGlaUDcxYnhQ?=
 =?utf-8?B?Vm5VcjArZW1pbHRpMlpycjg0VTUzbEd0Zm9sZndQamZqQjNjK0kzdCtYZHU3?=
 =?utf-8?B?YXRCTDYxS0lMWmdvRGVkYTIydm1pQjJkRWMxZ3pFa1llbnNpaFM3Sm5ic2VV?=
 =?utf-8?B?YkNBUFFGdUs4VkpwSFNwdVBJQTd0bmNhclh6TXQ1enVybXNFNE1oWUVWUnMw?=
 =?utf-8?B?T2ZIYzhDTnd1OGgwN2pTR0JjZEpacjFaa2hlU1VDS1oyQmF4TDZmdDQrQTZD?=
 =?utf-8?B?bDBRWXNXcmNlUWNvQytEcWNRN1FRRk1DbGkyZ3E3QVgwakFJbnZiYmExOGk5?=
 =?utf-8?B?amVYVkN3SFprM1ZzSk03bG5oQ2hRb1BkRnN1ZU5jaXdiOE5GOWF1eXV1dUEw?=
 =?utf-8?B?RktGYkkyeVdUOG40SE5FLzBaMnFJV1ZFUXhwb0NHSFQ0aDFZOHFBbHRuNGhO?=
 =?utf-8?B?TVdVam1URzM5WlZLVWMwZElOOFF0WTIrb2tsSis0QS9EaEFXOTJmUS9zbWRB?=
 =?utf-8?B?eVpVVVJ4N3pZNlY4TlpWYW1MN3MxZklHQi9TTFEwN0QvUFNJbU53R1JlUGZI?=
 =?utf-8?B?cjNndFhQa0V0UFFnZTBlZGxQMmZLQzllM1g0d0Q0d2pONEhrQlpDdHBjcVR4?=
 =?utf-8?B?UWhFQXNaeWhzRFJDaVJkTXBZOG80K2pVN0dNMDdXRW1BaGVkczFHQU85MUpW?=
 =?utf-8?B?c2R0RldQeElUL1BzZnJjREVWUDd1aDJtdGJlVTBOZEl3S1dFMTVNdk5leWhz?=
 =?utf-8?B?UVBDYUZ3d01va3FrcnFaSm1hOXZSN09mUTdWOEpuY0dFak91Ynh3YWdtSVBp?=
 =?utf-8?B?SDV5RDZpV2JJbGRlNjJsOHhoOE5PMlBXUGx4R1Y2NTZ2Z2hzSThqY3U2eEVD?=
 =?utf-8?B?Mlk3dGJ6VzM1VkZ3OVFISTZCWFRQcWdNdytEVklRTEkxc3NvN0dxQmNySllP?=
 =?utf-8?B?UVVJbjhBeXRuajJKZXB3eldsVU1PTEN1TVQyU2xENW1FZytYVFcvWThRb2pX?=
 =?utf-8?B?djM5VU16cndjeXUybzJjVnhTU0pFdUtUUXBWWGNGYU9EaERvYjY2M24xRVhV?=
 =?utf-8?B?cGNVbDRjaWEyWFY4RlZxbFV5TTQxSFFSeEdIVDhBMkl2cUhMRVNscXJKNmFt?=
 =?utf-8?B?RVhQTS8xemptMng3NzIxZFVBbWE5ZEJ5VFdjQzBMTXE0Nk1OT0lBS0MvK01Z?=
 =?utf-8?B?VWpBdC9PeXFVYjF4TTlURk0xSkR4UmtVQW1ZcThKTnNxQnpaZ1Uzb3gxdzd3?=
 =?utf-8?B?THFheFJGZkZqc21FUndUUWtnRU5lRTgvc3hLTnJzeDg3VEZ2cWNrUURhWTJj?=
 =?utf-8?B?UXJYditxU1d2OExtRXJSQTcvbzdUenJmNTh6M21jS3kvcDIxVWVLc0hOK3pt?=
 =?utf-8?B?WmJHa1VVSW56WGtWSTF4MXpHeXNoS2MrMjVCRWtlR2p0ejNJNEVDalErSHVQ?=
 =?utf-8?B?ajQvVmMvbmVhb3djS21pQUh4RUx0V2hIUXdXMjIrOHczT3RkUm5TZUVrazBj?=
 =?utf-8?B?ZkdGaStVTHMvYTd2d1lOWHk2bldqYmkybFNtZUhvQlVvemhmaHk0eXdJRnhT?=
 =?utf-8?B?TmZ4dGlBbUNrS3liVWN6aXVOOUxtcU9aM0trKzMvZWdkdi9sMUtDd0w2Q1BN?=
 =?utf-8?B?Sm9SODZvUW8zU0ZuTDVPMHlkRHdpQXZob0JHWmtFMTZaZ3Q5anN4cVd4RnpC?=
 =?utf-8?B?Yk5sRnBNS0ZwRE1DVGorK0VTdVlQTDJNdTlMNGEyWVRlcXowUHF5K2k3aDZ3?=
 =?utf-8?B?TDRqRE4wSXNWb1MydVo4Y2RxWjZOUnJGdDh6bUJBTTYyMUgyYXgvMGNEeWFJ?=
 =?utf-8?B?T2dQVnlTdnU5bmNTL2l0cHIzOUNORjgveDN5MEwwMWsyL1c0cEJSZGlJK0FO?=
 =?utf-8?B?YzAzbS9TVm1YTlE1Yit4RjJSdmdiSDFEUXNLUzBkUVQvVUhOZ0lQbEYxWnVV?=
 =?utf-8?B?NmV1RWlDRDM2S2lES1RHTGJSUUZDU0FGTjFjS2VsbTFZU3AydkFMNFllWlFu?=
 =?utf-8?B?WHpWUDhhaWI1NHZ2KzlYYnZaM2kvNGlVK0tmL0NrakxWK054L2VHTTZnQWpS?=
 =?utf-8?Q?CZ5HWFzf+NDug82Tq5zqukpql?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cbf27f7-cbfa-4055-15fe-08db0f3ccdbf
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5629.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 10:10:03.2206
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SzvqPacSiKD9LJLC/sdWNg9/0bYZiGZV3hCkSfK+TigQeKuheZ+LAOVJSRfVDBbZAjS4qAsOz+VvtVt4THIWow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5331
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 14/02/2023 21:24, Edward Cree wrote:
> On 14/02/2023 18:48, Marcelo Ricardo Leitner wrote:
>> On Tue, Feb 14, 2023 at 02:31:06PM +0200, Oz Shlomo wrote:
>>> Actually, I think the current naming scheme of act_cookie and miss_cookie
>>> makes sense.
>>
>> Then perhaps,
>> act_cookie here -> instance_cookie
>> miss_cookie -> config_cookie
>>
>> Sorry for the bikeshedding, btw, but these cookies are getting
>> confusing. We need them to taste nice :-}
> 
> I'm with Oz, keep the current name for act_cookie.
> 
> (In my ideal world, it'd just be called cookie, and the existing
>   cookie in struct flow_action_entry would be renamed user_cookie.
>   Because act_cookie is the same thing conceptually as
>   flow_cls_offload.cookie.  Though I wonder if that means it
>   belongs in struct flow_offload_action instead?)
> 
> -ed




Ok so I want to add this patch to the series:


 From 326938812758dbd2591b221452708504911ca419 Mon Sep 17 00:00:00 2001
From: Paul Blakey <paulb@nvidia.com>
Date: Wed, 15 Feb 2023 10:57:40 +0200
Subject: [PATCH] net: sched: Rename user cookie and act cookie

struct tc_action->act_cookie is a user defined cookie,
and the related struct flow_action_entry->act_cookie is
used as an handle similar to struct flow_cls_offload->cookie.

Rename tc_action->act_cookie to user_cookie, and
flow_action_entry->act_cookie to cookie so their names
would better fit their usage.

Issue: 3226890
Change-Id: I3cfff2323f50234250e510062fd27307b6aa1896
Signed-off-by: Paul Blakey <paulb@nvidia.com>
---

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c 
b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 2d06b44..208809a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4180,7 +4180,7 @@

  		parse_state->actions |= attr->action;
  		if (!tc_act->stats_action)
-			attr->tc_act_cookies[attr->tc_act_cookies_count++] = act->act_cookie;
+			attr->tc_act_cookies[attr->tc_act_cookies_count++] = act->cookie;

  		/* Split attr for multi table act if not the last act. */
  		if (jump_state.jump_target ||
diff --git a/include/net/act_api.h b/include/net/act_api.h
index 2a6f443..4ae0580 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -39,7 +39,7 @@
  	struct gnet_stats_basic_sync __percpu *cpu_bstats;
  	struct gnet_stats_basic_sync __percpu *cpu_bstats_hw;
  	struct gnet_stats_queue __percpu *cpu_qstats;
-	struct tc_cookie	__rcu *act_cookie;
+	struct tc_cookie	__rcu *user_cookie;
  	struct tcf_chain	__rcu *goto_chain;
  	u32			tcfa_flags;
  	u8			hw_stats;
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 8c05455..9c5cb12 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -228,7 +228,7 @@
  struct flow_action_entry {
  	enum flow_action_id		id;
  	u32				hw_index;
-	unsigned long			act_cookie;
+	unsigned long			cookie;
  	enum flow_action_hw_stats	hw_stats;
  	action_destr			destructor;
  	void				*destructor_priv;
@@ -321,7 +321,7 @@
  			u16		sid;
  		} pppoe;
  	};
-	struct flow_action_cookie *cookie; /* user defined action cookie */
+	struct flow_action_cookie *user_cookie; /* user defined action cookie */
  };

  struct flow_action {
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index eda58b7..e67ebc9 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -125,7 +125,7 @@
  	free_percpu(p->cpu_bstats_hw);
  	free_percpu(p->cpu_qstats);

-	tcf_set_action_cookie(&p->act_cookie, NULL);
+	tcf_set_action_cookie(&p->user_cookie, NULL);
  	if (chain)
  		tcf_chain_put_by_act(chain);

@@ -431,14 +431,14 @@

  static size_t tcf_action_shared_attrs_size(const struct tc_action *act)
  {
-	struct tc_cookie *act_cookie;
+	struct tc_cookie *user_cookie;
  	u32 cookie_len = 0;

  	rcu_read_lock();
-	act_cookie = rcu_dereference(act->act_cookie);
+	user_cookie = rcu_dereference(act->user_cookie);

-	if (act_cookie)
-		cookie_len = nla_total_size(act_cookie->len);
+	if (user_cookie)
+		cookie_len = nla_total_size(user_cookie->len);
  	rcu_read_unlock();

  	return  nla_total_size(0) /* action number nested */
@@ -488,7 +488,7 @@
  		goto nla_put_failure;

  	rcu_read_lock();
-	cookie = rcu_dereference(a->act_cookie);
+	cookie = rcu_dereference(a->user_cookie);
  	if (cookie) {
  		if (nla_put(skb, TCA_ACT_COOKIE, cookie->len, cookie->data)) {
  			rcu_read_unlock();
@@ -1362,9 +1362,9 @@
  {
  	bool police = flags & TCA_ACT_FLAGS_POLICE;
  	struct nla_bitfield32 userflags = { 0, 0 };
+	struct tc_cookie *user_cookie = NULL;
  	u8 hw_stats = TCA_ACT_HW_STATS_ANY;
  	struct nlattr *tb[TCA_ACT_MAX + 1];
-	struct tc_cookie *cookie = NULL;
  	struct tc_action *a;
  	int err;

@@ -1375,8 +1375,8 @@
  		if (err < 0)
  			return ERR_PTR(err);
  		if (tb[TCA_ACT_COOKIE]) {
-			cookie = nla_memdup_cookie(tb);
-			if (!cookie) {
+			user_cookie = nla_memdup_cookie(tb);
+			if (!user_cookie) {
  				NL_SET_ERR_MSG(extack, "No memory to generate TC cookie");
  				err = -ENOMEM;
  				goto err_out;
@@ -1402,7 +1402,7 @@
  	*init_res = err;

  	if (!police && tb[TCA_ACT_COOKIE])
-		tcf_set_action_cookie(&a->act_cookie, cookie);
+		tcf_set_action_cookie(&a->user_cookie, user_cookie);

  	if (!police)
  		a->hw_stats = hw_stats;
@@ -1410,9 +1410,9 @@
  	return a;

  err_out:
-	if (cookie) {
-		kfree(cookie->data);
-		kfree(cookie);
+	if (user_cookie) {
+		kfree(user_cookie->data);
+		kfree(user_cookie);
  	}
  	return ERR_PTR(err);
  }
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index bfabc9c..656049e 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3490,28 +3490,28 @@
  }
  EXPORT_SYMBOL(tc_setup_cb_reoffload);

-static int tcf_act_get_cookie(struct flow_action_entry *entry,
-			      const struct tc_action *act)
+static int tcf_act_get_user_cookie(struct flow_action_entry *entry,
+				   const struct tc_action *act)
  {
-	struct tc_cookie *cookie;
+	struct tc_cookie *user_cookie;
  	int err = 0;

  	rcu_read_lock();
-	cookie = rcu_dereference(act->act_cookie);
-	if (cookie) {
-		entry->cookie = flow_action_cookie_create(cookie->data,
-							  cookie->len,
-							  GFP_ATOMIC);
-		if (!entry->cookie)
+	user_cookie = rcu_dereference(act->user_cookie);
+	if (user_cookie) {
+		entry->user_cookie = flow_action_cookie_create(user_cookie->data,
+							       user_cookie->len,
+							       GFP_ATOMIC);
+		if (!entry->user_cookie)
  			err = -ENOMEM;
  	}
  	rcu_read_unlock();
  	return err;
  }

-static void tcf_act_put_cookie(struct flow_action_entry *entry)
+static void tcf_act_put_user_cookie(struct flow_action_entry *entry)
  {
-	flow_action_cookie_destroy(entry->cookie);
+	flow_action_cookie_destroy(entry->user_cookie);
  }

  void tc_cleanup_offload_action(struct flow_action *flow_action)
@@ -3520,7 +3520,7 @@
  	int i;

  	flow_action_for_each(i, entry, flow_action) {
-		tcf_act_put_cookie(entry);
+		tcf_act_put_user_cookie(entry);
  		if (entry->destructor)
  			entry->destructor(entry->destructor_priv);
  	}
@@ -3565,7 +3565,7 @@

  		entry = &flow_action->entries[j];
  		spin_lock_bh(&act->tcfa_lock);
-		err = tcf_act_get_cookie(entry, act);
+		err = tcf_act_get_user_cookie(entry, act);
  		if (err)
  			goto err_out_locked;

@@ -3577,7 +3577,7 @@
  		for (k = 0; k < index ; k++) {
  			entry[k].hw_stats = tc_act_hw_stats(act->hw_stats);
  			entry[k].hw_index = act->tcfa_index;
-			entry[k].act_cookie = (unsigned long)act;
+			entry[k].cookie = (unsigned long)act;
  		}

  		j += index;

