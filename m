Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 093CF12AF23
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 23:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbfLZWUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 17:20:31 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:28618 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726105AbfLZWUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 17:20:31 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBQMF8M9013298;
        Thu, 26 Dec 2019 14:20:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=rzY0ZM6q35oXhwZ6cCNCQ6plBjDqtQq9JsTkfxqYhs4=;
 b=UEzztJZrc0PV/UPaFGie3QOEuQVXAc+l+5FdGrHgByjj5WzEOb0w1vxlp+0eRMjLSqyh
 wxAAx7eDs1qdQiQChOLxSWcf0PwkTc0RmgoHpfWvI/LAsuSXF8aDzF4JboyIqezCtVmJ
 3fUqHvPluFA5U2K9V2wMDNRFMQ0E0ydVz+U= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2x3k5u8c29-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 26 Dec 2019 14:20:14 -0800
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 26 Dec 2019 14:20:13 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 26 Dec 2019 14:20:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jw/LQCPaa/hYUFUid0WMss6Jdkpg4ISKcpzGyFa3uKZn9YYprRC2F5DLeUdIj2jS/hgn6pkYJlVCXWfQ1/JMzkNHoW+SvIly1vHdcqtq5e/LRXXNqsJ8zhBG/nXltsI9yO+EeoXAZiUQovvkHUZA2BAaX4UzDkUhvNO8tpNOE01D3Jr7W5RUob9VEAJeP6ysxtunAuxCu6D110XsoVULca6vq77mLUQ+e7cWHy6CLie8XwOdZ9H/gqQSuvlS2KKDwq8Xjz6jQARt0pIcntOJ4f+uFBevaoqbaURyExjzs+qLX7dSqZYynK52xN4KVMAJB5xdNtpNTu9OXnRA8pGAGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rzY0ZM6q35oXhwZ6cCNCQ6plBjDqtQq9JsTkfxqYhs4=;
 b=E+8TIjwfqQXdN7ARk4845sy3yivQ0T5uMnQXp/lunNdnKXxQSZ6D6O7Rh5pTP+0s7DON5bemzjvIfB5zy1EajcY3u4xiPEi6rrPU9/VqzgiTNhV2n94j6o+LUZc2lgNIBdLu1Kv/fr1MpnsPcGhDHLJdRl/QtZlrEKPIIsXDAnBedEa8enteINXU/Ezj6PJSHlHyU4gkYvJlZbIzajpljz/sLZni3F9ySyU3MktShMPeIKarYDF8Q+dM3fBqDHxUugBwk6fX0NCFrVSiax//037f7AsmGgfurbXAd8Oj5Ebb0081ZBUKveA/jlTUg/Pamcy0RWbB3wytV312jh6kEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rzY0ZM6q35oXhwZ6cCNCQ6plBjDqtQq9JsTkfxqYhs4=;
 b=h4h09tGHZq7cdwbhz10wHHJjTu0WDy2ouAAsRL35IIFws58NTjUNInVQKs8UDS625EeT7MxioKxtkzM5Hhv8GyF2TcMLRoiDvuqtglD9pQc7lV0IIIhbCiOmvwBOxnwrFKUkQmSw33vRaW1vEgYST5ulCafmBVD6x9JXVrQz2X4=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB2973.namprd15.prod.outlook.com (20.178.253.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Thu, 26 Dec 2019 22:20:12 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2559.017; Thu, 26 Dec 2019
 22:20:12 +0000
Received: from kafai-mbp (2620:10d:c090:180::a2c3) by MWHPR17CA0080.namprd17.prod.outlook.com (2603:10b6:300:c2::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2581.11 via Frontend Transport; Thu, 26 Dec 2019 22:20:10 +0000
From:   Martin Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        "Kernel Team" <Kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 11/11] bpf: Add bpf_dctcp example
Thread-Topic: [PATCH bpf-next v2 11/11] bpf: Add bpf_dctcp example
Thread-Index: AQHVueh9eJgyi9Vd8EqEIu9FcYh4uKfIf/YAgABcRoCAAKRSgIADSacAgAAXIACAAAZpgIAAGbKA
Date:   Thu, 26 Dec 2019 22:20:12 +0000
Message-ID: <20191226222007.5m4kra2lqa5igpfm@kafai-mbp>
References: <20191221062556.1182261-1-kafai@fb.com>
 <20191221062620.1184118-1-kafai@fb.com>
 <CAEf4BzZX_TNUXJktJUtqmxgMefDzie=Ta18TbBqBhG0-GSLQMg@mail.gmail.com>
 <20191224013140.ibn33unj77mtbkne@kafai-mbp>
 <CAEf4Bzb2fRZJsccx2CG_pASy+2eMMWPXk6m3d6SbN+o0MSdQPg@mail.gmail.com>
 <20191224165003.oi4kvxad6mlsg5kw@kafai-mbp>
 <CAEf4BzYA=xS7pHPqGxK4LsRHpxN=Y4dLcbG8WNMqGhKpauh7gQ@mail.gmail.com>
 <20191226202512.abhyhdtetv46z5sd@kafai-mbp>
 <CAEf4BzagEe4sbUfz6=Y6MHCsAAUAVe1GKi_XJUNu8xpHdd_mAQ@mail.gmail.com>
In-Reply-To: <CAEf4BzagEe4sbUfz6=Y6MHCsAAUAVe1GKi_XJUNu8xpHdd_mAQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR17CA0080.namprd17.prod.outlook.com
 (2603:10b6:300:c2::18) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::a2c3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fbc39db5-5bcf-43b5-8876-08d78a51c656
x-ms-traffictypediagnostic: MN2PR15MB2973:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB2973447811458B480403A639D52B0@MN2PR15MB2973.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02638D901B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(376002)(346002)(366004)(396003)(189003)(199004)(16526019)(5660300002)(33716001)(186003)(316002)(8676002)(71200400001)(81156014)(81166006)(478600001)(4326008)(53546011)(6916009)(6496006)(52116002)(66946007)(1076003)(64756008)(66476007)(55016002)(8936002)(54906003)(66556008)(66446008)(86362001)(2906002)(9686003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2973;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ppSKSabrBcgc0FaCZZbvduPQZd+2n5zEsWIgXlE9ltZWpIDvkcGE+U8ayS7hcYD3hj7fy7WwxVA/D/QJXRmvxUoInB75hbJImCPcP1H1kOAn7mot2hxqFa6tfZuu01mBUwyOtxrlpbWDO41WFw4rokKJWcpF0WdXDj181wT4UB15Lx4rbXwluKKVQNkQvLjj450lPVaMJjEFjQQTEc8PplWu0kg08d4ZCFIbzTrStSCjIV3sxZwvKONyv3p0/JdeA33HH+BmnNE12m6IjGqftJWBVrpxwzhWfpYqmdBGQCdrw0vcD2f4Avi+F/GVBeQOhkDcmJUUyCdnJsRW3Mq7tPr4pfkyg607erV60lvcTwvgwwrxLUDeyt1HSydt2pKJkxNnmsE2iCTZSAUNjDgKO3kcv2Uyfo9Co1m7hUPJBFBi8YSZu9X6behfRwFgu1E3
Content-Type: text/plain; charset="us-ascii"
Content-ID: <17D0B1E1E8641649837B330E6C4AD13A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: fbc39db5-5bcf-43b5-8876-08d78a51c656
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Dec 2019 22:20:12.2717
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y0MKcoBanYjLAaZEJxQWaR+cnk68MzKQnxPNw9sj7drJq49iUVRJhawNz37HwHNI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2973
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-26_05:2019-12-24,2019-12-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 impostorscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 priorityscore=1501 clxscore=1015
 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912260196
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 26, 2019 at 12:48:09PM -0800, Andrii Nakryiko wrote:
> On Thu, Dec 26, 2019 at 12:25 PM Martin Lau <kafai@fb.com> wrote:
> >
> > On Thu, Dec 26, 2019 at 11:02:26AM -0800, Andrii Nakryiko wrote:
> > > On Tue, Dec 24, 2019 at 8:50 AM Martin Lau <kafai@fb.com> wrote:
> > > >
> > > > On Mon, Dec 23, 2019 at 11:01:55PM -0800, Andrii Nakryiko wrote:
> > > > > On Mon, Dec 23, 2019 at 5:31 PM Martin Lau <kafai@fb.com> wrote:
> > > > > >
> > > > > > On Mon, Dec 23, 2019 at 03:26:50PM -0800, Andrii Nakryiko wrote=
:
> > > > > > > On Fri, Dec 20, 2019 at 10:26 PM Martin KaFai Lau <kafai@fb.c=
om> wrote:
> > > > > > > >
> > > > > > > > This patch adds a bpf_dctcp example.  It currently does not=
 do
> > > > > > > > no-ECN fallback but the same could be done through the cgrp=
2-bpf.
> > > > > > > >
> > > > > > > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > > > > > > ---
> > > > > > > >  tools/testing/selftests/bpf/bpf_tcp_helpers.h | 228 ++++++=
++++++++++++
> > > > > > > >  .../selftests/bpf/prog_tests/bpf_tcp_ca.c     | 218 ++++++=
+++++++++++
> > > > > > > >  tools/testing/selftests/bpf/progs/bpf_dctcp.c | 210 ++++++=
++++++++++
> > > > > > > >  3 files changed, 656 insertions(+)
> > > > > > > >  create mode 100644 tools/testing/selftests/bpf/bpf_tcp_hel=
pers.h
> > > > > > > >  create mode 100644 tools/testing/selftests/bpf/prog_tests/=
bpf_tcp_ca.c
> > > > > > > >  create mode 100644 tools/testing/selftests/bpf/progs/bpf_d=
ctcp.c
> > > > > > > >
> > > > > > > > diff --git a/tools/testing/selftests/bpf/bpf_tcp_helpers.h =
b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
> > > > > > > > new file mode 100644
> > > > > > > > index 000000000000..7ba8c1b4157a
> > > > > > > > --- /dev/null
> > > > > > > > +++ b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
> > > > > > > > @@ -0,0 +1,228 @@
> > > > > > > > +/* SPDX-License-Identifier: GPL-2.0 */
> > > > > > > > +#ifndef __BPF_TCP_HELPERS_H
> > > > > > > > +#define __BPF_TCP_HELPERS_H
> > > > > > > > +
> > > > > > > > +#include <stdbool.h>
> > > > > > > > +#include <linux/types.h>
> > > > > > > > +#include <bpf_helpers.h>
> > > > > > > > +#include <bpf_core_read.h>
> > > > > > > > +#include "bpf_trace_helpers.h"
> > > > > > > > +
> > > > > > > > +#define BPF_TCP_OPS_0(fname, ret_type, ...) BPF_TRACE_x(0,=
 #fname"_sec", fname, ret_type, __VA_ARGS__)
> > > > > > > > +#define BPF_TCP_OPS_1(fname, ret_type, ...) BPF_TRACE_x(1,=
 #fname"_sec", fname, ret_type, __VA_ARGS__)
> > > > > > > > +#define BPF_TCP_OPS_2(fname, ret_type, ...) BPF_TRACE_x(2,=
 #fname"_sec", fname, ret_type, __VA_ARGS__)
> > > > > > > > +#define BPF_TCP_OPS_3(fname, ret_type, ...) BPF_TRACE_x(3,=
 #fname"_sec", fname, ret_type, __VA_ARGS__)
> > > > > > > > +#define BPF_TCP_OPS_4(fname, ret_type, ...) BPF_TRACE_x(4,=
 #fname"_sec", fname, ret_type, __VA_ARGS__)
> > > > > > > > +#define BPF_TCP_OPS_5(fname, ret_type, ...) BPF_TRACE_x(5,=
 #fname"_sec", fname, ret_type, __VA_ARGS__)
> > > > > > >
> > > > > > > Should we try to put those BPF programs into some section tha=
t would
> > > > > > > indicate they are used with struct opts? libbpf doesn't use o=
r enforce
> > > > > > > that (even though it could to derive and enforce that they ar=
e
> > > > > > > STRUCT_OPS programs). So something like
> > > > > > > SEC("struct_ops/<ideally-operation-name-here>"). I think havi=
ng this
> > > > > > > convention is very useful for consistency and to do a quick E=
LF dump
> > > > > > > and see what is where. WDYT?
> > > > > > I did not use it here because I don't want any misperception th=
at it is
> > > > > > a required convention by libbpf.
> > > > > >
> > > > > > Sure, I can prefix it here and comment that it is just a
> > > > > > convention but not a libbpf's requirement.
> > > > >
> > > > > Well, we can actually make it a requirement of sorts. Currently y=
our
> > > > > code expects that BPF program's type is UNSPEC and then it sets i=
t to
> > > > > STRUCT_OPS. Alternatively we can say that any BPF program in
> > > > > SEC("struct_ops/<whatever>") will be automatically assigned
> > > > > STRUCT_OPTS BPF program type (which is done generically in
> > > > > bpf_object__open()), and then as .struct_ops section is parsed, a=
ll
> > > > > those programs will be "assembled" by the code you added into a
> > > > > struct_ops map.
> > > > Setting BPF_PROG_TYPE_STRUCT_OPS can be done automatically at open
> > > > phase (during collect_reloc time).  I will make this change.
> > > >
> > >
> > > Can you please extend exiting logic in __bpf_object__open() to do
> > > this? See how libbpf_prog_type_by_name() is used for that.
> > Does it have to call libbpf_prog_type_by_name() if everything
> > has already been decided by the earlier
> > bpf_object__collect_struct_ops_map_reloc()?
>=20
> We can certainly change the logic to omit guessing program type if
> it's already set to something else than UNSPEC.
>=20
> But all I'm asking is that instead of using #fname"_sec" section name,
> is to use "struct_ops/"#fname, because it's consistent with all other
> program types. If you do that, then you don't have to do anything
> extra (well, add single entry to section_defs, of course), it will
> just work as is.
Re: adding "struct_ops/" to section_defs,
Sure. as long as SEC(".struct_ops") can use prog that
libbpf_prog_type_by_name() concluded it is either -ESRCH or
STRUCT_OPS.

It is not the only change though.  Other changes are still
needed in collect_reloc (e.g. check prog type mismatch).
They won't be much though.
