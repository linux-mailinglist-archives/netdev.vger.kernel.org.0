Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 170D7233032
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 12:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgG3KWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 06:22:16 -0400
Received: from mail-eopbgr60089.outbound.protection.outlook.com ([40.107.6.89]:38285
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725892AbgG3KWP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 06:22:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bV+0GZmtzjXdgXe9Xp72Rio3nguL7dB6+Pumzm4hvN0Cz0WP+bpGXlyFVRKsH/8mJAfaUwkIPwHLHs+w9osiRQMkvPoLE9JNxvmZgh5drQfPIOhFGjmawfndWHp8FO+auchhKD2BSbD4nY5E8w0lNusfTKB/traNSq9NYeO6buwEH5WDIaZS+gq9JMLwi3c1G38/8sp7RNArjgQkgiU07nO5FnmwaOWvW8XHdebsPVNaxdMRowX9dUR2kYSlfkxKorXiNzAgXlruMRUzwLptN2zvKDi4JB6/K/YMaDOlc3SZh97FLTS2x7b5v3P2Vy1jlFxPdSzTa2I87aRl2v1niA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xhDX0usYKyFSwfHA23XFSDaT8UCERO9Jou2prt5uSwI=;
 b=DGcSkeZW4pI7tz6i+Z80hCcQlrLbHhthRIRfLw4eid/oCmfAuLfVJVjAZnU/uhykPhbwUOxX725m+BtxnDAZk8OLa3OtOI4r0LWFWhkDwJrL4t3aMp6w+3nFleW/oXcOXh9l2tl6IUmJySyjE78jysqMpS2FVIfJBnFbB12rrNMsJodzvAFduIgN0AZRFhIFVzWtplvXkq/dy06H33ZnIGYQ/mO/PsmXcxvsQMzC/RZhUGyL4goc/k5WU5QvBqSbT1C0KUnfvzVDEVS5LMk04O56SesIqtZnIy2jU3kSonl99Zx6Ytfjn9gWJ9FP66daHAUmoV7Q1IkIgPd/hhJQ5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xhDX0usYKyFSwfHA23XFSDaT8UCERO9Jou2prt5uSwI=;
 b=hBfSVUuIbGq2J3AERK28QAli4ID42Z+H/7xXqoIYOBibHg6dSOtICJcJRBy8FLXNUeu9qDHnm15HPQuCDRX8kOVAFfoI0HP8fQlluqbI1uY3/watr5j+RMrc2Bmq70Sxmlt8/qpPkP22OhOijX6crw17aqt0FmQ7xOMrvyl9VKM=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from DB7PR04MB5099.eurprd04.prod.outlook.com (2603:10a6:10:18::30)
 by DB8PR04MB6924.eurprd04.prod.outlook.com (2603:10a6:10:11e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Thu, 30 Jul
 2020 10:22:12 +0000
Received: from DB7PR04MB5099.eurprd04.prod.outlook.com
 ([fe80::f801:51e:28:f2a3]) by DB7PR04MB5099.eurprd04.prod.outlook.com
 ([fe80::f801:51e:28:f2a3%4]) with mapi id 15.20.3239.019; Thu, 30 Jul 2020
 10:22:12 +0000
From:   hongbo.wang@nxp.com
To:     xiaoliang.yang_1@nxp.com, allan.nielsen@microchip.com,
        po.liu@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, mingkai.hu@nxp.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jiri@resnulli.us, idosch@idosch.org,
        kuba@kernel.org, vinicius.gomes@intel.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, ivecera@redhat.com
Cc:     "hongbo.wang" <hongbo.wang@nxp.com>
Subject: [PATCH v4 0/2] Add 802.1AD protocol support for dsa switch and ocelot driver
Date:   Thu, 30 Jul 2020 18:25:03 +0800
Message-Id: <20200730102505.27039-1-hongbo.wang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SGBP274CA0019.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::31)
 To DB7PR04MB5099.eurprd04.prod.outlook.com (2603:10a6:10:18::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from whb-OptiPlex-790.ap.freescale.net (119.31.174.73) by SGBP274CA0019.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17 via Frontend Transport; Thu, 30 Jul 2020 10:22:05 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c95ad15c-4c97-4618-9111-08d834726c37
X-MS-TrafficTypeDiagnostic: DB8PR04MB6924:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB6924FBF0F1493DBB07A2533CE1710@DB8PR04MB6924.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h4z08L5sOZXmoW6x55iy17jmbVa8eOSvYvHm/CE2dkECBJdNVtbJATkyOsIqGUBQw5IQIRUI0poQJaxyjnLvvrSU51tIutSp+4oOiPD23JXxGB4U86ELi51+mmOxPeZNEve7GtC9Vhcwj8VmfdDjH5da57uExFNOctbaYFFJgo0wmc6Aj6bKRYgqE7WOTXt+5RyRSyc7g2PYb5n+mkKB2Pl7ydtLdvAIWT5vZvv3NPILwX3P4msTgRczHS/fkH4JA0dwrGZ+acw7Y2s2dppcWy/2Ea4PVqcKU+rvdR9kk4/7q5jUDuunzcSe1ZZg42CXu3ETm2XlPSkWFPJQTFOCMS70hyaTXYcs2w1W29bGhW4uFe9JN31KrFbkwQZ6PXtl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5099.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(346002)(376002)(366004)(136003)(396003)(2906002)(83380400001)(36756003)(66476007)(66946007)(4326008)(66556008)(6486002)(7416002)(52116002)(8676002)(316002)(86362001)(6506007)(6512007)(9686003)(1076003)(26005)(2616005)(956004)(478600001)(186003)(5660300002)(8936002)(16526019)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: rng0YGPoGA6CptCVTUacyjKkLgYlCz8kGek+c3VnL2dYJbN2HOoparw953aXFEArWK4aNyIFGbUepq3Be4VijYUnbzJojQIUE+uRyKqoqP65DpSRVJkBRpMxnV7jLYY2No4RDKwN9eWsZlzJi+ZzBX8UbgW/qH/sZat3eixTbaPloa+vQbCra4m1Sd4CjW+eJY9KV/4gqFUkViPMvvHmdYcUHssW+gpCXeWq/i7Ki7DQpf70rF9QPzrDyWXtxvt/Gc20rusp+nMJuNdJ3Y0HKLmxXo/OpR9Mn9qmEE2N7QGwUgLE1vv5AAz8fpAxureZa6ovvzvOuAhQUb/pknHLg6uegP23GxHZ6786BhzeRetrpeOYRmbBJDZocm6DD2rL7xUpfbgBWvLpDxEdZ4Lm/eHKalrE8VghA0qbmABCeu5kqPYwZx+onZEH7yqMR2aSVy1Nl9bWbhVL0NNqjiqmHWzLa+CRcoseH1kWavpLS7sGMHBVNWK3MkE6YPjdk1iJIowDEqHGBYFE1QLyNR1Yk/dets2xe1isACxboOHrgx7x9uCeeNYCXTmsnprE3Tt7f6Xoyk0M90P3TMn/CHf8JVZ6tcIr1sgaCqvwv01u3ZJAzE1TYRPXI925D38YLpUa07FJ57JG96cJWEQGQrnOSg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c95ad15c-4c97-4618-9111-08d834726c37
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5099.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2020 10:22:12.2080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ubuhUhWOdBQNZrWLbXy8nKsKmfW05DNN4Gj4VZdvVEidqGgWm3an/qsG6KVl2MpYzSMe7HtEFv5D/6EU9Aosxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6924
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "hongbo.wang" <hongbo.wang@nxp.com>

1. the patch 0001* is for setting single port into 802.1AD(QinQ) mode,
before this patch, the function dsa_slave_vlan_rx_add_vid didn't pass 
the parameter "proto" to next port level, so switch's port can't get
parameter "proto"
  after applying this patch, the following command can be supported:
  ip link set br0 type bridge vlan_protocol 802.1ad
  ip link add link swp1 name swp1.100 type vlan protocol 802.1ad id 100

2. the patch 0002* is for setting QinQ related registers in ocelot 
switch driver, after applying this patch, the switch(VSC99599)'s port can
enable or disable QinQ mode.

3. Version log
v4: 
a. modify slave.c to support "ip set br0 type bridge vlan_protocol 802.1ad"
b. modify ocelot.c, if enable QinQ, set VLAN_AWARE_ENA and VLAN_POP_CNT per
   port when vlan_filter=1
v3: combine two patches to one post

hongbo.wang (2):
  net: dsa: Add protocol support for 802.1AD when adding or   deleting
    vlan for dsa switch port
  net: dsa: ocelot: Add support for QinQ Operation

 drivers/net/dsa/ocelot/felix.c     | 12 +++++++
 drivers/net/ethernet/mscc/ocelot.c | 53 +++++++++++++++++++++++++-----
 include/net/switchdev.h            |  1 +
 include/soc/mscc/ocelot.h          |  2 ++
 net/dsa/dsa_priv.h                 |  4 +--
 net/dsa/port.c                     |  6 ++--
 net/dsa/slave.c                    | 27 +++++++++++----
 net/dsa/tag_8021q.c                |  4 +--
 8 files changed, 89 insertions(+), 20 deletions(-)

-- 
2.17.1

