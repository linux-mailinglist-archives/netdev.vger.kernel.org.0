Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 953BF5995AF
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 09:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346979AbiHSHCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 03:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346852AbiHSHCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 03:02:43 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130073.outbound.protection.outlook.com [40.107.13.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44D4DE0FE9;
        Fri, 19 Aug 2022 00:02:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RKx0rkdeehf2cvRMJn3jbj2Dat/zdpmtXaMwWCrmDn1yLJ0R6gbVJzdz57GiTDwvwnuV9d+TLr85/2pVL5oCGk5qIUHraalXCWvgyy946dtXYbDMGSvrEs1ezGJg8ZQ/bBCZxyH6MoqJoh0mZTqCsAD33F3OiPIaQ6eCjL7ukyoHnkYqtkrs3eDESNeDl7hrSLGPyq80fmagR4SsNnp1hSXjEJJGuxXSKyyskpVi2rW/Lwn2iu3ymat8eyKEkCnAFCM4CJPg/BX6Qfhsqcqp1HAUJuAcSrpTpQxODaQpWhprve7jTrEw+HjhTo+Cbkoo4SfDobZrOnpMU1SGRpzCdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0+0zyZ5G2/6oyxX1B1LjtLjYmOiXyzKv3YJ7CgseCNA=;
 b=YBcg2TMGtQT4hUrUHzrv2d6Lz3cUUOTa2Sw3G1yPptEVRfHitRhJPoz3fxZEUxtKC6PQwSqzYKl606QGIcWTxUPaRJs07TTzztuoTL6KPOs9FC5RKSmnNKO4Q8R6OiBOIuAm7TDfg8Q4CKcAWOal4BHssnXRGA8s1sG3bgzUCIWeBKmxTjkq+aGFsW+o+G2CgYyR4LA1Cn3SAnRekIbSY66cHoNPcngg4JPjscJG5troFPKcHVTQ1OQdQxFy0qikabWgClb/JctnstyximBQqlHYU03xLNptpBdej4mxwv7Gn4LYhHotBDdSbj5XQ+Wys3tg68sUMliq1p4Lum4aiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0+0zyZ5G2/6oyxX1B1LjtLjYmOiXyzKv3YJ7CgseCNA=;
 b=Yc/FqLYBHo1//I+zVFaoAB0EOpX9xW14W9fFUzI/TEWS2us29Fi62lWvcjyhy31NgrDuWrGNbdXPbbLOm0tf/UOREUh6a5se/vxtOnlKAiKVC9DYNkL2/FCU1ncwN8v+Uo86gcGJGx8VPxKaw/d7hE4sxtLSpkJ2S8aCth6Lp4U=
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by AM9PR04MB8922.eurprd04.prod.outlook.com (2603:10a6:20b:409::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Fri, 19 Aug
 2022 07:02:39 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::a569:c84a:d972:38ce]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::a569:c84a:d972:38ce%7]) with mapi id 15.20.5546.016; Fri, 19 Aug 2022
 07:02:39 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "festevam@gmail.com" <festevam@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>, Jacky Bai <ping.bai@nxp.com>,
        "sudeep.holla@arm.com" <sudeep.holla@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Aisheng Dong <aisheng.dong@nxp.com>,
        Peng Fan <peng.fan@nxp.com>
Subject: RE: [PATCH 1/3] dt-bings: net: fsl,fec: update compatible item
Thread-Topic: [PATCH 1/3] dt-bings: net: fsl,fec: update compatible item
Thread-Index: AQHYsqKW4sUYyPySKkCZLBfJFMMhm620SUAAgAAZr4CAAAaYgIAARhqAgAAB7ACAAMKigIAAGdGAgAA3ZYCAAAb4UA==
Date:   Fri, 19 Aug 2022 07:02:39 +0000
Message-ID: <DB9PR04MB8106947901F27BEDBC8A05A2886C9@DB9PR04MB8106.eurprd04.prod.outlook.com>
References: <20220704101056.24821-1-wei.fang@nxp.com>
 <20220704101056.24821-2-wei.fang@nxp.com>
 <ef7e501a-b351-77f9-c4f7-74ab10283ed6@linaro.org>
 <20220818013344.GE149610@dragon>
 <fd41a409-d0e0-0026-4644-9058d1177c45@linaro.org>
 <20220818092257.GF149610@dragon>
 <a08b230c-d655-75ee-0f0c-8281b13b477b@linaro.org>
 <20220818135727.GG149610@dragon>
 <00614b8f-0fdd-3d7e-0153-3846be5bb645@linaro.org>
 <DB9PR04MB8106BB72857149F5DD10ACEA886C9@DB9PR04MB8106.eurprd04.prod.outlook.com>
 <PA4PR04MB9416C0E26B13D4060C2F50A9886C9@PA4PR04MB9416.eurprd04.prod.outlook.com>
 <31dd0110-4c7f-61f8-7261-2476766c9360@linaro.org>
