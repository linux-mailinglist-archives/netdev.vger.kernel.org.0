Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A545339B40E
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 09:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbhFDHhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 03:37:23 -0400
Received: from mail-eopbgr130088.outbound.protection.outlook.com ([40.107.13.88]:46678
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230035AbhFDHhW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 03:37:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O4PwRc/lTwjwBPoEqSZMlefKDLG7arFQrEuJcWsYvJ9aSb0BnWU0XH7HzuLAUZnK+Ez7G0Ut2baGqsC7coyTCUwKm/w8o9ONmDsrAbPn03hFd89ykeZ2u7eRoFeMDEhFqB6Va4cV9ACJx/xprQk8/v+o04WWNA+u4umvAMpW2fYIO11SmfE3a/8hC9qDCgdF1sGY6B5rc65kXEmhJyYmEBcYWSC75ak3F3Rf0mq3hhCo1Y99goDLv7VKS1f7mVuRcgAvTV2CXFD5g5dILlmBf3WyAQmv/M0Bl/Z7NrNk+t9Y63I+6gylmPAEJ8xM9y25N9Z2GUCg8EFEsG4R/iGo7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TJaI3/roFiuKOoYxIrVXEK5k20MXkZpQ5pmOJFPRTRA=;
 b=mnNiP4wa2XiOcIh21ABgWKj6xjdoiUZr+UzxqaNq888oWCjxbJ60vd1qlObnHXn1bwhoRB1z8r6JkviAB6gMSECNDnRANx8wQhvuFQdSQhXWIKygISAWkVUUYjM/KWg+5kWIwq0si5Y5NBBevSBJqESr2qwq/Gcb+1tzU9+qndXF0q6M6jlgXYrCo3+78AvkwxudA99k4dMc8lTuw4jUeHRn4TLYK2AYzQG8uOBccSC/8sKaHUmLMR1ydov1Rk0Kgju6Xvdhf+CjsAF7aqSuTIT1BRHfxP3ciqpqOQ8SzJjOj4C+kAkhQCAKxe+kBFPbBq1yrUQXinIK7OttXPTgsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TJaI3/roFiuKOoYxIrVXEK5k20MXkZpQ5pmOJFPRTRA=;
 b=TLoSFHIqk7hvwIci/LrfP6+pM/1/Cx+TnUcipOqndEV4iE6ET2epQziTG2OtAAmgvsuUCuP1ygfmtCiIcZuPQWZlI0EfVhzq84br2MgUGaJgx/vrXuecHiGv0POKhrOe24o7njYSy5RPqAAMKq74m/9I4zFDhAflJPsM6nWiUcM=
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com (2603:10a6:209:3f::17)
 by AM5PR0401MB2562.eurprd04.prod.outlook.com (2603:10a6:203:3a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Fri, 4 Jun
 2021 07:35:34 +0000
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::7854:74ce:4bb7:858a]) by AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::7854:74ce:4bb7:858a%4]) with mapi id 15.20.4173.030; Fri, 4 Jun 2021
 07:35:34 +0000
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     =?utf-8?B?UGFsaSBSb2jDoXI=?= <pali@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
CC:     Igal Liberman <Igal.Liberman@freescale.com>,
        Shruti Kanetkar <Shruti@freescale.com>,
        Emil Medve <Emilian.Medve@freescale.com>,
        Scott Wood <oss@buserror.net>,
        Rob Herring <robh+dt@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Camelia Alexandra Groza (OSS)" <camelia.groza@oss.nxp.com>
Subject: RE: Unsupported phy-connection-type sgmii-2500 in
 arch/powerpc/boot/dts/fsl/t1023rdb.dts
Thread-Topic: Unsupported phy-connection-type sgmii-2500 in
 arch/powerpc/boot/dts/fsl/t1023rdb.dts
