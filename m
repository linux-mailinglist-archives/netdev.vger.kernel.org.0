Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 844AA6099F
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 17:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728111AbfGEPr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 11:47:57 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:39643 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbfGEPr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 11:47:57 -0400
Received: by mail-yb1-f196.google.com with SMTP id u9so2369643ybu.6;
        Fri, 05 Jul 2019 08:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pSoZkvURxejnL/dL0x9qCwre/oddJmYnNzThb5p9diM=;
        b=RCup37VGa1RV9hooH7UbdWODjKAl/7M+maPueUFBLnVc+Q6+d3YStEzpaXJd7Y06F2
         YBY/5xNODsyDtJdubHHKTO5eZxJbi5FxXjsfdQvKeW3vN3Cz0lOQxhArCJdTifxEcXaf
         bs+7gJzx3ZcmBrhB/rvVB+l9wYzEXXkugXSt553GPs+I5aTtnxza5ti5DaeRcOnfz2Fo
         QUpm5E3AlE82jKcohrH4CytuolOuNeDwuYWXgTJRHgstNE1ubbZaoc61gUwaNY/gvAxI
         A1kTp5Gqs1UaDWhrm4oDG8HSSkQOgJJCAwVun1un/n5gIVs7Kp3i2qxo2EKeHrvriwxf
         W7fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pSoZkvURxejnL/dL0x9qCwre/oddJmYnNzThb5p9diM=;
        b=HzeWYkfraGdulfVjpdRqTkAizVhsWZxNiwMeuh37ziLRfXxSc6pbCSC7q+9gdwDLUk
         ghEBjfIBn2yUzzyikkHAyxtWnQntklWafkvyD2emzSnuW6YfzSIkWassr5AZ6ngtWjIn
         pF8O0zWvV4LHBwjAjNDvrEjFvIPe4/7AgcDvMn7YkDHrVlhF9dMiH2aqBW4d7yftUX9F
         QZNJiK3ksv089shOGM7AYHjbPtI2S9H11pmkwKOB68Yvjyrpy3wWgBpceCx2+k8qO+at
         QyyTbGy5pfbmacR23QJI73mQgOSuyGQHYio0BJi29O/8lcULsYMlcx0sFplF4QslaMOQ
         dANw==
X-Gm-Message-State: APjAAAUiL0MQEmjEUy4NNqExkznSmFpBbFvQSoCxkqGGxoO8lv+5ChTi
        E6n/u7pu2ebh0+CJdX5LxHw73/riuvwMNdRieco=
X-Google-Smtp-Source: APXvYqzE7FTxwb8NVt4MJ9HxdzZoZBgvGvWzIgiPuNRQLQnw1nBvxA/XVYWjQlboIxZ2RYv7I6KyOybRT3+bDEKt66U=
X-Received: by 2002:a25:7683:: with SMTP id r125mr2629058ybc.144.1562341676399;
 Fri, 05 Jul 2019 08:47:56 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000d3f34b058c3d5a4f@google.com> <20190626184251.GE3116@mit.edu>
 <20190626210351.GF3116@mit.edu> <20190626224709.GH3116@mit.edu>
 <CACT4Y+YTpUErjEmjrqki-tJ0Lyx0c53MQDGVS4CixfmcAnuY=A@mail.gmail.com> <20190705151658.GP26519@linux.ibm.com>
In-Reply-To: <20190705151658.GP26519@linux.ibm.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 5 Jul 2019 18:47:45 +0300
Message-ID: <CAOQ4uxg_Tf3O787hGmMka9D1x3ZahnU3q2OB-M3Gk1hnPso0=g@mail.gmail.com>
Subject: Re: INFO: rcu detected stall in ext4_write_checks
To:     paulmck@linux.ibm.com
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        syzbot <syzbot+4bfbbf28a2e50ab07368@syzkaller.appspotmail.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        David Miller <davem@davemloft.net>, eladr@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        John Stultz <john.stultz@linaro.org>,
        Ext4 <linux-ext4@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Does the (untested, probably does not even build) patch shown below help?
> This patch assumes that the kernel was built with CONFIG_PREEMPT=n.
> And that I found all the tight loops on the do_sendfile() code path.
>

I *think* you have.

FWIW, it would have been nicer for sendfile(2) and copy_file_range(2)
if the do_splice_direct() loop was also killable/interruptible.
Users may want to back off from asking the kernel to copy/send a huge file.

Thanks,
Amir.

> > If this is semi-intended, the only option I see is to disable
> > something in syzkaller: sched_setattr entirely, or drop CAP_SYS_NICE,
> > or ...? Any preference either way?
>
> Long-running tight loops in the kernel really should contain
> cond_resched() or better.
>
>                                                         Thanx, Paul
>
> ------------------------------------------------------------------------
>
> diff --git a/fs/splice.c b/fs/splice.c
> index 25212dcca2df..50aa3286764a 100644
> --- a/fs/splice.c
> +++ b/fs/splice.c
> @@ -985,6 +985,7 @@ ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
>                         sd->pos = prev_pos + ret;
>                         goto out_release;
>                 }
> +               cond_resched();
>         }
>
>  done:
>
