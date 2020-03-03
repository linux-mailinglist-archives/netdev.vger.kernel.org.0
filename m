Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F291E1769CD
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 02:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgCCBDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 20:03:43 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34614 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726773AbgCCBDn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 20:03:43 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02311gM9026708;
        Mon, 2 Mar 2020 17:03:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=aEFd3nVfZROp+u31NXpAQdz/m3p4g4R/9NQdP3qwanY=;
 b=OPSjXWtOTzlD2KUCwgvU4BvhW98ZCmSqy2CV8qFHXFJA9ElzIPzhwHGCrW2sIBb4Ityv
 q+uiHgBHafRALSDVeoHyupOS4qeTa53H+7PFmqA2xtzdCCp76qvfMqKxLsizmawz3Qf9
 qrfvEvZkgGBwrKkaAMxxkkO/961SUkVBJ10= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yg8dcyy5b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 02 Mar 2020 17:03:24 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Mon, 2 Mar 2020 17:03:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kad1TR3Zhtk1KRC+NO/yt4pXBSRBZelXmqOCS+IvyXBHOz+QU4hKpXYhG6bL5SIlDvd2f1N4bRSgGcGUW/zF2kYGOSvSGum6lO7BhNtBrdYLRNT31KlTgGF1N8lBNjHkKNPUnyca4RxECAoU+wLlIHLx/7snSE4jrtD/aWXPaT+Wm8p0+LRCcYDMJa3T0phx1/ZD24MCXvQqa3UB66y2f8K8Xhb2sJ8O28pg1zi+1DoAwtfM+dj+Gz/jTRJVBAZqlP1WA3KWzO+uBNr+66MhOFJSThXmPyX8+diGGj9VU846tJKiu0ji8HZopGoqYzUPi8DutJI+r+CIgqzH3UwlDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aEFd3nVfZROp+u31NXpAQdz/m3p4g4R/9NQdP3qwanY=;
 b=XTGCKVvGjAG7Tx+I20K1TeywYGke0yNzHaLbgUg7ztMiVRVIKiAM5il/E41fXMQn1Hv330JHnohjSb1e2jOeS0buBTISfb6/pDT5Aoto7xzrv82P0MfSS2mVRDj8CH64jSILrfbKZRDhTyDbJAr98o5gi7MP7xpBWO6ar3pWo9z52Aar2T7LjZuSlV6lmYmp0o1sznn57gNCAaayp2jfnVOSQN/EmlM4IVyfPVq8/Mk5zhlT6HYWkI/knmm3e9QEEwkL1LmbA9OKzJy/T+V3mPVqMYo8Ui91wIk6noMniHr8mFSQ0sO6hfeDVPQWlOaovFc4mQnGxmPSr87fUIZMDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aEFd3nVfZROp+u31NXpAQdz/m3p4g4R/9NQdP3qwanY=;
 b=C/PBGNkdM7yaZTggfZd398DrtFa0i8Ci+uQDVk8chy/wCTQMMD8q3e3EiIJNzH27eJc3THfMi/DZCYNaCCFxZYIFL8DiFHSAlXAVuTdJoUX2TiKDcn/36+tWLfHvdRrMLWg+qbpa9H0+umtE6pLZVyVNpM73YVfZM/IsK2oo4Mg=
