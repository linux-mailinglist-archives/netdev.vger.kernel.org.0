Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0524FF9E1
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 17:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236366AbiDMPVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 11:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236398AbiDMPVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 11:21:30 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2088.outbound.protection.outlook.com [40.107.243.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DAC439B80
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 08:19:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nj43vggwSD3rjmJsc2nvcuxZ1DwQMiSmj+fUmbO077snA++QHtEG09TBHzFFv+qTawkxG1/SzdU+nLuhjAnhwJHftXa71xmx+Om982+GEQMsIcwvsi/hTNJ5o5mtmc6I0LYuP+Uz1xF2J8A721eY903cMrLzJFvl+QHFB9dmQSIsvS9/JH8lvVm2QKeo96wmIms+yq+/5UpMQvwowGL+33+cOCA4Rfr+cLavroGTTp2cSDJACum4pnS+S33l+C12sfYnrFq2fnXBdwJd4HyVzFM9+mXsp6jxxifM1XNwkMO09UkZomUJQZSfhOv/uRMR/bKKxI1ykJDpGg64Jy5Vrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bELZQPi3CxouDaEj3ffFIRf7ZoRdABasrG9GhfqIryQ=;
 b=mfVMsrZkY9EO/HUB8+2H3O0/+9ofkeBwju1ItOwkbyIYkf6cJfqyzOxcLCjj1zBD4dx3sULtkOcDx3q3D1sw/DOxTP1AU2MVZvdpcTOrIxdtQLD7NHYZQFqtqN8KU3bisXzxtgXVcwDgNIzz+hIMXXzgEPP+4/HYK8cTQpnmQyp6c/RmC8VH/H8qzLaCTkLdeCf3FI21XJ1VJxHKcjz9e0aF2di8byPl1le4sZkTwtaSqnrS4SIbrEM23kIArXNKp/CEG5oP2jKmnehWLVEGabs9JOVWhmm49LOehel84QuzAtPEW59SyU5F7LSZRzChKUPtuQnG782xGBVXy/qFOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bELZQPi3CxouDaEj3ffFIRf7ZoRdABasrG9GhfqIryQ=;
 b=apIBL0QcO37U990IfWf6vXWYtWmfxefCJBroLG3sPbFoX/D9Ta/U0twojZN8wfcKZZ2nte/KNW64vWcEn/E2FMGj70nntkbzzHDPIqiBo8GQk1XdxKqz3wr/oq8Et1Cla+pffOEiYuy6kly7F9XSpFhhP+yNU0HACN+eMSHJco7j9aFOmjz+6kjmRwkaGYyAvpyBBKFKuI4CRIZlNjJtSNYqmWpU7YLiTWPRsz+cn8kJY3g7Q2hQS1VIxtnCmFpGVHpLrYfKQx3xJhqRJctbvAJvOYDamGbw2jk1BNxZG1OyVghGQ5haG3SxB6CIkFRRav6BLb5+igIn6fR9hv5eKw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by MN2PR12MB3885.namprd12.prod.outlook.com (2603:10b6:208:16c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Wed, 13 Apr
 2022 15:19:01 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402%5]) with mapi id 15.20.5144.029; Wed, 13 Apr 2022
 15:19:01 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        petrm@nvidia.com, vadimp@nvidia.com, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 8/9] mlxsw: core_thermal: Use exact name of cooling devices for binding
Date:   Wed, 13 Apr 2022 18:17:32 +0300
Message-Id: <20220413151733.2738867-9-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220413151733.2738867-1-idosch@nvidia.com>
References: <20220413151733.2738867-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0252.eurprd07.prod.outlook.com
 (2603:10a6:803:b4::19) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 44360c7a-4a60-40e6-979a-08da1d60f069
