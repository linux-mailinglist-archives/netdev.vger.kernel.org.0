Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99FAB12425E
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 10:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbfLRJEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 04:04:34 -0500
Received: from mail-eopbgr00043.outbound.protection.outlook.com ([40.107.0.43]:40727
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725828AbfLRJEe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 04:04:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A2iqn4sG+k5+2c4ChWwDfTlSmHiQymRS3m0T8uXPN+C7aKPciwxkbtkf2cDAyD+eOiaEV7Mok6ejeOfbCIZ7XbpG5Ukqk/jxTQeGenK7qIzgq2lh87V0tfxpqC696LpkieZ4lawQl8xdwVJHYBziRa+etodaHRMM+B2M8nf7Bru2VJYGT6BCjiKvzfrPVJyOf044bHl+qI2PNFKmI6pc18Q4FHfPYgljsDKAmagsGlsJcghS16XlsUx6TyLgPmX2ShyA8gzgscoYP4H1H1mea0xeJRHtGf8Mkw5KuT8opSj1XGp4Im/IP3uf+bdlkdkxZ8RT48y9VrFbNJE7m6JyUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zwf1D9ZgQmVhsbXnAGp6LtT6L9yREz4gRT5wNVW8WfI=;
 b=ZvFzXrHlFVdZmydoUur59vk+DOsQMLIgCmE8clksPp0sO9Is4y0Xb/n0d2ZldsE360Wtx2YfjvF9jyl+dMlkMeO3aUvEjf8Nulhpr2QpMuQ04Iv+qVDO7nYnQZw6qXz7509mlSPzsrXfjOO0Y2mYYGQlSJNh4qgdZKPTO5zUxEBjwXnqI+Zs5DmH3YRaT5F0LKfjbUPytnclmNOWCuvN0UEKPFdaN9UtOrfab+oBDlMYEoDsNpnQddx/SZHjq5c/oJrqv/JO5ip4L0x5/TWlEOF0dSvxrH9BVZb3bgjfGHbkTgtlBc+Z6EZtYm1A/pqmE35w274syjuDmbz2JSbiEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zwf1D9ZgQmVhsbXnAGp6LtT6L9yREz4gRT5wNVW8WfI=;
 b=mevpVL6h9y21DIfsi6C1ctc5jN05kWmdIBr+NL2Q3eibF0pgmopnIUWv2zukflefYJzaIb8E8011FTgGpExUrhJNcAoDuhkia4Taeoy6hb4KHpG4GbWM9VoyjzSziCF/K22xHe5D+Sx275gx2tiglcdyMPu2WBqpkj3TyhB9rEA=
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com (10.172.250.135) by
 DB6PR0502MB2934.eurprd05.prod.outlook.com (10.172.249.149) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.15; Wed, 18 Dec 2019 09:04:30 +0000
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::a153:bb4e:c909:d3a1]) by DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::a153:bb4e:c909:d3a1%7]) with mapi id 15.20.2538.019; Wed, 18 Dec 2019
 09:04:30 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "roopa@cumulusnetworks.com" <roopa@cumulusnetworks.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "mrv@mojatatu.com" <mrv@mojatatu.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>
Subject: Re: [PATCH net-next mlxsw v1 00/10] Add a new Qdisc, ETS
Thread-Topic: [PATCH net-next mlxsw v1 00/10] Add a new Qdisc, ETS
Thread-Index: AQHVtDJ6JPi/8Zm5P0q0pMB/3bwNRae/YlSAgAA5lAA=
Date:   Wed, 18 Dec 2019 09:04:30 +0000
Message-ID: <87immengwz.fsf@mellanox.com>
References: <cover.1576515562.git.petrm@mellanox.com>
 <20191217.213823.770260276225386300.davem@davemloft.net>
In-Reply-To: <20191217.213823.770260276225386300.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR04CA0025.eurprd04.prod.outlook.com
 (2603:10a6:208:122::38) To DB6PR0502MB3047.eurprd05.prod.outlook.com
 (2603:10a6:4:9f::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [213.220.234.169]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2983f90f-41ae-4727-d84c-08d783994ab1
x-ms-traffictypediagnostic: DB6PR0502MB2934:|DB6PR0502MB2934:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0502MB2934986D95C35924DA6093BEDB530@DB6PR0502MB2934.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0255DF69B9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(396003)(39860400002)(346002)(376002)(189003)(199004)(186003)(8936002)(2906002)(316002)(71200400001)(81156014)(81166006)(26005)(8676002)(6506007)(66446008)(64756008)(66556008)(4744005)(6512007)(66476007)(4326008)(66946007)(54906003)(478600001)(86362001)(2616005)(52116002)(6916009)(36756003)(6486002)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0502MB2934;H:DB6PR0502MB3047.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CO0axDAuxS0xTDEnB5TUuVkDwghP2/ACuddbaC6V03qU+OQHhtoZaxUprzAdgVjvHYppogwX3roAgZmrOKcsjq39jQbK7Gdz+7E1/3IJw2ivX4ODXPvedkqh6dgbwQFyXEfCFhWdVqP3T2nqbaB6SvCzVARBP3YLSUWR04zAYodX7f/wCvmBtUwQSx1aTU3VqLuH/4Kb5HSzxOwwSt4NL6qHt5MAdyhzIS3ghQYqHjAvTLWDyIFffWAZPxElJkTmqZXkuvZPNxlgWSiH08H+7aXniqBw4YKYaAHe4afzx9WKSs0/ROR05Qws46ko1ncvN0qaD+uSEvaMvAfcxIsOpx1jPfc1tp9HDTZIVK752X7V9hNwQ8I7NiMFYjYEJpWwM9rjh+BKE2ydpgIymF0/Lm75USw4Lip0JDJh0glC/713Y+nXBM9SR87aFMgbYIYG
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2983f90f-41ae-4727-d84c-08d783994ab1
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2019 09:04:30.5387
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PTWg1ssUyaEPtkEK/IK8cvy8nuHeXLYtTyilapRKYzZWntw15r3YBSQ7wA8mIF+hdnnGlHKmtGq+UGuztV4V8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0502MB2934
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


David Miller <davem@davemloft.net> writes:

> From: Petr Machata <petrm@mellanox.com>
> Date: Mon, 16 Dec 2019 17:01:36 +0000
>
>> The IEEE standard 802.1Qaz (and 802.1Q-2014) specifies four principal
>> transmission selection algorithms: strict priority, credit-based shaper,
>> ETS (bandwidth sharing), and vendor-specific. All these have their
>> corresponding knobs in DCB. But DCB does not have interfaces to configur=
e
>> RED and ECN, unlike Qdiscs.
>  ...
>
> I have no problem with this new schedule or how it is coded.
>
> But I really want there to be some documentation blurb in the Kconfig
> entry (less verbose) and in a code comment of the scheduler itself
> (more verbose) which explains where this is derived from.
>
> People can indeed look at the commit but I think if someone just sees
> the new Kconfig or looks at the code they should be able to read
> something there that says what this thing is.
>
> The commit log message for patch #4 would be good to use as a basis.
>
> Thank you.

OK, I'll spin a v2.
