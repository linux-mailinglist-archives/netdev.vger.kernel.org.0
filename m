Return-Path: <netdev+bounces-8661-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A073E72519D
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 03:40:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 083802810F3
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 01:40:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23B0763C;
	Wed,  7 Jun 2023 01:40:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055957C;
	Wed,  7 Jun 2023 01:40:33 +0000 (UTC)
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1815E199D;
	Tue,  6 Jun 2023 18:40:32 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 356IfbCx023703;
	Tue, 6 Jun 2023 18:40:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=MzdJMzB3Z4poX+vCaBrJBBaPdS61Jr5mBMXvskl7Ijo=;
 b=QS+ZfJe4VMERS1qWuLUL2qBvY5/DvVc7F5+GG6zkFxX0LJLQBysRgqGU+WRA2SYbpA+B
 1LnkoshYphH8fp10sNvJ4o8vpyHLY79Hsdw1YtbX+Ub9Wy6J9DYgYfVlH+sehHIcUvpM
 pYbjB3bB0ZXwGbl82PxRpXOsqb1Qrugn5gnCKc94+wa968YMsTlZnnC6wzMO0FD7dEly
 JGiAYlx+alGaHzADLqEf3wLCmKaaSBb0bWvsSSOuyGByKCiy8zzNEknPehxgZvKhwpjg
 R7WObAISiVyEC21pmO2/cESuTLswK/8MhMISvRwmS2NaLXTUJhULKPxTxtzi20tqoKgS Kw== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3r2a9bae7u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Jun 2023 18:40:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V9o7c1Y3hoOeQcl2c4JylgCoeUJGOYb8bz5PSFzuzWgKeYoJHXA+D4OsFs4vT1kblSTTsjmDNclspcC7FRuGL5obfKOoZJTxpfShIW7IlVSi2oMzqR124CEYV705YCzLxhbP8lWjJybF99VNy7jyD/EL8VHVUBvQRx5a1qHJoMz7Uc2dYqjmqNB1TGK5j736/0huVvGIJyFy5DUcaFQnRKExFS6B+d7qGu2L+vqd8NAT3I0X8i411ypeYnE4XT0wma7qfwtrlaSgYFz0Wl3ye3gLigGi5IfZgfELuJfdvkMp2yK++mC3eAdFQvrbUnBiiqsghipEe30a3dFo44WODQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MzdJMzB3Z4poX+vCaBrJBBaPdS61Jr5mBMXvskl7Ijo=;
 b=mg/2VzCFqTZ1BAoRRYkRh+C3m3/tYLj4SwtnTkm7W1dBhE1M09iw+s97htgKRzXu0qmb8LDHNaAMnm4hSPBtw4y7/dasaXSleY6JlLggHy7kvO/EPUNcEcDO2u8hnedO3Ovw3m7GVTNKGyXmhEzSLI4FdU/LmEKKVLKYf0XlovhtEzuJhSMflVXb3jeZT3CcxCmWcFD9hVcBvXFmeY7cqpXq1GnJkmr/n60zgnVCROtn8+b9AZGJ9ajfsnn9wZAuLtygecHJsi5tNkuFdVWWe+6U8NUlgWb7OgkcT4sQIMlBLU/9Tv7szHFJ6tRkavGCbMzkdj6WyUlAyuryyRJlGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SJ0PR15MB4424.namprd15.prod.outlook.com (2603:10b6:a03:375::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Wed, 7 Jun
 2023 01:40:10 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::bf7d:a453:b8d9:cf0]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::bf7d:a453:b8d9:cf0%6]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 01:40:09 +0000
Message-ID: <959b03dd-6672-228d-9205-f543374977a1@meta.com>
Date: Tue, 6 Jun 2023 18:40:05 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
Subject: Re: [PATCH bpf v3 2/2] selftests/bpf: Add test cases to assert proper
 ID tracking on spill
Content-Language: en-US
To: Maxim Mikityanskiy <maxtram95@gmail.com>, bpf@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Eduard Zingerman
 <eddyz87@gmail.com>,
        Maxim Mikityanskiy <maxim@isovalent.com>, Song Liu <song@kernel.org>,
        Yonghong Song <yhs@fb.com>, KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>, Mykola Lysenko <mykolal@fb.com>,
        Shuah Khan <shuah@kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>
References: <20230606214246.403579-1-maxtram95@gmail.com>
 <20230606214246.403579-3-maxtram95@gmail.com>
