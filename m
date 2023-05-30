Return-Path: <netdev+bounces-6561-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 61590716EB1
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 22:31:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24B8D28134C
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 20:31:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 567A828C1D;
	Tue, 30 May 2023 20:31:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4460F24E84
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 20:31:50 +0000 (UTC)
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2068.outbound.protection.outlook.com [40.107.96.68])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 024FF118
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 13:31:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kd6FFQ2g41Mv1MsCdkPYaiwmq7KDUk1r+CUGnozueM3ZqPvzqc7i644/ut3yiWjaE/eK5USuO6yS4LXqXFOXXVCz8LWWqj40/MSzTcbkU3HbF48v9CNLO1Z3/bqT2oUlibHt4A3JOA3vA5wE2llB34yZpqzyGd7VGCAw+JzTiAQba11AbTeLpkkRfD9ahTkUFZ7k56Fz/jEqv3WdzIqi0kz5cYVJ/XFPJtZV3Aq33DAEuwbFwG8qynyhUss6iVwOCzPyreHHhEBfJVyEYt3BVQ1as/QqNYNgDrJXtMNMdOqF5B3y5cpTjWhzLu2Qo7CBn5/TE8ANu6oPraIep7i8oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BuhesGuJgqMEFS52IoR+7gSrHpVcjFXhyVh5Od/Q9II=;
 b=UdpPCHgOD6sNLkLWvnIS2lu0HthKrivQ9SFwX2WvZ6xZgV9d6pXOhaiRt5FOMbkvl+NLPVvMRjLL+l45ZbY6pTvLNdnJlBjlh7Twobari5U+tqFnh0kXyzF6GDkgpYPi0jvEebZi/dg9GblZWBqGQdP6oG+S/6UghKEreqDOrBVMUHtV/MhJgvyi7TLdGXHCdjyM77U8OXhc8a+qzgTRECDk67516w5Vn8TrmRB/Ol7ZjtLkpVOnvLy6HBP7KKdzPFc+mL9k0vIb5Z031beGAaNHxhzgfF52KdvCGiyccDYYU49KjloDeXHFvikZZetIIvgXZprf9GdyzlmlJKKBnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=microchip.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BuhesGuJgqMEFS52IoR+7gSrHpVcjFXhyVh5Od/Q9II=;
 b=RGLxMe9S3U8XhWCg/kkfIXqHZsyt2poMfkKRVRr0kNqiLyLsJgYstGtH1ZlqRpNECI3TJeKaK2Qlsys3gCNqCNjGsdvvdj0CLscETkB2XFhfbRw9IaQD19G9IdK3LHPlwM6cbXLNitcTaCUyWbhe5KGGnL50sJx67U0Ey84fDY3uwVf+259+FS0esk7dk/+jWz2k2ZnbiQuzzFggovNvRThOjMpevtNgh649zY5YVPomNv1EupS4n5mgbsqRdnJ1WtK2yd2epgeoCfaKqpm6FI7IbVXW6LRGq03zlTPi9e2uHLPfAZ512dc2t6UJlhiXzVPiSFdlEIy9xBJIpG3YLA==
