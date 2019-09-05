Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A876AAC18
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 21:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390811AbfIETh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 15:37:57 -0400
Received: from mail-eopbgr40081.outbound.protection.outlook.com ([40.107.4.81]:17824
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726626AbfIETh5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 15:37:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UFlP62oWxhllb/bIASTzlNHztRWF7LroF5M+S7M+gd63/apsmM3HjksAG9DVytsfjKygS9HTFkTMjS459zlDkSwiN7CglAoKwnASDz9bCL2+mZROyEHbp66RxFR2BEQdvEUO6HJU6AIBH8OTDqPog/s9qV233vjSC+6ransuyw06dHxQndBLRHK+4AwbAVgRnaaNB19JaeQ9f/mhilmviSUyUYm6px5IP8Fuodhf5zzZNPfZwN63Ee9K/r8iQq8Thzcuc+HGetxEAOW1EstsDdX4OnZgVGKyPG31kxnHhdu2Bb9XmGjw68Y8JXPYGKDjoDHz54StVfQfLo3CJpngjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qbYJiFqwhCsm3QJHjOrB3hO5E3DVf1d0kBPZJfVeo/o=;
 b=Sqh5uBKB6ZhbMccUisRI59nq3Q9YH7rVyu15OLQl1rbEQ2RTnDrQUwbqZa0KR3YOQ2gXyLamJIdC1QE+r/IAulXlK42axqNxkmR239tsVj2a5ZD/3OoEG57p/oXBEioDEFtACTftVcy+6O4g+/WtmRKxfD6dw15xscKSNEFU0IJlvVSxty8K4BDwSdlTbu42isahRrbxIGQki1keFsf4JvNFHSxyMNEkduL6CCBXexcCjJTl01MmozhYC/263vkT3medOCOeuD+CQCiyZJFgtuvtcKOTwIZNVVFegFd+LMnuRj+Ax443CvZxOIWA6UvylUfqDMHCijjFCR3RvRNP4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qbYJiFqwhCsm3QJHjOrB3hO5E3DVf1d0kBPZJfVeo/o=;
 b=D/2XolGnHane1ye5PU2dGyIg7HbzmWgOfkLnir1xSmhh7QTYzHokzWc2MENSZBYT/Ui8apKcMrkX+cOE5b6HEfVC/6E6Oc8XMhnqILGqLy7jfzgnDYxd0/ZwGkmErGYmpbPYdekPWFrWeV8qFoTpHJ7lByf2XjSLbCvSub9w4sY=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2528.eurprd05.prod.outlook.com (10.168.138.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.21; Thu, 5 Sep 2019 19:37:53 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9%5]) with mapi id 15.20.2220.022; Thu, 5 Sep 2019
 19:37:53 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Erez Shitrit <erezsh@mellanox.com>,
        "weiyongjun1@huawei.com" <weiyongjun1@huawei.com>,
        Mark Bloch <markb@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        Alex Vesker <valex@mellanox.com>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH net-next] net/mlx5: DR, Fix error return code in
 dr_domain_init_resources()
Thread-Topic: [PATCH net-next] net/mlx5: DR, Fix error return code in
 dr_domain_init_resources()
Thread-Index: AQHVY82oshc0j/9jWk+M6+lFVJzxvKcdezOA
Date:   Thu, 5 Sep 2019 19:37:53 +0000
Message-ID: <c89c55e6b443996a9cf83f160e2a6babd37437e9.camel@mellanox.com>
References: <20190905095600.127371-1-weiyongjun1@huawei.com>
In-Reply-To: <20190905095600.127371-1-weiyongjun1@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4135777d-9f17-4620-81bc-08d732388bac
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2528;
x-ms-traffictypediagnostic: VI1PR0501MB2528:|VI1PR0501MB2528:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0501MB252874E2C24B9FB07517F770BEBB0@VI1PR0501MB2528.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 015114592F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(376002)(136003)(396003)(39850400004)(199004)(189003)(102836004)(8936002)(2906002)(6246003)(5660300002)(53936002)(6506007)(86362001)(99286004)(76176011)(6486002)(316002)(229853002)(3846002)(14454004)(58126008)(2501003)(25786009)(54906003)(110136005)(6636002)(6116002)(4326008)(36756003)(478600001)(64756008)(4744005)(66446008)(7736002)(305945005)(71190400001)(486006)(476003)(71200400001)(2616005)(6436002)(91956017)(446003)(76116006)(66066001)(81166006)(11346002)(118296001)(66476007)(66556008)(186003)(66946007)(8676002)(6512007)(26005)(81156014)(256004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2528;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: OQZYdob1JKJ4kDTC7ducJzAFa2b1c74QeLSJXX54Rg53+5AbE3AF1O7Azjb/nTdMp8UmfHH4VAIiqPUg8dGfIGXSi/qQeZCrNFxcRJye8iaKzcVFx+wCTuZnbCF3zKlFYfiKAkWDorloLkoNfMyTtnrYhnxggHzcuzw/3bs4qYa+BcmqU67ASIpPZsDwCItQo94aYrJgHCZFP5Zo8yr7DQh/Se3MpZ/0aC9gr7IQ3dcSXggEInMCQmsu+ndgBbe1LXbogV0JI0qhRZSI7JQfppZZFSzldjVdJzUhZBX41T1ck9+YHGJBCIYNU0cbC2eImwZ+8vrm8BJQKpqNsouo3rJgGHz26mHCpM8OWy5iWfHtTudKGitfL8huazol8bsec+wW201XgRMSZo7Cs5azvPLx5bY8YWVbMSlKzgGziWM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9C29A2B9572C6E4EAF16BD59A9037024@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4135777d-9f17-4620-81bc-08d732388bac
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2019 19:37:53.7885
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oBI5AgUfDqXA9DwqY+48W3T2qot90Jw3UXql+i0jJ6etHzvfs0mLGjHC0f0ioIHoEdblmnrEIe68/mJYxj8G6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2528
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDE5LTA5LTA1IGF0IDA5OjU2ICswMDAwLCBXZWkgWW9uZ2p1biB3cm90ZToNCj4g
Rml4IHRvIHJldHVybiBuZWdhdGl2ZSBlcnJvciBjb2RlIC1FTk9NRU0gZnJvbSB0aGUgZXJyb3Ig
aGFuZGxpbmcNCj4gY2FzZSBpbnN0ZWFkIG9mIDAsIGFzIGRvbmUgZWxzZXdoZXJlIGluIHRoaXMg
ZnVuY3Rpb24uDQo+IA0KPiBGaXhlczogNGVjOWU3YjAyNjk3ICgibmV0L21seDU6IERSLCBFeHBv
c2Ugc3RlZXJpbmcgZG9tYWluDQo+IGZ1bmN0aW9uYWxpdHkiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBX
ZWkgWW9uZ2p1biA8d2VpeW9uZ2p1bjFAaHVhd2VpLmNvbT4NCj4gDQoNCkFwcGxpZWQgdG8gbmV0
LW5leHQtbWx4NS4NClRoYW5rcyAhDQoNCg==
