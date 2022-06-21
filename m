Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E621B552D16
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 10:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347786AbiFUIfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 04:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbiFUIe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 04:34:57 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2043.outbound.protection.outlook.com [40.107.237.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D4C2180D
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 01:34:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qs6DHv7DO0prKF0E/oRm2+LXLdeZnasG1SznMJqcXuMSgXRw2ZvFZ7ozXDefda18bdHWK6XHOf01dosAh0fIPpPVWK/Tr8azRWgZo4t/VSoDjFpUK0uvAzgljLovRsNkAy2HG1xgRTYOSopp4Kytxg0q3P92F/+ZOwYMW2dGojeAmEOTzmiw10Wkor3syor6MIhOeC4Nag780cxDIrOpoSPg55kyIw6TFSEQOCZUFyQ3E4S5lAuPDaLvQ6Qcz+k/vmJx76gQogFOJcLGBiTHHnl1cVV4AP107ObiCYCMxajKueg3jHTLtpS3e9PJc9p3znFHAWBHPxn2shZ4mOD6aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y+PwyLvO5Fhpd5sAKtIzaF1cVaXwrRBVyZF3VniWeqo=;
 b=mAaOEP8HEWUjEvymw4MuHhkT0ku6ocdX45f+2UW8MjjVz2PakSql7JRI+H3FmoFsc2gZ5sj802q3la7Hnh/j9lHdrZLo3RKR8CX5f5eRfIzx6kMZqYUsDeixPtednfaAUmu1RcmF5mn9UN84/e5/0+4Mhj3Hk+NA37XY0C9mQ3bKyLmnuyjlzW+rufsE0/m+NURdtEftGbWWExi3zpZVAP9LslHK6ueUZmVJ64zVriVjVVMH1PL6Hm5Ndi3X1h8qOwQRneSZfoBveE0+Sv8sEY7AfioOW8xsg21LCx2+P8asOHEbXbA7XyJ2oN/VLXH0k3e5OKr+RJEyFJa1x+m+6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y+PwyLvO5Fhpd5sAKtIzaF1cVaXwrRBVyZF3VniWeqo=;
 b=nmqqqXEcN7ULeKX7EELdrA5lkIRpD0IVvrvw6gKvzL+sAuWZG9O6SkWd9JGxqA1s5jgT3hYI5KJYYisQDiYHDH/w94KP9f7hi4dvX6qdeAbHa+kEG5rdDxHRVKEuEybkfkcQZsn2lohscw+BOzAWVW0A7WZCtdq/sfuvuHyN+Kgwv6EV8paua00wLm+XwLqkEil2K6Z13s2S1LEBjo5ZFihk+BQQFFqbxW5YC585XhVP0GHP+lyIbA5hjCQoGnHyNROSuQprx77Ym2PT2cFv/ZdDFd3Gbptl/YeV8grGWryLGHBxnYEipQrWxEZLLdIwn8f91tWeSIBtXPsQtEZ7YQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CH2PR12MB3832.namprd12.prod.outlook.com (2603:10b6:610:24::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Tue, 21 Jun
 2022 08:34:54 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%9]) with mapi id 15.20.5353.014; Tue, 21 Jun 2022
 08:34:54 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 03/13] mlxsw: spectrum_switchdev: Do not set 'multicast_enabled' twice
