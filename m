Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCBC3D64F7
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 18:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233185AbhGZQRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 12:17:49 -0400
Received: from mail-eopbgr00054.outbound.protection.outlook.com ([40.107.0.54]:5443
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241137AbhGZQPd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 12:15:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bZTUk2cQsce2upD1QB0gogPmHVidUa7TPMCpwpGECM8bgFFgFWCz0z3vTBvVSVi9+AtjOsj/14YNe3YQF/sQACVGCWAEleZE7WUDJuWK/Xti0LWHBiRe8Bm93Ff+mZyxpZbN4MWOQEb7I43RtS1gx3oaGmE7wqhSV7O3dLzySwhGyV3xUJeQ46LmTCLeDAKKXFeBUmt9jx/qSQ8R++PXU4qA9baW6ptNygMQGoe7Goe2vjs1KDmIT/E5ndp5hK7yE208UPVCaQvUZ6bIXvNvUWRd9yZP0rOMolm1oz03B2id783Xj6gylXIbcojadX1BOOUwd6HRmVIE7BoR79rNaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=taE3KZ/qqJ/aZAg0NFIaA+Zl5D1ymcJkjJu2oC+ZboY=;
 b=UWG+RG8kxWzhIUzJJ7zQuf25dESL01jjU0UHSQAxIzdQc2Tj3siGA3AC6mhQqPjUXwfYZXlx5LdV7rGFIxaJi0F2cfponOWaqHMP56erc83Ju1kkMYf2JxcI/9DKrxpvm5nrk5kWwP+tAzD27dsGCTu7k+6MFFkHuszNqVhbhroy4NEyuiWvlcf3ZVqa+5R20VcmfYwgpJTtLbu2y1gg2xpSEk1vhd2beipU8Ua6uDasN4t418DaHErjrwjyF/ao8xkdROv+nmqxb4GPNAQei7L/XyZXFALUaXiO48k17DWUU7/UXWucc/Mr5VM5w1Q5fRtmN2EcP1sZTmTfb7bD6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=taE3KZ/qqJ/aZAg0NFIaA+Zl5D1ymcJkjJu2oC+ZboY=;
 b=j8/hJLjsTLrVIVxEV8m/S1QVussI+0gsaPcgw5AiRl8UUc99uzYcZC/QWh+9Ijkkq9aATGU9FgTGr2t35ajvDj/pv5jfkL+VJk/p9SkGmCcjX4BQPoEgGFaLYao1+bppKA5Zi/Z6lr8y71YYDrVyTpQR7RU2S0nPCoGEtcOqxSU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7328.eurprd04.prod.outlook.com (2603:10a6:800:1a5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Mon, 26 Jul
 2021 16:55:59 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4352.031; Mon, 26 Jul 2021
 16:55:58 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Colin Ian King <colin.king@canonical.com>
Subject: [PATCH net-next 0/9] Traffic termination for sja1105 ports under VLAN-aware bridge
Date:   Mon, 26 Jul 2021 19:55:27 +0300
Message-Id: <20210726165536.1338471-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR05CA0078.eurprd05.prod.outlook.com
 (2603:10a6:208:136::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM0PR05CA0078.eurprd05.prod.outlook.com (2603:10a6:208:136::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26 via Frontend Transport; Mon, 26 Jul 2021 16:55:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c3f1ab37-8587-4117-b621-08d950563db6
X-MS-TrafficTypeDiagnostic: VE1PR04MB7328:
X-Microsoft-Antispam-PRVS: <VE1PR04MB73289D40560AEEF7443405ADE0E89@VE1PR04MB7328.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ajqKHMNl3XNXX4w1w8+12AuQUs4h4+bpoCdsNMWmkfajPpMfNlrlGMp5tOlsOH+pkPr+VYwfy2AI8xrlJqWwIhLhiu3i4bjBtSITqZYkbk0Xyh5uZEoyXQw1PhB6s/joNUa/uYDszuxHEawzp0N1VmrHx/dYc8UVF5S4iJHaGKPlqJUbysm3vk1U4JCrSniA1e7TZSA7tasm5nkjZV/xUJw7a6HdDY7s73OLgZxsGgqvFmVkjr67CiL9eis2jc0Mp25qm9XyCZ3oWE7VPIx5NTXldgu+h1LcnlxCE6hSxmvhFmdIbmMAfKWSx5kXQ7CsLcdb64jd9wYOKRvoeqott++r5xRUd5JUZO6O6Xvb5xh3fITAcdg/cj47XbqiLEFfD0dWiI6hm0/dDRnBCkcVscLDxuPRbeudDrDs3TCflloTgS3rjbkFCnD0GttMDYzvN41rjifJRaq0gy6xOlOkEmy738EiZ4MqA368tY46KLH39r70itRIQtAxYqcxkzQA48npvL7PNySJhlsnbqT6NGvDUzdtmGA+dzlabRig66OkROJ6hi0g7/1b3K78FkZmP1GP8LxKb/ryPSI8vpfm8gbTam6tGyweVy6jEbiSVS/Uh433xDTbL2h7BzurFG9OI6ha9QIIzvxFoPiC7djXPSA5FKSLegNhJpbD5ELsX4s2W27GHHokrXJtzKOFDsrlsEOXSVA7scO2tShWfpphjw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(39850400004)(136003)(346002)(366004)(36756003)(38350700002)(38100700002)(83380400001)(478600001)(44832011)(956004)(6666004)(86362001)(2616005)(2906002)(52116002)(8676002)(8936002)(7416002)(66556008)(5660300002)(66946007)(54906003)(110136005)(66476007)(316002)(26005)(6512007)(6506007)(186003)(1076003)(4326008)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MpUimbqM9994mE54ssVnJDZcPESFrC7umRFqjCM4zv5sogCJl9QvPwiovE+5?=
 =?us-ascii?Q?M7XOSZSyQUUms9GKLKkKlawtDv7KbnIwiabN2GUnC3Br+fWSSYutVvSLY47M?=
 =?us-ascii?Q?pczC8QkUWYQzebMXOjVCx5f1iRJDVx+sjxBSlXfL3KFpC1OR5NRh8k+VfUaD?=
 =?us-ascii?Q?5sHLpgEaMifjILDWwvNyl8DLCUtqBVBnPzH+iB7V4ahkQ7pS4wkk4l8HwFuO?=
 =?us-ascii?Q?5+vYFgxWzkW+s1dvIkdlWrBxYN5YbcxLb1YYeLR1Qx44VuehZzDLAKG5h7kO?=
 =?us-ascii?Q?Kdfs6mSAaIruqfWM9UM1yaHnzkylY5rMuVIyJ7eT0CwodS/qLfeD0tXSm98a?=
 =?us-ascii?Q?i+5+tJytX++igesVcSJB9y1lsgURMGPiI7iuWM+eaId0zm1yIYAgyf+3kBjr?=
 =?us-ascii?Q?O8TpMJXL98ECt63VIAjKlLpFeHVMaZzpA551kzrNc5Q9zZTKHqB1OIZ3Bm4N?=
 =?us-ascii?Q?v02d6bCoGbl7gfqYc0sLwU0Yi3acUO7XLuznUmMBcT2boSedKU/FqGj+Fme7?=
 =?us-ascii?Q?cf8wqGS7OoiCgY0lU7WFOUtPUa5Vy1T3RkyDqKO+KDdS8obnALlT1fIbbamx?=
 =?us-ascii?Q?ULM+FmecOLtIq/XqmpLfrSEYSR79ficsYet0T/hbKqlL89e5ATKgQQ6vRGqG?=
 =?us-ascii?Q?RT4fwrIc6QHpTeceR88HWz0b/t1LE1b2WZ7Pd7qmzeFUFGBCKzTob5iQelka?=
 =?us-ascii?Q?zQw8FQ8wRW/dFkgIvz2CeIEnoBOTr7gKpgnSOL+3mWiKaIf0wpPc64M5lvyv?=
 =?us-ascii?Q?soUfyXABzvTuN1HG/MVD/+axqVnCSfuM0ze3JC8+AbZrGtVhgQlDkYOHeGle?=
 =?us-ascii?Q?w1XSx2IgZpbRGpHpFINc9jBFmxw7/dODgZJ4hSKtYOm5yorMOJEBDXyUY7ir?=
 =?us-ascii?Q?4NIwKEeA7NF994/sAJg2T55IW0iB0c+Yx6Kgsnx4KxfK6QyrLK+XlE+/nec4?=
 =?us-ascii?Q?+qHpMhC4OlxJgt4PkEafK6YuQ29EbhtYm/WlXc7fmEMey2CDpPDFIPi/gtTG?=
 =?us-ascii?Q?TBKM2bhk9KKPgnTwJpEBJ3XX88uG5nmerRYgAi1vF4Zi40DJW/3YVbUr41sM?=
 =?us-ascii?Q?9df67fEILXajpzJA62GQWvyInKK5l2tR6eP0hLaGATHSP4DbOZxSHSByRc22?=
 =?us-ascii?Q?qi+DRe5ZKkqtCO2SsxYwLHLAUTXHUK1ZiybUyEVAcaRv/jvm1CdoqCn/pPtK?=
 =?us-ascii?Q?NnNB3aJENzzk7GG8dRls6gPa+92dln0+Vy3bJoc59ihA1Ufm2r6lGZ4GcM1O?=
 =?us-ascii?Q?ACu7QPf1HV+Ne/g9/sGwyTMUyY5LFaOQCF7zad/wMJ6LtfDdeiSQpvyAF61E?=
 =?us-ascii?Q?2gm+84pFrEfh+ZppyN+kGhSE?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3f1ab37-8587-4117-b621-08d950563db6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2021 16:55:58.4748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 01b9hgFeOOipGYH735QLYtFQ/wSKUyVa8OTYEHwPGKbfQuTGc1J9+V9l7h2TRaLuWGwhbYfrBiK4wNfo5R6WAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7328
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set of patches updates the sja1105 DSA driver to be able to send
and receive network stack packets on behalf of a VLAN-aware upper bridge
interface.

The reasons why this has traditionally been a problem are explained in
the "Traffic support" section of Documentation/networking/dsa/sja1105.rst.
(the entire documentation will be revised in a separate patch series).

The limitations that have prevented us from doing this so far have now
been partially lifted by the bridge's ability to send a packet with
skb->offload_fwd_mark = true, which means that the accelerator is
allowed to look up its hardware FDB when sending a packet and deliver it
to those destination ports. Basically skb->dev is now just a conduit to
the switchdev driver's ndo_start_xmit(), and does not guarantee that the
packet will really be transmitted on that port (but it will be
transmitted where it should, nonetheless).

Apart from the ability to perform IP termination on VLAN-aware bridges
on top of sja1105 interfaces, we also gain the following features:
- VLAN-aware software bridging between sja1105 ports and "foreign"
  (non-DSA) interfaces
- software bridging between sja1105 bridge ports, and software LAG
  uppers of sja1105 ports (as long as the bridge is VLAN-aware)

The only things that don't work are:
1. to create an AF_PACKET socket on top of a sja1105 port that is under
   a VLAN-aware bridge. This is because the "imprecise RX" procedure
   selects an RX port for data plane* packets based on the assumption
   that the packet will land in the bridge's data path.  If ebtables
   rules are added to remove some packets from the bridge's data path,
   that assumption will be broken. Nonetheless, this is not a limitation
   that negatively impacts the known use cases with this switch.  If
   there was a way to impose user space restrictions against creating
   AF_PACKET sockets on this particular configuration, I could be
   interested in adding those restrictions, but I think there are other
   known broken configs already which are not checked by the kernel
   today (like for example that the bridge's rx_handler steals packets
   anyway from AF_PACKET sockets with exact-match ptype handlers, as
   opposed to ptype_all which are processed earlier; this is precisely
   the reason why ebtables rules are generally needed to avoid that).
2. to send traffic on behalf of an 8021q upper of a standalone interface,
   while other sja1105 ports are part of a VLAN-aware bridge. This is
   because sja1105 sets ds->vlan_filtering_is_global = true, so we
   cannot make the standalone port ignore the VLAN header from the
   packet on RX, so we cannot make tag_8021q enforce its own pvid for
   the packets belonging to that port's 8021q upper. So we cannot
   determine in the first place that packets come from that port, unless
   we iterate through all 8021q uppers of all ports, and enforce
   uniqueness of VLAN IDs. I am not sure if this is what I want / if it
   is worth it, so currently all 8021q uppers are denied, regardless of
   whether the switch has ports under a VLAN-aware bridge or not
   (otherwise it becomes complicated even to track the state).
   Nonetheless, the VID uniqueness of all 8021q uppers does raise
   another question: what to do with VID 0, which has no 8021q upper,
   but the 8021q module adds it to our RX filter with vlan_vid_add().
   I am honestly not sure what to do. The best I can do is enable a
   hardware bit in sja1105 which reclassifies VID 0 frames to the PVID,
   and they will be sent on the CPU port using either the tag_8021q pvid
   of standalone ports, or the bridge pvid of VLAN-aware ports. So at
   the very least, those packets are still 'kinda' processed as if they
   were untagged, but the VID 0 is lost, though. In my defence, Marvell
   appears to do the same thing with reclassifying VID 0 frames, see
   commit b8b79c414eca ("net: dsa: mv88e6xxx: Fix adding vlan 0").

*Control packets (currently hardcoded in sja1105 as link-local packets
for MAC DA ranges 01-80-c2-xx-xx-xx and 01-1b-19-xx-xx-xx) are received
based on packet traps and their precise source port is always known.

I have taken one patch from Colin because my work conflicts with his,
and integrating it all through the same series avoids that.

Cc: Roopa Prabhu <roopa@nvidia.com>
Cc: Nikolay Aleksandrov <nikolay@nvidia.com>
Cc: Ido Schimmel <idosch@nvidia.com>
Cc: Jiri Pirko <jiri@nvidia.com>
Cc: Colin Ian King <colin.king@canonical.com>

Colin Ian King (1):
  net: dsa: sja1105: remove redundant re-assignment of pointer table

Vladimir Oltean (8):
  net: bridge: update BROPT_VLAN_ENABLED before notifying switchdev in
    br_vlan_filter_toggle
  net: bridge: add a helper for retrieving port VLANs from the data path
  net: dsa: sja1105: delete vlan delta save/restore logic
  net: dsa: sja1105: deny 8021q uppers on ports
  net: dsa: sja1105: deny more than one VLAN-aware bridge
  net: dsa: sja1105: add support for imprecise RX
  net: dsa: sja1105: add bridge TX data plane offload based on tag_8021q
  Revert "net: dsa: Allow drivers to filter packets they can decode
    source port from"

 drivers/net/dsa/sja1105/sja1105.h      |  12 +-
 drivers/net/dsa/sja1105/sja1105_main.c | 440 +++++++++----------------
 include/linux/dsa/8021q.h              |  10 +
 include/linux/if_bridge.h              |   8 +
 include/net/dsa.h                      |  15 -
 net/bridge/br_vlan.c                   |  34 +-
 net/dsa/dsa_priv.h                     |  43 +++
 net/dsa/port.c                         |   1 -
 net/dsa/tag_8021q.c                    |  48 ++-
 net/dsa/tag_sja1105.c                  | 118 ++++---
 net/ethernet/eth.c                     |   6 +-
 11 files changed, 363 insertions(+), 372 deletions(-)

-- 
2.25.1

