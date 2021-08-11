Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBD73E8D6A
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 11:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236753AbhHKJpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 05:45:10 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:11432 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236684AbhHKJpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 05:45:09 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17B9eo7N021934;
        Wed, 11 Aug 2021 02:44:41 -0700
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by mx0a-0016f401.pphosted.com with ESMTP id 3ac6qth22v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Aug 2021 02:44:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a8JyYwYEluVMSajm9ytSxH9McpDVDC/7anvgCqP8bIsbjOob+VN6u2KrbS69DXYMg2bl9iIN1KY5j6yZFmd8ThpxLKdCX+ZClsf2y8eH52pogQP+9oSccWtAv1h0hZLDfM2fBzziW3SXjkySQSj29DMRjt/uvumgDW9vOIafNXfvIRmU6iN39qONNcip9g/Erigh3peYgniwTiA9zknwWYe603ZBPywIY2RhznA1HJ8NN+CldJlfxZ0btsfMbklnqqIg+80hkKxbK/DQzzBcw8YEL0x96YD39Jo3Qe7LwoDhN518Emzd5UM+lNCPGoY+c8xC+umjsYhUfJj6QyPewQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jg2b9o/TA5Cbm6UrNtdTyVe9shVE62xW2t8bCcphxWE=;
 b=B5+8KdWYMpLdQE7fRJFgSWN9BOjVl/P+Y8i+XkRJ8tQPY6sezLasMKim4sw7u/BUDt+ZzKUMWvw/dWOd0E8CPhRJVyqrPobUc50abWd2DlHuIkvmlLp/QQT9R68kc4MH1ewuXdyGMEku+fiRBtX/4u9dUGRdf/HcjH2Ts3bbg1R/EnZc20MHxPuF3wCeWe+8ORERCKyejl4T1g0gtTUIupD9wVGGp0ija9QXM3uez0HUlAUfj2g/f3KazB1esTmyi2TR9NrfB2CTTeDV9YAOM4utqgtcTF2dH+lVf3+TBXAIoR8g2MSmS6vNzw6gYjz2E5Dm/LVbrLirL6Yfud9nwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jg2b9o/TA5Cbm6UrNtdTyVe9shVE62xW2t8bCcphxWE=;
 b=tdDsojz/Qn9V8bnXT/+Thl+jtNJAZJWvdBAbd9X9c9rsduXmd423cWwjSvCH8tg8x4zG7EOKQlrbMgJ20OrN2bMXTej1MfL542aKItD3MbADhIeYwOXLfjeDA/MxM+frYvjKfi7nTR8+s5yQ3zb+NPXNWjx9ROC3mGwLMmJ2Ids=
