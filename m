Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECB7355FFD7
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 14:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232117AbiF2M0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 08:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbiF2M0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 08:26:35 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2048.outbound.protection.outlook.com [40.107.20.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21ED535A96;
        Wed, 29 Jun 2022 05:26:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fPWsB6p+6w5t8/XpxK/Hs+YJA6SE7k2XbSPQDwL5GzjrmF/RLlIKWc6j8y6xuyIWA3+/2F7M3aSw2T3BKaoBDTwIxKwbhrfRYufs28KYNDdn0nLuLJJwoGdAkAIESEJuth/k4GnlUBZea/g8j/lS4vPGR0YTmtRS8wzhlM3kuR276qwvgPIyQ/5rHgQSrF8o1QIU6BDRei/eFe2pvjR3XsLlyRmfpmi9sJZdF73xtssE/Zz+71mAw5OfPdd9jcdkfYdQJh8XYS8Sw0U2PIRY+Mi9aVSjN+y14HUEkYY7CcyExq22hzyN96/gEUcJHcn49Ql7haOcWwDDOMKLIKOReg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EfA1i+LRu4VG9I3meOb4tv5VKkJ6Nhg/KS+9Sgke6qo=;
 b=fvbsge1JFKbgyvV8VlB3oJumou/g5vrmcakkAlcgj/K4XkNikTTrWyyOfTllxOA2cSTmPOWpOvdgZBQ7CvdFfsnoNIBrC3K8R81uqgom80ov9FFrrD74lTY2UX6m+2nEPqDVdHWxE5i/LkzVkgpRdT/Vc59duIRKT9Xl33IOyB2G6zqf+pAqcwH66nTmpJWDfBeCgtK8In6s7aDfN8MA/wa/tZuVNxc3Kt3Zv+3QWNEtLfRHeCqO64Uw1mm14NMjUejotRb1FKcI5BAgnbwduF8kqqaLRlt45Z7Q5nJoia0eftXDljM3qGvMEzuh8w8cLCxXNUxqKx+wLz7CZLzATg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EfA1i+LRu4VG9I3meOb4tv5VKkJ6Nhg/KS+9Sgke6qo=;
 b=bJ76hl2kLyNrDAECzh7DJDPvzHlqin8R7J0McqAuuF1tbmemFxatInAZWkJ/QD4Ba2fSVze3nyKoJp4r0KqEvPQ9LlUXnFTHKDVW8+g+rv7qjCBRiQ0UnmsQO8av6SDPADRfQQoYbGPDpJvTqydoUNYIYiA5cW2+ZRluV17wEUI=
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AM0PR04MB6033.eurprd04.prod.outlook.com (2603:10a6:208:13b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Wed, 29 Jun
 2022 12:26:32 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5c17:601f:ac4f:ebfd]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5c17:601f:ac4f:ebfd%6]) with mapi id 15.20.5373.018; Wed, 29 Jun 2022
 12:26:31 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
