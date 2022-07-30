Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3B945859A4
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 11:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234571AbiG3Jfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 05:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234521AbiG3Jfy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 05:35:54 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2040.outbound.protection.outlook.com [40.107.212.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83E415A20
        for <netdev@vger.kernel.org>; Sat, 30 Jul 2022 02:35:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KTqAYhhKfKD9qL6RJvKSrWtQAGPOAIlESHi7fT5QgOdc9k6SJFEkSabdsly4iy7smvYe4X2z+hdx9afAFAYj+yWx8A7k+n1QL821W6Eq2ST7dG3AN0ZK1s0FIcl301BxTPSYc3HgNSsQCudgbrZwFUldL0H2/l014Xwy5QSVvAxLpvfHQi7TjeQnXm7OmnKawDbu0cRVR8nDyWcYZ9VfUHAZuV6Vh6Me0jM4/QPcwF4nlGbLf79261Ih1CNVBpEkF7qpdZ38RvX2hDTnDkgoZIpOl0crPlW5u6bcAULyn3qPH3iUNdh/qyr32WjV3gwSttfJXRna9T8KzlQPL+dykg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Dg3q1OO2Q5TqH3+S4h+kQNUkFs4LvNj8hx55QcrhOQ=;
 b=LuEyr17tGl3gMEJ5vObapmHorfG1i4mmSGpZoFhljpqh0jyb/l2XS9PPpmgVpRXi+sx7Qqu/PGpnWtvqDdQvTmx6PAzaLwKN5NRwXFxJa7zayZk7q4wrxhDUxwdqCKuO8/zx6k/L5poY32XbmDEpUCeRwtphglrd7Lza0CNsBwoNGahce1WvoEt4VX6JU9mJAUmBTrOSzQudkibpUqHBGAzuMzAQwzoHKz8TEllHdFjfGZTwkxOj/U7zwN0UlTNslYixU2rK4jfs38SrSin7ycBiMV+agQQISQesTClLidxC1JxPPmm9yxqc8G7DXblR4Ex+If5CHQQgqB481WoO3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Dg3q1OO2Q5TqH3+S4h+kQNUkFs4LvNj8hx55QcrhOQ=;
 b=UCbW6HGKx/lnzsRExlrN0siHAnE+Kulk+fk/0KIfQWWXEFy9YAXgMYwtE0vjYCg7S69NkmVYb3VIjqs5wiK5fca+PAdBjtLnydftUgP0/Gc1Q9QEKLeFqhUBFHsyzRJJ2N30vYnhIWl2EwNDHpaUB43EcPlqBaZlCK/6mN98Q0jq34Y+ZssZRdlT/p/TXlBtfr/qyaYigSwaf9ysaYgjgnMCScO1h5/PNKGAowoaVrwTpgdYUn1HdYMM3Gy00Pqkjv/JKJ13iYnxxFkncRVLS2gnju3yxOQ0WfRE+PjYi6KWAWjQaW2nimz1TawaBhXVS4Kii8quju/URqCMZ0Bb2Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB5979.namprd12.prod.outlook.com (2603:10b6:208:37e::15)
 by BYAPR12MB3605.namprd12.prod.outlook.com (2603:10b6:a03:ae::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.20; Sat, 30 Jul
 2022 09:35:49 +0000
Received: from MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::4c33:6e01:fd71:d2e0]) by MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::4c33:6e01:fd71:d2e0%6]) with mapi id 15.20.5482.011; Sat, 30 Jul 2022
 09:35:49 +0000
Date:   Sat, 30 Jul 2022 11:35:45 +0200
From:   Jiri Pirko <jiri@nvidia.com>
To:     Vikas Gupta <vikas.gupta@broadcom.com>
Cc:     dsahern@kernel.org, stephen@networkplumber.org, kuba@kernel.org,
        netdev@vger.kernel.org, edumazet@google.com,
        michael.chan@broadcom.com, andrew.gospodarek@broadcom.com
Subject: Re: [PATCH iproute2-next v4 2/3] devlink: add support for running
 selftestst
