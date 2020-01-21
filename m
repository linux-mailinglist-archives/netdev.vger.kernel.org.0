Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7DF1444EA
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 20:16:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbgAUTQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 14:16:47 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:33064 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726229AbgAUTQr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 14:16:47 -0500
Received: by mail-lf1-f67.google.com with SMTP id n25so3291201lfl.0;
        Tue, 21 Jan 2020 11:16:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yH4ULRCvH4cIDF7hD9SOh0HJDCpz6O0XU2vMhvkwdOE=;
        b=Z1RfHvzAJPA/StIKZHDEekvQyA0VUlR1vmzUjSrVy0rGP1l702BDP+NRdzLf/mbFkj
         /25wksgnCFXLuFH3meS2QWhOtOLmA7ZFYl9R/wvQwi1UoZN70mg+peRJ565Dq3/0GmBZ
         hiE1Wxs9KqVV3+msNPh6H3dQK3AiLXRl670WQTcNp3v/qQg+WRtkEoOkmDLix0voBC30
         Q6+puIlj1cO68FdcbwN8+y0nYyMV19SstBVcXCr0lgZPzauVp273AqUQzfcua/w++cIh
         fma7F+ml8F66/yipQB6c2MdQzcoZQ7jXwS8j5ADncUcZkHBEv/7g7ke/dL7KchEwFdaa
         jFYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yH4ULRCvH4cIDF7hD9SOh0HJDCpz6O0XU2vMhvkwdOE=;
        b=LVwavKy2j87GnoleWH0KKedQNoJpEZ1AWmDssfWEe4ofajHc7r/LORKISKck7Qx4Ac
         bexNI6WrTsbf/1i5aqUMpV+srxhcQO0A3SmGXdX8aNtKxq0Gt3t5sOgR1D4DT0L/O9Bn
         G/tvd7/wf779yJQtiY9SWtT08mnrDTjCfbvWrS7QGAjrjnM630V5Q4sZmGRhMhr/q/fw
         kMAoXvvBx2s1Zi8GJJQBliouWkiPt97JUBcM6BwIO3nmvUSNPYElq+uRpc+wIMYBaukv
         rIub/E7ywihWkYRqs8uKdr9fQ8yw7TC5W4nJDI/AUmEdBtUU6jD+wCDZFgcl/aLADy/L
         31MA==
X-Gm-Message-State: APjAAAVaTMjLx6lisv6HUTJ1feV3C+sM4fIskqMipCGCbaYHJu1HAOxn
        TvnkHFUbzkQK07u7JzuaS/+VcBrLd5dRwOjIuE8=
X-Google-Smtp-Source: APXvYqxBYVgdpErMAXSCI8pmoUIGY/wO9CBLiGd4fNVY01TGZK0ZF/ly0kg8E6SVOc6FFy6MoRusPEJoH8+GoAsAgys=
X-Received: by 2002:a05:6512:4c6:: with SMTP id w6mr3497249lfq.157.1579634205243;
 Tue, 21 Jan 2020 11:16:45 -0800 (PST)
MIME-Version: 1.0
References: <00000000000031a8d7059c27c540@google.com> <00000000000048111c059cab1695@google.com>
In-Reply-To: <00000000000048111c059cab1695@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 21 Jan 2020 11:16:33 -0800
Message-ID: <CAADnVQ+jS2C=TxPvyKJmoj7HENCZVr3O_N1tHQ4uTewPDUu0_A@mail.gmail.com>
Subject: Re: general protection fault in free_verifier_state (3)
To:     syzbot <syzbot+b296579ba5015704d9fa@syzkaller.appspotmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 21, 2020 at 11:05 AM syzbot
<syzbot+b296579ba5015704d9fa@syzkaller.appspotmail.com> wrote:
>
> syzbot has found a reproducer for the following crash on:
>
> HEAD commit:    2e3a94aa bpf: Fix memory leaks in generic update/delete ba..
> git tree:       bpf-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=15aefc6ee00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a736c99e9fe5a676
> dashboard link: https://syzkaller.appspot.com/bug?extid=b296579ba5015704d9fa
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10a4280de00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1411544ee00000

Since it's in the verifier I'm guessing it's related to some of my
earlier patches.
I'll try to take a look soon.
