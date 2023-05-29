Return-Path: <netdev+bounces-6158-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4000E714EC5
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 19:09:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF83F280F2A
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 17:09:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B21EC2D4;
	Mon, 29 May 2023 17:09:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78FD3C2D2
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 17:09:31 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2063.outbound.protection.outlook.com [40.107.243.63])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27E7CB5
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 10:09:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bUNfOTXNEfzjAiTC0kVRn29IvBzozqWvlKSeGGM/yBSiLGa/dl+Zvj4dGRFe/0ZCcejFtmDoPmsnuF+y9jdev35cIM849NrcjLliSp5QRslKc54n7TRbSBifCqLdiWmP/atV50nd44UT6JXnDkYYfCZTaEamjYl8gT4a/cToA9dpbgHGVYv8b+NMYa5gJ3Gy54ivUss0SYXLE5ufOsOQ7M8Qae8bYR83S8M/M5u747zTEStngOwyaaJL6tvghIlqMlsSo9D3HLKMQNBFuaJjQ0TDLaRZPe61DLDu1T9MEN5cMxtHjsssm73s/lX46agkSu5dtvNMaVTpXOrrApYoow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9XxD+rZDmCVGp7ejCkgIr2a94P07d7/UbGEBrRIjK3c=;
 b=AA/qdDTVrx46TM6eSfLqaww/wROY6LEtrPgqZbV4JRgNTheVrEAjSDwp1qfUPCCUdMZ0WwRQ+BXmosL4+GjIgOGnrHP9OXQa8C3MkTZe0dfchBe1eMQ1gjnMPxqzfQ2BPDz69nO4ZGObnxSX29aziBg9OZ4UgpRx4UOY1se9OsVbVrtUlJhypqMaoVtPC5GaTB+ovRfkVCM5fMcEZi5NcEHNZYEsRUG+lBUxwm3Db3oXIsDnHT8uPCgivEw/S6cxJwhTj8L8A8BrBC+533Eky7hPYWwbB5OC8Rn1eSOFvOll6v6cvbHxIxrz7NUuQ0fqpSWJ80D6ChhWZ8MRVxk3fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=microchip.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9XxD+rZDmCVGp7ejCkgIr2a94P07d7/UbGEBrRIjK3c=;
 b=CvZ4brbad9jP5cKKj5sFKWJvRBGdQbjX16pgVcrtEpHlsQdu4uHXPtiysFCUqxo8dvg22cVm1GhimfaARbmoAWVo8YgPcEu+Fps0djqnmj+DERXCX0vS7++ojKTqrmS9xv5cf6uKCwS9MrsF3SYERWjvZMdw3TH7sHBwsCb4o8/tgkX4a+Lj8AXMSTSU4PNdWJj34qQ9qaTmUe4Nm7hW6SYuyOEi89bq0VgbeEINxBDAkX6gUxn3MzoFS3YpUgd1qNXxjzAfqv+j9iSZrFgzUES9O5uxaZg0xJrc3ZC37RiUZln5xr8mg9EBzD8fPyiAA/d+Q8ZVQOHlH/SwBorXow==
