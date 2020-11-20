Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9F92BA00C
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 02:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbgKTByQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 20:54:16 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45962 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726540AbgKTByP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 20:54:15 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0AK1rE1j024445;
        Thu, 19 Nov 2020 17:53:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=FH2sKks99ZisUxgYeEnGfbrTQznVc/jfMVDWFkykQDI=;
 b=kzmo8kiP10ZbD55P3nJp9sA1WJ56Sfj0QVegQcRmhacuhe45CPCC2FCWzapugcbVY4xg
 nMS9HfvRwFPBy2jBDQrjSCsL6uLdTe5c1JEsfsd5CjMtsYxwLITj2ilaOQ0RxJa/Ko2Z
 cJlgg0N1YN1UY/4Yc6xW6oD2eYMJwDKIM2M= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 34whfkr7x4-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 19 Nov 2020 17:53:56 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 19 Nov 2020 17:53:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DdK8bPGyAZVmqZm4Ummiik9SbWMv90kLNUo+XcsN17n8B5XJdeG7iystbpXesBcsmca3MdAms2T4fpEbLO59pUnVeLXFbiQgO57Ul71q6L62K4Yz2Riv9rX41/zjQei49mrpCHxSV4nMqzMnPGUX1XpB6UhgttSueJ+5OMgZx1Bu3mcxyCApct6RqNtSTrS2iyKcty/6Ssy5QXGFWDAhpgA+vpXwG1j1Jku1dmg9W/aSJKhwEwr9Voad7SGhNeuKRzMpKJcRutSyV00DdW2KUg4MOG0Cz/3Ic3BzzDuSK36sh1IjYoxrgCGK995d1GjtMlEqPEOxUR1oZhwqchSbjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FH2sKks99ZisUxgYeEnGfbrTQznVc/jfMVDWFkykQDI=;
 b=fTk7fT3sg8/IKQNkfJ3ffsNp1lYnC/dUsYPcZz9EifPQP57Segj9Afa6ReyMDX0r6eSmfAq1xBizANB9Swmas4P8HvNGVih6G0FTIu2KqlWBqM6416alKSY0m1XTTLDLDCqgXahDyxwM0cIm44J8GkNG+DgT5iwYbLFo7nnGllJSIxobexQD4r/0hpWRub8+cTS5b/DjYqOfMVGtl0hv1/yQUx4CeTAqAqApSGyvyDDg+fv59UWWeeSxlH+ohixZij2NZ2yAdh5LWAiOskNRKuisX6Y3pHrp/zORi/OILCK87qdIrlijGJlmGsgUwiHUhhzeTPMyGvMYdGG9acv2tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FH2sKks99ZisUxgYeEnGfbrTQznVc/jfMVDWFkykQDI=;
 b=GcN+6zDAFZjK1lougyR76SH5wsKFaSX1jaVCXa4unDJ1xiBPSh+1tvfjFTGU6Qbl1O/ZwNcirZrBjekO75DMXnuUbIWUXGw7dnIIq1bIE+JZTS7kwG/ViTPA+eKoaKYaInF+8b/Lvg6UTCOdfo+ANY2622lsPBSyFq1r6Whxw1Y=
Authentication-Results: amazon.co.jp; dkim=none (message not signed)
 header.d=none;amazon.co.jp; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2246.namprd15.prod.outlook.com (2603:10b6:a02:8d::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28; Fri, 20 Nov
 2020 01:53:53 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee%4]) with mapi id 15.20.3564.034; Fri, 20 Nov 2020
 01:53:53 +0000
Date:   Thu, 19 Nov 2020 17:53:46 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
CC:     <ast@kernel.org>, <benh@amazon.com>, <bpf@vger.kernel.org>,
        <daniel@iogearbox.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH bpf-next 3/8] tcp: Migrate
 TCP_ESTABLISHED/TCP_SYN_RECV sockets in accept queues.
Message-ID: <20201120015346.sokqxwx4uavmoctz@kafai-mbp.dhcp.thefacebook.com>
References: <20201118235017.xrudgf6bfwgkaukh@kafai-mbp.dhcp.thefacebook.com>
 <20201119220922.75145-1-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201119220922.75145-1-kuniyu@amazon.co.jp>
