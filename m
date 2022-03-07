Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0894F4CF267
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 08:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234561AbiCGHK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 02:10:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235751AbiCGHKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 02:10:25 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2085.outbound.protection.outlook.com [40.107.236.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B815DE7C
        for <netdev@vger.kernel.org>; Sun,  6 Mar 2022 23:09:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dRkSM6HpYVocT+SPzS7KpFfQq+Vt7VXn5WdrJ61fOKa6IFW5o9LNqaNRsPTYZZLHjphEVyXOjKMFgDaMfqRhTtG5iiHlGLq0s7Rov4h+uflYjUnD7vSAvXTZpiA9caEYDHc4Dg1Ru/DIjs0Oihr74tm6aahJXlD4PTKPvBS1S5TI7C19VrCVhtt4U/RzupAiQPIRMpiQBl/CxFHqaBvgungk0ocBKPClizhyaOdGO1qCp0y9Vq1jJgAbDZbbkL9Ll+hkcKBrvSxyutYh6wERjTt9A2wyMyybHI0u4dRlDXwYSzrwKQ07yXbKgrfzfSvhklrGWmhyjvWSvqRbQ4Qm4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RlBWeE3XdWnISzs3uAdvfXfDyzAAp0Bs83yfOIJeHFk=;
 b=CwAQIG4XKHQSuJ3Oho1bMi4jg3gJ12te2OSwUQDo56cMCHH3r4s8NL+gG1N1t3sN9sLYVap5kENI8ai6TR2m9YbP70u2eJiOE/kfeecOkL7Danrd4sr+tvzrb8JAsRCvvgBt048lkNy/3ZxR9nSWhmU7tqTbfV+XifuMdLK3fl5+ShFCR602n3AYjnAwmQzjH3DtPJ1UNmzdDtIwkFGHr5nLKKCWDHhXjcyX5h3ZZ6i2Ct+gVipKonWfX9APRM+yLkxl56fnO8Tn5yrTQ4+noINYl5kSUscyVpCJ1j7MpbgLiCjGFF20tqvZVGkTp5G4b49mtidirpUBIfV3TBlfpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RlBWeE3XdWnISzs3uAdvfXfDyzAAp0Bs83yfOIJeHFk=;
 b=Zq3+5a4e2YOZxk7fwNU7PzhXnniL4q2e4ceXa0dkY3wxQ3Hhbu5/g0TVyVoiBJE4OgLvUKIvKRuvYMshnknDa24hrGsxhxp+miRNIN8YQhIYQfkQQW7v0yGE8ShH0i9+IrCd9KfP0FvSXC3Ss70mDQDwrwPpqiINwLtqE/FgXj+k/WxthiDamSCdKreElljwY5jtYxqciwRlk2x8TBghpb6VXdYwzTqeRBoAky2BmUbwd3PUy4yBGY9yxl4MmMlf263XYcSbAKpHGTXNlDWS4jWs8c+iiRbknCyu6yR/2OBBKt/CAUa6PQ46WCflrpzG/KTzt8e+6Srmb0Q8CVwtbQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH0PR12MB5330.namprd12.prod.outlook.com (2603:10b6:610:d5::7)
 by DM5PR12MB1195.namprd12.prod.outlook.com (2603:10b6:3:7a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Mon, 7 Mar
 2022 07:09:25 +0000
Received: from CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::dd23:4505:7f5b:9e86]) by CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::dd23:4505:7f5b:9e86%5]) with mapi id 15.20.5038.027; Mon, 7 Mar 2022
 07:09:25 +0000
Message-ID: <ed4028e8-e41f-2b25-3461-0a6053f57ddd@nvidia.com>
Date:   Mon, 7 Mar 2022 09:09:19 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:98.0) Gecko/20100101
 Thunderbird/98.0
Subject: Re: [PATCH iproute2-next v1] tc: separate action print for filter and
 action dump
Content-Language: en-US
To:     Baowen Zheng <baowen.zheng@corigine.com>,
        David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com, jhs@mojatatu.com,
        Victor Nogueira <victor@mojatatu.com>,
        Simon Horman <simon.horman@corigine.com>
