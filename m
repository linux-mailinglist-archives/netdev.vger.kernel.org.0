Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD53E60F19
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 07:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725955AbfGFFm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 01:42:57 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53730 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725887AbfGFFm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 01:42:56 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x665drww011745;
        Fri, 5 Jul 2019 22:42:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=gG39rceh+vtosN6KWYe02GzKiCUjlSEu/Di/plcBfBo=;
 b=LBYBtvBs6fQLu6EbAZMT0SynzBbYfV+HjjOU/DZZyHTd10uvPG5LiRLQkn1/bejEg6jN
 YGF6CQD5liYMa3TkpgDzuRd9o80EPspgVC1DDF0bm1HSDeGezUjqIhy6qSdTRP+3dNLN
 w9HlsqgZjsrEVDHjhuwvKF6tiPqJCEpxnA4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2tjdqes5rs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 05 Jul 2019 22:42:36 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 5 Jul 2019 22:42:34 -0700
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 5 Jul 2019 22:42:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gG39rceh+vtosN6KWYe02GzKiCUjlSEu/Di/plcBfBo=;
 b=Ss58FqV1BQuv5vOgx0aStcScSxFPpxjenT2u+O+PK2BN3GAr59SM9dj+Ab+p837lOoMVR6Km3vTyUMU2ip9L+TKt0EKUounLtjQxm1Rr+oRwqweR5l6yEjyaTlANVjHc082h7gIC5K7/PK6Z0LGZBMY14zhh2gQT/nNAgbdQIwc=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB3175.namprd15.prod.outlook.com (20.179.56.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.17; Sat, 6 Jul 2019 05:42:33 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac%5]) with mapi id 15.20.2052.019; Sat, 6 Jul 2019
 05:42:33 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
Subject: Re: [PATCH v5 bpf-next 1/5] libbpf: add perf buffer API
Thread-Topic: [PATCH v5 bpf-next 1/5] libbpf: add perf buffer API
Thread-Index: AQHVM7RDY67jeJ/hpEu/lVUn/Au/Aqa9E8mA
Date:   Sat, 6 Jul 2019 05:42:33 +0000
Message-ID: <e0e2f6d2-016c-70bd-a0c6-5c147d5b7aca@fb.com>
References: <20190706043522.1559005-1-andriin@fb.com>
 <20190706043522.1559005-2-andriin@fb.com>
