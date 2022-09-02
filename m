Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5223F5AA535
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 03:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234697AbiIBBqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 21:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232014AbiIBBp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 21:45:58 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2080.outbound.protection.outlook.com [40.107.223.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E917749B7F;
        Thu,  1 Sep 2022 18:45:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MRhcKmpTQKX++jQLhfU9OmNDxzbe7/iZA0tJvYHkpgOBJ5TTluoyUgo/hTS45HhMBQVuw7dPULf2ulCFGfEKMMLsb7SdboIewFvGaoL7pGbZ43rINZa7/o8XRDL5NVtI9EzMGkLXV6qeC8iTVS5IMsH+4uDojstwnvjn0sOThZf9fby7x9rzme0Sz63FbZCN+XjypiHAtxe/sRsf7H9wT0MAfcFgSO64Dzv8xDb3OnQhhL9OfP8fCdCX86AtPOC8hXFgaJxmaULg+GRm/tVnhY2oMhi9pmwbvQeD+v714zZL6mbfnWDQWCw3TfY97IR8QAFGYkVCO4aKDVpSZYJxug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4+svzPgV6xUfAOFvrMmMfUOGCeojwOXOOXD5YCLh7nA=;
 b=CzalhSbNw78fHrHxIksSc1L6uNWYaBSBXTuP3jgciaJhlXN4QJKEZ6uWDpcZWGb+i2vzV+PEMq/v++TcsuaC7KaGtXQFVu+HtY2K9f0zo1VQ/kK7X67QfP/bxI8O7H7fRQ87QmMRipOZY86rMt1Gzz34SpM9JzHrOpsKkSUtueuZGfcAbDWt5MxydRP1B3YFAs7YfLUMmOqWkBQLHW+BiPleyZt2ZYbd97jVQMXeCpV+HNZi78sjNqVOzyrnKvmOa8NrNqqqMWYLUyKTF7IoxUSrAz1GZNWfN429st2Wl0FFAxZSAqqju2Y37Lqg1nfaYJAIk5hNmnQYOEKNhtwaoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4+svzPgV6xUfAOFvrMmMfUOGCeojwOXOOXD5YCLh7nA=;
 b=eaKEvH1kt4QsuEjDoFx+elKGAKPM1vvn1pRUfjmirrq5u55cIoN0t0kLZxNdcaE4FQMgI7Q+efThtG4AlxOSXWP7V6J6b5Agu+eKoRqbXr3no2FtYJhI1xkh85DWhhpoHTE1mzUpGWRN6z+/q0bZzCkLPW3T9VzmuKK2Ocbln3rU88cuyj4kK5BSZWgXkVvc7rtDRUPgsLaYWLQFwZfODxRLjauexarT9NpkKRIakgEGcFR2rT1pDFGx0qRRMfRolfisQeoI5PXamjhctyVqu+tysHt0OOuxULI1CZKsGtJ05+/MGsRlMXoRwsMNRYkV1xFn5faPpm6DLDGMIw0Y7Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4373.namprd12.prod.outlook.com (2603:10b6:208:261::8)
 by SA1PR12MB6728.namprd12.prod.outlook.com (2603:10b6:806:257::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.11; Fri, 2 Sep
 2022 01:45:55 +0000
Received: from MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::51f3:15f4:a31a:7406]) by MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::51f3:15f4:a31a:7406%5]) with mapi id 15.20.5588.010; Fri, 2 Sep 2022
 01:45:55 +0000