Subject: Re: [PATCH net-next v2 0/7] net: lan966x: Add lag support
Thread-Topic: [PATCH net-next v2 0/7] net: lan966x: Add lag support
Thread-Index: AQHYimHdDTDh5jwai02cndkVFmS37q1mUicA
Date:   Wed, 29 Jun 2022 12:26:31 +0000
Message-ID: <20220629122630.qd7nsqmkxoshovhc@skbuf>
References: <20220627201330.45219-1-horatiu.vultur@microchip.com>
In-Reply-To: <20220627201330.45219-1-horatiu.vultur@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5b77fbbd-7a8b-4184-2321-08da59ca996d
x-ms-traffictypediagnostic: AM0PR04MB6033:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: N/P+v7QOFzjYovbn6pYMY+jE3/sm7h9+JugNBgAyjDiarktk7km+0zoHsuJhj/v2iadXJyAgAjBLvRSuWBhvrozhJtma4J9gQ8XhYC1wIRkfQCadcs9zzIrDirUGAGme8VutTZbOXvvoU9q797oUfj9SeI0L60Bp58h+M8dt9KlFnZkAJD2j5AxyF1jWycYBawnQ7Y3yj6aeleQQsAZI8zm3yvf8nyG4HCU5/UpNUSErtdtWaoJRMsVWMN9P0AH8CaqqJLVXhy+VfhWM1kIKZ//UPyeVoijVDWz/JB4DdtPO4bLQv/bL6CBWLrUH8e6uOQgjSrhnXvYFuNfCCtiI3ZPJbUwl+ZuRa1J179Si6ofihuhf3hnQAy9Po/GMESM2OcKhiqhjvRLyoWAuFVrpPqSs1mnDjixXIqlj/Cb9SpfDZbxbcFgvrjJakcvhuFMUUnfblVXDwim5Ph3LRj5y5T2FXPJcItkqEqPF8nSmHIEKard0m5XyHho9l5aglNhoF0tPoXMuMoz5PC0knoFt+cpY3+j27lpHl+j8wOg+VtxsBoqsO9WuR+WPPKWmQRwWcsVkHcjJ1Xjp6PYk23D/uatolsMhiwyYUHYecF0s/PPNRqd07u2Qn/rfkrNVyvXJ9852q0RMGRPPBocNP8RTXBlL9nKKYiCEDoeZGu01w6y50u/2uv85+J9q4RrsuNRpMDTIa5T8qnGVqVkhkwrgmkFYU3qxJOVQSe+lUcit2RyaVbXYW7Ld4emkiio4iyw77L3b/mJNRa+dZ/i/GDI2Q349j1OYR8zVMMfsb6QOnik=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(346002)(396003)(366004)(39860400002)(376002)(136003)(26005)(86362001)(6512007)(6506007)(9686003)(66946007)(71200400001)(8676002)(38070700005)(66446008)(66476007)(4326008)(64756008)(76116006)(6486002)(83380400001)(8936002)(1076003)(33716001)(44832011)(66556008)(478600001)(6916009)(5660300002)(54906003)(122000001)(38100700002)(41300700001)(2906002)(186003)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?K85pBCrai1wmxR44GwwgrvWToVQoHTnDOIYbB66h32LX+nPPvua+s2CyZIM4?=
 =?us-ascii?Q?WidJ/E2m1/wO9zPK3F2ly6sU2A2SJxdj+3GJ0MDB5yQndCVjSAH425I3cKdU?=
 =?us-ascii?Q?YY4wiNH3LOvKatJ/OSxQljs8Z0/gh7Lxc/tzB/e8gg3MBYd0qYY2vT8gN6mJ?=
 =?us-ascii?Q?8k9eXdWEhHYdOJxlsvZEKq21PykbaUCCFDbIKtdXA+Dyutn2rSTxf9flgGmt?=
 =?us-ascii?Q?OUp7pk2GZVZy8UuDqzG893kbwBX+mybbqxBpQzVWvFDZX4UGS29DLX21iDdi?=
 =?us-ascii?Q?blqX+tgyM4yWEyEb67rickBDnqdasjaxrpxQClVuzyPbRhFGfTGj+7D8AF4i?=
 =?us-ascii?Q?JBrwL8SwckYf0EJLtyzxGIaaA+wWmSNf1nwt1aXjnsZPN3Ew2gMHzFmr8K2G?=
 =?us-ascii?Q?fViXZqq/FqyshOQp8uI/26NLiHpJUgbgEh/ArQrf42sBOc7PyeVov0Kf1XYZ?=
 =?us-ascii?Q?YcS34Pp/z48V6h/LlD5XG/tRsKtGeoG9V8HbG0h6mSOdZ/DUzDq1Tkd7YIl3?=
 =?us-ascii?Q?F5AnxxMDaDJtEj83Rsdn2tZhyCsYgD0O9CweXX5SuuLlmgBqLN5tHctNRn6X?=
 =?us-ascii?Q?Q2IyxAmwM9OfoNyN0CsAvGnKajwRNu/BgqXXmbzHHt7RdUHTLsxw2hn1rAcI?=
 =?us-ascii?Q?+ahMcTs7/GALHYiT3a0vv0ZKBZc1/euSUcEcsU++1Y2sVnWH8qsTHO83NfBr?=
 =?us-ascii?Q?HvRM4mpPjxyUm6EbtP9jlBHTw11wo5kWrgS23SnilYyo2dP/k+W0c7UNH4Ej?=
 =?us-ascii?Q?YnrdtEw/HTK9DQXKZqyCLnIncvvUkUd6NHEDhrw+J39+uJyJiRV+hpWKJk/V?=
 =?us-ascii?Q?eMd7kYyrNvvPKFMty5ZWGE9UWxmo3hoXIASK9Lx/0yjEIBWy/t0CTOs8EVsr?=
 =?us-ascii?Q?GC0PDSth6aaXHkYYSFqpV7DxM4epo0KH/7ECsmaY/1gv1ib/3BX3qUxMamIW?=
 =?us-ascii?Q?aSrUuUEGSUjYxFQN3nwKCpRN2LxNyMmEYHZ1zliuIZ/kXhVX9wj/qkCO0VHX?=
 =?us-ascii?Q?hEAsh/itOZw2B7EKRNXlSTQRDXKRdM/phgbGl6GiDcOYb4onnpbSVMV1ylzh?=
 =?us-ascii?Q?0d9PEiusguHPSrdIsBZH4n4zhhQkeSVNByla5hdusN0w4JUF5hUvoSIJd/YZ?=
 =?us-ascii?Q?wnoqceR7QRAkFXTu9IMibhE9aJUrxDs6r/Mk84Olm2t13BGEGVV62pRjZKrP?=
 =?us-ascii?Q?UrstZwRqAjyerhwcgYbi+430IKSlgfHrXj0/f2RYuuS6+YF40bIG1NyYzLCz?=
 =?us-ascii?Q?ew/PuvNd08O51lcIamtudo/EutYDazyBVlnhsLsnj1n4zE8C1wKOinXKCpRO?=
 =?us-ascii?Q?Y5/wnsnZqFRJPiFqzgPJQBPiaz8ZtPwgCLS2Bf/62weF6EG4sUlPlA40QodE?=
 =?us-ascii?Q?na//exlEv9SipLYt4MLBqgD40zp5W3lrE3FDQc2JPq1BZD528Fn7ctTmj45+?=
 =?us-ascii?Q?NqcIMXFCgeLHiL35WYL7s7u7on1sz7/ZGE8n8uH7UrFQxoMz2IEui9yo4YyR?=
 =?us-ascii?Q?Viq/w7QiveSF0XaDFQvQTT1XKNg/hvn/wr0LeSnEsa42idId/6fK+QXf2qBN?=
 =?us-ascii?Q?g4vEJtFWZqvLpKJ1TucehT+IR/8TyXEkwKipr9SYL0kFLLZCZG7HVZ1JAq4B?=
 =?us-ascii?Q?gA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9EC444AAB4EA6E4FABFBE2E9A36355ED@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b77fbbd-7a8b-4184-2321-08da59ca996d
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2022 12:26:31.8366
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xh0B6bkz1onzvEtvWU6C7kydYp95jJxMXje1OKFo7y9XLABfczJaORf8FiluPwwBFDDU11iBtDRoNnLdDGZpyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6033
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Horatiu,

