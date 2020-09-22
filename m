Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97BCB274840
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 20:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgIVSig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 14:38:36 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:60194 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726526AbgIVSif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 14:38:35 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08MIUrsQ022380;
        Tue, 22 Sep 2020 11:38:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=A8BLL8yAZGKjalkBs6Aec8RVsqCOuOUVetaOxCPLeYQ=;
 b=iK4JfkQJAiygMBilBUJEMrq7Zt1CKFbvbgfEBw0knI9i7La/+u9E6nPXkWhfjupi1AQM
 HycVXDtfCvIuzJe28LVKqMpbNY8cu3N3hY2n1gsV5iEfIo60+P5tlkasTqt9kBfpyCRH
 MbrbXgw3IVDtMK7dmVIFvbFlQWoSkBQwc1I= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33p1g9vhpp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 22 Sep 2020 11:38:21 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 22 Sep 2020 11:38:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TrrYqN+i2Wy5EtfJ9ZbKr/eBzJqNw4YaDhKfzNDV2Mz4IAu182EhlxfEIcMmmgIzOL61Zt1VkRbZPISMzU10M/kPv7WUsoyn6S7qcFxRS8QhiVvGg8XMuA2iV3MT61pjy95JzFsJSZwsXRICwXtSozKSk4T03wlA/R/hbDLIsDzvrXzx+JB3yhhVVdbLgnHO6AkhQEKpMi4nlwdIQV004PBW5z7/E+ri30Wtwh28QfFsgOJvC4HtNvUGqpX2Uy6SPa9kqw+tNTXCdu45anfekRo9NLzrIs0VLiiaTn/eQ5p06jFr9mrlKWHIpkt8TJKyWYoJ5PJFFNtJ08X2pLf20A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A8BLL8yAZGKjalkBs6Aec8RVsqCOuOUVetaOxCPLeYQ=;
 b=ScQNm41BavEM++n1Mgkv0TBmFyht//wHRwZwJfOnW1OVLeQZ2e+y/JM2tKpZmDOdp5QwTmbceQS7ZCSA2lcXeywYBmt2m5v5W72GCOnev6VuAFv9hHy6Hhkjpd5piXMT1ZsRTV0ysyem/w6eQQOqnlGWOYUfxRUxasB0n3cq8iWcG90nwEe+DOO5l3OGzfcN4VkbkRbm5IHiTprTGYyJONu8eI9l//qpYjgFQbymt/aZz4npUYu1jtaxuGuJDzUVb5p77e1RxnpFAzfm3Wk59u0Oq//m/JOpi+mF+K2ImC5uLa7Pzlgt4slJHU26QLaOijd2n/xZjBKOJ1E5LgeCdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A8BLL8yAZGKjalkBs6Aec8RVsqCOuOUVetaOxCPLeYQ=;
 b=WqsBBnNZNULU24MGEGEeAbQNFZUWxhYBwP1XeOiIdSAF7B/8g5/MKp3ECmMKj92eUBEQAkeViwqmlxf62Y81OC17WxX+0cSDG0I6l6OqCooIXphfFARk7mO/tJTF25kgF5qKbO7hOjqylH7EfKlPuqn6+egdQYwUWYLuZbmNXGY=
Authentication-Results: cloudflare.com; dkim=none (message not signed)
 header.d=none;cloudflare.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2583.namprd15.prod.outlook.com (2603:10b6:a03:156::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.19; Tue, 22 Sep
 2020 18:38:12 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb%3]) with mapi id 15.20.3391.026; Tue, 22 Sep 2020
 18:38:12 +0000
Date:   Tue, 22 Sep 2020 11:38:05 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 bpf-next 01/11] bpf: Move the PTR_TO_BTF_ID check to
 check_reg_type()
Message-ID: <20200922183805.l2fjw462hukiel4n@kafai-mbp.dhcp.thefacebook.com>
References: <20200922070409.1914988-1-kafai@fb.com>
 <20200922070415.1916194-1-kafai@fb.com>
 <CACAyw9_wEMFuymvUC0fsZVJCH0vsvbD9p=CWTZC1jV2gUiu3KA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACAyw9_wEMFuymvUC0fsZVJCH0vsvbD9p=CWTZC1jV2gUiu3KA@mail.gmail.com>
