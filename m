Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3796B2A3B15
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 04:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbgKCDin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 22:38:43 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:57092 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725855AbgKCDin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 22:38:43 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A33PGVb019626;
        Mon, 2 Nov 2020 19:38:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0220; bh=SLBa7Ce/dW6FHgnxYc6s6pQh1hzXNZ9hN721v+iOzcE=;
 b=RbLBBLHv7kswSFvJ8TO0f1hvOeKt+bM3sUOr38O2JiymOfO9s84ZUTEggAC7inlJ3qCK
 kD0VnFo7CJkaQSg5eBTR1Veo0p+eTypoGeb+GpnUTUP1tpbKmWqlBaDHP+qmxUKJ0q7x
 wlyfYQF8CU/yGA2aIjeh2k8ojnbNoKv2udcHVwNMPfOqmbym3qubjMKPCYjUe0X2qpyg
 Vozf1TcBhp2kQ82z7rHdiOjMQP2T81Xi5Vw6Iae76yPo4BK3fWTvmfceRzyiApAP522d
 szTHg0vmsiAcpvtDXEZ7/xPhj1lgsoU+VxF/hH6e+i7IVo6aSAvnIhKry1wb08f/i2iC mg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 34h59mumvn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 02 Nov 2020 19:38:40 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 2 Nov
 2020 19:38:38 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 2 Nov 2020 19:38:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DgFpPNIZgqmBbhI08PqVRPFUhVcWU54z0BKLbq8h2TAYe0XmCRvv98uI4t3KoP3mfFa6STgHYc4ftvYyNd31ReLr7YIqvkyxhHtE4KuD5r/5STX93j+r2pkjPu5PX/qup1sOJAYSczkjZQwtTmTYv7hCx7t097lYyTogUD4rOJvNwNJ9hqWQN3/Nig7HL8ICloedsxyD/PaBEg9NyXnZAslipay0fK9pShQvBtlbRnorF/qGif5v7TWjSxu9pFbjx1x2q/+cU4vHcSKaYNNIH2s6368Za1y9OlMECLDdhLIMkjgVAm7EK0yBQ7CozVyijQS1Erf6M3Y49PfSfBj8HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SLBa7Ce/dW6FHgnxYc6s6pQh1hzXNZ9hN721v+iOzcE=;
 b=nuSVu4asLgulj+/TT3QbB0wg0A9XlvU/hHfQDKLSTNWypKWj314t3PAEyGaIMJLFTA7HlTXHCxkMjVpQRGgqS1sRNm7/os6KBCBq8c8ks2L+Bxp5UX0fsQ5sZk9/DtMWme2LAfbaVpSO6mXHOrJY9knC2/QShapJjBGjWaCRa+1q4Nv/XnyULAgFQZn8VZSeAQ+2MUrMHcFsAtXDeOJEY+I9hfSwPc9c3kft7E+ZWOVvw/sO0HRfICtz/j2giBIQMQiAHulKfplAUZMlIQLf+IS6/HDojETzKEGVbwSlXkSeq+zaMNmv2BNiylsM1jUl5r3wYV2G5yzNVafIX+ut3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SLBa7Ce/dW6FHgnxYc6s6pQh1hzXNZ9hN721v+iOzcE=;
 b=LANZxxwAojbuNIJOCo46DlayOWDVlo3phtqbhbDGn4QmiDYBtorNDLKyXBbewPxg5kAw8mdFnAxttnI7VKS4TZ8tBEMj6RZWejk6xKEqfje5Zy9ERiQ2UJWffcNWJodMQax40nPMipa7hRrLqR0C8qGG2xDohmGwHKIKGxzJzSU=
