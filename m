Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7656EB5B
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 21:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728631AbfGSTue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 15:50:34 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:8810 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727602AbfGSTud (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 15:50:33 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6JJihQl005279;
        Fri, 19 Jul 2019 12:50:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=NSUUlEIKSAsQfrTanc7ZDg56vrZAwG3wZjZ2qwTlFmA=;
 b=i/LCraQbQ5JIGK25DidEFi4f/b2l6OCwOlbzKUdlkSZ5TCwaV/eUFkrQIQg2zlNIX3dN
 DIDuyoLEu60qkuA8GQQUSOs4wRJZQvBAYlw+wqMd1WnsC5cV6dTnJ+LiGLepRxHysni2
 A6q5hs7YBSQQE//oI2U0AjVsXfvGHWexMnk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2tufjh96qb-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 19 Jul 2019 12:50:09 -0700
Received: from ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) by
 ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 19 Jul 2019 12:50:07 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 19 Jul 2019 12:50:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G/qH84ENPrlrg4RDEgQpn1SyzoF/FcNYLsmmi6SaIeZ05aicEsJ5XR4rZJTrDQ0ZtN9QOqe0bKM+EACfB3ANz6QtAA47cETiOcqX++lRQqeAJnA5sB3IR5n1HeGXF1ySmvDaucYgjZoG1GHpLu0jS4uyAhMpvwBoU9yg5TDMTMCmmpgnw/wJQdtYbCl+6JD+QF9Qec7HjQ7/EhngwFUsddkpdC+kWxefeA1OUBjiMvaCAQ+imqztXxwOpkvUll4uuyyLP0iVnJSW42M+VUN/M1AnObtZgm5iqUnDQ/S6mRGm2C/GtHrq+eeavketItJWKU0hngxZniAlWumdfx8yZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NSUUlEIKSAsQfrTanc7ZDg56vrZAwG3wZjZ2qwTlFmA=;
 b=YQOCs4AEr6ch7396EOuQBCj8X4UVcTzAJUTA7aBKLXbF4IJaV9NgqXdivzNFpTYKlq4SKVpZHEcdAwTtrJem9G8WVSGltJh+YmZJLJzEbD03mPDnj3cIhgJfYJB/rbfpz/nYL4rEymuSAWia0X6ayuTa3mYz+yUWR9O6ID0/DVggA2k202dFdk3WqETwz0e9vDtsqakl3vzoWuHThCCqQ6C6QcNH9ewFAoeRQ25zhH6AFNOWxlYQ2KUPucp4YUcwfY82Lht4Ozu96Lm6/OFZL6dNvbCIrRiC6V6OzqJrDSAa/+St4Z9fxRoDGc7h4tZwRPj22lMBzu4sBaREqhTYQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NSUUlEIKSAsQfrTanc7ZDg56vrZAwG3wZjZ2qwTlFmA=;
 b=LdqmtUNq6Z7uK7+vOToQnPV5RNP9IYpb31S1hhWrfR2bQMLRJ54O6aMnJ/G/TkGY37o5BOW9a+pANoWHib/KvgNFqtmy9UJuDKkINMG9qzzY4TwoXANlNraee22N/YAMFSkvHgTzyEEj4EqkLqOsWX8ITa3gLYkouGs7t5xi/tw=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB3319.namprd15.prod.outlook.com (20.179.58.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.11; Fri, 19 Jul 2019 19:50:05 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::b964:e4e:5b14:fa7]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::b964:e4e:5b14:fa7%6]) with mapi id 15.20.2073.012; Fri, 19 Jul 2019
 19:50:05 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Andrey Ignatov <rdna@fb.com>
