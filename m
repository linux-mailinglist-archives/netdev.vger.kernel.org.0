Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC4DFCE499
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 16:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727838AbfJGOEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 10:04:14 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:35845 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727685AbfJGOEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 10:04:14 -0400
Received: by mail-lj1-f196.google.com with SMTP id v24so13811791ljj.3;
        Mon, 07 Oct 2019 07:04:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7sEOczYia3KOKHGEcMhkwGMtTevaZ3R4NRuGCoRYvdA=;
        b=cKyDL7ABIR1BUZNmXm35gwM0xfdn5S4tvmbrFqSfzpRqMBMrRRJmldvuXRH2OIH5KR
         7Wa5BdkX7uuiZJqDi17puIjACYQqO+BBV6Y/E9ctsbau6M3XPSMGP1unSpNVGwn6ROgC
         C8/dcdwkbN2TMvoGO8ZJQQJGMh4SHRfosL7+Eu7GHng0xmHIiH+t1vOaON1lyWLL/cl3
         E94i1Q8IN2C0+TX6it6guD6PaUgVkVrxLcQlzx5EhPREY2QlKnGaS7fYMfR9BUBNlhtk
         Mh4y+7Y0qMDe6c+LWH8CL3QGZAqq9lV4L29fSuCD5veS/RtX3WzQLh7w+cm/dxqDpLSa
         4Weg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7sEOczYia3KOKHGEcMhkwGMtTevaZ3R4NRuGCoRYvdA=;
        b=bQBoNPDmFUJ1urepwQ16FrrcIIxgzfvQaNIkDv7VD35QXHoA7j/uDczg1SwLzGpOJk
         N/nHRz9KPc6KuSMY25IT5AVSCXnXy9yjT16hnDoqOZWaigkCX7zo2q7xLNArQnjw61fg
         DCxcpxSkmMAKRk2Kpj0/1ipTs+cfaGm/6moqKTmQd6m9sw7+7gv2JGfLAPJuI7JkUBMI
         XgT9QWZAGVKv7F5X8GIOEvOC6WzWgw7Sq9qrw54l1zCrKn0TnYDFvu2Hd0qiK3TYKf9W
         Z3Csmhz6tGJ5PJ9jQskf6MWfdRoGamr7jNh8zbZrCRjg22YC3X9c5zrncP72lJGa1Cta
         ZZTw==
X-Gm-Message-State: APjAAAULrP+mr3evoXoFAzvdxPG7WbUcfMdlFOYaA2j8QOi2AX9diIBC
        orA0pW0e8qhHFA+5TPaxdLMdrCoxWB3jsB2W9P8tUQ==
X-Google-Smtp-Source: APXvYqz9rauiSGXNFl9949c8WXsIKrXSSJ2p9Te0Emowvi+R4IoeeF0Fnh2b41vtw5Od7As9Ba6IikYV7IL9gHnaNt4=
X-Received: by 2002:a2e:8ed2:: with SMTP id e18mr9988415ljl.180.1570457049844;
 Mon, 07 Oct 2019 07:04:09 -0700 (PDT)
MIME-Version: 1.0
References: <20191006184515.23048-1-jcfaracco@gmail.com> <20191006184515.23048-3-jcfaracco@gmail.com>
 <20191007034402-mutt-send-email-mst@kernel.org>
In-Reply-To: <20191007034402-mutt-send-email-mst@kernel.org>
From:   Julio Faracco <jcfaracco@gmail.com>
Date:   Mon, 7 Oct 2019 11:03:58 -0300
Message-ID: <CAENf94L+KNJgq1V6kgcwnT0hyTZMDX5Jh6kYRCaeMHDU4GGHCg@mail.gmail.com>
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

Em seg, 7 de out de 2019 =C3=A0s 04:51, Michael S. Tsirkin <mst@redhat.com>=
 escreveu:
