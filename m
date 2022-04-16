Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F21F850361C
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 12:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbiDPLAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 07:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231570AbiDPLAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 07:00:30 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80120.outbound.protection.outlook.com [40.107.8.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C075A146;
        Sat, 16 Apr 2022 03:57:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ty4tHnLSLAem2BbfhbqLo+SnumMsiBIeVk/FFQL0FyI9jZYYy2R/M9lzcrFJLuCo9div/WZIFO1Vn/wTEKTGhHMSSkfgZjXWaypjIXKYYkvoej9XqbVqMyQ56u8J7CvqM6Bq1rdDu6/9MfVUVwaG4K6EBj3RHMHuB7gD+oTzgOeCEXAziHKVBmPiQEabzEakyesZ80ugMve+z8O44w6qyCS3OdACEtcBe0ALzC7K7N7NW2v+bPs81LogBBy71U+UWwLfMoCsaev+0TTzYDb5SkHoA89twGxgk7/kjvTOf0KgVWz0j17IkJA2wEXLEyTWvchwBwcuzMj2yUJJIG1QVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cxxiVcfMxZ9+aDNMUp5QixKfLAOm9oE8dvYn59KsSIs=;
 b=Wm4ejtkDGA+R8sCJwj4xmwf53pQ7LE+MWhY2j8jpo4zxQ33UxcwWXN9RhT4s6H9MStdpRrSZ2kc3TyRx2gR1MrbpoH4jXGUBAH+8kW5g0y8dy68a9xcFIccgo1tJ4RknS3RJl9VoVYKqHTA/dUfAbd7W47/TTOdJO+EELWyDL8wNXkqHho75JTKBLT+frIoNl1b4Qvn7m5aZuErtkEV7PjZk4cwzegMfmLQEC+3dXt5+oOozMMZSPEhy+m8c1mqZbOtB0Vf7CvYv/l+HJLlK3nzsM72QSo2gwT07Fu18M83O/B0IBQ7d3TJtLLcdYa/6MXnSeCSsJJRLIuxshTWYLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cxxiVcfMxZ9+aDNMUp5QixKfLAOm9oE8dvYn59KsSIs=;
 b=CKU+KFescXP6vwd6jaYQfA0JcrPMstmUG3xqaV9xAURhX5CxUmUZ6+xoEc+aMnDfLK7mau/RJ9z1sKNnSiTnabttPZkzrY1SpIuW285Phv9Z71lKUxXi43T/zg9mLMOg6aIYqqv5Q9J7qpVHKgCtNN23wFnZlDSAH/AucWRbKno=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by VI1PR03MB6142.eurprd03.prod.outlook.com (2603:10a6:800:142::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Sat, 16 Apr
 2022 10:57:54 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::a443:52f8:22c3:1d82]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::a443:52f8:22c3:1d82%3]) with mapi id 15.20.5164.020; Sat, 16 Apr 2022
 10:57:54 +0000
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
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH net 1/2] dt-bindings: net: dsa: realtek: cleanup
 compatible strings
Thread-Topic: [PATCH net 1/2] dt-bindings: net: dsa: realtek: cleanup
 compatible strings
