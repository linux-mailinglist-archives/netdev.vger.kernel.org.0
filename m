Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10CD14FBF81
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 16:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347474AbiDKOuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 10:50:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347471AbiDKOuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 10:50:32 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2078.outbound.protection.outlook.com [40.107.236.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5157327FC0
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 07:48:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GnaFh3As9jmLIooySdUsGeR97rmmBgip2ujd+u3Z027BBbE9MsH44REjsQq/hpNkh8r12UlvY9EvlmCIU5e4JHvNpVV8e/+sZpCs/hxnf83bP2g49yrmasS8kHtd4Tb/DsauhYejRQ2rsBXFo6EJe0noojDXQCvpDyVrepMD0LrFQY5pgNN/m6T0FZK+k4xRcu+7cEUnDZ8M6zMWpGI+yWRg+lKj5sh+BL7Y+1YRerd2BHonlPjdApsIo2aYSqGH1MLW75nGRgrwuS2BMCs6v1yfw+/essU4X4u4SIh64Ru+ecUiqfmV9nGZWpIF/hRIHZCeVbGlLXtwjCR8mupQfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1PeUtBHGVrLvRAOUGCAXro9Mq8XP7HSFe7psPCmJCCk=;
 b=Q/SxFsgmg1QgeCD97tp5hECySve4zxk/9brggMRMgwn6vx8SF9x9l1r+U8ZBd8iaXOKowjL5MY1j/tZ+bhJ8x5xP7yfcZ+G52ZET6upCZirF0a5+nzZlKSnp7pqt/qCZd4KUMTKykN0Hve6DSU9yLQx/vDUkE68uQL5z/aDDwXIZ8QKXVFrNKLgShdcAjKT6AH2XcoPhf3Lck9olhzjlojzv+1TC8H9NR+3iMcSsal4//ewOqoNUr5bLfwsNxCpmOSclvt0AN9R3KHN+/i7N1t64R3CGHASkNBJkpEgNs7wFqFK3Awbe+dBjraSOQ24POkhKQgBnvdA8SIppirL7Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1PeUtBHGVrLvRAOUGCAXro9Mq8XP7HSFe7psPCmJCCk=;
 b=rS8IZKTWffu9QKbPixWCBkK6+m2EeN2CWRF/ldPcBs7PYKZrStGVqhlVYw5eEvMDluH1MTXgwm5QJIsb0KoS6pE5lKQDcwv51g6vmsiKosRXWo9Vd3gP1Ilrxp5pkqSynCrnu7SlUPf+t7KeHCu6M82hVcmtMV+gx31703/VkDvsS3/YnwhuAgzMryNr3uECsBd+QOwBAffMG46a2CJNWl4R0Uzs8tUJYOiGqLnAyYpDQJkngdoqKOJ0AYYGuG3fPzZhHspBxEpXwAyuvpUlCJQjGa0R2MzbYcjTrIX13Y/vsS4ddvTsmUcYpjNJUbIlPQe3bGzj/acQKgVzKwMD4g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by BN9PR12MB5067.namprd12.prod.outlook.com (2603:10b6:408:134::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 14:48:12 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402%5]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 14:48:12 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        petrm@nvidia.com, jiri@nvidia.com, vadimp@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 8/8] mlxsw: reg: Add new field to Management General Peripheral Information Register
