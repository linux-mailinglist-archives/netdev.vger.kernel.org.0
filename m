Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2EAE1E8DCE
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 06:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728657AbgE3E1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 00:27:15 -0400
Received: from mail-eopbgr130058.outbound.protection.outlook.com ([40.107.13.58]:61765
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726193AbgE3E1N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 May 2020 00:27:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B1LqeIWLibFj636tlUsWNxM9sCO+8qjv1VM2WwrLUYgCeePN0VbMpgEE5twHXf/RBZ/cDMr4Zu5f/CcVU4T/xxQHNaGQpXbNL1LPNhXh/Plkmv8EUza5u/SmBqjdQWqfVrwZzZcsqbWiN8Nv9LqG7GBe/9WT9JXiXHHuDIxQFTq8Y1bEYvrZ8serCDgf2XbiNMsb2n63f/L98OHn8xP5sX7GsX7bs700n5vI7Wf++YXKRLZvd7tpzbYgFqkhv5xrSEDO7VC/vDR83jBM1cpUW8ceWfhcgrGhVcceShc0/p1UA/pHirTBctd8MgD79vgqIQeOwdPe45Wtgz514dVhtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rxLQunfHb7Tz+ma/Q3Z6e0QA1tn2OKJtBxbt0huMxPY=;
 b=F2RhAmPqUzDM9eLdJPxHfFqgcAvqfCmJCH51nlrvmH9H4L0mFkiCBrXG+TUA/WyCuQT3u3U3u0YejF3Ln4CL0xb51ASQhAa1IX8D4AGzAdBLUuCnj3URIeDEOk1KvZgJnSSCrFAvTHowes+IVb9fELkSqfI+45v5Ck1i54ubeQMNdc3DqelkEfpx4YAdXSolzm/knsLlwYTgT2GL9QdEz6zaKRGRgZDfMkhxv0qGdiMg2ribgJ9mLwDZdNlB5M3lTI8o+DG9Km6tbJPkmiOABCE9JbFELE/mxOMuqogpzzvOZ3IfJLKbLQmADDU8wEehXE4CBqJCE7FDjQ319inlEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rxLQunfHb7Tz+ma/Q3Z6e0QA1tn2OKJtBxbt0huMxPY=;
 b=huv4QAQEZAjdW0Ou8GXQYeW1Caz1FwM8jlVFbxA0q6saKl9qZFVw+wi0iIGNkNVZfm3RplbK7MZG64aZRX5CKQ5UXyNceePlcUYGq5dvCZ5hpwGJf1PnsgKewzQC3+ywbhMf/9RIB6BrNVTKrZ/V5nYyD4H2cFvm3LJPFR0/GFM=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3408.eurprd05.prod.outlook.com (2603:10a6:802:1e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.18; Sat, 30 May
 2020 04:27:03 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3045.018; Sat, 30 May 2020
 04:27:02 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Mark Bloch <markb@mellanox.com>
Subject: [net-next 07/15] net/mlx5: DR: Fix incorrect type in argument
Date:   Fri, 29 May 2020 21:26:18 -0700
Message-Id: <20200530042626.15837-8-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200530042626.15837-1-saeedm@mellanox.com>
References: <20200530042626.15837-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0004.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::17) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR05CA0004.namprd05.prod.outlook.com (2603:10b6:a03:c0::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.7 via Frontend Transport; Sat, 30 May 2020 04:27:00 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fc6b2659-9f48-469a-4366-08d80451b386
X-MS-TrafficTypeDiagnostic: VI1PR05MB3408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB340880910868E45E88A02875BE8C0@VI1PR05MB3408.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-Forefront-PRVS: 041963B986
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e96wBCwq6lhJD28Y4916ZfSLO2+QC+xqckR7ocIiYjNq++aeiZD7Lh6GdSAWsciApYr4u5b7QAHrwf1R60++hD6/XcaUpbxOB2JnAapWyAbYofjy9C5arFdgMMDXWRpm2UKgLi6uuc2+3zIq+q9GpzeQZdBwem9fucZuSHH60jBgc7zY+ec185SxYpBvyueagPzfbbwD6muVuhcAk7ujRGospSxN+o6CiDRpq+teltqw1xZ+o8TLEr0auldp4cjzdVYyfRBlyPN8ROOqfN8k/OcBlKvRyqcC4LnEEEA659BOiQ9k8LjdQYZ/H/mr9cwsp8KWq6Mr1/KpcfAzsGl/g6XkJCLmxKa2LErQQaJD6mPBABUxs4qEepyRMVUUn6hv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(396003)(136003)(346002)(366004)(52116002)(5660300002)(6666004)(107886003)(186003)(66476007)(26005)(16526019)(66946007)(478600001)(1076003)(8676002)(4326008)(6486002)(66556008)(2906002)(956004)(86362001)(6512007)(83380400001)(316002)(6506007)(36756003)(2616005)(8936002)(54906003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: r4klY4bYoCOuzOSPC3908qnFkpcbJ2mAmtuW+YPY4UqzDkOI9LfEufUBZ5Tw+xVWVNSNZFV1kWpfLQYmRT6MT+Ni4qAIC6rTD+dpr1qsZW30uTh7Pknr7vB4Z52Lx10KNTd1+AXap1tf+vDQdX48zlvQght7ZnaPDIQe2F9rxfyKGXkwfx8RQOmhadCL08JIPNjKZJSQpC8f/9NRZuW4JFUTiLsqGi4YNkUJneTV0vS2bLsJK+9pe+z1nSfF/PEGZsEfdOQ2pgUdtWX7qWo/PSOqDE5hSUJHA3PKjp51rqyMVvnXXLosaQMNp/dPzzYHwCIjPa1ROfK4qHxHNnd/HmlNNIQqr3vGipOmPOcac9Qu9kHRKyvV3L6TKWGtbxrwGg0/SqJnnF7GIwZYkBQZbgpWazcr7AkPQSB8rHxLQ2h8t56M1NZit3NxyljVPdRU2bYFxrRQPXWJGHtICqLdbdzBQ7IOIYxCMfDZZfSjq2I=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc6b2659-9f48-469a-4366-08d80451b386
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2020 04:27:02.7905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mT2VPaCZO5X7Kh8APKSn7bIP1+pqV72FwxpXeO65DFAD0CsZuprrf5PdUVICrxihhjVPRCf8KG30KDUow4ZgSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3408
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

HW spec objects should receive a void ptr to work on, the MLX5_SET/GET
macro will know how to handle it.

No need to provide explicit or wrong pointer type in this case.

warning: incorrect type in argument 1 (different base types)
    expected unsigned long long const [usertype] *sw_action
    got restricted __be64 [usertype] *[assigned] sw_action

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index 554811de4c9de..df1363a34a429 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -1662,7 +1662,7 @@ dr_action_modify_check_field_limitation(struct mlx5dr_action *action,
 }
 
 static bool
-dr_action_modify_check_is_ttl_modify(const u64 *sw_action)
+dr_action_modify_check_is_ttl_modify(const void *sw_action)
 {
 	u16 sw_field = MLX5_GET(set_action_in, sw_action, field);
 
-- 
2.26.2

