Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 722051BD4C7
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 08:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgD2Gmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 02:42:37 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47504 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726158AbgD2Gmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 02:42:36 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 03T6gLj2022023;
        Tue, 28 Apr 2020 23:42:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=ein3AtokJ7ALLgFmS5SNqRlCIXzcpLEm69edW/OBsd8=;
 b=ejOZpkPhreAvQwIJk+UMDUAvk409I1Dxxl1Fu2tswtaXYMf62fejlRwPTWpANAi4eVwX
 3xJIU8tFk7h435JUVqB4TRl7TNaV5gAkVnEKvdsR8mpBu0nJa+UHko4pSuhooiNgwkt8
 i0uhsrCktmjMyinqKmZEyipLumXVuuKxd5Y= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 30mgvnsugv-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 28 Apr 2020 23:42:22 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 28 Apr 2020 23:41:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hg0zFKbkvtrZypjTwaLyXEkEErsU4CNUCE4qyRG03UTbD71B3D687IIrrCbR26TjUg4wFC5uGIZM35LYYZTMjJDXfSUZWmE2dw9ZItGbhz9p7BVg5K4m/BypKGO8E+3KSQ+rh/PdyziF+Ai2ysCfbUTHuE6BiDUbIcffhM103xjrNbEJ18fXl5v7zyf387YbXvhYXnktQZ4iK+pmbJUNvsYO8sjbC/nZmkJtpIviWnN1XFym+aKKmIe/W60RE0yrGcJDu5ZqWk5Ns7+xs4s5g60PfdXri9bYFpwRXT5esBcqRET+0K7xRSDEyrG622OrJRlKgvwXJpw68bOHAsySlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ein3AtokJ7ALLgFmS5SNqRlCIXzcpLEm69edW/OBsd8=;
 b=V5hJzocezj8h2G4t/DfOsYaUu5IXQ80VgC1yg2ftpyb99z6suPw5GBQ24hXwzRoxnBr9FYvU/ATUxXbyDXkY/uDz2AGBoltG3IfIrhEjZn88R3BzrXgrA/csRcgHkli64dp4pNASweudh92Zul9tIBkvTPXTSizDOt2O3JBkQzTxw1Heat++PGQSAdYo6d3PphVDM2B9JlymC5vAFJP8nksG52EnPi6Ehrgdzoke39+Il17IxD2An7WH8hGzSe6i6/BSkPqVKzVvyoC23AoCgBRwD5/k0Vkwl+E9dLXnWyDRvjt7itoGf5ohHp/tkxqMbUi6GlThpP2+s/uECDCAsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ein3AtokJ7ALLgFmS5SNqRlCIXzcpLEm69edW/OBsd8=;
 b=leZnKOdT3exHC/FNJkJeCSqvb93lo+YfmzFJmqueC1r+Boujm1Vi4spIxGj3G/okNDBftTiJkPArHJBvOLp1GK8APBcZVeW0UyvQuowyhJKP4T0Q57/JCUGUiIj5ETLY2lcPPfALQyJueA2y625viTfTs/30rHNKuK3gVuvco1w=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from MW3PR15MB4044.namprd15.prod.outlook.com (2603:10b6:303:4b::24)
 by MW3PR15MB3930.namprd15.prod.outlook.com (2603:10b6:303:46::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Wed, 29 Apr
 2020 06:41:47 +0000
Received: from MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0]) by MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0%5]) with mapi id 15.20.2937.026; Wed, 29 Apr 2020
 06:41:47 +0000
Date:   Tue, 28 Apr 2020 23:41:44 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next v1 06/19] bpf: support bpf tracing/iter programs
 for BPF_LINK_UPDATE
