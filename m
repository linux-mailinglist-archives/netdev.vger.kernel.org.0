Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A096142D972
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 14:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbhJNMqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 08:46:47 -0400
Received: from mail-eopbgr30121.outbound.protection.outlook.com ([40.107.3.121]:35712
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229912AbhJNMqr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 08:46:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lV1T3ig4W4NdDTMslwf8BtN0yDN2D64fDQ925h4BBDoihxxLeTMrUhwjV52N4puKMvW19UWAMipb+q959Qvay0qsLWZREz5ShKYPk7UGGF6UhQbY8SCtA69U6h7N/1ozIQTq6i/i7Kll7ikMDn4KNIbrR/j9v+/eRLRQzF9SYHuY9jAHtIhuWr5wioQxU/3csJfY9GDZ/k1RHLbZ5xwf1TTXRzLtpnUhgLn0jLs5Ir4O0hZFThrOPgJGYEQ7bRHVdACzYY+vxYWPYiyRdCRVTCu+es1U2JtjfjfBRKCh/S0+0Ehugka7kL0mpQfovJG9B9cwl6sGlbDmCwOtr6yLWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rc1gD0Osc3wzeRjlVAUqkMVDlR92/pv3TesVqmF8JMA=;
 b=TtlfzVvFivog4/qA7T7Tswm0okldAv5pG71v+G0Txpj1wHNeoltGqXvynTnNhYsyObBwyyyFwmIC1/OoC6GM0a735E8Jklk2CxHxiZh51B/QRBORdFt8YG7WtRc5aq7EHRAfxv5tEYgQ687qaTTMbEml7/2nL2avvaBNEJ4jLeymmONAJwOmL1Qt3sWOmjxM19ov4cVPqiQ9zkvRt0k45JE7gu32LiweEk1sjrVWZho+RIOd35NPJOjBnefiUKbK6RFN22BEYJDPd4C9M5d9g5SLim0EBtVcC8v1V/9hK1FIOhPTbc0upuTchh6eNVEiJ3PdhPypmAEYtiQvsyvARA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rc1gD0Osc3wzeRjlVAUqkMVDlR92/pv3TesVqmF8JMA=;
 b=W37+Q/CVlmgBk/KkrWguL9U/HObBKn3WMJq0+zUxve6uyF7fwNaweeXDFACiGk65k4Mxazxx2sHh1oncrTkRAeDbiIYz6WHLOO/D/B2UiMJKBnz0Ej/nZXVn/wrVngc9rv9ssKsS7lgnpMQKJAYw7i0rlmTZuacwPwf9IIdINAw=
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com (2603:10a6:7:60::18) by
 HE1PR0302MB2681.eurprd03.prod.outlook.com (2603:10a6:3:ee::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.25; Thu, 14 Oct 2021 12:44:37 +0000
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::d984:dc33:ba2e:7e56]) by HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::d984:dc33:ba2e:7e56%5]) with mapi id 15.20.4587.026; Thu, 14 Oct 2021
 12:44:37 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <alvin@pqrs.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Michael Rasmussen <MIR@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 5/6] net: dsa: realtek-smi: add rtl8365mb
 subdriver for RTL8365MB-VC
Thread-Topic: [PATCH net-next 5/6] net: dsa: realtek-smi: add rtl8365mb
 subdriver for RTL8365MB-VC
Thread-Index: AQHXv2Xnxc/wFCiERUe0xn+KS7nXfavPfGuAgAEez4CAAG/IAIABaK8A
Date:   Thu, 14 Oct 2021 12:44:37 +0000
Message-ID: <80c80992-85c2-d971-ce1c-a37f8199da7a@bang-olufsen.dk>
References: <20211012123557.3547280-1-alvin@pqrs.dk>
 <20211012123557.3547280-6-alvin@pqrs.dk>
 <20211012082703.7b31e73b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <bde59012-8394-d31b-24c4-018cbfe0ed57@bang-olufsen.dk>
 <20211013081340.0ca97db1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211013081340.0ca97db1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4d4a19e4-e26d-4c0f-7046-08d98f106211
