Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 846D01A87B5
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 19:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730242AbgDNRjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 13:39:18 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:59820 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730099AbgDNRjO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 13:39:14 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03EHC3SR002725;
        Tue, 14 Apr 2020 10:36:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=3N1cqzsBumrqcRDuJ92B73koJlzslbv9EfHYBIuGwrE=;
 b=C8pZKHf/7DGYrKSQ6OIFGWq4sfa8UFs0FdJnYw7nRZ4ADLH47AlHV2XB02VrhYqw8IOP
 O1B8TIqGBOgpPQtwoXUX3hCgMVR6Chjdddcz7SiwbqiuePPCAedvMUWLDJDWOQAS3Ojh
 YcLFJkmrTDenXSpqA4rSAnm41PnwdSCP5cU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30bwtebb6k-16
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 14 Apr 2020 10:36:43 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 14 Apr 2020 10:24:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ITmToEsQjEezhxYJJ1HTSTO3P46eyjEjaYFnyKxWvr7wP87Nstl3Z6xFR2z9rgugDdrm4dewYfKtWMURHrUfKN4N2fOsc67pasB3bhmmpM3EaoEwYf4GNvwEHfhBiZnBWSUtp1UY46xgq3aOstTt3KGsqe5ckfRHoXsXu51YMuLipDAKkLi378tJnxTQQftdRGAPVinzdAzJwp9YIvuPMEZp95FMAvsZzQDu82/ujle0vKJ1pg/oPmtWbJwEqlSfM3QO62NhYrggdXVx8LrpHRrUbmQeUcs5ha9hLUgbEIUQcZRjKZ8xLqn6D4ibjJlkq6RZRlyJntWCQpc+7LpTwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3N1cqzsBumrqcRDuJ92B73koJlzslbv9EfHYBIuGwrE=;
 b=Wqxo6I3wIs8ukjXnkBo1eTZHFBW8bhS/qNxbRpXtdRHPrnFenv1JfoixJIzZYhOlwP2iTvQekQnIfUvG1BGwHvQ2I0bMjXv6PalllRrikJgo7A89dM/stuVuSUJTJU+MWmshVAvP2lIm085zre9O43+BrTdabuJiF8qYKQWjeqb2lbOt5R1HMRddSI34hx0jufeX8FeOsUfm3uJCAKSB506c/+jrimzdrU1lIDBd5woTGFdRmJTxAKans1fw9Me28cIfYjCeuZZJW7pxjD99LD+xpYuSRqCX9vX/pYBP/rgpZ1NvTlWA419cnRUIA6TkawQJi5V9Nvz1rXO/NnKQIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3N1cqzsBumrqcRDuJ92B73koJlzslbv9EfHYBIuGwrE=;
 b=Luil+NdIyDh8ysTMARfyOWy2xWots3ZUzDPsBP41icJ7ey7jm0zt+8zKocdpTleV4UgoeHQE4qyBgJtP/jyHsU552oIrplA4IFRoAMXMhocC+Yi8OP6nSoJ6nvJknAu2ePlHmxWPSnytRMYo3tn6PDgJFhixzHaP96VYCROrEoA=
Received: from BYAPR15MB4119.namprd15.prod.outlook.com (2603:10b6:a02:cd::20)
 by BYAPR15MB2327.namprd15.prod.outlook.com (2603:10b6:a02:8e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15; Tue, 14 Apr
 2020 17:24:12 +0000
Received: from BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::90d6:ec75:fde:e992]) by BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::90d6:ec75:fde:e992%7]) with mapi id 15.20.2900.028; Tue, 14 Apr 2020
 17:24:12 +0000
Date:   Tue, 14 Apr 2020 10:24:09 -0700
From:   Andrey Ignatov <rdna@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] libbpf: always specify expected_attach_type on
 program load if supported
