Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADBC9D75E
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 22:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733036AbfHZUSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 16:18:47 -0400
Received: from mail-eopbgr140082.outbound.protection.outlook.com ([40.107.14.82]:27874
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729144AbfHZUSq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 16:18:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XsAwmh43uCS27MQ18KLfIZ4coBcAuuwJP7SwlLK2JPEIOQAo6frZJNB+IYUS4Ldu6F0dTp4IzSGi7bMpDIeSsURgJB3QY8323RQHXr6xxYAkSIz+Gxd9awuyikuhhs5XMUidvzuJ9QJqBPB9o/8fzMxpuxNte8Z/T7UmJZs+NY+Xb3cYc7nFdQSI1YOOAsbzjJFMVCTUDRlPzoSo6gJsGVoxNElr9y3r4sl84F+/3E8mLkodG1h5FnHkdSdKvZZcE+i0aulNuHH+kXUka3G7dkdtZtY0jn9Y+Zt+b5OIDn8fFBBzoTgmZlrf1bDQ6rXwHHGNZpK6u5cBCNnXIplXPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=htM6yOe02qdDxP4e6/9WlBeq0RxH8gOR9o57K28N5xw=;
 b=jyBXKp++KWIe9zeLJDwktbgwdOl9pWaXPEOTndF6HkL6P3ucWwU1vtErQTawmmseOvegvHTi7cQYwQFTGeKV0OzAVb/ynOu4Pn+PZ2hkPcOeDtKK28T13GcR+iAgHytQRwh6aVO1ZevZfoUQSVFg4VQNx7+TV2A/1aVKLhZBVP0sgRRTdNAilwIPD1AYfEXTIJDQO9zG0X7MJDqbFJfJPewj4SChbJRU3lFuPyTzua1IzMXdDZfyYMfoRM03MHxoqhZaHgdOx8K962a842zc0bva87vj2mLUq48cYEBFp56io0PB//hI4bPFF4qCtDP2Oxw8/Nmj5ZTNDwvAZqAAUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=htM6yOe02qdDxP4e6/9WlBeq0RxH8gOR9o57K28N5xw=;
 b=ZDzBaEHMqdcSwfZliTRiN4rTw9Jck92KcX0MQp41jkzTOnxaNMRyMBdD44aEk9aAp1z/PQsyN2qFSpmUpHeUcCM1a1i0OhMluGBdt17c5jWV8CDM62SVvJVjdCJ99CBEE4o8QK9ySj6yKVw2thCMJGv4R8rpG2LU99z35cMx3b4=
Received: from HE1PR0501MB2763.eurprd05.prod.outlook.com (10.172.125.17) by
 HE1PR0501MB2425.eurprd05.prod.outlook.com (10.168.124.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Mon, 26 Aug 2019 20:18:41 +0000
Received: from HE1PR0501MB2763.eurprd05.prod.outlook.com
 ([fe80::a561:bcc6:10ab:d06a]) by HE1PR0501MB2763.eurprd05.prod.outlook.com
 ([fe80::a561:bcc6:10ab:d06a%10]) with mapi id 15.20.2178.023; Mon, 26 Aug
 2019 20:18:41 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "cai@lca.pw" <cai@lca.pw>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     Eran Ben Elisha <eranbe@mellanox.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Feras Daoud <ferasda@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>
Subject: Re: [PATCH] net/mlx5: fix a -Wstringop-truncation warning
Thread-Topic: [PATCH] net/mlx5: fix a -Wstringop-truncation warning
Thread-Index: AQHVWezn79S9mYXS9UOCwXmOlPmrCacJTW+AgASVnIA=
Date:   Mon, 26 Aug 2019 20:18:41 +0000
Message-ID: <9eb82b4de408d5f969c1df069d6b4c76a83e9ed7.camel@mellanox.com>
References: <1566590183-9898-1-git-send-email-cai@lca.pw>
         <20190823.151809.442664848668672070.davem@davemloft.net>
In-Reply-To: <20190823.151809.442664848668672070.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 84ea3c80-3204-465b-c8bb-08d72a629691
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:HE1PR0501MB2425;
x-ms-traffictypediagnostic: HE1PR0501MB2425:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HE1PR0501MB24252E8C06BC887F839FB5BCBEA10@HE1PR0501MB2425.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2582;
x-forefront-prvs: 01415BB535
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(39860400002)(136003)(366004)(376002)(199004)(189003)(229853002)(91956017)(76116006)(6116002)(305945005)(3846002)(2906002)(107886003)(66066001)(53936002)(7736002)(478600001)(6246003)(76176011)(256004)(446003)(11346002)(186003)(36756003)(486006)(2501003)(86362001)(476003)(2616005)(26005)(316002)(6486002)(118296001)(99286004)(558084003)(110136005)(58126008)(6506007)(102836004)(71190400001)(71200400001)(54906003)(4326008)(6436002)(81166006)(81156014)(64756008)(8936002)(66946007)(66476007)(66556008)(66446008)(6512007)(25786009)(8676002)(5660300002)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0501MB2425;H:HE1PR0501MB2763.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 14ALgps/fQKXDLF+Q3x397LOHhIosqD/OfEKwxzCNqgmYeWWaFcXYrzT8oYBlax22PNfBfixb3eNYp9qQ+FyGitMZ3RzhULr9VHvH2kRflV09AjOJE8rGZKvWnAozvVClE5nMMfMNuLgi5+f5VQ/MXdvRfuqTUIb+AyG3sHTds3WIStEpyd2TeNaMQhOBdxr3/MNgXFnpChQxIzg6tbwMjcTrPRZc2Pbyjqw37gaFjiDsYtnXgfK14z/KYmPOODkLb0L5W8ouVrKRS/+wpfxO/C3vDYWE/LzWk3w8xMnaUXBh2X1Z/K9IfUXPQXjnBHtq5IT/p+hz8ZCO2umOaRqkWNrMq+ZJjv4JeAaf75iGyvOeJZk4D59y0LEVJxD8/mDS3x3GyK6DFhEd1q/QLBlF1+XunKpMXcjDUR15YExGb0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9460794B6C09694DA4274ABE5DE23ACF@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84ea3c80-3204-465b-c8bb-08d72a629691
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2019 20:18:41.6373
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sVrrw5JTfOLS0/J0pouPgwYMTjVByRxEW0EL7nq4H5MzChdOZHj6qat/Pnvu72H3TbAo3NVV6EAXyUWicFCL0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0501MB2425
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDE5LTA4LTIzIGF0IDE1OjE4IC0wNzAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+
IFNhZWVkLCBJIGFzc3VtZSBJJ2xsIGdldCB0aGlzIGZyb20geW91Lg0KDQpZZXMsIGkgd2lsbCBo
YW5kbGUgaXQuDQo=
