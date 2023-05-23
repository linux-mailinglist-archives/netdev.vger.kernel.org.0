Return-Path: <netdev+bounces-4716-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D937370DFD7
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 17:02:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 941B328136C
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 15:02:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D85761F92C;
	Tue, 23 May 2023 15:02:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17CB1E524
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 15:02:21 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2052.outbound.protection.outlook.com [40.107.237.52])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 062C011A
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 08:02:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZNOu9mOisglDxQ0fIr4SgseQsAEzYlB7XzCzfTrVmqLh2IDk3G3uapLKZUv7vks+l6t6bqNBOpu60CNAVq5e+NBcTWi5dSUv//K368aTtSB+wrs/6IUJZH3hnX3o0R7XHmBzgdJzThnSpi1z5gB+SJkKol74jz5PazmpKh3S8xFYh7HgTT/GD2Iz/xYIozzQRc1rVaXUCd4Is9squssoVLgoe5UFinXGwFji0y7+HwoZjafwOMc6E+xcFKf17/6fiiY9F/8zDIX1AVZFAqYTVBv7ljSQ508mvMVf6yc6I8BLRNjR/vUhrUEewo0z7OHvwxNT7Cl4yYBa5JWdeEn+uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ymMrrHekSvoKTeREa0kJCsnwTxEn4WE5DBnzVBtblms=;
 b=EvWSuqZ6wIhm5KXdlK/aonCVDqFITkVy2NmUJ8l+OnVYKbGhGwv0QUdU9NTnS9wqtJqtRSk4GnxD7lOdT94JyH57/Oytdi94mRe3R0Lm3f8X2w0rYb8ptO/roQRJa2DN3VJdXc2hF1lATyLdz34vUyhXwFbR79NdA8zqU0w6T14qHl1yCHS409QNAH2iHOR4R73WpXeNee8eKU6MJfyBSvkGGhyjI6FZ/ylwu61zdyfe7a0C0zQrFIjt8li2AAKJfE/VhdDau2qz2+yI25sIwrQP+N0FALHIsrmn0CvltMPi4bit5s+ludjglSYxBT4F+imEJOTbHCiwlZsHSlLB+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=microchip.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ymMrrHekSvoKTeREa0kJCsnwTxEn4WE5DBnzVBtblms=;
 b=n0N0FC0O+c/IqIwMHzc60qlYkDyOHcaezZ8QPTjgqvgFiu2KwpGgfAeUATkZKAs2thTmBykbu8DDG19wyMw7qqPjcJHA6UPYTXmXiVRC+lrPaDcBxj+weowP+mkG3BPktnCSyVghaBIgj/bWEiLvzYM86QJ5gMSH6kkeaRw0rmcpKL3f8flGnsHrvUuxVai1u1KpLxrdHkTXMaiUO3WZpXLNhsFfGZm2OYJpNiM+N4y6NLkR6HYuzw/YH+wMuhWIUeOnV0Gpi50of5evuH0gKjRlAQq8bvsXk2QfgYG8sIha2HPIKBCHwxYozfonz+O+LZ2j4xcEzKXpaUoX1kgzpg==
Received: from MW4PR03CA0156.namprd03.prod.outlook.com (2603:10b6:303:8d::11)
 by BL0PR12MB4930.namprd12.prod.outlook.com (2603:10b6:208:1c8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.14; Tue, 23 May
 2023 15:02:18 +0000
Received: from CO1NAM11FT007.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8d:cafe::e0) by MW4PR03CA0156.outlook.office365.com
 (2603:10b6:303:8d::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28 via Frontend
 Transport; Tue, 23 May 2023 15:02:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT007.mail.protection.outlook.com (10.13.174.131) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.30 via Frontend Transport; Tue, 23 May 2023 15:02:17 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 23 May 2023
 08:02:06 -0700
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 23 May
 2023 08:02:04 -0700
References: <20230510-dcb-rewr-v1-0-83adc1f93356@microchip.com>
 <20230510-dcb-rewr-v1-4-83adc1f93356@microchip.com>
User-agent: mu4e 1.6.6; emacs 28.1
From: Petr Machata <petrm@nvidia.com>
To: Daniel Machon <daniel.machon@microchip.com>
CC: <netdev@vger.kernel.org>, <dsahern@kernel.org>,
	<stephen@networkplumber.org>, <petrm@nvidia.com>,
	<UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH iproute2-next 4/9] dcb: app: modify
 dcb_app_table_remove_replaced() for dcb-rewr reuse
