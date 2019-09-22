Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70CF5BA363
	for <lists+netdev@lfdr.de>; Sun, 22 Sep 2019 19:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387763AbfIVRnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Sep 2019 13:43:32 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:37361 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726599AbfIVRnc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Sep 2019 13:43:32 -0400
Received: by mail-vs1-f68.google.com with SMTP id p13so7964721vsr.4;
        Sun, 22 Sep 2019 10:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XtNRBxYnZtSXynhBfLXe+m5UKoR3CqvO1nZEOzzDm/Q=;
        b=QHQt6VRZyy//8JIfy77lOyFVYdA3g04jOIx7BDFnfhjEg99MMzvVosGXIB0aaHjgxT
         qdeJCLYW9y6tafzyYpIY8NcDVKKyDJo091GAQW57oarxo3m3zrBeVc8bkttJk+4sLsPJ
         66PAuPTijhz3RFOORwjHGmgGB1xcFsTbqr2RQ33Wzd236LUvP2LoR5rxvLTeHlkX1kYR
         GEp9TXA4Vh7Tz99vba3vw5jTpUuzeM0eq5O0dXVTFKS8KfVntzJcWHZXM5BYYym4ayJT
         ao4+3j56mBmwy1xvlr8gFs/Tn5rKr2GdNss3gIsuAN0wtNZLXQ59iprLEX8eMU78cUb4
         j3eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XtNRBxYnZtSXynhBfLXe+m5UKoR3CqvO1nZEOzzDm/Q=;
        b=V/4DqEP0gSD4rdN8OhnkuiJl9qTqjQn8p7DBC9dQw4J7k48Zeq13mEYCKnvoF3WEF3
         9FXmesTPunH1FraNKu1IJXTd0mQAaKfcHsBTkn/kp87ZUUdrYremtSS+rue32o5/flIk
         oaFje3IYebsOrnVoEpCSZIvtS/m8YanY34+3egabClHS87YlGxg6Uj/ZHd93tG4UzjkE
         eviCmbZ9rL8IdqVWlVZ/DrSWeK+EJljLPFaubzOK1OnRM2nMWxmDhLe2Wcd0YVjquwpR
         /dxCEDQfAgGkct2c5WsVOW4clwPuQPEkPS5MrF+Eb59ImTb9JIt82wWJmr0SWreyFDik
         GpVw==
X-Gm-Message-State: APjAAAU5B5uUA4B+gG/fczJtFIcgd4MatB6xkJWMUQXZTS+yDdmcLFzH
        faWLynbpx2wiPS8Y6A2PT5AA7vpQDrqR9xiPF2o=
X-Google-Smtp-Source: APXvYqz+u1hPxbyLUfEGAhAPdI8YySRZkCJ3g9fsD+ATwHPs6nbz82u0RnkGbf5WCMDIJHosVVdus6bJ33cea0PO0Eg=
X-Received: by 2002:a67:c181:: with SMTP id h1mr5733868vsj.195.1569174210569;
 Sun, 22 Sep 2019 10:43:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190920185843.4096-1-matthew.cover@stackpath.com> <20190922080326-mutt-send-email-mst@kernel.org>
In-Reply-To: <20190922080326-mutt-send-email-mst@kernel.org>
From:   Matt Cover <werekraken@gmail.com>
Date:   Sun, 22 Sep 2019 10:43:19 -0700
Message-ID: <CAGyo_hqGbFdt1PoDrmo=S5iTO8TwbrbtOJtbvGT1WrFFMLwk-Q@mail.gmail.com>
Subject: Re: [PATCH net-next] tuntap: Fallback to automq on TUNSETSTEERINGEBPF
 prog negative return
To:     "Michael S. Tsirkin" <mst@redhat.com>
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
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 22, 2019 at 5:37 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Fri, Sep 20, 2019 at 11:58:43AM -0700, Matthew Cover wrote:
> > Treat a negative return from a TUNSETSTEERINGEBPF bpf prog as a signal
> > to fallback to tun_automq_select_queue() for tx queue selection.
> >
> > Compilation of this exact patch was tested.
> >
> > For functional testing 3 additional printk()s were added.
> >
> > Functional testing results (on 2 txq tap device):
> >
> >   [Fri Sep 20 18:33:27 2019] ========== tun no prog ==========
> >   [Fri Sep 20 18:33:27 2019] tuntap: tun_ebpf_select_queue() returned '-1'
> >   [Fri Sep 20 18:33:27 2019] tuntap: tun_automq_select_queue() ran
> >   [Fri Sep 20 18:33:27 2019] ========== tun prog -1 ==========
> >   [Fri Sep 20 18:33:27 2019] tuntap: bpf_prog_run_clear_cb() returned '-1'
> >   [Fri Sep 20 18:33:27 2019] tuntap: tun_ebpf_select_queue() returned '-1'
> >   [Fri Sep 20 18:33:27 2019] tuntap: tun_automq_select_queue() ran
> >   [Fri Sep 20 18:33:27 2019] ========== tun prog 0 ==========
> >   [Fri Sep 20 18:33:27 2019] tuntap: bpf_prog_run_clear_cb() returned '0'
> >   [Fri Sep 20 18:33:27 2019] tuntap: tun_ebpf_select_queue() returned '0'
> >   [Fri Sep 20 18:33:27 2019] ========== tun prog 1 ==========
> >   [Fri Sep 20 18:33:27 2019] tuntap: bpf_prog_run_clear_cb() returned '1'
> >   [Fri Sep 20 18:33:27 2019] tuntap: tun_ebpf_select_queue() returned '1'
> >   [Fri Sep 20 18:33:27 2019] ========== tun prog 2 ==========
> >   [Fri Sep 20 18:33:27 2019] tuntap: bpf_prog_run_clear_cb() returned '2'
> >   [Fri Sep 20 18:33:27 2019] tuntap: tun_ebpf_select_queue() returned '0'
> >
> > Signed-off-by: Matthew Cover <matthew.cover@stackpath.com>
>
>
> Could you add a bit more motivation data here?

