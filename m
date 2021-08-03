Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA7C3DE436
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 04:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233598AbhHCCBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 22:01:35 -0400
Received: from mail-am6eur05on2062.outbound.protection.outlook.com ([40.107.22.62]:29985
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233200AbhHCCBe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 22:01:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OFSCvI7pQkKmgGPYIDsrWgxKM53wV214b5zVf31DU/WQOC8aXNeU36pko+jrOxZ3gkPVX/eQp3oSJNYcp0+Gwiiz/h3U35zTBlnKkKs5WS/CnDXm2Dm+gQfoo9mw0W46ltGQjLLUmN6yiLq+eDffw61K/sSAzvsbDU09GoDOuQaoAW405KuBiuAHKApkG6eYtjGRDEy7S+CcHYLait0ryFx9475/ZFK87mI0n93dNVpSqLfIxz92B8a7rntnANJqRHKu428U3qowLnoxOw48fotPKW2OerZnrcg7U4wYGepXOphLdP5ycHkI7FMXbwNF3RNQQaV1cU0vppgypacugQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WEcSARZy7O8WWHZ0a8nVQsJ36fj/F1rJcnvD5qZ1NNY=;
 b=aOVa7r+fMqq3OiHgnr1vuzLg5B1Pm2Wc+6Mumgdf8/9lQTgrVlQEYOoK0QXlSzR39VfRGmQiXKU37nIlIOKNERAg2DgTIzmnkj8q/+QUgF1vE11EEzoPQK8CcZMkpEodatj7/HiYXm4YGbGBN4atD+g/eAzKY00r3aQKHT6CyUz8+tFBKrQWBJUHh9AlYeig+148Ipp/lVBDS7ufY5tBjePvtIl6PHjH4JJVOFe5Wk6IwPhRjE5c+boXQN5cvYw+UghQ5D1cVoocPTUclGLELsDcijBCxY2VoxfulpXwnpxUQMJOlCF1hSEPnpbPo000iRZNhOox+BEhrarxzhrIpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WEcSARZy7O8WWHZ0a8nVQsJ36fj/F1rJcnvD5qZ1NNY=;
 b=bPfJkKEu6x7pg/obZ9Mms+7VMqLIZKwbqlgeS/2ZqmkJHu69wZAJz+c8qTNq62A5tYw7WSnwLLx/pJPfKcGgy/fqLwsrWdKJ6Edh5VtviBw2KK0vGJuDHb7hOV9/8iv4HtZhdNf8R+mNRHnBy3eSjIPJVamHLUdk4EJhVmgzqAw=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB3962.eurprd04.prod.outlook.com (2603:10a6:5:1a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Tue, 3 Aug
 2021 02:01:21 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802%9]) with mapi id 15.20.4373.026; Tue, 3 Aug 2021
 02:01:21 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] net: fec: fix MAC internal delay doesn't work
Thread-Topic: [PATCH net-next] net: fec: fix MAC internal delay doesn't work
Thread-Index: AQHXhTi1YbhedU4i7EaozSEeEkQvQqtgsJYAgABbpiA=
Date:   Tue, 3 Aug 2021 02:01:21 +0000
Message-ID: <DB8PR04MB6795B1DA6A99BB90F82AD4EAE6F09@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210730114709.12385-1-qiangqing.zhang@nxp.com>
 <20210802133230.1a17ac4c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210802133230.1a17ac4c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8b859daf-f115-44c8-8666-08d956229747
