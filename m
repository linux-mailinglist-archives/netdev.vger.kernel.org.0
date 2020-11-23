Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B61C32BFDA5
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 01:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgKWAlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 19:41:09 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:26188 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725782AbgKWAlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Nov 2020 19:41:09 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AN0Y3fb000486;
        Sun, 22 Nov 2020 16:40:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=AU6wwZ0dhDwKYJt97OVMlcCPUKDxA5MKVDvmfkBm6YY=;
 b=FWpUOR31EYF0oN62ctTQnpmy3oftpzjeu1WFa1e5kYSKgw09gedF325b8k8LGpIl2ErU
 6VKPoxgQqFUEDMCFtR3s5ksS7x0sjJ5IsE9Kyhu/HsIrHPAiRE1pBqsPQbqvE99KDwCT
 xBRbtwVKO/loXxIGgf36cQDLZ5QL2wvVV/g= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34ym1ta5kr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 22 Nov 2020 16:40:43 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 22 Nov 2020 16:40:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d80su9xyBNK57nOhpo6RE+I7Z9uvM+73w2N0DMsSnr+EaDAJ+R+HzquTpz2ZShwvl/ooz8vt8+azdJ50zgUfK7Gn5JQp4YjNRWaOeVq5sNIfI6MQWZaJhGtv1NT4TQ2svM2y1gujtAbhNhVgg6tB2XFsfcoCOQux9R2Wmm/KNvql9WkOkGb8HVergfCfOOn/S19GagC/XLzABWcZpPrbj3JKUMsb7cYNxipxrSgnlQbpnafM/KzXn+GjBircWNgnj4OYA4yWc7LQmfuNuJv6eqru6cp+no2a/5C+K6VViM/vjg55n05fbTzUdTtynyrm+gKU7kkocJWrZ2y+cg8/hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AU6wwZ0dhDwKYJt97OVMlcCPUKDxA5MKVDvmfkBm6YY=;
 b=hWnieRW+r5g8bJPq8B6Nf94csmO95uM940/BWs9inQxMdpvnWQ9/2AG0BGEy8GUE7bcZTjgTsYfCjQ2Hv2Z6ovTU0q75mIkO3LNjsX3I8/2z5NPxurmWZBTjsMaFDEf3hkmBwq08QNr0Or4ceqXiZI7N7NNHJ3/T26xLge7uGBYSDdZlogO08hLEiqMKowOZvULkc/lL+DZsdgs4jPnSVCsGxqjsSlI+7CZCQl2/zXr6MaB8b95VDg7vdSKcEza/FAxBK7sGu0m1PtbjWyrDoNsaqiwhWyFi2yxVUS/GmCZUrGeIFQLjLVS8qdcu1PNSKkiPZYaanvP2O0WQD0zTrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AU6wwZ0dhDwKYJt97OVMlcCPUKDxA5MKVDvmfkBm6YY=;
 b=g5fAe7JlCJZP+9Oc6JZUPzVanX0r2AYMnFld6gQBqn4RoFHYgpGNCOQa/bKJCvKCqwaaxCxD+9b46C+eSvizY8F0SoU+SNwVqc0IB8nWOZ4cPVlj25mN4kuqEdE4B1FKjSGOa8jGJvVOhru/pP3DfK7iUdLXf/Fd5eD2PiS5Z90=
Authentication-Results: amazon.co.jp; dkim=none (message not signed)
 header.d=none;amazon.co.jp; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2774.namprd15.prod.outlook.com (2603:10b6:a03:15d::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.21; Mon, 23 Nov
 2020 00:40:27 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee%4]) with mapi id 15.20.3564.034; Mon, 23 Nov 2020
 00:40:27 +0000
Date:   Sun, 22 Nov 2020 16:40:20 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
CC:     <ast@kernel.org>, <benh@amazon.com>, <bpf@vger.kernel.org>,
        <daniel@iogearbox.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH bpf-next 3/8] tcp: Migrate
 TCP_ESTABLISHED/TCP_SYN_RECV sockets in accept queues.
Message-ID: <20201123003828.xjpjdtk4ygl6tg6h@kafai-mbp.dhcp.thefacebook.com>
References: <20201120015346.sokqxwx4uavmoctz@kafai-mbp.dhcp.thefacebook.com>
 <20201121101322.97015-1-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201121101322.97015-1-kuniyu@amazon.co.jp>
