Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3748BACC7
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 05:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404982AbfIWDA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Sep 2019 23:00:26 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:41601 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404758AbfIWDA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Sep 2019 23:00:26 -0400
Received: by mail-vs1-f68.google.com with SMTP id l2so8433766vsr.8;
        Sun, 22 Sep 2019 20:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BWqaQWhv6k4houp28Xd7ZU1mZ5VF9c1nzAKk9Enxcmk=;
        b=EOOfU1a0AH0mVvagVrPoEIh2rGXN4f6EkUieuaxKWYNDyXlH0kcyfzRNRH1XWN3WBv
         xTHg/LTNgUCEooocx3u1b9FQsMNv+iiYv7eAsZyAgTUv/KDEKo7l8yAOBOYRXyfV6+sG
         szXDY/P2IIfLgqlV9f4lzWwo6M5c6agXYy2RXNRxMvFLEFlin6+G4TshRcqiAmplEiQL
         26QLOOnPT3HUIuR6yyz4d8Nvox3oIg3qrFFidu3VSaWs9o2rTya8pPYmM3snFpoUCx1Q
         4iaP/n4xdiE5ByCX4Bz847+dtz1aG1Spl9c2iLXnSRujSWd97xBcVARe6y1eNYkTgGMB
         A9PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BWqaQWhv6k4houp28Xd7ZU1mZ5VF9c1nzAKk9Enxcmk=;
        b=DOYm3z7gCj76HyHi99iilrL6HHJIibVcTDlyPJ8hHbepip1Nnlq0dC1C8WoCaH5gYu
         l6vqp7UEZZ1TAzf7LNrNUyViEIEqRXrS3Xxyd7qIqjq0K8/mrhq6ZG5csH7ShTaM6aOL
         fJO0WA3VAFCq4x9n4JCvv+ivpTrUI8HNJ2YGYijORrepFHkQn7ulr8pPM+QXH1/fF53p
         2cN9srLSJBMR+EqKapbjzzh4Cc1TVhS4AJy93Ae/KszaRCp3BCnfIv7cM5cdeulnEccE
         Lbn3WGxkP7Jgk0eCnWETqu7aofVN1BYt6A5rOzpg0SwABrPB9z964mApR3i3AUVu/9HK
         d9Vg==
X-Gm-Message-State: APjAAAWWMWcD4z9gm0JYTn6WpKyE2U/b/WXHQdmFqreV8LpIOQPuYc0T
        yZRC0nwHXfdvRz2qryHhzObIO/BOW7nX64Hu5kI=
X-Google-Smtp-Source: APXvYqymepsiquxOO2ZzZDvO+mwo8DVNZ3y8q8HuCmxQ/B7rhSM3UfH0Ye3A0ZQtwNPb+FVvfP2rZEyTzPwt6qX0rgI=
X-Received: by 2002:a67:c181:: with SMTP id h1mr6465119vsj.195.1569207624720;
 Sun, 22 Sep 2019 20:00:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190920185843.4096-1-matthew.cover@stackpath.com>
 <20190922080326-mutt-send-email-mst@kernel.org> <CAGyo_hqGbFdt1PoDrmo=S5iTO8TwbrbtOJtbvGT1WrFFMLwk-Q@mail.gmail.com>
 <0f4541d9-a405-6185-7e54-112dc9188146@redhat.com> <CAGyo_hp-PJUg7GWFK996vqRxn=cCEdE=hcWdYhyf4K-nSU9qYQ@mail.gmail.com>
 <df4ee92f-89e4-70a7-2de8-49fa4acfa08e@redhat.com>
In-Reply-To: <df4ee92f-89e4-70a7-2de8-49fa4acfa08e@redhat.com>
From:   Matt Cover <werekraken@gmail.com>
Date:   Sun, 22 Sep 2019 20:00:13 -0700
Message-ID: <CAGyo_hrM8TzTp6L77x-_18XZn+NEcDyZXAxnwgNaCgMBLpCMPg@mail.gmail.com>
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

