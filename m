Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC63048D24
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 20:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727683AbfFQS6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 14:58:09 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:16776 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725839AbfFQS6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 14:58:08 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5HIvhsu005764;
        Mon, 17 Jun 2019 11:57:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=ScN/PXzBQnHkiM4Si/xs/o97dda6m3jAGc9su/sF4Qo=;
 b=cgnmi/GwS8XuXWM8Q9B/qmHz+XHXEnlNwxaYdOcO4fCNKm4lgmi3uOyZ58Nlg5Z/n03s
 pswQIjFTNT+6OkF2cidD5GcwN4wnQlO2qlfa2/odPzwNOwHcNbdWm2doah8pzEw7T6mh
 yZLLFsAqkBJ6YS9FOPI1kIIzsvE2zzbCVfQ= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2t6e8erkqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 17 Jun 2019 11:57:43 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 17 Jun 2019 11:57:42 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 17 Jun 2019 11:57:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ScN/PXzBQnHkiM4Si/xs/o97dda6m3jAGc9su/sF4Qo=;
 b=GLDnsk99MmkjaKUR5FZBgl3Eo4uAV4kBix1Ftb6lKL92wX5ct5Bid5YSD6tQAstQfAgEV3ql0n2B/HBCWsJSRb+82cEY2z/Z0yH8bL2Ph5MqZsheEUE++yogrzQuEDAnE0oHsrcp1Co3/3yPh4gH0wd7Zkk9SK0socVO5/SHX7g=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB3318.namprd15.prod.outlook.com (20.179.58.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.10; Mon, 17 Jun 2019 18:57:40 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::60a3:8bdd:1ea2:3702]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::60a3:8bdd:1ea2:3702%7]) with mapi id 15.20.1987.014; Mon, 17 Jun 2019
 18:57:40 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 0/9] bpf: bounded loops and other features
Thread-Topic: [PATCH v3 bpf-next 0/9] bpf: bounded loops and other features
Thread-Index: AQHVI65GI4VJAvCO2kK9BBp8ni6I4aagDzMAgAAmf4A=
Date:   Mon, 17 Jun 2019 18:57:40 +0000
Message-ID: <70187096-9876-b004-0ccb-8293618f384f@fb.com>
References: <20190615191225.2409862-1-ast@kernel.org>
 <CAEf4BzY_w-tTQFy_MfSvRwS4uDziNLRN+Jax4WXidP9R-s961w@mail.gmail.com>