X-Originating-IP: [2620:10d:c090:400::5:3bb5]
X-ClientProxiedBy: MWHPR21CA0066.namprd21.prod.outlook.com
 (2603:10b6:300:db::28) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:3bb5) by MWHPR21CA0066.namprd21.prod.outlook.com (2603:10b6:300:db::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.0 via Frontend Transport; Mon, 23 Nov 2020 00:40:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6d39d142-b538-4704-bb13-08d88f485f20
X-MS-TrafficTypeDiagnostic: BYAPR15MB2774:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2774F44403ECB1C70E399F5BD5FC0@BYAPR15MB2774.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ueTQYHyLCMBtuSS/LLvUoUZ/EWRSrjHkZ6i9Y15eFVMkjrM4N6f9IGUzWxkAWDAxuaCCvbsA7nIaKtioedKQr0x+Y1Lu2DM68heEDPTShcCuFK48cY81P0BLhswGTGfyqSF+uw1z6u7Eskm7WggzI8ExPE4KhcFlIaL2uzHwUcokXceq+vqW5vU3egiIt8EdKASgAmXGCh7jGuER1yadtgBgtzk4aBpoWquz0ST5jgO+8nsM6pCtgIIqmfXk+B8uzwPUgguiOD8D2nIJFumwjEMs3FCa9ZN2PbHSAKan0C4sZ2DgnS0ewdK6G7nuMSd/J1pLmLSTou6qEUaci35qNA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(346002)(366004)(39860400002)(396003)(8676002)(6666004)(16526019)(8936002)(6506007)(186003)(316002)(5660300002)(1076003)(7416002)(4326008)(55016002)(478600001)(83380400001)(7696005)(9686003)(52116002)(66476007)(66556008)(66946007)(86362001)(2906002)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: +i28NUIyR3cSugXfKdVpLq026ZM6avKK5kh+b67AYXA+FHm6cKWKEWLhR6oCAI/nzIQPKLqvAynmHsEJzBYTKEOsO+51zg5UDKqHfznUa2VjCBuG8alZitrlfXHYOgLrtqDaTvJ0et0FqHVYqJ4DmmOR1njXT2+YcgvxVmFydjPgSa9WC4GOIxOxanM9Fn1nAk/KvUF5NQt3Lk1OxCrSMUyCl7k/tc1kOVKjVTCN7xZqWSXsnRC3mpd0bSwPNfS7+5z5XIhdK5u7W7HtM5HFu/W621VRWhUJ2Op53zEQDBi0Kc29FvVD4wWQ3IZa6v47HLRuQ8UsBac7fffWHQ7MRO6o0Da6wSqHyWZfqPEIa54hcVXbwf0TnTO0lBmAhG502gOGl9LdPwj6cT4XBFA5r7end/OOWo5vJVJ23R2kgghWFs0OlB8l4DTP0LmmFKxbRKjEIFpTFxLkf/lgO4YE1nm2aaxJ/IBeeGhL4WFRjXwbbau5lRNQ0YgubHTRmmRkNozrUMw7YvtfWgQP3R+EJulbJuHTdP755xRpgsYbHdGbuH7/g5hZcwUPuAYPMsvAu0JSv+TwJmdRdc2VWvPR9GHFiNjbBqVvZkHT1pItSxe6p7LK6IhSi6SbQnlLzZ/+9azvfO9OvghAi/CaH+6nmJtlaNM1bZISjZW2pMZdNqe+26Pf3Hnks98Ruc/nhxNBJYH2tmcEqZjD1XYIqzzVmaTlNOZAE8kEytugisg+sKqaluS4Q1pH3bvVKdTxbrIu4OC1CBu2WkH2oQA2hCX4mcj/O8dxySincgHiDYi96exixBzLhuxLp962cnFbkbYiPN44uymRZSZK42SQF7DvLOQe4eBouPmxZ0BUq04bA8ypvdibU0bk5g5ZBNRsM85JptXxYW39+/EO7hZ3NmQWKjsky4Zc8YlLe7ZUh3ZQE0M=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d39d142-b538-4704-bb13-08d88f485f20
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2020 00:40:27.2950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sOitREzth3QevsaFioetNo8Y/qbJTJptyTQwaz7pbkGpU4tVNTpZDjBGJA9lXrsT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2774
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-22_16:2020-11-20,2020-11-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 adultscore=0 clxscore=1015 mlxlogscore=999 priorityscore=1501 mlxscore=0
 spamscore=0 suspectscore=1 bulkscore=0 phishscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011230001
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 21, 2020 at 07:13:22PM +0900, Kuniyuki Iwashima wrote:
> From:   Martin KaFai Lau <kafai@fb.com>
> Date:   Thu, 19 Nov 2020 17:53:46 -0800
> > On Fri, Nov 20, 2020 at 07:09:22AM +0900, Kuniyuki Iwashima wrote:
> > > From: Martin KaFai Lau <kafai@fb.com>
> > > Date: Wed, 18 Nov 2020 15:50:17 -0800
> > > > On Tue, Nov 17, 2020 at 06:40:18PM +0900, Kuniyuki Iwashima wrote:
> > > > > This patch lets reuseport_detach_sock() return a pointer of struct sock,
> > > > > which is used only by inet_unhash(). If it is not NULL,
> > > > > inet_csk_reqsk_queue_migrate() migrates TCP_ESTABLISHED/TCP_SYN_RECV
> > > > > sockets from the closing listener to the selected one.
> > > > > 
> > > > > Listening sockets hold incoming connections as a linked list of struct
> > > > > request_sock in the accept queue, and each request has reference to a full
> > > > > socket and its listener. In inet_csk_reqsk_queue_migrate(), we unlink the
> > > > > requests from the closing listener's queue and relink them to the head of
> > > > > the new listener's queue. We do not process each request, so the migration
> > > > > completes in O(1) time complexity. However, in the case of TCP_SYN_RECV
> > > > > sockets, we will take special care in the next commit.
> > > > > 
> > > > > By default, we select the last element of socks[] as the new listener.
> > > > > This behaviour is based on how the kernel moves sockets in socks[].
> > > > > 
> > > > > For example, we call listen() for four sockets (A, B, C, D), and close the
> > > > > first two by turns. The sockets move in socks[] like below. (See also [1])
> > > > > 
> > > > >   socks[0] : A <-.      socks[0] : D          socks[0] : D
> > > > >   socks[1] : B   |  =>  socks[1] : B <-.  =>  socks[1] : C
> > > > >   socks[2] : C   |      socks[2] : C --'
> > > > >   socks[3] : D --'
> > > > > 
> > > > > Then, if C and D have newer settings than A and B, and each socket has a
> > > > > request (a, b, c, d) in their accept queue, we can redistribute old
> > > > > requests evenly to new listeners.
> > > > I don't think it should emphasize/claim there is a specific way that
> > > > the kernel-pick here can redistribute the requests evenly.  It depends on
> > > > how the application close/listen.  The userspace can not expect the
> > > > ordering of socks[] will behave in a certain way.
> > > 
> > > I've expected replacing listeners by generations as a general use case.
> > > But exactly. Users should not expect the undocumented kernel internal.
> > > 
> > > 
> > > > The primary redistribution policy has to depend on BPF which is the
> > > > policy defined by the user based on its application logic (e.g. how
> > > > its binary restart work).  The application (and bpf) knows which one
> > > > is a dying process and can avoid distributing to it.
> > > > 
> > > > The kernel-pick could be an optional fallback but not a must.  If the bpf
> > > > prog is attached, I would even go further to call bpf to redistribute
> > > > regardless of the sysctl, so I think the sysctl is not necessary.
> > > 
> > > I also think it is just an optional fallback, but to pick out a different
> > > listener everytime, choosing the moved socket was reasonable. So the even
> > > redistribution for a specific use case is a side effect of such socket
> > > selection.
> > > 
> > > But, users should decide to use either way:
> > >   (1) let the kernel select a new listener randomly
> > >   (2) select a particular listener by eBPF
> > > 
> > > I will update the commit message like:
> > > The kernel selects a new listener randomly, but as the side effect, it can
> > > redistribute packets evenly for a specific case where an application
> > > replaces listeners by generations.
> > Since there is no feedback on sysctl, so may be something missed
> > in the lines.
> 
> I'm sorry, I have missed this point while thinking about each reply...
> 
> 
> > I don't think this migration logic should depend on a sysctl.
> > At least not when a bpf prog is attached that is capable of doing
> > migration, it is too fragile to ask user to remember to turn on
> > the sysctl before attaching the bpf prog.
> > 
> > Your use case is to primarily based on bpf prog to pick or only based
> > on kernel to do a random pick?
Again, what is your primarily use case?

> 
> I think we have to care about both cases.
> 
> I think we can always enable the migration feature if eBPF prog is not
> attached. On the other hand, if BPF_PROG_TYPE_SK_REUSEPORT prog is attached
> to select a listener by some rules, along updating the kernel,
> redistributing requests without user intention can break the application.
> So, there is something needed to confirm user intension at least if eBPF
> prog is attached.
Right, something being able to tell if the bpf prog can do migration
can confirm the user intention here.  However, this will not be a
sysctl.

A new bpf_attach_type "BPF_SK_REUSEPORT_SELECT_OR_MIGRATE" can be added.
"prog->expected_attach_type == BPF_SK_REUSEPORT_SELECT_OR_MIGRATE"
can be used to decide if migration can be done by the bpf prog.
Although the prog->expected_attach_type has not been checked for
BPF_PROG_TYPE_SK_REUSEPORT, there was an earlier discussion
that the risk of breaking is very small and is acceptable.

Instead of depending on !reuse_md->data to decide if it
is doing migration or not, a clearer signal should be given
to the bpf prog.  A "u8 migration" can be added to "struct sk_reuseport_kern"
(and to "struct sk_reuseport_md" accordingly).  It can tell
the bpf prog that it is doing migration.  It should also tell if it is
migrating a list of established sk(s) or an individual req_sk.
Accessing "reuse_md->migration" should only be allowed for
BPF_SK_REUSEPORT_SELECT_OR_MIGRATE during is_valid_access().

During migration, if skb is not available, an empty skb can be used.
Migration is a slow path and does not happen very often, so it will
be fine even it has to create a temp skb (or may be a static const skb
can be used, not sure but this is implementation details).

> 
> But honestly, I believe such eBPF users can follow this change and
> implement migration eBPF prog if we introduce such a breaking change.
> 
> 
> > Also, IIUC, this sysctl setting sticks at "*reuse", there is no way to
> > change it until all the listening sockets are closed which is exactly
> > the service disruption problem this series is trying to solve here.
> 
> Oh, exactly...
> If we apply this series by live patching, we cannot enable the feature
> without service disruption.
> 
> To enable the migration feature dynamically, how about this logic?
> In this logic, we do not save the sysctl value and check it at each time.
> 
>   1. no eBPF prog attached -> ON
>   2. eBPF prog attached and sysctl is 0 -> OFF
No.  When bpf prog is attached and it clearly signals (expected_attach_type
here) it can do migration, it should not depend on anything else.  It is very
confusing to use.  When a prog is successfully loaded, verified
and attached, it is expected to run.

This sysctl essentially only disables the bpf prog with
type == BPF_PROG_TYPE_SK_REUSEPORT running at a particular point.
This is going down a path that having another sysctl in the future
to disable another bpf prog type.  If there would be a need to disable
bpf prog on a type-by-type bases, it would need a more
generic solution on the bpf side and do it in a consistent way
for all prog types.  It needs a separate and longer discussion.

All behaviors of the BPF_SK_REUSEPORT_SELECT_OR_MIGRATE bpf prog
should not depend on this sysctl at all .

/* Pseudo code to show the idea only.
 * Actual implementation should try to fit
 * better into the current code and should look
 * quite different from here.
 */

if ((prog && prog->expected_attach_type == BPF_SK_REUSEPORT_SELECT_OR_MIGRATE)) {
	/* call bpf to migrate */
	action = BPF_PROG_RUN(prog, &reuse_kern);

	if (action == SK_PASS) {
		if (!reuse_kern.selected_sk)
			/* fallback to kernel random pick */
		else
			/* migrate to reuse_kern.selected_sk */
	} else {
		/* action == SK_DROP. don't do migration at all and
		 * don't fallback to kernel random pick.
		 */ 
	}
}

Going back to the sysctl, with BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
do you still have a need on adding sysctl_tcp_migrate_req?
Regardless, if there is still a need,
the document for sysctl_tcp_migrate_req should be something like:
"the kernel will do a random pick when there is no bpf prog
 attached to the reuseport group...."

[ ps, my reply will be slow in this week. ]

>   3. eBPF prog attached and sysctl is 1 -> ON
> 
> So, replacing 
> 
>   if (reuse->migrate_req)
> 
> to 
> 
>   if (!reuse->prog || net->ipv4.sysctl_tcp_migrate_req)

