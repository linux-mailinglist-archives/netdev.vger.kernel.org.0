Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6726275011
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 06:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726919AbgIWErU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 00:47:20 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57052 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726198AbgIWErU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 00:47:20 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08N4l5Wb003702;
        Tue, 22 Sep 2020 21:47:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=V5kHmvUyZgJgwyDdOLifODhpUZfJIuHePghYOL+KHlc=;
 b=Z3Zq1pNHO6FffLmMS7e9YXEyMdHjUraywvEL8kh4anM2PpVgYVXErTtw1HtXkfdOjd+x
 u/gHbeTlvSWYynZSVnP9arY59Q/BoEPAx0PxQY2Jr68/vnxbly/y83Kx/S1lBAxqwxF8
 IBAxeF4dkTFSmW/iawIu58bkH6C/H+9ZbvE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33qsp49k5t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 22 Sep 2020 21:47:04 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 22 Sep 2020 21:46:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CZtzeZwJ3ycZQGpEuzuD76KBuPIYraTRj9yuyUbJkcXFo3Az+YYDFvNutkfkkJNZ7DnMqv8vuqhb90ZKbkC3B6f75ETb7WeJuExfiuekFLYemhZNwyK14AmH+2/7adXhHlk3vtpovTFDZVHa/bG0iKq+FYKLh51CnntS0/ho9r/A7OsL6Qu1zpFqk7QUdjvOOjY8u3ozAO9cWupwGLEw2uUys1Ro11chTyM2FjNL2fRFs62P6C5btYDnKHPL7eS4tLfNbti4qjHahfgs3BActd+y+BsWMxm4hFPDDvd7OnaJ3q/ZrEow5eARcU+9QbC15q0bPjUiQlRp2JDdVzwWBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V5kHmvUyZgJgwyDdOLifODhpUZfJIuHePghYOL+KHlc=;
 b=ZUdDzUAwBiptvP5Dhfz9DqVxfJLkfBcD1vWhZpav2TK1DcLbd38DuvewIHmtcZ4MJGff4vfe2XsHdXhEW0Dmvrkvgc2UPpm3mJFxNYo2pjwm9ynrpXxAKHqVP08LkiN0GbT1SFts0wkvcUHGJyra95e9jBpDqjWMJfMfdrWiTDr8Ms+M0UkerwL6ylEml+K3vKJaYcRRnTQ5VFTLA89CaqJMzabRgia3Py9qGcs9uEeXGAl6pYMHZNzhrm0YGuYvkB45Lcw2CrTXRqNylRrttmOl+ZtIZmh7YbbjwlKAnC5PNQ0meM77q7wMjpB8PlAgTQiamo55N7uZ4agWoVQkNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V5kHmvUyZgJgwyDdOLifODhpUZfJIuHePghYOL+KHlc=;
 b=Jpu0tYahchK4DO04DJgNdzA1wc+U+aXT33Mt01TsZcdv6J4DR7QIdcYmQqVgwXmI8KNN8gsZqZvUfzUN2gm60Q+xPedznc7p/BilvGhqjiSqSA6RQoTQnuJ/P0Kb51ITwj+yDSbWxzU8mXB8poNNPOCqhR5Na01Ox1AWcn1K2bY=
Authentication-Results: cloudflare.com; dkim=none (message not signed)
 header.d=none;cloudflare.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2198.namprd15.prod.outlook.com (2603:10b6:a02:8d::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Wed, 23 Sep
 2020 04:46:15 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb%3]) with mapi id 15.20.3391.026; Wed, 23 Sep 2020
 04:46:14 +0000
Date:   Tue, 22 Sep 2020 21:45:59 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 bpf-next 01/11] bpf: Move the PTR_TO_BTF_ID check to
 check_reg_type()
Message-ID: <20200923044559.ag7ifrqwhd6o27xr@kafai-mbp.dhcp.thefacebook.com>
References: <20200922070409.1914988-1-kafai@fb.com>
 <20200922070415.1916194-1-kafai@fb.com>
 <CACAyw9_wEMFuymvUC0fsZVJCH0vsvbD9p=CWTZC1jV2gUiu3KA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACAyw9_wEMFuymvUC0fsZVJCH0vsvbD9p=CWTZC1jV2gUiu3KA@mail.gmail.com>
