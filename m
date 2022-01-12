Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6556748CCB1
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 21:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357189AbiALUAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 15:00:35 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:32238 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1357373AbiALT55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 14:57:57 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 20CIVRTn020423;
        Wed, 12 Jan 2022 11:57:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=AdD47U6u4HmHJqQ7BmznViszx2sq2hD8hzydjGyNMPE=;
 b=TwaN514sgGM53QXO5vEZf03iP2YeHdvf4RuWTZH3vq1fG1S5yiVVd3o5eYDxT2t0Ihrh
 5Sz6jg1nlTENr6j4IybgItAUc5xkoJ2PO67JCTPdVFLHKMUK2HRaqfd1YA/IKNcZ9HbA
 ulH6EATi5R8o6Citb3IsfzKdMRgsMD2S+bw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3dj4b90hqw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 12 Jan 2022 11:57:39 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 12 Jan 2022 11:57:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sh+WTQC5o3T9ThvjTGPsB9tis5+uOMDnvXTvqHwAdh7CxiSEwpZPwHVeFlY9QKnm9BruqF51EZXHq0OLW0ENlzddIZfGbIWS7kEe9oQ6gowS7nnODxEKH57R7WATd5LytsfCy3FL8NHuf4ohSc0ol7RSjFnMzinuzT6pUF/gD3bmkS37r/jYNtOe8kZYQjOv0E+X/ny63mkTjJnfrlE/RCJrLvOvVREg9C3+FfM5NG734Cma2yB/Hlpax3av+lVD0iG59RLWqx9KtLmEKSZKTGVUg0e9gNp9AxmKNklF574xNYGbqVE20H4OPJvhfMizBjJpkab5GdUnahSZ5374ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AdD47U6u4HmHJqQ7BmznViszx2sq2hD8hzydjGyNMPE=;
 b=NeNOgaFP7b4uVPq+u7qZ+fB0hP1GGjcL5hQm//xJv69UtfIsC37QOxfZmTbif0sRGNne/RdPdzxPeiM77eECHdJLPn0SvNuvsacfgykrw2zJJfmk1xFgq7t0doDj/VTcvTKWqph8nLX55uzCqTz18Ohu8+DNuKZ4z9mNiJySrXy7V8CJ/jrKryDNm78X8ybVnKRyYkrti0NHLYHfgflFNa2F3faD+Hbhk3tD7BLymsnY9JAGJsHm6RRiJXAFX5eoyXZ0axu3FSZ3f7jnwrECL+HBye8MEb8hekRaTBTNwJPVs427WrrpFniOaSDC6B5VeHr+V96jxDxrWCw0Xgw3eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA1PR15MB4321.namprd15.prod.outlook.com (2603:10b6:806:1ac::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.9; Wed, 12 Jan
 2022 19:57:36 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::b0ca:a63e:fb69:6437]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::b0ca:a63e:fb69:6437%4]) with mapi id 15.20.4888.010; Wed, 12 Jan 2022
 19:57:36 +0000
Date:   Wed, 12 Jan 2022 11:57:32 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Tyler Wear <quic_twear@quicinc.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>, <maze@google.com>,
        <yhs@fb.com>, <toke@redhat.com>, <daniel@iogearbox.net>,
        <song@kernel.org>
Subject: Re: [PATCH bpf-next v5 1/2] Add skb_store_bytes() for
 BPF_PROG_TYPE_CGROUP_SKB
Message-ID: <20220112195732.4vlkuowaiyc4k24t@kafai-mbp.dhcp.thefacebook.com>
References: <20220111000001.3118189-1-quic_twear@quicinc.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220111000001.3118189-1-quic_twear@quicinc.com>
X-ClientProxiedBy: CO2PR05CA0070.namprd05.prod.outlook.com
 (2603:10b6:102:2::38) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 111c8116-6470-4113-526c-08d9d605c766
