Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC82D6040B4
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 12:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232414AbiJSKMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 06:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbiJSKMS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 06:12:18 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on20604.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eb2::604])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AFF514DF3E;
        Wed, 19 Oct 2022 02:51:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y+Ks2rlmrl3PFYh1hBnhj1J6MJ3iRReIvtJtScqzIO5Yr9Run01BxrWQqAgE30G1SCBrMxrewaUFgVh00X1T1A0iuwHv3V7QbQcvsg4201krASvlmNx7HQ7cg8qmUv5DH9H/MmzdZ9r95Yxd2gte+M5uj84izK+cvjY1VGbbbyMHKbCAuO4sKNW1/bWGYqbcPO9+OT0ll39M1F0LkP7hFyagjcciwYX3iYkPU3NvUKXAbx5VeWuyMOrDzCXnc96hOgJiqGW+3APyo02gxifhcTlX+BxYS3JvXJcJLNQpDO8XKbGxKLr/boctJgLIh1V4S+EfHyDD5PpUeFd/Te/MLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QujAvgOqg/flBpEucdYR00+h5saQamdc196S8msC/xc=;
 b=O1V1NGxaMrfdtSDOvjcb46XCiunEzvqpd8SkR+wReuMNa8QLKQtSsrpjl3w6nfw/T72iLBNJ072wBFdUcZ+3AWHPRUun44ULu9YufS9r9JRpWuLZWYsM7CKWAsnSTyVfMWlxkgcNlLKPm6Od3AKgu+Sx8ZoWWfMfhrMQbJ0jQ3LjKqXwFu69+DmMSloFqmKhY5S8OGRIjFXvV1zuvpeY6YSX0XLQ836qIdmY0RbkBMNQHTR+0l9xiUy8DshsCGvIiU+JE9GOYHVOKHiOeks5m4vcgWdbgPpkRMkxXN8bY2ZYvUQH7MHsHgfyMuV1BHh5fm0pkZlUY1nVQrT6FCzZUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QujAvgOqg/flBpEucdYR00+h5saQamdc196S8msC/xc=;
 b=imNGyrX3NlFjlQhl02wqDI55QbobpxHfrSN1xYQXr90Z+H2UpXTepP/vJktBBe+TnKHUY1SYf864jUsFx4KRYHiQsUr7O3t9vIOfxDz/rriTzKXfBUlfy3PTa/0UdfqUGlbfhzR0N/ha4WfuMxI/wAQ8uuBydruoNCEyvgV70eT3W69PPukRtMeOsGU6UdvtW3BndcXd+hHZkavb7Pohb8IWc2UScSiYa/AnJdTvTlCYkgJdaW5sWVjb3o/iszpyieTmLA+wGL3yS0QzS7YwEP6XMIRtLmSZxpg2LyB4wcR3tcssIvpJSqmziMVzvV7utKDnPL6+UK+6Tbqm2JipEg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4373.namprd12.prod.outlook.com (2603:10b6:208:261::8)
 by SJ1PR12MB6052.namprd12.prod.outlook.com (2603:10b6:a03:489::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Wed, 19 Oct
 2022 09:11:56 +0000
Received: from MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::6c65:8f78:f54e:3c93]) by MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::6c65:8f78:f54e:3c93%4]) with mapi id 15.20.5723.033; Wed, 19 Oct 2022
 09:11:55 +0000
