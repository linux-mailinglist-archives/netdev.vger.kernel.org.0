Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9157AE06F
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 23:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388550AbfIIV5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 17:57:17 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:13384 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727008AbfIIV5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 17:57:16 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x89LlbDR012907;
        Mon, 9 Sep 2019 14:57:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=H+BiD1XGGAJVA2vsJeOnVPcvlKujo+r9T29NtaZWgtk=;
 b=NkBIcDJJZgrXooVDtc2ujj7/yAAP6o+iuCmZ+5bQK5Pop7r2g8BKe2rn+519cbqL/JGl
 uhXELA1Nbbpae55MnIPnDRKLUa5eqn0xkFkHUIOhosmpLDc8PAykpl/jWqRI0J36K8R1
 IHkV+Qk2fKZ8n4W4MnXXOF88QIHZXGPQl5M= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2uv87nhjy1-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 09 Sep 2019 14:57:01 -0700
Received: from ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 9 Sep 2019 14:57:00 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 9 Sep 2019 14:57:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GUHvp38i6lVCiwdtQTh5JVnouIOtMmulrJT7zU8VDnsboHl3D5TP73rGwhKnak47g3YFd8vOI54LEy1NkVfoKwBFbMpYZom3lOaZ2DpSW6tbaICQNURopAeboxki1HPyxwBoSYv7J3MhSo/EhQHxcKP0G8pHMxZ+LtyCzBSm9fvvjs/XyiBDUBKlm9hdgwDsyGLeatym2IbPO+J6RrEWvBYOKngpkl0c5WNpCb/JvO2ejpPswf5q7o/9KHLdDKqXF3cxRmq0wtgWrXQEasMHlC8t518++odQD95bFGNDvhYfydEUolJJkrkQq3ju8Bun4R1VkuWSS6j+XIyQFeItpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H+BiD1XGGAJVA2vsJeOnVPcvlKujo+r9T29NtaZWgtk=;
 b=CUXDxjvfPrOwZGxe+zh0k57N3MJ+CYy5VACYT7NHYDEX7wk0pQBjU9LKBPj1m5C69RAr4ogLTUigUa8+EFxduWQC0lcgkBIz+DlUUi7onV5F7spQHwBu/M7XOIn8NwUKkruRUqZcc5R5sh1wFe46m5SSRtIP94a2/v8ZjJMyx46WR4+uCHUwWg/a9INv1isQNfTPmkjOihzds6PNXZ48203/GTHYcEu3v62DptktqCV8hslMGwc+tO5DwzuofZMeXfOH/thIcY7uOL8zXkPMqD2XlLDPprlghD+77Z1xhjeF4sFG1LBr+h/rvqn+ScF5iwXw5imcyyurHIxTiWKVzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H+BiD1XGGAJVA2vsJeOnVPcvlKujo+r9T29NtaZWgtk=;
 b=PFPz2940WHOaEZBIHPcrGlZmckmxRBYvfmzDd7r4cPFGqpxT5e9ESfcfPphApeYM5zMP1yUzrjy00nLrhQ8j2wa7cRXVwbLjnA9ahwHF/k7g+P3FcPSUpBhupvniOQmgebhNn7bp97aNIZ0kVSGT4RofAJpMVa8BBcgQBLxS9Oc=
Received: from MWHPR15MB1216.namprd15.prod.outlook.com (10.175.2.17) by
 MWHPR15MB1183.namprd15.prod.outlook.com (10.175.2.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Mon, 9 Sep 2019 21:56:59 +0000
Received: from MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::2980:5c7f:8dde:174a]) by MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::2980:5c7f:8dde:174a%9]) with mapi id 15.20.2241.018; Mon, 9 Sep 2019
 21:56:59 +0000
From:   Tao Ren <taoren@fb.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Justin Chen <justinpopo6@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>
Subject: Re: [PATCH net-next v8 2/3] net: phy: add support for clause 37
 auto-negotiation
