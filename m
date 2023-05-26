Return-Path: <netdev+bounces-5518-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 55DDC711F7F
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 08:01:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D484028168D
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 06:01:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1F043D8C;
	Fri, 26 May 2023 06:01:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D632587;
	Fri, 26 May 2023 06:01:51 +0000 (UTC)
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF403DF;
	Thu, 25 May 2023 23:01:49 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34PKnswK003820;
	Thu, 25 May 2023 23:01:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=KsOg8yO9sHdpPSIpGDvoUc6MR2JZTXafivpD5i2jZRw=;
 b=asryQ0WUXzs7Grbyi7r487+JV6xk1ZlW4L14JUTTJIoh0BwBBBRp7f1gPlSgzCPiHNjk
 2a0ubeoPe4bt2s87KcoJnJbN4azt0DU+lpBlN7Vja50hDcpCZdQg39Asr5gOve8reEZw
 xjtnIrZ/YA/YI6S14VTY7IBOtk7PjPQuLmxopG1rFLPPwRORvxWPzZ4r/6pqVp3gZnxD
 SLIZPcMJ+oUMI3SOWJID/8kiUateNagA8xC4ChsRzZ9N3BYCY6i6w/KNCImGrOSwcigs
 erIcmsAYyrFhgnQjreMXsikiJtcDmDUrd9AS7n7/bxhBwrm87VE0r1rMiZgT1XN9Qezo uQ== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3qt9b0nq1b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 May 2023 23:01:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MBWUBRHRCj+MNInDS365pKKx11mDQXBwud0Xc4tmw4PgrMB2t/OMIq0zlyUulNeKu0z1TmLbQaPp+D3aJvJSMp6WJGHS23yXSw/6itfhHV3CUu8EKiE34xJr2ACBoQXy4B7YYCwY9NfLKhXsYG0iKEUbv6t/antnIxPN+0hLCgX0U1vgPjc57k4tm2VRJUyMUq8PgRhNUz2jygr4xhEvVOo81ztru5BqFzO7MtcU74OZ0dtxeDsCniwDCT2e4ZtzQZaZKo8ed2l9VeDMAHbIEgfVNjceOM23mg+vD/qhnkf1Sw++HbUXTiwjGyetFk2je6kSLZzkNZyD19sPN34cgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KsOg8yO9sHdpPSIpGDvoUc6MR2JZTXafivpD5i2jZRw=;
 b=iBl5AhupHMPV2Euq7rt7X8dqfoAPrQsX6iIhi/+7aHwFdQes2lC64h12r8eo5DlmBwrPOojNO7wTyJBmT0Fsul+dXebp3UCmDhXWrNOXMvAPW1IxcFKPl+IZliPdqd/wFzehEqtbfz4P+k7oHFGVSUEFUhii6kvKqHxzl0KNyjTd6Nbw2ne0lq+uJt1CgVSBT7GVMmRFMMYrxN+zAmvZBnOPnS8aPs9ORFh7qaPtOoqGiEaLnl1zWRIoK8RdWH0IMFeHktOHysv7Lk8wn2YPvfK28sPkQIMqghVw7+Nfe9k1CdZ945Tifw0P+PJjCpaZKroaWPH8Fr2AHui2hF1SVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4871.namprd15.prod.outlook.com (2603:10b6:806:1d2::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.18; Fri, 26 May
 2023 06:01:38 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::bf7d:a453:b8d9:cf0]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::bf7d:a453:b8d9:cf0%5]) with mapi id 15.20.6433.016; Fri, 26 May 2023
 06:01:38 +0000
Message-ID: <cc91d53d-0a73-cf30-bd7f-b22db8228842@meta.com>
Date: Thu, 25 May 2023 23:01:34 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
Subject: Re: [PATCH 1/2] bpf: add table ID to bpf_fib_lookup BPF helper
To: Louis DeLosSantos <louis.delos.devel@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc: Martin KaFai Lau <martin.lau@linux.dev>,
        Stanislav Fomichev <sdf@google.com>, razor@blackwall.org
