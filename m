Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 714825B8201
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 09:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbiINH0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 03:26:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiINH0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 03:26:09 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2069.outbound.protection.outlook.com [40.107.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1097F6A492
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 00:26:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ldt27Xb3hvLTLvX7PKHoFShJTp6XB7ScqvurFmEnSG72KYP4HPZs3r2yIKGthE45BrPSH810ME2rgvk9m7DsiiAiip8mcnAJDMA12LT6jAUJchIDGOTPCnuMgtV7OoVSRHVf4TngvU8cQcEcXqf8Pqxax6CWGYLbrRsArR2GHfCdQrPWWJvzw4rh6uAO0AvyL4hUNzLjSjLvk0wTGTWBWyeTqE/RIXMFwZHy+8Lva6ANhZnh3bZAUk9IxkQ9jyrohqS4WmOGt0N6aSJ933XnfrDo6dXVIYDfTHyy34LufoLYddZgToktf4Vhf7hIHv5tv8mChOU8gKS5vfKfVB75NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qJvi/8TV7bTJrm4ML0ZHogdHKxPe5idvseSwTStjp6c=;
 b=Tlkh3wbE9cWPA1r+m686ptGmCxr9xw+i1OGjnpku5eNfK44KkT7P2aQhlCRndvVSQ7Pvrs8V5y0zCQClPCUyF6R0n0EhQ6djunuSW9bVENpiD8EavM7eOWKyjRRk/eGZlPAKpE6tVd6vyGnkC4xOKrzsRd7bHfBenhCDvdh4YxgkhbWuhvxV3h9mcsGk5lpm0yjogccKPXEKDEqBRICjeoarOwJ8pAnXA/wZ0Gk+0UNkC18sGO/jw24es+iILqk93oE+WmMqdIOof2vfuvHKKLgrgDVOU3HqRcityK69h7mpJoriPIkVKZmEkiMpDEF3TK6EgCHdtkopAlKLl4qBgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qJvi/8TV7bTJrm4ML0ZHogdHKxPe5idvseSwTStjp6c=;
 b=eYAribmSNkZYY7rST5QfCoxuVIdtGjzLuGptxMv5ge9HlxN8l7Ef8T1EnGE3w56Qs/u/F9+PIliI/Ab1XusvveA2nUbF1bBhRkpfVE9zH4CB5xlseRQazwC1xZetZrMT7OugbQx3aRz5lKbWTWKQIrqt/XqfBOMh6VBz7z+uuo/ICj0t2hSyKjW9QAu4r/XveB6J9Ce6DyaU3Clv7rjFPfenIMowcpFKizv5c5bRLuQIUAjJMqgOcGuAV89SOqMrcGMxzY9NCyyH34AFyKsgQsHnpLIRYRo1y2RY5JstTBsvMs3svtbtmBpShZlIZvTNfTqrkDfD968+M/Nns61VUw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by PH7PR12MB7163.namprd12.prod.outlook.com (2603:10b6:510:202::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Wed, 14 Sep
 2022 07:26:03 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::18a5:7a35:3bb2:929b]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::18a5:7a35:3bb2:929b%3]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 07:26:03 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool-next] netlink: settings: Enable link modes advertisement according to lanes
Date:   Wed, 14 Sep 2022 10:25:47 +0300
Message-Id: <20220914072547.4070658-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0158.eurprd09.prod.outlook.com
 (2603:10a6:800:120::12) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|PH7PR12MB7163:EE_
