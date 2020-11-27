Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDE72C602C
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 07:32:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387557AbgK0Gcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 01:32:39 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:31590 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726721AbgK0Gci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 01:32:38 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AR6N5sG032013;
        Thu, 26 Nov 2020 22:32:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=24vRWPCu76bSfpjZY9u+LLPi3Zx5abbsLSkZzBE5DdA=;
 b=ByBwNQf5bEb4bwVsyNOtQcfJFnDurSK179fuD2/nC+iaqkeVlOJmlgL8Q/zOwdG18Sgg
 I46l4lCIyLTWdKvqcmDoTXAaOQ7koAbN8evZIUlTUNLWrj5h2Sp0Bc7HL2WiV22HkK/g
 KdcBLTeF7j48GzgzQNxIaaUB8wq8hA+UZA4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 352pa3s155-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 26 Nov 2020 22:32:03 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 26 Nov 2020 22:32:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T2MRJJ0DME/Pv4O3dlhq7ImPV6RMXA0JFjiv/xTERv9mbi6HNtMnTjZEtKPWUDgsjizZmcDBJdokXqYngVG+65LD+ecK092Fhnjvu5kJvJdFicNgmF9kZBlOpoRhhVMEKv4iCAYDoFyw7OVwbXNUifdYO7Oiap7/Pqx7kvi8a4tu1RNSGxCDtH3fgBfedFdjGaG4vaJgIdp1Hf/urfq3sijqowXPFmthvRD98ME0VmyCA/dAGP4HabHOGYtGLaq90TG6MrnpQZlRRxThF1PhNWz6HRa7pPH5e2IkTDKnpGlgJlxBIYvHOlmMZfsXIgLwfR+SfKHQNg1WTsYFtfh9Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=24vRWPCu76bSfpjZY9u+LLPi3Zx5abbsLSkZzBE5DdA=;
 b=cedAwsTweNZnoAG72PlenwoXqqrSphIFODoHPgEL7qBYBYqgsBrwCx0dDNVjSTbRPR68QZ9/J/835GET2yk+1INWEdKykz109wtXUWUU+srdI3P93ct8oQS2NMyPD41vUy9/8CS7WA14moQDJGjJzAxdfmEFcloSM5OwLfYj8vjpXKkYgcymnhVXGeecmx83DIlKisEQD0C9mzO/t0KXCqGGUsKTlGy0rPZ1G3boV6N6tUs+umHCJmhUliQbUvWffPqriGTcMOsQ5T/X5yUJKh+qHhmr06rpp2n8h3/K1+eea/JrPUI4BWL4DA/anqT3ovYXIiepwSX42RYzvThjtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=24vRWPCu76bSfpjZY9u+LLPi3Zx5abbsLSkZzBE5DdA=;
 b=S855Qtje9fdvTZJrj7smtp9lUJQp8bUvAY7aEz+4tprGlI5pCXZfGJ3B16UTSwioptxePiX/hWww934IaQEEC21a8o0v4PUB06Rq2h1FjhcI+Lt0cT6LbNgWbX9VdrrD9XsSzedw97Oz3hC+ApZoa9SIrsY3ULpC7VyXSQqZn8g=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3304.namprd15.prod.outlook.com (2603:10b6:a03:10a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.22; Fri, 27 Nov
 2020 06:31:59 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3611.025; Fri, 27 Nov 2020
 06:31:59 +0000
Subject: Re: [PATCHv2 bpf-next] samples/bpf: add xdp program on egress for
 xdp_redirect_map
To:     Hangbin Liu <liuhangbin@gmail.com>, <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
References: <20201110124639.1941654-1-liuhangbin@gmail.com>
 <20201126084325.477470-1-liuhangbin@gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <54642499-57d7-5f03-f51e-c0be72fb89de@fb.com>
Date:   Thu, 26 Nov 2020 22:31:56 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
In-Reply-To: <20201126084325.477470-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:7e72]
X-ClientProxiedBy: MWHPR01CA0027.prod.exchangelabs.com (2603:10b6:300:101::13)
 To BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::1008] (2620:10d:c090:400::5:7e72) by MWHPR01CA0027.prod.exchangelabs.com (2603:10b6:300:101::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20 via Frontend Transport; Fri, 27 Nov 2020 06:31:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc63f6ea-f070-48fa-9bd8-08d8929e24c4
X-MS-TrafficTypeDiagnostic: BYAPR15MB3304:
X-Microsoft-Antispam-PRVS: <BYAPR15MB3304AE1525B55E34EF1ADEFED3F80@BYAPR15MB3304.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:343;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kTHR6bi/LkyAz/B15luuXbb98nZWG5G/w0YQjo2QGk/tPgFpWXisD6cd5IR8nCkw3nqgjLwEbl4rUwi5ZSA2a+tONa6UagrPZoBNHY1aEk1xk7/i5inMW7SY9dumNyUWKHEjrRJhIPnCaueUV5lglJbSXy7sST6dl6VrSWiwUWioDlsi2Ai4Afx2mKm4jf9wtByTy3NSTr+DlPOUSmKrmqeeKfV1eOZus9un3BYA9RMtRjOsbRpTN1U8G+RSLbKRyqkIHf3QO9US9zXxIuscKQPlIpBfaSrUbOs6x+avwrIEfs+HWiZGmZrgWTxeGrj0gH92R3JOzRithTk7OepA/6mj08KSDz8wAZGEf01oDLSmnoSh//xCuyXiI0/etd4n
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(396003)(346002)(39860400002)(136003)(36756003)(86362001)(478600001)(31696002)(5660300002)(4326008)(8676002)(54906003)(2616005)(2906002)(52116002)(8936002)(16526019)(186003)(83380400001)(53546011)(6486002)(316002)(66476007)(66556008)(31686004)(66946007)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aFFVTjB2T1RaSUtud0Y5N1Nqb0hHeThiZll0S0NzcXBRZ3FGQjN3cS9FOXg5?=
 =?utf-8?B?cXJCS1pzdzNoUnYrTHFycjV1TG5IUGhVWGFWOURnY0pFWXVRZ1hTL25TdDBL?=
 =?utf-8?B?QVJyNW1reG1wK011UnFHL2o5U0FBWDYybGtWcTh1S1c0emdoekVZQU56YTkw?=
 =?utf-8?B?VjZyUk84Yzl3UUJEeFBDaWp0WXhFdXY4MTczb205RytCdStQeW9HOVowVmFu?=
 =?utf-8?B?T1ZUTkxWRWtLUjkwY29NVmxpbnUrSkFGQW9EanlMTUhqb3Y0QVF3MnlkMVZz?=
 =?utf-8?B?c0FITUJKbmc1VjlkN0hoQ2JlbjdWYVFNVkROSFN1bDJ1bmlXV01tY3RoUTVM?=
 =?utf-8?B?eTB6ZDdMbkljUTJTYnZ2VWVOem9GeXkvOUY4V2Y1RUpRdWlmTzVGY21hTHlx?=
 =?utf-8?B?OVl3eGtSRUxCY3V0YXNtU0lybDlUbzdCYitkNjFkTzk4L2o1Z01HY3JOaC9C?=
 =?utf-8?B?dHY3aHdIb2dRZG5adlViZkw2TEgxcmRyN3grckdsL2lJdGpCZm9aV0paTlZK?=
 =?utf-8?B?Nks4ZGlvL3FsdXhsaXNtLzNpWFJ4MDlQSEl0TW1hWjRyQjVLQ29KMlRHejVR?=
 =?utf-8?B?bWFoNERLUjRrSTBkY3N4OTZIQXVrTDNTNW9sUDZLS1pGeWZoR3ZtR1dCYUx2?=
 =?utf-8?B?VmRIdVVtMnY3Qk0vSlpjM2VGL1AyamFtZldkOHArejUzaU91WkM0UEFwUHND?=
 =?utf-8?B?RmNxN0lpaEZ5c1BYU0wzeUZadVhEWTI2U0ZMcTc1YmZyN1RKTWRMRXd2Z0E2?=
 =?utf-8?B?Wm9QQ3NhZGc5azIzUmhSSTlLcXkza0hCZjhvWllsNGFUeTh5TnNlNTE1a0FZ?=
 =?utf-8?B?ZGFzTFpUZ3hSeUJKSlZJamRRSW5JMWFhcXlrd29ZZDRwd1k5c3BiNzNKTjkr?=
 =?utf-8?B?Sk9uV0RjR25TRTZTZ3VpaE8yWkhDSzFsdnlBeGhKRkVqSFRzR0w3Ri9XbHd5?=
 =?utf-8?B?SktMcDdXZ2s5Rm10QlJMdGFpZkJIY0lnV3I2ZnRtZXYyQVM3K1BmMVZqd1dk?=
 =?utf-8?B?SVBFQWJzSXFEcFNoR0lXRUVQUDhDZ1IxNUdqejRTZlRvZGExVDdQa1R2RzZw?=
 =?utf-8?B?NkNhM3p3c1Z1bG83ZXlZaHZJMU1weG9XK21ENEdiWmtZdlBhQ2NFN0g1N1gx?=
 =?utf-8?B?UmdtVmZJcFNpaEQ1T2FTUDY1b0s4YWFVZkF2djBULzRsVWdPazhvMjJObXZ1?=
 =?utf-8?B?UFFUMTNGd3d2cU50MzIzN29HWFhCTXJrQ252VUZUSi9CUXBaTmpwbXlTanVF?=
 =?utf-8?B?djZ4VVpzaFFpMUpCd1ZZVHJ5SGZUaEcvV0hEbEdPdEhOakxNb0FyRU9NZzlC?=
 =?utf-8?B?NHFqV0tmdDg0VHZWem5ValhTSUpPNHB5UTJrYitMSUhDVmMrOUFFVS8vNFFw?=
 =?utf-8?B?SUZBQ1ZiSzVxVVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cc63f6ea-f070-48fa-9bd8-08d8929e24c4
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2020 06:31:59.4476
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kicwwrzTDR0mrkGgwLsPTdQynNVtUVIcoVL4iatmtpHUZb2S2lqRzN4Dkvl157Vn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3304
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-27_01:2020-11-26,2020-11-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1011
 adultscore=0 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 suspectscore=0 mlxscore=0 spamscore=0
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011270037
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/26/20 12:43 AM, Hangbin Liu wrote:
> Current sample test xdp_redirect_map only count pkts on ingress. But we
> can't know whether the pkts are redirected or dropped. So add a counter
> on egress interface so we could know how many pkts are redirect in fact.
> 
> sample result:
> 
> $ ./xdp_redirect_map -X veth1 veth2
> input: 5 output: 6
> libbpf: elf: skipping unrecognized data section(9) .rodata.str1.16
> libbpf: elf: skipping unrecognized data section(23) .eh_frame
> libbpf: elf: skipping relo section(24) .rel.eh_frame for section(23) .eh_frame
> in ifindex 5:          1 pkt/s, out ifindex 6:          1 pkt/s
> in ifindex 5:          1 pkt/s, out ifindex 6:          1 pkt/s
> in ifindex 5:          0 pkt/s, out ifindex 6:          0 pkt/s
> in ifindex 5:         68 pkt/s, out ifindex 6:         68 pkt/s
> in ifindex 5:         91 pkt/s, out ifindex 6:         91 pkt/s
> in ifindex 5:         91 pkt/s, out ifindex 6:         91 pkt/s
> in ifindex 5:         66 pkt/s, out ifindex 6:         66 pkt/s
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
> v2:
> a) use pkt counter instead of IP ttl modification on egress program
> b) make the egress program selectable by option -X
> 
> ---
>   samples/bpf/xdp_redirect_map_kern.c |  26 +++--
>   samples/bpf/xdp_redirect_map_user.c | 142 ++++++++++++++++++----------
>   2 files changed, 113 insertions(+), 55 deletions(-)
> 
> diff --git a/samples/bpf/xdp_redirect_map_kern.c b/samples/bpf/xdp_redirect_map_kern.c
> index 6489352ab7a4..fd6704a4f7e2 100644
> --- a/samples/bpf/xdp_redirect_map_kern.c
> +++ b/samples/bpf/xdp_redirect_map_kern.c
> @@ -22,19 +22,19 @@
>   struct {
>   	__uint(type, BPF_MAP_TYPE_DEVMAP);
>   	__uint(key_size, sizeof(int));
> -	__uint(value_size, sizeof(int));
> +	__uint(value_size, sizeof(struct bpf_devmap_val));
>   	__uint(max_entries, 100);
>   } tx_port SEC(".maps");
>   
> -/* Count RX packets, as XDP bpf_prog doesn't get direct TX-success
> - * feedback.  Redirect TX errors can be caught via a tracepoint.
> +/* Count RX/TX packets, use key 0 for rx pkt count, key 1 for tx
> + * pkt count.
>    */
>   struct {
>   	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
>   	__type(key, u32);
>   	__type(value, long);
> -	__uint(max_entries, 1);
> -} rxcnt SEC(".maps");
> +	__uint(max_entries, 2);
> +} pktcnt SEC(".maps");
>   
>   static void swap_src_dst_mac(void *data)
>   {
> @@ -72,7 +72,7 @@ int xdp_redirect_map_prog(struct xdp_md *ctx)
>   	vport = 0;
>   
>   	/* count packet in global counter */
> -	value = bpf_map_lookup_elem(&rxcnt, &key);
> +	value = bpf_map_lookup_elem(&pktcnt, &key);
>   	if (value)
>   		*value += 1;
>   
> @@ -82,6 +82,20 @@ int xdp_redirect_map_prog(struct xdp_md *ctx)
>   	return bpf_redirect_map(&tx_port, vport, 0);
>   }
>   
> +SEC("xdp_devmap/map_prog")
> +int xdp_devmap_prog(struct xdp_md *ctx)
> +{
> +	long *value;
> +	u32 key = 1;
> +
> +	/* count packet in global counter */
> +	value = bpf_map_lookup_elem(&pktcnt, &key);
> +	if (value)
> +		*value += 1;
> +
> +	return XDP_PASS;
> +}
> +
>   /* Redirect require an XDP bpf_prog loaded on the TX device */
>   SEC("xdp_redirect_dummy")
>   int xdp_redirect_dummy_prog(struct xdp_md *ctx)
> diff --git a/samples/bpf/xdp_redirect_map_user.c b/samples/bpf/xdp_redirect_map_user.c
> index 35e16dee613e..8bdec0865e1d 100644
> --- a/samples/bpf/xdp_redirect_map_user.c
> +++ b/samples/bpf/xdp_redirect_map_user.c
> @@ -21,12 +21,13 @@
>   
>   static int ifindex_in;
>   static int ifindex_out;
> -static bool ifindex_out_xdp_dummy_attached = true;
> +static bool ifindex_out_xdp_dummy_attached = false;
> +static bool xdp_prog_attached = false;

