Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCE876BC679
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 08:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbjCPHGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 03:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjCPHGp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 03:06:45 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2065.outbound.protection.outlook.com [40.107.6.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F873A90BA;
        Thu, 16 Mar 2023 00:06:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wz3L4vqM3D+dQ40gynlS3DZbxN+H4YcUK3dDXjaIl7YjA7PXxR+dk+Uqlg8sY4qLrNs6FVgXQWLMJ9SIvFXkT0ADb0lm60aqD/FhHpTCh+QSUiKWboyliXj01Fm5yQ0xlNMNbujl8BAbmTIorhhpZHX5i7XxW45yQVH+ekibk4+Zzo7OrIuRMPu4yYkKyhAP7TBO8RgJ2RZ7POaNFOWZp2g9QNsq4uJBSlmC4WePwKeAp1yFWdMFduwzulz+2crSuSpPXcSp2xUkP8gtvNVzQTk+I8Ztr8MrqFOgJujTVkk057G5VuW9T/3zy8x6DujZ3owNjQnqpoiD0oo2W/PDiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lPObwD8A8GSr8jRCtjCUxSpfCNIOqKezJJArIuFBStk=;
 b=eybNhnOPZci7L7XJRNy9b0v9qtNT1QJTSWus8VCsJyi8EUTvMRMztkUddm63D6cdiDVTVgW9WxxXyNePs7vRPVi1M7CCGXUe4VkU6uHDLoSO9e5SxZyk+pZZW6uDjgCzeNwAlOwxn50eX/1YySQDsfxj+7vULyN6Em9UdeMZTmVZAS+WCb+QBDPQbFbs7wcUclxG68TWCA63Jf4zGAleFLYLjhh/amk7XPf55Y5NwzwSul21r33gFId6bs8uW4VJWqFO8vHYI6I3Mdcgwb25kfPtaE19S1cfwVWK5f7CdWQB3YUhCOAWRlvPdYjiiIPMAKLodk8Pi6z+IuZzp0WcaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lPObwD8A8GSr8jRCtjCUxSpfCNIOqKezJJArIuFBStk=;
 b=QrughBzv910f8xc8BxdnecoRISuo7h1saehpKIWLmHVBiBmPIvXQ9zT3u9A2m9II5WFpwGJsPnSazXO032LVbDvK9vrW7k3tCqqMS3da+/SuCqacyWSGP1HbVPTDzGFmDCe/P6WqBQ1ZLZr720i3Yi3e/g9GrvkRRbT7Lh0py0o=
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by AS5PR04MB9972.eurprd04.prod.outlook.com (2603:10a6:20b:682::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Thu, 16 Mar
 2023 07:06:41 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762%5]) with mapi id 15.20.6178.031; Thu, 16 Mar 2023
 07:06:41 +0000
From:   Neeraj sanjay kale <neeraj.sanjaykale@nxp.com>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "marcel@holtmann.org" <marcel@holtmann.org>,
        "johan.hedberg@gmail.com" <johan.hedberg@gmail.com>,
        "luiz.dentz@gmail.com" <luiz.dentz@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jirislaby@kernel.org" <jirislaby@kernel.org>,
        "alok.a.tiwari@oracle.com" <alok.a.tiwari@oracle.com>,
        "hdanton@sina.com" <hdanton@sina.com>,
        "ilpo.jarvinen@linux.intel.com" <ilpo.jarvinen@linux.intel.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "simon.horman@corigine.com" <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Amitkumar Karwar <amitkumar.karwar@nxp.com>,
        Rohit Fule <rohit.fule@nxp.com>,
        Sherry Sun <sherry.sun@nxp.com>
Subject: RE: [EXT] Re: [PATCH v12 4/4] Bluetooth: NXP: Add protocol support
 for NXP Bluetooth chipsets
Thread-Topic: [EXT] Re: [PATCH v12 4/4] Bluetooth: NXP: Add protocol support
 for NXP Bluetooth chipsets
Thread-Index: AQHZVzZHDkBzfjktkE6A5bIIiWvy06773dwAgAEbuWA=
Date:   Thu, 16 Mar 2023 07:06:41 +0000
Message-ID: <AM9PR04MB8603920AC4B83DB6D7CEAB71E7BC9@AM9PR04MB8603.eurprd04.prod.outlook.com>
References: <20230315120327.958413-1-neeraj.sanjaykale@nxp.com>
 <20230315120327.958413-5-neeraj.sanjaykale@nxp.com>
 <838f77fd-fc25-da16-b0fb-14624e0bc33e@molgen.mpg.de>
