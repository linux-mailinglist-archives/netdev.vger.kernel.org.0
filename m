Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39E5F23ACC2
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 21:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbgHCTHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 15:07:16 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:2584 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726007AbgHCTHP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 15:07:15 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 073J2V8k024553;
        Mon, 3 Aug 2020 12:06:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=w5qZN36XkOS4WA9gHpdphDIVWM1XYLQBcqt1owfpGqY=;
 b=h4Hvi09fvdcPpokkByYQ+8sYWhaae7UYzwi7e9CX5x7R1Hb8uMV97bbsL8Bi0E1IFc1M
 qCFv4NPmXgwsqIbr6wcG/XjWJ8S7LXFEn1fVGl+DbUTkR0wBgkEV7X5V5vBndCAN06fI
 uU/DyXjHfAiV6VNuFwrkeIcetIAPAeZ+DnA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 32n80t8j00-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 03 Aug 2020 12:06:59 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 3 Aug 2020 12:06:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QGSjLrNhUFYttsbJ+pOP3RSIg/AB5K3bEb/kgpxF/LgQWTkJKMggodwEYEPDPjFBgjGDgpgCk3GEu7QzGxZwHoR6PqsSYBfCBihrwVCM6vWNkmGV43gIStDYnQT7Htmin045cJL1Xui/Q0u+GX+8kMSiLYc/7xIIKszkvp2jC6RNhK18Goben+R7xzJvwkSFeIS1vURdfqBnQcT/6F3n1dvNsnXdw4XnGnQh3uVn+JOaJoCF2Rtr0N6CsDQntnaesJGcYE1oNcOdbzxoPT9L+0/8GPV4PafMIuUCavvqSjmhFHsXIjq46sebEYTSGgSyZh0/mHjukTS594iFln9zuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w5qZN36XkOS4WA9gHpdphDIVWM1XYLQBcqt1owfpGqY=;
 b=A5XgfcuGGtYJtyS7NojY5S98PLk2iKChlS+UoJsm/2VPtFrcpGLkJBa+gjGmMqBgla17fCRqA5OU2LpoOppZgHujfU3DNO6Jsq9wkfVMwYLazHt9QP4NIv/Ck6NouanfUbFx/fbiiev3EFDLFKs6DW3MFfJroJkASFPLMwH4FWaC72mQlRW41/sZdXO6bzlS5Afo5678xgCnb3YF2OpKHD/TwJB+VeZQop1sqItaX6NkT5LTDpuRbB1W2K2dMwp7vAHuIl/J/T3V82Y3QMzC7gWSEur0sMAK+P1CbXbRjML66WtVn8BYkfp7XQGygbFOk1UFa+KAHpjoF+s6d243ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w5qZN36XkOS4WA9gHpdphDIVWM1XYLQBcqt1owfpGqY=;
 b=fiKQz1Y+4KtucfspSX3HoN02auzUt2SDe5/P3oxNuprCA6Jee1pESaiFPPBPgNU6AEBrf80DG79TmiuY8RFtcnYy5kav6XWlMnXg519fPd3wsvZzwXSTOTtyd7wttOeBwRd8Hqi5UsQNCr2ZHRpy5/ey/D/6inYGbmwDEaBjF/c=
Authentication-Results: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB3032.namprd15.prod.outlook.com (2603:10b6:a03:ff::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.20; Mon, 3 Aug
 2020 19:06:43 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::354d:5296:6a28:f55e]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::354d:5296:6a28:f55e%6]) with mapi id 15.20.3239.021; Mon, 3 Aug 2020
 19:06:43 +0000
Date:   Mon, 3 Aug 2020 12:06:39 -0700
From:   Roman Gushchin <guro@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, <kernel-team@fb.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next v3 00/29] bpf: switch to memcg-based memory
 accounting
Message-ID: <20200803190639.GD1020566@carbon.DHCP.thefacebook.com>
References: <20200730212310.2609108-1-guro@fb.com>
 <6b1777ac-cae1-fa1f-db53-f6061d9ae675@iogearbox.net>
 <20200803153449.GA1020566@carbon.DHCP.thefacebook.com>
 <a620f231-1e68-6ac5-d7d2-57afa68e91c9@iogearbox.net>
 <20200803170549.GC1020566@carbon.DHCP.thefacebook.com>
 <e17c28a7-d4ff-0689-b2d9-93495e60c4cf@iogearbox.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e17c28a7-d4ff-0689-b2d9-93495e60c4cf@iogearbox.net>
