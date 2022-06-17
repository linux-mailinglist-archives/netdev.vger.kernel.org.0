Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D76CB54FF19
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 23:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381052AbiFQVEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 17:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbiFQVEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 17:04:54 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D865DE50;
        Fri, 17 Jun 2022 14:04:53 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 25HIjR9T012762;
        Fri, 17 Jun 2022 14:04:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=KxEcrJJdoKIq8TAKbzojh3M/sBeB1oMWjoyD2gn8E+8=;
 b=NowNEOKJU0QPIIhFkXtsCit5Jeq2RB6q55Aqx/QLdn/0XBrT+is90pvnGj3RY6Lt+jau
 nIsoOLIvC4nUbseFnIHbeKRBrnDJUg7UyiPC+3A2e46DG/iVGGFPUnYn3Za6zqLGapaO
 sGM8oMOVM72FFxR4WpjHtrqVscgsQwNUppc= 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by m0001303.ppops.net (PPS) with ESMTPS id 3grkew4s8f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Jun 2022 14:04:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YbMza5zr5DGz8PVxB9okCTm32tmDjbiSVSrTmoWo0P1INQzH/ingIc2opy1JrMhxkVPko/2thLcYnQ0Nfz9Zjh5LBbTUbV1drD16luyGfQKVh+SngS85opKP9yZJIhoJBBd/wjsYPZHuUxA+/aLB4xWTyvDpj2wRuklc6ZGolqm2JbhcxgKNWOfESOlFZQID8k1glM2pLDKBtearP7sruwsfeC3AJVBG1BT7YYLE0tuLfr0WPcJMEsJ/2eKWwkMsS5GxELbMW4T8muOqbd6Xf8Un1RZVUAqbrX/z5BrsmbETtlx0G/1O2vkc/LDonhNm+IQms3mHxHs+5HLQ+m+DRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9CSWba2hBWRR8lQbLIDvaT45Ajs7p0Y4h0HR+834AhI=;
 b=VOzMu0XFcSsqQY/yoNdx2zXzy6oUTMLXoCQ4YS4LQSOkp6wT8mrsmCH/ccJYwwT1biCPk7yYYZ9BS3/ZqNL4/fsFnIYeXkURhfqTBlTHJhph/ODqV+p09Du+i7+R0ko3lSmnICHCfws3ZEM6E+EMdVgXlAsQQUmtIyLe2YAMdt67SQty3frL1aC/QTwnooC5moafpKoKZSuJjnvO2VvHQ/3VSe5urWbsKBOyfts8EuitR5pspuTOOvud+196ggoIXWs1dNP0kUtE2pE46JruEmVG5PxqHHEjx7V0tbo54e6oRaVo6dTMV2V1m4FjI7C7icSvyWZ0zX98GLq2YaR/xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by DM6PR15MB3323.namprd15.prod.outlook.com (2603:10b6:5:162::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.17; Fri, 17 Jun
 2022 21:04:27 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762%6]) with mapi id 15.20.5353.017; Fri, 17 Jun 2022
 21:04:27 +0000
Date:   Fri, 17 Jun 2022 14:04:25 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     =?utf-8?Q?J=C3=B6rn-Thorben?= Hinz <jthinz@mailbox.tu-berlin.de>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 3/5] selftests/bpf: Test a BPF CC writing
 sk_pacing_*
Message-ID: <20220617210425.xpeyxd4ahnudxnxb@kafai-mbp>
References: <20220614104452.3370148-1-jthinz@mailbox.tu-berlin.de>
 <20220614104452.3370148-4-jthinz@mailbox.tu-berlin.de>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220614104452.3370148-4-jthinz@mailbox.tu-berlin.de>
X-ClientProxiedBy: BY5PR17CA0046.namprd17.prod.outlook.com
 (2603:10b6:a03:167::23) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 24bb72f8-7008-40c7-21ea-08da50a4f6b5
