Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43E73596C9F
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 12:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232929AbiHQKKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 06:10:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbiHQKKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 06:10:33 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2088.outbound.protection.outlook.com [40.107.20.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B55D6580D;
        Wed, 17 Aug 2022 03:10:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SdsSTeUR4V5b8WQvzWyclkraVqKmUh/fcqixeW1nr7AoHYmllJoWIX2gnINJEwMOIG3hlwbFqkO5GW8W8gCy6uqi0ZkxD3SrUtgMMQbSSmgzU77oDvNrvraaPU5OGYPv/MePRSg89xX9rtppx8KxSzh55VKrrm6q2np8VAZwhdVG+Bp0pgjE+oftPbq+THwkQ+N3T3zPeGHki5RRor2mEHQE6Ao54BVU4Km5q8re+RvykQD11BJf2rEXKJ2hTpjbM2QgWTsnqC0rfzJDuo3w1f8OCWGRYwF22JgxShVaE+BgxjVdA1iDfR654foJBOwQLxYipLrcq+6E/jSzHWLcGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UPI6G77NHesMFpzEICz0XyvaVqEe5gPuE4yCAFnNJFc=;
 b=lFNj8Odb+nVlCq1xtN4XV4Bd9Ghv33U3JoqdWz3UZiF+HzQGLFcTdXUyDgquwc153V8hUhLkXAOumJg0W+CgKylDc7WAYhEZ45Pc5+rTv+VhDy73PzzI6MCcD+yDrg+6zv8BBVuDVLkcvd59oGg0CIGbhn9hMB5R5oBCl+t7MGmQZ3DoJn4ZZVrO9gHp5Q1CL58NJ7a4o48ptNRUe7HSffPLei8irG2jU2Jm6LhP6YCR6Kl2RPKoW3xuEcT5HzyZGLI/7Aue56RQVORTeztlmrCHIJF5GkI7ctFWslCifKi1AKVUD2PCSp5Y/g8YWkevI9K+Mb2mYJQpiYAf6qgFjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UPI6G77NHesMFpzEICz0XyvaVqEe5gPuE4yCAFnNJFc=;
 b=cV+Usdim6SAnD3P1OugpaLuqJf/VS0udb6Rteb3DmkPwnPekKeYoAhlzMpuJSPztpzOfuU05Hrw0pgWKXulaGEH6nh2UOhaMiY7C1A3/BdzAzh8p4AYDdYLnG3OKMbCoZjX2SlgLNTa8JeAxC+nNItMxhJZV5YFH1uag50NiVhM=
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by VI1PR0401MB2287.eurprd04.prod.outlook.com (2603:10a6:800:2e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Wed, 17 Aug
 2022 10:10:28 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5598:eebf:2288:f279]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5598:eebf:2288:f279%9]) with mapi id 15.20.5525.010; Wed, 17 Aug 2022
 10:10:28 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     Shawn Guo <shawnguo@kernel.org>
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
        dl-linux-imx <linux-imx@nxp.com>, Peng Fan <peng.fan@nxp.com>,
        Jacky Bai <ping.bai@nxp.com>,
        "sudeep.holla@arm.com" <sudeep.holla@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Aisheng Dong <aisheng.dong@nxp.com>
Subject: RE: [PATCH V4 2/3] arm64: dts: imx8ulp: Add the fec support
Thread-Topic: [PATCH V4 2/3] arm64: dts: imx8ulp: Add the fec support
Thread-Index: AQHYoLtRPcfKMNAKWUeX6RgO2NkehK2y+yoAgAABFiA=
Date:   Wed, 17 Aug 2022 10:10:28 +0000
Message-ID: <DB9PR04MB8106B1570E12E5AFCC861FE0886A9@DB9PR04MB8106.eurprd04.prod.outlook.com>
References: <20220726143853.23709-1-wei.fang@nxp.com>
 <20220726143853.23709-3-wei.fang@nxp.com> <20220817094708.GC149610@dragon>
