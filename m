Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49A4961060A
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 00:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234875AbiJ0W6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 18:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233548AbiJ0W6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 18:58:37 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2086.outbound.protection.outlook.com [40.107.20.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC42B56E2
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 15:58:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OKMYdlUCHN0N2SWTaJVfyyBRN6YIvfoi4LXal78lbq2kuDWLwnBCGBPsP7gAw33BLyOdSFi9T5SDziuloDTWty3ia3eGZJChIqdp3zJMKIooMnjwCqHiH/O/a+qIC9gHIuGfGaeQ8XKgRrAalAqLm4BD9E4J/oF72waxKti+Hsj1TWVGObFOHvwTO8kMGog3VP9sWXkXPzPH5EV59CGAgBy9byANT3fUYT/DQ/CLhoYp9ubMCL+5HQaPQHfUeUZo0V/Q6IBfMJZsm9stYP3nDU4sU19Zm9MAu3J5WM09ZmvVCn8Fw3Z1iUALyEDn4+1G1MPtLAEecuyoZ/RdC6MtFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0piNMHbPRHz2tA4mZUV2Fet5WHFOTUIUdxfjvlIt6G4=;
 b=WjfLd9bllpE4R80FcoHDVi4BBcTr8BU2GLuFKkujAZNvy+r81iuRFtvBYSi+/AqGFznNp2KcfJSdpQuF+2M7u8su0vJ8SV3sPlgZke+t1j4nbA50M01OXrz5GqmS+UoonOywTo8kKbIdbVWrcHTpSwyocGJVN3Ou3jvbPVRCbX/f3isZtCtowRmHfxyswjbeYs1MTHLAfo3KJWx97MxtNsr9MdjdmfsXQyHFbbmKM6b3kmPvHalibIJoQBUbzE+OZTQyjKQzE1UZ8u24NeItZBpWmoXP1rZQU6WhoMrtS7uRVy1Bv46pkHoZAaYKI6u11ibwwoaUfLqHuDmDwOlnbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0piNMHbPRHz2tA4mZUV2Fet5WHFOTUIUdxfjvlIt6G4=;
 b=sLQOZdeSewwXHrl2/bFMLVMXSY9TNwluzVjPMp5kp15b8PpkMEdv3Nwd1S408E3lw8R5tp/EvmFqWKiF50SyyjuJ/LSWTxFl0A+jd8faTvcVU+JIiLolfbToEBdREfXzrKxSyfRVlTphPU49ERlcyyJqSG0OrmfzG8Y2TDP9AC0=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS1PR04MB9309.eurprd04.prod.outlook.com (2603:10a6:20b:4df::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Thu, 27 Oct
 2022 22:58:33 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::6710:c5fd:bc88:2035]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::6710:c5fd:bc88:2035%6]) with mapi id 15.20.5746.028; Thu, 27 Oct 2022
 22:58:33 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ido Schimmel <idosch@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "ivecera@redhat.com" <ivecera@redhat.com>,
        "roopa@nvidia.com" <roopa@nvidia.com>,
        "razor@blackwall.org" <razor@blackwall.org>,
        "netdev@kapio-technology.com" <netdev@kapio-technology.com>,
        "mlxsw@nvidia.com" <mlxsw@nvidia.com>
Subject: Re: [RFC PATCH net-next 01/16] bridge: Add MAC Authentication Bypass
 (MAB) support
Thread-Topic: [RFC PATCH net-next 01/16] bridge: Add MAC Authentication Bypass
 (MAB) support
Thread-Index: AQHY6Fiv4pbmyN8AOUGZ8n7qeLkzjq4i3pQA
Date:   Thu, 27 Oct 2022 22:58:32 +0000
Message-ID: <20221027225832.2yg4ljivjymuj353@skbuf>
References: <20221025100024.1287157-1-idosch@nvidia.com>
 <20221025100024.1287157-2-idosch@nvidia.com>