Message-ID: <YuT7cbvnlYRRdjma@nanopsycho>
References: <20220729101821.48180-1-vikas.gupta@broadcom.com>
 <20220729101821.48180-3-vikas.gupta@broadcom.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220729101821.48180-3-vikas.gupta@broadcom.com>
X-ClientProxiedBy: AM6P195CA0081.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:86::22) To MN0PR12MB5979.namprd12.prod.outlook.com
 (2603:10b6:208:37e::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b9496617-4eb7-48a7-ef3c-08da720ee331
X-MS-TrafficTypeDiagnostic: BYAPR12MB3605:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3xHyHzRbK8H+VmruXTh6NH2HXYrakES3GlpIBDytZB7xgPWIu4OK0lB3WqUUJa0FYqdH3uVnCHHKmgla2uV5tGMFp9Tt24RTt3irqEtv9lHozIIhM++aAAxwoKY83gfGwzA6ZkhVzNYTvr1DWYiRGmWtQrZf9MXeFDlGCssS0RNSfj54qW2eGsqCJVVWEmmu1rMOHp0/Hqml7uz9JXd1w0mlEkr33XcLlabLiDulAQOOklU/Yw2mpS2zqapUkZOrW3tX0pXG7DZ2Ij73Pxdt6uzHEN6+Y6yl11pIet5Jz4STp/dMz7l0zDdEEo48jPPvuXMamP3qI4YAGD/aqi150uZWbV0ROqQ/cQiEf83g2NZAsZSxZsDgLw+sDlJZEvwKazZ3XbPgFr42MfS/dgZ/ieqaF8p4Qb+4jkEYOjyzCXOGd3TW+OzfZrEYhNukE2WpsEb/E21hUtb6A4zrRJJ8rhlneIjYkMybDC6gX99BsjyTF1oVRDo2goWt+jZbh04bplHxwgCWm9hP72wMzGIx9PJgdgnWoZJOE3XTmm9m9fgvJZH8kgLhvIKRgVvAbkSnxqd1JqrqGX+Er/SBbr8x0SitJeP3wQmSrU584LHQyhsdA8WM4nFw2BhkepVhgVMlrFc+XtBg8HbgxZSWjtIhUhDUXwAsB6SLAZlJMyCJ1KA9In5XIKYaKFmEX+hWDJ3xtwoBVHkSNM50LFal4jHO4V+5lM4CFRhc15e9clW3+1c85CyeKzawowFl53ubfppj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5979.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(346002)(39860400002)(136003)(396003)(366004)(376002)(6506007)(8936002)(6486002)(6512007)(478600001)(33716001)(38100700002)(30864003)(83380400001)(5660300002)(6666004)(8676002)(26005)(316002)(2906002)(41300700001)(66556008)(6916009)(4326008)(186003)(9686003)(66476007)(66946007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FKc2oaGHFvKBKiRv5ZYt9IUTqnm8IFpeGOwZn8EIS8TCT55ihkwNF9e8tb3C?=
 =?us-ascii?Q?I2ihth9kgOe39ZHOVY99pJSMNWMflT7DBuupvT3EqXc1VAxRKYw4ZSLvLp1Y?=
 =?us-ascii?Q?sluMGuaYnq4NIMig6UVr4Leo8okCjplo8PuTk9xC8rZpQADVx7QcURTyEpzn?=
 =?us-ascii?Q?xfg2LVt7C1sA1WaP42VZjARaGvFtMsbINU3ukLDBlodm26cFgtnrl5q3icaD?=
 =?us-ascii?Q?S7EdlCf2OJE/FsQAgrc0Mh472iaJEqfK4cw3/MCNzt/+mh5pD1G2Ak2BFymq?=
 =?us-ascii?Q?aYfKQ55OP5AQS6pjBEKA0li5EJq6dg8oVdjHrUtfZb/3ieaBRWsDMug+gnHf?=
 =?us-ascii?Q?aH0ipVMWK0VTkV/pZQSAemoOHtQEhYILQwaHvToCiDs7Uo95OrdnSIOAbE3j?=
 =?us-ascii?Q?9uo2we1ACAsuc5SJoWB2jIfP7p9pvort7PxfrRcehadxGRQgE99CVHa+N8rs?=
 =?us-ascii?Q?qHwF09LslShdLXnHBs26jfrfAXnEzKL9kyWDyZpITT8hhIa4snGj0MjqlqVe?=
 =?us-ascii?Q?B36o7WPTtpockPriBR6TqcLl5PW9YT83u6rVEnyVqROOiVQp49h42Heu08T5?=
 =?us-ascii?Q?NPNdx53d+X2Yd2Qr/gHEpHFggQfoWa6iU/JV23dG6t6rzmQcYBglD+PFfAEK?=
 =?us-ascii?Q?kYvaEXCMPdlI3O9nbsbWwwJT16EvNuiuRLxN6VKN1QHqKfq5wXUO5Gp0INV1?=
 =?us-ascii?Q?YnTxLqLw+BWOye+ZUzCyp73gXUHamjbqLbcQkRvbIqrCkftIailacVo9Hgi7?=
 =?us-ascii?Q?Et8sdsDVygdShAjtBytkccZqqcr7aWRcjnJIFwC+1//qNQiG/UzYkHja9CWn?=
 =?us-ascii?Q?CrkVH2OdMw7mZNDj+J2/XZJ1/QgMTT6CM1G1r/TfqaYYa2nsT6VHbRya+Aq3?=
 =?us-ascii?Q?qvYkNmLmk3rv2mGK/mTGwnDGuVbAt39bZhrw9kf9hcc2KCfHvlhp/MYL4wjY?=
 =?us-ascii?Q?ycRLGu3mCoFQ4f19iiNgqS4GsF+GNxVq4nLmljiv4SSPMsdn7+Jm4EP8s+M8?=
 =?us-ascii?Q?UyP1iMtmSSM/5lis7OtniwzvlicbhcUhrMsS/3wfXHowa14WFEY8grSiPIRe?=
 =?us-ascii?Q?ezp2CyZaMI2D5y2ITPK6L40ptQmsMGvVVdKZnQXp29mEiHWquwtgFVI/mOxW?=
 =?us-ascii?Q?hMppQ8kCdxnNEUDn25X1AG8UnwY0OWusWNzc2kqnbM7YBQl8rISfhextRHXc?=
 =?us-ascii?Q?hsosT5lhd87kVj83Q7ofmkygfc7GNECle9FlRw5zQItZeQZNT9eZARZaazen?=
 =?us-ascii?Q?ymNXMZdmHxb9EUGSzEcPE5YHcf4HM4mOi8OcJSqdKvldILi/b3hiQCExH8HL?=
 =?us-ascii?Q?OhoNfEcedPzS5c+8e5jC0Vx+9G2GKPyuiV8IxupA7jhWmwmfW1Nl3swZJHvI?=
 =?us-ascii?Q?iy0M2zpUXBCsWLb6LiomUweCSAhMr7T/77HCnc7bm1LeI+ZvJT0RngUpTUZg?=
 =?us-ascii?Q?Y/7nU4iIfTfF7hv0++qhkYrLRzMzZpPd9/mI5YtBiT7Iuhbr9IP+i+mcskQq?=
 =?us-ascii?Q?e+9B1H/KJ3S65vm0IeZnGjQTUMz6gsjerBNJJu+Ta0y9aghNqsPNvopLtSfX?=
 =?us-ascii?Q?HmFCyiu1K2ZNrYO+y/sLCobCVYtDj8Gw6zzJb6T/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9496617-4eb7-48a7-ef3c-08da720ee331
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5979.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2022 09:35:49.6124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UzxeI3MSTeRh4WPJMT1eEZQo8aPOALVW1dAo7XHQyVLQLdT/Qd+RGRXJcTv6U44/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3605
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jul 29, 2022 at 12:18:20PM CEST, vikas.gupta@broadcom.com wrote:
>Add command and helper APIs to run selfests.
>Also add a selftest for a non volatile memory i.e. flash.
>
>Examples:
>$ devlink dev selftests run pci/0000:03:00.0 id flash
>pci/0000:03:00.0:
>    flash:
>      status passed
>
>$ devlink dev selftests show pci/0000:03:00.0
>pci/0000:03:00.0
>      flash

Please include json outputs as well.


>
>Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
>---
> devlink/devlink.c | 294 ++++++++++++++++++++++++++++++++++++++++++++++

> 1 file changed, 294 insertions(+)
>
>diff --git a/devlink/devlink.c b/devlink/devlink.c
>index ddf430bb..5ab11345 100644
>--- a/devlink/devlink.c
>+++ b/devlink/devlink.c
>@@ -294,6 +294,7 @@ static void ifname_map_free(struct ifname_map *ifname_map)
> #define DL_OPT_PORT_FN_RATE_TX_MAX	BIT(49)
> #define DL_OPT_PORT_FN_RATE_NODE_NAME	BIT(50)
> #define DL_OPT_PORT_FN_RATE_PARENT	BIT(51)
>+#define DL_OPT_SELFTESTS		BIT(52)
> 
> struct dl_opts {
> 	uint64_t present; /* flags of present items */
>@@ -354,6 +355,7 @@ struct dl_opts {
> 	uint64_t rate_tx_max;
> 	char *rate_node_name;
> 	const char *rate_parent_node;
>+	bool selftests_opt[DEVLINK_ATTR_SELFTEST_ID_MAX + 1];
> };
> 
> struct dl {
>@@ -693,6 +695,7 @@ static const enum mnl_attr_data_type devlink_policy[DEVLINK_ATTR_MAX + 1] = {
> 	[DEVLINK_ATTR_TRAP_POLICER_ID] = MNL_TYPE_U32,
> 	[DEVLINK_ATTR_TRAP_POLICER_RATE] = MNL_TYPE_U64,
> 	[DEVLINK_ATTR_TRAP_POLICER_BURST] = MNL_TYPE_U64,
>+	[DEVLINK_ATTR_SELFTESTS] = MNL_TYPE_NESTED,
> };
> 
> static const enum mnl_attr_data_type
>@@ -1401,6 +1404,17 @@ static struct str_num_map port_fn_opstate_map[] = {
> 	{ .str = NULL, }
> };
> 
>+static int selftests_get(const char *selftest_name, bool *selftests_opt)
>+{
>+	if (strcmp(selftest_name, "flash") == 0) {
>+		selftests_opt[0] = 1;

s/1/true/

Use attr as an index here instead of "0".



>+	} else {
>+		pr_err("Unknown selftest \"%s\"\n", selftest_name);
>+		return -EINVAL;
>+	}
>+	return 0;
>+}
>+
> static int port_flavour_parse(const char *flavour, uint16_t *value)
> {
> 	int num;
>@@ -1490,6 +1504,7 @@ static const struct dl_args_metadata dl_args_required[] = {
> 	{DL_OPT_PORT_FUNCTION_HW_ADDR, "Port function's hardware address is expected."},
> 	{DL_OPT_PORT_FLAVOUR,          "Port flavour is expected."},
> 	{DL_OPT_PORT_PFNUMBER,         "Port PCI PF number is expected."},
>+	{DL_OPT_SELFTESTS,             "Test name is expected"},
> };
> 
> static int dl_args_finding_required_validate(uint64_t o_required,
>@@ -1793,6 +1808,20 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
> 				return err;
> 			o_found |= DL_OPT_FLASH_OVERWRITE;
> 
>+		} else if (dl_argv_match(dl, "id") &&
>+				(o_all & DL_OPT_SELFTESTS)) {
>+			const char *selftest_name;
>+
>+			dl_arg_inc(dl);
>+			err = dl_argv_str(dl, &selftest_name);
>+			if (err)
>+				return err;
>+			err = selftests_get(selftest_name,
>+					    opts->selftests_opt);
>+			if (err)
>+				return err;
>+			o_found |= DL_OPT_SELFTESTS;
>+
> 		} else if (dl_argv_match(dl, "reporter") &&
> 			   (o_all & DL_OPT_HEALTH_REPORTER_NAME)) {
> 			dl_arg_inc(dl);
>@@ -2063,6 +2092,34 @@ dl_reload_limits_put(struct nlmsghdr *nlh, const struct dl_opts *opts)
> 	mnl_attr_put(nlh, DEVLINK_ATTR_RELOAD_LIMITS, sizeof(limits), &limits);
> }
> 
>+static void
>+dl_selftests_put(struct nlmsghdr *nlh, const struct dl_opts *opts)
>+{
>+	bool test_sel = false;
>+	struct nlattr *nest;
>+	int id;
>+
>+	nest = mnl_attr_nest_start(nlh, DEVLINK_ATTR_SELFTESTS);
>+
>+	for (id = DEVLINK_ATTR_SELFTEST_ID_UNSPEC + 1;
>+	     id <= DEVLINK_ATTR_SELFTEST_ID_MAX &&
>+		opts->selftests_opt[id]; id++) {
>+		if (opts->selftests_opt[id]) {
>+			test_sel = true;
>+			mnl_attr_put(nlh, id, 0, NULL);
>+		}
>+	}
>+
>+	/* No test selcted from user, select all */

s/selcted/selected/

I wonder if that is desired behaviour. I guess so. I can't think of
anything better.



>+	if (!test_sel) {
>+		for (id = DEVLINK_ATTR_SELFTEST_ID_UNSPEC + 1;
>+		     id <= DEVLINK_ATTR_SELFTEST_ID_MAX; id++)
>+			mnl_attr_put(nlh, id, 0, NULL);
>+	}
>+
>+	mnl_attr_nest_end(nlh, nest);
>+}
>+
> static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
> {
> 	struct dl_opts *opts = &dl->opts;
>@@ -2157,6 +2214,8 @@ static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
> 				  opts->flash_component);
> 	if (opts->present & DL_OPT_FLASH_OVERWRITE)
> 		dl_flash_update_overwrite_put(nlh, opts);
>+	if (opts->present & DL_OPT_SELFTESTS)
>+		dl_selftests_put(nlh, opts);
> 	if (opts->present & DL_OPT_HEALTH_REPORTER_NAME)
> 		mnl_attr_put_strz(nlh, DEVLINK_ATTR_HEALTH_REPORTER_NAME,
> 				  opts->reporter_name);
>@@ -2285,6 +2344,8 @@ static void cmd_dev_help(void)
> 	pr_err("                              [ action { driver_reinit | fw_activate } ] [ limit no_reset ]\n");
> 	pr_err("       devlink dev info [ DEV ]\n");
> 	pr_err("       devlink dev flash DEV file PATH [ component NAME ] [ overwrite SECTION ]\n");
>+	pr_err("       devlink dev selftests show [DEV]\n");
>+	pr_err("       devlink dev selftests run DEV [id TESTNAME ]\n");
> }
> 
> static bool cmp_arr_last_handle(struct dl *dl, const char *bus_name,
>@@ -3904,6 +3965,236 @@ err_socket:
> 	return err;
> }
> 
>+static const char *devlink_get_selftest_name(int id)
>+{
>+	switch (id) {
>+	case DEVLINK_ATTR_SELFTEST_ID_FLASH:
>+		return "flash";
>+	default:
>+		return "unknown";
>+	}
>+}
>+
>+static const enum mnl_attr_data_type
>+devlink_selftest_id_policy[DEVLINK_ATTR_SELFTEST_ID_MAX + 1] = {
>+	[DEVLINK_ATTR_SELFTEST_ID_FLASH] = MNL_TYPE_FLAG,
>+};
>+
>+static int selftests_list_attr_cb(const struct nlattr *attr, void *data)
>+{
>+	const struct nlattr **tb = data;
>+	int type;
>+
>+	if (mnl_attr_type_valid(attr, DEVLINK_ATTR_SELFTEST_ID_MAX) < 0)
>+		return MNL_CB_OK;
>+
>+	type = mnl_attr_get_type(attr);
>+	if (mnl_attr_validate(attr, devlink_selftest_id_policy[type]) < 0)
>+		return MNL_CB_ERROR;
>+
>+	tb[type] = attr;
>+	return MNL_CB_OK;
>+}
>+
>+static int cmd_dev_selftests_show_cb(const struct nlmsghdr *nlh, void *data)
>+{
>+	struct nlattr *selftests[DEVLINK_ATTR_SELFTEST_ID_MAX + 1] = {};
>+	struct genlmsghdr *genl = mnl_nlmsg_get_payload(nlh);
>+	struct nlattr *tb[DEVLINK_ATTR_MAX + 1] = {};
>+	struct dl *dl = data;
>+	int avail = 0;
>+	int err;
>+	int i;
>+
>+	mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
>+
>+	if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME] ||
>+	    !tb[DEVLINK_ATTR_SELFTESTS])
>+		return MNL_CB_ERROR;
>+
>+	err = mnl_attr_parse_nested(tb[DEVLINK_ATTR_SELFTESTS],
>+				    selftests_list_attr_cb, selftests);
>+	if (err != MNL_CB_OK)
>+		return MNL_CB_ERROR;
>+
>+	for (i = DEVLINK_ATTR_SELFTEST_ID_UNSPEC + 1;
>+	     i <= DEVLINK_ATTR_SELFTEST_ID_MAX; i++) {
>+		if (!(selftests[i]))
>+			continue;
>+
>+		if (!avail) {
>+			__pr_out_handle_start(dl, tb, true, false);
>+			__pr_out_indent_inc();
>+			if (!dl->json_output)
>+				__pr_out_newline();
>+			avail = 1;
>+		}
>+
>+		check_indent_newline(dl);
>+		print_string(PRINT_ANY, NULL, "%s", devlink_get_selftest_name(i));
>+		if (!dl->json_output)
>+			__pr_out_newline();
>+	}
>+
>+	if (avail) {
>+		__pr_out_indent_dec();
>+		pr_out_handle_end(dl);
>+	}
>+
>+	return MNL_CB_OK;
>+}
>+
>+static const char *devlink_selftest_status_to_str(uint8_t status)
>+{
>+	switch (status) {
>+	case DEVLINK_SELFTEST_STATUS_SKIP:
>+		return "skipped";
>+	case DEVLINK_SELFTEST_STATUS_PASS:
>+		return "passed";
>+	case DEVLINK_SELFTEST_STATUS_FAIL:
>+		return "failed";
>+	default:
>+		return "unknown";
>+	}
>+}
>+
>+static const enum mnl_attr_data_type
>+devlink_selftests_result_policy[DEVLINK_ATTR_SELFTEST_RESULT_MAX + 1] = {
>+	[DEVLINK_ATTR_SELFTEST_RESULT] = MNL_TYPE_NESTED,
>+	[DEVLINK_ATTR_SELFTEST_RESULT_ID] = MNL_TYPE_U32,
>+	[DEVLINK_ATTR_SELFTEST_RESULT_STATUS] = MNL_TYPE_U8,
>+};
>+
>+static int selftests_status_attr_cb(const struct nlattr *attr, void *data)
>+{
>+	const struct nlattr **tb = data;
>+	int type;
>+
>+	if (mnl_attr_type_valid(attr, DEVLINK_ATTR_SELFTEST_RESULT_MAX) < 0)
>+		return MNL_CB_OK;
>+
>+	type = mnl_attr_get_type(attr);
>+	if (mnl_attr_validate(attr, devlink_selftests_result_policy[type]) < 0)
>+		return MNL_CB_ERROR;
>+
>+	tb[type] = attr;
>+	return MNL_CB_OK;
>+}
>+
>+static int cmd_dev_selftests_run_cb(const struct nlmsghdr *nlh, void *data)
>+{
>+	struct genlmsghdr *genl = mnl_nlmsg_get_payload(nlh);
>+	struct nlattr *tb[DEVLINK_ATTR_MAX + 1] = {};
>+	struct nlattr *selftest;
>+	struct dl *dl = data;
>+	int avail = 0;
>+
>+	mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
>+
>+	if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME] ||
>+	    !tb[DEVLINK_ATTR_SELFTESTS])
>+		return MNL_CB_ERROR;
>+
>+	mnl_attr_for_each_nested(selftest, tb[DEVLINK_ATTR_SELFTESTS]) {
>+		struct nlattr *result[DEVLINK_ATTR_SELFTEST_RESULT_MAX + 1] = {};
>+		uint8_t status;
>+		int err;
>+		int id;
>+
>+		err = mnl_attr_parse_nested(selftest,
>+					    selftests_status_attr_cb, result);
>+		if (err != MNL_CB_OK)
>+			return MNL_CB_ERROR;
>+
>+		if (!result[DEVLINK_ATTR_SELFTEST_RESULT_ID] ||
>+		    !result[DEVLINK_ATTR_SELFTEST_RESULT_STATUS])
>+			return MNL_CB_ERROR;
>+
>+		if (!avail) {
>+			__pr_out_handle_start(dl, tb, true, false);
>+			__pr_out_indent_inc();
>+			avail = 1;
>+			if (!dl->json_output)
>+				__pr_out_newline();
>+		}
>+
>+		id = mnl_attr_get_u32(result[DEVLINK_ATTR_SELFTEST_RESULT_ID]);
>+		status = mnl_attr_get_u8(result[DEVLINK_ATTR_SELFTEST_RESULT_STATUS]);
>+
>+		pr_out_object_start(dl, devlink_get_selftest_name(id));
>+		check_indent_newline(dl);
>+		print_string_name_value("status",
>+					devlink_selftest_status_to_str(status));
>+		pr_out_object_end(dl);
>+		if (!dl->json_output)
>+			__pr_out_newline();
>+	}
>+
>+	if (avail) {
>+		__pr_out_indent_dec();
>+		pr_out_handle_end(dl);
>+	}
>+
>+	return MNL_CB_OK;
>+}
>+
>+static int cmd_dev_selftests_run(struct dl *dl)
>+{
>+	struct nlmsghdr *nlh;
>+	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
>+	int err;
>+
>+	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_SELFTESTS_RUN, flags);
>+
>+	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE, DL_OPT_SELFTESTS);
>+	if (err)
>+		return err;
>+
>+	if (!(dl->opts.present & DL_OPT_SELFTESTS))
>+		dl_selftests_put(nlh, &dl->opts);
>+
>+	err = mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_dev_selftests_run_cb, dl);
>+	return err;
>+}
>+
>+static int cmd_dev_selftests_show(struct dl *dl)
>+{
>+	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
>+	struct nlmsghdr *nlh;
>+	int err;
>+
>+	if (dl_argc(dl) == 0)
>+		flags |= NLM_F_DUMP;
>+
>+	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_SELFTESTS_GET, flags);
>+
>+	if (dl_argc(dl) > 0) {
>+		err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE, 0);
>+		if (err)
>+			return err;
>+	}
>+
>+	err = mnlu_gen_socket_sndrcv(&dl->nlg, nlh, cmd_dev_selftests_show_cb, dl);
>+	return err;
>+}
>+
>+static int cmd_dev_selftests(struct dl *dl)
>+{
>+	if (dl_argv_match(dl, "help")) {
>+		cmd_dev_help();
>+		return 0;
>+	} else if (dl_argv_match(dl, "show") ||
>+		   dl_argv_match(dl, "list") || dl_no_arg(dl)) {
>+		dl_arg_inc(dl);
>+		return cmd_dev_selftests_show(dl);
>+	} else if (dl_argv_match(dl, "run")) {
>+		dl_arg_inc(dl);
>+		return cmd_dev_selftests_run(dl);
>+	}
>+	pr_err("Command \"%s\" not found\n", dl_argv(dl));
>+	return -ENOENT;
>+}
>+
> static int cmd_dev(struct dl *dl)
> {
> 	if (dl_argv_match(dl, "help")) {
>@@ -3928,6 +4219,9 @@ static int cmd_dev(struct dl *dl)
> 	} else if (dl_argv_match(dl, "flash")) {
> 		dl_arg_inc(dl);
> 		return cmd_dev_flash(dl);
>+	} else if (dl_argv_match(dl, "selftests")) {
>+		dl_arg_inc(dl);
>+		return cmd_dev_selftests(dl);
> 	}
> 	pr_err("Command \"%s\" not found\n", dl_argv(dl));
> 	return -ENOENT;
>-- 
>2.31.1
>


