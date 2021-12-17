Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48A78479305
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 18:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238518AbhLQRoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 12:44:18 -0500
Received: from mail-eopbgr70080.outbound.protection.outlook.com ([40.107.7.80]:42795
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235821AbhLQRoS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 12:44:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UO+TzODQck5iPhrkmKWoMBR3yFUhYLYZh3fYcfnl9yPCH6Q5LB3qXpxPbnF4x9DoKdqhfKWN3+QaMqqNVnE8o3zn4bhN2qO+KARS4mlBq/mfayh/M0pHOusmPkoxpeH17bhug1viKk2k9oEwKxZWfB4PAmIotzwtiXLyUkjrvXLjW0kUho5NMHoiHmXVAt/3P9qrQsCsLCy3jPqOwYMGGsGFjKX0lodieGnAzAYL6RCrrnBuC4P+2tQSr9cfxaO1Ym+ejYqxGmEkLJ6zPEpZP9U5c4IG76Bf3ErYJxS1XjFN5qscF7UNIjHX8SoGvXf+GAmBIbpyznowRmid05i69A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IoIV44/K7vvHQTRJp7B2dc+hlLLdc+kveByovJm6p8w=;
 b=jew3DU3YSKqW4DysqGW60WflDlJ9gdEcibMKZ53QyG5bh49Hi+HFplc5nrbQWThWwyPhL4VpJgWcmdKNnBhq4s/dZy8W36dkyvo5XOabzgNEjVTAKn2CuiJ+0+jqUW9n/U4VD5mm+PcGLyueUSE2BGlPix5DfEeta/bTDTu+Dtr9gv/V3mewTRFbfsAPkXicZuKJ8CblC50a2pKlm4V86GirOAe/IcwDQBYEbCsoRtC1kgl/in2FdDI/AfAyZck6OvSqs1RROjw0wK2JppAGnsI48989pJOjw4B4sDfrl9Hb7M6tiymRzvF/I/70AWux5BTHnGgMvU+OuonFFeneGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IoIV44/K7vvHQTRJp7B2dc+hlLLdc+kveByovJm6p8w=;
 b=XCCllSgOq6Rw0o+9GnIF0y+eYgkhUMwSi8/o4uh4BZAu/2hKxHFNIvOBEX5Q598CdXzRs1RuXTVQWXtCtrMWiQEmYuDPDDdf4co7JC5FqvkSqC+YHe+HZqBlakzpV9PrOWPc/QlhCjWw54MpKieKdixC4JfZQG3bOvqZVtapguQ=
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AM4PR0401MB2242.eurprd04.prod.outlook.com (2603:10a6:200:4f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.18; Fri, 17 Dec
 2021 17:44:14 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8d61:83aa:b70c:3208]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8d61:83aa:b70c:3208%6]) with mapi id 15.20.4778.018; Fri, 17 Dec 2021
 17:44:14 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net-next v7 6/9] net: lan966x: Add support to offload the
 forwarding.
Thread-Topic: [PATCH net-next v7 6/9] net: lan966x: Add support to offload the
 forwarding.
Thread-Index: AQHX8140QpvO59EjdUWacx2qGVwygKw29KoA
Date:   Fri, 17 Dec 2021 17:44:13 +0000
Message-ID: <20211217174412.w4jwe2uuwx56ipfg@skbuf>
References: <20211217155353.460594-1-horatiu.vultur@microchip.com>
 <20211217155353.460594-7-horatiu.vultur@microchip.com>
