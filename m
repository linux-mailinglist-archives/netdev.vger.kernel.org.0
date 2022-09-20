Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 807985BEFD9
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 00:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbiITWMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 18:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiITWMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 18:12:50 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150077.outbound.protection.outlook.com [40.107.15.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E2C77EB9;
        Tue, 20 Sep 2022 15:12:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OPGIhy/tJNqdTlJ8JT9EttXddf/ArZaFqeGC5Gubj27dQGIIOCcHIj5Yn5RhtDUGZ+n9shLYOS6MyfW0DJaajQI84VdexxetY4D4oZPmDorE8LMAOwWglJ+il6yOhpWN1oHu32MTgFVPBG+o6qkOcEquIRKloG5ByWzQaAo2/tgY9aqZpu3sP/GynGTv1AsG+63x1llQqe58spvarH5RsaOPVjvqjIgshUsTzpgjSK3f3NPB6HN0kH9lvjWWjOe02S27sPbizFoSnnkrQKPKTaQ8+h19JlRuCeG3Wn4zphH6cFyX/uJ4G7PDYr1mdozfEqYyDM0CdpvnYIlgIYc0nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BNor5NqYpS5KRNmKMxpe5Ss2IZwSElF6CmhVRIBDViA=;
 b=hGc228++Di8YIfCH+JTIDF9sc3GPwpvIjUROUschIUn1ZT4s5vaBGTv1A/II/IWh3sGuiYYBNDuHnrH9y8tShWgzL3Jf4hQtlM9KYQVFVQIX+KH1SmnEkkh4Za8Xk7IZP0fCnoRhTFkaTwgCmZ4thMUm7C/wOOCPrQ3C6cRtoBEVIbY2U5vJFuYOwtgV3S9vDogU2Mt/wuCtd9tHJtqQM0SOWX2EOhRhCIQQbP286EX+rnPQfEhlIUv1Ho7y2qX1QNbtNbBIbBuQJO8o7YR5WnvWaFTnD39cjtbNa94i6iaiMa3a+03ZmoY33TDk3jpB52xTaHJ3+SmMYEyETl94dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BNor5NqYpS5KRNmKMxpe5Ss2IZwSElF6CmhVRIBDViA=;
 b=jiWFNdRJojCjwfP10PpY9q6IGFTPoTAnlIHeoRfO0Vhnv18+8+77Ku7lDiUp9PVmuKNwfuCKHwCn2FCMP3VJhCZVjiEZ5lbJ/FQ3rVmVN/KtVZ3ym0OG6q+Pp6GpucCQdznJeyKUcteA2fjHzn/57S+L5nkKB8WV+215enQ/rrwrGFPz9q6uS2IRA0UvWAft6yKdMGmmtmOfbLVJEaPdd1ZUiGu/3rRnAxBR/fjijozvGDbXklGI9k+6QHmiRvwEKv3czuuvhMa/wRJXWcz4rgs7QLaqa14rpqc1t5WFArVeqY8nVzEqCEIfY7/IfdnROOnLsSsy75mC60HfUQHStA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AS4PR03MB8179.eurprd03.prod.outlook.com (2603:10a6:20b:4e2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.18; Tue, 20 Sep
 2022 22:12:46 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d%6]) with mapi id 15.20.5654.014; Tue, 20 Sep 2022
 22:12:46 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sean Anderson <sean.anderson@seco.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH net-next v6 0/8] net: phy: Add support for rate matching
Date:   Tue, 20 Sep 2022 18:12:27 -0400
Message-Id: <20220920221235.1487501-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR01CA0038.prod.exchangelabs.com (2603:10b6:208:23f::7)
 To DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|AS4PR03MB8179:EE_
