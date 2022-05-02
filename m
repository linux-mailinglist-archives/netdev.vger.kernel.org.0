Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61D8E516C7F
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 10:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383905AbiEBIxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 04:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383829AbiEBIxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 04:53:47 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2041.outbound.protection.outlook.com [40.107.101.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C49781001
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 01:50:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MBWAoezrRx8b+jXV7F2b2lbBR4b0OleKUcgHD7faAB+BBwUHexgxE5mGflF5N/KX+adR2vO6vczQxRSs39ymXGu22ophWdfZrDPw2cbXssH2nmI7uX2JUyhcDG2+Jn5MwDK6b9wVUQML9Ho5UxgKWeLP2Fyfuc7ucO3p1BPCMDL8DvzP6lVmF4EKfqutsScnNMetaZYscEsoclWGYtneR5ZOl9oTGXNng2r1RuciRydkFBQt5LRDCRzdw2W+3jwqA2K843hSBOUS4wGB71zFItbGBsZP5VNEK9i8DQdCX9yQrBbBWLTVhf2E0PzsqSjK+BA2EDAzqwYH8mW/+dHdlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fsoDWHmSdkxZWP1rE94vLWOtzJuel6Ft0KihSyArZJo=;
 b=SHxBsNwivyUkaSr+QywqQZgLuPC7kV+CYzETTQR43fovi830JQew5zHam2Bqa4hUIqRRas6+GJzMBSNpgH6c82BPWOCVFZytkcWNBvV6Zc4bZWdNG77haY63hOHJB5tt00hzuwN5HX6n9pj+1BpwT+96wotzaDLgEP4fMt3yoBQ4lTf2Lh2lK9FP5FZ5IfntH71d7zdom8rH/0vqP2JGbzS+TQyZSibQhkGCU6VgTXZEMQgBRZmnFRMSxNtXSqqJ28VMHAGaAwz6nDQ+cf+jAVimd/FT0C0TpIhowD3afdNGAjzcNFxHyQs2zyadwVKInQUKp13K/RS9WYSUzxzwkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fsoDWHmSdkxZWP1rE94vLWOtzJuel6Ft0KihSyArZJo=;
 b=SZr+NbFpegWDgCem6r0EMRQD2xOxrmozRZW4Nze67I/Sey7kalY2T2JaN018c8p4g4vGxbe1mJYagLyEJAJJNuJ+qrBr7P5vU3lDkIYkgDLeyYnXNnqNcov/l29bL7ALEZqZJ78n5E6xGLX3l6CUiPvvz75AkknIAKqiDzslmq7il574K61hkkjhK0n/ktEp1v3o7ZVM5XSgw4IIUfhV8p+Z735MrLZeDf9pHEPR/IMtZxTSBoJ859ceAPDmY+yVP4Xl1cIERyS5qtY/2c4Fn1SzFl01W3mQP34OAqCgFRovIwzdLUFqTRb2N+mx8f/yzwgk5YeX94Qz1uCQtl6FSQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DS7PR12MB5912.namprd12.prod.outlook.com (2603:10b6:8:7d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Mon, 2 May
 2022 08:50:19 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331%7]) with mapi id 15.20.5206.024; Mon, 2 May 2022
 08:50:19 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/4] mlxsw: reg: Add "desc" field to SBPR
