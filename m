Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 016A7DD2B0
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 00:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389316AbfJRWJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 18:09:50 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34074 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389264AbfJRWJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 18:09:48 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x9IM7iOP013736;
        Fri, 18 Oct 2019 15:09:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=QQ3X7UZ1KnDEKfKq41IcBUYQVtvm9mlZ38mJe+Odegc=;
 b=aKrqgGwvo/cTmqMEfv8WzGVvVRmG8DN1Ek7wqxaUhPCDiakOK8Fz90xiQ3HhD9o+MOis
 v62k74LGjR8Ri0NJGQq5wVwVFD/iPaFrxBWHt2/sJo8LPhVlg3KIDIKCIbeS6gC7E1LB
 ySiXMQIDhVgW1b6Uv8cXTja6zZO8dRnLIWk= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2vprq9fgys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 18 Oct 2019 15:09:34 -0700
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 18 Oct 2019 15:09:32 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 18 Oct 2019 15:09:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=almBBESH4Dhmh2s3lzDI4f1glInF+J2RJ09hzGXWm/nKHfTEu3H2HaDJEGqm0nY47c2zsaPePNBMHY5BZMIuivRjIXSJeT5c3tZ6ksOMDwQPDhEL36+MX5m28dUXf4/5jwuJ2O83civUWqI3lTLS2cjIOKv4HntmXYI/5ekQ6tqasEKGWyUIiXsvX0iIy09+rLpsjW01IK+OPC+tbp9LOykMEXrOHROUIdGioHwOeCBee1q8VBDGytkWgsgw0Wcp5c/oVdPbyeQI6Los4sQBZBXlL3EYpyVB4oqZ2tWLHwIi2aKZazi6GaVAOKDAw60TcQemwDeSqHsLEDiuhJKZJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QQ3X7UZ1KnDEKfKq41IcBUYQVtvm9mlZ38mJe+Odegc=;
 b=ZW7B1h0tUl+a5MnSb9J89I1Gq+VLllFYuanxCNrYJ99Ee9GHtK9Kp/V8ImP/kVqXrHE6mX8Qyq83iJL8FAtL3l3v3jeux5cpwC5FNGLR0MCW/PbfBQEuj4vxnV9sh5u9IH/kCEhCKxWIsMPPZgfN3xhvJw8D4mTCi4GiEptcsUawZQ67MWwhIDmq37YI149jEoxMBmtkfQClb8srcDXgbajkArVCi+KNcWNCKQuJQQUsgJWOQsOPUwUrgscGIQU0JEXz96gM8S0FBSWXq/p4MpLXCzC7VY5GEJy2ieiAPmgrmFzFJW/WBGcqayRVe6vQCgSiDlIIfEvD5A8kGccrrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QQ3X7UZ1KnDEKfKq41IcBUYQVtvm9mlZ38mJe+Odegc=;
 b=I2jGi0QW5f4etmrcupMGdhovLpVsnR8qxh24qKV25k2LOg/khbBgO7i7lFtR5Bzsv8bbrGu/znRqOcTSqPr4PlOiXI5DP1cUBeL1Z8hNuYlYBag30ZSpd9rpMjEYRvYiD78p+jWFgjy+0E1WbBX7KiZCfgYliW9GWN9/nZ3JEiU=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB2693.namprd15.prod.outlook.com (20.179.156.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.20; Fri, 18 Oct 2019 22:09:31 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d%5]) with mapi id 15.20.2347.024; Fri, 18 Oct 2019
 22:09:31 +0000
From:   Yonghong Song <yhs@fb.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     Andrii Nakryiko <andriin@fb.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [bpf-next PATCH] bpf: libbpf, support older style kprobe load
Thread-Topic: [bpf-next PATCH] bpf: libbpf, support older style kprobe load
Thread-Index: AQHVhcQG6uh+sm4mqE6JAseWoIZMJKdgzVyAgAAmO4CAAAJLAA==
Date:   Fri, 18 Oct 2019 22:09:30 +0000
Message-ID: <a4b5045b-ebbd-a5f4-b96c-0352a5e8bb23@fb.com>
References: <157141046629.11948.8937909716570078019.stgit@john-XPS-13-9370>
 <20191018194425.GI26267@pc-63.home>
 <5daa362b4c9b6_68182abd481885b455@john-XPS-13-9370.notmuch>
