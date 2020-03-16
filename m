Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D48F3187609
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 00:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732880AbgCPXDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 19:03:32 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58408 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732854AbgCPXDc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 19:03:32 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02GMswMT018605;
        Mon, 16 Mar 2020 16:03:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=AmLHjbOjHMCFh34G9DCXzmubytsXLMfpMjG4QgQ/9ME=;
 b=IAnrP6r4DL/8rNdefzC6gnmedAI2A2cCcl/mT8YBktXxovn65TprUMNCQmbYMMeioaNJ
 Fx/04FzYi3Xgsvhi+J8nIQVyBzxoHJ7r1vBRicsnes4Nqzre3hP+J1kX1BH5xSz2mGcT
 awl8M+8Mmg3Wb9e6LcITR0PG2hdGZos7J+I= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ysf9nycrv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 16 Mar 2020 16:03:18 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 16 Mar 2020 16:03:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dXzXOKqeenNeJoxwJodWtn4EwSBxe9raNZZA831iwlhKx4uWfeKEL5zKg+HICIjxgnDBuP83ouEx41hUJ/gsomRDnKcR9EsnTF38lC+P1qa7yNYFpfU7rjz29E5OGd05HnGOv3GX0Yb9tKwi1wZwq/kOeDumenmoCwBgP0VB4/oN5yLa1/KoKI0REGd6h2IULB/dUtp5gZ0zkYQw9OljTe7tv5YdlpBlujZH1/piBLNrHO5uuc9IVzc/o2d4rGTDrTkpP9sndtBhH2fTT2U4aUA9EsQyNKwuR/eFxtCqIbxiaIO8DSqaTzXzOrxgdubAdV1cpfpmHqROU+gzVj9gVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AmLHjbOjHMCFh34G9DCXzmubytsXLMfpMjG4QgQ/9ME=;
 b=Mdz0wf/63kiXXJeWlAMAmYXtCmgMicGkFz4AtpB2gVSOL3cnicR2GstzMf4NSlyaecX0QynFLY4x4EX0LJRmLWD5QI5XC2FsVC5YwxKZobrxpIQJ28uRa+UStJiN3wIiyliUm82tNuu00NK6BnMsILiTE1DUEgVjNB/hrbb+AkbdlDTAyWfHv+m2BNZ82Wx6un5PLRBvS8sL87xFQCC/FERdFfFJcJYrNnKFE8KukWorBLjMCdNxcMz3xHd7/OibH565RjvfSdjEf//ZtdtoqssXLxoky1ELGgLDWdc4CkYj9efPBf5QzTTpgQ9KloTtiEFpX5hJNc9biAWkUWXfTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AmLHjbOjHMCFh34G9DCXzmubytsXLMfpMjG4QgQ/9ME=;
 b=C/XRHlnn3t4WNoKbhCR2njQZIWIBcp2/VYQtw3G/AYFYhpykChfADlrVTbkk2cRmQvb1GQ5AtvYSucWOv4vg/LwY/+eQNSPe1eAOFmwNyXuV/M+GvOAXmGuc+2E3f5nkE+pN//7NUBi3G/uwfdVsJOoaHURo/HiR7HdNgMhYUfE=
Received: from BYAPR15MB2278.namprd15.prod.outlook.com (2603:10b6:a02:8e::17)
 by BYAPR15MB4135.namprd15.prod.outlook.com (2603:10b6:a03:a0::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.22; Mon, 16 Mar
 2020 23:03:15 +0000
Received: from BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47]) by BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47%4]) with mapi id 15.20.2814.021; Mon, 16 Mar 2020
 23:03:15 +0000
Date:   Mon, 16 Mar 2020 16:03:12 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Joe Stringer <joe@wand.net.nz>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <daniel@iogearbox.net>, <ast@kernel.org>, <eric.dumazet@gmail.com>,
        <lmb@cloudflare.com>
Subject: Re: [PATCH bpf-next 4/7] dst: Prefetch established socket
 destinations
