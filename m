Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 839832CE4B5
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 02:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730062AbgLDBHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 20:07:23 -0500
Received: from mail-eopbgr20043.outbound.protection.outlook.com ([40.107.2.43]:57668
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728005AbgLDBHX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 20:07:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EGpX0DaZkIRBdbYr7MPeLg1bN9klENeyNxSm66WosrBPqW/DjD3nSdMPxgMWsEky4XM1apRPPF5arh2RQM3RVj3v4LEksUAm79ZNypGb6lO/qCMuKgxgoo0RCsBlgFXBzVc+TMovmNg9ytsn+xA8pk1hgq7j/RpjM+WJtIIjobZqCKoRYCgA+OjX/imaJLgA/4rLhZfvQE5wA9UGPoueHvO1N2ULzzW+WB8mjqqoYwj0DPwH2veyRdkZJ6vJAGR/Vg4cGOXvU4hLgUVynNymUULZVSbu4I28QCKWcUT9lG5h4kRWNoGsoa6IADRebIRio+tMmnmByGv76LoF/+Yx1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/2A0QhOXBSzOnbVqXmTBd5AdlRx5A88tgxzUPm1Rh7I=;
 b=ahaVe+mA0dxH38nOfzo+vTycZn//xKumSkd1r87LEMmZtmXmEwX8rbelM5Qs8/mpsz4OJbt5ZdAFdEr+CxBcFJ4yWyEBPUZM/SpAT0NlTEh97KgEqNBO8DrDCgphVHqcunM6lo5JPzAGib64Ivw5bJfu/0FpDrEHC9WobquEh8FLWn/2NV4Iy9lQmgpZujgJOSpJgFMolsrXhHpySQmN+7n9QdeSpZqOxndJNQR9yfcY602wKYQOb1krC499CVV3+Vw+cmcINLgIJGnbz/HjJFIuf60BMVfQiyDiJ9iGuuS0hwn63WVf9jbDvQrtQaagMz3spN8u8/z7ymdxrr9c0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/2A0QhOXBSzOnbVqXmTBd5AdlRx5A88tgxzUPm1Rh7I=;
 b=NWR43+pfn+djFTSmBnjbTCkU0II9szcSf+dMIuYZ0FnJRu0F0iSarMLPRXziMCSiZtXavLFRONG6x86pf+Kqh1iV+JeGwowaRW0ICYpCQaBoa+IofzVHMSQhD4/lkZtRl3QQGOHr9kF8Flz9vszUCi3jhz3xZXR+6WCo4epxFY0=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBBPR04MB7674.eurprd04.prod.outlook.com (2603:10a6:10:1f5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Fri, 4 Dec
 2020 01:06:35 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666%4]) with mapi id 15.20.3632.021; Fri, 4 Dec 2020
 01:06:35 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] net: stmmac: overwrite the dma_cap.addr64 according to HW
 design
Thread-Topic: [PATCH] net: stmmac: overwrite the dma_cap.addr64 according to
 HW design
Thread-Index: AQHWyR5HoRHNdb0kOEuTjZTFRwX0banltdSAgABqGYA=
Date:   Fri, 4 Dec 2020 01:06:34 +0000
Message-ID: <DB8PR04MB6795A1B287A9395DE6D7B660E6F10@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20201203024423.23764-1-qiangqing.zhang@nxp.com>
 <20201203104221.6b692285@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201203104221.6b692285@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1a1370df-fb68-420d-4ebc-08d897f0d85b
