Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B754247693F
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 05:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231816AbhLPEwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 23:52:43 -0500
Received: from mail-eopbgr10051.outbound.protection.outlook.com ([40.107.1.51]:47701
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231710AbhLPEwn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 23:52:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VC+1s93cPTGrzEWvxoR1Xzz1yyFWP+dsg3rahdjKgrzQJk/spAkpZwnlj29yUcZoAokkGtLdCR4h3+56DXVh/JtSNqgpwEtq3FW/tH1rQkp3HDWraAYgMliPFRZSljho3a9wrbaKffKroSUMmCERAUTQQvv57qf9wdPniQj3DxRzksoB8BkMxfanP2sbIS328z7kdf6CbaFfs8kY7IToZHkmhhW4STAekytUnc9VMwNDSDJCd7T9xYKmhzbMoqbnZdOuvmtNBzjWknrRE+t7RaWe12Mk5v+Q7n9pR1uw6+dBU2gYyyH1HwuViA1ZeAMPKzCpfTPgTJoFnqN72+Yqsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T2ZNv1e8wS80Cl693lRQkGIPHVp0RcOFxNkxoHUPzjM=;
 b=V7GvKtlRS9Xiffqk4R+0dgKDlD6netcuI70HoHDPkXNQ/q0L4nv+6lqwJLG67nw6zIURq9e+vSEH5NOVmpRsLdeK1SNccNsXzmfKbF5oJO6uI3siLJjpguO5G5Dcqnp2JL3cg6dm/p6SqAliaY2IEUBpSh+41gmm/Wa5r5MAjubWYse2IUVg4d8dLMANlCch5S9Q4GnAwyCOGdqvy7XtDvSw0uDJOV+7vPkb2s32DlQupoXf1A5k62wCbn3V8rTUPHA69TCut+tdMLmCOEGk8nrhsKmJueUZHD7Gsi3cPgfn2P1wFZCY3BhiVKC8r5f0BmeEfjg/zL32or6hdHlArQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T2ZNv1e8wS80Cl693lRQkGIPHVp0RcOFxNkxoHUPzjM=;
 b=MQ9ldGFW/21laQq17nBtKkSLlhiyKnl3Hgk9IzpRzBFwQqvLFLR6eJAWbcEwbiUBFq4yOWANG1heOao24YxMyPaoww3CKTOt33iJNxAPIkI7ls1PpApd9DbRg7xkq2v+ZF9pJHMxVEWSXvDOoOolbjHRYYRF3F17VD77MuGVw/I=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB3PR0402MB3705.eurprd04.prod.outlook.com (2603:10a6:8:c::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Thu, 16 Dec
 2021 04:52:39 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::c005:8cdc:9d35:4079]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::c005:8cdc:9d35:4079%5]) with mapi id 15.20.4778.018; Thu, 16 Dec 2021
 04:52:39 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Francesco Dolcini <francesco.dolcini@toradex.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next 3/3] net: fec: reset phy on resume after power-up
Thread-Topic: [PATCH net-next 3/3] net: fec: reset phy on resume after
 power-up
Thread-Index: AQHX8aMlzfPRCsnvV0CLXNvSxG+k56w0jIlA
Date:   Thu, 16 Dec 2021 04:52:39 +0000
Message-ID: <DB8PR04MB67951CB5217193E4CBF73B26E6779@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <DB8PR04MB679570A356B655A5D6BFE818E6769@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YbnDc/snmb1WYVCt@shell.armlinux.org.uk> <Ybm3NDeq96TSjh+k@lunn.ch>
 <20211215110139.GA64001@francesco-nb.int.toradex.com>
