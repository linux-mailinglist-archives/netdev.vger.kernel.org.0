Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4B0B8B30
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 08:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437327AbfITGkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 02:40:15 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:47442 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437279AbfITGkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 02:40:14 -0400
Received: from pps.filterd (m0167091.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8K6bxAS022209;
        Fri, 20 Sep 2019 02:39:25 -0400
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2050.outbound.protection.outlook.com [104.47.36.50])
        by mx0b-00128a01.pphosted.com with ESMTP id 2v3vb5v70b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Sep 2019 02:39:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dT0yYqKzh0CG/78E9g2TLzeJ4PagGVHy4x6HE5/C/4f6m74AGzeDno4FXHBrIlXCAmTYufFCcjWLHVMoqLrwxgsbrol44lxEla+DlyeeLrgfHuvvkhDZkNpNFrpWDzic7mVaKFBAD6h8oa5LdZMINv+lVC3Bl8OFk7uMnoDbd0kdptfAwqZNNr/87aCDOUwjpJZOBc5Jx2ApoMVMZBuIQfKcBiRyqu3711YFnd5msF1Aa7NCSCFOvk5dzGw+Z/olsOvOGflH6GQM3qZSRxKCtDCq3M+YbH3vXv1o6Yhyau97NEStGMHqwpAA6XBRfexSAC4+3MOia56KH+qCdC8RVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PQaftXl4d6EKPHFo0+ThOXmDYfT8cz0Erp6yesMIu7I=;
 b=KYkQBIt3XgbngpcRe427s2nMdV7//dWzjg/lhzv28s0y1sQngfli+tbvQXUj6qoqIhAUAZjISaDix45uOFp34WStKzykHdAQRttdMJE2fDT9shdJRQgrQrEAZkBlJjQrS0GvjrBQXazpwE2asum0HxqDiYfRXu12lP/hBbD0UFlf6vp4OFuSwFd/Ug04xcgn/WM6g+x2G5jXitpenTjgFstvcUah0xWvy6KlwkFYxVvm8eYm4CiSxvU28lyArrPmLX/b/z7glrz2FK0ZCQHH54dMENsyDXtt25rqNXZsuCtH1mNjvbT0XxZfYXyiX11lf4nDS05gRPyAUro6q3W7Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=analog.com; dmarc=pass action=none header.from=analog.com;
 dkim=pass header.d=analog.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PQaftXl4d6EKPHFo0+ThOXmDYfT8cz0Erp6yesMIu7I=;
 b=HxhrJZ15rZA9VCpdZm8MDeunR4E8bcmRV81d7X7amtXkVDz2kY7cie/0ukQxr22IBaimENYeFSai89P4OEV3egDwy1cs5S6ufiXnL02NpffUPKGFPcl0zu23QtQZoUJBo3tJBwXT/HxxCc25jcRhOJRVoBOlGX8TQvMml5i5n9Y=
Received: from CH2PR03MB5192.namprd03.prod.outlook.com (20.180.12.152) by
 CH2PR03MB5318.namprd03.prod.outlook.com (20.180.15.201) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.18; Fri, 20 Sep 2019 06:39:22 +0000
Received: from CH2PR03MB5192.namprd03.prod.outlook.com
 ([fe80::344d:7f50:49a3:db1b]) by CH2PR03MB5192.namprd03.prod.outlook.com
 ([fe80::344d:7f50:49a3:db1b%3]) with mapi id 15.20.2284.009; Fri, 20 Sep 2019
 06:39:22 +0000
From:   "Ardelean, Alexandru" <alexandru.Ardelean@analog.com>
To:     "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
Subject: Re: [PATCH 2/2][ethtool] ethtool: implement support for Energy Detect
 Power Down
Thread-Topic: [PATCH 2/2][ethtool] ethtool: implement support for Energy
 Detect Power Down
Thread-Index: AQHVbrkabB9cLWWF40mbNZ5JSD7OmqczB7mAgAFJYAA=
Date:   Fri, 20 Sep 2019 06:39:21 +0000
Message-ID: <79abfbff321f0d87c9c2e4df2b4c46a3f874c2ee.camel@analog.com>
References: <20190919100833.6208-1-alexandru.ardelean@analog.com>
         <20190919100833.6208-2-alexandru.ardelean@analog.com>
         <20190919140025.GC22556@lunn.ch>
