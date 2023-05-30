Return-Path: <netdev+bounces-6564-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D1E4716F09
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 22:46:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 947D71C20D48
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 20:46:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9E8519933;
	Tue, 30 May 2023 20:46:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A977E
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 20:46:42 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2077.outbound.protection.outlook.com [40.107.220.77])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 084AC8E
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 13:46:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SR8NWweULY19hW4wk7Gl51kSMnem9DZXRBytz0i3pK9L3yG/15GQgfNS5rSoN1Aiim6X0vHmvwu72D7zT+YoKWOVnlRhkYjBhTgZ2AzvkSLshQg81QE2EEdszinKoEiZfrdXuTopFTtJbXJnre8SHScO1V3vzswwtOpA+TJlmrbOfgnviDlnXReJYRDZHMUL5dfskzWniuBKcWo37kOeA6wJ4PxyMkGJigjyfNHqI7Sy4WDrcbJ6/fuC3e9OAMkgP2uIYxeWYe2oaQ0PREJwkaEZLc+GZx0lJFToe+4VmMzwDX7oXKnmZAsF/jSKah827wAV12OBGc2TD9kPsU9flQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/DIZe+d50VHtD8FTsABS+UvBvJy+jh/vHi4OgldRBCg=;
 b=nAJ9qa+RAiNV7TO4LjZTPf0TO4eXC0IKEyAWW+Pmj8TaTfWkNuQH/spx4o0wLrd8BmBZLoXeaTt0hPV6hoReAy5JjSiBlXOvj0hzHxFFOfDAYQoeefLahNNDuveXt4sFuKFsIyo4bt9XJybFSB/DBnjO1s5eOdkbFdk5eHGtLCvrWQVqXEIB/AmhVjogfkRm4NJYd5HB6eCgKTO2X3mFI4in8eiOjEOL5pz1mVvY15lXxjb0tYPkLZ9y6kaE85xj2TMtbgLlFKKlx70ApoHtGqf+xIlWeDD71UQKLM55THRzFwc89O8fh0G7KIElwu8a5SC4Xzc1OPCwAVj9jw8t3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=microchip.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/DIZe+d50VHtD8FTsABS+UvBvJy+jh/vHi4OgldRBCg=;
 b=ggQmrDUD8KEl3OHjsTD/jylO7zbqX+vynaXV5VEzqT0yDGOUgU+x/VJoLA7nnVu4tLNFl6e9APJzHM0+pgeTKU9e0NH+H/QsSa4Tqf+/sT+nwtGma3Si1HBl5cPP0Yo8KMmIdc4H8NmhDybwDQvGWeXhf0XamV/Mp26OoVTicG3brN2iDFAYpGDQ7zYsxs/K7goHDvxH4t+F9g2li2/N2WFpJHyE0WW/qLS3bjWmoTnGDhARtOgTiklOEaycDpzqaKYE80ZRzbcTpvzHUXRNmNdBV46/S5cDOrquxShGCGLdFqrYqaRlgekTIVZPu0iJJKargOk0eoC08jA+H5TXow==
