Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB4C4FE381
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 16:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356466AbiDLOQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 10:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235000AbiDLOQL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 10:16:11 -0400
Received: from IND01-BMX-obe.outbound.protection.outlook.com (mail-bmxind01olkn2049.outbound.protection.outlook.com [40.92.103.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CAB31D0C1;
        Tue, 12 Apr 2022 07:13:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gCv626nvb2GiE+oyaoPTlACpePCd/2Js++AWZttJHKBbSu2vVT/NJFiFBPU1OBmU2vAYzz+EnOLLNTe8i6GYkZicsJ2p66BfpejLmAyuW+DWlETxctHvkPVJ8X10YPwH5dVvKPmTtlG6jxr+KTdeQWaUw8WICZtr7jOSEp1lacnJW91Riu1tHbPT7GCa5R42HDIT+E8X8hQAe9gW31FmONJFeWUNHWz+HcQQ8NzZDUReEet/OzeRfj416fVucnhn7WCrZWHLCTyJZ1X6RT73PhzumNec1Lug1ondAzalvWS0gFZoSoKe+KROnmorqU74e4wogcgafRgdHGG7TwlDTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XzyPU+JwXJgz0a6lU+48LRH2oXOzMbRezdzu9PTNWJU=;
 b=GBq9kS+Z25dVMQ7U7nJ0A8U2PFPy00LFsjyX3HqW9RzX+FyX0rUel+bMZwBHmsjitNuPrlneDHvYmmherXNkYO0hDvN3A+8GQbtpBil8EV6G1QuVISUB4ZgToKyLBtV9s6wH60dVxKmN2u4wDCd0drRCPeUub0seMbeKgVLfXu21K5FrO8kicpfyc3EQ9x8K/K2tuevI281vBb4rWfId/TkCXs1CWc/oflf/IRAYF2LM4/OIHy2UW+NELFgIIqNMeq2N/PFc9arFHzaRkDiXTb5sEgjfUrZnbEOBDnEXFvuv65AFjGG+JFx/Lm1c8uy93+Neybb2wH8LE98N8126zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XzyPU+JwXJgz0a6lU+48LRH2oXOzMbRezdzu9PTNWJU=;
 b=r+q3qkV3Qkh0uLgd+B2Ahq5lTIJhgF8KojWywMj86UqP+sax0KLhnpMPt3t7V1PpGG74AsVsIwRDdqbEXc25jbdlDbAB6pdin5cvbfRdljeFx2ef4i8wq4wxhJJ6fqitFvLIcsb9d00DsB5EEolOcUGc7p+cPzZbPSzTV1DhFXCR1MQWguVkjscB+3cHPpMn/SCg7tlSCg+Bo6KMU6abYVpDGiw/6kZVx+ySmf24RpsARaoEiCdHG68mR20Eh061ahkS20OYNvxfJmsvlDBPdqiEaXhD3YRLJbwKLDc1wWLh+wzNILzZXDm2MIadUVoJVv5QLXeExB3SSQgVZkGHWw==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by MA1PR0101MB1782.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:2d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 14:13:44 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::dc4b:b757:214c:22cd]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::dc4b:b757:214c:22cd%7]) with mapi id 15.20.5144.030; Tue, 12 Apr 2022
 14:13:44 +0000
From:   Aditya Garg <gargaditya08@live.com>
To:     Mimi Zohar <zohar@linux.ibm.com>
CC:     "jarkko@kernel.org" <jarkko@kernel.org>,
        "dmitry.kasatkin@gmail.com" <dmitry.kasatkin@gmail.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "serge@hallyn.com" <serge@hallyn.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Orlando Chamberlain <redecorating@protonmail.com>,
        "admin@kodeit.net" <admin@kodeit.net>
Subject: Re: [PATCH v3 RESEND] efi: Do not import certificates from UEFI
 Secure Boot for T2 Macs
Thread-Topic: [PATCH v3 RESEND] efi: Do not import certificates from UEFI
 Secure Boot for T2 Macs
Thread-Index: AQHYTMiulSPMjZZGmkKiAUWUNy3DFqzsOTYAgAAcO4A=
Date:   Tue, 12 Apr 2022 14:13:44 +0000
Message-ID: <B857EF0F-23D7-4B82-8A1E-7480C19C9AC5@live.com>
References: <652C3E9E-CB97-4C70-A961-74AF8AEF9E39@live.com>
 <f55551188f2a17a7a5da54ea4a38bfbae938a62f.camel@linux.ibm.com>
