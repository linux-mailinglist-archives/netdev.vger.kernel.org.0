Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 560C92945FD
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 02:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410913AbgJUAXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 20:23:12 -0400
Received: from mail-am6eur05on2087.outbound.protection.outlook.com ([40.107.22.87]:28128
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2410905AbgJUAXM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 20:23:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ddZlW7roB00S98UNnRhBb8+dIi9Zoem7zRwaE+E2A2hpj7JDmU2v54PnH6uvYPQya1oqot6NV1wI+7u0pcr/1n2iDd5laNF10a6C/zAtvswFOjWsyuRsEzt/Gbg2kNByTnnlSi/VM4YTpH1EbwAouHQqeEJlID4gO1caHjxisf6FK/y8Yad2DEADrAQ1l2fDIi+W3Ue8rqvChs/lKQjB6XyKS839YYx7S+iyppSW90qYzB7PHjka7qpdyv1brM58ozN8PunIsoBdUkx7lOOnrsj1P6x5mLrUtUztvwgqtSuiMDo+D3QHTfmdvo9nUFsr/Rk93w2KM5zSOf+vIieCtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+tr/2q/KeYP4vxHlrUlbQ003RavHqPfTFpQ45Q+9gkU=;
 b=Ir3Q7HWVJSmpMoXT5B6EVtdHfzp9fqi14i3R1s0TAG9gQQ8bCPaDCP6ERbrHqux+W4Ghfhpjel0xDAZV2Gt9vKnoU5T07nOjZwdpXVTCzMe95gY1EfbNK83M0V/LOVghkJ4rd1JkOaKgRcdTlGZ9dLS4uckyFagSRs8GLCKPQ1iN+/AxGFOuWPTKKnIOEM6jFHhKRTi7sot9a1U5tlSXfAP0Hvu4lPFU5zQynkJ8+h3WPUbZ5uL0vQ735oIhAHjr8C4lWY2JW+PbtXSrbDdUxG8fDoSEVJfwgMsywkHWvPnC3aMrAnW8vBkGPX49rMuP1gOPapYWxlM7nYontWepjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+tr/2q/KeYP4vxHlrUlbQ003RavHqPfTFpQ45Q+9gkU=;
 b=bfe0PAIhdpTQK4ZdOgSm3iRlseAbjS1XfDzTwXwQkQPWEut4KmiKe4bSxBfa6l9o4nWCWCP0t+UB5awz4OFszPYNWnABW/qzC9AzU/HV2QwLYq68bqVTmujP2AGAh/O4PlyNLuXKpnz3st7zzUwBA1n1lBQsH39nMrQnz9bgZkA=
Received: from AM6PR04MB5685.eurprd04.prod.outlook.com (2603:10a6:20b:a4::30)
 by AM6PR04MB4183.eurprd04.prod.outlook.com (2603:10a6:209:43::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.24; Wed, 21 Oct
 2020 00:23:05 +0000
Received: from AM6PR04MB5685.eurprd04.prod.outlook.com
 ([fe80::c62:742e:bcca:e226]) by AM6PR04MB5685.eurprd04.prod.outlook.com
 ([fe80::c62:742e:bcca:e226%4]) with mapi id 15.20.3499.018; Wed, 21 Oct 2020
 00:23:05 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "kuba@kernel.org" <kuba@kernel.org>, Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Leo Li <leoyang.li@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>
Subject: Re: [PATCH v1 net-next 3/5] net: dsa: felix: add gate action offload
 based on tc flower
Thread-Topic: [PATCH v1 net-next 3/5] net: dsa: felix: add gate action offload
 based on tc flower
Thread-Index: AQHWprM0Dmu58BxP1keaaga2Kx2pwqmhM0gA
Date:   Wed, 21 Oct 2020 00:23:05 +0000
Message-ID: <20201021002304.l3evf3e7czd36qgo@skbuf>
References: <20201020072321.36921-1-xiaoliang.yang_1@nxp.com>
 <20201020072321.36921-4-xiaoliang.yang_1@nxp.com>
In-Reply-To: <20201020072321.36921-4-xiaoliang.yang_1@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.174.215]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b24eabdb-94db-4879-debd-08d875577ab7
x-ms-traffictypediagnostic: AM6PR04MB4183:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR04MB41838DA00B2C26C57009A8D2E01C0@AM6PR04MB4183.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KFvpd5QeerxZwUL8Iuh78WKotkC7G78XuFUj9aPLGIQ19FDYXu4FtTwKIJHGqgplMbWauE7ZlSJpqNr7tmHk8/M/JwfB4UzGJk+XgTlM+q1SjH5WLTc0jDOQZoQh8opGZF8eKim24wy2FK+V6NTm3G9ZPWID9IF29159C4lp6zy0/NDT7daPaduCfSlw3gVDYtZgnqrecIaORmBEfHmCCEI2IloB3dDqMaTA15nVaau8Kc0rpgoel5150HSs9MGG7Oa/32Ug+ILYVbfWqQ3zi/rgCqyW4YYZiVDjUBIWXxOJhyES8OnYaGljmwbfgyGREWz3r38mYgsHWIcgexAcBgFV+BRgFcuHjARR76lKfAIftAG0oEfftZXWginvFbAztq57dvKGK6Hw5RYG+dVsJKrIc9OvrZf/b07LD3eqaa09D9uB3TULVzNl/zgkIxMkjmMhfLvkrSyTlFE5FYIvBA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB5685.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(39860400002)(136003)(366004)(376002)(346002)(396003)(8676002)(33716001)(6506007)(316002)(54906003)(8936002)(26005)(6486002)(186003)(83380400001)(71200400001)(86362001)(2906002)(64756008)(76116006)(6862004)(6512007)(4326008)(9686003)(44832011)(30864003)(5660300002)(478600001)(6636002)(1076003)(66446008)(7416002)(91956017)(966005)(66556008)(66946007)(66476007)(461764006)(559001)(579004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: XXTJqxCjot3dqPRpUA+hEFNI9AjyGxabSkrK48GQ79KliXQlFbCaaFe/LEc7eABUNCCGBocKjU06iits6e4oqpcWNvjC/BTk1o6n4MpcE6ghUTSGFzgpiGfxwvXFOqSCiftUw/bxdcqjlSoMusF4sQXvaIh6I1F4JS6rHqtuyV8vKgkNek6d9rMWL6y7YlNPFEpaVptzWzq5X/6Udvwd7/RXh8fiQ1KqkFlUF2b4tdhppggXPJSer4w4KoUk120sVyphp1iZCfi0I9TyRiSMMsenmSwf68qX99U9l+qXPbbUdgZjf3afjCXbF+UP0EKLmeKN6gkxr6wSnXe5t2DoBXUR+AyVQyDcH7Aku1+c9ACMjX2+8pJpPtbedTbsUWWUrpSVQQsTImFTWzNpV9dq3ldPqmbHDFpNjY2bVfkKNVeHAadeV7s8i+81C4sqzEt6FJFv5hGaUedgmWkmfZ513yCo8xkr+WDml5+Lomz/JxWSmd8gdtztVcpA/Jbh0Ki6sIH2bGtrHwyX52NHzHsQS3g9z4JndFB5jXvS/UX6Hwta5DNW/sI77jSWEMpT/y+ho1rNlpK+wXkH+Vn6iingh+vw+G7DulIWrSn+Fx1UDLBVHV8XbW04ohjPUtuaurTK4njD1uRDqq2Ui0OSd4T92A==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <89F690775AA2B541BC14983952998AA4@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB5685.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b24eabdb-94db-4879-debd-08d875577ab7
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2020 00:23:05.3200
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OF2ibea3n3b/HgSu9fTZlxYzFzNBn2AHSt7TUyH8ZCs9Tog9tbSUQSK/VkylqJlidjvsO8dDBa9H0YHLIp+nWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4183
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 20, 2020 at 03:23:19PM +0800, Xiaoliang Yang wrote:
> VSC9959 supports Per-Stream Filtering and Policing(PSFP). Sream is
> identified by Null Stream identification which is defined in
> IEEE802.1Qci.
>=20
> For IEEE 802.1Qci, there are four tables need to set: stream table,
> stream filter table, stream gate table, and flow meter table. This
> patch is using TC flower gate action to set stream gate table, using
> TC flower keys{dst_mac, vlan_id} to identify a stream and set the
> stream table. Stream filter table is maintained automatically, and
> it's index is determined by SGID(stream gate index) and FMID(flow
> meter index).
>=20
> On the ocelot driver, there is also a TC flower offload to set up
> VCAPs. We check the chain ID to offload the rule on felix driver to
> run PSFP flow.
>=20
> An example to set stream gate:
> 	> tc qdisc add dev swp0 clsact
> 	> tc filter add dev swp0 ingress chain 30000 protocol 802.1Q
> 		flower skip_sw dst_mac  CA:9C:00:BC:6D:68 vlan_id 1 \
> 		action gate index 1 base-time 0 \
> 			sched-entry CLOSE 6000 3 -1

I believe there is one extra level of indentation here than you
intended. Also, since we're speaking of examples. Would you be kind
enough to create a new selftest where you demonstrate the tc-gate
functionality? You can easily base that selftest on
tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh which
uses a loopback scheme with the 4 switch ports. And because you would be
using ports in loopback, you don't even need to run PTP, because the
sender, receiver and switch ports will all be in sync with one another,
as they share the same PHC.

What I would like to see is:

           swp0          |        swp1       |    swp2     |   swp3
---------------------------------------------------------------------
           Sender             ingress           egress
(scheduled with tc-taprio)    ------>   switch  -------->   Receiver
                           (tc-gate here)

If you have no better idea how to send time-based traffic and you can't
get mausezahn to do that either (I don't think you can), you can use
isochron:
https://github.com/vladimiroltean/tsn-scripts/tree/isochron/isochron

Once you do that, everybody will have a good understanding of how to use
it, as well as a working example and not just a wall of text.

>=20
> Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
> ---
>  drivers/net/dsa/ocelot/Makefile        |   3 +-
>  drivers/net/dsa/ocelot/felix.c         |  23 +
>  drivers/net/dsa/ocelot/felix.h         |  16 +
>  drivers/net/dsa/ocelot/felix_flower.c  | 651 +++++++++++++++++++++++++
>  drivers/net/dsa/ocelot/felix_vsc9959.c |  10 +-
>  include/soc/mscc/ocelot_ana.h          |  10 +
>  6 files changed, 709 insertions(+), 4 deletions(-)
>  create mode 100644 drivers/net/dsa/ocelot/felix_flower.c
>=20
> diff --git a/drivers/net/dsa/ocelot/Makefile b/drivers/net/dsa/ocelot/Mak=
efile
> index f6dd131e7491..22f3f98914e3 100644
> --- a/drivers/net/dsa/ocelot/Makefile
> +++ b/drivers/net/dsa/ocelot/Makefile
> @@ -4,7 +4,8 @@ obj-$(CONFIG_NET_DSA_MSCC_SEVILLE) +=3D mscc_seville.o
> =20
>  mscc_felix-objs :=3D \
>  	felix.o \
> -	felix_vsc9959.o
> +	felix_vsc9959.o \
> +	felix_flower.o
> =20
>  mscc_seville-objs :=3D \
>  	felix.o \
> diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/feli=
x.c
> index f791860d495f..42f972d10539 100644
> --- a/drivers/net/dsa/ocelot/felix.c
> +++ b/drivers/net/dsa/ocelot/felix.c
> @@ -716,6 +716,13 @@ static int felix_cls_flower_add(struct dsa_switch *d=
s, int port,
>  				struct flow_cls_offload *cls, bool ingress)
>  {
>  	struct ocelot *ocelot =3D ds->priv;
> +	struct felix *felix =3D ocelot_to_felix(ocelot);
> +
> +	if (felix->info->flower_replace) {
> +		if (cls->common.chain_index =3D=3D OCELOT_PSFP_CHAIN)
> +			return felix->info->flower_replace(ocelot, port, cls,
> +							   ingress);
> +	}
> =20
>  	return ocelot_cls_flower_replace(ocelot, port, cls, ingress);
>  }
> @@ -724,6 +731,14 @@ static int felix_cls_flower_del(struct dsa_switch *d=
s, int port,
>  				struct flow_cls_offload *cls, bool ingress)
>  {
>  	struct ocelot *ocelot =3D ds->priv;
> +	struct felix *felix =3D ocelot_to_felix(ocelot);
> +	int ret;
> +
> +	if (felix->info->flower_destroy) {
> +		ret =3D felix->info->flower_destroy(ocelot, port, cls, ingress);
> +		if (!ret)
> +			return 0;

To be honest I don't particularly enjoy having these function pointers
mask the functionality from mscc_ocelot like this. For example here. If
felix->info->flower_destroy for a PSFP rule returns an error, what you
do is you go ahead and call ocelot_cls_flower_destroy which is incorrect,
you should just return that error code to the user.

Have you tried putting these ops for the PSFP chain in struct
ocelot_ops, and just let ocelot_flower.c check the chain number and the
presence of those function pointers? The code path would be:

slave.c: dsa_slave_add_cls_flower
-> felix.c: felix_cls_flower_add
   -> ocelot_flower.c: ocelot_cls_flower_replace
      -> felix_vsc9959.c: pick a name here (vsc9959_gate_entry_add ?)

I recommend implementing the features that are only available on the
VSC9959 hardware in felix_vsc9959.c. Then, when new hardware will come
and we'll have a real idea of what's common and what isn't (unlike now
when we would just be guessing), and we'll refactor appropriately like
we did with the Lynx PCS. But that doesn't mean we should completely
bypass ocelot_flower.c.

> +	}
> =20
>  	return ocelot_cls_flower_destroy(ocelot, port, cls, ingress);
>  }
> @@ -732,6 +747,14 @@ static int felix_cls_flower_stats(struct dsa_switch =
*ds, int port,
>  				  struct flow_cls_offload *cls, bool ingress)
>  {
>  	struct ocelot *ocelot =3D ds->priv;
> +	struct felix *felix =3D ocelot_to_felix(ocelot);
> +	int ret;
> +
> +	if (felix->info->flower_stats) {
> +		ret =3D felix->info->flower_stats(ocelot, port, cls, ingress);
> +		if (!ret)
> +			return 0;
> +	}
> =20
>  	return ocelot_cls_flower_stats(ocelot, port, cls, ingress);
>  }
> diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/feli=
x.h
> index 4c717324ac2f..9ea880deb2a0 100644
> --- a/drivers/net/dsa/ocelot/felix.h
> +++ b/drivers/net/dsa/ocelot/felix.h
> @@ -37,6 +37,12 @@ struct felix_info {
>  	void	(*port_sched_speed_set)(struct ocelot *ocelot, int port,
>  					u32 speed);
>  	void	(*xmit_template_populate)(struct ocelot *ocelot, int port);
> +	int	(*flower_replace)(struct ocelot *ocelot, int port,
> +				  struct flow_cls_offload *f, bool ingress);
> +	int	(*flower_destroy)(struct ocelot *ocelot, int port,
> +				  struct flow_cls_offload *f, bool ingress);
> +	int	(*flower_stats)(struct ocelot *ocelot, int port,
> +				struct flow_cls_offload *f, bool ingress);
>  };
> =20
>  extern const struct dsa_switch_ops felix_switch_ops;
> @@ -55,4 +61,14 @@ struct felix {
>  struct net_device *felix_port_to_netdev(struct ocelot *ocelot, int port)=
;
>  int felix_netdev_to_port(struct net_device *dev);
> =20
> +void vsc9959_new_base_time(struct ocelot *ocelot, ktime_t base_time,
> +			   u64 cycle_time, struct timespec64 *new_base_ts);
> +int felix_flower_stream_replace(struct ocelot *ocelot, int port,
> +				struct flow_cls_offload *f, bool ingress);
> +int felix_flower_stream_destroy(struct ocelot *ocelot, int port,
> +				struct flow_cls_offload *f, bool ingress);
> +int felix_flower_stream_stats(struct ocelot *ocelot, int port,
> +			      struct flow_cls_offload *f, bool ingress);
> +void felix_psfp_init(struct ocelot *ocelot);
> +
>  #endif
> diff --git a/drivers/net/dsa/ocelot/felix_flower.c b/drivers/net/dsa/ocel=
ot/felix_flower.c
> new file mode 100644
> index 000000000000..71894dcc0af2
> --- /dev/null
> +++ b/drivers/net/dsa/ocelot/felix_flower.c
> @@ -0,0 +1,651 @@
> +// SPDX-License-Identifier: (GPL-2.0 OR MIT)
> +/* Copyright 2020 NXP Semiconductors
> + */
> +#include <soc/mscc/ocelot_ana.h>
> +#include <soc/mscc/ocelot_sys.h>
> +#include <net/tc_act/tc_gate.h>
> +#include <net/flow_offload.h>
> +#include <soc/mscc/ocelot.h>
> +#include <net/pkt_sched.h>
> +#include "felix.h"
> +
> +#define FELIX_PSFP_SFID_MAX		175
> +#define FELIX_PSFP_GATE_ID_MAX		183
> +#define FELIX_POLICER_PSFP_BASE		63
> +#define FELIX_POLICER_PSFP_MAX		383
> +#define FELIX_PSFP_GATE_LIST_NUM	4
> +#define FELIX_PSFP_GATE_CYCLETIME_MIN	5000
> +
> +struct felix_streamid {
> +	struct list_head list;
> +	u32 id;
> +	u8 dmac[ETH_ALEN];
> +	u16 vid;
> +	s8 prio;
> +	u8 sfid_valid;
> +	u32 sfid;
> +};
> +
> +struct felix_stream_gate_conf {
> +	u32 index;
> +	u8 enable;
> +	u8 ipv_valid;
> +	u8 init_ipv;
> +	u64 basetime;
> +	u64 cycletime;
> +	u64 cycletimext;
> +	u32 num_entries;
> +	struct action_gate_entry entries[0];
> +};
> +
> +struct felix_stream_filter {
> +	struct list_head list;
> +	refcount_t refcount;
> +	u32 index;
> +	u8 enable;
> +	u8 sg_valid;
> +	u32 sgid;
> +	u8 fm_valid;
> +	u32 fmid;
> +	u8 prio_valid;
> +	u8 prio;
> +	u32 maxsdu;
> +};
> +
> +struct felix_stream_gate {
> +	struct list_head list;
> +	refcount_t refcount;
> +	u32 index;
> +};
> +
> +struct felix_psfp_stream_counters {
> +	u32 match;
> +	u32 not_pass_gate;
> +	u32 not_pass_sdu;
> +	u32 red;
> +};
> +
> +struct felix_psfp_list {
> +	struct list_head stream_list;
> +	struct list_head gate_list;
> +	struct list_head sfi_list;
> +};
> +
> +static struct felix_psfp_list lpsfp;
> +
> +static u32 felix_sg_cfg_status(struct ocelot *ocelot)
> +{
> +	return ocelot_read(ocelot, ANA_SG_ACCESS_CTRL);
> +}
> +
> +static int felix_hw_sgi_set(struct ocelot *ocelot,
> +			    struct felix_stream_gate_conf *sgi)
> +{
> +	struct action_gate_entry *e;
> +	struct timespec64 base_ts;
> +	u32 interval_sum =3D 0;
> +	u32 val;
> +	int i;
> +
> +	if (sgi->index > FELIX_PSFP_GATE_ID_MAX)
> +		return -EINVAL;
> +
> +	ocelot_write(ocelot, ANA_SG_ACCESS_CTRL_SGID(sgi->index),
> +		     ANA_SG_ACCESS_CTRL);
> +
> +	if (!sgi->enable) {
> +		ocelot_rmw(ocelot, ANA_SG_CONFIG_REG_3_INIT_GATE_STATE,
> +			   ANA_SG_CONFIG_REG_3_INIT_GATE_STATE |
> +			   ANA_SG_CONFIG_REG_3_GATE_ENABLE,
> +			   ANA_SG_CONFIG_REG_3);
> +
> +		return 0;
> +	}
> +
> +	if (sgi->cycletime < FELIX_PSFP_GATE_CYCLETIME_MIN ||
> +	    sgi->cycletime > NSEC_PER_SEC)
> +		return -EINVAL;
> +
> +	if (sgi->num_entries > FELIX_PSFP_GATE_LIST_NUM)
> +		return -EINVAL;
> +
> +	vsc9959_new_base_time(ocelot, sgi->basetime, sgi->cycletime, &base_ts);

See, either you rename vsc9959_new_base_time to something more generic
(in my opinion you could even provide this functionality as part of the
tc-taprio API, as long as you replace "struct ocelot *ocelot" with
"u64 now"), or you move the entire felix_flower.c into felix_vsc9959.c,
or you rename felix_flower.c into felix_vsc9959_flower.c to indicate
that it is hardware-specific functionality and not common with seville
(which does use felix.c but would not use felix_flower.c).

> +	ocelot_write(ocelot, base_ts.tv_nsec, ANA_SG_CONFIG_REG_1);
> +	val =3D lower_32_bits(base_ts.tv_sec);
> +	ocelot_write(ocelot, val, ANA_SG_CONFIG_REG_2);
> +
> +	val =3D upper_32_bits(base_ts.tv_sec);
> +	ocelot_write(ocelot,
> +		     (sgi->ipv_valid ? ANA_SG_CONFIG_REG_3_IPV_VALID : 0) |
> +		     ANA_SG_CONFIG_REG_3_INIT_IPV(sgi->init_ipv) |
> +		     ANA_SG_CONFIG_REG_3_GATE_ENABLE |
> +		     ANA_SG_CONFIG_REG_3_LIST_LENGTH(sgi->num_entries) |
> +		     ANA_SG_CONFIG_REG_3_INIT_GATE_STATE |
> +		     ANA_SG_CONFIG_REG_3_BASE_TIME_SEC_MSB(val),
> +		     ANA_SG_CONFIG_REG_3);
> +
> +	ocelot_write(ocelot, sgi->cycletime, ANA_SG_CONFIG_REG_4);
> +
> +	e =3D sgi->entries;
> +	for (i =3D 0; i < sgi->num_entries; i++) {
> +		u32 ips =3D (e[i].ipv < 0) ? 0 : (e[i].ipv + 8);
> +
> +		ocelot_write_rix(ocelot, ANA_SG_GCL_GS_CONFIG_IPS(ips) |
> +				 (e[i].gate_state ?
> +				  ANA_SG_GCL_GS_CONFIG_GATE_STATE : 0),
> +				 ANA_SG_GCL_GS_CONFIG, i);
> +
> +		interval_sum +=3D e[i].interval;
> +		ocelot_write_rix(ocelot, interval_sum, ANA_SG_GCL_TI_CONFIG, i);
> +	}
> +
> +	ocelot_rmw(ocelot, ANA_SG_ACCESS_CTRL_CONFIG_CHANGE,
> +		   ANA_SG_ACCESS_CTRL_CONFIG_CHANGE,
> +		   ANA_SG_ACCESS_CTRL);
> +
> +	return readx_poll_timeout(felix_sg_cfg_status, ocelot, val,
> +				  (!(ANA_SG_ACCESS_CTRL_CONFIG_CHANGE & val)),
> +				  10, 100000);
> +}
> +
> +static u32 felix_sfi_access_status(struct ocelot *ocelot)
> +{
> +	return ocelot_read(ocelot, ANA_TABLES_SFIDACCESS);
> +}
> +
> +static int felix_hw_sfi_set(struct ocelot *ocelot,
> +			    struct felix_stream_filter *sfi)
> +{
> +	u32 val;
> +
> +	if (sfi->index > FELIX_PSFP_SFID_MAX)
> +		return -EINVAL;
> +
> +	if (!sfi->enable) {
> +		ocelot_write(ocelot, ANA_TABLES_SFIDTIDX_SFID_INDEX(sfi->index),
> +			     ANA_TABLES_SFIDTIDX);
> +
> +		val =3D ANA_TABLES_SFIDACCESS_SFID_TBL_CMD(SFIDACCESS_CMD_WRITE);
> +		ocelot_write(ocelot, val, ANA_TABLES_SFIDACCESS);
> +
> +		return readx_poll_timeout(felix_sfi_access_status, ocelot, val,
> +					  (!ANA_TABLES_SFIDACCESS_SFID_TBL_CMD(val)),
> +					  10, 100000);
> +	}
> +
> +	if (sfi->sgid > FELIX_PSFP_GATE_ID_MAX ||
> +	    sfi->fmid > FELIX_POLICER_PSFP_MAX)
> +		return -EINVAL;
> +
> +	ocelot_write(ocelot,
> +		     (sfi->sg_valid ? ANA_TABLES_SFIDTIDX_SGID_VALID : 0) |
> +		     ANA_TABLES_SFIDTIDX_SGID(sfi->sgid) |
> +		     (sfi->fm_valid ? ANA_TABLES_SFIDTIDX_POL_ENA : 0) |
> +		     ANA_TABLES_SFIDTIDX_POL_IDX(sfi->fmid) |
> +		     ANA_TABLES_SFIDTIDX_SFID_INDEX(sfi->index),
> +		     ANA_TABLES_SFIDTIDX);
> +
> +	ocelot_write(ocelot,
> +		     (sfi->prio_valid ? ANA_TABLES_SFIDACCESS_IGR_PRIO_MATCH_ENA : 0) =
|
> +		     ANA_TABLES_SFIDACCESS_IGR_PRIO(sfi->prio) |
> +		     ANA_TABLES_SFIDACCESS_MAX_SDU_LEN(sfi->maxsdu) |
> +		     ANA_TABLES_SFIDACCESS_SFID_TBL_CMD(SFIDACCESS_CMD_WRITE),
> +		     ANA_TABLES_SFIDACCESS);
> +
> +	return readx_poll_timeout(felix_sfi_access_status, ocelot, val,
> +				  (!ANA_TABLES_SFIDACCESS_SFID_TBL_CMD(val)),
> +				  10, 100000);
> +}
> +
> +static u32 felix_mact_status(struct ocelot *ocelot)
> +{
> +	return ocelot_read(ocelot, ANA_TABLES_MACACCESS);
> +}
> +
> +static int felix_mact_stream_update(struct ocelot *ocelot,
> +				    struct felix_streamid *stream,
> +				    struct netlink_ext_ack *extack)
> +{
> +	u32 row, col, reg, val;
> +	u8 type;
> +	int ret;
> +
> +	/* Stream identification desn't support to add a stream with non
> +	 * existent MAC (The MAC entry has not been learned in MAC table).
> +	 * return -EOPNOTSUPP to continue offloading to other modules.
> +	 */
> +	ret =3D ocelot_mact_lookup(ocelot, stream->dmac, stream->vid, &row, &co=
l);
> +	if (ret) {
> +		if (extack)
> +			NL_SET_ERR_MSG_MOD(extack, "Stream is not learned in MAC table");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	ocelot_rmw(ocelot,
> +		   (stream->sfid_valid ? ANA_TABLES_STREAMDATA_SFID_VALID : 0) |
> +		   ANA_TABLES_STREAMDATA_SFID(stream->sfid),
> +		   ANA_TABLES_STREAMDATA_SFID_VALID |
> +		   ANA_TABLES_STREAMDATA_SFID_M,
> +		   ANA_TABLES_STREAMDATA);
> +
> +	reg =3D ocelot_read(ocelot, ANA_TABLES_STREAMDATA);
> +	reg &=3D (ANA_TABLES_STREAMDATA_SFID_VALID | ANA_TABLES_STREAMDATA_SSID=
_VALID);
> +	type =3D (reg ? ENTRYTYPE_LOCKED : ENTRYTYPE_NORMAL);
> +	ocelot_rmw(ocelot,  ANA_TABLES_MACACCESS_VALID |
> +		   ANA_TABLES_MACACCESS_ENTRYTYPE(type) |
> +		   ANA_TABLES_MACACCESS_MAC_TABLE_CMD(MACACCESS_CMD_WRITE),
> +		   ANA_TABLES_MACACCESS_VALID |
> +		   ANA_TABLES_MACACCESS_ENTRYTYPE_M |
> +		   ANA_TABLES_MACACCESS_MAC_TABLE_CMD_M,
> +		   ANA_TABLES_MACACCESS);
> +
> +	return readx_poll_timeout(felix_mact_status, ocelot, val,
> +				  (!ANA_TABLES_MACACCESS_MAC_TABLE_CMD(val)),
> +				  10, 100000);
> +}
> +
> +static void felix_stream_counters_get(struct ocelot *ocelot, u32 index,
> +				      struct felix_psfp_stream_counters *counters)
> +{
> +	ocelot_rmw(ocelot, SYS_STAT_CFG_STAT_VIEW(index),
> +		   SYS_STAT_CFG_STAT_VIEW_M,
> +		   SYS_STAT_CFG);
> +
> +	counters->match =3D ocelot_read_gix(ocelot, SYS_CNT, 0x200);
> +	counters->not_pass_gate =3D ocelot_read_gix(ocelot, SYS_CNT, 0x201);
> +	counters->not_pass_sdu =3D ocelot_read_gix(ocelot, SYS_CNT, 0x202);
> +	counters->red =3D ocelot_read_gix(ocelot, SYS_CNT, 0x203);
> +}
> +
> +static int felix_list_gate_add(struct ocelot *ocelot,
> +			       struct felix_stream_gate_conf *sgi)
> +{
> +	struct felix_stream_gate *gate, *tmp;
> +	struct list_head *pos, *q;
> +	int ret;
> +
> +	list_for_each_safe(pos, q, &lpsfp.gate_list) {
> +		tmp =3D list_entry(pos, struct felix_stream_gate, list);
> +		if (tmp->index =3D=3D sgi->index) {
> +			refcount_inc(&tmp->refcount);
> +			return 0;
> +		}
> +		if (tmp->index > sgi->index)
> +			break;
> +	}
> +
> +	ret =3D felix_hw_sgi_set(ocelot, sgi);
> +	if (ret)
> +		return ret;
> +
> +	gate =3D kzalloc(sizeof(*gate), GFP_KERNEL);
> +	if (!gate)
> +		return -ENOMEM;
> +
> +	gate->index =3D sgi->index;
> +	refcount_set(&gate->refcount, 1);
> +	list_add(&gate->list, pos->prev);
> +
> +	return 0;
> +}
> +
> +static void felix_list_gate_del(struct ocelot *ocelot, u32 index)
> +{
> +	struct felix_stream_gate *tmp;
> +	struct felix_stream_gate_conf sgi;
> +	struct list_head *pos, *q;
> +	u8 z;
> +
> +	list_for_each_safe(pos, q, &lpsfp.gate_list) {
> +		tmp =3D list_entry(pos, struct felix_stream_gate, list);
> +		if (tmp->index =3D=3D index) {
> +			z =3D refcount_dec_and_test(&tmp->refcount);
> +			if (z) {
> +				sgi.index =3D index;
> +				sgi.enable =3D 0;
> +				felix_hw_sgi_set(ocelot, &sgi);
> +				list_del(pos);
> +				kfree(tmp);
> +			}
> +			break;
> +		}
> +	}
> +}
> +
> +static int felix_list_stream_filter_add(struct ocelot *ocelot,
> +					struct felix_stream_filter *sfi)
> +{
> +	struct felix_stream_filter *sfi_entry, *tmp;
> +	struct list_head *last =3D &lpsfp.sfi_list;
> +	struct list_head *pos, *q;
> +	u32 insert =3D 0;
> +	int ret;
> +
> +	list_for_each_safe(pos, q, &lpsfp.sfi_list) {
> +		tmp =3D list_entry(pos, struct felix_stream_filter, list);
> +		if (sfi->sg_valid =3D=3D tmp->sg_valid &&
> +		    tmp->sgid =3D=3D sfi->sgid &&
> +		    tmp->fmid =3D=3D sfi->fmid) {
> +			sfi->index =3D tmp->index;
> +			refcount_inc(&tmp->refcount);
> +			return 0;
> +		}
> +		if (tmp->index =3D=3D insert) {
> +			last =3D pos;
> +			insert++;
> +		}
> +	}
> +	sfi->index =3D insert;
> +	ret =3D felix_hw_sfi_set(ocelot, sfi);
> +	if (ret)
> +		return ret;
> +
> +	sfi_entry =3D kzalloc(sizeof(*sfi_entry), GFP_KERNEL);
> +	if (!sfi_entry)
> +		return -ENOMEM;
> +
> +	memcpy(sfi_entry, sfi, sizeof(*sfi_entry));
> +	refcount_set(&sfi_entry->refcount, 1);
> +
> +	list_add(&sfi_entry->list, last->next);
> +
> +	return 0;
> +}
> +
> +static void felix_list_stream_filter_del(struct ocelot *ocelot, u32 inde=
x)
> +{
> +	struct felix_stream_filter *tmp;
> +	struct list_head *pos, *q;
> +	u8 z;
> +
> +	list_for_each_safe(pos, q, &lpsfp.sfi_list) {
> +		tmp =3D list_entry(pos, struct felix_stream_filter, list);
> +		if (tmp->index =3D=3D index) {
> +			if (tmp->sg_valid)
> +				felix_list_gate_del(ocelot, tmp->sgid);
> +
> +			z =3D refcount_dec_and_test(&tmp->refcount);
> +			if (z) {
> +				tmp->enable =3D 0;
> +				felix_hw_sfi_set(ocelot, tmp);
> +				list_del(pos);
> +				kfree(tmp);
> +			}
> +			break;
> +		}
> +	}
> +}
> +
> +static int felix_list_stream_add(struct felix_streamid *stream)
> +{
> +	struct felix_streamid *stream_entry;
> +	struct list_head *pos;
> +
> +	stream_entry =3D kzalloc(sizeof(*stream_entry), GFP_KERNEL);
> +	if (!stream_entry)
> +		return -ENOMEM;
> +
> +	memcpy(stream_entry, stream, sizeof(*stream_entry));
> +
> +	if (list_empty(&lpsfp.stream_list)) {
> +		list_add(&stream_entry->list, &lpsfp.stream_list);
> +		return 0;
> +	}
> +
> +	pos =3D &lpsfp.stream_list;
> +	list_add(&stream_entry->list, pos->prev);
> +
> +	return 0;
> +}
> +
> +static int felix_list_stream_lookup(struct felix_streamid *stream)
> +{
> +	struct felix_streamid *tmp;
> +
> +	list_for_each_entry(tmp, &lpsfp.stream_list, list) {
> +		if (tmp->dmac[0] =3D=3D stream->dmac[0] &&
> +		    tmp->dmac[1] =3D=3D stream->dmac[1] &&
> +		    tmp->dmac[2] =3D=3D stream->dmac[2] &&
> +		    tmp->dmac[3] =3D=3D stream->dmac[3] &&
> +		    tmp->dmac[4] =3D=3D stream->dmac[4] &&
> +		    tmp->dmac[5] =3D=3D stream->dmac[5] &&

ether_addr_equal

Did you even read the internal review comments?

> +		    tmp->vid =3D=3D stream->vid &&
> +		    (tmp->sfid_valid & stream->sfid_valid))
> +			return 0;
> +	}
> +
> +	return -ENOENT;
> +}
> +
> +static struct felix_streamid *felix_list_stream_get(u32 id)
> +{
> +	struct felix_streamid *tmp;
> +	struct list_head *pos, *q;
> +
> +	list_for_each_safe(pos, q, &lpsfp.stream_list) {
> +		tmp =3D list_entry(pos, struct felix_streamid, list);

list_for_each_entry

Please revise the way you use the kernel lists API, I won't go over the
whole file with these comments because it would pollute the entire
discussion.

> +		if (tmp->id =3D=3D id)
> +			return tmp;
> +	}
> +
> +	return NULL;
> +}
> +
> +static int felix_list_stream_del(struct ocelot *ocelot, u32 id)
> +{
> +	struct felix_streamid *tmp;
> +	struct list_head *pos, *q;
> +
> +	list_for_each_safe(pos, q, &lpsfp.stream_list) {
> +		tmp =3D list_entry(pos, struct felix_streamid, list);
> +		if (tmp->id =3D=3D id) {
> +			tmp->sfid_valid =3D 0;
> +			felix_list_stream_filter_del(ocelot, tmp->sfid);
> +			felix_mact_stream_update(ocelot, tmp, NULL);
> +			list_del(pos);
> +			kfree(tmp);
> +
> +			return 0;
> +		}
> +	}
> +
> +	return -ENOENT;
> +}
> +
> +static int felix_psfp_set(struct ocelot *ocelot,
> +			  struct felix_streamid *stream,
> +			  struct felix_stream_filter *sfi,
> +			  struct netlink_ext_ack *extack)
> +{
> +	int ret;
> +
> +	sfi->prio_valid =3D (stream->prio < 0 ? 0 : 1);
> +	sfi->prio =3D (sfi->prio_valid ? stream->prio : 0);
> +	sfi->enable =3D 1;
> +	ret =3D felix_list_stream_filter_add(ocelot, sfi);
> +	if (ret) {
> +		if (sfi->sg_valid)
> +			felix_list_gate_del(ocelot, sfi->sgid);
> +		return ret;
> +	}
> +
> +	stream->sfid =3D sfi->index;
> +	ret =3D felix_mact_stream_update(ocelot, stream, extack);
> +	if (ret) {
> +		felix_list_stream_filter_del(ocelot, sfi->index);
> +		return ret;
> +	}
> +
> +	ret =3D felix_list_stream_add(stream);
> +	if (ret)
> +		felix_list_stream_filter_del(ocelot, sfi->index);
> +
> +	return ret;
> +}
> +
> +static void felix_parse_gate(const struct flow_action_entry *entry,
> +			     struct felix_stream_gate_conf *sgi)
> +{
> +	struct action_gate_entry *e;
> +	int i;
> +
> +	sgi->index =3D entry->gate.index;
> +	sgi->ipv_valid =3D (entry->gate.prio < 0) ? 0 : 1;
> +	sgi->init_ipv =3D (sgi->ipv_valid) ? entry->gate.prio : 0;
> +	sgi->basetime =3D entry->gate.basetime;
> +	sgi->cycletime =3D entry->gate.cycletime;
> +	sgi->num_entries =3D entry->gate.num_entries;
> +	sgi->enable =3D 1;
> +
> +	e =3D sgi->entries;
> +	for (i =3D 0; i < entry->gate.num_entries; i++) {
> +		e[i].gate_state =3D entry->gate.entries[i].gate_state;
> +		e[i].interval =3D entry->gate.entries[i].interval;
> +		e[i].ipv =3D entry->gate.entries[i].ipv;
> +		e[i].maxoctets =3D entry->gate.entries[i].maxoctets;
> +	}
> +}
> +
> +static int felix_flower_parse_key(struct flow_cls_offload *f,
> +				  struct felix_streamid *stream)
> +{
> +	struct flow_rule *rule =3D flow_cls_offload_flow_rule(f);
> +	struct flow_dissector *dissector =3D rule->match.dissector;
> +
> +	if (dissector->used_keys &
> +	    ~(BIT(FLOW_DISSECTOR_KEY_CONTROL) |
> +	      BIT(FLOW_DISSECTOR_KEY_BASIC) |
> +	      BIT(FLOW_DISSECTOR_KEY_VLAN) |
> +	      BIT(FLOW_DISSECTOR_KEY_ETH_ADDRS)))
> +		return -EOPNOTSUPP;
> +
> +	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ETH_ADDRS)) {
> +		struct flow_match_eth_addrs match;
> +
> +		flow_rule_match_eth_addrs(rule, &match);
> +		ether_addr_copy(stream->dmac, match.key->dst);
> +		if (!is_zero_ether_addr(match.mask->src))
> +			return -EOPNOTSUPP;
> +	} else {
> +		return -EOPNOTSUPP;
> +	}
> +
> +	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_VLAN)) {
> +		struct flow_match_vlan match;
> +
> +		flow_rule_match_vlan(rule, &match);
> +		if (match.mask->vlan_priority)
> +			stream->prio =3D match.key->vlan_priority;
> +		else
> +			stream->prio =3D -1;
> +
> +		if (!match.mask->vlan_id)
> +			return -EOPNOTSUPP;
> +		stream->vid =3D match.key->vlan_id;
> +	} else {
> +		return -EOPNOTSUPP;
> +	}
> +
> +	stream->id =3D f->cookie;
> +
> +	return 0;
> +}
> +
> +int felix_flower_stream_replace(struct ocelot *ocelot, int port,
> +				struct flow_cls_offload *f, bool ingress)
> +{
> +	struct netlink_ext_ack *extack =3D f->common.extack;
> +	struct felix_stream_filter sfi =3D {0};
> +	struct felix_streamid stream =3D {0};
> +	struct felix_stream_gate_conf *sgi;
> +	const struct flow_action_entry *a;
> +	int ret, size, i;
> +	u32 index;
> +
> +	ret =3D felix_flower_parse_key(f, &stream);
> +	if (ret) {
> +		NL_SET_ERR_MSG_MOD(extack, "Only can match on VID, PCP, and dest MAC")=
;
> +		return ret;
> +	}
> +
> +	if (!flow_action_basic_hw_stats_check(&f->rule->action,
> +					      f->common.extack))
> +		return -EOPNOTSUPP;
> +
> +	flow_action_for_each(i, a, &f->rule->action) {
> +		switch (a->id) {
> +		case FLOW_ACTION_GATE:
> +			if (f->common.chain_index !=3D OCELOT_PSFP_CHAIN) {
> +				NL_SET_ERR_MSG_MOD(extack,
> +						   "Gate action only be offloaded to PSFP chain");
> +				return -EOPNOTSUPP;
> +			}
> +
> +			size =3D struct_size(sgi, entries, a->gate.num_entries);
> +			sgi =3D kzalloc(size, GFP_KERNEL);
> +			felix_parse_gate(a, sgi);
> +			ret =3D felix_list_gate_add(ocelot, sgi);
> +			if (ret) {
> +				kfree(sgi);
> +				return ret;
> +			}
> +
> +			sfi.sg_valid =3D 1;
> +			sfi.sgid =3D sgi->index;
> +			stream.sfid_valid =3D 1;
> +			kfree(sgi);
> +			break;
> +		default:
> +			return -EOPNOTSUPP;
> +		}
> +	}
> +
> +	/* Check if stream is set. */
> +	ret =3D felix_list_stream_lookup(&stream);
> +	if (!ret) {
> +		if (sfi.sg_valid)
> +			felix_list_gate_del(ocelot, sfi.sgid);
> +
> +		NL_SET_ERR_MSG_MOD(extack, "This stream is already added");
> +
> +		return -EEXIST;
> +	}
> +
> +	if (stream.sfid_valid)
> +		return felix_psfp_set(ocelot, &stream, &sfi, extack);
> +
> +	return -EOPNOTSUPP;
> +}
> +
> +int felix_flower_stream_destroy(struct ocelot *ocelot, int port,
> +				struct flow_cls_offload *f, bool ingress)
> +{
> +	return felix_list_stream_del(ocelot, f->cookie);
> +}
> +
> +int felix_flower_stream_stats(struct ocelot *ocelot, int port,
> +			      struct flow_cls_offload *f, bool ingress)
> +{
> +	struct felix_psfp_stream_counters counters;
> +	struct felix_streamid *stream;
> +	struct flow_stats stats;
> +
> +	stream =3D felix_list_stream_get(f->cookie);
> +	if (!stream)
> +		return -ENOENT;
> +
> +	felix_stream_counters_get(ocelot, stream->sfid, &counters);
> +	stats.pkts =3D counters.match;
> +
> +	flow_stats_update(&f->stats, 0x0, stats.pkts, 0x0, 0,
> +			  FLOW_ACTION_HW_STATS_IMMEDIATE);
> +
> +	return 0;
> +}
> +
> +void felix_psfp_init(struct ocelot *ocelot)
> +{
> +	INIT_LIST_HEAD(&lpsfp.stream_list);
> +	INIT_LIST_HEAD(&lpsfp.gate_list);
> +	INIT_LIST_HEAD(&lpsfp.sfi_list);
> +}
> diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/oce=
lot/felix_vsc9959.c
> index 3e925b8d5306..f171e6f3fc98 100644
> --- a/drivers/net/dsa/ocelot/felix_vsc9959.c
> +++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
> @@ -931,6 +931,8 @@ static int vsc9959_reset(struct ocelot *ocelot)
>  	/* enable switch core */
>  	ocelot_field_write(ocelot, SYS_RESET_CFG_CORE_ENA, 1);
> =20
> +	felix_psfp_init(ocelot);
> +
>  	return 0;
>  }
> =20
> @@ -1150,9 +1152,8 @@ static void vsc9959_sched_speed_set(struct ocelot *=
ocelot, int port,
>  		       QSYS_TAG_CONFIG, port);
>  }
> =20
> -static void vsc9959_new_base_time(struct ocelot *ocelot, ktime_t base_ti=
me,
> -				  u64 cycle_time,
> -				  struct timespec64 *new_base_ts)
> +void vsc9959_new_base_time(struct ocelot *ocelot, ktime_t base_time,
> +			   u64 cycle_time, struct timespec64 *new_base_ts)
>  {
>  	struct timespec64 ts;
>  	ktime_t new_base_time;
> @@ -1370,6 +1371,9 @@ static const struct felix_info felix_info_vsc9959 =
=3D {
>  	.port_setup_tc		=3D vsc9959_port_setup_tc,
>  	.port_sched_speed_set	=3D vsc9959_sched_speed_set,
>  	.xmit_template_populate	=3D vsc9959_xmit_template_populate,
> +	.flower_replace		=3D felix_flower_stream_replace,
> +	.flower_destroy		=3D felix_flower_stream_destroy,
> +	.flower_stats		=3D felix_flower_stream_stats,
>  };
> =20
>  static irqreturn_t felix_irq_handler(int irq, void *data)
> diff --git a/include/soc/mscc/ocelot_ana.h b/include/soc/mscc/ocelot_ana.=
h
> index 1669481d9779..c5a0b7174518 100644
> --- a/include/soc/mscc/ocelot_ana.h
> +++ b/include/soc/mscc/ocelot_ana.h
> @@ -227,6 +227,11 @@
>  #define ANA_TABLES_SFIDACCESS_SFID_TBL_CMD(x)             ((x) & GENMASK=
(1, 0))
>  #define ANA_TABLES_SFIDACCESS_SFID_TBL_CMD_M              GENMASK(1, 0)
> =20
> +#define SFIDACCESS_CMD_IDLE                             0
> +#define SFIDACCESS_CMD_READ                             1
> +#define SFIDACCESS_CMD_WRITE                            2
> +#define SFIDACCESS_CMD_INIT				3
> +

