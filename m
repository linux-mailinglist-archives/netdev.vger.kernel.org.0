Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62647274821
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 20:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgIVS0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 14:26:48 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54046 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726563AbgIVS0s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 14:26:48 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 08MICQNN017976;
        Tue, 22 Sep 2020 11:26:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=1fPHxfQQ+dwiqZTeKrC9CKCafHKjg5BwlRreC+8scOc=;
 b=iWJAmzAcH+BqNymu5ttKD0sxVzZJZwnC6ve1xMI5pzosD2Rp6MSQvzwB/QWV6sWENgvl
 zhmSFN+2aT3E/t6abl9/3yqcSfDBexTFgyX4a49orLWq8yHvM1K2dqCsa6MZlpkKpoIy
 1pitITfekbdre6dqyXz682KTFfJJuFsqOEk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 33ndnnykeg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 22 Sep 2020 11:26:31 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 22 Sep 2020 11:26:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SEU/Dk6eTKYgZPCuPSbhBXbhfYzyIrl9k//klWLQpDiKgsKmbKbByAf6gD2sHJZEG/34ZaMgO1YCcotbCw38gD6apJsc4FxHTrg5bsxjy5+J1IBO5ERvPry8FRnVQnh9AVE1GHtYBmgSj1GDC7n2+BhNXQwg35MVlSE0l4jMeBySemrG7yDKpYNvXFgoGzCZcbrbF34X5CL/rRGL0wvD9S224ek6/siOj0VayDORRQcMy07ot4WeWrtPpnwEyX6PWM0yYokCKiC9htoddu9KfhLVNBUuHbZKxcIaYKbFx++rt4NSQgyVlNPQSmWIxIAhZmTLVYwGzFa0Rt8Ly3WFfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1fPHxfQQ+dwiqZTeKrC9CKCafHKjg5BwlRreC+8scOc=;
 b=S8h+mOMbJ6oJYvaS8SyLrWA/hvI17+6eO0XdXJSk5whrSR5dpcIq9sL8h4JmOYXFGx99HAvva9wEVZwOeK69Lm0YnQxBeLfwa3LL+Dp59uTBbR9FFzdRVe8vRSDYvCBeOxlwhIs34OZNd/cLF5bBc6hsXf87FR+MEHg1TIYhWvP38AWBeX51gVlS/6lij432qSsGlCHNpzW0RbHwau9ZrT1sLjyvq54MtZoIUoIz4uRyEPd+K6qpveb1+eKJkGyV1wOha/RBNkBYIKZt4aYcXqATe/O8+dCeejjiMykfs2Ad5Rk27DB5/b8oYEP4X1pKPvemTrCBml4hb7jsON2s6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1fPHxfQQ+dwiqZTeKrC9CKCafHKjg5BwlRreC+8scOc=;
 b=TpB24zZAXFwmF7iMxjHntpNTDfLOo3Hg1zI+z22RETdSjELD4BvJPsaYEHD/Y0AjQAoBAFWjLJHaLRuIIpSwb5ZnDjlobYY2MDI07ugF6KBzu9BsHcB7LzTdJ+VObFNK7cJRtkarUd0EYETLjswOqHLyoPaoniR1GSPcbCoeibg=
Authentication-Results: cloudflare.com; dkim=none (message not signed)
 header.d=none;cloudflare.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BY5PR15MB3715.namprd15.prod.outlook.com (2603:10b6:a03:1fe::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14; Tue, 22 Sep
 2020 18:26:29 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb%3]) with mapi id 15.20.3391.026; Tue, 22 Sep 2020
 18:26:29 +0000
Date:   Tue, 22 Sep 2020 11:26:22 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 bpf-next 02/11] bpf: Enable bpf_skc_to_* sock casting
 helper to networking prog type
Message-ID: <20200922182622.zcrqwpzkouvlndbw@kafai-mbp.dhcp.thefacebook.com>
References: <20200922070409.1914988-1-kafai@fb.com>
 <20200922070422.1917351-1-kafai@fb.com>
 <CACAyw9-LoKFuYxaMODtacJM-rOR0P5Y=j_yEm9bsFZe_j_9rYQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACAyw9-LoKFuYxaMODtacJM-rOR0P5Y=j_yEm9bsFZe_j_9rYQ@mail.gmail.com>