Thread-Topic: [PATCH net-next v8 2/3] net: phy: add support for clause 37
 auto-negotiation
Thread-Index: AQHVZ1Bi3JE3p3zeEkCydFApWQwsCKcj5F6A
Date:   Mon, 9 Sep 2019 21:56:59 +0000
Message-ID: <2f5a48e1-d2ae-cf82-db6d-6514067a8604@fb.com>
References: <20190909204906.2191290-1-taoren@fb.com>
In-Reply-To: <20190909204906.2191290-1-taoren@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR2201CA0018.namprd22.prod.outlook.com
 (2603:10b6:301:28::31) To MWHPR15MB1216.namprd15.prod.outlook.com
 (2603:10b6:320:22::17)
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:24c9]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 21cd5a17-1a30-4cc9-f40f-08d73570a35f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1183;
x-ms-traffictypediagnostic: MWHPR15MB1183:
x-microsoft-antispam-prvs: <MWHPR15MB1183AD23476E2AC46DCACCE7B2B70@MWHPR15MB1183.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01559F388D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(376002)(346002)(366004)(396003)(136003)(189003)(199004)(36756003)(2906002)(14444005)(229853002)(256004)(6436002)(99286004)(14454004)(58126008)(110136005)(52116002)(76176011)(31686004)(6486002)(6246003)(31696002)(2201001)(6512007)(86362001)(53936002)(46003)(186003)(81166006)(65956001)(81156014)(476003)(71190400001)(71200400001)(8936002)(486006)(2616005)(6116002)(478600001)(446003)(11346002)(2501003)(102836004)(53546011)(305945005)(66946007)(7416002)(6506007)(386003)(316002)(5660300002)(8676002)(7736002)(65806001)(66446008)(64756008)(66556008)(66476007)(25786009)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1183;H:MWHPR15MB1216.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: tGH25fim7jDQ7VRsTS+vtMn5QQy4BLucaHbmxkQLKb726nrJkkfeDPXGo9l0rSjhPt3paUzXtJrKtwqPcl426+UJp0HuokAG2V9fAU3Jb4LQ02+y4WDqfUhiHc39cIyUixkj/lltXpCuvEaZJun71C2veHxiOHuc5p9op/f+pvyazFBWTJLbPJrAM0ZiLMLckjm3DnaexWX6yB3Ybl44PQDNCIRp1JvPNav+QbTQEGo/2S+fiAedxvLvH4ZgkT1SlojyrJjP3AQmly+JsBAkoAb9Nm+gv1TYbecT0T9s1krbck+BdDKN70lt7GoToY8XtryyXax94fzkNbU/uhNS9J1ToWp590pveWX1Vab+UQHTnJ6FWGK5Gu7kfje1EMdBNnfJS/t9GvzOYpVWlFIofZngRj9ClYIDptv7y8BSuAM=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <D159649A44AAD54BA204ACB2D1341A49@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 21cd5a17-1a30-4cc9-f40f-08d73570a35f
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2019 21:56:59.1407
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ECFOFcdhvgxGhjh4ZAf7PdAPWP5U/wh4MiJZ2q1UIY2AThkO69GWR6Jb351WoD9C
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1183
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-09_08:2019-09-09,2019-09-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 clxscore=1015 phishscore=0 adultscore=0 suspectscore=0 priorityscore=1501
 bulkscore=0 lowpriorityscore=0 impostorscore=0 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909090211
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW5kcmV3IC8gRmxvcmlhbiwNCg0KT24gOS85LzE5IDE6NDkgUE0sIFRhbyBSZW4gd3JvdGU6
DQo+IEZyb206IEhlaW5lciBLYWxsd2VpdCA8aGthbGx3ZWl0MUBnbWFpbC5jb20+DQo+IA0KPiBU
aGlzIHBhdGNoIGFkZHMgc3VwcG9ydCBmb3IgY2xhdXNlIDM3IDEwMDBCYXNlLVggYXV0by1uZWdv
dGlhdGlvbi4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEhlaW5lciBLYWxsd2VpdCA8aGthbGx3ZWl0
MUBnbWFpbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFRhbyBSZW4gPHRhb3JlbkBmYi5jb20+DQo+
IFRlc3RlZC1ieTogUmVuw6kgdmFuIERvcnN0IDxvcGVuc291cmNlQHZkb3JzdC5jb20+DQoNCkp1
c3Qgd2FudCB0byBjaGVjayBpZiBJIG1pc3NlZCB5b3VyIGNvbW1lbnRzIChJIG5vdGljZWQgc29t
ZSB3aXJlZCBwcm9ibGVtcyBvbiBteSBlbWFpbCBjbGllbnQpPw0KDQpJZiB5ZXMgKHNvcnJ5IEkg
bWlzc2VkIHNvbWV0aGluZyksIGNvdWxkIHlvdSBwbGVhc2UgcmUtc2VuZCB5b3VyIGNvbW1lbnRz
PyBBbmQgSSB3aWxsIGFkZHJlc3MgdGhlbSBhcyBzb29uIGFzIHBvc3NpYmxlLg0KDQoNClRoYW5r
cywNCg0KVGFvDQoNCj4gLS0tDQo+ICBDaGFuZ2VzIGluIHY4Og0KPiAgIC0gUmViYXNlZCB0aGUg
cGF0Y2ggb24gdG9wIG9mIG5ldC1uZXh0IEhFQUQuDQo+ICBDaGFuZ2VzIGluIHY3Og0KPiAgIC0g
VXBkYXRlICJpZiAoQVVUT05FR19FTkFCTEUgIT0gcGh5ZGV2LT5hdXRvbmVnKSIgdG8NCj4gICAg
ICJpZiAocGh5ZGV2LT5hdXRvbmVnICE9IEFVVE9ORUdfRU5BQkxFKSIgc28gY2hlY2twYXRjaC5w
bCBpcyBoYXBweS4NCj4gIENoYW5nZXMgaW4gdjY6DQo+ICAgLSBhZGQgIlNpZ25lZC1vZmYtYnk6
IFRhbyBSZW4gPHRhb3JlbkBmYi5jb20+Ig0KPiAgQ2hhbmdlcyBpbiB2MS12NToNCj4gICAtIG5v
dGhpbmcgY2hhbmdlZC4gSXQncyBnaXZlbiB2NSBqdXN0IHRvIGFsaWduIHdpdGggdGhlIHZlcnNp
b24gb2YNCj4gICAgIHBhdGNoIHNlcmllcy4NCj4gDQo+ICBkcml2ZXJzL25ldC9waHkvcGh5X2Rl
dmljZS5jIHwgMTM5ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ICBpbmNs
dWRlL2xpbnV4L3BoeS5oICAgICAgICAgIHwgICA0ICsNCj4gIDIgZmlsZXMgY2hhbmdlZCwgMTQz
IGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9waHkvcGh5X2Rl
dmljZS5jIGIvZHJpdmVycy9uZXQvcGh5L3BoeV9kZXZpY2UuYw0KPiBpbmRleCA4OTMzZjA3ZDM5
ZTkuLmRkMDVmNzUwYmIzZiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvcGh5L3BoeV9kZXZp
Y2UuYw0KPiArKysgYi9kcml2ZXJzL25ldC9waHkvcGh5X2RldmljZS5jDQo+IEBAIC0xNjA3LDYg
KzE2MDcsNDAgQEAgc3RhdGljIGludCBnZW5waHlfY29uZmlnX2FkdmVydChzdHJ1Y3QgcGh5X2Rl
dmljZSAqcGh5ZGV2KQ0KPiAgCXJldHVybiBjaGFuZ2VkOw0KPiAgfQ0KPiAgDQo+ICsvKioNCj4g
KyAqIGdlbnBoeV9jMzdfY29uZmlnX2FkdmVydCAtIHNhbml0aXplIGFuZCBhZHZlcnRpc2UgYXV0
by1uZWdvdGlhdGlvbiBwYXJhbWV0ZXJzDQo+ICsgKiBAcGh5ZGV2OiB0YXJnZXQgcGh5X2Rldmlj
ZSBzdHJ1Y3QNCj4gKyAqDQo+ICsgKiBEZXNjcmlwdGlvbjogV3JpdGVzIE1JSV9BRFZFUlRJU0Ug
d2l0aCB0aGUgYXBwcm9wcmlhdGUgdmFsdWVzLA0KPiArICogICBhZnRlciBzYW5pdGl6aW5nIHRo
ZSB2YWx1ZXMgdG8gbWFrZSBzdXJlIHdlIG9ubHkgYWR2ZXJ0aXNlDQo+ICsgKiAgIHdoYXQgaXMg
c3VwcG9ydGVkLiAgUmV0dXJucyA8IDAgb24gZXJyb3IsIDAgaWYgdGhlIFBIWSdzIGFkdmVydGlz
ZW1lbnQNCj4gKyAqICAgaGFzbid0IGNoYW5nZWQsIGFuZCA+IDAgaWYgaXQgaGFzIGNoYW5nZWQu
IFRoaXMgZnVuY3Rpb24gaXMgaW50ZW5kZWQNCj4gKyAqICAgZm9yIENsYXVzZSAzNyAxMDAwQmFz
ZS1YIG1vZGUuDQo+ICsgKi8NCj4gK3N0YXRpYyBpbnQgZ2VucGh5X2MzN19jb25maWdfYWR2ZXJ0
KHN0cnVjdCBwaHlfZGV2aWNlICpwaHlkZXYpDQo+ICt7DQo+ICsJdTE2IGFkdiA9IDA7DQo+ICsN
Cj4gKwkvKiBPbmx5IGFsbG93IGFkdmVydGlzaW5nIHdoYXQgdGhpcyBQSFkgc3VwcG9ydHMgKi8N
Cj4gKwlsaW5rbW9kZV9hbmQocGh5ZGV2LT5hZHZlcnRpc2luZywgcGh5ZGV2LT5hZHZlcnRpc2lu
ZywNCj4gKwkJICAgICBwaHlkZXYtPnN1cHBvcnRlZCk7DQo+ICsNCj4gKwlpZiAobGlua21vZGVf
dGVzdF9iaXQoRVRIVE9PTF9MSU5LX01PREVfMTAwMGJhc2VYX0Z1bGxfQklULA0KPiArCQkJICAg
ICAgcGh5ZGV2LT5hZHZlcnRpc2luZykpDQo+ICsJCWFkdiB8PSBBRFZFUlRJU0VfMTAwMFhGVUxM
Ow0KPiArCWlmIChsaW5rbW9kZV90ZXN0X2JpdChFVEhUT09MX0xJTktfTU9ERV9QYXVzZV9CSVQs
DQo+ICsJCQkgICAgICBwaHlkZXYtPmFkdmVydGlzaW5nKSkNCj4gKwkJYWR2IHw9IEFEVkVSVElT
RV8xMDAwWFBBVVNFOw0KPiArCWlmIChsaW5rbW9kZV90ZXN0X2JpdChFVEhUT09MX0xJTktfTU9E
RV9Bc3ltX1BhdXNlX0JJVCwNCj4gKwkJCSAgICAgIHBoeWRldi0+YWR2ZXJ0aXNpbmcpKQ0KPiAr
CQlhZHYgfD0gQURWRVJUSVNFXzEwMDBYUFNFX0FTWU07DQo+ICsNCj4gKwlyZXR1cm4gcGh5X21v
ZGlmeV9jaGFuZ2VkKHBoeWRldiwgTUlJX0FEVkVSVElTRSwNCj4gKwkJCQkgIEFEVkVSVElTRV8x
MDAwWEZVTEwgfCBBRFZFUlRJU0VfMTAwMFhQQVVTRSB8DQo+ICsJCQkJICBBRFZFUlRJU0VfMTAw
MFhIQUxGIHwgQURWRVJUSVNFXzEwMDBYUFNFX0FTWU0sDQo+ICsJCQkJICBhZHYpOw0KPiArfQ0K
PiArDQo+ICAvKioNCj4gICAqIGdlbnBoeV9jb25maWdfZWVlX2FkdmVydCAtIGRpc2FibGUgdW53
YW50ZWQgZWVlIG1vZGUgYWR2ZXJ0aXNlbWVudA0KPiAgICogQHBoeWRldjogdGFyZ2V0IHBoeV9k
ZXZpY2Ugc3RydWN0DQo+IEBAIC0xNzE1LDYgKzE3NDksNTQgQEAgaW50IF9fZ2VucGh5X2NvbmZp
Z19hbmVnKHN0cnVjdCBwaHlfZGV2aWNlICpwaHlkZXYsIGJvb2wgY2hhbmdlZCkNCj4gIH0NCj4g
IEVYUE9SVF9TWU1CT0woX19nZW5waHlfY29uZmlnX2FuZWcpOw0KPiAgDQo+ICsvKioNCj4gKyAq
IGdlbnBoeV9jMzdfY29uZmlnX2FuZWcgLSByZXN0YXJ0IGF1dG8tbmVnb3RpYXRpb24gb3Igd3Jp
dGUgQk1DUg0KPiArICogQHBoeWRldjogdGFyZ2V0IHBoeV9kZXZpY2Ugc3RydWN0DQo+ICsgKg0K
PiArICogRGVzY3JpcHRpb246IElmIGF1dG8tbmVnb3RpYXRpb24gaXMgZW5hYmxlZCwgd2UgY29u
ZmlndXJlIHRoZQ0KPiArICogICBhZHZlcnRpc2luZywgYW5kIHRoZW4gcmVzdGFydCBhdXRvLW5l
Z290aWF0aW9uLiAgSWYgaXQgaXMgbm90DQo+ICsgKiAgIGVuYWJsZWQsIHRoZW4gd2Ugd3JpdGUg
dGhlIEJNQ1IuIFRoaXMgZnVuY3Rpb24gaXMgaW50ZW5kZWQNCj4gKyAqICAgZm9yIHVzZSB3aXRo
IENsYXVzZSAzNyAxMDAwQmFzZS1YIG1vZGUuDQo+ICsgKi8NCj4gK2ludCBnZW5waHlfYzM3X2Nv
bmZpZ19hbmVnKHN0cnVjdCBwaHlfZGV2aWNlICpwaHlkZXYpDQo+ICt7DQo+ICsJaW50IGVyciwg
Y2hhbmdlZDsNCj4gKw0KPiArCWlmIChwaHlkZXYtPmF1dG9uZWcgIT0gQVVUT05FR19FTkFCTEUp
DQo+ICsJCXJldHVybiBnZW5waHlfc2V0dXBfZm9yY2VkKHBoeWRldik7DQo+ICsNCj4gKwllcnIg
PSBwaHlfbW9kaWZ5KHBoeWRldiwgTUlJX0JNQ1IsIEJNQ1JfU1BFRUQxMDAwIHwgQk1DUl9TUEVF
RDEwMCwNCj4gKwkJCSBCTUNSX1NQRUVEMTAwMCk7DQo+ICsJaWYgKGVycikNCj4gKwkJcmV0dXJu
IGVycjsNCj4gKw0KPiArCWNoYW5nZWQgPSBnZW5waHlfYzM3X2NvbmZpZ19hZHZlcnQocGh5ZGV2
KTsNCj4gKwlpZiAoY2hhbmdlZCA8IDApIC8qIGVycm9yICovDQo+ICsJCXJldHVybiBjaGFuZ2Vk
Ow0KPiArDQo+ICsJaWYgKCFjaGFuZ2VkKSB7DQo+ICsJCS8qIEFkdmVydGlzZW1lbnQgaGFzbid0
IGNoYW5nZWQsIGJ1dCBtYXliZSBhbmVnIHdhcyBuZXZlciBvbiB0bw0KPiArCQkgKiBiZWdpbiB3
aXRoPyAgT3IgbWF5YmUgcGh5IHdhcyBpc29sYXRlZD8NCj4gKwkJICovDQo+ICsJCWludCBjdGwg
PSBwaHlfcmVhZChwaHlkZXYsIE1JSV9CTUNSKTsNCj4gKw0KPiArCQlpZiAoY3RsIDwgMCkNCj4g
KwkJCXJldHVybiBjdGw7DQo+ICsNCj4gKwkJaWYgKCEoY3RsICYgQk1DUl9BTkVOQUJMRSkgfHwg
KGN0bCAmIEJNQ1JfSVNPTEFURSkpDQo+ICsJCQljaGFuZ2VkID0gMTsgLyogZG8gcmVzdGFydCBh
bmVnICovDQo+ICsJfQ0KPiArDQo+ICsJLyogT25seSByZXN0YXJ0IGFuZWcgaWYgd2UgYXJlIGFk
dmVydGlzaW5nIHNvbWV0aGluZyBkaWZmZXJlbnQNCj4gKwkgKiB0aGFuIHdlIHdlcmUgYmVmb3Jl
Lg0KPiArCSAqLw0KPiArCWlmIChjaGFuZ2VkID4gMCkNCj4gKwkJcmV0dXJuIGdlbnBoeV9yZXN0
YXJ0X2FuZWcocGh5ZGV2KTsNCj4gKw0KPiArCXJldHVybiAwOw0KPiArfQ0KPiArRVhQT1JUX1NZ
TUJPTChnZW5waHlfYzM3X2NvbmZpZ19hbmVnKTsNCj4gKw0KPiAgLyoqDQo+ICAgKiBnZW5waHlf
YW5lZ19kb25lIC0gcmV0dXJuIGF1dG8tbmVnb3RpYXRpb24gc3RhdHVzDQo+ICAgKiBAcGh5ZGV2
OiB0YXJnZXQgcGh5X2RldmljZSBzdHJ1Y3QNCj4gQEAgLTE4NjIsNiArMTk0NCw2MyBAQCBpbnQg
Z2VucGh5X3JlYWRfc3RhdHVzKHN0cnVjdCBwaHlfZGV2aWNlICpwaHlkZXYpDQo+ICB9DQo+ICBF
WFBPUlRfU1lNQk9MKGdlbnBoeV9yZWFkX3N0YXR1cyk7DQo+ICANCj4gKy8qKg0KPiArICogZ2Vu
cGh5X2MzN19yZWFkX3N0YXR1cyAtIGNoZWNrIHRoZSBsaW5rIHN0YXR1cyBhbmQgdXBkYXRlIGN1
cnJlbnQgbGluayBzdGF0ZQ0KPiArICogQHBoeWRldjogdGFyZ2V0IHBoeV9kZXZpY2Ugc3RydWN0
DQo+ICsgKg0KPiArICogRGVzY3JpcHRpb246IENoZWNrIHRoZSBsaW5rLCB0aGVuIGZpZ3VyZSBv
dXQgdGhlIGN1cnJlbnQgc3RhdGUNCj4gKyAqICAgYnkgY29tcGFyaW5nIHdoYXQgd2UgYWR2ZXJ0
aXNlIHdpdGggd2hhdCB0aGUgbGluayBwYXJ0bmVyDQo+ICsgKiAgIGFkdmVydGlzZXMuIFRoaXMg
ZnVuY3Rpb24gaXMgZm9yIENsYXVzZSAzNyAxMDAwQmFzZS1YIG1vZGUuDQo+ICsgKi8NCj4gK2lu
dCBnZW5waHlfYzM3X3JlYWRfc3RhdHVzKHN0cnVjdCBwaHlfZGV2aWNlICpwaHlkZXYpDQo+ICt7
DQo+ICsJaW50IGxwYSwgZXJyLCBvbGRfbGluayA9IHBoeWRldi0+bGluazsNCj4gKw0KPiArCS8q
IFVwZGF0ZSB0aGUgbGluaywgYnV0IHJldHVybiBpZiB0aGVyZSB3YXMgYW4gZXJyb3IgKi8NCj4g
KwllcnIgPSBnZW5waHlfdXBkYXRlX2xpbmsocGh5ZGV2KTsNCj4gKwlpZiAoZXJyKQ0KPiArCQly
ZXR1cm4gZXJyOw0KPiArDQo+ICsJLyogd2h5IGJvdGhlciB0aGUgUEhZIGlmIG5vdGhpbmcgY2Fu
IGhhdmUgY2hhbmdlZCAqLw0KPiArCWlmIChwaHlkZXYtPmF1dG9uZWcgPT0gQVVUT05FR19FTkFC
TEUgJiYgb2xkX2xpbmsgJiYgcGh5ZGV2LT5saW5rKQ0KPiArCQlyZXR1cm4gMDsNCj4gKw0KPiAr
CXBoeWRldi0+ZHVwbGV4ID0gRFVQTEVYX1VOS05PV047DQo+ICsJcGh5ZGV2LT5wYXVzZSA9IDA7
DQo+ICsJcGh5ZGV2LT5hc3ltX3BhdXNlID0gMDsNCj4gKw0KPiArCWlmIChwaHlkZXYtPmF1dG9u
ZWcgPT0gQVVUT05FR19FTkFCTEUgJiYgcGh5ZGV2LT5hdXRvbmVnX2NvbXBsZXRlKSB7DQo+ICsJ
CWxwYSA9IHBoeV9yZWFkKHBoeWRldiwgTUlJX0xQQSk7DQo+ICsJCWlmIChscGEgPCAwKQ0KPiAr
CQkJcmV0dXJuIGxwYTsNCj4gKw0KPiArCQlsaW5rbW9kZV9tb2RfYml0KEVUSFRPT0xfTElOS19N
T0RFX0F1dG9uZWdfQklULA0KPiArCQkJCSBwaHlkZXYtPmxwX2FkdmVydGlzaW5nLCBscGEgJiBM
UEFfTFBBQ0spOw0KPiArCQlsaW5rbW9kZV9tb2RfYml0KEVUSFRPT0xfTElOS19NT0RFXzEwMDBi
YXNlWF9GdWxsX0JJVCwNCj4gKwkJCQkgcGh5ZGV2LT5scF9hZHZlcnRpc2luZywgbHBhICYgTFBB
XzEwMDBYRlVMTCk7DQo+ICsJCWxpbmttb2RlX21vZF9iaXQoRVRIVE9PTF9MSU5LX01PREVfUGF1
c2VfQklULA0KPiArCQkJCSBwaHlkZXYtPmxwX2FkdmVydGlzaW5nLCBscGEgJiBMUEFfMTAwMFhQ
QVVTRSk7DQo+ICsJCWxpbmttb2RlX21vZF9iaXQoRVRIVE9PTF9MSU5LX01PREVfQXN5bV9QYXVz
ZV9CSVQsDQo+ICsJCQkJIHBoeWRldi0+bHBfYWR2ZXJ0aXNpbmcsDQo+ICsJCQkJIGxwYSAmIExQ
QV8xMDAwWFBBVVNFX0FTWU0pOw0KPiArDQo+ICsJCXBoeV9yZXNvbHZlX2FuZWdfbGlua21vZGUo
cGh5ZGV2KTsNCj4gKwl9IGVsc2UgaWYgKHBoeWRldi0+YXV0b25lZyA9PSBBVVRPTkVHX0RJU0FC
TEUpIHsNCj4gKwkJaW50IGJtY3IgPSBwaHlfcmVhZChwaHlkZXYsIE1JSV9CTUNSKTsNCj4gKw0K
PiArCQlpZiAoYm1jciA8IDApDQo+ICsJCQlyZXR1cm4gYm1jcjsNCj4gKw0KPiArCQlpZiAoYm1j
ciAmIEJNQ1JfRlVMTERQTFgpDQo+ICsJCQlwaHlkZXYtPmR1cGxleCA9IERVUExFWF9GVUxMOw0K
PiArCQllbHNlDQo+ICsJCQlwaHlkZXYtPmR1cGxleCA9IERVUExFWF9IQUxGOw0KPiArCX0NCj4g
Kw0KPiArCXJldHVybiAwOw0KPiArfQ0KPiArRVhQT1JUX1NZTUJPTChnZW5waHlfYzM3X3JlYWRf
c3RhdHVzKTsNCj4gKw0KPiAgLyoqDQo+ICAgKiBnZW5waHlfc29mdF9yZXNldCAtIHNvZnR3YXJl
IHJlc2V0IHRoZSBQSFkgdmlhIEJNQ1JfUkVTRVQgYml0DQo+ICAgKiBAcGh5ZGV2OiB0YXJnZXQg
cGh5X2RldmljZSBzdHJ1Y3QNCj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvcGh5LmggYi9p
bmNsdWRlL2xpbnV4L3BoeS5oDQo+IGluZGV4IGE3ZWNiZTBlNTVhYS4uY2Q5Nzg2Y2NmNjMwIDEw
MDY0NA0KPiAtLS0gYS9pbmNsdWRlL2xpbnV4L3BoeS5oDQo+ICsrKyBiL2luY2x1ZGUvbGludXgv
cGh5LmgNCj4gQEAgLTExMDQsNiArMTEwNCwxMCBAQCBpbnQgZ2VucGh5X3JlYWRfbW1kX3Vuc3Vw
cG9ydGVkKHN0cnVjdCBwaHlfZGV2aWNlICpwaGRldiwgaW50IGRldmFkLA0KPiAgaW50IGdlbnBo
eV93cml0ZV9tbWRfdW5zdXBwb3J0ZWQoc3RydWN0IHBoeV9kZXZpY2UgKnBoZGV2LCBpbnQgZGV2
bnVtLA0KPiAgCQkJCSB1MTYgcmVnbnVtLCB1MTYgdmFsKTsNCj4gIA0KPiArLyogQ2xhdXNlIDM3
ICovDQo+ICtpbnQgZ2VucGh5X2MzN19jb25maWdfYW5lZyhzdHJ1Y3QgcGh5X2RldmljZSAqcGh5
ZGV2KTsNCj4gK2ludCBnZW5waHlfYzM3X3JlYWRfc3RhdHVzKHN0cnVjdCBwaHlfZGV2aWNlICpw
aHlkZXYpOw0KPiArDQo+ICAvKiBDbGF1c2UgNDUgUEhZICovDQo+ICBpbnQgZ2VucGh5X2M0NV9y
ZXN0YXJ0X2FuZWcoc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRldik7DQo+ICBpbnQgZ2VucGh5X2M0
NV9jaGVja19hbmRfcmVzdGFydF9hbmVnKHN0cnVjdCBwaHlfZGV2aWNlICpwaHlkZXYsIGJvb2wg
cmVzdGFydCk7DQo+IA0K
