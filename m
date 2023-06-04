Return-Path: <netdev+bounces-7814-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2915872199C
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 22:00:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 398C21C20A46
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 19:59:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2AF5111A6;
	Sun,  4 Jun 2023 19:59:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D3F23AD
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 19:59:59 +0000 (UTC)
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2090.outbound.protection.outlook.com [40.107.22.90])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D33390
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 12:59:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TR5Nr5GKTaDpSFjBZqLlfgKK9EHBnTGN1kznQqFLRdzWnT0Xn1cvdeA/mhPpNh50sCEc6xBoNlVznaZHAmj3pab4JikUjG0CkT44O6BeOUbKaRiUyUME4wlYRzIQz71uykrnbT3C5WIY9WlbWH5AY+L1H6vbBoRPtwI3JTM17f2CaIZh5ilKVYC6DbtuwysEJhwrnc3tFIjvXYKpwBc2jIRVcGXFLqnL9P1iYtkXAApedVnJDyLshDR5wRfnqxciARr4Vkd7gj3kuKR+99NC8csbbuoJgKnE6xOyWC9LBWyPnwj00wEYCRo4LpeIoZfyOkxfntcczFJLxtR2jXtMJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rCoc+jwnOYATjF9qXq07sy/iQsKY8cTLoh5bjC2pscM=;
 b=bo4BBF2HD9SQSCOuSG8z1bO40XTkHF2pvB4lj33FbXPkQTBIBdfG4RYyWxlaJ5eM3OdJAfXB3x3VoHaGcxaJMkeczhIaeRbE/tMAOeMV4ikUK3KtPujEULRap8hkjLpOQhCSFkp3DfVMVzhk2w246rlUJFkeqNscM/pkROjdzwoNPmLT3aS2ILvSXSNMmz81CN0N77TOFXAW6gEQ6dl940ncy6Ojkd+v13ciHxXHfe6qBBxLl+QX0SmukPfOmjzOzAcb6UkoL9OHre2jTiGKsDUG0byf7mHXlVvHTb7BRaoQForrFs0E605nfLOQqUrKfDBB4BbGCqh+qa2M25xRgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rCoc+jwnOYATjF9qXq07sy/iQsKY8cTLoh5bjC2pscM=;
 b=cXSGYmHWa1uV35R6gRPjx+73+MXw0bzzyD15xE26L7Ml3kM5S7R6vUE6IMf3G25SY6DykGuzJbUZVfg7zBgzf+sLEDFwDrwqvfStZN2Elsbu+O72SfzYbGIRVDadFPuGtVGO3MHHl5v1cOnmdkEwqUyYJ0AxbksHAsMABrz6xVM=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AM9PR03MB7946.eurprd03.prod.outlook.com (2603:10a6:20b:439::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Sun, 4 Jun
 2023 19:59:56 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::b8e6:a92f:367e:801f]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::b8e6:a92f:367e:801f%7]) with mapi id 15.20.6455.030; Sun, 4 Jun 2023
 19:59:56 +0000
From: =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To: Christian Lamparter <chunkeey@gmail.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "luizluca@gmail.com"
	<luizluca@gmail.com>, "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
	"andrew@lunn.ch" <andrew@lunn.ch>, "olteanv@gmail.com" <olteanv@gmail.com>,
	"f.fainelli@gmail.com" <f.fainelli@gmail.com>
Subject: Re: [PATCH v1] net: dsa: realtek: rtl8365mb: add missing case for
 digital interface 0
Thread-Topic: [PATCH v1] net: dsa: realtek: rtl8365mb: add missing case for
 digital interface 0
Thread-Index: AQHZlaUbiNIpGpW+YUqQiFxKZayVsq96f9CAgAAePoCAAHTrgA==
Date: Sun, 4 Jun 2023 19:59:56 +0000
Message-ID: <p6ijs4ejr6b55xphrjnwxf7tr376qsb2cdyyec6ejcvdhf74ga@rjd5b2mlz636>
References:
 <40df61cc5bebe94e4d7d32f79776be0c12a37d61.1685746295.git.chunkeey@gmail.com>
 <xh2nnmdasqngkycxqvpplxzwu5cqjnjsxp2ssosaholo5iexti@7lzdftu6dmyi>
 <802305c6-10b6-27e6-d154-83ee0abe3aeb@gmail.com>
