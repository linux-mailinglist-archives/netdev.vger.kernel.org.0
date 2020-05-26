Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68B371E3013
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 22:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389767AbgEZUd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 16:33:58 -0400
Received: from mail-am6eur05on2107.outbound.protection.outlook.com ([40.107.22.107]:51277
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389339AbgEZUd5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 16:33:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mbixu1Uksjwe3ox/cQ9S/7V8Z3xjhydi7RkyX966XvnYDt7UcgSlgUQkpCgnT2k3beRZEkLHevk4LqLBhAlpKkL8hHbQg4ydA9CpdQRVdHzvs2WWndFDFne9xEIBbh4x/b/ZOBYuFB4u8vmMj25v/rPzMYnu0kT94GB2/6IqALsCBQwBdfBWJTjWAl/Fgp8S7lHrpmD2d7Rw73ICzIYElxeVIcy1bSpLjI84+Yem7OQjWZUWSrd+0652qyanVu0nwGzeYqrC3BRoNy/xJ4Ns+6iVW4RNtRey0gAtJQr0etpNd4arhJQTJxxV72R9MVV141evxiVXbngf6XR9ZOALtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vVRCKqV7WEo14FqT+jZK9gWuI2xWO3lfIjv/WAlXhmM=;
 b=Tf30YtXnpc8dPkFTcLz7HsVqIy8UeOsu/ffP0+qEifQ9RUz21mBBtZdtYyN+PoopvMMU4sNnqDiyYdliJmd3Gkz1KNMk2HWdr/biCGsYJnTH2TuvBmhqbDGeJPM3G5bL9pNaPzo8bIkskdaEHbegRKKPKM+0UbyUQNkpTSDooSBpmhGYffSVKvNgbpzrvTQrARzE/yBWuBT5vkoKforEvOvzgoeUZvpQbJCXZA61f70n03aedWmD4lt0248ysbWhOe1/9kB2HA8PrsGM63Jtu+jfjUowRtqnibthsBR6rqR+PseocKi9a29sWxYUYToaMyU4YmgzIgj70Vnm2Qpozg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vVRCKqV7WEo14FqT+jZK9gWuI2xWO3lfIjv/WAlXhmM=;
 b=n3H6lbg7PDdzr0gWRJZnp+RhPxy651ivTIVCi4cpvbFKCa18cdmWmlMZEMHMZUmwYL23bNvGJd1qaph5xc6EeTnIkRSnOkKrJSHUjK8AbZZFnInAVy9/QkeJQcjn6SpXBkPOlyK9+Sa+IqWNXlh3zgeRqHRhefkQbXJ6fzcRwbw=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:35::10)
 by VI1P190MB0318.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:37::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Tue, 26 May
 2020 20:33:50 +0000
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::8149:8652:3746:574f]) by VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::8149:8652:3746:574f%7]) with mapi id 15.20.3021.029; Tue, 26 May 2020
 20:33:50 +0000
Date:   Tue, 26 May 2020 23:33:45 +0300
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
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
Subject: Re: [net-next RFC v3 0/6] net: marvell: prestera: Add Switchdev
 driver for Prestera family ASIC device 98DX326x (AC3x)
