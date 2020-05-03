Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3A01C2A69
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 08:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbgECGpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 02:45:11 -0400
Received: from mail-eopbgr50087.outbound.protection.outlook.com ([40.107.5.87]:4981
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726973AbgECGpK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 May 2020 02:45:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bvXGNyHJEX6M9BQ8J66Emmdf7+uh7aErsWHOQQ38+tZSGSBgJfUbeSJP5NPr2oHwBQ8khZZWw+Lt1ZfFLgtA3u2ggUoIcq4F6mrS1UB5bOEQZPnUwMurGooHZwapgbQGic1eDGiKXnUcHKNK0bCHd+MyR2V/5IyslQQJ5A7fXbsKyaYVJdP4fUOjAYFaQqZ8+RsD6ylkzxPvJs9CyMRjgjljHpWocR59VWxEUBf5dNiNXUTewElNSkwfGge2H2M1I2yykAbAD7FFarUnfSi9dzD1QmnjiIDReHo19c45ZqNcEH32V1M9Yzb0XFv9VUiXoVKAldRTd1doP5h6kYEsiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MKOPzK2DiP0shlOy07ssHAmlNm/smfEd82M0hZPqlQU=;
 b=bsfM8t5zntrxMBY5k5VcVjHW+ABDVTVNcm/5iy5sby5dcGVlL9S/FYyvUzHEnZTewxz4zDy5L10ZDGh6upOb8/g0emmnuSQYvjXOMcDPcQhk4vUfST5RoBQrFzhI0LYcyv7InK0OYXIX9yiuHormgZm78GSQwY2xKPVQs61vnlqxso8NK3b9OajP4uw3X8cDRbK+FsqZHnfuSSpiZC3khQ4LkUqJcZS63NHTovA3zzUYvxHbvB4ArkNwZ4DvK13cbmoO6jC+9ttx3VdtAysJMfINvxPA5xOcVqZZhlua0u59NBC6RGL9BQwj4ehu/SyA5NRSfT9MNIHhOb/wTop6XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MKOPzK2DiP0shlOy07ssHAmlNm/smfEd82M0hZPqlQU=;
 b=RefmbVx/wJoggfS9eo7x2omhl4iv8zau/K3OqqxuUam2wO0BK7L4xmlQo0CnUWGakpgqE2Gbzx9mSwiaIDYt3lS7c0JVF6f4IoOzbXTzL4SPCEhN8D4dktWRwaNtOYJREN87rZ0xgzp1l4R0Rn/ysZeWQ80uH65Kve/H1ayOZUA=
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VE1PR04MB6733.eurprd04.prod.outlook.com (2603:10a6:803:11e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.21; Sun, 3 May
 2020 06:45:07 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173%7]) with mapi id 15.20.2958.029; Sun, 3 May 2020
 06:45:07 +0000
From:   Po Liu <po.liu@nxp.com>
To:     David Miller <davem@davemloft.net>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "vlad@buslov.dev" <vlad@buslov.dev>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "moshe@mellanox.com" <moshe@mellanox.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "andre.guedes@linux.intel.com" <andre.guedes@linux.intel.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>
Subject: RE:  Re: [v5,net-next 0/4] Introduce a flow gate control action and
 apply IEEE
Thread-Topic: Re: [v5,net-next 0/4] Introduce a flow gate control action and
 apply IEEE
