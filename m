Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27DC855CB10
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238881AbiF0QJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 12:09:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238282AbiF0QJV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 12:09:21 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA6C64D8
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 09:09:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MtUmDHGQMM0+0L0X691m3h3O2QBLvqXUy/Wz4Rs6mwkrCFrHS1Xa3/09u0awM/WyqNdDqy1bstpba5/19bYlU56ozs/FjDRPPkeeGzuP3KkmXa/gM9Y59YMBmSBwBNnp5OfslX0a0WVP6KRhHJb5hwH95GFhcehWw9QhKYgYJ4dVa7uGMJBwuVD+q7U3h722Ok8nPPCYi7bQSVqdfaukLPtTDWQnalcFp+DXIobRttFG4glZFrjXR90IjeZBaGSJJtztg1Kk0b+PiCbLH7FliYB4y5Jp/S1JjwQteIO7Z2f5tr+HvlUQw9rY1rYJfdWaFrBt6cBOj4T43EugvziBvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LVToDp4dEvHqJfbwl0VTVms1OUA4W/mf6O/8CA5p9c4=;
 b=jDpTEuvhiqPcuRx2XtNh4cq+9nZyc/qawUjyXz7cQ3Xq1/cz+gIxAlC5D29gbxO5rdy6CZGdfEW/HmH9YHkp+iHlbTO+ju1neeH7gHyXLX8wFX0AYPXZKH0ZpXI2Jw9uFRi0vEeiUpUb8JyF9+/xeSEelS7BZFF7xJ0gtphKfXqiYOEgG7e/ty/RitO4ZPhsayt1aFN8kolAX0ZX4VFT5s3MBtQfN68rg6tvQGwyr1ZbYB8mqIPqd5lKtABkYu7hO06ZHxb01Np3cjANrgwTqyryQdL7g7LX3AL+Jx3QlhJPHejDe1dCzsxGp8a2SopG5/kUYGf0+ILf4/UnDfD5iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 12.22.5.236) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=temperror action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LVToDp4dEvHqJfbwl0VTVms1OUA4W/mf6O/8CA5p9c4=;
 b=mZE44SszBajyzyiMeRCRTh8P00K50X1HdNBVGIwsN7hnWhI0maY+B8A4hOCWujnINVaQQAnGtI8k9oOmio4UBW+1q+5VUi/HEKnUdz5f8DUwNa7Sbif841xPpz07WsKic4nBQMdmNIkcpY6CEc+ef8EG9nHkW1n8QRqnYUGcPZVl42q2T3xMyYkVpt+KqqxII/HV3h3BYqK0WuUZ4rjwJyPRpXrdgfFwM4NIYaYoE4okIU1PUjgMpcbLWc+8X5rrAaCo49zDjol+3plWiqjle4mHPQAg3HVbfoFIa7wTa4EOIOttYuoFFa4YSks6SZwQoGvYB2Y1lAOIdgleGL7beQ==
Received: from DM5PR07CA0092.namprd07.prod.outlook.com (2603:10b6:4:ae::21) by
 BY5PR12MB3650.namprd12.prod.outlook.com (2603:10b6:a03:1a3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Mon, 27 Jun
 2022 16:09:17 +0000
Received: from DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ae:cafe::5c) by DM5PR07CA0092.outlook.office365.com
 (2603:10b6:4:ae::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16 via Frontend
 Transport; Mon, 27 Jun 2022 16:09:17 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=temperror action=none header.from=nvidia.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of nvidia.com: DNS Timeout)
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT057.mail.protection.outlook.com (10.13.172.252) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5373.15 via Frontend Transport; Mon, 27 Jun 2022 16:09:15 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 27 Jun
 2022 16:09:14 +0000
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 27 Jun
 2022 09:09:12 -0700
References: <1b8c8a3e8ae41a85f2167d94a6d7bcc4d46757f6.1656335952.git.petrm@nvidia.com>
 <20220627081421.3228af32@hermes.local>
User-agent: mu4e 1.6.6; emacs 27.2
From:   Petr Machata <petrm@nvidia.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     Petr Machata <petrm@nvidia.com>, <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2] ip: Fix size_columns() invocation that passes
 a 32-bit quantity
