Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61C9F5B9EDD
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 17:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbiIOPeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 11:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiIOPeA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 11:34:00 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2095.outbound.protection.outlook.com [40.107.21.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B11BA4DB21;
        Thu, 15 Sep 2022 08:33:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UEVJyI3xVfBPWYCIdS2oLulUwlm+p61Drk85cMnfz7fUMo6uYHIMFiKjK8rrtDi43xH2U7M5NMzbv+13RSNnlWix57FzAGBZKA8/GWO7v5JvVVs2L5PYaQEAPm0aYpSRdTIe8Q1CQgUG28pK+6dIcqdqc53bBpoXqkGoyB7Li+fpDQG00hEWYgc9l7k4vwyzIFJVf1HjKLhALeM7Eomw078UlXuTMTUPQsgFanHZqSiLM7G3Hd6PyPgbznScsHPGqQhSD94b8UNWcF2/jIn34W8ctq9CQzUR8qccf8YhHdeeArNqFLVAOa4h2LkpdByGJ40bhndb26/0cGwUL4weFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t/ASbHUw/qcAVdmsdUm7hR3vYJ+G2Be3rhEmRHP5iFg=;
 b=eGn+rLkG4+Sq51JmKUeocS+J+aE1E88hvmYm1Vdv0wcXvaxNHZVDKoheGp+rhZa9pwobYZoUR6SFnR/VWc4+NzrQ29WnzEhMZEmMs2T/cZOTc8cdAj3nwKpvhILV6cfPoofTGv9Lkz2lZaCrSmg/IaqLONN4LJ2O6oyxNL/XLSvKPB6VmgoYkqvWqDuoYF8LpMYVwbVlUhZLWHOnCo6i5GynleCFuoLDQpTpuSWXPlh7qzPo/jAPief7tNfqB+QZiiXVL0JKJKQ+f/AE9D3orQmeW2qxng2qHOuLR66Sd7jcEv4s/LoQ757nLGgKBlJ5T0iALihA4u7+lc2Ec72HTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t/ASbHUw/qcAVdmsdUm7hR3vYJ+G2Be3rhEmRHP5iFg=;
 b=O1ib75B6nFuQB/WtR3bcQhqzRhZF9ySnseSaWZ2B23Jjs7GE+SF3SLkDRrMfP3g8aTim6MFnNgddd+u9dnqK7MKEXEgmLzYJ4GzaeM7Mge+FFlBckVKMIC/GgPqFVTgyyMGe1MJf8XqFek5Knm9DRmUbPHlxIa1qQ9mfSt7LgbI=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by DB9PR03MB7567.eurprd03.prod.outlook.com (2603:10a6:10:2c4::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Thu, 15 Sep
 2022 15:33:57 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::f17f:3a97:3cfa:3cbb]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::f17f:3a97:3cfa:3cbb%5]) with mapi id 15.20.5612.022; Thu, 15 Sep 2022
 15:33:57 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Russell King <rmk+kernel@armlinux.org.uk>
CC:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        "asahi@lists.linux.dev" <asahi@lists.linux.dev>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Hector Martin <marcan@marcan.st>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rafa__ Mi__ecki <zajec5@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        "SHA-cyfmac-dev-list@infineon.com" <SHA-cyfmac-dev-list@infineon.com>,
        Sven Peter <sven@svenpeter.dev>
Subject: Re: [PATCH wireless-next v2 03/12] brcmfmac: pcie/sdio/usb: Get CLM
 blob via standard firmware mechanism
Thread-Topic: [PATCH wireless-next v2 03/12] brcmfmac: pcie/sdio/usb: Get CLM
 blob via standard firmware mechanism
Thread-Index: AQHYyRiSXV7tePP8dE6YDpJGjL19hQ==
Date:   Thu, 15 Sep 2022 15:33:57 +0000
Message-ID: <20220915153357.v3hgwwyoohkwkdx5@bang-olufsen.dk>
References: <Yx8BQbjJT4I2oQ5K@shell.armlinux.org.uk>
 <E1oXg7X-0064us-KL@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1oXg7X-0064us-KL@rmk-PC.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM6PR03MB3943:EE_|DB9PR03MB7567:EE_
