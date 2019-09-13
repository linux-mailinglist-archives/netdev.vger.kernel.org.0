Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2E19B2563
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 20:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389924AbfIMSuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 14:50:07 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:2496 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389736AbfIMSuH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 14:50:07 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x8DInQER025441;
        Fri, 13 Sep 2019 11:49:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=vktzZLKxei6r6ivrBeL3zvKXpomJQxlWPdtTlVyY1pY=;
 b=c53W2KFJwVXdMiFt6aPMP+C+v2eJLhfUUtRTKbn5C5gV4dpKzDKAz5Eh7ABM86U8cCiV
 Ba3ZGOg4W12jqsx2p2R0Ro5h68psLRjmFiNx30A3LYaAgFI8WznQP5hlpTifE1oU1uE/
 B3oE00/inDcjBSxv3GEiEpyW8axgYyRWI5k= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2uytctwfrv-13
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 13 Sep 2019 11:49:39 -0700
Received: from prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 13 Sep 2019 11:48:56 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 13 Sep 2019 11:48:56 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 13 Sep 2019 11:48:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AaTekUGvaFCm6t5Fhv/dswHB6/HGAjtFrP59evqygvTidEtKQyWICEB9l5nYNczuaZ3SJrWFcS3VVp+f4e5L+JrE8YtgXbN04qdTS3kfxCjhg66djdy1h7MLl2tAuPWaHNRCbhZN5f6jIamVtzXfucLO8mXAnZa7p0OienIHP1xG9fiJUNSDfbfmVj/LXIOpLay7Ux1doL7tLGl1PFBoMPEzt/2Re+nX5lBh6X4ef3Q0u5ReXFf0AjS7YU68PK3FAKo0WLkIYSCeV8eqBc6p0bBa7xX+z8gRYK1lDiMW5mzlaQPnPHJRK6AMDWyDjdS7xQS6kVxYpJfA1PkN7I6D1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vktzZLKxei6r6ivrBeL3zvKXpomJQxlWPdtTlVyY1pY=;
 b=WzB/DVfUPV4JttwaxW+UcWhYoCUyQxFILih7fJKPjB1zi91Sidmn/fAclSfSrP34I9gT98pTQIpbnRW54JLeOeyQ7r7GdMc2KJYvKnTAYPWx4Ku8u49uyTDg3S+SRaiMEBfS934Otw3ZPct3Y5Yy3250aMimq5N5RCgvKKLd83OZqOUrRyml/uc1rtXyUZ0VuhvKSKotk4A6ZwGzv/q2J6GUxL7OElGCC1k7mEhvSfC+SC6FVO/V/uI/aNa7V45ph2pOC5q0O6ZxBnmAsb1ZfjUb+UwupKqYnPLRIBwoR/IuDfz1NdduKPOs3C0pCbyd/lvutWX0sCFud+cADKuukw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vktzZLKxei6r6ivrBeL3zvKXpomJQxlWPdtTlVyY1pY=;
 b=Qvop+ZiH1wa5WaTm6pYeMqQEgfQmAMS94+LUc5I4+I8LpuHnSUuqTTq6Gb7pm6IlKQs3ly0+0o2PW/lHv34Od5Nql5gl3wP2gMA2MHdXNoaXRhmyyokybvCSdKUxISbhrrFfkYwl3IaqRrLiRGLKgktu1P1g9Uw5lQPCJNv7Slc=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB2919.namprd15.prod.outlook.com (20.178.239.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.21; Fri, 13 Sep 2019 18:48:54 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::95ab:61a0:29f4:e07e]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::95ab:61a0:29f4:e07e%6]) with mapi id 15.20.2263.021; Fri, 13 Sep 2019
 18:48:54 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Christian Barcenas <christian@cbarcenas.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf] bpf: respect CAP_IPC_LOCK in RLIMIT_MEMLOCK check
