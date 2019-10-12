Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC0C4D4BE4
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 03:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728221AbfJLBjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 21:39:31 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27376 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726829AbfJLBjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 21:39:31 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9C1ZQS9010205;
        Fri, 11 Oct 2019 18:39:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=cKFrQVUS0LZSopp/WBnKUIScfRQ0CCNgJCcGybNI/U0=;
 b=EWO1AfP3I9C1vZALV70dtpb4iNHCq91+x/qjKy3N4+Hvy2BqfJBut0YVU33fxMBGbyRa
 q7nLGyWfns7NTNeJzF3E8+Vl/eyrjLcbaq/PqpDw1cyW4Xc2rkKpKO19HaO85Bb3pO1l
 2XDWlWH0R96SZkq2WQQEcnh1cr5gF8QdhZM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vjwqkt2fx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 11 Oct 2019 18:39:15 -0700
Received: from ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) by
 ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 11 Oct 2019 18:39:14 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 11 Oct 2019 18:39:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NECCRyCMkhj26n0bJHRJzVbe1REkTdAVrzDpcbsfqBPZ9+vxl1BnLI8GRopKUixHiY9NR3VyfNzD78QdAGZhd5zEDnKW/TV0f33hKmZhOg9JqNwHv4KosuDKEfATa9ivoFhXpOVN8fL22Wgh17CbUinDCHRfr4X+E5XjXPMGe1cXJxF2ua+oD4uCcPzrCW8/YkEUXqsh/tGAcpmpcpY48sDz1YFj/EEcX7l3QyqlytVY3GXn48PkoPaahrGOY6oYArO/+EnjJQ3nI8hpWvhF9mi4aWA56DSW2fPgQKuyb/GSeFkyrhMaPzJsk8T9Jm22YVbzgrEF2bbVVVN6Ry0YDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cKFrQVUS0LZSopp/WBnKUIScfRQ0CCNgJCcGybNI/U0=;
 b=XTe60uagFxEyTsYg74zkYay9Hg4XWIENBwM31W2VcrS1bYMkkXPDp4KJHhCUgK6BsLx0DLUcEGLGgVz89/RPVkL9//W33NwkxK3VCnneFMqwA2Oktqdr9TULvPp7AMZp8ECFwaROB8ceVdmpgyfjGhSqiO1bn28zRdKdMUQsFhMcsaCamFEM4bJjrCM4Oc2HTi7EgLtaBbq1RJhBhieRxcyZGKrFeRU5NV9HY2cB0HwqQtfsf+tR2IRIj9plOk5AvsWyUXPXe5LyijbnU8jm1Pxo3qJh69HyrDgWWtGuG28mCWW75A7nyjVR+IGTNcCkRVnPVQjUWZu8/w3x5bL0HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cKFrQVUS0LZSopp/WBnKUIScfRQ0CCNgJCcGybNI/U0=;
 b=LFVHCPtabo6fF/peELYc9f890hxZROnQpVlljAGYXDMFiDj4KsD97dbN3npNE5IlkAouLQahhLipwwc/hOFqliNXjjXYBDPm6Ehwq2d/PAG76QiklkrEFbCNuSoqmDBEwGpsYgJPt0ajZPYu+mK0LxU0e5yMaf9bGWTFBACTlsA=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB2998.namprd15.prod.outlook.com (20.178.238.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.18; Sat, 12 Oct 2019 01:39:13 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0%5]) with mapi id 15.20.2347.021; Sat, 12 Oct 2019
 01:39:13 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 10/12] bpf: check types of arguments passed
 into helpers
Thread-Topic: [PATCH v2 bpf-next 10/12] bpf: check types of arguments passed
 into helpers
Thread-Index: AQHVfyF24dbHPLfixEq7aHRRNCmWz6dVzrEAgABuuQA=
Date:   Sat, 12 Oct 2019 01:39:13 +0000
Message-ID: <ba51c8c3-94fc-413a-0935-aaa307127666@fb.com>
References: <20191010041503.2526303-1-ast@kernel.org>
 <20191010041503.2526303-11-ast@kernel.org>
 <CAEf4BzbmE_ADjjhu-+mLkQN_5HD6Azhrb-VuprAaoqxP1bb3OQ@mail.gmail.com>
In-Reply-To: <CAEf4BzbmE_ADjjhu-+mLkQN_5HD6Azhrb-VuprAaoqxP1bb3OQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR05CA0074.namprd05.prod.outlook.com
 (2603:10b6:102:2::42) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::3d03]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5ca60103-b243-4817-0339-08d74eb4fc39
