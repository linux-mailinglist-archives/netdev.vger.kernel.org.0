Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB5E4BC11A
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 21:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239253AbiBRUWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 15:22:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238139AbiBRUWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 15:22:42 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70084.outbound.protection.outlook.com [40.107.7.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D892C4AE18
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 12:22:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jdaNjtEP03koMegLwEsBOOZFU5iMBkWkWup/L0F4HS40wc9J6G8rd1oiqNK9Hhh5EVw/A4cu1DzHHCKYdVQh6FvF6MwFd22b9FLWNpec9GC/gFI0NUE4oOdwueapykZ0HyOyKZ2sghA+ZTgRJkEollw5z3zdGrUD0hC5jUlQh2uhrMG5uTheLjXucXPF5kH1ztSRBiKaCYHagaRzIz+sMryH7CUINiGsr5m2lhjM5ryMce6oyTHsFmTmFso2DLCM8nefy6rvBaIVBy0wh9A8tP/+C3ocYai+AzrvZM5k7wiuxdmAy2k9oGykkDDY3ERVIzVGgi9ORRIRfFToyVgaJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XuL6lQmxL/q92P47YWUHrhu3gx0GG56j7VJdGU3luS8=;
 b=R8dpw4g9MqOE349Ob/ozMgaCY92QdD7k/5uhbLHYIaWjY2u07BO/bf/p1Ungxfbz+KUJYU0pij9YSzqwTCH+r5BgQsgMk2XNR8r7K+2IqOt+frH+VbaiQAK8W9wg9BjT1MXGHIIIf9ZNgN8hxbETpA9Nrc83H886X8AO/zC47YgyaQW5fA6+Pcj1q1JzBhvpVQ8oa2/LPekA0FeD77C3uc1OXZ/RU7ez1qIHAOWaSYoRViUSMNNt6zlBKIda8Ogq/1IQQm9bidmXFFsVTHlSDWAWMTNGF/kicGPXdIMJ95T+DlQSHPAKaiiR6LvolZ8CXN1TZ3ZZWig+dwqb7SeZfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XuL6lQmxL/q92P47YWUHrhu3gx0GG56j7VJdGU3luS8=;
 b=Aww3sAe6JLv5CdGuhS+vN9wMNl48imhJVXLMo/D1UGHZ4wLwQOzBY85zb0JxQBHTcvq0bTZmoPUEi61d1RL410DyFZVimfwzXIh0JpcjARVAXVW0e76CdSOmaYhT/f+LBVrTyAhfTrCE+8wmGKWyMw7k4YhnBfqFnqU/Nchoc2A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5903.eurprd04.prod.outlook.com (2603:10a6:803:e0::10)
 by DB7PR04MB4378.eurprd04.prod.outlook.com (2603:10a6:5:30::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Fri, 18 Feb
 2022 20:22:21 +0000
Received: from VI1PR04MB5903.eurprd04.prod.outlook.com
 ([fe80::18c5:5edc:a2c2:4e45]) by VI1PR04MB5903.eurprd04.prod.outlook.com
 ([fe80::18c5:5edc:a2c2:4e45%6]) with mapi id 15.20.4995.022; Fri, 18 Feb 2022
 20:22:20 +0000
From:   Radu Bulie <radu-andrei.bulie@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, ioana.ciornei@nxp.com, yangbo.lu@nxp.com,
        richardcochran@gmail.com, Radu Bulie <radu-andrei.bulie@nxp.com>
Subject: [PATCH net-next v3 0/2] Provide direct access to 1588 one step register
Date:   Fri, 18 Feb 2022 22:21:59 +0200
Message-Id: <20220218202201.11111-1-radu-andrei.bulie@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0159.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::26) To VI1PR04MB5903.eurprd04.prod.outlook.com
 (2603:10a6:803:e0::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 73c12a18-9618-4d6f-2439-08d9f31c5d6e
X-MS-TrafficTypeDiagnostic: DB7PR04MB4378:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB43783E44A152D11B2D44C32FB0379@DB7PR04MB4378.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4IVwyveBgn+nmk/uLr6dfrXtcAVJ8zSCWI58kFtbQ7TIgQVxYgkgtzx96czAMhL4aZhWF/PhnrlLYWfIj0kWf8pFhczNRp1z73JA0/fA8DLsYTTB0aVps2RLSmY5/lBIRHLEtYR6p6pwg5AZBvu+pXAkig4ogh8w0q1sQFYndSKes8ycHuI6alzFAdgCU+EysDtntz+yDcOuNTyQtax7SL63TXtS5H/+SaEnOp9QtsiHOvT7HYAEN0HjIZbH1Nf9as/5LyPATuFFNDUWibqJaQDQEtYWkosP7Tw7o6EDty/TOOrmx3Vv8GVe6spmDzsWyAzM9RZxho6BNYi+AJHkT1Eb8s+61wwcDVW4qahS/qesKBIeVzli5Uv0D38w20luyzdGViZ89thfiSDkKThvlmMu4ShD1Ni+YMlcgGF3lwDQ8JqmEJhGhnKNMTFP2yJNnIzjUQf7bpLt+wLKeSUnbgtf9FgoXYzoB4JAndUDcgvWyR3EZ8RW3Ce4RTGF/10vUQlYqJXJ4Jik7nYTcUCCvQstI381FuMO3ND9DFsQ4e6fQkWM66GwITXm/W4EpkrB0j5l+xFEH6qjSwGb717A1CXoDhb+XKvH0t2rHI/Hj+PuAvOkriZubYkNnlYiquvUmSzMM+eOTNwfMxUHjNXsYMVlsev0EqeP3G2k75Ai82cHJJIQ93WK7fHLq0RdNofZCev/Z6hPZ95uurYpyPdM/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5903.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6512007)(8676002)(508600001)(66946007)(186003)(6506007)(66476007)(5660300002)(4326008)(2906002)(86362001)(66556008)(36756003)(1076003)(316002)(2616005)(26005)(83380400001)(6486002)(38100700002)(52116002)(6666004)(8936002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bRo6NWp8v9nMneuBwcEG42HTJwrVT0V3wrb8C8UFDu4BVOJYEeEh3WOqfcva?=
 =?us-ascii?Q?mznIqPIm+LB9MA2owfZkmUNU3tRDsssVPh3bk0217b+ErEVb0NXsA6WwaZeL?=
 =?us-ascii?Q?IJIyvGRBxFibi5IHa9WMomNhA9gk317vXulC3r4s5qW26RjX81Ry73Om+e8g?=
 =?us-ascii?Q?6GXthyAjjo9vBDJzy97I8oZkdy+KLqOh6oZMqRoyDGcdXQ4QbHCWM4sjOObI?=
 =?us-ascii?Q?U08YcWKcIu9VljHc86Poc18cTeXqpzwW5SG2urMvheohSQohO1NwSz+pP1g7?=
 =?us-ascii?Q?8pmODFkYKtzD/btXZcDz0mi4ZOClzTct1vjAo59Hlmnpca2Ix7KRVE/1WeAF?=
 =?us-ascii?Q?Q8oOz/2tzyEJVzH/0jJAAvDQN7J4vgQYvu9wqMykllBua65tpLimgL6pLRmp?=
 =?us-ascii?Q?9QG/zNaN4hcmUEw7SZBmMTJCjg/wFbr9hRHika96ofpoTl1yQFnWAoA0OMMN?=
 =?us-ascii?Q?+bqpwEGElSUh0QlRKh8C1yppYTx8F3/28IlLJNnsJ5QmIzb6mBwWC3+H6ZyN?=
 =?us-ascii?Q?HV9Ct/nMBDw+acuNx6qAbezlk4Jt+rH+t0WB+MMHOFhZ6CY0OIQYcDPErO0a?=
 =?us-ascii?Q?5CtyN+NLpXHxdh503Cs1vom1LxuR1yiRotHM9qGdL3WlY0V1QsdVXZGJCQeC?=
 =?us-ascii?Q?Kzt2AtllMZqElif07hvqxyz5ha31yyQ8NZjo1f8uFzMmdH0iotfi/t1VtvsF?=
 =?us-ascii?Q?V9DZVcZKp+yQ6Nxu1ivd1yi4yvnsyzvBz5YCpiiHpM3LIIAo0l4BnJoZcat4?=
 =?us-ascii?Q?TMy5wAbjg7rqW95tYCgHBH1CU3Dr5Bd0RVX7e2W9v1d5Vdww8zOUcS2m0lwc?=
 =?us-ascii?Q?bD0usi4kMy68JKu+NNf28zFZ63mZTs5ZbuB9DHVfi2mYgscBqasDKjOawfXG?=
 =?us-ascii?Q?xdDOO4PD6W3z3mqM9fD0hOQYG9hgNPFwLjX8mj+Xs3KJaJ+cZMck+IiHCSUo?=
 =?us-ascii?Q?uS9DMNoAt00C8W5pQm3OPNcptn6MNrEyx8SHftGLVpMQLuXqjEcQylxmgs1k?=
 =?us-ascii?Q?VFGiLzdc9NyBi/DDcIp2bXyHUjLCdlXbGCYItq19cEKOF5/Gdk1/E2CWTLLJ?=
 =?us-ascii?Q?jt8Z0/JOtGzaQMKVhIUJfjDvl7nhThuGTqfWg3QTM3OwYjlW8LPFB9fpY5mM?=
 =?us-ascii?Q?8lGCH4Cr62LH29TUz3X6XCbZl32tnqHswv7mYAKA0onZa6zrkhdhhe+DiRDJ?=
 =?us-ascii?Q?hqe2tgzpzmY3JAV7r+ANgjZ4AxKqJnAOgNm+6OAk8WQnz6Ku15843A8kmOtv?=
 =?us-ascii?Q?bOIfsf4IWZgWn2J+DRTqYM28YxfwoPUUATB46irG2GwkXZg0eLUSUbazweSm?=
 =?us-ascii?Q?kQnFiqF3o/GXklX+XmQye2V/7QG3oMkUWQvBerqNiviJ+p35xUHEtdf8IQx3?=
 =?us-ascii?Q?IQJU2SXlTBIXTLCF6qAGXWpFWxVmHag156DAxKU0hGmn/uAtNlou3DC7TdK6?=
 =?us-ascii?Q?zfTvvQILPTdGlll84APgh7kG8s9y0g/VaU8ntaNl0Qyni4FJFHDedhxWn0NS?=
 =?us-ascii?Q?b16BDUJDTUourrupaM6qLdQIgXgyCqbB1Luz7uu7U8myCsFcTdV7yKtdOWvM?=
 =?us-ascii?Q?QV10pE97aJlHiPYdhYISKNPmdvRLQoAlCxDbstfEnFXyst3WruqwKCCQv8pa?=
 =?us-ascii?Q?Ol39Z7Nrb+Anyxs84E65kRTBcza00gR7NiPud8m3YU+fS7Na9zfrgwAmjrbc?=
 =?us-ascii?Q?an79Vw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73c12a18-9618-4d6f-2439-08d9f31c5d6e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5903.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2022 20:22:20.3643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5SmPFEPaUplwL5vtrW7QXW33a5WBm4s80nlZ+o9SwmOsAEpm3wO0yyzqSk7rN+okS5EsOTL2jOAgqLYykLXgxthxeyW96DsTG4sv4UDCoZQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4378
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DPAA2 MAC supports 1588 one step timestamping.
If this option is enabled then for each transmitted PTP event packet,
the 1588 SINGLE_STEP register is accessed to modify the following fields:

-offset of the correction field inside the PTP packet
-UDP checksum update bit,  in case the PTP event packet has
 UDP encapsulation

These values can change any time, because there may be multiple
PTP clients connected, that receive various 1588 frame types:
- L2 only frame
- UDP / Ipv4
- UDP / Ipv6
- other

The current implementation uses dpni_set_single_step_cfg to update the
SINLGE_STEP register.
Using an MC command  on the Tx datapath for each transmitted 1588 message
introduces high delays, leading to low throughput and consequently to a
small number of supported PTP clients. Besides these, the nanosecond
correction field from the PTP packet will contain the high delay from the
driver which together with the originTimestamp will render timestamp
values that are unacceptable in a GM clock implementation.

This patch series replaces the dpni_set_single_step_cfg function call from
the Tx datapath for 1588 messages (when one step timestamping is enabled) 
with a callback that either implements direct access to the SINGLE_STEP
register, eliminating the overhead caused by the MC command that will need
to be dispatched by the MC firmware through the MC command portal
interface or falls back to the dpni_set_single_step_cfg in case the MC
version does not have support for returning the single step register
base address.

In other words all the delay introduced by dpni_set_single_step_cfg
function will be eliminated (if MC version has support for returning the
base address of the single step register), improving the egress driver
performance for PTP packets when single step timestamping is enabled.

The first patch adds a new attribute that contains the base address of
the SINGLE_STEP register. It will be used to directly update the register
on the Tx datapath.

The second patch updates the driver such that the SINGLE_STEP
register is either accessed directly if MC version >= 10.32 or is
accessed through dpni_set_single_step_cfg command when 1588 messages
are transmitted.

Changes in v2:
 - move global function pointer into the driver's private structure in 2/2
 - move repetitive code outside the body of the callback functions  in 2/2
 - update function dpaa2_ptp_onestep_reg_update_method  and remove goto 
   statement from non error path in 2/2	

Changes in v3:
 - remove static storage class specifier from within the structure in 2/2
 
Radu Bulie (2):
  dpaa2-eth: Update dpni_get_single_step_cfg command
  dpaa2-eth: Provide direct access to 1588 one step register

 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 96 +++++++++++++++++--
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  | 12 ++-
 .../net/ethernet/freescale/dpaa2/dpni-cmd.h   |  6 +-
 drivers/net/ethernet/freescale/dpaa2/dpni.c   |  2 +
 drivers/net/ethernet/freescale/dpaa2/dpni.h   |  6 ++
 5 files changed, 110 insertions(+), 12 deletions(-)

-- 
2.17.1