X-ClientProxiedBy: MW2PR2101CA0035.namprd21.prod.outlook.com
 (2603:10b6:302:1::48) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:7f66) by MW2PR2101CA0035.namprd21.prod.outlook.com (2603:10b6:302:1::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.7 via Frontend Transport; Tue, 22 Sep 2020 18:38:11 +0000
X-Originating-IP: [2620:10d:c090:400::5:7f66]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 51af2b4b-6690-48fc-7eab-08d85f26a8de
X-MS-TrafficTypeDiagnostic: BYAPR15MB2583:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2583589E056F24F7304F55EAD53B0@BYAPR15MB2583.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GowDOuD/R2aNNScWmsRRS5GCA0uaaTAoYAfQ7ah4c6g42uf8yl/0PIp44CoNXUSfInKpw22ZzhLra9ilNQMrgtDd7lucXscjQuuC6R4vb+H3b5NXa+fbYeGdHARI46KpocD277jWuTplX+x9FRJqOsRjiu+6JsRjGmV5UbqaO4IKmQFkU7w1R2iD1EZMsE/Cjrejx1mnUiUeX6Ys2BUvSH0z+dOt6nIrRuS+r8BaI0FJNpfMpeiHqht+0bs1D9mvCPz94yBhBkSru+sQFBzliQnv5AEWXZtYszL0npbI76t0GJh1VMlKDUsk2hgk/UBn/+NFsfc6N3ULr+hGK/y5sg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(136003)(366004)(376002)(346002)(6506007)(16526019)(2906002)(8936002)(5660300002)(1076003)(66476007)(66556008)(66946007)(55016002)(9686003)(86362001)(52116002)(83380400001)(316002)(6666004)(7696005)(478600001)(6916009)(4326008)(8676002)(54906003)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 3mwv7dLgQgZ+mk+yUZ7bwRQWyKkoh/UPS+Zf9v+jpp1Lr+X81paj0hOpuzmK2r8HadVf18r6MmqZ2aWVyPO5fuSAmaeMQVpngTCF1gK/vD7e+FA2OBveVzLIctLtWxRkyV4hk2aUyYhbFi5tv+Csnx9FzzFkhzWqMUY5JamBG5VnPLLb2zEbFywhvobJm8rPy4xYnvgvCMQYEsJXCG0gsqrS7l6Ot1c9MH1p2ATQpAkVvcZRTS50hZYrZ7dadYHiC9qXKSCkoFgpZKHtUsllBTEeQJTA6G2Cb3/2VOy8pojoUaAKrEP2T/V09Ec0i+0aHiLH6e6NGbs4VrpUk1TC1Eg269iPnXo7/teATulNBKW6UB/eEpSKSdiW/XKILUAUQhu2a8tlpFusOEGPY+h/779rO0Nd80jZeJNXZ9WFpFLSCjn4i/1kahKJY1Mfg0ufyxfOvgceVcW5OXd3ts280HZsQe4CpF3UFTxADukIfjFNwi0n9zDj78y5Jka0kDnwBaDJTHer6FzCbw0hAk7/eGehm3obsb7zk/7uO5neeXb5YAnuE52yIKHipDWkChJm7ZN2Aad5zWZlM0VdnPq7hr9tDNyLbu1/S4gXZGOXSRS0ayb/6qbIaKtylVusMO/oO5/2U4BIRyknSfbfU20GyS3JrhgsTbc85/UDxF53CN9875LZ6SVoM1DmoQ0OYF+r
X-MS-Exchange-CrossTenant-Network-Message-Id: 51af2b4b-6690-48fc-7eab-08d85f26a8de
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2020 18:38:12.1813
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qGYmSyXc/dRRDIjZ/jn2Y6G/cHgVbapAmVJG1u27Axkznnt9V7FKcGCJtZBAyHRH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2583
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-22_17:2020-09-21,2020-09-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 suspectscore=1 clxscore=1015 phishscore=0 mlxlogscore=999 adultscore=0
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009220144
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 22, 2020 at 10:56:55AM +0100, Lorenz Bauer wrote:
> On Tue, 22 Sep 2020 at 08:04, Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > check_reg_type() checks whether a reg can be used as an arg of a
> > func_proto.  For PTR_TO_BTF_ID, the check is actually not
> > completely done until the reg->btf_id is pointing to a
> > kernel struct that is acceptable by the func_proto.
> >
> > Thus, this patch moves the btf_id check into check_reg_type().
> > The compatible_reg_types[] usage is localized in check_reg_type() now.
> >
> > The "if (!btf_id) verbose(...); " is also removed since it won't happen.
> >
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
> >  kernel/bpf/verifier.c | 65 +++++++++++++++++++++++--------------------
> >  1 file changed, 35 insertions(+), 30 deletions(-)
> >
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 15ab889b0a3f..3ce61c412ea0 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -4028,20 +4028,29 @@ static const struct bpf_reg_types *compatible_reg_types[] = {
> >         [__BPF_ARG_TYPE_MAX]            = NULL,
> >  };
> >
> > -static int check_reg_type(struct bpf_verifier_env *env, u32 regno,
> > -                         const struct bpf_reg_types *compatible)
> > +static int check_reg_type(struct bpf_verifier_env *env, u32 arg,
> > +                         enum bpf_arg_type arg_type,
> > +                         const struct bpf_func_proto *fn)
Yes. I think that works as good.

An idea for the mid term, I think this map helper's arg override logic
should belong to a new map_ops and this new map_ops can return the whole
"fn" instead of overriding on an arg-by-arg base.
