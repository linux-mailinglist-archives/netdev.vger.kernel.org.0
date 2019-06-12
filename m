Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B592244922
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 19:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729376AbfFMROb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 13:14:31 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49692 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728829AbfFLVyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 17:54:06 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5CLrSrn020419;
        Wed, 12 Jun 2019 14:53:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=PDAWZenloNary9FLSZqWfTT4ENNMxgahrUyg23d4ttY=;
 b=DJtFQp1R9JE6ItJt3HxDEB/+C8AiT8Hr2GD1uu3oei9sAkA8jHuWlB4j3ERz1UQw3sPD
 +QoejR6cUVnIT+hkX911cPVQwbUhDBLnk38uvCm0zPXCRgnLHHrRS4zGek9tNnYzYU+D
 MdVSG7lOWtdEAudoYz5JDR/79QPs97YkfKA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2t38x6r5bd-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 12 Jun 2019 14:53:44 -0700
Received: from ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 12 Jun 2019 14:53:38 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 12 Jun 2019 14:53:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PDAWZenloNary9FLSZqWfTT4ENNMxgahrUyg23d4ttY=;
 b=DHganTDp0R9kqrz3FKfME2Kxj5vrzTBATjIGuy86Tx8mr3f3g1EPLADijB4AU/jfac+g8ZKjkXWGsRAuO6xdSv7TL3xJJB23AtSukQmjsyBNpDjRHadhS4bBL2vX0GYONltsmVI8o+T+PtiWbfoie8wIWuu/YG0ClEjws9ynf7I=
Received: from SN6PR15MB2512.namprd15.prod.outlook.com (52.135.66.25) by
 SN6PR15MB2511.namprd15.prod.outlook.com (52.135.66.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Wed, 12 Jun 2019 21:53:36 +0000
Received: from SN6PR15MB2512.namprd15.prod.outlook.com
 ([fe80::6077:6c8d:6f63:6494]) by SN6PR15MB2512.namprd15.prod.outlook.com
 ([fe80::6077:6c8d:6f63:6494%5]) with mapi id 15.20.1965.017; Wed, 12 Jun 2019
 21:53:36 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Stanislav Fomichev <sdf@fomichev.me>, Martin Lau <kafai@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David Miller" <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 2/2] bpf: Add test for SO_REUSEPORT_DETACH_BPF
Thread-Topic: [PATCH bpf-next 2/2] bpf: Add test for SO_REUSEPORT_DETACH_BPF
Thread-Index: AQHVIVHaEYjyGQrSF0mXM1zpnaQpr6aYb/6AgAAZkQCAAATLgIAAAY8A
Date:   Wed, 12 Jun 2019 21:53:35 +0000
Message-ID: <3045141f-298c-59ae-41a7-d8bc79048786@fb.com>
References: <20190612190536.2340077-1-kafai@fb.com>
 <20190612190539.2340343-1-kafai@fb.com> <20190612195917.GB9056@mini-arch>
 <20190612213046.e7tkduk5nfuv5s6a@kafai-mbp.dhcp.thefacebook.com>
 <20190612214757.GC9056@mini-arch>
In-Reply-To: <20190612214757.GC9056@mini-arch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR2001CA0011.namprd20.prod.outlook.com
 (2603:10b6:301:15::21) To SN6PR15MB2512.namprd15.prod.outlook.com
 (2603:10b6:805:25::25)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:70be]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e94540b2-74a9-4af8-cbba-08d6ef806b7d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:SN6PR15MB2511;