In-Reply-To: <20211217155353.460594-7-horatiu.vultur@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bb46c6bb-9955-4f01-b428-08d9c184d761
x-ms-traffictypediagnostic: AM4PR0401MB2242:EE_
x-microsoft-antispam-prvs: <AM4PR0401MB2242C11271F68221F71B61F8E0789@AM4PR0401MB2242.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:962;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LLo5m54Mi/phw0QGmD98Tz4r8Fm7DKg6UJ5vQFhX320QumiP3HGSt1Qqe3UDhKUc6NntFELMjt5StnskLE6oNYx4v9fS5PgQBJi1ffDdK8qJvMHy91PvceFCyamRlM72hSPMduud6qNgxkPjgiIoWdau5ODyWOsd+UaKj+PjqYy034DPWrD9G+5enupDtxIPy1VYzCMt68IgA4G1awo9hmsv9AAff1CMkiQvtlsSDcSryc4MhUaAlf6LpqZhBHfvqWfSPyitwO9avAaH9qlkVoSX6EN8JoZRIX3xdBYpZkA1vhPq9B2Ehwt8ZKwzwtoD4eXgd1HzR7xEqcWRNi1bnPbMlNlOkfDfLvHtO0tBlpJs+LYAdk22Gc3NCvaI/5x0q0kViZNVdp6eedRqbWqqakbO8Qcf+XHLn6ZpsTw5wttZcYwaskU0gaLJDTs/TZ+utsE0YhxUBa1+vV2NiuH9bMiEmu4vPMR3Fr8GNOA77ZY/UEI/Sx1TRX3MLPn3mBrTfGpZ75aBRZizG68XVKiIexU8mmdrPK5jssAaPuFC/AobMHZTL1rql4JMQ9Eg2pkXmILigZhvff9hq0KMJlhx+HJ2jD0+oZ1UIVdAUw1/0caKdUT0UKjN5fItox8EjXgeJeoKYdfhie00eY8vBWPMJANiC0eAJtEXUP73UyacyGNk0JGk9OVOeopQkBWd73TJRrI4Na3P/IV2Vpb3DkVh7A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(76116006)(5660300002)(91956017)(508600001)(2906002)(66446008)(71200400001)(6486002)(6916009)(66556008)(66476007)(4326008)(64756008)(83380400001)(66946007)(38070700005)(6512007)(1076003)(8676002)(30864003)(7416002)(38100700002)(86362001)(26005)(122000001)(316002)(9686003)(6506007)(33716001)(54906003)(186003)(44832011)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?N9palWSfQh/2OAGcGAukS12cmlTj4YBwM6bl7qfqvLBG5AiHTZsVYmHT9q29?=
 =?us-ascii?Q?T90W+9t+kt0TFyFvdu+ivqtcrjNuMCiPT2qmEBrVnam0cAN+DmyiGGWQBrJr?=
 =?us-ascii?Q?NJPGJRVbRFajc8kr69NkORCuDILP6MmlQ1LWOi7tJf2l6SIeTg1WDCPW+YWC?=
 =?us-ascii?Q?mVzXpouYTz1VtzsP6Nh6tBplgIpLvmPGeWbRAEy2j7PVJscL0KPrKGGdEFvI?=
 =?us-ascii?Q?XOoct+XNSZjFNoxhYGeL9cioZQKMnpmhtZXJpy4FDsUq8+5q4IzHtOF/vfiq?=
 =?us-ascii?Q?WhrNEeoxPp8tRWd92hCWhhK2agzph3aBq/yPXDU1MJxsmGK6NQViWaVJdIfL?=
 =?us-ascii?Q?zEBn7IkcgzLi8d2gs+m7Ijtef5uCEruNp5KS+7/u/FznbQ+A5mnv6+xItHA1?=
 =?us-ascii?Q?Vl7a2Fq4nuy29fvKUv02KJi9npn/kjDFMLSbtyz2PlrS8QwlDYTX/HDlHURz?=
 =?us-ascii?Q?nNrA1H+4bzjJ49i8m+cYrgWALPQpeeiU3pULfRg0CcUTZ3xl00+gr8nSvGlP?=
 =?us-ascii?Q?hpZ1+k4eQyMZijs6mdC3cTDwEEpRvmcOht2LlKRyM7cwSH2IMX6rL+QGNv3u?=
 =?us-ascii?Q?VcmxxLUJGveF7E8l9TRDXXrTZmS9WFqOS5CUvLEbTqV917KsSVKolmdOgoBo?=
 =?us-ascii?Q?mSeNP9EXIS0Bfc0lKHQRb2b5m0cWHfl0LYA7+mjPevbbUA2VrApZoJspPEjO?=
 =?us-ascii?Q?jzB04RnFg2AHqdW+1zSxKxGYpnQcM8pGoS5D0urYxPEQl/tzbNGLgrAlgWh1?=
 =?us-ascii?Q?yePNVImV7FrTsoRrWQt/6N22iqz7Uh73u3w4sgDNzq4TZvJ/l7IlABWTF/L8?=
 =?us-ascii?Q?AnyjsZ70uj7Go+r5kwuSjSuu4bZ79hTqdnpnQOTnXBw6EhWZrzmFlUQr2Wio?=
 =?us-ascii?Q?IRhY7wPUz26XTSh7WePbws4OjrGKCb+qiAv2ckh72jU3WV4W7TFmgVZWcotq?=
 =?us-ascii?Q?cS8PmPOj57UAjZr4AiahrHakGuEhGIFKP5WR9HL6acYm0lqmdH6xmF3J/Lvw?=
 =?us-ascii?Q?0pILwNyrZ4HN2iVGMWnbdNuysyOTWeXlzajOi3WrDAIbSdU1bqfJLv4TdYjx?=
 =?us-ascii?Q?c/lphtoydZZU82ER877Wialn0KUkdehdPAkaCxxy4vT2AZ+OiXdn7QeCgg/O?=
 =?us-ascii?Q?H/b0yeJ4lXCgVRePVFQKEpzJ1QBr/dyxqV5pSj2aKJEIRcfn0/R/RqUnhd6m?=
 =?us-ascii?Q?anVPhAQx/rnWMWVsU/2WRSABo1H2WCu0XrF/dnTZWax0smDqoR4AODUESj/h?=
 =?us-ascii?Q?TFRU42e4HmO49y0wEv2VSO0VJO5qjHqfdGCzaNvisvcqHHXwR1yEASE5hpTy?=
 =?us-ascii?Q?qsahLtiZxm9ls0rATsYauTYSRZfJsa7OqveiJZFx+uwGG8cT7riBbB01Ol+7?=
 =?us-ascii?Q?g4UujPa4nnNvcDEmA0wOAdDsKKMXJFn/i1x3NIf3YPSbfStxQ7wf1Lo1U3ax?=
 =?us-ascii?Q?1tVVBt0CWC7FMlpglClKwEs2MR6pD7kVBSccAFr0FKBv0d+sFfLNMfRaiX+L?=
 =?us-ascii?Q?Ap0kHHUMEIB6yPiUayOmTFy1Juf8muVVlTN2YZvkgTOILH5H3NZG5TFvk+4y?=
 =?us-ascii?Q?rsrHoFkP5QlsslxynQ31C6/kIfs0wR4W4BHKRurdVBTFAIppriggX8RPWQvQ?=
 =?us-ascii?Q?kuq94o2Zh+eYZCmbQU6sykU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CB69BC15CB33F64097BD2556C0DC45F7@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb46c6bb-9955-4f01-b428-08d9c184d761
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2021 17:44:14.0515
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: suCCZ++0zrBxwiAlPlbd80VBPRohldJM6Ig16lTFVDmcRUhgX+dNbSIPnMXDx79AL7M5OCm/vlw8cNNsvZln8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0401MB2242
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 17, 2021 at 04:53:50PM +0100, Horatiu Vultur wrote:
> This patch adds basic support to offload in the HW the forwarding of the
> frames. The driver registers to the switchdev callbacks and implements
> the callbacks for attributes SWITCHDEV_ATTR_ID_PORT_STP_STATE and
> SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME.
> It is not allowed to add a lan966x port to a bridge that contains a
> different interface than lan966x.
>=20
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  .../net/ethernet/microchip/lan966x/Kconfig    |   1 +
>  .../net/ethernet/microchip/lan966x/Makefile   |   2 +-
>  .../ethernet/microchip/lan966x/lan966x_main.c |  32 +-
>  .../ethernet/microchip/lan966x/lan966x_main.h |   9 +
>  .../microchip/lan966x/lan966x_switchdev.c     | 309 ++++++++++++++++++
>  5 files changed, 351 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_switch=
dev.c
>=20
> diff --git a/drivers/net/ethernet/microchip/lan966x/Kconfig b/drivers/net=
/ethernet/microchip/lan966x/Kconfig
> index 2860a8c9923d..ac273f84b69e 100644
> --- a/drivers/net/ethernet/microchip/lan966x/Kconfig
> +++ b/drivers/net/ethernet/microchip/lan966x/Kconfig
> @@ -2,6 +2,7 @@ config LAN966X_SWITCH
>  	tristate "Lan966x switch driver"
>  	depends on HAS_IOMEM
>  	depends on OF
> +	depends on NET_SWITCHDEV
>  	select PHYLINK
>  	select PACKING
>  	help
> diff --git a/drivers/net/ethernet/microchip/lan966x/Makefile b/drivers/ne=
t/ethernet/microchip/lan966x/Makefile
> index 2989ba528236..974229c51f55 100644
> --- a/drivers/net/ethernet/microchip/lan966x/Makefile
> +++ b/drivers/net/ethernet/microchip/lan966x/Makefile
> @@ -6,4 +6,4 @@
>  obj-$(CONFIG_LAN966X_SWITCH) +=3D lan966x-switch.o
> =20
>  lan966x-switch-objs  :=3D lan966x_main.o lan966x_phylink.o lan966x_port.=
o \
> -			lan966x_mac.o lan966x_ethtool.o
> +			lan966x_mac.o lan966x_ethtool.o lan966x_switchdev.o
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/driv=
ers/net/ethernet/microchip/lan966x/lan966x_main.c
> index dc40ac2eb246..5af60234d81d 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> @@ -355,6 +355,11 @@ static const struct net_device_ops lan966x_port_netd=
ev_ops =3D {
>  	.ndo_get_port_parent_id		=3D lan966x_port_get_parent_id,
>  };
> =20
> +bool lan966x_netdevice_check(const struct net_device *dev)
> +{
> +	return dev->netdev_ops =3D=3D &lan966x_port_netdev_ops;
> +}
> +
>  static int lan966x_port_xtr_status(struct lan966x *lan966x, u8 grp)
>  {
>  	return lan_rd(lan966x, QS_XTR_RD(grp));
> @@ -491,6 +496,9 @@ static irqreturn_t lan966x_xtr_irq_handler(int irq, v=
oid *args)
> =20
>  		skb->protocol =3D eth_type_trans(skb, dev);
> =20
> +		if (lan966x->bridge_mask & BIT(src_port))
> +			skb->offload_fwd_mark =3D 1;
> +
>  		netif_rx_ni(skb);
>  		dev->stats.rx_bytes +=3D len;
>  		dev->stats.rx_packets++;
> @@ -915,6 +923,7 @@ static int lan966x_remove(struct platform_device *pde=
v)
>  {
>  	struct lan966x *lan966x =3D platform_get_drvdata(pdev);
> =20
> +	lan966x_unregister_notifier_blocks();

You forgot to delete this from lan966x_remove.

>  	lan966x_cleanup_ports(lan966x);
> =20
>  	cancel_delayed_work_sync(&lan966x->stats_work);
> @@ -934,7 +943,28 @@ static struct platform_driver lan966x_driver =3D {
>  		.of_match_table =3D lan966x_match,
>  	},
>  };
> -module_platform_driver(lan966x_driver);
> +
> +static int __init lan966x_switch_driver_init(void)
> +{
> +	int ret;
> +
> +	ret =3D platform_driver_register(&lan966x_driver);
> +	if (ret)
> +		return ret;
> +
> +	lan966x_register_notifier_blocks();

I think you might miss some events if you register the notifier blocks
after you've registered your net devices, so could you move this to be
first (and reverse the order for the driver exit, too)?

> +
> +	return 0;
> +}
> +
> +static void __exit lan966x_switch_driver_exit(void)
> +{
> +	lan966x_unregister_notifier_blocks();
> +	platform_driver_unregister(&lan966x_driver);
> +}
> +
> +module_init(lan966x_switch_driver_init);
> +module_exit(lan966x_switch_driver_exit);
> =20
>  MODULE_DESCRIPTION("Microchip LAN966X switch driver");
>  MODULE_AUTHOR("Horatiu Vultur <horatiu.vultur@microchip.com>");
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/driv=
ers/net/ethernet/microchip/lan966x/lan966x_main.h
> index fcd5d09a070c..4723a904c13e 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> @@ -75,6 +75,10 @@ struct lan966x {
> =20
>  	u8 base_mac[ETH_ALEN];
> =20
> +	struct net_device *bridge;
> +	u16 bridge_mask;
> +	u16 bridge_fwd_mask;
> +
>  	struct list_head mac_entries;
>  	spinlock_t mac_lock; /* lock for mac_entries list */
> =20
> @@ -122,6 +126,11 @@ extern const struct phylink_mac_ops lan966x_phylink_=
mac_ops;
>  extern const struct phylink_pcs_ops lan966x_phylink_pcs_ops;
>  extern const struct ethtool_ops lan966x_ethtool_ops;
> =20
> +bool lan966x_netdevice_check(const struct net_device *dev);
> +
> +void lan966x_register_notifier_blocks(void);
> +void lan966x_unregister_notifier_blocks(void);
> +
>  void lan966x_stats_get(struct net_device *dev,
>  		       struct rtnl_link_stats64 *stats);
>  int lan966x_stats_init(struct lan966x *lan966x);
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c b=
/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
> new file mode 100644
> index 000000000000..9db17b677357
> --- /dev/null
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
> @@ -0,0 +1,309 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +
> +#include <linux/if_bridge.h>
> +#include <net/switchdev.h>
> +
> +#include "lan966x_main.h"
> +
> +static struct notifier_block lan966x_netdevice_nb __read_mostly;
> +static struct notifier_block lan966x_switchdev_nb __read_mostly;
> +static struct notifier_block lan966x_switchdev_blocking_nb __read_mostly=
;
> +
> +static void lan966x_update_fwd_mask(struct lan966x *lan966x)
> +{
> +	int i;
> +
> +	for (i =3D 0; i < lan966x->num_phys_ports; i++) {
> +		struct lan966x_port *port =3D lan966x->ports[i];
> +		unsigned long mask =3D 0;
> +
> +		if (port && lan966x->bridge_fwd_mask & BIT(i))
> +			mask =3D lan966x->bridge_fwd_mask & ~BIT(i);
> +
> +		mask |=3D BIT(CPU_PORT);
> +
> +		lan_wr(ANA_PGID_PGID_SET(mask),
> +		       lan966x, ANA_PGID(PGID_SRC + i));
> +	}
> +}
> +
> +static void lan966x_port_stp_state_set(struct lan966x_port *port, u8 sta=
te)
> +{
> +	struct lan966x *lan966x =3D port->lan966x;
> +	bool learn_ena =3D false;
> +
> +	if (state =3D=3D BR_STATE_FORWARDING || state =3D=3D BR_STATE_LEARNING)
> +		learn_ena =3D true;
> +
> +	if (state =3D=3D BR_STATE_FORWARDING)
> +		lan966x->bridge_fwd_mask |=3D BIT(port->chip_port);
> +	else
> +		lan966x->bridge_fwd_mask &=3D ~BIT(port->chip_port);
> +
> +	lan_rmw(ANA_PORT_CFG_LEARN_ENA_SET(learn_ena),
> +		ANA_PORT_CFG_LEARN_ENA,
> +		lan966x, ANA_PORT_CFG(port->chip_port));
> +
> +	lan966x_update_fwd_mask(lan966x);
> +}
> +
> +static void lan966x_port_ageing_set(struct lan966x_port *port,
> +				    unsigned long ageing_clock_t)
> +{
> +	unsigned long ageing_jiffies =3D clock_t_to_jiffies(ageing_clock_t);
> +	u32 ageing_time =3D jiffies_to_msecs(ageing_jiffies) / 1000;
> +
> +	lan966x_mac_set_ageing(port->lan966x, ageing_time);
> +}
> +
> +static int lan966x_port_attr_set(struct net_device *dev, const void *ctx=
,
> +				 const struct switchdev_attr *attr,
> +				 struct netlink_ext_ack *extack)
> +{
> +	struct lan966x_port *port =3D netdev_priv(dev);
> +	int err =3D 0;
> +
> +	if (ctx && ctx !=3D port)
> +		return 0;
> +
> +	switch (attr->id) {
> +	case SWITCHDEV_ATTR_ID_PORT_STP_STATE:
> +		lan966x_port_stp_state_set(port, attr->u.stp_state);
> +		break;
> +	case SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME:
> +		lan966x_port_ageing_set(port, attr->u.ageing_time);
> +		break;
> +	default:
> +		err =3D -EOPNOTSUPP;
> +		break;
> +	}
> +
> +	return err;
> +}
> +
> +static int lan966x_port_bridge_join(struct lan966x_port *port,
> +				    struct net_device *bridge,
> +				    struct netlink_ext_ack *extack)
> +{
> +	struct lan966x *lan966x =3D port->lan966x;
> +	struct net_device *dev =3D port->dev;
> +	int err;
> +
> +	if (!lan966x->bridge_mask) {
> +		lan966x->bridge =3D bridge;
> +	} else {
> +		if (lan966x->bridge !=3D bridge) {
> +			NL_SET_ERR_MSG_MOD(extack, "Not allow to add port to different bridge=
");
> +			return -ENODEV;
> +		}
> +	}
> +
> +	err =3D switchdev_bridge_port_offload(dev, dev, port,
> +					    &lan966x_switchdev_nb,
> +					    &lan966x_switchdev_blocking_nb,
> +					    false, extack);
> +	if (err)
> +		return err;
> +
> +	lan966x->bridge_mask |=3D BIT(port->chip_port);
> +
> +	return 0;
> +}
> +
> +static void lan966x_port_bridge_leave(struct lan966x_port *port,
> +				      struct net_device *bridge)
> +{
> +	struct lan966x *lan966x =3D port->lan966x;
> +
> +	lan966x->bridge_mask &=3D ~BIT(port->chip_port);
> +
> +	if (!lan966x->bridge_mask)
> +		lan966x->bridge =3D NULL;
> +
> +	lan966x_mac_cpu_learn(lan966x, port->dev->dev_addr, PORT_PVID);
> +}
> +
> +static int lan966x_port_changeupper(struct net_device *dev,
> +				    struct netdev_notifier_changeupper_info *info)
> +{
> +	struct lan966x_port *port =3D netdev_priv(dev);
> +	struct netlink_ext_ack *extack;
> +	int err =3D 0;
> +
> +	extack =3D netdev_notifier_info_to_extack(&info->info);
> +
> +	if (netif_is_bridge_master(info->upper_dev)) {
> +		if (info->linking)
> +			err =3D lan966x_port_bridge_join(port, info->upper_dev,
> +						       extack);
> +		else
> +			lan966x_port_bridge_leave(port, info->upper_dev);
> +	}
> +
> +	return err;
> +}
> +
> +static int lan966x_port_prechangeupper(struct net_device *dev,
> +				       struct netdev_notifier_changeupper_info *info)
> +{
> +	struct lan966x_port *port =3D netdev_priv(dev);
> +
> +	if (netif_is_bridge_master(info->upper_dev) && !info->linking)
> +		switchdev_bridge_port_unoffload(port->dev, port,
> +						&lan966x_switchdev_nb,
> +						&lan966x_switchdev_blocking_nb);
> +
> +	return NOTIFY_DONE;
> +}
> +
> +static int lan966x_foreign_bridging_check(struct net_device *bridge,
> +					  struct netlink_ext_ack *extack)
> +{
> +	struct lan966x *lan966x =3D NULL;
> +	bool has_foreign =3D false;
> +	struct net_device *dev;
> +	struct list_head *iter;
> +
> +	if (!netif_is_bridge_master(bridge))
> +		return 0;
> +
> +	netdev_for_each_lower_dev(bridge, dev, iter) {
> +		if (lan966x_netdevice_check(dev)) {
> +			struct lan966x_port *port =3D netdev_priv(dev);
> +
> +			if (lan966x) {
> +				/* Bridge already has at least one port of a
> +				 * lan966x switch inside it, check that it's
> +				 * the same instance of the driver.
> +				 */
> +				if (port->lan966x !=3D lan966x) {
> +					NL_SET_ERR_MSG_MOD(extack,
> +							   "Bridging between multiple lan966x switches disallowed");
> +					return -EINVAL;
> +				}
> +			} else {
> +				/* This is the first lan966x port inside this
> +				 * bridge
> +				 */
> +				lan966x =3D port->lan966x;
> +			}
> +		} else {
> +			has_foreign =3D true;
> +		}
> +
> +		if (lan966x && has_foreign) {
> +			NL_SET_ERR_MSG_MOD(extack,
> +					   "Bridging lan966x ports with foreign interfaces disallowed");
> +			return -EINVAL;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int lan966x_bridge_check(struct net_device *dev,
> +				struct netdev_notifier_changeupper_info *info)
> +{
> +	return lan966x_foreign_bridging_check(info->upper_dev,
> +					      info->info.extack);
> +}
> +
> +static int lan966x_netdevice_port_event(struct net_device *dev,
> +					struct notifier_block *nb,
> +					unsigned long event, void *ptr)
> +{
> +	int err =3D 0;
> +
> +	if (!lan966x_netdevice_check(dev)) {
> +		if (event =3D=3D NETDEV_CHANGEUPPER)
> +			return lan966x_bridge_check(dev, ptr);
> +		return 0;
> +	}
> +
> +	switch (event) {
> +	case NETDEV_PRECHANGEUPPER:
> +		err =3D lan966x_port_prechangeupper(dev, ptr);
> +		break;
> +	case NETDEV_CHANGEUPPER:
> +		err =3D lan966x_bridge_check(dev, ptr);
> +		if (err)
> +			return err;
> +
> +		err =3D lan966x_port_changeupper(dev, ptr);
> +		break;
> +	}
> +
> +	return err;
> +}
> +
> +static int lan966x_netdevice_event(struct notifier_block *nb,
> +				   unsigned long event, void *ptr)
> +{
> +	struct net_device *dev =3D netdev_notifier_info_to_dev(ptr);
> +	int ret;
> +
> +	ret =3D lan966x_netdevice_port_event(dev, nb, event, ptr);
> +
> +	return notifier_from_errno(ret);
> +}
> +
> +static int lan966x_switchdev_event(struct notifier_block *nb,
> +				   unsigned long event, void *ptr)
> +{
> +	struct net_device *dev =3D switchdev_notifier_info_to_dev(ptr);
> +	int err;
> +
> +	switch (event) {
> +	case SWITCHDEV_PORT_ATTR_SET:
> +		err =3D switchdev_handle_port_attr_set(dev, ptr,
> +						     lan966x_netdevice_check,
> +						     lan966x_port_attr_set);
> +		return notifier_from_errno(err);
> +	}
> +
> +	return NOTIFY_DONE;
> +}
> +
> +static int lan966x_switchdev_blocking_event(struct notifier_block *nb,
> +					    unsigned long event,
> +					    void *ptr)
> +{
> +	struct net_device *dev =3D switchdev_notifier_info_to_dev(ptr);
> +	int err;
> +
> +	switch (event) {
> +	case SWITCHDEV_PORT_ATTR_SET:
> +		err =3D switchdev_handle_port_attr_set(dev, ptr,
> +						     lan966x_netdevice_check,
> +						     lan966x_port_attr_set);
> +		return notifier_from_errno(err);
> +	}
> +
> +	return NOTIFY_DONE;
> +}
> +
> +static struct notifier_block lan966x_netdevice_nb __read_mostly =3D {
> +	.notifier_call =3D lan966x_netdevice_event,
> +};
> +
> +static struct notifier_block lan966x_switchdev_nb __read_mostly =3D {
> +	.notifier_call =3D lan966x_switchdev_event,
> +};
> +
> +static struct notifier_block lan966x_switchdev_blocking_nb __read_mostly=
 =3D {
> +	.notifier_call =3D lan966x_switchdev_blocking_event,
> +};
> +
> +void lan966x_register_notifier_blocks(void)
> +{
> +	register_netdevice_notifier(&lan966x_netdevice_nb);
> +	register_switchdev_notifier(&lan966x_switchdev_nb);
> +	register_switchdev_blocking_notifier(&lan966x_switchdev_blocking_nb);
> +}
> +
> +void lan966x_unregister_notifier_blocks(void)
> +{
> +	unregister_switchdev_blocking_notifier(&lan966x_switchdev_blocking_nb);
> +	unregister_switchdev_notifier(&lan966x_switchdev_nb);
> +	unregister_netdevice_notifier(&lan966x_netdevice_nb);
> +}
> --=20
> 2.33.0
>=