In-Reply-To: <20220817094708.GC149610@dragon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5638eb90-99bc-4282-03af-08da8038b5a7
x-ms-traffictypediagnostic: VI1PR0401MB2287:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EELTgpo+1Z6BQjF9Q1Rc0v61IU39FyGswAMT1PWiG3C3hl4Bf2bUhw7OotHaw0tvj7t+KmHRrEBzCwwufLBct0397XGbIK4sob1T6MzmoXNrSrjQ1xFhuhv5Cn0rE4aUUgbnwbFls32WEul49h3kPh/AEfRe9AuTsrwZ0sGO8KLF4WJK0IXxo9UKVeTzCTP2p9vEIfR0OupGXqaTZ4O9TBVWadFaNksaESerM1xyMme0++62y7HC+l+jj+P13M/mzDDkF0sfriwulH7xg6IBfj8Oq9Dg3RzDa4gQPFn0f4PNAyMEHkVcgbG0yEqUFRVgNQzfV1MMVBT9In6d7ygJzLXn0oBiB/JrKYWNMwhI1ad80wdGV9GIdIphNlDrs6Mi/TByhRXQtxbwLxZA1bpcgYnjonNfDw1k4CJgaFMS8CMUT/FTTIDExrLPd1SXCJJ/yJr/PZcHe/naaJIt1AyUgxCgLvaVS/xUvr1m7oTUM5VI3PXZrXunjYCoHYXiXV0JcM8mNHS01U/0gYsbjJvhglIi2rWp3zjQ+yevrEuX92Phl2Z6rQT6/YCZNowlwzMaEaN9eaI/NiisiMyvGK8GrNMyMjwv/PR4JcHjiqj8/ytYOCB57oMNuH7RRK4V0o+vQNdeF9dIbH8ev6r9L2FU58BYQO8w2dmMDut5K5FICMAbz8LPfqZVpEdAL2fG6/X4ZQy5sMIEvbI48PSPV+lrprENHTUWFtnfk4xXGhRcbLGS7qB3I1wY3j1LPcKf7jcS1pE7Az+FhVBtS2OqjhozT46WqbOv63tbqtc5O0KbP/Xs+kx8+g9glavYCzPbo2rIUlnxl/V+py3vDIPq/8I/z+8aHgnZhnbfcdFtH/I0RNc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(376002)(39860400002)(396003)(346002)(6916009)(44832011)(316002)(64756008)(76116006)(55016003)(8676002)(41300700001)(4326008)(66476007)(2906002)(66446008)(66556008)(83380400001)(54906003)(186003)(66946007)(7416002)(122000001)(26005)(9686003)(7696005)(38100700002)(53546011)(5660300002)(38070700005)(71200400001)(8936002)(86362001)(478600001)(6506007)(52536014)(33656002)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?NjNFV1pNSHBQREZyNloxdjlHM1YwZmVEVlVxY0tkdFFHWVR3ZlVuaFpxZEZp?=
 =?gb2312?B?Y2NETWhXZXZ4S0h4djNaTWpiRlMwNnloVk90S214VmZPZ242N1NZelVtdlhq?=
 =?gb2312?B?dDB1MkJBbWtpYjUwUkJaU2dMdnpjc0lIWTR5VXVobnVVUCswOXp4WEtRTG81?=
 =?gb2312?B?dC9aN2ZRSUtCSmQ5RUxZZ2tCdm1MNmpGaDlXZi9MY3pFblFmR1RLYUNvb25V?=
 =?gb2312?B?WHl2S2tJYmNET0tnbTlPQjZMRDBJYnlsSHgzOE5DamhMOUtrRjZ2QXQ3cXNO?=
 =?gb2312?B?ejhGNFhHVVhCUnhYbnlBUmxsS2QvczJERmZML0N2dTY4MXA5QkVvWXVVdDVX?=
 =?gb2312?B?blVZaXE3a0hDaVJDVk9SUHF5ME90QmhkTlJHdEVQSmsrM3E5YjlLcW84R3Fn?=
 =?gb2312?B?TFhRNW5DeTNIOEtUUCt6MFByOWc5c09YMmU0Uk1Jd1d0QkQwYzY3aUVGMXpJ?=
 =?gb2312?B?UTNxWC9OWDNsazQvVTh5WjZGTVk4aVFjR1BFQi9RUW1rZE1LbDBGQjNyZjJr?=
 =?gb2312?B?M3EvaWtwVkdCWEhXQm5CRytUc0RlaUxHWGNPMFBmTyttT01nbGxYUTZaUks0?=
 =?gb2312?B?RGgzNitFWkUwWmUzSzZnZzJyZHM3Y1VVUEZiU0xZaEVFdGdNbERoTEtQRngw?=
 =?gb2312?B?WlpaYXJEYVQwbkxMdlNaUnRrWGF0YnhJRHJCblVaV0tPNUpCVnN0d1ZGWjg1?=
 =?gb2312?B?bUtsODJjdkRwUFJHU3dXUGtmT1RDeDhINFRMR0hEYVlVdnB4RC9ud3RxZWFV?=
 =?gb2312?B?ZHFaWnUxNkdlOWcwWUVjZFJNZjc5ZWF2M2NkZHVjVGJNME1GN3ZFd1puK0Vj?=
 =?gb2312?B?MHVvSzlNTFBoVi9MdUYyd2RzVG5pMVNrTUJKVnFPN0ljZ3NsZUlQWEZNNzFv?=
 =?gb2312?B?TWp3WnRoU2pPVUhRRCtsditYZGFjOXBXTlYreDM1dlFlcjZDQ3MzR2tyaUxO?=
 =?gb2312?B?ZFFMeWo4cmZJSjU1Mk9LaG55VlQwbjJ5OG4reGJOckJ0amtLanpMUEcwcHgy?=
 =?gb2312?B?Q1c0eUFzblh1QUV4SFRKL0RTY3VvSEx1MHZadkZjNUhHMjhyZjlvMUpaZkRG?=
 =?gb2312?B?MVk2U0lIa0hvMyt0MDFNeWFZL2I2SjlRSDJOSjhxY0lieUxEMFBNTjJMVDBo?=
 =?gb2312?B?RkhvSXk1NDB4SUdVRW5RbTVnMUI0bjcyTUtFb1hjR01teTNUV1JmYkIvL3pW?=
 =?gb2312?B?YUN1R1IvNkZTTjU5eXlRcWo5Z2RSRkRDWEZ5LzVFL3VkVTMycjcrcEdQRGI1?=
 =?gb2312?B?R2xJcUxWSWY3LzFsVkJJOWJveE5zWEg1Ly92MmxTMGZYMVp0MVFiL3dvRi9s?=
 =?gb2312?B?aDE1Mm5HT05ESzRWTVRDMjFOOFFTZXNIOGM2Z2hWMHR5SHpZd1JIS2tKWm9p?=
 =?gb2312?B?UzNtTlprNUY5Sm5ibDBYbkREWFIyQzhkQnFWNlpmUEpQK2hPdXBHMExNc3Mv?=
 =?gb2312?B?WlMwYzFiWmFFNEErVVlVTkpSejUyKzRpakU1eUZDQUpkMjFzOE5SSStHSzlJ?=
 =?gb2312?B?YmROTGg3dVNQaEwxQnpjMnUySVUvcDdYUW9FUHBDOWVqdGRNYnEyVm13V05T?=
 =?gb2312?B?Unl0U2lYd2Y0ekI5V0RvN1NmUDBwQ2JTQkFIWTk3Zm5IZHBJUmVTZWcwazlm?=
 =?gb2312?B?UGxmMCs0UWZVMjM2a0Q2YmFCQ2VXb3k4ZjJXTEpWcWxqNGcxa0wzRWZxdEhZ?=
 =?gb2312?B?Tk9ZZ2RLS1QrbVBCUVYwMUZGNjlNY0Y2blNlQnNySGZZRUdTZk55aTJlbHNK?=
 =?gb2312?B?blpGQ2tZV2pKVXF6SDh1Z2FGSTR5eEpWZGQ4Ym40MmpKSkdRWHZ3cllFYlhy?=
 =?gb2312?B?dnNtQk5paVl3QXFoU0RkWnEwclB1ekcvanZMaFlteHk4a214eFNZclZZV3E2?=
 =?gb2312?B?MzlLa2ZBZmJhTlBPMVEvVXBSNkFEa1RjdHlBYnRtYldaV0lHWFBnem1wL09X?=
 =?gb2312?B?K3gvMzNWaTlUNVpua1RoRFhPNVB0QnFXT3VyZWd0T1JQelRleWQrTEVsMDV3?=
 =?gb2312?B?Qml0QWRyMXRXTWozcmIwWnMrOE0wcUNQdHVnL1pRbnNSc1hsMDh6bGVMQWJC?=
 =?gb2312?B?dldHblZWcHk3cGFNTmRkZDJLUnhxT09VeFpZbjdnbFVnWnEzMEJVQ3cyOVpX?=
 =?gb2312?Q?1hE4=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5638eb90-99bc-4282-03af-08da8038b5a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2022 10:10:28.0334
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tRTuFYE0MDcrXG1kOtwOGwzwSg3oF7HPb7UR/vM0NKC+uZFvrGC/en3lvIzb25lMwiyLsaD/Lcb6aA9azU5UvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2287
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU2hhd24gR3VvIDxzaGF3
bmd1b0BrZXJuZWwub3JnPg0KPiBTZW50OiAyMDIyxOo41MIxN8jVIDE3OjQ3DQo+IFRvOiBXZWkg
RmFuZyA8d2VpLmZhbmdAbnhwLmNvbT4NCj4gQ2M6IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGVkdW1h
emV0QGdvb2dsZS5jb207IGt1YmFAa2VybmVsLm9yZzsNCj4gcGFiZW5pQHJlZGhhdC5jb207IHJv
YmgrZHRAa2VybmVsLm9yZzsga3J6eXN6dG9mLmtvemxvd3NraStkdEBsaW5hcm8ub3JnOw0KPiBz
LmhhdWVyQHBlbmd1dHJvbml4LmRlOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBkZXZpY2V0cmVl
QHZnZXIua2VybmVsLm9yZzsNCj4gbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsga2VybmVs
QHBlbmd1dHJvbml4LmRlOyBmZXN0ZXZhbUBnbWFpbC5jb207DQo+IGRsLWxpbnV4LWlteCA8bGlu
dXgtaW14QG54cC5jb20+OyBQZW5nIEZhbiA8cGVuZy5mYW5AbnhwLmNvbT47IEphY2t5IEJhaQ0K
PiA8cGluZy5iYWlAbnhwLmNvbT47IHN1ZGVlcC5ob2xsYUBhcm0uY29tOw0KPiBsaW51eC1hcm0t
a2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmc7IEFpc2hlbmcgRG9uZyA8YWlzaGVuZy5kb25nQG54
cC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggVjQgMi8zXSBhcm02NDogZHRzOiBpbXg4dWxw
OiBBZGQgdGhlIGZlYyBzdXBwb3J0DQo+IA0KPiBPbiBXZWQsIEp1bCAyNywgMjAyMiBhdCAxMjoz
ODo1MkFNICsxMDAwLCB3ZWkuZmFuZ0BueHAuY29tIHdyb3RlOg0KPiA+IEZyb206IFdlaSBGYW5n
IDx3ZWkuZmFuZ0BueHAuY29tPg0KPiA+DQo+ID4gQWRkIHRoZSBmZWMgc3VwcG9ydCBvbiBpLk1Y
OFVMUCBwbGF0Zm9ybXMuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBXZWkgRmFuZyA8d2VpLmZh
bmdAbnhwLmNvbT4NCj4gPiBSZXZpZXdlZC1ieTogQWhtYWQgRmF0b3VtIDxhLmZhdG91bUBwZW5n
dXRyb25peC5kZT4NCj4gPiAtLS0NCj4gPiBWMiBjaGFuZ2U6DQo+ID4gUmVtb3ZlIHRoZSBleHRl
cm5hbCBjbG9ja3Mgd2hpY2ggaXMgcmVsYXRlZCB0byBzcGVjaWZpYyBib2FyZC4NCj4gPiBWMyBj
aGFuZ2U6DQo+ID4gTm8gY2hhbmdlLg0KPiA+IFY0IENoYW5nZToNCj4gPiBBZGQgUmV2aWV3ZWQt
YnkgdGFnLg0KPiA+IC0tLQ0KPiA+ICBhcmNoL2FybTY0L2Jvb3QvZHRzL2ZyZWVzY2FsZS9pbXg4
dWxwLmR0c2kgfCAxMSArKysrKysrKysrKw0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMTEgaW5zZXJ0
aW9ucygrKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQvYm9vdC9kdHMvZnJlZXNj
YWxlL2lteDh1bHAuZHRzaQ0KPiA+IGIvYXJjaC9hcm02NC9ib290L2R0cy9mcmVlc2NhbGUvaW14
OHVscC5kdHNpDQo+ID4gaW5kZXggNjBjMWIwMThiZjAzLi4zZThhMWU0ZjBmYzIgMTAwNjQ0DQo+
ID4gLS0tIGEvYXJjaC9hcm02NC9ib290L2R0cy9mcmVlc2NhbGUvaW14OHVscC5kdHNpDQo+ID4g
KysrIGIvYXJjaC9hcm02NC9ib290L2R0cy9mcmVlc2NhbGUvaW14OHVscC5kdHNpDQo+ID4gQEAg
LTE2LDYgKzE2LDcgQEAgLyB7DQo+ID4gIAkjc2l6ZS1jZWxscyA9IDwyPjsNCj4gPg0KPiA+ICAJ
YWxpYXNlcyB7DQo+ID4gKwkJZXRoZXJuZXQwID0gJmZlYzsNCj4gPiAgCQlncGlvMCA9ICZncGlv
ZDsNCj4gPiAgCQlncGlvMSA9ICZncGlvZTsNCj4gPiAgCQlncGlvMiA9ICZncGlvZjsNCj4gPiBA
QCAtMzY1LDYgKzM2NiwxNiBAQCB1c2RoYzI6IG1tY0AyOThmMDAwMCB7DQo+ID4gIAkJCQlidXMt
d2lkdGggPSA8ND47DQo+ID4gIAkJCQlzdGF0dXMgPSAiZGlzYWJsZWQiOw0KPiA+ICAJCQl9Ow0K
PiA+ICsNCj4gPiArCQkJZmVjOiBldGhlcm5ldEAyOTk1MDAwMCB7DQo+ID4gKwkJCQljb21wYXRp
YmxlID0gImZzbCxpbXg4dWxwLWZlYyIsICJmc2wsaW14NnVsLWZlYyIsDQo+ID4gKyJmc2wsaW14
NnEtZmVjIjsNCj4gDQo+IFNpbmNlIGlteDh1bHAtZmVjIGlzIGNvbXBhdGlibGUgd2l0aCBpbXg2
dWwtZmVjLCB3aGF0J3MgdGhlIHBvaW50IG9mIGhhdmluZw0KPiBpbXg2cS1mZWMgaW4gdGhlcmU/
ICBJdCBjYW4gYmUgZHJvcHBlZCwgSSBndWVzcz8NCj4gDQpBY3R1YWxseSwgSSBkaWQgZHJvcCB0
aGlzIGluIHZlcnNpb24gMS4gQnV0IHdoZW4gSSBhZGRlZCB0aGUgaW14OHVscCBjb21wYXRpYmxl
DQpwcm9wZXJ0eSB0byB0aGUgZnNsLGZlYy55YW1sLCB0aGUgbWFpbnRhaW5lciBleHBlY3RlZCBp
bXg4dWxwIHRvIGJlIGNvbXBhdGlibGUNCndpdGggaW14NnVsIGFuZCB3aXRoIGlteDZxLiBUaGUg
cGF0Y2ggb2YgZnNsLGZlYy55YW1sIGFzIGZvbGxvd3M6DQoNCi0tLSBhL0RvY3VtZW50YXRpb24v
ZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvZnNsLGZlYy55YW1sDQorKysgYi9Eb2N1bWVudGF0aW9u
L2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2ZzbCxmZWMueWFtbA0KQEAgLTU4LDYgKzU4LDExIEBA
IHByb3BlcnRpZXM6DQogICAgICAgICAgICAgICAtIGZzbCxpbXg4cXhwLWZlYw0KICAgICAgICAg
ICAtIGNvbnN0OiBmc2wsaW14OHFtLWZlYw0KICAgICAgICAgICAtIGNvbnN0OiBmc2wsaW14NnN4
LWZlYw0KKyAgICAgIC0gaXRlbXM6DQorICAgICAgICAgIC0gZW51bToNCisgICAgICAgICAgICAg
IC0gZnNsLGlteDh1bHAtZmVjDQorICAgICAgICAgIC0gY29uc3Q6IGZzbCxpbXg2dWwtZmVjDQor
ICAgICAgICAgIC0gY29uc3Q6IGZzbCxpbXg2cS1mZWMNCg0KRm9yIGNvbXBsaWFudCB3aXRoIHRo
ZSBmc2wsZmVjLnlhbWwsIHNvIEkgYWRkZWQgdGhlIGlteDZxLWZlYyBpbiB0aGUgbGF0ZXIgDQp2
ZXJzaW9uLiBBbmQgdGhlIHBhdGNoIG9mIHRoZSBmc2wsZmVjLnlhbWwgaGFzIGFscmVhZHkgYXBw
bGllZCB0byB0aGUgDQp1cHN0cmVhbSBrZXJuZWwuIFRoZXJlZm9yZSwgSSB0aGluayBpdCBkb2Vz
IG5vdCBtYXR0ZXIgaWYgdGhlIGlteDZxLWZlYyBpcw0KYWRkZWQuDQoNCg0KPiBTaGF3bg0KPiAN
Cj4gPiArCQkJCXJlZyA9IDwweDI5OTUwMDAwIDB4MTAwMDA+Ow0KPiA+ICsJCQkJaW50ZXJydXB0
cyA9IDxHSUNfU1BJIDEwNyBJUlFfVFlQRV9MRVZFTF9ISUdIPjsNCj4gPiArCQkJCWludGVycnVw
dC1uYW1lcyA9ICJpbnQwIjsNCj4gPiArCQkJCWZzbCxudW0tdHgtcXVldWVzID0gPDE+Ow0KPiA+
ICsJCQkJZnNsLG51bS1yeC1xdWV1ZXMgPSA8MT47DQo+ID4gKwkJCQlzdGF0dXMgPSAiZGlzYWJs
ZWQiOw0KPiA+ICsJCQl9Ow0KPiA+ICAJCX07DQo+ID4NCj4gPiAgCQlncGlvZTogZ3Bpb0AyZDAw
MDA4MCB7DQo+ID4gLS0NCj4gPiAyLjI1LjENCj4gPg0K
