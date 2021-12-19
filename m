Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F45647A262
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 22:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235403AbhLSVnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 16:43:25 -0500
Received: from mail-vi1eur05on2133.outbound.protection.outlook.com ([40.107.21.133]:47270
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231821AbhLSVnY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Dec 2021 16:43:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mHyxN1aiamgI0rU1YtPgBdZ2nUCGxXCVkfgYGEutgnqS1RL3hvKK+YlVpUovQSqk7w9tevvou4K3kSXhm0s2PVkBMJeK9ve4v2LI/b6X9CP5Dko0q81ixLoWX+enKi3HC6mhvhVfmP2klf42RfU57lA+0E3SiXjaoxwSsRD9ONLh9P7kIx0TISEsna6SV77vvIjTbAdmqYCGnK4GbmC6gxzzUiPDiVr92WXeDS9jFPHn3dxdVREelHSzCnFs0Qhs4nkLsLBmg0YfrBQJUu6fn+OFsQaRcdMTqmmHGLsjGp3IYbplEbImNYiWDgwpWzL0+0QcqlGR+EhdgTyfD1Drow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tv70xamzuVoCm4x5JRfxXP69F2r3Hxa5/Umf7Zonlzs=;
 b=k2gO/DdcUtwbcumiPczpyaU84Tsk9AFRWFz+e7OrfwJ9jEJWIVe3tmcuxBktEn931eTNjbv2/SF2lO+rbisnb+4lKrqIIrqrHRYRb5ve3pmJECK/4ctWlwpqiTIz3DVhU9W/MsAuWn6xzmevA9hc3xTYwiYJk4thSYVA6QcFVZmG4RjLdQTr5fRJexcG7sp2s+CRRX9tq1FWVggGIikCW8wB11UKoxlFMjTBJG+b0vWTQfiGOIiXnY9T/S4mEeG2Xl56wZ8NoQGcfXC4I8wqXEY/8RyElGfaPG4SZFmns2RcoU2iQ7WsgkbZXYMHWbNfc2NeVk7dB4hHGDpr2acbRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tv70xamzuVoCm4x5JRfxXP69F2r3Hxa5/Umf7Zonlzs=;
 b=iirao+/g+snJkQ2q9YC7exTP/SakCuO2l1NCIWTkQJ/RMqlxYZiU7JS4g35bcyvgexCikd3xCclFeZ7Vt5RM57M2dEDxxCLz28AXHe2kYON+TLs6HeZhh+vN87B+kW7hSUKX7FCDgNVzsBG/YZDvZQ7Xh0ixxuL1n2dh6ZTyfbQ=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AM6PR03MB5992.eurprd03.prod.outlook.com (2603:10a6:20b:e2::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.15; Sun, 19 Dec
 2021 21:43:22 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::dd50:b902:a4d:312f]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::dd50:b902:a4d:312f%5]) with mapi id 15.20.4801.020; Sun, 19 Dec 2021
 21:43:21 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next v2 12/13] net: dsa: realtek: rtl8365mb: add
 RTL8367S support
Thread-Topic: [PATCH net-next v2 12/13] net: dsa: realtek: rtl8365mb: add
 RTL8367S support
Thread-Index: AQHX8+dspq7JD1z7+kOzLBESF5L1Daw6WxIA
Date:   Sun, 19 Dec 2021 21:43:21 +0000
Message-ID: <c4f4aef5-aeb5-047b-d3e1-78e7b4c2c968@bang-olufsen.dk>
References: <20211216201342.25587-1-luizluca@gmail.com>
 <20211218081425.18722-1-luizluca@gmail.com>
 <20211218081425.18722-13-luizluca@gmail.com>
