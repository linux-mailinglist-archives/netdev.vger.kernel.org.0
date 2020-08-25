Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48BDF251A51
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 15:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbgHYN7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 09:59:25 -0400
Received: from mail-eopbgr80071.outbound.protection.outlook.com ([40.107.8.71]:60483
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726347AbgHYN7D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 09:59:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e14pgT/mOLe4QtpIo+BCd0jawFZtTgRR1trIROO6Rx19wbm+FtzQC2FloRY0uLjwaYNVtk45sCW/SsEwTqXeK0P3HDCxE7PGXY4gflNp4z9wuo8f1KaYrMyheeSE5Ge9220MpO+iWTWp6O7MJzBLe9p4iR1pepClNQdZgS+oG7KbN8LL0yuU0aekmeyfJ7bgIBbJl7cVS5nba9WiKfZBIB8SGb7fQIQ1EeSEBWYgU74mGW9gJEHOJInWmYKgJ5jRN7Cq7ZOEE5ltddYrDTrt3ZNetQ3kQTwRA5MVaV5l+4zgZwX8ao72MgIneG3NDcIfsYIyVFqasTj1/xsEyRZpOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/A+RHMcNA0PPkW53ALF9ayxGKd28LSxAGDEssGlk0bg=;
 b=ZpdPFCbWIzzqC5dRf1oNVwPn904xO3fortW2UnITlei16s8ams3Ct5pvuWE0fZ09AOihhs8bmSRHrOHg2pePnU+Im8ME2iIh6c1zE84eaTYEmfQD7ZGtkxQARjcXIgoNnITaz7Gry63b3blbHI1H5grD+NytTU/QoiHkERxta9jCByKTpZTIULFe/gmVEB5C1+zKxNNIh1MFM6oq1MjslN7wXhi29TfV5gP2WEZ4+khiibnCDAAuMGNVpTdEMuzgAmnL78awZ7kLSlgDibGFqPDTySHPj5xQMuOXpFdazifMUpe6DdPBVHdDR01NkI2cg8bq/V10bx0ZR4eBA/29KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/A+RHMcNA0PPkW53ALF9ayxGKd28LSxAGDEssGlk0bg=;
 b=GjHcSzYQjcHI8CKfZpcj5DjdxyBTj3PqLA8IdW97xrgRho2u5jiv7PTot4jgXlSQaG6JpMThEYtNKMMQQ80518chH6P6DdS9UT89vT4cQpSeDWf/T4mdu3A0MpIQ59PtvKrAAc8sLAr2FLtne9cQkUodSPS1FKLlKFdUNbIiEFY=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
 by AM0PR0502MB3649.eurprd05.prod.outlook.com (2603:10a6:208:22::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Tue, 25 Aug
 2020 13:58:57 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::5038:5c70:6fef:90a6]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::5038:5c70:6fef:90a6%5]) with mapi id 15.20.3305.026; Tue, 25 Aug 2020
 13:58:57 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     roid@mellanox.com, saeedm@mellanox.com,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH net-next 0/3] devlink show controller info
