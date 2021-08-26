Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4DD3F8EC1
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 21:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243459AbhHZTex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 15:34:53 -0400
Received: from mail-eopbgr1400108.outbound.protection.outlook.com ([40.107.140.108]:2262
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230008AbhHZTew (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 15:34:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dH+3MlIVurqBPI+9iB4usj1DwohrvgHDh95TuS03mXy4ygwehZ1PX8ehC9yDwCiWibRpqgFQTK2C7DzLuSiour7K1rallzYMYSrCJS6YZdSzrnLCoXvW53ygw5Af7pxZ7WM9pvwyZY7qdwt2Ud706XJ1z2aKe2B4CYdHYCgePzINMLFoJAG1QJFHd0JxYHiSs7bQrz3H3BbV5uWnr1ghOp8l3dJxaTgNII1AeQHtTYurxwRv6b69jGcHWLlIrPhzlTnTJmmNfVpccB9Vu/fDOk2pkcKpwzM6c7rCMJQoQ6X0CKoBJH7b83Mn73oQIu550teesAH98/k87Hj/LaIRVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OpPskXmQhtplshzx9Glk+68SMGSb0FdMyH6NDpM16Ss=;
 b=IBqTAVfyyLkmWfNurR9aKPTcHIZ9QB7sXsxoQEpUV8PaCmhYc7dGZVzdzrVrh7lAAW/CYleL4qNtjSD+OMs7GxI2WJJhF0LKdCftdrPJ9k5ml+HOFmonO/5Bt0A4aDSjZzCZUNnFrhh0Hawt7waDBpnMmyq8hLVn8tTZKyeFNQMXAQLSi7+GBHnDLegiqStFb6VbueFiBKoBGjs1gCQ0zva8LPXl6CmRtsvgC7rSZp88tA+95oUEho3ckIbsBVMH72LHaiONqMD5c4r/mquIwzmzYokKfONX2gUH5sR4gRKeisgi5RgQMa+6j/Ai9p23sET+hwf4tHsDk9s4HZXYkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OpPskXmQhtplshzx9Glk+68SMGSb0FdMyH6NDpM16Ss=;
 b=qyEckG+7uSLd/RwucP394nkl3GVAsBLfKJMnaIylbeVunhiWoksVclrscps+veuPkkpy5TF9bfnbbQdaTfOHWhE8IjFHmsg/MA674MPRQhNyFuARlUjPumFqdsSZC0HeatHODM0uP0ABAf4vY+xghNEi4iDFrhIvNkL0v6Gpi/I=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSBPR01MB3477.jpnprd01.prod.outlook.com (2603:1096:604:44::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.24; Thu, 26 Aug
 2021 19:34:01 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::e111:61:43af:3b98]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::e111:61:43af:3b98%3]) with mapi id 15.20.4436.025; Thu, 26 Aug 2021
 19:34:00 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: RE: [PATCH net-next 06/13] ravb: Factorise ravb_ring_format function
Thread-Topic: [PATCH net-next 06/13] ravb: Factorise ravb_ring_format function
Thread-Index: AQHXmX8rtXjF6s0Dr06Lwy+SEIhliquGJLUAgAAIyQA=
Date:   Thu, 26 Aug 2021 19:34:00 +0000
Message-ID: <OS0PR01MB59228C3EDA5A6D01504169F486C79@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210825070154.14336-1-biju.das.jz@bp.renesas.com>
 <20210825070154.14336-7-biju.das.jz@bp.renesas.com>
 <2ba347ab-ff1a-68c3-a577-2ce1b4a35392@omp.ru>
