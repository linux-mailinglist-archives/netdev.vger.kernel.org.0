Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB2C255C75E
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235198AbiF0NS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 09:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234978AbiF0NS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 09:18:59 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2057.outbound.protection.outlook.com [40.107.96.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5965C70
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 06:18:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YR7ARFTIXf0ZMRL9vV+dQni/+/DacHCdSnSdsRS193UaxIa3ILr8HgNI59nJEsfyf+6oz1Ymp1fHly9fPT1l3P0vqXiPjtD9roXwW62woUnf4ru/YUr6x20BbOqqENDHN5YQaxzzloL2OULKnWNwIAWEYUvVu4EdHSpaJcQZggD6DmC2idrP0jlP6vZ9dD8fH0JsSMsj9SKRmdv1vJvpVKstx/XtU8ZvyK7g+a59ACJX55fMinCZC9zjfNydhjyeJLXvFhF17Au/ewUHZ1tdsbo85YD0UFTLqayf+C1DZTLpgSL1GP49dXUkranQ9yMpfL9dgvbyMivQUYpnPpmuhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6IVnmQ3aCf/E+NwrMx9EcG7bGvbTwgbPcmlrfLbnwHw=;
 b=Njt8EEbghZ4+FgpKe5nd3fURPApNmYMa7c6yylTM5IFSJ13yf+7A4QYmA3RtCa1liLT0j8iSZpFvUWtu/y+wfzUCOcxrxmrxfxsfI86HujNDI3G4Q6uLwLh1C7vDjZhB3tqbcIwB2vtP3ZFVSZuCMs/dTwHRMb2xM3B1aWu53FYcvYxetK6zw9uKd42oI9IzHFJK/tLcQ7kNdVTWIS8aRlk/9wkfNJRLB0tK2Bqrt7wXYEvaXgSBZIjPJYwl5YgfxzkzzOy+gH/tSz7PNkIW/ZCfIv15WsDsY9XedqNTuzFeLYvJ95n/fAp2Yeju6YPIyx4jmZwDzKNmNEbNoP8KoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6IVnmQ3aCf/E+NwrMx9EcG7bGvbTwgbPcmlrfLbnwHw=;
 b=bNN2gNVINgcVh+msaCFgv/q0jx7fCLauhIolKopWhBeKyOI6+Ff3BuCc7PcPlgko2EitQ8s6RPpTzYlaZAqvvvCThqauw9KDDTYIMmpIsBBSK9vDsiKH1neFlPJC3wrIwa8Zhvt+cRgBsa6c5zM00sOPsKzngXs37TyHiMLzldQ0na8WxD1G3fbJQtjJ4/VnW9dWCYBEKAsRLl4MZMU7Rhd/qk5GAca8sHeAHqfMYb/riXvhyi9pQeSzW6ESYFvbsTKPPwsQC+sLLIayiazBuKFW6EFTNy8UO4LLpU2UZBwJsYb02IFrjNQewT66QgNahwYOC1pfKO05lxbtsS1L8g==
Received: from BN9PR03CA0200.namprd03.prod.outlook.com (2603:10b6:408:f9::25)
 by BY5PR12MB3970.namprd12.prod.outlook.com (2603:10b6:a03:1ac::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Mon, 27 Jun
 2022 13:18:54 +0000
Received: from BN8NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f9:cafe::10) by BN9PR03CA0200.outlook.office365.com
 (2603:10b6:408:f9::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17 via Frontend
 Transport; Mon, 27 Jun 2022 13:18:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT045.mail.protection.outlook.com (10.13.177.47) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5373.15 via Frontend Transport; Mon, 27 Jun 2022 13:18:53 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 27 Jun
 2022 13:18:47 +0000
Received: from localhost.localdomain (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 27 Jun
 2022 06:18:44 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Petr Machata <petrm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Itay Aveksis <itayav@nvidia.com>
Subject: [PATCH iproute2 v2] ip: Fix size_columns() for very large values
Date:   Mon, 27 Jun 2022 15:18:21 +0200
Message-ID: <8f45dcffeb5080d0f4512502cef35ef13ca29871.1656335782.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9e6c5b22-a413-4c42-665a-08da583f957e
X-MS-TrafficTypeDiagnostic: BY5PR12MB3970:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a85jqnNRAJH7fu7z6aREhsQmxj//m0sVWRwCLTbb1uc5eh/m1aNNIuNHWGx+E51feIRboptudpwbbdMmjTcIp7AtwdPFhpIdQrBU66AbiDmIP5fYcRNFAC/UZDLM9dXPN6KBozZCtPN5YOssXfpN/UydIR1uSSZFB8lz12RBbIXzC4mRuODs+xQZY16efrl+hkNdb6mVZdt4us4BWRGQsspjhK2Eit4PC7PPTu5qQOMmlqWx955tTWvaMeG1hLfCAekM/fmQgDCaSauMi3uusYkK58O9OvNAXStOIe0j8hvRIzqequrK7WpesYhRTsj6DPsBuZXv78D7Y/8we/Oeq9i6Kicilhf5EYugXDQtyWrSPiMt3OFEDGaMyUCyLUEo3saU15NXrX96zOZXYlXnJrj4eWfiEB0xLV4VuPOWFKC8xPIaCEww1C3FScMmXQkANbTBz5cgTu66LiKsFCwDIgTUPiwUilAyOnrlxVfwBl6JP8/3H337WM8a5cgmjftFmcwIzWh/jzWSNSAOgqm5aJLvoZ+go58A/hquNYFRg3dExeDeJZf8jqS1D7WIzM0Ki0s+KCdPcTmIxVKgNBYZ+ISEvyFbv0W8gm1y5YiF/aRfCF+VWTgYRM/Lg0D+fCQVDSznpH48V+H3GJxXYne3Q/JE5ZepDlKqH6zN0mAY5Rpe4DynB98EivnDVio64KsJgOA35ElAruflx0RAjKYhQ/G6e+CGeH5k0QviRryC0OK4W8ZULd2sJ3tB1DdANXqYTLReNDsVnccZM1ypucJtY4hGOvSSS+Nv+IpKPWgKB9OxMRmCuLD3DA6m94Q8uzANJqSUD/MlJsT9ZJxg1HP8Hw==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(39860400002)(346002)(136003)(46966006)(36840700001)(40470700004)(40460700003)(8936002)(82310400005)(41300700001)(36756003)(5660300002)(336012)(40480700001)(478600001)(54906003)(316002)(6916009)(36860700001)(83380400001)(6666004)(8676002)(356005)(82740400003)(107886003)(16526019)(26005)(2616005)(2906002)(70586007)(426003)(47076005)(70206006)(186003)(86362001)(4326008)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2022 13:18:53.8588
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e6c5b22-a413-4c42-665a-08da583f957e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3970
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For values near the 64-bit boundary, the iterative application of
powi *= 10 causes powi to overflow without the termination condition of
powi >= val having ever been satisfied. Instead, when determining the
length of the number, iterate val /= 10 and terminate when it's a single
digit.

Fixes: 49437375b6c1 ("ip: dynamically size columns when printing stats")
CC: Tariq Toukan <tariqt@nvidia.com>
CC: Itay Aveksis <itayav@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---

Notes:
    v2:
    - No changes, but CC the maintainers.

 ip/ipaddress.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index 17341d28..5a3b1cae 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -549,7 +549,7 @@ static void print_vfinfo(FILE *fp, struct ifinfomsg *ifi, struct rtattr *vfinfo)
 void size_columns(unsigned int cols[], unsigned int n, ...)
 {
 	unsigned int i, len;
-	uint64_t val, powi;
+	uint64_t val;
 	va_list args;
 
 	va_start(args, n);
@@ -560,7 +560,7 @@ void size_columns(unsigned int cols[], unsigned int n, ...)
 		if (human_readable)
 			continue;
 
-		for (len = 1, powi = 10; powi < val; len++, powi *= 10)
+		for (len = 1; val > 9; len++, val /= 10)
 			/* nothing */;
 		if (len > cols[i])
 			cols[i] = len;
-- 
2.35.3

