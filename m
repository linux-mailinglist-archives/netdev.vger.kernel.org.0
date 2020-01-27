Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8D2314A77D
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 16:49:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729505AbgA0Ptr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 10:49:47 -0500
Received: from mail-eopbgr150040.outbound.protection.outlook.com ([40.107.15.40]:48682
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728783AbgA0Ptq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 10:49:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mLsYktOpH8H5NGzo7oQUTOLdytdpjbF4KJPOs5o4mOux+35aZno52PjfCzXG4vApzEwYAkaEYL8y3bWElPGCBzVuwCGPuQjNLJRSzz1y9kP74y8z/cU5g+TXZiaw7sJIvmrRE+frQuy5Ii0ilkG1cHso6VMv9Kvsfd4EdVNEVpkXZHPVY9lUDCsFRpTiWDI2qlVFCRg6xHvg2I2B1Ny1P6IYSBLeeP9oAllskieR5f9OZ63uJwg28qqq2vrZHK0Laktc/J+TyvaSXRlJ2imkj2l331O2bPI/3yhY25mwQqt+AEZBP6ZTk/y718yz2C7IO3vt7heBJNLX/AjAzIz7qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e3h84hxu4V9dgvjJmJUCX4+6zxKBtNIUF4JADQOwhOw=;
 b=ChZ5PcA1v/XIcfhKOaN9li4YVeQCHRzODXagzO5J/r5YDZxmGgJDXKyXKY4emPksspGRr3yMU4MOk1Lb+NmV+4oLH54yri5hHb6vn55Qf5c6ZkJMNPZlyvsS8GsWS3qYAM+DG6cZ9f6QNhc9GGBzLMH48FLWkCPiYnUsKDwX8LZEwzsYDyo7zgHHLW+8YggwHd3E9Qa0g2Innv5jnm14gTLDc+DiEaNQCa41IHTA4dWdVucOznxTefeyBB4uvEqwoVHWscjtrl54I6I1Pw2MxbwYPdHn/dhSZKOv9oatQDDabAFHZ/UW2/Zf69jYZ3rcO1PqD22DZJQS1esrd/Eu4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e3h84hxu4V9dgvjJmJUCX4+6zxKBtNIUF4JADQOwhOw=;
 b=IKN2sTCs5RdEYeqSubBbvM4aEUZKKMbSI3yKhqpgp5CFxJWhshMZn5zNZWT0yLzFyzfQRBR8buU+z3aGmwcHrU4lDqcrn98FkRhjn24L4d2jVcRB8DAqTFl47BzPf4JHUeLvmMkMEJADzM89yDgJdlTlY53D027ag7WiKcv8eyI=
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com (52.133.243.85) by
 DB8PR04MB6361.eurprd04.prod.outlook.com (20.179.249.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.24; Mon, 27 Jan 2020 15:49:42 +0000
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::c181:4a83:14f2:27e3]) by DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::c181:4a83:14f2:27e3%6]) with mapi id 15.20.2665.026; Mon, 27 Jan 2020
 15:49:42 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "ykaukab@suse.de" <ykaukab@suse.de>
Subject: RE: [PATCH v2 2/2] dpaa_eth: support all modes with rate adapting
 PHYs
Thread-Topic: [PATCH v2 2/2] dpaa_eth: support all modes with rate adapting
 PHYs
Thread-Index: AQHV1SOT4TVxn3QCwU2UHzdlmVFpwqf+o0+AgAAE+tA=
Date:   Mon, 27 Jan 2020 15:49:42 +0000
Message-ID: <DB8PR04MB69853D197A7DCF6D02F8B876EC0B0@DB8PR04MB6985.eurprd04.prod.outlook.com>
References: <1580137671-22081-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1580137671-22081-3-git-send-email-madalin.bucur@oss.nxp.com>
 <CA+h21hqzR72v9=dWGk1zBptNHNst+kajh6SHHSUMp02fAq5m5g@mail.gmail.com>
