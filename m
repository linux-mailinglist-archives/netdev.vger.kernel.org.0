Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1332648F5A
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 15:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbiLJO64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 09:58:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiLJO6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 09:58:34 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2086.outbound.protection.outlook.com [40.107.96.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75DA06141
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 06:58:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rxz9hwA9mlx6CerGaEd6NcodAJAdKSepSqQaXPf8uJP4H9fWyoc3AtEtJViTG2BJ0hXRCjm4wloNMMEGXrnuWn4x0A92OjyskZcEPNZVfYbs8qHMl3AWtLObuKd4OAhkf1XTGFjb/QGTIGkaSYa1vDsIZmBf2JUaJgwFa3Gr2KZxxFqKhJwojDCbUlwK0cmIe8LW3KL4+I3HIXuZH/inOLF9oR+sItw3yQvPY7jJMkLhonUgWY4of/B61wHOpNixqyUYoBbzhqVaWHINnUUu1DdxQsL5CprV2ClvdNSWIa3gDX2uB69vbkdiCXM4nj/vZrobnsjWJDB+NSBdxlPOaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CmPkmYqU6S/w4DNuMfccOzmIVcRK9UkjmIMlqvpPd4g=;
 b=dqRoO0voxFu9F9hyCWCIvyaQdBXYTjN+ZCpAY/rrgmEb7XMyp4LUnKn773Wl1i7jRmrfq9cKrmk6Fvk2Czc+Un1yRlBf6/gAByGh/Bhh65RZW6QNsa942XCG65MwGv88GZ3Q6WA3qr2Mtdux5l2hPtiFJpAbf4KeNEh1KA1c79oackbV8wyx/SsiB72UWTluaKKhKOwQHqGCkxNan4/v3AAytIiPDHPXc32ANfwDD2aXY9wxLM+eWibDwnCP4FDyAWxOhFwenTcQr+vEl92Dxw5FRn/0ly0LLj7v89u7Sd61BHCjyxRDA96rZxpHW27qDz18G+uo7Stfchvtba5bnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CmPkmYqU6S/w4DNuMfccOzmIVcRK9UkjmIMlqvpPd4g=;
 b=tr2/k4gFpqqkLH70il1XYLhBqYENgQzbH9RAPgfdehgXCVq3sORC4lp7lJzKHUQJWyADyqaSoe9BHWTWTsSDOMKh9BqbyvLpK9byA4AydO85pwyj46QEhJNLs5MXg0Tz/cWQE7VvA+SwsHBSg8snBvhI8mLm6M3AjK0heossSGIOL+2u8KzAcHCjB+s+Xio95fN1zcDOcbxYmV3UOSsaPs4v9W8IP+QQeHCQ6hEvk3bNrCSAiTLEgOXXj9QsU3iB6xZ6p7ZQk+gbBLPq6IVwIezzXzKD8OzAwCPXb5uTnP0bReNwougSr3rvtEew0hfnJlsZhzJGxa24nlsO8UEenQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by PH0PR12MB8128.namprd12.prod.outlook.com (2603:10b6:510:294::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Sat, 10 Dec
 2022 14:58:31 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5880.014; Sat, 10 Dec 2022
 14:58:31 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 11/14] bridge: mcast: Allow user space to specify MDB entry routing protocol
Date:   Sat, 10 Dec 2022 16:56:30 +0200
Message-Id: <20221210145633.1328511-12-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221210145633.1328511-1-idosch@nvidia.com>
References: <20221210145633.1328511-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0802CA0012.eurprd08.prod.outlook.com
 (2603:10a6:800:aa::22) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|PH0PR12MB8128:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e524bc3-76d9-489c-ba44-08dadabf010a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lGm6vo81hoTMqZa50NUj7dcPuo8oSxpo3Hz9ApCLoEFtA0RsCk71Jy6kJZDFDdla0WceM/uI2/RNKs/zaCvwte8Hr3yRxaqmcopBOiUbcrm+gc7hpmIMrQ8e55J12m8drhEvRDc/wAc/Y/DuksDNFrNcnIeg4YmEYE6ufopgckMemRfFfhyBeHljXUtY6v5Tbr7M1jXRaeyLaicVILMY47DEkUEjrZdb8zMnyITGLpFMBRrpwsMlyGh38NEZ6KtIKQWgevbPP9b3kDtVgRhH3S7FfDkbK+s7ioX4z2VI1gEn1IIEY9gamrdDUBdInQ4T2F76W8d5E0v/XWt+QV3kl4mKaoFAFbuIb+tYCAAxsrTr//uDJc7YKFXR7C0uOEBK77jg6gxhGZ3cUcfNYPr3eZD9LxlELfjA+Z29SCW0GGWJkedViK9lnpoEZng00AZS1vkBoo7nomfFNP4b+niWvJB//F1+cc6vSjIYyadSgXng932+A2BmdUY5u9NyqBryflFlDq5RDNAZNYyjdCCbMQ0VhV87Z678U8SJuj0pxSRxW+Nj2PXCGKTHVlw/J8LF3SU9koGVWNtwpnQ4V8B4zkiTP0l7q1xkwhhm2ltbu1+/H0Vp827zW0M/zhClKyqgQEawSpDOsnKhZ0MUaGGTuQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(366004)(136003)(396003)(39860400002)(451199015)(36756003)(86362001)(38100700002)(83380400001)(1076003)(2616005)(6486002)(26005)(6512007)(186003)(478600001)(107886003)(6506007)(316002)(41300700001)(4326008)(8676002)(8936002)(5660300002)(2906002)(66946007)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uZAFknEZRxYZjrD1hqt7bGRwgJVNG8vYv7OpkRMNxJZn33d65JAkMoBhSvP5?=
 =?us-ascii?Q?aW9DVmBi5vs5oOzPDGO5qK6hVdKZIjt5XSZVeNROI1x8iwOStp0y6VCE/LYu?=
 =?us-ascii?Q?jAszD1AVrbubWpDPO4aToEMbBa2niiHhJuSbk21xNifKjqv520BVe57MjrhX?=
 =?us-ascii?Q?A0AJ7XSSQbnopVVi7VEtVYOg2Fjew6p+jmIIv9FwN29JR59H+MnwbiPC5af3?=
 =?us-ascii?Q?Tlow00OpNE0eCJ3/eu8pTcqv3Kw2/z/wZf6G9F4dw8CLnlBNE6azlBu8qnf/?=
 =?us-ascii?Q?Mqx3y6Xh2wulQlhAtj719+HkCw3RDAxG9peWnkeT+wvIXEgtqVHHHpBXqUFP?=
 =?us-ascii?Q?xSoFerFFAHTSiF6iLH5vQIqhdjW6ssDZTCeUAFEsPfVQxHF+j06srQkyQuUN?=
 =?us-ascii?Q?YnHr3/XlYok6815p75tzLIK3n5DTK6dRGc/TwrEc826uJeYU+52bFBlJKuS2?=
 =?us-ascii?Q?q8xdRE9kLYtFHNt5dUl0fHYAwwuv2byc0kRi7oCejx+GSNJiQtKikdVBZARV?=
 =?us-ascii?Q?PxShl5SDzYcgGvHSi4R5diAQdN9qiYYemhPAwNgfZbOomiPhmJQU4oQp9iqV?=
 =?us-ascii?Q?zU+3h8bdQbsOhZ1opjD1IzNNYv7KExFBpFXKbsHRieSXWd3gIlIDCiif3v3J?=
 =?us-ascii?Q?ycN/boI+7gazuPcXbwduHrTEotDh3LpCzKBCyzH2PMXvcyGZiH22PPXMa4MS?=
 =?us-ascii?Q?BcenKQ59ccx1n76G/8CKjboeovkC1ynREozRzt/uOwcc9Co0UY8sSP8D365c?=
 =?us-ascii?Q?WjsrsrHZxJsyzfqAagdNimTW3bMYo3klJ3Xiwi2eB+eKLGq2L1hUlWPA705w?=
 =?us-ascii?Q?N12FqmEG9ZCdEG8HwMO5kYwnGiMA34OW0kKRvFdJUebcKl0GfgfW7j+gFQm3?=
 =?us-ascii?Q?nwBNGx99Y3dkLOmjGQasBR9lxeb+rGgkjVuLS9V3znBuwkQIGFUWbBcxOavM?=
 =?us-ascii?Q?H4XBO5Lx7sMbADB/ron29wmYjaUoths8KVDhdIo7lGGVB8o0oX30dIxy4Kj+?=
 =?us-ascii?Q?JLQ1abVf6i1NmWuS4INq2EWaebhkSw8aWoxAy1FW7Z3g+xYaUvDB2rpp1fyE?=
 =?us-ascii?Q?yV8jHu0TvMusmv6Sp/lpSUV+irkgfKCG/61OlLJaiTQ1XvLpg35iJp062jvQ?=
 =?us-ascii?Q?GAQbGG1JBeQi4yWLRXDzaityfk5ujdM4XUfEnfiKEuFdnrxvpGdtIiBdH/YS?=
 =?us-ascii?Q?npKKDHmEqYsd7CewkLomq70mgV4kN1meJXAuYBAAXLOaLc5gQwzNSqj+RN1G?=
 =?us-ascii?Q?sOGMPeRPLIplKwInfEw7uQVSvY263wy9t5tzq2GecaykEPS/7w5B6bf5Zqg0?=
 =?us-ascii?Q?TFJhB5mE9Mco5bF+sdm6VDlqN5tFn6fdPWZJPTpODuOGqNhO/ra2uz24CZib?=
 =?us-ascii?Q?cvBmNPiE2O8b65ct1/UzOeFZ95+DlvDg/ozVkuxKr7j41Traw5zkqX7rF78Y?=
 =?us-ascii?Q?UkzizipTKpi1F1ow56q8fa4YfS5BQxQzd31q+QsUS/xbzfNAnL5RVAMIF/s4?=
 =?us-ascii?Q?tcrPU/Mxmtv0S1aoT/ZA+YwOGde5x54tJQI9KzObiYw+ryKWBPF/Dnz1oupR?=
 =?us-ascii?Q?psZSNB0C9H/VLUQkJdWaP6En0g58iccuDnRxEARw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e524bc3-76d9-489c-ba44-08dadabf010a
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2022 14:58:31.8216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 37gprxUd5m4T9zhmRVAaoqKx5aSnUPDROjIbdpMoQE8Us0pNz10+pnb1JOZ+j8VhoFbKxfYYq25s21wejHt1cA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8128
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the 'MDBE_ATTR_RTPORT' attribute to allow user space to specify the
routing protocol of the MDB port group entry. Enforce a minimum value of
'RTPROT_STATIC' to prevent user space from using protocol values that
should only be set by the kernel (e.g., 'RTPROT_KERNEL'). Maintain
backward compatibility by defaulting to 'RTPROT_STATIC'.

The protocol is already visible to user space in RTM_NEWMDB responses
and notifications via the 'MDBA_MDB_EATTR_RTPROT' attribute.

The routing protocol allows a routing daemon to distinguish between
entries configured by it and those configured by the administrator. Once
MDB flush is supported, the protocol can be used as a criterion
according to which the flush is performed.

Examples:

 # bridge mdb add dev br0 port dummy10 grp 239.1.1.1 permanent proto kernel
 Error: integer out of range.

 # bridge mdb add dev br0 port dummy10 grp 239.1.1.1 permanent proto static

 # bridge mdb add dev br0 port dummy10 grp 239.1.1.1 src 192.0.2.1 permanent proto zebra

 # bridge mdb add dev br0 port dummy10 grp 239.1.1.2 permanent source_list 198.51.100.1,198.51.100.2 filter_mode include proto 250

 # bridge -d mdb show
 dev br0 port dummy10 grp 239.1.1.2 src 198.51.100.2 permanent filter_mode include proto 250
 dev br0 port dummy10 grp 239.1.1.2 src 198.51.100.1 permanent filter_mode include proto 250
 dev br0 port dummy10 grp 239.1.1.2 permanent filter_mode include source_list 198.51.100.2/0.00,198.51.100.1/0.00 proto 250
 dev br0 port dummy10 grp 239.1.1.1 src 192.0.2.1 permanent filter_mode include proto zebra
 dev br0 port dummy10 grp 239.1.1.1 permanent filter_mode exclude proto static

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
---

Notes:
    v1:
    * Reject protocol for host entries.

 include/uapi/linux/if_bridge.h |  1 +
 net/bridge/br_mdb.c            | 15 +++++++++++++--
 net/bridge/br_private.h        |  1 +
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 0d9fe73fc48c..d9de241d90f9 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -725,6 +725,7 @@ enum {
 	MDBE_ATTR_SOURCE,
 	MDBE_ATTR_SRC_LIST,
 	MDBE_ATTR_GROUP_MODE,
+	MDBE_ATTR_RTPROT,
 	__MDBE_ATTR_MAX,
 };
 #define MDBE_ATTR_MAX (__MDBE_ATTR_MAX - 1)
diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 61d46b0a31b6..72d4e53193e5 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -682,6 +682,7 @@ static const struct nla_policy br_mdbe_attrs_pol[MDBE_ATTR_MAX + 1] = {
 	[MDBE_ATTR_GROUP_MODE] = NLA_POLICY_RANGE(NLA_U8, MCAST_EXCLUDE,
 						  MCAST_INCLUDE),
 	[MDBE_ATTR_SRC_LIST] = NLA_POLICY_NESTED(br_mdbe_src_list_pol),
+	[MDBE_ATTR_RTPROT] = NLA_POLICY_MIN(NLA_U8, RTPROT_STATIC),
 };
 
 static bool is_valid_mdb_entry(struct br_mdb_entry *entry,
@@ -823,7 +824,7 @@ static int br_mdb_add_group_sg(const struct br_mdb_config *cfg,
 	}
 
 	p = br_multicast_new_port_group(cfg->p, &cfg->group, *pp, flags, NULL,
-					MCAST_INCLUDE, RTPROT_STATIC);
+					MCAST_INCLUDE, cfg->rt_protocol);
 	if (unlikely(!p)) {
 		NL_SET_ERR_MSG_MOD(extack, "Couldn't allocate new (S, G) port group");
 		return -ENOMEM;
@@ -881,6 +882,7 @@ static int br_mdb_add_group_src_fwd(const struct br_mdb_config *cfg,
 	sg_cfg.group = sg_ip;
 	sg_cfg.src_entry = true;
 	sg_cfg.filter_mode = MCAST_INCLUDE;
+	sg_cfg.rt_protocol = cfg->rt_protocol;
 	return br_mdb_add_group_sg(&sg_cfg, sgmp, brmctx, flags, extack);
 }
 
@@ -982,7 +984,7 @@ static int br_mdb_add_group_star_g(const struct br_mdb_config *cfg,
 	}
 
 	p = br_multicast_new_port_group(cfg->p, &cfg->group, *pp, flags, NULL,
-					cfg->filter_mode, RTPROT_STATIC);
+					cfg->filter_mode, cfg->rt_protocol);
 	if (unlikely(!p)) {
 		NL_SET_ERR_MSG_MOD(extack, "Couldn't allocate new (*, G) port group");
 		return -ENOMEM;
@@ -1193,6 +1195,14 @@ static int br_mdb_config_attrs_init(struct nlattr *set_attrs,
 		return -EINVAL;
 	}
 
+	if (mdb_attrs[MDBE_ATTR_RTPROT]) {
+		if (!cfg->p) {
+			NL_SET_ERR_MSG_MOD(extack, "Protocol cannot be set for host groups");
+			return -EINVAL;
+		}
+		cfg->rt_protocol = nla_get_u8(mdb_attrs[MDBE_ATTR_RTPROT]);
+	}
+
 	return 0;
 }
 
@@ -1212,6 +1222,7 @@ static int br_mdb_config_init(struct net *net, const struct nlmsghdr *nlh,
 
 	memset(cfg, 0, sizeof(*cfg));
 	cfg->filter_mode = MCAST_EXCLUDE;
+	cfg->rt_protocol = RTPROT_STATIC;
 
 	bpm = nlmsg_data(nlh);
 	if (!bpm->ifindex) {
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 368f5f6fa42b..cdc9e040f1f6 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -106,6 +106,7 @@ struct br_mdb_config {
 	u8				filter_mode;
 	struct br_mdb_src_entry		*src_entries;
 	int				num_src_entries;
+	u8				rt_protocol;
 };
 #endif
 
-- 
2.37.3