In-Reply-To: <20221025100024.1287157-2-idosch@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AS1PR04MB9309:EE_
x-ms-office365-filtering-correlation-id: f19305a5-e975-494f-a263-08dab86ec5ca
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X0Jp4mFuW7V5wiLzDPOrtpciHhW+CzWFGzGce7xgWn9oYvqWCDKWoUy5H/YzhhjpXnTbjvYs05j2nXgtSzYGvbK7JVYzYsAVWaBjlXinqNLM8xRLut9LnHfIUeOkBzFHBSlSlVH+B7S4+kgpKX3/4v8CloALfQJ53Y/njEbPshapiaLIb4OzN/A0+uNKvzky7zzhhOjN18HtObnV9MmsK5Dy7MPqizRSLVAryfN9pqToYp9bO5+51nV/wBAXsWBUvrNKRGlE/CUAMldylNuvorfnvrg3qdsCK637XHjOoGBNoSQ7coUmn4DMlxsRzFZj0gVpm+GjSyctS2Gl1YCvyZnZyChSYD0B1jxM6S2TG/8Vabj1cJ9TW7nBOTVb6t62f6ooNV1/iWZ62uhXadzcyFmsnknH7YimsESwdzkg9BQFm4P9JaYAOQzuTElQWUaMTgcFQFmWFLU4SJcwjPu7LPlzkXt4ZnnGS4icsC57XOb6KywLqXwEu5gkheGHFS4RCXYtavoAMyhBW4xRDJJpZS6iSwYQ525MLxPmNIzEej8X/s8rgjnsPxM6k2zNeZraBDIGlstTC24ztINIXzt7lYWWUdIoAAsYlekhakIw6PIBFN+Oc3RoiHcoaVtbIJyQDexZ4nO1SC8F9AYvii2Y9pY5WMNnZscybhDU+BlkWwHgcRXx9vA1XqYxU1DMJA6xqj+mau8RM05lqe1fdNYdf4XVueJJcOA8OXOjcxYGJxJYfPXndYK99HaGgsroGFifC5fLDeVUSPrUDd7gUOpGpA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(366004)(136003)(346002)(396003)(39860400002)(376002)(451199015)(5660300002)(1076003)(76116006)(26005)(186003)(38070700005)(38100700002)(44832011)(33716001)(7416002)(83380400001)(86362001)(8936002)(71200400001)(478600001)(8676002)(91956017)(54906003)(64756008)(6916009)(316002)(41300700001)(66946007)(6512007)(4326008)(6506007)(66556008)(9686003)(2906002)(122000001)(66476007)(66446008)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/wmhRNqgClzvgsWwyjZwHWRcRua6whoMsVqg/uy66qGRVNtNHTv8qPAwGc1I?=
 =?us-ascii?Q?+/UMIvOhniLFIurfQF6EgdgoC0mAq0SyZzpOWoGaejc3y1rNNVDKGj4Ukol5?=
 =?us-ascii?Q?6PUvjCn2nk31LMP260FyQ6bjLHCRHalUDh8Y/6OA7EzURWqkRN2znpMsUAh9?=
 =?us-ascii?Q?Rv+lo4YSRD3X4QUc5+IIPx1NVBxP6my+mKfEkfZ3wQHCVuevKT5qmBcj9wf6?=
 =?us-ascii?Q?ibHzWBNEKPmKrIg5GwunHnDtD+P7+muLJkjJ+1iz1WZoHCUW8ITi989OFCPv?=
 =?us-ascii?Q?Nos5CCl68+6xKazrso6+7T6Aam6lxmKT/pn9AFnkD/gH0Fbd1243hBvDgZfp?=
 =?us-ascii?Q?O3XRYF3AzY1nrxyVNTbia7LzT/QDH2m5rZss24uaCGJP3HBS+3zD7YktKU1H?=
 =?us-ascii?Q?hAdLhoxLxXVtcTlhzU0/nkuXAKK2BwJ7K1lHjdgBDbmdBb/kGkBiTGaCafx9?=
 =?us-ascii?Q?FHCChAU+gepK5CXfDNYVIyNeh6FyhslPA+2QuNtmspPVJD6e9o79LTbDLhBU?=
 =?us-ascii?Q?vccUcfO/pUtKeUlOl/fh1y6b0k/pJlCnLZ3d0s8oFW4c8FXF3pWWmnpFJPsO?=
 =?us-ascii?Q?0o3ZF1FZ4wtapBLLBVnkkDFcbByS2acx10swdGBZKKbQ7DeTAGebseG8vppt?=
 =?us-ascii?Q?YHfyq97bI/Fpmt08/2MmwiRL94q4s7Ohx1++hVBQUgCFL16uFyb3A2sSKAxb?=
 =?us-ascii?Q?JgyqKNTslZxDvkXFZWQFCfNXt7YYAqD0eGLCuGKBTHUrLbV+cTTmO821cxMr?=
 =?us-ascii?Q?Vt073LZ8PfBThpmMX+CbQf3mD9Qf96zsC5Bk+nTF6DmDJogebI3hXo77juBM?=
 =?us-ascii?Q?4F5q8qrCmQJmoM2NBVKN3z9oFQ7wn8R98x+skBgR2evzUo+hwB3QLXRCaBuH?=
 =?us-ascii?Q?YmLuvZkcdmmLor+zNtbNN44phKirZbI7Sb0bbcJwJ2p7lwb0MZqlxI/O5wZg?=
 =?us-ascii?Q?26Av+83H4jvStiHcVrRUyAUnV3fTo2AOaLxQP4IEXs1c1qB0nlAb/kjgkeTM?=
 =?us-ascii?Q?ZydXZEaMVHvO+suh6IJ4bUprkmMn3PCI5n39yxTEv6S86atudII69SHYDxSw?=
 =?us-ascii?Q?ETbi0/eq7LgGCEYGTz5IEyxffZEguEgG2Pjq2Og8CUXdGglJmLTHoUPLMYSl?=
 =?us-ascii?Q?W3BkAUhr4yqp0e4Qb6gjHcrLj1uSQDzKb9T83gY5qh21571YKHm16Kqowpxw?=
 =?us-ascii?Q?GcEK9zX9UEMK0YdPqknse9ziLmsDaQTjxBR7ay/+Q4llu4aMhtxhxHzpm5If?=
 =?us-ascii?Q?XKyd4pb/u1QUA6ppIkWuvfyibsyREbHW5IPiSMjLaQdGHUIaY2EsZIOXp20j?=
 =?us-ascii?Q?UvfylxWDFc6nd5g6OiQnvUFxU5R9myVhAe/F6347xfGBymWi3yhJrOppWDpn?=
 =?us-ascii?Q?fV4+Jf4+D+wIIQs73DuNGDhSTkYH6/dVStLcY9S++GKhiMlNm1BYtEk6gR3Y?=
 =?us-ascii?Q?YTXXC3ymr6dBmaTIRBpMChH/GJ1nmtDu2OSV13iivz8C7E7FxgyqmCXnn6+J?=
 =?us-ascii?Q?e/x0q8th5VgdsSmFvPb7QTPXOFscrBuUKrMhvPvlrRePEN9AIRBRqbHpIwCZ?=
 =?us-ascii?Q?n87P48avfhPv4aGoHYdxDEaAEdSKgqZAAA2LQaLtpzs3zNuq8rXVCJRvMyuz?=
 =?us-ascii?Q?kg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8F78154D6E27BF4D8179E9E08ED9D297@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f19305a5-e975-494f-a263-08dab86ec5ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2022 22:58:33.0494
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jO0H7AV7/ar5T5clo5LoOieriogl6L3lEjmbcXix/R4KphbOCoguGMt5LRB1F8I5/hezYrMXaBRXhfNDZvgROw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR04MB9309
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ido,