References: <20230505-bpf-add-tbid-fib-lookup-v1-0-fd99f7162e76@gmail.com>
 <20230505-bpf-add-tbid-fib-lookup-v1-1-fd99f7162e76@gmail.com>
Content-Language: en-US
From: Yonghong Song <yhs@meta.com>
In-Reply-To: <20230505-bpf-add-tbid-fib-lookup-v1-1-fd99f7162e76@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR03CA0006.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::16) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|SA1PR15MB4871:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f01227f-0f34-4d3d-a1f7-08db5daeaaf8
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	y7y/0owz1g/sa3DjGAM2kCmbfT4g2c3dzjdthPm5PPlnALqeo+lhxpHK8qWPVcGw63dZj4lNYmtgeD34iZ7sqY/qdjIPtmaTaBko97PWDizupXx1mlNM8DchcFU05Cf8UVYmlRE4ZpQNOCfmR32u3spwbdUH0Ps0M3+SMdtT6q8ozR+/ppN85vKAeC2X+0qCKocXwi7zhnlwAC7fn8EWehyyQNn/xtU+EGgvcpeR1XS/4Sn/MyRfjO8bcDD69AzprUVL2rCdJqqy2MvweiTnGgYNUYUuBmug6+JTlIgRNlP1LH1ZVq68Wfo8hW+CL+fuP6xVyNa0pu72l3X/xGDemY2c0zmXnXZTvZRWrQMt1OCBGRkCGJZeREuZe9PdrpGiLoel6f7kGN44kyt6iSTho3LCAYoqzA6JoI9dCnaEOi7v6B2Uf1dcsoYh5wMHiYXK0HwGaLSyPBuxY7AuNnPvaMVWYWqwAbaenY+BGMjBgWSBs2YTeM9Qv4Ld1o2c+Y3AuCg9HImTjs69wg7c2CauJnZFQzUZNUJNXf7PqgBL+9R+gVjShv4GIOmdH0Nb6SX7AlCjt1Ow/7VPe+NGz/uU+GSPpZ10JOBpTnTOTwIF/pPULzleLv5VcS1UJM7y+6PVOt/+SBVR/z2U0+GnWLha/g==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(136003)(39860400002)(396003)(366004)(451199021)(38100700002)(8936002)(8676002)(5660300002)(478600001)(54906003)(6486002)(316002)(6666004)(41300700001)(4326008)(66946007)(66556008)(66476007)(36756003)(2616005)(86362001)(186003)(2906002)(31686004)(31696002)(83380400001)(6506007)(6512007)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?TEFBVmNRNU9sRWtCSDVCVm1JalFFQlN5b1R0NXpZbys2L3hLL3RybEtheHNx?=
 =?utf-8?B?U2RueG9CK0FNMUNobjFlRVFOTXVIdGp5NlVsYW15NkNBMHhuSEx6UERMeXUv?=
 =?utf-8?B?OTRTUEd1ODkwb2U1bXliWTZGTjZuY2Y4dm9lQjRzY0ROdWlrOG55bE1RUk5G?=
 =?utf-8?B?ZU5kZmdra3NYemtMVXBIYys4amFidWozdWtpVE9TdkJTaHpBbEh5R3UvMHJy?=
 =?utf-8?B?aUFvL0ZRYnVIQkZZaHFOWFROMHIvY3U4MjBZdUN5UW9yQWpRcmVzeXV0YUFk?=
 =?utf-8?B?VGpYdXZXSDNGZUY3emZRdlJ5WnJyTjBwNWpwd3R0WE1RSDFQaVNReXRRUXhI?=
 =?utf-8?B?MjVPR29KaDkxV1NEek4vRmtvNzZZaVo3cmhDdGpzNThPc2ZqZDIzb1k1ZFRi?=
 =?utf-8?B?OU8zd1JONnk5ZkV5a1p3YnB2eC9IOEp1ZzB3cEl3STU4cDFaS1FrcDgzUjY2?=
 =?utf-8?B?THV1OVdiMGc5aDMwTU1BTGIycVlRSE1ob1Nsa0Z3WVZZbXNOSVlRWGk1dWJL?=
 =?utf-8?B?L04wVUlza3BvNzdSYytSZzl2YjFJc3J6M3pIVFNtWEk2SW1wVmFFeUNXRUgw?=
 =?utf-8?B?VW1DZ0RPRktmTHAvSDZlVTNhRTczSC80Z3JkaFpVenRhQkVyMEQ0NTdwUHNG?=
 =?utf-8?B?Z1BxSnBXdnpzaU1yQ2tLTW5rcUUvb0lVeENzNXArTEJXQlpmZ0VhZWZsSVBS?=
 =?utf-8?B?Yk1VL0l2Mklvb0JVTHkzRnZ6eWRWNHhLb1J3M2RiYnFNeU80aTZ4RFNHY1Nq?=
 =?utf-8?B?YTBMR01Cak9QZ1hmWWdKM0p6amhsYWhqWFo5WG9mOVl3NUY0b1JiOFpSMFMv?=
 =?utf-8?B?Q201YUVlV2xqQzMzdkp4cDVpbEJ5VU0yb3VVK1hoVTFIMlVWTEdQT2VGWW9E?=
 =?utf-8?B?VENiNVp2Y2lWRzB1d2pVbTh0ZWpNZit5VXR5NUJKODFyVzI2TW1DOElHcGIw?=
 =?utf-8?B?RFg5ejQyK3pqbXE3UmhqTm5OaWtHbUgxRXliV3QvNEtSb0xaUlZqZ0hpWStU?=
 =?utf-8?B?QXV2VFhFbWszTmoyMkJMN2JkTHlpQ2NRMHZjamJ0cytvbEs0cEN4YUFnRHNF?=
 =?utf-8?B?NC85clI0V2kzbHFiY09JaFUyTVdadm9VMFBMQTk2dXRPSVVrY0NNdmROZllX?=
 =?utf-8?B?U3dQcElsUlVoTG9zNXBnUjBEZmdTK0JQaElSVUdBS3JSVmxPV1RtTWRKcFlK?=
 =?utf-8?B?VzlmY2pZaXZwai9pdmNjOEl3VUJ6Z0pYeEJkUGpoci96cUhhb1FhOWYyVFlX?=
 =?utf-8?B?ZkxERzdtRmlHNG1Ya2cydVRtcVpkb3FSKzZuVDJvb0RXcXBXd0xRUEIxbHVz?=
 =?utf-8?B?K3REM0JJKzRKcWJ3UWJIbE84blZ4UXY5cFYxYytPOGJPMmJZRGljWmhrbXdQ?=
 =?utf-8?B?NXVCaVBVYkVSd2JJcVpFUkpYMmZqUTFzUW5PdkdMOE5Idk5BTmN6OEpMT3Fs?=
 =?utf-8?B?Mkt2UmpZYWlwVGZncEJzNm8wUWNZcDdyMjg4TDd0a1RjWkVBVG96Vm9nYVBy?=
 =?utf-8?B?RytwZVFXOU9OM2lzK3kyV3JMWjZ1RzBNRnNoQ3ZTSlBpTjBsclg3eEMrYkQy?=
 =?utf-8?B?M3dHbEZhRkxzQWZtSko1SlNRUDVmRHNwOVBiUDNidHFXWTBUeEw5SzVNTWZ4?=
 =?utf-8?B?V3dJaks4OUZxOC9FOVVuSlJjZXZDanorQWw2NmpCTGFhUWxmSjJLUjVBUGEv?=
 =?utf-8?B?VThYVGhNOUtmSjlJQlk0VGRLYzVDWXZDUFNMN3U0b0tTeUhndTZWbFN4cU5L?=
 =?utf-8?B?cTJxU3NxZ1MzaC9uR3dWRm5aamduME5adnhaNXF1WG9PNnZhZnVWQSt5bkJO?=
 =?utf-8?B?OFpWODdOL2IrYm4xUHJoeEhnejlXYW9qa0g3bTBrcm9qVU9SYTVPeEhSTGZ0?=
 =?utf-8?B?c0tFT0pWTmFNZ2t5UTZtY0JBekw5ZXlRNnJCNEJtN2gyZElJSHo0MWlBTmFX?=
 =?utf-8?B?OEdaOTBReU1GSFNod1hVcjBsVi9YbHR2Z1Zyd1Z6bjdRWXdQRkNaeVpnbnZ5?=
 =?utf-8?B?WXJIUWVCWlVzakk1a3d4RnJDT0F1OU1idVVjL3B2bUNMSTUvelkyQTNTNEgx?=
 =?utf-8?B?ZkNGaTZvbWEreW5CTVYzbk94Yk9pMXFaL2ZrektWNzF2WHdicTY1ZUtoMDE2?=
 =?utf-8?B?ekJZcTBwRHI5VlpRYzBMcWE5LzFKT3h6Tm4yTmlBVWV6aFM4eGZ5VjNFR0d3?=
 =?utf-8?B?eVE9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f01227f-0f34-4d3d-a1f7-08db5daeaaf8
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2023 06:01:37.8602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MJjzKhgqjbLyiy3+nQ7uDYrl7X6U+zwKrVgNVA20PszBLVISOT4lz60kur99NrJ6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4871
X-Proofpoint-ORIG-GUID: nDJUo3LW72IEj8bmObMN0kShPlE7EqYK
X-Proofpoint-GUID: nDJUo3LW72IEj8bmObMN0kShPlE7EqYK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-26_01,2023-05-25_03,2023-05-22_02
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/25/23 7:27 AM, Louis DeLosSantos wrote:
> Add ability to specify routing table ID to the `bpf_fib_lookup` BPF
> helper.
> 
> A new field `tbid` is added to `struct bpf_fib_lookup` used as
> parameters to the `bpf_fib_lookup` BPF helper.
> 
> When the helper is called with the `BPF_FIB_LOOKUP_DIRECT` flag and the
> `tbid` field in `struct bpf_fib_lookup` is greater then 0, the `tbid`
> field will be used as the table ID for the fib lookup.

