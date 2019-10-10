Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEB94D3135
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 21:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbfJJTQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 15:16:36 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:25336 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726489AbfJJTQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 15:16:36 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9AJEsJG023261;
        Thu, 10 Oct 2019 12:15:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=gpo7u+O5ny4yNfM7OI/xQcXqo0X/HpBcn98U3zR/wZE=;
 b=VylCZZbFfz5U66fdm957PldU3xOiYKNh6CRrq6UrHiirXjpjg12p4f2xvmi8kx0QKPiW
 bnhRMNpCGyFI5x+2JjQUKSwHTHx3C4jr4sK4g4imbL7Qb1DA1lFjZVyoFfCxakS5oSKg
 I0F9LQz3ETIg/8Ay+EqrMLoXaMQisXgTxoo= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vhy7hbj2v-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 10 Oct 2019 12:15:09 -0700
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 10 Oct 2019 12:15:08 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 10 Oct 2019 12:15:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J3gU/Z5Yt0aJCDO4jLjMfyBJM3iFj9b2yJO8QhoLYOk9XLWHGxoQJM6GVtAI5IPtvvlPVL4ldVwo1Tzb5ky3ejiGuWSK0f+jrH4y8yrhguN5CQ/KyAjoRBiStE/fVmJWnr0ZoW7C+M8gzMqXoyezVqYQzf4pBz0OPFnUcao8QnwJUa1hhjCL0U0dlVozwqhzvgTnwXAhIwqcO8PAAgG9KEZmmFdimPG8VRMx+XDw9RILe6/yovxt306eyB7Sdi6yp07dum2F81KPBa7HF/Sti+ZnI88CJU0gmqBS8TkR/lD7LB8JpIkJlwiFZJhLjiHJ/OefZes15dCkcqK8adB9nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gpo7u+O5ny4yNfM7OI/xQcXqo0X/HpBcn98U3zR/wZE=;
 b=aK4bKYRZDAUHHE4CmtIARSh32nx+iX+4z4HAbubuBKCpmP1nXqZmwHLgkWcSWQMKOSMVJcOe5CbdgLpSk81C+caeESA4mPj4BgSDu1KUPtckArkLuTMyQ5lOojfrgsuA4wzXH8vLEreB+Yxd1JNL9v3G24agDK7a+i9icvwWpCBavbVN+clpcO5w9l1mpBrLYxCCfozJ+09SIaZ7bsjG92eJ0iU3O/TLlXD9/IfSc9XQiP0qs0YO768oWxG1LpcCQn7M8NgqOsvl5kK4bDXqWonXkYoZFGJ86FbX6PlC7o9cNkeZKfw8RL9gj6gVqBbmA+ue0KNzrVdUlN1w3SaMqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gpo7u+O5ny4yNfM7OI/xQcXqo0X/HpBcn98U3zR/wZE=;
 b=E6LpWzn7kammUzHBWri+w9BlcjmyszXYOSyfQFR6zIj1pTAcN6nd0y5phoHRrhHA4F4091VQh6jiDyX4OufYBZXtestLYZ/m8Rdc+FFWWvZzj0x7NTzBeHKkkQXkQVl+btjy6NYRobqT8+Kn70Cc915cRgNHE+vSuqG+/MibRZY=