X-ClientProxiedBy: BYAPR07CA0005.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::18) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.DHCP.thefacebook.com (2620:10d:c090:400::5:33f4) by BYAPR07CA0005.namprd07.prod.outlook.com (2603:10b6:a02:bc::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16 via Frontend Transport; Mon, 3 Aug 2020 19:06:42 +0000
X-Originating-IP: [2620:10d:c090:400::5:33f4]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e3cf730-aed2-4b96-f78d-08d837e05bd4
X-MS-TrafficTypeDiagnostic: BYAPR15MB3032:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3032535CAB84125DA7DE0D4CBE4D0@BYAPR15MB3032.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kx9I1R08WR1Vzf8inMbvRlUa2rFnCwsUwRtJjBy3IiQ4nGtt+nag7ezbBKp8OgmbEp3U/g8ghJKE93Z/vk0g7+taMEqwckp/+tgR03dhMRj45tj2wDAz+raBmeNFPnLVkoAzRl0gW4AzXzYMlhykLlcuCktmBwMC9470ueNfiawt37RrcCcr4FpfVDP7n6kizcYy46pW5sZsg+CJumHEk/I8FKPyY8n9ySxKPUXoYdhVoGS2b9SLK44o+TskyqJdmaNIIHyfELZ07cp8c8zss5oq6DIA1n02ucG6FqoubDQJKrCw9XOtNRw0NI2OTZtcwE3SKXiGOuLzm3+wt9kVvF9QIh2utINdEj4/L97T0Fw908KM+PVm9Oqz2ptpf/gb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(136003)(366004)(39860400002)(346002)(376002)(33656002)(86362001)(1076003)(6666004)(83380400001)(2906002)(8676002)(6506007)(53546011)(6916009)(66556008)(7696005)(55016002)(66476007)(5660300002)(186003)(8936002)(316002)(52116002)(15650500001)(9686003)(478600001)(30864003)(66946007)(4326008)(16526019)(2004002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 5VjNvJNmQwYhcVK5J+pcOpoXhDiY+uhhYQycWHlsx2AIeG37xQXQXS8GTLTOIvK9Un+sZSbTVlYfOyn59yHMtqX4xK47+Gg/rYTH1X1BOl9HD+28Yms0nV8zgR6+YB7wJvkUDlExawtJ2cw7118nG7Lb9mezgeIP8z+UTPev/gGCNXlXrTbHXOg+IxQ/vQhtkc6mbee/JwU1QHQsC9Yx2vLNUfPi45LIPlvfV1VNmm7/ICkEPb1cXqjWJmwA9LNdihL0iSPvbmAJ4m71VaamlcaqJW/QFAg5eRBYwgwKWfTDNI1Wc/jNtIHDGsApBWzoqtlr7fzc/FSfyhyNvX4YWFGjsyXhRMYMG3eAp/64Y44gQaYRr/KKRV4oi9+2TYP+SmY7UZmEUcqfTN0t1sKyP0LmlLIbTaA9qibxD6RL7Gryn9y6dlT4ijFJJH8OLiAH7wl00kX3w9f/gGx+DCned9i4AjCCvqYw5Pt7d3fpRDXMWfpQsQqW9GbHZziCIAntifkuWnw9JMY4TjExxz/Xey0LAtyeiTX2Q29iM3/XOcXAI9kNuhakdZesapQQZdZVdiaGgSMisQK1GKlmYvba+3CG10pUWhjaZZzGu0lQhIqC/SE1UZToNdmxFosYy8T/Cxr3hS/f2tWonHsOAXmd/69Ugvd3H/eYgTomWwc1PSI=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e3cf730-aed2-4b96-f78d-08d837e05bd4
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2020 19:06:42.8809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aZXOk2vgnPaEgOsV1ZczlPl3f9TWxnXbfR52yaYeIqINAlYgaReKCuv7+UGgmRAT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3032
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-03_15:2020-08-03,2020-08-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 suspectscore=1 spamscore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 bulkscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008030133
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 03, 2020 at 08:37:15PM +0200, Daniel Borkmann wrote:
> On 8/3/20 7:05 PM, Roman Gushchin wrote:
> > On Mon, Aug 03, 2020 at 06:39:01PM +0200, Daniel Borkmann wrote:
> > > On 8/3/20 5:34 PM, Roman Gushchin wrote:
> > > > On Mon, Aug 03, 2020 at 02:05:29PM +0200, Daniel Borkmann wrote:
> > > > > On 7/30/20 11:22 PM, Roman Gushchin wrote:
> > > > > > Currently bpf is using the memlock rlimit for the memory accounting.
> > > > > > This approach has its downsides and over time has created a significant
> > > > > > amount of problems:
> > > > > > 
> > > > > > 1) The limit is per-user, but because most bpf operations are performed
> > > > > >       as root, the limit has a little value.
> > > > > > 
> > > > > > 2) It's hard to come up with a specific maximum value. Especially because
> > > > > >       the counter is shared with non-bpf users (e.g. memlock() users).
> > > > > >       Any specific value is either too low and creates false failures
> > > > > >       or too high and useless.
> > > > > > 
> > > > > > 3) Charging is not connected to the actual memory allocation. Bpf code
> > > > > >       should manually calculate the estimated cost and precharge the counter,
> > > > > >       and then take care of uncharging, including all fail paths.
> > > > > >       It adds to the code complexity and makes it easy to leak a charge.
> > > > > > 
> > > > > > 4) There is no simple way of getting the current value of the counter.
> > > > > >       We've used drgn for it, but it's far from being convenient.
> > > > > > 
> > > > > > 5) Cryptic -EPERM is returned on exceeding the limit. Libbpf even had
> > > > > >       a function to "explain" this case for users.
> > > > > > 
> > > > > > In order to overcome these problems let's switch to the memcg-based
> > > > > > memory accounting of bpf objects. With the recent addition of the percpu
> > > > > > memory accounting, now it's possible to provide a comprehensive accounting
> > > > > > of memory used by bpf programs and maps.
> > > > > > 
> > > > > > This approach has the following advantages:
> > > > > > 1) The limit is per-cgroup and hierarchical. It's way more flexible and allows
> > > > > >       a better control over memory usage by different workloads.
> > > > > > 
> > > > > > 2) The actual memory consumption is taken into account. It happens automatically
> > > > > >       on the allocation time if __GFP_ACCOUNT flags is passed. Uncharging is also
> > > > > >       performed automatically on releasing the memory. So the code on the bpf side
> > > > > >       becomes simpler and safer.
> > > > > > 
> > > > > > 3) There is a simple way to get the current value and statistics.
> > > > > > 
> > > > > > The patchset consists of the following parts:
> > > > > > 1) memcg-based accounting for various bpf objects: progs and maps
> > > > > > 2) removal of the rlimit-based accounting
> > > > > > 3) removal of rlimit adjustments in userspace samples
> > > > 
> > > > > The diff stat looks nice & agree that rlimit sucks, but I'm missing how this is set
> > > > > is supposed to work reliably, at least I currently fail to see it. Elaborating on this
> > > > > in more depth especially for the case of unprivileged users should be a /fundamental/
> > > > > part of the commit message.
> > > > > 
> > > > > Lets take an example: unprivileged user adds a max sized hashtable to one of its
> > > > > programs, and configures the map that it will perform runtime allocation. The load
> > > > > succeeds as it doesn't surpass the limits set for the current memcg. Kernel then
> > > > > processes packets from softirq. Given the runtime allocations, we end up mischarging
> > > > > to whoever ended up triggering __do_softirq(). If, for example, ksoftirq thread, then
> > > > > it's probably reasonable to assume that this might not be accounted e.g. limits are
> > > > > not imposed on the root cgroup. If so we would probably need to drag the context of
> > > > > /where/ this must be charged to __memcg_kmem_charge_page() to do it reliably. Otherwise
> > > > > how do you protect unprivileged users to OOM the machine?
> > > > 
> > > > this is a valid concern, thank you for bringing it in. It can be resolved by
> > > > associating a map with a memory cgroup on creation, so that we can charge
> > > > this memory cgroup later, even from a soft-irq context. The question here is
> > > > whether we want to do it for all maps, or just for dynamic hashtables
> > > > (or any similar cases, if there are any)? I think the second option
> > > > is better. With the first option we have to annotate all memory allocations
> > > > in bpf maps code with memalloc_use_memcg()/memalloc_unuse_memcg(),
> > > > so it's easy to mess it up in the future.
> > > > What do you think?
> > > 
> > > We would need to do it for all maps that are configured with non-prealloc, e.g. not
> > > only hash/LRU table but also others like LPM maps etc. I wonder whether program entry/
> > > exit could do the memalloc_use_memcg() / memalloc_unuse_memcg() and then everything
> > > would be accounted against the prog's memcg from runtime side, but then there's the
> > > usual issue with 'unuse'-restore on tail calls, and it doesn't solve the syscall side.
> > > But seems like the memalloc_{use,unuse}_memcg()'s remote charging is lightweight
> > > anyway compared to some of the other map update work such as taking bucket lock etc.
> > 
> > I'll explore it and address in the next version. Thank you for suggestions!
> 
> Ok.
> 
> I'm probably still missing one more thing, but could you elaborate what limits would
> be enforced if an unprivileged user creates a prog/map on the host (w/o further action
> such as moving to a specific cgroup)?

