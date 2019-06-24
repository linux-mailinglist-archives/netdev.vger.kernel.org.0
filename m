Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F84A50949
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 12:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729351AbfFXKyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 06:54:39 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:45603 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728616AbfFXKyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 06:54:39 -0400
Received: by mail-io1-f65.google.com with SMTP id e3so510410ioc.12
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 03:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yvdMwkq9kuI2sDIx3QKOUTZy+R8mh2VJCHVGv1QYqB4=;
        b=hcnlKm6i5GqDrXUr6P2g5Fk27msTNikgjZMhHjv4nax2XzMdhJ+2m2RwInyveVXB7o
         m06xwgRax1aNAm/VgGWdi9muU7UvC9pf7K6/vYoergAkIiQvb8jWMfWMnCFzQ6WdH8c6
         OCQFOh9HDAx5q6DWfsn8ACfDBiWaS2Grw/M6SfwixpO/zAlqZGC39j6kxGlet3QRQmFn
         bMXSdhfQuyXKQNGkLmo764b449ZHYQtS+kJ4m21o8NGTp0FbQhae6tT4Wjv4lJKYKarJ
         2y5TItNNQWww9/A3TqHJLT3cnwbv2ljPq7P+L5iH4j/9Ys0MGR71iMAcX/eGTFotIBpC
         PuaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yvdMwkq9kuI2sDIx3QKOUTZy+R8mh2VJCHVGv1QYqB4=;
        b=kyYc+44uSe2GQxnq+IQ1mJzOy5kgedgHyjPu0g2W5Iw9Zh5/TFo4pqohk3Wb1uRcUj
         uqZxL3kjPXjmN8txtiEQu4zY8+R4GchY6yYpIc2tc/dk8Gqjnw5KQp73VY/Pxi58bCnO
         bMdtfvpe2N636M4ItxkZfjKwj1T0runbCqkHdTKwx3bTAgu5tZ8pMWSwtWQtODFDIrCl
         k3R1MsTl2n1OMN02GRRIHqpPqIui9G/ue1OM/qdXCiYQYcD7pVhl5lh6jYJgEbH1q6WS
         abiFbPLkqHKIZnycts0ZQ91RcUOHNGk+sWoSoJgsygSJHByeFkMFUPRyY32IScIzoNst
         VBSg==
X-Gm-Message-State: APjAAAUMT4kZGcpH2sCs3H2O/deJhWUEnhtslSdbUMAGyHxpo1H6Wpqb
        GwHRqxNNrjozPgNXSlKNXxLA18cYdCu3aVVif2mdIQ==
X-Google-Smtp-Source: APXvYqz/4lEop8zPzP0IRk55Anzi8uao/p42JXWpmclmQcnINvPJlyxlWzgtssZzhHnZAGF5a+qPi2FpQh5G5Cn7kwE=
X-Received: by 2002:a6b:fb0f:: with SMTP id h15mr37035083iog.266.1561373678104;
 Mon, 24 Jun 2019 03:54:38 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000d6a8ba058c0df076@google.com> <alpine.DEB.2.21.1906241130100.32342@nanos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.21.1906241130100.32342@nanos.tec.linutronix.de>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 24 Jun 2019 12:54:25 +0200
Message-ID: <CACT4Y+Y_TadXGE_CVFa4fKqrbpAD4i5WGem9StgoyP_YAVraXw@mail.gmail.com>
Subject: Re: WARNING: ODEBUG bug in netdev_freemem (2)
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     syzbot <syzbot+c4521ac872a4ccc3afec@syzkaller.appspotmail.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        amritha.nambiar@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        David Miller <davem@davemloft.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ido Schimmel <idosch@mellanox.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        tyhicks@canonical.com, wanghai26@huawei.com, yuehaibing@huawei.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 11:34 AM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> On Mon, 24 Jun 2019, syzbot wrote:
>
> > Hello,
> >
> > syzbot found the following crash on:
> >
> > HEAD commit:    fd6b99fa Merge branch 'akpm' (patches from Andrew)
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=144de256a00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=fa9f7e1b6a8bb586
> > dashboard link: https://syzkaller.appspot.com/bug?extid=c4521ac872a4ccc3afec
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> >
> > Unfortunately, I don't have any reproducer for this crash yet.
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+c4521ac872a4ccc3afec@syzkaller.appspotmail.com
> >
> > device hsr_slave_0 left promiscuous mode
> > team0 (unregistering): Port device team_slave_1 removed
> > team0 (unregistering): Port device team_slave_0 removed
> > bond0 (unregistering): Releasing backup interface bond_slave_1
> > bond0 (unregistering): Releasing backup interface bond_slave_0
> > bond0 (unregistering): Released all slaves
> > ------------[ cut here ]------------
> > ODEBUG: free active (active state 0) object type: timer_list hint:
> > delayed_work_timer_fn+0x0/0x90 arch/x86/include/asm/paravirt.h:767
>
> One of the cleaned up devices has left an active timer which belongs to a
> delayed work. That's all I can decode out of that splat. :(

Hi Thomas,

If ODEBUG would memorize full stack traces for object allocation
(using lib/stackdepot.c), it would make this splat actionable, right?
I've fixed https://bugzilla.kernel.org/show_bug.cgi?id=203969 for this.
