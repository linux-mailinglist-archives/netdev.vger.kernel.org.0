Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3552A4D9E
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbgKCR5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:57:23 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:50272 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728759AbgKCR5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 12:57:22 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A3HtQpW016661;
        Tue, 3 Nov 2020 09:57:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0220; bh=jvuhLpn01eU38ztJbeRX65wLEBUWsNBnlB3tiSCG1lI=;
 b=EQynP7rIr8Mvv2/aA1NIifWzJXdGvxrhbG4tvWRn70ZjUJ1jYHbwvhCXv61NdDIn/y/l
 /rTUibOZYGaiDY2qpveEtA9t5UImDnS74TYI/yn1f/D8B67QxyShA5Hxhgi/SSKiwNBT
 YOjSgDrdWAraajYv2gqOjiayyQ88ZTTBUuh6leDnsvp2/1htRh2mInfk/Dp62Ws5EPDC
 8XPiqb3szJqBbnRWgzREkCoYRRRR61AdtJX3oDfa60wx1eAqRfEGerlNKUdbt4++Q9U7
 B1Un0fK1fC+8IGtw+SNrPfF1bdoQ+5IJtxsK6bO1N6j5obzSMjPgDTBHt5U5ky7rbCQZ lQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 34h59mxw50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 03 Nov 2020 09:57:19 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 3 Nov
 2020 09:57:18 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 3 Nov 2020 09:57:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lFlnpsAgdMTv3pQyI1BYEEHNya0mvgs6bFlEp3RI/HBZJYZZFm//EkJJeWILxODbz/PMjvNZCUmDTSfWBOfrRBMNaAfZMid7VDZf+JWs7RQs4zI72SGUtolBZpCo6//epdXu3vtpjt28G1dnhNHu5Uhz+yuAv9rRcwPLOyfzvzIVV+UnMYB3DVlOgQGgWEXffqUNLUiRCp20ME5MduO9vZYsBCehQZAd2iC4PPqQrqQ1LX9gfUZ6lIJq/VMQuOF1LBThKaB4BjF43ksqhFIi2vZKnav4O+7ABBFRFJaUkoO3wziKuXlH9WwfNEk31hOf3FbZghYkLBO9w3x/Wx3tAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jvuhLpn01eU38ztJbeRX65wLEBUWsNBnlB3tiSCG1lI=;
 b=TE5Xp+U6/i+IAorQCxEQdC1PDfqNs53DZjp/SEXMcBtVMkDoX5VBEkMoVW5kPgcNPWJf/sVYCjcOqTQNRPHqt0xXvIEnVbZJF5CkospTvCn3WTwkWhAbya7raDhcpCi1Rw1cTPaHqAIMwjngGhx+bUiP0RGLyj0+IL/yxAL57GYUwELYP6fzD6v76Ukiudt7hC1rvJSPodx5cBO4jtCS+AXuW4mArmgSpU0v/ETtyi0jC34oPAjp/AmKpgtBLkCs6v/HH1jZwuu6RzY+jftTDeOnFBV+tZ/bUroV7DfvJ9P7wetZrFN/3Wq06PdCk5VZgIYP2PjuOPwco+hpuHup2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jvuhLpn01eU38ztJbeRX65wLEBUWsNBnlB3tiSCG1lI=;
 b=lAmgYefOFB6mvfRUJwdcuQdTnq9g1KFybuRdyGqQOJuNT/oWKYmau+23vdWY2/mLRPioi5OcPxyAp9MB9oKMOy7DaDPdh61dRg7oj0kPvKdYkXyrPTndjXbKMoE+p7mnBM4G3E6mxNXCDUj8cRMXpOvVlL9nQ9m7mSVQdxVZUbk=
