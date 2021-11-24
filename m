Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E61245B869
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 11:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241151AbhKXKgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 05:36:39 -0500
Received: from mail-psaapc01on2133.outbound.protection.outlook.com ([40.107.255.133]:65152
        "EHLO APC01-PSA-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233492AbhKXKgi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 05:36:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HFvEaALVbRhhjHII6+nGEJn8qxzL5y3oKJWUyRluUn02p4rIP4YXJsphzCbskyShXwturLnt+VwiDAR1EhYvINg83p5dFoDGjlwQwQGRP5zS5Q/MqVosWzKmZD1LuiCDiuvS+g6bWC/cchxZK2VLz/bDe1IFM9PmbnWlDXYcJLYYmDsYgPIYV59+FpiAR/rzKz7k+CkOaZT9YSxPueMNbGEdBvX8bjGXHnnZB0ppPWg61AhwhQXt+3hxJqB39YeHzgzFDWG5hTKvkfYug2vlnXqcK5RJGfkNygOOIjPkcePo33irs1GMtQ1IW3dpOo9fqzpX20fiVjD7vk4h1lgv2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q0jNHgRnOEHlsqXXHLtDCEfb3ZZBCYqEukgdw/pJJMI=;
 b=LvRTrJVFBG5n49qeBjV+KgCSLqVXK7suzabQGPwOkqislN5JCaWOY+08QdJCbS2pdp7fO/HBs5RoslyWdrWTKvlUs+CNQTfoAWvrjtEMPLPhL1s+0dC9Y0xXnumTNSteFDS+Rlz7Lv16snVjtgEda+2OwpJCHbACJe6VC/1gHkamkcLNHrI2MdZ0iPJfrJ1WB5+lGvpOhQ90GK/Ar4zZfyH5vybdP7QiVIqaRsH48GKg25gwi/SfRnh5ay2u6q4evOKcOeAqjl7JKy7reOlGNORhdyAKiJV97sg5ZotqrjMMEdBG0utEVFim/t0M7BFy0Hea9Y3CeLyq1lanf6SEsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aspeedtech.com; dmarc=pass action=none
 header.from=aspeedtech.com; dkim=pass header.d=aspeedtech.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aspeedtech.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q0jNHgRnOEHlsqXXHLtDCEfb3ZZBCYqEukgdw/pJJMI=;
 b=bmuXdd69sMQil461TC7vCX40h3T4gCe+UM7DFlcuNqIdCxEqT8g4CDVEp+YmQiTIr9s4u/2qIvjYnavsZatF+WVZF/5F70fbc0JjQpfJerbxRkdOE7YXo0SGchwEw7IocyCKO5I+VvE12XeDcdqWn1xOnZITVFZR53Xsw15QuVClHmnjzha+W/cbDBvCZI8JsWuemrczwkrdhD90SvcIEfvJBkHJ1NeUZvjTtGLoUaFg1A+ntA8F8M+bqbZLIqEGtZFtOHFEpCtGWe2BMzpt0D9ehFr4qdMK9iw3aSmVZDM9aKkFBhfW1b1yPhmo+dFQQrIGt7uh6O9TPk2zga50dA==
Received: from HK0PR06MB2834.apcprd06.prod.outlook.com (2603:1096:203:5c::20)
 by HK0PR06MB3377.apcprd06.prod.outlook.com (2603:1096:203:8b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Wed, 24 Nov
 2021 10:33:25 +0000
Received: from HK0PR06MB2834.apcprd06.prod.outlook.com
 ([fe80::3c8b:f0ed:47b2:15f5]) by HK0PR06MB2834.apcprd06.prod.outlook.com
 ([fe80::3c8b:f0ed:47b2:15f5%6]) with mapi id 15.20.4713.026; Wed, 24 Nov 2021
 10:33:25 +0000
From:   Dylan Hung <dylan_hung@aspeedtech.com>
To:     Joel Stanley <joel@jms.id.au>
CC:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Networking <netdev@vger.kernel.org>,
        Andrew Jeffery <andrew@aj.id.au>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, BMC-SW <BMC-SW@aspeedtech.com>
Subject: RE: [PATCH] net:phy: Fix "Link is Down" issue
Thread-Topic: [PATCH] net:phy: Fix "Link is Down" issue
Thread-Index: AQHX4PoOvlh8YFTKU0S4du3aOuQLJKwSc72AgAACTpA=
Date:   Wed, 24 Nov 2021 10:33:24 +0000
Message-ID: <HK0PR06MB2834489E23CA1F4281840D799C619@HK0PR06MB2834.apcprd06.prod.outlook.com>
References: <20211124061057.12555-1-dylan_hung@aspeedtech.com>
 <CACPK8Xc8aD8nY0M442=BdvrpRhYNS1HW7BNQgAQ+ExTfQMsMyQ@mail.gmail.com>
In-Reply-To: <CACPK8Xc8aD8nY0M442=BdvrpRhYNS1HW7BNQgAQ+ExTfQMsMyQ@mail.gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=aspeedtech.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 44732a94-b0c3-4075-f9ff-08d9af35d884
x-ms-traffictypediagnostic: HK0PR06MB3377:
x-microsoft-antispam-prvs: <HK0PR06MB3377BEB045622B9A36EBF8A69C619@HK0PR06MB3377.apcprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZAQswZToBjxkQku2mlEPztk1E24FCJGTrwb5at92gjbPAyO/PwM67Pehw9OB14vH7qaS8Jt9nCSzz9abJQMKaKqAsZhsSVDXtsTnKI34gGSgRYdGV3OCcSYQo70DhdkU5TOGDCwJ0sWcmK9ZEnoztW/8mVkRWI/wooq//aBpGYFaDaXTl/yqW0UgTrzKOWSudUUb2rtz3lEI0CzaZzW3nTqGSZunmuRx9RyV1nLLrrZVFxkKuXwZQrB/5Na4t3EYj3bLzqorakVOKl8qHYMRFAgETYhl1Jg5JeimCW0Jw2AkitbelAv7ufqhAelfJEGwWIu8VMBbizHytqjDdmEmdT11ADVbMQ4hf6mfMc4W/vIBhjet+lJYHg+qY+JVcYAxf5/A9p75AfGjZD4vTmoCRyL0sMNnNR2piAK4xkOEnVDPXRSTk4RBE4GKWAsxCE2YcxDZeL8/7gpOt0XVR+ImPIwsDaSk1Cld1pK/zm0LOhIixbVtDPKlJdzjEr4OFrEEnPytFQH+iNHv08+QYvtJizkTKX6K41QiOgCeVO2DuUoK5qqyZsl5fPyrVx5tO0RXI3uSnAu9BwR3pj0NzN79F7KXe/hxXd7KDUTZBFcn7wub7sonJC2UmrcSzOuGpKseAe52+MvJ0gJCSQa2IplbC/f3IdzGS7whjCNHXSEhem10MIJkndts+LzAsoADvQDbFzH4TP2y+cCTYiKl0EYnsw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0PR06MB2834.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(366004)(376002)(396003)(346002)(136003)(107886003)(76116006)(508600001)(7696005)(316002)(5660300002)(83380400001)(55016003)(4326008)(33656002)(7416002)(71200400001)(26005)(8936002)(38070700005)(53546011)(86362001)(186003)(6506007)(9686003)(54906003)(66476007)(66556008)(64756008)(66446008)(66946007)(6916009)(2906002)(38100700002)(122000001)(8676002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZzhUaERWSUpDYnBCdFkyT291cVdacFp5R0k0SUtPODY0UGpZYkhzU0pKYzVL?=
 =?utf-8?B?Zm5ZU04ybS83MHJTZjc3TUxnN3FPSXdSTkl4akUrSVNzc05jZFpWL1FZTTVC?=
 =?utf-8?B?ZW5FZ3FuV1hxaVJIV2xVYjJhWXlJTVAxblVyUHdOTUpVVXlOVVNYL2tOQWJW?=
 =?utf-8?B?TjFIZmVHc01kZVdUMzBLc25HdWhHNW9TQVVxd3FSczVyNFZoNlU1Z0VLcm5R?=
 =?utf-8?B?Z3BhTWhtRVhPM0tJc09GdXFiaTQ5K3orZWIvREJzdi9aMTJXa21MNnVMdHV6?=
 =?utf-8?B?Y2pYZ1pINkEzanBOQmpuOU51bGl2L2twQjFuOFJMeU5MTWVBNld5UDFDVkhB?=
 =?utf-8?B?clJHY2UwRzdxZE5CbjFMTjVNanFocWV4UWpnRUdiUjV6Z1p4SUo0TW0xbDJ6?=
 =?utf-8?B?ck9neHdQbVBmMDZXYWFTVHZ1T0x1b2dxZUVJSzd6UVE3ODU5QjZrTzFES0Fi?=
 =?utf-8?B?MElualVzQmhmR3VINFB6aHBXTHoxN1RBdHl2OFcxbG1xSEtSM1F4anB5UFJ2?=
 =?utf-8?B?bW9yLzRWRTFpc1dVMGMrMXF0Z0NKMTZ5ZVpzQ1ZJVG9PTEx5TDBETk5aeWZB?=
 =?utf-8?B?V2xqT1ZCMlZKT0dVVTczdzArakphb3oxR01zNkpQOURBMUVtbHUyQzFBL29R?=
 =?utf-8?B?Q1R3dzZkQkM5TFdiejB3OHNpVnFKTHliQTZXWVgySDNET1UwWE92Q25FUE1l?=
 =?utf-8?B?V2x5WjY3d3dhaXJnWlYwcHlGa0F0bnV1aFlPQnhXbVZVaUhNblozWllIWDVr?=
 =?utf-8?B?alp4WCtmNWlwNWYrVW9IcWdGRnRwRjVlM3BqTFIzaCtHd0xkdXV1OC9lVjI4?=
 =?utf-8?B?VEpBUlFMQTc1WE9KcXdmMkg2SmR4VkkxRjBPK0hFL1l1OGt6V3ZPM1FJTFg0?=
 =?utf-8?B?WlYxdWNkQWo3c0J2eFpxS1NVVDFpRjVLV0FpTDRLSUdWU2V3blJIRDZVZUlj?=
 =?utf-8?B?TUQ2R0NiWHZVamV5Rlc0cWpNR29PK2k2M3RJRk5IZnVCZnBtWitHc09uV0Zi?=
 =?utf-8?B?dy9PRHd5R2JPM1NkQ0hxN25oRitXbWhxcmh5YWhpUk1OZUZxeWNUQ0U4Sm5W?=
 =?utf-8?B?V0hEcVF5LzhxaVY5UCtrRm1ZaFBqTDRIcVVDL0hEU3NHOFdZK3Z1bVZ1VzFr?=
 =?utf-8?B?NDFWL0xiL0JhOHY2eXZ6UVZiTmp5K2lpQVEzQk90VUZkWENBWlZhcUtwZmVD?=
 =?utf-8?B?c1lPMENDV0tiTEczSVVJMFhONEVHSVpGSGhLWXBIVWR4QVJBNitYV0dOZ3hY?=
 =?utf-8?B?cE40U1cxWG9iU1lvWFp6L1h4bzE3WHdNekMwei9qcm9haWJPWnoybXZlZ3B4?=
 =?utf-8?B?OW5nTkZjVjBZcHFuVUlIa3VIOWxMd3dneHViS3dyTkV6RndzaU0xSTY4U1hV?=
 =?utf-8?B?Ym53TmhQWU1MZnNxNGtOMFViOHlINy8wd1lMbHZoeURhT093TnR2RUFYM2hq?=
 =?utf-8?B?eEJQNEl1MnRpK0R2T0tQbExBY2FUb216QlAwY0NjdXR5ODV3ZzZuZFFMSkxh?=
 =?utf-8?B?TUxpRUxuZ2JhaW5BVWUwcHhDdVZ0VGFCRnNrQXhubGZGVElaem9DK2hRSCtC?=
 =?utf-8?B?MXFFTmEreUsrV3Axa2tUUURBL3h0NEprbDJjOGY2VVpwT04zWDZ3elcveXBy?=
 =?utf-8?B?Q0VLY0lsOWR4RlRCZ28rQzFDcmh2UGp0eFRtc0pzN0RONzFzaHdmZTBwZm1G?=
 =?utf-8?B?UHBtbE9JSldsKzhlaGVIK2w0NTlpL3RSR0JYc0hUdlRsZG0xNnU1Sklmak1o?=
 =?utf-8?B?VThCVWQraW9Cc2tiL2dqL3IvTFU0aVlYR3dsOTNya0VNREdNc0s5REFZSVU4?=
 =?utf-8?B?aDB3OW8zenhRV0c2QkRVMXhkWDFoVDkxR2VSbysxYnlsb3FlU1lOVjJSUWZ4?=
 =?utf-8?B?OFNqNWM3UmNnVjZveEVMb2xhZ3RsUUprelBhdDRBWHBCOGZjTjFyMWhTS2FD?=
 =?utf-8?B?bnlRTUdOZS9jN3hzTlh6dFQ3M2lhcUlxcUlMTTRFUklzbzQzWk1GWkJqY2tu?=
 =?utf-8?B?Yml5ZWtwVWNRakVuZmNOWVhNVmp4OGVua3Z2Z1Q4S0JoYUtmOGZJQ3JsR1Rt?=
 =?utf-8?B?L2JmVVM2WERxV1h2R3lsSFBPazB4UjFPTzdTc1J5T1hMdXJIMUhEajN4Sm1D?=
 =?utf-8?B?K1VNaWxacTN4NCtxcDZZN092SVU2MGF4dXAwRkgvRW9rd0duakNhcWsyZkZR?=
 =?utf-8?B?RFAxZys0Y3YxSVgvRzk1NmE2STdhKzA4SUdvZGQvcXllNnBWeHRMSUVNYzh4?=
 =?utf-8?B?eTJIN3Z5WXQ2R1pjdmNranJia093PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aspeedtech.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HK0PR06MB2834.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44732a94-b0c3-4075-f9ff-08d9af35d884
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2021 10:33:24.9707
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43d4aa98-e35b-4575-8939-080e90d5a249
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bivEM69Ubeb18Wcc2i6sgpfVjWoXxF4aELIwdB+NySR8GLZZ3qozQ+SIwmVVggxddOu/la7qrgE9FJhmBvDLu26LqvXzZylVaTkxbwuW0w0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR06MB3377
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKb2VsIFN0YW5sZXkgW21haWx0
bzpqb2VsQGptcy5pZC5hdV0NCj4gU2VudDogMjAyMeW5tDEx5pyIMjTml6UgNjowNiBQTQ0KPiBU
bzogRHlsYW4gSHVuZyA8ZHlsYW5faHVuZ0Bhc3BlZWR0ZWNoLmNvbT4NCj4gQ2M6IExpbnV4IEtl
cm5lbCBNYWlsaW5nIExpc3QgPGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc+OyBsaW51eC1h
c3BlZWQNCj4gPGxpbnV4LWFzcGVlZEBsaXN0cy5vemxhYnMub3JnPjsgTGludXggQVJNDQo+IDxs
aW51eC1hcm0ta2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmc+OyBOZXR3b3JraW5nDQo+IDxuZXRk
ZXZAdmdlci5rZXJuZWwub3JnPjsgQW5kcmV3IEplZmZlcnkgPGFuZHJld0Bhai5pZC5hdT47IEph
a3ViIEtpY2luc2tpDQo+IDxrdWJhQGtlcm5lbC5vcmc+OyBEYXZpZCBTIC4gTWlsbGVyIDxkYXZl
bUBkYXZlbWxvZnQubmV0PjsgUnVzc2VsbCBLaW5nDQo+IDxsaW51eEBhcm1saW51eC5vcmcudWs+
OyBoa2FsbHdlaXQxQGdtYWlsLmNvbTsgQW5kcmV3IEx1bm4NCj4gPGFuZHJld0BsdW5uLmNoPjsg
Qk1DLVNXIDxCTUMtU1dAYXNwZWVkdGVjaC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0hdIG5l
dDpwaHk6IEZpeCAiTGluayBpcyBEb3duIiBpc3N1ZQ0KPiANCj4gT24gV2VkLCAyNCBOb3YgMjAy
MSBhdCAwNjoxMSwgRHlsYW4gSHVuZyA8ZHlsYW5faHVuZ0Bhc3BlZWR0ZWNoLmNvbT4NCj4gd3Jv
dGU6DQo+ID4NCj4gPiBUaGUgaXNzdWUgaGFwcGVuZWQgcmFuZG9tbHkgaW4gcnVudGltZS4gIFRo
ZSBtZXNzYWdlICJMaW5rIGlzIERvd24iIGlzDQo+ID4gcG9wcGVkIGJ1dCBzb29uIGl0IHJlY292
ZXJlZCB0byAiTGluayBpcyBVcCIuDQo+ID4NCj4gPiBUaGUgIkxpbmsgaXMgRG93biIgcmVzdWx0
cyBmcm9tIHRoZSBpbmNvcnJlY3QgcmVhZCBkYXRhIGZvciByZWFkaW5nDQo+ID4gdGhlIFBIWSBy
ZWdpc3RlciB2aWEgTURJTyBidXMuICBUaGUgY29ycmVjdCBzZXF1ZW5jZSBmb3IgcmVhZGluZyB0
aGUNCj4gPiBkYXRhIHNoYWxsIGJlOg0KPiA+IDEuIGZpcmUgdGhlIGNvbW1hbmQNCj4gPiAyLiB3
YWl0IGZvciBjb21tYW5kIGRvbmUgKHRoaXMgc3RlcCB3YXMgbWlzc2luZykgMy4gd2FpdCBmb3Ig
ZGF0YSBpZGxlDQo+ID4gNC4gcmVhZCBkYXRhIGZyb20gZGF0YSByZWdpc3Rlcg0KPiANCj4gSSBj
b25zdWx0ZWQgdGhlIGRhdGFzaGVldCBhbmQgaXQgZG9lc24ndCBtZW50aW9uIHRoaXMuIFBlcmhh
cHMgc29tZXRoaW5nIHRvIGJlDQo+IGFkZGVkPw0KV2Ugd2lsbCBhZGQgdGhpcyBzZXF1ZW5jZSBp
bnRvIHRoZSBkYXRhc2hlZXQsIHRoYW5rIHlvdS4NCj4gDQo+IFJldmlld2VkLWJ5OiBKb2VsIFN0
YW5sZXkgPGpvZWxAam1zLmlkLmF1Pg0KPiANCj4gPg0KPiA+IEZpeGVzOiBhOTc3MGVhYzUxMWEg
KCJuZXQ6IG1kaW86IE1vdmUgTURJTyBkcml2ZXJzIGludG8gYSBuZXcNCj4gPiBzdWJkaXJlY3Rv
cnkiKQ0KPiANCj4gSSB0aGluayB0aGlzIHNob3VsZCBiZToNCj4gDQo+IEZpeGVzOiBmMTYwZTk5
NDYyYzYgKCJuZXQ6IHBoeTogQWRkIG1kaW8tYXNwZWVkIikNCkkgd2lsbCBjaGFuZ2UgdGhpcyBp
biBWMi4NCj4gDQo+IFdlIHNob3VsZCBjYyBzdGFibGUgdG9vLg0KSSB3aWxsIGNoYW5nZSB0aGlz
IGluIFYyLg0KPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBEeWxhbiBIdW5nIDxkeWxhbl9odW5nQGFz
cGVlZHRlY2guY29tPg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL25ldC9tZGlvL21kaW8tYXNwZWVk
LmMgfCA3ICsrKysrKysNCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKQ0KPiA+
DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L21kaW8vbWRpby1hc3BlZWQuYw0KPiA+IGIv
ZHJpdmVycy9uZXQvbWRpby9tZGlvLWFzcGVlZC5jIGluZGV4IGNhZDgyMDU2OGY3NS4uOTY2YzNi
NGFkNTlkDQo+ID4gMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvbWRpby9tZGlvLWFzcGVl
ZC5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvbWRpby9tZGlvLWFzcGVlZC5jDQo+ID4gQEAgLTYx
LDYgKzYxLDEzIEBAIHN0YXRpYyBpbnQgYXNwZWVkX21kaW9fcmVhZChzdHJ1Y3QgbWlpX2J1cyAq
YnVzLA0KPiA+IGludCBhZGRyLCBpbnQgcmVnbnVtKQ0KPiA+DQo+ID4gICAgICAgICBpb3dyaXRl
MzIoY3RybCwgY3R4LT5iYXNlICsgQVNQRUVEX01ESU9fQ1RSTCk7DQo+ID4NCj4gPiArICAgICAg
IHJjID0gcmVhZGxfcG9sbF90aW1lb3V0KGN0eC0+YmFzZSArIEFTUEVFRF9NRElPX0NUUkwsIGN0
cmwsDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAhKGN0cmwgJiBBU1BFRURf
TURJT19DVFJMX0ZJUkUpLA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgQVNQ
RUVEX01ESU9fSU5URVJWQUxfVVMsDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBBU1BFRURfTURJT19USU1FT1VUX1VTKTsNCj4gPiArICAgICAgIGlmIChyYyA8IDApDQo+ID4g
KyAgICAgICAgICAgICAgIHJldHVybiByYzsNCj4gPiArDQo+ID4gICAgICAgICByYyA9IHJlYWRs
X3BvbGxfdGltZW91dChjdHgtPmJhc2UgKyBBU1BFRURfTURJT19EQVRBLCBkYXRhLA0KPiA+ICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZGF0YSAmIEFTUEVFRF9NRElPX0RBVEFfSURM
RSwNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIEFTUEVFRF9NRElPX0lOVEVS
VkFMX1VTLA0KPiA+IC0tDQo+ID4gMi4yNS4xDQo+ID4NCg==