In-Reply-To: <CAEf4BzY_w-tTQFy_MfSvRwS4uDziNLRN+Jax4WXidP9R-s961w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR13CA0041.namprd13.prod.outlook.com
 (2603:10b6:300:95::27) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:3e5b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 87613553-1078-493c-d0d4-08d6f355abfa
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB3318;
x-ms-traffictypediagnostic: BYAPR15MB3318:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <BYAPR15MB331847C3A76F898A16598337D7EB0@BYAPR15MB3318.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0071BFA85B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(366004)(346002)(136003)(39860400002)(396003)(189003)(199004)(86362001)(76176011)(6506007)(53546011)(386003)(31696002)(31686004)(966005)(316002)(478600001)(99286004)(4326008)(73956011)(66476007)(64756008)(66446008)(52116002)(66556008)(6116002)(71200400001)(66946007)(102836004)(6246003)(486006)(71190400001)(36756003)(68736007)(7736002)(446003)(476003)(2616005)(11346002)(186003)(14444005)(256004)(5660300002)(25786009)(81166006)(8676002)(81156014)(8936002)(6436002)(6512007)(2906002)(229853002)(46003)(6486002)(53936002)(6306002)(14454004)(305945005)(54906003)(110136005);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3318;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2IfDtAGIZfVmVJm67NaaVZcBFFqJum8rmVrJ9xYC9Bk+E28LWGSxaRhY9j+PvZq/sH2ZNwn+V5CKpGQYzlaD7kp5MPQ02UpE+n/EiWnFPHG8EVCgD8yz8ipLcUM0la2vm0GLGXjXBw62w0IyBZXfZWHBWa2n7lMA/gbIt6izmVxpTustBuL5/Pq0EbsIu8de5lfyaCjX5WbgfIpqhGir5TMtAxn19uufXV/LRJy6ptpNOIlD6lgXBukgGC09h0auRhVJVcYWqqCvE7waLDglx6pxePU3OucP1lrOgFTndxBPiBHOg0gmLiAKMOzsrMNFIcgPtIQD+O8YbcJZVkrtT6sSVMkC7aN2rRl4pPAdwg/C0AM29uH3cFn+z6Ubq+4GnfCRRumU8iX0QTok4RS3VpO6HVhzs99QpxiAiZt24lg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CBC0CE02F439E74AB89BA7E3F69883C3@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 87613553-1078-493c-d0d4-08d6f355abfa
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2019 18:57:40.5703
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ast@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3318
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-17_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906170168
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNi8xNy8xOSA5OjM5IEFNLCBBbmRyaWkgTmFrcnlpa28gd3JvdGU6DQo+IE9uIFNhdCwgSnVu
IDE1LCAyMDE5IGF0IDEyOjEyIFBNIEFsZXhlaSBTdGFyb3ZvaXRvdiA8YXN0QGtlcm5lbC5vcmc+
IHdyb3RlOg0KPj4NCj4+IHYyLT52MzogZml4ZWQgaXNzdWVzIGluIGJhY2t0cmFja2luZyBwb2lu
dGVkIG91dCBieSBBbmRyaWkuDQo+PiBUaGUgbmV4dCBzdGVwIGlzIHRvIGFkZCBhIGxvdCBtb3Jl
IHRlc3RzIGZvciBiYWNrdHJhY2tpbmcuDQo+Pg0KPiANCj4gVGVzdHMgd291bGQgYmUgZ3JlYXQs
IHZlcmlmaWVyIGNvbXBsZXhpdHkgaXMgYXQgdGhlIGxldmVsLCB3aGVyZSBpdCdzDQo+IHZlcnkg
ZWFzeSB0byBtaXNzIGlzc3Vlcy4NCj4gDQo+IFdhcyBmdXp6eWluZyBhcHByb2FjaCBldmVyIGRp
c2N1c3NlZCBmb3IgQlBGIHZlcmlmaWVyPyBJLmUuLCBoYXZlIGENCj4gZnV6emVyIHRvIGdlbmVy
YXRlIGJvdGggbGVnYWwgYW5kIGlsbGVnYWwgcmFuZG9tIHNtYWxsIHByb2dyYW1zLiBUaGVuDQo+
IHJlLWltcGxlbWVudCB2ZXJpZmllciBhcyB1c2VyLWxldmVsIHByb2dyYW0gd2l0aCBzdHJhaWdo
dGZvcndhcmQNCj4gcmVjdXJzaXZlIGV4aGF1c3RpdmUgdmVyaWZpY2F0aW9uIChzbyBubyBzdGF0
ZSBwcnVuaW5nIGxvZ2ljLCBubw0KPiBwcmVjaXNlL2NvYXJzZSwgZXRjLCBqdXN0IHJlZ2lzdGVy
L3N0YWNrIHN0YXRlIHRyYWNraW5nKSBvZiBhbGwNCj4gcG9zc2libGUgYnJhbmNoZXMuIElmIGtl
cm5lbCB2ZXJpZmllcidzIHZlcmRpY3QgZGlmZmVycyBmcm9tDQo+IHVzZXItbGV2ZWwgdmVyaWZp
ZXIncyB2ZXJkaWN0IC0gZmxhZyB0aGF0IGFzIGEgdGVzdCBjYXNlIGFuZCBmaWd1cmUNCj4gb3V0
IHdoeSB0aGV5IGRpZmZlci4gT2J2aW91c2x5IHRoYXQgd291bGQgd29yayB3ZWxsIG9ubHkgZm9y
IHNtYWxsDQo+IHByb2dyYW1zLCBidXQgdGhhdCBzaG91bGQgYmUgYSBnb29kIGZpcnN0IHN0ZXAg
YWxyZWFkeS4NCj4gDQo+IEluIGFkZGl0aW9uLCBpZiB0aGlzIGlzIGRvbmUsIHRoYXQgdXNlci1s
YW5kIHZlcmlmaWVyIGNhbiBiZSBhIEhVR0UNCj4gaGVscCB0byBCUEYgYXBwbGljYXRpb24gZGV2
ZWxvcGVycywgYXMgbGliYnBmIHdvdWxkIChwb3RlbnRpYWxseSkgYmUNCj4gYWJsZSB0byBnZW5l
cmF0ZSBiZXR0ZXIgZXJyb3IgbWVzc2FnZXMgdXNpbmcgaXQgYXMgd2VsbC4NCg0KSW4gdGhlb3J5
IHRoYXQgc291bmRzIGdvb2QsIGJ1dCBkb2Vzbid0IHdvcmsgaW4gcHJhY3RpY2UuDQpUaGUga2Vy
bmVsIHZlcmlmaWVyIGtlZXBzIGNoYW5naW5nIGZhc3RlciB0aGFuIHVzZXIgc3BhY2UgY2FuIGNh
dGNoIHVwLg0KSXQncyBhbHNvIHJlbHlpbmcgb24gbG9hZGVkIG1hcHMgYW5kIGFsbCBzb3J0cyBv
ZiBjYWxsYmFja3MgdGhhdA0KY2hlY2sgY29udGV4dCwgYWxsb3dlZCBoZWxwZXJzLCBtYXBzLCBj
b21iaW5hdGlvbnMgb2YgdGhlbSBmcm9tIGFsbA0Kb3ZlciB0aGUga2VybmVsLg0KVGhlIGxhc3Qg
ZWZmb3J0IHRvIGJ1aWxkIGtlcm5lbCB2ZXJpZmllciBhcy1pcyBpbnRvIC5vIGFuZCBsaW5rDQp3
aXRoIGttYWxsb2MvbWFwIHdyYXBwZXJzIGluIHVzZXIgc3BhY2Ugd2FzIGhlcmU6DQpodHRwczov
L2dpdGh1Yi5jb20vaW92aXNvci9icGYtZnV6emVyDQpJdCB3YXMgZnV6emluZyB0aGUgdmVyaWZp
ZXIgYW5kIHdhcyBhYmxlIHRvIGZpbmQgZmV3IG1pbm9yIGJ1Z3MuDQpCdXQgaXQgcXVpY2tseSBi
aXQgcm90dGVkLg0KDQpGb2xrcyBicm91Z2h0IHVwIGluIHRoZSBwYXN0IHRoZSBpZGVhIHRvIGNv
bGxlY3QgdXNlciBzcGFjZQ0KdmVyaWZpZXJzIGZyb20gZGlmZmVyZW50IGtlcm5lbHMsIHNvIHRo
YXQgdXNlciBzcGFjZSB0b29saW5nIGNhbg0KY2hlY2sgd2hldGhlciBwYXJ0aWN1bGFyIHByb2dy
YW0gd2lsbCBsb2FkIG9uIGEgc2V0IG9mIGtlcm5lbHMNCndpdGhvdXQgbmVlZCB0byBydW4gdGhl
bSBpbiBWTXMuDQpFdmVuIGlmIHN1Y2ggZmVhdHVyZSBleGlzdGVkIHRvZGF5IGl0IHdvbid0IHJl
YWxseSBzb2x2ZSB0aGlzIHByb2R1Y3Rpb24NCmhlYWRhY2hlLCBzaW5jZSBhbGwga2VybmVscyBw
cmlvciB0byB0b2RheSB3aWxsIG5vdCBiZSBjb3ZlcmVkLg0KDQpJIHRoaW5rIHN5emJvdCBpcyBz
dGlsbCBnZW5lcmF0aW5nIGJwZiBwcm9ncmFtcy4gaWlyYyBpdCBmb3VuZA0Kb25lIGJ1ZyBpbiB0
aGUgcGFzdCBpbiB0aGUgdmVyaWZpZXIgY29yZS4NCkkgdGhpbmsgdGhlIG9ubHkgd2F5IHRvIG1h
a2UgdmVyaWZpZXIgbW9yZSByb2J1c3QgaXMgdG8ga2VlcA0KYWRkaW5nIG5ldyB0ZXN0IGNhc2Vz
IG1hbnVhbGx5Lg0KTW9zdCBpbnRlcmVzdGluZyBidWdzIHdlIGZvdW5kIGJ5IGh1bWFucy4NCg0K
QW5vdGhlciBhcHByb2FjaCB0byAnYmV0dGVyIGVycm9yIG1lc3NhZ2UnIHRoYXQgd2FzIGNvbnNp
ZGVyZWQNCmluIHRoZSBwYXN0IHdhcyB0byB0ZWFjaCBsbHZtIHRvIHJlY29nbml6ZSB0aGluZ3Mg
dGhhdCB2ZXJpZmllcg0Kd2lsbCByZWplY3QgYW5kIGxldCBsbHZtIHdhcm4gb24gdGhlbS4NCkJ1
dCBpdCdzIGFsc28gbm90IHByYWN0aWNhbC4gV2UgaGFkIGxsdm0gZXJyb3Igb24gY2FsbHMuDQpU
aGVuIHdlIGFkZGVkIHRoZW0gdG8gdGhlIHZlcmlmaWVyIGFuZCBoYWQgdG8gY2hhbmdlIGxsdm0u
DQpJZiB3ZSBoYWQgbGx2bSBlcnJvciBvbiBsb29wcywgbm93IHdlJ2QgbmVlZCB0byBjaGFuZ2Ug
aXQuDQppbW8gaXQncyBiZXR0ZXIgdG8gbGV0IGxsdm0gaGFuZGxlIGV2ZXJ5dGhpbmcuDQo=
