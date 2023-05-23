Return-Path: <netdev+bounces-4755-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B6ED270E1D8
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 18:35:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BFAC2281470
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 16:35:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B8901F18C;
	Tue, 23 May 2023 16:35:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C57EA1
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 16:35:31 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C20AFE7C
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 09:35:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XWXUUe3LrMlWNVGEFBrS8bj3jN4j0k2WD3ZFK7J2KkutE0BPRcX45enhxfy7iioHLHA3Be9SJKwbPHYmmaH4OPMEzmgKoQP8y/oqZiPU9YUx8z9GTSlErpa9T8lg0Ioz9mK7fRWFVAdmgHtAi6crN0TgPrL5lUmzTa5yNN1Czhci0Mnu7hTwo7QA3s55TX/5x8eecQGf9T3qzh2jRk92bUVhHksFDS334Hs4lKmvZC6ZrfjXICiW2PGTU7g/puvAY5JjavmKC6iXh+vyVrQcMB+mE+8QUp4/f/Fm1sADYfR51W7gNJiSBigsYoyZryyyeeyAM1/2gYCPwhdtflI0Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DbHn39X+vsJSrjNQ/n21jA6M7JQTajmjTpiLItbBAR4=;
 b=Pc9fJ6cOexWQ4JNQ1rczf8OmRHr8xOkyq2CpTlDr0u3S2d30F8zBKsX0ZOXLKeeq4yh5wklF/jfFoF562CGyPonLG8SSnFp5L5shARWZXqzNG1WH50Y0csgOCE2x7+D+1WKR9i/+zGc1guXVbMn1MxF3yh48sOo+MENq5adfU+WjnQxGlucIFv16oL6XQeRzil2420qS8oWz1L8HvpFmUi0c1HY9UDr7w5os4l/RROpESJnmuVnjzOmBnHeSC8GEE/80mHGEpfMdbsKaSrG49HShKcRBuCtshxBFREjwGumaY5cH+RQPLuMJePdkwkkTy7PvJ0SgsKTms+vRaHwzyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=microchip.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DbHn39X+vsJSrjNQ/n21jA6M7JQTajmjTpiLItbBAR4=;
 b=THvzZiOhadKGuaXcFucslSFCr+7W5igVDTJnlXr67/+YVkUoqgpO1xGGnFc8AlQ2j5kg6eA0ymYMP0oSTBwtKyXnT191n+f45VGykRmyXLhYVg9rRRkhaiDcU5lwawTAzzq46B+Jlds7pyLYHvwrjets+uS8wWiN8M2JQVCfzIdfpA3cO7PkF8SWavfrb77xbMfNMU86CDi5XgrW8GxCS7nV7e1aCaJzeM/K1VmZlR6R0uNEGf378rfqenohADYrLV0dbydw8CoXLZQbPlomuGJ4Kt/BEAt4jk/wYucQPh8BThp2MGe4RML98fZEUW6+VxHmMHjP/eKtstj0DknG0w==
