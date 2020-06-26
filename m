Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C36920AF7E
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 12:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbgFZKQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 06:16:05 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:41070 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726524AbgFZKQE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 06:16:04 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05QAF7W5007278;
        Fri, 26 Jun 2020 03:15:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=5U4hyhyNdWWIjCdi3ioX8TKpshoQQDau3rU0Ycrr+Pw=;
 b=sunOw+TB4+JGH2xgXUR3N8s86JhyMYKUEueiAAlOb43EIdDocQUCISZMU03suW7N5NDx
 ev16CLBIMSVEhTngJASdTD6ZyambVIpAMcztc5qYekFNUm75EgU4h5GCUO7ikGeUhaVZ
 iaGVp0U0zEvmSkLlNnWQ/yVOCmSzEEnHDAUn23DizxYlg6y0RGoLw3Rd0/2K0EYuHw3I
 DmYL/tMDe9OFEMs/EFxZkhr4O0B926G5FyhZORUnUuzTTA6AXLxyPPXsjfq0PPJXzn9z
 /ajVQi6pAuQcgk3QtSv7XHPDj8B2NK0bqefV/rebKRIb+OCtmWkcIM5Slnckh9SExH5S bw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 31uuqh42wp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 26 Jun 2020 03:15:57 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 26 Jun
 2020 03:15:56 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 26 Jun
 2020 03:15:56 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 26 Jun 2020 03:15:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P/RyjuTCzAfasP/XWP8ln/AiWDBioYguSM5yx9qaC4x4FRJx44JuF87z0jpiJGoPvbDRX7rloaxYRTIrBQTeOrJRk8L9vx4Ve/qzqtn/28UlKjKm+5YKSHCL1SmAyqYXEdW+QEEh8JrCq4RxPBqZXBmueP1hTLCrvBqH8M/Xtk4C7Mm0/a6m9PdQmf/FY6AI0hAShu+7sTh0i5TWseRpbp4W7jVvdHhTjCn1b+nz/CRgjw26+NDVfWk1AQLCjSdBao0CgbbLbzJu+6kVr8ZMKJOg6c7O13jD+ktm31xh5KyktQXIX6SjqJecuTFIAEiWFletH9lgfYZPKzxscwOj2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5U4hyhyNdWWIjCdi3ioX8TKpshoQQDau3rU0Ycrr+Pw=;
 b=X7A7fSdnf3bEprKdwNxQkMWaAZrX6bTcW8cdUMzhs7EI1TWR97ktsevC8BgtqcOXvjtyS+Kkakht+JqHwkaK9bY5E9m23oOe30cFQEh/iqL2UhKaFlt48OQv/DEo5KPcZdy4JvOg1evItBZTpXMmSh5cRBAqyUfOwhDzSikJxSuNmHKUXBOXXuxErjMwy2qCm7kCB6FF5Q4/5Ub4ds6+LsoFWMqb6BY9ekRSqUcn2FsSrJxd00gK8V/82fEZJL20Ez56PAkvkyGoNasKsoXH4WWlGuUS6egN5ycfDCPyaWJdApVnJIBNnXhMYkTcQJgOZnLfUoBJKDUmrtr73w3jHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5U4hyhyNdWWIjCdi3ioX8TKpshoQQDau3rU0Ycrr+Pw=;
 b=frhSJo4BKfOpapKD6i+2UFrbpHwRFfYb3s+YKEykG8RhbqByyu5qMJ1Rqwie9vpxKiz5DXw4yp6qIPGFe9MzVV7KJDaIi04aU3gjPZwo/ph5KHi6Pd/mtcVCzzZRb7A/MrxXJX0JU4MWbTogvKlnL5KrFRZPFatoC6T2pOhbdQ0=
Received: from MN2PR18MB2528.namprd18.prod.outlook.com (2603:10b6:208:a9::22)
 by MN2PR18MB2720.namprd18.prod.outlook.com (2603:10b6:208:3a::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.24; Fri, 26 Jun
 2020 10:15:52 +0000
Received: from MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::dcc:95db:afcb:9b1b]) by MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::dcc:95db:afcb:9b1b%7]) with mapi id 15.20.3131.025; Fri, 26 Jun 2020
 10:15:52 +0000
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     Igor Russkikh <irusskikh@marvell.com>,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "bjorn@helgaas.com" <bjorn@helgaas.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-kernel-mentees@lists.linuxfoundation.org" 
        <linux-kernel-mentees@lists.linuxfoundation.org>,
        "skhan@linuxfoundation.org" <skhan@linuxfoundation.org>
