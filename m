Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCB71201F6D
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 03:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731306AbgFTBP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 21:15:26 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48690 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730293AbgFTBPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 21:15:23 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05K1E2Qd008565;
        Fri, 19 Jun 2020 18:14:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=JUg5pjTIefwUAWkdLe9Hh/beu75cNS1lgL0QKm2LG0c=;
 b=aJKr/EBEVWIdrYAtpr2NQrpKMZOmx2E4ZiP1wCx9T3bxGB3Ksgi93M3tjdHmy/dy980o
 lokRoX0HXrQtEzrH9caBaklpfrnohnexdU+ToWqu1lXWeP8iQRWeJgDEQQuegXH9x106
 yDJ9VAgb7ssFIMpn46115wWXZVQe1x+hu+g= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31s2rcsk2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 19 Jun 2020 18:14:14 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 19 Jun 2020 18:14:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J/PqCbKsCF9lvB7A954L44LCqKosiRwxAcYUBkGtknR1FqPojVUcQoCRLHUTe+u0S7fNcmWX+KaZyVmfiB8mMKDPDh4Gbx2IFW0xaJPIOTuKVZkypofx5UG+/sC8G/jMnIY9ulxPhC0d5fLx+y3EnYKFx3BVJuTdIiyD4Oig3jziF3cbb+VG66MADn1UN9G/Mhax7UJRNiKb1lz7GNHsXjEwBUiO3DHrd0sdFT1GFwnxqFvh1YMJd28J1xchDV1ev8EXm3aSU5ZO832rFwEDYKU/3R8n9P7DZyMYlio0bRiIfZdRW96nqB8p6YS/ECxqUCl2j6joYqC2lcNOZxrrgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JUg5pjTIefwUAWkdLe9Hh/beu75cNS1lgL0QKm2LG0c=;
 b=m50NQd/+h7oUK7EypvMcUaDPffnqwS0M0TNQlTl63WqgyVUpdvi5r+trFNFWFr7ZWHApldJACkINQvjromLI46axs//Zv/sUCgyHMT3sTdKMFmxFuBoGsdAHLrDJiolO/PXJBsP9eF8xivoT6dUIKCYGs4JjdM/Oo+8Kf60MYi1tYUDzuQjNpWiyWkF5EHcCpopTPkPBUwLxVrmgKttAL9dns25J3JcJUvotr7yHHApmrdiEiz6VXG4ugEf2B87eu/FlRNgZMO2SQSHQnDX/1K5MZMRypoGNTkIlW5OCeVgxRYQcrVqEUfim2fdOzlr6howQ6Eaho9nSqi0TERpP2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JUg5pjTIefwUAWkdLe9Hh/beu75cNS1lgL0QKm2LG0c=;
 b=BWiLnfNPJwjHF5FJjbu4rIhx0sRF7SGoCjPVxUkcxZR6Sgeooxvv+BKQImEAiPwLF8fYTsSzqd/0BK6NETntcCc2IlnOwyc5Umyz7255IHy9Bryu4unDocyATwVYXgAzGJPvkqZQ33I/H1r9kGu1tjKrSwaj/t2TlCDXiVShIak=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB2805.namprd15.prod.outlook.com (2603:10b6:a03:14e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.23; Sat, 20 Jun
 2020 01:14:12 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::48e3:c159:703d:a2f1]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::48e3:c159:703d:a2f1%5]) with mapi id 15.20.3109.021; Sat, 20 Jun 2020
 01:14:12 +0000
Date:   Fri, 19 Jun 2020 18:14:09 -0700
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
Message-ID: <20200620011409.GG237539@carbon.dhcp.thefacebook.com>
References: <20200616180352.18602-1-xiyou.wangcong@gmail.com>
 <141629e1-55b5-34b1-b2ab-bab6b68f0671@huawei.com>
 <CAM_iQpUFFHPnMxS2sAHZqMUs80tTn0+C_jCcne4Ddx2b9omCxg@mail.gmail.com>
 <20200618193611.GE24694@carbon.DHCP.thefacebook.com>
 <CAM_iQpWuNnHqNHKz5FMgAXoqQ5qGDEtNbBKDXpmpeNSadCZ-1w@mail.gmail.com>
 <4f17229e-1843-5bfc-ea2f-67ebaa9056da@huawei.com>
 <20200620005115.GE237539@carbon.dhcp.thefacebook.com>
 <f80878fe-bf2d-605a-50e4-bda97a1390c2@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f80878fe-bf2d-605a-50e4-bda97a1390c2@huawei.com>
