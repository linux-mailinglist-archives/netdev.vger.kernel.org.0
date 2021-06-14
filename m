Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F19E3A6945
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 16:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233057AbhFNOur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 10:50:47 -0400
Received: from mail-lj1-f176.google.com ([209.85.208.176]:40827 "EHLO
        mail-lj1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232875AbhFNOui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 10:50:38 -0400
Received: by mail-lj1-f176.google.com with SMTP id x14so20519600ljp.7;
        Mon, 14 Jun 2021 07:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lM05KvIv1j/pV1PSbzENxv/91mH5aJpm+cLZAmrkR2g=;
        b=SxhBYOtYm0RJHNdT8zx+1gcaPThONE2p1Z+UFp5Y9Y2Bep6JxdBjwHI5QU1QxAcu2t
         OD+Yv5o03/0caxpQLYOO8Vcxm8NLg7GOqO+qpLXW9NuSLynluXXn8FteXUg/QlFkg9A8
         RAgNpoPmbQG6fTbiMLyMbdEKs7cPTMhYkyqAlstpbiPN2UxEEyRtri3kicchp62g68JO
         EGjQ28vnf3ya5ldoAGYjgpYKJucCbQ7cXrqrPWEfcvlIPFRe3QSbzRZxnPCrc7HEkh2c
         258PxMMomM+nua3dvHmRPeDMjbavGz47XpNbJP5gbg9Y/JuSGXmVhQsKCOCfYBZQYdgL
         BTeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lM05KvIv1j/pV1PSbzENxv/91mH5aJpm+cLZAmrkR2g=;
        b=Dtu7Pq+7XJ7yk1gQAbgZ+vaabVUOux+H3QIFukzLVWr83XBGFWKWpucEbmJQU3RxNq
         KXb02rA8kiyCCrddozKO8Ma5jlJUi3pNNlO8Vso5oYDC/LrSzvQpFkr0uHVNCboGFJDe
         vTFXWMzxSbrc6Gz1t++JRDN/fQLP3LvEjNllGV70DpDAZ/vY/V+KhowHToMuUqH6PRvI
         TcmC3f4h5L4ZWld+rSICp6gtJywtn3+o3wEQNfU2W4sfwPzTP1Ul74hBIXVvXcdDKjlM
         iZcEZ2DbuBz6lcQ0vOGVXEgCq/VZBKTdFOv0de1cPHEjiwib2UWq1obe45Sfo+uuuwxR
         l0wA==
X-Gm-Message-State: AOAM532/Y9KOCG9qrYxSftIaxKBpsWgWb7lq2lLCChemXR+6SNfb1Z1r
        eO6EGPhwd+7CxGHDeKlojhw=
X-Google-Smtp-Source: ABdhPJzfFWuHrL5QAU0bW9cV1qIGISwEJA3hdr+8J7J/FjJZkcWwo83kc3ohJUuGsQasWn9giJ6CTw==
X-Received: by 2002:a2e:9855:: with SMTP id e21mr14624487ljj.295.1623682051507;
        Mon, 14 Jun 2021 07:47:31 -0700 (PDT)
Received: from localhost.localdomain ([94.103.229.24])
        by smtp.gmail.com with ESMTPSA id bn27sm1806449ljb.110.2021.06.14.07.47.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 07:47:31 -0700 (PDT)
Date:   Mon, 14 Jun 2021 17:47:27 +0300
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
Message-ID: <20210614174727.6a38b584@gmail.com>
In-Reply-To: <CAD-N9QUhQT8pG8Une8Fac1pJaiVd_mi9AU2c_nkPjTi36xbutQ@mail.gmail.com>
References: <CAD-N9QUUCSpZjg5RwdKBNF7xx127E6fUowTZkUhm66C891Fpkg@mail.gmail.com>
        <20210614163401.52807197@gmail.com>
        <CAD-N9QV5_91A6n5QcrafmQRbqH_qzFRatno-6z0i7q-V9VnLzg@mail.gmail.com>
        <20210614172512.799db10d@gmail.com>
        <CAD-N9QUhQT8pG8Une8Fac1pJaiVd_mi9AU2c_nkPjTi36xbutQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Jun 2021 22:40:55 +0800
Dongliang Mu <mudongliangabcd@gmail.com> wrote:

> On Mon, Jun 14, 2021 at 10:25 PM Pavel Skripkin
> <paskripkin@gmail.com> wrote:
> >
> > On Mon, 14 Jun 2021 22:19:10 +0800
> > Dongliang Mu <mudongliangabcd@gmail.com> wrote:
> >
> > > On Mon, Jun 14, 2021 at 9:34 PM Pavel Skripkin
> > > <paskripkin@gmail.com> wrote:
> > > >
> > > > On Mon, 14 Jun 2021 21:22:43 +0800
> > > > Dongliang Mu <mudongliangabcd@gmail.com> wrote:
> > > >
> > > > > Dear kernel developers,
> > > > >
> > > > > I was trying to debug the crash - memory leak in
> > > > > hwsim_add_one [1] recently. However, I encountered a
> > > > > disgusting issue: my breakpoint and printk/pr_alert in the
> > > > > functions that will be surely executed do not work. The stack
> > > > > trace is in the following. I wrote this email to ask for some
> > > > > suggestions on how to debug such cases?
> > > > >
> > > > > Thanks very much. Looking forward to your reply.
> > > > >
> > > >
> > > > Hi, Dongliang!
> > > >
> > > > This bug is not similar to others on the dashboard. I spent some
> > > > time debugging it a week ago. The main problem here, that memory
> > > > allocation happens in the boot time:
> > > >
> > > > > [<ffffffff84359255>] kernel_init+0xc/0x1a7 init/main.c:1447
> > > >
> > >
> > > Oh, nice catch. No wonder why my debugging does not work. :(
> > >
> > > > and reproducer simply tries to
> > > > free this data. You can use ftrace to look at it. Smth like
> > > > this:
> > > >
> > > > $ echo 'hwsim_*' > $TRACE_DIR/set_ftrace_filter
> > >
> > > Thanks for your suggestion.
> > >
> > > Do you have any conclusions about this case? If you have found
> > > out the root cause and start writing patches, I will turn my
> > > focus to other cases.
> >
> > No, I had some busy days and I have nothing about this bug for now.
> > I've just traced the reproducer execution and that's all :)
> >
> > I guess, some error handling paths are broken, but Im not sure
> 
> In the beginning, I agreed with you. However, after I manually checked
> functions: hwsim_probe (initialization) and  hwsim_remove (cleanup),
> then things may be different. The cleanup looks correct to me. I would
> like to debug but stuck with the debugging process.
> 
> And there is another issue: the cleanup function also does not output
> anything or hit the breakpoint. I don't quite understand it since the
> cleanup is not at the boot time.
> 
> Any idea?
> 

Output from ftrace (syzkaller repro):

root@syzkaller:~# cat /sys/kernel/tracing/trace
# tracer: function_graph
#
# CPU  DURATION                  FUNCTION CALLS
# |     |   |                     |   |   |   |
 1)               |  hwsim_del_radio_nl() {
 1)               |    hwsim_del() {
 1)               |      hwsim_edge_unsubscribe_me() {
 1) ! 310.041 us  |        hwsim_free_edge();
 1) ! 665.221 us  |      }
 1) * 52999.05 us |    }
 1) * 53035.38 us |  }

Cleanup function is not the case, I think :)



With regards,
Pavel Skripkin
