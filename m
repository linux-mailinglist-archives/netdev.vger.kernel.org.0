Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B75BE18A33
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 15:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbfEINBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 09:01:48 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:44362 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbfEINBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 09:01:48 -0400
Received: by mail-io1-f67.google.com with SMTP id f22so1323485iol.11
        for <netdev@vger.kernel.org>; Thu, 09 May 2019 06:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JVx7ZoW5hiGrgUVoRycI1AsV20RlQNkbPPM427dqnNY=;
        b=BurrVXPKDJWGamfAcikJ+exlkR0IQkubcyg1vpSZCwjgF3pbzzvL6Q8D3b2+HG8l9x
         sKIws5nNnFOyoQU2CaLtmyJcYCDI5i9G1UyyRbhInThBu1DC1RbF5jopRm6vbqr08VdS
         L0mDxm+xSM2o1nQ7M1m+na6LrLoGDzZLrOHWh6woW5byBb+xJrnGXAhBBxuYFQSL+Mhb
         ZcmTdiaOk4gkNG0j95CXnypMaVHTbeglMvrxkzwR7eHXCgUBN6XkQMQg6eQMXgJUtTcE
         NkfCLKvWXqeOpRxi7rDVWLYbJBjqeie/uKPo5WDpJsNDVMrHLLZvI+ZgK2lah4k6y9ag
         X6Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JVx7ZoW5hiGrgUVoRycI1AsV20RlQNkbPPM427dqnNY=;
        b=h3RcOpX2MroxypjMvl0W0gtCP+gQJ+h9i+bKvRdAvCCx4L/01Mm+xkiMXc/ENeCZPc
         THNxekkOxXEYfAHWq42dei2hMOYg8bDGtEPHYAPfFJdXO6RcD1mwHi5JUSFy4DIGGSXF
         6mcF7sCNPaFOxKf2ocdv4OL/+wO3UbUSi6huMoehG5UGvnW/fvhfzAVcVmT5geieD1Zu
         k4ccvDw2YefKtezwdbb+6eB4U5n+8upW6AC0S+UuH9QLeUuxtizp5LEgq96CN5in9gFt
         tAM8duOL0GZo/hW/lZSdd/BqssmkA+kvhtxCgFCqw+sW5hySiqowQg/+lVzU9LzoE6ty
         0irw==
X-Gm-Message-State: APjAAAUMJS6d2OmDMPinNn+Lg59Xb3EJ2zLwalY+/95XKOCaygMAZBRV
        6JuYq20wK8AeljqFy4O3d3TyiBKxidSyKVdlMvhkNg==
X-Google-Smtp-Source: APXvYqxUuiBLctRM7HeT7BpLXNkcpVG5z/yekVPem8+j0eMDpqkFGqrhfxcubw3nDGgcOF5RhAMdHH+Zis/USw9PiwM=
X-Received: by 2002:a5e:d60f:: with SMTP id w15mr2152398iom.282.1557406907069;
 Thu, 09 May 2019 06:01:47 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000bc227a0582464e62@google.com> <0000000000003d44980584c6c82a@google.com>
 <BL0PR1501MB20033F21FB21816CC2F50AA49A5E0@BL0PR1501MB2003.namprd15.prod.outlook.com>
In-Reply-To: <BL0PR1501MB20033F21FB21816CC2F50AA49A5E0@BL0PR1501MB2003.namprd15.prod.outlook.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 9 May 2019 15:01:36 +0200
Message-ID: <CACT4Y+aYfsTVCo3U9VJcQ2X0456FPtTH+2Sqd_J93CXrqvQhkg@mail.gmail.com>
Subject: Re: WARNING: locking bug in icmp_send
To:     Jon Maloy <jon.maloy@ericsson.com>
Cc:     syzbot <syzbot+ba21d65f55b562432c58@syzkaller.appspotmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        "ying.xue@windriver.com" <ying.xue@windriver.com>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jon Maloy <jon.maloy@ericsson.com>
Date: Mon, Mar 25, 2019 at 5:34 PM
To: syzbot, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
syzkaller-bugs@googlegroups.com,
tipc-discussion@lists.sourceforge.net, ying.xue@windriver.com,
yoshfuji@linux-ipv6.org

> Yet another duplicate of  syzbot+a25307ad099309f1c2b9@syzkaller.appspotmail.com
>
> A fix has been posted.
>
> ///jon

Let's close this too:

#syz fix: tipc: change to check tipc_own_id to return in tipc_net_stop

> > -----Original Message-----
> > From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org>
> > On Behalf Of syzbot
> > Sent: 23-Mar-19 19:03
> > To: davem@davemloft.net; Jon Maloy <jon.maloy@ericsson.com>;
> > kuznet@ms2.inr.ac.ru; linux-kernel@vger.kernel.org;
> > netdev@vger.kernel.org; syzkaller-bugs@googlegroups.com; tipc-
> > discussion@lists.sourceforge.net; ying.xue@windriver.com; yoshfuji@linux-
> > ipv6.org
> > Subject: Re: WARNING: locking bug in icmp_send
> >
> > syzbot has bisected this bug to:
> >
> > commit 52dfae5c85a4c1078e9f1d5e8947d4a25f73dd81
> > Author: Jon Maloy <jon.maloy@ericsson.com>
> > Date:   Thu Mar 22 19:42:52 2018 +0000
> >
> >      tipc: obtain node identity from interface by default
> >
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11b6dc5d200000
> > start commit:   b5372fe5 exec: load_script: Do not exec truncated interpre..
> > git tree:       upstream
> > final crash:    https://syzkaller.appspot.com/x/report.txt?x=13b6dc5d200000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=15b6dc5d200000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=7132344728e7ec3f
> > dashboard link:
> > https://syzkaller.appspot.com/bug?extid=ba21d65f55b562432c58
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14c90fa7400000
> >
> > Reported-by: syzbot+ba21d65f55b562432c58@syzkaller.appspotmail.com
> > Fixes: 52dfae5c85a4 ("tipc: obtain node identity from interface by default")
> >
> > For information about bisection process see:
> > https://goo.gl/tpsmEJ#bisection
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/BL0PR1501MB20033F21FB21816CC2F50AA49A5E0%40BL0PR1501MB2003.namprd15.prod.outlook.com.
> For more options, visit https://groups.google.com/d/optout.
