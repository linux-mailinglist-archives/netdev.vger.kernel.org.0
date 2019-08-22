Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 102829A139
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 22:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393260AbfHVUej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 16:34:39 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:63426 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388336AbfHVUej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 16:34:39 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7MKWLQO015717;
        Thu, 22 Aug 2019 13:34:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=qyLqcM1YELWzxub+6IznUHAvDCxzzNemCeWwh4J/HFs=;
 b=Y/rVyN2YBSgDSiNFlvpuabBnSgLpNuRZDZiUJApd83ieuZFZoFLYPtmGDudco44hzj7e
 6y9h6AAymIlBiLqYnKBA0EjBpUKDb4O5Bg+K2pPK09W+pqWMucljmeTszzA8QHMMvrU0
 9olIDftuDcwT7oUDcivNFU0rq8i7Z2ufsxc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2uhxqu10ff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 22 Aug 2019 13:34:25 -0700
Received: from ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 22 Aug 2019 13:34:23 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 22 Aug 2019 13:34:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IFWCsw/r5fwgE3g2CYKyzhnderqbfxZR/W4+zSx9hINLAOm0ueYMksNe0+z/xF8J/bCDgWCvIN0DILsVr81HgEjhxULMxfM858NZ+OxSlk/uSrZ489/TCgjeGBnZxMZ3nVX4se2Jwww7QIsCK3Bv24U6m9wBhrC0pPMamWCZkrtW4+86pbCh02teWRb3bZqNtbsJ3PjBpg2hVOWkZEFcL8khUQebzg5kMWO/wmEAj6zwfChtKcD/puBxG4Mu5LM3JypcLhOxa0+V1qZvbgXtkPvmlftpv764123kCt7KR2xXLtUOfx2rR2ECEFdmkGNz8cpit9/50DCEGcH0JUIDkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qyLqcM1YELWzxub+6IznUHAvDCxzzNemCeWwh4J/HFs=;
 b=Qz89nDBRaGmzS9EwMZVrpGSNTv3GU/nojojhNjpJ7iJtQcbuXkg2GB24ynxGOpsoDl+905brD7LImY8LObVvZNNtjk7T/fEvSHXIRFl0knbl7KWqTS/PeSWh/rSL1oW92eN480d4o4bO6+M7i7htgDhof/+YqRsZ0vbeh/6fdFmS7dlJLjR1hnC4KUlQi6zW9k1V2bRG9r/1drM1JVJHZsB0jlcbqKrCoMhFA1CEmyXs57xJbC1MbBt8o4LKpNiFhsG5cJPzujS+K8kXuKu1WeU4jZ+tUakXT36m7V74iw+qRAiSAGEKW2n5mLZJkRNBENdK8KzIR0l8MfkoiFwfjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qyLqcM1YELWzxub+6IznUHAvDCxzzNemCeWwh4J/HFs=;
 b=JYwwkbf/LRRTofV0BSpPBQZAA4/vAQZ8vNaDlAwJNfM/zj/wL4y7nY/hTHnewO4J4/YTayDsD0HqFGdTqyfiPYoMg3HOmL9bD97g58beLd68WXF2cuuRnl6OWAqJed84qUHU2c+WOyiu+ZRll52+frzTuRgtoMKbODZyR7meKtY=
