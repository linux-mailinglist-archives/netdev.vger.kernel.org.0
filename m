Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31746172A2D
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 22:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729907AbgB0VcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 16:32:06 -0500
Received: from mail-eopbgr00104.outbound.protection.outlook.com ([40.107.0.104]:14829
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726758AbgB0VcG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 16:32:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LSmjbszMWAYLFEQ0DRPVlV6RDrTQZgMnD0pz3pyY+1Mg80vEa4QWTqVm/7Aqeh9oUDRoEHN3PPzS/D7miidxRu1lXmRfdaqoLuj8sZAoTjnopTECuRDzkbUWXxwfMeDC3qb17sEJkqTsn/RUq0pm9Kb7TRtQy50exkc74eyaAJY/IaDYW7H/Dia3tse69zUZZFE7fH21uFjnIGgSnxRsLdcscEF3AeB1r5fLt4iVVXiEuFRjuIyKieWjPj5fRE7I7wWBxVx4OyRF/8agSOdAckI0Rz/F7QbbCI3wS4ScMPzSUR5HnIJ9H3PnipM5auF3QnmNDtewc9tYPe4o6mdZjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JgwUI4KupbdEerdCDykgkPVezNuJXh+f3TEDsDDX3XA=;
 b=FPGfUqC3rwP3hrMQV5Gktb9Uw9vGZ1S6IKSYmMjtdhaWnp9hQtT23aUUNx+DD5/x7kn8XnlIcPakhgs4sm/rFbM2/eBsl+DiQM+CuuIO+FNPXLkLFb0EK7muffO0bokYjD5dAmHBMtSlqH3Xsu4CM2cIcLXaWlvW2D4afJsvGHzdJj9EoEL/mV956l7NRpmj6Q2hbgDvK2hUBvQPJ+FPw3govh4XQOU/P43lZsWjv8wxUL3C/6r6o92NrMQTEVvv7mXgyEI3xD4nO8Pck3kY3VmAZQhVquGl7WtO2vCfkdAH+pGWiRtGz8LGF3zrNrVFlb9DElRm3tS2gtVF64TpXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JgwUI4KupbdEerdCDykgkPVezNuJXh+f3TEDsDDX3XA=;
 b=AFRlZYqJpzf7/ojerpitbZhG78Wn74lMelnPPObcBne79GDXRFDWOsQQtLQecTfPX8enSs/olmyvWv7xf15GzubfzVdWIaX1wTTmF2T5MfczDhJJJhVaFk5vgPMReP4lq6kvXt6t+R/bHfSQXwkYPr+onsYV509GuB3XsumjTEk=
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM (10.165.195.138) by
 VI1P190MB0573.EURP190.PROD.OUTLOOK.COM (10.165.198.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.15; Thu, 27 Feb 2020 21:32:01 +0000
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::a587:f64e:cbb8:af96]) by VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::a587:f64e:cbb8:af96%4]) with mapi id 15.20.2772.012; Thu, 27 Feb 2020
 21:32:01 +0000
