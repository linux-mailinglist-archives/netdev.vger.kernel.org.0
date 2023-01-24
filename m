Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE488679B0A
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 15:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234819AbjAXOES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 09:04:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234771AbjAXOEH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 09:04:07 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2077.outbound.protection.outlook.com [40.107.92.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26E88A7F;
        Tue, 24 Jan 2023 06:03:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fuyB31zh3Ov7W0fKolmYmL3ilwibfp47fsfYnRo2Y4cBbYjwYUjT2aReGp5dtjF3puz6eyIR3QJrTF9zR1CiXJyBh4BlWlTuTD55MEbQVO/5Gf9aLZwzegJIvymOdm0L/OS7O0pLTLW+su+qBnJ4vvzo9INrXJgdkdss49mXZAwdlDnC/gbZ8tyXqa2Fcv/AOZswHR1HYPW0x9TeQzImHwXMlyQQ8Q9Fr8lB6F9WHG+BOxGP+lHQRYEXT2oYGESFgttkQRYi0+I5YlOcBYuXEBn5dADbH4C8dgsTlFnu5bRgf3Yy8hoKtKvxWPhruXePBRy2+txDc8axy6r/ZjnNOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fc5chHB3Hj+JbD878mPb0uD62fVD37gKGI4Eclruct0=;
 b=fzZCj6FhN1GDNYsD7ZvmNQqhj94Vjhx92+HHwkhyh+Afsc/Iiq/riQfU1auHFc57qMKbSU8NJlYj0Z73jZHQwWkI+vU4aP2RQrQKw4LQSYKO8dhj/BboV4qIUNHpjy+Hggjmq0c3dphRM2T92tgCgcYnYvGXYRznJm6IzJ3pci+JBGBHJPkCjBdeMLrQVycGP0pdeJURb34BtJy1cV9Lj4lujrtBd27A0K/yAOCLJ6heoihZkhEI1rhCpsp3pTz9VNNNv+fythsXZZHTaaCK0eMufAMxysBgxlBMJBrP0WhvbBk1OwQlD1x9ZXUGDWGAMTbIqk35R20DIctP5T1R1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fc5chHB3Hj+JbD878mPb0uD62fVD37gKGI4Eclruct0=;
 b=lRn3wOmxwqh60g3pADvu9wzMGwGkyw08jGPJfF1Sfjr4W1vyMvhuBgpTWiYRKKSFph484QmhimODIV0CnjzC0jaXCieiau1t9l/YvkwtHZEflTUAP5BxpWxv8Zq2o4gA5C4rB/Ch3vOSqow14plnqJ/ncrAbv8c66ZSKrwioUT3yZrnm+1HluxD3dMbVZM2gDdEfa0zahdfkK7omv4dXYpsEDoRMG+qP2TBMqitpbKQ+1tCvsnAoiG6ZBwaukLco7VRP6BBaLv+kTL3Ggos2SAFxXHpuDDnkSUp8p3sftWWoBCGNcHGVBW9a/ntcRaHn7iUFMK5SF52rmYvF60KfFQ==
Received: from DM6PR18CA0035.namprd18.prod.outlook.com (2603:10b6:5:15b::48)
 by MW4PR12MB7360.namprd12.prod.outlook.com (2603:10b6:303:22b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 14:03:25 +0000
Received: from DM6NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:15b:cafe::72) by DM6PR18CA0035.outlook.office365.com
 (2603:10b6:5:15b::48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33 via Frontend
 Transport; Tue, 24 Jan 2023 14:03:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT020.mail.protection.outlook.com (10.13.172.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6023.16 via Frontend Transport; Tue, 24 Jan 2023 14:03:24 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 24 Jan
 2023 06:03:08 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 24 Jan
 2023 06:03:08 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Tue, 24 Jan
 2023 06:03:04 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v4 5/7] net/sched: act_ct: set ctinfo in meta action depending on ct state
Date:   Tue, 24 Jan 2023 15:02:05 +0100
Message-ID: <20230124140207.3975283-6-vladbu@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230124140207.3975283-1-vladbu@nvidia.com>
References: <20230124140207.3975283-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT020:EE_|MW4PR12MB7360:EE_
X-MS-Office365-Filtering-Correlation-Id: dfd4c832-040c-43d8-d323-08dafe13c269
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L0AfHpn8qhJTZT4+8xCnN16RX+AzjNevK5sHQeAfQrvxjLltUwJD/b6ORW+jFyOU5K5ELLosLTC4VnV3HoaoJgyqrLemCQwJHYttbHGTGLRvsvgxJx/tnu4JMc8wBMc56kMrq11Q9xKVrwBsTzq00xKzU8z/T9Ln4ahjQA/3Roo8kRWyPpXZRsIn/qSjxLlsajnWfgkP8oCBYq+TFLaF19m09u2OpNLBJmWOLex4yo2Oy7tmBy2JH3IOLLoGkHSLq0T0003TXmbhHzNkT06ut+GEhbA9yJdmHiqrwE4X7aizDgsAhX3nePij5AyRr7+P8DyHzQy3TmJ/qfNgZrx97auxSTIRxOp0l+ymt/dRH/Q7zsnRbaNqmcsaIJ0jxwEkhTv5yWa9RcBb9mS6D7wH/N/7145JT13DSjRr1X834zOAqJyQEgLVj2ZiabNkT9wF2kRDaOqeKFRWGGExTKTy9wfVjn/ONu6QQ16ladepD6K1MsgZUCJb3wP1cpyNvl1KospCiZ23bbNw6umDNz3jAkBdqMKmt/9MKhDyVveQGh+3HuvJqD1vjQHbtlotNPW1B86BC2fnnjvlS/719vrmLNsyVB5SzEjvEfMELBu4YG98Tp8gWWRL+3ddmW/QQIJ/ZM8aRuQ4PY5G7UVcUAdmzGjwQVQ7PCbdW7n3exPB0Ec+8OHskPzbIIA1aJNTmzro87KgT/QQjBbHJTMavU4tkGKLUqEXx3I7icnCoTOv8QLNgf2E7jjBzgLY6+O1Li9ezaj3CfQ71B4MwEJvsrJkAg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(136003)(396003)(376002)(451199015)(40470700004)(46966006)(36840700001)(36756003)(82740400003)(2906002)(5660300002)(356005)(7416002)(7636003)(8936002)(4326008)(82310400005)(41300700001)(4744005)(83380400001)(36860700001)(86362001)(40460700003)(478600001)(7696005)(110136005)(40480700001)(26005)(186003)(8676002)(316002)(54906003)(70206006)(2616005)(336012)(1076003)(426003)(107886003)(70586007)(47076005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 14:03:24.4333
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dfd4c832-040c-43d8-d323-08dafe13c269
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7360
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently tcf_ct_flow_table_add_action_meta() function assumes that only
established connections can be offloaded and always sets ctinfo to either
IP_CT_ESTABLISHED or IP_CT_ESTABLISHED_REPLY strictly based on direction
without checking actual connection state. To enable UDP NEW connection
offload set the ctinfo and metadata cookie based on ct->status value.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---
 net/sched/act_ct.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 48b88c96de86..2b81a7898662 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -249,7 +249,8 @@ static int tcf_ct_flow_table_fill_actions(struct net *net,
 	switch (tdir) {
 	case FLOW_OFFLOAD_DIR_ORIGINAL:
 		dir = IP_CT_DIR_ORIGINAL;
-		ctinfo = IP_CT_ESTABLISHED;
+		ctinfo = test_bit(IPS_SEEN_REPLY_BIT, &ct->status) ?
+			IP_CT_ESTABLISHED : IP_CT_NEW;
 		WRITE_ONCE(flow->ext_data, (void *)ctinfo);
 		break;
 	case FLOW_OFFLOAD_DIR_REPLY:
-- 
2.38.1