In-Reply-To: <20211215110139.GA64001@francesco-nb.int.toradex.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 20286abc-9d9f-48eb-a797-08d9c04fe308
x-ms-traffictypediagnostic: DB3PR0402MB3705:EE_
x-microsoft-antispam-prvs: <DB3PR0402MB370560F16816B35C1473E64EE6779@DB3PR0402MB3705.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jDP5R4GEaEja8wXuwmuFoSokM4uVClsi29kYVOFnD8r8pTMNcxYLxQEQnWN8N+jQZ8MlKlxW6hC+tf+Ol8sUjDOWxjJQS1dEOZiknBSv5h45CIDzQ4rPE3HseAFPuln3tJcDa+bVE2FQ38KlewCCggh//PKb0F6QdVLOalliq+V3IGrZonIp9ZZhmZI1duDID9p3wW1sutmPSasyBabvyOJprstBbsk/36h2Lk8LupwiIlkd3utTaJsWLyf85Js926E0G20IYD8dGiYqUZ0wFZduAbEC+GlqbhwxUxxlKbKj6hImaujlt4O0CobP4JGq3L35fREyf2SQNawmz3GC1oMTFO9bZmAaF/sHgk33riAp4td6jnJ1SO2Pvf1WUys72bDJ8mkKsDQdYOpA44eIn5hs0gWb7Q3z+GNGZrASbEiKbBK6RxPrKiDKI27B//Ux4QO8+nI28MYhA3u5T3ejDc0trx1NEBhfIsgzwHtpuoZtDoNNlRf/ICEak30Hpe8wv3+HAJx/uXXD8irnjCb3zE2ahFQwsCXVeI32mUcnUBE7cp02c0dowVssub1eQv/P++YkaK5AXaRGySN1tB9fTU+9sz0B0YHFbeci5MxwRaJAaZksLCOBWy+hEbnwLVCP2IORYxDxoFTPaS7MvDhRE5F1LVeVxbntLcQ01d6sPM4yoTTsNSPznlpO4NTjJiWCWM/BlovunsugfbeFK4GueA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(54906003)(66446008)(33656002)(86362001)(83380400001)(71200400001)(316002)(66946007)(66556008)(66476007)(64756008)(38070700005)(52536014)(186003)(9686003)(122000001)(38100700002)(110136005)(7696005)(53546011)(8936002)(55016003)(7416002)(6506007)(8676002)(5660300002)(508600001)(76116006)(2906002)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?YUsxcUUvWGlWUXM0aFlHdG9vOVQ4RXR4TEVsUk4vR2NVVXo1YVBQd3JVTVVN?=
 =?gb2312?B?MU1VRjhZdFpKeXpVTnE4dkVoVTBHaTB4c1RjQ3RDSU1TTzNtWEtiSTdLbGJu?=
 =?gb2312?B?VFF4MUIwM3ZCYkk5TUQraE5FOVkyOHZTL05Mck1vQyt6a0NYcWFUQ2c2c1Zk?=
 =?gb2312?B?SFBpajUyczBLVFBIL0M2RVkzRXZUakg2TjVOZENiSElDeitScFhudTdla1Fl?=
 =?gb2312?B?dnYwemRRL0pvdFdkVGlrbWcxNXI0QlBZZTM3L2N6bGNkZ2FvRVo4em1vaWJF?=
 =?gb2312?B?RUZHemlTT2ZmMHQ5ZEJTcndta2ZQdkxyc29qU0pERzhwUktOK05BNnFtbDFx?=
 =?gb2312?B?dWZRSXA3ZmI5NVZ0L2daT0J6dXFrdWppSUEzS3MyVE1KTUFNenJrNmJ3UW5R?=
 =?gb2312?B?azRZUEc4NDZSQS83YWdpRGdzN1B6WnlpdHU5SWxkOXRkMS93aVFVendzM01h?=
 =?gb2312?B?eEFlRkZiR1Q1Y0pBbFVuUGhvRTZqNGZzQ3ltNmZwbmNiYmdDT1UvL0ZHSmJa?=
 =?gb2312?B?WmxqRzVqblRpUHFlYnczOFNFQXIvMms0cXY4NTVoTkg0dmF2UFN3N05FZlRl?=
 =?gb2312?B?bWJRZGZqUnlrRWd0cS83dU5uSEI1UW5Xc08zUCtxT2hrNDdDdDZYNjk1ZytP?=
 =?gb2312?B?TnNxLzMyZTRuRHJCM0c1WUp0dWpCL2dhdWdBcm1jUVdPU0tVUlAwa0Vsd3NT?=
 =?gb2312?B?WHV4bFlaNy9LUzlLODhXME9haktaMWxIcFdPeWkwdldWQVRaUHJCTjRLUGV1?=
 =?gb2312?B?MTJGZitGcE1BZ0VWbDZUSmpHeTNLUUhVZVdNRmIvMWJqeHU0ODB1MTJjOHVH?=
 =?gb2312?B?dHNxZWx6RVpVZjg5OW1FVkpGK1hzOEtEbllvUjQ0R2VyekQvYnRqUXg3bFgz?=
 =?gb2312?B?SXdMY1orN3d6Q2taVk5vTFFyRVRxVC9ROTV4QXdpalFpSzFUK1cvYTgycnhL?=
 =?gb2312?B?MnlvZWxEeHNFWlRXUlVpT2lEdThMdlVXbEFoSkJ6UWhoU1BabmZUVXVNaFRk?=
 =?gb2312?B?dXI0dVhSRVdBYkVsdzMrdG1jaU5Ob2c5cGVGeU5XL1czbFBmWUR3U3l0aHJ4?=
 =?gb2312?B?UDFsOGF3Z2tSK3pwYXdzMFRieWdLT29oZ0ROazB4T3VLZDRGdWJkSGNGaUpN?=
 =?gb2312?B?NlhrcW0xL1NIbDhvbUpWeURVUVNIclh1VW9ScUtRcXd0SDZHcldYRXhieVZL?=
 =?gb2312?B?cHR1T1c2WmdVYldqTkJoeUhacTlPRzdSWGQrTm90Vmo2enVLbHVtSU1Zd3cx?=
 =?gb2312?B?R1RxQlo0Tk4xMVpwR2p3b21vWWRadjB4a1ZiZmRGMmlDZ1NlemRCbUFxa3Rl?=
 =?gb2312?B?aytyL1A0cFZSeHVvdkdCK3ExMDhORElMZjRSU3hQTDFJKzdSbDlXZUJoSzdw?=
 =?gb2312?B?K3FQTTk5dnZacU92bzZCcUROYytSclFHRDZEZFRkdms3cnpJbnpjWHVnNlNW?=
 =?gb2312?B?S1E4ZzNYUGlpck1DbjR5UTdFdU5BRTBoL0dmRFBuY3FINFlaYklKWkFha1hU?=
 =?gb2312?B?dmlrTlhjWFpVVlBselFlV1o4Y0x0MnZVZktsYTdqQTBWS2NkNkorMmZzMUU0?=
 =?gb2312?B?c0pxb29RVGJtaHdJc1RGU3ZYUklHOGRkczJqd2J3T2o4L2N6V2s4a2ZtM2hr?=
 =?gb2312?B?dUd0UWpiZzBNbktyQ283MklqUWUvT0d6aTBFbTBIRE5JMkFaUUl0SWNvZU5W?=
 =?gb2312?B?NHBWYitpYlkxbVRGN0FMOFg5YVlBZDEzUkc3MTlHWGtLaDJ5QmptUllScFNI?=
 =?gb2312?B?Q2ZMeTdZY2U1ZHhJT211QmJvb0ZieHN0ZFk5Ukpocmx1RzIxcFFXN0lvUk1h?=
 =?gb2312?B?MHMveE1aM2JYMGlzR1NycXN0OEk1QUhSWmNhWFhrd0lRUmVJZmRKcFU1djZr?=
 =?gb2312?B?MEljbmVMMlM2MHFxVVdtR2dTZTBSV05NK2QyazhBZkEwKzg3QUJHUzcrYzRt?=
 =?gb2312?B?eXlicmd4V3N5eEt2Z1o2bERtZjlZUC9NQi8zYkZka3ZzQzlsb1VuY2tiSm5Y?=
 =?gb2312?B?ZUNKQWk2Z1VUQ3ErSGladDJaVG16NzdrSlh3WDlINVVYR1FFWjBQTjBYc1RY?=
 =?gb2312?B?b3dKVjN1aklqRzFxU2RiK2JmTjEvQjdKeHFnbFJGaHpndk1tYlpYVU1lWmlF?=
 =?gb2312?B?V2haRjdCWjFPcDNZamRBYi9ITmJjY2pPYzE5RGpydDFCVUU0ZWMrSDc5K1lo?=
 =?gb2312?B?VWc9PQ==?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20286abc-9d9f-48eb-a797-08d9c04fe308
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2021 04:52:39.2335
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BYm6qMeBM1oJpxdKIi1DAldrAf3zwyFgVRqaMVUPeIy7Q5dRBi8JSnZ9gWkcitl9azieaimbP7zKc1xNx8bzIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3705
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEZyYW5jZXNjbyBEb2xjaW5p
IDxmcmFuY2VzY28uZG9sY2luaUB0b3JhZGV4LmNvbT4NCj4gU2VudDogMjAyMcTqMTLUwjE1yNUg
MTk6MDINCj4gVG86IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD47IFJ1c3NlbGwgS2luZyAo
T3JhY2xlKQ0KPiA8bGludXhAYXJtbGludXgub3JnLnVrPjsgSm9ha2ltIFpoYW5nIDxxaWFuZ3Fp
bmcuemhhbmdAbnhwLmNvbT4NCj4gQ2M6IFJ1c3NlbGwgS2luZyAoT3JhY2xlKSA8bGludXhAYXJt
bGludXgub3JnLnVrPjsgRnJhbmNlc2NvIERvbGNpbmkNCj4gPGZyYW5jZXNjby5kb2xjaW5pQHRv
cmFkZXguY29tPjsgUGhpbGlwcGUgU2NoZW5rZXINCj4gPHBoaWxpcHBlLnNjaGVua2VyQHRvcmFk
ZXguY29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgSm9ha2ltIFpoYW5nDQo+IDxxaWFuZ3Fp
bmcuemhhbmdAbnhwLmNvbT47IERhdmlkIFMgLiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+
Ow0KPiBIZWluZXIgS2FsbHdlaXQgPGhrYWxsd2VpdDFAZ21haWwuY29tPjsgSmFrdWIgS2ljaW5z
a2kgPGt1YmFAa2VybmVsLm9yZz47DQo+IEZhYmlvIEVzdGV2YW0gPGZlc3RldmFtQGdtYWlsLmNv
bT47IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCBu
ZXQtbmV4dCAzLzNdIG5ldDogZmVjOiByZXNldCBwaHkgb24gcmVzdW1lIGFmdGVyDQo+IHBvd2Vy
LXVwDQo+IA0KWy4uLl0NCg0KPiBPbiBXZWQsIERlYyAxNSwgMjAyMSBhdCAxMDoyNToxNEFNICsw
MDAwLCBKb2FraW0gWmhhbmcgd3JvdGU6DQo+ID4gQXMgSSBtZW50aW9uZWQgYmVmb3JlLCBib3Ro
IG1hYyBhbmQgcGh5bGliIGhhdmUgbm90IHRha2VuIFBIWSByZXNldA0KPiA+IGludG8gY29uc2lk
ZXJhdGlvbiBkdXJpbmcgc3lzdGVtIHN1c3BlbmQvcmVzdW1lIHNjZW5hcmlvLiBBcyBBbmRyZXcN
Cj4gPiBzdWdnZXN0ZWQsIHlvdSBjb3VsZCBtb3ZlIHRoaXMgaW50byBwaHkgZHJpdmVyIHN1c3Bl
bmQgZnVuY3Rpb24sIHRoaXMNCj4gPiBpcyBhIGNvcm5lciBjYXNlLiBPbmUgcG9pbnQgSSBkb24n
dCB1bmRlcnN0YW5kLCB3aHkgZG8geW91IHJlamVjdCB0bw0KPiA+IGFzc2VydCByZXNldCBzaWdu
YWwgZHVyaW5nIHN5c3RlbSBzdXNwZW5kZWQ/DQo+IFNlZSBteSBhbnN3ZXIgdG8gQW5kcmV3IGFi
b3ZlLCBpbiBzaG9ydCBhc3NlcnRpbmcgdGhlIHJlc2V0IHdpdGhvdXQNCj4gZGlzYWJsaW5nIHRo
ZSByZWd1bGF0b3Igd2lsbCBjcmVhdGUgYSByZWdyZXNzaW9uIG9uIHRoZSBwb3dlciBjb25zdW1w
dGlvbi4NCg0KQXMgSSBjYW4gc2VlLCB3aGVuIHN5c3RlbSBzdXNwZW5kZWQsIFBIWSBpcyB0b3Rh
bGx5IHBvd2VyZWQgZG93biwgc2luY2UgeW91IGRpc2FibGUgdGhlIA0KcmVndWxhdG9yLiBBdCB0
aGlzIHNpdHVhdGlvbiwgaWYgeW91IGFzc2VydCByZXNldCBzaWduYWwsIHlvdSBtZWFuIGl0IHdp
bGwgaW5jcmVhc2UgdGhlIHBvd2VyDQpjb25zdW1wdGlvbj8gUEhZIGlzIHRvdGFsbHkgcG93ZXJl
ZCBkb3duLCB3aHkgYXNzZXJ0IHJlc2V0IHNpZ25hbCBzdGlsbCBhZmZlY3QgUEhZPyANCiANCkJl
c3QgUmVnYXJkcywNCkpvYWtpbSBaaGFuZw0K
