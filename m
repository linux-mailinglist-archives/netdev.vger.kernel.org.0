Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2EC4F691A
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 20:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240574AbiDFSUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 14:20:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241572AbiDFST0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 14:19:26 -0400
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2091.outbound.protection.outlook.com [40.107.117.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21E5BB6E60;
        Wed,  6 Apr 2022 10:01:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oQ6Mp8BykhMGYm8HwNn4HTU7u/Im2qc8aQbsoAItG3/ZKz9fbrMvyvHA/zi+bwfpuoFYweu43batrxxcMyDunPi1wV57a7j4iXCeiIjw480e9jc6Fz5ueE2Ww8Sss8x+dHiNVxTQ2Etr/wBA+atrXV5lJNIJCe8t/cG2mEZ2cetsyQXVmHXg+vLbsryuw0nckHInaOVNesDUMERDu+D5HqHkoiQRy477t4fDrwLy1RX03T1g7rAUy1XiQGYTQfEmDIV+fW6cGoOTiuIyEpebwXwyBf5ResKZXKrDDo7z4PxGEUpa2ixoMvNhgS+cCXKXY+8pw3xH9ri3zE56GoUYVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W7RhM/ksXWdB7tb0U0+50mmjtbB54vz2QjNNhKipKxQ=;
 b=JbTJ17ICntFAcOxlKTAqw3KrU3HRoXSggnspC8xy5X0xR2YhZRiDJJrciE08FigKPh/XD0ssmcZ5FAgwqhFFLNzAaMbAhXJ5fgVIuhwtA0s9al/OlxyF9FK04O/zGFW5yk24m274DQkP1bHIubHFxrcnMIKvagRzp9VjphjKlkWJjJb3zUFdQrkB0s6Qq6D67q0EdduBkv1loLtCCAh5sSIdqlt6/01WOSJ6uZuOZwEy4CcBBCF0l3rtraIdT35EBAtCXclCe6MCfJ9xoZ0ch26j0lt8Ys+1xJFsutbJGmjlEmDB4gzFAjojZ79CLZk95ntUMzwQJUkz5Ayku3KXHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=quantatw.com; dmarc=pass action=none header.from=quantatw.com;
 dkim=pass header.d=quantatw.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=quantacorp.onmicrosoft.com; s=selector2-quantacorp-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W7RhM/ksXWdB7tb0U0+50mmjtbB54vz2QjNNhKipKxQ=;
 b=DEUeAQ+FtZxVGLqYNVhD5vvr5DEqhPPrPrFMS9XrkLqGFDSPe0G26yKdjAne2nTVkUXfiEYfRI/YZotmwcRLldtD2V2R5mWziUcOVTXVCO+1V+qgi2t3mDX8Y9GcW1MHlucpMDwc5lYg6mPREZsNrdba9M0631FTVv0oOrB50Vk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=quantatw.com;
Received: from HK0PR04MB3282.apcprd04.prod.outlook.com (2603:1096:203:89::17)
 by PUZPR04MB5204.apcprd04.prod.outlook.com (2603:1096:301:bf::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.19; Wed, 6 Apr
 2022 17:01:20 +0000
Received: from HK0PR04MB3282.apcprd04.prod.outlook.com
 ([fe80::9c61:c8e7:d1ad:c65f]) by HK0PR04MB3282.apcprd04.prod.outlook.com
 ([fe80::9c61:c8e7:d1ad:c65f%6]) with mapi id 15.20.5123.031; Wed, 6 Apr 2022
 17:01:20 +0000
From:   Potin Lai <potin.lai@quantatw.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Joel Stanley <joel@jms.id.au>, Andrew Jeffery <andrew@aj.id.au>
Cc:     Patrick Williams <patrick@stwcx.xyz>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Potin Lai <potin.lai@quantatw.com>
Subject: [PATCH net-next RESEND v2 0/3] Add Clause 45 support for Aspeed MDIO
Date:   Thu,  7 Apr 2022 01:00:52 +0800
Message-Id: <20220406170055.28516-1-potin.lai@quantatw.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: HK2PR02CA0148.apcprd02.prod.outlook.com
 (2603:1096:202:16::32) To HK0PR04MB3282.apcprd04.prod.outlook.com
 (2603:1096:203:89::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9d68b442-f42f-44c3-d954-08da17ef123b
X-MS-TrafficTypeDiagnostic: PUZPR04MB5204:EE_
X-Microsoft-Antispam-PRVS: <PUZPR04MB5204BCB8B8312A5C18671FB08EE79@PUZPR04MB5204.apcprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y4QlwVqcZE+i12e/fQF5ufCJu1cUKWhYv1ot5Tp5+vPMNNtvdfMi0WDNbzrOh4dJ3h7VrTit9Rw9xI8uctlw1rplhVruTRRQ7+DJORbuD+SpCRJOgfojYLhtgd/8G0JQSB70cnRLYdqC8hMHj+XF+YGaYhRRGwcpc58RgyPKsA+Qz6zscVpR+S68p0eTVwvGC8SmY3QdMu4Yhb7SxlP7NhubyC3K8VRvVvGaFo61U0TfegOflJrDjZIGxqkmUWnKCkwv9kUMJgFmoN3OADQHwjEjKHA75kbrXxdg0ohx+k0HUrr3eJdIfgiUyTJPISY7eQQGW3DDRJgYzkCtXx/JE/P97d37weMMh0iKZIHfMBjB8gKy4gvSvsdTUJmlW+moO2CfIicuuPY9XTJvFyPmv3c9QZvRlPDd1/e+dsG2+vlsNPnFerqj7NpPGMYlYSxiLpsIPz+Fcbmlljk/iBYsX2Qp4oFALaUfqffHalLNLK3BBJVhbqDZE+vRcS8Qsod+qn8TSmOZSEH2lYB8X/UdRl4aII7FHoOAFihso92oKcsNCw7585R0le6fxN+GtyRlfW1qo5zXZp+ctuLzXLr3BiiX2kj6qd09MkneeTd9jv9tuNW/gnpuMAtQSFM2z4ox78nJKuRNT3ONfjbeuxFNPUIQyFTY8JNfQHVLoYrUSjOE2o+w7a3tEERiI78fhnf+y0pdDrDt2TH3vUNIeY2dGPr5N6/UgRWBgCkNVyhHOaNSAvNRuC+ZpGjwFwLVqjc5mWXpmCy/cIdkzG+wx4NBeX/8OEkOAdQEGCJY14UZIww=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0PR04MB3282.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(5660300002)(38350700002)(26005)(7416002)(6512007)(36756003)(2906002)(6506007)(52116002)(186003)(508600001)(44832011)(38100700002)(4744005)(6486002)(8936002)(110136005)(107886003)(4326008)(8676002)(66476007)(66556008)(1076003)(54906003)(66946007)(966005)(86362001)(2616005)(316002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S+Tk7EgT8X1YPpJd/7LF6OpPgnIrxz6TTw2fw7In5RhB6epJPBi2LauDdFsj?=
 =?us-ascii?Q?6GgnIFbFpbM++f4ynToAmea2q979AGqXJqBZonjUpFH3JUaX7OC1GbhFLom4?=
 =?us-ascii?Q?1gOngYxXF/6rFo2MdltqhZ0HQ4aj++x28x/BOXZ1fsqnurfOOBVl87h1fQ03?=
 =?us-ascii?Q?tp5Y5rEzZ/YeRAD8HCJKKyAtm4c+EV013nx8l2yVJxdDgVq8mx7OKUIVbJxJ?=
 =?us-ascii?Q?KHIxxhJUrYvAAmUvsCrVUkSTKskNi2aM4T97p8VgbMam/a5IMCuABYAkIUbi?=
 =?us-ascii?Q?0oOQPacgkWKlakKKhrZezpPdPhbecg4CeaLravKyhRivO2IcdS0HLvRQoVpv?=
 =?us-ascii?Q?nadXYMN6CjBj9bhmAtrfFApwxBuWyUyvKI5GUmNiuRXaemWk6/5ws4MFWBdn?=
 =?us-ascii?Q?oAzK5Cn3eOwssL8DAhRS7mB0PcRTckteQOUicogn9nXRQ5lBy4Vwr9EVk2uc?=
 =?us-ascii?Q?ulc+71FW90xXFSdA+sQgph4zu92X+zm9+z3mLTTQcFBAfA6+gRfs+3xRm9US?=
 =?us-ascii?Q?duiNbO8gMuWPv7c0lqOBF0vj0d0RME7uOcnzcZIudTkhaZHdkdFBFPZjZJbO?=
 =?us-ascii?Q?lCDlOd4/xMnPKPbShC/j3byv2f7LVBpOENDMRVzpD/VwFkjgJGDfl3bWfQNj?=
 =?us-ascii?Q?RNRd8FEsqKstmnnsmDpnYdaTKE5QPnk3fbEcg8zB6I+j3ORs5szyR4WwBrV+?=
 =?us-ascii?Q?NoKG7nJd8cLImfzoNoTXwcijmHw81OheHPRFt2MEfvPxnuDbxBXzGRHVIMmh?=
 =?us-ascii?Q?8pJI3KWFFLH8+bbtWZUBrMEuAdDTm/H9/cJvs3IpMAEz1hcjuWBjGZN4pIU7?=
 =?us-ascii?Q?X9ccRr6Ooedg9QYCot0eyq/ozM758f+yFv0OkySXfd1vz9Qz40PzJOVet6J4?=
 =?us-ascii?Q?KDybqv3trgoyAo9ZHNO0l8ZdpZZ3rqbJnBk9G/4MdE43to2jcMe0+YI63BrE?=
 =?us-ascii?Q?LbkK3C26bJwZ33ZeYn5UybZZF5nkwLgGZrp7xmwACVmXIo8t2HD0zfenrEHt?=
 =?us-ascii?Q?Rca2CHx9U8IOBAk9TxopgH1/lJsPCUbqFQHg8bIYlqCW4BiHvCl7D+/KQoeK?=
 =?us-ascii?Q?GZctSrAOSMnUfAwBL5QYXtce737DTjCVOnXeNAY8+FxQLDmHdxSimBajIYFF?=
 =?us-ascii?Q?seX5qtlPlqoiPa1b3gJup8HfZxx8aKYddGFUL3tRy8xkHhPxsCnc0+ScH/jb?=
 =?us-ascii?Q?iWmOnDU+JXT7n6YWxZfXhxCwKq0M36aCUfQmPWEiepSawldWWErh9ZpRjNso?=
 =?us-ascii?Q?NUdQpN18wix4HKh0O56+/KtiogfpFLdOEYQOK7gYhKP/+oOGDnQoolC1kzKk?=
 =?us-ascii?Q?lRsY8OusNBBAIttz0zk83qTwDfI9X6a56qMcNb71gAC8vMjf2TRnYEg0eZD9?=
 =?us-ascii?Q?Nzai/vLFMVdy9kd8TS73N96PRUeNoFZZ7esMAyYdBfmUM3kPwAg+dtT4boqa?=
 =?us-ascii?Q?kvdR4dMVlp/z0pEhyoL1pe9YDXS7JGbMTl1IosgLHqe0pVDK57NK9QBj4GoA?=
 =?us-ascii?Q?3qNjsMvAmvnxk97NqdYfoDmWUX8QASa6SKAl2txfRxJEkldcqsJEGr09YgIf?=
 =?us-ascii?Q?laIzio7PrLONgCuftyJk/QSlGflIMsRyas0MyT6dfGoG2+WMqZ/ilTYb3Ytt?=
 =?us-ascii?Q?nRuzXOfPyC8n1JM56RjlV+GZPVwmzpZMwp3q6hTrp/ugdCUGkyF01NeSfBrg?=
 =?us-ascii?Q?X+ptJYKrcD+gdYsO1qhb6URs2V/fsx7pIAaCX26rAlh/u7AVxrlToAnbZ+YW?=
 =?us-ascii?Q?x8TpYw0G779duDQ2PncRUzLXkSlAdLs=3D?=
X-OriginatorOrg: quantatw.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d68b442-f42f-44c3-d954-08da17ef123b
X-MS-Exchange-CrossTenant-AuthSource: HK0PR04MB3282.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 17:01:19.8599
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 179b0327-07fc-4973-ac73-8de7313561b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fERIHk685oUFV6L/4s57XuV7VNUN2BswhLZ2QVfVRtrQC4GhwPwDO2YG8kDxNUZv7+JtgfL4FCzt44BGYtvcgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR04MB5204
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series add Clause 45 support for Aspeed MDIO driver, and
separate c22 and c45 implementation into different functions.


LINK: [v1] https://lore.kernel.org/all/20220329161949.19762-1-potin.lai@quantatw.com/

Changes v1 --> v2:
 - add C45 to probe_capabilities
 - break one patch into 3 small patches

Potin Lai (3):
  net: mdio: aspeed: move reg accessing part into separate functions
  net: mdio: aspeed: Introduce read write function for c22 and c45
  net: mdio: aspeed: Add c45 support

 drivers/net/mdio/mdio-aspeed.c | 123 ++++++++++++++++++++++++---------
 1 file changed, 89 insertions(+), 34 deletions(-)

-- 
2.17.1

