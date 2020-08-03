Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8DB123A978
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 17:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbgHCPfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 11:35:12 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:29936 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726773AbgHCPfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 11:35:11 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 073FMTQR023488;
        Mon, 3 Aug 2020 08:34:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=I4edBJXdTjhD2sCYXDwqzAa9net4DCi6gzZEEEXn0u4=;
 b=jX12vd+NM6BPD8UnoyZF66jPOIsanwEvBl3keMtXug27fxwqo1r7gp0XOWgOJSd237kg
 Z86LpnoEDOeRkAjlj+lMZ880gn6Evz/UefKCz067qfzFR+b83igT4v8PkKZ43sG1uqLI
 PRaq/BTL+H2NZJaVHN6kfkRitZloLLJBoJM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 32n80t7fr1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 03 Aug 2020 08:34:55 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 3 Aug 2020 08:34:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hXbE94sFZewp3DQAoonkJgF9dhkmytYTDbvYlu94c1SXhonqCb20fjpB4aXJWZLZpKz7boPSl/LAiTd3NVTlWeHU7ETElBk243QFGWfau0Ad2SIRX2Vzoyk4yMWIN8q2CPQNGvj+HFnOhTc9AjjutxT2jj5gCT24Ly+Q9dwEftnDdBztEHiImpWxM3vHb5YY6wYT4kmV2C4fqCB6D72JI1xb98+s4MCAenDXatEyivTg1GCFRGmZ2asBtYkCJBKczwpATsCN5ciidHPWkVAA22J7+d1hrsZVsiR57Q1ev7BAQ2UKe8MXPKxQfmnv97shnb8jJFABtqW1g8xSg4c4MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I4edBJXdTjhD2sCYXDwqzAa9net4DCi6gzZEEEXn0u4=;
 b=e5Z+k0Ls02LQylIn+YQrkYBow8y4fg8MHJsNIrOVbnQQqbDDTM9JwyJ2un4iY+65XJn2Ss3Sm3+falAPSzGd/AQpQGuSxFMV+RZwl5q5DbF0qddJ+vHfd/tafrQaxY0GlVAWfgY75fLsGC96+Y5klrJI+y/U4153iae7IGvGD8z1E3U3PjwaWyiBZghRlwfmadedSRQ2iYhjkfLMoQpJhRaOthpCv8k/3S6Ag+my4NzoJ4gmEtqio8ol9dp5ryQYlR3jZ+GoAYqoLex+vAPdOK+w3JY4CzlhI6fLPkjCXgVyeQVG+RGMPIYoag8K+OOW4kG3RKBsHCTaVyvY0qUGfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I4edBJXdTjhD2sCYXDwqzAa9net4DCi6gzZEEEXn0u4=;
 b=dtgmGQh9SolkAwp3lNV4RJAuAJibB1WT+kZgBlugAvdA8QAdY7GuAbyDGUdQeEOzF6bI+OZs8EFzcaHeBsM/yG1SF6z54iiGoPWfLyjddbu6+wTsLp+UItQU+CVmdeOb3s8xVbVIjhxJwLLiuBvJKPxAs55FmlU+145xvR2dTfw=
Authentication-Results: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB2437.namprd15.prod.outlook.com (2603:10b6:a02:8d::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.20; Mon, 3 Aug
 2020 15:34:53 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::354d:5296:6a28:f55e]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::354d:5296:6a28:f55e%6]) with mapi id 15.20.3239.021; Mon, 3 Aug 2020
 15:34:53 +0000
Date:   Mon, 3 Aug 2020 08:34:49 -0700
From:   Roman Gushchin <guro@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, <kernel-team@fb.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next v3 00/29] bpf: switch to memcg-based memory
 accounting
Message-ID: <20200803153449.GA1020566@carbon.DHCP.thefacebook.com>
References: <20200730212310.2609108-1-guro@fb.com>
 <6b1777ac-cae1-fa1f-db53-f6061d9ae675@iogearbox.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b1777ac-cae1-fa1f-db53-f6061d9ae675@iogearbox.net>
