Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB0F55D5CA
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232649AbiF0HHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 03:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232605AbiF0HHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 03:07:32 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2054.outbound.protection.outlook.com [40.107.94.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 233F95F89
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 00:07:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H9a3p0P4BBdUx1O/92canef19ICFVdMAkkj9yQlbZTp5VNpBXc0jGBVDk3vxlw3bRl4VuM2lASJUJ86DXSlku63nTazAsHcKcgi7kK8gxIcSWpi9mHsZWy/sZSNBOF+vAECuFKB1dOsW8VKluu5Rq/D6albRxka/fhiXpxxgM/FhRRiopku+pzHm1bRfLZW3EIY3rnGatm38EYKp6Mngt+r7y4+OEmDmCeHrQQKyf+oTBSFUypqA5ODYGTlfG2AFH5hu89/3bvcR3Ji5T4eNnkn1ZjjeI+BW0v5qQIIlrE4p/8N8V39nu+mT3QyiMCz+1RgFjuSSzRo+AbA3sZoTMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NUQMX55mJbwoqzo0zvkpW/t5/fGayGr1F7Nl0FtIFAo=;
 b=f+BgYqHvzbnUuovnCt8oJ7TENA/Pmzv0qM7CX2Iw58VeT1/mcL0uCWP/oNpla4vhnUYcTl0RGdEszh9Q1PPOfidG72gswdrVoVoRuBs9HxyIFTYtuxJv8n58dfu203n3D4vsvpFntMjt4mmGEB/zS7A1EnrVyd+cenGctb/pbJuzJRFvRPkt/nBmXZGAM13oE87K/R6aMeQBhODGnvdGh5on2XdrzOYAOfYpOqz0CPXLWATWB0YQgYspCemPC7Zu+CktBk+4ChNKTQy1Rt5BMJs1UakwsuEE1Klfwp9hSuaKQ7rWhlCBVoRUgJa/fZxXngVgnFmgdmnfUG0p2wAxvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NUQMX55mJbwoqzo0zvkpW/t5/fGayGr1F7Nl0FtIFAo=;
 b=L+Z37z37qZqPNUV0TKux3Ekw9umtY7JV1xr3IkcGAoBSlN+pXGKkWDQ+aARHoe9mtBr0B0X2yV+EiDSXIBc/LyT6o88tTwS2dEFEgqmAAd2x9dvdnbYyixvwWbnI37DpKg2+d446NpAPb/cTScblXxWWm+cgFIhnshf276k4TrKjUOdjOHD/VrosQ8OoUy943vuVDwF9D6HfPArktTG+6z5TDkwzo87fO6oTa6hldkIWdFUxVBYZu7+xAJrWvEyt7UYOXdCohhr52jXjJNQP6JxUxmssCPiP3fAYzdwx/vg4U9UhUIIlqWab0O1Zv/ue2DKs1MksuQicl2ZH4mgSyQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SJ0PR12MB5439.namprd12.prod.outlook.com (2603:10b6:a03:3ae::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Mon, 27 Jun
 2022 07:07:28 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%5]) with mapi id 15.20.5373.018; Mon, 27 Jun 2022
 07:07:28 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 05/13] mlxsw: Set flood bridge type for FIDs
