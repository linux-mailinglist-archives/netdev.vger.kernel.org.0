Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0BBB12488D
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 14:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbfLRNk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 08:40:58 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:62482 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726749AbfLRNk6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 08:40:58 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBIDZFox004395;
        Wed, 18 Dec 2019 05:40:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=lz7wXeCaSuMx+4efNzilGpGg+dyyBxPqgYi+kf1r71I=;
 b=Vc7kMCOVOjLw76SvTZHxJgPem/pVyLkn7Wfo6AJ+3LWVAqTPyE8mn8qK8yp3ua1cL54M
 4TzPxjZ84aZ92ARywLxB2ig5cDp8bzVJsI93tUMlY0izMDIr267U2g1UQyRd8wN40Ui/
 x+R7A28GBPu/tmXN7Hl7xrMdPNVA7/8D7tz+AF2opk593ZB+Z/05ZH6wk6+tmB78atGI
 wNESp4i4vz5Q3VC9nxrVYWViXIoPbnlESXYI3TRIXCb6KqKihWcFNbmYISysM/JUSNC0
 t1YqjVRxjqtTWE5fMa1RLwD3gjUuRx+ZrW1MDUk230VnaOXCGaL9M1u8vXMpWvIw+rU/ Vg== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2wxneaxpm7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 18 Dec 2019 05:40:42 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 18 Dec
 2019 05:40:41 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 18 Dec 2019 05:40:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vv52L9+JeAeJhShmXgJkDvqWI5La+ocw4rGiUb4axgAoDA4sc6YPMxpuMAzRrTyfCGsI82zmo/UaMlos2oTrOpRFeWhqQfSjw5EvjzIiMm5pxSmeHpmpHAflkULqVzGfC+YSVBUQbTGbKyARm2ZpAnS4NKJB75IaKki70oFOYQgS03S3Ec1clPEAQZaN7x/HN8tXo78iX6TMdpcvhpWUGrViK7eFxA/SbxGjVkzOf2pqJVyUD+m06qotsRQPLDamNIILDS2xzbraMY007WGEMmN1XnKD0sAMT7wg4PmavQXg5Zkt3KoFy3Oo/RqNfFgvy/wvNtwwMp6nsGa8r2uYPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lz7wXeCaSuMx+4efNzilGpGg+dyyBxPqgYi+kf1r71I=;
 b=DDyM/8GS9mU/w5gnumwo5YacVj4lRp4vIjoXi9/phI4L7u24qoVguZdYWsgsDF7Nk/8LVIrF10brpMUVcQilNuGeYCcAoVqvOQJoKbBhYS5miRWNPZMU+vjgKIGfh3C9PQJMf5cMcmqNTJsijVX3OMNOWJkWvM9KeIDVr6wLON3qwnvhGasFFcQiBR4pu/6ez/TUvq9FPJeNPFau3WnIK+dEn2qCQ0qIOK/siJZgRZMkLbDYXV4m7KMmyuFuAlZd1K6LB++oC7/ZFLpA+RDmE9nu9PZ9sAHJSAz9efALZEu7C86KAun7tbQ8KoUCXttQ+7gUYNyiTUMsdOzrgvMCIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lz7wXeCaSuMx+4efNzilGpGg+dyyBxPqgYi+kf1r71I=;
 b=jLIN4egSnHtqpPbPjDapwfO04YrtMHeGB+B02NBQDtThZED7vwX250RQD0up4/yGqHq7iHViLhIgQmlO+TKbNGODAqxdN9RmS2b8GBCKmprTO2+pdlt0mJRAkUubzCRZ7ULi1hrcWPqkNljiZNynpFlkordBRAEI3/sO9KfWb34=
