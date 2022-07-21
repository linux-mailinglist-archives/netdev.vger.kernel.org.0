Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93A7C57C302
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 05:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbiGUDu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 23:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231184AbiGUDuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 23:50:32 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12olkn2064.outbound.protection.outlook.com [40.92.22.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 563803DBE8;
        Wed, 20 Jul 2022 20:50:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C6En3pj1uLILPiPcDYH3wJTWDR2i1C3PTkdZvVkgrnMURMqIgb4zUiCBfvgHkHMSEiL0gJ6NUt28TNcX5JQr1eI486JPkSiGc2WFirsZ663h05EhLMY/Io9uaQiDH2Cp/jQUCIK5/g+zytt9TBhH4fW6xtnBXoWLao20sZ86XvcDBhFaHM2C0gFbmq13TR+7NOg+GDwtjxIvomWNQlCat6t7oftiZgPJAQfnEeklvEv1Q2WMW8xEexxf46joqAjSBwqIRCB7mFv1RXWR5T1fKlpIfv5pvhPuWUHFFjEZiwP4FF9eBTvateknUWMwrfrX23YWsqw81H1eC998l0NDMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k9OQrk1uobKH8zwqU2uEman5LRBC4d+lvkZ3B0KUhY8=;
 b=jjvaCfLula7jr4XN2Mo8x3CXPmUA7Owv4Y44rHiCSCPcFkqU9OCxKFRadHTtIBeaxzABHpJ14l+i15BfPNcXjAjPLC3HTIRArPSckEpM2FVu0UUzt87eaMExyJmS50mk+JSzzrp6GRCVFHTwS1FZ1FaAd9w9FBPowVwb8jctA2hrmzSWgz8i58OVNBokCDsG6y5JNZj/mwOTheLiAQhib1tcKmLNgR2Su9TVaHRZIW/94+DVCX4RfHDYJ9D4xi36ebMPbBZLB+za6ztPinD+RYv4b4X64plwiw/0xCl/9Z4J9q1Dkwt2aQpcDHXIgYu8VLVBduN1TM2MCbVFFSoYew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k9OQrk1uobKH8zwqU2uEman5LRBC4d+lvkZ3B0KUhY8=;
 b=Gbw0dlWkI20pkkMZPB+puYRQMm1HPWXY7oYhiWyfSGHDGdDreviaAPi2hxH+nt/1b1EywP05CIKvNnoUqd2Ux7N3UaohHky6itXyEh+pgSOwEW4TWw3HCHxJYZIXACy7kjLbTNAwrsv16SIu/fFGACq9xs0Ump2/bwnbYYSk1/A4z1ukpDjmL+umI2NEuzPkaRfgBDg58FYTL/Rx7X/hca1+GNF57sCEsHH1De2vDM11JMcwsN97/rkkW2WGkoas/qiLLDbPedKDt5UhzXLIVXIcX3ChouyA/1Bm+ezMESp742EBX+783QHK6wPFYrh9LsBydnVddCcaMQjAxxnz5A==
Received: from MN2PR17MB3375.namprd17.prod.outlook.com (2603:10b6:208:13c::25)
 by SJ0PR17MB4550.namprd17.prod.outlook.com (2603:10b6:a03:335::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 21 Jul
 2022 03:50:22 +0000
Received: from MN2PR17MB3375.namprd17.prod.outlook.com
 ([fe80::48d3:68bb:bdcb:4658]) by MN2PR17MB3375.namprd17.prod.outlook.com
 ([fe80::48d3:68bb:bdcb:4658%6]) with mapi id 15.20.5438.024; Thu, 21 Jul 2022
 03:50:22 +0000
From:   Vanessa Page <Vebpe@outlook.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     William Zhang <william.zhang@broadcom.com>,
        Linux ARM List <linux-arm-kernel@lists.infradead.org>,
        "joel.peshkin@broadcom.com" <joel.peshkin@broadcom.com>,
        "dan.beygelman@broadcom.com" <dan.beygelman@broadcom.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "open list:I2C SUBSYSTEM HOST DRIVERS" <linux-i2c@vger.kernel.org>,
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
        "open list:WATCHDOG DEVICE DRIVERS" <linux-watchdog@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: Re: [RESEND PATCH 0/9] arm64: bcmbca: Move BCM4908 SoC support under
 ARCH_BCMBCA
Thread-Topic: [RESEND PATCH 0/9] arm64: bcmbca: Move BCM4908 SoC support under
 ARCH_BCMBCA
Thread-Index: AQHYnJYZEMhK4a4RdUuXvO3VZlf0QK2IK86AgAAANYCAAAMvTIAAAaLF
Date:   Thu, 21 Jul 2022 03:50:22 +0000
Message-ID: <MN2PR17MB3375C81665CC0887AD6B91CBB8919@MN2PR17MB3375.namprd17.prod.outlook.com>
References: <20220721000626.29497-1-william.zhang@broadcom.com>
 <40cec207-9463-d999-5fc9-8a7514e24b91@gmail.com>
 <2492407a-49a8-4672-b117-4e027db09400@gmail.com>
 <MN2PR17MB3375B15F7E0673D50B241CD5B8919@MN2PR17MB3375.namprd17.prod.outlook.com>
In-Reply-To: <MN2PR17MB3375B15F7E0673D50B241CD5B8919@MN2PR17MB3375.namprd17.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-tmn:  [1MvGEaVt/S44/WDr4z0C75WJTNAjaEuicyGl1jnNoiDONMmGzntb65GR5ZdtBDTrKuRcNDq8yWc=]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 01d3283c-fa8e-4649-f4d5-08da6acc2372
x-ms-traffictypediagnostic: SJ0PR17MB4550:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7dAAh7kqL/ns7gA9KjTUs570MHWcE7uAKaTfZvoBnrcbaPqSMzZTBNLATcMXSmhxnTMqjcqIgpa4f8p7Rk3iIja+JT2OFNaBm9vthVaC29hXplHIHb3HDZnx7L290GvhM3wK8zOpgya8U3AGdl9agfan5csd2H6zP+V3WB/sJPFmWWY7PEyZCNv7MoBjd22Cxabk/xJAH3BcwbFN2XX2OFUpTE/00pLbI3YGE7LrqUd5XCdVyl2ZcYFPYG5k0OEKM8cgxYkrRlCn1U7XNhs7IYB0/5oHqqfZRhL6Uff8/iC+S3F+FlpciYphUhOQA1vx6+dmOWd/eHQccxzeqisa8286rTTWiU3VpHVJScGgHqyfQyF0Yl37Jnww3/ksXEuggvTOTKIecinq7/yRWEJSCiqIyLr2O6oQIk2H67SpbtlOe1eDWfj2z9zluw+E3AvPCeFGIahY16h2cLlf29bN+nM9zla5M2zeQ6/eaJpxeXydE7qQFiIsV9CBPWRY8FQo7z9Ktdc7+6Wm9g/TDWxe0DTubZMjtGz8Zke2ct8YPzoOZZQCoItXG6UOHgVIO/lUA9hKm8sFsNylZcDCq6k2A/RUsxpFK2YzjhQOvc1vNnqHJdBYJitvurSnL/JR334z1xgViPFGFkLVWJ/zZL+BnjZcrk7Z/Rx8V7uc6TD3+KdO8z3KeysIxTtL8AUzu5JX
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ODZlZmd6ZWswdDBlWUVnaWQraFJhQTRRYXozSmpUKzl2eFd3TFVqbWNXZ01O?=
 =?utf-8?B?WmU2NlJjZ0JBUXVuMEJGeVFhaE91TjRYZjNvc1lFdmRqVkQ0YzlVMk85c2xu?=
 =?utf-8?B?c1R2UGpDUDNuY3dFZlYrRVJiUGdGR1I2OXVEdFBRaFdQM0NNaGlBQmpRb0x0?=
 =?utf-8?B?d1JJWW9QK256cndhUXpYQTlaU0lrTTNZejFBUFYrdTJBUjF4OEdnbkNzT1R1?=
 =?utf-8?B?NUhPSEc5ZHhCdlYvZE16dHo1RVViZVh0YW15Wkt5MEMvVU9uaDljSGFoM0Vw?=
 =?utf-8?B?Ylg0TWZCRHFzUGl5dXNITW0xOG1PbkFxcTVrYXZvNzBsNC95UGsySEJFemY1?=
 =?utf-8?B?cWVpYi9BQVVKZkNzZG16TUVUUVM1WS9WMC9lQ1BVb3FKRjB1Nlo0d25mNlFv?=
 =?utf-8?B?V2FacmZncjR6MmNaKy9uZThLdXozUHhXSndVVzdLamVEVkxiUlZ3WU5XeXE3?=
 =?utf-8?B?Vms4OEZRVEhJMHVqVCs1bnpQWGJTNUtqeE1sRzlPdnJtQWhjQytQYlplWWdN?=
 =?utf-8?B?N0dvc2ZSMDh1RlZBU1graEJURjBTcEwxbEhXUlJYSkdZRjNncy9nU0Z5MHN0?=
 =?utf-8?B?eDlRTVQ1bGxCZHk3c1hjcGkyOTEwdzhoRlNlTlZ6ZnpKbWU3RHRrUExydHpu?=
 =?utf-8?B?aUJ1blZMeFhZdlRSR3VaVmpqYkdSZ0VjU01oTGF1bDcxa1A4UUlyL2ZxYUlR?=
 =?utf-8?B?dmgwWGJlcE1aOEdDZmlJOC9CdUJISUdOY0xWOW9HM3lwR1dwSTJGNlBsUEFT?=
 =?utf-8?B?ZWZZWmRkTlBDVGduekdBZkZhakMzd0JxNURmSEM2RGwxMyt3L0J1M3o1cDVR?=
 =?utf-8?B?R05QK3RDVzJJVWNwYlJQS21xbmZNbjRlRjlvblJZWTNYdmxIbXd4cnF5QUMr?=
 =?utf-8?B?R0N4YU5RVkdleCsreXg1dnNJN3hBdWlrMjY5NER1V2dGMENrNXVKcHg3Tmwz?=
 =?utf-8?B?QUkrc3dDYXhVSkxqRVBzOVlkZFRKcVphLzNuWElzbThacDNnOHFsTndBazkv?=
 =?utf-8?B?M2dPTVlIM2x3eVF5KzRMT2MwSW1GUnQvSTBQZ0cwV3F4NCtlMytNeVlhS2R0?=
 =?utf-8?B?LzRnaGdUQmZ1Mmh5ZHZrMFdEcGQweEZTSUxLVTZWV29COVd2RFBzVVJVQ2JG?=
 =?utf-8?B?SThVa3RzUVMxaFJvOW96b0pzWUhzQjFYbGNPRy9MSmJEZTU1MXlIL09EanVt?=
 =?utf-8?B?ckozcDNDYmF6dVM0UmlpWGlCTWR5eWhuT3JMTFZlSTBWSkR4aGVVQWdvOWVT?=
 =?utf-8?B?bllZNFMrcjhwZld0aXlyaGlXeVd0TG1CeHNmMnpHb1hZYld5YkEvRXd5ZXJo?=
 =?utf-8?B?ZjJUMjE4dUcvc2g3Z0NabXI1L1EzZDhTTGxNa1V1ajZ6TTNXWXY5SWsrRk81?=
 =?utf-8?B?bmVwaWk5VERLMGhWaEFCUkFLQlZ2ZVk0MXg2OWg1ajNPUVZpbXBOaGpvTjFF?=
 =?utf-8?B?SFpHRkNUTjhxbDI0Q0ZqaDd0SnBLYTEwME5ZbVFKc1IvZ0VGWGxXTWV3ZEJ0?=
 =?utf-8?B?VXoxdmtHbTU2TFdFbVdvQU9sNVQ1V0YvdlhONXBaQ2ZtZXc4OWRlQkppdGcv?=
 =?utf-8?B?WUVTcVFvRStsUHgySHc5L3MvNGV3ekZqUVNwU1NNajNCM0xvSDJHb0MrS2Fv?=
 =?utf-8?B?d202OHhmWVIwT1Flb1YwL3BWMDJXT1FxVlJQMThScCtLRG9WNkhWTHJzYXlG?=
 =?utf-8?B?Y0lYc1BjaisrZjc3ZGNSdmxNODhDWlFaUVoydmg4VXU5RWo5S3Z4VkQ2Zks3?=
 =?utf-8?B?ZmRnYzhVOWpqWFpjVVV6SHNZQWtaOWpwUy9LcDM1UWM5VFBlUmxJQTNQaWgv?=
 =?utf-8?B?bkNwZkh2VG5xZ2xhT3V5QT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR17MB3375.namprd17.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 01d3283c-fa8e-4649-f4d5-08da6acc2372
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2022 03:50:22.6643
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR17MB4550
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

WW91ciBjYXJlZXIgaXMgaGFyYXNzaW5nIHBlb3BsZXMgaW5ib3hlcyB5b3Ugc3R1cGlkIG1vdGhl
cmZ1Y2tlcnMuIA0KDQo+IE9uIEp1bCAyMCwgMjAyMiwgYXQgMTE6NDYgUE0sIFZhbmVzc2EgUGFn
ZSA8VmVicGVAb3V0bG9vay5jb20+IHdyb3RlOg0KPiANCj4g77u/WW91IGtub3cgbm9ib2R5IHVu
ZGVyc3RhbmRzIGEgZGFtbiB3b3JkIG9mIGFueXRoaW5nIGluIHRoaXMgZW1haWwuIFlvdSBjYW4g
bm90IGRvIHNlYXJjaGVzIHRocm91Z2ggZW1haWwuIFN0b3AgaGFyYXNzaW5nIG1lLiBSZXBvcnRp
bmcgeeKAmWFsbCBkb2VzbuKAmXQgd29yayBhbmQgSeKAmW0gbm90IGRlbGV0aW5nIG15IGFjY291
bnQgYmVjYXVzZSBvZiB5b3UuIFNvIHN0b3AgZnVja2luZyB3aXRoIG1lLiANCj4gDQo+IFRoYW5r
cw0KPiBCeWUgDQo+IA0KPj4gT24gSnVsIDIwLCAyMDIyLCBhdCAxMTozNSBQTSwgRmxvcmlhbiBG
YWluZWxsaSA8Zi5mYWluZWxsaUBnbWFpbC5jb20+IHdyb3RlOg0KPj4gDQo+PiDvu78NCj4+IA0K
Pj4+IE9uIDcvMjAvMjAyMiA4OjMyIFBNLCBGbG9yaWFuIEZhaW5lbGxpIHdyb3RlOg0KPj4+Pj4g
T24gNy8yMC8yMDIyIDU6MDYgUE0sIFdpbGxpYW0gWmhhbmcgd3JvdGU6DQo+Pj4+PiBSRVNFTkQg
dG8gaW5jbHVkZSBsaW51eCBhcm0ga2VybmVsIG1haWxpbmcgbGlzdC4NCj4+Pj4+IA0KPj4+Pj4g
Tm93IHRoYXQgQnJvYWRjb20gQnJvYWRiYW5kIGFyY2ggQVJDSF9CQ01CQ0EgaXMgaW4gdGhlIGtl
cm5lbCwgdGhpcyBjaGFuZ2UNCj4+Pj4+IHNldCBtaWdyYXRlcyB0aGUgZXhpc3RpbmcgYnJvYWRi
YW5kIGNoaXAgQkNNNDkwOCBzdXBwb3J0IHRvIEFSQ0hfQkNNQkNBLg0KPj4+IExvb2tzIGxpa2Ug
b25seSAxLCAyIDQgYW5kIDUgbWFkZSBpdCB0byBiY20ta2VybmVsLWZlZWRiYWNrLWxpc3QgbWVh
bmluZyB0aGF0IG91ciBwYXRjaHdvcmsgaW5zdGFuY2UgZGlkIG5vdCBwaWNrIHRoZW0gYWxsIHVw
Lg0KPj4+IERpZCB5b3UgdXNlIHBhdG1hbiB0byBzZW5kIHRoZXNlIHBhdGNoZXM/IElmIHNvLCB5
b3UgbWlnaHQgc3RpbGwgbmVlZCB0byBtYWtlIHN1cmUgdGhhdCB0aGUgZmluYWwgQ0MgbGlzdCBp
bmNsdWRlcyB0aGUgbm93IChleCkgQkNNNDkwOCBtYWludGFpbmVyIGFuZCB0aGUgQVJNIFNvQyBt
YWludGFpbmVyIGZvciBCcm9hZGNvbSBjaGFuZ2VzLg0KPj4gDQo+PiBBbmQgdGhlIHRocmVhZGlu
ZyB3YXMgYnJva2VuIGJlY2F1c2UgdGhlIHBhdGNoZXMgMS05IHdlcmUgbm90IGluIHJlc3BvbnNl
IHRvIHlvdXIgY292ZXIgbGV0dGVyLg0KPj4gLS0gDQo+PiBGbG9yaWFuDQo+PiANCj4+IF9fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXw0KPj4gTGlu
dXggTVREIGRpc2N1c3Npb24gbWFpbGluZyBsaXN0DQo+PiBodHRwOi8vbGlzdHMuaW5mcmFkZWFk
Lm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW10ZC8NCj4gX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fDQo+IExpbnV4IE1URCBkaXNjdXNzaW9u
IG1haWxpbmcgbGlzdA0KPiBodHRwOi8vbGlzdHMuaW5mcmFkZWFkLm9yZy9tYWlsbWFuL2xpc3Rp
bmZvL2xpbnV4LW10ZC8NCg==
