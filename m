Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DACE24C860
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 01:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728698AbgHTXRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 19:17:53 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:59448 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728498AbgHTXRu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 19:17:50 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07KNGT0v009723;
        Thu, 20 Aug 2020 16:16:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=vzmTT8AIr+31nFzjHxlcbRTnFvaBf8cAC/A9LiNVkkc=;
 b=IrfwCVPcVnslN32QMe2c813ff9hfFG1/0FST9hQB2OScQ4W7zmaBb/xUf9QWHu9ftbmL
 kuLJW2C/jUVetmkwAChLaAjqgOvpPVVwu+eAWbJ0b4jtPEf5dDletQNumOuWh4AC966M
 OTbsAVYlzWv7KZ45QyU9KmVzvhUT531vz5I= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 331cue6c5e-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 20 Aug 2020 16:16:33 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 20 Aug 2020 16:16:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Im9rU5VkYaE4ZCIvpXAfAq3vTZ6XVg9I4K7Ngp9kl78u+gYnmJovOLOGT2NjwwXPgkT7UF2zNWzpxbIRfRRnjlpyVso0LxlVg7yafRZg7kMwck6hAk1lM9n9dEoGtINLiMW0VKby0cs6e71OB274pBs2A52a/7Xja1KdAqtZRjZ5Zjpwe7R1DDok9tR2g3nIfV3r6zHIRltThdbb+g7D6NFFA8b1pjYvWhphvjBDIoHdHA7R/cqS5RWjpV5fG+X230A3lk7lFvkbbM+hofvrDky6mrdpfavDsLBwHkUFx6ree3KyXhUP118el2N+8bsLC237cBF0cGhIIQcE11SZAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vzmTT8AIr+31nFzjHxlcbRTnFvaBf8cAC/A9LiNVkkc=;
 b=GqaV/J0dKKm6L8D7UGUrokUSQ542yWJSX5Ppb8V7/ekpaE+beN4WwJH0a/2otY/j8MrQkvrvpVLxljtkxRfroJufVOMixrth+BtyTmyABMOvAzrVipQYP0jCJaTo6r/Z2J6ORu8/F01KAsBj9KAGvS1dfQELpZEFwft3n05Dkpgy8kEJLFCayEO7TTNb72G94KjyUGbSn1bLIxzIkeXc+RPi38lySAUnwo8YRvHT2dhtYzwSTEijcYvwrOnW36tElZiHSZkxKLjcN2aZfR6/PYEST5v2nfqKQXF5gn3Ab5ljhfaaobFLXCSCg3QicUf3DvNwLzDSNHH43cWa0W8P4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vzmTT8AIr+31nFzjHxlcbRTnFvaBf8cAC/A9LiNVkkc=;
 b=lSPw21ePonTFKuhqH8XrupiG4zNvklJNhxkT+DyQgwWQyVB4ncp+iobVba99tRdZt0UrvC72kYG4Bj6271Fv3Fxan740+bvxi6jhzWTKjQGIVcJWa0hbeefZWqULJ7XlEg8lqIu9tyXdJOqRXNKnY9sOHq8XIb4YP32vQEB3Vao=
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2725.namprd15.prod.outlook.com (2603:10b6:a03:158::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.20; Thu, 20 Aug
 2020 23:16:26 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d489:8f7f:614e:1b99]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d489:8f7f:614e:1b99%7]) with mapi id 15.20.3283.018; Thu, 20 Aug 2020
 23:16:26 +0000
Date:   Thu, 20 Aug 2020 16:16:20 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
CC:     <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>, <kernel-team@fb.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Neal Cardwell <ncardwell@google.com>, <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Subject: Re: [PATCH v5 bpf-next 07/12] bpf: tcp: Add bpf_skops_hdr_opt_len()
 and bpf_skops_write_hdr_opt()
Message-ID: <20200820231620.dorvpjme6lqqe4iq@kafai-mbp.dhcp.thefacebook.com>
References: <20200820190008.2883500-1-kafai@fb.com>
 <20200820190052.2885316-1-kafai@fb.com>
 <alpine.OSX.2.23.453.2008201529350.59053@mjmartin-mac01.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.OSX.2.23.453.2008201529350.59053@mjmartin-mac01.local>