In-Reply-To: <CA+h21hqzR72v9=dWGk1zBptNHNst+kajh6SHHSUMp02fAq5m5g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@oss.nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [86.126.28.142]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4c9acfc3-ee7d-4b50-41e0-08d7a340866d
x-ms-traffictypediagnostic: DB8PR04MB6361:|DB8PR04MB6361:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB636142A57A2F026FA5B9F273AD0B0@DB8PR04MB6361.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02951C14DC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(366004)(346002)(376002)(136003)(189003)(199004)(9686003)(478600001)(33656002)(55016002)(86362001)(71200400001)(76116006)(66476007)(66556008)(64756008)(186003)(5660300002)(52536014)(66946007)(66446008)(26005)(4326008)(81166006)(81156014)(7696005)(54906003)(110136005)(2906002)(8936002)(8676002)(6506007)(53546011)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR04MB6361;H:DB8PR04MB6985.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:0;
received-spf: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wD4LYb/A+qwJ1wTcrD6ebe8CZF37yqccxHGYkIZFVMdwF2/HKfMndIyHdUeZEU0RDAVTNbyfK/+GdXBdNsQJF7imNziJAJOOB7c3jUMj567lebn8qcCH+T/4L2NHIJIh00bYrgnZkyqcFPUeICBqwL0khPvMv6iIUgfpEBev1l5blZJNlCODo4WPBo0NJ8oSdXPGZIH/A2ePHwk+ISbMwohqh47+mIT9tz59xmd8CkaLEz/N/7n0P3CkWnsSU/rJU8/et9dCY8JWfUBx4ITpegOpggai1s8fuWE7FwlxApfMJ90GsHKPwVKctfZAvdBrXRVEjuguP3jtcGFAj39nbbxnl7GQi02YrXKYsJI6uJ0I2KCfu20gUvrtDbBt8unQrO2bIuhCxf2mezX/KbAVc40jxSBDvu3BmK9oo/J/hqacF9oGMYDx+SdyT2yOGViS
x-ms-exchange-antispam-messagedata: q+lNIC2NHS2rr+9k7u8b1MHqR+sJaoxIo/tnDG3H82MEDbwVoRqVHU8mhMnGYCwG15G9ZI1ydv3HRe1h7Y6FZESecrFExhtVnt+XtXFPG0m1R++CzBigT9yJ+VM5BqgtqyY9+FXNvHVdY+ZpbJ8Jug==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c9acfc3-ee7d-4b50-41e0-08d7a340866d
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2020 15:49:42.3053
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H/OHIRm9U+C6+eeJMctUMVthvtH2r9YfFg0dZkGlwSMaPr4MGepvLdQjmevYCvol+/CwRi9fiCELB9T6sI8QWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6361
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBWbGFkaW1pciBPbHRlYW4gPG9s
dGVhbnZAZ21haWwuY29tPg0KPiBTZW50OiBNb25kYXksIEphbnVhcnkgMjcsIDIwMjAgNTozMSBQ
TQ0KPiBUbzogTWFkYWxpbiBCdWN1ciAoT1NTKSA8bWFkYWxpbi5idWN1ckBvc3MubnhwLmNvbT4N
Cj4gQ2M6IERhdmlkIFMuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEFuZHJldyBMdW5u
IDxhbmRyZXdAbHVubi5jaD47DQo+IEZsb3JpYW4gRmFpbmVsbGkgPGYuZmFpbmVsbGlAZ21haWwu
Y29tPjsgSGVpbmVyIEthbGx3ZWl0DQo+IDxoa2FsbHdlaXQxQGdtYWlsLmNvbT47IG5ldGRldiA8
bmV0ZGV2QHZnZXIua2VybmVsLm9yZz47IHlrYXVrYWJAc3VzZS5kZQ0KPiBTdWJqZWN0OiBSZTog
W1BBVENIIHYyIDIvMl0gZHBhYV9ldGg6IHN1cHBvcnQgYWxsIG1vZGVzIHdpdGggcmF0ZSBhZGFw
dGluZw0KPiBQSFlzDQo+IA0KPiBIaSBNYWRhbGluLA0KPiANCj4gT24gTW9uLCAyNyBKYW4gMjAy
MCBhdCAxNzowOCwgTWFkYWxpbiBCdWN1ciA8bWFkYWxpbi5idWN1ckBvc3MubnhwLmNvbT4NCj4g
d3JvdGU6DQo+ID4NCj4gPiBTdG9wIHJlbW92aW5nIG1vZGVzIHRoYXQgYXJlIG5vdCBzdXBwb3J0
ZWQgb24gdGhlIHN5c3RlbSBpbnRlcmZhY2UNCj4gPiB3aGVuIHRoZSBjb25uZWN0ZWQgUEhZIGlz
IGNhcGFibGUgb2YgcmF0ZSBhZGFwdGF0aW9uLiBUaGlzIGFkZHJlc3Nlcw0KPiA+IGFuIGlzc3Vl
IHdpdGggdGhlIExTMTA0NkFSREIgYm9hcmQgMTBHIGludGVyZmFjZSBubyBsb25nZXIgd29ya2lu
Zw0KPiA+IHdpdGggYW4gMUcgbGluayBwYXJ0bmVyIGFmdGVyIGF1dG9uZWdvdGlhdGlvbiBzdXBw
b3J0IHdhcyBhZGRlZA0KPiA+IGZvciB0aGUgQXF1YW50aWEgUEhZIG9uIGJvYXJkIGluDQo+ID4N
Cj4gPiBjb21taXQgMDljNGM1N2Y3YmM0ICgibmV0OiBwaHk6IGFxdWFudGlhOiBhZGQgc3VwcG9y
dCBmb3IgYXV0by0NCj4gbmVnb3RpYXRpb24gY29uZmlndXJhdGlvbiIpDQo+ID4NCj4gPiBCZWZv
cmUgdGhpcyBjb21taXQgdGhlIHZhbHVlcyBhZHZlcnRpc2VkIGJ5IHRoZSBQSFkgd2VyZSBub3QN
Cj4gPiBpbmZsdWVuY2VkIGJ5IHRoZSBkcGFhX2V0aCBkcml2ZXIgcmVtb3ZhbCBvZiBzeXN0ZW0t
c2lkZSB1bnN1cHBvcnRlZA0KPiA+IG1vZGVzIGFzIHRoZSBhcXJfY29uZmlnX2FuZWcoKSB3YXMg
YmFzaWNhbGx5IGEgbm8tb3AuIEFmdGVyIHRoaXMNCj4gPiBjb21taXQsIHRoZSBtb2RlcyByZW1v
dmVkIGJ5IHRoZSBkcGFhX2V0aCBkcml2ZXIgd2VyZSBubyBsb25nZXINCj4gPiBhZHZlcnRpc2Vk
IHRodXMgYXV0b25lZ290aWF0aW9uIHdpdGggMUcgbGluayBwYXJ0bmVycyBmYWlsZWQuDQo+ID4N
Cj4gPiBSZXBvcnRlZC1ieTogTWlhbiBZb3VzYWYgS2F1a2FiIDx5a2F1a2FiQHN1c2UuZGU+DQo+
ID4gU2lnbmVkLW9mZi1ieTogTWFkYWxpbiBCdWN1ciA8bWFkYWxpbi5idWN1ckBvc3MubnhwLmNv
bT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2RwYWEvZHBh
YV9ldGguYyB8IDEwICsrKysrKystLS0NCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDcgaW5zZXJ0aW9u
cygrKSwgMyBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9l
dGhlcm5ldC9mcmVlc2NhbGUvZHBhYS9kcGFhX2V0aC5jDQo+IGIvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvZnJlZXNjYWxlL2RwYWEvZHBhYV9ldGguYw0KPiA+IGluZGV4IGEzMDFmMDA5NTIyMy4uZDNl
YjIzNTQ1MGU1IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2Fs
ZS9kcGFhL2RwYWFfZXRoLmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2Nh
bGUvZHBhYS9kcGFhX2V0aC5jDQo+ID4gQEAgLTI0NzEsOSArMjQ3MSwxMyBAQCBzdGF0aWMgaW50
IGRwYWFfcGh5X2luaXQoc3RydWN0IG5ldF9kZXZpY2UNCj4gKm5ldF9kZXYpDQo+ID4gICAgICAg
ICAgICAgICAgIHJldHVybiAtRU5PREVWOw0KPiA+ICAgICAgICAgfQ0KPiA+DQo+ID4gLSAgICAg
ICAvKiBSZW1vdmUgYW55IGZlYXR1cmVzIG5vdCBzdXBwb3J0ZWQgYnkgdGhlIGNvbnRyb2xsZXIg
Ki8NCj4gPiAtICAgICAgIGV0aHRvb2xfY29udmVydF9sZWdhY3lfdTMyX3RvX2xpbmtfbW9kZSht
YXNrLCBtYWNfZGV2LQ0KPiA+aWZfc3VwcG9ydCk7DQo+ID4gLSAgICAgICBsaW5rbW9kZV9hbmQo
cGh5X2Rldi0+c3VwcG9ydGVkLCBwaHlfZGV2LT5zdXBwb3J0ZWQsIG1hc2spOw0KPiA+ICsgICAg
ICAgaWYgKG1hY19kZXYtPnBoeV9pZiAhPSBQSFlfSU5URVJGQUNFX01PREVfWEdNSUkgfHwNCj4g
PiArICAgICAgICAgICAhcGh5X2Rldi0+cmF0ZV9hZGFwdGF0aW9uKSB7DQo+ID4gKyAgICAgICAg
ICAgICAgIC8qIFJlbW92ZSBhbnkgZmVhdHVyZXMgbm90IHN1cHBvcnRlZCBieSB0aGUgY29udHJv
bGxlcg0KPiAqLw0KPiA+ICsgICAgICAgICAgICAgICBldGh0b29sX2NvbnZlcnRfbGVnYWN5X3Uz
Ml90b19saW5rX21vZGUobWFzaywNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIG1hY19kZXYtDQo+ID5pZl9zdXBwb3J0KTsNCj4gPiAr
ICAgICAgICAgICAgICAgbGlua21vZGVfYW5kKHBoeV9kZXYtPnN1cHBvcnRlZCwgcGh5X2Rldi0+
c3VwcG9ydGVkLA0KPiBtYXNrKTsNCj4gPiArICAgICAgIH0NCj4gDQo+IElzIHRoaXMgc3VmZmlj
aWVudD8NCj4gSSBzdXBwb3NlIHRoaXMgd29ya3MgYmVjYXVzZSB5b3UgaGF2ZSBmbG93IGNvbnRy
b2wgZW5hYmxlZCBieSBkZWZhdWx0Pw0KPiBXaGF0IHdvdWxkIGhhcHBlbiBpZiB0aGUgdXNlciB3
b3VsZCBkaXNhYmxlIGZsb3cgY29udHJvbCB3aXRoIGV0aHRvb2w/DQoNClVzZXIgbWlzY29uZmln
dXJhdGlvbiBpcyBub3Qgc29tZXRoaW5nIEknZCB0cnkgdG8gcHJldmVudCBmcm9tIGRyaXZlciBj
b2RlLi4uDQoNCj4gPg0KPiA+ICAgICAgICAgcGh5X3N1cHBvcnRfYXN5bV9wYXVzZShwaHlfZGV2
KTsNCj4gPg0KPiA+IC0tDQo+ID4gMi4xLjANCj4gPg0KPiANCj4gUmVnYXJkcywNCj4gLVZsYWRp
bWlyDQo=
