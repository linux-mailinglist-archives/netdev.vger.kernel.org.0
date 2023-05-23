Return-Path: <netdev+bounces-4759-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4653570E204
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 18:45:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0158A1C20DBB
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 16:45:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D11AD200D0;
	Tue, 23 May 2023 16:45:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B811F1F933
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 16:45:26 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2073.outbound.protection.outlook.com [40.107.93.73])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73634E41
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 09:45:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bv/8Cb4GQT/ixN3V7lgFkw/RPoKshurhiI7WN+CfmksQhYjrYj48K5q9xoJl5NoeHpIf4UI9EgdbFPgOJ/keXFdN6hyC9Ed0GwE/tsgv0c86rl66nWwRt6WveAKon4LR0oZvdujBJBEmt/gJDPBOVBxkAPuCddLlsj04VIydqiznL7CAfWm801BiX7BFOVQTUoApNI4JUvNOyjvaiFIunkSC97YzFuzsvex7S+6BJlRxddblqZSTa0MUoNrjRuq6ZwdE7lhUAONs4k94hS7oqQs8jg2+GTnwcc7n7n7rL09JuigCHscj0rdMP5gebry67N4vkQPZoM1Wmi11VO0zpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tS/4BwU+8zjzp+Res6iIMsgF+zQaXUv/wXHYJLOZhk8=;
 b=SCOXglEJCkBcakOaGA1jf0gbjsFHQ7CAWXLJOCfQKQQ9Fb30gse6Ry0Py705bHBZMEeMsA7vZkJIR5sVUsHsQveMKdH409XmfhaR2UHjLjWz3cMXUeFC9H58vkifaDdqej8xU8ABit6jOESMKaqKa4W7I9y+zJhZ8x3NEo809gEuPnTAPChPsneJuUsLJ4xcUNoHQoTf9WXVOhxxzE4KplSdfdeMWfAP9WfhxMOt2Q7EYZBbXJzYdMHbS1wtRYBjP3iwCdUztwKnjFdXwPC8yQqqaELrmp7905Hi+Xo/crJDC1COwooi6H6rXxi3lP6z/xDDF7CIPcKCs8WJ8MwbZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=microchip.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tS/4BwU+8zjzp+Res6iIMsgF+zQaXUv/wXHYJLOZhk8=;
 b=F+5E5760G8fyUWGKgu/xLodMzISSylc+oGXzHZlzkyaDq1woWlEFxwLe2l1WZ0HwbBC2AFZsN/Mdl3+jKOB230GxNxqkNt0RpTTSEJJ8VeuZOEzg9U1DbSW5Ksr/eUa6l5BSxRXfsIfo+ls8dsxeDM1pnmnI1ED8qa/VaDNIUVOBISE3I2tbgZwxGKJs40UiczJsOUsZBF/itCOT6eCIpUZGlHzj7y7JApqswpFIn7pFcWbIjIJwc8A1MjWTKrmhyragimBHX+pN17afdIRLpYQvwInOQIoBHAkjZ88SnzVWvY6bO2oNd9/NppKQjwgyteLTkETKDOpZxS2uzOzMdQ==
Received: from MW4PR04CA0157.namprd04.prod.outlook.com (2603:10b6:303:85::12)
 by MN2PR12MB4485.namprd12.prod.outlook.com (2603:10b6:208:269::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Tue, 23 May
 2023 16:45:10 +0000
Received: from CO1NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:85:cafe::89) by MW4PR04CA0157.outlook.office365.com
 (2603:10b6:303:85::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28 via Frontend
 Transport; Tue, 23 May 2023 16:45:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT049.mail.protection.outlook.com (10.13.175.50) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.29 via Frontend Transport; Tue, 23 May 2023 16:45:10 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 23 May 2023
 09:45:01 -0700
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 23 May
 2023 09:44:59 -0700
References: <20230510-dcb-rewr-v1-0-83adc1f93356@microchip.com>
 <20230510-dcb-rewr-v1-6-83adc1f93356@microchip.com>
User-agent: mu4e 1.6.6; emacs 28.1
From: Petr Machata <petrm@nvidia.com>
To: Daniel Machon <daniel.machon@microchip.com>
CC: <netdev@vger.kernel.org>, <dsahern@kernel.org>,
	<stephen@networkplumber.org>, <petrm@nvidia.com>,
	<UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH iproute2-next 6/9] dcb: rewr: add new dcb-rewr subcommand
