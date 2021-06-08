Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1510339F348
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 12:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbhFHKQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 06:16:36 -0400
Received: from mail-eopbgr60054.outbound.protection.outlook.com ([40.107.6.54]:47745
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229626AbhFHKQf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 06:16:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NE0s1H9qKhyzXI5DdX9eUpgReAyj5hJh/01AWLjC5Hcs7YFvUNmR4p+X84OtZKwod3M33nfbabhLKfsm98sVp/iGj4pBys0zMdcUqQT0WUT4T0ztx8RcmCXT8RbCR9L3+UyPVVJFY5Gbk32fiRMIKeMaaau3MKFPtlzJLLQMMRw++qvSIo5/n8nKiwpRQDEA/KWLM6IWX2Y7WzI1fpzBcZht+nmGOCQS0h9fgGThVj8Wj6eCDezz1mzoh1Sfy/FRPZBdrRrttfAKNiTRxb57Co6BO4EEhX8w1HA7KnMzz6SB012aFwU9/n7iZRq8BitKY2k75GKHDciKwrx0I6IVEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9w4qBMnFDzhMAbJI7EfiHnuBd36mMMHQWPNUtXYytMM=;
 b=hLLxR1swZAMppx3s2InmEHqHQHSntZMItN9R2jilzUcPIuRJZ27pKBezOPCdRbmsSi9KKLDUx20WPXiUew+LEfcohDPj0bkA+Stz91pZggFFp+LQsiq1LDefukoltKpoPpJKUF4y/MyNq0FKQ2/UfbRdvXJSJONkyAacqm+nLsDVO1wKQUdZMf9G457p8xLSLlJIgE2U+Fl4k3TFDuMUvgc4DP/mWTibf+QcLJlkyJN9s9J9pQx5QTOiW0gaeXije8R280ZAWu/UpvYLOgA9uhg2M3S3yHcnrTv64nsjKnHLQCtm4j4H2hyRgxkGPFZwSbpD26paj2L6znaQU5Za9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9w4qBMnFDzhMAbJI7EfiHnuBd36mMMHQWPNUtXYytMM=;
 b=f92oxFpPYwKod1eXQCoR8xITYKtvk8iPee8XDdxrgbNxvkumSlFJCnYQ2WaDkC7gID86eyYcJXjxnuvUeZi98qi+yM12/4PfVEVG97eJr1I2HXJuWru3kQtevMMfSZx0/dAt31Lz+53G+z2Dc5OIxRT7TXQj/qrmSfnZoAs3BC8=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20; Tue, 8 Jun
 2021 10:14:40 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4219.020; Tue, 8 Jun 2021
 10:14:40 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Jisheng Zhang <Jisheng.Zhang@synaptics.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V3 net-next 3/4] net: phy: realtek: add dt property to
 enable ALDPS mode
Thread-Topic: [PATCH V3 net-next 3/4] net: phy: realtek: add dt property to
 enable ALDPS mode
Thread-Index: AQHXXBSh0nhwyLkWNESDxO+tqgeOSKsJ324AgAAFxMA=
Date:   Tue, 8 Jun 2021 10:14:40 +0000
Message-ID: <DB8PR04MB6795D312FDECF820164B0DE6E6379@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210608031535.3651-1-qiangqing.zhang@nxp.com>
        <20210608031535.3651-4-qiangqing.zhang@nxp.com>
 <20210608175104.7ce18d1d@xhacker.debian>
In-Reply-To: <20210608175104.7ce18d1d@xhacker.debian>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: synaptics.com; dkim=none (message not signed)
 header.d=none;synaptics.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e8519de5-1571-4582-2fef-08d92a663a8f
