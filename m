Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93B3154D498
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 00:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346037AbiFOWcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 18:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345120AbiFOWco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 18:32:44 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130097.outbound.protection.outlook.com [40.107.13.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B25E9DFAF;
        Wed, 15 Jun 2022 15:32:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CtIT2MxTdmPVyqiDxXvnGmaknq3857f40Kt7SEluHlvFoCACogdcf6IdVCmqB45ZV02xCqKS1/DV0F/EEX0VV+NjtBoiis6qjBh7Iaidwg7RKvwJt3qa9G6rchAlHAt0UKvKJrzRO1A5PplysNLoDzVCtN32b1Oolc6vPIQoNUkm7Z+hfiTrfQOFMRWuXUYIjnJauAA83ArHbOgIc5l+3+HnDM3IDRqBJfSAJtdWKZsu44NsFWZGxuIY+gwNLiiTBQLrJDxc2dq4me6oRMIZ2LGw+B7dIWl+gyW83jug3gLDxU+VgkDucxQYtaw3vvni3QMYNuRQ+TiNpbrsvqM3FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xLuQSnmlR44UgGjid3lAoKO68UoEA4m1vtBEMBrRlCE=;
 b=cgetBYAn+T+4a0NAGFsmjvO1kI3hnbx8uoBI2R01o3AE5tJotHPkAXeAKqHJ8Ne7KlA8428ZVWDefbP51u2i9FS2THhCLTs0f+gS0Ltn8DA0x+yYYn7rTB9lx2DmmfTSRNA49X7LaahgeQGgzlwf1keRr4jL/MXN3mP7z0ZO6E+JuMx2eGEg+OJEGLzk0aBPL0UMsz2MaRyi2SXQqli86CwBMLdow/Gb9TOY9kt4R5L4sVJbv5fqZSDOoUYiQGZnvBQcCrtwIYIOTURF1bN1RFjQ2FCKsV+LweeOvHrGb4hODCo5nnRAK1XBZ9MeXrzSB7SkAIi8vrRh5lzgC0/khg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xLuQSnmlR44UgGjid3lAoKO68UoEA4m1vtBEMBrRlCE=;
 b=Ca96BgjQ3Xj6+ZVlhTem/u96FAiQ4llpt0oHxfp71/Bl7ilpMZV00xTLGx0Ys9VRrjRUfLbOsbs2d+k/zbD9Tqbvq7+tgUHRc7Fx2vTk8WOO5UaonowD8mxuDp9TRJWb3ZC/IjeB2JXKFArdJ20sFnJu7iy5hMSsSDpjKEscBe0=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by DB4PR03MB8732.eurprd03.prod.outlook.com (2603:10a6:10:380::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Wed, 15 Jun
 2022 22:32:37 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::4cae:10e4:dfe8:e111]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::4cae:10e4:dfe8:e111%7]) with mapi id 15.20.5332.014; Wed, 15 Jun 2022
 22:32:37 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <alvin@pqrs.dk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hauke@hauke-m.de" <hauke@hauke-m.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 0/5] net: dsa: realtek: rtl8365mb: improve
 handling of PHY modes
Thread-Topic: [PATCH net-next v2 0/5] net: dsa: realtek: rtl8365mb: improve
 handling of PHY modes
Thread-Index: AQHYfOA9w1RozZJmDEqQhUTFY9YeGK1Qt66AgABbE4CAAAMfgA==
Date:   Wed, 15 Jun 2022 22:32:37 +0000
Message-ID: <20220615223237.z25vtgrxy7uwqfj7@bang-olufsen.dk>
References: <20220610153829.446516-1-alvin@pqrs.dk>
 <20220615165529.3g6aqwdpwxqhs6nj@bang-olufsen.dk>
 <20220615152127.0d530fe4@kernel.org>
