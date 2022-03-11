Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1B0A4D5654
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 01:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241945AbiCKAGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 19:06:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiCKAGp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 19:06:45 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9797B19F445;
        Thu, 10 Mar 2022 16:05:43 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22AI5FPH000964;
        Thu, 10 Mar 2022 16:05:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=W9QXdaweemyIoD3/Qgc5eMZDzWrFe2nhqVQ3/srOcL8=;
 b=G0eiF5pJDrXERmjVBsVLzAQKuWMjewoi+Pb0e4C4Pjd7AjGDj1X2ypJe4ICIBs3zzQoZ
 ojQjT8OnCsmgqhRcmT4DKPM119At1DhA/LQsa3bY93fr7Zv/vPGaCR+Z+ONCHNwgCaGD
 hSfB6FVMEORbKBTSH1SgtDZtVs58585p0HM= 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3eqex2dwgw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Mar 2022 16:05:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ErWsDrO5hwBwyjn4OINkO/BL2UmtLg55yuVTdhf4myCeixlNaEHx9KZzkCJF5yzpJ1eOLBGubFVJag4rvNTWlwM7900W1CeCb90EQWRuB0lrth5naVUVX1KoTvaVhVqn/biY07/woKErfQJOTtcvFBqzOueh/3HC0OqkxbHKBnB0gKpUcksa5ctIsIVS7Dc+b+C/XcXSu/sjTnBZAU+Za5ed+8hgd2xfWOWem2F2ODwpfz0PRT+tEIXi9Z+TI+/DQxWYPysGpMuDSxVd4iFdytdiIKQtMCSvrjarzj+emG4zSB2GJbF24oj9vEuXsH0OnFHerx2ljCBTxAEiUfxavA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TFwiL438MJAR2Sdj2HpMT/RkhdtJJs+YQp/SoS+Y5yw=;
 b=SbxA0hMwdeiPd9uxctZzHg0wDoCnHu9gl4oNYevugJ4QUg4+EdRjdt9tF8H3uHo/yuzd1qUxCDDuiAjv6IsklBofwbk3aqfALwBKbPgiG8la7d/1rXVZ1VEsR/0Xu3yDLMY0Xs8gnYBh5Byw8TsqaOoZdtEHOJWFCEW8G3J7BW8vI8t4VcRj0eiuxstfi5c0AwqbzvjAuGXJAz9m86ZW8oYYi+wse7ibvXAvWuNweed8xjbkH8oR4535hqHIYGqUlEHrJbeaFiNkY7OYI6xHtjHry69qThCEzDiIYoiJkZaj+oIyya/MI7l4ZyMoHazjK2iTJfe0mSe4yuLhti6ANA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by BN7PR15MB2433.namprd15.prod.outlook.com (2603:10b6:406:88::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22; Fri, 11 Mar
 2022 00:05:19 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::708c:84b0:641f:e7ca]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::708c:84b0:641f:e7ca%3]) with mapi id 15.20.5061.022; Fri, 11 Mar 2022
 00:05:17 +0000
Date:   Thu, 10 Mar 2022 16:05:11 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        syzbot+0e91362d99386dc5de99@syzkaller.appspotmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next 1/2] bpf, test_run: Fix packet size check for
 live packet mode
Message-ID: <20220311000511.atows3k5uzggg6wf@kafai-mbp.dhcp.thefacebook.com>
References: <20220310225621.53374-1-toke@redhat.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220310225621.53374-1-toke@redhat.com>
X-ClientProxiedBy: MWHPR22CA0011.namprd22.prod.outlook.com
 (2603:10b6:300:ef::21) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 70ece2b0-72db-4778-a60b-08da02f2d320
