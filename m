Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 478B5B0441
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 20:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730214AbfIKSwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 14:52:14 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:22480 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729758AbfIKSwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 14:52:14 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x8BIkwMk022615;
        Wed, 11 Sep 2019 11:51:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Psmjm4TrrjahD1mccl3eyjBfOgfZTuFXftlDbmifvpU=;
 b=alZY/QHOFiL+gZynVDXPbhLaGqxB4rDolLz1HXxq0ivFqabmuTT/phGeJoiiZRZ81Mcz
 Ayk8j34ULiask0AZX6th7DtiQ1RBnOSJo0BPK6QPZV3URTsrBW0Q4KFXDXEaGVl2fnbM
 7B0E7aOhT0OY6owR3kuxC7wLfUXStqDRIkM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2uy2yah581-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 11 Sep 2019 11:51:05 -0700
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 11 Sep 2019 11:50:42 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 11 Sep 2019 11:50:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jDE8FNWuPzTyCvlHV53PbVJQyUAUCBPIKQsjOSWKOxkEEFmhrQCbCL3VexuedgRI5ojexQlQ76ZVEFnlzRWOGYyJ7F67XrfSDTjHhpsNGT00P7EPXoEUmMEYOE3dFU3UaM0dLS7MAHiM1CLvcxnXOK3+sQqzffx+kJ80vDjFWIkBGIbz9Iq/rQoAGk8g4pzqqkgSm4lNvHvqIq8rEgmoKkQnl0OkLToTsk1Ath53ruGjRKr5CiqNItuH/GI+cm2YITW0ggjW7pJvjQisREYhBFG6AamfHNOe85fvabJroM/CYFSOhrx0AQu+3R4RDt8UW9uOJ7QrNUNsoRWjEMJXnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Psmjm4TrrjahD1mccl3eyjBfOgfZTuFXftlDbmifvpU=;
 b=TG1P2I1qY5F7tgyBAuxbQwV/deWQJio9hQatMuFkda8cUiXDgP+DoDEccD19ltKCeCXWXCM3d8G3FfTJsIyK5o1DVcAUjeg7MNk5yzLCZKn9ub5CAvYd3dgbx9qZeEaF0awChq1d5ohqArN/hBSqfEEHI6vDXecK+CCeJ6O3nZrCiE/J+IPn/aXDG/Wz+/Ya+yjDARZiQsLCrj7wQj+Bs0IhVDbUFGk/T88GyTACkT7ID7gZBYf1V/3fjFffyWydUhcNeo2HLOm9D76d5kZoxoZ5Ui5amcoYDOqXXn1k0FXsxJ99qCiq/2pAnnatRhHCbBXq6MPnQXWIQ9qphRr6PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Psmjm4TrrjahD1mccl3eyjBfOgfZTuFXftlDbmifvpU=;
 b=HKmG0ZbemNVo1UQHVuZ/ScHySNxPH97iKlaUoaLI0wFi0e/O0DRgFmo1amsKfI9XERF7cgbSi/fohluUB8gsNf/OP7wcNKq/hUyXMGh3GeCO3nteE/DGtQID8J5tUJWw5ZMNgxj+gp4kFMheoDEtfMT1RUwBJ1wfvS+F/grsBZE=
