Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84F77200884
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 14:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732907AbgFSMSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 08:18:04 -0400
Received: from mail-eopbgr80071.outbound.protection.outlook.com ([40.107.8.71]:13793
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728712AbgFSMSA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jun 2020 08:18:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QXMerSGxqgSi5scK88S6MhazvOLNDre+4VYQc87HGhs/EfWnppZByA5dd1cUbSnwkRvpHOAKrJLYJEWmfBN2YRinIbDzf13L0nndwAyZwOCTdFbdkHVZUHs0UdLySzpumhTbe1a/7BMS7WvhkvhJBz5p98+79vjHBd0+aq3MzmEje6umZICpPHLtw/NMvY6Z5EieVsuMf+SKj8BZ4LlFRKJqhowXbicZdemb/rkNQ/s9iEbWEK06/RRh8ogtfVXf1eVgnkZdmbqalj59GM5UE2oyO3L4/iymvAajunaaWK1j21Jq5uJHSc1t70t5kzzLYsdM7V+cN2L4Bynz60iMjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gb/1za/q03HvKoD96QnPKcDsnXBqZffU3wRZFo5M72A=;
 b=G4Rs3MEa+Thd5c75D81bino16U80Icc2guRQzdiFKrB81/Xzq2ScbFjQomSIa59iNdMIVfcVC05vKaKWyb1hiVgk4Gj7Ai4SKyytSRrmXhjXAg3EncW7ANuJhZvrqg6fjpEMndYUkvelrE+dLtVSTPOibkHn+mglUvH1BU/vfsPDa0xwbG37Dboqtr/qUc5UsfsSI4HJ5ct2t1LI77d/7SBs0MMy6jXmJeEoAeO6aVu8dw0ZIyjFvy3Q7/OcR9yxtwrPvSSnIrKE44cF9xUY2weF13+Gq/10yCBDHYvXFn0+sl5fY5PDtCbLx7DE5/EY8QlGVakInIJ4Ll+j/f6oyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gb/1za/q03HvKoD96QnPKcDsnXBqZffU3wRZFo5M72A=;
 b=BbFSgQ8xo5P/4jbEQFgHrGVwBEzDwAe3jr8kAHmz9hA9QrCn+9LmglWMWLN/7sq0E716HW+0v0Lk87Npwszr0xPQP3BvW3qv/6TH5aa5Dof+8tzMu6TGdZFLT+4Gym6yVWcuNSm9jS0sK5gqS6N0/ArV63GkCvsREk/QmlIO6xM=
Authentication-Results: windriver.com; dkim=none (message not signed)
 header.d=none;windriver.com; dmarc=none action=none header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB4586.eurprd05.prod.outlook.com (2603:10a6:7:99::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3109.22; Fri, 19 Jun 2020 12:17:55 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::9de2:ec4b:e521:eece]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::9de2:ec4b:e521:eece%5]) with mapi id 15.20.3088.029; Fri, 19 Jun 2020
 12:17:55 +0000
References: <00000000000086d87305801011c4@google.com> <000000000000320bcb05a863a04c@google.com>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     syzbot <syzbot+c58fa3b1231d2ea0c4d3@syzkaller.appspotmail.com>
Cc:     amitc@mellanox.com, andy.shevchenko@gmail.com,
        bgolaszewski@baylibre.com, bp@alien8.de, davem@davemloft.net,
        douly.fnst@cn.fujitsu.com, hpa@zytor.com, idosch@mellanox.com,
        jon.maloy@ericsson.com, konrad.wilk@oracle.com,
        len.brown@intel.com, linus.walleij@linaro.org,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, netdev@vger.kernel.org, puwen@hygon.cn,
        rppt@linux.vnet.ibm.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, tipc-discussion@lists.sourceforge.net,
        x86@kernel.org, ying.xue@windriver.com
