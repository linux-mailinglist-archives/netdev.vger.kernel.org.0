Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87FC41247AD
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 14:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbfLRNJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 08:09:36 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:35471 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbfLRNJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 08:09:36 -0500
Received: by mail-qv1-f66.google.com with SMTP id u10so634233qvi.2;
        Wed, 18 Dec 2019 05:09:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9fMhu2HY6cXBY8c2OuJYtWQsWKKglKnVQNGShQV3bMI=;
        b=lvopBNbqu0sI9I6IF8sHtepj3mAuUBZtc/Qyhrc/hqLfmMi7wqcrr1+6IzIMNVUASf
         Px+o0LbUnMF6zS++gEEuPkUNw5UYdN8Gyl1Ph9qS/jrfj7uGCeYQpYkW8OcLBGMwPFvi
         7tkNlQY9To+WPfTzsDcDcV9kNwJr9Gzv5qNPjgJn8T+2t6FtpM5AxKk2U3GI63WluE3o
         quY/ZaLr6yWQK1xM12FO1v+p13L8qjgkOIcQEehslLpdPKc2M+qg59hv5vkNODaiCoSG
         tIvVC+ZZY8XF6hMDUrgcwAo9DA78A+khXENCT3UMVk1C8GpvQSL2F1M7rjw7Z2sxO2dA
         E/jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9fMhu2HY6cXBY8c2OuJYtWQsWKKglKnVQNGShQV3bMI=;
        b=R47EPNwgWYSjP1v8Xp8fLBqh4Ue7lpVVli/o82bvICuw3Fr++Zu1YRTM4EGPm3FriV
         yjiOuoW6PaC/kXI3On6YF8CpYOwg5DTiS3Kkt03VFo/rO4zaaI8PFGGhy9es2hb52utn
         jD2TD0L81PVNvrCJnRPoEgMHtR3xtunZkzX1ohHj0J1skn+lMws6gRZGcL33DagQtJte
         rv7quiwEJmJJ7nx/oCsgWBj82u/MKdXzfMFQH7SEECxTmbv2sWeV0GZRlMqBlUOztXq6
         XgtvGabt5wOURib9CQmZFLFFcnQcYcUGEv9u3/fBZKjqkL/e18y9LdAyjsCB7zFBVtdw
         s06g==
X-Gm-Message-State: APjAAAVxZxZu9zyvbi6+StRNW7k6LFSk4A/1Ozmt2l42/YOYDxlIu6Ii
        GOp2/uT7a8l5YkiOxur0cgwicNuVdkKVo8PFYq0=
X-Google-Smtp-Source: APXvYqw5/kKXEadfnvekAx2yUiKXwcZWl7qWOZL2Bw3dU6/BRHJYZQTGg1SRlqStBl3ByZ+pshyQiV6TW04lnxok7xg=
X-Received: by 2002:a0c:e2cf:: with SMTP id t15mr2175626qvl.127.1576674575416;
 Wed, 18 Dec 2019 05:09:35 -0800 (PST)
MIME-Version: 1.0
References: <20191218105400.2895-1-bjorn.topel@gmail.com> <20191218105400.2895-8-bjorn.topel@gmail.com>
 <20191218140318.2c1d7140@carbon>
In-Reply-To: <20191218140318.2c1d7140@carbon>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 18 Dec 2019 14:09:23 +0100
Message-ID: <CAJ+HfNjg5kRhBuWQ0F1jM+YL8CYW2okes0jbFy6MQw9umT_dcA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 7/8] xdp: remove map_to_flush and map swap detection
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Dec 2019 at 14:03, Jesper Dangaard Brouer <jbrouer@redhat.com> w=
rote:
>
> On Wed, 18 Dec 2019 11:53:59 +0100
> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> wrote:
>
> > From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >
> > Now that all XDP maps that can be used with bpf_redirect_map() tracks
> > entries to be flushed in a global fashion, there is not need to track
> > that the map has changed and flush from xdp_do_generic_map()
> > anymore. All entries will be flushed in xdp_do_flush_map().
> >
> > This means that the map_to_flush can be removed, and the corresponding
> > checks. Moving the flush logic to one place, xdp_do_flush_map(), give
> > a bulking behavior and performance boost.
> >
> > Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> > ---
> >  include/linux/filter.h |  1 -
> >  net/core/filter.c      | 27 +++------------------------
> >  2 files changed, 3 insertions(+), 25 deletions(-)
> >
> > diff --git a/include/linux/filter.h b/include/linux/filter.h
> > index 37ac7025031d..69d6706fc889 100644
> > --- a/include/linux/filter.h
> > +++ b/include/linux/filter.h
> > @@ -592,7 +592,6 @@ struct bpf_redirect_info {
> >       u32 tgt_index;
> >       void *tgt_value;
> >       struct bpf_map *map;
> > -     struct bpf_map *map_to_flush;
> >       u32 kern_flags;
> >  };
> >
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index c706325b3e66..d9caa3e57ea1 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -3547,26 +3547,9 @@ static int __bpf_tx_xdp_map(struct net_device *d=
ev_rx, void *fwd,
> >
> >  void xdp_do_flush_map(void)
> >  {
> > -     struct bpf_redirect_info *ri =3D this_cpu_ptr(&bpf_redirect_info)=
;
> > -     struct bpf_map *map =3D ri->map_to_flush;
> > -
> > -     ri->map_to_flush =3D NULL;
> > -     if (map) {
> > -             switch (map->map_type) {
> > -             case BPF_MAP_TYPE_DEVMAP:
> > -             case BPF_MAP_TYPE_DEVMAP_HASH:
> > -                     __dev_map_flush();
> > -                     break;
> > -             case BPF_MAP_TYPE_CPUMAP:
> > -                     __cpu_map_flush();
> > -                     break;
> > -             case BPF_MAP_TYPE_XSKMAP:
> > -                     __xsk_map_flush();
> > -                     break;
> > -             default:
> > -                     break;
> > -             }
> > -     }
> > +     __dev_map_flush();
> > +     __cpu_map_flush();
> > +     __xsk_map_flush();
> >  }
> >  EXPORT_SYMBOL_GPL(xdp_do_flush_map);
> >
> > @@ -3615,14 +3598,10 @@ static int xdp_do_redirect_map(struct net_devic=
e *dev, struct xdp_buff *xdp,
> >       ri->tgt_value =3D NULL;
> >       WRITE_ONCE(ri->map, NULL);
> >
> > -     if (ri->map_to_flush && unlikely(ri->map_to_flush !=3D map))
> > -             xdp_do_flush_map();
> > -
>
> I guess, I need to read the other patches to understand why this is valid=
.
>

Please do; Review would be very much appreciated!

> The idea here is to detect if the BPF-prog are using several different
> redirect maps, and do the flush if the program uses another map.  I
> assume you handle this?
>

Yes, the highlevel idea is that since the maps are dealing partly with
this already (but swaps map internal), let the map code deal with map
swaps as well.