In-Reply-To: <31dd0110-4c7f-61f8-7261-2476766c9360@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0664329e-d1ba-4aae-1788-08da81b0cde3
x-ms-traffictypediagnostic: AM9PR04MB8922:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l3Wrke4uUfeVxp7BRZlWmvtJdig9JDLzXzhdjhgHLr08+Ige7EMXPLVW8C63UdAawBt6NTziAYlunksCCDvJZFMb0E3BItAIU63EoNCpfvnoEwQGqcCiGVg5Sv6gbEaKeOBRi49bxxg5Heyvx59sM486ltUtlPWdQe4X522BADEjTU1yrkd2SuCrFJ89qarx7y9wOC71iPDVh6YK+TsXypHZD+B5HadqdnWCVshnaE2gz/lXWAm4WWoE3uka+ueiuqOvpnQm+M5mJXVyCta77NaNzdPHkKtql9ELACBhzx8iFtvocNZSyZnKSovhW32URTYNBxSKGIDKuEzPGEOLUyyBn5oVCVt73NBbzkHKelgX8mr4Hno0EIJeo5U726NnrFZpg+U4OLy4jvbEAwgs34qRfcSGqH6NfM9WmKdih9YlQyewdTGRT54RiyHqsvu1l0ZnP2BaHub0ZVbMIQdM2JAPL6uB6jmETKlnQY793YW+IgDQy++UGywZmu/uFz7kG35cIrLfO9y7ithkvDJXFYjdz1gOXHRwGLufwgCTanSo9QfpyJFAsynOUMFg5S0wSSW9fFhPHWZ0RtmZNiPKILuANSOVvbtLDVvX3qkrTnhdkpCqc6X+n7my8XGQ7AuaK9ikyZ/Ei9NJ7hiEmCT1BGWcBRo2BSKjhg7fK1B/vHdBIDzy7DWa+IJ5iur8zzv5wrMerxvsCU9jzUJs241osj7Cb8jhcSsb5O/ZefHmkOk1XAephuswDMX9FAdvQnvUtt0vKt1rrgEhGg8QLXobEA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(346002)(366004)(136003)(376002)(38070700005)(86362001)(71200400001)(478600001)(110136005)(316002)(26005)(54906003)(53546011)(186003)(122000001)(6506007)(83380400001)(66476007)(55016003)(38100700002)(41300700001)(64756008)(9686003)(66446008)(8936002)(8676002)(4326008)(66556008)(52536014)(7696005)(33656002)(7416002)(5660300002)(15650500001)(76116006)(2906002)(44832011)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OUtzZUVvanBoUjdRa0Z3dytpU0JHaW9OSDRaRklxSUhLVG85dFdFa0xxNXVx?=
 =?utf-8?B?MjZaR1F4cnFOTUo0QVY2Z2RuU2s3MkE0bUZOY05Md29CeFU3dU56ZGtwTzND?=
 =?utf-8?B?SjBDMlplNHBQQkJZWGVIZzVHS0gzaVBZSlM0UGtkcWFpdXcwTWd6a0FoWEdi?=
 =?utf-8?B?eFBTd0ZHa2RmdjVLTzU0cTRJbEJ4YlVqNm94allYd3VkRkNUdXE2T1p6SDAw?=
 =?utf-8?B?YmJVL3JuZ09IWXByZ2xTbGxSMnl1eHZ5Yngya3AzS0JXcVNHMmtROVJ0MHQ2?=
 =?utf-8?B?N0pzaTFvZG1OZW80Y3ZpNlFKc01ZNkFuelpBM05xamxjQzFDUkp5em5jYlEy?=
 =?utf-8?B?dXI4bWpsQ0ZJQUN5citSOEJUd1Z2ZkZ0cmhnbzNvOU1IcHpzNEtDWTM1blQr?=
 =?utf-8?B?QkZNc1pMVFJmdmc4VjZ6ZnlGYjBRcXpLdlFCaE5WWXFDMDEzOW5CUTZYdEc5?=
 =?utf-8?B?cURPc1VrY3F6a0dzVWNJbWdZYmNaWnBic0h5czFjenBnVHd5QSt4bkxKT3Fa?=
 =?utf-8?B?a0NCRFVFRkU5UFFKUGI0SU5LdTI4OVVEV2NveEFPTHVwa0ZWM1VaNW42dGly?=
 =?utf-8?B?Nk42M083M1F6a1pRR2dOZ054K3JTcWpKNFVXaTFEMG00NlNnWHNYOUZPa3hB?=
 =?utf-8?B?OEQzcERUZ3ZnRHFlNVVjRTZhdEpuRUVFT1ZpZlRBeGdVWVBEWUdDVC9RNzho?=
 =?utf-8?B?dDNFaFMzZEh1Q0lZRGd0QmJXVXJjS1VEQW44VGgvU3NzdFBjUTlUc3JzWks4?=
 =?utf-8?B?TzA2MjAzcG96Ti9RL0RyYTV0a1JDUGZkQ2ZVbDZRVmxJQWZqejNBbTZrdHVG?=
 =?utf-8?B?MVV1ZHJmeUpTNW1XOXMxY0lzSEF2QXp4dGJMUFlnd2tNendydURRZ0l1VTJj?=
 =?utf-8?B?NXhER0pKUHU2WmFFY3VQdnAyMGpPY2lHckgvT0ZITjJUMzBQL1lTeFdMZjEz?=
 =?utf-8?B?WUpnOURiQVpqcEJnaGtUWHBpTUNUQ2hCZkh0cHBXVVE0NEx4M2FTVWVhNEtz?=
 =?utf-8?B?TWJxVVY3c0JZL2V0cisrTDNZRjBkejhlYlNsZnU4eGNCSWFPZURpS1NDbUhh?=
 =?utf-8?B?NUhQdkdIV0hwbXk1eHN4NVR2VTBlZDRwUExJNVB1WTc1SmxLNnM0YTlZZjAr?=
 =?utf-8?B?Q2lic0NnK3hRWTFrU21IOU15RTFuLzZ0WnJiZE9CWjBjUCtWMWo3UHlEeUkv?=
 =?utf-8?B?ZVFrelZvbHB3a1dPNEJLUVMvTC9oQ1h2T3BnNTRRKzI4RlMwZUpkc3R3aTlH?=
 =?utf-8?B?V3ZsYXZoNXBQTS9OR2tkQ3R5dC9ZbFUxNnZ1TmVtYWdkOFR3T2Z4NkhKU3JF?=
 =?utf-8?B?bmZ0MGJSL0g2Mnp0UmJuOVpSbWtNR0t2VXYxcnUwZWRpUmVIWm5Ra1hHaEtH?=
 =?utf-8?B?b1E3MUlGUElDY2NqYWtMTkV2STAwN2tON3NlVXR4VGtEaDVJdzNKSVVXamph?=
 =?utf-8?B?S1VHeGtaMU5lT3lUZ0oxaC91M0Q4V2pVTlZHLzZGbHNDNUsrQTN1SDk3OFI4?=
 =?utf-8?B?SXVJQS81VVFrbGx0anMxYzJiSjdoVmdsc1NudjZnRUR3OXpNcFVlRS9QaVdX?=
 =?utf-8?B?QkdZS2gzamJRU2RSRW9uZ1pQTG05eitjVmFpODdRQ2w0WkJWb1ZPVUVYKzZl?=
 =?utf-8?B?SHpsWkNXcDk2bk9Ma3U5c0dFY3AyaWJ0WWplc0FibnR5WmEvTk5rYTh6UUUv?=
 =?utf-8?B?cUlBY0VkUGJDUHZNU0dqa2RCa0FYdzFPWjQ5bjdIL1c3cDBrSkV4cFJDbjh2?=
 =?utf-8?B?bC84OHEzQ3hKRGpWQjd3YWtCVXVaU1YvcHNlc1hDT2xzV25YcGk0YlhlQkFZ?=
 =?utf-8?B?N043K3pOeFJCaXB4ZENQbFZ6TGNhMHA5Tk14TEtZZFBzQ3cwSVJocEtERkhT?=
 =?utf-8?B?c0tldnAzdzRNZFdrblRTNktkKzJscmJUaHlFNjBlTHpDcjVkM1BWUlpVaVhQ?=
 =?utf-8?B?aWxBcUJubFVHeU1YRGUxWkttcU5uUXZCM2lpYmYwVG1MNmV4eTBKUCtld1ZL?=
 =?utf-8?B?c0xBbFJrckFmYkZSblVVMUp5Qkk1bTFHZU5oZWlsNVg1dkFJRldGT1NGMFB0?=
 =?utf-8?B?dnJTY1MzR2NkbE9lNSsxbGVmQjg3cWVBYTdZQ3R3NmpXc3NpQ0NQZzFXK3hL?=
 =?utf-8?Q?A1yQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0664329e-d1ba-4aae-1788-08da81b0cde3
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2022 07:02:39.4473
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QJUS/8G21v+V3aKdq1gYahEDNBLaraP8QLmbinAFTetiiYoF4ems1AhaY4fyNszYqq1SF8yUJt7GacLNcv9MlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8922
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogS3J6eXN6dG9mIEtvemxv
d3NraSA8a3J6eXN6dG9mLmtvemxvd3NraUBsaW5hcm8ub3JnPg0KPiBTZW50OiAyMDIy5bm0OOac
iDE55pelIDE0OjMyDQo+IFRvOiBQZW5nIEZhbiA8cGVuZy5mYW5AbnhwLmNvbT47IFdlaSBGYW5n
IDx3ZWkuZmFuZ0BueHAuY29tPjsgU2hhd24NCj4gR3VvIDxzaGF3bmd1b0BrZXJuZWwub3JnPg0K
PiBDYzogZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgZWR1bWF6ZXRAZ29vZ2xlLmNvbTsga3ViYUBrZXJu
ZWwub3JnOw0KPiBwYWJlbmlAcmVkaGF0LmNvbTsgcm9iaCtkdEBrZXJuZWwub3JnOyBrcnp5c3p0
b2Yua296bG93c2tpK2R0QGxpbmFyby5vcmc7DQo+IHMuaGF1ZXJAcGVuZ3V0cm9uaXguZGU7IG5l
dGRldkB2Z2VyLmtlcm5lbC5vcmc7IGRldmljZXRyZWVAdmdlci5rZXJuZWwub3JnOw0KPiBsaW51
eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBrZXJuZWxAcGVuZ3V0cm9uaXguZGU7IGZlc3RldmFt
QGdtYWlsLmNvbTsNCj4gZGwtbGludXgtaW14IDxsaW51eC1pbXhAbnhwLmNvbT47IEphY2t5IEJh
aSA8cGluZy5iYWlAbnhwLmNvbT47DQo+IHN1ZGVlcC5ob2xsYUBhcm0uY29tOyBsaW51eC1hcm0t
a2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmc7IEFpc2hlbmcgRG9uZw0KPiA8YWlzaGVuZy5kb25n
QG54cC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggMS8zXSBkdC1iaW5nczogbmV0OiBmc2ws
ZmVjOiB1cGRhdGUgY29tcGF0aWJsZSBpdGVtDQo+IA0KPiBPbiAxOS8wOC8yMDIyIDA2OjEzLCBQ
ZW5nIEZhbiB3cm90ZToNCj4gPj4+DQo+ID4+IFNvcnJ5LCBJIGRpZCBub3QgZXhwbGFpbiBjbGVh
cmx5IGxhc3QgdGltZSwgSSBqdXN0IG1lbnRpb25lZCB0aGF0DQo+ID4+IGlteDh1bHAgZmVjIHdh
cyB0b3RhbGx5IHJldXNlZCBmcm9tIGlteDZ1bCBhbmQgd2FzIGEgbGl0dGxlIGRpZmZlcmVudCBm
cm9tDQo+IGlteDZxLg0KPiA+PiBTbyB3aGF0IHNob3VsZCBJIGRvIG5leHQ/IFNob3VsZCBJIGZp
eCB0aGUgYmluZGluZyBkb2MgPw0KPiA+DQo+ID4gSnVzdCBteSB1bmRlcnN0YW5kaW5nLCBzYXlp
bmcgaS5NWDZRIHN1cHBvcnRzIGZlYXR1cmUgQSwgaS5NWDZVTA0KPiA+IHN1cHBvcnQgZmVhdHVy
ZSBBICsgQiwgVGhlbiBpLk1YNlVMIGlzIGNvbXBhdGlibGUgd2l0aCBpLk1YNlEuDQo+IA0KPiBP
ciBpZiBpLk1YOFVMUCBjYW4gYmluZCB3aXRoIGFueSBwcmV2aW91cyBjb21wYXRpYmxlIGFuZCBz
dGlsbCB3b3JrICh3aXRoDQo+IGxpbWl0ZWQgc3Vic2V0IG9mIGZlYXR1cmVzKS4NCj4gDQo+ID4N
Cj4gPiBJZiB1cHBlciBpcyB0cnVlIGZyb20gaGFyZHdhcmUgbGV2ZWwsIHRoZW4gaS5NWDhVTFAg
RkVDIG5vZGUgc2hvdWxkDQo+ID4gY29udGFpbiA4dWxwLCA2dWwsIDZxLg0KPiA+DQo+ID4gQnV0
IHRoZSBsaXN0IG1heSBleHBhbmQgdG9vIGxvbmcgaWYgbW9yZSBhbmQgbW9yZSBkZXZpY2VzIGFy
ZQ0KPiA+IHN1cHBvcnRlZCBhbmQgaGFyZHdhcmUgYmFja3dhcmQgY29tcGF0aWJsZQ0KPiANCj4g
VHJ1ZS4gSSBndWVzcyB0aHJlZSBpdGVtcyBpcyB0aGUgbGltaXQgYW5kIGFueXRoaW5nIG5ld2Vy
IHNob3VsZCByZXN0YXJ0IHRoZQ0KPiBzZXF1ZW5jZS4NCj4gDQoNClNvLCB0aGUgYmluZGluZyBk
b2MgZG9lc24ndCBuZWVkIHRvIGJlIGZpeGVkID8NCg==