X-ClientProxiedBy: BY3PR05CA0018.namprd05.prod.outlook.com
 (2603:10b6:a03:254::23) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.DHCP.thefacebook.com (2620:10d:c090:400::5:2f3a) by BY3PR05CA0018.namprd05.prod.outlook.com (2603:10b6:a03:254::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.14 via Frontend Transport; Mon, 3 Aug 2020 15:34:52 +0000
X-Originating-IP: [2620:10d:c090:400::5:2f3a]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf112371-4c2f-46fd-c2ff-08d837c2c418
X-MS-TrafficTypeDiagnostic: BYAPR15MB2437:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB24373684B868160E521E61A5BE4D0@BYAPR15MB2437.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MHk+vc0wrUNKwCDPBfmJ9o0xy1RDWzDoLNtjSThAhJrFGp4cs7e9dEjf26eInIzgI9fzNEln0kktTbbtl59Aji/LnAkZzL+q2gJP6FeLEN+tb8yz7YqckyYssN06j2jqsi/QjdsZ1PdTy9x/Q96GOokMLQ5LDOylLKE8Vv5st/TpXWLtEmSzAvEWztFppoVn/2hPvKmAUXDJMhML4luj81LfepWdhRtAQNtJsoNu6LH/vlXcXXW1M3VguPCn/23SfAC1Su0owjgxSRMhoBQRTX+DiExpabjkSbH8DvZrYEXfgMKuvca5bNlNEv7Ps7ics+3B0JuM2ZokDZ+3uwWghA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(366004)(396003)(136003)(346002)(39860400002)(6916009)(86362001)(1076003)(55016002)(4326008)(9686003)(478600001)(33656002)(15650500001)(5660300002)(83380400001)(316002)(8936002)(8676002)(53546011)(186003)(16526019)(2906002)(6506007)(66556008)(6666004)(52116002)(7696005)(66946007)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: Wnx/2FMJfLDBqDz08r8HxBUDEO8bj+bXkyGqFbZVGjJ81ZtWtS8KppLNUzXsReLBvre0GlCFzOOh+Rc/q01qWPxAuN/kVU5uqUXhsNfBRhHtkBGJFIRjfCD4Uvy642ew6x8OcyvuecLVSCsC4Qi2h8fKWyjoYn+Z7s/Dk1PMe5aXT3olKkMX0Zi+N5YkZ1oUnuDw0zVp4OGdCdZ7z1gVIiKVfsrGm1YsZydF+MLytRtgSlt+KwJb7Md9hLV7p4ZmqzXGE3q7p3mUz8mIo6gB45zAtmyIm1O0BZ0Af1/YewHaUdA1OZPJyvruSF3OEmP7C2l+yT4BlkaoB3AGtKkLcA/LnMaKdkB52nNC4wrdFSTiRsUlBwpQjwDR5oeXhMRuq754hDcAqQnT9nqyoyJ2nu69++8I67mTWiIo5RrG9JbxSI/wiFdW0cpD0fwbhzW7My4hitt3lm1jA5KmEG8W+5U0uPw0kStsMnU+cHocnh5N2AVpXG7IRCVV4er9OfYUQBkHtTynwleaz3tpFImYdrIVgK3rmhUa7wMRkl9BDbAEDZ/HJkk9IQJ1x4RNkS44FSo82/kLaG/hHO93L2iG8jHYM2FGj3UN0Uxccgjh0DoAwT7wDZjuM1T58xHiVxi/aQTbZb6WFjx0CkTm/JU4kHITxr1kKsgbJnXjVV4AOxI=
X-MS-Exchange-CrossTenant-Network-Message-Id: cf112371-4c2f-46fd-c2ff-08d837c2c418
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2020 15:34:52.9503
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2OVx2GwD2Houck1T/GXdVsJlTD6HqCG9JrEEetOcl/dqz6BAdk7V6QO3EId6PpSt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2437
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-03_14:2020-08-03,2020-08-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 suspectscore=1 spamscore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 bulkscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008030116
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 03, 2020 at 02:05:29PM +0200, Daniel Borkmann wrote:
> On 7/30/20 11:22 PM, Roman Gushchin wrote:
> > Currently bpf is using the memlock rlimit for the memory accounting.
> > This approach has its downsides and over time has created a significant
> > amount of problems:
> > 
> > 1) The limit is per-user, but because most bpf operations are performed
> >     as root, the limit has a little value.
> > 
> > 2) It's hard to come up with a specific maximum value. Especially because
> >     the counter is shared with non-bpf users (e.g. memlock() users).
> >     Any specific value is either too low and creates false failures
> >     or too high and useless.
> > 
> > 3) Charging is not connected to the actual memory allocation. Bpf code
> >     should manually calculate the estimated cost and precharge the counter,
> >     and then take care of uncharging, including all fail paths.
> >     It adds to the code complexity and makes it easy to leak a charge.
> > 
> > 4) There is no simple way of getting the current value of the counter.
> >     We've used drgn for it, but it's far from being convenient.
> > 
> > 5) Cryptic -EPERM is returned on exceeding the limit. Libbpf even had
> >     a function to "explain" this case for users.
> > 
> > In order to overcome these problems let's switch to the memcg-based
> > memory accounting of bpf objects. With the recent addition of the percpu
> > memory accounting, now it's possible to provide a comprehensive accounting
> > of memory used by bpf programs and maps.
> > 
> > This approach has the following advantages:
> > 1) The limit is per-cgroup and hierarchical. It's way more flexible and allows
> >     a better control over memory usage by different workloads.
> > 
> > 2) The actual memory consumption is taken into account. It happens automatically
> >     on the allocation time if __GFP_ACCOUNT flags is passed. Uncharging is also
> >     performed automatically on releasing the memory. So the code on the bpf side
> >     becomes simpler and safer.
> > 
> > 3) There is a simple way to get the current value and statistics.
> > 
> > The patchset consists of the following parts:
> > 1) memcg-based accounting for various bpf objects: progs and maps
> > 2) removal of the rlimit-based accounting
> > 3) removal of rlimit adjustments in userspace samples

