Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49586676625
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 13:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbjAUMHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Jan 2023 07:07:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjAUMHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Jan 2023 07:07:52 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2111.outbound.protection.outlook.com [40.107.7.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED9512594
        for <netdev@vger.kernel.org>; Sat, 21 Jan 2023 04:07:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IvJwPpW5puC8u5SnZbaE0kUKaJ2gY2tJ0j1kRiG6ejvob+O1tg6TntyY5945kcjwvHbuFybtPwayiOPHnAiCvrHojEyR69roh/w8A3Mejha60mW+BBLjKL52RnKwVoriFPyYogm0OFu1riBORrvK2L5sctUy7nhN8c2UkNtndCbixqUUaTI0uxDp0CiMU7zwaDfCzFzOVvTQ6s+NH6d/6cGPmDTGM8xJLpedJMdmxft+SmcPjEFWOi61ZT5ZMvymNPccP18L7H6WKq0hmC64o/xVK4UtMG5B027Oy9AcooHY9W+vUy1kSMY0BJFN0LnpofkEltikp0Z9nYi7PYu5wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iczLDumT1O0EHi391YT6y211w8Wge9hVU9KfglcD2CE=;
 b=BRQ1CkPVtavjIz2POCNsDBw0cGHcgDKOkAAg+JwlXqyEUgABFAjiF1dHG8UpiK3TWMZtXJOPwe9+ix+JX2niCQ3Wjo8gonZLeMmh1tJsGxvg+xCO4YwVTYvfC6ofOoPjJGr9fblMIVCmoFWTcO+xL0iosomIuuJH+lYUicw5DD7qkK3x6o88iWK9MQ2bZXenMFz++LE/mxLV52BlUckmQSTwOYJV0LBirck5LLG+T8BQlHlLv+lhDd5kKS0kgKu/WQYWt0xwLGqaOrIaKbEEQSsxpKVpPiw6V+YKiQH+An8Kh02XwNfqLIA7RiIRBssFWZLAI3w2/IB3SRpkjh5kmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iczLDumT1O0EHi391YT6y211w8Wge9hVU9KfglcD2CE=;
 b=AI8qoEApB3fsShrIgcN+RQ91SNMMLtLRU1dkOM/TRSoxRpEtkqGjhhTMvAUZFM695SXB5lVo0dkF0s3qy0f90jVHE2h8N3u9ukkOoGpwiPrDcPrR8sdpKzBTRjJdUlgCM62WXEmIgSOHeqBTqgQDigWqeITuOLtMW3Qc4/qUF2w=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by DB9PR03MB8235.eurprd03.prod.outlook.com (2603:10a6:10:306::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.27; Sat, 21 Jan
 2023 12:07:46 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::5ef0:4421:7bff:69eb]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::5ef0:4421:7bff:69eb%5]) with mapi id 15.20.6002.025; Sat, 21 Jan 2023
 12:07:45 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzk+dt@kernel.org" <krzk+dt@kernel.org>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next] net: dsa: realtek: rtl8365mb: add change_mtu
