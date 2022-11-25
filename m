Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD0F638AEC
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 14:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbiKYNMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 08:12:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiKYNMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 08:12:35 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2075.outbound.protection.outlook.com [40.107.92.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB9AC13DC8
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 05:12:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b7LqcMaR8CoD5ns3yT12Gg9NjjDPkNwlJG2ylqJ6DcQPzLHt9jDQVxfccdFC5RtH0oMjQM2DMjVNzMk2cMPJqyw3TQpBbR7DFq1nxrjypkbGVjFBQuprzv2q3QwOv1OmEYk0BkSNCVxqtQtq8b+ZWl8L2LJAoHqQF/VDmxxzXmBJNpoAJc13fBSz+TiaJ5cBIba/ubRR6GGZ/Y5LHXflctoXofl/zbgGESrtgBxPJJcL36jq9yIYc3s/XzYM5Z1QTym/vMOWjVD/dkw4nHi8KVzwY1ft3lYtDyrSyKEd/7VuylFnnzGu3E7n+MPi64kSwMcjlGZfszVGVIsPb9bwDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Px+VlkTr3SbCmjpqDoVO+pUwjWOLBHmwtrgFxjdKewg=;
 b=S7AljSt54SaSapB3+mSbiJ3ghm3W5/7i+G3zW0uiM8xLV+ryrfJ6bBKhaJ5NsqIyAlL3Y4WE2ZU5CljOYqckfK4RZ8ceJCKJteg78/at4FkcZRfVu68sgJzxdoCzkx8XJ2y7GJxnDLWGZV/nRLIHX9RLcduxTDeAdZ4MKwwkR2e3WL8irzmnQ5QlCtw1btAlm+alWR5eAJot9KB6o/VKcDI10N+XN18Srigv8uVEqAYoe/ajRt4kK07PSgjqkYUJC5nFbpAPQoeR/oTyYH1MdbPPpM2s0nGWe+Re5xWymaWfxc2DutJ4FzFjhDNmleLa4AYyKgksq0kR4RrkJW1hgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=microchip.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Px+VlkTr3SbCmjpqDoVO+pUwjWOLBHmwtrgFxjdKewg=;
 b=pFHw54BSkcIHTA+6NPLUyaI9x7n7MK1QAHiiQckCAXMLfr192F6eOWitlwoiKvvGpnwfsVv4ltBxMQ5HaS3RR0RgxUefDAYsMl3p+Ok4R+W2FV3AjVSCkr71mjw5mZSuOuvcjIv/TMZLGtXvNQi+Rfcwt5fdYZ+xEegeYc6ZSX1eOzFjVHfho7+5+rbK9nRcJaBcimCrbetToYuEY97FTrsbG9tC80+oU5yI2sYT+EtlrZnVNCjNGlB3lYSK1bR0FLz9PNgKzyBlQPYNAY1E0M8K1kIb3nYCpL014VnIw/VUZ9UM7bgQjURIZJeMCsPIlE4W7r0ZE9SZlRovd6apVQ==
Received: from BN9PR03CA0397.namprd03.prod.outlook.com (2603:10b6:408:111::12)
 by BL1PR12MB5730.namprd12.prod.outlook.com (2603:10b6:208:385::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Fri, 25 Nov
 2022 13:12:32 +0000
Received: from BN8NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:111:cafe::bc) by BN9PR03CA0397.outlook.office365.com
 (2603:10b6:408:111::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.20 via Frontend
 Transport; Fri, 25 Nov 2022 13:12:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT021.mail.protection.outlook.com (10.13.177.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.8 via Frontend Transport; Fri, 25 Nov 2022 13:12:31 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 25 Nov
 2022 05:12:31 -0800
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 25 Nov
 2022 05:12:29 -0800
References: <20221122104112.144293-1-daniel.machon@microchip.com>
 <20221122104112.144293-3-daniel.machon@microchip.com>
 <87o7swi9ay.fsf@nvidia.com> <Y4CJWeNMMacAwHiL@DEN-LT-70577>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     <Daniel.Machon@microchip.com>
CC:     <petrm@nvidia.com>, <netdev@vger.kernel.org>, <dsahern@kernel.org>,
        <stephen@networkplumber.org>, <maxime.chevallier@bootlin.com>,
        <vladimir.oltean@nxp.com>, <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH iproute2-next 2/2] dcb: add new subcommand for apptrust
Date:   Fri, 25 Nov 2022 14:06:36 +0100
In-Reply-To: <Y4CJWeNMMacAwHiL@DEN-LT-70577>
Message-ID: <87fse7i3et.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT021:EE_|BL1PR12MB5730:EE_
X-MS-Office365-Filtering-Correlation-Id: cd078e0b-90e0-4097-c036-08dacee6b62d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5LGcr0+M+JhLY4ka1CWkgK+mSzF4QW5xCdJTzHGqGFKTgeng1h0VOCmm5UPf3j40r1RXvm5aSjV1RMl8dkb7S0UG3sqeh62Ey3nPwp1mtuWdyufH0AnM62U6sHHK9Aw5z0nbB/vrcGzjDqXOCqs+8osdfD3dB7DeKxcIYsfqcACR5OXYaFQhp3LJ1XhE4cErsgjccK8xeELSfsi+LVH92WfF3XYfDx9no9HEEsL+SXpuFEZXbBkB0h/YeNU8iz62QB1ZknuW8pKfQ8s5iEGwilntTQBtxsN20/0hsfoBHqcMUGjdvQQL7w1eqMMy7iFaF21eW/+5ZtElvbGh733LvOAP3roVfKLs+e8RZWkI2Kg/gW+2lZKSSrxmlyGe2kDd1q9iBgVIvpFbi3J3L63eO4t4Cjm1uvBVvWkogLBCCqGmtTYfQf6LRqB4CSGcUDbiA0JRudZBKAMZR0XyQ/diK5BqLT4ZJnotjX97iOT/YD6x/66hcFhxwsHDpQB+tI0idHgkcEHjjn1JDSm2CDnsal3fvwM/n6uLUkcmM4v1mZ9VTmgwQ4KB7QbQUU4e2QGaXZbcRh9TTjeDNqPVJSK/3Jk/AjHz69ZULn/5aVlF6D97jsfa42nnxLLN7ZgTy47OlDoOpDcesaqzRTjMapEGFXyyJzdUvJgO8aqUd2fkfhdlyWTYmexNQCwr//rE9FwMHsFLKJIw3SBE6nB7NnbVag==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(39860400002)(376002)(136003)(451199015)(36840700001)(40470700004)(46966006)(5660300002)(6916009)(54906003)(4326008)(82310400005)(316002)(47076005)(26005)(8936002)(336012)(2616005)(40460700003)(16526019)(426003)(186003)(6666004)(478600001)(8676002)(70586007)(70206006)(41300700001)(86362001)(36756003)(36860700001)(2906002)(83380400001)(7636003)(356005)(82740400003)(40480700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2022 13:12:31.8566
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cd078e0b-90e0-4097-c036-08dacee6b62d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5730
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


<Daniel.Machon@microchip.com> writes:

>> > +static int dcb_apptrust_parse_selector_list(int *argcp, char ***argvp,
>> > +                                         struct dcb_apptrust_table *table)
>> > +{
>> > +     char **argv = *argvp;
>> > +     int argc = *argcp;
>> > +     __u8 selector;
>> > +     int ret;
>> > +
>> > +     NEXT_ARG_FWD();
>> > +
>> > +     /* No trusted selectors ? */
>> > +     if (argc == 0)
>> > +             goto out;
>> > +
>> > +     while (argc > 0) {
>> > +             selector = parse_one_of("order", *argv, selector_names,
>> > +                                     ARRAY_SIZE(selector_names), &ret);
>> > +             if (ret < 0)
>> > +                     return -EINVAL;
>> 
>> I think this should legitimately conclude the parsing, because it could
>> be one of the higher-level keywords. Currently there's only one,
>> "order", but nonetheless. I think it should goto out, and be plonked by
>> the caller with "what is X?". Similar to how the first argument that
>> doesn't parse as e.g. DSCP:PRIO bails out and is attempted as a keyword
>> higher up, and either parsed, or plonked with "what is X".
>
> I dont quite follow you on this one. We are parsing the selector list
> here. Any offending selector is printed, as well as the entire list of
> valid ones. How could it be one of the higher-level keywords? Am I
> missing something here? :-)

Imagine there's more to specify than order. Say, per-selector rewrite
enablement or something. Then the command-line to specify both at the
same time could look like this:

# dcb apptrust set dev eth0 order dscp pcp rewrite dscp:on pcp:off

I think that currently the "rewrite" keyword will trigger the -EINVAL
return above and the whole command line will be rejected.

Right now it's all the same, because there's only one thing to
configure, but it would be cleaner to handle this case as if there could
be more things to configure.
