Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75CF44D28C4
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 07:11:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbiCIGLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 01:11:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbiCIGLq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 01:11:46 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15E25108BE7;
        Tue,  8 Mar 2022 22:10:49 -0800 (PST)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22961L6m005753;
        Tue, 8 Mar 2022 22:10:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=pBWlWJblbqB4wa3QuvewtV9ZMMRKBIfeMIFrRxbFtD4=;
 b=WQngDhNeMMu/lqJ4h6wOwDE20MScX1z96Iw0UHeZVE+WYld8kxYxz9qdhCAGv9YhsWlf
 v4hFsgNlZpVy8MX8Ohqg0pbo+bSt2xptsQdc0aUiMdUYbZwGG9PifshD9eFg0jDD5TaG
 CSiWvJHAXe4hNxqyiey4euKfMiqoxvQMIKE= 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3eppkk014j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Mar 2022 22:10:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WSILocufxALjfH3MKzyWTc3Ag8GTrMA3pNxFtSuZbu2/nEaMwK9jhwbaFDSW/7IOLCfmkUH6m3MTSE5QF1sjcbaTu2uly4rfUpezxTxHItsXsoZfoJ8n28TbxhH5f4Uw9o3imQEJo16wiJ6VsdTmsfLP0qIFTlJ4rF2CGCqVKQz/Gw6cXdO7ur30ORdjnN7q5CQFCsPiAAcuZQObTei/ourK8NXvg8wAacem8HxNV8wr24qy95eNPX0moTr4/sFiXp2fyHbgWrhM4v5ITjcAqZHENodvqaWvnqD1PUREuZ5agdM74Bhjbo5Y9jvwgRKBa2KKxDN9ROj7yoRWyKFR0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vNAvIrZnpD3HixfGWXtk9y7KwewzxUaZ9zxH3W7O2oc=;
 b=gWTjERBDEVgjBV6BASt96ZcMrpRTWijcJQ6dsjNHVTDBsdX0zLXotxgg2ZwFlymyVORx6GZXjSivJGlP4c0GqEiKvAsxAyZ26UFrvPORhDJuT3sicVqTFZ+1B/WEG+HhHT+WdNdLmsbYiJS8bCFAd3mVvEAgjE6R6YgLuGYgpqBmzOIdLCSB6Omfm2vxiOz4B2y6+8DzleMQalDdiYOb4zv0/4291EIPm6iZJQD9hl6LaBF80lp6/RPB8gjhXgjYULrLVBpRGkTjTxcwHjyJ2oJbvOcMtZXK6GkCrxdck0lIM+XdwD92eaXYdmp56kwYW7wP7apsxNJeps7vdMbz+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SN7PR15MB4173.namprd15.prod.outlook.com (2603:10b6:806:10f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 9 Mar
 2022 06:10:29 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1d2d:7a0f:fa57:cbdd]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1d2d:7a0f:fa57:cbdd%7]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 06:10:23 +0000
Date:   Tue, 8 Mar 2022 22:10:19 -0800
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
Subject: Re: [PATCH bpf-next v10 1/5] bpf: Add "live packet" mode for XDP in
 BPF_PROG_RUN
Message-ID: <20220309061018.wn5tddiguywdeyra@kafai-mbp.dhcp.thefacebook.com>
References: <20220308145801.46256-1-toke@redhat.com>
 <20220308145801.46256-2-toke@redhat.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220308145801.46256-2-toke@redhat.com>
