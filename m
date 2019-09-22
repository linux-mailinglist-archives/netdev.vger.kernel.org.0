Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D39FBBAC09
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 00:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389554AbfIVWqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Sep 2019 18:46:34 -0400
Received: from mail-vk1-f194.google.com ([209.85.221.194]:45609 "EHLO
        mail-vk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389439AbfIVWqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Sep 2019 18:46:34 -0400
Received: by mail-vk1-f194.google.com with SMTP id u192so2584113vkb.12;
        Sun, 22 Sep 2019 15:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rVJRFaJE5AEAesOtuJI9NH1xVfCZ4xaAZV4mZPfTXDI=;
        b=eVj4EWZImuOMCwXehKHEqP97MAgGkS1KslAMdmp/aFVLlAwjvoNI+ffLxG+uvOrg8w
         /TeMpbJAt4zTxI5bv8sAxcSrwKoGIb/QnYNf6PcIkleSXYTh1hJWpKdEnjna5RM+m/SY
         td1xa0hcFkWI88gzZyQsiRT6cp6KAnUnf57QGixWPPQxlNnUuH/4O0TP1IxMYmh/37WM
         3aqUB+FNbpLdpUPO4eEPh07LDF4BWrESlbWHRqScHil4GJPhzcuPeZWA9x+2ZUU2s1F8
         m7g8qwqJuKiXSFvp7hkczxj6rilsT/DB7ZgEI2R9q968GpdOeKY7oR9KTK72PiK8LDni
         I/Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rVJRFaJE5AEAesOtuJI9NH1xVfCZ4xaAZV4mZPfTXDI=;
        b=e70XTmuORYJDuLb1+Rz40npEwYP++o7H17vnA/WgOuIo0jZk87sei5KLLQmvsUBk9w
         H0dPPkrpED4ZCOogjxIavIKcdxqUceH5H6U0Fdo/STU2DW4UcOvLSMxxF/r3hg0JBfBP
         acOlhH4Lqu4VVqKvKQyY0tTgV7Yjl7iEdhW/1c4tBV/09lMZd8zlkjaxZXbUIMFnmNj7
         PsuzwTToUWYC/gd7f/YkKKRtWB95AY6Pz8vR2wrvF9Bsejv7b/vzH2llRpssp7ma6UAK
         i9tH2QFtoLm0/wgfu2CztK4p7PIPaD4kqam6ypUBFs97r8GcnFH5V4K5rD2kc6E/eWpA
         cVVQ==
X-Gm-Message-State: APjAAAV34JnWsc0/qzai/YXDMYBX4lYChSvlGfHCH5EZ4EGLiL/fl93M
        GEXW4i43UatO00WTqrowiPoSKaYMmJsty9uWho4=
X-Google-Smtp-Source: APXvYqxOFG9/xZZVxAoYT/1HFqcEGT5aNLeW3buObGdou+/30q6Ni0mz/dpmFMtaY/qKPwvP0N3bpVUKouHZa6knUL4=
X-Received: by 2002:ac5:c4d1:: with SMTP id a17mr13574798vkl.57.1569192390979;
 Sun, 22 Sep 2019 15:46:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190920185843.4096-1-matthew.cover@stackpath.com>
 <20190922080326-mutt-send-email-mst@kernel.org> <CAGyo_hqGbFdt1PoDrmo=S5iTO8TwbrbtOJtbvGT1WrFFMLwk-Q@mail.gmail.com>
 <20190922162546-mutt-send-email-mst@kernel.org> <CAGyo_hr+_oSwVSKSqKTXaouaMK-6b8+NVLTxWmZD3vn07GEGWA@mail.gmail.com>
In-Reply-To: <CAGyo_hr+_oSwVSKSqKTXaouaMK-6b8+NVLTxWmZD3vn07GEGWA@mail.gmail.com>
From:   Matt Cover <werekraken@gmail.com>
Date:   Sun, 22 Sep 2019 15:46:19 -0700
Message-ID: <CAGyo_hpCDPmNvTau50XxRVkq1C=Qn7E8cVkE=BZhhiNF6MjqZA@mail.gmail.com>
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

On Sun, Sep 22, 2019 at 3:30 PM Matt Cover <werekraken@gmail.com> wrote:
>
> On Sun, Sep 22, 2019 at 1:36 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Sun, Sep 22, 2019 at 10:43:19AM -0700, Matt Cover wrote:
> > > On Sun, Sep 22, 2019 at 5:37 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > On Fri, Sep 20, 2019 at 11:58:43AM -0700, Matthew Cover wrote:
> > > > > Treat a negative return from a TUNSETSTEERINGEBPF bpf prog as a signal
> > > > > to fallback to tun_automq_select_queue() for tx queue selection.
> > > > >
> > > > > Compilation of this exact patch was tested.
> > > > >
> > > > > For functional testing 3 additional printk()s were added.
> > > > >
> > > > > Functional testing results (on 2 txq tap device):
> > > > >
> > > > >   [Fri Sep 20 18:33:27 2019] ========== tun no prog ==========
> > > > >   [Fri Sep 20 18:33:27 2019] tuntap: tun_ebpf_select_queue() returned '-1'
> > > > >   [Fri Sep 20 18:33:27 2019] tuntap: tun_automq_select_queue() ran
> > > > >   [Fri Sep 20 18:33:27 2019] ========== tun prog -1 ==========
> > > > >   [Fri Sep 20 18:33:27 2019] tuntap: bpf_prog_run_clear_cb() returned '-1'
> > > > >   [Fri Sep 20 18:33:27 2019] tuntap: tun_ebpf_select_queue() returned '-1'
> > > > >   [Fri Sep 20 18:33:27 2019] tuntap: tun_automq_select_queue() ran
> > > > >   [Fri Sep 20 18:33:27 2019] ========== tun prog 0 ==========
> > > > >   [Fri Sep 20 18:33:27 2019] tuntap: bpf_prog_run_clear_cb() returned '0'
> > > > >   [Fri Sep 20 18:33:27 2019] tuntap: tun_ebpf_select_queue() returned '0'
> > > > >   [Fri Sep 20 18:33:27 2019] ========== tun prog 1 ==========
> > > > >   [Fri Sep 20 18:33:27 2019] tuntap: bpf_prog_run_clear_cb() returned '1'
> > > > >   [Fri Sep 20 18:33:27 2019] tuntap: tun_ebpf_select_queue() returned '1'
> > > > >   [Fri Sep 20 18:33:27 2019] ========== tun prog 2 ==========
> > > > >   [Fri Sep 20 18:33:27 2019] tuntap: bpf_prog_run_clear_cb() returned '2'
> > > > >   [Fri Sep 20 18:33:27 2019] tuntap: tun_ebpf_select_queue() returned '0'
> > > > >
> > > > > Signed-off-by: Matthew Cover <matthew.cover@stackpath.com>
> > > >
> > > >
> > > > Could you add a bit more motivation data here?
> > >
> > > Thank you for these questions Michael.
> > >
> > > I'll plan on adding the below information to the
> > > commit message and submitting a v2 of this patch
> > > when net-next reopens. In the meantime, it would
> > > be very helpful to know if these answers address
> > > some of your concerns.
> > >
> > > > 1. why is this a good idea
> > >
> > > This change allows TUNSETSTEERINGEBPF progs to
> > > do any of the following.
> > >  1. implement queue selection for a subset of
> > >     traffic (e.g. special queue selection logic
> > >     for ipv4, but return negative and use the
> > >     default automq logic for ipv6)
> > >  2. determine there isn't sufficient information
> > >     to do proper queue selection; return
> > >     negative and use the default automq logic
> > >     for the unknown
> > >  3. implement a noop prog (e.g. do
> > >     bpf_trace_printk() then return negative and
> > >     use the default automq logic for everything)
> > >
> > > > 2. how do we know existing userspace does not rely on existing behaviour
> > >
> > > Prior to this change a negative return from a
> > > TUNSETSTEERINGEBPF prog would have been cast
> > > into a u16 and traversed netdev_cap_txqueue().
> > >
> > > In most cases netdev_cap_txqueue() would have
> > > found this value to exceed real_num_tx_queues
> > > and queue_index would be updated to 0.
> > >
> > > It is possible that a TUNSETSTEERINGEBPF prog
> > > return a negative value which when cast into a
> > > u16 results in a positive queue_index less than
> > > real_num_tx_queues. For example, on x86_64, a
> > > return value of -65535 results in a queue_index
> > > of 1; which is a valid queue for any multiqueue
> > > device.
> > >
> > > It seems unlikely, however as stated above is
> > > unfortunately possible, that existing
> > > TUNSETSTEERINGEBPF programs would choose to
> > > return a negative value rather than return the
> > > positive value which holds the same meaning.
> > >
> > > It seems more likely that future
> > > TUNSETSTEERINGEBPF programs would leverage a
> > > negative return and potentially be loaded into
> > > a kernel with the old behavior.
> >
> > OK if we are returning a special
> > value, shouldn't we limit it? How about a special
> > value with this meaning?
> > If we are changing an ABI let's at least make it
> > extensible.
> >
>
> A special value with this meaning sounds
> good to me. I'll plan on adding a define
> set to -1 to cause the fallback to automq.
>
> The way I was initially viewing the old
> behavior was that returning negative was
> undefined; it happened to have the
> outcomes I walked through, but not
> necessarily by design.
>
> In order to keep the new behavior
> extensible, how should we state that a
> negative return other than -1 is
> undefined and therefore subject to
> change. Is something like this
> sufficient?
>
>   Documentation/networking/tc-actions-env-rules.txt
>
> Additionally, what should the new
> behavior implement when a negative other
> than -1 is returned? I would like to have
> it do the same thing as -1 for now, but
> with the understanding that this behavior
> is undefined. Does this sound reasonable?
>
> > > > 3. why doesn't userspace need a way to figure out whether it runs on a kernel with and
> > > >    without this patch
> > >
> > > There may be some value in exposing this fact
> > > to the ebpf prog loader. What is the standard
> > > practice here, a define?
> >
> >
> > We'll need something at runtime - people move binaries between kernels
> > without rebuilding then. An ioctl is one option.
> > A sysfs attribute is another, an ethtool flag yet another.
> > A combination of these is possible.
> >
> > And if we are doing this anyway, maybe let userspace select
> > the new behaviour? This way we can stay compatible with old
> > userspace...
> >
>
> Understood. I'll look into adding an
> ioctl to activate the new behavior. And
> perhaps a method of checking which is
> behavior is currently active (in case we
> ever want to change the default, say
> after some suitably long transition
> period).
>

Unless of course we can simply state via
documentation that any negative return
for which a define doesn't exist is
undefined behavior. In which case,
there is no old vs new behavior and
no need for an ioctl. Simply the
understanding provided by the
documentation.

> > > >
> > > >
> > > > thanks,
> > > > MST
> > > >
> > > > > ---
> > > > >  drivers/net/tun.c | 20 +++++++++++---------
> > > > >  1 file changed, 11 insertions(+), 9 deletions(-)
> > > > >
> > > > > diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> > > > > index aab0be4..173d159 100644
> > > > > --- a/drivers/net/tun.c
> > > > > +++ b/drivers/net/tun.c
> > > > > @@ -583,35 +583,37 @@ static u16 tun_automq_select_queue(struct tun_struct *tun, struct sk_buff *skb)
> > > > >       return txq;
> > > > >  }
> > > > >
> > > > > -static u16 tun_ebpf_select_queue(struct tun_struct *tun, struct sk_buff *skb)
> > > > > +static int tun_ebpf_select_queue(struct tun_struct *tun, struct sk_buff *skb)
> > > > >  {
> > > > >       struct tun_prog *prog;
> > > > >       u32 numqueues;
> > > > > -     u16 ret = 0;
> > > > > +     int ret = -1;
> > > > >
> > > > >       numqueues = READ_ONCE(tun->numqueues);
> > > > >       if (!numqueues)
> > > > >               return 0;
> > > > >
> > > > > +     rcu_read_lock();
> > > > >       prog = rcu_dereference(tun->steering_prog);
> > > > >       if (prog)
> > > > >               ret = bpf_prog_run_clear_cb(prog->prog, skb);
> > > > > +     rcu_read_unlock();
> > > > >
> > > > > -     return ret % numqueues;
> > > > > +     if (ret >= 0)
> > > > > +             ret %= numqueues;
> > > > > +
> > > > > +     return ret;
> > > > >  }
> > > > >
> > > > >  static u16 tun_select_queue(struct net_device *dev, struct sk_buff *skb,
> > > > >                           struct net_device *sb_dev)
> > > > >  {
> > > > >       struct tun_struct *tun = netdev_priv(dev);
> > > > > -     u16 ret;
> > > > > +     int ret;
> > > > >
> > > > > -     rcu_read_lock();
> > > > > -     if (rcu_dereference(tun->steering_prog))
> > > > > -             ret = tun_ebpf_select_queue(tun, skb);
> > > > > -     else
> > > > > +     ret = tun_ebpf_select_queue(tun, skb);
> > > > > +     if (ret < 0)
> > > > >               ret = tun_automq_select_queue(tun, skb);
> > > > > -     rcu_read_unlock();
> > > > >
> > > > >       return ret;
> > > > >  }
> > > > > --
> > > > > 1.8.3.1
