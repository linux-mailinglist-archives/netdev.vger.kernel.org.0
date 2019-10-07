Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47539CE892
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 18:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728079AbfJGQDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 12:03:51 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:43330 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727935AbfJGQDu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 12:03:50 -0400
Received: by mail-lf1-f66.google.com with SMTP id u3so9644998lfl.10;
        Mon, 07 Oct 2019 09:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+U+56u4o7Na2WXoYropxhfczs8fHMA7M9mdUs+PWReE=;
        b=Xh4TpPxCcQAoE6jyP1YluulUyU0xJq99mZooHAzrCwjs+h3iJqwxgrBLL+Wy6XP5zu
         7H7sQCaGyVoocAeorqddNQnBfeg7IgCw3k0chvJ+97le1AO3l7y/xO+bxazhZvBf5HXl
         F+YkI/0Qgt9+Kf3b1dCbr+kzhGSJxuQYPaadO8/HYmqhlO6Bh21MBxGakOQiWIraj0gh
         zSuPl53c7b6JFXatVY1bROIXA+hu1lBKHGVXS1+x6eIMJpn4Bf1eQ54OFxEReF0RHbUB
         Sn3AFVYRZByitYVpEkykP8r/sFOPgcYcs764VbjBEObc8yKI8axbTzDnPaZNi7SFOyBx
         X6fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+U+56u4o7Na2WXoYropxhfczs8fHMA7M9mdUs+PWReE=;
        b=eMdprjPtvvo7uGvHJDgv/buZiWqfbpWnukSMR1CiFjZ4QJMzVWyb56a/aTzfLcpD5+
         pcIgo8Lqcr+FvlCgNXMZzcw4p8GyIRznebh4RKVNdX4SyhHP/o+qBP6G/FoqHiM5Cnn4
         NUiLBqFxn/fBoMuXObwFnKR7zidnoDBvvb5lxVhHrFYAkMYziPeKl4oVZvxmyLC/fU9z
         Ps+qRDpy9h0vcNWU2xuphqOf09F48L63Pf9JwpP2q+SypcRmulIxGr9Sg7lXkABJmxYs
         Al5KwaDo1XQdGzJ68+5wWCc0we0z9NLovchjcJQ5kBykqlKtn/6koAu6ZKQN3mhyfsYn
         XUAA==
X-Gm-Message-State: APjAAAUFwLQNFKrqCh27yJTW5XwQ+URXRKQIjgl9rVkaqp9l/CxUicup
        127sKZrJBjYwKd0z3+nDeDA1xLOsagJ1Xcyh88c=
X-Google-Smtp-Source: APXvYqyRmoiXYFfRgwIoYqryNAgaJru+H6hRGUVhXzb+UTSl97Et5bj/A8oExgQP/f4gJ1WK9hUZ8B+pNN4lLaZdvfk=
X-Received: by 2002:a19:ca07:: with SMTP id a7mr18643407lfg.181.1570464227676;
 Mon, 07 Oct 2019 09:03:47 -0700 (PDT)
MIME-Version: 1.0
References: <20191006184515.23048-1-jcfaracco@gmail.com> <20191006184515.23048-3-jcfaracco@gmail.com>
 <20191007034402-mutt-send-email-mst@kernel.org> <CAENf94L+KNJgq1V6kgcwnT0hyTZMDX5Jh6kYRCaeMHDU4GGHCg@mail.gmail.com>
In-Reply-To: <CAENf94L+KNJgq1V6kgcwnT0hyTZMDX5Jh6kYRCaeMHDU4GGHCg@mail.gmail.com>
From:   Julio Faracco <jcfaracco@gmail.com>
Date:   Mon, 7 Oct 2019 13:03:34 -0300
Message-ID: <CAENf94Kamcd4TSy4wLGWLVCESiZr6q9+Kj2+3TFbFy2XncXOOw@mail.gmail.com>
Subject: Re: [PATCH RFC net-next 2/2] drivers: net: virtio_net: Add tx_timeout function
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        davem@davemloft.net, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Daiane Mendes <dnmendes76@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em seg, 7 de out de 2019 =C3=A0s 11:03, Julio Faracco <jcfaracco@gmail.com>=
 escreveu:
