Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87926504CD3
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 08:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236858AbiDRGrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 02:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236844AbiDRGqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 02:46:52 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2045.outbound.protection.outlook.com [40.107.101.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A8A619015
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 23:44:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j5wgNE64YDAOlE8A7goQVl6ibR102lirtqjM0m/SCRraWzCfVTvFKwsw+RRvE44JbxWSP9ak4V48KvKhGEA1TC553A4T1hBw94PZWB/jUidpez2CMJv7OJ1lEOdKP6XzsnRxLQuF6yKnYijiuMLSyfNauENp5w1V3oNPynK53SRT0ETVi6aX9V5ewk7urGCtxpOjPzA3sFpRQhUkoZuLdqlLr2BnUaSHZW6eYJCdYyGIK88bM59qPz0pNySWbOrEhcfJa8IS4UwMbqI2rIsmQpdX7umVB5Ly4MwBfoknQV9y2sV4u5z0Tuht7Z9L5NNF5c3zKtIMlkDMVAL5Wt73sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mNM9fvn4FehJaHNRhByhn9HMvi1orRPrHHkbxXkl9/k=;
 b=ag4HyGHz94XJLiXp71rpi6m4g2VKDgH4K5R6fsAWCxkaRx36u8Z+1BSYGDp4iaSNkp7QmarHJLgkVZl5n0pNM5fYoxaDDLJMkuMrShvsu6I2smj9qfVwTGJm4txyXe6aYSPzQxY72LwQiPOLeQBvxYdEBxHClhlbVLYOKQcPqSnxMxwo56kwVGxfUY8xbrUB7NskuJhY0DJIb9XlF5cPv4f6T3SQat5Ne88+59QxZ15Aj0XzXMWyvt86pu2/QKgMd6FPAH2e67KQX8H5rNsMIB00gHVBzlLFSiXpNN6hxVEjEYtEqeXOUl+iUKFZKElzcLNfn2ye0N6TmNN4xbB2YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mNM9fvn4FehJaHNRhByhn9HMvi1orRPrHHkbxXkl9/k=;
 b=mCOfZPdyYpwoNwJD7XxM9ce5yjIu5IX2ekXiQp7v2McYdM1MOCR7VihIgI2BB8yYuP06WAYUGvHKV8BLa9IJLhfsId+RjMqsrDlMFWLCi8+iQy0pW/8NLRYWP+DfZszcIC/081+B4vCkXQI5lpO9u5m1arAwXR0tzZ2oCqIbGVmo68wefF86TQqtjW7r/26ozQTr2GmWhNgS4+O6w+LSo+P1h4GEtN2SQAYplq70JTFkuAO20VVr2Fp3ckzsaHKso680YsqduhwfBHYfsa7JZdHH+fPbr32KkHG4PcLC0tyUl4ae4nA9uF/YZdi4C6byz305fVTmIZBvsuyz33p+7A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by PH0PR12MB5420.namprd12.prod.outlook.com (2603:10b6:510:e8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Mon, 18 Apr
 2022 06:44:06 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402%6]) with mapi id 15.20.5164.025; Mon, 18 Apr 2022
 06:44:06 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jiri@nvidia.com, vadimp@nvidia.com, petrm@nvidia.com,
        andrew@lunn.ch, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 07/17] mlxsw: reg: Add Ports Mapping Event Configuration Register
