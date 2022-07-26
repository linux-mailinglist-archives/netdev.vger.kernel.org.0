Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5211F58109B
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 11:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232300AbiGZJ73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 05:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbiGZJ70 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 05:59:26 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07olkn2105.outbound.protection.outlook.com [40.92.15.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FE042F03B;
        Tue, 26 Jul 2022 02:59:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EW7PU43l/Ea3htRyUtBjaLhEdR7tw4c2KqitEuGL2sj2L3d3a39WjawObZ3DUXQQvaFeRAltiasA2BHkEf/NLNZ5qBEQUcLD6TVpxb16Q+bBVPQ8OEhmIzMGp5Dn/2bo7mnlz4e0QH8Mfr6OrSv/2DDp51AiWl91xQmBGcVwaZfuNA1tq/VBwHrMc0ldWV2EWu6JCN5wdTd61uOUwHuIeBI4GCFEg+aqzEbOaUgfn8a8ROSZDS85AMDTdyLk2qbfMk6+MzuwJBqMomB4lWZluHIv++kneXHxoaqtoWOtNwHX5ts9RkDeen0fWarJ7SPSqslGfSpEFr2UazCmvG4tig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ShlT19q2N07oTs6AckZDhc7JJpLVxdctyDbRaQ3H50A=;
 b=DzEMN+98T8VXGoMeYFwY4QtNKsDj9JmDGQne4Ti6dD5p6EbZyPQa1AiT1yIeqQmFxHId6UOzNoKoCdIKqX5NffL/g9nhZWguIUf0g7U6WOn1BnnIaJJV1ieua84peFBalwfKIU74pjdbvlz6auiBtfDmgRiG8DQVoMLy6TPkFmmVpFhxoEk+LIqme5IpEV2BTDnRBlraVx5yha9t755faXlhQf6sWmbNztlFrb4mGF7lgqA4udBRyqCxRAN+UQJywcwnwF59scMhMldb+J+CEjk/Fg4nV+LSGuH8I/F/ny+9Qvjqo6DfRRjQHyyWgngzFbU07sSJHAirUOkCiszEgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ShlT19q2N07oTs6AckZDhc7JJpLVxdctyDbRaQ3H50A=;
 b=MRy3ofc1vhinTF8YfvfHNNj+SpbATChUy2aEC2R99Pk4wNPFgJm7FFDh0CN9saZxp/Q9++Z71ODoWQ7x1BQGmcZjRoP0rtzxOvg5hfSt1qs5b5eCLeC5Ypr3GI2EWFgRWReItO+aw6C7IQvdaJG9Z7qDs7dCgXd/ZSEcokBQaBb8kuS+VsqKbMYpDKWxREjsSBdJtml95fNg9/QoDtnTUpROBaEV+cfHRAz+kNud984Yt+5g9ysfnPghYkpXTYZ+ndDZFEhrzaHRLVU4nl2hXQOcV4HvhVEWa03sxy6nsWvjZXJfhNhxJXfXpG1u/pu5dk/hhj1akFkrj8ZRSKsCqw==
Received: from MN2PR17MB3375.namprd17.prod.outlook.com (2603:10b6:208:13c::25)
 by BY3PR17MB5681.namprd17.prod.outlook.com (2603:10b6:a03:3cc::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.25; Tue, 26 Jul
 2022 09:59:21 +0000
Received: from MN2PR17MB3375.namprd17.prod.outlook.com
 ([fe80::3409:88f8:6069:ccba]) by MN2PR17MB3375.namprd17.prod.outlook.com
 ([fe80::3409:88f8:6069:ccba%3]) with mapi id 15.20.5458.025; Tue, 26 Jul 2022
 09:59:20 +0000
From:   Vanessa Page <Vebpe@outlook.com>
To:     Philipp Zabel <p.zabel@pengutronix.de>
CC:     William Zhang <william.zhang@broadcom.com>,
        Linux ARM List <linux-arm-kernel@lists.infradead.org>,
        "joel.peshkin@broadcom.com" <joel.peshkin@broadcom.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        Broadcom Kernel List <bcm-kernel-feedback-list@broadcom.com>,
        "dan.beygelman@broadcom.com" <dan.beygelman@broadcom.com>,
        "anand.gore@broadcom.com" <anand.gore@broadcom.com>,
        "kursad.oney@broadcom.com" <kursad.oney@broadcom.com>,
        "rafal@milecki.pl" <rafal@milecki.pl>,
        "krzysztof.kozlowski@linaro.org" <krzysztof.kozlowski@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        "open list:I2C SUBSYSTEM HOST DRIVERS" <linux-i2c@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:MEMORY TECHNOLOGY DEVICES (MTD)" 
        <linux-mtd@lists.infradead.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        "open list:PCI NATIVE HOST BRIDGE AND ENDPOINT DRIVERS" 
        <linux-pci@vger.kernel.org>,
        "open list:GENERIC PHY FRAMEWORK" <linux-phy@lists.infradead.org>,
        "open list:PIN CONTROL SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        "open list:BROADCOM BMIPS MIPS ARCHITECTURE" 
        <linux-mips@vger.kernel.org>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        "open list:WATCHDOG DEVICE DRIVERS" <linux-watchdog@vger.kernel.org>
Subject: Re: [PATCH v2 6/9] arm64: bcmbca: Make BCM4908 drivers depend on
 ARCH_BCMBCA
Thread-Topic: [PATCH v2 6/9] arm64: bcmbca: Make BCM4908 drivers depend on
 ARCH_BCMBCA
Thread-Index: AQHYn+uxAbB9TwTL6U6uXQZJxy0Tvq2QU3IAgAAZdsw=
Date:   Tue, 26 Jul 2022 09:59:20 +0000
Message-ID: <MN2PR17MB33752B92BF227C5288B51C2CB8949@MN2PR17MB3375.namprd17.prod.outlook.com>
References: <20220725055402.6013-1-william.zhang@broadcom.com>
         <20220725055402.6013-7-william.zhang@broadcom.com>
 <55668d62aad8feedb7fa78f410f4f71ecfce8c98.camel@pengutronix.de>
In-Reply-To: <55668d62aad8feedb7fa78f410f4f71ecfce8c98.camel@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-tmn:  [raj1UmtPwuQtfdiq+c3IiZem6Z8ALjhxv4+VFCoEmUREoqhJy3lpG7OUXVrXXwm3MBcekyLRAF8=]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f712d961-22d6-4cde-f000-08da6eed82f5
x-ms-traffictypediagnostic: BY3PR17MB5681:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wcqTzd4eWB/95+ELGO/TfSGBCeZxaQTRHCIMRmL79lDoKcqcWZIB2ufXnoh+BMdif2nPj9xoI67UzH2uAHu7xtvyfxY6BOufT1Km7d71mOk15F2qFVQZpzeZNpCBXP15r0n6Tm7PgvKM3aW8u0K1bnNjd8th9DNOcoDwXrkRbAUHcDTwew+SYB+GaBy+tEjK9ILXKc0wjaAiXgJMA57/3ebpvOgQBN52uT8uYkrTeONGph0Jt/rjGvxnQpF2/n1GNy567FbDMq/fA3WobgIja7/862pHDa6+4fLPZqgxW9IXKLmcOfq+XfgoAK27wgDUFVjScRq0rShlkBTfrHIuT7FMDLReT2fBdyu1xHT5tIVbIitv0rEKx5W6Znr7aZF3JjUM6PC+qEQLOaxzKlhCW6GLbY0lZ+uh2bXjpVf9SlaBJXPEtwgyu0yanTcsD2GXdGFfSta1A9wvGKaQM1zFsLI7eWEWihs7Ar9+rvnd5fCZNmfzK/2FGnMuh/AF3lnrBmzBFWlZo6lpuEpCppSV3xSh9HBj6tnJyYMaKl6qzU0PbZxnfuBC+QmrIl3c7cUcOBypurBQgnMM/ChiF6R5p6TUyPbrYqF4vMWCyTmpoKuznfsif1c89S6grXGO1eECaN37sB+fhCqTs+RXM52UdIJf8Z3BX/xU3Ksj+FSMeqoaBGSB0v+Bld0+7hJFPebK
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SEJ1SC9iQ2gyQkxRckx2ZGpJZDZkZllRYjl6cXNQVWZUQk9BTHVySEMyK2xN?=
 =?utf-8?B?TExFUXlrLzZYYnFBc3dCVTJNT1FqeW5mVFREZzE2a3lDTUd5ckxIN1NIQTBB?=
 =?utf-8?B?TzdnTi9yUFFIZys4Q1A3UjJRUWtwMGtNdWY4RjVTS1h2TGlVY1JqcFdGSmxl?=
 =?utf-8?B?M1JWbzhnWFhnZU4wdjRGVHcwc3ZnWDJtU2pJcHhqRGNHSTdDM0tvT1FRMWJO?=
 =?utf-8?B?T3EwcFRRR2VRVVF5L1ZRbXdzbEVEcE15UXhINlFyNEJoSjJydHptYk5tdEVV?=
 =?utf-8?B?akpialpNK2FESFIwQ3A4dkNMTWxOZVphWW9qSkN4M1FNK1lRaG81SHBsblk4?=
 =?utf-8?B?NVA4VWh4UlE5cE5TbXpJM0lFSndxeW04TGIrUnB1bkZIS1p3aGt4bXA1bE43?=
 =?utf-8?B?R1Zvd3dOV0JGSGtxMkVTVDFzYklHNXlJQWk0T1Uza1dTYkYza1FXTVROZkg1?=
 =?utf-8?B?YWpHZks3Z3FRSHYrRmVFZTEvM1FTQVNkckRCSXhneVFWaG11VTVmSTgyRmZK?=
 =?utf-8?B?M04rdTF3cTNxNmViT1FSQTNQUzdOMHAwaUoyUmtBUVlIaGVNNGcrVWRnbEE4?=
 =?utf-8?B?VjAzNkdlSVVrVWpiUGEwd01taTdrUUZGeFV0d3pMUS90S2FCamNKd2IyVENY?=
 =?utf-8?B?cWlpMm9oeGZuOVl5QzZiRVBVVGJDL09LZkQvSFhocFpUb2xrMlVyZnRoZ055?=
 =?utf-8?B?NXBIdWkyQlhna1hjSTJXOEtYWFZLMkVrMDlYdUdaUWNtOFg4VjlUdGNMN0Z2?=
 =?utf-8?B?MEQ2OWJUVFNJTmdhTExGK1NPREpxRnFycXlUN2Z0UUtiaTkxRE1VWDA5N3B0?=
 =?utf-8?B?VkxoY2k0Z04yZEI0VEs5TFVzR0VvRXhLKzhtYzdUZFJ2Vzl0d01QdVgzMUho?=
 =?utf-8?B?OHYraEZRMTR5bmRlcGRhVTVJRmxTbHE0MHNRYzFUS2tnTjM0MS92U2hKTGUx?=
 =?utf-8?B?RVphd1B0OWU3NHowSDBnVXpMZ3pKY293TTVxUkNNZXRCWkl3MlNGcDhRZWlZ?=
 =?utf-8?B?aWVJSlZ2QXp1bUw0enlWVnB0bmVtY0RKWFQxZFJxTS9ONktvcjRFNWFIWGl6?=
 =?utf-8?B?cm9TR0tsbUJ2eDFiWTdoUnc1TFZyRks5Y2hlbGpvalJVRXVPZG0ycFVJY2NI?=
 =?utf-8?B?T2JJemZFa0dkZ0pjMWFZTVRFZFp1bjlucEhmYkhMeTdtZWtKMU9FclpEQ1Jq?=
 =?utf-8?B?RlQ0VzNPTkQ2ZFdEbXdhMmFOdzVzaFkwS2tnSnhQd09SNzkrQUhYTjQ0WDha?=
 =?utf-8?B?WXc4cEd5bEc4cWZESXg2WndHOWlwRERBUElsNFUwM1pscWJCZjBiL0RJb3px?=
 =?utf-8?B?bEt1TzZFblhOR0tzd005K0VQU0ltQjdkZnB1OEMxWHl5RjRlL1hBbzd2aXV6?=
 =?utf-8?B?cERiYmNUOUdXalQrMG9xcnJleloyTXVMQmZGSkJaYWtBcEpRWmhablRqTDF4?=
 =?utf-8?B?RXNaMlBrS09jc01wVUFCdnRWUFE5ajFjWm15T3d6WkF5aVZqQlloc1NrNVN0?=
 =?utf-8?B?STZDaG41d3RvUVVrUmp2dmdOeVhiRjZtOW50ZDQ0L2psQTVORGVNVkFVUkxG?=
 =?utf-8?B?L2lzb0hDY0wybytteis2ajlMektSTUtkTnhCTHdqekdVU3BBQ3I2enNYbTQx?=
 =?utf-8?B?Q0p6S0l4VkFTdnBnOTB4aS9UV3ZySHlpQkJzazdJQ1ZmMjk3emVBRERSMVRG?=
 =?utf-8?B?L1JkN0FlMnl0RHNpNGpSOU92MWY4T3BESEozbWVyNnJ3VGE5SUVVNzd2T0hS?=
 =?utf-8?Q?vE1+ni485rTpmA/COIf9MNpe0bwMVOCbkuJFhEM?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR17MB3375.namprd17.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: f712d961-22d6-4cde-f000-08da6eed82f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2022 09:59:20.9650
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR17MB5681
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyBpcyBzdHVwaWQgDQoNClNlbnQgZnJvbSBteSBpUGhvbmUNCg0KPiBPbiBKdWwgMjYsIDIw
MjIsIGF0IDQ6MzEgQU0sIFBoaWxpcHAgWmFiZWwgPHAuemFiZWxAcGVuZ3V0cm9uaXguZGU+IHdy
b3RlOg0KPiANCj4g77u/T24gU28sIDIwMjItMDctMjQgYXQgMjI6NTMgLTA3MDAsIFdpbGxpYW0g
Wmhhbmcgd3JvdGU6DQo+PiBXaXRoIEJyb2FkY29tIEJyb2FkYmFuZCBhcmNoIEFSQ0hfQkNNQkNB
IHN1cHBvcnRlZCBpbiB0aGUga2VybmVsLCB0aGlzDQo+PiBwYXRjaCBzZXJpZXMgbWlncmF0ZSB0
aGUgQVJDSF9CQ000OTA4IHN5bWJvbCB0byBBUkNIX0JDTUJDQS4gSGVuY2UNCj4+IHJlcGxhY2Ug
QVJDSF9CQ000OTA4IHdpdGggQVJDSF9CQ01CQ0EgaW4gc3Vic3lzdGVtIEtjb25maWcgZmlsZXMu
DQo+PiANCj4+IFNpZ25lZC1vZmYtYnk6IFdpbGxpYW0gWmhhbmcgPHdpbGxpYW0uemhhbmdAYnJv
YWRjb20uY29tPg0KPj4gQWNrZWQtYnk6IEd1ZW50ZXIgUm9lY2sgPGxpbnV4QHJvZWNrLXVzLm5l
dD4gKGZvciB3YXRjaGRvZykNCj4+IEFja2VkLWJ5OiBCam9ybiBIZWxnYWFzIDxiaGVsZ2Fhc0Bn
b29nbGUuY29tPiAoZm9yIGRyaXZlcnMvcGNpKQ0KPiANCj4gQWNrZWQtYnk6IFBoaWxpcHAgWmFi
ZWwgPHAuemFiZWxAcGVuZ3V0cm9uaXguZGU+IChmb3IgcmVzZXQpDQo+IA0KPiByZWdhcmRzDQo+
IFBoaWxpcHANCj4gDQo+IF9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXw0KPiBMaW51eCBNVEQgZGlzY3Vzc2lvbiBtYWlsaW5nIGxpc3QNCj4gaHR0
cDovL2xpc3RzLmluZnJhZGVhZC5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1tdGQvDQo=