Date:   Tue, 21 Jun 2022 11:33:35 +0300
Message-Id: <20220621083345.157664-4-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220621083345.157664-1-idosch@nvidia.com>
References: <20220621083345.157664-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P194CA0002.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:800:be::12) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a08f041-7a15-4add-509f-08da5360eac2
X-MS-TrafficTypeDiagnostic: CH2PR12MB3832:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB38320BB58BEED2428397A8DFB2B39@CH2PR12MB3832.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fEJ+j2kLVh26qudmXrJz9JrG6V+m5aHYx9R63M5gBsOPZYSwqCvveQf7+lv9wSRtaVLII2sgqcpgzvbkglzTOOxpVWozTJKzVfMbS8CTaDqZZcnQ0nB5j6WHzpXch3/biw137LjxuFOjUI+VjOGo6rhTYURp8ZT4XaJMG8WnX5xW9y9sxIABBuZKW/zTPneutP5BFkSJPie9gf6HFzfjXlQSvbIZ464DsPUFZGhnZyc0YMCrjIq6TRDPOv9bBy0FZonnR6NEGyR4tRARNyibzxaWkOujHVz7VGL8mMv+ASaW4AQUbw0hNmmaaZoSVFtlrTnWsCVgJm9Ze+9rVVwjbMC61C6ZjcbI5pySH/erDLlN5d/956KyADLuGBB5h2L3NtDE8yzUF9+u3S4cBNIWSWMj8+TAJ8BNQXJbta63beMCjhj2AtD08BSY8L1usEod4J8vgGmzT4lPBuiNke6mnzSMtIth5+1fAfm8m4NmA7tX/u0eBa0Na5N5K1j6L7pTpdRGPOeNNFKd5tExOMuEYCYt7MDVparMq2ZCmfeUUzGCHFMK+hLC6L0XKvC/IDQ+rTMNPgHU8gv0AhLh5mskxAyfDkOSAZ4rqTWPDsYBtmVJK4wlsjJhnOu+igLaHazp7cYcePhhsACKWNvxUQ+ARg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(39860400002)(396003)(366004)(136003)(2616005)(1076003)(38100700002)(186003)(107886003)(41300700001)(36756003)(66946007)(316002)(8676002)(6916009)(66556008)(83380400001)(66476007)(4326008)(8936002)(478600001)(6512007)(86362001)(26005)(6506007)(4744005)(6486002)(5660300002)(2906002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qL/R4JedCPYeNqUz02tcnNbsQ6odXLdI+7EZ+FEYsllHmGJ694pn7sASPyp9?=
 =?us-ascii?Q?fWHFYlReeTeUya+MDi231l97Rr5wcUX2KLIEaLvEkXjr8VMRU/vZvMmMs7Xx?=
 =?us-ascii?Q?LKoAQ9GTUWYk1yEIWvUDaPyLeDbjz6V45sfj1zyvTiySS4nZfsJE4qDRck3t?=
 =?us-ascii?Q?DVdKE4DiKJFWXNs8DpZ51LTdisfMlDNOq1u4LdupUE52B5GCgWxoFecVME0A?=
 =?us-ascii?Q?ZdIl0zqNbmjrrEWqiq+ChI2aqH/lGyJF2x79sBjCTDMQsQz7covT/5nlw9Ob?=
 =?us-ascii?Q?Ezot+4fnavxb9oNtvStdcs3bN+S31Z6yS8hLpQkC0wTN7U9zp+XPrV8WZM8p?=
 =?us-ascii?Q?ytmnMC6Og8UOM4bYerxss9ydy2WWns1VwLctDOa2VsK3jVhh1dspfZ4z3B2J?=
 =?us-ascii?Q?Zb0r6zOzl79fVpCAE1DCvWS4hlPHvD+OIyMJdZndzIZsIjb2UBt7sxmEw4uS?=
 =?us-ascii?Q?0X93u205oqf3lE7cOGiw9fZQ1KWHtEQxPcm4fXhTVAYBL7gm2W2QVwDyHMXR?=
 =?us-ascii?Q?dtNHIjwnaI/85yeYggwX/UGXb6b98bJZDKgTq4QHOfsXKK2jGxfuigE/Noi0?=
 =?us-ascii?Q?kLczqKTJxY+wwVufijEJKyczZbRU5BVcfFEHx2DZYQIVOEw79g+Fjv0nBFn7?=
 =?us-ascii?Q?XJ/NjxDIeOYHaizlzuHLmdIZKleciCLUmPz1Ha2IBq9fDg/fzYAfzi5zDH3F?=
 =?us-ascii?Q?K7PtO+UOl1+O0ut1s+FGeNSQ93G14upq9reKAP18edG6sajg9+gZhHVOiOTf?=
 =?us-ascii?Q?xrBNZ399gxGBzR+o6I2Pg7/wpCnZaPPiWyp6f3qEUYzpKJc6+4l4hh9GaDDY?=
 =?us-ascii?Q?mz68nWpWS2S+EIQe3WcXJ5I8ajTtvHgxn5GuswBrnj3mo+Q1KED7qRJJ+8N7?=
 =?us-ascii?Q?5EFVoltOxnmOo8Yg+C972I4NBN0pMDWLRK9fOI1uoHuwpvoorVcW2KNcov0O?=
 =?us-ascii?Q?ZQn1UuW4VEREZAv2FVAXz5qkDkAayhi56fwbiWiDKr3ePDugKSIZGzsYbYeb?=
 =?us-ascii?Q?YqA1JLIF9Yig6IBV3Vn74n8aD9CUhSR6Ia5bg85j5aw/i3jJdtS9FitNGyp3?=
 =?us-ascii?Q?8k3JbCewQLW7OU1VtSq9wSVo6fBYi1+MGyZoU511Fr6DdajlWT3pd9XKEr+H?=
 =?us-ascii?Q?JY3+TZir6hyQQGvynNJK1qtRSGGINW4rDRFTAAnUmol3VsgYYmwTc8mKp3Fd?=
 =?us-ascii?Q?ZwPlKS6AUwrGVHyLdaZ9S66PuA4+na2QNmbj8v5cTo0ALqtMd7pfhRMRbILR?=
 =?us-ascii?Q?tQp0efHP2eyjFp5rTavyPo8zJFYKO/fX+DGA/70/s3BbPFknmHsP0tWAWDRx?=
 =?us-ascii?Q?YFMbnm1s5F24iAOi2jdLuW0f2RXWLIYb/dqpcGufUtQBA4zypelINK5h3FEe?=
 =?us-ascii?Q?WNh1BAD/sULUZHSOTxuyFC4ASEskThvgbuheD8lzQQdrshd3k8AHAw+gZSOf?=
 =?us-ascii?Q?q0nubl0x4vD56jjNJfbFkMPvtRfOxC+0c9QQH2Ag6YFe/PeOpW+snf/eQCXj?=
 =?us-ascii?Q?ArfFpu+QSpQh34TCKkCjeECwXfOBFLAkBCE+t0AjEEgZKOkWpQbBOWCRMQ1K?=
 =?us-ascii?Q?Rvj2uObjzJhO+LWsYmou5FbM2t7BMvw3JLrF7A1Cqm+sTO5Fb8vKl6lhP7tT?=
 =?us-ascii?Q?yD1vS8aUg45BhUiQeHhzSDrRQTqzDL5aLOfGynnl3w95zoLic73k/wC+5jP/?=
 =?us-ascii?Q?vwDiFY/HTwlGtm/jg9uk27jbTVPRyvZoIugxikw6O7SPIHi5VmomxznkA68u?=
 =?us-ascii?Q?bfvyxewvOg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a08f041-7a15-4add-509f-08da5360eac2
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2022 08:34:54.8165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cmGL5qGxCTah92+vgPoXR0cLdcy6dlGtey3hIiCiMB8mVL0hNbn4AyjoZYBkvS4V9jqPSsxOfGkZ0V6YW9GGmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3832
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

The function mlxsw_sp_port_mc_disabled_set() sets
'bridge_device->multicast_enabled' twice. Remove the unnecessary setting.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 099ecb594d03..85757d79cb27 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -870,8 +870,6 @@ static int mlxsw_sp_port_mc_disabled_set(struct mlxsw_sp_port *mlxsw_sp_port,
 			return err;
 	}
 
-	bridge_device->multicast_enabled = !mc_disabled;
-
 	return 0;
 }
 
-- 
2.36.1

