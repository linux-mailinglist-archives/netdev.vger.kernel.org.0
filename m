Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF50C3CAD5
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 14:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390190AbfFKMNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 08:13:55 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:46018 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387538AbfFKMNz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 08:13:55 -0400
Received: by mail-qk1-f193.google.com with SMTP id s22so7432457qkj.12;
        Tue, 11 Jun 2019 05:13:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=F9sYH77GwvTWnaxRoVTLn2O5wlIPDpWETDCvIeRmDxQ=;
        b=UgdruSVxQRPvNbG+O2D3QZ56HicZqoGkRxd7toiTK9riWtndBDF8MUOoILQlKdslmC
         OWEL+p8ii3pjYX3RYJ81aVgBYRTdeJ6l7F0D+t2m4kgLH9ATd+HFq/X+rimOjbIoE2LU
         X9n8feS4kUdKnEa0d64DhavWczONBQQRBVMp94R15lmAjvYhQuzFH633AaCUxKXCRVhp
         Eenf4TyyMR9VMp/2t19u4RXJUELYXo/kf/O8R+itig9DVfcd+YpV0pj46FUFfDDkEYiN
         dGz1rffROcVWshBiCjyC/dT3HkPdX2rc+caLpLtHIpNodfk7GbMfAWbqACzJJOXJz/qN
         Txlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=F9sYH77GwvTWnaxRoVTLn2O5wlIPDpWETDCvIeRmDxQ=;
        b=UGr0dwY9TipFEQFFzLXo9gk5DTjeLFgc3lbDDSQk8doZMwEzy4W+3zo1vDG8xhb92i
         8WMYg1HmN32xZg0tHb0afaiFdClmCUiiJKaEfZK70/RMjJsY20AfVT6xZWkDsAhoNmRs
         ME+6jk4W7a4HY+mskHiOkG4UX52iphg9Dr+KSJDF9TEINK65+yhQcNK4UcKOJz5g3e/x
         TK//feOoGRxO6OqzctNSCk5hQ/TaVVPssK/vAPyGkM0jBOQ/oGMWKjIAiqW2CIjTDVCH
         Pgs4xxRcnqr8Jj87FNqHSm+FwGCRsHcMu+xqHbu6mR1Gk6v4Ib5DgYZUpv5EPm/Q+aWg
         NbuQ==
X-Gm-Message-State: APjAAAW2CaNzHA0jzXPkLge6DxLW76diC/zW+njElm7lHXpmthX+vSMH
        spdeBIMXsByEhEIe0/zAXm4FtWdcE/+Asgxjxto=
X-Google-Smtp-Source: APXvYqy+8DtsFTnS1eutVJbGzdlAhJ6iOi3oNQB1UWBvgvol3QTsgQYcWNOyMNDHpKIqYnVu2UnGjmICYET/jeLkm0I=
X-Received: by 2002:a37:7786:: with SMTP id s128mr59952244qkc.63.1560255233555;
 Tue, 11 Jun 2019 05:13:53 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20190610161551eucas1p1f370190ee6d0d5e921de1a21f3da72df@eucas1p1.samsung.com>
 <20190610161546.30569-1-i.maximets@samsung.com> <06C99519-64B9-4A91-96B9-0F99731E3857@gmail.com>
 <CAJ+HfNgdiutAwpnc3LDDEGXs2SFCu3UtMnao79sFNyZZpQ2ETw@mail.gmail.com> <e2313edb-6617-cd52-1a40-4712c9f20127@samsung.com>
In-Reply-To: <e2313edb-6617-cd52-1a40-4712c9f20127@samsung.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 11 Jun 2019 14:13:42 +0200
Message-ID: <CAJ+HfNgsxwDFdsfsNkpendnc=uwrkXakLBRw=WnjLMCG93z_3w@mail.gmail.com>
Subject: Re: [PATCH bpf v3] xdp: fix hang while unregistering device bound to
 xdp socket
To:     Ilya Maximets <i.maximets@samsung.com>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Xdp <xdp-newbies@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 11 Jun 2019 at 10:42, Ilya Maximets <i.maximets@samsung.com> wrote:
>
> On 11.06.2019 11:09, Bj=C3=B6rn T=C3=B6pel wrote:
> > On Mon, 10 Jun 2019 at 22:49, Jonathan Lemon <jonathan.lemon@gmail.com>=
 wrote:
