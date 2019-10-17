Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43E3CDB973
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 00:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503715AbfJQWDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 18:03:05 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:29428 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2441587AbfJQWDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 18:03:05 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9HLwWlk031582;
        Thu, 17 Oct 2019 15:01:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=0F3O/G09+8RDQ956ALlfFPTWWr5h01TaK8Rg/fDAySA=;
 b=ZuPpGPHyoM2lO5KzW5LHgIuxbeLKQdnW6ERbVGMxx4tJwCrPBI6If6TXUlM0iou32PPY
 rCi9lHXPaStNOk2Y7/6Y370I8JQ72bWLCm5GcjYr8p2I9rUxKbyIgA7cO145ciSdQXby
 lObGxXLB3tg3qK7mf2dDB2D8N3GFCuEwR+Y= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vpw9r8y9x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 17 Oct 2019 15:01:51 -0700
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 17 Oct 2019 15:01:50 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 17 Oct 2019 15:01:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dDx89fr2QrNMaTHCpUVyAefqcyj5UndIevqomZWgzkWenuoefie9BU/U5wfnbs9bvSnSlHgBpWhH8UFASn0Hfy2jjd1ReZ4wGRFoT60h4t2bYbNb+QUaqlqFOav1YkQ0iu2bhDU+pen6OkCEBk6zPQCbntCWEZR/3fXuYYkGfg8rJHgumgHF/LoW3Ia9oalqNdjNBDjX9XUcqxOT92atwMGtxUslRuODxxX5SyGOPLbL6kRso/vN10p6tZFvacdaOx5bAbp/cTVrK1ev9gr7Ldc9HmrotqyvVTdwikWlMOqNRLEgKHSp22vhBfZtimvVMrF+v4uX9uK9oGvipKtutQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0F3O/G09+8RDQ956ALlfFPTWWr5h01TaK8Rg/fDAySA=;
 b=hYFRpmUbI9qQ9waTKjONir6sErOuzK5lxm0HmwJ+K6UoqPQ/0LiTBwtSQlUwU3i1dejj47it3w29g9xkngBEEX7nhy9M9G/NqR+E8lFyDyCGmkILCSYAJggusaUElcOMaGVxOF7/JQSVtQ4rp3etM4D/nunard20taxLLh1IVKUi5xg7U8NhkI3vqRZLTRJTkpuxm5Wtl5HgLPHZR5+4NYKOm8X7YlZEAx/HBUDtrHjzt8mykZyv7N4T2Q6co6c1u0fb5DbRwXiZZsnz7s7hWoSRGxFbvALp0QMu3eHcKxD5b78BeaUsUBzVBiPGgoPLky3YJSo6gpmnh0mGioQSgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0F3O/G09+8RDQ956ALlfFPTWWr5h01TaK8Rg/fDAySA=;
 b=g0uoj/R4P0myrukAwCuCs0qWosFby2t1zT3Avj6glb8Ht4OU7/2xj0Fjpb1NOXe1A21KVUjEPe5abs8GPL9y7aW1mZr2hDFY8fcBx7lNVZw7NZcUV1BKWzgaTtAH3SjIBWWoQRcF80NcXebrq/wGGG8PUxWwUn6HOanuRFkQ56A=
