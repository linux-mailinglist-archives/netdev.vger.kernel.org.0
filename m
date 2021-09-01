Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7823FE159
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 19:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346635AbhIARqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 13:46:49 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47904 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345760AbhIARqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 13:46:47 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 181HdJZK029260;
        Wed, 1 Sep 2021 10:45:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=CydmOtYzr3whKDycQC8ae8bNi0FAAagERdWSX+WpFQM=;
 b=JKEGPs6FhEZjQEPZqkExX3nRJ9BK+2JPDfTGDGVOeEIxwWqat8K1URh/UXO8RsDbHurQ
 CwRck3Z/AyAC3PfzS+42pzuW4VrE9Czh6lvlIx6kf+afmnyjvPaZccGn/EqPOcomHFKe
 HC7n3I0rwI8qeuEff/kuYY9NteF3OGB4EGw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3ate08r45m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 01 Sep 2021 10:45:47 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Wed, 1 Sep 2021 10:45:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I4X2eTl1qgkom8XcgM4eikX2xGJfP+wS4V0C0sJMBWJV2d6euF0KNmi5Qmlemg+NvoO6g1MFv6eHQQGQZhuVgMjk57dk81VXNO+2G9MMNM5/Ptu3SHm7JCnozocjoqCZ3PwpD5zWXu+SBlAo8jK5ZF9g95rUhUs7Nc5qE40FG7JcGnT/v6U72OObwFT2RYeBQkip1kFOTlliqNrYsThrn087194i5tYWEls6hRwoyy3YlXIeqnsMMR2qgNFfKCshrT/n55rYl/AZgaIlaMpRuMdBR1aq9V5oJgzj2WtXg0/M4tsqOcnZ7oGfBogGhPS8xFJXxucN79egTCht/izR8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=x7k2j2ZtVkFJ/peT35/5IZ2tsRvkJfdX/0KlJcDMRWI=;
 b=HZt2b1y+MThlzyCGFqJxXWYaTo5/u1ZtLGbpXwAEBW6k8A30H1tmomlQYmRT/lp2ZGo71DtiKzsgmkfwIeJEQqYA7ZCM65/rIhiXjp0XrdsYxyDIns4de0brlN78lYJStnE3Y1Axl5ICR72gA+ecIZIdP4eS96BLOx3sKWqI3UoE3+Jv+PxOACF7kAGKDDU1a0bandVsu3BzJHWEEncGX96kacyR/pmo2YIwYXw9Du4IpHoNtaoLqdB7lrIs5v0ODh7hkWKtjY09WPUEug8pdt0s5Yg3QvVFcmTKWQEESuqXg9K+N5+SmdewpgZqJ32ycOfBybg1oldnLF3aotJ5uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA1PR15MB5015.namprd15.prod.outlook.com (2603:10b6:806:1da::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17; Wed, 1 Sep
 2021 17:45:45 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::3c1b:1a10:9708:7e36]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::3c1b:1a10:9708:7e36%7]) with mapi id 15.20.4457.024; Wed, 1 Sep 2021
 17:45:45 +0000
Date:   Wed, 1 Sep 2021 10:45:43 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>
CC:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [RFC Patch net-next] net_sched: introduce eBPF based Qdisc
Message-ID: <20210901174543.xukawl7ylkqzbuax@kafai-mbp.dhcp.thefacebook.com>
References: <20210821010240.10373-1-xiyou.wangcong@gmail.com>
 <20210824234700.qlteie6al3cldcu5@kafai-mbp>
 <CAM_iQpWP_kvE58Z+363n+miTQYPYLn6U4sxMKVaDvuRvjJo_Tg@mail.gmail.com>
 <612f137f4dc5c_152fe20891@john-XPS-13-9370.notmuch>
 <871r68vapw.fsf@toke.dk>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <871r68vapw.fsf@toke.dk>
