Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFB2446D349
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 13:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233327AbhLHMcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 07:32:47 -0500
Received: from mail-vi1eur05on2108.outbound.protection.outlook.com ([40.107.21.108]:41185
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233310AbhLHMcq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 07:32:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DdOBUeUKdGtg4OtQcuMowFt4O//rA+KIoedaJ3TEjPchj6G7UutIMm0NF5Pzj+G/5+sgHK/sH43we38XjbPr/UijDZM4Fj+MD9/THKM/gOcsiQOniifrUWLFukvJgCF4gRziZptDIcTD5N5aC6LFJKHpBYgU+5EINC2eiHTp2BYPcUXg+NVC4wfoEsFAaBJxOjBSHjdvuroE54n5je2NfDCZSjtiFLPjHEKy0liWfbYEZPlzhdTBDwf7w6KtAarIwY69uP8YNLGWjNrg2QgAoW+uf04HJD6GxMJK4JJ17UGvu55hhuEs/XxXuORo2W3et1tTd8rV8uhP1bgIHBwYnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DmoREJ7a0QmM4VD57Vqf8hC/ZI96VB5e6SElZXCWYqU=;
 b=G0pCW8KiL5ATbCKfgL3frU8sUXUT49blLIZJuPjMnVrFZn3o4gEBVBTbGk0SqmztPCvQ4gWvQMnTbSoQnDL3AACkRvwIEOUgDn6wVoNyCMhEctzOVkeW+r3GBOmHDA48/FmuDwyt/nISfxbScq1rVqcoPGVZveY2Xll+p9t0PvkwM4tzL1gw0rgCXQBCe8vWuGOszbTessc6yPHQMJb0X46HSZBM5TomRkH0tlKaGh0iaXUImQrJVR06N+KL2R06zsLV/FjuM2CwpKNqXXzddAW/jNW0FRIUKK6FpPMxeoUM3qYE4cua92H+5NMhj6rMHO4hg+CJ0/Wh1zI6t5/h2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hitachienergy.com; dmarc=pass action=none
 header.from=hitachienergy.com; dkim=pass header.d=hitachienergy.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hitachienergy.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DmoREJ7a0QmM4VD57Vqf8hC/ZI96VB5e6SElZXCWYqU=;
 b=iAzGNT/qHvR6unZ61e5O/AkCfYx2orXrriOALc9ngHC0qn3LNNRNCbGGQmDDcBdS1iL0ftmVqdXDgtpD8wy07q2p/IQWPakrqFS7x+iHN17haFi78QQXqktn3fflMRTfXr4AO6+1OKBkGLXEE/n6bZVkk0K/SNmj+qqZCzldu05ItYwhHUeMx/+/pC0/8OaJL363tQQx99wF/Kn7xqpXAeQGm7bcJJ1Xci52aJgh2xDc2NjEc2/MY9T/GI9eO7yn8Ez6Q3F97dQfTXMNHSEEycqTp0aiT5/5EWJlKCaT/1rRfMwlZUJCIr0v91j8kq27YbvasNFUxW1qwnQ+3isbpA==
Received: from AM6PR0602MB3671.eurprd06.prod.outlook.com
 (2603:10a6:209:20::29) by AM5PR0602MB2964.eurprd06.prod.outlook.com
 (2603:10a6:203:9d::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Wed, 8 Dec
 2021 12:29:13 +0000
Received: from AM6PR0602MB3671.eurprd06.prod.outlook.com
 ([fe80::605f:9ed6:73fb:235a]) by AM6PR0602MB3671.eurprd06.prod.outlook.com
 ([fe80::605f:9ed6:73fb:235a%7]) with mapi id 15.20.4755.022; Wed, 8 Dec 2021
 12:29:13 +0000
From:   Holger Brunck <holger.brunck@hitachienergy.com>
To:     =?utf-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: RE: [v3 2/2] dsa: mv88e6xxx: make serdes SGMII/Fiber output amplitude
 configurable
Thread-Topic: [v3 2/2] dsa: mv88e6xxx: make serdes SGMII/Fiber output
 amplitude configurable
Thread-Index: AQHX6525E9BoIskIRkqx58mIW7K4x6wnabuAgAEYVdA=
Date:   Wed, 8 Dec 2021 12:29:13 +0000
Message-ID: <AM6PR0602MB3671CC1FE1D6685FE2A503A6F76F9@AM6PR0602MB3671.eurprd06.prod.outlook.com>
References: <20211207190730.3076-1-holger.brunck@hitachienergy.com>
        <20211207190730.3076-2-holger.brunck@hitachienergy.com>
 <20211207202733.56a0cf15@thinkpad>
In-Reply-To: <20211207202733.56a0cf15@thinkpad>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-processedbytemplafy: true
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hitachienergy.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5029ef64-cb88-471d-15f5-08d9ba4657df
x-ms-traffictypediagnostic: AM5PR0602MB2964:EE_
x-microsoft-antispam-prvs: <AM5PR0602MB2964F699BE80A1E7DF10C391F76F9@AM5PR0602MB2964.eurprd06.prod.outlook.com>
x-he-o365-outbound: HEO365Out
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fZNhiwbzwCRQlNDC3ZCOaVHO5V07KKnIKhio4k9ItVjoQ4ukmcfgfw4pBsax256Qky323zkzBGeN0V+cuhZcWFhHsnzLjqTfy2B0B3gwvR5wSSTfirsKFAX8EvlN9+epWDuyItOrHdB/p0Ms3ioy+IsnFgh8dJ2aauJ3zf5pTuOjJ86tsdgELi/Fh1CJseYuAX1HIicbf0iXAqqaDnbviWl5sq/oopqfYHlAOwumovkcVdKjA8V3unLb2kktY3uQdKk7dKrT6QSTFGB5ybwEB0FSR67pqRnN5GxikhwVXi130Ft+Qb54Lhc1HvYllAi8Rsgp5C9zA28SA/zw/RJkCqSgSf98CDqInJYxkoYN7bX+NraR3Z1kHDdoYLqS4VtIB/5ajPjByxWQlqXCKm8nemhUk5BKVYAgy9r5aApMd73HZ4iPPgFZbTSLcXk7GweOdnT+zeApbXJM/4nB16/utxShWE0dKuFCWBLd3StP5+u3A0Hifeq5u8tOhm7nxcFLt1+Pmpz+JmqnbVVdy/UPQ8+Kbx61tJcd8k6A8wq0GnwRcmg45H8qHWvGrke2oK+DJOFRjtN387t/kVwXdcOtisEeK4MP+wrUnPB0sSxnWUJr1rrEPDHJj6d8VOc0mtrMNWLxYhh68F9rqJZd0fjm8y8fxsmO+7VkspOFKUCSRdgGMboVBPieAXu/veTDO4/62jhIEDKcQFTr2PBE5YlX0Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0602MB3671.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66446008)(9686003)(86362001)(38070700005)(66476007)(66556008)(64756008)(6916009)(26005)(186003)(7696005)(6506007)(2906002)(52536014)(55016003)(66946007)(8936002)(54906003)(4326008)(316002)(8676002)(5660300002)(82960400001)(38100700002)(508600001)(33656002)(71200400001)(76116006)(44832011)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MHdkQUpocFl5WFBWRGpseG5QSTM0bW8vZGVJNGpMVXl0ZjlQeUJHRjBTRUNK?=
 =?utf-8?B?VHI5UTZoOURlUzI5TlVycFh3VzlSRmc0UGw0K1QrVjBMUjR6MjA2OXRZVklu?=
 =?utf-8?B?bzBGeVBiNHkvbzFJSmc3ZEgrdGZlcEREUVJ3dXoyV2Q2cGM2dG5zRFpuR3px?=
 =?utf-8?B?Wi9BV0lDZVNoNWsycDJJTVlsZUdvVlB3cGwvSVNNTVBOMlBmKzZyOXAyUi9M?=
 =?utf-8?B?bjAvcWt6S0VKWVFFWFkwWTZpOWpTRkhiR28zVEUyb3BzaWlONUVOKytIY25l?=
 =?utf-8?B?ODlDK3pydUV4UEFuYlU5T3BWS0JLREdpMURML0pHQ3Qxc0hrbGRYZ2pObCta?=
 =?utf-8?B?VWZVRytadjdpRkRNNjVjWXVJQTFESjRFN1BqRHk5MDRMZm93ajJkUjVSSTJz?=
 =?utf-8?B?c3h1dXlEa2cvRkUrc0hJd1NqenBNWHdVU3hXNGZqTDlwWjRZajlWNFpXYnZs?=
 =?utf-8?B?VUtocVhIK2Jqd2N5UjFHY096ZVJ2a3R4a0pxelFNOUhWTitCM29jeXBPdzVp?=
 =?utf-8?B?Wk9EZ1YweUUvL2NmeW1QTThuNlBvWFVuemErZ1pac2NpSFhqR0h1V3pEWlFW?=
 =?utf-8?B?bWsrZFdwMVVVelhGK0NhOXhBUGxTV05NL2hTL284WWpxQkpJc2hEdzVTeXVw?=
 =?utf-8?B?Q2RhenNIWDg4MnJhelo0aDVxL1Y5a3laYTBJWkorNTlmaENuNmNpdThqdkc0?=
 =?utf-8?B?dHFwY2VIUjRwelg1aGREUlFxdkQwSXRKVHZsenhNZ2VKSHAycWxGalphNUFV?=
 =?utf-8?B?Z0JaNE9HcEY1eXZsekZsNTN3RkROK1VJMGdKckRxdE9QbEd3NjQrUXVaNExX?=
 =?utf-8?B?Y1VYZHk4L3U4alRrb3BXR3d1VGR1VzZxV0Z6SXJNbUdXR1JmVk4xMTduaGVh?=
 =?utf-8?B?WGtUNEdnUFRybHRNM0R0ZWNjRzk3ZzdyUDZaZGVmT252amtjenBDTTZVTXMv?=
 =?utf-8?B?Y1Y2VDdyRnlUNm1Da1Zsb1N0M3NIRUdpejR6WGQwd3BGeFhnanVLbkNCZWJw?=
 =?utf-8?B?YWhjaFNKN0lvUUNFaHRyT2w5L0Nkemc1SVpzcG5sZEdaTGhuTm8weHVSUGlF?=
 =?utf-8?B?MEpCeFU3end3WjhGWTFxRko5L0lvSEtQZEpRQk8rbC92MmxOTkh2QWdaYTZV?=
 =?utf-8?B?aWZGYmdSSTNTMWFkWUY2SlpLeGdWSnlZem9EaWd4YjB4TDM3cmpYMER4MG45?=
 =?utf-8?B?Z3pDTmtUNmdpK3NHSnV5LzVwcit4OTd3QUhRV1FzdjlnTXdDYjR5elZyRzMw?=
 =?utf-8?B?QmZUU3lWMTdDbUdkc2lJSU5pVWtjQmE2K3NyanQ4dmRVazMzdUhpZG1EaFNw?=
 =?utf-8?B?RnNXSkcxd2l4eDZuWnNoRDRxbjRsVEFXT1dwZ2x2OW9WMlZoN0JsMExSZEpj?=
 =?utf-8?B?T2NSUDhoaGVDbVBhYXZvUHhLc0FTd0oybTQ1S0JkQUREWVJ3NFhTMjlWZ0p6?=
 =?utf-8?B?b0doQnRuVG1pQ1ROMzF5YWxaemI1U1doOEExK0tvaldYdHdJdk5EM3ZxMG9n?=
 =?utf-8?B?dXU3VklmSmlVcUY3S2t1eDNhbVVuYk85NC9UUmM3OERYbDRwSkNoVTM3VEMy?=
 =?utf-8?B?cGZCMWhsQS9ObEEveWxCNGgrUjBhM2NQTUNyVS9SaVN5OFBsSDJWOUtRNG1K?=
 =?utf-8?B?QVdVQnNva3h4T3gzVUl6UnZ3UHNXaHRTY0p6OXpVUVNRczNyNFpUYXJsbjF4?=
 =?utf-8?B?MGZpd0JyWDJzbW53eTU4L3VCbkt5VE1EdUc2cmZVRnJGbUZmaUMrbGEwaVp4?=
 =?utf-8?B?NC9qOFBLWlprem10RlArQU1kL3NhQ21aclpVR1BjL1R1eVlubmN0ekhCNmhF?=
 =?utf-8?B?RnlEa1prZG5EWmhJaEVUUHUvMkQ3V1BKVEFTbGYrUnJWUFc1R0RvRERnR2o1?=
 =?utf-8?B?T3Z5enczUFNRemJ1UFJmUjhlcVZNWlVpY1RweUVqK3VYSG1ObkpJVUJzaHd4?=
 =?utf-8?B?N21iem9HQ3BkYlYwWm9LVkVpYTFsMVlRYVlQSEFKTjJ2SjF0UE1MeStaRHJI?=
 =?utf-8?B?c0VKNXpDd29wSExBUmpWSENZdGxiVDZSVmJtclpidHEzTko0eldLR29zZlJI?=
 =?utf-8?B?Qy9LZ2JrTEp0dTg1RzFJQzBnZmsyUDR6bVcvdmh5eHVTUGJWTFVvWm5hcE5a?=
 =?utf-8?B?Rk1DbkxERkl4dVltd1hZbE8vNlF6RlNoanFOUGM5WW10dWZuRjRMT1pIcGhi?=
 =?utf-8?B?dmRSKzZraUc5OU85WnY0TTMxK0J3NDhBc25UeTFXRUswQ1I4V2MxTkZ2d0Rv?=
 =?utf-8?B?Y21FaGxSd0JQVkMvK2xHSldrY0tRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hitachienergy.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR0602MB3671.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5029ef64-cb88-471d-15f5-08d9ba4657df
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2021 12:29:13.3061
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7831e6d9-dc6c-4cd1-9ec6-1dc2b4133195
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 43gHmHzofpsdLEQnrknch1icZPk0Yy8soIK2zk+mj4uACCVf3Tbtutlh4r6l+/K2olaLD6tcPgjWccF55MH2bm/codqwXhP77gkbm3CKj8s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0602MB2964
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWFyZWssDQoNCj4gPiBUaGUgbXY4OGU2MzUyLCBtdjg4ZTYyNDAgYW5kIG12ODhlNjE3NiAg
aGF2ZSBhIHNlcmRlcyBpbnRlcmZhY2UuIFRoaXMNCj4gPiBwYXRjaCBhbGxvd3MgdG8gY29uZmln
dXJlIHRoZSBvdXRwdXQgc3dpbmcgdG8gYSBkZXNpcmVkIHZhbHVlIGluIHRoZQ0KPiA+IGRldmlj
ZXRyZWUgbm9kZSBvZiB0aGUgcG9ydC4gQXMgdGhlIGNoaXBzIG9ubHkgc3VwcG9ydHMgZWlnaHQN
Cj4gPiBkZWRpY2F0ZWQgdmFsdWVzIHdlIHJldHVybiBFSU5WQUwgaWYgdGhlIHZhbHVlIGluIHRo
ZSBEVFMgZG9lcyBub3QgbWF0Y2guDQo+ID4NCj4gPiBDQzogQW5kcmV3IEx1bm4gPGFuZHJld0Bs
dW5uLmNoPg0KPiA+IENDOiBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPg0KPiA+IEND
OiBNYXJlayBCZWjDum4gPGthYmVsQGtlcm5lbC5vcmc+DQo+ID4gU2lnbmVkLW9mZi1ieTogSG9s
Z2VyIEJydW5jayA8aG9sZ2VyLmJydW5ja0BoaXRhY2hpZW5lcmd5LmNvbT4NCj4gDQo+IEhvbGdl
ciwgQW5kcmV3LA0KPiANCj4gdGhlcmUgaXMgYW5vdGhlciBpc3N1ZSB3aXRoIHRoaXMsIHdoaWNo
IEkgb25seSByZWFsaXplZCB5ZXN0ZXJkYXkuIFdoYXQgaWYgdGhlDQo+IGRpZmZlcmVudCBhbXBs
aXR1ZGUgbmVlZHMgdG8gYmUgc2V0IG9ubHkgZm9yIGNlcnRhaW4gU2VyRGVzIG1vZGVzPw0KPiAN
Cj4gSSBhbSBicmluZ2luZyB0aGlzIHVwIGJlY2F1c2UgSSBkaXNjb3ZlcmVkIHRoYXQgb24gVHVy
cmlzIE1veCB3ZSBuZWVkIHRvDQo+IGluY3JlYXNlIFNlckRlcyBvdXRwdXQgYW1wbGl0dWRlIHdo
ZW4gQTM3MjAgU09DIGlzIGNvbm5lY3RlZCBkaXJlY3RseSB0bw0KPiA4OEU2MTQxIHN3aXRjaCwg
YnV0IG9ubHkgZm9yIDI1MDBiYXNlLXggbW9kZS4gRm9yIDEwMDBiYXNlLXgsIHRoZSBkZWZhdWx0
DQo+IGFtcGxpdHVkZSBpcyBva2F5LiAoQWxzbyB3aGVuIHRoZSBTT0MgaXMgY29ubmVjdGVkIHRv
IDg4RTYxOTAsIHRoZSBhbXBsaXR1ZGUNCj4gZG9lcyBub3QgbmVlZCB0byBiZSBjaGFuZ2VkIGF0
IGFsbC4pDQo+IA0KDQpvbiBteSBib2FyZCBJIGhhdmUgYSBmaXhlZCBsaW5rIGNvbm5lY3RlZCB3
aXRoIFNHTUlJIGFuZCB0aGVyZSBpcyBubyBkZWRpY2F0ZWQNCnZhbHVlIGdpdmVuIGluIHRoZSBt
YW51YWwuDQoNCj4gSSBwbGFuIHRvIHNvbHZlIHRoaXMgaW4gdGhlIGNvbXBoeSBkcml2ZXIsIG5v
dCBpbiBkZXZpY2UtdHJlZS4NCj4gDQo+IEJ1dCBpZiB0aGUgc29sdXRpb24gaXMgdG8gYmUgZG9u
ZSBpbiBEVFMsIHNob3VsZG4ndCB0aGVyZSBiZSBhIHBvc3NpYmlsaXR5IHRvIGRlZmluZQ0KPiB0
aGUgYW1wbGl0dWRlIGZvciBhIHNwZWNpZmljIHNlcmRlcyBtb2RlIG9ubHk/DQo+IA0KPiBGb3Ig
ZXhhbXBsZQ0KPiAgIHNlcmRlcy0yNTAwYmFzZS14LXR4LWFtcGxpdHVkZS1taWxsaXZvbHQNCj4g
b3INCj4gICBzZXJkZXMtdHgtYW1wbGl0dWRlLW1pbGxpdm9sdC0yNTAwYmFzZS14DQo+IG9yDQo+
ICAgc2VyZGVzLXR4LWFtcGxpdHVkZS1taWxsaXZvbHQsMjUwMGJhc2UteA0KPiA/DQo+IA0KPiBX
aGF0IGRvIHlvdSB0aGluaz8NCj4gDQoNCmluIHRoZSBkYXRhIHNoZWV0IGZvciB0aGUgTVY2MzUy
IEkgYW0gdXNpbmcgdGhlcmUgYXJlIG5vIGRlZGljYXRlZCB2YWx1ZXMgc3RhdGVkIGZvcg0KZGlm
ZmVyZW50IG1vZGVzIGF0IGFsbCwgdGhleSBjYW4gYmUgY2hvc2VuIGFyYml0cmFyeS4gU28gaW4g
bXkgY2FzZSBJIHRoaW5rIGl0IG1ha2VzDQpzZW5zZSB0byBrZWVwIGl0IGFzIGl0IGlzIGZvciBu
b3cuIE90aGVyIGRyaXZlciBtYXkgaGF2ZSBvdGhlciBuZWVkcyBhbmQgbWF5IGVuaGFuY2UNCnRo
aXMgbGF0ZXIgb24uDQogDQpCZXN0IHJlZ2FyZHMNCkhvbGdlciAgIA0K