In-Reply-To: <802305c6-10b6-27e6-d154-83ee0abe3aeb@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM6PR03MB3943:EE_|AM9PR03MB7946:EE_
x-ms-office365-filtering-correlation-id: ef5ca4d7-7ca2-493a-7bd5-08db653644d7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 uSDeNn5zcCHXPjbuL8Szl1Jntuf2tHczybiRJ7MamXzmtxfaAitH5V2njkk2NsPLE5bRyuqZTFixC6SWSUbVbWn7GwHAhePwHi4pl6KNkE6owgomgmI1TNbyNQfpEvdMPm3L5Pi8YNNmsSvozkBNCazaYZ6ph8s9HO2yFvLaU/frXy3ZbbgSnHhUxLBuAmyY2NF8Y1rDdnvQFkK0SqRs3wo5xgkNzcQRxwzvo+6ELq6pL7mEYOgUkC6cs8AB6I1vdA63y1H77x4KzS7nTbfML45EJFcBJxi+ADW2sSlia7tS4ZQ5pDo9oQpzcBcOZJT4a/uUDBJqWS3FWFNCX+Ue12q6CkRkY9B0Yta4s5lDCogTE2JlBdXqLotIuXH1EQT2cJKU+t2I9J4zZimnhQpAMkIkYxO6W7E1z5QAArflG+jGQ5i5i+oYjmR85iFXfH0C3FTaBAMoBXrjcBFrau8/VqlPh5QlKTipOcHqBVpzwtuT464aLF7GI4DJ3uRastMsCdD7Kg4E3SEyc9PpT7/UT3gplJCAJYSPJgr8t9+EJrx6xYPhc+DqbhgnROIpT4rXvUJYnx77YDiurECcK8u5v7VXULOxtCRhHVHfYiYchMiGD+y/zIldEydxvnueM2Ra
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(39850400004)(376002)(366004)(136003)(396003)(346002)(451199021)(66574015)(54906003)(478600001)(8676002)(8936002)(38070700005)(316002)(66476007)(91956017)(66556008)(66946007)(76116006)(41300700001)(122000001)(66446008)(64756008)(4326008)(5660300002)(38100700002)(86362001)(6916009)(6486002)(85182001)(2906002)(71200400001)(85202003)(186003)(33716001)(9686003)(6506007)(26005)(6512007)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dG9CV3FYbXlhYkQ3Nm5kVXVmd2VVS2JkQXYzY1p0RWZJYWFMWEVNRFB3L0t2?=
 =?utf-8?B?T0k4R2ZHRTdCOS83em56cFFQeVdYMFl0a0dYNUNoVmVrU1d6UFFKYk02QzBr?=
 =?utf-8?B?Wk8wWFhkdnJBb1h4ejV0MUtwaStRTGhYSmZWbWtXUWZucjI3RENidVdFa3lD?=
 =?utf-8?B?WTlTcDI2Q05rRW9HOTZoU0hrUzZ2RnhWR0RsR0FIcGV3bERYZUh3OVd2dGFF?=
 =?utf-8?B?MmNURExFL1oyWHAyUnBXSStVWkdZLzY3QmxyR055ZUVuTmNNbDNWcXBrcmdD?=
 =?utf-8?B?RElLYTU2MHh0eGRYamJYSUd3RGF5UWhBUGhiZkJxanhBVHpRQ1hwenFsRDV1?=
 =?utf-8?B?UTJlZFc1cUF0TTJzR2xLNWk0S2MyeG1jWWpUNGtIRE5taStRcW1INFE5WUc1?=
 =?utf-8?B?bTlTTFNXLzRMQTZKN1FuaWw3b1gzcDRuRzF1a0RvOHZKR1JtclhSSzduaDkv?=
 =?utf-8?B?VnNOY0hQcVJ0TFRySW9IMVVseS8wZktqVW9XdC8yU2lUZUVReEdKOTZCN0gr?=
 =?utf-8?B?NGdUMFF2REFNVnBVRjJIbHJxVzFiQWdzQURDUzM0cHBnVlBteGtRUm16c21y?=
 =?utf-8?B?NlQ3UklJVHNUbzhoM1JNV1NVVDJwNC9ERVpBNy9ad1dSOERhZk1IOUZ6ZVF2?=
 =?utf-8?B?REhWUkJhemgzNGhXNTJMc3Z1c3lneEhOOVJpYnl5RlFVVUoyV0lldUExNk0z?=
 =?utf-8?B?RXNDK2pUdXZ4dWo2VkxxbG1FU0lXNzZNOE53anhNNVNLZUdJRWFqd0I2WE9o?=
 =?utf-8?B?dFl1eUFNUUVSUTJxc0JrM3VzNVJCYzFlbjl6a0F3K01tclRSMkVSSjAxMjRP?=
 =?utf-8?B?L3BIcVl2ZXloZGdCSkg4RUxnTkJtcHJ3NEVQTEJ3YkxSbkwwVXVrWFlhN29n?=
 =?utf-8?B?L1ovei9xbExoQktRTmZ2Zlc0ck5keTIzTm5LNWF5VEhVdXE1WkZzTzRVRXNi?=
 =?utf-8?B?NndCRUo0aHVpTEVQcVYzSnlCdkVFZm5Sc2YvckFlbUZDVnEzN0piOThrbDBk?=
 =?utf-8?B?S3pZbWxHSUNMcm5jYVhZaEhQdUNUSEViSEdVdGk1YzRLQTZVRUtONmZlOFFs?=
 =?utf-8?B?cjlBN3pqcVFCTUd1c216aHNhSmt2a00vUkl1TEMvUFI5WkZ5a2l5OU5hNm5l?=
 =?utf-8?B?ZEg4KzVPT3ZjeGtTN1JiUFI2aW9FSkFJNEltTnpOeld6LzdBKzA2WmtJemJX?=
 =?utf-8?B?aDlHUjY1YkZBeEdWaUxxazRScG5OL053ZlB4R1lSMUM3Q1NScFYrMmJMSWVa?=
 =?utf-8?B?OE16cU9VSHZtai81Vnk5UDZIYW5UK2FnQWtTOHhsdHFtYmNvS3R6bVNQYm1G?=
 =?utf-8?B?UnBZVUlQVy9HMGo0MXdIMlBFVDZtT1NjeUdBNUNqTGxkU09xNHBVSnBqZEFX?=
 =?utf-8?B?cTJRY3RkZ3AvSmo3a2VVTHB6bm9wbnBHbTRqNS81NGVyNGsxT3g1WDllVkZD?=
 =?utf-8?B?Umcrbk9oWmErQk5WNHNOV1ZOUThKSm9Qbk1RZmQ1dUlpU3lWRjlMRUF6OG0v?=
 =?utf-8?B?YWJlMmVKb3lFL09FWGJoS29COTJleU12bWJ0ZnkrMUJNMlhxWWZ3UmJYbkdQ?=
 =?utf-8?B?eHdYdS9vMVZtYnNkWVhMOWsyR1Rya2xYc1A5TXVjWHliU3I5ZTJ4bUlxcmhC?=
 =?utf-8?B?QklXdkR2Rnh1ZjNBMy9qL2NiUXJWSGVxQzR3NFNFd1JUdlFUVm41bzFqMDhB?=
 =?utf-8?B?YWpmSWgvQTdMSjdGazA5dTV6NVVlRjZuTDFKZXE4bFJQN3NNbFlnWERCbS96?=
 =?utf-8?B?S2xTSk9ZQStMakx3Q080ZlFVVXhHb3RIVnVxRGlzb242ZktwMWxHWkFtZjQ5?=
 =?utf-8?B?K2kvbUpHUER2VlR5Ti96cTEwQ0lwUEVybUtNT05wTlJzRHYzOGgzY3lTeWxs?=
 =?utf-8?B?dW9HenZVcmhrT3BOSUR6b1l0NkVGT1BtYlJvNElpRi9nTE1pNjBGUnRDL3F5?=
 =?utf-8?B?MXBlaVk1ZGJpVGdPSEtaS0NGNjNKR3RCbGk3K0ZBeWQ4VHI2eEpIYitOblNR?=
 =?utf-8?B?UTFhNC9CN1lMbTdEY0haSVprUmYwNk9nOExTdDNMKy81Y2drR1gvb1RSYnNp?=
 =?utf-8?B?YXlnaXdScFlRd1VsaUplQjJ2SzR0Ukx2WGFOeHNYOE5hVllJUm1WQU16SG9z?=
 =?utf-8?Q?q1hxrEcvoZMimgH2reG8ab1C1?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DD48057A95FF534484066727DEDE3724@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef5ca4d7-7ca2-493a-7bd5-08db653644d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2023 19:59:56.0317
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ECjYW3wHfGhr5JS4e3c10thzPH5Krzc4PWJCeqL+3hi86W1aLoB87TGd4iqtfLb5bAjrg2kd1svvg+SQ7Uwwog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR03MB7946
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

