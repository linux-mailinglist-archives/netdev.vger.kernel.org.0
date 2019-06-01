Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8D1A3211F
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 01:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfFAXG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 19:06:28 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59654 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726149AbfFAXG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jun 2019 19:06:28 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x51MxKMh008597;
        Sat, 1 Jun 2019 16:06:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=YtlRE6A7ezocgT4SQ3i4sAX4XXqrQMZsyyRE1Rwb/xA=;
 b=WwY3h3QFglm5sjjeEXXQgAIeS+m7M85TvXel+HBLZzB03x9jG7rYlZuQdymKgU1GeZKS
 qowIs8XvQzik2daAaN6qlhB5R9Z9EP2oenGHcD5TfKRwxRg4/eWSlmQUe6QLVyQUbDeC
 ExlOHJZlXH55MzKWsD0VxjSbmtxf8LMjqAA= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2suq3cs7u9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 01 Jun 2019 16:06:24 -0700
Received: from prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Sat, 1 Jun 2019 16:06:23 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Sat, 1 Jun 2019 16:06:23 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Sat, 1 Jun 2019 16:06:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YtlRE6A7ezocgT4SQ3i4sAX4XXqrQMZsyyRE1Rwb/xA=;
 b=pzKLqYRyCbDQML7i7hW7QxYt/ULkn3rBUfltkdlQFCMXAcLlB1kUJXVpZd49GvDPf/snKEbpuh0QmNKou0Mk47+H0Vk+s49tFFGOM8rlD8C8yNj0pLx9cDpgq1tE01ex81GnTO1i3cO2LGtTT7AXuBPb7WNz+55NujQdB4E/FaQ=
