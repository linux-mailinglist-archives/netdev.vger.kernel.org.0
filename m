Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 842F037591F
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 19:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236223AbhEFRVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 13:21:49 -0400
Received: from mail-db8eur05on2060.outbound.protection.outlook.com ([40.107.20.60]:2977
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236203AbhEFRVq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 May 2021 13:21:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Poiq28IA9F5S1WopkTZhJmXb9bTakgs4kcxXorYJlUULalBEJW7ie74RX21h+EBZwycmbIuLlY6m1OrM+fVHo7NvBNhMBcfiKQ0zZr67UV5qSSm3xc07tG9cXoRdI+Pz5Pp9Ae1pW0wv6pNU6oCh6IzqupBPUjnGM4QT4MhXYaNjMJovzA69QCXBDhC5qnhfWKrVpntMLzxXqTmi/j5NXR9c1H5TaWUTXJln6lP1CQWTCqdy+0KQALHbTAqR3GpxsAUXUFkzXCcSvuNlb79YFxNyLpcVAOXOLNJxzIYZLbtdqpwTUqyfYkBFtGGenuEccXSoqMCR8kgdlPcOWroIGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yl9e2iqd6M+ePoj94fZ9acHuCEm8qFeJi9EkFW6QIz0=;
 b=UInTE92FO5Nx7W/yCRutoJCcpJ5j22RcAZIqSJG9WsEvLf2VNqRYqt1ayRXp/IpUA8WWEwVCeZ645YyLGYJzvWhZGaEGVVK5Kg7+qSD9igD/v/lZqYVibrlWr2PEHRDEgTi7IXksnspSqwfQuAHFuAlz1UQPefHdPZ6owIl2C7KzhnKJRc5e9mGRndho78unDbHvsy7YpepqdYT8Gr7ypni0PlP6bvE2IbqfAdMMhypbKtGmkd1ZiKq3yFYFcAyd2UoDpeKB7EsXq2B46SLtFusbh3l6XNsDbwPgjJ/amBqkoa8Zbt16oD8gyZLaxxTxRFUDHkxaXbadaHW/yVwkyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yl9e2iqd6M+ePoj94fZ9acHuCEm8qFeJi9EkFW6QIz0=;
 b=UN0A6odiT3Q0U1Gs+nRGGGxCDlFXwjJi1uKDyrU5Hb607K1xORjp1FDkUyuaZFwHw2s9GBz4N+CTqXssWq17JFBKeObZFyIAEfCshVBrdUWiKuXjt4Y+5qvuQ1UCoSEwnfiJNK+97PgfXCZAPYF9maLy01TMoScv1qaoulmCIUE=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=oss.nxp.com;
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com (2603:10a6:10:2e2::23)
 by DU2PR04MB8581.eurprd04.prod.outlook.com (2603:10a6:10:2d8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.26; Thu, 6 May
 2021 17:20:45 +0000
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::88ab:35ac:f0f5:2387]) by DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::88ab:35ac:f0f5:2387%6]) with mapi id 15.20.4108.027; Thu, 6 May 2021
 17:20:45 +0000
