Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0095623AB56
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 19:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbgHCRGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 13:06:11 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9882 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726878AbgHCRGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 13:06:11 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 073H28at010633;
        Mon, 3 Aug 2020 10:05:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=b21y70r1iDrOh/sMXRlwRIKmNTVWQlIOUpAKpiD6+0E=;
 b=dDOYwBd0lESsnVHKnR2KkhVDGkydqaJlyUxFWpqAptnUn5piiogY3hPweUM+KhvYNdiJ
 nSmLIKeBtiBq10A8SH1LlnHyvkvqslDg1s4vFl4BS4+ATuOJ2wiJ4XHLHA2VdaV6ujgc
 nmon/BG3rSGY95zU7aZm0PYUZatYRO+ZvDQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32nr82dgq6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 03 Aug 2020 10:05:57 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 3 Aug 2020 10:05:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D7JlzuhqveGsJamgwwxNTIlRi9FUTjElaZJpydnR57m7CUZqTa07Ofec0tulEYpArM4v0gv5RWTSgiDSAdGKOrHX2LkoHjJIVcxuBpnlji/s7qpCd1kAQUptgSi8XQjEfP4atrVUiMtApKCF83PMlvJdk8STxFGrKG/2iO6WYbT6Wq6pLhs+BqeV7MYb2UDf2x9z31iRFUADmeLqwKXlxkUXh6r6Uav3QN65ElC8lGho8Q0iZm0WOI0D1ndJJV2eR2IWIcv8y51erYKZo96UyZWxPxcp2Yc3Gthy/08xgAi+jH7AMmBsWlkHUg6Y/fE4Ks/Jo1nH90sqZJIMtO4Xwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b21y70r1iDrOh/sMXRlwRIKmNTVWQlIOUpAKpiD6+0E=;
 b=Orq1W3qjQVm1i39mG+4Xvq85kvTKn7axgC5ogbu6A8qNXStmCJn744s+hiXLHNlytL0J/qhOhmS1xBEJLuprZBrup/ZVVSD7g5gMEHvSNH7GHhnkgQSucEr4HiZoyDfIyV1BKLg1kHsx+QE06WoGVMeuq8qWdCEpjG2txh1YXjATQJtoY/cTBkuHICRzaSqHVkoqZnD78lgMPaiYN55T2bnGmXBtkH2uvE3CEZGYh4duwKE9IjuF55ajdNnHAbnmiDLFG358pahA/WHJNTbJYHjPcuFoFbYrOqj+524pM9K1oPdMP6DWyYLs/G/RyVTUz+/voIC6/Y1Bhtxae0EU4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b21y70r1iDrOh/sMXRlwRIKmNTVWQlIOUpAKpiD6+0E=;
 b=Ro4TroFUVLush6miHiCiwODUFD5ToYJgXnk7e3HjRXvIX4uKl3DuZcFLrfzptzXtmmy0TpBDxYp0A6KghCvUu4onc+sjqaZGgOypsaHaTV8MKSyfrerQsiVGhnbcNkWAZ5OzAKAMcy5BObfukM+DkVSH63aPDwjM1Ej2BGDh+5Q=
Authentication-Results: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BY5PR15MB3524.namprd15.prod.outlook.com (2603:10b6:a03:1f5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17; Mon, 3 Aug
 2020 17:05:52 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::354d:5296:6a28:f55e]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::354d:5296:6a28:f55e%6]) with mapi id 15.20.3239.021; Mon, 3 Aug 2020
 17:05:52 +0000
Date:   Mon, 3 Aug 2020 10:05:49 -0700
From:   Roman Gushchin <guro@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, <kernel-team@fb.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next v3 00/29] bpf: switch to memcg-based memory
 accounting
Message-ID: <20200803170549.GC1020566@carbon.DHCP.thefacebook.com>
References: <20200730212310.2609108-1-guro@fb.com>
 <6b1777ac-cae1-fa1f-db53-f6061d9ae675@iogearbox.net>
 <20200803153449.GA1020566@carbon.DHCP.thefacebook.com>
 <a620f231-1e68-6ac5-d7d2-57afa68e91c9@iogearbox.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a620f231-1e68-6ac5-d7d2-57afa68e91c9@iogearbox.net>
