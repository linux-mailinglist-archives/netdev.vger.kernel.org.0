Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D040A5AC8C5
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 04:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234794AbiIECZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Sep 2022 22:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231931AbiIECZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Sep 2022 22:25:13 -0400
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2045.outbound.protection.outlook.com [40.107.117.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32CF4220C1;
        Sun,  4 Sep 2022 19:25:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ioleGVmjyVry/JYJF2oD9fqzu58Q9aN1Mc5F81mjujxbmn/5Obj3UVx2FtwJU4LzWD56L0odDw8F9YhUEZC+dZS5TYrJj2wb0FEFd1WuTSNc1Hlbli8Q8Ky3yuVlPHs/Nz484+U82HUybPm2kfx6bv9H8PHAETupTcz/PujpT4TsDIMSO8sjq5Q+nNdLdL0+ryqUPpd2ukU8n8+IwsdUJUtoXkRBp7M9ZaU/5vur/OLszsuNNQRnb6rGnREnD1S4VMBNrWhsNr0hhnjRXjT+8JHTg2xolX+8UuFPD47Trt4ZX3dAbT3XUy0vv/UQXQOOd0HjoCDR/RAhXvjFPE0B2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1cTBdgL61fIjwUl3YKK5sYpNo5bs3rBpyETn5nlh86g=;
 b=hyI59k+XqjmXILUxhiIO8HS/5UNCFB8EUdkj3V8mF3WLKPb032mZ/VLsba2rg6qsu2WIxo4JTGvxZpOAAhwDEZ3ZMZj95ZEZZ5X/oojM9WoF5uCrs1KcLhkW2/YypFDr9xNAbyPNIfgNc0uC1Gmm0PUAFFIZhicnM8SqWlPejDHtsNIQ5XCvZ7PsC2mM/pbwvZA2fs2gPhkRCxdwYmQuydka/rdDbVVE4TGYGfH8gIaChAv274wW29Vq/iFabTKsdzlpMwN9miQHUSO7tfioQCmRhKbFyj8GFrkgeobXzjArCWmTk6WVFkeZ2z5WqKWGH0gC0bXz1VVa+f6SQ5pDrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=jaguarmicro.com; dmarc=pass action=none
 header.from=jaguarmicro.com; dkim=pass header.d=jaguarmicro.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaguarmicro.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1cTBdgL61fIjwUl3YKK5sYpNo5bs3rBpyETn5nlh86g=;
 b=LT3ugNvD/e3U0Hl0RJrdKcowMV84HOKpQBWWhXaQKa8O6pR0YUPbjw3Y4hUjx7HMeKTi575/AKTIgjlzEZBsNzSH4Vy0k1HCQadB53jur2oDuxB53ueSvgY+XTwEKr0IXws/QwCTnAcM33+zApLnOqeoXF64GGmIDDvBSr4DbDFyEQO7a+HbkAEFeaYPo7+xUqqO6R/N/S5vOfI+/zJt8eJrxrRe/8RaFOvIdR/RM8eXUjjpA1NAptVLXIKj7vgHafUTSq9fWcOqbcZpAJvKYO0ttkhGxyaZevs9aq6lq86wb0bnmAwKXSx/gzpy6Qc8o/+N5rY7eQz8QJm1ezKKhA==
Received: from PS2PR06MB3432.apcprd06.prod.outlook.com (2603:1096:300:62::16)
 by TYZPR06MB5076.apcprd06.prod.outlook.com (2603:1096:400:1c4::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.16; Mon, 5 Sep
 2022 02:25:07 +0000
Received: from PS2PR06MB3432.apcprd06.prod.outlook.com
 ([fe80::af:24bd:d4a:da52]) by PS2PR06MB3432.apcprd06.prod.outlook.com
 ([fe80::af:24bd:d4a:da52%7]) with mapi id 15.20.5588.018; Mon, 5 Sep 2022
 02:25:06 +0000
From:   Xiaowu Ding <xiaowu.ding@jaguarmicro.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "claudiu.beznea@microchip.com" <claudiu.beznea@microchip.com>,
        "palmer@dabbelt.com" <palmer@dabbelt.com>,
        "paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>
Subject: =?gb2312?B?tPC4tDogW1BBVENIIG5ldC1uZXh0XSBkcml2ZXI6IGNhZGVuY2UgbWFjYiBk?=
 =?gb2312?Q?river_support_acpi_mode?=
Thread-Topic: [PATCH net-next] driver: cadence macb driver support acpi mode
Thread-Index: AQHYt7MEnYk6Po7le0C0MWOsjFrZhK2+KciAgA8rEXA=
Date:   Mon, 5 Sep 2022 02:25:06 +0000
Message-ID: <PS2PR06MB343298952D34545A7372FEFAF27F9@PS2PR06MB3432.apcprd06.prod.outlook.com>
References: <20220824121351.578-1-xiaowu.ding@jaguarmicro.com>
 <YwZA+1z7BDCXZn/3@lunn.ch>
In-Reply-To: <YwZA+1z7BDCXZn/3@lunn.ch>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=jaguarmicro.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e46ac01c-388e-4661-f2f1-08da8ee5d908
x-ms-traffictypediagnostic: TYZPR06MB5076:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EP/mGakCF39CWAva41fMaPw45fIRP2fLWDWfe+M/m98yMcaMuuDX3WUNYt++faTkYsLLE814KvgTH1ZQ+KHRF5fzkFhoy4HiUFRiWHSmylMphusd/nLMSb57IU1LZMR4h7clYAsxa41rN7R3m8t/Nd7fnrAQAg/vqHBTC2UA/1I1yn/q30pu8Ra1UzOhuXXqcCLzRP7z/6JoxXtQ52oxq0AxkOfbpAy7c71ZTgbb1Xgnq8H0rZdtH8x5LFyIO5FexZCN9AhRXVnAEmIL5B8s9vD0rmNzU923KjMJzROfASY6nTX7ZuAwfWxGS2Q3BF44JIPRL/sGZjx/61XTwltPIOBsh5XociJoaDbLypkJSYP1+8/WgaHIPJEZvpCUuaSI2JneDM98IMVxWhRNLeNsm3r6hMJpeV7zO9qawP/clxGuS0aOjgm5/hLnMdFUk4rrNpgIm1/Tr7lHUMAXInpJdebWPLl7VPn4xfcZYuOd/Au0KfixMuPJqd5x7yXn2Zf58mV7vZ2UUu92+Sr4VS7H4NkuS7akVaLogxTGZolLHzgpzB96h+1kc9TdYr8exvIiUKDRjHQeWQOCoxEI5eNSD5uQ6yVKzT66hRtArK4qv7E9f/LThFiXhPPO8SHTD2d4Rt91hx6RnJ/D6p7qwglku3NV4Gw6wK5PiesKyNwrFX21RdB17czQSnI4w9/67Ilplb/2lZZbnP2C39bck6F/wmwukSOsRllQaz0Ryg85pnp+Q7zKSgQLlSI3sbdOYKR0M3FiYbIygsU8UDdwsiRvhA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PS2PR06MB3432.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(396003)(136003)(366004)(346002)(39830400003)(66556008)(66446008)(66946007)(478600001)(316002)(6916009)(54906003)(66476007)(2906002)(38070700005)(224303003)(33656002)(122000001)(86362001)(38100700002)(76116006)(186003)(71200400001)(26005)(9686003)(7696005)(6506007)(5660300002)(52536014)(4326008)(55016003)(64756008)(41300700001)(44832011)(7416002)(83380400001)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?RGdFUlNKRE9Tc0R4T1BhV0FpQlFIMTE4eXBlams5VG5ETGN6bmRwZWtIRVlx?=
 =?gb2312?B?UXZ0Ykh6N2ZIQkdVTlFreWhNT3ljUjFzcVZHdHoyRUZ5L0tjSjg0cmJZK2k2?=
 =?gb2312?B?L3NBaUcyQnk0VjZydk1NTnVLV0g3c2l4Y2h1d2dhYmJRTkprQmJtS29qVllt?=
 =?gb2312?B?VVJmWVFLL0NIM3hBaHkxbWFheUR3YXhCNXZLRXJqUkZ0THI3cFQ1bWJXNWh2?=
 =?gb2312?B?QUF3TUJwZndySmJoWGNpZTB1NVN2czgxYmdYdHB4RkF0OVd5amlsUjBCN0pE?=
 =?gb2312?B?T091bXNBd1NJQ05CTmFHeVZCMlJsdVhzczVwbndRUW9zUXhpM0NKZy95cXI4?=
 =?gb2312?B?TjN5enNFeXBDSll2M0RvK0V1NnUycnV5L0FGM2FLMVdGS3c5QUdncnFBQkFH?=
 =?gb2312?B?ZEtFZGlZeUc4OE1BRmZVTVluNWNYb21hb1Q3WFlBUkpjaDJaZE5NYUdHbUdz?=
 =?gb2312?B?S0FrcG9odUdRc0tpeDZCTVYvc3lhVitWMG0wOHh4WjU2NnBVdEpoKzZ5M2FS?=
 =?gb2312?B?WDAxK1JlS3JvWGdHNFlid1FjSEsrRmw2Z1h4MEIwR2xHSWpSMXYzM0tCd2JU?=
 =?gb2312?B?dkxJU1BuZE5QVk1HT29sTmE2K01CSURwMjJlM1owOUt3dXZYYXZlR3ZDYTZr?=
 =?gb2312?B?OXRWREJPU2tQSEp0cHlxR3VVenJXWVMyb0xKb1F4czhwTmhKbVZhbEZXSnZZ?=
 =?gb2312?B?bWhpQTcvR2hlZ3FORHExRnZLYWlwNWpvUVZsNmVMNHRPTmZ5U2dYM3hxQnJK?=
 =?gb2312?B?ZlN5Y2dxbUFkQXdSZlZUR09xTjNsUmZRanNLYjJrVTdmT25Xb1FUOTNWbXY0?=
 =?gb2312?B?amNKMFNHcjJ2bktLMVZFSDBlSzdlRElqOG9aY1BuWlIySlpNNlhyVENrNUJw?=
 =?gb2312?B?bHdoSzc4ZDYrQWpWZ2RUb01RVERTMzFMc3NFQk9pS0tpMk93THlHNlNMOUhT?=
 =?gb2312?B?T0Z1WEh5K0R1RlArV3pxcmFxSzVFNzlxREVOeHFjN0liVThEQ21PQ2lVY0VD?=
 =?gb2312?B?cXREU3BWbkFzYnMrMFNwUlBMUjFSUE10SXVxVGd1WkRvMHFFOTl2RG5jKzM5?=
 =?gb2312?B?N2dnaVJkNmhaTDZIdzQ0TElnUU5xeHlxOExzRXo1b0JUSXRmNUFTSUJiVzlG?=
 =?gb2312?B?QzVWYjhmQjA0dHFaWGVKcS9SbTdyR3NIMyt4T0o1dmdSZnhyR2Q0dTBuaGhj?=
 =?gb2312?B?d2dubFNLU3BpK0JBMGxyWFg3c05GaXFNSGJacGtubnBjRy9IY1czcFNPSVpX?=
 =?gb2312?B?c2lFb3lFKyswY1Rid0lIODVwUGszeVlZakdSbUFqV083R0h3ejIxMXZNY0dp?=
 =?gb2312?B?UlBBUTR5QktXTTgwYmR4T2I0MS9pVFAxdzlzQ0FvUjErdUx0L0dGRkdVYzg3?=
 =?gb2312?B?V2crbllpL1pkS2paWXpHWG4rVjZkeVowSVRDMC9GQmtzVm56Slh0aS85Uktl?=
 =?gb2312?B?MVFRM1E0eDcwSFBZZ0VCLy8ySFhGVysrSlZ6SjlhT2MvM1FXOWRpQzN5aTlM?=
 =?gb2312?B?NTFnYkZCSGtKdCsrOTE4QWNXWVBraG9zSDQ2N0o3b3UzV0prVXJ3OUMrZWky?=
 =?gb2312?B?NnFKMVBmRXNjdWJFMVNSNFNYaVloMGNoVFZWNEdnN0RTMWttZTg1UEZsR2xC?=
 =?gb2312?B?VlZ4UmxTWndtZHJYMkhNRjhBR2R6SDdNR3E1QU5DOXdsSXlXdWxvWmtsMHpN?=
 =?gb2312?B?bHVaNTJ2bUlqb1pmNVJkREhFdVhXdHZnK2E4OWpqSkNXY0VBb3dOY2tpZWx4?=
 =?gb2312?B?WjFDL0o1czNxZVNZeTh1eTV3Qzg3RUFKT1dGaXJjMytpUEVGY3NueUJQaTdW?=
 =?gb2312?B?Qm9NYUpockRCa1RNWHdMb0hCVTN0bjh1RHQ1bXVObGIxREFTMUQ1ZFltbU9N?=
 =?gb2312?B?ZkMvb2NWcWdmbmNSek5hNTNBUytWSkJBNmVadllzWHlMVVlUZE5kNFhCb2JC?=
 =?gb2312?B?a3VoOTVBMDJmWjJDV1RmckJyWmtyU2N3ZWFWVStZMC9odzF1cnp2YUx5czdU?=
 =?gb2312?B?VjI0TXBkbk5PbWVWNytTOEhIRWpwZkgyVkdoZVNyVUdKZHFPdG82R3NYMGFG?=
 =?gb2312?B?NmlBNS9PbFIzZTNFenNrZWNUUFhRSmtiM2hxRGg0YXBlaFg1UGF0UG5HbnU1?=
 =?gb2312?Q?+GGxgB7Pd97PhOV8z8iBrjoQW?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: jaguarmicro.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PS2PR06MB3432.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e46ac01c-388e-4661-f2f1-08da8ee5d908
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2022 02:25:06.5931
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1e45a5c2-d3e1-46b3-a0e6-c5ebf6d8ba7b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JTDPKN2wMjgwTYx0GDiU9aRusbrK0Ez7PL+vyaNiAiKAIcQYlmGUdIiFq/mktQ5TgB5KEPdRRLTNB+hsylspnak8SVHc+dfuaBtRGSW0xKc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB5076
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW5kcmV3Og0KCVRoYW5rIHlvdSB2ZXJ5IG11Y2ggZm9yIHlvdXIgYWR2aWNlcy4NCiANCglU
aGVyZSB3aWxsIGJlIHNvbWUgcHJvYmxlbXMgd2l0aCB0aGUgY2xrX2h3X3JlZ2lzdGVyX2ZpeGVk
X3JhdGUgaW50ZXJmYWNlIGluIHRoZSBhY3BpIG1vZGUuDQoJSXQgc2VlbXMgdGhhdCB0aGUga2Vy
bmVsIGNvbW1vbiBjbG9jayBmcmFtZXdvcmsgY2FuIG5vdCBzdXBwb3J0IHRoZSBhY3BpIG1vZGUs
anVzdCBzdXBwb3J0IHRoZSBkdCBtb2RlLg0KCVJlZ2lzdGVyIHRoZSBmaXhlZCBjbG9ja3Mgd2l0
aCB0aGUgY2xrX2h3X3JlZ2lzdGVyX2ZpeGVkX3JhdGUgZnVuY3Rpb24gLGFuZCB0aGUgY2xrcyBo
dyBzaG91bGQgYmUgdXNlZCBieSBzb21lDQoJRHJpdmVycyxidXQgdGhlIGRyaXZlciBjYW4gbm90
IGdldCB0aGUgY2xvY2sgaHcgd2l0aCB0aGUgZGV2bV9nZXRfY2xrIGZ1bmN0aW9uLGJlY2F1c2Ug
dGhpcyBmdW5jdGlvbiBjYW4gbm90IHN1cHBvcnQNCglhY3BpIG1vZGUsIHRoZSBkcml2ZXIgY2Fu
bm90IGZpbmQgdGhlIGRldmljZSBjb3JyZWN0IHBhcmVudCBjbGsgaHcgbm9kZS4NCgkNCglTbyBj
dXJyZW50bHksIHdlIGp1c3QgZ2V0IHRoZSBjbGsgcmF0ZSBmcm9tIHRoZSBhY3BpIG5vZGUgd2l0
aCB0aGUgZGV2aWNlX3Byb3BlcnR5X3JlYWRfdTMyIGZ1bmN0aW9uLg0KDQpCciBYaWFvd3UNCg0K
LS0tLS3Tyrz+1K28/i0tLS0tDQq3orz+yMs6IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD4g
DQq3osvNyrG85DogMjAyMsTqONTCMjTI1SAyMzoxNw0KytW8/sjLOiBYaWFvd3UgRGluZyA8eGlh
b3d1LmRpbmdAamFndWFybWljcm8uY29tPg0Ks63LzTogZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgZWR1
bWF6ZXRAZ29vZ2xlLmNvbTsga3ViYUBrZXJuZWwub3JnOyBwYWJlbmlAcmVkaGF0LmNvbTsgbGlu
dXhAYXJtbGludXgub3JnLnVrOyBuaWNvbGFzLmZlcnJlQG1pY3JvY2hpcC5jb207IGNsYXVkaXUu
YmV6bmVhQG1pY3JvY2hpcC5jb207IHBhbG1lckBkYWJiZWx0LmNvbTsgcGF1bC53YWxtc2xleUBz
aWZpdmUuY29tOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJu
ZWwub3JnOyBsaW51eC1yaXNjdkBsaXN0cy5pbmZyYWRlYWQub3JnDQrW98ziOiBSZTogW1BBVENI
IG5ldC1uZXh0XSBkcml2ZXI6IGNhZGVuY2UgbWFjYiBkcml2ZXIgc3VwcG9ydCBhY3BpIG1vZGUN
Cg0KPiArLyogT24gQUNQSSBwbGF0Zm9ybXMsIGNsb2NrcyBhcmUgY29udHJvbGxlZCBieSBmaXJt
d2FyZSBhbmQvb3INCj4gKyAqIEFDUEksIG5vdCBieSBkcml2ZXJzLk5lZWQgdG8gc3RvcmUgdGhl
IGNsb2NrIHZhbHVlLg0KPiArICovDQo+ICtzdHJ1Y3QgbWFjYl9hY3BpX2NvbmZpZyB7DQo+ICsJ
dTMyIGhjbGtfcmF0ZTsgICAgICAgICAgLyogYW1iYSBjbG9jayByYXRlKi8NCj4gKwl1MzIgcGNs
a19yYXRlOyAgICAgICAgICAvKiBhbWJhIGFwYiBjbG9jayByYXRlKi8NCj4gKwl1MzIgdHhjbGtf
cmF0ZTsgICAgICAgICAvKiB0eCBjbG9jayByYXRlKi8NCj4gKwl1MzIgcnhjbGtfcmF0ZTsgICAg
ICAgICAvKiByeCBjbG9jayByYXRlKi8NCj4gKwl1MzIgdHN1Y2xrX3JhdGU7ICAgICAgICAvKiB0
eCBjbG9jayByYXRlKi8NCj4gKwlib29sIGFjcGlfZW5hYmxlOyAgICAgICAvKiBpcyBhY3BpIG9y
IG5vdCAqLw0KPiArfTsNCg0KPiArc3RhdGljIGludCBtYWNiX2FjcGlfc3VwcG9ydChzdHJ1Y3Qg
bWFjYiAqYnApIHsNCj4gKwlzdHJ1Y3QgZGV2aWNlICpkZXYgPSAmYnAtPnBkZXYtPmRldjsNCj4g
KwlzdHJ1Y3QgbWFjYl9hY3BpX2NvbmZpZyAqY29uZmlnID0gJmJwLT5hY3BpY2ZnOw0KPiArCWlu
dCByZXQ7DQo+ICsJdTMyIHByb3BlcnR5Ow0KPiArDQo+ICsJLyphY3BpIG11c3QgYmUgcmVwb3J0
IHRoZSBwY2xrKi8NCj4gKwlwcm9wZXJ0eSA9IDA7DQo+ICsJcmV0ID0gZGV2aWNlX3Byb3BlcnR5
X3JlYWRfdTMyKGRldiwgTUFDQl9TWVNQQ0xPQ0ssICZwcm9wZXJ0eSk7DQo+ICsJaWYgKHJldCkg
ew0KPiArCQlkZXZfZXJyKGRldiwgInVuYWJsZSB0byBvYnRhaW4gJXMgcHJvcGVydHlcbiIsIE1B
Q0JfU1lTUENMT0NLKTsNCj4gKwkJcmV0dXJuIHJldDsNCj4gKwl9DQo+ICsNCj4gKwljb25maWct
PnBjbGtfcmF0ZSA9IHByb3BlcnR5Ow0KDQpJdCBzZWVtcyBsaWtlIHlvdSBjb3VsZCBtYWtlIHRo
aXMgc2ltcGxlciBieSBqdXN0IGNhbGxpbmcNCg0KY2xrX2h3X3JlZ2lzdGVyX2ZpeGVkX3JhdGUo
ZGV2LCAicGNsayIsIE5VTEwsIDAsIHByb3BlcnR5KTsNCg0KWW91IHRoZW4gZG9uJ3QgbmVlZCB0
byBtb2RpZnkgYW55IG90aGVyIGNvZGUgd2l0aCByZXNwZWN0IHRvIGNsb2Nrcy4NClRoZSBjbG9j
ayBkb2VzIGV4aXN0LCBzbyBtb2RlbCBpdCBpbiB0aGUgY29tbW9uIGNsb2NrIGZyYW1ld29yay4N
Cg0KICAgIEFuZHJldw0K
