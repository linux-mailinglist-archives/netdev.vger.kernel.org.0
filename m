Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2B824FE4F9
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 17:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357228AbiDLPnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 11:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357237AbiDLPnh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 11:43:37 -0400
Received: from IND01-BMX-obe.outbound.protection.outlook.com (mail-bmxind01olkn2021.outbound.protection.outlook.com [40.92.103.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CF0B5FF13;
        Tue, 12 Apr 2022 08:41:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JtZKCqqvUuLvv65WqWtgzMJvMGk3n0isZwtmnhgAqTXSa81PzgD2m4v75B9jo/GCfvcIjy8lP/ufL871d5i5ouXC/+EOqf0uzTNyvXnk9xTU8Qgew/pi0C1pTs27j3r9AipYHxuHV+Plxy8yBApmrBU+p7oSA1lFWX9tpA5PBgEQLYgDhBw7//KHyQFejOMXLYNoJsLejDyNP42L0OOUrv9Y5l461am4zz4xFrehA37HyuW14ZQJj67t+pXj+P/kWQ7m6R9KooW0vaWTTJj3GCtj55pdOOBp3k1kX/ysKvz4a8G0ZNOR0ZSE2cjX2JEO3GNpB/hszvplppB+/nmESw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KuQRX/VWoXqUGB7VSQQfjP33Oxon6iygtfAa2a4moQQ=;
 b=FQvj5MkypB29nw8ZfsZSEloIxHYzISzKl4fkYLRaBdCX8pqcaFCoWk4UVw2F2rHKDL610jdnuy3Y8NNa/cwYO2LCWWrPXK/tM3Fb63gLjuIZTC6JbDZ/l8e4/i3GyXOhEko8Pqll3RbL1hTe3sckZmJj6LYfYgM7AezZ4jVtSFxRips3ndUHThT7ydmty4oIAuQYe6fuV285sEh4Llio91UAoO1/Bbq/BG4yv35x59mNNRiDaRj21UL5nDMJ0Fh9pwHVDX4FmCofl7tcZbaC18I3SDc0uiz9oRYjPM+1Kp3PS4cqQDrkKv9CxwsrwuRgk7R4ur5AZI72Bd1ThRftyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KuQRX/VWoXqUGB7VSQQfjP33Oxon6iygtfAa2a4moQQ=;
 b=or1h7M6utVZVsJLxrZNFzGAgMyFeTKJkYy+xWsHUJOWQHGobWewl7l+ga0qyQRdLmjR50BvRAi62SzkaqKLFFseaKc41I7aPf/B1CS+S5MYtTNeiRQExyzPESitDpr9/BrtE7CdKOGrU7y9eVNiNa7BBTeuR1blclTu0IkDhe+NcgXsHwHWfpKmKoc7QKiqpn/tg2UvbtxOPTz7JAW6g1m8DOSevQxV/4fLzfwnDp3x2ofCOGpH5l87ZWHAkK9zHq3x0ywubOmjRG0lGdFXa1xOLhEKEYyTOAJBpkV7gXyaYs4YopjhduxTAch5m90YtvXT5GalQSsOuFHa+lSpm8A==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by BM1PR01MB1028.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.27; Tue, 12 Apr
 2022 15:40:58 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::dc4b:b757:214c:22cd]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::dc4b:b757:214c:22cd%7]) with mapi id 15.20.5144.030; Tue, 12 Apr 2022
 15:40:57 +0000
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
Thread-Index: AQHYTMiulSPMjZZGmkKiAUWUNy3DFqzsOTYAgAAcO4CAABDTAIAAB42A
Date:   Tue, 12 Apr 2022 15:40:57 +0000
Message-ID: <E12D97B8-C609-4AA7-92E7-CE2A952089CD@live.com>
References: <652C3E9E-CB97-4C70-A961-74AF8AEF9E39@live.com>
 <f55551188f2a17a7a5da54ea4a38bfbae938a62f.camel@linux.ibm.com>
 <B857EF0F-23D7-4B82-8A1E-7480C19C9AC5@live.com>
 <2913e2998892833d4bc7d866b99dcd9bd234e82e.camel@linux.ibm.com>
