Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD745AD7FE
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 19:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbiIERCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 13:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232276AbiIERCC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 13:02:02 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80051.outbound.protection.outlook.com [40.107.8.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B46BB5D110;
        Mon,  5 Sep 2022 10:02:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bzCLqjJHykriilQ6BJCdx9MJWplofu4XWUIL+K9H+lpJWO/1R1mBvyFJh417acuAYaDXSSAhNxuP7RdsbHidT2XAC97V5zQFQlIQKZQPlZ5oxVxbszRcOqhzauVJgYHWH5tcp3h6Iv4EwAVS8aeG6269UcoMHDjSLNZbjTGyXWc4Se8ZCQoRBG8H84zxvujdgtKqcT0E5eLH8CnM7/b01XhVot7Ue5kKZyuux4y64ACXIaIdItPvN53zFA5nxhhdUQJ+4iYBo+B9hQG/b/J2Heemi2rAMwzjVHpvT5YCLnwLtyOIuCtiVBqx0l9z/YEEQs11fctixIo8Zo/uhv1Zpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ea1nVomYwJi/Mvf4X4BvuEUXUgsqY6sqEjKQTusGHeg=;
 b=DtjxovzueKnuWzddSHR+FjwZpK2Nx+oD6chyvJuE1qCsZDgMOZ7B/AjMVCretIS82MR+xIdSd/NNGzQgkEi1pZCxGORnH4D1nMss1LWED7xRbw2JOOu6dE48lHe/ugTvuMIkoA0LgrM+QyQ6wJRTEXpTBvBSeXldBzPnZnrkU5UcyR2yYMpdN2Q1iYvIxtPugI1jU7bazGu2PJ6eTI9ND6d0gza3SOgJen+kvZ346NTf6+4GgZt4COxeO777MqYFAIA+1CkA7huEPgdaTKY1iUQEpm88dneWZRcNva025TNvjFyP6YpfmL7l7bQe75LaB+jrDo3HIEkkd0445DYj1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ea1nVomYwJi/Mvf4X4BvuEUXUgsqY6sqEjKQTusGHeg=;
 b=SWyY8ACxEvbzXiJf1ffbfO3pj93NNGsDRw5Fg4Gt2JzoEXlum34FYtVZXP2Ik3h9Uy26tObNptNpJ+/kQ45Lh1GNrzX3F+NfD+be0vY2LpJ46v3NBfuU3YroDZpH8eYtqcmu9IprUsasLtU9wz3hKMhxUuVTIjEkuEIND+y/lJ0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB4803.eurprd04.prod.outlook.com (2603:10a6:208:c7::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Mon, 5 Sep
 2022 17:01:57 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.017; Mon, 5 Sep 2022
 17:01:57 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net 0/3] Fixes for Felix DSA driver calculation of tc-taprio guard bands
Date:   Mon,  5 Sep 2022 20:01:22 +0300
Message-Id: <20220905170125.1269498-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0140.eurprd06.prod.outlook.com
 (2603:10a6:803:a0::33) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0b831919-6bf6-437f-b7f3-08da8f605741
X-MS-TrafficTypeDiagnostic: AM0PR04MB4803:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /Oj6mtiNAsuxvgzInXvOtzinxyBYaX/OdosAymvFGye24bJ4G0E7a6hOrIY8B74vhCSAqho9f3qpA4wHpXSA84vwykYTQ0zdgsvaSYeh6qcM2SHwCoo7M0okgwtr7JjsLzeOpw7u/y8kYx9NiqhzZG30k6Om7M7BLCuoi3xEtshR5IY52+gR2wvGQ0O1KmeeoSgC4TjNL5wJQq3WZeM0Ll33AjRzhxGqOAe730efuY8tHSvbjZ21w4pfFRBFJ/9X3kv5rqmwdiCykw40n7gg0yuhF7CwEWo+tKNYj3daMYQ8sE5OeEavxDFalOuFRfjWpWUlK2GVYotxY2hkWqranAwQ+rcbO3D58eRlHYW8BKk+MMYPBaxNEbZs+Xgh191zmb+p5oRvkHkgZDipVsudSVYqJiqQg7jaNGp12ffVXrCmNRs2bAXN7qmsm8iwTp7BHuDbllWFaE/NFX8d+Is0+KmXJ3kJ8WU8p+DVqi7La29WIvhVdTGCisqQzBKF48g+WVy+pdAPdfWmnTybOGlfkZbXOSc++V+TigP++UsCcsRJjVu2/5TGCbdCgFc0PnP5UrXcF11Bk2tHR70GqAvqSkZzK5MRiUzD0NrklZpbYnwKPaxzQ6goaMz3Mi6dyOIUmTVV1pSuwfAVDzF0RsjmQFIF0layrWImffbHup2t6tTapJ5yJTpBRrLhuvxOCpmonCy976IOroLMjjqlhkOseB8g8el092fZY0d5yhsjaV3zMUbZ7YggMA6fDjCwWeZvNkgl0H60SqZDYTXxTran5Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(346002)(396003)(376002)(136003)(186003)(6916009)(54906003)(1076003)(2616005)(83380400001)(316002)(8936002)(26005)(6486002)(2906002)(36756003)(6512007)(41300700001)(5660300002)(6506007)(52116002)(4326008)(8676002)(44832011)(38350700002)(478600001)(66946007)(38100700002)(86362001)(66476007)(6666004)(66556008)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g38RzObWiyCFSSqlfy0l6Uc7KjyQbiztAXKE3AaaLyinzkYkpKAgZyidfMr/?=
 =?us-ascii?Q?a+hi0nXF5GANDx+VmaWVXLdxlEnrohwSCtTgrZi9xPjqI9VwSPlDIsbXBwZj?=
 =?us-ascii?Q?XRfFYw5OVU28DjsZqpNYBjVuW2ue5t0RRfmmblh6qRcLQEnfqiYsjk2xn/B/?=
 =?us-ascii?Q?4PDFludMe0yXOn25rPRIKNHOkA8pNGfrBxq8kuQ/0Wpy6uHlxtGLC9yDb2FR?=
 =?us-ascii?Q?M/J53RIUQ7U4VFt2i0OogUxnwugaaMoiwxzeJhKcfELKm4eLPpIFxzXyQYdq?=
 =?us-ascii?Q?gZrv2gma3owidkOULaSPNlk+sYt0+MOyp55N3FCnCyfx0ql8F/4wKgANih4M?=
 =?us-ascii?Q?rjETLxSLuE3ktk5vMxe77Yd/6kH1s/cqLiL2gsFQK53hW3r5n8CQUTwpghhQ?=
 =?us-ascii?Q?w9pUFvfxadaXbYVuaByGnQDVGf6okifV4eea40mQnZXW4V/cys83YO7Bu/i5?=
 =?us-ascii?Q?4lbrc1VCy6MDrw1BiC8xlXmag3dAWX++8UNv/UnTO723A2GOd+2YKTV7sSoM?=
 =?us-ascii?Q?5bWb1D7eA+bkgQZI97642gjOM+oFEZe9h9WAd4FEdlLQWM4lHSP1hZfGTG1y?=
 =?us-ascii?Q?H4cT5w2tTdlBkDWMmaK1mbKW1jq9pdwhjzHsMdaR0L9gsIRRQNFCp4eKJkoQ?=
 =?us-ascii?Q?yRMVfkMd42UyFpx94iFs3BXfhntHccRb/E/tYgsZHSzD39VDz/KXzuqo35SU?=
 =?us-ascii?Q?uyQjRLJ8oTthxhfK6n9RGsb4lRU6HY5EAWo/Db7RSGAOqhxTIR6vb/ubVQiB?=
 =?us-ascii?Q?Mxn/3EO5Z4aQUZuNdl1r3lPVfI2nxXDTeaQoZqSwQykIN896OCSPzXXH4ZPw?=
 =?us-ascii?Q?TXHm2nBiwL3W7XmPRrpxOVBmPbCcDDfzCbV/EY+pxI4Uxoq1ps+8v4JM8jyv?=
 =?us-ascii?Q?ccEQQJFDsAWHUEYppRPMrZ7DLcUJQqx5Qjd2NSwq1xAPYR430jzwiCnmFaUM?=
 =?us-ascii?Q?ysu7K63Mluq9UgqMFgHHECEJ+52q9Q/2cWGKszz6GljQz4EmSipn8ZayKgju?=
 =?us-ascii?Q?Y5LSxWJWLNunNVgOsbsjeJOHEqdrGdhT7NmKMttxDOEMGRUvwQtM5LU7PT0L?=
 =?us-ascii?Q?38vRHUcdvBLf1jfigiFEv1vv/2Ku056n7V+9EnpR3c9SqgrDhVbrQAeeMORj?=
 =?us-ascii?Q?RmRyaESFJ5KBqgUJ5HR7H1roNpMHsq/vmM6+UGunZBqR1z+/L1YHVvG+nqPS?=
 =?us-ascii?Q?5fiOkAzCc5MjiawEPJHII8mgjvS/d7SnG83gz5ISgSA59YDLuCqNjKwQCsdn?=
 =?us-ascii?Q?XRjMun9WaCq318FGru0odxoMgmfwnD8Z8byh2a1s6pufFPUmxTng+6u7ayJM?=
 =?us-ascii?Q?eSjLW3e/bBM7J0ZeeVu+f1UGEKg2ix6vyzVidqYcHxecur9xGPt8Pwr+z0Pw?=
 =?us-ascii?Q?Mp1yR0GmqEKvgNe1TKHkAUbe42U2mkt0VUqSbQcfuNcWAK/LRYOXi2M74c2a?=
 =?us-ascii?Q?fy1OTRH20YjmNAo61H12hzxEmpA3J1NHLHQ+yd9UT6TEsqBQ91ZF+iSDCfG7?=
 =?us-ascii?Q?rWJ0HfWqnAJhbGffZpxm+UoqeWnNWd9Z/iKVNzEKbQSL1MRSdPHBfaOZen4T?=
 =?us-ascii?Q?o7Y27c8cBk70y0fE+SBa+3colLodiMJo+vnaNUqR4a/TLeSMYjVx9HGcjRAN?=
 =?us-ascii?Q?Jg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b831919-6bf6-437f-b7f3-08da8f605741
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2022 17:01:57.2090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IsEtpyRPAQk2PksyQu3/LQ98sxPdy/TAs19ngnQv3SwhLx1Q5CjLBk5MQzRKhoFoxzaJ3/wp2YKQmSticOsVoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4803
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes some bugs which are not quite new, but date from v5.13
when static guard bands were enabled by Michael Walle to prevent
tc-taprio overruns.

The investigation started when Xiaoliang asked privately what is the
expected max SDU for a traffic class when its minimum gate interval is
10 us. The answer, as it turns out, is not an L1 size of 1250 octets,
but 1245 octets, since otherwise, the switch will not consider frames
for egress scheduling, because the static guard band is exactly as large
as the time interval. The switch needs a minimum of 33 ns outside of the
guard band to consider a frame for scheduling, and the reduction of the
max SDU by 5 provides exactly for that.

The fix for that (patch 1/3) is relatively small, but during testing, it
became apparent that cut-through forwarding prevents oversized frame
dropping from working properly. This is solved through the larger patch
2/3. Finally, patch 3/3 fixes one more tc-taprio locking problem found
through code inspection.

Vladimir Oltean (3):
  net: dsa: felix: tc-taprio intervals smaller than MTU should send at
    least one packet
  net: dsa: felix: disable cut-through forwarding for frames oversized
    for tc-taprio
  net: dsa: felix: access QSYS_TAG_CONFIG under tas_lock in
    vsc9959_sched_speed_set

 drivers/net/dsa/ocelot/felix_vsc9959.c | 161 +++++++++++++++++--------
 1 file changed, 112 insertions(+), 49 deletions(-)

-- 
2.34.1