Message-ID: <20200429064144.sqtpev55lqflw74a@kafai-mbp>
References: <20200427201235.2994549-1-yhs@fb.com>
 <20200427201241.2995075-1-yhs@fb.com>
 <20200429013239.apxevcpdc3kpqlrq@kafai-mbp>
 <f63cd9f5-a39e-1fc8-bba3-53ebffef9cc5@fb.com>
 <20200429055838.feupa5leawbduciy@kafai-mbp>
 <CAEf4BzabE6FHDMqHRMtf20O1FEv-4x_PiRHdavU7uN_ox_3=rA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzabE6FHDMqHRMtf20O1FEv-4x_PiRHdavU7uN_ox_3=rA@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: MWHPR22CA0069.namprd22.prod.outlook.com
 (2603:10b6:300:12a::31) To MW3PR15MB4044.namprd15.prod.outlook.com
 (2603:10b6:303:4b::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:1f77) by MWHPR22CA0069.namprd22.prod.outlook.com (2603:10b6:300:12a::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Wed, 29 Apr 2020 06:41:46 +0000
X-Originating-IP: [2620:10d:c090:400::5:1f77]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c84ebcfc-ee04-425e-1ecf-08d7ec08635a
X-MS-TrafficTypeDiagnostic: MW3PR15MB3930:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB393057538A42A0D1F30D9A96D5AD0@MW3PR15MB3930.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 03883BD916
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB4044.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(396003)(136003)(39860400002)(376002)(346002)(186003)(16526019)(6496006)(52116002)(55016002)(66556008)(478600001)(8936002)(1076003)(66946007)(8676002)(66476007)(5660300002)(2906002)(86362001)(9686003)(4326008)(6916009)(54906003)(316002)(53546011)(33716001);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v7aHCGyKml/Q6IaL3WkWIzf0CclFQDxnky7KOCDLS2For6QSqhxf2mWID5LlAEJwHK1muOKyJWTbA7Ur8pXQjdsN5k1WF5cKWct4vkjVQilOT0N1bNydyF6ib6J9Ss7MJSkg74TAKvwTqTtdyLnooP58V13jdzn2RM17t8VgLmMFnxcAoLdqRyv5CwINVdxZm0gPswqEVrrMvfDPMDR1q72q3NG0j0i1KbmA9zCnqQnqmMNfZsxt3cKjcN4r6zIiGo3fnkcGyQR+84D5Wax775GppetKJfjXmBig/UV4Eg+m2KPsP/rkFPWF+sMDzSiOoB8jfZm3WoN/wWYc+7ApJYmvbNXZ80oxIOnYs/OG7ebIU3VpyMomKOwHd9r1VCi1oQKhI+KfYXINoDTdfqR2F4VryB6ldj8ho5He8jhewCiL65EkCKduStoh1Rt6K3PI
X-MS-Exchange-AntiSpam-MessageData: YBhSVO9KxUVKY2gzuc+kau70u1Av9TzfB4GJrZiFxXJXw4B1uIMCzd6KtQQTw1dtvhDgeKWcl/e3HNWpYZ8oIfpXmfw1tJ5Rfs5mvtSwuj6SbHmqxBcHBQq4+IV2B46Q4CZ0rbjDopNdY72mnJZ9kH6Wh8A8jqpEQlmMNdqF/AknieMMJnex8XHuuxlWu0SPffqID4cbMaRY16ApDwEXfQH7lEqsBsQiTVEpPZjrjV1sP5j/EBGYEKgYSqB8ugRKWQWhboSLddo8puPzDx4nskVDNdBKkAxyUXDhX4R8J11tF4V7BqN+kPio3VMb8R+ZnbHM8G1rzsdOQYaTr325WqrrToyfDRE76lzgmk5vjCZjcEtoikldeO9wDfnZUd+0iiN1p8YY9q6UEAOTBOTeK5ITrNvnQHUPb6WckWrlo98QykLccpOtNQs4JOWsm6bjsa600NdD8/uT0RA6Sy73//GSVTKIrv0unMr/EeT16woLhsyHVCf/+1uCBViApu7h7X83tIQwclc/gROX105Cv/g3f2Lge57dNYESyM4mhN+8r5gFq2RPjC78CcHTEyaAY3KsJLuNf/InuAf2SJn1vlTTjePIcbjjfUTK4CALymaIgCtiXZqSKIJM5lNXZG8TkoO9AkxW35vIy3ki646nwfK8+3xSuecQvuZEw5YhOhjm2qTyuXklB60xpoEJBbjkm0+vQ95opW1lxy2Zr/qif6jQtTVn57Psd9u3qehQn93FpcGEikSH8YBil8O5ccIKXKJRevvKRMnt9d0az8lw0vFOTkVWu5xIlqv2KTN1d8zwlZdv2asoBpUt8ptEE4YoUCoUWuwu4RkfyMuehXQfRA==
X-MS-Exchange-CrossTenant-Network-Message-Id: c84ebcfc-ee04-425e-1ecf-08d7ec08635a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2020 06:41:46.8790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KSh/qoqVpSvCFlJBOeSo1ZCIKkDdRwoX6uVvWEK06e2VCmIt7z6d/LwmkcRIs2h7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3930
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_02:2020-04-28,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 bulkscore=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 priorityscore=1501 impostorscore=0 mlxlogscore=999 clxscore=1015
 suspectscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004290054
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 11:32:15PM -0700, Andrii Nakryiko wrote:
> On Tue, Apr 28, 2020 at 10:59 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Tue, Apr 28, 2020 at 10:04:54PM -0700, Yonghong Song wrote:
> > >
> > >
> > > On 4/28/20 6:32 PM, Martin KaFai Lau wrote:
> > > > On Mon, Apr 27, 2020 at 01:12:41PM -0700, Yonghong Song wrote:
> > > > > Added BPF_LINK_UPDATE support for tracing/iter programs.
> > > > > This way, a file based bpf iterator, which holds a reference
> > > > > to the link, can have its bpf program updated without
> > > > > creating new files.
> > > > >
> >
> > [ ... ]
> >
> > > > > --- a/kernel/bpf/bpf_iter.c
> > > > > +++ b/kernel/bpf/bpf_iter.c
> >
> > [ ... ]
> >
> > > > > @@ -121,3 +125,28 @@ int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
> > > > >                   kfree(link);
> > > > >           return err;
> > > > >   }
> > > > > +
> > > > > +int bpf_iter_link_replace(struct bpf_link *link, struct bpf_prog *old_prog,
> > > > > +                   struct bpf_prog *new_prog)
> > > > > +{
> > > > > + int ret = 0;
> > > > > +
> > > > > + mutex_lock(&bpf_iter_mutex);
> > > > > + if (old_prog && link->prog != old_prog) {
> > hmm....
> >
> > If I read this function correctly,
> > old_prog could be NULL here and it is only needed during BPF_F_REPLACE
> > to ensure it is replacing a particular old_prog, no?
> 
> Yes, do you see any problem with the above logic?
Not at all.  I just want to point out that when old_prog is NULL,
the link_update() would not even call bpf_prog_put(old_prog).

> 
> >
> >
> > > > > +         ret = -EPERM;
> > > > > +         goto out_unlock;
> > > > > + }
> > > > > +
> > > > > + if (link->prog->type != new_prog->type ||
> > > > > +     link->prog->expected_attach_type != new_prog->expected_attach_type ||
> > > > > +     strcmp(link->prog->aux->attach_func_name, new_prog->aux->attach_func_name)) {
> > > > Can attach_btf_id be compared instead of strcmp()?
> > >
> > > Yes, we can do it.
> > >
> > > >
> > > > > +         ret = -EINVAL;
> > > > > +         goto out_unlock;
> > > > > + }
> > > > > +
> > > > > + link->prog = new_prog;
> > > > Does the old link->prog need a bpf_prog_put()?
> > >
> > > The old_prog is replaced in caller link_update (syscall.c):
> >
> > > static int link_update(union bpf_attr *attr)
> > > {
> > >         struct bpf_prog *old_prog = NULL, *new_prog;
> > >         struct bpf_link *link;
> > >         u32 flags;
> > >         int ret;
> > > ...
> > >         if (link->ops == &bpf_iter_link_lops) {
> > >                 ret = bpf_iter_link_replace(link, old_prog, new_prog);
> > >                 goto out_put_progs;
> > >         }
> > >         ret = -EINVAL;
> > >
> > > out_put_progs:
> > >         if (old_prog)
> > >                 bpf_prog_put(old_prog);
> > The old_prog in link_update() took a separate refcnt from bpf_prog_get().
> > I don't see how it is related to the existing refcnt held in the link->prog.
> >
> > or I am missing something in BPF_F_REPLACE?
> 
> Martin is right, bpf_iter_link_replace() needs to drop its own refcnt
> on old_prog, in addition to what generic link_update logic does here,
> because bpf_link_iter bumped old_prog's refcnt when it was created or
> updated last time.
