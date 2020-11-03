Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5AB2A4D51
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728524AbgKCRnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:43:09 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:54920 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727688AbgKCRnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 12:43:09 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A3HfRkv023846;
        Tue, 3 Nov 2020 09:43:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0220; bh=/zuCIAGOyq2XFGDITBvnc0xNy1g12Bd6fuKqMtPufLs=;
 b=iG+zyrsEYsNbrp/qhfCIRotIxFKSLnOZ60nSwjUgm++y6hlUrfK5IxzjqguigRBq5Elm
 xeZalEurdItmevD3oqgi+QzHaEj/06+a+3H1nx/h3b7bvBe0Ie/0dqq92AD2w7Qw5ezC
 rWbYMLJPRpCFgAkzyrMObYTvoDJ5ejjXnMKfEJfrma4uyhwStspPT7hY+ArbxsOj44ke
 fyy/dpcKrYcnfWAHDrP468Om7L6tKXvGso+2x7YokAp7KeNInvEMJSgkyC/Yr9QeJeTa
 J2Ss/5TWQS4fuNkHbZTurcdpbeRcH+E4vBNX7FTKqxpzx478m9pHe4lrSoG7N2CAzO0/ Dg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 34h59mxu4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 03 Nov 2020 09:43:06 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 3 Nov
 2020 09:43:05 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 3 Nov
 2020 09:43:04 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 3 Nov 2020 09:43:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nvs3RFQGy5yOIXsIJcNAUFmZ/p2Z9EKn0NNBUjf0dOlFZ3pfyGa5nUD7EvnXfaE3VjqQtZRgImo6MepBiAFLaSP85NN2GoMsnRQWne4PDc0qmnkswSqO0JzmGv1D5/BdBeHi/Np61d83WRWvoAub4I89FTKDR41DfG2P2qcPTk42EcaalrtVmyuiOMoF/SCbfUhxpFneEd6y6qJ0JMkKZpsraQUAAW9UuLJJfl6NndQRAUaRD/sX5C+zsCqBr074YOfqCCsDQq+NQHpY7xvbnPZg6wAM7UzjZxesNncyONtg5liisfu41uf3zY/C8vnk9K26yyV97lPXSZdswoZD8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/zuCIAGOyq2XFGDITBvnc0xNy1g12Bd6fuKqMtPufLs=;
 b=ClRc+2xiSQY8lOObo05I2OF5Wqij+zNNmeIw9Hzw9L6NSCjCxJlSz+87vpr/3obQseHdgU15x7UreDHyGsJzJAqzMNQzyEkVlyCql989rsKitooYQUQZrn7VmnSFA47AY2C5XHHhMPCajhqoZ/rZTVdIR7o48RAYrg4RDeiXhCBhOr56xjxdCGXHiE1Kp0AHZAdNuiXu+Shr+vsSCtquu6p4jNL9ATAARWKspxCLxPJi+hdxwE9jh6jW65JrpdUisGrEvJL+oE/5bN1RXWUhd7lQ0bp4uD+jjzUVlImpBe9RkcI8k/pFeg/R9JEJuao7Ev9ZWj8T6ALmT+5fs08rbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/zuCIAGOyq2XFGDITBvnc0xNy1g12Bd6fuKqMtPufLs=;
 b=X7QzV1uJlGX2pOI+KFLM0YHnBAkMzLZty4xtWh8m7bxKXxQ3eNUImU3OXgxiBpoOfgWJXlnleiGkyY1hz70kHQUZDs6b8lvRfFe9xux4wKgGne3BK4xx7HXhjKzvLa3GlHPWTrQ9fB3KPfrLmhvjqZ98MPNYzGH84WCrJHe1fz4=
