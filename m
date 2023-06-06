Return-Path: <netdev+bounces-8337-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8472F723C34
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 10:51:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C8A8C281553
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 08:51:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 017DD11C94;
	Tue,  6 Jun 2023 08:51:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4369111AB
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 08:51:32 +0000 (UTC)
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2078.outbound.protection.outlook.com [40.107.104.78])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C29D1EA;
	Tue,  6 Jun 2023 01:51:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VGIVZ+F0jrmvToCFCi3sA/Hj9i+jvlMqEqr9ctpfc/84JYizV9loG2JAh1gvwyv/vgiKym4c4D5Ly38846hwsIcigoOdpdWbj3Ti5iNL/x2aXCaqqDnWBmYxpgeLUySZHjLFNiPTLPDnZh1DNK064A3t5sd86ediaUW74iPmpIN08/W5wiE9uKpKWfQ15AdDFctaEjNA83XmsXbqZf43oztAwSyFCv3g0lndVLCPa1h72TLwPJiP2oxLFn8veBcmyUeZNo+n6y0PEhWTwc+DnHGI2byBGZsmvOJQUEwjIuAfjJ/wvqGxdQijhZPS2JrofjaAhNnHaPRSoNerQpsV0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2MjWH8dDg3/BMU9sKD4pi5CMASYFSCbL0cUBOJmKobM=;
 b=XhHVs6KZcSIq0CbXZw/AQNMlsz8jmz+giyv0g+aK4/XJ9gFIfMx63jjrhYiv2eGJmndsByleUuxREz0SggDijwJIbE9WSK8YteIm1NsAuuNMS4scJVnI09xRZYI4dsVjdY36/YdfmkO9r0eYuGzO0aJh/TnD4YzFB1bncYqpAFql1HMn5ZlWcD7Vr8gHniUFWA3KgYI9RQco6Uz1Oh502Gfud+QS8FF2OGKGrUtheHE2HemlZt8wcGAMjVDCuQ+wPD2paQZL3UFvoS/zF0yC8uEJyOI+2sNsdRASG0vBk4HuLrgmtZUP0GN87x/1SYpVpWF+w69KnsY2krvIqltqTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2MjWH8dDg3/BMU9sKD4pi5CMASYFSCbL0cUBOJmKobM=;
 b=KLo3Yvu2NsqrFzrwf1zFs58qdjltyuXJusmD1M8MjfugBlypSJL0nEotPPMYDo8LaUjfU65yJP++BFuEa9pIjUqra6VXZrEKzd/RQ0kEVPqdNSB/Y0CwrWw2NHjIdV+XdEVsRDSp4Fxt3mk44VWOhIajYErswHDF2Pdpz7mqsII=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM5PR04MB3139.eurprd04.prod.outlook.com (2603:10a6:206:8::20)
 by AM9PR04MB7506.eurprd04.prod.outlook.com (2603:10a6:20b:281::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 08:51:26 +0000
Received: from AM5PR04MB3139.eurprd04.prod.outlook.com
 ([fe80::6ceb:ec9:49eb:a58c]) by AM5PR04MB3139.eurprd04.prod.outlook.com
 ([fe80::6ceb:ec9:49eb:a58c%2]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 08:51:26 +0000
From: wei.fang@nxp.com
To: claudiu.manoil@nxp.com,
	vladimir.oltean@nxp.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH net] net: enetc: correct the indexes of highest and 2nd highest TCs
Date: Tue,  6 Jun 2023 16:46:18 +0800
Message-Id: <20230606084618.1126471-1-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0080.apcprd02.prod.outlook.com
 (2603:1096:4:90::20) To AM5PR04MB3139.eurprd04.prod.outlook.com
 (2603:10a6:206:8::20)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM5PR04MB3139:EE_|AM9PR04MB7506:EE_
X-MS-Office365-Filtering-Correlation-Id: c5c15ccf-945c-497f-fa42-08db666b3653
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	0mDaFtHmP9rh1S5NjQJTMdCNeNP2nc2eckqwgWHYQIlCpFsN0VTQxr0stYXR6bWJwOczzdNtDpLQh+M0hznBMZT4wFFWyJ7PDxM7zuC14Z21PMiyBUgxrZNCDHV2VKlMRFXlIL3JnKytdX6r79QpJ81pi4F+rPGZrWrevzWmlbg6Vh3LLsgdu/YDCkK5Pt+FWBZjgtNJ52t7X1cVxn0ELjV9MGWDIjsZAyLML0Yh4YIlWP4shW27LAxnUH3fhgv9GTPBuN3QEGjRxG5baNzruEqfupxDAx2kuVBQ5Hhsh6z2ME6h5ZrozYX9A3u9ngen0vtpGlNR4nZ9gRdGOZLMfvhaOdYh5J4sYfY7eVy0Eni8SQ/kMOMweDDzGGHmwfgIYNTLKNun3acPLJPLMIiuwqxv5Kz3UG8mHGl/W8+WCau5sZnQcsJdMI0CwDsAl8XZ41EbP0ftCewKsVRgacWCXb3M/aaK8yZZmjCqYIFBiR6PrNZwI2ZsfmyHzkFYj4wH6vbbEKu6YV32U5bGH8udyWdhiM3YOc0JCaOgMqMEPnodnpJUGNsmoiDmt63zh8hIqejy4eZw0L19q7fnNywhP6IjA/34rLg2J+ULGXH7fIe/LGhlclAofwwqfPCVpVNj
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3139.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(396003)(39860400002)(366004)(346002)(451199021)(36756003)(2906002)(86362001)(5660300002)(6486002)(6666004)(52116002)(83380400001)(6512007)(1076003)(26005)(6506007)(9686003)(478600001)(186003)(66946007)(66476007)(316002)(38100700002)(41300700001)(2616005)(38350700002)(4326008)(66556008)(8936002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dEdq0kYk+wewGE4I/vdCkuogJtL4Xu9bNQp+PISeTW7HZYPxpR8P+uc0pd5f?=
 =?us-ascii?Q?uOSYUashslBDCSKsS1sAn4LSgT93vc4c1pl4yEqc8pNJNl7uJbJmAqQLEFRg?=
 =?us-ascii?Q?HWyqhk7RWjfXi2+nGnP9M7TdP0F4HEc7BEmF3SrB96E/caE+8J221kGbz97f?=
 =?us-ascii?Q?DkqOMF9bZUzSHeIgQv9WzN57ghOi/zew8mZgIzJe5EObsbZdlC5uBD5NBStr?=
 =?us-ascii?Q?Ult9RrMDfGqLUCU86Is9FrJlJDTZCkVgjvdtbL6apEFZXGhA3wRHnacGx3RY?=
 =?us-ascii?Q?A+X35oK0RaAseOdsyKikVUqp6OQggmsEAdh11MwlWaha3tz0l3NfbbgWtPl9?=
 =?us-ascii?Q?5g8a2a9wVlVfiWdNDeTMdRUtj0HXWVh2BsTB17Qk/utN1069tCvkKpbMMtWh?=
 =?us-ascii?Q?8wk21IzVDLMT5nhsKv7M9kChJWsp10t/Jr1AlgOLYFSi/aw8R83rPtOHgXkN?=
 =?us-ascii?Q?kW0SaQ1R077miSgur/yqpC5bJqzP2+NbYZzgSreQF0ods8ls+zv7FdOHAYre?=
 =?us-ascii?Q?13jM0DhijYdHM/y+goEsIIue+rYmZc68OI9k8LapaAYKRv66FqFHitplrmE9?=
 =?us-ascii?Q?eMRkB7WkfqTfuxtl1Oh4aIQPNtS3APgG2v0tfW6pwqwwGen12VqdvN0lyTaM?=
 =?us-ascii?Q?kP6o5dyGYLtRcZHRyRHa7gxE5ATxRFbEV9HqcmU5/XbgFd3Pp7FNcYYpspWO?=
 =?us-ascii?Q?NPj2AZ1h502FdO/rc2tMiySsi/pQGwj6w94RTVfGdVZXZQkP5m0RULUbqBiO?=
 =?us-ascii?Q?Vn25ZiW5vic6u05dz4sILXQOURuYiTK0jgEn63/BXSSk8/VqjCS1aPakEdzI?=
 =?us-ascii?Q?2fq4oXRrRydYTfNc5Y4yqrPcLkaBtpLuvoiKYOTWgryphm6tmpFiFgIoPys3?=
 =?us-ascii?Q?s2x+N8jnfEkC0oYxRqlyvUEVLZDPjvXHxNTom8dyXIeU0Hxn+ZiawvKrNv37?=
 =?us-ascii?Q?7IthMgPW7FxY0emmDXSOmucYA9KIIn9c7x9CfZca0g1lskf4NlJ3wWzIUuWd?=
 =?us-ascii?Q?dUixrtWaS+eCBkFQUKHb6rV/d8FNPesPhLiy/eVcpO8B1KBygZHf72/gNMjQ?=
 =?us-ascii?Q?paPOcSfvZlpwJ1QrODNYVNDrkXnKRsR/XH/PgEg3VuW5L6F4NVBNcl9bIzYL?=
 =?us-ascii?Q?jDE7NoA6Dyq5Lp399vWKRWM3YQ7yotsAHMFGMLQcReojJpp9i0CnOU+gryUu?=
 =?us-ascii?Q?mo3p1gg2lbRXfFxo79BY8PHlOpXToEAJYwOiRA7EtrMTrfj6DxaGJMyw48hX?=
 =?us-ascii?Q?wwbglJgpKjZeJskCUbGRUvfNDrYBTNIfrLNK2A/ksnpQNUQE3Uz+9lODzX2u?=
 =?us-ascii?Q?0uLAsnQGOWfu31QkM2sWPkkvWNSgclbMLO+76OP2tgMcwVNaQvAk3rXg3v+j?=
 =?us-ascii?Q?pwXQ0uH/SEygdXi+QARqPSwLKYpYEmT1Au+uboRH1HuRiOdJ3aUm2vfcQIlM?=
 =?us-ascii?Q?UdS6HxZxsfA3TrojbVey3jAVm9eI4Y3AxgndeJWFsieiTyQ4kgHwclqb94+s?=
 =?us-ascii?Q?Sw3+Cbs63dINqRr5p7THmHF/dpafrAXb46EVNKx/09/tOHO4QChe8PRB9789?=
 =?us-ascii?Q?NRO2tmN7NLehc0Xw+MoUwm8OP+tdnJJpHLvR7m/x?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5c15ccf-945c-497f-fa42-08db666b3653
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3139.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 08:51:26.4831
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y9JzkeCSkk/VQnAyqhV4rvnEVdTqziF2UQ1vEo816NwyF0FyqCCjT0oJ8j5jep1Qb1w81lokVTvqZtY/aNWmTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7506
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Wei Fang <wei.fang@nxp.com>

For ENETC hardware, the TCs are numbered from 0 to N-1, where N
is the number of TCs. Numerically higher TC has higher priority.
It's obvious that the highest priority TC index should be N-1 and
the 2nd highest priority TC index should be N-2.
However, the previous logic uses netdev_get_prio_tc_map() to get
the indexes of highest priority and 2nd highest priority TCs, it
does not make sense and is incorrect. It may get wrong indexes of
the two TCs and make the CBS unconfigurable. e.g.
$ tc qdisc add dev eno0 parent root handle 100: mqprio num_tc 6 \
	map 0 0 1 1 2 3 4 5 queues 1@0 1@1 1@2 1@3 2@4 2@6 hw 1
$ tc qdisc replace dev eno0 parent 100:6 cbs idleslope 100000 \
	sendslope -900000 hicredit 12 locredit -113 offload 1
$ Error: Specified device failed to setup cbs hardware offload.
  ^^^^^

Fixes: c431047c4efe ("enetc: add support Credit Based Shaper(CBS) for hardware offload")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_qos.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 83c27bbbc6ed..126007ab70f6 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -181,8 +181,8 @@ int enetc_setup_tc_cbs(struct net_device *ndev, void *type_data)
 	int bw_sum = 0;
 	u8 bw;
 
-	prio_top = netdev_get_prio_tc_map(ndev, tc_nums - 1);
-	prio_next = netdev_get_prio_tc_map(ndev, tc_nums - 2);
+	prio_top = tc_nums - 1;
+	prio_next = tc_nums - 2;
 
 	/* Support highest prio and second prio tc in cbs mode */
 	if (tc != prio_top && tc != prio_next)
-- 
2.25.1


