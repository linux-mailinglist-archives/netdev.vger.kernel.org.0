Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F21DD1FFD5F
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 23:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728538AbgFRV1k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 17:27:40 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38186 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725987AbgFRV1h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 17:27:37 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05ILEQYg013669;
        Thu, 18 Jun 2020 14:26:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=qNv40tOvcynqd1Xj5yeAErqFKfazs3ElWx/Nl9Yw938=;
 b=KjIAw7C6fcUEQVoUmSL3zvscG4ye2br9FPBgHX+Mwe4hsws6s5Vy+3tA013VGudDtoH2
 QYb8wGI7/t3C2TokwBYKrht2Evi/m12CHaM1JKEjlhkXnYaaTJeyL8KYEZ9dSAR5UJWr
 W7KhmALNSEz08QoVaJEpfvAQofHGrCA16ys= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31q64exe39-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 18 Jun 2020 14:26:23 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 18 Jun 2020 14:26:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IvRp3sloXfMaVzCY8oDy2/zbUGy65bkUK94wketuJ0gsmHEBN5qlELVhVq81KWLXh41k4uEbEUdaJZdVZlpFDMPSJGrf9pXCqy2ql8GGrkWX+0DnYqlVDi3/C6CGq2/ikrmStTcXN4OYBbcDT8vgJ8QFaw2UE3eWkFjTrlEWxOc789ui93SADZBsY31oy3/XvtKX5hyHXRhHB0SDj7ysGJdX1iMCcMSfW34GMJBnEInm0Fi3aHaElpbmrnDHzyTAegqu3mx1W705q9pbPzSMRe6+KLkJDU+gKQNhCiNWA32hqpPVQLFjc1ebTIoR90PJUesi8XYw+UWCJpUsYj6jlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qNv40tOvcynqd1Xj5yeAErqFKfazs3ElWx/Nl9Yw938=;
 b=njvRBBtaFVfgiU+MvbU2x2Xn/j8LX08LOuzbu/PwixwIu+iTNnaAHA0kazasfx/X1nf7aNUnYJ7xJTbmYVEHCC8DVeETeYLbpfTCRE5N0GFDMs5vDgYmUVj9UI9sYIiUNEaLmLCX3WWLtUe2zZ104nsEqZ0w47zpigKKZKaxnA8TMv8bH2/5Fp+tPYLzyjoVTgBIzHp/FlrpQzwsiHL6rc9F0htPTYBMkmwNE8qm9SgpHCy2vaYBVEc2tGxnAtUFFRMzQsUiIcNmAr54skhbLvK4aS0Nx4iLBeBECXB2tF3o3cOBxR/xeZUdz7G4tRq+8+d0Y5nkynUDKL/1ubsqhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qNv40tOvcynqd1Xj5yeAErqFKfazs3ElWx/Nl9Yw938=;
 b=TmIcGTGAkuQ49hHUrwtxkDdcb4JD6Io8McZtpPP4Q+u1uw8YIC4AXjZD+ywiNXIRUZMfXc/BB3AzoWuLOYrCI+dzU08nTZvUkp/Yf3FpzW79cugLx7Q9sW55V1kXkT8Qa7t5Er2VWysrOZnBEfy6+YCpjbgPSOw5VEAFTb2K93A=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB3446.namprd15.prod.outlook.com (2603:10b6:a03:109::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Thu, 18 Jun
 2020 21:26:19 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::48e3:c159:703d:a2f1]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::48e3:c159:703d:a2f1%5]) with mapi id 15.20.3109.021; Thu, 18 Jun 2020
 21:26:19 +0000
Date:   Thu, 18 Jun 2020 14:26:15 -0700
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
Message-ID: <20200618212615.GG110603@carbon.dhcp.thefacebook.com>
References: <20200616180352.18602-1-xiyou.wangcong@gmail.com>
 <141629e1-55b5-34b1-b2ab-bab6b68f0671@huawei.com>
 <CAM_iQpUFFHPnMxS2sAHZqMUs80tTn0+C_jCcne4Ddx2b9omCxg@mail.gmail.com>
 <20200618193611.GE24694@carbon.DHCP.thefacebook.com>
 <CAM_iQpWuNnHqNHKz5FMgAXoqQ5qGDEtNbBKDXpmpeNSadCZ-1w@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpWuNnHqNHKz5FMgAXoqQ5qGDEtNbBKDXpmpeNSadCZ-1w@mail.gmail.com>