In-Reply-To: <20190706043522.1559005-2-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR18CA0050.namprd18.prod.outlook.com
 (2603:10b6:104:2::18) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:2331]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a203d4eb-1d37-46a4-c3e1-08d701d4be64
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB3175;
x-ms-traffictypediagnostic: BYAPR15MB3175:
x-microsoft-antispam-prvs: <BYAPR15MB31751D1EC625C4EE3735872BD3F40@BYAPR15MB3175.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 00909363D5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(396003)(136003)(366004)(39860400002)(199004)(189003)(73956011)(66556008)(66476007)(64756008)(36756003)(66446008)(305945005)(66946007)(2201001)(86362001)(2616005)(386003)(446003)(53546011)(25786009)(6506007)(102836004)(11346002)(2906002)(7736002)(476003)(14454004)(478600001)(110136005)(6512007)(316002)(99286004)(6436002)(5660300002)(6486002)(53936002)(229853002)(31696002)(71200400001)(71190400001)(31686004)(6246003)(256004)(8676002)(81166006)(486006)(186003)(46003)(8936002)(81156014)(2501003)(76176011)(52116002)(14444005)(68736007)(6116002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3175;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: rTwY22LFfRyciEFqZ7Dncby7jeV1i925T5Ob39yXsFt7pU+AZG7DHxYP4O1ezdHVRyb+KrgYQXQsjqt9+R90ZYi0ov0X9Z+iCellXfQy4/BtrNtiOZN332NPTQO6goRafm7EGDUr7HQuBsRHb3IoDM/tYowWwcR0XQizDK2M+q+PhSkCut2fNupyH1FvkNuJFyO4njqqeC/UDJ12YAIlc4STVbaWgt/9+usVliggygswwqpoZuotuC64diJU4hGOfQxWQLhSNcWNl0re2qDSGM1F76xf2MBoqDBCQ5jPl1gICH9DsDYnWavwxFG18n2oTi2/WfZdN3Nk0O3s4dSTAAbrlc8Mz2xHsmbhGm87Hhl1xE+aeU2dDGr+qnQ8T11rQ057En5nZ5AYpFD5bXZZlCiftlNMHjhU4JyzyMLcc84=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DB94EACB984964479D793590F8EACA96@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a203d4eb-1d37-46a4-c3e1-08d701d4be64
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2019 05:42:33.6952
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3175
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-06_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907060074
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDcvNS8xOSA5OjM1IFBNLCBBbmRyaWkgTmFrcnlpa28gd3JvdGU6DQo+IEJQRl9NQVBf
VFlQRV9QRVJGX0VWRU5UX0FSUkFZIG1hcCBpcyBvZnRlbiB1c2VkIHRvIHNlbmQgZGF0YSBmcm9t
IEJQRiBwcm9ncmFtDQo+IHRvIHVzZXIgc3BhY2UgZm9yIGFkZGl0aW9uYWwgcHJvY2Vzc2luZy4g
bGliYnBmIGFscmVhZHkgaGFzIHZlcnkgbG93LWxldmVsIEFQSQ0KPiB0byByZWFkIHNpbmdsZSBD
UFUgcGVyZiBidWZmZXIsIGJwZl9wZXJmX2V2ZW50X3JlYWRfc2ltcGxlKCksIGJ1dCBpdCdzIGhh
cmQgdG8NCj4gdXNlIGFuZCByZXF1aXJlcyBhIGxvdCBvZiBjb2RlIHRvIHNldCBldmVyeXRoaW5n
IHVwLiBUaGlzIHBhdGNoIGFkZHMNCj4gcGVyZl9idWZmZXIgYWJzdHJhY3Rpb24gb24gdG9wIG9m
IGl0LCBhYnN0cmFjdGluZyBzZXR0aW5nIHVwIGFuZCBwb2xsaW5nDQo+IHBlci1DUFUgbG9naWMg
aW50byBzaW1wbGUgYW5kIGNvbnZlbmllbnQgQVBJLCBzaW1pbGFyIHRvIHdoYXQgQkNDIHByb3Zp
ZGVzLg0KPiANCj4gcGVyZl9idWZmZXJfX25ldygpIHNldHMgdXAgcGVyLUNQVSByaW5nIGJ1ZmZl
cnMgYW5kIHVwZGF0ZXMgY29ycmVzcG9uZGluZyBCUEYNCj4gbWFwIGVudHJpZXMuIEl0IGFjY2Vw
dHMgdHdvIHVzZXItcHJvdmlkZWQgY2FsbGJhY2tzOiBvbmUgZm9yIGhhbmRsaW5nIHJhdw0KPiBz
YW1wbGVzIGFuZCBvbmUgZm9yIGdldCBub3RpZmljYXRpb25zIG9mIGxvc3Qgc2FtcGxlcyBkdWUg
dG8gYnVmZmVyIG92ZXJmbG93Lg0KPiANCj4gcGVyZl9idWZmZXJfX25ld19yYXcoKSBpcyBzaW1p
bGFyLCBidXQgcHJvdmlkZXMgbW9yZSBjb250cm9sIG92ZXIgaG93DQo+IHBlcmYgZXZlbnRzIGFy
ZSBzZXQgdXAgKGJ5IGFjY2VwdGluZyB1c2VyLXByb3ZpZGVkIHBlcmZfZXZlbnRfYXR0ciksIGhv
dw0KPiB0aGV5IGFyZSBoYW5kbGVkIChwZXJmX2V2ZW50X2hlYWRlciBwb2ludGVyIGlzIHBhc3Nl
ZCBkaXJlY3RseSB0bw0KPiB1c2VyLXByb3ZpZGVkIGNhbGxiYWNrKSwgYW5kIG9uIHdoaWNoIENQ
VXMgcmluZyBidWZmZXJzIGFyZSBjcmVhdGVkDQo+IChpdCdzIHBvc3NpYmxlIHRvIHByb3ZpZGUg
YSBsaXN0IG9mIENQVXMgYW5kIGNvcnJlc3BvbmRpbmcgbWFwIGtleXMgdG8NCj4gdXBkYXRlKS4g
VGhpcyBBUEkgYWxsb3dzIGFkdmFuY2VkIHVzZXJzIGZ1bGxlciBjb250cm9sLg0KPiANCj4gcGVy
Zl9idWZmZXJfX3BvbGwoKSBpcyB1c2VkIHRvIGZldGNoIHJpbmcgYnVmZmVyIGRhdGEgYWNyb3Nz
IGFsbCBDUFVzLA0KPiB1dGlsaXppbmcgZXBvbGwgaW5zdGFuY2UuDQo+IA0KPiBwZXJmX2J1ZmZl
cl9fZnJlZSgpIGRvZXMgY29ycmVzcG9uZGluZyBjbGVhbiB1cCBhbmQgdW5zZXRzIEZEcyBmcm9t
IEJQRiBtYXAuDQo+IA0KPiBBbGwgQVBJcyBhcmUgbm90IHRocmVhZC1zYWZlLiBVc2VyIHNob3Vs
ZCBlbnN1cmUgcHJvcGVyIGxvY2tpbmcvY29vcmRpbmF0aW9uIGlmDQo+IHVzZWQgaW4gbXVsdGkt
dGhyZWFkZWQgc2V0IHVwLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQW5kcmlpIE5ha3J5aWtvIDxh
bmRyaWluQGZiLmNvbT4NCj4gLS0tDQo+ICAgdG9vbHMvbGliL2JwZi9saWJicGYuYyAgIHwgMzY2
ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiAgIHRvb2xzL2xpYi9i
cGYvbGliYnBmLmggICB8ICA0OSArKysrKysNCj4gICB0b29scy9saWIvYnBmL2xpYmJwZi5tYXAg
fCAgIDQgKw0KPiAgIDMgZmlsZXMgY2hhbmdlZCwgNDE5IGluc2VydGlvbnMoKykNCj4gDQo+IGRp
ZmYgLS1naXQgYS90b29scy9saWIvYnBmL2xpYmJwZi5jIGIvdG9vbHMvbGliL2JwZi9saWJicGYu
Yw0KPiBpbmRleCAyYTA4ZWIxMDYyMjEuLjcyMTQ5ZDY4YjhjMSAxMDA2NDQNCj4gLS0tIGEvdG9v
bHMvbGliL2JwZi9saWJicGYuYw0KPiArKysgYi90b29scy9saWIvYnBmL2xpYmJwZi5jDQo+IEBA
IC0zMiw3ICszMiw5IEBADQo+ICAgI2luY2x1ZGUgPGxpbnV4L2xpbWl0cy5oPg0KPiAgICNpbmNs
dWRlIDxsaW51eC9wZXJmX2V2ZW50Lmg+DQo+ICAgI2luY2x1ZGUgPGxpbnV4L3JpbmdfYnVmZmVy
Lmg+DQo+ICsjaW5jbHVkZSA8c3lzL2Vwb2xsLmg+DQo+ICAgI2luY2x1ZGUgPHN5cy9pb2N0bC5o
Pg0KPiArI2luY2x1ZGUgPHN5cy9tbWFuLmg+DQo+ICAgI2luY2x1ZGUgPHN5cy9zdGF0Lmg+DQo+
ICAgI2luY2x1ZGUgPHN5cy90eXBlcy5oPg0KPiAgICNpbmNsdWRlIDxzeXMvdmZzLmg+DQo+IEBA
IC00MzU0LDYgKzQzNTYsMzcwIEBAIGJwZl9wZXJmX2V2ZW50X3JlYWRfc2ltcGxlKHZvaWQgKm1t
YXBfbWVtLCBzaXplX3QgbW1hcF9zaXplLCBzaXplX3QgcGFnZV9zaXplLA0KPiAgIAlyZXR1cm4g
cmV0Ow0KPiAgIH0NCj4gICANCj4gK3N0cnVjdCBwZXJmX2J1ZmZlcjsNCj4gKw0KPiArc3RydWN0
IHBlcmZfYnVmZmVyX3BhcmFtcyB7DQo+ICsJc3RydWN0IHBlcmZfZXZlbnRfYXR0ciAqYXR0cjsN
Cj4gKwkvKiBpZiBldmVudF9jYiBpcyBzcGVjaWZpZWQsIGl0IHRha2VzIHByZWNlbmRlbmNlICov
DQo+ICsJcGVyZl9idWZmZXJfZXZlbnRfZm4gZXZlbnRfY2I7DQo+ICsJLyogc2FtcGxlX2NiIGFu
ZCBsb3N0X2NiIGFyZSBoaWdoZXItbGV2ZWwgY29tbW9uLWNhc2UgY2FsbGJhY2tzICovDQo+ICsJ
cGVyZl9idWZmZXJfc2FtcGxlX2ZuIHNhbXBsZV9jYjsNCj4gKwlwZXJmX2J1ZmZlcl9sb3N0X2Zu
IGxvc3RfY2I7DQo+ICsJdm9pZCAqY3R4Ow0KPiArCWludCBjcHVfY250Ow0KPiArCWludCAqY3B1
czsNClsuLi5dDQo+ICsNCj4gK2ludCBwZXJmX2J1ZmZlcl9fcG9sbChzdHJ1Y3QgcGVyZl9idWZm
ZXIgKnBiLCBpbnQgdGltZW91dF9tcykNCj4gK3sNCj4gKwlpbnQgY250LCBlcnI7DQo+ICsNCj4g
KwljbnQgPSBlcG9sbF93YWl0KHBiLT5lcG9sbF9mZCwgcGItPmV2ZW50cywgcGItPmNwdV9jbnQs
IHRpbWVvdXRfbXMpOw0KPiArCWZvciAoaW50IGkgPSAwOyBpIDwgY250OyBpKyspIHsNCg0KRmlu
ZCBvbmUgY29tcGlsYXRpb24gZXJyb3IgaGVyZS4NCg0KbGliYnBmLmM6IEluIGZ1bmN0aW9uIOKA
mHBlcmZfYnVmZmVyX19wb2xs4oCZOg0KbGliYnBmLmM6NDcyODoyOiBlcnJvcjog4oCYZm9y4oCZ
IGxvb3AgaW5pdGlhbCBkZWNsYXJhdGlvbnMgYXJlIG9ubHkgYWxsb3dlZCANCmluIEM5OSBtb2Rl
DQogICBmb3IgKGludCBpID0gMDsgaSA8IGNudDsgaSsrKSB7DQogICBeDQoNCj4gKwkJc3RydWN0
IHBlcmZfY3B1X2J1ZiAqY3B1X2J1ZiA9IHBiLT5ldmVudHNbaV0uZGF0YS5wdHI7DQo+ICsNCj4g
KwkJZXJyID0gcGVyZl9idWZmZXJfX3Byb2Nlc3NfcmVjb3JkcyhwYiwgY3B1X2J1Zik7DQo+ICsJ
CWlmIChlcnIpIHsNCj4gKwkJCXByX3dhcm5pbmcoImVycm9yIHdoaWxlIHByb2Nlc3NpbmcgcmVj
b3JkczogJWRcbiIsIGVycik7DQo+ICsJCQlyZXR1cm4gZXJyOw0KPiArCQl9DQo+ICsJfQ0KPiAr
CXJldHVybiBjbnQgPCAwID8gLWVycm5vIDogY250Ow0KPiArfQ0KPiArDQo+ICAgc3RydWN0IGJw
Zl9wcm9nX2luZm9fYXJyYXlfZGVzYyB7DQo+ICAgCWludAlhcnJheV9vZmZzZXQ7CS8qIGUuZy4g
b2Zmc2V0IG9mIGppdGVkX3Byb2dfaW5zbnMgKi8NCj4gICAJaW50CWNvdW50X29mZnNldDsJLyog
ZS5nLiBvZmZzZXQgb2Ygaml0ZWRfcHJvZ19sZW4gKi8NClsuLi5dDQo=
