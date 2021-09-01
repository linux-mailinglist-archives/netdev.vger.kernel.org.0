Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB633FE5D4
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 02:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244005AbhIAWwL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 18:52:11 -0400
Received: from mail-eopbgr00087.outbound.protection.outlook.com ([40.107.0.87]:32899
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230235AbhIAWwF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Sep 2021 18:52:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QB2wVu2gJwdUJ4iCYZkyFGXthJEyKExvVwmLA0VuSTts0VDP9rvyR3UpeAYzDV5swJzqOSg6wzCrF4zGaddnAHxqi/cmP6kXafSoTRqjS7+j31qluCykAmAoSHoFgtOoLhMwMOsiZi6ol3pGkNo80IUAIrF4YgTwlsjJYwzrb867L8iFCKH//tcfkBT6JLyT6t+c2X2Ki8vtjiCRNrTgwuW7VgV5y2TVW3OCixWhhZh1ThBrgAC3EVTljQQhUEWwx6+JlK8WN+7mrUSV1Dq5a/LhAb1Cy747XxPf8xPFMjQEGK5GMCZXigQL/RblF24U+yTvanmNmiPBe47hyPk2Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=WqMyDyVbI0SpZwM5B8+Eb4M0azRMsbR+wqWo3jPtsIU=;
 b=O1hw90EUYVNbxv6j4GvfRBW7megSZbl3WAX6PfJ+uCvzvHOgawnVJ39z7Ff4GTOcGcqmL0nUBuSisdeFmYTHvPYbzwwOcPKx6tuPfms/c3DJwTv0rTvrJ1uxoBMfBziYFAZ3LGztiRLK9S6w/DmGM1vjVlMPlDQW+Ttv2l1y1edMtaoW6pjeZX3nO8jnX7dKkR5s+ci0/Iaj6vcb4cv2Z0z89mPmpq7g4jYkwcwf3emuBTws+5i1fJxPJfpPKlWk17J6mosigrHFEipsjFdGd60zpz/LO4GqxNiobVe1AElLJu/6/t34DI2nOKvrtwRTWCiRJ00FHP84INLNV9cMLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WqMyDyVbI0SpZwM5B8+Eb4M0azRMsbR+wqWo3jPtsIU=;
 b=JXGt+rMu9yhAoha2SBEACMlW76L9W/tROWrATtidCAkt2FaqFqyfkFX2TgvfUWyG+7WX0HjrgmZZotQcMIH+H9P9l7kJSJEXOJ1cuKFvdN/5iXY2fNZEeYie2Z52qWYa+0FoXJK8w3vQ5hTARKRlo/u0fdeUhNQSzknAfyRoYP0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6015.eurprd04.prod.outlook.com (2603:10a6:803:d8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Wed, 1 Sep
 2021 22:51:05 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4457.026; Wed, 1 Sep 2021
 22:51:05 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        kernel-team <kernel-team@android.com>,
        Len Brown <lenb@kernel.org>
Subject: [RFC PATCH net-next 0/3] Make the PHY library stop being so greedy when binding the generic PHY driver
Date:   Thu,  2 Sep 2021 01:50:50 +0300
Message-Id: <20210901225053.1205571-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR04CA0130.eurprd04.prod.outlook.com (2603:10a6:207::14)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.78.148.104) by AM3PR04CA0130.eurprd04.prod.outlook.com (2603:10a6:207::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19 via Frontend Transport; Wed, 1 Sep 2021 22:51:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71ae9655-a08d-425e-28b2-08d96d9afacf
X-MS-TrafficTypeDiagnostic: VI1PR04MB6015:
X-Microsoft-Antispam-PRVS: <VI1PR04MB601554FC8F36CAFDC7F9CF28E0CD9@VI1PR04MB6015.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uD0rTEC6cJBLsEdmHXETg8oMrZizuI21pXtB9encR6/ePu4HznFUdt703TAFyqqJMUOwXiNNSQO1e8wB5kx72ipLnWoIRw2VoBWWanUascPVIZptddsBUiqpFUW53KRk7hhhO9gakCf50ds4fzICFuwXynS4fL27cAzpQr/Uorv8r8qeE/6Blh4F7pRr+PpJmhIdoKwy79mzt2Ryii0JYLJggelzhlQ08zbtQjPV35LvZBgZiWeZHYQL5MTs7Dm9uHMtvY/MMn0LnTttKKs1sKB11vg2Q+soWEDywtoMqjM5lJ+S3aOvnA9bamd+yP1pSsXOIjFoo2abDLnnhO/b87eg6i373NMKutAW5w/JApRC+fINzlxr4XPDT1piwUU3Ja6HNa6nUAxJfC4FZUBXTFBXVP//f3j47rX8nEmJi5VE1lKEEmAf9ZgHLE+EKZ+Ko0rR6MmD0p3fF1Ce7m01QDn8sjIRPSZZ54YGgS7IpCqW4magZnFOM0/s6tcdO1z9mGzSw4VW0sP9StoKoHAcInJrR82Vv1tmlGYlMJRbLipYm0ps+a1c9DuNaLSn6rrwB2RU5rQKHCjtQ3c5VwkpQzi0a7/FlsN9u8CeUncV99B2hr4eel/hspXUL7Hh4zMU81Xx8UYjxQOrXkwFXsM/sOf8B+c92F5BeKKpNmx5KR2Wgx/NHb4jcWebGLNzA2mpIUhUHROHs5cY3B+vlFAdmUZZ2m+R1T4z7H2WeERqGci5NkMuh+J0NOX20iS4jTdseFnCI04q+Mj79z/D0oMD2AGpuHfvsshxv0Ys2KxeXdCXg2QfTdCYiead9K4EVWJm2EH/uKv5Y+l4XjtagQcC4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(39860400002)(376002)(346002)(66556008)(66476007)(83380400001)(186003)(8936002)(66946007)(26005)(6506007)(52116002)(316002)(36756003)(478600001)(5660300002)(6916009)(2906002)(966005)(7416002)(4326008)(6666004)(956004)(86362001)(2616005)(6486002)(6512007)(44832011)(1076003)(38100700002)(54906003)(8676002)(38350700002)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DJKHvUc99Rs6pwv8jmzk4WqDDM1Fx8/LtSxcVPOvuH+XZhzLl9wJHh92M1TW?=
 =?us-ascii?Q?JaFn0Q5ocX9bP0FKXVx+gi2Bw7tAuypStpwobCQHPxMr8Y0xeSuL1FsEMpmg?=
 =?us-ascii?Q?KMtVp9kxxXPE2cJ7jE8xjb0fzN6WHkgWOjzEW43QlkmM+kWbaeL/gMy6BS9Y?=
 =?us-ascii?Q?WygYLpj98m2G/M1NAJpnpDb6N8e6zM/s3fAO8uB9bC5U58CH3WtWny14dHcI?=
 =?us-ascii?Q?Ig/Q0pgZ41j6XkpPCgP5AJAFnF4GbEzkKTGhnE79VnOJyD/t8V8vCKOCN3jE?=
 =?us-ascii?Q?conGpGkm1XOxUormeaHrLdTFagfCXfs5kPgbdv2bcZd7RqEoJkP2VgDFGsOg?=
 =?us-ascii?Q?56wju/vyl8954ig3NIjm7KqJwbYGmrFCfwgwGP/DZPOVzK9FmXeJNzpTexjO?=
 =?us-ascii?Q?fRGuYvT4pYPleUfNUarHWWJp5GH8QoHRb44jnb5CLVZ3QD5Ns1e4CM4/+IbH?=
 =?us-ascii?Q?mWhTYRBrIeEphxH0O76U8qiZjju3OrGjjRc9j5Idh9Om+u8RRXFIfwiRZvZe?=
 =?us-ascii?Q?nYHnKFRAtlQ+6dXqbLMu3QWVdDaaZ9tIYaHVVqIdBFXMfojB/Pr7k9963GLr?=
 =?us-ascii?Q?edLDG2k8R8uH4SC4qBlBwVI2D0fWsEQ8CK5XT7aIcNEvLFWOYfYaX9NsJSxl?=
 =?us-ascii?Q?7aSBqBBEZ/Cxw7XlrYfNrSWT7rRH01FgJ5UTT6BlQbGgEQtfvmkFnaxUsmnZ?=
 =?us-ascii?Q?nHzdG3GvOQqcfCkSkZY3rHNZ3RzQYr2g/mLK7OX5V6AQ3hbtXu4Zxjwu5REG?=
 =?us-ascii?Q?3u7mVZB1zeDbnZK6OhizzhfU+pdPclqiY8xssG0A4LuaFkyLXM927xDq97Dz?=
 =?us-ascii?Q?XWE8NoRncBtEZ2KQKJ1cMMrJhqSs6s8O6P57HnT5p+SOqDq4+06t7CVxvyff?=
 =?us-ascii?Q?6QXlVLh6Av5YP3vmkNFu98kA2XOvzQopseHG3EFY2yPAfOdT31Sw+sixv4G0?=
 =?us-ascii?Q?KYXqOUZboc7N6Lon3GMipMqG9MYvmNrRgShoBrVQJoqryDoAIWnu3FqaIcfT?=
 =?us-ascii?Q?vmKE7F403ZqgefK3YoS9urYrjQ9W/b4Ghi4G4dm/K07r7v2xZRvpsxPvQtwh?=
 =?us-ascii?Q?Kkn9EED+wkmazCMRHPUYuRwlCdw9kx2etXRkayDcUJfvRrYPiepVIaCEZWkw?=
 =?us-ascii?Q?7+AFYhos6aE1dlt+utvkCRstQbKasz+Qdc89F8zM2DTNXjK4b2LdR+jCQOXP?=
 =?us-ascii?Q?pCRKMRC9AH5OE7nPx3uBJmHWk2KfPg0vZikVGdcPiYlah4QlyxM+4XY5/6Om?=
 =?us-ascii?Q?eHFMUbDleDg+gDswUVBYbjqrN/XD7ajHJ+YzhlZ/MRKeu2sjU8jBmORCT695?=
 =?us-ascii?Q?9XUuZaq9d3gVT/JvnZ09xtD8?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71ae9655-a08d-425e-28b2-08d96d9afacf
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2021 22:51:05.2505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UzL5PfiiG/YAB3D94hLu7jDjnajmvJ96Fbn8MJtf0SkkKDU+dIJ2XGVuO30oL7cmfcmKgGERQEMJYyoHqCTEHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6015
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a continuation of the discussion on patch "[v1,1/2] driver core:
fw_devlink: Add support for FWNODE_FLAG_BROKEN_PARENT" from here:
https://patchwork.kernel.org/project/netdevbpf/patch/20210826074526.825517-2-saravanak@google.com/

Summary: in a complex combination of device dependencies which is not
really relevant to what is being proposed here, DSA ends up calling
phylink_of_phy_connect during a period in which the PHY driver goes
through a series of probe deferral events.

The central point of that discussion is that DSA seems "broken" for
expecting the PHY driver to probe immediately on PHYs belonging to the
internal MDIO buses of switches. A few suggestions were made about what
to do, but some were not satisfactory and some did not solve the problem.

In fact, fw_devlink, the mechanism that causes the PHY driver to defer
probing in this particular case, has some significant "issues" too, but
its "issues" are only in quotes "because at worst it'd allow a few
unnecessary deferred probes":
https://patchwork.kernel.org/project/netdevbpf/patch/20210826074526.825517-2-saravanak@google.com/#24418895

So if that's the criterion by which an issue is an issue, maybe we
should take a step back and look at the bigger picture.

There is nothing about the idea that a PHY might defer probing, or about
the changes proposed here, that has anything with DSA. Furthermore, the
changes done by this series solve the problem in the same way: "they
allow a few unnecessary deferred probes" <- in this case they provoke
this to the caller of phy_attach_direct.

If we look at commit 16983507742c ("net: phy: probe PHY drivers
synchronously"), we see that the PHY library expectation is for the PHY
device to have a PHY driver bound to it as soon as device_add() finishes.

Well, as it turns out, in case the PHY device has any supplier which is
not ready, this is not possible, but that patch still seems to ensure
that the process of binding a driver to the device has at least started.
That process will continue for a while, and will race with
phy_attach_direct calls, so we need to make the latter observe the fact
that a driver is struggling to probe, and wait for it a bit more.

What I've not tested is loading the PHY module at runtime, and seeing
how phy_attach_direct behaves then. I expect that this change set will
not alter the behavior in that case: the genphy will still bind to a
device with no driver, and phy_attach_direct will not return -EPROBE_DEFER
in that case.

I might not be very versed in the device core/internals, but the patches
make sense to me, and worked as intended from the first try on my system
(Turris MOX with mv88e6xxx), which was modified to make the same "sins"
as those called out in the thread above:

- use PHY interrupts provided by the switch itself as an interrupt-controller
- call of_mdiobus_register from setup() and not from probe(), so as to
  not circumvent fw_devlink's limitations, and still get to hit the PHY
  probe deferral conditions.

So feedback and testing on other platforms is very appreciated.

Vladimir Oltean (3):
  net: phy: don't bind genphy in phy_attach_direct if the specific
    driver defers probe
  net: dsa: destroy the phylink instance on any error in
    dsa_slave_phy_setup
  net: dsa: allow the phy_connect() call to return -EPROBE_DEFER

 drivers/base/dd.c            | 21 +++++++++++++++++++--
 drivers/net/phy/phy_device.c |  8 ++++++++
 include/linux/device.h       |  1 +
 net/dsa/dsa2.c               |  2 ++
 net/dsa/slave.c              | 12 +++++-------
 5 files changed, 35 insertions(+), 9 deletions(-)

-- 
2.25.1

