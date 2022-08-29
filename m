Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3BE15A4BDD
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 14:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbiH2MbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 08:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbiH2Mai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 08:30:38 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2061c.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::61c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20BC8DE3
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 05:14:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZrT2vrL39QSKgBGKzgEdUb6T6Qe4lJX2bCmARVk/je265x/ikaWXzxlT4oYFdi4qRpkPybr+PrkHZMeADEWHZ8CM6/C+dCuOrvIkQ48uTJy3zvhVzyYlqoUwSaP3F/J1eWO93CeWYdt3sJJVmEUeUy/4xjb5CEskPnArRWEiDjdfvgLfcdGJqwS0aUTAvouhj9PVPJpXX+7ZFXV2Zd7KRGGyxlxr2e5fVQ+Ne/mPpNOypcAd3H8z9SH8CmFheTlnpCP4R5nC1izA9dk4+deVTYwC7pwJQbQ69JjCNApEuNytHxJDH8mV4Q5+p/IBIRgGYqkM1ivIpyzQo4b/I7pw6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hnO2IOrcBB7dKOBPFigq3UOXl+3yl8Ika+y0P/LUi58=;
 b=RznOX0jEHVsn7pMoiXHXQgWOVNDAAngbSthk0qG/bLr9GOPRSnKtPQJTZ0z2sKkSS+62IbzvaPA9PjWnfWL551z3ylaGrP/dFi2IHsGaasuF6R9vrywtOLgyuSIfwIF1cU+s3nYMcmT6hDk1WnexnaXn01mqAsqtkb1jAtJkRVo0S1H1TooXCXAbNMZTnE5yOPNtjw4hmHg7HnEIbH80aZA79zBHr9z0AdTD/1JnyPYF7QGyNdhCJdUX/DOXDu7aLI2nHVplsIb0DXz0GqKQefM7+uNGZeezaHmytqW2/Jsk3LeLIe6rkH4TKl7I0L0q0MME3YQOWoAqgiUpMdbLMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hnO2IOrcBB7dKOBPFigq3UOXl+3yl8Ika+y0P/LUi58=;
 b=cXFVlXtsImicP16iZXfSAjfNJb+jNEZ8GySgxZCe1XYcT2md2LbGs8c5G4lZGoBMB29+L4y6EgDGWy8LqgpBxrE1uiHTqll9mdEr+WjsZ3ATfTt0DnmGHnZFylz+wSzmoLMzLGQ8gUczsztSMBpiBLxx/PQ/clwcySpg0qoMb8sv3pInvxJbooV3ut2jZDpk7qieMNr9Lb/tIcgazlj5QUPH+VO9/UmLEsza/5CEzJjSA/rZzMqrPOYTb9VCA98wu1Qa+BySAGZrwjt2jPChhVGZ4ZqIinizPlZUkAxhO//zgCGQnTk3//BFUV6c6G54LldEzd4eLDgtBifGbqQ+gw==
Received: from DM6PR02CA0077.namprd02.prod.outlook.com (2603:10b6:5:1f4::18)
 by DM4PR12MB6182.namprd12.prod.outlook.com (2603:10b6:8:a8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Mon, 29 Aug
 2022 12:13:41 +0000
Received: from DM6NAM11FT095.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1f4:cafe::c0) by DM6PR02CA0077.outlook.office365.com
 (2603:10b6:5:1f4::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15 via Frontend
 Transport; Mon, 29 Aug 2022 12:13:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT095.mail.protection.outlook.com (10.13.172.180) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5566.15 via Frontend Transport; Mon, 29 Aug 2022 12:13:41 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Mon, 29 Aug
 2022 12:13:40 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Mon, 29 Aug
 2022 05:13:40 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.29 via Frontend Transport; Mon, 29 Aug
 2022 05:13:37 -0700
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <jiri@resnulli.us>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <maord@nvidia.com>, <saeedm@nvidia.com>,
        <leon@kernel.org>, <roid@nvidia.com>, <jiri@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next] Revert "net: devlink: add RNLT lock assertion to devlink_compat_switch_id_get()"