In-Reply-To: <20211218081425.18722-13-luizluca@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b72e38d1-ad01-4851-3df6-08d9c3389417
x-ms-traffictypediagnostic: AM6PR03MB5992:EE_
x-microsoft-antispam-prvs: <AM6PR03MB59923388085E4DB582689DAF837A9@AM6PR03MB5992.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sJlf+2U3iHM1FuuDgwtJ988pldlbBlneySVEWrFzNHz1za/8f2P0/bd4pQvMu+VKHYUyheB+va6vDlnZiTicfKbXgNBW+6dZAomPMLZ88DOWzHNtJoCwEodcXtwSBIlhQU6TP/Otihq2phjSiUOxkYmJdB/bcP88nJdDozCQwgk5c8nF3h7+/f2Fl/cpZ5RKsm+yo+FOkpGiHE+WgJB8kMJ8O/5EpbvVF4DaEmGVC+YjO/hKeqL6spEXOzAAKlP8X8woUnEPNtDaC3eXklkckvOYKT8svz6G1c41rT6LxWIxa/dLA+gqaimMQnNBnCZiXw++ZbHGiHYXS8FARlEeKvLTqE5t3oZwW+e+mvnJX8hvc4E1uOdV3PnnBlF2jMNbmMCyYcaZ5G4Z2M5pWIbwWVT9g3zDD4RhM+Y6ss4uD5sEQOs3AojaJfkEEidpKTP1dukfO+U3zzLZbPBphpJGyE5XSfrdXE1vSOxfBBQ5wYfkDWeD78KY+arAe6eDaDw/AjGXuRbEwr3FD5BinQHyeBGdhj1SQoJcMeqkgse6FBngu6qIrkVFa/d/Tm70+8M4CNf6AzZ5naYp8Wl2/UgjkvR0rkHVN7mmXxIOu6jew2QWJnwcgdR+Sg57Zi7FR9pf52ECPeb1mAQBg8CossVWOZHxrbVRCWzSDGibZcixzVTkAJlv7JgmuKIu8x+2t/nJlXotBgFY+ZQblPvC9iNvmy7pNhgY4fNY1sJ2wk51xunnL52ok8LRjtIo79iu3b4GKWpQtaqYlfVf3od93CmEdw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(26005)(36756003)(5660300002)(6486002)(66476007)(66556008)(83380400001)(66446008)(64756008)(2616005)(53546011)(8976002)(8936002)(6506007)(8676002)(110136005)(66574015)(85182001)(54906003)(316002)(38100700002)(122000001)(31696002)(2906002)(71200400001)(38070700005)(4326008)(508600001)(31686004)(85202003)(76116006)(66946007)(91956017)(86362001)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Nk1acVRvbk42UWFnaUNjLzIvTWw1NHNFMmVCQTJ4UkVKZ2JjSEw0UFExVW1n?=
 =?utf-8?B?TFFvRE5WR0FFWkhoT1JjaTBJZnU0enBhYUhIZkhCZkFNNUJDUncydDhnWVlZ?=
 =?utf-8?B?NWxXd1pOSHFHUXdVMjZYVzByd01qT1I4ckRnMmRqb244b2c0R1dPWHBoSXha?=
 =?utf-8?B?SVNZN0JqaHZTK3ZsS1YzcS9TU0EvNnFXREJxZkFFOFNoT2ZYSGt2cWpSdkdJ?=
 =?utf-8?B?NTJsYkk0SUlTZEVWWkMzQnlrdUlsaUZTRXVNQWxlQnNTbms0VXNiMUd1U0lU?=
 =?utf-8?B?WXZTdm01TnRocjlldlRUK3dhYnpRaldwaFF0RjdyekhJTFJqaVZuNEJ0aC8y?=
 =?utf-8?B?M2tmQ0dOY3JNKzV4MTlxVVRMajA3THdLTnFlRXRFTFdvS2NwRHc4cWFlWXZm?=
 =?utf-8?B?bkR2Sy9Td1haM1NZYTFOb2xzUUNXNnFaWlZhaDdzQkU0cmZjS3pLRmVScy9y?=
 =?utf-8?B?OVVaNFRRVi9FVzdyeDFWOWk5U0tnRm1ONThwUnFmVEtVOE43ZkxNR1VCbTEx?=
 =?utf-8?B?SHo4RXF6NVlnamFmL3dqUXc1TzVGOWZKRGFKV0diVlNSZmVXQmNla3JnMnZC?=
 =?utf-8?B?R0s1QjdmV0NrbG85L0NGUGxpTWVNNGhORGNGaytLQ0szZ0lXREtCcG5QZjVq?=
 =?utf-8?B?c1FiOWRQeG9ML1RCVElyMXRRdHVudWZFY2phcElYQTJoZ21UWVNxRnlVYjVQ?=
 =?utf-8?B?MWJFNktoQU5TMVlWS0tKdnAwL3RVclU1c2xUUUx2aFhGTWNnb2pPZHE4TVRt?=
 =?utf-8?B?djYrSkwrcitVQmNFSDVFaVhoendldjh4YytUSTVPcWF5VTZWbUJPWjYvcTdD?=
 =?utf-8?B?OENyN1NMcHVHNW1hMUVRR3JENXYwVkY5R2QxSXg0Vjc5ZURNcjJNeTNxa3VJ?=
 =?utf-8?B?eitVTk15T2xYeVRoVXJvNjBld3FpVEMzengwMHFCaFBtc3pRdFdIQjcwRUh5?=
 =?utf-8?B?V2NnT3BaeUMvT0hnZmRGd2tnWExhVXFhaC91aU8zS2tyS0luK2l0cG1OenE1?=
 =?utf-8?B?UGc3Zm1BY0JQc1Zzb2o1S3lFb0h1a3UxWEJHalBrT21SOHlaaW5CR2VudjVN?=
 =?utf-8?B?QU5EdjFYalBXUFJkU2RmL24rVkYwRDlsaGNBdFlCdHFsekVHMXJoeDE0VHMv?=
 =?utf-8?B?QUd1bkJCMVYrRERRcnFtYUVsY3czNzUrUGorbENBSHBLeEF2T1dpSjlIdEJy?=
 =?utf-8?B?L21aZ25ndWZvUFh1UDlXSytTc1U4TUpsTFVERmYxakFQSXI3elkxaXhBbVNW?=
 =?utf-8?B?RnNHSzc5L2FvS2gxM3dFazRVWDRiVGpoajU3ZjJDZ0N3S0xsZTRxMnpyR0c2?=
 =?utf-8?B?YkFsRjZxNHNaekJRMktjb3lVYkZzcGVFQmR4UUZERE5kRWxYMCtjRXAwclBI?=
 =?utf-8?B?MzdWWk9PamhuS1JlZUdBbzhQZzNIOWFmUEd6d0tSZDlYbEYvV2lSOVoxYkwy?=
 =?utf-8?B?WG5UVGVOK3oxTEZ0dmlUQzkyWFhtYVc3UmFzS1pkb1k2OUZ4aHZBRjFURWpP?=
 =?utf-8?B?eExGalZNK2hzVnprZ0E3T0ZTVzVIbDFINnFHei9CaXRXV25SWEhzWlZWMnBN?=
 =?utf-8?B?UXhra24yb3JVZ3lZQ1B6bmlsTFlLNlU2T3hNQnVFMmQwdTU5Y1RuaGY3RzNQ?=
 =?utf-8?B?QVBueDFDcDVZc0FoK0wyTTRndW51WDBNZ3hFMzZSejFUaXg5cUNhbEVnWWhz?=
 =?utf-8?B?Z3NBTW5RK1J6dDFtczZaR0Fkck82RVhIK3BORGo5ME56ekhBMmg2eDlkUTl1?=
 =?utf-8?B?NUlRMXJpWW12a1ZSK1JGN0VXa0dNNC9RbERYYXlkUnBQUVRtN3ZlSkRxa2ZR?=
 =?utf-8?B?ZHVxL0htdXM0SXdyUzZTb0t2ODVlUERuUnRxM0orVTh6bWg0NHJJV2lWRTIx?=
 =?utf-8?B?eElsdmhjSllRVHgvMDZHMXpuYlhzaG5XbTlsR1pqNEtrL0tkTTZOeXEzVWlW?=
 =?utf-8?B?RWFjN0hINElSNDBFV1U3SWI3V3dyeHVQMk5XcVhzTzZzR0lDOGZMTWx5UVM0?=
 =?utf-8?B?WndFdlNqSzU1NXpscjc3NHRDUUVkTlJPYmMvRHBXN1ZsZytuc1FCcG5NdExw?=
 =?utf-8?B?NmE0S0FyVWFORW5QYVhmbDU4OVB2bVR4bklNUmtsSlMvbWkzQ3Yxa3p1MWJs?=
 =?utf-8?B?R0JWb2xNUkEzb2Fram54K2l4clRpSS95WnVQNjdJUXZzZ3VJWmlSYzZ3cVhP?=
 =?utf-8?Q?lLuNqeOUVO+/dCf6wNCAFHMYJ8Q+HWvWRtBlxjgAN4UK?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E8ED78E227ED3E4285A44B6FD5A44979@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b72e38d1-ad01-4851-3df6-08d9c3389417
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2021 21:43:21.8678
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vBe/u0cNFDPRwFlxhwVPdhmO2n0sxYhV44HrYO/TY9zJwBexyFtTJb98lGddcv4702URR5WCv0D1biYMaeH+ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB5992
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTIvMTgvMjEgMDk6MTQsIEx1aXogQW5nZWxvIERhcm9zIGRlIEx1Y2Egd3JvdGU6DQo+IFJl
YWx0ZWsncyBSVEw4MzY3UywgYSA1KzIgcG9ydCAxMC8xMDAvMTAwME0gRXRoZXJuZXQgc3dpdGNo
Lg0KPiBJdCBzaGFyZXMgdGhlIHNhbWUgZHJpdmVyIGZhbWlseSAoUlRMODM2N0MpIHdpdGggb3Ro
ZXIgbW9kZWxzDQo+IGFzIHRoZSBSVEw4MzY1TUItVkMuIEl0cyBjb21wYXRpYmxlIHN0cmluZyBp
cyAicmVhbHRlayxydGw4MzY3cyIuDQo+IA0KPiBJdCB3YXMgdGVzdGVkIG9ubHkgd2l0aCBNRElP
IGludGVyZmFjZSAocmVhbHRlay1tZGlvKSwgYWx0aG91Z2ggaXQgbWlnaHQNCj4gd29yayBvdXQt
b2YtdGhlLWJveCB3aXRoIFNNSSBpbnRlcmZhY2UgKHVzaW5nIHJlYWx0ZWstc21pKS4NCj4gDQo+
IFRoaXMgcGF0Y2ggd2FzIGJhc2VkIG9uIGFuIHVucHVibGlzaGVkIHBhdGNoIGZyb20gQWx2aW4g
xaBpcHJhZ2ENCj4gPGFsc2lAYmFuZy1vbHVmc2VuLmRrPi4NCj4gDQo+IFRlc3RlZC1ieTogQXLE
sW7DpyDDnE5BTCA8YXJpbmMudW5hbEBhcmluYzkuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBMdWl6
IEFuZ2VsbyBEYXJvcyBkZSBMdWNhIDxsdWl6bHVjYUBnbWFpbC5jb20+DQo+IC0tLQ0KPiAgIGRy
aXZlcnMvbmV0L2RzYS9yZWFsdGVrL0tjb25maWcgICAgICAgIHwgIDUgKysrKy0NCj4gICBkcml2
ZXJzL25ldC9kc2EvcmVhbHRlay9yZWFsdGVrLW1kaW8uYyB8ICAxICsNCj4gICBkcml2ZXJzL25l
dC9kc2EvcmVhbHRlay9yZWFsdGVrLXNtaS5jICB8ICA0ICsrKysNCj4gICBkcml2ZXJzL25ldC9k
c2EvcmVhbHRlay9ydGw4MzY1bWIuYyAgICB8IDMxICsrKysrKysrKysrKysrKysrKysrKy0tLS0t
DQo+ICAgNCBmaWxlcyBjaGFuZ2VkLCAzNCBpbnNlcnRpb25zKCspLCA3IGRlbGV0aW9ucygtKQ0K
PiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2RzYS9yZWFsdGVrL0tjb25maWcgYi9kcml2
ZXJzL25ldC9kc2EvcmVhbHRlay9LY29uZmlnDQo+IGluZGV4IDczYjI2MTcxZmFkZS4uMTY1MjE1
MDBhODg4IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9kc2EvcmVhbHRlay9LY29uZmlnDQo+
ICsrKyBiL2RyaXZlcnMvbmV0L2RzYS9yZWFsdGVrL0tjb25maWcNCj4gQEAgLTMxLDcgKzMxLDEw
IEBAIGNvbmZpZyBORVRfRFNBX1JFQUxURUtfUlRMODM2NU1CDQo+ICAgCWRlcGVuZHMgb24gTkVU
X0RTQV9SRUFMVEVLX1NNSSB8fCBORVRfRFNBX1JFQUxURUtfTURJTw0KPiAgIAlzZWxlY3QgTkVU
X0RTQV9UQUdfUlRMOF80DQo+ICAgCWhlbHANCj4gLQkgIFNlbGVjdCB0byBlbmFibGUgc3VwcG9y
dCBmb3IgUmVhbHRlayBSVEw4MzY1TUINCj4gKwkgIFNlbGVjdCB0byBlbmFibGUgc3VwcG9ydCBm
b3IgUmVhbHRlayBSVEw4MzY1TUItVkMgYW5kIFJUTDgzNjdTLiBUaGlzIHN1YmRyaXZlcg0KPiAr
CSAgbWlnaHQgYWxzbyBzdXBwb3J0IFJUTDgzNjNOQiwgUlRMODM2M05CLVZCLCBSVEw4MzYzU0Ms
IFJUTDgzNjNTQy1WQiwgUlRMODM2NE5CLA0KPiArCSAgUlRMODM2NE5CLVZCLCBSVEw4MzY2U0Ms
IFJUTDgzNjdSQi1WQiwgUlRMODM2N1NCLCBSVEw4MzcwTUIsIFJUTDgzMTBTUg0KPiArCSAgaW4g
dGhlIGZ1dHVyZS4NCg0KTm90IHN1cmUgaG93IHVzZWZ1bCB0aGlzIG1hcmtldGluZyBpcyB3aGVu
IEkgYW0gY29uZmlndXJpbmcgbXkga2VybmVsLg0KDQo+ICAgDQo+ICAgY29uZmlnIE5FVF9EU0Ff
UkVBTFRFS19SVEw4MzY2UkINCj4gICAJdHJpc3RhdGUgIlJlYWx0ZWsgUlRMODM2NlJCIHN3aXRj
aCBzdWJkcml2ZXIiDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9kc2EvcmVhbHRlay9yZWFs
dGVrLW1kaW8uYyBiL2RyaXZlcnMvbmV0L2RzYS9yZWFsdGVrL3JlYWx0ZWstbWRpby5jDQo+IGlu
ZGV4IDA4ZDEzYmI5NGQ5MS4uMGFjYjk1MTQyYjdlIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25l
dC9kc2EvcmVhbHRlay9yZWFsdGVrLW1kaW8uYw0KPiArKysgYi9kcml2ZXJzL25ldC9kc2EvcmVh
bHRlay9yZWFsdGVrLW1kaW8uYw0KPiBAQCAtMjQ4LDYgKzI0OCw3IEBAIHN0YXRpYyBjb25zdCBz
dHJ1Y3Qgb2ZfZGV2aWNlX2lkIHJlYWx0ZWtfbWRpb19vZl9tYXRjaFtdID0gew0KPiAgIAl7IC5j
b21wYXRpYmxlID0gInJlYWx0ZWsscnRsODM2NnMiLCAuZGF0YSA9IE5VTEwsIH0sDQo+ICAgI2lm
IElTX0VOQUJMRUQoQ09ORklHX05FVF9EU0FfUkVBTFRFS19SVEw4MzY1TUIpDQo+ICAgCXsgLmNv
bXBhdGlibGUgPSAicmVhbHRlayxydGw4MzY1bWIiLCAuZGF0YSA9ICZydGw4MzY1bWJfdmFyaWFu
dCwgfSwNCj4gKwl7IC5jb21wYXRpYmxlID0gInJlYWx0ZWsscnRsODM2N3MiLCAuZGF0YSA9ICZy
dGw4MzY1bWJfdmFyaWFudCwgfSwNCj4gICAjZW5kaWYNCj4gICAJeyAvKiBzZW50aW5lbCAqLyB9
LA0KPiAgIH07DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9kc2EvcmVhbHRlay9yZWFsdGVr
LXNtaS5jIGIvZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWsvcmVhbHRlay1zbWkuYw0KPiBpbmRleCAz
MjY5MGJkMjgxMjguLjBmYzA5NmIzNTVjNSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZHNh
L3JlYWx0ZWsvcmVhbHRlay1zbWkuYw0KPiArKysgYi9kcml2ZXJzL25ldC9kc2EvcmVhbHRlay9y
ZWFsdGVrLXNtaS5jDQo+IEBAIC01MTEsNiArNTExLDEwIEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3Qg
b2ZfZGV2aWNlX2lkIHJlYWx0ZWtfc21pX29mX21hdGNoW10gPSB7DQo+ICAgCQkuY29tcGF0aWJs
ZSA9ICJyZWFsdGVrLHJ0bDgzNjVtYiIsDQo+ICAgCQkuZGF0YSA9ICZydGw4MzY1bWJfdmFyaWFu
dCwNCj4gICAJfSwNCj4gKwl7DQo+ICsJCS5jb21wYXRpYmxlID0gInJlYWx0ZWsscnRsODM2N3Mi
LA0KPiArCQkuZGF0YSA9ICZydGw4MzY1bWJfdmFyaWFudCwNCj4gKwl9LA0KPiAgICNlbmRpZg0K
PiAgIAl7IC8qIHNlbnRpbmVsICovIH0sDQo+ICAgfTsNCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bmV0L2RzYS9yZWFsdGVrL3J0bDgzNjVtYi5jIGIvZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWsvcnRs
ODM2NW1iLmMNCj4gaW5kZXggYjc5YTQ2MzliMjgzLi5lNThkZDRkMWU3YjggMTAwNjQ0DQo+IC0t
LSBhL2RyaXZlcnMvbmV0L2RzYS9yZWFsdGVrL3J0bDgzNjVtYi5jDQo+ICsrKyBiL2RyaXZlcnMv
bmV0L2RzYS9yZWFsdGVrL3J0bDgzNjVtYi5jDQo+IEBAIC0xMDMsMTMgKzEwMywxOSBAQA0KPiAg
IA0KPiAgIC8qIENoaXAtc3BlY2lmaWMgZGF0YSBhbmQgbGltaXRzICovDQo+ICAgI2RlZmluZSBS
VEw4MzY1TUJfQ0hJUF9JRF84MzY1TUJfVkMJCTB4NjM2Nw0KPiAtI2RlZmluZSBSVEw4MzY1TUJf
TEVBUk5fTElNSVRfTUFYXzgzNjVNQl9WQwkyMTEyDQoNClRoZSBsZWFybiBsaW1pdCBhY3R1YWxs
eSBzZWVtcyB0byBiZSBjaGlwLXNwZWNpZmljIGFuZCBub3QgZmFtaWx5IA0Kc3BlY2lmaWMsIHRo
YXQncyB3aHkgSSBwbGFjZWQgaXQgaGVyZSB0byBiZWdpbiB3aXRoLiBGb3IgZXhhbXBsZSwgDQpz
b21ldGhpbmcgY2FsbGVkIFJUTDgzNzBCIGhhcyBhIGxpbWl0IG9mIDQxNjAuLi4NCg0KPiArI2Rl
ZmluZSBSVEw4MzY1TUJfQ0hJUF9WRVJfODM2NU1CX1ZDCQkweDAwNDANCj4gKw0KPiArI2RlZmlu
ZSBSVEw4MzY1TUJfQ0hJUF9JRF84MzY3UwkJCTB4NjM2Nw0KPiArI2RlZmluZSBSVEw4MzY1TUJf
Q0hJUF9WRVJfODM2N1MJCTB4MDBBMA0KPiArDQo+ICsjZGVmaW5lIFJUTDgzNjVNQl9MRUFSTl9M
SU1JVF9NQVgJCTIxMTINCg0KQnV0IGFueXdheXMsIGlmIHlvdSBhcmUgZ29pbmcgdG8gbWFrZSBp
dCBmYW1pbHktc3BlY2lmaWMgcmF0aGVyIHRoYW4gDQpjaGlwLXNwZWNpZmljLCBwbGFjZSBpdCAu
Li4NCg0KPiAgIA0KPiAgIC8qIEZhbWlseS1zcGVjaWZpYyBkYXRhIGFuZCBsaW1pdHMgKi8NCg0K
Li4uIHNvbWV3aGVyZSB1bmRlciBoZXJlLg0KDQo+ICAgI2RlZmluZSBSVEw4MzY1TUJfUEhZQURE
Uk1BWAk3DQo+ICAgI2RlZmluZSBSVEw4MzY1TUJfTlVNX1BIWVJFR1MJMzINCj4gICAjZGVmaW5l
IFJUTDgzNjVNQl9QSFlSRUdNQVgJKFJUTDgzNjVNQl9OVU1fUEhZUkVHUyAtIDEpDQo+IC0jZGVm
aW5lIFJUTDgzNjVNQl9NQVhfTlVNX1BPUlRTICA3DQo+ICsvLyBSVEw4MzcwTUIgYW5kIFJUTDgz
MTBTUiwgcG9zc2libHkgc3Vwb3J0YWJsZSBieSB0aGlzIGRyaXZlciwgaGF2ZSAxMCBwb3J0cw0K
DQpDIHN0eWxlIGNvbW1lbnRzIDotKQ0KDQo+ICsjZGVmaW5lIFJUTDgzNjVNQl9NQVhfTlVNX1BP
UlRTCQkxMA0KDQpEaWQgeW91IG1lc3MgdXAgdGhlIGluZGVudGF0aW9uIGhlcmU/IEFsc28gc2Vl
bXMgdW5yZWxhdGVkIHRvIFJUTDgzNjdTIA0Kc3VwcG9ydC4uLg0KDQo+ICAgDQo+ICAgLyogQ2hp
cCBpZGVudGlmaWNhdGlvbiByZWdpc3RlcnMgKi8NCj4gICAjZGVmaW5lIFJUTDgzNjVNQl9DSElQ
X0lEX1JFRwkJMHgxMzAwDQo+IEBAIC0xOTY0LDkgKzE5NzAsMjIgQEAgc3RhdGljIGludCBydGw4
MzY1bWJfZGV0ZWN0KHN0cnVjdCByZWFsdGVrX3ByaXYgKnByaXYpDQo+ICAgDQo+ICAgCXN3aXRj
aCAoY2hpcF9pZCkgew0KPiAgIAljYXNlIFJUTDgzNjVNQl9DSElQX0lEXzgzNjVNQl9WQzoNCj4g
LQkJZGV2X2luZm8ocHJpdi0+ZGV2LA0KPiAtCQkJICJmb3VuZCBhbiBSVEw4MzY1TUItVkMgc3dp
dGNoICh2ZXI9MHglMDR4KVxuIiwNCj4gLQkJCSBjaGlwX3Zlcik7DQo+ICsJCXN3aXRjaCAoY2hp
cF92ZXIpIHsNCj4gKwkJY2FzZSBSVEw4MzY1TUJfQ0hJUF9WRVJfODM2NU1CX1ZDOg0KPiArCQkJ
ZGV2X2luZm8ocHJpdi0+ZGV2LA0KPiArCQkJCSAiZm91bmQgYW4gUlRMODM2NU1CLVZDIHN3aXRj
aCAodmVyPTB4JTA0eClcbiIsDQo+ICsJCQkJIGNoaXBfdmVyKTsNCj4gKwkJCWJyZWFrOw0KPiAr
CQljYXNlIFJUTDgzNjVNQl9DSElQX1ZFUl84MzY3UzoNCj4gKwkJCWRldl9pbmZvKHByaXYtPmRl
diwNCj4gKwkJCQkgImZvdW5kIGFuIFJUTDgzNjdTIHN3aXRjaCAodmVyPTB4JTA0eClcbiIsDQo+
ICsJCQkJIGNoaXBfdmVyKTsNCj4gKwkJCWJyZWFrOw0KPiArCQlkZWZhdWx0Og0KPiArCQkJZGV2
X2Vycihwcml2LT5kZXYsICJ1bnJlY29nbml6ZWQgc3dpdGNoIHZlcnNpb24gKHZlcj0weCUwNHgp
IiwNCj4gKwkJCQljaGlwX3Zlcik7DQo+ICsJCQlyZXR1cm4gLUVOT0RFVjsNCj4gKwkJfQ0KPiAg
IA0KPiAgIAkJcHJpdi0+bnVtX3BvcnRzID0gUlRMODM2NU1CX01BWF9OVU1fUE9SVFM7DQo+ICAg
DQo+IEBAIC0xOTc0LDcgKzE5OTMsNyBAQCBzdGF0aWMgaW50IHJ0bDgzNjVtYl9kZXRlY3Qoc3Ry
dWN0IHJlYWx0ZWtfcHJpdiAqcHJpdikNCj4gICAJCW1iLT5jaGlwX2lkID0gY2hpcF9pZDsNCj4g
ICAJCW1iLT5jaGlwX3ZlciA9IGNoaXBfdmVyOw0KPiAgIAkJbWItPnBvcnRfbWFzayA9IEdFTk1B
U0socHJpdi0+bnVtX3BvcnRzIC0gMSwgMCk7DQo+IC0JCW1iLT5sZWFybl9saW1pdF9tYXggPSBS
VEw4MzY1TUJfTEVBUk5fTElNSVRfTUFYXzgzNjVNQl9WQzsNCj4gKwkJbWItPmxlYXJuX2xpbWl0
X21heCA9IFJUTDgzNjVNQl9MRUFSTl9MSU1JVF9NQVg7DQo+ICAgCQltYi0+amFtX3RhYmxlID0g
cnRsODM2NW1iX2luaXRfamFtXzgzNjVtYl92YzsNCj4gICAJCW1iLT5qYW1fc2l6ZSA9IEFSUkFZ
X1NJWkUocnRsODM2NW1iX2luaXRfamFtXzgzNjVtYl92Yyk7DQo+ICAgDQoNCg==