Message-ID: <20200414172409.GA54710@rdna-mbp>
References: <20200412055837.2883320-1-andriin@fb.com>
 <20200413202126.GA36960@rdna-mbp.dhcp.thefacebook.com>
 <CAEf4Bzbf7kuzTnq6d=Jh+hRdUi++vxabZz2oQU=hPh52rztbgg@mail.gmail.com>
 <20200413224412.GA44785@rdna-mbp.dhcp.thefacebook.com>
 <CAEf4BzY6g6E=_-+fvyEqgWK_-+j2jOL1mFA7wapWW8axZmY=UQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAEf4BzY6g6E=_-+fvyEqgWK_-+j2jOL1mFA7wapWW8axZmY=UQ@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-ClientProxiedBy: CO1PR15CA0077.namprd15.prod.outlook.com
 (2603:10b6:101:20::21) To BYAPR15MB4119.namprd15.prod.outlook.com
 (2603:10b6:a02:cd::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2620:10d:c090:400::5:895e) by CO1PR15CA0077.namprd15.prod.outlook.com (2603:10b6:101:20::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.24 via Frontend Transport; Tue, 14 Apr 2020 17:24:11 +0000
X-Originating-IP: [2620:10d:c090:400::5:895e]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 973c2b43-dd28-4939-d975-08d7e098a5ae
X-MS-TrafficTypeDiagnostic: BYAPR15MB2327:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB23274B4F8B96C040DB0A08C4A8DA0@BYAPR15MB2327.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-Forefront-PRVS: 0373D94D15
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4119.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(7916004)(366004)(53546011)(33716001)(16526019)(33656002)(54906003)(52116002)(6916009)(6496006)(86362001)(81156014)(8936002)(186003)(5660300002)(1076003)(4326008)(8676002)(6486002)(498600001)(66556008)(9686003)(2906002)(66476007)(66946007);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RBB/09uo5lYNOJpf2uQLD/NPWTKENktd/0d1b4wh0dxLNUdpZLAooBoWPRNCpI3mD9Vp77tzYX9bsRvhcDZluLZM12Dg9gYtdKK1wYNVbS2ewAKzHotjckWQwDZCfxIKDXOBo8qrnPbG8WPrWJTrErgi+GTKanHvjSsZMW3sZgJgz8uCMhMfaTD6mztlzvc+sjP6OW05qwwl07KHTk7ddvHJn2oxZaibCdjINvSTWCZSIX4OQTPvGUAgq15tN4ccPmMBc0ojAJQmJIo5n63vDgZX5Aj1tZ//zSeKVJTHdlz6eOinDhc6BQodJ/txA/L6ZBCnKp7XbPLrNAZpzKLxnye6Y/4UqBe3rl47co3nb0mJcm/Ce7vRifKU4Gr9X2HSzOWqsw890+UrjjLMS2VrkdpADNjEJzdMD7kOYD5Nla06eOwWPBQbajcwLEMv9wjW
X-MS-Exchange-AntiSpam-MessageData: Unl1fp5FRLoT3qN6zzZhLPr7m4QVk0iwXa2nsWN3vRw/D3yzjhM3RwYdU+n26vo1L7sk25A6BBcpQs5ep6jej7BKBKzvYrAVepet7Gl2NCY/tB62w6vtph8ZxZrOK4eSxCGGustr8QGNU6/kOVabBDq95c9vLX5g7AtJGX0N5SCYWIiJtN3dD6tOSAxeMaxp
X-MS-Exchange-CrossTenant-Network-Message-Id: 973c2b43-dd28-4939-d975-08d7e098a5ae
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2020 17:24:11.8313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1xYLw/VC3Co0nrQVG3pIOrmGbSfzfX5RPJXyhDoU7O/bQC9ACaBWOER95skM52rg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2327
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-14_08:2020-04-14,2020-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 phishscore=0 mlxscore=0 bulkscore=0 spamscore=0 adultscore=0
 suspectscore=0 lowpriorityscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004140131
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> [Mon, 2020-04-13 21:49 -0700]:
> On Mon, Apr 13, 2020 at 3:44 PM Andrey Ignatov <rdna@fb.com> wrote:
> >
> > Andrii Nakryiko <andrii.nakryiko@gmail.com> [Mon, 2020-04-13 15:00 -0700]:
> > > On Mon, Apr 13, 2020 at 1:21 PM Andrey Ignatov <rdna@fb.com> wrote:
> > > >
> > > > Andrii Nakryiko <andriin@fb.com> [Sat, 2020-04-11 22:58 -0700]:

...

> > > >
> > > > But I don't have context on all hooks that can be affected by this
> > > > change and could easily miss something.
> > > >
> > > > Ideally it should be verified by tests. Current section_names.c test
> > > > only verifies what will be returned, but AFAIK there is no test that
> > > > checks whether provided combination of prog_type/expected_attach_type at
> > > > load time and attach_type at attach time would actually work both on
> > > > current and old kernels. Do you think it's possible to add such a
> > > > selftest? (current libbpf CI supports running on old kernels, doesn't
> > > > it?)
> > >
> > > So all the existing selftests are essentially verifying this, if run
> > > on old kernel. I don't think libbpf currently runs tests on such old
> > > kernels, though. But there is no extra selftest that we need to add,
> > > because every single existing one will execute this piece of libbpf
> > > logic.
> >
> > Apparently existing tests didn't catch the very obvious bug with
> > BPF_PROG_TYPE_CGROUP_SOCK / BPF_CGROUP_INET_EGRESS invalid combination.
> 
> Sigh.. yeah. I expected cgroup_link test to fail if that functionality
> didn't work, but I missed that bpf_program__attach_cgroup() code will
> use correct expected_attach_type, even if it's not provided to
> BPF_PROG_LOAD.
> 
> >
> > I think it'd be useful to start with at least basic test focused on
> > expected_attach_type. Then later extend it to new attach types when they're
> > being added and, ideally, to existing ones.
> 
> How this test should look like? I can make a test that will work only
> on new kernel (e.g., by using cgroup program which needs
> expected_attach_type), but it will fail on old kernels. There doesn't
> seem to be a way to query expected_attach_type from kernel. Any hints
> on how to make test that will pass on old and new kernels and will
> validate expected_attach_type is passed properly?

I think there should be two steps here:
1) make a test;
2) make the test work on old kernels;

