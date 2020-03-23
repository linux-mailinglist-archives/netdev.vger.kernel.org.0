Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7760518FBD7
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 18:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727763AbgCWRsc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 13:48:32 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:40985 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727639AbgCWRsc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 13:48:32 -0400
Received: by mail-ot1-f66.google.com with SMTP id w26so8379832otp.8;
        Mon, 23 Mar 2020 10:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i5R4FiCsX5ixM5ijJTFNrw5pLmulYx/iMq1LWD3HrSk=;
        b=GCrRzrrK04ONsJppmAzrNV59zvFxlUNJdsBjcbSgkmGBeCPdY7pVlK/6Xl6k5zp3Zs
         V4Qpkt/yXGWc7J+tmX4emjq5a3QZr5mqfrDG1c8BotCr/6kplBc/b0cXkq4zYFbqlH2K
         erzPbZ6Ivrg3BuxhRXMKkhePGmhMqvxP/NfJbmQ07RNgmNFQgan/lQF2F42LfmqT43tx
         sDkZbz0kkdf9sDc7x4MWyAnyNcpqn3xwV116/pvgNA1WRx38TZilEf5WNDzWfLkaEfTF
         QdoKTHFvyshyEbYDrIWKf3fL8gu4j8vAlVDf2au1vJFBU1q+wtMN5sx3DZED5RHP4VC3
         Izmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i5R4FiCsX5ixM5ijJTFNrw5pLmulYx/iMq1LWD3HrSk=;
        b=VL4kg1NzcvXV/xz/OtqQ22TGr+JnPWWz8LVi+tFCx/i9PjWriUjLjSpGNW2DlidcUP
         7dWZlCdueeHgS+PIoMuc0F/fDIexyIYIM3f3h3EBYma2efUz2yqvp/wGvekf9NmygELo
         9cQdHYYlrep5N+Rm8NxNPlm+qJmCqRIa42n/ZUAsCBXCIYLg4Efj+VoeHx6aAhpFU/s0
         G4jZMrUk4c0uqPuI9Vhh/+BcBys0KCIBvPfMWBqgWRLEZct0AHudBO/gNJ5WfQQIdsNn
         aWtr3d9GtT5B6msZyw0R4nX+rjLgTM1yHTBebuHUlPQT3TkJID/66L36QjfW4lQFSHK3
         srXA==
X-Gm-Message-State: ANhLgQ3mZ7jLA2L1J/bd6aKIsvD7GXbrf1QTXq4DMyQvRE8FUqXnp/1G
        ByjZIOgx6Kq3su9Vx9EOujGZQ/Ed1p0NcmoE+NM=
X-Google-Smtp-Source: ADFU+vtQe3siLMOhX3F9IlIi0BxQ4oBMvx+Zn4y1ftZehgSO9XW/DOqs3ZYXcBXVNsyRyGuoMRfWExrocv87Msob1Zg=
X-Received: by 2002:a05:6830:1bc9:: with SMTP id v9mr18279116ota.319.1584985711651;
 Mon, 23 Mar 2020 10:48:31 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000742e9e05a10170bc@google.com> <87a74arown.fsf@nanos.tec.linutronix.de>
In-Reply-To: <87a74arown.fsf@nanos.tec.linutronix.de>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 23 Mar 2020 10:48:20 -0700
Message-ID: <CAM_iQpV3S0xv5xzSrA5COYa3uyy_TBGpDA9Wcj9Qt_vn1n3jBQ@mail.gmail.com>
Subject: Re: WARNING: ODEBUG bug in tcindex_destroy_work (3)
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     syzbot <syzbot+46f513c3033d592409d2@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 21, 2020 at 3:19 AM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> syzbot <syzbot+46f513c3033d592409d2@syzkaller.appspotmail.com> writes:
> > syzbot has found a reproducer for the following crash on:
> >
> > HEAD commit:    74522e7b net: sched: set the hw_stats_type in pedit loop
> > git tree:       net-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=14c85173e00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=b5acf5ac38a50651
> > dashboard link: https://syzkaller.appspot.com/bug?extid=46f513c3033d592409d2
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17bfff65e00000
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+46f513c3033d592409d2@syzkaller.appspotmail.com
> >
> > ------------[ cut here ]------------
> > ODEBUG: free active (active state 0) object type: work_struct hint: tcindex_destroy_rexts_work+0x0/0x20 net/sched/cls_tcindex.c:143
> ...
> >  __debug_check_no_obj_freed lib/debugobjects.c:967 [inline]
> >  debug_check_no_obj_freed+0x2e1/0x445 lib/debugobjects.c:998
> >  kfree+0xf6/0x2b0 mm/slab.c:3756
> >  tcindex_destroy_work+0x2e/0x70 net/sched/cls_tcindex.c:231
>
> So this is:
>
>         kfree(p->perfect);
>
> Looking at the place which queues that work:
>
> tcindex_destroy()
>
>    if (p->perfect) {
>         if (tcf_exts_get_net(&r->exts))
>             tcf_queue_work(&r-rwork, tcindex_destroy_rexts_work);
>         else
>             __tcindex_destroy_rexts(r)
>    }
>
>    .....
>
>    tcf_queue_work(&p->rwork, tcindex_destroy_work);
>
> So obviously if tcindex_destroy_work() runs before
> tcindex_destroy_rexts_work() then the above happens.

We use an ordered workqueue for tc filters, so these two
works are executed in the same order as they are queued.

Thanks.
