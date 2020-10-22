Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F437296190
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 17:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2510015AbgJVPTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 11:19:39 -0400
Received: from mail-eopbgr770080.outbound.protection.outlook.com ([40.107.77.80]:23411
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2509951AbgJVPTi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Oct 2020 11:19:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R6e5LwCq0EdMwqHzEJvFCHAz3/eYyrztw8TLg3SHTNQMxoB2RoaH7Q1/5h1aWQnYeXvOZjfTOVl22CXshTKkcUpiCgilZLpqkhy5+6u/uBlfRo8Pv+2eKZezqxHT6c2yiTs9N3J4YvkXi2rHck+AqI/pzanyn4Za9fppDlyTNAvGFb1TyrwcW+AroYaH6UWYTN0I0qtnCOHDVgusPEGwwxD2R0zTvS9U8TnYwka2QslmiFsjHy0OYy8ae9/b+QM9ALIKzgYjZ7K+IrSq/QnQeLU64NrWncyDF3LR9M84v18UXK2gcm5GYo4sYOPUUHUcMV4HujyGiFshyiSWJyJq4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xC3AIwxBf+GQTtNPmYLDYTl0wOY3s7M2egRVjZxZZ4Q=;
 b=grPGP7pIcUfNExlm22vFvdIXsRRPwXXd/CQKFgniCkRABeHe1iX0ZZUV5LHgOB3Mfq3ayJLDjekXHGqyrmRGApgAL8jwoExa5RFwsN6cZ37EONXhe6RgMuFZY41gxZXh06mZZt9jtz9lYoY6nz2+2QBpYQrRB4yTFzU1Ag3O/UFCLinw+wUkAI7Kh9aRvManMLjX/jYHd2B1NyUAumAikygT7xb2/P/ndsAv1so55Jym+GnTSAGfwtcCLpuceEoONrqQha7qCQBFvNzXwg7SJlDONHsjrJmacNs9AUxwtbnU3LNM2ePX55Sr5IGeTmgsNaYO49h3NV/Vx8Wa4HUIPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xC3AIwxBf+GQTtNPmYLDYTl0wOY3s7M2egRVjZxZZ4Q=;
 b=E6VCpzC7z3JZegvWXrBQcaBkuT0CfckRc3Q3hpLe6HS8h0mlO7zepCDrHttqEmEFPri9Ffuou9BXeIxwtXioIacYcOYRNdvL2k+iO2Gfb1HHg82SFEpcxkDlftgI619ahSN33l3LZhaXiYuNEzc5gwavXeg3wtQ1jT5e7ggpO08=
Received: from CY4PR1001MB2389.namprd10.prod.outlook.com
 (2603:10b6:910:45::21) by CY4PR10MB1608.namprd10.prod.outlook.com
 (2603:10b6:910:9::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Thu, 22 Oct
 2020 15:19:36 +0000
Received: from CY4PR1001MB2389.namprd10.prod.outlook.com
 ([fe80::bd9d:bfc6:31c2:f5d8]) by CY4PR1001MB2389.namprd10.prod.outlook.com
 ([fe80::bd9d:bfc6:31c2:f5d8%6]) with mapi id 15.20.3477.028; Thu, 22 Oct 2020
 15:19:36 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: arping stuck with ENOBUFS in 4.19.150
Thread-Topic: arping stuck with ENOBUFS in 4.19.150
Thread-Index: AQHWqIbAhm/w52lyHEuPPxU5ZaHMxA==
Date:   Thu, 22 Oct 2020 15:19:36 +0000
Message-ID: <9bede0ef7e66729034988f2d01681ca88a5c52d6.camel@infinera.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.1 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=infinera.com;
x-originating-ip: [88.131.87.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3861c5b0-985d-47a5-50e9-08d8769de346
x-ms-traffictypediagnostic: CY4PR10MB1608:
x-microsoft-antispam-prvs: <CY4PR10MB16083E43FEA2176B6A7B8ADDF41D0@CY4PR10MB1608.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:561;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5lG4S0UrtiJ5m0iCXFQ5R8TEOheg6wG2yQSbaI3ZvZH3bcTQKYw4HqS7I0DMEs6VkrfUW9m17J2HiZw2jDtGMQFevfSPoi9YrEozEJuymbxXH1Gw10VTU7c3Tjem9A9IvOH8vZdsXjK55nSZNcgBO0ua0FQSMKSmdnOzgnWTrp3PS+RgSsuYmmoPiRQE+ak+jgzdVJVD76fppR9InVm8AufQvQ3+2ISc01VqfCwDeNabpeYipqSd4+PeK2mrGTuMtFuWT/MsrX+Kg/HIDAHvuflHjJvn5tbyGd4QFcxAo7YeOmicl4ZFCqp1+xcHgbxWOHS51a+ELrBE0M1/VDK9sQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2389.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(366004)(39860400002)(6506007)(8936002)(316002)(8676002)(186003)(26005)(478600001)(64756008)(66446008)(66946007)(6486002)(91956017)(5660300002)(76116006)(66476007)(66556008)(36756003)(4744005)(6512007)(6916009)(2616005)(2906002)(71200400001)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 2Wb0j9ytVHAHIXH1w5G7X8auVO9TQnOWuc2/g7tet+nZJL6Mze4lUVMAfehzB1FSTvTzrffmNNLZhCg5RF4B7zYomZ+Y2ku/0VcP8OOe7cDFt4NPZiuClz1mQooQxQyyTIkGPv4oYAtX84v+QCCFCAgN+mX5bImxVqyNJnEFmTHX1RS+020twSD4gO8s6tCLNMGKn2heoiybNKGc2y+RjvSwnnQeJE747sZRFSe6lOYpq6oKwQXfaWGvFwxIEgVklTHH+0hy8mQR2hXBGntXWirfIIUzjcUUQIip1GvtblA8sEXKqtXbYrIAeoaAp8AANd0nGRs2k/scQ3b/rWoFT3wRrD1VGN2YmvXSSBmpcMitrrIJOMmthpg0Ib+24SsjpxmpYP78fimhp2jN/erqcSV3ooJ9mo8xosvDcclev64HYgMWp/xCe1qAi/sdwp9sP/PG5qt4CoyIB9zdTA6Y+Evz0v/CiVakwxhAwhuLK7/rjr49xeTZcLBWQaZJ86jmko7eJc1xzQcNY03Mzys8fEWe8Fjky7mupv+icK3GfN4rvs/MRbBwuTc2bCBr/67E9t8w0bC+SGbD8SkmJbPRB9zt6+qxIS5UjkO0xgeBGlcAEeQVMwMyDwjDzVx86msl00aUi6oX6Pg33ge+6L8D9Q==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <39B6506B91A7364E9766A13A82C97FB5@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2389.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3861c5b0-985d-47a5-50e9-08d8769de346
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2020 15:19:36.6545
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dJqIGdG1Qx10dfxWjCsME/6QyfaWsPOMCB/gBnoEsTUkTuwHO+n/2EjU7AHMitvoTks94dmQKhvW+CAVvaBA8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1608
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

c3RyYWNlIGFycGluZyAtcSAtYyAxIC1iIC1VICAtSSBldGgxIDAuMC4wLjANCi4uLg0Kc2VuZHRv
KDMsICJcMFwxXDEwXDBcNlw0XDBcMVwwXDZcMjM0XHZcNiBcdlx2XHZcdlwzNzdcMzc3XDM3N1wz
NzdcMzc3XDM3N1wwXDBcMFwwIiwgMjgsIDAsIHtzYV9mYW1pbHk9QUZfUEFDS0VULCBwcm90bz0w
eDgwNiwgaWY0LCBwa3R0eXBlPVBBQ0tFVF9IT1NULCBhZGRyKDYpPXsxLCBmZmZmZmZmZmZmZmZ9
LA0KMjApID0gLTEgRU5PQlVGUyAoTm8gYnVmZmVyIHNwYWNlIGF2YWlsYWJsZSkNCi4uLi4NCmFu
ZCB0aGVuIGFycGluZyBsb29wcy4NCg0KaW4gNC4xOS4xMjcgaXQgd2FzOg0Kc2VuZHRvKDMsICJc
MFwxXDEwXDBcNlw0XDBcMVwwXDZcMjM0XDVcMjcxXDM2MlxuXDMyMlwyMTJFXDM3N1wzNzdcMzc3
XDM3N1wzNzdcMzc3XDBcMFwwXDAiLCAyOCwgMCwge+KAi3NhX2ZhbWlseT1BRl9QQUNLRVQsIHBy
b3RvPTB4ODA2LCBpZjQsIHBrdHR5cGU9UEFDS0VUX0hPU1QsIGFkZHIoNik9e+KAizEsDQpmZmZm
ZmZmZmZmZmZ94oCLLCAyMCkgPSAyOA0KDQpTZWVtcyBsaWtlIHNvbWV0aGluZyBoYXMgY2hhbmdl
ZCB0aGUgSVAgYmVoYXZpb3VyIGJldHdlZW4gbm93IGFuZCB0aGVuID8NCmV0aDEgaXMgVVAgYnV0
IG5vdCBSVU5OSU5HIGFuZCBoYXMgYW4gSVAgYWRkcmVzcy4NCg0KIEpvY2tlDQo=
