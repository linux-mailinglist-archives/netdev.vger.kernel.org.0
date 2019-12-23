Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7C012957D
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 12:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727478AbfLWLhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 06:37:09 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:63798 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726791AbfLWLhI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 06:37:08 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBNBUIB3032559;
        Mon, 23 Dec 2019 03:36:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=umG6pZY64B5MYmOuvzhQTpX6kesataCEMSkVU+rzUtA=;
 b=YEUH0V9EKNWTsCZrpw0PdLTsgnpJ7AdhWJZBHF30O1VFELHM9bnYuMCkiJN8VCAkolIz
 riTviJ7/Fw1Y6tk7FnnGfGpX/GgSBwR73QQNP46Nfd4HSlPi5VH0chZWylXfsGDxs2w0
 M0TS8ObWk0wjzI8L6Fp0bEQGwTJifo33zAMi9aL2DougPVwmZ0K+fiiL+kxiIeB4JK3a
 9VYYKfNUX2s69JbTGeCdxwkjMQBFbn+lEwOyYfSl/XNXG1EVtI6e+d3SmnXRwX+3dAMw
 BTnFnG1b+2LQwt49q0vh9g6MVQzALndevF0eb+wJE20MAJyQOD3zV9dyL/+uw62w0u0P /w== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2x1hmv4vpy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 23 Dec 2019 03:36:51 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Dec
 2019 03:36:50 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 23 Dec 2019 03:36:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fjjedbSkouQXBjSfE8GBr9Ie8EnGTnFrDeNvWSTb0Y+urc+Wje/cJxPZDqmgiyzNZUU3w8hqI4hIhNwkOrtTP60ZNn8TYuNYJk39V74suz8SJw3c+GOe07vn7RjKo+TT3ToUjhofQSdJ/uF8W44Hqz9PeQXv3k8emCHPzzpT4tyCNMtlE+/DDKTpSeG0iZjN4nl3gOusIAjcEbJ8lFMwXpWS4PutuG5jxiGg7vm1N+z0NFw/vZ/R09YrvIrapGVJPkbj7gw4G5ijTuX1UmE1wWVXPFeFX5+PnX1v4h6UK8G6JR0cpOEG30bhKPIYAXq0cL3fbmhRAQ4bzjtkh31Ikw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=umG6pZY64B5MYmOuvzhQTpX6kesataCEMSkVU+rzUtA=;
 b=SketMkPSUrk1jKA+ZL+TL9DD8N1/QtQEVhxD+93fX8V0Ld/Xn2MWXclSctYO1DSBYGZd1epSCpjuhMQG72rI2yJdTquCNNWVT3G/E+yznl0H+tH6zWCRpi8FfDfdKszFIoLSb1rJWmvM9nX/i8KX90jAgUAJ0+ZpvtmfTgie28ucFTjZxh7UJRLuBz2Uy1cDzmEjJqU+qBv1shT2kY8k5Pr2lzojUYAiNFQIzhiJ0uzP/WqoH6bFRNlmvl+l6y4lAjAW6Q6m8I+EO5tsTGblcuHVKz/6wR9Av+eMdfephXfCTTE7Cw6w22AnSFLjzSCoMHcL0czvjpzSF6BNkFZb6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=umG6pZY64B5MYmOuvzhQTpX6kesataCEMSkVU+rzUtA=;
 b=TLkbtHqeuJ8aWC363qq+KYzKQQNoCxol1II1OA5bHvIC/lkbSgSSZJs+rPJQZD70IyF9tVfF6f83CFx1EHpQQc7I1xVJr6GyhXV+daPXl4TiPRAC3AdlH9n3lCIYZY4D2cqio3n5o3ry+h/rUwQOYPwbMuHdXSxqliv9oruanjQ=
