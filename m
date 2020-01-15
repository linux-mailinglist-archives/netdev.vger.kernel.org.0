Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24A4113CF12
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 22:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729072AbgAOVbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 16:31:43 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:19930 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726310AbgAOVbm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 16:31:42 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00FLVLAC004781;
        Wed, 15 Jan 2020 13:31:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=CuRTVKT2BhryE/Yuy9nn0q9cGne6pbm5maJrUh4u09Q=;
 b=YvbiajBWxIDmAueMd12QE2J0Pvd3ilMMTavgvV5Gg2vYfHXy47Ee8ikoruoNROJTjeMD
 G9YDCXBHVxYuZxQq/+IzwOwrzbsHsCqypl8kvCshWvlehHLz75aVc9Au0MX9FbzoGRs+
 T7alLwDoGOdrQ2+s/QoFRyLM2ofCBHtKAqY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xhahpruur-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 15 Jan 2020 13:31:24 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 15 Jan 2020 13:30:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cUyIcqWamcLNiBZfK6E6FxV0Wv9wxR+XIMUwz1QNM7XMNEpIzz8bBSmAKiXLD+lpbhTk0Vcbo5pcQ9rCj1O6we2eX4U7J/iNK/lEZVFnNBWqy3/zHRabjWAqrbor0Ggy8FCswQ5BLyzjj9DBW+lRbY3oJY/52I4y9Fxvgr+qK4eASpB9YyFktpnYEf/MgOrKu3h1lyg/p9zWeSygumCI3Wmp+ybPIEB2vIW2krz3qJEzpqmmFhhfFHpBcwBEjs/tvx0cp0knzPBMQYGR4TGSOmjmSoZ0erowzQvE1tntkT+Q1eJbiT/8noonHhYPo3a5V/80DFEt1NpSr/GcqrtVTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CuRTVKT2BhryE/Yuy9nn0q9cGne6pbm5maJrUh4u09Q=;
 b=lY22PzZ+kG/GdJi0eWaeY7nXy5N6+T2SQDVNg5nd5N7+72N/rTQ7h2pMixVgKQyJeZ4UAGrJIpzLAmifOQs2iHF6Wh/JL2WO6XNayVdwARWsIvZxv9kq5B8jhkbFjZT763hWybBe9lb809hcenwgs3swDjFpeNP9H4V46q3q4SCNsZSQsJp762+zqNvoWH+4qGj7/b9r6ipEvvHhj7nrOfnparM8gaAUyU8MrhDq7EUunrUPLjlQa//RMoblJ9tndpKGgO5DJTwBogb2H43/Fb8yKknka9jPjXKTvGKmGVIAuBsQvUX8j8B53O/n/V5VkqQBxzLNJEcdPZA5J1DEVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CuRTVKT2BhryE/Yuy9nn0q9cGne6pbm5maJrUh4u09Q=;
 b=BCLOGSboYE5q4USsGGDGH6kJ2eNqae5+7yaxSKGA5fHAcmR9Tp+5X0eg11xlLmhV49VH2dYxApeI0SUHtGLkzcuoRtuF0g5c4eVCpCKrA1sSRpK8s7gCmEkUEJh7DKMukQaMWf1Gb3Sk+DowdYx4wo6RG2Gu0Cr23oVikjJRYmk=
Received: from DM6PR15MB3001.namprd15.prod.outlook.com (20.178.231.16) by
 DM6PR15MB2236.namprd15.prod.outlook.com (20.176.70.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.13; Wed, 15 Jan 2020 21:30:57 +0000
Received: from DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::1d74:b392:183e:c8c2]) by DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::1d74:b392:183e:c8c2%6]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 21:30:57 +0000
Received: from MacBook-Pro-52.local (2620:10d:c090:200::2:a3ec) by MWHPR20CA0001.namprd20.prod.outlook.com (2603:10b6:300:13d::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.19 via Frontend Transport; Wed, 15 Jan 2020 21:30:56 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        "ast@kernel.org" <ast@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "anatoly.trosinenko@gmail.com" <anatoly.trosinenko@gmail.com>
Subject: Re: [PATCH bpf] bpf: Fix incorrect verifier simulation of ARSH under
 ALU32
Thread-Topic: [PATCH bpf] bpf: Fix incorrect verifier simulation of ARSH under
 ALU32
Thread-Index: AQHVy+ULukuK5TcurkKC71vg/j4tz6fsPlcA
Date:   Wed, 15 Jan 2020 21:30:57 +0000
Message-ID: <51d3fb28-a9f9-1feb-74fb-9011ced98ffc@fb.com>
References: <20200115204733.16648-1-daniel@iogearbox.net>
In-Reply-To: <20200115204733.16648-1-daniel@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR20CA0001.namprd20.prod.outlook.com
 (2603:10b6:300:13d::11) To DM6PR15MB3001.namprd15.prod.outlook.com
 (2603:10b6:5:13c::16)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:a3ec]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 45952b36-6e91-47ab-c460-08d79a023531
