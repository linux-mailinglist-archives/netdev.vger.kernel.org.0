Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73525B03A8
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 20:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729952AbfIKSbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 14:31:50 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51366 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729867AbfIKSbu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 14:31:50 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x8BIOd6Z003756;
        Wed, 11 Sep 2019 11:30:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=DaSnG84fOeVnTagzS96/J+Gcybol5OaLrT2g0dqlkxM=;
 b=Up9MxaxLdZpl8/Q7bFrpGLPo0gfEn8FwvnK2/5+6Ywi0WRDQxMmv+5b+2IyUDziHBPaD
 lcjFgwqql4HWqXohdg3xNxTDoRRbkd0UrjJGscF4U9g3yoXJaAI7wSA9wWHzSR3byEDw
 zUNz+Cd4ULcTwiSx/mDQCvY9qV0LFSRkfJY= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2uy315s2m1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 11 Sep 2019 11:30:41 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 11 Sep 2019 11:30:40 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 11 Sep 2019 11:30:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lD1oZWNv5gHyfywMIoVgxLX+4/TAr2nG0sgYyX5KbJbzMM+ACy6XRT3ExRg7udXhdsabEFPyvQ0Xd97sPPyuQ79XC+LcgzeFHp82X3ksjYyJuY/Pv0NYs1dHogCx/O2vSAywv3ncQUwYb/yYBRyXJYh/WSMlDwdXqPcJNRCzQ90oqTP9lVZC7tH78ThqB9TRkdnWJyRkW1zxlEcQjZuKyhloi5Etz2yRGNVPLcHrcW+YINW87rWrhPG3FVpbdXgS5NB+lE9xAbqI5L7G/HwAZUjpWfmfjobD4KPPpIjliT8Gl4xM8ihhIv7yeYrmVuoHbmLzXXktysS3H4+aZQdslQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DaSnG84fOeVnTagzS96/J+Gcybol5OaLrT2g0dqlkxM=;
 b=ALxKnnev0FY5q5huaUK7h2saJGVaIl0M+rIBu4fN9pGulMGGh2Aa+Arw4NfsWDoQP7PhZaXiXhEd0d8j/7WMuv66bn5cYX67hf2mKgQDfdGhdwnYekQu/msO1TQ/LknA+NlyxL7HgcR+pv+IzvicFZ9ewmWRmXPpjwp8VHnhWaUIv1KKXmfzuufqHum5Z3hvIwEFY4Mamol+XopQBHhwaWrcACFBt49g2h67P0omp+4pJfzTKkXqxldu8l1SxKII80+GRObWrGIbtj6ShoMxBzV7W6mivYCfcSAYR8WEsfWfklqW1MKJ8qt0pL0qtBC0LoLbYF+k+EnoRnTyAf4Qqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DaSnG84fOeVnTagzS96/J+Gcybol5OaLrT2g0dqlkxM=;
 b=DKZHGXrd8YbsV6eGQl+BozTKnm+EPso7GR28nvLibANKpKYhnwekJHmawluCy2aywnFDe45W9hUXnb8S5frbmioDMVpWyLccz7rEhUBBqRCSaBRLoP7FBMX3xlRXAeeCmomYxOfVu8pwZMUMdUfLPqQMGAM4uTPfuxpronwfkmg=