X-ClientProxiedBy: MWHPR1401CA0016.namprd14.prod.outlook.com
 (2603:10b6:301:4b::26) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:95f1) by MWHPR1401CA0016.namprd14.prod.outlook.com (2603:10b6:301:4b::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14 via Frontend Transport; Wed, 23 Sep 2020 04:46:13 +0000
X-Originating-IP: [2620:10d:c090:400::5:95f1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a3deeb67-ebca-4daf-4808-08d85f7b9a2d
X-MS-TrafficTypeDiagnostic: BYAPR15MB2198:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB21986B2BD58B42207FFBF0B6D5380@BYAPR15MB2198.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eFPjtNEs/pNw0Am/sLKX2Fbr4Em5+VkLm+mRltMzLsLIvGanARjGVGF4ZJMQh1iUSc06Nzfs29/yjpOc0XGLB5S9Mv4N8hfqtG9hGjGGVcw7nSDvofRIFWRlTocKDrEQOc+yEXnA1104MspK7BYPmxTl03L+Bz3/58ymlD6yPxhNy1dxyBdPrCNBtOSS+BzpagMxq2aprU/N6cUixf1IQkzYFAIpAFpWI1P1xCcpeUnN+4BERooMcbUpE0/YlcCbXzelyZwyX9MaYuSw2HF/bTJ8VG9qGeKGMAy1jvXU3eamKHauZcd8VWU2GQ7MxE8tnQLHg9ivNwQEDm5rBcO0RCbv1H6UZ4j/My+Icj0MrvBPzFlRi8x0HmWwMd8JU7ts
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(366004)(376002)(39860400002)(136003)(52116002)(2906002)(6916009)(4326008)(86362001)(66556008)(55016002)(1076003)(478600001)(8676002)(9686003)(6666004)(8936002)(66476007)(54906003)(83380400001)(7696005)(16526019)(186003)(66946007)(6506007)(316002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 86QTXcyFhZb5FHW3/KbUHPNHltfN7zDJqMX2YCBjPHB/bMIEifj7cfdp4Buw2OpZfUXzIcfMmXJLXxXG+Qz3QUdl1YdyNQAPgkFPqimdcwCVm28Bup3vDfo8KIHFrOPGVbkHFyxTmiJZVW/EaynUNCoyqn4bK7q3eNk6FILjEtLSHkvPGAtsqQ6BG85RZUq/UEfU6DGmHCZu/xjJdPQekBSB5azyIdscxJniA4Zmlb46QkF+NYCoT+CPe02LEED3tWeMrw2Q2sCiHjwybZuNM3Ry3347T1lzcNd2l4bW4UajWz6CeIx1/BVLvC6PCS0VMYva7wG02kjfot/LfA4MrBY+YmzvgYclRrIZMFUhyP3Lzzhnq8zsPUU+lvZJJjx78oJGuHbMGarO3ZA9xfIUWuj9fSC43ajni/fEbofEFV6I39AuP64nWoet5m89ULzS9bz1p6UtocR1MlSlJYJ151aeqgJ50ziGZL1g8vbauw5DaAuBXvhiqzDrsDiQEh/AzhB56XyfcLt5Os90D3w5QTUeHEqR32myo9QK8T1TsWcyMg2J/yce3+YMdI14y2UYTFTRX5OCzQ2k8wVm7CJyq119YdElF9+dO0xZtCWp+Frt3icHg+/j4SaaVFfftiUWNEWvUX+Z2nnVKNR80R6nnjBkNq2g3yTlY/CDEHA4e4Q=
X-MS-Exchange-CrossTenant-Network-Message-Id: a3deeb67-ebca-4daf-4808-08d85f7b9a2d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2020 04:46:14.8058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hpfef5yYEGM6VYcY5B6I+ekw0wgb1MiCiOx09UIhdDXPrORBLb5fbmTuV7oKtbCs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2198
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-23_03:2020-09-21,2020-09-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 priorityscore=1501 lowpriorityscore=0 phishscore=0 mlxscore=0 adultscore=0
 impostorscore=0 clxscore=1015 malwarescore=0 bulkscore=0 spamscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230035
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
> 
> How about (env, regno, arg_type, expected_btf_id) instead? Otherwise
Last reply cut off in the wrong line.  I will make this change in v4.
