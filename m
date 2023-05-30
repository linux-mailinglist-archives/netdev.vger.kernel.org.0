Return-Path: <netdev+bounces-6301-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C6C67159E1
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 11:20:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F7FF1C20B8E
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 09:20:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B193313ACC;
	Tue, 30 May 2023 09:20:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D69E13AC8
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 09:20:38 +0000 (UTC)
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2083.outbound.protection.outlook.com [40.107.7.83])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79CD31AD;
	Tue, 30 May 2023 02:20:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B4v8e8esuhL6KfLZN96Dbenf1L+Q78zZKkonM59W14CJjmGc1UkxLsxpaQQxxb9GPnPqS+dMYuCO/D65UFjYUmOjnCmKqAPf4tdw9kKI0Q+Jak2TdDpR9lUF/d5mxDwF7PPlPdHu0twiNOKK7rN7l3Bz2D6TFcFvfsU60aMrcSIQMepZU16t8o9MnrR2J/yjqVKZMXRFkn4th5wOascW26q7uGdDhjW97w3hDghXdBH7IdIP78cPH3GoLmysU8RV59UdBtdxHw1mkVz3hWHGirJuT29a1ilx0uPZtufmGQ7PsBtCwfmYmOFbDQGfaIRqIigRbQztUEMx54LiioUtqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O+UyOhuzfQMqN54rD4LgKK9nIDVVRFBI+0dKQwkqrZc=;
 b=QhL5yj6cqWlqWbDO8PyRZzpgL1JCaWXPg5p+TdCjpMLcH1Hdvo2WbJchbQ1bFo4w0sIbngrGBZhNUTkgQhisRsETfqD3NbW/Djt5mU1Js7/GHc0aEN/x/h1U6WhwAohltJpuZNYDTB86hdl9xCU5LZHk4FYQexKO/TDka6EdmPj1CWbfNG86FZbl+OveVSJF0Ux9kaPxWHEoyfXuNNvh3IUPwanLLTGvpHjE1x7QgEWCdkCMhc58UCj3HhYkcMio3gtL0Pi9dufZwEPA/DRuExuUIPFrJJnBtNFWFZrald/mE62lid5KHjCICGZpT712iyUTSYCHAn1qOGntz3goww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O+UyOhuzfQMqN54rD4LgKK9nIDVVRFBI+0dKQwkqrZc=;
 b=IMmDuCKhELrgzLTJrLbqZBOZEo60K5iSWxXmh4sEagsgTPjqn1islBz7DiJ+RHdKTVchwcHMJQPcozFrYHHCKgzPvD5eISAu3l6tEBjBvLQXyZK/4Q9n3B64n0Kqm1h2Z+szaoSJ4vf6IzFYvFLrh6BCPR9o+NmgVVNwESb/RZw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by VI1PR04MB7167.eurprd04.prod.outlook.com (2603:10a6:800:12a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 09:20:06 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::b027:17aa:e5f5:4fea]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::b027:17aa:e5f5:4fea%6]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 09:20:06 +0000
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Jiri Pirko <jiri@resnulli.us>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Kurt Kanzenbach <kurt@linutronix.de>,
	Gerhard Engleder <gerhard@engleder-embedded.com>,
	Amritha Nambiar <amritha.nambiar@intel.com>,
	Ferenc Fejes <ferenc.fejes@ericsson.com>,
	Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
	Roger Quadros <rogerq@kernel.org>,
	Pranavi Somisetty <pranavi.somisetty@amd.com>,
	Harini Katakam <harini.katakam@amd.com>,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
	Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
	Oleksij Rempel <linux@rempel-privat.de>,
	Jacob Keller <jacob.e.keller@intel.com>,
	linux-kernel@vger.kernel.org,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	UNGLinuxDriver@microchip.com,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Jose Abreu <joabreu@synopsys.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	intel-wired-lan@lists.osuosl.org,
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Subject: [PATCH net-next 0/5] xstats for tc-taprio
Date: Tue, 30 May 2023 12:19:43 +0300
Message-Id: <20230530091948.1408477-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0155.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b3::18) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|VI1PR04MB7167:EE_
X-MS-Office365-Filtering-Correlation-Id: 0228b954-e31a-4f72-3118-08db60ef0e98
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	XYOIpAOhBIsIN8u7C3WpbrXzbkgLLQxCXUkArhPKyxMDJVuJFTGdgY6/i2r6pjLLgt1Ro9aAiYIIGMrpKw+M0ZcP1hoGePHhZ2dYoDadHQzg63n6BnESrEZlG+uGnpE3f1NTDCk5Hm3NmkM86cZzruOxPj0nonJ3EmEMPWNNPOSz+ufrCqDsVDOAPAuSsjgGlXNCpfdIc4S1q3Ih5EQsaBbqYjKsNI4FkmLpT8Q27wTxxsZOvX5U+8Buz4wttVZTbmwsoMvOJw0BuhQSE3QGLCDR84RDh/AJnkWVOIQdaSFyK2XS9cqx16zQE8TMF2hfzMb/14E3PWx9NvlU2BXy/3tV4x36nN4inRcFkMkT4f0L/eQMJP7k8Q8Bqjm9Vo3wKIGIywLl+13OX3UtzvD01+IW+z/0aUAmW+w8FetIzK3eO3H6AgOpNePJymXv7NSIcwhHxQpvdx+1st+WtioU0IBVRvw3GDb9HI5RNAfc0VaP9OnIjMkdbV5zBvshxCotnK6PvQbE1f2m+b/qG1aaVc6iAcS/Roiqy40jtqNCVgVCYXuwhcFYhiF3FUqajHljyD9sJ3k5GLmgeIWnLRhyFvNIcCWK78FtS1KhSUEt5n+qiMPT/2ZtqaHfk3r2+B/rFkJrQM9e2LhOeahXvhQ4lw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(396003)(346002)(366004)(376002)(451199021)(54906003)(478600001)(38100700002)(38350700002)(966005)(66946007)(66556008)(66476007)(6486002)(41300700001)(52116002)(7416002)(7406005)(8676002)(8936002)(5660300002)(86362001)(44832011)(26005)(2906002)(186003)(1076003)(6506007)(6512007)(83380400001)(6916009)(4326008)(316002)(6666004)(2616005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0XNQvJv7p646rp/laIPLE4CS5ol7VYBZExMHII9gTHaNH4FVna/DYSoq2/M6?=
 =?us-ascii?Q?o6315YVUHv1uvMuF9WuP/Z+PrBwQ2GURM6IIc+BuBkh3zczCtyLoocFdanKB?=
 =?us-ascii?Q?I6G0ImywbNW4NCdXVOuea5g0lhtqnQOwlTDwNX3ZM4A2MWSaYWlwOwGexXz7?=
 =?us-ascii?Q?h9x7nofc1VnG9HWzjOXiK6boYawW45TIdFTUtP51eMwYtsjQ6/MMX9jfKNO+?=
 =?us-ascii?Q?iuwa3tqrqu7HoHfxM/EkrS0/kX6N3/udGxH0W6/bbEixrJEMQQpVrSf8dKvn?=
 =?us-ascii?Q?pje2YCWcm7bBhX8r/4nSKVdF6QSybDVpsqX0wNGPQnr3t17lgzYR+Vux7Mha?=
 =?us-ascii?Q?Nr1bMtD91Q8s7mftNCBPWNnCvjdEOfxh7+0tz6b013XpjmY9hvS8wc5VXOV7?=
 =?us-ascii?Q?2EFXFrUwxvd2v2F0ErW6voUwMnZoCJAfewcJ65J1AdUmGYjrm+jyBT4pG8aR?=
 =?us-ascii?Q?aBYbtawLf9Y5vE4wod+7E/Npkhul/pJHKDAn44U1tvZSyK8ArAU4MOadekwl?=
 =?us-ascii?Q?aOpSPFJD1fJ64FrYU5Kwkqlu4EXs8BF8/nVLi3wb/FSLo9vns+OPZWR7deid?=
 =?us-ascii?Q?WqcS3+9/8m7TpHS54k9yfHXJZdLcQ7bVSmMkSXgLHwC+RrtmY7TcXbOl8CDM?=
 =?us-ascii?Q?U1CrocIfZ9yGw9fk6VrDExPWidnX0tKvSU6CJyib+H6lm0Sfzlr+XtvPSq/l?=
 =?us-ascii?Q?WZ7J7ZqXTnJtCs0XlFT9Na4rpMA7ZF8jblSblvH/CO4nvhwGL/x7YKbZsyz3?=
 =?us-ascii?Q?3oiUnwkyl1C9w/2IDruERHxRBfyUmhTJ+nWCZsPrF8fxVykBPbykRGmfz1M5?=
 =?us-ascii?Q?Hb1C27Ohn9xBM8cUniP57/qb8DRBH6Rrn/3KDPNuA+Qm/7ETuzvEmTaSWLXr?=
 =?us-ascii?Q?jI1RNjPB8d+eD3lCKmNah/e+bGRzqm+IpSXUsExwKrFL8LrDB7CJqgdoGcQm?=
 =?us-ascii?Q?8nQeppcAEC4ZbY9IiSUcxi4gx/lY1Q9V5r1Cg2ShDnPj22jIGo3P4a5ooGPQ?=
 =?us-ascii?Q?d9P12dQGY2kp/6vT1syVl3xNc7gDvAAyLXntQeelEMRvbrJN3vfFuT85d2Xm?=
 =?us-ascii?Q?w8Y4DaOv+oNuMdqnlv3Sl0b9QLBKe+cyp1s6uCac0VB6JEqC5qCyyJNB6EMN?=
 =?us-ascii?Q?RroU3kV37e6rEtvDgTDtcNa/KSLk7cNzGYIfeypJpZjaXcZhd088+SVwCPm3?=
 =?us-ascii?Q?rZ2YYougN1XD77LRBLntg4hzHvX86NB7pdA1So+ndseLqeQNYu26ckHWhIJw?=
 =?us-ascii?Q?G3bbH1ie0kShHErItKphJLHjwXYocAXO1zMxyvu7vZrztyKBAjfOREqe3j2h?=
 =?us-ascii?Q?t0JQiZ6ZBa4bzKl62/dBf9QLr7EJzfvrs74I1UDsbVVdstUDE2mCdbyyD/wr?=
 =?us-ascii?Q?ATJGbwHOjv/R47z10+9HNGUmxrDEFOCWIPaKVAQpT+fATjz7uj0JkY4IYlc3?=
 =?us-ascii?Q?YMzcrKbJcRcBWsUhmme69nuHIHnjZnAVmuVIDSw2YoQge/ScYOgGH7i0GsRS?=
 =?us-ascii?Q?VwwAMeQBVwkj6NVQiwXLhupqeT9DITvzKeueCy1AOK92+kQtm6eVxHMcJmOl?=
 =?us-ascii?Q?mPDeXyLQUKofhj06mJlWdChnOCAnsgUB2MNHMuAZjYI4ujwd2TICa2mwyJGS?=
 =?us-ascii?Q?sg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0228b954-e31a-4f72-3118-08db60ef0e98
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 09:20:06.3978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UOTl16OsMG8o6uWggd/lZv6LC6iS5V6Ko9n4QWvL24OWt5dojK62qfJjfnoUdVV/uMQ5HYg8+fcdf4Wdoz/C6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7167
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

As a result of this discussion:
https://lore.kernel.org/intel-wired-lan/20230411055543.24177-1-muhammad.husaini.zulkifli@intel.com/

it became apparent that tc-taprio should make an effort to standardize
statistics counters related to the 802.1Qbv scheduling as implemented
by the NIC. I'm presenting here one counter suggested by the standard,
and one counter defined by the NXP ENETC controller from LS1028A. Both
counters are reported globally and per traffic class - drivers get
different callbacks for reporting both of these, and get to choose what
to report in both cases.

The iproute2 counterpart is available here for testing:
https://github.com/vladimiroltean/iproute2/commits/taprio-xstats

Vladimir Oltean (5):
  net/sched: taprio: don't overwrite "sch" variable in
    taprio_dump_class_stats()
  net/sched: taprio: replace tc_taprio_qopt_offload :: enable with a
    "cmd" enum
  net/sched: taprio: add netlink reporting for offload statistics
    counters
  net: enetc: refactor enetc_setup_tc_taprio() to have a switch/case for
    cmd
  net: enetc: report statistics counters for taprio

 drivers/net/dsa/hirschmann/hellcreek.c        |  14 ++-
 drivers/net/dsa/ocelot/felix_vsc9959.c        |   4 +-
 drivers/net/dsa/sja1105/sja1105_tas.c         |   7 +-
 .../net/ethernet/engleder/tsnep_selftests.c   |  12 +-
 drivers/net/ethernet/engleder/tsnep_tc.c      |   4 +-
 drivers/net/ethernet/freescale/enetc/enetc.c  |   3 +-
 drivers/net/ethernet/freescale/enetc/enetc.h  |   1 +
 .../net/ethernet/freescale/enetc/enetc_qos.c  | 110 ++++++++++++++----
 drivers/net/ethernet/intel/igc/igc_main.c     |  13 ++-
 .../ethernet/microchip/lan966x/lan966x_tc.c   |  10 +-
 .../net/ethernet/stmicro/stmmac/stmmac_tc.c   |   7 +-
 drivers/net/ethernet/ti/am65-cpsw-qos.c       |  11 +-
 include/net/pkt_sched.h                       |  56 +++++++--
 include/uapi/linux/pkt_sched.h                |  10 ++
 net/sched/sch_taprio.c                        |  90 ++++++++++++--
 15 files changed, 286 insertions(+), 66 deletions(-)

-- 
2.34.1


