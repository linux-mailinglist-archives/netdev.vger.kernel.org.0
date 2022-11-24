Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 909D2637DC3
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 17:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbiKXQxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 11:53:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiKXQxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 11:53:13 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2069.outbound.protection.outlook.com [40.107.94.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6B25C0E3
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 08:53:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CQwwPyu4WwN65ECUuc2pHFm8p/hyMtbg7wmxv1uVu3o635Ax2puq97jkIvCDecxg7ldMGXvFiJ9WK2isAAO+8fWCv+LIzSNjTGgDmkb2y90yLOQy+PQUZfzNgtv+FOfje1zDNbPUvG7+4avRtcYONSebABneixsEAkOyYiIt43XjTiEWfnF1gs2UGcyiO14ig2ht7awhKwZ/8TAFQPhx55Gt7tq3NjrNI5m7g6zNhJ3YaOKwsKFfdGDt5bEk3jlxXijgYX7ikhd5Vtc+efxoMMsvzvcDsQOW/i2DXjurs8GGbzkmA/lNsx1y4qEwFuhreV0ckS923ucAkpyWpytrNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k4J7a7T6wVxgZ7IAgqL9j7cM/uSqoSosmxFrFhHgT90=;
 b=VwCJuduqLX1f1Bm2kcFQvYSKW5Ph3/IwSCRqo0AK4KuzRe0icgQJurUd1ymZXIEaoelMq8MDsV1iBy0GXcQJ8ZggtfVimalVjLVEdpn90CX7v2cfvh692Gxrqj2A7jR3rF52A1Hb9RQhMJNjCHsEDJX+fXyCYsIKsCXA+lG/ncRwOS0Nun1n4tWdGxSwsy+lcYx7zV+FMMjW2Xe0Tqs0SBm2ya1g9HdMyBubJdHxNCCONfxYPo4yYRq1RE1LsBJ1i66S09BjNHVo5LLBBj7y9oRpcEvdH7vrs5waqwD4Jp35WEE5Qukp5+HGcNH+P5D+z7UOK3KCio6/0C2v05w88A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=microchip.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k4J7a7T6wVxgZ7IAgqL9j7cM/uSqoSosmxFrFhHgT90=;
 b=LsVI+ilsOOE061oaCjOAoNgDwAnT5PgkAIXHxFhrOLA+KfJpcK87XsfZVHSBjkNBFxOW+4TAvgkVJq+CWWCLOYv0XYtByd2TS/C4aMlDL/t4RHJqx0LhvrowX0y+k5RzauqAuJ6HDoAGLlMuySlZ/yuGfj2fwBUGoGMD/Gv73XW7okEVDC+zsa1hnVAxcqlk1tnmb7XU/vMiGlLh3iL64IzlR2BDPG//MJY88w99T0HvF+JIquJmz5m5b+cDSp7H+uzMOW3BBC1x1SbG9j1lTJnVRn+siylUbF1iwoTdvbn0QUAQA7915+tk7XsaWvjAfiC6QzRGZ10YsDATeOE/Sw==
Received: from DM6PR06CA0063.namprd06.prod.outlook.com (2603:10b6:5:54::40) by
 BL0PR12MB4884.namprd12.prod.outlook.com (2603:10b6:208:1ca::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Thu, 24 Nov
 2022 16:53:06 +0000
Received: from DM6NAM11FT082.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:54:cafe::4a) by DM6PR06CA0063.outlook.office365.com
 (2603:10b6:5:54::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19 via Frontend
 Transport; Thu, 24 Nov 2022 16:53:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT082.mail.protection.outlook.com (10.13.173.107) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.8 via Frontend Transport; Thu, 24 Nov 2022 16:53:05 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 24 Nov
 2022 08:52:58 -0800
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 24 Nov
 2022 08:52:56 -0800
References: <20221122104112.144293-1-daniel.machon@microchip.com>
 <20221122104112.144293-3-daniel.machon@microchip.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Daniel Machon <daniel.machon@microchip.com>
CC:     <netdev@vger.kernel.org>, <dsahern@kernel.org>,
        <stephen@networkplumber.org>, <petrm@nvidia.com>,
        <maxime.chevallier@bootlin.com>, <vladimir.oltean@nxp.com>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH iproute2-next 2/2] dcb: add new subcommand for apptrust
Date:   Thu, 24 Nov 2022 17:16:36 +0100
In-Reply-To: <20221122104112.144293-3-daniel.machon@microchip.com>
Message-ID: <87o7swi9ay.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT082:EE_|BL0PR12MB4884:EE_
X-MS-Office365-Filtering-Correlation-Id: eadb3c48-fa7e-4b4a-d380-08dace3c5ba7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9jpP3E7nwDPlHO4vz1Hwma7BTiIlHbpuUiLvFBJ3poptkTwWK+MwgsBvl+oM08Rim2dqVU1+IO5382rigdVxJHvbhDPbD4JzIA1tSEwxvO0lOLxJUi2Y8tv1MjwBSotzv7zRFTSUacRU9fdf3aDpIl1qBctdJM1xNc9zXoiDTu0fBeSA/BEbUo/VmQFGX30tm4dvbW8FQFLjWaAaC8OEWtR/73xEXDFYViWD6k1hB3ON6MUtXJ+R6FRD4EhdOPRPhiY/C4vcXSO9mdpe9HZlgp1JgZW/O0yMoEu08Z+c4BHyt7XVeeoQCZDaMky8XfANM135l5xKwkK27u24/87OTH5YNnY4H5MsxTbuH9Uj7q/aPitJ8fQw7btpx347zoB84op1Xgx2CNym+fZXNQTXanQd8PW51wMQ6+FpFogcQwVxJz5+Lr/lYxpEmXCc9PdWDb5r7cTOO/TKKxu5yduqEr4AYtxbT9OlYIf4UUHtlMiVr8QKQtFmND62ldRJq8+ehK5uD7/GNgKcJ13Uj98ziTnTJneifAqYrBuaR/M9aRIicBhmg727EBjFi1O/6Ss1jOyX2R278BQPLqTTn9bxIVAJ7+FIZCfU+ASOseiL0Pm7cDVzL2HFmlndAtqglK3uh8ZDw54A7xesBfriAXxw6qYD07CcPbjbmgDwBMNDxpkkyBzEWaiRJCBMU4bW/imE88vxFD7cX6eQlOAII4cMPA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(136003)(346002)(451199015)(46966006)(40470700004)(36840700001)(36860700001)(86362001)(356005)(82740400003)(7636003)(82310400005)(40480700001)(8676002)(70206006)(70586007)(4326008)(6916009)(316002)(30864003)(54906003)(5660300002)(2906002)(41300700001)(8936002)(40460700003)(186003)(426003)(16526019)(336012)(47076005)(6666004)(478600001)(83380400001)(26005)(2616005)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2022 16:53:05.5869
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eadb3c48-fa7e-4b4a-d380-08dace3c5ba7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT082.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4884
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Daniel Machon <daniel.machon@microchip.com> writes:

> Add new apptrust subcommand for the dcbnl apptrust extension object.
>
> The apptrust command lets you specify a consecutive ordered list of
> trusted selectors, which can be used by drivers to determine which
> selectors are eligible (trusted) for packet prioritization, and in which
> order.
>
> Selectors are sent in a new nested attribute:
> DCB_ATTR_IEEE_APP_TRUST_TABLE.  The nest contains trusted selectors
> encapsulated in either DCB_ATTR_IEEE_APP or DCB_ATTR_DCB_APP attributes,
> for standard and non-standard selectors, respectively.
>
> Example:
>
> Trust selectors dscp and pcp, in that order
> $ dcb apptrust set dev eth0 order dscp pcp
>
> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
> ---
>  dcb/Makefile            |   3 +-
>  dcb/dcb.c               |   4 +-
>  dcb/dcb.h               |   4 +
>  dcb/dcb_apptrust.c      | 291 ++++++++++++++++++++++++++++++++++++++++
>  man/man8/dcb-apptrust.8 | 118 ++++++++++++++++
>  5 files changed, 418 insertions(+), 2 deletions(-)
>  create mode 100644 dcb/dcb_apptrust.c
>  create mode 100644 man/man8/dcb-apptrust.8
>
> diff --git a/dcb/Makefile b/dcb/Makefile
> index ca65d4670c80..dd41a559a0c8 100644
> --- a/dcb/Makefile
> +++ b/dcb/Makefile
> @@ -7,7 +7,8 @@ DCBOBJ = dcb.o \
>           dcb_dcbx.o \
>           dcb_ets.o \
>           dcb_maxrate.o \
> -         dcb_pfc.o
> +         dcb_pfc.o \
> +         dcb_apptrust.o
>  TARGETS += dcb
>  LDLIBS += -lm
>  
> diff --git a/dcb/dcb.c b/dcb/dcb.c
> index 391fd95455f4..3ffa91d64d0d 100644
> --- a/dcb/dcb.c
> +++ b/dcb/dcb.c
> @@ -470,7 +470,7 @@ static void dcb_help(void)
>  	fprintf(stderr,
>  		"Usage: dcb [ OPTIONS ] OBJECT { COMMAND | help }\n"
>  		"       dcb [ -f | --force ] { -b | --batch } filename [ -n | --netns ] netnsname\n"
> -		"where  OBJECT := { app | buffer | dcbx | ets | maxrate | pfc }\n"
> +		"where  OBJECT := { app | apptrust | buffer | dcbx | ets | maxrate | pfc }\n"
>  		"       OPTIONS := [ -V | --Version | -i | --iec | -j | --json\n"
>  		"                  | -N | --Numeric | -p | --pretty\n"
>  		"                  | -s | --statistics | -v | --verbose]\n");
> @@ -483,6 +483,8 @@ static int dcb_cmd(struct dcb *dcb, int argc, char **argv)
>  		return 0;
>  	} else if (matches(*argv, "app") == 0) {
>  		return dcb_cmd_app(dcb, argc - 1, argv + 1);
> +	} else if (strcmp(*argv, "apptrust") == 0) {
> +		return dcb_cmd_apptrust(dcb, argc - 1, argv + 1);
>  	} else if (matches(*argv, "buffer") == 0) {
>  		return dcb_cmd_buffer(dcb, argc - 1, argv + 1);
>  	} else if (matches(*argv, "dcbx") == 0) {
> diff --git a/dcb/dcb.h b/dcb/dcb.h
> index 05eddcbbcfdf..d40664f29dad 100644
> --- a/dcb/dcb.h
> +++ b/dcb/dcb.h
> @@ -61,6 +61,10 @@ enum ieee_attrs_app dcb_app_attr_type_get(__u8 selector);
>  bool dcb_app_attr_type_validate(enum ieee_attrs_app type);
>  bool dcb_app_selector_validate(enum ieee_attrs_app type, __u8 selector);
>  
> +/* dcb_apptrust.c */
> +
> +int dcb_cmd_apptrust(struct dcb *dcb, int argc, char **argv);
> +
>  /* dcb_buffer.c */
>  
>  int dcb_cmd_buffer(struct dcb *dcb, int argc, char **argv);
> diff --git a/dcb/dcb_apptrust.c b/dcb/dcb_apptrust.c
> new file mode 100644
> index 000000000000..14d18dcb7f83
> --- /dev/null
> +++ b/dcb/dcb_apptrust.c
> @@ -0,0 +1,291 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +
> +#include <errno.h>
> +#include <linux/dcbnl.h>
> +
> +#include "dcb.h"
> +#include "utils.h"
> +
> +static void dcb_apptrust_help_set(void)
> +{
> +	fprintf(stderr,
> +		"Usage: dcb apptrust set dev STRING\n"
> +		"	[ order [ eth | stream | dgram | any | dscp | pcp ] ]\n"
> +		"\n");
> +}
> +
> +static void dcb_apptrust_help_show(void)
> +{
> +	fprintf(stderr, "Usage: dcb [ -i ] apptrust show dev STRING\n"
> +			"           [ order ]\n"
> +			"\n");
> +}
> +
> +static void dcb_apptrust_help(void)
> +{
> +	fprintf(stderr, "Usage: dcb apptrust help\n"
> +			"\n");
> +	dcb_apptrust_help_show();
> +	dcb_apptrust_help_set();
> +}
> +
> +static const char *const selector_names[] = {
> +	[IEEE_8021QAZ_APP_SEL_ETHERTYPE] = "eth",
> +	[IEEE_8021QAZ_APP_SEL_STREAM]    = "stream",
> +	[IEEE_8021QAZ_APP_SEL_DGRAM]     = "dgram",
> +	[IEEE_8021QAZ_APP_SEL_ANY]       = "any",
> +	[IEEE_8021QAZ_APP_SEL_DSCP]      = "dscp",
> +	[DCB_APP_SEL_PCP]                = "pcp",
> +};

These names should match how dcb-app names them. So ethtype,
stream-port, dgram-port, port, dscp, pcp.

> +
> +struct dcb_apptrust_table {
> +	__u8 selectors[IEEE_8021QAZ_APP_SEL_MAX + 1];
> +	int nselectors;
> +};
> +
> +static bool dcb_apptrust_contains(const struct dcb_apptrust_table *table,
> +				  __u8 selector)
> +{
> +	int i;
> +
> +	for (i = 0; i < table->nselectors; i++)
> +		if (table->selectors[i] == selector)
> +			return true;
> +
> +	return false;
> +}
> +
> +static void dcb_apptrust_print(const struct dcb_apptrust_table *table)
> +{
> +	const char *str;
> +	__u8 selector;
> +	int i;
> +
> +	open_json_array(PRINT_JSON, "order");
> +	print_string(PRINT_FP, NULL, "order: ", NULL);
> +
> +	for (i = 0; i < table->nselectors; i++) {
> +		selector = table->selectors[i];
> +		str = selector_names[selector];
> +		print_string(PRINT_ANY, NULL, "%s ", str);
> +	}
> +	print_nl();
> +
> +	close_json_array(PRINT_JSON, "order");
> +}
> +
> +static int dcb_apptrust_get_cb(const struct nlattr *attr, void *data)
> +{
> +	struct dcb_apptrust_table *table = data;
> +	uint16_t type;
> +	__u8 selector;
> +
> +	type = mnl_attr_get_type(attr);
> +
> +	if (!dcb_app_attr_type_validate(type)) {
> +		fprintf(stderr,
> +			"Unknown attribute in DCB_ATTR_IEEE_APP_TRUST_TABLE: %d\n",
> +			type);
> +		return MNL_CB_OK;
> +	}
> +
> +	if (mnl_attr_get_payload_len(attr) < 1) {
> +		fprintf(stderr,
> +			"DCB_ATTR_IEEE_APP_TRUST payload expected to have size %zd, not %d\n",
> +			sizeof(struct dcb_app), mnl_attr_get_payload_len(attr));
> +		return MNL_CB_OK;
> +	}
> +
> +	selector = mnl_attr_get_u8(attr);
> +
> +	/* Check that selector is encapsulated in the right attribute */
> +	if (!dcb_app_selector_validate(type, selector)) {
> +		fprintf(stderr, "Wrong type for selector: %s\n",
> +			selector_names[selector]);
> +		return MNL_CB_OK;
> +	}
> +
> +	table->selectors[table->nselectors++] = selector;
> +
> +	return MNL_CB_OK;
> +}
> +
> +static int dcb_apptrust_get(struct dcb *dcb, const char *dev,
> +			    struct dcb_apptrust_table *table)
> +{
> +	uint16_t payload_len;
> +	void *payload;
> +	int ret;
> +
> +	ret = dcb_get_attribute_va(dcb, dev, DCB_ATTR_DCB_APP_TRUST_TABLE,
> +				   &payload, &payload_len);
> +	if (ret != 0)
> +		return ret;
> +
> +	ret = mnl_attr_parse_payload(payload, payload_len, dcb_apptrust_get_cb,
> +				     table);
> +	if (ret != MNL_CB_OK)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static int dcb_apptrust_set_cb(struct dcb *dcb, struct nlmsghdr *nlh,
> +			       void *data)
> +{
> +	const struct dcb_apptrust_table *table = data;
> +	enum ieee_attrs_app type;
> +	struct nlattr *nest;
> +	int i;
> +
> +	nest = mnl_attr_nest_start(nlh, DCB_ATTR_DCB_APP_TRUST_TABLE);
> +
> +	for (i = 0; i < table->nselectors; i++) {
> +		type = dcb_app_attr_type_get(table->selectors[i]);
> +		mnl_attr_put_u8(nlh, type, table->selectors[i]);
> +	}
> +
> +	mnl_attr_nest_end(nlh, nest);
> +
> +	return 0;
> +}
> +
> +static int dcb_apptrust_set(struct dcb *dcb, const char *dev,
> +			    const struct dcb_apptrust_table *table)
> +{
> +	return dcb_set_attribute_va(dcb, DCB_CMD_IEEE_SET, dev,
> +				    &dcb_apptrust_set_cb, (void *)table);
> +}
> +
> +static int dcb_apptrust_parse_selector_list(int *argcp, char ***argvp,
> +					    struct dcb_apptrust_table *table)
> +{
> +	char **argv = *argvp;
> +	int argc = *argcp;
> +	__u8 selector;
> +	int ret;
> +
> +	NEXT_ARG_FWD();
> +
> +	/* No trusted selectors ? */
> +	if (argc == 0)
> +		goto out;
> +
> +	while (argc > 0) {
> +		selector = parse_one_of("order", *argv, selector_names,
> +					ARRAY_SIZE(selector_names), &ret);
> +		if (ret < 0)
> +			return -EINVAL;

I think this should legitimately conclude the parsing, because it could
be one of the higher-level keywords. Currently there's only one,
"order", but nonetheless. I think it should goto out, and be plonked by
the caller with "what is X?". Similar to how the first argument that
doesn't parse as e.g. DSCP:PRIO bails out and is attempted as a keyword
higher up, and either parsed, or plonked with "what is X".

> +
> +		if (table->nselectors > IEEE_8021QAZ_APP_SEL_MAX)

Yeah, this is purely theoretical, so no need for a message.

> +			return -ERANGE;
> +
> +		if (dcb_apptrust_contains(table, selector)) {
> +			fprintf(stderr, "Duplicate selector: %s\n",
> +				selector_names[selector]);
> +			return -EINVAL;
> +		}
> +
> +		table->selectors[table->nselectors++] = selector;
> +
> +		NEXT_ARG_FWD();
> +	}
> +
> +out:
> +	*argcp = argc;
> +	*argvp = argv;
> +
> +	return 0;
> +}
> +
> +static int dcb_cmd_apptrust_set(struct dcb *dcb, const char *dev, int argc,
> +				char **argv)
> +{
> +	struct dcb_apptrust_table table = { 0 };
> +	int ret;
> +
> +	if (!argc) {
> +		dcb_apptrust_help_set();
> +		return 0;
> +	}
> +
> +	do {
> +		if (strcmp(*argv, "help") == 0) {
> +			dcb_apptrust_help_set();
> +			return 0;
> +		} else if (strcmp(*argv, "order") == 0) {
> +			ret = dcb_apptrust_parse_selector_list(&argc, &argv,
> +							       &table);
> +			if (ret < 0) {
> +				fprintf(stderr, "Invalid list of selectors\n");
> +				return -EINVAL;
> +			}
> +			continue;
> +		} else {
> +			fprintf(stderr, "What is \"%s\"?\n", *argv);
> +			dcb_apptrust_help_set();
> +			return -EINVAL;
> +		}
> +
> +		NEXT_ARG_FWD();
> +	} while (argc > 0);
> +
> +	return dcb_apptrust_set(dcb, dev, &table);
> +}
> +
> +static int dcb_cmd_apptrust_show(struct dcb *dcb, const char *dev, int argc,
> +				 char **argv)
> +{
> +	struct dcb_apptrust_table table = { 0 };
> +	int ret;
> +
> +	ret = dcb_apptrust_get(dcb, dev, &table);
> +	if (ret)
> +		return ret;
> +
> +	open_json_object(NULL);
> +
> +	if (!argc) {
> +		dcb_apptrust_help();

Given no arguments to show, the tool should show everything, not help.

> +		goto out;
> +	}
> +
> +	do {
> +		if (strcmp(*argv, "help") == 0) {
> +			dcb_apptrust_help_show();
> +			return 0;
> +		} else if (strcmp(*argv, "order") == 0) {
> +			dcb_apptrust_print(&table);

This should probably be dcb_apptrust_print_order, so that more stuff can
be added cleanly.

> +		} else {
> +			fprintf(stderr, "What is \"%s\"?\n", *argv);
> +			dcb_apptrust_help_show();
> +			return -EINVAL;
> +		}
> +
> +		NEXT_ARG_FWD();
> +	} while (argc > 0);
> +
> +out:
> +	close_json_object();
> +	return 0;
> +}
> +
> +int dcb_cmd_apptrust(struct dcb *dcb, int argc, char **argv)
> +{
> +	if (!argc || strcmp(*argv, "help") == 0) {
> +		dcb_apptrust_help();
> +		return 0;
> +	} else if (strcmp(*argv, "show") == 0) {
> +		NEXT_ARG_FWD();
> +		return dcb_cmd_parse_dev(dcb, argc, argv, dcb_cmd_apptrust_show,
> +					 dcb_apptrust_help_show);
> +	} else if (strcmp(*argv, "set") == 0) {
> +		NEXT_ARG_FWD();
> +		return dcb_cmd_parse_dev(dcb, argc, argv, dcb_cmd_apptrust_set,
> +					 dcb_apptrust_help_set);
> +	} else {
> +		fprintf(stderr, "What is \"%s\"?\n", *argv);
> +		dcb_apptrust_help();
> +		return -EINVAL;
> +	}
> +}
> diff --git a/man/man8/dcb-apptrust.8 b/man/man8/dcb-apptrust.8
> new file mode 100644
> index 000000000000..9ebe7c17292c
> --- /dev/null
> +++ b/man/man8/dcb-apptrust.8
> @@ -0,0 +1,118 @@
> +.TH DCB-APPTRUST 8 "22 November 2022" "iproute2" "Linux"
> +.SH NAME
> +dcb-apptrust \- show / manipulate per-selector trust and trust order of the application
> +priority table of the DCB (Data Center Bridging) subsystem.
> +.SH SYNOPSIS
> +.sp
> +.ad l
> +.in +8
> +
> +.ti -8
> +.B dcb
> +.RI "[ " OPTIONS " ] "
> +.B apptrust
> +.RI "{ " COMMAND " | " help " }"
> +.sp
> +
> +.ti -8
> +.B dcb apptrust show dev order
> +.RI DEV
> +
> +.ti -8
> +.B dcb apptrust set dev order
> +.RI DEV
> +.RB "[ " eth " ]"
> +.RB "[ " stream " ]"
> +.RB "[ " dgram " ]"
> +.RB "[ " any " ]"
> +.RB "[ " dscp " ]"
> +.RB "[ " pcp " ]"

Taken literally, this prescribes the order, just allows omitting some of
the selectors. I think you'll need to circumscribe like this:

    dcb apptrust set dev order [ SEL-LIST ]
    SEL-LIST := [ SEL-LIST ] SEL
    SEL := { ethtype | stream-port | etc. etc. }

> +.SH DESCRIPTION
> +
> +.B dcb apptrust
> +is used to configure and manipulate per-selector trust and trust order of the
> +Application Priority Table, see
> +.BR dcb-app (8)
> +for details on how to configure app table entries.
> +
> +Selector trust can be used by the
> +software stack, or drivers (most likely the latter), when querying the APP
> +table, to determine if an APP entry should take effect, or not. Additionaly, the
> +order of the trusted selectors will dictate which selector should take
> +precedence, in the case of multiple different APP selectors being present in the
> +APP table.
> +
> +.SH COMMANDS
> +
> +.TP
> +.B show
> +Display all trusted selectors.
> +
> +.TP
> +.B set
> +Set new list of trusted selectors. Empty list is effectively the same as
> +removing trust entirely.
> +
> +.SH PARAMETERS
> +
> +The following describes only the write direction, i.e. as used with the
> +\fBset\fR command. For the \fBshow\fR command, the parameter name is to be used
> +as a simple keyword without further arguments. This instructs the tool to show
> +the values of a given parameter.
> +
> +.TP
> +.B order \fISELECTOR-NAMES
> +\fISELECTOR-NAMES\fR is a space-separated list of selector names:\fR
> +
> +.B eth
> +Trust EtherType.
> +
> +.B stream
> +Trust TCP, or Stream Control Transmission Protocol (SCTP).
> +
> +.B dgram
> +Trust UDP, or Datagram Congestion Control Protocol (DCCP).
> +
> +.B any
> +Trust TCP, SCTP, UDP, or DCCP.
> +
> +.B dscp
> +Trust Differentiated Services Code Point (DSCP) values.
> +
> +.B pcp
> +Trust Priority Code Point/Drop Eligible Indicator (PCP/DEI).

These names need to be updated as well.

> +
> +
> +.SH EXAMPLE & USAGE
> +
> +Set trust order to: dscp, pcp for eth0:
> +.P
> +# dcb apptrust set dev eth0 order dscp pcp
> +
> +Set trust order to: any (stream or dgram), pcp, eth for eth1:
> +.P
> +# dcb apptrust set dev eth1 order any pcp eth
> +
> +Show what was set:
> +
> +.P
> +# dcb apptrust show dev eth0
> +.br
> +order: any pcp eth
> +
> +.SH EXIT STATUS
> +Exit status is 0 if command was successful or a positive integer upon failure.
> +
> +.SH SEE ALSO
> +.BR dcb (8),
> +.BR dcb-app (8)
> +
> +.SH REPORTING BUGS
> +Report any bugs to the Network Developers mailing list
> +.B <netdev@vger.kernel.org>
> +where the development and maintenance is primarily done.
> +You do not have to be subscribed to the list to send a message there.
> +
> +.SH AUTHOR
> +Daniel Machon <daniel.machon@microchip.com>

