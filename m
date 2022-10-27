Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5141C610661
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 01:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235164AbiJ0X16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 19:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234552AbiJ0X14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 19:27:56 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2086.outbound.protection.outlook.com [40.107.20.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B6DA345C
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 16:27:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y8111vCxrAWflxH1ZfXmWlPMX0KFLsOPdpzS99CvOm85WWUNJPO24jOZxUx1bc3TfJPu7ZQd69klLbcFbpUzXMcTWkJWFtZUCd/+xMECBJjixvCx1pUGqlgAVWnzVx+ls08tNLAbnNSeV/CtijCJwn3cJfquERQ8d8dXMFN37jUR9lcbxHpx4PLPuHhgcrbyfRwrb02fpWYypRY3K0dOxw+fT4lflKlpK/jrNa2R/ySc2SoR7Niurf2kpkBxeT4Oo1EqqvZI3nN3wGMKmbRe4OVvyU8PmZw0dy103OQ/RWdvIOTt5tQB4gmXHQKIMa6jz5ph4pYoGvhHi/B9FbMMzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/FLHkdMq7pEvkj2fUEtN1bupHXbyWuGn9/sFQ5VEpi0=;
 b=OWDO6MRt5IuDuEL+EHAgnBUQ/ri8Jrs5H8StodAYLs7/ACgn5Q3cf0RNkFBEQ7sIZgyE4/wPff9uYHKNMFZg8MUW80gF4h1xt+8ogMy/QQdYyXWCFyAxDiryjcELXKePD3KX0kkfOTvRl/kgQnbr/0/glsjhDeLc0y5VClQfwNXd1j5XzUfvY4zM7aJSSNv9zMa1901cCbpda2HI+4GDBhGsnMNvyoA5MYzSTm0KHkKlzsHDgHHyzo0SRo0XUJTqLZNMEw/YMjx+rw+ReeDjMfiBmxprqSy1rNmKl7CCd423+7TWkngV6iO7ejHULSpQNCvsz6DVaXG/iO4Ayx+0Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/FLHkdMq7pEvkj2fUEtN1bupHXbyWuGn9/sFQ5VEpi0=;
 b=ARWO3tFzNynp9L6HqTy4Cce9qrJKBjwrawVi45utpgtX6/z5ClWOHQtqMKd2u/X0i5DReMapXji7Uwn49GfdkgFBoIhI8iRgpKmYRwesojWZItU2nTfcR68IeJGQ15UZq7e7tPZpjjfYC7+TbgYr3wg7wIpFPMYDzoM5+04sjFQ=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8822.eurprd04.prod.outlook.com (2603:10a6:10:2e1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Thu, 27 Oct
 2022 23:27:49 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::6710:c5fd:bc88:2035]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::6710:c5fd:bc88:2035%6]) with mapi id 15.20.5746.028; Thu, 27 Oct 2022
 23:27:48 +0000
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
Subject: Re: [RFC PATCH net-next 04/16] bridge: switchdev: Allow device
 drivers to install locked FDB entries
Thread-Topic: [RFC PATCH net-next 04/16] bridge: switchdev: Allow device
 drivers to install locked FDB entries
Thread-Index: AQHY6Fi6+swc7TuV1ESeb+jvW3Ya2A==
Date:   Thu, 27 Oct 2022 23:27:48 +0000
Message-ID: <20221027232748.cpvpw53pcx7dx2mp@skbuf>
References: <20221025100024.1287157-1-idosch@nvidia.com>
 <20221025100024.1287157-1-idosch@nvidia.com>
 <20221025100024.1287157-5-idosch@nvidia.com>
 <20221025100024.1287157-5-idosch@nvidia.com>
In-Reply-To: <20221025100024.1287157-5-idosch@nvidia.com>
 <20221025100024.1287157-5-idosch@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|DU2PR04MB8822:EE_
