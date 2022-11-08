Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21F38620D9F
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 11:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233868AbiKHKsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 05:48:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233203AbiKHKsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 05:48:09 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on20619.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::619])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7421B419AB
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 02:48:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NPXAXCRg+MLZYtldWRuoqu2Z/DVHVjqQPZFC1zjh9MipcCGu8BroDTuyYk6L2yFG+EF2YL5BKL7Ea9b08Vryv+D6lVgHvsSKme8orBsFvSjgPknY9dbRUQgE9zsY9WRODq7RHOT2V4WfEajvXBr3rvPciME9oHgSBGI4UVFJIXJnPZeZ+dFdYC2NPoAlLuqFC6ZBUacur0C9r62OoFZ9oMdqBmrJvPL0Mp5AyHu3Bsp0K7FPEM/X9/Nnn+rbZFTosVnDP1i18xJSf+qjIZ71nSYehcraw0dVD2Y3M9in8frn65fHVbZaPvuxS+MlLF1Qhcp1dlTI9vzE5cRB8+NIgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CI+GU5wtJ259odUNlmPhjajoh1bx0gxT17jrad7ZEvo=;
 b=b50KV2p3uugYYVMz/I1S3uxUm5kJ/WpQIzqkOLFpiXQw3WWJ0NOIg0K+UawDSXUrXK7+5ZNSYqFSeAV0Aw70cKWabNv/RFww4bcmGobndG4ks7nj9qjYBSxhTKhKPOZPPpORsynfbPmkwY8vr6VGGSRbtamu288x/zIJTNj/2tiYbxgDN0U+qfg4fGlHM3JQ0smWI8WSWctPfoGzUWq1FK0NSQ9jvz0oClL1cbetZ4zjh7bHXyuJNRIMAQ8up8BBkDxjwJf87Ricx1CBHhyRLfrGu4v1Xe5VRssNy1Yw8gHXe3HLXErUIaIfHXV/H5mJqLkDkmcEn6pXF9eM6693aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CI+GU5wtJ259odUNlmPhjajoh1bx0gxT17jrad7ZEvo=;
 b=ooT+IH6PDXGGUxWOrs1eUWRO02WgiswIFekqnhCqGKljZwoO7wu+7i0RPcPAK1VVmtYV8obtCH39ks7Vxyn12AwpjgqgmQvKIg9pp+rD+S3YnmzIeyMH1dvWuU+URR+JNnvs4iU26ufq6bHgZw7/6uQMWin5dqNxz4p8OtxQ3r94xwwPP2/BO/dv/kBq15TSifc1UW2uX/3UwKWxf3X5d5hyhzvCLwriOGWgmVdGKuVKWqHHFpAu/5OZEaK3sgYf55Aw41ZJjegitPYtkVKEyLKL/X2/ZMVB4reTT+G2wfnRVid3TWg+fPl4knvq1oBzNhZQm1RH99cK3XtjZza73Q==
