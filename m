Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45C6521725B
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 17:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730334AbgGGPbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 11:31:51 -0400
Received: from mail-db8eur05on2070.outbound.protection.outlook.com ([40.107.20.70]:4513
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729893AbgGGPWm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 11:22:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hkcDtffsX1/CUVwNy3rDdViKitAqTu2B5cIbfvhhCWZNHhh703e79qA4tGNgG7qoVqLQpOxvyYj8lnyzNeEKdhkEv15/FoAeEatn/16nrT+fIycWjNd16JoZwvF5OjNZv/Vl1F5QmsWMY3c8HaJPOdZ5eF1X0eYM7Nmw0qzmYbCrTMWrAYssX9mv0ERb8822UFbSXiMybnPyBUl5OzNZJ6HInkhb9bSOd1deHAyyXtg0iK4aZXlAnLB45FB11zNlDIJoUXHxWqM1CgNpXXm2kAIR2cwHICGngjs00azJoSYHmaf20HvjD4bmI0uqAYMGB+tS+jUuV9V7P+jvFrqwSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ayT1UJpPytQC43T3fVsRxcK65IPWIhVm/YpmJfaIadM=;
 b=OaOUDLSdJ8skIsLofGSJYoEI8Qd0AzFHEU+EjtRkBnwjQP7lCxIQ7GV4fI/0e5MV+HVI2SpUZVBMsuzzmnSbH5/eX2J2dnUcHRlEtTmvmlRiyPqz46a7RnIRCUYcOKeFbWERV4Ogn6xB7/pzCjfrwmnXh1ILvsw2u08W6e0guxfTjNB2Pv3+fowVf4I4eqIyUGBppczWUC2yBPwLwQtNJO1lr5MyZsjgv3PZanWAE/AoAKmrJcIQMqIrvBT7j5eSOzq8YkGVqnmngJFVUjc/2xATjAtgbQ9zFKqVxax6cuLUTld+XGRh5FnrErCTcIBzLphP4ZnlETJquieW7N3iiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ayT1UJpPytQC43T3fVsRxcK65IPWIhVm/YpmJfaIadM=;
 b=BEDKOoFuOzRjVDblRqvrctPdpkz6WZGSMVmRutlBcXs7Pa//WPRc+kiWrBXOD0Qoxhu7ds5R2ysFVoA1cesTajDBeXcdihKnrsrFQw5pyTkBEX8Y/v5MXujXivK8r/qovrmgUSccs+/VbQyYftBD1t5osr7YMejCx/0+TPBfV+s=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3420.eurprd05.prod.outlook.com (2603:10a6:7:30::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3153.20; Tue, 7 Jul 2020 15:22:38 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3153.029; Tue, 7 Jul 2020
 15:22:38 +0000
References: <cover.1593209494.git.petrm@mellanox.com> <79417f27b7c57da5c0eb54bb6d074d3a472d9ebf.1593209494.git.petrm@mellanox.com> <CAM_iQpXvwPGz=kKBFKQAkoJ0hwijC9M03SV9arC++gYBAU5VKw@mail.gmail.com>
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
In-reply-to: <CAM_iQpXvwPGz=kKBFKQAkoJ0hwijC9M03SV9arC++gYBAU5VKw@mail.gmail.com>
Date:   Tue, 07 Jul 2020 17:22:36 +0200
Message-ID: <87a70bic3n.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM3PR03CA0054.eurprd03.prod.outlook.com
 (2603:10a6:207:5::12) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (213.220.234.169) by AM3PR03CA0054.eurprd03.prod.outlook.com (2603:10a6:207:5::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20 via Frontend Transport; Tue, 7 Jul 2020 15:22:38 +0000
X-Originating-IP: [213.220.234.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 335bb001-5854-4384-2be9-08d82289955c
X-MS-TrafficTypeDiagnostic: HE1PR05MB3420:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3420CB5286B9D8F19DFC6959DB660@HE1PR05MB3420.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0457F11EAF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X3TvTA3xByv+PW3OHNkdp4fbl9tzUmJoqoC1DnS9aLoNLa31kGHn674v2l1GdZwFiRSJo54ubGdAJTD8iQJRMtbxh+5Ihn6IvXWeQwLwrN8lGwF9gygScBsbnp2XcZuYUrmvkovCgaQtA7DU5SYPB1Kk8GmQU1QGDOdwaQXkClt5t4K2toPOktg4FS8OqjbAWeKThOoMLCAN2kOKD8UqsMEx/BcWiSz5/vHzJYwUtG3H01Bm+fPzhZ9HHwszNiIF/OwyaaiyCHbvRTm5GPQCKCka316JU5FhZL7jB+PmgH7fSpCFfOJOSaqj6MxqmO0bplWfu+Wz8rcJn3iyRBZeqg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(107886003)(186003)(53546011)(26005)(54906003)(6496006)(8936002)(52116002)(36756003)(2616005)(956004)(6486002)(4326008)(6916009)(8676002)(5660300002)(16526019)(2906002)(498600001)(86362001)(66946007)(66556008)(83380400001)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: lvnjC44jLPgWGD0wT+6cNlRMVhSm0mMn6SvzIyHTmsf42WNvWuYOpKwNZGRPnKxW5XWIx1fdLGRHM/TOqf9GktJwUTrbzSxN+qeYDff4NqQaMoC+2JqRMgPwcHFomA8DYeskH6gVxqJj83AcXic9wsBmC4qCxQ7bH1BgZZAhj7EYjE9cwwxOjQDgwe1JXihf/gvbx30iSzzdE9SDpP8bRdwYMfmMGbKOL5s0tudWUYF95IusuRseVpODh3n2UFwYWrDlJS1vy35S60cPadpmGFDk9wKTjNol+vAiV5SItuVGnaOjT3DEZnmujdKNx6UAmu8cOR76sZXCDN72dzHC4gg3MlhA1bqViAG+v2cGWsnzDSLtkZ28OcUTcIlf3h77UOUbVFdVZGYZhRYW/pCkd+19exCNGjE8HUMlCtxBnTreJreolGZ2ELrQosccQ5GvprVkB4EoYqfAmFf595+uzx1vMyoL41EJsHTX2+Tilu3Vqz86T/WCTwHwBCaB14Xh
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 335bb001-5854-4384-2be9-08d82289955c
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2020 15:22:38.6173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VKupHjBEGg/QtP/sMML0pp71iBa+KFADI+FwyFJZd+ZXj8Yhazd8RMR2pXcbjYuGNAPtLWvd8ApzovISL/dzvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3420
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Cong Wang <xiyou.wangcong@gmail.com> writes:

> On Fri, Jun 26, 2020 at 3:46 PM Petr Machata <petrm@mellanox.com> wrote:
>> The function tcf_qevent_handle() should be invoked when qdisc hits the
>> "interesting event" corresponding to a block. This function releases root
>> lock for the duration of executing the attached filters, to allow packets
>> generated through user actions (notably mirred) to be reinserted to the
>> same qdisc tree.
>
> Are you sure releasing the root lock in the middle of an enqueue operation
> is a good idea? I mean, it seems racy with qdisc change or reset path,
> for example, __red_change() could update some RED parameters
> immediately after you release the root lock.

So I had mulled over this for a while. If packets are enqueued or
dequeued while the lock is released, maybe the packet under
consideration should have been hard_marked instead of prob_marked, or
vice versa. (I can't really go to not marked at all, because the fact
that we ran the qevent is a very observable commitment to put the packet
in the queue with marking.) I figured that is not such a big deal.

Regarding a configuration change, for a brief period after the change, a
few not-yet-pushed packets could have been enqueued with ECN marking
even as I e.g. disabled ECN. This does not seem like a big deal either,
these are transient effects.
