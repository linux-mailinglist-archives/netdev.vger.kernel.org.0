Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2702061F645
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 15:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbiKGOix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 09:38:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232363AbiKGOir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 09:38:47 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80087.outbound.protection.outlook.com [40.107.8.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0633A469;
        Mon,  7 Nov 2022 06:38:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YN9wmr8f8Yq08deXaQAMcSO2gu6D8tvM0EKgeJPEm434onptuONQxdoXkClLIY2JnGFeRw/M/2rQMVmejkU2g5WhQyUJxC5Tr8yHq/8Lur6GneoXkomk329x79H/ZaVJeKjGgIcW1pkR7jNOAqJvzZpFlNkiBa8ks5Nlsc1VCwPEk2pFuoFBH3emPyq0XjO77ShxyAphTnsGzpTNnZqF5SrLEek9sY2GkVUZWhFe5pssdjXgUO8eH30AD+v45lztMak+VYE84Sx1AukbqKjrkovG9oDJeQyIG5YUva+eFUSchBiLsju/OfuDap72UDnGqM2JMPp244RHEdRq+5n1Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+DMi05oM+ZJ69choAeJAxEp8II5Afox17XDpjRIM1ts=;
 b=ICjrVMtNrzioFpIjuDBhCN+O+G6Wh0TpP55cxF3mgfkElleiRI/kg1j4749Gk7F9cr07+Ywtup++BqhETKaEJyKLTM81P5Z+jJQPEo5KDQewhgNZBzfBFcRHOrTqEiVPT5v99EOlyvV81fv5DPajKbl7HyKOT2HZbe5udylqOmJC4iKuWPsLIc/cYOsa8wS8DCts5SZWloeQ0BWz5rGLOSgA+cjRUfy6q8x2scp8GI4y/RS0pmYGCVU6n54EtFDL9YYwiy4hTcxmyy6gLL4lOqdAjp3twOTU0VnFgMWbbqw5kU+zL6g7HVli52wHENNItrsRvVt5ygtFEuITdV3Aig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+DMi05oM+ZJ69choAeJAxEp8II5Afox17XDpjRIM1ts=;
 b=PHkTXBT31IPSB2zXyIbmF8+AjRPF/XkN2QQcRJDlFfK8nrBw5tzqRMbPa5BwLVSoU8BPQjYuIjKogg8dxf4gZ2yyZM3Qo8l0E5DzE7En8KpJZz1ryrifjJ+v9tAggy0BeqGkPMn7RpVdbVDm8nGzqgU4UtCycSd7Qi1zirEgdP0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by AS8PR04MB8385.eurprd04.prod.outlook.com (2603:10a6:20b:3f3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.20; Mon, 7 Nov
 2022 14:38:44 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::b1ab:dd4f:9237:d9f8]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::b1ab:dd4f:9237:d9f8%3]) with mapi id 15.20.5791.026; Mon, 7 Nov 2022
 14:38:44 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        imx@lists.linux.dev, Shenwei Wang <shenwei.wang@nxp.com>
