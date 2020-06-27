Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0499420BD89
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 03:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgF0BGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 21:06:32 -0400
Received: from mail-vi1eur05on2062.outbound.protection.outlook.com ([40.107.21.62]:6214
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726101AbgF0BGb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 21:06:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A900vvr1oqfbmG7hi2xJIRePA5PYSvOB2l7svcAgMFjsPF5lFMqAV8ZYHEodTCQm/RfValI5XQiQosvAfNn8fojVWfgUl6WkqNCmgNmpmSah371XihBKuEsNZcD8u0ys4EGKES+R8gwz1ElpSJzS5xFe2MB3jH2zX0hX8NLTeaciVywn6k7cQdB08Yz9dyXYZ/VjYm0WC889Kk5BIqyRA6+7TPC+aYVW2V68Ntf2KyiPVA/5k7XSONIwSQPfK3oAkCxyz8SI80bdpfG/9G8ca6Mi6OLs5kQB5pKRx25DfWAiWpJDxG9YEgNEfVjrGt7uNgo2bDPvApQPqaTHEXDTvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kDAXNqRVmnXUg9usKF6cWr3v0fdpH3aNGXBkjHm9no0=;
 b=hdXYaeu7Fni2C48wZQ0cgStZhfkj4omoUOEDYlsZk4gt3JDSfGIWYIcuGGnuIk+8lAlYwN9+VQqFtrv8TbeWBge2A6uzVMO5IqvL8Rdrn1k6cSmVXrK+LqKfiAbZEadk/8IEpWTHSI57hdfOZHVjJeqPgEWdgdb3E11iQ5xC0fI62+wPMhrekVHYaX7/ByFd75pcMPAsWOOV8sCclf8HWh3Atcp/I0GWQlRcAFI83aMQ74YyoHuFnN27ww+124yxgYAMg/p9qBCIjdgNKzgoU+mc3leC3K0jYX9D+NSvEDfZM6CYItNXUFrspm21km1keDn40thsz+58wVMQUOLjZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kDAXNqRVmnXUg9usKF6cWr3v0fdpH3aNGXBkjHm9no0=;
 b=nHlQZpZysiQoUqoYXIdG+GYEVxl9ZtkTJ4KhqpP1wX9nUN21hseIcsBmp1s+CCQK+PoL9jKwcqKj/u9TGhn3UYsHSJDT9gS3lujLlUSxrAnz1GtoS37SDuVE2ONP/N6WvtAZp6tftZMVDCHBgNbmehC6OGYE1V6eJKrsRzR8liE=
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VI1PR04MB4000.eurprd04.prod.outlook.com (2603:10a6:803:4c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Sat, 27 Jun
 2020 01:06:24 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::c1ea:5943:40e8:58f1]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::c1ea:5943:40e8:58f1%3]) with mapi id 15.20.3131.025; Sat, 27 Jun 2020
 01:06:24 +0000
From:   Po Liu <po.liu@nxp.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "idosch@idosch.org" <idosch@idosch.org>
CC:     "jiri@resnulli.us" <jiri@resnulli.us>,
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
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "moshe@mellanox.com" <moshe@mellanox.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "andre.guedes@linux.intel.com" <andre.guedes@linux.intel.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        Edward Cree <ecree@solarflare.com>
Subject: RE:  Re: [v1,net-next 3/4] net: qos: police action add index for tc
 flower offloading
Thread-Topic: Re: [v1,net-next 3/4] net: qos: police action add index for tc
 flower offloading
Thread-Index: AdZLxKgmD59kGggcTEKT0YbNVDx95g==
Date:   Sat, 27 Jun 2020 01:06:23 +0000
Message-ID: <VE1PR04MB6496E945835DED23EA746A3D92900@VE1PR04MB6496.eurprd04.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mojatatu.com; dkim=none (message not signed)
 header.d=none;mojatatu.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [221.221.90.193]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3e8d00c7-4bc2-4259-4950-08d81a364fe0
