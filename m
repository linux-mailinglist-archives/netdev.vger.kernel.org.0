Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1BD5B4978
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 10:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388883AbfIQI2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 04:28:02 -0400
Received: from mail-eopbgr150057.outbound.protection.outlook.com ([40.107.15.57]:21566
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728127AbfIQI2B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Sep 2019 04:28:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L+rtfvgrLQobjSEtDcwK+XxnXs2sIqbKyZwRavTBqRXBLH1pFfvkqW9FigFf6XhvrNdfdNvZDD2EFZKbWBcO3Q7ojv4L1CzYli8w8g00KyfWkYzKZD/aJqRkhc1OsG8C6IXcT9yzeele9Ge5O9x7aSGyoIFBPm9Vz1Za5OPPFbl/UJpbBv6VIqxOj/CMnsu48RXsVctXd6fDOlxVbg6yGELeCvEbon918yrrWfuaMJUGexid5oBE/spJPRzIc1WPXjf2G8hbVKDjiHjH+NSydhkvUJvZHlwH+AYu1BqrpYOwzG+e/8bUoKBaf6XdL+qLkSwnb9HQxyxkIEQ1HFQIZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iGgZRmHg8bUoZc3rCWzMu+54qIfekgpQj/oBaejGMhs=;
 b=XPmOBc4l0fywyIdYDq/gvdjqMC2N+PBqp8B661dTSupHDytz/CKWRCK6X8R2pDbqTo4X1CS0s2xip+tcHDVjbiSZdkA4PNTlr+HkvhD80f3O2GNrYdViIWhSSPVmYy/qd/Mfilp7mLLy9oUcjeccfdsCSzfuvzrEeRi2zVrcHwY7gF7Edm+HOXFkkVFB+aa0CJIFIoYNnc5cQASad3nzGVQpZ0VlFyACBtzl9hInk13WI9N3U/JqdMAPcVxh9sQDMK06h99I/stAMS6V7cVNo5uxdj0uCkFnriOnDPGPbNPQOjJuaaTR9M1Yf61BXl3xyHashQ0pSu7KMBZekfV5+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iGgZRmHg8bUoZc3rCWzMu+54qIfekgpQj/oBaejGMhs=;
 b=ML5yt2KA1MOPfdyeC4k0w9a8kHX2U/TE6e8p3+UV3r/YSohRzl1T/U4nzAkYYZNP/SkAIkWE6rauU+bgow3JWlYyU+eI56yXJzqVsV15MRFtR8ScYc9hY9WoP2+2yDQFDlK1fy+PGfdjP5YRFvriUXhqQdBUUhPbyqdThZL+iwA=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB5535.eurprd05.prod.outlook.com (20.177.201.94) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.23; Tue, 17 Sep 2019 08:27:55 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::f910:e7e:8717:f59d]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::f910:e7e:8717:f59d%6]) with mapi id 15.20.2263.023; Tue, 17 Sep 2019
 08:27:55 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     syzbot <syzbot+ac54455281db908c581e@syzkaller.appspotmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "hawk@kernel.org" <hawk@kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@mellanox.com>, Jiri Pirko <jiri@resnulli.us>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Petr Machata <petrm@mellanox.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>,
        "yhs@fb.com" <yhs@fb.com>
Subject: Re: BUG: sleeping function called from invalid context in
 tcf_chain0_head_change_cb_del
Thread-Topic: BUG: sleeping function called from invalid context in
 tcf_chain0_head_change_cb_del
Thread-Index: AQHVbOfxS+4wZTnw/UG0HWKBhwV4mKcvHPGAgABs04A=
Date:   Tue, 17 Sep 2019 08:27:55 +0000
Message-ID: <vbfk1a7cooq.fsf@mellanox.com>
References: <00000000000029a3a00592b41c48@google.com>
 <CAM_iQpX0FAvhcZgKjRd=3Rbp8cbfYiUqkF2KnmF9Pd0U4EkSDw@mail.gmail.com>
