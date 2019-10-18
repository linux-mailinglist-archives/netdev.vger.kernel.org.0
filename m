Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1D1BDCBC6
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 18:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437321AbfJRQo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 12:44:28 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22016 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2408749AbfJRQo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 12:44:27 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9IGh0HD015651;
        Fri, 18 Oct 2019 09:44:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=+UkI4WlqGnJwH5++X/Da96giXkUGNE5rspp9tEDj6xI=;
 b=EwD8TFAs9kVBBEDmdlvzsBKcrfVJbErUy4sSjZIFfzobR3zC2CvS2CB5Gt2HgA4AuSmL
 rsqcU3cJzlfnXg+3IsBA41XojXnhhknI1Y/XxSYUrLnZdbKjeyya6tf8SXhF9f3DwURX
 cNCHJI/94biCNynDn+cHoDZil5gCjBKnj7k= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vqeungrq4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 18 Oct 2019 09:44:09 -0700
Received: from prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 18 Oct 2019 09:44:08 -0700
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 18 Oct 2019 09:44:08 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 18 Oct 2019 09:44:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=boesN+O++I2/gg6/6OfD/b1cSAk+je/71q0yefXLYX1A7KAhzBF0I8L6FJcy4cNASgyaG3Ne1LiRoUFYoF+w7VCuzyDjyaLA8tA9eY3oSSxNRUDWFWACbd3l2JuWWJ3qpDPwy5uxeLVji/Fs4ElZ09MudXaOC2vskCsyBKvth9zTUpaCuMGCSNgLJOaeSBjuwZk0GrrJ8NkJHItrvemwNBse2LY4KQ2tomWBwEBNjELI4c6H5Gb/s87vqWO6JJoWaBAr/bjvaMX4AQISEkuI9cyvtSMYyO/D6Pt49zQ9UJOo175vW8VcpfomQhdgByVSEepXrQ+2RxHV7IAoXh3UGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+UkI4WlqGnJwH5++X/Da96giXkUGNE5rspp9tEDj6xI=;
 b=JXQSVJUsxnbWK0Bv2jwsCU4exyTq7ImvhPNix0bvpzMArn6BDUEm8Gy+FubZ2RvGi4ZO3Xa7Cv6sYC+6m0U1Y6LwbKQu/982JIe+enBeqyRK+VN/RCIQnthGQ/5O23x0qNpkYJS3qOcydV4+FgJ1aQVMSeGNGpW3LXjQqoIEl1Tco3nQ/yO2tdaPUDUdeRtkcrqjE6TUVeL1TIFzEP01i9QrerBqo36wseui4YSZMCfRfEpVJtcAYowaroFNERaXPNRLR/TqX3k1jiOj3HRSHjJG+BgrPpL7zE/7cQax0hlRTdmPmYPkbvsbFaP+x0ZMVrC4Kt8D4ODcOgzHaqA19A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+UkI4WlqGnJwH5++X/Da96giXkUGNE5rspp9tEDj6xI=;
 b=h8al7OZJugEtx2nawCV2undULNBeTKH9priBzlpmy1PdUrZooG/QiHs/C/Wfuvzj8IIpIVs9qCdZNjT6UuDi9GCEORbtJj23D8aPnxjJA3EhekLR8nGt0dir/wKv9gk6Mu7jR00h8WXWJ6yaoPFKvYFKer0bEnllGsNNEpKX/E4=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB3159.namprd15.prod.outlook.com (20.178.207.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Fri, 18 Oct 2019 16:44:00 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d%5]) with mapi id 15.20.2347.024; Fri, 18 Oct 2019
 16:44:00 +0000
From:   Yonghong Song <yhs@fb.com>
To:     =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [PATCH bpf] xdp: Prevent overflow in devmap_hash cost calculation
 for 32-bit builds
Thread-Topic: [PATCH bpf] xdp: Prevent overflow in devmap_hash cost
 calculation for 32-bit builds
Thread-Index: AQHVhNnFD9d5pJIOhEuDmXWPa+fSQqdgnMSA
Date:   Fri, 18 Oct 2019 16:44:00 +0000
Message-ID: <bad3785d-e4d9-82e7-c5ef-f70e44616711@fb.com>
References: <20191017105702.2807093-1-toke@redhat.com>
In-Reply-To: <20191017105702.2807093-1-toke@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR01CA0046.prod.exchangelabs.com (2603:10b6:300:101::32)
 To BYAPR15MB3384.namprd15.prod.outlook.com (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:3455]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 10dc147a-faae-4db7-4c68-08d753ea6086
