Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39EB65573C7
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 09:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbiFWHTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 03:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbiFWHTn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 03:19:43 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2062.outbound.protection.outlook.com [40.107.243.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD8A045AFE
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 00:19:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k+jSvu1xnmSGt3uso4vSd617wNhWNPii/pV8sbIspksiVxdLvq3RgJUBfSmzUJAXnzjgCis99Tyt5BTgWLTzttjV+Z+iptORVQ67Ky80vSsaUUwHYmjE7QHEjUPoDyVr6Nyw/TOmot4dbSfPAYcjlMrb4532M2IkK6Phg2GZd3Mh9h1sLRRdyrJkR85/y4Dgr5pt4jed//9U1f+nbBijpkfnXbmsTONItLrp2FIRDeqdeKbz1z/N6ijJ9qZYCoz+slipq3gpYcasjhDaIT61PpoEnN/U7Hy55YUAUticZoqSoAtFprKWSm8ZP+rtLY3iC9oQFGp5w0WLm0erPPxwRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Va5xqvSvJ8n5xyEYr2XZHYADbAkrDs5iW97FAUoxwCs=;
 b=h7vpxu5NJvn4Tt4XUWp0Q3zMc8muH6kjWxIKp21vOfuI1oRsw38wXQxobTTOIrcjBpuIfGh0z+S77715+iU1y/w5RL5zbet23vgcQDpf5Cwk//5Hr6lrxtiSkZZMdwr/p5CZhc3aRJo4562MXzuosvyBQQsndEYDfJQG7OXYiSIiAYKcizcba0X68gcPBO48hpsMixfARts/WEwQlSSNEooXO8ifk74FsGSPDBf8jdlmoRXAST5MLoMNls3ZK15tJu29AwbRkMA2/pEotUuq7S0kYNEdvn+rJGhAcCD45Ch20lwDeqoYm/Ncb/97/US7MdUDZEYkF/yy/ReWnKZq1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Va5xqvSvJ8n5xyEYr2XZHYADbAkrDs5iW97FAUoxwCs=;
 b=WGSoUtOd3lwhG0ZJVPGzZMZzIwKDXVTRd81TAgnnKsRcLM8Brz/t2JGfLwnRxVNoNdeGlfi56ZSRSsJXtvmtx+izIDI2yADBcuJNw+igo7UbuAr39mK2/IydIs4SCeshCCvffwIUkUdVioUgxDRhYn1EWzsbzPism6D13wHQu/7r5hrRu4pChncRxqub7WwlFIRY2iKWyEil9RCBHc3xsCGuhmnk+AHNjeaaPgb6nvAi2KpnTbKzZYIg1CzHwgBkr0RRsqCIJ20AUWNVOugkshbJ9Quhc8rST0Sf10VIVpbZItNMbOL8gsqKvOnE907eqxIfN0mnwvFgOSEwlC91Tw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB6163.namprd12.prod.outlook.com (2603:10b6:208:3e9::22)
 by DM5PR12MB2518.namprd12.prod.outlook.com (2603:10b6:4:b0::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.20; Thu, 23 Jun
 2022 07:19:39 +0000
Received: from IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::6da4:ce53:39ae:8dbf]) by IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::6da4:ce53:39ae:8dbf%7]) with mapi id 15.20.5353.018; Thu, 23 Jun 2022
 07:19:39 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 4/8] mlxsw: spectrum_fid: Pass FID structure to mlxsw_sp_fid_op()
