Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD516E03A2
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 03:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbjDMBXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 21:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbjDMBXG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 21:23:06 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2062.outbound.protection.outlook.com [40.107.94.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 597A1CF
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 18:23:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=COBy8jUYUl6V1sATSBBVDIj7XYAkQNlSmkijZm/TCAKV8rJ2TV5kYYFU3X7OhtJr+g0+EgnK8tqmLbHfch3IOxQaKCgIr4qN6A7L6dtnp221fzlQdYciSH8es6jh8d0v9kFOacRO19Vw9jUMzN+AoojWFx5CEZ/ICgykmzdWKJDAFVYOUMYc9uZucVXUqHPVxdz2B/r2RKbsmBegXbxR+GKC3wAuAvUh1SXQkSW6CAPc+B/kZgmOtONfJAkW4+n0DzRUfn5bWZwGWZ2SFZJnsfluu8B1IIgLs1HBPVf+aYUbGpT4ZU6O3ryjziDZyZkikdGpx8gGcYBnfAuCUSo2yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t1J2WclUR0aaBu8CqqV9XFKq1LEqPBWoal5yUp6xkR0=;
 b=buA5/UO2MHxAqehL48JNJ8C8fi0Cf4g5FRkOdB4AV5w5749ck8VVgh/nG2pS1NGcMeHU3qo9Z7p721kMcyPHb5zzDWqo0SfykCqsvGWJWaPLMBM4qJ8wjIoix+g8sgT9x+ToECzAS6LOgyi1IY56XJfJQ/+//YXpzhN6h/iQX/I6ISy9PBtIJ8S+YBLf4BOsKwayfbckaXjosp16Bxq6rE/xZrlkvxXT0oM1TMRPKrDciSq1qmsL2zdJtO6/DDNSyXnPzDIyiSXnCt/naONEZIqxFOEqzkqD1BrCosvzypvh31ZYxo4x5JXIQb2FJr0gc1s9NiVHAXl7pVraRViNbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t1J2WclUR0aaBu8CqqV9XFKq1LEqPBWoal5yUp6xkR0=;
 b=SEmPiYs9eeEZaev5fuA+aa5tdQru+I5CTYxrlREbKS+tJUZ6eDqhMn4YhO+sz+UT1/qVuQBeojGv8pncr1IcPXuYZ3SkgJWrpLM1wFHBOjc+ONnFGGY+Dk8wc89yjmYLQ7n3ihP50wj94AZEpvH42pdjKitZ9TI2Ky0dy2KaeuBvIZnLi3FrVgeX4EHRz6vZEF4KcgOLoN2gu7vMQr4UKnORuenMeHE9oIWUC2tvLE0K+d3g4ZNDAi1T1spJTkKC0/WzpkuzJtiQJK03DS1MMRJw0A9YmfEocmMzzEyLTLGBMlY37YYy9OvLdeiG5NIOJTIU4+mOlNy8zMbcD79nKA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by MN2PR12MB4335.namprd12.prod.outlook.com (2603:10b6:208:1d4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.28; Thu, 13 Apr
 2023 01:23:00 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::f6e3:c3af:67f9:91e9]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::f6e3:c3af:67f9:91e9%6]) with mapi id 15.20.6277.036; Thu, 13 Apr 2023
 01:23:00 +0000
