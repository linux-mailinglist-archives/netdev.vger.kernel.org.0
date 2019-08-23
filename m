Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA26E9A6E9
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 07:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391807AbfHWFGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 01:06:04 -0400
Received: from mail-eopbgr60089.outbound.protection.outlook.com ([40.107.6.89]:9026
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725613AbfHWFGE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 01:06:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MuwmZg+F+DuuUfkI9B3WPzZgnkWu2MWbEV56dadRy5hFBIdqF5WK3tE8+xYC+AhD7zoAcaQf9vUXOcA6eczi95pFCItGuWgiPQnJlmO8uRNU/yez4KVvB0GnDVbuHuCwl3sPCvWmBkduZuaG8Et9cHmFDI0u0FHRAa3U5MfWPfCG5D84YniUlnnT68xE+QF3VIYI5ERoNXL+B4jz3HJofCk6CYib8P27d686Yst0MREuV7AhWX31GWH3YMR++TsYNbr9IcwEyyl4UdXSgxTVZXGMU4QSS1MqR/bAvzDyLKuAJN0Vg6FhrIHNAz4+rTlvGg7H3/6WzidsFgB6MAvZ3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vFLvs6ANTVDUp946rlS0uh1fpeto0VHsz8UPYTqKK6E=;
 b=OlqMIha8i3XwCft5Y66RaPcBWArNsY4+dIFe95SfnYj+BbDgtx4tt0GGSkPiwPybywuWhcCTddV4+oQdSqAjGYMt+S+UwRRQfAtC0iEtUsUzbvFv9eU1p6DukO1ZGz44NZCdx1Rf/0g6e2oifocNFUBqTXuoIVUT6Ll03BGCrPpCQJbrzjzv33cQu5qoJ13q3lhTYvsOaJsrm5c9epvlJr8HPvSZxJDlKXT7cnD6eRS3/qhVfgZQtae6GOvWgR5e+cKjyU0ec+Dk2oZ2M/ID0LGueCMoF5I40dAKPcKBX/Jbpg4AxJSFG/qzoMh10TVjAMl56NKSat6rgveTq5n3Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vFLvs6ANTVDUp946rlS0uh1fpeto0VHsz8UPYTqKK6E=;
 b=c/1Tkm9V7PIZNj3zrwrEF4J4/eFIeDCyC2FxlP6b0+yfAlqy1JHr7UqwuGtn7WEyPkT0lZod0VEv2PcOTmNxDSte0BuidZG5AUyOWXVRdaZtJU6rljYtQ9fhQCHaCuXHrinSP64i4AiF+KGUxtK9S52lY+/mSuw7/GkRVjgo+yQ=
Received: from AM0PR0502MB4068.eurprd05.prod.outlook.com (52.133.38.142) by
 AM0PR0502MB4050.eurprd05.prod.outlook.com (52.133.37.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Fri, 23 Aug 2019 05:05:20 +0000
Received: from AM0PR0502MB4068.eurprd05.prod.outlook.com
 ([fe80::9d51:ae68:d177:fc94]) by AM0PR0502MB4068.eurprd05.prod.outlook.com
 ([fe80::9d51:ae68:d177:fc94%3]) with mapi id 15.20.2178.020; Fri, 23 Aug 2019
 05:05:20 +0000
From:   Eran Ben Elisha <eranbe@mellanox.com>
To:     haiyangz <haiyangz@microsoft.com>,
        David Miller <davem@davemloft.net>
CC:     "sashal@kernel.org" <sashal@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kys <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next,v5, 0/6] Add software backchannel and mlx5e HV
 VHCA stats
Thread-Topic: [PATCH net-next,v5, 0/6] Add software backchannel and mlx5e HV
 VHCA stats
Thread-Index: AQHVWTieJNg4lNlPokigzqQxpEz7DacHwLuAgAAAK6CAAAF/AIAAAF1ggABrKYA=
Date:   Fri, 23 Aug 2019 05:05:20 +0000
Message-ID: <1179f6f7-9e58-c601-1319-52be4182e0db@mellanox.com>
References: <1566512708-13785-1-git-send-email-haiyangz@microsoft.com>
 <20190822.153315.1245817410062415025.davem@davemloft.net>
 <DM6PR21MB133743FB2006A28AE10A170CCAA50@DM6PR21MB1337.namprd21.prod.outlook.com>
 <20190822.153912.2269276523787180347.davem@davemloft.net>
 <DM6PR21MB133778F0890449A5D58DD9D5CAA50@DM6PR21MB1337.namprd21.prod.outlook.com>
In-Reply-To: <DM6PR21MB133778F0890449A5D58DD9D5CAA50@DM6PR21MB1337.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0090.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:18::30) To AM0PR0502MB4068.eurprd05.prod.outlook.com
 (2603:10a6:208:d::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=eranbe@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [77.126.5.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9c7688ce-78c2-4e64-18e2-08d727877f04
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM0PR0502MB4050;
x-ms-traffictypediagnostic: AM0PR0502MB4050:
x-ld-processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR0502MB4050BD31EB49C483CD91B852BAA40@AM0PR0502MB4050.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 0138CD935C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(366004)(39850400004)(346002)(376002)(199004)(189003)(13464003)(316002)(2906002)(6486002)(102836004)(64756008)(66446008)(26005)(66476007)(66946007)(305945005)(25786009)(71190400001)(81166006)(81156014)(52116002)(478600001)(229853002)(71200400001)(110136005)(8936002)(99286004)(6506007)(386003)(6246003)(7736002)(7416002)(4326008)(6512007)(53546011)(14444005)(8676002)(256004)(36756003)(76176011)(11346002)(446003)(66066001)(2616005)(53936002)(54906003)(86362001)(1511001)(486006)(5660300002)(6116002)(186003)(3846002)(476003)(14454004)(31696002)(31686004)(6436002)(66556008)(42413003)(142933001)(32563001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR0502MB4050;H:AM0PR0502MB4068.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: umwJwdbRmpRJaJ9vDR/o9VVvmDiIpnfikDWhHdUfbkVPzAPgUHpP+ejWEBRwN4ABop7u0osmBvJZD7qs7aei/aUwzbVjJtaokP8evtEnuRpRPxoyQEgb5hEHMWKNUmNWh+aScBbPL80gkhz6cGjBoqV9qvCeULOMKdaMnb2RiCshDblSFc3pKFVW/3N36RkvdhER5LSHGJIhEIYWp2Yvra48s6ShLgSyiVgcsK3+qaHFO4po7eEBIB0V7PbaJNLM9Jm5lyt0NKXQ7vqqV2JgMausgIXO4lTpskj1NLqjUfIfsMb6jUFAUVVV0s07T7oIShYdmC5gPpo7ieyIM2cjZVs2470I+6Xc5CDIM4vET1R71yCcLyK8guef9tJQvoqqkMqPHQ89SJlRMX6GmLGrlELfiI3gjjl913j3FX4izu4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C24F5E41B18E3D468A0AF8B2D0A9CF05@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c7688ce-78c2-4e64-18e2-08d727877f04
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Aug 2019 05:05:20.3298
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gO6QCNpmBmzr8drzXOOBu8RJ3buv/dQCt5dOs4i5qFZAqK9I0oHK0bTJ66TXiy1GOYgXIuO6lRuGbyK0OoQuOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB4050
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDgvMjMvMjAxOSAxOjQzIEFNLCBIYWl5YW5nIFpoYW5nIHdyb3RlOg0KPiANCj4gDQo+
PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPj4gRnJvbTogRGF2aWQgTWlsbGVyIDxkYXZl
bUBkYXZlbWxvZnQubmV0Pg0KPj4gU2VudDogVGh1cnNkYXksIEF1Z3VzdCAyMiwgMjAxOSAzOjM5
IFBNDQo+PiBUbzogSGFpeWFuZyBaaGFuZyA8aGFpeWFuZ3pAbWljcm9zb2Z0LmNvbT4NCj4+IENj
OiBzYXNoYWxAa2VybmVsLm9yZzsgc2FlZWRtQG1lbGxhbm94LmNvbTsgbGVvbkBrZXJuZWwub3Jn
Ow0KPj4gZXJhbmJlQG1lbGxhbm94LmNvbTsgbG9yZW56by5waWVyYWxpc2lAYXJtLmNvbTsgYmhl
bGdhYXNAZ29vZ2xlLmNvbTsNCj4+IGxpbnV4LXBjaUB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWh5
cGVydkB2Z2VyLmtlcm5lbC5vcmc7DQo+PiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBLWSBTcmlu
aXZhc2FuIDxreXNAbWljcm9zb2Z0LmNvbT47IFN0ZXBoZW4NCj4+IEhlbW1pbmdlciA8c3RoZW1t
aW5AbWljcm9zb2Z0LmNvbT47IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4+IFN1Ympl
Y3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQsdjUsIDAvNl0gQWRkIHNvZnR3YXJlIGJhY2tjaGFubmVs
IGFuZCBtbHg1ZQ0KPj4gSFYgVkhDQSBzdGF0cw0KPj4NCj4+IEZyb206IEhhaXlhbmcgWmhhbmcg
PGhhaXlhbmd6QG1pY3Jvc29mdC5jb20+DQo+PiBEYXRlOiBUaHUsIDIyIEF1ZyAyMDE5IDIyOjM3
OjEzICswMDAwDQo+Pg0KPj4+IFRoZSB2NSBpcyBwcmV0dHkgbXVjaCB0aGUgc2FtZSBhcyB2NCwg
ZXhjZXB0IEVyYW4gaGFkIGEgZml4IHRvIHBhdGNoICMzIGluDQo+PiByZXNwb25zZSB0bw0KPj4+
IExlb24gUm9tYW5vdnNreSA8bGVvbkBrZXJuZWwub3JnPi4NCj4+DQo+PiBXZWxsIHlvdSBub3cg
aGF2ZSB0byBzZW5kIG1lIGEgcGF0Y2ggcmVsYXRpdmUgdG8gdjQgaW4gb3JkZXIgdG8gZml4IHRo
YXQuDQo+Pg0KPj4gV2hlbiBJIHNheSAiYXBwbGllZCIsIHRoZSBzZXJpZXMgaXMgaW4gbXkgdHJl
ZSBhbmQgaXMgdGhlcmVmb3JlIHBlcm1hbmVudC4NCj4+IEl0IGlzIHRoZXJlZm9yZSBuZXZlciBh
cHByb3ByaWF0ZSB0byB0aGVuIHBvc3QgYSBuZXcgdmVyc2lvbiBvZiB0aGUgc2VyaWVzLg0KPiAN
Cj4gVGhhbmtzLg0KPiANCj4gRXJhbiwgY291bGQgeW91IHN1Ym1pdCBhbm90aGVyIHBhdGNoIGZv
ciB0aGUgZml4IHRvIHBhdGNoICMzPw0KDQpTdXJlLCB3aWxsIHByZXBhcmUgYW5kIHNlbmQgbGF0
ZXIgdG9kYXkuDQoNCj4gDQo+IC0gSGFpeWFuZw0KPiANCg==
