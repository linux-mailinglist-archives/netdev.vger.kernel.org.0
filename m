Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF936A06D0
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 11:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233866AbjBWK5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 05:57:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233668AbjBWK5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 05:57:46 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2043.outbound.protection.outlook.com [40.107.8.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8765552DF8;
        Thu, 23 Feb 2023 02:57:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ws8JWJx+R/X7ce7M/Mc0plt9MUGbTQPSROCUF0PRbFqmrT2Uob4+Cx0OlBwyBR5uxaBcqljAdSttBhyZeCrFLraks9UliLYXvsQHK3bzbwbZrnZWX9kOtzB4TUuDPAo0mUn/8IMknSDAZlmNJg6ZL7GmbkZHTzok3bHjbt1HFI8x93wsvUhAOT7938LmpK/cAlb/a9muxcc58i4pGkunPsgho3n2xYIcxADTjZx0HQcZTAnat25mJbHW6GXpOk7DnTb1Q+faqxM2TAdij1zuoegaejEQkLbO9oqVBd67C0u/WWZSR245T8ilj1tDcxeCgnlGIn/jfF6esAMeT7ra/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VVephsUmzOavwKSJIHdj++mXEOdthATEV+ACwI45pSs=;
 b=mLvbIWdwRvXDaejw3ikWD3R3yzSah3y2kBWLvsVnyEjG9gNPfHsl64sRladp+e0Cl4lSURt/VPZnsV6Jc5pZUoKU0/FMJlbJGYx/1l3uJDwECa0ioWdBUY7VQ3OmDgMyRwtIgYcfGj3gYz3/1s6fyLvAdFxKWNgyPRKJrf2zm6Xlim2tsqNbAzBlAcCxEi2IQPX6AyoLG8p/CCDRtJoj5fDtfMEDuzrL8xki/9lNKLJ6hDFvZ1Sn4ReYyJ9Bq5nlAWukCuefX+p7Xd+VXvwqzNXyEETiCcJ3PhuT1rUMnJZ+V2fhxx5XzyAjcDi2CK8oTpC8mwYDRVsEdoIo5b1AIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VVephsUmzOavwKSJIHdj++mXEOdthATEV+ACwI45pSs=;
 b=OB0jGSOHNqx0VyUdmqE3g5PZUtsAJyEhB4CBux3hVCPPio/25dviGqxKmPUfgum/BytxBRTeDu6zRE6mJ7oUlzptGo0dY8OY1geZfpvy2tTv0FaGGJSzKRTKqz59NNxYIJulVSBSNiQH1B1J6ZzErOFVjC2gMBP/iI1nVwgw+XY=
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by AM0PR04MB7075.eurprd04.prod.outlook.com (2603:10a6:208:19e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.19; Thu, 23 Feb
 2023 10:57:31 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::f8fe:ab7c:ef5d:9189]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::f8fe:ab7c:ef5d:9189%9]) with mapi id 15.20.6134.021; Thu, 23 Feb 2023
 10:57:31 +0000
From:   Neeraj sanjay kale <neeraj.sanjaykale@nxp.com>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "marcel@holtmann.org" <marcel@holtmann.org>,
        "johan.hedberg@gmail.com" <johan.hedberg@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jirislaby@kernel.org" <jirislaby@kernel.org>,
        "alok.a.tiwari@oracle.com" <alok.a.tiwari@oracle.com>,
        "hdanton@sina.com" <hdanton@sina.com>,
        "ilpo.jarvinen@linux.intel.com" <ilpo.jarvinen@linux.intel.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Amitkumar Karwar <amitkumar.karwar@nxp.com>,
        Rohit Fule <rohit.fule@nxp.com>,
        Sherry Sun <sherry.sun@nxp.com>
Subject: Re: [PATCH v4 3/3] Bluetooth: NXP: Add protocol support for NXP
 Bluetooth chipsets
Thread-Topic: [PATCH v4 3/3] Bluetooth: NXP: Add protocol support for NXP
 Bluetooth chipsets
Thread-Index: AQHZR3WgpWD/t0tqlU6mX6RpcxbzSQ==
Date:   Thu, 23 Feb 2023 10:57:31 +0000
Message-ID: <AM9PR04MB8603B0EE436B89729C692C65E7AB9@AM9PR04MB8603.eurprd04.prod.outlook.com>
References: <20230221162541.3039992-1-neeraj.sanjaykale@nxp.com>
 <20230221162541.3039992-4-neeraj.sanjaykale@nxp.com>
 <CABBYNZLod2-2biJzre+OSFepBQFWo0ApD3Jkn8WAWyrei-rKdg@mail.gmail.com>
