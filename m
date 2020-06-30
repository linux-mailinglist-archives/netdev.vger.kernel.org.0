Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9AB20EE60
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 08:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730240AbgF3G1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 02:27:53 -0400
Received: from mail-eopbgr70059.outbound.protection.outlook.com ([40.107.7.59]:62214
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730220AbgF3G1w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 02:27:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z9KuBpkZJTj2xiS6RhB0swLsWGstV/2G7RKvgwFwswaGdoA39Bfmy4rGnM1w6JWDEuIoa28WGWXf9HBAWOEpHDubOf9N9h/fIPc9/RoolquzaH7JWNMLaCUjncHz+jo463Zqw7aElkeor2pWxhBs3bkILhC6GSKjukUj0dDdnRDSjxXZ/eJcmmdsxpoj5mR5tFqEVWs/UNnEQ20GB07uHaFAAhjX+CCtpKSMgRCMUkHovkEIn/1e0J+Wsv0JRAaXn56gOmeTy4WNcDiAP3qLfs61gtSstv3KHOLndxvYNq92T6ngJla3sFH2RrE/Sh25UbuWE0a1lHnRO/KHyi6Z8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QjI8G2e+9uCiq5CrSn+14ZpMiccj4MXA/pjziMiyMqQ=;
 b=e9Hah2+JOsnkw/I5aZlaTq58v8ph+RQ+7K3GxwrGDwTZa4HQyc3mbIJoDCIrtBD30ZypWWQtsfcNqn75OaMOM9h4gjHy/VN3jg0h3aPMKRrhEkYxTptcv4wQ8FClEYCP82ADkkqIMjMX8+5fePB8PFluYf/00SHQ24NGGWwGRAmao6LDK0vBhML89miGl+RSP38pyzECIdu/r8aFamBKbFDnKQgCPQpcj/YCrTAyIRFuLNi9RPJJ1MdnKFLeUYt+cSbaRIuL3A/PFpk3Ht5P++rVYKRnzNXYCLLvNDnCjeJaT94z+it5oL17gSxz7bz1XywgKqcV12kTU8WjAChDxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QjI8G2e+9uCiq5CrSn+14ZpMiccj4MXA/pjziMiyMqQ=;
 b=rMVfhiQHNIXfMDM7koQrSQRAi64YO20spD/xzStHFmK/IPykomFmLb3v/qaoOj75e6sL4qrO6hNWonLJ0L9OQIsVDNYX3Hwv/krLkuodvJbdPpFywXz3KA/O4Hnb5942ReF4Ct2CvP+NwFE88+RPgCZKe+To5Zb//U4Ie8lwjMA=
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM5PR04MB3076.eurprd04.prod.outlook.com
 (2603:10a6:206:5::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.26; Tue, 30 Jun
 2020 06:27:48 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1%7]) with mapi id 15.20.3131.027; Tue, 30 Jun 2020
 06:27:48 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>,
        David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH net-next] net: ethernet: fec: prevent tx
 starvation under high rx load
Thread-Topic: [EXT] Re: [PATCH net-next] net: ethernet: fec: prevent tx
 starvation under high rx load
Thread-Index: AQHWSyWV3hyWvPwI+E6K+muw3DPNvajtkJeQgAI97gCAAOkCsA==
Date:   Tue, 30 Jun 2020 06:27:48 +0000
Message-ID: <AM6PR0402MB36075CF372D7A31932E32B60FF6F0@AM6PR0402MB3607.eurprd04.prod.outlook.com>
References: <AM6PR0402MB3607B4D0AD43E1CBC41214BCFF910@AM6PR0402MB3607.eurprd04.prod.outlook.com>
 <C3TQ84VVJ0GY.3NZQOFY5QW9VM@wkz-x280>
In-Reply-To: <C3TQ84VVJ0GY.3NZQOFY5QW9VM@wkz-x280>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: waldekranz.com; dkim=none (message not signed)
 header.d=none;waldekranz.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.67]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1117a04a-ebb7-4dfa-4542-08d81cbeb53f