x-ms-office365-filtering-correlation-id: cb3162e0-22d8-4485-def5-08da972fb49a
x-ms-exchange-atpmessageproperties: SA|SL
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Al7a8bnHCi/mIkpJG1dm4/shLmPLaW2ZVqD/YLhfvkm3CWmmuhGLWJZ2W89sWhdnnitHAE2uZeq2SAFp3TIl7EFbyi6ds4uY14ZVY7AZqGV5v7QRO+qun6lSmZcZn4cRKj+GhmKy4UBu8SlqUYcwXbFuQEOXA/CSe87tK1mFl1gLj6/RRQRiDz3+/O281UU5QxUX/9Y2JNx/YoPBdDo+wg+bj2/JET/ilIYI/Txe1io0q4E6cm+AmLoGOnc8u8NwSIo/weZMhqn19jX8W1YdqjSl92GuraDxTq05mP4eb7f7lKnl24KZQPEJg7fcTaBTIOH7pAThX6CzjvkzNMWsyF8ToVX1zNJ8rwZfGe8Dwa2A7WI4fgtevZZVHk+wOq93779wkXPFhxjdxJZhYyTSn6y0j23/KTtktUnqQXvvFUWg7O2/NfvF2Rtbd8/fbce6xN8x2H2YPbx90QIhgeDwuoIQzvx/mNq8JkdBkM+oU/HcIYrIBqa78RX/YBWC6h632fZjOCNvUtEPZdIEJ/s5gqeoyBzzN0hjRxXu8qzmu0DFNTi6do4HY5VWcLLD7qtlMoj3QUtdWnEef3/LnF50pQoluOZB53MdzEdYUc7Rl0RV9N4ZSSLZIg7BD7CasHPOFtyX4qHaFNaAi31hhKU93kKjRW17OI5JznhPvs5V4+CkEowhW9KNIQIO1QmqTbBvYxv6wxkt7ynCBf2ia3IKGjAsTZjYctBQZEauWnKPunBJR785qqUOcZ6jVeZeQWtqE+992oXZLRxnKEtTVIr6Wg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(366004)(396003)(346002)(136003)(451199015)(122000001)(5660300002)(4326008)(91956017)(8936002)(4744005)(8976002)(64756008)(76116006)(2616005)(8676002)(66446008)(2906002)(36756003)(316002)(66946007)(85202003)(6512007)(71200400001)(41300700001)(86362001)(66556008)(54906003)(6486002)(66476007)(1076003)(6506007)(38100700002)(38070700005)(85182001)(26005)(478600001)(7416002)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cFpuVFI2SU9VZ1B1c0tPblN4VXA4NDh0WEJFZjIzUkFza1hvZVNpckh0QlJV?=
 =?utf-8?B?SEFaVlM5SlFLRDhJdjJwTHBlL1VKd1dpQ2FVQkJweGUwNmNpZHc0UllCK1ZJ?=
 =?utf-8?B?ZGRpYnFzdDNyUUhGYjVnZ0RRMVNNTTZNTlFTK3lPSmlETW5WZGIyODhJWFBN?=
 =?utf-8?B?b3JqTjhZV2gwRlBtSFJESWZoMUVYTzc2WE5ia3RQNjA2RHdWZlFRNHd3YTR2?=
 =?utf-8?B?bGYrQVB0OG5KcDJnTUxhRmFhbG1LUHFxZExBblJNYkFYV2RjSnFYclI5cFM2?=
 =?utf-8?B?T1FDL0lYaWdxVWRsVEdEeDVVNXRVNjVvVjEvWWg3RnVDbGxyb1JrdUc2aXhi?=
 =?utf-8?B?TExMeElTOHhralFzazY2eHJPMmdFWjZRTE9YS1o2MnRVcDJuN3JrV250cStt?=
 =?utf-8?B?UFR3RE14c1p3ejlxWjNtbytiZ29EZHdvbE51Ym1UUG1jMUV4TzM4Z1NzODNy?=
 =?utf-8?B?V1BCcGkwTHRFb0tXQUlnZEFFMTc2UERpSTRWMHRUbHhKU1h1WkZQSWtMRFdG?=
 =?utf-8?B?cExYNW52RjFHbEJKc0N4T0xpbWtsRTBVQU1JOEdIZlF0ZjlZSDdpVWlHdTlq?=
 =?utf-8?B?L1lQYVlTWXdCa1FwMitZb1g3OW1pSnpKVUxKOStzc1phTE1ERCtmMjAzZU5W?=
 =?utf-8?B?TzF4YVNFMW1NQmxiMWsxUVBMYjgxVzFmMmFXSzVjSGNxS21JMXRUZ0ZUZHlD?=
 =?utf-8?B?d3NGUmZjYXRxaDY2UkRQQXd4MnVFeEJRUHhQQS9OeHJXd2Q0R2s0akR0TFdu?=
 =?utf-8?B?Y0kzQ0xiM0o5Z3NWbnl0SVNPTXZNbTVGSFEzeStnNURZaGVQRnR2MXJ1K3pp?=
 =?utf-8?B?NWJ2bHBGekI5QXF4YmRXV1dNSEUxNkZydEVYbGpHODdCTGxad1VUeUJIYVc2?=
 =?utf-8?B?S2NqekxSZ3RMMWw5T1hWdjYyYmRCSm5qWFlaWjRLZFdXSlpjNThkenFLWkRU?=
 =?utf-8?B?YlRjOVZuS3lQSWpDTk9mNTZRWG9GZ1o2SnNMRjFyRC82ZHl3cE5pcy9iTExH?=
 =?utf-8?B?U0pIQ1dOMDZob1l4RytITm9Zd1RPMWhMV3ZWVlFiNG9DeDEwS29PaFBRNTBR?=
 =?utf-8?B?Sm9jaGF5WUtPdUUzNWZZREh3VHkyZkU4UTlYVXVMUm82WmZrR05LUzhwdFAz?=
 =?utf-8?B?dEtneFB6bDhGcHFwWFhtN2xFSW1MalRzYUJvUnphVEJ4RFozZTQ3c3pRUm83?=
 =?utf-8?B?YWk3ZStScU5Vb0x3L3hZdUg2YzN1bVRaakJiL2ZGVTN3VlFFWERmRURFb2dM?=
 =?utf-8?B?U0hDVUorY3FMVDNkQ0cyQTZmc1pTRFZEd2R3M3IxVFdoZ0djdHpnY3JYeGdw?=
 =?utf-8?B?MlZ5SElVdlV5VDFpRUZwUUY5SitaSWRxZ2ROZGl3WUlMbTFBSEJOcFVVc204?=
 =?utf-8?B?b3Rwd2tVckFteVpDQ01QSjNGcjAzeFg1SlZlR3pOc1kxRVByQnFIWjJuMUJH?=
 =?utf-8?B?akJiM2pxVWtMMEN3RGx2R2NVT2k2eUwzZlpIS3U4WnVqQ0t2ZlNTVkVOYkVl?=
 =?utf-8?B?REIzTDFybjVLOFo2OE5oTUI1ZjR6SWtQc2FTNm4rR0I5bFVrRGN0dGE5Vkw2?=
 =?utf-8?B?U3h6cUZEMXFUeUFzUHNaNG44RUpnZ2FqUnRuT2lBZGpEWmNWMER2dHhmdHRE?=
 =?utf-8?B?djFNTXRaTjdZWlB0Y2paelJ3NjJXWDhkRlNkWW9YN1AwNWZ2RmhJWldoRmN0?=
 =?utf-8?B?RWQrcnhXRmo4ekJvUkV5dnEyakl5YUJEMXVCMnQvaFl4UkdFUCtZWUdEM1NU?=
 =?utf-8?B?bVBqdVAva2JoYXNMRGxBRWk0dEh5RFd0K0EwNGVuZWNrUjJSdjl0RUlOcUV0?=
 =?utf-8?B?NklwWUdXMkJlV204SzkvVGc3NlVpWmZ3TTRwSmc0YlJMTHVNVTE2UDAxRUYy?=
 =?utf-8?B?QTFPSFBNZk1YVGhrV2ZMTGJRaTgyUE1uMTArSU90ZWxHckdIK2U3Nk56U2RX?=
 =?utf-8?B?T2RBeVV3dnFKVS9Lb2dMWWZtR3dUTEhuQ3VtQkVxazVJTklwQXpQWGJtVkZv?=
 =?utf-8?B?RXZXUStSSE5lKzhaTkJUaEx1dXJUaDJOTFpJbDUzUkRjWU4yaFoxY3RGbkZ3?=
 =?utf-8?B?T0ZHbUN5TDlVQ1hIOG9DWnIrbUhVd0FKNkNhc05BaUtYUXpYVXFuYXJadkRp?=
 =?utf-8?Q?UZOLQSs+Zv36Y/HaKwWnrWi1t?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <ED671327D0D3224A93619A0BB90232C7@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb3162e0-22d8-4485-def5-08da972fb49a
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2022 15:33:57.5339
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qSvtnnVSKsQ+hCQX72mwezvKDGTffW0ZObl7q2oNuYDG7lic1NpEGFAYVliwKv2Sf0RvQ3HIqVEr0aHL9BmcyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB7567
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCBTZXAgMTIsIDIwMjIgYXQgMTA6NTI6NTFBTSArMDEwMCwgUnVzc2VsbCBLaW5nIHdy
b3RlOg0KPiBGcm9tOiBIZWN0b3IgTWFydGluIDxtYXJjYW5AbWFyY2FuLnN0Pg0KPiANCj4gTm93
IHRoYXQgdGhlIGZpcm13YXJlIGZldGNoZXIgY2FuIGhhbmRsZSBwZXItYm9hcmQgQ0xNIGZpbGVz
LCBsb2FkIHRoZQ0KPiBDTE0gYmxvYiBhbG9uZ3NpZGUgdGhlIG90aGVyIGZpcm13YXJlIGZpbGVz
IGFuZCBjaGFuZ2UgdGhlIGJ1cyBBUEkgdG8NCj4ganVzdCByZXR1cm4gdGhlIGV4aXN0aW5nIGJs
b2IsIGluc3RlYWQgb2YgZmV0Y2hpbmcgdGhlIGZpbGVuYW1lLg0KPiANCj4gVGhpcyBlbmFibGVz
IHBlci1ib2FyZCBDTE0gYmxvYnMsIHdoaWNoIGFyZSByZXF1aXJlZCBvbiBBcHBsZSBwbGF0Zm9y
bXMuDQo+IA0KPiBBY2tlZC1ieTogTGludXMgV2FsbGVpaiA8bGludXMud2FsbGVpakBsaW5hcm8u
b3JnPg0KPiBSZXZpZXdlZC1ieTogQXJlbmQgdmFuIFNwcmllbCA8YXJlbmQudmFuc3ByaWVsQGJy
b2FkY29tLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogSGVjdG9yIE1hcnRpbiA8bWFyY2FuQG1hcmNh
bi5zdD4NCj4gU2lnbmVkLW9mZi1ieTogUnVzc2VsbCBLaW5nIChPcmFjbGUpIDxybWsra2VybmVs
QGFybWxpbnV4Lm9yZy51az4NCj4gLS0tDQoNClJldmlld2VkLWJ5OiBBbHZpbiDFoGlwcmFnYSA8
YWxzaUBiYW5nLW9sdWZzZW4uZGs+
