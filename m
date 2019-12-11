Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18FF611C02C
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 23:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbfLKWzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 17:55:50 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:26944 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726141AbfLKWzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 17:55:49 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBBMtVbp029332;
        Wed, 11 Dec 2019 14:55:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=52ezYPQh3j3hWBgAn0zKxAy11ISK9K+Hz8iqLQCBPMM=;
 b=evWvFggatN/ceLNRhQuKtaeB7q6JOewQFxy11NztUbiRAOR6i5Fxi/CDyGKymMVbHUVF
 MSmronATp0aPmsM1VBa7nUlBX2ri1fbya/h2taV7NVc+eEERkDgI+EkbzIR8WQEBEN8m
 KuvwRre29nSO1P6NOBcEuvbR7LzkUd1MaB4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wu87qgcee-13
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 11 Dec 2019 14:55:37 -0800
Received: from prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 11 Dec 2019 14:55:29 -0800
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 11 Dec 2019 14:55:29 -0800
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 11 Dec 2019 14:55:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kn9LKGv/d4gxUvcrARxSuA1IQ98tRD8VrJC0mA7IlVCqjlcOQqnzjN6aUVGUH4woDRN1lGHaVYnPembyj09hJY6/SjXvwSqcWHzG39bvFtewEbHo0Zlrrp1R38Po/2wgkp53qrv8BkcybYR3dbfpZYS3MDGeMOhWSVD/f1hIUEpj/7bkt7pXOWASi/ZK2GDajDwaBfCoWibV6f77BCV1jfsgH6nvIS6NJ9IpW1EfqZ7MS1emt2WZjbTyIE/luZTTS3dAcprGGm+dHlLp7JR0k77EWgLjOelzbVB7cayd5Q0i8Sz03C/CDZhUZ4dloYXWKDAGaUhnSWw7TRrOls3wSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=52ezYPQh3j3hWBgAn0zKxAy11ISK9K+Hz8iqLQCBPMM=;
 b=XuYyfhXbc3biNkrJUkyuC+RBRAWUeFs88upoBWkEBpBv+cHJvNH34WD5eK6A8J/UOxLwe2ddZuWvuZG3Na97vPVfqUYXQ+ewnVHx4+t/mrxgtCcfronjXe2yTsh4LroAJk9K4okcO74DmiOplbIVJYNl0BeatOUW2cIFQ4VCTcIEPuWtYObiQQilpoV9kIpnxOmXU0dvaHUkErvjfGxxbNP5A1i/7XL92V6c4H6DTse0UCMKFmTHAAL/rBgm/OCiMVYdSRjwW2m7cY2cxOWhFe5UxQLXuNpOnoEiLFzUgdDNB3CBRgE0lL+MQujYxCK3Bsmbk6R/kqfxFvO2gbba+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=52ezYPQh3j3hWBgAn0zKxAy11ISK9K+Hz8iqLQCBPMM=;
 b=ityYiGSCIbuhoICQIRpIgh/WZDa0ODqfsirBRkJFGJr/Zk742YRLV1fEtk4duQl/Gezocp4CDi65PqEDY8V7vSJTZZqoo3U0dbcCYc4c8/hdhjL5YQDfV2jmfDeWpLTcZXZWpCHLWB4M+NFf5NyhGKoe/Dc5IY3iQMKnhPnWkWU=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3085.namprd15.prod.outlook.com (20.178.252.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.12; Wed, 11 Dec 2019 22:55:25 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2516.018; Wed, 11 Dec 2019
 22:55:25 +0000
From:   Martin Lau <kafai@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 00/15] Add code-generated BPF object skeleton
 support
Thread-Topic: [PATCH bpf-next 00/15] Add code-generated BPF object skeleton
 support
Thread-Index: AQHVrvdIRVFaWnQgPE+G1mSVHmemwae1jiAA
Date:   Wed, 11 Dec 2019 22:55:25 +0000
Message-ID: <20191211225506.w3cv6sur3we6qiu3@kafai-mbp>
References: <20191210011438.4182911-1-andriin@fb.com>
In-Reply-To: <20191210011438.4182911-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR22CA0052.namprd22.prod.outlook.com
 (2603:10b6:300:12a::14) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:ee78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e0235c59-207b-4825-67f0-08d77e8d3583
