Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2DF4D0D90
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 02:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbiCHBgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 20:36:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343624AbiCHBgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 20:36:36 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE1192F02E;
        Mon,  7 Mar 2022 17:35:40 -0800 (PST)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 227Ipp0U003895;
        Mon, 7 Mar 2022 17:35:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=G4P5Yr5TaRcG48/usTq6GPUPnY6wn6tfZaceV6e+oik=;
 b=Ff/OjoQjo734OxgxEWY03ZA0YMjlU8OPzTvL2FtKQWhA09LBvpwvuaDNeBo4dPiFc8/w
 EnLnE+rPoIqxMUAAZ5wQBFajHrRnK7wdPCtHEqStQBv2n00KtlS/Z8MLRhERxUDJK7sg
 joFSMdH7V8ysB0SPW8esEiC7XxgelUCf7EM= 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ene6jxswm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 17:35:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kRzD3XlfVzNoGx1FG6u9Jn4PVutPnDfdgEEN0MOR8XzFSMpgfEz6HVIBp93nm5ZDOTiN/BP0MHtfZ8n3OhWHYxQ5xP381SlkywYchiDHVoAUueH04Cu3XojU9B6Ok2ni/uOCLndV5qhpNpTBRChwFMhQxL7qEu3MJPE4mKEh+YnwfJ1Msg5mK7ELWMTe2wDIlmZAhnK5sd5orLiT7/pkE+dQcxDzhDDeJpp2+Rs5XypRS/awc5rvtocrtVWvm2zLKqeD99GPiSDnfnZldOlZxovGciLpEFL83dSKP4AMRfrrCMjS6mBZHbiQK1NEqEZCvrqdW54ePC+UGkuzOtkLbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OsTLh26qy9f1COpQ8c5snzQHh5ig8s75bvHFAQEUIA0=;
 b=ZUphDYo0xKUiEJEts0GT0i6EgpksuSnX9BBpMn6ULOPDFG+rv7EXMsgJPm3JzGedCIJ/6ZZ7EUmHr4gbOzg4YlU7O4oMAhhDY59ZrggzH74IhmRSViJ3Gv/Klmw034ZBQz1MmtacnRRabs13AszTmcrf7y1sQJqN40z7e+enzJzbRzfWJyhdGWLYnnXBZWxdIVR2IwwTsGMc23ZfxjolCGo8GL/2vvR2YoF9uKmhLqzqOy1nnZgeKN1IGP6ivrOp2s0Lj7rBqQsOkBS1w5Lag154VNJNX7dfDlYCcMKVsU1xs5K8Vn7baCAzeGXCLHgbcb1X9DbS4G8HiOf5SteLew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by CY4PR15MB1944.namprd15.prod.outlook.com (2603:10b6:903:112::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Tue, 8 Mar
 2022 01:35:21 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1d2d:7a0f:fa57:cbdd]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1d2d:7a0f:fa57:cbdd%7]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 01:35:21 +0000
Date:   Mon, 7 Mar 2022 17:35:17 -0800
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
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v9 1/5] bpf: Add "live packet" mode for XDP in
 BPF_PROG_RUN
Message-ID: <20220308013517.b7xyhqainqmc255o@kafai-mbp.dhcp.thefacebook.com>
References: <20220306223404.60170-1-toke@redhat.com>
 <20220306223404.60170-2-toke@redhat.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220306223404.60170-2-toke@redhat.com>
X-ClientProxiedBy: MWHPR13CA0002.namprd13.prod.outlook.com
 (2603:10b6:300:16::12) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 41d5bb58-3c05-4d6b-191d-08da00a3e8cc
