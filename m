Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B722263D4AB
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 12:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232530AbiK3Ldo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 06:33:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232606AbiK3LdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 06:33:13 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2084.outbound.protection.outlook.com [40.107.7.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 696327B600;
        Wed, 30 Nov 2022 03:32:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TcXUu+wRHFh1kFhSqv/L0EcxpaTODnuaaW2H/2J18cpYsOKyAhLJWaFH5IgIyLBv/63NlNH+/4zWiIXiCjyt4mt8xyN6IsKO605rFn+ISlw29oT+G0bo+VaNJb8UeyettBqr0j+LsflRlUwBORaHHnsK/BUwtWclA9UTxmoMOwmWUH0whSl5UIHYamAgM28OFWxR/CS68tTk18xux/rwMRr2u2PEkNNqU6AMueGXBkVaMn3//zya3xa9CGUWfTwxFR31uuLWYmIgmKvlbKDHXE9I1EIvka6hGkBN4VWGjMEH6yLsdtGfm1RFQj7s2p8uFcVshiYYnzAbVOqxyBmDag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VwFkDZUa49rGEiyQxz/1PMwzhGhE6/8l+nkHjaxmwvs=;
 b=jRW/yBBhtnmQ26Yb/JvAprIc8izgMP0pEdHaWm3u9rGby1D92Kiwm8UskW5gTSosL5UPGDHDIz4iQrwyRoOFmzVeBowGro5f4n179yf6z+rDAUA3toqMtJkRA0DbHSCp14p0ZNj39XS0LHJKdFrk2CH9Ew+j0yenGd3MlQNtI6DCNMZBo4FQ5YJMu0RzQiSRBnpRqPAa/AYd9CbhWtqGXBohvFFbHb2ZPIj+tkC9w7KqgUt5rkIMlYJwdtDtngUk3wDBqOuS42rJBEh+CTpHlibqwgK3ZIahQCTDDChUrTX7z/IYA7L4S/MyufeicrcigqSXrJvuVMUvmM3YPaIr/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VwFkDZUa49rGEiyQxz/1PMwzhGhE6/8l+nkHjaxmwvs=;
 b=bAORCEhSlzvElDJ++2jTHUU0PJPLozJGbtycpxhKwFsaJydkP/bdzKYP8yfLQTnFoumuP3m36n/TfT5RUuKOKfxm38GdsNuOIbyvc+pIGp92EUVh/kyPWkBdpSno9ctj0Y2aAQLWBKyW0+DIYn96lyVUUg6o/exLLvBLEdH0j3c=
Received: from HE1PR0402MB2939.eurprd04.prod.outlook.com (2603:10a6:3:db::18)
 by VE1PR04MB7213.eurprd04.prod.outlook.com (2603:10a6:800:1b3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.20; Wed, 30 Nov
 2022 11:32:09 +0000
Received: from HE1PR0402MB2939.eurprd04.prod.outlook.com
 ([fe80::7682:a2e6:b891:2f4d]) by HE1PR0402MB2939.eurprd04.prod.outlook.com
 ([fe80::7682:a2e6:b891:2f4d%10]) with mapi id 15.20.5857.023; Wed, 30 Nov
 2022 11:32:09 +0000
From:   Clark Wang <xiaoning.wang@nxp.com>
To:     Russell King <linux@armlinux.org.uk>
CC:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] net: phylink: add sync flag mac_ready to fix resume
 issue with WoL enabled
Thread-Topic: [PATCH 1/2] net: phylink: add sync flag mac_ready to fix resume
 issue with WoL enabled
Thread-Index: AQHZBKyo4U8XamUbok2HUhpB4yX+kq5XUw0AgAAALtA=
Date:   Wed, 30 Nov 2022 11:32:09 +0000
Message-ID: <HE1PR0402MB2939242DB6E909B4A62109E5F3159@HE1PR0402MB2939.eurprd04.prod.outlook.com>
References: <20221130111148.1064475-1-xiaoning.wang@nxp.com>
 <20221130111148.1064475-2-xiaoning.wang@nxp.com>
 <Y4c9PlfEC17pVE08@shell.armlinux.org.uk>
In-Reply-To: <Y4c9PlfEC17pVE08@shell.armlinux.org.uk>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: HE1PR0402MB2939:EE_|VE1PR04MB7213:EE_
x-ms-office365-filtering-correlation-id: 4c7a399e-7b36-4500-6e65-08dad2c684aa
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XXrjvxG4aOJMYDBC9Oq4SAG9hyaJNscfMy5sYGCAD7L4dJGusEunmQisbGPFOFlpjtEFftn0eTsLxXHopkomMzOtQhT0o1Snj8BKlt8hcQ6MLNd+Qozy/vb3O43d28/Jaugalqokqh66BM/QC/YGAbzF6+j7mWLeaGmslMODMVeew1rXfcFzkzwfELrgPJIMpnC+gz70irFkbb7Jx2lq7LTzDDQfBMU2w1fiwvx4oA+qdI7R03LETWbZTvkwtGwa6k36CQFWPhPpCdkl+s6PjWmVfK52otzn0UTicl3ZFZwGZTBqDBFTveeXjLKigVpwUz6AxwLm4T1I/hjjZMFF3fjMbRrCWqLi/DWtIwod+fE0hyuCHbAF1nNwIK2m5ENpWyHEchxTFU643lLpI07DBVs1F71zIzIkA2jOO7+qfPM/cEGTnUJwDmBbtpZojFB67afMyDEMJJbokgAhrPOn8NZiywPSv4ifczKnoSVRN3MXVVsjuIgwUkbNh/7yhDw4C6rAqwYvKj4o3Q9z+k4IzZFeBVNgo0kaJYeNcCWV9bxa+lXmOGvY5hEMctWbN/l6ulzAa6vYveyQsBp8B83ZyClkyHSfOG1uKPMSW91mShsgpPx46CrSbUTZbN+s32z85gb6NED85kJ8rzJ69qNZZA7pMKZepbLSj9R7Y+suVc2/a+Dw7KwZvI7SdS4KpkKfAAkeA+rnhz0nT3nsyN2ZWrh5keeXQ5lhV5R473vo2cg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB2939.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(39860400002)(136003)(346002)(366004)(451199015)(86362001)(41300700001)(33656002)(55016003)(6916009)(54906003)(5660300002)(316002)(83380400001)(66476007)(8676002)(76116006)(66946007)(4326008)(66446008)(26005)(7696005)(71200400001)(64756008)(9686003)(53546011)(6506007)(66556008)(186003)(38070700005)(966005)(478600001)(52536014)(45080400002)(122000001)(8936002)(7416002)(2906002)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?RnpSeGFMZFkyRnl5SDV3QzJiazRuWnlHbDM1TGxaUmovL1UxYzQ5cnZITGVS?=
 =?gb2312?B?WW93ZkpReGNqMWU1dkkvaXlsQkhnTy8rZ2l0VGtYcEFGS0UzaEpJSmg0UzBH?=
 =?gb2312?B?MHMzN2lPNzFMMWhXaXNzNWNxa2hPOGF4ditSQzZtdnlYQmo5NHZTVWNaZG51?=
 =?gb2312?B?cjhjSyt6bnBteTQwdDRzYWpveVpVd3N1M2lYL2hnRTZtMGQxSExMZWozWDJX?=
 =?gb2312?B?OENCY0NMcnpGZlRRVktMRzRMcE0yMFBkZm5selY2dzVxVlIwK3BDajN6L2hQ?=
 =?gb2312?B?NGxTdFArUzZsbHgzek5QVndRR3phRk5rS3NKRFlKSlQ5MzZFZmlJN3drVTgw?=
 =?gb2312?B?Tm0xSEt2dkhYWnFvUnY0dURqRHR2cjhUd28zRmczZSs4ZmFtKzlOd0tuSVdV?=
 =?gb2312?B?d09xQzlHUmJCVjhBTis0QWIwdzhOdVpMSnd5dFFzZzFrUVpPMTVFR0gvTFIy?=
 =?gb2312?B?Um8rV0NlcTcwdS9CR1RmaXN2b1JJNU9hd0wwUkZNdm44UG14emwxaXdGVld4?=
 =?gb2312?B?am9vY1FHOUhqSTJqZUs0V3dwWmkzMnBpeVpuVDhHNjF1VkFxQUlKSkIrVDY5?=
 =?gb2312?B?b1NIcGtHOCtIdnNyVjA5SVU4WlRHRmV6WTRyYUFWRXROYmFOMVNlUGZIZDZH?=
 =?gb2312?B?K0hIRS9neFBFM1J3cFJTeWdmaS9BbXBBZmFudWFHelc0Mm5XUXBYS0gyTFhV?=
 =?gb2312?B?VFd4SmFVckhHOHRFSHo1M3lOZldRdVlsdEhTcDBSTXBvbGs4K2tOVUlzVmZh?=
 =?gb2312?B?eWFXSXh6Sk9vbGVSc3ovK0ZWbXR1VXlUZG9nZDFnc1gvdFI5ckxrd3lFT2xa?=
 =?gb2312?B?K2xqVWF4OFBRL1FvMG1zR3A4MmQyR2p5YkYvWi92SEU5VEVaMU1OclNtZTJ2?=
 =?gb2312?B?NFZMNmVVL3YwaFlIVjBHblBzYTlqelF1UDI1OTFveXk1N3lZMGxJYnFlajBS?=
 =?gb2312?B?a09xbHJ5TnExdVdndDlLazBISHQ1bnZyTXBSM0V6aUJFM2poblRwUEJKVGFL?=
 =?gb2312?B?d1dYUllVeTM4THoyVnF4OWtEbHRVY0N1Tlp3TzBra24wMWxLdFJoUVhYMUw0?=
 =?gb2312?B?S1FkM3FtQ0FoWGNzaEFseS9HNGdxN2NjQWtvaGUrdEdLbFN3K3VjRzdiT0gy?=
 =?gb2312?B?Zy9zR1JpbEYzNUIwUlZZN3lML0pBRjN1dlZCbW52RkROQ1V1OHc2OWdNdFph?=
 =?gb2312?B?QjFKc1lHZjNPTEN4OW0vQS9NZFl5cDU1MzYzWjBocUF3d09RSWpROU52eUhn?=
 =?gb2312?B?ZUF5S2RObVdsYkllN2xvSUw5NzRuMDluSnVUemZSL1ZxZlJ2d1dVdDFZRm5m?=
 =?gb2312?B?VUZjL2lYNFc0RTlBS3RURWpWSDNyZHhDYmlLcS9uSWxyMlFIbE9hL3p5ZVlE?=
 =?gb2312?B?cWlURFE2Rk1SNGJVZDhyWnVnRUNvSTg1MkFVYXlCSkN6d0dPQ0wva05yOVA0?=
 =?gb2312?B?dUhrYStKMG53WkdZazZKTEN3WEJlYXJsaFgrREdYN2g5dlRqUDRJZTRMZU1h?=
 =?gb2312?B?dzdXNEJuTGMySGM4ZDduSmdndWl2bEZJeDZvbmNVakZXWnp3eGxFYW5SQ1Aw?=
 =?gb2312?B?Snh0a01ud0U4cDJ0MUJLMlhpOHlJWkZQQ01vaWplcS9OMWptbzFYOElqM3Ni?=
 =?gb2312?B?cnN4MHQ2OFlOOHVVaVc1ZVcvdGJ3TzZxdWdwaG9vL1JiYUxzRVkwbVRScjRr?=
 =?gb2312?B?RmNrMTgwUjIrQ2tmYXFyamdadE9CSDZ4aHNzeFVBbkJpeU85aTVrL21nbXRN?=
 =?gb2312?B?cXR5ZU9VRVBzLy9WSmVXVmFBTlFMSnVrSlJGNGFPT0IxV0lucmRnY2xrbkdK?=
 =?gb2312?B?aDg5ckwvaWZMZ0dDM3kxYkZ4MWdVMGV0R3dYVWs4K0luT2RNbjlDekxDK1hM?=
 =?gb2312?B?ZFFRTmRrWTR4Kys0VjZqUlRWUmJKSThQenh5MnhFN2NjMzJ2Rk1nUVJDY28r?=
 =?gb2312?B?TS83NHVTNDVkenVNR2R4OE1ReWU5UDNOZWdUbFBPa002UjlSUEdvYm45bWxy?=
 =?gb2312?B?WGp1UndNckIzeDdmRm5Zd1BvcDE0STZmc2hGd3Nva25qV0dFUEVSaUhMZTVC?=
 =?gb2312?B?NmdSWi9FOEc2TGh2OEYzOUEza2h5RXFkMTZDalovaVdSVVNIb3FNdHZSREFN?=
 =?gb2312?Q?8U2pCU90cBaABwQ85BIFIr/fl?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0402MB2939.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c7a399e-7b36-4500-6e65-08dad2c684aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2022 11:32:09.6997
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NqX5BPCKYtA872rzpleY29DX/WtTt7vRHoDmoHzVsCvqWSMw6+cfm7zwKLklU70pW7gGh/A3vLflQAslJueDiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7213
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUnVzc2VsbCwNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBSdXNz
ZWxsIEtpbmcgPGxpbnV4QGFybWxpbnV4Lm9yZy51az4NCj4gU2VudDogMjAyMsTqMTHUwjMwyNUg
MTk6MjQNCj4gVG86IENsYXJrIFdhbmcgPHhpYW9uaW5nLndhbmdAbnhwLmNvbT4NCj4gQ2M6IHBl
cHBlLmNhdmFsbGFyb0BzdC5jb207IGFsZXhhbmRyZS50b3JndWVAZm9zcy5zdC5jb207DQo+IGpv
YWJyZXVAc3lub3BzeXMuY29tOyBkYXZlbUBkYXZlbWxvZnQubmV0OyBlZHVtYXpldEBnb29nbGUu
Y29tOw0KPiBrdWJhQGtlcm5lbC5vcmc7IHBhYmVuaUByZWRoYXQuY29tOyBtY29xdWVsaW4uc3Rt
MzJAZ21haWwuY29tOw0KPiBhbmRyZXdAbHVubi5jaDsgaGthbGx3ZWl0MUBnbWFpbC5jb207IG5l
dGRldkB2Z2VyLmtlcm5lbC5vcmc7DQo+IGxpbnV4LXN0bTMyQHN0LW1kLW1haWxtYW4uc3Rvcm1y
ZXBseS5jb207DQo+IGxpbnV4LWFybS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZzsgbGludXgt
a2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIDEvMl0gbmV0OiBw
aHlsaW5rOiBhZGQgc3luYyBmbGFnIG1hY19yZWFkeSB0byBmaXggcmVzdW1lDQo+IGlzc3VlIHdp
dGggV29MIGVuYWJsZWQNCj4gDQo+IE9uIFdlZCwgTm92IDMwLCAyMDIyIGF0IDA3OjExOjQ3UE0g
KzA4MDAsIENsYXJrIFdhbmcgd3JvdGU6DQo+ID4gSXNzdWUgd2UgbWV0Og0KPiA+IE9uIHNvbWUg
cGxhdGZvcm1zLCBtYWMgY2Fubm90IHdvcmsgYWZ0ZXIgcmVzdW1lZCBmcm9tIHRoZSBzdXNwZW5k
IHdpdGgNCj4gPiBXb0wgZW5hYmxlZC4NCj4gPg0KPiA+IFRoZSBjYXVzZSBvZiB0aGUgaXNzdWU6
DQo+ID4gMS4gcGh5bGlua19yZXNvbHZlKCkgaXMgaW4gYSB3b3JrcXVldWUgd2hpY2ggd2lsbCBu
b3QgYmUgZXhlY3V0ZWQgaW1tZWRpYXRlbHkuDQo+ID4gICAgVGhpcyBpcyB0aGUgY2FsbCBzZXF1
ZW5jZToNCj4gPiAgICAgICAgcGh5bGlua19yZXNvbHZlKCktPnBoeWxpbmtfbGlua191cCgpLT5w
bC0+bWFjX29wcy0+bWFjX2xpbmtfdXAoKQ0KPiA+ICAgIEZvciBzdG1tYWMgZHJpdmVyLCBtYWNf
bGlua191cCgpIHdpbGwgc2V0IHRoZSBjb3JyZWN0IHNwZWVkL2R1cGxleC4uLg0KPiA+ICAgIHZh
bHVlcyB3aGljaCBhcmUgZnJvbSBsaW5rX3N0YXRlLg0KPiA+IDIuIEluIHN0bW1hY19yZXN1bWUo
KSwgaXQgd2lsbCBjYWxsIHN0bW1hY19od19zZXR1cCgpIGFmdGVyIGNhbGxlZCB0aGUNCj4gPiAg
ICBwaHlsaW5rX3Jlc3VtZSgpLiBzdG1tYWNfY29yZV9pbml0KCkgaXMgY2FsbGVkIGluIGZ1bmN0
aW9uDQo+ID4gc3RtbWFjX2h3X3NldHVwKCksDQo+IA0KPiAuLi4gYW5kIHRoYXQgaXMgd2hlcmUg
dGhlIHByb2JsZW0gaXMuIERvbid0IGNhbGwgcGh5bGlua19yZXN1bWUoKSBiZWZvcmUgeW91cg0K
PiBoYXJkd2FyZSBpcyByZWFkeSB0byBzZWUgYSBsaW5rLXVwIGV2ZW50Lg0KDQpUaGFuayB5b3Ug
dmVyeSBtdWNoIGZvciB5b3VyIHJlcGx5IQ0KDQpZb3UgYXJlIHJpZ2h0Lg0KDQpIb3dldmVyLCBz
dG1tYWMgcmVxdWlyZXMgUlhDIHRvIGhhdmUgYSBjbG9jayBpbnB1dCB3aGVuIHBlcmZvcm1pbmcg
YSByZXNldChpbiBzdG1tYWNfaHdfc2V0dXAoKSkuIE9uIG91ciBib2FyZCwgUlhDIGlzIHByb3Zp
ZGVkIGJ5IHRoZSBwaHkuDQoNCkluIFdvTCBtb2RlLCB0aGlzIGlzIG5vdCBhIHByb2JsZW0sIGJl
Y2F1c2UgdGhlIHBoeSB3aWxsIG5vdCBiZSBkb3duIHdoZW4gc3VzcGVuZC4gUlhDIHdpbGwga2Vl
cCBvdXRwdXQuIEJ1dCBpbiBub3JtYWwgc3VzcGVuZCh3aXRob3V0IFdvTCksIHRoZSBwaHkgd2ls
bCBiZSBkb3duLCB3aGljaCBkb2VzIG5vdCBndWFyYW50ZWUgdGhlIG91dHB1dCBvZiB0aGUgUlhD
IG9mIHRoZSBwaHkuIFRoZXJlZm9yZSwgdGhlIHByZXZpb3VzIGNvZGUgd2lsbCBjYWxsIHBoeWxp
bmtfcmVzdW1lKCkgYmVmb3JlIHN0bW1hY19od19zZXR1cCgpLg0KDQpUaGFua3MgYWdhaW4hDQpD
bGFyayBXYW5nDQoNCj4gDQo+IC0tDQo+IFJNSydzIFBhdGNoIHN5c3RlbToNCj4gaHR0cHM6Ly9l
dXIwMS5zYWZlbGlua3MucHJvdGVjdGlvbi5vdXRsb29rLmNvbS8/dXJsPWh0dHBzJTNBJTJGJTJG
d3d3LmFyDQo+IG1saW51eC5vcmcudWslMkZkZXZlbG9wZXIlMkZwYXRjaGVzJTJGJmFtcDtkYXRh
PTA1JTdDMDElN0N4aWFvbmluZy4NCj4gd2FuZyU0MG54cC5jb20lN0M1YjJjZjAwNjA2MTY0MTA4
MTNjYTA4ZGFkMmM1NWExMSU3QzY4NmVhMWQzYmMyDQo+IGI0YzZmYTkyY2Q5OWM1YzMwMTYzNSU3
QzAlN0MwJTdDNjM4MDU0MDQyMzA2NDY0NjU3JTdDVW5rbm93biUNCj4gN0NUV0ZwYkdac2IzZDhl
eUpXSWpvaU1DNHdMakF3TURBaUxDSlFJam9pVjJsdU16SWlMQ0pCVGlJNklrMWhhV3dpDQo+IExD
SlhWQ0k2TW4wJTNEJTdDMzAwMCU3QyU3QyU3QyZhbXA7c2RhdGE9Q1BoUXBudm9WOTVjaCUyRlVj
DQo+IE00UmIySHZZMHIyNEkwRnNWU0tNOWhPMTNGSSUzRCZhbXA7cmVzZXJ2ZWQ9MA0KPiBGVFRQ
IGlzIGhlcmUhIDQwTWJwcyBkb3duIDEwTWJwcyB1cC4gRGVjZW50IGNvbm5lY3Rpdml0eSBhdCBs
YXN0IQ0K