If cgroups are not configured properly, no limits can be enforced. Memory cgroups
are completely orthogonal to users.

However, in the most popular case (at least in our setup) when all bpf operations
are performed by root, per-user accounting is useless.

> 
> From what I can tell via looking at systemd:
> 
>   $ cat /proc/self/cgroup
>   11:cpuset:/
>   10:hugetlb:/
>   9:devices:/user.slice
>   8:cpu,cpuacct:/
>   7:freezer:/
>   6:pids:/user.slice/user-1000.slice/user@1000.service
>   5:memory:/user.slice/user-1000.slice/user@1000.service
>   4:net_cls,net_prio:/
>   3:perf_event:/
>   2:blkio:/
>   1:name=systemd:/user.slice/user-1000.slice/user@1000.service/gnome-terminal-server.service
>   0::/user.slice/user-1000.slice/user@1000.service/gnome-terminal-server.service
> 
> And then:
> 
>   $ systemctl cat user-1000.slice
>   # /usr/lib/systemd/system/user-.slice.d/10-defaults.conf
>   #  SPDX-License-Identifier: LGPL-2.1+
>   #
>   #  This file is part of systemd.
>   #
>   #  systemd is free software; you can redistribute it and/or modify it
>   #  under the terms of the GNU Lesser General Public License as published by
>   #  the Free Software Foundation; either version 2.1 of the License, or
>   #  (at your option) any later version.
> 
>   [Unit]
>   Description=User Slice of UID %j
>   Documentation=man:user@.service(5)
>   After=systemd-user-sessions.service
>   StopWhenUnneeded=yes
> 
>   [Slice]
>   TasksMax=33%
> 
> So that has a Pid limit in place by default, but it does not say anything on memory. I
> presume the accounting relevant to us is tracked in memory.kmem.limit_in_bytes and
> memory.kmem.usage_in_bytes, is that correct? If true, it looks like the default would
> not prevent from OOM, no?

