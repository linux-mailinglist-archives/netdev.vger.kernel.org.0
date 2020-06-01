Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A91E1EB1C8
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 00:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728546AbgFAWhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 18:37:34 -0400
Received: from mail-vi1eur05on2043.outbound.protection.outlook.com ([40.107.21.43]:6047
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725800AbgFAWhe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jun 2020 18:37:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YCzG+L2KBHckmU9acaVKHZRWBYt8dUH4VVngAJwk7Q9OdaoQ/HjPPuja3gApDDKDOWUBZ2rThoDgaSD61fNK2LrIZx9tPGRqpYZGqwdEscX8Xu2EBFNO1FMAp2bcRajWiV6860f2EBDwo5yo40ejDB4VAeZ8fD66HWiXaROr++IzFhtc4bQ4XozcjoA8X1Fca7BhrzePH9rL93D6/nBybDU3sxyGJs5sH51YrqDeQkK3+uEHrhzN9k71B2llHkEqP2wcP8YYfR5Gb1xjckbJY8wDomFIL7RuW215Nsily5NsZRz0RDAcv7H4P/q+k973W+F/DWsP8iZW2GgIjZxXpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nW6hWJv5pwXOyslbTc8DP0kIs6HyAkrLp3y2v7W/I5Y=;
 b=Tzh9lqcN9g9U5Dy+mDDP2sndl9b6qG8zwW+ShcigXGOgMNINJUqYD1xcLm3luwUnO/hbOpBc1SAS+Zu7sSD/mnmjQewpT2c5alAzPYbTIZkdkRHhvptK/Iz35cLQR1n0BkJXcb87N+hJbi68RIpyVhRJ8BXNmX2717ERRgPVM3z1n+PKYZdJRp/Ug3YQoeiOVpbWF/4X/3ilhlsGTX1dpsfzyLVcEH2qkCU1oo0zbBp7pUdtMyX1CPvLy2/ezVkSsvln/tBUNuMxQP5UIHxCWY1IvLP30tulnNbllTz3nKbH2LBIe97boC5NpXk0obyIZIs8W5TU8oZCIC6wI4fPvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nW6hWJv5pwXOyslbTc8DP0kIs6HyAkrLp3y2v7W/I5Y=;
 b=fG7KLD3lKAVvLrAa55nbcAjUlZQmy7RkafWXwOilDYFA3XBA9ATojAPR7z0sDvgocy7G02eC6ue1qvB9HeiI421JqSDEWvX3S2mI31sGEvHz6uthJZvZOfDHpSCcybyRf9uaaITrVMN4pXxiQ4YeKEnD+lJ/2ws6ZB7C1Qv9gzc=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB4729.eurprd05.prod.outlook.com (2603:10a6:7:97::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3045.22; Mon, 1 Jun 2020 22:37:30 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::9de2:ec4b:e521:eece]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::9de2:ec4b:e521:eece%5]) with mapi id 15.20.3045.022; Mon, 1 Jun 2020
 22:37:29 +0000