Thread-Index: AdYhFZfmrpiMXeJyR2Wk03WkB1UxgA==
Date:   Sun, 3 May 2020 06:45:06 +0000
Message-ID: <VE1PR04MB649616D9EF624DE8E5B562B592A90@VE1PR04MB6496.eurprd04.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [221.221.94.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1e783f52-7f66-4cc5-8130-08d7ef2d847f
x-ms-traffictypediagnostic: VE1PR04MB6733:|VE1PR04MB6733:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB673303C44B6C47F5E91FBC8192A90@VE1PR04MB6733.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0392679D18
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U0alGug3PAIpvoFoQLFLnK5Z3Ycucb2B6wh8npKPjcqZjOb7+RUym2K6NGYWtyR4T4gvHXRl5LJ7BrD5VIpk3jHSl87AVHN+aOMTHzV5ixDt7EMjNfv8xi1ZlKRZdnTjiUBiswZQ080CPrPsqCnFQob2P3Q052JQKXbrgxijjn5hCU9tQBQ6EQ4/wixdnRA6OuidKMTaaL8vrwINCCaPSxb5EblaKH5bqgboxwNObzK/pA7mzS9cVCI293qP4IWhBznuB3Fs3gcLGqaNOrLS3svAG5/rzKQJObtp3ibWuMk8fvivrbVIKpsUnkxYlvHYlTBXtbfXXpn1fttLo4iJ2McuBjzhFbSQV8Kqg6/zj4qYKAohaJ9MvcYP0POpASG2VQ0j8P7ikun2VJmAOEtfpBwdE8aioL6ER0qVkBBTSxtDu2swYloe3PVLADZTgPfG
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(136003)(346002)(396003)(39860400002)(53546011)(6506007)(52536014)(26005)(5660300002)(7416002)(186003)(4326008)(55016002)(8676002)(478600001)(6916009)(9686003)(44832011)(71200400001)(2906002)(8936002)(33656002)(76116006)(54906003)(66446008)(66946007)(66556008)(86362001)(316002)(64756008)(7696005)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: igiSIqj024JxlMm8X6VkE4cAVwc5yB1VTwZ3FHV6FC90rb7YNG2azmTSgB2kIh5YvvE4VRowS3zn6mDpmf5L1BQvFNr3F9d4ef/D1IsLhug5XC5gwTY6zxatTWThkE1+ztFU3daaI6VRxy/XiI9FEuMJsoytQ3ihWmYwpk7kwrOB+0/WUAONc7g9rfzU2PUHVI5GBgFDaSHFUeT96UCJLeqXriuSyK0/wiepsw2uEBgvdrZfvvIfWux/c+Oj79Ls54zEkX869sm7oKPt4qtPzBafwRYqsZzgCaQ76EAsIvdrjtZ0Qp3uiMlfmxj+VY7TKOOM1rKWAE8HY4BIgphF9m7w0EkfRLPD0DKRBUbXmcopw7sFcba4jmOIKmterA5DnRZjsWlttb62L612mD90La6ipM4QDwA4lQDon8gA5M0Cy3Lbk/WOofAbUwUjMHcwUPOHsk3aypkuV0ezFaLzA6YqZkbJDoNL8xjtKZm+vRgUa7We6NJJDl2noTc6HwoTpNA47qpBUkt5w+VF3H1tsKe47vcwUXdtCD/i1fj2HmwccFMrz98F9BfSN0FjJ4NH2Gim4tFUPFL7v7+OGzunPhJYfkVzUXnkGG02fzKTGGMQ+b1OwzFfgvbUOe3WQ5XP7xydRcf5wyJ3aNEDJNOavwg42oWTdTCo7LBlYtFTzUus5lZN6Bsc9rV23mZx223ThtP7d7c25i/mm1QYyh1jn3gDRodca2xyTOw4/xPaJnjtFDVIWTFVnlJI6qPzFtFMF2+JRMA3AhdN2fsRCDA7PkW/cTmR1mJ4YwUH40Otd8k=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e783f52-7f66-4cc5-8130-08d7ef2d847f
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2020 06:45:07.1030
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h8XQcYfUHcudWosRSsZTwPZwbZ1SHGH6RsUr9BoBcN2AUK3SOHRMT63L/GLgd9QB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6733
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRGF2aWQsIFN0ZXBoZW4sDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJv
bTogRGF2aWQgTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KPiBTZW50OiAyMDIwxOo11MIy
yNUgNzowOQ0KPiBUbzogUG8gTGl1IDxwby5saXVAbnhwLmNvbT4NCj4gQ2M6IGxpbnV4LWtlcm5l
bEB2Z2VyLmtlcm5lbC5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7DQo+IHZpbmljaXVzLmdv
bWVzQGludGVsLmNvbTsgdmxhZEBidXNsb3YuZGV2OyBDbGF1ZGl1IE1hbm9pbA0KPiA8Y2xhdWRp
dS5tYW5vaWxAbnhwLmNvbT47IFZsYWRpbWlyIE9sdGVhbiA8dmxhZGltaXIub2x0ZWFuQG54cC5j
b20+Ow0KPiBBbGV4YW5kcnUgTWFyZ2luZWFuIDxhbGV4YW5kcnUubWFyZ2luZWFuQG54cC5jb20+
Ow0KPiBtaWNoYWVsLmNoYW5AYnJvYWRjb20uY29tOyB2aXNoYWxAY2hlbHNpby5jb207DQo+IHNh
ZWVkbUBtZWxsYW5veC5jb207IGxlb25Aa2VybmVsLm9yZzsgamlyaUBtZWxsYW5veC5jb207DQo+
IGlkb3NjaEBtZWxsYW5veC5jb207IGFsZXhhbmRyZS5iZWxsb25pQGJvb3RsaW4uY29tOw0KPiBV
TkdMaW51eERyaXZlckBtaWNyb2NoaXAuY29tOyBrdWJhQGtlcm5lbC5vcmc7IGpoc0Btb2phdGF0
dS5jb207DQo+IHhpeW91Lndhbmdjb25nQGdtYWlsLmNvbTsgc2ltb24uaG9ybWFuQG5ldHJvbm9t
ZS5jb207DQo+IHBhYmxvQG5ldGZpbHRlci5vcmc7IG1vc2hlQG1lbGxhbm94LmNvbTsgbS1rYXJp
Y2hlcmkyQHRpLmNvbTsNCj4gYW5kcmUuZ3VlZGVzQGxpbnV4LmludGVsLmNvbTsgc3RlcGhlbkBu
ZXR3b3JrcGx1bWJlci5vcmcNCj4gU3ViamVjdDogUmU6IFt2NSxuZXQtbmV4dCAwLzRdIEludHJv
ZHVjZSBhIGZsb3cgZ2F0ZSBjb250cm9sIGFjdGlvbg0KPiBhbmQgYXBwbHkgSUVFRQ0KPiANCj4g
RnJvbTogUG8gTGl1IDxQby5MaXVAbnhwLmNvbT4NCj4gRGF0ZTogRnJpLCAgMSBNYXkgMjAyMCAw
ODo1MzoxNCArMDgwMA0KPiANCj4gIC4uLg0KPiA+IFRoZXNlIHBhdGNoZXMgYWRkIHN0cmVhbSBn
YXRlIGFjdGlvbiBwb2xpY2luZyBpbiBJRUVFODAyLjFRY2kNCj4gPiAoUGVyLVN0cmVhbSBGaWx0
ZXJpbmcgYW5kIFBvbGljaW5nKSBzb2Z0d2FyZSBzdXBwb3J0IGFuZCBoYXJkd2FyZQ0KPiA+IG9m
ZmxvYWQgc3VwcG9ydCBpbiB0YyBmbG93ZXIsIGFuZCBpbXBsZW1lbnQgdGhlIHN0cmVhbSBpZGVu
dGlmeSwNCj4gPiBzdHJlYW0gZmlsdGVyaW5nIGFuZCBzdHJlYW0gZ2F0ZSBmaWx0ZXJpbmcgYWN0
aW9uIGluIHRoZSBOWFAgRU5FVEMNCj4gZXRoZXJuZXQgZHJpdmVyLg0KPiAgLi4uDQo+IA0KPiBT
ZXJpZXMgYXBwbGllZCwgdGhhbmtzLg0KDQpUaGFua3MgYSBsb3QuIEkgd291bGQgc2VuZCB0aGUg
aXByb3V0ZTIgcGF0Y2hlcyBvbiB0aGVzZSBlbWFpbCB0aHJlYWQuDQoNCkJyLA0KUG8gTGl1DQo=