Thread-Index: AQHYUVrEeNWR2gUUW0WcSJZAAVukwqzyXu6A
Date:   Sat, 16 Apr 2022 10:57:54 +0000
Message-ID: <20220416105753.ks3ztjvqkyatehqy@bang-olufsen.dk>
References: <20220416062504.19005-1-luizluca@gmail.com>
In-Reply-To: <20220416062504.19005-1-luizluca@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 67bdbf4b-dc66-4499-d300-08da1f97f575
x-ms-traffictypediagnostic: VI1PR03MB6142:EE_
x-microsoft-antispam-prvs: <VI1PR03MB614205F07F2BCE780A98CD8D83F19@VI1PR03MB6142.eurprd03.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ODXQjP52QtVabC8FPcvZ3qXaeY+xWzODovqekZ3JnIN2MiTIY+9th6owt6ti5QB6c5ro2gVsKv0i1C1716TsVultYBArjmhqKnTqJHj6VWdwWEyWWWhViHoDlZEHc1KCh59fOwCDAQC20evlo805vWQbT+ujbTg27sIjlXz3ecf7UD2k3MAX6oqwNRu4nyRq+1T6b2kIbsuKAJXEFRIcOnRYIkpyDfr1QIiZRnDhZGAyPzG5fh/0s0kaKZIfIOF+dF+BtFmBHIRZW8KerfrNOqB/NUHfM7+sIDEFXaYxVHEOT8g0gfoP2JNQI0jzklv6lkEZFxP0EQ6M4JnWr3aQzZAbS3oj62uJ23NCrj/444x+iZjbKJxd9Q7wYwvdVI//WLSCOIC5eeikguBk2BIOUqxGh3KPmhhnnMcb0GAPjKAS2bjGokMaMP/nnqKKLpGSkj1BXzz/o4Q5qQQMEjIOjJT6Osel1osGU6LWvX0pKbv6D0UhyED58eZ7gp5IVtt98s9PPK8em1d7HRecSLtGGjlXgUScOT5E3P71EEW6gI0NsKT7YMSZ+Ed9LCSqnCDAfqvH7F0p+BOWLfgUcUwsncrLWCkRqPSrUVmXc+zLLYGdS+g43Wla/AtiAvQzypw4/YOCwGixq6q4WmB3wBFoHKE1J/tq8R+d4TUm2US2gIFsbo9IVrlGIZY1W1pWJIfW64ozwq7MF9ylONopsAbxj92g/y1hTxJhnU5xnld6IyWKlIZh+2WzE+mxQhlfirnbKXiwZ1iUTHjbr20vy4bio23Zx4ohc/YD/b06azNaU1U=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(966005)(6486002)(71200400001)(186003)(26005)(1076003)(83380400001)(2616005)(36756003)(85182001)(85202003)(508600001)(5660300002)(86362001)(7416002)(316002)(2906002)(8936002)(8976002)(122000001)(91956017)(54906003)(6916009)(66556008)(66946007)(66446008)(66476007)(76116006)(64756008)(6506007)(6512007)(8676002)(4326008)(38070700005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VUdnMlJzU2RXbFp3QVVFQmNnTUszSnRLM1FHY2RvT3ZrTmVjeDNibjl1ek96?=
 =?utf-8?B?SVZvSlVXY3VENGhEMS9CTHhXNnhsZTIyd1UrQ3RESnZJeWpQWGpidGY0cFpX?=
 =?utf-8?B?Y3FyZWZoVy8xeVdINXV3OWpCODdaTklvcHFCTHhQNnhoSXFwUzVWbVZicEUv?=
 =?utf-8?B?WE1hYVhoam9pRmUwSURUZm5zSFlCTlRPVkVoMXgweTJldkhxbjh2YVdRNCtj?=
 =?utf-8?B?U2xKUEdSOFVGRms5Q1dmam41dGZSSDVIRXVUbEFGL2Z3aGxTaVBGTDIwaUlN?=
 =?utf-8?B?S3ovTWkyditjVmdhK1pzcHVyU2NxM0FubXpwb3REUFplMXRwK3htc2d0Y0JM?=
 =?utf-8?B?STlqVjk4QmFKdUExSHVmb1doSC9Jckg5aFgrL0NLamtQeVlvc1crMVMwbEtE?=
 =?utf-8?B?S3pKbThPcG5Xcml2UDJwYnJ4bnJYTWRUOVkwL3Y3V1huR0oxTFc1dlpJMnVL?=
 =?utf-8?B?ZGI2KytWVWNHaWxyYlJLY0g3M09pTU11QzJsdzk4YXo2YlFBMDZmM3Q2QXYx?=
 =?utf-8?B?VDZPMkgrNXJNUW13aVZFR252SWlyQ3dmaEh1cHlDVDVGYUxiR3kxVWJyRGRz?=
 =?utf-8?B?SENxZTMzdnJiUGpFM3d2SVdtMU12aGZ5VEJZNlFyNjkxcXR4YU5mRmJXV2RE?=
 =?utf-8?B?M055R2dMMkF2c2RtVklWWGpGQkdxR3pMQWUxOGJ4cS9HZXhjblc5eHFTY1FG?=
 =?utf-8?B?SnVRN1dJNDFLNnJhNjNPMFNHOFM0dTJOWjREN25GaWlCeC9nTkNnYmZpaUd0?=
 =?utf-8?B?TGhUbHNWOXkwMGlZQVM0VWV2bWxwVVFLUGQ0czNjNDJoTjl3NHJQOE5nOUJO?=
 =?utf-8?B?OEh5NTZuUzVFZks3NytrOGpUQ01UUjB6M3FIZjBPT3RZOFhsbWlTeWJGSDQ4?=
 =?utf-8?B?ZHZ0QjFBNTQveFQ5MVdnTEZxc3BJaGc2NE5uOXlYRGNIaU9kUFVDaDMxZjg4?=
 =?utf-8?B?RkZFOGxUNnZ5cGdXRHI3aHNsYWh5OXdTaFdNWW02U1pnOUhtT3FXWXhWelpJ?=
 =?utf-8?B?aG5wU1VPcmVVRTNFWW45TUZ3ckRTSng3aS9ESXdkdXhVemRRR1A0S1V2YjVS?=
 =?utf-8?B?QzhiMG4xK2lNL2w0dlV5OHJ6azhVc0wvRUJyRk9RODh4ZWU5ZmdDckg5UkVj?=
 =?utf-8?B?U0wvWTh5Zk96aXZmYzhWbFJ3M05qZy9SbmttSWlqSWpvaThKTm1UeHdwS2Zo?=
 =?utf-8?B?dTNGdEh5US90NkZTN3dTOTNxOGZvTHlnNko3aWZvUTVxOUVQNG9IeUlhMVM3?=
 =?utf-8?B?MDRiUEtMZmxUREZiUXNlNnR4eGxUVU5Rb2pSTXAyOUdvYTlLMWJhZGtKbWVi?=
 =?utf-8?B?UjgxMWhRNGNuS3pJZElPTGI2V1FZZUVpS2hEVlpDRWIrUllYZldURTQ1NGkv?=
 =?utf-8?B?R2syd21LZHNab1B4WWxUeUtNcWdidkVvNTJYUFR5L2RyelEzVFlHdi93d05h?=
 =?utf-8?B?VzNRU01lUVJQbzdsN2RBUjZ4UXc4bklYSkI4MmRiaUc0cjFRZUc3Ky9WYTRP?=
 =?utf-8?B?WXpvU3BuL05MYmgxRTkyT0t6U09ZK3RHNnNneld3REVxVzVLTlBkVXoxclhI?=
 =?utf-8?B?elhpWEVUMGZSdG1QYS9HbnpxdExhbVVld1UydEtmOFR5bHN6MEtmQkZqeHBr?=
 =?utf-8?B?RlRhV3lPcUt6dW0wL0h1eGRsQW14ZFlGb3dwU28wdHU3YWR5MU9DUlNDUEtO?=
 =?utf-8?B?cEhCVGVZUHRMUnBsaWNmaHlsMzBvR1ptNmVwT3VvVE1uMW10KzZ3SE5nejFJ?=
 =?utf-8?B?WTA5VGxnUHlxWlA0QXNDS29Hc1lVSXMwemt4a3BBbmZXc1NwbHFSMnNLYUJu?=
 =?utf-8?B?TEZSUFc4SmJzc1FuZXpFVGhKU2xJbWlqTHlWTDdVdjc0VEVKT01EZmRCNHdC?=
 =?utf-8?B?cTY3M2FMK0xsMFkzczYyazg0ZE1QVGF5STFGQkNyNUxWdCtKR0hIVlZyUkRm?=
 =?utf-8?B?S1JEbC9NZFgzY3dzeGVOeTJhSGR6WmhoRWdzaGZyWHZJZ2dyTDZ0WDRibXYw?=
 =?utf-8?B?MXhEejJYRXRrWFdTc2FWV3ErWXh1SExoMitndkNUdStEQ0hQSkU2dmFCZGpV?=
 =?utf-8?B?UDZVczJjNzRUd01JRGxORGlMMWNpWTNOaDNKVkNhbU9SdWFTRjBlOUlXemQ5?=
 =?utf-8?B?RlU1OVdMK2dhMGhlS2pzTWd2Rm5tUnRFbWU2K0NRRFhzZ2VXNXJ2ZHd3d2RI?=
 =?utf-8?B?UFIyRVZJdzhJWlUrUEppcTJrQ1BSMTYxOUZyczJZaUV5WFN4Wk5FanJxazVT?=
 =?utf-8?B?MTQ2TU0vNkVOazVxbE9DbTM3Y2dXbk13L1VlMXhIclBnRHlnSTFMaFRxVlJi?=
 =?utf-8?B?L3Q5S0VabWwvMTVxQ0ZwcUE3QkpEcEdxS2JqVVdwYUZvQmVMeVM3eXp3Zk04?=
 =?utf-8?Q?RhnxAIEnrKVCnG+I=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AA9BE7C18CE5814CBECE08BE4928034E@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67bdbf4b-dc66-4499-d300-08da1f97f575
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2022 10:57:54.4227
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bMgy0orNRCeLDFWDaJie3R22YRaEH8mSwCKkMLENLIcFpYDhSIX2x/4IsZGteOwoTp/s0ZxgwjhPzPAEefc2Bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR03MB6142
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU2F0LCBBcHIgMTYsIDIwMjIgYXQgMDM6MjU6MDNBTSAtMDMwMCwgTHVpeiBBbmdlbG8gRGFy
b3MgZGUgTHVjYSB3cm90ZToNCj4gQ29tcGF0aWJsZSBzdHJpbmdzIGFyZSB1c2VkIHRvIGhlbHAg
dGhlIGRyaXZlciBmaW5kIHRoZSBjaGlwIElEL3ZlcnNpb24NCj4gcmVnaXN0ZXIgZm9yIGVhY2gg
Y2hpcCBmYW1pbHkuIEFmdGVyIHRoYXQsIHRoZSBkcml2ZXIgY2FuIHNldHVwIHRoZQ0KPiBzd2l0
Y2ggYWNjb3JkaW5nbHkuIEtlZXAgb25seSB0aGUgZmlyc3Qgc3VwcG9ydGVkIG1vZGVsIGZvciBl
YWNoIGZhbWlseQ0KPiBhcyBhIGNvbXBhdGlibGUgc3RyaW5nIGFuZCByZWZlcmVuY2Ugb3RoZXIg
Y2hpcCBtb2RlbHMgaW4gdGhlDQo+IGRlc2NyaXB0aW9uLg0KPiANCj4gQ0M6IGRldmljZXRyZWVA
dmdlci5rZXJuZWwub3JnDQo+IExpbms6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL25ldGRldi8y
MDIyMDQxNDAxNDA1NS5tNHdibXI3dGR6NmhzYTNtQGJhbmctb2x1ZnNlbi5kay8NCj4gU2lnbmVk
LW9mZi1ieTogTHVpeiBBbmdlbG8gRGFyb3MgZGUgTHVjYSA8bHVpemx1Y2FAZ21haWwuY29tPg0K
PiAtLS0NCj4gIC4uLi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9kc2EvcmVhbHRlay55YW1sICB8
IDMzICsrKysrKystLS0tLS0tLS0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxMiBpbnNlcnRpb25z
KCspLCAyMSBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL2Rl
dmljZXRyZWUvYmluZGluZ3MvbmV0L2RzYS9yZWFsdGVrLnlhbWwgYi9Eb2N1bWVudGF0aW9uL2Rl
dmljZXRyZWUvYmluZGluZ3MvbmV0L2RzYS9yZWFsdGVrLnlhbWwNCj4gaW5kZXggODc1NjA2MDg5
NWE4Li45YmY4NjJhYmI0OTYgMTAwNjQ0DQo+IC0tLSBhL0RvY3VtZW50YXRpb24vZGV2aWNldHJl
ZS9iaW5kaW5ncy9uZXQvZHNhL3JlYWx0ZWsueWFtbA0KPiArKysgYi9Eb2N1bWVudGF0aW9uL2Rl
dmljZXRyZWUvYmluZGluZ3MvbmV0L2RzYS9yZWFsdGVrLnlhbWwNCj4gQEAgLTI3LDMyICsyNywy
MyBAQCBkZXNjcmlwdGlvbjoNCj4gICAgVGhlIHJlYWx0ZWstbWRpbyBkcml2ZXIgaXMgYW4gTURJ
TyBkcml2ZXIgYW5kIGl0IG11c3QgYmUgaW5zZXJ0ZWQgaW5zaWRlDQo+ICAgIGFuIE1ESU8gbm9k
ZS4NCj4gIA0KPiArICBUaGUgY29tcGF0aWJpbGl0eSBzdHJpbmcgaXMgdXNlZCBvbmx5IHRvIGZp
bmQgYW4gaWRlbnRpZmljYXRpb24gcmVnaXN0ZXIsDQoNCnMvY29tcGF0aWJpbGl0eS9jb21wYXRp
YmxlLw0KDQo+ICsgIChjaGlwIElEIGFuZCB2ZXJzaW9uKSB3aGljaCBpcyBhdCBhIGRpZmZlcmVu
dCBNRElPIGJhc2UgYWRkcmVzcyBpbiBkaWZmZXJlbnQNCj4gKyAgc3dpdGNoIGZhbWlsaWVzLiBU
aGUgZHJpdmVyIHRoZW4gdXNlcyB0aGUgY2hpcCBJRC92ZXJzaW9uIHRvIGRldmljZSBob3cgdG8N
Cj4gKyAgZHJpdmUgdGhlIHN3aXRjaC4NCg0KVGhpcyBhcHBsaWVzIHRvIE1hcnZlbGwgbmljZWx5
IGJ1dCBpdCBpcyBub3QgYWNjdXJhdGUgZm9yIFJlYWx0ZWssIHNvDQplaXRoZXIgbWFrZSBpdCBs
ZXNzIHByZWNpc2UgKGRvbid0IG1lbnRpb24gTURJTyBiYXNlIGFkZHJlc3MpLCBvciBiZQ0KbW9y
ZSBwcmVjaXNlLiBIZXJlIGlzIG15IHN1Z2dlc3Rpb246DQoNCnwgVGhlIGNvbXBhdGlibGUgc3Ry
aW5nIGlzIG9ubHkgdXNlZCB0byBpZGVudGlmeSB3aGljaCAoc2lsaWNvbikgZmFtaWx5DQp8IHRo
ZSBzd2l0Y2ggYmVsb25ncyB0by4gUm91Z2hseSBzcGVha2luZywgYSBmYW1pbHkgaXMgYW55IHNl
dCBvZiBSZWFsdGVrDQp8IHN3aXRjaGVzIHdob3NlIGNoaXAgaWRlbnRpZmljYXRpb24gcmVnaXN0
ZXIocykgaGF2ZSBhIGNvbW1vbiBsb2NhdGlvbg0KfCBhbmQgc2VtYW50aWNzLiBUaGUgZGlmZmVy
ZW50IG1vZGVscyBpbiBhIGdpdmVuIGZhbWlseSBjYW4gYmUNCnwgYXV0b21hdGljYWxseSBkaXNh
bWJpZ3VhdGVkIGJ5IHBhcnNpbmcgdGhlIGNoaXAgaWRlbnRpZmljYXRpb24NCnwgcmVnaXN0ZXIo
cykgYWNjb3JkaW5nIHRvIHRoZSBnaXZlbiBmYW1pbHksIG9idmlhdGluZyB0aGUgbmVlZCBmb3Ig
YQ0KfCB1bmlxdWUgY29tcGF0aWJsZSBzdHJpbmcgZm9yIGVhY2ggbW9kZWwuDQoNClRoaXMgYWxz
byBtYWtlcyBpdCBjbGVhciB3aGVuIGFuZCB3aHkgYSBuZXcgY29tcGF0aWJsZSBzdHJpbmcgc2hv
dWxkIGJlDQphZGRlZC4NCg0KPiArDQo+ICBwcm9wZXJ0aWVzOg0KPiAgICBjb21wYXRpYmxlOg0K
PiAgICAgIGVudW06DQo+ICAgICAgICAtIHJlYWx0ZWsscnRsODM2NW1iDQo+IC0gICAgICAtIHJl
YWx0ZWsscnRsODM2Ng0KPiAgICAgICAgLSByZWFsdGVrLHJ0bDgzNjZyYg0KPiAtICAgICAgLSBy
ZWFsdGVrLHJ0bDgzNjZzDQo+IC0gICAgICAtIHJlYWx0ZWsscnRsODM2Nw0KPiAtICAgICAgLSBy
ZWFsdGVrLHJ0bDgzNjdiDQo+IC0gICAgICAtIHJlYWx0ZWsscnRsODM2N3JiDQo+IC0gICAgICAt
IHJlYWx0ZWsscnRsODM2N3MNCj4gLSAgICAgIC0gcmVhbHRlayxydGw4MzY4cw0KPiAtICAgICAg
LSByZWFsdGVrLHJ0bDgzNjkNCj4gLSAgICAgIC0gcmVhbHRlayxydGw4MzcwDQo+ICAgICAgZGVz
Y3JpcHRpb246IHwNCj4gLSAgICAgIHJlYWx0ZWsscnRsODM2NW1iOiA0KzEgcG9ydHMNCj4gLSAg
ICAgIHJlYWx0ZWsscnRsODM2NjogNSsxIHBvcnRzDQo+IC0gICAgICByZWFsdGVrLHJ0bDgzNjZy
YjogNSsxIHBvcnRzDQo+IC0gICAgICByZWFsdGVrLHJ0bDgzNjZzOiA1KzEgcG9ydHMNCj4gLSAg
ICAgIHJlYWx0ZWsscnRsODM2NzoNCj4gLSAgICAgIHJlYWx0ZWsscnRsODM2N2I6DQo+IC0gICAg
ICByZWFsdGVrLHJ0bDgzNjdyYjogNSsyIHBvcnRzDQo+IC0gICAgICByZWFsdGVrLHJ0bDgzNjdz
OiA1KzIgcG9ydHMNCj4gLSAgICAgIHJlYWx0ZWsscnRsODM2OHM6IDggcG9ydHMNCj4gLSAgICAg
IHJlYWx0ZWsscnRsODM2OTogOCsxIHBvcnRzDQo+IC0gICAgICByZWFsdGVrLHJ0bDgzNzA6IDgr
MiBwb3J0cw0KPiArICAgICAgcmVhbHRlayxydGw4MzY1bWI6DQo+ICsgICAgICAgIFVzZSB3aXRo
IG1vZGVscyBSVEw4MzYzTkIsIFJUTDgzNjNOQi1WQiwgUlRMODM2M1NDLCBSVEw4MzYzU0MtVkIs
DQo+ICsgICAgICAgIFJUTDgzNjROQiwgUlRMODM2NE5CLVZCLCBSVEw4MzY1TUIsIFJUTDgzNjZT
QywgUlRMODM2N1JCLVZCLCBSVEw4MzY3UywNCj4gKyAgICAgICAgUlRMODM2N1NCLCBSVEw4Mzcw
TUIsIFJUTDgzMTBTUg0KPiArICAgICAgcmVhbHRlayxydGw4MzY3cmI6DQoNCnMvNjdyYi82NnJi
Lz8NCg0KPiArICAgICAgICBVc2Ugd2l0aCBtb2RlbHMgUlRMODM2NlJCLCBSVEw4MzY2Uw0KPiAg
DQo+ICAgIG1kYy1ncGlvczoNCj4gICAgICBkZXNjcmlwdGlvbjogR1BJTyBsaW5lIGZvciB0aGUg
TURDIGNsb2NrIGxpbmUuDQo+IEBAIC0zMzUsNyArMzI2LDcgQEAgZXhhbXBsZXM6DQo+ICAgICAg
ICAgICAgICAjc2l6ZS1jZWxscyA9IDwwPjsNCj4gIA0KPiAgICAgICAgICAgICAgc3dpdGNoQDI5
IHsNCj4gLSAgICAgICAgICAgICAgICAgICAgY29tcGF0aWJsZSA9ICJyZWFsdGVrLHJ0bDgzNjdz
IjsNCj4gKyAgICAgICAgICAgICAgICAgICAgY29tcGF0aWJsZSA9ICJyZWFsdGVrLHJ0bDgzNjVt
YiI7DQo+ICAgICAgICAgICAgICAgICAgICAgIHJlZyA9IDwyOT47DQo+ICANCj4gICAgICAgICAg
ICAgICAgICAgICAgcmVzZXQtZ3Bpb3MgPSA8JmdwaW8yIDIwIEdQSU9fQUNUSVZFX0xPVz47DQo+
IC0tIA0KPiAyLjM1LjENCj4=