Received: from BYAPR18MB2679.namprd18.prod.outlook.com (2603:10b6:a03:13c::10)
 by BYAPR18MB2759.namprd18.prod.outlook.com (2603:10b6:a03:10b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Tue, 3 Nov
 2020 03:38:38 +0000
Received: from BYAPR18MB2679.namprd18.prod.outlook.com
 ([fe80::fcc9:71b3:472:ef7a]) by BYAPR18MB2679.namprd18.prod.outlook.com
 ([fe80::fcc9:71b3:472:ef7a%7]) with mapi id 15.20.3499.030; Tue, 3 Nov 2020
 03:38:38 +0000
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
Subject: Re: [net-next PATCH 1/3] octeontx2-af: Add devlink suppoort to af
 driver
Thread-Topic: [net-next PATCH 1/3] octeontx2-af: Add devlink suppoort to af
 driver
Thread-Index: AdaxkbPVLIjrZ/iRTyOL5tSXkpvLog==
Date:   Tue, 3 Nov 2020 03:38:37 +0000
Message-ID: <BYAPR18MB26790653D85A78A92250B44DC5110@BYAPR18MB2679.namprd18.prod.outlook.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [111.92.87.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 475d570e-e3d1-4e31-5e49-08d87fa9f34f
x-ms-traffictypediagnostic: BYAPR18MB2759:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB2759F90BD54ADABE03614D16C5110@BYAPR18MB2759.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LGEuj+uk4I3xuVyXEtBTVVTCRYv/B56iXEMx/lK+I2F2GtNf5q577vfC4VVgVFg9p3s/HfPz+vXDQ9oC1PIAuUOhySH74VmYWF4On0TWecT/xXsZ4FPArAUfTHNJANunwqRbabTnW7DhyCe0K7AoHTDD5FdoSdMieE897i0Jf23UBc9ZTEzW1RIbip4J4MrQxkFZAnoxBM0XqqVfhGWxeTCIj1X7/sPg2wr5otWocoESpLjTpLTnm3VVPSpjTX4yvG3smh0U7v31azTM+0uEJtjD1cJn2KgvFc9b+Mp1/igSnt7VZ0M0BF0VTVhjJdPtiQ6Z2uuzPLuxUVtM67ibQw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2679.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(136003)(396003)(39860400002)(26005)(33656002)(8676002)(53546011)(5660300002)(6916009)(66946007)(478600001)(7696005)(186003)(86362001)(76116006)(71200400001)(54906003)(316002)(2906002)(9686003)(66476007)(55016002)(64756008)(8936002)(78460400001)(66556008)(66446008)(83380400001)(52536014)(4326008)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Y1DYyiI11Boh34Qns8nDOaK9mKyp4o9SW3s7XSHWjt1/LdaL98wj7KMsdkxef+q50I6Co0o78i/hphg/4k59vqWp+zQSnS+j5T9kHg+O5Hzj8TXCLPXtoRePAjRm4gNcwfhbRerHRf0s1NwCk8t7VSu17Z6thyN9vo9jLJODpWxvvVkIS6AeDBTlnRjOm0IWFNoi1/PFO289nUxVb6kF9RHwI3I81fXX6yPg6b0Xjx59t00JJFIuw8dSxXhnLpCESIk8fBhAByQ4DOgqRjdwDwaL0YrttGKyUuSStDsIpqynqh3SMhtaNJiIigFMwPYpoSb3PfyUEL/2u7XDJ0USoqRi5avaAyoOEW3jMZKNBZs9/iSmJ0YSbOu28U1ijxrnUyOlzcIqumDbPSZ9G0DUoGYUrDIXuG2RcCaX8OxjZnR15Ll2Au9NxddA5QTajTSLArskXjdWJo+0tTaexUry+ScIFEInT1G+qIpo/WSfqSTH0l6Mn6NauztYZLGSDcSrEifiSXm1z1NfXOwGnHgKMxTA/JJKN1QzLxbsHhMWuWk2G4YDKtZendc7wHE3FWcZF3vSZPGvKLaxcPHjcutUIc8tWDBzUcXkt11ptpKRR3aGoFqrgOCR/UWFJKBFZ/d9jNxpP7ecPyiMr/0zGzI7tw==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2679.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 475d570e-e3d1-4e31-5e49-08d87fa9f34f
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2020 03:38:37.9901
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4q5MSWYXo0PcIMMvtSgWEwIT2swau4pbeWqPnTUeFEau9v20gIEWW+79Ppsyig89+CWB340l0ZiO501FmHVCJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2759
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-03_02:2020-11-02,2020-11-03 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgV2lsbGVtLA0KDQpUaGFua3MgZm9yIHRoZSByZXZpZXcuDQoNCj4gLS0tLS1PcmlnaW5hbCBN
ZXNzYWdlLS0tLS0NCj4gRnJvbTogV2lsbGVtIGRlIEJydWlqbiA8d2lsbGVtZGVicnVpam4ua2Vy
bmVsQGdtYWlsLmNvbT4NCj4gU2VudDogTW9uZGF5LCBOb3ZlbWJlciAyLCAyMDIwIDc6MDEgUE0N
Cj4gVG86IEdlb3JnZSBDaGVyaWFuIDxnY2hlcmlhbkBtYXJ2ZWxsLmNvbT4NCj4gQ2M6IE5ldHdv
cmsgRGV2ZWxvcG1lbnQgPG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc+OyBsaW51eC1rZXJuZWwgPGxp
bnV4LQ0KPiBrZXJuZWxAdmdlci5rZXJuZWwub3JnPjsgSmFrdWIgS2ljaW5za2kgPGt1YmFAa2Vy
bmVsLm9yZz47IERhdmlkIE1pbGxlcg0KPiA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IFN1bmlsIEtv
dnZ1cmkgR291dGhhbQ0KPiA8c2dvdXRoYW1AbWFydmVsbC5jb20+OyBMaW51IENoZXJpYW4gPGxj
aGVyaWFuQG1hcnZlbGwuY29tPjsNCj4gR2VldGhhc293amFueWEgQWt1bGEgPGdha3VsYUBtYXJ2
ZWxsLmNvbT47IG1hc2FoaXJveUBrZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbbmV0LW5leHQg
UEFUQ0ggMS8zXSBvY3Rlb250eDItYWY6IEFkZCBkZXZsaW5rIHN1cHBvb3J0DQo+IHRvIGFmIGRy
aXZlcg0KPiANCj4gT24gTW9uLCBOb3YgMiwgMjAyMCBhdCAxMjowNyBBTSBHZW9yZ2UgQ2hlcmlh
bg0KPiA8Z2VvcmdlLmNoZXJpYW5AbWFydmVsbC5jb20+IHdyb3RlOg0KPiA+DQo+ID4gQWRkIGRl
dmxpbmsgc3VwcG9ydCB0byBBRiBkcml2ZXIuIEJhc2ljIGRldmxpbmsgc3VwcG9ydCBpcyBhZGRl
ZC4NCj4gPiBDdXJyZW50bHkgaW5mb19nZXQgaXMgdGhlIG9ubHkgc3VwcG9ydGVkIGRldmxpbmsg
b3BzLg0KPiA+DQo+ID4gZGV2bGluayBvdXB0cHV0IGxvb2tzIGxpa2UgdGhpcw0KPiA+ICAjIGRl
dmxpbmsgZGV2DQo+ID4gIHBjaS8wMDAyOjAxOjAwLjANCj4gPiAgIyBkZXZsaW5rIGRldiBpbmZv
DQo+ID4gIHBjaS8wMDAyOjAxOjAwLjA6DQo+ID4gICBkcml2ZXIgb2N0ZW9udHgyLWFmDQo+ID4g
ICB2ZXJzaW9uczoNCj4gPiAgICAgICBmaXhlZDoNCj4gPiAgICAgICAgIG1ib3ggdmVyc2lvbjog
OQ0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogU3VuaWwgS292dnVyaSBHb3V0aGFtIDxzZ291dGhh
bUBtYXJ2ZWxsLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBKZXJpbiBKYWNvYiA8amVyaW5qQG1h
cnZlbGwuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEdlb3JnZSBDaGVyaWFuIDxnZW9yZ2UuY2hl
cmlhbkBtYXJ2ZWxsLmNvbT4NCj4gDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L21hcnZlbGwvb2N0ZW9udHgyL2FmL3J2dS5oDQo+ID4gYi9kcml2ZXJzL25ldC9ldGhlcm5l
dC9tYXJ2ZWxsL29jdGVvbnR4Mi9hZi9ydnUuaA0KPiA+IGluZGV4IDVhYzliYjEyNDE1Zi4uYzEx
MmIyOTk2MzVkIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21hcnZlbGwv
b2N0ZW9udHgyL2FmL3J2dS5oDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWFydmVs
bC9vY3Rlb250eDIvYWYvcnZ1LmgNCj4gPiBAQCAtMTIsNyArMTIsMTAgQEANCj4gPiAgI2RlZmlu
ZSBSVlVfSA0KPiA+DQo+ID4gICNpbmNsdWRlIDxsaW51eC9wY2kuaD4NCj4gPiArI2luY2x1ZGUg
PG5ldC9kZXZsaW5rLmg+DQo+ID4gKw0KPiA+ICAjaW5jbHVkZSAicnZ1X3N0cnVjdC5oIg0KPiA+
ICsjaW5jbHVkZSAicnZ1X2RldmxpbmsuaCINCj4gPiAgI2luY2x1ZGUgImNvbW1vbi5oIg0KPiA+
ICAjaW5jbHVkZSAibWJveC5oIg0KPiA+DQo+ID4gQEAgLTM3MiwxMCArMzc1LDEwIEBAIHN0cnVj
dCBydnUgew0KPiA+ICAgICAgICAgc3RydWN0IG5wY19rcHVfcHJvZmlsZV9hZGFwdGVyIGtwdTsN
Cj4gPg0KPiA+ICAgICAgICAgc3RydWN0IHB0cCAgICAgICAgICAgICAgKnB0cDsNCj4gPiAtDQo+
IA0KPiBhY2NpZGVudGFsbHkgcmVtb3ZlZCB0aGlzIGxpbmU/DQpZZXMuDQo+IA0KPiA+ICAjaWZk
ZWYgQ09ORklHX0RFQlVHX0ZTDQo+ID4gICAgICAgICBzdHJ1Y3QgcnZ1X2RlYnVnZnMgICAgICBy
dnVfZGJnOw0KPiA+ICAjZW5kaWYNCj4gPiArICAgICAgIHN0cnVjdCBydnVfZGV2bGluayAgICAg
ICpydnVfZGw7DQo+ID4gIH07DQo+IA0KPiANCj4gPiAraW50IHJ2dV9yZWdpc3Rlcl9kbChzdHJ1
Y3QgcnZ1ICpydnUpDQo+ID4gK3sNCj4gPiArICAgICAgIHN0cnVjdCBydnVfZGV2bGluayAqcnZ1
X2RsOw0KPiA+ICsgICAgICAgc3RydWN0IGRldmxpbmsgKmRsOw0KPiA+ICsgICAgICAgaW50IGVy
cjsNCj4gPiArDQo+ID4gKyAgICAgICBydnVfZGwgPSBremFsbG9jKHNpemVvZigqcnZ1X2RsKSwg
R0ZQX0tFUk5FTCk7DQo+ID4gKyAgICAgICBpZiAoIXJ2dV9kbCkNCj4gPiArICAgICAgICAgICAg
ICAgcmV0dXJuIC1FTk9NRU07DQo+ID4gKw0KPiA+ICsgICAgICAgZGwgPSBkZXZsaW5rX2FsbG9j
KCZydnVfZGV2bGlua19vcHMsIHNpemVvZihzdHJ1Y3QgcnZ1X2RldmxpbmspKTsNCj4gPiArICAg
ICAgIGlmICghZGwpIHsNCj4gPiArICAgICAgICAgICAgICAgZGV2X3dhcm4ocnZ1LT5kZXYsICJk
ZXZsaW5rX2FsbG9jIGZhaWxlZFxuIik7DQo+ID4gKyAgICAgICAgICAgICAgIHJldHVybiAtRU5P
TUVNOw0KPiANCj4gcnZ1X2RsIG5vdCBmcmVlZCBvbiBlcnJvci4NClRoYW5rcyBmb3IgcG9pbnRp
bmcgb3V0LCB3aWxsIGFkZHJlc3MgaW4gdjIuDQo+IA0KPiBUaGlzIGhhcHBlbnMgYSBjb3VwbGUg
b2YgdGltZXMgaW4gdGhlc2UgcGF0Y2hlcw0KV2lsbCBmaXggaXQuDQo+IA0KPiBJcyB0aGUgaW50
ZXJtZWRpYXRlIHN0cnVjdCBuZWVkZWQsIG9yIGNvdWxkIHlvdSBlbWJlZCB0aGUgZmllbGRzIGRp
cmVjdGx5IGludG8NCj4gcnZ1IGFuZCB1c2UgY29udGFpbmVyX29mIHRvIGdldCBmcm9tIGRldmxp
bmsgdG8gc3RydWN0IHJ2dT8gRXZlbiBpZiBuZWVkZWQsDQo+IHBlcmhhcHMgZWFzaWVyIHRvIGVt
YmVkIHRoZSBzdHJ1Y3QgaW50byBydnUgcmF0aGVyIHRoYW4gYSBwb2ludGVyLg0KQ3VycmVudGx5
IG9ubHkgMiBoYXJkd2FyZSBibG9ja3MgYXJlIHN1cHBvcnRlZCBOSVggYW5kIE5QQS4NCkVycm9y
IHJlcG9ydGluZyBmb3IgbW9yZSBIVyBibG9ja3Mgd2lsbCBiZSBhZGRlZCwgdGhhdOKAmXMgdGhl
IHJlYXNvbiBmb3IgdGhlIGludGVybWVkaWF0ZSBzdHJ1Y3QuDQo+IA0KPiA+ICsgICAgICAgfQ0K
PiA+ICsNCj4gPiArICAgICAgIGVyciA9IGRldmxpbmtfcmVnaXN0ZXIoZGwsIHJ2dS0+ZGV2KTsN
Cj4gPiArICAgICAgIGlmIChlcnIpIHsNCj4gPiArICAgICAgICAgICAgICAgZGV2X2VycihydnUt
PmRldiwgImRldmxpbmsgcmVnaXN0ZXIgZmFpbGVkIHdpdGggZXJyb3IgJWRcbiIsIGVycik7DQo+
ID4gKyAgICAgICAgICAgICAgIGRldmxpbmtfZnJlZShkbCk7DQo+ID4gKyAgICAgICAgICAgICAg
IHJldHVybiBlcnI7DQo+ID4gKyAgICAgICB9DQo+ID4gKw0KPiA+ICsgICAgICAgcnZ1X2RsLT5k
bCA9IGRsOw0KPiA+ICsgICAgICAgcnZ1X2RsLT5ydnUgPSBydnU7DQo+ID4gKyAgICAgICBydnUt
PnJ2dV9kbCA9IHJ2dV9kbDsNCj4gPiArICAgICAgIHJldHVybiAwOw0KPiA+ICt9DQo+ID4gKw0K
PiA+ICt2b2lkIHJ2dV91bnJlZ2lzdGVyX2RsKHN0cnVjdCBydnUgKnJ2dSkgew0KPiA+ICsgICAg
ICAgc3RydWN0IHJ2dV9kZXZsaW5rICpydnVfZGwgPSBydnUtPnJ2dV9kbDsNCj4gPiArICAgICAg
IHN0cnVjdCBkZXZsaW5rICpkbCA9IHJ2dV9kbC0+ZGw7DQo+ID4gKw0KPiA+ICsgICAgICAgaWYg
KCFkbCkNCj4gPiArICAgICAgICAgICAgICAgcmV0dXJuOw0KPiA+ICsNCj4gPiArICAgICAgIGRl
dmxpbmtfdW5yZWdpc3RlcihkbCk7DQo+ID4gKyAgICAgICBkZXZsaW5rX2ZyZWUoZGwpOw0KPiAN
Cj4gaGVyZSB0b28NClllcywgd2lsbCBmaXggaW4gdjIuDQoNClJlZ2FyZHMsDQotR2VvcmdlDQo=