X-ClientProxiedBy: BYAPR06CA0032.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::45) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:400::5:2b5d) by BYAPR06CA0032.namprd06.prod.outlook.com (2603:10b6:a03:d4::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Sat, 20 Jun 2020 01:14:11 +0000
X-Originating-IP: [2620:10d:c090:400::5:2b5d]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2fe8f0b8-f3e6-4856-c743-08d814b73de6
X-MS-TrafficTypeDiagnostic: BYAPR15MB2805:
X-Microsoft-Antispam-PRVS: <BYAPR15MB280557D9445AE085381AF0D3BE990@BYAPR15MB2805.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0440AC9990
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jDyrskSdhtYY3AA7cvx0+WrLWjnUMFHNfqf7/6ZsyS2fvPrhFAKQQvI6WN+IkrHH47bwpcp2IOklUJ8V6xctKlKSCR530ZDdjv0u/DgApmpl33Znnte/6coxzD2RIbaRIxlsNAHcPURh6zOzGpkr1jW1CsOP4QbdwmzgbtmSh+Cp5HzDp06BGGMLhyY/47qVYrpoX3ZqL4o9MtfnZ/RgsBxcIn6lgn6/C7nr/Rk8I2UUHrTOP581D1mbtSjOOmeMXCFBrtrxl9cW+GRhsPtCzByXv35a0xPgjPU5PbkGLe6Vi0P3I6uS0kxVxrg6/RdAJ4tHT+DB2SZdtW1H5tUGSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(396003)(136003)(376002)(39860400002)(366004)(478600001)(52116002)(7696005)(186003)(6506007)(1076003)(33656002)(53546011)(66946007)(16526019)(66476007)(66556008)(54906003)(316002)(55016002)(9686003)(86362001)(5660300002)(4326008)(8936002)(6916009)(8676002)(2906002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: BcGLiS39QIaOyrZLpyyuCNDjZRpg/G2pLDeBfI0E8ZYzRR37dqU7WPSxm+PCDSuBLlZ3egFJunfp8dA2KumlJer5VUCV0/LGSNlZoTbRKhvnBpDs7JabaiTmeR9lzoH9yjF20zH7YhfUypNBMRJDe82AVkG+MHuf8EIBhhmCaqWULDVjFK/9TdIRlgJFrfc+0gcYxeGe0C+JDAb0zger1TPXAJFnhWQvuFS8anVJHEuwxtCGKX3pWPQvN6XWuNr33Qu9wyvX3tv49144EvnnJoE46nabbg+n9tORfNOepOIKxkcJys0IYzEx+mqiqNRw81iTTUoMxoYDrcxtvA7J1J8MaqNJgJ6BuVe/gux9E9XoFhMcTShmkLCPWfjn5TWuH61umX2emivLXQdMOwqJzXh/CyWjQz/VKVwqOBvxuHuw7z6oyGldQquPCFzn+8NLySAA3HLwMi0f0rgqEfiZc1MwTmc5YVTxl5LlC3/5kixdpbslog18eKTB/j/2ZRS2g+MSQIxHc9dGXVCs4jcvaw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fe8f0b8-f3e6-4856-c743-08d814b73de6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2020 01:14:12.5445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UuEZfhckh98hOZrt52PF03WdoWKJoRt9eHYbWmaTZz072ClsgT26MV2O+En5s4rB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2805
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-19_22:2020-06-19,2020-06-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=5
 bulkscore=0 malwarescore=0 mlxscore=0 lowpriorityscore=0
 cotscore=-2147483648 priorityscore=1501 clxscore=1015 adultscore=0
 spamscore=0 mlxlogscore=999 impostorscore=0 phishscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006200005
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 20, 2020 at 09:00:40AM +0800, Zefan Li wrote:
> On 2020/6/20 8:51, Roman Gushchin wrote:
> > On Fri, Jun 19, 2020 at 02:40:19PM +0800, Zefan Li wrote:
> >> On 2020/6/19 5:09, Cong Wang wrote:
> >>> On Thu, Jun 18, 2020 at 12:36 PM Roman Gushchin <guro@fb.com> wrote:
> >>>>
> >>>> On Thu, Jun 18, 2020 at 12:19:13PM -0700, Cong Wang wrote:
> >>>>> On Wed, Jun 17, 2020 at 6:44 PM Zefan Li <lizefan@huawei.com> wrote:
> >>>>>>
> >>>>>> Cc: Roman Gushchin <guro@fb.com>
> >>>>>>
> >>>>>> Thanks for fixing this.
> >>>>>>
> >>>>>> On 2020/6/17 2:03, Cong Wang wrote:
> >>>>>>> When we clone a socket in sk_clone_lock(), its sk_cgrp_data is
> >>>>>>> copied, so the cgroup refcnt must be taken too. And, unlike the
> >>>>>>> sk_alloc() path, sock_update_netprioidx() is not called here.
> >>>>>>> Therefore, it is safe and necessary to grab the cgroup refcnt
> >>>>>>> even when cgroup_sk_alloc is disabled.
> >>>>>>>
> >>>>>>> sk_clone_lock() is in BH context anyway, the in_interrupt()
> >>>>>>> would terminate this function if called there. And for sk_alloc()
> >>>>>>> skcd->val is always zero. So it's safe to factor out the code
> >>>>>>> to make it more readable.
> >>>>>>>
> >>>>>>> Fixes: 090e28b229af92dc5b ("netprio_cgroup: Fix unlimited memory leak of v2 cgroups")
> >>>>>>
> >>>>>> but I don't think the bug was introduced by this commit, because there
> >>>>>> are already calls to cgroup_sk_alloc_disable() in write_priomap() and
> >>>>>> write_classid(), which can be triggered by writing to ifpriomap or
> >>>>>> classid in cgroupfs. This commit just made it much easier to happen
> >>>>>> with systemd invovled.
> >>>>>>
> >>>>>> I think it's 4bfc0bb2c60e2f4c ("bpf: decouple the lifetime of cgroup_bpf from cgroup itself"),
> >>>>>> which added cgroup_bpf_get() in cgroup_sk_alloc().
> >>>>>
> >>>>> Good point.
> >>>>>
> >>>>> I take a deeper look, it looks like commit d979a39d7242e06
> >>>>> is the one to blame, because it is the first commit that began to
> >>>>> hold cgroup refcnt in cgroup_sk_alloc().
> >>>>
> >>>> I agree, ut seems that the issue is not related to bpf and probably
> >>>> can be reproduced without CONFIG_CGROUP_BPF. d979a39d7242e06 indeed
> >>>> seems closer to the origin.
> >>>
> >>> Yeah, I will update the Fixes tag and send V2.
> >>>
> >>
> >> Commit d979a39d7242e06 looks innocent to me. With this commit when cgroup_sk_alloc
> >> is disabled and then a socket is cloned the cgroup refcnt will not be incremented,
> >> but this is fine, because when the socket is to be freed:
> >>
> >>  sk_prot_free()
> >>    cgroup_sk_free()
> >>      cgroup_put(sock_cgroup_ptr(skcd)) == cgroup_put(&cgrp_dfl_root.cgrp)
> >>
> >> cgroup_put() does nothing for the default root cgroup, so nothing bad will happen.
> >>
> >> but cgroup_bpf_put() will decrement the bpf refcnt while this refcnt were not incremented
> >> as cgroup_sk_alloc has already been disabled. That's why I think it's 4bfc0bb2c60e2f4c
> >> that needs to be fixed.
> > 
> > Hm, does it mean that the problem always happens with the root cgroup?
> > 
> >>From the stacktrace provided by Peter it looks like that the problem
> > is bpf-related, but the original patch says nothing about it.
> > 
> > So from the test above it sounds like the problem is that we're trying
> > to release root's cgroup_bpf, which is a bad idea, I totally agree.
> > Is this the problem?
> 
> I think so, though I'm not familiar with the bfp cgroup code.
> 
> > If so, we might wanna fix it in a different way,
> > just checking if (!(css->flags & CSS_NO_REF)) in cgroup_bpf_put()
> > like in cgroup_put(). It feels more reliable to me.
> > 
> 
> Yeah I also have this idea in my mind.

I wonder if the following patch will fix the issue?

--

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 4598e4da6b1b..7eb51137d896 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -942,12 +942,14 @@ static inline bool cgroup_task_frozen(struct task_struct *task)
 #ifdef CONFIG_CGROUP_BPF
 static inline void cgroup_bpf_get(struct cgroup *cgrp)
 {
-       percpu_ref_get(&cgrp->bpf.refcnt);
+       if (!(cgrp->self.flags & CSS_NO_REF))
+               percpu_ref_get(&cgrp->bpf.refcnt);
 }
 
 static inline void cgroup_bpf_put(struct cgroup *cgrp)
 {
-       percpu_ref_put(&cgrp->bpf.refcnt);
+       if (!(cgrp->self.flags & CSS_NO_REF))
+               percpu_ref_put(&cgrp->bpf.refcnt);
 }
 
 #else /* CONFIG_CGROUP_BPF */
