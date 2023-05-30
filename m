Return-Path: <netdev+bounces-6552-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BBAD716E3B
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 21:58:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 03B17281304
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 19:58:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39A7331EE9;
	Tue, 30 May 2023 19:58:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 287562D27E
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 19:58:14 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2074.outbound.protection.outlook.com [40.107.92.74])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE300F9
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 12:58:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nl2ZA3bjiitJhBU8aZCz6mvEFBcWr4BED4OctSnZVlmyY8BR+NLUmFZ4YzStnb951M82kLXksuctI+Hb4/hQqHJfXMYT9PynrGfXznBZicFCyyV+2W0eh05OvejC7mQrBxgCgZgduDsb599woWhGj68CECOz/aztl+xXGlUyRiHTg92tgaJ1Yu53HfqchJ/GyylTz3KcP1zd+8QmDvaqrEQxNRxFcIbN6xF25fA+09g3zzIts0F7J7sLsF5o244ZoKbTktNhCXYm3yYwB/Qhv4imJcF6I3+Ic6yOJMEWA0jShCIrbuQz5UwJW7L7+MXWPOe0JHCeD8g7XiO/ZWcDsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UgITFy3wwp7D1/lRBanPrlSGS58wCOH3Ee788g5KavA=;
 b=IUgrQhX/AjPXvQepUqENJmjNWvh7CQv1roqME4nyqz46Sds6fg1WFzqR2a6cDpG/8NaSHekSHKQ4oNVFKfzoRDMGgkv7WMvqqv9P+z+q6NgLLoziA4BnyV212fjxhiVYzDwGTd9Ras2+sOTRuxzoFUKrpIc+owlZ7DBOft5tCer1dT/gQhX+TeSZs8TUrogk4uFMiYNXwQGUCPbeEnZM2gBTTyXRP3uWo/83u7CL1Txe8cDn9OVhvcVBO7oGV0YzJd7zYHk5XYUHbWb94DuA2HI1DNiXPtGQOYIGU+trBP+Ce5CLa73IzXS0vNl02nRNzcxVCjJDnIHIJFVmEgQFYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=microchip.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UgITFy3wwp7D1/lRBanPrlSGS58wCOH3Ee788g5KavA=;
 b=ohTzu62ZsvhNOv/rbrIT2VrPfLZYB0fP4xJntTZ6aD3UTnDnHJyUuDvgS6hu+2pDXsdK/ZYLMR+XlQMu1azOam27g+HrOYYlN9o45K02iNh1k4XODdw5HltQqZT8mByfmOjVKpzWp1F4m6jaS9vrfXvvSuzsdMVsVxVl963rtKr/QKv9NJIuYjA9kKNtsHSffXwfvC9nHPiKLhnNWA0p5SQnEPORkXybfOmq6Q8Kl4zWwAFs+IEGGxZ2INQSqfKVWOhxnj+CFKkWRFVRvsJA+5Fp1q+kfqhlOiQ0aPw04xTuaigx4S/yTZMz9wbG20Arl2Oy+RQ6QMgypvMDlFRfwg==
