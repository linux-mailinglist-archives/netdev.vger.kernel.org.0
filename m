Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 339351F1638
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 12:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729358AbgFHKDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 06:03:06 -0400
Received: from mail-eopbgr10087.outbound.protection.outlook.com ([40.107.1.87]:24290
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728745AbgFHKDF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 06:03:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BIm71B47vpElKbwKFMne7EbqLN+bmaym/q77fyVwKQv7ddtx1DnJo7N1ScjB71qKxIuZEk1VY9HDXqt5OWzSS2imUHeigRhEHXgr3NvZ8PonnU1cks/Jg/+VgKKkrs+yjmc2gDlk3Iyxqhnrp9G0236gWE18RLNevaoXvS3aRuJouTzXoGDX5FKtWOqE1ER7gxLEcL0eVonnkeHEX66ajV1+pL22pisRpgYX33CmKURoL+9mk9WMNLgeHFZfXEiRrN5OKYCmgbsjUc/35mzofo2qLA+Q1KXdbGe3taz/mp/AC0RcxCzg58q/tUlK+5u2pznWaoc+Pj3MSZ4RjbmxAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4GoCB+ypKVWcZb7UTMa6B0vn33ltD2sbQqjwqpyYMjk=;
 b=esWo4wIdArynKX30z/phaovnv1cJhd0AfNUREgsEBMVkRKka1Th66zATGSnmLBK7ymKWtLT5iuOoYGCk0rv1e4XZBGBg2iStTVQuVz/CmpA/FykM/qCJh6uERrjog1FcyGJLtxm7ZZkyv5KjB1F97JYupLxJjnrkIhQoNRxa2zNSIcTN773KOtFkuhMVcK9zBPdeU7ipJ8pqwTruh1PVqikBOeopR7BDque6bo93SC7Zyd2eGjDtngzMfuIiTCowGHJBlDQfwHew7c1O1CbTpXKudGDPJUwlyp290NkiTUyMVY1J4hYSMtzxg9x30BtKoCVq+kcSBwNtnFqCZFq/jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4GoCB+ypKVWcZb7UTMa6B0vn33ltD2sbQqjwqpyYMjk=;
 b=dgrpqN03Q0poQ5ekSJqf3NJEX5f8VUduVXUEbXIi+mMbIN0LX0uVaudDMS3AujGHKlnOjyPORg4Bfq7Nx0llPd+OeQ6t7RMS1Hn0hlWBhbzOK5CuzbKNwuzxh2ruIb9O8y+UiZEGHzpOfruQ8OM6MfceDKFGXEqw9Ak0vuTGQqc=
Received: from AM0PR0502MB3826.eurprd05.prod.outlook.com
 (2603:10a6:208:1b::25) by AM0PR0502MB4001.eurprd05.prod.outlook.com
 (2603:10a6:208:9::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.22; Mon, 8 Jun
 2020 10:03:01 +0000
Received: from AM0PR0502MB3826.eurprd05.prod.outlook.com
 ([fe80::2dae:c2a2:c26a:f5b]) by AM0PR0502MB3826.eurprd05.prod.outlook.com
 ([fe80::2dae:c2a2:c26a:f5b%7]) with mapi id 15.20.3066.023; Mon, 8 Jun 2020
 10:03:01 +0000
From:   Amit Cohen <amitc@mellanox.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>, Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "gustavo@embeddedor.com" <gustavo@embeddedor.com>,
        "cforno12@linux.vnet.ibm.com" <cforno12@linux.vnet.ibm.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "linux@rempel-privat.de" <linux@rempel-privat.de>,
        "alexandru.ardelean@analog.com" <alexandru.ardelean@analog.com>,
        Aya Levin <ayal@mellanox.com>,
        Petr Machata <petrm@mellanox.com>, mlxsw <mlxsw@mellanox.com>,
        "liuhangbin@gmail.com" <liuhangbin@gmail.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Subject: RE: [RFC PATCH net-next 04/10] ethtool: Add link extended state
Thread-Topic: [RFC PATCH net-next 04/10] ethtool: Add link extended state
Thread-Index: AQHWPNxasREQ3OFnpUutUmrz75Wb9qjNR3MAgAE2twA=
Date:   Mon, 8 Jun 2020 10:03:01 +0000
Message-ID: <AM0PR0502MB382610F0FEA6441B047A14ADD7850@AM0PR0502MB3826.eurprd05.prod.outlook.com>
References: <20200607145945.30559-1-amitc@mellanox.com>
 <20200607145945.30559-5-amitc@mellanox.com>
 <20200607153034.GC1022955@lunn.ch>
In-Reply-To: <20200607153034.GC1022955@lunn.ch>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [87.68.150.248]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 94fb49d9-901e-4380-3c5f-08d80b932145
x-ms-traffictypediagnostic: AM0PR0502MB4001:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR0502MB40018E6C5EE537F7D16DA2D7D7850@AM0PR0502MB4001.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 042857DBB5
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mKmZyw4zPpQePMVgOkKdT4DkvFMlYv5Dn+TnC2nyBHlAosvJ/xCisPtMC4H83UTOjA7N7I+14xMdOzvt/e7CouuCKe+OuexxvKa6cQ/UrvtKhtwsloI60gHjmcOxaQikLApcsfJqq9rujlXQz/rTDSKF42XIplSJncJ1YtI/YgZ9g3kzXzBbUnVlqFc2WzsCQLquqGN6N981DIHgx65d4m9Qjjwq3Pt+AtQWmhLFf/OvHcOX0iDIKcUNkhl50pjtGLESkfxdKk1vY7xWHuBsunVl1q3vJqtNTgVFRI8pSWw8WRSPLITEl/4YxFRaIklo+UlGg8FDqoxRajWWIGOftg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0502MB3826.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(366004)(376002)(346002)(396003)(8676002)(7696005)(26005)(83380400001)(7416002)(6506007)(9686003)(2906002)(33656002)(66556008)(54906003)(66446008)(64756008)(66476007)(186003)(55016002)(6916009)(76116006)(4326008)(5660300002)(4744005)(86362001)(478600001)(52536014)(71200400001)(8936002)(66946007)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: /5136gkAVIAlsfGav/oQ1GI+rJ1mAIWrXKnQPPycAOi/MU+cyf3GlpPAk5QsRn3VDy1Z2rg15GfcoTMMZmctiY8lW788h+Z/JqIo/DCAyWifdoiKZamVyE63cTPsgp7w3gOJ8bZIq3x1KtsecD0DO22PwmyCxOl0OmfEXy+Lx5uOwDn/GYZfxH9MuQIvFRP20uWeBrkv7qO7fGUQqxGEE0WBYZNBCG9A+F+mVzq4jE8Eb2WhJnFakVsoWiy85ycM9I6PBsfQAvd+g/Ma97pZ9x/Mr3U9vef7jrDx5VFjqCYXzwq6sHFxzzxeuV3+IdvfPmh64Y/Z+dpyqZ2/bvqqSMOxYwHbQLe11eWa7WP9u9i8juwWr+5BDN4IFiUw5Lheibp/A2O5UGX/WzkdakR5aGL1nT5gPMWbXCkX0n2rw605rTMeH6BBw8P/0fvfqFG3tnBwVJ2vrMz+B552+F0pGOlSR0CrdhKzAIMIL3y89Bb8syEcc/8lc8AtCc5uC8Sl
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94fb49d9-901e-4380-3c5f-08d80b932145
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2020 10:03:01.7379
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C5D4OTEnyJscdOjrl7fCM/HcSQbcwSoei+RiS6KtoXBe1ksrgBHgJgg9lqIVZdcn95CpKRvknSVqCe0Mz3xKpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB4001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew Lunn <andrew@lunn.ch> writes:

>> +/**
>> + * enum ethtool_ext_substate_cable_issue - more information in
>> + * addition to ETHTOOL_EXT_STATE_CABLE_ISSUE.
>> + */
>> +enum ethtool_ext_substate_cable_issue {
>> +	ETHTOOL_EXT_SUBSTATE_UNSUPPORTED_CABLE =3D 1,
>> +	ETHTOOL_EXT_SUBSTATE_SHORTED_CABLE,
>> +};
>
>I'm not too happy about shorted cable. I can see this getting extended to =
open cable, shorted to another pair, etc. It then becomes a duplicate of th=
e PHY cable testing infrastructure. A more generic
>
>> +	ETHTOOL_EXT_SUBSTATE_CABLE_TEST_FAILURE,
>
>would be better, and then the user can use then use the cable testing infr=
astructure to get the full details.
>

Ok, makes sense.

>	Andrew