Date:   Mon, 11 Apr 2022 17:46:57 +0300
Message-Id: <20220411144657.2655752-9-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220411144657.2655752-1-idosch@nvidia.com>
References: <20220411144657.2655752-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0254.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8a::26) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d08dd02-764b-43e3-7055-08da1bca4dab
X-MS-TrafficTypeDiagnostic: BN9PR12MB5067:EE_
X-Microsoft-Antispam-PRVS: <BN9PR12MB5067D2CF453C119DF11E1FB5B2EA9@BN9PR12MB5067.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BUKYw6kkIxkzxSh2Be5Kb9UjyQz5MWzvPM8aXb0jWHQS4RL2ptxdd4PdxJQieWi4iBAZvFV9LnaLqEHu7dbmet7bW2MYifJlGjqQe4/0mr7PnvmvwFqMnyswpT3a01QMM8vxWwMwL/DtmV1A6sjbqeDVZ8ZLocYnoLoSr5UUchppp4vXWsDRLO3LPs5RuMFDLiC27sX/VQ4Q4b0JYRg2fQbyrKPuvaQY8lhEIqnPsJml1ZpmOWg424nJ63va9+3xzulNXNO3mKtbVQfSjcnbg/0UXPIx0jeimt9KguTt4rpFFhw3dZRDRkaP+LZkYATFlQuxQL+Rp078lS0HlyvNOhOu2y5dTqUu84Ja2lnUoOr5eMCp6FBc0OJrrD3C7gd8oOGjDxVbcTNNrmwI0E9pvHh9OUNCn2xAQwXdMmtxfK6pYj/X4NqqeE2w5WAaG6xqQbUri/RpgNkL1N7Kry8PrmKflnFLU41Mmb3nCcaqOy+53M6S7neE8YTPGJHoE/Wf9vW3M3s2P0Zzle4wS9TBRkPuhwN6bJGSWimRWMnv8z1RGeAW2dmXVmw7zLwkP1fJh4vv3huPyVEIVN9t3IZpWzeMzc5WfeWY7f9fozm2GsPY051PSBrUuQR429WcwGTXl4NjV14AAJ4d/AsluweclA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(38100700002)(316002)(6512007)(6666004)(6506007)(186003)(26005)(1076003)(6916009)(6486002)(508600001)(5660300002)(2616005)(8936002)(2906002)(36756003)(4326008)(86362001)(8676002)(66946007)(66476007)(107886003)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?i+hABjw1pJhmh6zhuo0q4bjyshxvNxdZOO6dCQdWU1ytgYxKfqt7njSI3HaT?=
 =?us-ascii?Q?9358eH6bDXLtWddVsYJmahMJnustv9hkVHvJmOCfSy7KU7lkQYUN6H9LEOpL?=
 =?us-ascii?Q?HCPNPxLMUZMMxNwVGFmz9hGAlNk5VmnwQ80rIbSCKc/HfKMqYqo/H0cHx8xe?=
 =?us-ascii?Q?PseFU/v2SdBYYz1vczUCapqbPzRFBDLymf31JnwJbwrUWf1nJhQUGRzWY0/O?=
 =?us-ascii?Q?YaGTcrjqzwmbekSo48F6JLsbhNMG4+gNnbW8TdCkMUUGZwWQnUUI12johGiu?=
 =?us-ascii?Q?EG/ZOaj/YyJIHgCbSC6wsLH5ukCfDnbLnPOuPFib4AABvVHc3NCnswgqA6us?=
 =?us-ascii?Q?xLjJbu4b6T/Djyvy30QskLF8ORH68NUvOR7H0jhoncbzi7H1VlMjc8rpOeWv?=
 =?us-ascii?Q?aGiHHq8lelpRKzCGgFF39O4gRkJWHGsNFF1X347L7fi7xwU2oxPqH0YTb2Bx?=
 =?us-ascii?Q?bW6d5QqeRXU2E/Vlx1HRBz1+njmwo0CZ+jy2VihwhQSRLfnd5zIAXiY1gp4k?=
 =?us-ascii?Q?aEpmNQplW+TSeHEifY3o8///kdf/8nsbe1p+414vrk7imQ0kwTLWKRsXPZ84?=
 =?us-ascii?Q?uRfDb9mPy+TioFOZqVbFwJLgx5u2aezsb8ds+/sb5Mk/L8RCGG0c+U/nofvk?=
 =?us-ascii?Q?8wC6igvEGMZM6N+0a/kh5HotT7S6aXDF5zSEnPVb4SozswlFn7QdATTEHc+q?=
 =?us-ascii?Q?D5RLB/6sQQaL4j3vSU+EvCALwFnJT3Vy2B6RVxV5T9cllDdOmsZBmMVEmDd+?=
 =?us-ascii?Q?nG63tzjGQfNBT67tMTKV9m56chtH8Vg98U9uxfRe8t8n/OO2MNPgMF5R1xLL?=
 =?us-ascii?Q?1q3npVuKPI7WkUVypLiJsBy/ZhQ0EwiPlic0HOZ8ZPF6dNZwb8HbEIexyLZN?=
 =?us-ascii?Q?0CQyvi19xhGtYMg6ZXRjZ/dJ8CPscR4fwIMVvOtL8CkeG5chl8y+oAufSQ8s?=
 =?us-ascii?Q?Hb0l5ya521r5sOvMpTmAw/8m8HLEsfPLsquLLGqgAsEB2E2MxXuyQZJV04vI?=
 =?us-ascii?Q?X4fu198/Wd8W00TBuULOak/hI0XeLyHLvHh6bU6JJgda4ZLwWBPvalVv44fx?=
 =?us-ascii?Q?VMUgXSLUVUDEP1C68prowwIj0IN7+VJ99X8JBISuFucwEez4zWjYFUHXarx6?=
 =?us-ascii?Q?Ge+61XTEqDWf4vw2OlFwgH7iorn9nUr2cvQ9/5aVrCengZplp73jpbPcDY9D?=
 =?us-ascii?Q?qF6W3AqDhwFc6Ya+2PQoZEGHxagbrnsbfgmbMAVk0GDLwSFI4ANUITFbx61H?=
 =?us-ascii?Q?pfmI2RKpFkF6x+J7S7qKYvCNkt/awBrrph2QpvAxTEJZ4U7+UYzNjLSR5YOn?=
 =?us-ascii?Q?nj6R3H19IrMjyjr4W+isz5aE0rb/B1vH1Ba3DRJ/so8itMiz/WCBxL3XOwpE?=
 =?us-ascii?Q?iBX8Kt+WujTzGV3Ssf3N+WVs5qChMgMWcpMsvDr4gmVu3SG/VZZvL9eCTTYA?=
 =?us-ascii?Q?3PSqYKIAICeajgMkg7877lvB+01ddrERe6vp5ikZNWM2a/5+/rhBdcfOu0+q?=
 =?us-ascii?Q?5n/wf9JARXarRaYnMtXPenyZj/GOsJ7NncxQIYY/KEeXGlKXr22BIkkqC74p?=
 =?us-ascii?Q?dh1K8uvihe7AhnhORxXltU2nBLsPDQXPuSsZSPeFlN+xhP25fW//MTtoWvWn?=
 =?us-ascii?Q?CmnzMQUGmh02QirdID1CY8ajaNe4mn5wgn6lcUGn54cekOwy+6Ug4EJ4aVK+?=
 =?us-ascii?Q?ibKu56oMR1zoiFNp/5Oxi/Lr8fmsjBLBoqRoaL0YGEsKe4QNtvfOTxqDRJ8g?=
 =?us-ascii?Q?//Wvg2DTyQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d08dd02-764b-43e3-7055-08da1bca4dab
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2022 14:48:12.7552
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 68XWYSVhIzRKi9GDJY8LZs7AqYjnnDY2G182qUfvd5ih4YpLwRxyeP9foIRz8zsRrAe8u1IUhhylNQ++yzg5Cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5067
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Pasternak <vadimp@nvidia.com>

Add new field 'max_modules_per_slot' to provide maximum number of
modules that can be connected per slot. This field will always be zero,
if 'slot_index' in query request is set to non-zero value, otherwise
value in this field will provide maximum modules number, which can be
equipped on device inserted at any slot.

Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 03ef975a37e4..b8a236872fea 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -11386,6 +11386,12 @@ MLXSW_ITEM32(reg, mgpir, devices_per_flash, 0x00, 16, 8);
  */
 MLXSW_ITEM32(reg, mgpir, num_of_devices, 0x00, 0, 8);
 
+/* max_modules_per_slot
+ * Maximum number of modules that can be connected per slot.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mgpir, max_modules_per_slot, 0x04, 16, 8);
+
 /* mgpir_num_of_slots
  * Number of slots in the system.
  * Access: RO
-- 
2.33.1

