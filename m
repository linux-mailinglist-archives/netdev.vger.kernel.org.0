Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 607175A9A06
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 16:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234583AbiIAOVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 10:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232685AbiIAOVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 10:21:01 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2071.outbound.protection.outlook.com [40.107.237.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6729432EC1;
        Thu,  1 Sep 2022 07:21:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mQDuxmPMKgq+5eat+j7TfqmgVBa9QJwwxIWNNAdarunVYn1CdbZSx0bCz9W3WPZuBzedFgg/fWp2Ep97Dg4OCi+2AgPpeYCPXRnoO4Ua8WfXa2DikxXdTz6zcFec8mxA1KD/kEoY7e1fA1yDi8OG1y6RXP25hGKA0rsMBvoRkxpOb+rh8cePmJoOhFlBmAGbUDZzLJ+9GCNvIkRpgNuMLHa0l+rwwX8DXtdeyo+eWkJljV567N9ePeDvelpCS9f2AhjsB3CqGKP7zSpb6OwbBMBT6A2NAQ5PJesxsY+spYj1QkBBN84sGQUaEcJqPOL90stDTVKKI9YoYmfijtIfxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/aB2fdyup4zXlO7Fs2az03ubJD/zt2/t60pbinRpFNQ=;
 b=aBt/156TwEDGCmZgi6MygQeDDQjTKmCV4Lpa575aKRhkvFmmM2GlvYsi/jLGILTvIzy7945rIBP9W8WLj8uPraxebGaHYO7AoTH7paTEA7AOUfin54hzwvMVTD30ZWhjsLDjfzIgywRV+NYT5nyRxaoyAKlmwZy6StQRFQO4Y5cJy08wf5iOGJBf0X4jOyJUIZCbGtWftS1C4USbdPdxO9NQU5IOZklRdeQTEQESIohmZ1L5/4CKvWDIbO4abqUu6Hk2ANGh2MLHcMpQkPGvv8fbBs6fuh5hLUedC7l591RbIADJZwZ8ojzAfIgn9Bhw/rIXQkokmtOSSjR1z97BlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/aB2fdyup4zXlO7Fs2az03ubJD/zt2/t60pbinRpFNQ=;
 b=fhZmiN7U8rZs0slqgczpOzdTFY4A/es294tSxlbS6qTlnkg2JPTIWmw60A2jFK4Mbc7bbnpjIINDfTqK+L725dh1267yyQfGzpk3TGTEJmaLTEmzSGri+y+6zknHB0Achf6pIbb9D7XVkfet5IZbV3YOdEvLZJ2hh6oqtTTLlpMQdz6SushKoQ4cHG4z9I8wWGKFEahlCsB99nVPcsHYi3TZC9kUiTBpX9+EiqAN3eRn5wIIGN3627I0KFlPfY6WfKEP+9eQ3fRlzRP6Kcn4V9pjAslq1Ae8hU5pXcwsKcGZ2DmRSIUWgIv8ZlvyRNp7vUbVIi0GIGXUMlrThJlHCQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BY5PR12MB5000.namprd12.prod.outlook.com (2603:10b6:a03:1d7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Thu, 1 Sep
 2022 14:20:57 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5588.012; Thu, 1 Sep 2022
 14:20:57 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        dri-devel@lists.freedesktop.org, Leon Romanovsky <leon@kernel.org>,
        linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sumit Semwal <sumit.semwal@linaro.org>
Cc:     Kamal Heib <kamalheib1@gmail.com>,
        Mohammad Kabat <mohammadkab@nvidia.com>
Subject: [PATCH 2/4] RDMA/core: Add UVERBS_ATTR_RAW_FD
Date:   Thu,  1 Sep 2022 11:20:54 -0300
Message-Id: <2-v1-bd147097458e+ede-umem_dmabuf_jgg@nvidia.com>
In-Reply-To: <0-v1-bd147097458e+ede-umem_dmabuf_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR01CA0007.prod.exchangelabs.com (2603:10b6:208:10c::20)
 To MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9e4e12a6-d60d-496c-015d-08da8c253009
X-MS-TrafficTypeDiagnostic: BY5PR12MB5000:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pDIhVsbNPCH+LhanUheLaUnlGaYL1t0kAYkMcEFk7HH6dbs2Lero7nX8e0hrGuY7rZARQW4B6415QmY63s5m2X+TSJ/7b+gP4hfid6K4MnfwamloC5R2XOBxe+SyUGKYG+2p5PrGBXJwBFhhgnXtYfwZbHf2dtYRzGl0NfXnRk5s72fsd4d720RKSDelHTZTZQwj3pOf/BKHYLrOeMSxO2KOOQ5iorgJ9ydF6BLnqB57wiDOYfKvs0JLCC0KVQX39qRwJMNOajOKLaQ7YTJZWXsnQEI//H0ACkW21qxu2hAEDGQx3r3lk4MjxKSOBaga2c2SQpUL1RjlTOLIL1DbAmR1/Oy2uDFFahiZDZ486bI4UrCQ8O+O8/tBPcDxmnIbaGtaKHBBJlmpcg0IsD5XzwSPU0p3gOkjMeLhgbMGu7K05kKntJni2xThuq9oyXtVdTHMHxTPs73rze7jlsc/L8O9iToIKoTUIIzAc/Jgh/4uizYPQ1MirPXt4jRn2401OtNxH7qKlVYRlW/ShZxVXGWRn1uq/Hk5Nq0QYXEwARdh65d22iFhBJMeAH5ac8wsujBh3CeLzfdZ+r/N6KeC2dj2t09HKm5FvoyzzmkkKWdCXzTh93QSZ0CC+FJcUhFz7NSbTylkE1uBo3CxQzykzVOG2f+ejXXS76902UqgQaYrTD+dVI6chZiincaTmkAXEt8kRXdgd6UBzmpAG0tDZgukU48HQxXKJ+wCYwFdRHwhU2Au2iKPmb67+NRmBnck
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(346002)(136003)(366004)(396003)(6512007)(66946007)(4326008)(5660300002)(66476007)(6666004)(6506007)(478600001)(107886003)(8676002)(66556008)(6486002)(8936002)(86362001)(41300700001)(83380400001)(2906002)(2616005)(26005)(38100700002)(186003)(316002)(36756003)(110136005)(54906003)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UKAP33sN7HmkgVXsDBVvWQEhWbPRMDmw/iLMiUsV8ThAzAdGlYubAp8NbzN7?=
 =?us-ascii?Q?eYeXjcAjlxp3rGVGt2m2BSn6WJtuR91xB1OPI+BamoAcbuHe3f8TSLy9c3mm?=
 =?us-ascii?Q?sd2EVniUrece6LnuGT75txH7gKjsDK+LQ95e7R9LxE5HhANp+hH60zPOt+Zl?=
 =?us-ascii?Q?2kd4tPCxm9XqGiqUj77prExKaI8txIviBk4+QBPyIZx53SDsOImHAtvDlGVH?=
 =?us-ascii?Q?GHwn36lewtfhXDu9lgemDYzOpATLJKFhB77AW4Kveh19XgFUv6pzGGb0C1NX?=
 =?us-ascii?Q?Cm0pxb8P7GuOQwKGXh+41Eiy64qJBuLZrguJWJwgiFmjaxd+HxmZJZ1TcVdM?=
 =?us-ascii?Q?/heR/jtGHunaR24dp95KV1sx6TWGFdy20peNHVc1pMvvu/fZmsDuqi4ke7Zi?=
 =?us-ascii?Q?qACzz9SaXmmYK8iNqILxuCGYRp0yPTQz1NC+F1L+PRULtxWnqy3LoO4e3F8I?=
 =?us-ascii?Q?ezK14ABC7TqAMXQ0gRU7GSi99TOGYOySXim9CRKWa+vzQiRpeGv3RLA1iv7+?=
 =?us-ascii?Q?MLsux9v/7UcvX5vE4nbwVuASTjxdEnsapifeJ79ByhkffsEVMoQK6z26NOX9?=
 =?us-ascii?Q?jWMe31qEXLag0Zwvtlo+XOWgtDDpfNIZw42CxMuCEcgnLf+2QUeGDuEYvoQ3?=
 =?us-ascii?Q?Cigf/0TZbT8jyUjCrVVKtQDsFskelfB7MrDH1yMHUmR/T7ZvoQsRzff9Gog4?=
 =?us-ascii?Q?PgBwuDtToI89wJ+zXUcaPxcI8po0F8DdYHpK0wVeq+o74CT4nuOqugpTUaDH?=
 =?us-ascii?Q?Ts/YEEzcriQ3b/ZbkbTmcAPyvczMFFhxq98k03up9nPESlaGjzpnd/Xc6UVc?=
 =?us-ascii?Q?3YljU0AQNM+oJ+tteye8vccTPkMNT/BVSevKlHK8O0JcwC29TTPR5sF2IBf7?=
 =?us-ascii?Q?CKrl3cDLTjJduUPomZfX1x4KPY3oNHUqKXxomHhiprsxMSpl1Wa0REL17cMr?=
 =?us-ascii?Q?GmMyCrgla486trzuOejP9CS/RL3E5jYpu5qpkEMbgJCPeDtKjYfjqHVNYfcK?=
 =?us-ascii?Q?9vTWU4wKVDdsqcZbc3/fdTnMFKcEZWvIlo5jyZeRwYKNF4mnnU8aaDHQv9tL?=
 =?us-ascii?Q?M+QdVTaOx3rML99BAqnx5QW1QXHZa/okrLP5nErLILJYrKRrpNUa/vwT+oKw?=
 =?us-ascii?Q?/Jq2y8TIR3LH3BRI46s4YiSVotDeKPYcObYD7QesOajWpSnzrcuw+seSAIOj?=
 =?us-ascii?Q?EW/f2Z+LqqteX82zexU2UYGXriRFkZLa0Sxqv13mXm19ZoMB5GrUb6KW1Ab5?=
 =?us-ascii?Q?8AD+JbjQJNfzitK4o6co6HZBrtJPQRGl445yA0sDoF70yiVimFPqTTw+mfln?=
 =?us-ascii?Q?pSIbiRMAP7SqT07hAJyJOKvHGIyR/KRRc/dCiqgqh/BeTgIi/EWdBhp9PeoR?=
 =?us-ascii?Q?TzmcvqW2wP1ceR/q/YaVfrihBKURFMFLVescSqODH8oGF7giiP2FwMfaLvPY?=
 =?us-ascii?Q?dTxcUhG8/erM6pqIx20idLDVAZ2Y0sDlJ6uJV3LQEviab4+DGLGGnW0kS95i?=
 =?us-ascii?Q?itfWtoHh5PcS/2+JyZs+VXj0Wt6TcDleOPzxgXgFWEuYkQLjz5fcvHRP914O?=
 =?us-ascii?Q?3X8Br9AEXwdn1TKRkIe26/2FoQXGVXaAmj2uRdag?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e4e12a6-d60d-496c-015d-08da8c253009
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2022 14:20:57.5171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3MayONxtN/zL4PW7xCehQvlc2ay4mi/jVluEOkJMaoVCyd0vXa+ydBenYoQ9bb9D
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB5000
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This uses the same passing protocol as UVERBS_ATTR_FD (eg len = 0 data_s64
= fd), except that the FD is not required to be a uverbs object and the
core code does not covert the FD to an object handle automatically.

Access to the int fd is provided by uverbs_get_raw_fd().

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/infiniband/core/uverbs_ioctl.c |  8 ++++++++
 include/rdma/uverbs_ioctl.h            | 13 +++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_ioctl.c b/drivers/infiniband/core/uverbs_ioctl.c
index 990f0724acc6b6..d9799706c58e99 100644
--- a/drivers/infiniband/core/uverbs_ioctl.c
+++ b/drivers/infiniband/core/uverbs_ioctl.c
@@ -337,6 +337,14 @@ static int uverbs_process_attr(struct bundle_priv *pbundle,
 
 		break;
 
+	case UVERBS_ATTR_TYPE_RAW_FD:
+		if (uattr->attr_data.reserved || uattr->len != 0 ||
+		    uattr->data_s64 < INT_MIN || uattr->data_s64 > INT_MAX)
+			return -EINVAL;
+		/* _uverbs_get_const_signed() is the accessor */
+		e->ptr_attr.data = uattr->data_s64;
+		break;
+
 	case UVERBS_ATTR_TYPE_IDRS_ARRAY:
 		return uverbs_process_idrs_array(pbundle, attr_uapi,
 						 &e->objs_arr_attr, uattr,
diff --git a/include/rdma/uverbs_ioctl.h b/include/rdma/uverbs_ioctl.h
index 23bb404aba12c0..9d45a5b203169e 100644
--- a/include/rdma/uverbs_ioctl.h
+++ b/include/rdma/uverbs_ioctl.h
@@ -24,6 +24,7 @@ enum uverbs_attr_type {
 	UVERBS_ATTR_TYPE_PTR_OUT,
 	UVERBS_ATTR_TYPE_IDR,
 	UVERBS_ATTR_TYPE_FD,
+	UVERBS_ATTR_TYPE_RAW_FD,
 	UVERBS_ATTR_TYPE_ENUM_IN,
 	UVERBS_ATTR_TYPE_IDRS_ARRAY,
 };
@@ -521,6 +522,11 @@ struct uapi_definition {
 			  .u.obj.access = _access,                             \
 			  __VA_ARGS__ } })
 
+#define UVERBS_ATTR_RAW_FD(_attr_id, ...)                                      \
+	(&(const struct uverbs_attr_def){                                      \
+		.id = (_attr_id),                                              \
+		.attr = { .type = UVERBS_ATTR_TYPE_RAW_FD, __VA_ARGS__ } })
+
 #define UVERBS_ATTR_PTR_IN(_attr_id, _type, ...)                               \
 	(&(const struct uverbs_attr_def){                                      \
 		.id = _attr_id,                                                \
@@ -999,4 +1005,11 @@ _uverbs_get_const_unsigned(u64 *to,
 		 uverbs_get_const_default_unsigned(_to, _attrs_bundle, _idx,   \
 						    _default))
 
+static inline int
+uverbs_get_raw_fd(int *to, const struct uverbs_attr_bundle *attrs_bundle,
+		  size_t idx)
+{
+	return uverbs_get_const_signed(to, attrs_bundle, idx);
+}
+
 #endif
-- 
2.37.2