X-MS-TrafficTypeDiagnostic: MN2PR12MB3885:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB388513963798CA0748F3E9D3B2EC9@MN2PR12MB3885.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nFi4xYnaG7JxcSb8JBLuDea+DzJzeIPGlrqO4OK63jegH1lYoloxZA2AdESw5le3gwCq2sJcnrzzvg0SaejTXxYQ9zKAOqNlJRcErHGDVR7SSv14nKCKA3hnE+o0Va0CQuEajlGE/U2iRG+454HC4tGObkpsVKqfyg0TiWTN0Ll+nmVhq+XQj9BzipVFv2kTZ9NGtd7L6QmOkuGMB8YieD4JP9EjD83OpKYPr1uHGML39GCy8rxurMoWs7NUBVPv5OLQXZbOf/u+LJNktTPRsgs9HhQC6740l/Mx9+cX4qG6uRtH8UR37HUGT24Y1+JvM24vAyyv3clZ/jqLdKTf2Qe79LqaqEuGEG110s/NN8Pk1goC2oc5RWUmV4kljNej9mkX8htp80lfkRTMz1S+SFOKy/vHM+VOFGKrqaQ7clq4LUDRw1zguNNGAjzKh0JKCj7JmVdff6hQHE7smOQjBlDesWGidJ3ILM44ahx/+FO7x1F2ZLPCbe/RAhr2XojNJIDAaY3lToFjWIfouMLe4g6vfzI2q/4LF/272ZEWuu3/bwankmyRaCSlgVfiIEgpdOHfg+zWe2UBcx4Egzg286Y+ih0v1P6EiIaE1/dE7iSTp2z2QBjPodYjlsjrN0i/aWEAGZ9g8PWMcDmQbi+Rpw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(66556008)(66946007)(36756003)(2906002)(316002)(6916009)(4326008)(8676002)(83380400001)(86362001)(508600001)(38100700002)(5660300002)(8936002)(26005)(6506007)(186003)(6666004)(2616005)(107886003)(6512007)(1076003)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qSIGnNaNLJZkyjErFj3YqhMEAFLQNISITaSST+n1T6V60ap5YB+S3zhnBnpb?=
 =?us-ascii?Q?+vm072L2ANV3Flxp8OW9nlATt1uRP1N5Tb03GlxB/nt+l6m0hRfONmyaLtwU?=
 =?us-ascii?Q?29aplSPLZ5a85RgWqSWvt6ZL82z1FSQCrA8kk0vgnDKalobiAdxQqILwDyFK?=
 =?us-ascii?Q?xK0VEqwzfcRZn1RyVYkX7IOIUzsHCHW2E/d4HXMry33GZoSx+Mp956Yp9MO7?=
 =?us-ascii?Q?ywmAPC/r56FEgiH8lv1LYNec6SNHE2fhRlGrZG0YvSUPAKI2iy8M6w0Iv8sB?=
 =?us-ascii?Q?avKSpUo35wQ+zdMRoRRPTnp59FibrfKKdpol4TIbqhDk2y8/AvNxzI9VP4lo?=
 =?us-ascii?Q?wxZKd2vJIWiHh9Yc0cdZAN8u0QdWGTfKRiOWuvF4MjYu0d2KuOx2vntapwqF?=
 =?us-ascii?Q?b6Vf5jrkIfzkjwHa7uuleDPN2Klogw5f8R9JviCrRvNlv8BGNnL0eHCyV0eH?=
 =?us-ascii?Q?k4Oa15zm8D9FLJRmy2sP6NI5zcC1Ky8o1YdxyFNrWzc3vLnQERaQakIP8Mpu?=
 =?us-ascii?Q?cfNAQ+io/4Fe2n09Lk2NmwKc9jANddpibYc7xxaz/BEvRivPnPgV4wzBxHYc?=
 =?us-ascii?Q?Jd4S1gT+hdLEQjrc/XbJLrKEKGbhs3ruMk5IP+SHhFnHq0ijrA29ExuIs6SN?=
 =?us-ascii?Q?6Vvb22UVbVOaPfzQoNDp/Xyp8vmeMK4lJrM6rHsQmeTa6L/Woompw/r+Tqi4?=
 =?us-ascii?Q?fB4cmjrDhkOt55r8lZsMBuHQDSTHd5UYFW+iHXmulg0+9IA/kyKxqXRttwrK?=
 =?us-ascii?Q?zHJ12+4UAw3PDB+pdkaOb2Ek+oGNmBrT46ScerBWADxlIEoZa4dA7DHABqR+?=
 =?us-ascii?Q?1b/oSzNgeeiwnI7mxtglbal+69g1BVOmR18LMIowvuKXwAUpxpAXfWWv21Dr?=
 =?us-ascii?Q?e5oPu2xUxFLQDM5OQxrbO+XS9zY+/KqTridoOZcPbA5BvNi6HRCVzRVchL+v?=
 =?us-ascii?Q?sSjG0l2el/BBmCiWvZl47s8ZmbTACh+cswgQCE67LQuYfVoE2HyQIIJNrGp1?=
 =?us-ascii?Q?KRgrZuDxvjdJ89wfj71/57YVmEtI/EXvZkSKDWZQfDLeohQDGZOcKOS7YfaA?=
 =?us-ascii?Q?mMrgHf6GLesOBdYdBcRZSQ2iZxZO8XaNzbF2gT7TV64ZyqikNhtDc9B/ScLw?=
 =?us-ascii?Q?ccVoQNDdzsUTe7xlnjiO3HeJUHnNmkVumtWdebKpqKKV4LhtishDqnPfNvSM?=
 =?us-ascii?Q?11S6Zgi+PWT2ueSxJbCSblOd39f6a+U6+PKT+U6Fg76qYNr6DNG5WJgsd6fY?=
 =?us-ascii?Q?PXAykeZGw3rlSv51YlFsu3Q7TG29wTYgvG8cY2aLK97GOW0pNSRpYgmEU4zV?=
 =?us-ascii?Q?yLx7MlZGTzRgmzEXBbT5ri772EtqU9F5v22CAG+Ho7er7O5FtUkDmQ6Ch3vW?=
 =?us-ascii?Q?DWDXc3D/sxlxPy6Jyp8DF/pXPrkAZ2P6eAgHRAHTSEXROb00szVqCg7Qg2Dr?=
 =?us-ascii?Q?2ExJ+XAw+Ur3RcCcBhK+VPim8KSwo5ogXc7YHWv6qN1h8v6JxkRQNarU+kpU?=
 =?us-ascii?Q?AMkXOieKTd3RzCVl31gFE6Q0cai6QHmy7dp9/FcsD23jW/VVrde7iVxA8kPq?=
 =?us-ascii?Q?jyVkqXo8+GuNsHkFXcQqb0yrbyRbha6DM1Vk3GjtLOWrEf6tnvWod5CjY2os?=
 =?us-ascii?Q?2eQIkzV6ENqvgysyoQpCevQUMNP3Y1ZTqUdjLaHKlduwR6Q3UsuhmEQgYadc?=
 =?us-ascii?Q?RJGyEmWTeNlYsnzbuIpvSTqTW4us8o7xhs4qndUFFphLsYMFWa4JovtWmg8m?=
 =?us-ascii?Q?I0kiDKr8Sg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44360c7a-4a60-40e6-979a-08da1d60f069
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 15:19:01.4801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3TWm7R/rEGuu4+MgioRpfT1FDlvI3DNPFfhuIH2IYWWRxxgBt8/osMpzdO7uKSQ38u14lmOaCzTcMULJ/WqFvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3885
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Pasternak <vadimp@nvidia.com>

Modular system supports additional cooling devices "mlxreg_fan1",
"mlxreg_fan2", etcetera. Thermal zones in "mlxsw" driver should be
bound to the same device as before called "mlxreg_fan". Used exact
match for cooling device name to avoid binding to new additional
cooling devices.

Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index 23ff214367d3..49ea32457703 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -129,8 +129,7 @@ static int mlxsw_get_cooling_device_idx(struct mlxsw_thermal *thermal,
 
 	/* Allow mlxsw thermal zone binding to an external cooling device */
 	for (i = 0; i < ARRAY_SIZE(mlxsw_thermal_external_allowed_cdev); i++) {
-		if (strnstr(cdev->type, mlxsw_thermal_external_allowed_cdev[i],
-			    strlen(cdev->type)))
+		if (!strcmp(cdev->type, mlxsw_thermal_external_allowed_cdev[i]))
 			return 0;
 	}
 
-- 
2.33.1