The "1)" should be pretty straightforward: we can just have an object
with all possible section names and make sure it can be loaded. If
a program type can have different scenarios, IMO all scenarios should be
covered.

For example, part of the object for cgroup_skb can look like this:

	#include <linux/bpf.h>
	#include <bpf/bpf_helpers.h>
	
	char _license[] SEC("license") = "GPL";
	int _version SEC("version") = 0;
	
	SEC("cgroup_skb/ingress")
	int skb_ret1(struct __sk_buff *skb)
	{
	        return 1;
	}
	
	/* Support for ret > 1 has different expectations for expected_attach_type */
	SEC("cgroup_skb/ingress")
	int skb_ret1(struct __sk_buff *skb)
	{
		return 2;
	}
	
	SEC("cgroup_skb/egress")
	int skb_ret1(struct __sk_buff *skb)
	{
	        return 1;
	}
	
	/* Support for ret > 1 has different expectations for expected_attach_type */
	SEC("cgroup_skb/egress")
	int skb_ret1(struct __sk_buff *skb)
	{
		return 2;
	}
	
	/* Compat section name */
	SEC("cgroup/skb")
	int skb_ret1(struct __sk_buff *skb)
	{
	        return 1;
	}

	/* ... and then other sections .. */

Some time later attach step can be added according to what kind of
program it is (e.g. try to attach cgroup programs to a cgroup, etc).

IMO it'd be beneficial for libbpf to have such a simple/single test that
verifies the very basic thing: simple program for every supported
section name can be loaded.

And such a test would caught the initial problem with NET_XMIT_CN.

I checked whether all sections have at least one program in selftests
and found a bunch that don't:

	09:43:11 0 rdna@dev082.prn2:~/bpf-next$>sed -ne '/static const struct bpf_sec_def section_defs/,/^\};/p' tools/lib/bpf/libbpf.c | awk -F'"' 'NF == 3 {printf "SEC(\"%s\n", $2}' | sort > all_sec_names
	09:43:19 0 rdna@dev082.prn2:~/bpf-next$>head -n 5 all_sec_names
	SEC("action
	SEC("cgroup/bind4
	SEC("cgroup/bind6
	SEC("cgroup/connect4
	SEC("cgroup/connect6
	09:43:20 0 rdna@dev082.prn2:~/bpf-next$>diff -u all_sec_names <(git grep -ohf all_sec_names tools/testing/selftests/bpf/ | sort -u)
	--- all_sec_names       2020-04-14 09:43:19.552675629 -0700
	+++ /dev/fd/63  2020-04-14 09:43:30.967648496 -0700
	@@ -1,21 +1,13 @@
	-SEC("action
	-SEC("cgroup/bind4
	-SEC("cgroup/bind6
	 SEC("cgroup/connect4
	 SEC("cgroup/connect6
	 SEC("cgroup/dev
	 SEC("cgroup/getsockopt
	-SEC("cgroup/post_bind4
	-SEC("cgroup/post_bind6
	-SEC("cgroup/recvmsg4
	-SEC("cgroup/recvmsg6
	 SEC("cgroup/sendmsg4
	 SEC("cgroup/sendmsg6
	 SEC("cgroup/setsockopt
	 SEC("cgroup/skb
	 SEC("cgroup_skb/egress
	 SEC("cgroup_skb/ingress
	-SEC("cgroup/sock
	 SEC("cgroup/sysctl
	 SEC("classifier
	 SEC("fentry/
	@@ -27,10 +19,7 @@
	 SEC("kretprobe/
	 SEC("lirc_mode2
	 SEC("lsm/
	-SEC("lwt_in
	-SEC("lwt_out
	 SEC("lwt_seg6local
	-SEC("lwt_xmit
	 SEC("perf_event
	 SEC("raw_tp/
	 SEC("raw_tracepoint/

That simple test can provide coverage for such sections.

As for "2)" -- I agree, it's not that straightforward: there should be a
way to check for feature presence in the kernel and skip if feature is
not present.  AFAIK currently there is no such thing in bpf
selftests(?). IMO it's fine to postpone this step for later time.

What do you think?

-- 
Andrey Ignatov
