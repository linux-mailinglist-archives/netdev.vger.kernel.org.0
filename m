Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1463446876F
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 21:15:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243509AbhLDUTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 15:19:05 -0500
Received: from mail-eopbgr70074.outbound.protection.outlook.com ([40.107.7.74]:17024
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1351872AbhLDUP0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Dec 2021 15:15:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z2GjM8NidebSFkkjldo/D+XvjC3klQSKyJ3B6ODBONgOVP0o+dyKrD4MSGSkM9z/5NY54QmRuzvQ3s9tnCo5N+rwD+g89XlKHNZja53J+7lzwcD3p/xTpZfV9NJ+dT6NU70T6DwLjHHR8lP+jMgN60LILxzqqOKQlyRb/8C8WH7GijKNI+1beRS7VnqrsToCL8C3g9IwuGz5GbIFSsZELzg9li+Na1m2MaRXUpAa/mdyYdvgoQ/gHVx9Bljguse6JNsUU3Q1ex5xuzzteC62dSltveXT63T4YJFkAEHIuBy5KWtf15pLQm194urEiLZ3nEO9XjOnm92cgrvrFIpjTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rEz9hs30ppLvaospWuCdJXxobG5jOrMjOleLAAFcqFU=;
 b=Sq3gmfhUKDbEwv+yYIF8BntcrQq/5qn3uO/WSrzyhGujsARd4oJ1lYa2WumHpRn4b52ZaqXonbytNDBsnzXVykLyC1eTbNeW96Fc6GuKAPo9epf4vVp6uo50cjtkrvtiPlSV/vhpbC51awSr5O1mr8Sqlt1ooCIFM4+NtDAd64/C5TZv9y6JnIFKm+nH/77xARUy3RB+3BAMdiVodfaXRys34d1+/iiftLI8pyrLDtQPlsRcYif4y6VjyTSyKOAltLZpeKfD2V0N7ReUsUFxsvbp4MtUDLV4hygjSf+bUm45/R8TnzozmveWinVGI/GXWVkzZY+xFKD4BOoDAnpugg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rEz9hs30ppLvaospWuCdJXxobG5jOrMjOleLAAFcqFU=;
 b=NGgdYVUc10pfs1dNTLtFl8cpZR1sAxyhirhwilr9t4H7r0RC9B9VAmSuBsUSVznVq8I7nS4b5RHqI3HRIqGLMl6UaXdNqWnS+zG753+bGm71+i+9Ms+m8+/8mN/r9Ydv7NRX7kPxInLpM6gscrQk3dCnQ4AchOsBN3mPJDEdBlU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AM0PR0402MB3651.eurprd04.prod.outlook.com (2603:10a6:208:5::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Sat, 4 Dec
 2021 20:11:58 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8d61:83aa:b70c:3208]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8d61:83aa:b70c:3208%6]) with mapi id 15.20.4755.020; Sat, 4 Dec 2021
 20:11:58 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH v2 net-next 0/7] Rework DSA bridge TX forwarding offload API
