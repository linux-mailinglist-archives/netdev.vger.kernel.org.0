Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6203691FA
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 14:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242433AbhDWMXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 08:23:22 -0400
Received: from mail-dm6nam10on2052.outbound.protection.outlook.com ([40.107.93.52]:10176
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242301AbhDWMXT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 08:23:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NBu56+kllyAuCFhEgCCdEZXuM6y+apJ9DtY37gqBKJ805OZ1BjmWqu+TY5k3RuNNHxyMOEdh6wEzQAAe7kwt7wYuR2AJXx56zpy6Ol+M75MH62YyuH0MAIQbQ66GoYB/xonxMqPMLG0KZvbiMTpi+HmhE/W2rnkZ+wDIt1tlBOflULZVbSBHIrxOU/JxLFplTIHgNUAfop/ImDd+5DJrWPqIsT6IkiOH/nk/VmQ8mPjJj3Ksz6UWgODjeD9NI5uxdIxyeFAS5wDXVDY0Wq0Xlwjnw4/4HNRFkLEMOLR2OMlDBUQlFKUI+2AhS2LVHTiINOrqEpRwhew5uqjXV+bg2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p6pW1DIWgp7j7KLT55UDFMcSL4Y9sitWyM0X9N+57eg=;
 b=JM321XHCr8ZqWvzwt6wrQ6BrFwsLgxG38ybxxArITScaWX/kiTNjlzbOMM9YP2wZpYIn0NPHDBEhRv27eLyKSZEZ1iCoxeofojcehr3yGcPVNWVWN5Z9w4H0Tcg79UQrrQ9G0NMWZBXeLTYVlQKcUA+gFTB83CI0oBKYLhmsYyuZswbJsrYzFGHVGwa71d2zYlgFt+/lv2BON+Huj6SrinasdecW7jpHr6UKRV84tBqnVl358+RuMYJHcu3twUm4wFbwdUu57cTJPLc2cyUSPrEXkaaRNIA3FQVy17VHUVgoNm+fSfrH5AUgWEsdIscGHJhn3aZAGI4s7Rq+TUUFvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p6pW1DIWgp7j7KLT55UDFMcSL4Y9sitWyM0X9N+57eg=;
 b=k26C6my/mS383jyCqdGIcL0n95oTz1h4ps8Wd5JhIdBWY6NWiNs/bzTNwc15BSbOWIqmLgVD2586KX0amztR8+WS6/nfrvPKUPCJh3BIQNMWJJaCYf9OCCCyQmDLaqpWDnIKQAiIJImeSEkNrlDEQZbG7zvAmCd7ym/rOgl1Iu0g2E5iFNLexYmHf+WCUtq8tlUnsxEqBgIVwdtCXaPZdJRzDg9dNt6OuRPkPGhQkX2uuZQWqX2L21OzdDNlohFC7ovciEhwWknLx5zXh9gwEhkyCSSmjBKDRvvxJ1LNGrLg3YycQRLRtgaufRKwapuLEqzxrax6PWgHaAbyw2okjg==
Received: from BN6PR12CA0039.namprd12.prod.outlook.com (2603:10b6:405:70::25)
 by BYAPR12MB2983.namprd12.prod.outlook.com (2603:10b6:a03:d6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Fri, 23 Apr
 2021 12:22:42 +0000
Received: from BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:70:cafe::33) by BN6PR12CA0039.outlook.office365.com
 (2603:10b6:405:70::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend
 Transport; Fri, 23 Apr 2021 12:22:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT049.mail.protection.outlook.com (10.13.177.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Fri, 23 Apr 2021 12:22:41 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 23 Apr
 2021 12:22:39 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <mlxsw@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next 0/6] selftests: mlxsw: Fixes
Date:   Fri, 23 Apr 2021 14:19:42 +0200
Message-ID: <cover.1619179926.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b70f3910-6cc0-4526-514c-08d906527e09
X-MS-TrafficTypeDiagnostic: BYAPR12MB2983:
X-Microsoft-Antispam-PRVS: <BYAPR12MB298372573076644D6F84F4CFD6459@BYAPR12MB2983.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +eW/Fzf0Z3urWx0spPJ/SHI5zEA+0jrG18vOlb8Eof9YzniqOA+25oVgnFViJlqwC3+MxE5y1wN7d8kw64wv+wN5Zkajh1ZH0Lo3zdwvHjAPGggdb2tq0/mluOn2NI46GYgRWshNXsGufEfPo2PdgNjKVM92MT25UI1kVlpbzp5hxuZzaveLqwydA1XwF5uktY/Y6XNDDjwFpeiPeZDSgu0oO4Rrv3jws1ZLT+HlJP4bs3L7wG6cgsIcTr3GGqz6I2dyBheeL+AM6Kkk5X9Vnk5dOzq/oPCVRzzluB1uso23NhqE2eAXQW57LfgiR8cFChAODwAyFX2tTAl/r/E4OPR1wpx8YtZPvZo0DsiRPgrmyM9fDE50cmWXEjeN3PkyLs+EUqsw59RoWWucr/uRBX3Oij/3ydETzjQcaPPH3rE//aujFKi2CSSRzazNKwsbFXbjeUfOt7fDOfuLhmCI7hUG2BoWPEDmKQGKrH2IGj5GOpS6jL5SROikEsZ/lebwSmkjGpTiSinQ5J4l2Zaz9jyHDU4vNTlBqS9jkqAuzrQf/FCuA2pIYdx9etZGbvYolbI2swGlRFFt9pN6Al6+sbLTj+UnnWoW8+049X5q2zNO4QEdt7mjap0sg4bTCx8AsHCvPhLBDh5ePpiWx8rmxlGoqBCrOjtRJXiP91haYGc=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(346002)(39850400004)(36840700001)(46966006)(4326008)(6916009)(2616005)(82310400003)(478600001)(54906003)(36906005)(107886003)(316002)(2906002)(16526019)(186003)(36756003)(8936002)(47076005)(83380400001)(26005)(356005)(426003)(36860700001)(6666004)(82740400003)(86362001)(5660300002)(70586007)(7636003)(70206006)(8676002)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 12:22:41.9491
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b70f3910-6cc0-4526-514c-08d906527e09
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2983
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set carries fixes to selftest issues that we have hit in our
nightly regression run. Almost all are in mlxsw selftests, though one is in
a generic forwarding selftest.

- In patch #1, in an ERSPAN test, install an FDB entry as static instead of
  (implicitly) as local.

- In the mlxsw resource-scale test, an if statement overrides the value of
  $?, which is supposed to contain the result of the test. As a result, the
  resource scale test can spuriously pass.

  In patches #2 and #3, remove the if statements to fix the issue in,
  respectively, port_scale test and tc_flower_scale tests.

- Again in the mlxsw resource-scale test, when more then one sub-test is
  run, a successful sub-test overrides any previous failures. This causes a
  spurious pass of the overall test. This is fixed in patch #4.

- In patch #5, increase a tolerance in a mlxsw-specific RED backlog test.
  This test is very noisy, due to rounding errors and the unpredictability
  of software traffic generation. By bumping the tolerance from 5 % to 10,
  get the failure rate to zero. This shouldn't impact the accuracy,
  mistakes in backlog configuration (e.g. due to wrong cell size) are
  likely to cause a much larger discrepancy.

- In patch #6, fix mausezahn invocation in the mlxsw ERSPAN scale
  test. The test failed because of the wrong invocation.

Danielle Ratson (3):
  selftests: mlxsw: Remove a redundant if statement in port_scale test
  selftests: mlxsw: Remove a redundant if statement in tc_flower_scale
    test
  selftests: mlxsw: Return correct error code in resource scale tests

Petr Machata (3):
  selftests: net: mirror_gre_vlan_bridge_1q: Make an FDB entry static
  selftests: mlxsw: Increase the tolerance of backlog buildup
  selftests: mlxsw: Fix mausezahn invocation in ERSPAN scale test

 .../drivers/net/mlxsw/mirror_gre_scale.sh     |  3 ++-
 .../selftests/drivers/net/mlxsw/port_scale.sh |  6 +-----
 .../drivers/net/mlxsw/sch_red_core.sh         |  4 ++--
 .../net/mlxsw/spectrum-2/resource_scale.sh    |  4 +++-
 .../net/mlxsw/spectrum/resource_scale.sh      |  4 +++-
 .../drivers/net/mlxsw/tc_flower_scale.sh      |  6 +-----
 .../forwarding/mirror_gre_vlan_bridge_1q.sh   |  2 +-
 .../selftests/net/forwarding/mirror_lib.sh    | 19 +++++++++++++++++--
 8 files changed, 30 insertions(+), 18 deletions(-)

-- 
2.26.2

