Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1CD2183B45
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 22:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbgCLVZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 17:25:15 -0400
Received: from mail-eopbgr60084.outbound.protection.outlook.com ([40.107.6.84]:16033
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726442AbgCLVZO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 17:25:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TPt7NB+GKJIMbZHZCVTPrmYNfAB7+PVWeLzjYxGz5fb7aR5rLuVGY06JGDJiunvkn0+Gagw0JiBpFe2d1Q3EWrARDy324YYXAOGGNL2FfqfRLpbY+r0nD1a1N87tECPOsI3iGb4sFFEs14ep72NOr6mRHBDz18VLc/ihDO8zPeO1yHo5CKR4vUbH7MVsGX0OIIa2CNpQ5mWhaAGTnDL+YI6pv8bxVuWJTU9U21k2t8ReaAB7gatNT7vFk8/TyPWIzAAS8Oh62HRZY9XmFD5fka8jhS3dV+M2xN8Wbhcy1U3kb1qHQOWhH8PCCKT+5zGV1FiWbYr/r1DgwAHLbi8weA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wEWZ+Smv0SAwdzD8p7PO1AUKJkr53YcTQ+FPyVTTWAs=;
 b=MU+scRKUBNymVVDl9sF9yoBHBqxHLFwuGAxdKr+N+tg3Y3n7u4V8xK+YFv0HElEPTYnTp5NXmGbzWjxiRf4FAociKxf8f4tM7d2s5ziEQnnOvF8UM6ahQgdfapxz2rLYP/fwofomF/rf5VRSIbcnaeHhY0UzQr66PH1RJ6AkqLfYqHHJEuKRdI2CvQZ2K7XdeXKYhrNFmqPLNdf/eKRruqjiIqRUrxr3tfZ8cs8DvvT7ZFBslrzM+u8GwWIastjOFPo2cdJq3NrBioViBfXmBjmvNI1NsUydn5uK9DG0+OmGAaiK5PH35UHWssIApj/ArAFBnoFuhPkWk1zy14o9TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wEWZ+Smv0SAwdzD8p7PO1AUKJkr53YcTQ+FPyVTTWAs=;
 b=COsw1LCqq9Cj99RNfZuBNbmQjEjKdo0DoBrUdKVAe0yUghBjV0CGCYp358pQ2Iwshwl4Q1HWhVfvTNpJJw7eGacEvdsbTkaprw32A0EtOxthA54TvzNqneyE9mINGlVm8pLNmG1a15LxOEVNJ8RuIrQ3KOwBm46SU16vMNWA/OA=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 HE1PR05MB4668.eurprd05.prod.outlook.com (20.176.163.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.13; Thu, 12 Mar 2020 21:25:10 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32%7]) with mapi id 15.20.2793.018; Thu, 12 Mar 2020
 21:25:10 +0000
References: <20200312180507.6763-1-petrm@mellanox.com> <20200312180507.6763-3-petrm@mellanox.com> <20200312134300.219924b8@kicinski-fedora-PC1C0HJN>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roman Mashak <mrv@mojatatu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, davem@davemloft.net, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [PATCH net-next v3 2/6] net: sched: Allow extending set of supported RED flags
In-reply-to: <20200312134300.219924b8@kicinski-fedora-PC1C0HJN>
Date:   Thu, 12 Mar 2020 22:25:07 +0100
Message-ID: <87d09hxo3w.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM3PR04CA0136.eurprd04.prod.outlook.com (2603:10a6:207::20)
 To HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (89.176.246.183) by AM3PR04CA0136.eurprd04.prod.outlook.com (2603:10a6:207::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.20 via Frontend Transport; Thu, 12 Mar 2020 21:25:09 +0000
X-Originating-IP: [89.176.246.183]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 01141bfd-04fb-49eb-6b87-08d7c6cbd7f9
X-MS-TrafficTypeDiagnostic: HE1PR05MB4668:|HE1PR05MB4668:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB466885D7ECA15AACC2799D4FDBFD0@HE1PR05MB4668.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1169;
X-Forefront-PRVS: 0340850FCD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(376002)(366004)(136003)(39860400002)(199004)(54906003)(81166006)(2906002)(107886003)(956004)(316002)(6916009)(6486002)(52116002)(6496006)(4326008)(5660300002)(8936002)(478600001)(36756003)(26005)(2616005)(86362001)(16526019)(81156014)(66556008)(66476007)(4744005)(66946007)(186003)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR05MB4668;H:HE1PR05MB4746.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3x5EbJxKQoEyUXU1remMnuaaEjb0DehdN29aqDaDfDIDcHZiVGFBCA968IR/jCNePKWnZMvFJa0Rwwvu9w9OZxzg4B4Lq8ncpViJ0JvumQKf3kCLYLd4dGo3Q4ugMp2KA21VYncidcuu3YXAYclma1+R7mYUBEwIxkWGhGlbySDcwAPHpiYHqzBEX7WuRzG6ZSykvLHA0c8TQErfA1jpjb7FPvprZ5G2otm3bsUNvNTsBL37K2VrGlghQXnW+zgWb1HI/Hus8Ia/b8nYicMpuR7TBiTFDw7OXFlzbUdw73R4H0PrgNq6S5hL3t0yLs9l1cKmoTC4qgfi9GnY8PPjSK4oIWZJ7+nyGkSyhbPIi36nFkwj9aRfO5Wq08REMuzpmhQYHzMOa0Fh0MS+p5fzXavnqxRKcdHkmzZKiicDf+/OAFPGTdsBG6gifwJLAaZQ
X-MS-Exchange-AntiSpam-MessageData: ypWlAsvldP9RFutpDAhY28Upy7FB5ITMMB3AbX+oSaQIpgMm+KlhcJ3MDO6cNhixyksxXZrnyHAx29J5jJk7dVzZNL5mPMD5aQKbVUzlWSw+RZbD4ulKXzlm8jZJYJwTDxT87okPG5Yz+6iIB6YkUA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01141bfd-04fb-49eb-6b87-08d7c6cbd7f9
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2020 21:25:10.2761
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8NLFPoB+KSJhxo8yQUP5f46SpHtXqzlFWQFoIx6GRL7F/YP5qQ+puq8xOEGe0JY3s7kcKppVTc/4Px9KilCERg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB4668
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jakub Kicinski <kuba@kernel.org> writes:

> On Thu, 12 Mar 2020 20:05:03 +0200 Petr Machata wrote:
>> @@ -183,9 +189,12 @@ static void red_destroy(struct Qdisc *sch)
>>  }
>>  
>>  static const struct nla_policy red_policy[TCA_RED_MAX + 1] = {
>> -	[TCA_RED_PARMS]	= { .len = sizeof(struct tc_red_qopt) },
>> +	[TCA_RED_PARMS]	= { .len = sizeof(struct tc_red_qopt),
>> +			    .strict_start_type = TCA_RED_FLAGS },
>
> I think this needs to be set on attr 0, i.e. TCA_RED_UNSPEC,
> otherwise feel free to add:
>
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Pretty sure. I'll send v4.