x-ms-office365-filtering-correlation-id: 2a96cd59-08e4-4ac1-b7f3-08dab872dc56
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P7RedaE2BZhHgsVeRntPyXqQDsYMDzldRoTJYJDAGznJAjsIhFz7LDaJD1OwM5GV0lPxKep7t7+QnTilUupqui46PizZ9tdyf/wuNR5DchrYVVLQhhgHys9pTIey4yeXkcpjGk4WP/g7sEGBisvqOT91Nd3KFLpHNCn85chyzzTK9EbVstMmhPZtQoMhTKpip8paeBomnMBwywuaA2XBS59iH45wJL4agu4SxCqrI2xx6X/oSdwhfbtaBLJWozNCw2pyh56GAp5WQEKKE35+wEtmDNCJ4K8k3ZlCNbdOFahtF14l3QxGH4wTKb9vAwgDt9LsWZB7y14uTP7yeYLn81V+MtVfvvXqblDzvv4S4IpM53iLaDqCo31irYc+fCherbpPnBFYmHIDpS5Z1qHwZ2DxEF7qUbAij7EKexlTnwrDC8N+1ecffkP1kZ1Mlf54I3V3u5IFTawm6H2b0vZrFRszlbhUN/xnxAIJYkxADdyyKrYqqRumnK4R3ShSh8wKwXZvo1MmWjMtboAIEkiQ031KsZKILZtuluZYVmLygImuSs0yw+Xos/f3vJZ7SZe/5S6uOXDwagL/k/3IbweCwllTduwL3FpmA3Dxpz3CfaJCyGsxrrUpv4/VzssS7QOc399hzryrEC4jCaWk0v8GUjDFz7/bxl0Z4rqriPstb1/nPUOl4DRn3FY0GAvdBpPpGppAfGT4XDIcJEb3oPNGOmkXfpvMNK8Zl4LEIAhLadBvepU8agxzfkPbNp13Xou5ayaMyrY1lAhmOUw2Yx44PQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(39860400002)(396003)(346002)(366004)(376002)(136003)(451199015)(71200400001)(83380400001)(478600001)(6486002)(66946007)(6512007)(5660300002)(8936002)(91956017)(64756008)(66556008)(4326008)(66476007)(66446008)(54906003)(44832011)(7416002)(186003)(8676002)(2906002)(6506007)(9686003)(316002)(1076003)(6916009)(41300700001)(38100700002)(26005)(86362001)(76116006)(38070700005)(33716001)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lTG4cUoMgcy14X35RH/amOFTn7tIfxDegYaC4THsU2FZbNY62Qu7bC0+8Dbz?=
 =?us-ascii?Q?spUF8diI+wvAmsYYwJbIA9zqdFPcnuvh11AZBGt1BJ8hHQ1kRPN+qvBES0gl?=
 =?us-ascii?Q?nqT8uCH47wJxbawooAvmLBiN6pyaDoVBTmkF8WqTuQzh5FBtlS0Z4/NLB6PE?=
 =?us-ascii?Q?yC73xxFmTRAmI475sDGPORz2Hl4FpX6d+lAonjo+ZTeYrnbLQVDqv37zihFz?=
 =?us-ascii?Q?59zvXm8SFdETDRD8R3dOBci+W0GBGNo5vMi9Jk40gvPIMPE+JnxPWTfRnWwH?=
 =?us-ascii?Q?qe9CTESDqyMfJGxHkosFHKJkwIEhTbURdfET/2PLM1G+V3khx8Vu3alwEyJX?=
 =?us-ascii?Q?RNGj7p9MmkFCnvBAw9oNYzCdt+cZRU/BM0J99HSV3Y/92jNwx/a4I19lbAlh?=
 =?us-ascii?Q?6AFuYmVpbj80ssnqTtATPzrrDtuAf9z56+y+ImoEbH+jl6WfM02CHnlz8dWt?=
 =?us-ascii?Q?Srnzs+eEa43PThkl82oUh1M5Hv9Ni+GVE+iqyoMOxEDDqic0SSmXa08yBOoq?=
 =?us-ascii?Q?aPeOS7JSVd9MDRXQ8JyoC7A7EX8naOm2YyuoxM4lC4Ho3phjkC8gFrY2gatD?=
 =?us-ascii?Q?gEcJDaTfykon/D/KcV+/2GnXcU1DDQkcLA2oG1Q6UBpGLNaoIqBo+v7e9skU?=
 =?us-ascii?Q?TE882Dbo4XurI1zhg87DKhZRILKD1jOvdREpSBIGNZp8I3vYcmFs1+LgLcvr?=
 =?us-ascii?Q?5hHTALS0MO9BN309eVAd+yNmDeST4FrLTrUAwhLJL/8p4Jg+4j8QqtP23/1V?=
 =?us-ascii?Q?atcnu0E1qJT1uzNnGZJdwz8AwrV3Uz0rFxciWwbBs2qBU3f1/AthAN3Y9qze?=
 =?us-ascii?Q?WKWJrXb7js7OhmqeWr0vC246Bcb5gtuBYx1LKanZQqyGnxqtbnaHN71m+e8V?=
 =?us-ascii?Q?dySkVlIDUDFTmdGNxI/pFFj1hbDP8Ec8TLb6JGsEd1j+87HU8V+K6+RwaPV8?=
 =?us-ascii?Q?gfY2ba5qMPnqSpw4XauUQmi0L4F1Rz1TP60xN71gN6Ew4Qg+qe4XmpuaKWsw?=
 =?us-ascii?Q?b6yzxloGoKtQYDK1sagSkFjo3p6ldIrpw7F2WpPcoOjwJZSpxQI8zR688lkt?=
 =?us-ascii?Q?JAFa9EYmrXkfFQH4dFX0KvjGwnS9YCIXwAeyJ/JjAKUy/KK4UyhObxNNQEgT?=
 =?us-ascii?Q?w4a5wCuVQAiRnHrTobIwgw1g+4NsM9faUD18CWYCMa3z4+sunoUBBflXpF05?=
 =?us-ascii?Q?wNYGnGC61ip82UM2wRQGTOtYoqvN8e0g2PpQl6Ek5l9/i2FdoCu99VuEASiX?=
 =?us-ascii?Q?/UWsrPO/6lQajKeWa+O1iRfOxjM592P3PZ7RbPjsYOtOvMqmv+ngFxh+CqRO?=
 =?us-ascii?Q?HHDJ2jparte0rv9zGQ/tnPq0Q4KljF+zBOqB6v/5mpwtZ4dRdZDCtJvF/1qq?=
 =?us-ascii?Q?IVXd8W7D4FAfFhfSOnZfVKDUWcEk4MjmhOlctqwv6c0q0qoPS4mbxUTg2cyv?=
 =?us-ascii?Q?rHO3XvbqKmgdLtD4qsUsXimHpjazuQ9W8w/sNjHA09Xo1ASdcNVAVvkSf8gF?=
 =?us-ascii?Q?F9AIFNUpISwts+0jhKEbUp/8E4wSf2Ot2t1wJnEzMVkweotQbIcZn3052wAb?=
 =?us-ascii?Q?DsUQkDHBgXjCls8B95mfED7rELpLSmYg7XldFBXV4/3B22jXM9jj/2yC967N?=
 =?us-ascii?Q?8A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F31C387F451F4C458FABECC9FCFCF909@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a96cd59-08e4-4ac1-b7f3-08dab872dc56
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2022 23:27:48.8174
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f7ZulMbwagd2aHC/8Cbtr7BK+dfK33UP+q7B0G8k0NAAKU/53/uuNIngpZU1ZDInm1GLdN+N7Z3XBUv4EbY1DQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8822
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 25, 2022 at 01:00:12PM +0300, Ido Schimmel wrote:
> From: "Hans J. Schultz" <netdev@kapio-technology.com>
>=20
> When the bridge is offloaded to hardware, FDB entries are learned and
> aged-out by the hardware. Some device drivers synchronize the hardware
> and software FDBs by generating switchdev events towards the bridge.
>=20
> When a port is locked, the hardware must not learn autonomously, as
> otherwise any host will blindly gain authorization. Instead, the
> hardware should generate events regarding hosts that are trying to gain
> authorization and their MAC addresses should be notified by the device
> driver as locked FDB entries towards the bridge driver.
>=20
> Allow device drivers to notify the bridge driver about such entries by
> extending the 'switchdev_notifier_fdb_info' structure with the 'locked'
> bit. The bit can only be set by device drivers and not by the bridge
> driver.

