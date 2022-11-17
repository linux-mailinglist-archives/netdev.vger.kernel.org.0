Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 117A762DC87
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 14:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239410AbiKQNVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 08:21:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239952AbiKQNVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 08:21:33 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2093.outbound.protection.outlook.com [40.107.101.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F6F6E541
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 05:21:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C8cCqxKhdn5HJC09/yd5CrYBrfk/yz+dPWWOQzJjdGcazgA2xC2rKEte7U1jH51lapjUkl1k6KgjdTUpVDfg6lp4FEmLe6muARSZxz6/K9ijB8pSb2ldED5iVKseAiDzQDWiVzSkC9Id/hS8+0Rj9i57aRbI74jIHZGnzxtf29CgPXRAZCOUpBnARKy+idZ1g3r4pvkvLXUUZpc4Ns/5zkesgyhaRgsdNCxomjskUfqlC3Ll8h+uzI9/2iJjBTisSl7SJZk/JiTeGNGPBymY8/QFxN+/1jNL6LDGFxi7KxHyVX41GDW9sl1LKYtq03GwHYJqFTB9t2g+dfB4QwIWCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f+sUtkE8JS2lys7jFxil3Lby4hDJuR3qfJtoQmrTN1Q=;
 b=G8PUjqeduCaq/VXeZFKt4CXKSv3yerfZuW3fPPs8cNzmItHMXmQ8m1I+sp/8QnqF8ryNWv27/PQXEqqXnATTbWXKjNMt9zMd9mRsmJYr0p9ckoJxfg6mCZc4sJEryd1PB4R4Fe+3wHyYIfXUTSi9J93YKDJGUlRuv6WOI+jQb0Qq7w/HLvSZhVJ2iMcamn5H7jYEIEbTXcHRnFwORrZDk8Orxc5XPOT97M77Yw4oCJr4mbHwbGiUVcqyBYrBYWu/N2E+wdnAX7l5VGz5MFjJDeXyEc7BQcPRQUVIrMl3+SpM4QURZUsPlsETNrR2i/mADlYrwPIk8SFRHib6bQ80Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f+sUtkE8JS2lys7jFxil3Lby4hDJuR3qfJtoQmrTN1Q=;
 b=QysXlLSWuovmMUDGleh1m+8NzURse5LkPpYtz1yOVzZJ9jAOTMyL178WaS8duao1z5dH8PdnW5dXObbjXAZTu41j3hngmlH2xG4ykR0mwcwTgqPsu/xuBeuxosksA/PJATyr79lM3UVDRn1so5BmbS3RpeRQ6sMxXBSWntJJwNE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW4PR13MB5839.namprd13.prod.outlook.com (2603:10b6:303:1a7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.20; Thu, 17 Nov
 2022 13:21:26 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30%8]) with mapi id 15.20.5813.018; Thu, 17 Nov 2022
 13:21:26 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Leon Romanovsky <leon@kernel.org>,
        Chentian Liu <chengtian.liu@corigine.com>,
        Huanhuan Wang <huanhuan.wang@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: [PATCH net-next v4 3/3] nfp: implement xfrm callbacks and expose ipsec offload feature to upper layer
Date:   Thu, 17 Nov 2022 14:21:02 +0100
Message-Id: <20221117132102.678708-4-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221117132102.678708-1-simon.horman@corigine.com>
References: <20221117132102.678708-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0101.eurprd03.prod.outlook.com
 (2603:10a6:208:69::42) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW4PR13MB5839:EE_
