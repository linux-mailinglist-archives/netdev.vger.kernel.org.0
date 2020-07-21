Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD9322868D
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 18:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730375AbgGUQ4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 12:56:55 -0400
Received: from mail-eopbgr50063.outbound.protection.outlook.com ([40.107.5.63]:57383
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728042AbgGUQzv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 12:55:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hXcNU17tdH9p6XZrF2579sCadFkpXEQzERpRLgZPi5CtU5OUU8C9AtlljXSMZxkFgRZ91wrFUvfF4wXzbf0J6TRYNAmSmFKWXpsHRHOyEvErymQ/4MJbIuVdHjPYw2OgshBD1TjlPh8uBrfdBkgqyLehBg15d+yoUvJlZ4U9VM+GX6oYrHwf9ee2l8FryFE1zvOnkQ/6tP3f+ut06ITwuDjTTq/71NhB6SKgSnlWcvdd8IuJpwA3HfGz6G7KpgF1sUtpFqEsPS1daDjTXrPk0Qsv0oREt2qP2EcgXfx9DFLeDdsH3YBTGBTm4Dze9Ahm013YJ9Nn0Q+/XGPH2HOTGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+TSUuOflhyfbQvM20TbEMalN4E/XgoNZxrK5r7TcMAY=;
 b=OCT5rp6/a164ErSfuSrz2IyNAUf+8EYp+MzlIzL12yBogC6ANetVelURhICNWfsZvWTa2ne2hxuyNJdbsb4niS5fQc1NatSuMAwn/F2++7Dt6qeQe3EB/Q/zj7b9vYanVHjHZOmftYiYbaKVCS4Rr74MdouILUmNZ58cPaw4oyZqLld2A6PPMO9wg1mGzc5eTphSJXgc8sRysZcEr5KZO6lieVcbDBBGMxFeh0l8tNEzlX86bY6VXoJb5/jvRJVEx8b41MJPN0Um58CFxK0cEV17zUr/LF5Mz0/XA8bfQSw5vthYQGZFqt/iGlECKlC506OlDOV/lnLDWjmxzHS1oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+TSUuOflhyfbQvM20TbEMalN4E/XgoNZxrK5r7TcMAY=;
 b=SvkCfeJtqejHzLH7B1+0gvqLt1oYIHQsDKLBQEsU1tFiFzutZFSJLGz5/qDRg6kv4v8kII3xbycljfevpvby1mWjvlLrgRc31GM8biPoSWn/vOLpmqGSurkYatWU/Xv8YNejjpZmuR8CPBM/70UqJykDtPPF/cJ8zZP+4dBdfPQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
 by AM0PR05MB4739.eurprd05.prod.outlook.com (2603:10a6:208:ad::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.23; Tue, 21 Jul
 2020 16:54:13 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::d44d:a804:c730:d2b7]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::d44d:a804:c730:d2b7%2]) with mapi id 15.20.3195.026; Tue, 21 Jul 2020
 16:54:13 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net
Cc:     jiri@mellanox.com, Parav Pandit <parav@mellanox.com>
Subject: [PATCH net-next 4/4] devlink: Constify devlink instance pointer
Date:   Tue, 21 Jul 2020 19:53:54 +0300
Message-Id: <20200721165354.5244-5-parav@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200721165354.5244-1-parav@mellanox.com>
References: <20200721165354.5244-1-parav@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0073.eurprd04.prod.outlook.com
 (2603:10a6:208:be::14) To AM0PR05MB4866.eurprd05.prod.outlook.com
 (2603:10a6:208:c0::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c-141-251-1-009.mtl.labs.mlnx (94.188.199.18) by AM0PR04CA0073.eurprd04.prod.outlook.com (2603:10a6:208:be::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20 via Frontend Transport; Tue, 21 Jul 2020 16:54:11 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [94.188.199.18]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9e635fe8-f1a3-4289-2816-08d82d96b1cb
X-MS-TrafficTypeDiagnostic: AM0PR05MB4739:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB47398B52B6B1DF1846730BD6D1780@AM0PR05MB4739.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Di0ajh5amh7ElOn9zv6BMepdnbl6QY3wPh0AMSM3ket1Gl1OUmlRJn9R/RoM2Ul/EJLT07Roy01VM1xMz044+r+DdB9/+STT7DnisRUvo8NQxAoIYj2oEMvzWRU2jyB7OPW4mp0d81FAobygrKfXft49Z5YoseUuCNFX3pPBqMx41CEYWueq8FCIvTdI0Qo/ZxoWtl+LqcjWggb1P2RiKnYX4T5d18BFBJg/tbDEjB1S0Opj2jr6gNwFpysun8S5rP17AWSAc/JMKvU68N349pLEnH8AnTW4SSeSTnW8J7qNg2ehKGocvOqQBR3coZH/a4JjR+CkckDv/GFlS9q6Bg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39840400004)(366004)(396003)(136003)(346002)(376002)(316002)(1076003)(66556008)(2616005)(956004)(4326008)(26005)(186003)(16526019)(107886003)(8676002)(478600001)(8936002)(66946007)(66476007)(5660300002)(86362001)(6506007)(83380400001)(6486002)(6512007)(52116002)(2906002)(6666004)(36756003)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ++xPVdHv1pIZrRswBtau4SYQrq7zwQANr/AM/+kbeeltPYc10v9B3tU+Q9zE5NzQG9ZrnZxOgmU3Um+1skHml02JNwkimvaCqU0ijwPlxIoyFN/+F8ruEwC6eQabizufelLCNo4Dk64BHuUZh1hvoHWBLEAi/Yy28W3u5I98exFTYOxXLnu0b9Coo0plk19pC7zIKRU/riUONJqziZ2VnAcdBj7RpQmoUohbJ5aukKveQ0DTGiPdJo6638XCEmOqaq3700DMDG+GAwuoPhvexHqCqspPix4KJfrxnBly0hLQEGeLfmfhYsyT4DafnYRkPvJpDCNZ4x1iVy6DuK9AI3fY2wLt9k0MKwN63U5g06xx7Cuj0AUhINoDt7pCk6+z+3DewNSqtpyP9QDsx8eLtb72YOqbXBOFfCqG2Mtn9EoE1GB0Rz2e36e7q7Q0FiI9q1U88qGHwa3FiTQlx0+jdRxFrLqpbj5dUE6TDUOEAVvc3z0wBczXRIlJkTD3GlJE
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e635fe8-f1a3-4289-2816-08d82d96b1cb
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB4866.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2020 16:54:12.9367
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mA2DvIBoX3JGQSWAqGoOq1lYzkKe2BIpu8KdOhTAiBCt4twN2haH5Kf538eb80xkIzpAcH7LZXv9e5M+Pp9Opw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4739
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Constify devlink instance pointer while checking if reload operation is
supported or not.

This helps to review the scope of checks done in reload.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 net/core/devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 5c74e67f358c..8b7bb4bfb6d0 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -2921,7 +2921,7 @@ static void devlink_reload_netns_change(struct devlink *devlink,
 				     DEVLINK_CMD_PARAM_NEW);
 }
 
-static bool devlink_reload_supported(struct devlink *devlink)
+static bool devlink_reload_supported(const struct devlink *devlink)
 {
 	return devlink->ops->reload_down && devlink->ops->reload_up;
 }
-- 
2.25.4

