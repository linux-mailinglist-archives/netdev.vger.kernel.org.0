Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEE4558836
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 19:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbfF0RWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 13:22:48 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48786 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726315AbfF0RWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 13:22:48 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5RHJoMk012500;
        Thu, 27 Jun 2019 10:22:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=U7P2C4VweQI9LwyPsoPa9g1QOcRjKZWBlUSG43oQA7M=;
 b=njvpdRX2WMTIsSs+/TSDM2fPXXVB7o7rOBtCmrrCDdDdgb5FBCliyz91+BfbjvnTVbey
 k/ekDgMfe7tdBA0qBxf3HrtsG+aJO1VvpZNQc5mykZBnIN+ud8QBi8A7xDXRuwTYKK+d
 BAeurOyabVmLQc8Xk8A7P5wEu010UK5k08s= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2td0y50bhh-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 27 Jun 2019 10:22:28 -0700
Received: from prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 27 Jun 2019 10:22:19 -0700
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 27 Jun 2019 10:22:19 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 27 Jun 2019 10:22:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U7P2C4VweQI9LwyPsoPa9g1QOcRjKZWBlUSG43oQA7M=;
 b=gRQ/LsxJiWUwGTO3tdsS9F3jaIcV+3rh37eX43Aeh88bliJ7xSS+TSr5y8foAsYpTQlntVkkqKMuqXZlife2itk3sQR8DF/22aj+pSouV7J+mf8nHWewIQPS6jz2U9kDlD6V/6qAgeO8NAhMpiRY4v3fv/u3IXQ7XIRbri9ys74=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1661.namprd15.prod.outlook.com (10.175.140.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Thu, 27 Jun 2019 17:22:18 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d%6]) with mapi id 15.20.2008.018; Thu, 27 Jun 2019
 17:22:18 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 0/3] capture integers in BTF type info for map
 defs
Thread-Topic: [PATCH bpf-next 0/3] capture integers in BTF type info for map
 defs
Thread-Index: AQHVLHX+snSKpVswGUiINb1jJOrWs6avwNCA
Date:   Thu, 27 Jun 2019 17:22:18 +0000
Message-ID: <10E7849F-0DF3-4AA6-9C08-97DAF0697750@fb.com>
References: <20190626232133.3800637-1-andriin@fb.com>
In-Reply-To: <20190626232133.3800637-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::3:a913]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 770a38c3-3d1b-4fff-521d-08d6fb2401b5
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1661;
x-ms-traffictypediagnostic: MWHPR15MB1661:
x-microsoft-antispam-prvs: <MWHPR15MB1661F0B8A734366932FB92EDB3FD0@MWHPR15MB1661.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 008184426E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(396003)(376002)(346002)(39860400002)(189003)(199004)(36756003)(6506007)(446003)(6486002)(54906003)(256004)(2616005)(102836004)(6512007)(25786009)(14444005)(53546011)(486006)(99286004)(53936002)(2906002)(7736002)(46003)(8936002)(186003)(86362001)(76176011)(14454004)(11346002)(76116006)(66446008)(64756008)(66556008)(66476007)(66946007)(73956011)(6862004)(37006003)(81156014)(316002)(4326008)(478600001)(6116002)(6436002)(6636002)(8676002)(71190400001)(5660300002)(71200400001)(81166006)(229853002)(6246003)(68736007)(305945005)(476003)(33656002)(50226002)(57306001);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1661;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: g+Ithllvb370kqNgUmYlAV3eS2Wj6No6uwOFaW7yRDrmtS5v1/NEFj/jQOJdV8LojeP3Ek3fRFWchztpARl1A7HbHAIUAj/vEk+WtnnNEyIah/1xyOjCds/2gSsWQuIrNZvLWGQCr8WcTpRV3NtBrZY/D1mTfASj8vAhTrBClAslbRHWJglCT3IaUtxbDQvlWnfOjgytc5oH3KhmyA/bJIJI2lqrX2jewAk4RKQ6If09A9VanzImJTYpIHf60OHCWc863vM+pOOgXJ6l8sYqnNB4q06SbssyXUXIgb++sTpw/Aq4u1cAHRIy2Eqqqkg2vvZHN4kclogsfdmc5ym2oBI/hb1Gg5owEYMkRT5Uo5JRwVBWRE79fS7wR5DtoAYYxUJbaC8A2i8Vl8g5XO0bQGN6U+13sjuT368CUw7CpD0=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A5277EAB05830E41B2EC28BC830E03F6@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 770a38c3-3d1b-4fff-521d-08d6fb2401b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2019 17:22:18.4047
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1661
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-27_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906270200
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 26, 2019, at 4:21 PM, Andrii Nakryiko <andriin@fb.com> wrote:
>=20
> This patch set implements an update to how BTF-defined maps are specified=
. The
> change is in how integer attributes, e.g., type, max_entries, map_flags, =
are
> specified: now they are captured as part of map definition struct's BTF t=
ype
> information (using array dimension), eliminating the need for compile-tim=
e
> data initialization and keeping all the metadata in one place.