T24gU3VuLCBKdW4gMDQsIDIwMjMgYXQgMDM6MDE6MjdQTSArMDIwMCwgQ2hyaXN0aWFuIExhbXBh
cnRlciB3cm90ZToNCj4gT24gNi80LzIzIDEzOjEzLCBBbHZpbiDFoGlwcmFnYSB3cm90ZToNCj4g
PiBPbiBTYXQsIEp1biAwMywgMjAyMyBhdCAxMjo1Mzo0OEFNICswMjAwLCBDaHJpc3RpYW4gTGFt
cGFydGVyIHdyb3RlOg0KPiA+ID4gd2hlbiBicmluZ2luZyB1cCB0aGUgc3dpdGNoIG9uIGEgTmV0
Z2VhciBXTkRBUDY2MCwgSSBvYnNlcnZlZCB0aGF0DQo+ID4gPiBubyB0cmFmZmljIGdvdCBwYXNz
ZWQgZnJvbSB0aGUgUlRMODM2MyB0byB0aGUgZXRoZXJuZXQgaW50ZXJmYWNlLi4uDQo+ID4gDQo+
ID4gQ291bGQgeW91IHNoYXJlIHRoZSBjaGlwIElEL3ZlcnNpb24geW91IHJlYWQgb3V0IGZyb20g
dGhpcyBSVEw4MzYzU0I/IEkgaGF2ZW4ndA0KPiA+IHNlZW4gdGhpcyBwYXJ0IG51bWJlciBidXQg
bWF5YmUgaXQncyBlcXVpdmFsZW50IHRvIHNvbWUgb3RoZXIga25vd24gc3dpdGNoLg0KPiANCj4g
U3VyZSBDaGlwIElEIGlzIDB4NjAwMCBhbmQgQ2hpcCBWZXJzaW9uIGlzIDB4MTAwMC4gVGhlIGxh
YmVsIG9uIHRoZSBwaHlzaWNhbCBjaGlwIGl0c2VsZjoNCj4gDQo+IFJUTDgzNjNTQg0KPiBCOEU3
N1AyDQo+IEdDMTcgVEFJV0FODQo+IA0KPiBJIGFsc28gaGF2ZSBhIHByZWxpbWluYXJ5IHBhdGNo
IHRoYXQganVzdCBhZGRzIHRoZSBzd2l0Y2ggdG8gdGhlDQo+IHJ0bDgzNjVtYl9jaGlwX2luZm8g
dGFibGUuIChUaGUgLUNHIGNhbWUgZnJvbSBHb29nbGluZyBhZnRlciBSVEw4MzYzU0IpDQo+IC0t
LQ0KPiAtLS0gYS9kcml2ZXJzL25ldC9kc2EvcmVhbHRlay9ydGw4MzY1bWIuYw0KPiArKysgYi9k
cml2ZXJzL25ldC9kc2EvcmVhbHRlay9ydGw4MzY1bWIuYw0KPiBAQCAtNTE5LDYgKzUxOSwxOSBA
QCBzdHJ1Y3QgcnRsODM2NW1iX2NoaXBfaW5mbyB7DQo+ICAvKiBDaGlwIGluZm8gZm9yIGVhY2gg
c3VwcG9ydGVkIHN3aXRjaCBpbiB0aGUgZmFtaWx5ICovDQo+ICAjZGVmaW5lIFBIWV9JTlRGKF9t
b2RlKSAoUlRMODM2NU1CX1BIWV9JTlRFUkZBQ0VfTU9ERV8gIyMgX21vZGUpDQo+ICBzdGF0aWMg
Y29uc3Qgc3RydWN0IHJ0bDgzNjVtYl9jaGlwX2luZm8gcnRsODM2NW1iX2NoaXBfaW5mb3NbXSA9
IHsNCj4gKwl7DQo+ICsJCS5uYW1lID0gIlJUTDgzNjNTQi1DRyIsDQoNCkJ0dywgd2hlbiB5b3Ug
c2VuZCB0aGUgcGF0Y2gsIG9taXQgdGhlIC1DRy4gVGhlIFJUTDgzNjVNQi1WQyBmb3IgZXhhbXBs
ZSBhbHNvDQpoYXMgYSAtQ0cgc3VmZml4IGJ1dCB0aGlzIGlzIG5vdCByZWxldmFudCBhcyBpdCBy
ZWZlcnMgdG8gdGhlIHBhY2thZ2UgYmVpbmcgb2YNCidHcmVlbicgdHlwZSAod2hhdGV2ZXIgdGhh
dCBtZWFucyksIG5vdCB0aGUgc2lsaWNvbiByZXZpc2lvbi4gOik=

