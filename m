Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1D7637D70
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 17:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbiKXQCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 11:02:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiKXQCg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 11:02:36 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2086.outbound.protection.outlook.com [40.107.94.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1AD411C18
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 08:02:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ORkA8ZN5/WUZ52vmYCvGAahVcW6Gynyw2xFVBy3j0KKap5KydhAw3XFlz8T2g2mb+yIP9Km254FV+yu0lPIFCcs25sHK5/NnzFXo2KaUgALKa8+d09M6c2nQRdtne20hhUyvpdndzRpcFMZMuce/t3rf9bdSrGVXXJUvlNJCQ+LBv2/PxDN9hNgGqnsM17DTFYRE2DVXyJ7o92sLRQ8B4X+r5/UXzrlC47WA0xWAGh7NJwTArSpNF5Fvex2joeM/YXpbzYyI5btOd553FQy2Wtp0nIUiUT8hOD6KamCP121hf4Z0EaY9nFqN7n6nudSgn5IyO1OzJy0p2IIcLERFHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q7pSDDnTtWccFqPfLsmdKiGXHH/8P8jrumR67O/nDwg=;
 b=hTnVkNuIDeAoDaElhJfXtP87y/cQ1i2mKVbH2Q8qKJglP3x7AtnS5PP+vcKbv2RoNImOSNL5TWaOISMep4UtxjMw4enhEtwDkAPeV0oJ6DvLPoL1MEREsa4r3//DeHvkg1vYF1m8xm2ntl2XFDAP04JfGVOvIBleY9xKAubMHm0Nii9F5dQEqkNZItAE7l5yXBPvIIKYVvXgt1sr+frrTv4bEVTylqmVNG/7L78O+7rrLvnED16bITi3RsntWTkUzM3UN0lnJSEh/BldDuDvVLGeRxTF4P5msD3XFTHIqz2ksgg85lgxhR8/ogyna9XRIg+WnYCje83dZr2fxY8VXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=microchip.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q7pSDDnTtWccFqPfLsmdKiGXHH/8P8jrumR67O/nDwg=;
 b=UEDbhzLwp33zB4GQk0NfYEN99x1Ulx1ltAg00UicYCPopzhJS9VwcBHfnFzC7OwbpN/F6LaOZe7cQjgiIZ+fhTV/x7nYePPTX78pnxnEx2aeo+/O/AiH03/WumY5AV8VCBxMsjs8meJpPrUBlD/++9fnu7IXvv8/7sBYx8ozwSjE5eFBnUOSV4jzEqBiE9pXdqqQYXSM2jTcbQWbfxONtds85vPWgek6IHn2idMV13O2kRioEkOQh+ZyGK4m4bX91nKcAlnN+swBloY1UEAFKr9jMeB9RlCRpjFiUPDFe6JW1zChWNp0QTMIffpATzs+fBAxGNBELV6On7nCebxZEA==
Received: from MW4PR03CA0340.namprd03.prod.outlook.com (2603:10b6:303:dc::15)
 by SA1PR12MB5669.namprd12.prod.outlook.com (2603:10b6:806:237::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Thu, 24 Nov
 2022 16:02:31 +0000
Received: from CO1NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dc:cafe::9c) by MW4PR03CA0340.outlook.office365.com
 (2603:10b6:303:dc::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19 via Frontend
 Transport; Thu, 24 Nov 2022 16:02:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT063.mail.protection.outlook.com (10.13.175.37) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.8 via Frontend Transport; Thu, 24 Nov 2022 16:02:31 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 24 Nov
 2022 08:02:25 -0800
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 24 Nov
 2022 08:02:22 -0800
References: <20221122104112.144293-1-daniel.machon@microchip.com>
 <20221122104112.144293-2-daniel.machon@microchip.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Daniel Machon <daniel.machon@microchip.com>
CC:     <netdev@vger.kernel.org>, <dsahern@kernel.org>,
        <stephen@networkplumber.org>, <petrm@nvidia.com>,
        <maxime.chevallier@bootlin.com>, <vladimir.oltean@nxp.com>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH iproute2-next 1/2] dcb: add new pcp-prio parameter to
 dcb app
Date:   Thu, 24 Nov 2022 16:30:41 +0100
In-Reply-To: <20221122104112.144293-2-daniel.machon@microchip.com>
Message-ID: <87wn7kibn8.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT063:EE_|SA1PR12MB5669:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d1cd65f-e0f7-446f-0081-08dace354b28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ffdTZUXRcnc0BPo7q+qGygbnM6JGQXgvuUuipVsngzX2JxZxtqRNLiYsnF0k1V0YfwemNLNuV1vgDzKoc0GMd65W2uUG17gqsiLNPKBX/4MSGxxe3zW9GIePHa7wC0S1PrjGhBvbr5QyabbPgjAY/0R8ormcmJdbKAD/rdgifzIGPVGPVyqUcUXhvjAzAcN9iC5urTxh6jQHe+DuJNKdfdCUVTqLTqXCS8O5KylNfA5BbmTnMo5f+rAJbHWJlZV+C7YN02+OTBQazW5myy/YZx9R7CjsvZ5Wb+K/ttT1MYbkKbCnwnOura2YgQhtBb53zbtZ8BxNU+c6KdyR6TzQEUYcJ0nDb1n16+1OkjOScsNSgFwsY2/y8PsyeaRG8qkViYBkMcrQAOCGYreO4dYKcm3ivpGM4RL+BoID9KCFcomLORkZdypp3ElXWzYIhFPlfkBIzcJ/dkcjTjXLFeujM1/nrDoEZ6AeIhNqDGpmK2ODOvna4tiYjR+KabkMXkD/X57Uv2fL4cXyR/Z4jH+SE35NtBbwjBVzsL/pPFvu1ME3sht4JUtnEf/otSBhPzcSd9sgYsG/5cyyWzFhmJzLN3hVPY/c9ECESeDgwau+CnOH4wQDvospGSx2DgykACm+XNtY+czHJsM55hl5ll12q+h4865k3mf7R/QCuOUvhVn/f6LpHcEVEuCemYPSIi5BvoFwClI8p/DeklOY13cg9w==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(136003)(346002)(451199015)(36840700001)(40470700004)(46966006)(86362001)(70586007)(82740400003)(70206006)(40460700003)(7636003)(356005)(41300700001)(4326008)(8676002)(82310400005)(54906003)(8936002)(30864003)(6916009)(316002)(5660300002)(83380400001)(2906002)(47076005)(426003)(36860700001)(40480700001)(6666004)(478600001)(2616005)(336012)(16526019)(186003)(26005)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2022 16:02:31.4910
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d1cd65f-e0f7-446f-0081-08dace354b28
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5669
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This looks good to me overall, I just have a few nits.

Daniel Machon <daniel.machon@microchip.com> writes:

> Add new pcp-prio parameter to the app subcommand, which can be used to
> classify traffic based on PCP and DEI from the VLAN header. PCP and DEI
> is specified in a combination of numerical and symbolic form, where 'de'
> (as specified in the PCP Encoding Table, 802.1Q) means DEI=1.
>
> Map PCP 1 and DEI 0 to priority 1 $ dcb app add dev eth0 pcp-prio 1:1
>
> Map PCP 1 and DEI 1 to priority 1 $ dcb app add dev eth0 pcp-prio 1de:1
>
> Internally, PCP and DEI is encoded in the protocol field of the dcb_app
> struct. Each combination of PCP and DEI maps to a priority, thus needing
> a range of  0-15. A well formed dcb_app entry for PCP/DEI
> prioritization, could look like:
>
>     struct dcb_app pcp = {
>         .selector = DCB_APP_SEL_PCP,
> 	.priority = 7,
>         .protocol = 15
>     }
>
> For mapping PCP=7 and DEI=1 to Prio=7.
>
> Also, two helper functions for translating between std and non-std APP
> selectors, have been added to dcb_app.c and exposed through dcb.h.

Could you include an example or two of how PCP is configured? E.g. the
following was part of the dcb-app submission:

    # dcb app add dev eni1np1 dscp-prio 0:0 CS3:3 CS6:6
    # dcb app show dev eni1np1
    dscp-prio 0:0 CS3:3 CS6:6


> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
> ---
>  dcb/dcb.h          |   3 +
>  dcb/dcb_app.c      | 138 +++++++++++++++++++++++++++++++++++++++++++--
>  man/man8/dcb-app.8 |  27 +++++++++
>  3 files changed, 162 insertions(+), 6 deletions(-)
>
> diff --git a/dcb/dcb.h b/dcb/dcb.h
> index 244c3d3c30e3..05eddcbbcfdf 100644
> --- a/dcb/dcb.h
> +++ b/dcb/dcb.h
> @@ -57,6 +57,9 @@ void dcb_print_array_kw(const __u8 *array, size_t array_size,
>  /* dcb_app.c */
>  
>  int dcb_cmd_app(struct dcb *dcb, int argc, char **argv);
> +enum ieee_attrs_app dcb_app_attr_type_get(__u8 selector);
> +bool dcb_app_attr_type_validate(enum ieee_attrs_app type);
> +bool dcb_app_selector_validate(enum ieee_attrs_app type, __u8 selector);
>  
>  /* dcb_buffer.c */
>  
> diff --git a/dcb/dcb_app.c b/dcb/dcb_app.c
> index dad34554017a..0d4a82e1e502 100644
> --- a/dcb/dcb_app.c
> +++ b/dcb/dcb_app.c
> @@ -10,6 +10,16 @@
>  #include "utils.h"
>  #include "rt_names.h"
>  
> +static const char *const pcp_names[16] = {
> +	"0",   "1",   "2",   "3",   "4",   "5",   "6",   "7",
> +	"0de", "1de", "2de", "3de", "4de", "5de", "6de", "7de"
> +};
> +
> +static const char *const ieee_attrs_app_names[__DCB_ATTR_IEEE_APP_MAX] = {
> +	[DCB_ATTR_IEEE_APP] = "DCB_ATTR_IEEE_APP",
> +	[DCB_ATTR_DCB_APP] = "DCB_ATTR_DCB_APP"
> +};
> +
>  static void dcb_app_help_add(void)
>  {
>  	fprintf(stderr,
> @@ -20,11 +30,13 @@ static void dcb_app_help_add(void)
>  		"           [ dgram-port-prio PORT:PRIO ]\n"
>  		"           [ port-prio PORT:PRIO ]\n"
>  		"           [ dscp-prio INTEGER:PRIO ]\n"
> +		"           [ pcp-prio INTEGER:PRIO ]\n"

This should say PCP:PRIO, not INTEGER:PRIO.

>  		"\n"
>  		" where PRIO := { 0 .. 7 }\n"
>  		"       ET := { 0x600 .. 0xffff }\n"
>  		"       PORT := { 1 .. 65535 }\n"
>  		"       DSCP := { 0 .. 63 }\n"
> +		"       PCP := { 0(de) .. 7(de) }\n"
>  		"\n"
>  	);
>  }
> @@ -39,6 +51,7 @@ static void dcb_app_help_show_flush(void)
>  		"           [ dgram-port-prio ]\n"
>  		"           [ port-prio ]\n"
>  		"           [ dscp-prio ]\n"
> +		"           [ pcp-prio ]\n"
>  		"\n"
>  	);
>  }
> @@ -58,6 +71,38 @@ struct dcb_app_table {
>  	size_t n_apps;
>  };
>  
> +enum ieee_attrs_app dcb_app_attr_type_get(__u8 selector)
> +{
> +	switch (selector) {
> +	case IEEE_8021QAZ_APP_SEL_ETHERTYPE:
> +	case IEEE_8021QAZ_APP_SEL_STREAM:
> +	case IEEE_8021QAZ_APP_SEL_DGRAM:
> +	case IEEE_8021QAZ_APP_SEL_ANY:
> +	case IEEE_8021QAZ_APP_SEL_DSCP:
> +		return DCB_ATTR_IEEE_APP;
> +	case DCB_APP_SEL_PCP:
> +		return DCB_ATTR_DCB_APP;
> +	default:
> +		return DCB_ATTR_IEEE_APP_UNSPEC;
> +	}
> +}
> +
> +bool dcb_app_attr_type_validate(enum ieee_attrs_app type)
> +{
> +	switch (type) {
> +	case DCB_ATTR_IEEE_APP:
> +	case DCB_ATTR_DCB_APP:
> +		return true;
> +	default:
> +		return false;
> +	}
> +}
> +
> +bool dcb_app_selector_validate(enum ieee_attrs_app type, __u8 selector)
> +{
> +	return dcb_app_attr_type_get(selector) == type;
> +}
> +
>  static void dcb_app_table_fini(struct dcb_app_table *tab)
>  {
>  	free(tab->apps);
> @@ -213,6 +258,32 @@ static int dcb_app_parse_mapping_ethtype_prio(__u32 key, char *value, void *data
>  				 dcb_app_parse_mapping_cb, data);
>  }
>  
> +static int dcb_app_parse_pcp(__u32 *key, const char *arg)
> +{
> +	int ret, res;
> +
> +	res = parse_one_of("pcp-names", arg, pcp_names,
> +			   ARRAY_SIZE(pcp_names), &ret);
> +	if (ret < 0)
> +		return ret;
> +
> +	*key = res;
> +
> +	return 0;
> +}
> +
> +static int dcb_app_parse_mapping_pcp_prio(__u32 key, char *value, void *data)
> +{
> +	__u8 prio;
> +
> +	if (get_u8(&prio, value, 0))
> +		return -EINVAL;
> +
> +	return dcb_parse_mapping("PCP", key, 15,
> +				 "PRIO", prio, IEEE_8021QAZ_MAX_TCS - 1,
> +				 dcb_app_parse_mapping_cb, data);
> +}
> +
>  static int dcb_app_parse_dscp(__u32 *key, const char *arg)
>  {
>  	if (parse_mapping_num_all(key, arg) == 0)
> @@ -309,6 +380,11 @@ static bool dcb_app_is_dscp(const struct dcb_app *app)
>  	return app->selector == IEEE_8021QAZ_APP_SEL_DSCP;
>  }
>  
> +static bool dcb_app_is_pcp(const struct dcb_app *app)
> +{
> +	return app->selector == DCB_APP_SEL_PCP;
> +}
> +
>  static bool dcb_app_is_stream_port(const struct dcb_app *app)
>  {
>  	return app->selector == IEEE_8021QAZ_APP_SEL_STREAM;
> @@ -344,6 +420,17 @@ static int dcb_app_print_key_dscp(__u16 protocol)
>  	return print_uint(PRINT_ANY, NULL, "%d:", protocol);
>  }
>  
> +static int dcb_app_print_key_pcp(__u16 protocol)
> +{
> +	/* Print in numerical form, if protocol value is out-of-range */
> +	if (protocol > 15) {
> +		fprintf(stderr, "Unknown PCP key: %d\n", protocol);
> +		return print_uint(PRINT_ANY, NULL, "%d:", protocol);
> +	}
> +
> +	return print_string(PRINT_ANY, NULL, "%s:", pcp_names[protocol]);
> +}
> +
>  static void dcb_app_print_filtered(const struct dcb_app_table *tab,
>  				   bool (*filter)(const struct dcb_app *),
>  				   int (*print_key)(__u16 protocol),
> @@ -382,6 +469,15 @@ static void dcb_app_print_ethtype_prio(const struct dcb_app_table *tab)
>  			       "ethtype_prio", "ethtype-prio");
>  }
>  
> +static void dcb_app_print_pcp_prio(const struct dcb *dcb,
> +				   const struct dcb_app_table *tab)
> +{
> +	dcb_app_print_filtered(tab, dcb_app_is_pcp,
> +			       dcb->numeric ? dcb_app_print_key_dec
> +					    : dcb_app_print_key_pcp,
> +			       "pcp_prio", "pcp-prio");
> +}
> +
>  static void dcb_app_print_dscp_prio(const struct dcb *dcb,
>  				    const struct dcb_app_table *tab)
>  {
> @@ -439,26 +535,41 @@ static void dcb_app_print(const struct dcb *dcb, const struct dcb_app_table *tab
>  	dcb_app_print_stream_port_prio(tab);
>  	dcb_app_print_dgram_port_prio(tab);
>  	dcb_app_print_port_prio(tab);
> +	dcb_app_print_pcp_prio(dcb, tab);
>  }
>  
>  static int dcb_app_get_table_attr_cb(const struct nlattr *attr, void *data)
>  {
>  	struct dcb_app_table *tab = data;
>  	struct dcb_app *app;
> +	uint16_t type;
>  	int ret;
>  
> -	if (mnl_attr_get_type(attr) != DCB_ATTR_IEEE_APP) {
> -		fprintf(stderr, "Unknown attribute in DCB_ATTR_IEEE_APP_TABLE: %d\n",
> -			mnl_attr_get_type(attr));
> +	type = mnl_attr_get_type(attr);
> +
> +	if (!dcb_app_attr_type_validate(type)) {
> +		fprintf(stderr,
> +			"Unknown attribute in DCB_ATTR_IEEE_APP_TABLE: %d\n",
> +			type);
>  		return MNL_CB_OK;
>  	}
>  	if (mnl_attr_get_payload_len(attr) < sizeof(struct dcb_app)) {
> -		fprintf(stderr, "DCB_ATTR_IEEE_APP payload expected to have size %zd, not %d\n",
> -			sizeof(struct dcb_app), mnl_attr_get_payload_len(attr));
> +		fprintf(stderr,
> +			"%s payload expected to have size %zd, not %d\n",
> +			ieee_attrs_app_names[type], sizeof(struct dcb_app),
> +			mnl_attr_get_payload_len(attr));
>  		return MNL_CB_OK;
>  	}
>  
>  	app = mnl_attr_get_payload(attr);
> +
> +	/* Check that selector is encapsulated in the right attribute */
> +	if (!dcb_app_selector_validate(type, app->selector)) {
> +		fprintf(stderr, "Wrong selector for type: %s\n",
> +			ieee_attrs_app_names[type]);
> +		return MNL_CB_OK;
> +	}
> +
>  	ret = dcb_app_table_push(tab, app);
>  	if (ret != 0)
>  		return MNL_CB_ERROR;
> @@ -491,6 +602,7 @@ struct dcb_app_add_del {
>  static int dcb_app_add_del_cb(struct dcb *dcb, struct nlmsghdr *nlh, void *data)
>  {
>  	struct dcb_app_add_del *add_del = data;
> +	enum ieee_attrs_app type;
>  	struct nlattr *nest;
>  	size_t i;
>  
> @@ -498,9 +610,10 @@ static int dcb_app_add_del_cb(struct dcb *dcb, struct nlmsghdr *nlh, void *data)
>  
>  	for (i = 0; i < add_del->tab->n_apps; i++) {
>  		const struct dcb_app *app = &add_del->tab->apps[i];
> +		type = dcb_app_attr_type_get(app->selector);
>  
>  		if (add_del->filter == NULL || add_del->filter(app))
> -			mnl_attr_put(nlh, DCB_ATTR_IEEE_APP, sizeof(*app), app);
> +			mnl_attr_put(nlh, type, sizeof(*app), app);
>  	}
>  
>  	mnl_attr_nest_end(nlh, nest);
> @@ -577,6 +690,12 @@ static int dcb_cmd_app_parse_add_del(struct dcb *dcb, const char *dev,
>  			ret = parse_mapping(&argc, &argv, false,
>  					    &dcb_app_parse_mapping_port_prio,
>  					    &pm);
> +		} else if (strcmp(*argv, "pcp-prio") == 0) {
> +			NEXT_ARG();
> +			pm.selector = DCB_APP_SEL_PCP;
> +			ret = parse_mapping_gen(&argc, &argv, &dcb_app_parse_pcp,
> +						&dcb_app_parse_mapping_pcp_prio,
> +						&pm);
>  		} else {
>  			fprintf(stderr, "What is \"%s\"?\n", *argv);
>  			dcb_app_help_add();
> @@ -656,6 +775,8 @@ static int dcb_cmd_app_show(struct dcb *dcb, const char *dev, int argc, char **a
>  			dcb_app_print_port_prio(&tab);
>  		} else if (matches(*argv, "default-prio") == 0) {
>  			dcb_app_print_default_prio(&tab);
> +		} else if (strcmp(*argv, "pcp-prio") == 0) {
> +			dcb_app_print_pcp_prio(dcb, &tab);
>  		} else {
>  			fprintf(stderr, "What is \"%s\"?\n", *argv);
>  			dcb_app_help_show_flush();
> @@ -705,6 +826,11 @@ static int dcb_cmd_app_flush(struct dcb *dcb, const char *dev, int argc, char **
>  					      &dcb_app_is_dscp);
>  			if (ret != 0)
>  				goto out;
> +		} else if (strcmp(*argv, "pcp-prio") == 0) {
> +			ret = dcb_app_add_del(dcb, dev, DCB_CMD_IEEE_DEL, &tab,
> +					      &dcb_app_is_pcp);
> +			if (ret != 0)
> +				goto out;
>  		} else {
>  			fprintf(stderr, "What is \"%s\"?\n", *argv);
>  			dcb_app_help_show_flush();
> diff --git a/man/man8/dcb-app.8 b/man/man8/dcb-app.8
> index 9780fe4b60fa..054ba9801d81 100644
> --- a/man/man8/dcb-app.8
> +++ b/man/man8/dcb-app.8
> @@ -23,6 +23,7 @@ the DCB (Data Center Bridging) subsystem
>  .RB "[ " dgram-port-prio " ]"
>  .RB "[ " port-prio " ]"
>  .RB "[ " dscp-prio " ]"
> +.RB "[ " pcp-prio " ]"
>  
>  .ti -8
>  .B dcb ets " { " add " | " del " | " replace " } " dev
> @@ -33,6 +34,7 @@ the DCB (Data Center Bridging) subsystem
>  .RB "[ " dgram-port-prio " " \fIPORT-MAP\fB " ]"
>  .RB "[ " port-prio " " \fIPORT-MAP\fB " ]"
>  .RB "[ " dscp-prio " " \fIDSCP-MAP\fB " ]"
> +.RB "[ " pcp-prio " " \fIPCP-MAP\fB " ]"
>  
>  .ti -8
>  .IR PRIO-LIST " := [ " PRIO-LIST " ] " PRIO
> @@ -64,6 +66,9 @@ the DCB (Data Center Bridging) subsystem
>  .ti -8
>  .IR DSCP " := { " \fB0\fR " .. " \fB63\fR " }"
>  
> +.ti -8
> +.IR PCP " := { " \fB0\fR " .. " \fB7\fR " }"
> +
>  .ti -8
>  .IR PRIO " := { " \fB0\fR " .. " \fB7\fR " }"
>  
> @@ -182,6 +187,18 @@ command line option
>  .B -N
>  turns the show translation off.
>  
> +.TP
> +.B pcp-prio \fIPCP-MAP
> +\fIPCP-MAP\fR uses the array parameter syntax, see
> +.BR dcb (8)
> +for details. Keys are PCP/DEI values. Values are priorities assigned to traffic
> +with matching PCP and DEI. PCP/DEI values are written as a combination of
> +numeric- and symbolic values, to accommodate for both PCP and DEI. PCP always
> +in numerical form e.g 1 .. 7 and DEI in symbolic form e.g 'de', indicating that

0..7?

> +the DEI bit is 1.  In combination 2de:1 translates to a mapping of PCP=2 and
> +DEI=1 to priority 1. In a hardware offloaded context, the DEI bit can be mapped
> +directly to drop-precedence (DP) by the driver.

The last sentence about drivers doesn't belong to this man page IMHO.
Besides I'm not sure it's even correct: there is no notion of in-ASIC
drop eligibility here, just mapping between 802.1q priority+de headers
and in-ASIC priority.

> +
>  .SH EXAMPLE & USAGE
>  
>  Prioritize traffic with DSCP 0 to priority 0, 24 to 3 and 48 to 6:
> @@ -221,6 +238,16 @@ Flush all DSCP rules:
>  .br
>  (nothing)
>  
> +Add a rule to map traffic with PCP 1 and DEI 0 to priority 1 and PCP 2 and DEI 1
> +to priority 2:
> +
> +.P
> +# dcb app add dev eth0 pcp-prio 1:1 2de:2
> +.br
> +# dcb app show dev eth0 pcp-prio
> +.br
> +pcp-prio 1:1 2de:2
> +
>  .SH EXIT STATUS
>  Exit status is 0 if command was successful or a positive integer upon failure.

