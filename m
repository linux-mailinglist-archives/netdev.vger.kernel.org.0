Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2EE4B0F06
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 14:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242357AbiBJNpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 08:45:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242355AbiBJNpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 08:45:11 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70053.outbound.protection.outlook.com [40.107.7.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C955C59
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 05:45:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HbmoMdFqBUDykwCOUhB4D148iDLnW89gcr3MM+dme5vt2ik56QkpEPtYYVClYVVVa70J1vTZfyQOZZmczerfH+/WdWZ3ax1CANBdKa1x57NLUCD9+9M8Slz5g8kYh3ux0y+lG6MBhXT8BY/Cy6DtiXNCl0kODwHGIAzS5J5h60vs0tn10zJxAJOvNWlBGnhSRYJQjEE0CxmZqPmLNTpnsV5754PFXoN7sURM52ILnK1Xq3KzWe8pRp5m7bHKsFPQrYdo+pNomxKVNj2NinfnKUM+xUsL066ZgSFer5Qx4EA0O846Vl8h3UlQYsai9BY67FqetWC+iE68FhL7Iet0pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zL5FAy725iMnvxO9WplyUDeZCYh9hCFq/24f3civoHc=;
 b=cN/AOwqGHuEn6Ped70VSRbYIC1JYFx0F8phg1ncyVCN2Y4HFs4j5CWMlnFZOLr4tmF++Llk9Yx4noV1SEb3NZgjOgyJU0ryLqwYXi1SELxqlma5AY9h9iDyADKq3Pp8V9qrJ4iZKlw70a3o6qPnEVLotSivHzBWOityokJQuVzlFeA8E8dsYr+fdhDVNTZFPxoi04Glzw0SLE0lJks1vsbExWam+5/cojiUKwEZoTQdSLrEGrJFg7OozD9mVhXQUAILZYexjmnyUNTjUCFQke/Zm5D6mMYK9oQUwlMgMU2bDIbqEgTjH/QScDI/egSVKQqFNw6JwBvHhSRsC2T1gAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zL5FAy725iMnvxO9WplyUDeZCYh9hCFq/24f3civoHc=;
 b=exQUiHYiA9zU51uaX21LGuNE4pR7ifANPZzqz9A0meR1viBbnwdkgfc8RMBAgQTpa0pkynSplOez7xaMD7i3hcmc7I4z3oT5PBSl2QD5D+TkNIB+UNOZC0eo6fEupsyjo+opzGjMsOaYU6XJnd6eH0ZHlkaizn43devDD6qW/7w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2493.eurprd04.prod.outlook.com (2603:10a6:800:58::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Thu, 10 Feb
 2022 13:45:09 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Thu, 10 Feb 2022
 13:45:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v2 net-next 0/3] More aggressive DSA cleanup
Date:   Thu, 10 Feb 2022 15:44:57 +0200
Message-Id: <20220210134500.2949119-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0097.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 38f5c066-7bde-4b2c-9a07-08d9ec9b8de1
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2493:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2493D9A5161ACE3E714C64B8E02F9@VI1PR0401MB2493.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +w5Fb4YzVDGAnDNZbtpJuO4huOXMFIG2F4I2DwXIgMGgWK8/j/Maez0UwUHKReiFiB4JwIBmIDfmVN0JD/NzXkyRNKeLpK10frsovsCXOy0k4HSB6KWXhd22mNcwxHurupDrJX9qItIZjwc40Rx6/vo6xla5Au0qMpxU/nXX1UzNhQWqBISCIqem5mROL20SAOgCn79zw/9/+nttbz3QN8BtdeLCSMruzxVG8cefC4xngfUg1IOAWviQoHVOUbM1OroCy+sgBlFenusoaxUU8kmqIO/opy+AEtXYuH38pcK1VcIZUaRjHDXNRC/PYxnb8T1vb3PmG0NsKT0gEy3XyC6MBcIMwgkLqJU120dBwsSySR5/2oQeW3VAYqojh0Z5ar+jmEGSmiya7GIrbVETsQU25cju/YLB9tVDP/xk3WVb3UZ4MgGEauo1Ypj81WNiszlCuptIdqbrKj+g+4CbE/6BqazUZYIhjTPLhkZWJc5mk+NB92LBiH37fVrThkBVsZT1Nh9nByMx1acSrI3HtDzuwQBup5pvUkq2Lz/v2tgiAfDYD0h3lG23AcCjYQg0A0XRGp3gKQiWbUl3JPiUuZMEaxOD+QJDeK8mT4WAfFPqN2ETHHaP8x/Ykn/JxifUfDY9sS1PAIHFEO/R3yPhcZcBBBJXO+EqXu/YYhgia6k/dLhTsF3gWpk8aSkmj0tbY6Xf810v42mWEkqKK4kHZdEPj578N6G+JZPbGK+z74XfUDRADakZoRVi36GoaYMQ1qtxXRpEOi2k24cBq0ewa6kk4/8T7eTjNExQ8LpwZXQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(316002)(8936002)(52116002)(36756003)(6512007)(2616005)(54906003)(6506007)(6486002)(6916009)(966005)(1076003)(508600001)(2906002)(86362001)(83380400001)(26005)(186003)(66476007)(66946007)(4326008)(66556008)(44832011)(4744005)(8676002)(5660300002)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FX/dMwKn6Kn7NssOE1yOAsMKa99iZlC06mXijQXN0iAM2OuQ+DGGPEQ6l19A?=
 =?us-ascii?Q?SUnww8ORD7j7TRMh+VkDLKGlc0NOcGSl02wuvKGm6qqopfU81VX+jH40ZtTK?=
 =?us-ascii?Q?+KVwM6dz3Iy9SChQwDtWK8Ss0B2P/TWnZLwA3szg4o3wfCCqTBOdSR73y3np?=
 =?us-ascii?Q?tz0GozQn2Q+DafOOk34aJWhmUHNG4F+sT3euOCAK4CYpa9Q8BUQTLNkvhyDl?=
 =?us-ascii?Q?JMRkRwNxIqr3W+ODXTLINlmHSrzvf/AtL+c/fTH1WoChHYMymMyw6sBpAknf?=
 =?us-ascii?Q?Kr7aklAgDAQUqU60UlRLjsYxsbyjXVp05Kw3hjCTgaqKXj9JsBunM///InZZ?=
 =?us-ascii?Q?S3fsA0X6trLqU/I8HsS6bPWie2RVUaHs0ABchQ/pXb6ZbzOHj9rUGLtr2CHw?=
 =?us-ascii?Q?608MGa+3cZ2CoHtK4E1Ra/wpSMKepEMm1stzY6j4KBYeiJwBJG5X2T3lCz62?=
 =?us-ascii?Q?gRxiK2ixUax+2wNutBE4XuC+fxSC2pRs3BoHkR69uLUeT5fjO1P/Lbpox0cP?=
 =?us-ascii?Q?mYcd912NASsMTWG72ohu65dkX1nY00niLDB3rUtkCmKuxnbQnzzmflgx6SEg?=
 =?us-ascii?Q?9H6Uk19QnweSeXurlCbOG64HEDYatrlqqgMj0tFA+xi2ps+4NxgXGLKVvJXh?=
 =?us-ascii?Q?Sa+REi7LMXzpKhaLRs1+xXKeOIK7Bw0RQ7zYiWoIeUfCmZ1bgquD2GjBjsnY?=
 =?us-ascii?Q?JskI5ikgo8J+lyylNlJSv/vE9CfVMLQmMQeL5iGBCfRSoGzlrmdCD39Xbs2E?=
 =?us-ascii?Q?AyoVfOepzn8iCq4mAPhMTCrJyYBAmJ7bf9L0lu5VLzBI9ts3z9YUmCrlzuqE?=
 =?us-ascii?Q?yOkRXf/VRF+M69pgKKdac3FJBnsH4N0s78Kaoz9KffFCQEp5Qx3zaCqhWYUO?=
 =?us-ascii?Q?0WtAHoixrYbIbNYT78+lZzMmRnQ2BFKOXXNbRNRreflH8Miah24QouJKFYJr?=
 =?us-ascii?Q?pJf2pyPiNdb8PFlC7ceeyo/ZN76UTVuRmRSOYFWt1pX4shWetwQC/4NyXgbZ?=
 =?us-ascii?Q?EEdUUk7LiHwpcyUMUE4+3MNpn6FEu8zwqpKdhzWjU6807GjVKwTKOoNquUa7?=
 =?us-ascii?Q?6cxdkJ+iTguH/GYMVnd+YevkrJuvCaJjL5X84WtSB7NpJjCGFsxPUY5a5WM6?=
 =?us-ascii?Q?jt0+fZGCV8e+VZkUbHYurvLeShsfGurs/rGpo7/5bt1e+1Rx/Ffnuj2ryLSH?=
 =?us-ascii?Q?7ghptTr8vbot3F9kxL35mf13hW7xR9nWS4CbgtTfRPX8DHvokXUTxSvfy65I?=
 =?us-ascii?Q?nJ78qOfKOsmUgh3wmfzyn2uuWkp3UnYCFT7kIIBnElBaHwclCzMCLAwXky4S?=
 =?us-ascii?Q?RuHzOozoxCtFkdhxMiy02D9M0+JRcAemHRK6IvZuuEruEZi8aYPX5DWmIq0L?=
 =?us-ascii?Q?D4KV+gDAlfjB7TvBvojOvtLVll1V52uy7tyMvM+5fBoq5c0qYfNZKg7h28OM?=
 =?us-ascii?Q?bMe6vcEpFjCy2QIPKnayJJZGCcBMXiioU3mJwf2ZOfsFZV+8yy4kpvuhBAeV?=
 =?us-ascii?Q?Uo7gsnxJERXCLRCq7Qnv+djoEBKrqgK8lNlflXcrQmdvc88sjHCEjK092kP6?=
 =?us-ascii?Q?GBewWRUObuzS7v33izHANJ8s11t3CfAeeTnO26KjfvkbVhr1QUxk3/EclQf5?=
 =?us-ascii?Q?8vYjiTTjOpAGoDBY1FDScBg=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38f5c066-7bde-4b2c-9a07-08d9ec9b8de1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 13:45:09.6594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t8UhNNahM7SyxctlXCiU66EK7A30vLdPVE1R2hjmmN6Us+FjrNjsmlQKkOpxIarnxh31yeQaZUJj3dOrTQBH0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2493
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series deletes some code which is apparently not needed.

I've had these patches in my tree for a while, and testing on my boards
didn't reveal any issues.

Compared to the RFC v1 series, the only change is the addition of patch 3.
https://patchwork.kernel.org/project/netdevbpf/cover/20220107184842.550334-1-vladimir.oltean@nxp.com/

Vladimir Oltean (3):
  net: dsa: remove ndo_get_phys_port_name and ndo_get_port_parent_id
  net: dsa: remove lockdep class for DSA master address list
  net: dsa: remove lockdep class for DSA slave address list

 net/dsa/master.c |  4 ----
 net/dsa/slave.c  | 54 +-----------------------------------------------
 2 files changed, 1 insertion(+), 57 deletions(-)

-- 
2.25.1

