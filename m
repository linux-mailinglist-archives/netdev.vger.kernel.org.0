Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5B02D8DC5
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 15:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395285AbgLMOIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 09:08:40 -0500
Received: from mail-am6eur05on2041.outbound.protection.outlook.com ([40.107.22.41]:10034
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726723AbgLMOIb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Dec 2020 09:08:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KgOFAbf0fG8DkGXJy8TYjmg5YPRd1n/D+KabK9S/yLN5o1tcru/aT1xtMz+FDFw264AO0r1fhtFtweVG1O4guT9uAzmE7GkKW/xvvf81VpHXz8tg6AfX/pvftgBvCREp2aWIr+MgGnQNkBx8/WkBL/99fnYIPGHFqM7lVQa/MZMU7xluSVyJgpkotArnpEcSbelisf6t+y5T0K63VCiX6I3vg/ituFeCKYre2rO9KYMfeOEsjNcykABLt34Vohcrv6MTv5AV2I8OIekxiMdLOdX4Z+/wsm/fZarPvZ+6JnCRgwjJuWSn4hraeVesxAgkZ/MxFqkpuTLTaLZsyt43ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ylaZDEo7pj/8yP1z7Gk7Po/YAjQTTxVqHWZyOAEa3Lg=;
 b=IK6vHITCQxVvR2g6RIAL4cJRgtIfyYeXytrXcoDQn/9yP9f16zDyf5efafZGPWf6TSgPG0Rr/pS9RntSxzmOV2E8WEV14txoG3wOUVgbavaPaF8YrMEZPsKgqz6Axb5DjAcROMDrrYuXU/i14KMv8hsKY0tSrDpaYYeeuG5C61bH3zzL3kdD0dYnwEagq2jvXDW9GB/+hPpfTxTI0LVXyAdYgKuoQvQwCB42kyAFaz6UF/Un160ZaPPYYe9YqY313bc36kPG24xo39h4uwHjrLYJaTFNlOLe/Myx2vDq2NhSmsFPsdEHtA18yhb2fd0XMkw+VjLXiwBQF6PykR63Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ylaZDEo7pj/8yP1z7Gk7Po/YAjQTTxVqHWZyOAEa3Lg=;
 b=F5VcbLlBiwgglydu3hHcW4arJiQeJh4LFSIRZL127Q618WDTbc4EfFPZu3jbsNfpxwKD7iIi1ZyuoO4+W74IRtNgkBfIHZGPr7Jg6AVEsdIMTRz2pbDeketOAiaLt+PDu7g+fC4+PBRUCoGHxr6gDLVb3VvaSK5exWsGGzHiduM=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB7341.eurprd04.prod.outlook.com (2603:10a6:800:1a6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18; Sun, 13 Dec
 2020 14:07:37 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3654.020; Sun, 13 Dec 2020
 14:07:37 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek Behun <marek.behun@nic.cz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v3 net-next 1/7] net: bridge: notify switchdev of disappearance of old FDB entry upon migration
Date:   Sun, 13 Dec 2020 16:07:04 +0200
Message-Id: <20201213140710.1198050-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201213140710.1198050-1-vladimir.oltean@nxp.com>
References: <20201213140710.1198050-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: VI1PR08CA0235.eurprd08.prod.outlook.com
 (2603:10a6:802:15::44) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by VI1PR08CA0235.eurprd08.prod.outlook.com (2603:10a6:802:15::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Sun, 13 Dec 2020 14:07:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c592c9d2-5c6d-4d98-0ca6-08d89f707211
X-MS-TrafficTypeDiagnostic: VE1PR04MB7341:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB7341C740DE753FC76317F973E0C80@VE1PR04MB7341.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PW5GE1bXdXbFuj8ZUB5M7sO+69wmJM8MAMFtVEv7OfcJzHITWi0QNEKmi+In60qDEbMwMvXgbjkoK5zMEob8xpt5FADnQjys6lbn/xQBdHMzpX3/I6TXqTvJmKPqpJuwDCN7b7acGZHilzFdwTOTeF5kq6D5SqLM7SLXuPoRFn40birZ9s1/4u5py4tZbewLP5gxDY5RHlqJzyXKRr2QYAgVd5Mvlkb+RH88lD+1iGPJ0hY3q42pdCIPHQKOcvCOwpW+UXFsaFiGZzQuoyQLQ3FaYxdjwD1uNGvRDUb3DAeQDB1gwZClB5jIBsXzusidlIyscfSg1YtAUF9+qLLXmm+jImLWcBQZQFDT7JbbfoF5i1cypy80aq5tY85gJRcqOFE37TZWQQjoiCWcK7yFvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(136003)(376002)(39850400004)(478600001)(52116002)(7416002)(5660300002)(1076003)(6666004)(316002)(16526019)(186003)(86362001)(83380400001)(8676002)(26005)(6506007)(44832011)(2616005)(956004)(69590400008)(2906002)(4326008)(8936002)(921005)(66556008)(66946007)(66476007)(54906003)(6486002)(110136005)(36756003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?QaIiJ64A2+L1LUgfTX9p91vylcQC6ds1ARiXV8b/Ums+8uOAEsYAEkB/46d9?=
 =?us-ascii?Q?j8gkjlk92bUiBWtEdus7ezQ3IkEfwT9nkU+NPlq66ghjwXloTxtvvDWk/ALN?=
 =?us-ascii?Q?Iv+NwVTMRitl3wdPVh7YbiJODChN1wKb3Jot9Ieq7iphNQqQMeLLF8ymUobk?=
 =?us-ascii?Q?VDYC+uDJgmUvCO4aRy6GhXK8QUK577w1CHFzak0c8YP1aQlUzCOs9SgLLzRy?=
 =?us-ascii?Q?J74mdEQTfRhCBOmeEU4J627GWciIely5HLZkrSNjNnB5+MTVDrOOGX8s+b/0?=
 =?us-ascii?Q?pLU8jrYeKPQRE19J5DSM+0Ii7RnswZ5RQYRDCcmdhqxVtS7qyT8HkzJAondr?=
 =?us-ascii?Q?dyya9RjJGjH1kZb8aGhv3nAu2509hbhVqLdSRKtwz8nn8ybWmRMJx+a/+T6x?=
 =?us-ascii?Q?uo6iRUw8SUtIGQ5ELlGG57tEb98F5pYGqnO92liE2PVRFpqLgvzsau5laEDh?=
 =?us-ascii?Q?O6gqpvXlra3PixvhZrFX05ZUC9ZvVTarsS9g+BobUT4rtw3tJXItpaiJdxFi?=
 =?us-ascii?Q?CjaJShnF5pKzhLvbscg4Cr+VZ/td4f+BTFdo6BSf9uyv9Cio3R4KzvIgZ/AG?=
 =?us-ascii?Q?Nmn/o8i6sPzRx93c5QFxf1+iNufq+FQl8O26TiG1MeBnk8Uvm5M5q56uKtKl?=
 =?us-ascii?Q?WNe6TjuhgHtdiKtAnbgExQzgvvt2A/1xesfiE252TPthFc8V/XWHH+SJodtY?=
 =?us-ascii?Q?hYNMMC3tfOuoRTpXMs/U0Jk5teJ5HJVT08zqCutcJ05MK2WT50P12197pupn?=
 =?us-ascii?Q?jeBqUXZMD5c8NqoYOP/8l95qNiI865VYdFc+Ig2uw2tOes6fAOwE/vyIAVlF?=
 =?us-ascii?Q?hV0aut4pEAbBfDTifYaq6dg/4W8CRkaPP2wKfhNHNaw62PEAZCPZcZdzUUdR?=
 =?us-ascii?Q?G3WzGhxuOeVhe4INitouCMRaHOWGAtpZxBiF30UkyeYZ5l+VSbmatHnco+dR?=
 =?us-ascii?Q?HqsrmpVlgVRsZYHQTKGtnkvAcXD1XEgOqM5693ZBgL4cpOnPl0+AjV+BuWYG?=
 =?us-ascii?Q?V4fr?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2020 14:07:37.0559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: c592c9d2-5c6d-4d98-0ca6-08d89f707211
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WSGLMW/84DcJmm6g1x1ZTLdy6UToRLOLaR+TNPQhJefo/EQm7JUVzaOXBYSt3b1udA590ZVqPbKKw7mUlraMGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7341
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the bridge emits atomic switchdev notifications for
dynamically learnt FDB entries. Monitoring these notifications works
wonders for switchdev drivers that want to keep their hardware FDB in
sync with the bridge's FDB.

For example station A wants to talk to station B in the diagram below,
and we are concerned with the behavior of the bridge on the DUT device:

                   DUT
 +-------------------------------------+
 |                 br0                 |
 | +------+ +------+ +------+ +------+ |
 | |      | |      | |      | |      | |
 | | swp0 | | swp1 | | swp2 | | eth0 | |
 +-------------------------------------+
      |        |                  |
  Station A    |                  |
               |                  |
         +--+------+--+    +--+------+--+
         |  |      |  |    |  |      |  |
         |  | swp0 |  |    |  | swp0 |  |
 Another |  +------+  |    |  +------+  | Another
  switch |     br0    |    |     br0    | switch
         |  +------+  |    |  +------+  |
         |  |      |  |    |  |      |  |
         |  | swp1 |  |    |  | swp1 |  |
         +--+------+--+    +--+------+--+
                                  |
                              Station B

Interfaces swp0, swp1, swp2 are handled by a switchdev driver that has
the following property: frames injected from its control interface bypass
the internal address analyzer logic, and therefore, this hardware does
not learn from the source address of packets transmitted by the network
stack through it. So, since bridging between eth0 (where Station B is
attached) and swp0 (where Station A is attached) is done in software,
the switchdev hardware will never learn the source address of Station B.
So the traffic towards that destination will be treated as unknown, i.e.
flooded.

This is where the bridge notifications come in handy. When br0 on the
DUT sees frames with Station B's MAC address on eth0, the switchdev
driver gets these notifications and can install a rule to send frames
towards Station B's address that are incoming from swp0, swp1, swp2,
only towards the control interface. This is all switchdev driver private
business, which the notification makes possible.

All is fine until someone unplugs Station B's cable and moves it to the
other switch:

                   DUT
 +-------------------------------------+
 |                 br0                 |
 | +------+ +------+ +------+ +------+ |
 | |      | |      | |      | |      | |
 | | swp0 | | swp1 | | swp2 | | eth0 | |
 +-------------------------------------+
      |        |                  |
  Station A    |                  |
               |                  |
         +--+------+--+    +--+------+--+
         |  |      |  |    |  |      |  |
         |  | swp0 |  |    |  | swp0 |  |
 Another |  +------+  |    |  +------+  | Another
  switch |     br0    |    |     br0    | switch
         |  +------+  |    |  +------+  |
         |  |      |  |    |  |      |  |
         |  | swp1 |  |    |  | swp1 |  |
         +--+------+--+    +--+------+--+
               |
           Station B

Luckily for the use cases we care about, Station B is noisy enough that
the DUT hears it (on swp1 this time). swp1 receives the frames and
delivers them to the bridge, who enters the unlikely path in br_fdb_update
of updating an existing entry. It moves the entry in the software bridge
to swp1 and emits an addition notification towards that.

As far as the switchdev driver is concerned, all that it needs to ensure
is that traffic between Station A and Station B is not forever broken.
If it does nothing, then the stale rule to send frames for Station B
towards the control interface remains in place. But Station B is no
longer reachable via the control interface, but via a port that can
offload the bridge port learning attribute. It's just that the port is
prevented from learning this address, since the rule overrides FDB
updates. So the rule needs to go. The question is via what mechanism.

It sure would be possible for this switchdev driver to keep track of all
addresses which are sent to the control interface, and then also listen
for bridge notifier events on its own ports, searching for the ones that
have a MAC address which was previously sent to the control interface.
But this is cumbersome and inefficient. Instead, with one small change,
the bridge could notify of the address deletion from the old port, in a
symmetrical manner with how it did for the insertion. Then the switchdev
driver would not be required to monitor learn/forget events for its own
ports. It could just delete the rule towards the control interface upon
bridge entry migration. This would make hardware address learning be
possible again. Then it would take a few more packets until the hardware
and software FDB would be in sync again.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
Changes in v3:
None.

Changes in v2:
Patch is new.

 net/bridge/br_fdb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 32ac8343b0ba..b7490237f3fc 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -602,6 +602,7 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
 			/* fastpath: update of existing entry */
 			if (unlikely(source != fdb->dst &&
 				     !test_bit(BR_FDB_STICKY, &fdb->flags))) {
+				br_switchdev_fdb_notify(fdb, RTM_DELNEIGH);
 				fdb->dst = source;
 				fdb_modified = true;
 				/* Take over HW learned entry */
-- 
2.25.1