Subject: Re: general protection fault in __bfs (2)
In-reply-to: <000000000000320bcb05a863a04c@google.com>
Date:   Fri, 19 Jun 2020 14:17:51 +0200
Message-ID: <87wo43jllc.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0027.eurprd04.prod.outlook.com
 (2603:10a6:208:122::40) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (213.220.234.169) by AM0PR04CA0027.eurprd04.prod.outlook.com (2603:10a6:208:122::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Fri, 19 Jun 2020 12:17:53 +0000
X-Originating-IP: [213.220.234.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: afa3603f-dba0-499e-5d3d-08d8144acb95
X-MS-TrafficTypeDiagnostic: HE1PR05MB4586:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB4586D93168C268FC4C099786DB980@HE1PR05MB4586.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:404;
X-Forefront-PRVS: 0439571D1D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +fg9RBaRuoNbGnbNpgvaPuPLUd0YeelsuIXxdZInV0zY72XKnEH1vtPjISiTR14emX/Vq/v73VCfYE0HJGGXYbQvyc61nXaEPXxWxCAKyULFI3ACMXsZ3oHFphKl/4ES17Y5pJd8pPnQ2prkStfMzC9RJk+yn2qse2KJQ2vYSf2b8iJhiuLWi7dhRYyNaWPBka+cnC/BDuVKZ+ETSkpWrTmxH71TM3cihz8V1ECGp5xQyNnowMenj/XgFXM0aV6E1Xi5C3FWHvRB9Vog68JgYuCPAlcGWESAFPMy4vRjnAvE/ob4tHrRkH4FnySG1g/pqMdu5UuTWhrMaYBU8wCszw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(39860400002)(366004)(376002)(136003)(396003)(4744005)(478600001)(52116002)(5660300002)(66556008)(66476007)(86362001)(316002)(66946007)(7416002)(6496006)(6486002)(16526019)(186003)(26005)(4326008)(8676002)(2906002)(8936002)(2616005)(956004)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: q4Hfn4idkjXoc+ZG+txbyFtV7QTmzDhLgiE63CsNeQty3uP/5gAwsG1/pZXLYIVREv8ubIOMRtgaMh4hsNu71n/j0D7ycPk/eur4rUd9whHi5P1ghC8RlX2m4H9bNPY8GeGh2XZs1yZz4ygDJF7oj6lqBa5njfELKGf0VRLf+iDXWHcfe+96pDun5NdMpl8j8PDBJwqWdD+MLLVNrsYjo2ufYcE3dX1kKs4omZr7fOWhoSV5Zc9CRBX5eaDs8TRsrf8fISXHPOUz6TkDJF7hhyCAn93F7d/sDGd383vNkwtLjJkvDiXrO7aUzFkIONqSZpJWjfEHkEfUCsyLyMLH0ThBoFacTwNR641WADHZtqf4Z5c3uvno9eRHZ8IXq+sGBuY8dUyqMYSJm2X4FllXY/v2NTDlmGo1gqIyembpKiPrlj6piVjibu+PEbJ8J2lOWnnPpkA2aKj65nxG7CPF4+SKg4/7KaEHNiVwIevqmsY=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afa3603f-dba0-499e-5d3d-08d8144acb95
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2020 12:17:55.2441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KhbgpnuZWCDxGR3hqwbJZLfsRfQwjZDKgCGAkWgWc8clqhPr3NIX9RrkoyBprPJZS3cylrn778Od8rMk+CdwqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB4586
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


syzbot <syzbot+c58fa3b1231d2ea0c4d3@syzkaller.appspotmail.com> writes:

> syzbot suspects this bug was fixed by commit:
>
> commit 46ca11177ed593f39d534f8d2c74ec5344e90c11
> Author: Amit Cohen <amitc@mellanox.com>
> Date:   Thu May 21 12:11:45 2020 +0000
>
>     selftests: mlxsw: qos_mc_aware: Specify arping timeout as an integer

That does not sound right. The referenced commit is a shell script fix.