Date:   Mon, 18 Apr 2022 09:42:31 +0300
Message-Id: <20220418064241.2925668-8-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220418064241.2925668-1-idosch@nvidia.com>
References: <20220418064241.2925668-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0196.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a4::21) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 25814b01-f392-41a2-06a9-08da2106d55a
X-MS-TrafficTypeDiagnostic: PH0PR12MB5420:EE_
X-Microsoft-Antispam-PRVS: <PH0PR12MB5420278E8F3F2DB5A3B4442BB2F39@PH0PR12MB5420.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HyxCgL+hO7SN0Tw2LQfo+X3AvUIe+7iHzxSkyFwxy4DwnyaZwxh9Xm9LQcAZ2xpSmq5L/EdtzJqzh3RnrKk2vOjjUbBfkiXVL2qSptiIqf/sq8lVNe0c7pqRyeX/hXja00cjHlJz0Ado5jVxHHrQFDigl8BC6rK+J2FkL8yyjZEvyew2S3ehIt03Ud+jUgxy6FgFLnaPOP/BM48aGu96y/6oawvL0YxhczbjtnZdHK9fj2MtNcu0MsJa/FILRBwPa9MlyXmuB0d42T6pAk7XWlmjR4GttTIm3gk72JBs//GE9gn44d/NfEaDIntuQueSZ8gFFQBsg18iKX654Bk02Dn/5p4a8xr23bLi0U1igkBMduDXWY/2tNcHf951S070GpOrQMj1CnX5VZ/vKMWm+hk522W/0Il9EGCNgbsIDvUc7vspehik7jmEKSmkXsuV+lN45DKR3hVSlQ/qZtYtkfQxJ3OE9XKKVGj+N3CTuJJQHJ4hTt/e4syn6jjSd61GPLWtIC1heA2TW/mStfhdu1GoDAbqdvE9uB2qmXSLnYkyvWdPYLSljHd1K6wt9SFdD6SPwp5vpud3jNxipDRhVavMK3nTkk4h0xN76sw/qSLDEw8yVSxYyZI36ECitkptg9ROdRuDmX2vle//W6WfEA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(6486002)(508600001)(1076003)(2906002)(6512007)(6506007)(86362001)(6666004)(36756003)(186003)(26005)(83380400001)(66946007)(38100700002)(5660300002)(66556008)(66476007)(107886003)(2616005)(4326008)(8676002)(6916009)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5MkJC8iM2K6isAuEu21TmKyDZc6lgCyAwlnP9gUHdAC4hAABWU300Sbukaxu?=
 =?us-ascii?Q?mX/AZatPESbIfD6+6p8Fbyf3WeWLGNu18hVr7Q8fJC32Kvqp6KHg8lX63i8Y?=
 =?us-ascii?Q?JVL7O5Ndv3Nm3iBHSElc80tew7IWipPHp6KIo6mGr5+5GUOMMtICc0Y22/tU?=
 =?us-ascii?Q?FSOJtf+QOp1f2P5sd/i0OcSXE813Fr4JmtbqkWlhn56Lm4Vi9DdxMUFInwOt?=
 =?us-ascii?Q?iWyt+02en5UH6g6hUufp61UkA6jJuSZNFFbVw129Xb8js/kpW1eGFdFVoK7r?=
 =?us-ascii?Q?QH3pvh3WeDaNZQDG8OkohD6yVm6hRPf5zg4z+4QY8S1fZ9DLcKiSIwiF6hrs?=
 =?us-ascii?Q?ov506fAXPRn4FGVLG0tnbj7KKs0SEzWYWNx+7Msz3omOhKVo6YFOwtkgexP9?=
 =?us-ascii?Q?vWVBnXlgNmvIKGpxv6QWch8/oX/zqpF+iR9/7/RBXbJMNTxd2/WrnFt9bDwq?=
 =?us-ascii?Q?JxZiloP+PZuwZkeNpeVB9T98z+B1xew2bGgQMtnWIE1PDCXjYCjQ4egCvAZK?=
 =?us-ascii?Q?D6ZAWDouGcAt8KF0TU13WtIxa9mOKr7RWDurOg+cxUvHP0xzwoOWgMFxUgHm?=
 =?us-ascii?Q?S4yLuazlb79gChzpjdQqB5TonxuU1u3Oah0wNA62zUBI+XKL8uqTzFVebJ4T?=
 =?us-ascii?Q?/WkLLapYkFupGkksLtpVPs70CsqiFJSzsj3GWQOzlOvVIc7KkxJtovdNmYr6?=
 =?us-ascii?Q?DTBLIgbSKeaVslp2Ig7iG66ZJ0FaLxqOfxRdmqA9eLxQkGKqFx47/rOy1f6U?=
 =?us-ascii?Q?Zlkeg8R8YVv96aN7LrIS8AtJBvnUcm1Tk7qi2VHEA3OAjP8TSfguvFM5ZofQ?=
 =?us-ascii?Q?05RI5QJpprdmwGDX1182YOGP04P3x3OylLNBT2dgWywtahCh9OmZJIdJ3P/Z?=
 =?us-ascii?Q?Z1ADL4zDrE5BNjg44yrvsQ/b0PwKBWPZaEybk50mNvLXwgNjklOyQAEpl0b0?=
 =?us-ascii?Q?085JiSdCeDeFHM7NSGoLEokayZrgXtZDvjkSC2GyuyidDEY8ho27x9ZxbaSs?=
 =?us-ascii?Q?oQnESlvRkjM+KKVq4O0Ey3CbsFzgVCRUMPA8nU14i/OKbJ15TjYzr9CtVUmR?=
 =?us-ascii?Q?26h8ljrWhUCgHCbzlRXVsC6Uf7jSxixoUiorYz6R+/CuZtp9VVEtpHbK+/l2?=
 =?us-ascii?Q?Lr+fSLkb2Uow7xunI/YXK8xQ+AzZ3vyN3v3x9YFYeMISaKLZ8jL6NY7fXNj+?=
 =?us-ascii?Q?f/Vp6Nawoex65xdOjY2TrwBYmCjpKDCh9um3sFla+qh7etjL4CxDYxNxJCvU?=
 =?us-ascii?Q?ZZ8wMrV7dPiAzWRuBmzFbnDfCJH4SOsEkcvqVTQhPC4y0Da8XRnQmVJuXS+T?=
 =?us-ascii?Q?GIlMmHn2CZFJqisICImnnZKq/Eyo1EW8ojkLPeVILtNRmZ4fdf3beG2rsx2C?=
 =?us-ascii?Q?bEyAGeM2hiD7h0HiBtd6pGftBi7ki7mBdbNi+plIzN4hiubFLUuZzR91YNLn?=
 =?us-ascii?Q?lTFN1LEqrHhD0I+LvHUoTqXw/Syj6qlND2RLemCdr0CcFJYxk4BRXyokdMYk?=
 =?us-ascii?Q?el7P9+8c5lvUhAlCC7INku4RJkzyjXKRkujkHXMuhKCj0qxCT1RMIUefsQ4X?=
 =?us-ascii?Q?j0CQ6tXtAFFmIPLEbsoWm0MWg69mntVsh1ZNjAi1TVLqJRn1s8ts4ZwwYtNQ?=
 =?us-ascii?Q?zP+JRfVzizxXqEvXZL3WNSNhhxSatZ1xQYmqirHjLEDS5wxBq3cJt6Fh7/hv?=
 =?us-ascii?Q?awkp7eElX2K3tCygNKlTvPfBH0nWf8EW3L5DtXly9eLN5N7TthmESpBHlwbt?=
 =?us-ascii?Q?RlT+Yyes8w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25814b01-f392-41a2-06a9-08da2106d55a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2022 06:44:06.0563
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i1wIB2IMdypraX1Ro4q5B20wV8YDezlr9Ogvh3pCdBg18oftVYqcT3QOODOyAwix9fwWvIWmaTpY1ef3vPZ8Jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5420
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