X-ClientProxiedBy: BYAPR04CA0004.namprd04.prod.outlook.com
 (2603:10b6:a03:40::17) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:1c18) by BYAPR04CA0004.namprd04.prod.outlook.com (2603:10b6:a03:40::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19 via Frontend Transport; Wed, 1 Sep 2021 17:45:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1396ae83-66c8-44fc-61fe-08d96d705357
X-MS-TrafficTypeDiagnostic: SA1PR15MB5015:
X-Microsoft-Antispam-PRVS: <SA1PR15MB5015A61E94F441044770B26ED5CD9@SA1PR15MB5015.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cui0E8EXNHcbXn91kxb/ApRQKuu+fcmkf6kbHH3An0EVcW5iEVMLTE5QiVGBkFtR0Vljs3TML3p4A75lbWW8JFPFyXIKRw88fSpIAl8c7wccj39rrV9/pQsHJ6YQXoLVE0HRbMS1k7M01do+SbIRy9BLk+EDkmIkkPsvLKPOwgOAemtr5SPxZisyIcb7ca49IvsAOd8SEk9NPsxP3R5lvTvc69t6x2pDw7X9B8Jk6hG++X8WruI7vaygkUaQmCqKci60SWYdEVDGZqpyj16armSLYDRsCycsbXFwWVx3w4zDmOW5s1tab0N14qCJ4zbG4ef9l+NPs/TtylEQ2jTBv+3KrUYWYL22g/k22CobuHF0c/NfQaCOTBjsiQj7PjNLzI+kjYA10zyVMpnY+pX2lpOWRF5FzSKYeJsS47gd4PU+iX3fk5+leIhqdTDYbE0RGiQpNco8pKZSD3QRbe49zagz6Xwgg4EZiKYWW/rxp6E1vLXuESc1xrH8+7eojqMnZnU3Sp3FAuY0C1RW2I27YrMZpiXlPUIiIGrqhQKAEVuBED56N2yIvJ3Qx2hyvI2wtDmvyG62AWO17rYJNeVzz11Hy+0v+D0+jrjiMtydZZiDxo8EOHYfikCmiagxmgg894FzoEt2xhSrzfrLCnMIcg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(9686003)(38100700002)(110136005)(54906003)(55016002)(86362001)(66574015)(83380400001)(508600001)(6506007)(8936002)(8676002)(2906002)(53546011)(1076003)(66946007)(186003)(52116002)(7696005)(4326008)(66556008)(5660300002)(316002)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?m6M5wwIXhKHaj0DjxtKBm38F0mMAv7+oIO4pmo1mqSCX9xsrep702wVYBm?=
 =?iso-8859-1?Q?Wk1vnJ8fv2SRnKyK2XRTQhmrvoW/yWwntuDv7V5b8fC9tHbcgD3ohU9UuV?=
 =?iso-8859-1?Q?IE37/d2slqFm+0Ovc801UM9YnfdINOQ+OBdZouuhWmEeLbt65j+zGfBoZF?=
 =?iso-8859-1?Q?sOBp2HcTv6lI7CjL9AusyrCrZrr2PcD9X3KDUde0nMnlFImDcWLz+uyoyr?=
 =?iso-8859-1?Q?P+JD+zReTVrl8twygbL7lp7Wm0kC/B14vi3hIes9iJYPo5F1jh89opjl/Q?=
 =?iso-8859-1?Q?a4PskJrzy1POA6KIKXynSHV9wMau+qx1p8LOe9vVFCcLysTL2JwLha8Pld?=
 =?iso-8859-1?Q?MKMwRapyq9YwsL5i2RzbPS8lkr9uZNDQr8wsRhEZJ6skO6JvjGtySUcMdK?=
 =?iso-8859-1?Q?obgQ9u+MOVxNIdUexvdm6HPr2SDxhfCqhaqK/bzWFfiRDv8PUsIcS65yd5?=
 =?iso-8859-1?Q?dY1oY8CdQ0D//zV2Gh2NIs+sJP2v4qRY0r4SzG5hJkXpQa8YsbCb8p1BjO?=
 =?iso-8859-1?Q?oJFBXX4wyJxOOMUrd0e4js57SAdvT8RtUfJ8fssa1rRfv+J7sboPJKsH0h?=
 =?iso-8859-1?Q?LTCkREJElV+gZdGpMzfh3OxV9pVlzefjKmRUdlZci6mKnD86XbdEsr9HtD?=
 =?iso-8859-1?Q?CQcnyF1qgcZN/NNuLNoNAtgS00UrdvBLmLjk1orBQgsmYs1mEajQI86UYX?=
 =?iso-8859-1?Q?/XLG/I2SO20K/sUYM5giMBoJw3/MpXGeHLeCoUddRoij+xdStUDXMai5OX?=
 =?iso-8859-1?Q?ihJtbX939XItDLrzE2Uga8g737+J8Pd+YIuSnrwd4NC0LXqGuFkJNMvqHS?=
 =?iso-8859-1?Q?eXPUxzKA7/PUd+BF66F/UEZ5XTJy5wYBEs0DjiVPjCXeTaVoA1wgjmHfrv?=
 =?iso-8859-1?Q?07HT4Sgr5ekOHFBGo0AIL+LmR4TDb8YV16i7B87Xf4R0WjMsZkSM539OLJ?=
 =?iso-8859-1?Q?CyTNaNrVgKRWpSAPHTFcEEqyquMTV/aUUsO+7SXLWXXRzk5EuDLn1t2rB3?=
 =?iso-8859-1?Q?PiADV30HH1cfqE+qypEllTK6wtOqCqL985SuXyGrcV2U7Q+HX9ZS3x3Njw?=
 =?iso-8859-1?Q?lMKmHEHM0KOc1eug3YqNqjegg2ub94bnauLMCptgycDmDEQB1r4zUF0px0?=
 =?iso-8859-1?Q?qXw9EYL1t6QXNFOl4Z2spOGO5r6HlntWiJszDoItw5JYIeMh9mRuJKl20F?=
 =?iso-8859-1?Q?FYVZegsttYIRdbcuuYluyjdSiNzzCjbe4qsNilBgeAmJd7w11DAIxxfQt+?=
 =?iso-8859-1?Q?aU6LEC9rasJcyhvg7tODQL1Mi21d02g5T3qGNs6OrqVRJoPaQ3gM87sMXT?=
 =?iso-8859-1?Q?ljocgMgisZDz4aFCFG2BNC1nCUPRfU8qAyFno+XXJOqsRS4hYSW0AMAADv?=
 =?iso-8859-1?Q?j2EWPVW4WjiJAPQfQ46DcuRs2TVh9XYw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1396ae83-66c8-44fc-61fe-08d96d705357
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2021 17:45:45.4244
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jK5bb+JitljvO7kuwmYFdKb9zvs620VxV4yfTDhZS5NItfuyd6DSmspNo46TaKOU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5015
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: wzco70C3cl4Jz9FkOyUeTiNVgleJkWmY
X-Proofpoint-ORIG-GUID: wzco70C3cl4Jz9FkOyUeTiNVgleJkWmY
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-01_05:2021-09-01,2021-09-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 priorityscore=1501 phishscore=0 clxscore=1015 impostorscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2108310000 definitions=main-2109010101
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 01, 2021 at 12:42:03PM +0200, Toke Høiland-Jørgensen wrote:
> John Fastabend <john.fastabend@gmail.com> writes:
> 
> > Cong Wang wrote:
> >> On Tue, Aug 24, 2021 at 4:47 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >> > Please explain more on this.  What is currently missing
> >> > to make qdisc in struct_ops possible?
> >> 
> >> I think you misunderstand this point. The reason why I avoid it is
> >> _not_ anything is missing, quite oppositely, it is because it requires
> >> a lot of work to implement a Qdisc with struct_ops approach, literally
> >> all those struct Qdisc_ops (not to mention struct Qdisc_class_ops).
> >> WIth current approach, programmers only need to implement two
> >> eBPF programs (enqueue and dequeue).
_if_ it is using as a qdisc object/interface,
the patch "looks" easier because it obscures some of the ops/interface
from the bpf user.  The user will eventually ask for more flexibility
and then an on-par interface as the kernel's qdisc.  If there are some
common 'ops', the common bpf code can be shared as a library in userspace
or there is also kfunc call to call into the kernel implementation.
For existing kernel qdisc author,  it will be easier to use the same
interface also.

> > Another idea. Rather than work with qdisc objects which creates all
> > these issues with how to work with existing interfaces, filters, etc.
> > Why not create an sk_buff map? Then this can be used from the existing
> > egress/ingress hooks independent of the actual qdisc being used.
> 
> I agree. In fact, I'm working on doing just this for XDP, and I see no
> reason why the map type couldn't be reused for skbs as well. Doing it
> this way has a couple of benefits:
> 
> - It leaves more flexibility to BPF: want a simple FIFO queue? just
>   implement that with a single queue map. Or do you want to build a full
>   hierarchical queueing structure? Just instantiate as many queue maps
>   as you need to achieve this. Etc.
Agree.  Regardless how the interface may look like,
I even think being able to queue/dequeue an skb into different bpf maps
should be the first thing to do here.  Looking forward to your patches.

> 
> - The behaviour is defined entirely by BPF program behaviour, and does
>   not require setting up a qdisc hierarchy in addition to writing BPF
>   code.
Interesting idea.  If it does not need to use the qdisc object/interface
and be able to do the qdisc hierarchy setup in a programmable way, it may
be nice.  It will be useful for the future patches to come with some
bpf prog examples to do that.

> 
> - It should be possible to structure the hooks in a way that allows
>   reusing queueing algorithm implementations between the qdisc and XDP
>   layers.
> 
> > You mention skb should not be exposed to userspace? Why? Whats the
> > reason for this? Anyways we can make kernel only maps if we want or
> > scrub the data before passing it to userspace. We do this already in
> > some cases.
> 
> Yup, that's my approach as well.
> 
> > IMO it seems cleaner and more general to allow sk_buffs
> > to be stored in maps and pulled back out later for enqueue/dequeue.
> 
> FWIW there's some gnarly details here (for instance, we need to make
> sure the BPF program doesn't leak packet references after they are
> dequeued from the map). My idea is to use a scheme similar to what we do
> for XDP_REDIRECT, where a helper sets some hidden variables and doesn't
> actually remove the packet from the queue until the BPF program exits
> (so the kernel can make sure things are accounted correctly).
The verifier is tracking the sk's references.  Can it be reused to
track the skb's reference?

> 
> > I think one trick might be how to trigger the dequeue event on
> > transition from stopped to running net_device or other events like
> > this, but that could be solved with another program attached to
> > those events to kick the dequeue logic.
> 
> This is actually easy in the qdisc case, I think: there's already a
> qdisc_dequeue() operation, which just needs to execute a BPF program
> that picks which packet to dequeue (by pulling it off a queue map). For
> XDP we do need a new hook, on driver TX completion or something like
> that. Details TBD. Also, we need a way to BPF to kick an idle interface
> and make it start transmitting; that way we can implement a traffic
> shaper (that delays packets) by using BPF timers :)
> 
> -Toke
> 
