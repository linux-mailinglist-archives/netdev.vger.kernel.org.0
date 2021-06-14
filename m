Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E883E3A68EC
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 16:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234444AbhFNO1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 10:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232809AbhFNO1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 10:27:20 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55C58C061766;
        Mon, 14 Jun 2021 07:25:17 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id p17so21407130lfc.6;
        Mon, 14 Jun 2021 07:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lKRSk5HzbOmXuCA3rliZmeLLBLcB5mMmfL/kTP5W7uo=;
        b=HbMu/AK0B3ZfYZGiK5bqwr12vcZCA4Wfjhr3rxx6x4APBSV5+cOcztbmz4h5XipUdL
         MhyYGmxgkp9icxgpqfvhZt5G/HyEBlVLbaFbNDonII4Bjh4ELvWIMtUjSj7AHco8rlUt
         D4GVfGRX6NZl3JLyPa7hbtokhQlnFj25aGZhi5+zWRAsrIYc7kRcaW4CS3TwYubyBV9T
         n1AZtghp3yzkw3muaYmf1ZqIBw7NqRG3rW8kMjS4YxPEnW6r794JlDrYZCKIvfPzC8Sa
         c28L1eLRnhEhsJazcJjbriUBxugYbTvN1Zal+/7mOqwxT0ITT5eOmcRDNnP9TrClphXb
         HPjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lKRSk5HzbOmXuCA3rliZmeLLBLcB5mMmfL/kTP5W7uo=;
        b=qUh+W/20i5Tj12ZF+ZlFIv2yypOPXWaKj7rsdFxe3sq4J79PJ4wH8mVIVZmDf0hXXh
         UsIRWtQDJlyZxI+bIe/PM5LKxfAUct1Yo+kU/oAidheMh/vkuHyYPnVE27LDLhhRY6gi
         gPabXmMIg1+exQrnSM5RQsdw83hGUyg66uJGN6BfGavqYsYBHS9MVXwteYYusQmqmiqT
         K7QI4qFBJbJ1InhLym02VDaJgInDefGfNgPXFYN8/uZP/7toP9Glzfx0nXa9ti3rO1hy
         8WyjXzkRvfY+xVaJPPzM1ziX3C4y9GpVW+bCC7U+WhE3jfbY3NWeuLHow0B+xSpBA/ws
         QotQ==
X-Gm-Message-State: AOAM531eOF+YtLoaFEFdU9srWT2NaPQIcM/rtKoSUDGpj3qviFuxtkdM
        oDnC1pBzk1h94Md9TPhQWUo=
X-Google-Smtp-Source: ABdhPJz0cLTrRyc7MvmhGfJeBleE0yG9ThwWkjdAMqFhKJLurHNe6u0i14XCh5e9VyDIYl8Ns74Atg==
X-Received: by 2002:a05:6512:ba3:: with SMTP id b35mr1580844lfv.7.1623680715685;
        Mon, 14 Jun 2021 07:25:15 -0700 (PDT)
Received: from localhost.localdomain ([94.103.229.24])
        by smtp.gmail.com with ESMTPSA id z16sm1498670lfs.24.2021.06.14.07.25.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 07:25:15 -0700 (PDT)
Date:   Mon, 14 Jun 2021 17:25:12 +0300
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     alex.aring@gmail.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        stefan@datenfreihafen.org,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        syzbot+b80c9959009a9325cdff@syzkaller.appspotmail.com,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: Suggestions on how to debug kernel crashes where printk and gdb
 both does not work
Message-ID: <20210614172512.799db10d@gmail.com>
In-Reply-To: <CAD-N9QV5_91A6n5QcrafmQRbqH_qzFRatno-6z0i7q-V9VnLzg@mail.gmail.com>
References: <CAD-N9QUUCSpZjg5RwdKBNF7xx127E6fUowTZkUhm66C891Fpkg@mail.gmail.com>
        <20210614163401.52807197@gmail.com>
        <CAD-N9QV5_91A6n5QcrafmQRbqH_qzFRatno-6z0i7q-V9VnLzg@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Jun 2021 22:19:10 +0800
Dongliang Mu <mudongliangabcd@gmail.com> wrote:

> On Mon, Jun 14, 2021 at 9:34 PM Pavel Skripkin <paskripkin@gmail.com>
> wrote:
> >
> > On Mon, 14 Jun 2021 21:22:43 +0800
> > Dongliang Mu <mudongliangabcd@gmail.com> wrote:
> >
> > > Dear kernel developers,
> > >
> > > I was trying to debug the crash - memory leak in hwsim_add_one [1]
> > > recently. However, I encountered a disgusting issue: my
> > > breakpoint and printk/pr_alert in the functions that will be
> > > surely executed do not work. The stack trace is in the following.
> > > I wrote this email to ask for some suggestions on how to debug
> > > such cases?
> > >
> > > Thanks very much. Looking forward to your reply.
> > >
> >
> > Hi, Dongliang!
> >
> > This bug is not similar to others on the dashboard. I spent some
> > time debugging it a week ago. The main problem here, that memory
> > allocation happens in the boot time:
> >
> > > [<ffffffff84359255>] kernel_init+0xc/0x1a7 init/main.c:1447
> >
> 
> Oh, nice catch. No wonder why my debugging does not work. :(
> 
> > and reproducer simply tries to
> > free this data. You can use ftrace to look at it. Smth like this:
> >
> > $ echo 'hwsim_*' > $TRACE_DIR/set_ftrace_filter
> 
> Thanks for your suggestion.
> 
> Do you have any conclusions about this case? If you have found out the
> root cause and start writing patches, I will turn my focus to other
> cases.

No, I had some busy days and I have nothing about this bug for now.
I've just traced the reproducer execution and that's all :)

I guess, some error handling paths are broken, but Im not sure 
 

> 
> BTW, I only found another possible memory leak after some manual code
> review [1]. However, it is not the root cause for this crash.
> 
> [1] https://lkml.org/lkml/2021/6/10/1297
> 
> >
> > would work.
> >
> >
> > With regards,
> > Pavel Skripkin




With regards,
Pavel Skripkin
