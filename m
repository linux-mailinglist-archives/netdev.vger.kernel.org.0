Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FEB22194E1
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 02:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbgGIANz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 20:13:55 -0400
Received: from mail-eopbgr70071.outbound.protection.outlook.com ([40.107.7.71]:6083
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725848AbgGIANy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 20:13:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fcclbIFKIEyItPw8gGWACNQ1Sownh0mwmB2czFaCCL8uj/JVZdZB7KXDweHie3MimOeQxWmVKWrRTNtDRsytg0UgJJutqa1le4KMX+Vz1C5Dc2vke95n77GRTbS99ARVJkSzkN0UiFkCp7R5ta8YDWo01jMx0MseFTcuLjVTmcxABQGdCM6dHJYi6u9KKkn/42YdLov0YakqHDtxYx94eyyTnPbUNneR315aN0L8khTyuqRMdTS1ikJasE3sYjWHVFn2zYNnSaMRBkI78WPwSgL9j6GFFMiDy24CW7AnQDyROtzchshIvKry65egw0JPcQxyGQjEFUpkdBI0o92Azw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZOxIBklG1kQXXdVsTTOCQnMlSnUoYjGKYA8Ka+im+Lk=;
 b=BlMNroQexyZJW8sx0BgEg3rJCbWdn3Nx4BCklouYCZfabZ+kE0DETViK9JdsCIx1MWQ2P3wI/I1WAZv2xZllDE5g6IT2Gj2RcOI9cK9ukKb0mR3QlEZJlBYV2plx9pdsCWcqAWEBiiZzJ8HN35/OzBf/bx1kzsf5v/8V3qOPTqDKVtUJx5YffKOEeoFEMyxynSHw3wbu3JOCaClTUBpTmVv8HCtKcHdLLcpp/TmbB6UxAwJskIVDZAQCNtA0Rkag2BI+yMd3wDPoDB8A//bsSx9n9Bvw93qvXAD9cYowbj0nFXyfLyhr13VzYneDNrbFSe4wcaMz8shDwoNSzuYhsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZOxIBklG1kQXXdVsTTOCQnMlSnUoYjGKYA8Ka+im+Lk=;
 b=hzeJoywe7u5Jx+y4O9izNf+lVsNzJ8Da91p9AQqOXaO1I1wbBFJdkHMyk663SON3p3pHDFakRKoC0cwC/CxeEU5vBdqqvHXRHOPUZqOUdeJmMAaTMj2mG52Apj8bt/CELQg4IM0YUSfC4RpG0and58BNjFmyWCEPXLJmNNMsSXo=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR0501MB2171.eurprd05.prod.outlook.com (2603:10a6:3:28::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.21; Thu, 9 Jul 2020 00:13:50 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3153.031; Thu, 9 Jul 2020
 00:13:50 +0000
References: <cover.1593209494.git.petrm@mellanox.com> <79417f27b7c57da5c0eb54bb6d074d3a472d9ebf.1593209494.git.petrm@mellanox.com> <CAM_iQpXvwPGz=kKBFKQAkoJ0hwijC9M03SV9arC++gYBAU5VKw@mail.gmail.com> <87a70bic3n.fsf@mellanox.com> <CAM_iQpWjod0oLew-jSN+KUXkoPYkJYWyePHsvLyW4f2JbYQFRw@mail.gmail.com> <873662i3rc.fsf@mellanox.com> <CAM_iQpVs_OEBw54qMhn7Tx6_YAGh5PMSApj=RrO0j6ThSXpkcg@mail.gmail.com> <87wo3dhg63.fsf@mellanox.com>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next v1 2/5] net: sched: Introduce helpers for qevent blocks
In-reply-to: <87wo3dhg63.fsf@mellanox.com>
Date:   Thu, 09 Jul 2020 02:13:47 +0200
Message-ID: <87v9ixh7es.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR07CA0017.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::30) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (89.176.246.183) by AM0PR07CA0017.eurprd07.prod.outlook.com (2603:10a6:208:ac::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.8 via Frontend Transport; Thu, 9 Jul 2020 00:13:49 +0000
X-Originating-IP: [89.176.246.183]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 06d1f569-207d-437d-b6a9-08d8239cf4c2
X-MS-TrafficTypeDiagnostic: HE1PR0501MB2171:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR0501MB21716C11BEBC0D17F1C07691DB640@HE1PR0501MB2171.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5+0BvhmLvZ/e5Ew30P8Nyh8KYcBU+VU4phoFuscIpUJQ3L+lyQxlDBUIU8XXgM7zrWy6v6jK6PqUtdNDrmaW+QzSuoWSyJwUtcnlzXWwVB0UcY9pVv2bgum9aYHpvCDrmCWH1C52vgRE7cCU4xMHxL1SpNThF821B1KsuvY4BJRpVi5FsG7jJqRwGvDxCnCIcdGcyDdwBec0vqme+vKwXFEIzrY1fDrOb0tmwejzBEj2nlVTto8IA85PaSBO3i4ABHb7zlkTq8sI+7COt8ZeaozCGwAUT/NFqeQbh9qz7ezbC+VYziNqbgGswvT9nn1K
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(376002)(136003)(366004)(39860400002)(186003)(66476007)(16526019)(66556008)(107886003)(4744005)(52116002)(6486002)(36756003)(6916009)(86362001)(66946007)(4326008)(6496006)(5660300002)(2616005)(26005)(2906002)(8936002)(83380400001)(956004)(316002)(54906003)(478600001)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: AYhNAuPA4xOqXaS75eLrO7fRCHXrDkUsUIbwnV+AEZ05k/s9Ph0uzTacaJRctTj7LFeSFZMz3l9si/3j7sCMv2rqZtwbcgwWuSj6duPtKh96nWeRVt75xjGtTqu+JwC2mB9g9ZxHBqyG6RgWyFfR3DuC6DVpurwriCYn9ELu10KD46wo4nVLtfc6O+XjplpvDcdKZdih1ivsGDZPYr3ZGiIsw3hp4x6xhAYnq7/70bBTQD0X1urVmhHOFy9GA1FTE6qUapBCfcQH+DbaBNZn3b4f70Eviy/e9hF+sLqQiGedGmzJ+CU8WkjLEa0/WCm0VieVRsYw5e66Nv5Ro1q9yaEjSqXydPxQEphYMcbq01Cf61QVbpw/1PXC4IsE4cj8c3ALEzHNcvVvVLVaDLe1FaGkZ37c9OxPlZT8+oGYK0RhFOriLNu0SzGakLEDb8va9JBCkXbBd1FbAPzf6jtw378LeQzupYw0nESR6dDv7MRR9mpZq4rmBcJ5Sqc41Iuc
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06d1f569-207d-437d-b6a9-08d8239cf4c2
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2020 00:13:50.3945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vMzc5nRxOc9+4xtNdKwkB2RcXY5v4zTfqLJ+eeZcf7zkK6Rl4ihmfZIr/dBomn8HhggS16cv7B2CaVRaahPFAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0501MB2171
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Petr Machata <petrm@mellanox.com> writes:

> Cong Wang <xiyou.wangcong@gmail.com> writes:
>
> I'll think about it some more. For now I will at least fix the lack of
> locking.

I guess I could store smp_processor_id() that acquired the lock in
struct qdisc_skb_head. Do a trylock instead of lock, and on fail check
the stored value. I'll need to be careful about the race between
unsuccessful trylock and the test, and about making sure CPU ID doesn't
change after it is read. I'll probe this tomorrow.
