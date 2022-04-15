Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7C53502D4B
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 17:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355597AbiDOPtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 11:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355593AbiDOPtF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 11:49:05 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2057.outbound.protection.outlook.com [40.107.20.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BBE754BED
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 08:46:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LhI0uVsTLsVuJNJYaRTfgazL/ftwEl+JXjrubpZE7wt+F00rysdFx6kvQEU+5r5FpfqUEcCgGqltCRqFno2iaphdidYqkmD6Gj0BlN0wBSMyhnqZ7rJrWDkL2vhydQh5EeNQ94G+4uu9RCWWFWTxoLO2tXsz+jrh9RxMkahKuz5o/ZFa4eKHCNAPscCsgYSGdW3B09hwTLGvV23e6RRkWbvTxDbv8g5PJrcy9NdCK4JAwfkcS2r6iTI6CgPhN8N0WZs96boutQCf7pYoXTmhNA+CzHFCDmNREuicuzEgFifcWHMVHOjQ8xXjMVkuZk92GKU5U2KZpXeb1MF/LJuuDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CjETl4KpUPsfx0ogPXnVc7OyQ4eOvkNVcNs/u4wUAcI=;
 b=cxZ29o6eZq5rkEfobCxVXRqezuC06XFSNtMxDoeqd31vuT6bTv6B77KQe1sYRpgUNe1XKjVOvTvgcKjhUCyl9OOKoAF9OLRca0zwVOWG1gSr9M8NoKr7gQpK6nQqLxQq3IPqlYvrpN1oSx9/PoQfwo1RMpz4xDfA/HTeWZNV6D5dNttvgK4KfBabyf9zTJJvUFwXBUCmDCFyNLiV9qjm3N5i+gRurEcH0T3VcyinbPToc3koKk3Fk28rA+ofPQSYeKaHR5cHDv9NcyrTn+IWeLgniB3SKNKixqJRSW0QNBBIK5i2sPzYyUEba3Dx4TqlsSQ0zrPVTb5z8QrHSRjOiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CjETl4KpUPsfx0ogPXnVc7OyQ4eOvkNVcNs/u4wUAcI=;
 b=qai9jck5SfIpcFnfiB6f1FHk6RNSqltMLS/5xOSn28yihIpXqn+9Wte1me6LDiGpkjhxiI/0Wd3vMgsJ6RHAddkKf6256XpRmxT8y0gLgWMOhaGTTV0LoeMXc6q/R+mJk+BfnbOTdZso6a98v8LFD+p0fo//A/kQw490YiUHcNg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB7715.eurprd04.prod.outlook.com (2603:10a6:20b:285::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Fri, 15 Apr
 2022 15:46:35 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5144.029; Fri, 15 Apr 2022
 15:46:35 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 0/6] DSA cross-chip notifier cleanups