Received: from BYAPR18MB2679.namprd18.prod.outlook.com (2603:10b6:a03:13c::10)
 by BYAPR18MB2613.namprd18.prod.outlook.com (2603:10b6:a03:135::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.29; Tue, 3 Nov
 2020 17:43:01 +0000
Received: from BYAPR18MB2679.namprd18.prod.outlook.com
 ([fe80::fcc9:71b3:472:ef7a]) by BYAPR18MB2679.namprd18.prod.outlook.com
 ([fe80::fcc9:71b3:472:ef7a%7]) with mapi id 15.20.3499.032; Tue, 3 Nov 2020
 17:43:01 +0000
From:   George Cherian <gcherian@marvell.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David Miller" <davem@davemloft.net>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>
Subject: Re: [net-next PATCH 2/3] octeontx2-af: Add devlink health reporters
 for NPA
Thread-Topic: [net-next PATCH 2/3] octeontx2-af: Add devlink health reporters
 for NPA
Thread-Index: AdayCIqYpOwgeWXyQzmyNTdUV5kwrg==
Date:   Tue, 3 Nov 2020 17:43:01 +0000
Message-ID: <BYAPR18MB2679A2F3A2CE18CFA2427EEDC5110@BYAPR18MB2679.namprd18.prod.outlook.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [111.92.87.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b56fb41e-71b4-4af3-6a83-08d8801fe93c
x-ms-traffictypediagnostic: BYAPR18MB2613:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB261300752A605CB59348CC37C5110@BYAPR18MB2613.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BGnc6vF0UgwU5I3YAW0W1o+41Ukkdy+kAAHnliv0tRPCAkbhIa4i42F0Qk1StyHPIyuKhvGbmScdvPaF8EE9oM/Yrvtcspz9G+lEmQoi/sGJOet+TpBaub0O6poU1DNyZLSIJiLfs3Xf+Y6EKf9As1pBGgGvuYOIqf+B6362VNVZkXCba7VN7Pq9hJN5imr8SGI1I5tKh9N5BJhIxlJZbt+C1CqPJiQJdZ/tO8qH4+bm25t5oqsynbgOTC1D1MIuK4H2IfTgVR41CNorPwS8Zvr+RU27bxXzSPbp5WglPhb4fgIhnQUXK7hvC7Gv2ydT
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2679.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(498600001)(6506007)(26005)(186003)(55016002)(53546011)(66446008)(66476007)(66946007)(76116006)(7696005)(4326008)(54906003)(66556008)(64756008)(52536014)(86362001)(8676002)(5660300002)(8936002)(71200400001)(33656002)(2906002)(6916009)(83380400001)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: gzBvoePXbsmjgnO9P57LnEHVtlvFK+XJpkvrs3bCPxPRm6CV1b78c9Tjp9cvOha/zLW8108UhuwAmWCHXPE4OtCdb0btmxdlEz3NMMs3TRw8QeuuFj2GjCjLXjjfH6Ga/7v6u83wydkhqu49kguqSxCudOWELfrcqEPuFab7qleFu4H9ErzhclZlB8p7qEOxBuRcax4Lttce77brLEADKdn8L2agmafrxSpFvcYN6kG8bV9oV1aXiVOXFjCV4dRu+Qio5B3eKBMws1IKMLYn3FVce/HozbNXyorDu2qIE6aIT2//+k4+MoAw4JXEVvebLiItRHuwGu86qa3S4S6YZi+wNqlWQGii3BY9mRXJCz7oi1Z7xcf3b08Klo7y4XCAqhWcLAlwN8vWnlhy6oycPptpTwXQj9TQGfp6dO6D7StvNGaFfZdlLPWYLJOnvdo5gPFdDEbiU/SBJQiwJNAgpGktOkfaNIGoQEFeN+L/PpPQDEfOGqoNKJ1IJgEqZYr0X8U+HAycEPImAE/hlYsq9CG5/srnWyqIcNbWsuHqfy59wpFeigef2D/yeOyYnvpS80DTZ71ZCyzNamvS51mGEjaP2fNp7lALF8GdlVTWU/UtWgbQW0klIJaDLVhzmF1diZ/2G4SkdsrPz7tNQLysQQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2679.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b56fb41e-71b4-4af3-6a83-08d8801fe93c
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2020 17:43:01.6928
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FMbKapEmSXZ6y9wIb+uJsYILVJYTZg1n9xsQlSqXvfw1cJThJZ1KmMeZlPfZMxlVaeF8lB17XnKSqRIqWuRv6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2613
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-03_08:2020-11-03,2020-11-03 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgV2lsbGVtLA0KDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogV2ls
bGVtIGRlIEJydWlqbiA8d2lsbGVtZGVicnVpam4ua2VybmVsQGdtYWlsLmNvbT4NCj4gU2VudDog
VHVlc2RheSwgTm92ZW1iZXIgMywgMjAyMCA3OjIxIFBNDQo+IFRvOiBHZW9yZ2UgQ2hlcmlhbiA8
Z2NoZXJpYW5AbWFydmVsbC5jb20+DQo+IENjOiBOZXR3b3JrIERldmVsb3BtZW50IDxuZXRkZXZA
dmdlci5rZXJuZWwub3JnPjsgbGludXgta2VybmVsIDxsaW51eC0NCj4ga2VybmVsQHZnZXIua2Vy
bmVsLm9yZz47IEpha3ViIEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+OyBEYXZpZCBNaWxsZXIN
Cj4gPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBTdW5pbCBLb3Z2dXJpIEdvdXRoYW0NCj4gPHNnb3V0
aGFtQG1hcnZlbGwuY29tPjsgTGludSBDaGVyaWFuIDxsY2hlcmlhbkBtYXJ2ZWxsLmNvbT47DQo+
IEdlZXRoYXNvd2phbnlhIEFrdWxhIDxnYWt1bGFAbWFydmVsbC5jb20+OyBtYXNhaGlyb3lAa2Vy
bmVsLm9yZw0KPiBTdWJqZWN0OiBbRVhUXSBSZTogW25ldC1uZXh0IFBBVENIIDIvM10gb2N0ZW9u
dHgyLWFmOiBBZGQgZGV2bGluayBoZWFsdGgNCj4gcmVwb3J0ZXJzIGZvciBOUEENCj4gDQo+IEV4
dGVybmFsIEVtYWlsDQo+IA0KPiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+ID4gPiA+ICBzdGF0aWMgaW50IHJ2
dV9kZXZsaW5rX2luZm9fZ2V0KHN0cnVjdCBkZXZsaW5rICpkZXZsaW5rLCBzdHJ1Y3QNCj4gPiA+
IGRldmxpbmtfaW5mb19yZXEgKnJlcSwNCj4gPiA+ID4gICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICBzdHJ1Y3QgbmV0bGlua19leHRfYWNrICpleHRhY2spICB7IEBADQo+ID4gPiA+IC01
Myw3ICs0ODMsOCBAQCBpbnQgcnZ1X3JlZ2lzdGVyX2RsKHN0cnVjdCBydnUgKnJ2dSkNCj4gPiA+
ID4gICAgICAgICBydnVfZGwtPmRsID0gZGw7DQo+ID4gPiA+ICAgICAgICAgcnZ1X2RsLT5ydnUg
PSBydnU7DQo+ID4gPiA+ICAgICAgICAgcnZ1LT5ydnVfZGwgPSBydnVfZGw7DQo+ID4gPiA+IC0g
ICAgICAgcmV0dXJuIDA7DQo+ID4gPiA+ICsNCj4gPiA+ID4gKyAgICAgICByZXR1cm4gcnZ1X2hl
YWx0aF9yZXBvcnRlcnNfY3JlYXRlKHJ2dSk7DQo+ID4gPg0KPiA+ID4gd2hlbiB3b3VsZCB0aGlz
IGJlIGNhbGxlZCB3aXRoIHJ2dS0+cnZ1X2RsID09IE5VTEw/DQo+ID4NCj4gPiBEdXJpbmcgaW5p
dGlhbGl6YXRpb24uDQo+IA0KPiBUaGlzIGlzIHRoZSBvbmx5IGNhbGxlciwgYW5kIGl0IGlzIG9u
bHkgcmVhY2hlZCBpZiBydnVfZGwgaXMgbm9uLXplcm8uDQoNCkRpZCB5b3UgbWVhbiB0byBhc2ss
IHdoZXJlIGlzIGl0IGRlLWluaXRpYWxpemVkPw0KSWYgc28sIGl0IHNob3VsZCBiZSBkb25lIGlu
IHJ2dV91bnJlZ2lzdGVyX2RsKCkgYWZ0ZXIgZnJlZWluZyBydnVfZGwuDQoNCklzIHRoYXQgd2hh
dCB5b3UgbWVhbnQ/DQoNClJlZ2FyZHMsDQotR2VvcmdlDQo=
