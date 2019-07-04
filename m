Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53D4E5F7CD
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 14:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727673AbfGDMQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 08:16:45 -0400
Received: from mail-eopbgr30064.outbound.protection.outlook.com ([40.107.3.64]:18353
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727667AbfGDMQp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 08:16:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JQOY7bfBNFjjD2D9Hut1eUOxSI72Z5YyLw0wQwU9PRM=;
 b=JdwMhDNfsQwGiQ+t+ztt15rkwMz/6s97XWJb5038f4Z58FAgG5nqyFvhpoR2dWygox3bNcapGld3WcCyloLC/hQ7AWwVA1rR73XGImwi6XGcEU2op6UXnl9pb2KG8zTmr1ZoPsFQhWUJnszapGMISisXBGdsMEsTDJN+qGOV2GY=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (10.171.182.144) by
 VI1PR05MB5966.eurprd05.prod.outlook.com (20.178.126.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.18; Thu, 4 Jul 2019 12:16:42 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e%5]) with mapi id 15.20.2032.019; Thu, 4 Jul 2019
 12:16:42 +0000
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "poswald@suse.com" <poswald@suse.com>,
        "mustafa.ismail@intel.com" <mustafa.ismail@intel.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [net-next 1/3] ice: Initialize and register platform device to
 provide RDMA
Thread-Topic: [net-next 1/3] ice: Initialize and register platform device to
 provide RDMA
Thread-Index: AQHVMg3rTq5orI7nM0W8xdFRWAzlRqa6YIUA
Date:   Thu, 4 Jul 2019 12:16:41 +0000
Message-ID: <20190704121632.GB3401@mellanox.com>
References: <20190704021252.15534-1-jeffrey.t.kirsher@intel.com>
 <20190704021252.15534-2-jeffrey.t.kirsher@intel.com>
In-Reply-To: <20190704021252.15534-2-jeffrey.t.kirsher@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BL0PR1501CA0002.namprd15.prod.outlook.com
 (2603:10b6:207:17::15) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:4d::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [156.34.55.100]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 06254009-413e-4430-746e-08d7007978db
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB5966;
x-ms-traffictypediagnostic: VI1PR05MB5966:
x-microsoft-antispam-prvs: <VI1PR05MB5966D44D9DEE9A9359098E65CFFA0@VI1PR05MB5966.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0088C92887
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(136003)(39860400002)(366004)(396003)(189003)(199004)(25786009)(36756003)(386003)(6506007)(14454004)(6246003)(86362001)(3846002)(6486002)(6116002)(68736007)(4744005)(1076003)(186003)(2906002)(7416002)(66066001)(305945005)(7736002)(229853002)(102836004)(71190400001)(2616005)(66556008)(446003)(478600001)(486006)(66446008)(64756008)(73956011)(81156014)(66946007)(8676002)(5660300002)(8936002)(6436002)(81166006)(33656002)(54906003)(71200400001)(110136005)(52116002)(53936002)(316002)(76176011)(99286004)(26005)(476003)(4326008)(11346002)(66476007)(14444005)(256004)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5966;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: MCijnfMfHCHYd1nSdTQAPvHaoM+LNR8grPBWp5p5z8XdSywDC1rhfnjHiAqjZdlxWB6BHl2alJorHcXgFlK9V3zkF4irpHTOeF9ER/EgdYu7GFkq53Krdg2tTm9+XR7JmKqUFEtytR5c9B95SOUZIsGNOShiVYxOlNTsinvnvgqM25LRVsV97DnmgWG4zXJ5r1S0PS3WN9Y7pJShIFalrl0KIL/oviTGp4ck6XHPwCypFb7ek8maEjGWu64cjjA35CLBTgVWkM6KZFdYCr7FmB3v5K7MiKK+J57p+1hn+3pg6/z+9xg0qLqRNQQ/hkIUF0NZ2HS8y3Nv+iZboVde82tBmbDdeDi3n7mI6+/LzaadPFJtP3+fLfIjU2RZjmq7Y4bhxDqdG0Jeb0gwca/NWl6bfbCKQMNTgLKxM3LNe+Y=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F9AC956A73C52740A479C55CB9B8B460@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06254009-413e-4430-746e-08d7007978db
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2019 12:16:41.8013
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jgg@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5966
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 03, 2019 at 07:12:50PM -0700, Jeff Kirsher wrote:
> From: Tony Nguyen <anthony.l.nguyen@intel.com>
>=20
> The RDMA block does not advertise on the PCI bus or any other bus.
> Thus the ice driver needs to provide access to the RDMA hardware block
> via a virtual bus; utilize the platform bus to provide this access.
>=20
> This patch initializes the driver to support RDMA as well as creates
> and registers a platform device for the RDMA driver to register to. At
> this point the driver is fully initialized to register a platform
> driver, however, can not yet register as the ops have not been
> implemented.

I think you need Greg's ack on all this driver stuff - particularly
that a platform_device is OK.

Jason
