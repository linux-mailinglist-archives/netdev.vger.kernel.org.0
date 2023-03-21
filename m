Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0216C31C9
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 13:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbjCUMha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 08:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCUMh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 08:37:29 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2053.outbound.protection.outlook.com [40.107.95.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E90843454;
        Tue, 21 Mar 2023 05:37:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mCPCTbl6IfW4WsFzkQ2ho8GQ+Yc2oM8hj8z5UAIj6ZL5smHV/Jn7M5Amd3razDwXNyZUzN6tVIhqFa8R1BGLQxPRjkgqrHQIHjKQhunWI4Utq0AA9uNTI3qzxPsmDykonGQLlHazZgycV6clvW3d8yqGa6DXP2U0A7k/Ddj3ZbvZphdmSCOTm20Re1zydfKzMRVZ5fDKRuyeWYlxYButIPlPrs+goBwR+/OJ5UERwtCu5/CHUb8vdXPkEIud1Su4uR71w/ENllYwUBcrgJ6bxQHIswwtdsiKON5tTFaWgGMVtlwYbpOHiq/x192FXw3PTEyl3qxucApq1fHBqYnFUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7wrkVJOnlV4B6F80bqOp5MKzIkkomQRRDEkN0xjMIAY=;
 b=S8HR0NO9g8yYK1OHp6e32i3UtMk+tHXfusnsImv9T4FZbiy3pBW5owMfC/jCmWZUkmatzbb1hVO5+rf7/QjUBHXITiclLFw/TI878ZjSzGHSFOk3kI34UtYQ0jwW5ttaA8RCzpN6aHMYtzpeDp06PVI5Rn0dwLc+embtCOoVuh5+n4evvc4xgj0MOXvMdgntGgAyn1n3JLYMmSuso2+R6RT/MG79kFA9OLV72HmNwue3hVydG8kfRdE1qeDqr5lpvh/T2RKueiYAb8SFgu/uqSKZaWw+DSuhvENZFCOnnQCeLvO2Jnosz6XxR84XAgx+grGrW/YmOZ+amwTIn4QU1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7wrkVJOnlV4B6F80bqOp5MKzIkkomQRRDEkN0xjMIAY=;
 b=cF1siXI4ELJTMlR74xMyx7jCpm8oJuh9RUbZnm62IR4tkD0N9WBwAFLD5pH5tNYSHpfFfumsZmZe/yDia9/7PyJ2ixDwPurDqxqcIrdLQcD4quzxkECMfPrNPIlux06H7jqujGarb/pvFReViDwkSDswHTAsQ7KeBaUA+s+Kf7xKAB+aw/H21gDYWUiFAG0mJ8lBGj0yjZ1txOqQ/8HBk7ID404aCcN1C5CxXsp5918oS8M5gWREq13B8ZNue4K5fierqwJUlnNM4xNvlA+7y1iXeDKp4gbmGI7FOMuuju8F+CwNm8dm6bk5EpFJJePheWqcURW7FfWY4YXjALvAQQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL0PR12MB5011.namprd12.prod.outlook.com (2603:10b6:208:1c9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 12:37:25 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 12:37:25 +0000
Date:   Tue, 21 Mar 2023 09:37:24 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Patrisious Haddad <phaddad@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH rdma-next v1 2/3] RDMA/mlx5: Handling dct common resource
 destruction upon firmware failure
Message-ID: <ZBmlBEldcG6rMcM1@nvidia.com>
References: <cover.1678973858.git.leon@kernel.org>
 <1a064e9d1b372a73860faf053b3ac12c3315e2cd.1678973858.git.leon@kernel.org>
 <ZBixdlVsR5dl3J7Y@nvidia.com>
 <20230321075458.GP36557@unreal>
 <ZBmav4CF1yqRvyzZ@nvidia.com>
 <20230321120259.GT36557@unreal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321120259.GT36557@unreal>
X-ClientProxiedBy: MN2PR14CA0016.namprd14.prod.outlook.com
 (2603:10b6:208:23e::21) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL0PR12MB5011:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f886360-2042-4126-e5d5-08db2a090666
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aHn+sh6QNcA29+O6DCP86VrAXoosp5lMu7UZww58MOXo8IhEYioMDMdEI+4SGdcPfAThHDqpeAtID7WlnxleKyblpOdCs/RNfIi2SNF8gz8ZHfiJOgBzLM3ZMxG/HrNtYtr65ef9Fk9pUK5E5HDAP86RKIHocrxwtOL8cW6XN+r1iDd4pgfCgYOpHMlBKmYDWIY1MAKC4hp4KUZ+7FYlMwsUnkb08xVxAkwD5/hv9s1LfNg1p2uA2kCH/2BZVwNI0viZL0fvIK4+0RjEKWp4AdVC1F4j/mujKHRteM6cNdSvfvk3SXTRPH4lChz02vFtypaQr7FZ/1IAi7AFitGATxqbBi0WDSw1YGWW72R4V/FfQDwwfpOxLBfhIvcKPMBOyF2tOp9kPvK7+z/4KnQ/Drx2qZIE6ASyyZlY6qWtvMLVPFg4xrsNP6DfkIyg6tPCjf6JzuKeDzkbLhwm7r2T8GPr/ZLdx0JDSC6xCToezC3Bma+8jZmbgc+KQ0DY9rgVSBH30N0BCwRh6dj9ll085e51I040okYvfCZueYK5zZOs9zZL43YfPKD/LYtYB0A+wXZkRTJqbEb+Q+mp5hkeIuT9emVpmmvPBedksF6IPGeF0nv+uCCIdL02ppyYimV8ff4QAiFjCENgSKQ7uV5oRw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(346002)(376002)(39860400002)(366004)(451199018)(83380400001)(2616005)(86362001)(38100700002)(36756003)(8676002)(8936002)(66476007)(66556008)(6916009)(4326008)(66946007)(2906002)(41300700001)(478600001)(26005)(5660300002)(6506007)(6486002)(186003)(6512007)(54906003)(107886003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hjpZS68XRS3wTXpgrpu80Cv/xvS3wr70Z6TnFkYR5+Uz1fkLo6cQ1+8ISPch?=
 =?us-ascii?Q?3L+kIuZjbRQyDX3q1pLWRRly889NRuARtBL5H4itk7ZIXBRH0Q0pFaqr6T5M?=
 =?us-ascii?Q?4zHGLLlVbESH2TKThCVZ2sewE1wjSo6JpRkT1gHaFQsaBgIAR4ZrbWQU8hiV?=
 =?us-ascii?Q?2M3ua8pwlhPygS0XXD0XHLFqbSeJISfWgmeLM901CNF/zYOMChbQ/DpHAchA?=
 =?us-ascii?Q?STpZ43hJL0OchUVnIlgjoz5WAq9QBbNA0NPtDk1YgfdVZ1QRlLps4ENabt98?=
 =?us-ascii?Q?I7TbfBmWEnoE6z2xYSxWTvSzNEbGDodoGIvup0l4jI2j+gkIAFY/QeXGBWYc?=
 =?us-ascii?Q?S/NXE2tAP6GwCpMymNH45rnpP88sP8nto+eFrxya7i47LpYgvq/13tWO7puR?=
 =?us-ascii?Q?1t2oSR5QikHMTNRj0hRI1Q7GQC+nJMFY6fpCKLABcXMSo/QEfdZonP+/kMZF?=
 =?us-ascii?Q?TP32Z3F9jh1viwULPhPOKxsb904K0P9YH6XrzTredmhhvhCHb41k0lSa0pNL?=
 =?us-ascii?Q?70L8lXh5YvHqf/qOMs3jOQsQsCOphix78yJTNstJlTezgtrvUjvR0fbL9ZZ4?=
 =?us-ascii?Q?KvHJFPsLfzrjU91HmWWhp9GRnAzJswW8hNH1shI9G7lvfg1ulu1laDehsrO0?=
 =?us-ascii?Q?ix7VtpASGM3/VKSeAXmp6e2edIFG5jg2DvBZoFCPaAOjTDqa0bgtv9HIseV2?=
 =?us-ascii?Q?B5Gy5TlXBcx/PylPm9nXOH9BM1bB3QWejbPXnp7C6abOw5venSOAXthRTV/m?=
 =?us-ascii?Q?fAfzpnPMbZH3azcuDE67o50GrEQ5yExYI31GUqawY/jjhTUN1OKMUyg6Cidg?=
 =?us-ascii?Q?s5khgPQDYCXI9bBp7PA8DsxATI3bkW/P94ie08+j6XnRU71Ajq5Hnh6ZNBZo?=
 =?us-ascii?Q?8XVdKRaOucU7pdJomfRvwJmkOU0cM0UpWwqUh+Jxy21sM4vvSgpsNHllh//5?=
 =?us-ascii?Q?psHkQPr4lkUyJAjxPOmlB5NZFAOtnvepLK1FdcJkva9ChOWMkGt+aB8usXVW?=
 =?us-ascii?Q?XGDeRq2NDLvxfexG3/g7jVkeesq3VdrOLixtgdzxetPgE8xshcxwgWDVfpUQ?=
 =?us-ascii?Q?UT/L8m9PfdDWcBztq9tmnXgYbBwQIAFdmBbmGiuKQEhDE39uaA8dpSTdsHwI?=
 =?us-ascii?Q?tWoOsTyD+OD4QKhbhDulAyxV5mDNh5pYSjSzVH3pd65TaVHS4tWRknwox3Fw?=
 =?us-ascii?Q?+4U4AJC1K3u/2FB5AyYpZRw1t+TNPdwNhai8HLZVk1sj8Zs29TwsF5S5lcqd?=
 =?us-ascii?Q?DoJdgQxeA6BugU4CRCJAUncxXgLAd/nCqXd7kCOy62DeqSTlzb0sZEzZxJto?=
 =?us-ascii?Q?BssLrzou1oN6Ay+cEnobUrnKzMNjcapEBsKlK3iP5bFmxgfe6sq/7MinsXYq?=
 =?us-ascii?Q?Payp/h0gGfzsQ4/j2ZAqLRuk6lpHdheT6AtIFN1yFeH74YMkopvsiYn08HVJ?=
 =?us-ascii?Q?Nl6A3f8ufRBBw1G48E5IiO4XY4f4ZsRPN0FkZk6FulpMeEAw1dgvKD5XFk1a?=
 =?us-ascii?Q?SHhBRx7mqQSUi+9GYBGzxFzSpQpd/vPOBRuwOoJBX0dB+KySTcSlxvEYDsZJ?=
 =?us-ascii?Q?5iP7WsH1bqxujjcwyE5JblNwS+ncg3RU3SwFRxUz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f886360-2042-4126-e5d5-08db2a090666
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 12:37:25.5410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yRrKRO9Dgj0Wrq5Rz01molFf6WbnZtYqRSVJ1jdadljaaaYCDh+kZsRiO/o9mvn0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5011
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 02:02:59PM +0200, Leon Romanovsky wrote:
> On Tue, Mar 21, 2023 at 08:53:35AM -0300, Jason Gunthorpe wrote:
> > On Tue, Mar 21, 2023 at 09:54:58AM +0200, Leon Romanovsky wrote:
> > > On Mon, Mar 20, 2023 at 04:18:14PM -0300, Jason Gunthorpe wrote:
> > > > On Thu, Mar 16, 2023 at 03:39:27PM +0200, Leon Romanovsky wrote:
> > > > > From: Patrisious Haddad <phaddad@nvidia.com>
> > > > > 
> > > > > Previously when destroying a DCT, if the firmware function for the
> > > > > destruction failed, the common resource would have been destroyed
> > > > > either way, since it was destroyed before the firmware object.
> > > > > Which leads to kernel warning "refcount_t: underflow" which indicates
> > > > > possible use-after-free.
> > > > > Which is triggered when we try to destroy the common resource for the
> > > > > second time and execute refcount_dec_and_test(&common->refcount).
> > > > > 
> > > > > So, currently before destroying the common resource we check its
> > > > > refcount and continue with the destruction only if it isn't zero.
> > > > 
> > > > This seems super sketchy
> > > > 
> > > > If the destruction fails why not set the refcount back to 1?
> > > 
> > > Because destruction will fail in destroy_rq_tracked() which is after
> > > destroy_resource_common().
> > > 
> > > In first destruction attempt, we delete qp from radix tree and wait for all
> > > reference to drop. In order do not undo all this logic (setting 1 alone is
> > > not enough), it is much safer simply skip destroy_resource_common() in reentry
> > > case.
> > 
> > This is the bug I pointed a long time ago, it is ordered wrong to
> > remove restrack before destruction is assured
> 
> It is not restrack, but internal to mlx5_core structure.
> 
>   176 static void destroy_resource_common(struct mlx5_ib_dev *dev,
>   177                                     struct mlx5_core_qp *qp)
>   178 {
>   179         struct mlx5_qp_table *table = &dev->qp_table;
>   180         unsigned long flags;
>   181
> 
> ....
> 
>   185         spin_lock_irqsave(&table->lock, flags);
>   186         radix_tree_delete(&table->tree,
>   187                           qp->qpn | (qp->common.res << MLX5_USER_INDEX_LEN));
>   188         spin_unlock_irqrestore(&table->lock, flags);
>   189         mlx5_core_put_rsc((struct mlx5_core_rsc_common *)qp);
>   190         wait_for_completion(&qp->common.free);
>   191 }

Same basic issue.

"RSC"'s refcount stuff is really only for ODP to use, and the silly
pseudo locking should really just be rwsem not a refcount.

Get DCT out of that particular mess and the scheme is quite simple and
doesn't nee hacky stuff.

Please make a patch to remove radix tree from this code too...

diff --git a/drivers/infiniband/hw/mlx5/qpc.c b/drivers/infiniband/hw/mlx5/qpc.c
index bae0334d6e7f18..68009bff4bd544 100644
--- a/drivers/infiniband/hw/mlx5/qpc.c
+++ b/drivers/infiniband/hw/mlx5/qpc.c
@@ -88,23 +88,34 @@ static bool is_event_type_allowed(int rsc_type, int event_type)
 	}
 }
 