Date:   Thu, 23 Jun 2022 10:17:33 +0300
Message-Id: <20220623071737.318238-5-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623071737.318238-1-idosch@nvidia.com>
References: <20220623071737.318238-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR02CA0076.eurprd02.prod.outlook.com
 (2603:10a6:802:14::47) To IA1PR12MB6163.namprd12.prod.outlook.com
 (2603:10b6:208:3e9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5307342-5dac-4168-2194-08da54e8bbfc
X-MS-TrafficTypeDiagnostic: DM5PR12MB2518:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB2518FE036017AAA6A92660ACB2B59@DM5PR12MB2518.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: il3GOKt67NF0FQwGZj84EyBcATTLdFIZy1JRGhFuj+qUcwkouD6a8ic9pzrVdFkcIAQk3de+SFpko0Mtdys+dbE6di/g6YhwmeGzUEKjeGu87NO5jTBPiM+xRNP5BTCjQf2ajpzzbQAozJGnlUDgK/orktyJQA60Fjif3AcYcNdud7RxIZ6YKkPwrwvy2vrPPDkyKBPWFePxTm2PVyEyO+7xH+CUtHhY2SgtgpiXJrH4JSBTaEC+xtpCbrj6JtRmKgZ3AonyF8++yccTq5Yekg4xBJE1I8rpeAAosBwG+IPLaeIRTj2j9FkhS9lXCfEV6mqOM61K1lrJfBHCtMwsQGs6158fMf0FTkMZNysGm5ifuXmGkQDKK6QkWVzJrTXCSe8PjV9AjCm9mxvZEeUtN8RFGVcqXwQSvsFFMiSEhxKAGmpoRDYc++BsSkmpmsntwkn2MrlaoD48DB3C8v9GtTueAiD5UM80naiKQCy5pWZqZEynO9CF027rlLP1x6J1bM+nqiFBL/XxmmmEh1qE81nlu/OdkH2rtIS+enA5Ap7BcIyMi/fVnSTAmPX1FIK4JH3bg/p13Tyvuznpr0knxwFO3Fd3ygqaIJ6StncXH2Yknq/zh9LuyIV3/FOir+1CNE6l0vB788Oq6zLb3ZFa0aGlQAi5k29UrDLJeHJFyHmgnHbLXdMzHJL9sOmL4LYP/MGNr/2cZv7dzHaecaAQAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(346002)(376002)(366004)(136003)(4326008)(8936002)(66476007)(8676002)(86362001)(1076003)(6666004)(6506007)(66556008)(6512007)(66946007)(107886003)(186003)(6916009)(83380400001)(2616005)(5660300002)(36756003)(41300700001)(38100700002)(26005)(316002)(6486002)(478600001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?obEd16pZ+nKh5cPcD/INW8501fcUey+HM0xLDxzGiWvTlz3M/akyK6vg/ozm?=
 =?us-ascii?Q?TFnNIm9DitR/lG4uaAsjA17YfFhOpImh+kUm72F7eP5qEhD5z00awvSC7Kc9?=
 =?us-ascii?Q?oYSsJE3HfYEiYRxPC8wRN0VQFnFimHAMeSAf1lNxUzaYHe2FjqwAQYDyXCNJ?=
 =?us-ascii?Q?FlQMAn2nfq2WCPEih/WcWhlA8FpFk18Ov/6AA0PPyQyObbOyRVHrmxWbSiH/?=
 =?us-ascii?Q?3Ytk0Basn8SC4sJHZc5TJJl36Jp/QU5t6ituKdrCctf9nMvdCbKZ9ltWduVS?=
 =?us-ascii?Q?8+tVJriAj03Ks1NLX1yteq2WF5VT9Oc5NJRjEe6mwtC6KTJj31fVR7ijVzF8?=
 =?us-ascii?Q?2x8/AIINuSnBWupt/p0M9H3zXIBp+xOKR6jnbnC2WUoLKX1f9XdEeOSV5rAI?=
 =?us-ascii?Q?9Diq2FGwICTgxw6VHU888KvKe91+QdUd6ACbjVMpehu7TVNZHpj6PyAQvgdO?=
 =?us-ascii?Q?TPGCt4F5QGiC2j/biiJOIurMCzOO1T/vz/WKhxBg97oukrR/EDkB8zffVvJA?=
 =?us-ascii?Q?A7q0DWsRXOmN/ifHJzQpj5RyIvQEVB4KY4mibtCGXfGVTE1dkqZ0V2/KIQbq?=
 =?us-ascii?Q?jstVotSo5aHWSqHb0HwlNmEpXqLzt2xXiNyYPExAGUqj0h6M9u2sAy/rfPeC?=
 =?us-ascii?Q?3C0/VUK7c9ukGry9aq4YsTZgNQ9Dyv0v98d2BBLHcz6T7WSpn9I2P6a3cV8c?=
 =?us-ascii?Q?9VWxjk1ql+1WH5QDddy8SNNrweA0VLsEhQ9NLX0PZ1ypqPgZkXLhNj1Hb8Hl?=
 =?us-ascii?Q?mhU0V6Z3fTErIuyoVKO4BDGB3f66qQ8APtbFbvFbD89wj/CY/R+ZCK4LUA3r?=
 =?us-ascii?Q?QVLCNP8NnieW9ci7X/eAj3R+pgyj4bXEiCS7TwOLbQeE6Bdomfi2cmYqOz3u?=
 =?us-ascii?Q?8VqhUJ18HSnOnz5nJuN7FeE6heuihamS1oewyBUR4Fi3heZbFE0In92R6dia?=
 =?us-ascii?Q?8YwvJ0r0GLki0a2m4NYDj3QffJfEb8WOeFLpTZbPF9HAcYfxSaTlOHpNsjIK?=
 =?us-ascii?Q?a2sRoXlM0TfLP7BA1cIjXBGr9S7VmZ+tis/aVvHPDg8uDi4gVc/TIWTQL2FA?=
 =?us-ascii?Q?uwLc9iCOzvYnhDeirkPomHXuY/DOkpY55Uo762rjE5o298THmHjdsppgoiuA?=
 =?us-ascii?Q?U3zZI5mXeLJPsedTONY7NlabliDiSoVEWANMWvOvKvJA8SZMr2ND62wWUmWu?=
 =?us-ascii?Q?yirrMxfuBE3y/4SogoXX18QMd9vqBTsnwvkg0coOOvXvU3K7UF+W9AJZRCRA?=
 =?us-ascii?Q?sIvpvYwUsSLq+B/mGADFEOcke2XWhHBQGp18Gt6Wu9L8zUNA028wQJDPVJcj?=
 =?us-ascii?Q?K1Ud30/RuX7TaULW6/+50fqyhr9wVKD9u0jRnvxfEPDU2i+zSnkQmEFkHcby?=
 =?us-ascii?Q?91GK3FNUHVD67vH35T0TtKZyDZFKbCuD6kA6EISPPaHQtpwZx0YKPcIjNwT9?=
 =?us-ascii?Q?Lu4en97ODMHtjCURCXEKEwPLWCJK7IZ6MeDhUqKMGxMfb+jMYHedNOj2MDhf?=
 =?us-ascii?Q?s+K2yj0K70MgpsbhfEdD/qogwoKKEsYkw1h2UPbDQ/eFrYtjOONTOBxWfBos?=
 =?us-ascii?Q?6aDzMpvKh8qVpoJBm1wyZV5et/yugm2pwXNejUth11RGdiXJa1R/aWclxtHr?=
 =?us-ascii?Q?vRtnDvzL6NQsx5ilhsqOCI73bnvh5MUN/ZoOEJgVDZLMusorIEC9Dn4IjAvT?=
 =?us-ascii?Q?76xa6M2vSBlYEoFduCacvGtgtsc49Zkx1hX1bRHbewauAhS6o6Fsdg0pPwUr?=
 =?us-ascii?Q?I2o+V3cQJA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5307342-5dac-4168-2194-08da54e8bbfc
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6163.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 07:19:39.1398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CdylzB77ddJe2xhEOydlALFBjI/CKjkjy3jPzHdBFUkwp1xpUC7msRbSg0cMPe6VYrJMRGt8TTqsIfqnLbgQxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2518
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

The function gets several arguments derived from the FID structure
itself. In the future, it will need to be extended to configure
additional FID attributes.

Prepare for that change and reduce the arguments list by passing the FID
structure itself.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_fid.c    | 23 +++++++------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
index f642c25a0219..e356b4d2193d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
@@ -418,13 +418,13 @@ static enum mlxsw_reg_sfmr_op mlxsw_sp_sfmr_op(bool valid)
 		       MLXSW_REG_SFMR_OP_DESTROY_FID;
 }
 
-static int mlxsw_sp_fid_op(struct mlxsw_sp *mlxsw_sp, u16 fid_index,
-			   u16 fid_offset, bool valid)
+static int mlxsw_sp_fid_op(const struct mlxsw_sp_fid *fid, bool valid)
 {
+	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
 	char sfmr_pl[MLXSW_REG_SFMR_LEN];
 
-	mlxsw_reg_sfmr_pack(sfmr_pl, mlxsw_sp_sfmr_op(valid), fid_index,
-			    fid_offset);
+	mlxsw_reg_sfmr_pack(sfmr_pl, mlxsw_sp_sfmr_op(valid), fid->fid_index,
+			    fid->fid_offset);
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(sfmr), sfmr_pl);
 }
 