Received: from MW2PR2101CA0036.namprd21.prod.outlook.com (2603:10b6:302:1::49)
 by IA1PR12MB6284.namprd12.prod.outlook.com (2603:10b6:208:3e4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Tue, 23 May
 2023 16:35:06 +0000
Received: from CO1NAM11FT116.eop-nam11.prod.protection.outlook.com
 (2603:10b6:302:1:cafe::63) by MW2PR2101CA0036.outlook.office365.com
 (2603:10b6:302:1::49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.6 via Frontend
 Transport; Tue, 23 May 2023 16:35:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT116.mail.protection.outlook.com (10.13.174.243) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.30 via Frontend Transport; Tue, 23 May 2023 16:35:06 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 23 May 2023
 09:34:58 -0700
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 23 May
 2023 09:34:56 -0700
References: <20230510-dcb-rewr-v1-0-83adc1f93356@microchip.com>
 <20230510-dcb-rewr-v1-5-83adc1f93356@microchip.com>
User-agent: mu4e 1.6.6; emacs 28.1
From: Petr Machata <petrm@nvidia.com>
To: Daniel Machon <daniel.machon@microchip.com>
CC: <netdev@vger.kernel.org>, <dsahern@kernel.org>,
	<stephen@networkplumber.org>, <petrm@nvidia.com>,
	<UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH iproute2-next 5/9] dcb: app: modify
 dcb_app_parse_mapping_cb for dcb-rewr reuse
Date: Tue, 23 May 2023 18:29:28 +0200
In-Reply-To: <20230510-dcb-rewr-v1-5-83adc1f93356@microchip.com>
Message-ID: <878rdf57m9.fsf@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT116:EE_|IA1PR12MB6284:EE_
X-MS-Office365-Filtering-Correlation-Id: 61edd56b-b194-4531-bf89-08db5babaaa5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	2a0I0UQoONTNIi1Si6P3mpb/DQSRWcj8CnMONRlaBjfirSiHTLq3yEBur1gZZ3ldxrMf+60x5DVqokjq5+YnuSehiNRRXE2kTYJXXe9xNrMHKoH8Wiseq8DxrEhQrg9R9B7FRJpKzilNiE72b/jdCuVA+PPiSzg7Jn9RVaX4WDSe8Xd2epzwShLmD8FaKM59ZmEJHPhzR3aLSjsCtOzPHrui7dGpBzIdCfqq4t2x1gnGdX1Wj1tTZ1gJih09WALiY82FuADwUfqoG3jxX8mgy41Z0fGfIoGj5pYpbSTaEEv2xAl41UqSKHLkMJX3A5Ak+vpkqamh83AVChh0hyUddI0vWurO+1RzI3GLUrthIlMQ6HUpDy4rH0yYNBiQkCj4i+Z9uPShnghokBIeryVymH1h5myvzIXqSERjU9qMqzAYIvDJeXvt2OO16K8z1roSrj2VjaIF0BdkZ4J1xPoY4VaJe+TlPhLaWcGp1mM6JyNBTzW4/YZvLK6z9fb8r+uRvOps1ItVXSzxfLdZ380YpPpb9zR3o5Wz4jcpQU06vPcnFtuHVKl8oP7hRUccxBlkmqHQv/ShXieybJckqRLYtyo48s+xSo+92Iwr6n7yiH2TFNgTFCXTQjHBigGbR4QOz8p0D8qZI9tB1mrHpee89ETY+XtuyJJZ7WMGD6UzVPm4gh75+tZAwgfbgW7rEutgWwxx4Ble+VxckefLZ/m22F4cpC77tgiZ05qEaY7fAy71/v9VdUgc4cU+AT8Tm4wB
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(376002)(396003)(346002)(451199021)(40470700004)(46966006)(36840700001)(8676002)(8936002)(5660300002)(83380400001)(47076005)(186003)(36860700001)(16526019)(356005)(26005)(2616005)(336012)(426003)(86362001)(82740400003)(7636003)(40460700003)(70586007)(82310400005)(6666004)(41300700001)(40480700001)(478600001)(4326008)(6916009)(36756003)(70206006)(54906003)(316002)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 16:35:06.2644
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 61edd56b-b194-4531-bf89-08db5babaaa5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1NAM11FT116.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6284
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
> Modify the existing dcb_app_parse_mapping_cb for dcb-rewr reuse, by
> using the newly introduced dcbnl attribute in the dcb_app_table struct.
>
> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
> ---
>  dcb/dcb_app.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/dcb/dcb_app.c b/dcb/dcb_app.c
> index 23d6bb2a0013..46af67112748 100644
> --- a/dcb/dcb_app.c
> +++ b/dcb/dcb_app.c
> @@ -232,10 +232,17 @@ void dcb_app_parse_mapping_cb(__u32 key, __u64 value, void *data)
>  	struct dcb_app_parse_mapping *pm = data;
>  	struct dcb_app app = {
>  		.selector = pm->selector,
> -		.priority = value,
> -		.protocol = key,
>  	};
>  
> +	if (pm->tab->attr == DCB_ATTR_IEEE_APP_TABLE) {
> +		app.priority = value;
> +		app.protocol = key;
> +
> +	} else {
> +		app.priority = key;
> +		app.protocol = value;
> +	}
> +
>  	if (pm->err)
>  		return;

? (Or thereabouts... again, not tested.)

modified   dcb/dcb_app.c
@@ -225,22 +225,40 @@ static void dcb_app_table_sort(struct dcb_app_table *tab)
 struct dcb_app_parse_mapping {
 	__u8 selector;
 	struct dcb_app_table *tab;
+	int (*push)(struct dcb_app_table *tab,
+		    __u8 selector, __u32 key, __u64 value);
 	int err;
 };
 
-static void dcb_app_parse_mapping_cb(__u32 key, __u64 value, void *data)
+static int dcb_app_push_app(struct dcb_app_table *tab,
+			    __u8 selector, __u32 key, __u64 value)
 {
-	struct dcb_app_parse_mapping *pm = data;
 	struct dcb_app app = {
-		.selector = pm->selector,
+		.selector = selector,
 		.priority = value,
 		.protocol = key,
 	};
+	return dcb_app_table_push(tab, &app);
+}
+
+static int dcb_app_push_rewr(struct dcb_app_table *tab,
+			     __u8 selector, __u32 key, __u64 value)
+{
+	struct dcb_app app = {
+		.selector = selector,
+		.priority = key,
+		.protocol = value,
+	};
+	return dcb_app_table_push(tab, &app);
+}
+
+static void dcb_app_parse_mapping_cb(__u32 key, __u64 value, void *data)
+{
+	struct dcb_app_parse_mapping *pm = data;
 
 	if (pm->err)
 		return;
-
-	pm->err = dcb_app_table_push(pm->tab, &app);
+	pm->err = pm->push(pm->tab, pm->selector, key, value);
 }
 
 static int dcb_app_parse_mapping_ethtype_prio(__u32 key, char *value, void *data)
@@ -640,6 +658,7 @@ static int dcb_cmd_app_parse_add_del(struct dcb *dcb, const char *dev,
 {
 	struct dcb_app_parse_mapping pm = {
 		.tab = tab,
+		.push = dcb_app_push_app,
 	};
 	int ret;