X-ClientProxiedBy: MW4P221CA0009.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::14) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ff4d5859-ecdb-4271-b0f1-08da01937ea2
X-MS-TrafficTypeDiagnostic: SN7PR15MB4173:EE_
X-Microsoft-Antispam-PRVS: <SN7PR15MB4173B6E4B2D4F43BE4140E4BD50A9@SN7PR15MB4173.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QvfGiE8blHr2KS2HoqRypMyZpcynIJybsvQG4d1Vm4VeElPdju0DHMlOh3PMKVKvM3QBuhqpGX2pay5gOJptiWCS0QbR66AOMbYHvpEoxnfPhu9BsZ24JVn4xcBCYoEWBduLW5UKUJ+7Jrfw0Vn+DJUWrxjB8jQD3k5hsONXJneFUQIU8TioFd4orJpx/crIbYvjVNkrvwVXzkfT/pI1dxUHjUscoWZgd9WnvFuO7UxB30RKUGD4q2g1agtXAjSpwCiw5KxaQGlWDWZFWiHZHU57ot4Knz3c8HPI5oGzSlYZv7QtT13HC7ZG/ZHqXONjpO3ysh1CfT3AgOrQnlCGfNX2g7TjTEDdpUX4vt4cySFjTa/kn+WGRyXnhkX99JvEsfVjz7+Bx1y6NYZjuFtoIAzjH6JALXrhyLr55VCqJ3uwOzgyVUgM34Cc/CKCVBVPPGwhmBeCxP9HX+0Huf0MJOE1y8nJE8l2OY+jZ2TAO6YT9jEqGIwkCb/QumsTe47LeZ9NLeK/hjEC+HyG4zl3jT8uh6mlH0f3MCJ3dJhfu+LPLe82vh/hFGIjzBva10Pkx35SmqBd7jHZUk3uomrA3MZ5WlRCGIcklt9E9I6vgEFWDvLQ0T1+TaycY7vaWlOsgw9LvBOxp8HjibAKE4o9Xw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(6512007)(9686003)(86362001)(186003)(38100700002)(316002)(54906003)(1076003)(6916009)(66574015)(7416002)(6486002)(83380400001)(66556008)(66476007)(8676002)(66946007)(4326008)(508600001)(52116002)(5660300002)(8936002)(6666004)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?IXiSQo7P22TNKEEvkXvNd/7LQqcw7oOMSZ7BZHbqluw03w8KsMna8Wy6kt?=
 =?iso-8859-1?Q?Fh18BzhZ98AGLeexuOzZusdocJMG+fkRQTw5MJqLG8Qeu7W3g0/riI5nZV?=
 =?iso-8859-1?Q?9jzBt/m8u1KQdTepkxQXMc/fyAxDsqVhanz3Gija9CE4cEgrbr67Bi9hT1?=
 =?iso-8859-1?Q?2fXVMgbW1LEt5mCyc95n7JhW4ZYZlvjvwsLVvVSsNL4I9x2dXhQg/sY0LC?=
 =?iso-8859-1?Q?muzZHThF+HPq2BEQ03LQ0FGXsH0SGZPX2LVarPxzK2g8EOdlrZzJeXKmab?=
 =?iso-8859-1?Q?ccwiF8fEJ7pyHkEr40d+GWSi1CR7oi4Ffi7Xq32N+2ipLioNXKUu7GVWom?=
 =?iso-8859-1?Q?gY8QkKJ04SATAGbdnDWA3cqNaK8SPDBfjpV9Sde3dfvkE2V+FOlZLGyDQ7?=
 =?iso-8859-1?Q?nN8Eqa/uv/EQiIYGr5Oqy58/jiIsFVl23JabDDcTAIkMW28R1JwJn2XxRn?=
 =?iso-8859-1?Q?R1Kv3dSkxn2iPuGLwe1r2t4nLCbhJ5bN7EWMNrgVWg76a8rH8BOUHf34kW?=
 =?iso-8859-1?Q?C87FKa+xXbHdx5W/cm2D4wmftG+DGM1jcTm1rwD0aQbAKknJColqkptYSm?=
 =?iso-8859-1?Q?XoIKyfoTxttw74HRu6o5xjrs0Uobyh0j1z0pYvVMYYHGo/A7tMo1kGwvna?=
 =?iso-8859-1?Q?WM26tHmELLvZ3zEza6/VKofF35aEwqGERKs9PRN0hG4PWpuIlAcdTo2tj8?=
 =?iso-8859-1?Q?60AMbXa78h1pLczIaOnLZjQAjKTEGmC+WuAXas04grHdolOOAr88x0CYl0?=
 =?iso-8859-1?Q?0a4rhcQ9dyRsKNG0eZp2U2Z7g3DKYunr9raY7p1Z0DyDvsr1iMct5baPrR?=
 =?iso-8859-1?Q?XK3NExBXHllZU62GF2HlgzoxH0K+wgm1YI7mmsCGd0g+NBTa9h0+qtU1xZ?=
 =?iso-8859-1?Q?sRGdpPCW/MbStjqPX07gy91cD2hk+RRWyGjUU8Hu8FD7zn2edZJQdU8emc?=
 =?iso-8859-1?Q?rwTTGq+LTdUDa+7Q7C9TS5nZ6sHAAsGVbaFtnd3+5vM2fJtMqscN7/x/2E?=
 =?iso-8859-1?Q?heQBC05IhPQRMyTBCTPjCqvNoSXkPtTFo7fND9fjGk9iYeCThxfLps5R+5?=
 =?iso-8859-1?Q?OqV8QnBMPSEBYn5sc4ckeZ2AjGMafZjd7YhfJbi55d0vpYH9yOZI8PG3hH?=
 =?iso-8859-1?Q?s1FZyE4eInTiLi9+TchxIeEESPTXKxf2hN3BjRR5CVOr1clreD6S5jjFnH?=
 =?iso-8859-1?Q?sjSWOuwxTofizc0cZpP8zC8GgdYHL5Fz5J4x1R0IvAE2LIwGY2oTifSefo?=
 =?iso-8859-1?Q?wDHNyvf1YyE/0K4TEDpCpLq5grcmHuvRo01kmGZ/yvj/bUQ4ImdrVcIM7n?=
 =?iso-8859-1?Q?yBe3cgRxkm+6qL1x9WN67Q68dUtXmef+CErdaMUdu1a35F5knSIfhm6jSw?=
 =?iso-8859-1?Q?CoZKMZZFUOPCN9JHfylt/txpQGY6WaCRT3jgTTtQnnxpVkCOiiFgcWdF+t?=
 =?iso-8859-1?Q?Bw0IcvI2GO1bQqjrYemAjbE/fFzlpsbYchQGrUe18zSxeBOee0gT3LemVf?=
 =?iso-8859-1?Q?Cmr3FNsShfNfmrpxnxU4dyACYbX3qZUcHu8oJt/hmnLUKiN6+NM9hi5yNS?=
 =?iso-8859-1?Q?BdTkno+yr2MFz+Peuux+z5iSEL4QT69ev6Lz4HMme+bkMx+shohhktIvsG?=
 =?iso-8859-1?Q?s5ivi3KLIbvGDcBaZBlVZ+y4qg/WDqq3fQ?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff4d5859-ecdb-4271-b0f1-08da01937ea2
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 06:10:22.9787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o/seTBrr9aJkpwVKkad8wEjOAs5Q01B2LYyNeXmCwkRgA1BRxHlf1QEhWao1TVtM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR15MB4173
X-Proofpoint-ORIG-GUID: byXCow3EJ0tVv6tgemxbQoAUQd3w7Dof
X-Proofpoint-GUID: byXCow3EJ0tVv6tgemxbQoAUQd3w7Dof
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-09_02,2022-03-04_01,2022-02-23_01
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 08, 2022 at 03:57:57PM +0100, Toke Høiland-Jørgensen wrote:
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
> +			ret = xdp_update_frame_from_buff(ctx, frm);
> +			if (ret) {
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
> +			ret = xdp_do_redirect_frame(xdp->dev, ctx, frm, prog);
> +			if (ret)
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
> +	if (nframes)
> +		err = xdp_recv_frames(frames, nframes, xdp->skbs, xdp->dev);
This may overwrite the -ENOMEM with 0.

Others lgtm.

> +
> +	xdp_clear_return_frame_no_direct();
> +	local_bh_enable();
> +	return err;
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
