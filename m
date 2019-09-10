Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81D3AAF322
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 01:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbfIJXI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 19:08:28 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:31472 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725932AbfIJXI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 19:08:28 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8AN5Dgu026526;
        Tue, 10 Sep 2019 16:07:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=caZXJVJg6ZKsInjrzU5gAgF+aIGZUURESK6+ZQjKpV8=;
 b=Qfuh0Nk78+kDin9r7Otqs1Kl3Qcg8csi9AqyxouY4rJwT2J3w16VVhfR5Unz1a9ya5bB
 hugAOcykDTgKTj/1EUV/X1cfBfDWefR51DxOnnKNzwgpUP7CzinxLUqt4GtNXf6ouM2/
 tNk4MsLQ3Oz9c6ewk6xTXO3lH9wkpKynY2s= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2ux371d735-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 10 Sep 2019 16:07:22 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 10 Sep 2019 16:07:21 -0700
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 10 Sep 2019 16:07:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YuQvOahx3h4NpjzW1sIEoYK6Riv0TnB3720lEivxWTRDHuzNHq6lRCo5ja1H9wEi/JmCbcjLe/zuJMCt9buGoz7OLxlIgueMZq+6RupQvIoE3+Jv8gXdXvH4pqaFX6hriMbUjbAlLaR94tSTv/BYzne1/kjo9BucJ1tGgy1cP37TgUHPfq3oeRHEMuGVto5FpDxP46W+YMU9xd/P759+yCsKDrBd2mIz1BAfENpaoEPKhh0NYu3CO+uqYElDTcDFNYRRPFT7Y0KHMuQq1qaBnblqae+XdGojq1184w0PkBtp24q9epIa2yKtMPEKu7yHG8njTldlXkGeoIB4pXU2wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=caZXJVJg6ZKsInjrzU5gAgF+aIGZUURESK6+ZQjKpV8=;
 b=BAKMHMYWAE/hw1uxFIF/6gw0I9D6rqZmUBJwB9S6yObFdvxy2ONa3yi+vEXHseAxGXA2iOMUNs9xYb0bnfVC6Bli9WMN/nIBMLl0oCtQJOPnmKvXUksrIwB0ErbII1Bsxr2memr1UlTgmeVRp9BzQJLdyhXLUJiDwGIJi9SVUN597RlUM18LuGT2owfq5fpardM2xhExoXd+MdZPs3VZmas/ofiULFtwEK5IV/LFxcgpOWE/ZNla3A2OLliUyOHWS7Ia9GY3ZT6pu9s0ClmQmRX5xsWXvXKfbol3TLDtCATKkWu2Kt0AgNIIirMNWDK4p7PU3BkP3k8bPcQXATNY4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=caZXJVJg6ZKsInjrzU5gAgF+aIGZUURESK6+ZQjKpV8=;
 b=IXzlP4Sc7gTnUWw/NagwVowpAaFSTqRBjyVtl7wk/gL6QKZ9rCyiGDLRjF6jgRBjDNPmssgFn50yf6NfooxySGY0XsRR/7Ke/koPehwqj3uCaiahC54pcv0xFMnyDfne44RQCrpj30uz70uWiD4hMQn1sGJD5XOL0FfCFG5SDOA=
