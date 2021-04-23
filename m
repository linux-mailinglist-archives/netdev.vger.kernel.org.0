Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEF1A368B20
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 04:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240107AbhDWCiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 22:38:14 -0400
Received: from mail-vi1eur05on2082.outbound.protection.outlook.com ([40.107.21.82]:42656
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230367AbhDWCiO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 22:38:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aoQP/6KHol8mXVYQPOESga310ZUFIsiR6zLXzMvY8QPlXVsX2LSQBl98UmYgfaNA09MyTnB2bBb7HKRTY8BVeNXn9kIfSTanMCDbygTKdfhUS88RToJcQod4s+MX4Rdi6bhkSpKPzBStvnR/PNURJFdVRoynom1AONk36O9ge/l+mghRxx7FgEPfHKQIJivdKLa6hB4fBQlb7e7bt2aJ/f3YBW3lSDUmf9NDz3bHzOgIcucV/A0/ERLv7sBMxM30Og2t4FV1DHYdhOkivTHe0pOXHMEd6+9w4S1DxLLUtXmo4QAwQMizuwM5An/1kkB1Ib12v/W5HqVktvNhO8AuaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LIAQKIrx6mWuOl8bqm6xEaUPXO6j8b0RqwkOMxqH/Z8=;
 b=J+t+1EUrzWwV2ev+xVkIW0mknW3vwAr6wrSxgRWwoOV8diLf1of+3yMobvTY2THpdk8wbI2qx/2ecOQMuCy4rbVYrhrKroU3wPt5j68+sd/S0eTkNThw0fGKoEmeOUETIRsivXLjn+2f5eswYNTAnJgS7bSgFjxuhswqxkKKiasymgRvVEGsRbnghhGqlsJX3l3ZwImBVJ9nCanUSK5KmSbfdw61uV+JSNvUg0wtCrRYB0n1jNunz1IIVkxbIkOxl/ezCQIAELwpFdRP7KLnxIeq7S/anF93uidjW7zo+0/BLnLHaOZTMySbO9XomznCoJJT8j0ICl4Bhkmk5VDqfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LIAQKIrx6mWuOl8bqm6xEaUPXO6j8b0RqwkOMxqH/Z8=;
 b=gdBRCoMiSQ6JQBg7eyWOhFRoLcf25aQefuFHmbMqC4tyB6Gr9kX/3Gdbruk8Q6eKHN6tX5cqv4Sl1QNossP2+fwJMZE0KF4Oa78zN7Zed2kAVl1ZViWxgjQJ7h1pocFENHHtwyP+1EBKZDGeq/I7XomzhDG82s1tSd4xmzI6RkY=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7429.eurprd04.prod.outlook.com (2603:10a6:10:1a2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Fri, 23 Apr
 2021 02:37:35 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%7]) with mapi id 15.20.4065.021; Fri, 23 Apr 2021
 02:37:35 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "treding@nvidia.com" <treding@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [RFC net-next] net: stmmac: should not modify RX descriptor when
 STMMAC resume
Thread-Topic: [RFC net-next] net: stmmac: should not modify RX descriptor when
 STMMAC resume
Thread-Index: AQHXNRN2zsKOwhYLU0OtzigMEkddiqq78qqAgACuHyCAAMibgIACfU4wgADTrQCAAA1lgIAACQgAgACSuxA=
Date:   Fri, 23 Apr 2021 02:37:35 +0000
Message-ID: <DB8PR04MB6795520586BE91835A6CAA43E6459@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210419115921.19219-1-qiangqing.zhang@nxp.com>
 <f00e1790-5ba6-c9f0-f34f-d8a39c355cd7@nvidia.com>
 <DB8PR04MB67954D37A59B2D91C69BF6A9E6489@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <cec17489-2ef9-7862-94c8-202d31507a0c@nvidia.com>
 <DB8PR04MB67953A499438FF3FF6BE531BE6469@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <2cf60306-e2b9-cc24-359c-774c9d339074@gmail.com>
 <9abe58c4-a788-e07d-f281-847ee5b9fcf3@nvidia.com>
 <22bf351b-3f01-db62-8185-7a925f19998e@gmail.com>
