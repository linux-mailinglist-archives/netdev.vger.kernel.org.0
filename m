Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5337A1C4B3C
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 03:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgEEBG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 21:06:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbgEEBGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 21:06:25 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D715C061A0F;
        Mon,  4 May 2020 18:06:25 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id z25so253433otq.13;
        Mon, 04 May 2020 18:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CdwxcUFpDpRXJQYQA4tNofTIdp6JTfVxZhsYvwhhuio=;
        b=nWAYyQPhoAediHBMdLD5YT5596BfKZq6FPTPVXsb1xqpqhfvtCdD1WEDWCr0xWVwWN
         x3FWG5i9v/O5cjy+6zhs7CGdQHkebZFOozOCgbpLp0vjLIr3Y9X7kxf8zsIvFUMYh2xI
         0KBXg6V61tVBxeSLF10nQW5EwFNiLBI5iTabGx6KphnnFdAXKI0wNo7YmxIogC0Wzd4D
         /tITPGjGT8aagOkGzgobTGFyaiVA3qPUotQbXXiG/qSDfcPAmO3Dj6At/MnJq+x8qv6V
         C3R0EsiPYuQq2KfVXEQpHu74XmAV2sz61TtVAVJMnE9rY4bjQlQxNp9Oz4dQ3e13OYrt
         VZOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CdwxcUFpDpRXJQYQA4tNofTIdp6JTfVxZhsYvwhhuio=;
        b=ucee1zRyjqIlN1LxRlouY3qeJsQIT5lXchfgIHkINTERaPlmBzlRZRRGOniFPh9qqj
         35XRGD0spMPyiUF50plW249Tl9hI2fpSf9YlF6xP6FVc5a7QqyXzga40G+RvlDHTRh7n
         rsl+r7FTlzLNO71FqsyNSPKrbCBJUktvXoTdBVonr6VjpfyGfi8kjHNApxfKHIoM6VQW
         R/+9yotnfwByDEtZqoKIm6Rxoe/Lmq3p4kclEtNY4XhmwnVNxrdM8GSFgTrQaDyqBolU
         pT4o2OhmNQGyUj95s4hVJaCdJhNWraIG4wiAYq2zeXe4kRdun9t6KRMXYsXXPUyoyqUt
         zYxA==
X-Gm-Message-State: AGi0PuYLWj0jcNNpgpOJx+IO7nO5CkKNu+MfiJkZ4tsWD0JtbdcUDzGY
        9k9YZDjCneINgW6symsl+0i753UHc2NaI2VEdgw=
X-Google-Smtp-Source: APiQypIeUyYLu4PyVWEwcNM4KHou+LK6yqrKBTIIm3x+Utq3dMUUOEn1pRhdtOx7zI5xQ14fOIU0eNEWBOrKMPKSoe4=
X-Received: by 2002:a9d:107:: with SMTP id 7mr648193otu.48.1588640784669; Mon,
 04 May 2020 18:06:24 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000005a8fe005a4b8a114@google.com> <20200504190348.iphzmd7micvidh46@treble>
In-Reply-To: <20200504190348.iphzmd7micvidh46@treble>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 4 May 2020 18:06:13 -0700
Message-ID: <CAM_iQpVu11xwKS5OEhDKmtbnP83oFNy9jBoAROS78-ECPEBWdw@mail.gmail.com>
Subject: Re: BUG: stack guard page was hit in unwind_next_frame
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     syzbot <syzbot+e73ceacfd8560cc8a3ca@syzkaller.appspotmail.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        shile.zhang@linux.alibaba.com,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86 <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 4, 2020 at 12:08 PM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
>
> On Sat, May 02, 2020 at 11:36:11PM -0700, syzbot wrote:
> > Hello,
> >
> > syzbot found the following crash on:
> >
> > HEAD commit:    8999dc89 net/x25: Fix null-ptr-deref in x25_disconnect
> > git tree:       net
> > console output: https://syzkaller.appspot.com/x/log.txt?x=16004440100000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=b7a70e992f2f9b68
> > dashboard link: https://syzkaller.appspot.com/bug?extid=e73ceacfd8560cc8a3ca
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> >
> > Unfortunately, I don't have any reproducer for this crash yet.
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+e73ceacfd8560cc8a3ca@syzkaller.appspotmail.com
>
> Infinite loop in network code.

It is not a loop, it is an unbound recursion where netdev events
trigger between bond master and slave back and forth.

Let me see how this can be fixed properly.

Thanks!