> >>
> >> On 10 Jun 2019, at 9:15, Ilya Maximets wrote:
> >>
> >>> Device that bound to XDP socket will not have zero refcount until the
> >>> userspace application will not close it. This leads to hang inside
> >>> 'netdev_wait_allrefs()' if device unregistering requested:
> >>>
> >>>   # ip link del p1
> >>>   < hang on recvmsg on netlink socket >
> >>>
> >>>   # ps -x | grep ip
> >>>   5126  pts/0    D+   0:00 ip link del p1
> >>>
> >>>   # journalctl -b
> >>>
> >>>   Jun 05 07:19:16 kernel:
> >>>   unregister_netdevice: waiting for p1 to become free. Usage count =
=3D 1
> >>>
> >>>   Jun 05 07:19:27 kernel:
> >>>   unregister_netdevice: waiting for p1 to become free. Usage count =
=3D 1
> >>>   ...
> >>>
> >>> Fix that by implementing NETDEV_UNREGISTER event notification handler
> >>> to properly clean up all the resources and unref device.
> >>>
> >>> This should also allow socket killing via ss(8) utility.
> >>>
> >>> Fixes: 965a99098443 ("xsk: add support for bind for Rx")
> >>> Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
> >>> ---
> >>>
> >>> Version 3:
> >>>
> >>>     * Declaration lines ordered from longest to shortest.
> >>>     * Checking of event type moved to the top to avoid unnecessary
> >>>       locking.
> >>>
> >>> Version 2:
> >>>
> >>>     * Completely re-implemented using netdev event handler.
> >>>
> >>>  net/xdp/xsk.c | 65
> >>> ++++++++++++++++++++++++++++++++++++++++++++++++++-
> >>>  1 file changed, 64 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> >>> index a14e8864e4fa..273a419a8c4d 100644
> >>> --- a/net/xdp/xsk.c
> >>> +++ b/net/xdp/xsk.c
> >>> @@ -693,6 +693,57 @@ static int xsk_mmap(struct file *file, struct
> >>> socket *sock,
> >>>                              size, vma->vm_page_prot);
> >>>  }
> >>>
> >>> +static int xsk_notifier(struct notifier_block *this,
> >>> +                     unsigned long msg, void *ptr)
> >>> +{
> >>> +     struct net_device *dev =3D netdev_notifier_info_to_dev(ptr);
> >>> +     struct net *net =3D dev_net(dev);
> >>> +     int i, unregister_count =3D 0;
> >>> +     struct sock *sk;
> >>> +
> >>> +     switch (msg) {
> >>> +     case NETDEV_UNREGISTER:
> >>> +             mutex_lock(&net->xdp.lock);
> >>
> >> The call is under the rtnl lock, and we're not modifying
> >> the list, so this mutex shouldn't be needed.
> >>
> >
> > The list can, however, be modified outside the rtnl lock (e.g. at
> > socket creation). AFAIK the hlist cannot be traversed lock-less,
> > right?
>
> We could use 'rcu_read_lock' instead and iterate with 'sk_for_each_rcu',
> but we'll not be able to synchronize inside.
>
> >
> >>
> >>> +             sk_for_each(sk, &net->xdp.list) {
> >>> +                     struct xdp_sock *xs =3D xdp_sk(sk);
> >>> +
> >>> +                     mutex_lock(&xs->mutex);
> >>> +                     if (dev !=3D xs->dev) {
> >>> +                             mutex_unlock(&xs->mutex);
> >>> +                             continue;
> >>> +                     }
> >>> +
> >>> +                     sk->sk_err =3D ENETDOWN;
> >>> +                     if (!sock_flag(sk, SOCK_DEAD))
> >>> +                             sk->sk_error_report(sk);
> >>> +
> >>> +                     /* Wait for driver to stop using the xdp socket=
. */
> >>> +                     xdp_del_sk_umem(xs->umem, xs);
> >>> +                     xs->dev =3D NULL;
> >>> +                     synchronize_net();
> >> Isn't this by handled by the unregister_count case below?
> >>
> >
> > To clarify, setting dev to NULL and xdp_del_sk_umem() + sync makes
> > sure that a driver doesn't touch the Tx and Rx rings. Nothing can be
> > assumed about completion + fill ring (umem), until zero-copy has been
> > disabled via ndo_bpf.
> >
> >>> +
> >>> +                     /* Clear device references in umem. */
> >>> +                     xdp_put_umem(xs->umem);
> >>> +                     xs->umem =3D NULL;
> >>
> >> This makes me uneasy.  We need to unregister the umem from
> >> the device (xdp_umem_clear_dev()) but this can remove the umem
> >> pages out from underneath the xsk.
> >>
> >
> > Yes, this is scary. The socket is alive, and userland typically has
> > the fill/completion rings mmapped. Then the umem refcount is decreased
> > and can potentially free the umem (fill rings etc.), as Jonathan says,
> > underneath the xsk. Also, setting the xs umem/dev to zero, while the
> > socket is alive, would allow a user to re-setup the socket, which we
> > don't want to allow.
> >
> >> Perhaps what's needed here is the equivalent of an unbind()
> >> call that just detaches the umem/sk from the device, but does
> >> not otherwise tear them down.
> >>
> >
> > Yeah, I agree. A detached/zombie state is needed during the socket life=
time.
>
>
> I could try to rip the 'xdp_umem_release()' apart so the 'xdp_umem_clear_=
dev()'
> could be called separately. This will allow to not tear down the 'umem'.
> However, it seems that it'll not be easy to synchronize all parts.
> Any suggestions are welcome.
>

Thanks for continuing to work on this, Ilya.

What need to be done is exactly an "unbind()", i.e. returning the
socket to the state prior bind, but disallowing any changes from
userland (e.g. setsockopt/bind). So, unbind() + track that we're in
"unbound" mode. :-) I think breaking up xdp_umem_release() is good way
to go.

> Also, there is no way to not clear the 'dev' as we have to put the refere=
nce.
> Maybe we could add the additional check to 'xsk_bind()' for current devic=
e
> state (dev->reg_state =3D=3D NETREG_REGISTERED). This will allow us to av=
oid
> re-setup of the socket.
>

Yes, and also make sure that the rest of the syscall implementations
don't allow for re-setup.


Bj=C3=B6rn

> >
> >>
> >>> +                     mutex_unlock(&xs->mutex);
> >>> +                     unregister_count++;
> >>> +             }
> >>> +             mutex_unlock(&net->xdp.lock);
> >>> +
> >>> +             if (unregister_count) {
> >>> +                     /* Wait for umem clearing completion. */
> >>> +                     synchronize_net();
> >>> +                     for (i =3D 0; i < unregister_count; i++)
> >>> +                             dev_put(dev);
> >>> +             }
> >>> +
> >>> +             break;
> >>> +     }
> >>> +
> >>> +     return NOTIFY_DONE;
> >>> +}
> >>> +
> >>>  static struct proto xsk_proto =3D {
> >>>       .name =3D         "XDP",
> >>>       .owner =3D        THIS_MODULE,
> >>> @@ -727,7 +778,8 @@ static void xsk_destruct(struct sock *sk)
> >>>       if (!sock_flag(sk, SOCK_DEAD))
> >>>               return;
> >>>
> >>> -     xdp_put_umem(xs->umem);
> >>> +     if (xs->umem)
> >>> +             xdp_put_umem(xs->umem);
> >> Not needed - xdp_put_umem() already does a null check.
>
> Indeed. Thanks.
>
> >> --
> >> Jonathan
> >>
> >>
> >>>
> >>>       sk_refcnt_debug_dec(sk);
> >>>  }
> >>> @@ -784,6 +836,10 @@ static const struct net_proto_family
> >>> xsk_family_ops =3D {
> >>>       .owner  =3D THIS_MODULE,
> >>>  };
> >>>
> >>> +static struct notifier_block xsk_netdev_notifier =3D {
> >>> +     .notifier_call  =3D xsk_notifier,
> >>> +};
> >>> +
> >>>  static int __net_init xsk_net_init(struct net *net)
> >>>  {
> >>>       mutex_init(&net->xdp.lock);
> >>> @@ -816,8 +872,15 @@ static int __init xsk_init(void)
> >>>       err =3D register_pernet_subsys(&xsk_net_ops);
> >>>       if (err)
> >>>               goto out_sk;
> >>> +
> >>> +     err =3D register_netdevice_notifier(&xsk_netdev_notifier);
> >>> +     if (err)
> >>> +             goto out_pernet;
> >>> +
> >>>       return 0;
> >>>
> >>> +out_pernet:
> >>> +     unregister_pernet_subsys(&xsk_net_ops);
> >>>  out_sk:
> >>>       sock_unregister(PF_XDP);
> >>>  out_proto:
> >>> --
> >>> 2.17.1
> >
> >
