Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE8D202508
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 18:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbgFTQF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 12:05:28 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41724 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725826AbgFTQF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 12:05:26 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05KFu7Ee010236;
        Sat, 20 Jun 2020 09:04:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=49FxAEOFsptlHB1iQJxGETcaSrX0hLHYU7qva0hn2Ak=;
 b=Xow4Lf+m7/ql9nudBoPPLyzrxqMdioq7wGHkKqCtHK3Iz0itWTkyygW7kMvGHQqmhRa/
 Amm3Nd9N93foMt91dFHf1IDsxlSZA61cXTHG/L9eu5u1WshfFnzoRuSMOt8+u0p73BVP
 f4PD3oNcBIKqS+6DOqyfcK3fYMtP2b88QvY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31sdsk98by-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 20 Jun 2020 09:04:08 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 20 Jun 2020 09:04:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lGRQGFMs+Y3Kr7AHhOudSWlS6SQeumx8OwBllmZPWnN8XypWHWgFdVaoS0G0ZDrECIe+L/iQ5Nl6nXcy48/pJ4YDep42iMoeSpgg650I873scTLfhttR+pNcj5he9+qCA6CQFWf1EWpWpXrtZFlDKurJPora1vGJkuV14FI4ShfJHNHguqe6joXrIRV6yjIvw2pSzaN9cBe7Z0fH4WpVdmJHWFf/msEyJkKGPZykl4XBygSrN/NSIpDPVwiW1We3kwwolZVUpgGlUwkwKlqi2+uvB6rPvmX3GCuWXdAkUvS7ZYcd6aBzWaLanuBsTqh8zoPovKRKE5gRipUJArk3ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=49FxAEOFsptlHB1iQJxGETcaSrX0hLHYU7qva0hn2Ak=;
 b=JbjVhsRrFb/desCIC5fKjiSMEjwNsJVTtHHgO2PxPo45aSwTRzYl77CDB8bxqZGY/vPwJULspFateciD7iEmnkXPz/NGLX3StazMWwUQvdzo0GT02N5SP440FtuQ/+w4KuCtt5KTg85Zfid9n4ySahdR7XcK6K09SBSFXVp/pcdWQ8FjqMicwA7fc+cdDVGNVZDHFJ7GGW7pUeM36kqOFRRukaCSIvs7Z3wkuTaT9Et0EA6pzgy8DOu4zskX4ZVGNcTQT/6zAnxFXTPCOKArSjZ0qh585Rcy2ISsBwN6nRMwjDPEukGSeXeLnnZZBzNM4lD+VwcSsnhYwxt/hld05g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=49FxAEOFsptlHB1iQJxGETcaSrX0hLHYU7qva0hn2Ak=;
 b=IT6EbGpzVWYpAWyPwx1OMJEyaxqVX1aY5bKpg4G1w51eO+ix1/v/hpgD6FKri8GlOrg3gA2N6OO68Nl/L622fdBAg1YrcRR+/0+M2RH24F13GtMc0ahyWcJNfVEgPf0VAIAQZqmZIYH+f0YcLS7B/b2msLayGmrtMez2FtXLON0=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB2341.namprd15.prod.outlook.com (2603:10b6:a02:81::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Sat, 20 Jun
 2020 16:04:06 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::48e3:c159:703d:a2f1]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::48e3:c159:703d:a2f1%5]) with mapi id 15.20.3109.021; Sat, 20 Jun 2020
 16:04:06 +0000
Date:   Sat, 20 Jun 2020 09:04:03 -0700
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
Message-ID: <20200620160403.GA281075@carbon.dhcp.thefacebook.com>
References: <141629e1-55b5-34b1-b2ab-bab6b68f0671@huawei.com>
 <CAM_iQpUFFHPnMxS2sAHZqMUs80tTn0+C_jCcne4Ddx2b9omCxg@mail.gmail.com>
 <20200618193611.GE24694@carbon.DHCP.thefacebook.com>
 <CAM_iQpWuNnHqNHKz5FMgAXoqQ5qGDEtNbBKDXpmpeNSadCZ-1w@mail.gmail.com>
 <4f17229e-1843-5bfc-ea2f-67ebaa9056da@huawei.com>
 <CAM_iQpVKqFi00ohqPARxaDw2UN1m6CtjqsmBAP-pcK0GT2p_fQ@mail.gmail.com>
 <459be87d-0272-9ea9-839a-823b01e354b6@huawei.com>
 <35480172-c77e-fb67-7559-04576f375ea6@huawei.com>
 <CAM_iQpXpZd6ZaQyQifWOHSnqgAgdu1qP+fF_Na7rQ_H1vQ6eig@mail.gmail.com>
 <17116b4b-7542-86b5-5e78-9d6ab00e2c07@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <17116b4b-7542-86b5-5e78-9d6ab00e2c07@huawei.com>
