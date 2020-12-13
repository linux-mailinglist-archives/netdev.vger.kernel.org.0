Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF382D8AF3
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 03:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbgLMClz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 21:41:55 -0500
Received: from mail-eopbgr140078.outbound.protection.outlook.com ([40.107.14.78]:44269
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727663AbgLMClu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 21:41:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j1pJGT9s8zIvJBmuJiV8gSmwCql0WIf07G/S6qMjnICOoTLbHyDEZJyfpZFLZ2rvrnYALLcHAY1yXt5loVfuvgC488xrq+zkyDkk7Ayfps5bRqxTBt+YbJpQwnlreLEHy4MrnAFVOawwLwx0Hbh4oL4xZOcqFGABjwAJb2rLWwd9bibeauhKKe9Hv2Lr/t1AzSX7XyDTaIpijpntkousYTEB5/RJpRigIEiSz4ge+MiWekDKsurv7f6PdZflJKBHCFd0JdQ5evKKjR68Q9QTYGHs/lU4Q2UtAjCXme2LEHfysqZ6gRfNBwq9R/LSzns8uHxmyq1Y6WztuH18f/7gYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l+5rd7hxSU1RvLcEtYHVa4mtvgaZoy4+z3dy9/uQ/gE=;
 b=oFWK8Ol/UPKURkHfSXtgffQRPkqMc48mA1hWTL/6/rhbMhzAG4Qm10fkInERyfopnFhYFz69JmleeKJjx06vH8izs4Pb8V6sbToIPS3S3MIMrqo/FcmMy4Evgl+xJ6LxUAPzMfeQvnnMmBfhBEvtxMgGD1+d0zE67Vi3EkVl3KI5gEdtFZEfMcovXxLsQucU6RwMJKRAT4QjkgYhzDir0X9B3/QRDg+hCO9O7LYdDn934nAMQ1WQZkTqKtt8us/mIgdIGmuIggHK1E5F/TeWyl80brRTPLllCiTm4gvqqZW0TTxpogl0A94Z4qEF62Zv77OsvrUJTafgkDFwBYt5lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l+5rd7hxSU1RvLcEtYHVa4mtvgaZoy4+z3dy9/uQ/gE=;
 b=JVkmiz6J4ikj7q5sP7zhiUM14KjbmVwAHga4YCpfYUc/3TF7KWE05ERl5vvvrvb+kpve58YKM4eU+ubcBk3xGpBtxUhXDjTaEjejs5sAIXzK8pkuwj54rO6/encrN0+gIBXiePiVZhtNJjvRg5vFUUBl7PGUQD4jxj3+6TB0mk4=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB3407.eurprd04.prod.outlook.com (2603:10a6:803:5::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Sun, 13 Dec
 2020 02:41:01 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3654.020; Sun, 13 Dec 2020
 02:41:01 +0000
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
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH v2 net-next 0/6] Offload software learnt bridge addresses to DSA
Date:   Sun, 13 Dec 2020 04:40:12 +0200
Message-Id: <20201213024018.772586-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: VI1PR08CA0141.eurprd08.prod.outlook.com
 (2603:10a6:800:d5::19) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by VI1PR08CA0141.eurprd08.prod.outlook.com (2603:10a6:800:d5::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Sun, 13 Dec 2020 02:41:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b8eb9fff-9f1c-42e7-012b-08d89f10879e
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3407:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3407B1B9C6B75FDB5F66A163E0C80@VI1PR0402MB3407.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k6BUUb9Zl1fmBjMYw/ey+44BXUyNmPDVDLBSjnTTPK4WZ3HBRjCPuyd/N45N83PNS5Zv4eqq5pfrV5SU9fEI7vu4jNHO8A0dndWikKLLJcqcAvwtl3NRiJ09swSR9QgSQONnItMMUX+Wv4XWQFKACsL+IHlv0kSRucTWW0KNzciSp/3xLWvxVyEMAQRYJJ1Z39jiO0km/feLgtUMZWM1CrF/kt5FPvbdD2QRLrEwDO1zEv/VkG/XGDbGIRy+nD8dUcKyp51IcW1hayvM1Md/HC5NXT9+DrA/HplFZYa8opBkXMo84y5KCMP3/PFhgps1jBM9ZB76Sq6DopQOoEQx0tbVL3zz1Lmyim+6DFemi8qDFeNvdlfnKSu5wa6G1Uwvht+PqnZKzRsTTnELzihugYW/TRtPVVzVe8xmUwOiKzWiONhTGGSMQj1jD6a+MwXqO/4wmjJ8lw/x0iSPfsB9KuPRHWzyuiMImraP1yz+vgs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(39850400004)(396003)(376002)(52116002)(6512007)(66556008)(8676002)(316002)(478600001)(16526019)(966005)(44832011)(5660300002)(6506007)(6486002)(1076003)(7416002)(110136005)(26005)(921005)(2616005)(86362001)(54906003)(66946007)(2906002)(36756003)(8936002)(186003)(66476007)(4326008)(83380400001)(956004)(69590400008)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?lsUwSNiTIVYWg9d3hDDvp8wI+KFelUJFPn34Q8XW3Ro3428CZMvtcMraLklU?=
 =?us-ascii?Q?TyUW6SBN4hWsQ2Y3rvgoUZ0UqBGYv9zlkbXcoXOAK06ZjNSki70IbOsNsbkJ?=
 =?us-ascii?Q?qvhPmcC66/9SJ70L2E+b/VtLfslFUUFp9wJhHiW5FmEe0OJjMxWKmG7b1PdW?=
 =?us-ascii?Q?c8WX31w2YYR3w0PQFjbcA7VHGsQEAQo4sjgc9C/MR3ndgbXPOBXUOldvgxq4?=
 =?us-ascii?Q?wie50X63RdJP49iJ46zhAS3Dz3Wd2GYcP/AvPU72dyWsFewoDSlhIqr/ruxB?=
 =?us-ascii?Q?8Ndm6AYt3F9VMxDx1LaRMH1mCJdP/vhKER/UfKIxG4bqb+CowPdG2wwfkfGI?=
 =?us-ascii?Q?5HYw1FnQJ0wBU7QAg1AbO+uLSx8/5t2wXwI6A+qGfXRdYeEDrids29NKGWqX?=
 =?us-ascii?Q?tPEdN7JuF0YVRzYwPK8OUKbbVebtU1TX1pdxLQoYI+zG8QMwG6CH8BLHSaOV?=
 =?us-ascii?Q?5w57WYTId3IlXpeERdsYY1WJYU+QonXfMz41fzkfXFeXPUXwHnAY0B2Hx78J?=
 =?us-ascii?Q?8/I7VSQlWmLEZvykWlD48FuT+ZFJmph9pfiGrc9rMwPiOvEWJS/tSettJIn5?=
 =?us-ascii?Q?H0HqOFhF72qWkP10PI90B3f7lSkVpCnIozLlR+ah1B5UVh/1ELTGfnNKc1zX?=
 =?us-ascii?Q?mgW5SUbMr6IPF4qp10cyUUimpNo0fcEU4ELfOwYN70Ogd6Jk0B6t0mAUU2eb?=
 =?us-ascii?Q?g11V5zIkQW7ObxJAuBUejMUZG/ZZvHfsJa4mwu4bZ2huSzyhDeLde3P8tAeG?=
 =?us-ascii?Q?QKHLH58itcJiMEckJ+MA24fAl/HAWUpPNVMz1XOYiinK8eY62RludobQ+Xtm?=
 =?us-ascii?Q?yZSOrMfQC4JwlpmOJlRDdpjxjtW4WtGgL0Wco3IfLHVCG1eTpuKetHV8ft9Z?=
 =?us-ascii?Q?Lr3gN19cDLzDGms/0qj9+XjlyXARmmEaamdSap9eBFgx+/U6OMudDUPr5vPV?=
 =?us-ascii?Q?3O+CrYUkprWdGtxb0Xd3P7G596LFpD6nvo3NNdjr45CXpIxvqdeMizT78zml?=
 =?us-ascii?Q?YMtm?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2020 02:41:01.5897
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: b8eb9fff-9f1c-42e7-012b-08d89f10879e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JaTdJMUKvzjTMG9mbhTv928RYelR/phGYaP7EC3xTkvw5RyEEC6nuxTjrvG+L4UqVlFLNjmgcamLccDgxqca4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3407
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This small series tries to make DSA behave a bit more sanely when
bridged with "foreign" (non-DSA) interfaces. When a station A connected
to a DSA switch port needs to talk to another station B connected to a
non-DSA port through the Linux bridge, DSA must explicitly add a route
for station B towards its CPU port. It cannot rely on hardware address
learning for that.

Initial RFC was posted here:
https://www.spinics.net/lists/netdev/msg698169.html

Vladimir Oltean (6):
  net: bridge: notify switchdev of disappearance of old FDB entry upon
    migration
  net: dsa: don't use switchdev_notifier_fdb_info in
    dsa_switchdev_event_work
  net: dsa: move switchdev event implementation under the same
    switch/case statement
  net: dsa: exit early in dsa_slave_switchdev_event if we can't program
    the FDB
  net: dsa: listen for SWITCHDEV_{FDB,DEL}_ADD_TO_DEVICE on foreign
    bridge neighbors
  net: dsa: ocelot: request DSA to fix up lack of address learning on
    CPU port

 drivers/net/dsa/ocelot/felix.c |   1 +
 include/net/dsa.h              |   5 +
 net/bridge/br_fdb.c            |   1 +
 net/dsa/dsa_priv.h             |  12 +++
 net/dsa/slave.c                | 167 +++++++++++++++++++++------------
 5 files changed, 124 insertions(+), 62 deletions(-)

-- 
2.25.1