Received: from CY4PR15MB1269.namprd15.prod.outlook.com (10.172.177.11) by
 CY4PR15MB1304.namprd15.prod.outlook.com (10.172.181.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.19; Wed, 11 Sep 2019 18:50:41 +0000
Received: from CY4PR15MB1269.namprd15.prod.outlook.com
 ([fe80::38b1:336:13e6:b02b]) by CY4PR15MB1269.namprd15.prod.outlook.com
 ([fe80::38b1:336:13e6:b02b%7]) with mapi id 15.20.2241.018; Wed, 11 Sep 2019
 18:50:41 +0000
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
Thread-Index: AQHVaCL3HHZ/0IxjZ0GB2KAMVKzdAqcld28A//+WvACAAAU0AIABRQWAgAB2ZwD//48zAA==
Date:   Wed, 11 Sep 2019 18:50:41 +0000
Message-ID: <76733CEB-14E1-4158-B642-5B7F74F97DE4@fb.com>
References: <20190910213734.3112330-1-vijaykhemka@fb.com>
 <bd5eab2e-6ba6-9e27-54d4-d9534da9d5f7@gmail.com>
 <0797B1F1-883D-4129-AC16-794957ACCF1B@fb.com>
 <D79D04CC-4A02-4E51-8FDF-48B7C7EB6CC2@fb.com>
 <8A8392C8-5E5E-444D-AB1B-E0FAD3C29425@fb.com>
 <c9876340-c8d0-ba8b-2ae1-9900958f1834@gmail.com>
In-Reply-To: <c9876340-c8d0-ba8b-2ae1-9900958f1834@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2620:10d:c090:200::1:a2f5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: da7b063a-a3c6-4c08-6c53-08d736e8f1c7
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CY4PR15MB1304;
x-ms-traffictypediagnostic: CY4PR15MB1304:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR15MB1304E623E5374FE58F3A066DDDB10@CY4PR15MB1304.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0157DEB61B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(39860400002)(376002)(396003)(366004)(346002)(199004)(189003)(76176011)(81166006)(7736002)(81156014)(2616005)(11346002)(6512007)(53546011)(6246003)(6506007)(53936002)(99286004)(476003)(71190400001)(71200400001)(486006)(4326008)(316002)(25786009)(446003)(2201001)(110136005)(54906003)(36756003)(305945005)(478600001)(46003)(14444005)(91956017)(6116002)(256004)(186003)(2501003)(6436002)(102836004)(8676002)(5660300002)(2906002)(14454004)(33656002)(66556008)(66446008)(66476007)(66946007)(229853002)(86362001)(64756008)(8936002)(6486002)(76116006)(7416002)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR15MB1304;H:CY4PR15MB1269.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: eDfDMmzBEHkpQUiSblesHmXpsgQaKkao/mx12Nriwrk0sfAXXF8RnRH44oPCu2Lx2BhW6zJ5qmZ6FINGq2HjKEGJ3iu5CTm1MGYA9+yYrs9ZWkDecwd4R6FBqZYrdH3yGwWojv+/IJSWHtWw+ZxGmgJWp94KKYDsRE1vkNDIObQecbfSYnMSnZAxhwCtwtAI5aRQWuGNLH03eSw6W/s/zd+CbrrF6h+WYZajQNA87mgxHcbUg0wy6lskuhVDA/HBDxBqrSbQPamZ+SEzgCcc13VRJ8sw7bLUM1ZrivvOCMmWfd1MgRzw2S1OptrhPwHPA2OYFYxaISiFxHF1uqSMJ5FJvdYk7+5oXBJgBrBWGLx95oIWqMbwhjg2S915P9wQO190xSW9g7YvWzRhnqZH3ZRbXz2nyP7B408KAfn11+E=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CF91FAE597BD7049BC70796950CBA69C@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: da7b063a-a3c6-4c08-6c53-08d736e8f1c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2019 18:50:41.1906
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kmnSXSt+Zl4dM0Ka29PooPFdPMK4avCERRzLJwdG7cNY1pW4uowEff1nFCqu/xOnRdrkjkSaOalzse7MWlTLJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1304
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-11_08:2019-09-11,2019-09-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 clxscore=1015 mlxscore=0 impostorscore=0 spamscore=0 lowpriorityscore=0
 suspectscore=0 adultscore=0 phishscore=0 priorityscore=1501 bulkscore=0
 mlxlogscore=428 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909110171
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCu+7v09uIDkvMTEvMTksIDExOjM0IEFNLCAiRmxvcmlhbiBGYWluZWxsaSIgPGYuZmFpbmVs
bGlAZ21haWwuY29tPiB3cm90ZToNCg0KICAgIE9uIDkvMTEvMTkgMTE6MzAgQU0sIFZpamF5IEto
ZW1rYSB3cm90ZToNCiAgICA+IA0KICAgID4gDQogICAgPiBPbiA5LzEwLzE5LCA0OjA4IFBNLCAi
TGludXgtYXNwZWVkIG9uIGJlaGFsZiBvZiBWaWpheSBLaGVta2EiIDxsaW51eC1hc3BlZWQtYm91
bmNlcyt2aWpheWtoZW1rYT1mYi5jb21AbGlzdHMub3psYWJzLm9yZyBvbiBiZWhhbGYgb2Ygdmlq
YXlraGVta2FAZmIuY29tPiB3cm90ZToNCiAgICA+IA0KICAgID4gICAgIA0KICAgID4gICAgIA0K
ICAgID4gICAgIE9uIDkvMTAvMTksIDM6NTAgUE0sICJMaW51eC1hc3BlZWQgb24gYmVoYWxmIG9m
IFZpamF5IEtoZW1rYSIgPGxpbnV4LWFzcGVlZC1ib3VuY2VzK3ZpamF5a2hlbWthPWZiLmNvbUBs
aXN0cy5vemxhYnMub3JnIG9uIGJlaGFsZiBvZiB2aWpheWtoZW1rYUBmYi5jb20+IHdyb3RlOg0K
ICAgID4gICAgIA0KICAgID4gICAgICAgICANCiAgICA+ICAgICAgICAgDQogICAgPiAgICAgICAg
IE9uIDkvMTAvMTksIDM6MDUgUE0sICJGbG9yaWFuIEZhaW5lbGxpIiA8Zi5mYWluZWxsaUBnbWFp
bC5jb20+IHdyb3RlOg0KICAgID4gICAgICAgICANCiAgICA+ICAgICAgICAgICAgIE9uIDkvMTAv
MTkgMjozNyBQTSwgVmlqYXkgS2hlbWthIHdyb3RlOg0KICAgID4gICAgICAgICAgICAgPiBIVyBj
aGVja3N1bSBnZW5lcmF0aW9uIGlzIG5vdCB3b3JraW5nIGZvciBBU1QyNTAwLCBzcGVjaWFsbHkg
d2l0aCBJUFY2DQogICAgPiAgICAgICAgICAgICA+IG92ZXIgTkNTSS4gQWxsIFRDUCBwYWNrZXRz
IHdpdGggSVB2NiBnZXQgZHJvcHBlZC4gQnkgZGlzYWJsaW5nIHRoaXMNCiAgICA+ICAgICAgICAg
ICAgID4gaXQgd29ya3MgcGVyZmVjdGx5IGZpbmUgd2l0aCBJUFY2Lg0KICAgID4gICAgICAgICAg
ICAgPiANCiAgICA+ICAgICAgICAgICAgID4gVmVyaWZpZWQgd2l0aCBJUFY2IGVuYWJsZWQgYW5k
IGNhbiBkbyBzc2guDQogICAgPiAgICAgICAgICAgICANCiAgICA+ICAgICAgICAgICAgIEhvdyBh
Ym91dCBJUHY0LCBkbyB0aGVzZSBwYWNrZXRzIGhhdmUgcHJvYmxlbT8gSWYgbm90LCBjYW4geW91
IGNvbnRpbnVlDQogICAgPiAgICAgICAgICAgICBhZHZlcnRpc2luZyBORVRJRl9GX0lQX0NTVU0g
YnV0IHRha2Ugb3V0IE5FVElGX0ZfSVBWNl9DU1VNPw0KICAgID4gICAgICAgICANCiAgICA+ICAg
ICAgICAgSSBjaGFuZ2VkIGNvZGUgZnJvbSAobmV0ZGV2LT5od19mZWF0dXJlcyAmPSB+TkVUSUZf
Rl9IV19DU1VNKSB0byANCiAgICA+ICAgICAgICAgKG5ldGRldi0+aHdfZmVhdHVyZXMgJj0gfk5F
VElGX0ZfIElQVjZfQ1NVTSkuIEFuZCBpdCBpcyBub3Qgd29ya2luZy4gDQogICAgPiAgICAgICAg
IERvbid0IGtub3cgd2h5LiBJUFY0IHdvcmtzIHdpdGhvdXQgYW55IGNoYW5nZSBidXQgSVB2NiBu
ZWVkcyBIV19DU1VNDQogICAgPiAgICAgICAgIERpc2FibGVkLg0KICAgID4gICAgIA0KICAgID4g
ICAgIE5vdyBJIGNoYW5nZWQgdG8NCiAgICA+ICAgICBuZXRkZXYtPmh3X2ZlYXR1cmVzICY9ICh+
TkVUSUZfRl9IV19DU1VNKSB8IE5FVElGX0ZfSVBfQ1NVTTsNCiAgICA+ICAgICBBbmQgaXQgd29y
a3MuDQogICAgPiANCiAgICA+IEkgaW52ZXN0aWdhdGVkIG1vcmUgb24gdGhlc2UgZmVhdHVyZXMg
YW5kIGZvdW5kIHRoYXQgd2UgY2Fubm90IHNldCBORVRJRl9GX0lQX0NTVU0gDQogICAgPiBXaGls
ZSBORVRJRl9GX0hXX0NTVU0gaXMgc2V0LiBTbyBJIGRpc2FibGVkIE5FVElGX0ZfSFdfQ1NVTSBm
aXJzdCBhbmQgZW5hYmxlZA0KICAgID4gTkVUSUZfRl9JUF9DU1VNIGluIG5leHQgc3RhdGVtZW50
LiBBbmQgaXQgd29ya3MgZmluZS4NCiAgICA+IA0KICAgID4gQnV0IGFzIHBlciBsaW5lIDE2NiBp
biBpbmNsdWRlL2xpbnV4L3NrYnVmZi5oLCAgDQogICAgPiAqICAgTkVUSUZfRl9JUF9DU1VNIGFu
ZCBORVRJRl9GX0lQVjZfQ1NVTSBhcmUgYmVpbmcgZGVwcmVjYXRlZCBpbiBmYXZvciBvZg0KICAg
ID4gICogICBORVRJRl9GX0hXX0NTVU0uIE5ldyBkZXZpY2VzIHNob3VsZCB1c2UgTkVUSUZfRl9I
V19DU1VNIHRvIGluZGljYXRlDQogICAgPiAgKiAgIGNoZWNrc3VtIG9mZmxvYWQgY2FwYWJpbGl0
eS4NCiAgICA+IA0KICAgID4gUGxlYXNlIHN1Z2dlc3Qgd2hpY2ggb2YgYmVsb3cgMiBJIHNob3Vs
ZCBkby4gQXMgYm90aCB3b3JrcyBmb3IgbWUuDQogICAgPiAxLiBEaXNhYmxlIGNvbXBsZXRlbHkg
TkVUSUZfRl9IV19DU1VNIGFuZCBkbyBub3RoaW5nLiBUaGlzIGlzIG9yaWdpbmFsIHBhdGNoLg0K
ICAgID4gMi4gRW5hYmxlIE5FVElGX0ZfSVBfQ1NVTSBpbiBhZGRpdGlvbiB0byAxLiBJIGNhbiBo
YXZlIHYyIGlmIHRoaXMgaXMgYWNjZXB0ZWQuDQogICAgDQogICAgU291bmRzIGxpa2UgMiB3b3Vs
ZCBsZWF2ZSB0aGUgb3B0aW9uIG9mIG9mZmxvYWRpbmcgSVB2NCBjaGVja3N1bQ0KICAgIG9mZmxv
YWQsIHNvIHRoYXQgd291bGQgYmUgYSBiZXR0ZXIgbWlkZGxlIGdyb3VwIHRoYW4gZmxhdCBvdXQg
ZGlzYWJsZQ0KICAgIGNoZWNrc3VtIG9mZmxvYWQgZm9yIGJvdGggSVB2NCBhbmQgSVB2Niwgbm8/
DQpTb3VuZHMgZ29vZCwgSSB3aWxsIGhhdmUgdjIgYWZ0ZXIgbG90IG1vcmUgdGVzdGluZy4NCiAg
ICAtLSANCiAgICBGbG9yaWFuDQogICAgDQoNCg==