Received: from MN2PR18MB2638.namprd18.prod.outlook.com (20.179.84.25) by
 MN2PR18MB3406.namprd18.prod.outlook.com (10.255.236.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Mon, 23 Dec 2019 11:36:48 +0000
Received: from MN2PR18MB2638.namprd18.prod.outlook.com
 ([fe80::54ca:9908:4108:f0a6]) by MN2PR18MB2638.namprd18.prod.outlook.com
 ([fe80::54ca:9908:4108:f0a6%6]) with mapi id 15.20.2559.017; Mon, 23 Dec 2019
 11:36:48 +0000
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
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "Dmitry Bogdanov" <dbogdanov@marvell.com>,
        Mark Starovoytov <mstarovoitov@marvell.com>
Subject: Re: [EXT] [PATCH net-next v4 15/15] net: macsec: add support for
 offloading to the MAC
Thread-Topic: [EXT] [PATCH net-next v4 15/15] net: macsec: add support for
 offloading to the MAC
Thread-Index: AQIsumBpaQv0fT17tb+gRgQd0efq8ALR+7c2Ad4MoeQ=
Date:   Mon, 23 Dec 2019 11:36:48 +0000
Message-ID: <MN2PR18MB26387BD6B59565D21F936FE5B72E0@MN2PR18MB2638.namprd18.prod.outlook.com>
References: <20191219105515.78400-1-antoine.tenart@bootlin.com>
 <20191219105515.78400-16-antoine.tenart@bootlin.com>
In-Reply-To: <20191219105515.78400-16-antoine.tenart@bootlin.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a06fc9cd-9506-4668-823d-08d7879c659b
x-ms-traffictypediagnostic: MN2PR18MB3406:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB340616D84A061E22356C3E55B72E0@MN2PR18MB3406.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-forefront-prvs: 0260457E99
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(346002)(376002)(396003)(39850400004)(199004)(189003)(9686003)(54906003)(110136005)(33656002)(316002)(71200400001)(8676002)(81166006)(81156014)(8936002)(7416002)(478600001)(4326008)(186003)(55016002)(107886003)(66556008)(64756008)(66446008)(2906002)(66476007)(6506007)(66946007)(4744005)(26005)(86362001)(52536014)(7696005)(76116006)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB3406;H:MN2PR18MB2638.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7RgH2P3+1SoPtJDeJSGfXAmyilpUquZq9c4laMvtLRxgXRl+IO1KGCN2gF9qWRtPVNl7gqFBnr6ZsekZsT6xPDrtU1Cmhh3DHkbKS7qac7jk2j4XXU9hWXYEKGLzKZdujsxFoXxbF2LfjCi2VXBCHC+3zDwMC2X+9QhFYF3Q1BaaqFn9kHcuc92lcdQVkjkcilVCmNHPjluBsGwC6Gd5emLQICa/XUCIv/x76Cp0ptLVB50kiMfRHC0J1Xb+LfTcRZiiZI81PoqBF5EGy7RUohSVSw3XnKOhbufA9cWXm4KZ823/V5/IYGxYV3+7sbEBw8Y2JaJSon2XLbzquF082RIAVnGM9YilNvW/QfKS23zhdOKyFdAl8mas34lWQWD2mPYe1I0Yhp33MNaim1XjdXB8spQWm2n3E9cnUTQNm3Ga0yp7/ihZSObIFRkdajef
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a06fc9cd-9506-4668-823d-08d7879c659b
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2019 11:36:48.5003
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q/Jaf9Euiwd63E5QJypKvpYMyvv9MOLh+4Xs/wAlTJTO+pOFdI0LhRcP5jBjiMxV+Q715xlfHd1mR04JAiLPww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3406
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-23_05:2019-12-23,2019-12-23 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL3VhcGkvbGludXgvaWZfbGluay5oIGIvaW5jbHVkZS91
YXBpL2xpbnV4L2lmX2xpbmsuaA0KPiBpbmRleCAwMjRhZjJkMWQwYWYuLjc3MTM3MWQ1Yjk5NiAx
MDA2NDQNCj4gLS0tIGEvaW5jbHVkZS91YXBpL2xpbnV4L2lmX2xpbmsuaA0KPiArKysgYi9pbmNs
dWRlL3VhcGkvbGludXgvaWZfbGluay5oDQo+IEBAIC00ODksNiArNDg5LDcgQEAgZW51bSBtYWNz
ZWNfdmFsaWRhdGlvbl90eXBlIHsNCj4gIGVudW0gbWFjc2VjX29mZmxvYWQgew0KPiAgCU1BQ1NF
Q19PRkZMT0FEX09GRiA9IDAsDQo+ICAJTUFDU0VDX09GRkxPQURfUEhZID0gMSwNCj4gKwlNQUNT
RUNfT0ZGTE9BRF9NQUMgPSAyLA0KPiAgCV9fTUFDU0VDX09GRkxPQURfRU5ELA0KPiAgCU1BQ1NF
Q19PRkZMT0FEX01BWCA9IF9fTUFDU0VDX09GRkxPQURfRU5EIC0gMSwNCg0KSGkgQW50b2luZSwN
Cg0KU28gZnJvbSB1YXBpIHBlcnNwZWN0aXZlIHVzZXIgaGF2ZSB0byBleHBsaWNpdGx5IHNwZWNp
ZnkgIm9mZmxvYWQgbWFjIg0Kb3IgIm9mZmxvYWQgcGh5Ij8gQW5kIGZyb20gbm9uIGV4cGVyaWVu
Y2VkIHVzZXIgcGVyc3BlY3RpdmUgaGUgYWx3YXlzDQpoYXZlIHRvIHRyeSB0aGVzZSB0d28gYmVm
b3JlIHJvbGxpbmcgYmFjayB0byAib2ZmbG9hZCBub25lIiA/DQoNCkknbSBub3Qgc2F5aW5nIHRo
aXMgaXMgd3JvbmcsIGp1c3QgdHJ5aW5nIHRvIHVuZGVyc3RhbmQgaWYgdGhlcmUgYW55DQptb3Jl
IHN0cmVhbWxpbmVkIHdheSB0byBkbyB0aGlzLi4NCg0KUmVnYXJkcywNCiAgSWdvcg0K
