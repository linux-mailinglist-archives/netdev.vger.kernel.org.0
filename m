Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEAC489945
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 14:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbiAJNJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 08:09:56 -0500
Received: from mail-vi1eur05on2136.outbound.protection.outlook.com ([40.107.21.136]:10656
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232648AbiAJNJv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 08:09:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JG76BfTWTiFY/EtIGOL/Q2ku1qc0gdC7Wz+tQNWHMiL6++L7Lk49I8UkI0H09u3/ahCOaZckjXxTzfnZr9i5PqvCadIgVMT+sXTD46DdMUudjH7PZV71IgrE0h3Oki6kMp5AUGkLfEmBQoP89XWUGtyV/J11lg2dfKPwwNV21LN+tYgzPza1ZWVcjDzXCruO0U1MOmzbQ8dUX9r01dd33jO/CnJCAkhfFyuwJD3YSl457Pv9b24VBEKwua2zrPQMJfUM9BdGdzjrtR9mhnTYgAx0VEnPWrInX6VCJacIh3nHsjYmWs6USiXhSEkZSrcRdN9Wexxf5s0eas5weNKJWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GB8fam5yn0OAXF46FXs6+IPw3ku/RmZ5Tse5UISdTd4=;
 b=dK+i6EroX/H1uMcz0CObpdQEjiSZkJSgLbQYSZxzj5B5aW0slTMUTwFNmCxXCYRn1twyNG3t4rOa3cNr1t8sqP0HEw4ypxWYuM/q9py2Una9Ocjt1HqIs4kpx0MyWoL8WBH2u2T18JqfabDA3mk/f93GTQoVGrNFfn9sX+2McaWMEHcVE4bgA8QBA49Hje/4Tj4MzzOrKpcggK6ONkiyA2h8GpHRWUgJWSeGYOVCcRbTijTNos//4f/Y/VGQAajkqLGi2dvjHH0PHb/4u4UDSL1sxf+rIXgla+45ax5/ETfyAHq+OzEXa7KlR9dn/YGPQy1NlrNNx6VGpAHQOZzM7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GB8fam5yn0OAXF46FXs6+IPw3ku/RmZ5Tse5UISdTd4=;
 b=M70SXA6uUmymWPYI9luQ1jsuFkQmB3+aq1XM0L1oL4XMT94RRi5iHNM3mSzapkjmbifK4DzLPNKxIqbEM4UFARAXblmXb3IITsmzzYuIQhFwM9lkbEUJjTQz2pjvRuTpgAx1S0xYYaDujl/WxOkJ4rmKcWEV1bNWOINuuLIn7SE=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AM6PR0302MB3224.eurprd03.prod.outlook.com (2603:10a6:209:23::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Mon, 10 Jan
 2022 13:09:49 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::dd50:b902:a4d:312f]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::dd50:b902:a4d:312f%5]) with mapi id 15.20.4867.011; Mon, 10 Jan 2022
 13:09:49 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>,
        "frank-w@public-files.de" <frank-w@public-files.de>
Subject: Re: [PATCH net-next v4 05/11] net: dsa: realtek: use phy_read in
 ds->ops
Thread-Topic: [PATCH net-next v4 05/11] net: dsa: realtek: use phy_read in
 ds->ops
Thread-Index: AQHYAeKRalLGQjVP2UmGDCbKwHJfvQ==
Date:   Mon, 10 Jan 2022 13:09:49 +0000
Message-ID: <87zgo3d9er.fsf@bang-olufsen.dk>
References: <20220105031515.29276-1-luizluca@gmail.com>
        <20220105031515.29276-6-luizluca@gmail.com>
