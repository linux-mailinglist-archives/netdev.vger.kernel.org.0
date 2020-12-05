Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 842A72CFE18
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 20:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbgLETTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 14:19:08 -0500
Received: from mail-db8eur05on2119.outbound.protection.outlook.com ([40.107.20.119]:13921
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725902AbgLETTG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 14:19:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mYwgQNWhKPqIk43/yukeMmTjoN6VHOQIyv23qg89Fu+XTwlK2DzunUhOWPXI7j5KUVESk93ll3Sbju0UCRHea1nbp20DzRYM6ltu96aJ+NhfwQBij19oh6XP4y2QXYTii2y8xtT6fNNTpRqT5QrXy7URJoG+5uQNjPobmp9vrISL6w0TifY1VTwVFxwgBjgMfx5ZGr1YryaO97bye4RIp5qpGueebTzorT2x5CzSTTsZHnbHn76cF4ZSj4++NuPmU0es4DREO1cmrZU9Gf4l40jLzadFgb8/nS6v5klLd8SM/DqI7v5J2PmSyxaTMOdLJ8zoIBDk87mTTI5Z3tqu+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J1000bth0R4PjbivgQkuYbV5Wi49n13+XgebzPJUeUY=;
 b=OrSHzgqq6SA25jF8xVyrgBgmWl2aRmSAbVtdtYGjXSsYZRqo8sGs8IRfShMpLm2gaOEpcEj4Jn2QZqvA54LDdc5A5Iie46bPqmWHs5LYTvPNZE9qjhCPXqeH/K52XhbHAjYszyyUq4h+/D3q2LIkB1omh+mzZPdn5N3T2hjUd3pX7Yj/aHfe04Nmymi/lx/9NFlVCmJwyN/hhZbdZ2ZpelsahQ3/StqMdOXFxzcQNZNsIhefBSczJoZXeGCGoHzAw3K+GNQxr/gFUBl1vz7b/KS4aqsy4M26mwV3YzM3CoH0+h9t6S2FLfhvxDRgu4U43UmO6HCDTCL+4CjqitDr1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J1000bth0R4PjbivgQkuYbV5Wi49n13+XgebzPJUeUY=;
 b=LmLuwhDwjj8yODbJ577iw+YgqlkPNIO2+Hs/mhkjASK0+D3xf/kcafYQPww2SkQDXuXd2r58ZBOGz6YXcrJnsabZVrnPuUYc6Fuy38D5gAKpAdvLUGhm8IgIuDC8CrPGXssCJvRIjcNGhcPLr9TaH2spWE4h8S7VwEOazLilIR0=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB3729.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:185::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Sat, 5 Dec
 2020 19:18:17 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3632.021; Sat, 5 Dec 2020
 19:18:17 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Li Yang <leoyang.li@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Qiang Zhao <qiang.zhao@nxp.com>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH 00/20] ethernet: ucc_geth: assorted fixes and simplifications
