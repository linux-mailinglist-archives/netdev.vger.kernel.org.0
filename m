Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D382860C976
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 12:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232168AbiJYKIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 06:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231286AbiJYKIQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 06:08:16 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2069.outbound.protection.outlook.com [40.107.244.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E4DBFFFBA
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 03:01:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k31ngVQfp/Bksrokz8esC1dcbgSt518v559CppCycLu/EYQGYLLfu4bIWX/3ONTZKJghkz89b+vwdcGMKQTB8W5AbGEUmTBxM+elCIQpx+G+gg4QDQxdAx5wtvTSZpFSYbH6NG20WChQFve4PZZl3jQ81m2cymJYE8I2UMgb6bpgJxprAVuDMLp5pGHON0/vHfVUmgZbOu1uXIkNiNZY3FaJnI5JXMtUVSvKjJyDXRCYgU38F1nCLp8zk4HInIQ0yntySbLuFEH207Vitk2dWPa656rC21ekR7GHRHrpAlNaDGAKruzGNFJMC/1X1sdjn9S+Bw02auTb0J0hysFB6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0FXcWVwsBQdAaXI9PWsoFystsy/uPpRkTWQ7oaGegqA=;
 b=g/8iDU3b8FxHK/O9uYyz0FBg+FfctQI8y0/Dtbm9vscHoIGlRqD/TWIfUYyKGFwMpsrSKYdcg0t2fIpRIAs/v6bmFPAW4+oNJusFLtb+p23CSBPORXo5gFcG0cOaElb2+5SeKaAVIs8jp5JGqmjyyMAU7LAD1nTIA4bYUEyoLxldhAhGbTpZkQ783W+rXFP+z3tdvhAyxGTHpYv4bZr8hHvRnmS+ssAfD0Gw4tRmbH6g4BhS+iOFkTJjmn7z/415PeC+XaEtzfYFfijFNbucwoEWJtKoKBhn3GMwgCDzv3VwO47EJLl+H8//ZCohJCYOT1+KpNczamQlNb3NStI+5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0FXcWVwsBQdAaXI9PWsoFystsy/uPpRkTWQ7oaGegqA=;
 b=ZJifQdPzdBx+HPO1lrgeMRhlbL7JVb0Cc1I8Xu2iGm+JkkA0dcAfuejmI1ilGKkOJAkO9XvutHvxbf5e1UWkCIouy+vY0nSO6yElHNemry2leJLVg2oIG8QaQQERCIfSGmcaIy44ts98UrsR3ORl5l8TyAKYgK5egzGPGxOdDz6jkX59ltmqp/N6DZKJpO6dazlGFHC/kw3nKzFLEvMqDsuo6AIoDmLAR3gkeFkmfK3biihK5RZONMROwlH0hdmlyA2DNcEmbUEjLb+Zis+MtAEbjmyGwb8k/txRFkfgVMWTKZCPNb439H6f0jTPqtmPuPfYSDo3sQWGzhWOxNnqvQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MN2PR12MB4270.namprd12.prod.outlook.com (2603:10b6:208:1d9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Tue, 25 Oct
 2022 10:01:36 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e%7]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 10:01:36 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jiri@nvidia.com, petrm@nvidia.com,
        ivecera@redhat.com, roopa@nvidia.com, razor@blackwall.org,
        netdev@kapio-technology.com, vladimir.oltean@nxp.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 07/16] mlxsw: reg: Add Switch Port FDB Security Register
Date:   Tue, 25 Oct 2022 13:00:15 +0300
Message-Id: <20221025100024.1287157-8-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221025100024.1287157-1-idosch@nvidia.com>
References: <20221025100024.1287157-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0401CA0010.eurprd04.prod.outlook.com
 (2603:10a6:800:4a::20) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|MN2PR12MB4270:EE_
