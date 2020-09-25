Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB36278FF2
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 19:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729670AbgIYR62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 13:58:28 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56780 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726401AbgIYR62 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 13:58:28 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08PHt4JA027680;
        Fri, 25 Sep 2020 10:58:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=dNuTWTy9BbnatcAdOTA3PoT4vaBXD33k5Wh52tRjuus=;
 b=k8yjjn6cLXJICQ68lJ/xTctEvAtW5qQDqtxg+Nix4Kiqm2FF8+aSIKI5uIiKlgxSU6iq
 etQelYDLLGS7nZSQ7pzYd5a0Y++TyQarJs6IJBhI80KreLWQ0Fz98jECfU9Q7wmbC/xL
 H/kt1SlpEC2/rJZhOgdDEG3i1HiAOxh5+yI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33qsp7h06b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 25 Sep 2020 10:58:13 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 25 Sep 2020 10:58:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=csY+sj9Jb4GR8XdtvimeZWJJJRFWSzQ1m95ol0M9N/lYP8wsXtvx0fdg5GlFxOCvnUWs63wO9/5OXG7cSOV3sjV2DnQuXgydiXShSgV6pl5YeluzHnk2xaXimEXBoHkL/+NOhZt8Hc86MX0uDsvn359f+TDL6NvzgbvFZbZZZ15qY8LtooTL68Vkeg+qwZQt8xJ+QI+j7PX4hX1qc/S19xQyraU4h6iz6m0fEaTTI9ucX07RJAWGcQ2xtVDrVohVVKO5WHDbV1P/JV/uv409EVIEmsnBQkYLE9OWWNmsdyInBStvrTzSgnnAckYuaxLgQUL1w3yKqeoUIxZOWd5jrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dNuTWTy9BbnatcAdOTA3PoT4vaBXD33k5Wh52tRjuus=;
 b=Hs4fDyYlR0Pfenz/i6snt9IyZklERx9w2qKHOY5Gew6ZB0U5JEjazZSmQv6wQc6sgv9PvuQYeDWZVG5dKHJ8FgRj132c6nS2hmqZcf+XeYOiB5UQzvAjioElhngSQk9fV4nBBP/nsj3+3LAV0dhcJDEALV9ZxX1fqlLBP4kNpQnbBpmLSsNB5L4ktZnwKUfLr7B/4QytHBmDTClsNRPo+J/YF1P/RWMMdt5w2BxDL3XGbYvNqr/Dg79bN1ANK2qsH56OUyVAHtZQ98ocbq/ltSDhJCaxElfMl5Auq9g0RTmRt2EeQasYsChJTeqXPtW/Nemi3Lr2Zf0UuAYJomg42A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dNuTWTy9BbnatcAdOTA3PoT4vaBXD33k5Wh52tRjuus=;
 b=BVh3wDXNxd7Q99EggW9zfwU02o5H2u1IP4Hz+KTdD+cs2K0n+semwLXPsf7u7IBiSLa0PGBar/T2Kd0Y6JbDcwZff+d/ZK/1AT22mQqzjMnWxMO5dg7uXQKIJPCXslFg5/pz1CUXsl1iMCDi7EX7IuVVbTJSgkJ9cjolz6wuQOE=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2949.namprd15.prod.outlook.com (2603:10b6:a03:f8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Fri, 25 Sep
 2020 17:58:09 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb%3]) with mapi id 15.20.3391.027; Fri, 25 Sep 2020
 17:58:09 +0000
Date:   Fri, 25 Sep 2020 10:58:02 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     John Fastabend <john.fastabend@gmail.com>
CC:     <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v4 bpf-next 13/13] bpf: selftest: Add
 test_btf_skc_cls_ingress
Message-ID: <20200925175712.uanka7nq5rjlrfht@kafai-mbp>
References: <20200925000337.3853598-1-kafai@fb.com>
 <20200925000458.3859627-1-kafai@fb.com>
 <5f6e19a2621d8_8ae15208fd@john-XPS-13-9370.notmuch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f6e19a2621d8_8ae15208fd@john-XPS-13-9370.notmuch>
