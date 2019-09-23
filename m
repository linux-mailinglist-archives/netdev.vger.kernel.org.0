Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5CE0BAC5F
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 03:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390844AbfIWBUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Sep 2019 21:20:39 -0400
Received: from mail-ua1-f65.google.com ([209.85.222.65]:44277 "EHLO
        mail-ua1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387843AbfIWBUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Sep 2019 21:20:39 -0400
Received: by mail-ua1-f65.google.com with SMTP id n2so3803833ual.11;
        Sun, 22 Sep 2019 18:20:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yBfCu/VUWJ5N3M0v3fGiMsNf7JIKawuMn8mF8bIor2o=;
        b=qnLpTUrdFJ42xoHGtpbGfhSQwISM7WfrEfelcSMRHhgJf1YKTTKJQa8bKELHKsZOcv
         wogMS6Gb2byDKPRwWK0NvG0tLbqCVKVgAymbG44yBB4FDXOVvn2nCN6X3swXalE2KnUU
         bFJFfH6HpdhYxcz/yQDDVXnZFcmCBSZ8V6vrT8FgNBucEwm+NSzBwtWpky7R3UQ5SwUW
         4xoobQa9jX5p7OIO1a6S99fwhxrQo41NYn8XUGveCAJhWuJpx6ZozaX6L43cTNbKRayw
         2bvP6/3qaWgvTAWAno6fS9TsS+gqJrFa+IMevX/ZYiN9TTKxmwAbyhrd060OjAVEmPqE
         eWtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yBfCu/VUWJ5N3M0v3fGiMsNf7JIKawuMn8mF8bIor2o=;
        b=pMVMfp1eWkjganmYA1S6ZAW/TDMt0DF3CQkIxCYG8kF//0qHaC3+r3bOd/i/z1SeSe
         abR1nu3QdNcpZfb6jW/4uaTuXH2eQ5HYZPd1M7Aa+qqC0+iL5vQVNvmMsY9kbIlmnANq
         9WRK6cf4USMLkFZ1iFIbJeVOI43lhYHTkb0amTv48CDIFkcQ0bad0S9VWtbU/K2qM6jp
         oUOEf93zPJMWU659djbrMWn6WxRwM7/svsZ3Wub3gTpllsd09axjbmdA/lit3joyH0jz
         IlbSVUgeaYFOFWoicWJg/OQ8LuBjic+ymnKztoqCpLUUHs0yCSFSYg3VQMwoDxfQl2cI
         JGqw==
X-Gm-Message-State: APjAAAUwzawgoIWPF9W/n1KaeC7RlBfB3oK61jCEQBljJDgGNfmYv2W2
        ikK+4GB27iUAoR4gHTtIYu/4ciF+SLeTKRWx7vY=
X-Google-Smtp-Source: APXvYqwZA9zKm9FQ+UpldegcXBO5c6bNmAKbjCjFRbvO5MvIdAu9g+xlkkWyn307k7vWEW1Z6MNM0/NLwpbqBcszZzc=
X-Received: by 2002:ab0:2041:: with SMTP id g1mr7798749ual.45.1569201637331;
 Sun, 22 Sep 2019 18:20:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190920185843.4096-1-matthew.cover@stackpath.com>
 <20190922080326-mutt-send-email-mst@kernel.org> <CAGyo_hqGbFdt1PoDrmo=S5iTO8TwbrbtOJtbvGT1WrFFMLwk-Q@mail.gmail.com>
 <0f4541d9-a405-6185-7e54-112dc9188146@redhat.com>
In-Reply-To: <0f4541d9-a405-6185-7e54-112dc9188146@redhat.com>
From:   Matt Cover <werekraken@gmail.com>
Date:   Sun, 22 Sep 2019 18:20:24 -0700
Message-ID: <CAGyo_hp-PJUg7GWFK996vqRxn=cCEdE=hcWdYhyf4K-nSU9qYQ@mail.gmail.com>
Subject: Re: [PATCH net-next] tuntap: Fallback to automq on TUNSETSTEERINGEBPF
 prog negative return
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com,
        Eric Dumazet <edumazet@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Matthew Cover <matthew.cover@stackpath.com>,
        mail@timurcelik.de, pabeni@redhat.com,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        wangli39@baidu.com, lifei.shirley@bytedance.com,
        tglx@linutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 22, 2019 at 5:46 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2019/9/23 =E4=B8=8A=E5=8D=881:43, Matt Cover wrote:
> > On Sun, Sep 22, 2019 at 5:37 AM Michael S. Tsirkin <mst@redhat.com> wro=
te:
> >> On Fri, Sep 20, 2019 at 11:58:43AM -0700, Matthew Cover wrote:
> >>> Treat a negative return from a TUNSETSTEERINGEBPF bpf prog as a signa=
l
> >>> to fallback to tun_automq_select_queue() for tx queue selection.
> >>>
> >>> Compilation of this exact patch was tested.
> >>>
> >>> For functional testing 3 additional printk()s were added.
> >>>
> >>> Functional testing results (on 2 txq tap device):
> >>>
> >>>    [Fri Sep 20 18:33:27 2019] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D tun no p=
rog =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>>    [Fri Sep 20 18:33:27 2019] tuntap: tun_ebpf_select_queue() returne=
d '-1'
> >>>    [Fri Sep 20 18:33:27 2019] tuntap: tun_automq_select_queue() ran
> >>>    [Fri Sep 20 18:33:27 2019] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D tun prog=
 -1 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>>    [Fri Sep 20 18:33:27 2019] tuntap: bpf_prog_run_clear_cb() returne=
d '-1'
> >>>    [Fri Sep 20 18:33:27 2019] tuntap: tun_ebpf_select_queue() returne=
d '-1'
> >>>    [Fri Sep 20 18:33:27 2019] tuntap: tun_automq_select_queue() ran
> >>>    [Fri Sep 20 18:33:27 2019] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D tun prog=
 0 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>>    [Fri Sep 20 18:33:27 2019] tuntap: bpf_prog_run_clear_cb() returne=
d '0'
> >>>    [Fri Sep 20 18:33:27 2019] tuntap: tun_ebpf_select_queue() returne=
d '0'
> >>>    [Fri Sep 20 18:33:27 2019] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D tun prog=
 1 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>>    [Fri Sep 20 18:33:27 2019] tuntap: bpf_prog_run_clear_cb() returne=
d '1'
> >>>    [Fri Sep 20 18:33:27 2019] tuntap: tun_ebpf_select_queue() returne=
d '1'
> >>>    [Fri Sep 20 18:33:27 2019] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D tun prog=
 2 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>>    [Fri Sep 20 18:33:27 2019] tuntap: bpf_prog_run_clear_cb() returne=
d '2'
> >>>    [Fri Sep 20 18:33:27 2019] tuntap: tun_ebpf_select_queue() returne=
d '0'
> >>>
> >>> Signed-off-by: Matthew Cover <matthew.cover@stackpath.com>
> >>
> >> Could you add a bit more motivation data here?
> > Thank you for these questions Michael.
> >
> > I'll plan on adding the below information to the
> > commit message and submitting a v2 of this patch
> > when net-next reopens. In the meantime, it would
> > be very helpful to know if these answers address
> > some of your concerns.
> >
> >> 1. why is this a good idea
> > This change allows TUNSETSTEERINGEBPF progs to
> > do any of the following.
> >   1. implement queue selection for a subset of
> >      traffic (e.g. special queue selection logic
> >      for ipv4, but return negative and use the
> >      default automq logic for ipv6)
>
>
> Well, using ebpf means it need to take care of all the cases. E.g you
> can easily implement the fallback through eBPF as well.
>

I really think there is value in being
able to implement a scoped special
case while leaving the rest of the
packets in the kernel's hands.

Having to reimplement automq makes
this hookpoint less accessible to
beginners and experienced alike.

>
> >   2. determine there isn't sufficient information
> >      to do proper queue selection; return
> >      negative and use the default automq logic
> >      for the unknown
>
>
> Same as above.
>
>
> >   3. implement a noop prog (e.g. do
> >      bpf_trace_printk() then return negative and
> >      use the default automq logic for everything)
>
>
> ditto.
>
>
> >
> >> 2. how do we know existing userspace does not rely on existing behavio=
ur
> > Prior to this change a negative return from a
> > TUNSETSTEERINGEBPF prog would have been cast
> > into a u16 and traversed netdev_cap_txqueue().
> >
> > In most cases netdev_cap_txqueue() would have
> > found this value to exceed real_num_tx_queues
> > and queue_index would be updated to 0.
> >
> > It is possible that a TUNSETSTEERINGEBPF prog
> > return a negative value which when cast into a
> > u16 results in a positive queue_index less than
> > real_num_tx_queues. For example, on x86_64, a
> > return value of -65535 results in a queue_index
> > of 1; which is a valid queue for any multiqueue
> > device.
> >
> > It seems unlikely, however as stated above is
> > unfortunately possible, that existing
> > TUNSETSTEERINGEBPF programs would choose to
> > return a negative value rather than return the
> > positive value which holds the same meaning.
> >
> > It seems more likely that future
> > TUNSETSTEERINGEBPF programs would leverage a
> > negative return and potentially be loaded into
> > a kernel with the old behavior.
>
>
> Yes, eBPF can return probably wrong value, but what kernel did is just
> to make sure it doesn't harm anything.
>
> I would rather just drop the packet in this case.
>

In addition to TUN_SSE_ABORT, we can
add TUN_SSE_DROP. That could be made the
default for any undefined negative
return as well.

> Thanks
>
>
> >
> >> 3. why doesn't userspace need a way to figure out whether it runs on a=
 kernel with and
> >>     without this patch
> > There may be some value in exposing this fact
> > to the ebpf prog loader. What is the standard
> > practice here, a define?
> >
> >>
> >> thanks,
> >> MST
> >>
> >>> ---
> >>>   drivers/net/tun.c | 20 +++++++++++---------
> >>>   1 file changed, 11 insertions(+), 9 deletions(-)
> >>>
> >>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> >>> index aab0be4..173d159 100644
> >>> --- a/drivers/net/tun.c
> >>> +++ b/drivers/net/tun.c
> >>> @@ -583,35 +583,37 @@ static u16 tun_automq_select_queue(struct tun_s=
truct *tun, struct sk_buff *skb)
> >>>        return txq;
> >>>   }
> >>>
> >>> -static u16 tun_ebpf_select_queue(struct tun_struct *tun, struct sk_b=
uff *skb)
> >>> +static int tun_ebpf_select_queue(struct tun_struct *tun, struct sk_b=
uff *skb)
> >>>   {
> >>>        struct tun_prog *prog;
> >>>        u32 numqueues;
> >>> -     u16 ret =3D 0;
> >>> +     int ret =3D -1;
> >>>
> >>>        numqueues =3D READ_ONCE(tun->numqueues);
> >>>        if (!numqueues)
> >>>                return 0;
> >>>
> >>> +     rcu_read_lock();
> >>>        prog =3D rcu_dereference(tun->steering_prog);
> >>>        if (prog)
> >>>                ret =3D bpf_prog_run_clear_cb(prog->prog, skb);
> >>> +     rcu_read_unlock();
> >>>
> >>> -     return ret % numqueues;
> >>> +     if (ret >=3D 0)
> >>> +             ret %=3D numqueues;
> >>> +
> >>> +     return ret;
> >>>   }
> >>>
> >>>   static u16 tun_select_queue(struct net_device *dev, struct sk_buff =
*skb,
> >>>                            struct net_device *sb_dev)
> >>>   {
> >>>        struct tun_struct *tun =3D netdev_priv(dev);
> >>> -     u16 ret;
> >>> +     int ret;
> >>>
> >>> -     rcu_read_lock();
> >>> -     if (rcu_dereference(tun->steering_prog))
> >>> -             ret =3D tun_ebpf_select_queue(tun, skb);
> >>> -     else
> >>> +     ret =3D tun_ebpf_select_queue(tun, skb);
> >>> +     if (ret < 0)
> >>>                ret =3D tun_automq_select_queue(tun, skb);
> >>> -     rcu_read_unlock();
> >>>
> >>>        return ret;
> >>>   }
> >>> --
> >>> 1.8.3.1