In-Reply-To: <CABBYNZLod2-2biJzre+OSFepBQFWo0ApD3Jkn8WAWyrei-rKdg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM9PR04MB8603:EE_|AM0PR04MB7075:EE_
x-ms-office365-filtering-correlation-id: 3a7f89c6-e57a-40f3-57b0-08db158cc311
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +v+80CqL1NaEgDdwwAQqSrlsLH/p2y+9AwNqCPIcuFA46JCEvG15dBfx6Fktez43chAHsMY9cnT4cJwcs5l2F3iYH1SWRbewOHIbaRRc+yOIB4iehszsT38W9YYlFX5HIRAZqhIz3Tw3Ada8SWESQgm+fke8II4P2YqG4UIR2CgYNObC9KlgiLcHyj+Omgtewy7h2Xk13psyp/tJ2bhvvqD2VZPcJj5+dgb3ZeUJ7yNY5MS29cY3TT2vfJ2arSqni4x6tDzXpQ2VOovVeeQ4D4RUsKkmFNQoeNngUJncSxtcOLjACNSrDXg0VBZcNenqnN/F4h1fYqvivaBvfWvy8wWqJngJdlLufX6ozGiQILPl6rPhIlg0eaCqNCBq93lkl/9PdV/SY8u0cCW97dSKsNQJB3omHK8Y5DxEZXR8MUnigR7us4LZnvzddR7rQgj/MbJZc35VeobPk1BvfuadPElpe7ecwaN73C4o2gdkxOxkCdd3RJ1rND6vw8GrKzE6ApPZ2ao+r7cKuawgVB6ZMcajSwGh80SetmZFQiOBsEboMaAy4Fm+qRw9A+cWLv9J4AOfGojnecm9JePvmakz85KUQNwAkWyLtpVJNA3zc6qkgwTmvx9SHC0VXSNlA74kcE7SGYCDzwAg3veovnOB+YPRe8NDB78hAdq0XvaOhEdBeQ9npNkeqS16RtmwYHvk
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(346002)(136003)(396003)(366004)(451199018)(71200400001)(7696005)(186003)(26005)(66899018)(7416002)(5660300002)(966005)(9686003)(6506007)(54906003)(316002)(83380400001)(38070700005)(33656002)(8676002)(6916009)(64756008)(66446008)(4326008)(55016003)(52536014)(8936002)(41300700001)(76116006)(66476007)(66556008)(66946007)(478600001)(38100700002)(122000001)(86362001)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MDQvYit5U2hMZjFMSkc0TVcyTzVpRHdkL2drd0NoUXFlcGdJWHc3ak1VdG5U?=
 =?utf-8?B?NWxjQ05jSTlCNzZXSTliWFdCUjBMSWVjRmRpUFFBRmVEcEZmdmhRMW5BN2pP?=
 =?utf-8?B?eG5xYkFmaEx2OXJyQW1zWHBLaVRhd1pURzdFR3cwd1laTmcrR1hKOHN2Umpq?=
 =?utf-8?B?TTJ6d1FoZWdxOXBjaTdqbnNaYkQyMVBsRG1sbDR3MFQvT21GeWNsTlNzamFU?=
 =?utf-8?B?Ny9rQ3dpQy9iY2syWm80OGtiUVpyV3lHV09WdGs2c1VhOXhDaGt5WitIaWJ6?=
 =?utf-8?B?Z2xXSFNBOGJjbm84Q1ZPM2J2RmJWMG1laTF0MVBqVElqdWtQTWpBeUFVbXpC?=
 =?utf-8?B?aXd5cHpPYnJyWER6bTBNeW5DS1RJbE9sZVVhNDh2djZsekp4bGlYWkFYcEg1?=
 =?utf-8?B?K3VBeCtyb0tpV203ZFpCN0lTTlhKb0JUMjdPdEhkQlBleFRkTHlWN21HWXhW?=
 =?utf-8?B?ZEljaEJvYThIWjJZcGxqTm1oT2lNU1NYcUNJdjJ0YmhudTk4NXNsVzdINDgz?=
 =?utf-8?B?M3FVd1lheTQwVUpYc2w5dU5nNGhaY212MzJxMnkvSjYrWkVhbVhMb3RqbEpB?=
 =?utf-8?B?UGpPTzUyazNiT1dEdXRsQUpkdllTRnBOM2gwR1QvaDhxVDhWRm1IdnNxQ3JL?=
 =?utf-8?B?Q0NLT01hT0ZxSzFlV0loY3o4WkV3NkxTNEdPamVFOWFvUXkxTHRqSWNtMHVC?=
 =?utf-8?B?UGZOUTYxZk9rWnlJSkNwRElmTE92YWp3eTMzanpqUkg5cDAxU1ZiWkQrUUNB?=
 =?utf-8?B?UXd5UEhaeTNmRVZ4Z0JZMVdLQVZGNmRCTlRBTEZtSVhPRC9WWkhqdWxkMkFS?=
 =?utf-8?B?c0lnMm5RZzNQb2JxNkJSdEYxY0pVeVdKQlpDNFNIWnNCamQwL3I2NFZMbW5v?=
 =?utf-8?B?L2EzVTlYRkNnWVkxTlgzRGE3enlLcDJETXdnbGZzL003ZGx3S0tla094bzlt?=
 =?utf-8?B?VkdtRVo0OVAxV0Y4VHVOeTIyK1JVU2Zmak0rWUlvZ0VYQUJTNVVFZ1dqRmtp?=
 =?utf-8?B?eWxMTnRiVGpXcCtZN0hmZ3hWZkJDWndWRVRybzFVc0tkTGFFOWdES3FNaEtW?=
 =?utf-8?B?S3U5NG1iS09iZnFRYXFDWEZ1U3V1cEtXckZ5Z3lkMDVFT2hUZzhRc2FwZ1FO?=
 =?utf-8?B?YmZGZk5ZdHhkWHJsVjJpemo4dDlzQUxhbVk5U3VqeDc2V1ppeGUzcnRvUEZM?=
 =?utf-8?B?aU0vaWJlZUw2RjVncUdic1UzSnFKQzRxNnZRc0xxSWNVS2JqNFpaR0d4Y0Qy?=
 =?utf-8?B?aWpiVjRBSHdBRkxPMGQyc1ptQU5BeEZhbVZ3dFpHUTVhQm5PWlBTMzl3Ti8r?=
 =?utf-8?B?Ukl4NVN3aTUyaVNQS25YSUlERkkvKzBGeVdWTjZvcC92eVNyOVJTQTVFUEl1?=
 =?utf-8?B?TFVFRjV4MForQkNsdVJ6MVptb3NuMkQrY3h6dmZPVG15YlpseFdETTNjYWtv?=
 =?utf-8?B?aXNFak9NWEFGTXVucHlQczlob09jdWx6SndWRlB2YWpqR2hWTFR1NzhUcEZK?=
 =?utf-8?B?eVRpUGVsamJEOHdDeVhQZlBnMlpsZHhFbEVLbXJWckZEcm9iL0RWNFNJY3R3?=
 =?utf-8?B?dnIxQU9CWU9CZGpadERCbnNFcjQ4OGVTYkRnQ0FHK3BjNXg5VGY2RlRkYUUr?=
 =?utf-8?B?U0ZOek03eGE4UG9DZlhSUlFpNnM4Vi91VDBSZG9Wc2Z1ZmpGYlVnamNHRzFu?=
 =?utf-8?B?dFhUN2dScW9yekF0VzFMdVVscVJnOHV4UzVsWVkvZHAxaVNYLytIcVFOTU1i?=
 =?utf-8?B?a1QvY2NZd0o1N1czZ1RxTUN3L1VGN1ZxL2o2R2NhcmloM0pHQ1hySzJncndm?=
 =?utf-8?B?T1RXN2gza25pT1IvSnVlemxHNVRickFPS0I5blp5YUNsUCtRSG90LzE3SlRy?=
 =?utf-8?B?aWlkL0RTbE93RzVtaG9KSGNrcHd6T1M0RkxuRkdMNUJmREFtbmRsMjE3NUZ4?=
 =?utf-8?B?WThCQVhGOG1SN1E5UXJtdDY0YW1RbWRQak9sSUYrV2tpNHVyQ1k0VjhZWFla?=
 =?utf-8?B?M0RuQzRTVm1ueFdKY1ZjOUhhUGdYc09WTjNCN3FyQ3AxUDhWNG5ZN2R4UWlk?=
 =?utf-8?B?M3p5NVc5eVVyaWk0WUcxbVRjUURlbDNZZ1diVW1ZajdoOG4wYXZjQXV3eXk3?=
 =?utf-8?B?eVBCZ3ZtSEMvbWdUM2gzK2E3Nk11TXpMYjFMR3UwUThSRkt1eEoydXpOeUFu?=
 =?utf-8?B?enc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a7f89c6-e57a-40f3-57b0-08db158cc311
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2023 10:57:31.4730
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jZumtYdKPykuyH520MCpH6alI+v8hiquz5AWCgvKgvbTaJnxMw6kXjIqyT59LrDPZDKz05Tsz1H5IttdSEmlm4VCixo1NNgHYO/dGgoYhl8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB7075
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTHVpeiwNCg0KVGhhbmsgeW91IGZvciByZXZpZXdpbmcgdGhpcyBwYXRjaC4gSSBoYXZlIHJl
c29sdmVkIGFsbCB0aGUgY29tbWVudHMgaW4gVjUgcGF0Y2guDQoNCj4gPiArc3RhdGljIGludCBu
eHBfcmVjdl9md19yZXFfdjMoc3RydWN0IGhjaV9kZXYgKmhkZXYsIHN0cnVjdCBza19idWZmICpz
a2IpDQo+ID4gK3sNCj4gPiArICAgICAgIHN0cnVjdCB2M19kYXRhX3JlcSAqcmVxID0gc2tiX3B1
bGxfZGF0YShza2IsIHNpemVvZihzdHJ1Y3QNCj4gdjNfZGF0YV9yZXEpKTsNCj4gPiArICAgICAg
IHN0cnVjdCBidG54cHVhcnRfZGV2ICpueHBkZXYgPSBoY2lfZ2V0X2RydmRhdGEoaGRldik7DQo+
ID4gKw0KPiA+ICsgICAgICAgaWYgKCFyZXEgfHwgIW54cGRldiB8fCAhbnhwZGV2LT5mdykNCj4g
PiArICAgICAgICAgICAgICAgZ290byByZXQ7DQo+ID4gKw0KPiA+ICsgICAgICAgaWYgKCF0ZXN0
X2JpdChCVE5YUFVBUlRfRldfRE9XTkxPQURJTkcsICZueHBkZXYtPnR4X3N0YXRlKSkNCj4gPiAr
ICAgICAgICAgICAgICAgZ290byByZXQ7DQo+ID4gKw0KPiA+ICsgICAgICAgbnhwX3NlbmRfYWNr
KE5YUF9BQ0tfVjMsIGhkZXYpOw0KPiA+ICsNCj4gPiArICAgICAgIGlmICghbnhwZGV2LT50aW1l
b3V0X2NoYW5nZWQpIHsNCj4gPiArICAgICAgICAgICAgICAgbnhwZGV2LT50aW1lb3V0X2NoYW5n
ZWQgPSBueHBfZndfY2hhbmdlX3RpbWVvdXQoaGRldiwgcmVxLQ0KPiA+bGVuKTsNCj4gPiArICAg
ICAgICAgICAgICAgZ290byByZXQ7DQo+ID4gKyAgICAgICB9DQo+ID4gKw0KPiA+ICsgICAgICAg
aWYgKCFueHBkZXYtPmJhdWRyYXRlX2NoYW5nZWQpIHsNCj4gPiArICAgICAgICAgICAgICAgbnhw
ZGV2LT5iYXVkcmF0ZV9jaGFuZ2VkID0gbnhwX2Z3X2NoYW5nZV9iYXVkcmF0ZShoZGV2LA0KPiBy
ZXEtPmxlbik7DQo+ID4gKyAgICAgICAgICAgICAgIGlmIChueHBkZXYtPmJhdWRyYXRlX2NoYW5n
ZWQpIHsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICBzZXJkZXZfZGV2aWNlX3NldF9iYXVk
cmF0ZShueHBkZXYtPnNlcmRldiwNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICBIQ0lfTlhQX1NFQ19CQVVEUkFURSk7DQo+ID4gKyAgICAgICAg
ICAgICAgICAgICAgICAgc2VyZGV2X2RldmljZV9zZXRfZmxvd19jb250cm9sKG54cGRldi0+c2Vy
ZGV2LCAxKTsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICBueHBkZXYtPmN1cnJlbnRfYmF1
ZHJhdGUgPSBIQ0lfTlhQX1NFQ19CQVVEUkFURTsNCj4gPiArICAgICAgICAgICAgICAgfQ0KPiA+
ICsgICAgICAgICAgICAgICBnb3RvIHJldDsNCj4gPiArICAgICAgIH0NCj4gPiArDQo+ID4gKyAg
ICAgICBpZiAocmVxLT5sZW4gPT0gMCkgew0KPiA+ICsgICAgICAgICAgICAgICBidF9kZXZfaW5m
byhoZGV2LCAiRlcgRG93bmxvYWRlZCBTdWNjZXNzZnVsbHk6ICV6dSBieXRlcyIsDQo+IG54cGRl
di0+ZnctPnNpemUpOw0KPiA+ICsgICAgICAgICAgICAgICBjbGVhcl9iaXQoQlROWFBVQVJUX0ZX
X0RPV05MT0FESU5HLCAmbnhwZGV2LT50eF9zdGF0ZSk7DQo+ID4gKyAgICAgICAgICAgICAgIHdh
a2VfdXBfaW50ZXJydXB0aWJsZSgmbnhwZGV2LT5zdXNwZW5kX3dhaXRfcSk7DQo+ID4gKyAgICAg
ICAgICAgICAgIGdvdG8gcmV0Ow0KPiA+ICsgICAgICAgfQ0KPiA+ICsgICAgICAgaWYgKHJlcS0+
ZXJyb3IpDQo+ID4gKyAgICAgICAgICAgICAgIGJ0X2Rldl9lcnIoaGRldiwgIkZXIERvd25sb2Fk
IHJlY2VpdmVkIGVyciAweCUwMnggZnJvbSBjaGlwLg0KPiBSZXNlbmRpbmcgRlcgY2h1bmsuIiwN
Cj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICByZXEtPmVycm9yKTsNCj4gPiArDQo+ID4g
KyAgICAgICBpZiAocmVxLT5vZmZzZXQgPCBueHBkZXYtPmZ3X3YzX29mZnNldF9jb3JyZWN0aW9u
KSB7DQo+ID4gKyAgICAgICAgICAgICAgIC8qIFRoaXMgc2NlbmFyaW8gc2hvdWxkIGlkZWFsbHkg
bmV2ZXIgb2NjdXIuDQo+ID4gKyAgICAgICAgICAgICAgICAqIEJ1dCBpZiBpdCBldmVyIGRvZXMs
IEZXIGlzIG91dCBvZiBzeW5jIGFuZA0KPiA+ICsgICAgICAgICAgICAgICAgKiBuZWVkcyBhIHBv
d2VyIGN5Y2xlLg0KPiA+ICsgICAgICAgICAgICAgICAgKi8NCj4gPiArICAgICAgICAgICAgICAg
YnRfZGV2X2VycihoZGV2LCAiU29tZXRoaW5nIHdlbnQgd3JvbmcgZHVyaW5nIEZXIGRvd25sb2Fk
Lg0KPiBQbGVhc2UgcG93ZXIgY3ljbGUgYW5kIHRyeSBhZ2FpbiIpOw0KPiANCj4gQ2FuJ3Qgd2Ug
YWN0dWFsbHkgcG93ZXIgY3ljbGUgaW5zdGVhZCBvZiBwcmludGluZyBhbiBlcnJvcj8NClRoZSBO
WFAgY2hpcHMgZHJhdyBwb3dlciBmcm9tIHRoZSBwbGF0Zm9ybSdzIDVWIHBvd2VyIHN1cHBseSwg
d2hpY2ggaXMgdXNlZCBieSBXTEFOIGFzIHdlbGwgYXMgQlQgc3ViLXN5c3RlbSBpbnNpZGUgdGhl
IGNoaXAuIFRoZXNlIGNoaXBzIGhhdmUgbm8gbWVjaGFuaXNtIHRvIHJlc2V0IG9yIHBvd2VyLWN5
Y2xlIEJUIG9ubHkgc3ViLXN5c3RlbSBpbmRlcGVuZGVudGx5Lg0KPiANCj4gPiArICAgICAgICAg
ICAgICAgZ290byByZXQ7DQo+ID4gKyAgICAgICB9DQo+ID4gKw0KPiA+ICsgICAgICAgc2VyZGV2
X2RldmljZV93cml0ZV9idWYobnhwZGV2LT5zZXJkZXYsDQo+ID4gKyAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBueHBkZXYtPmZ3LT5kYXRhICsgcmVxLT5vZmZzZXQgLSBueHBkZXYtDQo+
ID5md192M19vZmZzZXRfY29ycmVjdGlvbiwNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIHJlcS0+bGVuKTsNCj4gPiArDQo+ID4gK3JldDoNCj4gPiArICAgICAgIGtmcmVlX3Nr
Yihza2IpOw0KPiA+ICsgICAgICAgcmV0dXJuIDA7DQo+ID4gK30NCj4gPiArDQoNCg0KPiA+ICtz
dGF0aWMgaW50IG54cF9lbnF1ZXVlKHN0cnVjdCBoY2lfZGV2ICpoZGV2LCBzdHJ1Y3Qgc2tfYnVm
ZiAqc2tiKQ0KPiA+ICt7DQo+ID4gKyAgICAgICBzdHJ1Y3QgYnRueHB1YXJ0X2RldiAqbnhwZGV2
ID0gaGNpX2dldF9kcnZkYXRhKGhkZXYpOw0KPiA+ICsgICAgICAgc3RydWN0IHBzX2RhdGEgKnBz
ZGF0YSA9IG54cGRldi0+cHNkYXRhOw0KPiA+ICsgICAgICAgc3RydWN0IGhjaV9jb21tYW5kX2hk
ciAqaGRyOw0KPiA+ICsgICAgICAgdTggKnBhcmFtOw0KPiA+ICsNCj4gPiArICAgICAgIGlmICgh
bnhwZGV2IHx8ICFwc2RhdGEpDQo+ID4gKyAgICAgICAgICAgICAgIGdvdG8gZnJlZV9za2I7DQo+
ID4gKw0KPiA+ICsgICAgICAgLyogaWYgdmVuZG9yIGNvbW1hbmRzIGFyZSByZWNlaXZlZCBmcm9t
IHVzZXIgc3BhY2UgKGUuZy4gaGNpdG9vbCksDQo+IHVwZGF0ZQ0KPiA+ICsgICAgICAgICogZHJp
dmVyIGZsYWdzIGFjY29yZGluZ2x5IGFuZCBhc2sgZHJpdmVyIHRvIHJlLXNlbmQgdGhlIGNvbW1h
bmQgdG8NCj4gRlcuDQo+ID4gKyAgICAgICAgKi8NCj4gPiArICAgICAgIGlmIChidF9jYihza2Ip
LT5wa3RfdHlwZSA9PSBIQ0lfQ09NTUFORF9QS1QgJiYgIXBzZGF0YS0NCj4gPmRyaXZlcl9zZW50
X2NtZCkgew0KPiA+ICsgICAgICAgICAgICAgICBoZHIgPSAoc3RydWN0IGhjaV9jb21tYW5kX2hk
ciAqKXNrYi0+ZGF0YTsNCj4gDQo+IEl0IGlzIG5vdCBzYWZlIHRvIGFjY2VzcyB0aGUgY29udGVu
dHMgb2Ygc2tiLT5kYXRhIHdpdGhvdXQgZmlyc3QNCj4gY2hlY2tpbmcgc2tiLT5sZW4sIEkgdW5k
ZXJzdGFuZCB5b3UgY2FuJ3QgdXNlIHNrYl9wdWxsX2RhdGEgc2luY2UgdGhhdA0KPiBjaGFuZ2Vz
IHRoZSBwYWNrZXQgYnV0IEltIG5vdCBzbyBoYXBweSB3aXRoIHRoaXMgY29kZSBlaXRoZXIgd2F5
IHNpbmNlDQo+IHlvdSBhcHBlYXIgdG8gYmUgZG9pbmcgdGhpcyBvbmx5IHRvIHN1cHBvcnQgdXNl
cnNwYWNlIGluaXRpYXRpbmcgdGhlc2UNCj4gY29tbWFuZHMgYnV0IGlzIHRoYXQgcmVhbGx5IGV4
cGVjdGVkIG9yIHlvdSBhcmUganVzdCBkb2luZyB0aGlzIGZvcg0KPiB0ZXN0aW5nIHB1cnBvc2U/
IEFsc28gd2h5IG5vdCBkb2luZyB0aGlzIGhhbmRsaW5nIG9uIHRoZSBjb21tYW5kDQo+IGNvbXBs
ZXRlL2NvbW1hbmQgc3RhdHVzIGV2ZW50IGFzIHRoYXQgd291bGQgYmUgY29tbW9uIHRvIGJvdGgg
ZHJpdmVyDQo+IG9yIHVzZXJzcGFjZSBpbml0aWF0ZWQ/DQo+IA0KSSBoYXZlIG1hZGUgZmV3IGNo
YW5nZXMgdG8gaGFuZGxlIHRoaXMgaXNzdWUgaW4gYSBzYWZlIHdheSBieSBjaGVja2luZw0Kc2ti
LT5sZW4gYW5kIGhkci0+cGxlbiBiZWZvcmUgdXNpbmcgdGhlIHBhcmFtZXRlcnMuDQpXZSBkbyBu
ZWVkIHRvIHBhcnNlIGEgY291cGxlIG9mIHVzZXIgc3BhY2UgdmVuZG9yIGNvbW1hbmRzIGJlZm9y
ZSBmb3J3YXJkaW5nDQp0aGVtIHRvIHRoZSBGVywgc2luY2UgdGhlIGRyaXZlciBuZWVkcyB0byB1
cGRhdGUgaXRzIGludGVybmFsIGZsYWdzIGFuZCBtZWNoYW5pc20NCmFjY29yZGluZ2x5LiBXZSBk
byBub3QgdXN1YWxseSBnZXQgdGhlIHBhcmFtZXRlcnMgd2hpbGUgaGFuZGxpbmcgY29tbWFuZCBj
b21wbGV0ZQ0Kb3IgY29tbWFuZCBzdGF0dXMgZXZlbnRzLg0KSW4gb25lIG9mIHRoZSBwcmV2aW91
cyBwYXRjaGVzIEkgd2FzIHBhcnNpbmcgcGFyYW1ldGVycyBpbiBueHBfZW5xdWV1ZSwgYW5kIHVw
ZGF0aW5nDQpkcml2ZXIgZmxhZ3MgaW4gcHNfY2hlY2tfZXZlbnRfcGFja2V0KCkgb24gc3RhdHVz
IHN1Y2Nlc3MuDQpodHRwczovL3BhdGNod29yay5rZXJuZWwub3JnL3Byb2plY3QvYmx1ZXRvb3Ro
L3BhdGNoLzE2NjkyMDc0MTMtOTYzNy0xLWdpdC1zZW5kLWVtYWlsLW5lZXJhai5zYW5qYXlrYWxl
QG54cC5jb20vDQoNCj4gDQo+ID4gKyAgICAgICAgICAgICAgIHBhcmFtID0gc2tiLT5kYXRhICsg
SENJX0NPTU1BTkRfSERSX1NJWkU7DQo+ID4gKyAgICAgICAgICAgICAgIHN3aXRjaCAoX19sZTE2
X3RvX2NwdShoZHItPm9wY29kZSkpIHsNCj4gPiArICAgICAgICAgICAgICAgY2FzZSBIQ0lfTlhQ
X0FVVE9fU0xFRVBfTU9ERToNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICBpZiAoaGRyLT5w
bGVuID49IDEpIHsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGlmIChwYXJh
bVswXSA9PSBCVF9QU19FTkFCTEUpDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIHBzZGF0YS0+cHNfbW9kZSA9IFBTX01PREVfRU5BQkxFOw0KPiA+ICsgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgZWxzZSBpZiAocGFyYW1bMF0gPT0gQlRfUFNfRElTQUJM
RSkNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgcHNkYXRhLT5w
c19tb2RlID0gUFNfTU9ERV9ESVNBQkxFOw0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgaGNpX2NtZF9zeW5jX3F1ZXVlKGhkZXYsIHNlbmRfcHNfY21kLCBOVUxMLCBOVUxMKTsN
Cj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGdvdG8gZnJlZV9za2I7DQo+ID4g
KyAgICAgICAgICAgICAgICAgICAgICAgfQ0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgIGJy
ZWFrOw0KPiA+ICsgICAgICAgICAgICAgICBjYXNlIEhDSV9OWFBfV0FLRVVQX01FVEhPRDoNCj4g
PiArICAgICAgICAgICAgICAgICAgICAgICBpZiAoaGRyLT5wbGVuID49IDQpIHsNCj4gPiArICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIHN3aXRjaCAocGFyYW1bMl0pIHsNCj4gPiArICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNhc2UgQlRfQ1RSTF9XQUtFVVBfTUVUSE9EX0RT
UjoNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgcHNkYXRhLT53
YWtldXBtb2RlID0gV0FLRVVQX01FVEhPRF9EVFI7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIGJyZWFrOw0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgY2FzZSBCVF9DVFJMX1dBS0VVUF9NRVRIT0RfQlJFQUs6DQo+ID4gKyAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICBkZWZhdWx0Og0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICBwc2RhdGEtPndha2V1cG1vZGUgPSBXQUtFVVBfTUVUSE9EX0JSRUFL
Ow0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBicmVhazsNCj4g
PiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIH0NCj4gPiArICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIGhjaV9jbWRfc3luY19xdWV1ZShoZGV2LCBzZW5kX3dha2V1cF9tZXRo
b2RfY21kLA0KPiBOVUxMLCBOVUxMKTsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIGdvdG8gZnJlZV9za2I7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgfQ0KPiA+ICsg
ICAgICAgICAgICAgICAgICAgICAgIGJyZWFrOw0KPiA+ICsgICAgICAgICAgICAgICBjYXNlIEhD
SV9OWFBfU0VUX09QRVJfU1BFRUQ6DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgaWYgKGhk
ci0+cGxlbiA9PSA0KSB7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBueHBk
ZXYtPm5ld19iYXVkcmF0ZSA9ICooKHUzMiAqKXBhcmFtKTsNCj4gPiArICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIGhjaV9jbWRfc3luY19xdWV1ZShoZGV2LCBueHBfc2V0X2JhdWRyYXRl
X2NtZCwNCj4gTlVMTCwgTlVMTCk7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBnb3RvIGZyZWVfc2tiOw0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgIH0NCj4gPiArICAg
ICAgICAgICAgICAgICAgICAgICBicmVhazsNCj4gPiArICAgICAgICAgICAgICAgY2FzZSBIQ0lf
TlhQX0lORF9SRVNFVDoNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICBpZiAoaGRyLT5wbGVu
ID09IDEpIHsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGhjaV9jbWRfc3lu
Y19xdWV1ZShoZGV2LCBueHBfc2V0X2luZF9yZXNldCwgTlVMTCwNCj4gTlVMTCk7DQo+ID4gKyAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBnb3RvIGZyZWVfc2tiOw0KPiA+ICsgICAgICAg
ICAgICAgICAgICAgICAgIH0NCj4gPiArICAgICAgICAgICAgICAgICAgICAgICBicmVhazsNCj4g
PiArICAgICAgICAgICAgICAgZGVmYXVsdDoNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICBi
cmVhazsNCj4gPiArICAgICAgICAgICAgICAgfQ0KPiA+ICsgICAgICAgfQ0KPiA+ICsNCj4gPiAr
ICAgICAgIC8qIFByZXBlbmQgc2tiIHdpdGggZnJhbWUgdHlwZSAqLw0KPiA+ICsgICAgICAgbWVt
Y3B5KHNrYl9wdXNoKHNrYiwgMSksICZoY2lfc2tiX3BrdF90eXBlKHNrYiksIDEpOw0KPiA+ICsg
ICAgICAgc2tiX3F1ZXVlX3RhaWwoJm54cGRldi0+dHhxLCBza2IpOw0KPiA+ICsNCj4gPiArICAg
ICAgIGJ0bnhwdWFydF90eF93YWtldXAobnhwZGV2KTsNCj4gPiArcmV0Og0KPiA+ICsgICAgICAg
cmV0dXJuIDA7DQo+ID4gKw0KPiA+ICtmcmVlX3NrYjoNCj4gPiArICAgICAgIGtmcmVlX3NrYihz
a2IpOw0KPiA+ICsgICAgICAgZ290byByZXQ7DQo+ID4gK30NCj4gPiArDQoNClRoYW5rcywNCk5l
ZXJhag0K