Thanks for the commit message. It is very good.

On Tue, Oct 25, 2022 at 01:00:09PM +0300, Ido Schimmel wrote:
> From: "Hans J. Schultz" <netdev@kapio-technology.com>
>=20
> Hosts that support 802.1X authentication are able to authenticate
> themselves by exchanging EAPOL frames with an authenticator (Ethernet
> bridge, in this case) and an authentication server. Access to the
> network is only granted by the authenticator to successfully
> authenticated hosts.
>=20
> The above is implemented in the bridge using the "locked" bridge port
> option. When enabled, link-local frames (e.g., EAPOL) can be locally
> received by the bridge, but all other frames are dropped unless the host
> is authenticated. That is, unless the user space control plane installed
> an FDB entry according to which the source address of the frame is
> located behind the locked ingress port. The entry can be dynamic, in
> which case learning needs to be enabled so that the entry will be
> refreshed by incoming traffic.
>=20
> There are deployments in which not all the devices connected to the
> authenticator (the bridge) support 802.1X. Such devices can include
> printers and cameras. One option to support such deployments is to
> unlock the bridge ports connecting these devices, but a slightly more
> secure option is to use MAB. When MAB is enabled, the MAC address of the
> connected device is used as the user name and password for the
> authentication.
>=20
> For MAB to work, the user space control plane needs to be notified about
> MAC addresses that are trying to gain access so that they will be
> compared against an allow list. This can be implemented via the regular
> learning process with the following differences:
>=20
> 1. Learned FDB entries are installed with a new "locked" flag indicating
>    that the entry cannot be used to authenticate the device. The flag
>    cannot be set by user space, but user space can clear the flag by
>    replacing the entry, thereby authenticating the device.
>=20
> 2. FDB entries cannot roam to locked ports to prevent unauthenticated
>    devices from disrupting traffic destined to already authenticated
>    devices.

The behavior described in (2) has nothing to do with locked FDB entries
or MAB (what is described in this paragraph), it applies to all of them,
no? The code was already there:

	if (p->flags & BR_PORT_LOCKED)
		if (!fdb_src || READ_ONCE(fdb_src->dst) !=3D p ||
		    test_bit(BR_FDB_LOCAL, &fdb_src->flags))
			goto drop;