References: <cover.1590512901.git.petrm@mellanox.com> <CAM_iQpW8NcZy=ayJ49iY-pCix+HFusTfoOpoD_oMOR6+LeGy1g@mail.gmail.com> <20200601134023.GQ2282@nanopsycho> <CAM_iQpXTWK+-_42CsVsL==XOSZO1tGeSDCz=BkgAaRsJvZL6TQ@mail.gmail.com>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [RFC PATCH net-next 0/3] TC: Introduce qevents
In-reply-to: <CAM_iQpXTWK+-_42CsVsL==XOSZO1tGeSDCz=BkgAaRsJvZL6TQ@mail.gmail.com>
Date:   Tue, 02 Jun 2020 00:37:25 +0200
Message-ID: <87d06itntm.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR07CA0018.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::31) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (89.176.246.183) by AM0PR07CA0018.eurprd07.prod.outlook.com (2603:10a6:208:ac::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.7 via Frontend Transport; Mon, 1 Jun 2020 22:37:28 +0000
X-Originating-IP: [89.176.246.183]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bb1f1b1d-2244-4368-2884-08d8067c5da0
X-MS-TrafficTypeDiagnostic: HE1PR05MB4729:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB472975491E8CB6BB0B8C34BFDB8A0@HE1PR05MB4729.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 0421BF7135
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o24Yqjd2DPg5kpiodjQ/pENKMMhiBcoX9XMJOOLtnjwcT/sAiEojAs2W2q2xLzTxqPZpN2RjHwKEi7iR6D6YEexa9EPsYsV/VXWIWcdiR0pJcVzGVJ9oUOJeZIW8lfQ8QKGSVf8pL4kFFoyBpa/rQjMur4oDC+1N7tMK1g/0kpa62rqcq51r4uQunXMybPdrl5mC65ZxX/Oy4y7KxlBYDnnvptiK8ol5rdVdUQc1AWuNlS26gTnNlFOZo0Dv6c6PuPVecr1Wybt2oET1jobMRNVH8r5em4OqKn/gNwulW1hDQoWasxmfc22rBuRrN6FT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(39860400002)(366004)(136003)(396003)(956004)(2906002)(4326008)(86362001)(2616005)(478600001)(36756003)(66476007)(66946007)(26005)(8676002)(52116002)(8936002)(53546011)(6916009)(6666004)(6496006)(107886003)(316002)(83380400001)(4744005)(186003)(6486002)(16526019)(66556008)(5660300002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: HDKz4+c/TJt9+4EmwE9qmx1DY5Mur1qxPAT8DSe1oHPF26IzphsuZLX6nG4p/jGe4Z4Y1RpsR2hXG3uerMFOkw7K8ajA2roqgfebOB+6TzYAQYpx1U6KcVDdqabJ6oQP7oc5y6gHwJMUJ4ifQ86FPullCQxNrVrZZWPfxjrURhQASzEh0OXrwzgBWKXzMcm3S7VxCFggLDdgCbfo73V6ht0ZSwfF4eYZCZmd11/mHo5cOSoPU3BujCSKb308V1DEXts8v0VTjnjPdgb/9HUzFHYDFodhwVz6vCaGUGTv7NAU7tGYWK9RIBnem3LelGNCFBSORh2GskyWvJ+U8EY82zsQcGQiuVDOoFQ7sTApeblixoGQ1nQlXo5jgFfvH3w/cjyq2JbNUJOezPKYV9jplBA6K0fZgpXW+Nf7amv3jHHf5ZDZ4d6NPKYxBS1Punzt7IQaWhSq++4/eKykiuFWXW6VbMH7by60AJmh9CmhRSg=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb1f1b1d-2244-4368-2884-08d8067c5da0
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2020 22:37:29.2252
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FJmb4Stvvk8S11Q7IAqZBATiOx5NNenAFKK4bcHGinC1cP5x2DQaffwSseE5r4olZAV60RCp5tvBpCs3E2jEZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB4729
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Cong Wang <xiyou.wangcong@gmail.com> writes:

> On Mon, Jun 1, 2020 at 6:40 AM Jiri Pirko <jiri@resnulli.us> wrote:
>> The first command just says "early drop position should be processed by
>> block 10"
>>
>> The second command just adds a filter to the block 10.

> This is exactly why it looks odd to me, because it _reads_ like
> 'tc qdisc' creates the block to hold tc filters... I think tc filters should
> create whatever placeholder for themselves.

Look at clsact. It creates blocks in exactly the same way.

> I know in memory block (or chain or filters) are stored in qdisc, but
> it is still different to me who initiates the creation.

The block binding mechanics are not new. The patch just reuses them. If
you are unhappy about how this is currently done, I too would see merit
in creating a block explicitly, like with chains. But it has nothing to
do with this patchset, which would just naturally pick up whatever this
new mechanic is.
