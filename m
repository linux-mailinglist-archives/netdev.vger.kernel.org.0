Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52D3269C5D3
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 08:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbjBTHLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 02:11:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjBTHLc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 02:11:32 -0500
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01olkn2032.outbound.protection.outlook.com [40.92.98.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 027461BD2;
        Sun, 19 Feb 2023 23:11:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZnijZFALxfmkDFGmJbjKB+oWq617V/IP9vz73Fpf+/XOXQz8O8gFVkhLNW7iqnxFxHNAgYJ2TENOhqw5cf+gR8aPE/Oi8NFQocB5wwPQvx/OdAgrGmyonueH9DG7iFCuh/FOsNnhYIXF9vXHUAH8VSUP/h1cX4dw09zbAbS/QJlZfPho858OWSKEh0oT6XUq5zYBJrQ+JJZ46EfjR8ZReuuJNH+w8Jl/w3ecNybjok5MldROZ5/niWNeSpeXcisL61xOYm8ABh3z5hQKO5hD6cIR5MM/TJ9f5WFT1+E+HXDaqEuqBdU+sHeTOpQgBiIe7bz8yGC4wK+98GD+gLJbNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VmvfWpwtghE7o9m+8VvKNGddV78ObqFGzfZhDekSbUY=;
 b=YXg9JVwL9Rht9rClI4QQevUYw/JAJeAwLnaLH3xYPBzihKvFmywC+zoyPmbLdeShAmxJR3jEJXBhS6YTdBzky/w/BILSxlOt3yE0/OVT2b7FsbeJNkN/YZkWzE1v+c45Ldz/QTBDeNP48963hWrau8pWeLfJuJXSNd9qyoLrHbPgeehLywbcybvma3aS1vNlzLIKJxcjp+aaMpXaolu1zFjrUH3X1NDNly8w2QUBnW9Oe5m7UOkLtVf7/1Q0K/kGHIi5n2axRyPN7hmPoo+3enSrgxf7v+iVuyOOv1UuxLPmSHZU8K89UbGt6ANWk3XkKU6oaidp/QFmhBoWb8ZRag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VmvfWpwtghE7o9m+8VvKNGddV78ObqFGzfZhDekSbUY=;
 b=Gz3t4Tewyg6RJXUJYR9imknQ9vrojnvz03HHFcStSTPqWQIyFHXi3/rINARyIv12Lj4/QLIDwxty4RB9UWcFnRCGUsshjT1RIHs31oRbf8TMbqtJ4hiuC4c3zGfHYWvR/6qMoiQTaSU2DApybx/VG1xeQE/FkW/DV+jqxzwCZgQcmCn2/FI15MBQ7Hs1p8vZd0mASh8LrE60yDBomcdXAgCxr161bzdjjNYemcrfZyAwBVWdehRdekoof1oG9RA8+kaKgZNAUUhR6bS7YemU9CU4l+SRQj40Imcd3uNs6J/eejNMp+ZzWG2OrRq+1qjse8bT5f5zYX5JV7epfT3rwQ==
Received: from OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:19b::11)
 by OS3P286MB2261.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:19f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Mon, 20 Feb
 2023 07:11:22 +0000
Received: from OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 ([fe80::9a1d:12f5:126c:9068]) by OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 ([fe80::9a1d:12f5:126c:9068%3]) with mapi id 15.20.6111.018; Mon, 20 Feb 2023
 07:11:22 +0000
Message-ID: <OS3P286MB22953C8741F17F500879FA86F5A49@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
Date:   Mon, 20 Feb 2023 15:11:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v1 1/1] net: openvswitch: ovs_packet_cmd_execute
 put sw_flow mainbody in stack
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org, Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
References: <OS3P286MB229509B8AD0264CC84F57845F5A69@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
 <Y/IqJvWEJ+UNOs6i@corigine.com>
From:   Eddy Tao <taoyuan_eddy@hotmail.com>
In-Reply-To: <Y/IqJvWEJ+UNOs6i@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TMN:  [+D5rrIW0W36MbdvUA5DwZbkpvupuZTPX]
X-ClientProxiedBy: TYCPR01CA0113.jpnprd01.prod.outlook.com
 (2603:1096:405:4::29) To OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:604:19b::11)