x-ms-traffictypediagnostic: DBBPR04MB7674:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBBPR04MB76745E089C51E8F6A509E6A9E6F10@DBBPR04MB7674.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WSUVCdIoxjvYip33a4p7jZF1XRyg+89zuzsHoxlmcW7Zyb51XjvnMsuUG0Q07kT3jrHG1DeerErbD2Gmh/DxM/GfvFrpRWzWh10Q28crSBk8Q65F3snl4gS05031ZzdHwwXTgLXYhoNtVkux/hqbQpd3YleGU+gU3+jpoL0k1GObEKWfPNNKmBKQ1nU+boggAE+Z/3wXKOScrxjHzXvmCDbBYDhlDYbF4lB2DynsIzBCNDLFk2zyedh6sHlMTWLOQDMLrtVA9LWgH2w41E5SBJBe5pqTXv6L3ZwqwiaI81yN11jm+hSLbyg3fDH/xDjav1YMWHl+NFWw7+FtylwB9w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(136003)(376002)(346002)(366004)(83380400001)(8676002)(52536014)(66946007)(5660300002)(76116006)(4744005)(64756008)(66556008)(9686003)(6916009)(66446008)(66476007)(478600001)(6506007)(186003)(53546011)(55016002)(26005)(4326008)(316002)(7696005)(33656002)(86362001)(54906003)(2906002)(8936002)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?a3VSZytvMHIxK1NuS0YvMHByQWQrMytNWUQ5bGVHcjBOVmdDS0JoVnRjWnpV?=
 =?gb2312?B?U0dUMzBoTndwRC9KQVZ0c3BTenl0UzJzNlE4NXZTM1hGcEZIQklFZzlYYXRR?=
 =?gb2312?B?OTkzUzdZYmQxYXV2czRjYnduRHVlY09NRTZNLzJZejcwQTlIRGovbVNtWXlC?=
 =?gb2312?B?QzZoeVNJSFY2TGtCMkJPd1kvbWswcHlNVDJSeVlnRUZIOHFkUThNOHQ2Yml2?=
 =?gb2312?B?QU5BNDQxUWdWdHlWREtrTWRGMThiRk03cTdEeXg2dHVGZzUxOThEeEtNdFNu?=
 =?gb2312?B?VWxFUU5qa0Jwam1tWVZSakR5c0lBRS9Qck9ramJ3bDB1NzRSL1ZsNUhtVVVy?=
 =?gb2312?B?bWxyUXRsQXF1S0N0d3dwS3l5WUFxOUdKUXMzWHRhUHFRYXgwUi9qVzdNQUFV?=
 =?gb2312?B?MG8wU2YzcXRNUXJTaVZDVnFZbnhJZkN5VTZ3M2dsL3FNUEY4d2hESUJFSnZ1?=
 =?gb2312?B?aHdYZ0k2WnJSZzRkWXphR1hvbnNOMzRzWVU5SjJSMElVYndiTU9veW5GUFN6?=
 =?gb2312?B?Z0V5N1prRzZHSy9CWVY0OC93L2NDN2FySUptRjczblZlZkdPZ0RUbEFMblFN?=
 =?gb2312?B?NlZDS2ZKVzhwRjUzN0ROeWJBZkhaZlZBVWRkSk1LYXBYbS9vKytvZjI4N1J5?=
 =?gb2312?B?L0kvR2Jrd0lMVi9RSmxtZjdMQ3dFNTluWWhwaW01QTJTWEtqU2l2NHV1NEFZ?=
 =?gb2312?B?Y3NpMFhmZElzRlF1dUNGMDgrd24zUnJzUHFDRHZtdTZFNjc3RnNJRVl2cExD?=
 =?gb2312?B?MDRBcG54RiszUWdLL1R3TlRBQitTTXFVMTQzUndGbHpkMndqNldFalBkSUdy?=
 =?gb2312?B?dXJTMjNnREU3UEFLeTBPZ1ZRRk9Ua0FBVWdnaG5za3RJMHRGV3hMMVM2TWo1?=
 =?gb2312?B?YkFQMGpXeFdabE9SVjVRckc4cDBXZ2tTczZuRWlyaU5iVHBwcWxBQXRpNWdv?=
 =?gb2312?B?amlBTmNwRFo4RzZBYk9hUFBkc2RPdDlJN0RYR1ZTTDVGaWZwVXY2QUs2ZWNI?=
 =?gb2312?B?WFgwL2hOU2dLWXMrRHVuQlE4TEEyWkJZS2d1djZ0VkxvNHAyNVdiek8vNjlB?=
 =?gb2312?B?RFFOSXc1ZytXNmZOV0dONkRpVzBETFhFZG5UbS8yb09lSlZ1Z2hmOXhuQXFl?=
 =?gb2312?B?UENQNFhnVXF5UFJVaXFBN1AzWU04RG9ibktaYW9PaDM4c08wV09yRUdtU1Mv?=
 =?gb2312?B?NkZaU3NWWlJUdUhTT2F5elNLdXJwRS82dWdFVjZsNUFoOFpQK3Y0WTdxR1U5?=
 =?gb2312?B?S2VwZHdrbE9NQ0djZUhISGJTN3pKYmw4QVczcjZiK2hIbEZ4Y2N2RmZGOUl1?=
 =?gb2312?Q?MVmMJ5HvYCZ0M=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a1370df-fb68-420d-4ebc-08d897f0d85b
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2020 01:06:34.9637
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vRV1ooVraxu/tevegGbx/5LRO5eBcEPmXwjG16E5pN7CJgKRPEPcJwsE/5fHkacLUqVlIfTkuv5dcAy++RpTBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7674
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEpha3ViIEtpY2luc2tpIDxr
dWJhQGtlcm5lbC5vcmc+DQo+IFNlbnQ6IDIwMjDE6jEy1MI0yNUgMjo0Mg0KPiBUbzogSm9ha2lt
IFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4gQ2M6IHBlcHBlLmNhdmFsbGFyb0Bz
dC5jb207IGFsZXhhbmRyZS50b3JndWVAc3QuY29tOw0KPiBqb2FicmV1QHN5bm9wc3lzLmNvbTsg
ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgZGwtbGludXgtaW14DQo+IDxsaW51eC1pbXhAbnhwLmNvbT47
IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSF0gbmV0OiBzdG1t
YWM6IG92ZXJ3cml0ZSB0aGUgZG1hX2NhcC5hZGRyNjQgYWNjb3JkaW5nIHRvDQo+IEhXIGRlc2ln
bg0KPiANCj4gT24gVGh1LCAgMyBEZWMgMjAyMCAxMDo0NDoyMyArMDgwMCBKb2FraW0gWmhhbmcg
d3JvdGU6DQo+ID4gRnJvbTogRnVnYW5nIER1YW4gPGZ1Z2FuZy5kdWFuQG54cC5jb20+DQo+ID4N
Cj4gPiBUaGUgY3VycmVudCBJUCByZWdpc3RlciBNQUNfSFdfRmVhdHVyZTFbQUREUjY0XSBvbmx5
IGRlZmluZXMNCj4gPiAzMi80MC82NCBiaXQgd2lkdGgsIGJ1dCBzb21lIFNPQ3Mgc3VwcG9ydCBv
dGhlcnMgbGlrZSBpLk1YOE1QIHN1cHBvcnQNCj4gPiAzNCBiaXRzIGJ1dCBpdCBtYXBzIHRvIDQw
IGJpdHMgd2lkdGggaW4gTUFDX0hXX0ZlYXR1cmUxW0FERFI2NF0uDQo+ID4gU28gb3ZlcndyaXRl
IGRtYV9jYXAuYWRkcjY0IGFjY29yZGluZyB0byBIVyByZWFsIGRlc2lnbi4NCj4gPg0KPiA+IFNp
Z25lZC1vZmYtYnk6IEZ1Z2FuZyBEdWFuIDxmdWdhbmcuZHVhbkBueHAuY29tPg0KPiA+IFNpZ25l
ZC1vZmYtYnk6IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+DQo+IA0KPiBU
aGlzIGlzIHJlZmFjdG9yaW5nLCBub3QgYSBmaXgsIHJpZ2h0Pw0KDQpIaSBKYWt1YiwNCg0KSW4g
dGhlb3J5LCB0aGlzIGlzIGEgYnVnIGZpeCwgcGxlYXNlIGxldCBpdCBpbnRvIG5ldCByZXBvIGlm
IHBvc3NpYmxlLg0KDQpJIHdpbGwgYWRkIGFsbCBidWcgZml4IHRhZyBmb3IgcGF0Y2hlcywgYW5k
IHNlbmQgb3V0IGEgVjIuIFRoYW5rcyBhIGxvdC4NCg0KQmVzdCBSZWdhcmRzLA0KSm9ha2ltIFpo
YW5nDQo=
