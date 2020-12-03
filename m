Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4E72CCBAE
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 02:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729321AbgLCBaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 20:30:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbgLCBaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 20:30:46 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD00C061A4E;
        Wed,  2 Dec 2020 17:30:05 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id w16so378821pga.9;
        Wed, 02 Dec 2020 17:30:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HPKk+tPFsmMdDN5iQ46kW2RL6ZSfQqNJbnPD/mPsMrc=;
        b=HfU+zhOx69d7iK5vVRPOojleW7qvDg4p/gB8P5r9YntAAdV6R7P7mLwyn0HrqvTDDs
         Xh8+U+PkpgQFEaS9oEEKSAeirEokFS8xUIoyL2TitFsQj2N8TMFjYT2tGzMlm8My6YUB
         tRWFI9ZQOBjkpZrm0jqz6woxxUBL77m1s7IDVoPyU1E8UXBwDBFD648AIXE52/KRojW8
         ZUVV31zQZze3hXGGQFbv0gD9456C2Uo4wQmujBOTd0VvhdqK7lXy5AW4dlPxKmEbowR8
         9+6Z5scS8SggCnJLiu8QFMdNkHYnJFr1PiHxKS1wCt8n/iA+YGjh1h+By0PSQazoS+m6
         +wMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HPKk+tPFsmMdDN5iQ46kW2RL6ZSfQqNJbnPD/mPsMrc=;
        b=XaDAFw/+4PSyzz/Kw1csmMDBQeYY7xXI49XlA2JoU3LTCRj0N5EpQUUEH2TgsuLzeV
         T4bUHT8ILAwDYawe4NuxgNwcE5TX92WGGXRy2UYbQXTBnc3IfVoT7pbCeyx0b6wkNo2o
         BNwt+HvUJGDhay8ZXqRGoxA7tPJPgJhCiNLgxlNXGINgjyhv6LFLrewcjNzyYqMYRVxC
         G887xLEF5fD4gogh0YlrYaAID5M3IpSP54LEOyaNNSxxJ+qrSJIt6PJSgK1DMUwq9eB/
         7CkL0efKRtqIKU/WxRqw70U8zNUFpe1fdklw5Bm2ZkXJfqQmqO/3oecsfy7FhWd3pzs+
         KpYw==
X-Gm-Message-State: AOAM530gXWl1NNuWZvr7kXyIdpG0exnxdluxXVszz1VB+L0Jhz/593Zu
        RpjpQfERwsSQGItmT+IdteCu4/kWSlCRBb/RHUE=
X-Google-Smtp-Source: ABdhPJwhEye5IiIlQv+57VN2i/IUZSiNO4b16O1LrMDjos7RmAKLZlw9hMAIhAF+MGqBe9i9Bx/0klOJyfn2rMRtrjQ=
X-Received: by 2002:a63:4956:: with SMTP id y22mr937093pgk.266.1606959005381;
 Wed, 02 Dec 2020 17:30:05 -0800 (PST)
MIME-Version: 1.0
References: <20201201194438.37402-1-xiyou.wangcong@gmail.com> <20201202171032.029b1cd8@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201202171032.029b1cd8@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 2 Dec 2020 17:29:53 -0800
Message-ID: <CAM_iQpWfv59MoEJES1O=FhA4YsrB2nNGGaKzDmqcmXQXzc8gow@mail.gmail.com>
Subject: Re: [Patch net] lwt: disable BH too in run_lwt_bpf()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Dongdong Wang <wangdongdong@bytedance.com>,
        Thomas Graf <tgraf@suug.ch>, bpf@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 2, 2020 at 5:10 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue,  1 Dec 2020 11:44:38 -0800 Cong Wang wrote:
> > From: Dongdong Wang <wangdongdong@bytedance.com>
> >
> > The per-cpu bpf_redirect_info is shared among all skb_do_redirect()
> > and BPF redirect helpers. Callers on RX path are all in BH context,
> > disabling preemption is not sufficient to prevent BH interruption.
> >
> > In production, we observed strange packet drops because of the race
> > condition between LWT xmit and TC ingress, and we verified this issue
> > is fixed after we disable BH.
> >
> > Although this bug was technically introduced from the beginning, that
> > is commit 3a0af8fd61f9 ("bpf: BPF for lightweight tunnel infrastructure"),
> > at that time call_rcu() had to be call_rcu_bh() to match the RCU context.
> > So this patch may not work well before RCU flavor consolidation has been
> > completed around v5.0.
> >
> > Update the comments above the code too, as call_rcu() is now BH friendly.
> >
> > Cc: Thomas Graf <tgraf@suug.ch>
> > Cc: bpf@vger.kernel.org
> > Reviewed-by: Cong Wang <cong.wang@bytedance.com>
> > Signed-off-by: Dongdong Wang <wangdongdong@bytedance.com>
> > ---
> >  net/core/lwt_bpf.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/net/core/lwt_bpf.c b/net/core/lwt_bpf.c
> > index 7d3438215f32..4f3cb7c15ddf 100644
> > --- a/net/core/lwt_bpf.c
> > +++ b/net/core/lwt_bpf.c
> > @@ -39,12 +39,11 @@ static int run_lwt_bpf(struct sk_buff *skb, struct bpf_lwt_prog *lwt,
> >  {
> >       int ret;
> >
> > -     /* Preempt disable is needed to protect per-cpu redirect_info between
> > -      * BPF prog and skb_do_redirect(). The call_rcu in bpf_prog_put() and
> > -      * access to maps strictly require a rcu_read_lock() for protection,
> > -      * mixing with BH RCU lock doesn't work.
> > +     /* Preempt disable and BH disable are needed to protect per-cpu
> > +      * redirect_info between BPF prog and skb_do_redirect().
> >        */
> >       preempt_disable();
> > +     local_bh_disable();
>
> Why not remove the preempt_disable()? Disabling BH must also disable
> preemption AFAIK.

It seems RT kernel still needs preempt disable:
https://www.spinics.net/lists/kernel/msg3710124.html
but my RT knowledge is not sufficient to tell. So I just follow the
same pattern
in x86 FPU (as of today):

static inline void fpregs_lock(void)
{
        preempt_disable();
        local_bh_disable();
}

static inline void fpregs_unlock(void)
{
        local_bh_enable();
        preempt_enable();
}

There are other similar patterns in the current code base, so if this
needs a clean up, RT people can clean up them all together.

Thanks.