Thread-Topic: [PATCH net-next] net: dsa: realtek: rtl8365mb: add change_mtu
Thread-Index: AQHZLPDxFy8jo2lKz0u3UVwnZgCUTK6oyA0A
Date:   Sat, 21 Jan 2023 12:07:45 +0000
Message-ID: <20230121120744.4krs4esfab56pvdz@bang-olufsen.dk>
References: <20230120170025.20178-1-luizluca@gmail.com>
In-Reply-To: <20230120170025.20178-1-luizluca@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM6PR03MB3943:EE_|DB9PR03MB8235:EE_
x-ms-office365-filtering-correlation-id: c0a68be4-fcaf-4cab-b842-08dafba81b26
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y/NXOLII9RaWlcBotlXuClDl22rVMfLaZDCQ7jwfljinAqczzqbclle2lBFvXQ3A1UH2DjiZnXRQbLos33f9Iq2xNACmiZtzgUtgpOWy1fnbCocKrYYOs6YiVDf+lokY2wlBkWWtWJ5SXm4V+++E3cKMgAX0hztOM8W4JD9h3b03cOBqmpy7exV5hJUjbz/4zv16ExjUQnDr7h3IMq2LhNV02apq6BHXAJ9KNju2kZp8dM0xSgQ9tFxTDzLwhOVk6WdspPz4jXTQ0q/fyC8OPttj7tRqgFWbftfkEjD9x55+DROOzrZMClbq/4Bb85xf0AdTVUkm683m9sQTwdNURKRAP/S2VueFq/8m+MNm/JCkC+g2OvUHIH1/2rtTpz3ebmBdORQDiEVL5Ko71PK37/SMro0F3vo1+AmnSvf/JLnlYqchWHKhWR0f1jbmEBKXNhoYe9AWoMTFECCwK4b/ZNs2NqUK4fEEgWPH6nyT8UufeHEF/F3WTsy5E9ky4qkDEqKA7qK0GtWYcWXLvBOn0KakLPjnxjDQY/d6pgOMoNV3YxKs9NjeoBOmbbQ1srY5c3ISPcoAs90/tQ12lGBkChg27fu1C7pd4osai9w6QgS3py4iahiImAdKMmbzLtNdRZo5ZIS+pcqvhMHU4Rux5KOOJgRHlfGB7vOmTFbL6uo+l+PAYwcFIWilLJyyVjHEYcAD/o1FsHoXuk1FOWh4LA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(136003)(39850400004)(396003)(346002)(451199015)(6506007)(478600001)(54906003)(71200400001)(6486002)(66556008)(8676002)(64756008)(66476007)(66446008)(6512007)(316002)(6916009)(186003)(26005)(7416002)(91956017)(76116006)(8936002)(36756003)(85182001)(8976002)(41300700001)(1076003)(2616005)(66946007)(85202003)(5660300002)(83380400001)(86362001)(4326008)(2906002)(38100700002)(38070700005)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VEx4TVR1YU9nRm5uZUdOdmtMdnBWZzBrMjliRmdudFE2N2c1TFdBdE9JSm9t?=
 =?utf-8?B?a1hianZJU0x5R1dvRU5RczR0RVJOSFZGeG8veng5QmV0TCtkRjFuR3BUSDhk?=
 =?utf-8?B?WlhRcGNJODdGbC8zSXlVQUU0OXk1R2d6ZmViMTJjQS9DN1UzRms4eVRnOWJn?=
 =?utf-8?B?RHpieFIzandyTUZRUEw2UDBwUzZGblNyaXR2b0s2WlZ4V2dZS0Y5QzkxMFcw?=
 =?utf-8?B?U3FmbmRha0hrZDl5R2tXd3cwZk1iZENrWkJ1L1JEaTNRWmtEcGFtbkVSQyt2?=
 =?utf-8?B?N2lzcERxSXRtN3dhUzgvcnNrMURNQzhXays5dHo1THRrSHZldmxMaW5nTEcy?=
 =?utf-8?B?YkU3VWxEY29rNzhoQWZoSmZZZnZ5SHBsUnU0N21ZR1lnanlBYUJjWGxoMENW?=
 =?utf-8?B?TTBrMEVHbGgvL0ZNMjZZNkM2OFZkRnhqSFZqS2RUU3FkaExXMzB6NWVHNDFl?=
 =?utf-8?B?Skh0QXd4aitvbDdOd08xSWhTVnp0Ull6bVhtbnNWWkVYUUxlNmpYclR6THg0?=
 =?utf-8?B?d0tLQ2VKWXZhN2lmS0c5b0Y1dDU0WTBTeUd4TUNtWEZuM0pKNFMycVE2ZklW?=
 =?utf-8?B?LzYvQ3VjWFR6MHhQQUh4cXZ4UHdNQ2VQR3VNRy8zcFhXR1U4UzRPbnl6NU0y?=
 =?utf-8?B?M05ZQW9hQjJkc0U3VTAvQW8xVVNCVVdmMStTUFNNd0xJRFlJYXpEMk9yZlN6?=
 =?utf-8?B?elFHNTRzOUVBMkZGeFlONmxsZWJxTzEvRVhHbGEwbm40dU1SYVdVTGhZamx0?=
 =?utf-8?B?TVFVVG1oS1ZIUlptUGVMNlZLQlVMYnhaQWZVZFBScFRJek5VVWZRUWs1TTJW?=
 =?utf-8?B?RC9zRS9ObStTZ21yZ3loeE5SbXYrVjg2NWpGTWZlRDhxQzVZVUIyb3JYM09z?=
 =?utf-8?B?U2E4ZHdDRXY2dWV2S2dpSTdJTUZLUklmMHQvVldlK1N2VG1YeHhuS2FkWmJC?=
 =?utf-8?B?MXR0SFhjYUNqL2hFeG1qL1Z3MncvNzBVZ0RnRHMzZVNveEJqSWlVaG4ybUlP?=
 =?utf-8?B?bGlTQTZGZzJDaHJLTjFjME1ienBrZk9aU25yUUtGWHlkUll3WnRqRCtGa2Rl?=
 =?utf-8?B?L3BYSVhCektTRkxka1BrOG5ySmlWNjhaZnZIRXRkVU1mZG5VL1V2RkhKSmpO?=
 =?utf-8?B?emhUeTFUekQ0SkI1dTBDdTVDZSs4eXFHU0VvOGxub3FueWw2Wk1OTHRwMGZ0?=
 =?utf-8?B?RUtoVmlsN1Z0bFBxekdKOGlOdFovV2kzeTJlYnRnZkVjdmtZWGg1cmVndjJO?=
 =?utf-8?B?T2FkMU12Ty9heXVlc2FlTzdsdWhDalYyOWo5azVwa2N4d2NwUnowaC9uc0VP?=
 =?utf-8?B?NHJwM29lQnExeCtUcUlwUjl6azcrTTBMSkM3K1dkZDV1TjJBbCtOZUc5bEdm?=
 =?utf-8?B?SytzN2tDRXBvMmFvdElnWStQMnI3bHNYK292bkh6SWVpdnJNNThGaGpoTGtW?=
 =?utf-8?B?ZGE2YWpXR0tYcUtUSDVrTlZFU2V6eVVhSjBHcjU1OEQ3S0pLdVpDUWFXRUxq?=
 =?utf-8?B?U3JIaDJQelJnSURnVUx4MEZlSFZMZXlKWlp1WDR0M0FSRENDbVQreFc3Z2sw?=
 =?utf-8?B?cmhVWXRoOXpQSXBwaUZiZUh6cnNheXZoUUg0V3VOTVBGcGVnRnQ5eGZqQlgr?=
 =?utf-8?B?UmpqMVE2TkpFc00rZDRyRTV2VEwrcUlXTXZNVU9mVzBBR1lURFdxYTREVXcy?=
 =?utf-8?B?YW1KZVRLcGRmaCs4UzA3K05ubEpNeXl1aGNMbkpDUWJ0N1JkY2xJR2RxODZF?=
 =?utf-8?B?RnpyWkhtOFpFcXJZcEwxT0pmcFlWTDF0U0JBZUFzRE00YjJ0VUNTM20rb3lJ?=
 =?utf-8?B?dlBpNDFsYTE3WXpJcjJPM09tdmFoTG00U21PUGVWYkVMbFBHbHpUUC8yT05p?=
 =?utf-8?B?SlA3c1pRaGRGOGpLMUI2Tk0zRllHNTVkNHcrN0xjSVczMzJqQmtod2hUYUhK?=
 =?utf-8?B?SU54dnVnT2xPaGdOL0pWKzFZUWI3MGtXMXlUM05aRGZmWmw2NDBBak93NVFR?=
 =?utf-8?B?c1pvamRpdmhYSXhDbGl2SVVQRFJ5RGYwUXVzczBVSEtWMVUyeFgwMkZtVnox?=
 =?utf-8?B?ZjBaclQ0SVJnclhEdGdnR2xGbkd2RG85Z244RCswTCtGTGQwMmRBTTlWN0lJ?=
 =?utf-8?B?Unl1dVVnQ29hQm0zd0RwVEpHRmIyS3VZb2x2NG9LWEZKYTM3T1hGUWlnaUJ2?=
 =?utf-8?B?Y2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <86F19DDA0FCFC24B8A3A14A4471C5AAC@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0a68be4-fcaf-4cab-b842-08dafba81b26
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2023 12:07:45.4790
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mcB3aG9uKwHSVu2clHR+BlOb7/AXVHgHeuyYGG4oziTf1AMF/DlNOMgOOJ8UHecbQTMZVY8CBve3O2qLE9aETw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB8235
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCBKYW4gMjAsIDIwMjMgYXQgMDI6MDA6MjZQTSAtMDMwMCwgTHVpeiBBbmdlbG8gRGFy
b3MgZGUgTHVjYSB3cm90ZToNCj4gcnRsODM2NW1iIHdhcyB1c2luZyBhIGZpeGVkIE1UVSBzaXpl
IG9mIDE1MzYsIHByb2JhYmx5IGluc3BpcmVkIGJ5DQo+IHJ0bDgzNjZyYiBpbml0aWFsIHBhY2tl
dCBzaXplLiBEaWZmZXJlbnQgZnJvbSB0aGF0IGZhbWlseSwgcnRsODM2NW1iDQo+IGZhbWlseSBj
YW4gc3BlY2lmeSB0aGUgbWF4IHBhY2tldCBzaXplIGluIGJ5dGVzIGFuZCBub3QgaW4gZml4ZWQg
c3RlcHMuDQo+IE5vdyBpdCBkZWZhdWx0cyB0byBWTEFOX0VUSF9ITEVOK0VUSF9EQVRBX0xFTitF
VEhfRkNTX0xFTiAoMTUyMiBieXRlcykuDQo+IA0KPiBEU0EgY2FsbHMgY2hhbmdlX210dSBmb3Ig
dGhlIENQVSBwb3J0IG9uY2UgdGhlIG1heCBtdHUgdmFsdWUgYW1vbmcgdGhlDQo+IHBvcnRzIGNo
YW5nZXMuIEFzIHRoZSBtYXggcGFja2V0IHNpemUgaXMgZGVmaW5lZCBnbG9iYWxseSwgdGhlIHN3
aXRjaA0KPiBpcyBjb25maWd1cmVkIG9ubHkgd2hlbiB0aGUgY2FsbCBhZmZlY3RzIHRoZSBDUFUg
cG9ydC4NCj4gDQo+IFRoZSBhdmFpbGFibGUgc3BlY3MgZG8gbm90IGRpcmVjdGx5IGRlZmluZSB0
aGUgbWF4IHN1cHBvcnRlZCBwYWNrZXQNCj4gc2l6ZSwgYnV0IGl0IG1lbnRpb25zIGEgMTZrIGxp
bWl0LiBIb3dldmVyLCB0aGUgc3dpdGNoIHNldHMgdGhlIG1heA0KPiBwYWNrZXQgc2l6ZSB0byAx
NjM2OCBieXRlcyAoMHgzRkYwKSBhZnRlciBpdCByZXNldHMuIFRoYXQgdmFsdWUgd2FzDQo+IGFz
c3VtZWQgYXMgdGhlIG1heGltdW0gc3VwcG9ydGVkIHBhY2tldCBzaXplLg0KPiANCj4gTVRVIHdh
cyB0ZXN0ZWQgdXAgdG8gMjAxOCAod2l0aCA4MDIuMVEpIGFzIHRoYXQgaXMgYXMgZmFyIGFzIG10
NzYyMA0KPiAod2hlcmUgcnRsODM2N3MgaXMgc3RhY2tlZCkgY2FuIGdvLg0KPiANCj4gVGhlcmUg
aXMgYSBqdW1ibyByZWdpc3RlciwgZW5hYmxlZCBieSBkZWZhdWx0IGF0IDZrIHBhY2tldCBzaXpl
Lg0KPiBIb3dldmVyLCB0aGUganVtYm8gc2V0dGluZ3MgZG9lcyBub3Qgc2VlbSB0byBsaW1pdCBu
b3IgZXhwYW5kIHRoZQ0KPiBtYXhpbXVtIHRlc3RlZCBNVFUgKDIwMTgpLCBldmVuIHdoZW4ganVt
Ym8gaXMgZGlzYWJsZWQuIE1vcmUgdGVzdHMgYXJlDQo+IG5lZWRlZCB3aXRoIGEgZGV2aWNlIHRo
YXQgY2FuIGhhbmRsZSBsYXJnZXIgZnJhbWVzLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogTHVpeiBB
bmdlbG8gRGFyb3MgZGUgTHVjYSA8bHVpemx1Y2FAZ21haWwuY29tPg0KPiAtLS0NCj4gIGRyaXZl
cnMvbmV0L2RzYS9yZWFsdGVrL3J0bDgzNjVtYi5jIHwgNjMgKysrKysrKysrKysrKysrKysrKysr
KysrKysrLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCA1OSBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9u
cygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2RzYS9yZWFsdGVrL3J0bDgzNjVt
Yi5jIGIvZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWsvcnRsODM2NW1iLmMNCj4gaW5kZXggZGEzMWQ4
YjgzOWFjLi5kYTllNWYxNmM4Y2MgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2RzYS9yZWFs
dGVrL3J0bDgzNjVtYi5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2RzYS9yZWFsdGVrL3J0bDgzNjVt
Yi5jDQo+IEBAIC05OCw2ICs5OCw3IEBADQo+ICAjaW5jbHVkZSA8bGludXgvb2ZfaXJxLmg+DQo+
ICAjaW5jbHVkZSA8bGludXgvcmVnbWFwLmg+DQo+ICAjaW5jbHVkZSA8bGludXgvaWZfYnJpZGdl
Lmg+DQo+ICsjaW5jbHVkZSA8bGludXgvaWZfdmxhbi5oPg0KPiAgDQo+ICAjaW5jbHVkZSAicmVh
bHRlay5oIg0KPiAgDQo+IEBAIC0yNjcsNiArMjY4LDEyIEBADQo+ICAvKiBNYXhpbXVtIHBhY2tl
dCBsZW5ndGggcmVnaXN0ZXIgKi8NCj4gICNkZWZpbmUgUlRMODM2NU1CX0NGRzBfTUFYX0xFTl9S
RUcJMHgwODhDDQo+ICAjZGVmaW5lICAgUlRMODM2NU1CX0NGRzBfTUFYX0xFTl9NQVNLCTB4M0ZG
Rg0KPiArLyogTm90IHN1cmUgYnV0IGl0IGlzIHRoZSBkZWZhdWx0IHZhbHVlIGFmdGVyIHJlc2V0
ICovDQo+ICsjZGVmaW5lIFJUTDgzNjVNQl9DRkcwX01BWF9MRU5fTUFYCTB4M0ZGMA0KDQpUaGUg
bWF4IGxlbmd0aCBpcyAweDNGRkYgYXMgc2VlbiBpbiB0aGUgbWFzayBkZWZpbmVkIHJpZ2h0IGFi
b3ZlLg0KDQo+ICsNCj4gKyNkZWZpbmUgUlRMODM2NU1CX0ZMT1dDVFJMX0pVTUJPX1NJWkVfUkVH
CTB4MTIzQg0KPiArI2RlZmluZSAgUlRMODM2NU1CX0ZMT1dDVFJMX0pVTUJPX1NJWkVfTUFTSwlH
RU5NQVNLKDEsMCkNCj4gKyNkZWZpbmUgIFJUTDgzNjVNQl9GTE9XQ1RSTF9KVU1CT19FTkFCTEVf
TUFTSwlHRU5NQVNLKDIsMikNCg0KWW91IHdlcmUgdW5hYmxlIHRvIHRlc3QgdGhpcyBzbyBwbGVh
c2UgZHJvcCBpdCBmcm9tIHRoZSBwYXRjaC4NCg0KPiAgDQo+ICAvKiBQb3J0IGxlYXJuaW5nIGxp
bWl0IHJlZ2lzdGVycyAqLw0KPiAgI2RlZmluZSBSVEw4MzY1TUJfTFVUX1BPUlRfTEVBUk5fTElN
SVRfQkFTRQkJMHgwQTIwDQo+IEBAIC0zMDksNiArMzE2LDE0IEBADQo+ICAgKi8NCj4gICNkZWZp
bmUgUlRMODM2NU1CX1NUQVRTX0lOVEVSVkFMX0pJRkZJRVMJKDMgKiBIWikNCj4gIA0KPiArLyog
RklYTUU6IGlzIGsgaW4gezMsNCw2LDl9ayAxMDAwIG9yIDEwMjQgKi8NCj4gK2VudW0gcnRsODM2
NW1iX2p1bWJvX3NpemUgew0KPiArCVJUTDgzNjVNQl9KVU1CT19TSVpFXzNLID0gMCwNCj4gKwlS
VEw4MzY1TUJfSlVNQk9fU0laRV80SywNCj4gKwlSVEw4MzY1TUJfSlVNQk9fU0laRV82SywNCj4g
KwlSVEw4MzY1TUJfSlVNQk9fU0laRV85Sw0KPiArfTsNCj4gKw0KPiAgZW51bSBydGw4MzY1bWJf
bWliX2NvdW50ZXJfaW5kZXggew0KPiAgCVJUTDgzNjVNQl9NSUJfaWZJbk9jdGV0cywNCj4gIAlS
VEw4MzY1TUJfTUlCX2RvdDNTdGF0c0ZDU0Vycm9ycywNCj4gQEAgLTExMzUsNiArMTE1MCw0NCBA
QCBzdGF0aWMgdm9pZCBydGw4MzY1bWJfcGh5bGlua19tYWNfbGlua191cChzdHJ1Y3QgZHNhX3N3
aXRjaCAqZHMsIGludCBwb3J0LA0KPiAgCX0NCj4gIH0NCj4gIA0KPiArc3RhdGljIGludCBydGw4
MzY1bWJfY2hhbmdlX210dShzdHJ1Y3QgZHNhX3N3aXRjaCAqZHMsIGludCBwb3J0LCBpbnQgbmV3
X210dSkNCj4gK3sNCj4gKwlzdHJ1Y3QgcmVhbHRla19wcml2ICpwcml2ID0gZHMtPnByaXY7DQo+
ICsNCj4gKwkvKiBXaGVuIGEgbmV3IE1UVSBpcyBzZXQsIERTQSBhbHdheXMgc2V0IHRoZSBDUFUg
cG9ydCdzIE1UVSB0byB0aGUNCg0Kcy9hbHdheXMgc2V0L2Fsd2F5cyBzZXRzLw0KDQo+ICsJICog
bGFyZ2VzdCBNVFUgb2YgdGhlIHNsYXZlIHBvcnRzLiBCZWNhdXNlIHRoZSBzd2l0Y2ggb25seSBo
YXMgYSBnbG9iYWwNCj4gKwkgKiBSWCBsZW5ndGggcmVnaXN0ZXIsIG9ubHkgYWxsb3dpbmcgQ1BV
IHBvcnQgaGVyZSBpcyBlbm91Z2guDQo+ICsJICovDQo+ICsJaWYgKCFkc2FfaXNfY3B1X3BvcnQo
ZHMsIHBvcnQpKQ0KPiArCQlyZXR1cm4gMDsNCj4gKw0KPiArCW5ld19tdHUgKz0gVkxBTl9FVEhf
SExFTiArIEVUSF9GQ1NfTEVOOw0KDQpXaHkgVkxBTl9FVEhfSExFTiByYXRoZXIgdGhhbiBFVEhf
SExFTj8NCg0KPiArDQo+ICsJLyogRklYTUU6IFdlIG1pZ2h0IG5lZWQgdG8gYWRqdXN0IHRoZSBq
dW1ibyBzaXplIGFzIHdlbGwuIEhvd2V2ZXIsIHRoZQ0KPiArCSAqIGRldmljZSBzZWVtcyB0byBm
b3J3YXJkIGF0IGxlYXN0IHVwIHRvIG10dT0yMDE4ICh0ZXN0IGRldmljZSBsaW1pdCkNCj4gKwkg
KiBldmVuIHdpdGgganVtYm8gZnJhbWVzIGRpc2FibGVkLg0KPiArCSAqLw0KPiArCS8qIFRoaXMg
aXMgdGhlIHN3aXRjaCBzdGF0ZSBhZnRlciByZXNldCAqLw0KPiArCS8qZW51bSBydGw4MzY1bWJf
anVtYm9fc2l6ZSBqdW1ib19zaXplID0gUlRMODM2NU1CX0pVTUJPX1NJWkVfNks7DQo+ICsNCj4g
KwlyZWdtYXBfdXBkYXRlX2JpdHMocHJpdi0+bWFwLCBSVEw4MzY1TUJfRkxPV0NUUkxfSlVNQk9f
U0laRV9SRUcsDQo+ICsJCQkgICBSVEw4MzY1TUJfRkxPV0NUUkxfSlVNQk9fRU5BQkxFX01BU0sg
fA0KPiArCQkJICAgUlRMODM2NU1CX0ZMT1dDVFJMX0pVTUJPX1NJWkVfTUFTSywNCj4gKwkJCSAg
IEZJRUxEX1BSRVAoUlRMODM2NU1CX0ZMT1dDVFJMX0pVTUJPX0VOQUJMRV9NQVNLLDEpIHwNCj4g
KwkJCSAgIEZJRUxEX1BSRVAoUlRMODM2NU1CX0ZMT1dDVFJMX0pVTUJPX1NJWkVfTUFTSywNCj4g
KwkJCQkgICAgICBqdW1ib19zaXplKSk7DQo+ICsJKi8NCg0KTm8gY29tbWVudGVkIG91dCBjb2Rl
IGNhbiBiZSBhY2NlcHRlZCBpbnRvIHRoZSBkcml2ZXIsIHBsZWFzZSBkcm9wIGl0DQpmcm9tIHRo
ZSBwYXRjaCBpZiBpdCBpcyBub3QgYWJsZSB0byBiZSB1c2VkLg0KDQo+ICsNCj4gKwlyZXR1cm4g
cmVnbWFwX3VwZGF0ZV9iaXRzKHByaXYtPm1hcCwgUlRMODM2NU1CX0NGRzBfTUFYX0xFTl9SRUcs
DQo+ICsJCQkJIFJUTDgzNjVNQl9DRkcwX01BWF9MRU5fTUFTSywNCj4gKwkJCQkgRklFTERfUFJF
UChSVEw4MzY1TUJfQ0ZHMF9NQVhfTEVOX01BU0ssIG5ld19tdHUpKTsNCg0KODAgY29sdW1ucyAr
IGxvb2tzIGxpa2UgYXJndW1lbnRzIGFyZW4ndCBhbGlnbmVkIHdpdGggdGhlICgNCg0KPiArfQ0K
PiArDQo+ICtzdGF0aWMgaW50IHJ0bDgzNjVtYl9tYXhfbXR1KHN0cnVjdCBkc2Ffc3dpdGNoICpk
cywgaW50IHBvcnQpDQo+ICt7DQo+ICsJcmV0dXJuIFJUTDgzNjVNQl9DRkcwX01BWF9MRU5fTUFY
IC0gVkxBTl9FVEhfSExFTiAtIEVUSF9GQ1NfTEVOOw0KPiArfQ0KPiArDQo+ICBzdGF0aWMgdm9p
ZCBydGw4MzY1bWJfcG9ydF9zdHBfc3RhdGVfc2V0KHN0cnVjdCBkc2Ffc3dpdGNoICpkcywgaW50
IHBvcnQsDQo+ICAJCQkJCSB1OCBzdGF0ZSkNCj4gIHsNCj4gQEAgLTE5ODAsMTAgKzIwMzMsOCBA
QCBzdGF0aWMgaW50IHJ0bDgzNjVtYl9zZXR1cChzdHJ1Y3QgZHNhX3N3aXRjaCAqZHMpDQo+ICAJ
CXAtPmluZGV4ID0gaTsNCj4gIAl9DQo+ICANCj4gLQkvKiBTZXQgbWF4aW11bSBwYWNrZXQgbGVu
Z3RoIHRvIDE1MzYgYnl0ZXMgKi8NCj4gLQlyZXQgPSByZWdtYXBfdXBkYXRlX2JpdHMocHJpdi0+
bWFwLCBSVEw4MzY1TUJfQ0ZHMF9NQVhfTEVOX1JFRywNCj4gLQkJCQkgUlRMODM2NU1CX0NGRzBf
TUFYX0xFTl9NQVNLLA0KPiAtCQkJCSBGSUVMRF9QUkVQKFJUTDgzNjVNQl9DRkcwX01BWF9MRU5f
TUFTSywgMTUzNikpOw0KPiArCS8qIFNldCBwYWNrZXQgbGVuZ3RoIGZyb20gMTYzNjggdG8gMTUw
MCsxNCs0KzQ9MTUyMiAqLw0KPiArCXJldCA9IHJ0bDgzNjVtYl9jaGFuZ2VfbXR1KGRzLCBjcHUt
PnRyYXBfcG9ydCwgRVRIX0RBVEFfTEVOKTsNCg0KSSB0aGluayBEU0Egc2V0cyB0aGUgTVRVIGF1
dG9tYXRpY2FsbHksIGNmLiBkc2Ffc2xhdmVfY3JlYXRlKCkuIFRoaXMgY2FuDQpwcm9iYWJseSBi
ZSBkcm9wcGVkIG5vdyB0aGF0IHRoZSBkc2Ffc3dpdGNoX29wcyBhcmUgaW1wbGVtZW50ZWQuDQoN
Cj4gIAlpZiAocmV0KQ0KPiAgCQlnb3RvIG91dF90ZWFyZG93bl9pcnE7DQo+ICANCj4gQEAgLTIx
MDMsNiArMjE1NCw4IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgZHNhX3N3aXRjaF9vcHMgcnRsODM2
NW1iX3N3aXRjaF9vcHNfc21pID0gew0KPiAgCS5nZXRfZXRoX21hY19zdGF0cyA9IHJ0bDgzNjVt
Yl9nZXRfbWFjX3N0YXRzLA0KPiAgCS5nZXRfZXRoX2N0cmxfc3RhdHMgPSBydGw4MzY1bWJfZ2V0
X2N0cmxfc3RhdHMsDQo+ICAJLmdldF9zdGF0czY0ID0gcnRsODM2NW1iX2dldF9zdGF0czY0LA0K
PiArCS5wb3J0X2NoYW5nZV9tdHUgPSBydGw4MzY1bWJfY2hhbmdlX210dSwNCj4gKwkucG9ydF9t
YXhfbXR1ID0gcnRsODM2NW1iX21heF9tdHUsDQoNClBsZWFzZSBuYW1lIHRoZSBmdW5jdGlvbnMg
YWNjb3JkaW5nIHRvIHRoZSBkc2Ffc3dpdGNoX29wcyBuYW1lOg0KDQpydGw4MzY1bWJfY2hhbmdl
X210dSAtPiBydGw4MzY1bWJfcG9ydF9jaGFuZ2VfbXR1DQpydGw4MzY1bWJfbWF4X210dSAtPiBy
dGw4MzY1bWJfcG9ydF9tYXhfbXR1DQoNCj4gIH07DQo+ICANCj4gIHN0YXRpYyBjb25zdCBzdHJ1
Y3QgZHNhX3N3aXRjaF9vcHMgcnRsODM2NW1iX3N3aXRjaF9vcHNfbWRpbyA9IHsNCj4gQEAgLTIx
MjQsNiArMjE3Nyw4IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgZHNhX3N3aXRjaF9vcHMgcnRsODM2
NW1iX3N3aXRjaF9vcHNfbWRpbyA9IHsNCj4gIAkuZ2V0X2V0aF9tYWNfc3RhdHMgPSBydGw4MzY1
bWJfZ2V0X21hY19zdGF0cywNCj4gIAkuZ2V0X2V0aF9jdHJsX3N0YXRzID0gcnRsODM2NW1iX2dl
dF9jdHJsX3N0YXRzLA0KPiAgCS5nZXRfc3RhdHM2NCA9IHJ0bDgzNjVtYl9nZXRfc3RhdHM2NCwN
Cj4gKwkucG9ydF9jaGFuZ2VfbXR1ID0gcnRsODM2NW1iX2NoYW5nZV9tdHUsDQo+ICsJLnBvcnRf
bWF4X210dSA9IHJ0bDgzNjVtYl9tYXhfbXR1LA0KPiAgfTsNCj4gIA0KPiAgc3RhdGljIGNvbnN0
IHN0cnVjdCByZWFsdGVrX29wcyBydGw4MzY1bWJfb3BzID0gew0KPiAtLSANCj4gMi4zOS4wDQo+
DQoNCktpbmQgcmVnYXJkcywNCkFsdmlu