Using array dimension is hacky. But I guess this work.



>=20
> All existing selftests that were using BTF-defined maps are updated, alon=
g
> with some other selftests, that were switched to new syntax.
>=20
> Andrii Nakryiko (3):
>  libbpf: capture value in BTF type info for BTF-defined map defs
>  selftests/bpf: convert selftests using BTF-defined maps to new syntax
>  selftests/bpf: convert legacy BPF maps to BTF-defined ones
>=20
> tools/lib/bpf/libbpf.c                        |  58 +++++----
> tools/testing/selftests/bpf/bpf_helpers.h     |   3 +
> tools/testing/selftests/bpf/progs/bpf_flow.c  |  28 ++---
> .../selftests/bpf/progs/get_cgroup_id_kern.c  |  26 ++---
> .../testing/selftests/bpf/progs/netcnt_prog.c |  20 ++--
> tools/testing/selftests/bpf/progs/pyperf.h    |  90 +++++++-------
> .../selftests/bpf/progs/sample_map_ret0.c     |  24 ++--
> .../selftests/bpf/progs/socket_cookie_prog.c  |  13 +--
> .../bpf/progs/sockmap_verdict_prog.c          |  48 ++++----
> .../testing/selftests/bpf/progs/strobemeta.h  |  68 +++++------
> .../selftests/bpf/progs/test_btf_newkv.c      |  13 +--
> .../bpf/progs/test_get_stack_rawtp.c          |  39 +++----
> .../selftests/bpf/progs/test_global_data.c    |  37 +++---
> tools/testing/selftests/bpf/progs/test_l4lb.c |  65 ++++-------
> .../selftests/bpf/progs/test_l4lb_noinline.c  |  65 ++++-------
> .../selftests/bpf/progs/test_map_in_map.c     |  30 ++---
> .../selftests/bpf/progs/test_map_lock.c       |  26 ++---
> .../testing/selftests/bpf/progs/test_obj_id.c |  12 +-
> .../bpf/progs/test_select_reuseport_kern.c    |  67 ++++-------
> .../bpf/progs/test_send_signal_kern.c         |  26 ++---
> .../bpf/progs/test_sock_fields_kern.c         |  78 +++++--------
> .../selftests/bpf/progs/test_spin_lock.c      |  36 +++---
> .../bpf/progs/test_stacktrace_build_id.c      |  55 ++++-----
> .../selftests/bpf/progs/test_stacktrace_map.c |  52 +++------
> .../selftests/bpf/progs/test_tcp_estats.c     |  13 +--
> .../selftests/bpf/progs/test_tcpbpf_kern.c    |  26 ++---
> .../selftests/bpf/progs/test_tcpnotify_kern.c |  28 ++---
> tools/testing/selftests/bpf/progs/test_xdp.c  |  26 ++---
> .../selftests/bpf/progs/test_xdp_loop.c       |  26 ++---
> .../selftests/bpf/progs/test_xdp_noinline.c   |  81 +++++--------
> .../selftests/bpf/progs/xdp_redirect_map.c    |  12 +-
> .../testing/selftests/bpf/progs/xdping_kern.c |  12 +-
> .../selftests/bpf/test_queue_stack_map.h      |  30 ++---
> .../testing/selftests/bpf/test_sockmap_kern.h | 110 +++++++++---------
> 34 files changed, 571 insertions(+), 772 deletions(-)
>=20
> --=20
> 2.17.1
>=20