Date:   Mon,  2 May 2022 11:49:23 +0300
Message-Id: <20220502084926.365268-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220502084926.365268-1-idosch@nvidia.com>
References: <20220502084926.365268-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0168.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9::36) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60c026ae-66f3-4998-def0-08da2c18c8f4
X-MS-TrafficTypeDiagnostic: DS7PR12MB5912:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB5912B38A6EA01199DE54698DB2C19@DS7PR12MB5912.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 29Kgtbk/I75WGui98GEZY6OXHUi4s4g9ezTy9X7cRfg1EV4A4uQhq2ypBt/bDUGrKH8sx0TFVJ7cNS+0v7d+/w+qV6XMAgl09tja6odHQu8vVB4JLMSW11l9SkbLUdGLyt4tIIg8fTr8iuc+M3CrZuxlz7/RDW8pKdaNF400xHxOsz2eEh/H5u3+zbMa9/Fn2RGbrLT888kmTyIWy+UThwf4tRv3csbDw/Q70e1toosSNkTZxlLEriyHc015N7foz3sEx0n18UrTW/+OvzQHY8Kp71RbxrxrhTpqNVHR3+gISsCPEFqPiQfhomg9qkk8i/jNKHPZz/Ue8C5uYYkmC3FGH5HuKOgNaOBIsQUzdbAHtv27KJHSRkfPXdv0ZutpA9nRO28TwrSrxGWwXRFYHjNxjw8lW3xqoMgy5ikzQeV79oni7fAIbnYPaGKMasfHpmLysQo/ndIpj/ZoiQQgarnSrjjOxbv4BoYzzGQ01ziG3XXs3x9YrY98PYJ5fy2+UQCapP4yGqsUWbIFnJwbjTMfsBZxXd8nu7nopSuZEcGqrKd5yTXQvaeqOu5GTi9O326TfqBgmKkUbmO8MFp1upZq/mqABRDIii8sXOdraJ++3wOOTp/TEEQXGKIh66SXqYgUCnwhDEgmiIgJ0KToog==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(6666004)(6506007)(66476007)(6916009)(316002)(5660300002)(86362001)(66946007)(8936002)(508600001)(8676002)(6486002)(4326008)(26005)(66556008)(83380400001)(36756003)(2616005)(2906002)(186003)(107886003)(1076003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?umAELzH6r5YixvMi/7WMJGzx7207ghUofHwRgH3j0WNhsP3Q4anc86Pv+TC2?=
 =?us-ascii?Q?2JUGzmsGblNbst2giZpET4C5qFudxUi80CHENBraHclqpxL4nX/LBb9zaF8n?=
 =?us-ascii?Q?PkT8tTeWuVpjfPBmzwvhI3WodbzeVamYDpFwSxLuYl/sCFpbOFvHy8KtwAF5?=
 =?us-ascii?Q?MaRzcupum4TDPtytzOk05Ut22BHeaDNtqZuAsyHyRanYeN+7sfOw5OWY3Jce?=
 =?us-ascii?Q?OzgC+m4nMmsiHmJeX+9KWtTRxShfz1WwH5xKIckUEtLy6TiA7YLf2ZjdI27n?=
 =?us-ascii?Q?e3avpZnX0FXQ9Wgyed3HG/ecJScPqiWNf7b7hGOnrzBA6hPWvEDp9EKbhy+h?=
 =?us-ascii?Q?P5LltrcfLoi5BB0GTn00tkt02vLbDj7e61iUDigifQxY92E5IDBgUTcmNak/?=
 =?us-ascii?Q?8AofZoGNXhnAuq6gOjKbYmuWmrRAOlv2DacGZxjXb0AyKk2x25mxMGXJpzIV?=
 =?us-ascii?Q?BLCCFnLT5FtAWFQimoJXeb9SJoPebifidFH2xmzmNI09MTsZVEBQEICLey64?=
 =?us-ascii?Q?XHQ3LyfYRzmPMxIxbPdEg4R6w8wsWIPIjqf5bt9o27H6i5xjNUvTDo+6UbXA?=
 =?us-ascii?Q?2FbhdswGhKouOC10+JIpwNoR3Bc9eyZY4QNsu0ri6FBPaNFEpcmbcZnek73U?=
 =?us-ascii?Q?66xDSnBJWBiW6ouBAUk4cG9I7cm5QASZ6xaaqLk+Ekw8cwuBujCIUsozvnxf?=
 =?us-ascii?Q?hhcwV4TfAFG8JKMAGcGx3EaGpgT+B7YWXTp+buQ4n7mKHX0lHHskhwMNBJEZ?=
 =?us-ascii?Q?hBfIDpwibPrmmt4MlARcx7ChGSLE5vSMAnGzhEnZy7QEbbb7rzuyvc0Kcnj+?=
 =?us-ascii?Q?3SgLNRtq2JPqkO/CBw6/IGNfPOR+gFaHQfJvgkVzK8PMsG97qXwTAZz9Ts8F?=
 =?us-ascii?Q?aBVYMeH8uONph49VVOVIEWkkqbWstEuQ2iNavNfzoBX7sXProt8Dk/8XmTkH?=
 =?us-ascii?Q?7ie+FeVX3GSVBGqsbW7AJbYEac+VYEQp7PGzP3dsnx++ZpTFWLusY2MB10GO?=
 =?us-ascii?Q?mW/MWgnzHCirpvdkuc+lY6tYArcUy1fBCd4vhq6WVZGg5y2z2BsR3W8QIRLr?=
 =?us-ascii?Q?pXDWrydH3OrHiomxu5DofPkG8mZwIoOxwhO9IChOjW9yH0iTLGL7z80PAF0A?=
 =?us-ascii?Q?k3rmUY8XWhv5TGBSZ/8sQzzopv6jBrGJ6jlqOmy6X8EzironNkyhCQACXWgq?=
 =?us-ascii?Q?gOuhQ7ARIiRQEjyKCOII+JmHEyafcxQxNlZhtzRKY9TKZEGatL4l/7z1njqq?=
 =?us-ascii?Q?aGncNqOKPV38HLwONoelJ9MCxPONejpkfZKcWL8NzlmPbfCE3t2xEaPoLCWD?=
 =?us-ascii?Q?yuCloPHm7bZoMsM/Iij0Cc5CsfPpF2Y8Dtsx43ZhdyxoCKxbBUQrs9O01UEk?=
 =?us-ascii?Q?I6ZEWcQ99qBkKGaKhybmirQD/hwM9d2K+q6yasis/tExbarPtnu/nVrD8mML?=
 =?us-ascii?Q?kCstNdFSayvXopMA0F0uCyX3HS60J1l1CpCCVP71Nrg9N8dd0vUeIG14gJyj?=
 =?us-ascii?Q?rooHm5+h67AA+8ZNI8Sv1ekqL5BwL/F5vDv8AJqSSYUoYw7umbMcvJL9ra/d?=
 =?us-ascii?Q?q7nV/vJyNgfvQZogvU2QeTn7Nx1rwQkfByp0UWsNf9R2kjx6+PgVGZqSsBmr?=
 =?us-ascii?Q?KyVXTkcc6l5XmOkB8kbxwF5if8P/qpg9JysWJA6yH7SFHToJtOg4mfj6SMp0?=
 =?us-ascii?Q?JFpqsCY/MVoziu3Wmyk9szo0YI1UxRiqRCOwJATIlCFNQCmyQvJ8ot342nMc?=
 =?us-ascii?Q?+QfX/fUPbw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60c026ae-66f3-4998-def0-08da2c18c8f4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2022 08:50:18.9768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dWrhejRlfqIh7VSSBXnJ05eUdz9bXCY50sJwQrEZNfuMeotLdeivK2qESO7C2w54imwJJMrTkpPI3+bjdeHATg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5912
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

SBPR, or Shared Buffer Pools Register, configures and retrieves the shared
buffer pools and configuration. The desc field determines whether the
configuration relates to the byte pool or the descriptor pool.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 04c4d7a4bd83..078e3aa04383 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -12641,6 +12641,12 @@ static inline void mlxsw_reg_tidem_pack(char *payload, u8 underlay_ecn,
 
 MLXSW_REG_DEFINE(sbpr, MLXSW_REG_SBPR_ID, MLXSW_REG_SBPR_LEN);
 
+/* reg_sbpr_desc
+ * When set, configures descriptor buffer.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, sbpr, desc, 0x00, 31, 1);
+
 /* shared direstion enum for SBPR, SBCM, SBPM */
 enum mlxsw_reg_sbxx_dir {
 	MLXSW_REG_SBXX_DIR_INGRESS,
-- 
2.35.1