Subject: [PATCH 0/2] optimization and statistics
Date:   Mon,  7 Nov 2022 08:38:23 -0600
Message-Id: <20221107143825.3368602-1-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0239.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::34) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|AS8PR04MB8385:EE_
X-MS-Office365-Filtering-Correlation-Id: 501a3226-2591-4b0f-af41-08dac0cdc5a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TSC4SCX6sxROVKohOwbiYa3HSvvj9hGS07lDL4u5EykjheK6SATItosIbzGb+IdRCfF9N6hfwCqm+2+TTZtWgXmOqgX/jE2Y7bOjFCI9dDb3VeBdqsRf+APaVqxpKs2d6DVQpIx9rfnTD/Oc/7q+s5NPl0k/4dAP8mOV9hM+QE8i7diMlUBl/KLO5SVZCG8lstMRn0kepCS8Zt4D9RWAHWEfM/zZLsnaGtB9vY3+MxW2M4IocSB1/5C5B6BjfHP1NM+wQAvkm5EwKJUkBseKgoMo0/naxYUGmn6QIS8tXpZ/UUvBK9v0kIfDnKgL6S70QcRRAOm7zWCzM6GsXHiOOAIzsE8LCLGgta/ibpGrpInLgv1gA2VHxD1zXj+Qs1Y2+1wzqVXAt/Tlrb7FwVmR+aF3S52e8sTKR1WCUxNopJv8y/W2Oed+TXf6/XT/gfOPxl+z73QLM8yFvthN71oNummH/HP8Ns9tos9nUtVie8Rbplo+Ewz6jbpO1rTUp6cfSTj5Zd1g72AEzfjxHHR7lyTxw4cDKD+QNmnQ8S+6hjbRPxIUC9FMKfI6Ut69UBoPK1cldvq5YEY8xAuOOJFe/Wtonpu1nE9DvTsFYe8PcX/3Q9c51VUUmJzdT5CF44QeScuZ8gt2wRk5TtqJlLmoX68uOs/6GPnujZ6eLoRCEhxyiGcGGxPQ9Q+hP34VbpVpNHcM9+lP3xEBMS/K035J/5cW0w+U6edsVbFrWmujFda+C6lhE/ufZk9N2Dmy62l3mypFma8mJsSCVXfhfcpTu7vfC2uutWF4GOdLk7cS59Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(376002)(366004)(396003)(39860400002)(451199015)(2906002)(66556008)(66476007)(8676002)(4326008)(66946007)(83380400001)(55236004)(52116002)(6666004)(6506007)(966005)(478600001)(86362001)(6486002)(2616005)(1076003)(186003)(316002)(6512007)(26005)(110136005)(36756003)(54906003)(5660300002)(8936002)(7416002)(38350700002)(38100700002)(4744005)(41300700001)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CoLR29I8VFz/jSwGSXtK0LAIzKq4imHdZN9tDX3UTzUOL/Nh8YqOh0YOrzPP?=
 =?us-ascii?Q?XxkY7uz0TZGtVxNWzStckCJtmcXfp6BwXnE5lHaNusE/Cd72FmSFzgArAsSx?=
 =?us-ascii?Q?eGknSh17g6hrRXEAZzQjSxxWQ63zTih7vlmnajQnmHDQVyRG+px9nOo17qIp?=
 =?us-ascii?Q?4P7xhq8+dBKZggO+0hb0KtHD7pL5/Y8uk+JzZGajbaYfbi95vzEdKbCX6q0k?=
 =?us-ascii?Q?VUDpCzkIfo3yQpzdSFoxO9uVai59we1xyCJD5KlN8oDpeKBmxO0w3ZNenzS3?=
 =?us-ascii?Q?c9y8AWhuQLyrDJx9rIsWE2heQZFYUdSSK1clIRg+PkFsgGbEj8oanXdCABnS?=
 =?us-ascii?Q?XA1St0Qx/OHp+gfdkYrPzSbY8Doiw7kaaGMkWR2obj4vnHapm3YSPxmXBVqS?=
 =?us-ascii?Q?T/JUdeDvL2oFYjtxuYk6paxKfYbrv4+XEAlgnOfiMRDZClAXV3aLDeWCJTmM?=
 =?us-ascii?Q?/pl6i8SFoxsXACPT/+pFj7dvVExluSe6FaTkJtLo9BT53fswvChY1bjSxBqH?=
 =?us-ascii?Q?XdP3Bu/WFbDFALvyRwhNrgH/fYsxIp5CLJfZ48V0SzW4Xi4+ndA/sk9W0nTx?=
 =?us-ascii?Q?UvLzHgU4oqLwh1xBmpPm830AJiSpS+9V9JtOZDs2Rksp8LIo6ztabYGlJrPl?=
 =?us-ascii?Q?Mp30pB2XymWG+peBvs7r/6eKxQ5a2LX6tYu+a1vlUOdtrdmf8DRcqunNyvnx?=
 =?us-ascii?Q?QxjryRajfSSi4VpoAfn6LiY6bEJKFE475tYdSMa4MkMatqUoPN2QiHbyEEKo?=
 =?us-ascii?Q?+kAq5f7clnZfQeljc3q9jRE79NThQIivi0qR6bD7Kkx0oDsn3jk/NbSzM3sp?=
 =?us-ascii?Q?xjBZ6GOKt2cwu1TgGWQBRltQ6sgo1Q23ZHEGTPIu0pIFPjRbxOH0U6tUa6o6?=
 =?us-ascii?Q?VO4N0azApc/0OaQhcQnVcvr37ql8qfvAG0hBH6hdPqTbfS+S7IGWD8feZqTg?=
 =?us-ascii?Q?tGVo+mw5PuSrPRlPQZN3gG7zmu6VkFy4GiW2BvDS+qrJFduKuLfKpILbOjyQ?=
 =?us-ascii?Q?mR0AOY7IW/bJ9gmZga/g2PctYSMSc/8P/Cku39Rh0d6qaiWIhTj2MeCxwh0u?=
 =?us-ascii?Q?rjAlrz+V+j3Vqs2+GYG+yAjx4vzmUaF8dQNmbsYmclOUTVd5dH3F8O2ke83y?=
 =?us-ascii?Q?GDQahmeRnZu5yE1Et63wLjGqBYCZ8m5sdUuNAs/AEWB5f1p22sJE8l5R/R3R?=
 =?us-ascii?Q?5aXvBQ9xHXQpNXqirYDcH3qc166v6y1UJa1BnZXnaKXCUUWybP/U12vV6VzM?=
 =?us-ascii?Q?nV+fJyw9zrpPTTph23b4zX1W1wQIs58yVyeUPIeDC6UAUmxrmf+xkFERNwOp?=
 =?us-ascii?Q?fqa4R1lgCaCNaPiQuOee2ixoZHpWZe7NLpAvqgITWlWwH0E3WiLpvuPuh3sN?=
 =?us-ascii?Q?IcHmjic9cIKfoMVJOuyqeQpYHBBwmMEHs2jgM/9jAD83R4wVdFcDbtuQqZbA?=
 =?us-ascii?Q?5Mh7OcZW7eW3YUWSFwQUq2sIz597TlvHhuxjmPBwplwjWbsZwAneE8juhkhb?=
 =?us-ascii?Q?ub7l8Le/0rZ05lN95ZaNSOHv4iAIBnp81UViWlTNwc0xrUv3Jq37yBpmeFl8?=
 =?us-ascii?Q?gKDWWSqTbVTvhLj4EzMbc3V0Q+yQTBT47OPIYdo8?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 501a3226-2591-4b0f-af41-08dac0cdc5a9
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 14:38:44.5125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vrojEz9ccSewb6H/Y5MRQRYzj3MxihNh5XQLC+UowWnvvZRFXp4t4MUz6ZQ0o64VYggztYz1xH4WRzAO4++y7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8385
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the patch to add XDP statistics is based on the previous optimization
patch, I've put the two patches together. The link to the optimization
is the following:

https://lore.kernel.org/imx/20221104024754.2756412-1-shenwei.wang@nxp.com/


Shenwei Wang (2):
  net: fec: simplify the code logic of quirks
  net: fec: add xdp and page pool statistics

 drivers/net/ethernet/freescale/fec.h      |  12 +++
 drivers/net/ethernet/freescale/fec_main.c | 119 ++++++++++++++++++----
 2 files changed, 109 insertions(+), 22 deletions(-)

--
2.34.1