X-MS-Office365-Filtering-Correlation-Id: 634fdab5-4251-455b-3855-08da9b553f1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jZ59hiedRZQmUDVoLQ39FSs4dxMWyP/OEpDf9hq3l9n3UWnNlhh2StNLU7pW3fqFB2Jdcx5rDHbxOeocp7yu9ULcTHq9+q5+NHQBU9ObKmOWsu3hGWlF2VuUeVl7B8Gr5QNC+pgV+ox+WyVQEpB6aQgGzARBOZITJgPae6qnYALIob97KpUl0QEE2yP8DViW4BLYpjSjtq97kO9jjbX9XELslVkt26qd+vxOMrC2i9H3PFyo6/U/QFSBbpdguUWI06I8MjEspoi5oeMyP2M5K2CWzNLyWArYNoQTLnb3VX+E9mbBCLbFGPr8DbY2W350UF6ZlXT62LfY0BxIwWRHTm0MF2PohIO2N1QbjEzD/TJPnpSAlrZVAHdaNvti9Zh/Qwrx1WOxZcW+hOr3OeDG3C8l213Dr+J60lMApyMmOvt7oRe4YD4AlRlp4oTJbRCwChcFvUkQzX18KPm01e0wTYVP8kIzuZ/fKcnrrLo2TNKijp6iagqB6rmaFZtooIZVBX5kW4s7Y99qmjeWxpKY7iCj8t09xlBxtirxXlVud6d9Ajj0XnkdzkgtIA6wlPZR37OFwyjJmXrdAfSOlMItr2qGU35CPxvZnnvLScIttISeCEmCAp9zmmynWHAbIHzt9fanM8nEl5dcd0rrPQ+ty30GT3csbUzkESEcNgw0S+pPfHnPs7U9oHGLPwNHYZfxYU0j1KeqWVfAReKWMPBYLq9/OriOScIKb6un7NLxQ54kY+LpGskZf+nz5SiiLOy1Jy/BUuZSiwO9BX1j1cTo7NOBMnt7oKGvPOIaSi4qsdM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39850400004)(366004)(396003)(376002)(346002)(136003)(451199015)(7416002)(8676002)(186003)(478600001)(966005)(1076003)(66476007)(66556008)(66946007)(4326008)(5660300002)(2616005)(44832011)(86362001)(8936002)(83380400001)(6486002)(26005)(316002)(54906003)(2906002)(6512007)(36756003)(110136005)(6506007)(38350700002)(6666004)(41300700001)(38100700002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zXEJPmWrruHNizAfwcrgndXiK1iQR5VY518hoOHB7UoP0yd6FvoF6AQC9mLT?=
 =?us-ascii?Q?xYTlhMHh21QKg1I5pNYQUEWyXmqAxpO7mSDMAOcR70axZgnYwzadchLnEqhR?=
 =?us-ascii?Q?4pmTZDkPaXEEJc++2do4qF3ezZoRhq97dGsOWT2QUi8v5AxMBZcnltqTGviB?=
 =?us-ascii?Q?Qblbg3lF8g8SMxKFk/0mgrba2YJ4DocvIDa1PguQY2YHBlXQYBzLaF2K30L8?=
 =?us-ascii?Q?FnIgr0jhDxtBNLnOVtu+cyag51hjsCaVSWYRmh14yTrUKYcVCW7WDz63040m?=
 =?us-ascii?Q?5hx5lSd4+h2GgX5IBukSHmhOSp93JCyCW6ggSrJJSSZUsFin4WQ3zuNq57RX?=
 =?us-ascii?Q?/bOwc7CcN2YfDNfj6wdZkDAujMLJd5JCZ2XoG2HjRmAiP9ThU/FXeFHiWl4a?=
 =?us-ascii?Q?uEykMHKqSm55raHqq4py1ARZ3TFKw6zfy5fCbrh3WPGb+Ft91MReXegK3NN3?=
 =?us-ascii?Q?tS4NRnWB41qMdl9VwXXqgWBZeJmZ4NnLRwEDyPC9Ode1k6M0BKoIRlA5SMJ1?=
 =?us-ascii?Q?i9S/0NjD4gpm0ONirdXIMZThAx52x4dRLBhhEmxP1sf/UZUFWcNPqr/SoVRr?=
 =?us-ascii?Q?4xCWeZRdS5ETfV/U/Pu6ErkKMbDH/GukujJWlOuX7BxPv0DHQ7CCYua8F7eZ?=
 =?us-ascii?Q?Vl72DFZQhYNmjDXFjc0GxDNMvrMQWL0pJ8IhfXwuqCipenS78Mwxd64hh9Dq?=
 =?us-ascii?Q?ALqSkWsAeKIdiSqT4o+l1j+ekJw9WDChgSRH1XYg6Oejpz/OTLyoZiXG26li?=
 =?us-ascii?Q?eNSd5Rgt1PUqm7whNJ6qqTIZc2Ip6lnqzsyVFq+T1Tivhm4QMYp0H5w7ARCY?=
 =?us-ascii?Q?TmJsg7yEOgB098/kv9zVeTj1v+S6oUcCoSmq4QyYYVEfkC2wsGHmJA0XBqc5?=
 =?us-ascii?Q?GRGkhXBmzHnzNLdxmkv+nwx2/fYOwEH6qtrFctlWsZA+/h3L1R+ztoim4YRB?=
 =?us-ascii?Q?ZBxpzjJnhT9YPAhjXMgAq48qdJ4iGf/l56RKEmn49pkrJdGzxnAKKA/EIupJ?=
 =?us-ascii?Q?ZgO7wB2A8tWZxMAFQj5k+9WefnjdeYBophwZzYQAuMmUcoC+TZGutQ9cYkl7?=
 =?us-ascii?Q?y9GZAGIOlpOOZvfFwtnknrJbCbE+xxGQ2vPBsaK3vOeK7Q4yrhNTSNmg1Sv6?=
 =?us-ascii?Q?Y1Uiy1iTyzXvFicETVzojVR5UDJDAM37WSzTHdJDiXhsCg7UzD2wxZmt0f8+?=
 =?us-ascii?Q?Klf8OcpHIXsH9cPrvWId1n0N+OiDlCbODrMVzbI6h7QQlOGAznGVYDbsfb3x?=
 =?us-ascii?Q?lVqPhJJvGDdwKi1aZ8v/MDd1w73dVP9+kqdgzpz4Qupk+XmbcOMZHl1PLIsM?=
 =?us-ascii?Q?MU8QivFfwvoC78Yg0gGIH8TdRybIZBbYfdbxyvGPnO+YhGjze45IJgSJMUSp?=
 =?us-ascii?Q?MKVoVI7NOwBNE6HaBmi83qUrv077TGbf9txh0jfPojtwsxa6vyZ5BhnxNOOl?=
 =?us-ascii?Q?P7VlVtwZR/uAf0fvK8MqikxL0qgb0ma1hzclq0jN/CXVBCvQQXsZHIhU4oiN?=
 =?us-ascii?Q?CDpRW40nyUG5agZOvGC3d7IpuZILbvxCJnmVypggTzxWDxHBD9GaKTeAsAu2?=
 =?us-ascii?Q?HzS/a6gywrN1VdjaTllD2wHE2Fxdt8bQhXznRWfv9zQRxwqNFocCzUU1dQHX?=
 =?us-ascii?Q?qg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 634fdab5-4251-455b-3855-08da9b553f1a
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 22:12:46.0492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HurueWqBe9BepU8FT71wZc+Gr8ppwdC9K+jNOFY3kewlNkS4LsfyBp0saqJrfvxrxyfD/m3iMR24AV5Nt+mSMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR03MB8179
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for phy rate matching: when a phy adapts between
differing phy interface and link speeds. It was originally submitted as
part of [1], which is considered "v1" of this series.

Several past discussions [2-4] around adding rate adaptation provide
some context.

Although in earlier versions of this series, userspace could disable
rate matching, now it is only possible to determine the current rate
adaptation type. Disabling or otherwise configuring rate adaptation has
been left for future work. However, because currently only
RATE_MATCH_PAUSE is implemented, it is possible to disable rate
adaptation by modifying the advertisement appropriately.

[1] https://lore.kernel.org/netdev/20220715215954.1449214-1-sean.anderson@seco.com/T/#t
[2] https://lore.kernel.org/netdev/1579701573-6609-1-git-send-email-madalin.bucur@oss.nxp.com/
[3] https://lore.kernel.org/netdev/1580137671-22081-1-git-send-email-madalin.bucur@oss.nxp.com/
[4] https://lore.kernel.org/netdev/20200116181933.32765-1-olteanv@gmail.com/

Changes in v6:
- Don't announce that we've enabled pause frames for rate adaptation
- Merry Christmas
- Rename rate adaptation to rate matching
- Reword documentation, (hopefully) taking into account feedback

Changes in v5:
- Break off patch "net: phy: Add 1000BASE-KX interface mode" for
  separate submission.
- Document phy_rate_adaptation_to_str
- Drop patch "Add some helpers for working with mac caps"; it has been
  incorperated into the autonegotiation patch.
- Move phylink_cap_from_speed_duplex to this commit
- Rebase onto net-next/master
- Remove unnecessary comma

Changes in v4:
- Export phy_rate_adaptation_to_str
- Remove phylink_interface_max_speed, which was accidentally added
- Split off the LS1046ARDB 1G fix

Changes in v3:
- Add phylink_cap_from_speed_duplex to look up the mac capability
  corresponding to the interface's speed.
- Document MAC_(A)SYM_PAUSE
- Include RATE_ADAPT_CRS; it's a few lines and it doesn't hurt.
- Modify link settings directly in phylink_link_up, instead of doing
  things more indirectly via link_*.
- Move unused defines to next commit (where they will be used)
- Remove "Support differing link/interface speed/duplex". It has been
  rendered unnecessary due to simplification of the rate adaptation
  patches. Thanks Russell!
- Rewrite cover letter to better reflect the opinions of the developers
  involved

Changes in v2:
- Add (read-only) ethtool support for rate adaptation
- Add comments clarifying the register defines
- Add locking to phy_get_rate_adaptation
- Always use the rate adaptation setting to determine the interface
  speed/duplex (instead of sometimes using the interface mode).
- Determine the interface speed and max mac speed directly instead of
  guessing based on the caps.
- Move part of commit message to cover letter, as it gives a good
  overview of the whole series, and allows this patch to focus more on
  the specifics.
- Reorder variables in aqr107_read_rate
- Use int/defines instead of enum to allow for use in ioctls/netlink
- Use the phy's rate adaptation setting to determine whether to use its
  link speed/duplex or the MAC's speed/duplex with MLO_AN_INBAND.

Sean Anderson (8):
  net: phylink: Document MAC_(A)SYM_PAUSE
  net: phylink: Export phylink_caps_to_linkmodes
  net: phylink: Generate caps and convert to linkmodes separately
  net: phy: Add support for rate matching
  net: phylink: Adjust link settings based on rate matching
  net: phylink: Adjust advertisement based on rate matching
  net: phy: aquantia: Add some additional phy interfaces
  net: phy: aquantia: Add support for rate matching

 Documentation/networking/ethtool-netlink.rst |   2 +
 drivers/net/phy/aquantia_main.c              |  68 ++++-
 drivers/net/phy/phy-core.c                   |  21 ++
 drivers/net/phy/phy.c                        |  28 ++
 drivers/net/phy/phylink.c                    | 268 +++++++++++++++++--
 include/linux/phy.h                          |  22 +-
 include/linux/phylink.h                      |  40 ++-
 include/uapi/linux/ethtool.h                 |  18 +-
 include/uapi/linux/ethtool_netlink.h         |   1 +
 net/ethtool/ioctl.c                          |   1 +
 net/ethtool/linkmodes.c                      |   5 +
 11 files changed, 440 insertions(+), 34 deletions(-)

-- 
2.35.1.1320.gc452695387.dirty

