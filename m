Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E057522F7B4
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 20:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730596AbgG0SXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 14:23:36 -0400
Received: from mail-eopbgr60087.outbound.protection.outlook.com ([40.107.6.87]:60452
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729205AbgG0SXf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 14:23:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KpkbpGhvGe5e2zUWBexDL/iG/Tj8Rk6biWyzn7cDpiDmDLdsZgRoNMdQ1FOvc0/sR63YLz2d/zi9qw/h4wuiiDaaF/PvotoElCn6xe1HqAl2hNFeJv5sORQWGJF+gjlWj76j5NRG4g9gcyC8+EQqkawSbnCuiHd5QxpR3OQ7y46UOhyxdpRRzTO4BnUF9L2KJQPSTgL0MpkcO3HE1zQFoDIL9hG8HvPIGH2L3K9iuuh8coAgfZlCemItyUlmnVe2M5cozGxEiuZ3SO0ag/Y5g6ukVGVY3ebsI/LSZMOoes8tkvXdyk1nq3aWJ7yghOfPEZbsUFMLWuew4837/jmBHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3fczzHf/CNmL9fZwUbnK2U9GwRidJ+D1vEi2cIyx0nU=;
 b=UnNQjfvd7a2LP6AHTjSOlQlp9LzBM3K5eq2PKDSgVS3jhP1r2U4I+gUaw8Tl2dXYONvdNR4WZPpxJehZIlMlwe9V/q0vHUm9wUps+ySUlMq+wfQs5vakjOjDk2IeYN6l/MW9kO7mnP8WqQ0HVbbh91H5xMcA2Pyejijpmjur5UvBzx4f+2HLD0IMT5mE7qCXvoKQMmnmtN84+zQYQG5QgHcEBqxj4JCy6COjn2a5NJ/k+oc3kf4zMUZHdwE7odrqV+m1B2O2l6zGHrjxKWvyBvUsL9UbovssYciPc48PygKctzz6+Bo4JW0huhc8mhyw0obH5AUtpRdnrLZ180SqTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3fczzHf/CNmL9fZwUbnK2U9GwRidJ+D1vEi2cIyx0nU=;
 b=jbVPClvUigSXCp17pUwXKq3ogUScNJGFw5mDvx/HTSaWEnd8iHjsmdO8d7NzXr46QylN1rovW4JI7dliWPk4IYOFZIrbq5gk/KtWB6WMcc7IbQ49E8rVY/3K4oD29cKL+dM/TkZSM0Y75nA9sR5JajPfKCmO1hbVOYNyC8CKAAg=
Authentication-Results: resnulli.us; dkim=none (message not signed)
 header.d=none;resnulli.us; dmarc=none action=none header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR0501MB2603.eurprd05.prod.outlook.com (2603:10a6:3:6e::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3216.23; Mon, 27 Jul 2020 18:23:31 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::56c:7b22:6d6e:ed2b]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::56c:7b22:6d6e:ed2b%5]) with mapi id 15.20.3216.033; Mon, 27 Jul 2020
 18:23:31 +0000
References: <20200725201707.16909-1-xiyou.wangcong@gmail.com>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org,
        syzbot+6e95a4fabf88dc217145@syzkaller.appspotmail.com,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [Patch net-next] net_sched: initialize timer earlier in red_init()
