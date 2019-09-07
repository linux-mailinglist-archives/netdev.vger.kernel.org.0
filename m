Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5519CAC4EB
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 08:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406487AbfIGGfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 02:35:08 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:45118 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733303AbfIGGfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 02:35:07 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x876Z1ug027231;
        Fri, 6 Sep 2019 23:35:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=INcTt/iqVYZRZWTu1i6UyvKe1wHIKYL+uxbyDiiSfok=;
 b=rET8VtiumWiOYUMZXVxAnyjJ0cogWWZ1uVuUGNlJC8Jt2CDISrdkiXJ/S80tn6Kud/0m
 0m+td3kjqsLFGdxZwOtQ6XfFqatIfDyFqdw6QsI65pkG85Cwzkkf5P3IlITH3Hy66k7X
 VGIMMEVH9MvoyjqY6m1ipuykhSSGS04Xz0M= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2uus7ckm9b-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 06 Sep 2019 23:35:03 -0700
Received: from ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) by
 ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 6 Sep 2019 23:34:40 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 6 Sep 2019 23:34:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=msDZ9K/4VQzMdA/10I/N4/SFUfh3cMFX6UeNTSIH+3F2v5F3xBTBjyf3rQbeiYldEQipp3FB3ai47u5E71LHr5FD7uvFgnq4EfLpRaNPwqn7KSLvAjv8g4Vs1JyjB99ZdDjhEKV4Yr41Urv77pBug8+dgB7V08pe/cVI6e6xfuhviNV5y0bJd2jMQ+9OwcMK20vlxp93/dQuPYgSfUva+azn3OPuIWySy15IEr9r1Uh07/7Vk553280ZJz+kzN4Lkazup7f/zT70aSyze4w6i9gEFV8PWGq3SKj3GFE40bYidip6L7GKWeaUQnArfK0p05lCFzqdginiSZWEY/uIkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=INcTt/iqVYZRZWTu1i6UyvKe1wHIKYL+uxbyDiiSfok=;
 b=aI3hLoOLrNMP9w3Lz6jK+MmopWcDMgMcSuVLHSbIgCEEIYTR3lI5Ral6GCzX04cwcLwPtGQmSsbMhDl0vHKNRn6DSYrJqX2WsUFFWgIqsQl88z1Tl/gVXknGbB4oYEFKLCrs5r4dumBS2w3JJ0rMOWdY8Ga92TtwHQcdleE6GV7htoyfyygjMvvNCVCMr1pBmsOvrOS61Drg25Hjz6z0grKlrPIZeLWa9yYTx/3yc5REfarydnYl9TtiX89bY2xebxrLVlFG8WOR4+//iR97HEpvXFvtBI//RvxcUjlA+r8QVoSJW5Ia/jSSw/oUXGP7svLIBSnDeS+KLeX6o+nmbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=INcTt/iqVYZRZWTu1i6UyvKe1wHIKYL+uxbyDiiSfok=;
 b=fxIgNWn/9Lq0szy+VDYjXRc5zKUJrjPpR62w4vs8fWQieCG3shUkTqjjt08BTfuhGYnm7bo+rqptvMm6ereI6mFB4cd4gHeVC2/LcPcCW6bjXBGZ0AOQ5plSTIYqCGWBvOCpgOJswQUQMqipmvgRHmVabPUkdsL0Xs3HfDPqkEs=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB2936.namprd15.prod.outlook.com (20.178.237.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.15; Sat, 7 Sep 2019 06:34:39 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::95ab:61a0:29f4:e07e]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::95ab:61a0:29f4:e07e%6]) with mapi id 15.20.2241.014; Sat, 7 Sep 2019
 06:34:39 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
CC:     Carlos Neira <cneirabustos@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v10 2/4] bpf: new helper to obtain namespace data
 from current task New bpf helper bpf_get_current_pidns_info.
