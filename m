Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3A6188474
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 13:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbgCQMoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 08:44:01 -0400
Received: from mail-am6eur05on2087.outbound.protection.outlook.com ([40.107.22.87]:6017
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725906AbgCQMoA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 08:44:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BVoQpTcEE8QjNamff562yYytIbGsYe67yNvbqMYrXAVfV6Gk4II6g56op8w2Xn/0WIFgC8MUmFnrVhs8utmoyRnKu9jmCL6G6Ty3ahjvpDMI0RxvhxX+/o7dFjh4CdIr6TiSYeMAvwUVJ4LaxwMsJDvLGEb40hqfRjTSbSdHPL3DJw7ZEmEPcwdGMzWxwl9+Kjxry86g84Byl9bsB3doT1YnXpnZQu+yMKXrw07YtopJBACpk24RApm79o42PMav96nUnKWDs0WSOYwYdPtZxJifA75T12Dt2H9xS42oHuno6x9MgJ5gW3eFMIODcNTpZwdyLx6bh393f62jSOdvSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=98AFEjMX5f3X9H26/+c+a7ugLJFa+WIRPV65WfKl8AU=;
 b=UvYWsX+48Bgsb1tGnP/+zhicmhUGJUjeOgeL3l67gxKL+tf2iB1AzSt9imoXpjKXfXH4Oneoz5gdCBN0AeVGofqYsCgFNTAjDouQoq3h6xVsZ7hp9zyTqTC90zfTdksRg//3c6ay4YFDLBEzoCeUyMIo0QEK5jsf56o6ots+X4CuuhNFeTUS2RSg7ImzJkhO5De57GAIxBNH/LtCica1haJSPbkWkJqTKyQl62trHO0h56vJxsQZ+nsZeLJ7TdYR925nSVVqJ2gr4fMGmI8zymyfViCZ7yeJ8Kn5682INnu1Yr5k7YdH5Z8sD1wyFM+qVpYP0zzmK9OYHzO1iJmYbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=98AFEjMX5f3X9H26/+c+a7ugLJFa+WIRPV65WfKl8AU=;
 b=EMkL8S0MRL0s2wyQeXT2+i7igudN+Ic6kbbbHJGj3jTC7mPEZ2U/W+WIRqC2BEzgU9uhgdUv2rCpca5MSPNlQDLdwotNKNnStQnLCZlL1JjuOKSIPb4ZxitBhNdciHvKA1dN+Ec6qaiSW4Pq1M311NvCFvC+OYeOK3Te0Wknljw=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 AM6SPR01MB0019.eurprd05.prod.outlook.com (20.177.39.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.15; Tue, 17 Mar 2020 12:43:54 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32%7]) with mapi id 15.20.2793.018; Tue, 17 Mar 2020
 12:43:54 +0000
References: <20200311173356.38181-1-petrm@mellanox.com> <20200314.210402.573725635566592048.davem@davemloft.net> <878sk0y3gk.fsf@mellanox.com> <20200316.145552.114479252418690423.davem@davemloft.net>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, mrv@mojatatu.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [PATCH net-next v2 0/6] RED: Introduce an ECN tail-dropping mode
In-reply-to: <20200316.145552.114479252418690423.davem@davemloft.net>
Date:   Tue, 17 Mar 2020 13:43:50 +0100
Message-ID: <87v9n3w3qx.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0094.eurprd02.prod.outlook.com
 (2603:10a6:208:154::35) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (213.220.234.169) by AM0PR02CA0094.eurprd02.prod.outlook.com (2603:10a6:208:154::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.21 via Frontend Transport; Tue, 17 Mar 2020 12:43:53 +0000
X-Originating-IP: [213.220.234.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 580dc756-944e-472d-7601-08d7ca70da0f
X-MS-TrafficTypeDiagnostic: AM6SPR01MB0019:|AM6SPR01MB0019:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6SPR01MB0019895DDBE2EA7C12E327BEDBF60@AM6SPR01MB0019.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:663;
X-Forefront-PRVS: 0345CFD558
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(136003)(376002)(346002)(39860400002)(199004)(107886003)(478600001)(316002)(86362001)(26005)(956004)(2616005)(186003)(4326008)(16526019)(6496006)(2906002)(52116002)(8936002)(6916009)(81166006)(81156014)(8676002)(6486002)(36756003)(4744005)(5660300002)(66556008)(66476007)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6SPR01MB0019;H:HE1PR05MB4746.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XESWnXjXdVD7zBVdi1BU5w44A2z49tUqkJO/MDXDjakzZcbg9yLCxLSSG57A28OiQr+464fr4wUzmGTImUVIJfn5En1jl59wqjQsRHL41Q/wVBGd2w8ZZ0Lli4xd/7sppRQ7WRnnBtq6JvbUPuC3TSQdn9wIWZPitNhBAakh830R0Qia0KzSOaaZ206w4Bi8r/5fz1m9UfGcJb6t6NRMr+/ttF2eABAVUaAARqoTnpVbv11WHHQXp7HWBWv9caFwv9elzPae1EZF2TpUvw+EhmQ1ELrRKUhtzKZMtUN5B0JEE31uVaTU8aTGh7enL4s3I7tpbK7tePZT1wUTFamccFH+84rKLnMF8kAZ9WLgqOFk5yIMXc3lCY7ORoIxfWn7KmjmVPJ/8tutwsTbkUq8ieUfeQrWSJLxFQU3tiFDVG+GJ1CzwE5jSzPR8yVzxfeQ
X-MS-Exchange-AntiSpam-MessageData: BX5Key14iwcoRbpH0R9apw6668NQaTCSu1/S9nMq9wxgvY43YiFYIsgTOvLaaKpESbbJHKOvUviWvcKMl1ACm4XyrtE1ZEIwflqeXPFawO4/TjtEpng3XiAhEqdI1ijRYQRyFsQ/48AhelrCNPg8zg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 580dc756-944e-472d-7601-08d7ca70da0f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2020 12:43:54.4416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wYcXWb4QgbiSbDrbuC2xQdEOF9KFB5gdSHaY0nBmh0RuDg8jD4l2aK8qnnWWylQqz9XrJhrggApf5O8YxIiwFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6SPR01MB0019
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


David Miller <davem@davemloft.net> writes:

> From: Petr Machata <petrm@mellanox.com>
> Date: Mon, 16 Mar 2020 11:54:51 +0100
>
>> Dave, there were v3 and v4 for this patchset as well. They had a
>> different subject, s/taildrop/nodrop/, hence the confusion I think.
>> Should I send a delta patch with just the changes, or do you want to
>> revert-and-reapply, or...?
>
> I prefer deltas, thank you.

Never mind, it's just the merge commit that contains v2, the actual
patches are v4.