X-MS-TrafficTypeDiagnostic: CY4PR15MB1944:EE_
X-Microsoft-Antispam-PRVS: <CY4PR15MB19444782A885B0F5C81F44B4D5099@CY4PR15MB1944.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f8K/xPCt8auShtduODBbUgcaLH7O/UVpcUlwg0284uAi2H5tOA/mo1dAp+KTU4T4myQDg75WStYkse14OD2PveAP2tqQCFhBkcSUeRUfwUPeLzCT+kk7rPeTdijDuu4ivm+Pur2+JQK9N1CYGql3+PMl2gmRptzQtvd9pJbG4FTBEqdqdmLy/VG8vp7fFmRARdaEVORIXFDXk+oaaW77Pa6qoMWbWs5CuoZITmUnxLFQYx1OPVDCEbGeg5ztb0GoFt5JYGS+MS92KUN3hTn4hYpNz48Q3s4M6C6dxNwlt2vCSsu0P1477Jn4iwJhIh16IpjoACCg6hml/VcXKiZhlrWIwkA1cjfHXOZWgeWjO7MRuH01IIprupMGqGkXXjSHMrfXfPKUTHMWxeiPAj1WxapuL5w6NKLti8D/E7LJMoyshNoaiW9Q5U5dxVvQuLnNqukuM8WitUf1C2Ci/4cLCYIRqKxNdd/2VyQIKYWMKPy+/RDYLD160Y5FXnEEd9bSnRjvIRMSGz970SweA8UOpZDamPpjk4rGGytBVURpqshi/yS4T+6p2793TJdhWVDtRYxgfHjP2EDwu4Uic75DgPnvkWjpMzH8eWWCIWOxyl7bUO30iTJSkuF/BQ3BMv2j7433tYxCN8u+iz1jrAy9jQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(316002)(38100700002)(7416002)(6512007)(8936002)(86362001)(6506007)(508600001)(9686003)(52116002)(6666004)(2906002)(66946007)(8676002)(66476007)(66556008)(5660300002)(54906003)(6916009)(1076003)(6486002)(83380400001)(186003)(66574015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?D4BdNTic4nP4hgOFIKptoyw0Vs9GI7X5j++aBp+/zpF9+piysPHWnLni3t?=
 =?iso-8859-1?Q?CzWAefv22ZQbPGj9DuH//RY2Eabw8bgQQVU4bcmyFXL6POdn1bVgqhGv0u?=
 =?iso-8859-1?Q?WLJQMiKiV2u52nbQ+wGF3LEtbFp1HpgXi9OT6whtL6GZQHGkTYd98rljx0?=
 =?iso-8859-1?Q?ydJjV9fW2KylowYHePcEWi+4LZlnaR2GcDyCRvaZH5D08MoKiPG/XeoOQ5?=
 =?iso-8859-1?Q?661mK/eN/U287SAGOK/+xegbbpzPB8Kkzd6URuv+KJDCQNvrroMsE2gl+F?=
 =?iso-8859-1?Q?isnmUaG027AlDHKb7t1AbNrjPdhgmgUWBi42zKL0vs3jighcDcwyhh1ZuU?=
 =?iso-8859-1?Q?jMNAhT21KYYtzF6u88U85+KRKLosi+nDhJJfKDpeipJhkDb1gXQY4/ge0U?=
 =?iso-8859-1?Q?fcMEUEVJGVOJEbQHBIUiOg/jMH5NTxR9DOsy75+zoOu9kJYJaOvK1wSTCS?=
 =?iso-8859-1?Q?G8L1qdt9MpxPtM92B/cqynArblAZ2b3L1ilRXoKfDMmUSp7lIr0QoRkAwx?=
 =?iso-8859-1?Q?KJ49zVDpyf4psESQHa8dQ/Q8qy5d6Df9Ij9+kXgmnXKYG2py5SIrW26c3j?=
 =?iso-8859-1?Q?FE7I74uVFY4mfw2nCmZSizeiqA+xTaZAHrnd7nG+gWL9qXI9n9rsbXq3Hw?=
 =?iso-8859-1?Q?XxROoUoBPgsId5Pxhf4oYHZu4ODvQQpUlrQkrocRjAixKRw7gMEjCsw9gJ?=
 =?iso-8859-1?Q?Fs2Ki/9he/Cewe8ZI0TN3ZOIvIi1Kox3JGtayrNG5X/TErCjXmGjW3Q31r?=
 =?iso-8859-1?Q?KZ9rfwXuP58rudjKCTKm84JJdzKZsldn+PdGgAieRkKzP4RdmAKr8Om9aN?=
 =?iso-8859-1?Q?nyWFj9INH1Qk73BwJle/q1FQKeP80EV2oSkVvucOKC0/4UadiRF6826XP1?=
 =?iso-8859-1?Q?dSfWGvQmcqn7ZjOfswtbZUKJ9Io7POISFVBZEL8dGt0PSdYTuFqbGHSZrW?=
 =?iso-8859-1?Q?hNKUkJAim/QuCDKyvKZN80FfU9IFgLtAWd9Twty5dNIBcLDNIqrDmD5BAz?=
 =?iso-8859-1?Q?Jj6iFWXoMlIjihZBHpAGQEz/5GjObTOzIU39GPnQ/Oe/odk3fsw3QadMOk?=
 =?iso-8859-1?Q?HMpQ2zZ9sC2X4jS233jRGckQ+ZihDGlldFT17ttyLEIkZLfidjViuJ7Hoo?=
 =?iso-8859-1?Q?lRH8FTtXbxz2dINaWXqBdlDvf6WZV29GKZven4C8d7kEdTdaH6TzZhLhEk?=
 =?iso-8859-1?Q?R8eE9KAat1zzFgSUCY113dlmd/JTuHVqlHXJo5TSyL89758Y3meujHp2Tv?=
 =?iso-8859-1?Q?+MdW80avBZ2xVrcn9atXMFRQ/Fu3tYwsploRn3bzOJPCQ9ceZMeeu4X3L8?=
 =?iso-8859-1?Q?8LlFM7X+8wq1XHpj9kqScDAJ77BkmlNwj2C+yoj8izI4LjwnXiE1MBo13E?=
 =?iso-8859-1?Q?0Ypc6IfkuK/xsy/M4U8X/nZTjQTlyp35OdOl8ZN08o40iOPGTgToNsOKiJ?=
 =?iso-8859-1?Q?QmEqUqeqdgquwH7OX07CdHqcnQUzj9DD135Vocg9UZArhuCkE8+sD0om31?=
 =?iso-8859-1?Q?xjItWCEm7FVENITA7e3kyoORI1GsSAXiWSoSE47mqvbo3yI/Ud5tOnX/IY?=
 =?iso-8859-1?Q?B16Sf74AbxaOnsEOGDSrTkTStu/qv18rq9iHVCiDuwconuVUdIvvfE7nZk?=
 =?iso-8859-1?Q?IyoRWbJFWpNeYHhHKy1I9YVCfLSrlJlKtp?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41d5bb58-3c05-4d6b-191d-08da00a3e8cc
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 01:35:21.3892
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: liqMeZo03PumRCx13AIFd0NTtA8WgTkBQxqmCn+uCIVO76Zx0BTMGZVYBZewKcVX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1944
X-Proofpoint-ORIG-GUID: LQuMy5knhTAw162YVoDP4mJ8p4H7O2ZU
X-Proofpoint-GUID: LQuMy5knhTAw162YVoDP4mJ8p4H7O2ZU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-07_12,2022-03-04_01,2022-02-23_01
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 06, 2022 at 11:34:00PM +0100, Toke Høiland-Jørgensen wrote:
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 4eebea830613..a36065872882 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -1232,6 +1232,10 @@ enum {
>  
>  /* If set, run the test on the cpu specified by bpf_attr.test.cpu */
>  #define BPF_F_TEST_RUN_ON_CPU	(1U << 0)
> +/* Guaranteed to be rejected in XDP tests (for probing) */
> +#define BPF_F_TEST_XDP_RESERVED	(1U << 1)
> +/* If set, XDP frames will be transmitted after processing */
> +#define BPF_F_TEST_XDP_LIVE_FRAMES	(1U << 2)
>  
>  /* type for BPF_ENABLE_STATS */
>  enum bpf_stats_type {
> @@ -1393,6 +1397,7 @@ union bpf_attr {
>  		__aligned_u64	ctx_out;
>  		__u32		flags;
>  		__u32		cpu;
> +		__u32		batch_size;
>  	} test;
>  
>  	struct { /* anonymous struct used by BPF_*_GET_*_ID */

[ ... ]

> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index db402ebc5570..9beb585be5a6 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -3336,7 +3336,7 @@ static int bpf_prog_query(const union bpf_attr *attr,
>  	}
>  }
>  
> -#define BPF_PROG_TEST_RUN_LAST_FIELD test.cpu
> +#define BPF_PROG_TEST_RUN_LAST_FIELD test.batch_size
Instead of adding BPF_F_TEST_XDP_RESERVED,
probing by non-zero batch_size (== 1) should be as good?

[ ... ]

> +static int xdp_test_run_batch(struct xdp_test_data *xdp, struct bpf_prog *prog,
> +			      u32 repeat)
> +{
> +	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
> +	int err = 0, act, ret, i, nframes = 0, batch_sz;
> +	struct xdp_frame **frames = xdp->frames;
> +	struct xdp_page_head *head;
> +	struct xdp_frame *frm;
> +	bool redirect = false;
> +	struct xdp_buff *ctx;
> +	struct page *page;
> +
> +	batch_sz = min_t(u32, repeat, xdp->batch_size);
> +
> +	local_bh_disable();
> +	xdp_set_return_frame_no_direct();
> +
> +	for (i = 0; i < batch_sz; i++) {
> +		page = page_pool_dev_alloc_pages(xdp->pp);
> +		if (!page) {
> +			err = -ENOMEM;
> +			goto out;
> +		}
> +
> +		head = phys_to_virt(page_to_phys(page));
> +		reset_ctx(head);
> +		ctx = &head->ctx;
> +		frm = &head->frm;
> +		xdp->frame_cnt++;
> +
> +		act = bpf_prog_run_xdp(prog, ctx);
> +
> +		/* if program changed pkt bounds we need to update the xdp_frame */
> +		if (unlikely(ctx_was_changed(head))) {
> +			err = xdp_update_frame_from_buff(ctx, frm);
> +			if (err) {
> +				xdp_return_buff(ctx);
> +				continue;
> +			}
> +		}
> +
> +		switch (act) {
> +		case XDP_TX:
> +			/* we can't do a real XDP_TX since we're not in the
> +			 * driver, so turn it into a REDIRECT back to the same
> +			 * index
> +			 */
> +			ri->tgt_index = xdp->dev->ifindex;
> +			ri->map_id = INT_MAX;
> +			ri->map_type = BPF_MAP_TYPE_UNSPEC;
> +			fallthrough;
> +		case XDP_REDIRECT:
> +			redirect = true;
> +			err = xdp_do_redirect_frame(xdp->dev, ctx, frm, prog);
err of the previous iteration is over written.

> +			if (err)
> +				xdp_return_buff(ctx);
> +			break;
> +		case XDP_PASS:
> +			frames[nframes++] = frm;
> +			break;
> +		default:
> +			bpf_warn_invalid_xdp_action(NULL, prog, act);
> +			fallthrough;
> +		case XDP_DROP:
> +			xdp_return_buff(ctx);
> +			break;
> +		}
> +	}
> +
> +out:
> +	if (redirect)
> +		xdp_do_flush();
> +	if (nframes) {
> +		ret = xdp_recv_frames(frames, nframes, xdp->skbs, xdp->dev);
> +		if (ret)
> +			err = ret;
but here is trying to avoid over writing the err if possible.

> +	}
> +
> +	xdp_clear_return_frame_no_direct();
> +	local_bh_enable();
> +	return err;
so only err happens in the last iteration will break the loop in
bpf_test_run_xdp_live()?

> +}
> +
> +static int bpf_test_run_xdp_live(struct bpf_prog *prog, struct xdp_buff *ctx,
> +				 u32 repeat, u32 batch_size, u32 *time)
> +
> +{
> +	struct xdp_test_data xdp = { .batch_size = batch_size };
> +	struct bpf_test_timer t = { .mode = NO_MIGRATE };
> +	int ret;
> +
> +	if (!repeat)
> +		repeat = 1;
> +
> +	ret = xdp_test_run_setup(&xdp, ctx);
> +	if (ret)
> +		return ret;
> +
> +	bpf_test_timer_enter(&t);
> +	do {
> +		xdp.frame_cnt = 0;
> +		ret = xdp_test_run_batch(&xdp, prog, repeat - t.i);
> +		if (unlikely(ret < 0))
> +			break;
> +	} while (bpf_test_timer_continue(&t, xdp.frame_cnt, repeat, &ret, time));
> +	bpf_test_timer_leave(&t);
> +
> +	xdp_test_run_teardown(&xdp);
> +	return ret;
> +}
> +
