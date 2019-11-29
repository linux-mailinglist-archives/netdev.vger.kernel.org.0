Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3907710D127
	for <lists+netdev@lfdr.de>; Fri, 29 Nov 2019 06:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbfK2Fyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Nov 2019 00:54:55 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:37091 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbfK2Fyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Nov 2019 00:54:54 -0500
Received: by mail-io1-f65.google.com with SMTP id k24so20511450ioc.4;
        Thu, 28 Nov 2019 21:54:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jmqoLt1Ipq80GEdpA7uVx5mVDtS/SHGillzYT51kWkE=;
        b=drRBrsLJwOsSDbcgTdjYnL5YhMtimm45cqMj6s4jIv1ZiQMoJ+n2QJ7Y4N2fpxng+k
         Av+QFRIqa3MGfDJvB6fXNrrtHwh/kKJkEwpY9NxTP5WdivkgkRF61Ef6lL7lkGNhzDUn
         mBh9Eabz7V+PMQcprEOS3wCgTBqMtOwzW53Da7vf+dbdon4HexOvCTcVAdFWAV/fyDQQ
         KvrRpmTc4IPAcG2Rmqyz5DUUXcMHWsyn6PctBCfMdcRQtValX9jxUzw/OogRD1nIfNKC
         zghJpMGqLmvnXVts6NHiYcNaN/WiKBs/svtV0BjUNRC61e+3CXOCi/kv/X5GG9ScEWIR
         Wlww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jmqoLt1Ipq80GEdpA7uVx5mVDtS/SHGillzYT51kWkE=;
        b=XdJU8TheBbhTC+up6Wx+DJOmJgBlo32F3IPJ3Jgaiq9PqdxKwBlUbYNdCUdyxKiZdq
         bU+Rmg18OhpttAc91ViAheUjsFePQxBiRJcPY5Nmq/++aeOdUThqILzps7YATSnYsUeS
         8V+c7HRA+zmgvyVv0louhi3/1l7HPzE/gqZauhPifxUFCf/7eRLCt7mB3HCZyvmW2eT0
         kc10p3y8+UXkVC2BwszKfqOaaXPuEjVj+OKY/u1oXLNiG19uVfx+hsNIcNN/s2aaMLCP
         jk0dh3W+vNUZ/Kt6dzr/vdVcplg+FmDs0MGqCNvqUhQK06WSgpO5iA6ucSxBpVzETqRx
         gZ6w==
X-Gm-Message-State: APjAAAVJCs9ifF4MWHI0cvs6P+gRJydiISXO03DjK/x6AG6bcZ3qMCTt
        KRUlPRljM4cwcSuOM8+nExsg7TbsmzbiWfIwZ3E=
X-Google-Smtp-Source: APXvYqwV3CFFzruKf9Fkvty9F4uglgcC+7qYiLkkXVZIkvaTCtnY+i383rzfNHnGK2g/uDxWCVCXSbrggK+AdFMZcrU=
X-Received: by 2002:a02:a08:: with SMTP id 8mr8538761jaw.98.1575006893958;
 Thu, 28 Nov 2019 21:54:53 -0800 (PST)
MIME-Version: 1.0
References: <0000000000007d22100573d66078@google.com> <alpine.LFD.2.20.1808201527230.2758@ja.home.ssi.bg>
 <ace19af4-7cae-babd-bac5-cd3505dcd874@I-love.SAKURA.ne.jp>
In-Reply-To: <ace19af4-7cae-babd-bac5-cd3505dcd874@I-love.SAKURA.ne.jp>
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
Date:   Fri, 29 Nov 2019 06:54:47 +0100
Message-ID: <CAKXUXMwwxvJYjB0BkcmYg=AkzxW37SPiEuhyFPoATzEVY-MC7g@mail.gmail.com>
Subject: Re: unregister_netdevice: waiting for DEV to become free (2)
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     syzbot <syzbot+30209ea299c09d8785c9@syzkaller.appspotmail.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Jouni Hogander <jouni.hogander@unikie.com>,
        Julian Anastasov <ja@ssi.bg>, ddstreet@ieee.org,
        Dmitry Vyukov <dvyukov@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, syzkaller-bugs@googlegroups.com,
        Hulk Robot <hulkci@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 28, 2019 at 10:56 AM Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
>
> Hello people involved in commit a3e23f719f5c4a38 ("net-sysfs: call dev_hold if kobject_init_and_add success")
> and commit b8eb718348b8fb30 ("net-sysfs: Fix reference count leak in rx|netdev_queue_add_kobject").
>
> syzbot is reporting that unregister_netdevice() hangs due to underflowing
> device refcount when kobject_init_and_add() failed due to -ENOMEM.
>

Tetsuo, would you happen to have a C reproducer program that creates
the trace you reported?

I could not quickly find one that by the date would fit to when we
included our change on this syzbot page:
https://syzkaller.appspot.com/bug?id=bae9a2236bfede42cf3d219e6bf6740c583568a4

Jouni, can you please follow up on this report.

Thanks.

Lukas
