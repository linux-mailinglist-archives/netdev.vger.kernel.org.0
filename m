Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0715D57139
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 21:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbfFZTCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 15:02:42 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37450 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726227AbfFZTCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 15:02:42 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5QJ0Qm5015757;
        Wed, 26 Jun 2019 12:02:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=7nfuponTVGXpzUAgpV9HFiwc9JmmetidDlohDERnNTw=;
 b=ohlC8RhEIn5PgMRhzwKaYZtbwSS1gwF+P15GVK+Z9I+vxjarB4002wOMSVRGEVYfAs19
 92svFweia9Kiqy4koJ3pKbZtiUF9AwuWUp2VVNDqr0VpTZdvFCJaMURUQHDmfiT3vVNw
 CEXeNR54ewVOYuJEge+7O1SHbVkJ4UcwQaU= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2tc8axhj9p-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 26 Jun 2019 12:02:22 -0700
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 26 Jun 2019 12:02:18 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 26 Jun 2019 12:02:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7nfuponTVGXpzUAgpV9HFiwc9JmmetidDlohDERnNTw=;
 b=LtpKIFw51cN6nXh0iKgJ90tL2NQ2UjRSapTCEcJ4XPbDniehPKxFX5gIweNVz1u7Vj9V5aYyNA1JSRtSJsc07DRnmt1oXasQXAcdpjDSMDnAxFLVPA5/7QUYjs6Tdh9QhaG7WbKqmLzaR6c1GNudq0QKPsnBkkQy01OM9w0fD+Q=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1215.namprd15.prod.outlook.com (10.175.3.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Wed, 26 Jun 2019 19:02:17 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d%6]) with mapi id 15.20.2008.018; Wed, 26 Jun 2019
 19:02:17 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 1/3] libbpf: add perf buffer API
Thread-Topic: [PATCH v2 bpf-next 1/3] libbpf: add perf buffer API
Thread-Index: AQHVK+Y9tyamqoqwF0mzLxOZNaVZfaauS4oA
Date:   Wed, 26 Jun 2019 19:02:17 +0000
Message-ID: <4D6ED1DE-A8F0-4531-BB0A-3C99E42BE60C@fb.com>
References: <20190626061235.602633-1-andriin@fb.com>
 <20190626061235.602633-2-andriin@fb.com>
In-Reply-To: <20190626061235.602633-2-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::1:6898]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0b000da7-f4a0-4539-5c6b-08d6fa68cedb
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1215;
x-ms-traffictypediagnostic: MWHPR15MB1215:
x-microsoft-antispam-prvs: <MWHPR15MB12150BBF2E8D45BD7AEFF817B3E20@MWHPR15MB1215.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 00808B16F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(39860400002)(346002)(396003)(376002)(199004)(189003)(6486002)(316002)(71190400001)(6636002)(66446008)(33656002)(68736007)(6116002)(8936002)(81166006)(478600001)(64756008)(81156014)(37006003)(2906002)(66476007)(66556008)(76116006)(54906003)(66946007)(73956011)(5660300002)(99286004)(6512007)(486006)(476003)(76176011)(86362001)(186003)(6246003)(6862004)(57306001)(256004)(36756003)(4326008)(229853002)(14444005)(71200400001)(6436002)(53546011)(46003)(14454004)(6506007)(50226002)(11346002)(7736002)(305945005)(8676002)(102836004)(53936002)(2616005)(446003)(25786009);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1215;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ql7OXRW/6Yo+iC+dTqonvByi8P5eDHv42bX/ggs2kVWqLQLV2ZK3dlxTKPYTVH7KPNzjyH8gpmmlsKHYIFleL8QRQgk6dbSutJEwUExpLb2gv/GVzpXMP0mmjXmEfgMxfj3b6VVOmB4oAb+42fl/ZK7u6kHuvQincEh4ltXuL/S3DiPvUkx5sKCCAoVza2RjSP341bs2E4UgxdtoCdLPbuAUulK0KzwaqUr9vv4kmye5VAzMFPBYMt2KCnKMdrsMnLcZe5d+QTOGvbNBhJSIPVM59rQ3KFrN6i13qrfIb7E5Peahj7QiFRvFxwFVoM/O/3NGJ38ZzRS3HmeDqDiUU8g7mvMHV8Fy0h8e590t1/hrRUfTzszxuyNFCvbz/Le6v+xas110q0FzBlC5jafQVSdxROPMwiug2gYEFj3L2gY=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E78338148801C345A15E09D6F8CADEF7@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b000da7-f4a0-4539-5c6b-08d6fa68cedb
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2019 19:02:17.1857
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1215
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-26_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=944 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906260220
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 25, 2019, at 11:12 PM, Andrii Nakryiko <andriin@fb.com> wrote:
>=20
> BPF_MAP_TYPE_PERF_EVENT_ARRAY map is often used to send data from BPF pro=
gram
> to user space for additional processing. libbpf already has very low-leve=
l API
> to read single CPU perf buffer, bpf_perf_event_read_simple(), but it's ha=
rd to
> use and requires a lot of code to set everything up. This patch adds
> perf_buffer abstraction on top of it, abstracting setting up and polling
> per-CPU logic into simple and convenient API, similar to what BCC provide=
s.
>=20
> perf_buffer__new() sets up per-CPU ring buffers and updates corresponding=
 BPF
> map entries. It accepts two user-provided callbacks: one for handling raw
> samples and one for get notifications of lost samples due to buffer overf=
low.
>=20
> perf_buffer__poll() is used to fetch ring buffer data across all CPUs,
> utilizing epoll instance.
>=20
> perf_buffer__free() does corresponding clean up and unsets FDs from BPF m=
ap.
>=20
> All APIs are not thread-safe. User should ensure proper locking/coordinat=
ion if
> used in multi-threaded set up.
>=20
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
> tools/lib/bpf/libbpf.c   | 282 +++++++++++++++++++++++++++++++++++++++
> tools/lib/bpf/libbpf.h   |  12 ++
> tools/lib/bpf/libbpf.map |   5 +-
> 3 files changed, 298 insertions(+), 1 deletion(-)