Received: from SJ0PR18MB3882.namprd18.prod.outlook.com (2603:10b6:a03:2c8::13)
 by BYAPR18MB2725.namprd18.prod.outlook.com (2603:10b6:a03:111::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.21; Wed, 11 Aug
 2021 09:44:39 +0000
Received: from SJ0PR18MB3882.namprd18.prod.outlook.com
 ([fe80::6513:d2ca:d44a:537c]) by SJ0PR18MB3882.namprd18.prod.outlook.com
 ([fe80::6513:d2ca:d44a:537c%8]) with mapi id 15.20.4394.025; Wed, 11 Aug 2021
 09:44:39 +0000
From:   Shai Malin <smalin@marvell.com>
To:     Tuo Li <islituo@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "baijiaju1990@gmail.com" <baijiaju1990@gmail.com>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "malin1024@gmail.com" <malin1024@gmail.com>
Subject: RE: [BUG] net: qed: possible null-pointer dereference in
 qed_rdma_create_qp()
Thread-Topic: [BUG] net: qed: possible null-pointer dereference in
 qed_rdma_create_qp()
Thread-Index: AdeOjq03unZUTZWXS2CkMt0DmePJiw==
Date:   Wed, 11 Aug 2021 09:44:38 +0000
Message-ID: <SJ0PR18MB38825C9DE41C67DEC36F3DAACCF89@SJ0PR18MB3882.namprd18.prod.outlook.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=marvell.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d936b5ab-2c24-4fa3-4cd1-08d95caca32b
x-ms-traffictypediagnostic: BYAPR18MB2725:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB27256CB8D6AC3B8BED36BF50CCF89@BYAPR18MB2725.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: an2mjvGOQ7luefYCvhgFcdcwAXiIbGuvYBmWcNCkPPcbaKYmF7N29PmnwNvWMWJSN2xDu2uVR9GyjIrtXCm8MqUp13LyBlpYlo7vE2egMM1pH20ptB/CITZmZu5PpTyHuk45/zA5lk8LTdt6M5A+MHcq1wTsV0pe73M4B+fi4aD0FuTuctrJ727ZRTCV9S2K73JpGDpx3RGP9U2B8oZaho0NHiC0UJkrh+OMHSNoNGkPib+VNV9CeDkPQbxeEA/7os+FE3SbVv78U3Z8+N7S60jRaozq90TqHUQRrpKEyHXiB+ZxraGFu2j78uudPUW2OPXpTkcQkQfj+KTGkTXt86EPa/pJfPtA76+xbGcTAZqZdGNciPtxBK5EL3a16c81yynfwSQyX8z8xLFGAGzxU4HpaSSv9jLeIN+iyFz56r/LtKMDCLESlOavb/qXs6y3Y/4IZ9jbRPZxef1TtzN6EUl+r0Yq5jpzntg9dp9DWw0ygucRLBK8HcnkPL4nu0VW7ncD0Kv7h8g5dZVQ1zuHFphWawxwmxt+GXXPABU0q/jiyxT3UWAs+6gPBGPLtZRMZ4XXXJAxgWjwAsJKwjd/658SIMIZKuv6QiIQqJr2CMEaGZjhSf/EmVXbHX5rf/GCbDjWzGikVrqANH+gZuaxK2JkgxrNhMmm0FhPtciixzPKdgJXotc3zKLLWI/LyXDXgvFXfNKXfUtmeggv5vEXUw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB3882.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(346002)(396003)(376002)(136003)(8676002)(8936002)(9686003)(2906002)(55016002)(66476007)(52536014)(76116006)(71200400001)(38070700005)(66556008)(5660300002)(64756008)(4326008)(54906003)(316002)(66946007)(6916009)(66446008)(4744005)(186003)(122000001)(6506007)(33656002)(7696005)(478600001)(53546011)(38100700002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c2Vxc3hTcERwT01TWTRoSEhxT0h5VUJ2U2ZXbEk0RHJBc0Y1NHZJaG1Fbko4?=
 =?utf-8?B?dGhYdk9XVXdBNklYbitsUWhZZnkxbkFML01yb0JEQmRwamNXWjUzVDFERTJz?=
 =?utf-8?B?UnFzelBWMUJRMjhHNTYwekM1U2x0ZDVvdEhLVW1DQjVhQkJqMi81a3YxNDNR?=
 =?utf-8?B?NnlpUHU2U2dsRDh6a0hTR3VBVzFLVVdjOGUrNktMZ3UyQkVaOXd1L2VpYi9q?=
 =?utf-8?B?b2MwWXVBQ0ZCeW5FdlVNMVlWbE5ZMnR6S2R0RFpqUEY4cGdLdlM0T0I3VDhZ?=
 =?utf-8?B?WWx1Tnd6T3BtTm83NnlmbTJDSFcxazRycmlTTHJaSjdUTndGSURDR3VLS2N4?=
 =?utf-8?B?Z01hLzNVWWtleDI2WUV2RWx2Y29yVzZnZ1VNcWNMWksvaFd2aXd0MnFvcmRG?=
 =?utf-8?B?WFhvczJJQWtkdUNJU2NsZEdYVE9TbzB5Z2JnNU03ZmVIM3JDREJGT1I4Ry9D?=
 =?utf-8?B?dTl6SHROb2JxOEZYejRrTEh2SmVreFpaUGhEalN4bGhyMkFHQ2liWTl0TUhS?=
 =?utf-8?B?SjNBTENLdERKdS8xUTJ3RUx6QU96ZHhkR1VlUjNoenB5NUo1Vkl3a0JlTFkv?=
 =?utf-8?B?THRPWlZwWUNxOGlsSVQvV2JYVmJsSmx5NFg5K25ZWi9nKy9GT0tRVEJaRlJR?=
 =?utf-8?B?MHhFOEYydjkxVnpTdThMUnBVT3p2RTc3clJCbkhDN0V0aHhxb0NSeFM5L0Jz?=
 =?utf-8?B?OUZkQm51NS8ySzVIT0NlUzFrR3h4NzIrblBTV3dJci9iZXlxS1hadTFiamVH?=
 =?utf-8?B?c2ZxbmhhZWRXbkhEalpqVnJIMTRkMlZudzNLTm1ZcWV1VkhUek9HSW5iS1FT?=
 =?utf-8?B?aG41cjVzVFNrNUg0cjBrOTEyYWZ6ODZjcTJodWg5MW5iRkF0a2dXSGtjTXha?=
 =?utf-8?B?clhHdkZqVVErcElWUlZ4eUZTajQvZVV6d3FJNjVqbjlTN3ovcHV5WVE2RUNN?=
 =?utf-8?B?ZGFSK2FDQ3FQbDFmek85N3N0WU5mVVVCWkg0bHEwRkMrejdPNW54MHAraVNP?=
 =?utf-8?B?QitxNzB2M3lnOUFhek5Nb0ZGWHJBUVpnTkZsSkVxMVhETnhJbG5RREZlc2xN?=
 =?utf-8?B?RFg2MUVqcTlsbExmN0hORFdPUlBVdzJweGYyMzc2bTRIamhMVUl1ZkpER21L?=
 =?utf-8?B?Z2pPK1NrZ3NNd3JJQ3Y3SndmL25EalFPSXY0MFl2OUJkTS9KZ0RZWGZ1TWwz?=
 =?utf-8?B?UmoraVV5RHF4d0pWNE94RFhOV3l5RmNzSUpzWjY4dWdxUDlGN2hTNW9ub1Bp?=
 =?utf-8?B?L2t2V3RWQWoxMU0xenFYbEljRVZPaCt0czc1VmtPSXlWMmRPV3lHSXVsK3RK?=
 =?utf-8?B?TFN0MDJtMG8xc2lFeUd0SWYrMHd5aDZwRzRHaUZSd0daUU5KSWdZVGdMU3V5?=
 =?utf-8?B?blgxTEd3NXJTRzNIYWJaS1pTcWZZREtBTzBibkYrL2Zkc0ZaQWZWMkIzNmtI?=
 =?utf-8?B?TUN5RmY4RndKa296bkZyOWIwdVVndTdIZDhya2t4OUVSUFNSWnBadkVrV1ls?=
 =?utf-8?B?S21DNzBHRG05WG1SWFhVSk5RM2JxeU41Q2s1cm5IdFc3eVh5QXJrbGhGaEhl?=
 =?utf-8?B?WXRQODZWeXZ0ZFdmTzJLUnVlemh3dzRldDU0MHpCYUw1cnVUL1hMelF0VGt0?=
 =?utf-8?B?RUc5d2pwRTE2OGQzZDh6RHdYUnFFRlBpYkZoTytscGNWOTA5NnlXdktzM1FL?=
 =?utf-8?B?d1JuRXZSbUlwck15bTVWQjVLOGY5bUFHRnl0VnVnMkJwSTNLQlEyMkg4cVBL?=
 =?utf-8?B?cFRSeFdLZjNvci8vaUhncWhmdWtZNUpEbTdmZUhFdXpnaHg0RGNUVlJud2pK?=
 =?utf-8?Q?XyaIWHwhLwHaxG4yd6nMNdrv/no7EM0AoKthM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB3882.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d936b5ab-2c24-4fa3-4cd1-08d95caca32b
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2021 09:44:38.9936
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: niv0R1J1D8NqKI/Xa8PWzT19NdWBP8EMsGPDRCtd5ktYH8Pyf+CPMxYRJVsaMiwLft4zxTOI17Ln0IN7mk/sTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2725
X-Proofpoint-ORIG-GUID: WZkJ93mZ7l8pVExYeKgsLYt4rh3YToh9
X-Proofpoint-GUID: WZkJ93mZ7l8pVExYeKgsLYt4rh3YToh9
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-11_03:2021-08-10,2021-08-11 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOC8xMS8yMSA2OjMwIEFNLCBUdW8gTGkgd3JvdGU6DQo+IEhlbGxvLA0KPiANCj4gT3VyIHN0
YXRpYyBhbmFseXNpcyB0b29sIGZpbmRzIGEgcG9zc2libGUgbnVsbC1wb2ludGVyIGRlcmVmZXJl
bmNlIGluDQo+IHFlZF9yZG1hLmMgaW4gTGludXggNS4xNC4wLXJjMzoNCj4gDQo+IFRoZSB2YXJp
YWJsZSByZG1hX2N4dCBpcyBhc3NpZ25lZCB0byBwX2h3Zm4sIGFuZCByZG1hX2N4dCBpcyBjaGVj
a2VkIGluOg0KPiAxMjg2OsKgwqDCoCBpZiAoIXJkbWFfY3h0IHx8ICFpbl9wYXJhbXMgfHwgIW91
dF9wYXJhbXMgfHwNCj4gIXBfaHdmbi0+cF9yZG1hX2luZm8tPmFjdGl2ZSkNCj4gDQo+IFRoaXMg
aW5kaWNhdGVzIHRoYXQgYm90aCByZG1hX2N4dCBhbmQgcF9od2ZuIGNhbiBiZSBOVUxMLiBJZiBz
bywgYQ0KPiBudWxsLXBvaW50ZXIgZGVyZWZlcmVuY2Ugd2lsbCBvY2N1cjoNCj4gMTI4ODrCoMKg
wqAgRFBfRVJSKHBfaHdmbi0+Y2RldiwgLi4uKTsNCj4gDQo+IEkgYW0gbm90IHF1aXRlIHN1cmUg
d2hldGhlciB0aGlzIHBvc3NpYmxlIG51bGwtcG9pbnRlciBkZXJlZmVyZW5jZSBpcw0KPiByZWFs
IGFuZCBob3cgdG8gZml4IGl0IGlmIGl0IGlzIHJlYWwuDQo+IEFueSBmZWVkYmFjayB3b3VsZCBi
ZSBhcHByZWNpYXRlZCwgdGhhbmtzIQ0KPiANCj4gUmVwb3J0ZWQtYnk6IFRPVEUgUm9ib3QgPG9z
bGFiQHRzaW5naHVhLmVkdS5jbj4NCg0KVGhhbmtzISBJdCdzIGEgcmVhbCBpc3N1ZS4NCldlIHdp
bGwgc2VuZCBhIGZpeC4NCg0KPiANCj4gQmVzdCB3aXNoZXMsDQo+IFR1byBMaQ0K
