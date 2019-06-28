Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEF0F5A387
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 20:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfF1S0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 14:26:43 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:17918 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726443AbfF1S0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 14:26:43 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5SIJZiu013594;
        Fri, 28 Jun 2019 11:26:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=8djjofBewhnxBLUUvMGkLArabA06X/PONs2ThCKlZqc=;
 b=XdObFbO4KmatJ6LYksbTqWg5lqBIhz9g93D8X4uUrXSxwrfQHEEwQqNl5JM76RAeKYtm
 i1usNjpvFdKJo4ruk5FCv2E8+9eKihsI1qHcKRGsqbehSE1o1IPse/AunMxXJuO0FEq+
 PjgC9q0UO0znhXmXc/5v2cLEFgrGCggqHGY= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2tddj42abc-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 28 Jun 2019 11:26:23 -0700
Received: from prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 28 Jun 2019 11:26:22 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 28 Jun 2019 11:26:22 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 28 Jun 2019 11:26:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=t80ergff8XtRXUYyg5tPBQGT+pBKbydUU8k1dXBZD32Oc1EJvHAtmzCn/aqo3/J6UVqSJwFLabfi4gles7/ZEAOVTqLqCg911tRHcHYDvSIQA+3Jd/uJ5Md/3lbv1dglxwDR5xqLNK4hLo0+fyLMDBCJGIFmEHDVGgeAhozYOpY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8djjofBewhnxBLUUvMGkLArabA06X/PONs2ThCKlZqc=;
 b=alsOzdOYTD4rC7euVbLKkaPqAH23kDSiqvIBQVPNYjv7TZE13U8pjp8uX3O+sD5QVJXo+V5vZEgMoBV1f/fqMTELNQEimopUulFbKqY8IIkgiGH6yUdfbgk4hXl6AeTdApr8P0MQ/2fqnP+XNVBLSJZkNn6JRRUzbPv99ktnols=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8djjofBewhnxBLUUvMGkLArabA06X/PONs2ThCKlZqc=;
 b=VSpIpuvNb75MShzLWgLyg6HPa1KC6bogK+r84+KyQO4dn++fNnkVvjE4S+TPsbaCp+E1voI7QT8tNwduW9Kzcz92daNZTi1h31PVIFVX6PocTYk6c7r1gZf1Gu+3h7jGoQbFPE28tyP4tROFus5z3eL8Go3dZf1kg0h9YWwDeYI=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1693.namprd15.prod.outlook.com (10.175.138.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Fri, 28 Jun 2019 18:26:21 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d%6]) with mapi id 15.20.2008.018; Fri, 28 Jun 2019
 18:26:21 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 4/4] selftests/bpf: convert legacy BPF maps to
 BTF-defined ones
Thread-Topic: [PATCH v2 bpf-next 4/4] selftests/bpf: convert legacy BPF maps
 to BTF-defined ones
Thread-Index: AQHVLcXP4fL+fCtZf0aKHJFs/JzqrqaxYmsA
Date:   Fri, 28 Jun 2019 18:26:21 +0000
Message-ID: <F9B8191F-D5BB-4B42-A1DA-373D2E861436@fb.com>
References: <20190628152539.3014719-1-andriin@fb.com>
 <20190628152539.3014719-5-andriin@fb.com>
In-Reply-To: <20190628152539.3014719-5-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::2127]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c9352754-b70e-4819-d71b-08d6fbf61ec9
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1693;
x-ms-traffictypediagnostic: MWHPR15MB1693:
x-microsoft-antispam-prvs: <MWHPR15MB1693C13B67CA7CC24BB726EEB3FC0@MWHPR15MB1693.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:800;
x-forefront-prvs: 00826B6158
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(376002)(136003)(366004)(396003)(346002)(189003)(199004)(64756008)(6636002)(76116006)(66476007)(66946007)(73956011)(57306001)(66556008)(446003)(46003)(11346002)(2616005)(476003)(7736002)(6506007)(76176011)(86362001)(486006)(81156014)(81166006)(53546011)(8936002)(8676002)(305945005)(66446008)(50226002)(99286004)(36756003)(53936002)(6486002)(102836004)(25786009)(6116002)(68736007)(6436002)(6512007)(6862004)(229853002)(6246003)(186003)(4326008)(478600001)(316002)(33656002)(4744005)(54906003)(5660300002)(71200400001)(37006003)(71190400001)(14454004)(2906002)(256004);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1693;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9Wduep+s/9IcRThXJvR+bZeK2jlAT9MQXTaFe1eFctLmVjmRdXnlX+uAGjxQYNfLYPC7jXS0CnNlGe8yzuhtQRyg/Jd+c0olRllTS1qWJv7ZEiA+q+N7IH2+fNp40Pk3AWPaa96ChOmhVn4x0iIVy7PKvsxzSxHFnHRKXyqrXZSplB+geh6KUXW7xm99fdunWOYKMp5UtwMl7KgJYkAbr1joLIeA/VoGrdXZEQpnClGlmBCEut5DNwvl/8KHK+Tus8ED9ISPS5HdLwFJlSkpwrpqMesf1+ZREFtEsQxAQatJ2dIUS4TMmrCPU/yN79S/AjApoZSyKj/2br12v6Xk41IPfOZtp8NcuD/ESwlMVtOyRqxVRt3SDuO4KhfWhupDRWuNQr32lr7OHVuQAFSI6KHxLwl26BWrllZ70488wlg=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <89FA51C54D7FDA41B453C5EF728257D1@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c9352754-b70e-4819-d71b-08d6fbf61ec9
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2019 18:26:21.5433
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1693
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-28_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906280207
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 28, 2019, at 8:25 AM, Andrii Nakryiko <andriin@fb.com> wrote:
>=20
> Convert selftests that were originally left out and new ones added
> recently to consistently use BTF-defined maps.
>=20
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
> .../selftests/bpf/progs/get_cgroup_id_kern.c  |  26 ++---
> tools/testing/selftests/bpf/progs/pyperf.h    |  90 +++++++-------
> .../selftests/bpf/progs/sample_map_ret0.c     |  24 ++--
> .../bpf/progs/sockmap_verdict_prog.c          |  48 ++++----
> .../testing/selftests/bpf/progs/strobemeta.h  |  68 +++++------
> .../selftests/bpf/progs/test_map_in_map.c     |  30 ++---
> .../testing/selftests/bpf/progs/test_obj_id.c |  12 +-
> .../selftests/bpf/progs/test_xdp_loop.c       |  26 ++---
> .../selftests/bpf/progs/xdp_redirect_map.c    |  12 +-
> .../testing/selftests/bpf/progs/xdping_kern.c |  12 +-
> .../selftests/bpf/test_queue_stack_map.h      |  30 ++---
> .../testing/selftests/bpf/test_sockmap_kern.h | 110 +++++++++---------
> 12 files changed, 240 insertions(+), 248 deletions(-)