Message-ID: <20200526203345.GB32356@plvision.eu>
References: <20200526171302.28649-1-vadym.kochan@plvision.eu>
 <20200526113512.33246247@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200526113512.33246247@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: AM7PR04CA0003.eurprd04.prod.outlook.com
 (2603:10a6:20b:110::13) To VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:35::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM7PR04CA0003.eurprd04.prod.outlook.com (2603:10a6:20b:110::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24 via Frontend Transport; Tue, 26 May 2020 20:33:48 +0000
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 612f7695-3eda-423f-cdae-08d801b418da
X-MS-TrafficTypeDiagnostic: VI1P190MB0318:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1P190MB0318C7B5C2DB7F7494D5BF7495B00@VI1P190MB0318.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 041517DFAB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DgNxs3KepmuPUC72h9el8dO+pPcC8ODw6Kls6SSpqHFYognRv5wVBjCq1S9ykITT2opHEhYX5X7GTdPmrV4KX1/1mmUxMdTBcsziDYnu67BjPoV4zezYbJ9del8245MlLBqULUSNk1RN/JmLJAbxTd90W/ixDrP3tHxDoblXXv/x9ONdwouHRFA986Pa35MI9KzM0a7XlMhySo60DKZHdUUeeOoFcAbeNbRDnXjHLfes7710jNRd/4N+xKRe1M2m7zDO9HtXK78sYKgM+r4UmyzxnX0f52sHMwHCCULb9RrqT+sBtsVddsVeh7We7JL85NgZUUXU7aweOSfIMltETw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0399.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(346002)(366004)(39830400003)(376002)(136003)(396003)(26005)(36756003)(66946007)(52116002)(55016002)(7696005)(30864003)(2906002)(6666004)(4326008)(1076003)(16526019)(316002)(2616005)(33656002)(6916009)(186003)(86362001)(8676002)(8886007)(8936002)(44832011)(66476007)(54906003)(508600001)(5660300002)(66556008)(956004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: r8nVvG+m7jiVjKbFWdxCvDg2rfsmUFqEBw4kOCBHdw+fPzExOuIucXN+4W6ugjLCoDPiuKdjPR8s8g8bWIw/K4PIiUMmGpqC12TjctvsUliV/IT9j93GDNL5VqJFabvVq/PkJuAyHHHOB4xsV9t/ZghBrbgnjWuQRcDv3I1R6K2VMg7wleF709V1MJl8xh88mrMeYRsqw8VXpfPWbRZyq9vDrsir4qP5uiUj1r1g9xPIy65Sy8YsUgydA1i4GpDgrglVRbPJWkgGLLFTJ8bW+Rc+zB5Edd8BBDmPlKyXd9GQQwx2m0elSyqYd9oa+VqJ1zy2fiGoOsbeaaJpa/xfR8hpl74vOQ8nTYKtbefKQXvG3ILrn7d3X/gFQERYz2KjK5wZkUaHu4HxTL/OfYFnR+76ymfk3P8Ldeljj2ksh7bXg74C8Ngh3ujOhnoCgD7oTf4LKVywhMss5+lpvpm8uX3C4V5CJ4Qi8HRP/hMECUymp5Ba1jwn7uuN2Ohm16AZ
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 612f7695-3eda-423f-cdae-08d801b418da
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2020 20:33:49.9056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nd5LnM+m7ZDFO10BSNkZ1c0yEfAOcDPm4zKV5b88c+99utApkIC0NDua0P59jHyKVwkI1xVcv6jlCPOs49DmAQUfxdpn2LPp2NAZJpecdLM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0318
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Jakub!

I fixed these locally, should I wait a bit for other comments
before sending next version ?

On Tue, May 26, 2020 at 11:35:12AM -0700, Jakub Kicinski wrote:
> On Tue, 26 May 2020 20:12:56 +0300 Vadym Kochan wrote:
> > Marvell Prestera 98DX326x integrates up to 24 ports of 1GbE with 8
> > ports of 10GbE uplinks or 2 ports of 40Gbps stacking for a largely
> > wireless SMB deployment.
> 
> This series adds lots of warnings when built with W=1, please make sure
> every individual patch builds cleanly.
> 
> ../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:38:24: warning: symbol 'prestera_devlink_alloc' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:47:6: warning: symbol 'prestera_devlink_free' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:54:5: warning: symbol 'prestera_devlink_register' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:68:6: warning: symbol 'prestera_devlink_unregister' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:75:5: warning: symbol 'prestera_devlink_port_register' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:95:6: warning: symbol 'prestera_devlink_port_unregister' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:100:6: warning: symbol 'prestera_devlink_port_type_set' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:105:21: warning: symbol 'prestera_devlink_get_port' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:656:5: warning: symbol 'prestera_sdma_switch_init' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:716:6: warning: symbol 'prestera_sdma_switch_fini' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:755:13: warning: symbol 'prestera_sdma_xmit' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:812:5: warning: symbol 'prestera_rxtx_switch_init' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:825:6: warning: symbol 'prestera_rxtx_switch_fini' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:831:5: warning: symbol 'prestera_rxtx_port_init' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:843:13: warning: symbol 'prestera_rxtx_xmit' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:38:25: warning: no previous prototype for â€˜prestera_devlink_allocâ€™ [-Wmissing-prototypes]
>    38 | struct prestera_switch *prestera_devlink_alloc(void)
>       |                         ^~~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:47:6: warning: no previous prototype for â€˜prestera_devlink_freeâ€™ [-Wmissing-prototypes]
>    47 | void prestera_devlink_free(struct prestera_switch *sw)
>       |      ^~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:54:5: warning: no previous prototype for â€˜prestera_devlink_registerâ€™ [-Wmissing-prototypes]
>    54 | int prestera_devlink_register(struct prestera_switch *sw)
>       |     ^~~~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:68:6: warning: no previous prototype for â€˜prestera_devlink_unregisterâ€™ [-Wmissing-prototypes]
>    68 | void prestera_devlink_unregister(struct prestera_switch *sw)
>       |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:75:5: warning: no previous prototype for â€˜prestera_devlink_port_registerâ€™ [-Wmissing-prototypes]
>    75 | int prestera_devlink_port_register(struct prestera_port *port)
>       |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:95:6: warning: no previous prototype for â€˜prestera_devlink_port_unregisterâ€™ [-Wmissing-prototypes]
>    95 | void prestera_devlink_port_unregister(struct prestera_port *port)
>       |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:100:6: warning: no previous prototype for â€˜prestera_devlink_port_type_setâ€™ [-Wmissing-prototypes]
>   100 | void prestera_devlink_port_type_set(struct prestera_port *port)
>       |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:105:22: warning: no previous prototype for â€˜prestera_devlink_get_portâ€™ [-Wmissing-prototypes]
>   105 | struct devlink_port *prestera_devlink_get_port(struct net_device *dev)
>       |                      ^~~~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c: In function â€˜prestera_sdma_tx_recycle_work_fnâ€™:
> ../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:535:17: warning: variable â€˜dma_devâ€™ set but not used [-Wunused-but-set-variable]
>   535 |  struct device *dma_dev;
>       |                 ^~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c: At top level:
> ../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:656:5: warning: no previous prototype for â€˜prestera_sdma_switch_initâ€™ [-Wmissing-prototypes]
>   656 | int prestera_sdma_switch_init(struct prestera_switch *sw)
>       |     ^~~~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:716:6: warning: no previous prototype for â€˜prestera_sdma_switch_finiâ€™ [-Wmissing-prototypes]
>   716 | void prestera_sdma_switch_fini(struct prestera_switch *sw)
>       |      ^~~~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:755:13: warning: no previous prototype for â€˜prestera_sdma_xmitâ€™ [-Wmissing-prototypes]
>   755 | netdev_tx_t prestera_sdma_xmit(struct prestera_sdma *sdma, struct sk_buff *skb)
>       |             ^~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:812:5: warning: no previous prototype for â€˜prestera_rxtx_switch_initâ€™ [-Wmissing-prototypes]
>   812 | int prestera_rxtx_switch_init(struct prestera_switch *sw)
>       |     ^~~~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:825:6: warning: no previous prototype for â€˜prestera_rxtx_switch_finiâ€™ [-Wmissing-prototypes]
>   825 | void prestera_rxtx_switch_fini(struct prestera_switch *sw)
>       |      ^~~~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:831:5: warning: no previous prototype for â€˜prestera_rxtx_port_initâ€™ [-Wmissing-prototypes]
>   831 | int prestera_rxtx_port_init(struct prestera_port *port)
>       |     ^~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:843:13: warning: no previous prototype for â€˜prestera_rxtx_xmitâ€™ [-Wmissing-prototypes]
>   843 | netdev_tx_t prestera_rxtx_xmit(struct prestera_port *port, struct sk_buff *skb)
>       |             ^~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:296:6: warning: symbol 'prestera_ethtool_get_drvinfo' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:473:5: warning: symbol 'prestera_ethtool_get_link_ksettings' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:598:5: warning: symbol 'prestera_ethtool_set_link_ksettings' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:634:5: warning: symbol 'prestera_ethtool_get_fecparam' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:661:5: warning: symbol 'prestera_ethtool_set_fecparam' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:696:5: warning: symbol 'prestera_ethtool_get_sset_count' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:706:6: warning: symbol 'prestera_ethtool_get_strings' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:715:6: warning: symbol 'prestera_ethtool_get_stats' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:726:5: warning: symbol 'prestera_ethtool_nway_reset' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:296:6: warning: no previous prototype for â€˜prestera_ethtool_get_drvinfoâ€™ [-Wmissing-prototypes]
>   296 | void prestera_ethtool_get_drvinfo(struct net_device *dev,
>       |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:473:5: warning: no previous prototype for â€˜prestera_ethtool_get_link_ksettingsâ€™ [-Wmissing-prototypes]
>   473 | int prestera_ethtool_get_link_ksettings(struct net_device *dev,
>       |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:598:5: warning: no previous prototype for â€˜prestera_ethtool_set_link_ksettingsâ€™ [-Wmissing-prototypes]
>   598 | int prestera_ethtool_set_link_ksettings(struct net_device *dev,
>       |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:634:5: warning: no previous prototype for â€˜prestera_ethtool_get_fecparamâ€™ [-Wmissing-prototypes]
>   634 | int prestera_ethtool_get_fecparam(struct net_device *dev,
>       |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:661:5: warning: no previous prototype for â€˜prestera_ethtool_set_fecparamâ€™ [-Wmissing-prototypes]
>   661 | int prestera_ethtool_set_fecparam(struct net_device *dev,
>       |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:696:5: warning: no previous prototype for â€˜prestera_ethtool_get_sset_countâ€™ [-Wmissing-prototypes]
>   696 | int prestera_ethtool_get_sset_count(struct net_device *dev, int sset)
>       |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:706:6: warning: no previous prototype for â€˜prestera_ethtool_get_stringsâ€™ [-Wmissing-prototypes]
>   706 | void prestera_ethtool_get_strings(struct net_device *dev,
>       |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:715:6: warning: no previous prototype for â€˜prestera_ethtool_get_statsâ€™ [-Wmissing-prototypes]
>   715 | void prestera_ethtool_get_stats(struct net_device *dev,
>       |      ^~~~~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:726:5: warning: no previous prototype for â€˜prestera_ethtool_nway_resetâ€™ [-Wmissing-prototypes]
>   726 | int prestera_ethtool_nway_reset(struct net_device *dev)
>       |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_pci.c: In function â€˜prestera_fw_rev_checkâ€™:
> ../drivers/net/ethernet/marvell/prestera/prestera_pci.c:590:15: warning: comparison is always true due to limited range of data type [-Wtype-limits]
>   590 |      rev->min >= PRESTERA_SUPP_FW_MIN_VER) {
>       |               ^~
> ../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:656:5: warning: symbol 'prestera_sdma_switch_init' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:716:6: warning: symbol 'prestera_sdma_switch_fini' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:755:13: warning: symbol 'prestera_sdma_xmit' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:812:5: warning: symbol 'prestera_rxtx_switch_init' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:825:6: warning: symbol 'prestera_rxtx_switch_fini' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:831:5: warning: symbol 'prestera_rxtx_port_init' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:843:13: warning: symbol 'prestera_rxtx_xmit' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:296:6: warning: symbol 'prestera_ethtool_get_drvinfo' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:473:5: warning: symbol 'prestera_ethtool_get_link_ksettings' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:598:5: warning: symbol 'prestera_ethtool_set_link_ksettings' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:634:5: warning: symbol 'prestera_ethtool_get_fecparam' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:661:5: warning: symbol 'prestera_ethtool_set_fecparam' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:696:5: warning: symbol 'prestera_ethtool_get_sset_count' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:706:6: warning: symbol 'prestera_ethtool_get_strings' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:715:6: warning: symbol 'prestera_ethtool_get_stats' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:726:5: warning: symbol 'prestera_ethtool_nway_reset' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:38:24: warning: symbol 'prestera_devlink_alloc' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:47:6: warning: symbol 'prestera_devlink_free' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:54:5: warning: symbol 'prestera_devlink_register' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:68:6: warning: symbol 'prestera_devlink_unregister' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:75:5: warning: symbol 'prestera_devlink_port_register' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:95:6: warning: symbol 'prestera_devlink_port_unregister' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:100:6: warning: symbol 'prestera_devlink_port_type_set' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:105:21: warning: symbol 'prestera_devlink_get_port' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_switchdev.c:214:6: warning: symbol 'prestera_port_vlan_destroy' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_switchdev.c:288:24: warning: symbol 'prestera_bridge_by_dev' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_switchdev.c:537:5: warning: symbol 'prestera_bridge_port_event' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_switchdev.c:1238:5: warning: symbol 'prestera_switchdev_init' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_switchdev.c:1276:6: warning: symbol 'prestera_switchdev_fini' was not declared. Should it be static?
> ../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:38:25: warning: no previous prototype for â€˜prestera_devlink_allocâ€™ [-Wmissing-prototypes]
>    38 | struct prestera_switch *prestera_devlink_alloc(void)
>       |                         ^~~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:47:6: warning: no previous prototype for â€˜prestera_devlink_freeâ€™ [-Wmissing-prototypes]
>    47 | void prestera_devlink_free(struct prestera_switch *sw)
>       |      ^~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:54:5: warning: no previous prototype for â€˜prestera_devlink_registerâ€™ [-Wmissing-prototypes]
>    54 | int prestera_devlink_register(struct prestera_switch *sw)
>       |     ^~~~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:68:6: warning: no previous prototype for â€˜prestera_devlink_unregisterâ€™ [-Wmissing-prototypes]
>    68 | void prestera_devlink_unregister(struct prestera_switch *sw)
>       |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:75:5: warning: no previous prototype for â€˜prestera_devlink_port_registerâ€™ [-Wmissing-prototypes]
>    75 | int prestera_devlink_port_register(struct prestera_port *port)
>       |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:95:6: warning: no previous prototype for â€˜prestera_devlink_port_unregisterâ€™ [-Wmissing-prototypes]
>    95 | void prestera_devlink_port_unregister(struct prestera_port *port)
>       |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:100:6: warning: no previous prototype for â€˜prestera_devlink_port_type_setâ€™ [-Wmissing-prototypes]
>   100 | void prestera_devlink_port_type_set(struct prestera_port *port)
>       |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_devlink.c:105:22: warning: no previous prototype for â€˜prestera_devlink_get_portâ€™ [-Wmissing-prototypes]
>   105 | struct devlink_port *prestera_devlink_get_port(struct net_device *dev)
>       |                      ^~~~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:296:6: warning: no previous prototype for â€˜prestera_ethtool_get_drvinfoâ€™ [-Wmissing-prototypes]
>   296 | void prestera_ethtool_get_drvinfo(struct net_device *dev,
>       |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:473:5: warning: no previous prototype for â€˜prestera_ethtool_get_link_ksettingsâ€™ [-Wmissing-prototypes]
>   473 | int prestera_ethtool_get_link_ksettings(struct net_device *dev,
>       |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:598:5: warning: no previous prototype for â€˜prestera_ethtool_set_link_ksettingsâ€™ [-Wmissing-prototypes]
>   598 | int prestera_ethtool_set_link_ksettings(struct net_device *dev,
>       |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:634:5: warning: no previous prototype for â€˜prestera_ethtool_get_fecparamâ€™ [-Wmissing-prototypes]
>   634 | int prestera_ethtool_get_fecparam(struct net_device *dev,
>       |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:661:5: warning: no previous prototype for â€˜prestera_ethtool_set_fecparamâ€™ [-Wmissing-prototypes]
>   661 | int prestera_ethtool_set_fecparam(struct net_device *dev,
>       |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:696:5: warning: no previous prototype for â€˜prestera_ethtool_get_sset_countâ€™ [-Wmissing-prototypes]
>   696 | int prestera_ethtool_get_sset_count(struct net_device *dev, int sset)
>       |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:706:6: warning: no previous prototype for â€˜prestera_ethtool_get_stringsâ€™ [-Wmissing-prototypes]
>   706 | void prestera_ethtool_get_strings(struct net_device *dev,
>       |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:715:6: warning: no previous prototype for â€˜prestera_ethtool_get_statsâ€™ [-Wmissing-prototypes]
>   715 | void prestera_ethtool_get_stats(struct net_device *dev,
>       |      ^~~~~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_ethtool.c:726:5: warning: no previous prototype for â€˜prestera_ethtool_nway_resetâ€™ [-Wmissing-prototypes]
>   726 | int prestera_ethtool_nway_reset(struct net_device *dev)
>       |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c: In function â€˜prestera_sdma_tx_recycle_work_fnâ€™:
> ../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:535:17: warning: variable â€˜dma_devâ€™ set but not used [-Wunused-but-set-variable]
>   535 |  struct device *dma_dev;
>       |                 ^~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c: At top level:
> ../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:656:5: warning: no previous prototype for â€˜prestera_sdma_switch_initâ€™ [-Wmissing-prototypes]
>   656 | int prestera_sdma_switch_init(struct prestera_switch *sw)
>       |     ^~~~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:716:6: warning: no previous prototype for â€˜prestera_sdma_switch_finiâ€™ [-Wmissing-prototypes]
>   716 | void prestera_sdma_switch_fini(struct prestera_switch *sw)
>       |      ^~~~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:755:13: warning: no previous prototype for â€˜prestera_sdma_xmitâ€™ [-Wmissing-prototypes]
>   755 | netdev_tx_t prestera_sdma_xmit(struct prestera_sdma *sdma, struct sk_buff *skb)
>       |             ^~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:812:5: warning: no previous prototype for â€˜prestera_rxtx_switch_initâ€™ [-Wmissing-prototypes]
>   812 | int prestera_rxtx_switch_init(struct prestera_switch *sw)
>       |     ^~~~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:825:6: warning: no previous prototype for â€˜prestera_rxtx_switch_finiâ€™ [-Wmissing-prototypes]
>   825 | void prestera_rxtx_switch_fini(struct prestera_switch *sw)
>       |      ^~~~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:831:5: warning: no previous prototype for â€˜prestera_rxtx_port_initâ€™ [-Wmissing-prototypes]
>   831 | int prestera_rxtx_port_init(struct prestera_port *port)
>       |     ^~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:843:13: warning: no previous prototype for â€˜prestera_rxtx_xmitâ€™ [-Wmissing-prototypes]
>   843 | netdev_tx_t prestera_rxtx_xmit(struct prestera_port *port, struct sk_buff *skb)
>       |             ^~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_pci.c: In function â€˜prestera_fw_rev_checkâ€™:
> ../drivers/net/ethernet/marvell/prestera/prestera_pci.c:590:15: warning: comparison is always true due to limited range of data type [-Wtype-limits]
>   590 |      rev->min >= PRESTERA_SUPP_FW_MIN_VER) {
>       |               ^~
> ../drivers/net/ethernet/marvell/prestera/prestera_switchdev.c:214:6: warning: no previous prototype for â€˜prestera_port_vlan_destroyâ€™ [-Wmissing-prototypes]
>   214 | void prestera_port_vlan_destroy(struct prestera_port_vlan *port_vlan)
>       |      ^~~~~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_switchdev.c:288:25: warning: no previous prototype for â€˜prestera_bridge_by_devâ€™ [-Wmissing-prototypes]
>   288 | struct prestera_bridge *prestera_bridge_by_dev(struct prestera_switchdev *swdev,
>       |                         ^~~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_switchdev.c:537:5: warning: no previous prototype for â€˜prestera_bridge_port_eventâ€™ [-Wmissing-prototypes]
>   537 | int prestera_bridge_port_event(struct net_device *dev, unsigned long event,
>       |     ^~~~~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_switchdev.c:1238:5: warning: no previous prototype for â€˜prestera_switchdev_initâ€™ [-Wmissing-prototypes]
>  1238 | int prestera_switchdev_init(struct prestera_switch *sw)
>       |     ^~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/marvell/prestera/prestera_switchdev.c:1276:6: warning: no previous prototype for â€˜prestera_switchdev_finiâ€™ [-Wmissing-prototypes]
>  1276 | void prestera_switchdev_fini(struct prestera_switch *sw)
>       |      ^~~~~~~~~~~~~~~~~~~~~~~
