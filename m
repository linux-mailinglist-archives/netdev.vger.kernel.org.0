Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFF97CCD9A
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 03:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbfJFBB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 21:01:56 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:29624 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726976AbfJFBB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 21:01:56 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x960wNsp017837;
        Sat, 5 Oct 2019 18:01:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=oZkk0mPIHyIKnpOpiZTF061ZMHg9LFOvrRxTUafheG4=;
 b=ieqKBZ2T7HuZdjhda1XVx70JY9lWpS6MsyrOv90SeN2k8bqrOFRU8l+jaXGI3i0rrhG/
 3PLItHvFsZ7wWnaO92DvH22mXgdIUmAS8OhGBJt0UPBbauaEbnDvpz1QcBuYQYuuWrjf
 TlSGcpn3GvszbWKbxDDLfHPFFZUQC40Hv2I= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ves0gjedb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 05 Oct 2019 18:01:42 -0700
Received: from ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 5 Oct 2019 18:01:41 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Sat, 5 Oct 2019 18:01:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lU8sxOTv+EdSZWE7LJBjxbxP4xONR9iIYBAdePMr+ovvI2VFFamOJ7ag/eJXFREOoFgngny21n1cEAZ4xgLYOxe/tIP6mRGWq8aI5uPdIxBQczoVe4cR94TT9iwYWAd2tc08omXzNfMyGA2xunQz2zhGYv9PppKwG4vz+fLBjmeoHdgBTdzjLflpBkRDw6WQ3fA2/MKvXaVUJ8VX6ajmDVcWoJC+qlSGRXm8Jq2RnkI/dn1JVr2iV58Pwhe151HHQH0IbyIaPisKvMMaHup0oA2EzkJnxCBYFLfKW8szwJeatbz6xuZYrPO07Ak5uxKGCT4xxSEU/5dGTlvGnXdaKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oZkk0mPIHyIKnpOpiZTF061ZMHg9LFOvrRxTUafheG4=;
 b=g5eX0ZT5qiaMjc+/bTjoGQJ0mjBdr9oVn55mwTfNFwfh9nhowFQjac+sd61+Bth7hydT91/MnQ8M2DwxH04oJ676hJpz9S6LJ/gYzdMW99M5SHtpKpmkhEE8oJb8JCfy/qlIhj+4tlPCRaBMhrZ7FTOHGo5bc5XPuN7T6CyAj7+RScT1YHjdqBmd1iFDPttpI1BwHZubOIsuQ/ktcrrX7eywa9567wRZjMM6y6/13GmS56eEM1zky4Pd23hghPx7tyEdIzzA/vnWLgxqUWir3EVzvNe4UWDbdAJnBhw+5+lkF0xBOpQbe0ta3cyJGsbY99xv08CFP5/drIw7HbrRFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oZkk0mPIHyIKnpOpiZTF061ZMHg9LFOvrRxTUafheG4=;
 b=XxxvM3YZzOPh1QoysfU78ls2QmBl4lE2FM1Lpy71nCh2OVUI70uowPZfyFmMah7PXn8vjE+WI5DJrsu4u+yRGnrZY0fi4GQzDAgOqRQCmSyp/9Ed2kIahsp3+WE5VsHKRsQlJyoJTnA+f4Sr7znTX9F2fyra40e7FzjCzDbbbt8=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB3415.namprd15.prod.outlook.com (20.179.60.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Sun, 6 Oct 2019 01:01:39 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0%5]) with mapi id 15.20.2327.023; Sun, 6 Oct 2019
 01:01:39 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: Re: [PATCH bpf-next 3/3] libbpf: auto-generate list of BPF helper
 definitions
Thread-Topic: [PATCH bpf-next 3/3] libbpf: auto-generate list of BPF helper
 definitions
Thread-Index: AQHVe1Lc+C9eeTHkrEenNHp85oWdn6dL05uAgACKBICAAG7vAA==
Date:   Sun, 6 Oct 2019 01:01:39 +0000
Message-ID: <c621f33f-4c17-f96f-e2f5-625d452f3df3@fb.com>
References: <20191005075921.3310139-1-andriin@fb.com>
 <20191005075921.3310139-4-andriin@fb.com>
 <b0df96f6-dc41-8baf-baa3-e98da94c54b7@fb.com>
 <CAEf4BzZdhBTovTfv+Ar0En__RmuP6Lr=RWF2ix3uo9hZ84oHcg@mail.gmail.com>
In-Reply-To: <CAEf4BzZdhBTovTfv+Ar0En__RmuP6Lr=RWF2ix3uo9hZ84oHcg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR22CA0072.namprd22.prod.outlook.com
 (2603:10b6:300:12a::34) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::7b19]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bb82ac10-7272-4eb3-5baa-08d749f8be49
