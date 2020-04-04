Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B928819E7D0
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 23:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbgDDV4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Apr 2020 17:56:12 -0400
Received: from mail-eopbgr00054.outbound.protection.outlook.com ([40.107.0.54]:12538
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726307AbgDDV4M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Apr 2020 17:56:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eJ3y1qEO200piA1pB18n1Sg6pQDQbkQM8KkcPecIgVLLlA4WFZfwLzD/eTEK715qNXGUBwphYZbgjhuc0fvotKkiL9Diwu9+wtDtpAEvn4GHahindt/gJ5fPOq17jDCthhiTJ+3NL+Plg5ks5m1CBlEG7O3NVSF+TdBJSD24WKsZstdOBHQwKCBjaFCdL5KTpUu3lGwqXEc95wPmKcuCzi8ZAEmV7qb7HRHPmEGeYZ0xTd7cfnLSMiYH365ldIOnmac099DzzKmL8GOquL/D4iliDL1Z5qTpnw60q+3zGQ6U9tEmeKVExZbI9eBVVr8NgWnx0SrPz5qA8+j+U5XM4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/lxG8pHP+BHIkQo4zemFB7lJJmlDNEYdR7sWUzx62jk=;
 b=nL3cl6xvHuLvZJfl35VuDeOOdQtl5+8hcJyWcG4HnyTo3q1FwRbHmlPyzSCukof2D1u77D/rk1nGyBtdJg6UA46re79ZdHdOrwzAPeCbnGeX3B4koGnQ4I464T6Q66JpWDRAAZdUSJ9HrO8iCp8y2cdkPB/FhyfMzh34SqivDGBvc4fiQf0+Nf7AaJsTqbOc4rNk0atOT9xkp7V2c7pufqafP9uot8iXLcezjnRDGxiDZddmJjtyK3Z7+u5aZGON8BdDColF2vCSSkkc93Ap12Ka0Z3EtQ+BgR2tRVeEgRIzLXinPQNkw2YdbohJ3BSj6TA4/IjM00fhrxvL8vVaAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/lxG8pHP+BHIkQo4zemFB7lJJmlDNEYdR7sWUzx62jk=;
 b=tNBX1Ppqzp+PM9Whwwu5NC4tRFtcIYNZRZnqjUuQvnRjMX6zo/yOMf2luFMt4+EvFrgEi7PlFYGKR+EuB/Z//ioTOnjnTgR6w5cBEN3vWR8pb4B+OzX5xPAcZZkHLK9UFuCNxUjm4EV5NMzjWBWf1J9Gl9ob7mPsy72kgM9QlTs=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 AM6SPR01MB0055.eurprd05.prod.outlook.com (2603:10a6:20b:1b::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.15; Sat, 4 Apr
 2020 21:56:09 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b%6]) with mapi id 15.20.2878.018; Sat, 4 Apr 2020
 21:56:09 +0000
References: <20200403130010.2471710-1-idosch@idosch.org> <20200403130010.2471710-2-idosch@idosch.org> <20200403.161332.275661443627820251.davem@davemloft.net>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     David Miller <davem@davemloft.net>
Cc:     idosch@idosch.org, netdev@vger.kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net 1/2] mlxsw: spectrum_flower: Do not stop at FLOW_ACTION_PRIORITY
In-reply-to: <20200403.161332.275661443627820251.davem@davemloft.net>
Date:   Sat, 04 Apr 2020 23:56:06 +0200
Message-ID: <87tv1yewzt.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0082.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::23) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (89.176.246.183) by AM0PR01CA0082.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.15 via Frontend Transport; Sat, 4 Apr 2020 21:56:08 +0000
X-Originating-IP: [89.176.246.183]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b70db201-b4dc-402b-cb2b-08d7d8e2fb5a
X-MS-TrafficTypeDiagnostic: AM6SPR01MB0055:|AM6SPR01MB0055:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6SPR01MB0055ACF9797D469D90FD5E40DBC40@AM6SPR01MB0055.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:534;
X-Forefront-PRVS: 03630A6A4A
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(376002)(346002)(39850400004)(366004)(396003)(136003)(81166006)(66946007)(4744005)(8936002)(36756003)(66556008)(66476007)(6486002)(8676002)(316002)(6496006)(52116002)(81156014)(478600001)(186003)(6916009)(956004)(5660300002)(2906002)(107886003)(26005)(16526019)(4326008)(86362001)(2616005);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QDsR1Q2FWximdHmlRGb319Tg4DZkXtfKjS/vjXSRVml9yjEeC/2FmZsRCT0JZ9iVVNfbmfGc/35U2okyeBFwV9oH9IqRwBtBDdW7YI3NVz/5QuCZsyhsu9nrDjdP526WJBcNUtLvTmwjpEYVjYHiKGClc5tcqZOh/yudqFmLMLfOGyzrSFl2l+X49ASrTVviBxh4kGMB0r3VXedPZ2Zw1R9VqEjkKmLsoD1PfAkcSySpIgF3UYKWllXmmm+pv9M3ft5wOmJvwYvjmyG1l3iWF6kutNcR4Btq6GfaePesWFtJ2Q6KtIyWC8mrgGNRondqRN76hOmGEuGRnfINhSOO9oMC0gsg399o89jHLdZa/M3ocv35/t9FzTSzkHScKVhrOk95XNlVD2lU7rsY/9AFiJvJJQxpLHwenvzQsXANpXHuBHnhtQ3SjWBVnukIb1rk
X-MS-Exchange-AntiSpam-MessageData: Llslr1An94ikiPMbyO5FnSGcXnOSac8mvMOFn8BNVpEIkj1Uv/9mqTUWV51OJymnm/+LgJYey1ieg97G3r/dFZNlJAVlsqn/p+aWFafc+Q/Nnssh/ubcLGG5ZS6ohClxm6GWjGc1WRi4FaEXcqB3wg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b70db201-b4dc-402b-cb2b-08d7d8e2fb5a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2020 21:56:08.9463
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zAlNb7ZkhX/ofWXm2JjVBn/tqgtFKbOYykvm4wvd6BkbAFlTm5eDNns7NqqZRV7XQhX7SWme9ihliSba/SMEdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6SPR01MB0055
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


David Miller <davem@davemloft.net> writes:

> From: Ido Schimmel <idosch@idosch.org>
> Date: Fri,  3 Apr 2020 16:00:09 +0300
>
>> Fixes: cc2c43406163 ("mlxsw: spectrum_flower: Offload FLOW_ACTION_PRIORITY")
>
> This is not a valid SHA1 ID.

Sorry about it, I must have referred to a commit in my tree by mistake.
The correct SHA1 is 463957e3fbab. I'll respin the patchset.
