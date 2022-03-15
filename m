Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFA444D9404
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 06:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344954AbiCOFjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 01:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232739AbiCOFjY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 01:39:24 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2060.outbound.protection.outlook.com [40.107.96.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B65F313E31;
        Mon, 14 Mar 2022 22:38:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JKz0sqMERR9uc2HfQVtgbD20qezrzMavc+0I1Q164ib+RaEnn9g6FNtK9SQjQeiTfj3oOewKQShfIDq73UmY7DGZgrJrD5GvmyVSZKyFFkClW8q7jpCXaJcB5Nquxd8kCJ4eRbIGAIxMYTtALxIuMkkj+U9xN4XgIm0VsQwsYuU5Z4FYfEt3wdSt4t3NxWxzD+7vYnKTVKRmVnUYBnwnFHHECtCICOsKsYvx/Jb4wdvdnOzD9q5R1y4B01VJvuFACZm+703Adfr3UHwxQ9CEGRVRI55tLhAr5eYZQ0mHVMN7E7wNOcc+6q5C6hCAHSCSsPTitLYxv/oxxrcKcwUaGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lEy3iLpsHN8qfRyv4mpv8k11qMHeI/mJ/QIdDvzR5uo=;
 b=UssLLNMkOh98UNAUMJfC8CyXgpZgLDAlLPJEVYc0sucNx8ZYU11MXDgJnjtZ1pnzAIFFHuaIOGb7wOfwFlIPr7D4krDspOKNOMlpTw1m6LmJTIi4KavfsFi4c9O7c9j9URm+szOtCzBZpkUQQTg5vTFtrIxBDPKdHJZ2G/7taFQ2avw6aWrUZdfncd6n+VqQKfIKMEo5fYYSObaxbCaLAlDtF0UB1y7BjYnAJqd47FSYFP9ZosMIidIESRN5cyDqClktrr1c8d6wkny9mddIEQMyL6h9u/OZRJMhlDexBz4vWJJMiUQugKUHl3wfwht+WEIxNJZtunK52syuF8A7eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lEy3iLpsHN8qfRyv4mpv8k11qMHeI/mJ/QIdDvzR5uo=;
 b=lbVq7u1GXClbLBVYnlgujBxnHqdfUpM1F5m9Jbkn0B9vjaRPHmr9jPE9ZRPZyv8KFzCfaSaVi9SIbzx06OX8ITCV3ZYnoHIcmvCE2zRRCKHuJPnfxHaTZAlw5O4pOBg8GIIzoLU3MF+5oTW/gBkZBc8qXh6hu2eOBZO9UIyW3eE=
Received: from DM8PR02MB7926.namprd02.prod.outlook.com (2603:10b6:8:31::9) by
 BL0PR02MB4612.namprd02.prod.outlook.com (2603:10b6:208:41::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5061.22; Tue, 15 Mar 2022 05:38:09 +0000
Received: from DM8PR02MB7926.namprd02.prod.outlook.com
 ([fe80::608e:6dbb:882a:a5d6]) by DM8PR02MB7926.namprd02.prod.outlook.com
 ([fe80::608e:6dbb:882a:a5d6%6]) with mapi id 15.20.5061.028; Tue, 15 Mar 2022
 05:38:09 +0000
From:   Amit Kumar Kumar Mahapatra <akumarma@xilinx.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Appana Durga Kedareswara Rao <appanad@xilinx.com>
CC:     "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Simek <michals@xilinx.com>, git <git@xilinx.com>
Subject: RE: [PATCH v3] dt-bindings: can: xilinx_can: Convert Xilinx CAN
 binding to YAML
Thread-Topic: [PATCH v3] dt-bindings: can: xilinx_can: Convert Xilinx CAN
 binding to YAML
Thread-Index: AQHYNJUHSoB2IsjcbkeLnBkDyERKD6y41f4AgAXXhvA=
Date:   Tue, 15 Mar 2022 05:38:09 +0000
Message-ID: <DM8PR02MB7926512883E8C0AF954AE2F6BA109@DM8PR02MB7926.namprd02.prod.outlook.com>
References: <20220310153909.30933-1-amit.kumar-mahapatra@xilinx.com>
 <78c7b777-1527-759f-41f7-bd8422cb4eb0@canonical.com>
In-Reply-To: <78c7b777-1527-759f-41f7-bd8422cb4eb0@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=xilinx.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 120d709c-20ea-4ef3-d3b8-08da0645fd06
x-ms-traffictypediagnostic: BL0PR02MB4612:EE_
x-ld-processed: 657af505-d5df-48d0-8300-c31994686c5c,ExtAddr
x-microsoft-antispam-prvs: <BL0PR02MB46129FAC0DBAA534DC428345BA109@BL0PR02MB4612.namprd02.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RArRMKctP+H/OaH4E5PgBmf9qFPKsXhYGklzMfeODqcDWvfzhTk21geiyMhRFLaGO0T1/AB6t0hPgCeqcV/OP7DQ8NtS7J7DT+ha1aF0y98m0QBXEPPeuulRvP3ej8CILtnsI7ZmKcNUQDQJ2BSM0FRicqqSijwipzA2WPU/Pg2Zm/T8BaRdFWiBDcwzjyw2Nh4CypnD7CGRKGFe9YL1rCOqgSw3n+Lgur48WnKgM6yorWbzlDmunpZhAHwDilnR9/9vufFvot+g3t4EWUhZ75OWGnirS8R9RJYMTSv3rltt5yzuuwbp891y9cInTWgEiLc/M7LOdyU9xXPh6QoomxDqvO63lwCsFB7k+M2zHvlpVzAgB2XVOU8YNTBPcbRDSwahSf2rOpFDtuRPzNdxHi6HVSuGHmckWl60wpl4yEb/i6F35oPA7fw1gwid6WgaK9tCyl4gLdUtL7iWzPpQXqGgE2VmI/MoEXVDTvyw+AR1FTDeCDUuereysf+mV10ra5d0HY0cKZgP+H+QL24ub2NGCWhkYGa/QInCjN2avsc5dWenCyCnmRgTb0VJmtAc4OwIKhl7ILwvaiFUP/XrWAtQSLLfcq2qLD/6oTiDnehZ3deVL46+EyBEs8vr5pwGG1UM+jTSn+m8lIFSAd2ujEVkzcgnVRWHNCNAF1SlRnnH+ELm4sT+0mpwE16Fs1+sxOwDwt/+DTUw3lfev0N9aZi2ky61j9mb+rc1Mk+LVOlQRVTvovpdvAQCz1rhCi4B1zn+q0JDRzFEDBFRS9xJCY+occ7RR6hMKczGB/7mGAWDFVw8uBS9DFm3kfc2xa0eN1B8lu15kSGBTlMq24UUDA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR02MB7926.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(8936002)(71200400001)(66556008)(64756008)(66946007)(52536014)(508600001)(66446008)(53546011)(7696005)(6506007)(33656002)(26005)(5660300002)(66476007)(76116006)(107886003)(186003)(7416002)(6636002)(122000001)(9686003)(966005)(110136005)(54906003)(2906002)(83380400001)(316002)(8676002)(4326008)(38070700005)(55016003)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TXZsSHJIRm9qY0NZaHhWYlp1d0x6VTRzK3kwUWFqcDNFNFB3YTN2d1pwTG40?=
 =?utf-8?B?d0w0ZGVFVGtYL0o2dWxmbDVLMDVqU043VXZaaGs2a2grNU5YbmtEN3QwZklu?=
 =?utf-8?B?elZTRkVhV0tUZ3dLc3hvWlhpTnRoVktzdkt1SFdubTRPZUQxUlVudUVibGxr?=
 =?utf-8?B?UGI1SThtL1h6RjM2MklkazM5MEhncmdQN1JmK05KekR6VW5vQ0czVDd0R3Q0?=
 =?utf-8?B?bExsVG1sVm14cnN6ejNDb0dVYkloV1dYdE5BYnJSckRrdWZPd2hhb3V6TS9I?=
 =?utf-8?B?Vlg4M0xQS0RTNDhWQXZkbHFNaXBwNXh3RGhzUzRKcmxob3pmRUNVWDJnaGJj?=
 =?utf-8?B?TlU2ZXpraGZyUTduWjVLbzJMcUVHU2ZWVnQ4RnVDY28vY1NNT2hmS1BwZlJp?=
 =?utf-8?B?QjBEaWxPVmRuazZBWnQ5N1E1dEM2STE2OW11YmdTVzgxckEya2Q3TkFHWWU5?=
 =?utf-8?B?azVRdFcvWUp5S1V3QUdZckxBQ0hscVRqMkJXc3pCODhwczRabFlRNFF0QkJX?=
 =?utf-8?B?c2VJOVhYSTc1SkFkZ25kUmpYcGRNcjB0d25ERDZGNkNBanFKdVVqRVZ0TnlZ?=
 =?utf-8?B?TFoxeUlvb0tMV2FpZTFyK2JMcmZEM1VGYitMNEpVL1ZqN0tQUnczSDdmWko1?=
 =?utf-8?B?WXN2UkZlOUc3Q2MxNjd6S1I3dDhZZW5OTGI1KzhmaHB0UUlURUE2cDNlWXJG?=
 =?utf-8?B?Q3FMZlFja3pLL2JqUy9XV1RCbHBKRGJKNFlXV29HckZGQmhjMks3YlBERmly?=
 =?utf-8?B?aXNhckFKR1JaT09UNFoveVlJdHVFb2hsWEswUFlrMFRSejdLOEJiOFRUNHp5?=
 =?utf-8?B?cFVZYjZzd3V3Y0tROGI1aFNkaVRxU1p5bEtMeEFsUWkxbWtHZnByOVpsbVhs?=
 =?utf-8?B?TzQ2aGVzd3lrb1A3ZVVsSmZUS3h6eXF2OW5KSjMwR2t4VFlTS2hRdmhLYk11?=
 =?utf-8?B?bjhnT1FmQXVQVDZoQXUwaGdHSjI4dzltQXdjTGpYWVVhMUZwS2kzc09CY1lK?=
 =?utf-8?B?Sm9SN2podS80YWIwUEF4QURDcHVOb2M4b1gxcm02WEwwOEt3WmZvUEIrakQ3?=
 =?utf-8?B?ZDZUN2dKMTlka2dTMTE0NlNydWVNclhrNHYzMzVJZ3B2NmZzb282WGpIWnMy?=
 =?utf-8?B?WWNnZXphNVdTaFBKSC8zMnQyNFRYTVd6K1labjBoRG42NEZKSUgva0lKV0to?=
 =?utf-8?B?cHNwWHVMU3QrTnNWRFB3V2h6MEwxeWJsSmdPNzFmSUcrNlhpNDd5RkpFRGh1?=
 =?utf-8?B?UHJyMkJXQU1BL1kyMGFXR0dHZnoyd2ZYZWVLV1EvN0NqdEUrQUNZbzVobnl6?=
 =?utf-8?B?SVhKSHN3TmFMRTdYekFJekNwUHdSZTFpeFdzcHZlS2hQc2w3RU1vaDVISTF2?=
 =?utf-8?B?ZTYzT3Z5SGk2S0p1RnVuRGpxUVZ6T25aU2phc05lMHQxNVJSdHJpMVh2aWZu?=
 =?utf-8?B?ZUkzdjlOVS9vSGQzeXVicWdzYmxqbURuaEUrUDZBZ1djbWZuWVRYVkhFOGlw?=
 =?utf-8?B?Rk9Cb2hJWVppVis2WDd2U0J1MmxBSjV2SkxZaVRveTF5ZFc0WTJaV3dRQndx?=
 =?utf-8?B?b2xtOC8yeldSdmdmaWpFMk9wV0tkdWZCeW9zeUZQbnpWbXpKTnpmZ2JMSnI4?=
 =?utf-8?B?K1RxMFZZcFBIazFJLzRlMFo0NEdPTFpweitxTnFVM09PN2dHdGNXZzhOWlFz?=
 =?utf-8?B?OWZUMU1lNUtsZE1zVWZGNjVmU0FKSmtLRFZCdmQwY2NxU3Q1MmU5ZmtJWjNK?=
 =?utf-8?B?bDVLbnRMWW04bzFRY2NHU0VFOEJTK0h4ZE5taEdvajROc3BLQ1p3czE4Nm1N?=
 =?utf-8?B?dE4wV01ZdUhrT0ZOWlRHK2c5aXdqWU8xTGpPN1M0SnJQMml3c2NPZENXNlZ5?=
 =?utf-8?B?YWVuZE5YVUo4Tlkwa1lEYW02UU8yc00rQ2NhTk13dTY5YVNyZFZ4MzdBMVlK?=
 =?utf-8?Q?J1gq5FjqInUvqUw5mYD8dfq8SweODZMR?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR02MB7926.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 120d709c-20ea-4ef3-d3b8-08da0645fd06
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2022 05:38:09.3158
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uSZHOpmYHzIsxDCohmr81W6ZxzvoHafLIM2Y+eSVzMQZcRfFLq0Tg6F7fiu4Kqmhivzm3zOBf6Pa6v9z9GJRiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR02MB4612
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8gS3J6eXN6dG9mLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206
IEtyenlzenRvZiBLb3psb3dza2kgPGtyenlzenRvZi5rb3psb3dza2lAY2Fub25pY2FsLmNvbT4N
Cj4gU2VudDogVGh1cnNkYXksIE1hcmNoIDEwLCAyMDIyIDEwOjI1IFBNDQo+IFRvOiBBbWl0IEt1
bWFyIEt1bWFyIE1haGFwYXRyYSA8YWt1bWFybWFAeGlsaW54LmNvbT47DQo+IHdnQGdyYW5kZWdn
ZXIuY29tOyBta2xAcGVuZ3V0cm9uaXguZGU7IGt1YmFAa2VybmVsLm9yZzsNCj4gcm9iaCtkdEBr
ZXJuZWwub3JnOyBBcHBhbmEgRHVyZ2EgS2VkYXJlc3dhcmEgUmFvDQo+IDxhcHBhbmFkQHhpbGlu
eC5jb20+DQo+IENjOiBsaW51eC1jYW5Admdlci5rZXJuZWwub3JnOyBuZXRkZXZAdmdlci5rZXJu
ZWwub3JnOw0KPiBkZXZpY2V0cmVlQHZnZXIua2VybmVsLm9yZzsgbGludXgtYXJtLWtlcm5lbEBs
aXN0cy5pbmZyYWRlYWQub3JnOyBsaW51eC0NCj4ga2VybmVsQHZnZXIua2VybmVsLm9yZzsgTWlj
aGFsIFNpbWVrIDxtaWNoYWxzQHhpbGlueC5jb20+OyBnaXQNCj4gPGdpdEB4aWxpbnguY29tPjsg
QW1pdCBLdW1hciBLdW1hciBNYWhhcGF0cmEgPGFrdW1hcm1hQHhpbGlueC5jb20+DQo+IFN1Ympl
Y3Q6IFJlOiBbUEFUQ0ggdjNdIGR0LWJpbmRpbmdzOiBjYW46IHhpbGlueF9jYW46IENvbnZlcnQg
WGlsaW54IENBTg0KPiBiaW5kaW5nIHRvIFlBTUwNCj4gDQo+IE9uIDEwLzAzLzIwMjIgMTY6Mzks
IEFtaXQgS3VtYXIgTWFoYXBhdHJhIHdyb3RlOg0KPiA+IENvbnZlcnQgWGlsaW54IENBTiBiaW5k
aW5nIGRvY3VtZW50YXRpb24gdG8gWUFNTC4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEFtaXQg
S3VtYXIgTWFoYXBhdHJhIDxhbWl0Lmt1bWFyLQ0KPiBtYWhhcGF0cmFAeGlsaW54LmNvbT4NCj4g
PiAtLS0NCj4gPiBCUkFOQ0g6IHlhbWwNCj4gPg0KPiA+IENoYW5nZXMgaW4gdjI6DQo+ID4gIC0g
QWRkZWQgcmVmZXJlbmNlIHRvIGNhbi1jb250cm9sbGVyLnlhbWwNCj4gPiAgLSBBZGRlZCBleGFt
cGxlIG5vZGUgZm9yIGNhbmZkLTIuMA0KPiA+DQo+ID4gQ2hhbmdlcyBpbiB2MzoNCj4gPiAgLSBD
aGFuZ2VkIHlhbWwgZmlsZSBuYW1lIGZyb20geGlsaW54X2Nhbi55YW1sIHRvIHhpbGlueCxjYW4u
eWFtbA0KPiA+ICAtIEFkZGVkICJwb3dlci1kb21haW5zIiB0byBmaXggZHRzX2NoZWNrIHdhcm5p
bmdzDQo+ID4gIC0gR3JvdXBlZCAiY2xvY2stbmFtZXMiIGFuZCAiY2xvY2tzIiB0b2dldGhlcg0K
PiA+ICAtIEFkZGVkIHR5cGUgJHJlZiBmb3IgYWxsIG5vbi1zdGFuZGFyZCBmaWVsZHMNCj4gPiAg
LSBEZWZpbmVkIGNvbXBhdGlibGUgc3RyaW5ncyBhcyBlbnVtDQo+ID4gIC0gVXNlZCBkZWZpbmVz
LGluc3RlYWQgb2YgaGFyZC1jb2RlZCB2YWx1ZXMsIGZvciBHSUMgaW50ZXJydXB0cw0KPiA+ICAt
IERyb3BlZCB1bnVzZWQgbGFiZWxzIGluIGV4YW1wbGVzDQo+ID4gIC0gRHJvcGVkIGRlc2NyaXB0
aW9uIGZvciBzdGFuZGFyZCBmZWlsZHMNCj4gPiAtLS0NCj4gPiAgLi4uL2JpbmRpbmdzL25ldC9j
YW4veGlsaW54LGNhbi55YW1sICAgICAgICAgIHwgMTYxICsrKysrKysrKysrKysrKysrKw0KPiA+
ICAuLi4vYmluZGluZ3MvbmV0L2Nhbi94aWxpbnhfY2FuLnR4dCAgICAgICAgICAgfCAgNjEgLS0t
LS0tLQ0KPiA+ICAyIGZpbGVzIGNoYW5nZWQsIDE2MSBpbnNlcnRpb25zKCspLCA2MSBkZWxldGlv
bnMoLSkgIGNyZWF0ZSBtb2RlDQo+ID4gMTAwNjQ0IERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9i
aW5kaW5ncy9uZXQvY2FuL3hpbGlueCxjYW4ueWFtbA0KPiA+ICBkZWxldGUgbW9kZSAxMDA2NDQN
Cj4gPiBEb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2Nhbi94aWxpbnhfY2Fu
LnR4dA0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5k
aW5ncy9uZXQvY2FuL3hpbGlueCxjYW4ueWFtbA0KPiA+IGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0
cmVlL2JpbmRpbmdzL25ldC9jYW4veGlsaW54LGNhbi55YW1sDQo+ID4gbmV3IGZpbGUgbW9kZSAx
MDA2NDQNCj4gPiBpbmRleCAwMDAwMDAwMDAwMDAuLjc4Mzk4ODI2Njc3ZA0KPiA+IC0tLSAvZGV2
L251bGwNCj4gPiArKysgYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2Nh
bi94aWxpbngsY2FuLnlhbWwNCj4gPiBAQCAtMCwwICsxLDE2MSBAQA0KPiA+ICsjIFNQRFgtTGlj
ZW5zZS1JZGVudGlmaWVyOiAoR1BMLTIuMC1vbmx5IE9SIEJTRC0yLUNsYXVzZSkgJVlBTUwgMS4y
DQo+ID4gKy0tLQ0KPiA+ICskaWQ6IGh0dHA6Ly9kZXZpY2V0cmVlLm9yZy9zY2hlbWFzL25ldC9j
YW4veGlsaW54LGNhbi55YW1sIw0KPiA+ICskc2NoZW1hOiBodHRwOi8vZGV2aWNldHJlZS5vcmcv
bWV0YS1zY2hlbWFzL2NvcmUueWFtbCMNCj4gPiArDQo+ID4gK3RpdGxlOg0KPiA+ICsgIFhpbGlu
eCBBeGkgQ0FOL1p5bnEgQ0FOUFMgY29udHJvbGxlcg0KPiA+ICsNCj4gPiArbWFpbnRhaW5lcnM6
DQo+ID4gKyAgLSBBcHBhbmEgRHVyZ2EgS2VkYXJlc3dhcmEgcmFvIDxhcHBhbmEuZHVyZ2EucmFv
QHhpbGlueC5jb20+DQo+ID4gKw0KPiA+ICtwcm9wZXJ0aWVzOg0KPiA+ICsgIGNvbXBhdGlibGU6
DQo+ID4gKyAgICBlbnVtOg0KPiA+ICsgICAgICAtIHhsbngsenlucS1jYW4tMS4wDQo+ID4gKyAg
ICAgIC0geGxueCxheGktY2FuLTEuMDAuYQ0KPiA+ICsgICAgICAtIHhsbngsY2FuZmQtMS4wDQo+
ID4gKyAgICAgIC0geGxueCxjYW5mZC0yLjANCj4gPiArDQo+ID4gKyAgcmVnOg0KPiA+ICsgICAg
bWF4SXRlbXM6IDENCj4gPiArDQo+ID4gKyAgaW50ZXJydXB0czoNCj4gPiArICAgIG1heEl0ZW1z
OiAxDQo+ID4gKw0KPiA+ICsgIGNsb2NrczoNCj4gPiArICAgIG1pbkl0ZW1zOiAxDQo+ID4gKyAg
ICBtYXhJdGVtczogMg0KPiA+ICsNCj4gPiArICBjbG9jay1uYW1lczoNCj4gPiArICAgIG1heEl0
ZW1zOiAyDQo+ID4gKw0KPiA+ICsgIHBvd2VyLWRvbWFpbnM6DQo+ID4gKyAgICBtYXhJdGVtczog
MQ0KPiA+ICsNCj4gPiArICB0eC1maWZvLWRlcHRoOg0KPiA+ICsgICAgJHJlZjogIi9zY2hlbWFz
L3R5cGVzLnlhbWwjL2RlZmluaXRpb25zL3VpbnQzMiINCj4gPiArICAgIGRlc2NyaXB0aW9uOiBD
QU4gVHggZmlmbyBkZXB0aCAoWnlucSwgQXhpIENBTikuDQo+ID4gKw0KPiA+ICsgIHJ4LWZpZm8t
ZGVwdGg6DQo+ID4gKyAgICAkcmVmOiAiL3NjaGVtYXMvdHlwZXMueWFtbCMvZGVmaW5pdGlvbnMv
dWludDMyIg0KPiA+ICsgICAgZGVzY3JpcHRpb246IENBTiBSeCBmaWZvIGRlcHRoIChaeW5xLCBB
eGkgQ0FOLCBDQU4gRkQgaW4NCj4gPiArIHNlcXVlbnRpYWwgUnggbW9kZSkNCj4gPiArDQo+ID4g
KyAgdHgtbWFpbGJveC1jb3VudDoNCj4gPiArICAgICRyZWY6ICIvc2NoZW1hcy90eXBlcy55YW1s
Iy9kZWZpbml0aW9ucy91aW50MzIiDQo+ID4gKyAgICBkZXNjcmlwdGlvbjogQ0FOIFR4IG1haWxi
b3ggYnVmZmVyIGNvdW50IChDQU4gRkQpDQo+IA0KPiBJIGFza2VkIGFib3V0IHZlbmRvciBwcmVm
aXggYW5kIEkgdGhpbmsgSSBkaWQgbm90IGdldCBhbiBhbnN3ZXIgZnJvbSB5b3UNCj4gYWJvdXQg
c2tpcHBpbmcgaXQuIERvIHlvdSB0aGluayBpdCBpcyBub3QgbmVlZGVkPw0KDQpTb3JyeSwgSSB3
ZW50IHRocm91Z2ggYWxsIHlvdXIgcHJldmlvdXMgY29tbWVudHMgYnV0IEkgY291bGRuJ3QgZmlu
ZCB0aGUgDQpjb21tZW50IHdoZXJlIHlvdSBoYWQgYXNrZWQgYWJvdXQgdmVuZG9yIHByZWZpeC4g
Q291bGQgeW91IHBsZWFzZSBwb2ludA0KbWUgdG8gaXQgPw0KV2UgY2FuIGFkZCB2ZW5kb3IgcHJl
Zml4IHRvIG5vbi1zdGFuZGFyZCBmaWVsZHMsIGJ1dCB3ZSBuZWVkIHRvIHVwZGF0ZSANCmRyaXZl
ciB0byBiZSBhbGlnbmVkIHdpdGggaXQgYW5kIGRlcHJlY2F0ZSBvcmlnaW5hbCBwcm9wZXJ0eSB3
aGljaCBoYXMgYmVlbiANCmFkZGVkIGluIDIwMTggYW5kIGFja2VkIGJ5IFJvYiBhbmQgTWFyYyBh
dCB0aGF0IHRpbWUuDQpodHRwczovL2dpdGh1Yi5jb20vdG9ydmFsZHMvbGludXgvY29tbWl0Lzdj
YjBmMTdmNTI1Mjg3NGJhMGVjYmRhOTY0ZTdlMDE1ODdiZjgyOGUNCg0KUmVnYXJkcywNCkFtaXQN
Cj4gDQo+ID4gKw0KPiA+ICtyZXF1aXJlZDoNCj4gPiArICAtIGNvbXBhdGlibGUNCj4gPiArICAt
IHJlZw0KPiA+ICsgIC0gaW50ZXJydXB0cw0KPiA+ICsgIC0gY2xvY2tzDQo+ID4gKyAgLSBjbG9j
ay1uYW1lcw0KPiA+ICsNCj4gPiArYWRkaXRpb25hbFByb3BlcnRpZXM6IGZhbHNlDQo+IA0KPiBU
aGlzIHNob3VsZCBiZSByYXRoZXIgdW5ldmFsdWF0ZWRQcm9wZXJ0aWVzOmZhbHNlLCBzbyB5b3Ug
Y291bGQgdXNlIGNhbi0NCj4gY29udHJvbGxlciBwcm9wZXJ0aWVzLg0KPiANCj4gPiArDQo+ID4g
K2FsbE9mOg0KPiA+ICsgIC0gJHJlZjogY2FuLWNvbnRyb2xsZXIueWFtbCMNCj4gPiArICAtIGlm
Og0KPiA+ICsgICAgICBwcm9wZXJ0aWVzOg0KPiA+ICsgICAgICAgIGNvbXBhdGlibGU6DQo+ID4g
KyAgICAgICAgICBjb250YWluczoNCj4gPiArICAgICAgICAgICAgZW51bToNCj4gPiArICAgICAg
ICAgICAgICAtIHhsbngsenlucS1jYW4tMS4wDQo+ID4gKw0KPiA+ICsgICAgdGhlbjoNCj4gPiAr
ICAgICAgcHJvcGVydGllczoNCj4gPiArICAgICAgICBjbG9jay1uYW1lczoNCj4gPiArICAgICAg
ICAgIGl0ZW1zOg0KPiA+ICsgICAgICAgICAgICAtIGNvbnN0OiBjYW5fY2xrDQo+ID4gKyAgICAg
ICAgICAgIC0gY29uc3Q6IHBjbGsNCj4gPiArICAgICAgcmVxdWlyZWQ6DQo+ID4gKyAgICAgICAg
LSB0eC1maWZvLWRlcHRoDQo+ID4gKyAgICAgICAgLSByeC1maWZvLWRlcHRoDQo+ID4gKw0KPiA+
ICsgIC0gaWY6DQo+ID4gKyAgICAgIHByb3BlcnRpZXM6DQo+ID4gKyAgICAgICAgY29tcGF0aWJs
ZToNCj4gPiArICAgICAgICAgIGNvbnRhaW5zOg0KPiA+ICsgICAgICAgICAgICBlbnVtOg0KPiA+
ICsgICAgICAgICAgICAgIC0geGxueCxheGktY2FuLTEuMDAuYQ0KPiA+ICsNCj4gPiArICAgIHRo
ZW46DQo+ID4gKyAgICAgIHByb3BlcnRpZXM6DQo+ID4gKyAgICAgICAgY2xvY2stbmFtZXM6DQo+
ID4gKyAgICAgICAgICBpdGVtczoNCj4gPiArICAgICAgICAgICAgLSBjb25zdDogY2FuX2Nsaw0K
PiA+ICsgICAgICAgICAgICAtIGNvbnN0OiBzX2F4aV9hY2xrDQo+ID4gKyAgICAgIHJlcXVpcmVk
Og0KPiA+ICsgICAgICAgIC0gdHgtZmlmby1kZXB0aA0KPiA+ICsgICAgICAgIC0gcngtZmlmby1k
ZXB0aA0KPiA+ICsNCj4gPiArICAtIGlmOg0KPiA+ICsgICAgICBwcm9wZXJ0aWVzOg0KPiA+ICsg
ICAgICAgIGNvbXBhdGlibGU6DQo+ID4gKyAgICAgICAgICBjb250YWluczoNCj4gPiArICAgICAg
ICAgICAgZW51bToNCj4gPiArICAgICAgICAgICAgICAtIHhsbngsY2FuZmQtMS4wDQo+ID4gKyAg
ICAgICAgICAgICAgLSB4bG54LGNhbmZkLTIuMA0KPiA+ICsNCj4gPiArICAgIHRoZW46DQo+ID4g
KyAgICAgIHByb3BlcnRpZXM6DQo+ID4gKyAgICAgICAgY2xvY2stbmFtZXM6DQo+ID4gKyAgICAg
ICAgICBpdGVtczoNCj4gPiArICAgICAgICAgICAgLSBjb25zdDogY2FuX2Nsaw0KPiA+ICsgICAg
ICAgICAgICAtIGNvbnN0OiBzX2F4aV9hY2xrDQo+ID4gKyAgICAgIHJlcXVpcmVkOg0KPiA+ICsg
ICAgICAgIC0gdHgtbWFpbGJveC1jb3VudA0KPiA+ICsgICAgICAgIC0gcngtZmlmby1kZXB0aA0K
PiA+ICsNCj4gPiArZXhhbXBsZXM6DQo+ID4gKyAgLSB8DQo+ID4gKyAgICAjaW5jbHVkZSA8ZHQt
YmluZGluZ3MvaW50ZXJydXB0LWNvbnRyb2xsZXIvYXJtLWdpYy5oPg0KPiA+ICsNCj4gPiArICAg
IGNhbkBlMDAwODAwMCB7DQo+ID4gKyAgICAgICAgY29tcGF0aWJsZSA9ICJ4bG54LHp5bnEtY2Fu
LTEuMCI7DQo+ID4gKyAgICAgICAgY2xvY2tzID0gPCZjbGtjIDE5PiwgPCZjbGtjIDM2PjsNCj4g
PiArICAgICAgICBjbG9jay1uYW1lcyA9ICJjYW5fY2xrIiwgInBjbGsiOw0KPiA+ICsgICAgICAg
IHJlZyA9IDwweGUwMDA4MDAwIDB4MTAwMD47DQo+IA0KPiBQdXQgcmVnIGp1c3QgYWZ0ZXIgY29t
cGF0aWJsZSBpbiBhbGwgRFRTIGV4YW1wbGVzLg0KPiANCj4gPiArICAgICAgICBpbnRlcnJ1cHRz
ID0gPEdJQ19TUEkgMjggSVJRX1RZUEVfTEVWRUxfSElHSD47DQo+ID4gKyAgICAgICAgaW50ZXJy
dXB0LXBhcmVudCA9IDwmaW50Yz47DQo+ID4gKyAgICAgICAgdHgtZmlmby1kZXB0aCA9IDwweDQw
PjsNCj4gPiArICAgICAgICByeC1maWZvLWRlcHRoID0gPDB4NDA+Ow0KPiA+ICsgICAgfTsNCj4g
PiArDQo+ID4gKyAgLSB8DQo+ID4gKyAgICBjYW5ANDAwMDAwMDAgew0KPiA+ICsgICAgICAgIGNv
bXBhdGlibGUgPSAieGxueCxheGktY2FuLTEuMDAuYSI7DQo+ID4gKyAgICAgICAgY2xvY2tzID0g
PCZjbGtjIDA+LCA8JmNsa2MgMT47DQo+ID4gKyAgICAgICAgY2xvY2stbmFtZXMgPSAiY2FuX2Ns
ayIsInNfYXhpX2FjbGsiIDsNCj4gDQo+IE1pc3Npbmcgc3BhY2UgYWZ0ZXIgJywnLg0KPiANCj4g
PiArICAgICAgICByZWcgPSA8MHg0MDAwMDAwMCAweDEwMDAwPjsNCj4gPiArICAgICAgICBpbnRl
cnJ1cHQtcGFyZW50ID0gPCZpbnRjPjsNCj4gPiArICAgICAgICBpbnRlcnJ1cHRzID0gPEdJQ19T
UEkgNTkgSVJRX1RZUEVfRURHRV9SSVNJTkc+Ow0KPiA+ICsgICAgICAgIHR4LWZpZm8tZGVwdGgg
PSA8MHg0MD47DQo+ID4gKyAgICAgICAgcngtZmlmby1kZXB0aCA9IDwweDQwPjsNCj4gPiArICAg
IH07DQo+IA0KPiBCZXN0IHJlZ2FyZHMsDQo+IEtyenlzenRvZg0K
