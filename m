Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7534D886D
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 16:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236401AbiCNPqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 11:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231308AbiCNPqp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 11:46:45 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60073.outbound.protection.outlook.com [40.107.6.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C197C3D48E
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 08:45:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EdoPApo449A9f15hY6mkuljPUbnGXtOqDiM/XaojQYge8e/d7+EZQmpYGptcnl2DUMagLsoeY/kKZlsqlqotioxBik7k8UlybPv+wCYfgm7kNmSTeMPwVY9T3R9CbmU+FjEbc50CRujng5VslFCV14SgI+wV2c9dDpefCN07Zx8U4iwF4NugrdHjFLJl4GKeYyDhaavAoVImUd0bc/8WxRB0XW6B68gQz95EaTbC0omNoc6rVuU5NHpWhu04VqzRhrQ6+VSBW2clqaKJMyDOUJqu3oDZvNJXY2q5ZgDcFSdN4plAVxIhWdIcluNT/mWrhPkuOGqPFBD9wHiRwyCL4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g1kvQ38yC5Vr8Isxy+zaI3+LgdcrN/g2H2yFv/Cgy1Y=;
 b=O01TWTnKa2+QWJccLwW2+KlJKvbYZdApjc+GSDPFqHVYB0twe7ndli92HvRsjOVBJgM3aHc4IdLPOb0xf0+T+WjrPug4m5f26VpptF6uOyPi5Tyec63dAesSimRR5tdkDNJvgW6YPaTMPWbtrEGK7sf6lH3Ip57r2ZCiPmUuNYEz+caePGzLcUTJfTHXkgO70GeHPLgeOPDY9V0M2aDAHI56E7lvPx+Q/YVTp2zKWlmqW0uJO48mDkgSfu4U5XiPpjVX7F3L5SaYR8GlJLkhJBynbY9j48i5X3oeNQ8pKiW5yretAP+nHVrQwy6g4IQ8t0/x+jqFhA4l1vaarJmuaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g1kvQ38yC5Vr8Isxy+zaI3+LgdcrN/g2H2yFv/Cgy1Y=;
 b=aMXxDStJGAzNXg8e4EFmOczL6F53iLM+wFnIjp79SX92IoMq2DVnT2szv4p+z7sRQ4KVbP6UI3mumQAvCM1r0gEd2u9X9D9Ym/Qq9vWIBnuAbZw8iE9LAxdKYPGcUkE5Op+adjhQI0iWDrLzzu3o6N0L9kwrUziF5kZAdHk4wD4=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB5531.eurprd04.prod.outlook.com (2603:10a6:10:90::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.26; Mon, 14 Mar
 2022 15:45:33 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%5]) with mapi id 15.20.5061.026; Mon, 14 Mar 2022
 15:45:33 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     =?utf-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>