Date:   Mon, 29 Aug 2022 14:13:24 +0200
Message-ID: <20220829121324.3980376-1-vladbu@nvidia.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b5aa2b5-1f3a-4d34-050e-08da89b7e974
X-MS-TrafficTypeDiagnostic: DM4PR12MB6182:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SY6WjYuqbG2iy9MFyM5QQgL3gBdLfSFgIKmVRvoZjlfdj4UuHGPAszhbdBVS8hPHOGFNZIDIwYwYDIh5rFjgs4XQPk4jbvUufO60TUZ+f0TN1ZzwGGCao/Aex823TXVC0Dk9MTotPYBa9UJAA0Lj34549c7m7TqKEQiD/Lez/rk1ZSDA9fKg1fyV9Xyc7cUjilCnF+IJXSdRvjiWqpzB/zeWEXHw8uK26sZNV7xmUNRutg+eYhsdR+Lj7J1iFOPb7xmCYOHpbgOoGvHMqE6LYWo7wlQ7TxG4nZSwZ/kGGGggkDRO8DSBsVyrFZmFQO+tVxkmlyEz7uNXIh70j3vah981xLWPwxIcbrqWYk96lYS5sw28eb6S+q8IidHvdTKiXErKKZxm9ezJKKVWvJRymldLUfFGDQvaB9Sa62ZdniiAVfSje9Se3Pwb3GAbWHdmE5NkAjf2VEAhb2D4W+P2dpt+XF8vg90cy07MKUnkQvy/G+XCGAOtspvgvobQxFNNou6bZvxay5RFOxVNdd0hVJ//UcTpfoh5EVUa3LulVXKcjCwpBz7ApK3Izt1F8Fi2TZIkUG6vRXpn4AmHXmHaZl6/tQpDCnJZOtyTbNbzsn+f2rKPKqx797d0DkIEHWIKSWjH82ehPo7gXaCMtn/KGZXH1TgjMPcBuFHS5rNFGYFTcM4mPvNrsPH65m7ucItVyRkv7xwIYuxQ4I+xIf6bmf3EjFRhjgpBeKSk3qbm5JUCrr9yM0MGH7NaDoEtfxFaqlHdCbKBTsAEKnLHehc1ip/GTVMsoJ5ZL3AC6IYxeiYjudzzk9IjiFKXx0xPtaqE
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(39860400002)(396003)(136003)(40470700004)(36840700001)(46966006)(82740400003)(356005)(70586007)(70206006)(8676002)(4326008)(36860700001)(36756003)(86362001)(81166007)(83380400001)(47076005)(426003)(336012)(1076003)(186003)(6666004)(107886003)(478600001)(26005)(7696005)(41300700001)(110136005)(54906003)(316002)(40480700001)(40460700003)(82310400005)(2906002)(2616005)(4744005)(5660300002)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2022 12:13:41.3968
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b5aa2b5-1f3a-4d34-050e-08da89b7e974
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT095.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6182
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 6005a8aecee8afeba826295321a612ab485c230e.

The assertion was intentionally removed in commit 043b8413e8c0 ("net:
devlink: remove redundant rtnl lock assert") and, contrary what is
described in the commit message, the comment reflects that: "Caller must
hold RTNL mutex or reference to dev...".

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---
 net/core/devlink.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 2afbeb6eca67..0f7078db1280 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -12505,8 +12505,6 @@ int devlink_compat_switch_id_get(struct net_device *dev,
 	 * devlink_port instance cannot disappear in the middle. No need to take
 	 * any devlink lock as only permanent values are accessed.
 	 */
-	ASSERT_RTNL();
-
 	devlink_port = netdev_to_devlink_port(dev);
 	if (!devlink_port || !devlink_port->switch_port)
 		return -EOPNOTSUPP;
-- 
2.36.1

