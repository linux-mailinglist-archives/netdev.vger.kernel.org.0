Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 011B66A704E
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 16:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbjCAPwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 10:52:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjCAPwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 10:52:53 -0500
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2056.outbound.protection.outlook.com [40.107.241.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9592474E0;
        Wed,  1 Mar 2023 07:52:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mmkxa1UmZzfYWWvhvWhT4X97SqG6AEK4/KMmRVdiGNbs/QkAkMEi7DsG9DGMqPEDhQrAPjf56pZ2EuL/m4DPtAnFSBJol8mtXZ/VbKAq5mtZFbjBc3JVh3CmKOMSFf/T+QkalbsWvfL/SoQoD35DV6aZCXtBakas/Y5AqAGR06cdAI3AIHNiuFhBEwXl2B7WrKPM3UK8LKxH4pqSXgfk598FpHjlz9BO/yRpJs1MTmhnbys2OuD7QzrVJTULg2BlzJSQIihuhmbEm78bgwdocS4w1sOGf/ObvXRnFBzrlJKu2oSvJ4nqYPoJAfPRyWtIETNx+9tmT5c/PQyuLdrgnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IBWHTCX7klKcD11Q1PfKSI3ga7+hgoOp83RjlgPhgFI=;
 b=APWkohifj1Rec1G42nkbaBu2yuXU1Co14d5RPX3YnAy/cdYtEnP0EkxuuuhWoP9Z9HratpK2LDB69GoXW3n1tB1TbGXg0s/0HxkQWShjP6alJNxy86YSlStnrkVqKRMoae8ikyNWwHPS1jAK83kJO3+hqi/bNNMm6vPtto1kkr1bxBp2Ebh8eVV6T3QaM5nb+22f5nUPHTczsuoAl9InhtRaz83CgfoceFDqsd4cEbGtj/iut/xBYEBzQSy6C6OuTGa1n8F7MZ5HpoAVWvWh1dERhyfIEpoSjsin5taoE7yVanaEPCgDADDheAjKlBxY88GAS/G0TuBEQfGF1dX+Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IBWHTCX7klKcD11Q1PfKSI3ga7+hgoOp83RjlgPhgFI=;
 b=TUtJwLl2HrgSxiVT5YKuCLdxTc+mzRKb2xYFInLvGFY3cfyjMGFq0V/PYhbdOhoFGqo3vST1fLcXan4Pv0azONBgmAewRKrQobg5sw/9fso5QFv9EvnwKGeFUr6tNvmO14tBJuTUA1g57iGekkZUAELgR9TZVWEzaOTJkB6DwFQ=
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by PAXPR04MB9253.eurprd04.prod.outlook.com (2603:10a6:102:2bd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.25; Wed, 1 Mar
 2023 15:51:52 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762%4]) with mapi id 15.20.6156.017; Wed, 1 Mar 2023
 15:51:52 +0000
From:   Neeraj sanjay kale <neeraj.sanjaykale@nxp.com>
To:     Sherry Sun <sherry.sun@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
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
        "leon@kernel.org" <leon@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Amitkumar Karwar <amitkumar.karwar@nxp.com>,
        Rohit Fule <rohit.fule@nxp.com>
Subject: RE: [PATCH v5] Bluetooth: NXP: Add protocol support for NXP Bluetooth
 chipsets
Thread-Topic: [PATCH v5] Bluetooth: NXP: Add protocol support for NXP
 Bluetooth chipsets
Thread-Index: AQHZR3LOTLuCHYJIkUS2g9wvpSvRZK7cZi8AgAm1GiA=
Date:   Wed, 1 Mar 2023 15:51:52 +0000
Message-ID: <AM9PR04MB860397EC747D0F0999D1A6C6E7AD9@AM9PR04MB8603.eurprd04.prod.outlook.com>
References: <20230223103614.4137309-1-neeraj.sanjaykale@nxp.com>
 <20230223103614.4137309-4-neeraj.sanjaykale@nxp.com>
 <AS8PR04MB8404D3C45734179D80BC242092AB9@AS8PR04MB8404.eurprd04.prod.outlook.com>
