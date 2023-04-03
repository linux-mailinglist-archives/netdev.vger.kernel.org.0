Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5F136D4224
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 12:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231771AbjDCKfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 06:35:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbjDCKfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 06:35:01 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2064.outbound.protection.outlook.com [40.107.105.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FCBA2D51;
        Mon,  3 Apr 2023 03:34:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iHBT8pQpC3CTY2KmVL4kPktSqtsK+k2SmWJXnDEQG2hZQg1sqaQ4iinq3FDGvvAINSty44MS5F9nabopIDiK3tjogvP1CZyflGL93StN1AaaPd0Irq7YMy0+MSDtjtqmU+pgRMglH8bpm7p1Sq0SkaqMh6tXW/eTBAM6h2xIVdNCiG9noLet0/kQPNNEOFHlCYC5cE4sLpbTTMxelwr5fCNvk8LwgxVdM7cMPKXC7zbTTmoLyGD6mE0QSmQE/EB3j0rjOZuTKGEDFThpRmSr2R9zE7e945DohPCMMm8TBZBM2IVpJ0XJIUTQP3ZFoESwaGJ9vTMRgLjVrUlS9J0d6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mwIX9iAQC+1sV9L87xnGUtlMEZo8P1vOTCbO3WtuWmg=;
 b=Zz3KY4LJJ1G9lFtledtzrueJtE62hwvRNZJ2cybajNimDZ9afqg/kqTRaMsMJPkECMAzUOI8HrGQR4xOrEjpKB9WVNKvFcoxCcvYLgIvXpe0kosyDU7qV+DMITuyiA0jXz17MmbDpss/QUaw0oDsswGPOMk7camnJv5aVebBLjFb/Cx9TNYhe69x1qppQ9DEGe8pgO1MWut6H/3E0OaXIMUJi/F5aKVT4BMx8JvLtd9L01gyJx6wsnIaApPWNIxM+awa2F4AbiveRe4X30Hh34xDVGgMmOKLAeHtXqqjfisF5D7ZoayimWvwvTiMB2nQ5Z0ECADmj6HhrWYIJ8Bnvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mwIX9iAQC+1sV9L87xnGUtlMEZo8P1vOTCbO3WtuWmg=;
 b=C+GGp43x8KyPjlIZ1JQ8/ZiXKEu33kgrrcSJ227X2V4DtmCh/Q6ds+QYOoXlGBYukCUdQTBYTHrsUVAILDJBsxJ3oUcfkKupCroHLnBOc0QvVp3fZ7uYZ0742HA9zE2TjFWogLGDvq1DpPOK3CBjWLeb4krod/0cPM9qnGn+jIk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS4PR04MB9292.eurprd04.prod.outlook.com (2603:10a6:20b:4e7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.29; Mon, 3 Apr
 2023 10:34:56 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Mon, 3 Apr 2023
 10:34:56 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
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
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 net-next 0/9] Add tc-mqprio and tc-taprio support for preemptible traffic classes
Date:   Mon,  3 Apr 2023 13:34:31 +0300
Message-Id: <20230403103440.2895683-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0221.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ac::17) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS4PR04MB9292:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f5f9866-75ef-4f07-c876-08db342f1162
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OpHV6mztmIH40zJXGMN776L93GkG4XrvqEDj5VdIxyvFv6hkDDLKLrFwmYZ3vhpbCy5qthIbYbpvfNC+WwaAz3wLj9Sh2qQNQ01CWpDnM+T+Pwj2bH0Yb6X8F16XHo+sz69ckr8U5LkPSwLkD2sVgcICLbJe3r/RCu4loryf6Ia+9gu1TbQUmBNjbJE5aGn3A17o/tJHODMCu8JIcKvt/v8WpW46TibZkUoqLORChRiLXVvbJOR2dlkSjDzbtj3zl4BeysbQzfPF6S2i5qv/J/1+18BGo25404csKHbZzyiBR71Zfl1TZLBgq6k/hxyvtPxhtSpdt4asQCyC7JnLlQXx/PYQXKGA/CGTOnoSzU2MqvqBkru2SRgWh/3Glp5ZZErk6umi4jouxY6FphiWmq/h6boigNg3KBb3sBGgsbbuUYsZOB8HSjX1Asmenz5aFqJa3Jz/wA86/0lXtbNeDR9v6zo0imX8jsrSaYaVBX2fsd4kAz9czYOTXPRTZ4B/pVsXYpZtV3j4ySfT2StRn7t6qi+XipMtcayFLQIJFc+Jh37pVhsiIKYvrutMqppU5xgW72bZfRh4jLtXjZfS/SFR0J8OoKZJ2bbf/XmL4waPO7xH3fN5qQR+fdHKxNb4V/zBrihP9zNjcGUPBEmmcw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(376002)(346002)(366004)(396003)(451199021)(26005)(1076003)(6506007)(186003)(38350700002)(38100700002)(6512007)(86362001)(316002)(54906003)(41300700001)(7416002)(5660300002)(44832011)(66556008)(66476007)(4326008)(66946007)(8676002)(6916009)(478600001)(52116002)(8936002)(6666004)(6486002)(966005)(36756003)(2616005)(2906002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+j7i9XTbOL+L7W+Wxnz2EcAZ0/WkvHRUpZ1Poj0/WrFDpfh7QrArLivOmQhw?=
 =?us-ascii?Q?d5zTCGBuV51QLjmla0vIIr2WYpYr6bavluMArzQ6YsN+m5WcT330XHOgMcmj?=
 =?us-ascii?Q?jxPVqbnEY/BwfmUev7HiQFR/RAu+ZXzat9tqANrGmcNE7VUeyMcBAKRk0qO2?=
 =?us-ascii?Q?U2+0b92TgfKBCTz8AKG4IW11uVvQHnuekFxamTZcSGs59YBdzbAzyvGlYXZV?=
 =?us-ascii?Q?+BYfCphBT5or6R1yBrNjGpGS1Dpk2YjUvT6LM3tX07XZrFLD7SqZg2CcEBJ8?=
 =?us-ascii?Q?/rYuG/vy05XlEDG2pdq2Pg3FU4MXTb8+Gw1hYVKylY7i5VUalOtBsUTnq8YD?=
 =?us-ascii?Q?TWkQkhcyMfNXc8YJniSij8DnKudWKq5gWdbiRxG91Nkyqbxe0CagzR7d8quT?=
 =?us-ascii?Q?ObmKvTxgwZU8DRM6AEpO6FV4s5fo2aKV4i7XAtriYlLM8k7/G4MaNITGm+Ai?=
 =?us-ascii?Q?+z45HNAXlQNXukiLTnrkCXZBKqL1FjiGWTlnDm475KkqsMw5ak/9Q4FBR9CD?=
 =?us-ascii?Q?A9TzdYcVI+eIYo3shSxWx154FhWRb0TtIdeZytmGX+iXcPcTDtipmkrRP8SQ?=
 =?us-ascii?Q?fGBqd/dw1gVJYcOaxArp9Hsg9pU7tLWqqIKIZ2q7IzEZFOHqIMzJDaQzvb63?=
 =?us-ascii?Q?Tcia4QJqxZeTkoMk648QH3uaw1cA7w0hXwCwOKWPEtYwyDWfo/VAMWaZfqOv?=
 =?us-ascii?Q?8MB8/tdoXgVWKU3DdKWTg9ijTHH4/DNRobJr8nfusH6yupmk2vmwLT0r0E/0?=
 =?us-ascii?Q?HM13ikN7JQfl2pFvZRX/68tx9KLaf790fTPa67WDpKNUYrki97HilvBws/yj?=
 =?us-ascii?Q?LTDWIF9oLnBGwOEf+CqI/+zvzkqtQnHVsuLgrjkelkEIcxhmoPON26kN5kdF?=
 =?us-ascii?Q?eEfCB9+exsEsvw1RZXdR3gBQrQkuXEyOxTQbw0mD4e3GUxcF5EAuNvLyY3ei?=
 =?us-ascii?Q?MTkbsN1dHrUm9FbGzbHGF9NOhIUf4j5ChhCnPIrNZZ67IEcQ6OGt0e36ciqF?=
 =?us-ascii?Q?rTY/Og5FQMCwsd/VkkTEwAgj5UScqUIjW2JXyzneTHFHN6/9panuYkwrtJLp?=
 =?us-ascii?Q?kqw9NE0XSEOngt1uLP45/LA9idsLcDtaYNtE6JZ9liSRV+wQKhUQacMrCkOr?=
 =?us-ascii?Q?wBN/5Foy/4P6LiqrNXWzZzNZM/VHfarHuo+pYalE1lHwQ0Z65v4dUsxPNw/X?=
 =?us-ascii?Q?0D0OmpM/nuNcYX9RdhgFt816n7LTBV4KzwFsJdkk8cA8maXcElLgfLyR8Wp8?=
 =?us-ascii?Q?IPD7lsTxSt576Hrl5rCG7ZMhEdDAvUAIeKDl01YJAJngBAptXMSaCHwrXaui?=
 =?us-ascii?Q?+GqnazuR+rNzcFSf5aJTyDmF0uFE0qjfkzdzV1vYal648frvrQlqp9qtKDUg?=
 =?us-ascii?Q?KFYJAWSReOpVENAhUzI/hO47GOom/J0Q6EEbbvAJugQ4sF8L0zLlb+3sUoV+?=
 =?us-ascii?Q?ImPK6h1WWjoJ6GOzSFJDAUOWvlqtOUpoAl0lr/bVJ4SvhGf3qlfJE9Asar2Q?=
 =?us-ascii?Q?YlPfhTB7eryCIH3lj/TVV9W/u2Ibf+8BUTLM96xwFLSWWBSvlJyiIhtIM+GR?=
 =?us-ascii?Q?8rUgYPYugq95ZbRLMhpXu7zGdZ3o3jAdVm4+/69KGTbKHfktwqeSn4CYK28N?=
 =?us-ascii?Q?PA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f5f9866-75ef-4f07-c876-08db342f1162
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 10:34:56.5923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S7Iyrt+OFe2648DoIb+QmJMxL7V6x6XqrI4ADOBfAiJHrfdNoGEm7jZP8fuNVXQi6IsSHADdcdxY9Xxr2bvZvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9292
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The last RFC in August 2022 contained a proposal for the UAPI of both
TSN standards which together form Frame Preemption (802.1Q and 802.3):
https://lore.kernel.org/netdev/20220816222920.1952936-1-vladimir.oltean@nxp.com/

It wasn't clear at the time whether the 802.1Q portion of Frame Preemption
should be exposed via the tc qdisc (mqprio, taprio) or via some other
layer (perhaps also ethtool like the 802.3 portion, or dcbnl), even
though the options were discussed extensively, with pros and cons:
https://lore.kernel.org/netdev/20220816222920.1952936-3-vladimir.oltean@nxp.com/

So the 802.3 portion got submitted separately and finally was accepted:
https://lore.kernel.org/netdev/20230119122705.73054-1-vladimir.oltean@nxp.com/

leaving the only remaining question: how do we expose the 802.1Q bits?

This series proposes that we use the Qdisc layer, through separate
(albeit very similar) UAPI in mqprio and taprio, and that both these
Qdiscs pass the information down to the offloading device driver through
the common mqprio offload structure (which taprio also passes).

An implementation is provided for the NXP LS1028A on-board Ethernet
endpoint (enetc). Previous versions also contained support for its
embedded switch (felix), but this needs more work and will be submitted
separately.

Changes in v4:
- removed felix driver support

Changes in v3:
- fixed build error caused by "default" switch case with no code
- reordered patches: bug fix first, driver changes all at the end
- changed links from patchwork to lore
- passed extack down to ndo_setup_tc() for mqprio and taprio, and made
  use of it in ocelot

v2 at:
https://lore.kernel.org/netdev/20230219135309.594188-1-vladimir.oltean@nxp.com/

Changes in v2:
- add missing EXPORT_SYMBOL_GPL(ethtool_dev_mm_supported)
- slightly reword some commit messages
- move #include <linux/ethtool_netlink.h> to the respective patch in
  mqprio
- remove self-evident comment "only for dump and offloading" in mqprio

v1 at:
https://lore.kernel.org/netdev/20230216232126.3402975-1-vladimir.oltean@nxp.com/

Vladimir Oltean (9):
  net: ethtool: create and export ethtool_dev_mm_supported()
  net/sched: mqprio: simplify handling of nlattr portion of TCA_OPTIONS
  net/sched: mqprio: add extack to mqprio_parse_nlattr()
  net/sched: mqprio: add an extack message to mqprio_parse_opt()
  net/sched: pass netlink extack to mqprio and taprio offload
  net/sched: mqprio: allow per-TC user input of FP adminStatus
  net/sched: taprio: allow per-TC user input of FP adminStatus
  net: enetc: rename "mqprio" to "qopt"
  net: enetc: add support for preemptible traffic classes

 drivers/net/ethernet/freescale/enetc/enetc.c  |  31 ++-
 drivers/net/ethernet/freescale/enetc/enetc.h  |   1 +
 .../net/ethernet/freescale/enetc/enetc_hw.h   |   4 +
 include/linux/ethtool_netlink.h               |   6 +
 include/net/pkt_sched.h                       |   3 +
 include/uapi/linux/pkt_sched.h                |  17 ++
 net/ethtool/mm.c                              |  23 +++
 net/sched/sch_mqprio.c                        | 187 +++++++++++++++---
 net/sched/sch_mqprio_lib.c                    |  14 ++
 net/sched/sch_mqprio_lib.h                    |   2 +
 net/sched/sch_taprio.c                        |  77 ++++++--
 11 files changed, 323 insertions(+), 42 deletions(-)

-- 
2.34.1