Thread-Topic: [PATCH bpf-next v10 2/4] bpf: new helper to obtain namespace
 data from current task New bpf helper bpf_get_current_pidns_info.
Thread-Index: AQHVZQnHC5SFgtm26kSgAiqJpjAzqqcfV1wAgABrMAA=
Date:   Sat, 7 Sep 2019 06:34:39 +0000
Message-ID: <7d196a64-cf36-c2d5-7328-154aaeb929eb@fb.com>
References: <20190906150952.23066-1-cneirabustos@gmail.com>
 <20190906150952.23066-3-cneirabustos@gmail.com>
 <20190906152435.GW1131@ZenIV.linux.org.uk>
 <20190906154647.GA19707@ZenIV.linux.org.uk>
 <20190906160020.GX1131@ZenIV.linux.org.uk>
 <c0e67fc7-be66-c4c6-6aad-316cbba18757@fb.com>
 <20190907001056.GA1131@ZenIV.linux.org.uk>
In-Reply-To: <20190907001056.GA1131@ZenIV.linux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MW2PR16CA0009.namprd16.prod.outlook.com (2603:10b6:907::22)
 To BYAPR15MB3384.namprd15.prod.outlook.com (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::7c8a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 05624466-f234-4757-c67a-08d7335d755b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2936;
x-ms-traffictypediagnostic: BYAPR15MB2936:
x-microsoft-antispam-prvs: <BYAPR15MB2936CE8D729E1D6A797F7DCCD3B50@BYAPR15MB2936.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 0153A8321A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(396003)(366004)(346002)(136003)(39860400002)(51914003)(189003)(199004)(486006)(86362001)(46003)(478600001)(31686004)(476003)(256004)(446003)(186003)(2616005)(31696002)(11346002)(8676002)(81156014)(81166006)(8936002)(305945005)(7736002)(14444005)(36756003)(99286004)(71190400001)(71200400001)(5660300002)(66946007)(52116002)(2906002)(66446008)(64756008)(6116002)(54906003)(66476007)(66556008)(316002)(6512007)(6486002)(14454004)(6506007)(76176011)(25786009)(229853002)(386003)(53936002)(53546011)(102836004)(6246003)(6916009)(4326008)(6436002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2936;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: T8QgX4Y6daldFEZzn91QXRyFyGg262kNNJdYrwK2eR1ONMVthkfOvJ61teUYdAhdHFYKZ+U224R+Mn3Dfw+9KxFoN8lPkDrrXtoDza0ifn2Q6Cpi/dsHU/pxvxxK4Iimno26NsgGI/bUuaqUFePmqLJPGLR/X8HbfsEy5qjmoTUSo0UOOedRN6RJq7uJU+xACKRJ3OnT1b8EmUWAPz43QXPjBkTvnkDPmAlceYRocQIYs3coXTgi7DoDrrVj50htAE0Bwmm96jBLzWTzZ3pFDqeQkCUYTETxc2uqsySAyftPIWN6NIpHcKjIWi32KHj5cFunwlnckmHPrXIIxK1VRhSJgPu5j5+AH2WKWlEIV/3M5CUA7B5Gczt16JRUgt6Q3FrhFz/QGHN+du5IOuWzYeOQB70H28pukfWbQ8BPbRI=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <6E5D37AAB8A9A6418BBBF5B1ED0924E3@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 05624466-f234-4757-c67a-08d7335d755b
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Sep 2019 06:34:39.3166
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KjmtRUw7hkUHWKUmknADY5xu6Txh+W1DOhbTTlrF8y7/JNZcqK8mcSKBEfJRq4rB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2936
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-07_02:2019-09-04,2019-09-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 spamscore=0 bulkscore=0 clxscore=1015 phishscore=0 mlxscore=0
 lowpriorityscore=0 impostorscore=0 malwarescore=0 adultscore=0
 suspectscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1906280000 definitions=main-1909070070
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDkvNi8xOSA1OjEwIFBNLCBBbCBWaXJvIHdyb3RlOg0KPiBPbiBGcmksIFNlcCAwNiwg
MjAxOSBhdCAxMToyMToxNFBNICswMDAwLCBZb25naG9uZyBTb25nIHdyb3RlOg0KPiANCj4+IC1i
YXNoLTQuNCQgcmVhZGxpbmsgL3Byb2Mvc2VsZi9ucy9waWQNCj4+IHBpZDpbNDAyNjUzMTgzNl0N
Cj4+IC1iYXNoLTQuNCQgc3RhdCAvcHJvYy9zZWxmL25zL3BpZA0KPj4gICAgIEZpbGU6IOKAmC9w
cm9jL3NlbGYvbnMvcGlk4oCZIC0+IOKAmHBpZDpbNDAyNjUzMTgzNl3igJkNCj4+ICAgICBTaXpl
OiAwICAgICAgICAgICAgICAgQmxvY2tzOiAwICAgICAgICAgIElPIEJsb2NrOiAxMDI0ICAgc3lt
Ym9saWMgbGluaw0KPj4gRGV2aWNlOiA0aC80ZCAgIElub2RlOiAzNDQ3OTU5ODkgICBMaW5rczog
MQ0KPj4gQWNjZXNzOiAoMDc3Ny9scnd4cnd4cnd4KSAgVWlkOiAoMTI4MjAzLyAgICAgeWhzKSAg
IEdpZDogKCAgMTAwLyAgIHVzZXJzKQ0KPj4gQ29udGV4dDogdXNlcl91OmJhc2VfcjpiYXNlX3QN
Cj4+IEFjY2VzczogMjAxOS0wOS0wNiAxNjowNjowOS40MzE2MTYzODAgLTA3MDANCj4+IE1vZGlm
eTogMjAxOS0wOS0wNiAxNjowNjowOS40MzE2MTYzODAgLTA3MDANCj4+IENoYW5nZTogMjAxOS0w
OS0wNiAxNjowNjowOS40MzE2MTYzODAgLTA3MDANCj4+ICAgIEJpcnRoOiAtDQo+PiAtYmFzaC00
LjQkDQo+Pg0KPj4gQmFzZWQgb24gYSBkaXNjdXNzaW9uIHdpdGggRXJpYyBCaWVkZXJtYW4gYmFj
ayBpbiAyMDE5IExpbnV4DQo+PiBQbHVtYmVycywgRXJpYyBzdWdnZXN0ZWQgdGhhdCB0byB1bmlx
dWVseSBpZGVudGlmeSBhDQo+PiBuYW1lc3BhY2UsIGRldmljZSBpZCAobWFqb3IvbWlub3IpIG51
bWJlciBzaG91bGQgYWxzbw0KPj4gYmUgaW5jbHVkZWQuIEFsdGhvdWdoIHRvZGF5J3Mga2VybmVs
IGltcGxlbWVudGF0aW9uDQo+PiBoYXMgdGhlIHNhbWUgZGV2aWNlIGZvciBhbGwgbmFtZXNwYWNl
IHBzZXVkbyBmaWxlcywNCj4+IGJ1dCBmcm9tIHVhcGkgcGVyc3BlY3RpdmUsIGRldmljZSBpZCBz
aG91bGQgYmUgaW5jbHVkZWQuDQo+Pg0KPj4gVGhhdCBpcyB0aGUgcmVhc29uIHdoeSB3ZSB0cnkg
dG8gZ2V0IGRldmljZSBpZCB3aGljaCBob2xkcw0KPj4gcGlkIG5hbWVzcGFjZSBwc2V1ZG8gZmls
ZS4NCj4+DQo+PiBEbyB5b3UgaGF2ZSBhIGJldHRlciBzdWdnZXN0aW9uIG9uIGhvdyB0byBnZXQN
Cj4+IHRoZSBkZXZpY2UgaWQgZm9yICdjdXJyZW50JyBwaWQgbmFtZXNwYWNlPyBPciBmcm9tIGRl
c2lnbiwgd2UNCj4+IHJlYWxseSBzaG91bGQgbm90IGNhcmUgYWJvdXQgZGV2aWNlIGlkIGF0IGFs
bD8NCj4gDQo+IFdoYXQgdGhlIGhlbGwgaXMgImRldmljZSBpZCBmb3IgcGlkIG5hbWVzcGFjZSI/
ICBUaGlzIGlzIHRoZQ0KPiBmaXJzdCB0aW1lIEkndmUgaGVhcmQgYWJvdXQgdGhhdCBteXN0ZXJ5
IG9iamVjdCwgc28gaXQncw0KPiBoYXJkIHRvIHRlbGwgd2hlcmUgaXQgY291bGQgYmUgZm91bmQu
DQo+IA0KPiBJIGNhbiB0ZWxsIHlvdSB3aGF0IGRldmljZSBudW1iZXJzIGFyZSBpbnZvbHZlZCBp
biB0aGUgYXJlYXMNCj4geW91IHNlZW0gdG8gYmUgbG9va2luZyBpbi4NCj4gDQo+IDEpIHRoZXJl
J3Mgd2hhdGV2ZXIgZGV2aWNlIG51bWJlciB0aGF0IGdldHMgYXNzaWduZWQgdG8NCj4gKHRoaXMp
IHByb2NmcyBpbnN0YW5jZS4gIFRoYXQsIGlyb25pY2FsbHksIF9pc18gcGVyLXBpZG5zLCBidXQN
Cj4gdGhhdCBvZiB0aGUgcHJvY2ZzIGluc3RhbmNlLCBub3QgdGhhdCBvZiB5b3VyIHByb2Nlc3Mg
KGFuZA0KPiB0aG9zZSBjYW4gYmUgZGlmZmVyZW50KS4gIFRoYXQncyB3aGF0IHlvdSBnZXQgaW4g
LT5zdF9kZXYNCj4gd2hlbiBkb2luZyBsc3RhdCgpIG9mIGFueXRoaW5nIGluIC9wcm9jIChhc3N1
bWluZyB0aGF0DQo+IHByb2NmcyBpcyBtb3VudGVkIHRoZXJlLCBpbiB0aGUgZmlyc3QgcGxhY2Up
LiAgTk9URToNCj4gdGhhdCdzIGxzdGF0KDIpLCBub3Qgc3RhdCgyKS4gIHN0YXQoMSkgdXNlcyBs
c3RhdCgyKSwNCj4gdW5sZXNzIGdpdmVuIC1MIChpbiB3aGljaCBjYXNlIGl0J3Mgc3RhdCgyKSB0
aW1lKS4gIFRoZQ0KPiBkaWZmZXJlbmNlOg0KPiANCj4gcm9vdEBrdm0xOn4jIHN0YXQgL3Byb2Mv
c2VsZi9ucy9waWQNCj4gICAgRmlsZTogL3Byb2Mvc2VsZi9ucy9waWQgLT4gcGlkOls0MDI2NTMx
ODM2XQ0KPiAgICBTaXplOiAwICAgICAgICAgICAgICAgQmxvY2tzOiAwICAgICAgICAgIElPIEJs
b2NrOiAxMDI0ICAgc3ltYm9saWMgbGluaw0KPiBEZXZpY2U6IDRoLzRkICAgSW5vZGU6IDE3Mzk2
ICAgICAgIExpbmtzOiAxDQo+IEFjY2VzczogKDA3NzcvbHJ3eHJ3eHJ3eCkgIFVpZDogKCAgICAw
LyAgICByb290KSAgIEdpZDogKCAgICAwLyAgICByb290KQ0KPiBBY2Nlc3M6IDIwMTktMDktMDYg
MTk6NDM6MTEuODcxMzEyMzE5IC0wNDAwDQo+IE1vZGlmeTogMjAxOS0wOS0wNiAxOTo0MzoxMS44
NzEzMTIzMTkgLTA0MDANCj4gQ2hhbmdlOiAyMDE5LTA5LTA2IDE5OjQzOjExLjg3MTMxMjMxOSAt
MDQwMA0KPiAgIEJpcnRoOiAtDQo+IHJvb3RAa3ZtMTp+IyBzdGF0IC1MIC9wcm9jL3NlbGYvbnMv
cGlkDQo+ICAgIEZpbGU6IC9wcm9jL3NlbGYvbnMvcGlkDQo+ICAgIFNpemU6IDAgICAgICAgICAg
ICAgICBCbG9ja3M6IDAgICAgICAgICAgSU8gQmxvY2s6IDQwOTYgICByZWd1bGFyIGVtcHR5IGZp
bGUNCj4gRGV2aWNlOiAzaC8zZCAgIElub2RlOiA0MDI2NTMxODM2ICBMaW5rczogMQ0KPiBBY2Nl
c3M6ICgwNDQ0Ly1yLS1yLS1yLS0pICBVaWQ6ICggICAgMC8gICAgcm9vdCkgICBHaWQ6ICggICAg
MC8gICAgcm9vdCkNCj4gQWNjZXNzOiAyMDE5LTA5LTA2IDE5OjQzOjE1Ljk1NTMxMzI5MyAtMDQw
MA0KPiBNb2RpZnk6IDIwMTktMDktMDYgMTk6NDM6MTUuOTU1MzEzMjkzIC0wNDAwDQo+IENoYW5n
ZTogMjAxOS0wOS0wNiAxOTo0MzoxNS45NTUzMTMyOTMgLTA0MDANCj4gICBCaXJ0aDogLQ0KPiAN
Cj4gVGhlIGZvcm1lciBpcyBsc3RhdCwgdGhlIGxhdHRlciAtIHN0YXQuDQo+IA0KPiAyKSBkZXZp
Y2UgbnVtYmVyIG9mIHRoZSBmaWxlc3lzdGVtIHdoZXJlIHRoZSBzeW1saW5rIHRhcmdldCBsaXZl
cy4NCj4gSW4gdGhpcyBjYXNlLCBpdCdzIG5zZnMgYW5kIHRoZXJlJ3Mgb25seSBvbmUgaW5zdGFu
Y2Ugb24gdGhlIGVudGlyZQ0KPiBzeXN0ZW0uICBfVGhhdF8gd291bGQgYmUgb2J0YWluZWQgYnkg
bG9va2luZyBhdCBzdF9kZXYgaW4gc3RhdCgyKSBvbg0KPiAvcHJvYy9zZWxmL25zL3BpZCAoMDoz
IGFib3ZlKS4NCj4gDQo+IDMpIGRldmljZSBudW1iZXIgKk9GKiB0aGUgc3ltbGluay4gIFRoYXQg
d291bGQgYmUgc3RfcmRldiBpbiBsc3RhdCgyKS4NCj4gVGhlcmUncyBub25lIC0gaXQncyBhIHN5
bWxpbmssIG5vdCBhIGNoYXJhY3RlciBvciBibG9jayBkZXZpY2UuICBJdCdzDQo+IGFsd2F5cyB6
ZXJvIGFuZCBhbHdheXMgd2lsbCBiZSB6ZXJvLg0KPiANCj4gNCkgdGhlIHNhbWUgZm9yIHRoZSB0
YXJnZXQ7IHN0X3JkZXYgaW4gc3RhdCgyKSByZXN1bHRzIGFuZCBhZ2FpbiwNCj4gdGhlcmUncyBu
byBzdWNoIGJlYXN0IC0gaXQncyBuZWl0aGVyIGNoYXJhY3RlciBub3IgYmxvY2sgZGV2aWNlLg0K
PiANCj4gWW91ciBjb2RlIGlzIGxvb2tpbmcgYXQgKDMpLiAgUGxlYXNlLCByZXJlYWQgYW55IHRl
eHRib29rIG9uIFVuaXgNCj4gaW4gdGhlIHNlY3Rpb24gdGhhdCB3b3VsZCBjb3ZlciBzdGF0KDIp
IGFuZCBkaXNjdXNzaW9uIG9mIHRoZQ0KPiBkaWZmZXJlbmNlIGJldHdlZW4gc3RfZGV2IGFuZCBz
dF9yZGV2Lg0KPiANCj4gSSBoYXZlIG5vIGlkZWEgd2hhdCBFcmljIGhhZCBiZWVuIHRhbGtpbmcg
YWJvdXQgLSBpdCdzIGhhcmQgdG8NCj4gcmVjb25zdHJ1Y3QgYnkgd2hhdCB5b3Ugc2FpZCBzbyBm
YXIuICBNYWtpbmcgbnNmcyBwZXItdXNlcm5zLA0KPiBwZXJoYXBzPyAgQnV0IHRoYXQgbWFrZXMg
bm8gc2Vuc2Ugd2hhdHNvZXZlciwgbm90IHRoYXQgdXNlcm5zDQo+IGV2ZXIgaGFkLi4uICBDaGVh
cCBzaG90cyBhc2lkZSwgSSByZWFsbHkgY2FuJ3QgZ3Vlc3Mgd2hhdCB0aGF0J3MNCj4gYWJvdXQu
ICBTb3JyeS4NCg0KVGhhbmtzIGZvciB0aGUgZGV0YWlsZWQgaW5mb3JtYXRpb24uIFRoZSBkZXZp
Y2UgbnVtYmVyIHdlIHdhbnQNCmlzIG5zZnMuIEluZGVlZCwgY3VycmVudGx5LCB0aGVyZSBpcyBv
bmx5IG9uZSBpbnN0YW5jZQ0Kb24gdGhlIGVudGlyZSBzeXN0ZW0uIEJ1dCBub3QgZXhhY3RseSBz
dXJlIHdoYXQgaXMgdGhlIHBvc3NpYmlsaXR5DQp0byBoYXZlIG1vcmUgdGhhbiBvbmUgbnNmcyBk
ZXZpY2UgaW4gdGhlIGZ1dHVyZS4gTWF5YmUgcGVyLXVzZXJucw0Kb3IgYW55IG90aGVyIGNyaXRl
cmlhPw0KDQo+IA0KPiBJbiBhbnkgY2FzZSwgcGF0aG5hbWUgcmVzb2x1dGlvbiBpcyAqTk9UKiBm
b3IgdGhlIHNpdHVhdGlvbnMgd2hlcmUNCj4geW91IGNhbid0IGJsb2NrLiAgRXZlbiBpZiBpdCdz
IHByb2NmcyAoYW5kIGZyb20gdGhlIHNhbWUgcGlkbnMgYXMNCj4gdGhlIHByb2Nlc3MpIG1vdW50
ZWQgdGhlcmUsIHRoZXJlIGlzIG5vIHByb21pc2UgdGhhdCB0aGUgdGFyZ2V0DQo+IG9mIC9wcm9j
L3NlbGYgaGFzIGFscmVhZHkgYmVlbiBsb29rZWQgdXAgYW5kIG5vdCBldmljdGVkIGZyb20NCj4g
bWVtb3J5IHNpbmNlIHRoZW4uICBBbmQgaW4gY2FzZSBvZiBjYWNoZSBtaXNzIHBhdGh3YWxrIHdp
bGwNCj4gaGF2ZSB0byBjYWxsIC0+bG9va3VwKCksIHdoaWNoIHJlcXVpcmVzIGxvY2tpbmcgdGhl
IGRpcmVjdG9yeQ0KPiAocndfc2VtLCBzaGFyZWQpLiAgWW91IGNhbid0IGRvIHRoYXQgaW4gc3Vj
aCBjb250ZXh0Lg0KPiANCj4gQW5kIHRoYXQgZG9lc24ndCBldmVuIGdvIGludG8gdGhlIHBvc3Np
YmlsaXR5IHRoYXQgcHJvY2VzcyBoYXMNCj4gc29tZXRoaW5nIHZlcnkgZGlmZmVyZW50IG1vdW50
ZWQgb24gL3Byb2MuDQo+IA0KPiBBZ2FpbiwgSSBkb24ndCBrbm93IHdoYXQgaXQgaXMgdGhhdCB5
b3Ugd2FudCB0byBnZXQgdG8sIGJ1dA0KPiBJIHdvdWxkIHN0cm9uZ2x5IHJlY29tbWVuZCBmaW5k
aW5nIGEgd2F5IHRvIGdldCB0byB0aGF0IGRhdGENCj4gdGhhdCB3b3VsZCBub3QgaW52b2x2ZSBn
b2luZyBhbnl3aGVyZSBuZWFyIHBhdGhuYW1lIHJlc29sdXRpb24uDQo+IA0KPiBIb3cgd291bGQg
eW91IGV4cGVjdCB0aGUgdXNlcmxhbmQgdG8gd29yayB3aXRoIHRoYXQgdmFsdWUsDQo+IHdoYXRl
dmVyIGl0IG1pZ2h0IGJlPyAgSWYgaXQncyBqdXN0IGEgMzJiaXQgZmllbGQgdGhhdCB3aWxsDQo+
IG5ldmVyIGJlIHJlYWQsIHlvdSBtaWdodCBhcyB3ZWxsIHN0b3JlIHRoZXJlIHRoZSBzYW1lIHZh
bHVlDQo+IHlvdSBzdG9yZSBub3cgKDAsIHRoYXQgaXMpIGluIG11Y2ggY2hlYXBlciBhbmQgc2Fm
ZXIgd2F5IDstKQ0KDQpTdXBwb3NlIGluc2lkZSBwaWQgbmFtZXNwYWNlLCB1c2VyIGNhbiBwYXNz
IHRoZSBkZXZpY2UgbnVtYmVyLA0Kc2F5IG4xLCAoYHN0YXQgLUwgL3Byb2Mvc2VsZi9ucy9waWRg
KSB0byBicGYgcHJvZ3JhbSAodGhyb3VnaCBtYXANCm9yIEpJVCkuIEF0IHJ1bnRpbWUsIGJwZiBw
cm9ncmFtIHdpbGwgdHJ5IHRvIGdldCBkZXZpY2UgbnVtYmVyLA0Kc2F5IG4yLCBmb3IgdGhlICdj
dXJyZW50JyBwcm9jZXNzLiBJZiBuMSBpcyBub3QgdGhlIHNhbWUgYXMNCm4yLCB0aGF0IG1lYW5z
IHRoZXkgYXJlIG5vdCBpbiB0aGUgc2FtZSBuYW1lc3BhY2UuICdjdXJyZW50Jw0KaXMgaW4gdGhl
IHNhbWUgcGlkIG5hbWVzcGFjZSBhcyB0aGUgdXNlciBpZmYNCm4xID09IG4yIGFuZCBhbHNvIHBp
ZG5zIGlkIGlzIHRoZSBzYW1lIGZvciAnY3VycmVudCcgYW5kDQp0aGUgb25lIHdpdGggYGxzbnMg
LXQgcGlkYC4NCg0KQXJlIHlvdSBhd2FyZSBvZiBhbnkgd2F5IHRvIGdldCB0aGUgcGlkbnMgZGV2
aWNlIG51bWJlcg0KZm9yICdjdXJyZW50JyB3aXRob3V0IGdvaW5nIHRocm91Z2ggdGhlIHBhdGhu
YW1lDQpsb29rdXA/DQoNCg==