I think you mean to say: the above already holds true, but the relevant
implication here is that locked FDB entries will not be created if the
MAC address is present in the FDB on any other port?

I think some part of this comment should also go to the convoluted
BR_PORT_LOCKED block from br_handle_frame_finish()?

I was going to ask if we should bother to add code to prohibit packets
from being forwarded to an FDB entry that was learned as LOCKED, since
that FDB entry is more of a "ghost" and not something fully committed?

But with the "never roam to locked port" policy, I don't think there is
any practical risk that the extra code would mitigate. Assume that a
"snooper" wants to get the traffic destined for a MAC DA X, so it creates
a LOCKED FDB entry. It has to time itself just right, 5 minutes after
the station it wants to intercept has gone silent (or before the station
said anything). Anyone thinking it's talking to X now talks to the snooper.
But this attack vector is bounded in time. As long as X says anything,
the LOCKED FDB entry moves towards X, and the LOCKED flag gets cleared.

>=20
> Enable this behavior using a new bridge port option called "mab". It can
> only be enabled on a bridge port that is both locked and has learning
> enabled. A new option is added because there are pure 802.1X deployments
> that are not interested in notifications about "locked" FDB entries.
>=20
> Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>=20
> Notes:
>     Changes made by me:
>    =20
>      * Reword commit message.
>      * Reword comment regarding 'NTF_EXT_LOCKED'.
>      * Use extack in br_fdb_add().
>      * Forbid MAB when learning is disabled.

Forbidding MAB when learning is disabled makes sense to me, since it
means accepting that MAB is a form of learning (as the implementation
also shows; all other callers of br_fdb_update() are guarded by a
port learning check). I believe this will also make life easier with
offloading drivers. Thanks.

>  include/linux/if_bridge.h      |  1 +
>  include/uapi/linux/if_link.h   |  1 +
>  include/uapi/linux/neighbour.h |  8 +++++++-
>  net/bridge/br_fdb.c            | 24 ++++++++++++++++++++++++
>  net/bridge/br_input.c          | 15 +++++++++++++--
>  net/bridge/br_netlink.c        | 13 ++++++++++++-
>  net/bridge/br_private.h        |  3 ++-
>  net/core/rtnetlink.c           |  5 +++++
>  8 files changed, 65 insertions(+), 5 deletions(-)
>=20
> diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
> index d62ef428e3aa..1668ac4d7adc 100644
> --- a/include/linux/if_bridge.h
> +++ b/include/linux/if_bridge.h
> @@ -59,6 +59,7 @@ struct br_ip_list {
>  #define BR_MRP_LOST_IN_CONT	BIT(19)
>  #define BR_TX_FWD_OFFLOAD	BIT(20)
>  #define BR_PORT_LOCKED		BIT(21)
> +#define BR_PORT_MAB		BIT(22)

Question about unsetting BR_PORT_MAB using IFLA_BRPORT_MAB: should this
operation flush BR_FDB_LOCKED entries on the port?

> diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
> index 68b3e850bcb9..068fced7693c 100644
> --- a/net/bridge/br_input.c
> +++ b/net/bridge/br_input.c
> @@ -109,9 +109,20 @@ int br_handle_frame_finish(struct net *net, struct s=
ock *sk, struct sk_buff *skb
>  		struct net_bridge_fdb_entry *fdb_src =3D
>  			br_fdb_find_rcu(br, eth_hdr(skb)->h_source, vid);
> =20
> -		if (!fdb_src || READ_ONCE(fdb_src->dst) !=3D p ||
> -		    test_bit(BR_FDB_LOCAL, &fdb_src->flags))
> +		if (!fdb_src) {
> +			unsigned long flags =3D 0;
> +
> +			if (p->flags & BR_PORT_MAB) {
> +				__set_bit(BR_FDB_LOCKED, &flags);
> +				br_fdb_update(br, p, eth_hdr(skb)->h_source,
> +					      vid, flags);
> +			}
>  			goto drop;
> +		} else if (READ_ONCE(fdb_src->dst) !=3D p ||
> +			   test_bit(BR_FDB_LOCAL, &fdb_src->flags) ||
> +			   test_bit(BR_FDB_LOCKED, &fdb_src->flags)) {

Minor nitpick: shouldn't br_fdb_update() also be called when the packet
matched on a BR_FDB_LOCKED entry on port p, so as to refresh it, if the
station is persistent? Currently I believe the FDB entry will expire
within 5 minutes of the first packet, regardless of subsequent traffic.

> +			goto drop;
> +		}
>  	}
> =20
>  	nbp_switchdev_frame_mark(p, skb);=