Received: from BLAPR03CA0064.namprd03.prod.outlook.com (2603:10b6:208:329::9)
 by BL0PR12MB4948.namprd12.prod.outlook.com (2603:10b6:208:1cc::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Tue, 30 May
 2023 20:46:38 +0000
Received: from BL02EPF000145BB.namprd05.prod.outlook.com
 (2603:10b6:208:329:cafe::24) by BLAPR03CA0064.outlook.office365.com
 (2603:10b6:208:329::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23 via Frontend
 Transport; Tue, 30 May 2023 20:46:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF000145BB.mail.protection.outlook.com (10.167.241.211) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.18 via Frontend Transport; Tue, 30 May 2023 20:46:38 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 30 May 2023
 13:46:20 -0700
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 30 May
 2023 13:46:18 -0700
References: <20230510-dcb-rewr-v2-0-9f38e688117e@microchip.com>
 <20230510-dcb-rewr-v2-5-9f38e688117e@microchip.com>
User-agent: mu4e 1.6.6; emacs 28.1
From: Petr Machata <petrm@nvidia.com>
To: Daniel Machon <daniel.machon@microchip.com>
CC: <netdev@vger.kernel.org>, <dsahern@kernel.org>,
	<stephen@networkplumber.org>, <petrm@nvidia.com>,
	<UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH iproute2-next v2 5/8] dcb: rewr: add new dcb-rewr
 subcommand
Date: Tue, 30 May 2023 21:58:33 +0200
In-Reply-To: <20230510-dcb-rewr-v2-5-9f38e688117e@microchip.com>
Message-ID: <87sfbd4kfb.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000145BB:EE_|BL0PR12MB4948:EE_
X-MS-Office365-Filtering-Correlation-Id: d79ca250-4bc9-48cb-0be9-08db614ef755
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	6IbGVVwg6G8zOC77KOgCkALU37qzTa+cOnxVv42VXLwxOXBinsNKW7E/kxTVTBRO1C1sjOsaCor72k5xBQMeRh5L1cvV+c16Cgof6pX3BpAjfg21kOPj26DdoELJ1FhNmuP2DtXhXayDXqhoL52GRJfpBpBRojAAxOTnFJZSXBVvYnmrcHs3Y1K1xPuh17xS7EFsZJN5TQUtUn2OVQaXpqjpCH1gz1eEW8clRRTqt4cvAGraSTxDaCaGMJV0hstOykyhGXI528JtXDJhJiTLyx5AybFtYwSwAtr1GRK8LwWdEV/5PLhbb/34adf0yMOrpbEdAfop9BWQQyYsk/AeuELqzdrdxkJu1Y0KuvkEv6hhKNduWhW35cPiPy2CAYWqWxa6qmKFLpvGr9L7+JRg3DsCbVoJaTTn7gGi3+Hw/yYEjhI1LE4+avFaeTldGUBnrBKC2cMwsD+lK82dmts0w3X+31eOGTPFaHpwrJY1HINA9RFY6Wh8ODd9Eq8FuX2erVEU85I0+fyKO4GVb8FgkuTc5SEha8c603MAcDBVJdyLzCywRDzjg0lHPt1o4aMzw7RDGsLhhnbtHpqiOgiglNHyDHOzF43KspQ7/mmZHmZ0YLOQgw4QD8vip1/rcxaO95G8MWYYGtIkGSdYlzBAsC9bUBiVuEUAN4PHl8/u+4kWYroHmykMHDzB/QMikAGqBzJe5xIvE15Pb14g2ktGeEbXmeDSOd7h0/yqg+DALH6rCauHYNiFSVBtL+u/jkA7
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(39860400002)(376002)(346002)(451199021)(36840700001)(46966006)(40470700004)(316002)(356005)(83380400001)(70206006)(70586007)(36860700001)(2906002)(54906003)(26005)(6916009)(7636003)(4326008)(82740400003)(86362001)(426003)(47076005)(336012)(2616005)(478600001)(5660300002)(40460700003)(186003)(6666004)(16526019)(41300700001)(40480700001)(36756003)(8936002)(8676002)(82310400005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 20:46:38.5915
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d79ca250-4bc9-48cb-0be9-08db614ef755
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF000145BB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4948
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


Daniel Machon <daniel.machon@microchip.com> writes:

> Add a new subcommand 'rewr' for configuring the in-kernel DCB rewrite
> table. The rewr-table of the kernel is similar to the APP-table, and so
> is this new subcommand. Therefore, much of the existing bookkeeping code
> from dcb-app, can be reused in the dcb-rewr implementation.
>
> Initially, only support for configuring PCP and DSCP-based rewrite has
> been added.
>
> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>

Looks good overall, barring the comment about dcb_app_parse_mapping_cb()
that I made in the other patch, and a handful of nits below.

> ---
>  dcb/Makefile   |   3 +-
>  dcb/dcb.c      |   4 +-
>  dcb/dcb.h      |  32 ++++++
>  dcb/dcb_app.c  |  49 ++++----
>  dcb/dcb_rewr.c | 355 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 416 insertions(+), 27 deletions(-)

> diff --git a/dcb/dcb.h b/dcb/dcb.h
> index b3bc30cd02c5..092dc90e8358 100644
> --- a/dcb/dcb.h
> +++ b/dcb/dcb.h
> @@ -54,6 +54,10 @@ void dcb_print_array_on_off(const __u8 *array, size_t size);
>  void dcb_print_array_kw(const __u8 *array, size_t array_size,
>  			const char *const kw[], size_t kw_size);
>  
> +/* dcp_rewr.c */
> +
> +int dcb_cmd_rewr(struct dcb *dcb, int argc, char **argv);
> +
>  /* dcb_app.c */
>  
>  struct dcb_app_table {
> @@ -70,8 +74,29 @@ struct dcb_app_parse_mapping {
>  	int err;
>  };
>  
> +#define DCB_APP_PCP_MAX 15

This should be removed from dcb_app.c as well.

> +#define DCB_APP_DSCP_MAX 63

DCB_APP_DSCP_MAX should be introduced in a separate patch together with
the s/63/DCB_APP_DSCP_MAX/ of the existing code, instead of including it
all here. It's a concern separate from the main topic of the patch.

> +
>  int dcb_cmd_app(struct dcb *dcb, int argc, char **argv);
>  
> +int dcb_app_get(struct dcb *dcb, const char *dev, struct dcb_app_table *tab);
> +int dcb_app_add_del(struct dcb *dcb, const char *dev, int command,
> +		    const struct dcb_app_table *tab,
> +		    bool (*filter)(const struct dcb_app *));
> +
> +bool dcb_app_is_dscp(const struct dcb_app *app);
> +bool dcb_app_is_pcp(const struct dcb_app *app);
> +
> +int dcb_app_print_pid_dscp(__u16 protocol);
> +int dcb_app_print_pid_pcp(__u16 protocol);
> +int dcb_app_print_pid_dec(__u16 protocol);
> +void dcb_app_print_filtered(const struct dcb_app_table *tab,
> +			    bool (*filter)(const struct dcb_app *),
> +			    void (*print_pid_prio)(int (*print_pid)(__u16),
> +						   const struct dcb_app *),
> +			    int (*print_pid)(__u16 protocol),
> +			    const char *json_name, const char *fp_name);
> +
>  enum ieee_attrs_app dcb_app_attr_type_get(__u8 selector);
>  bool dcb_app_attr_type_validate(enum ieee_attrs_app type);
>  bool dcb_app_selector_validate(enum ieee_attrs_app type, __u8 selector);
> @@ -80,11 +105,18 @@ bool dcb_app_pid_eq(const struct dcb_app *aa, const struct dcb_app *ab);
>  bool dcb_app_prio_eq(const struct dcb_app *aa, const struct dcb_app *ab);
>  
>  int dcb_app_table_push(struct dcb_app_table *tab, struct dcb_app *app);
> +int dcb_app_table_copy(struct dcb_app_table *a, const struct dcb_app_table *b);
> +void dcb_app_table_sort(struct dcb_app_table *tab);
> +void dcb_app_table_fini(struct dcb_app_table *tab);
> +void dcb_app_table_remove_existing(struct dcb_app_table *a,
> +				   const struct dcb_app_table *b);
>  void dcb_app_table_remove_replaced(struct dcb_app_table *a,
>  				   const struct dcb_app_table *b,
>  				   bool (*key_eq)(const struct dcb_app *aa,
>  						  const struct dcb_app *ab));
>  
> +int dcb_app_parse_pcp(__u32 *key, const char *arg);
> +int dcb_app_parse_dscp(__u32 *key, const char *arg);
>  void dcb_app_parse_mapping_cb(__u32 key, __u64 value, void *data);
>  
>  /* dcb_apptrust.c */
> diff --git a/dcb/dcb_app.c b/dcb/dcb_app.c
> index 97cba658aa6b..3cb1bb302ed6 100644
> --- a/dcb/dcb_app.c
> +++ b/dcb/dcb_app.c

> @@ -643,9 +642,9 @@ static int dcb_app_add_del_cb(struct dcb *dcb, struct nlmsghdr *nlh, void *data)

> +static int dcb_cmd_rewr_replace(struct dcb *dcb, const char *dev, int argc,
> +				char **argv)
> +{

[...]

> +}
> +
> +

Two blank lines.

> +static int dcb_cmd_rewr_show(struct dcb *dcb, const char *dev, int argc,
> +			     char **argv)
> +{

