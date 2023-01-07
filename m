Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0F6266105D
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 18:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232049AbjAGRKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 12:10:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjAGRKv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 12:10:51 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2051.outbound.protection.outlook.com [40.107.95.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6520EBF6
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 09:10:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SSZukPLHlDOJNanF37S/XqDrRyfltEqcL4SFtplL5bHBo0rXulnG9Sywv9JFGaemn225TIn5zXoKLNxFkGP/+aWoJCsL6uDB08UhTGzCJH2Z0LzTSriFKjbdbO40rVTW9xZOcf6+UJCNw/+vmUkSNHXMF9qk2zvllUxWxVjZo6zZgEMqUpGgn55txBVMbxtYVVFNfhtOWHHpyek4CF4EWjG7Q2C+fzaMLJbpP8mpp/pgo60sJnWREvwJMVagjtS771inIX+0bzmdjMqZGv/rLqJdo5aUeEv/yJuyoB5W4HY86fGRu76Xmn5Joa66dCtnt3//U/u48x8xOcySUNZTCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qQi/DNEqiDzdmJtHDI10jEPKk6RgSTjoq5nzbh2xBUE=;
 b=SGcodwpG+RthSePKd30c1GdRlkt6hc5ewQGaYBVsuqiZ8a0IlbhrvFnrPcech/a6/0tEzUtp1eskkRPYi8e0S/605MbPGQExrM0vm3VS4VaGUTb8d1N523RAfiU+7RzUX6BAQe/Xnn9E8GvEsgggvi42nKpG7kJmbw+YN7G9ayVA1tRjEehFDNY2JzbPzYlyjbFbB/Z933+KUHUGx3a8ZoYLE+5ncw4wiUPqGCrzH2tf1xcQRffj6c6ne3UWQO5I7KTH+u4LXlKsBYuJEJvGlVovgY2EZj9lvywiwcLISqhkF6aOnsOwpXJUJphtyOYSaGp1SASCxgoyI0SVg5f40w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qQi/DNEqiDzdmJtHDI10jEPKk6RgSTjoq5nzbh2xBUE=;
 b=dOFeaklhn6okcCkcq9+MWLpdgJ+Dm+5jppfRFaZM7WVF/fHM04pNqHL/k4vrOj/qPOnqGqinDWz9hFiO0ohqbHWpIs1xGoflNdOu7/NZoOBkUSQlYv3W5kQn5aKmbCy2vMrEs/Dz5b0qGQKUr6/Qgp58d8/OHTA0XB7e9uvPWZz8mb6LneEdYiipz7geMTjBg+0ubz81mIBDqmJZrhBVmECO/oN4tYTkvXQ6JHzkZjaekAu1X12WH5Uh6mjnVcmbQiLfRIGDU9OK7L55jelpBrGqr9A6HEtc/SD02T8mgUzztEKE4yecK09VEk9p9ggSj35pOfVilYy7+7FNympTaw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MW4PR12MB7431.namprd12.prod.outlook.com (2603:10b6:303:225::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Sat, 7 Jan
 2023 17:10:46 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5944.019; Sat, 7 Jan 2023
 17:10:46 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, willemb@google.com, simon.horman@netronome.com,
        john.hurley@netronome.com, harperchen1110@gmail.com,
        johannes@sipsolutions.net, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net] net/sched: act_mpls: Fix warning during failed attribute validation
Date:   Sat,  7 Jan 2023 19:10:04 +0200
Message-Id: <20230107171004.608436-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0107.eurprd04.prod.outlook.com
 (2603:10a6:803:64::42) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|MW4PR12MB7431:EE_
X-MS-Office365-Filtering-Correlation-Id: 29f2214c-508f-4b6b-1f1d-08daf0d21df8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sfn0k84RJvSBZAQCdEqc1a04xgeVXIcZ+IFeM/gxlD3DzRK54KcioJIC+U/TFwcgG2ccMdbmitb9obxptoQtZZpGFhzyyrWL8BNTznu9rPwkcts7goZGx7rdM05fsiPO1C6771Xvyp6f/LB7TDlPmC5ZjKAW6dXer1WaXv109NB2QcQVi4IT4swsSDh/NaXTUpra8bwoTu26rSpGSGHCgUYrw3vMFLInNGWW8qMefDFg/hHmBjmydqIddJ1uurAANAU0H6ZLuRuIyhR+BLfZhWdW1+hJyoD6zVlnUnxfiKZuG3AwqFE8xU5EZoVtcFTecDTtvctxCiX0w1s/XU18HNRTmFVFKiEesNU1RUEh99RsheklELOtbrbx2aXkzn106W/l9kD9vXsRwC/nqLFWrnzZcHDsJ1ngY5krN1Oe23MkZj/XdCkkOgmfgHdKg7kmV4WIgDel51opXvOg294F9Bk0S+9ooHRmx8Yl/Ukr64S+JtRfSuMflr4FnvJ25coNq8d8drJQRGBSVYI3F/b4ymN47PeF89g4DeP4SjOIhDqgRbgJo/voZqmnoBfeMWk/SL8yWZ0+WsSk8PEy9D6CWQzWaUFbP6xmMEBhEcWD6/DBl2F7IYb07vG9hryccw7cH2EAP1HVmA/k3GJLIVEa8l2ICQ6IGQr9uhCFouRYmGX8bxzoyM0RpvEQ8l2h7zwFUyNb7TdYUBNb13cknTKQyz6lzDFwEIZ19plj1FunotQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(396003)(346002)(376002)(366004)(451199015)(8936002)(2906002)(5660300002)(36756003)(7416002)(41300700001)(66476007)(66946007)(66556008)(8676002)(45080400002)(316002)(4326008)(6666004)(6486002)(966005)(6506007)(478600001)(26005)(6512007)(186003)(6916009)(2616005)(1076003)(107886003)(86362001)(83380400001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jSgU4Mffq9v9U0ZE+pshFD1ZQUxqWJGQAA7d6+QSuGhliouzVOGDIeStHvsD?=
 =?us-ascii?Q?ExKGgTAer3S+FJeJrXSY1x8dolu4j+kbxq8c81tmPgnvuVSkENgVF+ERufs3?=
 =?us-ascii?Q?6iZLgbmC/BGCejbqC89luKO54XdeWuir6Ox4AJkibPK+b9TOBV5ydQP+hfGQ?=
 =?us-ascii?Q?gqecv8w4NYAqo61lKsnlnq/9JIwt2uqGkq5zEsCfrrpjyEhe3D8osissmntZ?=
 =?us-ascii?Q?foBjzwzcz8LtkY8vPwE41/Bwws+CzmRIVMJkmooW2mAl8Mhy7a++bBdzIANH?=
 =?us-ascii?Q?qlEXbxlmWNNMxef0HvqKjlLahoVrETnIzUv7kU15Ghbddq7GhscXhmd4whlR?=
 =?us-ascii?Q?NEXgP8303MtPPYRMyrPXAdYT/gqA4NxhMf2SOeCDzRHgEF+4ZfeUHRFaZw25?=
 =?us-ascii?Q?E9lxLf4E1BlCiwbnEOOSycYW7ik6lfapCqozoInQBrI71Oijc4ZiHXix613I?=
 =?us-ascii?Q?hZhccnRiukDHQip7nRXSXWlVqCw36bc7YCUhGTP9k+qB3gMIhWQu1QRFywpI?=
 =?us-ascii?Q?P6U/C+xu0/Qo4B6UMMFtLl9vHgyY07TqtoE5G4CcrEWrnCm8u/fN7pCzYRmB?=
 =?us-ascii?Q?bA1LejEBYawntDqqEKK6ZIlEtTYzOQfWz0blXyMu2wUmd407yZu9tlkKwptc?=
 =?us-ascii?Q?UGZI9mazsjLzVPt4xbDFXzyzi1MezcBROYutQfXSEDhNsKcSik3shrHf9vdZ?=
 =?us-ascii?Q?w387EjFvDEbVLLsRcxUXFut2mZ5BuodXgiITg6nPD0If9t67uQLxHmOXJ8Xx?=
 =?us-ascii?Q?gpIBOctJGgNVA5KXdxC7L/YyBrxBr82CP3zJkJie0MIjvKAm+p7GYk6VSj8h?=
 =?us-ascii?Q?At/czDtd/4bAycb9z3gQFrbLG6uJrY3aOmu9fwhZzkXRtPz6rG4pT02HJT77?=
 =?us-ascii?Q?eZumIxjCadeiTTuJrJU2SNmk3OCDRDsJoJYNtIzuJ8EZTxdnBqGFQM4Tse50?=
 =?us-ascii?Q?pKTQrWoH0+Ft9LmYG1kiGBvxic7MkPh/9E5ETx31HwcawT6Gknm6bA3fS/RN?=
 =?us-ascii?Q?BEsjtXcJngPiuIqh2BczeTPXMVxX9kaXmwebYGQElKZ3V5zK4eqXs/DaMQtO?=
 =?us-ascii?Q?PJcT3fC5QNKkPnx1BvSe4/DuwGWk5pGw41OOBGWzW1Sq9sxmufU8/pZvyx0k?=
 =?us-ascii?Q?eN0eNXIZkeMqpiCB1s9LTwABGSlNR4nsrhQamQ2ZgIxnXRW8RoWfk6NfwKIG?=
 =?us-ascii?Q?bjB87+S5rYOtil5u4v+KEVTE2f4QeOMWOcMurwTXp3tlLAIzF8zvNojV5csc?=
 =?us-ascii?Q?8aelwZy3houDzQzRRuhIVFKNbayVkXniVHICymjIe6bzwECd2gFJC0m9uoC8?=
 =?us-ascii?Q?uDKnye/rWdIB+ksaU6vee1JkD/KnMY6Re7iFtJYtbHtOWO6suyanP0p4iKX0?=
 =?us-ascii?Q?6mVHX3j1JzMWSiegUfvFqnHvO3953f28Sb5sPS6/pIVXR8AAgPouX/YJeXbT?=
 =?us-ascii?Q?1IwbdVthEhHHrHo2hGtynjGg03q90+w65xpFbC4404RjIx+xkrhjhyfT61DB?=
 =?us-ascii?Q?YMVU1Ro4psALfmPabyWu0KuvEaiHHbQptnnBkIdByTJeWdFZG1bH6kBB5YnM?=
 =?us-ascii?Q?qxyjRiFQeT2i4NTU82D1ctvmOgRW/bMMgt+Y3QjZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29f2214c-508f-4b6b-1f1d-08daf0d21df8
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2023 17:10:46.4703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J99igELHIvg8PqdM17WVsn5yNPmnnrtxZtGkWCLwmMmEeYFKApd2X07tAeDw29lPaIYV9AU3a+X2wB11yehSIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7431
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'TCA_MPLS_LABEL' attribute is of 'NLA_U32' type, but has a
validation type of 'NLA_VALIDATE_FUNCTION'. This is an invalid
combination according to the comment above 'struct nla_policy':

"
Meaning of `validate' field, use via NLA_POLICY_VALIDATE_FN:
   NLA_BINARY           Validation function called for the attribute.
   All other            Unused - but note that it's a union
"

This can trigger the warning [1] in nla_get_range_unsigned() when
validation of the attribute fails. Despite being of 'NLA_U32' type, the
associated 'min'/'max' fields in the policy are negative as they are
aliased by the 'validate' field.

Fix by changing the attribute type to 'NLA_BINARY' which is consistent
with the above comment and all other users of NLA_POLICY_VALIDATE_FN().
As a result, move the length validation to the validation function.

No regressions in MPLS tests:

 # ./tdc.py -f tc-tests/actions/mpls.json
 [...]
 # echo $?
 0

[1]
WARNING: CPU: 0 PID: 17743 at lib/nlattr.c:118
nla_get_range_unsigned+0x1d8/0x1e0 lib/nlattr.c:117
Modules linked in:
CPU: 0 PID: 17743 Comm: syz-executor.0 Not tainted 6.1.0-rc8 #3
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.13.0-48-gd9c812dda519-prebuilt.qemu.org 04/01/2014
RIP: 0010:nla_get_range_unsigned+0x1d8/0x1e0 lib/nlattr.c:117
[...]
Call Trace:
 <TASK>
 __netlink_policy_dump_write_attr+0x23d/0x990 net/netlink/policy.c:310
 netlink_policy_dump_write_attr+0x22/0x30 net/netlink/policy.c:411
 netlink_ack_tlv_fill net/netlink/af_netlink.c:2454 [inline]
 netlink_ack+0x546/0x760 net/netlink/af_netlink.c:2506
 netlink_rcv_skb+0x1b7/0x240 net/netlink/af_netlink.c:2546
 rtnetlink_rcv+0x18/0x20 net/core/rtnetlink.c:6109
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x5e9/0x6b0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x739/0x860 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg net/socket.c:734 [inline]
 ____sys_sendmsg+0x38f/0x500 net/socket.c:2482
 ___sys_sendmsg net/socket.c:2536 [inline]
 __sys_sendmsg+0x197/0x230 net/socket.c:2565
 __do_sys_sendmsg net/socket.c:2574 [inline]
 __se_sys_sendmsg net/socket.c:2572 [inline]
 __x64_sys_sendmsg+0x42/0x50 net/socket.c:2572
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Link: https://lore.kernel.org/netdev/CAO4mrfdmjvRUNbDyP0R03_DrD_eFCLCguz6OxZ2TYRSv0K9gxA@mail.gmail.com/
Fixes: 2a2ea50870ba ("net: sched: add mpls manipulation actions to TC")
Reported-by: Wei Chen <harperchen1110@gmail.com>
Tested-by: Wei Chen <harperchen1110@gmail.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/sched/act_mpls.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
index ff47ce4d3968..6b26bdb999d7 100644
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -134,6 +134,11 @@ static int valid_label(const struct nlattr *attr,
 {
 	const u32 *label = nla_data(attr);
 
+	if (nla_len(attr) != sizeof(*label)) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid MPLS label length");
+		return -EINVAL;
+	}
+
 	if (*label & ~MPLS_LABEL_MASK || *label == MPLS_LABEL_IMPLNULL) {
 		NL_SET_ERR_MSG_MOD(extack, "MPLS label out of range");
 		return -EINVAL;
@@ -145,7 +150,8 @@ static int valid_label(const struct nlattr *attr,
 static const struct nla_policy mpls_policy[TCA_MPLS_MAX + 1] = {
 	[TCA_MPLS_PARMS]	= NLA_POLICY_EXACT_LEN(sizeof(struct tc_mpls)),
 	[TCA_MPLS_PROTO]	= { .type = NLA_U16 },
-	[TCA_MPLS_LABEL]	= NLA_POLICY_VALIDATE_FN(NLA_U32, valid_label),
+	[TCA_MPLS_LABEL]	= NLA_POLICY_VALIDATE_FN(NLA_BINARY,
+							 valid_label),
 	[TCA_MPLS_TC]		= NLA_POLICY_RANGE(NLA_U8, 0, 7),
 	[TCA_MPLS_TTL]		= NLA_POLICY_MIN(NLA_U8, 1),
 	[TCA_MPLS_BOS]		= NLA_POLICY_RANGE(NLA_U8, 0, 1),
-- 
2.37.3

