Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFE0A2E9F3D
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 22:02:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbhADVCM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 16:02:12 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59704 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726168AbhADVCK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 16:02:10 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 104KqAAS014233;
        Mon, 4 Jan 2021 13:01:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=DueEEIJ+xMYpNfsYIZtHQyqAI0LjnOG4BwaxZArr7zc=;
 b=dsR2ShybDhUV8OP9Xu3JRNMm5RpVRhTm4ZfrATUs2tVMCIzrRD4urNZtqxfvi6lL9LNX
 YJYALWNjW4tnygXEtvZGdSa1LOd57jW294M3+hLyNYlPhEWop1fzzMQ/LCvs+/uBgS0n
 lEyhVE3L++mQrZUaQhmTEbw+OK5VCembkAU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 35tncu88j1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 04 Jan 2021 13:01:13 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 4 Jan 2021 13:01:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SKN/ItTSZS3aenoIepgivKBPmQRJCKNUZy+pYcCcPHP3sOaHhHiivd07o4hjIxBwWKXWNttOJ4xdCy2CCKQFQRdYeMfn6zzavPlJTJCeNrrNTGnA/8GBX8GlVX83P2TwuQFfToEVXWFBuVAAxJMc7/hr/qL88PNjW3fENmrf7+o9v//EH670iJGruxoOjtAhtfuegHzfbXUBQkki/AiqVroUJEXPwgRmy32Px7L15ico8Hii/IHxNLMndEn61aAoN1JJsOqPG5FYJWAc41bkCHniPHFRflpdkGCHKxwvI/os+Vif6qMflZDq8BsQQAJoQsoG2dxK+xhihhRYWAxXrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DueEEIJ+xMYpNfsYIZtHQyqAI0LjnOG4BwaxZArr7zc=;
 b=RDPI/e7vwWpcXx/t6beXcBrcRccUnSJ+EYhniR8wa/Sput41yxDLc640UVjLqpvPTB/iE56JwZwmRfRucroVqiVo9Rbl5Pcc+2Geu5QFROW3SbJQO5BNxg5DxYSReerHgt2JRqTXgGzOIObDwAILJBSc2vO86aw/ZsC2XGyC/0VOxRRpIOEUoOAAx724FKaFZc6Pz+DGA+xkbHNTnVdMc5NDc2DUvM22JjFK/NmLeOxqgS3dd5SiG/K8xBPDIypJh8h/d2Awxjta7cg1197QvaVbliU+2vswl5hvgv9qNWjEocvGt2Sb8Js51eAdYStPwtrn4NEpIEAdN5jLQ1O5Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DueEEIJ+xMYpNfsYIZtHQyqAI0LjnOG4BwaxZArr7zc=;
 b=DZUQKbxiGL831Fx0ekcCztAfeYzmXVKgIHRUpTXJ9oL1VNmCN+Gy8/xSiAfk3kkoyBwihT2ZgkaENuuZQMVxMiPW7LAbAJUI0LxSQuPL7DxCbUQkcMUpFnZ4oSvZa7rhExj7vxwbKC5GbQMRfL5xe2g5QBChnE5xw8TU4ztLKn0=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2840.namprd15.prod.outlook.com (2603:10b6:a03:b2::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.20; Mon, 4 Jan
 2021 21:01:09 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::217e:885b:1cef:e1f7]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::217e:885b:1cef:e1f7%7]) with mapi id 15.20.3721.024; Mon, 4 Jan 2021
 21:01:09 +0000
Date:   Mon, 4 Jan 2021 13:01:03 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     <sdf@google.com>
CC:     Song Liu <song@kernel.org>, Networking <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next 1/2] bpf: try to avoid kzalloc in
 cgroup/{s,g}etsockopt