CC:     Tobias Waldekranz <tobias@waldekranz.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        =?utf-8?B?SmFuIELEm3TDrWs=?= <hagrid@svine.us>
Subject: Re: [PATCH net] net: dsa: fix panic when port leaves a bridge
Thread-Topic: [PATCH net] net: dsa: fix panic when port leaves a bridge
Thread-Index: AQHYN7j4R52Ve+kGyEmg11EfqSyjH6y/BaKA
Date:   Mon, 14 Mar 2022 15:45:33 +0000
Message-ID: <20220314154533.blqbjpqvh2apxycz@skbuf>
References: <20220314153410.31744-1-kabel@kernel.org>
In-Reply-To: <20220314153410.31744-1-kabel@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 60f857e6-47b1-4db8-e878-08da05d1ad11
x-ms-traffictypediagnostic: DB7PR04MB5531:EE_
x-microsoft-antispam-prvs: <DB7PR04MB5531E981FDAD2286AA6BBEA7E00F9@DB7PR04MB5531.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vfg8DYx+V33zO4bQwxUB/hl8xJqjuDXDufVzjAoLxooPFM4UB6hkHpWKGPPpY6tleZzkG38Yu8d54P+6afIEukUJzu6MV28XN2V144GMZ/Q3Z1hZcZo/rN/RlByyXOapB3J6XosHn2jFNImeMh6fj0VPsptFvG+DPf9WQQK+14Nj59/ZZl+lB5QIHNdSarTMB/spB/+nrzXvyFn0qGQiRmj/QrydtWWD1vFUElmUJnnlIHIUVzi9bWR/2u/VEzfAQXIsUrVY8iKm9z0XkCJvzOKnLK6w8YmxsRdqWDlRSEww9qHbB+/iYSay2N3wOZbPoebsLjnvk30qaRC/JY2Ut85D6md4FS9FhukgaTERA+doHx6+cOpd0oxpvC1F+eE84shlcTOb4V6Na4lotLAGj4XfYLZt6erwmkqxfbLLuEEz9PqxO1GdCglx4NJ1klTBkzdYDjE0mYUAUAoTBXMV0nXf0VAuXXwpGm2n/F7SorIzUE048g6vKJjVu6o52YrerTOo+1Mv0WA+ooeFTY8Nv83MycBIgU/xMyGEvDtfA+qmoOkD8vj5p5+KvKvML69rw3A3YKguexkS8FC8tC2KkxEqA1OVXiI3S9NY0POP06QN2kT47ITbbiofHgZJK37z6HBQlX87As/uCRf3EBwa/icN+G5EZBAzVm5KrCk6kvyTFvTI55SJ8gJDIy2JbQDSs/GVQhOHwZicnn0+C/L1ylnUE0e0cZBxvnvTFC8R9sZRUyXWOk4ssI6CkmN31ef9QWQho+qPpo4CWrKMveCaY5bF1qulOL9Z18f9uvjdMofdN7y1laqzNVMDpA6xRfFKI42jJkS1Y1g0xvE0VDbXZw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(966005)(71200400001)(8936002)(33716001)(6486002)(44832011)(508600001)(1076003)(2906002)(186003)(38070700005)(66556008)(26005)(4326008)(38100700002)(76116006)(122000001)(8676002)(66446008)(64756008)(66476007)(86362001)(66946007)(6916009)(316002)(9686003)(5660300002)(6506007)(6512007)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bGFIV3ZyVGtDU1dETjh4czV4b2dOK0x0dUJIVXNUUVVnYkxaVHFMaWdQcU9E?=
 =?utf-8?B?Q3VFZ0V2K2lEL2poOW9ISU1qNTg3ejlTOVN3UElvdjlxMEpJZGcvS29zWW9D?=
 =?utf-8?B?bzBSWXh0dnE2S21DSXdnTFg2VzBNT3hPanF1RlQ3TXNjS0pDWEcvZmZQTXVN?=
 =?utf-8?B?MUlRT3RvUEJOTFphcHNIc3F6My8wUjZ2eU1xckpWUGFCRlo3Tk5TRGpPblZJ?=
 =?utf-8?B?TGZ3THdoVVBTWjI2RmZPUEg0WkxJOVlCUkQxeGZKTy9yTXVMaHJiQUNLT2NW?=
 =?utf-8?B?TWZKSHlpSmxNVS8xSXFmTXNvdUxLUDdxeFJ2U21XTXdQT2JVRmIyTDQwQ01n?=
 =?utf-8?B?TzBYZlphVEVyWTR6dU5VdkdUcThrRkU4MzZ1SEE2aXhkYzF3M2NHbi92UUc3?=
 =?utf-8?B?bmVrYUlIT1B1SFFHUFQ2dmtoM0JWbVZ5Tlhib2RBckpDd1ZCWTdjNEpHdkxi?=
 =?utf-8?B?bjVuTGR2N2tOV2NuT3Vyb21YUXlDR2FYbC9pNTZhTmdoTTV2bnJ1UHNQZUI3?=
 =?utf-8?B?RUk4akZoSG1KbDRicSsrczBGN2Fxbzl1VlU2SmpUdi9MVnBiV3RBRmpzcWFG?=
 =?utf-8?B?akpsUUJ3WG1HS0ZJZnNZUmt3YlFvUGFyd1JtMlJ2dXNkMU0vMlNzam5kellD?=
 =?utf-8?B?dzFhKzI4YSt2RTlyYlhPZHdaZW9qSmUwRUlHWld1a1A5QTA4ZnBHdDlldy9N?=
 =?utf-8?B?TnR0b05oUFlDaGpBVzVuOXZ6aHdUYm1LbEdjN2dGNFdjSTlIWkxkUHgxdnFQ?=
 =?utf-8?B?L2Q0R0VUR2t4T1lEdHJSd1diVFYzTGxOYkNiYUNQQ256eFpXcVpkamc5MlBD?=
 =?utf-8?B?THVZYlpHYStLV2VNVmhHRmRSWmN5QXUycm5VOFZrTTJmZ2p5dlVmY0Y3UVFi?=
 =?utf-8?B?dVhqSnJkdHVRL1JPQzNiSUZUQi9VK2JtRDVwbFBETS9DMFlOZ3FPTFFVYlBn?=
 =?utf-8?B?bnh0SElDekMyU29udDhQakdJRlc0L3VVTFRNeVZBWWEvWEtDS3JmSHkxSWJh?=
 =?utf-8?B?Wm02RzZ3eWZ0elR3WSs2eGxzblBxMDFqbDFvdlVZVG5Hcmh0UWlCTXBKYVM2?=
 =?utf-8?B?RXEwSDhIcCs1VzlQK1ZkL2UrVXFMd2g5R3kxK3NGeWYxdjlndlNtcXJwWS9K?=
 =?utf-8?B?eE5aUyt3OTBSS3FvUmhibTlQOXNSZWlJQzRneTEvU21tYkpoM1FnanhIQi9r?=
 =?utf-8?B?Z0c5NGhHck1ja1F5UUM2WlhSNDljVHorU1JHRGtoWXhsZk9vVDJ0ZTZVdVM1?=
 =?utf-8?B?TDR3WHBzRHowMmZPQ2xna3Bvd1loakFQK2JGZjYySGhGRnVVL3RSTXRJMndR?=
 =?utf-8?B?ajMwRElvakRaaDYzL2hhdnI2UnA0L3k4TjJYZFlhak1acDE4UmhOWUxQS1Bo?=
 =?utf-8?B?K1JLaFkzN0pYK3lhYUIyejBwWGxIY25LdjVWNXRhLzAyRS9FUEVMZ1JDbVJM?=
 =?utf-8?B?RHQrcFFCcE1QYWJReXpEdHNqUm15bi9OZkNmMDZWMWxOU1FFV0x0ZlhOM05o?=
 =?utf-8?B?YkRnMVd0b1JYRXVCSHVhdktMTjR1dkxhd2Y4TDNPZUUwdTZhOFdKTWptNDVr?=
 =?utf-8?B?YlF4N2hBR044NmRVWTRHQUNwdG5CVEYxM2NEMVFzcFVCTjRVbDBwVFZ3VFBD?=
 =?utf-8?B?c1dlVDI3Z1FUZzZWeTRPS1hSandpRGlkRUh1OFRUK0pvRWpnamI5MVA0MDN4?=
 =?utf-8?B?VjYyMVV6bEZNYWZZWWdGUHUyYmxNK29IRjMybThZbURRVzFDREI1R1dDc2J6?=
 =?utf-8?B?d2h6SkpONmlsRVF3aWE3eUpzSnM2OEZyTnlIY29RUnV6Sk0vNUdyNU9hSXo4?=
 =?utf-8?B?ZEh3aElKeTI5N0E4bTgrVUs0RmZtRzFpSHhNMjdBazNlZU1YTXRVc3NsWXhP?=
 =?utf-8?B?S3M5UFFNd2syUFFhY09UVE1QeFMva3ZvWnhxUUJLMnI5d2xYUytxUjNMUTJz?=
 =?utf-8?B?a2VWOVprYldQSk56TFJ4NmZFeDloSUZrZlFnYlBhOGkxcmMwemVUR3lIclMx?=
 =?utf-8?B?UEJrTE1aZFFBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B30206E484E58047BF7F790F4CCCD695@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60f857e6-47b1-4db8-e878-08da05d1ad11
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2022 15:45:33.5813
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: StW8Z53IWbvs5RLhSNhCSt69kohmM03Td5sthw7kn8mZhVlYUg7c9mOxQhZzme0LwIqr6vf2yanskWwTZjF+BA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5531
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCBNYXIgMTQsIDIwMjIgYXQgMDQ6MzQ6MTBQTSArMDEwMCwgTWFyZWsgQmVow7puIHdy
b3RlOg0KPiBGaXggYSBkYXRhIHN0cnVjdHVyZSBicmVha2luZyAvIE5VTEwtcG9pbnRlciBkZXJl
ZmVyZW5jZSBpbg0KPiBkc2Ffc3dpdGNoX2JyaWRnZV9sZWF2ZSgpLg0KPiANCj4gV2hlbiBhIERT
QSBwb3J0IGxlYXZlcyBhIGJyaWRnZSwgZHNhX3N3aXRjaF9icmlkZ2VfbGVhdmUoKSBpcyBjYWxs
ZWQgYnkNCj4gbm90aWZpZXIgZm9yIGV2ZXJ5IERTQSBzd2l0Y2ggdGhhdCBjb250YWlucyBwb3J0
cyB0aGF0IGFyZSBpbiB0aGUNCj4gYnJpZGdlLg0KPiANCj4gQnV0IHRoZSBwYXJ0IG9mIHRoZSBj
b2RlIHRoYXQgdW5zZXRzIHZsYW5fZmlsdGVyaW5nIGV4cGVjdHMgdGhhdCB0aGUgZHMNCj4gYXJn
dW1lbnQgcmVmZXJzIHRvIHRoZSBzYW1lIHN3aXRjaCB0aGF0IGNvbnRhaW5zIHRoZSBsZWF2aW5n
IHBvcnQuDQo+IA0KPiBUaGlzIGxlYWRzIHRvIHZhcmlvdXMgcHJvYmxlbXMsIGluY2x1ZGluZyBh
IE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZSwNCj4gd2hpY2ggd2FzIG9ic2VydmVkIG9uIFR1cnJp
cyBNT1ggd2l0aCAyIHN3aXRjaGVzIChvbmUgd2l0aCA4IHVzZXIgcG9ydHMNCj4gYW5kIGFub3Ro
ZXIgd2l0aCA0IHVzZXIgcG9ydHMpLg0KPiANCj4gVGh1cyB3ZSBuZWVkIHRvIG1vdmUgdGhlIHZs
YW5fZmlsdGVyaW5nIGNoYW5nZSBjb2RlIHRvIHRoZSBub24tY3Jvc3NjaGlwDQo+IGJyYW5jaC4N
Cj4gDQo+IEZpeGVzOiBkMzcxYjdjOTJkMTkwICgibmV0OiBkc2E6IFVuc2V0IHZsYW5fZmlsdGVy
aW5nIHdoZW4gcG9ydHMgbGVhdmUgdGhlIGJyaWRnZSIpDQo+IFJlcG9ydGVkLWJ5OiBKYW4gQsSb
dMOtayA8aGFncmlkQHN2aW5lLnVzPg0KPiBTaWduZWQtb2ZmLWJ5OiBNYXJlayBCZWjDum4gPGth
YmVsQGtlcm5lbC5vcmc+DQo+IC0tLQ0KDQpBaCwgd2FpdCBhIG1pbnV0ZSwgeW91J3JlIG1pc3Np
bmcgVG9iaWFzJyBwYXRjaA0KaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tl
cm5lbC9naXQvbmV0ZGV2L25ldC1uZXh0LmdpdC9jb21taXQvP2lkPTEwOGRjODc0MWMyMDNlOWQ2
Y2U0ZTk3MzM2N2YxYmFjMjBjNzE5MmINCg0KV2hhdCBoYXBwZW5lZCBpcyB0aGF0IGl0IHdhcyBh
cHBsaWVkIHRvICJuZXQtbmV4dCIgaW5zdGVhZCBvZiAibmV0IiwNCmRlc3BpdGUgYmVpbmcgY29y
cmVjdGx5IHRhcmdldGVkLg0KaHR0cHM6Ly9wYXRjaHdvcmsua2VybmVsLm9yZy9wcm9qZWN0L25l
dGRldmJwZi9wYXRjaC8yMDIyMDEyNDIxMDk0NC4zNzQ5MjM1LTMtdG9iaWFzQHdhbGRla3Jhbnou
Y29tLw0KSG1tbS4uLg==