Received: from BY5PR15MB3636.namprd15.prod.outlook.com (52.133.252.91) by
 BY5PR15MB3572.namprd15.prod.outlook.com (52.133.255.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Thu, 17 Oct 2019 22:01:49 +0000
Received: from BY5PR15MB3636.namprd15.prod.outlook.com
 ([fe80::7887:4f9c:70df:285c]) by BY5PR15MB3636.namprd15.prod.outlook.com
 ([fe80::7887:4f9c:70df:285c%4]) with mapi id 15.20.2347.023; Thu, 17 Oct 2019
 22:01:49 +0000
From:   Vijay Khemka <vijaykhemka@fb.com>
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        "Sven Van Asbroeck" <TheSven73@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        "Bhupesh Sharma" <bhsharma@redhat.com>,
        YueHaibing <yuehaibing@huawei.com>,
        "Mauro Carvalho Chehab" <mchehab+samsung@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "openbmc @ lists . ozlabs . org" <openbmc@lists.ozlabs.org>,
        "joel@jms.id.au" <joel@jms.id.au>,
        "linux-aspeed@lists.ozlabs.org" <linux-aspeed@lists.ozlabs.org>,
        Sai Dasari <sdasari@fb.com>
Subject: Re: [PATCH v2] ftgmac100: Disable HW checksum generation on AST2500
Thread-Topic: [PATCH v2] ftgmac100: Disable HW checksum generation on AST2500
Thread-Index: AQHVgIJ8iNM2JFB8dkCGpaKji+MwkKdeE2WAgADjLwA=
Date:   Thu, 17 Oct 2019 22:01:48 +0000
Message-ID: <0C0BC813-5A84-403F-9C48-9447AAABD867@fb.com>
References: <20191011213027.2110008-1-vijaykhemka@fb.com>
 <3a1176067b745fddfc625bbd142a41913ee3e3a1.camel@kernel.crashing.org>
In-Reply-To: <3a1176067b745fddfc625bbd142a41913ee3e3a1.camel@kernel.crashing.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2620:10d:c090:200::3:f653]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 63c7cef0-b01f-4e89-6bf1-08d7534d9c09
x-ms-traffictypediagnostic: BY5PR15MB3572:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR15MB35722890CE8F93FAA427069CDD6D0@BY5PR15MB3572.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01930B2BA8
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(136003)(39860400002)(396003)(366004)(346002)(189003)(199004)(110136005)(6246003)(2906002)(54906003)(6436002)(486006)(316002)(11346002)(6116002)(33656002)(14444005)(446003)(229853002)(7736002)(2616005)(256004)(305945005)(71190400001)(71200400001)(14454004)(478600001)(25786009)(46003)(6486002)(7416002)(476003)(4001150100001)(2201001)(4326008)(186003)(99286004)(6512007)(5660300002)(6506007)(36756003)(76176011)(102836004)(2501003)(81166006)(8676002)(91956017)(76116006)(66946007)(81156014)(66476007)(66446008)(66556008)(86362001)(64756008)(8936002)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY5PR15MB3572;H:BY5PR15MB3636.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iedLVTcCEat0NMZl3WTaE/XSuHEGC3DKCWqF88kg3GrdAxuPgrNMg+YOQfOTDsGGXmXOGGSGY9FZ5RZNRqMMXmkUk5ef5JoMF7qUrQHf5yuNSbvpbxo00V/ez+fzSTAy2muQzj3nyzdJh5QfFzauN7bi9VYRIxxHKs19EV9vj+FYl5ibyelolnDa9G83nl68dgpe+wZYDcVA5VHtCA65L5mA+vIh/y2DOt4d51ZUj7QERgnSTURyW4TGleqehQrHUYpidYRQJd0ZRRA0w2v1pS+GWLiEpQ2Wrgpef6hi3+8+j5gihQPV4NrXb4U4U8QBACW0P/8T1EZZVQp1q0Q4NAkA6xOarbU4hQsa58iUZYyd/9GvKi1YQ5UTJPP2e9zt1X95rjW+QoU86rQLe/+JEggRINBmdBI47q/HnVzRAkE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B146F1DF5A37764E8AB04AAC4108B5C5@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 63c7cef0-b01f-4e89-6bf1-08d7534d9c09
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2019 22:01:48.9516
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CK7iCz1tEqLEYAsnBlaDagDKwbk+uW0tyvwOBhE0LOH87ioiJ5vcmaCxvaIy8UQzeVF7c190b/1qmMeDCEKs3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3572
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-17_06:2019-10-17,2019-10-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=948
 lowpriorityscore=0 mlxscore=0 suspectscore=0 phishscore=0 clxscore=1011
 adultscore=0 spamscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910170193
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCu+7v09uIDEwLzE2LzE5LCA2OjI5IFBNLCAiQmVuamFtaW4gSGVycmVuc2NobWlkdCIgPGJl
bmhAa2VybmVsLmNyYXNoaW5nLm9yZz4gd3JvdGU6DQoNCiAgICBPbiBGcmksIDIwMTktMTAtMTEg
YXQgMTQ6MzAgLTA3MDAsIFZpamF5IEtoZW1rYSB3cm90ZToNCiAgICA+IEhXIGNoZWNrc3VtIGdl
bmVyYXRpb24gaXMgbm90IHdvcmtpbmcgZm9yIEFTVDI1MDAsIHNwZWNpYWxseSB3aXRoDQogICAg
PiBJUFY2DQogICAgPiBvdmVyIE5DU0kuIEFsbCBUQ1AgcGFja2V0cyB3aXRoIElQdjYgZ2V0IGRy
b3BwZWQuIEJ5IGRpc2FibGluZyB0aGlzDQogICAgPiBpdCB3b3JrcyBwZXJmZWN0bHkgZmluZSB3
aXRoIElQVjYuIEFzIGl0IHdvcmtzIGZvciBJUFY0IHNvIGVuYWJsZWQNCiAgICA+IGh3IGNoZWNr
c3VtIGJhY2sgZm9yIElQVjQuDQogICAgPiANCiAgICA+IFZlcmlmaWVkIHdpdGggSVBWNiBlbmFi
bGVkIGFuZCBjYW4gZG8gc3NoLg0KICAgIA0KICAgIFNvIHdoaWxlIHRoaXMgcHJvYmFibHkgd29y
a3MsIEkgZG9uJ3QgdGhpbmsgdGhpcyBpcyB0aGUgcmlnaHQNCiAgICBhcHByb2FjaCwgYXQgbGVh
c3QgYWNjb3JkaW5nIHRvIHRoZSBjb21tZW50cyBpbiBza2J1ZmYuaA0KDQpUaGlzIGlzIG5vdCBh
IG1hdHRlciBvZiB1bnN1cHBvcnRlZCBjc3VtLCBpdCBpcyBicm9rZW4gaHcgY3N1bS4gDQpUaGF0
J3Mgd2h5IHdlIGRpc2FibGUgaHcgY2hlY2tzdW0uIE15IGd1ZXNzIGlzIG9uY2Ugd2UgZGlzYWJs
ZQ0KSHcgY2hlY2tzdW0sIGl0IHdpbGwgdXNlIHN3IGNoZWNrc3VtLiBTbyBJIGFtIGp1c3QgZGlz
YWJsaW5nIGh3IA0KQ2hlY2tzdW0uDQogICAgDQogICAgVGhlIGRyaXZlciBzaG91bGQgaGF2ZSBo
YW5kbGVkIHVuc3VwcG9ydGVkIGNzdW0gdmlhIFNXIGZhbGxiYWNrDQogICAgYWxyZWFkeSBpbiBm
dGdtYWMxMDBfcHJlcF90eF9jc3VtKCkNCiAgICANCiAgICBDYW4geW91IGNoZWNrIHdoeSB0aGlz
IGRpZG4ndCB3b3JrIGZvciB5b3UgPw0KICAgIA0KICAgIENoZWVycywNCiAgICBCZW4uDQogICAg
DQogICAgPiBTaWduZWQtb2ZmLWJ5OiBWaWpheSBLaGVta2EgPHZpamF5a2hlbWthQGZiLmNvbT4N
CiAgICA+IC0tLQ0KICAgID4gQ2hhbmdlcyBzaW5jZSB2MToNCiAgICA+ICBFbmFibGVkIElQVjQg
aHcgY2hlY2tzdW0gZ2VuZXJhdGlvbiBhcyBpdCB3b3JrcyBmb3IgSVBWNC4NCiAgICA+IA0KICAg
ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ZhcmFkYXkvZnRnbWFjMTAwLmMgfCAxMyArKysrKysr
KysrKystDQogICAgPiAgMSBmaWxlIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKyksIDEgZGVsZXRp
b24oLSkNCiAgICA+IA0KICAgID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Zh
cmFkYXkvZnRnbWFjMTAwLmMNCiAgICA+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvZmFyYWRheS9m
dGdtYWMxMDAuYw0KICAgID4gaW5kZXggMDMwZmVkNjUzOTNlLi4wMjU1YTI4ZDI5NTggMTAwNjQ0
DQogICAgPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9mYXJhZGF5L2Z0Z21hYzEwMC5jDQog
ICAgPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9mYXJhZGF5L2Z0Z21hYzEwMC5jDQogICAg
PiBAQCAtMTg0Miw4ICsxODQyLDE5IEBAIHN0YXRpYyBpbnQgZnRnbWFjMTAwX3Byb2JlKHN0cnVj
dA0KICAgID4gcGxhdGZvcm1fZGV2aWNlICpwZGV2KQ0KICAgID4gIAkvKiBBU1QyNDAwICBkb2Vz
bid0IGhhdmUgd29ya2luZyBIVyBjaGVja3N1bSBnZW5lcmF0aW9uICovDQogICAgPiAgCWlmIChu
cCAmJiAob2ZfZGV2aWNlX2lzX2NvbXBhdGlibGUobnAsICJhc3BlZWQsYXN0MjQwMC1tYWMiKSkp
DQogICAgPiAgCQluZXRkZXYtPmh3X2ZlYXR1cmVzICY9IH5ORVRJRl9GX0hXX0NTVU07DQogICAg
PiArDQogICAgPiArCS8qIEFTVDI1MDAgZG9lc24ndCBoYXZlIHdvcmtpbmcgSFcgY2hlY2tzdW0g
Z2VuZXJhdGlvbiBmb3IgSVBWNg0KICAgID4gKwkgKiBidXQgaXQgd29ya3MgZm9yIElQVjQsIHNv
IGRpc2FibGluZyBodyBjaGVja3N1bSBhbmQgZW5hYmxpbmcNCiAgICA+ICsJICogaXQgZm9yIG9u
bHkgSVBWNC4NCiAgICA+ICsJICovDQogICAgPiArCWlmIChucCAmJiAob2ZfZGV2aWNlX2lzX2Nv
bXBhdGlibGUobnAsICJhc3BlZWQsYXN0MjUwMC1tYWMiKSkpDQogICAgPiB7DQogICAgPiArCQlu
ZXRkZXYtPmh3X2ZlYXR1cmVzICY9IH5ORVRJRl9GX0hXX0NTVU07DQogICAgPiArCQluZXRkZXYt
Pmh3X2ZlYXR1cmVzIHw9IE5FVElGX0ZfSVBfQ1NVTTsNCiAgICA+ICsJfQ0KICAgID4gKw0KICAg
ID4gIAlpZiAobnAgJiYgb2ZfZ2V0X3Byb3BlcnR5KG5wLCAibm8taHctY2hlY2tzdW0iLCBOVUxM
KSkNCiAgICA+IC0JCW5ldGRldi0+aHdfZmVhdHVyZXMgJj0gfihORVRJRl9GX0hXX0NTVU0gfA0K
ICAgID4gTkVUSUZfRl9SWENTVU0pOw0KICAgID4gKwkJbmV0ZGV2LT5od19mZWF0dXJlcyAmPSB+
KE5FVElGX0ZfSFdfQ1NVTSB8DQogICAgPiBORVRJRl9GX1JYQ1NVTQ0KICAgID4gKwkJCQkJIHwg
TkVUSUZfRl9JUF9DU1VNKTsNCiAgICA+ICAJbmV0ZGV2LT5mZWF0dXJlcyB8PSBuZXRkZXYtPmh3
X2ZlYXR1cmVzOw0KICAgID4gIA0KICAgID4gIAkvKiByZWdpc3RlciBuZXR3b3JrIGRldmljZSAq
Lw0KICAgIA0KICAgIA0KDQo=
