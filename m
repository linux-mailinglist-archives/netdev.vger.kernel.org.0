Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26D5C34A7F5
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 14:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbhCZNTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 09:19:03 -0400
Received: from mail-vi1eur05on2066.outbound.protection.outlook.com ([40.107.21.66]:49251
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229986AbhCZNSz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 09:18:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a0xxuJ+6+oshHYyIFs6oK6vD6zHRbuarPMkhPzVZfr4QUgZcYB26pJUOlDD58AeT2CKlGQN2vyliPnD5xCdnBxVWoTT3xSPhfs08yxtl/3GndposctyXe6GWKLJz7NOCLd5e5J+rGq5LAO6QOdxuCicFSAnaAIqNCf3FFGEWgu+7x+FbkS7IOu6lu+nKasfkXVQKEywVw55v7r6LnQz56iWzcXZLVa1AToOIyv4wo/qJiMXa0CZMpfyIObasz/4hvRSP67n0CHif/wrQpE+jesiIDZuA1ZMYiy5AQ6CBOyeExI/Djr9WotlHnuoA/ZGDdOpRctji6bnIDwd+twjjQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gPPLM/1ixYnLD9FtgSi4BJrsEAjUGfYeTL+nJ/1Y2NQ=;
 b=Uu6QodqySTSXeSyXqKddajgfB1GJ9W9XpyU/mOM5A8w9v5JoSxoGKwFKpqkSa6vLJk+sY+UZWOVdzEc/IGZXHZjQnbbkl2yMYygJqexQ1++RaulukoPnmP4Dcw9I4O/JCAkwgeTnlwN1rR7QKqJjA+1CTIhFT7g9uoVCFs06mVHflcXmPSTmjxnycrgvVNIPJ855X6SDGw2ecslEeKCxP0+r/Elzw31oFIk4YDk1dvVRmhKENrk7BUJS7iURl3Ejww9jWbefTinM6TEwoWl5slz0H1wLE53BTlx6ITXxDJKX600+YPFTz0tixwnbywZTe/J/O3Jc8Rkre+mML/O8kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gPPLM/1ixYnLD9FtgSi4BJrsEAjUGfYeTL+nJ/1Y2NQ=;
 b=bohqMxN+EMm4QURsgTS9EA9vQxlQ1B1HhiXSZEyUxX8z1Hym3v09zz3pW8NUhYwaqEYCu5Dk0jRut7s82XgZJPPrXBHwDliJGnZbFWVA6zLM/ePwx7k4JwCtm8QVk/ATLI4q/ExUS4uKu49zRg6toYQCk89DorPsTezGHU/MbPI=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7382.eurprd04.prod.outlook.com (2603:10a6:10:1ab::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.29; Fri, 26 Mar
 2021 13:18:53 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5%6]) with mapi id 15.20.3977.025; Fri, 26 Mar 2021
 13:18:53 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: FEC unbind/bind feature
Thread-Topic: FEC unbind/bind feature
Thread-Index: AdchTA4mhHE+X6FhQBmQJxJLMagesAAKJ/aAACgNBSAAAM4PMAAJDS6AAAF9srA=
Date:   Fri, 26 Mar 2021 13:18:52 +0000
Message-ID: <DB8PR04MB67951448528CEA7DF6661611E6619@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <DB8PR04MB6795E5896375A9A9FED55A84E6629@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YFyF0dEgjN562aT8@lunn.ch>
 <DB8PR04MB679514359C626505E956981BE6619@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <DB8PR04MB67952CC10ADC4A656963D871E6619@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YF3UvaMpaXcFxU5y@lunn.ch>
