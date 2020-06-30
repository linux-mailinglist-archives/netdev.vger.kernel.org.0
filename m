Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC143210034
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 00:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbgF3Wtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 18:49:50 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:12458 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726135AbgF3Wtt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 18:49:49 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 05UMjp59015894;
        Tue, 30 Jun 2020 15:48:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=/+ubhidReBpA5ipJdTmh4UWTXHrzPsafursS/tqj8hw=;
 b=NvaPSIKZFrAhFSgbwQ9UgJYoapkg135ccyst0FAMEpTYYSV2NlOIk5/7yZrnhaQJSX+E
 xM8itj4fx5rlSV4XpwjMFxMTJZiDZ9X0KZ5SuJx9kHnS6X2jzLPPYId3mUVDTliK1s3N
 vSiO4DzYhsblOfx5K2roDjN2rfvPzPaz48k= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 320anf1426-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 30 Jun 2020 15:48:34 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 30 Jun 2020 15:48:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DSUaQYpImB5VlSfqXB1NDQmU7yWN6jhh5G1wQWqopB4Gpfdkbs8NgixYs3Em+rl/k8ts+2twxD3jPc6Y1b1axV+a7Ah3znymfp64TY53OUE1pjxtyaKFLIphM+dTRRVoUp2uSEBJe/r53n486E32jyD4WQeSrrnjPN/K+q1oafglLuSvh4hRfS+wONJNaUdv4iGfR5OBPtKKoI114ZBYKLWoNucbo4H30etIoycB8+wNHPMiqVC9BrD6Q9L2hGmQ5U13bUoNI9Bcw0holArMxuVg9iSkUK7G6wbxsbpo1b+K7Ja11GqkrGWnZLa2jsPNyqd8M/+IYgbk723sHJ5sKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/+ubhidReBpA5ipJdTmh4UWTXHrzPsafursS/tqj8hw=;
 b=SfAAdauAOwq7adi4KhAg3zgjqzpKIc1F5vy9VfcsQltcpMqg+g6+GmuFLfSt4/RhmNvigiY16mLRTgc8Qf+27KmO4sInU411B+QweaTnWcBMMEsL6AKMzO851ZqJAjJh95DPD+qvpClNFCoRNL+S2dIXstjcI6fVoJGGpQxVHiaYknsHtJNWZGBF4eeD3ANaqGaCsKm0g6NSMF811K2YRYXh1uRH2DqxlI4Zva2tZQKiMb0BPWBkP/Y21FK8K1ey4nVVjZFXvKA8/TTFGX3UCIaUUAH4yRw/1sJI3VYhv5GQ7/8E5YRuOGN584iQOvGwvT5Lpy5RiRMOe/9142m96g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/+ubhidReBpA5ipJdTmh4UWTXHrzPsafursS/tqj8hw=;
 b=Ktthvc8maYwNIHPPOCMi5uiG3sJK3po2I9rlWT6NqiL1x5zpQ6MQsGzKEEJdLec1HfxnI8BaE6xLNsPaS84ovukp1uLO6JeNOdARj5nxvvpulMY2lE0oD+IEAg0vTuq5JKJoSrkb4eQwkdi9NOWmQJWA9CiC6TeEqyM3DqrcVyE=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB3288.namprd15.prod.outlook.com (2603:10b6:a03:108::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Tue, 30 Jun
 2020 22:48:32 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::48e3:c159:703d:a2f1]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::48e3:c159:703d:a2f1%5]) with mapi id 15.20.3131.027; Tue, 30 Jun 2020
 22:48:32 +0000