X-MS-TrafficTypeDiagnostic: BN7PR15MB2433:EE_
X-Microsoft-Antispam-PRVS: <BN7PR15MB243386F5910271587FB5D8CCD50C9@BN7PR15MB2433.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fd5dsQe7RD5IdLjGXKL7xIUYKk+mRzIII3ptWEoCcC+m7Kzi4hVZ8dn6FzH7gWJUezn2pQPzbfbqhqeAY+IchftmMP9FejgAAFpWTYnlmJzHdG+v5m5t57eMU+cewwJNvOwGRbFeVE6vtgR3TEKM87rydWPlTO6vl0wz1RQlPONy9oCCM/j+s3R3LGyIqLWsFU+5O6OuUb+EXGkmWZyFu8+AqrCZ8plBcvDRWLDUSc3dAlb4b0MFlrRdoN/jxB3Yf/dG1WLJ7RLPcqV0gvLPA4sng53J1by5lY97m3QqhREPZ9IaHL2A8LM2A5k5dpFBvGdd4keP0lEJ6RQ//CUGnqOAYF8JYX50N+kOeHfBj7KPdQQXec5xn6XGURXOAcVKILir1rVlaOtwjvn14Xl9nGLomp4AaqTLolNOG7CVMgY0l1Yj9fVAHxqi+XQ9dGOkiIWWGtQfJwhNt7+utHHdTUebq0oXfsvBwnHaJ9TZqv/EwX+J6di1kZF5juu4h24A43Zit9cVxOA2CIA75mPCo80tLTX3YHTBP/ctgCAyviPPf7Cy0os8Z6Al3ewk0DptOBOp+4Ff9XkEuFQLKjiSbBNAdG2qxjihoaDkHwM5wBQH6T78HEE0xi+j5OlEWRcKk5/cB+9zhOb7gsmoPBUy2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66946007)(66476007)(66556008)(1076003)(6666004)(5660300002)(7416002)(316002)(38100700002)(4326008)(8676002)(66574015)(8936002)(83380400001)(6916009)(186003)(52116002)(2906002)(9686003)(6512007)(508600001)(6506007)(6486002)(54906003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?g5cdXEXS/SgnLn2pv/aRTgNJ0jL1q3PGqM0pVIcCxOVXODSO5BrRJ11X9t?=
 =?iso-8859-1?Q?I89f4sK0mNRENlHme5C5rplKHIAQIauvogYdmlBQp7af8j6h+uE2J4QNKt?=
 =?iso-8859-1?Q?A4CI164iwi3Dj7llLYrcMgZ8a4YNbiwaG1IYqib6UFefjCW1415t1LdE2o?=
 =?iso-8859-1?Q?uvVM0WX753X9UWWPS9CPDBYiLbC3Xf224MvdqPOstd0Blxyd8IXsng55Gy?=
 =?iso-8859-1?Q?i1GN5RD5RZICD9EPoHShM3Lm2dPsj/PFQIX/v8deBiogPf659dAPygsaof?=
 =?iso-8859-1?Q?Sx4H0XCKLLQzm6fBT4i8W6rRiHoGCX11gfUrZwm9v+N9LWQSB2Xyhhk+gj?=
 =?iso-8859-1?Q?FLBGYsmQIC4XTKSMscPHO+Sc1MsvB5cCn1tO3q/k1zpxmrzdVaiu+WJVak?=
 =?iso-8859-1?Q?4f3A+IhXXMTfv/WUmi0Kt6T3NP9b22Iozm89hRY1RTqxNeUH2siBtJxZuX?=
 =?iso-8859-1?Q?keziYzr7wmkyR25P1yjPe+qS/6ICRb4K7BWZru6giJx9wGh+5wL1V5SE2K?=
 =?iso-8859-1?Q?Yr2Mzq9sqSAiUP71T6597Mk73N51YnpePZvcERzmlCYGiQWQ3T5Rfk0v/L?=
 =?iso-8859-1?Q?Yof48FnGlM3tBH5OChQ4iHcuN1e0A4yrn7HkM7HzF4tp0FihQ5enhMNzKX?=
 =?iso-8859-1?Q?3pAddadeNQA09LDsVyVLdg6fkAAZQNlSi7/3uPT1kktl96De6dAT2mpzj4?=
 =?iso-8859-1?Q?1OOtDfMJkfTcV+kmiJloRCjSKsUriWE4s/AWmNtVhEPV+aOwjN1lfwGxWQ?=
 =?iso-8859-1?Q?+gzvcd/pmNRGZLJjf1twEz8d7MpaQFDGO/XYPTea/pobI54O5a5wF8qa7X?=
 =?iso-8859-1?Q?/7gD2/64fBnywxeav65yZJTqDVBAzkZsntaXoIVhHBhrXOq/gJr7wbgj+N?=
 =?iso-8859-1?Q?ejpAA/JyMVb0+QgVW+IJ1cZJ6YVYsifJqdReERYv47/yVdbOi6uWQVCLA6?=
 =?iso-8859-1?Q?JyA3PvHY5GbDQzC1I/CrPQ3lqgLWcVHRQx8DIp1vTvkEH11gXlyrysX5eQ?=
 =?iso-8859-1?Q?DyQ771wsClSLfWLIpLjNrbjLEfSxbSRGlobQrnJCzr4VlDVUdZ1ZbqGRw3?=
 =?iso-8859-1?Q?qvnH5s4Jxwx0ZmoECkjwiajX1gqy5sVU6eYp1urDJEdJjPSp/xZdNhomOc?=
 =?iso-8859-1?Q?d+Ew6vPo2S6n9yst1gQSg9rS+MIYDvcbYts7RM+IhqfcTz4gdrSePmsqwm?=
 =?iso-8859-1?Q?1JhEdQe+gV5SfhClmAro9nmIwvvMkxvF3gNI2+2K5HJNn8KUd5LPDWiAFa?=
 =?iso-8859-1?Q?OMrGmp+VMHfXI2zOKOdQAcqbd6Sitk/vn7YRyBnfG+Q2E7j8rh3jJrwYd1?=
 =?iso-8859-1?Q?VRH/JLrzrZ+53mPHq4CI1vJ6GtGxxy0Z1yqgjcRnjeOkpQxCl9hNoWfJLb?=
 =?iso-8859-1?Q?SxHMCDNjwvLCyBOULYWDIAA8S/H3Ws80nMRg+Dz+TvENiTrpI3DsHZkxV2?=
 =?iso-8859-1?Q?3XFyC2nIhckOiTJDI+w7sYfD7Zf7suHGbK78wsst7/3K3XuuunteswJdIQ?=
 =?iso-8859-1?Q?8AMPmh/FMHZ5S5cwAco2h/4niyljkfYGWhFhi0p1bygA=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70ece2b0-72db-4778-a60b-08da02f2d320
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 00:05:17.5225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OIS1fIoXCm/F3cerg/BvETWiutNut4A5l9iUtTwXAC859bNvbOu6t4/w7cfz+dBN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR15MB2433
X-Proofpoint-ORIG-GUID: I--CpgaqFA19o0FwgLvhymh82kDgOk0q
X-Proofpoint-GUID: I--CpgaqFA19o0FwgLvhymh82kDgOk0q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-10_09,2022-03-09_01,2022-02-23_01
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 10, 2022 at 11:56:20PM +0100, Toke Høiland-Jørgensen wrote:
> The live packet mode uses some extra space at the start of each page to
> cache data structures so they don't have to be rebuilt at every repetition.
> This space wasn't correctly accounted for in the size checking of the
> arguments supplied to userspace. In addition, the definition of the frame
> size should include the size of the skb_shared_info (as there is other
> logic that subtracts the size of this).
> 
> Together, these mistakes resulted in userspace being able to trip the
> XDP_WARN() in xdp_update_frame_from_buff(), which syzbot discovered in
> short order. Fix this by changing the frame size define and adding the
> extra headroom to the bpf_prog_test_run_xdp() function. Also drop the
> max_len parameter to the page_pool init, since this is related to DMA which
> is not used for the page pool instance in PROG_TEST_RUN.
> 
> Reported-by: syzbot+0e91362d99386dc5de99@syzkaller.appspotmail.com
> Fixes: b530e9e1063e ("bpf: Add "live packet" mode for XDP in BPF_PROG_RUN")
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
>  net/bpf/test_run.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index 24405a280a9b..e7b9c2636d10 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -112,8 +112,7 @@ struct xdp_test_data {
>  	u32 frame_cnt;
>  };
>  
> -#define TEST_XDP_FRAME_SIZE (PAGE_SIZE - sizeof(struct xdp_page_head)	\
> -			     - sizeof(struct skb_shared_info))
> +#define TEST_XDP_FRAME_SIZE (PAGE_SIZE - sizeof(struct xdp_page_head))
>  #define TEST_XDP_MAX_BATCH 256
>  
>  static void xdp_test_run_init_page(struct page *page, void *arg)
> @@ -156,7 +155,6 @@ static int xdp_test_run_setup(struct xdp_test_data *xdp, struct xdp_buff *orig_c
>  		.flags = 0,
>  		.pool_size = xdp->batch_size,
>  		.nid = NUMA_NO_NODE,
> -		.max_len = TEST_XDP_FRAME_SIZE,
>  		.init_callback = xdp_test_run_init_page,
>  		.init_arg = xdp,
>  	};
> @@ -1230,6 +1228,8 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
>  			batch_size = NAPI_POLL_WEIGHT;
>  		else if (batch_size > TEST_XDP_MAX_BATCH)
>  			return -E2BIG;
> +
> +		headroom += sizeof(struct xdp_page_head);
The orig_ctx->data_end will ensure there is a sizeof(struct skb_shared_info)
tailroom ?  It is quite tricky to read but I don't have a better idea
either.

Acked-by: Martin KaFai Lau <kafai@fb.com>

>  	} else if (batch_size) {
>  		return -EINVAL;
>  	}
> -- 
> 2.35.1
> 