Hi Daniel,

> 
> The diff stat looks nice & agree that rlimit sucks, but I'm missing how this is set
> is supposed to work reliably, at least I currently fail to see it. Elaborating on this
> in more depth especially for the case of unprivileged users should be a /fundamental/
> part of the commit message.
> 
> Lets take an example: unprivileged user adds a max sized hashtable to one of its
> programs, and configures the map that it will perform runtime allocation. The load
> succeeds as it doesn't surpass the limits set for the current memcg. Kernel then
> processes packets from softirq. Given the runtime allocations, we end up mischarging
> to whoever ended up triggering __do_softirq(). If, for example, ksoftirq thread, then
> it's probably reasonable to assume that this might not be accounted e.g. limits are
> not imposed on the root cgroup. If so we would probably need to drag the context of
> /where/ this must be charged to __memcg_kmem_charge_page() to do it reliably. Otherwise
> how do you protect unprivileged users to OOM the machine?

this is a valid concern, thank you for bringing it in. It can be resolved by
associating a map with a memory cgroup on creation, so that we can charge
this memory cgroup later, even from a soft-irq context. The question here is
whether we want to do it for all maps, or just for dynamic hashtables
(or any similar cases, if there are any)? I think the second option
is better. With the first option we have to annotate all memory allocations
in bpf maps code with memalloc_use_memcg()/memalloc_unuse_memcg(),
so it's easy to mess it up in the future.
What do you think?

> 
> Similarly, what happens to unprivileged users if kmemcg was not configured into the
> kernel or has been disabled?

Well, I don't think we can address it. Memcg-based memory accounting requires
enabled memory cgroups, a properly configured cgroup tree and also the kernel
memory accounting turned on to function properly.
Because we at Facebook are using cgroup for the memory accounting and control
everywhere, I might be biased. If there are real !memcg systems which are
actively using non-privileged bpf, we should keep the old system in place
and make it optional, so everyone can choose between having both accounting
systems or just the new one. Or we can disable the rlimit-based accounting
for root. But eliminating it completely looks so much nicer to me.

Thanks!