Received: from BYAPR18MB2679.namprd18.prod.outlook.com (2603:10b6:a03:13c::10)
 by BYAPR18MB2536.namprd18.prod.outlook.com (2603:10b6:a03:136::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.19; Tue, 3 Nov
 2020 17:57:15 +0000
Received: from BYAPR18MB2679.namprd18.prod.outlook.com
 ([fe80::fcc9:71b3:472:ef7a]) by BYAPR18MB2679.namprd18.prod.outlook.com
 ([fe80::fcc9:71b3:472:ef7a%7]) with mapi id 15.20.3499.032; Tue, 3 Nov 2020
 17:57:15 +0000
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
Thread-Index: AdayCqlS0gUuXfkEQA62mqDP7XCHXA==
Date:   Tue, 3 Nov 2020 17:57:15 +0000
Message-ID: <BYAPR18MB26798BE9AC64C0D402E69003C5110@BYAPR18MB2679.namprd18.prod.outlook.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [111.92.87.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9d17cbeb-ea00-484e-e6a3-08d88021e644
x-ms-traffictypediagnostic: BYAPR18MB2536:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB253650D90D909627765C6AD1C5110@BYAPR18MB2536.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uqSC422tO1mfHWGcsFyGYbeXunJu7zUT7K/rfses7e8QShnSaQo65VTpob8XkMzvEPlqwDP2eLYXmq+R230OHTSEgeDMSkGHSrOgFWLvFMf8exjfV+IJMoYrsPdTtJN4klJ0a5g6KT3IDetToj7bqe3E86csuX/vpBxJ59NAZ/wnCqrprzLt1gpcMbfZZ8eXW2a3I9LIzu69LJc6+U5sH0LvtDgdjOek6uqn2Rcq5aC5BiilqjRfgbACd4jSWZFvpiGuiST+/v016X/+98vlQQf709RFClA/QdlxRDmSmHP39HVO2UcyodVayfveqlUkX5wcSeyv/Ye6rHZl7ZEsoQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2679.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(396003)(366004)(39840400004)(8936002)(186003)(26005)(5660300002)(478600001)(8676002)(6916009)(52536014)(66946007)(6506007)(64756008)(66446008)(86362001)(53546011)(316002)(33656002)(83380400001)(76116006)(7696005)(66476007)(54906003)(4326008)(66556008)(55016002)(9686003)(2906002)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: K/ZUJ6PFq2sTn8PGVz369FvJgYySAw29m+z8wujI6/xJw2i2+/oKoFWiNuaZEZXeY/pC/cIiUz1Ue8bF52WS0vshDRZGdT19nBj/5Z4BDO72TWHM6MX+LC0wy59/6dY3gLx6zHF0qGDo8ZVDf750zgp/i691uV2BOvGNbqleOpBQd4NAoKLiWMuIsVHjGQRpjTsp3i95J+ULYIqQW1PPS8wtkrQnWkTAoAK7Xz3aIcmUL7un7n0yi1Zplz6GJbI35QUFSKYCCIa3QG2AT7mjlY+kEYsuYmcRTPFaYLj95h4ZXyLGvYyYc5GbOIvhgLpQfhgWIYXcNzmSN7Bb2BPQG1XT/107WrezOmklec3USLCzVWoJm8bGmH6ga2ZWBr09+SlniMyZVDDcTuUbWmB/putiwnpQ82nsrv/tC0N5ZEs3XbgPjMXJCV0jpjwhYKAUQ5BtJucVLlGchkZpoWdgFpOpiey8d0x3ZVhHTizvhLGHgnSNjItKvMQ4KYvRYqEnRZO179plS4aZFpEcv8KbnQjIfq4F/kI/YcZmmDMAE3t6R7a5w1fV8RICQZQdJ0IYRli4mC2R6tovrdn7uLkHycOQrPA/yNxWjH6j+4xDZlri0JXAs9GVQKHQtubQQnGcXDHCa18qhs8TimeM04VPDQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2679.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d17cbeb-ea00-484e-e6a3-08d88021e644
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2020 17:57:15.7457
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FMmAlelEyS9Vof3TCLOyWqIpGcoykiT/8PUfpArmKmFoXYdgdLrQxoeNvXoNPwNSwXqCOQqjZLR4rpbvyp6+rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2536
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
dHgyLWFmOiBBZGQgZGV2bGluayBoZWFsdGgNCj4gcmVwb3J0ZXJzIGZvciBOUEENCj4gDQo+ID4g
PiA+ICBzdGF0aWMgaW50IHJ2dV9kZXZsaW5rX2luZm9fZ2V0KHN0cnVjdCBkZXZsaW5rICpkZXZs
aW5rLCBzdHJ1Y3QNCj4gPiA+IGRldmxpbmtfaW5mb19yZXEgKnJlcSwNCj4gPiA+ID4gICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICBzdHJ1Y3QgbmV0bGlua19leHRfYWNrICpleHRhY2sp
ICB7IEBADQo+ID4gPiA+IC01Myw3ICs0ODMsOCBAQCBpbnQgcnZ1X3JlZ2lzdGVyX2RsKHN0cnVj
dCBydnUgKnJ2dSkNCj4gPiA+ID4gICAgICAgICBydnVfZGwtPmRsID0gZGw7DQo+ID4gPiA+ICAg
ICAgICAgcnZ1X2RsLT5ydnUgPSBydnU7DQo+ID4gPiA+ICAgICAgICAgcnZ1LT5ydnVfZGwgPSBy
dnVfZGw7DQo+ID4gPiA+IC0gICAgICAgcmV0dXJuIDA7DQo+ID4gPiA+ICsNCj4gPiA+ID4gKyAg
ICAgICByZXR1cm4gcnZ1X2hlYWx0aF9yZXBvcnRlcnNfY3JlYXRlKHJ2dSk7DQo+ID4gPg0KPiA+
ID4gd2hlbiB3b3VsZCB0aGlzIGJlIGNhbGxlZCB3aXRoIHJ2dS0+cnZ1X2RsID09IE5VTEw/DQo+
ID4NCj4gPiBEdXJpbmcgaW5pdGlhbGl6YXRpb24uDQo+IA0KPiBUaGlzIGlzIHRoZSBvbmx5IGNh
bGxlciwgYW5kIGl0IGlzIG9ubHkgcmVhY2hlZCBpZiBydnVfZGwgaXMgbm9uLXplcm8uDQoNClll
cyEhISBJIGdvdCBpdCwgd2lsbCBhZGRyZXNzIGl0IGluIHYyLg0KDQpSZWdhcmRzDQotR2Vvcmdl
DQo=
