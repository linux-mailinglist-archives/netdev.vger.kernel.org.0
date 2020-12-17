Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB1D2DD83F
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 19:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730867AbgLQSYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 13:24:46 -0500
Received: from mail-mw2nam12on2081.outbound.protection.outlook.com ([40.107.244.81]:56545
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730789AbgLQSYp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 13:24:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RBAYs5m1EJutaaqtKemkRfLaaIJL5X4njvQqfdxUxjc93FBn+Q4GlFiyT5qT07wd6fV+Y4QCrCxSSEV4uH+xMQVqjgj2AeHhmpTFRLu+q/MxVUtRW5nZd3nW+McB+le0wEC/vfpDkffJc4usHugi9aO6FtNFdPrfPxSYHpu8xFZt4fwQABrDEngYu3g+dPCGl+/247HXYz+5yHyKiHz3G22XOB6l6OK5pj8y/lPnPeyXtUzlZ3qKspL7M5tvP85gjEO3l+QDqW2W/j/3pQNki8GbknjSotL3NlNKxO9ut+33I++0A2bCkSuReiZj1OEl67Ap4L7tee+ep60/c7oMUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pzpKzTK7iPROAO4dv1iT2U5iakb9NowWPBs8tmPXrCs=;
 b=KCIJNvrC15fXG7cMGo3KGrsukm5XhvMSNkzqOYvFS1mmWy8YAdq1WYkG5mJ1phRLhOcRosyYLYSVh+Ccvx3hgHwM61l4BO/Ki03LyfRw6VQGqV7K8poPriVn2CTBeV5XPvvaGP+XrGaMkWbsyRfk7V3z0KUqRkBuy5IJEwiWbXR1+EU4v/XfXcTDYcHhise8kN6mSAKxU+j2OuDU/Mjv0J2vVi205ULqFPauSkZkBU+QWAijD625lI43NkOrXrZTWEW0h94UBRAO9/ia8Ybb21stPxnmjFtciHW0gEtQbQ050o1I8HQoNAnzfdGzoclaIWM+UbMDlyF5vImzFvW4sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pzpKzTK7iPROAO4dv1iT2U5iakb9NowWPBs8tmPXrCs=;
 b=bN/YQb3+Gjb7Zhcol2vHOVSwdXbwv5zVWk7yspO8nOJ7NzC66LiwxHljSFzW/lXmb2EPwFo/8t7ntd9AdMD27I1CZONrDiU1dSDvDGfjn/TBlAshp7NaOyGWUtJjRYVY0+iTGHJYbx7GC26clt56v/1Jx5lR18Rh3q9xMWEA2iQ=
Received: from BYAPR02MB5638.namprd02.prod.outlook.com (2603:10b6:a03:9f::18)
 by BY5PR02MB6129.namprd02.prod.outlook.com (2603:10b6:a03:1b3::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.20; Thu, 17 Dec
 2020 18:23:50 +0000
Received: from BYAPR02MB5638.namprd02.prod.outlook.com
 ([fe80::c04a:e001:49fc:9780]) by BYAPR02MB5638.namprd02.prod.outlook.com
 ([fe80::c04a:e001:49fc:9780%4]) with mapi id 15.20.3654.025; Thu, 17 Dec 2020
 18:23:50 +0000
From:   Radhey Shyam Pandey <radheys@xilinx.com>
To:     Denis Kirjanov <kda@linux-powerpc.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Michal Simek <michals@xilinx.com>,
        "mchehab+samsung@kernel.org" <mchehab+samsung@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        git <git@xilinx.com>, Shravya Kumbham <shravyak@xilinx.com>
Subject: RE: [PATCH net v2] net: emaclite: Add error handling for of_address_
 and _mdio_setup functions
Thread-Topic: [PATCH net v2] net: emaclite: Add error handling for of_address_
 and _mdio_setup functions
Thread-Index: AQHWvNph+cTMJcpqKU6e5Ro4uvdh2anMTRgAgC97KmA=
Date:   Thu, 17 Dec 2020 18:23:49 +0000
Message-ID: <BYAPR02MB5638EDA3D13A272ACF599BBFC7C40@BYAPR02MB5638.namprd02.prod.outlook.com>
References: <1605614877-5670-1-git-send-email-radhey.shyam.pandey@xilinx.com>
 <CAOJe8K3-x36TU2kuW-uR8eqkNyoPsLWZYvD53MPcWxA6i5g72g@mail.gmail.com>
In-Reply-To: <CAOJe8K3-x36TU2kuW-uR8eqkNyoPsLWZYvD53MPcWxA6i5g72g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: linux-powerpc.org; dkim=none (message not signed)
 header.d=none;linux-powerpc.org; dmarc=none action=none
 header.from=xilinx.com;
x-originating-ip: [149.199.50.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 79ec7b1a-5a3e-4efb-f1d3-08d8a2b8e6dd
x-ms-traffictypediagnostic: BY5PR02MB6129:
x-ld-processed: 657af505-d5df-48d0-8300-c31994686c5c,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR02MB612962C4C20A8DDAB9B06181C7C40@BY5PR02MB6129.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1332;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A8zBAW57VTGGLwJJiBj+QUrVsHnxN9HHQuxYbftf3YPnIcxDMlXi38RIKki/WN6uepnmN5/tqSDmiLX9dPUtXUY17EOMbVF4uAqPvQo+2gG05rO1bquFP4HO1k+/fl5Jq1OVe+jlU0fWdoq9OnhGU2fb3zrFuPS5IWPgG3YsGvO+BhXhyBXULlsE/H19sxI+Y49hhWt9M1XgYJ5EqvuuWsh13BBD73USyjI6UDKgPkMiMpuvhENgzAIURdFJBfvVRXtb1jPLn2sVYkgn69OWbrvPY294/KP4ldFfwVj+38LQ99C563BZxW04KkeVdMQLMHfvfPrXqVmbOBj1phdZKw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR02MB5638.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(366004)(346002)(396003)(86362001)(26005)(64756008)(66446008)(66476007)(8936002)(316002)(9686003)(2906002)(54906003)(76116006)(7416002)(53546011)(7696005)(55016002)(6916009)(4326008)(186003)(33656002)(6506007)(107886003)(66556008)(66946007)(52536014)(83380400001)(8676002)(478600001)(5660300002)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?eW9rZ0wrNWlvVXAwUFg1LzR6dUg2L2N3dGs3aE43WHNSa0VwRXFOWmZQU1V4?=
 =?utf-8?B?V3ZiZ01nQnppdkM0d3QzTlh1cUJVcDVSK3hjQTUzbmZnS01MZUFUQ0pvMGVX?=
 =?utf-8?B?bzB4aENaQW9iNGgzMDQzbTFCbGtjbDZkbVNEOVVQU2xzazA0MDdhR0tvelFn?=
 =?utf-8?B?S1ExV1hBdGE5ZlZud2h6MnVPTFE4TVM1YUJNYUxqZUNRVkFjQXpTUjVmeU9S?=
 =?utf-8?B?RUhvQjRpODhocm1SbWFSNVEyZVBBbng4aWVCajFCQzA0QTJ0S1BpQ0VlWUt0?=
 =?utf-8?B?czlLZE41UkdZcVNoQmN0L0dweitPaFBRMHBBczQ4dzg5TXA1RlhaYTI5ZkNw?=
 =?utf-8?B?T2diaVNydXREbTc4Z1dPUlcvRU1ZVGwwYmdQRHpqZFlvK2pBQW1FQmx4WkxE?=
 =?utf-8?B?ZnErMkdRZzdRRUNPeHpOcytEZjIzdERjMnJKMEhzM1ZBLzRXbUJZK0V0ZFZL?=
 =?utf-8?B?TTJYQ3NTQlY4elBkVi9mMGc5QmsrTmJaYm9NOEFWM0JTQllHY1p6TTdmTEJO?=
 =?utf-8?B?ajlFVDY5YThtRTlEU0tscFpSVDJaWk9XQWoxbXNYS1RYUkRtU0J2a0NhY29a?=
 =?utf-8?B?bEE5YU44emZpTFlQSy96ZmRBWk9BMU82bGd5TW1aY0N4ZWc0cUx2YnlPNlhn?=
 =?utf-8?B?WUJ4UXJla2w5T3ZCOXI0Z3gydVhLR1dVbHl1MFM5SXhKcUx6d2I0aXJzRHhU?=
 =?utf-8?B?eEhTdmd2UEtrNmR3eE0xenVRcXVYYzFHcEZ3YnZsV3RLTHJickp5amxxTFUx?=
 =?utf-8?B?TjdkeWJFNUtvZU52bTAwa3RvcUcwVFpPS0xZM1NYR3BXOG5KNTN5YXhoK1lp?=
 =?utf-8?B?REU3V1pBbWl5L0VkczVqRmdUNlZBaW9DUm82RTJaN3huQlIvTHJNbExFa0F0?=
 =?utf-8?B?U0dNQytvQmppSmt5a1R3ZzJYeUhqdzQ3T2RrSk1oVFR2ditvTDZyQWtzQzJp?=
 =?utf-8?B?eU9rVUdWN2x5L3kxTmhGRlBlWHVPSGJoZ2xtUkNKQ0hyTnRkdW4wdWM2M00y?=
 =?utf-8?B?Q2xWUEJwNHZ0ZXBacTRjRUpxRkhMUThQdVduajM5ZXJhWVNjOVpFRVBlNngz?=
 =?utf-8?B?MWQ2VVB1WUVRZlJnRElJR3JtYkVYMVFzT2NWc29kVWcwQUw5TkxoZHZhQzVG?=
 =?utf-8?B?V0cyNVdCaWpuVUhnRnJPV2FZYlVqQjV5SmRrL1R5MUZ4YjQzaXgzc1VuUlow?=
 =?utf-8?B?NithWHRBSXBtRE54S3FBUXdUUXJ2ck0rTDh5allmNnMzY1AvMFlMVWhTTmZN?=
 =?utf-8?B?cWhlUkJFd2hnU2sxYTRFaVBMTmdtM3pvYXhMYm5LU3BhWVZaaCt3aXFBTG9G?=
 =?utf-8?Q?/unamelvP0wLE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR02MB5638.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79ec7b1a-5a3e-4efb-f1d3-08d8a2b8e6dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2020 18:23:50.2423
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: avgzTjbIheyYSIC8J7I6ixBj2Du2BIqck5VfwF+Y1tGTD51SEGf3npHG6eT4OUaV7XzIokEnvXJu8MWrqKc2Hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB6129
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBEZW5pcyBLaXJqYW5vdiA8a2Rh
QGxpbnV4LXBvd2VycGMub3JnPg0KPiBTZW50OiBUdWVzZGF5LCBOb3ZlbWJlciAxNywgMjAyMCA2
OjQzIFBNDQo+IFRvOiBSYWRoZXkgU2h5YW0gUGFuZGV5IDxyYWRoZXlzQHhpbGlueC5jb20+DQo+
IENjOiBkYXZlbUBkYXZlbWxvZnQubmV0OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBrdWJhQGtl
cm5lbC5vcmc7DQo+IE1pY2hhbCBTaW1layA8bWljaGFsc0B4aWxpbnguY29tPjsgbWNoZWhhYitz
YW1zdW5nQGtlcm5lbC5vcmc7DQo+IGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnOyBuaWNvbGFz
LmZlcnJlQG1pY3JvY2hpcC5jb207IGxpbnV4LWFybS0NCj4ga2VybmVsQGxpc3RzLmluZnJhZGVh
ZC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGdpdA0KPiA8Z2l0QHhpbGlueC5j
b20+OyBTaHJhdnlhIEt1bWJoYW0gPHNocmF2eWFrQHhpbGlueC5jb20+DQo+IFN1YmplY3Q6IFJl
OiBbUEFUQ0ggbmV0IHYyXSBuZXQ6IGVtYWNsaXRlOiBBZGQgZXJyb3IgaGFuZGxpbmcgZm9yDQo+
IG9mX2FkZHJlc3NfIGFuZCBfbWRpb19zZXR1cCBmdW5jdGlvbnMNCj4gDQo+IE9uIDExLzE3LzIw
LCBSYWRoZXkgU2h5YW0gUGFuZGV5IDxyYWRoZXkuc2h5YW0ucGFuZGV5QHhpbGlueC5jb20+DQo+
IHdyb3RlOg0KPiA+IEZyb206IFNocmF2eWEgS3VtYmhhbSA8c2hyYXZ5YS5rdW1iaGFtQHhpbGlu
eC5jb20+DQo+ID4NCj4gPiBBZGQgcmV0IHZhcmlhYmxlLCBjb25kaXRpb24gdG8gY2hlY2sgdGhl
IHJldHVybiB2YWx1ZSBhbmQgZXJyb3IgcGF0aA0KPiA+IGZvciB0aGUgb2ZfYWRkcmVzc190b19y
ZXNvdXJjZSgpIGZ1bmN0aW9uLiBJdCBhbHNvIGFkZHMgZXJyb3IgaGFuZGxpbmcNCj4gPiBmb3Ig
bWRpbyBzZXR1cCBhbmQgZGVjcmVtZW50IHJlZmNvdW50IG9mIHBoeSBub2RlLg0KPiA+DQo+ID4g
QWRkcmVzc2VzLUNvdmVyaXR5OiBFdmVudCBjaGVja19yZXR1cm4gdmFsdWUuDQo+ID4gU2lnbmVk
LW9mZi1ieTogU2hyYXZ5YSBLdW1iaGFtIDxzaHJhdnlhLmt1bWJoYW1AeGlsaW54LmNvbT4NCj4g
PiBTaWduZWQtb2ZmLWJ5OiBSYWRoZXkgU2h5YW0gUGFuZGV5IDxyYWRoZXkuc2h5YW0ucGFuZGV5
QHhpbGlueC5jb20+DQo+ID4gLS0tDQo+ID4gQ2hhbmdlcyBmb3IgdjI6DQo+ID4NCj4gPiAtIENo
YW5nZSBzdWJqZWN0X3ByZWZpeCB0byB0YXJnZXQgbmV0IHRyZWUuDQo+ID4gLSBBZGQgZXJyb3Ig
aGFuZGxpbmcgZm9yIG1kaW9fc2V0dXAgYW5kIHJlbW92ZSBwaHlfcmVhZCBjaGFuZ2VzLg0KPiA+
ICAgRXJyb3IgY2hlY2tpbmcgb2YgcGh5X3JlYWQgd2lsbCBiZSBhZGRlZCBhbG9uZyB3aXRoIHBo
eV93cml0ZQ0KPiA+ICAgaW4gYSBmb2xsb3d1cCBwYXRjaC4gRG9jdW1lbnQgdGhlIGNoYW5nZXMg
aW4gY29tbWl0IGRlc2NyaXB0aW9uLg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5l
dC94aWxpbngveGlsaW54X2VtYWNsaXRlLmMgfCAxNiArKysrKysrKysrKysrLS0tDQo+ID4gIDEg
ZmlsZSBjaGFuZ2VkLCAxMyBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3hpbGlueC94aWxpbnhfZW1hY2xpdGUu
Yw0KPiA+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQveGlsaW54L3hpbGlueF9lbWFjbGl0ZS5jDQo+
ID4gaW5kZXggMGMyNmY1YmNjNTIzLi40ZTAwMDUxNjQ3ODUgMTAwNjQ0DQo+ID4gLS0tIGEvZHJp
dmVycy9uZXQvZXRoZXJuZXQveGlsaW54L3hpbGlueF9lbWFjbGl0ZS5jDQo+ID4gKysrIGIvZHJp
dmVycy9uZXQvZXRoZXJuZXQveGlsaW54L3hpbGlueF9lbWFjbGl0ZS5jDQo+ID4gQEAgLTgyMCw3
ICs4MjAsNyBAQCBzdGF0aWMgaW50IHhlbWFjbGl0ZV9tZGlvX3dyaXRlKHN0cnVjdCBtaWlfYnVz
DQo+ID4gKmJ1cywgaW50IHBoeV9pZCwgaW50IHJlZywgIHN0YXRpYyBpbnQgeGVtYWNsaXRlX21k
aW9fc2V0dXAoc3RydWN0DQo+ID4gbmV0X2xvY2FsICpscCwgc3RydWN0IGRldmljZSAqZGV2KSAg
ew0KPiA+ICAJc3RydWN0IG1paV9idXMgKmJ1czsNCj4gPiAtCWludCByYzsNCj4gPiArCWludCBy
YywgcmV0Ow0KPiA+ICAJc3RydWN0IHJlc291cmNlIHJlczsNCj4gPiAgCXN0cnVjdCBkZXZpY2Vf
bm9kZSAqbnAgPSBvZl9nZXRfcGFyZW50KGxwLT5waHlfbm9kZSk7DQo+ID4gIAlzdHJ1Y3QgZGV2
aWNlX25vZGUgKm5wcDsNCj4gPiBAQCAtODM0LDcgKzgzNCwxMiBAQCBzdGF0aWMgaW50IHhlbWFj
bGl0ZV9tZGlvX3NldHVwKHN0cnVjdCBuZXRfbG9jYWwNCj4gPiAqbHAsIHN0cnVjdCBkZXZpY2Ug
KmRldikNCj4gPiAgCX0NCj4gPiAgCW5wcCA9IG9mX2dldF9wYXJlbnQobnApOw0KPiA+DQo+ID4g
LQlvZl9hZGRyZXNzX3RvX3Jlc291cmNlKG5wcCwgMCwgJnJlcyk7DQo+ID4gKwlyZXQgPSBvZl9h
ZGRyZXNzX3RvX3Jlc291cmNlKG5wcCwgMCwgJnJlcyk7DQo+ID4gKwlpZiAocmV0KSB7DQo+ID4g
KwkJZGV2X2VycihkZXYsICIlcyByZXNvdXJjZSBlcnJvciFcbiIsDQo+ID4gKwkJCWRldi0+b2Zf
bm9kZS0+ZnVsbF9uYW1lKTsNCj4gPiArCQlyZXR1cm4gcmV0Ow0KPiA+ICsJfQ0KPiANCj4gbnBw
IGlzIG5vdCByZXR1cm5lZCB0byBvZl9ub2RlX3B1dCgpIGluIHRoZSBlcnJvciBjYXNlIGJlbG93
DQoNClllcywgYWdyZWUuIFRoZSByZWYgY291bnRpbmcgb2YgbnBwIGRldmljZSBub2RlIGlzIGJy
b2tlbi4gDQpJIGFtIHBsYW5uaW5nIHRvIHNlbmQgdjMgd2l0aCBhIHNlcGFyYXRlIHBhdGNoIHRv
IHNpbXBsaWZ5DQp0aGlzLg0KDQpbMS8yXSBuZXQ6IGVtYWNsaXRlOiBTaW1wbGlmeSBkZXZpY2Ug
bm9kZSByZWYgY291bnRpbmcNClsyLzJdIG5ldDogZW1hY2xpdGU6IEFkZCBlcnJvciBoYW5kbGlu
ZyBmb3Igb2ZfYWRkcmVzc18NCnRvX3Jlc291cmNlIGFuZCB4ZW1hY2xpdGVfbWRpb19zZXR1cCBm
dW5jdGlvbnMNCg0KPiANCj4gPiAgCWlmIChscC0+bmRldi0+bWVtX3N0YXJ0ICE9IHJlcy5zdGFy
dCkgew0KPiA+ICAJCXN0cnVjdCBwaHlfZGV2aWNlICpwaHlkZXY7DQo+ID4gIAkJcGh5ZGV2ID0g
b2ZfcGh5X2ZpbmRfZGV2aWNlKGxwLT5waHlfbm9kZSk7IEBAIC0xMTczLDcNCj4gKzExNzgsMTEg
QEANCj4gPiBzdGF0aWMgaW50IHhlbWFjbGl0ZV9vZl9wcm9iZShzdHJ1Y3QgcGxhdGZvcm1fZGV2
aWNlDQo+ID4gKm9mZGV2KQ0KPiA+ICAJeGVtYWNsaXRlX3VwZGF0ZV9hZGRyZXNzKGxwLCBuZGV2
LT5kZXZfYWRkcik7DQo+ID4NCj4gPiAgCWxwLT5waHlfbm9kZSA9IG9mX3BhcnNlX3BoYW5kbGUo
b2ZkZXYtPmRldi5vZl9ub2RlLCAicGh5LQ0KPiBoYW5kbGUiLCAwKTsNCj4gPiAtCXhlbWFjbGl0
ZV9tZGlvX3NldHVwKGxwLCAmb2ZkZXYtPmRldik7DQo+ID4gKwlyYyA9IHhlbWFjbGl0ZV9tZGlv
X3NldHVwKGxwLCAmb2ZkZXYtPmRldik7DQo+ID4gKwlpZiAocmMpIHsNCj4gPiArCQlkZXZfd2Fy
bihkZXYsICJlcnJvciByZWdpc3RlcmluZyBNRElPIGJ1czogJWRcbiIsIHJjKTsNCj4gPiArCQln
b3RvIGVycm9yOw0KPiA+ICsJfQ0KPiA+DQo+ID4gIAlkZXZfaW5mbyhkZXYsICJNQUMgYWRkcmVz
cyBpcyBub3cgJXBNXG4iLCBuZGV2LT5kZXZfYWRkcik7DQo+ID4NCj4gPiBAQCAtMTE5Nyw2ICsx
MjA2LDcgQEAgc3RhdGljIGludCB4ZW1hY2xpdGVfb2ZfcHJvYmUoc3RydWN0DQo+ID4gcGxhdGZv
cm1fZGV2aWNlDQo+ID4gKm9mZGV2KQ0KPiA+ICAJcmV0dXJuIDA7DQo+ID4NCj4gPiAgZXJyb3I6
DQo+ID4gKwlvZl9ub2RlX3B1dChscC0+cGh5X25vZGUpOw0KPiA+ICAJZnJlZV9uZXRkZXYobmRl
dik7DQo+ID4gIAlyZXR1cm4gcmM7DQo+ID4gIH0NCj4gPiAtLQ0KPiA+IDIuNy40DQo+ID4NCj4g
Pg0K
