Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B16AD50C452
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 01:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234182AbiDVXBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 19:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233664AbiDVXBe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 19:01:34 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2059.outbound.protection.outlook.com [40.107.223.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 695011A4335
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 15:25:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=daQYyLuQJHCswqQL/6n3iqdpnaIKLNL6yN/Bz+F1296ukk0uvVf1VD3Rhbus54cXaura2t/IC6yK/XriY3LzwLW9vX+ySKzZ/ZmeuOx9ENFT61PXF/Iig7GAqqTOTZC7zgWE80Csm4u5clf91DdhKHPGIm9uHBsZlybvQSlXsmX49UxQWvUuDwa1dmcGvDktp2pvVhdvO5WkhHTzkH2/AD1ZOHk0qhGhBodPqUkY2vmCMXGPuh5oKmc/Y1s4WckE518k8+z4sNBlPpKjlPqbXAi+UPQjFRHGNVOUGrw390Gff3/obi69keTgVNl54kwbWOAP7peTxF4Jw/dYL+BqXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ol8UEFzBVAZy8I+c01Ao0HXJOlgdM/vI5ajvERiAIN0=;
 b=Dm861B+a/x7u555OMNlEWqTcsqWzwq37aCXWYpLd68MmXleV5RtnXNYj4G1u4PiYs41pRJBpsXVagqRsg0XFqFgcv8P1NNNJbMW6QxvgGPyYl2bWJispMIFsobeQKXqPHvQfQDr3fqZ4PYOqiuT6qT5wOi0vht+tXLvlEuBUZzXNXcxhqPDEAXOLspMRNzvg+hTthVqUDr4DUrMLitOD/IdiKXV+HVGEFqlZVDWDcp8JfNioFD3Ey+SKjI3Whhf5XLUt+F4Xwc7wzv9gisP6OzBqRUGmRnv+4ivea4MwlMbY8LqyjDd/2/sSrmGGPBiXKoeRoo7KE9EVdciNdcIg/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ol8UEFzBVAZy8I+c01Ao0HXJOlgdM/vI5ajvERiAIN0=;
 b=VBbjagcHG2DORfR3Ig7bWHAqphhNGbvrsWHPd3T9KqOcMmM8PyTn0C+9X0BaLDpleWDRq+HZk/9rLQcD5/YUXME+jMyCga4/J0GJ5tZvyF0lBCXvLpVaJ6hRgVHac8MQjTwvUoRNfCsUg8rh/db+ih94wPa7EZe4ds8fS0AxlYH2B5kKwzdULTMVfT0ChLqSi9tyOiIjidoKi4U7Vyq9fl6+1aoefA7ff0B8vzxZeUIf7QfDgPKx6l8ifyKiXkjTErMVQkHhyd1YlWGTRYD0lEhQr8hNSZHeRW2WkVLGRE5DhC+j2+OoRVL4dOGGt1zlSv7y/XNyCUquDDm1DqYH2g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4220.namprd12.prod.outlook.com (2603:10b6:5:21d::7) by
 CY4PR12MB1173.namprd12.prod.outlook.com (2603:10b6:903:41::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5164.20; Fri, 22 Apr 2022 22:25:39 +0000
Received: from DM6PR12MB4220.namprd12.prod.outlook.com
 ([fe80::d585:d44d:54d6:a137]) by DM6PR12MB4220.namprd12.prod.outlook.com
 ([fe80::d585:d44d:54d6:a137%3]) with mapi id 15.20.5186.015; Fri, 22 Apr 2022
 22:25:39 +0000
Date:   Fri, 22 Apr 2022 15:25:36 -0700
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>
Subject: Re: [PATCH net-next v1 10/17] net/mlx5: Clean IPsec FS add/delete
 rules
Message-ID: <20220422222536.uxyyveytmmkwvwjv@sx1>
References: <cover.1650363043.git.leonro@nvidia.com>
 <874f16edb960923bb25c83382d96cd4cb3732485.1650363043.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <874f16edb960923bb25c83382d96cd4cb3732485.1650363043.git.leonro@nvidia.com>
X-ClientProxiedBy: SJ0PR13CA0131.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::16) To DM6PR12MB4220.namprd12.prod.outlook.com
 (2603:10b6:5:21d::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 00342f96-bcfb-4342-c79c-08da24af070c
X-MS-TrafficTypeDiagnostic: CY4PR12MB1173:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB11737665F18F599B5F19EC5CB3F79@CY4PR12MB1173.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hkn1LEl+PLilKMeEXADTx9QXSSOVyNzYNIRoZaK44Nx+7D0codTmFMP89jQwT0oncK7b8Q7AD5MV7hMTdLBi15mQcyTDZCNBSf9nQLj0CMEO9QJXZMj9zoZJfqi4Kfm3LrKQX9c7aLWFa0kh8cAHb3oCIAsjIgi10Q4EYhfmgrXybYF/OJdCLEkjfsRCL3OhBHJCV25vvWxhhtiNTBJ7rlOiOeGIuAp/eRV+n22p+g/s5gP9hWCLYM02LS6wX7k5qXeXLHmYsNVFgs3i8dBqBBBfFepHXzHMHmFCQZsnIk6NpX28khZ54DcOu7ZFQq3FGg+nkNUIJFgTDMwFMjnikjXkaTsnSG/389lh7HqIwOsD2+tvmYY9lHIgmpWhx0nRasCDmhBqjBdmF9OYSI4Q7rjKvcHEXG90qsjT9Q7jQUDOy+ycnnkiRBSSfQazDi2A9/CKDCSI/cNNHEnYcFoPOygLteyWso/MUj0DBmI0T05F7C2k6wt/YQ0LM5wxsDBAguKE/h8FXfjQ7QWCZGcoEQ3QfTZuzCc/7btxUTwJQp2PIozSyTLcLEJH1bew9OicZsX4zElRoVG+EIcnkTOPg+C/ED5yHg7W6l/b1PiXjl0Mr3D0pANGOO02CP7YuUsTvpAtpp5k9r9aZ7vrcEdjWA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4220.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(3716004)(5660300002)(186003)(6512007)(6486002)(66556008)(66476007)(8676002)(4326008)(33716001)(83380400001)(6916009)(316002)(54906003)(38100700002)(66946007)(9686003)(107886003)(508600001)(2906002)(86362001)(6666004)(8936002)(6506007)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JsTsEq7QR2rk69fmI1kg2NsKZaYMppRqpheJhsa/zShlqvPlniIWMaBcpruJ?=
 =?us-ascii?Q?vJMTaEmNYv9WwyzcZUyJOHl12hmtEPDgyJ3aahYFT9H3arkTb99lg5KTZxjV?=
 =?us-ascii?Q?AAOj/MFiSoJJhv2EX3nDkgmcpPAdfGXp6bSo5g6YTLlp3Fw6qLHjeEiCcU4K?=
 =?us-ascii?Q?X9jeYP5nqGRN9GiNG1lRTToKjfTpGbpxbmuHKjAAFaKeNaKcE9HS0RpWdi6g?=
 =?us-ascii?Q?T0W/jkY1wRWKp9Mxhgu+O9dZECZoVM0KEKQnX5XhXoOxYBCkKY6ffzrQA+r3?=
 =?us-ascii?Q?Ngr07sgjF1UKfOWwFLVJDqH40UiwVISdWPaYG0r0lYCNrepIzMQHB6Wk1UJF?=
 =?us-ascii?Q?DnFcfzZB9uzG24EgoTQEzdJ9hwTy/0jfaVSvoSUYamUNiaK7dclDX6kMTGI5?=
 =?us-ascii?Q?ST788R99ULUFKE3jk06Bsnm7DdxdwSz/GhDz7WgsMGCaX1y3LDuSdMUWyrKl?=
 =?us-ascii?Q?tugee/LM9QfI38GEfD3YNyMcQZm4Xzmv4HK+9O1KtOM4DBeAihsRToGQ5yjV?=
 =?us-ascii?Q?NHS5o5kwUw3zRxyEnl5ItUozOqmkf5ebBQuQX+0VSmdzo9jpfHnM501x++Oi?=
 =?us-ascii?Q?2OJfy7ORttkWZoj+2bMQCqgEz+rpky+a/P+lWK8J7v34acojpVF6QkqLUO4d?=
 =?us-ascii?Q?LsLb1VGcMCtluCeC7wahDC6gHUwcPbKLEQ0txhaExiJ2TAFSHjX3ls0TWma0?=
 =?us-ascii?Q?y9qOWfxy+0Y8JKK+fUWLaE+zzE6S2Ott5R8P1wrs+015IN0MVU3wlWlgm/kZ?=
 =?us-ascii?Q?0TIBtrCa9YhEA76pkBJPZUdpoP/YpT5UeVij8vxjU4Q38M4S6FgJcfWEiK8+?=
 =?us-ascii?Q?zmnl1ZoRtVjZxRDJUPWHCiOYxlYGThFNRGuh2SoSJrav1C/3nTswdIr2PD4E?=
 =?us-ascii?Q?Fg31ygvj48lnxw5CKF82ID0Z5Nh8J3aPXDS0SqIEh4TMYw19kSxOeTsboHvr?=
 =?us-ascii?Q?uxn9xlRRk2Y3ykakWfwAcgqoIhC8nfQ++mNVqgv2x3q/Dsger0bu88HuKpCV?=
 =?us-ascii?Q?CL9a1cD1Q8Mk9MGsoCLD52usmjBvw0nqf+Z5F6a5qcOyPitdKiOLWoS+8QAc?=
 =?us-ascii?Q?Sg4gvffVEq7WqVPgmyljzLlNHKRUqb4q+9Xf25kYSpF8gqBq6NHUriIwpls3?=
 =?us-ascii?Q?yw0wVB5vdTuDjeXpin1Cpqt5YHTazCZpxKOUut0Iac/qifh4PRUOAfIdx4Mf?=
 =?us-ascii?Q?ND8zpLC7ZofAoJniP7CKfFQ8RMTzlNLM5+fegO2s1xnqBG97M4V5zmDNGm3o?=
 =?us-ascii?Q?N1BfgYvl+GRKegk+PWWsyrzANb1R/j+81VmLOcJhfT3UcTyVhB75VO0xCBeE?=
 =?us-ascii?Q?m+rOW4YLjo0g9DZd3bf1Gw1UdHOEZMbMhXTfr/6PqY2Dx3dYrwbsiOt2o8i+?=
 =?us-ascii?Q?NjQlDHY3rm+rMfPIuITb6ytiVPJpc9Hhmm5ejMtCALmhgcTGkK0NZ4f0SDGM?=
 =?us-ascii?Q?RNUQY2nSYeUyKQyvrSjh1m/hQ6NLeHCcZ1eFEqxma1FL9lCTimKfCD++oSmU?=
 =?us-ascii?Q?fuhtYfpsunJZhOeQ1KUxZWswTrN7wG+ohC134FUq1G6RvcGtWPasr+ETea3+?=
 =?us-ascii?Q?P68CfP0XFBOMfkftFhABXjMBkrDauUk1OuIEN6VKcglWyoe1DYFjr9VHk+GZ?=
 =?us-ascii?Q?u46rvBQM1JJMMp8U9bJkXuGCSVGIth3NIVEstJeq+XwRNAnsbCY5YvJ4ByW+?=
 =?us-ascii?Q?V9nUSAOecUnCWkjBDhU2Q/c3ANw376cqooP5Vkc2lePez/EXz86dR7KgmlSz?=
 =?us-ascii?Q?ueKB4JpHzvf5aChRWrNzs8t3MeUP3oA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00342f96-bcfb-4342-c79c-08da24af070c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4220.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 22:25:38.9544
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4lK0MPj0oQdoNC58w6epO1HpvLOgUz0wXmEmWoV5rux6a0ztkjK8xsLSQu4BQIkKng5gOE8GK9nTNhSxQrIaVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1173
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19 Apr 13:13, Leon Romanovsky wrote:
>From: Leon Romanovsky <leonro@nvidia.com>
>
>Reuse existing struct to pass parameters instead of open code them.
>

Why? what do you mean "open code them" ? they are not open coded, they are
primitive for a reason ! If we go with this reasoning, then let's pass
mlx5e_priv to all functions and just forget about modularity.

>Reviewed-by: Raed Salem <raeds@nvidia.com>
>Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
>---
> .../mellanox/mlx5/core/en_accel/ipsec.c       | 10 +---
> .../mellanox/mlx5/core/en_accel/ipsec.h       |  7 +--
> .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 55 ++++++++++---------
> 3 files changed, 34 insertions(+), 38 deletions(-)
>
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
>index 537311a74bfb..81c9831ad286 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
>@@ -313,9 +313,7 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x)
> 	if (err)
> 		goto err_xfrm;
>
>-	err = mlx5e_accel_ipsec_fs_add_rule(priv, &sa_entry->attrs,
>-					    sa_entry->ipsec_obj_id,
>-					    &sa_entry->ipsec_rule);
>+	err = mlx5e_accel_ipsec_fs_add_rule(priv, sa_entry);

To add to my comment on the previous patch, in here the issue is more
severe as previously ipsec_fs.c was unaware of sa_entry object and used to
deal with pure fs related objects, you are peppering the code with sa_entry for
no reason, other than reducing function parameters from 4 to 2.
  
> 	if (err)
> 		goto err_hw_ctx;
>
>@@ -333,8 +331,7 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x)
> 	goto out;
>
> err_add_rule:
>-	mlx5e_accel_ipsec_fs_del_rule(priv, &sa_entry->attrs,
>-				      &sa_entry->ipsec_rule);
>+	mlx5e_accel_ipsec_fs_del_rule(priv, sa_entry);
> err_hw_ctx:
> 	mlx5_ipsec_free_sa_ctx(sa_entry);
> err_xfrm:
>@@ -357,8 +354,7 @@ static void mlx5e_xfrm_free_state(struct xfrm_state *x)
> 	struct mlx5e_priv *priv = netdev_priv(x->xso.dev);
>
> 	cancel_work_sync(&sa_entry->modify_work.work);
>-	mlx5e_accel_ipsec_fs_del_rule(priv, &sa_entry->attrs,
>-				      &sa_entry->ipsec_rule);
>+	mlx5e_accel_ipsec_fs_del_rule(priv, sa_entry);
> 	mlx5_ipsec_free_sa_ctx(sa_entry);
> 	kfree(sa_entry);
> }
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
>index cdcb95f90623..af1467cbb7c7 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
>@@ -176,12 +176,9 @@ struct xfrm_state *mlx5e_ipsec_sadb_rx_lookup(struct mlx5e_ipsec *dev,
> void mlx5e_accel_ipsec_fs_cleanup(struct mlx5e_ipsec *ipsec);
> int mlx5e_accel_ipsec_fs_init(struct mlx5e_ipsec *ipsec);
> int mlx5e_accel_ipsec_fs_add_rule(struct mlx5e_priv *priv,
>-				  struct mlx5_accel_esp_xfrm_attrs *attrs,
>-				  u32 ipsec_obj_id,
>-				  struct mlx5e_ipsec_rule *ipsec_rule);
>+				  struct mlx5e_ipsec_sa_entry *sa_entry);
> void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_priv *priv,
>-				   struct mlx5_accel_esp_xfrm_attrs *attrs,
>-				   struct mlx5e_ipsec_rule *ipsec_rule);
>+				   struct mlx5e_ipsec_sa_entry *sa_entry);
>
> int mlx5_ipsec_create_sa_ctx(struct mlx5e_ipsec_sa_entry *sa_entry);
> void mlx5_ipsec_free_sa_ctx(struct mlx5e_ipsec_sa_entry *sa_entry);
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
>index 96ab2e9d6f9a..342828351254 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
>@@ -454,11 +454,12 @@ static void setup_fte_common(struct mlx5_accel_esp_xfrm_attrs *attrs,
> }
>
> static int rx_add_rule(struct mlx5e_priv *priv,
>-		       struct mlx5_accel_esp_xfrm_attrs *attrs,
>-		       u32 ipsec_obj_id,
>-		       struct mlx5e_ipsec_rule *ipsec_rule)
>+		       struct mlx5e_ipsec_sa_entry *sa_entry)
> {
> 	u8 action[MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto)] = {};
>+	struct mlx5e_ipsec_rule *ipsec_rule = &sa_entry->ipsec_rule;
>+	struct mlx5_accel_esp_xfrm_attrs *attrs = &sa_entry->attrs;
>+	u32 ipsec_obj_id = sa_entry->ipsec_obj_id;
> 	struct mlx5_modify_hdr *modify_hdr = NULL;
> 	struct mlx5e_accel_fs_esp_prot *fs_prot;
> 	struct mlx5_flow_destination dest = {};
>@@ -532,9 +533,7 @@ static int rx_add_rule(struct mlx5e_priv *priv,
> }
>
> static int tx_add_rule(struct mlx5e_priv *priv,
>-		       struct mlx5_accel_esp_xfrm_attrs *attrs,
>-		       u32 ipsec_obj_id,
>-		       struct mlx5e_ipsec_rule *ipsec_rule)
>+		       struct mlx5e_ipsec_sa_entry *sa_entry)
> {
> 	struct mlx5_flow_act flow_act = {};
> 	struct mlx5_flow_handle *rule;
>@@ -551,7 +550,8 @@ static int tx_add_rule(struct mlx5e_priv *priv,
> 		goto out;
> 	}
>
>-	setup_fte_common(attrs, ipsec_obj_id, spec, &flow_act);
>+	setup_fte_common(&sa_entry->attrs, sa_entry->ipsec_obj_id, spec,
>+			 &flow_act);
>
> 	/* Add IPsec indicator in metadata_reg_a */
> 	spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS_2;
>@@ -566,11 +566,11 @@ static int tx_add_rule(struct mlx5e_priv *priv,
> 	if (IS_ERR(rule)) {
> 		err = PTR_ERR(rule);
> 		netdev_err(priv->netdev, "fail to add ipsec rule attrs->action=0x%x, err=%d\n",
>-				attrs->action, err);
>+				sa_entry->attrs.action, err);
> 		goto out;
> 	}
>
>-	ipsec_rule->rule = rule;
>+	sa_entry->ipsec_rule.rule = rule;
>
> out:
> 	kvfree(spec);
>@@ -580,21 +580,25 @@ static int tx_add_rule(struct mlx5e_priv *priv,
> }
>
> static void rx_del_rule(struct mlx5e_priv *priv,
>-		struct mlx5_accel_esp_xfrm_attrs *attrs,
>-		struct mlx5e_ipsec_rule *ipsec_rule)
>+			struct mlx5e_ipsec_sa_entry *sa_entry)
> {
>+	struct mlx5e_ipsec_rule *ipsec_rule = &sa_entry->ipsec_rule;
>+
> 	mlx5_del_flow_rules(ipsec_rule->rule);
> 	ipsec_rule->rule = NULL;
>
> 	mlx5_modify_header_dealloc(priv->mdev, ipsec_rule->set_modify_hdr);
> 	ipsec_rule->set_modify_hdr = NULL;
>
>-	rx_ft_put(priv, attrs->is_ipv6 ? ACCEL_FS_ESP6 : ACCEL_FS_ESP4);
>+	rx_ft_put(priv,
>+		  sa_entry->attrs.is_ipv6 ? ACCEL_FS_ESP6 : ACCEL_FS_ESP4);
> }
>
> static void tx_del_rule(struct mlx5e_priv *priv,
>-		struct mlx5e_ipsec_rule *ipsec_rule)
>+			struct mlx5e_ipsec_sa_entry *sa_entry)
> {
>+	struct mlx5e_ipsec_rule *ipsec_rule = &sa_entry->ipsec_rule;
>+
> 	mlx5_del_flow_rules(ipsec_rule->rule);
> 	ipsec_rule->rule = NULL;
>
>@@ -602,24 +606,23 @@ static void tx_del_rule(struct mlx5e_priv *priv,
> }
>
> int mlx5e_accel_ipsec_fs_add_rule(struct mlx5e_priv *priv,
>-				  struct mlx5_accel_esp_xfrm_attrs *attrs,
>-				  u32 ipsec_obj_id,
>-				  struct mlx5e_ipsec_rule *ipsec_rule)
>+				  struct mlx5e_ipsec_sa_entry *sa_entry)
> {
>-	if (attrs->action == MLX5_ACCEL_ESP_ACTION_DECRYPT)
>-		return rx_add_rule(priv, attrs, ipsec_obj_id, ipsec_rule);
>-	else
>-		return tx_add_rule(priv, attrs, ipsec_obj_id, ipsec_rule);
>+	if (sa_entry->attrs.action == MLX5_ACCEL_ESP_ACTION_ENCRYPT)
>+		return tx_add_rule(priv, sa_entry);
>+
>+	return rx_add_rule(priv, sa_entry);
> }
>
> void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_priv *priv,
>-		struct mlx5_accel_esp_xfrm_attrs *attrs,
>-		struct mlx5e_ipsec_rule *ipsec_rule)
>+				   struct mlx5e_ipsec_sa_entry *sa_entry)
> {
>-	if (attrs->action == MLX5_ACCEL_ESP_ACTION_DECRYPT)
>-		rx_del_rule(priv, attrs, ipsec_rule);
>-	else
>-		tx_del_rule(priv, ipsec_rule);
>+	if (sa_entry->attrs.action == MLX5_ACCEL_ESP_ACTION_ENCRYPT) {
>+		tx_del_rule(priv, sa_entry);
>+		return;
>+	}
>+
>+	rx_del_rule(priv, sa_entry);
> }
>
> void mlx5e_accel_ipsec_fs_cleanup(struct mlx5e_ipsec *ipsec)
>-- 
>2.35.1
>