From:   Benjamin Poirier <bpoirier@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Shuah Khan <shuah@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Jonathan Toppins <jtoppins@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net 0/2] selftests: net: Fix problems in some drivers/net tests
Date:   Wed, 19 Oct 2022 18:10:40 +0900
Message-Id: <20221019091042.783786-1-bpoirier@nvidia.com>
X-Mailer: git-send-email 2.37.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR06CA0022.apcprd06.prod.outlook.com
 (2603:1096:404:42::34) To MN2PR12MB4373.namprd12.prod.outlook.com
 (2603:10b6:208:261::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4373:EE_|SJ1PR12MB6052:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e4ac00d-3c0c-494b-562e-08dab1b1f7a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LPdAfEvh2Z1tihQe6UUzaXM7MDlA21s3Z9hK7kazR0QAFUHsG6CPkkA2LErlrXciF+ikbGXj1MXTh6Io4PGl8yIfnKUScbsukeRT9rCha8q/2O4vPB4u3Pqp4DIyR7nGUjx8fjZ/UDg9vKZWQ1+4yjhKshffQEe49LFQToK6ZHnSVkfpirpHY7DzeY6YjvjAgaMJjS9zOlzfd1wG6dzGtT4AO5CJKcgqKPzjT+sqolkqzGc+nuhyxX4+TUFrStEFcHT/UmcBN9myJqft+hm+R/yKRodebMGcLM1aDXwwQt0zcMEorF5YTAJfYiV9pdzTZX5S9O9vJ6FXCLtbyDA0/E504e49wYfeWqhgArCFnDwmy1sSx3MnodZ3wFxNd+ZvtOLfN1dMu98zUE77oS0cldV718V21Pifil4dWGBacFRMZLe3F8zcsEm5AS0Ic8G4QhBiwIoXh/Y/x7+dA0x11LtN1iw4+m5nypmE65AdDxxNBP7Llre2Be1ag/ALUauu7UwIErbArUAPtluw90sBV52PV67P1GpV0mCUwitLF3iMkLPvy0ugnatt8ko8RO6hDJdnoOydKf4Rhg0kjyLpQEks7XrTSbSjqGO5FPgvyoJTqjVvZAaToYzx476Va2BVQ0/XCcY8II4hSZ8P3X+FtXHHrjOdOIqghcBOCiLCq7PsIkqHoFTtmWixe1qnKRM+jCUJR/CNGgEKQ+mdh5bMAg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(366004)(346002)(136003)(451199015)(316002)(38100700002)(7416002)(2616005)(26005)(8936002)(4326008)(6512007)(8676002)(36756003)(5660300002)(66476007)(66556008)(66946007)(6666004)(41300700001)(186003)(6506007)(86362001)(2906002)(1076003)(6486002)(6916009)(83380400001)(54906003)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I4rB6F4VJamVQA0rO+i9xvWnCzNdXKFRfNJLQZ5t7AVHhKw58swMp0Z/bsM5?=
 =?us-ascii?Q?ls4FgjmqqTyCfm0aSZuKERsvyIBh2WaF7S0gVYOLe4kwr9ZYUi4P0JPB9KM9?=
 =?us-ascii?Q?kaoXhN8WZ01s15o0Kfcx2gA0pr1M0kQAMtWBS9JL6JyrcCgiBrMy8f76J59H?=
 =?us-ascii?Q?dKcdIOjUZCnkrP9sm4iup0uEAuybrxI1AAxuYyiS1vjAs96jUL65tgYBWJ+A?=
 =?us-ascii?Q?ouVbKthWp9OIjI6G8szjOLf1dqtNYR2E5JlxWml4FvAbMQheO+sQPv4OPGmH?=
 =?us-ascii?Q?FnnKEGqyPrzdObqhoex4ldqImyfnIKO+cTI1Fa5T0N0RFS/RcPcfa7TNpvRC?=
 =?us-ascii?Q?KLioQgxyPqS8/7teMlk3XrEUtY8pQoV6jwuBx4KoXmKx+dLJyCt+ZNtA+0cW?=
 =?us-ascii?Q?5xEd/MzFtkty1wI8O5lk8BnZcfFHic+oDohLfDQ6Wdm7HpOdRLIvLmfBqBYN?=
 =?us-ascii?Q?3u69Ch2/rCspaJFvLOXGeHiBbaqImwwz9KUcZdvMogQ9YzPJpY4MviOqg5Wu?=
 =?us-ascii?Q?fDY5HJ2O0ZABpgz+n9E67RwQY4R1GZescas0iXeWc7hSbD86T/EUfC7JqjpK?=
 =?us-ascii?Q?qLisWZxR2xhS+mOFtS1GRtpPNsQ1yZsFLi5zWQXdsHrCto8yaFZa2qgz9c8c?=
 =?us-ascii?Q?LRFzbDCPG97unM3D0b6RmoFSzVZbABhao4atDzv/YH+dwUqaKXmxHwqj3nTi?=
 =?us-ascii?Q?whOGYaYISqNjCFQYUkLdEJhcKtu4QvdDU1QJuf/WMkNqzpXyrxgcF1q13xR4?=
 =?us-ascii?Q?ga7w7Sh7D87QW/ZDYq214SLnme8iEqcIjKr1lBzipQGmi7FwAbN/wot3b623?=
 =?us-ascii?Q?hixXhmykfT8Cmr9jEP8k/rMct0G6e2Nm87aGCG31fRkAgOHHDguNQMA/zs85?=
 =?us-ascii?Q?QlDzj6eeXGVD4UllCxx2lAjmIdaFhBccybHA9WXSdGY6MBz8bohSkjXF9yYh?=
 =?us-ascii?Q?Edd91/iOitH9zbPYAsRRjn5Csd99dr0dg1/dPDumltXVb7+8ap2QdApEdgBI?=
 =?us-ascii?Q?QG34dTAgnNaPfp3Xv+4M5r1b2gLOsd7dJf3t1uKK+EOw2+lMYGzlk3Tj9hKR?=
 =?us-ascii?Q?IsweEIgV9xTw9ZlY0Q2q2FjjH13GJXG2B5Gpm2LwVgpnyGXsQsgT6z0Tn52i?=
 =?us-ascii?Q?DdmySA1ID9xLHozLClW9Soa3SNf43z7zzuyOsfQM5YHJi86RfeBxM2w/ezjy?=
 =?us-ascii?Q?lXRvPVUrUndEqPBrioN8xNGYDFtRkR+OSgmFzBwvp/+qmDOtGs4W/AmAZ3tQ?=
 =?us-ascii?Q?LqmUZR2jnZvpNMf6em1ECb9wHjeNrmnC62zjhgDVdeTzCj1aS+yfAlq9FOzJ?=
 =?us-ascii?Q?oHH3gUQoSjYJIwT7A/n8qhN9rlbGppD47fZbw0+WfyYp3p2/P43V4um+5Ge4?=
 =?us-ascii?Q?U9rTPeAtbUypQPtaD5cQ5cAm2bG6Dc8npXnsAGKPUcfu9MBY5EfC1QQ7sQhr?=
 =?us-ascii?Q?cuINg58sZImdrPOGvbkJbjQuvSvkX6LFNOcrc9hDNa27IBigOT5Ok+zrYcNX?=
 =?us-ascii?Q?zrQC1a9rG6L8Io9FcVRtz6SOdKlHOisNTy0RUXCt87j/wLdgUThe8SfS4F1t?=
 =?us-ascii?Q?WGt7N9Z3q53OX59RZSbMWSR/q+nrnlp2LCFecY3a?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e4ac00d-3c0c-494b-562e-08dab1b1f7a0
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2022 09:11:55.0979
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 32d2XRDTm31B5DcwaPBgViIJPJ1khrtwzxlyT9X5oj8COGUeGd/rEZPgMKSzS5z5U2f4hHwi4sm6XCZKjEi4qg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6052
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Benjamin Poirier <benjamin.poirier@gmail.com>

Fix two problems mostly introduced in commit bbb774d921e2 ("net: Add tests
for bonding and team address list management").

Benjamin Poirier (2):
  selftests: net: Fix cross-tree inclusion of scripts
  selftests: net: Fix netdev name mismatch in cleanup

 tools/testing/selftests/drivers/net/bonding/Makefile        | 4 +++-
 .../testing/selftests/drivers/net/bonding/dev_addr_lists.sh | 2 +-
 .../selftests/drivers/net/bonding/net_forwarding_lib.sh     | 1 +
 .../selftests/drivers/net/dsa/test_bridge_fdb_stress.sh     | 4 ++--
 tools/testing/selftests/drivers/net/team/Makefile           | 4 ++++
 tools/testing/selftests/drivers/net/team/dev_addr_lists.sh  | 6 +++---
 tools/testing/selftests/drivers/net/team/lag_lib.sh         | 1 +
 .../selftests/drivers/net/team/net_forwarding_lib.sh        | 1 +
 tools/testing/selftests/lib.mk                              | 4 ++--
 9 files changed, 18 insertions(+), 9 deletions(-)
 create mode 120000 tools/testing/selftests/drivers/net/bonding/net_forwarding_lib.sh
 create mode 120000 tools/testing/selftests/drivers/net/team/lag_lib.sh
 create mode 120000 tools/testing/selftests/drivers/net/team/net_forwarding_lib.sh

-- 
2.37.2

