Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83C874A9DBF
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 18:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377013AbiBDRiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 12:38:03 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42516 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1377016AbiBDRhp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 12:37:45 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 214H6r7L009832;
        Fri, 4 Feb 2022 09:37:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=GMxjwAJX4tOM2EIxO8H61Su09yqXpmkkKKj1qxjbZg8=;
 b=GD6xD24jqr7IJW+ktnOYKInSSiFKNuI0sHk0qX3dbcr74KVVeRqGgP5Vm7HexPw0GOzm
 CkDlYTq6MIARNcSvbWJy4P9+90HdRt3N49wtEiC0t84xXPbS+BL2ZhvVUGVzyDjxVWZa
 7bEeOCeXNPvll2FQpEAbbKD/B+HvNr2h6mE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e0w2fuqwy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 04 Feb 2022 09:37:28 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 4 Feb 2022 09:37:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RwCPlUje7jdwgKs2qO58vS7jdXpiyP8R2rPfgmpHv3cneQliWYQAXnyoXbPU5kcwDzlg9qyem5ozbFn6fI7USwUCvuCPOJTVoRpMu/ZXk02YFOBm97/FxxqpjT7m30ZvB7PrHIOo3Od+mbpJ+t2nPcaqQjr2DHW5H7Ru6ECAPXBxZJyFjJIfu+Pp4qWgykYQ3IUSfYrRAK4FTiwDcuMG839XcbP+jMnXs3dVa2Vkdd9Vlyy34n4z2fkb9N2PEgUWcStDlDkV+kbRA/xUOjidyNSHYWzAvaIvgbRB4KAQLukefhUZ8zL8IIODiFg07vKn48RyNbN78ZJwTvukUTsJkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GMxjwAJX4tOM2EIxO8H61Su09yqXpmkkKKj1qxjbZg8=;
 b=LjY19C5zTKn2c/jC5CcUTizDes/TR5wxRq0XizXB8Kh0zGTfXnaH+hW0lSJ8kFFOxc/+XmkwnhXXIzNKVjMVvkU8fFlbncR39+RsIQhCm1RxhZ08Uq3eFUYYT0mqQJb0itIfnJJr7O5RkX86mgL21nCazvSxr6FMl/B33rlMXSE82T4Ro879Ms7UUYuu/iCfsI4QdrdMT2Z/OPe/InITuquO7z7MJPfyTPf9xtv3sXBtD1+1S5kYX/xyfkMvV6/kpzHCPMMpJejg/WA5wH8+yLVsdbLVNu6xA8aOSoUoPIILNLzJwdLJe39ISoBKYwVnGAgY7zP+LhIIuRLRydGXJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BN7PR15MB2452.namprd15.prod.outlook.com (2603:10b6:406:87::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.14; Fri, 4 Feb
 2022 17:37:26 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::11fa:b11a:12b5:a7f0]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::11fa:b11a:12b5:a7f0%6]) with mapi id 15.20.4951.014; Fri, 4 Feb 2022
 17:37:26 +0000
Message-ID: <c3858f6b-43d5-18ef-2fc8-b58c13c12b05@fb.com>
Date:   Fri, 4 Feb 2022 09:37:22 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH bpf-next] selftest/bpf: check invalid length in
 test_xdp_update_frags
Content-Language: en-US
To:     Lorenzo Bianconi <lorenzo@kernel.org>, <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <brouer@redhat.com>,
        <toke@redhat.com>, <lorenzo.bianconi@redhat.com>,
        <andrii@kernel.org>, <netdev@vger.kernel.org>
References: <aff68ca785cae86cd6263355010ceaff24daee1f.1643982947.git.lorenzo@kernel.org>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <aff68ca785cae86cd6263355010ceaff24daee1f.1643982947.git.lorenzo@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR01CA0045.prod.exchangelabs.com (2603:10b6:300:101::31)
 To SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1db483e-e7fb-458d-9517-08d9e8050248