In-Reply-To: <20190919140025.GC22556@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.71.226.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 75c241c6-4679-4915-06bb-08d73d95458f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:CH2PR03MB5318;
x-ms-traffictypediagnostic: CH2PR03MB5318:
x-microsoft-antispam-prvs: <CH2PR03MB5318470C2CAD888E51746F16F9880@CH2PR03MB5318.namprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0166B75B74
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(39860400002)(396003)(366004)(136003)(346002)(199004)(189003)(99286004)(2351001)(478600001)(6436002)(6486002)(6512007)(14454004)(5640700003)(36756003)(2906002)(86362001)(229853002)(3846002)(66066001)(11346002)(446003)(6116002)(6916009)(305945005)(7736002)(25786009)(6506007)(4326008)(71190400001)(2616005)(2501003)(186003)(26005)(102836004)(118296001)(81156014)(1730700003)(8676002)(486006)(6246003)(316002)(54906003)(256004)(81166006)(8936002)(71200400001)(5660300002)(66946007)(66556008)(66446008)(76116006)(64756008)(66476007)(76176011)(476003)(461764006);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR03MB5318;H:CH2PR03MB5192.namprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: analog.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: wiOTLwVba9yA/mRT+ZkY5F9NSWDJpmsdaYzQpaooqGSqlVoX455g5a4ol+P3vc/rtEjjDiqvxvkwcRZ3O8zZmsgsQ3UcNTDd6S+s5P5hD6zZ+in8gNsh5pPdeQ5qD3chG8nmGnwZI9g5uGjj+moi5Bz5U4CjAyWziAthCJUidJrSK1eR/zRmaEenj3T3JRw6a2xn+vBiJF8sL/3YgqgpebtQ0+qkXfDJq2bSig/3iRFkG9pcmpYom4tdbfFUPCniBhIKM3TqQWwvVI31iBIj8knA79fydCd8708BcWVsXhHmmUtoTaK2I5kIzeKlYCFqq/JP6cLI4H2P06uE+i/Tw3ae6b/nUfX4BcJ2JOtcBeEbYEv6NQWRR/hG1PTn96ZSJDSTVjk5BEoB+ybgPZMa2/sNddKMQ1T5r0EZhsRzqLI=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <2766EC6ACB2AB844ABCF105AD6705CA0@namprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75c241c6-4679-4915-06bb-08d73d95458f
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2019 06:39:21.9784
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MEA9/wZbM2AyloYVx6STRWHNvaojr9qU3GWuUdyZdL6kh7mVczNCjg22nxII5udHlOxvMl4Fs3IrmnGN+AG3G7oMUmUOouwz12VPsXrXqlE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR03MB5318
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-20_01:2019-09-19,2019-09-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 phishscore=0 clxscore=1015 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909200071
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDE5LTA5LTE5IGF0IDE2OjAwICswMjAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
W0V4dGVybmFsXQ0KPiANCj4gPiAtc3RhdGljIGludCBwYXJzZV9uYW1lZF91OChzdHJ1Y3QgY21k
X2NvbnRleHQgKmN0eCwgY29uc3QgY2hhciAqbmFtZSwNCj4gPiB1OCAqdmFsKQ0KPiA+ICtzdGF0
aWMgaW50IHBhcnNlX25hbWVkX3VpbnQoc3RydWN0IGNtZF9jb250ZXh0ICpjdHgsIGNvbnN0IGNo
YXIgKm5hbWUsDQo+ID4gKwkJCSAgICB2b2lkICp2YWwsIGVudW0gdHVuYWJsZV90eXBlX2lkIHR5
cGVfaWQpDQo+ID4gIHsNCj4gPiAgCWlmIChjdHgtPmFyZ2MgPCAyKQ0KPiA+ICAJCXJldHVybiAw
Ow0KPiA+IEBAIC01MDI2LDcgKzUwNTEsMTYgQEAgc3RhdGljIGludCBwYXJzZV9uYW1lZF91OChz
dHJ1Y3QgY21kX2NvbnRleHQNCj4gPiAqY3R4LCBjb25zdCBjaGFyICpuYW1lLCB1OCAqdmFsKQ0K
PiA+ICAJaWYgKHN0cmNtcCgqY3R4LT5hcmdwLCBuYW1lKSkNCj4gPiAgCQlyZXR1cm4gMDsNCj4g
PiAgDQo+ID4gLQkqdmFsID0gZ2V0X3VpbnRfcmFuZ2UoKihjdHgtPmFyZ3AgKyAxKSwgMCwgMHhm
Zik7DQo+ID4gKwlzd2l0Y2ggKHR5cGVfaWQpIHsNCj4gPiArCWNhc2UgRVRIVE9PTF9UVU5BQkxF
X1U4Og0KPiA+ICsJCSoodTggKil2YWwgPSBnZXRfdWludF9yYW5nZSgqKGN0eC0+YXJncCArIDEp
LCAwLCAweGZmKTsNCj4gPiArCQlicmVhazsNCj4gPiArCWNhc2UgRVRIVE9PTF9UVU5BQkxFX1Ux
NjoNCj4gPiArCQkqKHUxNiAqKXZhbCA9IGdldF91aW50X3JhbmdlKCooY3R4LT5hcmdwICsgMSks
IDAsIDB4ZmZmZik7DQo+IA0KPiBJIHBlcnNvbmFsbHkgZG9uJ3QgbGlrZSB0aGVzZSBjYXN0cy4g
Q291bGQgeW91IHJlZmFjdG9yIHRoaXMgY29kZSBpbg0KPiBzb21lIG90aGVyIHdheSB0byBhdm9p
ZCB0aGVtLiBNYWtlIHRoZSBwYXJzZV9uYW1lZF91OCgpDQo+IHBhcnNlX25hbWVkX3UxNigpIGEg
Yml0IGZhdHRlciwgYW5kIHRoZSBzaGFyZWQgY29kZSBhIGJpdCBzbGltbWVyPw0KPiANCg0KU3Vy
ZSB0aGluZy4NClYyIGNvbWluZyBzaG9ydGx5Lg0KDQo+IFRoYW5rcw0KPiAJQW5kcmV3DQo=