Received: from BYAPR18MB2630.namprd18.prod.outlook.com (20.179.92.161) by
 BYAPR18MB2565.namprd18.prod.outlook.com (20.179.92.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Wed, 18 Dec 2019 13:40:39 +0000
Received: from BYAPR18MB2630.namprd18.prod.outlook.com
 ([fe80::d5c3:4c58:1bf3:46fc]) by BYAPR18MB2630.namprd18.prod.outlook.com
 ([fe80::d5c3:4c58:1bf3:46fc%5]) with mapi id 15.20.2559.012; Wed, 18 Dec 2019
 13:40:39 +0000
From:   Igor Russkikh <irusskikh@marvell.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "camelia.groza@nxp.com" <camelia.groza@nxp.com>,
        "Simon.Edelhaus@aquantia.com" <Simon.Edelhaus@aquantia.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
Subject: Re: [EXT] [PATCH net-next v3 05/15] net: macsec: hardware offloading
 infrastructure
Thread-Topic: [EXT] [PATCH net-next v3 05/15] net: macsec: hardware offloading
 infrastructure
Thread-Index: AQG0FHNA1O9KaxSfL8ZHV6wV77yymQFvulN/AgkMaZM=
Date:   Wed, 18 Dec 2019 13:40:39 +0000
Message-ID: <BYAPR18MB2630684FD194F179E718E198B7530@BYAPR18MB2630.namprd18.prod.outlook.com>
References: <20191213154844.635389-1-antoine.tenart@bootlin.com>
 <20191213154844.635389-6-antoine.tenart@bootlin.com>
In-Reply-To: <20191213154844.635389-6-antoine.tenart@bootlin.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2d506415-43ba-4a1a-e934-08d783bfdebd
x-ms-traffictypediagnostic: BYAPR18MB2565:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB2565ED83AEC6C7331E068170B7530@BYAPR18MB2565.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0255DF69B9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(396003)(376002)(346002)(39860400002)(199004)(189003)(33656002)(110136005)(52536014)(81166006)(8676002)(81156014)(4326008)(9686003)(7696005)(71200400001)(54906003)(66476007)(4744005)(478600001)(316002)(76116006)(66556008)(66446008)(64756008)(5660300002)(66946007)(26005)(86362001)(2906002)(7416002)(186003)(55016002)(8936002)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR18MB2565;H:BYAPR18MB2630.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bjIoAMQJaHkeKfQzukcPP3S2wAMiRig55Y5xpK/hR+UheFgZRrfIT18CgFk5kB3bPR9Xa2LfhUlpDVopaURa+j0pnJkulzykVLxo/cMa/u+47jS20WAL52bKisnP9OKLBVF1/to9ntwP7ToF7LTjGEvowFF9zL0Nl55gpVkPTLy5ZdLqYnHFEDr4BsF0x+Nwuabb/E4szurgblXZEk/i3XNm2NrlkeIzxc7/ohl01V9eysXTmU0TmYSMm1e65COrxfySFn+e3u63Mc+TMQqgZmTmO7bE7mv049lVeIZTVxL4R+7vMJQwbsMoJiPgMQ0OAaki05rwTMxbI71iZKpqW6WJapFlZ+/XFeoXaiIxptvZuwxwc6AfNUTYy0QFMNmtU4n0t6TW5Hy7ZxPXPqSMWKOSSReIKbcoqov5ZD/6kHYltl/pxR1ByE63/XN124oS
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d506415-43ba-4a1a-e934-08d783bfdebd
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2019 13:40:39.4215
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C0U66tnp+jDX+/pBdngc5kDUtZ8oR0KQ+2b5U3RXyWNLqhpKeugdujE0eoLNB1tNoCWbYybyK9cHwCeBX1AGcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2565
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-18_03:2019-12-17,2019-12-18 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW50b2luZSwNCg0KPiBAQCAtMjkyMiw3ICszMzAwLDI3IEBAIHN0YXRpYyBpbnQgbWFjc2Vj
X2NoYW5nZWxpbmsoc3RydWN0IG5ldF9kZXZpY2UNCj4gKmRldiwgc3RydWN0IG5sYXR0ciAqdGJb
XSwNCj4gIAkgICAgZGF0YVtJRkxBX01BQ1NFQ19QT1JUXSkNCj4gIAkJcmV0dXJuIC1FSU5WQUw7
DQo+ICANCj4gLQlyZXR1cm4gbWFjc2VjX2NoYW5nZWxpbmtfY29tbW9uKGRldiwgZGF0YSk7DQo+
ICsJLyogSWYgaC93IG9mZmxvYWRpbmcgaXMgYXZhaWxhYmxlLCBwcm9wYWdhdGUgdG8gdGhlIGRl
dmljZSAqLw0KPiArCWlmIChtYWNzZWNfaXNfb2ZmbG9hZGVkKG1hY3NlYykpIHsNCj4gKwkJY29u
c3Qgc3RydWN0IG1hY3NlY19vcHMgKm9wczsNCj4gKwkJc3RydWN0IG1hY3NlY19jb250ZXh0IGN0
eDsNCj4gKwkJaW50IHJldDsNCj4gKw0KPiArCQlvcHMgPSBtYWNzZWNfZ2V0X29wcyhuZXRkZXZf
cHJpdihkZXYpLCAmY3R4KTsNCj4gKwkJaWYgKCFvcHMpDQo+ICsJCQlyZXR1cm4gLUVPUE5PVFNV
UFA7DQo+ICsNCj4gKwkJY3R4LnNlY3kgPSAmbWFjc2VjLT5zZWN5Ow0KPiArCQlyZXQgPSBtYWNz
ZWNfb2ZmbG9hZChvcHMtPm1kb191cGRfc2VjeSwgJmN0eCk7DQo+ICsJCWlmIChyZXQpDQo+ICsJ
CQlyZXR1cm4gcmV0Ow0KPiArCX0NCj4gKw0KPiArCXJldCA9IG1hY3NlY19jaGFuZ2VsaW5rX2Nv
bW1vbihkZXYsIGRhdGEpOw0KDQpJbiBvdXIgbWFjIGRyaXZlciB2ZXJpZmljYXRpb24gd2Ugc2Vl
IHRoYXQgcHJvcGFnYXRpbmcgdXBkX3NlY3kgdG8gZGV2aWNlIGJlZm9yZSBkb2luZw0KbWFjc2Vj
X2NoYW5nZWxpbmtfY29tbW9uIGlzIGFjdHVhbGx5IHVzZWxlc3MsIHNpbmNlIGluIHRoaXMgY2Fz
ZSB1bmRlcmx5aW5nIGRldmljZQ0KY2FuJ3QgZmV0Y2ggYW55IG9mIHRoZSB1cGRhdGVkIHBhcmFt
ZXRlcnMgZnJvbSB0aGUgbWFjc2VjIHN0cnVjdHVyZXMuDQoNCklzbid0IGl0IGxvZ2ljYWwgZmly
c3QgZG9pbmcgYG1hY3NlY19jaGFuZ2VsaW5rX2NvbW1vbmAgYW5kIHRoZW4gcHJvcGFnYXRlIHRo
ZSBldmVudD8NCg0KLS0gDQoNClJlZ2FyZHMsDQogIElnb3INCg==
