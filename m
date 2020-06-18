Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDF0D1FFBE1
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 21:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbgFRTh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 15:37:26 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:7624 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726879AbgFRThZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 15:37:25 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05IJTJas011242;
        Thu, 18 Jun 2020 12:36:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=x5Mur3kRBc/WIfvKdYeMMZbV1QQqnngdTmAiLobFXHQ=;
 b=GUwfbl7q6iqvjeTmVqsBxwemXuxqNO0RZ51su+l8aiJBBhha8EHKkgv4PLCe4N7HNubk
 27kFNy7ieA9cN9x25Zzs+NA2fzx8lPIRlgBZMOcdPogLSyvSBYt09tg1ixO+abzMWdZR
 X6eDRHzM/ea5RkLjJ2L+SqV4/osnvgnC/nM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31q8u6njfm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 18 Jun 2020 12:36:17 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 18 Jun 2020 12:36:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ol/B7PsJfS88N3YVan5YZ8FOvu0Bw7Qq/2XeTcTOfhTvnM6kt6NaF50RW/lQR6Fzi8f5HBr5RN6XdGNnY+/6xUg2hkk+OvYoB9CXJ2lZ0SqCyUwECtkz/DltKP2few2xx+mUsuFP1zc2nTHessdpNOLBzG3l0ohGyII91K2QiuPzi2lcHl9tPf7rg+clU9JTaNQ5LnlpVKnaM+b9a2JE9fg/Bgw052o1y2Zm79RA75CeGfrE9AYBmUmKwKnoGs5G0OPgKDWitn3+A+RUp+UA9DfnALUwJxGlpZHxvJNG7zDOaWiXKdpRkHQ4Q2hce2HcBv2LjKRZBZYd6v0Zi6U3TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x5Mur3kRBc/WIfvKdYeMMZbV1QQqnngdTmAiLobFXHQ=;
 b=aTDB0DlQDnWS8vigfDeQCy8Te4/HbgwUZRlG8aUycYNlGSvepydDK1cDh/WTT3v6yZEpzGfPN6DwzNwsZFBBXyTtf69Nh6Wbo/BaaqrBw8nqDDg9H/rJ2l6TwGqqJOw+xDwsJSBFI+xI9rhNaLEC9S7fzqKMHqTgzxDBVMW4U/3s7+V+gG+CUvxWP8QXj6B+acFy2F7LJk3wAvDD6s/7TYLrtmKVivXSqkeudve3zU17XSq8Sch27mq1trGu2JfYTrzceShyrpn8SnkPYwVchbzSiMXG+Q+jhJFJhMrleKa993cevCqq/9ThtbwBOPRRpTNoApZl119r5MOrxg0NxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x5Mur3kRBc/WIfvKdYeMMZbV1QQqnngdTmAiLobFXHQ=;
 b=A74FaY9BdHLghzlZVfHuqqVBnrwOOqCLox3oLogiHTldlP1rTi6h6coH90CECvVDQ/KOqCsIxJrU3DN2B4+1IMIPGEnVIlDy2O+dq8tS8AI9NrYOsFsmnUHjzvhpWNhFF3d7SOwdzjs3PJUS9ylMHn2q507p4Yt1e1vqhxplwO8=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB3143.namprd15.prod.outlook.com (2603:10b6:a03:b5::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Thu, 18 Jun
 2020 19:36:15 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::48e3:c159:703d:a2f1]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::48e3:c159:703d:a2f1%5]) with mapi id 15.20.3109.021; Thu, 18 Jun 2020
 19:36:15 +0000
Date:   Thu, 18 Jun 2020 12:36:11 -0700
From:   Roman Gushchin <guro@fb.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     Zefan Li <lizefan@huawei.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cameron Berkenpas <cam@neo-zeon.de>,
        Peter Geis <pgwipeout@gmail.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        =?iso-8859-1?Q?Dani=EBl?= Sonck <dsonck92@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [Patch net] cgroup: fix cgroup_sk_alloc() for sk_clone_lock()
Message-ID: <20200618193611.GE24694@carbon.DHCP.thefacebook.com>
References: <20200616180352.18602-1-xiyou.wangcong@gmail.com>
 <141629e1-55b5-34b1-b2ab-bab6b68f0671@huawei.com>
 <CAM_iQpUFFHPnMxS2sAHZqMUs80tTn0+C_jCcne4Ddx2b9omCxg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpUFFHPnMxS2sAHZqMUs80tTn0+C_jCcne4Ddx2b9omCxg@mail.gmail.com>