X-ClientProxiedBy: BYAPR11CA0093.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::34) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.DHCP.thefacebook.com (2620:10d:c090:400::5:2f3a) by BYAPR11CA0093.namprd11.prod.outlook.com (2603:10b6:a03:f4::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17 via Frontend Transport; Mon, 3 Aug 2020 17:05:52 +0000
X-Originating-IP: [2620:10d:c090:400::5:2f3a]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e09fb912-cf2d-4110-fac0-08d837cf7a6c
X-MS-TrafficTypeDiagnostic: BY5PR15MB3524:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB352404DBF183E7194E990BB1BE4D0@BY5PR15MB3524.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6y1XHrKUqNLti8ABjTzGxyS+QkQ9NQcBfkumzi3LyQcyh7Tnj6mtfa6Bte+fR8K/1/AZQMYEnmlX/xL47JtJWTTFuMu7Lls6R4ujdtAxMjV9rgK0LXFhCvKhx6Kd2BAx6yCtwW//lKpcLYTsh7K5vgIWsej+LbII7GCkOmQM73TCi3YC1W8l2lzhfBBSRw/m3xrH4PzfFmR6s4H7rCJHnxgROGzUI4Cc9ZFI23cExyC12oV0/1IIjlwedlwto92HvJnOdk/gGGmw92Ungf7xQ+d9arftTMo20gk6BKFmXJ/OcD9vkt7gqTTeIs+PCFkmG4XYMUK6YsQvoTGc1KHOjw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(136003)(39860400002)(366004)(346002)(396003)(2906002)(5660300002)(4326008)(316002)(86362001)(66946007)(6666004)(15650500001)(8936002)(6916009)(186003)(55016002)(9686003)(53546011)(6506007)(1076003)(33656002)(83380400001)(52116002)(66556008)(66476007)(7696005)(8676002)(16526019)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: VfycO8aD2Tgr4mpTOL1eR4wawKFb9RAmeYZOJZ28NYcuTuR8Q4dRmdxlJDk9lB5TOUjBX7CFD8RjslZvWBqaCPJbYcyPGDAX36KarFkhV2iCjyweGjEd1jkJox8dcb8LvHRs3uBkf33xnQTpU0BF1T1n8XsOaWv/gFC0Mb1bvKsyftzyFUQbJxwU6Q8dmVIuoM/HxWmlVrtU2txyNYuGmkVYeZv3M/kjgh3D34YYaKTAQb4RdbWELGOAlMdohRp31HUODgTjqoHW6NzmiNIgXdaghB5W6oN56eESux/Gzyj18kg6SCG69XiOuoDdMP94nx8fgiwKVrBP0UgE1jpnt25oIYQzQuOQEEDGBDgA8xR/9+so+RSUQ45kfE0GIwWLr3vN8+/Gjs5trjs4kLAUwh4QUXQ7xaKUQFhCwtb8RVUMalarsVIQcI1fDDLepOYKxNHIa8K9lOi/XNQD1BrlOubNOujZHUgK4DoLedDNJKhmNty9FzHgIjNbJ28C1Bjp39FCgOP2tPewnVYTN+4mVfS0R8U507y0ldeCdQGh8JzNlfSWQr8HixQQqoAHGOL0LuBivSMC5Z2L4oPlNPPTfP7ePXgvuXot/CVVYVkPz0Isk66NE46qWSFc4RNSN8HP9FjUU8fcwIhZygez1YAJFhBMehAIJBeHhuNmev2JjZ8=
X-MS-Exchange-CrossTenant-Network-Message-Id: e09fb912-cf2d-4110-fac0-08d837cf7a6c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2020 17:05:52.7214
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TKi7Ty3igp39kvLB//60JEqhtD4G7ClFIUNLuWFS4zTHZBnSqMqqf3Hz30ET4D8J
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3524
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-03_15:2020-08-03,2020-08-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 impostorscore=0 spamscore=0 clxscore=1015 lowpriorityscore=0
 malwarescore=0 suspectscore=1 phishscore=0 priorityscore=1501 bulkscore=0
 mlxscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008030123
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 03, 2020 at 06:39:01PM +0200, Daniel Borkmann wrote:
> On 8/3/20 5:34 PM, Roman Gushchin wrote:
> > On Mon, Aug 03, 2020 at 02:05:29PM +0200, Daniel Borkmann wrote:
> > > On 7/30/20 11:22 PM, Roman Gushchin wrote:
> > > > Currently bpf is using the memlock rlimit for the memory accounting.
> > > > This approach has its downsides and over time has created a significant
> > > > amount of problems:
> > > > 
> > > > 1) The limit is per-user, but because most bpf operations are performed
> > > >      as root, the limit has a little value.
> > > > 
> > > > 2) It's hard to come up with a specific maximum value. Especially because
> > > >      the counter is shared with non-bpf users (e.g. memlock() users).
> > > >      Any specific value is either too low and creates false failures
> > > >      or too high and useless.
> > > > 
> > > > 3) Charging is not connected to the actual memory allocation. Bpf code
> > > >      should manually calculate the estimated cost and precharge the counter,
> > > >      and then take care of uncharging, including all fail paths.
> > > >      It adds to the code complexity and makes it easy to leak a charge.
> > > > 
> > > > 4) There is no simple way of getting the current value of the counter.
> > > >      We've used drgn for it, but it's far from being convenient.
> > > > 
> > > > 5) Cryptic -EPERM is returned on exceeding the limit. Libbpf even had
> > > >      a function to "explain" this case for users.
> > > > 
> > > > In order to overcome these problems let's switch to the memcg-based
> > > > memory accounting of bpf objects. With the recent addition of the percpu
> > > > memory accounting, now it's possible to provide a comprehensive accounting
> > > > of memory used by bpf programs and maps.
> > > > 
> > > > This approach has the following advantages:
> > > > 1) The limit is per-cgroup and hierarchical. It's way more flexible and allows
> > > >      a better control over memory usage by different workloads.
> > > > 
> > > > 2) The actual memory consumption is taken into account. It happens automatically
> > > >      on the allocation time if __GFP_ACCOUNT flags is passed. Uncharging is also
> > > >      performed automatically on releasing the memory. So the code on the bpf side
> > > >      becomes simpler and safer.
> > > > 
> > > > 3) There is a simple way to get the current value and statistics.
> > > > 
> > > > The patchset consists of the following parts:
> > > > 1) memcg-based accounting for various bpf objects: progs and maps
> > > > 2) removal of the rlimit-based accounting
> > > > 3) removal of rlimit adjustments in userspace samples
> > 
> > > The diff stat looks nice & agree that rlimit sucks, but I'm missing how this is set
> > > is supposed to work reliably, at least I currently fail to see it. Elaborating on this
> > > in more depth especially for the case of unprivileged users should be a /fundamental/
> > > part of the commit message.
> > > 
> > > Lets take an example: unprivileged user adds a max sized hashtable to one of its
> > > programs, and configures the map that it will perform runtime allocation. The load
> > > succeeds as it doesn't surpass the limits set for the current memcg. Kernel then
> > > processes packets from softirq. Given the runtime allocations, we end up mischarging
> > > to whoever ended up triggering __do_softirq(). If, for example, ksoftirq thread, then
> > > it's probably reasonable to assume that this might not be accounted e.g. limits are
> > > not imposed on the root cgroup. If so we would probably need to drag the context of
> > > /where/ this must be charged to __memcg_kmem_charge_page() to do it reliably. Otherwise
> > > how do you protect unprivileged users to OOM the machine?
> > 
> > this is a valid concern, thank you for bringing it in. It can be resolved by
> > associating a map with a memory cgroup on creation, so that we can charge
> > this memory cgroup later, even from a soft-irq context. The question here is
> > whether we want to do it for all maps, or just for dynamic hashtables
> > (or any similar cases, if there are any)? I think the second option
> > is better. With the first option we have to annotate all memory allocations
> > in bpf maps code with memalloc_use_memcg()/memalloc_unuse_memcg(),
> > so it's easy to mess it up in the future.
> > What do you think?
> 
> We would need to do it for all maps that are configured with non-prealloc, e.g. not
> only hash/LRU table but also others like LPM maps etc. I wonder whether program entry/
> exit could do the memalloc_use_memcg() / memalloc_unuse_memcg() and then everything
> would be accounted against the prog's memcg from runtime side, but then there's the
> usual issue with 'unuse'-restore on tail calls, and it doesn't solve the syscall side.
> But seems like the memalloc_{use,unuse}_memcg()'s remote charging is lightweight
> anyway compared to some of the other map update work such as taking bucket lock etc.

