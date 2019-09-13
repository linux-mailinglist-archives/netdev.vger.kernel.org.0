Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A181B287F
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 00:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404113AbfIMWe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 18:34:26 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38420 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404024AbfIMWe0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 18:34:26 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8DMSDK7028956;
        Fri, 13 Sep 2019 15:34:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=7EESWK+OA6ADxKsgRL1Wn8zN9KmYMLP41i/tQH4i+vI=;
 b=RmZf9mJ8uVzZQqQEUS7bymnf4cm8NehCk+ivsI5w3TZFpoutQHMPvcgq8fUs1pk3gfjR
 k+GCwQv5vrOq6bFUUNi567oTD7fG4hCYCsKlxHjacQNk/QqRYrK0f5zh1t2OoaKRPHya
 n4A5gjim2qg7/6UQBNIkJ0KFtR0hnrlzzb0= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2v0ehf1jjx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 13 Sep 2019 15:34:04 -0700
Received: from prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 13 Sep 2019 15:34:03 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 13 Sep 2019 15:34:03 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 13 Sep 2019 15:34:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O1IkSEJkvjWNhLqWRIOEbddZdbkgiA+16+U4KxJznlIM7FOEBPYRKqykNKLSGJSV4uAU8vQ/Q8fZgO/m3lHWBOiw54Z90PUD2jocVoTRMYHxRw9ku5IVbr9tetb45WkzjxPVKYmJAVHJjCVAO0vYWwBihaMlBMaToHSSEc5Wb2oC5dGY1guSN+QS3PEfmtaE/JT8AgklFQU9cy05wT/Q9k9i8/GiSmNXLgAWEbyNShqiysyVrC/GW0bqg4ytCNkuLePzn+M0yMqFF1rTzETPEzm+lovp58A6TIMdhCYwILSECy/7RUTnE7AnXC+iE/hCLcKlWnN7NX2jjqP7NO/YRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7EESWK+OA6ADxKsgRL1Wn8zN9KmYMLP41i/tQH4i+vI=;
 b=FmmW0fGEetGmB/25gdxVrfWkNdh2iSQAJW8fw6p6ygVpkyAWrPQ2viaLcweG/w9EbC3LN+jLqDO4IU6mL3XZlAZgCh3h+otSx7ahQQ+NCPiEjM/UvX4afOxfCqUe2uQVrt5BG4EcnqPVHzpAMVKanSbG5S5Y396M821p3vXUfNpmrfJ/3D6rFmNIm4bCeSRVUJHREhSTR01o54QgHCGiNWlrJG72NvsMgrrjALmgE73kWhKX0+HA6iC2ONxvd5AfwsLSZwk4rciANxmvM6iNyPt+3NegTaM3GdPWvJek0C9RATKWie/rttGKiRE2kYZzG5EvssCJOUN/HqyfrFbA0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7EESWK+OA6ADxKsgRL1Wn8zN9KmYMLP41i/tQH4i+vI=;
 b=hUhI50hkIAEjDX5GXUWxw/6jOEwBCS6rYFDPcuWJFG30nHAN8TyLKXlqAtmR2qv1qkUvGjIMUi8IZoSqAZWFq+WEvVRMmbYaAaxm1BiGOw9v0bKQD3j0D5KMapuEuil9VAJCNswbvyQeuuCaJpLbXHwUsDoISTnUxCk4MZyDems=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB2455.namprd15.prod.outlook.com (52.135.200.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.13; Fri, 13 Sep 2019 22:34:02 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::95ab:61a0:29f4:e07e]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::95ab:61a0:29f4:e07e%6]) with mapi id 15.20.2263.021; Fri, 13 Sep 2019
 22:34:02 +0000
From:   Yonghong Song <yhs@fb.com>
To:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [bpf-next,v3] samples: bpf: add max_pckt_size option at
 xdp_adjust_tail
Thread-Topic: [bpf-next,v3] samples: bpf: add max_pckt_size option at
 xdp_adjust_tail