Received: from BY5PR15MB3636.namprd15.prod.outlook.com (52.133.252.91) by
 BY5PR15MB3714.namprd15.prod.outlook.com (52.133.252.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Thu, 10 Oct 2019 19:15:06 +0000
Received: from BY5PR15MB3636.namprd15.prod.outlook.com
 ([fe80::7887:4f9c:70df:285c]) by BY5PR15MB3636.namprd15.prod.outlook.com
 ([fe80::7887:4f9c:70df:285c%4]) with mapi id 15.20.2347.016; Thu, 10 Oct 2019
 19:15:06 +0000
From:   Vijay Khemka <vijaykhemka@fb.com>
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Joel Stanley <joel@jms.id.au>,
        Florian Fainelli <f.fainelli@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        YueHaibing <yuehaibing@huawei.com>, Andrew Lunn <andrew@lunn.ch>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "openbmc @ lists . ozlabs . org" <openbmc@lists.ozlabs.org>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>,
        "Sai Dasari" <sdasari@fb.com>
Subject: Re: [PATCH] ftgmac100: Disable HW checksum generation on AST2500
Thread-Topic: [PATCH] ftgmac100: Disable HW checksum generation on AST2500
Thread-Index: AQHVaCL3HHZ/0IxjZ0GB2KAMVKzdAqcld28AgAEYWwCAK1ZcgIACEkcA
Date:   Thu, 10 Oct 2019 19:15:06 +0000
Message-ID: <AF7B985F-6E42-4CD4-B3D0-4B9EA42253C9@fb.com>
References: <20190910213734.3112330-1-vijaykhemka@fb.com>
 <bd5eab2e-6ba6-9e27-54d4-d9534da9d5f7@gmail.com>
 <CACPK8XcS4iKfKigPbPg0BFbmjbT-kdyjiPDXjk1k5XaS5bCdAA@mail.gmail.com>
 <95e215664612c0487808c02232852ef2188c95a5.camel@kernel.crashing.org>
In-Reply-To: <95e215664612c0487808c02232852ef2188c95a5.camel@kernel.crashing.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2620:10d:c090:200::3:7710]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 28bf5bdd-2a55-4b7f-d133-08d74db62950
x-ms-traffictypediagnostic: BY5PR15MB3714:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR15MB3714959FA6127C83F4F7B240DD940@BY5PR15MB3714.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 018632C080
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(396003)(376002)(346002)(39860400002)(189003)(199004)(7416002)(36756003)(6486002)(4326008)(33656002)(5660300002)(6436002)(66446008)(2906002)(64756008)(66556008)(66476007)(8936002)(76116006)(6246003)(91956017)(6116002)(66946007)(6512007)(81156014)(305945005)(7736002)(86362001)(81166006)(8676002)(11346002)(186003)(476003)(256004)(76176011)(46003)(71190400001)(71200400001)(99286004)(229853002)(2616005)(14454004)(478600001)(6506007)(53546011)(102836004)(486006)(446003)(316002)(25786009)(110136005)(54906003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY5PR15MB3714;H:BY5PR15MB3636.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HtRMDOXR41judw596OClkiPN6c5MDr/ivSz1sHNxLgnMGzIDL8UC6oFxz8i/QuJ1ghv46/6G4Xn3368c7gMzIEu4o14lziYpEoVuEbuDRlqmCNb1QYmoAgiPdh+bydCv30tfV8ph9cmZnM6eqipHANPDHxIgGnY/SGH0YULKcFXmcdr6JakTafO/EmEkTvZFavoc488NnliruKTrYrcoUGcYbyuVxjQoW5oqhhiVW4EIuEWI8aqb4tXXeIPvUvH/uO17fokG+lDh4KHn5VuReZZ80YYM+Iq4Aeyr9a/2XsLiZtg2aqz67Lb3XPEgdKjBgNO3DvmGnmOpBOAM+KS14cfKXowaLV7KkP97aiGl//KyzJ4/PZmbVYSjlJsPukUQ+498wl1+IyW4rVQ/BIyieRxVf2kc7cwS8f1GM3rbZUo=
Content-Type: text/plain; charset="utf-8"
Content-ID: <58A3C6651CCA94419BED4AD9D1693B4D@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 28bf5bdd-2a55-4b7f-d133-08d74db62950
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2019 19:15:06.6814
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wZEGjViaJHX1nrx4G4wZKro1lCxvyjdlDIIjaTZIDCp7L1DJlg/jpU9Tr7qudiTlQCPJq+hV5CSuvslEWsRkgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3714
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-10_06:2019-10-10,2019-10-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 adultscore=0 lowpriorityscore=0 mlxlogscore=999 spamscore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 impostorscore=0 phishscore=0
 malwarescore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1910100161
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCu+7v09uIDEwLzgvMTksIDk6MzcgUE0sICJCZW5qYW1pbiBIZXJyZW5zY2htaWR0IiA8YmVu
aEBrZXJuZWwuY3Jhc2hpbmcub3JnPiB3cm90ZToNCg0KICAgIE9uIFdlZCwgMjAxOS0wOS0xMSBh
dCAxNDo0OCArMDAwMCwgSm9lbCBTdGFubGV5IHdyb3RlOg0KICAgID4gSGkgQmVuLA0KICAgID4g
DQogICAgPiBPbiBUdWUsIDEwIFNlcCAyMDE5IGF0IDIyOjA1LCBGbG9yaWFuIEZhaW5lbGxpIDxm
LmZhaW5lbGxpQGdtYWlsLmNvbT4NCiAgICA+IHdyb3RlOg0KICAgID4gPiANCiAgICA+ID4gT24g
OS8xMC8xOSAyOjM3IFBNLCBWaWpheSBLaGVta2Egd3JvdGU6DQogICAgPiA+ID4gSFcgY2hlY2tz
dW0gZ2VuZXJhdGlvbiBpcyBub3Qgd29ya2luZyBmb3IgQVNUMjUwMCwgc3BlY2lhbGx5IHdpdGgN
CiAgICA+ID4gPiBJUFY2DQogICAgPiA+ID4gb3ZlciBOQ1NJLiBBbGwgVENQIHBhY2tldHMgd2l0
aCBJUHY2IGdldCBkcm9wcGVkLiBCeSBkaXNhYmxpbmcNCiAgICA+ID4gPiB0aGlzDQogICAgPiA+
ID4gaXQgd29ya3MgcGVyZmVjdGx5IGZpbmUgd2l0aCBJUFY2Lg0KICAgID4gPiA+IA0KICAgID4g
PiA+IFZlcmlmaWVkIHdpdGggSVBWNiBlbmFibGVkIGFuZCBjYW4gZG8gc3NoLg0KICAgID4gPiAN
CiAgICA+ID4gSG93IGFib3V0IElQdjQsIGRvIHRoZXNlIHBhY2tldHMgaGF2ZSBwcm9ibGVtPyBJ
ZiBub3QsIGNhbiB5b3UNCiAgICA+ID4gY29udGludWUNCiAgICA+ID4gYWR2ZXJ0aXNpbmcgTkVU
SUZfRl9JUF9DU1VNIGJ1dCB0YWtlIG91dCBORVRJRl9GX0lQVjZfQ1NVTT8NCiAgICA+ID4gDQog
ICAgPiA+ID4gDQogICAgPiA+ID4gU2lnbmVkLW9mZi1ieTogVmlqYXkgS2hlbWthIDx2aWpheWto
ZW1rYUBmYi5jb20+DQogICAgPiA+ID4gLS0tDQogICAgPiA+ID4gIGRyaXZlcnMvbmV0L2V0aGVy
bmV0L2ZhcmFkYXkvZnRnbWFjMTAwLmMgfCA1ICsrKy0tDQogICAgPiA+ID4gIDEgZmlsZSBjaGFu
Z2VkLCAzIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQogICAgPiA+ID4gDQogICAgPiA+
ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZhcmFkYXkvZnRnbWFjMTAwLmMN
CiAgICA+ID4gPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZhcmFkYXkvZnRnbWFjMTAwLmMNCiAg
ICA+ID4gPiBpbmRleCAwMzBmZWQ2NTM5M2UuLjU5MWM5NzI1MDAyYiAxMDA2NDQNCiAgICA+ID4g
PiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9mYXJhZGF5L2Z0Z21hYzEwMC5jDQogICAgPiA+
ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvZmFyYWRheS9mdGdtYWMxMDAuYw0KICAgID4g
PiA+IEBAIC0xODM5LDggKzE4MzksOSBAQCBzdGF0aWMgaW50IGZ0Z21hYzEwMF9wcm9iZShzdHJ1
Y3QNCiAgICA+ID4gPiBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpDQogICAgPiA+ID4gICAgICAgaWYg
KHByaXYtPnVzZV9uY3NpKQ0KICAgID4gPiA+ICAgICAgICAgICAgICAgbmV0ZGV2LT5od19mZWF0
dXJlcyB8PSBORVRJRl9GX0hXX1ZMQU5fQ1RBR19GSUxURVI7DQogICAgPiA+ID4gDQogICAgPiA+
ID4gLSAgICAgLyogQVNUMjQwMCAgZG9lc24ndCBoYXZlIHdvcmtpbmcgSFcgY2hlY2tzdW0gZ2Vu
ZXJhdGlvbiAqLw0KICAgID4gPiA+IC0gICAgIGlmIChucCAmJiAob2ZfZGV2aWNlX2lzX2NvbXBh
dGlibGUobnAsICJhc3BlZWQsYXN0MjQwMC0NCiAgICA+ID4gPiBtYWMiKSkpDQogICAgPiA+ID4g
KyAgICAgLyogQVNUMjQwMCAgYW5kIEFTVDI1MDAgZG9lc24ndCBoYXZlIHdvcmtpbmcgSFcgY2hl
Y2tzdW0NCiAgICA+ID4gPiBnZW5lcmF0aW9uICovDQogICAgPiA+ID4gKyAgICAgaWYgKG5wICYm
IChvZl9kZXZpY2VfaXNfY29tcGF0aWJsZShucCwgImFzcGVlZCxhc3QyNDAwLQ0KICAgID4gPiA+
IG1hYyIpIHx8DQogICAgPiA+ID4gKyAgICAgICAgICAgICAgICBvZl9kZXZpY2VfaXNfY29tcGF0
aWJsZShucCwgImFzcGVlZCxhc3QyNTAwLQ0KICAgID4gPiA+IG1hYyIpKSkNCiAgICA+IA0KICAg
ID4gRG8geW91IHJlY2FsbCB1bmRlciB3aGF0IGNpcmN1bXN0YW5jZXMgd2UgbmVlZCB0byBkaXNh
YmxlIGhhcmR3YXJlDQogICAgPiBjaGVja3N1bW1pbmc/DQogICAgDQogICAgQW55IG5ld3Mgb24g
dGhpcyA/IEFTVDI0MDAgaGFzIG5vIEhXIGNoZWNrc3VtIGxvZ2ljIGluIEhXLCBBU1QyNTAwDQog
ICAgc2hvdWxkIHdvcmsgZm9yIElQVjQgZmluZSwgd2Ugc2hvdWxkIG9ubHkgc2VsZWN0aXZlbHkg
ZGlzYWJsZSBpdCBmb3INCiAgICBJUFY2Lg0KDQpCZW4sIEkgaGF2ZSBhbHJlYWR5IHNlbnQgdjIg
Zm9yIHRoaXMgd2l0aCByZXF1ZXN0ZWQgY2hhbmdlIHdoaWNoIG9ubHkgZGlzYWJsZSANCmZvciBJ
UFY2IGluIEFTVDI1MDAuIEkgY2FuIHNlbmQgaXQgYWdhaW4uDQogICAgDQogICAgQ2FuIHlvdSBk
byBhbiB1cGRhdGVkIHBhdGNoID8NCiAgICANCiAgICBDaGVlcnMsDQogICAgQmVuLg0KICAgIA0K
ICAgIA0KDQo=
