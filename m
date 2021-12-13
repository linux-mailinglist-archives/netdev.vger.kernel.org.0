Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2978472FB7
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 15:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235628AbhLMOrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 09:47:14 -0500
Received: from mail-mw2nam12lp2047.outbound.protection.outlook.com ([104.47.66.47]:6643
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230272AbhLMOrN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Dec 2021 09:47:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nsIW7F+yE91f0lbcYGrm0U/C7HP+CsGVCnxcber4HOREfj6G9nVa/EievyHeqfGGv/qUrEuggQfHUC791MePFi0fCOohG3wrr/y77UM0gLnXgGtYuoNmCQ/HTYFtYCs9FQAjHYMf6KVHkXeMdGROowOssRdb6DZWkpLp+USFqN3kHwByVQLFU0KMiF9aEGoVgczDxjxz/aCX5/b4S5vzPlC9+JkmxECpqjcQvS3odjTtvD8ovARpiA9v4viPfDPmeZ5kXKe+z3DXwXxb17xd3t0bSH1eTmhdvl9yfJ3QCC+8xW8cX61h8MH3GNjmvY7nT+6dT7E1r83TLPMg75tIyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZlPZp6boE5oyDOShfe4nF4fMhGmN4+tzffza9VIcurI=;
 b=GN4rrwI2vTOPOeXeaw+m2PO4BlZhPmclokh29Ew2xrsVJp/DqfX8z+FY71UbRGQsT0x3m2YC6WnFf9tN2fr1ejT6Ij/BCs9tNPnxh+vBY33q0Vp8lbedKEMzO6s7PQr+3xug8oVX3j6InqOSz9TN9+u+g242UK8wogIdnPNTMu5G3+YkiF6HQhjFkhq5RBNpctngGeyPMLdvvWcFQdtIepMoXXZORUYuMU9Mln4MS2xSnC9piIcBcjJMyitBqIm+/uEE6GBR1i5SdlcKwmf/Yux/AGGcPHKSxp0iERtcEnpt9NZn5E0x/dqqywBsnPhBc4hY/IqrwZPtmqm1OMht4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZlPZp6boE5oyDOShfe4nF4fMhGmN4+tzffza9VIcurI=;
 b=dhotpBosZSQLr82ik4ccIFcJGtsLuqKyav9EIwhJOeaT3xIIzo/YQCRkmmNQJ8NqG3CZOx6/D8rN93m05CeVz4inb150xCWyq+SOhAO1Apt8zF9eYwaymCxo5Njsd5ZMog4aczcIQjh4HUC9FKXw8K9ppilQXOLayWQ1631tOv0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5780.namprd13.prod.outlook.com (2603:10b6:510:11b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.7; Mon, 13 Dec
 2021 14:47:10 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4801.014; Mon, 13 Dec 2021
 14:47:10 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Roi Dayan <roid@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net] flow_offload: return EOPNOTSUPP for the unsupported mpls action type
Date:   Mon, 13 Dec 2021 15:46:04 +0100
Message-Id: <20211213144604.23888-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0078.eurprd02.prod.outlook.com
 (2603:10a6:208:154::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1771ea80-c930-4bd1-bfff-08d9be47710d
X-MS-TrafficTypeDiagnostic: PH0PR13MB5780:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB5780B37238A2C5DAA74B86E8E8749@PH0PR13MB5780.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KfArVTpwsywhnqp3Abys/hNtUF72UEOTJyQJGD+DRGPp3d6lCIOW10h4SGItppnJYXjbsW8wJIy0scMGAg8BIpo/e8FiiiYhceu8rkCVWus3hl2+XHYmqu8yDTUgNHFlNvZqkRzKoYRCY2L5D9p7GXTAMsGboM6Zp3A1OVa9BpGJNiYMPOeyheA5K09re7c3CU9+YVUG8rTbdy83gS22zOVsFdZxHiscB80mvsrvRkUz05CRNm5C5/P8yoiBBTgCqq2kc7XEpdcLU23ScRwZDqy6A0n0uVLXKvv3utBDEVmPbVY9LbIpHpQ4Wp1ngJuOKFH6cu7nPcApjF2XHzEREEQMTdHC+hlczWOvgqeRb5om7S1irH83fMeQt6E3aSMd4eiebrh42azX/X9jUa1ZvihP/tZLc8bnCn+QGFrMLdHEne4nCGhm5jj98OnDLoElpqoJ+w/Az+V/cVPwsMZtqz+c+D+MfwSChrtOKwJBUYWMaixkfMCt/DjEd3D74q4HyAtYC0Rn8wuvVyCVSR9rKyoS5u4n1YRYL8IEjm3E1EPiTMTNlGx6O9wHtzIO35qEiiSGe1ubqhzz1qWvtfuMJqkM/Di05olNQkCGF07JchUEfLuPUbjZO7qpe2yl2e9PKfYnVLhYB2qDsygp+bHoqA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(346002)(39830400003)(366004)(136003)(376002)(2616005)(38100700002)(36756003)(2906002)(44832011)(508600001)(1076003)(4326008)(54906003)(86362001)(66946007)(5660300002)(110136005)(316002)(8676002)(8936002)(83380400001)(6486002)(6506007)(52116002)(6666004)(4744005)(66556008)(66476007)(186003)(107886003)(6512007)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Hnymu2At98VIdZfX33hnkBOcvOwF7zJ6PCdAK/Ll9I/GJ3XXTAWCRm3dgkua?=
 =?us-ascii?Q?XW3oGpt/S2OTkfHAo2Tmpg5La+ms3cIW9Q0ttCfK7/0YOmWz51pseTHv/h6r?=
 =?us-ascii?Q?8ABJwP7e/3NhwdYtM5sIY/6BGyGx3bMkM7rSieb45ZyXoqZDMsHDWAVZ+Zuw?=
 =?us-ascii?Q?KrEH0Dht50L8wRA2O/xRjgovlExRcfjmcs+dHgfI9psUNlC6bUnhoCAhMYuh?=
 =?us-ascii?Q?5SWGbuYLOC1kECXE3fJlW2pP4vAcrlufloqSH7oHCSdwQT7Wlx9zTj47vyer?=
 =?us-ascii?Q?bLW6xupEbFHDClu5lOOXV9C8wnC+bI5nJBFurV8IxjHm7GD8Kwj0Z52MPkug?=
 =?us-ascii?Q?hKLFMcFWbSU/wpFgO5S51WgQFl2eB5H8gKvucIHtO4b6Mzu6CVc16QGohsbE?=
 =?us-ascii?Q?9dPsiLjZlOyystifLJUPqb9ryFbhGWla64lAVAXbGf5TO9EYOSlvnPxnvLq8?=
 =?us-ascii?Q?I5f26UYMYQDwNFHww67D8NMvZUI2c7uml8lo13rUbiPIFc5T6K7018AkMXK7?=
 =?us-ascii?Q?tkTgbPxD/ZQyZkvHhcLdGV5BiXvuxyR8UxkO1splCvO0i8on+In0/lNnLLr9?=
 =?us-ascii?Q?d+uat5okpAHHmivlrtFUYGhQNpOt9DBUWNYDoauiPYQ3qo1CKl7PEZ79kYAf?=
 =?us-ascii?Q?2g7uJ/r5A0Rl9aBiDbHvFdSlLY0tYCPBtMTUpdngbqndkZ8/Ti3p7hTghmlL?=
 =?us-ascii?Q?HWzvX+5F2/jFIKAWBmI8s83kvvy3ZbXmdpBrLcmLovl3CvkZxZtUKwtbuLLc?=
 =?us-ascii?Q?wtykhAc8yUpZMDfEArs4BTQuMJ67H7uv6hfiCdNZxdPdaV0Fi51BmL3hsIm4?=
 =?us-ascii?Q?MzYfcSHew+IHqk2b6JA60+LuuO3TbOAJU+b1BUB5ki7ZjeSP+wJ46z5LxMxR?=
 =?us-ascii?Q?mTfKYHJjLitjnl5I5jRyL+TG3JafKcYZMk5u5Bh+5WFZ1UsetGSDL7fMRUz5?=
 =?us-ascii?Q?pf/ptLJ9nSKNLQQKisn3J3xwh0KPnPTnL/0OGGSY7Qi68l8HZhrQG6u20D/0?=
 =?us-ascii?Q?yjlG7AYtSvoRq5+fTXX6gcQdhsGy3yDi6aUd4vMoieCOqGd91G+gJjdScLFk?=
 =?us-ascii?Q?jNooo7uMG+Pg/eQu0LSsndX8P97Tp07XdhBqeWErDZywF48YAmVgDn0pUV0f?=
 =?us-ascii?Q?sA53mQ/yYbUja640ZNxovIfjuLTJL1SRsYgFpKlD2XWhayqX5ACqGNtv3+6F?=
 =?us-ascii?Q?FThYjyV8DBZ4MaajBHwdC1JCv06n5SyREyNTtpzQdVxidfKrDmfZgj4mCYdm?=
 =?us-ascii?Q?HrDbaAaRIX3dSmd74X9a046EfgNH8CSGzOVcZs6GlefiHvmE9AsoY2B/0lzy?=
 =?us-ascii?Q?MHeENy9voXSF4KSWtZMVGu7w765QEt0hTzKUEz3FM6vVbKp6jePl73mzP3Ct?=
 =?us-ascii?Q?SaNQe/CRvYmulzD2D20dgOttsuTgjHvAreF3VEPkAON/Dp/QuqpJbRRnsMLV?=
 =?us-ascii?Q?w6yY8ux+7AVVTffGGS8dNiA0moeOLkaASbNKnZMKiO91T6AnbbBsEJAAsL+G?=
 =?us-ascii?Q?8X3Xgaxqyp/JSGzNRiKBODDg5xl75nO+JKS9g5OLR9Yt9w6P/sw2enMi8yaQ?=
 =?us-ascii?Q?xQczXy7DjWOk9wL4LwXnEExqEsy+PPUbz/FxiNNzrMRKm557o7pOaIo/h9GU?=
 =?us-ascii?Q?aDECKryl/0MLzbTEDT/Qa18UyPDH9qwBsrZTblIc3gVF01yQ4xmhIhOZoTmy?=
 =?us-ascii?Q?I2gxZNyKEMJhDEvakQMaG9uRhAQekpMR/Gz6sgC48tr7YV5jmCXwkJBfKZyp?=
 =?us-ascii?Q?Xe32X/1JNQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1771ea80-c930-4bd1-bfff-08d9be47710d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2021 14:47:10.1264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 18if/KRrfBPTI6d7fkX1zpi0uk5LG7UfMKyLltLYEhuLZOEZkhu3XdqZrH0hk9wBg7t6cttlzEMHmQH/ZZVNnimgsbSTkKYyFXe89Wostao=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5780
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

We need to return EOPNOTSUPP for the unsupported mpls action type when
setup the flow action.

In the original implement, we will return 0 for the unsupported mpls
action type, actually we do not setup it and the following actions
to the flow action entry.

Fixes: 9838b20a7fb2 ("net: sched: take rtnl lock in tc_setup_flow_action()")
Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 net/sched/cls_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 2ef8f5a6205a..e54f0a42270c 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3687,6 +3687,7 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 				entry->mpls_mangle.ttl = tcf_mpls_ttl(act);
 				break;
 			default:
+				err = -EOPNOTSUPP;
 				goto err_out_locked;
 			}
 		} else if (is_tcf_skbedit_ptype(act)) {
-- 
2.20.1