X-MS-Office365-Filtering-Correlation-Id: e39e64a7-a7a7-41cb-3ab9-08da96226160
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QIXzBKoLqxZJi9EaJMSwmob2xSzmtd1+qgqD8t0oBIT3Vn9597NQhK299GBPuY42dlTQ1rIlcixQNnTQYAA4S1k07BUCvYcejd4DycTVlpkg64kfUF5CJHADICglDG42hRQfkgORMhKxyiDNDPvsaAbbmEHPrsY6N1Wmes8g4ndxK5PJWj95dONISxOtdvugBnzADtQqOtjw3Nn2NAqNUfv9wJncGUkBKbKBKMQSybU/4xMvqUkQmSS21g3A4E8TIRVBUVCEv8W0m7zrLXDJiqgZ6Wo7KbsDohoqNiKgG4evvodABjdKdAJZd+s2DN0WgiXL73Dg+UsRHCCbN+REZv24yVg5NYi/ApM3nWFhWQwrNJTypakRljpZfNRrxVAJ35iV29uilhCadj847SHTOlOdVbv6wP5IM4eMdPWyDrleukzKPHloKfF9Z42EZrFuxmmvYwi/NHlssmuBXiZWGTgx4yQ/DQvdQEHxJCgIXld1GUM/rmoJEWhR5lXyFXr9s4ehibcAvCbVgDExSCIzot5ofu7+HtME44Kd4dU4RkuvIOlr1agn4VDpQ0ZV8HUoyDe/jAqyYyt7Ug2bIN74L9XRLMvrR3Kya5POyDDbDEvie+EsMywSmiyeU+whry5gdCeuLZ2zAX+h01yXzbDji768UgdpQfoH/YRw/KTKAdL0MCJAueq8GTP+/n7lTpSOUQBFk3JInpRMqYgpHRw5zA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(136003)(376002)(39860400002)(346002)(451199015)(4326008)(8936002)(86362001)(41300700001)(6506007)(316002)(66946007)(2616005)(6916009)(6666004)(26005)(5660300002)(36756003)(6486002)(83380400001)(2906002)(66556008)(107886003)(186003)(38100700002)(1076003)(8676002)(478600001)(6512007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rF3niFSwbtjB2LL+LUkB10CtAnKW21VoMRNPb0MDqzNAX6PcgDz65uuDPbQO?=
 =?us-ascii?Q?9qohc75BJERzgKW1ygOAWMbJoxXI1bqP3RNq61sZk6XyxsvQ7QZq5EqWwSq+?=
 =?us-ascii?Q?hC8HdINCLF+63hbw+cxZAghrwSd6AO613Gld90em9i113BmTwudZt2w2oFFa?=
 =?us-ascii?Q?h1Hf+/fSWTHV6d03AY6Cs8TJ+xJPF/DXhG9VadtlTCsg12bYt3l7BfqC7LWS?=
 =?us-ascii?Q?JEe1kbLNS+MFCYNo2ALxgBvpTq0iKDL4BgIdC9TiDDxxuFKuXOCo++f9LnOi?=
 =?us-ascii?Q?V7eJatmbnbJ1h6ENyYE2pieqQ2yftImJrNzMs6EzCBCn+sV3G62IpngYwp1l?=
 =?us-ascii?Q?CttBmmpCXiK/eu7o3gl62epysiXDdSIy/fPU9mBu3eIAaIdMG3z0dvum98Hh?=
 =?us-ascii?Q?i8ogQQ9KSAD/PrkHXHkk6bTVGUdldDI1uX4UHKIAWb3OIC+SRMmQhp+3qtAs?=
 =?us-ascii?Q?AalZiSWiO435JFNaLh5PmObwcG6vo7OHIqw52HcRXLb0fQrz5TjFdUgp3dUT?=
 =?us-ascii?Q?MOYRPXbZMs3XfaBPgNCHMtzTlXkp9O5Jfeu6unHkc6Wk79UX/JrMy7nB40Ef?=
 =?us-ascii?Q?RPolScEKovdmzxEuwmPBffmmJJqij1gwxJsi6r8Ag3y/HhRjh8IrbR8oNiIs?=
 =?us-ascii?Q?4mrSfTr94JzCLYVfzC4dj5DFcdAM/FdEo916q7y0RAC/z1KlF69TezIia/7A?=
 =?us-ascii?Q?0R43IdVhTSNiG+0cH16MQ7w/WAQ1ra12FgC/IZVn0bYp92lOUmSx9kTNpD/D?=
 =?us-ascii?Q?CS3S6DupnB//g8LnPF4MxRBEPJ+LhHdgoAT9eG+Zc1ZWx077fbH5rsap/8Pp?=
 =?us-ascii?Q?+uiJBuczV4E7zX9FXivPKg6PdN0d1T0AzaS67h/Ykz80tNnDcmps9BxXtmhy?=
 =?us-ascii?Q?bKdD4+eqJ4X8x1eJocUDEJE8kd4AcbYDEKnWWshLMMt5OzuR3iVtmQD0M9gc?=
 =?us-ascii?Q?Ryrus3wVjOU0sCu+f8bNuvnsqHft7uyhnRpSQEs4CfT7vIlVq+6fQ5RlJ4QE?=
 =?us-ascii?Q?nprQaFXlH/pPC0v7ubJ6GxI9PpvaOkMWw7vIZjaa4VZYZIyz1PSpUF5jrHpc?=
 =?us-ascii?Q?Zt2YoB9hAxyQEGDfJ6XPK0qCm4uSwnkIf80k+hQ8JcUX4YDpWZ1lmKz3GZ+P?=
 =?us-ascii?Q?K1oZ6YvXmH2i5V+yNjF3iJfz7TtopNRJ+xVnvYeZgg3pRxSw8WVhv+SDj4vg?=
 =?us-ascii?Q?1dDWVQ617BT9nAMGEtnh/8f/ECKtIa7RIsUAqxDgO8CnLTruqoeWrVzuqlvO?=
 =?us-ascii?Q?h9Vun6FRUL0KQFV/tQdhJPp6BQx0hwzmzgeYowT7p9dlrkQ9ZHdpuDcdxRE6?=
 =?us-ascii?Q?EAZDdA6odk3rhkAuqplsChnBs6zxs5QrNHfHvAsYH5xG61Fom3rh2RtfFR4M?=
 =?us-ascii?Q?MoPwT9Xk1jt+3JOiSWI4BAN+6ptEgD5uPI5YZMk82FswhZUfF7wTSb2INz4l?=
 =?us-ascii?Q?qHICerH5vUOwD3UoALwzcMMYrvdTk8TTLTdTu75xZ23YooHehT9bj/JMpXiD?=
 =?us-ascii?Q?NCtMUDUF4ZVeGaQuG8ZdPU9NhNFG74dz4ttddlCDqbFncesLNUtN7t8HYF2I?=
 =?us-ascii?Q?b7oDwpTkMZaTKdA40Y4D13UtWwVGbReFE3MtH/ES?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e39e64a7-a7a7-41cb-3ab9-08da96226160
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 07:26:03.4190
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fFmcE9+fjWvJ9wQWzxZYVe1z0shYKOweddm8++JJiK8FoX3uQZ9aRTw6SZLh/QGLD4oE+YAZAvwAGdEPuZxA8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7163
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When user space does not pass link modes to advertise (via
'ETHTOOL_A_LINKMODES_OURS'), but enables auto-negotiation (via
'ETHTOOL_A_LINKMODES_AUTONEG'), the kernel will instruct the underlying
device driver to advertise link modes according to passed speed (via
'ETHTOOL_A_LINKMODES_SPEED'), duplex (via 'ETHTOOL_A_LINKMODES_DUPLEX')
or lanes (via 'ETHTOOL_A_LINKMODES_LANES').

It is not currently possible to have ethtool instruct the kernel to
perform advertisement solely based on lanes, as ethtool incorrectly
instructs the kernel to simply advertise all the "real" link modes [1].
This is caused by ethtool treating both of these commands as equivalent:

 # ethtool -s swp1 autoneg on
 # ethtool -s swp1 autoneg on lanes 1

Address this by having ethtool recognize that it should not advertise
all the "real" link modes when only "lanes" parameter is specified.

Before:

 # ethtool -s swp1 autoneg on lanes 1
 # ethtool swp1
 [...]
        Advertised link modes:  1000baseT/Full
                                10000baseT/Full
                                1000baseKX/Full
                                10000baseKR/Full
                                10000baseR_FEC
                                40000baseKR4/Full
                                40000baseCR4/Full
                                40000baseSR4/Full
                                40000baseLR4/Full
                                25000baseCR/Full
                                25000baseKR/Full
                                25000baseSR/Full
                                50000baseCR2/Full
                                50000baseKR2/Full
                                100000baseKR4/Full
                                100000baseSR4/Full
                                100000baseCR4/Full
                                100000baseLR4_ER4/Full
 [...]

After:

 # ethtool -s swp1 autoneg on lanes 1
 # ethtool swp1
 [...]
        Advertised link modes:  1000baseT/Full
                                10000baseT/Full
                                1000baseKX/Full
                                10000baseKR/Full
                                10000baseR_FEC
                                25000baseCR/Full
                                25000baseKR/Full
                                25000baseSR/Full
                                10000baseCR/Full
                                10000baseSR/Full
                                10000baseLR/Full
                                10000baseER/Full
                                50000baseKR/Full
                                50000baseSR/Full
                                50000baseCR/Full
                                50000baseLR_ER_FR/Full
                                50000baseDR/Full

[1]
 # ethtool --debug 0xff -s swp1 autoneg on lanes 1
 [...]
 sending genetlink packet (96 bytes):
     msg length 96 ethool ETHTOOL_MSG_LINKMODES_SET
     ETHTOOL_MSG_LINKMODES_SET
         ETHTOOL_A_LINKMODES_HEADER
             ETHTOOL_A_HEADER_DEV_NAME = "swp1"
         ETHTOOL_A_LINKMODES_AUTONEG = on
         ETHTOOL_A_LINKMODES_LANES = 1
         ETHTOOL_A_LINKMODES_OURS
             ETHTOOL_A_BITSET_SIZE = 93
             ETHTOOL_A_BITSET_VALUE = 20:10:9a:87 ff:5d:f0:ff e7:03:00:00
             ETHTOOL_A_BITSET_MASK = 20:10:9a:87 ff:5d:f0:ff e7:03:00:00
 [...]

Reported-by: Maksym Yaremchuk <maksymy@nvidia.com>
Tested-by: Maksym Yaremchuk <maksymy@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
Targeting at "ethtool-next" because this is not a regression (never
worked), but rather the result of an incomplete implementation in commit
107ee330ec7b ("netlink: settings: Add netlink support for lanes
parameter").
---
 netlink/settings.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/netlink/settings.c b/netlink/settings.c
index 3cf816f06299..dda4ac9bcf35 100644
--- a/netlink/settings.c
+++ b/netlink/settings.c
@@ -1193,8 +1193,9 @@ static int linkmodes_reply_advert_all_cb(const struct nlmsghdr *nlhdr,
 }
 
 /* For compatibility reasons with ioctl-based ethtool, when "autoneg on" is
- * specified without "advertise", "speed" and "duplex", we need to query the
- * supported link modes from the kernel and advertise all the "real" ones.
+ * specified without "advertise", "speed", "duplex" and "lanes", we need to
+ * query the supported link modes from the kernel and advertise all the "real"
+ * ones.
  */
 static int nl_sset_compat_linkmodes(struct nl_context *nlctx,
 				    struct nl_msg_buff *msgbuff)
@@ -1208,7 +1209,8 @@ static int nl_sset_compat_linkmodes(struct nl_context *nlctx,
 	if (ret < 0)
 		return ret;
 	if (!tb[ETHTOOL_A_LINKMODES_AUTONEG] || tb[ETHTOOL_A_LINKMODES_OURS] ||
-	    tb[ETHTOOL_A_LINKMODES_SPEED] || tb[ETHTOOL_A_LINKMODES_DUPLEX])
+	    tb[ETHTOOL_A_LINKMODES_SPEED] || tb[ETHTOOL_A_LINKMODES_DUPLEX] ||
+	    tb[ETHTOOL_A_LINKMODES_LANES])
 		return 0;
 	if (!mnl_attr_get_u8(tb[ETHTOOL_A_LINKMODES_AUTONEG]))
 		return 0;
-- 
2.37.1

