Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 124EC62B409
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 08:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233125AbiKPHfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 02:35:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233064AbiKPHfK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 02:35:10 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on20629.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e89::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 856A82701
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 23:34:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=boooMHU5VgPnr1qbcco3iNnTwkjawe6Kg9m8bk+ZarI7tqitRuiWGIjPkH9m8FdV29vXEc8II7JhX4SD0hEpVjfVdbfOaUof5Jk6EPyQrwL2kRp1M6lN9P0QkGWAG0mjZ9XeURTy+pWb+vrYMUBK3Piip16qKURkLKsIdjzM3BcfE9XrTMNelZ9Q+D3jK6VFogbvHX7Ur9eUq5yxPeY+ojaz6TJIyg3O+gQmzkVS7kl+KgBmgj41EtuwgKESD2W9DvpIPYM5dQJ7PTqRaI56xRh1OXLq+rPKwYfibqxgU5PMW+6f2f4fy2Smd3vMq8oKrkqRpU8lbPU8BKwqVwebjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KG4TYHJVS7VkZHjBwO0CTNYVDUeyxluziJH06oNon6I=;
 b=nKERya+8Wi4GMrflmBzy0SzcbK/uMmPIt825ELMxwiX3X6+qPbyyfy3joheq2bK0AaokMME1x3e6cE0TAg3qp4l2OofsOf4KnFa2pJXJqDDivhobGtTeA3QA4/lPffbcyOAL7DjHs44+yd01jDNu7KYhbAIDZvqpRMJ3IDLZuCIZ3nCgx7tzzfXNlB5hON3fSyPhEG1+/npWvUDoHLFFZaLa2CiJBb3jeJuqtoW6v+b3Es24QJSwrgd5k0bW+f1hJi9zsdDm2t2Gfh6aqZUIcepF+o7mRGbvl1I0lon2jqurE7giOtHusU985BUt71iHxFZSZoNyUL9U8jc+cjzpKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KG4TYHJVS7VkZHjBwO0CTNYVDUeyxluziJH06oNon6I=;
 b=nO5poj4p7558OxLH5Cjrju4MxH2MOt0DRHlTNKkUC7gfCAPxg5iie0hyBRPAPTNioGfVgQDDLCbZQrFhBTKP9kaFwn0/TIz2FzjK4c/s/QpFcHG544YDQQWR4K9XMYse4+Ur4Fy3rhobEGI4zMi35hDK9KUtJ5kgvfDUKSjH0Vjfpk/h/SmIBpQ3WZgz4qnIjOop/+4oMf/DB23L3IuwAk7w0NpmP0WVoKeNZmx9z85apy86bEJV3oXF5ktzCsbkrFMO5U06DPuPsvg9gezqwofOnGh2NCozkPieNPS6IY+hYKtSMMWFw/BgWVtBfeFFydOELGrI7cGm5G9gf+kg8w==
Received: from DS7P222CA0027.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::35) by
 MN0PR12MB6032.namprd12.prod.outlook.com (2603:10b6:208:3cc::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.18; Wed, 16 Nov
 2022 07:34:02 +0000
Received: from DM6NAM11FT088.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2e:cafe::74) by DS7P222CA0027.outlook.office365.com
 (2603:10b6:8:2e::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17 via Frontend
 Transport; Wed, 16 Nov 2022 07:34:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DM6NAM11FT088.mail.protection.outlook.com (10.13.172.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.8 via Frontend Transport; Wed, 16 Nov 2022 07:34:02 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 15 Nov
 2022 23:33:40 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Tue, 15 Nov 2022 23:33:40 -0800
Received: from dev-r-vrt-138.mtr.labs.mlnx (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Tue, 15 Nov 2022 23:33:39 -0800
From:   Roi Dayan <roid@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Roi Dayan <roid@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        "Stephen Hemminger" <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH iproute2 2/2] tc: ct: Fix invalid pointer derefence
Date:   Wed, 16 Nov 2022 09:33:12 +0200
Message-ID: <20221116073312.177786-3-roid@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221116073312.177786-1-roid@nvidia.com>
References: <20221116073312.177786-1-roid@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT088:EE_|MN0PR12MB6032:EE_
X-MS-Office365-Filtering-Correlation-Id: 7141626e-4bf5-4dc6-bfe7-08dac7a4eee7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d8hSWmlDGzeCyBna/ZPiQqXCETFy8ZHDBoxd12m9jX49j7JNVGT3rwJjOue7+O0621MGeJqFRbdJUZScpFSWiL9pIm+U5opGOz2a1XOV+j44g4z6xKqpeE6c8BA6dzB1f9AfJJhNC5jjVlh6G5aESw0T3gYqivvEUiYs2cZxF3rLRiRGmWY0hcefokLRxel3jXwmtSsatO//ul9mvujZ/PAk7k+maBP+hdv5/c848prSsdznnkcCqbdrnmGEjaBKikokF5guuNoWPf0Jb6TLdy8bpQi0CMCssK+tXIxjUAKzR26XRZKf70x3f7QdIqC/tLpfLZa1His91KdbQqM3FehlKjQda2pg2LCADSnowjG8y1FtlGNdTgXkYKGkP/jIhw+fchaGfSlV4Njz9kb5XIDqkGtL9rXyCDXml8dtPfAklnMytdV59SUEAkP5//+tT0AoWukhcu/sHm+8BnRl63p20XcAwqQhqF+6xgUnwksmmlTS2mhzxT3GrXxtxQToeLZRvgzy8WhxCxED0odXhHlWGWM0v2rV84fCLTQFP46mu3eFdlqmcY4fQaS2MdH4QKmaU8EKQ44eNs4EHTmQLcMBjPdFp2sjMSeBQpz++yDdWkG1Ba5OM2ou9p3imjpjdMMqo8roI33Q4O6mqhzk8BzXHsFAkVBRtrIyz5gm68xekmguVeUO7qfVKSQVl7sP+8CgD102ADfF/+P01FVaxY7IKHR6+dKbvRQxzOTwFE78GXRHGiGozeoFfJliONzQGaNfhGjp9SoL2IcORL1i/w==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(136003)(346002)(376002)(451199015)(40470700004)(46966006)(36840700001)(478600001)(6916009)(54906003)(6666004)(82310400005)(70206006)(426003)(47076005)(40480700001)(356005)(86362001)(82740400003)(26005)(316002)(7636003)(1076003)(186003)(70586007)(4326008)(8936002)(2616005)(8676002)(4744005)(36756003)(5660300002)(336012)(36860700001)(83380400001)(40460700003)(2906002)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 07:34:02.1669
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7141626e-4bf5-4dc6-bfe7-08dac7a4eee7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT088.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6032
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using mcaro NEXT_ARG_FWD does not validate argc.
Use macro NEXT_ARG which validates argc while parsing args
in the same loop iteration.

Fixes: c8a494314c40 ("tc: Introduce tc ct action")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
---
 tc/m_ct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tc/m_ct.c b/tc/m_ct.c
index 1b8984075a67..e1c4b822f8ac 100644
--- a/tc/m_ct.c
+++ b/tc/m_ct.c
@@ -243,7 +243,7 @@ parse_ct(struct action_util *a, int *argc_p, char ***argv_p, int tca_id,
 				return -1;
 			}
 
-			NEXT_ARG_FWD();
+			NEXT_ARG();
 			if (matches(*argv, "port") != 0)
 				continue;
 
-- 
2.38.0

