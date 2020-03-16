Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F050C186988
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 11:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730678AbgCPKzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 06:55:00 -0400
Received: from mail-eopbgr140058.outbound.protection.outlook.com ([40.107.14.58]:24583
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730582AbgCPKzA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 06:55:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e5//YYmLAZY33gjlq9XSeG1EVY2e6JcV2++Rfgv7oKjhkAP07HlXWVrTAINZNwv/Y9a004q1ESu17GO7gcKWfO1ErMiNlum2mDDtUqb/A6rP5+HyvMUWHFIvtmlR/R0RX1H7jGBmSgcL6DV/cpGRSRdcKBw8UTQmDl3ffAUbhwl+JKsK8AdHuy2w8T9kC4+RLkxDngrQCGpw+ttEV+aVNngO2dZpu0jrC2saWKJZqWsQLRs2vN8nknplZ8H3eDsZnQv0IlIDEDhEy7Co+m/qHdOLYZvN3L2p4MHRtPRoxd/n2iG5l5BJIeAzNMw4kK7XgMxMRbUMbdSYMJ5dL0zeaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z4zQc8GWVnt54dq2zLVBQI9VbL3YL6WNKjbNrk3jTK4=;
 b=NNMxPhvG7xX9vZ+7zOV5zVXC+fKhWwBRZCnlFRrAlVfjozx5qy6+YuWWm2bup9sTvABSv/JsUHGE91C/cSVfuYegPn9TbA/9XsPxABMnhWAjH9auPu8IvLGXRiY8slXg3vyDkJk+hJ1eYC3yTu2DRJJyiTLqxjIa8mNm0d+x7EscVdlec8mHhdBiRlLgCn+JIPaEEcIc9rYjUyJNku/azppPCzXS+vh9msvTA5OgLKx68VqDUw9T6Cv/eUfQIGm3qAQW6RNTQ2YA4yRDfEChHIQg0SyOyrBHAI2lrE1GlHbazWvKPlHratHPjvBwzaps0l2vlmci1UqUXFJFZYpt/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z4zQc8GWVnt54dq2zLVBQI9VbL3YL6WNKjbNrk3jTK4=;
 b=rfPEvQcCghfOKL1+ygrwJvnzwRBNnkZVx4afQZdka+f83Gu2hTjtLB2+TOHs+9upfTSSa4toC1TCnA2Pqa3Q40t8TS9vW+heXk66IoncKJrGZIj0LrTlKWX5x4Q9NJMS3GxG2WakpBK0TsxDedBMa8fvt2V+6zjxTA0Pf9pQWps=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 HE1PR05MB3404.eurprd05.prod.outlook.com (10.170.244.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.22; Mon, 16 Mar 2020 10:54:53 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32%7]) with mapi id 15.20.2793.018; Mon, 16 Mar 2020
 10:54:53 +0000
References: <20200311173356.38181-1-petrm@mellanox.com> <20200314.210402.573725635566592048.davem@davemloft.net>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, mrv@mojatatu.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [PATCH net-next v2 0/6] RED: Introduce an ECN tail-dropping mode
In-reply-to: <20200314.210402.573725635566592048.davem@davemloft.net>
Date:   Mon, 16 Mar 2020 11:54:51 +0100
Message-ID: <878sk0y3gk.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM4PR08CA0055.eurprd08.prod.outlook.com
 (2603:10a6:205:2::26) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (213.220.234.169) by AM4PR08CA0055.eurprd08.prod.outlook.com (2603:10a6:205:2::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.16 via Frontend Transport; Mon, 16 Mar 2020 10:54:53 +0000
X-Originating-IP: [213.220.234.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5c592200-eaa5-4715-c4ab-08d7c9987547
X-MS-TrafficTypeDiagnostic: HE1PR05MB3404:|HE1PR05MB3404:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3404ABFAC00D2DF03BE0B96DDBF90@HE1PR05MB3404.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 03449D5DD1
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(396003)(376002)(346002)(39860400002)(199004)(316002)(8936002)(81156014)(8676002)(81166006)(6486002)(2906002)(26005)(186003)(478600001)(956004)(2616005)(16526019)(4326008)(107886003)(36756003)(5660300002)(52116002)(66556008)(66476007)(66946007)(6496006)(86362001)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR05MB3404;H:HE1PR05MB4746.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3vUzfFzwBEv4HlgJGWp8F/BTW38n/uny4S/dR6kzsC5S1Sa6cT4E6+vc+DbgVfyjQ6XbTRPY5RQrds40DwhcAovum1NtPX4k2syedd0oLgH5ypFsMplkm4JoLgrvGsG9AU8f9gVYZe2Pby5+sa1T5J51335f3sIYLUtkmtSfaILuwqp7ciAPdcZ9+OscB3N4BW8D090Ah4W0rYXOmS1iWyNppWPjaUH86nXG8mPbayGuSGsIRwSWPnJH3cVu2AMpPSvH0QmZXopRej57p182wl9mrWaLYbW+vi3TP8CZ+c3CZGs4Ufd6zJctLaBY+Jku37pYQHiOIXEE41r7H1c9y9RZlkdBVDhUZtf1hKnN7/B39zIqx6Da43OCadOXwUkAEvbF8vN633C/bFSBRGLHjUeyGUCjV257l9RuHvQ+br1Ba3XwxER9i6J0+rwFu8yi
X-MS-Exchange-AntiSpam-MessageData: /j+vskHVHBC3U6mVeplrFjTMDZgO9sJ+w5HXB5SNnQ+qkwudGMlkn9gucyOufBM4Z8Dx30QBW+aZn1N7XlI4FJeirvWy76OBuYBFSGJW7WX85qv/pS1j2QohRr506L1SXqBioyR7Whiv993GFt/Lkg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c592200-eaa5-4715-c4ab-08d7c9987547
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2020 10:54:53.7273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3s0cYM0QBNqfZDWhWbxYI+0zZQS8lmvG875+Ap+a+PYQJj8XubaewZUMeYSmNIeQxJmoG3Eebimk8gBRHcAofA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3404
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


David Miller <davem@davemloft.net> writes:

> From: Petr Machata <petrm@mellanox.com>
> Date: Wed, 11 Mar 2020 19:33:50 +0200
>
>> When the RED qdisc is currently configured to enable ECN, the RED algorithm
>> is used to decide whether a certain SKB should be marked. If that SKB is
>> not ECN-capable, it is early-dropped.
>>
>> It is also possible to keep all traffic in the queue, and just mark the
>> ECN-capable subset of it, as appropriate under the RED algorithm. Some
>> switches support this mode, and some installations make use of it.
>> There is currently no way to put the RED qdiscs to this mode.
>>
>> Therefore this patchset adds a new RED flag, TC_RED_TAILDROP. When the
>> qdisc is configured with this flag, non-ECT traffic is enqueued (and
>> tail-dropped when the queue size is exhausted) instead of being
>> early-dropped.
>  ...
>
> Series applied, thank you.

Dave, there were v3 and v4 for this patchset as well. They had a
different subject, s/taildrop/nodrop/, hence the confusion I think.
Should I send a delta patch with just the changes, or do you want to
revert-and-reapply, or...?