X-ClientProxiedBy: BYAPR01CA0008.prod.exchangelabs.com (2603:10b6:a02:80::21)
 To BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:101) by BYAPR01CA0008.prod.exchangelabs.com (2603:10b6:a02:80::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Thu, 20 Aug 2020 23:16:25 +0000
X-Originating-IP: [2620:10d:c090:400::5:101]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7d61e690-ad6a-42aa-f0b1-08d8455f0fba
X-MS-TrafficTypeDiagnostic: BYAPR15MB2725:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB272575E630A01C47A01656ECD55A0@BYAPR15MB2725.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yC8akGC5/IjdupTzrQXYDwkprPRgCID9NW6hvRcYQU6ER0jWacDoKgVbRytra/9jWec6jLkFF60zihfDwTIW/H4DxodU8InlJIkpGxGv50HgVbhNuV3Eub/6j5AfizAzf6Ec53wsg1aZhz/6cAaSq8idSarulAk3Pu6mXjkhfIAqLV39iiWddnAFBLNtWKI8bQxzzXu9m90rWgAYZsSWGdZCxPnlUFy9erfubhk7thh92WMHo94FMb58AVY+hSHVM5QDNCcJucsGxsbo3FPVzCePbUQpx80scJenVsSBbE3joA8549dgvI6UmLAAfjbYD4O7OhypjunuvcQFBD6r9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(366004)(136003)(396003)(6506007)(5660300002)(66476007)(66946007)(316002)(7696005)(66556008)(6916009)(2906002)(54906003)(52116002)(1076003)(8676002)(4326008)(16526019)(86362001)(83380400001)(186003)(55016002)(478600001)(9686003)(8936002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 6DyhzPKhDCS+14KK2i9dWZLEhOJ6YdLpNLwD3RAifuTo9YbRqFM+l6Ovk/gsMvg2v8LFKlYKZmrxL0OulVB/kv8X6UAXTW7Sx0mULqcKH6HxXvE/1VuBAe8FbN0W+2ij7rG54CLIAh0eCwo7b90vM4NXN8TkkcpeFSpp5TLoCnvFa3kQNyzoNVJ291GAzxbHgrp9jQ0bpSistqr7rGDfiNl602TpzR/u+iiJfQa5QxO0KiNusZsVKLW8UUqGV4CHkxX291IM+e+lV9nHWI8jhasUr8VzjJ6u92YPrnkBaPtL9VQkscnZ0POzOEnZKgDSsr7/avR0b+mbHB8Ncd7u4jwi9JloAs4PYUaqNpbFTmORFZXfFrXsq9pF3/cp/yUs/BWFFiKzU5+MP6AcZGn18qXStzyVQRwfvXHteVyPr0MxNZDjWH8u8zg4wvRmLjdvxhxd7S0iPZHGVCiSKNYOtDH6w88u9HPSnniWPceRzGqxyCQT3v8xLHkj44NT8eMBaTeWh4V36oYc37u6WwWszYDeyr6JeuUR7nMbs6xPPF/fY2FKIyNxGvV0fc/EW6Ae0ANKYN4bcsi/izLGuHes0W9HF2oVVaRIp6GoZsaccHbOG39EIc8Zk1EuSPu2LDz3vb726Xh8ymshcZX2JyGAXfr+e31WWr8u+ZFEGqDdCiQ=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d61e690-ad6a-42aa-f0b1-08d8455f0fba
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2020 23:16:26.2593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kBoJp002Me/iuVHVpWd4b+DB7kWjfyvxIU5W9lBWGvCRb9A1JXJ9SN6eSIyKoh5L
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2725
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-20_07:2020-08-19,2020-08-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1011
 priorityscore=1501 suspectscore=1 spamscore=0 impostorscore=0 mlxscore=0
 adultscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008200190
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 20, 2020 at 03:39:21PM -0700, Mat Martineau wrote:
> 
> On Thu, 20 Aug 2020, Martin KaFai Lau wrote:
> 
> > The bpf prog needs to parse the SYN header to learn what options have
> > been sent by the peer's bpf-prog before writing its options into SYNACK.
> > This patch adds a "syn_skb" arg to tcp_make_synack() and send_synack().
> > This syn_skb will eventually be made available (as read-only) to the
> > bpf prog.  This will be the only SYN packet available to the bpf
> > prog during syncookie.  For other regular cases, the bpf prog can
> > also use the saved_syn.
> > 
> > When writing options, the bpf prog will first be called to tell the
> > kernel its required number of bytes.  It is done by the new
> > bpf_skops_hdr_opt_len().  The bpf prog will only be called when the new
> > BPF_SOCK_OPS_WRITE_HDR_OPT_CB_FLAG is set in tp->bpf_sock_ops_cb_flags.
> > When the bpf prog returns, the kernel will know how many bytes are needed
> > and then update the "*remaining" arg accordingly.  4 byte alignment will
> > be included in the "*remaining" before this function returns.  The 4 byte
> > aligned number of bytes will also be stored into the opts->bpf_opt_len.
> > "bpf_opt_len" is a newly added member to the struct tcp_out_options.
> > 
> > Then the new bpf_skops_write_hdr_opt() will call the bpf prog to write the
> > header options.  The bpf prog is only called if it has reserved spaces
> > before (opts->bpf_opt_len > 0).
> > 
> > The bpf prog is the last one getting a chance to reserve header space
> > and writing the header option.
> > 
> > These two functions are half implemented to highlight the changes in
> > TCP stack.  The actual codes preparing the bpf running context and
> > invoking the bpf prog will be added in the later patch with other
> > necessary bpf pieces.
> > 
> > Reviewed-by: Eric Dumazet <edumazet@google.com>
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
> > include/net/tcp.h              |   6 +-
> > include/uapi/linux/bpf.h       |   3 +-
> > net/ipv4/tcp_input.c           |   5 +-
> > net/ipv4/tcp_ipv4.c            |   5 +-
> > net/ipv4/tcp_output.c          | 105 +++++++++++++++++++++++++++++----
> > net/ipv6/tcp_ipv6.c            |   5 +-
> > tools/include/uapi/linux/bpf.h |   3 +-
> > 7 files changed, 109 insertions(+), 23 deletions(-)
> > 
> 
> ...
> 
> > diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> > index 5084333b5ab6..631a5ee0dd4e 100644
> > --- a/net/ipv4/tcp_ipv4.c
> > +++ b/net/ipv4/tcp_ipv4.c
> 
> ...
> 
> > @@ -826,6 +886,15 @@ static unsigned int tcp_established_options(struct sock *sk, struct sk_buff *skb
> > 			opts->num_sack_blocks * TCPOLEN_SACK_PERBLOCK;
> > 	}
> > 
> > +	if (unlikely(BPF_SOCK_OPS_TEST_FLAG(tp,
> > +					    BPF_SOCK_OPS_WRITE_HDR_OPT_CB_FLAG))) {
> > +		unsigned int remaining = MAX_TCP_OPTION_SPACE - size;
> > +
> > +		bpf_skops_hdr_opt_len(sk, skb, NULL, NULL, 0, opts, &remaining);
> > +
> > +		size = MAX_TCP_OPTION_SPACE - remaining;
> > +	}
> > +
> > 	return size;
> > }
> > 
> 
> Since bpf_skops_hdr_opt_len() is called after the SACK code tries to use up
> all remaining option space for SACK blocks, it's less likely that there will
> be sufficient space remaining. Did you consider moving this hunk before the
> SACK option space is allocated to give the bpf prog higher priority?
No.  Not at this point.

It is unlike a well defined option (e.g. MPTCP) that may have a
requirement on being presence in the header.  For a generic usage in bpf,
it is hard to judge if a bpf program is writing a higher priority option.
Also considering SACK is a transient behavior, the bpf prog will eventually
get its chance to write.  The bpf prog should always assume there may not have
enough space and ready to retry later.