X-ClientProxiedBy: BYAPR05CA0079.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::20) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.DHCP.thefacebook.com (2620:10d:c090:400::5:632d) by BYAPR05CA0079.namprd05.prod.outlook.com (2603:10b6:a03:e0::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.10 via Frontend Transport; Thu, 18 Jun 2020 19:36:14 +0000
X-Originating-IP: [2620:10d:c090:400::5:632d]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 30013670-75ea-43ce-2c9e-08d813bedd59
X-MS-TrafficTypeDiagnostic: BYAPR15MB3143:
X-Microsoft-Antispam-PRVS: <BYAPR15MB3143C5831FC9CEEAB54A5D78BE9B0@BYAPR15MB3143.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0438F90F17
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S8376XTHwkD01MlFLR8G6djzHq7ZMyOec7LrmFB54Di3mlukGzuDEg4nfnnNOrLEZNs9nN5GT0Ml+KYQTcGE9fYIcjGQTFBoq20vGBMaNYPnfVpoLAIqKNapOs7ryBN4VTW9qAtH8AgAN0zZigQdqj09/XIv+9ex0rqBY+iQoVSwCj06hKRmkAr+XV0S+3398uUeExHy3IOG+fkAgce6TNMt0UYllgP4BebVA8AOpRVcY+cWgju+9MeO5CI57WpD+R2A+UAswsf+cwQbRzQa1k9S4L5oWumC2ox0+EnTt2e7MtH71pv7u52vevNzlBQddJS27xyJPPx/JH56bGt4zA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(136003)(346002)(376002)(39860400002)(366004)(66946007)(316002)(54906003)(16526019)(186003)(8936002)(66476007)(66556008)(2906002)(8676002)(33656002)(6916009)(83380400001)(6506007)(7696005)(52116002)(9686003)(1076003)(55016002)(86362001)(53546011)(4326008)(478600001)(5660300002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: blhfW0ew5q8HL7OsWEMpygLTY58IvMGo6bkb1O3Dv44qs+wipi4o0xvpujhqTYYdhWLLrrUPdcb/ma2ek4m54yErbEFREIqIgGyzQ1nJcSFSvJpNjfOQlkR4PGToBZj9FThDG92vIa03fkSDafkaCg0+bJppoeOWYsFYLXKqvk4E2r3j6cffCy1lTGfRZiNOULc9CSDjRJ0nLcxhYHuxzuaD5fzFpCv/eWHPXK+upVc8kOdPezzBRlVdlsiOvkYv3v7z6ediT+WRSvQXYpsTGnLiTnv926AKNr3uGETJ5f01NrZzI4qTRWFLK0L+iCk3XKY6hI5cqRNf2FmSG6WNTza/bONnphQHwdSe1uNoxklPoIUTflk50tz2s60WLAmOhBOVMoR89ZHRyq1wgSlOlywhKARO6JdJIOSYG2IAq4HG1xhNgVGS2bR4VY3Q5atrUOPUHoqprKWzyzW+Mq0Lch9BD5gamS1S8jY1+c1WgyRf/PCw34uXfoPkAlxGgKYiNvFCMqCph8d0gQ7Reeas4Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: 30013670-75ea-43ce-2c9e-08d813bedd59
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2020 19:36:15.3688
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gVmEDUiLRqQm1IiFe+oB68o+B8FWdR/QydlEq7c4sWh8qteKIuKFkK+lBgvO/KEC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3143
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-18_15:2020-06-18,2020-06-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 clxscore=1011 phishscore=0
 cotscore=-2147483648 malwarescore=0 bulkscore=0 lowpriorityscore=0
 mlxlogscore=662 mlxscore=0 suspectscore=1 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006180148
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 12:19:13PM -0700, Cong Wang wrote:
> On Wed, Jun 17, 2020 at 6:44 PM Zefan Li <lizefan@huawei.com> wrote:
> >
> > Cc: Roman Gushchin <guro@fb.com>
> >
> > Thanks for fixing this.
> >
> > On 2020/6/17 2:03, Cong Wang wrote:
> > > When we clone a socket in sk_clone_lock(), its sk_cgrp_data is
> > > copied, so the cgroup refcnt must be taken too. And, unlike the
> > > sk_alloc() path, sock_update_netprioidx() is not called here.
> > > Therefore, it is safe and necessary to grab the cgroup refcnt
> > > even when cgroup_sk_alloc is disabled.
> > >
> > > sk_clone_lock() is in BH context anyway, the in_interrupt()
> > > would terminate this function if called there. And for sk_alloc()
> > > skcd->val is always zero. So it's safe to factor out the code
> > > to make it more readable.
> > >
> > > Fixes: 090e28b229af92dc5b ("netprio_cgroup: Fix unlimited memory leak of v2 cgroups")
> >
> > but I don't think the bug was introduced by this commit, because there
> > are already calls to cgroup_sk_alloc_disable() in write_priomap() and
> > write_classid(), which can be triggered by writing to ifpriomap or
> > classid in cgroupfs. This commit just made it much easier to happen
> > with systemd invovled.
> >
> > I think it's 4bfc0bb2c60e2f4c ("bpf: decouple the lifetime of cgroup_bpf from cgroup itself"),
> > which added cgroup_bpf_get() in cgroup_sk_alloc().
> 
> Good point.
> 
> I take a deeper look, it looks like commit d979a39d7242e06
> is the one to blame, because it is the first commit that began to
> hold cgroup refcnt in cgroup_sk_alloc().

I agree, ut seems that the issue is not related to bpf and probably
can be reproduced without CONFIG_CGROUP_BPF. d979a39d7242e06 indeed
seems closer to the origin.

Btw, based on the number of reported-by tags it seems that there was
a real issue which the patch is fixing. Maybe you'll a couple of words
about how it reveals itself in the real life?

Thanks!
