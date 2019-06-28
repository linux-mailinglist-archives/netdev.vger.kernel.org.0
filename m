Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B67185A385
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 20:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbfF1S0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 14:26:21 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:25874 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726443AbfF1S0V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 14:26:21 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5SINIq7000341;
        Fri, 28 Jun 2019 11:25:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Kkak3860U4t4xJx+mtM3p50pD8ZaJECeCWJNERL2eK8=;
 b=PK3zMrmk9IMqaUDs2x4SYgSVJC2m5mKa7Gl/LiWMxUXZa7aXdyXhE+NKh7L/yj9Lieu1
 POuqKS+FFyQHLgDKMqFA6vwcWEAwsgC6kzazSOpqFmGLoJfLrmwmDi9BfElyKq1jzbdp
 SzeAmLey3XBZ63ozWPH4cArq1bXXD9itsx8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2tdgrahpa0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 28 Jun 2019 11:25:58 -0700
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 28 Jun 2019 11:25:57 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 28 Jun 2019 11:25:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=glAV1XnlQExrsZolqC4TL7B1qpLFAubgShmoDZydFMRinjqpeU3jPI8q94YsO67vswRg+Ha9MEUXE1tSPOOw8K+duWEGcvz4ucuEgHZqB7HrkNCWZo4LSF45jGLn408Nx0xz2jVAgMY14a8LOhlMftFZGvVGZfZm20e0HS+1oHI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kkak3860U4t4xJx+mtM3p50pD8ZaJECeCWJNERL2eK8=;
 b=G5ljUZjyY3WJAZHfpsQWDDwNdwuFSCUAf6o6Zv7llc+0WZ5c3jUkkxW3FK6uiZ3p/SiufC5gOMhiNykZ0uLSsubgD7yXh5eruuBskAHok4VaVLlBOpN7BUvkSd7beUwX0Zgnn1FK9m6AZbz3Nwo6Ss74ruu6zcFKSHS24XJy3pc=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kkak3860U4t4xJx+mtM3p50pD8ZaJECeCWJNERL2eK8=;
 b=tGqgoc4mYMnc8sMCJN3aHQI9TV/zfbhrbIXbDRF1EZhDGsWZkgLd68bYQyMf/POfxgOGg2pvYvTlco0bdC02JLxfKYcWVPRR/NqVoy/h8fNOHpx2AvoLorWkYE6E41PjXjm9omDP+vAh+56Z/AtzPKUdr0BVP/GaFrwiyEFy/YU=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1693.namprd15.prod.outlook.com (10.175.138.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Fri, 28 Jun 2019 18:25:56 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d%6]) with mapi id 15.20.2008.018; Fri, 28 Jun 2019
 18:25:56 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 3/4] selftests/bpf: convert selftests using
 BTF-defined maps to new syntax
Thread-Topic: [PATCH v2 bpf-next 3/4] selftests/bpf: convert selftests using
 BTF-defined maps to new syntax
Thread-Index: AQHVLcX4ZaY2FXmvo0GYfiBTh3lsZqaxYkyA
Date:   Fri, 28 Jun 2019 18:25:55 +0000
Message-ID: <AC70CA4A-F925-431B-9860-70E7B190AA84@fb.com>
References: <20190628152539.3014719-1-andriin@fb.com>
 <20190628152539.3014719-4-andriin@fb.com>
In-Reply-To: <20190628152539.3014719-4-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::2127]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eec63b70-a6e4-4c62-8c9f-08d6fbf60f8e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1693;
x-ms-traffictypediagnostic: MWHPR15MB1693:
x-microsoft-antispam-prvs: <MWHPR15MB1693B66041C0AA596174F433B3FC0@MWHPR15MB1693.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:359;
x-forefront-prvs: 00826B6158
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(376002)(136003)(366004)(396003)(346002)(189003)(199004)(64756008)(6636002)(76116006)(66476007)(66946007)(73956011)(57306001)(66556008)(446003)(46003)(11346002)(2616005)(476003)(7736002)(6506007)(76176011)(86362001)(486006)(81156014)(81166006)(53546011)(8936002)(8676002)(305945005)(66446008)(50226002)(99286004)(36756003)(53936002)(6486002)(102836004)(25786009)(6116002)(68736007)(6436002)(6512007)(6862004)(229853002)(6246003)(186003)(4326008)(478600001)(316002)(33656002)(54906003)(5660300002)(71200400001)(37006003)(71190400001)(14454004)(2906002)(14444005)(256004);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1693;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 549TZblXqrx0XvZL/yMEW9L3guIvfdiuaAMXoMSIe+gRgPGNz+x0JEz5GX9yxajnFtSO+KS+7/GhO5BlJtvdqbEcymMah3SnWRGWpxqydrVmZsjYl6lnZRZJZvVMvg/WPLNZNUGyQrYzo9bvFi71sDQJ+xkTMcWLAizgKKluHRVuaRp4BuCFi7JhpLykLzZq5sMbociz4r9bmD+dIS8phFWulrsr6shyNSbcZFn9fWg9kCwxx+E1YZwx5NhKM9CPZe2oj4WQIgvews+XgiVA0fCchH34gPTT82aVpD2ciRm9MkxAaHE3wEv9DUx0bHN6Bn5x4agQNP9BNuoW5ffQvK1MoOWGZoWYdbo6RNrjkt7brHShTDL2YhemWYGpd42cQRs9pJWHjrdyo8fP2bYgcRIq5PPCY/0YcPb39NAzkJ8=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8B23BF8984AF034699472B476CE75FA8@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: eec63b70-a6e4-4c62-8c9f-08d6fbf60f8e
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2019 18:25:55.9179
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
> Convert all the existing selftests that are already using BTF-defined
> maps to use new syntax (with no static data initialization).
>=20
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

This looks cleaner!

> ---
> tools/testing/selftests/bpf/progs/bpf_flow.c  | 28 +++----
> .../testing/selftests/bpf/progs/netcnt_prog.c | 20 ++---
> .../selftests/bpf/progs/socket_cookie_prog.c  | 13 ++-
> .../selftests/bpf/progs/test_btf_newkv.c      | 13 ++-
> .../bpf/progs/test_get_stack_rawtp.c          | 39 ++++-----
> .../selftests/bpf/progs/test_global_data.c    | 37 ++++-----
> tools/testing/selftests/bpf/progs/test_l4lb.c | 65 ++++++---------
> .../selftests/bpf/progs/test_l4lb_noinline.c  | 65 ++++++---------
> .../selftests/bpf/progs/test_map_lock.c       | 26 +++---
> .../bpf/progs/test_select_reuseport_kern.c    | 67 ++++++---------
> .../bpf/progs/test_send_signal_kern.c         | 26 +++---
> .../bpf/progs/test_sock_fields_kern.c         | 78 +++++++-----------
> .../selftests/bpf/progs/test_spin_lock.c      | 36 ++++-----
> .../bpf/progs/test_stacktrace_build_id.c      | 55 +++++--------
> .../selftests/bpf/progs/test_stacktrace_map.c | 52 +++++-------
> .../selftests/bpf/progs/test_tcp_estats.c     | 13 ++-
> .../selftests/bpf/progs/test_tcpbpf_kern.c    | 26 +++---
> .../selftests/bpf/progs/test_tcpnotify_kern.c | 28 +++----
> tools/testing/selftests/bpf/progs/test_xdp.c  | 26 +++---
> .../selftests/bpf/progs/test_xdp_noinline.c   | 81 +++++++------------
> 20 files changed, 300 insertions(+), 494 deletions(-)

