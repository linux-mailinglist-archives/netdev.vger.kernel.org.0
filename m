Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5D265017D7
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 18:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243420AbiDNPu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 11:50:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355930AbiDNPlI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 11:41:08 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70055.outbound.protection.outlook.com [40.107.7.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD02FE098A;
        Thu, 14 Apr 2022 08:22:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GQT1tLvKPEBEVHECas5zqGjrH5UAPtHo+BDVWJr+GzWBe5eXLRLFU8+TpB52s973aOb8ghEmpi/HcDXVdMZ9+MymkgDEFc7Np03TYQwOHOLGwXoaeaUFLcr33DENJAysN/DOyTnTEmpR+aaAX9mY71yEB5hNqWZv6R1lj7cm6P0OOW8DN8ljcKxxFl5NyPA6HbNaBc7yac+G3KoySqVhGNe2SpUxyBCefdJv1vcjzi77TdkjRyWV3E/VVKbQlTeT0irwf5abWjkIeI3rpSCacP9wyui4V2RfXzKP53cCtT4ewiiNyMTogFzHIbHoEUX1eFegYavIDditcbiJaMul5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9XbLDYmSh4qOxLeudAAaaO/lS02BRDFCF9vBDmsGR2Y=;
 b=OAxsPEPgdgM99sJdUqUZcu/twfdrrBLnZcVixdgih0/CjRfmrm6DuaLCv47H7MqwzsDZcfAS2FG6sNGxXJJNGo3AsWmJSu0ny0lLrCT1efZXGNeiR7/kZPFYm7DqeWnyBiX42wzY2ubNrHFCAMx1mCi2al/T0QKDw07jWFm5HGsD9yi9SmgBlBh/p0abW8PCC3q4EgM3PKViMvXY1InfJYr+TlGFO/QNWHcbmbZyOBbBAJhspdxRCrqKiFaoTBk5s2U5qYdczQLiGMbpbB22peBx4T2hBoAg9tMc/tT4jZ9MR5y1ToOcboADquhImSlzvSBHzgK4pD28l+1/slO2Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9XbLDYmSh4qOxLeudAAaaO/lS02BRDFCF9vBDmsGR2Y=;
 b=i3Xa6y4PXROASOi2Ugl/XDsE/At/X5cGia+RM+a/1grW5PjPB8jl3qBIqsKXKek4Uu01F1lOivsVgAi9MLwT1gDB87lGKFwMI/wcH78xgJrfZcrXVaMTErNH+UGz5cPYWV++JC5D08ioMwB4+J6hKDr75UiQIlDW4vZO82K1XHo=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBAPR04MB7256.eurprd04.prod.outlook.com (2603:10a6:10:1a3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 14 Apr
 2022 15:22:12 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5144.029; Thu, 14 Apr 2022
 15:22:12 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
CC:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next v2] docs: net: dsa: describe issues with checksum
 offload
Thread-Topic: [PATCH net-next v2] docs: net: dsa: describe issues with
 checksum offload
Thread-Index: AQHYTfheCzBrufjauEu7NwJglkZ/ZKzuSJmAgACtXwCAAJTqgA==
Date:   Thu, 14 Apr 2022 15:22:12 +0000
Message-ID: <20220414152211.txmb3peuxs4rt4pw@skbuf>
References: <20220411230305.28951-1-luizluca@gmail.com>
 <20220413200841.4nmnv2qgapqhfnx3@skbuf> <87tuawp493.fsf@kurt>
In-Reply-To: <87tuawp493.fsf@kurt>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 481774ef-615a-4565-a22b-08da1e2a8c9a
x-ms-traffictypediagnostic: DBAPR04MB7256:EE_
x-microsoft-antispam-prvs: <DBAPR04MB72562CCA06A0C2008596F90CE0EF9@DBAPR04MB7256.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RBFNIIvG93PXwep2mQUKlLWnMmPweuCZqjmTOE4S6x/jh9R+wwaKz3rmULRSj1VdRcCF8B5RLfwmDUU+g4bdWETqprP6FuFl2xEYF7s8fETeSWUwFy0CF8iB39n3Rf7wRomGVcXOgjCyxpW4dSnGKYafgfKhdDGCm66NmiO7fn4ZoOnWcFbd6/Zx3+EAX4sRXSLPEgjOD8tuLAYEAK/mhpCMJQV/IflcdW1BpvahF8PPnTpL1dHeiLeVGEue5Ng1edYxh6ZSBSrwKo33Y4GW9tkj+mKHqqNahUp8DDVFiT6fEN96ssJKJsuA2rSfp7WZAnbUu94KLDJxQZtKCVkSIbCLNKdHHmjPFeAAtcuEjJM1uviauuiZCyJQ1Bxi0/K3tI/Tk7ag5YV4se/i0nb0eXFS7thoaPZUoMcrCv5R9gvt0sdP59ZCTMyS8easgFDF6CXrW+YavVvhBha/UitYyt5eEt58zhua6YC6qJkUMmFItJ4k+0Zio20u0T1FMxjsdJ3UW/yWy61Nsc7vqq5ZRjMYxcVT6fTQSsn8Hztc2/Nap6y5CrvQb9fWupsa9P0v6jG5OqsnkC9gXCuYhdPbDdKo9VcFOMQvU+/0AD1IqYK0VExFbKqxiogAobA8pVfYXetU//AsAL/QPBV+C0HNzCp1eDltVQqy9Uun3gqAPmrt8KHsZffvVXUxWHW7hc15FYlQLEUT5vLu5cy4GEVtxw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(8676002)(4326008)(5660300002)(122000001)(86362001)(2906002)(7416002)(38100700002)(38070700005)(8936002)(54906003)(44832011)(186003)(6506007)(1076003)(6512007)(9686003)(508600001)(6916009)(316002)(71200400001)(26005)(6486002)(66446008)(66556008)(76116006)(66946007)(66476007)(91956017)(33716001)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?dShr1OM3d3YKADTvHanBez9v1OX/YQDU4qje/G8qfTQTu/BAGIIdQqEKMtsY?=
 =?us-ascii?Q?SOPS69zaYlUQq7J79aT6FnavuJ+8g/Ogf7lWIo4nIurosQcoVHBiOBgiqDFD?=
 =?us-ascii?Q?Gc2Ip0GeK2Au2RZgsLCYMLNh6wUAg2FWZtdiZZayWgE+G1HDlmfN1/6iEpnC?=
 =?us-ascii?Q?AOesupa1cLvTYknFv5WbaAPqrcMOUnF9OYtooHgax+3HSUwWfzlclvL00lXm?=
 =?us-ascii?Q?ubFCYjlIS3ZWcQ7Xxh3V/Q66iHL1/GAEu1CXb+S0zb/23euCzK93JMJqoEtK?=
 =?us-ascii?Q?WcdySURuBWs7BrGj070Ry3vyQ8p6K8lLP/xAi1mmUJAadqX//DtQnvBpJTky?=
 =?us-ascii?Q?tc61Acxwtmv5qvTVu4j8Kx10zxGK1kdLmV8YbbQL+YBXK6U5eHBxqUKchjD+?=
 =?us-ascii?Q?DuKwKo6gYNvP5cZAv+eIz8kqqa6aiRpoaUhopVFzfFKHy2vfmZeuBI0Ytzxt?=
 =?us-ascii?Q?7iz1u6uk8PDQgH+5PNgvmvaJfHnVRovv6JAIMCBLrUeygR0AM9mpS7aIu1Wa?=
 =?us-ascii?Q?4eSFisSul52Q467kxc9t0tb+Sabemx+7wLr9g6xvk977zc+pQfbFSc8Dlasp?=
 =?us-ascii?Q?CX7pnSbCbpX5T5PwLzMGi788QPuo/IMw3LdomiHB/kuTuT+LNVE0DJllcUbX?=
 =?us-ascii?Q?dBB0dFef5BTVYMVV9HbxBdaWbFDD5g+/QoH38fAyQSaVj1KkAlj7Sk23qGo+?=
 =?us-ascii?Q?bzIXtZW3/jLjA+fRtx1J6YXbSiRqUaCkL+vF7PVmr9cg/786kScM3t5Rhzgf?=
 =?us-ascii?Q?58a1LvL3uRmIvVf7nd8d9qUz5Emy2LbJAKhL1A6Z2nH38/W6ACambS06x/Us?=
 =?us-ascii?Q?XeGRFsDggsxBefNJkBj0WvlWkKwb8o5B8TOmSwXv43LMPF58sLojuQklVd3H?=
 =?us-ascii?Q?qq7Q6QazsNR6GrrEyYaaF5cqNIxvkPAW2bg12iINWmpNx2ialrGU8G+S2SoD?=
 =?us-ascii?Q?fuNfJL3dWNi+zQ6WMWMGaZ41NyP+cuVpRROJdU/rYHb0onNxEzQy+PAMoYFM?=
 =?us-ascii?Q?a7dAjsb+Bt8wrrqQHJMMijOVIEh/3Bo/wjP8JMV73/U/es6mtv1z3X9rOf60?=
 =?us-ascii?Q?4KNm+wdld1CeGnXvYwUrruC3F7fOSbT3ohNTNozGA4MUOmGlqZHSTID5nx7P?=
 =?us-ascii?Q?ZxePx3LQtSOdVt+UXciIMRFZTzAEaJ+krnh+vfWxWocYjhM91Nu8qGsgxk6q?=
 =?us-ascii?Q?ynoBkXCfgBimMleQ7kHCiASZ08+EDrdRcef/EOtzl0SWVzfn0A+/8Ro9MWIL?=
 =?us-ascii?Q?dDmq0MsFRaD4yWUxnEc5bj4r9sakXJqTynncqStBJtpU2Hr/bGGSBWJVg1qI?=
 =?us-ascii?Q?Gwf/PxERe3+6fvjsJ56e/LQY7IMxCp2wu58ja7A2Yqsgp2O1DLZFhSlYJOPo?=
 =?us-ascii?Q?zbOPhpEI8GvstLeYRJRj+/R7eP2SF934Slug/Q27jnGfaY+r6ZAjJTS7e3Du?=
 =?us-ascii?Q?XI5KLcEY7x2IHzjHlxqjwO1wlGUQ3JHurd0PkEiXmaUhYcvSyDbxa47yCHtq?=
 =?us-ascii?Q?+hrHX/dwKN/kXC/V3kHwPmJsWmHWX1zml8X/aUR4EBWgx1ndcOX5qFbVyHGF?=
 =?us-ascii?Q?/5NxYw4O+NlHyGlNpAmZyZ2PinhcwLMDF22mE+DuncSsG5LGEEMQQj/jSXwU?=
 =?us-ascii?Q?fQm44o43phnkUSdCiU97TXP3KzP8ckGqJDZPEt7ekHaDwnpWMdvVonSZrC3f?=
 =?us-ascii?Q?dNSZJbHok3RckiAY0spdXT4cEQ2GnXHd6Q6ZtaVUkwRbhzDIvhXGOIYZoj7w?=
 =?us-ascii?Q?pnww46LwNGKlro4mOOC+nPDDJODlcn0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <25012289B008954A8D0B03E1018543F0@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 481774ef-615a-4565-a22b-08da1e2a8c9a
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2022 15:22:12.2281
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dz9bMg1NYwFLnGZmukIXAsDOXoJGp+gmmPfSOeObXzY6DoCbFN5d1olnRF2h4/Sx1UaEp+jbbridKF5T/rvmIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7256
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 14, 2022 at 08:29:12AM +0200, Kurt Kanzenbach wrote:
> On Wed Apr 13 2022, Vladimir Oltean wrote:
> > I've copied a bunch of new people to this email.
> >
> > TL;DR: Kurt/George/Andrew, on your systems with hellcreek/xrs700x/mv88e=
6060,
> > does the DSA master declare any of the following features as "on"?
> >
> > ethtool -k eth0 | grep tx-checksum-ip
>=20
> It's a Cyclone V with stmmac as master:
>=20
> |root@tsn:~# ethtool -k eth0 | grep tx-checksum-ip
> |        tx-checksum-ipv4: on
> |        tx-checksum-ip-generic: off [fixed]
> |        tx-checksum-ipv6: on
>=20
> >
> > I would expect not. Otherwise, we've either found a bug, or discovered
> > the Sasquatch.
>=20
> Now, I'm wondering how this actually works. Anyway, I'll send a patch to
> add the missing skb_checksum_help().
>=20
> Thanks,
> Kurt

Thanks, Kurt.

It works because stmmac declares NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM in
ndev->hw_features but not in ndev->vlan_features. Whereas DSA inherits
what it inherits from ndev->vlan_features.

It's good to fix this in hellcreek anyway.=
