Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA7421ADA3
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 05:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgGJDrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 23:47:42 -0400
Received: from mail-db8eur05on2056.outbound.protection.outlook.com ([40.107.20.56]:6125
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726495AbgGJDrm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 23:47:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oa7ThW3ipkxQQ7/bMhtr8Ib5ovFs+PHW9oRCF1HtpYzL4dnizzidHEQdglPwLPdZZpkCRmibiI22Ok5tRW04foLNS7xekS502BMYZ0/1Kat8JbzQJD00VU55nPJYv/JCrrv9TugDWVjnj1JGvsD8PwmHyZbwI3kImiZjjest//8nIkFIyy39SwhViJ4o0ds+p5+W0TRqoa2bdR2oBerN4BmGrcGBl/42BlqYiGaZWOvk0jHcKxIC3XgO9KuS4jTyOKnM7c2ME9xWs6JD6drUnhS6ofLljWybmsUiRti764o42TFCsXXl4icM1JQyPf1jUTnxenyFfZ2imtgGKYS+JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9GJuFJotOIrxBLs1mxMcg/7dGDjlDcGwN9+1LWfZi7s=;
 b=C4CY4btaQz5MToL1Pq1yK0rujv7sL4K9hHgT/Bb0vqQ4FDAyxO4ZYdzvijFKbcJuzCJaBVVh/DfY9idPWYKTkheY1b/S+OtUpaWudbdQvNT+7AxQmnmOj+j5ozsxshBJf0sboPOUY/d93FhyY0nZfB1nBRdh2sYkJMl2BlVrBIl7yh6JAb/YXAoKkWI+iAdMsVolGNNJiTkyEMxymp1vVGNUtihRuI+hh/W+Ks4CLve0cHkb1aNY9aeW+cllqGzn+iTY0BnM6A/eWm11GEgWSpqD78nelpD9tXYkZtMORqaYzqKKbjkISepcCR/IebD/mt+WBrCtX1nGvmR52giAWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9GJuFJotOIrxBLs1mxMcg/7dGDjlDcGwN9+1LWfZi7s=;
 b=hY+sFm/0cmRwdjmK/KGFGXaUQ19erImI/kgwZLW/DwdFcLgefyraxpOEA8KfXzLNMAFUrQDWy5d+zpCIv/lC4eAi9Zzv1UJjDcYQPhq2LnHCwsJigPMavXpxP3JEcb/vqBc9AAT8vsVTrahJviSSe6FGWOYP+8a0XO5T+31Ud7s=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0502MB3999.eurprd05.prod.outlook.com (2603:10a6:803:24::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21; Fri, 10 Jul
 2020 03:47:37 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.022; Fri, 10 Jul 2020
 03:47:37 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next 00/13] Mellanox, mlx5 CT updates 2020-07-09
Date:   Thu,  9 Jul 2020 20:44:19 -0700
Message-Id: <20200710034432.112602-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0022.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::32) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0022.namprd03.prod.outlook.com (2603:10b6:a03:1e0::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22 via Frontend Transport; Fri, 10 Jul 2020 03:47:35 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 17576f48-57b8-4faf-3a1b-08d82483fc37
X-MS-TrafficTypeDiagnostic: VI1PR0502MB3999:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0502MB39997678C1582A4E72636D9FBE650@VI1PR0502MB3999.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KmBeAOPBw3P2PIH9dfqdxybLiwDdBSpq7wUqgZxg3udTDzrx5POKU1akjJ3S6ucPzwzqxf9csJ79cfzqwgugt5jeO562U6pYrZCFKNeaZxE9HkqIhwSc7dh/Z6Gf8MmwOHMCG4w2HwjYKjHaf/HKdF42vRU7AAouJDzcp1x8KB++efgIz0fZnk9lhS7f3zgUU5OnFL+Tv1TIukTnY0j7DJgeErqpiLM2A6tnniCZzsEZK4eB3LvQkvpelUAt4xVE5yqe7HaOH6OvLARlrOI2UYI6SfGaPd5EH5fdx1sbenH0VRJVcb780latqNcmEeLDcVbV9zp7jdkh9I9hTtUjlw8sJH05JVIkmpxjSi0nJthCo5mBKKjCtV848hsNNHeO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(376002)(136003)(366004)(39860400002)(16526019)(186003)(107886003)(2906002)(6512007)(15650500001)(110136005)(4326008)(478600001)(316002)(52116002)(8936002)(2616005)(1076003)(83380400001)(6666004)(6506007)(8676002)(26005)(956004)(36756003)(5660300002)(6486002)(86362001)(66476007)(66556008)(66946007)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 3oOjHSNw3/nBv0gHk3TAv/sBBjEU2fZK0KFmdxCuF5Xci3JyuKGPkU7k34g7bPzPZhavdYutemjnaHvhMLdEsOD8in3up/K9GbFrQ7UdGu0YsIs0w+AObduUWYSyFya6ZrqlvN034phoRj/sM9/2OYSgcO/H7ArFDV8YYYsAG0duIxGZAmiHJmx9pMbVpZDP3gxt12dvg3vQymKYetYZ8JzHlo1EZKAlhpT97Yenw3shtujzM04tjeU+nxQCjTpR0HCz2XYoRN7AUtFnImGhdbTx/N8oXQdRYqJrO+qfGw6GjuURaPVnlrMqIgfD/NUiHuLUVHq69QnVrgrN0WQyF3K1TMHKaR/2T3NNHkmOaB5g08fnxaKDZsLUzxlZZKdUjUwaHf9AHz/HOWaw/u0qh9s1mbkAKPpwaF0cz3DgrWZ7B9J+1duNHhZEIqNTw2iCW8LaI7PdMudrllczgQSspJrPYvtDC6WuZ0HLW9+J5r0=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17576f48-57b8-4faf-3a1b-08d82483fc37
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 03:47:37.1374
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /tvJgHvavdqxrUgLptuob1MfRFxKEjx9aExKyCkCMEOh5U1Hx9Ky8idcwcITkpXzUwfzqMcVPJYT51Rihb10xQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0502MB3999
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave, Jakub,

This series provides updates to mlx5 CT (connection tracking) offloads
For more information please see tag log below.

Please pull and let me know if there is any problem.

The following conflict is expected when net is merged into net-next:
to resolve just use the hunks from net-next.

<<<<<<< HEAD (net-next)
	mlx5_tc_ct_del_ft_entry(ct_priv, entry);
	kfree(entry);
======= (net)
	mlx5_tc_ct_entry_del_rules(ct_priv, entry);
	kfree(entry);
>>>>>>> b1a7d5bdfe54c98eca46e2c997d4e3b1484a49af

Thanks,
Saeed.

---
The following changes since commit 8fb49c0109f47e4a25e8ba36abd8381afbfa7a08:

  Merge branch 'Expose-port-split-attributes' (2020-07-09 13:15:30 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2020-07-09

for you to fetch changes up to bbe1124944de2f78eaf3141d05f957f8391e7899:

  net/mlx5e: CT: Fix releasing ft entries (2020-07-09 19:51:17 -0700)

----------------------------------------------------------------
mlx5-updates-2020-07-09

mlx5 connection tracking offloads updates:

1)  Restore CT state from lookup in zone instead of tupleid

    On a miss, Use this zone + 5 tuple taken from the skb, to lookup the CT
    entry and restore it, instead of the driver allocated tuple id.

    This improves flow insertion rate by avoiding the allocation of a header
    rewrite context to maintain the tupleid.

2) Re-use modify header HW objects for identical modify actions.

