Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD1A52D1495
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 16:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbgLGPXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 10:23:16 -0500
Received: from mail-vi1eur05on2055.outbound.protection.outlook.com ([40.107.21.55]:33377
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725822AbgLGPXQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 10:23:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k6hd9HntQzrwbE8UWW3mejtCzsMtr8mk/DTnLHAlGpBuo1jAr+Sa0FDQzmjxOZv+MlNk5r9R1oDupqrLw9Kna2m5KIiLHACAVbEQaDx3YB72KBbuITvk3LEQLsyh8+Pg7uCY6NAe2Ti9jku7aMo/QiFQ1VQhroRABo026s6JPyDTRN3zZWmDWkzp7SrusrYPXJR7rm+pweNu+Urhd68QQTjOfZszlmA1fFmBApRVRR6sdZWB0oejvuhUvv4tYVkAULkWeHhE9eL3EcqACJqIgkw6lV3e0GlnPhroVKirYVdmAyhxCV6WTBsWmqT3kaCa0EWJVXkojP3Fnztx+drlVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2PMc2r8z+VGC7lx4Ey9T4izGJWIewCbbWEv26lUdjk8=;
 b=PYebXei2iJ/1kF40jIjPUEXyf4f9hvVcgAFPKaDmiVd5amLwz2YMbFS4ff3WgWeceKgSGKNNCSBXttIrgQUaZYKOUT+QPI3TBkkzA6hQuIRyVkyjcMg55av5uT8+grHrQs18QIlDcDWUcsOkZ2eaUr2UgnE6sh1b9LODuTrAwpOn0EUUNWBtBB6rA0RMEcvhcLnxgoJyl7PfQPIGAlcVgI7DCii6Nj++uAA/kraT4728CSomDS19lA8XisxLJnD9aEeFo7xIZjZQpGccXE11zdjLvQqWDChPMI+tdx+2cw1Tx1/rLLipyFntyLkUmDz7Ynl+4+WAknQNaVzVes5P2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2PMc2r8z+VGC7lx4Ey9T4izGJWIewCbbWEv26lUdjk8=;
 b=mxvvRooRAoMo31W2TceydnRCOPOS/NOw9f+5hnIQ8jITr3luhPlnZOfADkuScXCR8B5BM3cuPchAADcKlja4ge1BJnFqhgEid+n3k6YwDcnB0OM+IWDyepAzUtTdVhRoyaophOgLHgF7wZ1hZHMsUOXfwIuAbicIKHZGCuvxiGM=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB3616.eurprd04.prod.outlook.com (2603:10a6:803:8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.23; Mon, 7 Dec
 2020 15:22:27 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3632.021; Mon, 7 Dec 2020
 15:22:27 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jiri Benc <jbenc@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: Re: [RFC PATCH net-next 05/13] net: bonding: hold the netdev lists
 lock when retrieving device statistics
Thread-Topic: [RFC PATCH net-next 05/13] net: bonding: hold the netdev lists
 lock when retrieving device statistics
Thread-Index: AQHWzCvp+5zpZdZumUWV00Rtz8jGw6nq0GsAgADwxYA=
Date:   Mon, 7 Dec 2020 15:22:26 +0000
Message-ID: <20201207152225.hcvdq2n7ayo63f6k@skbuf>
References: <20201206235919.393158-1-vladimir.oltean@nxp.com>
 <20201206235919.393158-6-vladimir.oltean@nxp.com>
 <20201207010040.eriknpcidft3qul6@skbuf>
In-Reply-To: <20201207010040.eriknpcidft3qul6@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ae6659b6-290d-4d41-bd51-08d89ac3e7c1
x-ms-traffictypediagnostic: VI1PR0402MB3616:
x-microsoft-antispam-prvs: <VI1PR0402MB3616A98CEF3AE032464156E5E0CE0@VI1PR0402MB3616.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4+8RSgmWH1pomDuv3FUdgJ4bUgepAfUBgv+6eVQWy9MaBh1Aw39GGCjtsxd+6Sm4S9Rf8AofQnTdCG55PBspkEHWXRZVE1+iREyKWDaOONgxVMFOIGjI1KSZH8VACNuCyRlAdOS8EAfEZw15kKfBJnc9H2xCKOqHeBInIWRqqlakI8kySG7NMyZalfJM9+mNAFPpg7hm2nxWAKyWBAfZnDa9LuaMbXU71T80h+xaGULJYhHEPybhDFUwPKBP/tDUHmVy3gdjfWgrUb4Hb0kKSXYy4NN5eEsJRBqF/sQIhlLFiA7zQuefI9xCJ48CSd/d
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(39860400002)(376002)(136003)(396003)(346002)(366004)(316002)(66556008)(66476007)(110136005)(2906002)(8936002)(4326008)(91956017)(7416002)(66946007)(76116006)(6486002)(83380400001)(9686003)(186003)(26005)(71200400001)(33716001)(86362001)(64756008)(478600001)(8676002)(6506007)(1076003)(6512007)(44832011)(5660300002)(54906003)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?z2GXl5GedkWqvU15kghr8xubVAEEjFi6esuJjTFaJHGOOjrn+veygX0TZVxF?=
 =?us-ascii?Q?4k44qqiwcGkke1cus8WSFhMN5tGHhIrGQsGo1/b8qlSfCEbkjYW/dX6VMjQ+?=
 =?us-ascii?Q?l+FNCjHlhodrhukZTr1XFGa7mNu70ZjW4KXF1SKupkQS4k2wPJx4iw48hGXh?=
 =?us-ascii?Q?PHAVk0rhi4ag9D2rq+hssJ1wS2yxd7ISTMhbRgz9XcsAWIUnWieIRI0Db8VX?=
 =?us-ascii?Q?sqWK6ncc/60iXbvp4/CJcb2++NjA3yQz/nrCuYJj6yGb8IOq7CWVPa9mkGVo?=
 =?us-ascii?Q?x+Hx1/FEZDJD0iATN1nJnOlLoxJL3d+l6q4LW9DolXy5vJuIMtNLMH+q3TFq?=
 =?us-ascii?Q?8aj38tftkqxclDRwJrDP//Db8hTDr3MhiSohLhCYw+SI6rrKm4Uc1II4xfaj?=
 =?us-ascii?Q?Flw1LGbh3MbyHeiyhntuaaZGPS9N6RPrxl9NOmurOPMXcNAWNtf0eEr+KaZq?=
 =?us-ascii?Q?ttM2p7MhtM4KR+O80zCC4Z2Jc8+kFqs0LFoX2TTQeYkzq3Fiyqcp1hDiQHeE?=
 =?us-ascii?Q?KsWR7IHEZ7/4pdznB2SMso4hxw0qmcf2baeFJIOIKgP8DF20p+0Ceq1Tfz/e?=
 =?us-ascii?Q?Q8QJMTrDJbkZuvS3cpV/4B8maJcvC5Tk83iQaeEJ8zy1QNjShWJk29Eix0ca?=
 =?us-ascii?Q?x6I7D/AOfjvpouyg5gTvnBd7Bnd8jpJkPJ7wrXhDYmRvrVsPltPHBF3/GrrA?=
 =?us-ascii?Q?FOBBXSJFwCR7C77dahvJKaWcVKav8Amlz5xk9ZeDV6p75ZqDB1wcJcdIYktw?=
 =?us-ascii?Q?vrrj2qIOO5sXGEIQtRDkQZTtcGh0TuVQgG8+imTPmmilPImBv+KhUryZ3a2L?=
 =?us-ascii?Q?Xemp4fECXfE/KhyHr9PayEZezDVuYXP9OmAYlTSgTdzm9dxbsF2sio/SS9dm?=
 =?us-ascii?Q?EQcwFye7oqtGHLms7JQbgnk1UcCyR8y6Dg2j88aTrkcbeJBEdvhNCbgSNK2i?=
 =?us-ascii?Q?y8hbER8UZPxYzo/XIEOstlku+ZMTFpT+LH5bQMsIxYEcU+sJwmE8Gpkc0h00?=
 =?us-ascii?Q?Oduc?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A415556EDAC01643A8DEBF4C78892932@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae6659b6-290d-4d41-bd51-08d89ac3e7c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2020 15:22:26.8980
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QF0icC1CCykz+17saZkXEbXtT88VSMyQxV55s5CEct7ZjtnQaK4HJgz7fO4lklr036h0KewPD7bxarvIhqUbtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3616
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 07, 2020 at 03:00:40AM +0200, Vladimir Oltean wrote:
> There is a very obvious deadlock here which happens when we have
> bond-over-bond and the upper calls dev_get_stats from the lower.
>
> Conceptually, the same can happen even in any number of stacking
> combinations between bonding, net_failover, [ insert any other driver
> that takes net->netdev_lists_lock here ].
>
> There would be two approaches trying to solve this issue:
> - using mutex_lock_nested where we aren't sure that we are top level
> - ensuring through convention that user space always takes
>   net->netdev_lists_lock when calling dev_get_stats, and documenting
>   that, and therefore making it unnecessary to lock in bonding.
>
> I took neither of the two approaches (I don't really like either one too
> much), hence [ one of ] the reasons for the RFC. Comments?

And there are also issues which are more subtle (or maybe just to me, at
the time I wrote the patch). Like the fact that the netdev adjacency
lists are not protected by net->netdev_lists_lock, but still by the RTNL
mutex and RCU. I think that in order for the iteration through lower
interfaces to capture a consistent state of the adjancency lists of all
interfaces, the __netdev_adjacent_dev_link_lists and
__netdev_adjacent_dev_unlink_lists functions would need to be run under
the net->netdev_lists_lock, and not just under some lock per-netdev.
But this is raising the locking domain covered by net->netdev_lists_lock
to more than I initially intended. I'll try to do this and see how it
works.=