References: <1646359300-15825-1-git-send-email-baowen.zheng@corigine.com>
From:   Roi Dayan <roid@nvidia.com>
In-Reply-To: <1646359300-15825-1-git-send-email-baowen.zheng@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0087.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1f::9) To CH0PR12MB5330.namprd12.prod.outlook.com
 (2603:10b6:610:d5::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9d7cae14-de31-4697-a50c-08da00096998
X-MS-TrafficTypeDiagnostic: DM5PR12MB1195:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB11956EF60789027A93B44C4BB8089@DM5PR12MB1195.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k+2oq7IE6tpckGMAKArocKBEWCyvapfF1qvMhaIxfWbRbP24TkgceOmzwbRil2EWp1HeXneBL7PXSvPr55Qrc/DynwYYm5jA69uf7124iCjtlgxd9XnOKJVYEzhwzNVRW2C2rtzJPlofjWhFLEbBM555uq7vmSqnc0/J0ZBrCdli2jdvaUkpfF2M/rMszjkboakKgDrbDJuotxOGiGv3XZEf0m8W5lndayIkszQNGPpXfxaim2dkf7RsRjOXxftfJ/+KqQJANGvHA3c+YKFMve/TiHDIkcuYJ2VcBJqv9zLALHS+A11eSTfYCJWaoEhiYGHggoSItMp8/qG01Ft8EUtpBEk+XopeStF22GSQEqXctBxKjpzuQr8g0wjJq1f8x1nUM7S/J0QHHVk5yiZFOQWls6E9UcWd+PW/ycMv/Gsfhp0n/x6eMiuI22Z+JX0JTwlf6U+ARpngdTInPweaoDZ01Q6J6P9YGvQ3SwLHDuAoI13Bl4UXtSCW23zj0PmK8Txvr6ztuKWzBimqbyLKlw5jbFM8NuQdoEdCyhMMV5QY/Nr3htct0Gbow0y8CSIa5YGhiH/g3hmpl0KipmB4GlewgqM1c0EjQ/8eBD+3CdcOpYkp+Untj/1MiOKAwBYYlNWRxIYUBsdd6BuZsZAJliEZ9G/zKe8clbni0Vgbj9BzC8iElgDckbjDerZSovhfX+7TJ5V6dV6wjPF6RSneqLAZQZVc6Uynqc7SxbWX7nM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR12MB5330.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(54906003)(110136005)(31686004)(26005)(6506007)(6512007)(316002)(53546011)(8936002)(66946007)(6486002)(2616005)(38100700002)(6666004)(83380400001)(86362001)(36756003)(4326008)(8676002)(508600001)(66556008)(5660300002)(31696002)(66476007)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eXZOeFB1Vk1hcWhvT242cCtQVlZ6cTlTNG51TzlZKzk4L1NxRytldFQxcHlW?=
 =?utf-8?B?ZVZrRmQ5Y1RWeklFMGVEYjVjT2FRM281NjY2ZjNWRjd2K1hoOXRiS1BLVSs0?=
 =?utf-8?B?SVFMcEZ1Q0xrcEF0TDRWMVp3bGpDN2FyQVVLdExBaDdYVVB6Njh0ZFlVem5D?=
 =?utf-8?B?UlRKaitpdkxGOExvQ01vRTVIQUJncVRvMWZ3VTh2SUlwaXJ4K3BZMTAxMzhG?=
 =?utf-8?B?NnFuL1NkcUhISlNWZTNKeWZUL2NIVFZIUkRCRzFZRnc1cHVWYWJFZnk1ck9L?=
 =?utf-8?B?OWFZdXEyMWtua1dtWjgzUGlORG1CUnFueUVPaWRvb1FrUHpMYlZaQ0tkTnVZ?=
 =?utf-8?B?RUtDU0lObjM5dkx5WWE2L2pmSm44MlNBL0NIMERoeUFMcTZHaExkd2VFQkpB?=
 =?utf-8?B?d0ZRay9MZ0VyaW9VcmdiQk5CTlRDSDNLbFhYUTF3YVZsVUZpTlJYeXpjdW5G?=
 =?utf-8?B?emtIaVN1amwzVHJRc1ZDbjZIVW83N2JrRDFGSWtUKzI2OUEvZm80RW43ME4y?=
 =?utf-8?B?OVdPUzhJaGp6ZjNZN0VjQ1orQUtDTktzSkI1LzN4dlZNNm9jWndOZUw1dlJh?=
 =?utf-8?B?a09vYTN5WjBReFZZRU5XRkloUURpblBreDZaQ3hZOFRrb3BjUlhTT082UE9S?=
 =?utf-8?B?MU9leDNHL084MUt4N2E4NjNlRWRaV01HUWFMdUI0TENrOTNobmNtMWc5Q0pX?=
 =?utf-8?B?U3hpbEhxSTNGL2NwZGJ2VUxqaHdOcnB5MnZ2RWc3UEJsTzNWdi9Ua3BNMm5z?=
 =?utf-8?B?cVdPL2E3R2Z0Y0sySGdhTExSanVYZCtXeUJMeitZeDVLU3piZEt4cnlHY1pF?=
 =?utf-8?B?Vzc0eEs5OHA5Y05WdDNIa2NnV0VBZm9acXRtc2JWM3JVb2I2ZzBVa1ovQjVl?=
 =?utf-8?B?cE1SbmNsczZMOFVPV0ZUcVBQR2dtM0JPVCtlVVYxWDArMllEUXJrcWk4UTky?=
 =?utf-8?B?Ymt1R1Evd1FCQythTjQzMWdMTkhOQllQeWpxWmZsd01aTWZyVzd6RmZsMXlQ?=
 =?utf-8?B?RWV5Q1RMUVdkeFh4L0xBSm1NNlgzRTU4VThQcTJsVk1INDNSWlp6QlF0TTZw?=
 =?utf-8?B?Z2F6ZVdXVGNKMVNBa2MyTkNTKzZOTUx2UGdXdFUzYlh2dGc1NWMzWDN6MlJj?=
 =?utf-8?B?WnMvWEFoNzZnYzVXcXVEV29YbG9iZjlUdnFPZWp6T3VQTGN6cklTZ251RjNu?=
 =?utf-8?B?MUt2NEx4OVFhZ1F3ejFicjhFU3RwY2p2Si9GUzRxV2R2WU1sMjl1UkZiMlJv?=
 =?utf-8?B?RHVwYk50WHZ0Q05LaDk2bDNOSW8wSzdxemdEMmdsZWlVckdNejhTWmxmQnVK?=
 =?utf-8?B?ekJzMXBvV1BHaGt2NjN5RzkwMGJCbDZITkp5Yi9EUmpjblQycFBPUGc2NGpl?=
 =?utf-8?B?MmVxbVlyK0ZPZmZYSWx1TjlMMVJoaW5nN24rUGM1b2RzQzNRWEZoWkhTWVNC?=
 =?utf-8?B?d2M4dUVQbXFlQWFzUHgwaHcybWwzYUIvTHdWOWYvcEU0anRWbUhVMjJWUmpR?=
 =?utf-8?B?RnZHUGJTbGNKWU5JdDBqMnBoZ0VIamdBN0UxNjNrQUNtUkFsaFpKVWh2c01K?=
 =?utf-8?B?aGNYSVBuSEhWdkNCVDB4THFOUDdydk83RG9PUVRGaU5waGRMZGtUbDg5a3Nj?=
 =?utf-8?B?cFMrbjFFVXlucmwvMDBXSUNOWWZES083aFlzSEhXQ2hHZGJmVXd0TkhJTStZ?=
 =?utf-8?B?WUliR2lBRGVYR3U5YlVpejlKOE02Y0NGekdjSkordFA5Z3NESUoxTzhKa1dS?=
 =?utf-8?B?WktESkt0blMrN2Q3SVhqaGxBTHI1ZEJQalVwcDl3elk1N3ZBMkxCV2xPLzZK?=
 =?utf-8?B?OWhFNkFPQUIzamJ3bmJISHpRa0dzTE13ZUdUd0dwUnJCaVhSMHRTdVpVN1FO?=
 =?utf-8?B?NFY1TCtkdWI2T2tBeWFKMm1ycURpUC9NZVJHN2ZNUkRNVjNSNE11UEhSVXVs?=
 =?utf-8?B?NWh4SVgvbDdLZStIY2g0V09QMmtNcXl4WHRWMVVxRXlrenZ2bEVhelhNenMw?=
 =?utf-8?B?dFNoZDVZQ29IdjNxYnpvV0Y3QUZSRmtudXhIQ3diRER4QWJqNGtWbmRhd25X?=
 =?utf-8?B?UUExNndDQVdhN21XUy9tdDZUL2ZnTVJ1VDAxZ013OTV5cWxEK21saVkvL3l5?=
 =?utf-8?Q?weHY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d7cae14-de31-4697-a50c-08da00096998
X-MS-Exchange-CrossTenant-AuthSource: CH0PR12MB5330.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2022 07:09:25.7350
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hf2Ui3ME+90DEo3uVQxg2LCTs2IcnD1mmRE7KfqvYFYbPhPhRov4t6g70QlDGYxv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1195
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022-03-04 4:01 AM, Baowen Zheng wrote:
> We need to separate action print for filter and action dump since
> in action dump, we need to print hardware status and flags. But in
> filter dump, we do not need to print action hardware status and
> hardware related flags.
> 
> In filter dump, actions hardware status should be same with filter.
> so we will not print action hardware status in this case.
> 
> Action print for action dump:
>    action order 0:  police 0xff000100 rate 0bit burst 0b mtu 64Kb pkts_rate 50000 pkts_burst 10000 action drop/pipe overhead 0b linklayer unspec
>    ref 4 bind 3  installed 666 sec used 0 sec firstused 106 sec
>    Action statistics:
>    Sent 7634140154 bytes 5109889 pkt (dropped 0, overlimits 0 requeues 0)
>    Sent software 84 bytes 3 pkt
>    Sent hardware 7634140070 bytes 5109886 pkt
>    backlog 0b 0p requeues 0
>    in_hw in_hw_count 1
>    used_hw_stats delayed
> 
> Action print for filter dump:
>    action order 1:  police 0xff000100 rate 0bit burst 0b mtu 64Kb pkts_rate 50000 pkts_burst 10000 action drop/pipe overhead 0b linklayer unspec
>    ref 4 bind 3  installed 680 sec used 0 sec firstused 119 sec
>    Action statistics:
>    Sent 8627975846 bytes 5775107 pkt (dropped 0, overlimits 0 requeues 0)
>    Sent software 84 bytes 3 pkt
>    Sent hardware 8627975762 bytes 5775104 pkt
>    backlog 0b 0p requeues 0
>    used_hw_stats delayed
> 
> Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> ---
>   tc/m_action.c | 53 ++++++++++++++++++++++++++++++++++++-----------------
>   1 file changed, 36 insertions(+), 17 deletions(-)
> 
> diff --git a/tc/m_action.c b/tc/m_action.c
> index 1dd5425..b3fd019 100644
> --- a/tc/m_action.c
> +++ b/tc/m_action.c
> @@ -364,7 +364,7 @@ bad_val:
>   	return -1;
>   }
>   
> -static int tc_print_one_action(FILE *f, struct rtattr *arg)
> +static int tc_print_one_action(FILE *f, struct rtattr *arg, bool bind)
>   {
>   
>   	struct rtattr *tb[TCA_ACT_MAX + 1];
> @@ -415,26 +415,37 @@ static int tc_print_one_action(FILE *f, struct rtattr *arg)
>   	}
>   	if (tb[TCA_ACT_FLAGS] || tb[TCA_ACT_IN_HW_COUNT]) {
>   		bool skip_hw = false;
> +		bool newline = false;
> +
>   		if (tb[TCA_ACT_FLAGS]) {
>   			struct nla_bitfield32 *flags = RTA_DATA(tb[TCA_ACT_FLAGS]);
>   
> -			if (flags->selector & TCA_ACT_FLAGS_NO_PERCPU_STATS)
> +			if (flags->selector & TCA_ACT_FLAGS_NO_PERCPU_STATS) {
> +				newline = true;
>   				print_bool(PRINT_ANY, "no_percpu", "\tno_percpu",
>   					   flags->value &
>   					   TCA_ACT_FLAGS_NO_PERCPU_STATS);
> -			if (flags->selector & TCA_ACT_FLAGS_SKIP_HW) {
> -				print_bool(PRINT_ANY, "skip_hw", "\tskip_hw",
> -					   flags->value &
> -					   TCA_ACT_FLAGS_SKIP_HW);
> -				skip_hw = !!(flags->value & TCA_ACT_FLAGS_SKIP_HW);
>   			}
> -			if (flags->selector & TCA_ACT_FLAGS_SKIP_SW)
> -				print_bool(PRINT_ANY, "skip_sw", "\tskip_sw",
> -					   flags->value &
> -					   TCA_ACT_FLAGS_SKIP_SW);
> +			if (!bind) {
> +				if (flags->selector & TCA_ACT_FLAGS_SKIP_HW) {
> +					newline = true;
> +					print_bool(PRINT_ANY, "skip_hw", "\tskip_hw",
> +						   flags->value &
> +						   TCA_ACT_FLAGS_SKIP_HW);
> +					skip_hw = !!(flags->value & TCA_ACT_FLAGS_SKIP_HW);
> +				}
> +				if (flags->selector & TCA_ACT_FLAGS_SKIP_SW) {
> +					newline = true;
> +					print_bool(PRINT_ANY, "skip_sw", "\tskip_sw",
> +						   flags->value &
> +						   TCA_ACT_FLAGS_SKIP_SW);
> +				}
> +			}
>   		}
> -		if (tb[TCA_ACT_IN_HW_COUNT] && !skip_hw) {
> +		if (tb[TCA_ACT_IN_HW_COUNT] && !bind && !skip_hw) {
>   			__u32 count = rta_getattr_u32(tb[TCA_ACT_IN_HW_COUNT]);
> +
> +			newline = true;
>   			if (count) {
>   				print_bool(PRINT_ANY, "in_hw", "\tin_hw",
>   					   true);
> @@ -446,7 +457,8 @@ static int tc_print_one_action(FILE *f, struct rtattr *arg)
>   			}
>   		}
>   
> -		print_nl();
> +		if (newline)
> +			print_nl();
>   	}
>   	if (tb[TCA_ACT_HW_STATS])
>   		print_hw_stats(tb[TCA_ACT_HW_STATS], false);
> @@ -483,8 +495,9 @@ tc_print_action_flush(FILE *f, const struct rtattr *arg)
>   	return 0;
>   }
>   
> -int
> -tc_print_action(FILE *f, const struct rtattr *arg, unsigned short tot_acts)
> +static int
> +tc_dump_action(FILE *f, const struct rtattr *arg, unsigned short tot_acts,
> +	       bool bind)
>   {
>   
>   	int i;
> @@ -509,7 +522,7 @@ tc_print_action(FILE *f, const struct rtattr *arg, unsigned short tot_acts)
>   			print_nl();
>   			print_uint(PRINT_ANY, "order",
>   				   "\taction order %u: ", i);
> -			if (tc_print_one_action(f, tb[i]) < 0)
> +			if (tc_print_one_action(f, tb[i], bind) < 0)
>   				fprintf(stderr, "Error printing action\n");
>   			close_json_object();
>   		}
> @@ -520,6 +533,12 @@ tc_print_action(FILE *f, const struct rtattr *arg, unsigned short tot_acts)
>   	return 0;
>   }
>   
> +int
> +tc_print_action(FILE *f, const struct rtattr *arg, unsigned short tot_acts)
> +{
> +	return tc_dump_action(f, arg, tot_acts, true);
> +}
> +
>   int print_action(struct nlmsghdr *n, void *arg)
>   {
>   	FILE *fp = (FILE *)arg;
> @@ -570,7 +589,7 @@ int print_action(struct nlmsghdr *n, void *arg)
>   	}
>   
>   	open_json_object(NULL);
> -	tc_print_action(fp, tb[TCA_ACT_TAB], tot_acts ? *tot_acts:0);
> +	tc_dump_action(fp, tb[TCA_ACT_TAB], tot_acts ? *tot_acts:0, false);
>   	close_json_object();
>   
>   	return 0;

thanks

Reviewed-by: Roi Dayan <roid@nvidia.com>