x-ms-traffictypediagnostic: DM6PR15MB2236:
x-microsoft-antispam-prvs: <DM6PR15MB2236C8BE64C1B5C19519D23AD3370@DM6PR15MB2236.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(136003)(366004)(346002)(39860400002)(376002)(189003)(199004)(71200400001)(2616005)(5660300002)(2906002)(186003)(66946007)(110136005)(54906003)(8936002)(16526019)(66476007)(66446008)(316002)(66556008)(64756008)(6512007)(36756003)(86362001)(81156014)(52116002)(31686004)(6486002)(6506007)(53546011)(8676002)(4326008)(81166006)(478600001)(31696002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR15MB2236;H:DM6PR15MB3001.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5VOsWFK1+BQzXgN01a5hAs5ivmJEq8V11WBWu0pJeNIpjdaNL+AS/kZVDuY95F93Kl2XreR5/XhN6lbHVVOBTLBK5SKMrvcvNfj96dVw7G2UZLgWL3s61g5mcORRMZn9NwN6MYrpbdkWUCauouBQ/QB798SKLj/HKE9MQnjidO+T2cqaIU7eFkXX8bywHFo6GpvXZPK5GZSICk3Ne6F1otxnYYYt+9Aq3uptZkxYZ0iPsJP+6iA3KwYVLKcgx45cbSXKM2or8tIl4Dd/E9AwKw72vvrpmB0ivEEYdly2o4cOpTlYyWGouTHpxeExEXMBjfCssMmjhQSl1Ia8ldMDkeHAsdCjM+oA0SA1svXFhdvMw4PT2l7B2NEB3geI8RL8MRczZIRLqnouAu2WurrSLmuSItctQJu5SzN38DbkJ8yhhnCf1m3M6+7tiaa0kjaq
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <DC3D96395B67A84E9523E4DA23128319@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 45952b36-6e91-47ab-c460-08d79a023531
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 21:30:57.0789
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jy3v7stizSObNClBiVuCNuOL83XtkaxSvIdwJgfvgaHPAVVZayBoFpV/UjcWvH+L
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2236
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-15_03:2020-01-15,2020-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 bulkscore=0 mlxscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0
 mlxlogscore=999 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001150162
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEvMTUvMjAgMTI6NDcgUE0sIERhbmllbCBCb3JrbWFubiB3cm90ZToNCj4gQW5hdG9s
eSBoYXMgYmVlbiBmdXp6aW5nIHdpdGgga0JkeXNjaCBoYXJuZXNzIGFuZCByZXBvcnRlZCBhIGhh
bmcgaW4gb25lDQo+IG9mIHRoZSBvdXRjb21lczoNCj4gDQo+ICAgIDA6IFIxPWN0eChpZD0wLG9m
Zj0wLGltbT0wKSBSMTA9ZnAwDQo+ICAgIDA6ICg4NSkgY2FsbCBicGZfZ2V0X3NvY2tldF9jb29r
aWUjNDYNCj4gICAgMTogUjBfdz1pbnZQKGlkPTApIFIxMD1mcDANCj4gICAgMTogKDU3KSByMCAm
PSA4MDg0NjQ0MzINCj4gICAgMjogUjBfdz1pbnZQKGlkPTAsdW1heF92YWx1ZT04MDg0NjQ0MzIs
dmFyX29mZj0oMHgwOyAweDMwMzAzMDMwKSkgUjEwPWZwMA0KPiAgICAyOiAoMTQpIHcwIC09IDgx
MDI5OTQ0MA0KPiAgICAzOiBSMF93PWludlAoaWQ9MCx1bWF4X3ZhbHVlPTQyOTQ5NjcyOTUsdmFy
X29mZj0oMHhjZjgwMDAwMDsgMHgzMDc3ZmZmMCkpIFIxMD1mcDANCj4gICAgMzogKGM0KSB3MCBz
Pj49IDENCj4gICAgNDogUjBfdz1pbnZQKGlkPTAsdW1pbl92YWx1ZT0xNzQwNjM2MTYwLHVtYXhf
dmFsdWU9MjE0NzIyMTQ5Nix2YXJfb2ZmPSgweDY3YzAwMDAwOyAweDE4M2JmZmY4KSkgUjEwPWZw
MA0KPiAgICA0OiAoNzYpIGlmIHcwIHM+PSAweDMwMzAzMDMwIGdvdG8gcGMrMjE2DQo+ICAgIDIy
MTogUjBfdz1pbnZQKGlkPTAsdW1pbl92YWx1ZT0xNzQwNjM2MTYwLHVtYXhfdmFsdWU9MjE0NzIy
MTQ5Nix2YXJfb2ZmPSgweDY3YzAwMDAwOyAweDE4M2JmZmY4KSkgUjEwPWZwMA0KPiAgICAyMjE6
ICg5NSkgZXhpdA0KPiAgICBwcm9jZXNzZWQgNiBpbnNucyAobGltaXQgMTAwMDAwMCkgWy4uLl0N
Cj4gDQo+IFRha2luZyBhIGNsb3NlciBsb29rLCB0aGUgcHJvZ3JhbSB3YXMgeGxhdGVkIGFzIGZv
bGxvd3M6DQo+IA0KPiAgICAjIC4vYnBmdG9vbCBwIGQgeCBpIDEyDQo+ICAgIDA6ICg4NSkgY2Fs
bCBicGZfZ2V0X3NvY2tldF9jb29raWUjNzgwMDg5Ng0KPiAgICAxOiAoYmYpIHI2ID0gcjANCj4g
ICAgMjogKDU3KSByNiAmPSA4MDg0NjQ0MzINCj4gICAgMzogKDE0KSB3NiAtPSA4MTAyOTk0NDAN
Cj4gICAgNDogKGM0KSB3NiBzPj49IDENCj4gICAgNTogKDc2KSBpZiB3NiBzPj0gMHgzMDMwMzAz
MCBnb3RvIHBjKzIxNg0KPiAgICA2OiAoMDUpIGdvdG8gcGMtMQ0KPiAgICA3OiAoMDUpIGdvdG8g
cGMtMQ0KPiAgICA4OiAoMDUpIGdvdG8gcGMtMQ0KPiAgICBbLi4uXQ0KPiAgICAyMjA6ICgwNSkg
Z290byBwYy0xDQo+ICAgIDIyMTogKDA1KSBnb3RvIHBjLTENCj4gICAgMjIyOiAoOTUpIGV4aXQN
Cj4gDQo+IE1lYW5pbmcsIHRoZSB2aXNpYmxlIGVmZmVjdCBpcyB2ZXJ5IHNpbWlsYXIgdG8gZjU0
Yzc4OThlZDFjICgiYnBmOiBGaXgNCj4gcHJlY2lzaW9uIHRyYWNraW5nIGZvciB1bmJvdW5kZWQg
c2NhbGFycyIpLCB0aGF0IGlzLCB0aGUgZmFsbC10aHJvdWdoDQo+IGJyYW5jaCBpbiB0aGUgaW5z
dHJ1Y3Rpb24gNSBpcyBjb25zaWRlcmVkIHRvIGJlIG5ldmVyIHRha2VuIGdpdmVuIHRoZQ0KPiBj
b25jbHVzaW9uIGZyb20gdGhlIG1pbi9tYXggYm91bmRzIHRyYWNraW5nIGluIHc2LCBhbmQgdGhl
cmVmb3JlIHRoZQ0KPiBkZWFkLWNvZGUgc2FuaXRhdGlvbiByZXdyaXRlcyBpdCBhcyBnb3RvIHBj
LTEuIEhvd2V2ZXIsIHJlYWwtbGlmZSBpbnB1dA0KPiBkaXNhZ3JlZXMgd2l0aCB2ZXJpZmljYXRp
b24gYW5hbHlzaXMgc2luY2UgYSBzb2Z0LWxvY2t1cCB3YXMgb2JzZXJ2ZWQuDQo+IA0KPiBUaGUg
YnVnIHNpdHMgaW4gdGhlIGFuYWx5c2lzIG9mIHRoZSBBUlNILiBUaGUgZGVmaW5pdGlvbiBpcyB0
aGF0IHdlIHNoaWZ0DQo+IHRoZSB0YXJnZXQgcmVnaXN0ZXIgdmFsdWUgcmlnaHQgYnkgSyBiaXRz
IHRocm91Z2ggc2hpZnRpbmcgaW4gY29waWVzIG9mDQo+IGl0cyBzaWduIGJpdC4gSW4gYWRqdXN0
X3NjYWxhcl9taW5fbWF4X3ZhbHMoKSwgd2UgZG8gZmlyc3QgY29lcmNlIHRoZQ0KPiByZWdpc3Rl
ciBpbnRvIDMyIGJpdCBtb2RlLCBzYW1lIGhhcHBlbnMgYWZ0ZXIgc2ltdWxhdGluZyB0aGUgb3Bl
cmF0aW9uLg0KPiBIb3dldmVyLCBmb3IgdGhlIGNhc2Ugb2Ygc2ltdWxhdGluZyB0aGUgYWN0dWFs
IEFSU0gsIHdlIGRvbid0IHRha2UgdGhlDQo+IG1vZGUgaW50byBhY2NvdW50IGFuZCBhY3QgYXMg
aWYgaXQncyBhbHdheXMgNjQgYml0LCBidXQgbG9jYXRpb24gb2Ygc2lnbg0KPiBiaXQgaXMgZGlm
ZmVyZW50Og0KPiANCj4gICAgZHN0X3JlZy0+c21pbl92YWx1ZSA+Pj0gdW1pbl92YWw7DQo+ICAg
IGRzdF9yZWctPnNtYXhfdmFsdWUgPj49IHVtaW5fdmFsOw0KPiAgICBkc3RfcmVnLT52YXJfb2Zm
ID0gdG51bV9hcnNoaWZ0KGRzdF9yZWctPnZhcl9vZmYsIHVtaW5fdmFsKTsNCj4gDQo+IENvbnNp
ZGVyIGFuIHVua25vd24gUjAgd2hlcmUgYnBmX2dldF9zb2NrZXRfY29va2llKCkgKG9yIG90aGVy
cykgd291bGQNCj4gZm9yIGV4YW1wbGUgcmV0dXJuIDB4ZmZmZi4gV2l0aCB0aGUgYWJvdmUgQVJT
SCBzaW11bGF0aW9uLCB3ZSdkIHNlZSB0aGUNCj4gZm9sbG93aW5nIHJlc3VsdHM6DQo+IA0KPiAg
ICBbLi4uXQ0KPiAgICAxOiBSMT1jdHgoaWQ9MCxvZmY9MCxpbW09MCkgUjJfdz1pbnZQNjU1MzUg
UjEwPWZwMA0KPiAgICAxOiAoODUpIGNhbGwgYnBmX2dldF9zb2NrZXRfY29va2llIzQ2DQo+ICAg
IDI6IFIwX3c9aW52UChpZD0wKSBSMTA9ZnAwDQo+ICAgIDI6ICg1NykgcjAgJj0gODA4NDY0NDMy
DQo+ICAgICAgLT4gUjBfcnVudGltZSA9IDB4MzAzMA0KPiAgICAzOiBSMF93PWludlAoaWQ9MCx1
bWF4X3ZhbHVlPTgwODQ2NDQzMix2YXJfb2ZmPSgweDA7IDB4MzAzMDMwMzApKSBSMTA9ZnAwDQo+
ICAgIDM6ICgxNCkgdzAgLT0gODEwMjk5NDQwDQo+ICAgICAgLT4gUjBfcnVudGltZSA9IDB4Y2Zi
NDAwMDANCj4gICAgNDogUjBfdz1pbnZQKGlkPTAsdW1heF92YWx1ZT00Mjk0OTY3Mjk1LHZhcl9v
ZmY9KDB4Y2Y4MDAwMDA7IDB4MzA3N2ZmZjApKSBSMTA9ZnAwDQo+ICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAoMHhmZmZmZmZmZikNCj4gICAgNDogKGM0KSB3MCBzPj49IDENCj4gICAg
ICAtPiBSMF9ydW50aW1lID0gMHhlN2RhMDAwMA0KPiAgICA1OiBSMF93PWludlAoaWQ9MCx1bWlu
X3ZhbHVlPTE3NDA2MzYxNjAsdW1heF92YWx1ZT0yMTQ3MjIxNDk2LHZhcl9vZmY9KDB4NjdjMDAw
MDA7IDB4MTgzYmZmZjgpKSBSMTA9ZnAwDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAoMHg2N2MwMDAwMCkgICAgICAgICAgICgweDdmZmJmZmY4KQ0KPiAgICBbLi4uXQ0KPiANCj4g
SW4gaW5zbiAzLCB3ZSBoYXZlIGEgcnVudGltZSB2YWx1ZSBvZiAweGNmYjQwMDAwLCB3aGljaCBp
cyAnMTEwMCAxMTExIDEwMTENCj4gMDEwMCAwMDAwIDAwMDAgMDAwMCAwMDAwJywgdGhlIHJlc3Vs
dCBhZnRlciB0aGUgc2hpZnQgaGFzIDB4ZTdkYTAwMDAgdGhhdA0KPiBpcyAnMTExMCAwMTExIDEx
MDEgMTAxMCAwMDAwIDAwMDAgMDAwMCAwMDAwJywgd2hlcmUgdGhlIHNpZ24gYml0IGlzIGNvcnJl
Y3RseQ0KPiByZXRhaW5lZCBpbiAzMiBiaXQgbW9kZS4gSW4gaW5zbjQsIHRoZSB1bWF4IHdhcyAw
eGZmZmZmZmZmLCBhbmQgY2hhbmdlZCBpbnRvDQo+IDB4N2ZmYmZmZjggYWZ0ZXIgdGhlIHNoaWZ0
LCB0aGF0IGlzLCAnMDExMSAxMTExIDExMTEgMTAxMSAxMTExIDExMTEgMTExMSAxMDAwJw0KPiBh
bmQgbWVhbnMgaGVyZSB0aGF0IHRoZSBzaW11bGF0aW9uIGRpZG4ndCByZXRhaW4gdGhlIHNpZ24g
Yml0LiBXaXRoIGFib3ZlDQo+IGxvZ2ljLCB0aGUgdXBkYXRlcyBoYXBwZW4gb24gdGhlIDY0IGJp
dCBtaW4vbWF4IGJvdW5kcyBhbmQgZ2l2ZW4gd2UgY29lcmNlZA0KPiB0aGUgcmVnaXN0ZXIsIHRo
ZSBzaWduIGJpdHMgb2YgdGhlIGJvdW5kcyBhcmUgY2xlYXJlZCBhcyB3ZWxsLCBtZWFuaW5nLCB3
ZQ0KPiBuZWVkIHRvIGZvcmNlIHRoZSBzaW11bGF0aW9uIGludG8gczMyIHNwYWNlIGZvciAzMiBi
aXQgYWx1IG1vZGUuDQo+IA0KPiBWZXJpZmljYXRpb24gYWZ0ZXIgdGhlIGZpeCBiZWxvdy4gV2Un
cmUgZmlyc3QgYW5hbHl6aW5nIHRoZSBmYWxsLXRocm91Z2ggYnJhbmNoDQo+IG9uIDMyIGJpdCBz
aWduZWQgPj0gdGVzdCBldmVudHVhbGx5IGxlYWRpbmcgdG8gcmVqZWN0aW9uIG9mIHRoZSBwcm9n
cmFtIGluIHRoaXMNCj4gc3BlY2lmaWMgY2FzZToNCj4gDQo+ICAgIDA6IFIxPWN0eChpZD0wLG9m
Zj0wLGltbT0wKSBSMTA9ZnAwDQo+ICAgIDA6IChiNykgcjIgPSA4MDg0NjQ0MzINCj4gICAgMTog
UjE9Y3R4KGlkPTAsb2ZmPTAsaW1tPTApIFIyX3c9aW52UDgwODQ2NDQzMiBSMTA9ZnAwDQo+ICAg
IDE6ICg4NSkgY2FsbCBicGZfZ2V0X3NvY2tldF9jb29raWUjNDYNCj4gICAgMjogUjBfdz1pbnZQ
KGlkPTApIFIxMD1mcDANCj4gICAgMjogKGJmKSByNiA9IHIwDQo+ICAgIDM6IFIwX3c9aW52UChp
ZD0wKSBSNl93PWludlAoaWQ9MCkgUjEwPWZwMA0KPiAgICAzOiAoNTcpIHI2ICY9IDgwODQ2NDQz
Mg0KPiAgICA0OiBSMF93PWludlAoaWQ9MCkgUjZfdz1pbnZQKGlkPTAsdW1heF92YWx1ZT04MDg0
NjQ0MzIsdmFyX29mZj0oMHgwOyAweDMwMzAzMDMwKSkgUjEwPWZwMA0KPiAgICA0OiAoMTQpIHc2
IC09IDgxMDI5OTQ0MA0KPiAgICA1OiBSMF93PWludlAoaWQ9MCkgUjZfdz1pbnZQKGlkPTAsdW1h
eF92YWx1ZT00Mjk0OTY3Mjk1LHZhcl9vZmY9KDB4Y2Y4MDAwMDA7IDB4MzA3N2ZmZjApKSBSMTA9
ZnAwDQo+ICAgIDU6IChjNCkgdzYgcz4+PSAxDQo+ICAgIDY6IFIwX3c9aW52UChpZD0wKSBSNl93
PWludlAoaWQ9MCx1bWluX3ZhbHVlPTM4ODgxMTk4MDgsdW1heF92YWx1ZT00Mjk0NzA1MTQ0LHZh
cl9vZmY9KDB4ZTdjMDAwMDA7IDB4MTgzYmZmZjgpKSBSMTA9ZnAwDQo+ICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKDB4NjdjMDAwMDApICAgICAgICAgICgw
eGZmZmJmZmY4KQ0KPiAgICA2OiAoNzYpIGlmIHc2IHM+PSAweDMwMzAzMDMwIGdvdG8gcGMrMjE2
DQo+ICAgIDc6IFIwX3c9aW52UChpZD0wKSBSNl93PWludlAoaWQ9MCx1bWluX3ZhbHVlPTM4ODgx
MTk4MDgsdW1heF92YWx1ZT00Mjk0NzA1MTQ0LHZhcl9vZmY9KDB4ZTdjMDAwMDA7IDB4MTgzYmZm
ZjgpKSBSMTA9ZnAwDQo+ICAgIDc6ICgzMCkgcjAgPSAqKHU4ICopc2tiWzgwODQ2NDQzMl0NCj4g
ICAgQlBGX0xEX1tBQlN8SU5EXSB1c2VzIHJlc2VydmVkIGZpZWxkcw0KPiAgICBwcm9jZXNzZWQg
OCBpbnNucyAobGltaXQgMTAwMDAwMCkgWy4uLl0NCj4gDQo+IEZpeGVzOiA5Y2JlMWY1YTMyZGMg
KCJicGYvdmVyaWZpZXI6IGltcHJvdmUgcmVnaXN0ZXIgdmFsdWUgcmFuZ2UgdHJhY2tpbmcgd2l0
aCBBUlNIIikNCj4gUmVwb3J0ZWQtYnk6IEFuYXRvbHkgVHJvc2luZW5rbyA8YW5hdG9seS50cm9z
aW5lbmtvQGdtYWlsLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogRGFuaWVsIEJvcmttYW5uIDxkYW5p
ZWxAaW9nZWFyYm94Lm5ldD4NCg0KQWNrZWQtYnk6IFlvbmdob25nIFNvbmcgPHloc0BmYi5jb20+
DQo=
