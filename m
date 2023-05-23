Return-Path: <netdev+bounces-4693-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ACAE070DF0C
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 16:19:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3729C1C20D35
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 14:18:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 247531F17C;
	Tue, 23 May 2023 14:18:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF671E50F
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 14:18:59 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on20614.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::614])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84BC6E9
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 07:18:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z9Kmk8xGo3frSzSy3bc+gzkuZ2tEw4OC5tepsA6favzp3OE3SOB/c7SXrUmyC0GxfAGu1DN1SXzvIxC16RgL0ch69bxROdeNDyJnp2qPgeooCjfQMpOoC9seKSVrNTKmVwEb1rtQL+/yeMxkWpdc0xwUYujkpalOM6B+ovB9vb3k/juEPYY/XCbYl0ExuUm3Ss19fZ6pX5mNwKIl9Kyw9nGMiB5s0Z+wKarZ0RY5HwGgDDNYpBmInmWoeuJvgXZ8QPT5IJ+GJKAfYZFz8OCY+yHMLNWF0FSuAVONZ0aErOvqAy+G1zQAhMZ4562n8+E+urqicIWQSpodL6A9XVqjyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pF3S1O0g5R/3DDD/3iekDoUR4JukrWsFYep6ZWB0icU=;
 b=WQd9Mt0n+6qIwsdueE2ulnF8WFwHf7grEu1OXPMEtPNrETYVP9cCvWalYYw10yp6/CwLN1qXFnWABF/aPruY/4VLd8fk7nhx16ySJRRDEhh8GTAx17HtMghtM+xfhcFVjjOztMKtwVtutjaJ9OzZnnrES4jStUDWqRHvYaM+DBtjaG178b2L26ZF2HRt8piYLw+ENkxLu3Zs3/oQWmCso3nQbg4SQrjxc2NWwDurtQkxZW+b4/Siortp9NDkGkIq+3gvG6Cp17923d7cVdXP0OJRs2rybhOSOEGeGtLwZlfZUxsui6sBo0hEwYETt31DGzfs4oFKV4aBoCu4NXOFqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=microchip.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pF3S1O0g5R/3DDD/3iekDoUR4JukrWsFYep6ZWB0icU=;
 b=p+UFKA71z4jYLE5KL9nl4pOeoWmCduz90esL3QFyayfMSJfEGV/HWmlw6m7y2ZCeP8tjt+2AqgGJFNVQgZMdAGdxQFF/AJ+8mn9aeaiXi1BgYhVVufnmzBjoEv4QeZUKBimt2WFqWp07ONmSt8s8yqGOPrzda4pihVWnr+XG1rlksNJRrVuY+p2wYyKT4YWiriWOYm5GeR/uez/OevomG3a9M3DGTTQDkyy42UEuynaw9HgCG8WXvrOyBITuVBT0kAhfednuEGSzYV47mg9WMigjFlnoH5JPOFBxlv7xioCQZWLMQiC4b7rnDeGZOu6OHQHEz17d6rG0L59aa1XedA==
Received: from DM6PR02CA0156.namprd02.prod.outlook.com (2603:10b6:5:332::23)
 by PH7PR12MB7187.namprd12.prod.outlook.com (2603:10b6:510:203::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Tue, 23 May
 2023 14:18:54 +0000
Received: from DM6NAM11FT072.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:332:cafe::f) by DM6PR02CA0156.outlook.office365.com
 (2603:10b6:5:332::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.14 via Frontend
 Transport; Tue, 23 May 2023 14:18:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT072.mail.protection.outlook.com (10.13.173.181) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.29 via Frontend Transport; Tue, 23 May 2023 14:18:54 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 23 May 2023
 07:18:46 -0700
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 23 May
 2023 07:18:44 -0700
References: <20230510-dcb-rewr-v1-0-83adc1f93356@microchip.com>
 <20230510-dcb-rewr-v1-3-83adc1f93356@microchip.com>
User-agent: mu4e 1.6.6; emacs 28.1
From: Petr Machata <petrm@nvidia.com>
To: Daniel Machon <daniel.machon@microchip.com>
CC: <netdev@vger.kernel.org>, <dsahern@kernel.org>,
	<stephen@networkplumber.org>, <petrm@nvidia.com>,
	<UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH iproute2-next 3/9] dcb: app: modify dcb-app print
 functions for dcb-rewr reuse
