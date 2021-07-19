Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 928063CD09D
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 11:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235950AbhGSInM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 04:43:12 -0400
Received: from mail-vi1eur05on2079.outbound.protection.outlook.com ([40.107.21.79]:44481
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235651AbhGSInL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 04:43:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b27kuJHmLgG3hdQR/sS3u1yt8RL8dRughCClOZFQ2Qwu9TTJsEgBkaGKPBKOr3JV7yCBV14+XpRKVoVaqIjn7nfKG62FKrKhsAO3LBFdgm4q/V8tmpOA2euCr8FIyQGbTIfthke85YKGIlkutG78Vw0vAQpP4iGtknA49uWYW9oUCqC7cLQPH4YCFRackSYaqqnXAf9YzRzrakWWofuuoUZJXkwt7rtFJCmZiYe99ZOSI8LM2pvQMItgbGUYa8WbCTIwAafQM7XntzI+wOwK2leLPSig4i3J/VnK798i0iZdqAcwxok8HAk4VYR3jEZkbkf+hYgWhb/yIPLlL+6Lig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4LIyvsYtzRhURqLRstFh+fa3PQsRBnRa3uC/qWvQOyM=;
 b=ZRf9cdnlPAnMXXKeGs9EkqCKU834nmJaFUbMGa4/Q7W/l3h66sHFLImOIzDu6Ud1THMwct/Ptenf8VGSzo6mLevgj0OUoSZUJjF7cnt0W7GMHaQZnscOzf2EuuIiPB+BjyHnDTDz5C+PMdzmMSxKTBUHmZ9Wc1fIKBc+kwFCLVu1gOElyqmuv9kzDntL6znLcjo+8/8i9G687PdlEg6p0tfKn2Lg58XfjEWZFucpziFP8L3uJaM+GwJ035VlW2qpLOalMw0e2M8L7618Bu1WwAsnc6GFZWuxNg+1UYK7t4vebSOgApDIpgOZ4lMqNLBVBgeGS7wshV0vV8cO2EEsyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4LIyvsYtzRhURqLRstFh+fa3PQsRBnRa3uC/qWvQOyM=;
 b=bV/eTio4MMnqYPXpu7y/ymh7MOKrFv6hEXa9JJnHFPkSvJuxKeG7sTCffwKUeuQ6JDA80Iw2tjuhLdhHjT0pPUnpoCe90TnXdc8z/1RbRX2gDTXjCgrtij6C1/evXjldp5voO6BSLgOuE+R7EezzGOxEHjhReJm7kwHkS/tWdGo=
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13) by AM0PR04MB6930.eurprd04.prod.outlook.com
 (2603:10a6:208:186::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.28; Mon, 19 Jul
 2021 09:23:49 +0000
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::99d8:bc8c:537a:2601]) by AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::99d8:bc8c:537a:2601%3]) with mapi id 15.20.4308.027; Mon, 19 Jul 2021
 09:23:49 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: Re: [PATCH v4 net-next 09/15] net: bridge: switchdev: let drivers
 inform which bridge ports are offloaded
Thread-Topic: [PATCH v4 net-next 09/15] net: bridge: switchdev: let drivers
 inform which bridge ports are offloaded
Thread-Index: AQHXfB5XNUBYJG8WOUyHcYodTr5tvKtKB1IA
Date:   Mon, 19 Jul 2021 09:23:49 +0000
Message-ID: <20210719092348.wzpnhcrib24m7zpw@skbuf>
References: <20210718214434.3938850-1-vladimir.oltean@nxp.com>
 <20210718214434.3938850-10-vladimir.oltean@nxp.com>
