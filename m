Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8F84201F53
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 02:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731077AbgFTAwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 20:52:54 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:61128 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730293AbgFTAwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 20:52:53 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05K0iF6u004481;
        Fri, 19 Jun 2020 17:51:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=bsWHQ8XsgMzNgI1Aou7AXvJBvlmL10HMR2ayKdZ2Yn0=;
 b=T1TsxcmuX0uE+ChaFT5t6A43XNkuxQ3oa0PoNpd8ujlT+oz1K4fsLXuhpW6f5kWJ4AND
 fMkQqzuowSzQwybkL73wAqdmW9zoffnY04UJFZJTfBTpddzOcTVXLNpBgLEsX6HAZ28X
 botb0ExySR6r+cjJZOQXrqXBXh3iUc5Cqkg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31rwgscamp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 19 Jun 2020 17:51:20 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 19 Jun 2020 17:51:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wn9EEKx/XPn4lbVOyraSh9grqxYeQwWCiRTvi+K82WRvlletZ0Kcczk6eL6K6Z2CLEVu0nrK8RfDwSUrolArk0jpLeYRaqUQb1VxffCm6dxSV+uSethrvLGeMcPeN5odObmQzsUBw51uw/XovqceIqI8Vjt13NSGc3Y6Lf/SX22/A6JBcDG9xmqXvxihT3z0wKIdXrk/j4lM0E64tfZ76r4E8dBPEww0hqmobvQJOIyx3ZJbQeo0p6VpZQ+yro99vwgYfP8QY6l6yHGWX0lwyj8f7xCWyNFG1jh2FPk9EaqQGZDkX9lqA1cUSnoUkGMxpuxnBQGczK6w92ISeBJchQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bsWHQ8XsgMzNgI1Aou7AXvJBvlmL10HMR2ayKdZ2Yn0=;
 b=VYtXRcYR4W3wZY+N4eQR37kulT/NxEUF53GBSYMtl57IdI7lK0G79OSYSkQd3km7cdau3RZsK/gEp4RVCN99XnHQIUlenBn4gVXRGF3t6kQjOT+8GuaC6LJnoOTA6QwD6tU+DUnNC1REVog9XBDuMpnL7wuw6xmSJTnHzCmrLGg5/Hev5RRtbdSioZHBsSjoQpymmsJXfW/hzqTjsSbP6Cwn3sHb5cYjwLHOCnvH1gtD8JPTMzQUwnJC35bRn9C1s9zkiRISOpzT2AWfcyMMaz55je4Y6mJUTe6Be8S6H7/8vRZJUb30IiMYHL/skUllxQpqI0BSfqQDAsH4o/l0zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bsWHQ8XsgMzNgI1Aou7AXvJBvlmL10HMR2ayKdZ2Yn0=;
 b=aFEliuKm84zggPnUithZZ/12PI1l2/EZrCD6KvF5s9kG6xV9W3nUkwNBQbtxlhaAXc0FREpM548SJdMf8vjasXO9sFU36tieIUNV0eCEdeHABeAdocmjwSX+yA8zySVTEvUY9aetlm0aGhaLxDozdpHms9Br5gZ3dUQnuJHEzuo=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BY5PR15MB3524.namprd15.prod.outlook.com (2603:10b6:a03:1f5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Sat, 20 Jun
 2020 00:51:18 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::48e3:c159:703d:a2f1]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::48e3:c159:703d:a2f1%5]) with mapi id 15.20.3109.021; Sat, 20 Jun 2020
 00:51:18 +0000
Date:   Fri, 19 Jun 2020 17:51:15 -0700
From:   Roman Gushchin <guro@fb.com>
To:     Zefan Li <lizefan@huawei.com>
CC:     Cong Wang <xiyou.wangcong@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cameron Berkenpas <cam@neo-zeon.de>,
        Peter Geis <pgwipeout@gmail.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        =?iso-8859-1?Q?Dani=EBl?= Sonck <dsonck92@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [Patch net] cgroup: fix cgroup_sk_alloc() for sk_clone_lock()