Date:   Tue, 30 Jun 2020 15:48:29 -0700
From:   Roman Gushchin <guro@fb.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     Cameron Berkenpas <cam@neo-zeon.de>, Zefan Li <lizefan@huawei.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Peter Geis <pgwipeout@gmail.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        =?iso-8859-1?Q?Dani=EBl?= Sonck <dsonck92@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [Patch net] cgroup: fix cgroup_sk_alloc() for sk_clone_lock()
Message-ID: <20200630224829.GC37586@carbon.dhcp.thefacebook.com>
References: <4f17229e-1843-5bfc-ea2f-67ebaa9056da@huawei.com>
 <CAM_iQpVKqFi00ohqPARxaDw2UN1m6CtjqsmBAP-pcK0GT2p_fQ@mail.gmail.com>
 <459be87d-0272-9ea9-839a-823b01e354b6@huawei.com>
 <35480172-c77e-fb67-7559-04576f375ea6@huawei.com>
 <CAM_iQpXpZd6ZaQyQifWOHSnqgAgdu1qP+fF_Na7rQ_H1vQ6eig@mail.gmail.com>
 <20200623222137.GA358561@carbon.lan>
 <b3a5298d-3c4e-ba51-7045-9643c3986054@neo-zeon.de>
 <CAM_iQpU1ji2x9Pgb6Xs7Kqoh3mmFRN3R9GKf5QoVUv82mZb8hg@mail.gmail.com>
 <20200627234127.GA36944@carbon.DHCP.thefacebook.com>
 <CAM_iQpWk4x7U_ci1WTf6BG=E3yYETBUk0yxMNSz6GuWFXfhhJw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpWk4x7U_ci1WTf6BG=E3yYETBUk0yxMNSz6GuWFXfhhJw@mail.gmail.com>