From: Yonghong Song <yhs@meta.com>
In-Reply-To: <20230606214246.403579-3-maxtram95@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0077.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::18) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|SJ0PR15MB4424:EE_
X-MS-Office365-Filtering-Correlation-Id: b2937e71-92ca-4333-71b5-08db66f82129
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	uAQkwn+33TWqQT7KuYzNmlaJMQEP0nBdVV0ZY/kUSxYJxcAcN5dh9aOH64gZ8F1JLY0k50eWSJmSa9CUvjSlz0Yk2Xiubc+r25NO7edVOTdICstZ1nRE2VrgW5O3KgxwaCTMkNi/YzPxqzi2VHtLMYsOKphgiEUfGp7ZkR1HJMbDQwGzHdzlNmErQXgbAGY3C/Jj/GNRCejhM6TFhKF9gAFrSH/N6AqzOsUk6RMY7qQLqRhzgFGZcZJP7+77VOyQyUjj4NW4+4n1EA04mRI6/mzFKsNESXwyzasjR3iTLDPiUlvaYV3tjsDl3SecfMBCW98YU5nN28PaiskFHarWPAfH4V6Ll6KgjwNubLy1mxBolts4EN8hOGiQkKISAy40Z/2/ahD20ogDkRuo125KQwrdK27HB4e3S7XJi5y6T+Zk60g04p7vPeXiPqAA8sQzMp0r2x11Nb+fTaxef8ugEr1c0Kv6yttdtbsE8O7dNFXVK/XrN1FwBhhL/Qt8egGksV8sWjIA72hYiX6CSDif6hqaLH/Ul22JvXtLxDLfhILX982LvdqKeJnpk2pqertmZZ1QSaGhh9n78IYlhxRZDzJ9t/v0edJ9+mX6qk70Rkdicfp1Am8d4x6dOxv6vmQBXkQgEuVoYS9kIxEa9YRoLw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(396003)(39860400002)(136003)(366004)(451199021)(6666004)(36756003)(6486002)(2616005)(31696002)(86362001)(38100700002)(6506007)(6512007)(53546011)(186003)(8936002)(5660300002)(8676002)(41300700001)(316002)(7416002)(2906002)(4744005)(31686004)(54906003)(478600001)(66946007)(4326008)(66476007)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?U1ZxeFVsZG1xVFpmMlBuUElkN21ndnh5TWRtNThPb0JpMWhGQUhKZThqUUlU?=
 =?utf-8?B?dStOLzMvaDBGMDZ2SlVqS09Td2VLUENVRTNNeWJlYTRwd3BucHZsTTNrRHBi?=
 =?utf-8?B?RWw5NEpoekR3TmFxK3NQaTVncmJKektpOEpReWpyTWp0OXF2RVVZZW03OVFO?=
 =?utf-8?B?UnNpOFpnMkIwK2ZlaTV6MXV4VVRpN2dET0tKT3NpQmkzc1VBb2FPckxXZ2lh?=
 =?utf-8?B?OEdqUFA5MlFjdmhkVHIrYXBRVWpTN3VHTEg1YldjaHVPcFZPNWVocy9GazZn?=
 =?utf-8?B?c1g1dzNSUGlNbnZIOFYxVXhQdUNiZ2g0TWtuMlZvMXJiSkw4WHU0U1dabEpr?=
 =?utf-8?B?RXlGY05VUmtRdktnbVpnd3JzaVdFSW04RldYZnA3TkpVNzZJYWxlaC9mWDBu?=
 =?utf-8?B?U0xLR29USUpKVDVTb0tXQnhHSExuek5WU3h4bVpTUGR6OXh5RHR5aVdHNWNO?=
 =?utf-8?B?OUFnRU5YNEprY2Q2RldRWnRTcUlLWVNwWGV3bXpFQVllYWZIaXRiZ05Sb3VZ?=
 =?utf-8?B?VDlhb28zL3E3bGdReURuN2dURlZ4clRCcTlsZnMvc1Y2dkd0eWJ6VDE0Q2d4?=
 =?utf-8?B?MWFtR3djRDVhanpkdXR2VU5vK2hxLytld2wvemtPQ0tDejVmemNyeExxRHln?=
 =?utf-8?B?M0VBWVdJbHJiR0wvVk4zcWdGYXg5RVVJbWpnRG5WTGNhS0RLK2lBZ0Z4VCtK?=
 =?utf-8?B?TWNtWlYzUmlaTUEzbGxobTFmN1gyK2N3U3B6WkxBbjB4Wmc1VlBVaWpWQUxY?=
 =?utf-8?B?VVhtL24vUEdjZDNFZkIyUmZtUEdUMyt2QUdOWFNmRGtiR1BsYWcrOGdyclMz?=
 =?utf-8?B?T1BURjJHcHd6Z2RCSnRYRnFPNlFnVUVjeXgwYnIwTm9DcGlJSmgyL1BTbUpN?=
 =?utf-8?B?b1drVU8vMWdZcDhYWmI5TGlxZnh1K1Z5MlFQeVZHN0VEUWdydTBVRHpQNmxs?=
 =?utf-8?B?NVpJb09rWHlLRncraEhMSmFOYjlwaWx0bnM3elZ1SHdabmt4OVVLSnZFNlpo?=
 =?utf-8?B?d1ZKVEZqcEhTeklIN2lYZjhWY3p2YWlNY1JHZ3g5czNRRWFiT1ZTRllUL0tO?=
 =?utf-8?B?Sm83eVVNVEE5V0tBWm54bko1S3Y4bVB6cU4xc2VVSzJDb05hMW1PTEFJaFR4?=
 =?utf-8?B?SU1Kc1pVY2V6Z0RlckVobm9PYXpJWDBoQ0szd3ZlN1NLNTFrYXY2Z3o3d1Jj?=
 =?utf-8?B?dURrZUhlNEN5U2tHZnlBM1FQTGNTNTFJbWQ0S2lTK1JBYXNjUzBZVDBrekVI?=
 =?utf-8?B?NUNlK1RCcXlVVEhDcjZiN2p3NEM3VXYyUWd3WVFDYXY3cVpva1RkdjRNTmIz?=
 =?utf-8?B?b21FQThiMGd5cW5rM21DeXdHMm5jR1JsUWc5WllVQmF4cHJMc041OEJkT2dZ?=
 =?utf-8?B?Qlhvb0J4Um5qbFU2QXNVWXVKMC9kSkxua2JkWkdiN0FXVXZEOEVPbkFRR1Fv?=
 =?utf-8?B?ampjeml4WXQ4UVRVSitmUGtuVkc4QjBQcTNQU0ZzZ3Q3VnB3RWtDdjhFOUFL?=
 =?utf-8?B?ZVQ0a3lMZjdJL0Nhd1djbTAzZVloTmV2VHozRU5XYlZFdjFpUHREa21tNUdR?=
 =?utf-8?B?MWQvdEZzcGxZOXdJREtudzBOZytSY1luRmhNd2FlTVk2OGhuU3V3VHE4SEwy?=
 =?utf-8?B?QXFSa1pTblVwUUlGTVI4eGNITkZPNVBFRFd0cU5BT2VCMUNJZUs0TXB3UXVj?=
 =?utf-8?B?dkM1cGpVOXNScUE1Rk5jWjVNWXpSMVpwTkF6MzN2YnNJU3NTUDdSdnpPYU1s?=
 =?utf-8?B?cHhJL1phcUp4SFdVRU0xTEpZcmR1RXBHTDBzQll3TE1UaDhYc2xUc0xiZkFP?=
 =?utf-8?B?MGVUZG5vOGRtNlJSS3Yxck96eGxSdklibGhFSTdqTzQ2L2ZvcUxCVG51WnZl?=
 =?utf-8?B?TWpWbVMxcjVoSjA0b2pocE5GekdPNEtZa2w3ZjUyQkR6WXQ0MHJiUTFKWW1r?=
 =?utf-8?B?eHVHWjEvcnd3dXhFQVlkR3MxZ2RNYlZXVnkzQ3ZndEc1VGpuUFVqR3h3M3VT?=
 =?utf-8?B?eHUrVGEreFZSNjRHZEtaMDhWQVRLZ1k4b2dmQmRncTVvbEFNc252SXh2VVlZ?=
 =?utf-8?B?S05kTW95QmV5YW9aVTZIaE90eHU1R1N2UFgzVkNpMzlqNkZUcDhmTks2ditB?=
 =?utf-8?B?THRpdndvSHhJUldNOXcwUTZsZE9ORzlGVnpWRVRhdk9LQWp0N3VxMTBGcUM2?=
 =?utf-8?B?c2c9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2937e71-92ca-4333-71b5-08db66f82129
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 01:40:09.8674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ltN127VpebJgmoatocCXLGgES8g3MoE7F17s9tg4XNho4IYLHRsdUOdsEeEOPnBD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4424
X-Proofpoint-ORIG-GUID: rz1lEM1qZnxhUqofPggMfMpj_Ij-pQLO
X-Proofpoint-GUID: rz1lEM1qZnxhUqofPggMfMpj_Ij-pQLO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-06_18,2023-06-06_02,2023-05-22_02
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 6/6/23 2:42 PM, Maxim Mikityanskiy wrote:
> From: Maxim Mikityanskiy <maxim@isovalent.com>
> 
> The previous commit fixed a verifier bypass by ensuring that ID is not
> preserved on narrowing spills. Add the test cases to check the
> problematic patterns.
> 
> Signed-off-by: Maxim Mikityanskiy <maxim@isovalent.com>

Acked-by: Yonghong Song <yhs@fb.com>