From:   Rahul Rameshbabu <rrameshbabu@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Stanislav Fomichev <sdf@google.com>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>
Subject: [PATCH net-next 2/2] tools: ynl: Rename ethtool to ethtool.py
Date:   Wed, 12 Apr 2023 18:22:52 -0700
Message-Id: <20230413012252.184434-2-rrameshbabu@nvidia.com>
X-Mailer: git-send-email 2.38.4
In-Reply-To: <20230413012252.184434-1-rrameshbabu@nvidia.com>
References: <20230413012252.184434-1-rrameshbabu@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0030.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::43) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|MN2PR12MB4335:EE_
X-MS-Office365-Filtering-Correlation-Id: e6cf487e-c8db-4494-5472-08db3bbd9ee2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GBqLsul0/d6NPAhk9d0hiYxcjuCOSSKLsGCMpBVWveNQrbCVbYUujNAIaUDXWUM8hmF+JYiTcBEPidcf2gSCVCvmBl9iBnL8tsEpbdt+ED/J0DkPUgAfoZ+rkhEzU80eOVesP+EdPFtCKi3mGJn6ofa45sg+2mnRp0kxFic9lC9823z65WxmKCPnjGrQvsMPDba5ncSyDCqbLU80XvpcnipL2kuvyaJ7mIkURmRM2BnjBCfEwFgC++zMabpfE3c4H3b6A7l0PT6pXFwjBMBTsx5dCtrHZmTAlvJx+B9Wi0+UchNPMqfKgx4+yMehriwrcljN8SW05w7+3GV7Qtguh4bFgLEXwwC8ftRoGMdCIsgzn1seNUIQKl0hPf4awPS3oObs6yP2Fi7nzgP6AY4reTimsv3cxclhYc374UmyPnJGmE6xHbGaXl0ANVqkSqnsJj5yU77CHzjrYaoXBWEIFUcGlmK+T0qy7qH1q3Sa29izZONyOEe4Ngy1CqsXndgSzkQia2UGX3b+8PHIa5qW5TbJVPRq2+U6GzItZ4+fFBq5QuQzYMNOH4yh1lR1XRA1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(136003)(39860400002)(396003)(346002)(451199021)(478600001)(36756003)(38100700002)(5660300002)(4744005)(2906002)(316002)(8936002)(8676002)(86362001)(66556008)(41300700001)(66946007)(6916009)(4326008)(66476007)(83380400001)(107886003)(54906003)(26005)(186003)(6512007)(1076003)(6666004)(6506007)(2616005)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NcCaipuaYSIvPO4A96zDFn6zE4jC9FF6qCiCpoDa+42N0ITpO3ohwa1Cy/jz?=
 =?us-ascii?Q?D4LtLpU3NE4DOXz/cJNfp1wB+p+WF52zftX1Iadr2VsAQphEcabV8TDO2hbi?=
 =?us-ascii?Q?eGWUw0Ou0TwGeVrpgh2PuOwBv0fUBF5HgbOCZahjuAaq+3CDhe1gg0IQOoX7?=
 =?us-ascii?Q?rSegYBSD1N1nBe1anvCNDmwfEuwPwSRnI9jPEavdkKViLEyQVjkxSFatIcrJ?=
 =?us-ascii?Q?Yi28xiw9mvCE3JlVJqqvZhY9oR/4pFlKkvTO62LdDTRALvQM8Pt8EpTUhoNh?=
 =?us-ascii?Q?ZdWqSeszCnYYw0SaHQ+PL0/tRTl/Z+QHYbRe1LwhaE0rdw8G2koIkYnG5ira?=
 =?us-ascii?Q?0qmodE0aW1X14YSyWXkbi/mu3hRdAIufRioHM6ngjeQnFnrjlz93pcjeyrxs?=
 =?us-ascii?Q?YFBkLKItlT4tkpbcJRl+idAa1eFrq5mftm5atHxY7s9svGOgtUcQeRwO/jVk?=
 =?us-ascii?Q?U6jE7q8Pc26EnyHCeNrLb+G3jgVwKukchCkXsFzThcTdaxSwiQ32mlWM3ibF?=
 =?us-ascii?Q?7ff4b926teffj8fvnsWubF2oXVsFMPVFxUWtIZwx08ZYELIPVdovS2maf1GL?=
 =?us-ascii?Q?HTBP+OQjtOagNQvIueEnag/j5htGR9FZRmGDr+0tUqSApl4wmkphdCA9N5oD?=
 =?us-ascii?Q?sRDd8NOweit182VYNer05LVR1U6HSIP0tWqUd43BOeupMOqVb1fgu8OW2qVv?=
 =?us-ascii?Q?KCf57j1hhyZxyxw2CVG33bJC1hIEoJK1NSOz8Pm4u6rVGTvT1CGNHzbRVQaQ?=
 =?us-ascii?Q?DbD9APCKjvXOeSZu4MfID05t5Pp3iCVUluAC56Nnnk7m6SfFUf0YFlJ+pZd1?=
 =?us-ascii?Q?fJp5jGU8/80DJu8FZqJ0L3/z3iG9bL4rMTZaEZRjQ5zGeLooxkXhuBCXnvki?=
 =?us-ascii?Q?jhAX9IBK7dYz3IvaFCcoKqtxYoWoLHNwkgecCVV+Nr4QMLCvZzyJciQ2rQTS?=
 =?us-ascii?Q?2PPR5T/Rrp6D9/uwsv4wktyrTEgpNx9SvUczig0xXKdTrDMlZV/6hVgdOlsm?=
 =?us-ascii?Q?e8OdiEb3gJ1BcqTLFXKMQMabW4fodmil2OkrKK8HG0f5zPxcUvllyBz2ileN?=
 =?us-ascii?Q?vPczNMQvCvZOjvvuE9sK7LeQQbgWn9mgpvjHOnyY3GNUAbtLn8Orzu0n1AiN?=
 =?us-ascii?Q?uQtjVlx7D9X5eiKS8nW0mmaHL5FbE928BZgnbmN97fNx4JqPhD7aSHGtlAuu?=
 =?us-ascii?Q?Zy31MZJcsVOy1rgtXJKqZ2QikJ5mRuRsqcinUc7feyJtzN9x0aU6gg3mxk1+?=
 =?us-ascii?Q?GUJ2q7i7vqVhG4+GQaKYjGCOsfjAysiDpcx4kjdDr4pYPSYdljUYrUUO2p9Y?=
 =?us-ascii?Q?3g4bDeislVVNBy/974jhFW/VHEfqNxIq+0pnW3VHEUh5hCe/kF6hu4LYkzSn?=
 =?us-ascii?Q?d5zopvuBXT545sOzVZvD1Li4eFQSe/sfgbIuSrQsAIh6dJpl082gJ71IJA4V?=
 =?us-ascii?Q?36gwNSuD9ACY8RVEx4D7aTg7h5+g4vHneesfaLEvOpugCvbAdyCU+vO1sbjp?=
 =?us-ascii?Q?IvCZcvMiaBQAyPMeQt2t6xzImB1BLyf9tEzinLtprCLYfhSUXEDXbdkYHQ4/?=
 =?us-ascii?Q?z+Kz+D3T9nJmSwVB/6aQk9f2kosiqJyQyZyvTlEykmeGjTTnYMrWGFxo7+8Y?=
 =?us-ascii?Q?jg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6cf487e-c8db-4494-5472-08db3bbd9ee2
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 01:23:00.4706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ORp+vrhHyfXBtCQDvpAnZD/zxuX6kaEK3H9lPH7c9B3ifnWC0slIlyFZRjfx9/mhwB2oVHakMKWXHKvm0wi22Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4335
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make it explicit that this tool is not a drop-in replacement for ethtool.
This tool is intended for testing ethtool functionality implemented in the
kernel and should use a name that differentiates it from the ethtool
utility.

Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
---
 tools/net/ynl/{ethtool => ethtool.py} | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename tools/net/ynl/{ethtool => ethtool.py} (100%)

diff --git a/tools/net/ynl/ethtool b/tools/net/ynl/ethtool.py
similarity index 100%
rename from tools/net/ynl/ethtool
rename to tools/net/ynl/ethtool.py
-- 
2.38.4

