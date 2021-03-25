Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE0AB34998D
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 19:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbhCYSco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 14:32:44 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47386 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229614AbhCYScf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 14:32:35 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12PIV0Lv003178;
        Thu, 25 Mar 2021 11:32:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=sm3KWwNCFYuJyYiyP1/5GGPgp8uZxXuImVY7gHDW8bg=;
 b=mvFwtC7+kathC3POhZM9PaQcifxhhS5KRUKCgAac6Eu0Ck/EDWTuHpJh+NV+MHrSiKVF
 6uxOam31RzQDr/DVz/aXOTiS4zO/G6Jig7YV1RAM2nflTQ/5TlFsDmMdddxJ8/C93b/R
 N4hhveWgLwHUln1cYrp3ZqpNAnUwCdwbDR4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 37fp7xwk3q-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 25 Mar 2021 11:32:10 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 25 Mar 2021 11:32:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YdUXylktc2ry/02UEcqX0LMz76zKidmq+x+UdOzpiQFDkhByTevgi/zzJTJ4IrOmwB2xaiKp7UZCNoJR9j2TEoauMrRvgWIdibqDJff0ggFJmjThq+iKVlfB//oxNud2SFss88ZSxq3M6USEl6XR3BpwIuQlg09nG4LLmsYyO+9IQvHzBN/8zB3UO/uktroEuUWNxykLzNqcvkp/qq8cHWPKgd02+EP4Skd9kkaFV5XxNo5v2yE2AKTNR/PNSUALCpdfXr80Slu+ZdMjcyt1d5ToOE+y2/syV4iq4E5/+gP0B7SYauY+BM4lhD4b6/mAcOnXa/rpsfCNW0R2SidF/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3HYC/QxODQuBI3FIWQgmxZRXtHShdzR1XDq8dwvLM4Y=;
 b=TquvA7v1MwAV+98sKDbO3c00dEDc1t8J5AMhxYm8GdQpoN2BFHpSdhsONtG5XDeC2kOq8ulclf4bcDMXJfToWK35b16DqXIgjkqpOCCGLnoFguFRGcb8Iy8zS30CTHFaBcp1wnPnpotr4RoloqvDvbErEiNAwT1YD6SQoAhF8oiqQ0i0bZmEie0ZAdc9t6aYM3UrLaTPWFdRqQd01QX8rqoa2Eny3fad3SzIXFxpNc0DpBeM6aJ+/5JGles3xVezDnKALvCF6Kes6nt5E0WHLTwbKufsCyg/zzbsNnaN6ACa7Y9TlJ/WQGb2Hl/P8I33E3AXySBoL0ugb7shLAV0aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2885.namprd15.prod.outlook.com (2603:10b6:a03:f5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Thu, 25 Mar
 2021 18:32:04 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0%5]) with mapi id 15.20.3977.024; Thu, 25 Mar 2021
 18:32:04 +0000
Date:   Thu, 25 Mar 2021 11:32:00 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Clark Williams <williams@redhat.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf 2/2] bpf/selftests: test that kernel rejects a TCP CC
 with an invalid license
Message-ID: <20210325183200.jzk7dvxmkn2bj5q3@kafai-mbp.dhcp.thefacebook.com>
References: <20210325154034.85346-1-toke@redhat.com>
 <20210325154034.85346-2-toke@redhat.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210325154034.85346-2-toke@redhat.com>
