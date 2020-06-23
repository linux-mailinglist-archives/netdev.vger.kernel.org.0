Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04518206725
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 00:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387572AbgFWWXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 18:23:08 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:5088 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387466AbgFWWXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 18:23:07 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05NM18Gd021490;
        Tue, 23 Jun 2020 15:21:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=voStaJD5mI/2NA3BXEYYQHlOND//mMXnQQnBUr8kZnM=;
 b=n61Sn++i62nfLMIE+Am8T16ab9vWmEntmH8vfT3+tsXZDhpFmmXSwCE7ornvJQoy/lLR
 nfBarg05w2DwjGFtBCN70NFXroeN0lkRBTy9Alc77QKp6O1SoHnidz9HeKByxsD+kbpC
 aTXbGbgtTl9+lzJ4GJg456qHVg5q8CX64nA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31uk3cjhbn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 23 Jun 2020 15:21:58 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Jun 2020 15:21:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FGXF055wVfwvsqwelfDKiOuRUC/9cfFizViPt4ZVCu/HabgBrJYJNcShQOdYj0rMlUeeoJakVVeAxV4BYnZJLO8oWGMUBtPhyXnmEFHRPFxW3SuTBfGPoIsdhUZ5hYW15a9+I0nSbJqtHTgBT036ZSBopYhp72B2LMxwVtLt1cyMKcwceLH+lHN/RMyaWz1lJ8n4f1iAGmgEzvWQ1u2Nc8T58y4B0aTSJ7Otb7bupXNiAFxp5b6Sbmr+OigTOA6pdD4DaGjYw3nVBD6wjY8I4KBQe/haWvYzcE3HXKR6Xk2TKce3cnbagmYVB9DtnMqDHBSzRfMGziw5igX8ayapgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=voStaJD5mI/2NA3BXEYYQHlOND//mMXnQQnBUr8kZnM=;
 b=HiyNwJLclnRt6TjcZNxMUOd3Wm7jMTjnfl2VBABkdvzNwq9R7nzePydBBiGNugZGuDHFDI3C5xhRKxDhCdL6K1LsjSXZXSZ6og/s7V6K4LdlKV3ThTeBLQpZf2OoG4LLA8H/r5pQiMcXOg0Pg2xCQeIAS52QYigllGPTDLVTCPJscLgnCicLEDcGv2DyJVFI+4MOteP+OsTmdmHmNr06oZSgkOUvLeF4DoGqADzWfESfungR81mMWQpoQbEB85jCGwsxYm4+LAkG8yHzngzxGxL3PX6uC8CCWBLWLuMQkC14q7Vew2Ar1GGHphC5mMi4UU8UYsczZm2+ZVFmFTP6SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=voStaJD5mI/2NA3BXEYYQHlOND//mMXnQQnBUr8kZnM=;
 b=hNbkzdBF5LT7rG6p+NtyJkra4gMdL7c66UaHguD78i725qwAV8UUMxOIao7Jjce98005Gt/3dwUxKZEFn94Mn7XHw9Gn8T5Z5ZGGcRDj687UAkwhiEqsZlMhKVy/PzYoa++PPOLvQ9VPheyF8oKuQcWmkYlg9YJFMn7HiZyUziw=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB4141.namprd15.prod.outlook.com
 (2603:10b6:805:e3::14) by SN6PR15MB2352.namprd15.prod.outlook.com
 (2603:10b6:805:1c::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Tue, 23 Jun
 2020 22:21:42 +0000
Received: from SN6PR1501MB4141.namprd15.prod.outlook.com
 ([fe80::197f:d445:824d:1efa]) by SN6PR1501MB4141.namprd15.prod.outlook.com
 ([fe80::197f:d445:824d:1efa%6]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 22:21:42 +0000
Date:   Tue, 23 Jun 2020 15:21:37 -0700
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
Message-ID: <20200623222137.GA358561@carbon.lan>
References: <20200616180352.18602-1-xiyou.wangcong@gmail.com>
 <141629e1-55b5-34b1-b2ab-bab6b68f0671@huawei.com>
 <CAM_iQpUFFHPnMxS2sAHZqMUs80tTn0+C_jCcne4Ddx2b9omCxg@mail.gmail.com>
 <20200618193611.GE24694@carbon.DHCP.thefacebook.com>
 <CAM_iQpWuNnHqNHKz5FMgAXoqQ5qGDEtNbBKDXpmpeNSadCZ-1w@mail.gmail.com>
 <4f17229e-1843-5bfc-ea2f-67ebaa9056da@huawei.com>
 <CAM_iQpVKqFi00ohqPARxaDw2UN1m6CtjqsmBAP-pcK0GT2p_fQ@mail.gmail.com>
 <459be87d-0272-9ea9-839a-823b01e354b6@huawei.com>
 <35480172-c77e-fb67-7559-04576f375ea6@huawei.com>
 <CAM_iQpXpZd6ZaQyQifWOHSnqgAgdu1qP+fF_Na7rQ_H1vQ6eig@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAM_iQpXpZd6ZaQyQifWOHSnqgAgdu1qP+fF_Na7rQ_H1vQ6eig@mail.gmail.com>
X-ClientProxiedBy: BY5PR17CA0065.namprd17.prod.outlook.com
 (2603:10b6:a03:167::42) To SN6PR1501MB4141.namprd15.prod.outlook.com
 (2603:10b6:805:e3::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.lan (2620:10d:c090:400::5:19a7) by BY5PR17CA0065.namprd17.prod.outlook.com (2603:10b6:a03:167::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Tue, 23 Jun 2020 22:21:40 +0000
X-Originating-IP: [2620:10d:c090:400::5:19a7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc0cacca-ae22-4e68-41f2-08d817c3ce10
X-MS-TrafficTypeDiagnostic: SN6PR15MB2352:
X-Microsoft-Antispam-PRVS: <SN6PR15MB23528E3A035F857FADC23C2DBE940@SN6PR15MB2352.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 04433051BF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: atTRlFx+mWEfPQb1oFfGLjkhwn6gtlnNoSLkOZkCMkVx2F2rtptBenY7+8hJ87pPi9rbaRbtxcxbbKGgu3VPHWk4KiRv6uZA8H3yPnsnzbyJqBY25WBI0J6yLZUM8wyJhbi9i55wQpaZ1h56cg5yD2aWbfm4OGstZ0N46t7cR8kKzuVb/0ZdtFuCrMEFxlupDj9Z2LZSn9CYrMcuVrQCge+JEk2K6ICPMl8V81wBdYwt3RjnvqM8CzTiCbJvpQ+atnj9uHPhkeeaJvautAQGWvKl4RQgnlU6jNCrbIAPs/qQP3GyLmtTJwuTg4teBQCZ5bP5Do9Z4TRb1E1WCy+vIYo3YAU/kM1eXAaitEC0mzpgD7oMoqzLHPU/Mtvwm+YG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB4141.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(376002)(136003)(396003)(366004)(39860400002)(66476007)(5660300002)(8676002)(4326008)(316002)(478600001)(52116002)(53546011)(1076003)(6506007)(33656002)(7696005)(186003)(16526019)(54906003)(66946007)(8886007)(86362001)(6666004)(6916009)(55016002)(83380400001)(2906002)(8936002)(36756003)(9686003)(66556008)(27376004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 64/ruajHY3eDICzFsZeqIAgRErPz6MckegRBMT3kDIsqyhyU65qPO6LDWROyT6NyfJcX+Q0WG+KsFjWXCeI60mu615jggkmzRRZaPpA1XptbNHGWQ6N2GY36ydiH9osjimPayxhS5Mxl2ZXU541+LUOASccemfjvGzxNxN6w3VJdbNIZiyA16ij3Ls91vc9fRQqiNfbGwmoNCRrtAb6XJ9jaw0H7gKH2J7sX2ptT3Cxi/i4CczsZ/CbRr5PMaiNYySXZF6rAAXnAszkUB4HwI2PTJAxuXt++Zco3CrJHOzBV3zcuRF//BG3rKeJX4eYPOn9iKDjjUc3maI7fe6k2Cd3+EKUVp5g0qGLcTBhGuw1dzD+CpMk66SFSKAPFC25Psj61WlZGYku7Fa4zp6y04T510uaM3lDWqMnC4yjGDVtw7tToFBe1CovjP230O48gYwnSMXYvMBvM8xOWGjUNf3x6McbIkWEWu6Q+TA9hETjg6GVHfdPAUH2TWfmjAAS5nKiLH7UcVNdcEMbmc+Ml7w==
X-MS-Exchange-CrossTenant-Network-Message-Id: fc0cacca-ae22-4e68-41f2-08d817c3ce10
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2020 22:21:41.8597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ArFLD6h8LsSDlSSLM87DHPlIyU89poIinZNLbp56fW6eFYNjuhVOOqL2Y+467GPe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2352
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_14:2020-06-23,2020-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 impostorscore=0 suspectscore=5 phishscore=0 mlxlogscore=911
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 adultscore=0 spamscore=0
 malwarescore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006120000 definitions=main-2006230147
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 19, 2020 at 08:31:14PM -0700, Cong Wang wrote:
> On Fri, Jun 19, 2020 at 5:51 PM Zefan Li <lizefan@huawei.com> wrote:
> >
> > 在 2020/6/20 8:45, Zefan Li 写道:
> > > On 2020/6/20 3:51, Cong Wang wrote:
> > >> On Thu, Jun 18, 2020 at 11:40 PM Zefan Li <lizefan@huawei.com> wrote:
> > >>>
> > >>> On 2020/6/19 5:09, Cong Wang wrote:
> > >>>> On Thu, Jun 18, 2020 at 12:36 PM Roman Gushchin <guro@fb.com> wrote:
> > >>>>>
> > >>>>> On Thu, Jun 18, 2020 at 12:19:13PM -0700, Cong Wang wrote:
> > >>>>>> On Wed, Jun 17, 2020 at 6:44 PM Zefan Li <lizefan@huawei.com> wrote:
> > >>>>>>>
> > >>>>>>> Cc: Roman Gushchin <guro@fb.com>
> > >>>>>>>
> > >>>>>>> Thanks for fixing this.
> > >>>>>>>
> > >>>>>>> On 2020/6/17 2:03, Cong Wang wrote:
> > >>>>>>>> When we clone a socket in sk_clone_lock(), its sk_cgrp_data is
> > >>>>>>>> copied, so the cgroup refcnt must be taken too. And, unlike the
> > >>>>>>>> sk_alloc() path, sock_update_netprioidx() is not called here.
> > >>>>>>>> Therefore, it is safe and necessary to grab the cgroup refcnt
> > >>>>>>>> even when cgroup_sk_alloc is disabled.
> > >>>>>>>>
> > >>>>>>>> sk_clone_lock() is in BH context anyway, the in_interrupt()
> > >>>>>>>> would terminate this function if called there. And for sk_alloc()
> > >>>>>>>> skcd->val is always zero. So it's safe to factor out the code
> > >>>>>>>> to make it more readable.
> > >>>>>>>>
> > >>>>>>>> Fixes: 090e28b229af92dc5b ("netprio_cgroup: Fix unlimited memory leak of v2 cgroups")
> > >>>>>>>
> > >>>>>>> but I don't think the bug was introduced by this commit, because there
> > >>>>>>> are already calls to cgroup_sk_alloc_disable() in write_priomap() and
> > >>>>>>> write_classid(), which can be triggered by writing to ifpriomap or
> > >>>>>>> classid in cgroupfs. This commit just made it much easier to happen
> > >>>>>>> with systemd invovled.
> > >>>>>>>
> > >>>>>>> I think it's 4bfc0bb2c60e2f4c ("bpf: decouple the lifetime of cgroup_bpf from cgroup itself"),
> > >>>>>>> which added cgroup_bpf_get() in cgroup_sk_alloc().
> > >>>>>>
> > >>>>>> Good point.
> > >>>>>>
> > >>>>>> I take a deeper look, it looks like commit d979a39d7242e06
> > >>>>>> is the one to blame, because it is the first commit that began to
> > >>>>>> hold cgroup refcnt in cgroup_sk_alloc().
> > >>>>>
> > >>>>> I agree, ut seems that the issue is not related to bpf and probably
> > >>>>> can be reproduced without CONFIG_CGROUP_BPF. d979a39d7242e06 indeed
> > >>>>> seems closer to the origin.
> > >>>>
> > >>>> Yeah, I will update the Fixes tag and send V2.
> > >>>>
> > >>>
> > >>> Commit d979a39d7242e06 looks innocent to me. With this commit when cgroup_sk_alloc
> > >>> is disabled and then a socket is cloned the cgroup refcnt will not be incremented,
> > >>> but this is fine, because when the socket is to be freed:
> > >>>
> > >>>  sk_prot_free()
> > >>>    cgroup_sk_free()
> > >>>      cgroup_put(sock_cgroup_ptr(skcd)) == cgroup_put(&cgrp_dfl_root.cgrp)
> > >>>
> > >>> cgroup_put() does nothing for the default root cgroup, so nothing bad will happen.
> > >>
> > >> But skcd->val can be a pointer to a non-root cgroup:
> > >
> > > It returns a non-root cgroup when cgroup_sk_alloc is not disabled. The bug happens
> > > when cgroup_sk_alloc is disabled.
> > >
> >
> > And please read those recent bug reports, they all happened when bpf cgroup was in use,
> > and there was no bpf cgroup when d979a39d7242e06 was merged into mainline.
> 
> I am totally aware of this. My concern is whether cgroup
> has the same refcnt bug as it always pairs with the bpf refcnt.
> 
> But, after a second look, the non-root cgroup refcnt is immediately
> overwritten by sock_update_classid() or sock_update_netprioidx(),
> which effectively turns into a root cgroup again. :-/
> 
> (It seems we leak a refcnt here, but this is not related to my patch).

Yeah, I looked over this code, and I have the same suspicion.
Especially in sk_alloc(), where cgroup_sk_alloc() is followed by
sock_update_classid() and sock_update_netprioidx().

I also think your original patch is good, but there are probably
some other problems which it doesn't fix.

I looked over cgroup bpf code again, and the only difference with cgroup
refcounting I see (behind the root cgroup, which is a non-issue) is
here:

void cgroup_sk_alloc(struct sock_cgroup_data *skcd)
{
	...
	while (true) {
		struct css_set *cset;

		cset = task_css_set(current);
		if (likely(cgroup_tryget(cset->dfl_cgrp))) {
			  ^^^^^^^^^^^^^^^
			skcd->val = (unsigned long)cset->dfl_cgrp;
			cgroup_bpf_get(cset->dfl_cgrp);
			^^^^^^^^^^^^^^
			break;
			...

So, in theory, cgroup_bpf_get() can be called here after cgroup_bpf_release().
We might wanna introduce something like cgroup_bpf_tryget_live().
Idk if it can happen in reality, because it would require opening a new socket
in a deleted cgroup (without any other associated sockets).

Other than that I don't see any differences between cgroup and cgroup bpf
reference counting.

Thanks!

PS I'll be completely offline till the end of the week. I'll answer all
e-mails on Monday (Jun 29th).
