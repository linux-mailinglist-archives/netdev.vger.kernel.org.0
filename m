Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB3BFD19E
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 00:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbfKNXjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 18:39:47 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:10268 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726767AbfKNXjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 18:39:47 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xAENdUvB029521;
        Thu, 14 Nov 2019 15:39:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=G9BBACc9W/YM5yq3zWhQnOz9DTZ4LGa6Ta4Wy9a6Mts=;
 b=FVIdQTtZDgKxL5pciSZj+hg+DIo7ZpVwKaPlG6SWDjyO5ExaUc3TooJnKloqB2uw/56C
 buz/bIL+Xi2s3/xCXr2NvsHbHGz6C7VobKbzjC0yyYk+mQAh8OV+yIDc8u4NB8/nUjUw
 cn69nNTOFfjMn4CMLX9HznihLP4gYm89HH4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2w9c1avkbk-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 14 Nov 2019 15:39:32 -0800
Received: from prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 14 Nov 2019 15:39:13 -0800
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 14 Nov 2019 15:39:13 -0800
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 14 Nov 2019 15:39:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jzEGgyl5OXXe8GB1nABFo6PyMpdGNYpRWRvfKcW/3BDzuQvurlKxnXemWAWy5bk9WeBfJdS9EW6MhPR6LH1aALpZ1VyurjSVuDsxtgUcP+84sIeFl1W3TTAfqUcujLLjRuY3V4uv50lbSb5mBoSMbXeCKb8krvKmljsvSCgQbTcu5a3Yz+NxVjaLKMz+F+eYHHoe39IDQfzMqCF2k5FZsComJFd6VGexSN1DStShwzNSHOpXVa6oARwVlpIqpRMYhSITW25zSwXOrnH1Vi3SEs8U5ZJ+o6QOMqcL9u99TpD6yoxVfnzTMJihqluNTuJKLcwllJ905CfvhvhyYV7Auw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G9BBACc9W/YM5yq3zWhQnOz9DTZ4LGa6Ta4Wy9a6Mts=;
 b=brovpoV7szpfGOyR/8pkGkwHEZKcItXqlbuHwXAsPOasOzJnK1j1+VT967PgCy4+yaqkFi9JjIR6BuVYVI+O4wtPkPPr9o+IjWBiRzD8jwlLn+bt7ysgdfMUcKLE5zvHS5t+O8iKuHq3O2ecHDvadEGvYwv/wEbsINMPrksAeilGosZDko0zmqVqgZD3bI9I2TPsyOE+rtbXaWVmTD/nehTmfs0k5gX1pAGTii7djGQLn2SiNYMtiG4D4mh/Yx2n3RheABmw7VVNR3wOhjqUKmhYLmDXQLYI3eV6DrlzeqVmujii4bw+pFNalqfdqFF9voArROZLxH92/MPVwTeL9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G9BBACc9W/YM5yq3zWhQnOz9DTZ4LGa6Ta4Wy9a6Mts=;
 b=Z7m5SPv6u1z/wX18MfvJDtytLeq8fuYRXbipA3cXlsSUMkuWq/TBAkXiyKA3fJVjGwnMZ4b7lhHY39v9DJaQ/oD6piuT7J44+YXn+djgwXsjK2Q7dTVOpTNQDWsqXmmdO2Qxo96jPTMZFCcBdwkIE5vOaKEQaqT5TvOkhCQeLpQ=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1902.namprd15.prod.outlook.com (10.174.255.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Thu, 14 Nov 2019 23:39:13 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::f831:d112:6187:90d9]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::f831:d112:6187:90d9%4]) with mapi id 15.20.2451.027; Thu, 14 Nov 2019
 23:39:13 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v4 bpf-next 18/20] libbpf: Add support for attaching BPF
 programs to other BPF programs
Thread-Topic: [PATCH v4 bpf-next 18/20] libbpf: Add support for attaching BPF
 programs to other BPF programs
Thread-Index: AQHVmx2TVpNlU2N9bE6ZZ6hLUi2bBaeLUzQA
Date:   Thu, 14 Nov 2019 23:39:12 +0000
Message-ID: <DB8B7F4F-BDB4-4821-99DB-E814A3EBE966@fb.com>
References: <20191114185720.1641606-1-ast@kernel.org>
 <20191114185720.1641606-19-ast@kernel.org>
In-Reply-To: <20191114185720.1641606-19-ast@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3601.0.10)
x-originating-ip: [2620:10d:c090:200::3:e9ac]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9d962db7-5e6a-45e2-7668-08d7695bdad7
x-ms-traffictypediagnostic: MWHPR15MB1902:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB1902E58B287961A0F7124304B3710@MWHPR15MB1902.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:321;
x-forefront-prvs: 02213C82F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(396003)(346002)(39860400002)(366004)(199004)(189003)(66556008)(66446008)(64756008)(6486002)(186003)(558084003)(5024004)(256004)(6436002)(50226002)(25786009)(316002)(478600001)(46003)(54906003)(229853002)(99286004)(6246003)(5660300002)(86362001)(81156014)(4326008)(71200400001)(71190400001)(8676002)(81166006)(6512007)(66946007)(66476007)(6506007)(2616005)(8936002)(476003)(53546011)(33656002)(6116002)(486006)(2906002)(11346002)(102836004)(76116006)(36756003)(14454004)(6916009)(446003)(305945005)(76176011)(7736002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1902;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: arF3zJFysosBkhGrsMTf0ToW7XDR1XpBKiTGlBUbj/RnM4pbqLRyDOY7qJ5DJ5ZsSDzEcgi7jeMdP2wMZ/7oskQzrC1iBu3vm138YheCWgis2i48J+SzVYTZ6YRq/BH+E+z/J9vTzZRQVjnkpW4NOYQol1RHdSUCmyydQRVvfA7JC97RvQjDeu+OlbxgNJr2AN6Mj5sQ5hqj5yxFDUdmfyftJEyh+O94iHMzVbMj2vOt/8RUzliqU9yJWPyCAbYIn1veqEKo5wGTUmZ/DKiq1fkeEia478ExHa8EOnPteZnJGf/o0AXIsySIaB/XLVDqUD+yWJGDLUhEhkmdA2qvUp2i58rHjhlpFd0HTEfKUaoe2NexCztXK1kEcBDEvENN5PZdGQyPtAGqaFkTPYTBvzHsKENHM5KnHwCGi1IbsjhktPwk2w7KxqtMpRICUiaT
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0FDF3701AC6C084F9076B303C1E5EC69@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d962db7-5e6a-45e2-7668-08d7695bdad7
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2019 23:39:12.8909
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NHgww86Zavp/POgjZeqUOgVASsgAnvGdwjInhV/R9X1eKacu/mimtfFi4mdT4UZrvPHptbLlWD5mxN7p/Rqlrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1902
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-14_05:2019-11-14,2019-11-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxlogscore=778 adultscore=0 impostorscore=0 bulkscore=0 phishscore=0
 spamscore=0 mlxscore=0 suspectscore=0 clxscore=1015 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911140194
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 14, 2019, at 10:57 AM, Alexei Starovoitov <ast@kernel.org> wrote:
>=20
> Extend libbpf api to pass attach_prog_fd into bpf_object__open.
>=20
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>
