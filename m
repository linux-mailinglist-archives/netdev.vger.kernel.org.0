Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDF556616A
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 04:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234586AbiGECrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 22:47:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234229AbiGECrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 22:47:08 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60082.outbound.protection.outlook.com [40.107.6.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BFBF12A9F;
        Mon,  4 Jul 2022 19:47:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P/NcIGgON2VLt6IGudUcKDr9vkqpi1WZ1WBY7bgBcB0OgnLUNNqWTJDR57Fz+bcAWaYCM5eA2xbpqpBorkKT8i84jRNwSzkV+4KEn8EgVBYZ53UZMUryBIQPTIQV6pi2ew+Ey4vW7u8T/9/vW//OgwMuEUud0TXDvOWtYNL7EEwZ8Kv7wq3XaQ2xNN9iEaIeeAr8pR62VviLLhrDKlo0tN4p1/OTAYNnAyFIHO3StrvmIk264gU4athIx34yXwaz9NTmsTsfZSt+Qy2yTyrggsJXwQ1EyxL1GIqHGsK1vLKTroCDAwPPJ5gFVFwPedFguEsyXcHxR+oMEbFVaSdeug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FXiokfke+t/W95dqFhOWA0WUsuJJR5TYIt+a3uT3mSQ=;
 b=b4LuhCCDlbQujtMEO9Eq2p8KA8VZ4dqUeb9+2JyGK0s5T7a9ELgVgN5jceaDPcufLXHbGsrq3E3Qm7bMXeypjyW4RhUu/SV8dzLuTfFrKkK6ZIMdhqSaI4kbwrWedk6r2DCauE00fPe/2IV54aCl6Md0ERgaqXUgHcxYBL/QgIIw5rB8jW/+Lmy0r8erF2bAMARJKIUjSBocTojEzyMoUZxXdNkA45KLEyZFXLTQz9CRWNDadjJgdPDTB5HEOOwTsk2rKcDJiYsuEMPdBVnbBAyTDdMAhUVmYqgjaGnO6/r8oVSiAouS/L3pnZPn4q7YHCx2nmqGhBHSRNBOy4QKIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FXiokfke+t/W95dqFhOWA0WUsuJJR5TYIt+a3uT3mSQ=;
 b=MlNS1CE0ekJEtQ3AGCZI2aTthOW/2GLO2c/uPnWw78K9Sn5dVT+TqYvFf9k5HQrmtDALVHncFqFz0wMIGpdYzCwvjnJyjlQfRuoZmNxtkqY2zY4K68xLKVYKPJ/5yiz/xOvL373q8LbehyriXBjBtVjQKaKmNzgoAARCa671YS0=
Received: from AM9PR04MB9003.eurprd04.prod.outlook.com (2603:10a6:20b:40a::9)
 by PAXPR04MB8158.eurprd04.prod.outlook.com (2603:10a6:102:1c3::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.21; Tue, 5 Jul
 2022 02:47:00 +0000
Received: from AM9PR04MB9003.eurprd04.prod.outlook.com
 ([fe80::b00b:10eb:e562:4654]) by AM9PR04MB9003.eurprd04.prod.outlook.com
 ([fe80::b00b:10eb:e562:4654%8]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 02:47:00 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "festevam@gmail.com" <festevam@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>, Peng Fan <peng.fan@nxp.com>,
        Jacky Bai <ping.bai@nxp.com>,
        "sudeep.holla@arm.com" <sudeep.holla@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Aisheng Dong <aisheng.dong@nxp.com>
Subject: RE: [EXT] Re: [PATCH 1/3] dt-bings: net: fsl,fec: update compatible
 item
Thread-Topic: [EXT] Re: [PATCH 1/3] dt-bings: net: fsl,fec: update compatible
 item
Thread-Index: AQHYj0v3LLIwav7MHE6sxs7MEUf4UK1t7a6AgAEUIUA=
Date:   Tue, 5 Jul 2022 02:47:00 +0000
Message-ID: <AM9PR04MB900371B6B60D634C9391E70288819@AM9PR04MB9003.eurprd04.prod.outlook.com>
References: <20220704101056.24821-1-wei.fang@nxp.com>
 <20220704101056.24821-2-wei.fang@nxp.com>
 <ef7e501a-b351-77f9-c4f7-74ab10283ed6@linaro.org>
In-Reply-To: <ef7e501a-b351-77f9-c4f7-74ab10283ed6@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5ce29cdb-a9ab-4c42-71d3-08da5e30a252
x-ms-traffictypediagnostic: PAXPR04MB8158:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ndvYIUUMDTxDcwTyz0m8idexbpqIojm5FWSYB09Rm7SRbTBqI3+azSQ3x6xWMaE6QGiC1Oqvw+10RXbOLZtFznUgBImwIt4zazUFl8zU4v5KIpNn5SfW+bkVdM8cRDivBWeXoc9TOsiUK/EcxUv9vnEHo3+UYB3BJ3W9whP8xgYnelYtJonUx/x4gpS5tfFxHBD1bZHzEYejWa2yenDl8Hyzkzfpzu/YRFTCLp5cFCtHPP5+cHLoEKKJGHhg10Xpkx4FxIyt3OAQk/60nkOFN+oud7l1Aqy3vimHuyhUf9zIR5rXPtinVPrQBabgLmwfeLx857LG9wk7wvXwD8EhlX1fk18Y1/ky/tpItpdUt1q8pqr9tNVOfvwsvQQdi1woxcLiZcSZDtsz7JdWuhqWzhbBpMVvu5XObO4ncpAI42yRkVDbyFWJR0XCrYR1SbYOdmOpVd6Cy9pHFk53/vMmnMzibm3lZxUoqi8VDtu9ynCSySv0Pjqnfuuf0u5UGUijdcYDAECNXp0LXpxZ2X0t1TqMSIXaEA63m+bvr0ke8K+PCd+muiVp1F8ZQashCw+l5AxtW1EUoTw5kJTf4Dj/n2JpdkK7BdN0FLIozj8yEDlpt5kQ4v7pv3pvd5uttzX0GTNA98IUCulguZIId9xzmyXEEryjW+fVRbIqc47zt2U4PMvISjAkgOw756caXeFxrNcUdMhDH0W84PpNuMfw7PR2wJlKdAwCAgrEznYHWsYQz7/aEpqtFV19C42Ltgl4tXdhYE7onPL+k81AUoy5u23cGGfA3tHvUqHV/qCnMFM2EpVk0uDsRrQjju1+F6LG
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB9003.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(346002)(376002)(136003)(39860400002)(396003)(26005)(55016003)(7416002)(33656002)(54906003)(5660300002)(110136005)(8936002)(53546011)(9686003)(41300700001)(6506007)(83380400001)(7696005)(186003)(15650500001)(38070700005)(122000001)(38100700002)(86362001)(478600001)(2906002)(71200400001)(44832011)(66446008)(64756008)(8676002)(4326008)(66476007)(316002)(52536014)(76116006)(66946007)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T2lRSm8zMVVBNHRuYVZqc1MwN3M5VnIwbFlCQXRtVFpiNDBXSy8zOTRBdjNr?=
 =?utf-8?B?SjVGWU14NGg3ZC9SeVRrN0ZUS1ltMk9yQStLbEJ6RC9ZOXRkSHdrcTVJZW1u?=
 =?utf-8?B?d2NCblc1akFhU2p6SFVxMUdkU2pXdTZyUkt3RkFZZHJwVmVWc3RPT3VKclRL?=
 =?utf-8?B?WXpsWTVIa0JoTzRKUUQ4L3FCNlZkUmRRQjNXSlBqTlF2MFdLSEtyMFRpUmVy?=
 =?utf-8?B?MzhhRlBUR2RCQ3g3Z3NpWm9jQTFqeGZHTVhBQU5tM2FvaEhsUUU0clBOZksz?=
 =?utf-8?B?WTdZODZ3RmxFRlNraWxWd2wwMDBNR1FnUkhjVjZ2M05MdklRYlVNNkZlTkpX?=
 =?utf-8?B?VTdCUmhLYjU0SVBzYUFyTVNic1VYcE96TWRMakZvVnJRWDlGZkVBZmowUHha?=
 =?utf-8?B?WE0yM1FGOUwrVzNJUkhTOXl5eEczOTd5a1FyemRlT05BVHdITEVvb05JNjhH?=
 =?utf-8?B?NGFmOWNHYit4VnVxMjB5MENseXVjVmRLVDFzalhnUTZoSUlJaE1PVDRsUC9j?=
 =?utf-8?B?a0pXaWh3Q3pEaWJ4eVYvTkVJZUVnODBneWhsVlhZeG9CdldQdDN2WXdpSGNK?=
 =?utf-8?B?UGUrSTdPaVcyWWovQzJWVEo4RStFeGJYbmNPWnJKeEc0YTRTMTlWRnlDd1Qz?=
 =?utf-8?B?Nzd0ZXJFWjh1YklhU3RyVXo4WHRLQno3Ris4TWRDS0FpMkhqRkhaVDJGd0VW?=
 =?utf-8?B?YUNVSTdXcU9zejhVTU54ZnR5My95bndoSkNGaEhjeU94ZmxuWXZsVmFsQTc1?=
 =?utf-8?B?a1hKME9jc0ZTeXppWU9ESmxmbUQ2cXhaQWhOT3B2UzQvVy9ZUTNwK2MxT01Y?=
 =?utf-8?B?LzlrZ083dXVpdDhqSGNFcGxGbjVIajhjUFBDMC9MTzlxRFFiblVzNlBDa3ha?=
 =?utf-8?B?VHdKUktUOXk5Vy9vR0NJWkZEa0Npdk1COEJza3lmWWxXdncyZlhiNjE1Qlpn?=
 =?utf-8?B?SGlqMUxmZ2pjRnRlbE85Z0FFU1ZMNkswUWlDT0J1bXR2N2lVQzNDUk5kVGNy?=
 =?utf-8?B?bzBudTJuQlMydmMxYU9ObDVLZXJyYitKV3dXM1NHTjNCdjk2U0xVdTMrd0cw?=
 =?utf-8?B?L0hkdUcxVEdVOWUxVTZKZXpFRTk1MXU1VjV2dmFpYjJHSDd5SmFiSHlGVVhw?=
 =?utf-8?B?Z3dEa1laS3JobUNkem1MOFV1V3dxS0tvK1RwN3hlNHRwZ1J1SG8xYUpUc09L?=
 =?utf-8?B?a21rZXU1US9ZL3RTVEN3OXNqeHBaZEFPRW1hSzdSSFhBTy9YbFZXVDdWWmRx?=
 =?utf-8?B?MVNFellQMkRSMzNWMitKK3NXcjJSQUs0RnlNVkVxb2JnNXdSRlUrK1BMbXYr?=
 =?utf-8?B?NFVnMVNuR3RNUG1MZU9UOVZGUHVjOXJrVkdSMDFndjRCWVpnZER0M2VoVVlv?=
 =?utf-8?B?bWZORW1sUmQwVG9MNHBiVkwwS3RmTmFDRWl2MUx3ZWNvMFZhUXZndGp0UWE2?=
 =?utf-8?B?TmlybTNET2xNcHNwVUVrY1UwVG9wMlRNVnhsTlJpN3ZHanNaRnJpaDh2cEZn?=
 =?utf-8?B?MW5QUkNTdkhWbFpoN2ZpOXl2VzMrUnFYWFc0QTZtK2o1Q2x3WXBqK3JhU1pa?=
 =?utf-8?B?a1Y5L3FUUFJmaW5UOUZxbHg0dit1MmtnYm1jZ1ZoNTFSQ1ZraUVMZldlU0Qx?=
 =?utf-8?B?WW5BNC9xQ2J2aDFuTXArK01kemJlRlBXL2l0VGlhQXRjYjN5OS9LdExVaHB1?=
 =?utf-8?B?KzJwVWdiVVQxUFphQWhUZm8ycS8wN3Q0dktMN3U2MFZvQll0NXBCNituK0xG?=
 =?utf-8?B?RUQySzIzOWF0N1BhV1VxQi9tWE9Ra2E2dEN5cDlWcDVRbENTcGd4M3dQZjY4?=
 =?utf-8?B?SjBMTG1oSkFER0FaSEt4RGNFSHd2OUZCWEdKQ2RyamhSUHZoUGdRSllDZ2hz?=
 =?utf-8?B?dmFGWkkrU2tBSkFTUThBTU1PTGxtUitrSkZkb2FlNnp6UWM4eW9ZMkhYcVpu?=
 =?utf-8?B?M05JclJUVytwREdoSzVGcGRwaXAvVSt5Mk1wOW1HMkR4dEZIbzYxT2gyUjRS?=
 =?utf-8?B?b1czUW9KMHBpU3FsTUJZUWR3NjlwaHNrVWh2NHdYR0xKNWV6OENDMGZXYlU1?=
 =?utf-8?B?eUZnQUVnRG5oczVlU2xIYm9FWkRCdmpZallFMUlGRUJwNGliUVk2aFFrU2JL?=
 =?utf-8?Q?CTlQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB9003.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ce29cdb-a9ab-4c42-71d3-08da5e30a252
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2022 02:47:00.0786
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +m6pK1E4ASlV3bXRU1o/fLFQxFLplBe9efnqquD+0jUVmx5HzlBGsfiXgUS5xHrbR24Yr1S27hEyL2QwWaM6Ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8158
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgS3J6eXN6dG9mLA0KCQ0KCVNvcnJ5LCBJJ20gc3RpbGwgYSBsaXR0bGUgY29uZnVzZWQuIERv
IHlvdSBtZWFuIHRvIG1vZGlmeSBhcyBmb2xsb3dzPw0KPiArICAgICAgLSBpdGVtczoNCj4gKyAg
ICAgICAgICAtIGVudW06DQo+ICsgICAgICAgICAgICAgIC0gZnNsLGlteDh1bHAtZmVjDQo+ICsg
ICAgICAgICAgLSBjb25zdDogZnNsLGlteDZ1bC1mZWMNCj4gKyAgICAgICAgICAtIGNvbnN0OiBm
c2wsaW14NnEtZmVjDQoNCkFuZCBhcyBmYXIgYXMgSSBrbm93LCB0aGUgaW14OHVscCdzIGZlYyBp
cyByZXVzZWQgZnJvbSBpbXg2dWwsIHRoZXkgYm90aCBoYXZlIHRoZSBzYW1lIGZlYXR1cmVzLiBI
b3dldmVyLCB0aGUgZmVjIG9mIGlteDh1bHAoYW5kIGlteDZ1bCkgaXMgYSBsaXR0bGUgZGlmZmVy
ZW50IGZyb20gaW14NnEsIHRoZXJlZm9yZSwgdGhlIGZ1bmN0aW9ucyBzdXBwb3J0ZWQgYnkgdGhl
IGRyaXZlciBhcmUgYWxzbyBzb21ld2hhdCBkaWZmZXJlbnQuIA0KDQotLS0tLU9yaWdpbmFsIE1l
c3NhZ2UtLS0tLQ0KRnJvbTogS3J6eXN6dG9mIEtvemxvd3NraSA8a3J6eXN6dG9mLmtvemxvd3Nr
aUBsaW5hcm8ub3JnPiANClNlbnQ6IDIwMjLlubQ35pyINOaXpSAxNzoxMg0KVG86IFdlaSBGYW5n
IDx3ZWkuZmFuZ0BueHAuY29tPjsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgZWR1bWF6ZXRAZ29vZ2xl
LmNvbTsga3ViYUBrZXJuZWwub3JnOyBwYWJlbmlAcmVkaGF0LmNvbTsgcm9iaCtkdEBrZXJuZWwu
b3JnOyBrcnp5c3p0b2Yua296bG93c2tpK2R0QGxpbmFyby5vcmc7IHNoYXduZ3VvQGtlcm5lbC5v
cmc7IHMuaGF1ZXJAcGVuZ3V0cm9uaXguZGUNCkNjOiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBk
ZXZpY2V0cmVlQHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsg
a2VybmVsQHBlbmd1dHJvbml4LmRlOyBmZXN0ZXZhbUBnbWFpbC5jb207IGRsLWxpbnV4LWlteCA8
bGludXgtaW14QG54cC5jb20+OyBQZW5nIEZhbiA8cGVuZy5mYW5AbnhwLmNvbT47IEphY2t5IEJh
aSA8cGluZy5iYWlAbnhwLmNvbT47IHN1ZGVlcC5ob2xsYUBhcm0uY29tOyBsaW51eC1hcm0ta2Vy
bmVsQGxpc3RzLmluZnJhZGVhZC5vcmc7IEFpc2hlbmcgRG9uZyA8YWlzaGVuZy5kb25nQG54cC5j
b20+DQpTdWJqZWN0OiBbRVhUXSBSZTogW1BBVENIIDEvM10gZHQtYmluZ3M6IG5ldDogZnNsLGZl
YzogdXBkYXRlIGNvbXBhdGlibGUgaXRlbQ0KDQpDYXV0aW9uOiBFWFQgRW1haWwNCg0KT24gMDQv
MDcvMjAyMiAxMjoxMCwgV2VpIEZhbmcgd3JvdGU6DQo+IEFkZCBjb21wYXRpYmxlIGl0ZW0gZm9y
IGkuTVg4VUxQIHBsYXRmb3JtLg0KDQpXcm9uZyBzdWJqZWN0IHByZWZpeCAoZHQtYmluZGluZ3Mp
Lg0KDQpXcm9uZyBzdWJqZWN0IGNvbnRlbnRzIC0gZG8gbm90IHVzZSBzb21lIGdlbmVyaWMgc2Vu
dGVuY2VzIGxpa2UgInVwZGF0ZSBYIiwganVzdCB3cml0ZSB3aGF0IHlvdSBhcmUgZG9pbmcgb3Ig
d2hhdCB5b3Ugd2FudCB0byBhY2hpZXZlLiBGb3IgZXhhbXBsZToNCmR0LWJpbmRpbmdzOiBuZXQ6
IGZzbCxmZWM6IGFkZCBpLk1YOCBVTFAgRkVDDQoNCj4NCj4gU2lnbmVkLW9mZi1ieTogV2VpIEZh
bmcgPHdlaS5mYW5nQG54cC5jb20+DQo+IC0tLQ0KPiAgRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVl
L2JpbmRpbmdzL25ldC9mc2wsZmVjLnlhbWwgfCA0ICsrKysNCj4gIDEgZmlsZSBjaGFuZ2VkLCA0
IGluc2VydGlvbnMoKykNCj4NCj4gZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vZGV2aWNldHJl
ZS9iaW5kaW5ncy9uZXQvZnNsLGZlYy55YW1sIA0KPiBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJl
ZS9iaW5kaW5ncy9uZXQvZnNsLGZlYy55YW1sDQo+IGluZGV4IGRhYTJmNzlhMjk0Zi4uNjY0MmMy
NDY5NTFiIDEwMDY0NA0KPiAtLS0gYS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3Mv
bmV0L2ZzbCxmZWMueWFtbA0KPiArKysgYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGlu
Z3MvbmV0L2ZzbCxmZWMueWFtbA0KPiBAQCAtNDAsNiArNDAsMTAgQEAgcHJvcGVydGllczoNCj4g
ICAgICAgICAgICAtIGVudW06DQo+ICAgICAgICAgICAgICAgIC0gZnNsLGlteDdkLWZlYw0KPiAg
ICAgICAgICAgIC0gY29uc3Q6IGZzbCxpbXg2c3gtZmVjDQo+ICsgICAgICAtIGl0ZW1zOg0KPiAr
ICAgICAgICAgIC0gZW51bToNCj4gKyAgICAgICAgICAgICAgLSBmc2wsaW14OHVscC1mZWMNCj4g
KyAgICAgICAgICAtIGNvbnN0OiBmc2wsaW14NnVsLWZlYw0KDQpUaGlzIGlzIHdyb25nLiAgZnNs
LGlteDZ1bC1mZWMgaGFzIHRvIGJlIGZvbGxvd2VkIGJ5IGZzbCxpbXg2cS1mZWMuIEkgdGhpbmsg
c29tZW9uZSBtYWRlIHNpbWlsYXIgbWlzdGFrZXMgZWFybGllciBzbyB0aGlzIGlzIGEgbWVzcy4N
Cg0KPiAgICAgICAgLSBpdGVtczoNCj4gICAgICAgICAgICAtIGNvbnN0OiBmc2wsaW14OG1xLWZl
Yw0KPiAgICAgICAgICAgIC0gY29uc3Q6IGZzbCxpbXg2c3gtZmVjDQoNCg0KQmVzdCByZWdhcmRz
LA0KS3J6eXN6dG9mDQo=