Received: from BN7PR02CA0021.namprd02.prod.outlook.com (2603:10b6:408:20::34)
 by SN7PR12MB8025.namprd12.prod.outlook.com (2603:10b6:806:340::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Tue, 8 Nov
 2022 10:48:06 +0000
Received: from BN8NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:20:cafe::da) by BN7PR02CA0021.outlook.office365.com
 (2603:10b6:408:20::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27 via Frontend
 Transport; Tue, 8 Nov 2022 10:48:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT057.mail.protection.outlook.com (10.13.177.49) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.20 via Frontend Transport; Tue, 8 Nov 2022 10:48:05 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 8 Nov 2022
 02:47:48 -0800
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Tue, 8 Nov 2022 02:47:45 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ivan Vecera <ivecera@redhat.com>, <netdev@vger.kernel.org>
CC:     Nikolay Aleksandrov <razor@blackwall.org>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        <bridge@lists.linux-foundation.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "Hans J . Schultz" <netdev@kapio-technology.com>,
        <mlxsw@nvidia.com>
Subject: [PATCH net-next 03/15] bridge: switchdev: Reflect MAB bridge port flag to device drivers
Date:   Tue, 8 Nov 2022 11:47:09 +0100
Message-ID: <2db3f3f1eff65e42c92a8e3a5626d64f46e68edc.1667902754.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1667902754.git.petrm@nvidia.com>
References: <cover.1667902754.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT057:EE_|SN7PR12MB8025:EE_
X-MS-Office365-Filtering-Correlation-Id: 87753c22-69d5-46bb-5f41-08dac176b798
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /ZbecjekFsM2n0+awJtAx1zoA4IJwybfS/tq+/7SzLstD/KgCwP4XS5TGddtsLOZwBjuS4k1SXzNMHuYfNbxvJkaI/FZF5uI1agDhMQQHcdY5MaTRmn2XeARJz5zNtD/IHrBfbka6mOpcmXED8sL/g0Gvhv9VFD0iUAvIprj5dYB5eRqo/dRJtQMZG+GeGo4iJaDqAIBBM/ymvl1KapPt9Zu/DlAjYHrocWz53ZlHu44vPAg/+4n/5taZqn/HHyEtXfoV+Jyu7qoCHFRx2OCEXAqXjzag9j5UGoFiRsxYQCzQlN5+QRX4fV5+44S+oTQ7Zi1+akobuFC/jVTsF6hxKG2ifiV0WQ4bPtxGV8FPJpYq1avYQor4+HHphQkn1Qi7d62BVIB2nJaPvKVQgJw2QV0FfIko5NpAHqtyE7hMJVaWUDy6Z+whmjtvP+T8/X0U7xuwtuWL3DKxovJA66Go/A1OF79RBtx+aU24HcU/VdtLyGWk/mxIOZUiJi5o5p3dU55ypUkYzNkw5dT9Fj//iK+KFmx6YDkjaU7yKpmONvYE03k2j6I/0Q66K8+qSRh3pw5nbHNiGbPzrxM5gzj5H7UyOafQTbBPel7vkMJM8gJJ8CyAm8oC94EA0IhPGbtvBtfgseXB3TGFLBYvR0sM8OgilRP3NJLL3TEZSSAmfMtARUxq08qL/d7DUu1ABa5oHi+UVQfG2yp0V+D7vLTe43gm7pYiDIjp+CONdmG9SDlbySD0LCD58r6V9St6cWYhJvtW7GqUuFzSn/4JCLY9g==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(396003)(346002)(136003)(451199015)(40470700004)(36840700001)(46966006)(8936002)(82740400003)(5660300002)(41300700001)(8676002)(4326008)(2906002)(36756003)(478600001)(86362001)(110136005)(40460700003)(54906003)(316002)(70586007)(70206006)(36860700001)(6666004)(7696005)(40480700001)(7636003)(356005)(26005)(107886003)(82310400005)(426003)(47076005)(336012)(16526019)(2616005)(186003)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 10:48:05.4833
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 87753c22-69d5-46bb-5f41-08dac176b798
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8025
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Reflect the 'BR_PORT_MAB' flag to device drivers so that:

* Drivers that support MAB could act upon the flag being toggled.
* Drivers that do not support MAB will prevent MAB from being enabled.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---

Notes:
    v1:
    * New patch.

 net/bridge/br_switchdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 8a0abe35137d..7eb6fd5bb917 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -71,7 +71,7 @@ bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
 }
 
 /* Flags that can be offloaded to hardware */
-#define BR_PORT_FLAGS_HW_OFFLOAD (BR_LEARNING | BR_FLOOD | \
+#define BR_PORT_FLAGS_HW_OFFLOAD (BR_LEARNING | BR_FLOOD | BR_PORT_MAB | \
 				  BR_MCAST_FLOOD | BR_BCAST_FLOOD | BR_PORT_LOCKED | \
 				  BR_HAIRPIN_MODE | BR_ISOLATED | BR_MULTICAST_TO_UNICAST)
 
-- 
2.35.3