Date:   Tue, 25 Aug 2020 16:58:36 +0300
Message-Id: <20200825135839.106796-1-parav@mellanox.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0048.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::28) To AM0PR05MB4866.eurprd05.prod.outlook.com
 (2603:10a6:208:c0::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c-235-9-1-005.mtl.labs.mlnx (94.188.199.18) by AM0PR10CA0048.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25 via Frontend Transport; Tue, 25 Aug 2020 13:58:56 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [94.188.199.18]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9592cd21-60e0-4821-37e2-08d848ff0250
X-MS-TrafficTypeDiagnostic: AM0PR0502MB3649:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0502MB3649814700463F1440F40FB5D1570@AM0PR0502MB3649.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Isg6IcyY8TL3UBEQvf6S5doFp196RcBOLY//mibDdaH2hNw9G17BMnyJGlGwoYbx0IZcipQycaNqUrC7cDjMXB+OhyuC85bqMEqhvHMinD0Yc1rCsiEQytvVItcmJN6F5X1KTYntSC95iz+/C3hZ+NzMkfS6FQJytbU2Bbm1zBaMMRRUKP6golZJbJpYbnHYSvwDscG1CsYoSuBr58BbUViy3b/udyUbo7fUHpYZ3KQVZKoWCuEu5ueS+AHzmjqf9T/atj3dO8LZ1sn2G3/Mrocgplkr8SUr24Cqm2wLnDLW581POFpdLBvwAmguUAqA1msVM/wHCZO0ca6KEB9JXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(366004)(376002)(136003)(396003)(6506007)(6666004)(956004)(86362001)(36756003)(8936002)(83380400001)(5660300002)(316002)(8676002)(4326008)(52116002)(6486002)(6512007)(1076003)(478600001)(107886003)(2906002)(2616005)(66946007)(26005)(186003)(66476007)(66556008)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 2DYpH+buGiLqpcC2KDx+c1pUGIfgEOcwYpgqzOlAkzG6G9Iwkfk/38TOwTlGj0aK7cmfXbYnIq07wIMsGxfET2X7MW1vmGf2ZW6rjEdsfw0/DHy8mbeu7Pg6A6aoG3jivxhBB7MAknfHl0ewITqFQhKPEX2wmQLX9A+DFBLnUI4YUWuX6y2fQtThOcEtiykmOXRqtITvLmqcb1J6c+SE9WraPWnYlLjwuDPUXanH8WNA/O+rdOb4UW1wk8qrS3CPnNFojKfL/idmZcFBClomDcvVjR1UXoYmx580ggwElazHPexDs0WiwExruyGXwQ6x4NBm9afCG6jMpwm+ZwPxelqjrwLh4r1fKuI4n8NUdxcRJessgKtayflGSWKxGNZKSXLCtlwtnuFvae0HVb9ZF9ocWPPPbUJWl9uAGVQlN1Unmi1gqSctRxlc5EfdQ5g37+XxrUH8tVxqDLB+wrUplJrzMWlOOX8N6fVBfNe7bNkE816roGxuIk5eL8GR7PzhH15Ie+FMDcDvu912NiBO/8VQjsTMfcAhUeOvbUolVxxIUtL3RY6HdFQ1XZJashKdCz1iKwNp9xSmVoa6NDhg0AaJ/IOaz7nVxT5VVJTv8ZZBnyOCp6MQH4tCe49h+eHGLlxpzUDE3kbJRIrmrV0+KA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9592cd21-60e0-4821-37e2-08d848ff0250
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB4866.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2020 13:58:56.7945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +yvv1nboLW8dsbhEwh80VqqbPgTXoOMeqgZcaCEFRqGTqmYJ6dFelBQxaSCgz3U/fEAk5wkmPJGgW8dTwIOBaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB3649
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave, Jakub,

Currently a devlink instance that supports an eswitch handles eswitch
ports of two type of controllers.
(1) controller discovered on same system where eswitch resides.
This is the case where PCI PF/VF of a controller and devlink eswitch
instance both are located on a single system.
(2) controller located on other system.
This is the case where a controller is located in one system and its
devlink eswitch ports are located in a different system. In this case
devlink instance of the eswitch only have access to ports of the
controller.
However, there is no way to describe that a eswitch devlink port
belongs to which controller (mainly which external host controller).
This problem is more prevalent when port attribute such as PF and VF
numbers are overlapping between multiple controllers of same eswitch.
Due to this, for a specific switch_id, unique phys_port_name cannot
be constructed for such devlink ports.

This short series overcomes this limitation by defining external
controller attribute of the devlink port.
A port that represents an external controller's port defines which
controller it belongs to. Based on this a unique phys_port_name
is prepared.

phys_port_name construction using unique controller number is only
applicable to external controller ports. This ensures that for
non smartnic usecases where there is no external controller,
phys_port_name stays same as before.

Patch summary:
Patch-1 Adds the missing comment for the port attributes
Patch-2 prepares devlink port with external controller attribute
Patch-3 mlx5 driver to use new external controller attribute API

Parav Pandit (3):
  devlink: Add comment block for missing port attributes
  devlink: Consider other controller while building phys_port_name
  net/mlx5: E-switch, Set controller attribute for PCI PF and VF ports

 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  5 ++++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  1 +
 .../mellanox/mlx5/core/eswitch_offloads.c     | 21 ++++++++++++++
 include/net/devlink.h                         | 10 ++++++-
 include/uapi/linux/devlink.h                  |  1 +
 net/core/devlink.c                            | 29 +++++++++++++++++++
 6 files changed, 66 insertions(+), 1 deletion(-)

-- 
2.26.2

