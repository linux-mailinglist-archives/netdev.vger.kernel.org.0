Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79981537B48
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 15:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236484AbiE3NV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 09:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236475AbiE3NVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 09:21:55 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2087.outbound.protection.outlook.com [40.107.100.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 032BA1092;
        Mon, 30 May 2022 06:21:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mI37GSx6DXPKPGidtUFn4J650I9t4taJTQdMz0GxBydLuLRb38wqYNG8Sp4NybW1eIphaGfRGLdol48hpuczTfoW77ybI0J9KdiEF7F3FLO4tU2qV7dHLXckJEJVjNaK4bquDlt91mV9R0ZHKbZgRhcKTilgsQtSWhscI1BaIZK0f1xPIoxC9LHMLE7rluRezxIohoSFzyQcnPHACMG1+eUJp7hEunY3Fy4+LpbNX/VktXlMClIPRK6ltMVc43QAd4DkPIYayB1gmh0B9dNPtRKrIw7Ia6h+qABBcVhEyv+oNvRrcnwcCYuOZDXGJ8TrIhBhUNDsr+ok03OxfPrQMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hF6/0D8W7p+otLELgfQK0EuVALk1xuT8Ao9ufh0Q6aQ=;
 b=iHkMVsuHvfuATk2UTYT6J+wEhmYOpXXbpY0ZQN2bp+22Hw9yBz316dK6J2uA47omJIE5jogzqWX1crWiMX/K+SlXjuRDB+K9CaLtiA5hHVkV24V6IdPlBA5uKP3AGXASFNQNUiBwHSnbr2neTozVkqyaP/sLxGZ0u+EFe17KTejJ1KYVfbDaiNDLxvjOnHXBImk6ueOuX4A5BmoP693NlviwEszKZPCW4YH0Zf8wKOZ4ad5szuQ/lAHatzxFuzSmThT02/msAJ7oBXUVTlTNXIC5dk8B07RPdMcttlwgVTV485+ebIF4bzFrn5bqIoOCD2mIOyfSTvjhyHfJYJK8iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hF6/0D8W7p+otLELgfQK0EuVALk1xuT8Ao9ufh0Q6aQ=;
 b=c0mM8HOvwU+DaA1amLJnqeov06zNjGqIphc0KlvV9+qwxO35W/KYglzQwDujoNwaZU61QgUKzfx9kn/Z2kKx9TdUMLF0JmyDVuLGSH/eMnfw2F0YOGYNXKm17wpF1Z1hw2yXEayQRZPHS2AEw+r92ipFh2EoaA8yUoy8UuGfZ+4=
Received: from SA1PR02MB8560.namprd02.prod.outlook.com (2603:10b6:806:1fb::24)
 by CH2PR02MB6885.namprd02.prod.outlook.com (2603:10b6:610:89::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Mon, 30 May
 2022 13:21:52 +0000
Received: from SA1PR02MB8560.namprd02.prod.outlook.com
 ([fe80::94f0:32be:367b:1798]) by SA1PR02MB8560.namprd02.prod.outlook.com
 ([fe80::94f0:32be:367b:1798%8]) with mapi id 15.20.5293.019; Mon, 30 May 2022
 13:21:51 +0000
From:   Radhey Shyam Pandey <radheys@xilinx.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "harini.katakam@amd.com" <harini.katakam@amd.com>,
        "michal.simek@amd.com" <michal.simek@amd.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "git@amd.com" <git@amd.com>
Subject: RE: [PATCH net-next] dt-bindings: net: xilinx: document xilinx
 emaclite driver binding
Thread-Topic: [PATCH net-next] dt-bindings: net: xilinx: document xilinx
 emaclite driver binding
Thread-Index: AQHYbBrHRnAzUOGCX0i3+N8bgO5RS60peu4AgA3uL0A=
Date:   Mon, 30 May 2022 13:21:51 +0000
Message-ID: <SA1PR02MB85602AA1C1A0157A2F0DA28BC7DD9@SA1PR02MB8560.namprd02.prod.outlook.com>
References: <1653031473-21032-1-git-send-email-radhey.shyam.pandey@amd.com>
 <5c426fdc-6250-60fe-6c10-109a0ceb3e0c@linaro.org>
In-Reply-To: <5c426fdc-6250-60fe-6c10-109a0ceb3e0c@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=xilinx.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5ea72a9d-4043-4f8a-2e77-08da423f5bf6
x-ms-traffictypediagnostic: CH2PR02MB6885:EE_
x-microsoft-antispam-prvs: <CH2PR02MB68851FB10CCC412AE16A8446C7DD9@CH2PR02MB6885.namprd02.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t2Vru6FnXwmWnkfD8TLIpIpjbBK22Q/MjlvG0M881bk+BJnDaGSadRoZaPTVk1IPX7MEf/v/QGFUCeVQOPRT+AXWgqLVg9AIGXhDiLJeD6YyvEd2FJ4P3VBa3wQCW4PcZYmh11kqfMtGm+6Ct6VLFaYoOuCO5FdXsDQqoU712p9yl0VLxTYoTHCrnbiGhJ/XdzL1/MCV+gp09kHud3dAbzOZYYgIqlLfqfvqm5Wffq3m3MuRpEgkhfO//KgpNBZuUq9FGnNqyZfbtpbflab8uFuZzavhb3Ba9DKFa949TK4juY8WD4b8OZBpgYTccvv0l3dIWFOiDdq0BB/5RS4kcJ+T0sXm4uioa0VSwhYpU78XwpGxPg6UXVRoVJwv5X8CxMWotXT2rtmPY9o86cgSC/Wnw12sll3MsVg497jZqVi0+GphYNbkC7E5z5K1eUvuZE8lb4BZBGqmOHgmhkXpWV9ri1NE87Rc8SlWyZsjFmF+R5+2k3XDykDm6lQx3A5enYmmk/WfHSiBLravvA+W0trjkw5uSymiZ7NycgaaV1vWpyQ7ZF45pC09LXN0jlOl2LCmQtJJN6ICcLMlkZXvfdEsoj346kuAZg9du8jmJnL1mkHzyh5Prxg+ojjvaRntThNVanGy/oYMfGnq3DrZiEEFjWYUhTdgTeA13bj8P8SYnBhhcLHcdhYRPXsf41/VnuzkYKwwiM6rgEH0ASCBgVLfCCNVO0gjXJ1M7XisbjcFLSRo5YxQoD6JpDyo+tpXA9AcJXNWklcfYtftFNVm/zx/3O5vBYWFdkK0RywYMWu1pgR2Sfz1hmjSnAGgJ6cyr8EhUt2zE1dePwcblOGI1VwRbACbteW0Q/zoL7Swuo4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR02MB8560.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(186003)(7416002)(966005)(66556008)(508600001)(52536014)(55016003)(86362001)(83380400001)(4326008)(66946007)(66446008)(76116006)(38100700002)(8676002)(6506007)(53546011)(9686003)(110136005)(66476007)(64756008)(54906003)(316002)(7696005)(8936002)(33656002)(2906002)(71200400001)(26005)(122000001)(38070700005)(921005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dll2YlRIOTFnSmJTUFFHRExFR1dFS0R1MGtvK3I4ZktVcGNES015OGtVM2Jk?=
 =?utf-8?B?aG1WNE9RTm5HVDFGbFM3RWZpNnRYZTBiL2hhckxCWWZOQ0VmZjlGNytEaElu?=
 =?utf-8?B?bzI2MHJ6ZkdTeDUwbm8yajFBb3FyeXlPMEJQQ0NzNWFTVWNYVFVkOTRKL2JK?=
 =?utf-8?B?WEZkbS8rSkxwQk1zUmVkRDZFVzhSeGVrdkp0b3F1ZW0zQnZVVi9pZnZBUWo0?=
 =?utf-8?B?SzVjK2RoY3ZVZ3VyUWVEZk5kVlBrQ3pzRjRUNGtONnBXZUtYNlhNQUpjS3Z2?=
 =?utf-8?B?NDJvc2lJTnYxZHpIcUJ3eEdrSThIVWhNemNyNXhMTnJwdEpZeUZIWmRDaG41?=
 =?utf-8?B?eG9lU244YjRUT1JMeFpsMWtnRjYyYzBDOWcrRDhxMERlVEVZeGhmV0JPR3Yz?=
 =?utf-8?B?bksxS3RWRW1JWGhLNlczQ2pkdjV3RVhrTWI4d2pUaWJJZ2t4MlVEdTJDbWVD?=
 =?utf-8?B?VnJaUlJNWEJOci95ekEwWlRabmZsTk40eG9JVXF6YUFPNm9BeFlWYWRpb2l6?=
 =?utf-8?B?MFljWkdPa25xQVFJV2VibHFrcFNKVFl3SzlTMmR0RlFhWVUxMDltNEZqOUZI?=
 =?utf-8?B?RUI4YWZtZUYxdUdXdlFueVh2bDdjcGI3L0E2Z0tNaFo3ZWJOR1JUVXdsaGtY?=
 =?utf-8?B?M0hSeUNkYlBKc2h2amNIRUZ3WFFGdldmS2NKcU1OaXJRREZzTzN5RHZ6ODNT?=
 =?utf-8?B?NTZxVUJnUVRZSTV5dEhMRHVDSFZMbFM2YmFEYWJrNEExVjBMSUNjMFVud1hJ?=
 =?utf-8?B?bTdsVmNFcXk3MWhSTmNWQko4cnNRZ3NQL1ppM3B3K1NIdFNpSzFxQXltSnpa?=
 =?utf-8?B?b0dZY2hUR3hoTnVSTHkyaTV6d3ZRZlhXLzlIRmxtT0tad0xKK0JXbmIrVU9L?=
 =?utf-8?B?cW8yZjBnQ0hvSDNKdFI2Vk1Vd3dvcExtN05ZWldTeHBKenRGNXFBZVlDbzh6?=
 =?utf-8?B?Mm5sWWhtcmo1dU5pUEpXQ3UyQnQyNEVCR3had0xMaFlTZENOdmRkazI5WlpM?=
 =?utf-8?B?d3o4T0h5NURVUy9KSUg3Z0VOTDFLSXV3NHh5MVBWdHhXaDB6Q1B1cm1ZditO?=
 =?utf-8?B?SHhHWngyQVdla3dXdlZZbS9jK1c2Y3Y5MlhheXBDdU1IdktkV3o5RXFURlFn?=
 =?utf-8?B?YWlTMFN6NHJQVHR5Y2xBUDF0YU93OUh5U2s5YlRFYzRncUtlMW1rSmNlQnhN?=
 =?utf-8?B?WDFYdnM3cjVaUTdNWi9MbnNpYTJTWjh4Q2JRMFB3OEJlMzF2aDZDc0F0NHE2?=
 =?utf-8?B?dzBhUWtFbFN5Y21Mc2xYellKak05OVUyT295b0xob05pQU9xOGQyWmpLOEZy?=
 =?utf-8?B?RnlHTWZpVEZEWndQcWdUUXBoVG9TTXUzNWNud2lPYTBHWXA1d1hMK25qUmJ6?=
 =?utf-8?B?T0lHc2Zjd2c0VlpSalQrNW9oNTJqc09JeUxSY0RUL0UzcFpDdW1zaTZDM2dp?=
 =?utf-8?B?TEp4WGxRQ1pML0IxOU5oNHoybWdTd0FoZE9qRnV3dDdUV2FhQWZ1UWsyRVlm?=
 =?utf-8?B?SjliZ000SGhqb0h2aWE3cng0KzBZSlFxTmhibE1xUVRBV1piRWVtUnplVU9T?=
 =?utf-8?B?bDhoT1B2N1RKLzJwMEZTMkhxMDNrSEtXVEtob2M0QzNhL3hFdnYrOHd5WUo1?=
 =?utf-8?B?c3pDN3M2Tm8zMUJFOHpaSHpzK2ZrSS96a0lueWZsYjRuOEdxZkVjY3RXZ2ow?=
 =?utf-8?B?Uy94Vk84SXdRdlVQbDZHaytCRlRTdXp6OUlTRmRmbDNJdEg3UnlmYjE0Unpu?=
 =?utf-8?B?c2JUWmlOQ3JheWxyRU41aEExVzhyYnhLVHNEVXJ2MEdETitlR09KdFJTcWZ1?=
 =?utf-8?B?OU9tRmZxYm1rWWhMcnJhZUtORVRzUERjQllMRFIwQTFEa1F2ZVNzWUwxWmg1?=
 =?utf-8?B?dmt0bXBhKzYyalRoQWNwanFIQ1U5UHNlT09RRDQ1SW5rZitGMUJPWEt3Q0R3?=
 =?utf-8?B?a0RZYlJZZFVnbVhDNFJlc0p2cVo1cjFWaDRxcVJwcW01YlZuOFdsZ3BENGx5?=
 =?utf-8?B?ams0cnlaanVYV1RPM1EvSk90MmRHeVpBaW1ocGNZUSs0OE5DdWZLOWdKbTlO?=
 =?utf-8?B?V2dWcVdmUVlEZEhRMXZzd1lMSitwd21sSGNSWndCUEVLZ015QzUyOVh4aTdo?=
 =?utf-8?B?UzJjNTFMTkNlVXdObHJMZndycm1YN2lRYXlveVJUNWNUb0kxdlRJUkl4Tjdz?=
 =?utf-8?B?VEpsTkZaNXNhbDFNU242WDJ1QVh6cGNaZDJxcnJ2c2VNVGhPSjJyOVlNcUph?=
 =?utf-8?B?aHFEWUcwdUpUZHRRYmNiR2NyazdkTUkyNGRxSWR3VnFLNjEzMXU5cjYvcmFL?=
 =?utf-8?B?WmZramI2OVNWVHFlV1BwQ2FJd2tuai9ZZ05IaTlxcFpFSVluQkNBZz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR02MB8560.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ea72a9d-4043-4f8a-2e77-08da423f5bf6
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2022 13:21:51.9423
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qym4xd3F1S1Fem9X89NjTr1hJqEnHLGdN0s4Ga4Qv5wQqX1F8cOEZm7ayR7FmTaUABc7Y5PTlzOnwqabHXTS0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6885
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBLcnp5c3p0b2YgS296bG93c2tp
IDxrcnp5c3p0b2Yua296bG93c2tpQGxpbmFyby5vcmc+DQo+IFNlbnQ6IFNhdHVyZGF5LCBNYXkg
MjEsIDIwMjIgOToxNCBQTQ0KPiBUbzogUmFkaGV5IFNoeWFtIFBhbmRleSA8cmFkaGV5LnNoeWFt
LnBhbmRleUBhbWQuY29tPjsNCj4gZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgZWR1bWF6ZXRAZ29vZ2xl
LmNvbTsga3ViYUBrZXJuZWwub3JnOw0KPiBwYWJlbmlAcmVkaGF0LmNvbTsgcm9iaCtkdEBrZXJu
ZWwub3JnOyBrcnp5c3p0b2Yua296bG93c2tpK2R0QGxpbmFyby5vcmc7DQo+IGhhcmluaS5rYXRh
a2FtQGFtZC5jb207IG1pY2hhbC5zaW1la0BhbWQuY29tDQo+IENjOiBuZXRkZXZAdmdlci5rZXJu
ZWwub3JnOyBkZXZpY2V0cmVlQHZnZXIua2VybmVsLm9yZzsgbGludXgtDQo+IGtlcm5lbEB2Z2Vy
Lmtlcm5lbC5vcmc7IGdpdEBhbWQuY29tDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHRd
IGR0LWJpbmRpbmdzOiBuZXQ6IHhpbGlueDogZG9jdW1lbnQgeGlsaW54IGVtYWNsaXRlDQo+IGRy
aXZlciBiaW5kaW5nDQo+IA0KPiANCj4gT24gMjAvMDUvMjAyMiAwOToyNCwgUmFkaGV5IFNoeWFt
IFBhbmRleSB3cm90ZToNCj4gPiBBZGQgYmFzaWMgZGVzY3JpcHRpb24gZm9yIHRoZSB4aWxpbngg
ZW1hY2xpdGUgZHJpdmVyIERUIGJpbmRpbmdzLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogUmFk
aGV5IFNoeWFtIFBhbmRleSA8cmFkaGV5LnNoeWFtLnBhbmRleUBhbWQuY29tPg0KPiA+IC0tLQ0K
PiA+IENoYW5nZXMgc2luY2UgUkZDOg0KPiA+IC0gQWRkIGV0aGVybmV0LWNvbnRyb2xsZXIgeWFt
bCByZWZlcmVuY2UuDQo+ID4gLSA0IHNwYWNlIGluZGVudCBmb3IgRFRTIGV4YW1wbGUuDQo+ID4g
LS0tDQo+ID4gIC4uLi9iaW5kaW5ncy9uZXQveGxueCxlbWFjbGl0ZS55YW1sICAgICAgICAgICB8
IDYzICsrKysrKysrKysrKysrKysrKysNCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDYzIGluc2VydGlv
bnMoKykNCj4gPiAgY3JlYXRlIG1vZGUgMTAwNjQ0DQo+IERvY3VtZW50YXRpb24vZGV2aWNldHJl
ZS9iaW5kaW5ncy9uZXQveGxueCxlbWFjbGl0ZS55YW1sDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEv
RG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC94bG54LGVtYWNsaXRlLnlhbWwN
Cj4gYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L3hsbngsZW1hY2xpdGUu
eWFtbA0KPiA+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0DQo+ID4gaW5kZXggMDAwMDAwMDAwMDAwLi42
MTA1MTIyYWQ1ODMNCj4gPiAtLS0gL2Rldi9udWxsDQo+ID4gKysrIGIvRG9jdW1lbnRhdGlvbi9k
ZXZpY2V0cmVlL2JpbmRpbmdzL25ldC94bG54LGVtYWNsaXRlLnlhbWwNCj4gPiBAQCAtMCwwICsx
LDYzIEBADQo+ID4gKyMgU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IChHUEwtMi4wLW9ubHkgT1Ig
QlNELTItQ2xhdXNlKQ0KPiA+ICslWUFNTCAxLjINCj4gPiArLS0tDQo+ID4gKyRpZDogaHR0cDov
L2RldmljZXRyZWUub3JnL3NjaGVtYXMvbmV0L3hsbngsZW1hY2xpdGUueWFtbCMNCj4gPiArJHNj
aGVtYTogaHR0cDovL2RldmljZXRyZWUub3JnL21ldGEtc2NoZW1hcy9jb3JlLnlhbWwjDQo+ID4g
Kw0KPiA+ICt0aXRsZTogWGlsaW54IEVtYWNsaXRlIEV0aGVybmV0IGNvbnRyb2xsZXINCj4gPiAr
DQo+ID4gK2FsbE9mOg0KPiA+ICsgIC0gJHJlZjogZXRoZXJuZXQtY29udHJvbGxlci55YW1sIw0K
PiANCj4gVGhpcyBnb2VzIGp1c3QgYmVmb3JlIHByb3BlcnRpZXMgKHNvIGFmdGVyIG1haW50YWlu
ZXJzKS4NCg0KT2sgLiBzdXJlIHdpbGwgZml4IGluIHYyLg0KPiANCj4gPiArDQo+ID4gK21haW50
YWluZXJzOg0KPiA+ICsgIC0gUmFkaGV5IFNoeWFtIFBhbmRleSA8cmFkaGV5LnNoeWFtLnBhbmRl
eUBhbWQuY29tPg0KPiA+ICsgIC0gSGFyaW5pIEthdGFrYW0gPGhhcmluaS5rYXRha2FtQGFtZC5j
b20+DQo+ID4gKw0KPiA+ICtwcm9wZXJ0aWVzOg0KPiA+ICsgIGNvbXBhdGlibGU6DQo+ID4gKyAg
ICBlbnVtOg0KPiA+ICsgICAgICAtIHhsbngsb3BiLWV0aGVybmV0bGl0ZS0xLjAxLmENCj4gPiAr
ICAgICAgLSB4bG54LG9wYi1ldGhlcm5ldGxpdGUtMS4wMS5iDQo+ID4gKyAgICAgIC0geGxueCx4
cHMtZXRoZXJuZXRsaXRlLTEuMDAuYQ0KPiA+ICsgICAgICAtIHhsbngseHBzLWV0aGVybmV0bGl0
ZS0yLjAwLmENCj4gPiArICAgICAgLSB4bG54LHhwcy1ldGhlcm5ldGxpdGUtMi4wMS5hDQo+ID4g
KyAgICAgIC0geGxueCx4cHMtZXRoZXJuZXRsaXRlLTMuMDAuYQ0KPiA+ICsNCj4gPiArICByZWc6
DQo+ID4gKyAgICBtYXhJdGVtczogMQ0KPiA+ICsNCj4gPiArICBpbnRlcnJ1cHRzOg0KPiA+ICsg
ICAgbWF4SXRlbXM6IDENCj4gPiArDQo+ID4gKyAgcGh5LWhhbmRsZTogdHJ1ZQ0KPiA+ICsNCj4g
PiArICBsb2NhbC1tYWMtYWRkcmVzczogdHJ1ZQ0KPiA+ICsNCj4gPiArICB4bG54LHR4LXBpbmct
cG9uZzoNCj4gPiArICAgIHR5cGU6IGJvb2xlYW4NCj4gPiArICAgIGRlc2NyaXB0aW9uOiBoYXJk
d2FyZSBzdXBwb3J0cyB0eCBwaW5nIHBvbmcgYnVmZmVyLg0KPiA+ICsNCj4gPiArICB4bG54LHJ4
LXBpbmctcG9uZzoNCj4gPiArICAgIHR5cGU6IGJvb2xlYW4NCj4gPiArICAgIGRlc2NyaXB0aW9u
OiBoYXJkd2FyZSBzdXBwb3J0cyByeCBwaW5nIHBvbmcgYnVmZmVyLg0KPiA+ICsNCj4gPiArcmVx
dWlyZWQ6DQo+ID4gKyAgLSBjb21wYXRpYmxlDQo+ID4gKyAgLSByZWcNCj4gPiArICAtIGludGVy
cnVwdHMNCj4gPiArICAtIHBoeS1oYW5kbGUNCj4gPiArDQo+ID4gK2FkZGl0aW9uYWxQcm9wZXJ0
aWVzOiBmYWxzZQ0KPiA+ICsNCj4gPiArZXhhbXBsZXM6DQo+ID4gKyAgLSB8DQo+ID4gKyAgICBh
eGlfZXRoZXJuZXRsaXRlXzE6IGV0aGVybmV0QDQwZTAwMDAwIHsNCj4gPiArICAgICAgICBjb21w
YXRpYmxlID0gInhsbngseHBzLWV0aGVybmV0bGl0ZS0zLjAwLmEiOw0KPiA+ICsgICAgICAgIGlu
dGVycnVwdC1wYXJlbnQgPSA8JmF4aV9pbnRjXzE+Ow0KPiA+ICsgICAgICAgIGludGVycnVwdHMg
PSA8MSAwPjsNCj4gDQo+IElzICIwIiBhbiBpbnRlcnJ1cHQgbm9uZSB0eXBlPyBJZiB5ZXMsIHRo
ZW4gdGhpcyBzaG91bGQgYmUgcmF0aGVyIGENCj4gZGVmaW5lIGFuZCBhIHByb3BlciB0eXBlLCBu
b3Qgbm9uZS4NCg0KSSBsb29rZWQgYXQgYXhpIGludGMgZHJpdmVyIGFuZCBpdCBzZWVtcyBzZWNv
bmQgY2VsbCBpbiB1bnVzZWQgaGVyZS4NCkZvciBpbnRlcnJ1cHQgdHlwZSBsZXZlbC9lZGdlICwg
aW50ZXJydXB0IGNvbnRyb2xsZXIgaGFzIHNlcGFyYXRlDQpiaW5kaW5nICJ4bG54LGtpbmQtb2Yt
aW50ciIuICBTbyB3aWxsIHJlbW92ZSB0aGUgdW51c2VkIGNlbGwuDQorICAgICAgICBpbnRlcnJ1
cHRzID0gPDE+Ow0KDQo+IA0KPiA+ICsgICAgICAgIGxvY2FsLW1hYy1hZGRyZXNzID0gWzAwIDBh
IDM1IDAwIDAwIDAwXTsNCj4gDQo+IEVhY2ggZGV2aWNlIHNob3VsZCBnZXQgaXQncyBvd24gTUFD
IGFkZHJlc3MsIHJpZ2h0PyBJIHVuZGVyc3RhbmQgeW91DQo+IGxlYXZlIGl0IGZvciBib290bG9h
ZGVyLCB0aGVuIGp1c3QgZmlsbCBpdCB3aXRoIDAuDQoNClRoZSBlbWFjbGl0ZSBkcml2ZXIgdXNl
cyBvZl9nZXRfZXRoZGV2X2FkZHJlc3MoKSB0byBnZXQgbWFjIGZyb20gRFQuDQppLmUgICdsb2Nh
bC1tYWMtYWRkcmVzcycgaWYgcHJlc2VudCBpbiBEVCBpdCB3aWxsIGJlIHJlYWQgYW5kIHRoaXMg
TUFDIA0KYWRkcmVzcyBpcyBwcm9ncmFtbWVkIGluIHRoZSBNQUMgY29yZS4gU28gSSB0aGluayBp
dCdzIG9rIHRvIGhhdmUgYSANCnVzZXIgZGVmaW5lZCBtYWMtYWRkcmVzcyAoaW5zdGVhZCBvZiAw
cykgaGVyZSBpbiBEVCBleGFtcGxlPw0KIA0KPiANCj4gPiArICAgICAgICBwaHktaGFuZGxlID0g
PCZwaHkwPjsNCj4gPiArICAgICAgICByZWcgPSA8MHg0MGUwMDAwMCAweDEwMDAwPjsNCj4gDQo+
IFB1dCB0aGUgcmVnIGFmdGVyIGNvbXBhdGlibGUgaW4gRFRTIGNvZGUuDQoNCk9rLCBzdXJlIHdp
bGwgZml4IGl0IGluIHYyLg0KPiANCj4gPiArICAgICAgICB4bG54LHJ4LXBpbmctcG9uZzsNCj4g
PiArICAgICAgICB4bG54LHR4LXBpbmctcG9uZzsNCj4gPiArICAgIH07DQo+IA0KPiANCj4gQmVz
dCByZWdhcmRzLA0KPiBLcnp5c3p0b2YNCg==