Received: from DM6PR07CA0116.namprd07.prod.outlook.com (2603:10b6:5:330::13)
 by CY8PR12MB8067.namprd12.prod.outlook.com (2603:10b6:930:74::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 20:31:45 +0000
Received: from DM6NAM11FT077.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:330:cafe::83) by DM6PR07CA0116.outlook.office365.com
 (2603:10b6:5:330::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23 via Frontend
 Transport; Tue, 30 May 2023 20:31:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT077.mail.protection.outlook.com (10.13.173.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.22 via Frontend Transport; Tue, 30 May 2023 20:31:45 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 30 May 2023
 13:31:36 -0700
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 30 May
 2023 13:31:34 -0700
References: <20230510-dcb-rewr-v2-0-9f38e688117e@microchip.com>
 <20230510-dcb-rewr-v2-3-9f38e688117e@microchip.com>
 <87pm6j5ako.fsf@nvidia.com>
User-agent: mu4e 1.6.6; emacs 28.1
From: Petr Machata <petrm@nvidia.com>
To: Petr Machata <petrm@nvidia.com>
CC: Daniel Machon <daniel.machon@microchip.com>, <netdev@vger.kernel.org>,
	<dsahern@kernel.org>, <stephen@networkplumber.org>,
	<UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH iproute2-next v2 3/8] dcb: app: modify
 dcb_app_table_remove_replaced() for dcb-rewr reuse
Date: Tue, 30 May 2023 22:29:20 +0200
In-Reply-To: <87pm6j5ako.fsf@nvidia.com>
Message-ID: <87wn0p4l3w.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT077:EE_|CY8PR12MB8067:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b729c63-a99c-415e-eefc-08db614ce2f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	a2EkoOCFEMq52dEZobqs+3Wq4/6JHH1omICMTPfdY3HXCRHK/FzGkgdDAIznJOK1zH2RjMYJn/O74oh+lLm22AbWOVi1MBmq7HJbQ6CVmNT4Z4y/IlQeK9qjP2KiF2M3yxxNkQbdRnH0dXcUY5Q8AYxTr2my/T4qn8qkYVrZ7d8Mr7c1DN2NqdFyNHumW2+4+XPcSKBwm96caFJUdejw+mObiRlyX0+ximrwYeoZa0JDrlO6W+KatGaMRlZXhw8J374gCZL0VQo/cHC/yMniueGxWewI150C4xPNA8mnBnPIMi7Fk38U1WKxo4JKo7hlkbQhE3N7eXmAJXDT+RnXZsDkWea0++eAyJnffeh1JFzNsUKZx716sgRQgNPyGfXAZzfH2a8PnJgiRuKO850d6xtJJTBgBsPUvyF5cz+i3Hw3zvwBpTrnLrmn3GivwKDNg+4SM58WLVa+hr/n2jXDyLVDvPtphfJj27/FQ2Hr0xMNorl/aNVeNO0UDXemckstW/Sx3rf0G56dxLRsKgb5LNVjTSNDuznik12u7syJYcPRVPtDnKp3N/k0THpeCy11ck9qVungzOmF1ekGMCJnO956wvxHeeFJcL3D5ZGzIj1gUjmKGp4Tw9eJR1ZHiHom06eKJQDWKxdjqNjcdwzi3Wjpwc+gjs5FFt86O81fVJkIdJy/y/+SE3YFAUTn0dVGAQ15EK8fPmp1moJT6AmxuLuIJggcZAVWS0bX3uLGq+rw4X4t6Z5Kn9BF//9Fadeb
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(39860400002)(376002)(346002)(451199021)(46966006)(36840700001)(40470700004)(82310400005)(86362001)(41300700001)(40480700001)(40460700003)(478600001)(4326008)(6666004)(316002)(70206006)(70586007)(36756003)(36860700001)(5660300002)(186003)(16526019)(4744005)(2906002)(426003)(47076005)(336012)(6200100001)(83380400001)(26005)(2616005)(7636003)(6862004)(82740400003)(356005)(37006003)(8676002)(8936002)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 20:31:45.5024
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b729c63-a99c-415e-eefc-08db614ce2f8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT077.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8067
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


Petr Machata <petrm@nvidia.com> writes:

> Daniel Machon <daniel.machon@microchip.com> writes:
>
>> diff --git a/dcb/dcb.h b/dcb/dcb.h
>> index d40664f29dad..84ce95d5c1b2 100644
>> --- a/dcb/dcb.h
>> +++ b/dcb/dcb.h
>> @@ -56,11 +56,25 @@ void dcb_print_array_kw(const __u8 *array, size_t array_size,
>>  
>>  /* dcb_app.c */
>>  
>> +struct dcb_app_table {
>> +	struct dcb_app *apps;
>> +	size_t n_apps;
>> +	int attr;
>> +};
>> +
>>  int dcb_cmd_app(struct dcb *dcb, int argc, char **argv);
>>  enum ieee_attrs_app dcb_app_attr_type_get(__u8 selector);
>>  bool dcb_app_attr_type_validate(enum ieee_attrs_app type);
>>  bool dcb_app_selector_validate(enum ieee_attrs_app type, __u8 selector);
>>  
>> +bool dcb_app_pid_eq(const struct dcb_app *aa, const struct dcb_app *ab);

And I suspect this one does not need to be public at all?

>> +bool dcb_app_prio_eq(const struct dcb_app *aa, const struct dcb_app *ab);
>
> This function isn't necessary until 5/8, that's when it should be added.