3) Expand tunnel register mappings
   Reg_c1 is 32 bits wide. Before this patchset, 24 bit were allocated
   for the tuple_id,  6 bits for tunnel mapping and 2 bits for tunnel
   options mappings.

   Restoring the ct state from zone lookup instead of tuple id requires
   reg_c1 to store 8 bits mapping the ct zone, leaving 24 bits for tunnel
   mappings.

   Expand tunnel and tunnel options register mappings to 12 bit each.

4) Trivial cleanup and fixes.

----------------------------------------------------------------
Oz Shlomo (1):
      net/mlx5e: Use netdev_info instead of pr_info

Parav Pandit (1):
      net/mlx5: E-switch, When eswitch is unsupported, return -EOPNOTSUPP

Paul Blakey (8):
      net/mlx5e: CT: Save ct entries tuples in hashtables
      net/mlx5e: CT: Allow header rewrite of 5-tuple and ct clear action
      net/mlx5e: CT: Don't offload tuple rewrites for established tuples
      net/mlx5e: CT: Restore ct state from lookup in zone instead of tupleid
      net/mlx5e: Export sharing of mod headers to a new file
      net/mlx5e: CT: Re-use tuple modify headers for identical modify actions
      net/mlx5e: CT: Use mapping for zone restore register
      net/mlx5e: CT: Expand tunnel register mappings

Roi Dayan (1):
      net/mlx5e: CT: Fix releasing ft entries

Saeed Mahameed (2):
      net/mlx5e: CT: Return err_ptr from internal functions
      net/mlx5e: CT: Remove unused function param

 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h    |   2 +
 .../net/ethernet/mellanox/mlx5/core/en/mod_hdr.c   | 157 ++++++++
 .../net/ethernet/mellanox/mlx5/core/en/mod_hdr.h   |  31 ++
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 425 +++++++++++++++++----
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h |  29 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 274 +++++--------
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |  17 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   8 +-
 10 files changed, 672 insertions(+), 280 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/mod_hdr.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/mod_hdr.h