X-MS-TrafficTypeDiagnostic: SA1PR15MB4321:EE_
X-Microsoft-Antispam-PRVS: <SA1PR15MB4321C801C78452F6EBD309C7D5529@SA1PR15MB4321.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v1sJPl7A7FJ/WAinhn+vYwOCozVIqUj66qztLB1VHL1Xzx7UrLinNr1pENBb/Ol78z9UqKpnJYzTefG3y5ynQBYuUcFPIU5QZGsVPTJmJob64Vc+DilnPqf1qTrs8R/eRcHhQ/37F7J/gRG4SUKFmFPd04bVShE8SheeJdCkCVZ51WQlKUYn9QMTjRuNJrSWzaihfnF3cQmhDgeA2D2OFq+VvDpLx4aHfcOyGQq75He5JVJiJ2yOH79xQXQ7maoQiUaiS/Tkzw114St/D5o9zaAhMU7y51t4WbvOgStSY+9pBw+wsMw/qhoFpRPChV4ZJXGJHtsN02BEOZd29w7+cDpNCybqqnFCBIPHmfwGD9UhlVONJy3EkIfyKo/sqyS7UYvmqbHjH/TXs5nk8gFm+5Fbe+7p26KBcmBFgwL+euz9m/iD59/X56AVIm86PdD9IJottSxm3F3UuACtkCRywdGCNi191PIqirkdxSpp/4Y9zn8qhU6OvBY+omLuDfxP1/Ohq/IiNaM96vDwqWzPF2htL6ThMw38IKUpLwKNwGouWq6ik+v77LtH8QhJl6tc/P8/PmRqTJqAYu/9QvGgTF0GerBbXjuyBlstZJqiTPGoEvpYfVRvrZ/kX3PcgB6q+VQF3DKar1zGFe75WNsm1g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6512007)(9686003)(66476007)(1076003)(86362001)(316002)(66556008)(6506007)(66946007)(83380400001)(6666004)(6486002)(186003)(38100700002)(52116002)(8676002)(2906002)(8936002)(5660300002)(4326008)(6916009)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?U7fJf5tJxuzulahvuwvY8nqWGB/djzDdUzSXkIzKoP8RWpXt7AUyQccyjwLp?=
 =?us-ascii?Q?Onz3siOF2xt+5Ufk0vcELotj63evoADnLd1i4B1AgY4Y1gvpfSjuGLaT6ovQ?=
 =?us-ascii?Q?6a6and39oXofHrdwEWUiMQJyu4JLUxT72vLGGZEchFtdB695tdMXAXa0qYul?=
 =?us-ascii?Q?Mk0db157mdgN6a0EKoBoSEz62UFxgDByipLcI1A31BD9NOhvcbWTk1Vi5Sn2?=
 =?us-ascii?Q?gDkZwYT9ExaWacWZ9GcPTCVUwhLS1ucDI6y25phyQuiDQHYVxt7SeCjMMyBU?=
 =?us-ascii?Q?cNH5T7T8f6Q4L1VTlfCla2xLrf5nexzpwD+8GTpmHluxRjYtsxbKHIDgkBUK?=
 =?us-ascii?Q?TzbKwsezPWM6Fy7Q+apirUrWznGeB+VAI5iCB47ppqG4jpKP7YczqaHSkIsU?=
 =?us-ascii?Q?SyGSVhFPdGcLMLFmwt9zr4XY1TqgHdSoWS2sdNHIHyVUPQZS8dBs2fXClJPW?=
 =?us-ascii?Q?GSKjNcG+bs/fXtn3tjU79xUoi1kheRrI3bDOnNGN/9jyQnD9JEfoqbwun2rY?=
 =?us-ascii?Q?1NV4tDZ2diyPI9y2Lnej/R5KTNTYLwpmOhE85DSA2YRvb1UljZdJYDgfpi16?=
 =?us-ascii?Q?vfivW6cz68LTVirXWhybmA1A3f94l+8n8o5/6Vs+rpgPAjUtqhWAI2aC6Aig?=
 =?us-ascii?Q?rL+htWDm6kJokE7aUvtEjR8F/c5GV4xFffKMP5IWL/oIvAUSxOU+8np92KAl?=
 =?us-ascii?Q?8ttbJxR7hHyEsPTaYsLeldWo2cyrCGtTOsGNX/8ITsX7TfBAcZ5vmwQaHVom?=
 =?us-ascii?Q?ls/YlEBJA9DBYGTrxuBkYcPSEeNyBYRMhStafmO7WshWTSsk1XRYUnvAB18r?=
 =?us-ascii?Q?tiWXuiKNJ4WkiZplKaTL9dwraDlGf+rGKQnUxpKVU/Ds4z4M+J9lEQxU32Qn?=
 =?us-ascii?Q?BSvn6JdTuPopuIgit1+DB07lg5MA4gLxlC7CpsJITPWNcS1qEjMiWRH1b3rW?=
 =?us-ascii?Q?VdyobzoM6kn6cNHjO6IM3kDAHjZ8wcCo2WkPewiN4/ctf5cxPoA8GT5MMDTB?=
 =?us-ascii?Q?n3/hl+ZgIxzWbqZ1cz2lwUcp04x0o0+WORyVNB6q6+b2tJtwU31jRdntk4c2?=
 =?us-ascii?Q?bmziNoE0k/I0RevkfVwfdAf+A9wG53zgV66ponkJ1Fmmr/CXrcIjkt+3gNtQ?=
 =?us-ascii?Q?oZjNzlcN3dZeTIhIGzZY+S3MUaT5Gm0edeML+D2DSlWXTFDqDrpfdy7CtV4K?=
 =?us-ascii?Q?glVw7hDVVh1XfqIDs5ArOXzOdC4RGu0k3SWkUyD8C8u/iuD3OCulUEyxS5oo?=
 =?us-ascii?Q?ZSdKFkmz8dPRwA+H1HjieJT0R+/cVJkeXtFApbYnYvty6blPwLHTPPFJsiuF?=
 =?us-ascii?Q?LnAWWS+ZIpNp/aZ5RMoqJn0dU00fgNIg2n+4ihowRz20hjzNL3+7MkdbvQQR?=
 =?us-ascii?Q?5X31D0j3dJW2zkkTM5LCVzqeer1wnq6C9UmlJLnA94nSSETnuqTlk9TpNRgy?=
 =?us-ascii?Q?BBl0BsZYOjYUBe2RVUQqgh9mjtfRKYLVXT8I1BfcE/y96mQy5u3bBN8jLWlx?=
 =?us-ascii?Q?fPM80gip7iWGZ82TJ88GCypmjIi8OdA6kWVKWkiIHnYYxt/SqPw9OKdWBim5?=
 =?us-ascii?Q?iyBs4h+73y/G+b8gXozGq5/DlLXgg/mVp2GHTFz+?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 111c8116-6470-4113-526c-08d9d605c766
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2022 19:57:36.0219
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0U1Sb2aKBaQ6tSl/qk/BW54K13pZzDuorLmQisoxfScbcfHHWkNhvhq+4qz2+UeX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4321
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: XTm9NjhwOWsKQX9qV-NjcScnnzZk5omx
X-Proofpoint-ORIG-GUID: XTm9NjhwOWsKQX9qV-NjcScnnzZk5omx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-12_05,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 priorityscore=1501
 impostorscore=0 suspectscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0
 spamscore=0 malwarescore=0 clxscore=1011 phishscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201120117
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 10, 2022 at 04:00:00PM -0800, Tyler Wear wrote:
> Need to modify the ds field to support upcoming Wifi QoS Alliance spec.
> Instead of adding generic function for just modifying the ds field,
> add skb_store_bytes for BPF_PROG_TYPE_CGROUP_SKB.
> This allows other fields in the network and transport header to be
> modified in the future.
> 
> Checksum API's also need to be added for completeness.
> 
> It is not possible to use CGROUP_(SET|GET)SOCKOPT since
> the policy may change during runtime and would result
> in a large number of entries with wildcards.
> 
> V4 patch fixes warnings and errors from checkpatch.
> 
> The existing check for bpf_try_make_writable() should mean that
> skb_share_check() is not needed.
> 
> Signed-off-by: Tyler Wear <quic_twear@quicinc.com>
> ---
>  net/core/filter.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 6102f093d59a..ce01a8036361 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -7299,6 +7299,16 @@ cg_skb_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>  		return &bpf_sk_storage_delete_proto;
>  	case BPF_FUNC_perf_event_output:
>  		return &bpf_skb_event_output_proto;
> +	case BPF_FUNC_skb_store_bytes:
> +		return &bpf_skb_store_bytes_proto;
> +	case BPF_FUNC_csum_update:
> +		return &bpf_csum_update_proto;
> +	case BPF_FUNC_csum_level:
> +		return &bpf_csum_level_proto;
> +	case BPF_FUNC_l3_csum_replace:
> +		return &bpf_l3_csum_replace_proto;
> +	case BPF_FUNC_l4_csum_replace:
> +		return &bpf_l4_csum_replace_proto;
BPF_FUNC_csum_diff should also be added to support
updating >4 bytes (e.g. ipv6 addr).
