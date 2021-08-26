Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62E0C3F8D3C
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 19:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243197AbhHZRnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 13:43:03 -0400
Received: from mail-mw2nam10on2085.outbound.protection.outlook.com ([40.107.94.85]:29537
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231801AbhHZRnC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 13:43:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cjwiL02bWGOFG9BeeEjGn8AlBLul063nHzdu3AftM4l6RFDJDa7SKxvFT755s6rQySsW+dBC0HzFxTykq1kYLrwlm211fzmE7eQHDVZpa2qPnc0y3Cn8Viz/We5caUwWg5GAZ/0oec0xWOrAEn71mjBAMW2AQCVlF/cf/9zN+bxSvF1BS3QJMwWMzcrDhKUmQfE5VmU/J/yZ7YT3NZuXdgvR2qFLwsdWjlygVq/lP2zqxffG0DsnuY/EdIe6dnvuSwsXfojEf6VcXLPsKJm/2NUXeyCb+9jD//5DvOBAmnhkYzbe49HXZulTVmyxATq4F1S9hN84EbkPUV22cyeRxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tdU4dA8KWgbbSDgLX+XX+wiT4RWZ5s5NVbWmc6yXWL0=;
 b=S4ZHAcLX8yT+KWEY/2isAWfFR/ch2tO0tiZWzXOnWDrSNiKpK58xfQBlIuHUlUMlsm5NHejN1JntiImH3GSX7zpmSd4GQ7j+pQn7njFTVnz3L//U9a1j/nR/EVaOhdEPVTRRB6e3+47Hl8mX9RSQk2/R3oHu+ihoZTDhyN8ZqVNJpnmBDKUKhv5diKQ0zumW+SuB1pGbMhaGh0rliSEjhiXhTkWCCnosRRS6IbUwvrjQwM3klAfahK+4UaagV/KC+/OCIhI5v5eQTY61jeLyWVgS4yNsZy4KmGcCS5qiqV3zapkI4zxmH6Gfbxoeqgl1ljVD24/6ZI0PXNL0u8mL7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tdU4dA8KWgbbSDgLX+XX+wiT4RWZ5s5NVbWmc6yXWL0=;
 b=C0z3l9CrKBS7ts7bPG7NFl6/3fj4TgSsTHvxMrE9qijC0cRKcmt5WOMb8tpgSi8JAd/bQDsV9dqefp/dcac99PeDoSnRBZGUiXHeLnpDWr6+fg/iph4rQC8w6TiKYz0m9S9+4Zu/8jJkVmx6C1zLIHOcrRG09Gjv+Jz5Brw83AkC5H7i9ZlTI1GlbnhcHxQ6US3j8iYLi0Afb8qF0iiFRacghfz3VINt3i+6OQ7GmhiT/tJgVUFm0kWYXUp9u7CAEcxj6KrEvMBjdyS31G//hI/ZuvwNzk5IWfadC4Oay34TctOgHrJ1RF2anyFvbE29nOQWKJ0fDDSKXkHAIBUOwg==
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BYAPR12MB3637.namprd12.prod.outlook.com (2603:10b6:a03:da::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.23; Thu, 26 Aug
 2021 17:42:14 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::e000:8099:a5da:d74]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::e000:8099:a5da:d74%5]) with mapi id 15.20.4436.024; Thu, 26 Aug 2021
 17:42:14 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     Tariq Toukan <tariqt@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net] sch_htb: Fix inconsistency when leaf qdisc creation
 fails
Thread-Topic: [PATCH net] sch_htb: Fix inconsistency when leaf qdisc creation
 fails
Thread-Index: AQHXmnEmB6KSH0a8BkCSYMW5iQtDIKuF9QQAgAAZgYA=
Date:   Thu, 26 Aug 2021 17:42:13 +0000
Message-ID: <d3e996fdeea5eafad9d4f827d5d0cd7102ec4c4b.camel@nvidia.com>
References: <20210826115425.1744053-1-maximmi@nvidia.com>
         <69a54b65-fe1d-8c1c-792d-0958778c4379@gmail.com>
