Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1DE23062F
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 11:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbgG1JLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 05:11:04 -0400
Received: from mail-eopbgr10065.outbound.protection.outlook.com ([40.107.1.65]:60054
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727970AbgG1JLD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 05:11:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=giELgZwHUwy/q+WK4pYP6jm0ut4lFIlUzsUVrr87AwBOBvL7J9eMI13sFc43aIt9xGd4NWzYn4RKw1acZJPS+AGoLfnN7g/NsQRhEzBZdNIiiKEP5+atOFd5ijSZRN+73AawhaJfCr3M8ITpnCjb8dw3xkjOHP0wrycjhRkE4E66dFf+sdIwnBTg+XK/0leXgtYCaP60xsu/PWXYJdunSwK0ulWlzSPfdm1JWP/vlRfxFXAz+IhzQ9WglBHHLRTMAbLevX1PNbIDMKcU3mG4cXQyb/qiAGBxBPM5kDa+fBzGp4V7P9AKQc6hF94Hw391m7HTzkyS4FdgpyzGQfpF7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MOnOSy/vJaDGFyLEO7WI06kpxIiR4qJREegKlfST4Os=;
 b=mTQAJdTN7aGzoTLy9JuqqldEH+/3xY49uQsCJLkVeGQuQW42HMnS8kJ7SRqo4gg/S2+dmd9psPsgyWNxs6yRZ/c+rEEOqcWpIbAmCThCvTxA7Ta+WCQuUH/CUj7DjRjZjs/U0dkjnMmkiA9zPDQ6PZUKwJ1G142NryYuEgG47mOdBqXMXsehu3P3ODvxpM96v7HiNBwLwyPG1Ljbt58kE7dIL3R3usqcx3t6xPRZIiy1AZji2s10slk5VrN6rjdNi2uARoqMtbVqwWA7UHMQcxxMH3dFbcehmBrA5qpj3IQ4W+OlzIM/08wv+ggH969l4JIhyasT3a3A/ruQNLNrdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MOnOSy/vJaDGFyLEO7WI06kpxIiR4qJREegKlfST4Os=;
 b=lzur0wbQo6oB5Gh6l2FrRB6GlaYPFpxdVsHU/15k7u6d23cZVCpmHIt4pKL4bOnHxhfozZvxhyjVIrn8ypCjOanQj5G24K2BflVjx2YnUtbLUrgej2BjIJZO77g5szVojcqCwh/vglk+S46HV8y2u0EeulRValAc7Sjbf6fVB24=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4879.eurprd05.prod.outlook.com (2603:10a6:803:5c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23; Tue, 28 Jul
 2020 09:10:58 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 09:10:58 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net 00/12] mlx5 fixes 2020-07-28
Date:   Tue, 28 Jul 2020 02:10:23 -0700
Message-Id: <20200728091035.112067-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0022.namprd05.prod.outlook.com
 (2603:10b6:a03:254::27) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY3PR05CA0022.namprd05.prod.outlook.com (2603:10b6:a03:254::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.9 via Frontend Transport; Tue, 28 Jul 2020 09:10:57 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 085930c5-3690-4a3b-63ef-08d832d6242b
X-MS-TrafficTypeDiagnostic: VI1PR05MB4879:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4879520EA73745470EDB470BBE730@VI1PR05MB4879.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zwT4Ys0AilSwwteM5ZVKcEYmgERIq5tA4Tcz50iBq4u5lM+NGgqpCum4Uvby9L1pxcm8DL/ua4kKb54KF3RjC7goyeE8UepmNFQXgwIiOCxgJzMmg8wmAEa1VLIsu4kcBAUC+xAitmotSuiFCfUCanCyzEaFyYs3xoK3IuXzhyfT27Nec3cv6knC+1/jaIe1LlJuPMBoFOH+q1rA2jvGBkC8S7Fi4aXRev+2zI6+8epI1aYhTLN5eFnjuOSkz9gtbQVX00ZTAqDV6Gvd5HgQsM5aY8CFlAIRvyZz63YFCcvluFdmVjF959gEI2zJpcwuBBTz2Fpng9zpAtRJDFmhTNeuA18bsk5bd5aU7OYlO507+m/YfCpqLTFOPlBh9HYx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(366004)(346002)(376002)(136003)(6512007)(1076003)(8676002)(86362001)(8936002)(2906002)(66946007)(66556008)(66476007)(107886003)(16526019)(2616005)(26005)(83380400001)(186003)(36756003)(6666004)(478600001)(956004)(52116002)(6506007)(316002)(5660300002)(4326008)(110136005)(6486002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 5yz1Lu8vX3fxWbgQRNvSZKpLkhS9ZjfJv2uZz/yvMnNE3o8l4/4u+EFfA529JfaDouT5Glp6PSY/8Lp6axQoN2EdmzRA9l5kL1qFbIqpO153400Ryb/ywfnSdLSg4lGwYjOWqW1+M8L/z0dDsV6VI2WWcE9K8exbMqABYd/rXVawDJdizF9IY692J8O7LQoQwCqTiENmujREPqhdV9yxmPteZo5O44uELLsh5mDJUWJX3fpLwQrFtMxVPGWn60isZvBbIP51jqbJfXWzcSObhTPxRU0+YCsvKuIgzoFdGOTnPCAOdjCNy+1sKEKOv585URJ+QGup/Drekh+VoN7xAcMFh3HGgildGkhZx6MAG/7GGzizETkxQiUIK0N1/mcAc+uVTd8Za0zepUX/Tb50mR/EVH1P3X1JIdFFJSkU8+ti7aM6pNFCBOiC12LMyQqjDzztit5PV8s1iTQpXYtpE7KmotsAdOss8v5djGg3uwQ=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 085930c5-3690-4a3b-63ef-08d832d6242b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 09:10:58.5765
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7pP1KLynmbEwgumqtRAVUjufjt962OfZCMmM2F7dQVoTJuF/x04un2e2mbA+Magdc+dj06gkKuf7C/CVGNYiNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4879
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series introduces some fixes to mlx5 driver.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 181964e619b76ae2e71bcdc6001cf977bec4cf6e:

  fix a braino in cmsghdr_from_user_compat_to_kern() (2020-07-27 13:25:39 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2020-07-28

for you to fetch changes up to 0e231098e2d97879ad5fcf9c217ae836983bc9df:

  net/mlx5e: Fix kernel crash when setting vf VLANID on a VF dev (2020-07-28 02:06:06 -0700)

----------------------------------------------------------------
mlx5-fixes-2020-07-28

----------------------------------------------------------------
Alaa Hleihel (1):
      net/mlx5e: Fix kernel crash when setting vf VLANID on a VF dev

Aya Levin (1):
      net/mlx5e: Fix error path of device attach

Eli Cohen (1):
      net/mlx5e: Hold reference on mirred devices while accessing them

Eran Ben Elisha (3):
      net/mlx5: Fix a bug of using ptp channel index as pin index
      net/mlx5: Verify Hardware supports requested ptp function on a given pin
      net/mlx5: Query PPS pin operational status before registering it

Maor Dickman (1):
      net/mlx5e: Fix missing cleanup of ethtool steering during rep rx cleanup

Maor Gottlieb (1):
      net/mlx5: Fix forward to next namespace

Parav Pandit (2):
      net/mlx5: E-switch, Destroy TSAR when fail to enable the mode
      net/mlx5: E-switch, Destroy TSAR after reload interface

Raed Salem (1):
      net/mlx5e: Fix slab-out-of-bounds in mlx5e_rep_is_lag_netdev

Ron Diskin (1):
      net/mlx5e: Modify uplink state on interface up/down

 .../net/ethernet/mellanox/mlx5/core/en/rep/bond.c  |  7 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 27 +++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  3 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  8 ++-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  | 27 +++++---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |  2 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  | 28 ++------
 .../net/ethernet/mellanox/mlx5/core/lib/clock.c    | 78 ++++++++++++++++++----
 include/linux/mlx5/mlx5_ifc.h                      |  1 +
 9 files changed, 127 insertions(+), 54 deletions(-)