I'll explore it and address in the next version. Thank you for suggestions!

> 
> > > Similarly, what happens to unprivileged users if kmemcg was not configured into the
> > > kernel or has been disabled?
> > 
> > Well, I don't think we can address it. Memcg-based memory accounting requires
> > enabled memory cgroups, a properly configured cgroup tree and also the kernel
> > memory accounting turned on to function properly.
> > Because we at Facebook are using cgroup for the memory accounting and control
> > everywhere, I might be biased. If there are real !memcg systems which are
> > actively using non-privileged bpf, we should keep the old system in place
> > and make it optional, so everyone can choose between having both accounting
> > systems or just the new one. Or we can disable the rlimit-based accounting
> > for root. But eliminating it completely looks so much nicer to me.
> 
> Eliminating it entirely feels better indeed. Another option could be that BPF kconfig
> would select memcg, so it's always built with it. Perhaps that is an acceptable tradeoff.

But wouldn't it limit the usage of bpf on embedded devices?
Where memory cgroups are probably not used, but bpf still can be useful for tracing,
for example.

Adding this build dependency doesn't really guarantee anything (e.g. cgroupfs
can be simple not mounted on the system), so I'm not sure if we really need it.

Maybe we can print a warning if memcg is not properly configured and somebody
is creating a map? Idk.

Thanks!