Received: from BN6PR15MB1154.namprd15.prod.outlook.com (10.172.208.137) by
 BN6PR15MB1332.namprd15.prod.outlook.com (10.172.206.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.22; Sat, 1 Jun 2019 23:06:21 +0000
Received: from BN6PR15MB1154.namprd15.prod.outlook.com
 ([fe80::adc0:9bbf:9292:27bd]) by BN6PR15MB1154.namprd15.prod.outlook.com
 ([fe80::adc0:9bbf:9292:27bd%2]) with mapi id 15.20.1922.021; Sat, 1 Jun 2019
 23:06:21 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
CC:     Networking <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "bjorn.topel@intel.com" <bjorn.topel@intel.com>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>
Subject: Re: [PATCH v3 bpf-next 1/2] bpf: Allow bpf_map_lookup_elem() on an
 xskmap
Thread-Topic: [PATCH v3 bpf-next 1/2] bpf: Allow bpf_map_lookup_elem() on an
 xskmap
Thread-Index: AQHVF+Ks6jCUAehXXE6Frnvpym4nraaHbXoA
Date:   Sat, 1 Jun 2019 23:06:21 +0000
Message-ID: <40ECD9E8-5AC5-40E8-BAAD-ADB98AF8A915@fb.com>
References: <20190531185705.2629959-1-jonathan.lemon@gmail.com>
 <20190531185705.2629959-2-jonathan.lemon@gmail.com>
In-Reply-To: <20190531185705.2629959-2-jonathan.lemon@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::6be]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f2c6c828-6b5b-4416-8a73-08d6e6e5c325
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN6PR15MB1332;
x-ms-traffictypediagnostic: BN6PR15MB1332:
x-microsoft-antispam-prvs: <BN6PR15MB13323C4FD9327921265C7F25B31A0@BN6PR15MB1332.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-forefront-prvs: 00550ABE1F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(366004)(39860400002)(376002)(346002)(396003)(199004)(189003)(486006)(2616005)(476003)(82746002)(6436002)(53936002)(6116002)(305945005)(36756003)(68736007)(66574012)(6512007)(4326008)(2906002)(7736002)(11346002)(5660300002)(57306001)(8936002)(25786009)(54906003)(316002)(33656002)(8676002)(81156014)(81166006)(66946007)(6486002)(50226002)(446003)(6246003)(91956017)(76116006)(66446008)(64756008)(66556008)(66476007)(73956011)(46003)(6916009)(229853002)(99286004)(14444005)(256004)(53546011)(6506007)(86362001)(83716004)(102836004)(478600001)(71200400001)(71190400001)(186003)(76176011)(14454004);DIR:OUT;SFP:1102;SCL:1;SRVR:BN6PR15MB1332;H:BN6PR15MB1154.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: hOOUDhiK2lkGvgZpJ7dd2RAReZp0qco4ei9zr6nN/Bb7enLvQlKRGmXKL8dwA90XkwmKAaBX+L6PN+zxKsvZ4FXQ53tCffjk9w5NzVl+nhzgwQIpgkmaFVCsaSJzXjob935tchxvFxjnFxEN9F42DrnlHJP6OloxfPqVI6EbKT2R79GZm8mzYLQa60zy6RlH09NyH+Rvyba5KckJ4rLUeqNfg4J1HTpPYP4AInIGGUrwgu62n4x54pAkI9akx3oq+zqQMbrT0C+PoOa13OVShC+cqbdP1IcEuT0QBwpyqvpRNyUmRMvF2QYBh1d45swV6XzJAYKow7IOwkD7VILVLH3UCqaMunhu94Y64n27Y0PHBtMXsXMrg3Rz7c2rqgw8ort5XZeKB2K9KF8e3tvlesXLaysxCmTaULX/UZhBy7s=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2B70EFF6F7CD17418D13A95442E52B9E@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f2c6c828-6b5b-4416-8a73-08d6e6e5c325
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2019 23:06:21.3989
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1332
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-01_16:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906010166
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gTWF5IDMxLCAyMDE5LCBhdCAxMTo1NyBBTSwgSm9uYXRoYW4gTGVtb24gPGpvbmF0
aGFuLmxlbW9uQGdtYWlsLmNvbT4gd3JvdGU6DQo+IA0KPiBDdXJyZW50bHksIHRoZSBBRl9YRFAg
Y29kZSB1c2VzIGEgc2VwYXJhdGUgbWFwIGluIG9yZGVyIHRvDQo+IGRldGVybWluZSBpZiBhbiB4
c2sgaXMgYm91bmQgdG8gYSBxdWV1ZS4gIEluc3RlYWQgb2YgZG9pbmcgdGhpcywNCj4gaGF2ZSBi
cGZfbWFwX2xvb2t1cF9lbGVtKCkgcmV0dXJuIHRoZSBxdWV1ZV9pZCwgYXMgYSB3YXkgb2YNCj4g
aW5kaWNhdGluZyB0aGF0IHRoZXJlIGlzIGEgdmFsaWQgZW50cnkgYXQgdGhlIG1hcCBpbmRleC4N
Cj4gDQo+IFJlYXJyYW5nZSBzb21lIHhkcF9zb2NrIG1lbWJlcnMgdG8gZWxpbWluYXRlIHN0cnVj
dHVyZSBob2xlcy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEpvbmF0aGFuIExlbW9uIDxqb25hdGhh
bi5sZW1vbkBnbWFpbC5jb20+DQo+IEFja2VkLWJ5OiBCasO2cm4gVMO2cGVsIDxiam9ybi50b3Bl
bEBpbnRlbC5jb20+DQoNCkFja2VkLWJ5OiBTb25nIExpdSA8c29uZ2xpdWJyYXZpbmdAZmIuY29t
Pg0KDQo+IC0tLQ0KPiBpbmNsdWRlL25ldC94ZHBfc29jay5oICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIHwgIDYgKysrLS0tDQo+IGtlcm5lbC9icGYvdmVyaWZpZXIuYyAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgfCAgNiArKysrKy0NCj4ga2VybmVsL2JwZi94c2ttYXAuYyAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICB8ICA0ICsrKy0NCj4gLi4uL3NlbGZ0ZXN0cy9icGYvdmVy
aWZpZXIvcHJldmVudF9tYXBfbG9va3VwLmMgICB8IDE1IC0tLS0tLS0tLS0tLS0tLQ0KPiA0IGZp
bGVzIGNoYW5nZWQsIDExIGluc2VydGlvbnMoKyksIDIwIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlm
ZiAtLWdpdCBhL2luY2x1ZGUvbmV0L3hkcF9zb2NrLmggYi9pbmNsdWRlL25ldC94ZHBfc29jay5o
DQo+IGluZGV4IGQwNzRiNmQ2MGY4YS4uN2Q4NGIxZGE0M2QyIDEwMDY0NA0KPiAtLS0gYS9pbmNs
dWRlL25ldC94ZHBfc29jay5oDQo+ICsrKyBiL2luY2x1ZGUvbmV0L3hkcF9zb2NrLmgNCj4gQEAg
LTU3LDEyICs1NywxMiBAQCBzdHJ1Y3QgeGRwX3NvY2sgew0KPiAJc3RydWN0IG5ldF9kZXZpY2Ug
KmRldjsNCj4gCXN0cnVjdCB4ZHBfdW1lbSAqdW1lbTsNCj4gCXN0cnVjdCBsaXN0X2hlYWQgZmx1
c2hfbm9kZTsNCj4gLQl1MTYgcXVldWVfaWQ7DQo+IC0Jc3RydWN0IHhza19xdWV1ZSAqdHggX19f
X2NhY2hlbGluZV9hbGlnbmVkX2luX3NtcDsNCj4gLQlzdHJ1Y3QgbGlzdF9oZWFkIGxpc3Q7DQo+
ICsJdTMyIHF1ZXVlX2lkOw0KPiAJYm9vbCB6YzsNCj4gCS8qIFByb3RlY3RzIG11bHRpcGxlIHBy
b2Nlc3NlcyBpbiB0aGUgY29udHJvbCBwYXRoICovDQo+IAlzdHJ1Y3QgbXV0ZXggbXV0ZXg7DQo+
ICsJc3RydWN0IHhza19xdWV1ZSAqdHggX19fX2NhY2hlbGluZV9hbGlnbmVkX2luX3NtcDsNCj4g
KwlzdHJ1Y3QgbGlzdF9oZWFkIGxpc3Q7DQo+IAkvKiBNdXR1YWwgZXhjbHVzaW9uIG9mIE5BUEkg
VFggdGhyZWFkIGFuZCBzZW5kbXNnIGVycm9yIHBhdGhzDQo+IAkgKiBpbiB0aGUgU0tCIGRlc3Ry
dWN0b3IgY2FsbGJhY2suDQo+IAkgKi8NCj4gZGlmZiAtLWdpdCBhL2tlcm5lbC9icGYvdmVyaWZp
ZXIuYyBiL2tlcm5lbC9icGYvdmVyaWZpZXIuYw0KPiBpbmRleCAyNzc4NDE3ZTZlMGMuLjkxYzcz
MGY4NWU5MiAxMDA2NDQNCj4gLS0tIGEva2VybmVsL2JwZi92ZXJpZmllci5jDQo+ICsrKyBiL2tl
cm5lbC9icGYvdmVyaWZpZXIuYw0KPiBAQCAtMjkwNSwxMCArMjkwNSwxNCBAQCBzdGF0aWMgaW50
IGNoZWNrX21hcF9mdW5jX2NvbXBhdGliaWxpdHkoc3RydWN0IGJwZl92ZXJpZmllcl9lbnYgKmVu
diwNCj4gCSAqIGFwcGVhci4NCj4gCSAqLw0KPiAJY2FzZSBCUEZfTUFQX1RZUEVfQ1BVTUFQOg0K
PiAtCWNhc2UgQlBGX01BUF9UWVBFX1hTS01BUDoNCj4gCQlpZiAoZnVuY19pZCAhPSBCUEZfRlVO
Q19yZWRpcmVjdF9tYXApDQo+IAkJCWdvdG8gZXJyb3I7DQo+IAkJYnJlYWs7DQo+ICsJY2FzZSBC
UEZfTUFQX1RZUEVfWFNLTUFQOg0KPiArCQlpZiAoZnVuY19pZCAhPSBCUEZfRlVOQ19yZWRpcmVj
dF9tYXAgJiYNCj4gKwkJICAgIGZ1bmNfaWQgIT0gQlBGX0ZVTkNfbWFwX2xvb2t1cF9lbGVtKQ0K
PiArCQkJZ290byBlcnJvcjsNCj4gKwkJYnJlYWs7DQo+IAljYXNlIEJQRl9NQVBfVFlQRV9BUlJB
WV9PRl9NQVBTOg0KPiAJY2FzZSBCUEZfTUFQX1RZUEVfSEFTSF9PRl9NQVBTOg0KPiAJCWlmIChm
dW5jX2lkICE9IEJQRl9GVU5DX21hcF9sb29rdXBfZWxlbSkNCj4gZGlmZiAtLWdpdCBhL2tlcm5l
bC9icGYveHNrbWFwLmMgYi9rZXJuZWwvYnBmL3hza21hcC5jDQo+IGluZGV4IDY4NmQyNDRlNzk4
ZC4uMjQ5YjIyMDg5MDE0IDEwMDY0NA0KPiAtLS0gYS9rZXJuZWwvYnBmL3hza21hcC5jDQo+ICsr
KyBiL2tlcm5lbC9icGYveHNrbWFwLmMNCj4gQEAgLTE1NCw3ICsxNTQsOSBAQCB2b2lkIF9feHNr
X21hcF9mbHVzaChzdHJ1Y3QgYnBmX21hcCAqbWFwKQ0KPiANCj4gc3RhdGljIHZvaWQgKnhza19t
YXBfbG9va3VwX2VsZW0oc3RydWN0IGJwZl9tYXAgKm1hcCwgdm9pZCAqa2V5KQ0KPiB7DQo+IC0J
cmV0dXJuIEVSUl9QVFIoLUVPUE5PVFNVUFApOw0KPiArCXN0cnVjdCB4ZHBfc29jayAqeHMgPSBf
X3hza19tYXBfbG9va3VwX2VsZW0obWFwLCAqKHUzMiAqKWtleSk7DQo+ICsNCj4gKwlyZXR1cm4g
eHMgPyAmeHMtPnF1ZXVlX2lkIDogTlVMTDsNCj4gfQ0KPiANCj4gc3RhdGljIGludCB4c2tfbWFw
X3VwZGF0ZV9lbGVtKHN0cnVjdCBicGZfbWFwICptYXAsIHZvaWQgKmtleSwgdm9pZCAqdmFsdWUs
DQo+IGRpZmYgLS1naXQgYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvdmVyaWZpZXIvcHJl
dmVudF9tYXBfbG9va3VwLmMgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvdmVyaWZpZXIv
cHJldmVudF9tYXBfbG9va3VwLmMNCj4gaW5kZXggYmJkYmE5OTBmZWZiLi5kYTdhNGIzN2NiOTgg
MTAwNjQ0DQo+IC0tLSBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi92ZXJpZmllci9wcmV2
ZW50X21hcF9sb29rdXAuYw0KPiArKysgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvdmVy
aWZpZXIvcHJldmVudF9tYXBfbG9va3VwLmMNCj4gQEAgLTI4LDIxICsyOCw2IEBADQo+IAkuZXJy
c3RyID0gImNhbm5vdCBwYXNzIG1hcF90eXBlIDE4IGludG8gZnVuYyBicGZfbWFwX2xvb2t1cF9l
bGVtIiwNCj4gCS5wcm9nX3R5cGUgPSBCUEZfUFJPR19UWVBFX1NPQ0tfT1BTLA0KPiB9LA0KPiAt
ew0KPiAtCSJwcmV2ZW50IG1hcCBsb29rdXAgaW4geHNrbWFwIiwNCj4gLQkuaW5zbnMgPSB7DQo+
IC0JQlBGX1NUX01FTShCUEZfRFcsIEJQRl9SRUdfMTAsIC04LCAwKSwNCj4gLQlCUEZfTU9WNjRf
UkVHKEJQRl9SRUdfMiwgQlBGX1JFR18xMCksDQo+IC0JQlBGX0FMVTY0X0lNTShCUEZfQURELCBC
UEZfUkVHXzIsIC04KSwNCj4gLQlCUEZfTERfTUFQX0ZEKEJQRl9SRUdfMSwgMCksDQo+IC0JQlBG
X1JBV19JTlNOKEJQRl9KTVAgfCBCUEZfQ0FMTCwgMCwgMCwgMCwgQlBGX0ZVTkNfbWFwX2xvb2t1
cF9lbGVtKSwNCj4gLQlCUEZfRVhJVF9JTlNOKCksDQo+IC0JfSwNCj4gLQkuZml4dXBfbWFwX3hz
a21hcCA9IHsgMyB9LA0KPiAtCS5yZXN1bHQgPSBSRUpFQ1QsDQo+IC0JLmVycnN0ciA9ICJjYW5u
b3QgcGFzcyBtYXBfdHlwZSAxNyBpbnRvIGZ1bmMgYnBmX21hcF9sb29rdXBfZWxlbSIsDQo+IC0J
LnByb2dfdHlwZSA9IEJQRl9QUk9HX1RZUEVfWERQLA0KPiAtfSwNCj4gew0KPiAJInByZXZlbnQg
bWFwIGxvb2t1cCBpbiBzdGFjayB0cmFjZSIsDQo+IAkuaW5zbnMgPSB7DQo+IC0tIA0KPiAyLjE3
LjENCj4gDQoNCg==
