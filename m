Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60E1E5911F5
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 16:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239138AbiHLOOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 10:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239117AbiHLON5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 10:13:57 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80052.outbound.protection.outlook.com [40.107.8.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3990201A6
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 07:13:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FsYP6J9R8uxOPxm14qHvVLhRNeNt6LOrhyAQ/RIAYaObWFeBE52sEuK0OHC1azK+yCTYFhKq5CxnyrXB+Qmf8BqK6sGBLndm9+iI7xKP1JVALhhZy5QY11n4/q3Y5Ew6TcJhiSzozz4nYsRWtrd2KcDHSwlHa60zoJe2cQWY9G5UX+2q6Lr8nkBuqqr/cbKgv4FlkLX4vs8FfkQjtQKXBhOZXFshSHcBDHXROhnqDMHp+Xd2LxLH5f05/iUnIHQQmqFNA+bIruglhB8rCI6teM+dX/z5BLFJAsAtvFGwUbYFXtvL67ROb0m6xK2WL1cH7b9UgJexHapDcd3sC19qnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B8yYN0ZGCTodc0DIEE7kIPiW1HsnmIQAAs3mcQb0mN0=;
 b=oJB91muBi2YRrVp8sTo7VHjOZu5sjcA+TacI6ZNwbr//S15XeHq9f6ldn/qJxssCF3aEGhga5qY39/3sfVdo7TGy1V/zGUtnKUyPmHm/5uEr9PXtlBHq2dsxMNYQA8zFOZmDBZZl/9prnqnN7D+890g8hUb0NqQ0Pbc2pJLlXkQsKkf8w0PeMxpQHFPWZCpmlp920tKRebSFFgNYJ3uDoWFyQP4IiFlyPphdQIVPIypXICvRHvXqgQFpIGRkJWg9TnKAa7UL/czrzoDV7SveCYh5c6CEGf45OIT5/friE0lIxP/KvOCxsO8slE7AtpmtfK0D/fBtrc40fk42O9Yekw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ericsson.com; dmarc=pass action=none header.from=ericsson.com;
 dkim=pass header.d=ericsson.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ericsson.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B8yYN0ZGCTodc0DIEE7kIPiW1HsnmIQAAs3mcQb0mN0=;
 b=hqga4Kg3WXld0NsEUXgOGm+P/NHHKD3zLhoUaV2M9rJ+XRuboLxOcAmFienS6qGFtJb12PPIOAzQN6yQiHocYRmRAAuORlDOAE+WKVfPCgMa7Wyy3cTiHq98T+RGgPwpicX0dVLftJpVLxnl1mNVRsEqJIaqrxNwMHpaPo9SIYk=
Received: from VI1PR07MB4080.eurprd07.prod.outlook.com (2603:10a6:803:29::11)
 by PAXPR07MB8579.eurprd07.prod.outlook.com (2603:10a6:102:24e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Fri, 12 Aug
 2022 14:13:53 +0000
Received: from VI1PR07MB4080.eurprd07.prod.outlook.com
 ([fe80::dd4a:cda1:59f2:a19a]) by VI1PR07MB4080.eurprd07.prod.outlook.com
 ([fe80::dd4a:cda1:59f2:a19a%5]) with mapi id 15.20.5525.010; Fri, 12 Aug 2022
 14:13:53 +0000
From:   Ferenc Fejes <ferenc.fejes@ericsson.com>
To:     "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "marton12050@gmail.com" <marton12050@gmail.com>,
        "peti.antal99@gmail.com" <peti.antal99@gmail.com>,
        "vladimir.oltean@nxp.com" <vladimir.oltean@nxp.com>
Subject: Re: igc: missing HW timestamps at TX
Thread-Topic: igc: missing HW timestamps at TX
Thread-Index: AQHYmepVJYOkQdQn8k+cRlOb7lKNfK2Cowk2gAGTfACAARs4gIAkOlGAgABOEICAAZ2MAA==
Date:   Fri, 12 Aug 2022 14:13:52 +0000
Message-ID: <252755c5f3b83c86fac5cb60c70931204b0ed6df.camel@ericsson.com>
References: <VI1PR07MB4080AED64AC8BFD3F9C1BE58E18D9@VI1PR07MB4080.eurprd07.prod.outlook.com>
         <VI1PR07MB4080DC45051E112EEC6D7734E18D9@VI1PR07MB4080.eurprd07.prod.outlook.com>
         <87tu7emqb9.fsf@intel.com>
         <695ec13e018d1111cf3e16a309069a72d55ea70e.camel@ericsson.com>
         <d5571f0ea205e26bced51220044781131296aaac.camel@ericsson.com>
         <87tu6i6h1k.fsf@intel.com>
In-Reply-To: <87tu6i6h1k.fsf@intel.com>
Accept-Language: hu-HU, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ericsson.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 60522a28-cdf4-4a44-a5a9-08da7c6ce2ce
x-ms-traffictypediagnostic: PAXPR07MB8579:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nzvnJAwrTWWXgsbTA1E+utbHn2SwSBy/Ib/5beijg5jTnR1SiMYODBoxezyKOdVWIf0ukvLa0CFA7vHmgcJzZ7JP3B3Hq1irKC4SI8KYvX34G6I374MlbXVnE+iC5P85UpSoJ5bR2bzPihgJAN4JgByQkg+h+Ur5Is8NrfM2DDpGeqEYJDO62b28VwCjC74ztDL5buDNiH0KGgwNfFy9JW9Ngehl++Rgm9mOpvJZ3285o/LAKI2CQfPC7qep0ksCJ6H1d2RrZfloEnrcoV4J09zlzbQgQrmXNhdPOLUGHYC5bb0x4sdmzmy3jsHoEr55aYmi4ASg2JFSN0VaJSkoWmEkzpB8oKSUOaKetBoXD9umwQ3fsG2IAo+teds/KOtK1CtyNnru8206dMXOleKCkFRd0/Fk8pOY5mlL+s0nyqs348+YNiyKLYF70i3djHh37YR1LhU0+3mnMX6XEv1JlkID6kWjTe/GMqselyGiHoRmCK51kiSMIA6sOsp8dS/dvlrCv8zfp7ynuit73kpK2a+stMz7Gi6KRUjrkHtZND3aZEITUtyS781vdBOvjGaXFFlig2TRbu2a+ojLaJR08AQ0NvPSOUcwOmD1GqkxXQW02km65e2U4gFwG7OffdevIjI3FNlz4y+Buavju4ElG5PDodL/IGPbC74+ww52XDvtsEX9JjjUQS3Kt7hXVZXEQrhWbJOtjKZ8Ve20PaoYeWIrXYGOnubXmi9rmfMjCI389Z4kiKWtg5PwQ8O7zGwQlVcQJOqABlihCkmEeBYuVN7aWAIKKKHXniRSqMiQedmjyzlGMiaQVaDGaqB15RqB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR07MB4080.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(366004)(346002)(376002)(136003)(54906003)(316002)(5660300002)(82960400001)(38070700005)(110136005)(26005)(478600001)(6512007)(186003)(83380400001)(41300700001)(2616005)(36756003)(6506007)(71200400001)(8676002)(76116006)(66946007)(66476007)(66446008)(4326008)(122000001)(64756008)(66556008)(44832011)(86362001)(6486002)(8936002)(2906002)(91956017)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R0FvYXlnTXVqVGJKd2tIM2RGcHFhaUIvVlJnZTlmNElMK1dhNlhRYWFhWGU1?=
 =?utf-8?B?OXFBemhuTGJndnhQY1JieVF2V1JPNGRQSk5rL2NIQUtYODFLYlFzTzBUWWhw?=
 =?utf-8?B?RGxTZzFpMlpyNDZvdTVsK1NPWXBnUHdrR25kSExBUG1jYnBtL1hQQThwT0hS?=
 =?utf-8?B?TVdqcUJsaTNuNUNJOEN4S1J4bWNzWHpkVTEwaHRiRy9abW1zcVh4NE1kbGQ1?=
 =?utf-8?B?VTlYSjBkejhSMzdNUGpuSWNKSno2YW9OUDBVZHg1UDlic2dLN3Z6djY3VTdS?=
 =?utf-8?B?VWc1K3dxNkFCb3VFTEw0N0dSckhKOEEyekk1Q1ZCSVNScUFyTkdUZTl6WkhB?=
 =?utf-8?B?WTdqcDJqdEhrcU82dWprbWNzRE9xSnRCRjVoaEJsWWI1UUdLUUpoTXhkUHo2?=
 =?utf-8?B?cFl5OGxIM2pHand0YjNRa1Q4OFdtUlVhalVCZnFZdERybUp4ZzgvT1JMbkFF?=
 =?utf-8?B?Zm1Cd3hCSlk5amJQYjRvTWtZWVBuK29lbCtlMmlOVjBXZEJkNkg2Rjg4alhz?=
 =?utf-8?B?L3NPWm1kV1B1dm1ESkhIUmZBWmZCZTJ5UmJZUVlQYzQ5dlB2OG9ZdW5zQ3FT?=
 =?utf-8?B?eTFEYzhHcHR2enpZeGp2TXkrV216T3JudzFhVmR3ZXlsN01UR2xWQ25TektT?=
 =?utf-8?B?WUlkSmlac0sxc0hrUzM1OGN6S0hnbUJwZ0pkWUdFK2s0UEVTM3VZU0oxY3NM?=
 =?utf-8?B?VzNrOUQ3VEQyU1Z4SlhoL3BWZmp2YmtacTl6bjhmMUdGbENsdWxlQ0tuNTZz?=
 =?utf-8?B?VUJHdjAyUVMwSnBrbFJJaUlUdUlzYS9ELys1REt2a01seGo2MHFHc2l3VVNJ?=
 =?utf-8?B?WFRpNHVNQ0ZJK0pVQnFIeHQxWnVaR21ncmZWV1JzMjlTd2Zna2E1ZHlSZS9D?=
 =?utf-8?B?RStYM3RNWmxwSFY1RDNyM2VreUgzcXhCMy8rL0FsRHF3OHR0c2xUWjU3ejJF?=
 =?utf-8?B?M3ExVk93bS9zVkpXd21mK1NVMzhrc2lVeEpKSnVZNDdXaXhTanNBekNScHVr?=
 =?utf-8?B?WUJNT0VBYVA2cDF6Zmc1MVZiM05vZE1RaWpTdWgwd2h3Q2wwRmY5ZmtoK0FP?=
 =?utf-8?B?TDc1dWVlNk5jWVM5YUhySG5pZ2diYXlTcG9xR3JGR2pZa3BDQUZtU2Rnd1J5?=
 =?utf-8?B?Q2R3eVBveDhaRktxaXhQcU85SVpmdjJuYWZqTlBBN2h2QzZEM1E4dlN3YjFx?=
 =?utf-8?B?WFhpNHd5YURQc2UrejFZRGVNR2JRUStGd2JndjlUTXhUQ2JrT0wrS0Q2LzB1?=
 =?utf-8?B?anpwdXJtNXgzZXhHM3JEK0ExUFM0ZlNWeDJEVkd1REN2YjFVVExSN01XYm5Z?=
 =?utf-8?B?OXZnaHdDNEFOZ2k5VjAwK3M2eWZVSUdvNkFEQjZLYWJVa3RndUU3dUpTVm1R?=
 =?utf-8?B?WW9sLzFvMFZ6TnFtSzFLTy8yRWpOTlk1NnFYWVNqSVdEWGtaK0FNQmVtbi9X?=
 =?utf-8?B?ZzBrM3o1eEJTakl4VlFWTUw0VndFL012bk0wNHVzWjBBaHRueXJpbVp1eG9N?=
 =?utf-8?B?eXRtbDVVS01XOEJWUEZBa3FFOHZVL1ArYVl2M3BqYUJIejUxbmdLUnJpOXhY?=
 =?utf-8?B?elZmOHlROG9YSk5GZEdrdGFETk5uRWU4bHN4djZFSXpGaEFha0VzMjZDOFh1?=
 =?utf-8?B?ZWRjRWZRcndiSkplc2wzd2F3bjlNVlNpT1BPSm1YVE9xeVJOb2x0Wkd5Nnpw?=
 =?utf-8?B?SW91ZWtvU1I1TUs3VlZVdFA4d2YvUUdKZm1FL3FuSFZ2bGllbjBRY3YyamlK?=
 =?utf-8?B?UjJ0SzYwc0xjV2VVYzIyYVIwaWo1NXp5Y012SGo5ak1WbHNYQUZPUFJjSzlq?=
 =?utf-8?B?MkdYeU1HblhaL0tEK0VBNElyU3kyL01mSDZCWEJUYld4UHdHOC91bXJUQjdn?=
 =?utf-8?B?Ynl0L2tjMGtsODVEcUQyNDlOU1J0SzFHWEpsS1dmMW5PcGNIQzdXZmtKSG5B?=
 =?utf-8?B?RWIwY3MxVU5XU0hlYjQzQW43V1JSdWFPOWdIVUhkcURwVHBGQWxTWHhVdGcw?=
 =?utf-8?B?dlQzZWZXWWRUWVJBeFZtVnp1ckt5bm81dFk4OVdFd1hTcy9MazZiaW1rWmhE?=
 =?utf-8?B?MWxjTlZrY1hrdU1rTUhOQkgydzFYa2hiZkpUWDhhSUdSRGwvdDcvNllEUUZK?=
 =?utf-8?B?NTJQRHNVcWdrQTNIbmJVSjlVcFUrdG94QUlnN2swQnZsNnh0UEZFWXd3VUtW?=
 =?utf-8?B?ZHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F719168A796AD0418169026A97171037@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ericsson.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR07MB4080.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60522a28-cdf4-4a44-a5a9-08da7c6ce2ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2022 14:13:52.9227
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 92e84ceb-fbfd-47ab-be52-080c6b87953f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c5rxObfHFCYUrPBaVT/KADhjlAZK/aCU/+1xWEOzfvebkmpIEnDfYnC7I6gddf1KhAZVmOQq2b2FtZlIFa1/kZSPuI7wSuSuJKKzQ8VqGZY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR07MB8579
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmluaWNpdXMhDQoNCk9uIFRodSwgMjAyMi0wOC0xMSBhdCAxMDozMyAtMDMwMCwgVmluaWNp
dXMgQ29zdGEgR29tZXMgd3JvdGU6DQo+IEhpIEZlcmVuYywNCj4gDQo+ID4gDQo+ID4gV2l0aCBp
cGVyZiBUQ1AgdGVzdCBsaW5lLXJhdGUgYWNoaXZlYWJsZSBqdXN0IGxpa2Ugd2l0aG91dCB0aGUN
Cj4gPiBwYXRjaC4NCj4gPiANCj4gDQo+IFRoYXQncyB2ZXJ5IGdvb2QgdG8ga25vdy4NCj4gDQo+
ID4gPiA+IA0KPiA+ID4gPiBJZiB5b3UgYXJlIGZlZWxpbmcgYWR2ZW50dXJvdXMgYW5kIGZlZWwg
bGlrZSBoZWxwaW5nIHRlc3QgaXQsDQo+ID4gPiA+IGhlcmUNCj4gPiA+ID4gaXMNCj4gPiA+ID4g
dGhlIGxpbms6DQo+ID4gPiA+IA0KPiA+ID4gPiBodHRwcyUzQSUyRiUyRmdpdGh1Yi5jb20lMkZ2
Y2dvbWVzJTJGbmV0LW5leHQlMkZ0cmVlJTJGaWdjLQ0KPiA+ID4gPiBtdWx0aXBsZS10c3RhbXAt
dGltZXJzLWxvY2stbmV3DQo+ID4gPiA+IA0KPiA+IA0KPiA+IElzIHRoZXJlIGFueSB0ZXN0IGlu
IHBhcnR1Y3VsYXIgeW91IGludGVyZXN0ZWQgaW4/IE15IHRlc3RiZWQgaXMNCj4gPiBjb25maWd1
cmVkIHNvIEkgY2FuIGRvIHNvbWUuDQo+ID4gDQo+IA0KPiBUaGUgb25seSB0aGluZyBJIGFtIHdv
cnJpZWQgYWJvdXQgaXMsIGlmIGluIHRoZSAiZHJvcHBlZCIgSFcNCj4gdGltZXN0YW1wcw0KPiBj
YXNlLCBpZiBhbGwgdGhlIHRpbWVzdGFtcCBzbG90cyBhcmUgaW5kZWVkIGZ1bGwsIG9yIGlmIHRo
ZXJlJ3MgYW55DQo+IGJ1Zw0KPiBhbmQgd2UgbWlzc2VkIG9uZSB0aW1lc3RhbXAuDQo+IA0KPiBD
YW4geW91IHZlcmlmeSB0aGF0IGZvciBmb3IgZXZlcnkgZHJvcHBlZCBIVyB0aW1lc3RhbXAgaW4g
eW91cg0KPiBhcHBsaWNhdGlvbiwgY2FuIHlvdSBzZWUgdGhhdCAndHhfaHd0c3RhbXBfc2tpcHBl
ZCcgKGZyb20gJ2V0aHRvb2wgLQ0KPiBTJykNCj4gaW5jcmVhc2VzIGV2ZXJ5dGltZSB0aGUgZHJv
cCBoYXBwZW5zPyBTZWVpbmcgaWYNCj4gJ3R4X2h3dHN0YW1wX3RpbWVvdXRzJw0KPiBhbHNvIGlu
Y3JlYXNlcyB3b3VsZCBiZSB1c2VmdWwgYXMgd2VsbC4NCg0KWWVzLCBpdHMgaW5jcmVhc2luZy4g
TGV0IG1lIGlsbHVzdHJhdGUgaXQ6DQoNCkV0aHRvb2wgYmVmb3JlIHRoZSBtZWFzdXJlbWVudDoN
CiQgZXRodG9vbCAtUyBlbnAzczAgfCBncmVwIGh3dHN0YW1wDQogICAgIHR4X2h3dHN0YW1wX3Rp
bWVvdXRzOiAxDQogICAgIHR4X2h3dHN0YW1wX3NraXBwZWQ6IDQwOQ0KICAgICByeF9od3RzdGFt
cF9jbGVhcmVkOiAwDQoNCk1lYXN1cmVtZW50Og0KJCBzdWRvIGlzb2Nocm9uIHNlbmQgLWkgZW5w
M3MwIC1zIDY0IC1jIDAuMDAwMDAwNSAtLWNsaWVudCAxMC4wLjAuMjAgLS0NCm51bS1mcmFtZXMg
MTAwMDAwMDAgLUYgaXNvY2hyb24uZGF0IC0tc3luYy10aHJlc2hvbGQgMjAwMCAtTSAkKCgxIDw8
DQoyKSkgLS1zY2hlZC1maWZvIC0tc2NoZWQtcHJpb3JpdHkgOTkNCg0KKG5vdGU6IGlzb2Nocm9u
IHdvdWxkIHRyeSB0byBzZW5kIGEgcGFja2V0IGluIGV2ZXJ5IDUwMG5zLCBidXQgdGhlIHJhdGUN
CmFjdHVhbGx5IGxpbWl0ZWQgYnkgdGhlIHNsZWVwL3N5c2NhbGwgbGF0ZW5jeSBzbyBpdHMgc2Vu
ZGluZyBwYWNrZXRzIGluDQphYm91dCBldmVyeSAxNS0yMHVzKQ0KDQpPdXRwdXQ6DQppc29jaHJv
blsxNjYwMzE1OTQ4LjMzNTY3Nzc0NF06IGxvY2FsIHB0cG1vbiAgICAgICAgIC03IHN5c21vbiAg
ICAgICAgLQ0KMjUgcmVjZWl2ZXIgcHRwbW9uICAgICAgICAgIDAgc3lzbW9uICAgICAgICAgIDQN
ClRpbWVkIG91dCB3YWl0aW5nIGZvciBUWCB0aW1lc3RhbXBzLCAxMCB0aW1lc3RhbXBzIHVuYWNr
bm93bGVkZ2VkDQpzZXFpZCAzNDQxIG1pc3NpbmcgdGltZXN0YW1wczogaHcsIA0Kc2VxaWQgMzQ0
MiBtaXNzaW5nIHRpbWVzdGFtcHM6IGh3LCANCnNlcWlkIDM0NDMgbWlzc2luZyB0aW1lc3RhbXBz
OiBodywgDQpzZXFpZCAzNDQ5IG1pc3NpbmcgdGltZXN0YW1wczogaHcsIA0Kc2VxaWQgNTUzMCBt
aXNzaW5nIHRpbWVzdGFtcHM6IGh3LCANCnNlcWlkIDU1MzEgbWlzc2luZyB0aW1lc3RhbXBzOiBo
dywgDQpzZXFpZCA3NTk3IG1pc3NpbmcgdGltZXN0YW1wczogaHcsIA0Kc2VxaWQgNzU5OCBtaXNz
aW5nIHRpbWVzdGFtcHM6IGh3LCANCnNlcWlkIDc1OTkgbWlzc2luZyB0aW1lc3RhbXBzOiBodywg
DQpzZXFpZCA3NjA1IG1pc3NpbmcgdGltZXN0YW1wczogaHcsIA0KDQoNCkV0aHRvb2wgYWZ0ZXIg
dGhlIG1lYXN1cmVtZW50Og0KZXRodG9vbCAtUyBlbnAzczAgfCBncmVwIGh3dHN0YW1wDQogICAg
IHR4X2h3dHN0YW1wX3RpbWVvdXRzOiAxDQogICAgIHR4X2h3dHN0YW1wX3NraXBwZWQ6IDQxOQ0K
ICAgICByeF9od3RzdGFtcF9jbGVhcmVkOiAwDQoNCldoaWNoIGlzIGlubGluZSB3aXRoIHdoYXQg
dGhlIGlzb2Nocm9uIHNlZS4NCg0KQnV0IHRoYXRzIG9ubHkgaGFwcGVucyBpZiBJIGZvcmNpbmds
eSBwdXQgdGhlIGFmZmluaXR5IG9mIHRoZSBzZW5kZXINCmRpZmZlcmVudCBDUFUgY29yZSB0aGFu
IHRoZSBwdHAgd29ya2VyIG9mIHRoZSBpZ2MuIElmIHRob3NlIHJ1bm5pbmcgb24NCnRoZSBzYW1l
IGNvcmUgSSBkb2VzbnQgbG9zdCBhbnkgSFcgdGltZXN0YW0gZXZlbiBmb3IgMTAgbWlsbGlvbg0K
cGFja2V0cy4gV29ydGggdG8gbWVudGlvbiBhY3R1YWxseSBJIHNlZSBtYW55IGxvc3QgdGltZXN0
YW1wIHdoaWNoDQpjb25mdXNlZCBtZSBhIGxpdHRsZSBiaXQgYnV0IHRob3NlIGFyZSBsb3N0IGJl
Y2F1c2Ugb2YgdGhlIHNtYWxsDQpNU0dfRVJSUVVFVUUuIFdoZW4gSSBpbmNyZWFzZWQgdGhhdCBm
cm9tIGZldyBrYnl0ZXMgdG8gMjAgbWJ5dGVzIEkgZ290DQpldmVyeSB0aW1lc3RhbXAgc3VjY2Vz
c2Z1bGx5Lg0KDQo+IA0KPiBJZiBmb3IgZXZlcnkgZHJvcCB0aGVyZSdzIG9uZSAndHhfaHd0c3Rh
bXBfc2tpcHBlZCcgaW5jcmVtZW50LCB0aGVuDQo+IGl0DQo+IG1lYW5zIHRoYXQgdGhlIGRyaXZl
ciBpcyBkb2luZyBpdHMgYmVzdCwgYW5kIHRoZSB3b3JrbG9hZCBpcw0KPiByZXF1ZXN0aW5nDQo+
IG1vcmUgdGltZXN0YW1wcyB0aGFuIHRoZSBzeXN0ZW0gaXMgYWJsZSB0byBoYW5kbGUuDQo+IA0K
PiBJZiBvbmx5ICd0eF9od3RzdGFtcF90aW1lb3V0cycgaW5jcmVhc2VzIHRoZW4gaXQncyBwb3Nz
aWJsZSB0aGF0DQo+IHRoZXJlDQo+IGNvdWxkIGJlIGEgYnVnIGhpZGluZyBzdGlsbC4NCg0KT24g
dGhlIG90aGVyIGhhbmQgSSdtIGxpdHRsZSBiaXQgY29uZnVzZWQgd2l0aCB0aGUgRVRGIGJlaGF2
aW9yLg0KV2l0aG91dCBIVyBvZmZsb2FkLCBJIGxvc3QgYWxtb3N0IGV2ZXJ5IHRpbWVzdGFtcCBl
dmVuIHdpdGggbGFyZ2UgKG9uZQ0KcGFja2V0IGluIGV2ZXJ5IDUwMCB1cykgc2VuZGluZyByYXRl
IGFuZCB3aXRoIEhXIG9mZmxvYWQgSSBzdGlsbCBsb3N0IGENCmxvdC4gQnV0IHRoYXQgbWlnaCBi
ZSBiZXlvbmQgdGhlIGlnYywgYW5kIHNvbWUgY29uZmlnIGlzc3VlIG9uIG15IHNldHVwDQooSSBo
YXZlIHRvIGFwcGx5IG1xcHJpbyBhbmQgZG8gdGhlIFBUUCBzeW5jIG9uIGRlZmF1bHQgcHJpb3Jp
dHkgYW5kDQpkYXRhIHBhY2tldHMgd2l0aCBTT19UWFRJTUUgY21zZyBzZW50IHRvIEVURiBhdCBw
cmlvIDIpLiBEb2VzIHRoZQ0KdHhfcXVldWUgYWZmZWN0IHRoZSB0aW1lc3RhbXBpbmc/DQoNCkND
IFZsYWRpbWlyLCB0aGUgYXV0aG9yIG9mIGlzb2Nocm9uLg0KDQo+IA0KPiA+ID4gPiANCj4gPiA+
ID4gQ2hlZXJzLA0KPiA+ID4gDQo+ID4gPiBCZXN0LA0KPiA+ID4gRmVyZW5jDQoNCkJlc3QsDQpG
ZXJlbmMNCg0K