Thread-Index: AQHVaNOf96MRv7ORO0C6o+lo0/yYAacqNQSA
Date:   Fri, 13 Sep 2019 22:34:02 +0000
Message-ID: <7add91c8-a22c-f10e-76a4-495d8be09c9b@fb.com>
References: <20190911190218.22628-1-danieltimlee@gmail.com>
In-Reply-To: <20190911190218.22628-1-danieltimlee@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR19CA0018.namprd19.prod.outlook.com
 (2603:10b6:300:d4::28) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::ec5b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4d13de45-e034-4e24-2973-08d7389a7a43
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2455;
x-ms-traffictypediagnostic: BYAPR15MB2455:
x-microsoft-antispam-prvs: <BYAPR15MB2455A68B5F04E69DDCF5B023D3B30@BYAPR15MB2455.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1468;
x-forefront-prvs: 0159AC2B97
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(39860400002)(346002)(136003)(376002)(366004)(189003)(199004)(46003)(6116002)(66446008)(486006)(36756003)(25786009)(6246003)(53936002)(6512007)(66476007)(2906002)(14454004)(53546011)(6506007)(102836004)(66946007)(71190400001)(4326008)(64756008)(66556008)(14444005)(256004)(386003)(186003)(71200400001)(305945005)(316002)(8936002)(476003)(8676002)(31696002)(99286004)(31686004)(110136005)(478600001)(86362001)(7736002)(54906003)(2616005)(11346002)(6436002)(52116002)(81156014)(229853002)(81166006)(5660300002)(6486002)(76176011)(446003)(142933001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2455;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0Vbu2Capyd2RR6VO5kWybZCbCoJcmaff96vdZzNpX8RMBqOatzxmDNUPFpGlIBAEzhjo7kKc2ezpbpnEs+0On4s0ekb/HXAKoYkLQQpRM5yaOO66UpKUY8ze5kZNsVRLSrXv4amOlcCmMSesJRmYBXPS9EmSD1vY66kRrcho6QHxp+TqdR1IE7UHxtoXDon990k8m4KTWPWlmO7R9jGMA9KvnNihSyRN6LEZKAxT49YOanKYDWgKDxHkwGt1V8NcIUf33nCwbI064MKsVgvIA0Ya95QdMPnXyaUePMZyNK1PpP+WyYl2tiT46w7BvlQ8CxsXL1g+iP1CM7mIa+tFUoO2UBGc+6ZZtiWyS94ZqLEBs5yZrYQ8EB/lGmZnodrF1/cn/ZdlGGgEXDoXt7QlRYuG3rSOiKnMxhWznkAhJWA=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <DEC8A07313838547934D509C25F686F0@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d13de45-e034-4e24-2973-08d7389a7a43
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2019 22:34:02.5674
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WXhwy9XDcyCifWRHgSBsHI34MKBrI+xooEb0IDvJGndTYGLLZyug/BkQetrl3kfd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2455
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-13_10:2019-09-11,2019-09-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 lowpriorityscore=0 mlxlogscore=999 impostorscore=0 clxscore=1015
 malwarescore=0 phishscore=0 spamscore=0 priorityscore=1501 bulkscore=0
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909130220
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDkvMTEvMTkgODowMiBQTSwgRGFuaWVsIFQuIExlZSB3cm90ZToNCj4gQ3VycmVudGx5
LCBhdCB4ZHBfYWRqdXN0X3RhaWxfa2Vybi5jLCBNQVhfUENLVF9TSVpFIGlzIGxpbWl0ZWQNCj4g
dG8gNjAwLiBUbyBtYWtlIHRoaXMgc2l6ZSBmbGV4aWJsZSwgYSBuZXcgbWFwICdwY2t0c3onIGlz
IGFkZGVkLg0KPiANCj4gQnkgdXBkYXRpbmcgbmV3IHBhY2tldCBzaXplIHRvIHRoaXMgbWFwIGZy
b20gdGhlIHVzZXJsYW5kLA0KPiB4ZHBfYWRqdXN0X3RhaWxfa2Vybi5vIHdpbGwgdXNlIHRoaXMg
dmFsdWUgYXMgYSBuZXcgbWF4X3Bja3Rfc2l6ZS4NCj4gDQo+IElmIG5vICctUCA8TUFYX1BDS1Rf
U0laRT4nIG9wdGlvbiBpcyB1c2VkLCB0aGUgc2l6ZSBvZiBtYXhpbXVtIHBhY2tldA0KPiB3aWxs
IGJlIDYwMCBhcyBhIGRlZmF1bHQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBEYW5pZWwgVC4gTGVl
IDxkYW5pZWx0aW1sZWVAZ21haWwuY29tPg0KPiANCj4gLS0tDQo+IENoYW5nZXMgaW4gdjI6DQo+
ICAgICAgLSBDaGFuZ2UgdGhlIGhlbHBlciB0byBmZXRjaCBtYXAgZnJvbSAnYnBmX21hcF9fbmV4
dCcgdG8NCj4gICAgICAnYnBmX29iamVjdF9fZmluZF9tYXBfZmRfYnlfbmFtZScuDQo+ICAgDQo+
ICAgc2FtcGxlcy9icGYveGRwX2FkanVzdF90YWlsX2tlcm4uYyB8IDIzICsrKysrKysrKysrKysr
KysrKystLS0tDQo+ICAgc2FtcGxlcy9icGYveGRwX2FkanVzdF90YWlsX3VzZXIuYyB8IDI4ICsr
KysrKysrKysrKysrKysrKysrKystLS0tLS0NCj4gICAyIGZpbGVzIGNoYW5nZWQsIDQxIGluc2Vy
dGlvbnMoKyksIDEwIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL3NhbXBsZXMvYnBm
L3hkcF9hZGp1c3RfdGFpbF9rZXJuLmMgYi9zYW1wbGVzL2JwZi94ZHBfYWRqdXN0X3RhaWxfa2Vy
bi5jDQo+IGluZGV4IDQxMWZkYjIxZjhiYy4uZDZkODRmZmU2YTdhIDEwMDY0NA0KPiAtLS0gYS9z
YW1wbGVzL2JwZi94ZHBfYWRqdXN0X3RhaWxfa2Vybi5jDQo+ICsrKyBiL3NhbXBsZXMvYnBmL3hk
cF9hZGp1c3RfdGFpbF9rZXJuLmMNCj4gQEAgLTI1LDYgKzI1LDEzIEBADQo+ICAgI2RlZmluZSBJ
Q01QX1RPT0JJR19TSVpFIDk4DQo+ICAgI2RlZmluZSBJQ01QX1RPT0JJR19QQVlMT0FEX1NJWkUg
OTINCj4gICANCj4gK3N0cnVjdCBicGZfbWFwX2RlZiBTRUMoIm1hcHMiKSBwY2t0c3ogPSB7DQo+
ICsJLnR5cGUgPSBCUEZfTUFQX1RZUEVfQVJSQVksDQo+ICsJLmtleV9zaXplID0gc2l6ZW9mKF9f
dTMyKSwNCj4gKwkudmFsdWVfc2l6ZSA9IHNpemVvZihfX3UzMiksDQo+ICsJLm1heF9lbnRyaWVz
ID0gMSwNCj4gK307DQoNCldlIGhhdmUgbmV3IG1hcCBkZWZpbml0aW9uIGZvcm1hdCBsaWtlIGlu
DQp0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ3MvYnBmX2Zsb3cuYy4NCkJ1dCBsb29r
cyBsaWtlIG1vc3Qgc2FtcGxlcy9icGYgc3RpbGwgdXNlIFNFQygibWFwcyIpLg0KSSBndWVzcyB3
ZSBjYW4gbGVhdmUgaXQgZm9yIG5vdywgYW5kIGlmIG5lZWRlZCwNCmxhdGVyIG9uIGEgbWFzc2l2
ZSBjb252ZXJzaW9uIGZvciBhbGwgc2FtcGxlcy9icGYvDQpicGYgcHJvZ3JhbXMgY2FuIGJlIGRv
bmUuDQoNCj4gKw0KPiAgIHN0cnVjdCBicGZfbWFwX2RlZiBTRUMoIm1hcHMiKSBpY21wY250ID0g
ew0KPiAgIAkudHlwZSA9IEJQRl9NQVBfVFlQRV9BUlJBWSwNCj4gICAJLmtleV9zaXplID0gc2l6
ZW9mKF9fdTMyKSwNCj4gQEAgLTY0LDcgKzcxLDggQEAgc3RhdGljIF9fYWx3YXlzX2lubGluZSB2
b2lkIGlwdjRfY3N1bSh2b2lkICpkYXRhX3N0YXJ0LCBpbnQgZGF0YV9zaXplLA0KPiAgIAkqY3N1
bSA9IGNzdW1fZm9sZF9oZWxwZXIoKmNzdW0pOw0KPiAgIH0NCj4gICANCj4gLXN0YXRpYyBfX2Fs
d2F5c19pbmxpbmUgaW50IHNlbmRfaWNtcDRfdG9vX2JpZyhzdHJ1Y3QgeGRwX21kICp4ZHApDQo+
ICtzdGF0aWMgX19hbHdheXNfaW5saW5lIGludCBzZW5kX2ljbXA0X3Rvb19iaWcoc3RydWN0IHhk
cF9tZCAqeGRwLA0KPiArCQkJCQkgICAgICBfX3UzMiBtYXhfcGNrdF9zaXplKQ0KPiAgIHsNCj4g
ICAJaW50IGhlYWRyb29tID0gKGludClzaXplb2Yoc3RydWN0IGlwaGRyKSArIChpbnQpc2l6ZW9m
KHN0cnVjdCBpY21waGRyKTsNCj4gICANCj4gQEAgLTkyLDcgKzEwMCw3IEBAIHN0YXRpYyBfX2Fs
d2F5c19pbmxpbmUgaW50IHNlbmRfaWNtcDRfdG9vX2JpZyhzdHJ1Y3QgeGRwX21kICp4ZHApDQo+
ICAgCW9yaWdfaXBoID0gZGF0YSArIG9mZjsNCj4gICAJaWNtcF9oZHItPnR5cGUgPSBJQ01QX0RF
U1RfVU5SRUFDSDsNCj4gICAJaWNtcF9oZHItPmNvZGUgPSBJQ01QX0ZSQUdfTkVFREVEOw0KPiAt
CWljbXBfaGRyLT51bi5mcmFnLm10dSA9IGh0b25zKE1BWF9QQ0tUX1NJWkUtc2l6ZW9mKHN0cnVj
dCBldGhoZHIpKTsNCj4gKwlpY21wX2hkci0+dW4uZnJhZy5tdHUgPSBodG9ucyhtYXhfcGNrdF9z
aXplIC0gc2l6ZW9mKHN0cnVjdCBldGhoZHIpKTsNCj4gICAJaWNtcF9oZHItPmNoZWNrc3VtID0g
MDsNCj4gICAJaXB2NF9jc3VtKGljbXBfaGRyLCBJQ01QX1RPT0JJR19QQVlMT0FEX1NJWkUsICZj
c3VtKTsNCj4gICAJaWNtcF9oZHItPmNoZWNrc3VtID0gY3N1bTsNCj4gQEAgLTExOCwxNCArMTI2
LDIxIEBAIHN0YXRpYyBfX2Fsd2F5c19pbmxpbmUgaW50IGhhbmRsZV9pcHY0KHN0cnVjdCB4ZHBf
bWQgKnhkcCkNCj4gICB7DQo+ICAgCXZvaWQgKmRhdGFfZW5kID0gKHZvaWQgKikobG9uZyl4ZHAt
PmRhdGFfZW5kOw0KPiAgIAl2b2lkICpkYXRhID0gKHZvaWQgKikobG9uZyl4ZHAtPmRhdGE7DQo+
ICsJX191MzIgbWF4X3Bja3Rfc2l6ZSA9IE1BWF9QQ0tUX1NJWkU7DQo+ICsJX191MzIgKnBja3Rf
c3o7DQo+ICsJX191MzIga2V5ID0gMDsNCg0KVGhlIGFib3ZlIHR3byBuZXcgZGVmaW5pdGlvbnMg
bWF5IHRoZSBjb2RlIG5vdCBpbg0KcmV2ZXJzZSBDaHJpc3RtYXMgZGVmaW5pdGlvbiBvcmRlciwg
Y291bGQgeW91IGZpeCBpdD8NCg0KPiAgIAlpbnQgcGNrdF9zaXplID0gZGF0YV9lbmQgLSBkYXRh
Ow0KPiAgIAlpbnQgb2Zmc2V0Ow0KPiAgIA0KPiAtCWlmIChwY2t0X3NpemUgPiBNQVhfUENLVF9T
SVpFKSB7DQo+ICsJcGNrdF9zeiA9IGJwZl9tYXBfbG9va3VwX2VsZW0oJnBja3RzeiwgJmtleSk7
DQo+ICsJaWYgKHBja3Rfc3ogJiYgKnBja3Rfc3opDQo+ICsJCW1heF9wY2t0X3NpemUgPSAqcGNr
dF9zejsNCj4gKw0KPiArCWlmIChwY2t0X3NpemUgPiBtYXhfcGNrdF9zaXplKSB7DQo+ICAgCQlv
ZmZzZXQgPSBwY2t0X3NpemUgLSBJQ01QX1RPT0JJR19TSVpFOw0KPiAgIAkJaWYgKGJwZl94ZHBf
YWRqdXN0X3RhaWwoeGRwLCAwIC0gb2Zmc2V0KSkNCj4gICAJCQlyZXR1cm4gWERQX1BBU1M7DQoN
CldlIGNvdWxkIGhhdmUgdGhlIGZvbGxvd2luZyBzY2VuYXJpbzoNCiAgIG1heF9wY2t0X3NpemUg
PSAxDQogICBwY2t0X3NpemUgPSAyDQogICBvZmZzZXQgPSAtOTYNCiAgIGJwZl94ZHBfYWRqdXN0
X3RhaWwgcmV0dXJuIC1FSU5WQUwNCiAgIHNvIHdlIHJldHVybiBYRFBfUEFTUyBub3cNCg0KTWF5
YmUgeW91IHdhbnQgdG8gZG8NCiAgICBpZiAocGNrdF9zaXplID4gbWF4KG1heF9wY2t0X3NpemUs
IElDTVBfVE9PQklHX1NJWkUpKSB7DQogICAgICAgLi4uDQogICAgfQ0KYXMgaW4gb3JpZ2luYWwg
Y29kZSwgYnBmX3hkcF9hZGp1c3RfdGFpbCguLi4pIGFscmVhZHkgc3VjY2VlZHMuDQoNCj4gLQkJ
cmV0dXJuIHNlbmRfaWNtcDRfdG9vX2JpZyh4ZHApOw0KPiArCQlyZXR1cm4gc2VuZF9pY21wNF90
b29fYmlnKHhkcCwgbWF4X3Bja3Rfc2l6ZSk7DQo+ICAgCX0NCj4gICAJcmV0dXJuIFhEUF9QQVNT
Ow0KPiAgIH0NCj4gZGlmZiAtLWdpdCBhL3NhbXBsZXMvYnBmL3hkcF9hZGp1c3RfdGFpbF91c2Vy
LmMgYi9zYW1wbGVzL2JwZi94ZHBfYWRqdXN0X3RhaWxfdXNlci5jDQo+IGluZGV4IGEzNTk2YjYx
N2M0Yy4uYWVmNmM2OWE0OGE3IDEwMDY0NA0KPiAtLS0gYS9zYW1wbGVzL2JwZi94ZHBfYWRqdXN0
X3RhaWxfdXNlci5jDQo+ICsrKyBiL3NhbXBsZXMvYnBmL3hkcF9hZGp1c3RfdGFpbF91c2VyLmMN
Cj4gQEAgLTIzLDYgKzIzLDcgQEANCj4gICAjaW5jbHVkZSAibGliYnBmLmgiDQo+ICAgDQo+ICAg
I2RlZmluZSBTVEFUU19JTlRFUlZBTF9TIDJVDQo+ICsjZGVmaW5lIE1BWF9QQ0tUX1NJWkUgNjAw
DQo+ICAgDQo+ICAgc3RhdGljIGludCBpZmluZGV4ID0gLTE7DQo+ICAgc3RhdGljIF9fdTMyIHhk
cF9mbGFncyA9IFhEUF9GTEFHU19VUERBVEVfSUZfTk9FWElTVDsNCj4gQEAgLTcyLDYgKzczLDcg
QEAgc3RhdGljIHZvaWQgdXNhZ2UoY29uc3QgY2hhciAqY21kKQ0KPiAgIAlwcmludGYoIlVzYWdl
OiAlcyBbLi4uXVxuIiwgY21kKTsNCj4gICAJcHJpbnRmKCIgICAgLWkgPGlmbmFtZXxpZmluZGV4
PiBJbnRlcmZhY2VcbiIpOw0KPiAgIAlwcmludGYoIiAgICAtVCA8c3RvcC1hZnRlci1YLXNlY29u
ZHM+IERlZmF1bHQ6IDAgKGZvcmV2ZXIpXG4iKTsNCj4gKwlwcmludGYoIiAgICAtUCA8TUFYX1BD
S1RfU0laRT4gRGVmYXVsdDogJXVcbiIsIE1BWF9QQ0tUX1NJWkUpOw0KPiAgIAlwcmludGYoIiAg
ICAtUyB1c2Ugc2tiLW1vZGVcbiIpOw0KPiAgIAlwcmludGYoIiAgICAtTiBlbmZvcmNlIG5hdGl2
ZSBtb2RlXG4iKTsNCj4gICAJcHJpbnRmKCIgICAgLUYgZm9yY2UgbG9hZGluZyBwcm9nXG4iKTsN
Cj4gQEAgLTg1LDEzICs4NywxNCBAQCBpbnQgbWFpbihpbnQgYXJnYywgY2hhciAqKmFyZ3YpDQo+
ICAgCQkucHJvZ190eXBlCT0gQlBGX1BST0dfVFlQRV9YRFAsDQo+ICAgCX07DQo+ICAgCXVuc2ln
bmVkIGNoYXIgb3B0X2ZsYWdzWzI1Nl0gPSB7fTsNCj4gLQljb25zdCBjaGFyICpvcHRzdHIgPSAi
aTpUOlNORmgiOw0KPiArCWNvbnN0IGNoYXIgKm9wdHN0ciA9ICJpOlQ6UDpTTkZoIjsNCj4gICAJ
c3RydWN0IGJwZl9wcm9nX2luZm8gaW5mbyA9IHt9Ow0KPiAgIAlfX3UzMiBpbmZvX2xlbiA9IHNp
emVvZihpbmZvKTsNCj4gKwlfX3UzMiBtYXhfcGNrdF9zaXplID0gMDsNCj4gKwlfX3UzMiBrZXkg
PSAwOw0KPiAgIAl1bnNpZ25lZCBpbnQga2lsbF9hZnRlcl9zID0gMDsNCj4gICAJaW50IGksIHBy
b2dfZmQsIG1hcF9mZCwgb3B0Ow0KPiAgIAlzdHJ1Y3QgYnBmX29iamVjdCAqb2JqOw0KPiAtCXN0
cnVjdCBicGZfbWFwICptYXA7DQo+ICAgCWNoYXIgZmlsZW5hbWVbMjU2XTsNCj4gICAJaW50IGVy
cjsNCj4gICANCj4gQEAgLTExMCw2ICsxMTMsOSBAQCBpbnQgbWFpbihpbnQgYXJnYywgY2hhciAq
KmFyZ3YpDQo+ICAgCQljYXNlICdUJzoNCj4gICAJCQlraWxsX2FmdGVyX3MgPSBhdG9pKG9wdGFy
Zyk7DQo+ICAgCQkJYnJlYWs7DQo+ICsJCWNhc2UgJ1AnOg0KPiArCQkJbWF4X3Bja3Rfc2l6ZSA9
IGF0b2kob3B0YXJnKTsNCj4gKwkJCWJyZWFrOw0KPiAgIAkJY2FzZSAnUyc6DQo+ICAgCQkJeGRw
X2ZsYWdzIHw9IFhEUF9GTEFHU19TS0JfTU9ERTsNCj4gICAJCQlicmVhazsNCj4gQEAgLTE1MCwx
MiArMTU2LDIyIEBAIGludCBtYWluKGludCBhcmdjLCBjaGFyICoqYXJndikNCj4gICAJaWYgKGJw
Zl9wcm9nX2xvYWRfeGF0dHIoJnByb2dfbG9hZF9hdHRyLCAmb2JqLCAmcHJvZ19mZCkpDQo+ICAg
CQlyZXR1cm4gMTsNCj4gICANCj4gLQltYXAgPSBicGZfbWFwX19uZXh0KE5VTEwsIG9iaik7DQo+
IC0JaWYgKCFtYXApIHsNCj4gLQkJcHJpbnRmKCJmaW5kaW5nIGEgbWFwIGluIG9iaiBmaWxlIGZh
aWxlZFxuIik7DQo+ICsJLyogdXBkYXRlIHBja3RzeiBtYXAgKi8NCj4gKwlpZiAobWF4X3Bja3Rf
c2l6ZSkgew0KPiArCQltYXBfZmQgPSBicGZfb2JqZWN0X19maW5kX21hcF9mZF9ieV9uYW1lKG9i
aiwgInBja3RzeiIpOw0KPiArCQlpZiAoIW1hcF9mZCkgew0KDQpMZXQgdXMgdGVzdCBtYXBfZmQg
YW5kIGJlbG93IHByb2dfZmQgd2l0aCAnPCAwIiBpbnN0ZWFkIG9mICIhPSAwJy4NCkluIHRoaXMg
cGFydGljdWxhciBzYW1wbGUsICIhID0gMCIgaXMgb2theSBzaW5jZSB3ZSBkaWQgbm90IGNsb3Nl
DQpzdGRpbi4gQnV0IGluIHByb2dyYW1zIGlmIHN0ZGluIGlzIGNsb3NlZCwgdGhlIGZkIDAgbWF5
IGJlIHJldXNlZA0KZm9yIG1hcF9mZC4gTGV0IHVzIGp1c3Qga2VlcCBnb29kIGNvZGluZyBwcmFj
dGljZSBoZXJlLg0KDQo+ICsJCQlwcmludGYoImZpbmRpbmcgYSBwY2t0c3ogbWFwIGluIG9iaiBm
aWxlIGZhaWxlZFxuIik7DQo+ICsJCQlyZXR1cm4gMTsNCj4gKwkJfQ0KPiArCQlicGZfbWFwX3Vw
ZGF0ZV9lbGVtKG1hcF9mZCwgJmtleSwgJm1heF9wY2t0X3NpemUsIEJQRl9BTlkpOw0KPiArCX0N
Cj4gKw0KPiArCS8qIGZldGNoIGljbXBjbnQgbWFwICovDQo+ICsJbWFwX2ZkID0gYnBmX29iamVj
dF9fZmluZF9tYXBfZmRfYnlfbmFtZShvYmosICJpY21wY250Iik7DQo+ICsJaWYgKCFtYXBfZmQp
IHsNCj4gKwkJcHJpbnRmKCJmaW5kaW5nIGEgaWNtcGNudCBtYXAgaW4gb2JqIGZpbGUgZmFpbGVk
XG4iKTsNCj4gICAJCXJldHVybiAxOw0KPiAgIAl9DQo+IC0JbWFwX2ZkID0gYnBmX21hcF9fZmQo
bWFwKTsNCj4gICANCj4gICAJaWYgKCFwcm9nX2ZkKSB7DQo+ICAgCQlwcmludGYoImxvYWRfYnBm
X2ZpbGU6ICVzXG4iLCBzdHJlcnJvcihlcnJubykpOw0KPiANCg==
