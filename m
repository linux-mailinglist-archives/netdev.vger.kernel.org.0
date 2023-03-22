Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFF66C442E
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 08:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbjCVHf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 03:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjCVHf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 03:35:56 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2054.outbound.protection.outlook.com [40.107.243.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B548F5A6F4;
        Wed, 22 Mar 2023 00:35:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DZCUfd+LwYmoPYGoizIk+jNRTOxShBt9DEGh54rYvwhfCVcSqZ/VmRVROIgUZqrmLvlA8k6627MhKeEaMV+4gQcEANalemdrL4PNnewtv2Y6E5qp4qgnTUsM5oGQYVrxcCLtN9Zkm3AL+qBP8QL0mFCvuIxRabamRV9eqaRas+QDF37dIETqsJOwYz9QGDL9fiG0QtCwgDQuxWq5PWkUltoVsc1EHk0MPJETTxwPyNfy3RiGRF3bY8eKnWPhTteQLluYfKb6VGUzLJN4HO+1hX3WF9jVaK+kxP9W6EWOMn7KdV3uR+5cqb7Dt/SXDW/lgaRvak3xFPwo8UwF8P0gpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F2snrFClXrxEYMywJIQ4YJxrvd/RLdw+MmG5M5Iz+1M=;
 b=mILnNFOgSRD5SfEVQn6cBUa420Jn8Vqan7Px/WblCvU+7q1LZFOge1hwp+HNkCVgbdZBDkPnJVq8LfaRL88V+NUdv4CKUfetXdaQE6uhMJVLMlVsxCpA4muPHSiaA0PXZHpdezhBscTwMOKfK8PPzd4MKwltWtilBtUOm4Nucq18GVKSVhxTXWlQ2rdNt5ZEiUzKvIoJWLLb4KR5mdDqKr4roEjS80dcx5VB/zfKJL1TK88L0ZL2x0as5Ci3lDjPKMDmJ2PnCejiCaH9gXthBB2f5O3sQrQm0Ve0AoRoKjayLC8gtnO3ZcYHlq46mT9OzF1ujz4eQ+tpu/KhTR+Asg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=netfilter.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F2snrFClXrxEYMywJIQ4YJxrvd/RLdw+MmG5M5Iz+1M=;
 b=Lw74sfYdN8qm3CMKQIk0ERXqAwfEM5A3xmTNZtGdEHnKeUPqRmPq19LbU98MTg3dphkLt80asL0RUJxXQa+SnWgzeGbATOSpDdQjDY+C9+ERwqYRkvDktAV8f4WxXzjPVX9ao2Agb9ol2LWuW4PdmmGPwVJKj01TbcSE5El4Aj0luFpvBLPdxby+TcUnJn0xec7hXUac0TS9HqltUZqVL43pWBcQSVm9sYF7bfjTrIP10uR5VGxQrZ1Pk0joM3r97iLpEmN99TJxbogrtW/fluVSyGMF1OZPAyOh5j/NYg5efXFFabugBBnPWUHgenIS8+UGRTQ5t6QGOeRNtxEtsg==
Received: from DS7PR05CA0066.namprd05.prod.outlook.com (2603:10b6:8:57::11) by
 DM4PR12MB6445.namprd12.prod.outlook.com (2603:10b6:8:bd::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.37; Wed, 22 Mar 2023 07:35:53 +0000
Received: from DS1PEPF0000E637.namprd02.prod.outlook.com
 (2603:10b6:8:57:cafe::ac) by DS7PR05CA0066.outlook.office365.com
 (2603:10b6:8:57::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.17 via Frontend
 Transport; Wed, 22 Mar 2023 07:35:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000E637.mail.protection.outlook.com (10.167.17.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.30 via Frontend Transport; Wed, 22 Mar 2023 07:35:52 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 22 Mar 2023
 00:35:41 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Wed, 22 Mar
 2023 00:35:40 -0700
Received: from c-237-173-140-141.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.10) with Microsoft SMTP Server id 15.2.986.5 via
 Frontend Transport; Wed, 22 Mar 2023 00:35:36 -0700
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        <netfilter-devel@vger.kernel.org>
CC:     Oz Shlomo <ozsh@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <coreteam@netfilter.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH nf-next 1/1] netfilter: ctnetlink: Support offloaded conntrack entry deletion
Date:   Wed, 22 Mar 2023 09:35:32 +0200
Message-ID: <1679470532-163226-1-git-send-email-paulb@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E637:EE_|DM4PR12MB6445:EE_
X-MS-Office365-Filtering-Correlation-Id: 4de09292-f6f6-45a2-55a0-08db2aa810fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r81vk+LE/59bXbBqNaePBy4PrbhaDkNusmDpMfXNAsZTzgWo3fFJ+MqEmHwIQWlsR9p2lma6likaggjbiuDzCQfg8rD39+TndjQnVeAaYmCgcCnRhX7hVJdJ+jPmF/tL4onOjWBGHTsi2lJQ0yjtr7t6hd3t//7LzgOwjUouRpIksW6WW9Ig2cNRiVZGSyEAdkMuyGjMXOI4/9RJckuGOmDzu4MpjlukSiJQkFcgPhAzPAO2L/mUZ0O2ydsNH0JYq/+MCoZbjCwvmZpkD5lOx/vWwc1nM4R7XMV270wM8ta+njVS+1CiNJwV7LB0vv0wlDoTM7GJ1EiVoWFJTWAJHBXbRUXh0Nu+SReFjYSa5shVWHiwvqKI4E/z4SX8PzidfxIoaw3ab0YPsJUYBVfQpTZgNfmr4g6IWgQ90PHEVjZujJByUbZ+vdKbcMD0mxtuBoWCzAHSa07a49MYlHfv0XHgEy6QzkkBeF6azY2OKiRTPg2HdpzFYq1oNGwI2K2uwOITFNbnewxr9WwQ3BoGoEFilEsTgKUSvCrbkttbdQ91+RDSn4iTQozL3DF+UhjXxODCGWyAzub5gc1rXU6uCTE3D563QsA3Eyq0ujul6w5hH8N3BEtI1vt01STdYiiv+8ng7d4h0JDy+LjAvidOJq07UI/l/aZp6rRyXO82PK2/kOQq3LdP5M2g9oTJ8R5/rnV5EqVTUC8+bulCu+HEyQKSpOtlSgFMFzAwfLNW8CZ8NrLnBgZ2kh+yjh315OD1
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(376002)(396003)(39860400002)(451199018)(40470700004)(36840700001)(46966006)(86362001)(82310400005)(40460700003)(36756003)(40480700001)(316002)(83380400001)(4326008)(8676002)(478600001)(70586007)(70206006)(54906003)(186003)(110136005)(2616005)(426003)(47076005)(26005)(6666004)(336012)(356005)(8936002)(5660300002)(82740400003)(7416002)(41300700001)(2906002)(36860700001)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 07:35:52.9470
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4de09292-f6f6-45a2-55a0-08db2aa810fe
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E637.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6445
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, offloaded conntrack entries (flows) can only be deleted
after they are removed from offload, which is either by timeout,
tcp state change or tc ct rule deletion. This can cause issues for
users wishing to manually delete or flush existing entries.

Support deletion of offloaded conntrack entries.

Example usage:
 # Delete all offloaded (and non offloaded) conntrack entries
 # whose source address is 1.2.3.4
 $ conntrack -D -s 1.2.3.4
 # Delete all entries
 $ conntrack -F

Signed-off-by: Paul Blakey <paulb@nvidia.com>
---
 net/netfilter/nf_conntrack_netlink.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index bfc3aaa2c872..fbc47e4b7bc3 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1554,9 +1554,6 @@ static const struct nla_policy ct_nla_policy[CTA_MAX+1] = {
 
 static int ctnetlink_flush_iterate(struct nf_conn *ct, void *data)
 {
-	if (test_bit(IPS_OFFLOAD_BIT, &ct->status))
-		return 0;
-
 	return ctnetlink_filter_match(ct, data);
 }
 
@@ -1626,11 +1623,6 @@ static int ctnetlink_del_conntrack(struct sk_buff *skb,
 
 	ct = nf_ct_tuplehash_to_ctrack(h);
 
-	if (test_bit(IPS_OFFLOAD_BIT, &ct->status)) {
-		nf_ct_put(ct);
-		return -EBUSY;
-	}
-
 	if (cda[CTA_ID]) {
 		__be32 id = nla_get_be32(cda[CTA_ID]);
 
-- 
2.26.3

