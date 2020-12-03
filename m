Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 433732CE1FE
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 23:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387474AbgLCWnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 17:43:18 -0500
Received: from mx0a-000eb902.pphosted.com ([205.220.165.212]:55100 "EHLO
        mx0a-000eb902.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727533AbgLCWnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 17:43:18 -0500
Received: from pps.filterd (m0220296.ppops.net [127.0.0.1])
        by mx0a-000eb902.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B3MgRxO018524;
        Thu, 3 Dec 2020 16:42:27 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garmin.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pps1;
 bh=DC3UTyPP0ViP3u3aLxZLPIJhh9mOs9SoDB0LomURYtk=;
 b=xPjav+/+1U/Pw+eIHKLBe6lkadCpAmQDaCCYnPWHlsUPwHtckXEKEkqFzyFkmLPsjnoN
 frR/cqpif8oE9qQKd4lK6pLvRCMUzQyF37EyucSHUJ/hEXeGFHT+RKx8vznXAFYXWe6l
 2gRCI/cuwzelMPR+S853QQkcs+MxH09F0MW/NX9eMR2VhUiepYzfJ3ToYEZwYH5sx9HH
 VFEfXririzGU7f1sstpxfvzPMDy8GxnkGzemL9tbBfh4OaX+n6x65JbpWqgBOAJRYbQl
 aikJoZA/MngUpkZ9hSYwh4AX1FDkd0IwAxNApFvBUoc4Y8qJBFnkNElHAamDJUG7owvQ 2Q== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by mx0a-000eb902.pphosted.com with ESMTP id 355wbubdgc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Dec 2020 16:42:27 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J9AQr/x3ao2Uvk43WxsSL8C27W32Q7fls74drpu8jKpCi9f52GM3Ah9CLwEILrR4LnmORENvzyDAxLAPD10y0JUiEdIAKdcx9uEc7Q5tTUZBeXq+J/S8rT2E946cpVGKe48mdb9+JAIe6OIW6Zpt3HMeNrDASs1EcQxv4UXfXCJAL5jBLYmvnH8aspLrZJIuOXvm8PL7KyZsF9ZjgErtlI+v+Gnbmz6r22Bos9m9hkf1Kiz93Y7HG7fYO3586zEs+2vbrgktnMrGXWsUO9n/aW1i7QSEp/2vJ8BdweKFeCl14+TApAnwr+6gA//1wgrkEO9zLJMtAZZp98pcsCO8ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DC3UTyPP0ViP3u3aLxZLPIJhh9mOs9SoDB0LomURYtk=;
 b=WhqaGy66VNK0RKBMs5/MKHo4kRF+YOvzbQsrFsKQI8EP0btmL8Cb7bQg2OkuF9c+xMyvAM/RGfzO4o23D/sePS3ugo1LhK4X3BS/MzgFC2ohBYY880QOSXW//8aBHGyY+j0KwubJ823sXp2qHD/aj/sBbNuEMrl+J07udl+B5xzvzipq1GdMZy3II4sr7vYjKJ+lsBQh2ZI2C8fzklUbVlas1kWDzlMeczgkn3akffjfn4Sz7cyWtzYp0o+Rm6QHEKYNdF9H9Pw3scNfucx5l51wNLCBo7p+Kp+o4zbkhxSpFHHCrtAWrlEpFwmpHPhSVFbSRyvduUXyrPnm2e31PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 204.77.163.244) smtp.rcpttodomain=nvidia.com smtp.mailfrom=garmin.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=garmin.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=garmin.onmicrosoft.com; s=selector1-garmin-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DC3UTyPP0ViP3u3aLxZLPIJhh9mOs9SoDB0LomURYtk=;
 b=no17NnzxDiKwKNwejmr7Ef1gmoNYjhVCu41nKUTcxSsgrZTB8hHz/bDs3Sxd/qfj0Tb6TZNwr+jlTkofJuo9qFLjqzmBioC6jdxHzFaVQ3PM8RPcOigz6T8bdkPw69an1aP7ezOpgmz5/zgcKlgnZb1GZrw+Ryx4g0RoSKJNGC9D62UGIGzk42bekUFDg3yPgTnRTZmFy6pNAPvsvg63EKWloNuP2ciZZ5esVX4pQtZyvbeIrYHi8SSp1C7mt3tXWurszZ6HgjOOE/m7IXkdPmPg43HNDAaaMGMTIvfCfJnUFX8oQ3V0oRBQT7f6+52xWl5taMzDRCL0OWGDCp3lyw==
Received: from DM6PR04CA0026.namprd04.prod.outlook.com (2603:10b6:5:334::31)
 by BYAPR04MB3829.namprd04.prod.outlook.com (2603:10b6:a02:ab::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Thu, 3 Dec
 2020 22:42:23 +0000
Received: from DM6NAM10FT064.eop-nam10.prod.protection.outlook.com
 (2603:10b6:5:334:cafe::3) by DM6PR04CA0026.outlook.office365.com
 (2603:10b6:5:334::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend
 Transport; Thu, 3 Dec 2020 22:42:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 204.77.163.244)
 smtp.mailfrom=garmin.com; nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=pass action=none header.from=garmin.com;
Received-SPF: Pass (protection.outlook.com: domain of garmin.com designates
 204.77.163.244 as permitted sender) receiver=protection.outlook.com;
 client-ip=204.77.163.244; helo=edgetransport.garmin.com;
Received: from edgetransport.garmin.com (204.77.163.244) by
 DM6NAM10FT064.mail.protection.outlook.com (10.13.152.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3632.20 via Frontend Transport; Thu, 3 Dec 2020 22:42:22 +0000
Received: from OLAWPA-EXMB3.ad.garmin.com (10.5.144.15) by
 olawpa-edge5.garmin.com (10.60.4.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2106.2; Thu, 3 Dec 2020 16:42:20 -0600
Received: from OLAWPA-EXMB4.ad.garmin.com (10.5.144.25) by
 OLAWPA-EXMB3.ad.garmin.com (10.5.144.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Thu, 3 Dec 2020 16:42:21 -0600
Received: from OLAWPA-EXMB4.ad.garmin.com ([fe80::d9c:e89c:1ef1:23c]) by
 OLAWPA-EXMB4.ad.garmin.com ([fe80::d9c:e89c:1ef1:23c%23]) with mapi id
 15.01.2106.004; Thu, 3 Dec 2020 16:42:21 -0600
From:   "Huang, Joseph" <Joseph.Huang@garmin.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Roopa Prabhu <roopa@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?iso-8859-1?Q?Linus_L=FCssing?= <linus.luessing@c0d3.blue>
Subject: Re: [PATCH] bridge: Fix a deadlock when enabling multicast snooping
Thread-Topic: [PATCH] bridge: Fix a deadlock when enabling multicast snooping
Thread-Index: AQHWyCqujj1Ju82dikKTtbTkT254GqnmGFEAgAAm0ID//52IEIAAGyyW
Date:   Thu, 3 Dec 2020 22:42:21 +0000
Message-ID: <2b96b845990e4a84a3b3fd46f4138ac6@garmin.com>
References: <20201201214047.128948-1-Joseph.Huang@garmin.com>
 <20201203102802.62bc86ba@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <bd84ca4c-c694-6fd2-81ef-08e9253c18a4@nvidia.com>,<c82ce96d74ed4d3897d2e68a258f7834@garmin.com>
In-Reply-To: <c82ce96d74ed4d3897d2e68a258f7834@garmin.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.50.4.7]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f79d4eaf-ce16-45c0-2f97-08d897dcb315
X-MS-TrafficTypeDiagnostic: BYAPR04MB3829:
X-Microsoft-Antispam-PRVS: <BYAPR04MB38291E1D6660BED8E8827EBCFBF20@BYAPR04MB3829.namprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YbxWTX7XGOcj31xC6EIiXzf9Z9pza+hiPq21vhpmWgwPSep9SGlxsWzRFj7ETNfFzQsgTq0RSsnoj0Jqt7Zoo2eaEiI5hOVZx31mFlM6d1cLINQ2u9csHbZMuNl9/39pHJbJFgZKPQ7rOY30+3lRtOfcgvYRpYlUof646Bxzj46yxV9M7R1PVtOBQp+NXgdgLdGtVBUScNsWvW2yBtFAJLPWxSkcOblHlyakfOBj2iy/NMqEdiCm6EasqcSveYIEkgIS9BP3r6AwkKc1QOsvUpxnlV3g43iFcYF/d8kDPNf++cv6TYBy9IBIJ2k7zPuQ28uhO1PhHhBO3LL1Lm/7txlhj9VZVkRnz/Qon6FuXxV3pE+iXFYJdZZQk70fY8NSMiH72hEbcd+AV4RYNtpdQA==
X-Forefront-Antispam-Report: CIP:204.77.163.244;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:edgetransport.garmin.com;PTR:extedge.garmin.com;CAT:NONE;SFS:(39860400002)(136003)(376002)(346002)(396003)(46966005)(186003)(8676002)(7696005)(8936002)(5660300002)(53546011)(2616005)(108616005)(24736004)(336012)(86362001)(426003)(316002)(110136005)(54906003)(2906002)(47076004)(478600001)(36756003)(7636003)(26005)(83380400001)(4326008)(70206006)(82740400003)(356005)(70586007)(66574015)(82310400003);DIR:OUT;SFP:1102;
X-OriginatorOrg: garmin.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2020 22:42:22.5015
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f79d4eaf-ce16-45c0-2f97-08d897dcb315
X-MS-Exchange-CrossTenant-Id: 38d0d425-ba52-4c0a-a03e-2a65c8e82e2d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38d0d425-ba52-4c0a-a03e-2a65c8e82e2d;Ip=[204.77.163.244];Helo=[edgetransport.garmin.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM10FT064.eop-nam10.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB3829
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-03_15:2020-12-03,2020-12-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 spamscore=0 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012030126
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Huang, Joseph
> Sent: Thursday, December 3, 2020 4:53 PM
> To: Nikolay Aleksandrov <nikolay@nvidia.com>; Jakub Kicinski
> <kuba@kernel.org>
> Cc: Roopa Prabhu <roopa@nvidia.com>; David S. Miller
> <davem@davemloft.net>; bridge@lists.linux-foundation.org;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Linus L=FCssing
> <linus.luessing@c0d3.blue>
> Subject: RE: [PATCH] bridge: Fix a deadlock when enabling multicast snoop=
ing
>
> > From: Nikolay Aleksandrov <nikolay@nvidia.com>
> > Sent: Thursday, December 3, 2020 3:47 PM
> > To: Jakub Kicinski <kuba@kernel.org>; Huang, Joseph
> > <Joseph.Huang@garmin.com>
> > Cc: Roopa Prabhu <roopa@nvidia.com>; David S. Miller
> > <davem@davemloft.net>; bridge@lists.linux-foundation.org;
> > netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Linus L=FCssing
> > <linus.luessing@c0d3.blue>
> > Subject: Re: [PATCH] bridge: Fix a deadlock when enabling multicast
> > snooping
> >
> > On 03/12/2020 20:28, Jakub Kicinski wrote:
> > > On Tue, 1 Dec 2020 16:40:47 -0500 Joseph Huang wrote:
> > >> When enabling multicast snooping, bridge module deadlocks on
> > >> multicast_lock if 1) IPv6 is enabled, and 2) there is an existing
> > >> querier on the same L2 network.
> > >>
> > >> The deadlock was caused by the following sequence: While holding the
> > >> lock, br_multicast_open calls br_multicast_join_snoopers, which
> > >> eventually causes IP stack to (attempt to) send out a Listener Repor=
t (in
> > igmp6_join_group).
> > >> Since the destination Ethernet address is a multicast address,
> > >> br_dev_xmit feeds the packet back to the bridge via br_multicast_rcv=
,
> > >> which in turn calls br_multicast_add_group, which then deadlocks on
> > multicast_lock.
> > >>
> > >> The fix is to move the call br_multicast_join_snoopers outside of th=
e
> > >> critical section. This works since br_multicast_join_snoopers only
> > >> deals with IP and does not modify any multicast data structures of
> > >> the bridge, so there's no need to hold the lock.
> > >>
> > >> Fixes: 4effd28c1245 ("bridge: join all-snoopers multicast address")
> > >>
> > >> Signed-off-by: Joseph Huang <Joseph.Huang@garmin.com>
> > >
> > > Nik, Linus - how does this one look?
> > >
> >
> > Hi,
> > Thanks, somehow I missed this one too. Need to check my email config. :=
) I
> > believe I see how it can happen, although it's not straight-forward to =
follow.
> > A selftest for this case would be great, and any traces (e.g. hung task=
)
> would
> > help a lot as well.
> > Correct me if I'm wrong but the sequence is something like:
> > br_multicast_join_snoopers -> ipv6_dev_mc_inc -> __ipv6_dev_mc_inc ->
> > igmp6_group_added
> > -> MLDv1 (mode) igmp6_join_group() -> Again MLDv1 mode
> > -> igmp6_join_group() -> igmp6_join_group
> > -> igmp6_send() on the bridge device -> br_dev_xmit and onto the bridge
> > -> mcast processing code
> > which uses the multicast_lock spinlock. Right?
>
> That is correct.
>
> Here's a stack trace from a typical run:
>
> echo -n 1 > /sys/devices/virtual/net/gmn0/bridge/multicast_snooping
> [  936.146754] rcu: INFO: rcu_preempt self-detected stall on CPU
> [  936.152534] rcu:   0-....: (5594 ticks this GP)
> idle=3D75a/1/0x4000000000000002 softirq=3D2787/2789 fqs=3D2625
> [  936.162026]        (t=3D5253 jiffies g=3D4205 q=3D12)
> [  936.166041] Task dump for CPU 0:
> [  936.169272] sh              R  running task        0  1315   1295 0x00=
000002
> [  936.176332] Call trace:
> [  936.178797]  dump_backtrace+0x0/0x140
> [  936.182469]  show_stack+0x14/0x20
> [  936.185793]  sched_show_task+0x108/0x138
> [  936.189727]  dump_cpu_task+0x40/0x50
> [  936.193313]  rcu_dump_cpu_stacks+0x94/0xd0
> [  936.197420]  rcu_sched_clock_irq+0x75c/0x9c0
> [  936.201698]  update_process_times+0x2c/0x68
> [  936.205893]  tick_sched_handle.isra.0+0x30/0x50
> [  936.210432]  tick_sched_timer+0x48/0x98
> [  936.214272]  __hrtimer_run_queues+0x110/0x1b0
> [  936.218635]  hrtimer_interrupt+0xe4/0x240
> [  936.222656]  arch_timer_handler_phys+0x30/0x40
> [  936.227106]  handle_percpu_devid_irq+0x80/0x140
> [  936.231654]  generic_handle_irq+0x24/0x38
> [  936.235669]  __handle_domain_irq+0x60/0xb8
> [  936.239774]  gic_handle_irq+0x5c/0x148
> [  936.243535]  el1_irq+0xb8/0x180
> [  936.246689]  queued_spin_lock_slowpath+0x118/0x3b0
> [  936.251495]  _raw_spin_lock+0x5c/0x68
> [  936.255221]  br_multicast_add_group+0x40/0x170 [bridge]
> [  936.260491]  br_multicast_rcv+0x7ac/0xe30 [bridge]
> [  936.265322]  br_dev_xmit+0x140/0x368 [bridge]
> [  936.269689]  dev_hard_start_xmit+0x94/0x158
> [  936.273876]  __dev_queue_xmit+0x5ac/0x7f8
> [  936.277890]  dev_queue_xmit+0x10/0x18
> [  936.281563]  neigh_resolve_output+0xec/0x198
> [  936.285845]  ip6_finish_output2+0x240/0x710
> [  936.290039]  __ip6_finish_output+0x130/0x170
> [  936.294318]  ip6_output+0x6c/0x1c8
> [  936.297731]  NF_HOOK.constprop.0+0xd8/0xe8
> [  936.301834]  igmp6_send+0x358/0x558
> [  936.305326]  igmp6_join_group.part.0+0x30/0xf0
> [  936.309774]  igmp6_group_added+0xfc/0x110
> [  936.313787]  __ipv6_dev_mc_inc+0x1a4/0x290
> [  936.317885]  ipv6_dev_mc_inc+0x10/0x18
> [  936.321677]  br_multicast_open+0xbc/0x110 [bridge]
> [  936.326506]  br_multicast_toggle+0xec/0x140 [bridge]
>
>
> >
> > One question - shouldn't leaving have the same problem? I.e.
> > br_multicast_toggle -> br_multicast_leave_snoopers
> > -> br_ip6_multicast_leave_snoopers -> ipv6_dev_mc_dec ->
> > -> igmp6_group_dropped -> igmp6_leave_group ->
> > MLDv1 mode && last reporter -> igmp6_send() ?
> >
> > I think it was saved by the fact that !br_opt_get(br,
> > BROPT_MULTICAST_ENABLED) would be true and the multicast lock won't
> be
> > acquired in the br_dev_xmit path? If so, I'd appreciate a comment about
> that
> > because it's not really trivial to find out. :)
>
> That's a really good point. Leave should have deadlocked as well, but whe=
n I
> tested the patch, I was able to turn on/off multicast snooping multiple t=
imes
> without any problem.
>
> Is it because this line in igmp6_leave_group?
>
>               if (ma->mca_flags & MAF_LAST_REPORTER)
>                       igmp6_send(&ma->mca_addr, ma->idev->dev,
>                               ICMPV6_MGM_REDUCTION);
>
> Perhaps MAF_LAST_REPORTER was not set, so igmp6_send was not called?
>
> >
> > Anyhow, the patch is fine as-is too:
> > Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
> >
> > Thanks,
> >  Nik
>
> Thanks,
> Joseph

Would it be advisable if we move br_multicast_leave_snoopers out of the cri=
tical
section as well? Even though I can't really verify that if this is helpful =
since I haven't
seen it deadlock when disabling multicast snooping.

Thanks,
Joseph

________________________________

CONFIDENTIALITY NOTICE: This email and any attachments are for the sole use=
 of the intended recipient(s) and contain information that may be Garmin co=
nfidential and/or Garmin legally privileged. If you have received this emai=
l in error, please notify the sender by reply email and delete the message.=
 Any disclosure, copying, distribution or use of this communication (includ=
ing attachments) by someone other than the intended recipient is prohibited=
. Thank you.