Received: from plvision.eu (217.20.186.93) by AM6P191CA0041.EURP191.PROD.OUTLOOK.COM (2603:10a6:209:7f::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14 via Frontend Transport; Thu, 27 Feb 2020 21:32:00 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>
Subject: Re: [RFC net-next 1/3] net: marvell: prestera: Add Switchdev driver
 for Prestera family ASIC device 98DX325x (AC3x)
Thread-Topic: [RFC net-next 1/3] net: marvell: prestera: Add Switchdev driver
 for Prestera family ASIC device 98DX325x (AC3x)
Thread-Index: AQHV6/jzY7yqWky1LUqTk1e6REHYB6gtohWAgAHwnQA=
Date:   Thu, 27 Feb 2020 21:32:00 +0000
Message-ID: <20200227213150.GA9372@plvision.eu>
References: <20200225163025.9430-1-vadym.kochan@plvision.eu>
 <20200225163025.9430-2-vadym.kochan@plvision.eu>
 <20200226155423.GC26061@nanopsycho>
In-Reply-To: <20200226155423.GC26061@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6P191CA0041.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:209:7f::18) To VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:35::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vadym.kochan@plvision.eu; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [217.20.186.93]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 82cec300-e8fc-44fd-8b84-08d7bbcc7afe
x-ms-traffictypediagnostic: VI1P190MB0573:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1P190MB0573D5B0C4543939C6F978F095EB0@VI1P190MB0573.EURP190.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 03264AEA72
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(136003)(366004)(396003)(376002)(39830400003)(199004)(189003)(2906002)(81166006)(16526019)(5660300002)(71200400001)(26005)(8936002)(186003)(508600001)(55016002)(4326008)(8886007)(81156014)(8676002)(1076003)(86362001)(66446008)(44832011)(6916009)(7696005)(107886003)(54906003)(52116002)(956004)(2616005)(66946007)(64756008)(66556008)(66476007)(316002)(36756003)(33656002);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1P190MB0573;H:VI1P190MB0399.EURP190.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: plvision.eu does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OqwZUBu69Ml8ZVmxAZam5KjduIpRXjDivfcE8PJLrqRFHYJV1qwkgYnj6V5vDY6/04jGXBVIMfxiT++kyoNmU6tlYmWB/tuWfo8uIqHZxo1ugKh74zZ6HLiNJToa60x51dsmUfoKredaNWWoipRx1nyycq6+Zj54Xsd4uDnu464DKwQD14R1ivXOtF0ScNJ/LPtfzPtRHUIHt7rPCiWgm01Rp7rOB4ixP2R7LKaZ1l6CfoNG69xNuEmL0yx2eLzTek3zQSFIDsb0mdc5PN6gqrbdqitlJEUPZ3FmGJKd+dPDeX7qkqFsZuyos/P9a+RHA1tH+F/cqL8H6u7lB6HDgdur4B4meMb96CfUby5fDk7nkulGtvLull8/+aW/VUIfqv9FTqyX0h+HgKpHBplwH4P/HTq7c7YZm0xnVIivAoBtEJNsk3zPwcpn1t+2NwXz
x-ms-exchange-antispam-messagedata: yQrhsu3UwRSOGNWh5Brhauieuq65lnW3oArtHoh6nVYmenTBuNruW/XXs74wVAA8Ps4vqQDYrqRvLLlTdRWFR7Pmy+lsGhKRqiqjyw/xDJec2bXeUOhBrMHfpWx+eicmzfg0CYgFOT7MCWpB5U1lkA==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CA7DB9B41122844891676B938ACCFE94@EURP190.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 82cec300-e8fc-44fd-8b84-08d7bbcc7afe
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Feb 2020 21:32:01.0177
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XOEGDdOunVrTqKVZ5L2XRToAPZNpH2fKH0/TEPDQKzJ6x5Qxt0APacWXB3og0mMyUbIy+hgEYn8lI5rCMcbiKC83sqNtKLpPRvzG/RhmZws=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0573
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiri,

