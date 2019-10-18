Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53C21DC5A1
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 15:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410173AbfJRNBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 09:01:07 -0400
Received: from mail-eopbgr730048.outbound.protection.outlook.com ([40.107.73.48]:56288
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2410136AbfJRNBG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 09:01:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nbrmzLDSlOS5EiRDID5f654PGNovjBRTpTzg89or9Wntkc4DKAH6jz1RPwsQtBdUEtXhfciuN23Rnp9s0QPlW6OQgifSx15zdDl5M42HKNeySVvANCx53l+6SiPOc83/DGgoXVJV2tQH2bUw5kAO6n1/pmpkxvDhicdPI++v6fcf1XysaoEnDKHlo+pf1BSgV1J5YS/DsRbMusr2bbMh43JiI8g7Pf8ULGHdsVTrY/YhlZzYJi+djFFQskwvBmQjFKGPtTjayT/UpbSU7yomk0up/lUhmXI2b+DnhACnK2hbcurKCFFR4HU8/JkZz+1nV56g9eg7nE08AG1cd5wTeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QjDzHjU7jd3fX4mjgmy33/k9Z/RrS4Mwc6nUvZtGPcY=;
 b=MfvDpzJHQYz4xWzK7lEJKjITsEOhZHmhZMQX8vmo3Xo62MzcYaYcfZY5BjGePHpkhbZ4flnjM0rdyyuj6MkF//ecH2pTRqgVyr4pnxn3VpP+8lSETzwyPV9gsEV3Y+sNlc4ii0BJ/CA9GvMV7K946J0eCRg5Xe+yv7Wl5BqYZcu2plp5AgubkeFz4L2sZK1rYQlUiQR7T3Y10ngdtH8FJCmMt1LC6TrR8W/HGU4f3fku94ESFcvGic9vrxxGBgvOfx10CvLJS/RD7Z619dOrQQQFui2y2y6lTfjrQkr/QUCtfyGhL3Z4KeA5Gqje4zUTVCZ67kRaMD5hD6blY/wZmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QjDzHjU7jd3fX4mjgmy33/k9Z/RrS4Mwc6nUvZtGPcY=;
 b=XtX7rlSIFNyG+ifg/f0fmZn+pfNJPLskdToQQnwMR+T1uxcT7Oe6DrM+RJDOlcgtihiDb3UdZEV0fATh7J1Gf0iwuyKUrwH/mQOYlT+ACEBl2UCv1NuCNg2zTma75lhsToSTFDLEqaF75sNSqx/cRFBP5SYNWdkmwX85B9oGMs4=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3716.namprd11.prod.outlook.com (20.178.220.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.19; Fri, 18 Oct 2019 13:01:02 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f%3]) with mapi id 15.20.2347.024; Fri, 18 Oct 2019
 13:01:02 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     Chen Wandun <chenwandun@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] net: aquantia: add an error handling in
 aq_nic_set_multicast_list
Thread-Topic: [PATCH v2] net: aquantia: add an error handling in
 aq_nic_set_multicast_list
Thread-Index: AQHVhZzB3xc8p4AAK0GwsqOl7MTQo6dgXPCA
Date:   Fri, 18 Oct 2019 13:01:02 +0000
Message-ID: <89eede3b-2b8c-8d0b-3ffc-adf71f26e883@aquantia.com>
References: <1571394037-19978-1-git-send-email-chenwandun@huawei.com>
In-Reply-To: <1571394037-19978-1-git-send-email-chenwandun@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0020.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100::32)
 To BN8PR11MB3762.namprd11.prod.outlook.com (2603:10b6:408:8d::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8d6d164f-6e0f-4757-bc04-08d753cb3a8a
x-ms-traffictypediagnostic: BN8PR11MB3716:
x-microsoft-antispam-prvs: <BN8PR11MB3716E54A626C9C07CF902254986C0@BN8PR11MB3716.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 01949FE337
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(396003)(366004)(136003)(39850400004)(346002)(199004)(189003)(2906002)(14444005)(25786009)(4744005)(14454004)(256004)(2201001)(66066001)(5660300002)(508600001)(11346002)(36756003)(486006)(446003)(2616005)(476003)(44832011)(6246003)(186003)(6512007)(6436002)(6486002)(71190400001)(52116002)(81156014)(64756008)(229853002)(81166006)(2501003)(26005)(102836004)(99286004)(76176011)(6506007)(305945005)(386003)(31696002)(66556008)(66446008)(53546011)(66946007)(8936002)(7736002)(110136005)(66476007)(6116002)(86362001)(8676002)(3846002)(316002)(31686004)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3716;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RBbI6zpxoJrAvefQcO0ckuOYQdN/IGvwOZzUI2hvF6RFkyYM/I1ZbSxzzyo+P34kqgkLRxvRyKJM0Xj4KgL5QLTX0NOMgV4tN/d/THyYxXsrZzixdyc+iWzzju7v5O8A941FsiOwizdt8TAbUdcy3PV6s6eVjpoDSY1raKbFzpCK9F8r+RR9+oWAGrHnNAMURD47SHVmTvTPksPdv1de/dhl7qTYdgqMBFTgu0nfEnoe3M40gj+c0IlamyDN1GwJeBOkhR80+QPZsFHIxrvk43C7MNLPC4ePRu4Jcx+tML28xnFlQWXFL9lWohU+nFHNWX01PYcXZorBaMUgu7dRRuf3H8AhtXWDKUv0j9T8PK5hgKdKvv1dZ7sW7BJTWvCCktMP6kWk1dEpmu0f4np3DibWcpizpunw+DYW6KU7cAM=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <0FF8810558AEAC408D9BA93A96E7A013@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d6d164f-6e0f-4757-bc04-08d753cb3a8a
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2019 13:01:02.6908
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +O28YHBEkbpsPKEAfBnIM+Tur56Gw7YfA0yJy6Vhxap/Zd5WjRPtmwhEkO2l6lVw8tWERRF5J1qIXaJE/Ifl+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmtzLCBDaGVuLg0KDQpPbiAxOC4xMC4yMDE5IDEzOjIwLCBDaGVuIFdhbmR1biB3cm90ZToN
Cj4gRnJvbTogQ2hlbndhbmR1biA8Y2hlbndhbmR1bkBodWF3ZWkuY29tPg0KPiANCj4gYWRkIGFu
IGVycm9yIGhhbmRsaW5nIGluIGFxX25pY19zZXRfbXVsdGljYXN0X2xpc3QsIGl0IG1heSBub3QN
Cj4gd29yayB3aGVuIGh3X211bHRpY2FzdF9saXN0X3NldCBlcnJvcjsgYW5kIGF0IHRoZSBzYW1l
IHRpbWUNCj4gaXQgd2lsbCByZW1vdmUgZ2NjIFd1bnVzZWQtYnV0LXNldC12YXJpYWJsZSB3YXJu
aW5nLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQ2hlbndhbmR1biA8Y2hlbndhbmR1bkBodWF3ZWku
Y29tPg0KDQpSZXZpZXdlZC1ieTogSWdvciBSdXNza2lraCA8aWdvci5ydXNza2lraEBhcXVhbnRp
YS5jb20+DQoNClJlZ2FyZHMsDQogIElnb3INCg==