In-Reply-To: <AS8PR04MB8404D3C45734179D80BC242092AB9@AS8PR04MB8404.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM9PR04MB8603:EE_|PAXPR04MB9253:EE_
x-ms-office365-filtering-correlation-id: 67a7ffcd-b643-43dc-6218-08db1a6ce063
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wOIc/30WVWAdvQOlcpypaZCU0oK2iwLJCR+Y7WTV0lE8KvnsJDEL4ot7A8ol/cnKpNqfIQI/b3++LNH77fAfftCdibXAs9uQG5YZGu4lTXPhw6N/6/Fcx2t1u3EvMFg7WybHK4LIbSc8SJSilKXO8pLy8wdsuV4+tkdgI4UUKy0T5PtWA8KgSdu2ANDiahvFiR7v5a1kaNcQBj5X1kh8KvXG0NQVT3mX2cwMS6lDoO3FNYeCsdsfTcrJZJbLj0I2giQ2O1bCr9N9+Xyu5hsFVVmjY02WsfBMjEQwhriP3Ks2x7pM141gRblJDLgVHtCrhPg0HRXJycQAp9jLPsvGfaRs9764DayQcpgcMuOnXRHD66JMKYfwkbwSwpJpE9dz+IxrENFmirwLkekNlvTH9GgyDruE89kGZ4LsFCV7qm7tPuT+CqcJAf5jQmLS0jCT7B0FxzcIG91WHGLk7r7Hn/5KN/7oGOtXDG+RvG57YdnthyqIzisc7iRepScd5fjWCqATWpiqfFh1Zi/3ruWh5VSQdUcwK0FzL/3VzQeLXIX5J6Gfec9uUJS+1mXt/WVulcGyAXcrTvQPJY9TFJlf6zHqfoG1BXN2eez7miI6rVqje5v3gt+VyJyLGDzFpjX3tGwlK6TN+QzYT5PkgHrPO+OlTg1bm9Rm7MM612HFGIH8vP8hyrLcT5iVb/+fHagLnLAF4tePn67x/WtX75XuqNTfVw7WuDbW3Uq50nCTYzI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(136003)(366004)(39860400002)(346002)(451199018)(83380400001)(86362001)(2906002)(110136005)(26005)(478600001)(186003)(9686003)(33656002)(6506007)(52536014)(71200400001)(41300700001)(921005)(38100700002)(122000001)(7696005)(5660300002)(7416002)(66556008)(8676002)(64756008)(8936002)(66946007)(66476007)(76116006)(38070700005)(54906003)(4326008)(66446008)(316002)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K3hQbnZmUytTTDV6RXBQY2VXZFBCK2t0bXgxMzR6enRhSU82YXJzc3pseU5Q?=
 =?utf-8?B?L2RtSzZZdWZHVHJvYzNzTHJkaTJVaTVSQVhjeDR1QU1jWHRXTlpNR1o2Q0NJ?=
 =?utf-8?B?RC9aWEU1b2JReG1FQ2toMGxWZXlteW5scmNEMmpTWldNSHpGR2hvVmNlU1BR?=
 =?utf-8?B?U29OaTRvWEg4M2N1M2ZMVnpMRGRjTi9wTGdWeDJ6YVJsbWRtVUVSM1lzMWpt?=
 =?utf-8?B?cGZkSFFHakV0RkV4bGFqRTZQRHNYTllpMStvckZuQ25iY0RhS1FYcWh3ZHAx?=
 =?utf-8?B?cGJlS1RBQzlGV2pCYnRhZHprWFBIbXJ2Q1NWaUUrK2kyMzdvU29hSlFZdGZu?=
 =?utf-8?B?TXIzRmh5YTJRbTNTem9sOThMS3d2Z1FUQTA0SE1XM3JETWdrWlRwb1hHc3dh?=
 =?utf-8?B?UzUrL3BzZmYvWnlvRDJlejRJSVBvZWNNd3JMZ01HQ0tBdnFDNjh2TENJaXds?=
 =?utf-8?B?SC9jWnl5RFB4U3M5WjZvaFhtMlJlRmw5cmhrYmlSM2JzdVl2WjE1a1VtNk04?=
 =?utf-8?B?UHBVaTZSRFNwNGxtcW9ENlBPQjR3MXJoOHRLbE1zeHpkdlFiMTRCVU5PYktP?=
 =?utf-8?B?TlJYUGpBM0hRMTdPa0lVcU5md3RzUklZSFdyVWN1NTJhZm5HWXgzVkNVZnNW?=
 =?utf-8?B?QnlyNzlPSnFEOUhwRFNxS0pDTlBiK1I5VThpTEFHUmJCeUlFNkRVZHJRRkRs?=
 =?utf-8?B?aXE4SWlhTzAwN1d1VEcxVms0bVc5ZHRFR3R0b1ZUcmpuSnAyMWVZS1E0NmdK?=
 =?utf-8?B?RnN6M2lrV3gvd3R2aHl6Q2hxTGsvQWlzNHJ3RkJZSWRhZEMyTTJ0aTI1VXVu?=
 =?utf-8?B?bVFpK0UweFFMWEdDemp2YmZoTVlNM0Y2R1VFWFpkNjJMWEFIdzlNSjJmZkRh?=
 =?utf-8?B?NzZDKzRxZUMvRUQzd2ZoQjJUQ1lHbUNMeVhQbjN3cnBBbVBhYVpOZTI4dXRZ?=
 =?utf-8?B?Yzlxa0tYYy81RnlJUENrTXFQdmRPaXRjOStQbGtFWXYxTzdXQUVISXQvdDJ4?=
 =?utf-8?B?ZE1MejBXbndFLy9FUXhSZHUwV1MyS0ZGb1J0bjNRT0JBN1NNRUNrT25UUWY2?=
 =?utf-8?B?QVVRUTdpYzVXODVNaWxWbkNVdmx0dnBRejN0Sm1DS1V1UXBZUG1xNnFCMmQz?=
 =?utf-8?B?MngrOWI1Y1YxMWR0Q29JdWR4cEtSU2RGbDlaTm5oOEt5c1VGMFAxczNFQnhZ?=
 =?utf-8?B?WWZURGVvcVdzbHhHbzBPc0dCQy81dEVaRnM4S3l2QUFKcnJ2VEhSdUp3ZHVj?=
 =?utf-8?B?dWZCK29qQkoyMWlxN1JoNW9TMUJjQ3JRbHIydUZnYzZ4bjdJUmNscVpEZGVq?=
 =?utf-8?B?OVNGWm5KdldJb2JibHVrMWFvZHRTVU9BTFNrbGNOUVVLU0ZXK3BvM1ZSWkNK?=
 =?utf-8?B?bTdBbm5XZWVzSnlJeUVyOXExWU9rSHZ1Y0VJRk05Wk15WExybGhJSUNueFF1?=
 =?utf-8?B?ZUZJcmljclliOVkyN0tGWnBwKzgzbkhPUmxxNzN3c1lQeUFsSHZoTndySXBW?=
 =?utf-8?B?cDJWN3N2OHRrSVVvaWNoL283NFZMay9xUEgrVHdPOFZ2VlJJZmxEYThpV1pw?=
 =?utf-8?B?eXhQV2xhY2Zjd2duRGhwVGtyeEMzNTJkcHdQVHd6M21GNE5IYmZweUN1T01Z?=
 =?utf-8?B?Q0RoU2FVV0ZZWFUrTXRsd2NsTkpZc284S1cxOFN5U3c3TGVnUnNZTW5zTkNF?=
 =?utf-8?B?ZS9HSFRIZ1YzTGhNbmhhOGRhUngyNjYyTXVpamRyL2lDNjN3SjF5allJZWwv?=
 =?utf-8?B?eEo4aEgxQjg0YWx1NUFDb0s0YXRaRGxad05hOElScGRpWkxRUktUbGdIc1hZ?=
 =?utf-8?B?ZU84OGRLYkNQb3pFQnkzNUJzUFphUmZIdnFHY2szUHFjRzgxZFFqN2ZJZkda?=
 =?utf-8?B?SVpjTTIvWnVzVElRM1VjSDNOQXRzRkMvcXQ4S0dHOWdOaGIrdFBNdGFOcDVk?=
 =?utf-8?B?S3lXb0k3eC9PcXljVENlejZIeTFkUnhRNTJ5VW5RNUFEY2xkM0NZZjFmajV0?=
 =?utf-8?B?RXZJK3RHZFpYem9VQ1gyV0Zweng3M2ZYdVRhckh5aTIzanNqb3BuSGhveFpa?=
 =?utf-8?B?QkY0cjk4Z2ZRNjNHZmtmdnBYMHIwSW9EZG9Xa01CcGVlb3RONFE0QitLZ3k2?=
 =?utf-8?B?VWRmbGk5bkw2ZWpRNDhzVzRGNCtvaFZjWmI0ZFYxMDAzUVlwanF3ZTRxY29u?=
 =?utf-8?B?SGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67a7ffcd-b643-43dc-6218-08db1a6ce063
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2023 15:51:52.5827
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BAwENoZ/ixdTEQ69+3MR4ulWoyD9+3xQdzGDvOoOpkPx8AuGk0XAUF96eiBgK4Z5Qd6TJwOGGdAGQhiKexaKG4X3/176Q4vHICAklvGdLoQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9253
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2hlcnJ5DQoNCj4gLi4uLi4uDQo+IA0KPiA+ICtzdGF0aWMgdTggKm54cF9nZXRfZndfbmFt
ZV9mcm9tX2NoaXBpZChzdHJ1Y3QgaGNpX2RldiAqaGRldiwgdTE2DQo+ID4gK2NoaXBpZCkgew0K
PiA+ICsJdTggKmZ3X25hbWUgPSBOVUxMOw0KPiA+ICsNCj4gPiArCXN3aXRjaCAoY2hpcGlkKSB7
DQo+ID4gKwljYXNlIENISVBfSURfVzkwOTg6DQo+ID4gKwkJZndfbmFtZSA9IEZJUk1XQVJFX1c5
MDk4Ow0KPiA+ICsJCWJyZWFrOw0KPiA+ICsJY2FzZSBDSElQX0lEX0lXNDE2Og0KPiA+ICsJCWZ3
X25hbWUgPSBGSVJNV0FSRV9JVzQxNjsNCj4gPiArCQlicmVhazsNCj4gPiArCWNhc2UgQ0hJUF9J
RF9JVzYxMjoNCj4gPiArCQlmd19uYW1lID0gRklSTVdBUkVfSVc2MTI7DQo+IA0KPiBTdXBwb3Nl
IGZvciBlYWNoIFYzIEJUIGNoaXBzLCB5b3Ugbm90IG9ubHkgbmVlZCB0byB1cGRhdGUgdGhlIGZ3
X25hbWUsIGJ1dA0KPiBhbHNvIGZ3X2RubGRfdXNlX2hpZ2hfYmF1ZHJhdGUuIERvbid0IHVzZSB0
aGUgZGVmYXVsdCB2YWx1ZSBpbiBkcnZfZGF0YSBmb3INCj4gYWxsIGNoaXBzIGhlcmUuDQpmd19k
bmxkX3VzZV9oaWdoX2JhdWRyYXRlIGlzIG5vdCB1c2VkIGluIHRoZSBWMyBkb3dubG9hZCBtZWNo
YW5pc20sIG5laXRoZXIgZG8gd2UgbmVlZCBpdCBhcyBvZiBub3cgaW4gVjMuDQoNCj4gPiArDQo+
ID4gKwlzZXRfYml0KEJUTlhQVUFSVF9GV19ET1dOTE9BRElORywgJm54cGRldi0+dHhfc3RhdGUp
Ow0KPiA+ICsJaW5pdF93YWl0cXVldWVfaGVhZCgmbnhwZGV2LT5zdXNwZW5kX3dhaXRfcSk7DQo+
ID4gKw0KPiA+ICsJaWYgKCFzZXJkZXZfZGV2aWNlX2dldF9jdHMobnhwZGV2LT5zZXJkZXYpKSB7
DQo+ID4gKwkJYnRfZGV2X2RiZyhoZGV2LCAiQ1RTIGhpZ2guIE5lZWQgRlcgRG93bmxvYWQiKTsN
Cj4gDQo+IEkgZG9uJ3QgdGhpbmsgaXQncyBhIGdvb2QgaWRlYSB0byB1c2UgQ1RTIHN0YXR1cyB0
byBkZXRlcm1pbmUgdGhlIEJUIEZXIHN0YXR1cywNCj4gYmVjYXVzZSBtYW55IHVhcnQgZHJpdmVy
cyBvbmx5IHN1cHBvcnQgYXV0byBoYXJkd2FyZSBmbG93IGNvbnRyb2wsIGFuZA0KPiBjYW5ub3Qg
cmV0dXJuIHRoZSBDVFMgbGluZSBzdGF0ZS4NCj4gU3VjaCBhcyBmb3IgTFBVQVJULCBzZXJkZXZf
ZGV2aWNlX2dldF9jdHMoKSB3aWxsIGFsd2F5cyByZXR1cm4gVElPQ01fQ1RTLA0KPiBzbyBoZXJl
IEZXIG1heSBuZXZlciBiZSBkb3dubG9hZGVkLg0KSSBoYXZlIHJld29ya2VkIHRoaXMgcGFydCBv
ZiBjb2RlIGFuZCB3ZSBhcmUgbm93IHdhaXRpbmcgZm9yIDEgc2Vjb25kIHRvIHNlZSBpZiB3ZSBh
cmUgcmVjZWl2aW5nIGFueSBib290bG9hZGVyIHNpZ25hdHVyZSBmcm9tIHRoZSBjaGlwLCBhbmQg
ZG93bmxvYWRpbmcgRlcgb3IgbW92aW5nIGFoZWFkIGFjY29yZGluZ2x5Lg0KDQpQbGVhc2UgY2hl
Y2sgdGhlIHY2IHBhdGNoIGZvciB0aGUgY2hhbmdlcy4NCg0KVGhhbmtzLA0KTmVlcmFqDQo=
