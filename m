Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A86EB129AC5
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 21:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbfLWUSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 15:18:42 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38768 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726787AbfLWUSm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 15:18:42 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBNKGNq4025871;
        Mon, 23 Dec 2019 12:18:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=9IW1f9sp4zdgDmrQwO0WJMQbwNBuZUKGwEaD0AH5CA0=;
 b=F5MT6fuePwhwfNMtIf9IQmnHUBlAdqb3her9GKgcqOL/Nn2eG4U2Q4pgQlYi8OsZJnYq
 ie3dz1ces3zhQW7+Ie5HBIOuXEPF/lXj5/XTAD1ngfZWcfcWWSRI6EAj2AL/0XAKnB1V
 n8o9Vb87PBRLeT0gLq/oOtvwE2IKVEqqxyE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2x2410dvwn-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 23 Dec 2019 12:18:27 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Mon, 23 Dec 2019 12:18:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zu8tt4P55HcR5rprzbCaTufCg+kbP+we6mNNWi5OIqfpB3eAPESKkw9xD8BWYGJkblb/OJxg+2yOL2/dYYfp+pVIxnZQmsPUGhpypRKtEHN7BUX98FP4s+S2wkEwXNWRotPwLC3U1OfGAo3//Dlg/B4ugMP4GljPeT6B8r/VLpxYpj38HQ2KxdHgQ+TbUUaSyrxrx9WheVJQNQ+8gXZ1lx0TrBlYYMW4JUPYYrWMEyIOiqD7ZnpkQV/Q1iWHiSEpVa+qQlAsdy6mVciyzNP9bdUSOBLT5HjkhdBcw88/8Wljs9TFaYEJrn8UBKpJ1CigigPDFh0rjCOTUuLCrkuUKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9IW1f9sp4zdgDmrQwO0WJMQbwNBuZUKGwEaD0AH5CA0=;
 b=MEdt0aJi5/xsrMQDCYMI/7YeqBSXFstaa2P4QVhBYvVdaedh4mGkqL4Vva40dsi3IJQlSfBXhzHv3U2f0A0OTLL6tdjZxpu/3gf1ozNLnlOnBm+jsX5JmyFQDiFJmvUARWjKtruQAtJZRT0ttydO7ou+tKk109u80iVOyJ8GC73drxdCFBTIv2qB25UgnlMO2WEVPCqi8EgkaD93y1baQRhm1ZqQ7MMdBMBpPM1qGk3r0qgEffFvTFJ57Qx7BRMs9OnA5oo4BBDkYTfBiPBqVf5P1q1gf9nlDFtHwjFJeysxhJ9wosKyt/XV6rsQgIwG3jV8XdP5iZgcrwlPzbuhgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9IW1f9sp4zdgDmrQwO0WJMQbwNBuZUKGwEaD0AH5CA0=;
 b=kHigF/FKt/+5bfeWUzhNNB7h6nDAfVOoesTLrC2m7mcSu72+pNVkGIeVbtjtYvAuUDHwqTNOPeF4BqYYDAFtO24LLKBToqMDNx9vvNzTmCEMqiFLxbUq4d+pfv0jB2YLnHROrUfawkNa6VCXhbvHjiDiDsysbnbOFNOW/fHPyqM=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1449.namprd15.prod.outlook.com (10.173.221.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.17; Mon, 23 Dec 2019 20:18:25 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23%8]) with mapi id 15.20.2559.017; Mon, 23 Dec 2019
 20:18:25 +0000
Received: from macbook-pro-52.dhcp.thefacebook.com (2620:10d:c090:200::4a23) by MWHPR11CA0003.namprd11.prod.outlook.com (2603:10b6:301:1::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2559.14 via Frontend Transport; Mon, 23 Dec 2019 20:18:24 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Martin Lau <kafai@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 07/11] bpf: tcp: Support tcp_congestion_ops in
 bpf
Thread-Topic: [PATCH bpf-next v2 07/11] bpf: tcp: Support tcp_congestion_ops
 in bpf
Thread-Index: AQHVt8eLuQqsxSqWc0CMjuCCix3BFqfILLGA
Date:   Mon, 23 Dec 2019 20:18:25 +0000
Message-ID: <c1e908ca-917b-3d65-1d45-892b0f63ff3c@fb.com>
References: <20191221062556.1182261-1-kafai@fb.com>
 <20191221062611.1183363-1-kafai@fb.com>