Received: from MWHPR15MB1294.namprd15.prod.outlook.com (2603:10b6:320:25::22)
 by MWHPR15MB1454.namprd15.prod.outlook.com (2603:10b6:300:be::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15; Tue, 3 Mar
 2020 01:03:21 +0000
Received: from MWHPR15MB1294.namprd15.prod.outlook.com
 ([fe80::b47a:a4d2:b9dd:eb1e]) by MWHPR15MB1294.namprd15.prod.outlook.com
 ([fe80::b47a:a4d2:b9dd:eb1e%5]) with mapi id 15.20.2772.019; Tue, 3 Mar 2020
 01:03:21 +0000
Date:   Mon, 2 Mar 2020 17:03:18 -0800
From:   Andrey Ignatov <rdna@fb.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <ctakshak@fb.com>
Subject: Re: [PATCH RFC] Userspace library for handling multiple XDP programs
 on an interface
Message-ID: <20200303010318.GB84713@rdna-mbp>
References: <158289973977.337029.3637846294079508848.stgit@toke.dk>
 <20200228221519.GE51456@rdna-mbp>
 <87v9npu1cg.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87v9npu1cg.fsf@toke.dk>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-ClientProxiedBy: MW2PR2101CA0018.namprd21.prod.outlook.com
 (2603:10b6:302:1::31) To MWHPR15MB1294.namprd15.prod.outlook.com
 (2603:10b6:320:25::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2620:10d:c090:500::4:fbfe) by MW2PR2101CA0018.namprd21.prod.outlook.com (2603:10b6:302:1::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.1 via Frontend Transport; Tue, 3 Mar 2020 01:03:20 +0000
X-Originating-IP: [2620:10d:c090:500::4:fbfe]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ba3b4559-9d97-4d79-5ad0-08d7bf0eaa9a
X-MS-TrafficTypeDiagnostic: MWHPR15MB1454:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR15MB1454E5EDF980BE07F8232115A8E40@MWHPR15MB1454.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 03319F6FEF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(7916004)(39860400002)(396003)(376002)(346002)(136003)(366004)(199004)(189003)(66476007)(7416002)(8936002)(1076003)(66574012)(2906002)(6916009)(66946007)(66556008)(8676002)(33656002)(86362001)(52116002)(5660300002)(6496006)(478600001)(9686003)(81166006)(4326008)(16526019)(81156014)(186003)(6486002)(316002)(33716001)(54906003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1454;H:MWHPR15MB1294.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XgoIeX8gADNkkfg+B51Km34rlkwoLkG0p0Dcby01iJE7SVwYBJAckLNCQSAQLQ6zME/hjmWZA8lT37bEYrvwnh59fM3e3mYerKMDNBa6iEgcGZs3G75nndvB95KI9fnfrG329qI1LNb02v7SXaW279ew5kgBsudluOI9AdRAHxL7JQS5UXjaROcfktoh1rzeDm2MI4wEsihnHRyfGdaFvXU3IZoKkNyish0dllWgUUNhqerRtKbT9gOm9+cHwDbmCT95GutGEP2FPluFZpOHxeGPuto0pBa4LJBAfOHvIGsFBLWs+1ny/q7sGWlmkY/PHqTR0TSIxE35rSFnc99gsaTBSFWV8gl2SRMOASnRo65066RHPJ8Btyso46CaBFabsMU9SNNRFmgUskwjPskTXVNTjVTVtOuSe60mMxOJfYyaRjOkDMrzeHyvpLb1KWvK
X-MS-Exchange-AntiSpam-MessageData: l/34ouiYa4opPZTP29LUA0Zxd19dTJ2yPMMuzxaS+kCEgKnskfa16h3A4jnVcU5igi4H4cATNSGzjBbHu+sBWDR/vFsrCf771h/6VEduH22awcv3DrSjy0N7nnRrSu/zk+5nySCOSsp2cBow5MOB+4ybPU+y9VT7gwBC2nZi8c8OTUfRstqJSqHQGVTOJ7Tw
X-MS-Exchange-CrossTenant-Network-Message-Id: ba3b4559-9d97-4d79-5ad0-08d7bf0eaa9a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2020 01:03:21.2452
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5B0P/Il9cEWKSsOxrvMwtSQN0fUPlcJ8bNlt4mUa3pyxkr2g2tyPlktHx+IfHSYJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1454
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-02_09:2020-03-02,2020-03-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 clxscore=1015 priorityscore=1501 suspectscore=0 phishscore=0
 malwarescore=0 impostorscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003030004
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke Høiland-Jørgensen <toke@redhat.com> [Sat, 2020-02-29 02:36 -0800]:
> Andrey Ignatov <rdna@fb.com> writes:
> 
> > The main challenges I see for applying this approach in fb case is the
> > need to recreate the dispatcher every time a new program has to be
> > added.
> >
> > Imagine there there are a few containers and every container wants to
> > run an application that attaches XDP program to the "dispatcher" via
> > freplace. Every application may have a "priority" reserved for it, but
> > recreating the dispatcher may have race condition, for example:
> 
> Yeah, I did realise this is potentially racy, but so is any loading of
> XDP programs right now (i.e., two applications can both try loading a
> single XDP program at the same time, and end up stomping on each others'
> feet). So we'll need to solve that in any case. I've managed to come up
> with two possible ways to solve this:
> 
> 1. Locking: Make it possible for a process to temporarily lock the
> XDP program loaded onto an interface so no other program can modify it
> until the lock is released.
> 
> 2. A cmpxchg operation: Add a new field to the XDP load netlink message
> containing an fd of the old program that the load call is expecting to
> replace. I.e., instead of attach(ifindex, prog_fd, flags), you have
> attach(ifindex, prog_fd, old_fd, flags). The kernel can then check that
> the old_fd matches the program currently loaded before replacing
> anything, and reject the operation otherwise.
> 
> With either of these mechanisms it should be possible for userspace to
> do the right thing if the kernel state changes underneath it. I'm
> leaning towards (2) because I think it is simpler to implement and
> doesn't require any new state be kept in the kernel.

Yep, that will solve the race.

(2) sounds good to me, in fact I did similar thing for cgroup-bpf in:

7dd68b3279f1 ("bpf: Support replacing cgroup-bpf program in MULTI mode")

where user can pass replace_bpf_fd and BPF_F_REPLACE flag and it
guarantees that the program, users wants, will be replaced, not a new
program that was attached by somebody else just a moment ago.


> The drawback is
> that it may lead to a lot of retries if many processes are trying to
> load their programs at the same time. Some data would be good here: How
> often do you expect programs to be loaded/unloaded in your use case?


In the case I mentioned it's more about having multiple applications
that may start/restart at the same time, not about frequency. It'll be a
few (one digit number) apps, what means having a few retries should be
fine if "the old program doesn't exist" can be detected easily (e.g.
ENOENT should work) not to do retry for errors that are obviously
unrelated to the race condition.


> As for your other suggestion:
> 
> > Also I see at least one other way to do it w/o regenerating dispatcher
> > every time:
> >
> > It can be created and attached once with "big enough" number of slots,
> > for example with 100 and programs may use use their corresponding slot
> > to freplace w/o regenerating the dispatcher. Having those big number of
> > no-op slots should not be a big deal from what I understand and kernel
> > can optimize it.
> 
> I thought about having the dispatcher stay around for longer, and just
> replacing more function slots as new programs are added/removed. The
> reason I didn't go with this is the following: Modifying the dispatcher
> while it is loaded means that the modifications will apply to traffic on
> the interface immediately. This is fine for simple add/remove of a
> single program, but it limits which operations you can do atomically.
> E.g., you can't switch the order of two programs, or add or remove more
> than one, in a way that is atomic from the PoV of the traffic on the
> interface.

Right, simple add/remove cases is the only ones I've seen so far since
programs are usually more or less independent and they just should be
chained properly w/o anything like "order of programs should be changed
atomically" or "two programs must be enabled atomically".

But okay, I can imagine that this may happen in the wild. In this case
yes, full regeneration of the dispatcher looks like the option ..


> Since I expect that we will need to support atomic operations even for
> these more complex cases, that means we'll need to support rebuilding
> the dispatcher anyway, and solving the race condition problem for that.
> And once we've done that, the simple add/remove in the existing
> dispatcher becomes just an additional code path that we'll need to
> maintain, so why bother? :)
> 
> I am also not sure it's as simple as you say for the kernel to optimise
> a more complex dispatcher: The current dead code elimination relies on
> map data being frozen at verification time, so it's not applicable to
> optimising a dispatcher as it is being changed later. Now, this could
> probably be fixed and/or we could try doing clever tricks with the flow
> control in the dispatcher program itself. But again, why bother if we
> have to support the dispatcher rebuild mode of operation anyway?

Yeah, having the ability to regenerate the full dispatcher helps to
avoid dealing with those no-ops programs.

This kinda solves another problem of allocating positions in the list of
noop_fun1, noop_func2, ..., noop_funcN, since the N is limited and
keeping "enough space" between existing programs to be able to attach
something else between them in the future can be challenging in general
case.

> I may have missed something, of course, so feel free to point out if you
> see anything wrong with my reasoning above!
> 
> > This is the main thing so far, I'll likely provide more feedback when
> > have some more time to read the code ..
> 
> Sounds good! You're already being very helpful, so thank you! :)

I've spent more time reading the library and like the static global data
idea that allows to "regenerate" dispatcher w/o actually recompiling it
so that it can still be compiled once and distributed to all relevant
hosts.  It simplifies a bunch of things discussed above.

But this part in the "missing pieces":

> > - There is no way to re-attach an already loaded program to another function;
> >   this is needed for updating the call sequence: When a new program is loaded,
> >   libxdp should get the existing list of component programs on the interface and
> >   insert the new one into the chain in the appropriate place. To do this it
> >   needs to build a new dispatcher and reattach all the old programs to it.
> >   Ideally, this should be doable without detaching them from the old dispatcher;
> >   that way, we can build the new dispatcher completely, and atomically replace
> >   it on the interface by the usual XDP attach mechanism.

seems to be "must-have", including the "Ideally" section, since IMO
simply adding a new program should not interrupt what previously
attached programs are doing.

If there is a container A that attached progA to dispatcher some time
ago, and then container B is regenerating dispatcher to add progB, that
shouldn't stop progA from being executed even for short period of time
since for some programs it's just no-go (e.g. if progA is a firewall and
disabling it would mean allowing traffic that otherwise is denied).

I'm not the one who can answer the question how hard would it be to
support this kind of "re-attaching" on kernel side and curios myself. I
do see though that current implementation of ext programs has a single
(prog->aux->linked_prog, prog->aux->attach_btf_id) pair.

Also it's not clear what to do with fd returned by
bpf_tracing_prog_attach (whether it can be pined or not), e.g. if
container A generated dispatcher with ext progA attached to it and got
this "link" fd, but then dispatcher was regenerated and the progA was
reattached to the new dispatcher, how to make sure that the "link" fd is
still the right one and cleanup will happen when a process in container
A closes the fd it has (or unpins corresponding file in bpf fs).


-- 
Andrey Ignatov