X-Originating-IP: [2620:10d:c090:400::5:daf1]
X-ClientProxiedBy: CO2PR06CA0075.namprd06.prod.outlook.com
 (2603:10b6:104:3::33) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:daf1) by CO2PR06CA0075.namprd06.prod.outlook.com (2603:10b6:104:3::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.29 via Frontend Transport; Thu, 25 Mar 2021 18:32:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 01d8ff88-cc45-45a8-b3a3-08d8efbc4987
X-MS-TrafficTypeDiagnostic: BYAPR15MB2885:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB288501F86F7E0A916DCA5FAFD5629@BYAPR15MB2885.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d+og4VWoDq4AIfOdRp7yfUYI7Ate6rW/RHdAH0L2/O9KB6orOHRgvBMQvpCF9mm+f08osf393ET6zNKw+uCiry+WdcqXTAlqV3J8Lnm1p/lsmRVuGnO1PEW/y1JH/YXyqhMhy71bNX6+fJCCrK15OdyvyUOTtyW813bVNE4Ot/q8TQCnXlq53QCJqF4X49UUfPzvhR2Wr83uN29lWLlqSp3yG/6jo33k444F0SFfxYD8RvwM+vnkUc0vy5RYf5LBTG6a5GOBGIGWU0XOW7h30vkT1vv0CTiYBjxXFUUjFRe1cw+B+SeLBcrLMd6yl/53GABjyYTvDCfd0cGDT0OcxReBm88hfRevmIeoZ7iIlLSLJqs4Shu4FXOcXRXvm/Zg23g/Ox3WxyAs+TdTDFotwyrkf489biVQprn+2bW8z/h1IuMwtwYgB30/3FKvebnRBsXPLu+xRL8KRk60I1g9aI5rnDDMg7EItyMq4QaQphwEAY9DvSJxUyPQSd9kg6J90unweIlvoB/8LTENclJhtFJX9xK0jUtDz2Zn1qM9yyFOrmTuD+yYICUgh1MEdavm786/7LRCvmx9X/1JevMf0CtIC9+XlW99ZXD8cQ65GnsYF+5UgwJQDzTaqbOB4oo1okzdz8YnL4WEu0a0XuGwCA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(396003)(376002)(39860400002)(346002)(9686003)(8936002)(2906002)(7696005)(55016002)(66946007)(316002)(52116002)(66574015)(54906003)(4326008)(8676002)(38100700001)(6506007)(478600001)(7416002)(5660300002)(66556008)(66476007)(1076003)(6916009)(186003)(16526019)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?iso-8859-1?Q?mCMkQoV8LyW2VQWOQPXXok71ssaax9FbNrH7pDcfnGbP37CyfqC4TgL3Vr?=
 =?iso-8859-1?Q?jXcf0GcvL7Qp9xr7SraNSfst1LZ1fGFko2jR+A9oe5i2sT+cV62SWczujV?=
 =?iso-8859-1?Q?p3Rv8R54Ddrzu6cdDINg6ZFi9jaeYtxrUH0HLiz/18M9BYPE0P3ydvzlsP?=
 =?iso-8859-1?Q?8ZtKRroIq9olTXvDj9LTk88X+0VMzxJNb5BBI5BR/H3pVc6GIUW6shUl+/?=
 =?iso-8859-1?Q?m99nOUVvDHOTruv201D+8DurOkEpx6A5BQIVrlGQPkq7Wj9ln6E+esk8gf?=
 =?iso-8859-1?Q?n0ngJVshEtDEDSb00uTYm1Z5omEM0xMlr69MtIt2gJ0xrJS+gJr8GiV2Xg?=
 =?iso-8859-1?Q?qYSc73Sze3nvkpsIzBMRnsqAmmLZNqLNzfdC/CEVDAM9zj2jhuTjZ41LfS?=
 =?iso-8859-1?Q?++nC8IANivO1fZ0r6ZIlHAw/ys+PY7xJ6u089HOAMC/RE1CbJNuegYYA9b?=
 =?iso-8859-1?Q?YE19MPeoJuw9pwuvRD2Xuf5by7ZzXIEXMbH6aYPIWLf3/TgJNyI5bkDi04?=
 =?iso-8859-1?Q?U1sWfnfttTHwb9zVdqgDDlNo6gN0G7RuiE0KB1XSlnU2Mas3JojzTb9euq?=
 =?iso-8859-1?Q?9HTfBMv34Kil8IdXizhAkdZSR5oF4rnPJvxoDwfruD4PkuSnJBsvSTTFIi?=
 =?iso-8859-1?Q?8WKvMdp9HUom+wU3Vn+5isEo8xQM6q0vJGPAEJsnjtXSTR9j4QNX/OjL3s?=
 =?iso-8859-1?Q?B7wuC9nRlAy9KSzG7HqTJso/suwPyMFou/vbyb3AvsA0Hjwnsq0EUolTpd?=
 =?iso-8859-1?Q?YeFiBRumUYMQti4IHDk3hLNMO21de75jwhj6CP1XsSaLgnbTjUW/2V1tfo?=
 =?iso-8859-1?Q?iNBNK7Nd7BjqJT5JFbl7f291mCJMnfJmTF3gX9VkMSawRNUtaSPqPzjNch?=
 =?iso-8859-1?Q?t9+rcYHyeG7h0elt/hX6CqaA6lvhobLuNXCTH2aUS63Znvfb2yEwbTvQcd?=
 =?iso-8859-1?Q?aV9CArw3nE+wWZDPQlQ1RQslLbIF6K80aDpQ45PHqcL0IPPNcMiaAHmugt?=
 =?iso-8859-1?Q?iLtf8ggf2AQlIw3fzdPYxDaXwn/k8P75kN91fPKTAYeLk3m+7BznDQAp2y?=
 =?iso-8859-1?Q?8DCAedlFjLfoTGNEHGKx8pv2y+KAQKSf6woZ6tRVowPeKy2JHHMU+sJIKq?=
 =?iso-8859-1?Q?xLjJQ8bwOThUGhVoTQpKHy+1o9gVvvnXRl7h6BuWrdVN3bv6ai3Ad43GNA?=
 =?iso-8859-1?Q?bLzfNfYot15E4Ku4uHYL+wCsvYfxvoAv7vDH8eaEWgd0kCxES83HSZPkgF?=
 =?iso-8859-1?Q?niOaBYejRqUB6kPdVw1Q8PwMydWjnoy3lcZQtTaaLukVJlau0yL7yI2ALu?=
 =?iso-8859-1?Q?J0W1cVsIEdCiV1iXzimXOB5Aqb4juf69hoOr3IclTDcGOO2mgEjO5umJmc?=
 =?iso-8859-1?Q?1IStZ1CuEKZWn45F++6U8mL+iTCT9X/Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 01d8ff88-cc45-45a8-b3a3-08d8efbc4987
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2021 18:32:04.1294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z8qa8irGKLABmSoZVzg5DZomgoZsSM0FeQQhGjXCWS8xOb6+mJ28a3oJcsp0EZB9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2885
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-25_07:2021-03-25,2021-03-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 bulkscore=0 spamscore=0 clxscore=1015 impostorscore=0 mlxscore=0
 adultscore=0 suspectscore=0 mlxlogscore=999 lowpriorityscore=0
 phishscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2103250135
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 04:40:34PM +0100, Toke Høiland-Jørgensen wrote:
> This adds a selftest to check that the verifier rejects a TCP CC struct_ops
> with a non-GPL license. To save having to add a whole new BPF object just
> for this, reuse the dctcp CC, but rewrite the license field before loading.
> 
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
>  .../selftests/bpf/prog_tests/bpf_tcp_ca.c     | 31 +++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c b/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
> index 37c5494a0381..613cf8a00b22 100644
> --- a/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
> @@ -227,10 +227,41 @@ static void test_dctcp(void)
>  	bpf_dctcp__destroy(dctcp_skel);
>  }
>  
> +static void test_invalid_license(void)
> +{
> +	/* We want to check that the verifier refuses to load a non-GPL TCP CC.
> +	 * Rather than create a whole new file+skeleton, just reuse an existing
> +	 * object and rewrite the license in memory after loading. Sine libbpf
> +	 * doesn't expose this, we define a struct that includes the first couple
> +	 * of internal fields for struct bpf_object so we can overwrite the right
> +	 * bits. Yes, this is a bit of a hack, but it makes the test a lot simpler.
> +	 */
> +	struct bpf_object_fragment {
> +		char name[BPF_OBJ_NAME_LEN];
> +		char license[64];
> +	} *obj;
It is fragile.  A new bpf_nogpltcp.c should be created and it does
not have to be a full tcp-cc.  A very minimal implementation with
only .init. Something like this (uncompiled code):

char _license[] SEC("license") = "X";

void BPF_STRUCT_OPS(nogpltcp_init, struct sock *sk)
{
}

SEC(".struct_ops")
struct tcp_congestion_ops bpf_nogpltcp = {
	.init           = (void *)nogpltcp_init,
	.name           = "bpf_nogpltcp",
};

libbpf_set_print() can also be used to look for the
the verifier log "struct ops programs must have a GPL compatible license".