In-Reply-To: <69a54b65-fe1d-8c1c-792d-0958778c4379@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 11492263-9313-4350-68d2-08d968b8d708
x-ms-traffictypediagnostic: BYAPR12MB3637:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB3637954663BB5BA2E3A79007B3C79@BYAPR12MB3637.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1417;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IAyt175SB7auq5lW/0mcPOs/P6Bgu7zMHGxB8tbj/saRDUufk/+Mb+wyAdTqYaH/v4F9AIWvgjaXrV3LRdldYbOYPycIeif7Cyyp6TqppDuDKm3+bMlxq6L6URSUP5HXELNSawm5U/4VagAvtSkkrF1VgbAHxaUHqW/FB5mGXY/mx91CgJ06CnlXMg67rUWFdvuPLl/pQEuBsgUwXeezJUl0RGE0VbyJQK/36yiaVp/PWmXhfcg2aoJ9VLRETNT2QAAGvQ5mFQH6lwuxJ14XMRF9NBRjfWoK+IWItb+wgFe/tqFULlsCh3n5ryvwB77VBceHHRu7bfVVnpk9ekhiVz4CcpQ7OoXX4OZ7WF1xuf8VHwqYTBdLSOq4rjCBQvAYffHopdk/xsGlLgKos0ROcDGuCHGwetmXNf/dQXzTVY8mKruHQywG89IOMYtQrbmIwi9V1j9LpX0Mzdx3J959/WK/JFkTjcXNjJjvpaXGwuMeNiiQyJBZad2OKeCyJ/fa7zKfwq0KrRGdIwYBxmAJliu/hC2ujdBuJZKLFTpFwvdbCv34+l+FVCVazwbWXnGj5f/Oeozhps97UroEkoa35Z1GfNnazaX+dY3BNuTnDK6BiPMRl1EI5WwZ6j7V2qVZv+6KzoYvJcAsZLAPF8wpPaNSar1E48OZRrfMiIulfGfvJfA2zIcyiR5H3JzpEw+YGezjJQQ2rzF5CPPPIz/vxA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(39860400002)(136003)(396003)(6486002)(8936002)(122000001)(38100700002)(86362001)(478600001)(76116006)(2906002)(110136005)(6506007)(186003)(54906003)(6512007)(53546011)(66476007)(2616005)(66946007)(8676002)(26005)(83380400001)(66446008)(316002)(5660300002)(71200400001)(66556008)(38070700005)(4326008)(64756008)(36756003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NTMyMmhBbHNaU3A2Ulc3QkdSUjcwdnduYUlzL2IveU5QdS9JVGZ0UStXRTZo?=
 =?utf-8?B?YmFXVE1mWjlKSmRVeFc3YS9SLzV6QkJSR0o3WVFLSE03aURKall3cjJvcXIv?=
 =?utf-8?B?Z3FsYUhvTU16djB1Tzg1aTkyL3hTK3ZIa0Q4ek1mUEdkL3dVblhHQy84WmlO?=
 =?utf-8?B?ak5hRmQxeEk4d2NXMjZnMWRjZUNlL3lST1M0YlJwMlJ3b1AvTUtVU1M1YWpN?=
 =?utf-8?B?M0lQc29WcVpLWXBZYzlRdUExTmM4SyswS25QMFdFd0VtSm14YitzWDZHQTFR?=
 =?utf-8?B?cUd6ZzFuN2VUQUJHWm85djdBUCswWERnUklyTWpoalhYZlpXcjNlTnVwS2Ev?=
 =?utf-8?B?enp4YkQ2UzRPQzcwQ2Q3NTdXaDRPMnoycXlPSk8wUEZpdTgwQlBGWW5wR0Jq?=
 =?utf-8?B?ek84SWxwU3NCTDFkQXNwaGhQT1ljSWhBWFhWQkZ4WW5NTUllNmtEQlZGUTBy?=
 =?utf-8?B?SGQ5cDVOa29XZlRJS2JRRGhyamx0RjdsYUt6RU9EVi9uTjVsOXE4d0pjRkNz?=
 =?utf-8?B?L0hWMUpYWjhoVTNjRkpHRzJqZkNhTU04NWRaN3Y2L2x4MDNuN1RIUW5yZFQy?=
 =?utf-8?B?cnNKamMvaGpEMG83dDJQSVp3WWx0OTZqblNLZXhmcHlVN044R0xacGhjMVpu?=
 =?utf-8?B?aGpINHVYcVQ2ZlcyaHpXd1R6cU5qVi9jSENoaDZEQ1hKclgycnhqb3pxMVMx?=
 =?utf-8?B?djVob1o1NlhhU3crcnM5bm5Ra2JYWjUyUGo4QWdzbVo5MTJKc2JsaEdsaEFs?=
 =?utf-8?B?L1RBaFkvaVhueUtBY3NrRUdURDhxcWdCUEZ6RHpqWmxsLzJyUVFkeVVreU1X?=
 =?utf-8?B?YkttNmh4L0EzSmdUU240RVVMNVJRS1hBK05DSitNQml0Y2hsWERweGJXV2lz?=
 =?utf-8?B?dzVydk1hbTdHMHRUVEd6S3VPMXBCMUp3Q1VZMnZDMWhTY0NSWkNUcTNrRWxo?=
 =?utf-8?B?K2JpVEwyTnpiN3hFTzU2a3NpaEx4LzhLaFBlZmxuSkRtUW82c2RwMEdyQmwv?=
 =?utf-8?B?UTA5NjRYWVdDOHRlbTlGSW55bmZURkc0S05EeHI2Nnh0OG1hR3drN3NvV3R5?=
 =?utf-8?B?cU5WSnVjYlpkRUFrRjd4VXoyblBKYVo2ZURkbXNxa2piRTRxM01Ranh2ZlJ3?=
 =?utf-8?B?eXMvNEpZandFaXJEMGNuYlFMMmRXRzBOSURxYzAwZmxZNi95WUdQdkRhTlVV?=
 =?utf-8?B?Y0RQQWJ0RE5Gb3pvMGtIRCsyL0djclpCYXdhckVjN1djdE15bEFDcGg0TGFV?=
 =?utf-8?B?S0VEOHZWeVNpdkdpcHBSeFIvdXQwK1ZUbjB4NlJCZExSR0JMSUtpWHAyWm4x?=
 =?utf-8?B?U0YzenJyWHlmanp1bVB3WUVWd2tOWEFUeHM5RHlvQXFJK3o0dVN4TWRybWJO?=
 =?utf-8?B?b3ZIRjhIYkZFWVBWeVBKTVE3RDU1ZFg5TDRPNVZzblpjQlZ2Ky94QklueW1H?=
 =?utf-8?B?ZTlCYVplU2VMTTdzM3ByUHJvNVljaWdsd3h3L0trQUZNKzZKM25xQXdYRDJV?=
 =?utf-8?B?NFVPK0JadDU5ZE1kL3AzelVMbEFsaFJYYkNLV3ZFYlB4TFRaWko2K0xGN0k2?=
 =?utf-8?B?RXN2YTc5MThWUEZjUERUc3RuNWFnS0pWRFVEN1lnYXpOOW12WTdOQXFrajhW?=
 =?utf-8?B?WDhWOE1FVFZOVkpNcDZFelZWZW1BYzVnSThBNzNrd2FwbU8ycHFpNHY4MFhn?=
 =?utf-8?B?K0txak1qL0VlTXV0dUhDRlNvQW5uSWJwYld5aTNta2lsWFJ6TkQ1dUVqamZa?=
 =?utf-8?B?Y3p0Wks5ZVZCS0t4L3ZQVTV3bmhMbDVTb2dTc0pQMWtZdGVWUEhaVVVITDVu?=
 =?utf-8?B?UTJxV3h6b21lUGlNOE14QT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <33E71AE06D58234BA7DA56DE12A5E3C7@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11492263-9313-4350-68d2-08d968b8d708
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2021 17:42:13.9419
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YgdZbXjEZg34sK2XQ/S2xYR6ZAJYcgEBmk80Qt4m2AlP5kkr0CLrK4BImY1mZjwhqtqW17C8C2Yl3B8DZenIgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3637
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIxLTA4LTI2IGF0IDA5OjEwIC0wNzAwLCBFcmljIER1bWF6ZXQgd3JvdGU6DQo+
IA0KPiANCj4gT24gOC8yNi8yMSA0OjU0IEFNLCBNYXhpbSBNaWtpdHlhbnNraXkgd3JvdGU6DQo+
ID4gSW4gSFRCIG9mZmxvYWQgbW9kZSwgcWRpc2NzIG9mIGxlYWYgY2xhc3NlcyBhcmUgZ3JhZnRl
ZCB0byBuZXRkZXYNCj4gPiBxdWV1ZXMuIHNjaF9odGIgZXhwZWN0cyB0aGUgZGV2X3F1ZXVlIGZp
ZWxkIG9mIHRoZXNlIHFkaXNjcyB0bw0KPiA+IHBvaW50IHRvDQo+ID4gdGhlIGNvcnJlc3BvbmRp
bmcgcXVldWVzLiBIb3dldmVyLCBxZGlzYyBjcmVhdGlvbiBtYXkgZmFpbCwgYW5kIGluDQo+ID4g
dGhhdA0KPiA+IGNhc2Ugbm9vcF9xZGlzYyBpcyB1c2VkIGluc3RlYWQuIEl0cyBkZXZfcXVldWUg
ZG9lc24ndCBwb2ludCB0byB0aGUNCj4gPiByaWdodCBxdWV1ZSwgc28gc2NoX2h0YiBjYW4gbG9z
ZSB0cmFjayBvZiB1c2VkIG5ldGRldiBxdWV1ZXMsIHdoaWNoDQo+ID4gd2lsbA0KPiA+IGNhdXNl
IGludGVybmFsIGluY29uc2lzdGVuY2llcy4NCj4gPiANCj4gPiBUaGlzIGNvbW1pdCBmaXhlcyB0
aGlzIGJ1ZyBieSBrZWVwaW5nIHRyYWNrIG9mIHRoZSBuZXRkZXYgcXVldWUNCj4gPiBpbnNpZGUN
Cj4gPiBzdHJ1Y3QgaHRiX2NsYXNzLiBBbGwgcmVhZHMgb2YgY2wtPmxlYWYucS0+ZGV2X3F1ZXVl
IGFyZSByZXBsYWNlZA0KPiA+IGJ5IHRoZQ0KPiA+IG5ldyBmaWVsZCwgdGhlIHR3byB2YWx1ZXMg
YXJlIHN5bmNlZCBvbiB3cml0ZXMsIGFuZCBXQVJOcyBhcmUgYWRkZWQNCj4gPiB0bw0KPiA+IGFz
c2VydCBlcXVhbGl0eSBvZiB0aGUgdHdvIHZhbHVlcy4NCj4gPiANCj4gPiBUaGUgZHJpdmVyIEFQ
SSBoYXMgY2hhbmdlZDogd2hlbiBUQ19IVEJfTEVBRl9ERUwgbmVlZHMgdG8gbW92ZSBhDQo+ID4g
cXVldWUsDQo+ID4gdGhlIGRyaXZlciB1c2VkIHRvIHBhc3MgdGhlIG9sZCBhbmQgbmV3IHF1ZXVl
IElEcyB0byBzY2hfaHRiLiBOb3cNCj4gPiB0aGF0DQo+ID4gdGhlcmUgaXMgYSBuZXcgZmllbGQg
KG9mZmxvYWRfcXVldWUpIGluIHN0cnVjdCBodGJfY2xhc3MgdGhhdCBuZWVkcw0KPiA+IHRvDQo+
ID4gYmUgdXBkYXRlZCBvbiB0aGlzIG9wZXJhdGlvbiwgdGhlIGRyaXZlciB3aWxsIHBhc3MgdGhl
IG9sZCBjbGFzcyBJRA0KPiA+IHRvDQo+ID4gc2NoX2h0YiBpbnN0ZWFkIChpdCBhbHJlYWR5IGtu
b3dzIHRoZSBuZXcgY2xhc3MgSUQpLg0KPiA+IA0KPiA+IEZpeGVzOiBkMDNiMTk1YjVhYTAgKCJz
Y2hfaHRiOiBIaWVyYXJjaGljYWwgUW9TIGhhcmR3YXJlIG9mZmxvYWQiKQ0KPiA+IFNpZ25lZC1v
ZmYtYnk6IE1heGltIE1pa2l0eWFuc2tpeSA8bWF4aW1taUBudmlkaWEuY29tPg0KPiA+IFJldmll
d2VkLWJ5OiBUYXJpcSBUb3VrYW4gPHRhcmlxdEBudmlkaWEuY29tPg0KPiA+IC0tLQ0KPiA+IMKg
Li4uL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4vcW9zLmPCoCB8IDE1ICsrLQ0K
PiA+IMKgLi4uL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4vcW9zLmjCoCB8wqAg
NCArLQ0KPiA+IMKgLi4uL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fbWFpbi5j
IHzCoCAzICstDQo+ID4gwqBpbmNsdWRlL25ldC9wa3RfY2xzLmjCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfMKgIDMgKy0NCj4gPiDCoG5ldC9zY2hlZC9z
Y2hfaHRiLmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIHwgOTcgKysrKysrKysrKysrLS0tDQo+ID4gLS0tLQ0KPiA+IMKgNSBmaWxlcyBjaGFuZ2Vk
LCA3MiBpbnNlcnRpb25zKCspLCA1MCBkZWxldGlvbnMoLSkNCj4gDQo+IEhhdmluZyBvbmUgcGF0
Y2ggdG91Y2hpbmcgbmV0L3NjaGVkIGFuZCBvbmUgZHJpdmVyIGxvb2tzIG9kZC4NCj4gDQo+IEkg
Z3Vlc3MgaXQgaXMgbm90IHBvc3NpYmxlIHRvIHNwbGl0IGl0ID8NCj4gDQoNCm5vdCByZWFsbHkg
cG9zc2libGUgc2luY2UgQVBJIGZvciB0aGUgZHJpdmVyIGdvdCBjaGFuZ2VkDQpzdHJ1Y3QgdGNf
aHRiX3FvcHRfb2ZmbG9hZDogcmVtb3ZlZCBtb3ZlZF9xaWQgZmllbGQuDQp3ZSBjYW4gbWluaW1p
emUgdGhlIGRyaXZlciBjb2RlIGp1c3QgdG8gbWFrZSBpdCBidWlsZCwgdGhlbiBpbXBsZW1lbnQN
CnRoZSBwcm9wZXIgc3VwcG9ydCBpbiBhIGxhdGVyIHBhdGNoLCBidXQgd2hhdCdzIHRoZSBwb2lu
dCwgdGhlIGRyaXZlcg0KY2hhbmdlcyBhcmUgcHJldHR5IG1pbmltYWwuDQoNCg0KDQo=
