Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCA01C8032
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 04:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728388AbgEGCxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 22:53:03 -0400
Received: from mail-db8eur05on2086.outbound.protection.outlook.com ([40.107.20.86]:12165
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725827AbgEGCxB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 22:53:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ACpXuDHxLDKSYdhjAz2iKlASzh3zrk5gLNfG8c26dQKlYavD/SZsJdS1yf4D2Ds8dl/9lsg0jsLUUwpziFMN6UdXxpmZWqYJSTjiMoVPNaT5EhsdMDI6k4qQY6eDfnnvbW9mW+l7CYPs4TwnyjD1lft53wmMW/YJ30U5EderI4JP/kaLRSSELxoAt6RAKRfWWz1+499auMPjJNeWx/GNbRnvG0YYQ6iscrp7+bLBvUarT3amOV6Eqtjv0lwZYrXba7rtYMZwkzOr3rrID29nJJB+xFIcXdioIzWrheIuyqM2sZACGJpk8TsBeBI7L5VBB+IuDWA62EJUdAzI7k0paw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BeH+x+d1OI91WnjW+uFClHA1gAB4zH8lqjlkhfEF5b8=;
 b=V2MjcSAIr98jsPtnFRiCo0PbefgxwZExfLoFdTtId9YJR4h75uaZ6yZ1tyZ35PdEVAaLUz6WxZ11jw5s9I13Z8XZOBPyA0GDR7ELRNzeSNrzkT+ejUYnkJWqkhvrPn4eb3W9fqoOxaZIZ0dDB7ZW/qbMDdv+Gw1SEV0/7oYrGmYhzkkYl31TLl4Jw6N+n5JEbIOVH3tmcjZWZWGwyamXbqkjWW1Bd9mNP3FXJTrza/kxKo9keakUIpBUE+ZV7AIKTt7ProLeukAkiFJzn/eeKVZi2P3iwSJRaf6HEksziwI4FjW7VEOYjH+DuShNdiguBJ71HwnOhsfuD+CHCP+7/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BeH+x+d1OI91WnjW+uFClHA1gAB4zH8lqjlkhfEF5b8=;
 b=XN7mNqB381bF3uDyvoN95fjm09Ijq2lvwSQTQ70ZPFW0oKQEZeKEh6GyioAiP3MTBaWCqnSJvttz3uJHkK2ip5fDffydBjkRVkaDrE1DxeuECH0ZN3DHo1tiMGFyIM6bt3dXi3GZ9A0zcJUTxV2c8bGaLWNuGbdg/a5xWsHcu5o=
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VE1PR04MB6445.eurprd04.prod.outlook.com (2603:10a6:803:11c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28; Thu, 7 May
 2020 02:52:56 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173%7]) with mapi id 15.20.2958.030; Thu, 7 May 2020
 02:52:56 +0000
From:   Po Liu <po.liu@nxp.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     "dsahern@gmail.com" <dsahern@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "vlad@buslov.dev" <vlad@buslov.dev>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>
Subject: RE: Re: [v4,iproute2-next 1/2] iproute2-next:tc:action: add a gate
 control action
Thread-Topic: Re: [v4,iproute2-next 1/2] iproute2-next:tc:action: add a gate
 control action