On Mon, Jun 27, 2022 at 10:13:23PM +0200, Horatiu Vultur wrote:
> Add lag support for lan966x.
> First 4 patches don't do any changes to the current behaviour, they
> just prepare for lag support. While the rest is to add the lag support.
>=20
> v1->v2:
> - fix the LAG PGIDs when ports go down, in this way is not
>   needed anymore the last patch of the series.
>=20
> Horatiu Vultur (7):
>   net: lan966x: Add reqisters used to configure lag interfaces
>   net: lan966x: Split lan966x_fdb_event_work
>   net: lan966x: Expose lan966x_switchdev_nb and
>     lan966x_switchdev_blocking_nb
>   net: lan966x: Extend lan966x_foreign_bridging_check
>   net: lan966x: Add lag support for lan966x.
>   net: lan966x: Extend FDB to support also lag
>   net: lan966x: Extend MAC to support also lag interfaces.
>=20
>  .../net/ethernet/microchip/lan966x/Makefile   |   2 +-
>  .../ethernet/microchip/lan966x/lan966x_fdb.c  | 153 ++++++---
>  .../ethernet/microchip/lan966x/lan966x_lag.c  | 322 ++++++++++++++++++
>  .../ethernet/microchip/lan966x/lan966x_mac.c  |  66 +++-
>  .../ethernet/microchip/lan966x/lan966x_main.h |  41 +++
>  .../ethernet/microchip/lan966x/lan966x_regs.h |  45 +++
>  .../microchip/lan966x/lan966x_switchdev.c     | 115 +++++--
>  7 files changed, 654 insertions(+), 90 deletions(-)
>  create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_lag.c
>=20
> --=20
> 2.33.0
>