x-ms-traffictypediagnostic: BYAPR15MB2998:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2998A1416D8EA394B1DC7027D7960@BYAPR15MB2998.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:651;
x-forefront-prvs: 0188D66E61
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(39860400002)(366004)(346002)(376002)(189003)(199004)(64756008)(66476007)(66446008)(76176011)(99286004)(66556008)(8676002)(5660300002)(478600001)(6116002)(305945005)(7736002)(81156014)(81166006)(8936002)(6246003)(4326008)(71200400001)(66946007)(186003)(71190400001)(6512007)(52116002)(102836004)(53546011)(6506007)(386003)(14444005)(256004)(2906002)(31686004)(2616005)(86362001)(54906003)(110136005)(25786009)(31696002)(46003)(6486002)(36756003)(14454004)(6436002)(229853002)(476003)(486006)(316002)(446003)(11346002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2998;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RfQB9BN1zopKzEvlUR3lFncPZZqdCoGyHA//SHQ4FrpDdI6X6FzYPMQQyyXqyDWFjtahUnU13iAGb33sBt84HQum4ExH7GFJt/FYDwKIyf5QgXuszvJ7zltaGJgL9pjR11OY/PE7cIwf8Bsq4ToL096q9LroWDwkwDII/5I+3XnL9e8qD2c8K5Tjm7JEYQIQhDQJSQo0+fBpWmf21GF9sNdZLvaj6ju7xE4vemlOS14SVFkU31o9rJRRBaxncAcbFY3PDZ/1Jz/xW7GK5HV29Hc143p7lmnbxtUVj4jBKOk0iTjLIKQ/07q9GoAWG7B5YzBWFFau2IRwN7TSBLG9psaREtRqurBx0aNVpjKcxXDQUWqjjXjrg2mPYuzzn9M67umX4wb1tPpr9AMvWSeKvOecG4mXlCAFP/+AtDA0Ud4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F63F7D8FDA74384B8DAA83EAED30EAB5@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ca60103-b243-4817-0339-08d74eb4fc39
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2019 01:39:13.0788
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QumJrM6sLDjVss6Ylbdwn8xh+f7ZDbAibE2tNDYotjwUuSlsPbhR8LQ5FxQCN06w
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2998
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-11_12:2019-10-10,2019-10-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 clxscore=1015 priorityscore=1501 mlxscore=0 phishscore=0 spamscore=0
 bulkscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910120007
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvMTEvMTkgMTI6MDIgUE0sIEFuZHJpaSBOYWtyeWlrbyB3cm90ZToNCj4gT24gV2VkLCBP
Y3QgOSwgMjAxOSBhdCA5OjE1IFBNIEFsZXhlaSBTdGFyb3ZvaXRvdiA8YXN0QGtlcm5lbC5vcmc+
IHdyb3RlOg0KPj4NCj4+ICAgLyogdHlwZSBvZiB2YWx1ZXMgcmV0dXJuZWQgZnJvbSBoZWxwZXIg
ZnVuY3Rpb25zICovDQo+PiBAQCAtMjM1LDExICsyMzYsMTcgQEAgc3RydWN0IGJwZl9mdW5jX3By
b3RvIHsNCj4+ICAgICAgICAgIGJvb2wgZ3BsX29ubHk7DQo+PiAgICAgICAgICBib29sIHBrdF9h
Y2Nlc3M7DQo+PiAgICAgICAgICBlbnVtIGJwZl9yZXR1cm5fdHlwZSByZXRfdHlwZTsNCj4+IC0g
ICAgICAgZW51bSBicGZfYXJnX3R5cGUgYXJnMV90eXBlOw0KPj4gLSAgICAgICBlbnVtIGJwZl9h
cmdfdHlwZSBhcmcyX3R5cGU7DQo+PiAtICAgICAgIGVudW0gYnBmX2FyZ190eXBlIGFyZzNfdHlw
ZTsNCj4+IC0gICAgICAgZW51bSBicGZfYXJnX3R5cGUgYXJnNF90eXBlOw0KPj4gLSAgICAgICBl
bnVtIGJwZl9hcmdfdHlwZSBhcmc1X3R5cGU7DQo+PiArICAgICAgIHVuaW9uIHsNCj4+ICsgICAg
ICAgICAgICAgICBzdHJ1Y3Qgew0KPj4gKyAgICAgICAgICAgICAgICAgICAgICAgZW51bSBicGZf
YXJnX3R5cGUgYXJnMV90eXBlOw0KPj4gKyAgICAgICAgICAgICAgICAgICAgICAgZW51bSBicGZf
YXJnX3R5cGUgYXJnMl90eXBlOw0KPj4gKyAgICAgICAgICAgICAgICAgICAgICAgZW51bSBicGZf
YXJnX3R5cGUgYXJnM190eXBlOw0KPj4gKyAgICAgICAgICAgICAgICAgICAgICAgZW51bSBicGZf
YXJnX3R5cGUgYXJnNF90eXBlOw0KPj4gKyAgICAgICAgICAgICAgICAgICAgICAgZW51bSBicGZf
YXJnX3R5cGUgYXJnNV90eXBlOw0KPj4gKyAgICAgICAgICAgICAgIH07DQo+PiArICAgICAgICAg
ICAgICAgZW51bSBicGZfYXJnX3R5cGUgYXJnX3R5cGVbNV07DQo+PiArICAgICAgIH07DQo+PiAr
ICAgICAgIHUzMiAqYnRmX2lkOyAvKiBCVEYgaWRzIG9mIGFyZ3VtZW50cyAqLw0KPiANCj4gYXJl
IHlvdSB0cnlpbmcgdG8gc2F2ZSBtZW1vcnkgd2l0aCB0aGlzPyBvdGhlcndpc2Ugbm90IHN1cmUg
d2h5IGl0J3MNCj4gbm90IGp1c3QgYHUzMiBidGZfaWRbNV1gPyBFdmVuIGluIHRoYXQgY2FzZSBp
dCB3aWxsIHNhdmUgYXQgbW9zdCAxMg0KPiBieXRlcyAoYW5kIEkgaGF2ZW4ndCBldmVuIGNoZWNr
IGFsaWdubWVudCBwYWRkaW5nIGFuZCBzdHVmZikuIFNvDQo+IGRvZXNuJ3Qgc2VlbSB3b3J0aCBp
dD8NCg0KR2xhZCB5b3UgYXNrZWQgOikNCkl0IGNhbm5vdCBiZSAidTMyIGJ0Zl9pZFs1XTsiLg0K
R3Vlc3Mgd2h5Pw0KSSB0aGluayBpdCdzIGEgY29vbCB0cmljay4NCkkgd2FzIGhhcHB5IHdoZW4g
SSBmaW5hbGx5IGZpZ3VyZWQgb3V0IHRvIHNvbHZlIGl0IHRoaXMgd2F5DQphZnRlciBhbmFseXpp
bmcgYSBidW5jaCBvZiB1Z2x5IHNvbHV0aW9ucy4NCg0KPj4gKyAqDQo+PiArICogICAgICAgICAg
ICAgVGhlIHZhbHVlIHRvIHdyaXRlLCBvZiAqc2l6ZSosIGlzIHBhc3NlZCB0aHJvdWdoIGVCUEYg
c3RhY2sgYW5kDQo+PiArICogICAgICAgICAgICAgcG9pbnRlZCBieSAqZGF0YSouDQo+IA0KPiB0
eXBvPyBwb2ludGVkIF9fdG9fXyBieSAqZGF0YSo/DQoNCkknbSBub3QgYW4gZ3JhbW1hciBleHBl
cnQuIFRoYXQgd2FzIGEgY29weSBwYXN0ZSBmcm9tIGV4aXN0aW5nIGNvbW1lbnQuDQoNCj4+ICsg
Kg0KPj4gKyAqICAgICAgICAgICAgICpjdHgqIGlzIGEgcG9pbnRlciB0byBpbi1rZXJuZWwgc3V0
cmN0IHNrX2J1ZmYuDQo+PiArICoNCj4+ICsgKiAgICAgICAgICAgICBUaGlzIGhlbHBlciBpcyBz
aW1pbGFyIHRvICoqYnBmX3BlcmZfZXZlbnRfb3V0cHV0KipcICgpIGJ1dA0KPj4gKyAqICAgICAg
ICAgICAgIHJlc3RyaWN0ZWQgdG8gcmF3X3RyYWNlcG9pbnQgYnBmIHByb2dyYW1zLg0KPiANCj4g
bml0OiB3aXRoIEJURiB0eXBlIHRyYWNraW5nIGVuYWJsZWQ/DQoNCnN1cmUuDQoNCj4+ICsgICAg
ICAgZm9yIChpID0gMDsgaSA8IDU7IGkrKykgew0KPj4gKyAgICAgICAgICAgICAgIGlmIChmbi0+
YXJnX3R5cGVbaV0gPT0gQVJHX1BUUl9UT19CVEZfSUQpIHsNCj4+ICsgICAgICAgICAgICAgICAg
ICAgICAgIGlmICghZm4tPmJ0Zl9pZFtpXSkNCj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgZm4tPmJ0Zl9pZFtpXSA9IGJ0Zl9yZXNvbHZlX2hlbHBlcl9pZCgmZW52LT5sb2csIGZu
LT5mdW5jLCAwKTsNCj4gDQo+IGJ1ZzogMCAtPiBpICA6KQ0KDQpOaWNlIGNhdGNoLg0KQ2xlYXJs
eSBJIGRvbid0IGhhdmUgYSB1c2UgY2FzZSB5ZXQgZm9yIDJuZCBhcmcgYmVpbmcgcHRyX3RvX2J0
Zi4NCg==
