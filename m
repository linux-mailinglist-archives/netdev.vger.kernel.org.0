Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8DEA6058BD
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 09:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbiJTHgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 03:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbiJTHgG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 03:36:06 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2122.outbound.protection.outlook.com [40.107.113.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86982166572;
        Thu, 20 Oct 2022 00:36:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F2n4nAKK8RrqejrnDTzsZbbIB13IG/WJZEyrPN3WiDUOv08wQVXZOura1PXMHeVIeFGXltcjp68Kif5xTJp29m0Yn27GNNU2TwHrTN1YKsCcpR0iSnvAjHr+BrBQfJcMn0ohvTrNGOSdoRkFzkYMNioK5C0URHzFTk06jpC+Wdn61k5teeL9TICEN6VskzfLYf6bwpmzb4wmJYZBMm+0jwWrWvipeCsjRAY9p6QP7jHltOzH7yTOkKomET65U9KWYP92+fsc2OHWmjcpryxGBiD83qJJbcHRFxLHNHidmuM4BdG7pSKO2Qm0kZ/CZPxL6o6gz+HCTAqJqOfcvlnVKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9cu4IcvDw3yDTatQvDx4wIeT5EsjfbAMHYK/Ad9bsSE=;
 b=l/j4KRK+ON+EBHZdOn4WuskajU+ds5S7eowbidW38OmyikRMsH/yc/daonA7vikCn9Qs4GcdAqmaB4OUytmwLXb1mvx6KSgsA8f1CEI6cyjGGqf05D6Xg0hldJQcN+B1L0urlBYuOdMb8ZXF70v5GUSr6rhinuTKKK00jI7AC0v+qv9q/ngA97eGS0VdHSd73z7U7Ks8mL6Wks6XHJMTAYgBWnymRTmKtassuW1mkfSjx0Z1aHHfwzyENIn+CPfe8f/dOo8D7opn5RLqeBxEM+Nm3sCu/C7OcP/mee/6jbhGekDSCEWOsAuy9nfhNuSLc7W0rs6ESfT9pRCiTghPOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9cu4IcvDw3yDTatQvDx4wIeT5EsjfbAMHYK/Ad9bsSE=;
 b=StdUc/I7Lr1VKzcIQpqkjfEN0BM1QeBXmDxRa3wbocMYwSieZcPgl0GpuF49bhnHdJLb9/cilaSMYXHFBQEvR+v+XcXyvRc7kznDdx+C4oaVsFkzgTlD+kuVqeutLsAcD8k28t4vj2C2maVPryo/f4c2YXd0hD1fwzyu333sFds=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by OS3PR01MB9463.jpnprd01.prod.outlook.com
 (2603:1096:604:1c7::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34; Thu, 20 Oct
 2022 07:35:59 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::51b0:c391:5c63:4af4]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::51b0:c391:5c63:4af4%3]) with mapi id 15.20.5723.034; Thu, 20 Oct 2022
 07:35:59 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH v4 2/3] net: ethernet: renesas: Add Ethernet Switch driver
Thread-Topic: [PATCH v4 2/3] net: ethernet: renesas: Add Ethernet Switch
 driver
Thread-Index: AQHY45W84OTfYE+kgU+A+iXKytdlb64WjrIAgABMRaA=
Date:   Thu, 20 Oct 2022 07:35:59 +0000
Message-ID: <TYBPR01MB5341BFDA86EE48F07DBC9882D82A9@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20221019083518.933070-1-yoshihiro.shimoda.uh@renesas.com>
 <20221019083518.933070-3-yoshihiro.shimoda.uh@renesas.com>
 <ccd7f1fc-b2e2-7acf-d7fd-85191564603a@gmail.com>