+static int dct_event_notifier(struct mlx5_ib_dev *dev, struct mlx5_eqe *eqe)
+{
+	struct mlx5_core_dct *dct;
+	u32 qpn;
+
+	qpn = be32_to_cpu(eqe->data.dct.dctn) & 0xffffff;
+	xa_lock(&dev->qp_table.dct_xa);
+	dct = xa_load(&dev->qp_table.dct_xa, qpn);
+	if (dct)
+		complete(&dct->drained);
+	xa_unlock(&dev->qp_table.dct_xa);
+	return NOTIFY_OK;
+}
+
 static int rsc_event_notifier(struct notifier_block *nb,
 			      unsigned long type, void *data)
 {
+	struct mlx5_ib_dev *dev =
+		container_of(nb, struct mlx5_ib_dev, qp_table.nb);
 	struct mlx5_core_rsc_common *common;
-	struct mlx5_qp_table *table;
-	struct mlx5_core_dct *dct;
+	struct mlx5_eqe *eqe = data;
 	u8 event_type = (u8)type;
 	struct mlx5_core_qp *qp;
-	struct mlx5_eqe *eqe;
 	u32 rsn;
 
 	switch (event_type) {
 	case MLX5_EVENT_TYPE_DCT_DRAINED:
-		eqe = data;
-		rsn = be32_to_cpu(eqe->data.dct.dctn) & 0xffffff;
-		rsn |= (MLX5_RES_DCT << MLX5_USER_INDEX_LEN);
-		break;
+		return dct_event_notifier(dev, eqe);
 	case MLX5_EVENT_TYPE_PATH_MIG:
 	case MLX5_EVENT_TYPE_COMM_EST:
 	case MLX5_EVENT_TYPE_SQ_DRAINED:
@@ -113,7 +124,6 @@ static int rsc_event_notifier(struct notifier_block *nb,
 	case MLX5_EVENT_TYPE_PATH_MIG_FAILED:
 	case MLX5_EVENT_TYPE_WQ_INVAL_REQ_ERROR:
 	case MLX5_EVENT_TYPE_WQ_ACCESS_ERROR:
-		eqe = data;
 		rsn = be32_to_cpu(eqe->data.qp_srq.qp_srq_n) & 0xffffff;
 		rsn |= (eqe->data.qp_srq.type << MLX5_USER_INDEX_LEN);
 		break;
@@ -121,8 +131,7 @@ static int rsc_event_notifier(struct notifier_block *nb,
 		return NOTIFY_DONE;
 	}
 
-	table = container_of(nb, struct mlx5_qp_table, nb);
-	common = mlx5_get_rsc(table, rsn);
+	common = mlx5_get_rsc(&dev->qp_table, rsn);
 	if (!common)
 		return NOTIFY_OK;
 
@@ -137,11 +146,6 @@ static int rsc_event_notifier(struct notifier_block *nb,
 		qp->event(qp, event_type);
 		/* Need to put resource in event handler */
 		return NOTIFY_OK;
-	case MLX5_RES_DCT:
-		dct = (struct mlx5_core_dct *)common;
-		if (event_type == MLX5_EVENT_TYPE_DCT_DRAINED)
-			complete(&dct->drained);
-		break;
 	default:
 		break;
 	}
@@ -188,7 +192,7 @@ static void destroy_resource_common(struct mlx5_ib_dev *dev,
 }
 
 static int _mlx5_core_destroy_dct(struct mlx5_ib_dev *dev,
-				  struct mlx5_core_dct *dct, bool need_cleanup)
+				  struct mlx5_core_dct *dct)
 {
 	u32 in[MLX5_ST_SZ_DW(destroy_dct_in)] = {};
 	struct mlx5_core_qp *qp = &dct->mqp;
@@ -203,13 +207,14 @@ static int _mlx5_core_destroy_dct(struct mlx5_ib_dev *dev,
 	}
 	wait_for_completion(&dct->drained);
 destroy:
-	if (need_cleanup)
-		destroy_resource_common(dev, &dct->mqp);
 	MLX5_SET(destroy_dct_in, in, opcode, MLX5_CMD_OP_DESTROY_DCT);
 	MLX5_SET(destroy_dct_in, in, dctn, qp->qpn);
 	MLX5_SET(destroy_dct_in, in, uid, qp->uid);
 	err = mlx5_cmd_exec_in(dev->mdev, destroy_dct, in);
-	return err;
+	if (err)
+		return err;
+	xa_cmpxchg(&dev->qp_table.dct_xa, dct->mqp.qpn, dct, NULL, GFP_KERNEL);
+	return 0;
 }
 
 int mlx5_core_create_dct(struct mlx5_ib_dev *dev, struct mlx5_core_dct *dct,
@@ -227,13 +232,13 @@ int mlx5_core_create_dct(struct mlx5_ib_dev *dev, struct mlx5_core_dct *dct,
 
 	qp->qpn = MLX5_GET(create_dct_out, out, dctn);
 	qp->uid = MLX5_GET(create_dct_in, in, uid);
-	err = create_resource_common(dev, qp, MLX5_RES_DCT);
+	err = xa_err(xa_store(&dev->qp_table.dct_xa, qp->qpn, dct, GFP_KERNEL));
 	if (err)
 		goto err_cmd;
 
 	return 0;
 err_cmd:
-	_mlx5_core_destroy_dct(dev, dct, false);
+	_mlx5_core_destroy_dct(dev, dct);
 	return err;
 }
 
@@ -284,7 +289,7 @@ static int mlx5_core_drain_dct(struct mlx5_ib_dev *dev,
 int mlx5_core_destroy_dct(struct mlx5_ib_dev *dev,
 			  struct mlx5_core_dct *dct)
 {
-	return _mlx5_core_destroy_dct(dev, dct, true);
+	return _mlx5_core_destroy_dct(dev, dct);
 }
 
 int mlx5_core_destroy_qp(struct mlx5_ib_dev *dev, struct mlx5_core_qp *qp)
@@ -488,6 +493,7 @@ int mlx5_init_qp_table(struct mlx5_ib_dev *dev)
 
 	spin_lock_init(&table->lock);
 	INIT_RADIX_TREE(&table->tree, GFP_ATOMIC);
+	xa_init(&table->dct_xa);
 	mlx5_qp_debugfs_init(dev->mdev);
 
 	table->nb.notifier_call = rsc_event_notifier;
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index f33389b42209e4..87e19e6d07a94a 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -381,7 +381,6 @@ enum mlx5_res_type {
 	MLX5_RES_SRQ	= 3,
 	MLX5_RES_XSRQ	= 4,
 	MLX5_RES_XRQ	= 5,
-	MLX5_RES_DCT	= MLX5_EVENT_QUEUE_TYPE_DCT,
 };
 
 struct mlx5_core_rsc_common {
@@ -443,6 +442,7 @@ struct mlx5_core_health {
 
 struct mlx5_qp_table {
 	struct notifier_block   nb;
+	struct xarray dct_xa;
 
 	/* protect radix tree
 	 */