x-ms-traffictypediagnostic: HE1PR0302MB2681:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HE1PR0302MB26816CFEFA8475DF15CC05B783B89@HE1PR0302MB2681.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NCqfxS2ry7tzF3Q4vxD9EqLHASPCVeP3G18FjEDSWEsSo6yUUA9qicPpjWS+GJN3ym4ScV23kHYhLge7bptzcfBejPaE5MO60JpQSAVBt1x8/kkcg+3TuBA12ZC3FjXaVU+wZGHNbe4MG+9Ee+ptuzr7JUuZtMzBVnFyx9UW4h6De9+eSsOWs1Wq51mrM7IbhqZi4/f3p3q12+RXFU6MAhPMzbpKPIvhH623JFmlXfiZzxSXiokB1eycXvyBeqmzPc1lAdSAxjFKCsB7Y3d1cHOUPXwA2P0oGGGCGNWG9zi4sCUjkihEAikMJxPZEeucLppIK7VVQuU2JM18rIfUx/GCinXvx7qkAkIDHYNoLWBH8lMuV/ihWUV1gr7/p6x0V2pRDwU0+0KGdOQdg+xrwD2UOp7Tw8xOKBjsT7mrd1rGaCG5mS8j8CaARFz4qF5VMj+2cDMw+bF3RBcV4ToEMP1FPs6Dfz2sLBLEF952J0o/WrGOZeyPVWogh76e0pn87fox5Hn0HtvqgDzwPbSLx4S3SJr4CABdkdzPs701bNgutn6hQZwozjh5mDw2e5tLKsFcj68d1bdzi5npbuxvM67G2B2aeIsLvVAN8bZSrJ2AiZghpmhYzbNp81MtUUt3yLeoEV3op2r7ye+YNxYVeovgAiu9HhlufvBp9fm4X+4rnb5yWuQILyB/FXUaCkbd6t2/HXpRqaHx4GGKHiieqRUMdAbY9b3B8hALU4ibdORF6zKpv1qxZWuWJWV3dHsdzPjDyY+AGMnJ2W3N3oqZzw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR03MB3114.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8976002)(2616005)(6916009)(31686004)(186003)(85202003)(85182001)(54906003)(2906002)(508600001)(66556008)(66446008)(6486002)(4326008)(6506007)(31696002)(6512007)(38100700002)(76116006)(86362001)(7416002)(66476007)(64756008)(71200400001)(316002)(122000001)(26005)(83380400001)(66946007)(66574015)(38070700005)(8676002)(53546011)(8936002)(91956017)(36756003)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cEViSnl2dUEyWlZ6bTl1Vi9GSHZhZFdpRlhiR2pkUWcwMnBYcmt3VytZTU9h?=
 =?utf-8?B?T3NIWnJ1SHk0WnRPQW1tSmIzTXZVQlNBK2w5bTJwZFBhQytpWk4rcnllUGQw?=
 =?utf-8?B?RkkvU1c2VFc4NHV0MG1YWEticUpmRnUyOUpTR010bmFSY2FIQXlDVHd4aVBq?=
 =?utf-8?B?anBLay9SckQwR1JwbmIxQ1E0Zk1jQ2RwUTF0VUpIY3BsK25KT3J3Mm9jZDJQ?=
 =?utf-8?B?NitPSzM5dHZSQzhpbEdLRFBvZkNJYWFIZjJsSXlHWjBHSjdUVTJGa3FIaG80?=
 =?utf-8?B?YjBVeHh2ZXUxaVFjL1NFQzkwOGkwR3BKNDE0ZUhCYkUxc3NoblEwcFZaMEZw?=
 =?utf-8?B?QWswTzY3SGNGYkZMOWFZRFJ1ZVRJUXE1UWJWcDdpejJIcTNjRTg1MnFDT1B1?=
 =?utf-8?B?bllHaVRsNDFxRXp1ZElrczZVaSt6L29QT2dxUU5vYXY5Q2ZGU1J5RUtqcis1?=
 =?utf-8?B?OURyZzVkWDBnZFcwZ0VTZE8wVlJMemZYbFBTa0dnUzU5WkNrWjhza25HM0Ux?=
 =?utf-8?B?Ukx2anIzOWZKRmtvUTA4NU5YNTRhWFNzWUpDdTFibXVodk9YYUljam5ZV2hM?=
 =?utf-8?B?a2pRMTkxQWgrRU5EK29oRk91MDVFdGdmY2lGdXhoUTFGcGd0bG1KQmp1YlJt?=
 =?utf-8?B?RnkxQjVhaENHdnlnS1NoakVsSmVyTFd0SXlYVFh5cVo0Mkw3bE5SSzhyWG5D?=
 =?utf-8?B?VXJVbFB1c3FJRC9qMUJxcUhWRXlKd2w3NFFjV2d0UFhBek1oN3NBZXRTeXV3?=
 =?utf-8?B?ZVNBWHAxWEtuN0ltdkJPeCtsdUVrS2pRb05RdE5BNHJZRjcvV2U1K1NDdkQw?=
 =?utf-8?B?UFcrUlVNMkJNVHlOcVRydndJcEtwWERkRU43Snp1eW5jMDRDQzMzbEIvQTN5?=
 =?utf-8?B?TFhhbDRBUGhJR0F5Y0tmRlRPeitYL3RlL3FQYmJrWkROZTQvaGZYc0VuRXY0?=
 =?utf-8?B?UHYvSS9VR3ZXeE5mV3d5QkhWbmluMEhmRHJva01Hejlmc0drbXU3TFlYc3pD?=
 =?utf-8?B?UUd6azB0SzY5SWhyRGZXUUlZQmtSdmt0bFZhUm44Ui9OZUxGZWZVRG53MHF1?=
 =?utf-8?B?dGpZZjNlREdxSWFOWTIxNFR1WnVkWlRvSUJ1Mks0dkp0WlhIRW9pcWFBZncy?=
 =?utf-8?B?Z1lQVFpyTUxOUVhkNlQzM3RXVitGRjVaWHYrU0UrYW9wNWU3cWhCZkNYd2Nj?=
 =?utf-8?B?Qk1RQzhnMmh3REZ3bk0rbDRoMFZybkxMRExZSnk1MEhGYXdnSmMwTnR5b0tU?=
 =?utf-8?B?K0htYXFSSWkxSG9JNGZLSW5yOFo4S0VoRXU4ME1sQ2RaTmhDeFpzTVREVk9C?=
 =?utf-8?B?aVY4WGF0dlpnTE5UOTZiaEpCYURET01KRE1hb1p1Q0NkelZxazhrUHI0WStB?=
 =?utf-8?B?N0p2SnRFSDF3L2Q4RkpsWENKemVoRS9CbkFOcmExazRNVDVqT1F2RmYrSzJ5?=
 =?utf-8?B?Z2J1eGZQOFRVUUxzQzFnekJIVm5MRTM3bXBlNUJFSW40Z3JiaHpyNHBPYzdV?=
 =?utf-8?B?K3RXWE9HN2U5VnBSck5TeDltLzlrVnNoSHB1NVhDbWpGN0tlaEgvM1lPRDhk?=
 =?utf-8?B?Vlg1cGJhcFVQZzh5TlNYMkl5cVh0STc0NFg1QVp1Z3FYcmt1YUZVd1VLSlFu?=
 =?utf-8?B?NHlTbjd3cm5YT0poSFBSeFF1TnA2bnN1Znc1RG1nOFl0dWVWWGdCSk0vN081?=
 =?utf-8?B?eXVpMm1MZjhIOGg1VDJJNHdzdGllQ3ZsdHBITVRDL0lxTWJMampCZW9EVW44?=
 =?utf-8?Q?AsvRIyuPNqNWaIahOK19T5JLJTHZLeh3wkTw7WU?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6467C79BC251C442B28353C6A3C45CCB@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR03MB3114.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d4a19e4-e26d-4c0f-7046-08d98f106211
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2021 12:44:37.5255
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IbXFwoyup2jGV7m2Oygb6xNlkzdDg72YO69fwfhc3Fu8TJUx4xuZtYdg24N8nVSYjdwHoQUEK7BF6v4Le7zNaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0302MB2681
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvMTMvMjEgNToxMyBQTSwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+IE9uIFdlZCwgMTMg
T2N0IDIwMjEgMDg6MzM6MzYgKzAwMDAgQWx2aW4gxaBpcHJhZ2Egd3JvdGU6DQo+PiBPbiAxMC8x
Mi8yMSA1OjI3IFBNLCBKYWt1YiBLaWNpbnNraSB3cm90ZToNCj4+PiBPbiBUdWUsIDEyIE9jdCAy
MDIxIDE0OjM1OjU0ICswMjAwIEFsdmluIMWgaXByYWdhIHdyb3RlOg0KPj4+PiArCXsgMCwgNCwg
MiwgImRvdDNTdGF0c0ZDU0Vycm9ycyIgfSwNCj4+Pj4gKwl7IDAsIDYsIDIsICJkb3QzU3RhdHNT
eW1ib2xFcnJvcnMiIH0sDQo+Pj4+ICsJeyAwLCA4LCAyLCAiZG90M0luUGF1c2VGcmFtZXMiIH0s
DQo+Pj4+ICsJeyAwLCAxMCwgMiwgImRvdDNDb250cm9sSW5Vbmtub3duT3Bjb2RlcyIgfSwNCj4+
PiAuLi4NCj4+Pg0KPj4+IFlvdSBtdXN0IGV4cG9zZSBjb3VudGVycyB2aWEgZXhpc3Rpbmcgc3Rh
bmRhcmQgQVBJcy4NCj4+Pg0KPj4+IFlvdSBzaG91bGQgaW1wbGVtZW50IHRoZXNlIGV0aHRvb2wg
b3BzOg0KPj4NCj4+IEkgaW1wbGVtZW50IHRoZSBkc2Ffc3dpdGNoX29wcyBjYWxsYmFjayAuZ2V0
X2V0aHRvb2xfc3RhdHMsIHVzaW5nIGFuDQo+PiBleGlzdGluZyBmdW5jdGlvbiBydGw4MzY2X2dl
dF9ldGh0b29sX3N0YXRzIGluIHRoZSBzd2l0Y2ggaGVscGVyIGxpYnJhcnkNCj4+IHJ0bDgzNjYu
Yy4gSXQgd2FzIG15IHVuZGVyc3RhbmRpbmcgdGhhdCB0aGlzIGlzIHRoZSBjb3JyZWN0IHdheSB0
bw0KPj4gZXhwb3NlIGNvdW50ZXJzIHdpdGhpbiB0aGUgRFNBIGZyYW1ld29yayAtIHBsZWFzZSBj
b3JyZWN0IG1lIGlmIHRoYXQgaXMNCj4+IHdyb25nLg0KPiANCj4gSXQncyB0aGUgbGVnYWN5IHdh
eSwgdG9kYXkgd2UgaGF2ZSBhIHVuaWZpZWQgQVBJIGZvciByZXBvcnRpbmcgdGhvc2UNCj4gc3Rh
dHMgc28gdXNlciBzcGFjZSBTVyBkb2Vzbid0IGhhdmUgdG8gbWFpbnRhaW4gYSBteXJpYWQgc3Ry
aW5nIG1hdGNoZXMNCj4gdG8gZ2V0IHRvIGJhc2ljIElFRUUgc3RhdHMgYWNyb3NzIHZlbmRvcnMu
IERyaXZlciBhdXRob3JzIGhhdmUgYSB0cnVseQ0KPiBpbmNyZWRpYmxlIGFiaWxpdHkgdG8gaW52
ZW50IHRoZWlyIG93biBuYW1lcyBmb3Igc3RhbmRhcmQgc3RhdHMuIEl0DQo+IGFwcGVhcnMgdGhh
dCB5b3VyIHBpY2sgb2YgbmFtZXMgaXMgYWxzbyB1bmlxdWUgOikNCj4gDQo+IEl0IHNob3VsZCBi
ZSB0cml2aWFsIHRvIHBsdW1iIHRoZSByZWxldmFudCBldGh0b29sX29wcyB0aHJ1IHRvDQo+IGRz
YV9zd2l0Y2hfb3BzIGlmIHJlbGV2YW50IGRzYSBvcHMgZG9uJ3QgZXhpc3QuDQo+IA0KPiBZb3Ug
c2hvdWxkIGFsc28gcG9wdWxhdGUgY29ycmVjdCBzdGF0cyBpbiBkc2Ffc3dpdGNoX29wczo6Z2V0
X3N0YXRzNjQNCj4gKHNlZSB0aGUgbGFyZ2UgY29tbWVudCBhYm92ZSB0aGUgZGVmaW5pdGlvbiBv
ZiBzdHJ1Y3QNCj4gcnRubF9saW5rX3N0YXRzNjQgZm9yIG1hcHBpbmcpLiBBIHdvcmQgb2Ygd2Fy
bmluZyB0aGVyZSwgdGhvLCB0aGF0DQo+IGNhbGxiYWNrIHJ1bnMgaW4gYW4gYXRvbWljIGNvbnRl
eHQgc28gaWYgeW91ciBkcml2ZXIgbmVlZHMgdG8gYmxvY2sgaXQNCj4gaGFzIHRvIHJlYWQgdGhl
IHN0YXRzIHBlcmlvZGljYWxseSBmcm9tIGEgYXN5bmMgd29yay4NCg0KT0ssIHNvIGp1c3QgdG8g
Y2xhcmlmeToNCg0KLSBnZXRfZXRodG9vbF9zdGF0cyBpcyBkZXByZWNhdGVkIC0gZG8gbm90IHVz
ZQ0KLSBnZXRfZXRoX3twaHksbWFjLGN0cmwscm1vbn1fc3RhdHMgaXMgdGhlIG5ldyBBUEkgLSBh
ZGQgRFNBIHBsdW1iaW5nIA0KYW5kIHVzZSB0aGlzDQotIGdldF9zdGF0czY0IG9ydGhvZ29uYWwg
dG8gZXRodG9vbCBzdGF0cyBidXQgc3RpbGwgaW1wb3J0YW50IC0gdXNlIGFsc28gDQp0aGlzDQoN
CkZvciBzdGF0czY0IEkgd2lsbCBuZWVkIHRvIHBvbGwgYXN5bmNocm9ub3VzbHkgLSBkbyB5b3Ug
aGF2ZSBhbnkgDQpzdWdnZXN0aW9uIGZvciBob3cgZnJlcXVlbnRseSBJIHNob3VsZCBkbyB0aGF0
PyBJIHNlZSBvbmUgRFNBIGRyaXZlciANCmRvaW5nIGl0IGV2ZXJ5IDMgc2Vjb25kcywgZm9yIGV4
YW1wbGUuDQoNClRoYW5rcw0KDQoJQWx2aW4NCg0KPiANCj4+IFRoZSBzdHJ1Y3R1cmUgeW91IGhp
Z2hsaWdodCBpcyBqdXN0IHNvbWUgaW50ZXJuYWwgZ2x1ZSB0byBzb3J0IG91dCB0aGUNCj4+IGlu
dGVybmFsIHJlZ2lzdGVyIG1hcHBpbmcuIEkgYm9ycm93ZWQgdGhlIGFwcHJvYWNoIGZyb20gdGhl
IGV4aXN0aW5nDQo+PiBydGw4MzY2cmIuYyBSZWFsdGVrIFNNSSBzdWJkcml2ZXIuDQo+IA0KPiBU
aGUgY2FsbGJhY2tzIGxpc3RlZCBiZWxvdyBhcmUgcmVsYXRpdmVseSBuZXcsIHRoZXkgbWF5IGhh
dmUgbm90DQo+IGV4aXN0ZWQgd2hlbiB0aGF0IGRyaXZlciB3YXMgd3JpdHRlbi4gQWxzbyBJIG1h
eSBoYXZlIG1pc3NlZCBpdA0KPiBpbiByZXZpZXcuDQo+IA0KPj4+IAl2b2lkCSgqZ2V0X2V0aF9w
aHlfc3RhdHMpKHN0cnVjdCBuZXRfZGV2aWNlICpkZXYsDQo+Pj4gCQkJCSAgICAgc3RydWN0IGV0
aHRvb2xfZXRoX3BoeV9zdGF0cyAqcGh5X3N0YXRzKTsNCj4+PiAJdm9pZAkoKmdldF9ldGhfbWFj
X3N0YXRzKShzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LA0KPj4+IAkJCQkgICAgIHN0cnVjdCBldGh0
b29sX2V0aF9tYWNfc3RhdHMgKm1hY19zdGF0cyk7DQo+Pj4gCXZvaWQJKCpnZXRfZXRoX2N0cmxf
c3RhdHMpKHN0cnVjdCBuZXRfZGV2aWNlICpkZXYsDQo+Pj4gCQkJCSAgICAgIHN0cnVjdCBldGh0
b29sX2V0aF9jdHJsX3N0YXRzICpjdHJsX3N0YXRzKTsNCj4+PiAJdm9pZAkoKmdldF9ybW9uX3N0
YXRzKShzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LA0KPj4+IAkJCQkgIHN0cnVjdCBldGh0b29sX3Jt
b25fc3RhdHMgKnJtb25fc3RhdHMsDQo+Pj4gCQkJCSAgY29uc3Qgc3RydWN0IGV0aHRvb2xfcm1v
bl9oaXN0X3JhbmdlICoqcmFuZ2VzKTsNCg0K