X-ClientProxiedBy: CO2PR05CA0089.namprd05.prod.outlook.com
 (2603:10b6:104:1::15) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:4e29) by CO2PR05CA0089.namprd05.prod.outlook.com (2603:10b6:104:1::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.7 via Frontend Transport; Fri, 25 Sep 2020 17:58:08 +0000
X-Originating-IP: [2620:10d:c090:400::5:4e29]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e4b4699-4e73-4994-5a8d-08d8617c8fcc
X-MS-TrafficTypeDiagnostic: BYAPR15MB2949:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2949F276C87EEEE91D4C6C8DD5360@BYAPR15MB2949.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: INH/vIQD3kKzHg4mobBtrlcIxdnGJUhpYL/kbfclSEuOQ/kl4wn3wPvE1Dq0RN2SkE+dk9dwE8Tbiz1rtbDdBFOqeuBDImi8w/OVFGVxZVG6XGMqUPbEQ0ILeSDDU1ZKV7rqa6GhXoNr8ekd3yRKgfkypYPxRXucWMbQ174+Wnl52x+c4A587vDjIEat27+RSBDaWLLIx+vmnE1RdZ1gKte8RHbbYZGMbQ/sYAHP4iu2ZhBFJlHV4i23uY+BXUxNyvrJh7+9mjcbaAjUUGoR98N2G9X8vKpfFe9yDOEul2lUXR/zzxua7u9UWyGQ6Qs7qjSDeFiZ2R5aV7ltRXHHHSYogDUiNHKFxs55IdIlQ6oDAak6pRFktKAO2yiSGUvG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(396003)(366004)(376002)(346002)(66476007)(55016002)(2906002)(1076003)(9686003)(66946007)(86362001)(83380400001)(6666004)(8936002)(66556008)(8676002)(4326008)(54906003)(5660300002)(316002)(6916009)(52116002)(33716001)(186003)(6496006)(478600001)(16526019);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: wNQf246alT/KNyObjIj9/LKS+lQeuluKs/erCBwEI1CvrE5yErbD5sV4E3LO74lXMWxWMd7HyGEdP8EAf0sIqayCxc7dtPk2ov1s2hHu/QyT1tWD32qOPVVUTwDlgaz81oLN4n7f4SRbo+JGd+67i+uGpUtrNdALUzLfXOO4qb9VNCe2cak/J1u3M4qWTphL8uInJsuYwMGmjYF+tZjetJgbK3bsqg5qP5Fymz00pUnp1bRwYQM2hZJ7l/HdcDEkLmdVFzaVc7jmli2WPPvXneq/T18H4wO6/QK3Y7EajMukEK6EtuRKAi4FHckNc78dQROpuz3N9+HJa5qpi6CLiyER+YITkeCssPpuN6c/vqc1QWhktpdRnZZZx/26dzWQarfeqyvPMcyV+fV5T4dHoL/xIFNoVCAXJeFne8aCOmRPh9RaMbuASxrylKG74mI/OhlfdOlNr1uwfR2s07ILQ4Pqy2v6eYcR6r5hj+DZlSaaf0+SCQOHOv0k0WX5rwoscX+9UOxg3cGuldJO1PehUgKsN5PAQomnuWwidsm4n7iNHDuSP+36UjhZChFK8xdboAhREAcZNJdmmk/KFvrLWSQNFWu61KlVlH8SWMPeFKwnFJRRubM0liDlYDLSC9zG4ibtCwyi1/Qo4okifVigGyBmDhqHR0SQ2LttNhSMdZ8=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e4b4699-4e73-4994-5a8d-08d8617c8fcc
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2020 17:58:09.2326
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bx0chHN5ZdeT5JNWVrf3mts1Ol/Q5a7dgZjqLQpqonn9wPgc/e1Is1U8bzybdDHI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2949
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-25_15:2020-09-24,2020-09-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 mlxlogscore=704 impostorscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 spamscore=0 suspectscore=1
 clxscore=1015 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009250126
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 25, 2020 at 09:24:02AM -0700, John Fastabend wrote:
[ ... ]

> Hi Martin,
> 
> One piece I'm missing is how does this handle null pointer dereferences
> from network side when reading BTF objects? I've not got through all the
> code yet so maybe I'm just not there yet.
> 
> For example,
> 
> > diff --git a/tools/testing/selftests/bpf/bpf_tcp_helpers.h b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
> > index a0e8b3758bd7..2915664c335d 100644
> > --- a/tools/testing/selftests/bpf/bpf_tcp_helpers.h
> > +++ b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
> > @@ -16,6 +16,7 @@ BPF_PROG(name, args)
> >  
> >  struct sock_common {
> >  	unsigned char	skc_state;
> > +	__u16		skc_num;
> >  } __attribute__((preserve_access_index));
> >  
> >  enum sk_pacing {
> > @@ -45,6 +46,10 @@ struct inet_connection_sock {
> >  	__u64			  icsk_ca_priv[104 / sizeof(__u64)];
> >  } __attribute__((preserve_access_index));
> >  
> > +struct request_sock {
> > +	struct sock_common		__req_common;
> > +} __attribute__((preserve_access_index));
> > +
> >  struct tcp_sock {
> >  	struct inet_connection_sock	inet_conn;
> 
> add some pointer from tcp_sock which is likely not set so should be NULL,
> 
>         struct tcp_fastopen_request *fastopen_req;
> 
> [...]
> 
> > +	if (bpf_skc->state == BPF_TCP_NEW_SYN_RECV) {
> > +		struct request_sock *req_sk;
> > +
> > +		req_sk = (struct request_sock *)bpf_skc_to_tcp_request_sock(bpf_skc);
> > +		if (!req_sk) {
> > +			LOG();
> > +			goto release;
> > +		}
> > +
> > +		if (bpf_sk_assign(skb, req_sk, 0)) {
> > +			LOG();
> > +			goto release;
> > +		}
> > +
> > +		req_sk_sport = req_sk->__req_common.skc_num;
> > +
> > +		bpf_sk_release(req_sk);
> > +		return TC_ACT_OK;
> > +	} else if (bpf_skc->state == BPF_TCP_LISTEN) {
> > +		struct tcp_sock *tp;
> > +
> > +		tp = bpf_skc_to_tcp_sock(bpf_skc);
> > +		if (!tp) {
> > +			LOG();
> > +			goto release;
> > +		}
> > +
> > +		if (bpf_sk_assign(skb, tp, 0)) {
> > +			LOG();
> > +			goto release;
> > +		}
> > +
> 
> 
> Then use it here without a null check in the BPF program,
> 
>                 fastopen = tp->fastopen_req;
fastopen is in PTR_TO_BTF_ID here.

> 		if (fastopen->size > 0x1234)
This load will be marked with BPF_PROBE_MEM.

>                       (do something)
> 
> > +		listen_tp_sport = tp->inet_conn.icsk_inet.sk.__sk_common.skc_num;
> > +
> > +		test_syncookie_helper(ip6h, th, tp, skb);
> > +		bpf_sk_release(tp);
> > +		return TC_ACT_OK;
> > +	}
> 
> My quick check shows this didn't actually fault and the xlated
> looks like it did the read and dereference. Must be missing
> something? We shouldn't have fault_handler set for cls_ingress.
By xlated, do you mean the interpreter mode?  The LDX_PROBE_MEM
is done by bpf_probe_read_kernel() in bpf/core.c.

I don't think the handling of PTR_TO_BTF_ID is depending on
prog->type.

> 
> Perhaps a comment in the cover letter about this would be
> helpful? Or if I'm just being dense this morning let me know
> as well. ;)
> 