On Wed, Feb 26, 2020 at 04:54:23PM +0100, Jiri Pirko wrote:
> Tue, Feb 25, 2020 at 05:30:54PM CET, vadym.kochan@plvision.eu wrote:
> >Marvell Prestera 98DX326x integrates up to 24 ports of 1GbE with 8
> >ports of 10GbE uplinks or 2 ports of 40Gbps stacking for a largely
> >wireless SMB deployment.
> >
> >This driver implementation includes only L1 & basic L2 support.
> >
> >The core Prestera switching logic is implemented in prestera.c, there is
> >an intermediate hw layer between core logic and firmware. It is
> >implemented in prestera_hw.c, the purpose of it is to encapsulate hw
> >related logic, in future there is a plan to support more devices with
> >different HW related configurations.
> >
> >The following Switchdev features are supported:
> >
> >    - VLAN-aware bridge offloading
> >    - VLAN-unaware bridge offloading
> >    - FDB offloading (learning, ageing)
> >    - Switchport configuration
> >
> >Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
> >Signed-off-by: Andrii Savka <andrii.savka@plvision.eu>
> >Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> >Signed-off-by: Serhiy Boiko <serhiy.boiko@plvision.eu>
> >Signed-off-by: Serhiy Pshyk <serhiy.pshyk@plvision.eu>
> >Signed-off-by: Taras Chornyi <taras.chornyi@plvision.eu>
> >Signed-off-by: Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
> >---
> > drivers/net/ethernet/marvell/Kconfig          |    1 +
> > drivers/net/ethernet/marvell/Makefile         |    1 +
> > drivers/net/ethernet/marvell/prestera/Kconfig |   13 +
> > .../net/ethernet/marvell/prestera/Makefile    |    3 +
> > .../net/ethernet/marvell/prestera/prestera.c  | 1502 +++++++++++++++++
> > .../net/ethernet/marvell/prestera/prestera.h  |  244 +++
> > .../marvell/prestera/prestera_drv_ver.h       |   23 +
> > .../ethernet/marvell/prestera/prestera_hw.c   | 1094 ++++++++++++
> > .../ethernet/marvell/prestera/prestera_hw.h   |  159 ++
> > .../marvell/prestera/prestera_switchdev.c     | 1217 +++++++++++++
> > 10 files changed, 4257 insertions(+)
> > create mode 100644 drivers/net/ethernet/marvell/prestera/Kconfig
> > create mode 100644 drivers/net/ethernet/marvell/prestera/Makefile
> > create mode 100644 drivers/net/ethernet/marvell/prestera/prestera.c
> > create mode 100644 drivers/net/ethernet/marvell/prestera/prestera.h
> > create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_drv_v=
er.h
> > create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_hw.c
> > create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_hw.h
> > create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_switc=
hdev.c
> >
> >diff --git a/drivers/net/ethernet/marvell/Kconfig b/drivers/net/ethernet=
/marvell/Kconfig
> >index 3d5caea096fb..74313d9e1fc0 100644
> >--- a/drivers/net/ethernet/marvell/Kconfig
> >+++ b/drivers/net/ethernet/marvell/Kconfig
> >@@ -171,5 +171,6 @@ config SKY2_DEBUG
> >=20
> >=20
> > source "drivers/net/ethernet/marvell/octeontx2/Kconfig"
> >+source "drivers/net/ethernet/marvell/prestera/Kconfig"
> >=20
> > endif # NET_VENDOR_MARVELL
> >diff --git a/drivers/net/ethernet/marvell/Makefile b/drivers/net/etherne=
t/marvell/Makefile
> >index 89dea7284d5b..9f88fe822555 100644
> >--- a/drivers/net/ethernet/marvell/Makefile
> >+++ b/drivers/net/ethernet/marvell/Makefile
> >@@ -12,3 +12,4 @@ obj-$(CONFIG_PXA168_ETH) +=3D pxa168_eth.o
> > obj-$(CONFIG_SKGE) +=3D skge.o
> > obj-$(CONFIG_SKY2) +=3D sky2.o
> > obj-y		+=3D octeontx2/
> >+obj-y		+=3D prestera/
> >diff --git a/drivers/net/ethernet/marvell/prestera/Kconfig b/drivers/net=
/ethernet/marvell/prestera/Kconfig
> >new file mode 100644
> >index 000000000000..d0b416dcb677
> >--- /dev/null
> >+++ b/drivers/net/ethernet/marvell/prestera/Kconfig
> >@@ -0,0 +1,13 @@
> >+# SPDX-License-Identifier: GPL-2.0-only
> >+#
> >+# Marvell Prestera drivers configuration
> >+#
> >+
> >+config PRESTERA
> >+	tristate "Marvell Prestera Switch ASICs support"
> >+	depends on NET_SWITCHDEV && VLAN_8021Q
> >+	---help---
> >+	  This driver supports Marvell Prestera Switch ASICs family.
> >+
> >+	  To compile this driver as a module, choose M here: the
> >+	  module will be called prestera_sw.
> >diff --git a/drivers/net/ethernet/marvell/prestera/Makefile b/drivers/ne=
t/ethernet/marvell/prestera/Makefile
> >new file mode 100644
> >index 000000000000..9446298fb7f4
> >--- /dev/null
> >+++ b/drivers/net/ethernet/marvell/prestera/Makefile
> >@@ -0,0 +1,3 @@
> >+# SPDX-License-Identifier: GPL-2.0
> >+obj-$(CONFIG_PRESTERA)	+=3D prestera_sw.o
> >+prestera_sw-objs	:=3D prestera.o prestera_hw.o prestera_switchdev.o
> >diff --git a/drivers/net/ethernet/marvell/prestera/prestera.c b/drivers/=
net/ethernet/marvell/prestera/prestera.c
> >new file mode 100644
> >index 000000000000..12d0eb590bbb
> >--- /dev/null
> >+++ b/drivers/net/ethernet/marvell/prestera/prestera.c
> >@@ -0,0 +1,1502 @@
> >+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
> >+ *
> >+ * Copyright (c) 2019-2020 Marvell International Ltd. All rights reserv=
ed.
> >+ *
> >+ */
> >+#include <linux/kernel.h>
> >+#include <linux/module.h>
> >+#include <linux/list.h>
> >+#include <linux/netdevice.h>
> >+#include <linux/netdev_features.h>
> >+#include <linux/etherdevice.h>
> >+#include <linux/ethtool.h>
> >+#include <linux/jiffies.h>
> >+#include <net/switchdev.h>
> >+
> >+#include "prestera.h"
> >+#include "prestera_hw.h"
> >+#include "prestera_drv_ver.h"
> >+
> >+#define MVSW_PR_MTU_DEFAULT 1536
> >+
> >+#define PORT_STATS_CACHE_TIMEOUT_MS	(msecs_to_jiffies(1000))
> >+#define PORT_STATS_CNT	(sizeof(struct mvsw_pr_port_stats) / sizeof(u64)=
)
>=20
> Keep the prefix for all defines withing the file. "PORT_STATS_CNT"
> looks way to generic on the first look.
>=20
>=20
> >+#define PORT_STATS_IDX(name) \
> >+	(offsetof(struct mvsw_pr_port_stats, name) / sizeof(u64))
> >+#define PORT_STATS_FIELD(name)	\
> >+	[PORT_STATS_IDX(name)] =3D __stringify(name)
> >+
> >+static struct list_head switches_registered;
> >+
> >+static const char mvsw_driver_kind[] =3D "prestera_sw";
>=20
> Please be consistent. Make your prefixes, name, filenames the same.
> For example:
> prestera_driver_kind[] =3D "prestera";
>=20
> Applied to the whole code.
>=20
So you suggested to use prestera_ as a prefix, I dont see a problem
with that, but why not mvsw_pr_ ? So it has the vendor, device name parts
together as a key. Also it is necessary to apply prefix for the static
names ?