From:   Benjamin Poirier <bpoirier@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Shuah Khan <shuah@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH net v2 0/3] Unsync addresses from ports when stopping aggregated devices
Date:   Fri,  2 Sep 2022 10:45:13 +0900
Message-Id: <20220902014516.184930-1-bpoirier@nvidia.com>
X-Mailer: git-send-email 2.37.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0076.jpnprd01.prod.outlook.com
 (2603:1096:404:2c::16) To MN2PR12MB4373.namprd12.prod.outlook.com
 (2603:10b6:208:261::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ac0925f1-503a-4965-d2c4-08da8c84e054
X-MS-TrafficTypeDiagnostic: SA1PR12MB6728:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tR9kWg/bYi+6CDqzt2VG9XpN05YniigdqszBDkNU5rGUk/V32ewAwuB19UR8ls9HeRbd294Qxq6fdu8hHlALHxsBVV+VEKWx62j7OKI7u4yzQlwY9P7D6QLuIr7kiqdn6dyYYs1gdxt3skHUFsLRjbQEJVpg6Eat/BSMI7qM7G9K8Vhr1Ltw5quWl5EcdFxZmgSVmjVbDTW9LMVnZX0o8QTxQRbExC4NFmoRiy+k6zuKu36wvzm7tMbsxbqZlUUj5kOqxQo+CkXm9/C89Mh9Fm6xIeWGaUrU4O/TYpzECpjJ/NvjBlDwYVvc79SsGvOpOjpV5tozr9KHFAp2c64DVn7JShJxHwN/nGTMhGp7PJHBMCkFecURxk7eWxosOlYBM/af9s2N3RmeMd9X1ZOviHtnW9T2tOvWR2488kCWbIeKaO5S15MpEKKD9bcoCfy4s8v4tAuVzzVsVc6gF3BQ7ZC+2fjb5ntzOaP52OnLY/7HL+1otRXDX+hq/N6z4UF+hgLbsaFC+emOkEOrPlGtZSWSn4jd2eYtKOfEOKyP37h9YTYdCe7auGA2hUr+2YjcO1r7f9DQYxUfrjsmj0m6hAaVzLwBd2xpAMjnKyw5HguA1h0Ncs1zskzeunWu497ihqCtyg6pB/95BbhdBOc4HMTGX6Ip1XTA5lCrbXWTW2dzoY95icLV1Ip8umeUFO+M71zUZDBjbNEieSb9Hv+m1w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(346002)(39860400002)(396003)(376002)(136003)(8936002)(5660300002)(6916009)(66946007)(66556008)(66476007)(8676002)(2906002)(36756003)(4326008)(316002)(54906003)(478600001)(7416002)(6486002)(41300700001)(83380400001)(26005)(6512007)(86362001)(6506007)(2616005)(186003)(6666004)(1076003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z+ONIeJJS5E5dz531jtTF851HQ8O7ZUhzaIGvaMUqGdD+eyoNZXDq2Lf3I1f?=
 =?us-ascii?Q?92lk/OiKJcq5tIvoWsbrTzvX3M2sB9LMAPj8Nu4yjzyh/4Qkuv9SPIUEtg29?=
 =?us-ascii?Q?bqXFmuLGC1Pq2akiBo7l8HK8VpB+mf+/BV5e1g614ONXgyz34xQRtaNqeyZk?=
 =?us-ascii?Q?7oGdl4UHQcHOTvGTdkcpLcNgbu5luBT0Q5D7OmupXxuo6JI5ZdZIMT8V/ugl?=
 =?us-ascii?Q?DXuqEd3mex5JWOzfq/DpT2SX4TgmyX7dZL19RruMGFiegufYtYk8XltqkM4P?=
 =?us-ascii?Q?85e2R0f2yVbekv96nviS4zQ+1AxLBTFrSQ6IxBAkxmsDe3GJYR0+sCjx0om1?=
 =?us-ascii?Q?47RL0YPjxGrGDnWVnCE/fIJMHCqj4g7JCRMdgdNNu5z+xvyRbqvldm98U4Dl?=
 =?us-ascii?Q?C/FjaepW8n4F34YxTzhGNC4TdQiYFcBiLBxXWJkC3pR4OqA4IU0E9yXD5zlA?=
 =?us-ascii?Q?T5zbn63PPnn/HZ28dS5t9IRXH/4HtBE/ewWYz+zi9ZTROqz2eUiIgHLzuMyL?=
 =?us-ascii?Q?QWxMXuKr/4qzkewJxGYETNU1JOTzdyw4rp2LHMjB8vzS/VrBSOJHcZybLK8y?=
 =?us-ascii?Q?u1CpajuTLBlTnoquc4G6iDKLPizg/gDO/X1lEGZtkvc0RFR0w4QGDufLnZjL?=
 =?us-ascii?Q?BLhrhNd31kvflleYPRSRNO3FXqnp77VGsupEHPt2vNq+mdWTSWPPXmb5RhiP?=
 =?us-ascii?Q?Iryj8mmvhnTdayi83qhDmNPkhGIU0b3xP38mSXhl0GzsZvqH5tyodt2QPEj3?=
 =?us-ascii?Q?HGUsHO/M0k06GxAtKQ5jj8ECVMhdUtUqldjgywXgvymKEoaBfiDHrFMRg4LR?=
 =?us-ascii?Q?JiK0YV3k66zZMrVB/ImBtAkJ+dqO68oaUoLFYD9r2qWIAiYXlfBLP90PnpBE?=
 =?us-ascii?Q?4wlIatJI21mAUheh+WtVJ7yXxu8qUHvbRQE9yHAxnV12/uu0OHN1CsqbP/0Q?=
 =?us-ascii?Q?n1b0z6632OFbcFRPztKyicTopGafpOwvlF3Sgs1gwe4xkFPwZ2LLbqU79F/U?=
 =?us-ascii?Q?s97spu2SQpR3IwrBe54N30O+/3b4xTyZWtb+rMzbzZlIBIC3Xv+1ZrUHlfQu?=
 =?us-ascii?Q?v3G7sqPaG18tRHD/m3Bk2VVSOW1/xXMmxaM2s+ZHPp5/vMOP3YYcD2AEmUe0?=
 =?us-ascii?Q?ZUbcgRGbYPAdWQNkXDaAVDDqguB2rLarSskPEYnlh2BI8/GBuQFWvJQqPzIZ?=
 =?us-ascii?Q?ti5vlrVYjRWDtamHKababwX8ILCzORBwx70Eguc0A7Q+24i9yrZQNIRTLAO7?=
 =?us-ascii?Q?Nb7JnVfNjyiSnefhrkHozRuzK18F9mUCjvZqfptZIX4cQS+vxLbdKx6hr8Ef?=
 =?us-ascii?Q?pnCcc6P94Wz3u1uCQIIz3Tu0aLqoMnnZo++K1Fq8NI+jQcwRhUiInPPfYMBV?=
 =?us-ascii?Q?bjA/00zPKviKpkSwEzYZNSxCBbtp9mCRLj3RWVk4wkOKYt2YHKeqCovcW5Aq?=
 =?us-ascii?Q?7GP+aeYNOdyTlbDVWFRG6BplNkz8zp9CH2DPXdT49kCOMZdMGpVdt4bGcBkY?=
 =?us-ascii?Q?Z7XmY8OEpco+8jXXcbnw+/QRP1VYk+yJLqk6ZlCdTAC4dhv8P5B2hs2KyTR1?=
 =?us-ascii?Q?dgnFmFqJ6m8kBVMp6QsycI2gh+KhDUS3OSu0VlkK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac0925f1-503a-4965-d2c4-08da8c84e054
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 01:45:55.5917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C5Khdsq+9r8g/wzlZr6IOBVPksoExypwN01I2aivwYNBje5GBP7Yk+fPnXf++h4YeMlvwUafNkohpfybV7U1Rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6728
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes similar problems in the bonding and team drivers.

Because of missing dev_{uc,mc}_unsync() calls, addresses added to
underlying devices may be leftover after the aggregated device is deleted.
Add the missing calls and a few related tests.

v2:
* fix selftest installation, see patch 3

Benjamin Poirier (3):
  net: bonding: Unsync device addresses on ndo_stop
  net: team: Unsync device addresses on ndo_stop
  net: Add tests for bonding and team address list management

 MAINTAINERS                                   |  1 +
 drivers/net/bonding/bond_main.c               | 31 ++++---
 drivers/net/team/team.c                       |  8 ++
 tools/testing/selftests/Makefile              |  1 +
 .../selftests/drivers/net/bonding/Makefile    |  5 +-
 .../selftests/drivers/net/bonding/config      |  1 +
 .../drivers/net/bonding/dev_addr_lists.sh     | 89 +++++++++++++++++++
 .../selftests/drivers/net/bonding/lag_lib.sh  | 63 +++++++++++++
 .../selftests/drivers/net/team/Makefile       |  6 ++
 .../testing/selftests/drivers/net/team/config |  3 +
 .../drivers/net/team/dev_addr_lists.sh        | 51 +++++++++++
 11 files changed, 248 insertions(+), 11 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/bonding/dev_addr_lists.sh
 create mode 100644 tools/testing/selftests/drivers/net/bonding/lag_lib.sh
 create mode 100644 tools/testing/selftests/drivers/net/team/Makefile
 create mode 100644 tools/testing/selftests/drivers/net/team/config
 create mode 100755 tools/testing/selftests/drivers/net/team/dev_addr_lists.sh

-- 
2.37.2