X-MS-TrafficTypeDiagnostic: DM6PR15MB3323:EE_
X-Microsoft-Antispam-PRVS: <DM6PR15MB33236105DEFC5B55D7DB7719D5AF9@DM6PR15MB3323.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z8qb6VYqXfGj4/CnwYlL22DF8VLfMPRIe9t5RBxE8UVGwDVAfKe9UWhIFn1wH9bYzCBqHhrdscLGgT2WihNyFYp/tI+8XAn3lTkbwIMeqoeoCKCPub0bizm836u7aoZwJVs2OrLn+qKszaJNzr++wA4Ty4ypPy+AJSDsM28mKhehN9ZEbCCpFx1ljFRcsgrZetCtT64WGbPyxigK8RobMc9kSDLBhix4rtPm73C3+PkB+HMnaN7Vh1y4GR7P7bf6OaDlF6QtzSv2kZUoDL9gnozedjUi54iYfqTeax794IPKoegf0OmS+lZRzx8xcXDXP+NqERR4gOQElp2mTST5xgUdoLxEYyMp+OVPdhh11LEBCh14Y8AIDwzXWDl5hk57yIoBxWyQXyr/Y9ilI/eGvhAr8XwfpJ6pYzNp/kDboHV5aryYhF4MrKpgN66pGLCJL0Mecxf9Is5GX9dnw5YyNE3lhbM0IC+oa5CX1f0bUUbquepAUm+oOOgD4Rbz16oDCdhK3QPc3g885pQonhWYFr3YyScMN7YQkXAFsPQXdv2KAomKO6iGpLCsXtzbCIJhAEsPBXhBY5WCwo1ESXLbhz5pxkAn3nEmZ5r8hsgUd97iGq/vE+ZIeuN/ngl5OaexomoCtIygiyS9c9t39QE37Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(366004)(54906003)(66574015)(38100700002)(186003)(33716001)(5660300002)(498600001)(8936002)(316002)(83380400001)(6916009)(6486002)(6512007)(9686003)(66946007)(86362001)(2906002)(66556008)(66476007)(52116002)(4326008)(1076003)(8676002)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?BjtAn3hISUV3aCtTkm4DWoHNkcC3SvStq7X5dyRaL3tgQ7+nI3KpvY6kvt?=
 =?iso-8859-1?Q?tz2gXag1zjWYjuS3viZcm1VhIaLYK9CTioWEql9rUmtRTFIf1yrgj+SIxe?=
 =?iso-8859-1?Q?dA8TP9Va6jeeJ44VxxMbRH5rMzIkrGDWxEwEH5KIZ3BCDY8zQiq13NNzp/?=
 =?iso-8859-1?Q?j9lplma/hDQbODQBalOgOTsELAYusF91GQ2/ThtL85Xv2yhv3wbk+Hw9AF?=
 =?iso-8859-1?Q?m4lVKgQwomxNRnKA87Thzg28tXiMGbub3jrOIfvykBqagJzVserbJJ9fpw?=
 =?iso-8859-1?Q?utNrgkMLp5TCSWATIxf1Dr+2Oemy+YfetcqdWSOHp/+7ArsmHbtqKr7/Dl?=
 =?iso-8859-1?Q?6RAR0w9nOcWOMvqaXWVBjT6OE3QGfIGb5HFelS8Ez6qo4mbHSBORiyEVj4?=
 =?iso-8859-1?Q?hDFQGlfLxyMuzf9K9p9cHIQ83KMd/bBaWlDqnJCqJd5SmnCIch4qIQc5GL?=
 =?iso-8859-1?Q?qBxLpHXeJpO0hXTdNr2pEYeAdPQlp+gGl8n+HPQilS3g71fPH10iznXC4r?=
 =?iso-8859-1?Q?qSy2rgRCw9p1kSKoBtZN6F+vSEaMybtJYlce5LSFA6J9Knqrm3KMwoWEdi?=
 =?iso-8859-1?Q?jFVfbmS0PchyZmUP6hy3Ieu69/i3vkPmP1OmiygtETQxnRER1stooYuJfY?=
 =?iso-8859-1?Q?9pLW7G5TlqtOVymTWsuUA2ykt9fv2QVTsGng/0qGzCgCvzZOdRrzI+/V25?=
 =?iso-8859-1?Q?bfji29pIMEw1WNFwvWie/WQDQlArhD5IE1con7ZhphnRP7umfa/umhtcvf?=
 =?iso-8859-1?Q?hsIH0g1IshZ0OY8h0e7hiCH8KCAp+iw0LqHONyuN+kI5LhrzWES59MDuYv?=
 =?iso-8859-1?Q?Uq+WcIOrMb3zxTC7o0SgY3ylIHGjs0y6E91Vlu6JabUDb7aNiJwaTMkyi1?=
 =?iso-8859-1?Q?fIAARV4Wo1kXfJU6UmcWOuPoX19hOlBxCMy9YvMkNO00AElXWUg2X5CJ0Z?=
 =?iso-8859-1?Q?kOrTazlaToLGeVzKz/seKtcjO+3Pdo7S1tpoTsS6YwgXipxA8eOqYqBZD4?=
 =?iso-8859-1?Q?QeKtsV6CyrChrN61jo5ENh8yDf98zJ3qtNVCIzHsikS6Q0TtvsKZZrCVSA?=
 =?iso-8859-1?Q?zD72T/+CjgxabG2fNiokwA1xwvXNArDNl6DpHEy9Ro8SLKy9AGXV0FAFgk?=
 =?iso-8859-1?Q?rK4cRP9OQD2koMK6X1d3EnqoYTjey/6jPdP43iF/yqlgTtjNgRvYJvxbMs?=
 =?iso-8859-1?Q?6shrixerqws2i/tuoy2ETaOGqRufVqp7ZEB3ImpVUtWMkw0cwtgKuwoZWp?=
 =?iso-8859-1?Q?YJTYz8pFQu1g4z61X0e7/xGFg/c/vWqAj4/bjUgSQB/tmQdBAjt+Wxj6mi?=
 =?iso-8859-1?Q?0A2oFCzeQXH60HQQmJ+h5f1jouMmV+CQTNHYwcz9Wi393CuZ3+OEdvK4P2?=
 =?iso-8859-1?Q?RWZ1tFIh6Y1KQInMri0j0Dd+1O4siSzsJKB41GMbRhbIsW0abqyughw2gU?=
 =?iso-8859-1?Q?7pszhzc2Wsplp74yX+xDnrAofvRvtSWAr4CAgac8Sc++CsfRK0igvHeWFV?=
 =?iso-8859-1?Q?Q12jdfJjXP9qJPyaPs8oJDxRulAsTuLbuD81fbZhAdldM0icQIi5kMG7p0?=
 =?iso-8859-1?Q?Pj7JPIfP1myRtU1wscHRUjzTmhQc5qsj2SqUaaq28ov7UHVx/XxS2WzIQ2?=
 =?iso-8859-1?Q?xUQfN/XKLBnTsv4C2VDnBPDA4L8u6vHWi4gU9f7Ov4puyU33vV0598EFoj?=
 =?iso-8859-1?Q?gsNo3S1ruP4B+F3YWwTwi/qdNzYyQly6B2mPwz8q16E3vqOEev9l9ezUxb?=
 =?iso-8859-1?Q?HKWpW3tUbaRMfzcBntWHzGDdrIO9e3Dkt00PtyyxYzewOHj75r12SKkx/W?=
 =?iso-8859-1?Q?aY+Q1B4NqJe23+5roYKZRAjI0jDKtjk=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24bb72f8-7008-40c7-21ea-08da50a4f6b5
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 21:04:27.1833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hN8eS2b85EJTGq4PhZISCYn+/5OHu8Ba5sV8NTVqurourQHKGpYCrZ5glyBLGQRz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3323
X-Proofpoint-ORIG-GUID: lPCZ5nzBZcnnFUHSFblygFfMUtYCIaYF
X-Proofpoint-GUID: lPCZ5nzBZcnnFUHSFblygFfMUtYCIaYF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-17_14,2022-06-17_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 14, 2022 at 12:44:50PM +0200, Jörn-Thorben Hinz wrote:
> Test whether a TCP CC implemented in BPF is allowed to write
> sk_pacing_rate and sk_pacing_status in struct sock. This is needed when
> cong_control() is implemented and used.
> 
> Signed-off-by: Jörn-Thorben Hinz <jthinz@mailbox.tu-berlin.de>
> ---
>  .../selftests/bpf/prog_tests/bpf_tcp_ca.c     | 21 +++++++
>  .../bpf/progs/tcp_ca_write_sk_pacing.c        | 60 +++++++++++++++++++
>  2 files changed, 81 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/progs/tcp_ca_write_sk_pacing.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c b/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
> index e9a9a31b2ffe..a797497e2864 100644
> --- a/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
> @@ -9,6 +9,7 @@
>  #include "bpf_cubic.skel.h"
>  #include "bpf_tcp_nogpl.skel.h"
>  #include "bpf_dctcp_release.skel.h"
> +#include "tcp_ca_write_sk_pacing.skel.h"
>  
>  #ifndef ENOTSUPP
>  #define ENOTSUPP 524
> @@ -322,6 +323,24 @@ static void test_rel_setsockopt(void)
>  	bpf_dctcp_release__destroy(rel_skel);
>  }
>  
> +static void test_write_sk_pacing(void)
> +{
> +	struct tcp_ca_write_sk_pacing *skel;
> +	struct bpf_link *link;
> +
> +	skel = tcp_ca_write_sk_pacing__open_and_load();
> +	if (!ASSERT_OK_PTR(skel, "open_and_load")) {
nit. Remove this single line '{'.

./scripts/checkpatch.pl has reported that also:
WARNING: braces {} are not necessary for single statement blocks
#43: FILE: tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c:332:
+	if (!ASSERT_OK_PTR(skel, "open_and_load")) {
+		return;
+	}


> +		return;
> +	}
> +
> +	link = bpf_map__attach_struct_ops(skel->maps.write_sk_pacing);
> +	if (ASSERT_OK_PTR(link, "attach_struct_ops")) {
Same here.

and no need to check the link before bpf_link__destroy.
bpf_link__destroy can handle error link.  Something like:

	ASSERT_OK_PTR(link, "attach_struct_ops");
	bpf_link__destroy(link);
	tcp_ca_write_sk_pacing__destroy(skel);

The earlier examples in test_cubic and test_dctcp were
written before bpf_link__destroy can handle error link.

> +		bpf_link__destroy(link);
> +	}
> +
> +	tcp_ca_write_sk_pacing__destroy(skel);
> +}
> +
>  void test_bpf_tcp_ca(void)
>  {
>  	if (test__start_subtest("dctcp"))
> @@ -334,4 +353,6 @@ void test_bpf_tcp_ca(void)
>  		test_dctcp_fallback();
>  	if (test__start_subtest("rel_setsockopt"))
>  		test_rel_setsockopt();
> +	if (test__start_subtest("write_sk_pacing"))
> +		test_write_sk_pacing();
>  }
> diff --git a/tools/testing/selftests/bpf/progs/tcp_ca_write_sk_pacing.c b/tools/testing/selftests/bpf/progs/tcp_ca_write_sk_pacing.c
> new file mode 100644
> index 000000000000..43447704cf0e
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/tcp_ca_write_sk_pacing.c
> @@ -0,0 +1,60 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include "vmlinux.h"
> +
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +
> +char _license[] SEC("license") = "GPL";
> +
> +#define USEC_PER_SEC 1000000UL
> +
> +#define min(a, b) ((a) < (b) ? (a) : (b))
> +
> +static inline struct tcp_sock *tcp_sk(const struct sock *sk)
> +{
This helper is already available in bpf_tcp_helpers.h.
Is there a reason not to use that one and redefine
it in both patch 3 and 4?  The mss_cache and srtt_us can be added
to bpf_tcp_helpers.h.  It will need another effort to move
all selftest's bpf-cc to vmlinux.h.

> +	return (struct tcp_sock *)sk;
> +}
> +
> +SEC("struct_ops/write_sk_pacing_init")
> +void BPF_PROG(write_sk_pacing_init, struct sock *sk)
> +{
> +#ifdef ENABLE_ATOMICS_TESTS
> +	__sync_bool_compare_and_swap(&sk->sk_pacing_status, SK_PACING_NONE,
> +				     SK_PACING_NEEDED);
> +#else
> +	sk->sk_pacing_status = SK_PACING_NEEDED;
> +#endif
> +}
> +
> +SEC("struct_ops/write_sk_pacing_cong_control")
> +void BPF_PROG(write_sk_pacing_cong_control, struct sock *sk,
> +	      const struct rate_sample *rs)
> +{
> +	const struct tcp_sock *tp = tcp_sk(sk);
> +	unsigned long rate =
> +		((tp->snd_cwnd * tp->mss_cache * USEC_PER_SEC) << 3) /
> +		(tp->srtt_us ?: 1U << 3);
> +	sk->sk_pacing_rate = min(rate, sk->sk_max_pacing_rate);
> +}
> +
> +SEC("struct_ops/write_sk_pacing_ssthresh")
> +__u32 BPF_PROG(write_sk_pacing_ssthresh, struct sock *sk)
> +{
> +	return tcp_sk(sk)->snd_ssthresh;
> +}
> +
> +SEC("struct_ops/write_sk_pacing_undo_cwnd")
> +__u32 BPF_PROG(write_sk_pacing_undo_cwnd, struct sock *sk)
> +{
> +	return tcp_sk(sk)->snd_cwnd;
> +}
> +
> +SEC(".struct_ops")
> +struct tcp_congestion_ops write_sk_pacing = {
> +	.init = (void *)write_sk_pacing_init,
> +	.cong_control = (void *)write_sk_pacing_cong_control,
> +	.ssthresh = (void *)write_sk_pacing_ssthresh,
> +	.undo_cwnd = (void *)write_sk_pacing_undo_cwnd,
> +	.name = "bpf_w_sk_pacing",
> +};
> -- 
> 2.30.2
> 