x-ms-traffictypediagnostic: VI1PR04MB4000:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB4000CC17E954D03E395454B892900@VI1PR04MB4000.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0447DB1C71
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bjb6H/J/QP0ECRaQteTaj2B6wUSzbvUfZoOD6Z0nnudiTiagt3x80tL6YUn9irsNTGPy4H73rqYAHh7xauK04bqibW4j+Qrs1xWwgK9ZV2zyIymId4C1aPxx/9WbJm/wWQVUHAWuEAODxKeOCX1+OYxMAUaLNto9YiPZ+ZTTej0LV0RjtTz8zRxfE3tdPL+EaJhyAODWTNwqjs8vdcaZDIEkGzyUjTGlR3yGTv4ZTSkrvsnYE9eSVAeOUCYHFK/3gFjBH0w5/5sXUVkMRqRWwx6Z5gzettXxlSK83uRYNO8s9SEx88qI5Wp2r+IjOg+WF5iFr2JiJTGoXIhCWmeQvBIPGWQmwkmH9mruJUgwLd0lVmZszzFQAADEi+Jy6SaTyfNqMD/AtSJ+z44vE2T6gA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(376002)(396003)(346002)(39860400002)(366004)(4326008)(71200400001)(83080400001)(2906002)(966005)(66556008)(66946007)(66446008)(8936002)(66476007)(8676002)(64756008)(45080400002)(83380400001)(316002)(54906003)(186003)(33656002)(478600001)(110136005)(55016002)(9686003)(86362001)(26005)(7416002)(7696005)(52536014)(6506007)(44832011)(76116006)(5660300002)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 49Th8QngXj98iioC37A1xsKQZDi9rSmCOr7yMvWegxbLJ0SCFrbso5c7wfLYBFxEKJdWwIlqKXsFClUHf4lJXRbZR6fL6oB8RTyuapk/uwvQeZb2/9LvC8qTG7tEqI90+Oh5olWdmvVAFwpPl65zd+BZ33eid0bHUcpClNo+vulIaCpl/A7xh5ukDogAV/2yPvApdDCKgJ3GHCZonrCfoQjVQH6nfXzvHJVTGUH2J/836AmAKTTM+maM9p28eZ76zp7z3RFCExf2gHinFj+mYh7mfCN9Yy7vT+gMPuna4uZveMk+PJOCEKjdKzXV0Fe/6su9P7wfg7buG78hwB9+eiet+K43iQdeol5DFFwWSEYdfBIwKLfLbOq4+WEfXUbhZ/cHlb/h1EZjGA88b+WV45XCkf9hYPeky/J6+fz2ZVdTwZsQ0e8TnWBQJOAakHPH43Mc+LaqeK0wwEYFOCPzTwMICMRM2cQKN/7vdMVog/etY5vASvABCRZvffdxb5+e
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6496.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e8d00c7-4bc2-4259-4950-08d81a364fe0
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2020 01:06:24.0731
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TPfWTgWLyGKyFaHObfOJx9BS92snEl8G3Y2vVS8UD3dPliqw8ZiHUNQDN9B2U+XU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSmFtYWwsDQoNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKYW1h
bCBIYWRpIFNhbGltIDxqaHNAbW9qYXRhdHUuY29tPg0KPiBTZW50OiAyMDIw5bm0NuaciDI25pel
IDIxOjI4DQo+IFRvOiBQbyBMaXUgPHBvLmxpdUBueHAuY29tPjsgZGF2ZW1AZGF2ZW1sb2Z0Lm5l
dDsgbGludXgtDQo+IGtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5v
cmc7IGlkb3NjaEBpZG9zY2gub3JnDQo+IENjOiBqaXJpQHJlc251bGxpLnVzOyB2aW5pY2l1cy5n
b21lc0BpbnRlbC5jb207IHZsYWRAYnVzbG92LmRldjsgQ2xhdWRpdQ0KPiBNYW5vaWwgPGNsYXVk
aXUubWFub2lsQG54cC5jb20+OyBWbGFkaW1pciBPbHRlYW4NCj4gPHZsYWRpbWlyLm9sdGVhbkBu
eHAuY29tPjsgQWxleGFuZHJ1IE1hcmdpbmVhbg0KPiA8YWxleGFuZHJ1Lm1hcmdpbmVhbkBueHAu
Y29tPjsgbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTsNCj4gdmlzaGFsQGNoZWxzaW8uY29tOyBz
YWVlZG1AbWVsbGFub3guY29tOyBsZW9uQGtlcm5lbC5vcmc7DQo+IGppcmlAbWVsbGFub3guY29t
OyBpZG9zY2hAbWVsbGFub3guY29tOw0KPiBhbGV4YW5kcmUuYmVsbG9uaUBib290bGluLmNvbTsg
VU5HTGludXhEcml2ZXJAbWljcm9jaGlwLmNvbTsNCj4ga3ViYUBrZXJuZWwub3JnOyB4aXlvdS53
YW5nY29uZ0BnbWFpbC5jb207DQo+IHNpbW9uLmhvcm1hbkBuZXRyb25vbWUuY29tOyBwYWJsb0Bu
ZXRmaWx0ZXIub3JnOw0KPiBtb3NoZUBtZWxsYW5veC5jb207IG0ta2FyaWNoZXJpMkB0aS5jb207
DQo+IGFuZHJlLmd1ZWRlc0BsaW51eC5pbnRlbC5jb207IHN0ZXBoZW5AbmV0d29ya3BsdW1iZXIu
b3JnOyBFZHdhcmQNCj4gQ3JlZSA8ZWNyZWVAc29sYXJmbGFyZS5jb20+DQo+IFN1YmplY3Q6IFJl
OiBbdjEsbmV0LW5leHQgMy80XSBuZXQ6IHFvczogcG9saWNlIGFjdGlvbiBhZGQgaW5kZXggZm9y
IHRjDQo+IGZsb3dlciBvZmZsb2FkaW5nDQo+IA0KPiBPbiAyMDIwLTA2LTI0IDg6MzQgcC5tLiwg
UG8gTGl1IHdyb3RlOg0KPiA+DQo+ID4NCj4gPj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0N
Cj4gDQo+ID4+IFRoYXQgaXMgdGhlIHBvaW50IGkgd2FzIHRyeWluZyB0byBnZXQgdG8uIEJhc2lj
YWxseToNCj4gPj4gWW91IGhhdmUgYSBjb3VudGVyIHRhYmxlIHdoaWNoIGlzIHJlZmVyZW5jZWQg
YnkgImluZGV4Ig0KPiA+PiBZb3UgYWxzbyBoYXZlIGEgbWV0ZXIvcG9saWNlciB0YWJsZSB3aGlj
aCBpcyByZWZlcmVuY2VkIGJ5ICJpbmRleCIuDQo+ID4NCj4gPiBUaGV5IHNob3VsZCBiZSBvbmUg
c2FtZSBncm91cCBhbmQgc2FtZSBtZWFuaW5nLg0KPiA+DQo+IA0KPiBEaWRudCBmb2xsb3cuIFlv
dSBtZWFuIHRoZSBpbmRleCBpcyB0aGUgc2FtZSBmb3IgYm90aCB0aGUgc3RhdCBhbmQgcG9saWNl
cj8NCg0KU29ycnksIGp1c3QgaWdub3JlIHRoaXMgcmVwbHkgbGluZSwgaGFyZHdhcmUgaGFzIHRo
aXMgcG9saWNlIGluZGV4IGNvdW50ZXIsIGJ1dCB3YXNuJ3QgdXNlIGluIHRoaXMgdGMgY29tbWFu
ZCwganVzdCBmb2N1cyBvbiBiZWxvdyBwc2ZwX3N0cmVhbWZpbHRlcl9jb3VudGVycy4gDQpJIHRo
b3VnaHQgeW91IHRob3VnaHQgaW4gdGhpcyB3YXkuDQoNCj4gDQo+ID4+DQo+ID4+IEZvciBwb2xp
Y2VycywgdGhleSBtYWludGFpbiB0aGVpciBvd24gc3RhdHMuIFNvIHdoZW4gaSBzYXk6DQo+ID4+
IHRjIC4uLiBmbG93ZXIgLi4uIGFjdGlvbiBwb2xpY2UgLi4uIGluZGV4IDUgVGhlIGluZGV4IHJl
ZmVycmVkIHRvIGlzDQo+ID4+IGluIHRoZSBwb2xpY2VyIHRhYmxlDQo+ID4+DQo+ID4NCj4gPiBT
dXJlLiBNZWFucyBwb2xpY2Ugd2l0aCBOby4gNSBlbnRyeS4NCj4gPg0KPiA+PiBCdXQgZm9yIG90
aGVyIGFjdGlvbnMsIGV4YW1wbGUgd2hlbiBpIHNheToNCj4gPj4gdGMgLi4uIGZsb3dlciAuLi4g
YWN0aW9uIGRyb3AgaW5kZXggMTANCj4gPg0KPiA+IFN0aWxsIHRoZSBxdWVzdGlvbiwgZG9lcyBn
YWN0IGFjdGlvbiBkcm9wIGNvdWxkIGJpbmQgd2l0aCBpbmRleD8gSXQNCj4gZG9lc24ndCBtZWFu
ZnVsLg0KPiA+DQo+IA0KPiBEZXBlbmRzIG9uIHlvdXIgaGFyZHdhcmUuIEZyb20gdGhpcyBkaXNj
dXNzaW9uIGkgYW0gdHJ5aW5nIHRvIHVuZGVyc3RhbmQNCj4gd2hlcmUgdGhlIGNvbnN0cmFpbnQg
aXMgZm9yIHlvdXIgY2FzZS4NCj4gV2hldGhlciBpdCBpcyB5b3VyIGgvdyBvciB0aGUgVFNOIHNw
ZWMuDQo+IEZvciBhIHNhbXBsZSBjb3VudGluZyB3aGljaCBpcyBmbGV4aWJsZSBzZWUgaGVyZToN
Cj4gaHR0cHM6Ly9ldXIwMS5zYWZlbGlua3MucHJvdGVjdGlvbi5vdXRsb29rLmNvbS8/dXJsPWh0
dHBzJTNBJTJGJTJGcDQubw0KPiByZyUyRnA0LXNwZWMlMkZkb2NzJTJGUFNBLmh0bWwlMjNzZWMt
DQo+IGNvdW50ZXJzJmFtcDtkYXRhPTAyJTdDMDElN0Nwby5saXUlNDBueHAuY29tJTdDMDJkYzhm
M2Y2MDcxNGFmZA0KPiAzZGFiMDhkODE5ZDRjNjZlJTdDNjg2ZWExZDNiYzJiNGM2ZmE5MmNkOTlj
NWMzMDE2MzUlN0MwJTdDMSU3DQo+IEM2MzcyODc3NDg5NDEwNDEzNTMmYW1wO3NkYXRhPTklMkZT
JTJCQU1iSFYwOUg1VnJKTXdkRWVpU1B6Zw0KPiA0dyUyRm1XNUZ4UXI0ZWN1emU0JTNEJmFtcDty
ZXNlcnZlZD0wDQo+IA0KPiBUaGF0IGNvbmNlcHQgaXMgbm90IHNwZWNpZmljIHRvIFA0IGJ1dCBy
YXRoZXIgdG8gbmV3ZXIgZmxvdy1iYXNlZA0KPiBoYXJkd2FyZS4NCj4gDQo+IE1vcmUgY29udGV4
dDoNCj4gVGhlIGFzc3VtcHRpb24gdGhlc2UgZGF5cyBpcyB3ZSBjYW4gaGF2ZSBhIF9sb3RfIG9m
IGZsb3dzIHdpdGggYSBsb3Qgb2YNCj4gYWN0aW9ucy4NCj4gVGhlbiB5b3Ugd2FudCB0byBiZSBh
YmxlIHRvIGNvbGxlY3QgdGhlIHN0YXRzIHNlcGFyYXRlbHksIHBvc3NpYmx5IG9uZQ0KPiBjb3Vu
dGVyIGVudHJ5IGZvciBlYWNoIGFjdGlvbiBvZiBpbnRlcmVzdC4NCj4gV2h5IGlzIHRoaXMgaW1w
b3J0YW50P2YgRm9yIGFuYWx5dGljcyB1c2VzIGNhc2VzLCB3aGVuIHlvdSBhcmUgcmV0cmlldmlu
Zw0KPiB0aGUgc3RhdHMgeW91IHdhbnQgdG8gcmVkdWNlIHRoZSBhbW91bnQgb2YgZGF0YSBiZWlu
ZyByZXRyaWV2ZWQuIFR5cGljYWxseQ0KPiB0aGVzZSBzdGF0cyBhcmUgcG9sbGVkIGV2ZXJ5IFgg
c2Vjb25kcy4NCj4gRm9yIHN0YXJ0ZXJzLCB5b3UgZG9udCBkdW1wIGZpbHRlcnMgKHdoaWNoIGlu
IHlvdXIgY2FzZSBzZWVtcyB0byBiZSB0aGUNCj4gb25seSB3YXkgdG8gZ2V0IHRoZSBzdGF0cyku
DQo+IEluIGN1cnJlbnQgdGMsIHlvdSBkdW1wIHRoZSBhY3Rpb25zLiBCdXQgdGhhdCBjb3VsZCBi
ZSBpbXByb3ZlZCBzbyB5b3UNCj4gY2FuIGp1c3QgZHVtcCB0aGUgc3RhdHMuIFRoZSBtYXBwaW5n
IG9mIHN0YXRzIGluZGV4IHRvIGFjdGlvbnMgaXMga25vd24gdG8NCj4gdGhlIGVudGl0eSBkb2lu
ZyB0aGUgZHVtcC4NCj4gDQo+IERvZXMgdGhhdCBtYWtlIHNlbnNlPw0KPiANCj4gPj4gVGhlIGlu
ZGV4IGlzIGluIHRoZSBjb3VudGVyL3N0YXRzIHRhYmxlLg0KPiA+PiBJdCBpcyBub3QgZXhhY3Rs
eSAiMTAiIGluIGhhcmR3YXJlLCB0aGUgZHJpdmVyIG1hZ2ljYWxseSBoaWRlcyBpdA0KPiA+PiBm
cm9tIHRoZSB1c2VyIC0gc28gaXQgY291bGQgYmUgaHcgY291bnRlciBpbmRleCAxMjM0DQo+ID4N
Cj4gPiBOb3QgZXhhY3RseS4gQ3VycmVudCBmbG93ZXIgb2ZmbG9hZGluZyBzdGF0cyBtZWFucyBn
ZXQgdGhlIGNoYWluIGluZGV4DQo+IGZvciB0aGF0IGZsb3cgZmlsdGVyLiBUaGUgb3RoZXIgYWN0
aW9ucyBzaG91bGQgYmluZCB0byB0aGF0IGNoYWluIGluZGV4Lg0KPiAgPg0KPiANCj4gU28gaWYg
aSByZWFkIGNvcnJlY3RseTogWW91IGhhdmUgYW4gaW5kZXggcGVyIGZpbHRlciBwb2ludGluZyB0
byB0aGUgY291bnRlcg0KPiB0YWJsZS4NCj4gSXMgdGhpcyBzb21ldGhpbmcgX3lvdV8gZGVjaWRl
ZCB0byBkbyBpbiBzb2Z0d2FyZSBvciBpcyBpdCBob3cgdGhlDQo+IGhhcmR3YXJlIHdvcmtzPyAo
bm90ZSBpIHJlZmVycmVkIHRvIHRoaXMgYXMgImxlZ2FjeSBBQ0wiIGFwcHJvYWNoIGVhcmxpZXIu
DQo+IEl0IHdvcmtlZCBsaWtlIHRoYXQgaW4gb2xkIGhhcmR3YXJlIGJlY2F1c2UgdGhlIG1haW4g
dXNlIGNhc2Ugd2FzIHRvIGhhdmUNCj4gb25lIGFjdGlvbiBvbiBhIG1hdGNoIChkcm9wL2FjY2Vw
dCBraW5kKS4NCg0KSXQgaXMgdGhlIGhhcmR3YXJlIHdvcmtzIGFuZCBhbGwgcmVnaXN0ZXJzIGFj
Y29yZGluZyB0byB0aGUgSUVFRTgwMi4xUWNpIHNwZWMuDQoNCj4gDQo+ID5MaWtlIElFRUU4MDIu
MVFjaSwgd2hhdCBJIGFtIGRvaW5nIGlzIGJpbmQgZ2F0ZSBhY3Rpb24gdG8gZmlsdGVyDQo+IGNo
YWluKG1hbmRhdG9yeSkuIEFuZCBhbHNvIHBvbGljZSBhY3Rpb24gYXMgb3B0aW9uYWwuDQo+IA0K
PiBJIGNhbnQgc2VlbSB0byBmaW5kIHRoaXMgc3BlYyBvbmxpbmUuIElzIGl0IGZyZWVseSBhdmFp
bGFibGU/DQoNCk1heWJlIG5lZWQgYSByZWdpc3RlciBjb3VudCBvbiBodHRwOi8vd3d3LmllZWU4
MDIub3JnLw0KDQo+IEFsc28sIGlmIGkgdW5kZXJzdGFuZCB5b3UgY29ycmVjdGx5IHlvdSBhcmUg
c2F5aW5nIGFjY29yZGluZyB0byB0aGlzIHNwZWMNCj4geW91IGNhbiBvbmx5IGhhdmUgdGhlIGZv
bGxvd2luZyB0eXBlIG9mIHBvbGljeToNCj4gdGMgLi4gZmlsdGVyIG1hdGNoLXNwZWMtaGVyZSAu
LiBcDQo+IGFjdGlvbiBnYXRlIGdhdGUtYWN0aW9uLWF0dHJpYnV0ZXMgXA0KPiBhY3Rpb24gcG9s
aWNlIC4uLg0KPiANCj4gVGhhdCAiYWN0aW9uIGdhdGUiIE1VU1QgYWx3YXlzIGJlIHByZXNlbnQg
YnV0ICJhY3Rpb24gcG9saWNlIiBpcyBvcHRpb25hbD8NCg0KWWVzLiBUaGF0IGlzIHdoYXQgSSB0
cnlpbmcgdG8gZG86IG1hcCBzdHJlYW0gZ2F0ZSB0byBnYXRlIGFjdGlvbiBhbmQgZmxvdyBtZXRl
cmluZyBlbnRyeSB0byBhY3Rpb24gcG9saWNlLiBBbmQgYSBmbG93IGZpbHRlciB0byBhIHN0cmVh
bSBmaWx0ZXIgZW50cnkuIEVhY2ggc3RyZWFtIGZpbHRlciBlbnRyeSBpbiBoYXJkd2FyZSBiaW5k
IHdpdGggc3RyZWFtIGZpbHRlciBlbnRyeS4NCg0KPiANCj4gPiBUaGVyZSBpcyBzdHJlYW0gY291
bnRlciB0YWJsZSB3aGljaCBzdW1tYXJ5IHRoZSBjb3VudGVycyBwYXNzIGdhdGUNCj4gYWN0aW9u
IGVudHJ5IGFuZCBwb2xpY2UgYWN0aW9uIGVudHJ5IGZvciB0aGF0IGNoYWluIGluZGV4KHRoZXJl
IGlzIGEgYml0DQo+IGRpZmZlcmVudCBpZiB0d28gY2hhaW4gc2hhcmluZyBzYW1lIGFjdGlvbiBs
aXN0KS4NCj4gPiBPbmUgY2hhaW4gY291bnRlciB3aGljaCB0YyBzaG93IHN0YXRzIGdldCBjb3Vu
dGVyIHNvdXJjZToNCj4gPiBzdHJ1Y3QgcHNmcF9zdHJlYW1maWx0ZXJfY291bnRlcnMgew0KPiA+
ICAgICAgICAgIHU2NCBtYXRjaGluZ19mcmFtZXNfY291bnQ7DQo+ID4gICAgICAgICAgdTY0IHBh
c3NpbmdfZnJhbWVzX2NvdW50Ow0KPiA+ICAgICAgICAgIHU2NCBub3RfcGFzc2luZ19mcmFtZXNf
Y291bnQ7DQo+ID4gICAgICAgICAgdTY0IHBhc3Npbmdfc2R1X2NvdW50Ow0KPiA+ICAgICAgICAg
IHU2NCBub3RfcGFzc2luZ19zZHVfY291bnQ7DQo+ID4gICAgICAgICAgdTY0IHJlZF9mcmFtZXNf
Y291bnQ7DQo+ID4gfTsNCj4gPg0KPiANCj4gQXNzdW1pbmcgcHNmcCBpcyBzb21ldGhpbmcgZGVm
aW5lZCBpbiBJRUVFODAyLjFRY2kgYW5kIHRoZSBzcGVjIHdpbGwNCj4gZGVzY3JpYmUgdGhlc2U/
DQoNClllcy4NCg0KPiBJcyB0aGUgZmlsdGVyICAiaW5kZXgiIHBvaW50aW5nIHRvIG9uZSBvZiB0
aG9zZSBpbiBzb21lIGNvdW50ZXIgdGFibGU/DQoNCkZpbHRlciAnaW5kZXgnIHRvZ2V0aGVyIHdp
dGggYSBjb3VudGVyICdpbmRleCcgYXMgc3RhdGlzdGljcy4NCg0KPiANCj4gDQo+ID4gV2hlbiBw
YXNzIHRvIHRoZSB1c2VyIHNwYWNlLCBzdW1tYXJpemUgYXM6DQo+ID4gICAgICAgICAgc3RhdHMu
cGt0cyA9IGNvdW50ZXJzLm1hdGNoaW5nX2ZyYW1lc19jb3VudCArDQo+ID4gY291bnRlcnMubm90
X3Bhc3Npbmdfc2R1X2NvdW50IC0gZmlsdGVyLT5zdGF0cy5wa3RzOw0KPiAgPg0KPiA+ICAgICAg
ICAgIHN0YXRzLmRyb3BzID0gY291bnRlcnMubm90X3Bhc3NpbmdfZnJhbWVzX2NvdW50ICsNCj4g
Y291bnRlcnMubm90X3Bhc3Npbmdfc2R1X2NvdW50ICsgICBjb3VudGVycy5yZWRfZnJhbWVzX2Nv
dW50IC0gZmlsdGVyLQ0KPiA+c3RhdHMuZHJvcHM7DQo+ID4NCj4gDQo+IFRoYW5rcyBmb3IgdGhl
IGV4cGxhbmF0aW9uLg0KPiBXaGF0IGlzIGZpbHRlci0+c3RhdHM/DQoNCkZpbHRlci0+c3RhdHMg
YnVmZmVyIHRoZSBjb3VudGVycyBsYXN0IHRpbWUgcmVhZCBzdGF0cy4gRmxvd2VyIHN0YXRzIGdl
dCB0aGUgaW5jcmVhc2luZyBjb3VudGVycy4NCg0KPiBUaGUgcmVzdCBvZiB0aG9zZSBjb3VudGVy
cyBzZWVtIHJlbGF0ZWQgdG8gdGhlIGdhdGUgYWN0aW9uLg0KPiBIb3cgZG8geW91IGFjY291bnQg
Zm9yIHBvbGljaW5nIGFjdGlvbnM/DQoNCmNvdW50ZXJzLnJlZF9mcmFtZXNfY291bnQgaXMgdGhl
IHBvbGljaW5nIGFjdGlvbiBjb3VudGVycy4NCg0KDQo+IA0KPiBjaGVlcnMsDQo+IGphbWFsDQoN
Cg0KQnIsDQpQbyBMaXUNCg==