Message-ID: <20210104210103.v6zdxxjxa4xfpywv@kafai-mbp>
References: <20201217172324.2121488-1-sdf@google.com>
 <20201217172324.2121488-2-sdf@google.com>
 <CAPhsuW52eTurJ4pPAgZtv0giw2C+7r6aMacZXx8XkwUxBGARAQ@mail.gmail.com>
 <20201231064728.x7vywfzxxn3sqq7e@kafai-mbp.dhcp.thefacebook.com>
 <X+4xFUuYHUIufeJ1@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X+4xFUuYHUIufeJ1@google.com>
X-Originating-IP: [2620:10d:c090:400::5:eac]
X-ClientProxiedBy: SJ0PR13CA0082.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::27) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:eac) by SJ0PR13CA0082.namprd13.prod.outlook.com (2603:10b6:a03:2c4::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.4 via Frontend Transport; Mon, 4 Jan 2021 21:01:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c05f8d0b-aeb4-4680-4959-08d8b0f3dc87
X-MS-TrafficTypeDiagnostic: BYAPR15MB2840:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2840C8B7AF10119F3D5E88E4D5D20@BYAPR15MB2840.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wBoDRQ8XMIQbsoyiWybG9b4XTRTEzjuVezYRD0uanhkbO5g4b+QWCi9oVogaEMoHEUwqpy8I9jzLNh4Em7fzK/IdYM83iCObKNpBZ4E4OoxYsccOc5IpupwHvBa1u7p6sc2mKjNYgxB5u0ovWk1LyQIgN+IhhaQbubKOsXTFdDFE5k1veTFun/oubnQxGwgKVvHpP6gNQf0d6d76PyNfChbF1HiHQHyif3vmC+7Dn3RSJrv+Veket+i2I+a/V3v19wHwh/TjGB1Qt02wZXjsEOkflCCuuflDGWkUhgsJm01/W8pvu7LykTox02FnkTL5qPX3SgfH3iOmqSYWWU9uoEL41gXki7eZXEl49jCJ/1vqdsaPHBCdAvSWNg5yqZJOLMD1VAzsG5yo9/V6KA4xXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(396003)(366004)(346002)(39860400002)(2906002)(8936002)(66556008)(66946007)(9686003)(53546011)(55016002)(8676002)(52116002)(86362001)(6916009)(6496006)(316002)(54906003)(478600001)(66476007)(6666004)(5660300002)(1076003)(16526019)(186003)(33716001)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?yezmPxqZHF98KHFZSdENBdRzyf0HpGk7On7rD+kttVt5Nxp7hn+4wH7JZ6jW?=
 =?us-ascii?Q?16UmoOOGyqupaREqW1Y8mZkDAzLo03Qd20NFdvvJv9xN4CA7GZlnnzLa3/c1?=
 =?us-ascii?Q?QCxmRkdKzEnsl8o9SfamUC+8PcTQ4lzu8mcswY+TFqt4OkN2ocD10WPBTQka?=
 =?us-ascii?Q?26VhGme9D7IgjwbH3lQAkUA2zPK0TZw6JmCgvW9gV+WBkeoPZEp8F4yYIwe/?=
 =?us-ascii?Q?UT61oROZXs6MxZGfTEbTtSamp6yhI61fIkuGzWLgm8Efu6WBjUKYFkl+OWrL?=
 =?us-ascii?Q?/yun6C2RgiFOCJnTmgvLY0/Gan2xmQV+F8EK3lLwg2PoYsBp3Zq6uUARiSzP?=
 =?us-ascii?Q?H3Y988+OX5Fd2DB5vU8Jt4kg2qEmiBOa+IQFi4WVqtkW67TUAs9StNJ2Nd5x?=
 =?us-ascii?Q?GcDOUqMBREU74e/NgeAeB+nYaPGMrKDtJjwgedSS2K7Zxwy4MRYGYuap3xVb?=
 =?us-ascii?Q?z8ayJ8oLS/j/2VKknU7A/ckN8AAS66ymiHYN6PBsF9mbWSjBizevUtaBA0HG?=
 =?us-ascii?Q?4cqJUhV8njxjm+XbTXz15uoPUFDZJE8uhtvudWdehrVG406wNkp/7R43o/Dw?=
 =?us-ascii?Q?Iy2DO6x+vv3lXGlY+rVJlvgsS5Jo7R4cIjLaxyo3NrXNWOOdv1LCEMIfC5mZ?=
 =?us-ascii?Q?Pbdp8kYYFC4L75MuJS5CZ7SBTYPUTa+LqDvNkRbU/iZGHkTioI10Cr7jB7h3?=
 =?us-ascii?Q?uH9PjowOCnJIwzo+R7DFVZohxfncly3mvY5TQSHEx3PgQPVrAbxaYE+R2ybW?=
 =?us-ascii?Q?K1BENT+n7DyclA8baqr8ZzSemGlGkkBl2YABp3PLVpyVVoYtYWNlFpmk2UDY?=
 =?us-ascii?Q?HBz/nD/+QVFirhcvrh+fImlvNKYnh/0TxtKXAHk7Vj18gTK0/3eMISqLkF8y?=
 =?us-ascii?Q?8ZPVl4x4UVnfC7q+xqxKQ1uRryOyv/bdPaGkMW38XDvWLf+ZHqXOH3634wiW?=
 =?us-ascii?Q?yopfBNc+Pc7nnE2omG4OAhT33mdKxZd3hZHoINROkluWiLwppQ0leSr+/IX/?=
 =?us-ascii?Q?gFS/ywHw+0wcjnCRW07xIpGamw=3D=3D?=
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2021 21:01:09.5570
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: c05f8d0b-aeb4-4680-4959-08d8b0f3dc87
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XkeeiCYO4nGaWn2T8O9SWOUtdwkHLvvm5HeEnbqH7a8Dxk86rwKYxt2r/EJxFOqL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2840
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-04_12:2021-01-04,2021-01-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 priorityscore=1501 clxscore=1015
 lowpriorityscore=0 spamscore=0 malwarescore=0 bulkscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101040128
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 31, 2020 at 12:14:13PM -0800, sdf@google.com wrote:
> On 12/30, Martin KaFai Lau wrote:
> > On Mon, Dec 21, 2020 at 02:22:41PM -0800, Song Liu wrote:
> > > On Thu, Dec 17, 2020 at 9:24 AM Stanislav Fomichev <sdf@google.com>
> > wrote:
> > > >
> > > > When we attach a bpf program to cgroup/getsockopt any other
> > getsockopt()
> > > > syscall starts incurring kzalloc/kfree cost. While, in general, it's
> > > > not an issue, sometimes it is, like in the case of
> > TCP_ZEROCOPY_RECEIVE.
> > > > TCP_ZEROCOPY_RECEIVE (ab)uses getsockopt system call to implement
> > > > fastpath for incoming TCP, we don't want to have extra allocations in
> > > > there.
> > > >
> > > > Let add a small buffer on the stack and use it for small (majority)
> > > > {s,g}etsockopt values. I've started with 128 bytes to cover
> > > > the options we care about (TCP_ZEROCOPY_RECEIVE which is 32 bytes
> > > > currently, with some planned extension to 64 + some headroom
> > > > for the future).
> > >
> > > I don't really know the rule of thumb, but 128 bytes on stack feels
> > too big to
> > > me. I would like to hear others' opinions on this. Can we solve the
> > problem
> > > with some other mechanisms, e.g. a mempool?
> > It seems the do_tcp_getsockopt() is also having "struct
> > tcp_zerocopy_receive"
> > in the stack.  I think the buf here is also mimicking
> > "struct tcp_zerocopy_receive", so should not cause any
> > new problem.
> Good point!
> 
> > However, "struct tcp_zerocopy_receive" is only 40 bytes now.  I think it
> > is better to have a smaller buf for now and increase it later when the
> > the future needs in "struct tcp_zerocopy_receive" is also upstreamed.
> I can lower it to 64. Or even 40?
I think either is fine.  Both will need another cacheline on bpf_sockopt_kern.
128 is a bit too much without a clear understanding on what "some headroom
for the future" means.