Yeah, it's true.

Also in general we're moving from setting hard limits to pressure-based oom handling,
where we detect high continuous memory pressure in a cgroups using psi metrics
and handle it in userspace. Memory.high can be used to slow down the workload
to avoid an extensive overfilling over the limit.

So the most important "feature" is that bpf memory is accounted in
memory.current (cgroup v2) and memory.usage_in_bytes (cgroup v1).

> 
>   $ cat /sys/fs/cgroup/memory/user.slice/user-1000.slice/user@1000.service/memory.kmem.usage_in_bytes
>   257966080
>   $ cat /sys/fs/cgroup/memory/user.slice/user-1000.slice/user@1000.service/memory.kmem.limit_in_bytes
>   9223372036854771712
> 
> > > > > Similarly, what happens to unprivileged users if kmemcg was not configured into the
> > > > > kernel or has been disabled?
> > > > 
> > > > Well, I don't think we can address it. Memcg-based memory accounting requires
> > > > enabled memory cgroups, a properly configured cgroup tree and also the kernel
> > > > memory accounting turned on to function properly.
> > > > Because we at Facebook are using cgroup for the memory accounting and control
> > > > everywhere, I might be biased. If there are real !memcg systems which are
> > > > actively using non-privileged bpf, we should keep the old system in place
> > > > and make it optional, so everyone can choose between having both accounting
> > > > systems or just the new one. Or we can disable the rlimit-based accounting
> > > > for root. But eliminating it completely looks so much nicer to me.
> > > 
> > > Eliminating it entirely feels better indeed. Another option could be that BPF kconfig
> > > would select memcg, so it's always built with it. Perhaps that is an acceptable tradeoff.
> > 
> > But wouldn't it limit the usage of bpf on embedded devices?
> > Where memory cgroups are probably not used, but bpf still can be useful for tracing,
> > for example.
> > 
> > Adding this build dependency doesn't really guarantee anything (e.g. cgroupfs
> > can be simple not mounted on the system), so I'm not sure if we really need it.
> 
> Argh, true as well. :/ Is there some fallback accounting/limitation that could be done
> either explicit or ideally hidden via __GFP_ACCOUNT for unprivileged? We still need to
> prevent unprivileged users to easily cause OOM damage in those situations, too.

Users and memory cgroups are orthogonal, so an unprivileged user can have a process
in the root memory cgroup and it shouldn't be limited. And the opposite: a root process
in a non-root memory cgroup might be limited. We can't really emulate the old semantics
using cgroups.

But I'm not sure if it's a problem: there are other ways to exhaust (kernel) memory
beside bpf. So if a user is not limited by a memory cgroup with the enabled kernel
memory accounting, it's not completely safe anyway.

If we want to save the old behavior, I think the best thing is to keep it as it is,
only add an option (sysctl?) to disable it, which everybody who relies on cgroups
can do to avoid all this hassle with rlimits.

I actually wonder, does anybody rely on this memlock limit?
Or everybody's just bumping it to be "big enough" to avoid getting errors.

Thanks!
