Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AEFA2C19C7
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 01:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727502AbgKXAGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 19:06:14 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34506 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725287AbgKXAGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 19:06:13 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AO04Y3F029560;
        Mon, 23 Nov 2020 16:05:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=B4o1/oPUqFd/jw27oUZp09nN4vL3HmDq4Mc6dMu8isY=;
 b=JD6qsfPIe8gc4IVCDV5u5tp7qaMGyqao6IT0caosb3efkii5dkjJsraXRk9nrT3wUX9/
 DE/HnoL7NQ3xiRPWgejjN+j+6kXyErYAVVIrqY2O5KcWg0hflkhKhRQShbPKe18JK7P2
 ceg37AuwRL092Y3iufrmHpuBHuDDt0PLNNU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34ykxgf2s2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 23 Nov 2020 16:05:55 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 23 Nov 2020 16:05:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kDFGrtxwQ0ib1AbOVDVaxQpe6kWnXbkkQGuHO1O/k5svqHaUc7zbadlrreCASkbcfWjCkuYkr67vK1NEd1yKjUbmZQ24seK1ZyhzbBsODTpBuakWvcbcVjPpQw0zbGM7vjFbCCnCLzMebNVRcLks8WNHnqIR6guC6VEoFPefF3SbgRN75KCKwqpc0D2vjsqbu4hsyqc0oO2DK/5hhmT1astGmv4yrYxjaX2SI/oI2HlxCWLJUqpS1Sruf+8haUZBXoSpxlSk8jMGjzhBY98T6h+nA8tmdxjfJjnZV8Tz5SFzUcaJAZeMXWU8hIrI1WxF8ZRpWyfQ3rjBXJWNZJQphA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B4o1/oPUqFd/jw27oUZp09nN4vL3HmDq4Mc6dMu8isY=;
 b=lq69Wj38WdwvH7MDwxQDxWYoV+kY5gNpu6W0UOsygyqcQ9DLdXHKqw8P/IKaD8gfGf36TdmorMDvKxSDn4zaBOYLudWUd8zVJABC2ueFEaq/0mEgh0q/odDAA3vjvjZl6OqYkCfnGQilk9RBUJagEkuDT5N15dDHfvtL6IBupImtaztIHnHiC5wSqVXZ7DvdapYPx1FBd1tl7rdoZ62LKcX3r73rU2qTQ4t1gcblPmVvniBtEAynPcjIfDbEMQ0adxQMUE58v4pP6fO/q71tUX+W2CWTyLGJ4QqqgYj7zeh+K+hQpMHzoRqoponSbXqYplE5EmjqT6T7fxw2c4HwZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B4o1/oPUqFd/jw27oUZp09nN4vL3HmDq4Mc6dMu8isY=;
 b=IdpSG8tRRMcSWZTL+vBfoqW+LuATMcf7WHm+f0R29+mSwh6EGd8zTVcKchJYZmHX7Gv3jRB+TQkDv9OcpDuNgCz+YTS609dzddfFh9wLF1/xHhwLWFths87imVLWUX2Q3b+USNctN8k82dc5UiPQKnHXu2PST0UCk2LCQem9VbI=
Authentication-Results: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB2486.namprd15.prod.outlook.com (2603:10b6:a02:84::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.21; Tue, 24 Nov
 2020 00:05:53 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::3925:e1f9:4c6a:9396]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::3925:e1f9:4c6a:9396%7]) with mapi id 15.20.3589.021; Tue, 24 Nov 2020
 00:05:53 +0000
Date:   Mon, 23 Nov 2020 16:05:48 -0800
From:   Roman Gushchin <guro@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     <bpf@vger.kernel.org>, <ast@kernel.org>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next v7 00/34] bpf: switch to memcg-based memory
 accounting
Message-ID: <20201124000548.GE186396@carbon.dhcp.thefacebook.com>
References: <20201119173754.4125257-1-guro@fb.com>
 <9134a408-e26c-a7f2-23a7-5fc221bafdde@iogearbox.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9134a408-e26c-a7f2-23a7-5fc221bafdde@iogearbox.net>
