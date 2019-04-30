Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20697F106
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 09:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbfD3HRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 03:17:06 -0400
Received: from mail-eopbgr60055.outbound.protection.outlook.com ([40.107.6.55]:59798
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725769AbfD3HRG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 03:17:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nd4MxhIrUwKiVwGpb1EgFnCjRra7TThNARyE3FXQDPQ=;
 b=TJO+3h3cq9u9hGglxx0dVaAnfivxCcvpPWS6SWd4Z6bHhhXlg/ThBRSd2lqwzHhM7OWL/309fEx/Vww+H6J1BhmdC95jQ8qTQQz+u9zpEgCMF4LLSZQU39TipEX6BTdZQYpuiJOk6UnTrfs5u7ykDAIHzkrk+derlcQ6RztUVRU=
Received: from AM0PR05MB6497.eurprd05.prod.outlook.com (20.179.34.15) by
 AM0PR05MB4660.eurprd05.prod.outlook.com (52.133.55.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.15; Tue, 30 Apr 2019 07:17:03 +0000
Received: from AM0PR05MB6497.eurprd05.prod.outlook.com
 ([fe80::151:4fc5:f798:6ef1]) by AM0PR05MB6497.eurprd05.prod.outlook.com
 ([fe80::151:4fc5:f798:6ef1%5]) with mapi id 15.20.1835.018; Tue, 30 Apr 2019
 07:17:03 +0000
From:   Ido Schimmel <idosch@mellanox.com>
To:     David Ahern <dsahern@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH v3 net-next 3/3] ipv4: Move exception bucket to nh_common
Thread-Topic: [PATCH v3 net-next 3/3] ipv4: Move exception bucket to nh_common
Thread-Index: AQHU/qa+k57bRtwvAEWHX2PSIO6EQqZUTBuA
Date:   Tue, 30 Apr 2019 07:17:03 +0000
Message-ID: <20190430071701.GB20525@splinter>
References: <20190429161619.23671-1-dsahern@kernel.org>
 <20190429161619.23671-4-dsahern@kernel.org>
In-Reply-To: <20190429161619.23671-4-dsahern@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM3PR07CA0065.eurprd07.prod.outlook.com
 (2603:10a6:207:4::23) To AM0PR05MB6497.eurprd05.prod.outlook.com
 (2603:10a6:208:13f::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=idosch@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c91c030f-6294-47d9-8bc5-08d6cd3bd848
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB4660;
x-ms-traffictypediagnostic: AM0PR05MB4660:
x-microsoft-antispam-prvs: <AM0PR05MB4660C55BC4D1B1CC2FE6030BBF3A0@AM0PR05MB4660.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 00235A1EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(346002)(136003)(366004)(376002)(396003)(39860400002)(199004)(189003)(316002)(52116002)(54906003)(3846002)(186003)(305945005)(8936002)(7736002)(6512007)(9686003)(68736007)(476003)(5660300002)(102836004)(33656002)(66066001)(256004)(26005)(86362001)(386003)(6506007)(76176011)(6116002)(446003)(97736004)(4744005)(6436002)(71200400001)(71190400001)(33716001)(11346002)(229853002)(66446008)(53936002)(99286004)(4326008)(25786009)(66476007)(73956011)(6916009)(66946007)(14454004)(81156014)(64756008)(81166006)(66556008)(2906002)(486006)(478600001)(6486002)(6246003)(1076003)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4660;H:AM0PR05MB6497.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2VUaBfB2dDGZMmhSvznbEIkyY/xapZpOlw9/AeHaA3adlljaxjp19uK+NtDtBfv9fj79cWWaWSO+2883MiuYG58yPokBI0Ie6xEPx+NEWnSqMmoBHjmWtUVjQYLUgDJkr695baVsMoUbBOoCZiK4dyNeWzHkY37ml+sFoinODuBumI3u0ytRxCE+qBSa0pnp2275gxpfsBxrJi9tQ7khmY4ZGHO930gj8qP5FVWWtM49A4olR0G5tdJdac1UY4J6suUgaDJTlnjcRnlVsP/xwdMNOWat184k+/4yk+A5xR1Nsfkew5QdQYufYCrVAn12kih+SfhwlUDRoeeQSgpf1GL8BCRbxTslCSFa7BYdH9eVbWaiIHCJKZlSp9yuhTTIEKnpQNOs6VolvZSvdI/Oi7hwbGd8dgXS2oHY3I1epbg=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BC9468118FA4474AA74822C6B4512295@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c91c030f-6294-47d9-8bc5-08d6cd3bd848
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2019 07:17:03.7440
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4660
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 09:16:19AM -0700, David Ahern wrote:
> From: David Ahern <dsahern@gmail.com>
>=20
> Similar to the cached routes, make IPv4 exceptions accessible when
> using an IPv6 nexthop struct with IPv4 routes. Simplify the exception
> functions by passing in fib_nh_common since that is all it needs,
> and then cleanup the call sites that have extraneous fib_nh conversions.
>=20
> As with the cached routes this is a change in location only, from fib_nh
> up to fib_nh_common; no functional change intended:
>=20
> Signed-off-by: David Ahern <dsahern@gmail.com>

Reviewed-by: Ido Schimmel <idosch@mellanox.com>