On Sun, Sep 22, 2019 at 7:32 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2019/9/23 =E4=B8=8A=E5=8D=889:20, Matt Cover wrote:
> > On Sun, Sep 22, 2019 at 5:46 PM Jason Wang <jasowang@redhat.com> wrote:
> >>
> >> On 2019/9/23 =E4=B8=8A=E5=8D=881:43, Matt Cover wrote:
> >>> On Sun, Sep 22, 2019 at 5:37 AM Michael S. Tsirkin <mst@redhat.com> w=
rote:
> >>>> On Fri, Sep 20, 2019 at 11:58:43AM -0700, Matthew Cover wrote:
> >>>>> Treat a negative return from a TUNSETSTEERINGEBPF bpf prog as a sig=
nal
> >>>>> to fallback to tun_automq_select_queue() for tx queue selection.
> >>>>>
> >>>>> Compilation of this exact patch was tested.
> >>>>>
> >>>>> For functional testing 3 additional printk()s were added.
> >>>>>
> >>>>> Functional testing results (on 2 txq tap device):
> >>>>>
> >>>>>     [Fri Sep 20 18:33:27 2019] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D tun n=
o prog =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>>>>     [Fri Sep 20 18:33:27 2019] tuntap: tun_ebpf_select_queue() retu=
rned '-1'
> >>>>>     [Fri Sep 20 18:33:27 2019] tuntap: tun_automq_select_queue() ra=
n
> >>>>>     [Fri Sep 20 18:33:27 2019] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D tun p=
rog -1 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>>>>     [Fri Sep 20 18:33:27 2019] tuntap: bpf_prog_run_clear_cb() retu=
rned '-1'
> >>>>>     [Fri Sep 20 18:33:27 2019] tuntap: tun_ebpf_select_queue() retu=
rned '-1'
> >>>>>     [Fri Sep 20 18:33:27 2019] tuntap: tun_automq_select_queue() ra=
n
> >>>>>     [Fri Sep 20 18:33:27 2019] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D tun p=
rog 0 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>>>>     [Fri Sep 20 18:33:27 2019] tuntap: bpf_prog_run_clear_cb() retu=
rned '0'
> >>>>>     [Fri Sep 20 18:33:27 2019] tuntap: tun_ebpf_select_queue() retu=
rned '0'
> >>>>>     [Fri Sep 20 18:33:27 2019] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D tun p=
rog 1 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>>>>     [Fri Sep 20 18:33:27 2019] tuntap: bpf_prog_run_clear_cb() retu=
rned '1'
> >>>>>     [Fri Sep 20 18:33:27 2019] tuntap: tun_ebpf_select_queue() retu=
rned '1'
> >>>>>     [Fri Sep 20 18:33:27 2019] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D tun p=
rog 2 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>>>>     [Fri Sep 20 18:33:27 2019] tuntap: bpf_prog_run_clear_cb() retu=
rned '2'
> >>>>>     [Fri Sep 20 18:33:27 2019] tuntap: tun_ebpf_select_queue() retu=
rned '0'
> >>>>>
> >>>>> Signed-off-by: Matthew Cover <matthew.cover@stackpath.com>
> >>>> Could you add a bit more motivation data here?
> >>> Thank you for these questions Michael.
> >>>
> >>> I'll plan on adding the below information to the
> >>> commit message and submitting a v2 of this patch
> >>> when net-next reopens. In the meantime, it would
> >>> be very helpful to know if these answers address
> >>> some of your concerns.
> >>>
> >>>> 1. why is this a good idea
> >>> This change allows TUNSETSTEERINGEBPF progs to
> >>> do any of the following.
> >>>    1. implement queue selection for a subset of
> >>>       traffic (e.g. special queue selection logic
> >>>       for ipv4, but return negative and use the
> >>>       default automq logic for ipv6)
> >>
> >> Well, using ebpf means it need to take care of all the cases. E.g you
> >> can easily implement the fallback through eBPF as well.
> >>
> > I really think there is value in being
> > able to implement a scoped special
> > case while leaving the rest of the
> > packets in the kernel's hands.
>
>
> This is only work when some fucntion could not be done by eBPF itself
> and then we can provide the function through eBPF helpers. But this is
> not the case here.
>
>
> >
> > Having to reimplement automq makes
> > this hookpoint less accessible to
> > beginners and experienced alike.
>
>
> Note that automq itself is kind of complicated, it's best effort that is
> hard to be documented accurately. It has several limitations (e.g flow
> caches etc.) that may not work well in some conditions.
>
> It's not hard to implement a user programmable steering policy through
> maps which could have much deterministic behavior than automq. The goal
> of steering ebpf is to get rid of automq completely not partially rely
> on it.
>
> And I don't see how relying on automq can simplify anything.
>
> Thanks
>

I'm not suggesting that we document automq.

I'm suggesting that we add a return value
which is documented as signaling to the
kernel to implement whatever queue
selection method is used when there is no
ebpf prog attached. That behavior today is
automq.

There is nothing about this return value
which would harder to change the default
queue selection later. The default already
exists today when there is no program
loaded.