x-ms-traffictypediagnostic: BYAPR15MB3415:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB34156EC8B8DE7238470F1AA5D7980@BYAPR15MB3415.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:374;
x-forefront-prvs: 0182DBBB05
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(376002)(346002)(39850400004)(396003)(136003)(189003)(199004)(6506007)(2616005)(53546011)(11346002)(46003)(486006)(446003)(186003)(66556008)(66476007)(64756008)(66446008)(31686004)(476003)(14454004)(71200400001)(71190400001)(102836004)(229853002)(6486002)(256004)(52116002)(99286004)(386003)(66946007)(81156014)(81166006)(76176011)(4326008)(6116002)(316002)(36756003)(6916009)(6512007)(8936002)(31696002)(5660300002)(6246003)(25786009)(86362001)(2906002)(54906003)(6436002)(305945005)(8676002)(478600001)(7736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3415;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PYLIMkmXGVeoE0Om6NuY/4/3Dy1YTG7oRYEEjUByltsi6WZh5T02fGqRovk5EeyhXw0kzB33WB73ufkGL8KEXZfgSreulwlZ1RFzp4d52ErxLYRq6KkifDdjCKsU8gNqHO8mqH6IPwZjAPSdnoySkquO9U5G9Yc36YOiti6qpj4xpiIkLywhOoFqUNIpN+Ug+m9iWhguiOjSKDJ7EzbXiVFFmKfYnlReG0xBAtp1xjDz0dK2xkLrfxE1lTskTQKUszyVbLRS5kNkXvjyUGe981Mdv8LF4OdoLplKwBjepvRrOuzPKXKYWHjxBuPe1lu62K2Auub1iueKuddY8MepI9x8aBTZvaTqolHn8sfamm0jbzq7gmYk22ELJ6B9bH3mKOqUSMZHlwjfh3PlwULdfx4RM7xeiUN7c7QkNPrmla4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D3B4281950982C4A8F9FE6B6F7BE9655@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: bb82ac10-7272-4eb3-5baa-08d749f8be49
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2019 01:01:39.2718
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CvtSiy3uo1gK3LKSxRpb4LjDU3GdW6r87kpvoBkmqUpj6t6EvO/JsL1AR24GfvI+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3415
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-05_14:2019-10-03,2019-10-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 bulkscore=0 clxscore=1011 impostorscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 spamscore=0 priorityscore=1501 phishscore=0 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910060007
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvNS8xOSAxMToyNCBBTSwgQW5kcmlpIE5ha3J5aWtvIHdyb3RlOg0KPiBPbiBTYXQsIE9j
dCA1LCAyMDE5IGF0IDEwOjEwIEFNIEFsZXhlaSBTdGFyb3ZvaXRvdiA8YXN0QGZiLmNvbT4gd3Jv
dGU6DQo+Pg0KPj4gT24gMTAvNS8xOSAxMjo1OSBBTSwgQW5kcmlpIE5ha3J5aWtvIHdyb3RlOg0K
Pj4+IEdldCByaWQgb2YgbGlzdCBvZiBCUEYgaGVscGVycyBpbiBicGZfaGVscGVycy5oIChpcm9u
eS4uLikgYW5kDQo+Pj4gYXV0by1nZW5lcmF0ZSBpdCBpbnRvIGJwZl9oZWxwZXJzX2RlZnMuaCwg
d2hpY2ggaXMgbm93IGluY2x1ZGVkIGZyb20NCj4+PiBicGZfaGVscGVycy5oLg0KPj4+DQo+Pj4g
U3VnZ2VzdGVkLWJ5OiBBbGV4ZWkgU3Rhcm92b2l0b3Y8YXN0QGZiLmNvbT4NCj4+PiBTaWduZWQt
b2ZmLWJ5OiBBbmRyaWkgTmFrcnlpa288YW5kcmlpbkBmYi5jb20+DQo+Pj4gLS0tDQo+Pj4gICAg
dG9vbHMvbGliL2JwZi9NYWtlZmlsZSAgICAgICAgICAgfCAgICA4ICstDQo+Pj4gICAgdG9vbHMv
bGliL2JwZi9icGZfaGVscGVycy5oICAgICAgfCAgMjY0ICstLQ0KPj4+ICAgIHRvb2xzL2xpYi9i
cGYvYnBmX2hlbHBlcnNfZGVmcy5oIHwgMjY3NyArKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysNCj4+PiAgICAzIGZpbGVzIGNoYW5nZWQsIDI2ODUgaW5zZXJ0aW9ucygrKSwgMjY0IGRlbGV0
aW9ucygtKQ0KPj4+ICAgIGNyZWF0ZSBtb2RlIDEwMDY0NCB0b29scy9saWIvYnBmL2JwZl9oZWxw
ZXJzX2RlZnMuaA0KPj4NCj4+IEFwcHJvYWNoIGxvb2tzIGdvb2QgdG8gbWUuDQo+PiBpbW8gdGhh
dCdzIGJldHRlciB0aGFuIG1lc3Npbmcgd2l0aCBtYWNyb3MuDQo+Pg0KPj4gVXNpbmcgYnBmX2hl
bHBlcnNfZG9jLnB5IGFzIHBhcnQgb2YgYnVpbGQgd2lsbCBoZWxwIG1hbiBwYWdlcyB0b28uDQo+
PiBJIHRoaW5rIHdlIHdlcmUgc2xvcHB5IGRvY3VtZW50aW5nIGhlbHBlcnMsIHNpbmNlIG9ubHkg
UXVlbnRpbg0KPj4gd2FzIHJ1bm5pbmcgdGhhdCBzY3JpcHQgcmVndWxhcmx5Lg0KPiANCj4gWWVw
LCBJIGFncmVlLCBJIGhhZCB0byBmaXggZmV3IHRoaW5ncywgYXMgd2VsbCBhcyAoY2hhciAqKSB2
cyAodm9pZCAqKQ0KPiB2cyAoX191OCAqKSBkaWZmZXJlbmNlcyB3ZXJlIGNhdXNpbmcgc29tZSBl
eHRyYSB3YXJuaW5ncy4NCj4gUGxlYXNlIGNoZWNrIHRoZSBsaXN0IG9mIHR5cGUgdHJhbnNsYXRp
b25zIHdoZXRoZXIgdGhleSBtYWtlIHNlbnNlLg0KDQp5ZXMuIFRoZXNlIGNvbnZlcnNpb25zIG1h
a2Ugc2Vuc2UuDQpPbmx5IG9uZSBza19idWZmLT5fX3NrX2J1ZmYgd29uJ3Qgd29yayBmb3IgdG9v
IGxvbmcuDQpPbmNlIG15IGJ0ZiB2bWxpbnV4IHN0dWZmIGxhbmRzIGJvdGggc3RydWN0cyB3aWxs
IGJlIHBvc3NpYmxlLg0KDQo+Pg0KPj4gT25seSBxdWVzdGlvbiBpcyB3aGF0IGlzIHRoZSByZWFz
b24gdG8gY29tbWl0IGdlbmVyYXRlZCAuaCBpbnRvIGdpdD8NCj4gDQo+IFNvIG9yaWdpbmFsbHkg
SSBkaWRuJ3Qgd2FudCB0byBkZXBlbmQgb24gc3lzdGVtIFVBUEkgaGVhZGVycyBkdXJpbmcNCj4g
R2l0aHViIGJ1aWxkLiBCdXQgbm93IEkgcmVjYWxsZWQgdGhhdCB3ZSBkbyBoYXZlIGxhdGVzdCBV
QVBJIHN5bmNlZA0KPiBpbnRvIEdpdGh1YidzIGluY2x1ZGUvIHN1YmRpciwgc28gdGhhdCdzIG5v
dCBhbiBvYnN0YWNsZSByZWFsbHkuIFdlJ2xsDQo+IGp1c3QgbmVlZCB0byByZS1saWNlbnNlIGJw
Zl9oZWxwZXJzX2RvYy5weSAoSSBkb24ndCB0aGluayBRdWVudGluIHdpbGwNCj4gbWluZCkgYW5k
IHN0YXJ0IHN5bmNpbmcgaXQgdG8gR2l0aHViIChub3QgYSBiaWcgZGVhbCBhdCBhbGwpLg0KDQpn
aXRodWIgc3luYyBzY3JpcHQgY2FuIHJ1biBtYWtlLCBncmFiIGdlbmVyYXRlZCAuaCwNCmFuZCBj
aGVjayBpdCBpbiBpbnRvIGdpdGh1Yi4NCg0KPiANCj4gVGhlcmUgaXMgc3RpbGwgYSBiZW5lZml0
IGluIGhhdmluZyBpdCBjaGVja2VkIGluOiBlYXN5IHRvIHNwb3QgaWYNCj4gc2NyaXB0IGRvZXMg
c29tZXRoaW5nIHdyb25nIGFuZCBkb3VibGUtY2hlY2sgdGhlIGNoYW5nZXMgKGFmdGVyDQo+IGlu
aXRpYWwgYmlnIGNvbW1pdCwgb2YgY291cnNlKS4NCj4gDQo+IElmIHlvdSB0aGluayB0aGF0J3Mg
bm90IHJlYXNvbiBlbm91Z2gsIGxldCBtZSBrbm93IGFuZCBJIGNhbiBkcm9wIGl0IGluIHYyLg0K
DQpJIGRvbid0IHJlbWVtYmVyIHRvbyBtYW55IGNhc2VzIHdoZW4gZ2VuZXJhdGVkIGZpbGVzIHdl
cmUgY29tbWl0dGVkLg0KTXkgcHJlZmVyZW5jZSB0byBrZWVwIGl0IG91dCBvZiBrZXJuZWwgZ2l0
Lg0KZ2l0aHViL2xpYmJwZiBpcyBhIHB1cmUgbWlycm9yLiBUaGF0IC5oIGNhbiBiZSBjb21taXR0
ZWQgdGhlcmUuDQpUaGUgd2hvbGUgdGhpbmcgaXMgYXV0b21hdGljLCBzbyB3ZSBkb24ndCBuZWVk
IHRvIG1vdmUgLnB5DQppbnRvIGdpdGh1YiB0b28uDQoNCg==