Received: from CY5PR18CA0056.namprd18.prod.outlook.com (2603:10b6:930:13::23)
 by CH2PR12MB4230.namprd12.prod.outlook.com (2603:10b6:610:aa::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Mon, 29 May
 2023 17:09:27 +0000
Received: from CY4PEPF0000E9D4.namprd03.prod.outlook.com
 (2603:10b6:930:13:cafe::3) by CY5PR18CA0056.outlook.office365.com
 (2603:10b6:930:13::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23 via Frontend
 Transport; Mon, 29 May 2023 17:09:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000E9D4.mail.protection.outlook.com (10.167.241.147) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.18 via Frontend Transport; Mon, 29 May 2023 17:09:27 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 29 May 2023
 10:09:16 -0700
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 29 May
 2023 10:09:14 -0700
References: <20230510-dcb-rewr-v2-0-9f38e688117e@microchip.com>
 <20230510-dcb-rewr-v2-3-9f38e688117e@microchip.com>
User-agent: mu4e 1.6.6; emacs 28.1
From: Petr Machata <petrm@nvidia.com>
To: Daniel Machon <daniel.machon@microchip.com>
CC: <netdev@vger.kernel.org>, <dsahern@kernel.org>,
	<stephen@networkplumber.org>, <petrm@nvidia.com>,
	<UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH iproute2-next v2 3/8] dcb: app: modify
 dcb_app_table_remove_replaced() for dcb-rewr reuse
Date: Mon, 29 May 2023 19:00:14 +0200
In-Reply-To: <20230510-dcb-rewr-v2-3-9f38e688117e@microchip.com>
Message-ID: <87pm6j5ako.fsf@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D4:EE_|CH2PR12MB4230:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e2bd559-9f31-42d5-3707-08db606775b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	fcozae8x5PRVwMYl/SvmSuujVln5bw/MVT6J5Gi+HTF3kLoBgSmhvY+8n0IEHPSnioUIhTgkO31ouBGemkzBVukyima4AaK44l0/qhDHkC5xlCS3W0dVjHLnVKBFOJITDWKPo71qKmuoPNiEJYY81Xqp+dNFd+PnxgXaChTR8U7RodyTdPPu6y/pe0oY6LkWf4Unvp/PB/pB2qJ51Vr1cmBVcQTLDrcoV7XQV1MW6f5HOVVL74/17qmiAG3Y97XqBnv09qYFhjXNsUsqu54Sd2Ei7wghzyJ63Gm8Uv5wqXPD4n/iyqX1rGu11lTSl0EDcm/HxsWq7MB2qBXfVjsp7HMTLU6qiVAeT9gRe/7yjrd+nEazs0fbNfZILlLoMlonpuk2lSDRWK9QwIHpgwBEa2/JvSF7iTjABLzOd9/WTrDN8bHwPImj3BCs6GbIlGdztKhC/uiVLInk8jWAtf81LQaSVYLYQdKn6uL517wJK9UBDk+AQT0Vggai6B5W6XI34EzrdT7HozjafUqSHG/PqsfH8vB6WI/80p1eaMceafT8NMuBeriuBx69IJVIg9K1+3za8DNw5iRFotAIDKcLCFuxzlUHVtiCBlJNnMBtHeX3DlHrJ5QlmiuO6QhDQXHTc5iyHepM7h+WcGYOODA9KAAKNizgmSTqQUp+mUa10XnAjwgyAKbAVq6UslufYBZseUm46RSJ1LewJpzwzwTgmomnTWuVQlB52GXFFC4RM5gKrFjPxAWd1VV+F6EUCXu5
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(136003)(396003)(376002)(451199021)(36840700001)(40470700004)(46966006)(478600001)(82310400005)(86362001)(41300700001)(40480700001)(40460700003)(6916009)(4326008)(316002)(36756003)(70206006)(70586007)(36860700001)(5660300002)(16526019)(186003)(2906002)(26005)(2616005)(83380400001)(47076005)(426003)(336012)(8676002)(54906003)(8936002)(82740400003)(356005)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2023 17:09:27.4868
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e2bd559-9f31-42d5-3707-08db606775b8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4230
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


Daniel Machon <daniel.machon@microchip.com> writes:

> When doing a replace command, entries are checked against selector and
> protocol. Rewrite requires the check to be against selector and
> priority.
>
> Adapt the existing dcb_app_table_remove_replace function for this, by
> using callback functions for selector, pid and prio checks.
>
> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
> ---
>  dcb/dcb.h     | 14 ++++++++++++++
>  dcb/dcb_app.c | 32 ++++++++++++++++++++------------
>  2 files changed, 34 insertions(+), 12 deletions(-)
>
> diff --git a/dcb/dcb.h b/dcb/dcb.h
> index d40664f29dad..84ce95d5c1b2 100644
> --- a/dcb/dcb.h
> +++ b/dcb/dcb.h
> @@ -56,11 +56,25 @@ void dcb_print_array_kw(const __u8 *array, size_t array_size,
>  
>  /* dcb_app.c */
>  
> +struct dcb_app_table {
> +	struct dcb_app *apps;
> +	size_t n_apps;
> +	int attr;
> +};
> +
>  int dcb_cmd_app(struct dcb *dcb, int argc, char **argv);
>  enum ieee_attrs_app dcb_app_attr_type_get(__u8 selector);
>  bool dcb_app_attr_type_validate(enum ieee_attrs_app type);
>  bool dcb_app_selector_validate(enum ieee_attrs_app type, __u8 selector);
>  
> +bool dcb_app_pid_eq(const struct dcb_app *aa, const struct dcb_app *ab);
> +bool dcb_app_prio_eq(const struct dcb_app *aa, const struct dcb_app *ab);

This function isn't necessary until 5/8, that's when it should be added.

> +
> +void dcb_app_table_remove_replaced(struct dcb_app_table *a,
> +				   const struct dcb_app_table *b,
> +				   bool (*key_eq)(const struct dcb_app *aa,
> +						  const struct dcb_app *ab));
> +

This is conflating publication with prototype change. It would be best
to separate. I think the publication could be done at the point when you
actually need the function, i.e. 5/8 as well. I would keep here just the
prototype change.

>  /* dcb_apptrust.c */
>  
>  int dcb_cmd_apptrust(struct dcb *dcb, int argc, char **argv);
> diff --git a/dcb/dcb_app.c b/dcb/dcb_app.c
> index 1e36541bec61..4cd175a0623b 100644
> --- a/dcb/dcb_app.c
> +++ b/dcb/dcb_app.c
> @@ -68,12 +68,6 @@ static void dcb_app_help(void)
>  	dcb_app_help_add();
>  }
>  
> -struct dcb_app_table {
> -	struct dcb_app *apps;
> -	size_t n_apps;
> -	int attr;
> -};
> -
>  enum ieee_attrs_app dcb_app_attr_type_get(__u8 selector)
>  {
>  	switch (selector) {
> @@ -153,8 +147,22 @@ static void dcb_app_table_remove_existing(struct dcb_app_table *a,
>  	a->n_apps = ja;
>  }
>  
> -static void dcb_app_table_remove_replaced(struct dcb_app_table *a,
> -					  const struct dcb_app_table *b)
> +bool dcb_app_pid_eq(const struct dcb_app *aa, const struct dcb_app *ab)
> +{
> +	return aa->selector == ab->selector &&
> +	       aa->protocol == ab->protocol;
> +}
> +
> +bool dcb_app_prio_eq(const struct dcb_app *aa, const struct dcb_app *ab)
> +{
> +	return aa->selector == ab->selector &&
> +	       aa->priority == ab->priority;
> +}
> +
> +void dcb_app_table_remove_replaced(struct dcb_app_table *a,
> +				   const struct dcb_app_table *b,
> +				   bool (*key_eq)(const struct dcb_app *aa,
> +						  const struct dcb_app *ab))
>  {
>  	size_t ia, ja;
>  	size_t ib;
> @@ -167,13 +175,13 @@ static void dcb_app_table_remove_replaced(struct dcb_app_table *a,
>  		for (ib = 0; ib < b->n_apps; ib++) {
>  			const struct dcb_app *ab = &b->apps[ib];
>  
> -			if (aa->selector == ab->selector &&
> -			    aa->protocol == ab->protocol)
> +			if (key_eq(aa, ab))
>  				present = true;
>  			else
>  				continue;
>  
> -			if (aa->priority == ab->priority) {
> +			if (aa->protocol == ab->protocol &&
> +			    aa->priority == ab->priority) {
>  				found = true;
>  				break;
>  			}
> @@ -891,7 +899,7 @@ static int dcb_cmd_app_replace(struct dcb *dcb, const char *dev, int argc, char
>  	}
>  
>  	/* Remove the obsolete entries. */
> -	dcb_app_table_remove_replaced(&orig, &tab);
> +	dcb_app_table_remove_replaced(&orig, &tab, dcb_app_pid_eq);
>  	ret = dcb_app_add_del(dcb, dev, DCB_CMD_IEEE_DEL, &orig, NULL);
>  	if (ret != 0) {
>  		fprintf(stderr, "Could not remove replaced APP entries\n");