X-ClientProxiedBy: MWHPR03CA0015.namprd03.prod.outlook.com
 (2603:10b6:300:117::25) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:7f66) by MWHPR03CA0015.namprd03.prod.outlook.com (2603:10b6:300:117::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Tue, 22 Sep 2020 18:26:28 +0000
X-Originating-IP: [2620:10d:c090:400::5:7f66]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bcb124fa-c022-4efe-fbb1-08d85f2505b9
X-MS-TrafficTypeDiagnostic: BY5PR15MB3715:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB371568FA6B1D815B67D823FBD53B0@BY5PR15MB3715.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uKmMgzBQxnKiVVq1s2nJdn+3G+D0/04iCkjR9uGjTTyNg1mZ29PF1Y5DKjfKDyMlhJquSPopFP8iYXa61BMeQTRLHR8pDnr42D147AL5gNDT34x1N/9MKyNiKhlbLpkAJs4ys+3yPukIRIZzi1taMX00FRPttzfOSsWNSS+fidW5gZE/722Az8Kgcsg2Fj9h0yWEIFF39a7fWmIgYbwpDeYD6C4boOjsa3bgP6OnHqD7DGTbmsTc0qxK+U75MCNjopG4eKF2wxNir9Bl6wcGt9RzVNtBu9w+PNlDpDENK+D+W3hCQSBLBmHsEGzhCK5M
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(366004)(346002)(136003)(39860400002)(86362001)(6666004)(2906002)(9686003)(478600001)(55016002)(7696005)(66556008)(66946007)(66476007)(316002)(5660300002)(1076003)(52116002)(54906003)(186003)(8936002)(16526019)(4326008)(6506007)(6916009)(3716004)(83380400001)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: mV7QRHuQt/w8BGA21OsKAyCYCzTOn0pUE7n7KzBOPRFSvUkv2L4fx7lUwSEbP6FhaeCVJEeFVZEptv/ExaAUMPT3JfxItn0cpe3lTmnjSQ2Ez+lH7nz9jSPMsQAfBFHHr/UcHV6/53BF702QEltA74D4zyWFrj9Asv6BexbiEzKOOxBxoaxsMqxYCsdhA4BQmxmXsypaH42oT8/8bd3xiXo9pe8KSd3Z++l3mvzkkKQNA6eh9QW6efOIVfqlVqoVdueY+jG0RNqzJ0QQgKOlL9BKN/uxmCCrzE+bi0IirX7zD2d7gmzJgXOVlQ8/re25+YGR04ZjRb8sHrXeekqUUkru/ghTTIcEG5daO6rnTggbKm7h6/ym3rhDlup2Y31aKoI0MR9asxuMJRO91MTQlWKZ1U0CqnUv/HKkqJbZPdnfb+uD4d/5R2UXpsELpaFwSsFyaBpLBAZsmRsWZrJT0Er1g9DNuvBk/8zbzXdrrBY0yVLcupFglsAU0t1MQRTchtqokqcC4dxoRO9gTAFiPJTN9PK5jR4GBiWtHNQpWuOHnk1DKFZx1q+jEZLxFdCtHF/QiF0qTiaNKmDTxVGWE6zPYJ1zDUEHr9R7amsP8OkRJLNzBN5o+0iCMLgiTqbb5P5FCCenCMYe/vejB0dq0LQb0xpnsD9R/FbaP0RDf4U=
X-MS-Exchange-CrossTenant-Network-Message-Id: bcb124fa-c022-4efe-fbb1-08d85f2505b9
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2020 18:26:29.0276
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 69er9Q/LodVg5M75WKlF3yNx+LQpBIEnTh0CPuvFyiF2LdhJfo9AmxSAeJuFsTsi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3715
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-22_17:2020-09-21,2020-09-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 adultscore=0
 mlxlogscore=972 spamscore=0 malwarescore=0 clxscore=1015 suspectscore=1
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009220143
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 22, 2020 at 10:46:41AM +0100, Lorenz Bauer wrote:
> On Tue, 22 Sep 2020 at 08:04, Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > There is a constant need to add more fields into the bpf_tcp_sock
> > for the bpf programs running at tc, sock_ops...etc.
> >
> > A current workaround could be to use bpf_probe_read_kernel().  However,
> > other than making another helper call for reading each field and missing
> > CO-RE, it is also not as intuitive to use as directly reading
> > "tp->lsndtime" for example.  While already having perfmon cap to do
> > bpf_probe_read_kernel(), it will be much easier if the bpf prog can
> > directly read from the tcp_sock.
> >
> > This patch tries to do that by using the existing casting-helpers
> > bpf_skc_to_*() whose func_proto returns a btf_id.  For example, the
> > func_proto of bpf_skc_to_tcp_sock returns the btf_id of the
> > kernel "struct tcp_sock".
> >
> > These helpers are also added to is_ptr_cast_function().
> > It ensures the returning reg (BPF_REF_0) will also carries the ref_obj_id.
> > That will keep the ref-tracking works properly.
> >
> > The bpf_skc_to_* helpers are made available to most of the bpf prog
> > types in filter.c. They are limited by perfmon cap.
> >
> > This patch adds a ARG_PTR_TO_BTF_ID_SOCK_COMMON.  The helper accepting
> > this arg can accept a btf-id-ptr (PTR_TO_BTF_ID + &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON])
> > or a legacy-ctx-convert-skc-ptr (PTR_TO_SOCK_COMMON).  The bpf_skc_to_*()
> > helpers are changed to take ARG_PTR_TO_BTF_ID_SOCK_COMMON such that
> > they will accept pointer obtained from skb->sk.
> >
> > PTR_TO_*_OR_NULL is not accepted as an ARG_PTR_TO_BTF_ID_SOCK_COMMON
> > at verification time.  All PTR_TO_*_OR_NULL reg has to do a NULL check
> > first before passing into the helper or else the bpf prog will be
> > rejected by the verifier.
> >
> > [ ARG_PTR_TO_SOCK_COMMON_OR_NULL was attempted earlier.  The _OR_NULL was
> >   needed because the PTR_TO_BTF_ID could be NULL but note that a could be NULL
> >   PTR_TO_BTF_ID is not a scalar NULL to the verifier.  "_OR_NULL" implicitly
> >   gives an expectation that the helper can take a scalar NULL which does
> >   not make sense in most (except one) helpers.  Passing scalar NULL
> >   should be rejected at the verification time.
> 
> What is the benefit of requiring a !sk check from the user if all of
> the helpers know how to deal with a NULL pointer?
I don't see a reason why the verifier should not reject an incorrect
program at load time if it can.

> 
> >
> >   Thus, this patch uses ARG_PTR_TO_BTF_ID_SOCK_COMMON to specify that the
> >   helper can take both the btf-id ptr or the legacy PTR_TO_SOCK_COMMON but
> >   not scalar NULL.  It requires the func_proto to explicitly specify the
> >   arg_btf_id such that there is a very clear expectation that the helper
> >   can handle a NULL PTR_TO_BTF_ID. ]
> 
> I think ARG_PTR_TO_BTF_ID_SOCK_COMMON is actually a misnomer, since
> nothing enforces that arg_btf_id is actually an ID for sock common.
> This is where ARG_PTR_TO_SOCK_COMMON_OR_NULL is much easier to
> understand, even though it's more permissive than it has to be. It
> communicates very clearly what values the argument can take.
_OR_NULL is incorrect which implies a scalar NULL as mentioned in
this commit message.  From verifier pov, _OR_NULL can take
a scalar NULL.

> 
> If you're set on ARG_PTR_TO_BTF_ID_SOCK_COMMON I'd suggest forcing the
> btf_id in struct bpf_reg_types. This avoids the weird case where the
> btf_id doesn't actually point at sock_common, and it also makes my
I have considered the bpf_reg_types option.  I prefer all
arg info (arg_type and arg_btf_id) stay in the same one
place (i.e. func_proto) as much as possible for now
instead of introducing another place to specify/override it
which then depends on a particular arg_type that some arg_type may be
in func_proto while some may be in other places.

The arg_btf_id can be checked in check_btf_id_ok() if it would be a
big concern that it might slip through the review but I think the
chance is pretty low.