x-ms-traffictypediagnostic: MN2PR15MB3085:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB30855AAA8FBBF396D061142CD55A0@MN2PR15MB3085.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 024847EE92
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(136003)(376002)(346002)(366004)(396003)(39860400002)(189003)(199004)(66556008)(66446008)(66946007)(1076003)(64756008)(66476007)(6486002)(5660300002)(81166006)(54906003)(86362001)(2906002)(316002)(8936002)(8676002)(71200400001)(9686003)(6636002)(81156014)(186003)(6506007)(4326008)(52116002)(478600001)(33716001)(6862004)(6512007);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3085;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DOcBfUvqoMG2LDOyvo1flVZiV2XGUoYS8B2UpmDdr5Wi4R9Z/b24bcdMUZudF2GQI9QnbQ+9K9yKnOoiH2de2OEwA+o7M6/oS3NPdozEOgkBvPCFTAKdS/gTZGEwfP1tbjhUPL9rYD0VdOEfzvcGbUr2AqrGpzMqggP/3EijqHZemhfYdLT9j5i65HhO30uOCo9WayNU5W6BQvG2h58XE2geMq6a5gaaHemAdE/VPGQGf3uXpKszpdikR+c4fbUY9zlAizcKGm3Iu9Jrqls/NzqtY60DjEJmz8YAIyMM3dgnmo4an46z0NTmBBMIX3jGKplPz2YXmcfKGE17LB39fDf6ZSGE7PSR7yAC737LnBXglt4XftoFBBNATBWxaUlrqL/Vh9XX9OWra+LL8ZCcL2ynf0bL/s9+Ejsqq17xzsYdfOwrLC9qC/lkaViREG2H
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B240DF911521DF49875A593D978893AA@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e0235c59-207b-4825-67f0-08d77e8d3583
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2019 22:55:25.2585
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h8W85s/WjtbXDwenIo8vu4vzxNpds50uDpUQ1gMHKj3JTeICD5Hq77OqXhcCizSu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3085
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-11_07:2019-12-11,2019-12-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 malwarescore=0
 spamscore=0 mlxscore=0 suspectscore=0 phishscore=0 lowpriorityscore=0
 mlxlogscore=958 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912110180
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 05:14:23PM -0800, Andrii Nakryiko wrote:
> This patch set introduces an alternative and complimentary to existing li=
bbpf
> API interface for working with BPF objects, maps, programs, and global da=
ta
> from userspace side. This approach is relying on code generation. bpftool
> produces a struct (a.k.a. skeleton) tailored and specific to provided BPF
> object file. It includes hard-coded fields and data structures for every =
map,
> program, link, and global data present.
>=20
> Altogether this approach significantly reduces amount of userspace boiler=
plate
> code required to open, load, attach, and work with BPF objects. It improv=
es
> attach/detach story, by providing pre-allocated space for bpf_links, and
> ensuring they are properly detached on shutdown. It allows to do away wit=
h by
> name/title lookups of maps and programs, because libbpf's skeleton API, i=
n
> conjunction with generated code from bpftool, is filling in hard-coded fi=
elds
> with actual pointers to corresponding struct bpf_map/bpf_program/bpf_link=
.
>=20
> Also, thanks to BPF array mmap() support, working with global data (varia=
bles)
> from userspace is now as natural as it is from BPF side: each variable is=
 just
> a struct field inside skeleton struct. Furthermore, this allows to have
> a natural way for userspace to pre-initialize global data (including
> previously impossible to initialize .rodata) by just assigning values to =
the
> same per-variable fields. Libbpf will carefully take into account this
> initialization image, will use it to pre-populate BPF maps at creation ti=
me,
> and will re-mmap() BPF map's contents at exactly the same userspace memor=
y
> address such that it can continue working with all the same pointers with=
out
> any interruptions. If kernel doesn't support mmap(), global data will sti=
ll be
> successfully initialized, but after map creation global data structures i=
nside
> skeleton will be NULL-ed out. This allows userspace application to gracef=
ully
> handle lack of mmap() support, if necessary.
>=20
> A bunch of selftests are also converted to using skeletons, demonstrating
> significant simplification of userspace part of test and reduction in amo=
unt
> of code necessary.
Changes look good to me.

Acked-by: Martin KaFai Lau <kafai@fb.com>

which should not stop the on-going discussion.
