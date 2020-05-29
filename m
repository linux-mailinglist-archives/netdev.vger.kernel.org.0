Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C13B1E763C
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 08:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726052AbgE2G5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 02:57:19 -0400
Received: from mail-eopbgr130082.outbound.protection.outlook.com ([40.107.13.82]:44867
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725988AbgE2G5S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 02:57:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eskTo45UEdKIsEUSg/p99D6mIKgzkhngK7bd6m8iCw1X6I0Und9vuTTWJw+B/+d1f7tiYeUIgSsJQtdYoGTBXVkoxKabgLCW9Vi+9FUFXRX1ttsTrzl0v8uSWFQAIY6SJHZxdlp2jjh4zz2tlW86WmcTki9AYGxfzqrdxxnateYg+cVt9A2OmdC9ebs8Nv14csBK9kfBaUzNOfPdFFKd+Sp9q7Zyph0OmzMgc+Kf3pBDEeXoMge+1/hdFVrzDEXeJiAcwUZlY1zPmodregV8zcGHggA3FXdyqO5+zZFyoDdYBLUKrvVAi8UrGksAB6/EIO0OczTsddXYzoB9UVCDaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F2FclwByQB/K15mDmC57MUT+XLk2t26s6uCHkb1mlqQ=;
 b=JrGe9fFPovCSiTk/HnZUzsga6SCzmSZB6tyHWhyLnvaltnCuV94gFR/vZrR6ESelt5VDzRiSzGp5e/5RPiz4P7sllfxcuMkGRfIGMa2HOwCuP2MUiDkmXgADVkrZwCsgY7mOD7n3uieRB3PEmw8OupGzgNa/m7wxECN1L/x23nMC4BJAHc3cglEGC8Ysi9TTB/2omXueo1n7IqoOagpdurAp6fzKb+DE01b5NE5GypkgVbrYmVaAVQP36jjq0ZWBjs78b3Y4RFozzYn+0p2BD8pCi+LJenD9W62UC3W5itDRbTeqZLhKltfkQEpzYaRSHO8SN0y0rZXAQvbM/yPueA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F2FclwByQB/K15mDmC57MUT+XLk2t26s6uCHkb1mlqQ=;
 b=gYNmWjgun+Vo9Xhmq9umO2WQifPT3ZPP4ej1WYDAMTLPOMYpzZDkJxW0t0lp6zgLtzEIzrNB+9D2dl+GH3fa6mJ8xUvxjDi1PW54ovw6GCCthGfN7QqUYpQCYUXLzb9S5JfWRXuC+/mNEJrDy/76QduftbU5tsyYJ6uHh7zCJgc=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6640.eurprd05.prod.outlook.com (2603:10a6:800:132::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.21; Fri, 29 May
 2020 06:57:14 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3045.018; Fri, 29 May 2020
 06:57:14 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, jakub@kernel.org
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net 0/6] mlx5 fixes 2020-05-28
Date:   Thu, 28 May 2020 23:56:39 -0700
Message-Id: <20200529065645.118386-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0027.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::37) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0027.namprd03.prod.outlook.com (2603:10b6:a03:1e0::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19 via Frontend Transport; Fri, 29 May 2020 06:57:12 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2778e6f0-363c-456e-5843-08d8039d845e
X-MS-TrafficTypeDiagnostic: VI1PR05MB6640:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6640D0C637DCA769EC5E1C82BE8F0@VI1PR05MB6640.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 04180B6720
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XE4Vj42yhvZbxzTXUWQerNnVfZPfuf0H/nPfX3vNBXXaVTMbGhIQqHbEiRk6mYbV8TRCtcTernxjnu7y2lDOEBjngBAzWLV2G2AknZAfC0ehuRbKiwanRhCK7/4aOT4NRB3nPhgv6emJ41glMejG2CN24oVyrTpU6JXsx4noMsTaIavNmfeL+zLyTOEE0UDuQF5aRPR1vzy87x2yYbfoD6tqnIwRYABLlQfkPx4BgqEsCBvBOSOU60PEHDJ6MQzjjL/ZcdW4E0PsnqFQZI7ePX2QK+Is3I6Ugv1v7ZbN+EcYmV7uc/efS8jcLntcteDy91003xMZPdZ3LmnfhOJBSPX4q2yxfyg5QlaNW4ssW4WJMR0yO9fCjiZPEZCfu1eG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(83380400001)(107886003)(2906002)(5660300002)(6486002)(6512007)(86362001)(66946007)(4326008)(1076003)(66556008)(66476007)(6666004)(52116002)(8676002)(36756003)(316002)(8936002)(956004)(2616005)(186003)(478600001)(16526019)(6506007)(26005)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: l8nweRk68peZUEk9jJgyGPdykMg9pUV1Jt2RL2XIcvXbyc6i6bjSWd8xRlYwZ7Dyon7jBAzQ6Iv1/SB2cLeHpzl2ItgNpZ1vk4Pilxh3J0ecV0/5Ol1AkGdUcxC/YN2ViG9TeFWqNcq2QyOkUTw/8g9VCy+FL/cl9Y/W3xifLrmK/J4C6xYGPBhP2CQUqgBPMhrqWJAX86tXjWOqqq5+rKOeP9Gklxrkraxxbs6fTEoA9lKQGeBaZWxlZzWyWuitf37//TbfempbKlB35kslpjjDZlANbPqaiNnG1jMgDQqzsR23v3gHT4nCFyBRdwX6ddJwKYZoDd02nbFnpmKO/nG2w5hDbGqvwrxGiQq/HX7MoiMaNSwwZwwYKp2JVEYpRcofpr2qEZ7W6gTl4G2BgJ97KUIK/7JXCGMOCX/jNfOP9mPqjoPKCjlzZXa4VkJYUmC9pLUlZi/G2C2V/nPx5vT39LM5BiyPuIlp+U/e6Ds=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2778e6f0-363c-456e-5843-08d8039d845e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2020 06:57:13.9788
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QUz6yIYmnSm13SXCo06sMTX22ekIJGa5NC9F8lLmrEsWqRQimaKS4TziLx9uAsGayT0ElDU9oPkHbsdn/xdnkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6640
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series introduces some fixes to mlx5 driver.

Nothing major, the only patch worth mentioning is the suspend/resume crash
fix by adding the missing pci device handlers, the fix is very straight
forward and as Dexuan already expressed, the patch is important for Azure
users to avoid crash on VM hibernation, patch is marked for -stable v4.6
below.

Conflict note:
('net/mlx5e: Fix MLX5_TC_CT dependencies') has a trivial one line conflict
with current net-next, which can be resolved by simply using the line from
net-next.

Please pull and let me know if there is any problem.

For -stable v4.6
   ('net/mlx5: Fix crash upon suspend/resume')

Thanks,
Saeed.

---
The following changes since commit 7c6d2ecbda83150b2036a2b36b21381ad4667762:

  net: be more gentle about silly gso requests coming from user (2020-05-28 16:31:30 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2020-05-28

for you to fetch changes up to 4d5e5c2bf43f1ef2d9e51b89f95e871120bca84f:

  net/mlx5e: Fix MLX5_TC_CT dependencies (2020-05-28 23:42:44 -0700)

----------------------------------------------------------------
mlx5-fixes-2020-05-28

----------------------------------------------------------------
Aya Levin (1):
      net/mlx5e: Fix arch depending casting issue in FEC

Maor Dickman (1):
      net/mlx5e: Remove warning "devices are not on same switch HW"

Mark Bloch (1):
      net/mlx5: Fix crash upon suspend/resume

Roi Dayan (1):
      net/mlx5e: Fix stats update for matchall classifier

Tal Gilboa (1):
      net/mlx5e: Properly set default values when disabling adaptive moderation

Vlad Buslov (1):
      net/mlx5e: Fix MLX5_TC_CT dependencies

 drivers/net/ethernet/mellanox/mlx5/core/Kconfig    |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       | 10 +++---
 drivers/net/ethernet/mellanox/mlx5/core/en/port.c  | 24 +++++++------
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   | 41 +++++++++++++++-------
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 20 +++++++----
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  6 +---
 drivers/net/ethernet/mellanox/mlx5/core/main.c     | 18 ++++++++++
 7 files changed, 81 insertions(+), 40 deletions(-)