>
> >
> >>>    2. determine there isn't sufficient information
> >>>       to do proper queue selection; return
> >>>       negative and use the default automq logic
> >>>       for the unknown
> >>
> >> Same as above.
> >>
> >>
> >>>    3. implement a noop prog (e.g. do
> >>>       bpf_trace_printk() then return negative and
> >>>       use the default automq logic for everything)
> >>
> >> ditto.
> >>
> >>
> >>>> 2. how do we know existing userspace does not rely on existing behav=
iour
> >>> Prior to this change a negative return from a
> >>> TUNSETSTEERINGEBPF prog would have been cast
> >>> into a u16 and traversed netdev_cap_txqueue().
> >>>
> >>> In most cases netdev_cap_txqueue() would have
> >>> found this value to exceed real_num_tx_queues
> >>> and queue_index would be updated to 0.
> >>>
> >>> It is possible that a TUNSETSTEERINGEBPF prog
> >>> return a negative value which when cast into a
> >>> u16 results in a positive queue_index less than
> >>> real_num_tx_queues. For example, on x86_64, a
> >>> return value of -65535 results in a queue_index
> >>> of 1; which is a valid queue for any multiqueue
> >>> device.
> >>>
> >>> It seems unlikely, however as stated above is
> >>> unfortunately possible, that existing
> >>> TUNSETSTEERINGEBPF programs would choose to
> >>> return a negative value rather than return the
> >>> positive value which holds the same meaning.
> >>>
> >>> It seems more likely that future
> >>> TUNSETSTEERINGEBPF programs would leverage a
> >>> negative return and potentially be loaded into
> >>> a kernel with the old behavior.
> >>
> >> Yes, eBPF can return probably wrong value, but what kernel did is just
> >> to make sure it doesn't harm anything.
> >>
> >> I would rather just drop the packet in this case.
> >>
> > In addition to TUN_SSE_ABORT, we can
> > add TUN_SSE_DROP. That could be made the
> > default for any undefined negative
> > return as well.
> >
> >> Thanks
> >>
> >>
> >>>> 3. why doesn't userspace need a way to figure out whether it runs on=
 a kernel with and
> >>>>      without this patch
> >>> There may be some value in exposing this fact
> >>> to the ebpf prog loader. What is the standard
> >>> practice here, a define?
> >>>
> >>>> thanks,
> >>>> MST
> >>>>
> >>>>> ---
> >>>>>    drivers/net/tun.c | 20 +++++++++++---------
> >>>>>    1 file changed, 11 insertions(+), 9 deletions(-)
> >>>>>
> >>>>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> >>>>> index aab0be4..173d159 100644
> >>>>> --- a/drivers/net/tun.c
> >>>>> +++ b/drivers/net/tun.c
> >>>>> @@ -583,35 +583,37 @@ static u16 tun_automq_select_queue(struct tun=
_struct *tun, struct sk_buff *skb)
> >>>>>         return txq;
> >>>>>    }
> >>>>>
> >>>>> -static u16 tun_ebpf_select_queue(struct tun_struct *tun, struct sk=
_buff *skb)
> >>>>> +static int tun_ebpf_select_queue(struct tun_struct *tun, struct sk=
_buff *skb)
> >>>>>    {
> >>>>>         struct tun_prog *prog;
> >>>>>         u32 numqueues;
> >>>>> -     u16 ret =3D 0;
> >>>>> +     int ret =3D -1;
> >>>>>
> >>>>>         numqueues =3D READ_ONCE(tun->numqueues);
> >>>>>         if (!numqueues)
> >>>>>                 return 0;
> >>>>>
> >>>>> +     rcu_read_lock();
> >>>>>         prog =3D rcu_dereference(tun->steering_prog);
> >>>>>         if (prog)
> >>>>>                 ret =3D bpf_prog_run_clear_cb(prog->prog, skb);
> >>>>> +     rcu_read_unlock();
> >>>>>
> >>>>> -     return ret % numqueues;
> >>>>> +     if (ret >=3D 0)
> >>>>> +             ret %=3D numqueues;
> >>>>> +
> >>>>> +     return ret;
> >>>>>    }
> >>>>>
> >>>>>    static u16 tun_select_queue(struct net_device *dev, struct sk_bu=
ff *skb,
> >>>>>                             struct net_device *sb_dev)
> >>>>>    {
> >>>>>         struct tun_struct *tun =3D netdev_priv(dev);
> >>>>> -     u16 ret;
> >>>>> +     int ret;
> >>>>>
> >>>>> -     rcu_read_lock();
> >>>>> -     if (rcu_dereference(tun->steering_prog))
> >>>>> -             ret =3D tun_ebpf_select_queue(tun, skb);
> >>>>> -     else
> >>>>> +     ret =3D tun_ebpf_select_queue(tun, skb);
> >>>>> +     if (ret < 0)
> >>>>>                 ret =3D tun_automq_select_queue(tun, skb);
> >>>>> -     rcu_read_unlock();
> >>>>>
> >>>>>         return ret;
> >>>>>    }
> >>>>> --
> >>>>> 1.8.3.1