In-Reply-To: <CAM_iQpX0FAvhcZgKjRd=3Rbp8cbfYiUqkF2KnmF9Pd0U4EkSDw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0239.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:b::35) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 36c7d97b-d23d-4f5f-863e-08d73b48f038
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB5535;
x-ms-traffictypediagnostic: VI1PR05MB5535:|VI1PR05MB5535:
x-ms-exchange-purlcount: 8
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5535F80DFE4F1858073A29F8AD8F0@VI1PR05MB5535.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 01630974C0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(39860400002)(376002)(136003)(346002)(189003)(199004)(11346002)(229853002)(6512007)(316002)(2616005)(54906003)(446003)(4326008)(6306002)(81156014)(81166006)(8936002)(8676002)(476003)(7736002)(36756003)(64756008)(66446008)(66556008)(305945005)(5660300002)(66946007)(66476007)(6246003)(86362001)(14454004)(99286004)(14444005)(186003)(66066001)(26005)(6486002)(256004)(2906002)(386003)(478600001)(6436002)(52116002)(76176011)(102836004)(25786009)(6506007)(53546011)(71200400001)(6916009)(486006)(966005)(7416002)(71190400001)(6116002)(3846002)(99710200001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5535;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: KrlkLv6njugdOXrmMAlsm0ObiJ1rxdJR97YzGov/FB0v8yJJZrFaLQR7euj2KcqdwiPLMAMvzrBKtuL0o+g3LOBptUiPICP+qTr5VvBr94z0S3IKm4SaukVJuv8jnTUfkaFjfoMgvmAK2LXT/pyy0eK8SlM+WDoje/YHGU1unWc+OLikHwxlWSvgtlOODxLViYHR+Vb4Baw504K4CQjYwKFLytliMuEFHm1rhK3iIg/8Buvs2CGjqoC2XiARpMsQ1ufT8OGuyLhWBaO/MgRExSQMhll9wk0CwOWlWc4Ar1/tCZ3VGmBqv4hGFXxQG6+G9UUYZl1nRtf4sJKzsZE02yhauaScZXv8BkptmUKQFD2gzh9aX2NvymfQZ96i8E49Q3MsGGG1JB+U710W7n6WU28mJwBlLET+mjIrLC176ZU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36c7d97b-d23d-4f5f-863e-08d73b48f038
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Sep 2019 08:27:55.3313
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fETXdrXCVt/o0th/W2D3HO53OkfpdWBPVwwU2h5EgxoWjzCVY4p8kB7BWUdU/MwPkJ/LeWHv8z428vQgyC8piw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5535
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue 17 Sep 2019 at 04:58, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> On Mon, Sep 16, 2019 at 4:39 PM syzbot
> <syzbot+ac54455281db908c581e@syzkaller.appspotmail.com> wrote:
>>
>> Hello,
>>
>> syzbot found the following crash on:
>>
>> HEAD commit:    1609d760 Merge tag 'for-linus' of git://git.kernel.org/p=
ub..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=3D10236abe6000=
00
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=3Ded2b148cd673=
82ec
>> dashboard link: https://syzkaller.appspot.com/bug?extid=3Dac54455281db90=
8c581e
>> compiler:       clang version 9.0.0 (/home/glider/llvm/clang
>> 80fee25776c2fb61e74c1ecb1a523375c2500b69)
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D116c4b1160=
0000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D15ff270d6000=
00
>>
>> The bug was bisected to:
>>
>> commit c266f64dbfa2a970a13b0574246c0ddfec492365
>> Author: Vlad Buslov <vladbu@mellanox.com>
>> Date:   Mon Feb 11 08:55:32 2019 +0000
>>
>>      net: sched: protect block state with mutex
>>
>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=3D16e7ca656=
00000
>> final crash:    https://syzkaller.appspot.com/x/report.txt?x=3D15e7ca656=
00000
>> console output: https://syzkaller.appspot.com/x/log.txt?x=3D11e7ca656000=
00
>>
>> IMPORTANT: if you fix the bug, please add the following tag to the commi=
t:
>> Reported-by: syzbot+ac54455281db908c581e@syzkaller.appspotmail.com
>> Fixes: c266f64dbfa2 ("net: sched: protect block state with mutex")
>>
>> BUG: sleeping function called from invalid context at
>> kernel/locking/mutex.c:909
>> in_atomic(): 1, irqs_disabled(): 0, pid: 9297, name: syz-executor942
>> INFO: lockdep is turned off.
>> Preemption disabled at:
>> [<ffffffff8604de24>] spin_lock_bh include/linux/spinlock.h:343 [inline]
>> [<ffffffff8604de24>] sch_tree_lock include/net/sch_generic.h:570 [inline=
]
>> [<ffffffff8604de24>] sfb_change+0x284/0xd30 net/sched/sch_sfb.c:519
>> CPU: 0 PID: 9297 Comm: syz-executor942 Not tainted 5.3.0-rc8+ #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
>> Google 01/01/2011
>> Call Trace:
>>   __dump_stack lib/dump_stack.c:77 [inline]
>>   dump_stack+0x1d8/0x2f8 lib/dump_stack.c:113
>>   ___might_sleep+0x3ff/0x530 kernel/sched/core.c:6608
>>   __might_sleep+0x8f/0x100 kernel/sched/core.c:6561
>>   __mutex_lock_common+0x4e/0x2820 kernel/locking/mutex.c:909
>>   __mutex_lock kernel/locking/mutex.c:1077 [inline]
>>   mutex_lock_nested+0x1b/0x30 kernel/locking/mutex.c:1092
>>   tcf_chain0_head_change_cb_del+0x30/0x390 net/sched/cls_api.c:932
>>   tcf_block_put_ext+0x3d/0x2a0 net/sched/cls_api.c:1502
>>   tcf_block_put+0x6e/0x90 net/sched/cls_api.c:1515
>>   sfb_destroy+0x47/0x70 net/sched/sch_sfb.c:467
>>   qdisc_destroy+0x147/0x4d0 net/sched/sch_generic.c:968
>>   qdisc_put+0x58/0x90 net/sched/sch_generic.c:992
>>   sfb_change+0x52d/0xd30 net/sched/sch_sfb.c:522
>
> I don't think we have to hold the qdisc tree lock when destroying
> the old qdisc. Does the following change make sense?
>
> diff --git a/net/sched/sch_sfb.c b/net/sched/sch_sfb.c
> index 1dff8506a715..726d0fa956b1 100644
> --- a/net/sched/sch_sfb.c
> +++ b/net/sched/sch_sfb.c
> @@ -488,7 +488,7 @@ static int sfb_change(struct Qdisc *sch, struct nlatt=
r *opt,
>                       struct netlink_ext_ack *extack)
>  {
>         struct sfb_sched_data *q =3D qdisc_priv(sch);
> -       struct Qdisc *child;
> +       struct Qdisc *child, *tmp;
>         struct nlattr *tb[TCA_SFB_MAX + 1];
>         const struct tc_sfb_qopt *ctl =3D &sfb_default_ops;
>         u32 limit;
> @@ -519,7 +519,7 @@ static int sfb_change(struct Qdisc *sch, struct nlatt=
r *opt,
>         sch_tree_lock(sch);
>
>         qdisc_tree_flush_backlog(q->qdisc);
> -       qdisc_put(q->qdisc);
> +       tmp =3D q->qdisc;
>         q->qdisc =3D child;
>
>         q->rehash_interval =3D msecs_to_jiffies(ctl->rehash_interval);
> @@ -543,6 +543,7 @@ static int sfb_change(struct Qdisc *sch, struct nlatt=
r *opt,
>
>         sch_tree_unlock(sch);
>
> +       qdisc_put(tmp);
>         return 0;
>  }
>
>
> What do you think, Vlad?

Hi Cong,

Don't see why we would need qdisc tree lock while releasing the
reference to (or destroying) previous Qdisc. I've skimmed through other
scheds and it looks like sch_multiq, sch_htb and sch_tbf are also
affected. Do you want me to send patches?

Regards,
Vlad
