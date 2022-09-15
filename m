Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E51645B9EE5
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 17:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbiIOPeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 11:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbiIOPeV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 11:34:21 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2114.outbound.protection.outlook.com [40.107.21.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF52052DF5;
        Thu, 15 Sep 2022 08:34:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gTYV0si/BVWNH9UOWO80EJWQNN7lJWPlQAYIVMbwV/nBWmSx+7hsz6hAn9nuE/WSR+vVP8JeuuKH5m6dDsAz/gnMHsMC90iIOweO4ncGTEcJXE4GADA3Bv04hSPxOEq1wYJjTsdKU8gRBIWyBNS4wjfggcBVwdXRQ8yb+fCSwXmga7RTrV7f74p3mVzkYLrgwUI73+PyR2lzr2z6A6LaJfJJ6yvdc3O0ZjiiqWtGTkH+foQYR3nuqR2fuUB5eHz7FrVUpQstVW1YdNTp7DCXHecHCRRgzgmw0JNtLZli7lkHr4ts+K4Fu6lZ+ZMzImgb8+1ItF6swqy7NpLxBfQztQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+ohJdotrx8m8f7c+dzBlXT/4Y9xtDpH4zVqm5op2p/Y=;
 b=VRNVaKvcuQkukkzzBjIm0WKdcRh+ZHMwSDtPUsoTQHKjYonnR2YHnWNmw8Fk7K5lirYN/Qc+YMmZFfgIsX8Aua1+5NfRt9veyIQ13+B2P4N1mhuib9e30uTI4ZBBgp78pf9yIaJEYYmtK7hPhyookFxYeKJbLmhFqriKbFycMX5SZPOT8a65CGYa4mupyZ+cFJLzSrGCBwUsmBKYGFQL9AYaBdSE4joCoEJn/xgaBVmSaXb7Ho7sLCH7y7OS5qge9Cq77L05VXFiOhF6kbaDfx6EWHuUnBPGanul2HXPd3XPFfyuc4oW/mI91DAbs9GjWa6A/+yYyJghLzrSU+QmSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ohJdotrx8m8f7c+dzBlXT/4Y9xtDpH4zVqm5op2p/Y=;
 b=cQa4YjEGf8aK5h3FEMM8EuYAIsvB2wfgoOrlcQy9E1oQ7tuNFsWt2SaykqAQgyQRU2Xy8MEWNsY95EHnEU/iBydhb75qCNpYfJ6qRZyo3pI6ykD1nKburCFEXcRlJJrmumNqpQoe9O2Smc+NN/0KKv6mbz3uKl2bcsANilRLcKQ=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by DB9PR03MB7567.eurprd03.prod.outlook.com (2603:10a6:10:2c4::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Thu, 15 Sep
 2022 15:34:17 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::f17f:3a97:3cfa:3cbb]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::f17f:3a97:3cfa:3cbb%5]) with mapi id 15.20.5612.022; Thu, 15 Sep 2022
 15:34:17 +0000
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
Subject: Re: [PATCH wireless-next v2 06/12] brcmfmac: of: Fetch Apple
 properties
Thread-Topic: [PATCH wireless-next v2 06/12] brcmfmac: of: Fetch Apple
 properties
Thread-Index: AQHYyRier/o3zjLKzU6MC/yZoLYD8A==
Date:   Thu, 15 Sep 2022 15:34:17 +0000
Message-ID: <20220915153417.dehkww7ci6kk3oyb@bang-olufsen.dk>
References: <Yx8BQbjJT4I2oQ5K@shell.armlinux.org.uk>
 <E1oXg7n-0064vB-3Y@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1oXg7n-0064vB-3Y@rmk-PC.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM6PR03MB3943:EE_|DB9PR03MB7567:EE_