In-Reply-To: <2ba347ab-ff1a-68c3-a577-2ce1b4a35392@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4ea2e4aa-9cdc-4446-828a-08d968c8742d
x-ms-traffictypediagnostic: OSBPR01MB3477:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB347737ECE68212335EE1B73986C79@OSBPR01MB3477.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:125;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XxN7Ga/FCcgWBNLa/4ZG1owi9YAKZfm3T+l/z0R++xejBwO0HNczuPeJYy1xOrcIMvHMiD0I+x61mCRdt/cCdfcEx9G389tfdaL2o5FMFx3DrvGUE3bZQbnP2Bnfq7HwLVqSd/yZdSTdgPeUbYBo660rOJzab3EsoZY0jcW7ts2SAShl00kd/O5ydcMaj0P6s7Tq1XxIozd36dPDecfSloYMv1IzolH5eXTkB+IUTiNe8Mq71KkRwsZ59/iY5fqQSDfDD1uxrHBLyLG+qCn3XEmNlwSrHth6u2kOjECEFzl35favnwwTuwjyaGtFCveGGlJ6CqwXgQpN9kW/OfEgZaNPNw7cVA1/oxzbIJv39yOCjt27+uOfaAXMPRe5ZRMxRTURuV15BmizDyQZdTw6yQo8sNymi7H98cKUAeFTfFyfqtdmqIWjBdxEOBo/m4U4E2svga7YP5uow7GzV1LjS8VuYNKHSjhATEJI+0okRhiso+faBAGHbCNBl5v04bHawsstE1uO7Sisc6QiSBDsypxT1/uWTNVRy1x91TBvaQhxAZ4k0Qlf/52Un8LvcuG296bdUngvMzOVlD/Zy8QwJgLADQvvRDDog34Adg7xIqJu49vGvf75GmoKaJqD9j0GqIisZjTwCctbzwGnnqfbJfCiJwdaobq4wh9hyH2LFgx/Pmy3k3NY18kaCOjBvKFYtq2yJmfuiIlJru4DmcVZhH2KujAMprTDFogR+kcNtFgt//0nDhXeRu9fFY8NRcW033jyP+fZcnhnvnNHRbXC/l7CZVj+q4FUJV6ed6vr3cQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(396003)(346002)(39850400004)(136003)(966005)(5660300002)(71200400001)(52536014)(26005)(8936002)(8676002)(186003)(64756008)(478600001)(107886003)(66556008)(86362001)(110136005)(4326008)(66946007)(66446008)(66476007)(53546011)(38100700002)(54906003)(122000001)(76116006)(9686003)(2906002)(55016002)(38070700005)(7696005)(316002)(6506007)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aC80L2orUUMySjZrUXNUVXFDUnNLSlQ3VXlkNGovTzhWYWZFTk9pU1ZtVTJw?=
 =?utf-8?B?aFlVUHc5SWxwem1MMjVHekdJN1Z2aXpQRGRaTlUwRFY0ZDRQQTRYYk5rN01M?=
 =?utf-8?B?cVpzUnoveUZTbGs0Vm51Nkp3UUJDN3E4SHQrcFkxREI2dFJYVlc1Y3JkbkFC?=
 =?utf-8?B?WExPRVJHY3dIQS9nNTErSUY4dkdBbTNpOTFrbTNMTVN5VjZJWXhwRm1kcHBn?=
 =?utf-8?B?VjhvWktSc0ZwN2haWTk0SjVtQ3BQN0pUclNMejh6WmErSkhSRmxtMDdLTkxX?=
 =?utf-8?B?QjdSNTM0alljNUJ3ZzdWQ1NzaUN0aU13endGOWdSOHEvOWh3UHpNQUJ6MDZl?=
 =?utf-8?B?QjF1RnhQNVZhdWsxb1lmOURQS2d5alpneHBBOXM3NnJlYUhKdk81d3cvbFBE?=
 =?utf-8?B?dEFtM0h4VnVTN0lXNDZEZmIvYWJlblE0b2kxSDArNnc4c0lsaGRYSlhjdmE0?=
 =?utf-8?B?emlGeENMWk5rRkhFd2hQUVF4NFh0TXhneGR4dEdWbEZ5OGJxN0YyQlpoZGxt?=
 =?utf-8?B?V01OOUU1NUxCSWZvejNvbzVmVE9xcUxIalhRdTdVMWtuSGJJNjhSWW9Md3oz?=
 =?utf-8?B?d1haNEtYYkJ3WE9BWVJwVWNXa2FvS1RtWlM1NTcrL3ZoNEhvMWFKaWI4ako2?=
 =?utf-8?B?eUlaOHZJTTFURHJvK2J4M0lyWjhxdEpVQ0ZhN1MzY3lxQlVmaDVua0tvYVNs?=
 =?utf-8?B?Q0VkcnZ3OGpSNWJLdU1LTjNQT01CSVpPYXJpbkRXZVVLbUxOQ1FBUXRqYzV6?=
 =?utf-8?B?QUVqNVNLbUJCRi80OElZaWUzaXUxQjdmWHNyOERyQUNUQUxrMzlpTlNHZUdK?=
 =?utf-8?B?NmpGcnlPQ1IrZG04QVZOQkFRNEFKc0RLL2tmaFZ2cWhuYWE1a01Gai9VVVNV?=
 =?utf-8?B?NEdtUFpXOS9ZaHFtcXNwNGRzSE1zRk5IbDNYVmZhRFFMQUROUzk3K294K2xw?=
 =?utf-8?B?UjhDYVE2SDdQMEhiMm5PNVp0NFovVDB0cTZMa2wrVjlJZmdqWWZITFh0Tk1U?=
 =?utf-8?B?UXpRVjIvdmZkdEZ6YUx0OGwxbVVROWZaRmYyV2hsa2hJOW1yeGFKc3VJbzFV?=
 =?utf-8?B?L21rbTM4bWV3ZXZJaFphM1JwSkhuU2kyZ202cDRHekJQZHNFZ1BqVTlMdC9a?=
 =?utf-8?B?WkhTelI4TE1UdHdHakQrT0FVTExGNWtQVEJLNEVzcElLRU5aZVhkOXRuWkw3?=
 =?utf-8?B?MTRPcmU4ZTVGYnorbDhxalNCZG5oRHZhMnRCd1dKNW1LVVVxOVNHNEUxVGpx?=
 =?utf-8?B?dnhrTEE0dURmaUExcUhVcTV1eFdDREg1bGV0eENHaW1JWTVXRStHTGRwdjU0?=
 =?utf-8?B?Q1ZYMW1wVFRuU3FOVmM0T1J3alArWXRGN1NFNlJSdDZ0OEVzNDAyMThRY2d6?=
 =?utf-8?B?RGhXdHphTjN2N1NWZ3lSNCthcTllR2cyNXFrV1Vvd21TcUdrN0M2OGVEOFda?=
 =?utf-8?B?V1J0cFJNc3pJd052N0ZZd0tqTi9lZ29YbU1UT0FFa0RBSVNjMWVLOFFjRG93?=
 =?utf-8?B?TXBBd2JtMkQ2UXNxOU9rNlN0VVM3amRBT2QwamFiVi95cEJIWHBtUlZtQUcy?=
 =?utf-8?B?OXQwN3AzNnVsT2xySnB6a2x3Z3ZWTXV3bGxqdkRCVWFtN0dnSkY5cjVkaVJy?=
 =?utf-8?B?RkZUWE9tUk9QM2h2NGlBZ3lqRm9yK24zYkFzdDRNanVCenZBR0tqRDdNZHRD?=
 =?utf-8?B?b1hqK01XcHVJN3ozeENQKzR4SUlUd0ZtdzRJOEFKSFVEZmZrV2J1MDBKbklE?=
 =?utf-8?Q?DM+7ivXuB1id+bjvLc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ea2e4aa-9cdc-4446-828a-08d968c8742d
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2021 19:34:00.0428
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8F4U7kqsL7+RCwFKq0ccbaUCvBiAK0Aa+A1/HaFq8IyYWnVQxXSjP+BZ50u2G/YQdP7pUxduezWFGBh49slwnGcRCZNAh6pLiPX8Gii6T/g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB3477
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgMDYvMTNdIHJhdmI6
IEZhY3RvcmlzZSByYXZiX3JpbmdfZm9ybWF0DQo+IGZ1bmN0aW9uDQo+IA0KPiBPbiA4LzI1LzIx
IDEwOjAxIEFNLCBCaWp1IERhcyB3cm90ZToNCj4gDQo+ID4gVGhlIHJhdmJfcmluZ19mb3JtYXQg
ZnVuY3Rpb24gdXNlcyBhbiBleHRlbmRlZCBkZXNjcmlwdG9yIGluIFJYIGZvcg0KPiA+IFItQ2Fy
IGNvbXBhcmVkIHRvIHRoZSBub3JtYWwgZGVzY3JpcHRvciBmb3IgUlovRzJMLiBGYWN0b3Jpc2Ug
UlggcmluZw0KPiA+IGJ1ZmZlciBidWlsZHVwIHRvIGV4dGVuZCB0aGUgc3VwcG9ydCBmb3IgbGF0
ZXIgU29DLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogQmlqdSBEYXMgPGJpanUuZGFzLmp6QGJw
LnJlbmVzYXMuY29tPg0KPiA+IFJldmlld2VkLWJ5OiBMYWQgUHJhYmhha2FyIDxwcmFiaGFrYXIu
bWFoYWRldi1sYWQucmpAYnAucmVuZXNhcy5jb20+DQo+IFsuLi5dDQo+ID4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPiBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPiBpbmRleCBkYzM4OGEzMjQ5NmEu
LmU1MmUzNmNjZDFjNiAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5l
c2FzL3JhdmJfbWFpbi5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9y
YXZiX21haW4uYw0KPiBbLi4uXQ0KPiA+IEBAIC0zMjEsNiArMzEwLDI2IEBAIHN0YXRpYyB2b2lk
IHJhdmJfcmluZ19mb3JtYXQoc3RydWN0IG5ldF9kZXZpY2UNCj4gKm5kZXYsIGludCBxKQ0KPiA+
ICAJcnhfZGVzYyA9ICZwcml2LT5yeF9yaW5nW3FdW2ldOw0KPiA+ICAJcnhfZGVzYy0+ZHB0ciA9
IGNwdV90b19sZTMyKCh1MzIpcHJpdi0+cnhfZGVzY19kbWFbcV0pOw0KPiA+ICAJcnhfZGVzYy0+
ZGllX2R0ID0gRFRfTElOS0ZJWDsgLyogdHlwZSAqLw0KPiA+ICt9DQo+ID4gKw0KPiA+ICsvKiBG
b3JtYXQgc2tiIGFuZCBkZXNjcmlwdG9yIGJ1ZmZlciBmb3IgRXRoZXJuZXQgQVZCICovIHN0YXRp
YyB2b2lkDQo+ID4gK3JhdmJfcmluZ19mb3JtYXQoc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYsIGlu
dCBxKSB7DQo+ID4gKwlzdHJ1Y3QgcmF2Yl9wcml2YXRlICpwcml2ID0gbmV0ZGV2X3ByaXYobmRl
dik7DQo+ID4gKwljb25zdCBzdHJ1Y3QgcmF2Yl9od19pbmZvICppbmZvID0gcHJpdi0+aW5mbzsN
Cj4gPiArCXVuc2lnbmVkIGludCBudW1fdHhfZGVzYyA9IHByaXYtPm51bV90eF9kZXNjOw0KPiA+
ICsJc3RydWN0IHJhdmJfdHhfZGVzYyAqdHhfZGVzYzsNCj4gPiArCXN0cnVjdCByYXZiX2Rlc2Mg
KmRlc2M7DQo+ID4gKwl1bnNpZ25lZCBpbnQgdHhfcmluZ19zaXplID0gc2l6ZW9mKCp0eF9kZXNj
KSAqIHByaXYtPm51bV90eF9yaW5nW3FdDQo+ICoNCj4gPiArCQkJCSAgICBudW1fdHhfZGVzYzsN
Cj4gPiArCXVuc2lnbmVkIGludCBpOw0KPiA+ICsNCj4gPiArCXByaXYtPmN1cl9yeFtxXSA9IDA7
DQo+ID4gKwlwcml2LT5jdXJfdHhbcV0gPSAwOw0KPiA+ICsJcHJpdi0+ZGlydHlfcnhbcV0gPSAw
Ow0KPiA+ICsJcHJpdi0+ZGlydHlfdHhbcV0gPSAwOw0KPiA+ICsNCj4gPiArCWluZm8tPnJ4X3Jp
bmdfZm9ybWF0KG5kZXYsIHEpOw0KPiA+DQo+ID4gIAltZW1zZXQocHJpdi0+dHhfcmluZ1txXSwg
MCwgdHhfcmluZ19zaXplKTsNCj4gPiAgCS8qIEJ1aWxkIFRYIHJpbmcgYnVmZmVyICovDQo+IA0K
PiAgICBUaGF0J3MgYWxsIGZpbmUgYnV0IHRoZSBmcmFnbWVudCB0aGF0IHNldHMgdXAgVFggZGVz
Y3JpcHRvciByaW5nIGJhc2UNCj4gYWRkcmVzcyB3YXMgbGVmdCBpbiByYXZiX3J4X3JpbmdfZm9y
bWV0KCkuLi4NCg0KQ2FuIHlvdSBwbGVhc2UgY2xhcmlmeSB0aGlzPyBXaGljaCBmcmFnbWVudCBp
biBbMV0/IERvIHlvdSBzZWUgYW55IHByb2JsZW1zIHdpdGggdGhhdD8NCg0KWzFdIGh0dHBzOi8v
Z2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L25ldGRldi9uZXQtbmV4dC5n
aXQvdHJlZS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jI24yODYNCg0K
UmVnYXJkcywNCkJpanUNCg0KDQpSZWdhcmRzLA0KQmlqdQ0K