In-Reply-To: <838f77fd-fc25-da16-b0fb-14624e0bc33e@molgen.mpg.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM9PR04MB8603:EE_|AS5PR04MB9972:EE_
x-ms-office365-filtering-correlation-id: 7f6f0d93-46b0-45d0-5877-08db25ecfe66
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CdTZw318cZoLnmwqMqAAo8B3LJywjCIgAAmOzut9jVE/moET/Lm57+FQfNNCtJQEdAIzSNTnm2/b17MLWjUc9v7HSAdECPQh1tq5nwaxJBXfj4FP464v+xZ1RFxo67DyJxYjIOk2IZhM/LFlXhpBrzU+pW6sBydtQSRoGxeofPw4FMmqtjsArLlPp1iYC9abXd+d/mGJeDcsP6Gv0w52gCB9rrI1QC3yCzfzcIZPd3nawji3m+cEEff2mkRFHKVUTdy0F61HceN1gQoJtG3upx1cdOIpSPsq0F0twoiXgEL/aQP0lrcOJnKyodxyb8bK0517z1iQ/W7uF2ZbOQ4DfaHPOnQBAwn5eRfJlafaCmjRIfnifcW7cTGlq1Y5EbD+IuZ/CwqYYZZOTd0e/n6gzdcBetJIihZrBXjp1YF7QSSHxqxAXG5YOOt+CPe4exJ8PtCi8AhNFP4NgTlTO/gfvXJJt+GkMJmccj3hf00Se6vUFRzVXai0gKMjDn4xAeexWXlmkUirNW9b2MSye88bt9WGFEmS6SURWGrXd3KcHRKN3wUSsgIVEWS0piU8DRumrZR1vosyyKltgcFmHBMC135zrKu3ZZGefD9YtPW2xHD3OXferHxQM9JbKxj+OukqSxxrSiTAQbRuuBV9ZNJrMq1mgXHEJpaL8wkC4MUyvJ85H32T5HvAqYErRYiF0ejZzjE09XK5IiYKSbBoXhzcTg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(376002)(39860400002)(396003)(346002)(136003)(451199018)(4326008)(6916009)(8936002)(52536014)(66446008)(8676002)(66946007)(76116006)(66556008)(66476007)(41300700001)(38100700002)(38070700005)(55016003)(122000001)(5660300002)(7416002)(64756008)(2906002)(71200400001)(7696005)(9686003)(186003)(6506007)(55236004)(26005)(316002)(33656002)(86362001)(54906003)(83380400001)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NWx3K1grNWZvSGU2WWlURUQ4YXNhMy8zRElkWlZsU1RGK05vUEZCbjVuWHVY?=
 =?utf-8?B?TEdrc2xiZktmZmYrNHF6NUxIQ04zRXV0TUdlVE5RRTZzLzZYNERwWWN1L0Ex?=
 =?utf-8?B?TGtBQlZ4R3E2UFowN3I4eUsxZ2k5Qm1ybFRVRTE5a2FMd2x2bEdpd2pDbDJL?=
 =?utf-8?B?QmkrRm9BY1B2ekZjUlU0U3ZwVENDQVdXVUVmTzFudFNlR3lqRWFZOStONjla?=
 =?utf-8?B?Rk82OEpQOTdlTzZjQjJzdzM0NHJSckN6YThGcWk2d0lTTWJkUFlmQWppR29W?=
 =?utf-8?B?SDYrdElxdWx0NWNidTR4NzJuZXQrS3NEYk5oeXR3THFPQXZmVlloQTZCNDU1?=
 =?utf-8?B?LzUzaXdTRmZFL2tCVVVNSEk4UG9oNGZ4TXBEbHdMMkFPRGVsclVTVVpRVWVF?=
 =?utf-8?B?N3JYWTk1UVpZZ2xjZFJ0enNVNnlYZFpUYjV2eExacVVtR3BOZ2dZcDRmSGNr?=
 =?utf-8?B?UXlBVk9YL3VkWDRaa0xveTQySkpLYmJublNJcHdqNVJlbXN1TE9WbXgrUFkz?=
 =?utf-8?B?YWc3YXF6MFVMUjhUUVNTTHJTZVZsekp3NCs0ZExVcVBWelQ2SW5YUnpyNURP?=
 =?utf-8?B?ZG1sL3pGeG5nMVQzM2k0cnVXMER1dGloczBjQVVPODZ3a0t5WFhjRFFjZUlF?=
 =?utf-8?B?NkxFNFZYVzdyRkdDVndIc2dFZ1pmTjhBenFYNjAzZEpESlIzck9FTk1rOC9N?=
 =?utf-8?B?WjZ6ZmUxTWNmdEVNMmhFZ2FlaUw1N0xxeFEzWG45SVBoNncvczZocXJUR3J0?=
 =?utf-8?B?RDArM2ZMbGxSbkxYbDU4Z205azNJeWh3NEl0b1FaUWxhNWpqckNtQ0RWdHQ4?=
 =?utf-8?B?eTFCcWxMSkhWL3kydGs3ODN3c0xuMUhhQ3JaTGpnWVRZb3g4RjNoQ3NIRytZ?=
 =?utf-8?B?UjhHKytzaXJuSkNLNGJudW5HZGc1TWthQmRocm9KZWRJNm9nK3QyZmhTUkkr?=
 =?utf-8?B?TXZvcjE1WTZ0aU5mWmpicC8zMU52ZzVLZ2NiclNsTzhZL1dmc0FUTFpqdVRS?=
 =?utf-8?B?NzBuWHI3VUk5NEYvTEFiTGlJWm1FRW9jU1ZjK0lSNERxUjlGS3FTeGFNbDhq?=
 =?utf-8?B?YWpmQU1ScnR1alBwVmcwN29qK2Y1YllDQUw5UTVNanA3Ny8wdC9nZGc0VVM4?=
 =?utf-8?B?Nk9kcG43SXJFQU4rWXl6RUxRZHd3cDVwUDNDRTJrNFRkR0c4ajBTblkvQzdP?=
 =?utf-8?B?bTJGSWNMR21welVLVWtreEhEUy9NTG04OUl5SmV1VWNKSmgxd3NlY2RwVlNs?=
 =?utf-8?B?NGYycXA3NHZ0MFk2TkZkc3BxQzljc1laV0ordXVYeC96ZnhHTzRLVmNxeSsy?=
 =?utf-8?B?TEExQ0MxS21QVWYzR0pYSksrWGtha3FkcFNxQURNTjRGNjNFRUhKRkcrdUZt?=
 =?utf-8?B?ZVJDeWFsanoxU3dJZUw3a1ZLc3VHTnRTOU1FVHBPdWk3RStVUERuQXN0Z09l?=
 =?utf-8?B?c2dCQ1ljYStQZUJ5UDFsWWRiYnA1ZWJsR3dEZzZYVmJGYU4vUTdPRFRERzhh?=
 =?utf-8?B?aDRIK3VpRytjODJjVXhwbGU3UWJjYmJWZ3NLbXBYNUNJUFVhaDlnUmU0N2Vu?=
 =?utf-8?B?VERTZis4MUljUmZ6Qk1UcjNhcU11VjB3TldvSjhBRGVWU2Q5dGlKSTNoUmky?=
 =?utf-8?B?YW5oZUNPakFSSGI0U0dlODVJd0tYS1RvM21qSm9kN1JDUGovczdycWozeU1Q?=
 =?utf-8?B?bmVISEQ1NWdYSnkybHVPSzZ6YnBMaGgva3Y5a3dVL3pFN3BxZGNieVk5R25J?=
 =?utf-8?B?bzltTjNjcndRVGsxVVVoenZtNmRSb0JjRU5OTkFoeStINm1ybi9YV2xOWXRP?=
 =?utf-8?B?R3FyR0NXV1lScVlKTVFreFZDV3RBSzVKeEwrWFhocjJ2VVR6b29zbjJoc1Jt?=
 =?utf-8?B?bEJ6NGNGNUJuYnBUUGtpbExJc3lLUWJqZU1SdmY5TUNUUVRTbEEwL2tmcEk1?=
 =?utf-8?B?cUxWQTlvanlzY3N2OWprODh5S0pQSElhd3ZaM3JCZExzRVdxRmZKNEpxN0xi?=
 =?utf-8?B?dTRvMHhFK2o5OW40eG0wRml4ZWl3STFXM3VLUkVreXpySUdFU3NHbXlseGxa?=
 =?utf-8?B?UWJZS0FsVmRVR2loZmdnRGoyU1FIcU1COEpVajBteFA0d2NZV0ZvVGN2TkFU?=
 =?utf-8?B?SXArMEZuUWpaMlFuZHBqQUozNytsQnhZWmFmRCszUzZQb3NhR1VKMVN3MGtN?=
 =?utf-8?B?bEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f6f0d93-46b0-45d0-5877-08db25ecfe66
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2023 07:06:41.3530
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CqT+R9TFz+B16f/wo0QPdelpKIzVv7DpxWaFwvSbwPw3wetsrKTE3/HInLxyL9MTNwwyDJh4H0YcZAl5bLx4+dpaKq/irD5ezDSr/fLGaPM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS5PR04MB9972
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,RCVD_IN_VALIDITY_RPBL,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUGF1bCwNCg0KVGhhbmsgeW91IGZvciByZXZpZXdpbmcgdGhlIHBhdGNoLg0KDQo+ID4NCj4g
PiBUaGlzIGRyaXZlciBoYXMgUG93ZXIgU2F2ZSBmZWF0dXJlIHRoYXQgd2lsbCBwdXQgdGhlIGNo
aXAgaW50byBzbGVlcA0KPiA+IHN0YXRlIHdoZW5ldmVyIHRoZXJlIGlzIG5vIGFjdGl2aXR5IGZv
ciAyMDAwbXMsIGFuZCB3aWxsIGJlIHdva2VuIHVwDQo+ID4gd2hlbiBhbnkNCj4gDQo+IEludGVy
ZXN0aW5nLiBBcmUgdHdvIHNlY29uZHMgcmVjb21tZW5kZWQgaW4gc29tZSBzcGVjaWZpY2F0aW9u
Pw0KVGhpcyAyIHNlY29uZHMgaXMgYSBkZWZhdWx0IHRpbWVvdXQgdmFsdWUgaW4gdGhpcyBkZXNp
Z24sIHdoaWNoIGlzIGVub3VnaCB0byBkZWNpZGUgaWYgdGhlIGNvbW11bmljYXRpb24gYmV0d2Vl
biBjaGlwIGlzIGdvaW5nIHRvIGJlIGlkbGUsIGluIG9yZGVyIHRvIHByZXZlbnQgbW9yZSBmcmVx
dWVudCBzbGVlcC13YWtldXAgY3ljbGVzLCBhbmQgdG8gbm90IGtlZXAgdGhlIHBvd2VyIGNvbnN1
bXB0aW9uIGhpZ2ggZm9yIHRvbyBsb25nIGluIGlkbGUgc2NlbmFyaW9zLg0KV2UgaG93ZXZlciBp
bnRlbmQgdG8gbWFrZSB0aGlzIHRpbWVvdXQgY29uZmlndXJhYmxlIChkZWZhdWx0IHdpbGwgc3Rp
bGwgYmUgMjAwMG1zKSBpbiBmdXR1cmUgcGF0Y2hlcywgcHJvYmFibHkgYnkgY29taW5nIHVwIHdp
dGggYSBuZXcgaGNpIHZlbmRvciBjb21tYW5kLg0KDQo+ID4gKw0KPiA+ICtzdGF0aWMgdTggKm54
cF9nZXRfZndfbmFtZV9mcm9tX2NoaXBpZChzdHJ1Y3QgaGNpX2RldiAqaGRldiwgdTE2DQo+ID4g
K2NoaXBpZCkNCj4gDQo+IEFueSByZWFzb24gdG8gbGltaXQgdGhlIGxlbmd0aCBvZiBgY2hpcGlk
YCBpbnN0ZWFkIG9mIHVzaW5nIGB1bnNpZ25lZCBpbnRgPw0KVGhpcyAnY2hpcGlkJyBpcyBub3Ro
aW5nIGJ1dCB0aGUgb25lIHJlY2VpdmVkIGZyb20gY2hpcCdzIGJvb3Rsb2FkZXIgc2lnbmF0dXJl
LCB3aGljaCBpcyBvZiAxNiBiaXRzLg0KUGxlYXNlIGNoZWNrICdzdHJ1Y3QgdjNfc3RhcnRfaW5k
JyBkZWZpbml0aW9uIGFuZCAnbnhwX3JlY3ZfY2hpcF92ZXJfdjMoKScuDQpUbyBtYWludGFpbiBj
b25zaXN0ZW5jeSBJIGhhdmUga2VwdCB0aGUgZGF0YXR5cGUgYXMgdTE2LiBQbGVhc2UgbGV0IG1l
IGtub3cgaWYgeW91IHRoaW5rIG90aGVyd2lzZS4NCg0KVGhhbmtzLA0KTmVlcmFqDQo=