In-Reply-To: <20210718214434.3938850-10-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dfe1dd0e-c163-4bbb-622d-08d94a96ead4
x-ms-traffictypediagnostic: AM0PR04MB6930:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB6930027A8312F3AA5ECE6BFBE0E19@AM0PR04MB6930.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TMpvg72HVnAJ04SY+GwgEZnGrmY2nAXL7oWczLoX6ff3hY3tt1D8JMtZix1Af2Ky8THMhQN0SW3gMLHTjpS55OgrBYfYuZYtgDbCvb0/+1uQkVsTnkTrPH+IS4XY2ZsHw7YDVAnYRM30bJiDi6dO2qF44CZVZI54pBgpZ3ntysbKGM66j/rutPJqgqSrFmDNnM5KkShD4O7hdvpYHI8jsuSnrKCQw8b+fXPRYc+mzNCavYZjY8ognoyihxxfuYjWyja5W7ENmfM1anXQzlW6viGa+lXHa6SvVU16hqq/nHU2StdJzKvPomYjJLbJSefkdW+9oRqfpUZN33Yp2NOhE+BkxFnsEZoL21ApoxHIucCeNbCsG9JiDc8bAipC525bTUA5d0QMPLGb/g/oYiKLPTEXL8cH8OVm96ooYWVuG5J1K6AjSm4Rm6Whzeb57xqlLLLosUxzphBT72xPdRslqtrdI1f9qxcGjAN3dF+RyWGekUoTkT8m8nkOi0+4IAmXWjbRTvvieDWDepU8wMmnWgdUcCWdUEYfsaYdqRbdCInXXRz6UY5qPvT+OnNfxJsO8JzCQC84jRph7Sfw11/gk8wEmTm+0LOm7LSYR+4Gxyikp5YQohys9b/cnLKn6awwbW7wiXCJBBoW6b2SB8rNxPI8/5BSlriyUekXCHh8j+GB4JPozoYIncMPgnGyUO/m1MGPZJTUMdUHzMFPMxYQmw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0401MB2308.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(136003)(346002)(39860400002)(396003)(366004)(376002)(33716001)(38100700002)(5660300002)(122000001)(44832011)(4326008)(6636002)(186003)(478600001)(316002)(7416002)(26005)(6862004)(86362001)(1076003)(6506007)(2906002)(8936002)(66946007)(66446008)(64756008)(66556008)(6486002)(66476007)(54906003)(71200400001)(76116006)(9686003)(6512007)(8676002)(83380400001)(38070700004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?v8yOBUpW6m4OZJF06nVCtOhllOc+UaaEWIatpO7AFI6Is8xfmV5PCebpta4y?=
 =?us-ascii?Q?eFOpc11UTVBPrCTAppWn5w4FsvQbHg2NP53hlOpC3yBz4NXnA8jjxydz0Cu5?=
 =?us-ascii?Q?2kItGT5bpA++GpO8rU8PMV6Cll3tqeV610c9nyYjTKT3RkPdU1QKT+/Sn6IZ?=
 =?us-ascii?Q?PYkT2vnxm/Dw1MeelVHKXbEHNzyMrYtTrQlkZzaPg63+zgKhRoGS0OzOF5bu?=
 =?us-ascii?Q?paihYz5IxQwQcQuGGveAfJehR98tSrn7bLI0f5QqPIpe8yGssEuzlJl6mMiN?=
 =?us-ascii?Q?CuzRWl5gXNa3mop8ur+KUQBNY753hi7ivD/ZxzHtrtFtoFuMEtB3U7wYIxQC?=
 =?us-ascii?Q?nk+WuDtD9JclLDyztEbjE7r6URh27qyf3Nscb2izf1EJ7ZtAnbXPzKwXxIG7?=
 =?us-ascii?Q?CqN442xhgsf7iF7Y5wCYYTSKuicMJA99hAQN8DHkGdY1JTUkJdlnD9ai95bG?=
 =?us-ascii?Q?StC5xYZQtWQLBTevc9bhq68oih9V+Fp+t83ZQdluXvxrfS6AkJHsK+8njsJN?=
 =?us-ascii?Q?OgiTukIkyBUNkq6mqFdG4tsEGCXyPLsRpg5T3CsiEYt6ZCppIbeoj3UgOokR?=
 =?us-ascii?Q?0h0hW85uH0+B4WHqDykLRHXMNoAcfWTyD0aIlNOOt24Rs+QpMAONCI+EzFSI?=
 =?us-ascii?Q?K/h2v7/zt65oa4k+zwohKeqMxpUZWeZq/P+uRhhrQvEMDt6Ozapga3AcR4He?=
 =?us-ascii?Q?kj/ooJ+DIqnXS8fQ+28WAo0rpY9H0d2Jidp82LmUuq68mH9C6rHzIrofrYas?=
 =?us-ascii?Q?/K5srkUMcM/LNzcFTHY/NC996NVG2dDtr5w1FFoqT4WxDriVC1Xpfqe9EALp?=
 =?us-ascii?Q?tmbFu1TRXB//EEE7YrA63805Z0tUXzjZBBqbtPR1aIGvuDZ7sJGOTLjpl9hc?=
 =?us-ascii?Q?v3mLtxok1glAqTICPcVqbFXnM9aA8zs5QO2i1LUptR1MWJuZAcXCNl6ga1fx?=
 =?us-ascii?Q?NRLEL9tYyiZZi9S2VCZtNzwlSkcVnLZvCxeLZJTwpyYU3cKTzT4rGSY5S3Rk?=
 =?us-ascii?Q?LOvcN4PMlw2NqJrNnR23XjJh5zacPjs1dXPfX797tdHI4YgSpRDVPZBg0h6A?=
 =?us-ascii?Q?RnghtPZzPPWi673a1ESNunuj5dkGPW0VPX3+7qqWey1tWc3IP3f7eJh7uV/I?=
 =?us-ascii?Q?wj5jrWwFoPSB70LcM6XS5HUpUmIrqYhvM0HR+iJ75gJsvoSpLdpM2JnZu7Fg?=
 =?us-ascii?Q?k/6KYmHqjVr+J8gWEEDgIbGMuO8gKVNv1q0seUU9uZtrppUO0wIZpdWaXHiI?=
 =?us-ascii?Q?avfyUKlbG+nKxfRkA8IC9ocCCLUR8G4ntPrxUP/8QcVdk7DUMZuqFcUWX/R+?=
 =?us-ascii?Q?o/y6JykO8+2gGSteLvKV2hBc?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A0E76103D6D80A49B174BFEF581FDFC4@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0401MB2308.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfe1dd0e-c163-4bbb-622d-08d94a96ead4
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2021 09:23:49.3833
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lRVr7Ep+EWSG+ntUzHUyBA5wSFp++LganLuiTwrDoyAMtUE9nWJnJm7cWrPLnVk8ivsZxGFJuhOTzPbQdZWP2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6930
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 19, 2021 at 12:44:28AM +0300, Vladimir Oltean wrote:
> On reception of an skb, the bridge checks if it was marked as 'already
> forwarded in hardware' (checks if skb->offload_fwd_mark =3D=3D 1), and if=
 it
> is, it assigns the source hardware domain of that skb based on the
> hardware domain of the ingress port. Then during forwarding, it enforces
> that the egress port must have a different hardware domain than the
> ingress one (this is done in nbp_switchdev_allowed_egress).
>=20
> Non-switchdev drivers don't report any physical switch id (neither
> through devlink nor .ndo_get_port_parent_id), therefore the bridge
> assigns them a hardware domain of 0, and packets coming from them will
> always have skb->offload_fwd_mark =3D 0. So there aren't any restrictions=
.
>=20
> Problems appear due to the fact that DSA would like to perform software
> fallback for bonding and team interfaces that the physical switch cannot
> offload.
>=20
>        +-- br0 ---+
>       / /   |      \
>      / /    |       \
>     /  |    |      bond0
>    /   |    |     /    \
>  swp0 swp1 swp2 swp3 swp4
>=20
> There, it is desirable that the presence of swp3 and swp4 under a
> non-offloaded LAG does not preclude us from doing hardware bridging
> beteen swp0, swp1 and swp2. The bandwidth of the CPU is often times high
> enough that software bridging between {swp0,swp1,swp2} and bond0 is not
> impractical.
>=20
> But this creates an impossible paradox given the current way in which
> port hardware domains are assigned. When the driver receives a packet
> from swp0 (say, due to flooding), it must set skb->offload_fwd_mark to
> something.
>=20
> - If we set it to 0, then the bridge will forward it towards swp1, swp2
>   and bond0. But the switch has already forwarded it towards swp1 and
>   swp2 (not to bond0, remember, that isn't offloaded, so as far as the
>   switch is concerned, ports swp3 and swp4 are not looking up the FDB,
>   and the entire bond0 is a destination that is strictly behind the
>   CPU). But we don't want duplicated traffic towards swp1 and swp2, so
>   it's not ok to set skb->offload_fwd_mark =3D 0.
>=20
> - If we set it to 1, then the bridge will not forward the skb towards
>   the ports with the same switchdev mark, i.e. not to swp1, swp2 and
>   bond0. Towards swp1 and swp2 that's ok, but towards bond0? It should
>   have forwarded the skb there.
>=20
> So the real issue is that bond0 will be assigned the same hardware
> domain as {swp0,swp1,swp2}, because the function that assigns hardware
> domains to bridge ports, nbp_switchdev_add(), recurses through bond0's
> lower interfaces until it finds something that implements devlink (calls
> dev_get_port_parent_id with bool recurse =3D true). This is a problem
> because the fact that bond0 can be offloaded by swp3 and swp4 in our
> example is merely an assumption.
>=20
> A solution is to give the bridge explicit hints as to what hardware
> domain it should use for each port.
>=20
> Currently, the bridging offload is very 'silent': a driver registers a
> netdevice notifier, which is put on the netns's notifier chain, and
> which sniffs around for NETDEV_CHANGEUPPER events where the upper is a
> bridge, and the lower is an interface it knows about (one registered by
> this driver, normally). Then, from within that notifier, it does a bunch
> of stuff behind the bridge's back, without the bridge necessarily
> knowing that there's somebody offloading that port. It looks like this:
>=20
>      ip link set swp0 master br0
>                   |
>                   v
>  br_add_if() calls netdev_master_upper_dev_link()
>                   |
>                   v
>         call_netdevice_notifiers
>                   |
>                   v
>        dsa_slave_netdevice_event
>                   |
>                   v
>         oh, hey! it's for me!
>                   |
>                   v
>            .port_bridge_join
>=20
> What we do to solve the conundrum is to be less silent, and change the
> switchdev drivers to present themselves to the bridge. Something like thi=
s:
>=20
>      ip link set swp0 master br0
>                   |
>                   v
>  br_add_if() calls netdev_master_upper_dev_link()
>                   |
>                   v                    bridge: Aye! I'll use this
>         call_netdevice_notifiers           ^  ppid as the
>                   |                        |  hardware domain for
>                   v                        |  this port, and zero
>        dsa_slave_netdevice_event           |  if I got nothing.
>                   |                        |
>                   v                        |
>         oh, hey! it's for me!              |
>                   |                        |
>                   v                        |
>            .port_bridge_join               |
>                   |                        |
>                   +------------------------+
>              switchdev_bridge_port_offload(swp0, swp0)
>=20
> Then stacked interfaces (like bond0 on top of swp3/swp4) would be
> treated differently in DSA, depending on whether we can or cannot
> offload them.
>=20
> The offload case:
>=20
>     ip link set bond0 master br0
>                   |
>                   v
>  br_add_if() calls netdev_master_upper_dev_link()
>                   |
>                   v                    bridge: Aye! I'll use this
>         call_netdevice_notifiers           ^  ppid as the
>                   |                        |  switchdev mark for
>                   v                        |        bond0.
>        dsa_slave_netdevice_event           | Coincidentally (or not),
>                   |                        | bond0 and swp0, swp1, swp2
>                   v                        | all have the same switchdev
>         hmm, it's not quite for me,        | mark now, since the ASIC
>          but my driver has already         | is able to forward towards
>            called .port_lag_join           | all these ports in hw.
>           for it, because I have           |
>       a port with dp->lag_dev =3D=3D bond0.    |
>                   |                        |
>                   v                        |
>            .port_bridge_join               |
>            for swp3 and swp4               |
>                   |                        |
>                   +------------------------+
>             switchdev_bridge_port_offload(bond0, swp3)
>             switchdev_bridge_port_offload(bond0, swp4)
>=20
> And the non-offload case:
>=20
>     ip link set bond0 master br0
>                   |
>                   v
>  br_add_if() calls netdev_master_upper_dev_link()
>                   |
>                   v                    bridge waiting:
>         call_netdevice_notifiers           ^  huh, switchdev_bridge_port_=
offload
>                   |                        |  wasn't called, okay, I'll u=
se a
>                   v                        |  hwdom of zero for this one.
>        dsa_slave_netdevice_event           :  Then packets received on sw=
p0 will
>                   |                        :  not be software-forwarded t=
owards
>                   v                        :  swp1, but they will towards=
 bond0.