What prevents a BR_FDB_LOCKED entry learned by the software bridge in
br_handle_frame_finish() from being notified to switchdev (as non-BR_FDB_LO=
CKED,
since this is what br_switchdev_fdb_notify() currently hardcodes)?

I think it would be good to reinstate some of the checks in
br_switchdev_fdb_notify() like the one removed in commit 2c4eca3ef716
("net: bridge: switchdev: include local flag in FDB notifications"):

	if (test_bit(BR_FDB_LOCKED, &fdb->flags))
		return;

at least until we need something more complex and somebody on the
switchdev chain wants to snoop these addresses for some incredibly odd
reason.

> Prevent a locked entry from being installed if MAB is not enabled on the
> bridge port. By placing this check in the bridge driver we avoid the
> need to reflect the 'BR_PORT_MAB' flag to device drivers.

So how does the device driver know whether to emit the SWITCHDEV_FDB_ADD_TO=
_BRIDGE
or not, if we don't pass the BR_PORT_MAB bit to it?

> If an entry already exists in the bridge driver, reject the locked entry
> if the current entry does not have the "locked" flag set or if it points
> to a different port. The same semantics are implemented in the software
> data path.
>=20
> Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index 4ce8b8e5ae0b..4c4fda930068 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -811,7 +811,7 @@ int br_fdb_sync_static(struct net_bridge *br, struct =
net_bridge_port *p);
>  void br_fdb_unsync_static(struct net_bridge *br, struct net_bridge_port =
*p);
>  int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_p=
ort *p,
>  			      const unsigned char *addr, u16 vid,
> -			      bool swdev_notify);
> +			      bool locked, bool swdev_notify);
>  int br_fdb_external_learn_del(struct net_bridge *br, struct net_bridge_p=
ort *p,
>  			      const unsigned char *addr, u16 vid,
>  			      bool swdev_notify);
> diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
> index 8f3d76c751dd..6afd4f241474 100644
> --- a/net/bridge/br_switchdev.c
> +++ b/net/bridge/br_switchdev.c
> @@ -136,6 +136,7 @@ static void br_switchdev_fdb_populate(struct net_brid=
ge *br,
>  	item->added_by_user =3D test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
>  	item->offloaded =3D test_bit(BR_FDB_OFFLOADED, &fdb->flags);
>  	item->is_local =3D test_bit(BR_FDB_LOCAL, &fdb->flags);
> +	item->locked =3D 0;

0 or false? A matter of preference, I presume. Anyway, this will only be
correct with the extra check mentioned above. Otherwise, a LOCKED entry
may be presented as non-LOCKED to switchdev, with potentially unforeseen
consequences.

>  	item->info.dev =3D (!p || item->is_local) ? br->dev : p->dev;
>  	item->info.ctx =3D ctx;
>  }
> --=20
> 2.37.3
>=