In-Reply-To: <YF3UvaMpaXcFxU5y@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 092d7ab3-f003-45e0-9749-08d8f059b3d5
x-ms-traffictypediagnostic: DBAPR04MB7382:
x-microsoft-antispam-prvs: <DBAPR04MB7382778A5F495F4E90C6B1E7E6619@DBAPR04MB7382.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fkriSNKkxtN4xC/8sGCCh6WCm4HH/CWYfLBgujUdcYPuIWcyb3oXiVJtprOtf+oKWsdXq3XqQVLTYQdGNVwQpqG3abhzeNZU86dDt6atmSgY2ci/x2HRiKvonpi5yuDV2yGhVC88cRspsz1T0dc4kAaNDEjJFFuDKSPpVuJcfWKp1/gvz3wcmd0o2ibVdjOneFwCm94outwFoDXaahXi/v700QU9Q8M3G4re+7ivIxq/RFeFdqyTzxIyq8CGY2m3KsQNkO/9zIwPfL+HBQnk45ANhgeOpWSyuF/yh0hsaBPljrU7M6jC8SD4USs16+s85j4eh5Csxu8ItG121WNgXGdwf9yVy2WZVswiVgodsi3+Erw148zjwL0tpmE0ci3ZClt03nbM50gQFNsBTYsx0vn0XweeiFK28XpyT+IHUsbt7GZsZl48vXOCFx+BWafg0vOlrWl7ePziaO9MeUBSUgYjhhZm0TW5YdovN5nqQ89PCKtbiG30bFMveiwG++y1x5SA1swGqy8j82psRkC7xEATYkzEsF+NJFX6GNf87V/YyRCvUDCCLVkUQ6m3AKQnyEVrLsC6P5Nym2kXGISUXb0QawvawPygicAXPSORP7zeLJ60a+DCmRIOiPCA8VM7IbaYp58R7jz+E2qtrTz0jofJhhEedVsvvmJHp9WTds8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(39850400004)(376002)(136003)(346002)(54906003)(316002)(8676002)(86362001)(26005)(4326008)(52536014)(478600001)(8936002)(5660300002)(66476007)(64756008)(66446008)(66946007)(66556008)(76116006)(3480700007)(33656002)(55016002)(71200400001)(9686003)(6506007)(186003)(6916009)(38100700001)(7696005)(53546011)(83380400001)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?OTZWYU1FZmhjblB4aiszeWNYb3NqRDJJRGNsRThmU2dZT1lSVUY1d25DejdC?=
 =?gb2312?B?cnliMzhkK3lDczB3L2xIelZOTlVBcGJBengrVVZsRHQ2WUk4RTh5aG9aVUlF?=
 =?gb2312?B?Ty9kakxKUFR1dEIzTWZndW9xRE91dE5nSkJDTDRIRk1EemorSnZUZWpNbWFJ?=
 =?gb2312?B?a0V6RVJqcGJrbWpvczRpYVFUWGc5VDRnTlRCUC9udWFZUkQzNUFjSDJBeDF3?=
 =?gb2312?B?QU14OGw0ZngxMmhFK1d2U2RHNU91SEdOVkhDVHBaQjZzaDVQSzZNVWRaOG1O?=
 =?gb2312?B?Yk8vVVR6eHEwNHVaZjRqWVJHNElzeE8wUlB1c21qNGJwNWVmWjF2dEJyYjh1?=
 =?gb2312?B?RHZrb0d3VituMjV6bGpWQW9RYXc4dHZIK0E4K3Y2dkRjVTRMdmgxVU1WVG5V?=
 =?gb2312?B?TFdYTWlDeHNJcFJ0R0lqNlJqMG04dFBkaFdmNnBDekc4cFBFS2Z2MUREM1hC?=
 =?gb2312?B?UjIwWTlwWnhxT2dEMjVOZ3VHa0E5c2xJMWUrcFRMV2JtWTRUTndzei94WTFL?=
 =?gb2312?B?ODlXVHJpbFhJTElYbDNhSGpQWVAwUEt1RnpsQkV0UXRjOUR4S0F0SmE0Ymwy?=
 =?gb2312?B?V0V3LzZuRjFSUGNSZDAzblFRL2NwbmREOHlubFRRNnpVUGtvcG9SdjJMTGY4?=
 =?gb2312?B?WFhPMmJDUmhIVS9xZnhHdjZ0aE03THdhL0lORnljakIrU0dQaFlJa0pPdkI4?=
 =?gb2312?B?MGthMmg2Qkp0SmVnWUlab0xTQlJaWm8wRng5SXIrR1RySGQrSldoMUpDQW5m?=
 =?gb2312?B?cTB2anJ6OEY1MmVGYWlqSHQ3Q05xMGdpQUhIQ2lJTnFNMXN6NGdHWXFGdzQx?=
 =?gb2312?B?NEVTRCtCOU1wbGJENkIvbXFUT0p1Y2ttUkpmMXMrNGh3ekxSQ2ZSSk9Ydk5n?=
 =?gb2312?B?TCtiNVY1ajhBcXdtMU5uQjh6Yi96aDgwSkt1R21HUlloZEZPc05QRHoyYnRu?=
 =?gb2312?B?MzFmeTB4Mysyb2ZLQy9SWjAxYTRGQXpZS3Q2aVA1ZlRUZWIvM1Mza0JhTkoz?=
 =?gb2312?B?U1JqWnRCTXh2SjBtdmdKMERWNEpNU3pMZjNSR2lYS3ltamlld20yZnJqby83?=
 =?gb2312?B?R0lQQzlRbHNpUkxLR3h3YUk2dllLV0JJQi9TVm5EbStmUktQbVBCZHZ5VUt3?=
 =?gb2312?B?MVhjck1OSEZtL1ZyZW42bE50OGVKejFYV0t4UlhXYk8zcXNqbDVHbk4vYjVx?=
 =?gb2312?B?UExUdDBXWVdDdXloMkxxVXVFUXVOWS9vYWE1UEpSYlNEQmFmYlNmcTlOMWpl?=
 =?gb2312?B?STRmL0RYMVF3OVRGVlhsYytiaW0wUTh6YmNhNkVpWXpHRzYrT1JzUmRzS3Fz?=
 =?gb2312?B?NWJEOHlnN1lZbkZkL3VKOEgrRTlybkg4WXJjUGJWVjVQM0FZdjFadkZ4M0Rl?=
 =?gb2312?B?NWR5cHVObEhCMWl1ZkZYRS8zczAwQkMrVWpoNkNQV2Q0U3lKY3N5M0VCL0VQ?=
 =?gb2312?B?NFQwMlY3MG85SU80Si82ZXpPRHhYaktQZHhYbzBMWE9xcW9SbFYvWk8rTmJo?=
 =?gb2312?B?T0tqUnkwcXNNZjV1eCtUcWZ0QTlTTFFreHNrazVDUXVWM2VvMUxZRkd1eWQ3?=
 =?gb2312?B?dVJGczJ5Qnl6UzRIVEU1aFByYmtpVGhocFBWRjdVV1FLUU91eW14T1ZrbXJG?=
 =?gb2312?B?djh6RllOcWV2RlVpRThJTXlVdHZZRmRtUjhuVklSbGI4Ym4zakdWZjBDdWJF?=
 =?gb2312?B?YnRXQi9zOUp6bTAvUkFISjBGeGY2Mmp0Q2s5cjZaaUE5TzBQT0w1UlBhMkoy?=
 =?gb2312?Q?ccK/YC/FHRsdTmtdXjPM/TrFg68h/UcA9KUG8lK?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 092d7ab3-f003-45e0-9749-08d8f059b3d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2021 13:18:53.1754
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eSI67aff3AzU+VA6g5m2xj6sH/7Iwb+WlIEeckisktx5hAYFS7jLpea4HrnovD4fpMgYW0/MkWK9+fWDB5IcJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7382
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEFuZHJldyBMdW5uIDxhbmRy
ZXdAbHVubi5jaD4NCj4gU2VudDogMjAyMcTqM9TCMjbI1SAyMDozNA0KPiBUbzogSm9ha2ltIFpo
YW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4gQ2M6IEZsb3JpYW4gRmFpbmVsbGkgPGYu
ZmFpbmVsbGlAZ21haWwuY29tPjsgaGthbGx3ZWl0MUBnbWFpbC5jb207DQo+IG5ldGRldkB2Z2Vy
Lmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IEZFQyB1bmJpbmQvYmluZCBmZWF0dXJlDQo+IA0K
PiA+IE9uZSBtb3JlIGFkZCwgeWVzLCBJIGFtIGxvb2tpbmcgdGhlIGRyaXZlcnMvbmV0L21kaW8s
IGl0IGlzIGJldHRlciB0bw0KPiBpbXBsZW1lbnQgc3RhbmRhbG9uZSBNRElPIGRyaXZlciB3aGVu
IHdyaXRpbmcgdGhlIE1BQyBkcml2ZXIgYXQgdGhlDQo+IGJlZ2lubmluZy4NCj4gPiBOb3cgaWYg
SSBhYnN0cmFjdCBNRElPIGRyaXZlciBmcm9tIEZFQyBkcml2ZXIsIGR0IGJpbmRpbmdzIHdvdWxk
IGNoYW5nZSwgaXQNCj4gd2lsbCBicmVhayBhbGwgZXhpc3RpbmcgaW1wbGVtZW50YXRpb25zIGlu
IHRoZSBrZXJuZWwgYmFzZWQgb24gRkVDIGRyaXZlciwgbGV0DQo+IHRoZW0gY2FuJ3Qgd29yay4N
Cj4gPiBIb3cgdG8gY29tcGF0aWJsZSB0aGUgbGVnYWN5IGR0IGJpbmRpbmdzPyBJIGhhdmUgbm8g
aWRlYSBub3cuIEF0IHRoZSBzYW1lDQo+IHRpbWUsIEkgYWxzbyBmZWVsIHRoYXQgaXQgc2VlbXMg
bm90IG5lY2Vzc2FyeSB0byByZXdyaXRlIGl0Lg0KPiANCj4gSSBoYXZlIGEgcmVhc29uYWJsZSB1
bmRlcnN0YW5kaW5nIG9mIHRoZSBGRUMgTURJTyBkcml2ZXIuIEkgaGF2ZSBicm9rZW4gaXQgYQ0K
PiBmZXcgdGltZXMgOi0pDQo+IA0KPiBJdCBpcyBnb2luZyB0byBiZSBoYXJkIHRvIG1ha2UgaXQg
YW4gaW5kZXBlbmRlbnQgZHJpdmVyLCBiZWNhdXNlIGl0IG5lZWRzIGFjY2Vzcw0KPiB0byB0aGUg
aW50ZXJydXB0IGZsYWdzIGFuZCB0aGUgY2xvY2tzIGZvciBwb3dlciBzYXZpbmcuIEZyb20gYSBo
YXJkd2FyZQ0KPiBwZXJzcGVjdGl2ZSwgaXQgaXMgbm90IGFuIGluZGVwZW5kZW50IGhhcmR3YXJl
IGJsb2NrLCBpdCBpcyBpbnRlZ3JhdGVkIGludG8gdGhlDQo+IE1BQy4NCj4gDQo+IFhEUCBwcm9i
YWJseSBpcyB5b3VyIGVhc2llciBwYXRoLg0KDQpUaGFua3MgQW5kcmV3IGZvciB5b3VyIHNoYXJl
LCB5b3UgbWVhbiB1c2UgWERQIGluc3RlYWQgRFBESywgcmlnaHQ/DQoNCkJlc3QgUmVnYXJkcywN
CkpvYWtpbSBaaGFuZw0KPiAgICAgQW5kcmV3DQo=
