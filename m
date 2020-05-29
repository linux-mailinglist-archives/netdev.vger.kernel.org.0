Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0D461E7B7C
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 13:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725808AbgE2LRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 07:17:20 -0400
Received: from mail-eopbgr60067.outbound.protection.outlook.com ([40.107.6.67]:13233
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725306AbgE2LRT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 07:17:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ArlOwg2h9g2C+hRCWzHsRXAS83eSbGojgaQbzIBUrsEdinuRCQPDy7Cm7BNcCImzEZm/oG/Gs4TyXJynAhevyyB1w2X/cFf14Tgo2xdz+nyslCS2I0BR2v3TgfOq49aiA1Sqwf3qokcgCOltBVONJ2v7KBmCWkvUaip2ofcYEpIyckZ2kI74W74KiCht95RupDaFpTurTdLP2IYJ7B5cUz/CyDXF5Uboes+UCydgXLxk2aaxjcpL+qMmaL5YEJAwqTvyuvEJLcIITKIvEgoy2Fmpt8mIIuXQAo3UGYZNoibj82td50ofLrYK34YVdg3cSW0w2tv9kpAEIBVK00clPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UOq5q/dZeeJ6FYIXiQrvbVRn8ekyGvGQ8wlxVaxbY/A=;
 b=lAYciWttrX0Mc3EjboieBUeR4Tta5bC1UBvOyf5T960Eg0SjaMXineKeVg7YJGDoBo9HqVU/97OZBQhf9ut22hhG1Ms/McV7elHHJIdOmFp5oEIvHbolrmWaQj+Sp9by1CtYqbjqlwxMEuyKiIrQzAcPnsfo5EHhoM5DPjcnK4pNUv/9tZxzlCOcMe/TTjy5e7lBT95oSMcv0H4qY5c8Zkw8eMwtnAEU5xbV9ptxznBxiQmxo5wI1tTClOuQFH/Mpm7ImvjqEfuRNeBgaU/kzOH3u4lpf+bUmpuThG32RKRsJ8wqLhbZIRnBvLX1bP7tW1XCL4Tb2SvJQE9tOupiBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UOq5q/dZeeJ6FYIXiQrvbVRn8ekyGvGQ8wlxVaxbY/A=;
 b=e+MjF0hwOPCq7xN/2WfeDnXWM2rFfBYOtlDvG5jiMxG9jRFY+Hym3+jPfJBQCVjjpe3C6RpY/OvK2sZitgZxPwYD0BLrYm95va36E5bLJ7ElHX56LatfEn/febwx7Eez2Sa9eIMxEzJs1wY4BurJD/38/aqPI8YbUzOGRNXQ+GE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3468.eurprd05.prod.outlook.com (2603:10a6:7:32::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3021.27; Fri, 29 May 2020 11:17:16 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::9de2:ec4b:e521:eece]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::9de2:ec4b:e521:eece%5]) with mapi id 15.20.3045.018; Fri, 29 May 2020
 11:17:16 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petr Machata <petrm@mellanox.com>
Subject: [PATCH net-next 0/2] selftests: forwarding: Two small changes
Date:   Fri, 29 May 2020 14:16:52 +0300
Message-Id: <cover.1590749356.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0032.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::12) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM0PR10CA0032.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Fri, 29 May 2020 11:17:14 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f1a68d8d-bc40-4234-a4d6-08d803c1d7b2
X-MS-TrafficTypeDiagnostic: HE1PR05MB3468:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB346836FE469E0059407C458EDB8F0@HE1PR05MB3468.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 04180B6720
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GNpIPwtd+gLoLllhxdxeLG3DqYCvQlMsS+wlmLpzafUmMaOhX1GImOMQHJTyCUbVW+EbY6aN9P2VsoeD8HolycRo44kLx5bRTeyMtC0ybSA84BJlRUXa7f9eCE7vRMTihhn9Y/5MqTrtxu20cryMphq/G7tGgk9a0mqUClEPhjj8az14pKn6+NhYPacHU0PIXHbD1tBTQ7bYL0GsBPYxSgXqOJiYmSqVHAyzFT1NTkNEGiB0zynvPfi2Z/DXgnzOondm6Mos+PWtFu/6SE5nVAVDts6C0uKIP23Qhra/XwVGhA3PEK83XPW1stlb+XGwdmk3zvckdt0WGto+e8isug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(39860400002)(366004)(396003)(136003)(6916009)(8676002)(316002)(83380400001)(86362001)(8936002)(186003)(107886003)(16526019)(54906003)(6512007)(6486002)(478600001)(4326008)(6666004)(6506007)(36756003)(66476007)(66556008)(66946007)(26005)(2906002)(5660300002)(2616005)(956004)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: voHZXaefL7GOGgpkZGhbWD+pZ0SghswHR6cReXXeRrY2N2wwRpiJOxZNuXbpLqD50PYEyaWBul+qVMZQWVZcxvQU5n5WfBoUkIqOB0ztUTson/7+8KbXgspet/TNgmQKoEde79RcMsYuoYVDi6bgfN8sP7xzMa8uh7ijXKWO2xUZqjhv/f17VplXuPIF6m/X39WbpnrXlYTsmeadtQ2zvCnwvk6fqwG9nPIOC82LGITyLOor6Q241Zl9hWOtXOfbp22cHnwIjhGQpDAnikayKkSG2nLdeLLsDLxxYUIIxUQA7xlmLt+vF1LdTreu4eGm0z1C3f5WEGcc5x9BZ/f5pH5lQ3pGezKxkYImEvQgkuDpCM3NW15UNXyUD7IqUHOTE+UxG/2k5ixspFar3x/4Q5841ADdYo6rkASvNM/iHRM0BuOCBk/f0Dmf3y5VWtGa52oSkX0s3hyhNkAZg6ODrDj4w8Qb0Gk31iGsKsXlrMQ=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1a68d8d-bc40-4234-a4d6-08d803c1d7b2
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2020 11:17:15.8423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pNhIlJ1c0B5twTTbo+Ro2fqRXMeQiAibUNzAzH7fe8Eu51bpuiS61/JRrAw0xZtWz3VguIDqvoNsC/HTT40lxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3468
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two unrelated changes in this patchset:

- In patch #1, convert mirror tests from using ping directly to generating
  ICMP packets by mausezahn. Using ping in tests is error-prone, because
  ping is too smart. On a flaky system (notably in a simulator), when
  packets don't come quickly enough, more pings are sent, and that throws
  off counters. This was worked around in the past by just pinging more
  slowly, but using mausezahn avoids the issue as well without making the
  tests unnecessary slow.

- A missing stats_update callback was recently added to act_pedit. Now that
  iproute2 supports JSON dumping for pedit, extend in patch #2 the
  pedit_dsfield selftest with a check that would have caught the fact that
  the callback was missing.

Petr Machata (2):
  selftests: forwarding: mirror_lib: Use mausezahn
  selftests: forwarding: pedit_dsfield: Check counter value

 tools/testing/selftests/net/forwarding/mirror_lib.sh    | 6 ++----
 tools/testing/selftests/net/forwarding/pedit_dsfield.sh | 7 ++++++-
 2 files changed, 8 insertions(+), 5 deletions(-)

-- 
2.20.1

