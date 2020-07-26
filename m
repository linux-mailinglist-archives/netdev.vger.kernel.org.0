Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC3F222E333
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 00:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727889AbgGZW4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 18:56:05 -0400
Received: from mail-eopbgr80103.outbound.protection.outlook.com ([40.107.8.103]:8340
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726082AbgGZW4E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jul 2020 18:56:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=McX+I7uF4TpawkJ1tTkEJWjp9GWbS/hJEwtEE5GjGDBvDxPfkB35F3S628uf+Ke02R/ldVl44JbGHw5I/rCKBCMqAAiL3Ej8pzrheeBV0ShekOtVdua14d/ZmyI6wuXdnsuC3fovX5hbDcot3A4zaZDzm6KTbJAe5uGOHQcdcbq5szH4ytIau8jszXhMEG/KHTHTye84b7bV29Qc/E1Pf+D+2DibX7jW3LQlCqJKV5DpjL2uirveOWD0OZexzGjP5YVb8HmNCcbPHGoTeOPlYe7ZT+cJZtW8gCpfx2qkqsZg6XTBUt4biE9X8TQHviEoRoQT5P8H8QmlVSveLQI7MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mxrOM796zBOwD83/tU05B48lz8iQp4JGB7JlnBudXAc=;
 b=YKZsAy0uA8KPvAoJP4gNg1vq3qX6FaIjqRjToj/vmnmYovNRsRp/Civ3D8vFgjibAncivBJst2abtkc9n601r1pci+gtPcJuGdgK77baoiillpgk+FOgFjVOYXTgcqHCrEfmszFfIy1/HdO8WvEicmZONxz6Xy702vkssVlWw+BRmLr/QTJWI7Cy077YyWnCydXYwxisJRiFDxV/IS7UFjXPY1Uam+w89eVX4xJFREnL2bowoaeGufFSYYD+98cETg7/dIjTOh1e0o9bSe8ofJQirrAtz842yBCv95m0l5XxFX8/8/yYGOnqfL/Tbuq1druCyJXJL+FXvL/UWA+hOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mxrOM796zBOwD83/tU05B48lz8iQp4JGB7JlnBudXAc=;
 b=Fa5mcZ70+V93Lp4Pxz7Yb6ROaizylzJx9Xw5t6gSB4xYPkwdqU6fOf8cgzTwG0oyeSAI+Bonb44pdWXc9hkHBtRN+hHRQOx6rITh7RZyy+p/yvg0F2QNVj4J2esN2rq9JGGVrxu3a/b0v1MjgixJW1pI5Gfr/AGnYAIHcQmbfg0=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=plvision.eu;
Received: from DB6P190MB0534.EURP190.PROD.OUTLOOK.COM (2603:10a6:6:33::15) by
 DB6P190MB0152.EURP190.PROD.OUTLOOK.COM (2603:10a6:4:8a::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3216.24; Sun, 26 Jul 2020 22:55:54 +0000
Received: from DB6P190MB0534.EURP190.PROD.OUTLOOK.COM
 ([fe80::2c35:1eb3:3877:3c1d]) by DB6P190MB0534.EURP190.PROD.OUTLOOK.COM
 ([fe80::2c35:1eb3:3877:3c1d%7]) with mapi id 15.20.3216.033; Sun, 26 Jul 2020
 22:55:54 +0000
Date:   Mon, 27 Jul 2020 01:55:45 +0300
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mickey Rachamim <mickeyr@marvell.com>
Subject: Re: [net-next v3 2/6] net: marvell: prestera: Add PCI interface
 support
Message-ID: <20200726225545.GA11300@plvision.eu>
References: <20200725150651.17029-1-vadym.kochan@plvision.eu>
 <20200725150651.17029-3-vadym.kochan@plvision.eu>
 <CAHp75VeLS+-QkHuee8oPP4TDQoQPGFHSVpzi0e4m3Xhy2K+d1g@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VeLS+-QkHuee8oPP4TDQoQPGFHSVpzi0e4m3Xhy2K+d1g@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: AM6P194CA0035.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:90::48) To DB6P190MB0534.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:6:33::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM6P194CA0035.EURP194.PROD.OUTLOOK.COM (2603:10a6:209:90::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.22 via Frontend Transport; Sun, 26 Jul 2020 22:55:52 +0000
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 535b51dc-6de3-4bff-7b55-08d831b70d0d
X-MS-TrafficTypeDiagnostic: DB6P190MB0152:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6P190MB01526C7DC6EADB5927951F8195750@DB6P190MB0152.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:765;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: StsPhRLcy79Auqs4HJ6nkxYd4pFYtRbgioofjZqqkjsjIeMMHg7c6zTiWY9vXZbvZ/Zdd2AI6//AAkp5Cz/Mel2YQgbwElgbe1Cg2hR5onQpVXKE6gxHArsVBZ7ff/fpi4SYlcpMdAsLqbR5/8YxQa8A80p+kCg5vv5IWimyAuiEwHlCZBxesOuiSm6D2ZxnDBomTp2uL0YAoyWyxn3uK7SLFjKELFm7u88BIzUsz1bIxyDQLPoSlnB9XNfvFSYhcOaFJ+QQBHKIJIdxO8Blk8HZ/nHNDH6pxZ/8YAXr4hypm46rRTY/YZ8v5sS/nvDsSu0mJloB6EBe0RNU0jkPcw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6P190MB0534.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(376002)(39830400003)(396003)(346002)(136003)(366004)(2616005)(8676002)(86362001)(508600001)(316002)(52116002)(2906002)(7696005)(956004)(33656002)(44832011)(36756003)(54906003)(8936002)(6916009)(8886007)(4326008)(6666004)(26005)(1076003)(186003)(66556008)(16526019)(5660300002)(53546011)(83380400001)(55016002)(66476007)(30864003)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 5yokH0K1gJqARTkbqB1lCNGjA8tBBRZO+RRz1OElIo5d7xHTZ5lrw4u8vauqTQHcGyxNgFf+6AaNYBP6T4oH7FZIGC0KYiyrxbZVW2wmjgPO4hcehyhKrEAehuB0BS+YK+OzXv3b6RbjY7rnJcKhIiHFAmXB8IW3/EhHTMh5TH5KGHVBN4bZHxB7vf4SgSJfRi1WT5uxxYdhYuSVpPg5Q5cTOIPo3qPIoWOTLltqeL7ViKhBw3sDgPoYBPqRNZFQxwoIBtrc5U9hyDgHNmP2egdLVL4bee48pQqBM90TJ9fZrDrEdl20QxEj0vajL/6QfENJQDu1rwrdINy+WlykD9a1zSG6WJwgpEeTf7RPeIPOM0t3WJHt5/tr6VFSiHAEEnda3HKouFNQSNZWAW6SMpmP5OkS5FlN35Or/Bkfb2c0Wim/VbnQk7rxwNKMYCYAp6YLUor5ge+oLAqy6Yzfo6Hv3D4r+REnMa+gLjtj3ng=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 535b51dc-6de3-4bff-7b55-08d831b70d0d
X-MS-Exchange-CrossTenant-AuthSource: DB6P190MB0534.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2020 22:55:54.6195
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mgp9V5SM3ppF6wpxXcEl0KD+NI2UlXlAnIEEoIp4BHfjaMi5cfSficfDwlecvE9/zyWyynMuynJAPbxTFmyMKpWsXxmpsauvjZNZKY78Y34=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6P190MB0152
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy,

On Sun, Jul 26, 2020 at 01:32:19PM +0300, Andy Shevchenko wrote:
> On Sat, Jul 25, 2020 at 6:10 PM Vadym Kochan <vadym.kochan@plvision.eu> wrote:
> >
> > Add PCI interface driver for Prestera Switch ASICs family devices, which
> > provides:
> >
> >     - Firmware loading mechanism
> >     - Requests & events handling to/from the firmware
> >     - Access to the firmware on the bus level
> >
> > The firmware has to be loaded each time device is reset. The driver is
> 
> the device
> 
> > loading it from:
> >
> >     /lib/firmware/marvell/prestera_fw-v{MAJOR}.{MINOR}.img
> >
> > The full firmware image version is located within internal header and
> 
> the internal
> 
> > consists of 3 numbers - MAJOR.MINOR.PATCH. Additionally, driver has
> > hard-coded minimum supported firmware version which it can work with:
> >
> >     MAJOR - reflects the support on ABI level between driver and loaded
> >             firmware, this number should be the same for driver and loaded
> >             firmware.
> >
> >     MINOR - this is the minimum supported version between driver and the
> >             firmware.
> >
> >     PATCH - indicates only fixes, firmware ABI is not changed.
> >
> > Firmware image file name contains only MAJOR and MINOR numbers to make
> > driver be compatible with any PATCH version.
> >
> > Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> > Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
> > ---
> >  drivers/net/ethernet/marvell/prestera/Kconfig |  11 +
> >  .../net/ethernet/marvell/prestera/Makefile    |   2 +
> >  .../ethernet/marvell/prestera/prestera_pci.c  | 823 ++++++++++++++++++
> >  3 files changed, 836 insertions(+)
> >  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_pci.c
> >
> > diff --git a/drivers/net/ethernet/marvell/prestera/Kconfig b/drivers/net/ethernet/marvell/prestera/Kconfig
> > index 76b68613ea7a..d30e3e6d8b7b 100644
> > --- a/drivers/net/ethernet/marvell/prestera/Kconfig
> > +++ b/drivers/net/ethernet/marvell/prestera/Kconfig
> > @@ -11,3 +11,14 @@ config PRESTERA
> >
> >           To compile this driver as a module, choose M here: the
> >           module will be called prestera.
> > +
> > +config PRESTERA_PCI
> > +       tristate "PCI interface driver for Marvell Prestera Switch ASICs family"
> > +       depends on PCI && HAS_IOMEM && PRESTERA
> 
> > +       default m
> 
> Even if I have CONFIG_PRESTERA=y, why as a user I must have this as a module?
> If it's a crucial feature, shouldn't it be rather
>   default CONFIG_PRESTERA
> ?

The firmware image should be located on rootfs, and in case the rootfs
should be mounted later the pci driver can't pick this up when
statically compiled so I left it as 'm' by default.

> 
> > +       help
> > +         This is implementation of PCI interface support for Marvell Prestera
> > +         Switch ASICs family.
> > +
> > +         To compile this driver as a module, choose M here: the
> > +         module will be called prestera_pci.
> > diff --git a/drivers/net/ethernet/marvell/prestera/Makefile b/drivers/net/ethernet/marvell/prestera/Makefile
> > index 610d75032b78..2146714eab21 100644
> > --- a/drivers/net/ethernet/marvell/prestera/Makefile
> > +++ b/drivers/net/ethernet/marvell/prestera/Makefile
> > @@ -2,3 +2,5 @@
> >  obj-$(CONFIG_PRESTERA) += prestera.o
> >  prestera-objs          := prestera_main.o prestera_hw.o prestera_dsa.o \
> >                            prestera_rxtx.o
> > +
> > +obj-$(CONFIG_PRESTERA_PCI)     += prestera_pci.o
> > diff --git a/drivers/net/ethernet/marvell/prestera/prestera_pci.c b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
> > new file mode 100644
> > index 000000000000..cc8446c6b4d9
> > --- /dev/null
> > +++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
> > @@ -0,0 +1,823 @@
> > +// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
> > +/* Copyright (c) 2019-2020 Marvell International Ltd. All rights reserved */
> > +
> > +#include <linux/module.h>
> > +#include <linux/kernel.h>
> > +#include <linux/device.h>
> > +#include <linux/pci.h>
> > +#include <linux/circ_buf.h>
> > +#include <linux/firmware.h>
> > +#include <linux/iopoll.h>
> 
> Perhaps keep them in order?
> 
> > +
> > +#include "prestera.h"
> > +
> > +#define PRESTERA_MSG_MAX_SIZE 1500
> > +
> > +#define PRESTERA_SUPP_FW_MAJ_VER       2
> > +#define PRESTERA_SUPP_FW_MIN_VER       0
> > +
> > +#define PRESTERA_FW_PATH \
> > +       "mrvl/prestera/mvsw_prestera_fw-v" \
> > +       __stringify(PRESTERA_SUPP_FW_MAJ_VER) \
> > +       "." __stringify(PRESTERA_SUPP_FW_MIN_VER) ".img"
> 
> Wouldn't it be better to see this in the C code?

I have no strong opinion on this, but looks like macro is enough for
this statically defined versioning.

> 
> Also this is a PATH and a filename.
> 
> > +
> > +#define PRESTERA_FW_HDR_MAGIC  0x351D9D06
> 
> > +#define PRESTERA_FW_DL_TIMEOUT 50000
> 
> Use the suffix, are they "us" or "ns" or "s" or what?
> 
> > +#define PRESTERA_FW_BLK_SZ     1024
> > +
> > +#define PRESTERA_FW_VER_MAJ_MUL 1000000
> > +#define PRESTERA_FW_VER_MIN_MUL 1000
> > +
> > +#define PRESTERA_FW_VER_MAJ(v) ((v) / PRESTERA_FW_VER_MAJ_MUL)
> > +
> > +#define PRESTERA_FW_VER_MIN(v) \
> > +       (((v) - (PRESTERA_FW_VER_MAJ(v) * PRESTERA_FW_VER_MAJ_MUL)) / \
> > +                       PRESTERA_FW_VER_MIN_MUL)
> > +
> > +#define PRESTERA_FW_VER_PATCH(v) \
> > +       ((v) - (PRESTERA_FW_VER_MAJ(v) * PRESTERA_FW_VER_MAJ_MUL) - \
> > +                       (PRESTERA_FW_VER_MIN(v) * PRESTERA_FW_VER_MIN_MUL))
> > +
> > +struct prestera_fw_header {
> > +       __be32 magic_number;
> > +       __be32 version_value;
> > +       u8 reserved[8];
> 
> > +} __packed;
> 
> Hmm... How __packed make a difference here?
> 
> > +struct prestera_ldr_regs {
> > +       u32 ldr_ready;
> > +       u32 pad1;
> > +
> > +       u32 ldr_img_size;
> > +       u32 ldr_ctl_flags;
> > +
> > +       u32 ldr_buf_offs;
> > +       u32 ldr_buf_size;
> > +
> > +       u32 ldr_buf_rd;
> > +       u32 pad2;
> > +       u32 ldr_buf_wr;
> > +
> > +       u32 ldr_status;
> > +} __packed __aligned(4);
> > +
> > +#define PRESTERA_LDR_REG_OFFSET(f)     offsetof(struct prestera_ldr_regs, f)
> > +
> > +#define PRESTERA_LDR_READY_MAGIC       0xf00dfeed
> > +
> > +#define PRESTERA_LDR_STATUS_IMG_DL     BIT(0)
> > +#define PRESTERA_LDR_STATUS_START_FW   BIT(1)
> > +#define PRESTERA_LDR_STATUS_INVALID_IMG        BIT(2)
> > +#define PRESTERA_LDR_STATUS_NOMEM      BIT(3)
> > +
> > +#define PRESTERA_LDR_REG_BASE(fw)      ((fw)->ldr_regs)
> > +#define PRESTERA_LDR_REG_ADDR(fw, reg) (PRESTERA_LDR_REG_BASE(fw) + (reg))
> > +
> > +#define prestera_ldr_write(fw, reg, val) \
> > +       writel(val, PRESTERA_LDR_REG_ADDR(fw, reg))
> > +#define prestera_ldr_read(fw, reg)     \
> > +       readl(PRESTERA_LDR_REG_ADDR(fw, reg))
> > +
> > +/* fw loader registers */
> > +#define PRESTERA_LDR_READY_REG         PRESTERA_LDR_REG_OFFSET(ldr_ready)
> > +#define PRESTERA_LDR_IMG_SIZE_REG      PRESTERA_LDR_REG_OFFSET(ldr_img_size)
> > +#define PRESTERA_LDR_CTL_REG           PRESTERA_LDR_REG_OFFSET(ldr_ctl_flags)
> > +#define PRESTERA_LDR_BUF_SIZE_REG      PRESTERA_LDR_REG_OFFSET(ldr_buf_size)
> > +#define PRESTERA_LDR_BUF_OFFS_REG      PRESTERA_LDR_REG_OFFSET(ldr_buf_offs)
> > +#define PRESTERA_LDR_BUF_RD_REG                PRESTERA_LDR_REG_OFFSET(ldr_buf_rd)
> > +#define PRESTERA_LDR_BUF_WR_REG                PRESTERA_LDR_REG_OFFSET(ldr_buf_wr)
> > +#define PRESTERA_LDR_STATUS_REG                PRESTERA_LDR_REG_OFFSET(ldr_status)
> > +
> > +#define PRESTERA_LDR_CTL_DL_START      BIT(0)
> > +
> > +#define PRESTERA_EVT_QNUM_MAX  4
> > +
> > +struct prestera_fw_evtq_regs {
> > +       u32 rd_idx;
> > +       u32 pad1;
> > +       u32 wr_idx;
> > +       u32 pad2;
> > +       u32 offs;
> > +       u32 len;
> > +};
> > +
> > +struct prestera_fw_regs {
> > +       u32 fw_ready;
> > +       u32 pad;
> > +       u32 cmd_offs;
> > +       u32 cmd_len;
> > +       u32 evt_offs;
> > +       u32 evt_qnum;
> > +
> > +       u32 cmd_req_ctl;
> > +       u32 cmd_req_len;
> > +       u32 cmd_rcv_ctl;
> > +       u32 cmd_rcv_len;
> > +
> > +       u32 fw_status;
> > +       u32 rx_status;
> > +
> > +       struct prestera_fw_evtq_regs evtq_list[PRESTERA_EVT_QNUM_MAX];
> > +};
> 
> > +#define PRESTERA_FW_REG_OFFSET(f)      offsetof(struct prestera_fw_regs, f)
> 
> > +#define PRESTERA_FW_READY_MAGIC        0xcafebabe
> > +
> > +/* fw registers */
> > +#define PRESTERA_FW_READY_REG          PRESTERA_FW_REG_OFFSET(fw_ready)
> > +
> > +#define PRESTERA_CMD_BUF_OFFS_REG      PRESTERA_FW_REG_OFFSET(cmd_offs)
> > +#define PRESTERA_CMD_BUF_LEN_REG       PRESTERA_FW_REG_OFFSET(cmd_len)
> > +#define PRESTERA_EVT_BUF_OFFS_REG      PRESTERA_FW_REG_OFFSET(evt_offs)
> > +#define PRESTERA_EVT_QNUM_REG          PRESTERA_FW_REG_OFFSET(evt_qnum)
> > +
> > +#define PRESTERA_CMD_REQ_CTL_REG       PRESTERA_FW_REG_OFFSET(cmd_req_ctl)
> > +#define PRESTERA_CMD_REQ_LEN_REG       PRESTERA_FW_REG_OFFSET(cmd_req_len)
> > +
> > +#define PRESTERA_CMD_RCV_CTL_REG       PRESTERA_FW_REG_OFFSET(cmd_rcv_ctl)
> > +#define PRESTERA_CMD_RCV_LEN_REG       PRESTERA_FW_REG_OFFSET(cmd_rcv_len)
> > +#define PRESTERA_FW_STATUS_REG         PRESTERA_FW_REG_OFFSET(fw_status)
> > +#define PRESTERA_RX_STATUS_REG         PRESTERA_FW_REG_OFFSET(rx_status)
> > +
> > +/* PRESTERA_CMD_REQ_CTL_REG flags */
> > +#define PRESTERA_CMD_F_REQ_SENT                BIT(0)
> > +#define PRESTERA_CMD_F_REPL_RCVD       BIT(1)
> > +
> > +/* PRESTERA_CMD_RCV_CTL_REG flags */
> > +#define PRESTERA_CMD_F_REPL_SENT       BIT(0)
> > +
> > +#define PRESTERA_EVTQ_REG_OFFSET(q, f)                 \
> > +       (PRESTERA_FW_REG_OFFSET(evtq_list) +            \
> > +        (q) * sizeof(struct prestera_fw_evtq_regs) +   \
> > +        offsetof(struct prestera_fw_evtq_regs, f))
> > +
> > +#define PRESTERA_EVTQ_RD_IDX_REG(q)    PRESTERA_EVTQ_REG_OFFSET(q, rd_idx)
> > +#define PRESTERA_EVTQ_WR_IDX_REG(q)    PRESTERA_EVTQ_REG_OFFSET(q, wr_idx)
> > +#define PRESTERA_EVTQ_OFFS_REG(q)      PRESTERA_EVTQ_REG_OFFSET(q, offs)
> > +#define PRESTERA_EVTQ_LEN_REG(q)       PRESTERA_EVTQ_REG_OFFSET(q, len)
> > +
> > +#define PRESTERA_FW_REG_BASE(fw)       ((fw)->dev.ctl_regs)
> > +#define PRESTERA_FW_REG_ADDR(fw, reg)  PRESTERA_FW_REG_BASE((fw)) + (reg)
> 
> > +#define prestera_fw_write(fw, reg, val)        \
> > +       writel(val, PRESTERA_FW_REG_ADDR(fw, reg))
> > +#define prestera_fw_read(fw, reg) \
> > +       readl(PRESTERA_FW_REG_ADDR(fw, reg))
> 
> Why macros? Can't be inline functions? Why?
> 
> > +#define PRESTERA_FW_CMD_DEFAULT_WAITMS 30000
> > +#define PRESTERA_FW_READY_WAITMS       20000
> 
> _MS in both cases
> 
> > +struct prestera_fw_evtq {
> > +       u8 __iomem *addr;
> > +       size_t len;
> > +};
> > +
> > +struct prestera_fw {
> > +       struct workqueue_struct *wq;
> > +       struct prestera_device dev;
> > +       struct pci_dev *pci_dev;
> > +       u8 __iomem *ldr_regs;
> > +       u8 __iomem *ldr_ring_buf;
> > +       u32 ldr_buf_len;
> > +       u32 ldr_wr_idx;
> > +       struct mutex cmd_mtx; /* serialize access to dev->send_req */
> > +       size_t cmd_mbox_len;
> > +       u8 __iomem *cmd_mbox;
> > +       struct prestera_fw_evtq evt_queue[PRESTERA_EVT_QNUM_MAX];
> > +       u8 evt_qnum;
> > +       struct work_struct evt_work;
> > +       u8 __iomem *evt_buf;
> > +       u8 *evt_msg;
> > +};
> > +
> > +static int prestera_fw_load(struct prestera_fw *fw);
> > +
> > +static u32 prestera_fw_evtq_len(struct prestera_fw *fw, u8 qid)
> > +{
> > +       return fw->evt_queue[qid].len;
> > +}
> > +
> > +static u32 prestera_fw_evtq_avail(struct prestera_fw *fw, u8 qid)
> > +{
> > +       u32 wr_idx = prestera_fw_read(fw, PRESTERA_EVTQ_WR_IDX_REG(qid));
> > +       u32 rd_idx = prestera_fw_read(fw, PRESTERA_EVTQ_RD_IDX_REG(qid));
> > +
> > +       return CIRC_CNT(wr_idx, rd_idx, prestera_fw_evtq_len(fw, qid));
> > +}
> > +
> > +static void prestera_fw_evtq_rd_set(struct prestera_fw *fw,
> > +                                   u8 qid, u32 idx)
> > +{
> > +       u32 rd_idx = idx & (prestera_fw_evtq_len(fw, qid) - 1);
> > +
> > +       prestera_fw_write(fw, PRESTERA_EVTQ_RD_IDX_REG(qid), rd_idx);
> > +}
> > +
> > +static u8 __iomem *prestera_fw_evtq_buf(struct prestera_fw *fw, u8 qid)
> > +{
> > +       return fw->evt_queue[qid].addr;
> > +}
> > +
> > +static u32 prestera_fw_evtq_read32(struct prestera_fw *fw, u8 qid)
> > +{
> > +       u32 rd_idx = prestera_fw_read(fw, PRESTERA_EVTQ_RD_IDX_REG(qid));
> > +       u32 val;
> > +
> > +       val = readl(prestera_fw_evtq_buf(fw, qid) + rd_idx);
> > +       prestera_fw_evtq_rd_set(fw, qid, rd_idx + 4);
> > +       return val;
> > +}
> > +
> > +static ssize_t prestera_fw_evtq_read_buf(struct prestera_fw *fw,
> > +                                        u8 qid, u8 *buf, size_t len)
> > +{
> > +       u32 idx = prestera_fw_read(fw, PRESTERA_EVTQ_RD_IDX_REG(qid));
> > +       u8 __iomem *evtq_addr = prestera_fw_evtq_buf(fw, qid);
> > +       u32 *buf32 = (u32 *)buf;
> > +       int i;
> 
> > +       for (i = 0; i < len / 4; buf32++, i++) {
> > +               *buf32 = readl_relaxed(evtq_addr + idx);
> > +               idx = (idx + 4) & (prestera_fw_evtq_len(fw, qid) - 1);
> > +       }
> > +
> > +       prestera_fw_evtq_rd_set(fw, qid, idx);
> > +
> > +       return i;
> > +}
> > +
> > +static u8 prestera_fw_evtq_pick(struct prestera_fw *fw)
> > +{
> > +       int qid;
> > +
> > +       for (qid = 0; qid < fw->evt_qnum; qid++) {
> > +               if (prestera_fw_evtq_avail(fw, qid) >= 4)
> > +                       return qid;
> > +       }
> > +
> > +       return PRESTERA_EVT_QNUM_MAX;
> > +}
> > +
> > +static void prestera_fw_evt_work_fn(struct work_struct *work)
> > +{
> > +       struct prestera_fw *fw;
> > +       u8 *msg;
> > +       u8 qid;
> > +
> > +       fw = container_of(work, struct prestera_fw, evt_work);
> > +       msg = fw->evt_msg;
> > +
> > +       while ((qid = prestera_fw_evtq_pick(fw)) < PRESTERA_EVT_QNUM_MAX) {
> > +               u32 idx;
> > +               u32 len;
> > +
> > +               len = prestera_fw_evtq_read32(fw, qid);
> > +               idx = prestera_fw_read(fw, PRESTERA_EVTQ_RD_IDX_REG(qid));
> > +
> > +               WARN_ON(prestera_fw_evtq_avail(fw, qid) < len);
> > +
> > +               if (WARN_ON(len > PRESTERA_MSG_MAX_SIZE)) {
> > +                       prestera_fw_evtq_rd_set(fw, qid, idx + len);
> > +                       continue;
> > +               }
> > +
> > +               prestera_fw_evtq_read_buf(fw, qid, msg, len);
> > +
> > +               if (fw->dev.recv_msg)
> > +                       fw->dev.recv_msg(&fw->dev, msg, len);
> > +       }
> > +}
> > +
> > +static int prestera_fw_wait_reg32(struct prestera_fw *fw, u32 reg, u32 cmp,
> > +                                 unsigned int waitms)
> > +{
> > +       u8 __iomem *addr = PRESTERA_FW_REG_ADDR(fw, reg);
> 
> > +       u32 val = 0;
> 
> Redundant assignment.
> 
> > +
> > +       return readl_poll_timeout(addr, val, cmp == val, 1000 * 10, waitms * 1000);
> > +}
> 
> 
> > +static void prestera_pci_copy_to(u8 __iomem *dst, u8 *src, size_t len)
> > +{
> > +       u32 __iomem *dst32 = (u32 __iomem *)dst;
> > +       u32 *src32 = (u32 *)src;
> > +       int i;
> > +
> > +       for (i = 0; i < (len / 4); dst32++, src32++, i++)
> > +               writel_relaxed(*src32, dst32);
> > +}
> > +
> > +static void prestera_pci_copy_from(u8 *dst, u8 __iomem *src, size_t len)
> > +{
> > +       u32 __iomem *src32 = (u32 __iomem *)src;
> > +       u32 *dst32 = (u32 *)dst;
> > +       int i;
> > +
> > +       for (i = 0; i < (len / 4); dst32++, src32++, i++)
> > +               *dst32 = readl_relaxed(src32);
> > +}
> 
> NIH of memcpy_fromio() / memcpy_toio() ?
> 
I am not sure if there will be no issue with < 4 bytes transactions over
PCI bus. I need to check it.

> > +static int prestera_fw_cmd_send(struct prestera_fw *fw,
> > +                               u8 *in_msg, size_t in_size,
> > +                               u8 *out_msg, size_t out_size,
> > +                               unsigned int waitms)
> > +{
> > +       u32 ret_size = 0;
> 
> > +       int err = 0;
> 
> Redundant assignment. Check your entire code.
> 
> > +       if (!waitms)
> > +               waitms = PRESTERA_FW_CMD_DEFAULT_WAITMS;
> > +
> > +       if (ALIGN(in_size, 4) > fw->cmd_mbox_len)
> > +               return -EMSGSIZE;
> > +
> > +       /* wait for finish previous reply from FW */
> > +       err = prestera_fw_wait_reg32(fw, PRESTERA_CMD_RCV_CTL_REG, 0, 30);
> > +       if (err) {
> > +               dev_err(fw->dev.dev, "finish reply from FW is timed out\n");
> > +               return err;
> > +       }
> > +
> > +       prestera_fw_write(fw, PRESTERA_CMD_REQ_LEN_REG, in_size);
> > +       prestera_pci_copy_to(fw->cmd_mbox, in_msg, in_size);
> > +
> > +       prestera_fw_write(fw, PRESTERA_CMD_REQ_CTL_REG, PRESTERA_CMD_F_REQ_SENT);
> > +
> > +       /* wait for reply from FW */
> > +       err = prestera_fw_wait_reg32(fw, PRESTERA_CMD_RCV_CTL_REG,
> > +                                    PRESTERA_CMD_F_REPL_SENT, waitms);
> > +       if (err) {
> > +               dev_err(fw->dev.dev, "reply from FW is timed out\n");
> > +               goto cmd_exit;
> > +       }
> > +
> > +       ret_size = prestera_fw_read(fw, PRESTERA_CMD_RCV_LEN_REG);
> > +       if (ret_size > out_size) {
> > +               dev_err(fw->dev.dev, "ret_size (%u) > out_len(%zu)\n",
> > +                       ret_size, out_size);
> > +               err = -EMSGSIZE;
> > +               goto cmd_exit;
> > +       }
> > +
> > +       prestera_pci_copy_from(out_msg, fw->cmd_mbox + in_size, ret_size);
> > +
> > +cmd_exit:
> > +       prestera_fw_write(fw, PRESTERA_CMD_REQ_CTL_REG, PRESTERA_CMD_F_REPL_RCVD);
> > +       return err;
> > +}
> > +
> > +static int prestera_fw_send_req(struct prestera_device *dev,
> > +                               u8 *in_msg, size_t in_size, u8 *out_msg,
> > +                               size_t out_size, unsigned int waitms)
> > +{
> > +       struct prestera_fw *fw;
> > +       ssize_t ret;
> > +
> > +       fw = container_of(dev, struct prestera_fw, dev);
> > +
> > +       mutex_lock(&fw->cmd_mtx);
> > +       ret = prestera_fw_cmd_send(fw, in_msg, in_size, out_msg, out_size, waitms);
> > +       mutex_unlock(&fw->cmd_mtx);
> > +
> > +       return ret;
> > +}
> > +
> > +static int prestera_fw_init(struct prestera_fw *fw)
> > +{
> > +       u8 __iomem *base;
> > +       int err;
> > +       u8 qid;
> > +
> > +       fw->dev.send_req = prestera_fw_send_req;
> > +       fw->ldr_regs = fw->dev.ctl_regs;
> > +
> > +       err = prestera_fw_load(fw);
> > +       if (err && err != -ETIMEDOUT)
> > +               return err;
> > +
> > +       err = prestera_fw_wait_reg32(fw, PRESTERA_FW_READY_REG,
> > +                                    PRESTERA_FW_READY_MAGIC,
> > +                                    PRESTERA_FW_READY_WAITMS);
> > +       if (err) {
> > +               dev_err(fw->dev.dev, "FW failed to start\n");
> > +               return err;
> > +       }
> > +
> > +       base = fw->dev.ctl_regs;
> > +
> > +       fw->cmd_mbox = base + prestera_fw_read(fw, PRESTERA_CMD_BUF_OFFS_REG);
> > +       fw->cmd_mbox_len = prestera_fw_read(fw, PRESTERA_CMD_BUF_LEN_REG);
> > +       mutex_init(&fw->cmd_mtx);
> > +
> > +       fw->evt_buf = base + prestera_fw_read(fw, PRESTERA_EVT_BUF_OFFS_REG);
> > +       fw->evt_qnum = prestera_fw_read(fw, PRESTERA_EVT_QNUM_REG);
> > +       fw->evt_msg = kmalloc(PRESTERA_MSG_MAX_SIZE, GFP_KERNEL);
> > +       if (!fw->evt_msg)
> > +               return -ENOMEM;
> > +
> > +       for (qid = 0; qid < fw->evt_qnum; qid++) {
> > +               u32 offs = prestera_fw_read(fw, PRESTERA_EVTQ_OFFS_REG(qid));
> > +               struct prestera_fw_evtq *evtq = &fw->evt_queue[qid];
> > +
> > +               evtq->len = prestera_fw_read(fw, PRESTERA_EVTQ_LEN_REG(qid));
> > +               evtq->addr = fw->evt_buf + offs;
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> > +static void prestera_fw_uninit(struct prestera_fw *fw)
> > +{
> > +       kfree(fw->evt_msg);
> > +}
> > +
> > +static irqreturn_t prestera_pci_irq_handler(int irq, void *dev_id)
> > +{
> > +       struct prestera_fw *fw = dev_id;
> > +
> > +       if (prestera_fw_read(fw, PRESTERA_RX_STATUS_REG)) {
> > +               prestera_fw_write(fw, PRESTERA_RX_STATUS_REG, 0);
> > +
> > +               if (fw->dev.recv_pkt)
> > +                       fw->dev.recv_pkt(&fw->dev);
> > +       }
> > +
> > +       queue_work(fw->wq, &fw->evt_work);
> > +
> > +       return IRQ_HANDLED;
> > +}
> > +
> > +static int prestera_ldr_wait_reg32(struct prestera_fw *fw,
> > +                                  u32 reg, u32 cmp, unsigned int waitms)
> > +{
> > +       u8 __iomem *addr = PRESTERA_LDR_REG_ADDR(fw, reg);
> > +       u32 val = 0;
> > +
> > +       return readl_poll_timeout(addr, val, cmp == val, 1000 * 10, waitms * 1000);
> > +}
> > +
> > +static u32 prestera_ldr_wait_buf(struct prestera_fw *fw, size_t len)
> > +{
> > +       u8 __iomem *addr = PRESTERA_LDR_REG_ADDR(fw, PRESTERA_LDR_BUF_RD_REG);
> > +       u32 buf_len = fw->ldr_buf_len;
> > +       u32 wr_idx = fw->ldr_wr_idx;
> > +       u32 rd_idx = 0;
> > +
> > +       return readl_poll_timeout(addr, rd_idx,
> > +                                CIRC_SPACE(wr_idx, rd_idx, buf_len) >= len,
> > +                                1000, 100 * 1000);
> > +       return 0;
> > +}
> > +
> > +static int prestera_ldr_wait_dl_finish(struct prestera_fw *fw)
> > +{
> > +       u8 __iomem *addr = PRESTERA_LDR_REG_ADDR(fw, PRESTERA_LDR_STATUS_REG);
> > +       unsigned int waitus = PRESTERA_FW_DL_TIMEOUT * 1000;
> > +       unsigned long mask = ~(PRESTERA_LDR_STATUS_IMG_DL);
> > +       u32 val = 0;
> > +       int err;
> > +
> > +       err = readl_poll_timeout(addr, val, val & mask, 1000 * 10, waitus);
> > +       if (err) {
> > +               dev_err(fw->dev.dev, "Timeout to load FW img [state=%d]",
> > +                       prestera_ldr_read(fw, PRESTERA_LDR_STATUS_REG));
> > +               return err;
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> > +static void prestera_ldr_wr_idx_move(struct prestera_fw *fw, unsigned int n)
> > +{
> > +       fw->ldr_wr_idx = (fw->ldr_wr_idx + (n)) & (fw->ldr_buf_len - 1);
> > +}
> > +
> > +static void prestera_ldr_wr_idx_commit(struct prestera_fw *fw)
> > +{
> > +       prestera_ldr_write(fw, PRESTERA_LDR_BUF_WR_REG, fw->ldr_wr_idx);
> > +}
> > +
> > +static u8 __iomem *prestera_ldr_wr_ptr(struct prestera_fw *fw)
> > +{
> > +       return fw->ldr_ring_buf + fw->ldr_wr_idx;
> > +}
> > +
> > +static int prestera_ldr_send(struct prestera_fw *fw, const u8 *buf, size_t len)
> > +{
> > +       int err;
> > +       int i;
> > +
> > +       err = prestera_ldr_wait_buf(fw, len);
> > +       if (err) {
> > +               dev_err(fw->dev.dev, "failed wait for sending firmware\n");
> > +               return err;
> > +       }
> > +
> > +       for (i = 0; i < len; i += 4) {
> > +               writel_relaxed(*(u32 *)(buf + i), prestera_ldr_wr_ptr(fw));
> > +               prestera_ldr_wr_idx_move(fw, 4);
> > +       }
> > +
> > +       prestera_ldr_wr_idx_commit(fw);
> > +       return 0;
> > +}
> > +
> > +static int prestera_ldr_fw_send(struct prestera_fw *fw,
> > +                               const char *img, u32 fw_size)
> > +{
> > +       u32 status;
> > +       u32 pos;
> > +       int err;
> > +
> > +       err = prestera_ldr_wait_reg32(fw, PRESTERA_LDR_STATUS_REG,
> > +                                     PRESTERA_LDR_STATUS_IMG_DL, 5 * 1000);
> > +       if (err) {
> > +               dev_err(fw->dev.dev, "Loader is not ready to load image\n");
> > +               return err;
> > +       }
> > +
> > +       for (pos = 0; pos < fw_size; pos += PRESTERA_FW_BLK_SZ) {
> > +               if (pos + PRESTERA_FW_BLK_SZ > fw_size)
> > +                       break;
> > +
> > +               err = prestera_ldr_send(fw, img + pos, PRESTERA_FW_BLK_SZ);
> > +               if (err)
> > +                       return err;
> > +       }
> > +
> > +       if (pos < fw_size) {
> > +               err = prestera_ldr_send(fw, img + pos, fw_size - pos);
> > +               if (err)
> > +                       return err;
> > +       }
> > +
> > +       err = prestera_ldr_wait_dl_finish(fw);
> > +       if (err)
> > +               return err;
> > +
> > +       status = prestera_ldr_read(fw, PRESTERA_LDR_STATUS_REG);
> 
> > +       if (status != PRESTERA_LDR_STATUS_START_FW) {
> 
> What is the point?
> 
> > +               switch (status) {
> > +               case PRESTERA_LDR_STATUS_INVALID_IMG:
> > +                       dev_err(fw->dev.dev, "FW img has bad CRC\n");
> > +                       return -EINVAL;
> > +               case PRESTERA_LDR_STATUS_NOMEM:
> > +                       dev_err(fw->dev.dev, "Loader has no enough mem\n");
> > +                       return -ENOMEM;
> > +               default:
> > +                       break;
> > +               }
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> > +static void prestera_fw_rev_parse(const struct prestera_fw_header *hdr,
> > +                                 struct prestera_fw_rev *rev)
> > +{
> > +       u32 version = be32_to_cpu(hdr->version_value);
> > +
> > +       rev->maj = PRESTERA_FW_VER_MAJ(version);
> > +       rev->min = PRESTERA_FW_VER_MIN(version);
> > +       rev->sub = PRESTERA_FW_VER_PATCH(version);
> > +}
> > +
> > +static int prestera_fw_rev_check(struct prestera_fw *fw)
> > +{
> > +       struct prestera_fw_rev *rev = &fw->dev.fw_rev;
> > +       u16 maj_supp = PRESTERA_SUPP_FW_MAJ_VER;
> > +       u16 min_supp = PRESTERA_SUPP_FW_MIN_VER;
> > +
> 
> > +       if (rev->maj == maj_supp && rev->min >= min_supp)
> > +               return 0;
> 
> Why not traditional pattern
> 
> if (err) {
>  ...
> }

At least for me it looks simpler when to check which version is
correct.

> 
> ...
> return 0;
> 
> ?
> 
> > +       dev_err(fw->dev.dev, "Driver supports FW version only '%u.%u.x'",
> > +               PRESTERA_SUPP_FW_MAJ_VER, PRESTERA_SUPP_FW_MIN_VER);
> > +
> > +       return -EINVAL;
> > +}
> > +
> > +static int prestera_fw_hdr_parse(struct prestera_fw *fw,
> > +                                const struct firmware *img)
> > +{
> > +       struct prestera_fw_header *hdr = (struct prestera_fw_header *)img->data;
> > +       struct prestera_fw_rev *rev = &fw->dev.fw_rev;
> > +       u32 magic;
> > +
> > +       magic = be32_to_cpu(hdr->magic_number);
> > +       if (magic != PRESTERA_FW_HDR_MAGIC) {
> > +               dev_err(fw->dev.dev, "FW img hdr magic is invalid");
> > +               return -EINVAL;
> > +       }
> > +
> > +       prestera_fw_rev_parse(hdr, rev);
> > +
> > +       dev_info(fw->dev.dev, "FW version '%u.%u.%u'\n",
> > +                rev->maj, rev->min, rev->sub);
> > +
> > +       return prestera_fw_rev_check(fw);
> > +}
> > +
> > +static int prestera_fw_load(struct prestera_fw *fw)
> > +{
> > +       size_t hlen = sizeof(struct prestera_fw_header);
> > +       const struct firmware *f;
> > +       int err;
> > +
> > +       err = prestera_ldr_wait_reg32(fw, PRESTERA_LDR_READY_REG,
> > +                                     PRESTERA_LDR_READY_MAGIC, 5 * 1000);
> > +       if (err) {
> > +               dev_err(fw->dev.dev, "waiting for FW loader is timed out");
> > +               return err;
> > +       }
> > +
> > +       fw->ldr_ring_buf = fw->ldr_regs +
> > +               prestera_ldr_read(fw, PRESTERA_LDR_BUF_OFFS_REG);
> > +
> > +       fw->ldr_buf_len =
> > +               prestera_ldr_read(fw, PRESTERA_LDR_BUF_SIZE_REG);
> > +
> > +       fw->ldr_wr_idx = 0;
> > +
> > +       err = request_firmware_direct(&f, PRESTERA_FW_PATH, &fw->pci_dev->dev);
> > +       if (err) {
> > +               dev_err(fw->dev.dev, "failed to request firmware file\n");
> > +               return err;
> > +       }
> > +
> > +       if (!IS_ALIGNED(f->size, 4)) {
> > +               dev_err(fw->dev.dev, "FW image file is not aligned");
> > +               release_firmware(f);
> > +               return -EINVAL;
> > +       }
> > +
> > +       err = prestera_fw_hdr_parse(fw, f);
> > +       if (err) {
> > +               dev_err(fw->dev.dev, "FW image header is invalid\n");
> > +               release_firmware(f);
> > +               return err;
> > +       }
> > +
> > +       prestera_ldr_write(fw, PRESTERA_LDR_IMG_SIZE_REG, f->size - hlen);
> > +       prestera_ldr_write(fw, PRESTERA_LDR_CTL_REG, PRESTERA_LDR_CTL_DL_START);
> > +
> 
> > +       dev_info(fw->dev.dev, "Loading prestera FW image ...");
> 
> Makes sense to see the file which is being used as a FW image.
> 
> > +       err = prestera_ldr_fw_send(fw, f->data + hlen, f->size - hlen);
> > +
> > +       release_firmware(f);
> > +       return err;
> > +}
> > +
> > +static int prestera_pci_probe(struct pci_dev *pdev,
> > +                             const struct pci_device_id *id)
> > +{
> > +       const char *driver_name = pdev->driver->name;
> > +       u8 __iomem *ctl_addr, *pp_addr;
> > +       struct prestera_fw *fw;
> > +       int err;
> > +
> > +       err = pci_enable_device(pdev);
> 
> pcim_enable_device()
> 
> > +       if (err)
> > +               return err;
> > +
> 
> > +       err = pci_request_regions(pdev, driver_name);
> > +       if (err) {
> > +               dev_err(&pdev->dev, "pci_request_regions failed\n");
> > +               goto err_pci_request_regions;
> > +       }
> 
> (1)
> 
> > +
> > +       if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(30))) {
> > +               dev_err(&pdev->dev, "fail to set DMA mask\n");
> > +               goto err_dma_mask;
> > +       }
> > +
> > +       ctl_addr = pci_ioremap_bar(pdev, 2);
> > +       if (!ctl_addr) {
> > +               dev_err(&pdev->dev, "ioremap failed\n");
> > +               err = -EIO;
> > +               goto err_ctl_ioremap;
> > +       }
> > +
> > +       pp_addr = pci_ioremap_bar(pdev, 4);
> > +       if (!pp_addr) {
> > +               dev_err(&pdev->dev, "ioremap failed\n");
> > +               err = -EIO;
> > +               goto err_pp_ioremap;
> > +       }
> 
> (2)
> 
> (1) and (2) can be replaced with
> pcim_ioremap_regions()
> followed by pcim_iomap_table[2] / [4]
> 
> And magic 2 & 4 should be defined.
> 
> > +       pci_set_master(pdev);
> > +       fw = kzalloc(sizeof(*fw), GFP_KERNEL);
> 
> devm_kzalloc() ?
> 
> > +       if (!fw) {
> > +               err = -ENOMEM;
> > +               goto err_pci_dev_alloc;
> > +       }
> > +
> > +       fw->pci_dev = pdev;
> > +       fw->dev.dev = &pdev->dev;
> > +       fw->dev.ctl_regs = ctl_addr;
> > +       fw->dev.pp_regs = pp_addr;
> > +
> > +       pci_set_drvdata(pdev, fw);
> > +
> > +       err = prestera_fw_init(fw);
> > +       if (err)
> > +               goto err_prestera_fw_init;
> > +
> > +       dev_info(fw->dev.dev, "Switch FW is ready\n");
> > +
> > +       fw->wq = alloc_workqueue("prestera_fw_wq", WQ_HIGHPRI, 1);
> > +       if (!fw->wq)
> > +               goto err_wq_alloc;
> > +
> > +       INIT_WORK(&fw->evt_work, prestera_fw_evt_work_fn);
> > +
> > +       err = pci_alloc_irq_vectors(pdev, 1, 1, PCI_IRQ_MSI);
> > +       if (err < 0) {
> > +               dev_err(&pdev->dev, "MSI IRQ init failed\n");
> > +               goto err_irq_alloc;
> > +       }
> > +
> > +       err = request_irq(pci_irq_vector(pdev, 0), prestera_pci_irq_handler,
> > +                         0, driver_name, fw);
> > +       if (err) {
> > +               dev_err(&pdev->dev, "fail to request IRQ\n");
> > +               goto err_request_irq;
> > +       }
> > +
> > +       err = prestera_device_register(&fw->dev);
> > +       if (err)
> > +               goto err_prestera_dev_register;
> > +
> > +       return 0;
> > +
> > +err_prestera_dev_register:
> > +       free_irq(pci_irq_vector(pdev, 0), fw);
> > +err_request_irq:
> > +       pci_free_irq_vectors(pdev);
> > +err_irq_alloc:
> > +       destroy_workqueue(fw->wq);
> > +err_wq_alloc:
> > +       prestera_fw_uninit(fw);
> > +err_prestera_fw_init:
> > +       kfree(fw);
> > +err_pci_dev_alloc:
> > +       iounmap(pp_addr);
> > +err_pp_ioremap:
> > +       iounmap(ctl_addr);
> > +err_ctl_ioremap:
> > +err_dma_mask:
> > +       pci_release_regions(pdev);
> > +err_pci_request_regions:
> > +       pci_disable_device(pdev);
> > +       return err;
> > +}
> > +
> > +static void prestera_pci_remove(struct pci_dev *pdev)
> > +{
> > +       struct prestera_fw *fw = pci_get_drvdata(pdev);
> > +       u8 __iomem *ctl_addr = fw->dev.ctl_regs;
> > +       u8 __iomem *pp_addr = fw->dev.pp_regs;
> > +
> > +       prestera_device_unregister(&fw->dev);
> > +       free_irq(pci_irq_vector(pdev, 0), fw);
> > +       pci_free_irq_vectors(pdev);
> > +       destroy_workqueue(fw->wq);
> > +       prestera_fw_uninit(fw);
> > +       kfree(fw);
> > +       iounmap(pp_addr);
> > +       iounmap(ctl_addr);
> > +       pci_release_regions(pdev);
> > +       pci_disable_device(pdev);
> > +}
> > +
> > +static const struct pci_device_id prestera_pci_devices[] = {
> > +       { PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0xC804) },
> > +       { }
> > +};
> > +MODULE_DEVICE_TABLE(pci, prestera_pci_devices);
> > +
> > +static struct pci_driver prestera_pci_driver = {
> > +       .name     = "Prestera DX",
> > +       .id_table = prestera_pci_devices,
> > +       .probe    = prestera_pci_probe,
> > +       .remove   = prestera_pci_remove,
> > +};
> > +
> > +static int __init prestera_pci_init(void)
> > +{
> > +       return pci_register_driver(&prestera_pci_driver);
> > +}
> > +
> > +static void __exit prestera_pci_exit(void)
> > +{
> > +       pci_unregister_driver(&prestera_pci_driver);
> > +}
> > +
> > +module_init(prestera_pci_init);
> > +module_exit(prestera_pci_exit);
> 
> module_pci_driver()
> 
> > +MODULE_LICENSE("Dual BSD/GPL");
> > +MODULE_DESCRIPTION("Marvell Prestera switch PCI interface");
> 
> -- 
> With Best Regards,
> Andy Shevchenko


Thanks Andy for the comments, especially for pcim_ helpers.

Regards,
Vadym Kochan