Date: Tue, 23 May 2023 18:35:35 +0200
In-Reply-To: <20230510-dcb-rewr-v1-6-83adc1f93356@microchip.com>
Message-ID: <874jo3575i.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT049:EE_|MN2PR12MB4485:EE_
X-MS-Office365-Filtering-Correlation-Id: a0ab7800-f350-40c4-4c82-08db5bad12e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	MJXqehTGW/3lwmNxGBgWkoBMWq3Gm/BvNeZ7Xjv9h9C96XbXDwO3c5LUciRC9w3XkEGSGmKgk+0GrB6jJLCZ0hIC+EJpBjV2QLHordvROv3gpx8W/upN5h7P+oQcONTIt3WiXUWDx84mZLjQJh2kjJ+ewnynVORm/Q1IEMPOTFAcz6ETPufyArypljaaE4cDesp4y/kD3thZTVY13OHIYkDEikUgSpXde8q0J+qbs9lr3RHWINY2zkla/aRWbQMLeaP41sukwJHCCWQ7hY+MwaoFvXqxQfUf+X5E91nztIBRoE0curbuGmEhSuBK+DRolE0Jja1nHAhDOnfxhv08YDfnwtqEPUsfx3ANsavhBGekLXnAKB4hG/mtYxevC1cd8B4Xi++gvu6zAwT+8GzmVPXxGSCaKnTwnqYSwR/eg68MLYukZNktW+f3jNdv1ZsoOjpEMU4jx4NnAf98K8CNVtQ29lGR1S3HlICxLg8PpfbQ3gVbx2kwmq1cqVfL2NCmBdRqy58TKpB0toqioLKxA0DCvHOg4fZTAB5yu2TATWB6bRlSBKTPnayp6WLse4Pp9kMZdxsw5A8OX4iR8WsJjC7yGn3EKCx8MrDHogP++M1SXoK/s2fhZDPupIBHzSTv3UwKvG0bAFvjlZfuKiamMTtUi9XSI32SDBurbXfYtT1X8kjdmqW7vd/vzlqkEVN2hiPgC0JO64loPbQHNXzv8Z0U1PcheWXIYqT6uiZalPo6hs/jK7IE3MfkHS3+Bkdj
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(136003)(376002)(39860400002)(451199021)(40470700004)(36840700001)(46966006)(82310400005)(54906003)(41300700001)(478600001)(316002)(4326008)(70586007)(6916009)(6666004)(70206006)(86362001)(5660300002)(8936002)(8676002)(2906002)(26005)(356005)(7636003)(82740400003)(186003)(40460700003)(16526019)(426003)(336012)(83380400001)(40480700001)(30864003)(2616005)(36756003)(36860700001)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 16:45:10.6269
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a0ab7800-f350-40c4-4c82-08db5bad12e7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4485
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

That's reasonable.

> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
> ---
>  dcb/Makefile   |   3 +-
>  dcb/dcb.c      |   4 +-
>  dcb/dcb.h      |   3 +
>  dcb/dcb_app.h  |   1 +
>  dcb/dcb_rewr.c | 332 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 341 insertions(+), 2 deletions(-)
>
> diff --git a/dcb/Makefile b/dcb/Makefile
> index dd41a559a0c8..10794c9dc19f 100644
> --- a/dcb/Makefile
> +++ b/dcb/Makefile
> @@ -8,7 +8,8 @@ DCBOBJ = dcb.o \
>           dcb_ets.o \
>           dcb_maxrate.o \
>           dcb_pfc.o \
> -         dcb_apptrust.o
> +         dcb_apptrust.o \
> +         dcb_rewr.o
>  TARGETS += dcb
>  LDLIBS += -lm
>  
> diff --git a/dcb/dcb.c b/dcb/dcb.c
> index 9b996abac529..fe0a0f04143d 100644
> --- a/dcb/dcb.c
> +++ b/dcb/dcb.c
> @@ -470,7 +470,7 @@ static void dcb_help(void)
>  	fprintf(stderr,
>  		"Usage: dcb [ OPTIONS ] OBJECT { COMMAND | help }\n"
>  		"       dcb [ -f | --force ] { -b | --batch } filename [ -n | --netns ] netnsname\n"
> -		"where  OBJECT := { app | apptrust | buffer | dcbx | ets | maxrate | pfc }\n"
> +		"where  OBJECT := { app | apptrust | buffer | dcbx | ets | maxrate | pfc | rewr }\n"
>  		"       OPTIONS := [ -V | --Version | -i | --iec | -j | --json\n"
>  		"                  | -N | --Numeric | -p | --pretty\n"
>  		"                  | -s | --statistics | -v | --verbose]\n");
> @@ -485,6 +485,8 @@ static int dcb_cmd(struct dcb *dcb, int argc, char **argv)
>  		return dcb_cmd_app(dcb, argc - 1, argv + 1);
>  	} else if (strcmp(*argv, "apptrust") == 0) {
>  		return dcb_cmd_apptrust(dcb, argc - 1, argv + 1);
> +	} else if (strcmp(*argv, "rewr") == 0) {
> +		return dcb_cmd_rewr(dcb, argc - 1, argv + 1);
>  	} else if (matches(*argv, "buffer") == 0) {
>  		return dcb_cmd_buffer(dcb, argc - 1, argv + 1);
>  	} else if (matches(*argv, "dcbx") == 0) {
> diff --git a/dcb/dcb.h b/dcb/dcb.h
> index 4c8a4aa25e0c..39a04f1c59df 100644
> --- a/dcb/dcb.h
> +++ b/dcb/dcb.h
> @@ -56,6 +56,9 @@ void dcb_print_array_on_off(const __u8 *array, size_t size);
>  void dcb_print_array_kw(const __u8 *array, size_t array_size,
>  			const char *const kw[], size_t kw_size);
>  
> +/* dcb_rewr.c */
> +int dcb_cmd_rewr(struct dcb *dcb, int argc, char **argv);
> +
>  /* dcb_apptrust.c */
>  
>  int dcb_cmd_apptrust(struct dcb *dcb, int argc, char **argv);
> diff --git a/dcb/dcb_app.h b/dcb/dcb_app.h
> index 8f048605c3a8..02c9eb03f6c2 100644
> --- a/dcb/dcb_app.h
> +++ b/dcb/dcb_app.h
> @@ -22,6 +22,7 @@ struct dcb_app_parse_mapping {
>  };
>  
>  #define DCB_APP_PCP_MAX 15
> +#define DCB_APP_DSCP_MAX 63

It would be nice to have dcb_app_parse_mapping_dscp_prio() use that
define now that it exists. Back then I figured the value 63 in the
context that mentions DSCP is clear enough, and the value itself being
grounded in IEEE won't change, but... um, yeah, if the define exists,
let's use it :)

>  
>  int dcb_cmd_app(struct dcb *dcb, int argc, char **argv);
>  
> diff --git a/dcb/dcb_rewr.c b/dcb/dcb_rewr.c
> new file mode 100644
> index 000000000000..731ba78977e2
> --- /dev/null
> +++ b/dcb/dcb_rewr.c
> @@ -0,0 +1,332 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +
> +#include <errno.h>
> +#include <linux/dcbnl.h>
> +#include <stdio.h>
> +
> +#include "dcb.h"
> +#include "utils.h"
> +
> +static void dcb_rewr_help_add(void)
> +{
> +	fprintf(stderr,
> +		"Usage: dcb rewr { add | del | replace } dev STRING\n"
> +		"           [ prio-pcp PRIO:PCP   ]\n"
> +		"           [ prio-dscp PRIO:DSCP ]\n"
> +		"\n"
> +		" where PRIO := { 0 .. 7               }\n"
> +		"       PCP  := { 0(nd/de) .. 7(nd/de) }\n"
> +		"       DSCP := { 0 .. 63              }\n"

I was wondering if you had done something with this instance of 63 ;)

Can you also drop all those extra spaces? Here and elsewhere. These
tabular layouts only ever lead to later reformatting as longer lines
break it.

> +		"\n"
> +	);
> +}
> +
> +static void dcb_rewr_help_show_flush(void)
> +{
> +	fprintf(stderr,
> +		"Usage: dcb rewr { show | flush } dev STRING\n"
> +		"           [ prio-pcp  ]\n"
> +		"           [ prio-dscp ]\n"
> +		"\n"
> +	);
> +}
> +
> +static void dcb_rewr_help(void)
> +{
> +	fprintf(stderr,
> +		"Usage: dcb rewr help\n"
> +		"\n"
> +	);
> +	dcb_rewr_help_show_flush();
> +	dcb_rewr_help_add();
> +}
> +
> +static int dcb_rewr_parse_mapping_prio_pcp(__u32 key, char *value, void *data)
> +{
> +	__u32 pcp;
> +
> +	if (dcb_app_parse_pcp(&pcp, value))
> +		return -EINVAL;
> +
> +	return dcb_parse_mapping("PRIO", key, IEEE_8021QAZ_MAX_TCS - 1, "PCP",
> +				 pcp, DCB_APP_PCP_MAX, dcb_app_parse_mapping_cb,
> +				 data);

See, the way it's formatted in app makes it clear what's what. Consider:

	return dcb_parse_mapping("PRIO", key, IEEE_8021QAZ_MAX_TCS - 1,
				 "PCP", pcp, DCB_APP_PCP_MAX,
				 dcb_app_parse_mapping_cb, data);

PRIO has proposed value of "key" and goes up to IEEE_8021QAZ_MAX_TCS - 1,
PCP has "pcp", goes up to DCB_APP_PCP_MAX, please use this callback and
invoke it with "data".

The expression in this patch takes the same amount of space, but it's
much less clear what is what.

The same applies below.

> +}
> +
> +static int dcb_rewr_parse_mapping_prio_dscp(__u32 key, char *value, void *data)
> +{
> +	__u32 dscp;
> +
> +	if (dcb_app_parse_dscp(&dscp, value))
> +		return -EINVAL;
> +
> +	return dcb_parse_mapping("PRIO", key, IEEE_8021QAZ_MAX_TCS - 1, "DSCP",
> +				 dscp, DCB_APP_DSCP_MAX,
> +				 dcb_app_parse_mapping_cb, data);
> +}
> +
> +static void dcb_rewr_print_prio_pcp(const struct dcb *dcb,
> +				    const struct dcb_app_table *tab)
> +{
> +	dcb_app_print_filtered(tab, dcb_app_is_pcp,
> +			       dcb->numeric ? dcb_app_print_pid_dec :
> +					      dcb_app_print_pid_pcp,
> +			       "prio_pcp", "prio-pcp");
> +}
> +
> +static void dcb_rewr_print_prio_dscp(const struct dcb *dcb,
> +				     const struct dcb_app_table *tab)
> +{
> +	dcb_app_print_filtered(tab, dcb_app_is_dscp,
> +			       dcb->numeric ? dcb_app_print_pid_dec :
> +					      dcb_app_print_pid_dscp,
> +			       "prio_dscp", "prio-dscp");
> +}
> +
> +static void dcb_rewr_print(const struct dcb *dcb,
> +			   const struct dcb_app_table *tab)
> +{
> +	dcb_rewr_print_prio_pcp(dcb, tab);
> +	dcb_rewr_print_prio_dscp(dcb, tab);
> +}
> +
> +static int dcb_cmd_rewr_parse_add_del(struct dcb *dcb, const char *dev,
> +				      int argc, char **argv,
> +				      struct dcb_app_table *tab)
> +{
> +	struct dcb_app_parse_mapping pm = { .tab = tab };
> +	int ret;
> +
> +	if (!argc) {
> +		dcb_rewr_help_add();
> +		return 0;
> +	}
> +
> +	do {
> +		if (strcmp(*argv, "help") == 0) {
> +			dcb_rewr_help_add();
> +			return 0;
> +		} else if (strcmp(*argv, "prio-pcp") == 0) {
> +			NEXT_ARG();
> +			pm.selector = DCB_APP_SEL_PCP;
> +			ret = parse_mapping(&argc, &argv, false,
> +					    &dcb_rewr_parse_mapping_prio_pcp,
> +					    &pm);
> +		} else if (strcmp(*argv, "prio-dscp") == 0) {
> +			NEXT_ARG();
> +			pm.selector = IEEE_8021QAZ_APP_SEL_DSCP;
> +			ret = parse_mapping(&argc, &argv, false,
> +					    &dcb_rewr_parse_mapping_prio_dscp,
> +					    &pm);
> +		} else {
> +			fprintf(stderr, "What is \"%s\"?\n", *argv);
> +			dcb_rewr_help_add();
> +			return -EINVAL;
> +		}
> +
> +		if (ret != 0) {
> +			fprintf(stderr, "Invalid mapping %s\n", *argv);
> +			return ret;
> +		}
> +		if (pm.err)
> +			return pm.err;
> +	} while (argc > 0);
> +
> +	return 0;
> +}
> +
> +static int dcb_cmd_rewr_add(struct dcb *dcb, const char *dev, int argc,
> +			    char **argv)
> +{
> +	struct dcb_app_table tab = { .attr = DCB_ATTR_DCB_REWR_TABLE };
> +	int ret;
> +
> +	ret = dcb_cmd_rewr_parse_add_del(dcb, dev, argc, argv, &tab);
> +	if (ret != 0)
> +		return ret;
> +
> +	ret = dcb_app_add_del(dcb, dev, DCB_CMD_IEEE_SET, &tab, NULL);
> +	dcb_app_table_fini(&tab);
> +	return ret;
> +}
> +
> +static int dcb_cmd_rewr_del(struct dcb *dcb, const char *dev, int argc,
> +			    char **argv)
> +{
> +	struct dcb_app_table tab = { .attr = DCB_ATTR_DCB_REWR_TABLE };
> +	int ret;
> +
> +	ret = dcb_cmd_rewr_parse_add_del(dcb, dev, argc, argv, &tab);
> +	if (ret != 0)
> +		return ret;
> +
> +	ret = dcb_app_add_del(dcb, dev, DCB_CMD_IEEE_DEL, &tab, NULL);
> +	dcb_app_table_fini(&tab);
> +	return ret;
> +}
> +
> +static int dcb_cmd_rewr_replace(struct dcb *dcb, const char *dev, int argc,
> +				char **argv)
> +{
> +	struct dcb_app_table orig = { .attr = DCB_ATTR_DCB_REWR_TABLE };
> +	struct dcb_app_table tab = { .attr = DCB_ATTR_DCB_REWR_TABLE };
> +	struct dcb_app_table new = { .attr = DCB_ATTR_DCB_REWR_TABLE };
> +	int ret;
> +
> +	ret = dcb_app_get(dcb, dev, &orig);
> +	if (ret != 0)
> +		return ret;
> +
> +	ret = dcb_cmd_rewr_parse_add_del(dcb, dev, argc, argv, &tab);
> +	if (ret != 0)
> +		goto out;
> +
> +	/* Attempts to add an existing entry would be rejected, so drop
> +	 * these entries from tab.
> +	 */
> +	ret = dcb_app_table_copy(&new, &tab);
> +	if (ret != 0)
> +		goto out;
> +	dcb_app_table_remove_existing(&new, &orig);
> +
> +	ret = dcb_app_add_del(dcb, dev, DCB_CMD_IEEE_SET, &new, NULL);
> +	if (ret != 0) {
> +		fprintf(stderr, "Could not add new rewrite entries\n");
> +		goto out;
> +	}
> +
> +	/* Remove the obsolete entries. */
> +	dcb_app_table_remove_replaced(&orig, &tab);
> +	ret = dcb_app_add_del(dcb, dev, DCB_CMD_IEEE_DEL, &orig, NULL);
> +	if (ret != 0) {
> +		fprintf(stderr, "Could not remove replaced rewrite entries\n");
> +		goto out;
> +	}
> +
> +out:
> +	dcb_app_table_fini(&new);
> +	dcb_app_table_fini(&tab);
> +	dcb_app_table_fini(&orig);
> +	return 0;
> +}
> +
> +
> +static int dcb_cmd_rewr_show(struct dcb *dcb, const char *dev, int argc,
> +			     char **argv)
> +{
> +	struct dcb_app_table tab = { .attr = DCB_ATTR_DCB_REWR_TABLE };
> +	int ret;
> +
> +	ret = dcb_app_get(dcb, dev, &tab);
> +	if (ret != 0)
> +		return ret;
> +
> +	dcb_app_table_sort(&tab);
> +
> +	open_json_object(NULL);
> +
> +	if (!argc) {
> +		dcb_rewr_print(dcb, &tab);
> +		goto out;
> +	}
> +
> +	do {
> +		if (strcmp(*argv, "help") == 0) {
> +			dcb_rewr_help_show_flush();
> +			goto out;
> +		} else if (strcmp(*argv, "prio-pcp") == 0) {
> +			dcb_rewr_print_prio_pcp(dcb, &tab);
> +		} else if (strcmp(*argv, "prio-dscp") == 0) {
> +			dcb_rewr_print_prio_dscp(dcb, &tab);
> +		} else {
> +			fprintf(stderr, "What is \"%s\"?\n", *argv);
> +			dcb_rewr_help_show_flush();
> +			ret = -EINVAL;
> +			goto out;
> +		}
> +
> +		NEXT_ARG_FWD();
> +	} while (argc > 0);
> +
> +out:
> +	close_json_object();
> +	dcb_app_table_fini(&tab);
> +	return ret;
> +}
> +
> +static int dcb_cmd_rewr_flush(struct dcb *dcb, const char *dev, int argc,
> +			      char **argv)
> +{
> +	struct dcb_app_table tab = { .attr = DCB_ATTR_DCB_REWR_TABLE };
> +	int ret;
> +
> +	ret = dcb_app_get(dcb, dev, &tab);
> +	if (ret != 0)
> +		return ret;
> +
> +	if (!argc) {
> +		ret = dcb_app_add_del(dcb, dev, DCB_CMD_IEEE_DEL, &tab,
> +				      NULL);
> +		goto out;
> +	}
> +
> +	do {
> +		if (strcmp(*argv, "help") == 0) {
> +			dcb_rewr_help_show_flush();
> +			goto out;
> +		} else if (strcmp(*argv, "prio-pcp") == 0) {
> +			ret = dcb_app_add_del(dcb, dev, DCB_CMD_IEEE_DEL, &tab,
> +					      &dcb_app_is_pcp);
> +			if (ret != 0)
> +				goto out;
> +		} else if (strcmp(*argv, "prio-dscp") == 0) {
> +			ret = dcb_app_add_del(dcb, dev, DCB_CMD_IEEE_DEL, &tab,
> +					      &dcb_app_is_dscp);
> +			if (ret != 0)
> +				goto out;
> +		} else {
> +			fprintf(stderr, "What is \"%s\"?\n", *argv);
> +			dcb_rewr_help_show_flush();
> +			ret = -EINVAL;
> +			goto out;
> +		}
> +
> +		NEXT_ARG_FWD();
> +	} while (argc > 0);
> +
> +out:
> +	dcb_app_table_fini(&tab);
> +	return ret;
> +}
> +
> +int dcb_cmd_rewr(struct dcb *dcb, int argc, char **argv)
> +{
> +	if (!argc || strcmp(*argv, "help") == 0) {
> +		dcb_rewr_help();
> +		return 0;
> +	} else if (strcmp(*argv, "show") == 0) {
> +		NEXT_ARG_FWD();
> +		return dcb_cmd_parse_dev(dcb, argc, argv, dcb_cmd_rewr_show,
> +					 dcb_rewr_help_show_flush);
> +	} else if (strcmp(*argv, "flush") == 0) {
> +		NEXT_ARG_FWD();
> +		return dcb_cmd_parse_dev(dcb, argc, argv, dcb_cmd_rewr_flush,
> +					 dcb_rewr_help_show_flush);
> +	} else if (strcmp(*argv, "add") == 0) {
> +		NEXT_ARG_FWD();
> +		return dcb_cmd_parse_dev(dcb, argc, argv, dcb_cmd_rewr_add,
> +					 dcb_rewr_help_add);
> +	} else if (strcmp(*argv, "del") == 0) {
> +		NEXT_ARG_FWD();
> +		return dcb_cmd_parse_dev(dcb, argc, argv, dcb_cmd_rewr_del,
> +					 dcb_rewr_help_add);
> +	} else if (strcmp(*argv, "replace") == 0) {
> +		NEXT_ARG_FWD();
> +		return dcb_cmd_parse_dev(dcb, argc, argv, dcb_cmd_rewr_replace,
> +					 dcb_rewr_help_add);
> +	} else {
> +		fprintf(stderr, "What is \"%s\"?\n", *argv);
> +		dcb_rewr_help();
> +		return -EINVAL;
> +	}
> +}


