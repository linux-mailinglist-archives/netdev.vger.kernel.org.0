Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 001FB1EE1AE
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 11:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728293AbgFDJoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 05:44:22 -0400
Received: from mail-eopbgr80070.outbound.protection.outlook.com ([40.107.8.70]:32069
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727993AbgFDJoV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jun 2020 05:44:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MEntRKTtU4RDEvLcz0V8WJ3gx6f4pN1QInbl1fNqaU4mRvJZUnby3hiygQ+WpjqQnXCqVjnn56x6qBjlaelJeyTcyiQelIbZZCxk+5dYWIbnR6oFGvZ3zWoztmtcA8npyqRflglG+pL2bvEYLoPoxPzr03SwBiSsbQVnc8wniUOHrMnwjVV1PFOSpAT8EhlA8piAVK41mRWcWXOeVAqma6RWNvHdNg36HUQmXynLR7+akqvmkPVlADfeP9LaJFo96Sp8owIrT7JoqmBLAR8vEnmxAnXtSxxVt+gOZGFvnrhAQ8SwTB5uYaRv+JxT2hIEESggtJ5voIBs8RPgh17rtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xseet1s/1TLnEX3HIDo7uD87CkPQfStINF8f5TcsVK4=;
 b=b55PJ0T+TS2YfYjdjajthOXfN0TL/K+pZe8Se8rRbTXTb2AqBTEyBwTNQM/owyjH5L9/6Juz8JAzonWx/m21f9GVj6rhNs9cNEfRMUMhyaFo8Uh/OC29d4BuOfttpGO1lE09M60W6VE4Jccg8ZpwZy3onrzsyrrakLEMmsWzO2aNfTmf4O6fUF6IduNmKkLe271amPUv6t+H0B0tlCggGN9pNN/P/4/F/z6p3QB3Xe/1Ke84aiPYSVmHtHulaHHbPN3r3SXLxDmX6aTOInOPQCwswNTVeaML6Z5iDj1LtDKZqYwn3QMUdZW26ORMQdh253shmAy7XFvliI8g9iUmMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xseet1s/1TLnEX3HIDo7uD87CkPQfStINF8f5TcsVK4=;
 b=gasFy8DPW93oXDnQXS1t3ennRKaARxYHrInkZpovKakxwGatiSi3nbJMl3UCMG2skpYuB/hhxNa3yqUUO/dJ/ruQjMXyURU3tjOtMFX2UWK6Sc0EaTg/QqY7d1gc/xtrNETBxtOK6DLCSyyEMgWlWLtXkczTy0IIB9oz6kWYig4=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3177.eurprd05.prod.outlook.com (2603:10a6:7:36::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3045.19; Thu, 4 Jun 2020 09:44:12 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::9de2:ec4b:e521:eece]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::9de2:ec4b:e521:eece%5]) with mapi id 15.20.3066.018; Thu, 4 Jun 2020
 09:44:12 +0000
References: <20200602113119.36665-1-danieller@mellanox.com> <20200602113119.36665-9-danieller@mellanox.com> <619b71e5-57c2-0368-f1b6-8b052819cd22@gmail.com> <20200603201638.608cfdb0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <0a5ac09d-ea4d-fddf-fc58-9a42b7e086f8@gmail.com>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Danielle Ratson <danieller@mellanox.com>,
        netdev@vger.kernel.org, davem@davemloft.net,
        michael.chan@broadcom.com, jeffrey.t.kirsher@intel.com,
        saeedm@mellanox.com, leon@kernel.org, jiri@mellanox.com,
        idosch@mellanox.com, snelson@pensando.io, drivers@pensando.io,
        andrew@lunn.ch, vivien.didelot@gmail.com, mlxsw@mellanox.com