Date:   Sat,  5 Dec 2020 20:17:23 +0100
Message-Id: <20201205191744.7847-1-rasmus.villemoes@prevas.dk>
X-Mailer: git-send-email 2.23.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM5PR0701CA0063.eurprd07.prod.outlook.com
 (2603:10a6:203:2::25) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM5PR0701CA0063.eurprd07.prod.outlook.com (2603:10a6:203:2::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.5 via Frontend Transport; Sat, 5 Dec 2020 19:18:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cfe90b0e-7301-43e6-3887-08d8995284e3
X-MS-TrafficTypeDiagnostic: AM0PR10MB3729:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR10MB37295F16789C80F3073E985C93F00@AM0PR10MB3729.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lvkQ4HWZCqSdlheXbguYDTbAMTY6hDJgWPnLXq+viTK8syOM21f1AOUXUPqecF6+IkdfH8qnc5g1pRNqwIvx0JRS7ExTjUA1Ej473oHhI8hGA0mOjRCtGyrfy7wBfbi/u4HMIqvP8cPWvLaSHe1Ev5ECql+Mhs0CMl1WwWlqPhM3qVNthkazosyH9mGGUqb6iRv6RulK9oOqQ5hNzr0l7gzUxdGrGv2gVJDDWWA42vHKzHPnnNtS/3G9OH71VwXhILbEj/Ut6nd9CrErXtUqBxmjgVhIMprbr8jnA4zujdB7UT8I8Q1Hi1gV95eZTQ1s
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(366004)(396003)(39840400004)(5660300002)(2616005)(66476007)(66556008)(6506007)(107886003)(8676002)(66946007)(4326008)(8936002)(2906002)(86362001)(956004)(16526019)(83380400001)(44832011)(6512007)(186003)(8976002)(26005)(36756003)(316002)(6486002)(1076003)(52116002)(6666004)(54906003)(478600001)(110136005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?B3OZpnefOXZUwzV9psVEDduen5c1DUQ2goydgoSq5F0uW1aeV8cSRPxIlU7v?=
 =?us-ascii?Q?YNCHZHxnqnR0NmRUQ2dnvKoBMyO7aQXU5V7N8CnwZUwBQ5VfxtgjSU44dWGp?=
 =?us-ascii?Q?EQIA6lv5CddHRw633O5Gd9XB2M7I2I0lJ0nlo+WKiwoxafvX4hgfb4zPy/y2?=
 =?us-ascii?Q?+RtLvg86cSTvLeVHNNxzRFO3rAWj5uhM6i3Ppg1Y36WgRjweeCE/SmTC3YhJ?=
 =?us-ascii?Q?KquqGPRIvd950cvoTjM7ut2FjZQ+UIj2qPMpoSzbKdFGRmUXhOiPkoHYgiPp?=
 =?us-ascii?Q?6eJiH/jxohLZEgyGeapxcwyk2hx6hxjzRtjgm6RkrDWfh7WVwfmiQ85CGST8?=
 =?us-ascii?Q?UD7iFRHERsejeOkMOpNEO+SwwWsl+j7JyoRRgDPN1FSengP2Bjo7IFmYqELN?=
 =?us-ascii?Q?DpwEjXrdL5qZwOO+cjjSvgUFTteOcAamLMyHGjqYZdBuRv1vSOX7scmeXvPp?=
 =?us-ascii?Q?wft+RFGFYEYZx5nH9LGH1QReKO0+F41Q9kMK7tf46VbNU3Ir+kzDoPToW9Qk?=
 =?us-ascii?Q?H+1r0a+Z5alBpfnmExIUZgAjaTAfASjN2H37WaOXsnoOqTKRXzcnKjOPr0Nv?=
 =?us-ascii?Q?VryU9yMVVY7HdstVOeyFqdcr0VjMDrO5iH6EgZryfsW+/ig5xtjdxwk3pRxB?=
 =?us-ascii?Q?dU81Z/p4Y/8zTiknneiNYfetOVqz6b0AJmy0lOUsRjBNjwbz8uUV06phATWS?=
 =?us-ascii?Q?Qpy0FSUB+cAXyMZISLZIZJkR7Bb4I3ViUbaklLDgKX3aP5zajrB39qMuudpq?=
 =?us-ascii?Q?fNMSo0Yw37oNPXNeu/GBwymLQxYnRVYKxsnIUPlILXDqtKtwg3tMH27TXkG4?=
 =?us-ascii?Q?vINd/CxUJof6p+zY8SOZg3sQTWJKOaXTGUDEu7fePINi0SZ9JoK/CndNkOEq?=
 =?us-ascii?Q?GlTsoDqGuNJlhXloxpcay7G/4Cre4CauWv/j1ZYsXZV+p7XEKQGrpND+degR?=
 =?us-ascii?Q?btQQUWpD19E2TRWttS8PlZxsQ/Hnibz7AtuTWMsgX7dSVnHu4PLIgd0610u0?=
 =?us-ascii?Q?HNHv?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: cfe90b0e-7301-43e6-3887-08d8995284e3
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2020 19:18:17.0325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XoTKCl+eHVCa86h9W78Fylq7ei7Gu6y6vbd5Qb9/bLSleoayCR2bFbX43DLAPFNKWiib1Aoh09mSuD56zBJHxDH0m2ME4VhE4CS5HoKsa6g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3729
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While trying to figure out how to allow bumping the MTU with the
ucc_geth driver, I fell into a rabbit hole and stumbled on a whole
bunch of issues of varying importance - some are outright bug fixes,
while most are a matter of simplifying the code to make it more
accessible.

At the end of digging around the code and data sheet to figure out how
it all works, I think the MTU issue might be fixed by a one-liner, but
I'm not sure it can be that simple. It does seem to work (ping -s X
works for larger values of X, and wireshark confirms that the packets
are not fragmented).

Re patch 2, someone in NXP should check how the hardware actually
works and make an updated reference manual available.

Rasmus Villemoes (20):
  ethernet: ucc_geth: set dev->max_mtu to 1518
  ethernet: ucc_geth: fix definition and size of ucc_geth_tx_global_pram
  ethernet: ucc_geth: remove unused read of temoder field
  soc: fsl: qe: make cpm_muram_offset take a const void* argument
  soc: fsl: qe: store muram_vbase as a void pointer instead of u8
  soc: fsl: qe: add cpm_muram_free_addr() helper
  ethernet: ucc_geth: use qe_muram_free_addr()
  ethernet: ucc_geth: remove unnecessary memset_io() calls
  ethernet: ucc_geth: replace kmalloc+memset by kzalloc
  ethernet: ucc_geth: remove {rx,tx}_glbl_pram_offset from struct
    ucc_geth_private
  ethernet: ucc_geth: fix use-after-free in ucc_geth_remove()
  ethernet: ucc_geth: factor out parsing of {rx,tx}-clock{,-name}
    properties
  ethernet: ucc_geth: constify ugeth_primary_info
  ethernet: ucc_geth: don't statically allocate eight ucc_geth_info
  ethernet: ucc_geth: use UCC_GETH_{RX,TX}_BD_RING_ALIGNMENT macros
    directly
  ethernet: ucc_geth: remove bd_mem_part and all associated code
  ethernet: ucc_geth: replace kmalloc_array()+for loop by kcalloc()
  ethernet: ucc_geth: add helper to replace repeated switch statements
  ethernet: ucc_geth: inform the compiler that numQueues is always 1
  ethernet: ucc_geth: simplify rx/tx allocations

 drivers/net/ethernet/freescale/ucc_geth.c | 553 ++++++++--------------
 drivers/net/ethernet/freescale/ucc_geth.h |  15 +-
 drivers/soc/fsl/qe/qe_common.c            |  20 +-
 include/soc/fsl/qe/qe.h                   |  15 +-
 include/soc/fsl/qe/ucc_fast.h             |   1 -
 5 files changed, 219 insertions(+), 385 deletions(-)

-- 
2.23.0