Message-ID: <20200316230312.oxgsjpyzhp5iiyyx@kafai-mbp>
References: <20200312233648.1767-1-joe@wand.net.nz>
 <20200312233648.1767-5-joe@wand.net.nz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200312233648.1767-5-joe@wand.net.nz>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: MWHPR22CA0062.namprd22.prod.outlook.com
 (2603:10b6:300:12a::24) To BYAPR15MB2278.namprd15.prod.outlook.com
 (2603:10b6:a02:8e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:e745) by MWHPR22CA0062.namprd22.prod.outlook.com (2603:10b6:300:12a::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.14 via Frontend Transport; Mon, 16 Mar 2020 23:03:14 +0000
X-Originating-IP: [2620:10d:c090:400::5:e745]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce4edf5d-cce7-48cc-b4e5-08d7c9fe3592
X-MS-TrafficTypeDiagnostic: BYAPR15MB4135:
X-Microsoft-Antispam-PRVS: <BYAPR15MB41355E239C8325CC29A9CFC3D5F90@BYAPR15MB4135.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 03449D5DD1
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(366004)(346002)(136003)(376002)(396003)(39860400002)(199004)(86362001)(66946007)(4326008)(66476007)(81166006)(81156014)(1076003)(8936002)(8676002)(66556008)(5660300002)(33716001)(478600001)(6916009)(52116002)(6496006)(316002)(55016002)(9686003)(2906002)(186003)(16526019);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB4135;H:BYAPR15MB2278.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /c1O20cmLBOdMHMGpYR9bPEHd1l8Vugupg46kB79QdHyX7KdHL7+l7a2u71QB5/c/jDJW75EE6ugcELwH3j+gVoEOmQ27XnkzW9Nkvv+BtQkKqFbBmR5c7DVrT4eJQIzeCBjYK4sCpzZCSgy2IBLXf/wtQegULHSTgJPyyAmNp81SK4LJT+gUKU+D/hs3H+9EizQ3Fc3ePRT0mI/YDkbz5MVGVpBj8Jy9Wiu6To6LSf+lJL1RFqrn3dDuP5C4lbr6wJjOvQt7yWUXBRVzDPuI4Jj1t2KK5vxTsRBgCLrs3GbxKYDne5DzGt1MvVy/bQ06pYvibkq7X65tfCTb8hUV3zyOQEjR5W2ARfpe0RUJIYL79q1/qk9PrC2G21Sld1ZoUVASxeMhvLaQWkrwSfEU22l3O6jYR6d6WC6b81PnHz1MXfCWO//MvbBFFJ/FGmB
X-MS-Exchange-AntiSpam-MessageData: zYHvL8OV71vqUMfJ8yxe0opXDB0CQeqkZuzkgIc+qJLnqrP7djQctxiqa57eScUoGsW9EDmAdvEXCoboN1iYGHmqGlQ6+7wftXPIdUSh5FE8ZPTeyRpKsmSjtHu6jZatKgdbRJClRQ1rawOsInXhPfx63DEZvCNjLI7lHqfCR+5Xns6M2Dqk3r5leOgwf2pC
X-MS-Exchange-CrossTenant-Network-Message-Id: ce4edf5d-cce7-48cc-b4e5-08d7c9fe3592
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2020 23:03:15.6766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p4PF1p5Bm6vijEUEZqgKKhv5vcnvm2I1ayT8HoMoPZqkS6LmBWO6Nu6E2qHUFd7b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4135
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-16_10:2020-03-12,2020-03-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 bulkscore=0 impostorscore=0 spamscore=0 clxscore=1015 phishscore=0
 mlxscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003160094
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 12, 2020 at 04:36:45PM -0700, Joe Stringer wrote:
> Enhance the dst_sk_prefetch logic to temporarily store the socket
> receive destination, to save the route lookup later on. The dst
> reference is kept alive by the caller's socket reference.
> 
> Suggested-by: Daniel Borkmann <daniel@iogearbox.net>
> Signed-off-by: Joe Stringer <joe@wand.net.nz>
> ---
>  include/net/dst_metadata.h |  2 +-
>  net/core/dst.c             | 20 +++++++++++++++++---
>  net/core/filter.c          |  2 +-
>  3 files changed, 19 insertions(+), 5 deletions(-)
> 
> diff --git a/include/net/dst_metadata.h b/include/net/dst_metadata.h
> index 31574c553a07..4f16322b08d5 100644
> --- a/include/net/dst_metadata.h
> +++ b/include/net/dst_metadata.h
> @@ -230,7 +230,7 @@ static inline bool skb_dst_is_sk_prefetch(const struct sk_buff *skb)
>  	return dst_is_sk_prefetch(skb_dst(skb));
>  }
>  
> -void dst_sk_prefetch_store(struct sk_buff *skb);
> +void dst_sk_prefetch_store(struct sk_buff *skb, struct sock *sk);
>  void dst_sk_prefetch_fetch(struct sk_buff *skb);
>  
>  /**
> diff --git a/net/core/dst.c b/net/core/dst.c
> index cf1a1d5b6b0a..5068d127d9c2 100644
> --- a/net/core/dst.c
> +++ b/net/core/dst.c
> @@ -346,11 +346,25 @@ EXPORT_SYMBOL(dst_sk_prefetch);
>  
>  DEFINE_PER_CPU(unsigned long, dst_sk_prefetch_dst);
>  
> -void dst_sk_prefetch_store(struct sk_buff *skb)
> +void dst_sk_prefetch_store(struct sk_buff *skb, struct sock *sk)
>  {
> -	unsigned long refdst;
> +	unsigned long refdst = 0L;
> +
> +	WARN_ON(!rcu_read_lock_held() &&
> +		!rcu_read_lock_bh_held());
> +	if (sk_fullsock(sk)) {
> +		struct dst_entry *dst = READ_ONCE(sk->sk_rx_dst);
> +
> +		if (dst)
> +			dst = dst_check(dst, 0);
v6 requires a cookie.  tcp_v6_early_demux() could be a good example.

> +		if (dst)
> +			refdst = (unsigned long)dst | SKB_DST_NOREF;
> +	}
> +	if (!refdst)
> +		refdst = skb->_skb_refdst;
> +	if (skb->_skb_refdst != refdst)
> +		skb_dst_drop(skb);
>  
> -	refdst = skb->_skb_refdst;
>  	__this_cpu_write(dst_sk_prefetch_dst, refdst);
>  	skb_dst_set_noref(skb, (struct dst_entry *)&dst_sk_prefetch.dst);
>  }
