Return-Path: <netdev+bounces-6777-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B4D4717E2B
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 13:38:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 33BE028148C
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 11:38:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D2DF13AEE;
	Wed, 31 May 2023 11:38:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47DDBE64
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 11:38:03 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2088.outbound.protection.outlook.com [40.107.93.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21B47E8
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 04:38:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bu4m6576sObcGUHGCielc0ylaqKdjWSYbXSIQitJqmqEc3tqEg/C0V+r5ZXqqa0oYWk7DCWujCvGVIFxbBtuLm4J2GonUJh75AXGY4MOYnyfVvepp7Ty6NrkjatKGuIY4rf+jIstdrmDJc2nZP8tR+gkWt6n0y17+0Iv2xVjaJY3p5gsuEBExUd24F5hQYF7AW3fotGteCP5eLtxg+Sg++5tM+AAKsqefVbPPUxmb2wufxrXoeYsREt8ljJkO0tMM9UPsP8//JsGAl/75s+A7cHlv7CLxDSA1WgCb2c3LuBI5UownHRVQN6QtLD0ijGlmloiSo2VICE//++B3OZzeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6gT5ggbXP9OE3o/k1VUmLtxS4/ayqWoB1gblTl3Vjeg=;
 b=art+x5kF9YVoCYxL+DXrsI9N45OOmSsdfbYRfO32EGr2m1fGPi8oQGVTuSOgJ30ArR6dcwCpPoQzY+XR6LKffcaPc+c3aWqCFJaXHn9g5XsD6NfJCVkUoze1a2fA5Hot7bp8Vh3hAZbHbg+zZgJCaZaq8FpWMNm9MLasdMfi9vDb6etS128MbO4uw4nSIE5kWWYJXf39jzY4eQx/M723hZ61bTKWpwC3oDBHCsWv6t6tCpg7PzIS+G9eNo4pKWJ+eZA1swUswtiCIohG5qIn7palmnJpxa5SUFBof35+LsO/rF1ejx0SklD+VZN8JPfg3eI3JbNuzpzMBhgu0BNwkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=microchip.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6gT5ggbXP9OE3o/k1VUmLtxS4/ayqWoB1gblTl3Vjeg=;
 b=GF99f9C1bWVBGQhD3gZ/tEF5b7OSuy66Ld2sl7oJxGY3CtLFec7s4fnufVfei5noeUJa8D7qy1nwxXGK/ql8QCrLg96mVDz6Ef7peqh6SU5fA9wwZdcJVoUnTo6dQB2EiOFBjRtuxET5eUgaJBTfloeUt1Q08RrSiLW6FgaaEUNKEV7+NKYgEqiagXuaNaofAxVOXYr7FupykrOUSeSZyo9iN6MQJCoVHcSWpXwSEynVUl5iUpH0yD5neKrozxApQXdzfSSfnrYlPaN+wNRlbwcZZoVTYNRGgYZkGNZYVw09ciTr/4OrOTdVRNGwYtV+Rle3M9kh7cGxV+xehSFzpg==
Received: from BN0PR02CA0041.namprd02.prod.outlook.com (2603:10b6:408:e5::16)
 by DM4PR12MB6086.namprd12.prod.outlook.com (2603:10b6:8:b2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Wed, 31 May
 2023 11:38:00 +0000
Received: from BN8NAM11FT111.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e5:cafe::1a) by BN0PR02CA0041.outlook.office365.com
 (2603:10b6:408:e5::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22 via Frontend
 Transport; Wed, 31 May 2023 11:38:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT111.mail.protection.outlook.com (10.13.177.54) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.23 via Frontend Transport; Wed, 31 May 2023 11:37:59 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 31 May 2023
 04:37:42 -0700
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Wed, 31 May
 2023 04:37:40 -0700
References: <20230510-dcb-rewr-v2-0-9f38e688117e@microchip.com>
 <20230510-dcb-rewr-v2-2-9f38e688117e@microchip.com>
 <87leh75aek.fsf@nvidia.com> <20230531083141.ijtwsfxa3javczdf@DEN-LT-70577>
User-agent: mu4e 1.6.6; emacs 28.1
From: Petr Machata <petrm@nvidia.com>
To: Daniel Machon <daniel.machon@microchip.com>
CC: Petr Machata <petrm@nvidia.com>, <netdev@vger.kernel.org>,
	<dsahern@kernel.org>, <stephen@networkplumber.org>,
	<UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH iproute2-next v2 2/8] dcb: app: modify dcb-app print
 functions for dcb-rewr reuse
Date: Wed, 31 May 2023 13:26:06 +0200
In-Reply-To: <20230531083141.ijtwsfxa3javczdf@DEN-LT-70577>
Message-ID: <87o7m04tq5.fsf@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT111:EE_|DM4PR12MB6086:EE_
X-MS-Office365-Filtering-Correlation-Id: 396a62e2-1e36-43d9-ca7e-08db61cb7cab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	BO4xMxj0kxqDFh5pj01jaSGj0DwWrqth2kJFnS4x3OcBksSLLNQWBqk3ubloIVtnc3jwrzGJFcCJVwgzV47ymcNxiM4tVQA8EJW9kKyoOIXq2hhqLUEgyNKXayNxO33Ui8RNDzTiJaS0FgOgvAm+ZTkLMqfjNOj1mDfALejBUkQBuVHklpYGVmoCBiMdDWKh3DuZ7mTtZuesDYKvdUFnZQC/55TUMIknVI1Bja2a8upT3iQUrAb28lD3kFObyiOm+NZpNGEE8nqgzeH+NetGLITgei99ENOSRf9OWvZOKOLYJGN/X/9NXGpe1TZHWKgYswmujVE7jHlP6sgCq4zlwKjTiwpWbvniXmoZZuoFUmSK2Ubhtb4iOR4liS2zygfBZF6Pd/AM4WoiSwAEZRzHBSBnxGqLbDYcvmoMJGozo/+szdHf0/yuJYn7ZOjxkSqCTusfZ3+SuItda3NT07JvfixpvWWepNDbg52upnE9JpehdIWjzQEKYk6foBFtJZwmIe0slo7zNKQLeDFLZhNd+6okMO2EeqEaElf4kS2cMP1xGgBRBLyovrKY4ZlyZ4y8dBDBFAqZxaAXQ0AZnD+ELkyG9EYnX4qE/3JdGts3P05zXtiSm5hIWIGkcKTsYYYnifa1CpJN7IrHfSpc85xTZHaYKmoCCfYRd/51XbEIbbWEu+4SRpG/AUtGfXFbDpAvIcRHfwaGwmMk4UfVvFo9VzLn2UqFaCx4JPja2LIArjseQWxh9qJCMVAHbs3uHDfX
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(346002)(376002)(39860400002)(451199021)(40470700004)(36840700001)(46966006)(40460700003)(478600001)(6666004)(36860700001)(186003)(36756003)(26005)(426003)(336012)(16526019)(47076005)(83380400001)(2616005)(82310400005)(86362001)(82740400003)(356005)(7636003)(40480700001)(316002)(4326008)(41300700001)(70586007)(70206006)(6916009)(8936002)(8676002)(5660300002)(2906002)(66899021)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 11:37:59.8914
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 396a62e2-1e36-43d9-ca7e-08db61cb7cab
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT111.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6086
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


Daniel Machon <daniel.machon@microchip.com> writes:

>> Daniel Machon <daniel.machon@microchip.com> writes:
>> 
>> > Where dcb-app requires protocol to be the printed key, dcb-rewr requires
>> > it to be the priority. Adapt existing dcb-app print functions for this.
>> >
>> > dcb_app_print_filtered() has been modified, to take two callbacks; one
>> > for printing the entire string (pid and prio), and one for the pid type
>> > (dec, hex, dscp, pcp). This saves us for making one dedicated function
>> > for each pid type for both app and rewr.
>> >
>> > dcb_app_print_key_*() functions have been renamed to
>> > dcb_app_print_pid_*() to align with new situation. Also, none of them
>> > will print the colon anymore.
>> >
>> > Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
>> 
>> There are about four patches included in this one patch: the %d->%u
>> change, the colon shenanigans, the renaming, and prototype change of
>> dcb_app_print_filtered().
>> 
>> I think the code is OK, but I would appreciate splitting into a patch
>> per feature.
>
> Actually, IMHO, the 'colon shenanigans' does not make much sense in a
> patch of its own, since its not really a standalone feature, but rather
> some change that is required for the prototype change of
> dcb_app_print_filtered? 

It doesn't make sense on its own, but it also does not get sent on its
own, but together with the following patches. Its role is to set stage.

dcb_app_print_filtered() should first stop assuming the callback prints
a colon. So you have one patch where the colon moves from the callback
to _print_filtered(). That's a clean, behavior-neutral change that
should be trivial to review. Then next patch introduces the callback.
Which at that point should likewise be tidy, focused and easy to review,
because it will only deal with the new callback.