X-MS-TrafficTypeDiagnostic: BN7PR15MB2452:EE_
X-Microsoft-Antispam-PRVS: <BN7PR15MB2452C264C3F7CF59089F81FCD3299@BN7PR15MB2452.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I41jFu5rmr1gTAwO6u/ybSf6Ap6FG7xiXqbLa/EsBM39FwXnjw7beIBtn4GoI/+Gx5EIDOtJx2pKt858LmLb1HXC/vLj8yrjzDobWMd6Z95O8UkbzffD80HiwUkgfPz2n+F2QmX+Xpd0MQMwcntlvRth6wrs+cfn/AtxdeO8czrUo+KazByOEfSchs0oCcVL6oTr9eieW0YVgwkl50l44aMqngAfYcThQGyg9nOY7QXCRSeBY156U+1ZyHiKcytQM56LlGPZFcbq6V5cosljgg5I4k0iZvHiUi9XAcGQTfV+eU/9Zm7e4X2YpOVuMKX7WEEk1uwVHOggxZ1sbHk/3gMEtdtagXhJjXJ6dgFh7CTh+V43UKxnyLQx7guYm2A89aPneEbGgf08iOLUzU43I5TcMzxBTr6/2BCUxDEh8ZaeyZreLvnjrRUrFqd7z40bQFb/tTMddJdeJQtFgvo2jQKaRjkxBKcGhGz67sPn0JOpasXb32AKFXdnYY9tFY0pM7+pDqbcITCJ0XLem97PCF0F5vGVpzZhOO0JBGOaa2t3hKAXFQZA58r5+xW93zXHS+Pui1fpXF6SlkwTCaDKnt5tKTbPlPr+aSkQXGWHOiYb9/waXSGW9uRwfDKgMkLutYEQu2NAvi+jBnH/QjdNPpOmybcPNxAoJXdbH6ubHBmd0x0ylqYbrUVizV19hYAiV0AqPrIb0Cb8O2wDbm8PhqIPZfp4rLLE0+HLejdfDeY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(66556008)(508600001)(36756003)(38100700002)(5660300002)(86362001)(83380400001)(52116002)(2906002)(6506007)(31686004)(6486002)(66476007)(186003)(66946007)(8936002)(31696002)(4326008)(53546011)(6512007)(6666004)(2616005)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M0JjbXhvV0J4Slp5OTFiTUV6OXdtSk9HUDRUU084T0s2VHM1Z1ZiQlIvYzF2?=
 =?utf-8?B?YTl2OXM3Rmk0RW1rYWo0M1djNUpPYm9pV0RiUStQdVBkOHFEV1ZmTFFlZ0pE?=
 =?utf-8?B?REVNZDJQRVRMMjh2ekpVekFTWUFkSVRVN0xZMzdueTVtZ2ZIaC9wYzJVZkNI?=
 =?utf-8?B?SmVMaldaZDJQc2d6OVoraXEwM0ZGWk5uR2xDZUVMZ3VqT0tpMzlnUFV0RFFB?=
 =?utf-8?B?em54S3p3K3p6OEhUSWZEbVhzdGh5bW5wVkVIb21sNHV2VlVuVG00cjRZNmx5?=
 =?utf-8?B?NTcwbS9vOEdrZHYyM0NqWXpIWWhmY1lzWUdWYnBZbTNFSXRuTHBjekFvc1I3?=
 =?utf-8?B?TVZVdXE0dkJsNFJ1WGk2Z2hHVGFDVkRNUEtZVzAva0h3TzllQmZxZW1ld3hV?=
 =?utf-8?B?Z0hoRHRyYTl1T2V6Z2hrdyt4OWFqdTNFRkhmY2tPOXFiNEN2K3UwQmJRWlVX?=
 =?utf-8?B?SjFTY0haVGJjUTB6QVVnUTVKWlFkQXF0QlFDZ1UxM1BXdDFoVHFiSzUyWkd3?=
 =?utf-8?B?anhBTndOemUxT0RYT2JJSnloN3k0UGN6VEVkQmhTTlJoTEp5eEpJVFJKdlo5?=
 =?utf-8?B?cFlDSGNkbUdVVmpaTDZlUForNHZEeXozWHRXQ2dxaTZDOVJ4TkNoVDFUYTJ2?=
 =?utf-8?B?OFFuWjVUYkM5Q0lMbGdRQzliQnJnN1ErWkxNejc0Y2lXd1NiQ0Nna3JRTko1?=
 =?utf-8?B?QllTMytmRXdwMU5nVjFIWEhncksxdTZrVUpLbmEzWDgra21GbGVSSk4vMGR3?=
 =?utf-8?B?eTFLY2F6dnNicjdZQ2ZZLzdEUnJjaFFjWXg3NGVxOFo1VW16WUdyMzFDbHA1?=
 =?utf-8?B?MHNzRVhLMnJaVS9CMWdDemVrSmdzQWRBcGFpTGcyUzdYVEhHbERWdDN6SEho?=
 =?utf-8?B?aGVOZmU1Y1J2VWtyTTVFY0ZDUlFxeW5EK3FnVDlKZkc3eGFmSThUdkptTTU2?=
 =?utf-8?B?eVBGMXJVN0l5enVqNEQ4dzg2MmRaSytwa2dMK0QrWTl5R01DV21BQlJnek0r?=
 =?utf-8?B?U2R1cXlTeFEvSThTLzhlTGt2MDB6NWFCSHhzM2x1TndzbFJ1cksxbmpSbHN4?=
 =?utf-8?B?TVN6NnB3SkgxN2lTbGhFa0dWWXkrYmxEK09WY1pVR1g4cmNGTjJncFp0YXNl?=
 =?utf-8?B?WlVtVExxU3l4cmRNdm1PTkNTZlVsUFBOMXpRZFF0U0NnU3Q2NUJPc2pWZEVk?=
 =?utf-8?B?TTdUK1pDa3o3ZFJUZmdnMzRGdGw5YXo4cHBFcjZVcG4rU3NNb3ljdWRIK2JF?=
 =?utf-8?B?TE5TaHc2SC9ibnpBMFptQUZYbDJZN1lSeG1WSENLUkg1SmptTTBid2dBdEhq?=
 =?utf-8?B?YjJWd213VXF0TmN5L0JtVXZSUmkzMHB1ai9wRGxpTGF1Z29BeHdZTHdrdVpv?=
 =?utf-8?B?SDhQb2pIL2V5QnIrM0J3dHRkSUthOSsvdHp3aXE3bzE1WWhpRlQ4VHFXMjRP?=
 =?utf-8?B?cnE0RVFzVzdLaVNOcXl1REVxR2E4ZGt0MGtBUzRYRUg2NkZBV1BzZXhjOE4x?=
 =?utf-8?B?UWRLWGw2TEkybENHV1pQY1lRdEF6YnhscXpZVlpaWm10WnNTdjUrbDlzT2VK?=
 =?utf-8?B?NUQ1OElQTE5UbUtiS3Rrb1kvM0NrWWJ0SlNpVHZZRkRhSzluT1NDc0IzSGpV?=
 =?utf-8?B?WEZpa2hjWEc1dk4xL29Pd2p6WHY1cjlGdVUzNG9IeHQ2aGZoTU50THRJakpj?=
 =?utf-8?B?T1kraFFObktwVTRNVzQ2Sy9hUWNkZURocVR6NjFpZWZMQzBud200VGhkRnBl?=
 =?utf-8?B?VTZBcjBxVklPeUhaMTBWaWFmT2dvY0ZidFl6Mld2OE5YTzg5aGxKZlZ4eDMr?=
 =?utf-8?B?ZXBWTW1LOVVzdWFPTm42MXBWUGhNVGx3WFhLUVhCZDd5L1QrbXlJZGhNRWZq?=
 =?utf-8?B?aEp6VElleFVWSUhiTkt5alN5VkJpWUdjUzcrN05qc09mVVlVbUJzUUdia0Z1?=
 =?utf-8?B?cUh0bmhFV2hlUWs2Ym5VbmIxcVQrc2VVd2xGY2hLR2I5R051T1BsZnpiZkZP?=
 =?utf-8?B?Y0lRRTNBZnJUY0xpS3ZYVVBMK2ozL1JNblNySE5GWm9PbjJKVUw5TTJlZ0p2?=
 =?utf-8?B?YlVGd3g1K1JnR3BCNlRaTnFTS09pdTFycVlXMW4xdno0ZmNoVUwvdmY1TWlh?=
 =?utf-8?Q?ts0Xlj6jnCcJHfUTJVCxwTOiQ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d1db483e-e7fb-458d-9517-08d9e8050248
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2022 17:37:26.2302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P+F4ajEBY3QnIuSFvXfTLvb2cwtT4uKKRSMuwmOUslpDCKeTpYzNCF19d+W9ZQSe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR15MB2452
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: PtNv5s_MJq6Px6Q8RHuvXoNuHji-V8sf
X-Proofpoint-ORIG-GUID: PtNv5s_MJq6Px6Q8RHuvXoNuHji-V8sf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-04_07,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 lowpriorityscore=0
 phishscore=0 adultscore=0 suspectscore=0 spamscore=0 mlxlogscore=940
 impostorscore=0 mlxscore=0 priorityscore=1501 bulkscore=0 clxscore=1011
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202040097
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/4/22 5:58 AM, Lorenzo Bianconi wrote:
> Update test_xdp_update_frags adding a test for a buffer size
> set to (MAX_SKB_FRAGS + 2) * PAGE_SIZE. The kernel is supposed
> to return -ENOMEM.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>   .../bpf/prog_tests/xdp_adjust_frags.c         | 37 ++++++++++++++++++-
>   1 file changed, 36 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c
> index 134d0ac32f59..61d5b585eb15 100644
> --- a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c
> +++ b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c
> @@ -5,11 +5,12 @@
>   void test_xdp_update_frags(void)
>   {
>   	const char *file = "./test_xdp_update_frags.o";
> +	int err, prog_fd, max_skb_frags, buf_size, num;
>   	struct bpf_program *prog;
>   	struct bpf_object *obj;
> -	int err, prog_fd;
>   	__u32 *offset;
>   	__u8 *buf;
> +	FILE *f;
>   	LIBBPF_OPTS(bpf_test_run_opts, topts);
>   
>   	obj = bpf_object__open(file);
> @@ -99,6 +100,40 @@ void test_xdp_update_frags(void)
>   	ASSERT_EQ(buf[7621], 0xbb, "xdp_update_frag buf[7621]");
>   
>   	free(buf);
> +
> +	/* test_xdp_update_frags: unsupported buffer size */
> +	f = fopen("/proc/sys/net/core/max_skb_frags", "r");
> +	if (!ASSERT_OK_PTR(f, "max_skb_frag file pointer"))
> +		goto out;

In kernel, the nr_frags checking is against MAX_SKB_FRAGS,
but if /proc/sys/net/core/max_skb_flags is 2 or more less
than MAX_SKB_FRAGS, the test won't fail, right?

> +
> +	num = fscanf(f, "%d", &max_skb_frags);
> +	fclose(f);
> +
> +	if (!ASSERT_EQ(num, 1, "max_skb_frags read failed"))
> +		goto out;
> +
> +	/* xdp_buff linear area size is always set to 4096 in the
> +	 * bpf_prog_test_run_xdp routine.
> +	 */
> +	buf_size = 4096 + (max_skb_frags + 1) * sysconf(_SC_PAGE_SIZE);
> +	buf = malloc(buf_size);
> +	if (!ASSERT_OK_PTR(buf, "alloc buf"))
> +		goto out;
> +
> +	memset(buf, 0, buf_size);
> +	offset = (__u32 *)buf;
> +	*offset = 16;
> +	buf[*offset] = 0xaa;
> +	buf[*offset + 15] = 0xaa;
> +
> +	topts.data_in = buf;
> +	topts.data_out = buf;
> +	topts.data_size_in = buf_size;
> +	topts.data_size_out = buf_size;
> +
> +	err = bpf_prog_test_run_opts(prog_fd, &topts);
> +	ASSERT_EQ(err, -ENOMEM, "unsupported buffer size");
> +	free(buf);
>   out:
>   	bpf_object__close(obj);
>   }