X-Originating-IP: [2620:10d:c090:400::5:603e]
X-ClientProxiedBy: CO2PR18CA0050.namprd18.prod.outlook.com
 (2603:10b6:104:2::18) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:603e) by CO2PR18CA0050.namprd18.prod.outlook.com (2603:10b6:104:2::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Fri, 20 Nov 2020 01:53:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b169f02-dd9f-4341-2243-08d88cf721f0
X-MS-TrafficTypeDiagnostic: BYAPR15MB2246:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2246B81C24FF5047215C81B6D5FF0@BYAPR15MB2246.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0cx9lZfrjyzctT5hkF8YfslZt1OvWoLHkQPnmwhgqMnOtmzqth9O/KBbpVmP8XR6c5hH2tjuq6MM+Zm7Qq8KXxFdRkHlbLLyE0Fd4lbwqvfOzbC5rfbKkd6Md2hF7p3XU+2/KGFuoRycPRdEloPaz5Inq4PhdGGnZ+iB8EwDkfPHU6xwAY7MuRrbmBqOCTuedW7T3LGQ9B+fF2wvRtRw3uqbyI+DoBXEPzcMXDx3ZTU4hByEm/JUws9RiOLj5qRoYbW5raUmHOGOLS2i3jWedWcWunhB2F/Irdq96KJS/UNX5xewAah7GptkCVGeXvLQxWy2T/uWioMSjE4BfVWoLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(376002)(396003)(346002)(136003)(2906002)(66946007)(52116002)(16526019)(8936002)(186003)(83380400001)(8676002)(7696005)(9686003)(66476007)(1076003)(5660300002)(6506007)(66556008)(55016002)(7416002)(4326008)(316002)(86362001)(478600001)(6666004)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 3AB71ChZs2+oxch7Id2EtBUTmjQcC9jgn6yNhgB9KY0IoT+EeU4CsvHzkndZnr0k/Fg6YAuJtWiF26+ReeRfuO0dOWDShh4KqYxdYNUqwZOwByd4PNaPBeLrgFZdyieXTeBH4pqaSoui9xw1orJm/huXsVyd8DJe1fcIz6d8mAIVH0VGi8q0VFWBnGpq9edUapVhRAIZI3eblSWBN8fS41ll73cUyCTIKhwTQCdwcwjaSgghZBeAezk2pfcKchKQhZqEJTgkI2ZD8LyZSbjKT8ukc/r6cjPeah1ux9ROAXJZJCvMODsmeI23L7mlKDLOD36r75DTs0+CgUR2nERtLxEBqyq6dHx4BuzoQY3fo73bh+deaJOpIa1TbsMld1Vk7yXbo/YbVTO1CXHw8kUwAjnOx0tD9SBcKl5eYrAE3j9qjSb5ae7J4ueu/orjeZ+KEOTULROHQUtDLUbAraQbh8I6Kc3trLKrtwBjgdTsx+jxxOO3HpVjw4qbj9cCqA7H0AdjAqKOw2or4JCjgDmHBtIeYTJxy3q0gqdvlsEzZG8t38iQtLn2Eo2R4GOR/cQhLIArR6XjSE4g1PZCyZGkvJ7Gzcb6t+JRhSTcSVTHzDkMoljuxRq/r++gP0sttJySI8hr5U5JeY3kfIFfEIZkymhNE+hrSxXzDgbQK0R+/SV54dAj8zx9rjyhtGD4SBKixFP931XxawKBcSRnnePlaMbgkaPKgDUMXyEf2MYMrJNr8rXn0Wp+PQyDqPsz5mY5MyOrGpJxhd8w9AR85Ify481UHGTpPXMQ5ESfB5BN3Vgeewx6MZCtIayuFO7rWwz5IToOntpYSaYMd81/YOQ14FJ0jvH0P13VWYy0iHaZPca5cwNx3L7711YW6KgBPXPH5EatHAd6FwSmY3+Ybz/k5WlVzudq9e4QCpqCUBUr22Q=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b169f02-dd9f-4341-2243-08d88cf721f0
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2020 01:53:53.0939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2OPAt/VxUOR3nNnsPH/M164HHOcsuMmSAEEEsgXNne8A4G6jKCuLAUQ3ToaqdxV0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2246
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-19_14:2020-11-19,2020-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 malwarescore=0 phishscore=0 suspectscore=1 priorityscore=1501
 impostorscore=0 mlxlogscore=999 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200012
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 20, 2020 at 07:09:22AM +0900, Kuniyuki Iwashima wrote:
> From: Martin KaFai Lau <kafai@fb.com>
> Date: Wed, 18 Nov 2020 15:50:17 -0800
> > On Tue, Nov 17, 2020 at 06:40:18PM +0900, Kuniyuki Iwashima wrote:
> > > This patch lets reuseport_detach_sock() return a pointer of struct sock,
> > > which is used only by inet_unhash(). If it is not NULL,
> > > inet_csk_reqsk_queue_migrate() migrates TCP_ESTABLISHED/TCP_SYN_RECV
> > > sockets from the closing listener to the selected one.
> > > 
> > > Listening sockets hold incoming connections as a linked list of struct
> > > request_sock in the accept queue, and each request has reference to a full
> > > socket and its listener. In inet_csk_reqsk_queue_migrate(), we unlink the
> > > requests from the closing listener's queue and relink them to the head of
> > > the new listener's queue. We do not process each request, so the migration
> > > completes in O(1) time complexity. However, in the case of TCP_SYN_RECV
> > > sockets, we will take special care in the next commit.
> > > 
> > > By default, we select the last element of socks[] as the new listener.
> > > This behaviour is based on how the kernel moves sockets in socks[].
> > > 
> > > For example, we call listen() for four sockets (A, B, C, D), and close the
> > > first two by turns. The sockets move in socks[] like below. (See also [1])
> > > 
> > >   socks[0] : A <-.      socks[0] : D          socks[0] : D
> > >   socks[1] : B   |  =>  socks[1] : B <-.  =>  socks[1] : C
> > >   socks[2] : C   |      socks[2] : C --'
> > >   socks[3] : D --'
> > > 
> > > Then, if C and D have newer settings than A and B, and each socket has a
> > > request (a, b, c, d) in their accept queue, we can redistribute old
> > > requests evenly to new listeners.
> > I don't think it should emphasize/claim there is a specific way that
> > the kernel-pick here can redistribute the requests evenly.  It depends on
> > how the application close/listen.  The userspace can not expect the
> > ordering of socks[] will behave in a certain way.
> 
> I've expected replacing listeners by generations as a general use case.
> But exactly. Users should not expect the undocumented kernel internal.
> 
> 
> > The primary redistribution policy has to depend on BPF which is the
> > policy defined by the user based on its application logic (e.g. how
> > its binary restart work).  The application (and bpf) knows which one
> > is a dying process and can avoid distributing to it.
> > 
> > The kernel-pick could be an optional fallback but not a must.  If the bpf
> > prog is attached, I would even go further to call bpf to redistribute
> > regardless of the sysctl, so I think the sysctl is not necessary.
> 
> I also think it is just an optional fallback, but to pick out a different
> listener everytime, choosing the moved socket was reasonable. So the even
> redistribution for a specific use case is a side effect of such socket
> selection.
> 
> But, users should decide to use either way:
>   (1) let the kernel select a new listener randomly
>   (2) select a particular listener by eBPF
> 
> I will update the commit message like:
> The kernel selects a new listener randomly, but as the side effect, it can
> redistribute packets evenly for a specific case where an application
> replaces listeners by generations.
Since there is no feedback on sysctl, so may be something missed
in the lines.

I don't think this migration logic should depend on a sysctl.
At least not when a bpf prog is attached that is capable of doing
migration, it is too fragile to ask user to remember to turn on
the sysctl before attaching the bpf prog.

Your use case is to primarily based on bpf prog to pick or only based
on kernel to do a random pick?

Also, IIUC, this sysctl setting sticks at "*reuse", there is no way to
change it until all the listening sockets are closed which is exactly
the service disruption problem this series is trying to solve here.
