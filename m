Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA08D568887
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 14:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232623AbiGFMnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 08:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232640AbiGFMnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 08:43:45 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2059.outbound.protection.outlook.com [40.107.94.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9A5C1EAD5
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 05:43:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kGoVSZDo+qegOHEJq9p1ltKrWINiaaT3OXhHEtdY++fmp1E9twrDLqHHkd4P/+/4MFtvh2uQwvirkKfK8+/onOnWlppr9TD9xcn7HKZtwpTyI6rTwpJV/qYMcH50YrBzCE1FvzjvOozsPOF3NA08sjfQl8AdfZ0eY+bslCiLWKTxf+xqZ1fL7N6wYQ7yifDewDS/TP6+MZCJHDhy+3X44Q7n8oSr+cSGYKk64LjrBJ94t2OScZvch54vfL2OHZdLxDAWADu02ZxKhrOffyqhHX29jDfyty+wIMVilEQWKq9z2FUhcDMSHcLVGivo/tGDCt/36LeeLZU/HQr0kcCLsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2kY956u0mPhxux7xhTdVNNAIWjxH4zqZEGFGuLwzIzY=;
 b=g3oyVP8LTxG/q/aUH7PgifWfWeaXlhBT71ht92UzUciA3n0VckdYhscBGGIQkgeiE5xgm2YINU8z6LvjPGFQIDVykVhSMrdiFbtbPucXwp+QVpUbbaoho9nsLmMSmNSwcOqUfiZpoz7ZcEzyx2BdCC1nixBbIJoluIuyktfnx6qhZUI0pCoBfw0FtfCD5icdinOdyDqCDYPHoYz1ennB1do8VI12i8cZKJBNGBWMsBEgjjQTOI+petJEzXvNLI1SfpPwnlgJ2bcy4QVKLcXwqeHYtbT7Eysv2dsLH+5Q3vm3IKx5LoqYqK8Y/DuNg71p/fPYHro1PrdAuinXfmdKrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2kY956u0mPhxux7xhTdVNNAIWjxH4zqZEGFGuLwzIzY=;
 b=MTEQ4Cp65IQLE1VjdYFmC5sldfLqfhms4meyw3AmhdsS7JH+zX4XxNJ4sJQnXNjwR2xB2xGLkXzOuho3mzs814gcYfe5EOw3FeCeKJGIpj9n9dq+txAL5Zj8ugzSHf8DdHoziG9b1pXDUXn12s0OsodrUyrtbb9jmlgMvgf+DX0rVaK3zjPNv1mupozGK8jX0DXcv54l1mp/acqNN28fGo1TXCPcbEK2c7uQiF/116vxSYzdSKyXXp6I5yam04lVF+MpBCD4E/ZzMhK5jZy4ztats/+oePoY5WR8A5ZOUoswS/Ggn694Ru2T/sGiNSXijD3AjenPCFnJUdsSk9QrHA==
Received: from MW4PR04CA0199.namprd04.prod.outlook.com (2603:10b6:303:86::24)
 by BL0PR12MB4660.namprd12.prod.outlook.com (2603:10b6:207:34::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.18; Wed, 6 Jul
 2022 12:43:41 +0000
Received: from CO1NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:86:cafe::1b) by MW4PR04CA0199.outlook.office365.com
 (2603:10b6:303:86::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.15 via Frontend
 Transport; Wed, 6 Jul 2022 12:43:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT009.mail.protection.outlook.com (10.13.175.61) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5417.15 via Frontend Transport; Wed, 6 Jul 2022 12:43:40 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 6 Jul
 2022 12:43:40 +0000
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 6 Jul 2022
 05:43:38 -0700
References: <4148bef3a4e4f259aa9fa7936062a4416a035fec.1656411498.git.petrm@nvidia.com>
 <7a9cc617-c903-d9e7-9120-649a3bab86c6@gmail.com>
User-agent: mu4e 1.6.6; emacs 27.2
From:   Petr Machata <petrm@nvidia.com>
To:     David Ahern <dsahern@gmail.com>
CC:     Petr Machata <petrm@nvidia.com>, <netdev@vger.kernel.org>,
        "Stephen Hemminger" <stephen@networkplumber.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Itay Aveksis <itayav@nvidia.com>
Subject: Re: [PATCH iproute2-next v2] ip: Fix rx_otherhost_dropped support
Date:   Wed, 6 Jul 2022 14:42:04 +0200
In-Reply-To: <7a9cc617-c903-d9e7-9120-649a3bab86c6@gmail.com>
Message-ID: <87sfnes96v.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b3ec9c60-c5ca-446b-ae0e-08da5f4d27c0
X-MS-TrafficTypeDiagnostic: BL0PR12MB4660:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S18n60P4CyOoTTNnJiFmjLwqlYVrr5Yzz/LNWmayO89EUYIJE4dLN0X3ZJDLvN5X//7G4Bq6XTa7WhpXxfi7v+LCHcA470/2E6t1RSzqPoVUGHirXQvH5jCQYLMVfK7QZnCMj6f/YYeO16ueo57313gTVm5YqH3yWReyyPPXXdkWqHZ9xAes7wP2uK7HCWDZgYc0MAJ+V9/z8jaEYmpLDMq4ngk+trSYiMOkLObp5JeYqCDyEOBHqSMULWUdrApYbQRa56gI7T4vSkWxHNuLwMwQeuh9KayRRXgsdL8lr1GwOfRjGCv7dSMog2DDrzQmcO0Tcl8ScjL7RR1qBrAOvq7DZJgs20ZLjwReQHLqKuQu/p0M8jpD4fyYBqiYToOcmFhClgIArA7IzJ1E2QlFhiU4FLLfa1kcCUo1EXucMYE2DAqZmmhGIDnY6Xp5BMMe5laolWEakX9N71lS+zpbaRCA7hkv6UhxurWLxt7E/cAbpusQmJB7ClTHs/2TlJCbd86qBAK7s/sFGU6QDE+spYTBor5GZfI7M3YOUc4anaK8AwPR8fcSrhiGX0NPxIAHHZSk8s4uxPFwvRzBvEDcAAfMiDVwtg6sxDXlF7Og9CY8owlauDrjjL2HFg+KkgRQqS+jyskaYPgSnSXLTSSexDju22NDcaYm3q/TJfe1fJyOeldb9T867dDjonSGbSxHyL/6WW/i9Q4rWkXAEBxTX5mPosR4l34ssRSnYGxCjZoh3I15dLNDKw4wx5SUdn1HkiE8ZhWJFU2Fkey1RHmYdnr7w1W46Eu0vhULaVWG+PFHXjoqi7wtMi+L4ur+zb+12x1TVpuKCSmEty/yiXDAkKX+syONHwYqxBLVJRQuuW8=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(346002)(376002)(136003)(46966006)(36840700001)(40470700004)(8676002)(4326008)(70586007)(70206006)(82310400005)(2906002)(86362001)(5660300002)(356005)(8936002)(83380400001)(40480700001)(82740400003)(81166007)(41300700001)(336012)(47076005)(426003)(26005)(53546011)(2616005)(186003)(16526019)(6666004)(107886003)(40460700003)(36860700001)(316002)(6916009)(54906003)(478600001)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2022 12:43:40.9155
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b3ec9c60-c5ca-446b-ae0e-08da5f4d27c0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4660
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


David Ahern <dsahern@gmail.com> writes:

> On 6/28/22 4:19 AM, Petr Machata wrote:
>> The commit cited below added a new column to print_stats64(). However it
>> then updated only one size_columns() call site, neglecting to update the
>> remaining three. As a result, in those not-updated invocations,
>> size_columns() now accesses a vararg argument that is not being passed,
>> which is undefined behavior.
>> 
>> Fixes: cebf67a35d8a ("show rx_otherehost_dropped stat in ip link show")
>> CC: Tariq Toukan <tariqt@nvidia.com>
>> CC: Itay Aveksis <itayav@nvidia.com>
>> Signed-off-by: Petr Machata <petrm@nvidia.com>
>> ---
>> 
>> Notes:
>>     v2:
>>     - Adjust to changes in the "32-bit quantity" patch
>>     - Tweak the commit message for clarity
>> 
>>  ip/ipaddress.c | 8 +++++---
>>  1 file changed, 5 insertions(+), 3 deletions(-)
>> 
>
> I merged main into next and now this one needs to be rebased.

The issue is that this depends on 329fda186156 ("ip: Fix size_columns()
invocation that passes a 32-bit quantity"), which got to net only
yesterday. When it's merged to next, this patch should apply cleanly.
