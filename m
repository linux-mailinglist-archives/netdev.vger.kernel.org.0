Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95AF219024E
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 00:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbgCWXzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 19:55:06 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:31746 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727234AbgCWXzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 19:55:06 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02NNkphu022271;
        Mon, 23 Mar 2020 16:54:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=Xs+DBXGJ8Nqd6jYjH0KFEex+F3pvtcrQreifwC8tohM=;
 b=gZyPUIukAIKDuFvr+Lslp2SGBfhBVuxG62l2/lR+YubDaoTEZMV5aujP1FrRk7w9arWS
 t5CeVy1KEqWsI7pKiTi1gZTs6CRkPqNr+nANu0+Ah6sEqJ5RuOEBTFa+0r64ppdvK/Ew
 ZWBk72GRRo2/peabaKRWZ66vKv+ViSKqg1E= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2yx32wfvmf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 23 Mar 2020 16:54:49 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 23 Mar 2020 16:54:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XUe6rzT/zRHJsX6y57dFAIuLiE3fsi8iCjmgKQtPfhfR/ZT6CNBzMQpgPo39V6bo6HjQJhdTGBQ7kWP+N9kFsMEfCxa5ADRPYbVuC3gPsuWRLXtX7n2F1ODoB+Ckkpx8WF4YbO5Dq+IuC5UfKwvd6Jdfh5GYiHFedMoJLqr5t1Oe3oDdoHEl2C0yuT1to3XEpf6rx/Le4s7VVQKvANZRJV4VNvqwaRmJWElvCFUX6jhasZEy6OyLSIUl5GPd/6xeZGUFFaB47gUAzmfYxqQn9pz92QW2ip0UE9GM3x/+pA7P1g3mQ9mrL5E6OeNVMXs/YInb3+liWKIneovWgOfPgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xs+DBXGJ8Nqd6jYjH0KFEex+F3pvtcrQreifwC8tohM=;
 b=IedgBJStHTy6E9BMKw7QpOFoZ2OwdHgRXYJQ5VzfnRNs159snXalQ5KRSsJz2htk8meyRLqiSqYVbPX/5Of1aH4lzaqYCfi5wiIYcd8tepChzhiOCbUIB4XqILrv7peNHw3tj0Nw93k60DQDwDdTh048khzZxeaCb4+LpSlhqqXKIsRS/SPDV4x8XXUAXSX+auo6hpW9JhEN6GfqKmr/nIKY2MZBXVMgTqu+xw1ybq/mRD/HgStsJEaqNzHE8u5kLXnCmX2Bf/CyLOuFIGZxlvRIRL61098zDyM69BAx8VYh6jjLRMULmDZeAR++sqlzOjSBcl1LpSMs+jxF0Hg8Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xs+DBXGJ8Nqd6jYjH0KFEex+F3pvtcrQreifwC8tohM=;
 b=S1RFoueYUrbuRKngwQbHb0qHueRaPR73mn9ktCwdTf7egdUHPWJFA0ipKav1l73CKzLNveEotSx4M2X/omexzHxwMxYWYg1psssDjwqaek40nYY+Fpb634Sd6qomQIOsR3Fq2Wx+mWrjQxL6qV0mgYED69kIBpl/RQ7q9+srNBQ=
Received: from BYAPR15MB4119.namprd15.prod.outlook.com (2603:10b6:a02:cd::20)
 by BYAPR15MB2294.namprd15.prod.outlook.com (2603:10b6:a02:8a::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.20; Mon, 23 Mar
 2020 23:54:47 +0000
Received: from BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::90d6:ec75:fde:e992]) by BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::90d6:ec75:fde:e992%7]) with mapi id 15.20.2835.021; Mon, 23 Mar 2020
 23:54:47 +0000
