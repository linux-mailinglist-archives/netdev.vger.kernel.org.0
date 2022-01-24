Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8E44978E5
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 07:26:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241605AbiAXG0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 01:26:05 -0500
Received: from mail-eopbgr60082.outbound.protection.outlook.com ([40.107.6.82]:32138
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241551AbiAXG0E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jan 2022 01:26:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=So56SnSK6KNokYIP3JEtiaKTmRdNXD9GFUlmCYHUdZ19Os154rpRvkwTHE9pASw40BEoXoepGSAVtdrNEN1sqsQ3fbdvsDp75Cxw5pjf2PjxY6B3OUfnAmrIcxC6Y86gjDmMs1q8EgiwFbC8XOU9E694cweYPhy8DXXsinen7yaxY5eE5gAUVI2joFgjDlnACMGRBaXcTlqGwb0nNW3K0lvDvTxpNRpFWqMAL1SqkVdRiqgMWjg4ToSAFMvRS6HjTgnRDugkVbzDGvROJR/sJv2x105mfzdXiU11LBaoUQ9FBWNkz8U1UiqkYyhmPZtRx3PzMj5wl2JvxPmzqEPMIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eS1aJRecqdYASjwrQggxCkg4YrROzgBbvegi+t/h8O4=;
 b=bW8RPxDGuEAY/13V/n2CTkv1Al0Li+DGyLjEYMEzbzAMFdogw23JrtYwulZtAqv/38rBREQiP7WPGpxG5K2RxymCvb8ul3AM2mxGXzBTr00y7uAtt74UAFlMRh0w/mpoS4opCbr7Z0FfYV4XXQZwB/wpaI60FaaHJDFsxHEP52/SzCh7r/5L1GKTjvEUssEwaOH4hUOZwtu6CyHVfhYiNBUt93I8Bxdyn9bJX7+huYUB8GhOoWg+W0U7JA04dyNLcQDCPQHONk50RFKQu8ObH//SQuT2teBNlCLer2woxnQEiUxdvLtYsRXocAyVUo22dLBXpm/U/oKAjqnd0zIZTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eS1aJRecqdYASjwrQggxCkg4YrROzgBbvegi+t/h8O4=;
 b=ralEVdqPQiVwiDHrPW72pxyNmRKSdhIIbk9QnvRYim6ymZrjQpEvalOD47yOJbxKoNe2W3Ol6zbl9FiwJvPuCpzys+n2G2bH0B6I5FbTj52oLXYcpAhtLS60jSlenLgVJE+IjjJ7QXrFtcg/VSJGEbY6VDJVsvAsyPH6RqxnyCQ=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by PA4PR04MB7712.eurprd04.prod.outlook.com (2603:10a6:102:ec::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.17; Mon, 24 Jan
 2022 06:25:59 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3071:c2e8:c8f5:570e]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3071:c2e8:c8f5:570e%5]) with mapi id 15.20.4909.017; Mon, 24 Jan 2022
 06:25:59 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Jisheng Zhang <jszhang@kernel.org>, Andrew Lunn <andrew@lunn.ch>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net: stmmac: don't stop RXC during LPI
Thread-Topic: [PATCH] net: stmmac: don't stop RXC during LPI
Thread-Index: AQHYEGRfG8CmCqPiu0ygexJGApNyUaxwwaqAgAAEZACAAABiAIAA4Ngg
Date:   Mon, 24 Jan 2022 06:25:58 +0000
Message-ID: <DB8PR04MB6795A6611E578530ACC337E9E65E9@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20220123141245.1060-1-jszhang@kernel.org>
 <Ye15va7tFWMgKPEE@lunn.ch> <Ye19bHxcQ5Plx0v9@xhacker>
 <Ye19vpFWXR8wJQVH@xhacker>
