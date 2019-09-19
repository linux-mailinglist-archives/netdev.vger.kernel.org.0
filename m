Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14D5CB813C
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 21:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392326AbfISTN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 15:13:59 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:44090 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390859AbfISTN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 15:13:59 -0400
Received: by mail-pl1-f195.google.com with SMTP id q15so2033585pll.11
        for <netdev@vger.kernel.org>; Thu, 19 Sep 2019 12:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W5DGy7JzEyGPCwlKkv2bH+TeKMC3s+WOSUvOMWryOKo=;
        b=CZGSHDsyChkg94i3PwCNrEuh54m2C9yWMOe+Ot5zxXF6gWdfk2VSYvB0LXvhnxNFZZ
         f3xT+E/yWSrvRIJkQ02VqcP0WdaPlC+2LOoT4X4UMRjKTWtHAXkTH5s/D39V2/LU9sTC
         6MVeaZWfxVv1gBEq30XNe+RiLQh8bhzdFVHUA1y3V4ozMIgrkbFsRbjhFPH7FBOXnHJN
         VcYUiAoYj926VD9YVBIaHuXq6oeSdv6RJ3382aHKo9XOZANwBWGxsc6C6TZtJXvG0JwV
         jgqWeaOcitouwqUc6TS6/MkxYtK69oY4kCm2VQ/qujpUycX4l3aCXg73jmDZg2+DXVyC
         0E0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W5DGy7JzEyGPCwlKkv2bH+TeKMC3s+WOSUvOMWryOKo=;
        b=NBW1yLZKqkQ0LRRtheFZO1STXfO3gMMeQu9rY2icstemD9C8h3bt/XpaNxU8te1UIP
         vwq0IjumtnZ+PNyKqnNZUtSTtr06+JP+luJTcA831wzL6BzxnCKoCW/mw1fm/JLJ/I+S
         rbDSwK5/qvoo8CC8fzBzCBPA+VCLZakG5rUexE+TQFq6PV0q9QR5wfkpQ/HSt4KRENXs
         1Zs1AP1v29zqyxd4m5vQtgYiegOOk1uv8Litt9J1XFbss/mnV0MsGgHZP9XISC8G5wqE
         lWBL1sbVR1XWFkgVqtI9ysihXhGrlnXKKNkHJzUak4/0zrCeqmYpctKLLNXRNJgg4OAU
         IoIg==
X-Gm-Message-State: APjAAAXOcG4krqgQsEZA5Ds4s1iJoAYrfU5vY9TvCPJg1wAoZqzNeOE+
        qvC31ccN+/G0oVdIrSSEMRPgnzsj4AkIXdAG4QE=
X-Google-Smtp-Source: APXvYqzvVu0gMDS7qsipBBTDp0Mj8hH7AYBd71WN6kvnfWhvG3+yJK3aEx259hya/f3eXG2KFewaF6ayGZyrUkKEICY=
X-Received: by 2002:a17:902:a586:: with SMTP id az6mr11959180plb.12.1568920438031;
 Thu, 19 Sep 2019 12:13:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190918073201.2320-1-vladbu@mellanox.com> <CAM_iQpX6RAmf4oXLLJnhYpaXX4g7MUmZ33GZgwrYaiPLBGxmYw@mail.gmail.com>
 <vbfy2ykk6ps.fsf@mellanox.com>
In-Reply-To: <vbfy2ykk6ps.fsf@mellanox.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 19 Sep 2019 12:13:46 -0700
Message-ID: <CAM_iQpUoOr_mPkOYQ5TdUCPCSRftdnTNDSAoNziX-U88E3JxMw@mail.gmail.com>
Subject: Re: [PATCH net 0/3] Fix Qdisc destroy issues caused by adding
 fine-grained locking to filter API
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 19, 2019 at 1:53 AM Vlad Buslov <vladbu@mellanox.com> wrote:
>
>
> On Thu 19 Sep 2019 at 01:50, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > On Wed, Sep 18, 2019 at 12:32 AM Vlad Buslov <vladbu@mellanox.com> wrote:
> >>
> >> TC filter API unlocking introduced several new fine-grained locks. The
> >> change caused sleeping-while-atomic BUGs in several Qdiscs that call cls
> >> APIs which need to obtain new mutex while holding sch tree spinlock. This
> >> series fixes affected Qdiscs by ensuring that cls API that became sleeping
> >> is only called outside of sch tree lock critical section.
> >
> > Sorry I just took a deeper look. It seems harder than just moving it
> > out of the critical section.
> >
> > qdisc_destroy() calls ops->reset() which usually purges queues,
> > I don't see how it is safe to move it out of tree spinlock without
> > respecting fast path.
> >
> > What do you think?
>
> Hmm, maybe we can split qdisc destruction in two stage process for
> affected qdiscs? Rough sketch:
>
> 1. Call qdisc_reset() (or qdisc_purge_queue()) on qdisc that are being
>    deleted under sch tree lock protection.
>
> 2. Call new qdisc_put_empty() function after releasing the lock. This
>    function would implement same functionality as a regular qdisc_put()
>    besides resetting the Qdisc and freeing skb in its queues (already
>    done by qdisc_reset())
>
> In fact, affected queues already do the same or something similar:
>
> - htb_change_class() calls qdisc_purge_queue() that calls qdisc_reset(),
>   which makes reset inside qdisc_destroy() redundant.
>
> - multiq_tune() calls qdisc_tree_flush_backlog() that has the same
>   implementation as qdisc_purge_queue() minus actually resetting the
>   Qdisc. Can we substitute first function with the second one here?
>
> - sfb_change() - same as multiq_tune().
>
> Do you think that would work?

I think they have to call qdisc_purge_queue() or whatever that calls
qdisc_reset() to reset all queues including qdisc->gso_skb and
qdisc->skb_bad_txq before releasing sch tree lock.

qdisc_tree_flush_backlog() is not sufficient.