CC:     "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf] libbpf: sanitize VAR to conservative 1-byte INT
Thread-Topic: [PATCH bpf] libbpf: sanitize VAR to conservative 1-byte INT
Thread-Index: AQHVPmqe/LplmdIpI0iDkI4qqXFKeqbSWXqA
Date:   Fri, 19 Jul 2019 19:50:05 +0000
Message-ID: <3ef85585-5f6b-9556-6896-536090b16f0a@fb.com>
References: <20190719194603.2704713-1-andriin@fb.com>
In-Reply-To: <20190719194603.2704713-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR02CA0025.namprd02.prod.outlook.com
 (2603:10b6:301:60::14) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:a5f3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 25a4de96-f75a-4571-4c41-08d70c824bad
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB3319;
x-ms-traffictypediagnostic: BYAPR15MB3319:
x-microsoft-antispam-prvs: <BYAPR15MB331945057B5DD883D3D03E4FD7CB0@BYAPR15MB3319.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 01039C93E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(376002)(366004)(396003)(39860400002)(199004)(189003)(6506007)(386003)(53546011)(4326008)(4744005)(486006)(316002)(76176011)(478600001)(2201001)(71200400001)(71190400001)(66946007)(8676002)(2906002)(6512007)(66476007)(476003)(2616005)(31696002)(6636002)(11346002)(46003)(6436002)(86362001)(446003)(256004)(6486002)(14444005)(229853002)(6246003)(110136005)(66446008)(66556008)(31686004)(186003)(14454004)(68736007)(36756003)(81166006)(305945005)(25786009)(81156014)(52116002)(8936002)(99286004)(6116002)(64756008)(5660300002)(54906003)(2501003)(102836004)(53936002)(7736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3319;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: syARVtYHrfuotcvNcOBKFXdk72gcDlPr9oh1HjETUN3sEe2Xeg9akeO8CGMbKE/dfxWb/KYy4gtrCGDJoDN4BMZ8eDfJzhFMfLQRnxjvZTPCXKVjn6SEgVGFWe5M+PBggMqbilqzIbKeKyZnoElOsYf1ruCJWH40DvUyHLqaBLx40+YbAzY5WjzOi0m4ELsi2b6Ze27AmLwXdyrAQtgd/xihP7EPQQFt7JKEKex+j2TPFXZPEMdtWZ0rbADDRefSGgswYPVxqad/k6/A409VEG1ei1CHGw8Ez/XWZm+uAxzqG26EK112qJyTEebPrQEp25lKHnuCiUZktr+l08wPvOwBaAASIvtGXig6CsOaZdUXZ4xF6Rx8PmQwbebwCg7iT3CXtXPKpqwlU05ksNVANVBRXnUb16v0Fd4O1rTaQYc=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A40536B537CA5C4B80CE15B8256EF44E@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 25a4de96-f75a-4571-4c41-08d70c824bad
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2019 19:50:05.3923
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ast@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3319
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-19_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=887 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907190212
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNy8xOS8xOSAxMjo0NiBQTSwgQW5kcmlpIE5ha3J5aWtvIHdyb3RlOg0KPiBJZiBWQVIgaW4g
bm9uLXNhbml0aXplZCBCVEYgd2FzIHNpemUgbGVzcyB0aGFuIDQsIGNvbnZlcnRpbmcgc3VjaCBW
QVINCj4gaW50byBhbiBJTlQgd2l0aCBzaXplPTQgd2lsbCBjYXVzZSBCVEYgdmFsaWRhdGlvbiBm
YWlsdXJlIGR1ZSB0bw0KPiB2aW9sYXRpb25nIG9mIFNUUlVDVCAoaW50byB3aGljaCBEQVRBU0VD
IHdhcyBjb252ZXJ0ZWQpIG1lbWJlciBzaXplLg0KPiBGaXggYnkgY29uc2VydmF0aXZlbHkgdXNp
bmcgc2l6ZT0xLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQW5kcmlpIE5ha3J5aWtvIDxhbmRyaWlu
QGZiLmNvbT4NCg0KQXBwbGllZC4gVGhhbmtzDQo=