Date:   Mon, 27 Jun 2022 10:06:13 +0300
Message-Id: <20220627070621.648499-6-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627070621.648499-1-idosch@nvidia.com>
References: <20220627070621.648499-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0255.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:194::8) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: df37e876-1ddb-45c4-819f-08da580bb261
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5439:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uOgUlacOKwgKv3UfyVMQiRqzLIKWy0aG+3IYCgXF+y/03kFq2wPmEU7vI1v1FmAzeVu3hvKOcJrbddq/R7VFL1dtHOTk09fX6kT3o9C11F/xVFKWjGeIig0AKGQ5SPoB6r69cyre1nGVMsvnR1zpuz4YVPoFj4upAgykZgreFC1yamR8zuFIZFZ566qTHSV/5IeMxeYXJQZ/xFeEkz1jQGbQga7G1UlcIkKbFrmpTMmQfqGnnNtdzzO6s+At91wSMxk4Y9OhJgtkLxnHqy64yt2MmpAlOlsJqNiX531SsC6iFIHrBK5EwzerC1qCxOvL9w/qM1zC0BHrlwFk7nxawBDfd+082rsrLSjYczXSs5W3HBeUlRfwFYhYCJxJzghqPQpefcEU+vs8UxRIEvZL/Wh8owsA1rSGHCMcfjD6BjJmRdfbO38Li4OwJJJCxpSuUnTxP4E183a/snR/i96WV7wgE9EzoQjAi5J21KpFnBzP15rSe2nrjdIhhu+NdX9P/PVW5uJWtmH8xy6tj5qQuFLBQPChGYfJmqfExT68zcEn3oTtPlIzhsBYVpPWLo1nWPVvJw4Ih+tp2yG4fSCKXfJXXqY4pzTueV9uBYXuw9nz8dOGO0S2W0aaJH2S9CWp1JV8SufZO2+CdJLBLoRGjeW2PTI61/oFZRv2GgpjdMnTpHoNU/JPJEccSqb1sdFKFxttDiIPrORzAgqpSpCGTvpRreFVdwwGHIduW+vEyZvKfiREa7ifSlKMYIYacw+E
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(346002)(136003)(39860400002)(366004)(6512007)(2616005)(36756003)(6666004)(6916009)(66556008)(316002)(107886003)(1076003)(186003)(66946007)(41300700001)(6506007)(2906002)(38100700002)(66476007)(6486002)(8936002)(478600001)(4326008)(86362001)(8676002)(83380400001)(26005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?95Y96kfdeSJFDM8VRuelLW9ay6qMznJRWzmXyTlqPTEUbL5U+pfVur/GmIjH?=
 =?us-ascii?Q?CIGJnxzLVCp/KCfGbQSNcgVl9oQe0kZoIJfeR5lghls8VC/PqvSR/asCGrZj?=
 =?us-ascii?Q?1lWMkEamL53LATnHi78mzgaUZxQ8Racpba9wsn8FaRm1DME5GLiUd3JWFiNq?=
 =?us-ascii?Q?PeoDviqaUf0/jnETI1KByNv5zN1XjLayJnrLxQqlVXMLH4iEJQ4lwQNbJ86L?=
 =?us-ascii?Q?DObvgXEGMZbuxpQ/qVnik4pg/5eR5nUXyXXW3Q4LMaqYi82E9L9VUGiZdJte?=
 =?us-ascii?Q?MPkpYW7nBNDFP0ibUhzepA0FNX9lC+ntbRHCg9d4AxAQn2CcSbWwuh2j+pUc?=
 =?us-ascii?Q?RrCxdXDxRVF7e3EAT0/yIbLsE4tABlaESGBdBPk2UmQD9a4vEPJ8I+/l35p0?=
 =?us-ascii?Q?6NqRErEA0A0uz4DG4Jyju5CwjkZ2uzCS70rnVt3KTEPEReE7qOJAOh3U4Hii?=
 =?us-ascii?Q?XjM2lx/j67JQ54/ex2gBCcGml9t1dxDgtn+yJui1cm/hbvNsv65XUZaJ8gWl?=
 =?us-ascii?Q?C5a/RIiy/39Qoxw8aVhTH1N8Cq3XnQ97NIUM3FP4d5Ky321eXVgPqyWpcmkq?=
 =?us-ascii?Q?CdhmxcW1nFUXqVnHmSN/RXggZL10sJyujEFhMY7bQhhJsBtKxY0qfbTz71FY?=
 =?us-ascii?Q?Z/5Judukfx5o+mqPHCRftf21sXpUMTpCtexcagg5S69IST1rOZ4bkqNhAK46?=
 =?us-ascii?Q?+x0/C7zfJ91kbAKt0t/NyG1ZTq2uChiIHzkIFrdTcHVx8nudXZopGSb5P6Wy?=
 =?us-ascii?Q?yqCIXe6BNaYS9DXaoJyIbrGwMFhe/yMQFFQaYUaHr8exi85UkIOoUceszGx9?=
 =?us-ascii?Q?DdNit0xop+Xf3UCvl2lQTsvO5tjRHbCHEmogeGcZjQfploco2OiF2+nvrCTj?=
 =?us-ascii?Q?zK1Qh8WnY/pVINVHaRVz3O1QHxH662AuD8R37joTUjq3fJuAq3t2SP55ZtPH?=
 =?us-ascii?Q?dtNAKxWemOOKIDlfLguNn+vR5+ukFXosHoUKWL4qW1NBW4wZAfc5eMHB9Kzd?=
 =?us-ascii?Q?WF0RwmDj62Syn+JD6r2COUFT0B7gOzmbZeBQ0owPpUaBhUhl0xnV3tplUC2C?=
 =?us-ascii?Q?707YpXr+eaXHs6mDKJOmKAnMGj4yrM1zWVQauJdN6ySRHDxsUaK+o0230V+Y?=
 =?us-ascii?Q?aK7xQnS6kYPWS+2hcBNvRD26L+gdJm9CWASiuIVzyGzigZMGpCG8moG7SjiL?=
 =?us-ascii?Q?ztI/czrayUh5Mh2E6rSMOKrhsNIzdvhpvGP2uDM2mw6OZgOUWtFk2c45QObI?=
 =?us-ascii?Q?ryPkNT6o2dkaY1n8SooXCbT6XNITajwCFrGOeTRONa5oU7HaLpY7KGYkAwob?=
 =?us-ascii?Q?7HJX8JjLQ1OAeeBpzkSwBWJS2biKL6wcppot5HAq8vPI2Jt+oVyi0lthj3AG?=
 =?us-ascii?Q?ELdNg/U3F6H4xf6K1isvoip6EpgJP11fKHx+1qA+K5Gux4utgTFuHA1fwypK?=
 =?us-ascii?Q?JS2z0FHiU3waW03Rn55dMGmO3CgYoBEjFw/5Q4RdPtyYevrLNYxGfJDfhVcD?=
 =?us-ascii?Q?fAcW0Ch7UJ+Ow5gCmzP0+2uJi9cGbMboZIAjUrCLn7K07aqMjYfZuaQtA4L/?=
 =?us-ascii?Q?/ThFygaw1iI93VUNZxUKigVtZWaQjdjIUmmCN7E7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df37e876-1ddb-45c4-819f-08da580bb261
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2022 07:07:28.8059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 91vKhAZJzUo743r9/er2uCf1ALV/abY7g/azdnQcUeHywHFwouPuwuDEX18BkFUEAx7oGUMb8X2vwFdR/3VXwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5439
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

In the unified bridge model, the bridge type FID attribute is no longer
configured by the firmware, but instead by software when creating and
editing a FID via SFMR register.

Set this field as part of FID creation and edition flow. Default to 0
(reserved) as long as the driver operates in the legacy bridge model.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h         |  4 +++-
 .../net/ethernet/mellanox/mlxsw/spectrum_fid.c    | 15 +++++++++++----
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index e198ee7365b5..d0ebb565b5cd 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -1961,7 +1961,8 @@ MLXSW_ITEM32(reg, sfmr, smpe, 0x28, 0, 16);
 
 static inline void mlxsw_reg_sfmr_pack(char *payload,
 				       enum mlxsw_reg_sfmr_op op, u16 fid,
-				       u16 fid_offset, bool flood_rsp)
+				       u16 fid_offset, bool flood_rsp,
+				       enum mlxsw_reg_bridge_type bridge_type)
 {
 	MLXSW_REG_ZERO(sfmr, payload);
 	mlxsw_reg_sfmr_op_set(payload, op);
@@ -1970,6 +1971,7 @@ static inline void mlxsw_reg_sfmr_pack(char *payload,
 	mlxsw_reg_sfmr_vtfp_set(payload, false);
 	mlxsw_reg_sfmr_vv_set(payload, false);
 	mlxsw_reg_sfmr_flood_rsp_set(payload, flood_rsp);
+	mlxsw_reg_sfmr_flood_bridge_type_set(payload, bridge_type);
 }
 
 /* SPVMLR - Switch Port VLAN MAC Learning Register
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
index 279e65a5fad2..3335d744f870 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
@@ -422,28 +422,35 @@ static enum mlxsw_reg_sfmr_op mlxsw_sp_sfmr_op(bool valid)
 static int mlxsw_sp_fid_op(const struct mlxsw_sp_fid *fid, bool valid)
 {
 	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
+	enum mlxsw_reg_bridge_type bridge_type = 0;
 	char sfmr_pl[MLXSW_REG_SFMR_LEN];
 	bool flood_rsp = false;
 
-	if (mlxsw_sp->ubridge)
+	if (mlxsw_sp->ubridge) {
 		flood_rsp = fid->fid_family->flood_rsp;
+		bridge_type = fid->fid_family->bridge_type;
+	}
 
 	mlxsw_reg_sfmr_pack(sfmr_pl, mlxsw_sp_sfmr_op(valid), fid->fid_index,
-			    fid->fid_offset, flood_rsp);
+			    fid->fid_offset, flood_rsp, bridge_type);
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(sfmr), sfmr_pl);
 }
 
 static int mlxsw_sp_fid_edit_op(const struct mlxsw_sp_fid *fid)
 {
 	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
+	enum mlxsw_reg_bridge_type bridge_type = 0;
 	char sfmr_pl[MLXSW_REG_SFMR_LEN];
 	bool flood_rsp = false;
 
-	if (mlxsw_sp->ubridge)
+	if (mlxsw_sp->ubridge) {
 		flood_rsp = fid->fid_family->flood_rsp;
+		bridge_type = fid->fid_family->bridge_type;
+	}
 
 	mlxsw_reg_sfmr_pack(sfmr_pl, MLXSW_REG_SFMR_OP_CREATE_FID,
-			    fid->fid_index, fid->fid_offset, flood_rsp);
+			    fid->fid_index, fid->fid_offset, flood_rsp,
+			    bridge_type);
 	mlxsw_reg_sfmr_vv_set(sfmr_pl, fid->vni_valid);
 	mlxsw_reg_sfmr_vni_set(sfmr_pl, be32_to_cpu(fid->vni));
 	mlxsw_reg_sfmr_vtfp_set(sfmr_pl, fid->nve_flood_index_valid);
-- 
2.36.1