In-Reply-To: <20191221062611.1183363-1-kafai@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR11CA0003.namprd11.prod.outlook.com
 (2603:10b6:301:1::13) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::4a23]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a896519e-6f97-49bc-8cfd-08d787e54402
x-ms-traffictypediagnostic: DM5PR15MB1449:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR15MB14497774E2C5DE49F8F79558D32E0@DM5PR15MB1449.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0260457E99
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(376002)(366004)(396003)(346002)(136003)(189003)(199004)(16526019)(110136005)(53546011)(2906002)(31686004)(186003)(316002)(54906003)(2616005)(6486002)(5660300002)(6506007)(52116002)(31696002)(36756003)(66446008)(8936002)(86362001)(66476007)(6512007)(81156014)(64756008)(81166006)(66556008)(8676002)(71200400001)(66946007)(478600001)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1449;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: I9rYt4gzuwdPmgqpFkLt71FTPV5Jz84uOV1kddJUnghlg8JTcHyRXcDg2onbkz6OZ+7WzwEnUw1WTIsxhb6SovkjLQUoKU9AWl8V/QrG8Ftp8pR3KsB3FPmUJp3d54jfm/HvndiZhNBv0VpxQZbZNZRQjdpm5geAzShYphcbVW8/+atP38MRPWPjU3N16bEB9FogGsx2Bd2TLVE/Z8YFgGtevnTIx1MTm8XrjF+pkn2RmG6AXHkbiuIPDhFaC7iqco5JdognOFnvV9FGiHaPTqwXm7OnOU8kmeeeNdnwr0pPfgLSuZ78GnBk5kKTj8eNyltfbeEOCuCS5I/hiIW2DP9auEKyzDnL8af/lYDA5jBUFvbZd3xaYj5UvR+5M66irGwKPtIDKata/G6NReXXGj+XmuN3lPRxBqPM8J/Mr2XqyshgSiIaGFuoGq80B56e
Content-Type: text/plain; charset="utf-8"
Content-ID: <311A2A2EB12FBA469234B88B3A09D0CF@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a896519e-6f97-49bc-8cfd-08d787e54402
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2019 20:18:25.5562
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lNZFfARtvDx+PfLHjUu7wfiQQuBljlftaiL/LHkA7YdhdRGxOOIotJiImtYBhYtD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1449
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-23_09:2019-12-23,2019-12-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 phishscore=0
 mlxlogscore=587 mlxscore=0 bulkscore=0 suspectscore=0 clxscore=1015
 spamscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912230175
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzIwLzE5IDEwOjI2IFBNLCBNYXJ0aW4gS2FGYWkgTGF1IHdyb3RlOg0KPiBUaGlz
IHBhdGNoIG1ha2VzICJzdHJ1Y3QgdGNwX2Nvbmdlc3Rpb25fb3BzIiB0byBiZSB0aGUgZmlyc3Qg
dXNlcg0KPiBvZiBCUEYgU1RSVUNUX09QUy4gIEl0IGFsbG93cyBpbXBsZW1lbnRpbmcgYSB0Y3Bf
Y29uZ2VzdGlvbl9vcHMNCj4gaW4gYnBmLg0KPiANCj4gVGhlIEJQRiBpbXBsZW1lbnRlZCB0Y3Bf
Y29uZ2VzdGlvbl9vcHMgY2FuIGJlIHVzZWQgbGlrZQ0KPiByZWd1bGFyIGtlcm5lbCB0Y3AtY2Mg
dGhyb3VnaCBzeXNjdGwgYW5kIHNldHNvY2tvcHQuICBlLmcuDQo+IFtyb290QGFyY2gtZmItdm0x
IGJwZl0jIHN5c2N0bCAtYSB8IGVncmVwIGNvbmdlc3Rpb24NCj4gbmV0LmlwdjQudGNwX2FsbG93
ZWRfY29uZ2VzdGlvbl9jb250cm9sID0gcmVubyBjdWJpYyBicGZfY3ViaWMNCj4gbmV0LmlwdjQu
dGNwX2F2YWlsYWJsZV9jb25nZXN0aW9uX2NvbnRyb2wgPSByZW5vIGJpYyBjdWJpYyBicGZfY3Vi
aWMNCj4gbmV0LmlwdjQudGNwX2Nvbmdlc3Rpb25fY29udHJvbCA9IGJwZl9jdWJpYw0KPiANCj4g
VGhlcmUgaGFzIGJlZW4gYXR0ZW1wdCB0byBtb3ZlIHRoZSBUQ1AgQ0MgdG8gdGhlIHVzZXIgc3Bh
Y2UNCj4gKGUuZy4gQ0NQIGluIFRDUCkuICAgVGhlIGNvbW1vbiBhcmd1bWVudHMgYXJlIGZhc3Rl
ciB0dXJuIGFyb3VuZCwNCj4gZ2V0IGF3YXkgZnJvbSBsb25nLXRhaWwga2VybmVsIHZlcnNpb25z
IGluIHByb2R1Y3Rpb24uLi5ldGMsDQo+IHdoaWNoIGFyZSBsZWdpdCBwb2ludHMuDQo+IA0KPiBC
UEYgaGFzIGJlZW4gdGhlIGNvbnRpbnVvdXMgZWZmb3J0IHRvIGpvaW4gYm90aCBrZXJuZWwgYW5k
DQo+IHVzZXJzcGFjZSB1cHNpZGVzIHRvZ2V0aGVyIChlLmcuIFhEUCB0byBnYWluIHRoZSBwZXJm
b3JtYW5jZQ0KPiBhZHZhbnRhZ2Ugd2l0aG91dCBieXBhc3NpbmcgdGhlIGtlcm5lbCkuICBUaGUg
cmVjZW50IEJQRg0KPiBhZHZhbmNlbWVudHMgKGluIHBhcnRpY3VsYXIgQlRGLWF3YXJlIHZlcmlm
aWVyLCBCUEYgdHJhbXBvbGluZSwNCj4gQlBGIENPLVJFLi4uKSBtYWRlIGltcGxlbWVudGluZyBr
ZXJuZWwgc3RydWN0IG9wcyAoZS5nLiB0Y3AgY2MpDQo+IHBvc3NpYmxlIGluIEJQRi4gIEl0IGFs
bG93cyBhIGZhc3RlciB0dXJuYXJvdW5kIGZvciB0ZXN0aW5nIGFsZ29yaXRobQ0KPiBpbiB0aGUg
cHJvZHVjdGlvbiB3aGlsZSBsZXZlcmFnaW5nIHRoZSBleGlzdGluZyAoYW5kIGNvbnRpbnVlIGdy
b3dpbmcpDQo+IEJQRiBmZWF0dXJlL2ZyYW1ld29yayBpbnN0ZWFkIG9mIGJ1aWxkaW5nIG9uZSBz
cGVjaWZpY2FsbHkgZm9yDQo+IHVzZXJzcGFjZSBUQ1AgQ0MuDQo+IA0KPiBUaGlzIHBhdGNoIGFs
bG93cyB3cml0ZSBhY2Nlc3MgdG8gYSBmZXcgZmllbGRzIGluIHRjcC1zb2NrDQo+IChpbiBicGZf
dGNwX2NhX2J0Zl9zdHJ1Y3RfYWNjZXNzKCkpLg0KPiANCj4gVGhlIG9wdGlvbmFsICJnZXRfaW5m
byIgaXMgdW5zdXBwb3J0ZWQgbm93LiAgSXQgY2FuIGJlIGFkZGVkDQo+IGxhdGVyLiAgT25lIHBv
c3NpYmxlIHdheSBpcyB0byBvdXRwdXQgdGhlIGluZm8gd2l0aCBhIGJ0Zi1pZA0KPiB0byBkZXNj
cmliZSB0aGUgY29udGVudC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IE1hcnRpbiBLYUZhaSBMYXUg
PGthZmFpQGZiLmNvbT4NCg0KQWNrIGZyb20gYnBmL2J0ZiBwZXJzcGVjdGl2ZS4NCg0KQWNrZWQt
Ynk6IFlvbmdob25nIFNvbmcgPHloc0BmYi5jb20+DQo=