The PMECR register is used to enable/disable event triggering
in case of local port mapping change.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 64 +++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index b8a236872fea..7b51a63d23c1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5875,6 +5875,69 @@ static inline void mlxsw_reg_pmtdb_pack(char *payload, u8 slot_index, u8 module,
 	mlxsw_reg_pmtdb_num_ports_set(payload, num_ports);
 }
 
+/* PMECR - Ports Mapping Event Configuration Register
+ * --------------------------------------------------
+ * The PMECR register is used to enable/disable event triggering
+ * in case of local port mapping change.
+ */
+#define MLXSW_REG_PMECR_ID 0x501B
+#define MLXSW_REG_PMECR_LEN 0x20
+
+MLXSW_REG_DEFINE(pmecr, MLXSW_REG_PMECR_ID, MLXSW_REG_PMECR_LEN);
+
+/* reg_pmecr_local_port
+ * Local port number.
+ * Access: Index
+ */
+MLXSW_ITEM32_LP(reg, pmecr, 0x00, 16, 0x00, 12);
+
+/* reg_pmecr_ee
+ * Event update enable. If this bit is set, event generation will be updated
+ * based on the e field. Only relevant on Set operations.
+ * Access: WO
+ */
+MLXSW_ITEM32(reg, pmecr, ee, 0x04, 30, 1);
+
+/* reg_pmecr_eswi
+ * Software ignore enable bit. If this bit is set, the value of swi is used.
+ * If this bit is clear, the value of swi is ignored.
+ * Only relevant on Set operations.
+ * Access: WO
+ */
+MLXSW_ITEM32(reg, pmecr, eswi, 0x04, 24, 1);
+
+/* reg_pmecr_swi
+ * Software ignore. If this bit is set, the device shouldn't generate events
+ * in case of PMLP SET operation but only upon self local port mapping change
+ * (if applicable according to e configuration). This is supplementary
+ * configuration on top of e value.
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, pmecr, swi, 0x04, 8, 1);
+
+enum mlxsw_reg_pmecr_e {
+	MLXSW_REG_PMECR_E_DO_NOT_GENERATE_EVENT,
+	MLXSW_REG_PMECR_E_GENERATE_EVENT,
+	MLXSW_REG_PMECR_E_GENERATE_SINGLE_EVENT,
+};
+
+/* reg_pmecr_e
+ * Event generation on local port mapping change.
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, pmecr, e, 0x04, 0, 2);
+
+static inline void mlxsw_reg_pmecr_pack(char *payload, u16 local_port,
+					enum mlxsw_reg_pmecr_e e)
+{
+	MLXSW_REG_ZERO(pmecr, payload);
+	mlxsw_reg_pmecr_local_port_set(payload, local_port);
+	mlxsw_reg_pmecr_e_set(payload, e);
+	mlxsw_reg_pmecr_ee_set(payload, true);
+	mlxsw_reg_pmecr_swi_set(payload, true);
+	mlxsw_reg_pmecr_eswi_set(payload, true);
+}
+
 /* PMPE - Port Module Plug/Unplug Event Register
  * ---------------------------------------------
  * This register reports any operational status change of a module.
@@ -12678,6 +12741,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(pmaos),
 	MLXSW_REG(pplr),
 	MLXSW_REG(pmtdb),
+	MLXSW_REG(pmecr),
 	MLXSW_REG(pmpe),
 	MLXSW_REG(pddr),
 	MLXSW_REG(pmmp),
-- 
2.33.1