Date: Tue, 23 May 2023 16:42:16 +0200
In-Reply-To: <20230510-dcb-rewr-v1-4-83adc1f93356@microchip.com>
Message-ID: <87cz2r5bx1.fsf@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT007:EE_|BL0PR12MB4930:EE_
X-MS-Office365-Filtering-Correlation-Id: 9408fc44-6ba7-43b9-b4f9-08db5b9eb355
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	M+PqCJ6aXdHrovCGifhh8sFpsfl++u+8U5UoGjbtaFDnsbajOqnDWnCDH1OU4vxHF8+Usn/Zneo6qtbTMfXflJWcn6vZJO02Ih3OIY38sIhMAipuLsyrC9ea4KOKhpCLLQtk3XWvUU5wTci0xLKDk4bOzn34M4WJivwAmHPTuipByuL3GSnu/1lCbuNd4LM/vzaj5aBbXD4nYkg+PqzeiaSoxWagku/RVKopmuz1f2W5Umi8fexEq6jXu1WJrCZVK4IBP/JlcfdmTawhkXESadufPk4h+T8o8tX8euahn76mDhB52ZzyVr12+tFCE6lWUYNgMYMrLEAxFibUNlF5k/QPkck2ezxQCYQzeq8IJ0YCE1d2qnro/EIWjYXafQxaEyfeAZ4GgQ/M3PT/xUbmXh1spRkwz/GD/5OJobYaRaSbYcSkmQ8MYobdxLN+8WgkIBLLhf9/CUzpqoCU6JrfnbreXmSkQSa4pvaYviMl6oHISIK4rLb8F+G5Oicmb+A8mgVPs73Y164tN6yTiposZhCgI3tjux2A/v76QkBYosjiFtkF5xuPTykVU9F5U/aUHRZrdvyFc7lVF3KH3BMrtI48j1G2xWVJNvKPKlpK4JmVw95EM566OZ0VZ4QY+IoHmiPWxyNg39MQ5OYlx2BWGCg3oDO8Hn8B2KIYOuC4NIWOQ3MIO5hCaZLcHy0+g0CEN5QvuMK5uMLWHgos4yUwY/2D0w9AyHiDeHDzAN/ptcJvGnzvQminkVyB/01Vppqd
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(39860400002)(346002)(376002)(451199021)(40470700004)(46966006)(36840700001)(8676002)(8936002)(5660300002)(36860700001)(82310400005)(47076005)(83380400001)(16526019)(186003)(7636003)(26005)(336012)(426003)(86362001)(2616005)(356005)(82740400003)(40460700003)(41300700001)(40480700001)(6666004)(70586007)(70206006)(6916009)(4326008)(316002)(36756003)(478600001)(54906003)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 15:02:17.3662
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9408fc44-6ba7-43b9-b4f9-08db5b9eb355
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1NAM11FT007.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4930
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


Daniel Machon <daniel.machon@microchip.com> writes:

> When doing a replace command, entries are checked against selector and
> protocol. Rewrite requires the check to be against selector and
> priority.
>
> Modify the existing dcb_app_table_remove_replace function for dcb-rewr
> reuse, by using the newly introduced dcbnl attribute in the
> dcb_app_table struct.
>
> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
> ---
>  dcb/dcb_app.c | 26 +++++++++++++++++++-------
>  1 file changed, 19 insertions(+), 7 deletions(-)
>
> diff --git a/dcb/dcb_app.c b/dcb/dcb_app.c
> index 9bb64f32e12e..23d6bb2a0013 100644
> --- a/dcb/dcb_app.c
> +++ b/dcb/dcb_app.c
> @@ -160,15 +160,27 @@ void dcb_app_table_remove_replaced(struct dcb_app_table *a,
>  		for (ib = 0; ib < b->n_apps; ib++) {
>  			const struct dcb_app *ab = &b->apps[ib];
>  
> -			if (aa->selector == ab->selector &&
> -			    aa->protocol == ab->protocol)
> -				present = true;
> -			else
> +			if (aa->selector != ab->selector)
>  				continue;
>  
> -			if (aa->priority == ab->priority) {
> -				found = true;
> -				break;
> +			if (a->attr == DCB_ATTR_IEEE_APP_TABLE) {
> +				if (aa->protocol == ab->protocol)
> +					present = true;
> +				else
> +					continue;
> +				if (aa->priority == ab->priority) {
> +					found = true;
> +					break;
> +				}
> +			} else {
> +				if (aa->priority == ab->priority)
> +					present = true;
> +				else
> +					continue;
> +				if (aa->protocol == ab->protocol) {
> +					found = true;
> +					break;
> +				}
>  			}
>  		}

Same point about the attribute dispatch. How about this? (Not tested
though.)

	static bool dcb_app_pid_eq(const struct dcb_app *aa, const struct dcb_app *ab)
	{
		return aa->selector == ab->selector &&
		       aa->protocol == ab->protocol;
	}

	static bool dcb_app_prio_eq(const struct dcb_app *aa, const struct dcb_app *ab)
	{
		return aa->selector == ab->selector &&
		       aa->priority == ab->priority;
	}

	static void __dcb_app_table_remove_replaced(struct dcb_app_table *a,
						    const struct dcb_app_table *b,
						    bool (*key_eq)(const struct dcb_app *aa,
								const struct dcb_app *ab),
						    bool (*val_eq)(const struct dcb_app *aa,
								const struct dcb_app *ab))
	{
		size_t ia, ja;
		size_t ib;

		for (ia = 0, ja = 0; ia < a->n_apps; ia++) {
			struct dcb_app *aa = &a->apps[ia];
			bool present = false;
			bool found = false;

			for (ib = 0; ib < b->n_apps; ib++) {
				const struct dcb_app *ab = &b->apps[ib];

				if (key_eq(aa, ab))
					present = true;
				else
					continue;

				if (val_eq(aa, ab)) {
					found = true;
					break;
				}
			}

			/* Entries that remain in A will be removed, so keep in the
                         * table only APP entries whose sel/pid is mentioned in B,
			 * but that do not have the full sel/pid/prio match.
			 */
			if (present && !found)
				a->apps[ja++] = *aa;
		}

		a->n_apps = ja;
	}

	void dcb_app_table_remove_replaced(struct dcb_app_table *a,
					const struct dcb_app_table *b)
	{
		__dcb_app_table_remove_replaced(a, b, dcb_app_pid_eq, dcb_app_prio_eq);
	}

	void dcb_rwr_table_remove_replaced(struct dcb_app_table *a,
					const struct dcb_app_table *b)
	{
		__dcb_app_table_remove_replaced(a, b, dcb_app_prio_eq, dcb_app_pid_eq);
	}

Alternatively have key / value extractor callbacks and compare those
instead of directly priority and protocol.

And actually now that I think about it more, a key_eq / get_key callback
is all we need. Instead of val_eq / get_val, we can just compare the
full app. We know the key matches already, so whatever it actually is,
it will not prevent the second match.

Dunno. I just don't want the attribute field become a polymorphic type
tag of the structure. DCB is using these callbacks quite a bit all over
the place, so code like this will be right at home.

I was actually looking at dcb_app_table_remove_existing(), which is
tantalizingly close to being a special case of the above where key_eq
just always returns true and val_eq compares all fields. But alas for
empty tables it would do the wrong thing.