>
> Em seg, 7 de out de 2019 =C3=A0s 04:51, Michael S. Tsirkin <mst@redhat.co=
m> escreveu:
> >
> > On Sun, Oct 06, 2019 at 03:45:15PM -0300, jcfaracco@gmail.com wrote:
> > > From: Julio Faracco <jcfaracco@gmail.com>
> > >
> > > To enable dev_watchdog, virtio_net should have a tx_timeout defined
> > > (.ndo_tx_timeout). This is only a skeleton to throw a warn message. I=
t
> > > notifies the event in some specific queue of device. This function
> > > still counts tx_timeout statistic and consider this event as an error
> > > (one error per queue), reporting it.
> > >
> > > Signed-off-by: Julio Faracco <jcfaracco@gmail.com>
> > > Signed-off-by: Daiane Mendes <dnmendes76@gmail.com>
> > > Cc: Jason Wang <jasowang@redhat.com>
> > > ---
> > >  drivers/net/virtio_net.c | 27 +++++++++++++++++++++++++++
> > >  1 file changed, 27 insertions(+)
> > >
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index 27f9b212c9f5..4b703b4b9441 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -2585,6 +2585,29 @@ static int virtnet_set_features(struct net_dev=
ice *dev,
> > >       return 0;
> > >  }
> > >
> > > +static void virtnet_tx_timeout(struct net_device *dev)
> > > +{
> > > +     struct virtnet_info *vi =3D netdev_priv(dev);
> > > +     u32 i;
> > > +
> > > +     /* find the stopped queue the same way dev_watchdog() does */
> >
> > not really - the watchdog actually looks at trans_start.
>
> The comments are wrong. It is the negative logic from dev_watchdog.
> Watchdog requires queue stopped AND timeout.
>
> If the queue is not stopped, this queue does not reached a timeout event.
> So, continue... Do not report a timeout.
>
> >
> > > +     for (i =3D 0; i < vi->curr_queue_pairs; i++) {
> > > +             struct send_queue *sq =3D &vi->sq[i];
> > > +
> > > +             if (!netif_xmit_stopped(netdev_get_tx_queue(dev, i)))
> > > +                     continue;
> > > +
> > > +             u64_stats_update_begin(&sq->stats.syncp);
> > > +             sq->stats.tx_timeouts++;
> > > +             u64_stats_update_end(&sq->stats.syncp);
> > > +
> > > +             netdev_warn(dev, "TX timeout on send queue: %d, sq: %s,=
 vq: %d, name: %s\n",
> > > +                         i, sq->name, sq->vq->index, sq->vq->name);
> >
> > this seems to assume any running queue is timed out.
> > doesn't look right.
> >
> > also - there's already a warning in this case in the core. do we need a=
nother one?
>
> Here, it can be a debug message if the idea is enhance debugging informat=
ion.
> Other enhancements can be done to enable or disable debug messages.
> Using ethtool methods for instance.

Observation...
Another important point, kernel will thrown WARN_ONCE, only if
ndo_tx_timeout() is implemented.
Even if we are adding an extra/unnecessary netdev_warn() we need this
function to enable dev_watchdog().

>
> >
> > > +             dev->stats.tx_errors++;
> >
> >
> >
> > > +     }
> > > +}
> > > +
> > >  static const struct net_device_ops virtnet_netdev =3D {
> > >       .ndo_open            =3D virtnet_open,
> > >       .ndo_stop            =3D virtnet_close,
> > > @@ -2600,6 +2623,7 @@ static const struct net_device_ops virtnet_netd=
ev =3D {
> > >       .ndo_features_check     =3D passthru_features_check,
> > >       .ndo_get_phys_port_name =3D virtnet_get_phys_port_name,
> > >       .ndo_set_features       =3D virtnet_set_features,
> > > +     .ndo_tx_timeout         =3D virtnet_tx_timeout,
> > >  };
> > >
> > >  static void virtnet_config_changed_work(struct work_struct *work)
> > > @@ -3018,6 +3042,9 @@ static int virtnet_probe(struct virtio_device *=
vdev)
> > >       dev->netdev_ops =3D &virtnet_netdev;
> > >       dev->features =3D NETIF_F_HIGHDMA;
> > >
> > > +     /* Set up dev_watchdog cycle. */
> > > +     dev->watchdog_timeo =3D 5 * HZ;
> > > +
> >
> > Seems to be still broken with napi_tx =3D false.
> >
> > >       dev->ethtool_ops =3D &virtnet_ethtool_ops;
> > >       SET_NETDEV_DEV(dev, &vdev->dev);
> > >
> > > --
> > > 2.21.0