x-ms-traffictypediagnostic: DB7PR04MB3962:
x-microsoft-antispam-prvs: <DB7PR04MB39627BCB90C673A0C066B3D2E6F09@DB7PR04MB3962.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nIIhAwtnBHCq7Fa9SCqQ+g836Ah4Y1S8rAYwJu47CZN8ONc+fhL7fCWn+zKN+M0ceQvd0D7n9ssca/YYfuLt54aCPBOt+i6Qct3IFpHU5ixYoWHCN93gcgiG4pMjJi/zwLMHiqGlr24b56mIb8rCUE15mFewxjCIJjJWAuLYRD9haTtuorv3mRyowHMJMVpnHm04bwSyIxzVijCqDG9urH7rgT/IWntYbqrT7gaCaAjvc0SYZbMuCOsNXZp8NXMDyGjM3H8O8wGelpKHW7YE6PJVtl0CHdgjll/Y8P/6UVaVF0t8htr1yA0qCmmw0IrqJsKyCrP/oSARjLahXR9fPIx89HFE7OWQFiV4wF9UTL0Efb/M1QyYVNM4m4pDCwV2DGy6Sy2nMGkkCciQbjU2vULXIPTQ2p7i5ljyyWKBUkSJmN7BC79hh+KocXFjkucapRJt1SvmCp8Cis+YdRWr1weRHQuSngP0H6H12rqNOOZEzyZ2qI9EGSvUvEBszXKgvFJ/Z/oNX1azvDSDZESihiMVecnXQfBBRZe4uVaTi7s/8y98I5MTjAtrFo7HU5Vqb1LpN7VyD4pvFn8qacioTyo11WUU4QU3UWMa+hNxFcAPkcIrHNvBMJa6E08jeFTuJ5T/m3Td/OZLgC3xIyqNNHfXM8osIEe9DmfaFyBWuu2GG+Lp05FB2GUZeWumcQVIpCZK9xAfB/DN2efKxiMDug==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(71200400001)(8936002)(8676002)(52536014)(55016002)(26005)(6916009)(9686003)(508600001)(316002)(2906002)(38100700002)(122000001)(38070700005)(54906003)(7696005)(86362001)(33656002)(66446008)(64756008)(53546011)(6506007)(66476007)(66556008)(66946007)(5660300002)(186003)(76116006)(83380400001)(4326008)(4744005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?ZmtzMk80ZXk0cWlzNmhlZHAxaHFWZEVTUzFtL2tETlhETnJPdFZ4d3BLVWFR?=
 =?gb2312?B?K2d3ekp1WXZTcWlIbUF4YWdMS1JKaG1zcDlSVjdXbGFiMW9pRms5c3Nzci9O?=
 =?gb2312?B?YVhNeVNSakxidExuNEtLY2ZOd0x4WDlIeFBBSDFqdVd6QnZlMExjenFjNW0r?=
 =?gb2312?B?am9EVGtoV3ZYUFpuTnBQNzRIMTE5NkFQRUFJMmh4cVRpZEh2Smd3a09aUXJo?=
 =?gb2312?B?emF3ZGczdlhLY0Fsb1VINmhGWFYxZzRGV1JGZFZlNkxMcDZkeFV3WXdzTFR0?=
 =?gb2312?B?OXhXWkRTYWppOVNxQ1R6QWFHckw3Wi80aVk5WE0rTEMyYzk4eUo1d0xvVzll?=
 =?gb2312?B?cVRCV3hocW5RTVVYcnVjTmNyZFF4L0pFU3VJSWMyZnEyRW5vblFhSVhYaHA1?=
 =?gb2312?B?cnJwQk1ucG1uZy9GUUgrSFY1cW9BY3Z5YU9Xc3hwakw5a1B3TGNTL3Y3RXh5?=
 =?gb2312?B?ZFYvSmtCTG1oZmRUQkFIYlB6bmZoQUlpM1NGV2FmSFlmWlRNNUFKMUc0ZVNY?=
 =?gb2312?B?TXdCS05HTVZYTVQvRHBkdmYwVlo5b3dMaG05andZWmsvZ3ZGY0J0eEJhYkpO?=
 =?gb2312?B?cmJ6NmIydXhXL3lBMkdlUU9HWjJyd2UzR3ZuT0luVHA1Sy9PUjJHM2ZueHJW?=
 =?gb2312?B?eXpkdXViSERHRGpRWlZOS25UZ2s4eVpzalY5bEJrdkUzc0s1NU1LNVc0MDZS?=
 =?gb2312?B?VGlXSWp1aE5zYXBITUJkVC8zSzhKWmdSdlZ0ZUNUUWZHWlpIUHVwVmJFU1VG?=
 =?gb2312?B?K0pvY1Q0cnNROGpFMGhISVE5cUFFSkNzUndzb1FyN2RkdjhKZ3g0dU1aS1Yy?=
 =?gb2312?B?WU9qUU9RNll5eWhROENmOFh6NXRvUHVna3ZVU1hjUVNBTnV3TUp3d1g2RWl4?=
 =?gb2312?B?ZzlnRDFYV0cvWDFENHgxbS9XZDBmemtpL21yc3gzc0pjT0R1cXNQWXFMZFVz?=
 =?gb2312?B?Q3UzWG5Ba04vQ21NZVAwdmIzUC9nSnA2VVgyV0NQL0pGQzNEcDV3SHBNNHc5?=
 =?gb2312?B?K2hYSU5RbXBFUlBleFVFeVQ2MHRYdWpPbXZzd0VEeVMwMWp5WndhZTczZjV1?=
 =?gb2312?B?bkNjbFNMK21BSzB4MVl1a0Rlbi9ZZlNzMXdHcUhtblhJeGtqZXFSdlNOdE94?=
 =?gb2312?B?SnhFY0FzVUZBTEQvbmhrRERmSHdDZ3Y2c1RLVUpsTkxXSDdaOEZxdXJ5eUMr?=
 =?gb2312?B?ZWNDUXQ1SForRGpEU2JDWHpEcTVGUzVlcGFGNzVkVXdMUC9DVGtkYXRrN09k?=
 =?gb2312?B?V2pwR3R4d25CNVFrS0NmMHRyMUdmZ05hRlBQS3hFT1gwZUFUNmhOcm85T3FK?=
 =?gb2312?B?QjdXWllyaWRxS0l6dTl4M011T2NXRGgxcklsSmtXWGlhcEJJR0NnblVLRG9r?=
 =?gb2312?B?cVo0Y0JIRW5Mb0RRRVlyaW9rczdSMXZmRGswNUVYemdRQjdwVzZIS3BrUzJB?=
 =?gb2312?B?ekgzSGlKN0taNVNJRS94OU94ZnJheTZmZER2ZDZkbjlWTXJmVytLYXVnemVD?=
 =?gb2312?B?N1JFdEJSakU4WXdwb3htMmlieHJCRmlLV3JxWmtoMEcrbGszVjlPMUxuRUxG?=
 =?gb2312?B?T2FYVXNhZWIzckFmYXNIWmc5U2VINFcrTlR4ZThzM2praWlPS0FESEVhYWpi?=
 =?gb2312?B?ZXVWazRnbWIvNm44TGt4UGFmMHZlTW50N3NPZm4xUHhNakExdWdrSzRaRlJY?=
 =?gb2312?B?U1JGbnJzUzgvekEwU2ErLzNSQ1pmRnlpOE5aaG9oekdGOXA1WHZYUVlNS0FI?=
 =?gb2312?Q?SgE5B4CzEsHK1pK19o=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b859daf-f115-44c8-8666-08d956229747
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2021 02:01:21.5633
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eObm1iHduwIPs8JHMOZsVcnfXgVHzlNZdqJrXCP/v9gkEe2IHY+bLDsy27pYxxgTjvW2KBQbQGulp2oLWlzYaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB3962
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEpha3ViIEtpY2luc2tpIDxr
dWJhQGtlcm5lbC5vcmc+DQo+IFNlbnQ6IDIwMjHE6jjUwjPI1SA0OjMzDQo+IFRvOiBKb2FraW0g
WmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPg0KPiBDYzogZGF2ZW1AZGF2ZW1sb2Z0Lm5l
dDsgYW5kcmV3QGx1bm4uY2g7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7DQo+IGxpbnV4LWtlcm5l
bEB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dF0gbmV0OiBm
ZWM6IGZpeCBNQUMgaW50ZXJuYWwgZGVsYXkgZG9lc24ndCB3b3JrDQo+IA0KPiBPbiBGcmksIDMw
IEp1bCAyMDIxIDE5OjQ3OjA5ICswODAwIEpvYWtpbSBaaGFuZyB3cm90ZToNCj4gPiBAQCAtMzgw
Niw2ICszODI3LDEwIEBAIGZlY19wcm9iZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQ0K
PiA+ICAJCWZlcC0+cGh5X2ludGVyZmFjZSA9IGludGVyZmFjZTsNCj4gPiAgCX0NCj4gPg0KPiA+
ICsJcmV0ID0gZmVjX2VuZXRfcGFyc2VfcmdtaWlfZGVsYXkoZmVwLCBucCk7DQo+ID4gKwlpZiAo
cmV0KQ0KPiA+ICsJCWdvdG8gZmFpbGVkX3BoeTsNCj4gDQo+IFlvdSdyZSBqdW1waW5nIHRvIHRo
ZSB3cm9uZyBsYWJlbCwgaXQgbG9va3MgbGlrZSBwaHlfbm9kZSBuZWVkcyB0byBiZSByZWxlYXNl
ZA0KPiBhdCB0aGlzIHBvaW50Lg0KDQpZZXMsIEkgd2lsbCBjb3JyZWN0IGl0LiBUaGFua3MgSmFr
dWIuDQoNCkJlc3QgUmVnYXJkcywNCkpvYWtpbSBaaGFuZw0K