Subject: Re: [RFC PATCH net-next 8/8] selftests: net: Add port split test
In-reply-to: <0a5ac09d-ea4d-fddf-fc58-9a42b7e086f8@gmail.com>
Date:   Thu, 04 Jun 2020 11:44:09 +0200
Message-ID: <877dwn2mja.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR05CA0073.eurprd05.prod.outlook.com
 (2603:10a6:208:136::13) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (213.220.234.169) by AM0PR05CA0073.eurprd05.prod.outlook.com (2603:10a6:208:136::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18 via Frontend Transport; Thu, 4 Jun 2020 09:44:11 +0000
X-Originating-IP: [213.220.234.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2a43eb58-2723-4afa-ebaa-08d8086bd60c
X-MS-TrafficTypeDiagnostic: HE1PR05MB3177:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3177D25FF485C4F362356731DB890@HE1PR05MB3177.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 04244E0DC5
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bpLCRCgdBZbGWgLoZ2j4qU4E/OIbyL3RTe1L9Jo5g7LE/CULRqVjAeM0M7EYIVEtuTSZNHUrx/hhaJavoRwWNX6M9Afx7V9TdIJRlgF7SBAW3zan4DeFjPzKHGJ0QUzpFPl37CBOTNrpDNRXaMvDd3WBwNlpv4FAUYGua0juxxUGNHtw0W6AoOi2CjQ7D8QUYDY4hMGsTAbnhyiod1jR0ncP1AMyzRVCymhNVhrfKtlS0I8/sgYB4N1HRT/2hJ7ExouRw9im3dhIaRVZlKIpE8Ljt/WV8Ewh8vIELeJoVlV73VzVuxyYZ7UZQsSkSlGurZLfC8bWnNavC8ZsmRcE7Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(136003)(376002)(346002)(39860400002)(396003)(316002)(2616005)(6496006)(8676002)(478600001)(8936002)(107886003)(956004)(52116002)(2906002)(5660300002)(6486002)(66556008)(6916009)(66476007)(7416002)(66946007)(54906003)(26005)(36756003)(186003)(4744005)(16526019)(86362001)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: phcZ0zyN7AZHOgtymAJjblLWUyu4swtbD0LfZAosqgE1OFNqqVaJEgxYm6UX3/TN3wQ3aMI2BpQEGcdAzEQ7zhOJypWlbHpzB9HfolhcI8Ra2yw7wr88Va9y0n2+CyJZ13fUY3+XhRK1nSxbrnObAZ/dSvGtJ6v6YLmR1lc+9CQ8oOER9t9ktdj5ssqgeN+FXYfsw861OCGHKVkwdp3cbCMpqIZyftXggnqxpsleNhawA/ZgXKVBRCLUdFKdvZEaklQ8eiOM990XzBug0m0GZt06+2yU52LduJ50XknG98k2aeNDxwPk9iDRnmfI7k5hr6YI7oDkt7+90A49t+/LXQhZDBQ2EQPku1bTnEEeOkA1lZLFWb3lceBn1WQf2ZO6pq+GNtBi0g753lZllQL+rPlbb43YOe9GpVKudwzsn5JbyccXiMynMt9TFZCrcypauetklTpxdkqBBbFdwQu8gptim0XOB8Ds9et23SofJc9lu5GWGQ+jWYhlfZLvk9DL
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a43eb58-2723-4afa-ebaa-08d8086bd60c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2020 09:44:12.2007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aGgc1df5cEUaWDeoYt0qYKwuNWwzmWnIv49gBvYyQsA/T1Oi8eQwgDwFLeiHFz4mEPZiIoKHVmuul+mqelyILA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3177
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Florian Fainelli <f.fainelli@gmail.com> writes:

> In general there appears to be no direction from kernel maintainers
> about what scripting language is acceptable for writing selftests. My
> concern over time is that if we all let our preferences pick a scripting
> language, we could make it harder for people to actually run these tests
> when running non mainstream systems and we could start requiring more
> and more interpreters or runtime environments over time.

You make it sound as if we pushed like Ruby or SBCL or S-Lang, or some
craziness like that. Python is a conservative choice in the Linux
kernel. Not as conservative as Bash or C, but still conservative, Python
is used quite a bit, even for selftests (TDC!).