X-ClientProxiedBy: SN4PR0501CA0126.namprd05.prod.outlook.com
 (2603:10b6:803:42::43) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:400::5:32ff) by SN4PR0501CA0126.namprd05.prod.outlook.com (2603:10b6:803:42::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.12 via Frontend Transport; Thu, 18 Jun 2020 21:26:18 +0000
X-Originating-IP: [2620:10d:c090:400::5:32ff]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c0ac8c4b-4c30-4031-47ef-08d813ce3def
X-MS-TrafficTypeDiagnostic: BYAPR15MB3446:
X-Microsoft-Antispam-PRVS: <BYAPR15MB3446DF9F05ACC334CCF8F43BBE9B0@BYAPR15MB3446.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0438F90F17
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d/+gfTAYj6CuVHTHINzxFDrJ9faG0QtH106rbCXdj5vMNuu1YOoGyQ4yaYcEL+Wxc8XrlXRcDetIuMvqbDDYTwVvsi2+XeR9Sb4dHDgdD70RrvFMGGnnU+pvSN7ephF8fntBR5ZQtn5it0pj36G6trj17zEejJkFPttZX1PGOXPuwiV5MBkESPO9bTnson7BrBkSwjo83DkZ8pR3WOMaOik/zMr/jnMNHkbWvgEGQu9BAGQWS3WOZ92Z4tvczJXa+u5i4z8tEqqVXHRSAZZCy19cUVTylqKjca9AHqUKi0mG5K93n2H4j0YNZEwuXiT075S2WHPxVMWeKTjgYaGKmg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(346002)(396003)(136003)(376002)(39860400002)(66476007)(66556008)(66946007)(54906003)(478600001)(1076003)(9686003)(316002)(6666004)(55016002)(6506007)(53546011)(4326008)(86362001)(186003)(8936002)(5660300002)(2906002)(6916009)(83380400001)(16526019)(7696005)(8676002)(52116002)(33656002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: r3v5K5Y4iAgi9VVNmU6Pd4eXN1cuenDc/gm0ZjTs+yF73+t61TMTv1LgT8dET+lIhI12R4L2qzU+Rhu98gjukLEQTp+zxnft8qIKXYIdZZayL2yIFveXbtb63B4V1nSOI1665tGrqsPke5nzqiT69Su6fLQpzDeBhxLO96Z4YaakaSuB9u5wnu+IhWPtDmz1DxXrLR24agn3zxl6sf3YyIxBGhRqecHtJ2BCPj5fSdKAeSS3HvjJpVLyKm4a0UfdZthW2l5/wowwqB3TEqN1tAsuzXTstjPPcu6quCTSVUbYIKkuqV1Ze04WVT6wyD5fpoZSLr5PkqT2WcCBPSbYeza2rJcRuEgQK4nYpOea5lkaQ7YI9xmS+4qDmjNEMC9r8ab1PsWUliQmo6R5y6PHwEAQUrCZGJxJgNM0QwFzJOieHt2Y51jKP0ZAEW2nlAysS2zJJAFnABa2tL8Vap7koJ5mkmZxg2ewk9XpoNVxA1WtUiGIJX8J/3k3hmM6ydYo1EGwK0967TsxXk4w7v++VQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: c0ac8c4b-4c30-4031-47ef-08d813ce3def
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2020 21:26:19.8303
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GrZZejD970spL8RQ9UhDnr05mLm2sVk7RTq8Z9Q3/pNNv3NuFWvhnuwrlYWH8rfe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3446
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-18_21:2020-06-18,2020-06-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 cotscore=-2147483648 lowpriorityscore=0 mlxscore=0
 spamscore=0 bulkscore=0 suspectscore=1 adultscore=0 phishscore=0
 mlxlogscore=784 clxscore=1015 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006180163
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 02:09:43PM -0700, Cong Wang wrote:
> On Thu, Jun 18, 2020 at 12:36 PM Roman Gushchin <guro@fb.com> wrote:
> >
> > On Thu, Jun 18, 2020 at 12:19:13PM -0700, Cong Wang wrote:
> > > On Wed, Jun 17, 2020 at 6:44 PM Zefan Li <lizefan@huawei.com> wrote:
> > > >
> > > > Cc: Roman Gushchin <guro@fb.com>
> > > >
> > > > Thanks for fixing this.
> > > >
> > > > On 2020/6/17 2:03, Cong Wang wrote:
> > > > > When we clone a socket in sk_clone_lock(), its sk_cgrp_data is
> > > > > copied, so the cgroup refcnt must be taken too. And, unlike the
> > > > > sk_alloc() path, sock_update_netprioidx() is not called here.
> > > > > Therefore, it is safe and necessary to grab the cgroup refcnt
> > > > > even when cgroup_sk_alloc is disabled.
> > > > >
> > > > > sk_clone_lock() is in BH context anyway, the in_interrupt()
> > > > > would terminate this function if called there. And for sk_alloc()
> > > > > skcd->val is always zero. So it's safe to factor out the code
> > > > > to make it more readable.
> > > > >
> > > > > Fixes: 090e28b229af92dc5b ("netprio_cgroup: Fix unlimited memory leak of v2 cgroups")
> > > >
> > > > but I don't think the bug was introduced by this commit, because there
> > > > are already calls to cgroup_sk_alloc_disable() in write_priomap() and
> > > > write_classid(), which can be triggered by writing to ifpriomap or
> > > > classid in cgroupfs. This commit just made it much easier to happen
> > > > with systemd invovled.
> > > >
> > > > I think it's 4bfc0bb2c60e2f4c ("bpf: decouple the lifetime of cgroup_bpf from cgroup itself"),
> > > > which added cgroup_bpf_get() in cgroup_sk_alloc().
> > >
> > > Good point.
> > >
> > > I take a deeper look, it looks like commit d979a39d7242e06
> > > is the one to blame, because it is the first commit that began to
> > > hold cgroup refcnt in cgroup_sk_alloc().
> >
> > I agree, ut seems that the issue is not related to bpf and probably
> > can be reproduced without CONFIG_CGROUP_BPF. d979a39d7242e06 indeed
> > seems closer to the origin.
> 
> Yeah, I will update the Fixes tag and send V2.
> 
> >
> > Btw, based on the number of reported-by tags it seems that there was
> > a real issue which the patch is fixing. Maybe you'll a couple of words
> > about how it reveals itself in the real life?
> 
> I still have no idea how exactly this is triggered. According to the
> people who reported this bug, they just need to wait for some hours
> to trigger. So I am not sure what to add here, just the stack trace?

Yeah, stack trace is definitely useful. So at least if someone will encounter the same
error in the future, they can search for the stacktrace and find the fix.

Thanks!