From:   Yannick Vignon <yannick.vignon@oss.nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Taehee Yoo <ap420073@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>, netdev@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        sebastien.laveze@oss.nxp.com
Cc:     Yannick Vignon <yannick.vignon@nxp.com>
Subject: [RFC PATCH net-next v1 0/2] Threaded NAPI configurability
Date:   Thu,  6 May 2021 19:20:19 +0200
Message-Id: <20210506172021.7327-1-yannick.vignon@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [81.1.10.98]
X-ClientProxiedBy: AM3PR07CA0129.eurprd07.prod.outlook.com
 (2603:10a6:207:8::15) To DU2PR04MB8807.eurprd04.prod.outlook.com
 (2603:10a6:10:2e2::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sopdpuats09.ea.freescale.net (81.1.10.98) by AM3PR07CA0129.eurprd07.prod.outlook.com (2603:10a6:207:8::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.9 via Frontend Transport; Thu, 6 May 2021 17:20:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 214d6f20-5e6b-4fbf-0577-08d910b3485a
X-MS-TrafficTypeDiagnostic: DU2PR04MB8581:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DU2PR04MB858186FEE9FC4598485F72E9D2589@DU2PR04MB8581.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3XLpVX+J8JL1ee0Zz5dBnjJUXtnwbhmYQVF+yNwm7nQaU1WeEAVEkEZDr8YDVqyu2HCzOl2LNNaHRafyucvUGTsR3fqO7HhiN3WOf5K2kdkG0EItYHIBWpr5gTy7b2rARxm5a61mEoNi7WLi0CjfgYC5svJurm57LdIFVDwaJunvI8zYk1LaiAnyyQLqAJvE9fM/5EPVZInoJWx7iAT8E3HCUV8uwBPU9zxUwYaEuDdbFmeWL7odUQakCEsIqmi0uis8BoJelQb6EOZ0BVRdNfAY9xifnotCXSMr8GebQJtV5ktw8brb6MUL8tDN/BeyBdAwCt0ByMT7hivMXk4PCLmlZ1rmRjO3OoXcaE7eeGb5rfEVjDvzuTF75wJdzdu/jWDEiKnm4vdXrLCVFhMwdQKDW/gkYlg9XVE6gmBBEI2uJqLo838CM1J0Kmmi1gYD/YVJVhRSIxOMtmsrWCktalDK1fKx11FrwWBF0PriPfuMGw3+ejJy0RFs1qAzqVzeEH03L3ENKQ72elmrgMvpxrVRCUwusCtbR+nkhVizZnq4brQ3gtSOnTUyvZ90T6ndLjlifIrdJXnw18NAFYJYkrhu877w0B1YhrexuLiCvRsDxli5aDRnV0m2jHet8vdLYq/+sxyuncIwQOWb5dEqVfvxFoAxWIYKsC+DDLqRg4o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR04MB8807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(346002)(376002)(39860400002)(86362001)(83380400001)(8676002)(16526019)(6486002)(4744005)(7416002)(1076003)(6506007)(478600001)(26005)(6666004)(921005)(44832011)(186003)(6512007)(6636002)(2906002)(4326008)(38350700002)(66476007)(5660300002)(316002)(956004)(2616005)(52116002)(8936002)(66946007)(66556008)(38100700002)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?JxiMoa3sMB4hXG5vViaFHAJTc3Zlr/7dA+p9GDYs3Vwa6PQg7kJBIdBbvKan?=
 =?us-ascii?Q?4Z8kEBsP0nxFGvjOqaI1gWJ1OI4KBVwsz8fwHy3DjdKPkaGWZw2bJvrs/wHx?=
 =?us-ascii?Q?uKZ+iFE9cNh2f6sGjfDDwEFJ46IkMTwY32VyWnfOPUpjn2pzr+XYhpF3oDx9?=
 =?us-ascii?Q?Xwq7rSImNthNlUvt35bg5xKVAGiGSjN8zjY3QnpzN+fdlHDH2ctEOx5y2ajx?=
 =?us-ascii?Q?SgUCAj+fq5Hv+pJ5HvpNS4iRQsaXlQX3gvK91havIJu6VkBRfuYIkWb8D3mg?=
 =?us-ascii?Q?eyzXppSK0fYk8K3SUpVHMfwD/fD6jHripG/e0/fwGY05j5dCtVn+M7T+Ze9e?=
 =?us-ascii?Q?8G97lQZ/vMgM/5JMkLVafb0CDNZHReWrhp8eXCpqMAff/BgL5M4y4zjP4kSA?=
 =?us-ascii?Q?aN4qAmANvW5U7Kq6Xyl3ukJh41EtXCMrQ1+CO6qNln0gSCGnX2mpgp7/e525?=
 =?us-ascii?Q?ztWbLWT56u3Rlr3eXRhPmm0V90EMqdUZntT4QDhkg/2nnoNv0z3vzv8sEiax?=
 =?us-ascii?Q?S9lD/GCz1fwozfvfq2zDex1M2E9EBZBimeteFFMxz5YbrD9dSMn5UZ1JG/gD?=
 =?us-ascii?Q?O8kkKmlv8ciJot53MhCzG6pHzu//NYQ9guXXgikddD5AxvADixVGmkeQ21zu?=
 =?us-ascii?Q?xTUG3bUD8Omy+vcGhi+nH7kdWq43bCxyjQ4M0eXVPH5r3KQabyI+Ifm0PR33?=
 =?us-ascii?Q?S1gST/JfnL4sgUQiLQtPLPMQuU7FzCsU9le+U1fBvA2lOfsa3rtoDMMGjQgW?=
 =?us-ascii?Q?z7ODI3iLSzp87eT6MdvVYs67u5LBGiRyCC/s7X7rMThyKq22zL5agCHJG7Tg?=
 =?us-ascii?Q?8dpTxqK1eGH3bn7M5c28/D3OV4siHIKlaeSTRu/s1+hGqocfn7TaFkpgR1EJ?=
 =?us-ascii?Q?pUyEuq/iT9t0Vi7qDEGt0JT+uXIor1cjHW2sFUQ+8UE8SJBNsZAtfYoZJrnT?=
 =?us-ascii?Q?8HTTtlIG0pllNIiELrh/Z0SV1xwrjX5NRMvf3+oxaEo5MGuxzWflZglkt3wL?=
 =?us-ascii?Q?VTJS3gec8IwdHg/buj/xdivobN6wePwha4536a9hsexdBOd+Ymos+nE2UiVY?=
 =?us-ascii?Q?UU/8PRUDadYmcIETM/YVNLQLJuJv47Ga9bvKfuR5xgaJ+arit/eTwexnmNNP?=
 =?us-ascii?Q?r2o1/7SrCtGMTBDukXsfHjTeivuM4aWYiIA/d0oeOe+3kBhpSyLb0IzqB8vA?=
 =?us-ascii?Q?TQYZUY5xO65uofI0o6W4kWLDT/jPLUvvKRjBPWjq1MxgdLIqQYRrLDrO5bZ0?=
 =?us-ascii?Q?DRylTYTpF3USJ+lLGdeocQ6g7ouC9lQm0t8pEgLHpdXzVW0hdIIgcrbEFdpm?=
 =?us-ascii?Q?R3KKycXuxiu/Hw/fPnZVdxAY?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 214d6f20-5e6b-4fbf-0577-08d910b3485a
X-MS-Exchange-CrossTenant-AuthSource: DU2PR04MB8807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2021 17:20:45.0915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zMuH1if2owqcWtIHnn8TZQg6/QrXbBTZfopAWaU44ZYEUEznAJEFrwEahpB8fN9k4sZJY17z6MuPdvHVfCwGtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8581
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yannick Vignon <yannick.vignon@nxp.com>

The purpose of these 2 patches is to be able to configure the scheduling
properties (e.g. affinity, priority...) of the NAPI threads more easily
at run-time, based on the hardware queues each thread is handling.
The main goal is really to expose which thread does what, as the current
naming doesn't exactly make that clear.

Posting this as an RFC in case people have different opinions on how to
do that.

Yannick Vignon (2):
  net: add name field to napi struct
  net: stmmac: use specific name for each NAPI instance

 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 21 ++++++----
 include/linux/netdevice.h                     | 42 ++++++++++++++++++-
 net/core/dev.c                                | 20 +++++++--
 3 files changed, 69 insertions(+), 14 deletions(-)

-- 
2.17.1

