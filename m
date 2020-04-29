Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36E821BEC34
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 00:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbgD2WzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 18:55:17 -0400
Received: from mail-eopbgr10044.outbound.protection.outlook.com ([40.107.1.44]:62734
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726164AbgD2WzR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 18:55:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f8Ui4e0EUJL+biHyqm1y9k7Y2IEjCgqUlGSBh+1XjJnOEfVSghzk8AIK97mdOulfxClen1ZaYBl6HFOp5VC/DijAvWqtDGxSlwrAZXf82Kn81Y56//OX9/B++4STtWyp5sAVKEOJnyA6t39aukLBjtP+EUHNHR3y7Z22seleRw8+V7Bm7GHE3Oy6e8EvPCyABKVltdv7dBh7xTc1ZK3kTPVMlJ+vseAws0HsRrRpvxl0ByXFNo1phfTNnF7lbyMamAbVwkJSFM2VsL5dgfkxQ9tR2V4f04VXgtppP1vhqVpK/InjtMCazwn28U8lJpH3cSB9FzasZGLRwVIFbCyq4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JZto3LjIk9aGRKHJVZPV5t4f1O9ReACzeecRfel7hmw=;
 b=d/HtMqvC3ejKSOj5Z5NEKyWlpAh1va93QcoDBC4erBTWOhU9T3SrOIy0YAQVdzPH4ZGmM9TElZiWCf8/PD+S+ADdD5k3efZgnsiQRNY/SVtNDWrthNSoCww6p9gh3l2hgauVTS3xoipTsQoldQuophGuYnTgyo7Z3k0WUj9flswuEkUalREQSL51IxpQUrZfCsCTNJLvHIngILmGos8dEDPsAYFAoMeKDzl8IrCqwqQrk0HRhKRQKBAWZEauGPP12wmF+OTOSPlFMtvEfLIW4yvJYfoqCwdifariZleiajUqkmQlO6vCXTFIxA4bvDcpWJxjM3iYB+eSst+Se/O9Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JZto3LjIk9aGRKHJVZPV5t4f1O9ReACzeecRfel7hmw=;
 b=XAajUDOYw4XKuXcTko/NnyxuvqLr03QFrz6XCfOLBz6Roq/GCFvVxX8ujeNz7zUX7DrZvTBs/kyPWI52jxZOkxnqprgfmF7tljqzsspmO5H/Vz8UOSseJnQZWHiV/eVdmCxrvljXSLVbwlwjU0GwbKCjJFDizhWxXaNNnrlVKBo=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5247.eurprd05.prod.outlook.com (2603:10a6:803:ae::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Wed, 29 Apr
 2020 22:55:11 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.028; Wed, 29 Apr 2020
 22:55:11 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net 0/8] Mellanox, mlx5 fixes 2020-04-29
Date:   Wed, 29 Apr 2020 15:54:41 -0700
Message-Id: <20200429225449.60664-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0022.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::32) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0022.namprd04.prod.outlook.com (2603:10b6:a03:1d0::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Wed, 29 Apr 2020 22:55:09 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4ab9e81a-ec07-4ed0-cff4-08d7ec905eca
X-MS-TrafficTypeDiagnostic: VI1PR05MB5247:|VI1PR05MB5247:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB524720516DDE4723CB505DBFBEAD0@VI1PR05MB5247.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-Forefront-PRVS: 03883BD916
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(366004)(136003)(346002)(376002)(478600001)(6512007)(2906002)(66556008)(6916009)(66476007)(316002)(107886003)(6486002)(52116002)(6506007)(66946007)(6666004)(2616005)(186003)(8676002)(16526019)(26005)(86362001)(8936002)(36756003)(1076003)(5660300002)(4326008)(956004)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D6W4pGxZRRGkG0MXLHzV35bWnRFl+Bc7J2sYr+vJPpVRq9SDt/69yT/wsnk4mNWBAEgJhCmVjNQzRseOZgPWdXXqKRtcl6zsgqA2jknMVPtTbhm3nmut4WAPft/547eoEHMwI1OQ29dNYxr5LoS5avl6yh/t9js+PNGynMZDPSr7gWw4XBsGaQ2vmNNC2sGmxSSnllh/O5M/0vhvU0nK5QfetpmymDMzNPHEd/pqjUdW4TMkuN45NnYAMHDh1S2WK7nYdM9V6iGihqnxNZt+bAuSEOrqaWr/Mhfs9Bf6g5KgTa4LDqMh8n2MDCJWWvz6yOsBixLMZSP8xnW8TTym9yD2nas/DsglO/sHzL2Ma9rQHCM8xNVSeznSQ0qFzleNHp0vu5bWzN3s+vbbXcXANaitmQUIm6ZUl408sY++Ugj7aDGxEf9bncONWcWCE6BNgoKsoMe8fs/P1WqmCyCP1TEwuPye9K266K713qsKXOtrHNqQYckzZzfY0KFKJKdG
X-MS-Exchange-AntiSpam-MessageData: wE/gC5bFlTAtpdD0VVyaD8dDQtm+OmftFoKe5i+xJeZ+SnTIvre5fAXWBc1t9cBSORhilVUV/cKIyMi7uL1syTjoff2ES7ssMCd4puS3QhAVOiQQO3MNALK2BGQ5jzXiuRfX71Wgo3MAp8LT9G7sqmXunQ+7553DT+Y/w7Q3WfPhy2OhgLQ4GE9hkUG6CC/8ahCi/GrgEgkFuh9bDUvfEWjkLt5iVl3+DHM6SNWMNRlwvSQCtlBNNrGQK09qqx0YHfqvFrAKlzG5KPM3gF+AudWswJaZ5OQWIkUpTwiL6g9f5ZWKUBQC/sKLZ4g4ohDRU5KHLK1HAIcqgtyv4+KJP8XTTzVGXJwKxrjXXNhsnGwdIRBqHQ2jGtHa0GVvhbJAk1Rr7278emV3yjQdeMsDiD0vpMajAESwelMgXIKipw8j18tFCfwvtgSeomnEpdPFCRTcMqdqxYU6Is99+jVRxp3DuTqxi55XSTO+FGE9FcMpiO+LtnBsZjRQok5dVGFWigsAVdOdZitHPmfj1eMTF2QW0uufWRUMwEKQrqMxOJzqtAdFJsNtYTWe7QMGW0VRdGND0mizeRL+BQisQYBn8iNrYCJuTUhgrGvd/XitS9JSGTwIpqcSFBhXTJZF+JzIamJCwedF2W2hMVh7kDUzFox76kcXcBu9m6EeQgBcansq9hcclRjGkq7w+y09AWT0+irKx66WmP0tBNPRdmGUBKaOpKp6f/HwzIDCDxNA3v5zJ6IH5e/PZaj3lucGKQa0WSguDHTkaEiUVWCcxkoKZYvojD9d2KLuN4cAtq/j7Rg=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ab9e81a-ec07-4ed0-cff4-08d7ec905eca
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2020 22:55:10.8528
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aQCJCXhOlNOwT4kRHVj/krYU4N+zJffguK3iJti1gItEDG3nL5/zUSCYYYY3sLMCtgaa3947AwyX8zPuPwB3ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5247
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series introduces some fixes to mlx5 driver.

Please pull and let me know if there is any problem.

For -stable v4.12
 ('net/mlx5: Fix forced completion access non initialized command entry')
 ('net/mlx5: Fix command entry leak in Internal Error State')

For -stable v5.4
 ('net/mlx5: DR, On creation set CQ's arm_db member to right value')
 ('net/mlx5e: kTLS, Add resiliency to zero-size record frags in TX resync flow')

For -stable v5.6
 ('net/mlx5e: Fix q counters on uplink representors')

Thanks,
Saeed.

---
The following changes since commit 42c556fef92361bbc58be22f91b1c49db0963c34:

  mptcp: replace mptcp_disconnect with a stub (2020-04-29 12:39:49 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2020-04-29

for you to fetch changes up to e77ccbe791c7e51db388a6e5a4f9f5b2ca484acf:

  net/mlx5e: kTLS, Add resiliency to zero-size record frags in TX resync flow (2020-04-29 15:11:03 -0700)

----------------------------------------------------------------
mlx5-fixes-2020-04-29

----------------------------------------------------------------
Erez Shitrit (1):
      net/mlx5: DR, On creation set CQ's arm_db member to right value

Moshe Shemesh (2):
      net/mlx5: Fix forced completion access non initialized command entry
      net/mlx5: Fix command entry leak in Internal Error State

Parav Pandit (3):
      net/mlx5: E-switch, Fix error unwinding flow for steering init failure
      net/mlx5: E-switch, Fix printing wrong error value
      net/mlx5: E-switch, Fix mutex init order

Roi Dayan (1):
      net/mlx5e: Fix q counters on uplink representors

Tariq Toukan (1):
      net/mlx5e: kTLS, Add resiliency to zero-size record frags in TX resync flow

 drivers/net/ethernet/mellanox/mlx5/core/cmd.c          |  6 +++++-
 .../net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |  7 ++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c       |  9 ++-------
 .../net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 18 +++++++++---------
 .../net/ethernet/mellanox/mlx5/core/steering/dr_send.c | 14 +++++++++++++-
 5 files changed, 35 insertions(+), 19 deletions(-)