In-Reply-To: <2913e2998892833d4bc7d866b99dcd9bd234e82e.camel@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [0f5Equ0CFiBDOzFHh8VSgw3dnYGmFBs+]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e6a597f3-bf94-4af8-c847-08da1c9ad675
x-ms-traffictypediagnostic: BM1PR01MB1028:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OsjYO3ezWzGbb3Q5n/yKXNmXuaYHAlsemuekZvGaMRsnkeshL8i8T+AlI1w9Qm08UvbG68/yU3oDuYXkQ6gK8oFVbw2HCntCSb112MjUHCGulWhjjrGG6B/yTsKE3nSOhtIysWsBovsKOfHSyrGbYkvbOjo3SrBHn2jHPohdASlWsPvUW5QipzCPOUjjmrXqb99dmmidHtTNvigVz1ZPelHWHNpmDcjrHU6QieqCw5RkdjXocbY4iyvFJ1KjES3sTTsROPUGVlWTCITKhaqpYgZx3Hy5U0JJLqnHP5ZKv/lLdORRLfNyg3l1F7plLnaCed7bUwqWG+d3SAqL0sPJDOJU5V5UuHaAr/0ZQaKy6oR4yLucl3wpjzs7G4QbUz4N5SIX8S4KLCyQlQt39z3Xqj5dqjbyXHMlM6s+e/Uc0DFkRJAZHcIzK/7LvTrlEikSUQPrstDXfmeXI3nIj1s8nN4DAwi0283WYHzwDAct6Icq7WwgCJ8ayoqZlokpZFVXhBPlAFN6sQYymd5kPaYZR+IjHUrlxYYOXHmeXRbYj236gcSJ6j0GcpOl4EY9ewkmUujiJSmeg7tJ2EAWBcGiLQ==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YVpKSm1kZkRJc2dWVTJDd0JkNWdDcy9STkkwOHl2dmdqVTBZcjhjYlhpV1lj?=
 =?utf-8?B?eUtkdDBMVXlRUFFHT0tLdU5VT0NHdXRscUJ6Q1R5bmJ5SCtzQnRKS0tKTFQ4?=
 =?utf-8?B?YUlIejA0VERHWm1qdTZrUnh0N2lYVUQ2N2tsN1ZNNzh1UHRzQUYzZ3FubkpE?=
 =?utf-8?B?MEVRVldCRHdmaXZXSWRtK0Z1ZUJRbzVqWlV1djVXd0Z3a0tZZWU5aThMVGM4?=
 =?utf-8?B?WFc2MlRmY0ZmRDFwMXp0OWhjVlJjK2FJNVp4TnFxVkNqUENNMTZaVGxVM1ov?=
 =?utf-8?B?RXA1dGMvaHRxUUhBejRRVjFiR0tod2lNQXR4dFF5SG4yNEFDMW1DNjF5NWM3?=
 =?utf-8?B?N2RCY1hVeDAyT1NXc1BBc1l1NFNHTFZWNjBmMUUxKzcxRVMrU3BWend6N2NM?=
 =?utf-8?B?aG1ZNG9ZQ25saXVEdTIvdldxQ2NlbmZXQ3Erc01uZEsyUmNSVXR4ZE1TbGg4?=
 =?utf-8?B?QzlqWnkrMnBjNXA1andLbUVzZzF1T2xwaHU2VnU5N1YvK1ZVV3ZiNk1ONlpI?=
 =?utf-8?B?TFRlS3FxRGRuL3l6K3BqL1BxR1NyZ1JWd1lHa01Kam1uWjV2NDFtTHNuZ0ls?=
 =?utf-8?B?U0l5N05BUmZXckdTaWc3d21sYUVBZCtRd1RUUWZyc09FenF0WVdRbVZVQ2Rn?=
 =?utf-8?B?SEkzTkpSK1ZpbFNyOTZpa3VzQ3FKNTQxeFgrVk55TnBNR05HUjdqaXFaRW5u?=
 =?utf-8?B?Q1lwTTNDb2dzemdRTTUwZGoxUHZjSDFmdGZ1c1ArRTBiL0NDelBhTEdKRVNh?=
 =?utf-8?B?cklGT3F6Ri85b0NrZGQxSEU5QlBmVUVrM3VZRUpJYU9yYm9BZHZCMzU3Q2lD?=
 =?utf-8?B?M085ekNmbU1BU0gzclhOVlVjQ3JjeHIxc0lYQ0hjWW01UjFHbDVzTnZkWHBS?=
 =?utf-8?B?Mm5oWUk1Q3pQa0lMNlBmUGdmUTROUUFNYmpsU2VxdFA1dU9qQzErNzJYMGo0?=
 =?utf-8?B?QXBxaDJXK05tNEo0ODJISFR3Skw4eHl4TktmajA5TFpNUXBSVFFjTmNIb09v?=
 =?utf-8?B?c3h3R1lyQm5TTEpBTGlKZTZqakRQUHFaMU8zb3lUSFhiVVFqTU1LNmF5Q0ox?=
 =?utf-8?B?NXh3Qms0enhBSnN2WkxMdXJWdXZaV0JqKzE1bm1tY2xjcHZ0cmZDNW1uQk95?=
 =?utf-8?B?cWczenZsTXBITVpyQzhna3RGVmV4K0ZXeUsrZ0VKZnhXUTNmU2JQUTl1eDcz?=
 =?utf-8?B?TXhJYXJCdHF0QWdjMzc0OGc1bTZkdWhpdUhKSnpDdkxnQXRnck9xZzVYcVox?=
 =?utf-8?B?emRxWmxEQkxSM3dLbU1UcWxkalpyYWdMRnRXU3JGRXEvYXB1QmVyQ0JSaDZP?=
 =?utf-8?B?bUMxOTFKRGxGWElkWUhlWUg5a1g1SDdIam5Bd3krTjMyTjV6YTdOMHRhdDRa?=
 =?utf-8?B?VGtkeHNqRlN5QWtYbWJnWG5IYkZ5eUNjbnRnUFczQjljSWdRNFlCTThlZWV0?=
 =?utf-8?B?VjFtOW5YaENQVHNMNEJReGo5VHNHT2IrcXZ5YlVDWDhBNGhOaWkyWUNMVlNG?=
 =?utf-8?B?R2c0WC9WN1Joc05YWDl3TVFWN281Qzh4WnhPQXo5Qi82ZWREUlRKUmdmN3Zp?=
 =?utf-8?B?cnprYVRLanVxSTM2OHd5eDBHTXBXUEgrWTFaUEEvcmFDSWQ5RFhpdnlURUJO?=
 =?utf-8?B?MnMwUkY5cTVDT2RPREhHb0dXanhUbmt5eTA4WjBsRzFobjB3ZkJrbG1qZ1RW?=
 =?utf-8?B?Vkc4R0Z5MWhUVll2aFpQNTRYbUlTZ1FRNFBhRi9NWXl4enlTMWtDcGszSVAr?=
 =?utf-8?B?YjAraGRCekN3QjdpS1A4SG56THRmTC9SeTdtc2JTc2xuaG5XOG5uc2lVUmVL?=
 =?utf-8?B?a2RSZWo4czV3WGh6WDZ0emdyWHFESmlMNFRjTjZQb0RGdHd3bXBOejZ4ejhn?=
 =?utf-8?B?SEZwVyswT0xGNHhyVSswZlgzVzE3Y1V3Y1Yyd20vQVB4a1BZLzBNRXRQbk1C?=
 =?utf-8?Q?4bsSAhPdzd4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <80A3C0C4ACA4114CBD28D0A884F22953@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: e6a597f3-bf94-4af8-c847-08da1c9ad675
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2022 15:40:57.4618
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BM1PR01MB1028
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IGRtaV9maXJzdF9tYXRjaCgpIGlzIGNhbGxlZCBoZXJlIGF0IHRoZSBiZWdpbm5pbmcgb2Yg
bG9hZF91ZWZpX2NlcnRzKCkuDQo+IE9ubHkgaWYgaXQgc3VjY2VlZHMgd291bGQgdWVmaV9jaGVj
a19pZ25vcmVfZGIoKSwgZ2V0X2NlcnRfbGlzdCgpLA0KPiB1ZWZpX2NoZWNrX2lnbm9yZV9kYigp
LCBvcg0KPiBsb2FkX21va2xpc3RfY2VydHMoKSBiZSBjYWxsZWQuICBJcyB0aGVyZSBhIG5lZWQg
Zm9yIGFkZGluZyBhIGNhbGwgdG8NCj4gZG1pX2ZpcnN0X21hdGNoKCkgaW4gYW55IG9mIHRoZXNl
IG90aGVyIGZ1bmN0aW9ucz8NCknigJlsbCB0ZXN0IHRoaXMgb3V0Lg0KPiANCj4gdGhhbmtzLA0K
PiANCj4gTWltaQ0KPiANCj4+PiANCj4+PiBMaWtlIGluIGFsbCB0aGUgb3RoZXIgY2FzZXMsIHRo
ZXJlIHNob3VsZCBiZSBzb21lIHNvcnQgb2YgbWVzc2FnZS4gQXQNCj4+PiBtaW5pbXVtLCB0aGVy
ZSBzaG91bGQgYmUgYSBwcl9pbmZvKCkuDQo+Pj4gDQo+Pj4+IA0KPj4+PiAgICAgaWYgKCFlZmlf
cnRfc2VydmljZXNfc3VwcG9ydGVkKEVGSV9SVF9TVVBQT1JURURfR0VUX1ZBUklBQkxFKSkNCj4+
Pj4gICAgICAgICAgICAgcmV0dXJuIGZhbHNlOw0KPj4+IA0KPiANCj4gDQoNCg==