I've downloaded and applied your patches and I have some general feedback.
Some of it relates to changes which were not made and hence I couldn't
have commented on the patches themselves, so I'm posting it here.

1. switchdev_bridge_port_offload() returns an error code if object
replay failed, or if it couldn't get the port parent id, or if the user
tries to join a lan966x port and a port belonging to another switchdev
driver to the same LAG. It would be good to propagate this error and not
ignore it.

Side note: maybe this could help to eliminate the extra logic you need
to add to lan966x_foreign_bridging_check().

2. lan966x_foreign_dev_check() seems wrong/misunderstood. Currently it
reports that a LAG upper is a foreign interface (unoffloaded). In turn,
this makes switchdev_lower_dev_find() not find any lan966x interface
beneath a LAG, and hence, __switchdev_handle_fdb_event_to_device() would
not recurse to the lan966x "dev" below a LAG when the "orig_dev" of an
FDB event is the bridge itself. Otherwise said, if you have no direct
lan966x port under a bridge, but just bridge -> LAG -> lan966x, you will
miss all local (host-filtered) FDB event notifications that you should
otherwise learn towards the CPU.

3. The implementation of lan966x_lag_mac_add_entry(), with that first
call to lan966x_mac_del_entry(), seems a hack. Why do you need to do
that?

4. The handling of lan966x->mac_lock seems wrong in general, not just
particular to this patch set. In particular, it appears to protect too
little in lan966x_mac_add_entry(), i.e. just the list_add_tail.
This makes it possible for lan966x_mac_lookup and lan966x_mac_learn to
be concurrent with lan966x_mac_del_entry(). In turn, this appears bad
first and foremost for the hardware access interface, since the MAC
table access is indirect, and if you allow multiple threads to
concurrently call lan966x_mac_select(), change the command in
ANA_MACACCESS, and poll for command completion, things will go sideways
very quickly (one command will inadvertently poll for the completion of
another, which inadvertently operates on the row/column selected by yet
a third command, all that due to improper serialization).

5. There is a race between lan966x_fdb_lag_event_work() calling
lan966x_lag_first_port(), and lan966x_lag_port_leave() changing
port->bond =3D NULL. Specifically, when a lan966x port leaves a LAG, there
might still be deferred FDB events (add or del) which are still pending.
There exists a dead time during which you will ignore these, because you
think that the first lan966x LAG port isn't the first lan966x LAG port,
which will lead to a desynchronization between the bridge FDB and the
hardware FDB.

In DSA we solved this by flushing lan966x->fdb_work inside
lan966x_port_prechangeupper() on leave. This waits for the pending
events to finish, and the bridge will not emit further events.
It's important to do this in prechangeupper() rather than in
changeupper() because switchdev_handle_fdb_event_to_device() needs the
upper/lower relationship to still exist to function properly, and in
changeupper() it has already been destroyed.

Side note: if you flush lan966x->fdb_work, then you have an upper bound
for how long can lan966x_fdb_event_work be deferred. Specifically, you
can remove the dev_hold() and dev_put() calls, since it surely can't be
deferred until after the netdev is unregistered. The bounding event is
much quicker - the lan966x port leaves the LAG.

6. You are missing LAG FDB migration logic in lan966x_lag_port_join().
Specifically, you assume that the lan966x_lag_first_port() will never
change, probably because you just make the switch ports join the LAG in
the order 1, 2, 3. But they can also join in the order 3, 2, 1.=
