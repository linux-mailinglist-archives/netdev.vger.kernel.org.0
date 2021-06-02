Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F569397EFE
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 04:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbhFBCZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 22:25:51 -0400
Received: from mail-eopbgr40071.outbound.protection.outlook.com ([40.107.4.71]:64323
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230518AbhFBCZe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 22:25:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P6O8SQi0FMmqMlh8N1KQhf7oxQnAKBXiFOZeSZE/Mc/ynxZSJqYeUVzBbovQgPRxN/Y8T4Y9T9tZpOAXUD+tcKyGyPUTiZWDOGGtYwm26Mjjm+VPxCWVfUJAp1KQjsVQRbqYPF8xDMKYMhPV2JnBh5peI5ZHg4+3yW1Kl30YYcryODBmzMaXf44kHklNI40xgEAT9rrdH/ZsXkAYWJk7ETLut6WT18+ki/HO4ZOtF4dyaL9Za0klIwl6NUQu3y/Djhc4kyFmeEaLRYvbLiAvtyZBivgCB/mG0XmGp08byAK57+FmpUl45Nsl+kNnXaoM0nyAoj6uXVPvNDXasbTIcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dn86TYSCmWM/KRfrkCYlRITmF9t9jESc7K9yV+Y6AK8=;
 b=XU3ky4urjsAGB+NXKEKmmPhGJQ31R4/NSqvxPtJgokjBuwHPfmjm67NFOc89vxNrg1BUiUKMIk7ESo4Z+Z5DvFyGQJ4qcz2KONIqPXUMLjii+hXt7xzMHUNjU4jY/c0dMzFPAo0idzkrUjzJpnLWnQ2c6xvlwdZaTlX0frzqPKHKIN0oNk65KdEuQ/Pblkk56VGX7O5RmwPSRoFdFBKe0rIDPyJ1jmpzENmHQI8XJMrToSxnSMjXxZ0PNtcRs9tVJyl/OV2ugbEgarPLh+UxeXg2Ygw/003uJARdMvKO/lLSrSzP2ae6rbxkTHE4JmRNIHM2/2yURUkctvLE/haSNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dn86TYSCmWM/KRfrkCYlRITmF9t9jESc7K9yV+Y6AK8=;
 b=LpixBS8lBwuMF1y13I5pTO+jBM0L8Ew8KRO18NJsrD2z+HcN6pXCVvBcmZbWoTr6eQH7azW8ZHw3jUTylVbd3GhvbXTjgwOs3IrFq1gsvVG095lDEC+u6HnhFAV3956ycewjOyTIHsShv6QYK5e7VB8GS7legezYdVe4FdoOkUw=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB4523.eurprd04.prod.outlook.com (2603:10a6:5:36::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Wed, 2 Jun
 2021 02:23:48 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 02:23:48 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>
Subject: RE: [PATCH net-next 2/4] net: phy: realtek: add dt property to
 disable CLKOUT clock
Thread-Topic: [PATCH net-next 2/4] net: phy: realtek: add dt property to
 disable CLKOUT clock
Thread-Index: AQHXVsUrYIqLsUimNEavP8iLTUfcA6r/t5QAgABGrSA=
Date:   Wed, 2 Jun 2021 02:23:48 +0000
Message-ID: <DB8PR04MB679560988832E69559F467F0E63D9@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210601090408.22025-1-qiangqing.zhang@nxp.com>
 <20210601090408.22025-3-qiangqing.zhang@nxp.com> <YLavtkj5YO4WGlLd@lunn.ch>
In-Reply-To: <YLavtkj5YO4WGlLd@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 926712be-8e27-47aa-401d-08d9256d74a5
x-ms-traffictypediagnostic: DB7PR04MB4523:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB45232DEAD3304A4EE91E4B9BE63D9@DB7PR04MB4523.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: k8FiS2A5Kw6U7mPs2VwpAMRPnEAW29q86S7eSU5J+qtizwenjNuUfpBlTdZNUJZ3JOQ8r7ItTjwR41k4kEQkOoKUyGpT4NsfFsTGN+U45Bs8AoPTpMSTr+nEGBY17jwv3ZRFjdQ74qeFPhCERfTDkOLhU0PusRJB4Y8tmYfNKFt/USnaP7QQ2pr63WJTxU3pbCAWtzlMdeG4Z1+W1/gP5LC5q+kAdLrimlNYYrQw8+Qyv/VapOXiG/5iDVSE+tLTevKuHF7ZIKYfFiCZSuEbAchQfjYk/rKpMPx3GnL+hfG+M6BSZNNGe8e1R/V2oQjF0bhRpwDTimoTu9jCPWIpkvByNyGWpCpBEwVVp7G8wN9HDZqIW3P1wjhymAXGj1LgZJCdW4SUl286BwrvkYAj6l4llLeHhxv+0NxfuS0ZmDOBu7WLLLuUu4+0GvkRKmMnSm1ZmRrZmyEObXLwm5+T1AyKRUza9tg7UovZyBrpKSww0XZnYeycyYIf4A3vGDEb3fLnMJAjHS+ElGyQ+VMe/S6mDq6Vv+8In6iEaIPk7L/+mJ3lNPsAsS9sBmDphz3h73pUXivE7D8S8xNuqa0TQBqZ/TVDVPCllYCHhaiaRgA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(39860400002)(346002)(366004)(478600001)(4744005)(38100700002)(122000001)(66556008)(4326008)(64756008)(55016002)(66446008)(26005)(76116006)(7696005)(8936002)(2906002)(66946007)(71200400001)(33656002)(66476007)(8676002)(7416002)(54906003)(86362001)(6916009)(186003)(9686003)(6506007)(52536014)(53546011)(83380400001)(316002)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?ZjJnV2Y1YlpmUnlmTTJrWCtSWG54NTlabGgzeFdtM3V4dUd6WmVWMDJBK2gy?=
 =?gb2312?B?UHVNZkdXcFVtRmxoOFFBK2h1WWgwUHZoWkh4TUN4R2N5MGxxaUNLcHVQY0U5?=
 =?gb2312?B?YTJja1lIeUVaQ3lqV1JQVS9iYm5SOFdacEJOaXVGU0hqZzNzM1JwT2JZUERK?=
 =?gb2312?B?MDVyeUhNUDBBaSt3T21YSXluWWRISGk4OVhqS05jSlBpd1prYnB2cEdqam9o?=
 =?gb2312?B?RnBnTEpwWjJnMDVBT21mSGd0UWRVQTBoMkk2NnhJcmM1ay9ZUTZ0aisva1Nw?=
 =?gb2312?B?emRQbFo4MTRwTk9QQytHMUJNemxnREtCa25IR1g1MEFrcGZ6eWkvS05TbXEr?=
 =?gb2312?B?NVovRXRXeVR6aWlSQzh2YUZvTzJialh4TUJySTJZMGFiRWM3Z3ZDRWtkSUtP?=
 =?gb2312?B?N1kxaTBjVHdOWUZtYWRxK1pIcHBTTnlWVk5nUHUyZlNNbTZ6R1FhL0RuOHBy?=
 =?gb2312?B?dmI3T0ZqTEhlMVNraFlLOHdkRnhLaHRlUkw3bW5CSjdMTWlmNmFOZEdEVUZK?=
 =?gb2312?B?VVR3Z0xCbHZudXB5Z1FHcnVwZURzMndNaUhXR1gzWnc0WkRnUTdTQUJHNGJS?=
 =?gb2312?B?ei91YjlJdjJpaVgraTI2WHZqOStvZEo1Z0JUOVBBaVFpT0c1R001cW5vSk1Z?=
 =?gb2312?B?bkhxZ1VqdDkrV0tVTTRWZEM2cE8yUXRGRnc5VGQxdWFFdWZoRDEyVE1XV3cx?=
 =?gb2312?B?RFBTT3Nsajk0YmdYNGdGNGJqMEE0UkJCVGd4THNGK0NGSEc2aXczVnkrVUhW?=
 =?gb2312?B?ZE9oRDFjZzlsNk1oWHp0NTBaeWFvME9PYzNlblI3VnJBZlQ5R2ZOVXZRVS8v?=
 =?gb2312?B?czJWVXB0elZieHZJbDNnaHhKZWorRGRGL1dKQUJtOEZueXFaZGIyOGp6akVJ?=
 =?gb2312?B?SFIrSlRRQkR1NEord0VGQktoZEcwaUdET2IxQXM4Qlg3djJnbFFLd3lvZjh4?=
 =?gb2312?B?WkZqZUNxZHdFL2pqK0pGRXNQWkkrNFI3c2dGKzhGb1YwamhZSGdEWFc0YzF5?=
 =?gb2312?B?OEh6eG54akk5bnRtOEZsYW9HR3VseWxXbVlZWUlKdUl3ZWJncC90OUxZWWR6?=
 =?gb2312?B?ZjhDazJsNXlqRG9TV2FUbjlyZ28za1F4OFFIV3RlaG9HR3hKS1p1TkFsWlpD?=
 =?gb2312?B?UGpYOEErUm1XVWRXejF1M0ExcmwrdTVVV0QvSDNYZ21aOHg3eFQvUlh4QzRG?=
 =?gb2312?B?cGZNQVIzaDFqL1lMNnhBWGhvamJxM1dtVElLSGZWYU5HbE5tbG9NMmh5d3pt?=
 =?gb2312?B?NnJhdk5IT0M0OXRhOUprS0xBeDR2QUZHeVcySk9yOXJCamhoL3E3ZW4wNEU0?=
 =?gb2312?B?c3R3Kzd4RmlaNjEvS1B1KytpTjBKQzVCd25QRE42cjdZZytyOUtrbnNTU1NJ?=
 =?gb2312?B?cGw0aE1vRXVnOTBoT2tZVWZaVFhiNC83bkh5YUlQT2tnbmVNZzFpRkNmS0Vq?=
 =?gb2312?B?NWx0RENnU2s2aHg3bk5vdWlCd0dlQjU5L0dlMWJXVG05Qy9GNGxUOEY0ZHMz?=
 =?gb2312?B?VGlrQSs0aGNZaXJTcCtsbTcyaitrdDRxWU0vTXE3bjZ2US9xbjlXZ09QMG5H?=
 =?gb2312?B?YUpkdE0rU2c3Nm01bytKS0xlc3h2WEFJUjlTaDVsdGwwSXB0NXV6TzV2cURt?=
 =?gb2312?B?QlYzdXVHekRtd0diOVNqSGFJQi9kc1hYTWZ2bkVKc3dBTmlxRmJ6SzRmTHBM?=
 =?gb2312?B?NjZLWG56WnF5OU1IWGZLMHJNemFLNEF4THorR3FHd2JDOFIwRHc4cld6cVY0?=
 =?gb2312?Q?xN2ARKVxnruCdxtY8iWrXq7gZ2YKBfA9QtQRiAb?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 926712be-8e27-47aa-401d-08d9256d74a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2021 02:23:48.7250
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WCEp0VUn5WvcIICppxYiGKI3ftcBYkFeJ9H+wVStRCXJDLdbvB0jfGpGywJqreQd7aO56vTx8EjvMGu1uZBnEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4523
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBBbmRyZXcsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQW5k
cmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPg0KPiBTZW50OiAyMDIxxOo21MIyyNUgNjowOA0KPiBU
bzogSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4gQ2M6IGRhdmVtQGRh
dmVtbG9mdC5uZXQ7IGt1YmFAa2VybmVsLm9yZzsgcm9iaCtkdEBrZXJuZWwub3JnOw0KPiBoa2Fs
bHdlaXQxQGdtYWlsLmNvbTsgbGludXhAYXJtbGludXgub3JnLnVrOyBmLmZhaW5lbGxpQGdtYWls
LmNvbTsNCj4gZGwtbGludXgtaW14IDxsaW51eC1pbXhAbnhwLmNvbT47IG5ldGRldkB2Z2VyLmtl
cm5lbC5vcmc7DQo+IGRldmljZXRyZWVAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdl
ci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgMi80XSBuZXQ6IHBo
eTogcmVhbHRlazogYWRkIGR0IHByb3BlcnR5IHRvIGRpc2FibGUNCj4gQ0xLT1VUIGNsb2NrDQo+
IA0KPiA+ICtzdHJ1Y3QgcnRsODIxeF9wcml2IHsNCj4gPiArCXUzMiBxdWlya3M7DQo+IA0KPiBJ
J20gbm90IHN1cmUgcXVpcmtzIGlzIHRoZSBjb3JyZWN0IHdvcmQgaGVyZS4gSSB3b3VsZCBwcm9i
YWJseSB1c2UgZmVhdHVyZXMsIG9yDQo+IGZsYWdzLg0KDQpPaywgSSB3aWxsIGNoYW5nZSB0byBm
bGFncy4NCg0KQXMgUnVzc2VsbCBraW5nIHN1Z2dlc3RzIGFub3RoZXIgc29sdXRpb24sIHdoaWNo
IHdvdWxkIHlvdSBwcmVmZXIgdG8/DQpJIG5lZWQgYSBjb25jbHVzaW9uIHNvIHRoYXQgSSBjYW4g
c2VuZCBvdXQgdGhlIFYyLCB0aGFua3MuDQoNCkJlc3QgUmVnYXJkcywNCkpvYWtpbSBaaGFuZw0K
PiAJICBBbmRyZXcNCg==