Received: from CY4PR15MB1269.namprd15.prod.outlook.com (10.172.177.11) by
 CY4PR15MB1814.namprd15.prod.outlook.com (10.172.77.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.13; Tue, 10 Sep 2019 23:07:21 +0000
Received: from CY4PR15MB1269.namprd15.prod.outlook.com
 ([fe80::38b1:336:13e6:b02b]) by CY4PR15MB1269.namprd15.prod.outlook.com
 ([fe80::38b1:336:13e6:b02b%7]) with mapi id 15.20.2241.018; Tue, 10 Sep 2019
 23:07:21 +0000
From:   Vijay Khemka <vijaykhemka@fb.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        YueHaibing <yuehaibing@huawei.com>, Andrew Lunn <andrew@lunn.ch>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        "Mauro Carvalho Chehab" <mchehab+samsung@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "openbmc @ lists . ozlabs . org" <openbmc@lists.ozlabs.org>,
        Sai Dasari <sdasari@fb.com>,
        "linux-aspeed@lists.ozlabs.org" <linux-aspeed@lists.ozlabs.org>
Subject: Re: [PATCH] ftgmac100: Disable HW checksum generation on AST2500
Thread-Topic: [PATCH] ftgmac100: Disable HW checksum generation on AST2500
Thread-Index: AQHVaCL3HHZ/0IxjZ0GB2KAMVKzdAqcld28A//+WvACAAAU0AA==
Date:   Tue, 10 Sep 2019 23:07:20 +0000
Message-ID: <D79D04CC-4A02-4E51-8FDF-48B7C7EB6CC2@fb.com>
References: <20190910213734.3112330-1-vijaykhemka@fb.com>
 <bd5eab2e-6ba6-9e27-54d4-d9534da9d5f7@gmail.com>
 <0797B1F1-883D-4129-AC16-794957ACCF1B@fb.com>
In-Reply-To: <0797B1F1-883D-4129-AC16-794957ACCF1B@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2620:10d:c090:200::2:1b73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2516618c-912e-4aaf-f153-08d73643a251
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:CY4PR15MB1814;
x-ms-traffictypediagnostic: CY4PR15MB1814:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR15MB1814B9912076B64D9E479F68DDB60@CY4PR15MB1814.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 01565FED4C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(136003)(396003)(366004)(376002)(39860400002)(189003)(199004)(33656002)(11346002)(14444005)(256004)(446003)(53546011)(6506007)(2616005)(46003)(66556008)(66946007)(64756008)(66446008)(66476007)(8676002)(81156014)(81166006)(486006)(476003)(2501003)(8936002)(71200400001)(102836004)(186003)(76116006)(91956017)(54906003)(71190400001)(4326008)(229853002)(110136005)(478600001)(316002)(6436002)(36756003)(99286004)(7416002)(5660300002)(2201001)(305945005)(2906002)(14454004)(76176011)(25786009)(53936002)(7736002)(86362001)(6246003)(6116002)(6486002)(6512007)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR15MB1814;H:CY4PR15MB1269.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 3xiEvixdPP4GvyTwkMJ2cHpru4vwzXzDI57iEkTRFnPC5e1wte04383CCK1Gj06fvK8/KaWfZuScGdUC1g40Q6iWcrlZEaodEIcF/spWhwQ1CgdeN+uScymlKX+mh2Hn5L+5qCcOSqBPmTyLoLmW5PsGHcAztbUK271EvNFu9nhKoIJyjUPaygyGGp/uM5IXmWeNoF3g7untlpuOUPDy4St2cIu6W9QxMzx6JckY1AqZjmO8W3BP6ujWqt8xmAxxmCsV4kQ5LMbsy9LFe7aNcuVIG0uvblHv/bz1txoICyzrX1C4tOgrRf2jV/NBAhBJ0r8khq/Fz+SRynQjTwKLqbTIIr/cPPbSL2+UuyVKuQYyixDcOxrrPxfnHW1YYyZepRNbaqnaGvDUTwgExgzx5lZOuNLVtxyan0+N6e9uxA0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <36E2D267A9EE7F4993D03253AA6A5429@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2516618c-912e-4aaf-f153-08d73643a251
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2019 23:07:20.8623
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: szQ1BVXicYpmHrJe3kDFRq75gna7K6PlOuCldWKQKBbtFVQlmYVJlp/cyVgwq+xbbpH/N5VguvKPr2x4A4xW5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1814
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-10_12:2019-09-10,2019-09-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 clxscore=1015
 bulkscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909100215
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCu+7v09uIDkvMTAvMTksIDM6NTAgUE0sICJMaW51eC1hc3BlZWQgb24gYmVoYWxmIG9mIFZp
amF5IEtoZW1rYSIgPGxpbnV4LWFzcGVlZC1ib3VuY2VzK3ZpamF5a2hlbWthPWZiLmNvbUBsaXN0
cy5vemxhYnMub3JnIG9uIGJlaGFsZiBvZiB2aWpheWtoZW1rYUBmYi5jb20+IHdyb3RlOg0KDQog
ICAgDQogICAgDQogICAgT24gOS8xMC8xOSwgMzowNSBQTSwgIkZsb3JpYW4gRmFpbmVsbGkiIDxm
LmZhaW5lbGxpQGdtYWlsLmNvbT4gd3JvdGU6DQogICAgDQogICAgICAgIE9uIDkvMTAvMTkgMjoz
NyBQTSwgVmlqYXkgS2hlbWthIHdyb3RlOg0KICAgICAgICA+IEhXIGNoZWNrc3VtIGdlbmVyYXRp
b24gaXMgbm90IHdvcmtpbmcgZm9yIEFTVDI1MDAsIHNwZWNpYWxseSB3aXRoIElQVjYNCiAgICAg
ICAgPiBvdmVyIE5DU0kuIEFsbCBUQ1AgcGFja2V0cyB3aXRoIElQdjYgZ2V0IGRyb3BwZWQuIEJ5
IGRpc2FibGluZyB0aGlzDQogICAgICAgID4gaXQgd29ya3MgcGVyZmVjdGx5IGZpbmUgd2l0aCBJ
UFY2Lg0KICAgICAgICA+IA0KICAgICAgICA+IFZlcmlmaWVkIHdpdGggSVBWNiBlbmFibGVkIGFu
ZCBjYW4gZG8gc3NoLg0KICAgICAgICANCiAgICAgICAgSG93IGFib3V0IElQdjQsIGRvIHRoZXNl
IHBhY2tldHMgaGF2ZSBwcm9ibGVtPyBJZiBub3QsIGNhbiB5b3UgY29udGludWUNCiAgICAgICAg
YWR2ZXJ0aXNpbmcgTkVUSUZfRl9JUF9DU1VNIGJ1dCB0YWtlIG91dCBORVRJRl9GX0lQVjZfQ1NV
TT8NCiAgICANCiAgICBJIGNoYW5nZWQgY29kZSBmcm9tIChuZXRkZXYtPmh3X2ZlYXR1cmVzICY9
IH5ORVRJRl9GX0hXX0NTVU0pIHRvIA0KICAgIChuZXRkZXYtPmh3X2ZlYXR1cmVzICY9IH5ORVRJ
Rl9GXyBJUFY2X0NTVU0pLiBBbmQgaXQgaXMgbm90IHdvcmtpbmcuIA0KICAgIERvbid0IGtub3cg
d2h5LiBJUFY0IHdvcmtzIHdpdGhvdXQgYW55IGNoYW5nZSBidXQgSVB2NiBuZWVkcyBIV19DU1VN
DQogICAgRGlzYWJsZWQuDQoNCk5vdyBJIGNoYW5nZWQgdG8NCm5ldGRldi0+aHdfZmVhdHVyZXMg
Jj0gKH5ORVRJRl9GX0hXX0NTVU0pIHwgTkVUSUZfRl9JUF9DU1VNOw0KQW5kIGl0IHdvcmtzLg0K
ICAgICAgICANCiAgICAgICAgPiANCiAgICAgICAgPiBTaWduZWQtb2ZmLWJ5OiBWaWpheSBLaGVt
a2EgPHZpamF5a2hlbWthQGZiLmNvbT4NCiAgICAgICAgPiAtLS0NCiAgICAgICAgPiAgZHJpdmVy
cy9uZXQvZXRoZXJuZXQvZmFyYWRheS9mdGdtYWMxMDAuYyB8IDUgKysrLS0NCiAgICAgICAgPiAg
MSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCiAgICAgICAg
PiANCiAgICAgICAgPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvZmFyYWRheS9m
dGdtYWMxMDAuYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZhcmFkYXkvZnRnbWFjMTAwLmMNCiAg
ICAgICAgPiBpbmRleCAwMzBmZWQ2NTM5M2UuLjU5MWM5NzI1MDAyYiAxMDA2NDQNCiAgICAgICAg
PiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9mYXJhZGF5L2Z0Z21hYzEwMC5jDQogICAgICAg
ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvZmFyYWRheS9mdGdtYWMxMDAuYw0KICAgICAg
ICA+IEBAIC0xODM5LDggKzE4MzksOSBAQCBzdGF0aWMgaW50IGZ0Z21hYzEwMF9wcm9iZShzdHJ1
Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQ0KICAgICAgICA+ICAJaWYgKHByaXYtPnVzZV9uY3Np
KQ0KICAgICAgICA+ICAJCW5ldGRldi0+aHdfZmVhdHVyZXMgfD0gTkVUSUZfRl9IV19WTEFOX0NU
QUdfRklMVEVSOw0KICAgICAgICA+ICANCiAgICAgICAgPiAtCS8qIEFTVDI0MDAgIGRvZXNuJ3Qg
aGF2ZSB3b3JraW5nIEhXIGNoZWNrc3VtIGdlbmVyYXRpb24gKi8NCiAgICAgICAgPiAtCWlmIChu
cCAmJiAob2ZfZGV2aWNlX2lzX2NvbXBhdGlibGUobnAsICJhc3BlZWQsYXN0MjQwMC1tYWMiKSkp
DQogICAgICAgID4gKwkvKiBBU1QyNDAwICBhbmQgQVNUMjUwMCBkb2Vzbid0IGhhdmUgd29ya2lu
ZyBIVyBjaGVja3N1bSBnZW5lcmF0aW9uICovDQogICAgICAgID4gKwlpZiAobnAgJiYgKG9mX2Rl
dmljZV9pc19jb21wYXRpYmxlKG5wLCAiYXNwZWVkLGFzdDI0MDAtbWFjIikgfHwNCiAgICAgICAg
PiArCQkgICBvZl9kZXZpY2VfaXNfY29tcGF0aWJsZShucCwgImFzcGVlZCxhc3QyNTAwLW1hYyIp
KSkNCiAgICAgICAgPiAgCQluZXRkZXYtPmh3X2ZlYXR1cmVzICY9IH5ORVRJRl9GX0hXX0NTVU07
DQogICAgICAgID4gIAlpZiAobnAgJiYgb2ZfZ2V0X3Byb3BlcnR5KG5wLCAibm8taHctY2hlY2tz
dW0iLCBOVUxMKSkNCiAgICAgICAgPiAgCQluZXRkZXYtPmh3X2ZlYXR1cmVzICY9IH4oTkVUSUZf
Rl9IV19DU1VNIHwgTkVUSUZfRl9SWENTVU0pOw0KICAgICAgICA+IA0KICAgICAgICANCiAgICAg
ICAgDQogICAgICAgIC0tIA0KICAgICAgICBGbG9yaWFuDQogICAgICAgIA0KICAgIA0KICAgIA0K
DQo=