Thread-Index: AdYkGP/813CTQ3HyQZuckXvjuAsisQ==
Date:   Thu, 7 May 2020 02:52:56 +0000
Message-ID: <VE1PR04MB64969AC550AE3A762DADEF5292A50@VE1PR04MB6496.eurprd04.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 595e83a7-e875-48af-ed63-08d7f231bf01
x-ms-traffictypediagnostic: VE1PR04MB6445:|VE1PR04MB6445:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB64451DE3AB5DAE9F5B15FE5E92A50@VE1PR04MB6445.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 03965EFC76
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wElIhp+yCNxD0uZZwaqoFAm977uM45pPFNn7MBgqWU4CxffQmznWI5kRLXpIP85YoPQ5bF1jCLPsRZGZ31z+2TyPH7leFIQ4zJ0jWkVdEPgq2TtHowaE0bGidQgFj0mCz6VJAiE6BPuOWtgxxNp+LZfkJHaQm1qozW8Mmbu9sc3aRatJ/so2hwXKmYOMNUTTLmps5YwwI9Xg8hN/CYcNnsGTqhg06NMknWMVN9/8aR7Iia+5cdckocf56hZbiejqCS4wrIqzZ/2vIwO9oH7+KpHyogl32v+sFNjfKZervy6kJMKMu4EL8/R1MdZoxYno5ABGUJ97bv7YOF5eaYEsADfqaVw4c0nYvNYXKRr4ZOPnPvV500gEOrq0qv/KxGMEAy8P52+gwJFG+ePzWhiz2IRyVZpnSLjeoWWfz3hyE+gthC1CUUZgQw+3aCmb4p0ljCwIW0SVk2FuIqAaz+psFbZR5+lgRdL/0K8wG2vbueQHrVurLMWeArJHoUR8yWo/8bKxSxwqVibdhiw2od/gFQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(136003)(366004)(39860400002)(376002)(33430700001)(71200400001)(4326008)(478600001)(66446008)(5660300002)(9686003)(33440700001)(83300400001)(83290400001)(83280400001)(83320400001)(83310400001)(8676002)(66556008)(66476007)(316002)(54906003)(66946007)(55016002)(64756008)(186003)(44832011)(76116006)(8936002)(86362001)(33656002)(6916009)(52536014)(6506007)(2906002)(53546011)(26005)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 1Osem7V5aZBFYj2SrIHT0Fhqv9Lu0Qa5NfEUR+GAAJua0WnqDBclblBXY7rvvmE50fQTolu77eiatdVuxJL9VniyeXULg0Ua40M9Gi1nohLfB5Z97Ql/ejJb7owZg0jVqawul5lW3orFbE3uDqsSauUGQgj1hvVl2bG04hnAO2M6EIaNHCLfdb/ALA3GbDlTUk67t+GB3fPZI+J5Mlu/22mTyPk0dgOq4zZwyxdDEBSthwgcjLI2aoXx0unqDzCvAjgVK43Maw+pouJDBn2aceGz28i36GH4ycGyn+BToRuitaWuSIp2KeSma5VhrEHg4dfBr5tITeYjMz1jHgR+csREoYWb3E8mi+5NT5YdDn+4jn0ZG+0/jjs5midRrKmR55cuqcsyCi/TXfHbg/dYAt1VbfEENSud4YVHZ2j9A5JPy7rOCOqep4tjX+yfNSKJVjHi2XCK24DN/t/XXF7CL6EdQQibZ4Tt6IBHUamVZYmSLPLqHgHdabAKH1BbaGhBJ7Kv5xsGPD9n9Nl7VD/Ax6MLtqlkJ/3Dw7jqbnq0p1az1YUaGodza/szJ8RiXjA/XeW2deaV7Y4xpIVD9E50VG2sRUQPCVnhiTaggZxIId8NPjudwiktsPJWR19vD+Ial7T+qQRaH9WDjDYevfU3W+Upn6ay+AQx3yhHuPmYigwHHMvl9W5OX6FwPu5Z/7jrdb6qNJh3uzKmUdPrRuRO806z9PJioJQWDnIILKUyxzO0zvcLiUWziO/ZLylNKPDL+WJB2BCm7B7GGeRWSYvM7tHHii0ZnJKcl/ievhO+qXM=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 595e83a7-e875-48af-ed63-08d7f231bf01
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2020 02:52:56.7069
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JCUs7m8AVQsSAHyuBT8UIlqUSs9MSBU7O9Em8Yhw/2Ex1FYG5pvRT8IyBcwfmMX7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6445
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU3RlcGhlbiwNCg0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFN0
ZXBoZW4gSGVtbWluZ2VyIDxzdGVwaGVuQG5ldHdvcmtwbHVtYmVyLm9yZz4NCj4gU2VudDogMjAy
MMTqNdTCNsjVIDIzOjIyDQo+IFRvOiBQbyBMaXUgPHBvLmxpdUBueHAuY29tPg0KPiBDYzogZHNh
aGVybkBnbWFpbC5jb207IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7DQo+IG5ldGRldkB2
Z2VyLmtlcm5lbC5vcmc7IHZpbmljaXVzLmdvbWVzQGludGVsLmNvbTsNCj4gZGF2ZW1AZGF2ZW1s
b2Z0Lm5ldDsgdmxhZEBidXNsb3YuZGV2OyBDbGF1ZGl1IE1hbm9pbA0KPiA8Y2xhdWRpdS5tYW5v
aWxAbnhwLmNvbT47IFZsYWRpbWlyIE9sdGVhbiA8dmxhZGltaXIub2x0ZWFuQG54cC5jb20+Ow0K
PiBBbGV4YW5kcnUgTWFyZ2luZWFuIDxhbGV4YW5kcnUubWFyZ2luZWFuQG54cC5jb20+DQo+IFN1
YmplY3Q6IFJlOiBbdjQsaXByb3V0ZTItbmV4dCAxLzJdIGlwcm91dGUyLW5leHQ6dGM6YWN0aW9u
OiBhZGQgYQ0KPiBnYXRlIGNvbnRyb2wgYWN0aW9uDQo+IE9uIFdlZCwgIDYgTWF5IDIwMjAgMTY6
NDA6MTkgKzA4MDANCj4gUG8gTGl1IDxQby5MaXVAbnhwLmNvbT4gd3JvdGU6DQo+IA0KPiA+ICAg
ICAgICAgICAgICAgfSBlbHNlIGlmIChtYXRjaGVzKCphcmd2LCAiYmFzZS10aW1lIikgPT0gMCkg
ew0KPiA+ICsgICAgICAgICAgICAgICAgICAgICBORVhUX0FSRygpOw0KPiA+ICsgICAgICAgICAg
ICAgICAgICAgICBpZiAoZ2V0X3U2NCgmYmFzZV90aW1lLCAqYXJndiwgMTApKSB7DQo+ID4gKyAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgaW52YWxpZGFyZyA9ICJiYXNlLXRpbWUiOw0KPiA+
ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGdvdG8gZXJyX2FyZzsNCj4gPiArICAgICAg
ICAgICAgICAgICAgICAgfQ0KPiA+ICsgICAgICAgICAgICAgfSBlbHNlIGlmIChtYXRjaGVzKCph
cmd2LCAiY3ljbGUtdGltZSIpID09IDApIHsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgTkVY
VF9BUkcoKTsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgaWYgKGdldF91NjQoJmN5Y2xlX3Rp
bWUsICphcmd2LCAxMCkpIHsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICBpbnZh
bGlkYXJnID0gImN5Y2xlLXRpbWUiOw0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IGdvdG8gZXJyX2FyZzsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgfQ0KPiA+ICsgICAgICAg
ICAgICAgfSBlbHNlIGlmIChtYXRjaGVzKCphcmd2LCAiY3ljbGUtdGltZS1leHQiKSA9PSAwKSB7
DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgIE5FWFRfQVJHKCk7DQo+ID4gKyAgICAgICAgICAg
ICAgICAgICAgIGlmIChnZXRfdTY0KCZjeWNsZV90aW1lX2V4dCwgKmFyZ3YsIDEwKSkgew0KPiA+
ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGludmFsaWRhcmcgPSAiY3ljbGUtdGltZS1l
eHQiOw0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGdvdG8gZXJyX2FyZzsNCj4g
PiArICAgICAgICAgICAgICAgICAgICAgfQ0KPiANCj4gQ291bGQgYWxsIHRoZXNlIHRpbWUgdmFs
dWVzIHVzZSBleGlzdGluZyBUQyBoZWxwZXIgcm91dGluZXM/DQoNCkkgYWdyZWUgdG8ga2VlcCB0
aGUgdGMgcm91dGluZXMgaW5wdXQuDQpUaGUgbmFtZXMgb2YgdGltZXIgaW5wdXQgYW5kIHR5cGUg
aXMgbW9yZSByZWZlcmVuY2UgdGhlIHRhcHJpbyBpbnB1dC4NCg0KPiBTZWUgZ2V0X3RpbWUoKS4g
IFRoZSB3YXkgeW91IGhhdmUgaXQgbWFrZXMgc2Vuc2UgZm9yIGhhcmR3YXJlIGJ1dCBzdGFuZHMN
Cj4gb3V0IHZlcnN1cyB0aGUgcmVzdCBvZiB0Yy4NCj4gDQo+IEl0IG1heWJlIHRoYXQgdGhlIGtl
cm5lbCBVQVBJIGlzIHdyb25nLCBhbmQgc2hvdWxkIGJlIHVzaW5nIHNhbWUgdGltZQ0KPiB1bml0
cyBhcyByZXN0IG9mIHRjLiBGb3Jnb3QgdG8gcmV2aWV3IHRoYXQgcGFydCBvZiB0aGUgcGF0Y2gu
DQoNCkkgd291bGQgYWxzbyBzeW5jIHdpdGgga2VybmVsIFVBUEkgaWYgbmVlZGVkLg0KDQoNCkJy
LA0KUG8gTGl1DQo=
