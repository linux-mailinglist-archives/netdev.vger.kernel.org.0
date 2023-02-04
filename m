Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ACCD68AB80
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 18:12:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232422AbjBDRMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 12:12:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232529AbjBDRMS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 12:12:18 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1F333468
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 09:12:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YRHvLfDUFLXEw9DevUgSaUkxhfirRi+d74LrW3cosHPcikYYG4zvwc/iRImf1RfVwkkiIk8B9ffd22kVD7m+L5SDsAjRd47iks563K8B0MKn3YqKHI3aASeVgCw3QTPFGV0My4wbocoXmbvXeez8qfUB8YBhgU3JW124T++hek/KLtjqOsQDY5HPBmuWXtHlr+SoOL5WUgfYHxHwQUACD138L1XbPY7NQ7D7xLg619MgBA3KXGf4GQA5tT9sJUz+RXwwwNpi2liMdNQy3crQHSKznk4HfSFht6zUPF5aT6iLeq4dnSeZm88EsyC0/Neps3K3wR7h43Xq+reB9JzGaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2sxMKfQrl1R9hAAzNNuoFio8mVq87qKkUi/x5UAzYHM=;
 b=UB9iPFGH/adQd5epxsjEBGbYGRfi3OEdGLuUN0GjMFDJwl5q+N8dIZD9ePsInJ86GI68puccfITjb6quyN1PGTJ9LONqKUGFc4nGXJBQVy8UYclWx1JwTNzcwEs3mHcLotJiWsU7Z6IFLd76PgcoXCO87zfnlExMzAWMdLkgh/XyBDKhhUvnwoOpACXwMNkl6vgukl/z3eO3+heuO7CMs/bioEKSFt+xhU9a4VaA4lBZZK9IjcSyN2ca0RjPTlBDmjpMSrmZvtgyMsQz9MxP6T/7worA3jRlA5a9a5FW4ZZkZY63+l20AvN/pD7BW3tz1M7YxYFD/XnCOV3hvUwKjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2sxMKfQrl1R9hAAzNNuoFio8mVq87qKkUi/x5UAzYHM=;
 b=p+eCo8sOukCA+p9AlgxKamZzW4IsZDYMqhX5vX9al7f1HmMAOAC0KB12TLdqBJaL/U0nXWn2/O8oKi2YxLfBfATjgcNEEdYXVOEaz3l9IWwnd1cUhP2Sz8ZxRTcONGnZRB+ObHo4H8HMyHem3aQ8YdExVxYydXR3Lfv0efm4cXzcdW4uSAw+Dw3+EeWDChc9paS4/TvMrL2i63TOJ5oYkNheYf8gG2PEjzIJUOYQJhkTtITepWhKM0vZEd4moorBKbLWHN5NLY/a0JsxNkd4++Q0/hX5GkBrTVuwX+R/E0j7vceB+p5mMEDLZ0YwvNk3dscJ5I/bDFCW2VIeihPryg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SA3PR12MB7997.namprd12.prod.outlook.com (2603:10b6:806:307::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Sat, 4 Feb
 2023 17:12:06 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab%9]) with mapi id 15.20.6064.025; Sat, 4 Feb 2023
 17:12:06 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, razor@blackwall.org, roopa@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 04/13] net: Add MDB net device operations
Date:   Sat,  4 Feb 2023 19:07:52 +0200
Message-Id: <20230204170801.3897900-5-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230204170801.3897900-1-idosch@nvidia.com>
References: <20230204170801.3897900-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0174.eurprd07.prod.outlook.com
 (2603:10a6:802:3e::22) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|SA3PR12MB7997:EE_