>=20
> >+static const char mvsw_driver_name[] =3D "mvsw_switchdev";
>=20
> Why is this different from kind?
>=20
> Also, don't mention "switchdev" anywhere.
>=20
>=20
> >+static const char mvsw_driver_version[] =3D PRESTERA_DRV_VER;
>=20
> [...]
>=20
>=20
> >+static void mvsw_pr_port_remote_cap_get(struct ethtool_link_ksettings *=
ecmd,
> >+					struct mvsw_pr_port *port)
> >+{
> >+	u64 bitmap;
> >+
> >+	if (!mvsw_pr_hw_port_remote_cap_get(port, &bitmap)) {
> >+		mvsw_modes_to_eth(ecmd->link_modes.lp_advertising,
> >+				  bitmap, 0, MVSW_PORT_TYPE_NONE);
> >+	}
>=20
> Don't use {} for single statement. checkpatch.pl should warn you about
> this.
>=20
>=20
>=20
> >+}
> >+
> >+static void mvsw_pr_port_duplex_get(struct ethtool_link_ksettings *ecmd=
,
> >+				    struct mvsw_pr_port *port)
> >+{
> >+	u8 duplex;
> >+
> >+	if (!mvsw_pr_hw_port_duplex_get(port, &duplex)) {
> >+		ecmd->base.duplex =3D duplex =3D=3D MVSW_PORT_DUPLEX_FULL ?
> >+				    DUPLEX_FULL : DUPLEX_HALF;
> >+	} else {
> >+		ecmd->base.duplex =3D DUPLEX_UNKNOWN;
> >+	}
>=20
> Same here.
>=20
>=20
> >+}
>=20
> [...]
>=20
>=20
> >+static void __exit mvsw_pr_module_exit(void)
> >+{
> >+	destroy_workqueue(mvsw_pr_wq);
> >+
> >+	pr_info("Unloading Marvell Prestera Switch Driver\n");
>=20
> No prints like this please.
>=20
> =09
> =09
> >+}
> >+
> >+module_init(mvsw_pr_module_init);
> >+module_exit(mvsw_pr_module_exit);
> >+
> >+MODULE_AUTHOR("Marvell Semi.");
>=20
> Does not look so :)
>=20
>=20
> >+MODULE_LICENSE("GPL");
> >+MODULE_DESCRIPTION("Marvell Prestera switch driver");
> >+MODULE_VERSION(PRESTERA_DRV_VER);
>=20
> [...]

Thank you for the comments and suggestions!

Regards,
Vadym Kochan