X-MS-Office365-Filtering-Correlation-Id: c2108a6a-12d5-4bd3-7cba-08dac89ea13f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: htRUf5x+DQy6R0dBbim9d9Jmqr5iC242mqGnYugpZxryapL1uno+D2IvIU5F+iVrSoKeMXZmH87TWmWaiy8WEYSsJxa6kkMyCjspoVejm21q/41EioHS3JwX5oqeAf15lfMWSaAK0haTUkiRUh/2/Quzr+WCrEkeRW/1YZXFBcbXeWDpB+yyryAcO/HbjEo8Nuk61WvDdgRHf9+PVjr09H209GbhAASPMuBKGm6dnxjp+Q9WsqxKOhJNjyYfJSP+KV5s3HUdZOs2+lc1jjjAjrDZYgyxsEx+W2DhTglkkjiiEXQQWL8Jx18xFw+hwtToQCOMFIx6H6wWA7/wtse4teQIdyQCxsU5X1SBl8hTNoAYY36wq4DCgURyaIziNpwDznsQutaUeP3hvi9cDZdGpxzkrvlgWim9AwNgjOCekZRw0NtBvjuQk2fa2Vkhz+SiaPmm7/yvuvhS+wNOYAoOQZ5/zkXeA42JsLkryk15Yq9Eg+N+CckZdnM92LFN/QYcfucuFTgLO73EYxAYEk4zoRdfo494gt2qx9fe8j01TskAJZVwhKKU46nQvOArktbJ0J4XTIPXX/CHP0WUFfntwX0Di49pdiKKHKj+ZZL3PpbSz6TV24rBgCPpnpvIkfAhSTbHFYAu8LXHEryfWgKWRWDmEWH//X7aGPlwh7NZxGxrxsV/7ptH2tTImrW06oc6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(136003)(376002)(366004)(39840400004)(451199015)(86362001)(54906003)(66946007)(110136005)(30864003)(5660300002)(41300700001)(316002)(8936002)(2906002)(38100700002)(6486002)(478600001)(83380400001)(6506007)(52116002)(44832011)(107886003)(6666004)(1076003)(186003)(36756003)(2616005)(4326008)(66556008)(66476007)(8676002)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XuoFITcZx/m47gb/dMnI9YJMsaK1AOFip3eRzNWSMujKCRPH9Z0mz0QkXIbI?=
 =?us-ascii?Q?A8JiRLpN9eBt2jqVCxOj+NJTwsGWFXGtBQNZgzGwWOUrWaB9zo72YmE/bwWX?=
 =?us-ascii?Q?MFW7rQZN2qAOG9ee20ZvZNRarkqgMxy/Vgvbip6fpWA5P4rDN0EGqHI2Uv/t?=
 =?us-ascii?Q?qclUw8QRH1LmYBGkdFhc+CUPJw1vwwnX/xr+bLHDVL4qoQkEUFl00lWt3C8Q?=
 =?us-ascii?Q?j8p/08tKr4AFeViKoCptyoC0mrY8cFP8s4D4HUTUzu9HrGk5gF75zyeZgzA2?=
 =?us-ascii?Q?hspqMXGIC7JSDaLIZSviTwJmUbCGcx4nCtbmcDK/Qho5KO1utcGxO2gMfIbC?=
 =?us-ascii?Q?xIew08K674iw/7QjVdWAzGxsld8WLR49/p246uGTT84ea8+KYr7GWhEdB6j5?=
 =?us-ascii?Q?UIEN1VPBOVgZ5ledJSxH5BCMvHYX8UIQjtpUNQTjXcEFGUHdreinEJ5kTXVZ?=
 =?us-ascii?Q?WzyFyFS93WVT6ilMLSS94OmnqHlJB+CbdtSqxN/yzcPExdoKDw7bszcTdbdN?=
 =?us-ascii?Q?w0TBQXNaFVDp2/joAFpk9LMQWywGXThycCBElk9B7e5c5JDbymGoUlCvcKOn?=
 =?us-ascii?Q?ZdfH0rqGMYoNaiKC5UBRcSzoarKKIAmpVJ5OHsdnlHoAhiuBb3Q6iNQ0+XcR?=
 =?us-ascii?Q?iXWyEwXZ/f/VcMah5KlUuQK8QbbA/+Fx1XGhKZpZvy1IEra/R5yMBX0n+sD7?=
 =?us-ascii?Q?yxHQ6BMowl/h0euZJpKG/FH06in/ArIFBsn7UDoazAez2w8AqdaZDILfDMYx?=
 =?us-ascii?Q?rcofj1TvfkC0ddsm4fTgK0HJdUG+kyGw939cogLzvaY+n99cHjAU3BsWgXMM?=
 =?us-ascii?Q?71bASTBHDyHOBPWdmj931+qNYKugNXnHHSwPbgBmzH5LHRdpcdO9z6HhdrXZ?=
 =?us-ascii?Q?Wjxhef5gksCkhNwbCOQgRiyub7SFhyFb1NCI88lSzbLWkEPmXMQ4ZVKXVpng?=
 =?us-ascii?Q?MyiTIXMI8MSUyJe0UO9XTN2xpP3HZd3Ep3VGdGOGD1+NUhcobIinzV/9Fsj3?=
 =?us-ascii?Q?dpTSt7+zqZfVe+7aYb9j3Fs1U+KzGUJnesRW6JjatDNXnT9vWYw1lAYF7+fu?=
 =?us-ascii?Q?M0SiR6LO1r8VDCUW+KDm3c7OA9jtEVqec6k0W0xbPu/u2yBlNlEDa4jIO19e?=
 =?us-ascii?Q?KAHtOPvMMpy5zg4cmr0uGeC64mdECYqiyMxUOTCNEq1mldH6jWy0nbtqQBYq?=
 =?us-ascii?Q?7ULgwznrimr35vMZlA7TyhC2Fgvd85asxih61kuwhNhC54K3HuJEn8od6LaX?=
 =?us-ascii?Q?GIC4W5kEtV5yTsWr5Qd9Eo1U38nBoqYXuMtHc0IH8UYKF+1JhWW5PBd/XD0l?=
 =?us-ascii?Q?zJFkABrd5NXZkMIgKBWBS4+KDHwM5QT7FXJcNYkEe5kg4kECoZk5Pt14KXCB?=
 =?us-ascii?Q?il3Vep3z/jiDPTv9mw7LgV5xu+6OfdPir14ODiXbD/Gr0n8LuUzQxd+adVw5?=
 =?us-ascii?Q?l6lFr5Y1SnC1l46msmB3gzB56QTKOSZLRbQUt25zhhu/gH8IL11H1P16h/oe?=
 =?us-ascii?Q?3OpApvI1msTXVLOip2y10WXTgI0TzXvnlEq9RJSEkEYWBsjxtGmzzozGZnBX?=
 =?us-ascii?Q?MLf2ZFbA+kypNOMvg8OJaZfcys/toE1o7FQt4HckQYi37opaRz1PryOxR6+O?=
 =?us-ascii?Q?jGZDBqbfyOJW6hs55zPjRIitSiOkc7XIxO9ZVLrrVO/vPjUSNxPHzzCxbbsW?=
 =?us-ascii?Q?U/m7+Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2108a6a-12d5-4bd3-7cba-08dac89ea13f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2022 13:21:26.4682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ju7Cn0aUpOq7MCZukkUFBiI0RCS2xjC3GJZGpscSsujmpfC2tVzNjYzOvCSygNCnCNei5NRmynhqcNM6Xms3etP4XA7/GBEz2lKY939vod0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR13MB5839
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huanhuan Wang <huanhuan.wang@corigine.com>