Date:   Fri, 15 Apr 2022 18:46:20 +0300
Message-Id: <20220415154626.345767-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0091.eurprd06.prod.outlook.com
 (2603:10a6:803:8c::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ac8dde23-eb67-4df3-1907-08da1ef71ecc
X-MS-TrafficTypeDiagnostic: AM9PR04MB7715:EE_
X-Microsoft-Antispam-PRVS: <AM9PR04MB77155F1F45E267FDA1101DBDE0EE9@AM9PR04MB7715.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7tWQmeRvf11IKpDNVt/MuuRKhsXy6AMfqdCEVQ1Lq5UT4IjjHJugq5VL1CruaZQI1TjfbpBsC7ZVTC3AJomhgcz/3GCdffulYQomqBaXCRhcBAOBV7cvFQpT9VaS/aNb8Clqqbl3w7bZZqbH+CS9fTSuZJ9FNGdLOu/OqBoMLpB/Q3yIY9Umszty1hZilYB2mdQCev8fSlCB4uPgBT+Vs9RQ9xQVycix6XP9sWXgKN/AUr5j3Sjeytcn2ABmMpW9fxDMVqx62qvZMeTa5NnLrhsUSpXTYpyYGAXXHl8Si3yCjE8ACm9qxrVp3hf7Pp7yKgsO6hhmFLH9xFBhOM/FwAEn46J7t7gMDdotpp7QtrVx3M+SLRl5TFCw3hyADAIlFdryEPaKaPlw5M6sUMEfaKw9Cv1A97UHzReKK6Ii0n5VRIWa6t6yS8SH6d0L4378VfSMAV0Lajurd0x9EOC7U0rkJIfFEG2ijtVS4WcnDUwfG9TihEw+yInvSMpNykjKWDxbZI2NvS+FxK275Db9+mZwJo3cdNz2aJwrRRK9+PeDnVuVp5qvYqBUNhTHx7J6RlS30ih69a2V1+xnLuZr9BEu/OSRkIkLiVWWdFNlyNr2ezUM+qHhx+BysXaf3lyhL576l47UGLfWtCUSwYXAdEV5s3jf8iowYe1msf+1Z8xot6/x4Atv4IB5QQhcXIEcgqZzI+cUISDzEM8iCm2kmA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(36756003)(38100700002)(54906003)(6916009)(8936002)(38350700002)(316002)(86362001)(26005)(6486002)(2616005)(1076003)(66946007)(66556008)(66476007)(8676002)(4326008)(6512007)(6666004)(83380400001)(2906002)(186003)(52116002)(6506007)(5660300002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N6qqo7xjhZY0GvdAKlOqW//qd49q+oauz1xrPGgoKbD8rb8pMyQFdOtUmuaP?=
 =?us-ascii?Q?WDGXPDD47Joom5xB8mxGSqa+Jf6mk9DqBJElZx1mQIut75IlF8FjMgQnx1x3?=
 =?us-ascii?Q?UGBEOI3Klgdd3sOT6+wmwWoNCA71ebh3nnSF/AYK/sWBmeDC8D/m7ko5bXJ3?=
 =?us-ascii?Q?zT0OgEXovVO2g/XsBfyv8vSej2ON8EUdb75nCUzrD0cTshc0o03ulOP0KmSY?=
 =?us-ascii?Q?wz0U3tRPdMhIXf/Tp27PXR6BIXUDvPjzMwPQZZEunmEvryPKjwTlaWfGGQo0?=
 =?us-ascii?Q?ELwj1ynZEzBCJ5fGoPfehfqke9KGFbmmTZUdn49grMexl2ZHq/BuCryTnL40?=
 =?us-ascii?Q?RbpE+nYvn0oYo7S4fYQCRZWj9acu9bTh+1lDZkuKMBGZeMbXA7cEGjPIdP7j?=
 =?us-ascii?Q?Ynbr68uuNZcaclJKQr0uHNOJsYI49Kmf0IqtR6J4d1lgkBCvh8F2JIPJ1Pyl?=
 =?us-ascii?Q?YmnLS2Ec+xAg1NMgFIqEhRe6pAwyltAE08W5XFUSgzKbQN5pbLLOASSzjpVW?=
 =?us-ascii?Q?fLN2npW3SeDBMzQGeDaaLsWrr7PeGuwSM5z7C4/TA0C4Z0EoycV3xx3/UL6u?=
 =?us-ascii?Q?U5MZogRsI4S12QEPYjFqP3KEdhQ5xqsn2FD1O5SY2JiN3z/Us3ndOmkZN6km?=
 =?us-ascii?Q?bglJwr3nkoammJj0b4wYAE5nILaWXzPnxmoJuueKIHINVpOEjXckQEApYQfB?=
 =?us-ascii?Q?kOAu3v9BZ/fSg4CL1z66+hvXxpRDYSc4MD90EZxFJqQQhyQnc9MIsbueexgL?=
 =?us-ascii?Q?SHi9GEF+NOP21W9W2ei6sCdeg9lPcrCSEbYjDVrKD4M9FqR9AtoLfG4enZtf?=
 =?us-ascii?Q?92lZURBiGptbIszhIsbC99raJgFfOdw40dLpBqSkV02YZ+D8lVhP25fcGIyr?=
 =?us-ascii?Q?n6XJEJycSZ2uSxJ6MqI/cFsW7aRFGjaq3WbTmO9APjMLbqFYVqUeFHlSLqQW?=
 =?us-ascii?Q?N/k4StMtkMUcgujlBdnlpsVaX6t9jsfT6bDsgBcRMYxw25yqAp8PfjnF6fhU?=
 =?us-ascii?Q?4T/5VkbNMdHR1LjtQmFjr4zxhZBCDTo/R6ioxzgXA1bqPIJbY4jCFTshxZM5?=
 =?us-ascii?Q?JlWV63kPvTvAlHQzQvH+M2nqqqydtQuTcNoJIIBdDO+Tnnn8J6EF62aO18tP?=
 =?us-ascii?Q?syWkcVqIrDzkQs5+KPdcxJU7jdR04pZ7nSe/CVldBwzr3jMm2hzsJh0t6H6+?=
 =?us-ascii?Q?Q70CnFqi79sb0z0mH3+LkSUjKFtxv/8vI3tQfxMZj7ptLWLVU8jXXbEYn8Yg?=
 =?us-ascii?Q?SvpnJwXIH5B8fKW+jf4FvTG+lSr51MGL18XhdczSyThi3/K8APbiMvzB3PwV?=
 =?us-ascii?Q?CLgHjo/EwShmJSTLS6JZkFd4tWgC4DtDqS7FKfp8tSHfmrpS7qCjLGTK2xc+?=
 =?us-ascii?Q?kGVN5+eCufjo5qdi5D2Zt4F3C4y7+yzjlJ1MVtAPGHr7ApXMtH4LrSbhj74v?=
 =?us-ascii?Q?8rXgLzBJxtxf1XYH9aV/went5yt4u4any2DuRMM7dGhf3vf6nBDh3vOTeJkY?=
 =?us-ascii?Q?jUorQhexsb/V0ZgUuPx0e/4WmESxQQapUpHZjastZccNxTX6GtkSg/ypzPOA?=
 =?us-ascii?Q?+feS0wZKVcMRy7GGym5URmn1gOvBHq9ulP4JKw22BCNPcPDR00H6SsNhgP97?=
 =?us-ascii?Q?MSPnFIqSJMVDZLId0K1VuAvah9TG6TVUZMDHSFiqnPN1fK+sXxCsGEfelG2N?=
 =?us-ascii?Q?NBViLoFQGiRD1jta6dcKEq8o7RAq4705SXw+/iJ5WYVUk9kSpEcmyz4Fg5x5?=
 =?us-ascii?Q?TgcrFs8u+TQpcbTYdYfM37zGhsbxcH8=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac8dde23-eb67-4df3-1907-08da1ef71ecc
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2022 15:46:35.0044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1sG3LDmy+EhxT1XQr1o1v++0Zv9lzNqAFWD33+xa8eyneVkVYxL3wH/k2nVA/76wfAJ5YdFZktv1xcugRNbpvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7715
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set makes the following improvements:

- Cross-chip notifiers pass a switch index, port index, sometimes tree
  index, all as integers. Sometimes we need to recover the struct
  dsa_port based on those integers. That recovery involves traversing a
  list. By passing directly a pointer to the struct dsa_port we can
  avoid that, and the indices passed previously can still be obtained
  from the passed struct dsa_port.

- Resetting VLAN filtering on a switch has explicit code to make it run
  on a single switch, so it has no place to stay in the cross-chip
  notifier code. Move it out.

- Changing the MTU on a user port affects only that single port, yet the
  code passes through the cross-chip notifier layer where all switches
  are notified. Avoid that.

- Other related cosmetic changes in the MTU changing procedure.

Apart from the slight improvement in performance given by
(a) doing less work in cross-chip notifiers
(b) emitting less cross-chip notifiers
we also end up with about 100 less lines of code.

Vladimir Oltean (6):
  net: dsa: move reset of VLAN filtering to
    dsa_port_switchdev_unsync_attrs
  net: dsa: make cross-chip notifiers more efficient for host events
  net: dsa: use dsa_tree_for_each_user_port in dsa_slave_change_mtu
  net: dsa: avoid one dsa_to_port() in dsa_slave_change_mtu
  net: dsa: drop dsa_slave_priv from dsa_slave_change_mtu
  net: dsa: don't emit targeted cross-chip notifiers for MTU change

 net/dsa/dsa_priv.h  |  28 ++-----
 net/dsa/port.c      | 128 ++++++++++++++++++------------
 net/dsa/slave.c     |  31 +++-----
 net/dsa/switch.c    | 188 +++++++++++---------------------------------
 net/dsa/tag_8021q.c |  10 +--
 5 files changed, 146 insertions(+), 239 deletions(-)

-- 
2.25.1