x-ms-office365-filtering-correlation-id: a9a48679-d3fa-4a35-f296-08da972fc0ae
x-ms-exchange-atpmessageproperties: SA|SL
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: z2feiMOn0loRFIvA18SWFRT6Qqmzc/xjhgKx2KK2/Q1Sr60l4K+9O8s5TLiqqQrx/yGN8AZxpeZaoIlfQnFVzxbqWffzafgt5v8ccYpJZmCvXf+MBpI4t6xK/5KW9wy5gEJAFCfZhlYz9DI+PRIfyT5uZMGApKeJO3/OeypGbf2+rSGx3LVSl3wX3OkHxTtg5DRQ28LEaQ2ewXAhjLB8u4JVi8TgmRqjJEP7Fp5Ydl2+KYLoIIxAivC0Q+K4nOZtEN3N5MlwHOEuvE42S/cUdidoVn6UPJrMqJYHN9b/gXUrT3l75lKy+PObrdaQ5Zw6/24k4oQUUFcQUctKw/iGcsxYi/yx5y7U8ajnA8Psk5bE8Z92RR34tcy3T3+3EK3aelSGR5VVQAgzHf76PhXVqRBq/SXfjEu8/utuXSQQ4w+DGZ8MUq5Bks9n8q52/cd71nti2Hoiuc121kDbtmn/g/r/yZ7uuJ87Y42uNLrA8iqarDl21fsBlp8iwAsFZK2M5wGOlTYQf6yl4S7HbwQWRTflvO7hpwPzNrtPWoOQbDrG0uKLXTkOCQ8E4mQ569RxI4gJ8i1Meq5KOxQMEhlCi6NTv4/X6qRkYScbibMCIWnUcPaMZuSqxwpYqJGNbdVBnWx3MEjjm3JVmNtCy9Rl57QP6QdAcb7YDwMIFudx9MHYBaiKtMVbflssNUdcMj/j2enpCDpwarMIkj+1CP1RanUWxbBecFchdA25eNtOUIv9colQTMI5M1wEpSZTLp0+812IiDaToAxk3b9mwjysDplphdcaDbZxJQLdzJrYSPk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(366004)(396003)(346002)(136003)(47660400002)(451199015)(122000001)(5660300002)(4326008)(91956017)(8936002)(4744005)(8976002)(64756008)(76116006)(2616005)(8676002)(66446008)(2906002)(36756003)(316002)(66946007)(85202003)(6512007)(71200400001)(41300700001)(86362001)(66556008)(54906003)(6486002)(66476007)(1076003)(6506007)(38100700002)(38070700005)(85182001)(26005)(478600001)(7416002)(186003)(46800400005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NzI1WXl5QnFjN2Q3MFFXTUltQmdmc29uNCtnQkoxVHFZR1lwOVhERDVuRFJT?=
 =?utf-8?B?NDR2MEF1NGw0dHRYNEJnRzlWOEZKeThPcnJXbkJyc0hFamthSnNSOHRsaE4v?=
 =?utf-8?B?NU1ZOHk0cnFUWkdLcXVVUmdFd2V4ZlpidHdoc2xCMExKK2pvRDgwK29UK05W?=
 =?utf-8?B?d0pQaTVZOEtvdWpranR5WUlCN0YyTHJWTDFmRnc5cGNYMmJpWjQ5Qi84Q2ZR?=
 =?utf-8?B?aUh5QkVUb3FNZyswbTgrMkgyck03cnN0bU44NjJkMkd2VDdzbG1jdGxRVkFh?=
 =?utf-8?B?SjBESU1yT01FMEhObHJYbkpJMENkYXgyUkYvYTNwUE1hTGs2S25vRHJ1ak9I?=
 =?utf-8?B?TDljV0xIQ2ppTmk2NDRnVzlXSS9WNzZ3ZHBHM3JvSDFPNnY3MlFBOURpcFNW?=
 =?utf-8?B?Y0E3SG9MWHpiUmdMd3pDOFJnd1liTnhnOXkvN0FFNzNKbi9sSmJMdUJrcVN0?=
 =?utf-8?B?cDd5SmNmV1JZNE9mSDY5YTZnL1IrbFd0SXlhQzR5Vmg3QUJYMlk4VS9JYkxZ?=
 =?utf-8?B?WWJpak5pNEQ0QzRQb3EwWEsvc0Qyd2o1SENsOGcxbGd2SVpSS2ZPMlN6Z0lL?=
 =?utf-8?B?amFEcEtac1dQUjRLQXRHVHVxTzJ4Yzh6Tk1pYWhKa2pEMmNtN09Qcko1SWhr?=
 =?utf-8?B?cWV0QW9WSGo5M0Nqc0ZpZDJiamFzeXBRcDJ1WVM0Z2JIWm5vWE02alc4NWdv?=
 =?utf-8?B?TDRTTGNtKytjRTNwNmhpZ3JZeE93dzhwM1VJbXR5UnB3VXdhQWdFdG1iejdy?=
 =?utf-8?B?Ym1GL1h4Z1Q0RDgwSXM0UVEvZE16R1I1R1hXQkhQWXBaZVFlYmIvWDBmU0dH?=
 =?utf-8?B?cnBWckFBdk40V1lMZi9YRzMwOXFLVGVJV1JGeE9zcFdhRCszZVVDYlVhQ1F4?=
 =?utf-8?B?aVJhMXVLTlNzc1Bhbk9TcGlZemZBODVQTFUwWHV3RDlYRjhITkJ1aHhweDRj?=
 =?utf-8?B?UXB1V1YzVzdCQVZoUkRpSFlUR1dQN3NsOXViMklUSXJOUmFHNWVKalJCeERM?=
 =?utf-8?B?ZS9SODNYdGtneDZmaDBReW9vSEJNK2tMS3k5VElzMmNXdk9mYURFeitENjlH?=
 =?utf-8?B?d0JBUDM5dEJUaEhKa2Z6SXhobUxoTzR5NVpkUlVucHJnYjRnZ2h4UE0wdUpZ?=
 =?utf-8?B?YlNjdUhCd01IUHVkanh2U1YvbXRqUDFYMUFZQjY2UGhzNEdQQXRnRUJiZnY0?=
 =?utf-8?B?NlY2Z21tZ0xXT1RUOGc3U3RtYmFMSEJzQnljWFJ3UGZHZDhuOUtncmNNUkdk?=
 =?utf-8?B?NGVHQ0JibndnZC8yRTAzQlNBSWdDVDlZK2NZNFpYdnk4Tkp3Q2pUL3dKNFRD?=
 =?utf-8?B?djJHZkhtcFZOUFJkdkRiSVpBVmVXYWkxdXNobFNXREpDMFBlTnRjcExZaUNn?=
 =?utf-8?B?aVJDZUw0ODR1SEU5cFFodjZzOXJLTnZiZ1pvR0hkK1RmdE5iWUFETEZDeG9O?=
 =?utf-8?B?VUZkUzJBdHJoTGFrMmhnb3ZhZlVJUU5ZYVpUVXZlNlA3dWlLOElRMm5PcWwr?=
 =?utf-8?B?YjFLUUs3N0hjdVIrVjc1VWIxL0dQSUxwdmxVTkhhVVN2S2d6TmNScXJlRjZ4?=
 =?utf-8?B?ZkRXS0Nsd2ZxWWpYRUJiWENPVmNMZ1NtT21SWlpkL24zZW1Cbi9OT01zVU0w?=
 =?utf-8?B?eWVlU1BwdS9yUGVYU3lieCthcFY4ZGpsVG9lWG94WlpJbjdIeDR2UElLY0R0?=
 =?utf-8?B?aEpZVzE4aTFXS2JyZFVwWkZwc1phelIzTW9CVjVXN1JzeXpnaE1Yd0ZCY0tO?=
 =?utf-8?B?a0JaNXQvVEl2aVJROWI2ZDFKTVZuQUVXNGpIVzI4cGlsaXJpbVNZT0U1MDU0?=
 =?utf-8?B?a29BdzlMckNicGxIY0J5VVBrNHEvdXlsWUxvbkFnYnFheENQeFNtV0cxNHJt?=
 =?utf-8?B?aXpaNHhET3NsMDh2YzRLa2YvZkRlbmFOeDliajlRLzlsMDJwUGdqOTZIOUdy?=
 =?utf-8?B?RTdFUG0ycUp2ZTB3NFRvOENWRThxSGlJNkcrb3FEb0ZiTmFVTlBTMStJTHJ4?=
 =?utf-8?B?NFpKckl4cmdXSWJ3RXFPczRQVTRPRnlTVU9mb21DNEhBc0llbE9XKzNQMldl?=
 =?utf-8?B?Vm5FaDJEU0dnRHRUV3VOWGZNeVZuRnpBWitTakFpd3hnSlQxcHczQzdiWTMr?=
 =?utf-8?Q?4tdgbT4dYjvLtMUh4sOwVCwzz?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D7D07EC3B0BBF74E8BEA4F292DFDCAAD@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9a48679-d3fa-4a35-f296-08da972fc0ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2022 15:34:17.8138
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tUpHWjXsZymRIH/AIuC/QoZGQSwhPpMzM61dvuuHIMOHNTfTII5fcsBakZvkE8hCVcKVRokksRJ/JN3vznDARA==
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

T24gTW9uLCBTZXAgMTIsIDIwMjIgYXQgMTA6NTM6MDdBTSArMDEwMCwgUnVzc2VsbCBLaW5nIHdy
b3RlOg0KPiBGcm9tOiBIZWN0b3IgTWFydGluIDxtYXJjYW5AbWFyY2FuLnN0Pg0KPiANCj4gT24g
QXBwbGUgQVJNNjQgcGxhdGZvcm1zLCBmaXJtd2FyZSBzZWxlY3Rpb24gcmVxdWlyZXMgdHdvIHBy
b3BlcnRpZXMNCj4gdGhhdCBjb21lIGZyb20gc3lzdGVtIGZpcm13YXJlOiB0aGUgbW9kdWxlLWlu
c3RhbmNlIChha2EgImlzbGFuZCIsIGENCj4gY29kZW5hbWUgcmVwcmVzZW50aW5nIGEgZ2l2ZW4g
aGFyZHdhcmUgcGxhdGZvcm0pIGFuZCB0aGUgYW50ZW5uYS1za3UuDQo+IFdlIG1hcCBBcHBsZSdz
IG1vZHVsZSBjb2RlbmFtZXMgdG8gYm9hcmRfdHlwZXMgaW4gdGhlIGZvcm0NCj4gImFwcGxlLDxt
b2R1bGUtaW5zdGFuY2U+Ii4NCj4gDQo+IFRoZSBtYXBwZWQgYm9hcmRfdHlwZSBpcyBhZGRlZCB0
byB0aGUgRFRTIGZpbGUgaW4gdGhhdCBmb3JtLCB3aGlsZSB0aGUNCj4gYW50ZW5uYS1za3UgaXMg
Zm9yd2FyZGVkIGJ5IG91ciBib290bG9hZGVyIGZyb20gdGhlIEFwcGxlIERldmljZSBUcmVlDQo+
IGludG8gdGhlIEZEVC4gR3JhYiB0aGVtIGZyb20gdGhlIERUIHNvIGZpcm13YXJlIHNlbGVjdGlv
biBjYW4gdXNlDQo+IHRoZW0uDQo+IA0KPiBSZXZpZXdlZC1ieTogTGludXMgV2FsbGVpaiA8bGlu
dXMud2FsbGVpakBsaW5hcm8ub3JnPg0KPiBTaWduZWQtb2ZmLWJ5OiBIZWN0b3IgTWFydGluIDxt
YXJjYW5AbWFyY2FuLnN0Pg0KPiBTaWduZWQtb2ZmLWJ5OiBSdXNzZWxsIEtpbmcgKE9yYWNsZSkg
PHJtaytrZXJuZWxAYXJtbGludXgub3JnLnVrPg0KPiAtLS0NCg0KUmV2aWV3ZWQtYnk6IEFsdmlu
IMWgaXByYWdhIDxhbHNpQGJhbmctb2x1ZnNlbi5kaz4=