Received: from SJ0P220CA0013.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:41b::20)
 by PH7PR12MB8121.namprd12.prod.outlook.com (2603:10b6:510:2b5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 19:58:10 +0000
Received: from DM6NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:a03:41b:cafe::e2) by SJ0P220CA0013.outlook.office365.com
 (2603:10b6:a03:41b::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23 via Frontend
 Transport; Tue, 30 May 2023 19:58:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT015.mail.protection.outlook.com (10.13.172.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.22 via Frontend Transport; Tue, 30 May 2023 19:58:09 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 30 May 2023
 12:57:58 -0700
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 30 May
 2023 12:57:55 -0700
References: <20230510-dcb-rewr-v2-0-9f38e688117e@microchip.com>
 <20230510-dcb-rewr-v2-4-9f38e688117e@microchip.com>
User-agent: mu4e 1.6.6; emacs 28.1
From: Petr Machata <petrm@nvidia.com>
To: Daniel Machon <daniel.machon@microchip.com>
CC: <netdev@vger.kernel.org>, <dsahern@kernel.org>,
	<stephen@networkplumber.org>, <petrm@nvidia.com>,
	<UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH iproute2-next v2 4/8] dcb: app: modify
 dcb_app_parse_mapping_cb for dcb-rewr reuse
Date: Tue, 30 May 2023 21:50:46 +0200
In-Reply-To: <20230510-dcb-rewr-v2-4-9f38e688117e@microchip.com>
Message-ID: <874jnt618e.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT015:EE_|PH7PR12MB8121:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b47ffc1-093d-45c8-6d2d-08db6148316d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	lAWBvaL/0ZSwGE/iOCXS6P1FVbzWUDrDVBz4WQqLfIfjHnMlvp/E/IsHDrM+Ll1vtqc7dNIb3iuFhLvsL4sXpq034ZQwxGud8pZKcglc37dqJdPkND0xCxt8E8Ffh45n2Uco7oS6I7Ni3Qd56ZlQMUBScQyJijsTj0jPvnqEYIkTjBa/M5vpuu08+hLvDoEbGwVKkCWSc0QbO+YOrFoyjO2g7fZOxpSxqFUnhkjQdWoBBpSnMQfLd7j0hqJ3fC93YzLBgRoN+4+ZFScJp5GBIsAqep1CRWC9I6bzSREiAJp55WalabdThs942EH0RJmIWk9VuTxqZnL5JqYQd6njw7uLaDA3DM1JxDyAznGTDpizYzNfS+uImMcZ/1CjPEIPRffkC0jCNOifvKXGrR8NOyEZ66Vgl6gyc4mI4UJD9N3ry0fo2N2Em8YNJ5rr13VRJdgyEJeOSH3kg7o70c5ujAbcm1Y13IS/s8fflXZ+wPH7A3jifnAzw6uSP5VjnmPq5MGV4Ve11ZJ6RMSjQTixrESHQX2bv2NjnmS1nWnhctd1IdxCAlHL+AgGCUfLb19GrJ4U5Y0bYYqO4vIk2l7+mH/khBDe8Xxi9eYcFzGacTiziTS2y3B2sQzw5bF5q1P9qD5KmsYv6ECxTVNUMI2gGSxaDdBfCw6hCJUojNidTn2wZy6TmBc+iOEjOjoRGJRlBOJBw6BI2PBhiXMWnSb9zEH96AUmG91ii1b6jSw6N1iecJHqxea1aX2sYiCdFkUF
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(376002)(39860400002)(136003)(451199021)(40470700004)(36840700001)(46966006)(54906003)(478600001)(8936002)(40460700003)(8676002)(82310400005)(36756003)(2906002)(5660300002)(86362001)(6916009)(356005)(7636003)(4326008)(70586007)(70206006)(82740400003)(316002)(40480700001)(41300700001)(2616005)(16526019)(186003)(26005)(36860700001)(47076005)(6666004)(426003)(336012)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 19:58:09.6445
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b47ffc1-093d-45c8-6d2d-08db6148316d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8121
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


Daniel Machon <daniel.machon@microchip.com> writes:

> When parsing APP table entries, priority and protocol is assigned from
> value and key, respectively. Rewrite requires it opposite.
>
> Adapt the existing dcb_app_parse_mapping_cb for this, by using callbacks
> for pushing app or rewr entries to the table.
>
> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
> ---
>  dcb/dcb.h     | 12 ++++++++++++
>  dcb/dcb_app.c | 23 ++++++++++++-----------
>  2 files changed, 24 insertions(+), 11 deletions(-)
>
> diff --git a/dcb/dcb.h b/dcb/dcb.h
> index 84ce95d5c1b2..b3bc30cd02c5 100644
> --- a/dcb/dcb.h
> +++ b/dcb/dcb.h
> @@ -62,7 +62,16 @@ struct dcb_app_table {
>  	int attr;
>  };
>  
> +struct dcb_app_parse_mapping {
> +	__u8 selector;
> +	struct dcb_app_table *tab;
> +	int (*push)(struct dcb_app_table *tab,
> +		    __u8 selector, __u32 key, __u64 value);
> +	int err;
> +};
> +
>  int dcb_cmd_app(struct dcb *dcb, int argc, char **argv);
> +
>  enum ieee_attrs_app dcb_app_attr_type_get(__u8 selector);
>  bool dcb_app_attr_type_validate(enum ieee_attrs_app type);
>  bool dcb_app_selector_validate(enum ieee_attrs_app type, __u8 selector);
> @@ -70,11 +79,14 @@ bool dcb_app_selector_validate(enum ieee_attrs_app type, __u8 selector);
>  bool dcb_app_pid_eq(const struct dcb_app *aa, const struct dcb_app *ab);
>  bool dcb_app_prio_eq(const struct dcb_app *aa, const struct dcb_app *ab);
>  
> +int dcb_app_table_push(struct dcb_app_table *tab, struct dcb_app *app);
>  void dcb_app_table_remove_replaced(struct dcb_app_table *a,
>  				   const struct dcb_app_table *b,
>  				   bool (*key_eq)(const struct dcb_app *aa,
>  						  const struct dcb_app *ab));
>  
> +void dcb_app_parse_mapping_cb(__u32 key, __u64 value, void *data);
> +
>  /* dcb_apptrust.c */
>  
>  int dcb_cmd_apptrust(struct dcb *dcb, int argc, char **argv);
> diff --git a/dcb/dcb_app.c b/dcb/dcb_app.c
> index 4cd175a0623b..97cba658aa6b 100644
> --- a/dcb/dcb_app.c
> +++ b/dcb/dcb_app.c
> @@ -105,7 +105,7 @@ static void dcb_app_table_fini(struct dcb_app_table *tab)
>  	free(tab->apps);
>  }
>  
> -static int dcb_app_table_push(struct dcb_app_table *tab, struct dcb_app *app)
> +int dcb_app_table_push(struct dcb_app_table *tab, struct dcb_app *app)
>  {
>  	struct dcb_app *apps = realloc(tab->apps, (tab->n_apps + 1) * sizeof(*tab->apps));
>  
> @@ -231,25 +231,25 @@ static void dcb_app_table_sort(struct dcb_app_table *tab)
>  	qsort(tab->apps, tab->n_apps, sizeof(*tab->apps), dcb_app_cmp_cb);
>  }
>  
> -struct dcb_app_parse_mapping {
> -	__u8 selector;
> -	struct dcb_app_table *tab;
> -	int err;
> -};
> -
> -static void dcb_app_parse_mapping_cb(__u32 key, __u64 value, void *data)
> +static int dcb_app_push(struct dcb_app_table *tab,
> +			__u8 selector, __u32 key, __u64 value)
>  {
> -	struct dcb_app_parse_mapping *pm = data;
>  	struct dcb_app app = {
> -		.selector = pm->selector,
> +		.selector = selector,
>  		.priority = value,
>  		.protocol = key,
>  	};
> +	return dcb_app_table_push(tab, &app);
> +}
> +
> +void dcb_app_parse_mapping_cb(__u32 key, __u64 value, void *data)
> +{
> +	struct dcb_app_parse_mapping *pm = data;
>  
>  	if (pm->err)
>  		return;
>  
> -	pm->err = dcb_app_table_push(pm->tab, &app);
> +	pm->err = pm->push(pm->tab, pm->selector, key, value);
>  }
>  
>  static int dcb_app_parse_mapping_ethtype_prio(__u32 key, char *value, void *data)
> @@ -663,6 +663,7 @@ static int dcb_cmd_app_parse_add_del(struct dcb *dcb, const char *dev,
>  {
>  	struct dcb_app_parse_mapping pm = {
>  		.tab = tab,
> +		.push = dcb_app_push,
>  	};
>  	int ret;

I think I misunderstood your code. Since you are adding new functions
for parsing the PRIO-DSCP and PRIO-PCP mappings, which have their own
dcb_parse_mapping() invocations, couldn't you just copy over the
dcb_app_parse_mapping_cb() from APP and adapt it to do the right thing
for REWR? Then the push callback is not even necessary
dcb_app_parse_mapping_cb() does not need to be public.