X-ClientProxiedBy: BY5PR04CA0005.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::15) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:400::5:c1f6) by BY5PR04CA0005.namprd04.prod.outlook.com (2603:10b6:a03:1d0::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.21 via Frontend Transport; Tue, 30 Jun 2020 22:48:32 +0000
X-Originating-IP: [2620:10d:c090:400::5:c1f6]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd17c814-fbef-4595-a1dc-08d81d47b725
X-MS-TrafficTypeDiagnostic: BYAPR15MB3288:
X-Microsoft-Antispam-PRVS: <BYAPR15MB3288E045BC115413AA163D07BE6F0@BYAPR15MB3288.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0450A714CB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XnfkVvGkwqGb8mswgN3mjPVuGSnG3UUXxO10T0fzYEhxrmFeINoOTjCIixCqt7NPkyf2ExhZKzY+f/9foJx/yJyEn6/Y/0rnRBTryDn8vLerD5OLVy4eQndgjPqBoGE4Hze7IxggoM+holyjvYgyWXr8J0iSZKJ7cY+v2i+FKbOePQ/6ZNuK9Sl20T5zzzaDt0+ljZZmG2SX6RLzcGZJNStUkXokbR8RAN1XoFSlEi1ic9rJNjBywZV4jqMS6ZALqHL8DtVa0B/oFpsk/2THwz6XNMZu9jjmQG4fJHJsjt0MGGlx8/M9q53ajcpgOTbUQKgyMCvPBcJGtq3WhiQJxA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(366004)(346002)(136003)(376002)(39860400002)(1076003)(8676002)(83380400001)(33656002)(66556008)(66476007)(66946007)(6916009)(6666004)(8936002)(2906002)(54906003)(86362001)(5660300002)(478600001)(4326008)(6506007)(55016002)(7696005)(186003)(53546011)(16526019)(52116002)(9686003)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: zeUOHV5YAuRQDPdsc/5WCmbT/JsE+GLe6gU0G8Fo2AVBXW0CNitCCLfy/1NvQn554iBvBsXf7IY4ClcgD+ngKt7o99hjzU+R+JpZmQZuD0FBsGzjO2sB9rpSgcgwmrLI+zUS2jJVzjfcQq2h8FSb5f+RXE5nDDmAlE7XHpcNi3TaGY3yDeWur0wStfDG7QwkdjpRAaV62dYSY7CPfz9QMTZMFfNcZurO3ftwF4xxzuP6q1tFdhcwQAYpSMH3U2fh2IFO+6NcAWokmhO2DyJI6WsFFr3GXM/Gm6JOJ03N5469OEYn12FyDYqtmo0lCTdGHo1h0gYL/ekw7pbJAjtyaGUy3QRBJvVq7gq48h3x3M6JMeQ5AcLraZ7FdSThJtz230WR8WSXXhn0V2WrChLbF+j8D5e7N/kiohTvlUM4NZ4PQgEKzjmIRqn2pgP7wnvGEXK2XziOsDGsf+AoKcDRVk/CWglhPurtdcSgbiaJgWNpiyFFjXkbECUy0OKa+xKtyglgp+J/VRaVrCoBRb0Z5Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: fd17c814-fbef-4595-a1dc-08d81d47b725
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2020 22:48:32.7684
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cnmzGp8NLGi7OUzDv5hTtQNpTOkO640xgn/2VsjQ1LKTOJN0WF+kihpXi+ZLFpoL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3288
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-06-30_06:2020-06-30,2020-06-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=1
 mlxlogscore=999 lowpriorityscore=0 adultscore=0 mlxscore=0
 priorityscore=1501 cotscore=-2147483648 phishscore=0 impostorscore=0
 spamscore=0 bulkscore=0 malwarescore=0 clxscore=1015 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300157
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 03:22:34PM -0700, Cong Wang wrote:
> On Sat, Jun 27, 2020 at 4:41 PM Roman Gushchin <guro@fb.com> wrote:
> >
> > On Fri, Jun 26, 2020 at 10:58:14AM -0700, Cong Wang wrote:
> > > On Thu, Jun 25, 2020 at 10:23 PM Cameron Berkenpas <cam@neo-zeon.de> wrote:
> > > >
> > > > Hello,
> > > >
> > > > Somewhere along the way I got the impression that it generally takes
> > > > those affected hours before their systems lock up. I'm (generally) able
> > > > to reproduce this issue much faster than that. Regardless, I can help test.
> > > >
> > > > Are there any patches that need testing or is this all still pending
> > > > discussion around the  best way to resolve the issue?
> > >
> > > Yes. I come up with a (hopefully) much better patch in the attachment.
> > > Can you help to test it? You need to unapply the previous patch before
> > > applying this one.
> > >
> > > (Just in case of any confusion: I still believe we should check NULL on
> > > top of this refcnt fix. But it should be a separate patch.)
> > >
> > > Thank you!
> >
> > Not opposing the patch, but the Fixes tag is still confusing me.
> > Do we have an explanation for what's wrong with 4bfc0bb2c60e?
> >
> > It looks like we have cgroup_bpf_get()/put() exactly where we have
> > cgroup_get()/put(), so it would be nice to understand what's different
> > if the problem is bpf-related.
> 
> Hmm, I think it is Zefan who believes cgroup refcnt is fine, the bug
> is just in cgroup bpf refcnt, in our previous discussion.
> 
> Although I agree cgroup refcnt is buggy too, it may not necessarily
> cause any real problem, otherwise we would receive bug report
> much earlier than just recently, right?
> 
> If the Fixes tag is confusing, I can certainly remove it, but this also
> means the patch will not be backported to stable. I am fine either
> way, this crash is only reported after Zefan's recent change anyway.

Well, I'm not trying to protect my commit, I just don't understand
the whole picture and what I see doesn't make complete sense to me.

I understand a problem which can be described as copying the cgroup pointer
on cgroup cloning without bumping the reference counter.
It seems that this problem is not caused by bpf changes, so if we're adding
a Fixes tag, it must point at an earlier commit. Most likely, it was there from
scratch, i.e. from bd1060ad671 ("sock, cgroup: add sock->sk_cgroup").
Do we know why Zefan's change made it reproducible?

Btw if we want to backport the problem but can't blame a specific commit,
we can always use something like "Cc: <stable@vger.kernel.org>    [3.1+]".

Thanks!
