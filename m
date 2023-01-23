Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44CEE677CC3
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 14:41:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbjAWNlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 08:41:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjAWNlw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 08:41:52 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2091.outbound.protection.outlook.com [40.107.223.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7330C14B
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 05:41:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dz68Fxh++/ucsSZBbXRQFrvFpZ771LTgl/ftz0p6CJ/eAv4QwRkOM+Dm064nU/Vp28+RjfrNZrUccYrOiWoJF5QKwDt1tQnTdMsOn1zoEXafTQbf/HICTIKEM6q3+bFb8kHvtQZ/r8FbIZN0XNEKxCfaMFvgHQc/W0BB471QFhq2Qd1QjoABoT3KNUJ1yDvIi2qqoqeTgLjbapApPNECgFOA+snfSRQD1mF/3yCKKYIHuFTLYeAS7KmG7v6uIZmsI4pf1qWr+PtV21ya6Ax8kgEx/Qi76kqBSiOB+JlJyMq39Aw61Cwf/gSwHnGDf8BXsXnNBFtYxhHU2q2PC7EQdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mSz2mK236ZsN9GuGR/FiduqXXttcwFqGS0+2nBcmCiI=;
 b=Ngh2ImLyldhFxLvwR4UvwttR473ydIGuDIkoiYV2Ec8NSL5VCIlBeukZavcRBQUtN/Uji0PScAtuCbHl7lA36l+YFq0vVt7vgcgtuVclE8DSekc2y7hAgoWYPVPfabYWIsCfH26A15ny9EjP4rfbNOugf8CIZyZ4cAFVi5ZwHkehHcnxX+D71AxM79Mte78l4x2MOzjNNkx8eYRiQCqU1EROyQvQ6oBAPhwu7Q6LZCVQr2eR1pD88TVKKpZEH3RC9BJwy76H/7h38ktxo8Ga21zCq8R0MoJ6z+Ntg07EhfsFLj3J2CY2iJjAhyBQRN0a5ZVCfcEPJtFw6mOgfs9CuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mSz2mK236ZsN9GuGR/FiduqXXttcwFqGS0+2nBcmCiI=;
 b=rsop6RFWeAxegfMWLKrt0hKsqj6iT1EcXYo72MoZm8kfznWqzP3BUWjDoiHS4TiM5OD/V9GVGmDULsKyfF2Pjwp7PT91pdRHLwPzywfKiSxYlu5WfHOTWLxBWnNv7PBGLEbG3sbwBYMjb/2TODZdXO/7jXB+JgOKVJ7h9Sg0zcY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB5103.namprd13.prod.outlook.com (2603:10b6:408:14b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 13:41:48 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 13:41:48 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        James Hershaw <james.hershaw@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next] nfp: flower: change get/set_eeprom logic and enable for flower reps
Date:   Mon, 23 Jan 2023 14:41:35 +0100
Message-Id: <20230123134135.293278-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P191CA0010.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d5::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB5103:EE_
X-MS-Office365-Filtering-Correlation-Id: 31f95255-948e-4000-5fda-08dafd47936e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zbdQh3HihXSXF+cGXLAmg6rUJDPR6D+cY6Jlo3yKbdfGCd1TXMccbQB2tP/kONSp9SaS3/QsIliyvJIidvOOu/Y/69q503FC2ojHe+JkQKnYnq15zei5IID+4H969xRVLVE1q2k6GbQr0ntRN9T5tUxrWvCNYtLplNCT3RHyCW1Qo8h3xGpThrF32CVqINgu5Py4i76yg/iahqveImxLxWAAjT+IWzJWVH/a0B2o7+/eT6UxMS9m5TPxRsiSLF/Y1WPoI95q9fMB0aGfxM3ZrzN3cUWhTtfA0StuJh/kkpj4x08vLJ9qsiGUlYM388AqUL2OBJpbridvRNSzbKDm4Pfo3n2ExMGwAod9ghGu9E1mwBWr2Ay+nHkH+RnHUllWmWovJtlptj4gc+qYp60bCIc1Kw9lhzmvJ6WqrlPKh5TAiZ/rY6HePPNkMS4pq5wGInbt7xQj7YK+vP/iYW1KDx9FWfQqXXw468KesQk0gjoGG17BkmWlGqtebIrJyVphYj+xXICE4HHHya02PFb8KsKyZ73g/CvvZWkpjyAkSpwrK2vPq16pwReIBVCSpf82pMe/NFmHNw+joojgML8SSDGOSGCnW3H6AiJv9JeNyaXy4aOd1vSLWZotxkCt9g+Ymky+hUowUA78fJ/Iy9jHYg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(376002)(136003)(396003)(39830400003)(451199015)(36756003)(86362001)(2906002)(38100700002)(8936002)(4326008)(41300700001)(44832011)(5660300002)(83380400001)(52116002)(110136005)(478600001)(6486002)(186003)(8676002)(6506007)(6512007)(66946007)(54906003)(66556008)(66476007)(2616005)(316002)(1076003)(6666004)(107886003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?grK2dbkNloo/f77qY8VAdPxW5DJ9UY465YBU6IXpvEqR9d168KeYwxC2YUes?=
 =?us-ascii?Q?BymmhdtnRW9WJaHzlKVcII0QO5olfHzEMTor5oPugq2PzzRAwc+n+uH4Egp7?=
 =?us-ascii?Q?5h7jZEYaG+JqK0+u4cey9PXq4FHz3VzWubjwvo6XwKf5gkT4V0/1hEfJJkyR?=
 =?us-ascii?Q?YycSR29u5xK8s6LRNTSFjoZMcqFr8g64ZPHN13xF4ccOi9DTljPzb26BNwAv?=
 =?us-ascii?Q?5YT00zaPhp0wkOkktzteM0Ueq1ci3FtrNbsZbOKDTlmM7AmJvIrcUvhDQa7g?=
 =?us-ascii?Q?C62/YPQEnuv5cC+1nuTyJ0MMGf+B1E56TvZEFRFMZY38YyW07Afu/RC4cIvR?=
 =?us-ascii?Q?Jo++0r94TRLBUj8izNpXmuknfWQ778cyfJkgRpmMNSfjcpYMf+WQxmxhIifY?=
 =?us-ascii?Q?cWZHz/jwvyvaMdfRc+zz33rx9/OmEyZpenyI7vu/oUtCAt7OOFi8Fm+V4m6n?=
 =?us-ascii?Q?mEa4Zr34db+0FzYsk3zW/gOibdn2TwkzEF74XTRKGratszfC4ozxDTV6WjQs?=
 =?us-ascii?Q?SawcBvXSZ4LVlspOXmvRnZPp1et318Y0Lvw7i5Npw2oQ0bHzqVqp4YKGWWMN?=
 =?us-ascii?Q?7Exl+HOUaRr2V9apKe+xUiT93nI4+73N1G8Gw+29+MS6JPEzDp0aYhZ6FCzy?=
 =?us-ascii?Q?Zka0XdZh0JRVhT0/ygNHRMxti9lIagcd7XWycjCgDA7nfX++lVxbl9URqxlU?=
 =?us-ascii?Q?N64JVRx0g7ce5lQzAXhF83gZc9GIMTlKvvvWPxGHA61UDcUoY72G2jHXLswF?=
 =?us-ascii?Q?JJuRT89Fu46L6KU3bBK4eUHzjlFxxfliOytrDMLwfU0TQa02i5Ms6mP/kJNU?=
 =?us-ascii?Q?9YW5uP1GaYNI/9gOeAkcqN4CEppzMeCYIT3odNXOw4t5v6kOOwfyUQ6gyvk0?=
 =?us-ascii?Q?AY+AuC4wJ4rxuAVuovUufrgR2SjBClE8QZsXf6keOtd09H7CHX8cTLSH8oig?=
 =?us-ascii?Q?4k+ib2hWrs2ZO853EdLbkp4+W60WT4upREe1EgAacnIWm2QeGvBSPbUxaNJt?=
 =?us-ascii?Q?WgtzCQnkDvnPMKuTSL1OANqF4xc4Tgr3nOa10IoSQeTGxIDJ9omD3yNn6jFq?=
 =?us-ascii?Q?JWS2PXJG4WYZi1UoYhRPl81JZy8rLbA5+IBjWxBLYrUutNGJyXsC/pkgLmMB?=
 =?us-ascii?Q?Inv/gBw0nE52u4T07lYOAOzXkhSzGH62qreI4inTGv9GlKzMmAnBNoJT5HOA?=
 =?us-ascii?Q?NWQgX52+Xo50jOwlaSc3Xa5esC2anAAfDC+rJ031qb5uOo7KWE0tTJhgLTf5?=
 =?us-ascii?Q?9bbVVlHD7zwMmXMO+V5aeEyLFNxCJWYpHTzqGZtOp3iT/knmtcMqv/w3atsV?=
 =?us-ascii?Q?HwRR44jjTyAsPqDm0Z8IPe5NLXjqquQSC0Wn6zskxrbakY+UIiXc8LafZMRH?=
 =?us-ascii?Q?+YdMIzCN1cVH5lonJzHYMn9wkV6h4kByDMIdRGll7kzYEbBKmT+jW9dVLTVO?=
 =?us-ascii?Q?HN3/nLUhP1tX++k95+XecXjw8+AfRAqlwIbxzjQ8NRYFPQVPBXLMBSegMycy?=
 =?us-ascii?Q?qfjDYSU5e0+dWlI+05+NduFeZn2jwRdbNzLb6/Yt31W5Ofom4b3+nZ3sgy3M?=
 =?us-ascii?Q?RMzHVL4gylr3QbGaCm2GG2rVUpXJxmjPZWEfgfs4lz5ifLsBoc8qeYriQkCw?=
 =?us-ascii?Q?KEsyiPUXGsjQgiXup3VERN3f9Ju+h9nciU6OhlIz7KehCSYLArjPQ6lLEocf?=
 =?us-ascii?Q?zUTzGg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31f95255-948e-4000-5fda-08dafd47936e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 13:41:48.5761
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a4UeipAey+5OATSHN8eC17FYS5hTZpm2UWhiZrnIlwaZt0ob1pQF7341+PmSd0dMpz+Bp6MnVeLJFi6O9d+QfOV8TXEU0MDGjiJzpCnXJcY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB5103
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: James Hershaw <james.hershaw@corigine.com>

The changes in this patch are as follows:

- Alter the logic of get/set_eeprom functions to use the helper function
nfp_app_from_netdev() which handles differentiating between an nfp_net
and a nfp_repr. This allows us to get an agnostic backpointer to the
pdev.

- Enable the various eeprom commands by adding the 'get_eeprom_len',
'get_eeprom', 'set_eeprom' callbacks to the nfp_port_ethtool_ops struct.
This allows the eeprom commands to work on representor interfaces,
similar to a previous patch which added it to the vnics.
Currently these are being used to configure persistent MAC addresses for
the physical ports on the nfp.

Signed-off-by: James Hershaw <james.hershaw@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index a4a89ef3f18b..e9d228d7a95d 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -1905,7 +1905,7 @@ static int
 nfp_net_get_eeprom(struct net_device *netdev,
 		   struct ethtool_eeprom *eeprom, u8 *bytes)
 {
-	struct nfp_net *nn = netdev_priv(netdev);
+	struct nfp_app *app = nfp_app_from_netdev(netdev);
 	u8 buf[NFP_EEPROM_LEN] = {};
 
 	if (eeprom->len == 0)
@@ -1914,7 +1914,7 @@ nfp_net_get_eeprom(struct net_device *netdev,
 	if (nfp_net_get_port_mac_by_hwinfo(netdev, buf))
 		return -EOPNOTSUPP;
 
-	eeprom->magic = nn->pdev->vendor | (nn->pdev->device << 16);
+	eeprom->magic = app->pdev->vendor | (app->pdev->device << 16);
 	memcpy(bytes, buf + eeprom->offset, eeprom->len);
 
 	return 0;
@@ -1924,13 +1924,13 @@ static int
 nfp_net_set_eeprom(struct net_device *netdev,
 		   struct ethtool_eeprom *eeprom, u8 *bytes)
 {
-	struct nfp_net *nn = netdev_priv(netdev);
+	struct nfp_app *app = nfp_app_from_netdev(netdev);
 	u8 buf[NFP_EEPROM_LEN] = {};
 
 	if (eeprom->len == 0)
 		return -EINVAL;
 
-	if (eeprom->magic != (nn->pdev->vendor | nn->pdev->device << 16))
+	if (eeprom->magic != (app->pdev->vendor | app->pdev->device << 16))
 		return -EINVAL;
 
 	if (nfp_net_get_port_mac_by_hwinfo(netdev, buf))
@@ -1995,6 +1995,9 @@ const struct ethtool_ops nfp_port_ethtool_ops = {
 	.set_dump		= nfp_app_set_dump,
 	.get_dump_flag		= nfp_app_get_dump_flag,
 	.get_dump_data		= nfp_app_get_dump_data,
+	.get_eeprom_len         = nfp_net_get_eeprom_len,
+	.get_eeprom             = nfp_net_get_eeprom,
+	.set_eeprom             = nfp_net_set_eeprom,
 	.get_module_info	= nfp_port_get_module_info,
 	.get_module_eeprom	= nfp_port_get_module_eeprom,
 	.get_link_ksettings	= nfp_net_get_link_ksettings,
-- 
2.30.2