>          it's not for me, but
>        bond0 is an upper of swp3
>       and swp4, but their dp->lag_dev
>        is NULL because they couldn't
>             offload it.
>=20
> Basically we can draw the conclusion that the lowers of a bridge port
> can come and go, so depending on the configuration of lowers for a
> bridge port, it can dynamically toggle between offloaded and unoffloaded.
> Therefore, we need an equivalent switchdev_bridge_port_unoffload too.
>=20
> This patch changes the way any switchdev driver interacts with the
> bridge. From now on, everybody needs to call switchdev_bridge_port_offloa=
d
> and switchdev_bridge_port_unoffload, otherwise the bridge will treat the
> port as non-offloaded and allow software flooding to other ports from
> the same ASIC.
>=20
> Note that these functions lay the ground for a more complex handshake
> between switchdev drivers and the bridge in the future. During the
> info->linking =3D=3D false path, switchdev_bridge_port_unoffload() is
> strategically put in the NETDEV_PRECHANGEUPPER notifier as opposed to
> NETDEV_CHANGEUPPER. The reason for this has to do with a future
> migration of the switchdev object replay helpers (br_*_replay) from a
> pull mode (completely initiated by the driver) to a semi-push mode (the
> bridge initiates the replay when the switchdev driver declares that it
> offloads a port). On deletion, the switchdev object replay helpers need
> the netdev adjacency lists to be valid, and that is only true in
> NETDEV_PRECHANGEUPPER. So we need to add trivial glue code to all
> drivers to handle a "pre bridge leave" event, and that is where we hook
> the switchdev_bridge_port_unoffload() call.
>=20
> Cc: Vadym Kochan <vkochan@marvell.com>
> Cc: Taras Chornyi <tchornyi@marvell.com>
> Cc: Ioana Ciornei <ioana.ciornei@nxp.com>
> Cc: Lars Povlsen <lars.povlsen@microchip.com>
> Cc: Steen Hegelund <Steen.Hegelund@microchip.com>
> Cc: UNGLinuxDriver@microchip.com
> Cc: Claudiu Manoil <claudiu.manoil@nxp.com>
> Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Cc: Grygorii Strashko <grygorii.strashko@ti.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Tested-by: Ioana Ciornei <ioana.ciornei@nxp.com> # dpaa2-switch: regression
Acked-by: Ioana Ciornei <ioana.ciornei@nxp.com> # dpaa2-switch