Date:   Mon, 23 Mar 2020 16:54:41 -0700
From:   Andrey Ignatov <rdna@fb.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
Message-ID: <20200323235441.GA33093@rdna-mbp>
References: <158462359206.164779.15902346296781033076.stgit@toke.dk>
 <158462359315.164779.13931660750493121404.stgit@toke.dk>
 <20200319155236.3d8537c5@kicinski-fedora-PC1C0HJN>
 <875zez76ph.fsf@toke.dk>
 <CAEf4BzYGZz7hdd-_x+uyE0OF8h_3vJxNjF-Qkd5QhOWpaB8bbQ@mail.gmail.com>
 <87r1xj48ko.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87r1xj48ko.fsf@toke.dk>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-ClientProxiedBy: MWHPR19CA0086.namprd19.prod.outlook.com
 (2603:10b6:320:1f::24) To BYAPR15MB4119.namprd15.prod.outlook.com
 (2603:10b6:a02:cd::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2620:10d:c090:400::5:8baa) by MWHPR19CA0086.namprd19.prod.outlook.com (2603:10b6:320:1f::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.19 via Frontend Transport; Mon, 23 Mar 2020 23:54:45 +0000
X-Originating-IP: [2620:10d:c090:400::5:8baa]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ec60fe8-d62b-4026-4cf8-08d7cf859119
X-MS-TrafficTypeDiagnostic: BYAPR15MB2294:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2294911A52B5EAA5F8AFB14BA8F00@BYAPR15MB2294.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0351D213B3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(7916004)(136003)(366004)(346002)(396003)(39850400004)(376002)(66556008)(316002)(53546011)(66574012)(66476007)(5660300002)(1076003)(54906003)(33656002)(478600001)(2906002)(6666004)(66946007)(9686003)(81166006)(16526019)(6916009)(186003)(4326008)(52116002)(6496006)(86362001)(33716001)(7416002)(8936002)(81156014)(6486002)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2294;H:BYAPR15MB4119.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aKb1nL3mMnWbqXLeT5OonI/SMzzmOPMTu50D73KR6JPNA2/LmZlPL2wR8b7w2Kykkq1nOJ9X71SVv2tvMQ86Nj8gHwsZbwANomQksJ1gMAhkQtBmIe8oYoIiMoxsPZwyb8Gjv/xmxz5m9aK7F6bRHIOIXA7YlSPkWTnKOkZMMSNG4TCO0QIkud2/ZCkV5inotrh7Cf5RA4eshRnR+A+tJ9Wa4ZCc7DvcBNZu+c19fT02DYu0UvAI1OH2UVONbpj0v4R/B1A3zZHbo9ZthKaCfqYpM6fCc3zOVP19f3eGBPtlZboRpxLMhB6z2bDBPu2oLaGpJZvp3W75Z2wcZklgi4kdocnqPJ0W0banmIxXe3aSIGxgrr5p2pNi75VoK/a2sV9d4/L9rkqwiLK+jYyVfyWOVACvYjEDoQC7CntrMIVRCMtgrtDNVIqQepnv/uTI
X-MS-Exchange-AntiSpam-MessageData: pzF9JOGa4mKcMOeHwEqRNs+rbCmOqZjnNYIYeX+HwhjLcQgpqpPTVz4C8962oNrZ6FvY+W7oFGmbu1dTzryovubK/hwprbeafsvwqVW4Cu7FfV8sT0ws4KicijyCJ1ADKlJJZwv2wHu1vNOlpxgFsYBazDuXNcO+g8b8o0duyEu28I60YOExAJGez+nMOqOf
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ec60fe8-d62b-4026-4cf8-08d7cf859119
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2020 23:54:47.0117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V+8S7vapyYW5iZnTQHWT0UivXgfornYFD4WQoU2zLcrL2x9kReyh7gfKokmD8mjY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2294
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-23_10:2020-03-23,2020-03-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 impostorscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 lowpriorityscore=0
 adultscore=0 clxscore=1015 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003230118
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke Høiland-Jørgensen <toke@redhat.com> [Mon, 2020-03-23 04:25 -0700]:
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> 
> > On Fri, Mar 20, 2020 at 1:48 AM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> >>
> >> Jakub Kicinski <kuba@kernel.org> writes:
> >>
> >> > On Thu, 19 Mar 2020 14:13:13 +0100 Toke Høiland-Jørgensen wrote:
> >> >> From: Toke Høiland-Jørgensen <toke@redhat.com>
> >> >>
> >> >> While it is currently possible for userspace to specify that an existing
> >> >> XDP program should not be replaced when attaching to an interface, there is
> >> >> no mechanism to safely replace a specific XDP program with another.
> >> >>
> >> >> This patch adds a new netlink attribute, IFLA_XDP_EXPECTED_FD, which can be
> >> >> set along with IFLA_XDP_FD. If set, the kernel will check that the program
> >> >> currently loaded on the interface matches the expected one, and fail the
> >> >> operation if it does not. This corresponds to a 'cmpxchg' memory operation.
> >> >>
> >> >> A new companion flag, XDP_FLAGS_EXPECT_FD, is also added to explicitly
> >> >> request checking of the EXPECTED_FD attribute. This is needed for userspace
> >> >> to discover whether the kernel supports the new attribute.
> >> >>
> >> >> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> >> >
> >> > I didn't know we wanted to go ahead with this...
> >>
> >> Well, I'm aware of the bpf_link discussion, obviously. Not sure what's
> >> happening with that, though. So since this is a straight-forward
> >> extension of the existing API, that doesn't carry a high implementation
> >> cost, I figured I'd just go ahead with this. Doesn't mean we can't have
> >> something similar in bpf_link as well, of course.
> >>
> >> > If we do please run this thru checkpatch, set .strict_start_type,
> >>
> >> Will do.
> >>
> >> > and make the expected fd unsigned. A negative expected fd makes no
> >> > sense.
> >>
> >> A negative expected_fd corresponds to setting the UPDATE_IF_NOEXIST
> >> flag. I guess you could argue that since we have that flag, setting a
> >> negative expected_fd is not strictly needed. However, I thought it was
> >> weird to have a "this is what I expect" API that did not support
> >> expressing "I expect no program to be attached".
> >
> > For BPF syscall it seems the typical approach when optional FD is
> > needed is to have extra flag (e.g., BPF_F_REPLACE for cgroups) and if
> > it's not specified - enforce zero for that optional fd. That handles
> > backwards compatibility cases well as well.
> 
> Never did understand how that is supposed to square with 0 being a valid
> fd number?

In BPF_F_REPLACE case (since it was used as an example in this thread)
it's all pretty clear:

* if the flag is set, use fd from attr.replace_bpf_fd that can be anything
  (incl. zero, since indeed it's valid fd) no problem with that;
* if flag is not set, ignore replace_bpf_fd completely.

It's descirbed in commit log in 7dd68b3279f1:

    ...

    BPF_F_REPLACE is introduced to make the user intent clear, since
    replace_bpf_fd alone can't be used for this (its default value, 0, is a
    valid fd). BPF_F_REPLACE also makes it possible to extend the API in the
    future (e.g. add BPF_F_BEFORE and BPF_F_AFTER if needed).

    ...

, i.e. flag presense is important, not the fd attribute being zero.

Hope it clarifies.


-- 
Andrey Ignatov