Received: from CY4PR15MB1269.namprd15.prod.outlook.com (10.172.177.11) by
 CY4PR15MB1640.namprd15.prod.outlook.com (10.175.120.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.15; Wed, 11 Sep 2019 18:30:38 +0000
Received: from CY4PR15MB1269.namprd15.prod.outlook.com
 ([fe80::38b1:336:13e6:b02b]) by CY4PR15MB1269.namprd15.prod.outlook.com
 ([fe80::38b1:336:13e6:b02b%7]) with mapi id 15.20.2241.018; Wed, 11 Sep 2019
 18:30:38 +0000
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
Thread-Index: AQHVaCL3HHZ/0IxjZ0GB2KAMVKzdAqcld28A//+WvACAAAU0AIABRQWA
Date:   Wed, 11 Sep 2019 18:30:38 +0000
Message-ID: <8A8392C8-5E5E-444D-AB1B-E0FAD3C29425@fb.com>
References: <20190910213734.3112330-1-vijaykhemka@fb.com>
 <bd5eab2e-6ba6-9e27-54d4-d9534da9d5f7@gmail.com>
 <0797B1F1-883D-4129-AC16-794957ACCF1B@fb.com>
 <D79D04CC-4A02-4E51-8FDF-48B7C7EB6CC2@fb.com>
In-Reply-To: <D79D04CC-4A02-4E51-8FDF-48B7C7EB6CC2@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2620:10d:c090:200::1:a2f5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 347985eb-efe9-4e4f-315b-08d736e624f7
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CY4PR15MB1640;
x-ms-traffictypediagnostic: CY4PR15MB1640:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR15MB164076137D6C3E28571F107EDDB10@CY4PR15MB1640.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0157DEB61B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(396003)(136003)(376002)(39860400002)(189003)(199004)(71190400001)(71200400001)(8676002)(2501003)(25786009)(5660300002)(6246003)(14444005)(316002)(54906003)(102836004)(36756003)(256004)(110136005)(478600001)(229853002)(81166006)(186003)(81156014)(4326008)(33656002)(6116002)(2906002)(6436002)(66946007)(6512007)(6486002)(91956017)(6506007)(66446008)(66476007)(66556008)(76116006)(86362001)(7736002)(64756008)(8936002)(53936002)(2201001)(53546011)(476003)(7416002)(99286004)(486006)(46003)(446003)(11346002)(14454004)(76176011)(305945005)(2616005)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR15MB1640;H:CY4PR15MB1269.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: auFjN3b8vj8jLLhI05oZw2wyyZFaVIf6nz1Hm74qmaIzsLkYfeh2zUrGuDqWAmWQg3yJ0+lCl3YLi3+IBALe8DK36waFo2erQrmNPw72ODyEaEq7YD8iIkp+MCgAEjiZZZf91yMbA2VZlp0ENu0LmlHvjnBmCMwmUKEbhMbaH+YA+dLZHYS1XMm7c/IgVYwbSWUZNWl+SyvOlg5Y5+09b3i1Wbc8+8e5riPAd4m9iscNdP90T8tSn+MvCrhRnq43L3qa/MglvkDrap+lba8VbLi7I7vJgk2qSKAW5ebFgqqzFFKSKlLftbwQB5c6m2sO/Da3h2H1RjohPLRTTcmf9QgWhZ/jUoBxU1cW9WAGd2P0Doblw6ZiYHSsJ/RwWowAjsol1oKuZ78ehkrPbAfVfhslAn233oFNWt2twLTLLGs=
Content-Type: text/plain; charset="utf-8"
Content-ID: <656A970E1619814A89F8066C8A40D2BA@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 347985eb-efe9-4e4f-315b-08d736e624f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2019 18:30:38.5632
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LQqLW9wQmtOENxU0R9CFOUysGzyc+FoeE7IeCZZgPtNKjH2FZZ7UYG4sSqy7bof+DdATXw8ACbFyU+qVA6W+aQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1640
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-11_08:2019-09-11,2019-09-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 clxscore=1015 mlxscore=0 mlxlogscore=869
 phishscore=0 spamscore=0 bulkscore=0 impostorscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909110170
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCu+7v09uIDkvMTAvMTksIDQ6MDggUE0sICJMaW51eC1hc3BlZWQgb24gYmVoYWxmIG9mIFZp
amF5IEtoZW1rYSIgPGxpbnV4LWFzcGVlZC1ib3VuY2VzK3ZpamF5a2hlbWthPWZiLmNvbUBsaXN0
cy5vemxhYnMub3JnIG9uIGJlaGFsZiBvZiB2aWpheWtoZW1rYUBmYi5jb20+IHdyb3RlOg0KDQog
ICAgDQogICAgDQogICAgT24gOS8xMC8xOSwgMzo1MCBQTSwgIkxpbnV4LWFzcGVlZCBvbiBiZWhh
bGYgb2YgVmlqYXkgS2hlbWthIiA8bGludXgtYXNwZWVkLWJvdW5jZXMrdmlqYXlraGVta2E9ZmIu
Y29tQGxpc3RzLm96bGFicy5vcmcgb24gYmVoYWxmIG9mIHZpamF5a2hlbWthQGZiLmNvbT4gd3Jv
dGU6DQogICAgDQogICAgICAgIA0KICAgICAgICANCiAgICAgICAgT24gOS8xMC8xOSwgMzowNSBQ
TSwgIkZsb3JpYW4gRmFpbmVsbGkiIDxmLmZhaW5lbGxpQGdtYWlsLmNvbT4gd3JvdGU6DQogICAg
ICAgIA0KICAgICAgICAgICAgT24gOS8xMC8xOSAyOjM3IFBNLCBWaWpheSBLaGVta2Egd3JvdGU6
DQogICAgICAgICAgICA+IEhXIGNoZWNrc3VtIGdlbmVyYXRpb24gaXMgbm90IHdvcmtpbmcgZm9y
IEFTVDI1MDAsIHNwZWNpYWxseSB3aXRoIElQVjYNCiAgICAgICAgICAgID4gb3ZlciBOQ1NJLiBB
bGwgVENQIHBhY2tldHMgd2l0aCBJUHY2IGdldCBkcm9wcGVkLiBCeSBkaXNhYmxpbmcgdGhpcw0K
ICAgICAgICAgICAgPiBpdCB3b3JrcyBwZXJmZWN0bHkgZmluZSB3aXRoIElQVjYuDQogICAgICAg
ICAgICA+IA0KICAgICAgICAgICAgPiBWZXJpZmllZCB3aXRoIElQVjYgZW5hYmxlZCBhbmQgY2Fu
IGRvIHNzaC4NCiAgICAgICAgICAgIA0KICAgICAgICAgICAgSG93IGFib3V0IElQdjQsIGRvIHRo
ZXNlIHBhY2tldHMgaGF2ZSBwcm9ibGVtPyBJZiBub3QsIGNhbiB5b3UgY29udGludWUNCiAgICAg
ICAgICAgIGFkdmVydGlzaW5nIE5FVElGX0ZfSVBfQ1NVTSBidXQgdGFrZSBvdXQgTkVUSUZfRl9J
UFY2X0NTVU0/DQogICAgICAgIA0KICAgICAgICBJIGNoYW5nZWQgY29kZSBmcm9tIChuZXRkZXYt
Pmh3X2ZlYXR1cmVzICY9IH5ORVRJRl9GX0hXX0NTVU0pIHRvIA0KICAgICAgICAobmV0ZGV2LT5o
d19mZWF0dXJlcyAmPSB+TkVUSUZfRl8gSVBWNl9DU1VNKS4gQW5kIGl0IGlzIG5vdCB3b3JraW5n
LiANCiAgICAgICAgRG9uJ3Qga25vdyB3aHkuIElQVjQgd29ya3Mgd2l0aG91dCBhbnkgY2hhbmdl
IGJ1dCBJUHY2IG5lZWRzIEhXX0NTVU0NCiAgICAgICAgRGlzYWJsZWQuDQogICAgDQogICAgTm93
IEkgY2hhbmdlZCB0bw0KICAgIG5ldGRldi0+aHdfZmVhdHVyZXMgJj0gKH5ORVRJRl9GX0hXX0NT
VU0pIHwgTkVUSUZfRl9JUF9DU1VNOw0KICAgIEFuZCBpdCB3b3Jrcy4NCg0KSSBpbnZlc3RpZ2F0
ZWQgbW9yZSBvbiB0aGVzZSBmZWF0dXJlcyBhbmQgZm91bmQgdGhhdCB3ZSBjYW5ub3Qgc2V0IE5F
VElGX0ZfSVBfQ1NVTSANCldoaWxlIE5FVElGX0ZfSFdfQ1NVTSBpcyBzZXQuIFNvIEkgZGlzYWJs
ZWQgTkVUSUZfRl9IV19DU1VNIGZpcnN0IGFuZCBlbmFibGVkDQpORVRJRl9GX0lQX0NTVU0gaW4g
bmV4dCBzdGF0ZW1lbnQuIEFuZCBpdCB3b3JrcyBmaW5lLg0KDQpCdXQgYXMgcGVyIGxpbmUgMTY2
IGluIGluY2x1ZGUvbGludXgvc2tidWZmLmgsICANCiogICBORVRJRl9GX0lQX0NTVU0gYW5kIE5F
VElGX0ZfSVBWNl9DU1VNIGFyZSBiZWluZyBkZXByZWNhdGVkIGluIGZhdm9yIG9mDQogKiAgIE5F
VElGX0ZfSFdfQ1NVTS4gTmV3IGRldmljZXMgc2hvdWxkIHVzZSBORVRJRl9GX0hXX0NTVU0gdG8g
aW5kaWNhdGUNCiAqICAgY2hlY2tzdW0gb2ZmbG9hZCBjYXBhYmlsaXR5Lg0KDQpQbGVhc2Ugc3Vn
Z2VzdCB3aGljaCBvZiBiZWxvdyAyIEkgc2hvdWxkIGRvLiBBcyBib3RoIHdvcmtzIGZvciBtZS4N
CjEuIERpc2FibGUgY29tcGxldGVseSBORVRJRl9GX0hXX0NTVU0gYW5kIGRvIG5vdGhpbmcuIFRo
aXMgaXMgb3JpZ2luYWwgcGF0Y2guDQoyLiBFbmFibGUgTkVUSUZfRl9JUF9DU1VNIGluIGFkZGl0
aW9uIHRvIDEuIEkgY2FuIGhhdmUgdjIgaWYgdGhpcyBpcyBhY2NlcHRlZC4NCiAgICAgICAgICAg
IA0KICAgICAgICAgICAgPiANCiAgICAgICAgICAgID4gU2lnbmVkLW9mZi1ieTogVmlqYXkgS2hl
bWthIDx2aWpheWtoZW1rYUBmYi5jb20+DQogICAgICAgICAgICA+IC0tLQ0KICAgICAgICAgICAg
PiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvZmFyYWRheS9mdGdtYWMxMDAuYyB8IDUgKysrLS0NCiAg
ICAgICAgICAgID4gIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25z
KC0pDQogICAgICAgICAgICA+IA0KICAgICAgICAgICAgPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvZmFyYWRheS9mdGdtYWMxMDAuYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Zh
cmFkYXkvZnRnbWFjMTAwLmMNCiAgICAgICAgICAgID4gaW5kZXggMDMwZmVkNjUzOTNlLi41OTFj
OTcyNTAwMmIgMTAwNjQ0DQogICAgICAgICAgICA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0
L2ZhcmFkYXkvZnRnbWFjMTAwLmMNCiAgICAgICAgICAgID4gKysrIGIvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvZmFyYWRheS9mdGdtYWMxMDAuYw0KICAgICAgICAgICAgPiBAQCAtMTgzOSw4ICsxODM5
LDkgQEAgc3RhdGljIGludCBmdGdtYWMxMDBfcHJvYmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAq
cGRldikNCiAgICAgICAgICAgID4gIAlpZiAocHJpdi0+dXNlX25jc2kpDQogICAgICAgICAgICA+
ICAJCW5ldGRldi0+aHdfZmVhdHVyZXMgfD0gTkVUSUZfRl9IV19WTEFOX0NUQUdfRklMVEVSOw0K
ICAgICAgICAgICAgPiAgDQogICAgICAgICAgICA+IC0JLyogQVNUMjQwMCAgZG9lc24ndCBoYXZl
IHdvcmtpbmcgSFcgY2hlY2tzdW0gZ2VuZXJhdGlvbiAqLw0KICAgICAgICAgICAgPiAtCWlmIChu
cCAmJiAob2ZfZGV2aWNlX2lzX2NvbXBhdGlibGUobnAsICJhc3BlZWQsYXN0MjQwMC1tYWMiKSkp
DQogICAgICAgICAgICA+ICsJLyogQVNUMjQwMCAgYW5kIEFTVDI1MDAgZG9lc24ndCBoYXZlIHdv
cmtpbmcgSFcgY2hlY2tzdW0gZ2VuZXJhdGlvbiAqLw0KICAgICAgICAgICAgPiArCWlmIChucCAm
JiAob2ZfZGV2aWNlX2lzX2NvbXBhdGlibGUobnAsICJhc3BlZWQsYXN0MjQwMC1tYWMiKSB8fA0K
ICAgICAgICAgICAgPiArCQkgICBvZl9kZXZpY2VfaXNfY29tcGF0aWJsZShucCwgImFzcGVlZCxh
c3QyNTAwLW1hYyIpKSkNCiAgICAgICAgICAgID4gIAkJbmV0ZGV2LT5od19mZWF0dXJlcyAmPSB+
TkVUSUZfRl9IV19DU1VNOw0KICAgICAgICAgICAgPiAgCWlmIChucCAmJiBvZl9nZXRfcHJvcGVy
dHkobnAsICJuby1ody1jaGVja3N1bSIsIE5VTEwpKQ0KICAgICAgICAgICAgPiAgCQluZXRkZXYt
Pmh3X2ZlYXR1cmVzICY9IH4oTkVUSUZfRl9IV19DU1VNIHwgTkVUSUZfRl9SWENTVU0pOw0KICAg
ICAgICAgICAgPiANCiAgICAgICAgICAgIA0KICAgICAgICAgICAgDQogICAgICAgICAgICAtLSAN
CiAgICAgICAgICAgIEZsb3JpYW4NCiAgICAgICAgICAgIA0KICAgICAgICANCiAgICAgICAgDQog
ICAgDQogICAgDQoNCg==