In-Reply-To: <22bf351b-3f01-db62-8185-7a925f19998e@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2fc5ca01-feec-4c6f-0478-08d90600c0f1
x-ms-traffictypediagnostic: DBAPR04MB7429:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBAPR04MB7429825CC1E7653D8D41C034E6459@DBAPR04MB7429.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xGNXFofxNs6zz2msSuJmvByUeQ6sa79MOtujrR7wigxdhbLAmeTBWk8efHM3YTnxJauPOQ//FdtUoS6qmxQX/3mT3MifauiwKyV/7xiYvaj3yRbEDWUuCpgtErgYY5AvKMr8cht8hFYbrNWHj1Phm8JXxzZ9Npsl6/SkS7f6N/NCLBNR1HatSHxTnLQ+D4q+Sc1QTpQhNPmhecNeYke3+FaEk3n3wo2MHK+r14qg30lqqhPVLep/YvE0coY5h4D5udJLQTkFc+wfRIGc1VlQCDvmGgJpnzzIxTlWY253HneO89D/PaAvJUeNojGIjrsjj3/mNjEo/woJDZmbLpZ2qdjHIgjAv6Tr76792lZvKOP2vAwXn4Ftj1QJZ3cY9AY+2SRHPC/QZkkaSZxrtxGjatPJdO66eLfaBAbLze9i5/cOgn8+SmuXihTaZfWtLeTtM5tYUF+mIWmkRToYXtbSFiebxzePXaqlYiA07ZlfRLKiIIijksvtcV+b3RETQYmxDi+ZbEoIu82vDZ4VjikaK8TPHuGoEk7dHq4KBQS0xFQ8wbFFugEsJ9PiwAymXEYGatshwjpTotfecFIwLnaUdi+zb2Ti1zK9dGOB/0MfpnBOqkwfQLHASagNF3hli1V5LR+qMBgXT1pP2xzQYTX0AiVTPf+gjR26ri1jixN/SQiv4tLx7Gjq7o9/zdH4PvBe
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(366004)(346002)(39860400002)(71200400001)(316002)(53546011)(55016002)(66556008)(76116006)(9686003)(86362001)(52536014)(7416002)(110136005)(66946007)(8936002)(26005)(186003)(54906003)(4326008)(122000001)(33656002)(45080400002)(38100700002)(66476007)(83380400001)(7696005)(478600001)(966005)(8676002)(6506007)(64756008)(66446008)(5660300002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?UElRSGN2cFZua0srSEN2S0VxZW5LRUlvbHozcHp5U292VDFLTGp0SGcyTFVF?=
 =?gb2312?B?QzgzZUhBNEJ0YW1xQnUwUVh2d2RiTGY0V1phUFdkbG5FVE5ibVhyYnJ4ek0y?=
 =?gb2312?B?VUxFempTM3dKTjQrQVBtZWtMR0tXZ0RyN09ZWjdnNCs1M0pxWFNoTzh1WCtV?=
 =?gb2312?B?WkhwOGZCWkQ0L2NqTVRPclZveE9lNG9zOVJTZ1I4R3BNMTRhckw5Ym1iSzQ2?=
 =?gb2312?B?TU4yeitqY08zTUlJd0pSajlqejZVaDI5cHRvUjY4SHVWd0d2SmhXdGkvQ3VR?=
 =?gb2312?B?Z0s5Z2NJV0NXSW5hUkFWWDRSOEJUWUNQcmhSNVgyRXp1Vm54enRtWE5SbVAw?=
 =?gb2312?B?aGZXa21KaFNZQnJnYm9mRldCdC9laThGTWdOUXBkbWthZFJrL3NoWXFIMTVH?=
 =?gb2312?B?TmpMdnpKK29mMkdMZEhQL01JbUdSSnRwS3JnbVZxV1hTUGNKeVA2ZGJMNXMx?=
 =?gb2312?B?Z3lMQlcrMXFWeHBFOE84QldwajZYZ3JSMTExMFM2VVZPWEtuYmNIWFI4d2Fy?=
 =?gb2312?B?bFA1R2RCRC9DdkhJYXF2cWJQbTdLOXl3VjJaQWNLTUhyZHJJRkZDQXIweWFO?=
 =?gb2312?B?ZHhqbi9vbWJTVjZmTkpBVGVzZHByWXdqK1ljaUtzdDlRRkZTR1FOL3VENTRq?=
 =?gb2312?B?ckNmTWY5d0RqNm9xSjhTejJ4MTBWVjhDZGhsQVN0blMwSjZVdjdQT3k0RHdR?=
 =?gb2312?B?dHhsbkMvY1UrQU5sKzhjdnoyQ0xkNzVKSVdkRTMvYkVIMzhVQmNzb2orTDJB?=
 =?gb2312?B?TE5NZENPaENUOTl1S0tRbEJWRU5wekhqRWpOQ1ZtcWsxcHVqSzdCMnBVWmsr?=
 =?gb2312?B?Yk5DaWQ1NnNRci9CYnozWFlxRHE5VDlzandYdUs4b2duY0FaelZ2aVZoUWQ5?=
 =?gb2312?B?NnNWSXB6a2htdWJVR2duRzJud2o5M085YklPQUxXQ3VyWDZVU0hMd0RJRGxs?=
 =?gb2312?B?VDFMRG5jSkpockEraGNRM2dJc0p1QWZod0RRVWRFVHpuTDZiTy83M3dBeFVC?=
 =?gb2312?B?TDhSWHF5SHdIQXdnRFdlZVdGd2wrRnJuTG13dFFubFoweW45Z0N6T3Y3cHBT?=
 =?gb2312?B?R0JpaHJoM3V3SGFIU1NlRGZncXZCT3d1LzRZZjNCYm00bmRZdGdZRS95dkIr?=
 =?gb2312?B?T3ZPSy9lenY1OUN3eUluaHVjN3pkZE5Vdlc0ZlAyY0l6MXpDeEhQSFl5WGt4?=
 =?gb2312?B?dE0rS0tTUHAwbUg0R2dNYmRuOEMxS05KTFAvcGpBQUpCaFkrNVQyL3VNY3dF?=
 =?gb2312?B?UmFNY2FEb044WHR1NXlIL2FnQklyc2V4bktxRjVWS0xiaVFhdUJvNXJUaVZH?=
 =?gb2312?B?cjVKQVBSYzVjbCt2cnZyRmEralRMeUVEa3AzelNLWUVHaUppUW95ZC9NNlJt?=
 =?gb2312?B?M2xsR1ZzY3pOV0lqY2U2Z0ZMRmdjMi9hcXptelQ0Q25oR1hzZTZrV0xGK0V4?=
 =?gb2312?B?WEFqT1o0ZzRvNlpSb2pNdHc4MTk3aHFQVW9LMjVremFlWFl4a1c0cUFQWFc5?=
 =?gb2312?B?RkZGRkFXcncwVEZLbUx3TWFVNDdDQUY5T1NmQ0pybWR2aGlwZkdLOUNYOUM2?=
 =?gb2312?B?Ylp0WDVIOHBUaVJySy9SeVhmWnZYb0U1MFNRR3A5bzJtOE05eFRtaWRkUHhI?=
 =?gb2312?B?WlpRZHdjNCthbGJHNzU5cXl4WG81NTJkVGZLMjQxRVR2NUdWMVdESEJ5blRZ?=
 =?gb2312?B?YzUxWkN0RG9PY2VGT1Z1SGg3dmwrVnU3RWtUZ1N1YXQrQ3hqMHlWcmM5MUlD?=
 =?gb2312?Q?zMgZE/SrXaNAjjLZi8dpGrD8T7W/YBVHv2Ob98D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fc5ca01-feec-4c6f-0478-08d90600c0f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2021 02:37:35.5258
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fF0HoGy3wB8MTqiWay0Ih447LrvXRRLE4dAreE0SMLV3JRzaTsiXiQF0ceOHNSXK0gEuWfzvNaSdMcj982biUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7429
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBGbG9yaWFuLCBKb2huLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZy
b206IEZsb3JpYW4gRmFpbmVsbGkgPGYuZmFpbmVsbGlAZ21haWwuY29tPg0KPiBTZW50OiAyMDIx
xOo01MIyM8jVIDE6MzMNCj4gVG86IEpvbiBIdW50ZXIgPGpvbmF0aGFuaEBudmlkaWEuY29tPjsg
Sm9ha2ltIFpoYW5nDQo+IDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT47IHBlcHBlLmNhdmFsbGFy
b0BzdC5jb207DQo+IGFsZXhhbmRyZS50b3JndWVAZm9zcy5zdC5jb207IGpvYWJyZXVAc3lub3Bz
eXMuY29tOw0KPiBkYXZlbUBkYXZlbWxvZnQubmV0OyBrdWJhQGtlcm5lbC5vcmc7IG1jb3F1ZWxp
bi5zdG0zMkBnbWFpbC5jb207DQo+IGFuZHJld0BsdW5uLmNoDQo+IENjOiBkbC1saW51eC1pbXgg
PGxpbnV4LWlteEBueHAuY29tPjsgdHJlZGluZ0BudmlkaWEuY29tOw0KPiBuZXRkZXZAdmdlci5r
ZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUkZDIG5ldC1uZXh0XSBuZXQ6IHN0bW1hYzogc2hv
dWxkIG5vdCBtb2RpZnkgUlggZGVzY3JpcHRvciB3aGVuDQo+IFNUTU1BQyByZXN1bWUNCj4gDQo+
IA0KPiANCj4gT24gNC8yMi8yMDIxIDEwOjAwIEFNLCBKb24gSHVudGVyIHdyb3RlOg0KPiA+DQo+
ID4gT24gMjIvMDQvMjAyMSAxNzoxMiwgRmxvcmlhbiBGYWluZWxsaSB3cm90ZToNCj4gPg0KPiA+
IC4uLg0KPiA+DQo+ID4+IFdoYXQgZG9lcyB0aGUgcmVzdW1wdGlvbiBmYWlsdXJlIGxvb2tzIGxp
a2U/IERvZXMgdGhlIHN0bW1hYyBkcml2ZXINCj4gPj4gc3VjY2Vzc2Z1bGx5IHJlc3VtZSBmcm9t
IHlvdXIgc3VzcGVuZCBzdGF0ZSwgYnV0IHRoZXJlIGlzIG5vIG5ldHdvcmsNCj4gPj4gdHJhZmZp
Yz8gRG8geW91IGhhdmUgYSBsb2cgYnkgYW55IGNoYW5jZT8NCj4gPg0KPiA+IFRoZSBib2FyZCBm
YWlscyB0byByZXN1bWUgYW5kIGFwcGVhcnMgdG8gaGFuZy4gV2l0aCByZWdhcmQgdG8gdGhlDQo+
ID4gb3JpZ2luYWwgcGF0Y2ggSSBkaWQgZmluZCB0aGF0IG1vdmluZyB0aGUgY29kZSB0byByZS1p
bml0IHRoZSBSWA0KPiA+IGJ1ZmZlcnMgdG8gYmVmb3JlIHRoZSBQSFkgaXMgZW5hYmxlZCBkaWQg
d29yayBbMF0uDQo+IA0KPiBZb3UgaW5kaWNhdGVkIHRoYXQgeW91IGFyZSB1c2luZyBhIEJyb2Fk
Y29tIFBIWSwgd2hpY2ggc3BlY2lmaWMgUEhZIGFyZSB5b3UNCj4gdXNpbmc/DQo+IA0KPiBJIHN1
c3BlY3QgdGhhdCB0aGUgc3RtbWFjIGlzIHNvbWVob3cgcmVseWluZyBvbiB0aGUgUEhZIHRvIHBy
b3ZpZGUgaXRzDQo+IDEyNU1IeiBSWEMgY2xvY2sgYmFjayB0byB5b3UgaW4gb3JkZXIgdG8gaGF2
ZSBpdHMgUlggbG9naWMgd29yayBjb3JyZWN0bHkuDQpZZXMsIGZvciBpLk1YIHBsYXRmb3Jtcywg
d2UgbmVlZCBQSFkgZmVlZHMgaXRzIFJYQyBjbG9jayBiYWNrIHRvIFNUTU1BQyBmb3IgUlggbG9n
aWMsIG5vdCBzdXJlIGlmIGl0IGlzIG5lZWQgZm9yIE5WSURJQSBwbGF0Zm9ybXMuDQpBbmQgbm93
IHN0bW1hYyByZXN1bWUgUEhZKHBoeWxpbmtfc3RhcnQpIGJlZm9yZSBpbml0aWFsaXplIE1BQy4N
Cg0KPiBPbmUgZGlmZmVyZW5jZSBiZXR3ZWVuIHVzaW5nIHRoZSBCcm9hZGNvbSBQSFkgYW5kIHRo
ZSBHZW5lcmljIFBIWSBkcml2ZXJzDQo+IGNvdWxkIGJlIHdoZXRoZXIgeW91ciBCcm9hZGNvbSBQ
SFkgZHJpdmVyIGVudHJ5IGhhcyBhIC5zdXNwZW5kLy5yZXN1bWUNCj4gY2FsbGJhY2sgaW1wbGVt
ZW50ZWQgb3Igbm90Lg0KDQpJZiB0aGVyZSBpcyBubyAuc3VzcGVuZC8ucmVzdW1lIGNhbGxiYWNr
LCB0aGUgUEhZIHNob3VsZCBhbHdheXMgd29yay4gSSBoYXZlIGEgY29uY2VybiwgZG9lcyBCb2Fy
ZGNvbSBhbHdheXMgY2FuIGZlZWQgY29udGludW91cyBSWCBjbG9jaz8gRG9lcyBpdCBzdXBwb3J0
IEVFRT8NCg0KQmVzdCBSZWdhcmRzLA0KSm9ha2ltIFpoYW5nDQo+ID4NCj4gPj4gSXMgcG93ZXIg
dG8gdGhlIEV0aGVybmV0IE1BQyB0dXJuZWQgb2ZmIGluIHRoaXMgc3VzcGVuZCBzdGF0ZSwgaW4N
Cj4gPj4gd2hpY2ggY2FzZSBjb3VsZCB3ZSBiZSBtaXNzaW5nIGFuIGVzc2VudGlhbCByZWdpc3Rl
ciBwcm9ncmFtbWluZyBzdGFnZT8NCj4gPg0KPiA+IEl0IHNlZW1zIHRvIGJlIG1vcmUgb2YgYSBz
ZXF1ZW5jaW5nIGlzc3VlIHJhdGhlciB0aGFuIGEgcG93ZXIgaXNzdWUuDQo+ID4NCj4gPiBJIGhh
dmUgYWxzbyByYW4gMjAwMCBzdXNwZW5kIGN5Y2xlcyBvbiBvdXIgVGVncmEgcGxhdGZvcm0gd2l0
aG91dA0KPiA+IEpvYWtpbSdzIHBhdGNoIHRvIHNlZSBob3cgc3RhYmxlIHN1c3BlbmQgaXMgb24g
dGhpcyBwbGF0Zm9ybS4gSSBkaWQNCj4gPiBub3Qgc2VlIGFueSBmYWlsdXJlcyBpbiAyMDAwIGN5
Y2xlcyBhbmQgc28gaXQgaXMgbm90IGV2aWRlbnQgdG8gbWUNCj4gPiB0aGF0IHRoZSBwcm9ibGVt
IHRoYXQgSm9ha2ltIGlzIHRyeWluZyB0byBmaXggaXMgc2VlbiBvbiBkZXZpY2VzIHN1Y2ggYXMg
VGVncmEuDQo+ID4gQWRtaXR0ZWRseSwgaWYgaXQgaXMgaGFyZCB0byByZXByb2R1Y2UsIHRoZW4g
aXQgaXMgcG9zc2libGUgd2UgaGF2ZQ0KPiA+IG5vdCBzZWVuIGl0IHlldC4NCj4gPg0KPiA+IEpv
bg0KPiA+DQo+ID4gWzBdDQo+ID4gaHR0cHM6Ly9ldXIwMS5zYWZlbGlua3MucHJvdGVjdGlvbi5v
dXRsb29rLmNvbS8/dXJsPWh0dHBzJTNBJTJGJTJGbG9yZQ0KPiA+IC5rZXJuZWwub3JnJTJGbmV0
ZGV2JTJGZTQ4NjQwNDYtZTUyZi02M2I2LWE0OTAtNzRjM2NkODA0NWY0JTQwbnZpZGlhDQo+IC5j
DQo+ID4NCj4gb20lMkYmYW1wO2RhdGE9MDQlN0MwMSU3Q3FpYW5ncWluZy56aGFuZyU0MG54cC5j
b20lN0NhNGNlOWE4OWINCj4gOTJjNGY2MDANCj4gPg0KPiA4NDYwOGQ5MDViNGEyODUlN0M2ODZl
YTFkM2JjMmI0YzZmYTkyY2Q5OWM1YzMwMTYzNSU3QzAlN0MwJTdDNjMNCj4gNzU0NzA5NQ0KPiA+
DQo+IDYzOTc4OTk3MCU3Q1Vua25vd24lN0NUV0ZwYkdac2IzZDhleUpXSWpvaU1DNHdMakF3TURB
aUxDSlFJam9pDQo+IFYybHVNeklpDQo+ID4NCj4gTENKQlRpSTZJazFoYVd3aUxDSlhWQ0k2TW4w
JTNEJTdDMTAwMCZhbXA7c2RhdGE9eExnWWtZaXQwRWZPWGJiTQ0KPiBsejc4d3MNCj4gPiBiNHcx
OVczNkEwRnZQdmthUHpsN28lM0QmYW1wO3Jlc2VydmVkPTANCj4gPg0KPiANCj4gLS0NCj4gRmxv
cmlhbg0K