@@ -468,18 +468,14 @@ static void mlxsw_sp_fid_8021d_setup(struct mlxsw_sp_fid *fid, const void *arg)
 
 static int mlxsw_sp_fid_8021d_configure(struct mlxsw_sp_fid *fid)
 {
-	struct mlxsw_sp_fid_family *fid_family = fid->fid_family;
-
-	return mlxsw_sp_fid_op(fid_family->mlxsw_sp, fid->fid_index,
-			       fid->fid_offset, true);
+	return mlxsw_sp_fid_op(fid, true);
 }
 
 static void mlxsw_sp_fid_8021d_deconfigure(struct mlxsw_sp_fid *fid)
 {
 	if (fid->vni_valid)
 		mlxsw_sp_nve_fid_disable(fid->fid_family->mlxsw_sp, fid);
-	mlxsw_sp_fid_op(fid->fid_family->mlxsw_sp, fid->fid_index,
-			fid->fid_offset, false);
+	mlxsw_sp_fid_op(fid, false);
 }
 
 static int mlxsw_sp_fid_8021d_index_alloc(struct mlxsw_sp_fid *fid,
@@ -916,15 +912,12 @@ static void mlxsw_sp_fid_dummy_setup(struct mlxsw_sp_fid *fid, const void *arg)
 
 static int mlxsw_sp_fid_dummy_configure(struct mlxsw_sp_fid *fid)
 {
-	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
-
-	return mlxsw_sp_fid_op(mlxsw_sp, fid->fid_index, fid->fid_offset, true);
+	return mlxsw_sp_fid_op(fid, true);
 }
 
 static void mlxsw_sp_fid_dummy_deconfigure(struct mlxsw_sp_fid *fid)
 {
-	mlxsw_sp_fid_op(fid->fid_family->mlxsw_sp, fid->fid_index,
-			fid->fid_offset, false);
+	mlxsw_sp_fid_op(fid, false);
 }
 
 static int mlxsw_sp_fid_dummy_index_alloc(struct mlxsw_sp_fid *fid,
-- 
2.36.1

