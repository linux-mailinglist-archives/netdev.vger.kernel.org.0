Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE303182D46
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 11:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgCLKRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 06:17:10 -0400
Received: from mail-eopbgr140045.outbound.protection.outlook.com ([40.107.14.45]:65095
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726044AbgCLKRK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 06:17:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I/GWz2KyvMQZl5dG8SO70zqtrwjoi3Svfo9vCzfQqKNSJ2bXYzPWLcNXt2jMNfmjRtE5YkvAB2k5xYyi+pS6Oaf6Rg7q1oC6Q+xeJNUH+Lu5m132sBy1gaTJw1XKK5PesWHTdMt6bwKNvJGGRNpSZOThEtbzGH/iL7ImRTRwjNNxfIqQ7QX+mmd2pZk9LfdAlF7txaTz5tLuA3qmDPPRav3YQfvwJ5Lu79ByKyLZ4VepgEe22eStsvDEz19+KN1UlT040utiq3s0JhJcWuTUGCn/oH1Fju9DY9HnL2NcNMN4W4tsTOhLCFCkZoh5eenDF44c/H8eMs1sAiKBO2fylg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7C+mBwMk+JRVw/ror5gzQiut1/lu7ngxAPcykPQKs4Y=;
 b=K22KpAtxkzCLvsQeWs+3sWezH7tC/Z1GIOxtn2o8NGOQSto09wNMiOc1azqtjfPaU9URxqCBuvceLMAmUH1mxhzZT3ysvErrztFPDCRiVLrMKwe/LwubGxOg74KJlcVdSHI0Shg7GvsedEUYk4e74XKKyFw+Gc5IIPos+tWIyldp+/YgsP3w5D0SO2DmLX9JiMlqn7151q8yLqf3ZgtCpUh148ywUfK4A72OPMIPsZJoYF9pYi/yVXVdpQx8a3+cTI3qhqrVTuVAuw9s4oMewBnupnwpCveTa7MZRtIcqHftb4Hwa+oG7UdzVBuAMTfcgXSo6YPWetuy1Nb+M22K4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7C+mBwMk+JRVw/ror5gzQiut1/lu7ngxAPcykPQKs4Y=;
 b=DeLSjgoXzP1A910nKmiHP2R1QM+/9OuYln+99y6xi2yGIH7tkJhwc8RRdgcGHa4K06T6ATPwHh4yDdlIjitl1N/iOXsnnCGpHupO3KzB0ToO/6kmlE4IVLhFgpdGzaQueOkONwWMQ748YfWLaphNY5Zm1YXEiLLZlLMWun5tfi0=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 AM6SPR01MB03.eurprd05.prod.outlook.com (52.133.25.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.13; Thu, 12 Mar 2020 10:17:07 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32%7]) with mapi id 15.20.2793.018; Thu, 12 Mar 2020
 10:17:07 +0000
References: <20200311173356.38181-1-petrm@mellanox.com> <20200311173356.38181-4-petrm@mellanox.com>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, davem@davemloft.net, jiri@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [PATCH net-next v2 3/6] net: sched: RED: Introduce an ECN tail-dropping mode
In-reply-to: <20200311173356.38181-4-petrm@mellanox.com>
Date:   Thu, 12 Mar 2020 11:17:05 +0100
Message-ID: <87ftedyj1a.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0026.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:69::39) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (213.220.234.169) by AM0PR01CA0026.eurprd01.prod.exchangelabs.com (2603:10a6:208:69::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.20 via Frontend Transport; Thu, 12 Mar 2020 10:17:06 +0000
X-Originating-IP: [213.220.234.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ba846944-05fd-4f22-9c7f-08d7c66e84c5
X-MS-TrafficTypeDiagnostic: AM6SPR01MB03:|AM6SPR01MB03:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6SPR01MB039DA976EA5FC41D02ECA1DBFD0@AM6SPR01MB03.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-Forefront-PRVS: 0340850FCD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(346002)(136003)(396003)(366004)(199004)(52116002)(4326008)(956004)(16526019)(2616005)(6496006)(86362001)(26005)(81156014)(81166006)(6916009)(478600001)(8676002)(186003)(4744005)(66476007)(107886003)(66556008)(2906002)(54906003)(5660300002)(8936002)(316002)(6486002)(36756003)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6SPR01MB03;H:HE1PR05MB4746.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aXGA9QCsMOSui0q6HY3h8XmUdGXl9cKxrxgpK/YW5ZimpT251i8OC3jCsSqIEsQ0w59Uyy/TZw1YW/j8695v6o9bpIrkJ/+D27Y5vbfI2Ujkt3Y/d3WTywaOGfSjjRCnZuoxsETGUT6habq9FUbiVtXzEJCKO/nn21R0HGUw4NeIJxDnP60K6poDu77jbx7IwpSMo4fqZWYkFo+5DlLdGgFDpuUZAroOvJkDnSeBAfbapcOyRWKa5zTnWTkhcII+Jl3gZ9KlU1/tZ5pBXgFmxC1VzZ7xm7xzdZqBfS07pcsiQCluNzyGqK+3sFKOEzdvYvnma5XjwxR4rq06RWj0NKyhtyTB1laFUUSY9IuB7RQhofWq0QjJ6NUOmkKtvHiPEW1CABvchM0hSnq2T8KhuWGyKW49isYtCN5easuLbiFzWNX74AGJel0aE4520S7v
X-MS-Exchange-AntiSpam-MessageData: lLUb01idFZvE7cC6X8h9lH5K17xrXMkncw9hE7WOxH/6ObdAdMrBl1Zaa1Zk+gE31hq/2WVRU7W7VnspV9yQnz/1xPoQe+fOlfYObPpWTiXzHecojkaYmnY9YLH0l1AarSdpX4V9d21s6B3QQ0btxw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba846944-05fd-4f22-9c7f-08d7c66e84c5
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2020 10:17:07.4019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FwyuWblrmFVqBjBKpD9OQ3kVfDGZpUjBYoV9s3B+Ox32675Yzq1GungRwYbgBjrTw6kUqfqJsvzVjDvL3PLpOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6SPR01MB03
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Petr Machata <petrm@mellanox.com> writes:

> @@ -60,6 +60,11 @@ static inline int red_use_harddrop(struct red_sched_data *q)
>  	return q->flags & TC_RED_HARDDROP;
>  }
>  
> +static inline int red_use_taildrop(struct red_sched_data *q)

Forgot to take care of the static inline :-|

> +{
> +	return q->flags & TC_RED_TAILDROP;
> +}
> +