Date: Tue, 23 May 2023 15:23:46 +0200
In-Reply-To: <20230510-dcb-rewr-v1-3-83adc1f93356@microchip.com>
Message-ID: <87h6s35dx9.fsf@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT072:EE_|PH7PR12MB7187:EE_
X-MS-Office365-Filtering-Correlation-Id: 430ab0aa-b05a-4dd8-a516-08db5b98a3dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	iNy8zN+05D07YPplbwpQZ454jYUyM0lq6dEnTZXRAFdTVtzZGuYlhhcWKFRUCd0QagISddF0wJdrIukNe4dK2Xj0FvVKSGhOENztI49mEScl0lOWhmPdkUdgRFi6as2fEm6cHt4RuQOQzL7WDYvU4k74d73/2Eg7j0YmgniuGiV7mm+XXJbgDJxJDibF4b0xQdKs3Bjkjwgly6Z6ld+mz2+64f8Jny1MGGMj+i+GOrbb7nyzDsb/U1IPBrZI/k5VYluyuIB/y6CegvTCkdg+hXpfCeZJlSER25SAfC6X+Fx9Gl+ntdhJF3F3hsBHOSAG4uDaIBB02XKHHEgUKnxTb8cMtnPYBlLN8bnbrjeZWMv0TAdKHP3zTZDETPsr4JRqq/W/5Oexyb9j7AkivYYzpBMnuOTMm4q/wzxBl2vifXweYLYNwOadhvwnxNbCoeMOaREQ4i+n/UsKz0eJKTHbajKB46fkY2C0ZrVFnlq3DEYazX/vW++Zj5EzrtbC5tRktgbEWHNuJeRP3FHYkfYKGZODO2a5+C4RUxaYCJ+BwgP7ZFoAws7qzGbNlLyE9N5cvpoZvRoxb9SCX+tCxqVAKqU60vqthIcwnpG63to5vNThJv8vNL4uauFTykbZAGNIw8DMg1xZSFak4I1AR2yWxESKnjkQXGeulsLTmAqH6HDZ7wJGIB+LVBrS3aT8qLRHyOdyGnChb/3qD+SUPXjw85vbf8QZdRfZ5GF6WiDvc3BBJKi6YYwN4N8r/csNBuI9
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(396003)(376002)(39860400002)(451199021)(46966006)(36840700001)(40470700004)(40460700003)(36860700001)(16526019)(8676002)(8936002)(66899021)(83380400001)(82740400003)(82310400005)(86362001)(36756003)(7636003)(356005)(2616005)(426003)(336012)(47076005)(40480700001)(2906002)(41300700001)(70586007)(70206006)(6916009)(316002)(4326008)(5660300002)(54906003)(26005)(186003)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 14:18:54.4019
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 430ab0aa-b05a-4dd8-a516-08db5b98a3dd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT072.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7187
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


Daniel Machon <daniel.machon@microchip.com> writes:

> -static void dcb_app_print_filtered(const struct dcb_app_table *tab,
> -				   bool (*filter)(const struct dcb_app *),
> -				   int (*print_key)(__u16 protocol),
> -				   const char *json_name,
> -				   const char *fp_name)
> +void dcb_app_print_filtered(const struct dcb_app_table *tab,
> +			    bool (*filter)(const struct dcb_app *),
> +			    int (*print_pid)(__u16 protocol),
> +			    const char *json_name, const char *fp_name)
>  {
>  	bool first = true;
>  	size_t i;
> @@ -439,8 +437,14 @@ static void dcb_app_print_filtered(const struct dcb_app_table *tab,
>  		}
>  
>  		open_json_array(PRINT_JSON, NULL);
> -		print_key(app->protocol);
> -		print_uint(PRINT_ANY, NULL, "%d ", app->priority);
> +		if (tab->attr == DCB_ATTR_IEEE_APP_TABLE) {
> +			print_pid(app->protocol);
> +			print_uint(PRINT_ANY, NULL, ":%d", app->priority);
> +		} else {
> +			print_uint(PRINT_ANY, NULL, "%d:", app->priority);
> +			print_pid(app->protocol);
> +		}

I really dislike the attribute dispatch. I feels too much like mixing
abstraction layers. I think the callback should take a full struct
dcb_app pointer and format it as appropriate. Then you can model the
rewrite table differently from the app table by providing a callback
that invokes the print_ helpers in the correct order.

The app->protocol field as such is not really necessary IMHO, because
the function that invokes the helpers understands what kind of table it
is dealing with and could provide it as a parameter. But OK, I guess it
makes sense and probably saves some boilerplate parameterization.

> +		print_string(PRINT_ANY, NULL, "%s", " ");
>  		close_json_array(PRINT_JSON, NULL);
>  	}
>  