Message-ID: <20200620005115.GE237539@carbon.dhcp.thefacebook.com>
References: <20200616180352.18602-1-xiyou.wangcong@gmail.com>
 <141629e1-55b5-34b1-b2ab-bab6b68f0671@huawei.com>
 <CAM_iQpUFFHPnMxS2sAHZqMUs80tTn0+C_jCcne4Ddx2b9omCxg@mail.gmail.com>
 <20200618193611.GE24694@carbon.DHCP.thefacebook.com>
 <CAM_iQpWuNnHqNHKz5FMgAXoqQ5qGDEtNbBKDXpmpeNSadCZ-1w@mail.gmail.com>
 <4f17229e-1843-5bfc-ea2f-67ebaa9056da@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f17229e-1843-5bfc-ea2f-67ebaa9056da@huawei.com>
X-ClientProxiedBy: BYAPR01CA0034.prod.exchangelabs.com (2603:10b6:a02:80::47)
 To BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:400::5:2b5d) by BYAPR01CA0034.prod.exchangelabs.com (2603:10b6:a02:80::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Sat, 20 Jun 2020 00:51:17 +0000
X-Originating-IP: [2620:10d:c090:400::5:2b5d]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c848487d-32e9-4434-3101-08d814b40ae1
X-MS-TrafficTypeDiagnostic: BY5PR15MB3524:
X-Microsoft-Antispam-PRVS: <BY5PR15MB3524456DFF47D09F7AFE7342BE990@BY5PR15MB3524.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0440AC9990
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SzIBSIHoqXgz3VKojTlAYslqirY9R8gzf//PBf7E/FMP0qOSyiQ7rJYlInJSSx7htERWTKBkRAAA8CbNt/Jlx+obfQSCEi9N9AFbj1YpmcfZN+DELpwYIVLKQkO8cITGDyE+giHA91KCOF8pgLjE6T4cEgAXUJ2LeRDc+QFRiROI80cYETY0hVWwzgk9clCoZJhCwsCqD2s9ndAhGtwjzkTQAN1TqFylw+2TORLvvJM/WanTiHXombkGKip0SRmoS+e41pnOEQBwgylRPnEoReyhd20tFz3rKXY9UOq+/6bPwGczY9tN3Coes1EGzVj8/kaAMFU51Ts1dE2qzoddcg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(346002)(39860400002)(136003)(376002)(396003)(83380400001)(478600001)(9686003)(7696005)(52116002)(5660300002)(66946007)(6506007)(66556008)(86362001)(316002)(53546011)(66476007)(186003)(55016002)(4326008)(8676002)(2906002)(33656002)(16526019)(54906003)(8936002)(1076003)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: EqztvHTIlJJpee0WaiJQJt4bkCYT53ARVHPmeHE2q8rP5s1Tq2L8nigToK0h+XUA0vhPoewRgPu0QVKTjn2APiBKjY7Wd/tKnjWKCFkPI9HlZpugH3KRO4DZ3yaq7DyDL7G3S8t7Dk5C2o+oolDj0/hYRknW3h1rl3xE6LM34Ygbiq/wLJPav0KZFlmtgzdFYdQzEQ3rJp7CD0JET+H4QNJysbOqp6Z/ri4ej7uH7fETbE91tKY+F/UblEIDot7EPEtKOIvqBoPZ6iAwf/yL7kSaCPkPE6O7Dc+phU9lHNtFyIJSLPZBeFz4t9MG4HRyLaXpYs0GdWTXxKYPiHSu8YPJHLnaxkrsrO4+Wb/q4N/J6lFklCfU1ErZVC7aYPKhgUu459gzD3Gh3av8cYG/S8Qwwqoxan6P4LTteFMxrFzMdt2P0MW/+syUvynKzc9sAwe7P14cxZd6pevHdKN3+KKTgdqyBR4Pbk1funTarz7z4TiXwih8VrgqRymevqlLBf8gB+Wjc7arI1QnGU5tdw==
X-MS-Exchange-CrossTenant-Network-Message-Id: c848487d-32e9-4434-3101-08d814b40ae1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2020 00:51:18.5283
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hGFhewARvo1ZKElv7r99rGe6nhuTXvYrdV7x2k3WRcUaraSydkexfYM1ZAqTYn5H
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3524
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-19_22:2020-06-19,2020-06-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 cotscore=-2147483648 spamscore=0 suspectscore=5 clxscore=1015 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 adultscore=0 mlxlogscore=809 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006200001
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 19, 2020 at 02:40:19PM +0800, Zefan Li wrote:
> On 2020/6/19 5:09, Cong Wang wrote:
> > On Thu, Jun 18, 2020 at 12:36 PM Roman Gushchin <guro@fb.com> wrote:
> >>
> >> On Thu, Jun 18, 2020 at 12:19:13PM -0700, Cong Wang wrote:
> >>> On Wed, Jun 17, 2020 at 6:44 PM Zefan Li <lizefan@huawei.com> wrote:
> >>>>
> >>>> Cc: Roman Gushchin <guro@fb.com>
> >>>>
> >>>> Thanks for fixing this.
> >>>>
> >>>> On 2020/6/17 2:03, Cong Wang wrote:
> >>>>> When we clone a socket in sk_clone_lock(), its sk_cgrp_data is
> >>>>> copied, so the cgroup refcnt must be taken too. And, unlike the
> >>>>> sk_alloc() path, sock_update_netprioidx() is not called here.
> >>>>> Therefore, it is safe and necessary to grab the cgroup refcnt
> >>>>> even when cgroup_sk_alloc is disabled.
> >>>>>
> >>>>> sk_clone_lock() is in BH context anyway, the in_interrupt()
> >>>>> would terminate this function if called there. And for sk_alloc()
> >>>>> skcd->val is always zero. So it's safe to factor out the code
> >>>>> to make it more readable.
> >>>>>
> >>>>> Fixes: 090e28b229af92dc5b ("netprio_cgroup: Fix unlimited memory leak of v2 cgroups")
> >>>>
> >>>> but I don't think the bug was introduced by this commit, because there
> >>>> are already calls to cgroup_sk_alloc_disable() in write_priomap() and
> >>>> write_classid(), which can be triggered by writing to ifpriomap or
> >>>> classid in cgroupfs. This commit just made it much easier to happen
> >>>> with systemd invovled.
> >>>>
> >>>> I think it's 4bfc0bb2c60e2f4c ("bpf: decouple the lifetime of cgroup_bpf from cgroup itself"),
> >>>> which added cgroup_bpf_get() in cgroup_sk_alloc().
> >>>
> >>> Good point.
> >>>
> >>> I take a deeper look, it looks like commit d979a39d7242e06
> >>> is the one to blame, because it is the first commit that began to
> >>> hold cgroup refcnt in cgroup_sk_alloc().
> >>
> >> I agree, ut seems that the issue is not related to bpf and probably
> >> can be reproduced without CONFIG_CGROUP_BPF. d979a39d7242e06 indeed
> >> seems closer to the origin.
> > 
> > Yeah, I will update the Fixes tag and send V2.
> > 
> 
> Commit d979a39d7242e06 looks innocent to me. With this commit when cgroup_sk_alloc
> is disabled and then a socket is cloned the cgroup refcnt will not be incremented,
> but this is fine, because when the socket is to be freed:
> 
>  sk_prot_free()
>    cgroup_sk_free()
>      cgroup_put(sock_cgroup_ptr(skcd)) == cgroup_put(&cgrp_dfl_root.cgrp)
> 
> cgroup_put() does nothing for the default root cgroup, so nothing bad will happen.
> 
> but cgroup_bpf_put() will decrement the bpf refcnt while this refcnt were not incremented
> as cgroup_sk_alloc has already been disabled. That's why I think it's 4bfc0bb2c60e2f4c
> that needs to be fixed.

Hm, does it mean that the problem always happens with the root cgroup?

From the stacktrace provided by Peter it looks like that the problem
is bpf-related, but the original patch says nothing about it.

So from the test above it sounds like the problem is that we're trying
to release root's cgroup_bpf, which is a bad idea, I totally agree.
Is this the problem? If so, we might wanna fix it in a different way,
just checking if (!(css->flags & CSS_NO_REF)) in cgroup_bpf_put()
like in cgroup_put(). It feels more reliable to me.

Thanks!