Subject: RE: [EXT] [PATCH v1] bnx2x: use generic power management
Thread-Topic: [EXT] [PATCH v1] bnx2x: use generic power management
Thread-Index: AQHWSlCOw9OMOszQmkCOhMRyUSrU5ajpi66AgAEkX1A=
Date:   Fri, 26 Jun 2020 10:15:52 +0000
Message-ID: <MN2PR18MB2528DB31A7C55B0D69E7FF0ED3930@MN2PR18MB2528.namprd18.prod.outlook.com>
References: <20200624175116.67911-1-vaibhavgupta40@gmail.com>
 <f685dfe2-9a50-15f5-f94f-c72433f84eb1@marvell.com>
In-Reply-To: <f685dfe2-9a50-15f5-f94f-c72433f84eb1@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2401:4900:3295:7c38:e12b:793f:c022:b379]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 156bc86e-cf52-4472-bab2-08d819b9e833
x-ms-traffictypediagnostic: MN2PR18MB2720:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB272002E3B316528BBB2322DED3930@MN2PR18MB2720.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0446F0FCE1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Oy3Me2VzZB2/Ws8taDyV4NPx7Xp7DrcQe0zO2wOgjPB3cO5kOdh7KYXptkdp1gypKbrLHXkx34mF65BEcrbUjVD7jU/ewli1ZJLRyJOFVHzNUFbFNXpI9ir6D+CtVr47z93VR82jFNjGO+gTekmuNd79IHlbDcOf7nUygCF5ZOpv85NoTYipRSnvhW9KTw/vrf80Up9ODy4TQNwDxGxypJJL2lYRkU3XJXKZZFVVJmim1Cu/uURE/wSl2OjocAX2vA5VxZtXWR05QO/vVmdaWL8rN//9G4GLmPSuqm0sJcHPQLSL6RRxIIuJbtl71GugkW+eJZ+3bhIBCMrDLpwYJs+1un9SxNcyQ9B8N97IxWAE4oD+Yyj7gd0+npu81Xt61Zx2crZp+CZHblDZobOuaQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR18MB2528.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(376002)(39860400002)(346002)(396003)(366004)(33656002)(478600001)(2906002)(7416002)(8936002)(110136005)(52536014)(55016002)(8676002)(54906003)(7696005)(9686003)(86362001)(76116006)(66476007)(64756008)(6506007)(6636002)(186003)(316002)(53546011)(83380400001)(66556008)(66446008)(66946007)(71200400001)(4326008)(5660300002)(41533002)(921003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: tcMuxY4lq8co+6QSZgOYdKUos2M33GHX9Hylz5P+PUZsBMx5tME54NGrYfltqBMPUb581/Q7rtNeUNUjyEdG4RqRPQWTbxgMevumt1ThNLFiGZXMLnv2zsA6VhwjjAppQnlrMkyZG7XoVRmCQNMzMwBnAqPEK8XkzpItlEx/bt5YwanAoztI5CD42OlLOi//nE3GRqnM1v6effUbKkRIF7usIBEHf4iGsEJw6A4AkoY6hFY7YIlANXgu2GIMnBPcJnE9FL4a0y8MzU0Ixkkkx6MyD1uUF1HAM3yznovhlKkAyy8bWYbE8c14PvyzVdBENyLg0tgarOwysdBD/4yfg/JFwlzBbHvmMSxlXCwXgbYF3FQEFPnVRzKlLhiC7z+ZzzIyW/4xUUo5edhJol+nVK5v3/FPFbcfOKUzULjH+A+kxC+CI21fD+TIQAY63G8oZ00lWugf/0YHLkAedVMDRdORHkleOgtpczfuPJnz/7XaPHmoddjNCrFliogFrr3UcC8fL0is2WCL7S4Ucp2ToMRgbJW1xdUdeEI0aVDxrGtfyZjRlbKgeAcObhfT9pui
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR18MB2528.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 156bc86e-cf52-4472-bab2-08d819b9e833
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2020 10:15:52.6914
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +vpxvSe6kJUftx8G9B97c759eaieCQUkm4IyCQPpkapWbPPT6JXvtRt3s0UUPnHvH+8Da3HWdt0CvsFOyKC58Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2720
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-26_05:2020-06-26,2020-06-26 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IElnb3IgUnVzc2tpa2ggPGly
dXNza2lraEBtYXJ2ZWxsLmNvbT4NCj4gU2VudDogVGh1cnNkYXksIEp1bmUgMjUsIDIwMjAgMTA6
MTYgUE0NCj4gVG86IFZhaWJoYXYgR3VwdGEgPHZhaWJoYXZndXB0YTQwQGdtYWlsLmNvbT47IEJq
b3JuIEhlbGdhYXMNCj4gPGhlbGdhYXNAa2VybmVsLm9yZz47IEJqb3JuIEhlbGdhYXMgPGJoZWxn
YWFzQGdvb2dsZS5jb20+Ow0KPiBiam9ybkBoZWxnYWFzLmNvbTsgVmFpYmhhdiBHdXB0YSA8dmFp
Ymhhdi52YXJvZGVrQGdtYWlsLmNvbT47IERhdmlkIFMuDQo+IE1pbGxlciA8ZGF2ZW1AZGF2ZW1s
b2Z0Lm5ldD47IEpha3ViIEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+OyBBcmllbCBFbGlvcg0K
PiA8YWVsaW9yQG1hcnZlbGwuY29tPjsgU3VkYXJzYW5hIFJlZGR5IEthbGx1cnUgPHNrYWxsdXJ1
QG1hcnZlbGwuY29tPjsgR1ItDQo+IGV2ZXJlc3QtbGludXgtbDIgPEdSLWV2ZXJlc3QtbGludXgt
bDJAbWFydmVsbC5jb20+DQo+IENjOiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJu
ZWxAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWwtDQo+IG1lbnRlZXNAbGlzdHMubGludXhm
b3VuZGF0aW9uLm9yZzsgc2toYW5AbGludXhmb3VuZGF0aW9uLm9yZw0KPiBTdWJqZWN0OiBSZTog
W0VYVF0gW1BBVENIIHYxXSBibngyeDogdXNlIGdlbmVyaWMgcG93ZXIgbWFuYWdlbWVudA0KPiAN
Cj4gDQo+IA0KPiBPbiAyNC8wNi8yMDIwIDg6NTEgcG0sIFZhaWJoYXYgR3VwdGEgd3JvdGU6DQo+
ID4gRXh0ZXJuYWwgRW1haWwNCj4gPg0KPiA+IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gPiBXaXRoIGxlZ2Fj
eSBQTSwgZHJpdmVycyB0aGVtc2VsdmVzIHdlcmUgcmVzcG9uc2libGUgZm9yIG1hbmFnaW5nIHRo
ZQ0KPiA+IGRldmljZSdzIHBvd2VyIHN0YXRlcyBhbmQgdGFrZXMgY2FyZSBvZiByZWdpc3RlciBz
dGF0ZXMuDQo+ID4NCj4gPiBBZnRlciB1cGdyYWRpbmcgdG8gdGhlIGdlbmVyaWMgc3RydWN0dXJl
LCBQQ0kgY29yZSB3aWxsIHRha2UgY2FyZSBvZg0KPiA+IHJlcXVpcmVkIHRhc2tzIGFuZCBkcml2
ZXJzIHNob3VsZCBkbyBvbmx5IGRldmljZS1zcGVjaWZpYyBvcGVyYXRpb25zLg0KPiA+DQo+ID4g
VGhlIGRyaXZlciB3YXMgYWxzbyBjYWxsaW5nIGJueDJ4X3NldF9wb3dlcl9zdGF0ZSgpIHRvIHNl
dCB0aGUgcG93ZXINCj4gPiBzdGF0ZSBvZiB0aGUgZGV2aWNlIGJ5IGNoYW5naW5nIHRoZSBkZXZp
Y2UncyByZWdpc3RlcnMnIHZhbHVlLiBJdCBpcw0KPiA+IG5vIG1vcmUgbmVlZGVkLg0KPiA+DQo+
ID4gQ29tcGlsZS10ZXN0ZWQgb25seS4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFZhaWJoYXYg
R3VwdGEgPHZhaWJoYXZndXB0YTQwQGdtYWlsLmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9u
ZXQvZXRoZXJuZXQvYnJvYWRjb20vYm54MngvYm54MnhfY21uLmMgIHwgMTUgKysrKysrLS0tLS0t
LS0tDQo+ID4gZHJpdmVycy9uZXQvZXRoZXJuZXQvYnJvYWRjb20vYm54MngvYm54MnhfY21uLmgg
IHwgIDQgKy0tLQ0KPiA+IGRyaXZlcnMvbmV0L2V0aGVybmV0L2Jyb2FkY29tL2JueDJ4L2JueDJ4
X21haW4uYyB8ICAzICstLQ0KPiA+ICAzIGZpbGVzIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKSwg
MTQgZGVsZXRpb25zKC0pDQo+IA0KPiBBY2tlZC1ieTogSWdvciBSdXNza2lraCA8aXJ1c3NraWto
QG1hcnZlbGwuY29tPg0KPiANCj4gU3VkYXJzYW5hLCBjb3VsZCB5b3UgcGxlYXNlIGdpdmUgaXQg
YSBzaG9ydCBzYW5pdHkgdGVzdCBhbmQgcmVwb3J0IGJhY2s/DQo+IA0KPiBUaGFua3MsDQo+ICAg
SWdvcg0KDQpJIGhhdmUgcnVuIHRoZSBiYXNpYyBzYW5pdHkgdGVzdCB3aXRoIHRoZXNlIGNoYW5n
ZXMgaW4gdGhlIGRyaXZlciwgZGlkbuKAmXQgc2VlIGFueSBpc3N1ZXMuDQoNClRoYW5rcywNClN1
ZGFyc2FuYQ0K