X-MS-Office365-Filtering-Correlation-Id: fbf6700c-348d-4965-2965-08dab66fe739
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YJqlAXEPUl63T/fvbKM9Pf7SXUty2kYLsCdd2nPt8lp1PI1QOepkX7o7UbNzz7E2OwC9tkal5kBfh61ugu52+lEEhWtijxbhBG9XJJdSl0Qel5XRLiuc4clJM3HVZDwgnLsfcWbky2xwU1KTv2qRi/naX7bvwQgWiyRO0PK8V5itjLxUtxpOXo9cI5owMWMZR4F8vJi2McMwRt7vbVRolwOjPhPFnNJTiXk55DsYxkaQfO+Yi06AGP6iz5PnUP1n0VrtfeXHje7TXaYiC6KUVU/aZLf4QQmK0jX1fvOoz/WyusNaWXmrlzKeoyIGpiU0MzsTmg1c4njkrZAcMfsQZMktHcau5mSyRHghBAHkCo3YhPrRIDij+YlyjBql6XulUMOSWRQw82rvaUnZZsH+wmw1Ie5sjjLt+GLejDjGNQh+UkJX8sHyhp6A4DDq5dMtVLMDiDqL4V7MhwpAtFyL29R2i9O/Uw2oaFareTeDLgwXN/c3S4nyq55Bq+oGoOOEP9Vps5F4FEnBp+O6G6qJMc+buJi+8QgyISF6BZDycr14nxo9mN1Lu9AIwqDyJhEkzCtlIJ+BrAFn7e+1EfWpSeJoglKtfTZWhOiS2adbVuxg3C47s9MPnMKj1YwrcxhCl/rLFMBLZoR1Z4rQAztVA528804+btlf4reOcGu+VX7NyAT4HrA3+2bJimKj/Jpou8+f71v3GEAtj1ufUgibrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(366004)(136003)(39860400002)(376002)(451199015)(36756003)(5660300002)(66476007)(66556008)(66946007)(7416002)(38100700002)(8936002)(83380400001)(86362001)(316002)(186003)(2616005)(1076003)(26005)(6512007)(6486002)(478600001)(2906002)(8676002)(41300700001)(4326008)(6506007)(6666004)(107886003)(15650500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BYfZspuq9Usl/c5TRW9o7A/k1P1kxIH2lnBwAE5Ti3YK0A2xfzrLkEntRhN/?=
 =?us-ascii?Q?bTmOF+uXLNuo30W8jwYcYwqW8ssU7kQla94wdML9wVpjYWe6wKoHcaTf7UiL?=
 =?us-ascii?Q?I+3cDi9sI1WpGpS/iX9DJvxZqfsmQN95WVr6naJLFzk28B4RLpDs/xPhgf7P?=
 =?us-ascii?Q?pLn3tbX7Xgc21kWnUWZySwOtlTtexwPHjtypKQFR+bBhpS3lGgbReUB/rX4d?=
 =?us-ascii?Q?kf7l13RCalBfqfKuVUbUK5CTBb7vrOjKppa7mR3vIZsRTeccF/P/qNDAke6M?=
 =?us-ascii?Q?2MmuM/INWfnVmhun7n1CSEee2Pi+8czM292Je3tTG36ZhGZ2HoDqIvhivE4a?=
 =?us-ascii?Q?n09VsAcsKHdLJBAo0sq02tQBPE5A+UqlvhZkaKGRdjTw95w9omu8/P9iVQQd?=
 =?us-ascii?Q?h9HfgsNVSz5evR4gNxQVxjDjUR1a8SnwwYgDLUTgM4TwcI7dYirotOKyCBTe?=
 =?us-ascii?Q?kLbQcqeFzHj6jFKDcN8hJgaxxpNWIL2o4paYaDr8vdQl2SoanO1uhbDkYfu+?=
 =?us-ascii?Q?shZAvh6E7zZ6DZBFNkze5J3hOhMCvISLJbB50WyIb1NxItiZtBMYXWrlmZys?=
 =?us-ascii?Q?CweV7zMHws6DlEIUoGVNPuziipxdkIwNAwEf0q1DoC9z7MrMOQET0v+kqeZo?=
 =?us-ascii?Q?UtGOySKYloYa7OtytaDhgm94s2RwSfZ+/xyx/ePFPJfPc+0HjjuGfEYTj15R?=
 =?us-ascii?Q?RnKpK2zWD0mPlUfvfZ8rW8Jjg5U5DJYKeXWOhLeh7QwbPG3MvC+qjp2OVNCj?=
 =?us-ascii?Q?8KK8R6V8V+sXExIqmrRWAdJUEP9s2bA5PSlkhgsxSce7kLsatRZ675NARMxj?=
 =?us-ascii?Q?Sh5tcnezyChXRkx6EoT8MP99mhx/KqzbjUZ2AiP08b2VS0hZF7l42xH495vU?=
 =?us-ascii?Q?n1de6qihLvpRzAM9X1Vse6nIIc7lKBgZ+SoA4gnebe1TDHZRO/0wlrfE5Zgg?=
 =?us-ascii?Q?1kxe623gE9KyalDZS9bj8PiqudHGQmwAx7tXNqxb8UM3UqchI+CG2wCg87dy?=
 =?us-ascii?Q?te2IehzBEUXvEvJP7kMydtW6ckI7zzZnS2Wak3I60alOsi4fqtOhZsJBRjUp?=
 =?us-ascii?Q?zfZd2v3Ao3lNif+nJJ2vRisc8R/Tj2VwIGQdwFtJREKFaYqz5urwP//kmmkM?=
 =?us-ascii?Q?CUEzvkiHVzmV54W9sjCxG980Zs/ktn6nBtkQaqEpEd1WEvb743tZSGcoLuGF?=
 =?us-ascii?Q?kV9DZ9fZYrLraKCj4exaYYu2X6tjVHW273exn05bxpEtJshM4Qe8u6QTmIzE?=
 =?us-ascii?Q?HrAa0UzdHXSlnyacQVQhV6DCsK3cyU41H80G/CifVub8Y2BHRNbTawNiM7CN?=
 =?us-ascii?Q?xiP+X/+D+ZJGdH1ZtIwTTgV1tch54P26fr+3EcX4UkdiqOfssFOFe8Tig3ZQ?=
 =?us-ascii?Q?5WIt133gorXUO5Ly4JL+A4RW5yaeU85WU1+r/YPOW3okhMb4BGrf+EuEq0eF?=
 =?us-ascii?Q?OSAnqHhR5QegyyPlX76NobZr4+ZAroR/YkkUH1bbQYxZd+QwnLRGXX0d/9Uy?=
 =?us-ascii?Q?Tl+zr3Hc+dJp7cO+9u3OrAp2a8UDJIaRf8JIrgYBb50sRnoOFhCxtOgZXvLV?=
 =?us-ascii?Q?HctWZZO9d2F3VbBegZcBCcPhM8f/zHVatHGnrUl9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbf6700c-348d-4965-2965-08dab66fe739
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 10:01:36.4348
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gZTeFofcao9aU/fdndAPbegQhkwMQzuLmg+YEk2TdAw95J/2nVYZ4a2+1wotRkWTcOYHVYPX9ptn2bDUawN/4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4270
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the Switch Port FDB Security Register (SPFSR) that allows enabling
and disabling security checks on a given local port. In Linux terms, it
allows locking / unlocking a port.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 34 +++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 7240af45ade5..f2d6f8654e04 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -2046,6 +2046,39 @@ static inline void mlxsw_reg_spvmlr_pack(char *payload, u16 local_port,
 	}
 }
 