x-ms-traffictypediagnostic: BYAPR15MB3159:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB315920F1F2A952801619E08FD36C0@BYAPR15MB3159.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:758;
x-forefront-prvs: 01949FE337
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(376002)(136003)(39860400002)(346002)(366004)(189003)(199004)(2616005)(6246003)(81166006)(81156014)(86362001)(8676002)(4326008)(110136005)(36756003)(31696002)(6636002)(14444005)(11346002)(316002)(256004)(446003)(186003)(476003)(54906003)(6116002)(486006)(46003)(25786009)(66574012)(2906002)(6436002)(305945005)(229853002)(66476007)(66446008)(66556008)(66946007)(99286004)(14454004)(4744005)(6512007)(102836004)(52116002)(53546011)(478600001)(7736002)(5660300002)(2501003)(6506007)(386003)(31686004)(6486002)(8936002)(76176011)(71200400001)(71190400001)(64756008);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3159;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XG64HEwQpcnScKwkWn278NRpIIv+EGAWPmIG/i0NKFCCMfNaKfGGY9cGhjNgYopeRJ5eaxxRFrsACcFWBl8o+YDk7vY4UP4D2KU4fK9q96RlvcGz2QMwq+pbKKNQ2j3qXDEZE5hmylH9rYR3ebFdtO/fY5rLfbC7AcnoTls2jMkIMQTgqVakbWm7ETGWQUOg+0U8D6nRAuDri62i0PtQ4B1ub0n3lSoFl0ObTveqYsWjRKv+nJk5lqnUTTfSpsSRKvJKjns+ES1d9vNszqsqqQwWwYxkOkR0e8xky0MqNKZ/pPsMAt+GZ1kc18jk952zKMILpAcF3y7L2Kf0lzmqcCzwYRq5OmWLdvgWnIZUyYaL8yy6yFeU1bNsxc7e556yjSn6DVI8u1nmRaJlrpAl7SLJvGQWpuLr+u3rnElgPCw=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A03305F5B331214796BF2F00BE615EB3@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 10dc147a-faae-4db7-4c68-08d753ea6086
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2019 16:44:00.6089
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iBy9w3xifP5jNGdOt1rRBuYnJCZznUbwuPsKzTB5OFYmuWz5OXpGBwc4wBn3ZZ22
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3159
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-18_04:2019-10-18,2019-10-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0 clxscore=1011
 spamscore=0 adultscore=0 suspectscore=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910180152
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEwLzE3LzE5IDM6NTcgQU0sIFRva2UgSMO4aWxhbmQtSsO4cmdlbnNlbiB3cm90ZToN
Cj4gVGV0c3VvIHBvaW50ZWQgb3V0IHRoYXQgd2l0aG91dCBhbiBleHBsaWNpdCBjYXN0LCB0aGUg
Y29zdCBjYWxjdWxhdGlvbiBmb3INCj4gZGV2bWFwX2hhc2ggdHlwZSBtYXBzIGNvdWxkIG92ZXJm
bG93IG9uIDMyLWJpdCBidWlsZHMuIFRoaXMgYWRkcyB0aGUNCj4gbWlzc2luZyBjYXN0Lg0KPiAN
Cj4gRml4ZXM6IDZmOWQ0NTFhYjFhMyAoInhkcDogQWRkIGRldm1hcF9oYXNoIG1hcCB0eXBlIGZv
ciBsb29raW5nIHVwIGRldmljZXMgYnkgaGFzaGVkIGluZGV4IikNCj4gUmVwb3J0ZWQtYnk6IFRl
dHN1byBIYW5kYSA8cGVuZ3Vpbi1rZXJuZWxAaS1sb3ZlLnNha3VyYS5uZS5qcD4NCj4gU2lnbmVk
LW9mZi1ieTogVG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2VuIDx0b2tlQHJlZGhhdC5jb20+DQoNCkFj
a2VkLWJ5OiBZb25naG9uZyBTb25nIDx5aHNAZmIuY29tPg0KDQo+IC0tLQ0KPiAgIGtlcm5lbC9i
cGYvZGV2bWFwLmMgfCAyICstDQo+ICAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAx
IGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEva2VybmVsL2JwZi9kZXZtYXAuYyBiL2tl
cm5lbC9icGYvZGV2bWFwLmMNCj4gaW5kZXggYTBhMTE1M2RhNWFlLi5lMzRmYWM2MDIyZWIgMTAw
NjQ0DQo+IC0tLSBhL2tlcm5lbC9icGYvZGV2bWFwLmMNCj4gKysrIGIva2VybmVsL2JwZi9kZXZt
YXAuYw0KPiBAQCAtMTI4LDcgKzEyOCw3IEBAIHN0YXRpYyBpbnQgZGV2X21hcF9pbml0X21hcChz
dHJ1Y3QgYnBmX2R0YWIgKmR0YWIsIHVuaW9uIGJwZl9hdHRyICphdHRyKQ0KPiAgIA0KPiAgIAkJ
aWYgKCFkdGFiLT5uX2J1Y2tldHMpIC8qIE92ZXJmbG93IGNoZWNrICovDQo+ICAgCQkJcmV0dXJu
IC1FSU5WQUw7DQo+IC0JCWNvc3QgKz0gc2l6ZW9mKHN0cnVjdCBobGlzdF9oZWFkKSAqIGR0YWIt
Pm5fYnVja2V0czsNCj4gKwkJY29zdCArPSAodTY0KSBzaXplb2Yoc3RydWN0IGhsaXN0X2hlYWQp
ICogZHRhYi0+bl9idWNrZXRzOw0KPiAgIAl9DQo+ICAgDQo+ICAgCS8qIGlmIG1hcCBzaXplIGlz
IGxhcmdlciB0aGFuIG1lbWxvY2sgbGltaXQsIHJlamVjdCBpdCAqLw0KPiANCg==