x-ms-traffictypediagnostic: DB8PR04MB6795:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB67951E92435F21C4BF3BED63E6379@DB8PR04MB6795.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: G9oTLfxO3tWbvpuMd9YCr5XEH1FqANlsbx0bOeeNfxBBbfA9EVIfkNft7GcXAtGqpPbxceN/wg0pb59bXot956PPArLowymFK4JqVqxq44lxFobXyGpXe+9E1qXw3G9CrMI+zUyp71UQvP1RtNUdWd3HyFkNBsPOcylcfhPKWkPqZPrlXE8LXoxlqdGwzVk6FWINkKSBUpH540vMi3EMAtpc6MNohatu/lIzKQRy7HDQdgDz/DRnubKpslShXJyFyGKhYZLseKB6m0Ws/JVPYAmQKp6nwlpDkpENxF98oABLcrajwihB9NPcSjNkmJLGarWmPNNQ6sJDk+bgYnW45P34RXBX24pR1yeI2j/EWAqU8rKxu/lR5qSDnPVzyZrlVoS+N5kbURS8UFpeZDTvaE+XEMlAEq7nVn8BRMfH2gS6G4p7H3Tw0QuaYX3MUW6/xz3bRIA6WCAJ03QgkdRt8yylHE+swlsI9W0DR8XI/7ejCsqE1eg3OhMVT9sX803e2rx0l1V0yQcVgXqCY9RROTAGvXDx/5KwdP9uNhlhECXbjVlGUFJEzI6bJ0NIYvbbk+NiVdukjsEBIPa6P3iBennyxVVkPUKO7+V2ra3kErA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(33656002)(55016002)(6916009)(54906003)(71200400001)(38100700002)(8936002)(52536014)(122000001)(498600001)(186003)(8676002)(66476007)(66556008)(64756008)(66446008)(53546011)(7696005)(9686003)(86362001)(7416002)(83380400001)(66946007)(5660300002)(4326008)(6506007)(76116006)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?empSZUR5dWRCTVBFdFBMS3ZwQWdnU2lGMTUxWVJobjdHRWdlRHZNQlVjYXFO?=
 =?gb2312?B?TVR5Y2NEUzB4R2hXVForK2FZSUxsM0pSWU03MzlITXpyMXRRUElFRW4venlP?=
 =?gb2312?B?cEdteUJFOGtnZjd3S2J1ZmJsKzVXRGU1bFJMRFdFMEhmNDlHbTZFb3hKRE5V?=
 =?gb2312?B?RnlDQjdVbFRQSldFaWo3OHZRaUNoaCtGemlING9zRkdUdU0vUC9IcDh6OSsy?=
 =?gb2312?B?RzhiWnJ6UjhtdmFEam9YYy9aWDRhZ2dEMUFtTGo4a00zTmQxTWFVMEJKbDJD?=
 =?gb2312?B?VU1KWXJCQnE5QUQ0V3JBTk1Rdy9rMEoxK2lvUElYOHFBM1B0NjVQVXpWN2Zx?=
 =?gb2312?B?SWI1TTJmc3pPSktXU0poL1BlRUI0aW43MCtMNmdXU2p2d2lCZ0cycWN5TmM0?=
 =?gb2312?B?RmpFMU81SjFna1hTWElleXdFNzNHR214NVduV0hFdzFKZkZGVkFXL2lFOWs5?=
 =?gb2312?B?SWRUTytKTUlzQUJGejJOaFM4TkxxaXZBb3A5cXhRRUNKcERhMUxKMzFEWFV2?=
 =?gb2312?B?NnNTYUdBMC9GMm96Q0VkMFZLbmEvWGVFMFN6ZStOYnZpQzJIYkdCSmtIVDZx?=
 =?gb2312?B?ZXR3QUhlcktOZVJvdEpsanE1MmVrcTV6NjZzRkQ4MWdCYit5Zy8ySzdDello?=
 =?gb2312?B?UFdnVU1KaFJRaitBdmZ4M21NR1pRajB4eStlNjArQXVjbEpHakFiSWN6NFNh?=
 =?gb2312?B?UUt6eHA3cm9wMHRUZWdmamVZUXhmNDNPUVRWWjVEeGdBM3V1Q3YvdjJUVU9t?=
 =?gb2312?B?TDlBR3lMYk14WTkxUEhteW9yZjN2aG9NdUxBWFBLcUt2a0cyYTYxTVRMNVJu?=
 =?gb2312?B?WENyL0ZnMmtwNUNYdU9QOFhIeUNkZkxKNmtPbC9HQTRJZS8rYkoxcmE2bjVW?=
 =?gb2312?B?WFF1aC90dGQwZXNxOTdtaGg3NzY4WHVLbUUxbWhqeDVRMFM0bHBnNTllZWFJ?=
 =?gb2312?B?a3RLb0NzczYzV1ZaVUxEMEg4ZjhOZkxBd2ptR2JiU1NXMjBVU25HQmo5UFo5?=
 =?gb2312?B?dXZ3SUkxNFNDZk1taTZNLy9uM3daN1NLS21XN1NBZXNBR1VHNG52aWdSMnBG?=
 =?gb2312?B?WlQzQXBkU0RFNmtYYjhERE9vLzBCbTVScTlDMWU5MGZnTUtZYU5EVS9DbEw2?=
 =?gb2312?B?OFdVOUNPQThybC9lcFhOMS8rdS91VFFHU1JlWDdKdW5raUNVeEFKcGxmTm9t?=
 =?gb2312?B?bzVXNWp6cEhLa2RtbXp4bGtpLzhMdmtNVlRCWFhZNklOZy8wTkVCR2FtWkpU?=
 =?gb2312?B?UkN0T0djR3dkaXpBN1pUZWR2U3BCWGYzaFRwSUltdENPTkkvWk9sUkVsK2hY?=
 =?gb2312?B?anFsRmQrZktVcUFvSUNxRSthMVdCT0I3R2VrVmR6MDRzNGtSSTVNeFFTei8v?=
 =?gb2312?B?NHFQQzFqWDczS25WNkQzUEdPUmVzejlTQlA3OFdkZ2hpa1ZTS2lXZVV3SlNw?=
 =?gb2312?B?dElSSlBGc3lKN2ZLLzJkMHJDU3pZYWpZQmNLUm1nbXJEb3FZSEthYTRjSndx?=
 =?gb2312?B?YnZuWnR3elg3aWg3aG5BUExVVktDTzFqZkE5MmhvTzhEWDNyNXJwaG5HQUdp?=
 =?gb2312?B?RGsvcm5tTDhCa25aUmw5TzNNTjZIVWpmcTNMRGYrQWtYQStzY3VuOUtQY043?=
 =?gb2312?B?THYwWlVCcUFZZXpVcWdmYXh2c0FOYk1YNjJ2Zjg5R0FOY29VTVpORnM5aTls?=
 =?gb2312?B?UU50dGxrT3hhR1BHb3ozZFJEaVE3cEZQN0svbTFOK0JnTkp6UXZkUjc2RTNX?=
 =?gb2312?Q?EH6ieuMEwXXRgzRaT3qknN6xjZf7cIZju+D45Fc?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8519de5-1571-4582-2fef-08d92a663a8f
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2021 10:14:40.6252
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U8lz5AhfKgg260bTi77XnFq4EfL8Da6pNpfrlzVPzdQkfANXtG9dWRRURewJb8DLaNbfJcfRRJcs16dyxbcCFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6795
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBKaXNoZW5nLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEpp
c2hlbmcgWmhhbmcgPEppc2hlbmcuWmhhbmdAc3luYXB0aWNzLmNvbT4NCj4gU2VudDogMjAyMcTq
NtTCOMjVIDE3OjUxDQo+IFRvOiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29t
Pg0KPiBDYzogZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsga3ViYUBrZXJuZWwub3JnOyByb2JoK2R0QGtl
cm5lbC5vcmc7DQo+IGFuZHJld0BsdW5uLmNoOyBoa2FsbHdlaXQxQGdtYWlsLmNvbTsgbGludXhA
YXJtbGludXgub3JnLnVrOw0KPiBmLmZhaW5lbGxpQGdtYWlsLmNvbTsgZGwtbGludXgtaW14IDxs
aW51eC1pbXhAbnhwLmNvbT47DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGRldmljZXRyZWVA
dmdlci5rZXJuZWwub3JnOw0KPiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IFN1Ympl
Y3Q6IFJlOiBbUEFUQ0ggVjMgbmV0LW5leHQgMy80XSBuZXQ6IHBoeTogcmVhbHRlazogYWRkIGR0
IHByb3BlcnR5IHRvDQo+IGVuYWJsZSBBTERQUyBtb2RlDQo+IA0KPiBPbiBUdWUsICA4IEp1biAy
MDIxIDExOjE1OjM0ICswODAwDQo+IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5j
b20+IHdyb3RlOg0KPiANCj4gDQo+ID4NCj4gPg0KPiA+IElmIGVuYWJsZSBBZHZhbmNlIExpbmsg
RG93biBQb3dlciBTYXZpbmcgKEFMRFBTKSBtb2RlLCBpdCB3aWxsIGNoYW5nZQ0KPiA+IGNyeXN0
YWwvY2xvY2sgYmVoYXZpb3IsIHdoaWNoIGNhdXNlIFJYQyBjbG9jayBzdG9wIGZvciBkb3plbnMg
dG8NCj4gPiBodW5kcmVkcyBvZiBtaWxpc2Vjb25kcy4gVGhpcyBpcyBjb21maXJtZWQgYnkgUmVh
bHRlayBlbmdpbmVlci4gRm9yDQo+ID4gc29tZSBNQUNzLCBpdCBuZWVkcyBSWEMgY2xvY2sgdG8g
c3VwcG9ydCBSWCBsb2dpYywgYWZ0ZXIgdGhpcyBwYXRjaCwNCj4gPiBQSFkgY2FuIGdlbmVyYXRl
IGNvbnRpbnVvdXMgUlhDIGNsb2NrIGR1cmluZyBhdXRvLW5lZ290aWF0aW9uLg0KPiA+DQo+ID4g
QUxEUFMgZGVmYXVsdCBpcyBkaXNhYmxlZCBhZnRlciBoYXJkd2FyZSByZXNldCwgaXQncyBtb3Jl
IHJlYXNvbmFibGUNCj4gPiB0byBhZGQgYSBwcm9wZXJ0eSB0byBlbmFibGUgdGhpcyBmZWF0dXJl
LCBzaW5jZSBBTERQUyB3b3VsZCBpbnRyb2R1Y2Ugc2lkZQ0KPiBlZmZlY3QuDQo+ID4gVGhpcyBw
YXRjaCBhZGRzIGR0IHByb3BlcnR5ICJyZWFsdGVrLGFsZHBzLWVuYWJsZSIgdG8gZW5hYmxlIEFM
RFBTDQo+ID4gbW9kZSBwZXIgdXNlcnMnIHJlcXVpcmVtZW50Lg0KPiA+DQo+ID4gSmlzaGVuZyBa
aGFuZyBlbmFibGVzIHRoaXMgZmVhdHVyZSwgY2hhbmdlcyB0aGUgZGVmYXVsdCBiZWhhdmlvci4N
Cj4gPiBTaW5jZSBtaW5lIHBhdGNoIGJyZWFrcyB0aGUgcnVsZSB0aGF0IG5ldyBpbXBsZW1lbnRh
dGlvbiBzaG91bGQgbm90DQo+ID4gYnJlYWsgZXhpc3RpbmcgZGVzaWduLCBzbyBDYydlZCBsZXQg
aGltIGtub3cgdG8gc2VlIGlmIGl0IGNhbiBiZSBhY2NlcHRlZC4NCj4gPg0KPiA+IENjOiBKaXNo
ZW5nIFpoYW5nIDxKaXNoZW5nLlpoYW5nQHN5bmFwdGljcy5jb20+DQo+ID4gU2lnbmVkLW9mZi1i
eTogSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4gPiAtLS0NCj4gPiAg
ZHJpdmVycy9uZXQvcGh5L3JlYWx0ZWsuYyB8IDIwICsrKysrKysrKysrKysrKysrLS0tDQo+ID4g
IDEgZmlsZSBjaGFuZ2VkLCAxNyBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KPiA+DQo+
ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3BoeS9yZWFsdGVrLmMgYi9kcml2ZXJzL25ldC9w
aHkvcmVhbHRlay5jDQo+ID4gaW5kZXggY2EyNThmMmE5NjEzLi43OWRjNTViYjQwOTEgMTAwNjQ0
DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvcGh5L3JlYWx0ZWsuYw0KPiA+ICsrKyBiL2RyaXZlcnMv
bmV0L3BoeS9yZWFsdGVrLmMNCj4gPiBAQCAtNzYsNiArNzYsNyBAQCBNT0RVTEVfQVVUSE9SKCJK
b2huc29uIExldW5nIik7DQo+ID4gTU9EVUxFX0xJQ0VOU0UoIkdQTCIpOw0KPiA+DQo+ID4gIHN0
cnVjdCBydGw4MjF4X3ByaXYgew0KPiA+ICsgICAgICAgdTE2IHBoeWNyMTsNCj4gPiAgICAgICAg
IHUxNiBwaHljcjI7DQo+ID4gIH07DQo+ID4NCj4gPiBAQCAtOTgsNiArOTksMTQgQEAgc3RhdGlj
IGludCBydGw4MjF4X3Byb2JlKHN0cnVjdCBwaHlfZGV2aWNlICpwaHlkZXYpDQo+ID4gICAgICAg
ICBpZiAoIXByaXYpDQo+ID4gICAgICAgICAgICAgICAgIHJldHVybiAtRU5PTUVNOw0KPiA+DQo+
ID4gKyAgICAgICBwcml2LT5waHljcjEgPSBwaHlfcmVhZF9wYWdlZChwaHlkZXYsIDB4YTQzLA0K
PiBSVEw4MjExRl9QSFlDUjEpOw0KPiA+ICsgICAgICAgaWYgKHByaXYtPnBoeWNyMSA8IDApDQo+
ID4gKyAgICAgICAgICAgICAgIHJldHVybiBwcml2LT5waHljcjE7DQo+ID4gKw0KPiA+ICsgICAg
ICAgcHJpdi0+cGh5Y3IxICY9IChSVEw4MjExRl9BTERQU19QTExfT0ZGIHwNCj4gPiArIFJUTDgy
MTFGX0FMRFBTX0VOQUJMRSB8IFJUTDgyMTFGX0FMRFBTX1hUQUxfT0ZGKTsNCj4gDQo+IHByaXYt
PnBoeWNyMSBpcyAwIGJ5IGRlZmF1bHQsIHNvIGFib3ZlIDUgTG9DcyBjYW4gYmUgcmVtb3ZlZA0K
DQpUaGUgaW50ZW50aW9uIG9mIHRoaXMgaXMgdG8gdGFrZSBib290bG9hZGVyIGludG8gYWNjb3Vu
dC4gU3VjaCBhcyB1Ym9vdCBjb25maWd1cmUgdGhlIFBIWSBiZWZvcmUuDQoNCkJlc3QgUmVnYXJk
cywNCkpvYWtpbSBaaGFuZw0KPiA+ICsgICAgICAgaWYgKG9mX3Byb3BlcnR5X3JlYWRfYm9vbChk
ZXYtPm9mX25vZGUsICJyZWFsdGVrLGFsZHBzLWVuYWJsZSIpKQ0KPiA+ICsgICAgICAgICAgICAg
ICBwcml2LT5waHljcjEgfD0gUlRMODIxMUZfQUxEUFNfUExMX09GRiB8DQo+ID4gKyBSVEw4MjEx
Rl9BTERQU19FTkFCTEUgfCBSVEw4MjExRl9BTERQU19YVEFMX09GRjsNCj4gPiArDQo+ID4gICAg
ICAgICBwcml2LT5waHljcjIgPSBwaHlfcmVhZF9wYWdlZChwaHlkZXYsIDB4YTQzLA0KPiBSVEw4
MjExRl9QSFlDUjIpOw0KPiA+ICAgICAgICAgaWYgKHByaXYtPnBoeWNyMiA8IDApDQo+ID4gICAg
ICAgICAgICAgICAgIHJldHVybiBwcml2LT5waHljcjI7DQo+ID4gQEAgLTMyNCwxMSArMzMzLDE2
IEBAIHN0YXRpYyBpbnQgcnRsODIxMWZfY29uZmlnX2luaXQoc3RydWN0IHBoeV9kZXZpY2UNCj4g
KnBoeWRldikNCj4gPiAgICAgICAgIHN0cnVjdCBydGw4MjF4X3ByaXYgKnByaXYgPSBwaHlkZXYt
PnByaXY7DQo+ID4gICAgICAgICBzdHJ1Y3QgZGV2aWNlICpkZXYgPSAmcGh5ZGV2LT5tZGlvLmRl
djsNCj4gPiAgICAgICAgIHUxNiB2YWxfdHhkbHksIHZhbF9yeGRseTsNCj4gPiAtICAgICAgIHUx
NiB2YWw7DQo+ID4gICAgICAgICBpbnQgcmV0Ow0KPiA+DQo+ID4gLSAgICAgICB2YWwgPSBSVEw4
MjExRl9BTERQU19FTkFCTEUgfCBSVEw4MjExRl9BTERQU19QTExfT0ZGIHwNCj4gUlRMODIxMUZf
QUxEUFNfWFRBTF9PRkY7DQo+ID4gLSAgICAgICBwaHlfbW9kaWZ5X3BhZ2VkX2NoYW5nZWQocGh5
ZGV2LCAweGE0MywgUlRMODIxMUZfUEhZQ1IxLCB2YWwsDQo+IHZhbCk7DQo+ID4gKyAgICAgICBy
ZXQgPSBwaHlfbW9kaWZ5X3BhZ2VkX2NoYW5nZWQocGh5ZGV2LCAweGE0MywNCj4gUlRMODIxMUZf
UEhZQ1IxLA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFJUTDgy
MTFGX0FMRFBTX1BMTF9PRkYgfA0KPiBSVEw4MjExRl9BTERQU19FTkFCTEUgfCBSVEw4MjExRl9B
TERQU19YVEFMX09GRiwNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBwcml2LT5waHljcjEpOw0KPiA+ICsgICAgICAgaWYgKHJldCA8IDApIHsNCj4gPiArICAgICAg
ICAgICAgICAgZGV2X2VycihkZXYsICJhbGRwcyBtb2RlICBjb25maWd1cmF0aW9uIGZhaWxlZDog
JXBlXG4iLA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgIEVSUl9QVFIocmV0KSk7DQo+ID4g
KyAgICAgICAgICAgICAgIHJldHVybiByZXQ7DQo+ID4gKyAgICAgICB9DQo+ID4NCj4gPiAgICAg
ICAgIHN3aXRjaCAocGh5ZGV2LT5pbnRlcmZhY2UpIHsNCj4gPiAgICAgICAgIGNhc2UgUEhZX0lO
VEVSRkFDRV9NT0RFX1JHTUlJOg0KPiA+IC0tDQo+ID4gMi4xNy4xDQo+ID4NCg0K
