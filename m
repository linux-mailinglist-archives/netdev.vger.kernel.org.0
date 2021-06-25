Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D09673B4236
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 13:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbhFYLMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 07:12:03 -0400
Received: from mail-db8eur05on2042.outbound.protection.outlook.com ([40.107.20.42]:29536
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229573AbhFYLMC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Jun 2021 07:12:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a4UvFZqUaRLJ1egnS/4Y/OA5m+DCAbUUVwvyUZpfSqz6K2e1QgpQ1+VK30aUERXkTikfxnxMfT67FKnh4QAjr1HT/ZWzCRB0cR4OHPHACxuA937ehRqvFsPDWg5lRF+/KnnysEdRvSP5O7wKndGsDdLlHtGQmkw6MCqC9AD8CUTpJvZMBS2AWdi/px7vk6FoOFlQ2ptUGZ9llwdcHyE93isDsZwnEpX5/oIiKBbh3Q8+UZlV/LNPU5gP5KARxm7AfCUUXAz6wfp1ngx+K9KAwlFiqGHpvO1POJ2F62+wZhjjCmo4LwPmIhSbjKov1G0ZX2hDjd0ZIeNxqFfGZx/lOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r7YZ6yWBD7Xv+D+fCg6H/dMJ4rZo5qHphfw74vp7A8M=;
 b=h3THvcY6uK3qvOJkyyZv8BNcMD8pjhqjaczRjuhOaTzVVZx/5vafDFk+m75mx3jIEUidxrE+hL2m4ELFsE/ZgFDu+JYyM7gYK4RwD/6Hgd4IwnSlq7HjPDrCuSpioYh4qgxDSj0qcBG0DC/DZTzrb/p44KbFbCDOvX+aQlK/DdHqmF9Vvbyc+z8cgwYRH0B/za4L2H37ai+XIJnEETuwWXYmDCz5J7Hv2Dq7LzuroTnL1jIUJ/jGhM5+Kr0gCSEskEOdBjqH/XE77scxvRdD+Xa2IpghvO66ABh93sP8z7d9ORRhoBXpH2L/O+QFi5fskUWt13dZJBwjnEILoRw6ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r7YZ6yWBD7Xv+D+fCg6H/dMJ4rZo5qHphfw74vp7A8M=;
 b=YCozTnXXb9LH1lAahrKvKs4w/iYkdaG1w6kt9FKTmLR4K3IMEBY21GEOX/WnGrLix8gm6MOCUsnghgyO7VZ1aAaaT+s3do++KfvNPmcTvJHsVpUdGwHUlOVgGCjuZhDwcmOwFtoJlOsUQb5wCkGoxir0EFs4585wiAfRCU7bpt4=
Received: from DB7PR04MB5017.eurprd04.prod.outlook.com (2603:10a6:10:1b::21)
 by DB8PR04MB6779.eurprd04.prod.outlook.com (2603:10a6:10:11b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Fri, 25 Jun
 2021 11:09:39 +0000
Received: from DB7PR04MB5017.eurprd04.prod.outlook.com
 ([fe80::605f:7d36:5e2d:ebdd]) by DB7PR04MB5017.eurprd04.prod.outlook.com
 ([fe80::605f:7d36:5e2d:ebdd%7]) with mapi id 15.20.4264.022; Fri, 25 Jun 2021
 11:09:39 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "mptcp@lists.linux.dev" <mptcp@lists.linux.dev>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Shuah Khan <shuah@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Rui Sousa <rui.sousa@nxp.com>,
        Sebastien Laveze <sebastien.laveze@nxp.com>
Subject: RE: [net-next, v3, 02/10] ptp: support ptp physical/virtual clocks
 conversion
Thread-Topic: [net-next, v3, 02/10] ptp: support ptp physical/virtual clocks
 conversion
Thread-Index: AQHXYcnwaUvaYN3/1UWKJ0RWryDTcKsYiVqAgAdTHVCABMRZEA==
Date:   Fri, 25 Jun 2021 11:09:38 +0000
Message-ID: <DB7PR04MB5017347E573293D98A60FB30F8069@DB7PR04MB5017.eurprd04.prod.outlook.com>
References: <20210615094517.48752-1-yangbo.lu@nxp.com>
 <20210615094517.48752-3-yangbo.lu@nxp.com> <20210617182745.GC4770@localhost>
 <DB7PR04MB5017355B61A31D61340A52A3F8099@DB7PR04MB5017.eurprd04.prod.outlook.com>
In-Reply-To: <DB7PR04MB5017355B61A31D61340A52A3F8099@DB7PR04MB5017.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 419a680f-b048-4c1e-0ed6-08d937c9b9a4
x-ms-traffictypediagnostic: DB8PR04MB6779:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB6779FD38316869BB0571B6F7F8069@DB8PR04MB6779.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xEqLp+amPLPyL7CIxn4wTP+EfVQ5DLFQLWAU4D6vTwtBi8qqhvSHGSRvlxVhRf+QP0gghCeoU5DhZwMorePlG4fI0bh5Iwe2Q8LCuwLi2v/c7X8mzReWeCIN6B8CqJTHfAeSrbywYZmuHjCrzYw0H9BfYpZ0ykakCCPSEWe+oP1SYg/ZvrCk3xnQJ9dwMyLV/kPgklN5HeegTEURUv2SC8tBqi5gsbIQTIyRFAhSwDAB2eTzPp1/nbf4QNQ7+njttyQVoNfbmA9QLxA9uRQXOYFeomQWnWHPzfUA8pYHcVDEnEip8Bs4xMKbXxLA0JOl0eGY2kbdKiCX14WBj6CezBbMJgosLb9c7VS5CUfN+AV7hyADRAog/dAdGFz+cYzQ8D3QJEzexFWH6eCMloc1BKrtD37m0xWP1CSIA3pKyPSH69PERQFxA2aYtcM1Mhl61JYPf0mxmF0F2E0ttjJ1AQk/ParQL2KmemFj9quqlPP89Wudx8xbFuqkggT7ksbVt8uNBrmDEEQ4exaZ6W37/pi/lPet5RjMV8hjuMuqYMUVdbKZ7IP109mckm4d3eLRSC//DuTVOnoOfGKRTUCFEeWnJ3uCzFF6g1kDv+hOxoE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5017.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(376002)(346002)(366004)(38100700002)(55016002)(8676002)(186003)(71200400001)(9686003)(7696005)(5660300002)(122000001)(8936002)(6916009)(54906003)(7416002)(316002)(66946007)(6506007)(53546011)(66446008)(52536014)(2906002)(76116006)(478600001)(33656002)(4326008)(64756008)(66556008)(66476007)(83380400001)(26005)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?V3EyOHNNUHpVWnlhWmpUZDR4WlBYS1crQi9wMkVmbUNvRGYrUWM5Y1UxRWNn?=
 =?gb2312?B?MEJNbm5qdElJcGRYd1Y5UGw4S1ByTTVLb3dIb0ZnMkJRR2F5Rm5kdnNPSUVp?=
 =?gb2312?B?VVR4UTBDQlJzNkUxRndXNjlOT2JEN0tpeTVJbzVQbkN3RW1kZG0wVllpN0Q0?=
 =?gb2312?B?KzhUQTd4RGlKdVJFKy9NM2gvN2ZKcU1McjZXT1ZjUk9pOERsSzNUbHBDeVd4?=
 =?gb2312?B?WDJkYVk3UktKU3ZxR3B1NlFvWVRRajFZTmlSSk5jVGlCanlYRWx6MkxyS0lU?=
 =?gb2312?B?d1JiQmRBSmxPSzJ1QmdzYVNwWkxRUVVVRmRpbGZSSVJnSVUyclloVmhKNzJL?=
 =?gb2312?B?elJTcFF5RUJpWGhtWUhuM0o0U1NJT1hDbThKUkZVOGNaNDBBckRoU1pRNU03?=
 =?gb2312?B?SVA2aHdQa3RlcjlMRmkwNmNuQzQzQkFWMjl1bE1pWjFrZ2xVOFZ6aytqUzFJ?=
 =?gb2312?B?QXZxUHRFQ3NmdWNJcU92aWdhM2UzOFpMSFdxZ2VEMXB4aXdIYzZIMWhuR2JZ?=
 =?gb2312?B?aUszeW1Vd2FibVJZZ2tySi9XRmhlUWlTaGRhZUU4VFEycEZPeEpldTd6TW5K?=
 =?gb2312?B?cDErYitBOXlFaHlyRWdmbUhjaHY2cmMzLzVxbUtBRVZTdVNOK0psWURPMklV?=
 =?gb2312?B?WUxadEZFZzBRdENPYi9yUThIcUJtODlvVllkYWY3czlXZlpkbHNRaHA1NUxt?=
 =?gb2312?B?NE9lY3ZnaDgram5jN2ZrKzNFTmtYb1F5MjhwTURLNzVJVG4xcm9HU2dCV3E5?=
 =?gb2312?B?R2cwU05iYWRSVDhROUNoOEl1RzdEeWRNWjRPUEVHVEpMRUU4cFBFVGMycDJL?=
 =?gb2312?B?ZXlHOXVSQTRwMkZRenA4TENVdXBwMkNJRjJydDlpSUdsZ25IZFgrVWxMNm5t?=
 =?gb2312?B?bDZSelJwam5oV0V4ZStzREVjemFhZURWL0ptUHY2UnBMQjhiVWZiWVB3bjgz?=
 =?gb2312?B?ZzhFQm54c3ZFbmlpcnBiOVlDUkNIczIzOXVkcFI1T3JEV25pcXFsTTdzVjJo?=
 =?gb2312?B?dzR1UkFQQ3dNbjJnbHZuZHBEbklhdVhUQXJzeG9aU0dKMUJkcjJoSmE2QWRS?=
 =?gb2312?B?eVQ0cHYyallJRHRBa0NLY0pKNWhjY0RqbHhXSFdWRGhZTXdoaGF0TlpvSEU3?=
 =?gb2312?B?RHRzOERpVFFaRTIwV0lOTWhoT1ozQmpMSmJzOXkrM1NTZ2IzN0NFdFBFWXhC?=
 =?gb2312?B?bXM1L0JFWEZyYjVYSkNqazY0SXB2SlNUN1pCMGJZVmlnc25zSlhsdXJJWUs3?=
 =?gb2312?B?ckFQcElTTGRKTmJScXljdDZYaWRrOVltbkRSd2hWd0txVnJDZWZyWkdWN05a?=
 =?gb2312?B?SWVZejVOWW5Gc3AydWd3b1BwWTFLc3BZRU12SXZjNVZLVXNyZ21zVnp5UVlK?=
 =?gb2312?B?VnEwRHpFUkhLL0prREpRT3J5OS8yMkZlSGU4V2QwYkp3emxONXIvUzl2amcy?=
 =?gb2312?B?QXFTUHdUWDVYNjJnVU51M1MrOEllWWJxSlhsOTRrSnZraGxqTEIwSnJEckp2?=
 =?gb2312?B?YjBFbzFLd3FleE14T3REUkU2K1JxMHRSU3lkc0M0S0lMQkVpWVZOeFRiOG45?=
 =?gb2312?B?bzJ3enRPK1k5cmd4WHFrS3JGZ1A4TmtOUXlCeGF5Nng0M1ErZy9nUFVzdEdk?=
 =?gb2312?B?N3paRzFaWXRrNHZqUGlhb25nTGFJK0hVc0dGVzRpbkJYK2NoVGdBUEpnRFYx?=
 =?gb2312?B?TXMveFB4cCsrRmtTQ1QxZW9oT2N6OUpsU3BxL2ZKL2hhZzJvTmV3c0M3Q1c4?=
 =?gb2312?Q?oXr7D7V8EKgMMcTbHYaF5zh2WL7diZ5gauAPbSH?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5017.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 419a680f-b048-4c1e-0ed6-08d937c9b9a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2021 11:09:39.0567
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DeAiEeyFZ0Yt9WS+0kbNyI+gEhPb2fdL5+G6GLi0N/X3g3WbmgjL9SK0PKGA4f0lrvdg/HsDyU0dti9Cmo9QQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6779
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUmljaGFyZCwNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBZLmIu
IEx1DQo+IFNlbnQ6IDIwMjHE6jbUwjIyyNUgMTg6MzUNCj4gVG86IFJpY2hhcmQgQ29jaHJhbiA8
cmljaGFyZGNvY2hyYW5AZ21haWwuY29tPg0KPiBDYzogbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsg
bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsNCj4gbGludXgta3NlbGZ0ZXN0QHZnZXIua2Vy
bmVsLm9yZzsgbXB0Y3BAbGlzdHMubGludXguZGV2OyBEYXZpZCBTIC4gTWlsbGVyDQo+IDxkYXZl
bUBkYXZlbWxvZnQubmV0PjsgSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz47IE1hdCBN
YXJ0aW5lYXUNCj4gPG1hdGhldy5qLm1hcnRpbmVhdUBsaW51eC5pbnRlbC5jb20+OyBNYXR0aGll
dSBCYWVydHMNCj4gPG1hdHRoaWV1LmJhZXJ0c0B0ZXNzYXJlcy5uZXQ+OyBTaHVhaCBLaGFuIDxz
aHVhaEBrZXJuZWwub3JnPjsgTWljaGFsDQo+IEt1YmVjZWsgPG1rdWJlY2VrQHN1c2UuY3o+OyBG
bG9yaWFuIEZhaW5lbGxpIDxmLmZhaW5lbGxpQGdtYWlsLmNvbT47DQo+IEFuZHJldyBMdW5uIDxh
bmRyZXdAbHVubi5jaD47IFJ1aSBTb3VzYSA8cnVpLnNvdXNhQG54cC5jb20+OyBTZWJhc3RpZW4N
Cj4gTGF2ZXplIDxzZWJhc3RpZW4ubGF2ZXplQG54cC5jb20+DQo+IFN1YmplY3Q6IFJFOiBbbmV0
LW5leHQsIHYzLCAwMi8xMF0gcHRwOiBzdXBwb3J0IHB0cCBwaHlzaWNhbC92aXJ0dWFsIGNsb2Nr
cw0KPiBjb252ZXJzaW9uDQo+IA0KPiBIaSBSaWNoYXJkLA0KPiANCj4gPiAtLS0tLU9yaWdpbmFs
IE1lc3NhZ2UtLS0tLQ0KPiA+IEZyb206IFJpY2hhcmQgQ29jaHJhbiA8cmljaGFyZGNvY2hyYW5A
Z21haWwuY29tPg0KPiA+IFNlbnQ6IDIwMjHE6jbUwjE4yNUgMjoyOA0KPiA+IFRvOiBZLmIuIEx1
IDx5YW5nYm8ubHVAbnhwLmNvbT4NCj4gPiBDYzogbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGlu
dXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsNCj4gPiBsaW51eC1rc2VsZnRlc3RAdmdlci5rZXJu
ZWwub3JnOyBtcHRjcEBsaXN0cy5saW51eC5kZXY7IERhdmlkIFMgLg0KPiA+IE1pbGxlciA8ZGF2
ZW1AZGF2ZW1sb2Z0Lm5ldD47IEpha3ViIEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+OyBNYXQN
Cj4gPiBNYXJ0aW5lYXUgPG1hdGhldy5qLm1hcnRpbmVhdUBsaW51eC5pbnRlbC5jb20+OyBNYXR0
aGlldSBCYWVydHMNCj4gPiA8bWF0dGhpZXUuYmFlcnRzQHRlc3NhcmVzLm5ldD47IFNodWFoIEto
YW4gPHNodWFoQGtlcm5lbC5vcmc+OyBNaWNoYWwNCj4gPiBLdWJlY2VrIDxta3ViZWNla0BzdXNl
LmN6PjsgRmxvcmlhbiBGYWluZWxsaSA8Zi5mYWluZWxsaUBnbWFpbC5jb20+Ow0KPiA+IEFuZHJl
dyBMdW5uIDxhbmRyZXdAbHVubi5jaD47IFJ1aSBTb3VzYSA8cnVpLnNvdXNhQG54cC5jb20+Ow0K
PiBTZWJhc3RpZW4NCj4gPiBMYXZlemUgPHNlYmFzdGllbi5sYXZlemVAbnhwLmNvbT4NCj4gPiBT
dWJqZWN0OiBSZTogW25ldC1uZXh0LCB2MywgMDIvMTBdIHB0cDogc3VwcG9ydCBwdHAgcGh5c2lj
YWwvdmlydHVhbA0KPiA+IGNsb2NrcyBjb252ZXJzaW9uDQo+ID4NCj4gPiBPbiBUdWUsIEp1biAx
NSwgMjAyMSBhdCAwNTo0NTowOVBNICswODAwLCBZYW5nYm8gTHUgd3JvdGU6DQo+ID4NCj4gPiA+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL3B0cC9wdHBfcHJpdmF0ZS5oIGIvZHJpdmVycy9wdHAvcHRw
X3ByaXZhdGUuaA0KPiA+ID4gaW5kZXggM2YzODhkNjM5MDRjLi42OTQ5YWZjOWQ3MzMgMTAwNjQ0
DQo+ID4gPiAtLS0gYS9kcml2ZXJzL3B0cC9wdHBfcHJpdmF0ZS5oDQo+ID4gPiArKysgYi9kcml2
ZXJzL3B0cC9wdHBfcHJpdmF0ZS5oDQo+ID4gPiBAQCAtNDYsNiArNDYsOSBAQCBzdHJ1Y3QgcHRw
X2Nsb2NrIHsNCj4gPiA+ICAJY29uc3Qgc3RydWN0IGF0dHJpYnV0ZV9ncm91cCAqcGluX2F0dHJf
Z3JvdXBzWzJdOw0KPiA+ID4gIAlzdHJ1Y3Qga3RocmVhZF93b3JrZXIgKmt3b3JrZXI7DQo+ID4g
PiAgCXN0cnVjdCBrdGhyZWFkX2RlbGF5ZWRfd29yayBhdXhfd29yazsNCj4gPiA+ICsJdTggbl92
Y2xvY2tzOw0KPiA+DQo+ID4gSG0sIHR5cGUgaXMgdTgsIGJ1dCAuLi4NCj4gPg0KPiA+ID4gKwlz
dHJ1Y3QgbXV0ZXggbl92Y2xvY2tzX211eDsgLyogcHJvdGVjdCBjb25jdXJyZW50IG5fdmNsb2Nr
cyBhY2Nlc3MgKi8NCj4gPiA+ICsJYm9vbCB2Y2xvY2tfZmxhZzsNCj4gPiA+ICB9Ow0KPiA+ID4N
Cj4gPg0KPiA+ID4gICNkZWZpbmUgaW5mb190b192Y2xvY2soZCkgY29udGFpbmVyX29mKChkKSwg
c3RydWN0IHB0cF92Y2xvY2ssDQo+ID4gPiBpbmZvKSBkaWZmIC0tZ2l0IGEvaW5jbHVkZS91YXBp
L2xpbnV4L3B0cF9jbG9jay5oDQo+ID4gPiBiL2luY2x1ZGUvdWFwaS9saW51eC9wdHBfY2xvY2su
aCBpbmRleCAxZDEwOGQ1OTdmNjYuLjRiOTMzZGMxYjgxYg0KPiA+ID4gMTAwNjQ0DQo+ID4gPiAt
LS0gYS9pbmNsdWRlL3VhcGkvbGludXgvcHRwX2Nsb2NrLmgNCj4gPiA+ICsrKyBiL2luY2x1ZGUv
dWFwaS9saW51eC9wdHBfY2xvY2suaA0KPiA+ID4gQEAgLTY5LDYgKzY5LDExIEBADQo+ID4gPiAg
ICovDQo+ID4gPiAgI2RlZmluZSBQVFBfUEVST1VUX1YxX1ZBTElEX0ZMQUdTCSgwKQ0KPiA+ID4N
Cj4gPiA+ICsvKg0KPiA+ID4gKyAqIE1heCBudW1iZXIgb2YgUFRQIHZpcnR1YWwgY2xvY2tzIHBl
ciBQVFAgcGh5c2ljYWwgY2xvY2sgICovDQo+ID4gPiArI2RlZmluZSBQVFBfTUFYX1ZDTE9DS1MJ
CQkyMA0KPiA+DQo+ID4gT25seSAyMCBjbG9ja3MgYXJlIGFsbG93ZWQ/ICBXaHk/DQo+IA0KPiBJ
bml0aWFsbHkgSSB0aGluayB2Y2xvY2sgY2FuIGJlIHVzZWQgZm9yIHB0cCBtdWx0aXBsZSBkb21h
aW5zIHN5bmNocm9uaXphdGlvbi4NCj4gU2luY2UgdGhlIFBUUCBkb21haW5WYWx1ZSBpcyB1OCwg
dTggdmNsb2NrIG51bWJlciBpcyBsYXJnZSBlbm91Z2guDQo+IFRoaXMgaXMgbm90IGEgZ29vZCBp
ZGVhIHRvIGhhcmQtY29kZSBhIFBUUF9NQVhfVkNMT0NLUyB2YWx1ZS4gQnV0IGl0IGxvb2tzIGEN
Cj4gbGl0dGxlIGNyYXp5IHRvIGNyZWF0ZSBudW1iZXJzIG9mIHZjbG9ja3MgdmlhIG9uZSBjb21t
YW5kIChlY2hvIG4gPg0KPiAvc3lzL2NsYXNzL3B0cC9wdHAwL25fdmNsb2NrcykuDQo+IE1heWJl
IGEgdHlwbyBjcmVhdGVzIGh1bmRyZWRzIG9mIHZjbG9ja3Mgd2UgZG9uoa90IG5lZWQuDQo+IERv
IHlvdSB0aGluayB3ZSBzaG91bGQgYmUgY2FyZSBhYm91dCBzZXR0aW5nIGEgbGltaXRhdGlvbiBv
ZiB2Y2xvY2sgbnVtYmVyPw0KPiBBbnkgc3VnZ2VzdGlvbiBmb3IgaW1wbGVtZW50YXRpb24/DQo+
IFRoYW5rcy4NCg0KSSBzZW50IHY0LiBJIHJlbW92ZWQgdGhlIHU4IGxpbWl0YXRpb24gZm9yIHZj
bG9ja3MgbnVtYmVyLCB1c2luZyB1bnNpZ25lZCBpbnQgaW5zdGVhZC4NCkkgaW50cm9kdWNlZCBt
YXhfdmNsb2NrcyBhdHRyaWJ1dGUgd2hpY2ggY291bGQgYmUgcmUtY29uZmlndXJlZC4NClBsZWFz
ZSBoZWxwIHRvIHJldmlldy4NClRoYW5rcy4NCg0KPiANCj4gPg0KPiA+IFRoYW5rcywNCj4gPiBS
aWNoYXJkDQo=
