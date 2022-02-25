Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01CCC4C4B8D
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 17:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243238AbiBYRAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 12:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241043AbiBYRAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 12:00:20 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2073.outbound.protection.outlook.com [40.107.212.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B04D1AE673
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 08:59:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cDnQ1qqsFysuCMQxaHOjWgragbtMTRdWfJYeOHq5PPOetPNs6YEgJwcCR/euo50RoDwTD4CswviJvbow/GX5YkADXvtoyCHCk1qHskylZMvXhHjxO3SRoJU0hWmq1BpS6CF62Vm06MAcBf9VBCBOwqCLxdkZDbGC5DOy5ouuizRJTP2YdheepwyF0eRmu6OQY8tpkG1z24gF87DlhvsYR4/sVJzuquR0xT/GiUdBtBtzOSW3Md0chV+uWN/tlRbf3Y50+kFD4U3958IKIlJR5kXpnbIsIFnjPKc2NC2iT0NzXqdcqNdyuYkvkI7E06PXZI3UHe8V5+WP51PL5qjR5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pVjtVAhdOnlaAsL2Nc9TyXI7VSHKuZdK8d6O+oFR4zM=;
 b=kHoHAfCMaB3MEtYnnpvEinBv3OqcMcoFxAtJbc/CyayfQC2hqjYGCUUdogjbZpck+sIVZXKQyj4xJMdvOx/hhSjtUQopyCtXKf7We2HEEPSU/P77v8O2irJM5nPU64LQhHCGZOSmCIvLlQYieiH7FyszJYXWIp50ydCymdc/gPHPfeldF9CwJJ1OGRAtCmS10aaWgPNIW+T8kzukiA0flnqrQCKs6yoRSUYbfGOejUH0xvQ8Y/71DOPTxHk+UD4bxEyIHE8GG5U8p+QFErYoVZ4yVFP3ZN6/aepucWIvw6lXZuSbGe66/FqCy8dWJ78qS4gAoVLMkrumj0lqQ8M9Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pVjtVAhdOnlaAsL2Nc9TyXI7VSHKuZdK8d6O+oFR4zM=;
 b=smEWoP6GFjJRg6FBEgE1KDULWuEmRQFctrZlpWSd+J0pKssLTzDRjCooER+GnCgGVft0l0YnBW/zetBaPULCuh7lLR1mXWz8q02MP8f0ysE6ERmAJhEYieO63P7KwMT5/CnsGyjZ1YoAsRjvGiHVScCuHu0eBbYSJWNDDIQRXesSwoZBcPhqsy6xsrzCzTeVb5YRH/xvYDX0cxSQPCGyT0WX4Vi2f/mVNljiIQVYXhBjYMOHBzQ8splBGbZpiCyf2Jy47zom07InsPk1V0rcWhGwvZ0qfPLBxvIumB9gM93aCZTzgGjqzLRFECjIVABJWKzIZXbZhwsBE8CffWGAjg==
Received: from CO2PR04CA0068.namprd04.prod.outlook.com (2603:10b6:102:1::36)
 by CY4PR12MB1318.namprd12.prod.outlook.com (2603:10b6:903:38::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Fri, 25 Feb
 2022 16:59:42 +0000
Received: from CO1NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:102:1:cafe::6b) by CO2PR04CA0068.outlook.office365.com
 (2603:10b6:102:1::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.23 via Frontend
 Transport; Fri, 25 Feb 2022 16:59:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT054.mail.protection.outlook.com (10.13.174.70) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Fri, 25 Feb 2022 16:59:42 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 25 Feb
 2022 16:59:41 +0000
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Fri, 25 Feb 2022
 08:59:38 -0800
References: <20220224133335.599529-1-idosch@nvidia.com>
 <20220224133335.599529-4-idosch@nvidia.com>
 <20220224221447.6c7fa95d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <87a6effiup.fsf@nvidia.com>
 <20220225080422.7551b855@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
User-agent: mu4e 1.6.6; emacs 27.2
From:   Petr Machata <petrm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Petr Machata <petrm@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        <netdev@vger.kernel.org>, <davem@davemloft.net>, <jiri@nvidia.com>,
        <razor@blackwall.org>, <roopa@nvidia.com>, <dsahern@gmail.com>,
        <andrew@lunn.ch>, <mlxsw@nvidia.com>
Subject: Re: [PATCH net-next 03/14] net: rtnetlink: RTM_GETSTATS: Allow
 filtering inside nests
Date:   Fri, 25 Feb 2022 17:57:20 +0100
In-Reply-To: <20220225080422.7551b855@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Message-ID: <878rtyevbb.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b957b2f-d6ea-45b9-45fa-08d9f88037af
X-MS-TrafficTypeDiagnostic: CY4PR12MB1318:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1318314818D2776B15B1202CD63E9@CY4PR12MB1318.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZtwChZsMc8qdRQjq6aJOfR1XZoekBOC3ElNHfY71rUnHSRo+xcJPu0+HwSSVt5UIu0n3KKrvba+JtnqwbF1MzM5+0IN49sR/eqON3wRbZWqptnhMGoDO0G3ZDoV2bNW+PTbKiGjVkbS7qXIvTom7o902D5z3UxtEEJADl9TUqvueYcoWzJ8QINU5b1UCYouLQyHPH42mqojhbG5dOCEnmt08kOBeiD5PqJKof3Je2ZvYEgHJkBT0VCvJrl5eCYNGm+xD7Wi4o1UhBjByu8ai8yJT/a9OHq6YFR5LxAERfjRPuHSmr7YZ+Lz9VQeQcvZ6VfL45FdH/j8joMD/QS2eVbfJeLfTp5B/DrbIkCumAGWTfD3a17LQJqIZWMZ5w2eC0sAtx+C80ERneTL6laLEQg2zxhACvKHECjjeAfU/3NYOn6R4O/Ed4S6x1DO0XpTKuz3ztY465wJXDK9LXioZjfkJM1Eey6PvtCjnsBIJgL1zzNe2BY6kdHZ+UrcGhGgOf+ZKaM+fuDjDpq3ZnuWX2hRZPGB0NUUkZFiHPFprAwl6X4WkbyI6SRil1XUlLvC3wItIvvbl8lta/N06BmjsrUr6/JjPjj0sk+XO1TUOqHwAp8/481tVd4QfNjXrS3dl11kP+PeINI1CFx0R9+SBbqTbkIq0+NFGW7m7uvdu9gErAe9LqQi7Tpc7fQ2X+mnBDywmfbNAUrJ0fZDZhrw4qg==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(186003)(356005)(508600001)(16526019)(70586007)(36756003)(5660300002)(8936002)(6666004)(4326008)(86362001)(8676002)(107886003)(426003)(26005)(2616005)(2906002)(82310400004)(336012)(4744005)(81166007)(70206006)(83380400001)(6916009)(47076005)(40460700003)(54906003)(316002)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2022 16:59:42.2121
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b957b2f-d6ea-45b9-45fa-08d9f88037af
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1318
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jakub Kicinski <kuba@kernel.org> writes:

> On Fri, 25 Feb 2022 09:22:19 +0100 Petr Machata wrote:
>> > Why use bitfield if we only use the .value, a u32 would do?  
>> 
>> The bitfield validates the mask as well, thereby making sure that
>> userspace and the kernel are in sync WRT which bits are meaningful.
>> 
>> Specifically in case of filtering, all meaningful bits are always going
>> to be the set ones. So it should be OK to just handroll the check that
>> value doesn't include any bits that we don't know about, and we don't
>> really need the mask.
>
> Nothing that NLA_POLICY_MASK() can't do, right?

I see, so no need to even handroll.

> Or do you mean that we can when user space requests _not_ to have a
> group reported?

Can't parse this, but I do not think unset bit X will mean anything else
than "do not include X+1 in the response".

>> So I can redo this as u32 if you prefer.
>
> I think that'd be better, simplest tool for the job.

NP.