x-ms-traffictypediagnostic: AM5PR04MB3076:
x-microsoft-antispam-prvs: <AM5PR04MB30768AD419DF971B874FC8E2FF6F0@AM5PR04MB3076.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2000;
x-forefront-prvs: 0450A714CB
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gC64A/yr9nBvCgUzziCzmwWjXm1jX5Qo6s4MQ085HZwPQx6OusZrmKRa5+0cXGko+xy+0am0zlrfj1shojz9gX8q7T3f/9fdOQTbU0Y1z5mrieCKZbgJF3frtvLVR0UlrtUyOskrXfFBkLclWIduc8ATkTMmKepMkYYZIU2lhHJxf+YYG/w9ow7SYqF7+VWP22bC2K/GYpw4rPA5oTAtUHiK4vT1IsaeCxBEF4a+Q+dAO7yL9/zYab6C6eMpC6+lsKlMfBNZSwNasHrQrxiQndt8dUFSU6SIbSsKXcLfWga44l5r5v26wwVVZDT2NcgSdVIEfIV0/8P4gEy0PYlgOtvVAUxUw15GBcsXfBRViDs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(346002)(366004)(376002)(136003)(52536014)(76116006)(966005)(5660300002)(55016002)(66946007)(66446008)(64756008)(66556008)(66476007)(186003)(7696005)(6506007)(9686003)(316002)(26005)(110136005)(4326008)(71200400001)(2906002)(8676002)(8936002)(478600001)(45080400002)(33656002)(83380400001)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: CdWHGI2cjfGykISnvk3NvXWT/lRhR5zU2lG4GkKvRYpkG+F65Gg5HMhlf/xrEkuLwQKCoF8thaWNTPUU8NPRQ0P8dYFtgyjfrbHtWPVVdhkzEkUP7MrmJ4dP81lbL1Zrk/o2qwdv5wgCmRi1axWfWO0OihybR9tIQS7qMaXCO8XMICDr/R28TA91VKLRN35jGbEhfOG1uFnJUYQ0OQp8zIH+LLW55DbrJIdFv/5UYOotOkPffNUHlObpK2KI3JUTUcz98OSTsJk+CG4Fd4ydi60yj1LCgmO4XaS8jR44ObPepU7Y2jNHyrBxs2fLHF1s/D425P7iKJOA1V/+aAQcssWX7vIPFpCep24UCKTvgUbx+IzXgyjNMHdw/9/aOojS4u2Z0S196RSpP65EymqHe2wvwM2B3mqjC3SHEWt81tyi1HFhok2O+mLn8TAkjwJVphIU1LC3qNiBPFaLrjDFWneg70TW5BIx2USJYNhzNC4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR0402MB3607.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1117a04a-ebb7-4dfa-4542-08d81cbeb53f
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2020 06:27:48.1864
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: owgxNezHqZA4hb8WB277o3dAip0d5V6hFGi2pCNnGFroT8cslW/0nDo99UA+MLr4tR5VByEPLoQHyJxwL7vyzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR04MB3076
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogVG9iaWFzIFdhbGRla3JhbnogPHRvYmlhc0B3YWxkZWtyYW56LmNvbT4gU2VudDogVHVl
c2RheSwgSnVuZSAzMCwgMjAyMCAxMjoyOSBBTQ0KPiBPbiBTdW4gSnVuIDI4LCAyMDIwIGF0IDg6
MjMgQU0gQ0VTVCwgQW5keSBEdWFuIHdyb3RlOg0KPiA+IEkgbmV2ZXIgc2VlbSBiYW5kd2lkdGgg
dGVzdCBjYXVzZSBuZXRkZXYgd2F0Y2hkb2cgdHJpcC4NCj4gPiBDYW4geW91IGRlc2NyaWJlIHRo
ZSByZXByb2R1Y2Ugc3RlcHMgb24gdGhlIGNvbW1pdCwgdGhlbiB3ZSBjYW4NCj4gPiByZXByb2R1
Y2UgaXQgb24gbXkgbG9jYWwuIFRoYW5rcy4NCj4gDQo+IE15IHNldHVwIHVzZXMgYSBpLk1YOE0g
TmFubyBFVksgY29ubmVjdGVkIHRvIGFuIGV0aGVybmV0IHN3aXRjaCwgYnV0IGNhbg0KPiBnZXQg
dGhlIHNhbWUgcmVzdWx0cyB3aXRoIGEgZGlyZWN0IGNvbm5lY3Rpb24gdG8gYSBQQy4NCj4gDQo+
IE9uIHRoZSBpTVgsIGNvbmZpZ3VyZSB0d28gVkxBTnMgb24gdG9wIG9mIHRoZSBGRUMgYW5kIGVu
YWJsZSBJUHY0DQo+IGZvcndhcmRpbmcuDQo+IA0KPiBPbiB0aGUgUEMsIGNvbmZpZ3VyZSB0d28g
VkxBTnMgYW5kIHB1dCB0aGVtIGluIGRpZmZlcmVudCBuYW1lc3BhY2VzLiBGcm9tDQo+IG9uZSBu
YW1lc3BhY2UsIHVzZSB0cmFmZ2VuIHRvIGdlbmVyYXRlIGEgZmxvdyB0aGF0IHRoZSBpTVggd2ls
bCByb3V0ZSBmcm9tDQo+IHRoZSBmaXJzdCBWTEFOIHRvIHRoZSBzZWNvbmQgYW5kIHRoZW4gYmFj
ayB0b3dhcmRzIHRoZSBzZWNvbmQgbmFtZXNwYWNlIG9uDQo+IHRoZSBQQy4NCj4gDQo+IFNvbWV0
aGluZyBsaWtlOg0KPiANCj4gICAgIHsNCj4gICAgICAgICBldGgoc2E9UENfTUFDLCBkYT1JTVhf
TUFDKSwNCj4gICAgICAgICBpcHY0KHNhZGRyPTEwLjAuMi4yLCBkYWRkcj0xMC4wLjMuMiwgdHRs
PTIpDQo+ICAgICAgICAgdWRwKHNwPTEsIGRwPTIpLA0KPiAgICAgICAgICJIZWxsbyB3b3JsZCIN
Cj4gICAgIH0NCj4gDQo+IFdhaXQgYSBjb3VwbGUgb2Ygc2Vjb25kcyBhbmQgdGhlbiB5b3UnbGwg
c2VlIHRoZSBvdXRwdXQgZnJvbSBmZWNfZHVtcC4NCj4gDQo+IEluIHRoZSBzYW1lIHNldHVwIEkg
YWxzbyBzZWUgYSB3ZWlyZCBpc3N1ZSB3aGVuIHJ1bm5pbmcgYSBUQ1AgZmxvdyB1c2luZw0KPiBp
cGVyZjMuIE1vc3Qgb2YgdGhlIHRpbWUgKH43MCUpIHdoZW4gaSBzdGFydCB0aGUgaXBlcmYzIGNs
aWVudCBJJ2xsIHNlZQ0KPiB+NDUwTWJwcyBvZiB0aHJvdWdocHV0LiBJbiB0aGUgb3RoZXIgY2Fz
ZSAofjMwJSkgSSdsbCBzZWUgfjc5ME1icHMuIFRoZQ0KPiBzeXN0ZW0gaXMgInN0YWJseSBiaS1t
b2RhbCIsIGkuZS4gd2hpY2hldmVyIHJhdGUgaXMgcmVhY2hlZCBpbiB0aGUgYmVnaW5uaW5nIGlz
DQo+IHRoZW4gc3VzdGFpbmVkIGZvciBhcyBsb25nIGFzIHRoZSBzZXNzaW9uIGlzIGtlcHQgYWxp
dmUuDQo+IA0KPiBJJ3ZlIGluc2VydGVkIHNvbWUgdHJhY2Vwb2ludHMgaW4gdGhlIGRyaXZlciB0
byB0cnkgdG8gdW5kZXJzdGFuZCB3aGF0J3MgZ29pbmcNCj4gb246DQo+IGh0dHBzOi8vZXVyMDEu
c2FmZWxpbmtzLnByb3RlY3Rpb24ub3V0bG9vay5jb20vP3VybD1odHRwcyUzQSUyRiUyRnN2Z3No
YQ0KPiByZS5jb20lMkZpJTJGTVZwLnN2ZyZhbXA7ZGF0YT0wMiU3QzAxJTdDZnVnYW5nLmR1YW4l
NDBueHAuY29tJQ0KPiA3QzEyODU0ZTIxZWExMjRiNGNjMmUwMDhkODFjNTlkNjE4JTdDNjg2ZWEx
ZDNiYzJiNGM2ZmE5MmNkOTljNWMNCj4gMzAxNjM1JTdDMCU3QzAlN0M2MzcyOTA1MTk0NTM2NTYw
MTMmYW1wO3NkYXRhPWJ5NFNoT2ttVGFSa0ZmRQ0KPiAweEprclRwdEMlMkIyZWdGZjlpTTRFNWh4
NGppU1UlM0QmYW1wO3Jlc2VydmVkPTANCj4gDQo+IFdoYXQgSSBjYW4ndCBmaWd1cmUgb3V0IGlz
IHdoeSB0aGUgVHggYnVmZmVycyBzZWVtIHRvIGJlIGNvbGxlY3RlZCBhdCBhIG11Y2gNCj4gc2xv
d2VyIHJhdGUgaW4gdGhlIHNsb3cgY2FzZSAodG9wIGluIHRoZSBwaWN0dXJlKS4gSWYgd2UgZmFs
bCBiZWhpbmQgaW4gb25lIE5BUEkNCj4gcG9sbCwgd2Ugc2hvdWxkIGNhdGNoIHVwIGF0IHRoZSBu
ZXh0IGNhbGwgKHdoaWNoIHdlIGNhbiBzZWUgaW4gdGhlIGZhc3QgY2FzZSkuDQo+IEJ1dCBpbiB0
aGUgc2xvdyBjYXNlIHdlIGtlZXAgZmFsbGluZyBmdXJ0aGVyIGFuZCBmdXJ0aGVyIGJlaGluZCB1
bnRpbCB3ZSBmcmVlemUNCj4gdGhlIHF1ZXVlLiBJcyB0aGlzIHNvbWV0aGluZyB5b3UndmUgZXZl
ciBvYnNlcnZlZD8gQW55IGlkZWFzPw0KDQpCZWZvcmUsIG91ciBjYXNlcyBkb24ndCByZXByb2R1
Y2UgdGhlIGlzc3VlLCBjcHUgcmVzb3VyY2UgaGFzIGJldHRlciBiYW5kd2lkdGgNCnRoYW4gZXRo
ZXJuZXQgdURNQSB0aGVuIHRoZXJlIGhhdmUgY2hhbmNlIHRvIGNvbXBsZXRlIGN1cnJlbnQgTkFQ
SS4gVGhlIG5leHQsDQp3b3JrX3R4IGdldCB0aGUgdXBkYXRlLCBuZXZlciBjYXRjaCB0aGUgaXNz
dWUuDQo=
