Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE8A564592
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 09:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbiGCHhB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 03:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiGCHhA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 03:37:00 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20088.outbound.protection.outlook.com [40.107.2.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48CCD9FEF;
        Sun,  3 Jul 2022 00:36:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oENGByudOZV3s15vMnfPYpGKJrfRmIQ27MZ+CHPtxYTLU8XW+PvSaFUe+tTTNrUCoDW/oq9H2CWUUgSLRTlYu6KotGeKZGwBuAfIn4VeKx/XWADZXhCaA77y0Kz4JMMYSP6Pkev5bYrvjQAzTLB9sqNPVZ6qaHNsqIi0tL5S1N+Im/zvVLPYEXZIyABIHoKRvZyyfdeBXEUaFVwdFdhT2q0pRyqrpXVXzPx/KJcDZVTZzT9jNB7uTdqKiyUlsUvZ27YP9fxIz6ook6UdYp7EUMzemYwrGZP1x1zilZYxNx7UQYCQGK4ymAaW1SoCMPlPmBAqfcS/3ivaNjaUzjoyYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WJs1N43RVO8aqaIdpIGt161PaDKGvyh/cDXPDpnyo4k=;
 b=IwMuhT8HQ5YVAk1xzaQZPxaNVIsnGNaXWfqKsWAdaYnnirCU17um7UI9qC25fAfoTDaMz/RHkYOOILLSmrV3ooqJeEpH3Szja5Ht9RR+csJhCKJyObP6k87l6Lt1faIW86W5F716+j7k2p+RyPnQwG8+kB4ZpbqGRnRjsLilFzHFhK/QzWQJaXnqYhzwup8ctoWsLnaHcnn1smv5pJGYwzGEPYrmzGdMV2LHRHQF+iLy7gIdGTpi5VO2k9uC81BC8M5TuzEO7+pYmXeyX0LzjYyvmyLD+cplFlzPWGgfJO4V/4iCyH/c9onsAE/4DScRyS1ocwMkc6J/F+ju+eGM5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WJs1N43RVO8aqaIdpIGt161PaDKGvyh/cDXPDpnyo4k=;
 b=mSk67/cU98iDdMfsaF0CxoTOMygVFJeJk144P0zsOWlwjAgQ6o8UVM3zDvrtKoy5148HvK4pGOpZxuwk8sD0pFKg/m3lzIx/i8mOPbIEI1OB5uVjVO10gpJIPqPezjsk78tHjw47YTFDnHbMBFz+zCHFxfJv9qxgYEVVM7J+2sc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR0402MB3877.eurprd04.prod.outlook.com (2603:10a6:209:1d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.19; Sun, 3 Jul
 2022 07:36:54 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5395.019; Sun, 3 Jul 2022
 07:36:53 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH net 0/3] Fix bridge_vlan_aware.sh and bridge_vlan_unaware.sh with IFF_UNICAST_FLT
Date:   Sun,  3 Jul 2022 10:36:23 +0300
Message-Id: <20220703073626.937785-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0018.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7387f4a-928f-4ff1-4642-08da5cc6cca8
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3877:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GxJsZcZJaLVbVQKENbEQNj7E/b8hvlem1B2xxVAJB0M+vKezjrhDzK6af5DCiqS9nxmW0YonAtjG01cujYyfe5nWWzKFc4Pc+QWGRHgNmejh4Iokqw7tHy35IQxyOwZOEZ7QvLPrHA0+u8bnKP52gPc4zuCLBZn5q788Qm1BjOzPk7GU0+nK+VuVXsZLg6ElXIAHi4JyB6j52hRKJaKulhJa9sOoHLcerA413iQJubMOOoSEoTANUe0AeRApQf1gIALX/iKrVacT135NjXFhK0L7Zk9KGBQ9sB8KNpePmBl0O/59PfqqvQ0TSp2X4V/jProy6OFeqGpcabV3kNgAc+aL5QemUPThZV0aeagn5udRB55PPOolKEknKeVvhdQFShaNK8jyCoQyIVpa6QwsfVRrejwWPeSjjsqc0eHsbJ2CVB/VVrFMbc1vl/PbQxSzVKhMyNiA7iwO30Q1fY1/CP8tU/jOxMAwv/KqdQAlJiReb5rNSyVDNHKAhyUNE9+w84260cjQBdtj9RoHklHlUg98C9dkmHJ7tFDtI5h0+iyTgI4hnLHcfnhVqpAxvEQKufJbCO3NojxNIs3kPV67rYeMocsnlwg++iRCmuxzzA3rmoYPbmGVNpc7AFHVJD0c7HeKtOhfngkuKxUxjlnX4m0I/YvqXJQltewJQ5Mo8i5pY0SdJZ91Ane/wGXLJ32HoYc/XDahGEHIcJpvPJGBe4lIK5WjOobCy4C1Oo2NvtjIX/rtZrhEoGkNkGsozN+Q/qmP6DCcCmqKh9d8QyutXXgK9QYliW/n77YL1YHKaMKnXe51m8IQ8euxwBLCtlxo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(346002)(376002)(136003)(39860400002)(2616005)(1076003)(5660300002)(8936002)(6916009)(54906003)(4326008)(8676002)(86362001)(316002)(66476007)(66556008)(66946007)(6506007)(41300700001)(6666004)(6512007)(26005)(38100700002)(52116002)(38350700002)(6486002)(478600001)(83380400001)(2906002)(4744005)(44832011)(36756003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vCgWUKTHS6IbOowoLGingHnSMSNikSSFjDc6pMzyGcJnAducslsl/NmxvLBm?=
 =?us-ascii?Q?xJbo6NGS2jrSt+HoKd8xqJoicGZucOh0FCPnnukRuJfqLsHNrv3rLYmhyx5A?=
 =?us-ascii?Q?G6ji4Py94DaK5XmHeHeENAtVORNYrSbIBuetuVRZie5zNy7442YgHCmvAXay?=
 =?us-ascii?Q?HQciKzrdsleMC5QAK9bL9jwy3t9TtgD+O31YB59ys78REf8McM1dNK8sZ/fG?=
 =?us-ascii?Q?WvPhPj/lCgOKw8QQbgMND/tkEepTS5m+frqPguop1U5GAJHrRaDs5V1cvv+j?=
 =?us-ascii?Q?4M4C+wBdKmMh0+eh0yD/HvyV3d2npv27yR37Pn1/at0yMlSwXrF0GnMYXl8G?=
 =?us-ascii?Q?Wxnf1Bed/IjhYiwP0YO3k4W2TthHG7DeKp9eVbOq2uKSPJFiK2Ond//pAe3r?=
 =?us-ascii?Q?7zXuWLLeN3Gr+4ffoZjJte8gnuMRoPMYi6HzI3JEOqYdbVKsKiuCWZSkN3nU?=
 =?us-ascii?Q?APUocH9byfXS9ymD8+gL0hDGRMrUaA0J/qSiZFExCMEpElsoo/8AJ/ADpGFL?=
 =?us-ascii?Q?UZrgmUPWwS2oLpcLtQj9hszwS9POasuu+15BcYTl8Nivb5ak1jSTDyZMj7FH?=
 =?us-ascii?Q?/iEKlCOqvKodFAkNBV7tRugzaNGv7pChpmjlnCeuIrfzsylvvxR01dXuE7Kb?=
 =?us-ascii?Q?xFbWIpMrV05pSPrit9+n5Y6pphrlFg+wL1D2ei4vbBfZVVmronSCZsTL307d?=
 =?us-ascii?Q?H5FjglOewUDCBw/F1Fkwt6nxrE1auT4lUMG2kG8nJQGv+iRc4K8B8UOv10zI?=
 =?us-ascii?Q?O0gn6xCc5tPYpoPB/j1PDmvyuHb1sRvQ1bSFBLWkxPJ7IZfwLpzxj8sHI25m?=
 =?us-ascii?Q?24wK8rrpBWhQvkI7L1uUYGPNf1wUT5EwDWxGo1OUzr1Fs4ZekORYSk3hqbfe?=
 =?us-ascii?Q?DZK8/+eAiDIInAt+pCkU5Z8ItvjIgn3mGI+mDtn2UHifJzsciJufGCd4aa+G?=
 =?us-ascii?Q?3GAAIctxLBbY+t47gFmcsn72ilvXok7AMSKKaU+NLfMUzHbjZbyIBK4jPBXV?=
 =?us-ascii?Q?gyFQ0otqlUUGofTynWDw3LJ/K3NYKgjcnX6C3DpyHY2fUl1H461FwaYn9k3J?=
 =?us-ascii?Q?dXH0+Q62Oj5qLJ9R0abp2AJb7sx2ZUXV3ISPaYv5FfPymbf+Cv8+EK942KXE?=
 =?us-ascii?Q?9Jn3alRao+XF26eL8l66NzyCkw9ogPwb75bO5YRS4NVyC5hUubHZGZOizxio?=
 =?us-ascii?Q?hk8UgeRgjVeIxsHTkEp3ViNZiN0ABDqK2TBXDO/LxYOCajrrNeUAu0QtM814?=
 =?us-ascii?Q?oH5H4LMiL3fXlEpb4nO5mQCjM7vj9hmbWv/b8qhRU4XeL/sPRn4Vh9YECGZX?=
 =?us-ascii?Q?ZUi7I1mfeL9kA/3iR6gwMcdMIJes/b6JmKYOGm1NmSQSltuU509449aOcouB?=
 =?us-ascii?Q?BE8NGRv/rKb84c2epi44Xt2o1kga+8qouUICqZCNZ3nFwNPUQVG4WF8xplrV?=
 =?us-ascii?Q?Cy7qqoV1iyGWzEgnuj7EV4mqRZB6Py//ZU9k1ZjH4o6iCq2A95CZUak3KW8f?=
 =?us-ascii?Q?45ssJxSVak+YW1/RlUpD1/60pquRoEEaJcy9sMdIZfGcfb6GH1E4YVNJqZje?=
 =?us-ascii?Q?4JyMLSi3wYRHrEM1SsSP+aDCzDTokwG96J8B6RiQmCNTbO2MXyWLb7JVck8Y?=
 =?us-ascii?Q?5A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7387f4a-928f-4ff1-4642-08da5cc6cca8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2022 07:36:53.6331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xr/ZYhcREXSPmkaAk+OYjOb3PzXPEfuQaxmJtVocna9G2AYIOHhDrRWI6kUeTlqZTcX9A3aRwP56infv8s08Jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3877
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure that h1 and h2 don't drop packets with a random MAC DA, which
otherwise confuses these selftests. Also, fix an incorrect error message
found during those failures.

Vladimir Oltean (3):
  selftests: forwarding: fix flood_unicast_test when h2 supports
    IFF_UNICAST_FLT
  selftests: forwarding: fix learning_test when h1 supports
    IFF_UNICAST_FLT
  selftests: forwarding: fix error message in learning_test

 tools/testing/selftests/net/forwarding/lib.sh | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

-- 
2.25.1

