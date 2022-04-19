Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65581507123
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 16:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353577AbiDSO6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 10:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353590AbiDSO5u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 10:57:50 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2076.outbound.protection.outlook.com [40.107.236.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D395140B8
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 07:55:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cI/DcZkA919NI5PieEhe0UOrlk1u64V7Xdbfj70uoLOuLPP7gJ/oF92LlDRqjrc3GCJLv5Oq2mfzBgyOkD2QfffJkuOgkh4J9hvEmtoKtbfJ2yHxa7Pu3Q3yzL15JStwJahonrBH1PFNFJ4SOc5DdJbLh0Ds6qVp+nA0MeysQVlAu0mDc1n9OWlRnAvufmQwKh01mFEti/0Ifzz+OIsgC8gGNc9eBUgO3fvhml47vvUBs7JJ5xxVow2ib2f6s2u4Q47jgeq39+/dqlYDg5Tzvp7F55cGtdWtF42A491sQjyXV7i30yCWHEKv8GtLBu+bLE83XJWceQHjSE58YtkYqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=99Uctkw+ESXel928vw2gENMJGFGn93+dhsRH58XG1Bc=;
 b=TBIvOjcfWE61n0rsrAjjb+Lz/M4XPhHEurllHiNl7QUsoXzWG6fDI2j03O78EF2rMg/JRElTsB8YNu/Nlqnrq7bu/pN5YY3O3URd68z81HWgM2MAmbAjAd+uK+Vq99M1dzIWwcpE3rzNiXc5/M4RSMdwiRd6J5tZArP1BedDkOXlEseuPrPlWatWK3FKfq8Wjv9ReRV3lWeaT12XY0HZmIHguHi92jao0KWChaUBt57oPzX5LqEQjKl0RMTcOp3oec+WaEnPEYpmM3HYGS+CNypJmMch+7icub/02Bn8LcFVKnduyWM3v9KxirO6edyq7a2KcfHgfH1M2MbNCMy5GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=99Uctkw+ESXel928vw2gENMJGFGn93+dhsRH58XG1Bc=;
 b=iyRqs29fLEl42keGDaxMB/7GK1jf07AUg48fzc6Wavrn+bs2vWrT/SuGGB6Vj7RtLQOqadqm/wMqGKvZ9nFELB0q+oAo+J7YCyewbgPR39QVrcO4rkWjiYKJS+sEm4ejDutK/HqgQ7CFkRMiYXPKDCszqk4bD6M7TYmD+1A1S5uG2ALEc9FIPJAkylsaW/8KSiUoQ0NGWJlQljtxXgmQljH2MRfmXPs7BZuhGj6KoX/pDx9tS+3iFguSspboU5cr6lv9rJ6ePYOHLCDkaow9zhafNAPqLlyZTdURFwh2gBH+UAJkUfMI8Zv8JGGtXWA5nM0jgrkq2pmlqpMXbet6AA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW3PR12MB4347.namprd12.prod.outlook.com (2603:10b6:303:2e::10)
 by MWHPR12MB1216.namprd12.prod.outlook.com (2603:10b6:300:10::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.25; Tue, 19 Apr
 2022 14:55:06 +0000
Received: from MW3PR12MB4347.namprd12.prod.outlook.com
 ([fe80::9196:55b8:5355:f64d]) by MW3PR12MB4347.namprd12.prod.outlook.com
 ([fe80::9196:55b8:5355:f64d%2]) with mapi id 15.20.5186.013; Tue, 19 Apr 2022
 14:55:06 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        petrm@nvidia.com, jiri@nvidia.com, vadimp@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/6] mlxsw: Line cards status tracking
Date:   Tue, 19 Apr 2022 17:54:25 +0300
Message-Id: <20220419145431.2991382-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR02CA0066.eurprd02.prod.outlook.com
 (2603:10a6:802:14::37) To MW3PR12MB4347.namprd12.prod.outlook.com
 (2603:10b6:303:2e::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 45f83461-11b2-4022-3d8e-08da2214973f
X-MS-TrafficTypeDiagnostic: MWHPR12MB1216:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB12161ECA929673F01F5E6421B2F29@MWHPR12MB1216.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vKR70MJVb9T7pBY9jlqRKczQ98UMbGUq1nJxsYFPWIiALYzA2RxUABXYZUsCIGwQ7Xse9As6pnIAwIBieM7tZ5OCKGgWqirz6Pjpl73H8pSHkao1MU05fhMrsBGTNJ48Msl0ew3NMgPDYkTL8XnehasxYYyoi2Abm+JNuHW4vaic5lYYs/wIPFrCCuogNGmTG201HHjQKrKmNN2PRSYj9+12BNVkWD7qYhjd95gOFDVbP4VM2NJ7eFN+q+6JH84gyxahE+8tKKF/xhdZasVP/Yws3Ac02LLAxPhHgrPxpeAYGu7hQxiH15kISMivW2nRdjH9CZxSx+hIJEFxxOQPRzgMQ/m5KhQz6XLqijdS0pTC6ON5iGbf1dGmOqTfTMnCQ9dNUF1n43zZpadET7jA4Zb2wzdtg67fv0dclIJv7IzgCILOZKCPEa2kgoDdW6gW/uByepHQHE0friIlcQZdveuQDaWKmFLhf3MKg2D4Ro+fXAPZyREYiRlwG1GWklhT7SJergnuf9CZt00s0Hw7AQco/VOiLwrkLfSowjHoBNuk74f8HnlUOotQMAoAZUDxd6cPj/FGx/XwrzoIPGBzNm1oHrrIuw1dJMyMOlE37B1Tlo9ea5dIhbqQGf9tuClIjLB0KoJa7+39eXingL/D2A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4347.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(66946007)(66476007)(8936002)(6486002)(66556008)(6666004)(2906002)(6506007)(6512007)(316002)(86362001)(2616005)(5660300002)(36756003)(1076003)(8676002)(4326008)(38100700002)(83380400001)(6916009)(107886003)(26005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3X2BDyVxdGq0DDOMu1EfDr0HC3o2bP9WVCJ9uY9uRKAwWLiONNWD7vvHGAxN?=
 =?us-ascii?Q?ONEaoLcaG2pzkHzHdhobg4k7xBs2f+3xMRfTuxVlRfUZAMjzrP65qrpMzZ37?=
 =?us-ascii?Q?BRYeXiE+LAtxaWqcKhBLk+S/wOFaOxDePE2V83SktzHN6nS4jMGPu2gG75s7?=
 =?us-ascii?Q?zRRxe0kfFy0+BHBJVVATA+BXYiUpLRzzlz4xSxi4LSrIJyNz8TXUwD/xk2NT?=
 =?us-ascii?Q?1cM+3f3NNiG6RKK7e9coQMfcn0YpQeeFYbGvENQnrZuiMuMvY6XcQNJrIrep?=
 =?us-ascii?Q?ymBRU129lsra73kaLL7yWrk+dTWGACfvbE4Nc5mcmZnk3+Ue7sWa5By7lyfA?=
 =?us-ascii?Q?enukKKkkMGTYlxilTWA9mn8s/+95Y+NH910+F3jIymmb7g1SQ31MrRIZjCj5?=
 =?us-ascii?Q?VqfZWaGmdetjryDCscSjnrtCbyNZ3cyOWhpaG2bCjjCiFYe+axAcxyCZbrQF?=
 =?us-ascii?Q?TQBwXfd44bqOteTzFFp0+07FTv8uZAjo1rjqeEYJnxyHRzzf0jxg7wZKrKEm?=
 =?us-ascii?Q?qsDEWJuSroQ2xxUJLDBagv8rCYzFUMjizE0Thx/wnPUMfEBMeL2iWt0OAW2s?=
 =?us-ascii?Q?Q1rMduHAcH7wsReZCh3qn1ljxW8XGdOIGpKDkv/z7tQZzUOkiQAbOvNQ4hBo?=
 =?us-ascii?Q?l7aSmkId1sClxpPJKyM7TLKKThfwS3SnPnjUHdic9Ca3oppLGxqvAX4ZJqbm?=
 =?us-ascii?Q?rGD8LOKepeGVdf+u37G7HZhRtO4HVC5HOwrqfpTALXjNmEunr83uzah9kp5E?=
 =?us-ascii?Q?C7UFgOBT/aO/QD/o/9Rmfmgb+yqgI2f7neCcX7b4TL3RQOQSiIs8fdRI7i3H?=
 =?us-ascii?Q?zVcuU7qPw4H6l79mIiqSXenVdOFN/okMEIlUy1dwxWPtNJlMtLgTm1BJRZ/Z?=
 =?us-ascii?Q?SXv5z6su5G2/aMBwj20V4QJO+A995R6S7QA4rioptKQG+xN9nZ5spEdwtbib?=
 =?us-ascii?Q?/4V3252hSse8jx2esxwVzDX4kIFTfJyW1+SEJt8Ger7HOAVx9vd/lNyMqEzA?=
 =?us-ascii?Q?OdDEjuXoDOiyBYGKHfUC+J8zPU+sJGrql7GzoiFUDNciPM721T+GL43NVurA?=
 =?us-ascii?Q?/Hrsgy1ORRTfoedegLSJVcTOS9/I+OzXyjpz+gxu7w+okAqio5CAqYhhrwN7?=
 =?us-ascii?Q?vonXm/gD+6skClb4/0++KtxUXNmOnzwyi55J921wF35Vb8F7uFQR5T4qNodM?=
 =?us-ascii?Q?Pg/w4z2mWCrEGK8tRHO7XZf21usCYT1wttZUKh2nSM1zDwzkHeaKOFiW0PoU?=
 =?us-ascii?Q?2pG4uMsKoLX1N08cnvP0YaG8sz7oQOTLuBVGm9hZ1tTLtxSVXVhzzX+JU0cZ?=
 =?us-ascii?Q?uaYvS6o8hg3x2D09F1tnzLpn4BleilzziosvSoBBca0+q4MtJzQuDDHl8/OI?=
 =?us-ascii?Q?+4qCBLUmrXz8CiIH7aswTYQLFUfnvMru88+MVxX+1W7ZCUA+u6CvL9+LWCwz?=
 =?us-ascii?Q?9v1SvZqB9BHuJYjROi7cezGpOXVkLYiiBQMP6MW0mygYEKlR0Mk4pqXXeM2k?=
 =?us-ascii?Q?kXQEusaVmtIWjL9Wz6L5FhhiKs+NRIA2rJf8O6XmHF5DGKlUBqACOPGRnwbR?=
 =?us-ascii?Q?W5T6UmB6xcaUJN5rme0w88L/lNbi3ye6htBjX8z5b3X+VjmdiCROnw9ace6O?=
 =?us-ascii?Q?JgLFodAfy+M7SdTg9TloAnECTr4ND11eAbHfWq2k1a1QQWOmhLzXIPHpDTVF?=
 =?us-ascii?Q?R/KmRTD9ivfv1ZAZVOVhEljEm00Rzo4bc+zIbMFR+NZOZ4tAv52CWJTFCXDC?=
 =?us-ascii?Q?kI4mmnfcLA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45f83461-11b2-4022-3d8e-08da2214973f
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4347.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 14:55:06.0884
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s3GByofMzhMVZ6x+b5McxdrNgin/TNPFaeb07mPsa8aYvdOP5EgorRjOPFyMwzL4jZhajl44/wdBKTmL/XNF8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1216
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a line card is provisioned, netdevs corresponding to the ports
found on the line card are registered. User space can then perform
various logical configurations (e.g., splitting, setting MTU) on these
netdevs.

However, since the line card is not present / powered on (i.e., it is
not in 'active' state), user space cannot access the various components
found on the line card. For example, user space cannot read the
temperature of gearboxes or transceiver modules found on the line card
via hwmon / thermal. Similarly, it cannot dump the EEPROM contents of
these transceiver modules. The above is only possible when the line card
becomes active.

This patchset solves the problem by tracking the status of each line
card and invoking callbacks from interested parties when a line card
becomes active / inactive.

Patchset overview:

Patch #1 adds the infrastructure in the line cards core that allows
users to registers a set of callbacks that are invoked when a line card
becomes active / inactive. To avoid races, if a line card is already
active during registration, the got_active() callback is invoked.

Patches #2-#3 are preparations.

Patch #4 changes the port module core to register a set of callbacks
with the line cards core. See detailed description with examples in the
commit message.

Patches #5-#6 do the same with regards to thermal / hwmon support, so
that user space will be able to monitor the temperature of various
components on the line card when it becomes active.

Jiri Pirko (1):
  mlxsw: core_linecards: Introduce ops for linecards status change
    tracking

Vadim Pasternak (5):
  mlxsw: core: Add bus argument to environment init API
  mlxsw: core_env: Split module power mode setting to a separate
    function
  mlxsw: core_env: Add interfaces for line card initialization and
    de-initialization
  mlxsw: core_thermal: Add interfaces for line card initialization and
    de-initialization
  mlxsw: core_hwmon: Add interfaces for line card initialization and
    de-initialization

 drivers/net/ethernet/mellanox/mlxsw/core.c    |   2 +-
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  17 ++
 .../net/ethernet/mellanox/mlxsw/core_env.c    | 213 ++++++++++++++++--
 .../net/ethernet/mellanox/mlxsw/core_env.h    |   4 +-
 .../net/ethernet/mellanox/mlxsw/core_hwmon.c  |  84 +++++++
 .../ethernet/mellanox/mlxsw/core_linecards.c  | 137 +++++++++++
 .../ethernet/mellanox/mlxsw/core_thermal.c    |  74 ++++++
 7 files changed, 513 insertions(+), 18 deletions(-)

-- 
2.33.1