X-MS-Office365-Filtering-Correlation-Id: 54d9f6b5-fcef-4240-bad8-08db06d2f173
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i6fayuULSwXqaPTI9omB7NMKohKJDHYQLqv7addQ4NyKTXQ2bjvs3Edokdpe7ysDNdreX3SvOeWCozuSEcLJTomA9nM47cPLJ8suNflCuTr3KyuFB+0jRAILUTD0YbEBEQoFnGMGsUkI3dXO60pv2oMXTAAMdzncHjpp8QuqDczoH6Wuop2XkKAj4UvZySYwQKP592Lpq6s59/Mlg7brlQymo5qtWMsFVg0DatsO0E0OHRlVN4n6cd/aE+QawLEghPo/KPpCeNLGvN/qVHakYfSaA3464+YKBfFVkKtDN6IG7f8zxgjntzZwT24/IwK/t9B+49xBNfBBmTPUqwclZ6hXkVTAk6coKrqh5i086TDDFTuMNUFn5c1EoDKkFNWrElUPn1MQnIkBAiFGqv23znwK4R1ej1iRCUVSxLAVxY8V1VnJz5l77/wWI7+4kvY4gXA/7spiaQfQsPSiRJALQtaziGzbp3pC5Tuq5Tewux/cwhgxNhmm+cPfRsknVPVndoXrlfDJ9rVqwuX26uAjxLC4e7jahh+KMfR3tYezSyF/saeZXsaaToZzSROfjsUyKbdQOpF31STilsc317MZnKkxC4m9GhS8MBylFKILL98SjCFKBaN2+Mpy/zXIKvNgRobPXjbxpdu9idC3sZ8CTg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(366004)(346002)(396003)(376002)(451199018)(8676002)(41300700001)(66556008)(316002)(66946007)(36756003)(66476007)(6486002)(1076003)(26005)(186003)(478600001)(6506007)(6512007)(4326008)(6666004)(107886003)(38100700002)(2906002)(86362001)(8936002)(5660300002)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QcV/uHW0d7Mi8weGgvA1PlK/k69QqXfHCzz28d8W1ZaUCKRjS4RfbqG9G3mg?=
 =?us-ascii?Q?LN6dJH8uJTGGQfBitZeZoQ/vhyNPF12PKWLjsy4AKTgDiKI3qn6yNF1hjr8Q?=
 =?us-ascii?Q?q40GO3EjdyRGYwVy4MmFaXxvuEY4KRyrk0ZsBgxiX5Xunm7vfUuBVNeyCrnw?=
 =?us-ascii?Q?X4riSF9E+Wsp21J2JqZIfe5a0PdgY0UgE/YUnz1fVIeMFplr/UrCosSewsNN?=
 =?us-ascii?Q?frXBZRoW9JsEfuw8Rc1FTBDfLk4EwBR2FYNVB6iD2L6AOjwovRfuX+uWSjnE?=
 =?us-ascii?Q?JW3+AvKI3WUzXI8QuPvBGA/bsMt/G5eXOqY82q5x6r54NFKO0RYwT3SUMr6N?=
 =?us-ascii?Q?0QhJlZXqhW0QxUucFl78wjHvvun3pUtJ5GpZHsP00+crbSN/Ka9rNuDodMQO?=
 =?us-ascii?Q?cftON9uV5m+rTW15UynndCBy3curSSHa6esIOXbmXaowui4itpEiOejYL//n?=
 =?us-ascii?Q?+PUT8pmVkwaQjiaTVzRqiba8BlxRCbum2XlIPJLIJNLlLiXCnbdI7QuOPGkg?=
 =?us-ascii?Q?SIcwJwSoLlzUqYDBmSAjVOovi01lL425RxHO0Z2rHZ17hrzjlH4Mi4tJBtH5?=
 =?us-ascii?Q?PcV1vCLslCkAL7brriMuSPTNVc0KrxoC1lfssR5mWB8yrBhjaLTAyA4rCD+l?=
 =?us-ascii?Q?vur0U44ah/pjJhBbANgkG3Yfo/gbBTpKQNB16WvJOsecpCTU46PnBfSNbgMk?=
 =?us-ascii?Q?6PWQ9fKLnJUMAPKUgHJJpC9jii/7XXh6R79nElSAaLBHjf7KL6YGY6ke6qVh?=
 =?us-ascii?Q?XHFrTFDoZozgVSeqh9hNf/wd2fs9onHyXN5dnpQ4JDtORLdVO9O8teJceH7x?=
 =?us-ascii?Q?/zWTeec8nKIctRnB3inFar8EyWwgtMfS4Y5i4BY3oWMfJPLaoORBgQedk8C8?=
 =?us-ascii?Q?mwAxDtHouRbl28J1KDcgnhijRaD7nsiq/ykx/M+2K93TRn9N8+HzFqGhGmWF?=
 =?us-ascii?Q?pb1FMchBgtpRW21icy/HpDCtdQatMF2EdHWTrCDlb7vtavOLDiOQdfI52Ch9?=
 =?us-ascii?Q?pfDSLI2VZzzvcsuwu+1z+i1kvfzkBtmsuMPxSmSUX7XhKjhQ7jhxP8OAxygl?=
 =?us-ascii?Q?cQQebn/HMLq7NV4Ni76JcQyjEeqdpND2LgXNSWI/BPcFQLL2gc6oT671fX/v?=
 =?us-ascii?Q?i70Ytbzs9Wqb5TAYxEc6CLYikSw01zKTH4k67wvFkD8Vt2khbnTHVVGkjfSR?=
 =?us-ascii?Q?kUuT963u1/Tq+50v3p+PfeJpyZE9MwtmMzkI+vzM5zuSF7F4lQeTGuJnt/4H?=
 =?us-ascii?Q?1j8NHSWEEsoR2uM4/E89pjgSGvAynPjuon7vMUQMnT+WLtE9onuS+KMkE+lL?=
 =?us-ascii?Q?NC2bWnqc6Ri8rzjfCZ28JabkUCqTl2gboBjX2bkoZk2V+GsJldhfnl5eCcKs?=
 =?us-ascii?Q?OefZPFgipCkDJoqxVJa3sFaKeANDCpozOIpqQuikrf8/4YCHdRCsKGMiUT76?=
 =?us-ascii?Q?CVYadki7huZXzEe4mvxQGbUlwfSWzNdpcvEbj0EzwpPua4HpKwTM8LR57uzD?=
 =?us-ascii?Q?Qf93UaYDYqYOB74+1unBjZNg0zj3mb+6W1m1MyYnuaSstInUl/+OC1ybzsHW?=
 =?us-ascii?Q?CsvGylbi0IH69KLNtgBpYlhyrPFwwz90a0Kt7My5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54d9f6b5-fcef-4240-bad8-08db06d2f173
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 17:12:06.7955
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AQdIUmiV2d6w4SodHRhxPz8a6htsruh8g7trLOm9S1qwl9lt+kW3jzhAqm89uY3VN7/f8c5PB8hNDNpa5EH06g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7997
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add MDB net device operations that will be invoked by rtnetlink code in
response to received RTM_{NEW,DEL,GET}MDB messages. Subsequent patches
will implement these operations in the bridge and VXLAN drivers.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 include/linux/netdevice.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index d5ef4c1fedd2..47e33c6d314e 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1305,6 +1305,17 @@ struct netdev_net_notifier {
  *	Used to add FDB entries to dump requests. Implementers should add
  *	entries to skb and update idx with the number of entries.
  *
+ * int (*ndo_mdb_add)(struct net_device *dev, struct nlattr *tb[],
+ *		      u16 nlmsg_flags, struct netlink_ext_ack *extack);
+ *	Adds an MDB entry to dev.
+ * int (*ndo_mdb_del)(struct net_device *dev, struct nlattr *tb[],
+ *		      struct netlink_ext_ack *extack);
+ *	Deletes the MDB entry from dev.
+ * int (*ndo_mdb_dump)(struct net_device *dev, struct sk_buff *skb,
+ *		       struct netlink_callback *cb);
+ *	Dumps MDB entries from dev. The first argument (marker) in the netlink
+ *	callback is used by core rtnetlink code.
+ *
  * int (*ndo_bridge_setlink)(struct net_device *dev, struct nlmsghdr *nlh,
  *			     u16 flags, struct netlink_ext_ack *extack)
  * int (*ndo_bridge_getlink)(struct sk_buff *skb, u32 pid, u32 seq,
@@ -1567,6 +1578,16 @@ struct net_device_ops {
 					       const unsigned char *addr,
 					       u16 vid, u32 portid, u32 seq,
 					       struct netlink_ext_ack *extack);
+	int			(*ndo_mdb_add)(struct net_device *dev,
+					       struct nlattr *tb[],
+					       u16 nlmsg_flags,
+					       struct netlink_ext_ack *extack);
+	int			(*ndo_mdb_del)(struct net_device *dev,
+					       struct nlattr *tb[],
+					       struct netlink_ext_ack *extack);
+	int			(*ndo_mdb_dump)(struct net_device *dev,
+						struct sk_buff *skb,
+						struct netlink_callback *cb);
 	int			(*ndo_bridge_setlink)(struct net_device *dev,
 						      struct nlmsghdr *nlh,
 						      u16 flags,
-- 
2.37.3