Received: from CY4PR15MB1269.namprd15.prod.outlook.com (10.172.177.11) by
 CY4PR15MB1301.namprd15.prod.outlook.com (10.172.182.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Thu, 22 Aug 2019 20:34:22 +0000
Received: from CY4PR15MB1269.namprd15.prod.outlook.com
 ([fe80::8c93:f913:124:8dd0]) by CY4PR15MB1269.namprd15.prod.outlook.com
 ([fe80::8c93:f913:124:8dd0%8]) with mapi id 15.20.2178.020; Thu, 22 Aug 2019
 20:34:22 +0000
From:   Vijay Khemka <vijaykhemka@fb.com>
To:     "Justin.Lee1@Dell.com" <Justin.Lee1@Dell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sam@mendozajonas.com" <sam@mendozajonas.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH] net/ncsi: Fix the payload copying for the request coming
 from Netlink
Thread-Topic: [PATCH] net/ncsi: Fix the payload copying for the request coming
 from Netlink
Thread-Index: AdVYWI8OU3qkqsD+SsWDRcEtUwk7KQAlb7eA
Date:   Thu, 22 Aug 2019 20:34:22 +0000
Message-ID: <0B7D4454-2976-4E22-AF0D-385616F3B7CF@fb.com>
References: <a94e5fa397a64ae3a676ec11ea09aaba@AUSX13MPS302.AMER.DELL.COM>
In-Reply-To: <a94e5fa397a64ae3a676ec11ea09aaba@AUSX13MPS302.AMER.DELL.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Enabled=True;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_SiteId=945c199a-83a2-4e80-9f8c-5a91be5752dd;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Owner=Justin_Lee1@Dell.com;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_SetDate=2019-08-21T21:22:10.9472431Z;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Name=External Public;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Extended_MSFT_Method=Manual;
 aiplabel=External Public
x-originating-ip: [2620:10d:c090:200::3:7504]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8eb2d78b-496e-4cad-f58d-08d727401d95
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:CY4PR15MB1301;
x-ms-traffictypediagnostic: CY4PR15MB1301:
x-microsoft-antispam-prvs: <CY4PR15MB13010BF71D50EACDE448B97ADDA50@CY4PR15MB1301.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(39860400002)(366004)(346002)(396003)(136003)(189003)(199004)(76176011)(316002)(33656002)(14444005)(7736002)(305945005)(446003)(11346002)(486006)(46003)(71190400001)(71200400001)(2201001)(2616005)(256004)(36756003)(6436002)(86362001)(8936002)(14454004)(476003)(53936002)(99286004)(64756008)(6246003)(110136005)(102836004)(6512007)(25786009)(6486002)(6506007)(2501003)(5660300002)(81166006)(478600001)(186003)(81156014)(8676002)(6116002)(229853002)(2906002)(66946007)(66476007)(66446008)(66556008)(91956017)(76116006);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR15MB1301;H:CY4PR15MB1269.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: aCHfd1XbBvR7tsb7e0cO+/gpUIdwBm9W7BpJ5aDsZ5wXMDBmZH2u9yQxE0W9wWNQn3lS9kHkfvvm1Y+O1fEB1Z88r+baIHjuRCdd0ajJYiU38GCTuG4CadyqUtIAZLnoVtLRNx3feozz7PIGCgFNIFKwtW7W9jAbo5Ygz2isRhqKhI5+ViSzSv2JSrXrTkKH84cVLRQHovhgR4ncDprLouNaeBvb8I1PZek5zxGb6eHri8baWuksBEvH4S0Y6eh+Vib0gewpCWEiszlwow+lZlJDtKn1vtxwm6M0T/A8+Echk09N6tAlpp1Py9X3CUbhE1SNo558cP2N1Kg9SV4PnVVLNsENoNkRiat0I/QPifTfnB5WYGHe2nTTuYYKI4q0PuIErLqNl12WhYk2b1/WOoSgL0oBQx83wl97FR3/6x8=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <E763626CDE04104CA358D4D46FDAFB4A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8eb2d78b-496e-4cad-f58d-08d727401d95
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 20:34:22.2252
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7NLffxtXXA1QMSRfQ7r3EKfzdz2GZx0tAeHmA4okR6Z7JSAYt2Tmc58snqZ744Jhbs8Ky/A2866b7bkwGFdDZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1301
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-22_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908220178
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TEdUTS4NCg0KDQoNCu+7v09uIDgvMjEvMTksIDI6MjYgUE0sICJvcGVuYm1jIG9uIGJlaGFsZiBv
ZiBKdXN0aW4uTGVlMUBEZWxsLmNvbSIgPG9wZW5ibWMtYm91bmNlcyt2aWpheWtoZW1rYT1mYi5j
b21AbGlzdHMub3psYWJzLm9yZyBvbiBiZWhhbGYgb2YgSnVzdGluLkxlZTFARGVsbC5jb20+IHdy
b3RlOg0KDQogICAgVGhlIHJlcXVlc3QgY29taW5nIGZyb20gTmV0bGluayBzaG91bGQgdXNlIHRo
ZSBPRU0gZ2VuZXJpYyBoYW5kbGVyLg0KICAgIA0KICAgIFRoZSBzdGFuZGFyZCBjb21tYW5kIGhh
bmRsZXIgZXhwZWN0cyBwYXlsb2FkIGluIGJ5dGVzL3dvcmRzL2R3b3Jkcw0KICAgIGJ1dCB0aGUg
YWN0dWFsIHBheWxvYWQgaXMgc3RvcmVkIGluIGRhdGEgaWYgdGhlIHJlcXVlc3QgaXMgY29taW5n
IGZyb20gTmV0bGluay4NCiAgICANCiAgICBTaWduZWQtb2ZmLWJ5OiBKdXN0aW4gTGVlIDxqdXN0
aW4ubGVlMUBkZWxsLmNvbT4NClJldmlld2VkLWJ5OiBWaWpheSBLaGVta2EgPHZpamF5a2hlbWth
QGZiLmNvbT4NCiAgICANCiAgICAtLS0NCiAgICAgbmV0L25jc2kvbmNzaS1jbWQuYyB8IDExICsr
KysrKysrKy0tDQogICAgIDEgZmlsZSBjaGFuZ2VkLCA5IGluc2VydGlvbnMoKyksIDIgZGVsZXRp
b25zKC0pDQogICAgDQogICAgZGlmZiAtLWdpdCBhL25ldC9uY3NpL25jc2ktY21kLmMgYi9uZXQv
bmNzaS9uY3NpLWNtZC5jDQogICAgaW5kZXggZWFiNDM0Ni4uMDE4N2U2NSAxMDA2NDQNCiAgICAt
LS0gYS9uZXQvbmNzaS9uY3NpLWNtZC5jDQogICAgKysrIGIvbmV0L25jc2kvbmNzaS1jbWQuYw0K
ICAgIEBAIC0zMDksMTQgKzMwOSwyMSBAQCBzdGF0aWMgc3RydWN0IG5jc2lfcmVxdWVzdCAqbmNz
aV9hbGxvY19jb21tYW5kKHN0cnVjdCBuY3NpX2NtZF9hcmcgKm5jYSkNCiAgICAgDQogICAgIGlu
dCBuY3NpX3htaXRfY21kKHN0cnVjdCBuY3NpX2NtZF9hcmcgKm5jYSkNCiAgICAgew0KICAgICsJ
c3RydWN0IG5jc2lfY21kX2hhbmRsZXIgKm5jaCA9IE5VTEw7DQogICAgIAlzdHJ1Y3QgbmNzaV9y
ZXF1ZXN0ICpucjsNCiAgICArCXVuc2lnbmVkIGNoYXIgdHlwZTsNCiAgICAgCXN0cnVjdCBldGho
ZHIgKmVoOw0KICAgIC0Jc3RydWN0IG5jc2lfY21kX2hhbmRsZXIgKm5jaCA9IE5VTEw7DQogICAg
IAlpbnQgaSwgcmV0Ow0KICAgICANCiAgICArCS8qIFVzZSBPRU0gZ2VuZXJpYyBoYW5kbGVyIGZv
ciBOZXRsaW5rIHJlcXVlc3QgKi8NCiAgICArCWlmIChuY2EtPnJlcV9mbGFncyA9PSBOQ1NJX1JF
UV9GTEFHX05FVExJTktfRFJJVkVOKQ0KICAgICsJCXR5cGUgPSBOQ1NJX1BLVF9DTURfT0VNOw0K
ICAgICsJZWxzZQ0KICAgICsJCXR5cGUgPSBuY2EtPnR5cGU7DQogICAgKw0KICAgICAJLyogU2Vh
cmNoIGZvciB0aGUgaGFuZGxlciAqLw0KICAgICAJZm9yIChpID0gMDsgaSA8IEFSUkFZX1NJWkUo
bmNzaV9jbWRfaGFuZGxlcnMpOyBpKyspIHsNCiAgICAtCQlpZiAobmNzaV9jbWRfaGFuZGxlcnNb
aV0udHlwZSA9PSBuY2EtPnR5cGUpIHsNCiAgICArCQlpZiAobmNzaV9jbWRfaGFuZGxlcnNbaV0u
dHlwZSA9PSB0eXBlKSB7DQogICAgIAkJCWlmIChuY3NpX2NtZF9oYW5kbGVyc1tpXS5oYW5kbGVy
KQ0KICAgICAJCQkJbmNoID0gJm5jc2lfY21kX2hhbmRsZXJzW2ldOw0KICAgICAJCQllbHNlDQog
ICAgLS0gDQogICAgMi45LjMNCiAgICANCg0K
