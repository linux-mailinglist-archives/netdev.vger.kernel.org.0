Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5620D28DC0C
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 10:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730103AbgJNIxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 04:53:24 -0400
Received: from mail-eopbgr10054.outbound.protection.outlook.com ([40.107.1.54]:42166
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725934AbgJNIxY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 04:53:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iE49E4wNL09LNe1y/H/cpLlvHnfm/4yHBrTuSbEqUZxkw9orM54QKUFLSmVMsJLuQasrBVcGPr+NikDXR/I8GVdS4Gwqe7Air8nurfHk2tDgSPnIMfzRgWmGuob+HkOvgjmpDzx/ObzBkSSn+MglY0n15sEHUdeq6/QBexq0FzZaIMQc095SQFSNRHuT507YTbukKoLsWvpddLsgRfuhs/670TgALblY8lH9xVmelKhx2rOLxaCBvJJMcN7TDqqh8/ZHGczgMEXj80Xl/2a8KuJGRPOC9l9HzY1QRvWKWdWpTWRMLX2v9tXRR5ri78v9GP6SIVhz3TNtBSfGtKYq8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MqxsqqllmWE1QN5cVEUGxuw9CBgVH6RrP9W/lfZXeSk=;
 b=EOP9Ms2T/pRhqEp8doPShiD2wsW+Ci2SLa1FA+jXiIUpP3FU/2nQElluAAnTmVm0QrwgQ6alxYiOeryaA8VEUXdncWtdH9CorME5SYbkuCoc4YXcZPrg1w0ZJUDZZZSZzpam6LVKag09J2zb1BFjxSe/HYnzz6nw/9t8nsIYtN8pDFLwkJQjwT1awg4wLQVKpLpWuBb+0+u60eeC13q7pXIPDTvtenGYf2hrxILHcg+81ayUR4+Gx3YSOb3ZfQMAzJbTJJBGKSmZR9l5VUYarzhhfMVYS6l1crtlo0reKM+tuUCU9lZGEf2L5ODHnSUSdlmM0VuEtoZZhKJTJdLqSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MqxsqqllmWE1QN5cVEUGxuw9CBgVH6RrP9W/lfZXeSk=;
 b=Z4alp+qS3fF8l/xF6FHwzy59sTZXhSLPbP+fDGsYzwVVlnWhAu6yoN6DSzdzEYiznKBR9qO7R6hRE+pCEB5g9Pf9T9z0sX4kMsiyUlp5Sl930SXX6tekT3f5ao4XxNpKm26rAM2kySoFh4LTAK9ZoYuszIjQmO6iVOUymK8WFv8=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB3961.eurprd04.prod.outlook.com (2603:10a6:5:25::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21; Wed, 14 Oct
 2020 08:53:20 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%9]) with mapi id 15.20.3477.021; Wed, 14 Oct 2020
 08:53:20 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: RE: [PATCH 14/17] can: flexcan: remove ack_grp and ack_bit handling
 from driver
Thread-Topic: [PATCH 14/17] can: flexcan: remove ack_grp and ack_bit handling
 from driver
Thread-Index: AQHWnPFYsfBcQexeJUe7ttPv0w1AlamW0gaQ
Date:   Wed, 14 Oct 2020 08:53:20 +0000
Message-ID: <DB8PR04MB6795CE6F83E1C25F8A04633FE6050@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20201007213159.1959308-1-mkl@pengutronix.de>
 <20201007213159.1959308-15-mkl@pengutronix.de>
