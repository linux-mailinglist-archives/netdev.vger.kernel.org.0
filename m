Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7A6BBABB4
	for <lists+netdev@lfdr.de>; Sun, 22 Sep 2019 22:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391307AbfIVUgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Sep 2019 16:36:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46244 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729329AbfIVUgE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Sep 2019 16:36:04 -0400
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A877C36955
        for <netdev@vger.kernel.org>; Sun, 22 Sep 2019 20:36:03 +0000 (UTC)
Received: by mail-qt1-f198.google.com with SMTP id 59so15203167qtc.5
        for <netdev@vger.kernel.org>; Sun, 22 Sep 2019 13:36:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YSXaA2r9qU9Te2gXXHNcuvMEJHQJhJAAUl9iW1zQXc4=;
        b=tEtKCTV4RLsqLe5SqsS1Vpzjzf+Sf6v2K9LrNHCFQhkMgDjXRJhs1wOFdsRYdjbPrZ
         ytB+d0Q8s8IuAdPCvF3VJaCzAZ1MChPwvr12+s7dhi6aL8JyaF1yBu6lAPklCYUDwWhV
         /tGB8U1vRIH7HTtDmmzEr8BlGnz7VYl1afcdsk6I0c60NzStTkhyHZhJVedSUWRPOhNg
         8gmbYDkFpnEac8imDATRmGO7JqaSykpmejePhbHddR53K1Yi9eojVUrHWYhucI/3Ut/2
         A5QofM8zK4ptFjUCbRq6nFk6rmMuFwyODVoT8cx5dTV+Eyw5qKz1EhqfIJgD8dxJng95
         azRg==
X-Gm-Message-State: APjAAAWPoGLrDa4xqoZCtlXxWl/A3jtzZNdU4zwBb+TwyPhfEERLendn
        oME0lxhLpYkR1uu5AcHU+p2+6VUQpqCt8uJF/Hz6MnbI7nicdvq9zgW/rIdNLthuiKPmrDKXSEA
        E7R21f6QN475CBycM
X-Received: by 2002:ac8:5143:: with SMTP id h3mr13919777qtn.26.1569184562926;
        Sun, 22 Sep 2019 13:36:02 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz5Sp0rHpG3ieulHzbVOe9YMjO68HR9+bn23l2wjHc5HwBB++7sZJ5HX3cDnJ2rF8gF9YEK/Q==
X-Received: by 2002:ac8:5143:: with SMTP id h3mr13919765qtn.26.1569184562714;
        Sun, 22 Sep 2019 13:36:02 -0700 (PDT)
Received: from redhat.com (bzq-79-176-40-226.red.bezeqint.net. [79.176.40.226])
        by smtp.gmail.com with ESMTPSA id 44sm5107705qtu.45.2019.09.22.13.35.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Sep 2019 13:36:01 -0700 (PDT)
Date:   Sun, 22 Sep 2019 16:35:54 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Matt Cover <werekraken@gmail.com>
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        Jason Wang <jasowang@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Matthew Cover <matthew.cover@stackpath.com>,
        mail@timurcelik.de, pabeni@redhat.com,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        wangli39@baidu.com, lifei.shirley@bytedance.com,
        tglx@linutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH net-next] tuntap: Fallback to automq on
 TUNSETSTEERINGEBPF prog negative return
Message-ID: <20190922162546-mutt-send-email-mst@kernel.org>
References: <20190920185843.4096-1-matthew.cover@stackpath.com>
 <20190922080326-mutt-send-email-mst@kernel.org>
 <CAGyo_hqGbFdt1PoDrmo=S5iTO8TwbrbtOJtbvGT1WrFFMLwk-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGyo_hqGbFdt1PoDrmo=S5iTO8TwbrbtOJtbvGT1WrFFMLwk-Q@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 22, 2019 at 10:43:19AM -0700, Matt Cover wrote:
> On Sun, Sep 22, 2019 at 5:37 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Fri, Sep 20, 2019 at 11:58:43AM -0700, Matthew Cover wrote:
> > > Treat a negative return from a TUNSETSTEERINGEBPF bpf prog as a signal
> > > to fallback to tun_automq_select_queue() for tx queue selection.
> > >
> > > Compilation of this exact patch was tested.
> > >
> > > For functional testing 3 additional printk()s were added.
> > >
> > > Functional testing results (on 2 txq tap device):
> > >
> > >   [Fri Sep 20 18:33:27 2019] ========== tun no prog ==========
> > >   [Fri Sep 20 18:33:27 2019] tuntap: tun_ebpf_select_queue() returned '-1'
> > >   [Fri Sep 20 18:33:27 2019] tuntap: tun_automq_select_queue() ran
> > >   [Fri Sep 20 18:33:27 2019] ========== tun prog -1 ==========
> > >   [Fri Sep 20 18:33:27 2019] tuntap: bpf_prog_run_clear_cb() returned '-1'
> > >   [Fri Sep 20 18:33:27 2019] tuntap: tun_ebpf_select_queue() returned '-1'
> > >   [Fri Sep 20 18:33:27 2019] tuntap: tun_automq_select_queue() ran
> > >   [Fri Sep 20 18:33:27 2019] ========== tun prog 0 ==========
> > >   [Fri Sep 20 18:33:27 2019] tuntap: bpf_prog_run_clear_cb() returned '0'
> > >   [Fri Sep 20 18:33:27 2019] tuntap: tun_ebpf_select_queue() returned '0'
> > >   [Fri Sep 20 18:33:27 2019] ========== tun prog 1 ==========
> > >   [Fri Sep 20 18:33:27 2019] tuntap: bpf_prog_run_clear_cb() returned '1'
> > >   [Fri Sep 20 18:33:27 2019] tuntap: tun_ebpf_select_queue() returned '1'
> > >   [Fri Sep 20 18:33:27 2019] ========== tun prog 2 ==========
> > >   [Fri Sep 20 18:33:27 2019] tuntap: bpf_prog_run_clear_cb() returned '2'
> > >   [Fri Sep 20 18:33:27 2019] tuntap: tun_ebpf_select_queue() returned '0'
> > >
> > > Signed-off-by: Matthew Cover <matthew.cover@stackpath.com>
> >
> >
> > Could you add a bit more motivation data here?
> 
> Thank you for these questions Michael.
> 
> I'll plan on adding the below information to the
> commit message and submitting a v2 of this patch
> when net-next reopens. In the meantime, it would
> be very helpful to know if these answers address
> some of your concerns.
> 
> > 1. why is this a good idea
> 
> This change allows TUNSETSTEERINGEBPF progs to
> do any of the following.
>  1. implement queue selection for a subset of
>     traffic (e.g. special queue selection logic
>     for ipv4, but return negative and use the
>     default automq logic for ipv6)
>  2. determine there isn't sufficient information
>     to do proper queue selection; return
>     negative and use the default automq logic
>     for the unknown
>  3. implement a noop prog (e.g. do
>     bpf_trace_printk() then return negative and
>     use the default automq logic for everything)
> 
> > 2. how do we know existing userspace does not rely on existing behaviour
> 
> Prior to this change a negative return from a
> TUNSETSTEERINGEBPF prog would have been cast
> into a u16 and traversed netdev_cap_txqueue().
> 
> In most cases netdev_cap_txqueue() would have
> found this value to exceed real_num_tx_queues
> and queue_index would be updated to 0.
> 
> It is possible that a TUNSETSTEERINGEBPF prog
> return a negative value which when cast into a
> u16 results in a positive queue_index less than
> real_num_tx_queues. For example, on x86_64, a
> return value of -65535 results in a queue_index
> of 1; which is a valid queue for any multiqueue
> device.
> 
> It seems unlikely, however as stated above is
> unfortunately possible, that existing
> TUNSETSTEERINGEBPF programs would choose to
> return a negative value rather than return the
> positive value which holds the same meaning.
> 
> It seems more likely that future
> TUNSETSTEERINGEBPF programs would leverage a
> negative return and potentially be loaded into
> a kernel with the old behavior.

OK if we are returning a special
value, shouldn't we limit it? How about a special
value with this meaning?
If we are changing an ABI let's at least make it
extensible.

> > 3. why doesn't userspace need a way to figure out whether it runs on a kernel with and
> >    without this patch
> 
> There may be some value in exposing this fact
> to the ebpf prog loader. What is the standard
> practice here, a define?


We'll need something at runtime - people move binaries between kernels
without rebuilding then. An ioctl is one option.
A sysfs attribute is another, an ethtool flag yet another.
A combination of these is possible.

And if we are doing this anyway, maybe let userspace select
the new behaviour? This way we can stay compatible with old
userspace...

> >
> >
> > thanks,
> > MST
> >
> > > ---
> > >  drivers/net/tun.c | 20 +++++++++++---------
> > >  1 file changed, 11 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> > > index aab0be4..173d159 100644
> > > --- a/drivers/net/tun.c
> > > +++ b/drivers/net/tun.c
> > > @@ -583,35 +583,37 @@ static u16 tun_automq_select_queue(struct tun_struct *tun, struct sk_buff *skb)
> > >       return txq;
> > >  }
> > >
> > > -static u16 tun_ebpf_select_queue(struct tun_struct *tun, struct sk_buff *skb)
> > > +static int tun_ebpf_select_queue(struct tun_struct *tun, struct sk_buff *skb)
> > >  {
> > >       struct tun_prog *prog;
> > >       u32 numqueues;
> > > -     u16 ret = 0;
> > > +     int ret = -1;
> > >
> > >       numqueues = READ_ONCE(tun->numqueues);
> > >       if (!numqueues)
> > >               return 0;
> > >
> > > +     rcu_read_lock();
> > >       prog = rcu_dereference(tun->steering_prog);
> > >       if (prog)
> > >               ret = bpf_prog_run_clear_cb(prog->prog, skb);
> > > +     rcu_read_unlock();
> > >
> > > -     return ret % numqueues;
> > > +     if (ret >= 0)
> > > +             ret %= numqueues;
> > > +
> > > +     return ret;
> > >  }
> > >
> > >  static u16 tun_select_queue(struct net_device *dev, struct sk_buff *skb,
> > >                           struct net_device *sb_dev)
> > >  {
> > >       struct tun_struct *tun = netdev_priv(dev);
> > > -     u16 ret;
> > > +     int ret;
> > >
> > > -     rcu_read_lock();
> > > -     if (rcu_dereference(tun->steering_prog))
> > > -             ret = tun_ebpf_select_queue(tun, skb);
> > > -     else
> > > +     ret = tun_ebpf_select_queue(tun, skb);
> > > +     if (ret < 0)
> > >               ret = tun_automq_select_queue(tun, skb);
> > > -     rcu_read_unlock();
> > >
> > >       return ret;
> > >  }
> > > --
> > > 1.8.3.1