In-reply-to: <20200725201707.16909-1-xiyou.wangcong@gmail.com>
Date:   Mon, 27 Jul 2020 20:23:29 +0200
Message-ID: <871rkwizq6.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0202CA0003.eurprd02.prod.outlook.com
 (2603:10a6:200:89::13) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (213.220.234.169) by AM4PR0202CA0003.eurprd02.prod.outlook.com (2603:10a6:200:89::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Mon, 27 Jul 2020 18:23:30 +0000
X-Originating-IP: [213.220.234.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e6ac6c1c-a084-4ceb-2467-08d8325a2a61
X-MS-TrafficTypeDiagnostic: HE1PR0501MB2603:
X-Microsoft-Antispam-PRVS: <HE1PR0501MB26036A5DF9130972B564CFFEDB720@HE1PR0501MB2603.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z0b4ATCVQxQp9y2aHPHVszlAxc+EIowtKAz0izM1FYMalEY8S7X9AUYQMPzi5vgsnBxqUcAc9uP3kV/mP+bCBAUVC8vngxE/1o36ZXHo39re50v2cuuY1MRY9iYGJlYkAfHILpZhlY94hmfnUdVGqBW992f7OmeuPuqHe33rhbAtRdQLkAZu1clN0pffrddEb/NAKdQFZkhzkGrVA6+rdFVAfqaO2NOsbg7tGD48b9coemhb7t3a8t21KunvSNLzl8/qhoRN0CTML2F5j0owq8sTVcLTkoWST3EDDQD3v8cD1bxE4rI0GsYluNFrhhx43S1msB0fkE7PI2bPtqQuAQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(376002)(136003)(39860400002)(396003)(26005)(4326008)(186003)(36756003)(66556008)(66946007)(52116002)(6496006)(16526019)(66476007)(478600001)(316002)(6916009)(83380400001)(2906002)(8676002)(6486002)(86362001)(5660300002)(54906003)(8936002)(956004)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: BH696SkZz7mmKLAQqcDvOYj1crnrduN9JMghnH+wSXvh599ZFBroEL5CXH4vLsZFP2jt+oCtKvnFUM9w5l+S5DuAMoBbODbrgyhiVKIE329YClMVJaYv7/ZYdE/qBJ7AmEAdGCOvYng2ZzluVxHtzZMhce4rBR1NezdQg1E3AakQIkQE4Y740O+SbNCfsRLXrJHbPL4IZXmGymmxEUyrA+m3+muJNC6WtmEG9OhD1ljZbapi/jW1MAjTiuXbxr6KHtdlA+nbu+4ECSHtvJzVRxu5Wm0YcIjb2e1x2lWND6HNKMJwCtOvkJg9ENwrDMvqgaDmylmgUD8zsDxjuDt8A6ekSsgeJ09KAzQ6prCf5G+E+o9Uz8UEaHww1CWAiIM2G8QFLdDtg18egoaLPR+AQRJIKbYLOyTkr6fK805r7p9B8OnufXHBX3mp9iaP478D+E+kewudXAdLXR91fN9rXHDT7QI90spctQM0tpMNSt5DhBJME8s66+6AssXxD3uN
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6ac6c1c-a084-4ceb-2467-08d8325a2a61
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2020 18:23:31.4228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6oNLvlLsLR+cv2LC0SbmxVYBFaNsLtOg0ng1hPJfdXzAilTDzrKgfunufnlPYM+m4iW/nyJ+gCBBTaWdUmPzEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0501MB2603
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Cong Wang <xiyou.wangcong@gmail.com> writes:

> When red_init() fails, red_destroy() is called to clean up.
> If the timer is not initialized yet, del_timer_sync() will
> complain. So we have to move timer_setup() before any failure.
>
> Reported-and-tested-by: syzbot+6e95a4fabf88dc217145@syzkaller.appspotmail.com
> Fixes: aee9caa03fc3 ("net: sched: sch_red: Add qevents "early_drop" and "mark"")
> Cc: Petr Machata <petrm@mellanox.com>
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Ah, correct, this used to be done in red_init() not only before calling
red_change(), but actually before doing anything that can fail. Thanks
for fixing this.

Reviewed-by: Petr Machata <petrm@mellanox.com>

> ---
>  net/sched/sch_red.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/net/sched/sch_red.c b/net/sched/sch_red.c
> index 4cc0ad0b1189..deac82f3ad7b 100644
> --- a/net/sched/sch_red.c
> +++ b/net/sched/sch_red.c
> @@ -333,6 +333,10 @@ static int red_init(struct Qdisc *sch, struct nlattr *opt,
>  	struct nlattr *tb[TCA_RED_MAX + 1];
>  	int err;
>
> +	q->qdisc = &noop_qdisc;
> +	q->sch = sch;
> +	timer_setup(&q->adapt_timer, red_adaptative_timer, 0);
> +
>  	if (!opt)
>  		return -EINVAL;
>
> @@ -341,10 +345,6 @@ static int red_init(struct Qdisc *sch, struct nlattr *opt,
>  	if (err < 0)
>  		return err;
>
> -	q->qdisc = &noop_qdisc;
> -	q->sch = sch;
> -	timer_setup(&q->adapt_timer, red_adaptative_timer, 0);
> -
>  	err = __red_change(sch, tb, extack);
>  	if (err)
>  		return err;