Thread-Topic: [PATCH bpf] bpf: respect CAP_IPC_LOCK in RLIMIT_MEMLOCK check
Thread-Index: AQHVaM1lSccL9vuCLEOP978yKyN7eacp9igA
Date:   Fri, 13 Sep 2019 18:48:53 +0000
Message-ID: <246b9dd2-f146-f94c-e029-4b9f6090ec26@fb.com>
References: <20190911181816.89874-1-christian@cbarcenas.com>
In-Reply-To: <20190911181816.89874-1-christian@cbarcenas.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR19CA0093.namprd19.prod.outlook.com
 (2603:10b6:320:1f::31) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::ec5b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: acd08f73-cc0a-45d2-78e1-08d7387b0680
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2919;
x-ms-traffictypediagnostic: BYAPR15MB2919:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2919156CB9862A912363F942D3B30@BYAPR15MB2919.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0159AC2B97
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(396003)(376002)(366004)(39860400002)(199004)(189003)(186003)(2501003)(6116002)(316002)(14454004)(4326008)(25786009)(478600001)(99286004)(46003)(102836004)(76176011)(52116002)(386003)(6506007)(53546011)(8676002)(8936002)(2906002)(110136005)(54906003)(81166006)(81156014)(36756003)(6246003)(53936002)(71200400001)(71190400001)(305945005)(7736002)(229853002)(6486002)(6512007)(6436002)(66446008)(64756008)(66556008)(66476007)(66946007)(446003)(11346002)(2616005)(476003)(86362001)(31696002)(5660300002)(486006)(31686004)(14444005)(256004);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2919;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: TaSuU0T23lxaeBxfCi/03y1+yJpceZE3wVEO6U8qXMQRrSphMEga6U7s4XZ51SHO34ST8GDUSi63nS6P3nCssgFW3fjqLjWkswl27/WoehrDhqFerOTizKiVp+gfD3I//8RNj8pc6iGPiNAI54sn9TazZ4EnPqSu0UvZzM6Oks4vp4lXl/zxAVWPZLSg85xbTNlYRchhTgBA5ejNd6mValqW5gc/v4DBFkAn5AlewQ3u6NQIYjIc62R4VDqqsRxdHjFfqVr1OsJ1gfJA1AFjRsQW6ErPTChlpYBDAEsWNxzhb25F/787gtQgJmsz9wqxln6C3NO08CxbcdlBJ+Bw/mN254rzmmsfqeCMyIeAgbUzRj/Ala5AForsYYe6jQR3/i8wCAaIox7muocPoMjgLF3DV63OP6MF+ko+4zLW7Mk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5630F2F3E9D1D5489C62F6A82B97A347@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: acd08f73-cc0a-45d2-78e1-08d7387b0680
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2019 18:48:54.0138
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m8CchyIQ7RUwx5yFBrE7b9ZQ8M/XJFnDwx42sVL9NGZteZqC39H5Tnnp5KE6TtlH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2919
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-13_08:2019-09-11,2019-09-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 suspectscore=0 priorityscore=1501 adultscore=0
 clxscore=1011 impostorscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909130191
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDkvMTEvMTkgNzoxOCBQTSwgQ2hyaXN0aWFuIEJhcmNlbmFzIHdyb3RlOg0KPiBBIHBy
b2Nlc3MgY2FuIGxvY2sgbWVtb3J5IGFkZHJlc3NlcyBpbnRvIHBoeXNpY2FsIFJBTSBleHBsaWNp
dGx5DQo+ICh2aWEgbWxvY2ssIG1sb2NrYWxsLCBzaG1jdGwsIGV0Yy4pIG9yIGltcGxpY2l0bHkg
KHZpYSBWRklPLA0KPiBwZXJmIHJpbmctYnVmZmVycywgYnBmIG1hcHMsIGV0Yy4pLCBzdWJqZWN0
IHRvIFJMSU1JVF9NRU1MT0NLIGxpbWl0cy4NCj4gDQo+IENBUF9JUENfTE9DSyBhbGxvd3MgYSBw
cm9jZXNzIHRvIGV4Y2VlZCB0aGVzZSBsaW1pdHMsIGFuZCB0aHJvdWdob3V0DQo+IHRoZSBrZXJu
ZWwgdGhpcyBjYXBhYmlsaXR5IGlzIGNoZWNrZWQgYmVmb3JlIGFsbG93aW5nL2RlbnlpbmcgYW4g
YXR0ZW1wdA0KPiB0byBsb2NrIG1lbW9yeSByZWdpb25zIGludG8gUkFNLg0KPiANCj4gQmVjYXVz
ZSBicGYgbG9ja3MgaXRzIHByb2dyYW1zIGFuZCBtYXBzIGludG8gUkFNLCBpdCBzaG91bGQgcmVz
cGVjdA0KPiBDQVBfSVBDX0xPQ0suIFByZXZpb3VzbHksIGJwZiB3b3VsZCByZXR1cm4gRVBFUk0g
d2hlbiBSTElNSVRfTUVNTE9DSyB3YXMNCj4gZXhjZWVkZWQgYnkgYSBwcml2aWxlZ2VkIHByb2Nl
c3MsIHdoaWNoIGlzIGNvbnRyYXJ5IHRvIGRvY3VtZW50ZWQNCj4gUkxJTUlUX01FTUxPQ0srQ0FQ
X0lQQ19MT0NLIGJlaGF2aW9yLg0KPiANCj4gRml4ZXM6IGFhYWMzYmE5NWU0YyAoImJwZjogY2hh
cmdlIHVzZXIgZm9yIGNyZWF0aW9uIG9mIEJQRiBtYXBzIGFuZCBwcm9ncmFtcyIpDQo+IFNpZ25l
ZC1vZmYtYnk6IENocmlzdGlhbiBCYXJjZW5hcyA8Y2hyaXN0aWFuQGNiYXJjZW5hcy5jb20+DQoN
CkFja2VkLWJ5OiBZb25naG9uZyBTb25nIDx5aHNAZmIuY29tPg0KDQo+IC0tLQ0KPiAgIGtlcm5l
bC9icGYvc3lzY2FsbC5jIHwgNSArKystLQ0KPiAgIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlv
bnMoKyksIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEva2VybmVsL2JwZi9zeXNj
YWxsLmMgYi9rZXJuZWwvYnBmL3N5c2NhbGwuYw0KPiBpbmRleCAyNzIwNzFlOTExMmYuLmU1NTE5
NjFmMzY0YiAxMDA2NDQNCj4gLS0tIGEva2VybmVsL2JwZi9zeXNjYWxsLmMNCj4gKysrIGIva2Vy
bmVsL2JwZi9zeXNjYWxsLmMNCj4gQEAgLTE4Myw4ICsxODMsOSBAQCB2b2lkIGJwZl9tYXBfaW5p
dF9mcm9tX2F0dHIoc3RydWN0IGJwZl9tYXAgKm1hcCwgdW5pb24gYnBmX2F0dHIgKmF0dHIpDQo+
ICAgc3RhdGljIGludCBicGZfY2hhcmdlX21lbWxvY2soc3RydWN0IHVzZXJfc3RydWN0ICp1c2Vy
LCB1MzIgcGFnZXMpDQo+ICAgew0KPiAgIAl1bnNpZ25lZCBsb25nIG1lbWxvY2tfbGltaXQgPSBy
bGltaXQoUkxJTUlUX01FTUxPQ0spID4+IFBBR0VfU0hJRlQ7DQo+ICsJdW5zaWduZWQgbG9uZyBs
b2NrZWQgPSBhdG9taWNfbG9uZ19hZGRfcmV0dXJuKHBhZ2VzLCAmdXNlci0+bG9ja2VkX3ZtKTsN
Cj4gICANCj4gLQlpZiAoYXRvbWljX2xvbmdfYWRkX3JldHVybihwYWdlcywgJnVzZXItPmxvY2tl
ZF92bSkgPiBtZW1sb2NrX2xpbWl0KSB7DQo+ICsJaWYgKGxvY2tlZCA+IG1lbWxvY2tfbGltaXQg
JiYgIWNhcGFibGUoQ0FQX0lQQ19MT0NLKSkgew0KPiAgIAkJYXRvbWljX2xvbmdfc3ViKHBhZ2Vz
LCAmdXNlci0+bG9ja2VkX3ZtKTsNCj4gICAJCXJldHVybiAtRVBFUk07DQo+ICAgCX0NCj4gQEAg
LTEyMzEsNyArMTIzMiw3IEBAIGludCBfX2JwZl9wcm9nX2NoYXJnZShzdHJ1Y3QgdXNlcl9zdHJ1
Y3QgKnVzZXIsIHUzMiBwYWdlcykNCj4gICANCj4gICAJaWYgKHVzZXIpIHsNCj4gICAJCXVzZXJf
YnVmcyA9IGF0b21pY19sb25nX2FkZF9yZXR1cm4ocGFnZXMsICZ1c2VyLT5sb2NrZWRfdm0pOw0K
PiAtCQlpZiAodXNlcl9idWZzID4gbWVtbG9ja19saW1pdCkgew0KPiArCQlpZiAodXNlcl9idWZz
ID4gbWVtbG9ja19saW1pdCAmJiAhY2FwYWJsZShDQVBfSVBDX0xPQ0spKSB7DQo+ICAgCQkJYXRv
bWljX2xvbmdfc3ViKHBhZ2VzLCAmdXNlci0+bG9ja2VkX3ZtKTsNCj4gICAJCQlyZXR1cm4gLUVQ
RVJNOw0KPiAgIAkJfQ0KPiANCg==
