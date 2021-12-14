Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6724744DF
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 15:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232484AbhLNO0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 09:26:45 -0500
Received: from mail-mw2nam10on2073.outbound.protection.outlook.com ([40.107.94.73]:22144
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232444AbhLNO0o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 09:26:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j7bpg+S2phmj8jhJmkAAZs1QZf4KQotoA7mDeMW/Ct/DNI/zknGoviLF3EsFhKUc4jr1HKCQlr1uUubiyZqOQ3I38L2URYjtdI2qNSoSAkyfLTn7uHuabZ6WKcIG5jGusJDodjmftoxSt37jgkA4VDIPinwYoDm2mGAvSiqoXDJ1mdzzUOIcOB2MdF6H7jp+b9w/kdNt7HyvQz5IOa8NCumX+44myOnVl8bD53a8j31rEHWbXLVnN1olfCS8k1y9syIHm0+FpZLfBly/dmfJ5DQLGojFcGSgqDQe0QXlezEE4UmaDA5AlXFPoyhT+NQqHZDi9Jt1NpTZ9iK+5EmksA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q4P2MaxWEtRyDc2+stlZ7a4T9LeCSs96Oj4z6yJoiuQ=;
 b=mz2zvhRslKLv661ly3cWvM7ZRzt4rqZTv0Og+cNrzNwg4SLaKh7o/UviE8a5SPPlbJqoxtLAgZJaeFrvDACEJkv+rdB/TLZ4dzlYd74mEmwqpvm47Np3O6rnc0/9NCUYKLiP0eu3TBLO2OFxGqRpXo7EX6+JTs3JtWBOqlWC1Di7m6ryeZD1G2XgiNoWCoNHDHfX84HvzGow8xAkZ0eFC1zu9dPz0QAOmlOPiihw8JYO5tOL6uTdzAD8rIWoIP/6irXEdE8nEvxNgv2mGh5NKU+WxFKI0Drueu1wHB6eQvhS8KwTz6oV/w1paSMcE1MD3LSdo/z5APGNMlHH+tWy6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q4P2MaxWEtRyDc2+stlZ7a4T9LeCSs96Oj4z6yJoiuQ=;
 b=YqrSl/0fW3ZNXo6khISHbEpRHmte8bS1Nx7qfl8xTQuZg0NioeAxZQ11jEoqzx3iWqfZPhI0Zl+ZF0dZrnBSG/nmrJVs1FKav6a3Fln8gKHmMYnk88x6AoeUA4AZskmOj9PCeR97tiBu7YCME/M10gJrwKF1SM8qISDRV6IU8DiHKpFlNHyRAJDWaOM23F/K0DF2OpdCYb4ciFc3PRSn0XZ1XhP+zCtFXI5jUsGVZ9bZhmEMNqbIDI9NcvHMZ8Z/pzGxvYVklNd9zKXvWL+w7W7o/W4gaYXvc/96I2PsHnGh1SODO34W0pRviS7aDaJUNdhKUAt9XN/ycaXPRsEyJQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB4757.namprd12.prod.outlook.com (2603:10b6:a03:97::32)
 by BYAPR12MB3031.namprd12.prod.outlook.com (2603:10b6:a03:d8::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.13; Tue, 14 Dec
 2021 14:26:43 +0000
Received: from BYAPR12MB4757.namprd12.prod.outlook.com
 ([fe80::398b:d0f7:22f:5d2b]) by BYAPR12MB4757.namprd12.prod.outlook.com
 ([fe80::398b:d0f7:22f:5d2b%3]) with mapi id 15.20.4755.028; Tue, 14 Dec 2021
 14:26:42 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 5/8] mlxsw: reg: Add a function to fill IPv6 unicast FDB entries
Date:   Tue, 14 Dec 2021 16:25:48 +0200
Message-Id: <20211214142551.606542-6-idosch@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211214142551.606542-1-idosch@nvidia.com>
References: <20211214142551.606542-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR2P264CA0019.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:1::31) To BYAPR12MB4757.namprd12.prod.outlook.com
 (2603:10b6:a03:97::32)
