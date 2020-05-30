Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2EEF1E9230
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 16:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729107AbgE3Own (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 10:52:43 -0400
Received: from mail-eopbgr80130.outbound.protection.outlook.com ([40.107.8.130]:43524
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728927AbgE3Owm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 May 2020 10:52:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Eq3OsXt1rjhViz7N00Mqd+2y65ZHKc4tokTAsCFDnv0ag+o9NTBMb7eV5U4NcajixN6ItZSb/a6dTclEHYti/TirDulEhVUrkT0H4wt+iZ9O2uoZladplvydQhbMRhGWZKeQwOxZfAH5sGQKEmkl/5hZFPom0OeZ5xU2meq388slOtyHktQ2ujyEW6GokUoS1MnHrY7uc0KdUHwLJ8ypytwo4C+wYanSgKrmrNlKIr6Y/MkQODf1VT4IHRT3EV/J9zEIPWMQIJbvErFHfXQSJgoKFEbrwP2IJ6oyK8qy4sikOY1b3wAzUUO68ahutuRL2tYx5U6/VIY/qol/Q7tRDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vext0lOY5nFFotFjBfgvchkJnrvXtkYqDroysfgpM8U=;
 b=T6MRebYUMxHZvuSW5dDq64aMFA1Dc53JnwRkYeCNVqwRli4vBr47P1Vo4u2SNnYPYLSMPk9EnEi8TtXnMqEx7bOeS8T05HNhn/kHNH+pcFpvzBpHZXVlvSL1VaJU+Y20jd01j8mW68p41I+qMrk/OqhuXvsXT9ZR1J3ZkXRRdt0Uc55Wp1fCIT8pLo5PobPwWN2EgSPaOwLhOjkCXV7Q+4i8HRNfSd3qepr1eFeOTjlGs2c2y1/DAgi6mguMkQSgOGE8F2kpv2z/OEVzYZvp17ncRV7Cn3ivzqhNY8wW+FuZa8E7kK9RCXP+15hLQoHE7xd9VCv+GOFsqeZt9dgoWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vext0lOY5nFFotFjBfgvchkJnrvXtkYqDroysfgpM8U=;
 b=Zehs4if1nvu96RkvHXmLqjquQE04BxJ5LzjQiI2fKK/PYa4gZP+VuNdUOUSW4drKMBB3BZJBRtOEkX4gN8hgP976IbDYuKHJAm43/o2k8sxRNszZLYV38QLQqoQJafmM/ZAAWicJr/jwgZ7Kv1lbq27qcl0IzO0SHz4K5KMEu+0=
Authentication-Results: idosch.org; dkim=none (message not signed)
 header.d=none;idosch.org; dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:35::10)
 by VI1P190MB0382.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:2d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.22; Sat, 30 May
 2020 14:52:35 +0000
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::8149:8652:3746:574f]) by VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::8149:8652:3746:574f%7]) with mapi id 15.20.3045.022; Sat, 30 May 2020
 14:52:35 +0000
Date:   Sat, 30 May 2020 17:52:31 +0300
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Ido Schimmel <idosch@idosch.org>
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
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>
Subject: Re: [net-next 0/6] net: marvell: prestera: Add Switchdev driver for
 Prestera family ASIC device 98DX326x (AC3x)
