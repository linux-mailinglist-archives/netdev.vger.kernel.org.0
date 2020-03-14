Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73D7A1853C6
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 02:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbgCNBRR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 21:17:17 -0400
Received: from mail-eopbgr50046.outbound.protection.outlook.com ([40.107.5.46]:31971
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727805AbgCNBRP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 21:17:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mXeT6H6Eo+FrNTYUMINXQdFYHJ3mEuQAUzV7zcq5TyXWpm+PF5Tj7XO0c1Nbpzy3Q8Zn8kdyg/f+Q1ECDZavlEuFInf33T7U41oTfPcjy52kR1Tkb3jSCV40upVPUgiXKKUZ1MBuL89gJP79M7R/+YGq1cArVbUx3iRZcoO34UsuoC3RCuIC9ZgKxeogw3gmz3e0fv7vfWz0Den/t3PXN+QBFD4E0NIwuLKFdvdWgL0L2Bu/HeT72L5TrFuWeFZuQNRJGgqpJICVbeDVuwRaW8ZnNOXn6KbERUAalwODhQSxiOKbOS3ulWNq/IZt5i4+tVcWHpNVh1tmVqZfSbYTGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RdKtSc4B5PXZFF9AxXATw1csvG/RhRxBVZW+Vu4v/h8=;
 b=M3ZiZfhc2gzGdj4mPyG70krPIf8mZbA/QLeGuGpsN9DWb1S7V8Mi+3VTi4+piZHqroDIQVf7mvrZjG4fpuI+frhytMGg9SnzWhnkqN7ZwBt3Yjn9m61P4jTY6LXGOeVJ2qHud3Td3up9Yu9tOmX7YspXGTW38CqqO+Htxiv3zmVlOdlcJU+1jXC18Osp0DwhQtAzKV2Tujm+J/A+BTw3n6lZDSEUBIJu6+WQhpzzjIKIn4zV3coxgTwDj0pCZ8P7XNoE3z8BrV9CI1iOXpapP1Hx/THOS61avlHoMzu98/npY9I0ybJ8aXgL8L66xoBhhXFmwIhvcKa38AT8y8mMGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RdKtSc4B5PXZFF9AxXATw1csvG/RhRxBVZW+Vu4v/h8=;
 b=apZh/AmlQnMruFHqGuLct6lOCXx2MjMg8F2GCBuE4zEK2FbokM1yW8RJG5ZegzyVinceC8F6UW7Cmj/T4eX1RBehzOPjxRY7Bw7PxT0q7pMYjyfCtZTuJBU6bjhaCaFEBi0VNXZkYOfAo3YBGoBYcVFQZU2HDhfrXw7br2N2zp4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6845.eurprd05.prod.outlook.com (10.186.163.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.16; Sat, 14 Mar 2020 01:17:08 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2793.018; Sat, 14 Mar 2020
 01:17:08 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Bodong Wang <bodong@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 11/14] net/mlx5: E-switch, Annotate esw state_lock mutex destroy
Date:   Fri, 13 Mar 2020 18:16:19 -0700
Message-Id: <20200314011622.64939-12-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200314011622.64939-1-saeedm@mellanox.com>
References: <20200314011622.64939-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0005.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::15) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0005.namprd03.prod.outlook.com (2603:10b6:a03:1e0::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.16 via Frontend Transport; Sat, 14 Mar 2020 01:17:05 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dd4d83a1-1615-4a71-0edf-08d7c7b569fa
X-MS-TrafficTypeDiagnostic: VI1PR05MB6845:|VI1PR05MB6845:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB684506E3476C13E41F909FA0BEFB0@VI1PR05MB6845.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:186;
X-Forefront-PRVS: 034215E98F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(366004)(346002)(376002)(199004)(86362001)(54906003)(6506007)(52116002)(4326008)(6486002)(6512007)(107886003)(2906002)(5660300002)(478600001)(316002)(66476007)(26005)(66946007)(8936002)(66556008)(8676002)(81166006)(81156014)(2616005)(36756003)(956004)(186003)(16526019)(1076003)(6916009)(6666004)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6845;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YXOgRXcEbAiPAh0Wb99DsgApnjWHtumt5PPdlSOsiz3mykKMsusRelkVe5t5pkRl8BiZAZfD+xDhUIwZidjm/vJVjqrS1S6X/h3hQ71X35B2kO+RxI01VQ01ATplarA6WyfM037q2IkUsy3us3B1a965VE4K/hC8bIPoYRaW3gvoZgucpfRniBizFQbzuiIM08+eCIfCFk8rBdESM3XF85WF7fyLV4dHJmLEJb9lShYVP8TMGBa9GKpUUuX2bKIQcxOfWdiIgcePBn5XWtw9610i6bseG7j0qt8lR+rYkId8GYLSmS2jJ0Q0tgSAhs4+wCagm95Vdj8auhlBdfRgylFXychuzECt5LNYKLz8uHkV7847ilILoO1swsJYkT74D8DuPxk7xQT3kizwMekwT/NkaP9cJJNQJUZLGkWo4flcT6O7qwoVNjZ8A66HIVtxOChQtZROo/4cgaY0unppgdYQnTXqDzXN33V0a7tfu8A1SS73VcpGTMP2jHUhyEJUsrk048q9/BUP92TahG1yoJ1BwUD2ga93m9b4RQadhyI=
X-MS-Exchange-AntiSpam-MessageData: SvDmtvobyyHc5Lg58H15Nt8bKWILPElHoMuCEwqx/jTkoUqMpwIGGEwjbGJPQfzbpWj8KcmsD7sUX1QZEcH9hnI6/dNJr/z8mBZE5yXhD5N47e1HvCGrGEqHnqSJRPJcr7hVjNpgAet0nsUuvdGWhw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd4d83a1-1615-4a71-0edf-08d7c7b569fa
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2020 01:17:08.3424
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OiN6b8yR2OOijwUJoA5p8hb6nj3pxtxj9DA9szA69xwwZ1fKbOzjDxtUaMhr6Z1Fiid+KfM5Pm3V1iNPB4Y8UQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6845
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

Invoke mutex_destroy() to catch any esw state_lock errors.

Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Bodong Wang <bodong@mellanox.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 54e5334f02a7..8fc351240f4c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -2239,6 +2239,7 @@ void mlx5_eswitch_cleanup(struct mlx5_eswitch *esw)
 	esw->dev->priv.eswitch = NULL;
 	destroy_workqueue(esw->work_queue);
 	esw_offloads_cleanup_reps(esw);
+	mutex_destroy(&esw->state_lock);
 	mutex_destroy(&esw->offloads.mod_hdr.lock);
 	mutex_destroy(&esw->offloads.encap_tbl_lock);
 	kfree(esw->vports);
-- 
2.24.1