In-Reply-To: <20201007213159.1959308-15-mkl@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 58f012d5-feb0-419d-d299-08d8701e99d9
x-ms-traffictypediagnostic: DB7PR04MB3961:
x-microsoft-antispam-prvs: <DB7PR04MB396138C7AF2FEA925B7E9451E6050@DB7PR04MB3961.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:499;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ggu8ljUgHKRUX7PtrxfzEZ7mY/ovvjqiKvBhMzITZyGybibVtbTUcWnRkUV3iejci2gZ9VE9ByyLvA/4hkh7hfPQMN+MfpU+5zv3BGlGtpX3ba2WdGdRAK5wtjLp4u6LpMpJzVqezwZzOlEHCy8TTylaYzyp+e0RMBnRXs3qwa6nOvbK87vka+tYrM0UJLWBSNxoVFkZYUM53Dq1SUTpT2/cBLFY59wTKMNMieW4A6ITHP9gv/KKHQyIqIhpyBtE6/+2E1SWa3hrjzfJ9DgXSll9nLxAliNupMzDj9Ja7ht7liPTj7TYfPS+UlXkJddRs8/SIny5LrPCwElAk7C67v0YeD8/a4RJSrizD/I7UE0S6Qmo0k5WeMhenHPhdrTAmJVmmP+LPwTdLIhHuteA1A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(396003)(366004)(376002)(9686003)(478600001)(83380400001)(316002)(76116006)(64756008)(66946007)(66476007)(66556008)(5660300002)(66446008)(45080400002)(33656002)(966005)(54906003)(52536014)(8676002)(86362001)(110136005)(4326008)(2906002)(83080400001)(7696005)(55016002)(26005)(71200400001)(6506007)(53546011)(8936002)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Npy0vTOAc9VZybFZAPaEgxBWOfwIGLK6oHAONltJpwaae7VeKmXZvTNKJN26ljrEi5ZnEMYv3Xpywz6h3+GNh655/Bl5Gzdbk0MJ9CSsqj6oz52wvZHBNHysGYmmuXW+94CddtDKOZqM/0lYjW0e8gEigA/s0Bi56/C0X3SApNitYEPCUSQsxMHv5o++iNScL8+05BDOLyp1v6D3KHBGId2nhkd6DfS8oreW2BRK+Yn0BK7A7uNt3E0S1TNYY5AmEhfwIOFz53YXXntxWaIqAOkBL9whYHwnuhJP/7tpT0B2pNjdF2ug9+DZWEe2sWFmajgSTWMnlQqxh/x5b/Db40YSMWQjlrjIeGZL/ukfOjXLZ/YnVMDgiFerMhFHNtbE/TnGljdaummpkJtGnN8fRNxVraF8ppw/Tqn8PWz3TGgT17yCLMgh1J8Q4g5636vdw0Ub4aPp/PpEx9KabPZyUMy7cCZEWj6v83HV4lOqxKwMqIn/M2EriNyZfWdHag3Cni7ucJIvTtSJg80W7fbzUZUewvxuL0SERqC+ZE8MDFdw7ekXFzqKBttv2sogoH/C7ufLjKCxSgpyXtuvpqcS+9vQGk+4puuIfMTCVeEOQptIsUlpQ5fX2dl1C3IY12CKEJWb84it5x87kYGKh06J5w==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58f012d5-feb0-419d-d299-08d8701e99d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2020 08:53:20.4757
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q/0DgjG196mH0tf9Zvpw16lwjz8ux/VDJnyJerIVxOWqAwLEhvUMX5iYapfUW7nLFBJGSWfNGbafhXvGz6ft5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB3961
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE1hcmMgS2xlaW5lLUJ1ZGRl
IDxta2xAcGVuZ3V0cm9uaXguZGU+DQo+IFNlbnQ6IDIwMjDE6jEw1MI4yNUgNTozMg0KPiBUbzog
bmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KPiBDYzogZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgbGludXgt
Y2FuQHZnZXIua2VybmVsLm9yZzsNCj4ga2VybmVsQHBlbmd1dHJvbml4LmRlOyBNYXJjIEtsZWlu
ZS1CdWRkZSA8bWtsQHBlbmd1dHJvbml4LmRlPjsgSm9ha2ltDQo+IFpoYW5nIDxxaWFuZ3Fpbmcu
emhhbmdAbnhwLmNvbT4NCj4gU3ViamVjdDogW1BBVENIIDE0LzE3XSBjYW46IGZsZXhjYW46IHJl
bW92ZSBhY2tfZ3JwIGFuZCBhY2tfYml0IGhhbmRsaW5nIGZyb20NCj4gZHJpdmVyDQo+IA0KPiBT
aW5jZSBjb21taXQ6DQo+IA0KPiAgICAgMDQ4ZTNhMzRhMmU3IGNhbjogZmxleGNhbjogcG9sbCBN
Q1JfTFBNX0FDSyBpbnN0ZWFkIG9mIEdQUiBBQ0sgZm9yDQo+IHN0b3AgbW9kZSBhY2tub3dsZWRn
bWVudA0KPiANCj4gdGhlIGRyaXZlciBwb2xscyB0aGUgSVAgY29yZSdzIGludGVybmFsIGJpdCBN
Q1JbTFBNX0FDS10gYXMgc3RvcCBtb2RlDQo+IGFja25vd2xlZGdlIGFuZCBub3QgdGhlIGFja25v
d2xlZGdtZW50IG9uIGNoaXAgbGV2ZWwuDQo+IA0KPiBUaGlzIG1lYW5zIHRoZSA0dGggYW5kIDV0
aCB2YWx1ZSBvZiB0aGUgcHJvcGVydHkgImZzbCxzdG9wLW1vZGUiIGlzbid0IHVzZWQNCj4gYW55
bW9yZS4gVGhpcyBwYXRjaCByZW1vdmVzIHRoZSB1c2VkICJhY2tfZ3ByIiBhbmQgImFja19iaXQi
IGZyb20gdGhlDQo+IGRyaXZlci4NCj4gDQo+IExpbms6DQo+IGh0dHBzOi8vZXVyMDEuc2FmZWxp
bmtzLnByb3RlY3Rpb24ub3V0bG9vay5jb20vP3VybD1odHRwJTNBJTJGJTJGbG9yZS5rZXJuDQo+
IGVsLm9yZyUyRnIlMkYyMDIwMTAwNjIwMzc0OC4xNzUwMTU2LTE1LW1rbCU0MHBlbmd1dHJvbml4
LmRlJmFtcDtkYXQNCj4gYT0wMiU3QzAxJTdDcWlhbmdxaW5nLnpoYW5nJTQwbnhwLmNvbSU3QzE1
NDBhZDViZjdiZDRhMWUxMGE1MDhkOA0KPiA2YjA4N2E2NyU3QzY4NmVhMWQzYmMyYjRjNmZhOTJj
ZDk5YzVjMzAxNjM1JTdDMCU3QzAlN0M2MzczNzcwMzENCj4gNDM2Nzg1Nzg3JmFtcDtzZGF0YT1p
ZXJJSVZkU3FaRkxrbEl2Z01va0hYNkxVNzdjRVdRZ1VHelVpNkNIZERJJQ0KPiAzRCZhbXA7cmVz
ZXJ2ZWQ9MA0KPiBGaXhlczogMDQ4ZTNhMzRhMmU3ICgiY2FuOiBmbGV4Y2FuOiBwb2xsIE1DUl9M
UE1fQUNLIGluc3RlYWQgb2YgR1BSIEFDSw0KPiBmb3Igc3RvcCBtb2RlIGFja25vd2xlZGdtZW50
IikNCj4gQ2M6IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+DQo+IFNpZ25l
ZC1vZmYtYnk6IE1hcmMgS2xlaW5lLUJ1ZGRlIDxta2xAcGVuZ3V0cm9uaXguZGU+DQoNClsuLi5d
DQo+ICAJLyogc3RvcCBtb2RlIHByb3BlcnR5IGZvcm1hdCBpczoNCj4gLQkgKiA8JmdwciByZXFf
Z3ByIHJlcV9iaXQgYWNrX2dwciBhY2tfYml0Pi4NCj4gKwkgKiA8JmdwciByZXFfZ3ByPi4NCg0K
SGkgTWFyYywNCg0KU29ycnkgZm9yIHJlc3BvbnNlIGRlbGF5LCBzdG9wIG1vZGUgcHJvcGVydHkg
Zm9ybWF0IHNob3VsZCBiZSAiPCZncHIgcmVxX2dwciByZXFfYml0PiIsIEkgc2F3IHRoaXMgY29k
ZSBjaGFuZ2UgaGFzIHdlbnQgaW50byBsaW51eC1uZXh0LCBzbyBJIHdpbGwgY29ycmVjdCBpdCBi
eSB0aGUgd2F5IG5leHQgdGltZSB3aGVuIEkgdXBzdGVhbSB3YWtldXAgZnVuY3Rpb24gZm9yIGku
TVg4Lg0KDQpOZWVkIEkgdXBkYXRlIHN0b3AgbW9kZSBwcm9wZXJ0eSBpbiBkdHMgZmlsZT8gQWx0
aG91Z2ggdGhpcyBmdW5jdGlvbiB3b24ndCBiZSBicm9rZW4gd2l0aG91dCBkdHMgdXBkYXRlLg0K
DQpCZXN0IFJlZ2FyZHMsDQpKb2FraW0gWmhhbmcNCg==