In-Reply-To: <20220615152127.0d530fe4@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8865b973-9574-49d2-fd78-08da4f1ef36e
x-ms-traffictypediagnostic: DB4PR03MB8732:EE_
x-microsoft-antispam-prvs: <DB4PR03MB8732E6E827181EAC6281D11B83AD9@DB4PR03MB8732.eurprd03.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5zJaOQ9PJ0YOLLilBBBcmoUfGS+H2FMjs5NZCM4qkrMxkxPHVd6GkVQpcly0fps8FIxGB6X9CzC78nfxfVh8qT+mFEW05hJx9fMTf0GCji7ZuL2CF+8tgtsKlpZodmpqqwJxzMhYIeXQxeYX19BZGwc6NKPu/ZGcOlbqW3gcj4ZevCiqO3alIDA681D5EkefOpRu0uwskBjHOC9bacXW+K+hYmBLTctF2E7TFKLCmXSVzi/P1Cvo5h8zuVnLd3xebBnaQK+jnx8FtWjYABumSTgFimkptg93JAUGakow1gyVZuqJR8LdRa61j1AECnJ3LUi+x1aOHvER7K9+unbCOFcwGvHnWMt+hf7PXlUT47v7sM0UmtQOJlx/qANcQKfnGEJ3frKBKPW9GdILKFPLg86GG97XW/MeB3MqdFJXeqt93AV5ck4PdIm8CTrc7ASaz9DiecvU635cNTx7P2RzjMMKNUt8P19uqDHsc8qdS9RdBcqKRir11vff10KAmVR1YRXIW3EW+i6DypYRYj54ZWXcXSQ+ChgwPrfxyPqywHVC0WvPBQtcRPtK5cF6Z/0R0Q9smDlg4WyZBowFi45RX/OvcdDAXR0wGLPVuKNO/P8BUwwAr5U+AGhBPh1mzk7WDFfCYuKRMCoAVa/9vqXx10GAmb55qetNDRn88u1pYykDqycRQYn07kJ72Q0TUx7XSi8EvW9m0nY3NH+Dy+GCcg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(76116006)(1076003)(66946007)(85182001)(5660300002)(8676002)(38070700005)(66556008)(83380400001)(85202003)(36756003)(64756008)(2616005)(71200400001)(7416002)(6506007)(122000001)(66446008)(66476007)(4744005)(8936002)(91956017)(8976002)(4326008)(186003)(66574015)(508600001)(6486002)(2906002)(6916009)(54906003)(86362001)(26005)(6512007)(38100700002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZzNJNlpxcXc0cEoxa0x1QWU3NXhxK0xwZUM4OEE4VW1weFhJQS9GNDBvVWtr?=
 =?utf-8?B?dVR5eUo5RXprUmU4cGxSb0czb2Exa0pNUjFUeGlqWmFYdFp6NlpvMVRGZE14?=
 =?utf-8?B?RCtvTVF3MFRnVi9qcTFEdUJhTmRJN3lycW92QWNEUU9pZ1VvZjlPMmVLSitj?=
 =?utf-8?B?aEN6d2VmOEppeUFuSGxWY2VsSEwreDJubkZ0S3Bjb0xZb1Q2S2Z5bkVkNmMv?=
 =?utf-8?B?V2gwZlppeEt6a1Z4bGVIamNERlF3cEd6MmJPNmh0VzkzT2F1U0tDbFBpQTk0?=
 =?utf-8?B?VFdvYytoZUg3RlJKY3VMTHdxY0pDMWluRnVEM0dCSUdKT0JyT1hmYVliSGY0?=
 =?utf-8?B?SjRyMEF1SG9GZzVKbVdrMFRwbXZqRTBoSVhGWHVlWnlobEY1b3dxZzlWc0Qy?=
 =?utf-8?B?SDhHRmFpaVd2R2t2YWo3RkozOG5rZkpCZ05GcGVuOGRaSC9HS3ZHb3luc3hv?=
 =?utf-8?B?L3p1TGFTZ3lGOFpXVGptU1J5UGhyaFFyT3FlNEVYUXVQUlZHOFF2dnpVZzZW?=
 =?utf-8?B?U2oxdjQ3alNnWFlUbzJXS294ejZUNTVmRFJVT0xSYWJsaU9rZGIwWmZqZDNP?=
 =?utf-8?B?d0lUMzU1Z2sxNldibVVxRTE2dU84UHhIa1VQYy95OVZaVWVvUXZFcWdMWXhN?=
 =?utf-8?B?amEzYWkwZ0kvcU9SRmNISmdIMzljajFyUlVFblkzM202QkptY3JzWWNNd3R2?=
 =?utf-8?B?aVViZUwvV0dFWkVoT3A3VTkrN0RoMlBDWkhpQ1pNTktRNEhSSm9YZ0JQUnFB?=
 =?utf-8?B?ME9Ja0RSYmdwQmxxM09xcXZ5M0Z6VEhUYS9QZWFQYWFtRjFaL1lhL1JVSE5T?=
 =?utf-8?B?Q29qME5GV25UU1YzemhibXFKOFBGZVVnWnRKcit2N0NmbUhpTzhQY05FWUZ6?=
 =?utf-8?B?OU1wWFJWZWZpNkxMZTJOS0JuWUEzdDR5Z0xJQzFxUEFaeHFnZ05iSHRpU0Vu?=
 =?utf-8?B?SlJ6eWRCaFltV1BDRENwQWVyRVF4V2YxSU5USWtMREVRT2dhNHFENzR0cmY2?=
 =?utf-8?B?ZlhGd21ZUEpDZGZPRVFqdTMrQlFrR0tVeXYxTUtNUEJJS3dLOEFoaHNUODZG?=
 =?utf-8?B?WUQ4RUdyY21hSHZydXdOU2VqT3N1eVRPQkI3di9pcTVRQSs1eW9wQ0xkYkpK?=
 =?utf-8?B?UW1MUjBZTzNkQlN2WExnbVgxbFMvaS9La1Rzd1E5T1ppQ2srOTE2ZHNIc3lx?=
 =?utf-8?B?MURDaVNrTGhreTFVOXZTOU9veEk0N3ZvYkIzNlNLeERmZ3k4dGhCdDdaUy9H?=
 =?utf-8?B?d0NvTk1kYlRGN1EzRWViY0h2R0p2WWg2czdjTG1pdzRxRHFxSHMzSk1CZTZO?=
 =?utf-8?B?VnQrRGgrY1JGV3lkdU9CdXRFMG1tcGhGQTRHNWJXaTN1dU9iazg5ZXRidWt2?=
 =?utf-8?B?NDdqeHl3Y3I4OHBnaTN0YWRnZlNWL0xSWStTQWl3bDRkNzg3M1NKMHJ4SEZT?=
 =?utf-8?B?VDBQM1lvQ1RJQ3dPZ1FUTm1MeUZLd21vYThTMVNLV1FpRTdDT3k5YnRaTW8w?=
 =?utf-8?B?SlRDY1NENnMyaFNXNmsrekhSRVYyaUJUM1Z1RCtQdVgzZnliVXY0b0l6UmFY?=
 =?utf-8?B?WElCdlllWGlsSUtmdVlXR1pxRWNNWmREWGV4b3BOR25rNE5rMVFUeXdJMThK?=
 =?utf-8?B?T3ZPSUZjOEJheXMwZDQ5cjRsRk5URHordGd1SW5NZWhKNzlFeDFZd0NIVVEv?=
 =?utf-8?B?MWxCMWxpSU05OWlCcHo4aXkrSlVZQ2xrMTdzb1hqWUcxOUlUWmo4UE85eWNt?=
 =?utf-8?B?STBIRkpENnVSQThDTytVbk5BUHU5U1o0VE5LaHhXU0l4bUJ6Q2JFVmhIMDNR?=
 =?utf-8?B?WXNLTkRWWkx3YU15N2JJVHNBUlJzeXB0QU40SzBqSkVCMkpMZDhiY1Rsb1kv?=
 =?utf-8?B?b3NMK2ZvaWRCOEZ0WXpLUXNlN1hlWkdMYVA2MCsydW9qR0Nyd1ErM3lCVTVn?=
 =?utf-8?B?NUFPSENCNU4reDdvbkh1Q2FHZlVuNVQ2djUyZVJhZGZzQ3NuRVhjQUFpeklF?=
 =?utf-8?B?NndJcUJGTTJvV255a2xzb0IyNHJvVWhhZ1lNY3dFbFlSZnZGNDZNcnc1OUhD?=
 =?utf-8?B?SjgvRFMyaVlQS1VtblBLZHdLNHBnREhNdDRzUU1KQTFiWklhVDdlNkJEcGta?=
 =?utf-8?B?UW1DemtwbTJVczVyZzNsV29NbEJpTWhsTHNpblFSWFdEQmRxV1FWQUtmQmF3?=
 =?utf-8?B?ZW9OclNsNjNvNzNBRVBVU0tnSGFqbjRLK0pCdnpZelJBY0E3dWlPWFVYbXcz?=
 =?utf-8?B?dmY3MVd3cSsrTk8vZ0s5TmxtNlN1NjhYa1M3V1VwL2VQeXZGVjAxWmV6RDFw?=
 =?utf-8?B?S1Q5Q1VHRWVtOVdRbkFOLzhlOUdzTldJTFlYd25TSkxrUWRjMEdvdjU3WENR?=
 =?utf-8?Q?Uyz2bdq9FPKwl72g=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DC39211ED7FD594D839D090F4ED82D56@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8865b973-9574-49d2-fd78-08da4f1ef36e
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2022 22:32:37.7628
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WEcycAxzSn88sNHcqp1TyRbUeSTifAgNOCuCtfpjuXODDALCNRzJSGdPrtK5b4PTO2B+ggG5pCmQQR8bhWGU5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR03MB8732
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCBKdW4gMTUsIDIwMjIgYXQgMDM6MjE6MjdQTSAtMDcwMCwgSmFrdWIgS2ljaW5za2kg
d3JvdGU6DQo+IE9uIFdlZCwgMTUgSnVuIDIwMjIgMTY6NTU6MjkgKzAwMDAgQWx2aW4gxaBpcHJh
Z2Egd3JvdGU6DQo+ID4gRGF2aWQsIEpha3ViLCB0aGlzIHNlcmllcyBpcyBtYXJrZWQgQ2hhbmdl
cyBSZXF1ZXN0ZWQgb24gcGF0Y2h3b3JrLCBidXQgSSBoYXZlDQo+ID4gYWRkcmVzc2VkIGFsbCB0
aGUgY29tbWVudHMuIERvIHlvdSB3YW50IG1lIHRvIHJlc2VuZD8NCj4gDQo+IE9oLCB0aGF0IHdh
cyBtZS4gSSB3YXMgaG9waW5nIHlvdSdkIHJlc3BpbiB0byBhdCBsZWFzdCBjbGFyaWZ5IA0KPiB0
aGUgY29tbWl0IG1lc3NhZ2Ugb24gcGF0Y2ggNSwgYmFzZWQgb24gUnVzc2VsbCdzIHF1ZXN0aW9u
cy4NCj4gUGVyaGFwcyB0aGF0J3Mgbm90IGFzIGltcG9ydGFudCB0aGVzZSBkYXlzIGdpdmVuIHdl
IGFkZCBMaW5rcw0KPiB0byB0aGUgb3JpZ2luYWwgZGlzY3Vzc2lvbiBidXQgc2hvdWxkIGJlIHVz
ZWZ1bCB0byBwZXJzb24gcmVhZGluZyANCj4ganVzdCB0aGUgZ2l0IGhpc3RvcnkuIFNvcnJ5IGZv
ciBub3QgbWFraW5nIHRoYXQgY2xlYXIsIGZvbGtzIHNlbmRpbmcNCj4gY29tbWVudHMgYW5kIHN0
aWxsIGFja2luZyB0aGUgcGF0Y2ggaW4gZ2VuZXJhbCBnaXZlcyBtZSBsb3cgc2lnbmFsLg0KDQpB
aCBzb3JyeSwgSSBoYWQgYWN0dWFsbHkgZm9yZ290dGVuIGFib3V0IHRoYXQuIExldCBtZSBzZW5k
IGEgdjMgdGhlbiBhbmQNCkkgd2lsbCBmaXggaXQgdXAuIFRoYW5rcyBmb3IgY2xhcmlmeWluZyE=
