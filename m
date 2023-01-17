Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EAF6670E18
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 00:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbjAQXwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 18:52:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjAQXvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 18:51:51 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2078.outbound.protection.outlook.com [40.107.14.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E39DC4F367
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 15:03:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jb/LGneaFSdtqoGRrVFA+dcPzpz/jsxsqYhFhn6HFS+EVBuF4CiAtiC376EODrsCjXbbwwoNc91XIRrs2fF990NnleqzGDi1lwzDOG/QTMiSrD/lq4xDX/MFQma9e80MtH+vavzZQ3LubeeMF997k6lORAr/mVzIXidzANyu6xYggPlYP7DLKidBjltU6HI3l74DLo94daafjrBfdqIgLJQC7zBqZ+0noWLL9DIPMEY35BLf3xAmmXD7U8d2FiuFiqBkUuJc84pEfrlsXBLsGaMBVArbxe9yoEK3bdPdA2/PRUVLDHkMomJLLn+sU3lWLMoMSxB8U7RzfPBKJJxaEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZiXAYvFva4V6Oa1asNHNkkDfeElM3BGuqUo36/YJa0o=;
 b=V9roXa9gNW3RU8Sf8fYO6Z3U4IAUkhtWYMk0nGqHZc/8dAsh9t1XDJ9ymIJtFnnIYrN1CpfVfFAkMzuSQMpstAuSZZwkgPt89NFMZKECbOxj1jTCFm4z4qs+m4UwVj+tHa7ghdppIFPBQFu6E4bvveuPoUMM6/ri4xyOMNMXfnJCcvKIuxg8NzN8ZL6gNW9AK8Ns7vVaL+NrT+nVlHmfyo1IJ6m6AXgP2zbJqK8uhoUQqo2t3EgPE1Le1fbpuN5496dtrRGOdvwfZb1ouuJ7QEC1rfxQBGjPWZvQew+hORZuisE/fON4J0jUReY1AQtZsrHfMGwrKQuuzp5sjzsVQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZiXAYvFva4V6Oa1asNHNkkDfeElM3BGuqUo36/YJa0o=;
 b=WBHLY1qTqtRVYKIIQ1PKuqdOTaXK4qDeTgSHGeTrQvu/YHN9z35b/qo/nIVirqU80rTM6aZ9i2TR8NlGAH2ArBINxhapafYSxYJ6nQKCBxc775cqhwQeYDV3Ratu1AdsCkVZswXlR7by1vei4v3Gecyhh416bqJcRoc5OkTBJyw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM7PR04MB6808.eurprd04.prod.outlook.com (2603:10a6:20b:109::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 23:03:07 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.023; Tue, 17 Jan 2023
 23:03:07 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH net-next 00/12] ENETC BD ring cleanup
Date:   Wed, 18 Jan 2023 01:02:22 +0200
Message-Id: <20230117230234.2950873-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P195CA0002.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e2::6) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM7PR04MB6808:EE_
X-MS-Office365-Filtering-Correlation-Id: 872dcfb9-cc55-478f-e0d8-08daf8defec9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hASvzBuQ+hNmO7XddEw05uWYOqbb/xagk9SkjrH4CNOF6+0WqL5L9MwdTm87eRgWxFBZcGAbIl+6opk+izgfo0EbY6DUCkmya8zRg7Nhj4Ih4ymAiL51AO8tKVTrWruxEHuddt/3WND6g3TBPKKCCqA1SrYLYi5iXr7iF3gxD6UDdG/Xcc9vheCZyOjd6vjtMglfgpgy8IhBgFbuvz3r8pQ7sCtVlVuzQeolknrtMVqsbGX1CMiArZEAqCJAxvakJgzh7nyVg3xMiva52NMcWBFEXndNa82n7TaDRLsSH9Sg5sk/KSUSmtQ55gS4ac+qJdBtvEu5Yn46n65nHmMP/STVyQhYc5b5DkJ8FFX4QNC9bXI8t6m5FEe3bJPBmmKEH0G6YUYFR8gcqrW0POjyRtKnC+CSVVQ5EzUHWBJy35CiLlKTEkIebaseM1I9TVZv0pzzPcS56KTgY+6t9XU/JJ1mSprPemY+rJfuBuJEwofG/LubO9GF93xq9XGwCo4oU8HsdHhwJK0Hpmcw/ehRdpOILoKkn42Bjb+iicskEhfxvqCrkmW3JK+u7uaazuQXgFeMN4QVIt7K9XchhhgWr3XXtmSLsdrIYoVHGYS4ZCzaEHQi4MwqNvD42UpYj9a7vjeFAuShgFQrqfjTaDBRu7EcsnLcV2DpZ3G6R9Cex2B8wE4cHrjUezGGS58PLyR1OjH8+GdXftyXxu4cYqrxgQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(136003)(346002)(376002)(366004)(451199015)(86362001)(36756003)(38350700002)(6512007)(8936002)(44832011)(41300700001)(5660300002)(66556008)(66476007)(8676002)(66946007)(6916009)(316002)(4326008)(2906002)(2616005)(52116002)(83380400001)(38100700002)(186003)(478600001)(26005)(6666004)(6506007)(1076003)(6486002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yorlFOiPDNOaZBw5OCjNREmKvtSFY/azm9k1foorRFAZskNMAa7Srq8IwATm?=
 =?us-ascii?Q?ysiaAOEuIUQQ2+HAhzgKHtIVySGs3iLi//9Z2gDtPoEa9DJO+vm+rkfEeNJL?=
 =?us-ascii?Q?IYI7XYi0Taw+556i7q10FF6Li4Jk/ds35HLei7iJUMHfiv1wNLG28kdUR1M4?=
 =?us-ascii?Q?LATH8OcoI1kTW76S9CySY1Qv6xZrc+jcqnx388mY/kI6LWWHo5GSEoCryhim?=
 =?us-ascii?Q?/MBjr6hGkmn34wlONJO2/ZOW5xrwR4A4o+2s2lPhs6DhUDKGx4/q95dh2KC5?=
 =?us-ascii?Q?/hAe0PcrK2Oe9KHSVtSdQo93W/RJLpLgYh4ru87Vr/qOtPQsuAJ9k8Ybm1Xw?=
 =?us-ascii?Q?Gpbetu0LZ8dRkd0We5oQUFXOKGdBmoXoUlwOQAQ/ui2LGZ/ynPQMpG5Erjer?=
 =?us-ascii?Q?XmZVE6/2sK9NsZdj937tiM5It+4rMrruSnIVLfg5He+U7lREV+X99Keti+UE?=
 =?us-ascii?Q?QUziOSBYer4SFhqZNFUG/o/vjyfTe8ykiCEfJShlVsNgdxh3KTwk43iqrS3c?=
 =?us-ascii?Q?qDNh+JNIP8wtBDSG0+Ah1jgJ3Zj5I7/6YfsxdbZmPDlpyJspXCYvtbMkY1Di?=
 =?us-ascii?Q?BWI1vVdf4BU6hQUAEQ3eJbgkagG6t3nWRbP9l/8gJMRfSVhsM4CTqIpIIbvo?=
 =?us-ascii?Q?QGO3n+gV0OdeBHqmOR7jJgVSx9IboT08f0iTE7uQdxpiqY4CoLti7IhA03os?=
 =?us-ascii?Q?1psfYHZ63upckyXvDcAcLdseC2SDcjcC3mPgsu5w+3d6XjlMFFrcQQhYo04P?=
 =?us-ascii?Q?3H7iDOCt1eOIMEecdfaCr1RGn1W/CFoLjTZ69VtTd+z+T41cwSpQHtXoBnaS?=
 =?us-ascii?Q?jxt3K9dY7yOCJSloBEBb+tc1RGuJQQfYqJFQ9Je2/1qHi/wB8ozBz5ENwa1t?=
 =?us-ascii?Q?D9wZ/3dCpPaMX3O+vnGhBmj8V7WgyshL3m3E0r2Sxec79Y0+lQXCIHS/vZmp?=
 =?us-ascii?Q?JSYNF4lFPxIY3qUq2D5bFiLMbTc6vz8IS0NoMXXk2GCAU6ASviGCB7RUSWnp?=
 =?us-ascii?Q?ObMSiLvBqb25Uiy1R/nAcZZy/VOwGWG8VRCf8zg3Dn9huCvHjNpc9cD+LRzf?=
 =?us-ascii?Q?FhIRd24lWK5wqA8/2swuvREiW99UHN0Wp1md7U1n9RvR1A0bV87Kd0gKl2wj?=
 =?us-ascii?Q?3C/7n+UBokkjzNTLbAaIISeKF2TIuXj44MwIr+INFniJ0iVIoF3lhxWoSqhc?=
 =?us-ascii?Q?OJeBaoOBJZpBjTBtNlzEvIGr10734BKwlSZJYOp32W5l6G6zOMIkCLfvZ8mX?=
 =?us-ascii?Q?XSpIqdq3Zs8QH5A1CugvoqiU6GGswpTDmdLxIRwHneIZBOm3gVvaNXEcBGKc?=
 =?us-ascii?Q?CArMdew0ytdcBEYqMsoqTUJ11mVWkTITh4Hc7D49d33fB25Y+nLM1w/nwFAA?=
 =?us-ascii?Q?5wPMINFQ2h5ghaEBhZ/0TSRUoXjGrNDnxJKehYsTFHqa0+UsMDZOHkbFFyaP?=
 =?us-ascii?Q?lHjx7aFfpLIlrvKLkx93DyyKSGWAz+pzAVyrUcfnsCAY4M6STza8rGFEd5r4?=
 =?us-ascii?Q?kgaUcMetQq/zITkbOv33X0Ern+93vtA1oMXz8BUynS71jQdRZip5yB7fsiUb?=
 =?us-ascii?Q?wEP5N63r+l0lBLbxxYSgZ3MR6nNNg/lNcEKs4Q6OsBgXC2xYJXW7hvkCh1ko?=
 =?us-ascii?Q?Hg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 872dcfb9-cc55-478f-e0d8-08daf8defec9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 23:03:07.2886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cPmk4cutKVit6QPHZgQDu6sy9G6eLMmr3VvVIwWCaV97VlHTuVdRPrk2jlN3nY/O1RS92hmWm7LUquuHR+pMPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6808
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The highlights of this patch set are:

- Installing a BPF program and changing PTP RX timestamping settings are
  currently implemented through a port reconfiguration procedure which
  triggers an AN restart on the PHY, and these procedures are not
  generally guaranteed to leave the port in a sane state. Patches 9/12
  and 11/12 address that.

- Attempting to put the port down (or trying to reconfigure it) has the
  driver oppose some resistance if it's bombarded with RX traffic
  (it won't go down). Patch 12/12 addresses that.

The other 9 patches are just cleanup in the BD ring setup/teardown code,
which gradually led to bringing the driver in a position where resolving
those 2 issues was possible.

Vladimir Oltean (12):
  net: enetc: set next_to_clean/next_to_use just from
    enetc_setup_txbdr()
  net: enetc: set up RX ring indices from enetc_setup_rxbdr()
  net: enetc: create enetc_dma_free_bdr()
  net: enetc: rx_swbd and tx_swbd are never NULL in
    enetc_free_rxtx_rings()
  net: enetc: drop redundant enetc_free_tx_frame() call from
    enetc_free_txbdr()
  net: enetc: bring "bool extended" to top-level in enetc_open()
  net: enetc: split ring resource allocation from assignment
  net: enetc: move phylink_start/stop out of enetc_start/stop
  net: enetc: implement ring reconfiguration procedure for PTP RX
    timestamping
  net: enetc: rename "xdp" and "dev" in enetc_setup_bpf()
  net: enetc: set up XDP program under enetc_reconfigure()
  net: enetc: prioritize ability to go down over packet processing

 drivers/net/ethernet/freescale/enetc/enetc.c | 502 +++++++++++++------
 drivers/net/ethernet/freescale/enetc/enetc.h |  21 +-
 2 files changed, 357 insertions(+), 166 deletions(-)

-- 
2.34.1