Again, do you even read review comments?

>  #define ANA_TABLES_SFIDTIDX_SGID_VALID                    BIT(26)
>  #define ANA_TABLES_SFIDTIDX_SGID(x)                       (((x) << 18) &=
 GENMASK(25, 18))
>  #define ANA_TABLES_SFIDTIDX_SGID_M                        GENMASK(25, 18=
)
> @@ -255,6 +260,11 @@
>  #define ANA_SG_CONFIG_REG_3_INIT_IPS(x)                   (((x) << 21) &=
 GENMASK(24, 21))
>  #define ANA_SG_CONFIG_REG_3_INIT_IPS_M                    GENMASK(24, 21=
)
>  #define ANA_SG_CONFIG_REG_3_INIT_IPS_X(x)                 (((x) & GENMAS=
K(24, 21)) >> 21)
> +#define ANA_SG_CONFIG_REG_3_IPV_VALID                     BIT(24)
> +#define ANA_SG_CONFIG_REG_3_IPV_INVALID(x)		  (((x) << 24) & GENMASK(24,=
 24))
> +#define ANA_SG_CONFIG_REG_3_INIT_IPV(x)                   (((x) << 21) &=
 GENMASK(23, 21))
> +#define ANA_SG_CONFIG_REG_3_INIT_IPV_M                    GENMASK(23, 21=
)
> +#define ANA_SG_CONFIG_REG_3_INIT_IPV_X(x)                 (((x) & GENMAS=
K(23, 21)) >> 21)
>  #define ANA_SG_CONFIG_REG_3_INIT_GATE_STATE               BIT(25)
> =20
>  #define ANA_SG_GCL_GS_CONFIG_RSZ                          0x4
> --=20
> 2.17.1
> =