X-ClientProxiedBy: BY5PR16CA0002.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::15) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:400::5:c714) by BY5PR16CA0002.namprd16.prod.outlook.com (2603:10b6:a03:1a0::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21 via Frontend Transport; Sat, 20 Jun 2020 16:04:05 +0000
X-Originating-IP: [2620:10d:c090:400::5:c714]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22c9687d-7979-4a1e-0e43-08d815338efc
X-MS-TrafficTypeDiagnostic: BYAPR15MB2341:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2341BED4534C8890D456C17ABE990@BYAPR15MB2341.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0440AC9990
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hZp2QHtKm7z3yG6YXN0VtM+NbeXoTF/tfbkNOphXpuRRQUcTWkdZ+PZtFoakRjdZBhefuCCrKULALEfOMKIxJQKf2bLdQulahnG8jdPigMms1dzgMUAEyVZhGA9I0xhgVIMN2aeAfH8iMKP/L/g6GNfm6ZjZmHa7/xN+gKtUTjutKiu+La2isaxBG0zWS9Uh1/ociTBeKr6mSO1y8Mgy+i2ick1jbnHNT47kCro2s5dNGyEUGiluotQUpiBcqHc4BXx14JgtEdI5B5gYgHV6bbdrYengpoK79ewatMBJ/m6uUs7kcqgP+OmnoQcmrlM+OUYSgsb6ebSELQ2uE+pZ6g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(346002)(376002)(136003)(39860400002)(396003)(53546011)(6506007)(9686003)(186003)(83380400001)(16526019)(86362001)(55016002)(54906003)(2906002)(8676002)(478600001)(52116002)(8936002)(6916009)(66946007)(66476007)(5660300002)(66556008)(33656002)(1076003)(7696005)(4326008)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: fF/MyRy3LH1gBvI5J4QjnAhmN8Gqew7o/0SVUG1Yp6Ub+dnhteYIBP1pEPynm2osW/hQn7ujsZASBclfxfOF3NtENxVlR6wM6WzjkMDn6/Gmwh8ci3f8Ff5QmHklFf2RzSlGz2KuarFb/lZxafFuBMyCIpMMbDC6kAbVibZVRkoB1xJ1dREmgm/AwYZd345kCIfZ9fQ8tHFTEYlD2enAE5XLCkgl9AYBM8TicjF8j9cXEOb5AWGa5O5Mi+ldPbv3vZN4WjvNXMaD0oNeMwW6MUFvrb7AdO5L3JsJOw/byUEwcjaid3ZEtt6bKtHip3a5XOSdlDdeEzS8a6uX9hWfz34gTU7CfxTNjyHVDtou9XKtWHtWkocW39dFv3xNhUn0Y4dlMyyYwWXfaP4A4fLaLjZ5/sMVigCZ4RLb9hge9dKyKOeoV3OB5HKPSaGcikmbLHgZAaTf8wpgS76IpE9TqVeHDnHky4cwiTQKeOdaxoktF0mWCTgpeUBriWShFW1IADPxtSur/JYchvmPeSjvkQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 22c9687d-7979-4a1e-0e43-08d815338efc
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2020 16:04:06.1889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EsocOfU52zuiS8ud0IlBQZ7oSVhFSIJDLVYys9PS/vg7qXfqfyYVSVOLxqtHM3EQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2341
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-20_09:2020-06-19,2020-06-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 cotscore=-2147483648
 mlxlogscore=944 clxscore=1015 impostorscore=0 priorityscore=1501
 phishscore=0 adultscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0
 malwarescore=0 suspectscore=5 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006200118
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 20, 2020 at 03:52:49PM +0800, Zefan Li wrote:
> 在 2020/6/20 11:31, Cong Wang 写道:
> > On Fri, Jun 19, 2020 at 5:51 PM Zefan Li <lizefan@huawei.com> wrote:
> >>
> >> 在 2020/6/20 8:45, Zefan Li 写道:
> >>> On 2020/6/20 3:51, Cong Wang wrote:
> >>>> On Thu, Jun 18, 2020 at 11:40 PM Zefan Li <lizefan@huawei.com> wrote:
> >>>>>
> >>>>> On 2020/6/19 5:09, Cong Wang wrote:
> >>>>>> On Thu, Jun 18, 2020 at 12:36 PM Roman Gushchin <guro@fb.com> wrote:
> >>>>>>>
> >>>>>>> On Thu, Jun 18, 2020 at 12:19:13PM -0700, Cong Wang wrote:
> >>>>>>>> On Wed, Jun 17, 2020 at 6:44 PM Zefan Li <lizefan@huawei.com> wrote:
> >>>>>>>>>
> >>>>>>>>> Cc: Roman Gushchin <guro@fb.com>
> >>>>>>>>>
> >>>>>>>>> Thanks for fixing this.
> >>>>>>>>>
> >>>>>>>>> On 2020/6/17 2:03, Cong Wang wrote:
> >>>>>>>>>> When we clone a socket in sk_clone_lock(), its sk_cgrp_data is
> >>>>>>>>>> copied, so the cgroup refcnt must be taken too. And, unlike the
> >>>>>>>>>> sk_alloc() path, sock_update_netprioidx() is not called here.
> >>>>>>>>>> Therefore, it is safe and necessary to grab the cgroup refcnt
> >>>>>>>>>> even when cgroup_sk_alloc is disabled.
> >>>>>>>>>>
> >>>>>>>>>> sk_clone_lock() is in BH context anyway, the in_interrupt()
> >>>>>>>>>> would terminate this function if called there. And for sk_alloc()
> >>>>>>>>>> skcd->val is always zero. So it's safe to factor out the code
> >>>>>>>>>> to make it more readable.
> >>>>>>>>>>
> >>>>>>>>>> Fixes: 090e28b229af92dc5b ("netprio_cgroup: Fix unlimited memory leak of v2 cgroups")
> >>>>>>>>>
> >>>>>>>>> but I don't think the bug was introduced by this commit, because there
> >>>>>>>>> are already calls to cgroup_sk_alloc_disable() in write_priomap() and
> >>>>>>>>> write_classid(), which can be triggered by writing to ifpriomap or
> >>>>>>>>> classid in cgroupfs. This commit just made it much easier to happen
> >>>>>>>>> with systemd invovled.
> >>>>>>>>>
> >>>>>>>>> I think it's 4bfc0bb2c60e2f4c ("bpf: decouple the lifetime of cgroup_bpf from cgroup itself"),
> >>>>>>>>> which added cgroup_bpf_get() in cgroup_sk_alloc().
> >>>>>>>>
> >>>>>>>> Good point.
> >>>>>>>>
> >>>>>>>> I take a deeper look, it looks like commit d979a39d7242e06
> >>>>>>>> is the one to blame, because it is the first commit that began to
> >>>>>>>> hold cgroup refcnt in cgroup_sk_alloc().
> >>>>>>>
> >>>>>>> I agree, ut seems that the issue is not related to bpf and probably
> >>>>>>> can be reproduced without CONFIG_CGROUP_BPF. d979a39d7242e06 indeed
> >>>>>>> seems closer to the origin.
> >>>>>>
> >>>>>> Yeah, I will update the Fixes tag and send V2.
> >>>>>>
> >>>>>
> >>>>> Commit d979a39d7242e06 looks innocent to me. With this commit when cgroup_sk_alloc
> >>>>> is disabled and then a socket is cloned the cgroup refcnt will not be incremented,
> >>>>> but this is fine, because when the socket is to be freed:
> >>>>>
> >>>>>  sk_prot_free()
> >>>>>    cgroup_sk_free()
> >>>>>      cgroup_put(sock_cgroup_ptr(skcd)) == cgroup_put(&cgrp_dfl_root.cgrp)
> >>>>>
> >>>>> cgroup_put() does nothing for the default root cgroup, so nothing bad will happen.
> >>>>
> >>>> But skcd->val can be a pointer to a non-root cgroup:
> >>>
> >>> It returns a non-root cgroup when cgroup_sk_alloc is not disabled. The bug happens
> >>> when cgroup_sk_alloc is disabled.
> >>>
> >>
> >> And please read those recent bug reports, they all happened when bpf cgroup was in use,
> >> and there was no bpf cgroup when d979a39d7242e06 was merged into mainline.
> > 
> > I am totally aware of this. My concern is whether cgroup
> > has the same refcnt bug as it always pairs with the bpf refcnt.
> > 
> > But, after a second look, the non-root cgroup refcnt is immediately
> > overwritten by sock_update_classid() or sock_update_netprioidx(),
> > which effectively turns into a root cgroup again. :-/
> > 
> > (It seems we leak a refcnt here, but this is not related to my patch).
> > 
> 
> Indead, but it's well known, see bd1060a1d67128bb8fbe2. But now bpf cgroup comes into play...
> 
> Your patch doesn't seem to fix the bug completely. If cgroup_sk_alloc_disable happens after
> socket cloning, then we will deref the bpf of the root cgroup while incref-ed the bpf of a
> non-root cgroup.

Hm, so it seems that to disable the refcounting for the root cgroup's cgroup_bpf
is a good idea anyway, as it makes cgroup_bpf refcounting work similar to cgroup
refcounting. But it's not completely clear to me, if it's enough or do we have
something else to fix here?

Thanks!
