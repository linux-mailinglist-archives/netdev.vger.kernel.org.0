Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62A8B391437
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 11:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233732AbhEZJ7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 05:59:42 -0400
Received: from mail-mw2nam10on2047.outbound.protection.outlook.com ([40.107.94.47]:49825
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233264AbhEZJ7l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 05:59:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UXtkEn0VU/exEhfAmpCOTtS1728PF7Y73rKni7KsnWn7v+6tWXCA39q4DTHttqWEyLaJvz9QDsnJ5yqdp01sGdMtWVe6Ci77ou009j0ilAwn1rVsZDhKQamcLdFdJHWGkNgsDQm0IfZIycIBahEa+JksTr4USoVDNoCtw9NQWtGlzvSgfSC/Kkt0J9Tz3o8Lf2pViT2jp4Az9CNndwTIKNtZOMByxb3Ufa4KOEfTEgncCs7lk5qANqjxLYNwjUHaKL51t1YelH5JS2fclarBo5kg142EHOWtcCjYgIvTcFAfE7GVCDpKIdDiXmc5+7SZgJDbFdS9nkFy3MUj3IwMMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HAuNS5Fxdim4pWI+tb4q24YkJZG2PId+crCga4/qHCE=;
 b=Sh9jtIryRuplhEN40K5rZybi+cgRJorihMo0fmkQCPl/r82R5PxYI9g7lTC1DM6nbO+Rfg7z/jeTVwM8fRm3RAMb56w6kMbxF0xGgfmU4AQ9X7QvCcly60YpMv45rRTFNH2MOOCV251zmAM6KciucfwjdWYqaMAixa/yJGQCGZ4Od2IpX/duoWtjdmeMpVKGuGrYY7Bn1jStunzS5sp6P+smO+zxQ9r+MamKOmzYp0lPe1Z9boumIVqbaMh+FeJDfRQ3QG++M8VJcnx/qLuZABHf2tosDqAU7DBLU3q+zCsL8OHB4Rc2iwec5QEvKUGS7VR41AchztCMgCwsVMxjWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HAuNS5Fxdim4pWI+tb4q24YkJZG2PId+crCga4/qHCE=;
 b=j/UuUhIomm/hmvnitA4MdEozf4hlVgpPvzYyve4xh3qw8u2Ox0F1a3QeYUx2zDI8TAzB6iUMoJVEGOfhCUgO4JbIh91W+k19cSimJfCFzP7ExRU3IC85/itr6iu+TaiNUhTtT+OVdGTzpbQO0LytGnnSsjgNgb3x6vkkZ/+TFYSnwziHyD+M42bxSHi9jU+j1F09JNv+M1RtkbqrR36V9uaCE/Joj3PrHx6HN2OcfBQuIW8+A3mNPLTuE0p2tegNBRXo7UCuL0r0jAiHGoiROuIACinGrTzrCYLo/YluEzMKIs4BQ3JL3kiOQ21c5Fm3iJMmUu10PVMZVY+7RmsbOQ==
Received: from BN8PR04CA0027.namprd04.prod.outlook.com (2603:10b6:408:70::40)
 by MWHPR1201MB0269.namprd12.prod.outlook.com (2603:10b6:301:5b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Wed, 26 May
 2021 09:58:09 +0000
Received: from BN8NAM11FT031.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:70:cafe::b4) by BN8PR04CA0027.outlook.office365.com
 (2603:10b6:408:70::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend
 Transport; Wed, 26 May 2021 09:58:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT031.mail.protection.outlook.com (10.13.177.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 26 May 2021 09:58:09 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 May
 2021 09:58:08 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 May
 2021 09:58:07 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 26 May 2021 09:58:05 +0000
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Moshe Shemesh <moshe@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [RFC PATCH 0/6] BOND TLS flags fixes
Date:   Wed, 26 May 2021 12:57:41 +0300
Message-ID: <20210526095747.22446-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 915fe5ec-4102-498b-2ed0-08d9202cc45f
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0269:
X-Microsoft-Antispam-PRVS: <MWHPR1201MB026979838DEEB7BC4DDD51A9A3249@MWHPR1201MB0269.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YWdPm/aylXVDnur3LNFdQH3Eee0QhKqOniEN8EbJ4ZLGUOy1F0fspt7B6qLJghpcgk3g8YTXdizLCCmPdAwfaFcw/0zGUFx2Vlqp84EFt+mWWCAsOuNEhUFxXOHUm3nAvOS179RDqv1WvvRAQ3KYeDprQHAX+jKXyUQBEBzDBaLenoMnluaRz68jjYfGo6UV0efKuqB4mVxOCOz70czCoOe+I3hish6pcAIbWIO160N9R28AbGVHpBckORmHlaqoM6RK+MMuQ00IGJz3wWAREb8wq0d4XpdZ9YBxxO3XUm/a1A6/0sLt8gD+JvWN4w8nX4ivAVdd2/LO37XP9bB1dd3wotY4yIh/XbS0CW7bJU63+Gbd2tHOmSPUtD/YgTqg83k/BEnb41ukGx3xRlAEWy5lct5PXVC7p165RE1QruQ1iXzW2CxmLKjr5TIbu90d77H6lkzFS4v1RP7T+hrrb/6rTg3UdCV2JdwyFgiHgefkUHoEpRgr8kI6YdqE16cwOcL1nxnNmLBCroYUvhoeXq7arx01s80QnE0pUSDRr3mnkzreVcOENzgFE+y7RlG/8IjzZNnqDN9iywqnqwDoEphVeGf/lU9CndvlZISaIShXRDxRTlDHXIM+uQPs+IzI1rCYiPAiaKmWP4Lrsnd3U5Dc+k/TzSCRijaAWO1rJoI=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(136003)(39860400002)(46966006)(36840700001)(6666004)(7636003)(54906003)(356005)(82310400003)(36860700001)(110136005)(316002)(47076005)(86362001)(107886003)(8936002)(8676002)(70206006)(70586007)(2906002)(82740400003)(5660300002)(2616005)(7696005)(36756003)(186003)(83380400001)(4326008)(26005)(336012)(478600001)(36906005)(426003)(1076003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 09:58:09.3078
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 915fe5ec-4102-498b-2ed0-08d9202cc45f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT031.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0269
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This RFC series suggests a solution for the following problem:

Bond interface and lower interface are both up with TLS RX/TX offloads on.
TX/RX csum offload is turned off for the upper, hence RX/TX TLS is turned off
for it as well.
Yet, although it indicates that feature is disabled, new connections are still
offloaded by the lower, as Bond has no way to impact that:
Return value of bond_sk_get_lower_dev() is agnostic to this change.

One way to solve this issue, is to bring back the Bond TLS operations callbacks,
i.e. provide implementation for struct tlsdev_ops in Bond.
This gives full control for the Bond over its features, making it aware of every
new TLS connection offload request.
This direction was proposed in the original Bond TLS implementation, but dropped
during ML review. Probably it's right to re-consider now.

Here I suggest another solution, which requires generic changes out of the bond
driver.

Fixes in patches 1 and 4 are needed anyway, independently to which solution
we choose. I'll probably submit them separately soon.

Regards,
Tariq

Tariq Toukan (6):
  net: Fix features skip in for_each_netdev_feature()
  net: Disable TX TLS device offload on lower devices if disabled on the
    upper
  net: Disable RX TLS device offload on lower devices if disabled on the
    upper
  net/bond: Enable RXCSUM feature for bond
  net/bond: Allow explicit control of the TLS device offload features
  net/bond: Do not turn on TLS features in bond_fix_features()

 drivers/net/bonding/bond_main.c | 6 +++---
 include/linux/netdev_features.h | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

-- 
2.21.0