Thread-Index: AQHXWIWiLLzXceBiLkWovt9CFi28O6sCZLOAgABNOICAAL4lwA==
Date:   Fri, 4 Jun 2021 07:35:33 +0000
Message-ID: <AM6PR04MB3976B62084EC462BA02F0C4CEC3B9@AM6PR04MB3976.eurprd04.prod.outlook.com>
References: <20210603143453.if7hgifupx5k433b@pali> <YLjxX/XPDoRRIvYf@lunn.ch>
 <20210603194853.ngz4jdso3kfncnj4@pali>
In-Reply-To: <20210603194853.ngz4jdso3kfncnj4@pali>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [81.196.28.56]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bf2c0c6f-36e0-4a9e-7aa4-08d9272b56a7
x-ms-traffictypediagnostic: AM5PR0401MB2562:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM5PR0401MB2562DDBDF45F1BA609C2EE0DEC3B9@AM5PR0401MB2562.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yfoGgo8Y/Ct3sT6RKp7Uip+tJ6I0jLsW9WVcImxFCyH2q0RgH29s/QH3Rr81VHYbnUcYeXgS09Vy1vei+iAObd57QfGg1WuFribx6ytBv9pHz4BP2iJv3rh6I6PkwgOksTNH279TWRMbfvYy7NXqkYKlhswkHGOjG2N/OGJps8VNbMHrUw0BoWDpQZsn1EdbTkOnVI75RWvrABb0XXUwsgQ246L9E9byywZtBZJbYLnucP3Wr4ZJwwcPRWZW9z/c6U0LxBulBM/tcSA6gngpdNcoJ3NZrObJ/aIvGjjiq/APGFzts2bDa6WTbIPMQfjPHWrRC42wZeziEb4P3w5YPO6tXdSwGF4YA6JpdGTn7UayClr4csMGm7FDUJble0JlB23J3O+oX5Q5mRvGxal80IPrbAfkMosJFOOR7UhsMUnLYNhyYSy5Wm6Te5b9p8a4orzvugkfxl97ldghYn7hvH0anUrjaSsYoCVJsBM8Jv9CJWwd2WceueFDIq/HYSMAZAz+k/ZBBhs99eROXcs9JdDa33X2sCDMsLINMKPBBWcaMOM14AM+Owlc/1HdaSutj8qh7togW/nDKFXlYnp73nL0HnOLYdznSuKIGF3cjxg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB3976.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(136003)(376002)(39860400002)(2906002)(5660300002)(26005)(44832011)(38100700002)(33656002)(9686003)(55016002)(52536014)(186003)(86362001)(122000001)(71200400001)(316002)(53546011)(76116006)(4326008)(110136005)(54906003)(66476007)(8676002)(66446008)(478600001)(7696005)(83380400001)(66946007)(64756008)(66556008)(66574015)(7416002)(8936002)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?WWo2cnVKVjZ4MHVQOEliSTR5b2d1R0lBanZlODd1WS9jN1lGK0g5cmtWaXdG?=
 =?utf-8?B?bktpOU9YK2l0aG4rTHFHL0xkQXc5YzJGMXdKbFg2ODJvZXExcjlUY3VJTmJw?=
 =?utf-8?B?ZWFhenlxc1RlTFFYQnZZQitaRkNZSU9Ea0s0bWRrQzhMR1BFK1ZuY09xSW1s?=
 =?utf-8?B?S2NBQ2NPRUJSaWExaEtyOGFFbHVIMUtESVQya1VJM1o4VTlveituL0g1M0J1?=
 =?utf-8?B?aXFPVjc1bEI1em96NXdkNmJVQVIrTWg1QXlDVzB5dDVVTHdWYkxqQUhGT1Bq?=
 =?utf-8?B?YUdoT2VmNlFzaVM2a3plWnZUTnRBM1FieXB0UDNVMTRZY2ZjZVI2UlBhTDZo?=
 =?utf-8?B?b1BsRnljYzZzZ1g0THJ0bXRxcFdQZkwwY0RWeTNHYlptSEl1R1RSTHBPUUFV?=
 =?utf-8?B?SDZ4WWRZNXJjdTlVUy9aSUpVT0xOM0p2Y2N2NkVoR1hPbWphQ3NRcXV3RnpY?=
 =?utf-8?B?cXVxQUhFMjlsZlJ3Yzd4dlNJOGpweElFTkpmV3R0WGdkMTZIbytLUm9PczZJ?=
 =?utf-8?B?SFdibjVzK3NMaWF0c2FTWmJVdnNHRy8wSGV5RFRONHh4R241ZmR3NGk2a1Bn?=
 =?utf-8?B?RjJpSnlrZVgwQm5KVmJBYm5QaFlBUERub09VcVhPTy9GNXFPQW05RGJVTy9z?=
 =?utf-8?B?QkIxc2dBRFhlczBvZUxJUjhEZ3lCcURYZ0hkYlk5UzRVREhEODBSSndWazVI?=
 =?utf-8?B?K1lsREp5RGI5N3I3NittSHRteCsrTTQrNm05dDNqbTNUUGdjRmExOW1GZTdJ?=
 =?utf-8?B?R3JSaVpmZ2xMRnpOaHdpTU13WlM3cDFNc3dudFVBRDNaa014RXNBV2dGS2VP?=
 =?utf-8?B?T0dmSTVmY1JkUElqQjZOTXlwaHAzSkJZQ2wrVHVMR1dlRWVObXVkZEFwcDU4?=
 =?utf-8?B?aUdNYW12bG1mQWtJVVNkWWtmc0h5R0VTSElwT3BPZWJiY3V3aGV5N21nY25J?=
 =?utf-8?B?Y00xSml6OGRXVHVucytVaEFZeWpXRDhXOFFTQ1M4M3RDZUQwaUEzNFVBNjhO?=
 =?utf-8?B?OEdycXh2OWdueDZaOGF6K1lZY3ZudElYZ0pTOGN0NW5kRS9vS0hhSnV6TWht?=
 =?utf-8?B?LzltaEwzUy9zTnU3ajVpM2JpbWJtQWdNZyt5eW5RdkZXZlhDMEFudDI1eHh6?=
 =?utf-8?B?VHBqSEhuZ1JqRVBscG9DTUMzN2FoNUo1cllRWWJ1QnNlNXBpajdzRElJY3FZ?=
 =?utf-8?B?TnI0ejhBZ2JlVE0rR0ZKNk1wS2FRNXk1cUxLT1ZkVUZ6eC9xaWw0dG5LeGph?=
 =?utf-8?B?Z0FCVHpCTmZPS1N6WHRybWlwNXFGZnRWV2djN1hBNm42bksyQjBXVVUxQXZm?=
 =?utf-8?B?K01XSDNOSWd4bzRnT1RydENRSEhNOUFRTUVYaVg2eGZKV2R3SVovQUhZNjNy?=
 =?utf-8?B?QjV2MUJnUU16WHZkelZQZDRRcmtKc0hhUFBZRGRBeFYrem8rVk9tLzFtczU4?=
 =?utf-8?B?emVPMEtWM0owQUphUkVVbzBmemU3Qm8wbGZyc2ZTQlZ0NjdNSFRkb0xWdjEx?=
 =?utf-8?B?SDRPNCs2YmZxZ0lia0c4WjFmc0FkT2ZocVZzUmk0Y1d4S1hhc2plV3p0c3NN?=
 =?utf-8?B?VW1tOWp6cVdDRTdLVHRDMVNpU253ZkV5cDdqa256YldseUk2T1dlMXhXdHNV?=
 =?utf-8?B?ZWJkNEJzUHdwU0VJMklJSnNVSE1Wb1dJblVWZm9sQmZMK0VKT1J5dHlMZVJw?=
 =?utf-8?B?aDNNaG5aNnd0b0tWVjJPWUZrclNrajR4RkFhL01uRE1CWFNSeWxzeDJJVElz?=
 =?utf-8?Q?3VNs6cZbZweLwKu42U=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB3976.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf2c0c6f-36e0-4a9e-7aa4-08d9272b56a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2021 07:35:33.9519
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pcBw8ZEOJYcGhHfQ0FSWva1v7/HCetYM5xVkD8vBU30kjlIFiQ86Rus0foQ9TePbohMGqrGFe9KyTdXV2soqeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0401MB2562
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBQYWxpIFJvaMOhciA8cGFsaUBr
ZXJuZWwub3JnPg0KPiBTZW50OiAwMyBKdW5lIDIwMjEgMjI6NDkNCj4gVG86IEFuZHJldyBMdW5u
IDxhbmRyZXdAbHVubi5jaD4NCj4gQ2M6IElnYWwgTGliZXJtYW4gPElnYWwuTGliZXJtYW5AZnJl
ZXNjYWxlLmNvbT47IFNocnV0aSBLYW5ldGthcg0KPiA8U2hydXRpQGZyZWVzY2FsZS5jb20+OyBF
bWlsIE1lZHZlIDxFbWlsaWFuLk1lZHZlQGZyZWVzY2FsZS5jb20+OyBTY290dA0KPiBXb29kIDxv
c3NAYnVzZXJyb3IubmV0PjsgUm9iIEhlcnJpbmcgPHJvYmgrZHRAa2VybmVsLm9yZz47IE1pY2hh
ZWwNCj4gRWxsZXJtYW4gPG1wZUBlbGxlcm1hbi5pZC5hdT47IEJlbmphbWluIEhlcnJlbnNjaG1p
ZHQNCj4gPGJlbmhAa2VybmVsLmNyYXNoaW5nLm9yZz47IE1hZGFsaW4gQnVjdXIgPG1hZGFsaW4u
YnVjdXJAbnhwLmNvbT47IFJ1c3NlbGwNCj4gS2luZyA8cm1rK2tlcm5lbEBhcm1saW51eC5vcmcu
dWs+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOw0KPiBkZXZpY2V0cmVlQHZnZXIua2VybmVsLm9y
ZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogVW5zdXBwb3J0
ZWQgcGh5LWNvbm5lY3Rpb24tdHlwZSBzZ21paS0yNTAwIGluDQo+IGFyY2gvcG93ZXJwYy9ib290
L2R0cy9mc2wvdDEwMjNyZGIuZHRzDQo+IA0KPiBPbiBUaHVyc2RheSAwMyBKdW5lIDIwMjEgMTc6
MTI6MzEgQW5kcmV3IEx1bm4gd3JvdGU6DQo+ID4gT24gVGh1LCBKdW4gMDMsIDIwMjEgYXQgMDQ6
MzQ6NTNQTSArMDIwMCwgUGFsaSBSb2jDoXIgd3JvdGU6DQo+ID4gPiBIZWxsbyENCj4gPiA+DQo+
ID4gPiBJbiBjb21taXQgODRlMGYxYzEzODA2ICgicG93ZXJwYy9tcGM4NXh4OiBBZGQgTURJTyBi
dXMgbXV4aW5nIHN1cHBvcnQNCj4gdG8NCj4gPiA+IHRoZSBib2FyZCBkZXZpY2UgdHJlZShzKSIp
IHdhcyBhZGRlZCBmb2xsb3dpbmcgRFQgcHJvcGVydHkgaW50byBEVA0KPiBub2RlOg0KPiA+ID4g
YXJjaC9wb3dlcnBjL2Jvb3QvZHRzL2ZzbC90MTAyM3JkYi5kdHMgZm0xbWFjMzogZXRoZXJuZXRA
ZTQwMDANCj4gPiA+DQo+ID4gPiAgICAgcGh5LWNvbm5lY3Rpb24tdHlwZSA9ICJzZ21paS0yNTAw
IjsNCj4gPiA+DQo+ID4gPiBCdXQgY3VycmVudGx5IGtlcm5lbCBkb2VzIG5vdCByZWNvZ25pemUg
dGhpcyAic2dtaWktMjUwMCIgcGh5IG1vZGUuDQo+IFNlZQ0KPiA+ID4gZmlsZSBpbmNsdWRlL2xp
bnV4L3BoeS5oLiBJbiBteSBvcGluaW9uIGl0IHNob3VsZCBiZSAiMjUwMGJhc2UteCIgYXMNCj4g
PiA+IHRoaXMgaXMgbW9kZSB3aGljaCBvcGVyYXRlcyBhdCAyLjUgR2Jwcy4NCj4gPiA+DQo+ID4g
PiBJIGRvIG5vdCB0aGluayB0aGF0IHNnbWlpLTI1MDAgbW9kZSBleGlzdCBhdCBhbGwgKGNvcnJl
Y3QgbWUgaWYgSSdtDQo+ID4gPiB3cm9uZykuDQo+ID4NCj4gPiBLaW5kIG9mIGV4aXN0LCB1bm9m
ZmljaWFsbHkuIFNvbWUgdmVuZG9ycyBydW4gU0dNSUkgb3ZlciBjbG9ja2VkIGF0DQo+ID4gMjUw
MC4gQnV0IHRoZXJlIGlzIG5vIHN0YW5kYXJkIGZvciBpdCwgYW5kIGl0IGlzIHVuY2xlYXIgaG93
IGluYmFuZA0KPiA+IHNpZ25hbGxpbmcgc2hvdWxkIHdvcmsuIFdoZW5ldmVyIGkgc2VlIGNvZGUg
c2F5aW5nIDIuNUcgU0dNSUksIGkNCj4gPiBhbHdheXMgYXNrLCBhcmUgeW91IHN1cmUsIGlzIGl0
IHJlYWxseSAyNTAwQmFzZVg/IE1vc3RseSBpdCBnZXRzDQo+ID4gY2hhbmdlZCB0byAyNTAwQmFz
ZVggYWZ0ZXIgcmV2aWV3Lg0KPiANCj4gU28gdGhpcyBpcyBxdWVzdGlvbiBmb3IgYXV0aG9ycyBv
ZiB0aGF0IGNvbW1pdCA4NGUwZjFjMTM4MDYuIEJ1dCBpdA0KPiBsb29rcyBsaWtlIEkgY2Fubm90
IHNlbmQgdGhlbSBlbWFpbHMgYmVjYXVzZSBvZiBmb2xsb3dpbmcgZXJyb3I6DQo+IA0KPiA8TWlu
Z2h1YW4uTGlhbkBmcmVlc2NhbGUuY29tPjogY29ubmVjdCB0byBmcmVlc2NhbGUuY29tWzE5Mi44
OC4xNTYuMzNdOjI1Og0KPiBDb25uZWN0aW9uIHRpbWVkIG91dA0KPiANCj4gRG8geW91IGhhdmUg
b3RoZXIgd2F5IGhvdyB0byBjb250YWN0IG1haW50YWluZXJzIG9mIHRoYXQgRFRTIGZpbGU/DQo+
IGFyY2gvcG93ZXJwYy9ib290L2R0cy9mc2wvdDEwMjNyZGIuZHRzDQo+IA0KPiA+IFBIWSBtb2Rl
IHNnbWlpLTI1MDAgZG9lcyBub3QgZXhpc3QgaW4gbWFpbmxpbmUuDQo+IA0KPiBZZXMsIHRoaXMg
aXMgcmVhc29uIHdoeSBJIHNlbnQgdGhpcyBlbWFpbC4gSW4gRFRTIGlzIHNwZWNpZmllZCB0aGlz
IG1vZGUNCj4gd2hpY2ggZG9lcyBub3QgZXhpc3QuDQo+IA0KPiA+IAlBbmRyZXcNCg0KSGksIHRo
ZSBGcmVlc2NhbGUgZW1haWxzIG5vIGxvbmdlciB3b3JrLCB5ZWFycyBhZnRlciBGcmVlc2NhbGUg
am9pbmVkIE5YUC4NCkFsc28sIHRoZSBmaXJzdCBmb3VyIHJlY2lwaWVudHMgbm8gbG9uZ2VyIHdv
cmsgZm9yIE5YUC4NCg0KSW4gcmVnYXJkcyB0byB0aGUgc2dtaWktMjUwMCB5b3Ugc2VlIGluIHRo
ZSBkZXZpY2UgdHJlZSwgaXQgZGVzY3JpYmVzIFNHTUlJDQpvdmVyY2xvY2tlZCB0byAyLjVHYnBz
LCB3aXRoIGF1dG9uZWdvdGlhdGlvbiBkaXNhYmxlZC4gDQoNCkEgcXVvdGUgZnJvbSBhIGxvbmcg
dGltZSBhZ28sIGZyb20gc29tZW9uZSBmcm9tIHRoZSBIVyB0ZWFtIG9uIHRoaXM6DQoNCglUaGUg
aW5kdXN0cnkgY29uc2Vuc3VzIGlzIHRoYXQgMi41RyBTR01JSSBpcyBvdmVyY2xvY2tlZCAxRyBT
R01JSQ0KCXVzaW5nIFhBVUkgZWxlY3RyaWNhbHMuIEZvciB0aGUgUENTIGFuZCBNQUMgbGF5ZXJz
LCBpdCBsb29rcyBleGFjdGx5DQoJbGlrZSAxRyBTR01JSSwganVzdCB3aXRoIGEgZmFzdGVyIGNs
b2NrLg0KDQpUaGUgc3RhdGVtZW50IHRoYXQgaXQgZG9lcyBub3QgZXhpc3QgaXMgbm90IGFjY3Vy
YXRlLCBpdCBleGlzdHMgaW4gSFcsIGFuZA0KaXQgaXMgZGVzY3JpYmVkIGFzIHN1Y2ggaW4gdGhl
IGRldmljZSB0cmVlLiBXaGV0aGVyIG9yIG5vdCBpdCBpcyBwcm9wZXJseQ0KdHJlYXRlZCBpbiBT
VyBpdCdzIGFub3RoZXIgZGlzY3Vzc2lvbi4gSW4gMjAxNSwgd2hlbiB0aGlzIHdhcyBzdWJtaXR0
ZWQsDQp0aGVyZSB3ZXJlIG5vIG90aGVyIDIuNUcgY29tcGF0aWJsZXMgaW4gdXNlLCBpZiBJJ20g
bm90IG1pc3Rha2VuLg0KMjUwMEJhc2UtWCBzdGFydGVkIHRvIGJlIGFkZGVkIHRvIGRldmljZSB0
cmVlcyBmb3VyIHllYXJzIGxhdGVyLCBpdCBzaG91bGQNCmJlIGNvbXBhdGlibGUvaW50ZXJ3b3Jr
aW5nIGJ1dCBpdCBpcyBsZXNzIHNwZWNpZmljIG9uIHRoZSBhY3R1YWwgaW1wbGVtZW50YXRpb24N
CmRldGFpbHMgKGRlbm90ZXMgMi41RyBzcGVlZCwgOGIvMTBiIGNvZGluZywgd2hpY2ggaXMgdHJ1
ZSBmb3IgdGhpcyBvdmVyY2xvY2tlZA0KU0dNSUkpLiBJZiB0aGV5IGFyZSBjb21wYXRpYmxlLCBT
VyBzaG91bGQgcHJvYmFibHkgdHJlYXQgdGhlbSBpbiB0aGUgc2FtZSBtYW5uZXIuDQoNClRoZXJl
IHdlcmUgc29tZSBkaXNjdXNzaW9ucyBhIHdoaWxlIGFnbyBhYm91dCB0aGUgbWl4IG9yIGV2ZW4g
Y29uZnVzaW9uIGJldHdlZW4NCnRoZSBhY3R1YWwgSFcgZGVzY3JpcHRpb24gKHRoYXQncyB3aGF0
IHRoZSBkdHMgaXMgc3VwcG9zZWQgdG8gZG8pIGFuZCB0aGUgc2V0dGluZ3MNCm9uZSB3YW50cyB0
byByZXByZXNlbnQgaW4gU1cgKGkuZS4gc3BlZWQpIGRlbm90ZWQgbG9vc2VseSBieSBkZW5vbWlu
YXRpb25zIGxpa2UNCjEwRyBCYXNlLVIuIA0KDQpSZWdhcmRzLA0KTWFkYWxpbg0K
