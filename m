Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 054141974E2
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 09:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729377AbgC3HJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 03:09:53 -0400
Received: from mail-eopbgr10067.outbound.protection.outlook.com ([40.107.1.67]:45394
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729089AbgC3HJx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 03:09:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m14SE8rvFgbcYDybvyt0OnD4p2ctgNP7CDy71gxw00vINfkW6E3Dr6yGQZMBIn20NrHUXge12iOJwdkV8VqSASvkKRYeOfVPQuBZFmu+lYRznEa/LUA+p/yvQbapQ1c0gWblQQ9oKEm27KFa+XhkNWuEdOuSsf6vBQ9HNrpOeW335AWAu71VBbgP0dnTWqCKWIR82VkzQT7U5QEIa/ZyvvT9JPXnXPXZZ7bfttBUS0rsjhj5gm1vLMWeqGmNAW1o07mh5mtCdkC8y2Bm2DIdqh8GCEcTFIZyNeq59YgUYfP+TGYWxhywpMeNQ0Sp3lLX9Xr+9dKhpxd1mAESn0j1Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NgihZUt7Vf5bwy6haf7cTY5R6tCY9mRe0VfBAWcRca4=;
 b=lmucNSVOm4RTXdHTb1pi3+bksJRK9Hq5Vdt47I20SlGtlGwOhP24ifJQabo+VFKQahLMM0qFfPAUGZcW7FYFHar4DKV7g4hvP2g65APUW6NR/wRXPFJ4HuekzSmDwDIneSjv3hBViFbggJIU3GehGkQIYIMt+IZyORETZZjGkAqgly6gh3jMe89k70ecKYa94AKZecZSBgsFN6ITBCFUH3Wbcj4Sf3Z110YFiE6wjCx3o7Vhe2LyDNVutffmCfy4of0kP0vvQKnUS6H8TIK0hZ3q2xUxwoJ2xfzUBMy1Vrpa8OC9Nw/iNzlWvZsihucvYhLtB8ZKtKiZOyAbj6N12g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NgihZUt7Vf5bwy6haf7cTY5R6tCY9mRe0VfBAWcRca4=;
 b=bns5Ef6BLqBiwA6QRdc0UvOx/hr+9Js1yB8Z1I0w9u7d//oRX3BqL6O/YS9my47eQXfUAxHEQkVfYDOkqGGYQ/GND4xEix8Jrcu9KgplMGef3+xraGot+/LukNyv8Njonc1KHP0sZuz/M77seltW47aHDbXnTV3VLC3EbiPhFSY=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6308.eurprd05.prod.outlook.com (20.179.32.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.20; Mon, 30 Mar 2020 07:09:48 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::8c4:e45b:ecdc:e02b]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::8c4:e45b:ecdc:e02b%7]) with mapi id 15.20.2856.019; Mon, 30 Mar 2020
 07:09:47 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "sridhar.samudrala@intel.com" <sridhar.samudrala@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     Aya Levin <ayal@mellanox.com>,
        "andrew.gospodarek@broadcom.com" <andrew.gospodarek@broadcom.com>,
        "sburla@marvell.com" <sburla@marvell.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        Tariq Toukan <tariqt@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        "lihong.yang@intel.com" <lihong.yang@intel.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "fmanlunas@marvell.com" <fmanlunas@marvell.com>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        Alex Vesker <valex@mellanox.com>,
        "snelson@pensando.io" <snelson@pensando.io>,
        "linyunsheng@huawei.com" <linyunsheng@huawei.com>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
        "dchickles@marvell.com" <dchickles@marvell.com>,
        "jacob.e.keller@intel.com" <jacob.e.keller@intel.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        "aelior@marvell.com" <aelior@marvell.com>,
        Yuval Avnery <yuvalav@mellanox.com>,
        "drivers@pensando.io" <drivers@pensando.io>,
        mlxsw <mlxsw@mellanox.com>,
        "GR-everest-linux-l2@marvell.com" <GR-everest-linux-l2@marvell.com>,
        Yevgeny Kliteynik <kliteyn@mellanox.com>,
        "vikas.gupta@broadcom.com" <vikas.gupta@broadcom.com>,
        Eran Ben Elisha <eranbe@mellanox.com>
Subject: Re: [RFC] current devlink extension plan for NICs
Thread-Topic: [RFC] current devlink extension plan for NICs
Thread-Index: AQHV/iRsiKU58im38Um7T8fyNtLerKhQ1DGAgABD54CAAOeuAIAAzAqAgAPIYYCABGpggIAAAUoAgABegoCAAL1QAIAAlFSAgAAkgwCAAAXeAIAACfuAgAPjvQA=
Date:   Mon, 30 Mar 2020 07:09:47 +0000
Message-ID: <e1398970-7fa7-36dc-4bf8-b901b2923049@mellanox.com>
References: <20200319192719.GD11304@nanopsycho.orion>
 <20200319203253.73cca739@kicinski-fedora-PC1C0HJN>
 <20200320073555.GE11304@nanopsycho.orion>
 <20200320142508.31ff70f3@kicinski-fedora-PC1C0HJN>
 <20200321093525.GJ11304@nanopsycho.orion>
 <20200323122123.2a3ff20f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200326144709.GW11304@nanopsycho.orion>
 <20200326145146.GX11304@nanopsycho.orion>
 <20200326133001.1b2694c9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200327074736.GJ11304@nanopsycho.orion>
 <20200327093829.76140a98@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <a02cf0e6-98ad-65c4-0363-8fb9d67d2c9c@intel.com>
 <20200327121010.3e987488@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <ea8a8434b1db2b692489edfd4abbc2274a77228c.camel@mellanox.com>
In-Reply-To: <ea8a8434b1db2b692489edfd4abbc2274a77228c.camel@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [122.172.60.127]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f8f9404b-6427-4f0d-558e-08d7d479550f
x-ms-traffictypediagnostic: AM0PR05MB6308:|AM0PR05MB6308:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB630865AB367A6A026F55F514D1CB0@AM0PR05MB6308.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-forefront-prvs: 0358535363
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(396003)(136003)(346002)(376002)(366004)(36756003)(71200400001)(8676002)(478600001)(6506007)(81156014)(81166006)(7416002)(86362001)(4744005)(6512007)(31696002)(107886003)(4326008)(53546011)(5660300002)(76116006)(64756008)(66556008)(66476007)(91956017)(66946007)(66446008)(110136005)(8936002)(186003)(54906003)(31686004)(26005)(2616005)(2906002)(316002)(6486002);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MoN8JDJyAs3GdYRE2btw5pWJUCxzfVYr93pd5zmbWyZnu+9PKyXQM0YUrC1PuQaVi+mRuAjalHLu7wEqdXLOmrl80Av5IyKgnpq/eE6D6yPfEfDHw93V9sK0Bw2hUoUUouI6WBS3YDutJWks2P8sN7FB6P+K4exUlXT18gWHkXQpOul1h0xQygdCxHEhy7zxWC3Fz1m4L1pqZr7+68DsSgEhEQLxCG4URMbZlTRJbE68eQ68QjUbDquDkpvesWxPcgC7aPx/fn2/zStU7grv+5R5AsW3oAaCKKwZg6WCBpej6MupWVxiun/jZAP9yvbw221Gzjjxky6GUKQ/csmw0ENLuFwjUVfloN6HbSg8D9rfZDPCKsm0BxRPifyea4r6ys/GZ4A7b5oiCPlV876U9bClG8iA5ac0H9DNGePjE9p4fa3JwAiLrwXu2Mw2KnqL
x-ms-exchange-antispam-messagedata: eDxGpDc1yr6ug6xGgePXZkmOYZHtLpd0U08VlYClViAV+RNMO4ym3b2Zh3ewzjPnoLv8DmY1aTHzxgG4n1+gBzU0uEGDrST7CNpo0hKDWOlzXrMlWMtbd+9ZtNh0ZfsPdzk85igCKDYhCjqMFQHhow==
Content-Type: text/plain; charset="utf-8"
Content-ID: <5868AFE4EFC6CF40A098E8E1EE144B5B@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8f9404b-6427-4f0d-558e-08d7d479550f
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2020 07:09:47.7155
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b0V+lm09Aij4T+eBDoS9aHe4vPCHyk6sCpuuxWLeqAgYGnKmnbm15ahWcQm4Db0FZcNmQrwR+S/767eUFd4Teg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6308
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMy8yOC8yMDIwIDE6MTUgQU0sIFNhZWVkIE1haGFtZWVkIHdyb3RlOg0KPiANCj4gV2UgbmVl
ZCBhIGNsZWFyLWN1dCBkZWZpbml0aW9uIG9mIHdoYXQgYSBTdWItZnVuY3Rpb24gc2xpY2UgaXMu
LiB0aGlzDQo+IFJGQyBkb2Vzbid0IHNlZW0gdG8gYWRkcmVzcyB0aGF0IGNsZWFybHkuDQo+IA0K
SmlyaSdzIFJGQyBjb250ZW50IHdhcyBhbHJlYWR5IGJpZyBzbyB3ZSBza2lwcGVkIGxvdCBvZiBT
RiBzbGljZQ0KcGx1bWJpbmcgZGV0YWlscy4NCkkgd2lsbCBzaG9ydGx5IHBvc3QgYW4gZXh0ZW5k
ZWQgY29udGVudCBpbiB0aGlzIGVtYWlsIHRocmVhZCB3aGljaCB0YWxrcw0KYWJvdXQgU0YsIHNs
aWNlIGFuZCBhbGwgb2YgaXRzIHBsdW1iaW5nIGRldGFpbHMuDQoNCj4+IEJ1dCB0aGUgc3ViLWZ1
bmN0aW9ucyBhcmUganVzdCBhIHN1YnNldCBvZiBzbGljZXMsIFBGIGFuZCBWRnMgYWxzbw0KPj4g
aGF2ZSBhIHNsaWNlIGFzc29jaWF0ZWQgd2l0aCB0aGVtLi4gQW5kIGFsbCB0aG9zZSB0aGluZ3Mg
aGF2ZSBhIHBvcnQsDQo+PiB0b28uDQpZZXMuDQo=