In-Reply-To: <Ye19vpFWXR8wJQVH@xhacker>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 12d30ebc-e00c-49d9-0c6b-08d9df0262eb
x-ms-traffictypediagnostic: PA4PR04MB7712:EE_
x-microsoft-antispam-prvs: <PA4PR04MB77127A31BD51733C2A3ADDBFE65E9@PA4PR04MB7712.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oS3Jl380FhUgDGUlBxR02HGMHr/BqgaHtsmUhx+ErCuPti//ULBtSvKzyXVEn6gRR0ajuDjZ9abLUZgoJqnaiH8S6A/9/7wZBcgHiZIMDTJwI5HiyzMAmKZIdDPmDco06tMX68CU5xNrx4OFHnnyayzFGCjVCG7AnNwz2uGarj5ERUI4oMUEzS7SfsA/VggSTQpDrXiB+TVkOiiSrApsHPV6g08VNWI6qltzXYThrk8ta8uafbbdEQNuB0slF7a7KKFMlvy/RU6FBqNBqfHTojKCKhZv1+MR0Ljabog9BghOaqvD9rwZiM6vfJQom3DdLTOkdICGylecNbugBVScnG847JPr5GbybbHFR63Wf5Xd6NgHsicUEnBu3tjdkFjhG6TbOupJ6dFk/1bFEeF0apCsPcdrbkVr9Crm2nWQpar8UmUmDgqqciW28uONzde5DGVR/sHhsXkVuc2mYwHYJh4TJNDId0DY1uXyvQ16+wwJoaL8f8BS0rqntgGJbZkV9wSFWvSgViZGrBfkKn++TRdiMhxiRixYycTKiyrk+QxkCrwn21WNE4YHaek8zd1vA4qpu/70iaNHqOnc8z+s1kqE8Z4JqVWyV/03/yeXoVQQC5QKTiZ4B8nwcZ8nR+vMWsIgKFOEaPtL6oi949OiMNNouvjTNNa8wUbt8KxY72FUPwAoWrPJwuqMh4z9TzfVpWukSbYcXVjaCfnC9gp7/4vZ4aG98EVHAx+rFoU4RBJ9WljO2moryBL1fXeGUOS4dMAKmhDXTUWZGee2HUnH5zwGOofraV0IZ6VjCEat420=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(7416002)(86362001)(7696005)(316002)(8936002)(9686003)(966005)(66946007)(76116006)(54906003)(83380400001)(66556008)(66476007)(53546011)(6506007)(33656002)(71200400001)(64756008)(8676002)(66446008)(26005)(4326008)(55016003)(52536014)(38100700002)(508600001)(110136005)(5660300002)(38070700005)(122000001)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dCtXZEhpamxrRFc5dzVOYWxYR2ZINXZTcHBqVlBrRnpPOGJmWnpOOGVsRUh0?=
 =?utf-8?B?WmJUQnVUVkNTbjYrdk5weDFaVHpLTmVUTDJOaWhuTkE0UlBKQU1JS3Z1TG1N?=
 =?utf-8?B?Qk5GZ3lmaTdwWVpiYUNoOW11TzJCWXV6cEl6MXV3S3QvOU1SRis4UHJVQWQw?=
 =?utf-8?B?dGVIWU42RzVlM0djUHpFaktOSStTZnA3UVBOSlpLNDhEL1FwSk9BcjJHeVc1?=
 =?utf-8?B?TDBQWGZzQUluVWJSZ2d1UGtrRDRISEFOR1R2QmxQbGZQcXpRdHYzMkxYcTIy?=
 =?utf-8?B?ckF1aEF3RmY2YkVtbFA1OVR4T2RoZjEyMWk1Vm9IaFRaQTNZSER4N1F2Nkxi?=
 =?utf-8?B?L0NRZ29oeTBMVDBadDRva2J5QTh5NHREdDlZNlhPZDZmVzNmeUNXakdob25P?=
 =?utf-8?B?ZGZvd2NON1JZUSsxUnJlWFBpMmRIRkRyalFUQ2ZwSXlJMHRYRUZieFBiaFFw?=
 =?utf-8?B?ek9WUmVIRWdQcGtsUkVZM3FKZTc5TkUwam85U1JPWFpsL1Y3cmNmcG5CYXU1?=
 =?utf-8?B?UGVyVDZLN3BydTAxY1MvTStpWW5qSjQ3M3cxcXNrWVVwNENVVm1oMFZEN2VC?=
 =?utf-8?B?TWh1bzB6M1g4Zi80QlNuTmVadStNVzJRMlFxUElxNG5qeXBkZWlVZjY2OXdY?=
 =?utf-8?B?M1dFMlFVRWJQbWlkUVB0ZjR0cUgvcWlHL3JTMzA1UXJnQ2dOTWwrb0Nua21Z?=
 =?utf-8?B?ZDRBVlpBMDRvS1dVWUJHMXV2anJZTFdrVi9MUXZnTVZVZklhbTZ2cVJML1h4?=
 =?utf-8?B?UXlJbDV1QVNJZWM1Rjg5QzYxWnFsSmhoTnRTT3d0a3NyWDUvSGxzL0dMR21o?=
 =?utf-8?B?OUVFNXd6eWM1a2NicFFmRy96SDdMY3hYVUoyang5L1N4by85SEZmdnErNW9n?=
 =?utf-8?B?bnQyTFVlT3B0NXB3UzlTN3JCUjI4aitRd0t0Y3Yrb3lMQTk1b1RETTYzNlJP?=
 =?utf-8?B?cnhXZGRUS3QxZzg1QUlVeXlPdUFHclBIemx1N0p4SzN1QlkwNUNjVkdJcThw?=
 =?utf-8?B?ZnNLU0FoVUdvUEFmUThnMW1yVzc1QnM4RGdKN25qUHNoUU1sTXhMS0N2cVFj?=
 =?utf-8?B?WWMyczNtWlpsZWR4ZW5wNGxmSThLTU9abDk4M044azhJQ01RUXRzbUlMMTRP?=
 =?utf-8?B?dnFFV1pDL0U1MWR6bzRzYitrelBnSjZkM3M1QnAvTjU1aGJEZThlRWdXREsv?=
 =?utf-8?B?S3Z3QnRPeFNUcTJ5a1ZxeDVITGppS3pRTExpNW5rV3dHVm03MUkrMTBRNmVN?=
 =?utf-8?B?bW00dm5paUJkMTBnaXptS1E0QXhvcjRSMmxrWUFlQXZVbDNKb3MvUnFldk45?=
 =?utf-8?B?YmpQVjBWUkQ2aFB6VXIxS2pvbE5MQkR4bjZSaXgwdTlhTGVoRFdPS3VpUzho?=
 =?utf-8?B?YW9ZL21WRnV0dWdKYkkwdGJ4aFlUNG9oa2RwWHd6VklaNGpGMmM1c3lhVk9j?=
 =?utf-8?B?U21IUUszOEJKUWx3Rml5ajlNT3MxdTQ0VXdYUnVmVUhBUlhEWHBORnRrQU5E?=
 =?utf-8?B?U3N3MkFUOVpYNjE0bEF4U05xNkxUd1k2Q25aeWVxYjJXcmh5Ym9SbHFiYjJy?=
 =?utf-8?B?ei9IeE0rUlgvSyt5T2FkN0pHUzhkWXVFSFJuMVNnYkZuQ1JCVVFFSWNVUE0v?=
 =?utf-8?B?Z205Ni9yelRxNE5uc3N4MTFLWTdwZ3Jia2FKY1dZWXcwcXQxNVVtV1NxRWhM?=
 =?utf-8?B?M3hxM1pwbE1QekptSk1iQ1A1Q3YyTEg3L21aeHVlSzV6bVBVbThrSExmTE5F?=
 =?utf-8?B?KzJKKzltb0N5Q1YwNjdhcWVhTFdIU0F4Yy9CL3A0UW1maWVueEV3R2ZvOXVs?=
 =?utf-8?B?YzVENU0wVUhUNERYdlVmUURTakttQmdpdHY4WCs4REJnL0k5UWx4djBGcUtW?=
 =?utf-8?B?MklveS9tcktsc0Fxa3ltRUpwc0I1eWFQUm9rSk41dnFWU3RsTHkwYWFxUnBo?=
 =?utf-8?B?d2xEb3dSZDFXMCs4ODJBem51NHpNdTEwcVVEaWdQcDJXN3ZuUlVCeW9SYWRl?=
 =?utf-8?B?dUIybUZ4RUNwUGMvWktBVWJqdTFYNVJCRUQraHlSUjRDK1htVkJnN0xKb0p1?=
 =?utf-8?B?U1YzMythSTRFQzIxVDlROTNMckhtMnVQemZIcXpvZUk0SnRoLzdSTFFQRVNm?=
 =?utf-8?B?eUovSkdyVjA0UU9jYVNJNG83bXNLemZSSVR1WElkN3dIdmdTb2YwVlZpcENE?=
 =?utf-8?B?SGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12d30ebc-e00c-49d9-0c6b-08d9df0262eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2022 06:25:58.9167
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hC7c5wPh/pHTPdrd6HKEFZ1yj5EaHqOOM4oQM7r+8d9zaaEyNnkVbzLGZgMuqnMzjXEEWegJ0ZSjLzGABW7fBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7712
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBKaXNoZW5nLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEpp
c2hlbmcgWmhhbmcgPGpzemhhbmdAa2VybmVsLm9yZz4NCj4gU2VudDogMjAyMuW5tDHmnIgyNOaX
pSAwOjEwDQo+IFRvOiBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+OyBKb2FraW0gWmhhbmcN
Cj4gPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPg0KPiBDYzogR2l1c2VwcGUgQ2F2YWxsYXJvIDxw
ZXBwZS5jYXZhbGxhcm9Ac3QuY29tPjsgQWxleGFuZHJlIFRvcmd1ZQ0KPiA8YWxleGFuZHJlLnRv
cmd1ZUBmb3NzLnN0LmNvbT47IEpvc2UgQWJyZXUgPGpvYWJyZXVAc3lub3BzeXMuY29tPjsNCj4g
RGF2aWQgUyAuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEpha3ViIEtpY2luc2tpIDxr
dWJhQGtlcm5lbC5vcmc+Ow0KPiBNYXhpbWUgQ29xdWVsaW4gPG1jb3F1ZWxpbi5zdG0zMkBnbWFp
bC5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOw0KPiBsaW51eC1zdG0zMkBzdC1tZC1tYWls
bWFuLnN0b3JtcmVwbHkuY29tOw0KPiBsaW51eC1hcm0ta2VybmVsQGxpc3RzLmluZnJhZGVhZC5v
cmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSF0g
bmV0OiBzdG1tYWM6IGRvbid0IHN0b3AgUlhDIGR1cmluZyBMUEkNCj4gDQo+IE9uIE1vbiwgSmFu
IDI0LCAyMDIyIGF0IDEyOjA4OjIyQU0gKzA4MDAsIEppc2hlbmcgWmhhbmcgd3JvdGU6DQo+ID4g
T24gU3VuLCBKYW4gMjMsIDIwMjIgYXQgMDQ6NTI6MjlQTSArMDEwMCwgQW5kcmV3IEx1bm4gd3Jv
dGU6DQo+ID4gPiBPbiBTdW4sIEphbiAyMywgMjAyMiBhdCAxMDoxMjo0NVBNICswODAwLCBKaXNo
ZW5nIFpoYW5nIHdyb3RlOg0KPiA+ID4gPiBJIG1ldCBjYW4ndCByZWNlaXZlIHJ4IHBrdCBpc3N1
ZSB3aXRoIGJlbG93IHN0ZXBzOg0KPiA+ID4gPiAwLnBsdWcgaW4gZXRoZXJuZXQgY2FibGUgdGhl
biBib290IG5vcm1hbCBhbmQgZ2V0IGlwIGZyb20gZGhjcA0KPiA+ID4gPiBzZXJ2ZXIgMS5xdWlj
a2x5IGhvdHBsdWcgb3V0IHRoZW4gaG90cGx1ZyBpbiB0aGUgZXRoZXJuZXQgY2FibGUNCj4gPiA+
ID4gMi50cmlnZ2VyIHRoZSBkaGNwIGNsaWVudCB0byByZW5ldyBsZWFzZQ0KPiA+ID4gPg0KPiA+
ID4gPiB0Y3BkdW1wIHNob3dzIHRoYXQgdGhlIHJlcXVlc3QgdHggcGt0IGlzIHNlbnQgb3V0IHN1
Y2Nlc3NmdWxseSwNCj4gPiA+ID4gYnV0IHRoZSBtYWMgY2FuJ3QgcmVjZWl2ZSB0aGUgcnggcGt0
Lg0KPiA+ID4gPg0KPiA+ID4gPiBUaGUgaXNzdWUgY2FuIGVhc2lseSBiZSByZXByb2R1Y2VkIG9u
IHBsYXRmb3JtcyB3aXRoIFBIWV9QT0xMDQo+ID4gPiA+IGV4dGVybmFsIHBoeS4gSWYgd2UgZG9u
J3QgYWxsb3cgdGhlIHBoeSB0byBzdG9wIHRoZSBSWEMgZHVyaW5nDQo+ID4gPiA+IExQSSwgdGhl
IGlzc3VlIGlzIGdvbmUuIEkgdGhpbmsgaXQncyB1bnNhZmUgdG8gc3RvcCB0aGUgUlhDIGR1cmlu
Zw0KPiA+ID4gPiBMUEkgYmVjYXVzZSB0aGUgbWFjIG5lZWRzIFJYQyBjbG9jayB0byBzdXBwb3J0
IFJYIGxvZ2ljLg0KPiA+ID4gPg0KPiA+ID4gPiBBbmQgdGhlIDJuZCBwYXJhbSBjbGtfc3RvcF9l
bmFibGUgb2YgcGh5X2luaXRfZWVlKCkgaXMgYSBib29sLCBzbw0KPiA+ID4gPiB1c2UgZmFsc2Ug
aW5zdGVhZCBvZiAwLg0KPiA+ID4gPg0KPiA+ID4gPiBTaWduZWQtb2ZmLWJ5OiBKaXNoZW5nIFpo
YW5nIDxqc3poYW5nQGtlcm5lbC5vcmc+DQo+ID4gPiA+IC0tLQ0KPiA+ID4gPiAgZHJpdmVycy9u
ZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvc3RtbWFjX21haW4uYyB8IDIgKy0NCj4gPiA+ID4g
IDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiA+ID4gPg0K
PiA+ID4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMv
c3RtbWFjX21haW4uYw0KPiA+ID4gPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3Rt
bWFjL3N0bW1hY19tYWluLmMNCj4gPiA+ID4gaW5kZXggNjcwOGNhMmFhNGY3Li45MmE5YjBiMjI2
YjEgMTAwNjQ0DQo+ID4gPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3Rt
bWFjL3N0bW1hY19tYWluLmMNCj4gPiA+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvc3Rt
aWNyby9zdG1tYWMvc3RtbWFjX21haW4uYw0KPiA+ID4gPiBAQCAtMTE2Miw3ICsxMTYyLDcgQEAg
c3RhdGljIHZvaWQgc3RtbWFjX21hY19saW5rX3VwKHN0cnVjdA0KPiA+ID4gPiBwaHlsaW5rX2Nv
bmZpZyAqY29uZmlnLA0KPiA+ID4gPg0KPiA+ID4gPiAgCXN0bW1hY19tYWNfc2V0KHByaXYsIHBy
aXYtPmlvYWRkciwgdHJ1ZSk7DQo+ID4gPiA+ICAJaWYgKHBoeSAmJiBwcml2LT5kbWFfY2FwLmVl
ZSkgew0KPiA+ID4gPiAtCQlwcml2LT5lZWVfYWN0aXZlID0gcGh5X2luaXRfZWVlKHBoeSwgMSkg
Pj0gMDsNCj4gPiA+ID4gKwkJcHJpdi0+ZWVlX2FjdGl2ZSA9IHBoeV9pbml0X2VlZShwaHksIGZh
bHNlKSA+PSAwOw0KPiA+ID4NCj4gPiA+IFRoaXMgaGFzIG5vdCBjYXVzZWQgaXNzdWVzIGluIHRo
ZSBwYXN0LiBTbyBpJ20gd29uZGVyaW5nIGlmIHRoaXMgaXMNCj4gPiA+IHNvbWVob3cgc3BlY2lm
aWMgdG8geW91ciBzeXN0ZW0/IERvZXMgZXZlcnlib2R5IGVsc2UgdXNlIGEgUEhZIHdoaWNoDQo+
ID4gPiBkb2VzIG5vdCBpbXBsZW1lbnQgdGhpcyBiaXQ/IERvZXMgeW91ciBzeW50aGVzaXMgb2Yg
dGhlIHN0bW1hYyBoYXZlDQo+ID4gPiBhIGRpZmZlcmVudCBjbG9jayB0cmVlPw0KPiA+ID4NCj4g
PiA+IEJ5IGNoYW5naW5nIHRoaXMgdmFsdWUgZm9yIGV2ZXJ5IGluc3RhbmNlIG9mIHRoZSBzdG1t
YWMsIHlvdSBhcmUNCj4gPiA+IHBvdGVudGlhbGx5IGNhdXNpbmcgYSBwb3dlciByZWdyZXNzaW9u
IGZvciBzdG1tYWMgaW1wbGVtZW50YXRpb25zDQo+ID4gPiB3aGljaCBkb24ndCBuZWVkIHRoZSBj
bG9jay4gU28gd2UgbmVlZCBhIGNsZWFyIHVuZGVyc3RhbmRpbmcsDQo+ID4gPiBzdG9wcGluZyB0
aGUgY2xvY2sgaXMgd3JvbmcgaW4gZ2VuZXJhbCBhbmQgc28gdGhlIGNoYW5nZSBpcyBjb3JyZWN0
DQo+ID4gPiBpbg0KPiA+DQo+ID4gSSB0aGluayB0aGlzIGlzIGEgY29tbW9uIGlzc3VlIGJlY2F1
c2UgdGhlIE1BQyBuZWVkcyBwaHkncyBSWEMgZm9yIFJYDQo+ID4gbG9naWMuIEJ1dCBpdCdzIGJl
dHRlciB0byBsZXQgb3RoZXIgc3RtbWFjIHVzZXJzIHZlcmlmeS4gVGhlIGlzc3VlIGNhbg0KPiA+
IGVhc2lseSBiZSByZXByb2R1Y2VkIG9uIHBsYXRmb3JtcyB3aXRoIFBIWV9QT0xMIGV4dGVybmFs
IHBoeS4NCj4gPiBPciBvdGhlciBwbGF0Zm9ybXMgdXNlIGEgZGVkaWNhdGVkIGNsb2NrIHJhdGhl
ciB0aGFuIGNsb2NrIGZyb20gcGh5DQo+ID4gZm9yIE1BQydzIFJYIGxvZ2ljPw0KPiA+DQo+ID4g
SWYgdGhlIGlzc3VlIHR1cm5zIG91dCBzcGVjaWZpYyB0byBteSBzeXN0ZW0sIHRoZW4gSSB3aWxs
IHNlbmQgb3V0IGENCj4gPiBuZXcgcGF0Y2ggdG8gYWRvcHQgeW91ciBzdWdnZXN0aW9uLg0KPiA+
DQo+IA0KPiArIEpvYWtpbQ0KPiANCj4gPiBIaSBKb2FraW0sIElJUkMsIHlvdSBoYXZlIHN0bW1h
YyArIGV4dGVybmFsIFJUTDgyMTFGIHBoeSBwbGF0Zm9ybSwgYnV0DQo+ID4gSSdtIG5vdCBzdXJl
IHdoZXRoZXIgeW91ciBwbGF0Zm9ybSBoYXZlIGFuIGlycSBmb3IgdGhlIHBoeS4gY291bGQgeW91
DQo+ID4gaGVscCBtZSB0byBjaGVjayB3aGV0aGVyIHlvdSBjYW4gcmVwcm9kdWNlIHRoZSBpc3N1
ZSBvbiB5b3VyIHBsYXRmb3JtPw0KDQpZZXMsIGkuTVg4TVAgdXNlcyB0aGUgc3RtbWFjICsgZXh0
ZXJuYWwgUlRMODIxMUYgd2hpY2ggd29ya3Mgb24gUEhZX1BPTEwgbW9kZS4NCkkgdHJpZWQgdGhl
IHJlcHJvZHVjZSBzdGVwcyB5b3UgcHJvdmlkZWQsIGJ1dCB0aGUgRXRoZXJuZXQgY2FuIHdvcmsg
cHJvcGVybHkuIEkgZG9uJ3Qga25vdyB3aGF0IGFibm9ybWFsIGJlaGF2aW9yIHNob3VsZCBhcHBl
YXIgb2J2aW91c2x5Pw0KDQpSZWdhcmRpbmcgdG8geW91ciByZXBvcnRlZCBpc3N1ZSwgSSBndWVz
cyB0aGlzIGlzIGEgcmVhbCBnZW5lcmFsIGlzc3VlIGZvciBTTlBTIHN0bW1hYyB3b3JraW5nIG9u
IFJHTUlJIG1vZGUsIG5vdCBzdXJlIGlmIG90aGVyIG1paSBtb2RlcyBhbHNvIHN1ZmZlciBzaW1p
bGFyIGlzc3VlLg0KQWN0dWFsbHkgd2UgaGF2ZSBhIHNhbWUgcGF0Y2ggZm9yIGl0IGF0IGxvY2Fs
IHNpbmNlIDUuMTAgdG8gZml4IGEgc3VzcGVuZC9yZXN1bWUgaXNzdWUuDQpodHRwczovL3NvdXJj
ZS5jb2RlYXVyb3JhLm9yZy9leHRlcm5hbC9pbXgvbGludXgtaW14L2NvbW1pdC9kcml2ZXJzL25l
dC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9zdG1tYWNfbWFpbi5jP2g9bGYtNS4xMC55JmlkPWE3
ODY0ZTlmYmM4ZjhmOTllNzg1Y2U3NDE5YTY4MjY1MWM4OWI4ZjcNCg0KVGhlIHJvb3QgY2F1c2Ug
aXMgdGhhdCBzdG1tYWMgbmVlZHMgUlhDIGNsb2NrIGdlbmVyYXRpbmcgZnJvbSBQSFkgZm9yIHNv
bWUgcmVjZWl2ZSBsb2dpYywgaWYgUlhDIGNsb2NrIGlzIG5vdCBmZWVkaW5nIGluIHRpbWUsIHN0
bW1hYyB3b3VsZCBiZSBicm9rZW4uIEFuZCB0aGUgZmVlZGJhY2sgZnJvbSBTTlBTIGd1eXMsIHRo
ZXkgY29uZmlybSB0aGF0IHN0bW1hYyBuZWVkcyB0aGlzIFJYQyBjbG9jayBhbmQgdGhlcmUgaXMg
bm8gb3RoZXIgY2xvY2tzIGNhbiBiZSByb3V0ZWQgaWYgUlhDIGlzIG5vdCBwcmVzZW50Lg0KIA0K
QmVzdCBSZWdhcmRzLA0KSm9ha2ltIFpoYW5nDQo=