MIME-Version: 1.0
Received: from localhost (2a0d:6fc2:5560:e600:ddf8:d1fa:667a:53e3) by MR2P264CA0019.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:1::31) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Tue, 14 Dec 2021 14:26:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 81e38361-11dc-4037-c6ec-08d9bf0dc00b
X-MS-TrafficTypeDiagnostic: BYAPR12MB3031:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3031EC2520E715BABF7A8634B2759@BYAPR12MB3031.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vNdIi0eTD7waSGiLaU/m5JJ/PZvH1nQkzc1AED160hXSugg58gk8Zce77zNbbsZyqITuUmmmxGGJ/8F2Bo2dBBdapbgRZFEd476/cWDLdhnr52g2yMWjigaWyt7UhNHxxjME1n3kD3nYr0Tk6zPddGsq++fALQcp0zpRcTwn/kCv4h8uZgYeiRPIEYLzaMAMxlRl5JMb4ItPipgtg0iz1WSdyIn0rGSmur5jjtHD4/qZnGu1enpMz+bsLkAnZBbDEw8EsbvwyhE74X+Ivv91dD9PBJqjcMy3al61f7XSqW/gxomz/aHtzAJGgNh2GB1lE2CE8phRfvM/xu0SKBePw0w1OWyXsukmCBAvqbviOrkLhjYa4rL9X6CUWsFKwmjpeiaWXi45NKMUmYX5fNAqpkceQQMNyROIIyK6AKQmSJxj2/2L1o7B87e8qym2Q+58fQEh8SvMz+WoT5G6+QjRuvpy1U08DIvhijyKMARGObAyexzSySYCUT9V+nKbk2GAvr3pJWmlpIJ8jqe02LGBGQ5DVMVR2CZGRJhqsgMEiZ+7hdaCVhxnRblDHaC60mZ1+z1fag8ZsHiWYVjD7ffyCpyslnaC5HOX42WgV1kliusDStXZiZ0XKXeS6LT+07VmW1KNWMU5JVFlgblypbWi8g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(6496006)(508600001)(8936002)(107886003)(2906002)(66476007)(66556008)(86362001)(186003)(38100700002)(316002)(4326008)(8676002)(2616005)(1076003)(5660300002)(6486002)(36756003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5CzijFKiMvprGjApbftzIJD66XSSXl3Sjd1rpPNW9VsQ/AyOYVrq9AoPsJHU?=
 =?us-ascii?Q?aFcm28cHmuOOYbsRNCs7zSsrzcW2pZCerv1ZYlfF9SZueZU9djhniBKqpJKp?=
 =?us-ascii?Q?18H09rYImp8Im2tTgWkS2TvhsdaV9Ii0XndpZQQHTc7ATFOOV2kyNWOLbr6K?=
 =?us-ascii?Q?J9Qv8OoUltdjEbsjl7spWRLLST04PMpg6ehrl0Gj94ou+Y2+N1BoV+lECBc8?=
 =?us-ascii?Q?aKuFNUqWCKeN2SRtUJmP927+NBBT1wCRTlSG4ys/BFsSfyXu90gin9xWnuBm?=
 =?us-ascii?Q?y9Yq7uDfG9D+LAt+D/9QRFfdhdvDH2U7NxF45PjJ+WyyqBQmqhCAyGxka5Nj?=
 =?us-ascii?Q?S6IreWzL+95s2da1WQqJ4DLCRtSGtW1GMUsC+WWgtYbZ0NtPgtB5oANgWUtQ?=
 =?us-ascii?Q?jrPAU/yAM94tkgMgitvXCRhzvsHdk/PfEch6PFRcRKWt1RXGZKf6OdETLcBq?=
 =?us-ascii?Q?pdOwjUrBX8gp+PadOOI6IEmTZjgC01Q9yqLAWZg2zhRZPyjoT/dlD60bTD65?=
 =?us-ascii?Q?qFfvNXLIrqHX0EBXs23RdBu2VzMN5n2eX6sAnJ6e6VagQUuEbzhZ1C3XFeh+?=
 =?us-ascii?Q?bphlsFO8DXXG2Ldhh34QThIo6Tg4fT3aTBEzLbvAE5W50ejTMB8KnNnA1FMT?=
 =?us-ascii?Q?LG6aaN1iOvFKuwb+HtmkUw76aeX2vj9Dx8pr0p+Fwg0qTBt179SWuHEIYX1d?=
 =?us-ascii?Q?HwH46oUbQfvz26W4iXUoxu+iTT1tlVlGnRJV+mg3PUUyum4PZ01TW2X802UR?=
 =?us-ascii?Q?BkTpWnCOzLrJCBD7uuGqzUtD701Uk4494xUpQ9KEt2IDP4t9trieMLIRqXz6?=
 =?us-ascii?Q?L6Enm4FYQVktzHElKo90LXHfSyfUhzXnBBbOo2o+qGTkYmpMKQQdKMzG3kJv?=
 =?us-ascii?Q?gQxq/sexz45wpXCM3u6+8XdHDpHuXHDmtTtnt/tPRcAOQXuqpYUOosNs5IT0?=
 =?us-ascii?Q?48FVA0sDqR8qWc+3f+U8/qTyeNOuKyu+DaxlBCpD6kfx0ZGeYnN2rfUbbKrt?=
 =?us-ascii?Q?2bUkPKKlmIqrtcgBOknZM8b/fnCs+1LQJ0M4iCsBhD8XhRZ52N8WqQEZWimi?=
 =?us-ascii?Q?cS9HjRQi4Id80eeHWdizHe61nEuQiQuxeFr2BaxqUGLxlP5dna7u9h1JlRNh?=
 =?us-ascii?Q?XHcn1HS9d/vs6RaghSe6OP5IeneIWiXRNLeHnxz3IAu+r69VCqJgrF2uebh3?=
 =?us-ascii?Q?4sv3he0966wWCovXlHNYAJGIj394WELocWpgxMQn8ifaQXpGDUykFaplwUuv?=
 =?us-ascii?Q?44s+ztyYGhFiFQzS75cwpJC6vv0vL7/OGpFymQhLfLRa6yjjAUIwYFHV+wK9?=
 =?us-ascii?Q?QQlR4hza8BfRGoCkltO6QYyQJx5xsOQ7CHe4WWgpf+RXQ2sTISJkKjfUIBIS?=
 =?us-ascii?Q?0ISkeEd/ZsQvXA2xmyNfzuxgLECB4W4ZApSHtc6hn+mNwq9NB5VprczA1Jhp?=
 =?us-ascii?Q?euXlYv0bPGU5ukKHnRQ4cvcrhqDxhfJ1IyJ1TtUaCfyeCCYghqQw4gsy3gFW?=
 =?us-ascii?Q?zj4J/44rIBnK8DWalPlCOeRUZbQjg/cPwK0McpRaFDWleVml/PqhOYikOfgF?=
 =?us-ascii?Q?PH8fIh9p8AoELYcvDhyX+cVmZ05/pYWNB6Xlj41BdS6jp1VieVBsIc8Nphtw?=
 =?us-ascii?Q?64NlQKTwY7TdT0v10gh27NZ7SorykuU5ewuGKfzeT4aWHrXVk6vIl1Pclqyy?=
 =?us-ascii?Q?1D+wwU6KFXGZlNWDSxWyJb1MKps=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81e38361-11dc-4037-c6ec-08d9bf0dc00b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 14:26:42.8831
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GHVgQpmJvuwC0Et4I7EYvzM3XQBvEzCS1QQe0U1vK+yOTGoNB46q/OITsG2N9vbMVO6LnZL+HG0jkV9vh5YjpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3031
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Add a function to fill IPv6 unicast FDB entries. Use the common function
for common fields.

Unlike IPv4 entries, the underlay IP address is not filled in the
register payload, but instead a pointer to KVDL is used.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 50226dae9d4e..f748b537bdab 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -528,6 +528,19 @@ mlxsw_reg_sfd_uc_tunnel_pack4(char *payload, int rec_index,
 				     MLXSW_REG_SFD_UC_TUNNEL_PROTOCOL_IPV4);
 }
 
+static inline void
+mlxsw_reg_sfd_uc_tunnel_pack6(char *payload, int rec_index, const char *mac,
+			      u16 fid, enum mlxsw_reg_sfd_rec_action action,
+			      u32 uip_ptr)
+{
+	mlxsw_reg_sfd_uc_tunnel_uip_lsb_set(payload, rec_index, uip_ptr);
+	/* Only static policy is supported for IPv6 unicast tunnel entry. */
+	mlxsw_reg_sfd_uc_tunnel_pack(payload, rec_index,
+				     MLXSW_REG_SFD_REC_POLICY_STATIC_ENTRY,
+				     mac, fid, action,
+				     MLXSW_REG_SFD_UC_TUNNEL_PROTOCOL_IPV6);
+}
+
 enum mlxsw_reg_tunnel_port {
 	MLXSW_REG_TUNNEL_PORT_NVE,
 	MLXSW_REG_TUNNEL_PORT_VPLS,
-- 
2.31.1