X-Originating-IP: [2620:10d:c090:400::5:91e]
X-ClientProxiedBy: MWHPR14CA0027.namprd14.prod.outlook.com
 (2603:10b6:300:12b::13) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:400::5:91e) by MWHPR14CA0027.namprd14.prod.outlook.com (2603:10b6:300:12b::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Tue, 24 Nov 2020 00:05:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: feaa64f1-38b7-440b-65ad-08d8900cb526
X-MS-TrafficTypeDiagnostic: BYAPR15MB2486:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2486C803EEFF51CC7427AA5BBEFB0@BYAPR15MB2486.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nPLdrBHyOZ2TJlLYYL/IzJSvBi0q9Ak5z22HvOd4B8j9y5NUi8jT9LzkMSmqXonu7CzFMJIrj5FbYTIAZkuqX+Z25NRwhOcJTYjMFKs84gstEfgqq9cYH579pj0E+XfVPpwJEkotJSxTu0RxKpQ3TvYaoGiBroCXQjPE4CFA7YF7iyn6+k6YU6W5rLE+eepH4xi93KUnBbmlA4JRFst8Yuyt853HlUhpv+Wzn0XTaTh2DQ+pZs8UE4mAiVTTAJtAnuq0yq9JJh0yTicXEe5ZChMQxcNj5c0sx1lR33ZCGE5t1OYbBn7v82mO8Mj8Clbmnx8uVMZYjR4huyx+xml5/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(136003)(346002)(366004)(376002)(6666004)(4326008)(53546011)(8936002)(6506007)(316002)(16526019)(83380400001)(186003)(6916009)(8676002)(2906002)(9686003)(5660300002)(478600001)(55016002)(86362001)(15650500001)(66556008)(66476007)(1076003)(7696005)(66946007)(33656002)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: yzkGHyKj72N+VLRlFrj6DtvBYXfXX+NOTRIdknIC8zj8I2AHr9xGScDxRKzv6jPNRr0Ws6oKF7CmmSDMIo2KMmiJkwdO9WNsb/bQ//VxYIpMNtO8YMxViurJEsjd+VUqngzlA5JaxVn4rknbhrWL1rGFRhgTbiVV4XBIpSHnm9eQde4E+GEr/jhIWJmAa6rTB1stZmenD0KEVF4HhaJZhiDascNrs+NoRqrhcSLfbzItucrdvkpFxMQxFMmoylG5vax72LiLEaBfzRtLhmZDu1pticqxbdy17q4rjMZSTg7An+kJK20duuAjL35BE5U5qvVOU5+modCaT2nUs6fU8djXs94VTXC56VM3VPVmW0yOIZ1Bv3/Y9CmEnY8C2rBrHph6/sYodtoLPJ8pqH5nntcTYnGjKfMMUes2Ijj65A7K/Og3tvWRAwSCqtRdDLoqN0VyFpuE5hqQVMIfFsEK8yo5CXyy/bHCmxecDOXOHI8qY4cve7eFj7xre7dsXbKXBy5rMGl5TFSPZbaYVl/c0H2FFdzT++yU4hmvBrgARQH0bOT7IEbwlYLp8+7sdJW7ZhgJ/VQuDm1kpbTotLS7q481COu0KIYfHJoN+UdlIZ+BiAOXSGP9deJhIP45+eLQuQLk412ma56FHjtnIvumUcPrZLQPfrwQIruv0lWgWTsikIV5ITrYPZDrN+rw9vDSl4bylbWbiR6GqM38p5vua5goj3dO39YppGt54/3tC7x6hC74SKkSV+l0axUY+pRUgf0ZSH21UG0j+gwWQSxvwCTV7664oWJA4CgoogZpwUkZoEi1GVLGfJsjm7L8Fs77GIcEeAB6u0FybfDxfPf1wSQL1pzJCg3ep9IXcTwbnThSixhdCioXVjsFHV+NiOQxE6tCYJbbwVttNngam/r7Cx/YQQa0KPgfYgnlZqCUG6o=
X-MS-Exchange-CrossTenant-Network-Message-Id: feaa64f1-38b7-440b-65ad-08d8900cb526
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2020 00:05:52.8893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QFRZw1rp/ipSGNeQTklWkS0VHWOJkcOU+VkMmKmLFobFZ4OLXrT+0jIMj6VX2g3q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2486
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-23_19:2020-11-23,2020-11-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 lowpriorityscore=0 suspectscore=1 mlxlogscore=967 priorityscore=1501
 spamscore=0 impostorscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 phishscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011230155
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 23, 2020 at 02:30:09PM +0100, Daniel Borkmann wrote:
> On 11/19/20 6:37 PM, Roman Gushchin wrote:
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
> > of the memory used by bpf programs and maps.
> > 
> > This approach has the following advantages:
> > 1) The limit is per-cgroup and hierarchical. It's way more flexible and allows
> >     a better control over memory usage by different workloads. Of course, it
> >     requires enabled cgroups and kernel memory accounting and properly configured
> >     cgroup tree, but it's a default configuration for a modern Linux system.
> > 
> > 2) The actual memory consumption is taken into account. It happens automatically
> >     on the allocation time if __GFP_ACCOUNT flags is passed. Uncharging is also
> >     performed automatically on releasing the memory. So the code on the bpf side
> >     becomes simpler and safer.
> > 
> > 3) There is a simple way to get the current value and statistics.
> > 
> > In general, if a process performs a bpf operation (e.g. creates or updates
> > a map), it's memory cgroup is charged. However map updates performed from
> > an interrupt context are charged to the memory cgroup which contained
> > the process, which created the map.
> > 
> > Providing a 1:1 replacement for the rlimit-based memory accounting is
> > a non-goal of this patchset. Users and memory cgroups are completely
> > orthogonal, so it's not possible even in theory.
> > Memcg-based memory accounting requires a properly configured cgroup tree
> > to be actually useful. However, it's the way how the memory is managed
> > on a modern Linux system.

