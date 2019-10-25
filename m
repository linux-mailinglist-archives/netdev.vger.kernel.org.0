Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60008E4F37
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 16:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392858AbfJYOfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 10:35:15 -0400
Received: from mail-eopbgr700048.outbound.protection.outlook.com ([40.107.70.48]:20864
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729132AbfJYOfP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 10:35:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jdpqvZeVU/x04oFvmsimDHeXY+3IkOsjKybh9+o+fQLS4VI3JKHHQwdZ/MZa8rzgJTOECGN+pTH4bqG/Pw7qaqbjv/0DbX0AFTZCCRA1ven5zIKpcMyhG5nnU/B/MK/7MtBAAHGKHN7auLKvfWU+o6R90SzFII3+D/CVYzu1MgqtCW+vKw/xtyduAFFV1xGkSlgPvXLdBxFOwYbw4hwzI9aTw8lnRFH8EJTbQAbFnFYVilZx37Qpwh+zLb992U3qNGc89BuEw5sbNYw5p/oXLib2oVUt8HSz975M+FmmB1I5X0GZHsKoOS6PG7X23wtqOH2acC8+rHzXuLM2sCk9OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YCqw1umRSodcBGACcLog5jXOxH0uDRUaxwOiwJYZlSk=;
 b=gPeT220HbbeMwVOrijp8PFq9cyyjwlUTC9XCpGLci4ocuMCaTXxVSE9YhfIK0QrcENOHYF5/TkIHBi4Z5GyWt1M6FNBcWjgt1nCMJnvh3APLshs0zBLg0+juaY7C/se2QkAXrSCqYLkZhdKNVSRskINff1LwtRoEwXrU6GkY1HmX7EUX0O1pGpYMYql1/RP0Jx/7W225r1UKlWQfQkTXdDVZTtqUZlmGXBOmV84KUxxBqA0Kn0oHG2EUGzigTSPqm//ifhLRHftMt0F6duS51fKEexax1OVLFp5XWHEQDTMda37WhG7Lm2hdwzqoVqPtMzXHA13ZXO3sVCRKYuNXOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YCqw1umRSodcBGACcLog5jXOxH0uDRUaxwOiwJYZlSk=;
 b=8IP1yzaa12aNNrQFtK5jjszgCbPPdccJ6xBt2K5JDGcmH76wyUKpoX2SCBY0jmRp4ncn2iQTGdUQT+7hgNzR4nYau+zv+guJxJBzwIr+m7zUZg6cEBKgIw+MK+dIJBAhA3JKoGFopOQdCG+uHrwiTKdCiw1eITD5bjVo5xQkzNg=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3555.namprd11.prod.outlook.com (20.178.218.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.22; Fri, 25 Oct 2019 14:35:11 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f%3]) with mapi id 15.20.2387.023; Fri, 25 Oct 2019
 14:35:11 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     David Miller <davem@davemloft.net>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Egor Pomozov <epomozov@marvell.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Simon Edelhaus <sedelhaus@marvell.com>
Subject: Re: [PATCH v3 net-next 00/12] net: aquantia: PTP support for AQC
 devices
Thread-Topic: [PATCH v3 net-next 00/12] net: aquantia: PTP support for AQC
 devices
Thread-Index: AQHViL6JpaiqbV9+r0Kgd1DtsoK9Uqdp2JiAgAAskwCAAWwfAA==
Date:   Fri, 25 Oct 2019 14:35:11 +0000
Message-ID: <4248b01d-10f2-35ea-5d30-bc33b12de739@aquantia.com>
References: <cover.1571737612.git.igor.russkikh@aquantia.com>
 <20191024141217.GC1435@localhost>
 <20191024.095150.1788364595890052897.davem@davemloft.net>
In-Reply-To: <20191024.095150.1788364595890052897.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: GVAP278CA0005.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:20::15) To BN8PR11MB3762.namprd11.prod.outlook.com
 (2603:10b6:408:8d::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3e500e22-cd9a-41f0-98a8-08d759588a6b
x-ms-traffictypediagnostic: BN8PR11MB3555:
x-ld-processed: 83e2e134-991c-4ede-8ced-34d47e38e6b1,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB355555D188A8B08DA10EF57098650@BN8PR11MB3555.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 02015246A9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(39850400004)(136003)(346002)(376002)(189003)(199004)(54906003)(2501003)(52116002)(2906002)(558084003)(99286004)(110136005)(86362001)(6512007)(229853002)(36756003)(3846002)(6486002)(66476007)(66946007)(6116002)(6436002)(66446008)(64756008)(66556008)(14454004)(305945005)(7736002)(25786009)(31686004)(5660300002)(6246003)(8936002)(4326008)(71200400001)(316002)(76176011)(102836004)(26005)(44832011)(6506007)(186003)(386003)(256004)(2616005)(486006)(446003)(11346002)(81156014)(81166006)(508600001)(8676002)(476003)(66066001)(71190400001)(31696002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3555;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Z0A1FzUFeVbXzpVKztOV1VN+8Efbk7j1p2u0T19DSnrQUd7lIS/lrxmArbTJmjFOhjGtroyebf2ogaVRdHZWskD2FwjjT+W99rXPFNOSVEROf0mfeF2/hfcq/8DXPiCAXJbZyoGfmj4IHBYWW6ER9OCAAqzGeYaW4yjw8wd/U6WXzDM0+nX65sUa8xQkJIn4auT0sPu7SEdCZ0rMs6OrdkTwDGvwbDZyXnhFUDRY/pguw6bXatBbFJ8xafa7IMIQp0SIWnDDlYHqSVUpUgQAnKUOHsc7EQDJcqeSlLnPXDL/lM7KJut/qp7eE1y+xCpccr56eDyOq4pE0Nnuyl090G3gjSP4v/NkF+ysH04HKDoLmDnwG/SZkczm/xZXIASSmfJeL7cvOyeGLl5bjXzfLYLAkXIy5pqQraIR6tiBvUeqehbS4JcUxDSRJl7DpbI8
Content-Type: text/plain; charset="utf-8"
Content-ID: <D25E79E007E0EC4F8A2DCFA6D49E3C06@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e500e22-cd9a-41f0-98a8-08d759588a6b
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2019 14:35:11.3054
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8GO700TXj2A3xAa7k630GLwd0aXDxz8pephdl4+zkAJvZjs+JJGqOe7L7jYwBHS5BbDCZWm1B8LF+lojmbOUHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3555
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+Pg0KPj4gRm9yIHRoZSBzZXJpZXM6DQo+Pg0KPj4gQWNrZWQtYnk6IFJpY2hhcmQgQ29jaHJh
biA8cmljaGFyZGNvY2hyYW5AZ21haWwuY29tPg0KPiANCj4gU2VyaWVzIGFwcGxpZWQuDQo+IA0K
PiBJZ29yLCBwbGVhc2UgYWRkcmVzcyB0aGUgaXNzdWVzIHJlcG9ydGVkIGJ5IHRoZSBrYnVpbGQg
cm9ib3QuDQoNCkhpIERhdmlkLCB3aWxsIGRvLg0KDQpSaWNoYXJkLCB0aGFua3MgZm9yIHlvdXIg
cmV2aWV3IQ0KDQpSZWdhcmRzLA0KICBJZ29yDQo=
