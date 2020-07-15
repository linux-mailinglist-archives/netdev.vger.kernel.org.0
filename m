Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 686A52203FF
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 06:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728273AbgGOE3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 00:29:08 -0400
Received: from mail-eopbgr80085.outbound.protection.outlook.com ([40.107.8.85]:25072
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725772AbgGOE3G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 00:29:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZXNrY7NtNyeoy+f1j+PtDUXq9mTyAbledAwQipJXyEpy+ZJDwK68gTS/9t41XAy4oaP4kx2MHc/AFXJfjeKzMK6xZxB3wtsBAT7LK9ygQOrmYCpdTVZ1w5Trj/Ub9gmGkyEvrLn+p/MsQigx463pgoW1OIA6hNKL26kId7fB7zT8J5/N9f3KrdTdSK5E+k0hP+pOkjHsKlrm5RjcPe0mKEbt1+tR7AAFW/xV2b0sVsbNErQFc6zNJ7jv/KQpq6Yf0FePFBHnYZldFJlLPymriwEsN+N1EwbzI2ok8K1mwKEAapDbrSYXYs/rX/3ABtZNDFYmn7uTqMh5EIp126QTKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4OrynigjUQkBUbJF5A2b6jrcPyQS04qP8VprkEQKbhQ=;
 b=ScZ7iXrZtB/+rkXIwMsN4OPLcj414HRRN53Fm90qlUq+dQOV0K//r8VdZnNLaXdD2reHxj5DGsF384TNJJSozrQfVZjlm1WmigUGV0lHNM8l9xFJuUUGzK65LPP9+GdY82fsIrSICnwfq/kE93Au8RaOMIKtAPykNldM1OxgseAPXM1EY59fDhDVMFnzh1RJkE2Y8WyJ79cEEdJRpSfHFJ8Gxv1eUvFxPU7vh2DrhZMstxJ6KNTSzFtgHKf1jDa2isehkFh2f1xAkvm+X0N+L4oKbnHcJN2xJ4QmpRasPnxIBWvJ1jwl02tqx+B0ZBcPd1EZuxL1WaldtkDDJL7tYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4OrynigjUQkBUbJF5A2b6jrcPyQS04qP8VprkEQKbhQ=;
 b=PRiVJXwgVjrsZPZzxNXrwS0Tbg7Q//XC1AUc/6w6uYTbrVzhMUBCDpFySNun0skw2MzoH1By4l5P0TORJISZlHInOZYgHwg7JGFdQCiW6gU7bZgMnarH4ZM7JLKnzTd5ktsCFI+eVyhLT2jgxt9wtVTRos1DFeA3urppuU2vxa8=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6655.eurprd05.prod.outlook.com (2603:10a6:800:131::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Wed, 15 Jul
 2020 04:29:01 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.026; Wed, 15 Jul 2020
 04:29:01 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Eli Cohen <eli@mellanox.com>, Parav Pandit <parav@mellanox.com>
Subject: [PATCH mlx5-next 2/4] net/mlx5: Add VDPA interface type to supported enumerations
Date:   Tue, 14 Jul 2020 21:28:33 -0700
Message-Id: <20200715042835.32851-3-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200715042835.32851-1-saeedm@mellanox.com>
References: <20200715042835.32851-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0096.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::37) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR07CA0096.namprd07.prod.outlook.com (2603:10b6:a03:12b::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22 via Frontend Transport; Wed, 15 Jul 2020 04:28:59 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fab51403-2704-4271-f199-08d82877991e
X-MS-TrafficTypeDiagnostic: VI1PR05MB6655:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB66554DAF9A326C3D6887B368BE7E0@VI1PR05MB6655.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5rButc354P/Z1dD0Va1dWjfDXZVEqMf5ScHUsOUd/kbTNwvI2LO9JDl7ioeXivtjGFRs6a/ZrS8XC8BxY/06kLx2K6eEpZv3yyo4erR4KLXS45vOaIqlDmeaMNlETpsjC8KdhRgGfFhlWZyyrOkyaBdkg3lGujEhFoWtU7HymfcvCD2WmiXYrfOKgVgduEaKj6fetinmIX8WVh4LsWNc8fzAdGQ1gMAyoZqFWr47C9MXcnfBJXXek5Gy5ygUV2YmAcMB3Y56VV1VFBWSD+M/5lQ/+zbS6XzruEKaDRvUmvy70weOClSkwC2Kpp+kY5Dqo/TgVeWoSOGASVEjgrla5CD57fUwZIKoAbQ+lXjZw0KxHlZ4CBCMK+4mJfdQGfR8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(366004)(396003)(376002)(346002)(6636002)(6512007)(2906002)(107886003)(1076003)(6506007)(8936002)(6486002)(4744005)(478600001)(52116002)(86362001)(110136005)(8676002)(5660300002)(6666004)(16526019)(956004)(66946007)(66476007)(316002)(36756003)(26005)(66556008)(450100002)(4326008)(54906003)(186003)(2616005)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: vAHDhrEWQnjv5WR3r0yitnFDBN5uyLaX0Et/ypz+fbfYQp/tqsYVn6lCDcCn35hiR/KIdrfdA3bSKUdL6Ur/N+3H26gF2HwvCHE+Lk9yNQMZ9XLSEATGS3fJ7Xmlh2foqOyXQNZfv4OZKiqcWtcPuNKyuYJIgMIRvp5pyHPz8CZ9ud5doZUFOdr+wJQ+/BIcMAjyoUiT/hpeFgUHjPawGeB+lXceiU7/TCK+y0eJECWin0ajEgSBkEfmjbdHPOuAiynRYjAvgPhwUS9gllomv6tZrNcuB3IrXqAgmD2ZvfZEvuzv7PXPHvdxV7zuXZ/Egsa38TBuh1QtMyjbWnPlxWdikzl75Zd8X/r+B//s83eR9oJnEa4DDbjQaGSnHv6hBhp29gf/VIi+NeiVX1gmisTqSs3oPpaWCoAw/Q8h3qfpJOeJKfLkXygiAnheAzpeyJPZ71ILYiHvQWYsYqKiRI+kVlKt1IRXBf/tK/Zjubw=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fab51403-2704-4271-f199-08d82877991e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2020 04:29:01.1844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8+A7VdGjtUXpCQhzcIBmvoZpmnLCDZLN/QjoyIP/wEttkVRbIHN6KeblwZWWYuBxhDpfCTYkTwANvHQl/yb2LQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6655
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <eli@mellanox.com>

VDPA is a new interface that will be added in subsequent patches. It
uses mlx5 core devices and resources. Add an interface type for it.

Signed-off-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/linux/mlx5/driver.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index f2557d7e1355c..5ecc48831ae8b 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1054,6 +1054,7 @@ enum {
 enum {
 	MLX5_INTERFACE_PROTOCOL_IB  = 0,
 	MLX5_INTERFACE_PROTOCOL_ETH = 1,
+	MLX5_INTERFACE_PROTOCOL_VDPA = 2,
 };
 
 struct mlx5_interface {
-- 
2.26.2