In-Reply-To: <ccd7f1fc-b2e2-7acf-d7fd-85191564603a@gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|OS3PR01MB9463:EE_
x-ms-office365-filtering-correlation-id: 2dafb0ee-951a-494e-72e3-08dab26dbbca
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: reg/OvlmlpI8BubbJ604H0LifJUblWUuSG1zCJX3G06/BTaZK1hpQN70fXGmYGz4p06E/1vXkzd+5dz4ONTb+XljY0fbYb9y8x/wdZJ9CsJxlBx4GqIwqUgtZYkB2/Pkm1KoIrhSlu38Izna94XdVZIkaBhZu4ZG6Rpfh/oyWxtppTdYt9KbDsgdNn1UMpp3QZlaw7JuYGGnXIAsMqcQ4h2Sz8crJstV+/iLRAJBcdyH3MmdF7coQr0m7yD6NWOfa273n2AFmtOFe5L3Zu+uSmii4/VDu/eSDOBA5YRcnWOZ5s7+FD7LM4wOzETQziIuy9Liq7fHYfYg82Ugtz2lWetsx1fuOAVRUL6VvmGW9SXLJMX23EfDWTGjvVmF3mGWqQ/2Mr13UM7MDbb897o6agcQq070ksHOdiaQzjWd2+Y0K9Ifbv+14IyHSg+OmScGTaUoqVsIthJSJnJNchihDWEr4phJwqFdMQoxpDqTUe+2UlMpi+TtY3bZMyjuZI08DUgGcd0c3ssLDNrk9YMUHm3L9ZohBvrvFUxy9qqQ0IGxphte8u3BHi2FNduHA4xo41FYmteKQZkuZEzcga51d1UnHCjyLEEGEt3yXfmdsDy4HPg3wtCLZ4NgJo5sEWF519KrIhP7Ph0QPuo0k2BWUvi13RZy4Fiq30LFCUUfVq2DKGGteigiPxxju/T4gyH6sncKvnmVCyY75lCam6SPGjoCD06cy5ZB8wcppV8uYG6vJrmClW7ske4UbJOe+CiFugwHHO8Hnhj8jokfH0d23Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(346002)(366004)(136003)(39860400002)(451199015)(55016003)(2906002)(41300700001)(66946007)(66556008)(8936002)(52536014)(66446008)(66476007)(4326008)(64756008)(8676002)(5660300002)(7416002)(6506007)(54906003)(186003)(33656002)(71200400001)(316002)(110136005)(86362001)(38100700002)(76116006)(38070700005)(9686003)(478600001)(7696005)(53546011)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eXVhVk5YU2dZcnJsb3pQNGxPQVFzMS9HY09BN0hzVzdFRXQ0dERQem1TS1Vl?=
 =?utf-8?B?cm9HWDVtRmpHYlhGSWpBSHBrRmNwSVdQdzB2TnRTeEZCekpiVkdyVzdscXJ4?=
 =?utf-8?B?NkpRYmpuWmZPd1VwVFBIR0xNdTdPeFozNFVGOWE2WUdjRDQrQVR6elkxU2Ru?=
 =?utf-8?B?UzdNZmVTNlJ5azFkb2paRkN0VVB0b2tWR2dtbzFOV1RRb1BBN1dtRUFKREg3?=
 =?utf-8?B?dm1hcTQ0WllzdGFjYkJaaDBVcHcyR0pjTTBVVlVnTG51eUNQcVl3VjNCWUdI?=
 =?utf-8?B?SmZ3TkhaTkFaNWRGZU9zamJpSHFBSkRiV3RjeWMwaE9sS3V4aUVvNkMzS1Yr?=
 =?utf-8?B?NGxQeWtRWVh2SVJSRkRHcllIM2tUU1NFUlBLSEpMWTB6YjAxbEt3MmFVd2NF?=
 =?utf-8?B?dXdTcWczV1dJa1Nzb1NkeVVsdExkS0ViMW5rb1RwRjFzamdvdlo2WGVnQWpF?=
 =?utf-8?B?ZDRueUxpRlUvWWF4NmY0R1djWVpFZzdkUE9CdHRuU0hRTFFTUzlpTmlRcWFk?=
 =?utf-8?B?S2Z3VkJBNnByTHAzbFYxaW5ocWZ0UlNXZGFydzMybmh6L0Ria0duWm9iOCtH?=
 =?utf-8?B?bjE0Mk5ZdE1ZNGpkUCtMMjNRaGNvUlRPRDJOcys0ZWhCT3hMRlJ3M1dMWklt?=
 =?utf-8?B?NFRDUFFSbUxPZVVRcXQzZlowL2ZHM0lvbjZaQ3RGdE9kMFBZaFFvajdoaTNm?=
 =?utf-8?B?RGwrL0R2TzdCbnZQSDBVYWtycWo1WHJTbG5QVzc4b284NmFxOGtxZTZ0WWRk?=
 =?utf-8?B?V1N3Y1Fvc3BOeUYzS3VIZkJUTXpQRG1QZkkxZjZSS05YbExPekNpblU5cFJM?=
 =?utf-8?B?eTAvNUJHcUNGM0gwaDRmS0dxaEp5Wk9mSVpaZmNqMFlGakpyV3FtTjRNRmpY?=
 =?utf-8?B?UUpIQ1VEcFZMNkU3Y2RWZktlRm4vQmNET2Q0dDVuZlliSGwrTlVGYWVzQXRm?=
 =?utf-8?B?c1pQei9wWEpMRTZ1MFRKUEhhWWlQNVBHOU0wNFJMTWlGMllYQmY5R3E0bzFO?=
 =?utf-8?B?MWE1Q2ZrNTdmanNvWm5KbUpZVzlTQTBQSnFsNTlNOVlkYkEwckovaGNSeXA4?=
 =?utf-8?B?WExQOTFvQlNKZ0pCa3lGQmVuNHhrd2FKMkV1K0RpSW5GUzU5VzJ4ZXdXeWxT?=
 =?utf-8?B?SEJhQndnbXVWVVllV00zTExuWDRWdjBFY2cvcFBGR05sY1k2SE5Zd0lUeG1U?=
 =?utf-8?B?Z1RZcDlaUlYwclI5ZnJzK0IwQTRmU0NaM2F2bGIwcGNGelpIOVkzSllvOE5w?=
 =?utf-8?B?elVMcUlibzBLV0hvOWJBUXh1Yk11RXFEcVJWTFJ1bnE4U0hJZloyRkpkZldT?=
 =?utf-8?B?b28vYmpYeExxcksxZ3JINnExb3UxMGVTR09SMWY3T3NkQ0NLWHVGTkNVK3pq?=
 =?utf-8?B?KytYOFczZ3VWaHppYm8xZTZQcHBtRjhhMkNRa1ZUZEZwZms5LzQ1ZFFvLzkx?=
 =?utf-8?B?TlVLckVFS1hrNGY1WmZQRWh4K1FjSkkzbHA3d1p0TWUzN2VQTTBKKzF0N0RW?=
 =?utf-8?B?enVTSGU0YUV2bnIzUFEzOG9mbU13NUFtZC9XTGxia0dLWUQrWThZejFveWtq?=
 =?utf-8?B?eXRxTHdpV0VuR3JpdlVJclRaaVRhcmNxUmdJNWI4MWx2Q2pYclBoNXRaOXVn?=
 =?utf-8?B?T1kyR0IrcFk4Ynd1VXRQb2hxQ3VzNHFzRm02STJyNjB2akp3anlJMzN1WGFm?=
 =?utf-8?B?eE9oQ3VId0dwWlpBMkd6MHNLSW00cXYrSHBtNHBqeXp1OHFFTUJ6em5yaVRM?=
 =?utf-8?B?WU0vbmlFZEdOQVhWM0FDWlpTTVZQNHRNUGFwVDZWWVBuRU8rSDRkVG9IMzQw?=
 =?utf-8?B?VnVic3J4SVRkbFVRV3hIbEJudGcyQkNMWTZQcnJ0ZTFxWllaL2NxaC9veld6?=
 =?utf-8?B?SWZhaXgxajJEejFXeTdjaHN6aFFEdGsrT2pQSkRPWFV2Sk5MYng4aTM2Tzlt?=
 =?utf-8?B?cnRkcDRDSmsrQ2ZLNjI3Mm0vVUNWbE5KdDkrQnMxT1J5YnMvMktDczNHSFhO?=
 =?utf-8?B?azhMSUozZDBZZEdBSFhJSFA4Yko3aGVBOFRmcE9YQnpIWHdWVDBGQ3dvTDJa?=
 =?utf-8?B?T2FVZG10RTFIUDRaYjVRNGE4cTBTRUh5T001NFd4N09NcTJIc1RLLytoV3hh?=
 =?utf-8?B?end3TWFIUlluUFBNSXNqY3N1VmZnam50Y2p5bFRGdXJxbTFBV1cyWnZuTjFW?=
 =?utf-8?B?eXpQQ05INlNYMG9yOWVVNG5MbWVLSmFtOGtxa2RGejZOeDJSWlVWeHZIRU1I?=
 =?utf-8?B?ckxHUkVzTUFUMS8rbTBqQ1I4dHpBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2dafb0ee-951a-494e-72e3-08dab26dbbca
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2022 07:35:59.7820
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4hHI6+8zVcc/Wb8mwzTP0mpe4QeS9pV1zjxoNMXYlbPW/1NPA4caK2Ex7Oele3Djumr7rTNu3X/D6SroRzSsLcOCMZ3K4LvHwW0PK4/91vOILly5jx5nwo/01PTnuaFe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB9463
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRmxvcmlhbiwNCg0KPiBGcm9tOiBGbG9yaWFuIEZhaW5lbGxpLCBTZW50OiBUaHVyc2RheSwg
T2N0b2JlciAyMCwgMjAyMiAxMToyMyBBTQ0KPiANCj4gT24gMTAvMTkvMjAyMiAxOjM1IEFNLCBZ
b3NoaWhpcm8gU2hpbW9kYSB3cm90ZToNCj4gPiBBZGQgUmVuZXNhcyBFdGhlcm5ldCBTd2l0Y2gg
ZHJpdmVyIGZvciBSLUNhciBTNC04IHRvIGJlIHVzZWQgYXMgYW4NCj4gPiBldGhlcm5ldCBjb250
cm9sbGVyLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogWW9zaGloaXJvIFNoaW1vZGEgPHlvc2hp
aGlyby5zaGltb2RhLnVoQHJlbmVzYXMuY29tPg0KPiANCj4gSG93IGNhbiB0aGlzIGJlIGEgc3dp
dGNoIGRyaXZlciB3aGVuIGl0IGRvZXMgbm90IGluY2x1ZGUgYW55IHN3aXRjaGRldg0KPiBoZWFk
ZXIgZmlsZXMgbm9yIGRvZXMgaXQgYXR0ZW1wdCB0byBiZSB1c2luZyB0aGUgRFNBIGZyYW1ld29y
az8gWW91IGFyZQ0KPiBjZXJ0YWlubHkgZHVwbGljYXRpbmcgYSBsb3Qgb2YgdGhpbmdzIHRoYXQg
RFNBIHdvdWxkIGRvIGZvciB5b3UgbGlrZQ0KPiBtYW5hZ2luZyBQSFlzIGFuZCByZWdpc3Rlcmlu
ZyBwZXItcG9ydCBuZXdvcmsgZGV2aWNlcy4gV2h5Pw0KDQpUaGUgY3VycmVudCBkcml2ZXIgZG9l
c24ndCBzdXBwb3J0IGFueSBmb3J3YXJkaW5nIG9mZmxvYWQuIEFuZCwgYXQgdGhlIGZpcnN0DQpz
dGVwIG9mIHN1cHBvcnRpbmcgdGhpcyBoYXJkd2FyZSwgSSdkIGxpa2UgdG8gdXNlIHRoZSBoYXJk
d2FyZSBhcyBhbiBldGhlcm5ldA0KY29udHJvbGxlciBmb3Igc2VuZGluZy9yZWNlaXZpbmcgZnJh
bWVzLiBTbywgSSBkaWRuJ3QgdXNlIHRoZSBzd2l0Y2hkZXYgYW5kDQp0aGUgRFNBIGZyYW1ld29y
a3MuDQoNCkJ5IHRoZSB3YXksIHRoZSBoYXJkd2FyZSBuYW1lIGlzICJFdGhlcm5ldCBTd2l0Y2gi
IHNvIHRoYXQgSSB3cm90ZQ0KdGhlIHN1YmplY3QgYXMgIkFkZCBFdGhlcm5ldCBTd2l0Y2ggZHJp
dmVyIi4gQnV0LCBJJ20gdGhpbmtpbmcgdGhhdA0KdGhpcyBzdWJqZWN0L2NvbW1pdCBkZXNjcmlw
dGlvbiBzaG91bGQgYmUgY2hhbmdlZCBsaWtlIGJlbG93Og0KLS0tDQpTdWJqZWN0OiBuZXQ6IGV0
aGVybmV0OiByZW5lc2FzOiBBZGQgc3VwcG9ydCBmb3IgIkV0aGVybmV0IFN3aXRjaCINCg0KQWRk
IGluaXRpYWwgc3VwcG9ydCBmb3IgUmVuZXNhcyBFdGhlcm5ldCBTd2l0Y2ggb2YgUi1DYXIgUzQt
OC4NClRoZSBoYXJkd2FyZSBoYXMgZmVhdHVyZXMgYWJvdXQgZm9yd2FyZGluZyBmb3IgYW4gZXRo
ZXJuZXQgc3dpdGNoDQpkZXZpY2UuIEJ1dCwgZm9yIG5vdywgaXQgYWN0cyBhcyBhbiBldGhlcm5l
dCBjb250cm9sbGVyIHNvIHRoYXQgYW55DQpmb3J3YXJkaW5nIG9mZmxvYWQgZmVhdHVyZXMgYXJl
IG5vdCBzdXBwb3J0ZWQuDQotLS0NCg0KQmVzdCByZWdhcmRzLA0KWW9zaGloaXJvIFNoaW1vZGEN
Cg0KPiAtLQ0KPiBGbG9yaWFuDQo=
