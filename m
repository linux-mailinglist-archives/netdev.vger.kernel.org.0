Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5E646E64
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 07:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbfFOFBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 01:01:01 -0400
Received: from mail-eopbgr710137.outbound.protection.outlook.com ([40.107.71.137]:62838
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725943AbfFOFBB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Jun 2019 01:01:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=SUWPY/RJZZnEYG2U5sqUGFozbGwdU50aKwl1a8XOoo5ZxqIhBIOvzdJ7UpKOmH0oJCh8zIkjdqI2Yu+lcFMyP7Momp0adKaTdrATDODxIxNIG6W5pMabABNocsTE5xD7p/hcoVas9a5JQupRVo6XJV24EImT9AcKJwTgZbiTVb0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OUsdzV/SEDlwM1lUFoaFZNEm19FDHQ7U8mOZDJzfNxk=;
 b=RXfzXAr+OsZHTIp22DaNg6RZa3uhBR3XRoJ6+OvrzJZeW/RwbWFWOzmzBICTG56yd1SHZP3lx4377YWoJi2cChlB5OjRzfMb9FvlDxXVgsPTQyrpwvNns7eC4884syORCe0f1u7zmgstfYhJX0h3Zty+h6jSdAQSQ+NFn0KxBYk=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OUsdzV/SEDlwM1lUFoaFZNEm19FDHQ7U8mOZDJzfNxk=;
 b=hEKsidmq6BlEpq0tWOTM22SOvV1rztDW7HwobGNX3p16yPc25hv/xj/HJS5PTlUFxZtG0rqoFn3YRBA2mmuZhLoLtMXU6mRop6ADsjHnDSxj5chemSj4vXhz1ghCapJmgdLn6R+ekyxLCnhBAFeOs9sifaU3blNR37g+iPTAglg=
Received: from SN6PR2101MB0942.namprd21.prod.outlook.com (2603:10b6:805:4::19)
 by SN6PR2101MB0975.namprd21.prod.outlook.com (2603:10b6:805:4::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2008.7; Sat, 15 Jun
 2019 05:00:57 +0000
Received: from SN6PR2101MB0942.namprd21.prod.outlook.com
 ([fe80::d8f0:bc1e:20d2:9bf6]) by SN6PR2101MB0942.namprd21.prod.outlook.com
 ([fe80::d8f0:bc1e:20d2:9bf6%3]) with mapi id 15.20.2008.002; Sat, 15 Jun 2019
 05:00:57 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Michael Kelley <mikelley@microsoft.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Sasha Levin <Alexander.Levin@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        vkuznets <vkuznets@redhat.com>,
        "marcelo.cerri@canonical.com" <marcelo.cerri@canonical.com>,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH net] hv_sock: Suppress bogus "may be used uninitialized"
 warnings
Thread-Topic: [PATCH net] hv_sock: Suppress bogus "may be used uninitialized"
 warnings
Thread-Index: AQHVIzdRyJ4h5bYUQkOiYCme+G2mpw==
Date:   Sat, 15 Jun 2019 05:00:57 +0000
Message-ID: <1560574826-99551-1-git-send-email-decui@microsoft.com>
Reply-To: Dexuan Cui <decui@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR05CA0053.namprd05.prod.outlook.com
 (2603:10b6:102:2::21) To SN6PR2101MB0942.namprd21.prod.outlook.com
 (2603:10b6:805:4::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 1.8.3.1
x-originating-ip: [13.77.154.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3a986c8c-a497-4d5f-7795-08d6f14e73a7
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:SN6PR2101MB0975;
x-ms-traffictypediagnostic: SN6PR2101MB0975:
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <SN6PR2101MB09757CA0B2040B4B154E333ABFE90@SN6PR2101MB0975.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0069246B74
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(136003)(376002)(396003)(39860400002)(199004)(189003)(50226002)(1511001)(71190400001)(71200400001)(102836004)(25786009)(107886003)(4326008)(8676002)(99286004)(22452003)(8936002)(66446008)(81166006)(73956011)(5660300002)(6116002)(64756008)(66946007)(36756003)(66476007)(52396003)(52116002)(66556008)(81156014)(2906002)(386003)(316002)(2501003)(3846002)(54906003)(6506007)(305945005)(66066001)(486006)(110136005)(86362001)(26005)(6512007)(6486002)(53936002)(186003)(10090500001)(3450700001)(6436002)(7736002)(4744005)(68736007)(10290500003)(14444005)(476003)(2616005)(43066004)(256004)(4720700003)(478600001)(6636002)(14454004);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR2101MB0975;H:SN6PR2101MB0942.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: JCb1ApIo0sXOd4NdYsgqbHlZWFFhByBKPfaniuML6jUq+VJC5aTw0U4RUKQcIqPhZ+dTfzRnKVKKYrae2RyrQpFMUr8hX3EfswrU5lvV4JyOuK4OXyWhIyEnBv3iLZXlG1TdqGTMzDcW7jLwRVSh7iqDzf5p21jCl7lwxVd1IXA6ob+qIX26hp8w0P4hZaA0zdqzxRkhPm3GFYZ7wzvxPaanKibnVjMFL6lTu9Wsg6ygTu9PG1VbXZRd06H5TEbqpZE+7R+n5TJtv7jeaZWMSkL4UN4RqrOaBxh6eD990jzsy7dDZ2iB5H9xriZcdIH2x8qnxmuUMpHdIG1YqNfH+aGSKaHkBjFa025H2yQAPZJiJuXtzIaOE20cjfJM6MK4I8pCPecVJOJT12xkPHWQ3GkgPEOrmreNBdXrP85sP+k=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2D67B7DBD8191F448FC3EAEB0514E697@namprd21.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a986c8c-a497-4d5f-7795-08d6f14e73a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2019 05:00:57.6278
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lkmldc@microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR2101MB0975
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Z2NjIDguMi4wIG1heSByZXBvcnQgdGhlc2UgYm9ndXMgd2FybmluZ3MgdW5kZXIgc29tZSBjb25k
aXRpb246DQoNCndhcm5pbmc6IOKAmHZuZXfigJkgbWF5IGJlIHVzZWQgdW5pbml0aWFsaXplZCBp
biB0aGlzIGZ1bmN0aW9uDQp3YXJuaW5nOiDigJhodnNfbmV34oCZIG1heSBiZSB1c2VkIHVuaW5p
dGlhbGl6ZWQgaW4gdGhpcyBmdW5jdGlvbg0KDQpBY3R1YWxseSwgdGhlIDIgcG9pbnRlcnMgYXJl
IG9ubHkgaW5pdGlhbGl6ZWQgYW5kIHVzZWQgaWYgdGhlIHZhcmlhYmxlDQoiY29ubl9mcm9tX2hv
c3QiIGlzIHRydWUuIFRoZSBjb2RlIGlzIG5vdCBidWdneSBoZXJlLg0KDQpTaWduZWQtb2ZmLWJ5
OiBEZXh1YW4gQ3VpIDxkZWN1aUBtaWNyb3NvZnQuY29tPg0KLS0tDQogbmV0L3Ztd192c29jay9o
eXBlcnZfdHJhbnNwb3J0LmMgfCA0ICsrLS0NCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25z
KCspLCAyIGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvbmV0L3Ztd192c29jay9oeXBlcnZf
dHJhbnNwb3J0LmMgYi9uZXQvdm13X3Zzb2NrL2h5cGVydl90cmFuc3BvcnQuYw0KaW5kZXggOGQx
ZWE5ZWRhOGEyLi5jZDNmNDdmNTRmYTcgMTAwNjQ0DQotLS0gYS9uZXQvdm13X3Zzb2NrL2h5cGVy
dl90cmFuc3BvcnQuYw0KKysrIGIvbmV0L3Ztd192c29jay9oeXBlcnZfdHJhbnNwb3J0LmMNCkBA
IC0zMjksOCArMzI5LDggQEAgc3RhdGljIHZvaWQgaHZzX29wZW5fY29ubmVjdGlvbihzdHJ1Y3Qg
dm1idXNfY2hhbm5lbCAqY2hhbikNCiANCiAJc3RydWN0IHNvY2thZGRyX3ZtIGFkZHI7DQogCXN0
cnVjdCBzb2NrICpzaywgKm5ldyA9IE5VTEw7DQotCXN0cnVjdCB2c29ja19zb2NrICp2bmV3Ow0K
LQlzdHJ1Y3QgaHZzb2NrICpodnMsICpodnNfbmV3Ow0KKwlzdHJ1Y3QgdnNvY2tfc29jayAqdm5l
dyA9IE5VTEw7DQorCXN0cnVjdCBodnNvY2sgKmh2cywgKmh2c19uZXcgPSBOVUxMOw0KIAlpbnQg
cmV0Ow0KIA0KIAlpZl90eXBlID0gJmNoYW4tPm9mZmVybXNnLm9mZmVyLmlmX3R5cGU7DQotLSAN
CjIuMTkuMQ0KDQo=