X-Microsoft-Original-Message-ID: <dbd08c18-3f86-0036-68b2-9f6b30ffd0d0@hotmail.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OS3P286MB2295:EE_|OS3P286MB2261:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f1c1d89-09f8-49dc-7ee4-08db1311abce
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ar+8IvAPrXe+Cte8eL4VS2Ufk72qJACNQTgfEAuAre2xz6gmRzUquP/OwoyHeDGcAX8t+yX9eQoxc97Um5boyRpUGVykjmjE8Q2QBWq0YxurwDn9vfiqIWmzb/+Uo+AT5q4Ip4G2aN3sQ+rvCQwuZrCXj6DDUdLzMXcurC6hjXECYz4KCg9Xy2w5egMVxp8m0jayUo4NmuDjwgbSjb9Weib6KFHoNf3T5MrwHvuLzNqwifhSrh1JMIi0J7UQiLklcLd8amLIcJINpDuZn+eCO1aat6YqP/X9o3nDUqKozdWqNPGWVJNoFRqlMpq2+qgowP0lxsOIzA8sSlqtk5Nv8kHTjrh2aNNKhF6yWPuvJpIA5bvbhr1fOiC0KNUO53tm2O8yY+MIbbumJ/BYrRnxbZ/HU7/a8R7ETd1edBN41DaiDMTMmHvpwAewdpF1xgRR6GV69EDIT8yBGtQ4s1a20zf81jAGkM+npW6JfmxbXzEI6vLAKqntjGdl4sHCup9hRp8do3w7DP9GcDQSWlnnSR7MbhZadxIeTmrXLa4loY670P7mADYV6Cyj3aGk8xw/C8cNQhS5b5rOWclcCzKiREOZtnRjuo1LEu5SUkORLmk6Z6t5KqsHkturJxZlLIVkTZSgIDhfHdYwLbeEu3lsow==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cFQ0V2hlYW0vcldodkkrSGt0REhRdFNHMU5iUS9TQW5FNTh5VGlMcUwrU3A0?=
 =?utf-8?B?RlR4ZUw1YzJyOGYzUTJYdmw0VW82MHh2ZmZ2M1RNeURQV1M3MjFMRU5ydlcw?=
 =?utf-8?B?S2xmYWs0ZU8xd2JqY0xjeDlIMWg3dUtWeXdiSVoyVWtlaGlFTldDOWl0aVQv?=
 =?utf-8?B?dXdnSTM1RngxTEJKNFI1NXdEQzh0elVuTzZteW1pVTlRWTdjNmxqRUx2NnRC?=
 =?utf-8?B?LzJqdjAvaXRVRmR2d21MOHYyaW9qSkVNWU1scFkreFhMSXp0elBJd1RCM2JN?=
 =?utf-8?B?RDlZM2RYbVp1anFnR3BucXpYY21XSi9aajFzR1pmRHphRnRqanRhRGtsam1o?=
 =?utf-8?B?YWZ5YUV3ZnQvOWp4NXZmcitqQkJFNGkwTC9OWjJjWkxsZUYycXQ3eXVOVU94?=
 =?utf-8?B?bjh2ZTA1enRuTlJRYzVyTkVTNXY0Qk5hUHBwZGRkSkwwODhOTTVkaHVSWmhK?=
 =?utf-8?B?Q2VCZi94cGRsd1o3TjMwenVqSURwYXJJWTRVSHY3OEI5bmk4SFFibWQ4RUU2?=
 =?utf-8?B?d0dRUUVJbjZ1VGtWdllVdFk2UDFFWStoZnl2RjlJb3p4L2lGTitSRE93dFVo?=
 =?utf-8?B?a1hNOUI5TjVWMTdyeW9OLzdQb1pMNkswRWw4R05Mb3RrWWt3WmJYbzd3SmdE?=
 =?utf-8?B?V2xnNCtZbzdiaXVrbTZxMUl5ZUg0aTQ2UUhwUEpDb1lCSTRqQ2l1YmtVUTU5?=
 =?utf-8?B?MVBjSEdUVlNMeGdwNG5DMFYrRmJrakpUd1hNYUFDOXZVeFZCYzZvblIySXo3?=
 =?utf-8?B?ei9qei9aa0wyMlJpTUpZdFhjVUJIRzlxanJ4VjQ4NjVHWnZpZjZUeTdiSytk?=
 =?utf-8?B?b3JTZ3I5dXdDV3V0cmQvK2RyS1NmUjJWSjlkVzhqSXRaZzV3YmZNLzd5ejNT?=
 =?utf-8?B?bVJHL0ZNRVJGNTJ6U0FZZTdPUkxEQ1RsenFGeUxXRWxBM2FyS2ZuTzk1UFR3?=
 =?utf-8?B?aVpkcm5Yb20ya1lqM1kySUs4enBteklOT3hjcFIwbmh4cmYzNDRSTlZCNDMz?=
 =?utf-8?B?UFpGWHJmUFpzS0pvQ1QyT2t2RTNjUUY5aFlBYndFOHdGLzlNTi9jNjNPaXZh?=
 =?utf-8?B?Z0RkZDY3TU54MWd2Y1cyRU1IMEg2NkZjRkpwTEMyZTNFRk95dUdUM3ZxZmtN?=
 =?utf-8?B?bzNOMldzYndYd0UrNllSUG11R2lqVzloUkdMNWI1THY5azZiMXhuRmRGcUJu?=
 =?utf-8?B?U3JKUzkzamFjUkd1STB1LzRNUGVkdEtFbW5jWWM0Z1VRUWl0dXltYzdKL2Fj?=
 =?utf-8?B?OTVrRjNCd2FwM0tCNW56WXVENzRtYVdDQWVtTnpYYWdBL25mUHg3cDIvaVZJ?=
 =?utf-8?B?SThsOXlaUEozN1pJOHIwZk5tRU9hRnd2K1NISkJGY0FFaWs5T0Q0UHE3VG5Z?=
 =?utf-8?B?QmFYKzh1Qkl3d3dvbnFpYk5LY1FBT2ZQNnNqLzA2MjlTTWRObVNwaVlIQ3By?=
 =?utf-8?B?LzF0SHhoakxpMzR1VVREaGVIbkR5bnVqdWw3TjN6bENqSXhzWjdJWlc1Mkxi?=
 =?utf-8?B?OXRqVEhCWjduZXpXVHRHV2o1MTFyTVpUS2pab21GSEJ3OHVEcFJZOWh2dENt?=
 =?utf-8?B?YXNmb0Jwd3pSVWs2WFBOTmlldkxmbXhCRnp0T2xWR09pMEJnS21PTUpIcW80?=
 =?utf-8?B?SmRkVWMvUEk4Q3Nmd1h0TGU0eGE4cEEzelAvdTFYRFFLb29keEdPK0tORmZF?=
 =?utf-8?B?YlNKRkliSnVpTDREcFRyYWpkdWdBSDdZdmxUMVNyRWlVME0rMktkWlBIOGRy?=
 =?utf-8?Q?F8jA1I0Pusglm4KZFU=3D?=
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-05f45.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f1c1d89-09f8-49dc-7ee4-08db1311abce
X-MS-Exchange-CrossTenant-AuthSource: OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 07:11:22.4458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3P286MB2261
X-Spam-Status: No, score=1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FREEMAIL_FROM,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Simon:


     About your concern for the stack size, it leads to more room for 
improvement.

I will file a new version which will have smaller stack occupation and 
better performance


The new revision is invoked by existing examples of using struct in 
stack, in the same file net/openvswitch/datapath.c

struct sw_flow_actions *get_flow_actions(..)
{
     struct sw_flow_key masked_key;==> sizeof sw_flow_key is 464 bytes

static noinline_for_stack int
ovs_nla_init_match_and_action(..)
{
     struct sw_flow_mask mask;==> sizeof sw_flow_mask is 496 bytes


The first example reminded me, revisiting the code in 
ovs_packet_cmd_execute, basically sw_flow serves as a container for 
sw_flow_actions and sw_flow_key only.

We do not need the bulk of tunnel info memory in sw_flow, which saves us 
200+ bytes further -- less is more.


The new revision will be presented shortly after some sanity and benchmark

eddy