+/* SPFSR - Switch Port FDB Security Register
+ * -----------------------------------------
+ * Configures the security mode per port.
+ */
+#define MLXSW_REG_SPFSR_ID 0x2023
+#define MLXSW_REG_SPFSR_LEN 0x08
+
+MLXSW_REG_DEFINE(spfsr, MLXSW_REG_SPFSR_ID, MLXSW_REG_SPFSR_LEN);
+
+/* reg_spfsr_local_port
+ * Local port.
+ * Access: Index
+ *
+ * Note: not supported for CPU port.
+ */
+MLXSW_ITEM32_LP(reg, spfsr, 0x00, 16, 0x00, 12);
+
+/* reg_spfsr_security
+ * Security checks.
+ * 0: disabled (default)
+ * 1: enabled
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, spfsr, security, 0x04, 31, 1);
+
+static inline void mlxsw_reg_spfsr_pack(char *payload, u16 local_port,
+					bool security)
+{
+	MLXSW_REG_ZERO(spfsr, payload);
+	mlxsw_reg_spfsr_local_port_set(payload, local_port);
+	mlxsw_reg_spfsr_security_set(payload, security);
+}
+
 /* SPVC - Switch Port VLAN Classification Register
  * -----------------------------------------------
  * Configures the port to identify packets as untagged / single tagged /
@@ -12762,6 +12795,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(svpe),
 	MLXSW_REG(sfmr),
 	MLXSW_REG(spvmlr),
+	MLXSW_REG(spfsr),
 	MLXSW_REG(spvc),
 	MLXSW_REG(spevet),
 	MLXSW_REG(smpe),
-- 
2.37.3