x-ms-traffictypediagnostic: SN6PR15MB2511:
x-microsoft-antispam-prvs: <SN6PR15MB2511F2A955B0A0F31593AB3CD7EC0@SN6PR15MB2511.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0066D63CE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(346002)(366004)(136003)(39860400002)(376002)(199004)(189003)(71190400001)(229853002)(31686004)(6486002)(476003)(2616005)(11346002)(486006)(6116002)(46003)(68736007)(305945005)(7736002)(5660300002)(6436002)(446003)(6512007)(66946007)(64756008)(2906002)(8936002)(256004)(71200400001)(66476007)(99286004)(52116002)(66556008)(4326008)(53546011)(102836004)(76176011)(81156014)(6506007)(386003)(25786009)(478600001)(14454004)(53936002)(36756003)(86362001)(6246003)(31696002)(73956011)(81166006)(110136005)(54906003)(8676002)(66446008)(186003)(6636002)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR15MB2511;H:SN6PR15MB2512.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Y/UdRJdN7MI4o+Cb9UT6TJ5e47xl0QIydC9ld9Td6konlEHaVAng74FvoHBt4wouK6Lkb0G+hkAW38Zoo/+LV+GUCScNRI1BQKgjNMGiwPdlh99Z0K3mNoSmk2D93L4xYNd8c0pud+VbwEdvjbuBOG3LmPVzYvYN65IRSx/p9pwCCBeY/L5Q1Dvy2tgs75Ps4q7NL7FXWIhu86BR+Esel5+4AIrLrKdTNACMq2DGx4/166NCZ2fMP256OwvJ3m0/QpOrKaLrBHiMFB4qABq/7P4aCfN1LiHDLs3j+mJ9eLqdV1J+qkvazoWzHFlzI5NqkYst5IxbruxvABXYnJoFs2Pd0uuwEShSNgMp0PKbxvEHakeTP4sMytOu32RpX+KWOcdozd9OHGrjiyhzt5EyDAhpHSm7gwsAXJH6B/+klPs=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4BCB1AEC6E34B94892EFB6601E54A64E@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e94540b2-74a9-4af8-cbba-08d6ef806b7d
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2019 21:53:35.9631
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ast@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2511
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-12_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=632 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906120152
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNi8xMi8xOSAyOjQ3IFBNLCBTdGFuaXNsYXYgRm9taWNoZXYgd3JvdGU6DQo+Pj4+IENGTEFH
UyArPSAtV2FsbCAtTzIgLUkkKEFQSURJUikgLUkkKExJQkRJUikgLUkkKEJQRkRJUikgLUkkKEdF
TkRJUikgJChHRU5GTEFHUykgLUkuLi8uLi8uLi9pbmNsdWRlIFwNCj4+Pj4gKwkgIC1JLi4vLi4v
Li4vLi4vdXNyL2luY2x1ZGUvICBcDQo+Pj4gV2h5IG5vdCBjb3B5IGlubHVkZS91YXBpL2FzbS1n
ZW5lcmljL3NvY2tldC5oIGludG8gdG9vbHMvaW5jbHVkZQ0KPj4+IGluc3RlYWQ/IFdpbGwgdGhh
dCB3b3JrPw0KPj4gU3VyZS4gSSBhbSBvayB3aXRoIGNvcHkuICBJIGRvbid0IHRoaW5rIHdlIG5l
ZWQgdG8gc3luYyB2ZXJ5IG9mdGVuLg0KPj4gRG8geW91IGtub3cgaG93IHRvIGRvIHRoYXQgY29u
c2lkZXJpbmcgbXVsdGlwbGUgYXJjaCdzIHNvY2tldC5oDQo+PiBoYXZlIGJlZW4gY2hhbmdlZCBp
biBQYXRjaCAxPw0KPiBObywgSSBkb24ndCBrbm93IGhvdyB0byBoYW5kbGUgYXJjaCBzcGVjaWZp
YyBzdHVmZi4gSSBzdWdnZXN0IHRvIGNvcHkNCj4gYXNtLWdlbmVyaWMgYW5kIGhhdmUgaWZkZWZz
IGluIHRoZSB0ZXN0cyBpZiBzb21lb25lIGNvbXBsYWluczotKQ0KPiANCj4+IElzIGNvcHkgYmV0
dGVyPw0KPiBEb2Vzbid0IC4uLy4uLy4uLy4uL3Vzci9pbmNsdWRlIHByb3ZpZGUgdGhlIHNhbWUg
aGVhZGVycyB3ZSBoYXZlIGluDQo+IHRvb2xzL2luY2x1ZGUvdWFwaT8gSWYgeW91IGFkZCAtSS4u
Ly4uLy4uLy4uL3Vzci9pbmNsdWRlLCB0aGVuIGlzIHRoZXJlDQo+IGEgcG9pbnQgb2YgaGF2aW5n
IGNvcGllcyB1bmRlciB0b29scy9pbmNsdWRlL3VhcGk/IEkgZG9uJ3QgcmVhbGx5DQo+IGtub3cg
d2h5IHdlIGtlZXAgdGhlIGNvcGllcyB1bmRlciB0b29scy9pbmNsdWRlL3VhcGkgcmF0aGVyIHRo
YW4gaW5jbHVkaW5nDQo+IC4uLy4uLy4uL3Vzci9pbmNsdWRlIGRpcmVjdGx5Lg0KDQpmb3Igb3V0
LW9mLXNyYyBidWlsZHMgLi4vLi4vLi4vLi4vdXNyL2luY2x1ZGUvIGRpcmVjdG9yeSBkb2Vzbid0
IGV4aXN0Lg0KDQoNCg==
