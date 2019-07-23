Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A00A719F4
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 16:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390425AbfGWOJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 10:09:15 -0400
Received: from mail-eopbgr140110.outbound.protection.outlook.com ([40.107.14.110]:56002
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726201AbfGWOJO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 10:09:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ck39ZsMjZnfmRo5lSbZS9UYnrR/ff5blJRPotL+RS5xhkLLsiNXdJhLPLgxa2FsommcqSoPvWgaRLNdBeCzzLKUpaXZNVg13XO3cM/hc9TvauAE2iwX+BKSuEaDhtU5MC5wz/6yzGNO9oAIlcg93XnyA4fgbcR02PXfdXSQHVnb9NOjv6xbdrOKS/SiDlOC849D+PVgF8WVxqCcebifCELLnOwJl1WTu6WIzItivbR7AAh6vlEz8DD6VYQfbC+FodIMKdRlaJ3DmNjRUN+/nsBVY8eBfsGtfIThquePkCNPPjg29OntlvF8/rwe0DFSOKF85d16G683mUB+Ui7p3yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E3oDFnRYzCD4BuuF2tYpjxmJ19fxAaUg+pHx7Ppme+M=;
 b=n2mT9sEvhqG59vcXKqgPYBR2qO9p2OPSbUdWJHyKGdipL4CAiwq0Qk6wL53wMaZJvcf4Sx4GeyGVuQR8zlCht+n6Vn4FEnRXgZzPLLAHICJjPOh8tWc87WMrgsEmR9GERPUP9fAyc7c26PKVdDJls+/CWGhE4jAhV91GJSwyBzCIyyGouWf3VDQs3rLn5VWH7BjEN0keu55vWQE4GLMfERIo+geKmZf03VnOdirjyKCCxBBctuVHBVWxfrjoAO4AgtP6aOr+saBjq7IwUH4Yjzu+OUh80Mngi+C218ktOYCIb65jU2HVcfmHVstRwKAXWzGf0jd5BVApcOH+4QwBmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=prevas.se;dmarc=pass action=none
 header.from=prevas.dk;dkim=pass header.d=prevas.dk;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.se;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E3oDFnRYzCD4BuuF2tYpjxmJ19fxAaUg+pHx7Ppme+M=;
 b=Bnas+BVDR6iTnSch6CzGlddLrzC4rEFgdlavBt4UWVLc6tQydeOYj/b/MhJVop/ee1FS5LDHYDUTfZwBrxFUHoP5/fQBbaYWvPREa6OFg7ghlF9QT5Rhoa+LUF+CfGoPkgYs/ONuSIPQnwjMD9Z4SaYQo/eQ+zhxtQrYfLAQ2JA=
Received: from AM0PR10MB3476.EURPRD10.PROD.OUTLOOK.COM (10.186.175.83) by
 AM0PR10MB2900.EURPRD10.PROD.OUTLOOK.COM (10.255.28.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Tue, 23 Jul 2019 14:09:10 +0000
Received: from AM0PR10MB3476.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9451:861a:85cc:daa0]) by AM0PR10MB3476.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9451:861a:85cc:daa0%2]) with mapi id 15.20.2094.017; Tue, 23 Jul 2019
 14:09:10 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: avoid some redundant vtu
 load/purge operations
Thread-Topic: [PATCH net-next] net: dsa: mv88e6xxx: avoid some redundant vtu
 load/purge operations
Thread-Index: AQHVQOZrz5Mh4qk+xE+98wWJgclwEabYNp6AgAAH9oA=
Date:   Tue, 23 Jul 2019 14:09:10 +0000
Message-ID: <956f9821-199d-074d-9508-2bdcd12cf4bf@prevas.dk>
References: <20190722233713.31396-1-rasmus.villemoes@prevas.dk>
 <20190723134037.GA2381@lunn.ch>
In-Reply-To: <20190723134037.GA2381@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR0902CA0020.eurprd09.prod.outlook.com
 (2603:10a6:3:e5::30) To AM0PR10MB3476.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:15e::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Rasmus.Villemoes@prevas.se; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [81.216.59.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8516a62e-36f6-483b-4ce0-08d70f77552b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:AM0PR10MB2900;
x-ms-traffictypediagnostic: AM0PR10MB2900:
x-microsoft-antispam-prvs: <AM0PR10MB2900D0A71B45AC5D442DB8E88AC70@AM0PR10MB2900.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(136003)(376002)(39840400004)(366004)(396003)(199004)(189003)(31686004)(54906003)(66066001)(11346002)(446003)(229853002)(4326008)(476003)(2616005)(26005)(6916009)(186003)(508600001)(71190400001)(71200400001)(256004)(305945005)(7736002)(42882007)(52116002)(14454004)(6116002)(3846002)(316002)(76176011)(386003)(6506007)(102836004)(36756003)(66946007)(8976002)(6512007)(44832011)(31696002)(486006)(6246003)(2906002)(68736007)(6436002)(81156014)(81166006)(66446008)(53936002)(99286004)(25786009)(4744005)(6486002)(8936002)(66556008)(5660300002)(64756008)(8676002)(66476007);DIR:OUT;SFP:1102;SCL:1;SRVR:AM0PR10MB2900;H:AM0PR10MB3476.EURPRD10.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: prevas.se does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 1l0Q+AZBJbLOt6Tv10i+IPsLAjk+NPv9jJ7qX6pJbtw+p3VdDiyvW2nzEf2n0j8KvmlPAidTAw6Y8Mjzm/BxtxaF9SKE3nvppZAY7EWild+u2AluyWgKxMkDapF7+WzIAsmZeC5/N3p6EPgTp/UskSYmzX0lis9vf+324keuZ3y4YtU6CYrkoGs2qWg683YXxWXw6oz4I1PIjakFlLKA8dVlaO1+XE4Ho6NfNrBs1IbydRLsWNVzakRiWR3h8IlJ7bcptlqlbr4NTXTLJEZU3c5ueRViG6yKnSdFbMMN2kGOZKLKG18VSDGuBxP6gxohqGTjKgtSgxbtN4odRAk2DENWO960mIGnad1awNW4LlXCbTEJQb25rJTWx7Lp+anNOMzKno9rzPFFQ3oBaPCxLlJcWq3ySr6rrp+wZ3T4s8o=
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <191625002D586F499931A603205244AC@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 8516a62e-36f6-483b-4ce0-08d70f77552b
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 14:09:10.2502
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rasmus.Villemoes@prevas.dk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB2900
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/07/2019 15.40, Andrew Lunn wrote:
> On Mon, Jul 22, 2019 at 11:37:26PM +0000, Rasmus Villemoes wrote:
>> We have an ERPS (Ethernet Ring Protection Switching) setup involving
>> mv88e6250 switches which we're in the process of switching to a BSP
>> based on the mainline driver. Breaking any link in the ring works as
>> expected, with the ring reconfiguring itself quickly and traffic
>> continuing with almost no noticable drops. However, when plugging back
>> the cable, we see 5+ second stalls.
>=20
> Hi Rasmus
>=20
> I would prefer Vivien reviews this patch. But he is away at the
> moment. Are you O.K. to wait a few days?

Sure, no rush.

Rasmus