In-Reply-To: <5daa362b4c9b6_68182abd481885b455@john-XPS-13-9370.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR2001CA0018.namprd20.prod.outlook.com
 (2603:10b6:301:15::28) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:95af]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: edb73928-ded9-46bf-1735-08d75417d980
x-ms-traffictypediagnostic: BYAPR15MB2693:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB26935674CC4952090492BF46D36C0@BYAPR15MB2693.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-forefront-prvs: 01949FE337
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(366004)(376002)(346002)(396003)(199004)(189003)(486006)(31696002)(186003)(8936002)(52116002)(86362001)(99286004)(81156014)(14454004)(102836004)(76176011)(53546011)(6506007)(81166006)(386003)(31686004)(476003)(2616005)(446003)(11346002)(478600001)(46003)(66476007)(66556008)(66946007)(64756008)(66446008)(316002)(71200400001)(71190400001)(7736002)(54906003)(110136005)(5660300002)(25786009)(2906002)(305945005)(229853002)(256004)(14444005)(6116002)(6436002)(6512007)(6486002)(4326008)(6246003)(36756003)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2693;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2AyXnvzr3bH+BuXj7pzmjHtyzjv0SHWZ6FDMobeg9owQ6oxdvZXix1xzo5qd4RSptuCejcn6MOZ3Qp8rEUoHL1eUvJ0mcOfGmYZi+3LTThVkftWYxlNS1gqBU90JaJNAQ8jNUhiHTmohAyl6miP7CiJKzNWzX9mchW3RAEa+wIwMF0+KGPoaBuZS8Y1hDBACzRLyR3psCaeFrdC79mzTyVXwih2v+znU0N5pSNro5jRh7W/tHTc8zXQTHbe2rM/Wrh3PsbC+pPn7G46HRiGYMBkAVTedmeb7wJrwudgxW8RrLiR+4gXpqsHZCrw0Ab9Nu1CyscBM6pQsLgSV/n31eT3M7J+R1QWCobsE1qCVXKMNwiNQoy9/lEz9+WVaMKuO5uBJmy7awG5IapX4Yjuscd08P3rkTLYPEethqRHQTH2BPjU4+mnVNMHTmCzLJurB
Content-Type: text/plain; charset="utf-8"
Content-ID: <7A9DA29A97F8DB4A8ED24A29CBBDF3DE@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: edb73928-ded9-46bf-1735-08d75417d980
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2019 22:09:31.0613
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kZpjhc/m+Lk/uJjLIIEX6HICer5L949Gi4veWpFmrjEeqJDQ0pxiF3Auj0xyINmb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2693
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-18_05:2019-10-18,2019-10-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 spamscore=0
 impostorscore=0 clxscore=1015 suspectscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910180195
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEwLzE4LzE5IDM6MDEgUE0sIEpvaG4gRmFzdGFiZW5kIHdyb3RlOg0KPiBEYW5pZWwg
Qm9ya21hbm4gd3JvdGU6DQo+PiBPbiBGcmksIE9jdCAxOCwgMjAxOSBhdCAwNzo1NDoyNkFNIC0w
NzAwLCBKb2huIEZhc3RhYmVuZCB3cm90ZToNCj4+PiBGb2xsb3dpbmcgLi9Eb2N1bWVudGF0aW9u
L3RyYWNlL2twcm9iZXRyYWNlLnJzdCBhZGQgc3VwcG9ydCBmb3IgbG9hZGluZw0KPj4+IGtwcm9i
ZXMgcHJvZ3JhbXMgb24gb2xkZXIga2VybmVscy4NCj4+Pg0KPj4+IFNpZ25lZC1vZmYtYnk6IEpv
aG4gRmFzdGFiZW5kIDxqb2huLmZhc3RhYmVuZEBnbWFpbC5jb20+DQo+Pj4gLS0tDQo+Pj4gICB0
b29scy9saWIvYnBmL2xpYmJwZi5jIHwgICA4MSArKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrLS0tLS0NCj4+PiAgIDEgZmlsZSBjaGFuZ2VkLCA3MyBpbnNlcnRpb25z
KCspLCA4IGRlbGV0aW9ucygtKQ0KPj4+DQo+Pj4gZGlmZiAtLWdpdCBhL3Rvb2xzL2xpYi9icGYv
bGliYnBmLmMgYi90b29scy9saWIvYnBmL2xpYmJwZi5jDQo+Pj4gaW5kZXggZmNlYTY5ODhmOTYy
Li4xMmIzMTA1ZDExMmMgMTAwNjQ0DQo+Pj4gLS0tIGEvdG9vbHMvbGliL2JwZi9saWJicGYuYw0K
Pj4+ICsrKyBiL3Rvb2xzL2xpYi9icGYvbGliYnBmLmMNCj4+PiBAQCAtNTAwNSwyMCArNTAwNSw4
OSBAQCBzdGF0aWMgaW50IGRldGVybWluZV91cHJvYmVfcmV0cHJvYmVfYml0KHZvaWQpDQo+Pj4g
ICAJcmV0dXJuIHBhcnNlX3VpbnRfZnJvbV9maWxlKGZpbGUsICJjb25maWc6JWRcbiIpOw0KPj4+
ICAgfQ0KPj4+ICAgDQo+Pj4gK3N0YXRpYyBpbnQgdXNlX2twcm9iZV9kZWJ1Z2ZzKGNvbnN0IGNo
YXIgKm5hbWUsDQo+Pj4gKwkJCSAgICAgIHVpbnQ2NF90IG9mZnNldCwgaW50IHBpZCwgYm9vbCBy
ZXRwcm9iZSkNCj4+DQo+PiBvZmZzZXQgJiBwaWQgdW51c2VkPw0KPiANCj4gV2VsbCBwaWQgc2hv
dWxkIGJlIGRyb3BwZWQgYW5kIEknbGwgYWRkIHN1cHBvcnQgZm9yIG9mZnNldC4gSSd2ZSBub3QN
Cj4gYmVpbmcgdXNpbmcgb2Zmc2V0IHNvIG1pc3NlZCBpdCBoZXJlLg0KPiANCj4+DQo+Pj4gK3sN
Cj4+PiArCWNvbnN0IGNoYXIgKmZpbGUgPSAiL3N5cy9rZXJuZWwvZGVidWcvdHJhY2luZy9rcHJv
YmVfZXZlbnRzIjsNCj4+PiArCWludCBmZCA9IG9wZW4oZmlsZSwgT19XUk9OTFkgfCBPX0FQUEVO
RCwgMCk7DQo+Pj4gKwljaGFyIGJ1ZltQQVRIX01BWF07DQo+Pj4gKwlpbnQgZXJyOw0KPj4+ICsN
Cj4+PiArCWlmIChmZCA8IDApIHsNCj4+PiArCQlwcl93YXJuaW5nKCJmYWlsZWQgb3BlbiBrcHJv
YmVfZXZlbnRzOiAlc1xuIiwNCj4+PiArCQkJICAgc3RyZXJyb3IoZXJybm8pKTsNCj4+PiArCQly
ZXR1cm4gLWVycm5vOw0KPj4+ICsJfQ0KPj4+ICsNCj4+PiArCXNucHJpbnRmKGJ1Ziwgc2l6ZW9m
KGJ1ZiksICIlYzprcHJvYmVzLyVzICVzIiwNCj4+PiArCQkgcmV0cHJvYmUgPyAncicgOiAncCcs
IG5hbWUsIG5hbWUpOw0KPj4+ICsNCj4+PiArCWVyciA9IHdyaXRlKGZkLCBidWYsIHN0cmxlbihi
dWYpKTsNCj4+PiArCWNsb3NlKGZkKTsNCj4+PiArCWlmIChlcnIgPCAwKQ0KPj4+ICsJCXJldHVy
biAtZXJybm87DQo+Pj4gKwlyZXR1cm4gMDsNCj4+PiArfQ0KPj4+ICsNCj4+PiAgIHN0YXRpYyBp
bnQgcGVyZl9ldmVudF9vcGVuX3Byb2JlKGJvb2wgdXByb2JlLCBib29sIHJldHByb2JlLCBjb25z
dCBjaGFyICpuYW1lLA0KPj4+ICAgCQkJCSB1aW50NjRfdCBvZmZzZXQsIGludCBwaWQpDQo+Pj4g
ICB7DQo+Pj4gICAJc3RydWN0IHBlcmZfZXZlbnRfYXR0ciBhdHRyID0ge307DQo+Pj4gICAJY2hh
ciBlcnJtc2dbU1RSRVJSX0JVRlNJWkVdOw0KPj4+ICsJdWludDY0X3QgY29uZmlnMSA9IDA7DQo+
Pj4gICAJaW50IHR5cGUsIHBmZCwgZXJyOw0KPj4+ICAgDQo+Pj4gICAJdHlwZSA9IHVwcm9iZSA/
IGRldGVybWluZV91cHJvYmVfcGVyZl90eXBlKCkNCj4+PiAgIAkJICAgICAgOiBkZXRlcm1pbmVf
a3Byb2JlX3BlcmZfdHlwZSgpOw0KPj4+ICAgCWlmICh0eXBlIDwgMCkgew0KPj4+IC0JCXByX3dh
cm5pbmcoImZhaWxlZCB0byBkZXRlcm1pbmUgJXMgcGVyZiB0eXBlOiAlc1xuIiwNCj4+PiAtCQkJ
ICAgdXByb2JlID8gInVwcm9iZSIgOiAia3Byb2JlIiwNCj4+PiAtCQkJICAgbGliYnBmX3N0cmVy
cm9yX3IodHlwZSwgZXJybXNnLCBzaXplb2YoZXJybXNnKSkpOw0KPj4+IC0JCXJldHVybiB0eXBl
Ow0KPj4+ICsJCWlmICh1cHJvYmUpIHsNCj4+PiArCQkJcHJfd2FybmluZygiZmFpbGVkIHRvIGRl
dGVybWluZSB1cHJvYmUgcGVyZiB0eXBlICVzOiAlc1xuIiwNCj4+PiArCQkJCSAgIG5hbWUsDQo+
Pj4gKwkJCQkgICBsaWJicGZfc3RyZXJyb3Jfcih0eXBlLA0KPj4+ICsJCQkJCQkgICAgIGVycm1z
Zywgc2l6ZW9mKGVycm1zZykpKTsNCj4+PiArCQl9IGVsc2Ugew0KPj4+ICsJCQkvKiBJZiB3ZSBk
byBub3QgaGF2ZSBhbiBldmVudF9zb3VyY2UvLi4va3Byb2JlcyB0aGVuIHdlDQo+Pj4gKwkJCSAq
IGNhbiB0cnkgdG8gdXNlIGtwcm9iZS1iYXNlIGV2ZW50IHRyYWNpbmcsIGZvciBkZXRhaWxzDQo+
Pj4gKwkJCSAqIHNlZSAuL0RvY3VtZW50YXRpb24vdHJhY2Uva3Byb2JldHJhY2UucnN0DQo+Pj4g
KwkJCSAqLw0KPj4+ICsJCQljb25zdCBjaGFyICpmaWxlID0gIi9zeXMva2VybmVsL2RlYnVnL3Ry
YWNpbmcvZXZlbnRzL2twcm9iZXMvIjsNCj4+PiArCQkJY2hhciBjW1BBVEhfTUFYXTsNCj4+PiAr
CQkJaW50IGZkLCBuOw0KPj4+ICsNCj4+PiArCQkJc25wcmludGYoYywgc2l6ZW9mKGMpLCAiJXMv
JXMvaWQiLCBmaWxlLCBuYW1lKTsNCj4+PiArDQo+Pj4gKwkJCWVyciA9IHVzZV9rcHJvYmVfZGVi
dWdmcyhuYW1lLCBvZmZzZXQsIHBpZCwgcmV0cHJvYmUpOw0KPj4+ICsJCQlpZiAoZXJyKQ0KPj4+
ICsJCQkJcmV0dXJuIGVycjsNCj4+DQo+PiBTaG91bGQgd2UgdGhyb3cgYSBwcl93YXJuaW5nKCkg
aGVyZSBhcyB3ZWxsIHdoZW4gYmFpbGluZyBvdXQ/DQo+IA0KPiBTdXJlIG1ha2VzIHNlbnNlLg0K
PiANCj4+DQo+Pj4gKwkJCXR5cGUgPSBQRVJGX1RZUEVfVFJBQ0VQT0lOVDsNCj4+PiArCQkJZmQg
PSBvcGVuKGMsIE9fUkRPTkxZLCAwKTsNCj4+PiArCQkJaWYgKGZkIDwgMCkgew0KPj4+ICsJCQkJ
cHJfd2FybmluZygiZmFpbGVkIHRvIG9wZW4gdHJhY2Vwb2ludCAlczogJXNcbiIsDQo+Pj4gKwkJ
CQkJICAgYywgc3RyZXJyb3IoZXJybm8pKTsNCj4+PiArCQkJCXJldHVybiAtZXJybm87DQo+Pj4g
KwkJCX0NCj4+PiArCQkJbiA9IHJlYWQoZmQsIGMsIHNpemVvZihjKSk7DQo+Pj4gKwkJCWNsb3Nl
KGZkKTsNCj4+PiArCQkJaWYgKG4gPCAwKSB7DQo+Pj4gKwkJCQlwcl93YXJuaW5nKCJmYWlsZWQg
dG8gcmVhZCAlczogJXNcbiIsDQo+Pj4gKwkJCQkJICAgYywgc3RyZXJyb3IoZXJybm8pKTsNCj4+
PiArCQkJCXJldHVybiAtZXJybm87DQo+Pj4gKwkJCX0NCj4+PiArCQkJY1tuXSA9ICdcMCc7DQo+
Pj4gKwkJCWNvbmZpZzEgPSBzdHJ0b2woYywgTlVMTCwgMCk7DQo+Pj4gKwkJCWF0dHIuc2l6ZSA9
IHNpemVvZihhdHRyKTsNCj4+PiArCQkJYXR0ci50eXBlID0gdHlwZTsNCj4+PiArCQkJYXR0ci5j
b25maWcgPSBjb25maWcxOw0KPj4+ICsJCQlhdHRyLnNhbXBsZV9wZXJpb2QgPSAxOw0KPj4+ICsJ
CQlhdHRyLndha2V1cF9ldmVudHMgPSAxOw0KPj4NCj4+IElzIHRoZXJlIGEgcmVhc29uIHlvdSBz
ZXQgbGF0dGVyIHR3byB3aGVyZWFzIGJlbG93IHRoZXkgYXJlIG5vdCBzZXQsDQo+PiBkb2VzIGl0
IG5vdCBkZWZhdWx0IHRvIHRoZXNlPw0KPiANCj4gV2UgY2FuIGRyb3AgdGhpcy4NCg0KQWdyZWVk
LiBhdHRyLnNhbXBsZV9wZXJpb2QgYW5kIGF0dHIud2FrZXVwX2V2ZW50cyBhcmUgdXNlZCBmb3Ig
cGVyZi4NCkhlcmUgd2UgcnVuIGJwZiBwcm9ncmFtcyBhbmQgcmV0dXJuIGVhcmx5LCBzbyB0aGVz
ZSB0d28gdmFsdWVzIHdvbid0IA0KdGFrZSBlZmZlY3QuDQoNCj4gDQo+Pg0KPj4+ICsJCX0NCj4+
PiArCX0gZWxzZSB7DQo+Pj4gKwkJY29uZmlnMSA9IHB0cl90b191NjQobmFtZSk7DQo+Pj4gKwkJ
YXR0ci5zaXplID0gc2l6ZW9mKGF0dHIpOw0KPj4+ICsJCWF0dHIudHlwZSA9IHR5cGU7DQo+Pj4g
KwkJYXR0ci5jb25maWcxID0gY29uZmlnMTsgLyoga3Byb2JlX2Z1bmMgb3IgdXByb2JlX3BhdGgg
Ki8NCj4+PiArCQlhdHRyLmNvbmZpZzIgPSBvZmZzZXQ7ICAvKiBrcHJvYmVfYWRkciBvciBwcm9i
ZV9vZmZzZXQgKi8NCj4+PiAgIAl9DQo+Pj4gICAJaWYgKHJldHByb2JlKSB7DQo+Pj4gICAJCWlu
dCBiaXQgPSB1cHJvYmUgPyBkZXRlcm1pbmVfdXByb2JlX3JldHByb2JlX2JpdCgpDQo+Pj4gQEAg
LTUwMzMsMTAgKzUxMDIsNiBAQCBzdGF0aWMgaW50IHBlcmZfZXZlbnRfb3Blbl9wcm9iZShib29s
IHVwcm9iZSwgYm9vbCByZXRwcm9iZSwgY29uc3QgY2hhciAqbmFtZSwNCj4+PiAgIAkJfQ0KPj4+
ICAgCQlhdHRyLmNvbmZpZyB8PSAxIDw8IGJpdDsNCj4+PiAgIAl9DQo+Pg0KPj4gV2hhdCBoYXBw
ZW5zIGluIGNhc2Ugb2YgcmV0cHJvYmUsIGRvbid0IHlvdSAodW53YW50ZWRseSkgYmFpbCBvdXQg
aGVyZQ0KPj4gYWdhaW4gKGV2ZW4gdGhyb3VnaCB5b3UndmUgc2V0IHVwIHRoZSByZXRwcm9iZSBl
YXJsaWVyKT8NCj4gDQo+IFdpbGwgZml4IGFzIHdlbGwuIExvb2tpbmcgdG8gc2VlIGhvdyBpdCBw
YXNzZWQgb24gbXkgYm94IGhlcmUgYnV0IGVpdGhlcg0KPiB3YXkgaXRzIGNyeXB0aWMgc28gd2ls
bCBjbGVhbiB1cC4NCj4gDQo+Pg0KPj4+IC0JYXR0ci5zaXplID0gc2l6ZW9mKGF0dHIpOw0KPj4+
IC0JYXR0ci50eXBlID0gdHlwZTsNCj4+PiAtCWF0dHIuY29uZmlnMSA9IHB0cl90b191NjQobmFt
ZSk7IC8qIGtwcm9iZV9mdW5jIG9yIHVwcm9iZV9wYXRoICovDQo+Pj4gLQlhdHRyLmNvbmZpZzIg
PSBvZmZzZXQ7CQkgLyoga3Byb2JlX2FkZHIgb3IgcHJvYmVfb2Zmc2V0ICovDQo+Pj4gICANCj4+
PiAgIAkvKiBwaWQgZmlsdGVyIGlzIG1lYW5pbmdmdWwgb25seSBmb3IgdXByb2JlcyAqLw0KPj4+
ICAgCXBmZCA9IHN5c2NhbGwoX19OUl9wZXJmX2V2ZW50X29wZW4sICZhdHRyLA0KPj4+DQo+IA0K
PiANCg==