Maybe xdp_devmap_prog_attached? Feel xdp_prog_attached
is too generic since actually it controls xdp_devmap program
attachment.

>   static __u32 prog_id;
>   static __u32 dummy_prog_id;
>   
>   static __u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
> -static int rxcnt_map_fd;
> +static int pktcnt_map_fd;
>   
>   static void int_exit(int sig)
>   {
> @@ -60,26 +61,46 @@ static void int_exit(int sig)
>   	exit(0);
>   }
>   
> -static void poll_stats(int interval, int ifindex)
> +static void poll_stats(int interval, int if_ingress, int if_egress)
>   {
>   	unsigned int nr_cpus = bpf_num_possible_cpus();
> -	__u64 values[nr_cpus], prev[nr_cpus];
> +	__u64 values[nr_cpus], in_prev[nr_cpus], e_prev[nr_cpus];
> +	__u64 sum;
> +	__u32 key;
> +	int i;
>   
> -	memset(prev, 0, sizeof(prev));
> +	memset(in_prev, 0, sizeof(in_prev));
> +	memset(e_prev, 0, sizeof(e_prev));
>   
>   	while (1) {
> -		__u64 sum = 0;
> -		__u32 key = 0;
> -		int i;
> +		sum = 0;
> +		key = 0;
>   
>   		sleep(interval);
> -		assert(bpf_map_lookup_elem(rxcnt_map_fd, &key, values) == 0);
> -		for (i = 0; i < nr_cpus; i++)
> -			sum += (values[i] - prev[i]);
> -		if (sum)
> -			printf("ifindex %i: %10llu pkt/s\n",
> -			       ifindex, sum / interval);
> -		memcpy(prev, values, sizeof(values));
> +		if (bpf_map_lookup_elem(pktcnt_map_fd, &key, values) == 0) {

When we could have a failure here? If it indeed failed maybe it signals
something wrong and the process should fail?

> +			for (i = 0; i < nr_cpus; i++)
> +				sum += (values[i] - in_prev[i]);
> +			if (sum)
> +				printf("in ifindex %i: %10llu pkt/s",
> +				       if_ingress, sum / interval);
> +			memcpy(in_prev, values, sizeof(values));
> +		}
> +
> +		if (!xdp_prog_attached) {
> +			printf("\n");
> +			continue;
> +		}
> +
> +		sum = 0;
> +		key = 1;
> +		if (bpf_map_lookup_elem(pktcnt_map_fd, &key, values) == 0) {

same as the above, if bpf_map_lookup_elem() failed, maybe we should 
signal a failure?

> +			for (i = 0; i < nr_cpus; i++)
> +				sum += (values[i] - e_prev[i]);
> +			if (sum)
> +				printf(", out ifindex %i: %10llu pkt/s\n",
> +				       if_egress, sum / interval);
> +			memcpy(e_prev, values, sizeof(values));
> +		}
>   	}
>   }
>   
[...]
