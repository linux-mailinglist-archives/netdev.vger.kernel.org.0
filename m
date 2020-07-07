Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3532521781D
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 21:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728224AbgGGTly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 15:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727834AbgGGTlx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 15:41:53 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F25C061755
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 12:41:53 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id q74so20907857iod.1
        for <netdev@vger.kernel.org>; Tue, 07 Jul 2020 12:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HiN+pHTCRHzTLPcXcBTqAJaXXSDdqcq64hPv2IZBZ3w=;
        b=cOX13lIiDxW9Wr9t4FN46oONTv56oYG5I4dk7zxUcCWlbbjs8shr2JAFs8wxhz3D5x
         OJJSZ3R8MJ9w/+lcQ9VMu2tvsSR7MDb562dz9msiWJyFCOKtsbPZw00qvpND68KIDIic
         gZuQa5+H2dtEJnv76QDDz8rQWjkiaKN9Usm9ffgSVoLJZEGAxgID43X6HVl1jczs28rB
         V9CGtzZ5prRybQWBSYQV5NJzBlS21YeL6QDuOmGlRdAKxTfRAukzYfM2UQW+A2w9rT0B
         je6cqj0ngjhh/XazJ8xxwJ02bFe1Yz7i37o+AuwIsZZQKEfsMmFhWTJ6CTnKwx8DbwIF
         mjgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HiN+pHTCRHzTLPcXcBTqAJaXXSDdqcq64hPv2IZBZ3w=;
        b=Dzdd8Fstg+lkIC//stMKdETfQTSPG+3L2B+sCO0DsxEU39pxezoUFccLlWRbzzTUs0
         rFXyLf5EnxvmMb/2EjBOZ+PwN/XbWpuvCApB1YMgod0BfsJl2tgONv7aTG5ocfMtQ+tt
         hqlsY9hl0xt90wonGD/TVBwI7+B1TD4FPu3pABrRbhOzMq/8qnBT72o0FN0g+MIBjuuP
         ZWkN2tx8I4rWKKJevYKg5cXX27lOC1zU/VS2SRUoegh5HVpudXy6w0DbaaEX5bBvN2I2
         VghDNfRmJKfaFk9RRfJxNbpSSpcjmWnSZamVBcHNM+P+94AKE2O8VpkbF5wkHMqApf2Z
         Pw+Q==
X-Gm-Message-State: AOAM530jSCXEB9XKeURjARLdJUnB7m4DrJn41oBZMPDx9QGB67WQcEek
        1IJ/tKUYAUhkzSeDupnngDtRqs7xUukhEofx6Yk=
X-Google-Smtp-Source: ABdhPJxq8UmnAxXofOVNCZZpBTxCw6GT0SbDxwKFH1ttbI9poA9869jFgKAY5AY/U1YxLfWHCMnBDEYRCJ7juHWnbVY=
X-Received: by 2002:a5e:c311:: with SMTP id a17mr3457320iok.12.1594150912374;
 Tue, 07 Jul 2020 12:41:52 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1593209494.git.petrm@mellanox.com> <643ef0859371d3bf6280f5014d668fb18b3b6d85.1593209494.git.petrm@mellanox.com>
 <CAM_iQpUEAt_0Kr1vVfRrpMPz+2arpLA5g4yfWCLe2fhbMTrH7w@mail.gmail.com> <878sfvibzf.fsf@mellanox.com>
In-Reply-To: <878sfvibzf.fsf@mellanox.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 7 Jul 2020 12:41:41 -0700
Message-ID: <CAM_iQpV34xi_4G-OeJpTyuXWAmr9S=uiknUa=-f_kvwawOp49w@mail.gmail.com>
Subject: Re: [PATCH net-next v1 1/5] net: sched: Pass root lock to Qdisc_ops.enqueue
To:     Petr Machata <petrm@mellanox.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 7, 2020 at 8:25 AM Petr Machata <petrm@mellanox.com> wrote:
>
>
> Cong Wang <xiyou.wangcong@gmail.com> writes:
>
> > On Fri, Jun 26, 2020 at 3:46 PM Petr Machata <petrm@mellanox.com> wrote:
> >>
> >> A following patch introduces qevents, points in qdisc algorithm where
> >> packet can be processed by user-defined filters. Should this processing
> >> lead to a situation where a new packet is to be enqueued on the same port,
> >> holding the root lock would lead to deadlocks. To solve the issue, qevent
> >> handler needs to unlock and relock the root lock when necessary.
> >>
> >> To that end, add the root lock argument to the qdisc op enqueue, and
> >> propagate throughout.
> >
> > Hmm, but why do you pass root lock down to each ->enqueue()?
> >
> > You can find root lock with sch_tree_lock() (or qdisc_lock() if you don't
> > care about hierarchy), and you already have qdisc as a parameter of
> > tcf_qevent_handle().
>
> I know, I wanted to make it clear that the lock may end up being used,
> instead of doing it "stealthily". If you find this inelegant I can push
> a follow-up that converts tcf_qevent_handle() to sch_tree_unlock().

So far only sch_red uses tcf_qevent_handle(), changing the rest
qdisc's just for sch_red seems overkill here.

Of course, if we could eliminate the root lock release, all the pains
would go away.

Thanks.