Hi Daniel!

> 
> The cover letter here only describes the advantages of this series, but leaves
> out discussion of the disadvantages. They definitely must be part of the series
> to provide a clear description of the semantic changes to readers.

Honestly, I don't see them as disadvantages. Cgroups are basic units in which
resource control limits/guarantees/accounting are expressed. If there are
no cgroups created and configured in the system, it's obvious (maybe only to me)
that no limits are applied.

Users (rlimits) are to some extent similar units, but they do not provide
a comprehensive resource control system. Some parts are deprecated (like rss limits),
some parts are just missing. Aside from bpf nobody uses users to control
the memory as a physical resource. It simple doesn't work (and never did).
If somebody expects that a non-privileged user can't harm the system by depleting
it's memory (and other resources), it's simple not correct. There are multiple ways
for doing it. Accounting or not accounting bpf maps doesn't really change anything.
If we see them not as a real security mechanism, but as a way to prevent "mistakes",
which can harm the system, it's to some extent legit. The question is only if
it justifies the amount of problems we had with these limits.

Switching to memory cgroups, which are the way how the memory control is expressed,
IMO doesn't need an additional justification. During the last year I remember 2 or 3
times when various people (internally in Fb and in public mailing lists) were asking
why bpf memory is not accounted to memory cgroups. I think it's basically expected
these days.

I'll try to make more obvious that we're switching from users to cgroups and
describe the consequences of it on an unconfigured system. I'll update the cover.

> Last time we
> discussed them, they were i) no mem limits in general on unprivileged users when
> memory cgroups was not configured in the kernel, and ii) no mem limits by default
> if not configured in the cgroup specifically.
> Did we made any progress on these
> in the meantime? How do we want to address them? What is the concrete justification
> to not address them?

I don't see how they can and should be addressed.
Cgroups are the way how the resource consumption of a group of processes can be
limited. If there are no cgroups configured, it means all resources are available
to everyone. Maybe a user wants to use the whole memory for a bpf map? Why not?

Do you have any specific use case in your mind?
If you see a real value in the old system (I don't), which can justify an additional
complexity of keeping them both in a working state, we can discuss this option too.
We can make a switch in few steps, if you think it's too risky.

> 
> Also I wonder what are the risk of regressions here, for example, if an existing
> orchestrator has configured memory cgroup limits that are tailored to the application's
> needs.. now, with kernel upgrade BPF will start to interfere, e.g. if a BPF program
> attached to cgroups (e.g. connect/sendmsg/recvmsg or general cgroup skb egress hook)
> starts charging to the process' memcg due to map updates?

Well, if somebody has a tight memory limit and large bpf map(s), they can see a "regression".
However the kernel memory usage and accounting implementation details vary from a version
to a version, so nobody should expect that limits once set will work forever.
If for some strange reason it'll create a critical problem, as a workaround it's possible
to disable the kernel memory accounting as a whole (via a boot option).

Actually, it seems that the usefulness of strict limits is generally limited, because
it's hard to get and assign any specific value. They are always either too relaxed
(and have no value), either too strict (and causing production issues). Memory cgroups
are generally moving towards soft limits and protections. But it's a separate theme...

Thanks!