Date:   Mon, 27 Jun 2022 18:06:54 +0200
In-Reply-To: <20220627081421.3228af32@hermes.local>
Message-ID: <87tu86ulzt.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 276b1fdd-1eba-4a07-4220-08da585761e6
X-MS-TrafficTypeDiagnostic: BY5PR12MB3650:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CHnN4Usjrwf6ud9MJWWIMUwf+/2HzVb1PhUQZi/mFZtAp4pm0bIaTpwNbHuBWcKQXWeXOJbs74el1U/mdXq9fEcQaL7v660BEAZMZgpEWhKTsi3T883qVDlx2bwuZY7t7WkjPm7SmnPjV72nMNeE1ycLRiQ7QIJYbViK0EjPtzdXYuw7t4zdSutAU1c/YnjHhZ30owyp49uKumd5ZF7NUiJsIjb2DMxWJ1QYMgUU/PRw7UKQOVgkim56LRN3Ki5mk8aUtScVRl0OBkle6P9Po9rtbmDR2w4S2Z/lwkhwyUwYWRjrbRM84knxz+dMiSgMBuhre9jtsE+bLZo4G5r/b9h7+yvsJ6bRRHX76ZfsgjHEmU7bGIwXXX0lWSH0RRvEWU/PVh45Dyk+IXXGTspRDzx53+Zqnk5MK9T2GZb8IK7XJXkQMKfuyJaerhS7HES3LWKUBPbrMYDWZdeIekTD7PUD5yit0g/8OH8Y4I93hz502tSDWx49TaKEfK/oKFlAD66CRLkrTTIdiexHQnBYALHfGh5zpAuqGUbwqgTwswSvxJR+j/kP0z6ohic+SPBVFE1tmnQLGDxcsFMMduZU3fRBfLEnZzAIPF6jlxSq3cGdBT4ayLtiNxfAj7Vnt//gzIu4Xr5Oux0HIqiVe0Tdyr0L9+f56YKKfU8lQwMKmnIRlq3rSJG4JrYYijCMUnExop3BUGch7B3x/lQ4Rjg//1RRM7GXcw82HJ+kU2WoMvF1CTA7E0qkfeZ8LdhA3VdQJQQEIv6cdst9EYa0pKNevD5pkUIc/DuJ2oNDy2WnaJKFdf6OXeWgNxcxD7AqFKXMsb+Wy82MQ3ZwgIiy7iro3w==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(39860400002)(136003)(396003)(36840700001)(46966006)(40470700004)(6666004)(36860700001)(26005)(41300700001)(36756003)(356005)(16526019)(40480700001)(186003)(478600001)(86362001)(2616005)(40460700003)(82310400005)(82740400003)(63350400001)(8676002)(2906002)(6916009)(63370400001)(4326008)(54906003)(5660300002)(4744005)(47076005)(70586007)(70206006)(81166007)(8936002)(426003)(336012)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2022 16:09:15.2975
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 276b1fdd-1eba-4a07-4220-08da585761e6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3650
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Stephen Hemminger <stephen@networkplumber.org> writes:

>> diff --git a/ip/ipaddress.c b/ip/ipaddress.c
>> index 5a3b1cae..8cd76073 100644
>> --- a/ip/ipaddress.c
>> +++ b/ip/ipaddress.c
>> @@ -788,8 +788,9 @@ void print_stats64(FILE *fp, struct rtnl_link_stats64 *s,
>>  				     s->tx_aborted_errors, s->tx_fifo_errors,
>>  				     s->tx_window_errors,
>>  				     s->tx_heartbeat_errors,
>> -				     carrier_changes ?
>> -				     rta_getattr_u32(carrier_changes) : 0);
>> +				     (uint64_t)(carrier_changes ?
>> +						rta_getattr_u32(carrier_changes)
>> +						: 0));
>
> Looks good, but would be clearer with a local temporary variable
> which would eliminate the cast etc.

OK, I have a v2 queued up. I'll wait a bit before sending for possible
comments on the rx_otherhost_dropped patch, as it depends on this one,
and will need to be resent for this change anyway.