In-Reply-To: <f55551188f2a17a7a5da54ea4a38bfbae938a62f.camel@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [GiODMBp9O7Lp8HEbW4buWPFcp98S1iv2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fb167169-a42d-42dc-3ad5-08da1c8ea796
x-ms-traffictypediagnostic: MA1PR0101MB1782:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TeI6cd6QnuB1vCyL2DqeoASALVOvbwnRaTjIZuHevoQGWNFIgRqGgXjDP/bXoF30x7pFuJv4YaDXnljF8+50URLal0tu9I5Rd3C97hUBzMo1CGCvjxt6H21vd5ddqFhaqERc8I4yv5jnICL9WI1OcZFY1/q98xE6y7hi+qwXAQO4hiA65mBtQNNsAB1ByEcItn1DUTiVubm13L8z69FQIh+YLwffLK+XRrFETNARw37kjoMi3YD9Mdl3MVw0tMHHS/HGex0Yhljyd7Olz8gcEbfvCWpIC0kjYTgc1g9u7k/+g8CMTvrPxcV7+2s6jBar7uViOnUFKtafgolJu+vjUpR0TN6ikqtEtr1ouf6auyQtKptbG14bhykPE76BX8D3h6OPrb/IeXf1XhMdS1ZUz9hVvY7l31cOtLFYd0HxFir49E9ctFqJCAIF9ImGLAW7guWAUCf+oX319v5EjPaPRRv421UovKXbLgVeudXzAmmopvzfYCJlW9rUUDC2PPbHBSUq39sXuhNa6bCNFJ03IGzqhSYNotgUfW1zu3Zie6FnTcP0arzWXv9ba/Bd7Ky77QkBHVcx7Z2KBs9RZ/XqDw==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dndzSUd2b3IrcEZBMSt3ZFZPZE40ckZpSFdYYmZmdzkyQ2hSRnFiZEJ0NEdU?=
 =?utf-8?B?cXNkQ01QcUdYanJIelpQY0hyNHh4NGNCS01VczZ1MnRXNkhSUFdHcC9KVW02?=
 =?utf-8?B?Vm1RTzFwTTNlNndVL3dteHpPQU1aUXo1cysreHl6SkRlQ2E2YTlYVVIvSk1Y?=
 =?utf-8?B?NkJzc0krcmxsNzRxUklEK2NCVDE4cGh3M1k1blRyemFIMVNSYm1yUXJpMGd0?=
 =?utf-8?B?OE1ySDlDbVc4RGRjRSsxOVNMSVBKVE8zZS95ZnRvR0tLNTl2a0R3bFJqOEZy?=
 =?utf-8?B?eHQvcDAvUWg0Z3RvanpMczhDM2xuMFAvaE1tMUVtcHl2ZVoySlJyODJvc1Ny?=
 =?utf-8?B?cy9QUkpEY20wVUNhUUswWHJhZ2FrOHVoL3E0Z2JxV2JUMjYwS0h2WVdpWU9l?=
 =?utf-8?B?MGZwVjlEZU12UFdvRkg2aE9vWlZyY0Q1NlFCM05oR2dDUVJKQmlkTmlGc0Vy?=
 =?utf-8?B?ZWNBM2V5SFRJTDRhc05OVTc1bXhGYXliTDhoYlo1YkNLS2xJbzFTVEh4MDVP?=
 =?utf-8?B?OXU4MFc3N2RrRzN3YTBPcHdoRElDZ3Vsc29Pck52a1FPVXZTNnRNWkJWbHZ0?=
 =?utf-8?B?TUozalpWYmZ2UDNvVE1VbTNDOXlVdDBKVHg3RzFYY1NuZVlXZDIrMXlzTUo2?=
 =?utf-8?B?SXYvVndWVCtMRDdma1J0VVVXVjA0NmViSkk5MmxVSEx0MUNLMmdUSzErbFVK?=
 =?utf-8?B?QXdpTXpnYVd0czlmQ2k1Ty96SG1adWEvYzhJZXIydS9FUXhYc1lPem1CWm5H?=
 =?utf-8?B?aXdOKzI1ck5WdGRGSjVFdUttWERkTDBldVQxUWxPM2JTejlLSmloUmsyZ003?=
 =?utf-8?B?ZjcvUGh1aFFJRHdnc3psSnNlMmVNb3dDazAzZ2JsbzdQS25WaHNtWFA3dEgr?=
 =?utf-8?B?NkFEYVc0WmlRR0l5L0ZCWC9xczJ0b3cxaVZwcjlacCtEUVlMMEl4KytPOHBP?=
 =?utf-8?B?Yy9WS0ZJeGNyaFk4MDl6d1grRXdFT0pYTHVGQmlnUkt6aUFkTC91ZkVlVE5X?=
 =?utf-8?B?THQzSWxMcGpCQXYrYXVubHlSaDJWbTdYQzdKays5UGExaEpEMXpjQWFGRVlB?=
 =?utf-8?B?ZzFscXJEaGRjQWRuaDcvNXlKQkI1RWJDY2I5SEhCSEw3TWVRY21sV3ZNR2wz?=
 =?utf-8?B?TVRDNmNSdm90c3oyWW90UlhlcW10TjZMQk9Rd0cvQzd6UFllS0w0b3I0UTNQ?=
 =?utf-8?B?RVRBVjlodCtKNXpEbmdEdTByZ250ZlpEVHJldVpSeWt6anp3dDhBZ3U5U0Vh?=
 =?utf-8?B?OHBycEhOQnRpRkQyTUdzMThkNGJiSFh3VktrU0JwSTA5QjVqcW1OQ1Q2TFI4?=
 =?utf-8?B?SG94M0xScmFhK2ZOM1hBS2VYaU9OUE5RMlJjNFc3U2VPQ2M0c1c0QXgvV3ZH?=
 =?utf-8?B?L0lyNEZ4V01FUUVLeG5VL0ZpNkFkUGM4dytYT3FGSHA2TXNHcnVZWC9hbUlH?=
 =?utf-8?B?cUNzWit2WStVb21PQ2pNKzNFU2g4TlA4NE1ieDllQlIrRThFY2l0N09waUZ1?=
 =?utf-8?B?c1ZCWXFja1FKa1crcjdMNU4vdE9DakJ6ZWtxRmhzZDlISnVIUEFLbzA5dTRW?=
 =?utf-8?B?Zy9UVHJRSjhtMHVLY05SYWtBdWxlMFRFUnlyY2lvcThQbGZndU83N2RiUXI1?=
 =?utf-8?B?T3J6dXNFWEFkNTkwdzczRnN5NW9MdDRhVTBGdVI3WnFSbDhrRkhiMHIyeW9k?=
 =?utf-8?B?czNFU3VrOU5NdUF1VjlieE45MjJzMzNhN0RYTW8wRHFIcUxOejNHTUZXTXI4?=
 =?utf-8?B?UGZhS09OZENnMFg5V3I5V3ZmNjR2cktmZlM3RjkxZE5lajlwQTZkekxsNTVq?=
 =?utf-8?B?OWRsRy8wcjRuZm9GMDMxeE5IU0wyamNWN3RsWVU5TngxS3JnSnV6cXNOLzVy?=
 =?utf-8?B?MGQwaHJzLzRDajNCelh0OGlid3hsdDhxbGd3amxtS1lxeERwMVR1MUc5Smhm?=
 =?utf-8?Q?gW9fI3Ek6nU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B84710D247CFD347A0EC66CF4615AFB1@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: fb167169-a42d-42dc-3ad5-08da1c8ea796
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2022 14:13:44.8452
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MA1PR0101MB1782
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gMTItQXByLTIwMjIsIGF0IDY6MDIgUE0sIE1pbWkgWm9oYXIgPHpvaGFyQGxpbnV4
LmlibS5jb20+IHdyb3RlOg0KPiANCj4gT24gU3VuLCAyMDIyLTA0LTEwIGF0IDEwOjQ5ICswMDAw
LCBBZGl0eWEgR2FyZyB3cm90ZToNCj4+IEZyb206IEFkaXR5YSBHYXJnIDxnYXJnYWRpdHlhMDhA
bGl2ZS5jb20+DQo+PiANCj4+IE9uIFQyIE1hY3MsIHRoZSBzZWN1cmUgYm9vdCBpcyBoYW5kbGVk
IGJ5IHRoZSBUMiBDaGlwLiBJZiBlbmFibGVkLCBvbmx5DQo+PiBtYWNPUyBhbmQgV2luZG93cyBh
cmUgYWxsb3dlZCB0byBib290IG9uIHRoZXNlIG1hY2hpbmVzLiBUaHVzIHdlIG5lZWQgdG8NCj4+
IGRpc2FibGUgc2VjdXJlIGJvb3QgZm9yIExpbnV4Lg0KPiANCj4gVGhlIGVuZCByZXN1bHQgbWln
aHQgYmUgImRpc2FibGUgc2VjdXJlIGJvb3QgZm9yIExpbnV4IiwgYnV0IHRoYXQgaXNuJ3QNCj4g
d2hhdCB0aGUgY29kZSBpcyBhY3R1YWxseSBkb2luZy4gQXMgYSByZXN1bHQgb2Ygbm90IGJlaW5n
IGFibGUgdG8gcmVhZA0KPiBvciBsb2FkIGNlcnRpZmljYXRlcywgc2VjdXJlIGJvb3QgY2Fubm90
IGJlIGVuYWJsZWQuIFBsZWFzZSBiZSBtb3JlDQo+IHByZWNpc2UuDQpJ4oCZbGwgZml4IHRoaXMN
Cj4gDQo+PiBJZiB3ZSBib290IGludG8gTGludXggYWZ0ZXIgZGlzYWJsaW5nDQo+PiBzZWN1cmUg
Ym9vdCwgaWYgQ09ORklHX0xPQURfVUVGSV9LRVlTIGlzIGVuYWJsZWQsIEVGSSBSdW50aW1lIHNl
cnZpY2VzDQo+PiBmYWlsIHRvIHN0YXJ0LCB3aXRoIHRoZSBmb2xsb3dpbmcgbG9ncyBpbiBkbWVz
Zw0KPj4gDQo+PiBDYWxsIFRyYWNlOg0KPj4gPFRBU0s+DQo+PiBwYWdlX2ZhdWx0X29vcHMrMHg0
Zi8weDJjMA0KPj4gPyBzZWFyY2hfYnBmX2V4dGFibGVzKzB4NmIvMHg4MA0KPj4gPyBzZWFyY2hf
bW9kdWxlX2V4dGFibGVzKzB4NTAvMHg4MA0KPj4gPyBzZWFyY2hfZXhjZXB0aW9uX3RhYmxlcysw
eDViLzB4NjANCj4+IGtlcm5lbG1vZGVfZml4dXBfb3Jfb29wcysweDllLzB4MTEwDQo+PiBfX2Jh
ZF9hcmVhX25vc2VtYXBob3JlKzB4MTU1LzB4MTkwDQo+PiBiYWRfYXJlYV9ub3NlbWFwaG9yZSsw
eDE2LzB4MjANCj4+IGRvX2tlcm5fYWRkcl9mYXVsdCsweDhjLzB4YTANCj4+IGV4Y19wYWdlX2Zh
dWx0KzB4ZDgvMHgxODANCj4+IGFzbV9leGNfcGFnZV9mYXVsdCsweDFlLzB4MzANCj4+IChSZW1v
dmVkIHNvbWUgbG9ncyBmcm9tIGhlcmUpDQo+PiA/IF9fZWZpX2NhbGwrMHgyOC8weDMwDQo+PiA/
IHN3aXRjaF9tbSsweDIwLzB4MzANCj4+ID8gZWZpX2NhbGxfcnRzKzB4MTlhLzB4OGUwDQo+PiA/
IHByb2Nlc3Nfb25lX3dvcmsrMHgyMjIvMHgzZjANCj4+ID8gd29ya2VyX3RocmVhZCsweDRhLzB4
M2QwDQo+PiA/IGt0aHJlYWQrMHgxN2EvMHgxYTANCj4+ID8gcHJvY2Vzc19vbmVfd29yaysweDNm
MC8weDNmMA0KPj4gPyBzZXRfa3RocmVhZF9zdHJ1Y3QrMHg0MC8weDQwDQo+PiA/IHJldF9mcm9t
X2ZvcmsrMHgyMi8weDMwDQo+PiA8L1RBU0s+DQo+PiAtLS1bIGVuZCB0cmFjZSAxZjgyMDIzNTk1
YTU5MjdmIF0tLS0NCj4+IGVmaTogRnJvemUgZWZpX3J0c193cSBhbmQgZGlzYWJsZWQgRUZJIFJ1
bnRpbWUgU2VydmljZXMNCj4+IGludGVncml0eTogQ291bGRuJ3QgZ2V0IHNpemU6IDB4ODAwMDAw
MDAwMDAwMDAxNQ0KPj4gaW50ZWdyaXR5OiBNT0RTSUdOOiBDb3VsZG4ndCBnZXQgVUVGSSBkYiBs
aXN0DQo+PiBlZmk6IEVGSSBSdW50aW1lIFNlcnZpY2VzIGFyZSBkaXNhYmxlZCENCj4+IGludGVn
cml0eTogQ291bGRuJ3QgZ2V0IHNpemU6IDB4ODAwMDAwMDAwMDAwMDAxNQ0KPj4gaW50ZWdyaXR5
OiBDb3VsZG4ndCBnZXQgVUVGSSBkYnggbGlzdA0KPj4gaW50ZWdyaXR5OiBDb3VsZG4ndCBnZXQg
c2l6ZTogMHg4MDAwMDAwMDAwMDAwMDE1DQo+PiBpbnRlZ3JpdHk6IENvdWxkbid0IGdldCBtb2t4
IGxpc3QNCj4+IGludGVncml0eTogQ291bGRuJ3QgZ2V0IHNpemU6IDB4ODAwMDAwMDANCj4+IA0K
Pj4gVGhpcyBwYXRjaCBwcmV2ZW50cyBxdWVyeWluZyBvZiB0aGVzZSBVRUZJIHZhcmlhYmxlcywg
c2luY2UgdGhlc2UgTWFjcw0KPj4gc2VlbSB0byB1c2UgYSBub24tc3RhbmRhcmQgRUZJIGhhcmR3
YXJlDQo+PiANCj4+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+PiBTaWduZWQtb2ZmLWJ5
OiBBZGl0eWEgR2FyZyA8Z2FyZ2FkaXR5YTA4QGxpdmUuY29tPg0KPj4gLS0tDQo+PiB2MiA6LSBS
ZWR1Y2UgY29kZSBzaXplIG9mIHRoZSB0YWJsZS4NCj4+IFYzIDotIENsb3NlIHRoZSBicmFja2V0
cyB3aGljaCB3ZXJlIGxlZnQgb3BlbiBieSBtaXN0YWtlLg0KPj4gLi4uL3BsYXRmb3JtX2NlcnRz
L2tleXJpbmdfaGFuZGxlci5oIHwgOCArKysrDQo+PiBzZWN1cml0eS9pbnRlZ3JpdHkvcGxhdGZv
cm1fY2VydHMvbG9hZF91ZWZpLmMgfCA0OCArKysrKysrKysrKysrKysrKysrDQo+PiAyIGZpbGVz
IGNoYW5nZWQsIDU2IGluc2VydGlvbnMoKykNCj4+IA0KPj4gZGlmZiAtLWdpdCBhL3NlY3VyaXR5
L2ludGVncml0eS9wbGF0Zm9ybV9jZXJ0cy9rZXlyaW5nX2hhbmRsZXIuaCBiL3NlY3VyaXR5L2lu
dGVncml0eS9wbGF0Zm9ybV9jZXJ0cy9rZXlyaW5nX2hhbmRsZXIuaA0KPj4gaW5kZXggMjQ2MmJm
YTA4Li5jZDA2YmQ2MDcgMTAwNjQ0DQo+PiAtLS0gYS9zZWN1cml0eS9pbnRlZ3JpdHkvcGxhdGZv
cm1fY2VydHMva2V5cmluZ19oYW5kbGVyLmgNCj4+ICsrKyBiL3NlY3VyaXR5L2ludGVncml0eS9w
bGF0Zm9ybV9jZXJ0cy9rZXlyaW5nX2hhbmRsZXIuaA0KPj4gQEAgLTMwLDMgKzMwLDExIEBAIGVm
aV9lbGVtZW50X2hhbmRsZXJfdCBnZXRfaGFuZGxlcl9mb3JfZGIoY29uc3QgZWZpX2d1aWRfdCAq
c2lnX3R5cGUpOw0KPj4gZWZpX2VsZW1lbnRfaGFuZGxlcl90IGdldF9oYW5kbGVyX2Zvcl9kYngo
Y29uc3QgZWZpX2d1aWRfdCAqc2lnX3R5cGUpOw0KPj4gDQo+PiAjZW5kaWYNCj4+ICsNCj4+ICsj
aWZuZGVmIFVFRklfUVVJUktfU0tJUF9DRVJUDQo+PiArI2RlZmluZSBVRUZJX1FVSVJLX1NLSVBf
Q0VSVCh2ZW5kb3IsIHByb2R1Y3QpIFwNCj4+ICsJCSAubWF0Y2hlcyA9IHsgXA0KPj4gKwkJCURN
SV9NQVRDSChETUlfQk9BUkRfVkVORE9SLCB2ZW5kb3IpLCBcDQo+PiArCQkJRE1JX01BVENIKERN
SV9QUk9EVUNUX05BTUUsIHByb2R1Y3QpLCBcDQo+PiArCQl9LA0KPj4gKyNlbmRpZg0KPj4gZGlm
ZiAtLWdpdCBhL3NlY3VyaXR5L2ludGVncml0eS9wbGF0Zm9ybV9jZXJ0cy9sb2FkX3VlZmkuYyBi
L3NlY3VyaXR5L2ludGVncml0eS9wbGF0Zm9ybV9jZXJ0cy9sb2FkX3VlZmkuYw0KPj4gaW5kZXgg
MDhiNmQxMmY5Li5mMjQ2Yzg3MzIgMTAwNjQ0DQo+PiAtLS0gYS9zZWN1cml0eS9pbnRlZ3JpdHkv
cGxhdGZvcm1fY2VydHMvbG9hZF91ZWZpLmMNCj4+ICsrKyBiL3NlY3VyaXR5L2ludGVncml0eS9w
bGF0Zm9ybV9jZXJ0cy9sb2FkX3VlZmkuYw0KPj4gQEAgLTMsNiArMyw3IEBADQo+PiAjaW5jbHVk
ZSA8bGludXgva2VybmVsLmg+DQo+PiAjaW5jbHVkZSA8bGludXgvc2NoZWQuaD4NCj4+ICNpbmNs
dWRlIDxsaW51eC9jcmVkLmg+DQo+PiArI2luY2x1ZGUgPGxpbnV4L2RtaS5oPg0KPj4gI2luY2x1
ZGUgPGxpbnV4L2Vyci5oPg0KPj4gI2luY2x1ZGUgPGxpbnV4L2VmaS5oPg0KPj4gI2luY2x1ZGUg
PGxpbnV4L3NsYWIuaD4NCj4+IEBAIC0xMiw2ICsxMywzMiBAQA0KPj4gI2luY2x1ZGUgIi4uL2lu
dGVncml0eS5oIg0KPj4gI2luY2x1ZGUgImtleXJpbmdfaGFuZGxlci5oIg0KPj4gDQo+PiArLyog
QXBwbGUgTWFjcyB3aXRoIFQyIFNlY3VyaXR5IGNoaXAgZG9uJ3Qgc3VwcG9ydCB0aGVzZSBVRUZJ
IHZhcmlhYmxlcy4NCj4gDQo+IFBsZWFzZSByZWZlciB0byBEb2N1bWVudGF0aW9uL3Byb2Nlc3Mv
Y29kaW5nLXN0eWxlLnJzdCBmb3IgdGhlIGZvcm1hdA0KPiBvZiBtdWx0aS1saW5lIGNvbW1lbnRz
Lg0KRG9uZQ0KPiANCj4+ICsgKiBUaGUgVDIgY2hpcCBtYW5hZ2VzIHRoZSBTZWN1cmUgQm9vdCBh
bmQgZG9lcyBub3QgYWxsb3cgTGludXggdG8gYm9vdA0KPj4gKyAqIGlmIGl0IGlzIHR1cm5lZCBv
bi4gSWYgdHVybmVkIG9mZiwgYW4gYXR0ZW1wdCB0byBnZXQgY2VydGlmaWNhdGVzDQo+PiArICog
Y2F1c2VzIGEgY3Jhc2gsIHNvIHdlIHNpbXBseSByZXR1cm4gMCBmb3IgdGhlbSBpbiBlYWNoIGZ1
bmN0aW9uLg0KPj4gKyAqLw0KPj4gKw0KPiANCj4gTm8gbmVlZCBmb3IgYSBibGFuayBsaW5lIGhl
cmUuDQpBbGwgYmxhbmtzIHJlbW92ZWQNCj4gDQo+PiArc3RhdGljIGNvbnN0IHN0cnVjdCBkbWlf
c3lzdGVtX2lkIHVlZmlfc2tpcF9jZXJ0W10gPSB7DQo+PiArDQo+IE5vIG5lZWQgZm9yIGEgYmxh
bmsgaGVyZSBlaXRoZXIuDQo+IA0KPj4gKwl7IFVFRklfUVVJUktfU0tJUF9DRVJUKCJBcHBsZSBJ
bmMuIiwgIk1hY0Jvb2tQcm8xNSwxIikgfSwNCj4+ICsJeyBVRUZJX1FVSVJLX1NLSVBfQ0VSVCgi
QXBwbGUgSW5jLiIsICJNYWNCb29rUHJvMTUsMiIpIH0sDQo+PiArCXsgVUVGSV9RVUlSS19TS0lQ
X0NFUlQoIkFwcGxlIEluYy4iLCAiTWFjQm9va1BybzE1LDMiKSB9LA0KPj4gKwl7IFVFRklfUVVJ
UktfU0tJUF9DRVJUKCJBcHBsZSBJbmMuIiwgIk1hY0Jvb2tQcm8xNSw0IikgfSwNCj4+ICsJeyBV
RUZJX1FVSVJLX1NLSVBfQ0VSVCgiQXBwbGUgSW5jLiIsICJNYWNCb29rUHJvMTYsMSIpIH0sDQo+
PiArCXsgVUVGSV9RVUlSS19TS0lQX0NFUlQoIkFwcGxlIEluYy4iLCAiTWFjQm9va1BybzE2LDIi
KSB9LA0KPj4gKwl7IFVFRklfUVVJUktfU0tJUF9DRVJUKCJBcHBsZSBJbmMuIiwgIk1hY0Jvb2tQ
cm8xNiwzIikgfSwNCj4+ICsJeyBVRUZJX1FVSVJLX1NLSVBfQ0VSVCgiQXBwbGUgSW5jLiIsICJN
YWNCb29rUHJvMTYsNCIpIH0sDQo+PiArCXsgVUVGSV9RVUlSS19TS0lQX0NFUlQoIkFwcGxlIElu
Yy4iLCAiTWFjQm9va0FpcjgsMSIpIH0sDQo+PiArCXsgVUVGSV9RVUlSS19TS0lQX0NFUlQoIkFw
cGxlIEluYy4iLCAiTWFjQm9va0FpcjgsMiIpIH0sDQo+PiArCXsgVUVGSV9RVUlSS19TS0lQX0NF
UlQoIkFwcGxlIEluYy4iLCAiTWFjQm9va0FpcjksMSIpIH0sDQo+PiArCXsgVUVGSV9RVUlSS19T
S0lQX0NFUlQoIkFwcGxlIEluYy4iLCAiTWFjTWluaTgsMSIpIH0sDQo+PiArCXsgVUVGSV9RVUlS
S19TS0lQX0NFUlQoIkFwcGxlIEluYy4iLCAiTWFjUHJvNywxIikgfSwNCj4+ICsJeyBVRUZJX1FV
SVJLX1NLSVBfQ0VSVCgiQXBwbGUgSW5jLiIsICJpTWFjMjAsMSIpIH0sDQo+PiArCXsgVUVGSV9R
VUlSS19TS0lQX0NFUlQoIkFwcGxlIEluYy4iLCAiaU1hYzIwLDIiKSB9LA0KPj4gKwl7IH0NCj4+
ICt9Ow0KPj4gKw0KPj4gLyoNCj4+ICogTG9vayB0byBzZWUgaWYgYSBVRUZJIHZhcmlhYmxlIGNh
bGxlZCBNb2tJZ25vcmVEQiBleGlzdHMgYW5kIHJldHVybiB0cnVlIGlmDQo+PiAqIGl0IGRvZXMu
DQo+PiBAQCAtMjEsMTIgKzQ4LDE4IEBADQo+PiAqIGlzIHNldCwgd2Ugc2hvdWxkIGlnbm9yZSB0
aGUgZGIgdmFyaWFibGUgYWxzbyBhbmQgdGhlIHRydWUgcmV0dXJuIGluZGljYXRlcw0KPj4gKiB0
aGlzLg0KPj4gKi8NCj4+ICsNCj4gT3IgaGVyZQ0KPiANCj4+IHN0YXRpYyBfX2luaXQgYm9vbCB1
ZWZpX2NoZWNrX2lnbm9yZV9kYih2b2lkKQ0KPj4gew0KPj4gCWVmaV9zdGF0dXNfdCBzdGF0dXM7
DQo+PiAJdW5zaWduZWQgaW50IGRiID0gMDsNCj4+IAl1bnNpZ25lZCBsb25nIHNpemUgPSBzaXpl
b2YoZGIpOw0KPj4gCWVmaV9ndWlkX3QgZ3VpZCA9IEVGSV9TSElNX0xPQ0tfR1VJRDsNCj4+ICsJ
Y29uc3Qgc3RydWN0IGRtaV9zeXN0ZW1faWQgKmRtaV9pZDsNCj4+ICsNCj4+ICsJZG1pX2lkID0g
ZG1pX2ZpcnN0X21hdGNoKHVlZmlfc2tpcF9jZXJ0KTsNCj4+ICsJaWYgKGRtaV9pZCkNCj4+ICsJ
CXJldHVybiAwOw0KPiANCj4gVGhlIGZ1bmN0aW9uIHJldHVybnMgYSBib29sLiBSZXR1cm4gZWl0
aGVyICJ0cnVlIiBvciAiZmFsc2UiLg0KPiANCj4+IA0KPj4gCXN0YXR1cyA9IGVmaS5nZXRfdmFy
aWFibGUoTCJNb2tJZ25vcmVEQiIsICZndWlkLCBOVUxMLCAmc2l6ZSwgJmRiKTsNCj4+IAlyZXR1
cm4gc3RhdHVzID09IEVGSV9TVUNDRVNTOw0KPj4gQEAgLTQxLDYgKzc0LDExIEBAIHN0YXRpYyBf
X2luaXQgdm9pZCAqZ2V0X2NlcnRfbGlzdChlZmlfY2hhcjE2X3QgKm5hbWUsIGVmaV9ndWlkX3Qg
Kmd1aWQsDQo+PiAJdW5zaWduZWQgbG9uZyBsc2l6ZSA9IDQ7DQo+PiAJdW5zaWduZWQgbG9uZyB0
bXBkYls0XTsNCj4+IAl2b2lkICpkYjsNCj4+ICsJY29uc3Qgc3RydWN0IGRtaV9zeXN0ZW1faWQg
KmRtaV9pZDsNCj4+ICsNCj4+ICsJZG1pX2lkID0gZG1pX2ZpcnN0X21hdGNoKHVlZmlfc2tpcF9j
ZXJ0KTsNCj4+ICsJaWYgKGRtaV9pZCkNCj4+ICsJCXJldHVybiAwOw0KPiANCj4gVGhlIHJldHVy
biB2YWx1ZSBoZXJlIHNob3VsZCBiZSBOVUxMLg0KPiANCj4+IA0KPj4gCSpzdGF0dXMgPSBlZmku
Z2V0X3ZhcmlhYmxlKG5hbWUsIGd1aWQsIE5VTEwsICZsc2l6ZSwgJnRtcGRiKTsNCj4+IAlpZiAo
KnN0YXR1cyA9PSBFRklfTk9UX0ZPVU5EKQ0KPj4gQEAgLTg1LDYgKzEyMywxMSBAQCBzdGF0aWMg
aW50IF9faW5pdCBsb2FkX21va2xpc3RfY2VydHModm9pZCkNCj4+IAl1bnNpZ25lZCBsb25nIG1v
a3NpemU7DQo+PiAJZWZpX3N0YXR1c190IHN0YXR1czsNCj4+IAlpbnQgcmM7DQo+PiArCWNvbnN0
IHN0cnVjdCBkbWlfc3lzdGVtX2lkICpkbWlfaWQ7DQo+PiArDQo+PiArCWRtaV9pZCA9IGRtaV9m
aXJzdF9tYXRjaCh1ZWZpX3NraXBfY2VydCk7DQo+PiArCWlmIChkbWlfaWQpDQo+PiArCQlyZXR1
cm4gMDsNCj4+IA0KPj4gCS8qIEZpcnN0IHRyeSB0byBsb2FkIGNlcnRzIGZyb20gdGhlIEVGSSBN
T0t2YXIgY29uZmlnIHRhYmxlLg0KPj4gCSAqIEl0J3Mgbm90IGFuIGVycm9yIGlmIHRoZSBNT0t2
YXIgY29uZmlnIHRhYmxlIGRvZXNuJ3QgZXhpc3QNCj4+IEBAIC0xMzgsNiArMTgxLDExIEBAIHN0
YXRpYyBpbnQgX19pbml0IGxvYWRfdWVmaV9jZXJ0cyh2b2lkKQ0KPj4gCXVuc2lnbmVkIGxvbmcg
ZGJzaXplID0gMCwgZGJ4c2l6ZSA9IDAsIG1va3hzaXplID0gMDsNCj4+IAllZmlfc3RhdHVzX3Qg
c3RhdHVzOw0KPj4gCWludCByYyA9IDA7DQo+PiArCWNvbnN0IHN0cnVjdCBkbWlfc3lzdGVtX2lk
ICpkbWlfaWQ7DQo+PiArDQo+PiArCWRtaV9pZCA9IGRtaV9maXJzdF9tYXRjaCh1ZWZpX3NraXBf
Y2VydCk7DQo+PiArCWlmIChkbWlfaWQpDQo+PiArCQlyZXR1cm4gMDsNCj4gDQo+IHVlZmlfY2hl
Y2tfaWdub3JlX2RiKCksIGdldF9jZXJ0X2xpc3QoKSwgdWVmaV9jaGVja19pZ25vcmVfZGIoKSwg
YW5kDQo+IC9sb2FkX21va2xpc3RfY2VydHMoKSBhcmUgYWxsIGRlZmluZWQgYWxsIHN0YXRpYyBh
bmQgYXJlIGdhdGVkIGhlcmUgYnkNCj4gdGhpcyBkbWlfZmlyc3RfbWF0Y2goKS4gVGhlcmUncyBw
cm9iYWJseSBubyBuZWVkIGZvciBhbnkgb2YgdGhlIG90aGVyDQo+IGNhbGxzIHRvIGRtaV9maXJz
dF9tYXRjaCgpLg0KSSBjb3VsZG7igJl0IGdldCB5b3UgaGVyZS4gQ291bGQgeW91IGVsYWJvcmF0
ZT8NCj4gDQo+IExpa2UgaW4gYWxsIHRoZSBvdGhlciBjYXNlcywgdGhlcmUgc2hvdWxkIGJlIHNv
bWUgc29ydCBvZiBtZXNzYWdlLiBBdA0KPiBtaW5pbXVtLCB0aGVyZSBzaG91bGQgYmUgYSBwcl9p
bmZvKCkuDQo+IA0KPj4gDQo+PiAJaWYgKCFlZmlfcnRfc2VydmljZXNfc3VwcG9ydGVkKEVGSV9S
VF9TVVBQT1JURURfR0VUX1ZBUklBQkxFKSkNCj4+IAkJcmV0dXJuIGZhbHNlOw0KPiANCj4gdGhh
bmtzLA0KPiANCj4gTWltaQ0KDQo=