>
> On Sun, Oct 06, 2019 at 03:45:15PM -0300, jcfaracco@gmail.com wrote:
> > From: Julio Faracco <jcfaracco@gmail.com>
> >
> > To enable dev_watchdog, virtio_net should have a tx_timeout defined
> > (.ndo_tx_timeout). This is only a skeleton to throw a warn message. It
> > notifies the event in some specific queue of device. This function
> > still counts tx_timeout statistic and consider this event as an error
> > (one error per queue), reporting it.
> >
> > Signed-off-by: Julio Faracco <jcfaracco@gmail.com>
> > Signed-off-by: Daiane Mendes <dnmendes76@gmail.com>
> > Cc: Jason Wang <jasowang@redhat.com>
> > ---
> >  drivers/net/virtio_net.c | 27 +++++++++++++++++++++++++++
> >  1 file changed, 27 insertions(+)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 27f9b212c9f5..4b703b4b9441 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -2585,6 +2585,29 @@ static int virtnet_set_features(struct net_devic=
e *dev,
> >       return 0;
> >  }
> >
> > +static void virtnet_tx_timeout(struct net_device *dev)
> > +{
> > +     struct virtnet_info *vi =3D netdev_priv(dev);
> > +     u32 i;
> > +
> > +     /* find the stopped queue the same way dev_watchdog() does */
>
> not really - the watchdog actually looks at trans_start.

The comments are wrong. It is the negative logic from dev_watchdog.
Watchdog requires queue stopped AND timeout.

If the queue is not stopped, this queue does not reached a timeout event.
So, continue... Do not report a timeout.

>
> > +     for (i =3D 0; i < vi->curr_queue_pairs; i++) {
> > +             struct send_queue *sq =3D &vi->sq[i];
> > +
> > +             if (!netif_xmit_stopped(netdev_get_tx_queue(dev, i)))
> > +                     continue;
> > +
> > +             u64_stats_update_begin(&sq->stats.syncp);
> > +             sq->stats.tx_timeouts++;
> > +             u64_stats_update_end(&sq->stats.syncp);
> > +
> > +             netdev_warn(dev, "TX timeout on send queue: %d, sq: %s, v=
q: %d, name: %s\n",
> > +                         i, sq->name, sq->vq->index, sq->vq->name);
>
> this seems to assume any running queue is timed out.
> doesn't look right.
>
> also - there's already a warning in this case in the core. do we need ano=
ther one?

Here, it can be a debug message if the idea is enhance debugging informatio=
n.
Other enhancements can be done to enable or disable debug messages.
Using ethtool methods for instance.

>
> > +             dev->stats.tx_errors++;
>
>
>
> > +     }
> > +}
> > +
> >  static const struct net_device_ops virtnet_netdev =3D {
> >       .ndo_open            =3D virtnet_open,
> >       .ndo_stop            =3D virtnet_close,
> > @@ -2600,6 +2623,7 @@ static const struct net_device_ops virtnet_netdev=
 =3D {
> >       .ndo_features_check     =3D passthru_features_check,
> >       .ndo_get_phys_port_name =3D virtnet_get_phys_port_name,
> >       .ndo_set_features       =3D virtnet_set_features,
> > +     .ndo_tx_timeout         =3D virtnet_tx_timeout,
> >  };
> >
> >  static void virtnet_config_changed_work(struct work_struct *work)
> > @@ -3018,6 +3042,9 @@ static int virtnet_probe(struct virtio_device *vd=
ev)
> >       dev->netdev_ops =3D &virtnet_netdev;
> >       dev->features =3D NETIF_F_HIGHDMA;
> >
> > +     /* Set up dev_watchdog cycle. */
> > +     dev->watchdog_timeo =3D 5 * HZ;
> > +
>
> Seems to be still broken with napi_tx =3D false.
>
> >       dev->ethtool_ops =3D &virtnet_ethtool_ops;
> >       SET_NETDEV_DEV(dev, &vdev->dev);
> >
> > --
> > 2.21.0
