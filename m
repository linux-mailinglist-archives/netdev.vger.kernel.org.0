Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE13B3F5D3B
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 13:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236681AbhHXLmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 07:42:06 -0400
Received: from mail-eopbgr80078.outbound.protection.outlook.com ([40.107.8.78]:43248
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235897AbhHXLmD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 07:42:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tpw5VhiKGhrWjZKA8TOlPFK5KQfc/YXjzSJJsIZ8D3Ersorm7Kj6kSU8aGtqcfKLsbA2/6NorfuJlts76uGpxVFlumOn+G1BFNrY62Hpd19HQgWa2vTKE43Per4QZ0iYd14LJ8/OZDgqXtH//YP8FrfROtYtUPx+ZUjRQjZ7wYEDB/wAuEDmhZSxSSX2zYyu5flbOGqZVuPwTd310Zs8sS6w+73w9SqZRwUCxf2EvodPY8AE4sV4SjhVnrnHMQT6uQb6cw6AnUcJYAaQHMfa1iAjGdkr+ZmXsl31PLZ9nHAVQKnhx40KJyFHWnXHacY4ECJYBv7oWxjbibmsGx5m3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7lou0HBHPxEn9a2/m1qYfNWteyYhXD1BHNDsjkLomDE=;
 b=XOsiSanuBKtNjtfsbzyVaGqgpFGDZwXO+ukUI6qGOjYO5D1Yzd8zD6TCUOVIwCfr6t9eoUz4tWCIQNNcjRoJMSUYWM5HiDS4UUsgh5apBPnpersmdO+4tstNaNrgpbuUPNZD5vHuFPBlWkrUHyJ1lVDbaC3NWBMvI1jRBq+8BmULYAHPLsws4ijCs+gyft5azDG7fJuHBVTBmaOyEJgCFRILSWQm0Ylnew+u8sWC4dm8uT545oKmP9JUfi6IdSNOkCp8ahtVOrEWsBx4sqTy23J27n2mjtgJnNaU6EVWywMLcaaGrOzV64obG904+/49pwiSUqgjXzUN0jSWnx5Q4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7lou0HBHPxEn9a2/m1qYfNWteyYhXD1BHNDsjkLomDE=;
 b=putG8wZd2I5F23jJqTdWqaxx0WIub1C8mwD50KHrY+x1/Xx5GkfXQVpUxP2/30z0Hhu4OU5ZYnxD4sk4Hvirejqo14aZpjuyoPHfgLAxPdBCeAxxRNskGjc8jvcig/oj2fTohVnkrgkfchqCJ8/5rKwsvXxjbPssmutjC2uTi6Y=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 11:41:15 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.025; Tue, 24 Aug 2021
 11:41:14 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        UNGLinuxDriver@microchip.com, DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        John Crispin <john@phrozen.org>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        Egil Hjelmeland <privat@egil-hjelmeland.no>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: [RFC PATCH net-next 0/8] Drop rtnl_lock from DSA .port_fdb_{add,del}
Date:   Tue, 24 Aug 2021 14:40:41 +0300
Message-Id: <20210824114049.3814660-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0083.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by FR0P281CA0083.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:1e::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.6 via Frontend Transport; Tue, 24 Aug 2021 11:41:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d98027fa-db41-47f2-0b6d-08d966f413fb
X-MS-TrafficTypeDiagnostic: VI1PR04MB5696:
X-Microsoft-Antispam-PRVS: <VI1PR04MB5696B063E56F6BBEAD77B0EDE0C59@VI1PR04MB5696.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6J1MwYnfNvRlCiboi8RT59/T9SE3axciWSE4bh5Dg2d6aXXnoAfe86unfqfnyCWGtfemM08/8BeueM/kvOdjIcA/DfzwOSlC9Ocd4Kops5vXaKiil6ZfCEQ4WkQOEwKzd6wtBN7YJ14XWptgh0swTah5v3o2uNFrvA/xXFQY1houV5kF6Ah2Cpg46eeX6nwVqhkzIM6qflL+mGd3ChBtHDI+ja6+IRtWttR4cuJNIGgS8n1VvbAwGsTuWpygCxAGQkipxL5w1s6xbOSvhSdKmQgBRHX8VTKmcWg65dEESr4ZfowFFTJ8XzdMQhFW4HJTZhjcLtuJfA5N5c9trp022fSUZbFtE0/9TDl78O0vB23UwWLm4aVhp4QUG4/PuMQ80bKaMsHpsHtiBNtf09jMnMvs++UC5eKl1ZGud88gOYF5+CFTiZ1LdxtBDyKTcc/RvrJKllfS8h6f/DWtOA4ibGAVXuFjw0nCZX8Dkjpel6NO0MoPeRBRgRihOD/Ezyz1yPfYv65lKkiZwo412RuZsaBDS2GrmgryoIvATm1dcMldrkmOEYZNuiFAVOGSDsGau1jJ1ChiE5GQlchX2oKYhOIXC3VCkAsi6BjusIkVNe70BD3y9oNQnYmRg0wlWGiDtiAMIuERJwSRVZMENW4WYmg710VKa/gqFqec6Wib+wWNslJ2ns5RN4VJB5gNdPqZSvZuM0vK0FArH+8gwfdgiwrXp8Zwr5a+wy/ruDuKiow=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(136003)(39850400004)(376002)(52116002)(4326008)(478600001)(5660300002)(6916009)(66476007)(66556008)(26005)(83380400001)(1076003)(36756003)(66946007)(6486002)(6666004)(6512007)(7416002)(6506007)(186003)(8676002)(8936002)(2616005)(86362001)(44832011)(38100700002)(38350700002)(956004)(2906002)(54906003)(316002)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dTZtzF53ro6A2TJcivgCWqANiZdmUwBtJz/zZumOOfu/xKAqP7d4nNtUFtA/?=
 =?us-ascii?Q?vjv+g/YZSlmjuA3h1g+xjCDY14M31mm6flV65AHKp6CGbEStBRduyjitdWh5?=
 =?us-ascii?Q?VM97cYSse3GDP20V4savYT2swiGvucofe1j0P38SstLg8Nkz1qUsusHks6F7?=
 =?us-ascii?Q?BXYRcbi0r2XmXObwHKb/QW216Ib8jf+IH5j3QSwIxuQHZqO3Hl0UPRnrbiPB?=
 =?us-ascii?Q?+ZscfqZn7I4NORJTJrYOiwebitcHPYvszZ0c0hNZ2Rbvag3uJq2O0QOV6g/C?=
 =?us-ascii?Q?ZXG60ALmoRaWY4VoMos4g52XljeLA6KBMMSbj56FSSPgmitIBVq4NWeBocA+?=
 =?us-ascii?Q?7iikHU+6Jpi7u/Rll7Acc+jKNmy7lWngmo3i67pe9644dUzk5mVVMasIU0s4?=
 =?us-ascii?Q?dn36Jdv0JCEh9wHtEqi0WKLauEz3WDcn9N9YrlA2k8uVetCkCuPW0i4mGG+a?=
 =?us-ascii?Q?XvGHi0hJ860hrn1Gn2iE+qWAXA8UggZZ4iM5eGAOOtlAFf5UzjUYkDFIR+ii?=
 =?us-ascii?Q?Y+CC6vbxdtHGd4MY8lXZ3WhJt0sPRaSSlByS0q1DYMfnISKjqlT4af3j+bPm?=
 =?us-ascii?Q?1aG47fO6YvBwLy1iJY/dZmieJJIDa2B3N2xznQa04twQwKzR6YZwn1xKKQYC?=
 =?us-ascii?Q?1dXcK9fTsfxKVuHPptMUZ8FTtp52UiJpnRcBtmtHuw2yZ3EgsdYZoJVoR80C?=
 =?us-ascii?Q?V/fFhtOpQGyME48/ZD0a/gT3u5VtB4UShdtB/f/vOAVxSecyyBwgewWj2Nve?=
 =?us-ascii?Q?2yKmXjX7jKoz5JUsCeeAV+mS4P1au3t6xR7LhMsjzIFsLRQwp7n9kxKo+lxT?=
 =?us-ascii?Q?qKeqXpXHbgZJ9fGxXTc/n2Dwwvwv99dGxLSS4jCD19SWuV8hrO2JpMpEwdhY?=
 =?us-ascii?Q?Qb8FQqYNdCp3ex+2wuw6U7svx5Cy7FE7Gx3JKfv6Z5UXY1UZf8uGtXWErtqj?=
 =?us-ascii?Q?2S2ihnQMLSbXESKwltcpHYwMium1kRae5ChdoQzCSMjENsv6ksRNeGhhT+ap?=
 =?us-ascii?Q?JH2qGHlI2KZVYnDk98cIkrFzPshuWOT5KkjLn4MFFkXWyAmSOMod5/bS3Jgw?=
 =?us-ascii?Q?+JJ+vrm3I1l+Tc6B4HbjQTpgbs4BUv/DTUPtXPN/E77McqctErF6iOXwkvSx?=
 =?us-ascii?Q?w9CvGDxTYKQAZG/gRokHd+dH6KpbPhBx8Um1zBQGYBV0VlDLvKQCllrepqAw?=
 =?us-ascii?Q?bggIcttSsqDu4LUbWJX+g92kj3SYVfvfwzewbG/xzZDOHnamaoiet+98leKm?=
 =?us-ascii?Q?qeKcudNzd7w1OwnJU1mBwm/bte5Hwy3jS1qPSYhOttbM0pdMbgYnyxdHdlse?=
 =?us-ascii?Q?dbnRSn+bZAZZtPVlN4kWmXEq?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d98027fa-db41-47f2-0b6d-08d966f413fb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 11:41:14.5587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XDoMOV2LO+mUd44g9gBUMOqzo6BAgpVwsAYhFLl47lxBeORTm3TxceBJYGle6R4eA6xmRGZIW6u7QVgIitt5Pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5696
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a heads-up to DSA driver maintainers: in about 3 weeks time
(when the development cycle for v5.16 begins), I will come back with
these patches and attempt to drop the rtnl_lock guarantee from the DSA
.port_fdb_add and .port_fdb_del methods.

Plans might change, but this seems like an overall beneficial change if
we could make it, regardless of whether it is going to be part of the
final solution for enforcing FDB isolation in DSA.

After applying the entire patch set, the .port_fdb_add and .port_fdb_del
methods will run unlocked, and I would appreciate any regression test
that a maintainer can run on their hardware. Most drivers have locking
of sorts, but I wouldn't trust it, since it wasn't really put to test
until now.

The change set is structured as follows (from bottom to top):

1. A self test that driver maintainers could run while testing their
   newly unlocked ops. It is not bullet-proof, but I have found issues
   with it, so maybe it is useful.

   To run it, rsync the entire "selftests" folder to the board, then run:

   ./selftests/drivers/net/dsa/test_bridge_fdb_stress.sh sw0p2

   For the sja1105 driver, this was an indication that the internal
   locking was not sufficient:

[  282.615386] sja1105 spi2.0: port 2 failed to read back entry for 00:01:02:03:04:05 vid 1: -ENOENT <- printed by the driver
[  282.624796] sja1105 spi2.0: port 2 failed to add 00:01:02:03:04:05 vid 1 to fdb: -2 <- printed by DSA

   The self-test does not test traffic, but it would be nice to check if
   the switch still behaves normally after the test finishes.

2. The DSA changes themselves that drop the rtnl_lock.

3. Some example changes that I needed to make in two drivers I could
   test. I would very much prefer avoiding non-expert, wide ranging
   locking schemes such as an "FDB lock" or a "register lock". It is
   best to understand what needs to be atomic and what can be safely
   concurrent.

As usual, feedback and ACKs/NACKs are very welcome.

Vladimir Oltean (8):
  net: dsa: sja1105: wait for dynamic config command completion on
    writes too
  net: dsa: sja1105: serialize access to the dynamic config interface
  net: mscc: ocelot: serialize access to the MAC table
  net: dsa: introduce locking for the address lists on CPU and DSA ports
  net: dsa: drop rtnl_lock from dsa_slave_switchdev_event_work
  net: dsa: flush switchdev workqueue when leaving the bridge
  selftests: lib: forwarding: allow tests to not require mz and jq
  selftests: net: dsa: add a stress test for unlocked FDB operations

 MAINTAINERS                                   |  1 +
 drivers/net/dsa/sja1105/sja1105.h             |  2 +
 .../net/dsa/sja1105/sja1105_dynamic_config.c  | 91 ++++++++++++++-----
 drivers/net/dsa/sja1105/sja1105_main.c        |  1 +
 drivers/net/ethernet/mscc/ocelot.c            | 53 ++++++++---
 include/net/dsa.h                             |  1 +
 include/soc/mscc/ocelot.h                     |  3 +
 net/dsa/dsa.c                                 |  5 +
 net/dsa/dsa2.c                                |  1 +
 net/dsa/dsa_priv.h                            |  2 +
 net/dsa/port.c                                |  2 +
 net/dsa/slave.c                               |  2 -
 net/dsa/switch.c                              | 76 +++++++++++-----
 .../drivers/net/dsa/test_bridge_fdb_stress.sh | 48 ++++++++++
 tools/testing/selftests/net/forwarding/lib.sh | 10 +-
 15 files changed, 235 insertions(+), 63 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/dsa/test_bridge_fdb_stress.sh

-- 
2.25.1