Message-ID: <20200530145231.GB19411@plvision.eu>
References: <20200528151245.7592-1-vadym.kochan@plvision.eu>
 <20200530142928.GA1624759@splinter>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200530142928.GA1624759@splinter>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: AM6P192CA0013.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:209:83::26) To VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:35::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM6P192CA0013.EURP192.PROD.OUTLOOK.COM (2603:10a6:209:83::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19 via Frontend Transport; Sat, 30 May 2020 14:52:33 +0000
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 455f59c7-0216-4987-3a6b-08d804a91679
X-MS-TrafficTypeDiagnostic: VI1P190MB0382:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1P190MB0382FB290DE09CA6CF27E79C958C0@VI1P190MB0382.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 041963B986
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4Fgv1fk6+gcIrWOfrpPzfsoRBexs4+ydK0IMTjKGncwZzQNCYJU1PVmo8bMpeYYagjDmzhsU0Ispdu1VU1xjdmCJzrt/uI3x36e2nvCRilDoY3THFiLjMAYpTcoA8EPr1kBzqVW2wOmRqb3CGw+ufzO8CmyB4M9vCY0JbjEN2ZlGv505XHW6XNuCKHMjzJAgW+3/P6YiO7nw6lV+h049a/+fpdlXkMDLZnmaqKVsx2d3KIU7qTIZgXK91jT8qEfeFde8v5aRL/GiXcCL3xvQ+Huis/ZWmHLN9y7AjrDhA+Mgi/KZoYIrP55In4L9lXkc2YzbOlBrcSCLMEet6scbHA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0399.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(136003)(366004)(376002)(396003)(346002)(39830400003)(83380400001)(1076003)(8936002)(508600001)(52116002)(86362001)(36756003)(7696005)(8676002)(2906002)(33656002)(6916009)(66476007)(55016002)(66946007)(8886007)(316002)(4326008)(54906003)(44832011)(26005)(66556008)(5660300002)(16526019)(186003)(956004)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: VUpozSds/leyPfBPMWU6pLpyzoU1HFIQbFyN+/Y5yL9PIqh5QdMpFh6aHdoEiXIfJaxLTO1YjtPUE4DX8cF37lqbnliL47ToqtrlzUFuOlGuwPAbtni1UHkSy4TYuDGrxKAfFSNaWYyTdSulPJexY4MdkTigTMCH5mAR/nbJg+tISsc6KsbCP2kSwRv+C6Hftkjwc9q2pMKqoGAD8Yhhqve2JZfV7Ndw3tAmr30dDYPiAGuqKxuxignFKd0m28WcB3QQA/Ozl9r5VRIl9CKppIbPSFVuvX7iuHkzVFLLLakqh3Q0+NkyGZUHq+GnJZnF88CdCPVTf6IJMZs8e7bREmWKPXNSdklNOwtZgzUgbMF8dhR5EDwsBBr+un9SZIrPzvygZ1e+dYxxabCO1wEZeqBF3WRHHnhX65NmFBenbmJqRXHqbuMME4Y5qpnPi8ollFiADFjmO6VJqfxzg+UtYkXQNxsShbF7rYtRU8BYuqI=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 455f59c7-0216-4987-3a6b-08d804a91679
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2020 14:52:34.9420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uhna6/Gv1WRIiIsOj2miyh6HXwZFXJEw89onElnAUpEdAAA8961fsOMPACs4KN2rhi8k/wdfqyNzCgM8WtBqG+aoCSiX1pg/tWI7fCQ9B7c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0382
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ido,

On Sat, May 30, 2020 at 05:29:28PM +0300, Ido Schimmel wrote:
> On Thu, May 28, 2020 at 06:12:39PM +0300, Vadym Kochan wrote:
> > Marvell Prestera 98DX326x integrates up to 24 ports of 1GbE with 8
> > ports of 10GbE uplinks or 2 ports of 40Gbps stacking for a largely
> > wireless SMB deployment.
> > 
> > Prestera Switchdev is a firmware based driver that operates via PCI bus.  The
> > current implementation supports only boards designed for the Marvell Switchdev
> > solution and requires special firmware.
> > 
> > This driver implementation includes only L1, basic L2 support, and RX/TX.
> > 
> > The core Prestera switching logic is implemented in prestera_main.c, there is
> > an intermediate hw layer between core logic and firmware. It is
> > implemented in prestera_hw.c, the purpose of it is to encapsulate hw
> > related logic, in future there is a plan to support more devices with
> > different HW related configurations.
> > 
> > The following Switchdev features are supported:
> > 
> >     - VLAN-aware bridge offloading
> >     - VLAN-unaware bridge offloading
> >     - FDB offloading (learning, ageing)
> >     - Switchport configuration
> > 
> > The firmware image will be uploaded soon to the linux-firmware repository.
> > 
> > PATCH:
> >     1) Fixed W=1 warnings
> 
> Hi,
> 
> I just applied the patches for review and checkpatch had a lot of
> complaints. Some are even ERRORs. For example:
> 
> WARNING: do not add new typedefs
> #1064: FILE: drivers/net/ethernet/marvell/prestera/prestera_hw.h:32:
> +typedef void (*prestera_event_cb_t)
I may be wrong, as I remember Jiri suggested it and looks like
it makes sense. I really don't have strong opinion about this.

> 
> WARNING: line over 80 characters
> #2007: FILE: drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:321:
> +                       __skb_trim(buf->skb, PRESTERA_SDMA_RX_DESC_PKT_LEN(desc));
> 
> WARNING: line over 80 characters
> #2007: FILE: drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:321:
> +                       __skb_trim(buf->skb, PRESTERA_SDMA_RX_DESC_PKT_LEN(desc));
> 
> ERROR: Macros with complex values should be enclosed in parentheses
> #196: FILE: drivers/net/ethernet/marvell/prestera/prestera_pci.c:161:
> +#define PRESTERA_FW_REG_ADDR(fw, reg)  PRESTERA_FW_REG_BASE(fw) + (reg)
This one makes sense.
> 
> WARNING: prefer 'help' over '---help---' for new help texts
> #52: FILE: drivers/net/ethernet/marvell/prestera/Kconfig:15:
> +config PRESTERA_PCI
I will fix it.
> 
> ...

The most are about using ethtool types which are in camel style.
Regarding > 80 chars is is a required rule ? I saw some discussion
on LKML that 80+ are acceptable sometimes.

> 
> Also, smatch complaints about:
> 
> drivers/net/ethernet/marvell/prestera//prestera_ethtool.c:713
> prestera_ethtool_get_strings() error: memcpy() '*prestera_cnt_name' too
> small (32 vs 960)
> 
> And coccicheck about:
> 
> drivers/net/ethernet/marvell/prestera/prestera_hw.c:681:2-3: Unneeded
> semicolon
These looks interesting, I did not use smatch and coccicheck, will look
on these.

