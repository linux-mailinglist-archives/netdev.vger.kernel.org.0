Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 671A31E8920
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 22:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728302AbgE2Uqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 16:46:42 -0400
Received: from mail-vi1eur05on2044.outbound.protection.outlook.com ([40.107.21.44]:6087
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726975AbgE2Uql (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 16:46:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=auI67AW9VG+M7BOJJpU6k0mo3c/j9YAPtEbQrNe7vp9vUO+7aFq3pP9wGn9/ZJg3hbDnfNzmyOrRGqtnutdH8CXEsuWFHkxwgJds140q0mcYHl+Hvcb/ehrgCm/N3xpYzQGh/1RG3mCpQlpcPe8Rur/qkTVX0TiBWQGJHmUIj/jakKeanhPgZCSdRJJ9HtIa94uxpDgngpxyy5TxnGjzQgZG3UWK27sqnf5pfkc7b8FzdZQqh7b0OcpRMK1LG/xPGIEfW6ZMLdjrVr/Mchy5hazkw8BM0RUrG+MAkD9kj2UGmJ4vNY0ECnEmxWpRYGt7gMCwjKdST8G70X8aW1N5QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KCgg3ACzgohdJjHa3meRhJxaRJRX7/x8TFUyxGakG7c=;
 b=dK3cMwjs0YzMxOQ/viiX3L//mOPQiguYN1BTb+XlEY/tnOvPBaYpZHR19RAc6esrxJZz2k/9kwJtbKGqgLjAbM1JiSFiFju/yLT5hWtvhfTpwi7SGsDlITCnbQHrZcgctOEMVlniy+wA4QKIlKSafUDzIG425jgP6gq5oH87+HlHmWjBO9O9LBL60d8ibrupRp3zu30jZiYVBdvnBV6N1moYBetC9asG3UWwhnDg5KD+os02cvpBVeKkLR/Ul0PC3QHt42ozOFDxhsPLAZijjOJKj+hU52S4iyS6rgCPpO3SvmXyWH7dkQlGUHN0PhldEqTKHT1oO39R1jUWRLGCUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KCgg3ACzgohdJjHa3meRhJxaRJRX7/x8TFUyxGakG7c=;
 b=AZe1YJ5yRs78vrvruHM9ABoR63lJ6S9lSJzdewwtsD239JTLeo50K3itt0ZI7IO70V5kOYpVncvYtH4hEyGYlrdo3Z7N8fRQGzivWxx6iYOtcuArfgg6A3Y1qFisWZ4Nx0coDqV9OfZg5CINJ2DfB8voEl7aKAYmp3OMF+DoRwA=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3359.eurprd05.prod.outlook.com (2603:10a6:802:1c::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.21; Fri, 29 May
 2020 20:46:37 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3045.018; Fri, 29 May 2020
 20:46:37 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net V2 0/7] mlx5 fixes 2020-05-28
Date:   Fri, 29 May 2020 13:46:03 -0700
Message-Id: <20200529204610.253456-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0025.prod.exchangelabs.com (2603:10b6:a02:80::38)
 To VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR01CA0025.prod.exchangelabs.com (2603:10b6:a02:80::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Fri, 29 May 2020 20:46:36 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 49a7f82a-e119-477c-ae96-08d8041161b5
X-MS-TrafficTypeDiagnostic: VI1PR05MB3359:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB3359A6DFB96C5F6A28FD0F9DBE8F0@VI1PR05MB3359.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 04180B6720
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xCrchWxGyWcK8OlJpJQDCeSt339iyxSHfSykJb5tQY7RQ/hNarVIP6+rGOxqG9knGrlqRTt9BVLAFuPmOTCCR5yKjBBJQFfpgkQi9U0j9JgNwHKMgq7Z8UPaUQv8TSmTnjl1uzoKsMaDg+XlYukQq2jK+Z2vQ9T/gkpENHsXUrB0Ud1HIzhYJsLJbidvtS5WUXl7MHShwG/AtGiIbagBz1LzhvYs0p8u7ApHVYEa0pL2EH6WL5w6WKVxvdn1strjU18acUC3wEAvCn3nQaoozpNGgpT5yvZlPj+B1voWO9Gz3d969y95Jc6iHv1fXyBvR311PtMP1niChkZ77/vnpQBe4D2PiYMwvrRL62I2WjP0706iTt6ftgbTA7ssmLaJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(366004)(346002)(376002)(396003)(2906002)(66556008)(86362001)(478600001)(956004)(2616005)(6486002)(16526019)(6506007)(316002)(186003)(26005)(83380400001)(36756003)(66946007)(8676002)(1076003)(8936002)(66476007)(5660300002)(52116002)(6512007)(107886003)(4326008)(6666004)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 2E1bGoclWTd1W4tc2VFRXFdakz3CpAik/TFm6W0zm4Oqx7Hagcyz21/xa2EM6wJtcVdui2FqOS42WcCVEGFHrs1qSNHJw8a9QevimDgKF9v8qyfkIF1x/SJ8rle1WhyzMN72iaVzjK1lS5o8iXhWNZQ9WIl8Opnde6nxMwKJa7ja5I26IGmmYUSMn//4XglVwMnIGM2rXp+PxPDb8y2Gpe15b7mRAUUkOigO42PuBPrhw1xZg3dx8Isv6E8ZTII2BGTB0GXJ2vkv2bpMvwHy7+2JsuimUpsokmHP7Jw8jZM+E5Z5Uh1rNn63aPwIJs21is78+1g0yb2x6rtwpt11BwyZpt5lQKXCVzSJBY7OXoKotGMmcvNiKVleSoZDwUBO120UZrMkcBido/2I4G4cmNwElVslEWmugqTnAHftE5xmCTLRtMQQVGq0oi0t4tm/8L6C7dzb0TRxT/dLSC3mm5txlhwAj389kpUSUgOxRlw=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49a7f82a-e119-477c-ae96-08d8041161b5
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2020 20:46:37.6694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cSlBDruTqHbaV0AcimHImUULgXe7/7YMSwQAfJxvE70jpJq8h6PRMoEJ8rzIuqJDn4S5nlyLUKXnasb+qVtFOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3359
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave/Jakub,

This series introduces some fixes to mlx5 driver.

v1->v2:
 - Fix bad sha1, Jakub.
 - Added one more patch by Pablo.
   net/mlx5e: replace EINVAL in mlx5e_flower_parse_meta()


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

For -stable v5.6
 ('net/mlx5e: replace EINVAL in mlx5e_flower_parse_meta()')

Thanks,
Saeed.

---
The following changes since commit 7c6d2ecbda83150b2036a2b36b21381ad4667762:

  net: be more gentle about silly gso requests coming from user (2020-05-28 16:31:30 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2020-05-28

for you to fetch changes up to a683012a8e77675a1947cc8f11f97cdc1d5bb769:

  net/mlx5e: replace EINVAL in mlx5e_flower_parse_meta() (2020-05-29 13:07:54 -0700)

----------------------------------------------------------------
mlx5-fixes-2020-05-28

----------------------------------------------------------------
Aya Levin (1):
      net/mlx5e: Fix arch depending casting issue in FEC

Maor Dickman (1):
      net/mlx5e: Remove warning "devices are not on same switch HW"

Mark Bloch (1):
      net/mlx5: Fix crash upon suspend/resume

Pablo Neira Ayuso (1):
      net/mlx5e: replace EINVAL in mlx5e_flower_parse_meta()

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
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 12 +++----
 drivers/net/ethernet/mellanox/mlx5/core/main.c     | 18 ++++++++++
 7 files changed, 84 insertions(+), 43 deletions(-)
