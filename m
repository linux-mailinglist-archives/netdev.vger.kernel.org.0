Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEB9710AE8E
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 12:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbfK0LQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 06:16:32 -0500
Received: from mail-oln040092253052.outbound.protection.outlook.com ([40.92.253.52]:2337
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726219AbfK0LQc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Nov 2019 06:16:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KRVgAKDZPsZQFrRVeC16JGSdcxZ/jd2KyKqj9VlY6Xt8a4MB9HurrJxRiUgIqgGYx8kQiKtEAqeDEulbwzOMikYcGkOfJTKum+9WN2Ma8IckX4Ln17jbs9/sJ/Sj22WSAVoDN63ukO7DSqmc5+zvlv5YxqFF/REyXnTHRA28OKcULjOYcleO+o2E/uO6r1AELZIiCzs2ThCN+xRSivsrym4J54WbdOPfrlUQ1gyO/P9G10B8VCplw/aDUVyJcGgbLG79ubeqTRqXzdQQUK3M0Vt9m5Dd22rO2ZDGWSu4sAehh/4CmFM9e1XEEQvM0WmXehTmKDDcfL1jlv+pWixubA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mUmLyO8fW8q87Xdw+pPKEFB6jsNUA0R6FJ00BeRcjD4=;
 b=L6jLOXbjAe/tGX/6ax8PfWGp2icgZaqnD83PjvkRX2jV+uNPF6KAE3PhULqkVl7CvtCfcQ/lGmNNBH97LVh0rVPskRDIed0IUASl2H180gY9Li9yEbmZWFGaj5L6wDGsXA77VTSjtUU0lt5S55SPAz51CjmNnHgB2SGJLs+h4Qq262XCf+OeHQZ2N93j1Zt7DqxdLNpdVuB3tqmzcfUc8P8othlUt7SCdbvLC80cIsb1EsjLEbS4T6x/Jy/BQiUQXQtorzq9E3m42J0929V8IzbhltMhDX2F19SBDhWr7IcTlWZCgL6k7iiBhKwRc7CIK9HFPsg1lpOORaPkkFE4+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from HK2APC01FT031.eop-APC01.prod.protection.outlook.com
 (10.152.248.55) by HK2APC01HT190.eop-APC01.prod.protection.outlook.com
 (10.152.249.134) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2474.17; Wed, 27 Nov
 2019 11:16:22 +0000
Received: from PSXP216MB0438.KORP216.PROD.OUTLOOK.COM (10.152.248.58) by
 HK2APC01FT031.mail.protection.outlook.com (10.152.248.189) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17 via Frontend Transport; Wed, 27 Nov 2019 11:16:22 +0000
Received: from PSXP216MB0438.KORP216.PROD.OUTLOOK.COM
 ([fe80::b880:961e:dd88:8b5d]) by PSXP216MB0438.KORP216.PROD.OUTLOOK.COM
 ([fe80::b880:961e:dd88:8b5d%12]) with mapi id 15.20.2474.023; Wed, 27 Nov
 2019 11:16:22 +0000
From:   Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>
To:     Alexander Lobakin <alobakin@dlink.ru>
CC:     Luciano Coelho <luciano.coelho@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Edward Cree <ecree@solarflare.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Petr Machata <petrm@mellanox.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Manish Chopra <manishc@marvell.com>,
        "GR-Linux-NIC-Dev@marvell.com" <GR-Linux-NIC-Dev@marvell.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "Kenneth R. Crudup" <kenny@panix.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: wireless: intel: iwlwifi: fix GRO_NORMAL packet
 stalling
Thread-Topic: [PATCH net] net: wireless: intel: iwlwifi: fix GRO_NORMAL packet
 stalling
Thread-Index: AQHVpQcZfcbrCchhyk2SRqQueNdPk6eeyGaAgAAD6wCAAAJz0IAAAiiAgAANJIA=
Date:   Wed, 27 Nov 2019 11:16:21 +0000
Message-ID: <PSXP216MB04382F0BA8CE3754439EA2CC80440@PSXP216MB0438.KORP216.PROD.OUTLOOK.COM>
References: <20191127094123.18161-1-alobakin@dlink.ru>
 <7a9332bf645fbb8c9fff634a3640c092fb9b4b79.camel@intel.com>
 <c571a88c15c4a70a61cde6ca270af033@dlink.ru>
 <PSXP216MB0438B2F163C635F8B8B4AD8AA4440@PSXP216MB0438.KORP216.PROD.OUTLOOK.COM>
 <a638ab877999dbc4ded87bfaebe784f5@dlink.ru>
In-Reply-To: <a638ab877999dbc4ded87bfaebe784f5@dlink.ru>
Accept-Language: en-AU, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SYXPR01CA0099.ausprd01.prod.outlook.com
 (2603:10c6:0:2e::32) To PSXP216MB0438.KORP216.PROD.OUTLOOK.COM
 (2603:1096:300:d::20)
x-incomingtopheadermarker: OriginalChecksum:C6DB9A6317ACAA90F47D1BA94C9309EF3042EEC82E89F1E0D73BAC2A624EDDE7;UpperCasedChecksum:8C13DBEDCDA7354A564DD10DEB3CA43BE0488C8EA45E7959D60D41BFE68C128D;SizeAsReceived:8492;Count:49
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [rhOQRpFCjyfMcAzn5x47wPCdcvPO+Pa+rizpBaWwjc8=]
x-microsoft-original-message-id: <20191127111559.GA3224@nicholas-usb>
x-ms-publictraffictype: Email
x-incomingheadercount: 49
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: af21f94b-fb61-40b0-e349-08d7732b3b63
x-ms-traffictypediagnostic: HK2APC01HT190:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9fw8QR1jF3m9gVRfAVPLoN92c1m0Mk5nIMhBV00wZofFDe66k+Mq8kRcDtpPkygGy6iOjXnl1PiTQddomAjF0t35qJDjz9DuzfY5fksJ5IvpbUJPzomalBVxHHEux7vNHq267tnoD5yt8fNAyVafUjQiGHD9wgMM9dtLEcC+H41s0etUMZM1dI5mZ9+P+ef6
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <AC2C6BF6C3B2AF4383C4140B9FBDE198@KORP216.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: af21f94b-fb61-40b0-e349-08d7732b3b63
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2019 11:16:21.9281
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK2APC01HT190
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCBOb3YgMjcsIDIwMTkgYXQgMDE6Mjk6MDNQTSArMDMwMCwgQWxleGFuZGVyIExvYmFr
aW4gd3JvdGU6DQo+IE5pY2hvbGFzIEpvaG5zb24gd3JvdGUgMjcuMTEuMjAxOSAxMzoyMzoNCj4g
PiBIaSwNCj4gDQo+IEhpIE5pY2hvbGFzLA0KPiANCj4gPiAgU29ycnkgZm9yIHRvcCBkb3duIHJl
cGx5LCBzdHVjayB3aXRoIG15IHBob25lLiBJZiBpdCByZXBsaWVzIEhUTUwNCj4gPiB0aGVuIEkg
YW0gc28gZG9uZSB3aXRoIE91dGxvb2sgY2xpZW50Lg0KDQpJIGFtIHZlcnkgc29ycnkgdG8gZXZl
cnlib2R5IGZvciB0aGUgaW1wcm9wZXIgcmVwbHkuIEl0IGxvb2tzIGxpa2UgaXQgDQp3YXMgSFRN
TCBhcyB2Z2VyLmtlcm5lbC5vcmcgdG9sZCBtZSBJIHdhcyBzcGFtLiBJZiBhbnlib2R5IGtub3dz
IGEgZ29vZCANCmVtYWlsIGNsaWVudCBmb3Iga2VybmVsIGRldmVsb3BtZW50IGZvciBBbmRyb2lk
IHRoZW4gSSBhbSBhbGwgZWFycy4NCg0KSSB3ZW50IGhvbWUgZWFybHkgYW5kIEkgaGF2ZSBteSBj
b21wdXRlcihzKSBub3cuDQoNCj4gPiANCj4gPiAgRG9lcyBteSBSZXBvcnRlZC1ieSB0YWcgYXBw
bHkgaGVyZT8NCj4gPiANCj4gPiAgQXMgdGhlIHJlcG9ydGVyLCBzaG91bGQgSSBjaGVjayB0byBz
ZWUgdGhhdCBpdCBpbmRlZWQgc29sdmVzIHRoZQ0KPiA+IGlzc3VlIG9uIHRoZSBvcmlnaW5hbCBo
YXJkd2FyZSBzZXR1cD8gSSBjYW4gZG8gdGhpcyB3aXRoaW4gdHdvIGhvdXJzDQo+ID4gYW5kIGdp
dmUgVGVzdGVkLWJ5IHRoZW4uDQo+IA0KPiBPb3BzLCBJJ20gc29ycnkgSSBmb3Jnb3QgdG8gbWVu
dGlvbiB5b3UgaW4gdGhlIGNvbW1pdCBtZXNzYWdlLiBMZXQncw0KPiBzZWUgd2hhdCBEYXZlIHdp
bGwgc2F5LCBJIGhhdmUgbm8gcHJvYmxlbXMgd2l0aCB3YWl0aW5nIGZvciB5b3VyIHRlc3QNCj4g
cmVzdWx0cyBhbmQgcHVibGlzaGluZyB2Mi4NCg0KQWxsIGdvb2QuIDopDQoNCkkgdGVzdGVkIHRo
ZSB0aGUgcGF0Y2ggYW5kIGl0IHdvcmtzIGZpbmUuIEdyZWF0IHdvcmssIHRoZSBmaXJzdCANCmh5
cG90aGVzaXMgYXMgdG8gd2hhdCB0aGUgcHJvYmxlbSB3YXMgaXMgY29ycmVjdC4gSXQgbm93IGNv
bm5lY3RzIHRvIA0Kd2lyZWxlc3MgbmV0d29ya3Mgd2l0aG91dCBhbnkgaGFzc2xlcy4NCg0KUmVw
b3J0ZWQtYnk6IE5pY2hvbGFzIEpvaG5zb24gPG5pY2hvbGFzLmpvaG5zb24tb3BlbnNvdXJjZUBv
dXRsb29rLmNvbS5hdT4NClRlc3RlZC1ieTogTmljaG9sYXMgSm9obnNvbiA8bmljaG9sYXMuam9o
bnNvbi1vcGVuc291cmNlQG91dGxvb2suY29tLmF1Pg0KDQpJIGRvIG5vdCB1bmRlcnN0YW5kIHRo
ZSBuZXR3b3JraW5nIHN1YnN5c3RlbSB3ZWxsIGVub3VnaCB0byBnaXZlIA0KUmV2aWV3ZWQtYnks
IHlldC4gSG9wZWZ1bGx5IGluIHRpbWUuDQoNClRoYW5rcyB0byBldmVyeWJvZHkgZm9yIGhhbmRs
aW5nIG15IHJlcG9ydC4NCg0KPiANCj4gPiAgVGhhbmtzDQo+ID4gDQo+ID4gIFJlZ2FyZHMsDQo+
ID4gDQo+ID4gIE5pY2hvbGFzDQo+IA0KPiBSZWdhcmRzLA0KPiDhmrcg4ZuWIOGaoiDhmqYg4Zqg
IOGasQ0KDQpSZWdhcmRzLA0KTmljaG9sYXMNCg==