I think table id 0 is legal in the kernel, right?
It is probably okay to consider table id 0 not supported to
simplify the user interface. But it would be great to
add some explanations in the commit message.

> 
> If the `tbid` does not exist the fib lookup will fail with
> `BPF_FIB_LKUP_RET_NOT_FWDED`.
> 
> The `tbid` field becomes a union over the vlan related output fields in
> `struct bpf_fib_lookup` and will be zeroed immediately after usage.
> 
> This functionality is useful in containerized environments.
> 
> For instance, if a CNI wants to dictate the next-hop for traffic leaving
> a container it can create a container-specific routing table and perform
> a fib lookup against this table in a "host-net-namespace-side" TC program.
> 
> This functionality also allows `ip rule` like functionality at the TC
> layer, allowing an eBPF program to pick a routing table based on some
> aspect of the sk_buff.
> 
> As a concrete use case, this feature will be used in Cilium's SRv6 L3VPN
> datapath.
> 
> When egress traffic leaves a Pod an eBPF program attached by Cilium will
> determine which VRF the egress traffic should target, and then perform a
> FIB lookup in a specific table representing this VRF's FIB.
> 
> Signed-off-by: Louis DeLosSantos <louis.delos.devel@gmail.com>
> ---
>   include/uapi/linux/bpf.h       | 17 ++++++++++++++---
>   net/core/filter.c              | 12 ++++++++++++
>   tools/include/uapi/linux/bpf.h | 17 ++++++++++++++---
>   3 files changed, 40 insertions(+), 6 deletions(-)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 1bb11a6ee6676..2096fbb328a9b 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3167,6 +3167,8 @@ union bpf_attr {
>    *		**BPF_FIB_LOOKUP_DIRECT**
>    *			Do a direct table lookup vs full lookup using FIB
>    *			rules.
> + *			If *params*->tbid is non-zero, this value designates
> + *			a routing table ID to perform the lookup against.
>    *		**BPF_FIB_LOOKUP_OUTPUT**
>    *			Perform lookup from an egress perspective (default is
>    *			ingress).
> @@ -6881,9 +6883,18 @@ struct bpf_fib_lookup {
>   		__u32		ipv6_dst[4];  /* in6_addr; network order */
>   	};
>   
> -	/* output */
> -	__be16	h_vlan_proto;
> -	__be16	h_vlan_TCI;
> +	union {
> +		struct {
> +			/* output */
> +			__be16	h_vlan_proto;
> +			__be16	h_vlan_TCI;
> +		};
> +		/* input: when accompanied with the 'BPF_FIB_LOOKUP_DIRECT` flag, a
> +		 * specific routing table to use for the fib lookup.
> +		 */
> +		__u32	tbid;
> +	};
> +
>   	__u8	smac[6];     /* ETH_ALEN */
>   	__u8	dmac[6];     /* ETH_ALEN */
>   };
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 451b0ec7f2421..6f710aa0a54b3 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -5803,6 +5803,12 @@ static int bpf_ipv4_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
>   		u32 tbid = l3mdev_fib_table_rcu(dev) ? : RT_TABLE_MAIN;
>   		struct fib_table *tb;
>   
> +		if (params->tbid) {
> +			tbid = params->tbid;
> +			/* zero out for vlan output */
> +			params->tbid = 0;
> +		}
> +
>   		tb = fib_get_table(net, tbid);
>   		if (unlikely(!tb))
>   			return BPF_FIB_LKUP_RET_NOT_FWDED;
> @@ -5936,6 +5942,12 @@ static int bpf_ipv6_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
>   		u32 tbid = l3mdev_fib_table_rcu(dev) ? : RT_TABLE_MAIN;
>   		struct fib6_table *tb;
>   
> +		if (params->tbid) {
> +			tbid = params->tbid;
> +			/* zero out for vlan output */
> +			params->tbid = 0;
> +		}
> +
>   		tb = ipv6_stub->fib6_get_table(net, tbid);
>   		if (unlikely(!tb))
>   			return BPF_FIB_LKUP_RET_NOT_FWDED;
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index 1bb11a6ee6676..2096fbb328a9b 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -3167,6 +3167,8 @@ union bpf_attr {
>    *		**BPF_FIB_LOOKUP_DIRECT**
>    *			Do a direct table lookup vs full lookup using FIB
>    *			rules.
> + *			If *params*->tbid is non-zero, this value designates
> + *			a routing table ID to perform the lookup against.
>    *		**BPF_FIB_LOOKUP_OUTPUT**
>    *			Perform lookup from an egress perspective (default is
>    *			ingress).
> @@ -6881,9 +6883,18 @@ struct bpf_fib_lookup {
>   		__u32		ipv6_dst[4];  /* in6_addr; network order */
>   	};
>   
> -	/* output */
> -	__be16	h_vlan_proto;
> -	__be16	h_vlan_TCI;
> +	union {
> +		struct {
> +			/* output */
> +			__be16	h_vlan_proto;
> +			__be16	h_vlan_TCI;
> +		};
> +		/* input: when accompanied with the 'BPF_FIB_LOOKUP_DIRECT` flag, a
> +		 * specific routing table to use for the fib lookup.
> +		 */
> +		__u32	tbid;
> +	};
> +
>   	__u8	smac[6];     /* ETH_ALEN */
>   	__u8	dmac[6];     /* ETH_ALEN */
>   };
> 