In-Reply-To: <20220105031515.29276-6-luizluca@gmail.com> (Luiz Angelo Daros de
        Luca's message of "Wed, 5 Jan 2022 00:15:09 -0300")
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5175703a-c858-4b58-c513-08d9d43a7b72
x-ms-traffictypediagnostic: AM6PR0302MB3224:EE_
x-microsoft-antispam-prvs: <AM6PR0302MB3224219A3473F72EE4DA253783509@AM6PR0302MB3224.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uPjaupEHtZyMY8wANPhwMWh2S5tmmCqpjkCXUrnQGVewhOlrE+A781dXd9TDoz7Rl3KUQRl7Z0n6f+wHDUrFw5/mYKxr1op5US4vKsNlBWjpR2eOSM3veLhHru5WY647QK4fV6CjH7njHY5trRa9msHA2h2HNaau29K6zcfCONSQ7sEIHArOiQUDQLKnQIxjjHlWz5tVobEG+M0gC1QGqVKGVGUBoAUv4zRsGEftYSzSjqbRbyZEqF2axPifabLxBWuYU7y+TP05Lp+FBuck4Pu0VfHpu2VuUQwKa5ms7HKoTEQVCQhaJqIywxP3SkbFGg937GdEDnj68qwQsJdsQy1ujGiaZStMoVbYGYE1OJqPk6ciRlA39nFZwsarUdaarAOEHfM7C9zWsI/4z3Y63sogAkkeUMwlZJnQTuVGFYhXbEIz7V5n5YSeI/zHHWmoERXlOb6jCsIhXPn0Z0tk5SIKgmMSPemTzP2wjiUcCTvTK9aVsGqalffh50m7xgftricI82W+ZbRNiAPm3e+Rw+YX7wUT4z800yrJkuxIT4hcblSt1gWfqTPOhLaWj5qMIpxvd7AH4v2adOoswvUHyrrCTbNVUosjcipq2/c7+xuZINlGMjeye5jEKd/dLcVQVtt6AdJSfBloWqbnE1olx+jxLu1vl/wlp7GJca5JHg7dCrJ+S1YFTziScrEiYNrdVSZ641Z/hfmSJFBL9jitXg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(316002)(5660300002)(66556008)(66476007)(54906003)(83380400001)(122000001)(186003)(8936002)(6486002)(36756003)(508600001)(66446008)(66574015)(8676002)(66946007)(91956017)(85182001)(76116006)(38100700002)(4326008)(71200400001)(38070700005)(6506007)(8976002)(85202003)(6512007)(2616005)(64756008)(86362001)(6916009)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OGFqNVZldUczNFVBRHVQbUxRL2Q1VlcyUC9YR2IvZ3d4ekpHbmp3Qm92RUxR?=
 =?utf-8?B?VWNoN2dJMExiclhVRTZHUnpIUHF5QXJhRmZiNUNrUU0vN010Y1gxWEhMOHFZ?=
 =?utf-8?B?MFdsbkM2SWFHTmtCRXAzOXh6aXJwUlpHRElQb09vem5YajBBSGJiYXpEdkQ1?=
 =?utf-8?B?NWg1dmpUTU9RR2RDVWVzeUZTZlNFeTlVcFdnMEFWbXlpUEpuRXBHYUN6U3Jn?=
 =?utf-8?B?VExJVlZlbm9JSFZPZXorUmY2R1NEbXNIalNzMmVYRE9YNmQrb1FwT2VqNVAr?=
 =?utf-8?B?a2szby9uVTBxY0xUdk9LbGlSQXRxY21iM2hYY3M3VUI3WEQ3cXNmYzZnRWMx?=
 =?utf-8?B?QTA4UGdxOHIrelROY21zVlEyN2V0MHZEeXVYYWJaR2MvOE83TWpkZEw0cTlR?=
 =?utf-8?B?SmRibzBQemlFZklMNXBuejBoMVJsNFowU25vdlpjU1d0UzU4L2lSWDhZMFJR?=
 =?utf-8?B?cEk1bklLaGVzWHZIQjV2OCtqMStFU2lMR3dKaGtXMWhONE5INUxDenl5ZC9x?=
 =?utf-8?B?VmRNc0Flc0tUU2t4VmRvRkJ4NTVuVlM2UkhsamdRRzZlMzVNU2o1RHl1Ti9K?=
 =?utf-8?B?L0VrbHVIQnZLWXNjK0wra1NmdzE1Z2NIUHVGU0VzZW5abnBwV00zVnhORjRv?=
 =?utf-8?B?T2g1UzR6MzE5QmF2bU9ZYm05aFI4Wk1vblV0b0o1OUJ6WjZpOU41VzBHaHFT?=
 =?utf-8?B?N1plQ0RTdndFdU1TcThNNXJQOHBPajQxN21JRWxWYWxFdXpSTkN1MnlvOHNi?=
 =?utf-8?B?bkJacFBBV1lFRzBaSGdlamlJUDcvcFhiVU5ucVRiWVJ0WDhReEx3K2o2SzJy?=
 =?utf-8?B?clpRODh0VlZiZmhtdTE4MWFiLzhhMGdlb2VuWnpwRmdqUktlSkgzbVMvamF3?=
 =?utf-8?B?bEd5QWdUbnpVaytacEU3V1VKWHFJTVdCTDZ0R3dxUTNxQVRqRFMyRVdRQlVJ?=
 =?utf-8?B?SEVZeXQ4SXQ0WVZpSHBRK292MWMrVTdBaWx1b2ZUYjdKaWlKN1c1NENVcTZW?=
 =?utf-8?B?Y2Zub2lxbVI3RXFiS2w4bXg0Z0JyUkgybE4vWXpUNGFXcnVVTGtKZ1JJRXFS?=
 =?utf-8?B?ZWRXd0RCdVI0a3RBeVpzL0VQckpNdnRKQTlIYWkweHZEaHF4RTZsVTNPYVhF?=
 =?utf-8?B?dEZUa1ZVSm4rb2szb05wbi90MDZRNWpoK21UdmV2TGdVNEh6enRSenRYLzFs?=
 =?utf-8?B?dW9VakorY0ZtL2VoNFhVdHZjRXNyNjVET3Z0VDBmUmdVV0xpdk0zVGczMngr?=
 =?utf-8?B?d25UTFN6TituSmFRdWUvZjZxUFp0ZEdMd2prZ1R5ck9FRkJnTFFWY0V0dlVk?=
 =?utf-8?B?ZlFJd0MxZmIyc2F3dDV2RTJXYW1INnp0SDhJMWo4Nmk3S0xyaTBqTGd6VkZy?=
 =?utf-8?B?TER6dVc2dU1ZSGFDbXdVSjgyZUllMVZibjVTY2x1NENVVENmd1BqTHVqN2dE?=
 =?utf-8?B?djRKRkU0cmVHbStxVi9rMFhkWEtpZmNqeWxaT01SdEtEZS9TcUduamJyYXhQ?=
 =?utf-8?B?a0VzSzhBc0hGU05oS0JqcmY1a1ZIdkF3bTF5Q1BPOVB5S29Md1N4MmE4c09v?=
 =?utf-8?B?eEkxRGJPcGt2dSs2TGt4WmU1ZlVvYnRROGFwb3lSZjlQRjY4OVp4bDdRdlpi?=
 =?utf-8?B?SXpmN0E4VHVocFZWdk1TanZkRmt2MFA3VnFoOEVNL3Y2b1dUWm16MnQ1ME1r?=
 =?utf-8?B?NVpkSkphYXk5SGRqdGs4aGMwVklhR244TFlzYjlsZEtXWXY1VGdLWkwwU2JD?=
 =?utf-8?B?TjRWb1dRYUY2QWl6d0R1NkdqUytJWnY5cGlTdWl2S0NGeVEzb0hkZWFYRGtu?=
 =?utf-8?B?NjAzWVZsQ0FUUVRDbDB1YXFyMDVsNnNnOEs5c1piYnRUMmk1QlFKc2xqb0kr?=
 =?utf-8?B?TzlOUVMwcEpqbzExOFB2YnZ5WmF2RlYyL2hXdW85ZXJmTlEySVpDd0hkZExx?=
 =?utf-8?B?SGZ0UUU3NjBPOU83cGMxaFRUSDZWM3JuclpHZmFKaU0zL1dlUDV4NU5zV2xj?=
 =?utf-8?B?eWkxOVd6cGk2SmZEVXB0Ymtodkh5b1JYdTJzQnVudlIwdFR6SGFqQmxpaUtW?=
 =?utf-8?B?b3NRUDZyRTFJZ0l0aXJLcnUxVTNBRUdaU21SOWFzNGtuM0s4dllPSEVhSjd3?=
 =?utf-8?B?TjR4ejUvVElDK1RHMXI0dWRycFV1YkpHWktBY09PVFI3WEFEOExaV25scWU2?=
 =?utf-8?Q?QR78Xs2xMDfzNc0uzshyAYo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8D8ED1F55851254883794981CBDE6822@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5175703a-c858-4b58-c513-08d9d43a7b72
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2022 13:09:49.3634
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0IPCnz3QBlyf9+OElf0g5wEjKUYtO4zCPMoGxETn0N8SJFSp2FY01wkpgoJUX+FJru472j0/XYOwyudufTXTUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0302MB3224
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

THVpeiBBbmdlbG8gRGFyb3MgZGUgTHVjYSA8bHVpemx1Y2FAZ21haWwuY29tPiB3cml0ZXM6DQoN
Cj4gVGhlIGRzLT5vcHMtPnBoeV9yZWFkIHdpbGwgb25seSBiZSB1c2VkIGlmIHRoZSBkcy0+c2xh
dmVfbWlpX2J1cw0KPiB3YXMgbm90IGluaXRpYWxpemVkLiBDYWxsaW5nIHJlYWx0ZWtfc21pX3Nl
dHVwX21kaW8gd2lsbCBjcmVhdGUgYQ0KPiBkcy0+c2xhdmVfbWlpX2J1cywgbWFraW5nIGRzLT5v
cHMtPnBoeV9yZWFkIGRvcm1hbnQuDQo+DQo+IFVzaW5nIGRzLT5vcHMtPnBoeV9yZWFkIHdpbGwg
YWxsb3cgc3dpdGNoZXMgY29ubmVjdGVkIHRocm91Z2ggbm9uLVNNSQ0KPiBpbnRlcmZhY2VzIChs
aWtlIG1kaW8pIHRvIGxldCBkcyBhbGxvY2F0ZSBzbGF2ZV9taWlfYnVzIGFuZCByZXVzZSB0aGUN
Cj4gc2FtZSBjb2RlLg0KPg0KPiBTaWduZWQtb2ZmLWJ5OiBMdWl6IEFuZ2VsbyBEYXJvcyBkZSBM
dWNhIDxsdWl6bHVjYUBnbWFpbC5jb20+DQo+IFRlc3RlZC1ieTogQXLEsW7DpyDDnE5BTCA8YXJp
bmMudW5hbEBhcmluYzkuY29tPg0KPiBSZXZpZXdlZC1ieTogTGludXMgV2FsbGVpaiA8bGludXMu
d2FsbGVpakBsaW5hcm8ub3JnPg0KDQpSZXZpZXdlZC1ieTogQWx2aW4gxaBpcHJhZ2EgPGFsc2lA
YmFuZy1vbHVmc2VuLmRrPg0KDQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWsvcmVh
bHRlay1zbWkuYyB8ICA2ICsrKystLQ0KPiAgZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWsvcmVhbHRl
ay5oICAgICB8ICAzIC0tLQ0KPiAgZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWsvcnRsODM2NW1iLmMg
ICB8IDEwICsrKysrKy0tLS0NCj4gIGRyaXZlcnMvbmV0L2RzYS9yZWFsdGVrL3J0bDgzNjZyYi5j
ICAgfCAxMCArKysrKystLS0tDQo+ICA0IGZpbGVzIGNoYW5nZWQsIDE2IGluc2VydGlvbnMoKyks
IDEzIGRlbGV0aW9ucygtKQ0KPg0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZHNhL3JlYWx0
ZWsvcmVhbHRlay1zbWkuYyBiL2RyaXZlcnMvbmV0L2RzYS9yZWFsdGVrL3JlYWx0ZWstc21pLmMN
Cj4gaW5kZXggNTUxNGZlODFkNjRmLi4xZjAyNGUyNTIwYTYgMTAwNjQ0DQo+IC0tLSBhL2RyaXZl
cnMvbmV0L2RzYS9yZWFsdGVrL3JlYWx0ZWstc21pLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZHNh
L3JlYWx0ZWsvcmVhbHRlay1zbWkuYw0KPiBAQCAtMzI5LDE2ICszMjksMTggQEAgc3RhdGljIGNv
bnN0IHN0cnVjdCByZWdtYXBfY29uZmlnIHJlYWx0ZWtfc21pX21kaW9fcmVnbWFwX2NvbmZpZyA9
IHsNCj4gIHN0YXRpYyBpbnQgcmVhbHRla19zbWlfbWRpb19yZWFkKHN0cnVjdCBtaWlfYnVzICpi
dXMsIGludCBhZGRyLCBpbnQgcmVnbnVtKQ0KPiAgew0KPiAgCXN0cnVjdCByZWFsdGVrX3ByaXYg
KnByaXYgPSBidXMtPnByaXY7DQo+ICsJc3RydWN0IGRzYV9zd2l0Y2ggKmRzID0gcHJpdi0+ZHM7
DQo+ICANCj4gLQlyZXR1cm4gcHJpdi0+b3BzLT5waHlfcmVhZChwcml2LCBhZGRyLCByZWdudW0p
Ow0KPiArCXJldHVybiBkcy0+b3BzLT5waHlfcmVhZChkcywgYWRkciwgcmVnbnVtKTsNCj4gIH0N
Cj4gIA0KPiAgc3RhdGljIGludCByZWFsdGVrX3NtaV9tZGlvX3dyaXRlKHN0cnVjdCBtaWlfYnVz
ICpidXMsIGludCBhZGRyLCBpbnQgcmVnbnVtLA0KPiAgCQkJCSAgdTE2IHZhbCkNCj4gIHsNCj4g
IAlzdHJ1Y3QgcmVhbHRla19wcml2ICpwcml2ID0gYnVzLT5wcml2Ow0KPiArCXN0cnVjdCBkc2Ff
c3dpdGNoICpkcyA9IHByaXYtPmRzOw0KPiAgDQo+IC0JcmV0dXJuIHByaXYtPm9wcy0+cGh5X3dy
aXRlKHByaXYsIGFkZHIsIHJlZ251bSwgdmFsKTsNCj4gKwlyZXR1cm4gZHMtPm9wcy0+cGh5X3dy
aXRlKGRzLCBhZGRyLCByZWdudW0sIHZhbCk7DQo+ICB9DQo+ICANCj4gIHN0YXRpYyBpbnQgcmVh
bHRla19zbWlfc2V0dXBfbWRpbyhzdHJ1Y3QgZHNhX3N3aXRjaCAqZHMpDQo+IGRpZmYgLS1naXQg
YS9kcml2ZXJzL25ldC9kc2EvcmVhbHRlay9yZWFsdGVrLmggYi9kcml2ZXJzL25ldC9kc2EvcmVh
bHRlay9yZWFsdGVrLmgNCj4gaW5kZXggNTg4MTRkZTU2M2EyLi5hMDNkZTE1YzRhOTQgMTAwNjQ0
DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2RzYS9yZWFsdGVrL3JlYWx0ZWsuaA0KPiArKysgYi9kcml2
ZXJzL25ldC9kc2EvcmVhbHRlay9yZWFsdGVrLmgNCj4gQEAgLTEwMyw5ICsxMDMsNiBAQCBzdHJ1
Y3QgcmVhbHRla19vcHMgew0KPiAgCWludAkoKmVuYWJsZV92bGFuKShzdHJ1Y3QgcmVhbHRla19w
cml2ICpwcml2LCBib29sIGVuYWJsZSk7DQo+ICAJaW50CSgqZW5hYmxlX3ZsYW40aykoc3RydWN0
IHJlYWx0ZWtfcHJpdiAqcHJpdiwgYm9vbCBlbmFibGUpOw0KPiAgCWludAkoKmVuYWJsZV9wb3J0
KShzdHJ1Y3QgcmVhbHRla19wcml2ICpwcml2LCBpbnQgcG9ydCwgYm9vbCBlbmFibGUpOw0KPiAt
CWludAkoKnBoeV9yZWFkKShzdHJ1Y3QgcmVhbHRla19wcml2ICpwcml2LCBpbnQgcGh5LCBpbnQg
cmVnbnVtKTsNCj4gLQlpbnQJKCpwaHlfd3JpdGUpKHN0cnVjdCByZWFsdGVrX3ByaXYgKnByaXYs
IGludCBwaHksIGludCByZWdudW0sDQo+IC0JCQkgICAgIHUxNiB2YWwpOw0KPiAgfTsNCj4gIA0K
PiAgc3RydWN0IHJlYWx0ZWtfdmFyaWFudCB7DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9k
c2EvcmVhbHRlay9ydGw4MzY1bWIuYyBiL2RyaXZlcnMvbmV0L2RzYS9yZWFsdGVrL3J0bDgzNjVt
Yi5jDQo+IGluZGV4IGI1MmJiOTg3MDI3Yy4uMTFhOTg1OTAwYzU3IDEwMDY0NA0KPiAtLS0gYS9k
cml2ZXJzL25ldC9kc2EvcmVhbHRlay9ydGw4MzY1bWIuYw0KPiArKysgYi9kcml2ZXJzL25ldC9k
c2EvcmVhbHRlay9ydGw4MzY1bWIuYw0KPiBAQCAtNjc0LDggKzY3NCw5IEBAIHN0YXRpYyBpbnQg
cnRsODM2NW1iX3BoeV9vY3Bfd3JpdGUoc3RydWN0IHJlYWx0ZWtfcHJpdiAqcHJpdiwgaW50IHBo
eSwNCj4gIAlyZXR1cm4gMDsNCj4gIH0NCj4gIA0KPiAtc3RhdGljIGludCBydGw4MzY1bWJfcGh5
X3JlYWQoc3RydWN0IHJlYWx0ZWtfcHJpdiAqcHJpdiwgaW50IHBoeSwgaW50IHJlZ251bSkNCj4g
K3N0YXRpYyBpbnQgcnRsODM2NW1iX3BoeV9yZWFkKHN0cnVjdCBkc2Ffc3dpdGNoICpkcywgaW50
IHBoeSwgaW50IHJlZ251bSkNCj4gIHsNCj4gKwlzdHJ1Y3QgcmVhbHRla19wcml2ICpwcml2ID0g
ZHMtPnByaXY7DQo+ICAJdTMyIG9jcF9hZGRyOw0KPiAgCXUxNiB2YWw7DQo+ICAJaW50IHJldDsN
Cj4gQEAgLTcwMiw5ICs3MDMsMTAgQEAgc3RhdGljIGludCBydGw4MzY1bWJfcGh5X3JlYWQoc3Ry
dWN0IHJlYWx0ZWtfcHJpdiAqcHJpdiwgaW50IHBoeSwgaW50IHJlZ251bSkNCj4gIAlyZXR1cm4g
dmFsOw0KPiAgfQ0KPiAgDQo+IC1zdGF0aWMgaW50IHJ0bDgzNjVtYl9waHlfd3JpdGUoc3RydWN0
IHJlYWx0ZWtfcHJpdiAqcHJpdiwgaW50IHBoeSwgaW50IHJlZ251bSwNCj4gK3N0YXRpYyBpbnQg
cnRsODM2NW1iX3BoeV93cml0ZShzdHJ1Y3QgZHNhX3N3aXRjaCAqZHMsIGludCBwaHksIGludCBy
ZWdudW0sDQo+ICAJCQkgICAgICAgdTE2IHZhbCkNCj4gIHsNCj4gKwlzdHJ1Y3QgcmVhbHRla19w
cml2ICpwcml2ID0gKHN0cnVjdCByZWFsdGVrX3ByaXYgKilkcy0+cHJpdjsNCj4gIAl1MzIgb2Nw
X2FkZHI7DQo+ICAJaW50IHJldDsNCj4gIA0KPiBAQCAtMTk1OCw2ICsxOTYwLDggQEAgc3RhdGlj
IGNvbnN0IHN0cnVjdCBkc2Ffc3dpdGNoX29wcyBydGw4MzY1bWJfc3dpdGNoX29wcyA9IHsNCj4g
IAkuZ2V0X3RhZ19wcm90b2NvbCA9IHJ0bDgzNjVtYl9nZXRfdGFnX3Byb3RvY29sLA0KPiAgCS5z
ZXR1cCA9IHJ0bDgzNjVtYl9zZXR1cCwNCj4gIAkudGVhcmRvd24gPSBydGw4MzY1bWJfdGVhcmRv
d24sDQo+ICsJLnBoeV9yZWFkID0gcnRsODM2NW1iX3BoeV9yZWFkLA0KPiArCS5waHlfd3JpdGUg
PSBydGw4MzY1bWJfcGh5X3dyaXRlLA0KPiAgCS5waHlsaW5rX3ZhbGlkYXRlID0gcnRsODM2NW1i
X3BoeWxpbmtfdmFsaWRhdGUsDQo+ICAJLnBoeWxpbmtfbWFjX2NvbmZpZyA9IHJ0bDgzNjVtYl9w
aHlsaW5rX21hY19jb25maWcsDQo+ICAJLnBoeWxpbmtfbWFjX2xpbmtfZG93biA9IHJ0bDgzNjVt
Yl9waHlsaW5rX21hY19saW5rX2Rvd24sDQo+IEBAIC0xOTc0LDggKzE5NzgsNiBAQCBzdGF0aWMg
Y29uc3Qgc3RydWN0IGRzYV9zd2l0Y2hfb3BzIHJ0bDgzNjVtYl9zd2l0Y2hfb3BzID0gew0KPiAg
DQo+ICBzdGF0aWMgY29uc3Qgc3RydWN0IHJlYWx0ZWtfb3BzIHJ0bDgzNjVtYl9vcHMgPSB7DQo+
ICAJLmRldGVjdCA9IHJ0bDgzNjVtYl9kZXRlY3QsDQo+IC0JLnBoeV9yZWFkID0gcnRsODM2NW1i
X3BoeV9yZWFkLA0KPiAtCS5waHlfd3JpdGUgPSBydGw4MzY1bWJfcGh5X3dyaXRlLA0KPiAgfTsN
Cj4gIA0KPiAgY29uc3Qgc3RydWN0IHJlYWx0ZWtfdmFyaWFudCBydGw4MzY1bWJfdmFyaWFudCA9
IHsNCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2RzYS9yZWFsdGVrL3J0bDgzNjZyYi5jIGIv
ZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWsvcnRsODM2NnJiLmMNCj4gaW5kZXggZmY2MDc2MDhkZWFk
Li40NTc2ZjliNzk3YzUgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2RzYS9yZWFsdGVrL3J0
bDgzNjZyYi5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2RzYS9yZWFsdGVrL3J0bDgzNjZyYi5jDQo+
IEBAIC0xNjQxLDggKzE2NDEsOSBAQCBzdGF0aWMgaW50IHJ0bDgzNjZyYl9lbmFibGVfdmxhbjRr
KHN0cnVjdCByZWFsdGVrX3ByaXYgKnByaXYsIGJvb2wgZW5hYmxlKQ0KPiAgCQkJCSAgZW5hYmxl
ID8gUlRMODM2NlJCX1NHQ1JfRU5fVkxBTl80S1RCIDogMCk7DQo+ICB9DQo+ICANCj4gLXN0YXRp
YyBpbnQgcnRsODM2NnJiX3BoeV9yZWFkKHN0cnVjdCByZWFsdGVrX3ByaXYgKnByaXYsIGludCBw
aHksIGludCByZWdudW0pDQo+ICtzdGF0aWMgaW50IHJ0bDgzNjZyYl9waHlfcmVhZChzdHJ1Y3Qg
ZHNhX3N3aXRjaCAqZHMsIGludCBwaHksIGludCByZWdudW0pDQo+ICB7DQo+ICsJc3RydWN0IHJl
YWx0ZWtfcHJpdiAqcHJpdiA9IGRzLT5wcml2Ow0KPiAgCXUzMiB2YWw7DQo+ICAJdTMyIHJlZzsN
Cj4gIAlpbnQgcmV0Ow0KPiBAQCAtMTY3NSw5ICsxNjc2LDEwIEBAIHN0YXRpYyBpbnQgcnRsODM2
NnJiX3BoeV9yZWFkKHN0cnVjdCByZWFsdGVrX3ByaXYgKnByaXYsIGludCBwaHksIGludCByZWdu
dW0pDQo+ICAJcmV0dXJuIHZhbDsNCj4gIH0NCj4gIA0KPiAtc3RhdGljIGludCBydGw4MzY2cmJf
cGh5X3dyaXRlKHN0cnVjdCByZWFsdGVrX3ByaXYgKnByaXYsIGludCBwaHksIGludCByZWdudW0s
DQo+ICtzdGF0aWMgaW50IHJ0bDgzNjZyYl9waHlfd3JpdGUoc3RydWN0IGRzYV9zd2l0Y2ggKmRz
LCBpbnQgcGh5LCBpbnQgcmVnbnVtLA0KPiAgCQkJICAgICAgIHUxNiB2YWwpDQo+ICB7DQo+ICsJ
c3RydWN0IHJlYWx0ZWtfcHJpdiAqcHJpdiA9IGRzLT5wcml2Ow0KPiAgCXUzMiByZWc7DQo+ICAJ
aW50IHJldDsNCj4gIA0KPiBAQCAtMTc2OSw2ICsxNzcxLDggQEAgc3RhdGljIGludCBydGw4MzY2
cmJfZGV0ZWN0KHN0cnVjdCByZWFsdGVrX3ByaXYgKnByaXYpDQo+ICBzdGF0aWMgY29uc3Qgc3Ry
dWN0IGRzYV9zd2l0Y2hfb3BzIHJ0bDgzNjZyYl9zd2l0Y2hfb3BzID0gew0KPiAgCS5nZXRfdGFn
X3Byb3RvY29sID0gcnRsODM2Nl9nZXRfdGFnX3Byb3RvY29sLA0KPiAgCS5zZXR1cCA9IHJ0bDgz
NjZyYl9zZXR1cCwNCj4gKwkucGh5X3JlYWQgPSBydGw4MzY2cmJfcGh5X3JlYWQsDQo+ICsJLnBo
eV93cml0ZSA9IHJ0bDgzNjZyYl9waHlfd3JpdGUsDQo+ICAJLnBoeWxpbmtfbWFjX2xpbmtfdXAg
PSBydGw4MzY2cmJfbWFjX2xpbmtfdXAsDQo+ICAJLnBoeWxpbmtfbWFjX2xpbmtfZG93biA9IHJ0
bDgzNjZyYl9tYWNfbGlua19kb3duLA0KPiAgCS5nZXRfc3RyaW5ncyA9IHJ0bDgzNjZfZ2V0X3N0
cmluZ3MsDQo+IEBAIC0xODAxLDggKzE4MDUsNiBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IHJlYWx0
ZWtfb3BzIHJ0bDgzNjZyYl9vcHMgPSB7DQo+ICAJLmlzX3ZsYW5fdmFsaWQJPSBydGw4MzY2cmJf
aXNfdmxhbl92YWxpZCwNCj4gIAkuZW5hYmxlX3ZsYW4JPSBydGw4MzY2cmJfZW5hYmxlX3ZsYW4s
DQo+ICAJLmVuYWJsZV92bGFuNGsJPSBydGw4MzY2cmJfZW5hYmxlX3ZsYW40aywNCj4gLQkucGh5
X3JlYWQJPSBydGw4MzY2cmJfcGh5X3JlYWQsDQo+IC0JLnBoeV93cml0ZQk9IHJ0bDgzNjZyYl9w
aHlfd3JpdGUsDQo+ICB9Ow0KPiAgDQo+ICBjb25zdCBzdHJ1Y3QgcmVhbHRla192YXJpYW50IHJ0
bDgzNjZyYl92YXJpYW50ID0gew==