Date:   Sat,  4 Dec 2021 22:11:39 +0200
Message-Id: <20211204201146.4088103-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS9P194CA0030.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:20b:46d::26) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AS9P194CA0030.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:46d::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Sat, 4 Dec 2021 20:11:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 84607710-4896-4c1f-5046-08d9b762533f
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3651:
X-Microsoft-Antispam-PRVS: <AM0PR0402MB36517578484BD5157F595D44E06B9@AM0PR0402MB3651.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zJRkNo98AKKLXcCiMx2dpztsPCjSccoogbZwn0Zz/TmWiNRIySREEAUpIESkcpayMgrFgVma79kCSyYIBlK5ZT7ZcIvshkcFO5ET208HxcoXzzqGJUztkhy0n7wAK0wxkhFh63kxCknhik3A5SxCWUGkooeYaCR5UAQHHl68GstK3FtfZAbBaR1Kencfrh6hWbhDlJgBlAp1UTyKAA1YwLHuTknvhEwGGc02ZwVzSS9xhIlsXTlP2Z9H9ZRJPmdKmvw6LDtnBBezQqGeIf6Cyhdyv3LsPcdzxHOichGPdwsKQX/hYpyVPALeGAMOpi3PI2XCwiEGOJtf3ldEL/xZCUE1XuAUvDAs46kEZE252FHJUj9e6Ew8OFbWt9cqWWLRJBgZoQtETGpkNSRPk05SIvC+lz6YOK85wDuVoPu+y6wcL+UGqDQ3vsz8q4DbUKgpTBt2uarc4gd+yZ5SvNxMUkGYB2zGkXgj8UdQE4wX7Fan++/Bsk6irqJCk0MRYOpOlETOeVs66Esi+Y52kCt03AJNZy7owxNoXcgfCoRr9ETGLSclDPBbVTlMKBvWIJSIo9jlmbH0CAYO+gjNCtYNATFQSaL5ZlaxTvoZaEGKipTY+lo/C1e1ygsG3OEWdEux4+PHjUZZVKOAk4XZNhjDxbrLotHeYc9Sz2EWQiiYtsmBqQAbSy+lf+DlSvwvGk4NjnY5OX6EkJezBOJkWx8wiYRRw3B8qjMVPqNkMfq+MFTewNoNDFOhBvzAcJOSQQMmJKGS8ILqwoQXlEb3t8x+mDxLAfj8Lka9BVilAtf0aOM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(8676002)(6506007)(4326008)(6486002)(6666004)(66556008)(8936002)(508600001)(54906003)(2906002)(44832011)(66476007)(316002)(6512007)(86362001)(66946007)(7416002)(52116002)(1076003)(83380400001)(38100700002)(966005)(6916009)(2616005)(38350700002)(186003)(956004)(26005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UFhkVkdhY3BvalB4QTFTWGpxbXU3K3V4ZzZmSUhiN0xkQVpDTTRpSmJQMXNO?=
 =?utf-8?B?eFNveCtVKzd1K1pyK0Y3dkRlZnZLcmg4d3pVTXM4QTBwSFkvZnJBSndBN21j?=
 =?utf-8?B?WUgwS2NYMkxudW1RMCs2YW92UjZWeHJOQjZSQ1ZFc3kvdHFHYytxTHhnUzZS?=
 =?utf-8?B?eG9SdlNkajlFM25xSUhobEh6UFVLTk95Y1hoUWZMT1dvYUFnaDl2ZlVZS0RX?=
 =?utf-8?B?TURtZXp3dk1aUThzODRMdmo5OS8wcVRrekdYb1BmOG5uOHUvSnlLTVQ4QWxz?=
 =?utf-8?B?ak9yUWU5WkZNNkRqQ3R0d2VEU2pCT0RuOEt2RGZiWWI1bnRKT1hZUzhxQTha?=
 =?utf-8?B?NHpWR1pnNitlS1YvZC9zSEdVUEtkYzJRM2JLQWMvWGhnQzZ3ZlEyVjhscUhY?=
 =?utf-8?B?TGRHTzZSYXhrWld0WmdhY3p1OTdYY21XRVU4YS9vQ1VjS3FGcE1JbXBnMC9Y?=
 =?utf-8?B?cEUwZFJlaGc4eUVSdWhuNFV2OGxydFZ1OTljOThZYy8vcFQ1c1RnVzhrcVJB?=
 =?utf-8?B?MVZlVnh4YWxtRHJZRm9RdXlycVRUS2FCbUVzOGtGR0h1dkVDUGtyMVg2TjRq?=
 =?utf-8?B?ODF6VEx5TXhwbHpwbmE4Y3l3a0VkNnZJaVFLT3NUV3UrWkRCMGdwS1hVa2NS?=
 =?utf-8?B?K3NEWldUeXNNQnV3WlFmQmVzb2x3cXErcnBTanh4bzgwUnZZSU1sS00xNzJR?=
 =?utf-8?B?MGM5b1lSSWx6ZlRlT25RcnBwR2lsZEFkcmFlTVFGVXpIaThROUdPeGFHT3Ax?=
 =?utf-8?B?ckI3R2Joeks1L3dONlNxRXFab1cvVHJiMjc0S0pLZERMQ2VVd3lIRDRxNUYr?=
 =?utf-8?B?L3ZQaXNMZjBjWHdSR1pIOUZKWHd2Nm5GOS9XazVWYmhHTSszbDRqS2lLcU5X?=
 =?utf-8?B?N0hXSDFwY3JlRzBZMHhBd0FjWDhsTE1sdG5QYWFyRDVJNlFwdFFXcGx2WTh5?=
 =?utf-8?B?MkdBakh5V0tHcjlWaXROVDlsbDVtMWtqYk1Udy9EeXh0bDRsRjZIZUR5SE1o?=
 =?utf-8?B?c1JpeGNEaU1ENWgrZFFuMkt2R1N4bE51cGQ5UXl4eGhzcUV2SGxHaS9MR2F3?=
 =?utf-8?B?bW9qRjVuM0wwQXVOV1phWkQ1ZXUweUlSVjZaZXl4dUlOZ0drNFI2dVlIZUtu?=
 =?utf-8?B?L0drcERCUXBwWGt3WlpMTzY0WjBoNFFYbWd3LzAwTi9lT0o1VXZBVktaNitv?=
 =?utf-8?B?aTBKeTVvQ1NSaVFzY3RLWEtrZm82U203d2ZHSjc5SWlycjRuOERNMUdrb0tO?=
 =?utf-8?B?RFkrbGxTL1NRWmQ5Ym1sK0FFUnlJa3dlRWE5eENwc3U0OUxtOWdYTmx5SnJR?=
 =?utf-8?B?UVF3SWNIYzU3N2VwYzBYVkoweExvQ2ZFMFhmTW9vTEUzRkIyZm5yU3AzM0VY?=
 =?utf-8?B?TWpDZGJSWnJDaEt6TDFEVC9xN05WSnZRRng1R0FLd29UV3NjT2FBVU04MVhz?=
 =?utf-8?B?WEpicTdVWVN1SWpCL3FWaVdjTHVhSTdUWXdLQUVCRmZjTUQ5dHZmcU5OYnlG?=
 =?utf-8?B?WXRZQ1pESjFTK3dDam81UHVaaWd1VTcvUUM5eWVabktEYUNpUnEydVhObkpR?=
 =?utf-8?B?YWp4TlQ5YWpaN2xzSS9Na2dBZ3hTTG0rUzFFYUgzb1U2NjMzS0YwY0VXWE1a?=
 =?utf-8?B?RXhPbWlDSWlGaUk5Wk5ad2tuWnYyekZBejBNREZsWlRPdXpyUFRLMElUbk5T?=
 =?utf-8?B?VFgreDJJZEZ5cVplMTJRbHFDOEdoV0loWUR2T3dmWEtNWnJ1akhaZU40WVNS?=
 =?utf-8?B?cytyZjNnVllmUUI5NlZoUSthZDIxd1grZEN1bHpiYWFLRStLZ203RDd5RTFL?=
 =?utf-8?B?c2w0Z0Y3TGYycTA5LzVCZTM4WklsWFNObGMxQ1orcHlyZnh4RlZNVCtxZm5Q?=
 =?utf-8?B?NkpCSEVrUmJZRXFRQWVud2V6cFhuR1phTnA0b1lBbzBuTW5ONGxLMUNFOFhy?=
 =?utf-8?B?ZTM2TXFOMERVb0lqSmQvV0hPTEN6R29KcXI5Wkl1R2R4RFlNMzFVSlNtSnF4?=
 =?utf-8?B?bGVtaGs5TWhyLytPcXk2TTNNeGxHRUorYmxPTVZPbzdnNUI4RmVXR1NjcW03?=
 =?utf-8?B?cnNMOVlMalFJUkxQL3I5WTllb3pmR2REMDU4aXdidGdxV2E4S1lXZ0dYb1dh?=
 =?utf-8?B?TG1MNUw0Sm9JM2FtK2p3TFZpbWdFOGd3MUJVV1c1UkRBR0wvMWlYaTNZSU9R?=
 =?utf-8?Q?ULCcwldlSMqVk+mWw36Aa6Y=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84607710-4896-4c1f-5046-08d9b762533f
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2021 20:11:58.2651
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9/XoU5XIykRI0MdDS5F+LGUdm+zU4SQJVVo1kWe1LdK85fcjZQZeZnwJK8JYjoubbxSx3A+yzQJiyeip4IxUmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3651
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change set is preparation work for DSA support of bridge FDB
isolation. It replaces struct net_device *dp->bridge_dev with a struct
dsa_bridge *dp->bridge that contains some extra information about that
bridge, like a unique number kept by DSA.

Up until now we computed that number only with the bridge TX forwarding
offload feature, but it will be needed for other features too, like for
isolation of FDB entries belonging to different bridges. Hardware
implementations vary, but one common pattern seems to be the presence of
a FID field which can be associated with that bridge number kept by DSA.
The idea was outlined here:
https://patchwork.kernel.org/project/netdevbpf/patch/20210818120150.892647-16-vladimir.oltean@nxp.com/
(the difference being that with this new proposal, drivers would not
need to call dsa_bridge_num_find, instead the bridge_num would be part
of the struct dsa_bridge :: num passed as argument).

No functional change is intended for drivers that don't already make use
of the bridge TX forwarding offload. I've tested the changes on the
felix, sja1105 and mv88e6xxx drivers, but nonetheless I'm copying all
DSA driver maintainers due to API changes that are taking place.

Vladimir Oltean (7):
  net: dsa: make dp->bridge_num one-based
  net: dsa: assign a bridge number even without TX forwarding offload
  net: dsa: hide dp->bridge_dev and dp->bridge_num behind helpers
  net: dsa: rename dsa_port_offloads_bridge to
    dsa_port_offloads_bridge_dev
  net: dsa: keep the bridge_dev and bridge_num as part of the same
    structure
  net: dsa: add a "tx_fwd_offload" argument to ->port_bridge_join
  net: dsa: eliminate dsa_switch_ops :: port_bridge_tx_fwd_{,un}offload

 drivers/net/dsa/b53/b53_common.c       |   9 +-
 drivers/net/dsa/b53/b53_priv.h         |   5 +-
 drivers/net/dsa/dsa_loop.c             |   9 +-
 drivers/net/dsa/hirschmann/hellcreek.c |   5 +-
 drivers/net/dsa/lan9303-core.c         |   7 +-
 drivers/net/dsa/lantiq_gswip.c         |  25 +++--
 drivers/net/dsa/microchip/ksz_common.c |   7 +-
 drivers/net/dsa/microchip/ksz_common.h |   4 +-
 drivers/net/dsa/mt7530.c               |  18 ++--
 drivers/net/dsa/mv88e6xxx/chip.c       | 140 ++++++++++++-------------
 drivers/net/dsa/ocelot/felix.c         |   8 +-
 drivers/net/dsa/qca8k.c                |  13 +--
 drivers/net/dsa/rtl8366rb.c            |   9 +-
 drivers/net/dsa/sja1105/sja1105_main.c |  40 ++++---
 drivers/net/dsa/xrs700x/xrs700x.c      |  10 +-
 include/linux/dsa/8021q.h              |   9 +-
 include/net/dsa.h                      | 108 +++++++++++++++----
 net/dsa/dsa2.c                         |  67 +++++++-----
 net/dsa/dsa_priv.h                     |  59 ++---------
 net/dsa/port.c                         | 123 +++++++++++-----------
 net/dsa/slave.c                        |  34 +++---
 net/dsa/switch.c                       |  20 ++--
 net/dsa/tag_8021q.c                    |  20 ++--
 net/dsa/tag_dsa.c                      |   5 +-
 net/dsa/tag_ocelot.c                   |   2 +-
 net/dsa/tag_sja1105.c                  |  11 +-
 26 files changed, 422 insertions(+), 345 deletions(-)

-- 
2.25.1