Xfrm callbacks are implemented to offload SA info into firmware
by mailbox. It supports 16K SA info in total.

Expose ipsec offload feature to upper layer, this feature will
signal the availability of the offload.

Based on initial work of Norm Bagley <norman.bagley@netronome.com>.

Signed-off-by: Huanhuan Wang <huanhuan.wang@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 .../net/ethernet/netronome/nfp/crypto/ipsec.c | 484 +++++++++++++++++-
 .../ethernet/netronome/nfp/nfp_net_common.c   |   6 +
 .../net/ethernet/netronome/nfp/nfp_net_ctrl.h |   4 +-
 3 files changed, 490 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c b/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
index 154ef841e847..3728870d8e9c 100644
--- a/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
+++ b/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
@@ -16,18 +16,498 @@
 
 #define NFP_NET_IPSEC_MAX_SA_CNT  (16 * 1024) /* Firmware support a maximum of 16K SA offload */
 
+/* IPsec config message cmd codes */
+enum nfp_ipsec_cfg_mssg_cmd_codes {
+	NFP_IPSEC_CFG_MSSG_ADD_SA,	 /* Add a new SA */
+	NFP_IPSEC_CFG_MSSG_INV_SA	 /* Invalidate an existing SA */
+};
+
+/* IPsec config message response codes */
+enum nfp_ipsec_cfg_mssg_rsp_codes {
+	NFP_IPSEC_CFG_MSSG_OK,
+	NFP_IPSEC_CFG_MSSG_FAILED,
+	NFP_IPSEC_CFG_MSSG_SA_VALID,
+	NFP_IPSEC_CFG_MSSG_SA_HASH_ADD_FAILED,
+	NFP_IPSEC_CFG_MSSG_SA_HASH_DEL_FAILED,
+	NFP_IPSEC_CFG_MSSG_SA_INVALID_CMD
+};
+
+/* Protocol */
+enum nfp_ipsec_sa_prot {
+	NFP_IPSEC_PROTOCOL_AH = 0,
+	NFP_IPSEC_PROTOCOL_ESP = 1
+};
+
+/* Mode */
+enum nfp_ipsec_sa_mode {
+	NFP_IPSEC_PROTMODE_TRANSPORT = 0,
+	NFP_IPSEC_PROTMODE_TUNNEL = 1
+};
+
+/* Cipher types */
+enum nfp_ipsec_sa_cipher {
+	NFP_IPSEC_CIPHER_NULL,
+	NFP_IPSEC_CIPHER_3DES,
+	NFP_IPSEC_CIPHER_AES128,
+	NFP_IPSEC_CIPHER_AES192,
+	NFP_IPSEC_CIPHER_AES256,
+	NFP_IPSEC_CIPHER_AES128_NULL,
+	NFP_IPSEC_CIPHER_AES192_NULL,
+	NFP_IPSEC_CIPHER_AES256_NULL,
+	NFP_IPSEC_CIPHER_CHACHA20
+};
+
+/* Cipher modes */
+enum nfp_ipsec_sa_cipher_mode {
+	NFP_IPSEC_CIMODE_ECB,
+	NFP_IPSEC_CIMODE_CBC,
+	NFP_IPSEC_CIMODE_CFB,
+	NFP_IPSEC_CIMODE_OFB,
+	NFP_IPSEC_CIMODE_CTR
+};
+
+/* Hash types */
+enum nfp_ipsec_sa_hash_type {
+	NFP_IPSEC_HASH_NONE,
+	NFP_IPSEC_HASH_MD5_96,
+	NFP_IPSEC_HASH_SHA1_96,
+	NFP_IPSEC_HASH_SHA256_96,
+	NFP_IPSEC_HASH_SHA384_96,
+	NFP_IPSEC_HASH_SHA512_96,
+	NFP_IPSEC_HASH_MD5_128,
+	NFP_IPSEC_HASH_SHA1_80,
+	NFP_IPSEC_HASH_SHA256_128,
+	NFP_IPSEC_HASH_SHA384_192,
+	NFP_IPSEC_HASH_SHA512_256,
+	NFP_IPSEC_HASH_GF128_128,
+	NFP_IPSEC_HASH_POLY1305_128
+};
+
+/* IPSEC_CFG_MSSG_ADD_SA */
+struct nfp_ipsec_cfg_add_sa {
+	u32 ciph_key[8];		  /* Cipher Key */
+	union {
+		u32 auth_key[16];	  /* Authentication Key */
+		struct nfp_ipsec_aesgcm { /* AES-GCM-ESP fields */
+			u32 salt;	  /* Initialized with SA */
+			u32 resv[15];
+		} aesgcm_fields;
+	};
+	struct sa_ctrl_word {
+		uint32_t hash   :4;	  /* From nfp_ipsec_sa_hash_type */
+		uint32_t cimode :4;	  /* From nfp_ipsec_sa_cipher_mode */
+		uint32_t cipher :4;	  /* From nfp_ipsec_sa_cipher */
+		uint32_t mode   :2;	  /* From nfp_ipsec_sa_mode */
+		uint32_t proto  :2;	  /* From nfp_ipsec_sa_prot */
+		uint32_t dir :1;	  /* SA direction */
+		uint32_t resv0 :12;
+		uint32_t encap_dsbl:1;	  /* Encap/Decap disable */
+		uint32_t resv1 :2;	  /* Must be set to 0 */
+	} ctrl_word;
+	u32 spi;			  /* SPI Value */
+	uint32_t pmtu_limit :16;          /* PMTU Limit */
+	uint32_t resv0 :5;
+	uint32_t ipv6       :1;		  /* Outbound IPv6 addr format */
+	uint32_t resv1	 :10;
+	u32 resv2[2];
+	u32 src_ip[4];			  /* Src IP addr */
+	u32 dst_ip[4];			  /* Dst IP addr */
+	u32 resv3[6];
+};
+
+/* IPSEC_CFG_MSSG */
+struct nfp_ipsec_cfg_mssg {
+	union {
+		struct{
+			uint32_t cmd:16;     /* One of nfp_ipsec_cfg_mssg_cmd_codes */
+			uint32_t rsp:16;     /* One of nfp_ipsec_cfg_mssg_rsp_codes */
+			uint32_t sa_idx:16;  /* SA table index */
+			uint32_t spare0:16;
+			struct nfp_ipsec_cfg_add_sa cfg_add_sa;
+		};
+		u32 raw[64];
+	};
+};
+
+static int nfp_ipsec_cfg_cmd_issue(struct nfp_net *nn, int type, int saidx,
+				   struct nfp_ipsec_cfg_mssg *msg)
+{
+	int i, msg_size, ret;
+
+	msg->cmd = type;
+	msg->sa_idx = saidx;
+	msg->rsp = 0;
+	msg_size = ARRAY_SIZE(msg->raw);
+
+	for (i = 0; i < msg_size; i++)
+		nn_writel(nn, NFP_NET_CFG_MBOX_VAL + 4 * i, msg->raw[i]);
+
+	ret = nfp_net_mbox_reconfig(nn, NFP_NET_CFG_MBOX_CMD_IPSEC);
+	if (ret < 0)
+		return ret;
+
+	/* For now we always read the whole message response back */
+	for (i = 0; i < msg_size; i++)
+		msg->raw[i] = nn_readl(nn, NFP_NET_CFG_MBOX_VAL + 4 * i);
+
+	switch (msg->rsp) {
+	case NFP_IPSEC_CFG_MSSG_OK:
+		return 0;
+	case NFP_IPSEC_CFG_MSSG_SA_INVALID_CMD:
+		return -EINVAL;
+	case NFP_IPSEC_CFG_MSSG_SA_VALID:
+		return -EEXIST;
+	case NFP_IPSEC_CFG_MSSG_FAILED:
+	case NFP_IPSEC_CFG_MSSG_SA_HASH_ADD_FAILED:
+	case NFP_IPSEC_CFG_MSSG_SA_HASH_DEL_FAILED:
+		return -EIO;
+	default:
+		return -EINVAL;
+	}
+}
+
+static int set_aes_keylen(struct nfp_ipsec_cfg_add_sa *cfg, int alg, int keylen)
+{
+	bool aes_gmac = (alg == SADB_X_EALG_NULL_AES_GMAC);
+
+	switch (keylen) {
+	case 128:
+		cfg->ctrl_word.cipher = aes_gmac ? NFP_IPSEC_CIPHER_AES128_NULL :
+						   NFP_IPSEC_CIPHER_AES128;
+		break;
+	case 192:
+		cfg->ctrl_word.cipher = aes_gmac ? NFP_IPSEC_CIPHER_AES192_NULL :
+						   NFP_IPSEC_CIPHER_AES192;
+		break;
+	case 256:
+		cfg->ctrl_word.cipher = aes_gmac ? NFP_IPSEC_CIPHER_AES256_NULL :
+						   NFP_IPSEC_CIPHER_AES256;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void set_md5hmac(struct nfp_ipsec_cfg_add_sa *cfg, int *trunc_len)
+{
+	switch (*trunc_len) {
+	case 96:
+		cfg->ctrl_word.hash = NFP_IPSEC_HASH_MD5_96;
+		break;
+	case 128:
+		cfg->ctrl_word.hash = NFP_IPSEC_HASH_MD5_128;
+		break;
+	default:
+		*trunc_len = 0;
+	}
+}
+
+static void set_sha1hmac(struct nfp_ipsec_cfg_add_sa *cfg, int *trunc_len)
+{
+	switch (*trunc_len) {
+	case 96:
+		cfg->ctrl_word.hash = NFP_IPSEC_HASH_SHA1_96;
+		break;
+	case 80:
+		cfg->ctrl_word.hash = NFP_IPSEC_HASH_SHA1_80;
+		break;
+	default:
+		*trunc_len = 0;
+	}
+}
+
+static void set_sha2_256hmac(struct nfp_ipsec_cfg_add_sa *cfg, int *trunc_len)
+{
+	switch (*trunc_len) {
+	case 96:
+		cfg->ctrl_word.hash = NFP_IPSEC_HASH_SHA256_96;
+		break;
+	case 128:
+		cfg->ctrl_word.hash = NFP_IPSEC_HASH_SHA256_128;
+		break;
+	default:
+		*trunc_len = 0;
+	}
+}
+
+static void set_sha2_384hmac(struct nfp_ipsec_cfg_add_sa *cfg, int *trunc_len)
+{
+	switch (*trunc_len) {
+	case 96:
+		cfg->ctrl_word.hash = NFP_IPSEC_HASH_SHA384_96;
+		break;
+	case 192:
+		cfg->ctrl_word.hash = NFP_IPSEC_HASH_SHA384_192;
+		break;
+	default:
+		*trunc_len = 0;
+	}
+}
+
+static void set_sha2_512hmac(struct nfp_ipsec_cfg_add_sa *cfg, int *trunc_len)
+{
+	switch (*trunc_len) {
+	case 96:
+		cfg->ctrl_word.hash = NFP_IPSEC_HASH_SHA512_96;
+		break;
+	case 256:
+		cfg->ctrl_word.hash = NFP_IPSEC_HASH_SHA512_256;
+		break;
+	default:
+		*trunc_len = 0;
+	}
+}
+
 static int nfp_net_xfrm_add_state(struct xfrm_state *x)
 {
-	return -EOPNOTSUPP;
+	struct net_device *netdev = x->xso.dev;
+	struct nfp_ipsec_cfg_mssg msg = {};
+	int i, key_len, trunc_len, err = 0;
+	struct nfp_ipsec_cfg_add_sa *cfg;
+	struct nfp_net *nn;
+	unsigned int saidx;
+
+	nn = netdev_priv(netdev);
+	cfg = &msg.cfg_add_sa;
+
+	/* General */
+	switch (x->props.mode) {
+	case XFRM_MODE_TUNNEL:
+		cfg->ctrl_word.mode = NFP_IPSEC_PROTMODE_TUNNEL;
+		break;
+	case XFRM_MODE_TRANSPORT:
+		cfg->ctrl_word.mode = NFP_IPSEC_PROTMODE_TRANSPORT;
+		break;
+	default:
+		nn_err(nn, "Unsupported mode for xfrm offload\n");
+		return -EINVAL;
+	}
+
+	switch (x->id.proto) {
+	case IPPROTO_ESP:
+		cfg->ctrl_word.proto = NFP_IPSEC_PROTOCOL_ESP;
+		break;
+	case IPPROTO_AH:
+		cfg->ctrl_word.proto = NFP_IPSEC_PROTOCOL_AH;
+		break;
+	default:
+		nn_err(nn, "Unsupported protocol for xfrm offload\n");
+		return -EINVAL;
+	}
+
+	if (x->props.flags & XFRM_STATE_ESN) {
+		nn_err(nn, "Unsupported XFRM_REPLAY_MODE_ESN for xfrm offload\n");
+		return -EINVAL;
+	}
+
+	cfg->spi = ntohl(x->id.spi);
+
+	/* Hash/Authentication */
+	if (x->aalg)
+		trunc_len = x->aalg->alg_trunc_len;
+	else
+		trunc_len = 0;
+
+	switch (x->props.aalgo) {
+	case SADB_AALG_NONE:
+		if (x->aead) {
+			trunc_len = -1;
+		} else {
+			nn_err(nn, "Unsupported authentication algorithm\n");
+			return -EINVAL;
+		}
+		break;
+	case SADB_X_AALG_NULL:
+		cfg->ctrl_word.hash = NFP_IPSEC_HASH_NONE;
+		trunc_len = -1;
+		break;
+	case SADB_AALG_MD5HMAC:
+		set_md5hmac(cfg, &trunc_len);
+		break;
+	case SADB_AALG_SHA1HMAC:
+		set_sha1hmac(cfg, &trunc_len);
+		break;
+	case SADB_X_AALG_SHA2_256HMAC:
+		set_sha2_256hmac(cfg, &trunc_len);
+		break;
+	case SADB_X_AALG_SHA2_384HMAC:
+		set_sha2_384hmac(cfg, &trunc_len);
+		break;
+	case SADB_X_AALG_SHA2_512HMAC:
+		set_sha2_512hmac(cfg, &trunc_len);
+		break;
+	default:
+		nn_err(nn, "Unsupported authentication algorithm\n");
+		return -EINVAL;
+	}
+
+	if (!trunc_len) {
+		nn_err(nn, "Unsupported authentication algorithm trunc length\n");
+		return -EINVAL;
+	}
+
+	if (x->aalg) {
+		key_len = DIV_ROUND_UP(x->aalg->alg_key_len, BITS_PER_BYTE);
+		if (key_len > sizeof(cfg->auth_key)) {
+			nn_err(nn, "Insufficient space for offloaded auth key\n");
+			return -EINVAL;
+		}
+		for (i = 0; i < key_len / sizeof(cfg->auth_key[0]) ; i++)
+			cfg->auth_key[i] = get_unaligned_be32(x->aalg->alg_key +
+							      sizeof(cfg->auth_key[0]) * i);
+	}
+
+	/* Encryption */
+	switch (x->props.ealgo) {
+	case SADB_EALG_NONE:
+	case SADB_EALG_NULL:
+		cfg->ctrl_word.cimode = NFP_IPSEC_CIMODE_CBC;
+		cfg->ctrl_word.cipher = NFP_IPSEC_CIPHER_NULL;
+		break;
+	case SADB_EALG_3DESCBC:
+		cfg->ctrl_word.cimode = NFP_IPSEC_CIMODE_CBC;
+		cfg->ctrl_word.cipher = NFP_IPSEC_CIPHER_3DES;
+		break;
+	case SADB_X_EALG_AES_GCM_ICV16:
+	case SADB_X_EALG_NULL_AES_GMAC:
+		if (!x->aead) {
+			nn_err(nn, "Invalid AES key data\n");
+			return -EINVAL;
+		}
+
+		if (x->aead->alg_icv_len != 128) {
+			nn_err(nn, "ICV must be 128bit with SADB_X_EALG_AES_GCM_ICV16\n");
+			return -EINVAL;
+		}
+		cfg->ctrl_word.cimode = NFP_IPSEC_CIMODE_CTR;
+		cfg->ctrl_word.hash = NFP_IPSEC_HASH_GF128_128;
+
+		/* Aead->alg_key_len includes 32-bit salt */
+		if (set_aes_keylen(cfg, x->props.ealgo, x->aead->alg_key_len - 32)) {
+			nn_err(nn, "Unsupported AES key length %d\n", x->aead->alg_key_len);
+			return -EINVAL;
+		}
+		break;
+	case SADB_X_EALG_AESCBC:
+		cfg->ctrl_word.cimode = NFP_IPSEC_CIMODE_CBC;
+		if (!x->ealg) {
+			nn_err(nn, "Invalid AES key data\n");
+			return -EINVAL;
+		}
+		if (set_aes_keylen(cfg, x->props.ealgo, x->ealg->alg_key_len) < 0) {
+			nn_err(nn, "Unsupported AES key length %d\n", x->ealg->alg_key_len);
+			return -EINVAL;
+		}
+		break;
+	default:
+		nn_err(nn, "Unsupported encryption algorithm for offload\n");
+		return -EINVAL;
+	}
+
+	if (x->aead) {
+		int salt_len = 4;
+
+		key_len = DIV_ROUND_UP(x->aead->alg_key_len, BITS_PER_BYTE);
+		key_len -= salt_len;
+
+		if (key_len > sizeof(cfg->ciph_key)) {
+			nn_err(nn, "aead: Insufficient space for offloaded key\n");
+			return -EINVAL;
+		}
+
+		for (i = 0; i < key_len / sizeof(cfg->ciph_key[0]) ; i++)
+			cfg->ciph_key[i] = get_unaligned_be32(x->aead->alg_key +
+							      sizeof(cfg->ciph_key[0]) * i);
+
+		/* Load up the salt */
+		cfg->aesgcm_fields.salt = get_unaligned_be32(x->aead->alg_key + key_len);
+	}
+
+	if (x->ealg) {
+		key_len = DIV_ROUND_UP(x->ealg->alg_key_len, BITS_PER_BYTE);
+
+		if (key_len > sizeof(cfg->ciph_key)) {
+			nn_err(nn, "ealg: Insufficient space for offloaded key\n");
+			return -EINVAL;
+		}
+		for (i = 0; i < key_len / sizeof(cfg->ciph_key[0]) ; i++)
+			cfg->ciph_key[i] = get_unaligned_be32(x->ealg->alg_key +
+							      sizeof(cfg->ciph_key[0]) * i);
+	}
+
+	/* IP related info */
+	switch (x->props.family) {
+	case AF_INET:
+		cfg->ipv6 = 0;
+		cfg->src_ip[0] = ntohl(x->props.saddr.a4);
+		cfg->dst_ip[0] = ntohl(x->id.daddr.a4);
+		break;
+	case AF_INET6:
+		cfg->ipv6 = 1;
+		for (i = 0; i < 4; i++) {
+			cfg->src_ip[i] = ntohl(x->props.saddr.a6[i]);
+			cfg->dst_ip[i] = ntohl(x->id.daddr.a6[i]);
+		}
+		break;
+	default:
+		nn_err(nn, "Unsupported address family\n");
+		return -EINVAL;
+	}
+
+	/* Maximum nic IPsec code could handle. Other limits may apply. */
+	cfg->pmtu_limit = 0xffff;
+	cfg->ctrl_word.encap_dsbl = 1;
+
+	/* SA direction */
+	cfg->ctrl_word.dir = x->xso.dir;
+
+	/* Find unused SA data*/
+	err = xa_alloc(&nn->xa_ipsec, &saidx, x,
+		       XA_LIMIT(0, NFP_NET_IPSEC_MAX_SA_CNT - 1), GFP_KERNEL);
+	if (err < 0) {
+		nn_err(nn, "Unable to get sa_data number for IPsec\n");
+		return err;
+	}
+
+	/* Allocate saidx and commit the SA */
+	err = nfp_ipsec_cfg_cmd_issue(nn, NFP_IPSEC_CFG_MSSG_ADD_SA, saidx, &msg);
+	if (err) {
+		xa_erase(&nn->xa_ipsec, saidx);
+		nn_err(nn, "Failed to issue IPsec command err ret=%d\n", err);
+		return err;
+	}
+
+	/* 0 is invalid offload_handle for kernel */
+	x->xso.offload_handle = saidx + 1;
+	return 0;
 }
 
 static void nfp_net_xfrm_del_state(struct xfrm_state *x)
 {
+	struct net_device *netdev = x->xso.dev;
+	struct nfp_ipsec_cfg_mssg msg;
+	struct nfp_net *nn;
+	int err;
+
+	nn = netdev_priv(netdev);
+	err = nfp_ipsec_cfg_cmd_issue(nn, NFP_IPSEC_CFG_MSSG_INV_SA,
+				      x->xso.offload_handle - 1, &msg);
+	if (err)
+		nn_warn(nn, "Failed to invalidate SA in hardware\n");
+
+	xa_erase(&nn->xa_ipsec, x->xso.offload_handle - 1);
 }
 
 static bool nfp_net_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state *x)
 {
-	return false;
+	if (x->props.family == AF_INET)
+		/* Offload with IPv4 options is not supported yet */
+		return ip_hdr(skb)->ihl == 5;
+
+	/* Offload with IPv6 extension headers is not support yet */
+	return !(ipv6_ext_hdr(ipv6_hdr(skb)->nexthdr));
 }
 
 static const struct xfrmdev_ops nfp_net_ipsec_xfrmdev_ops = {
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 593df8f8ac8f..682a9198fb54 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -2371,6 +2371,12 @@ static void nfp_net_netdev_init(struct nfp_net *nn)
 	}
 	if (nn->cap & NFP_NET_CFG_CTRL_RSS_ANY)
 		netdev->hw_features |= NETIF_F_RXHASH;
+
+#ifdef CONFIG_NFP_NET_IPSEC
+	if (nn->cap_w1 & NFP_NET_CFG_CTRL_IPSEC)
+		netdev->hw_features |= NETIF_F_HW_ESP | NETIF_F_HW_ESP_TX_CSUM;
+#endif
+
 	if (nn->cap & NFP_NET_CFG_CTRL_VXLAN) {
 		if (nn->cap & NFP_NET_CFG_CTRL_LSO) {
 			netdev->hw_features |= NETIF_F_GSO_UDP_TUNNEL |
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
index 8f75efd9e463..cc11b3dc1252 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
@@ -402,14 +402,14 @@
  */
 #define NFP_NET_CFG_MBOX_BASE		0x1800
 #define NFP_NET_CFG_MBOX_VAL_MAX_SZ	0x1F8
-
+#define NFP_NET_CFG_MBOX_VAL		0x1808
 #define NFP_NET_CFG_MBOX_SIMPLE_CMD	0x0
 #define NFP_NET_CFG_MBOX_SIMPLE_RET	0x4
 #define NFP_NET_CFG_MBOX_SIMPLE_VAL	0x8
 
 #define NFP_NET_CFG_MBOX_CMD_CTAG_FILTER_ADD 1
 #define NFP_NET_CFG_MBOX_CMD_CTAG_FILTER_KILL 2
-
+#define NFP_NET_CFG_MBOX_CMD_IPSEC 3
 #define NFP_NET_CFG_MBOX_CMD_PCI_DSCP_PRIOMAP_SET	5
 #define NFP_NET_CFG_MBOX_CMD_TLV_CMSG			6
 
-- 
2.30.2