> 
> > 
> >     2) Renamed PCI driver name to be more generic "Prestera DX" because
> >        there will be more devices supported.
> > 
> >     3) Changed firmware image dir path: marvell/ -> mrvl/prestera/
> >        to be aligned with location in linux-firmware.git (if such
> >        will be accepted).
> > 
> > RFC v3:
> >     1) Fix prestera prefix in prestera_rxtx.c
> > 
> >     2) Protect concurrent access from multiple ports on multiple CPU system
> >        on tx path by spinlock in prestera_rxtx.c
> > 
> >     3) Try to get base mac address from device-tree, otherwise use a random generated one.
> > 
> >     4) Move ethtool interface support into separate prestera_ethtool.c file.
> > 
> >     5) Add basic devlink support and get rid of physical port naming ops.
> > 
> >     6) Add STP support in Switchdev driver.
> > 
> >     7) Removed MODULE_AUTHOR
> > 
> >     8) Renamed prestera.c -> prestera_main.c, and kernel module to
> >        prestera.ko
> > 
> > RFC v2:
> >     1) Use "pestera_" prefix in struct's and functions instead of mvsw_pr_
> > 
> >     2) Original series split into additional patches for Switchdev ethtool support.
> > 
> >     3) Use major and minor firmware version numbers in the firmware image filename.
> > 
> >     4) Removed not needed prints.
> > 
> >     5) Use iopoll API for waiting on register's value in prestera_pci.c
> > 
> >     6) Use standart approach for describing PCI ID matching section instead of using
> >        custom wrappers in prestera_pci.c
> > 
> >     7) Add RX/TX support in prestera_rxtx.c.
> > 
> >     8) Rewritten prestera_switchdev.c with following changes:
> >        - handle netdev events from prestera.c
> > 
> >        - use struct prestera_bridge for bridge objects, and get rid of
> >          struct prestera_bridge_device which may confuse.
> > 
> >        - use refcount_t
> > 
> >     9) Get rid of macro usage for sending fw requests in prestera_hw.c
> > 
> >     10) Add base_mac setting as module parameter. base_mac is required for
> >         generation default port's mac.
> > 
> > Vadym Kochan (6):
> >   net: marvell: prestera: Add driver for Prestera family ASIC devices
> >   net: marvell: prestera: Add PCI interface support
> >   net: marvell: prestera: Add basic devlink support
> >   net: marvell: prestera: Add ethtool interface support
> >   net: marvell: prestera: Add Switchdev driver implementation
> >   dt-bindings: marvell,prestera: Add description for device-tree
> >     bindings
> > 
> >  .../bindings/net/marvell,prestera.txt         |   34 +
> >  drivers/net/ethernet/marvell/Kconfig          |    1 +
> >  drivers/net/ethernet/marvell/Makefile         |    1 +
> >  drivers/net/ethernet/marvell/prestera/Kconfig |   25 +
> >  .../net/ethernet/marvell/prestera/Makefile    |    7 +
> >  .../net/ethernet/marvell/prestera/prestera.h  |  208 +++
> >  .../marvell/prestera/prestera_devlink.c       |  111 ++
> >  .../marvell/prestera/prestera_devlink.h       |   25 +
> >  .../ethernet/marvell/prestera/prestera_dsa.c  |  134 ++
> >  .../ethernet/marvell/prestera/prestera_dsa.h  |   37 +
> >  .../marvell/prestera/prestera_ethtool.c       |  737 ++++++++++
> >  .../marvell/prestera/prestera_ethtool.h       |   37 +
> >  .../ethernet/marvell/prestera/prestera_hw.c   | 1225 ++++++++++++++++
> >  .../ethernet/marvell/prestera/prestera_hw.h   |  180 +++
> >  .../ethernet/marvell/prestera/prestera_main.c |  663 +++++++++
> >  .../ethernet/marvell/prestera/prestera_pci.c  |  825 +++++++++++
> >  .../ethernet/marvell/prestera/prestera_rxtx.c |  860 +++++++++++
> >  .../ethernet/marvell/prestera/prestera_rxtx.h |   21 +
> >  .../marvell/prestera/prestera_switchdev.c     | 1286 +++++++++++++++++
> >  .../marvell/prestera/prestera_switchdev.h     |   16 +
> >  20 files changed, 6433 insertions(+)
> >  create mode 100644 drivers/net/ethernet/marvell/prestera/Kconfig
> >  create mode 100644 drivers/net/ethernet/marvell/prestera/Makefile
> >  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera.h
> >  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_devlink.c
> >  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_devlink.h
> >  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_dsa.c
> >  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_dsa.h
> >  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_ethtool.c
> >  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_ethtool.h
> >  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_hw.c
> >  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_hw.h
> >  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_main.c
> >  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_pci.c
> >  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
> >  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_rxtx.h
> >  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
> >  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_switchdev.h
> > 
> > -- 
> > 2.17.1
> > 