Thank you for these questions Michael.

I'll plan on adding the below information to the
commit message and submitting a v2 of this patch
when net-next reopens. In the meantime, it would
be very helpful to know if these answers address
some of your concerns.

> 1. why is this a good idea

This change allows TUNSETSTEERINGEBPF progs to
do any of the following.
 1. implement queue selection for a subset of
    traffic (e.g. special queue selection logic
    for ipv4, but return negative and use the
    default automq logic for ipv6)
 2. determine there isn't sufficient information
    to do proper queue selection; return
    negative and use the default automq logic
    for the unknown
 3. implement a noop prog (e.g. do
    bpf_trace_printk() then return negative and
    use the default automq logic for everything)

> 2. how do we know existing userspace does not rely on existing behaviour

Prior to this change a negative return from a
TUNSETSTEERINGEBPF prog would have been cast
into a u16 and traversed netdev_cap_txqueue().

In most cases netdev_cap_txqueue() would have
found this value to exceed real_num_tx_queues
and queue_index would be updated to 0.

It is possible that a TUNSETSTEERINGEBPF prog
return a negative value which when cast into a
u16 results in a positive queue_index less than
real_num_tx_queues. For example, on x86_64, a
return value of -65535 results in a queue_index
of 1; which is a valid queue for any multiqueue
device.

It seems unlikely, however as stated above is
unfortunately possible, that existing
TUNSETSTEERINGEBPF programs would choose to
return a negative value rather than return the
positive value which holds the same meaning.

It seems more likely that future
TUNSETSTEERINGEBPF programs would leverage a
negative return and potentially be loaded into
a kernel with the old behavior.

> 3. why doesn't userspace need a way to figure out whether it runs on a kernel with and
>    without this patch

There may be some value in exposing this fact
to the ebpf prog loader. What is the standard
practice here, a define?

>
>
> thanks,
> MST
>
> > ---
> >  drivers/net/tun.c | 20 +++++++++++---------
> >  1 file changed, 11 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> > index aab0be4..173d159 100644
> > --- a/drivers/net/tun.c
> > +++ b/drivers/net/tun.c
> > @@ -583,35 +583,37 @@ static u16 tun_automq_select_queue(struct tun_struct *tun, struct sk_buff *skb)
> >       return txq;
> >  }
> >
> > -static u16 tun_ebpf_select_queue(struct tun_struct *tun, struct sk_buff *skb)
> > +static int tun_ebpf_select_queue(struct tun_struct *tun, struct sk_buff *skb)
> >  {
> >       struct tun_prog *prog;
> >       u32 numqueues;
> > -     u16 ret = 0;
> > +     int ret = -1;
> >
> >       numqueues = READ_ONCE(tun->numqueues);
> >       if (!numqueues)
> >               return 0;
> >
> > +     rcu_read_lock();
> >       prog = rcu_dereference(tun->steering_prog);
> >       if (prog)
> >               ret = bpf_prog_run_clear_cb(prog->prog, skb);
> > +     rcu_read_unlock();
> >
> > -     return ret % numqueues;
> > +     if (ret >= 0)
> > +             ret %= numqueues;
> > +
> > +     return ret;
> >  }
> >
> >  static u16 tun_select_queue(struct net_device *dev, struct sk_buff *skb,
> >                           struct net_device *sb_dev)
> >  {
> >       struct tun_struct *tun = netdev_priv(dev);
> > -     u16 ret;
> > +     int ret;
> >
> > -     rcu_read_lock();
> > -     if (rcu_dereference(tun->steering_prog))
> > -             ret = tun_ebpf_select_queue(tun, skb);
> > -     else
> > +     ret = tun_ebpf_select_queue(tun, skb);
> > +     if (ret < 0)
> >               ret = tun_automq_select_queue(tun, skb);
> > -     rcu_read_unlock();
> >
> >       return ret;
> >  }
> > --
> > 1.8.3.1
