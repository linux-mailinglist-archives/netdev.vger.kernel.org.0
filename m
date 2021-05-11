Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1514C37AF12
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 21:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232212AbhEKTIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 15:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231851AbhEKTIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 15:08:09 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FA8FC061574
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 12:07:02 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id n184so19963796oia.12
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 12:07:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Z+2tFNovZUcDgEPPmQYv2lYlE9Duihn50lxuJ1yOCWQ=;
        b=PIXgT4XG2X+/uIY36jt05vZQkE2YO+G0mpeL+fHV2dF/yYj5lBYYKPtKL5PzdK3MCU
         nnBXHvQ6pSfmOGpcgm7v8V1NNO9/IRr9s9D5DBAIelqnemp7oDG+l+8KwSM/bQ9Z0laz
         nuLcOzhi+8D+I2Ts04EHFsbdXOH6WH1HC9mVZhauXT1HhTLTAHRIxGc6m8w/j7Z4TK9W
         Votlfrv2HeXCMrVYE1XBO583Lok6h58fQ3fh8FHqgc++TtxzBMs1yHCijG3fehF5/vpK
         F55TNfhN2iSknoEIF/EpFnhCB3eRUY2OCO5J7GzPaZsnCIrMlDLfe53+d4OPEYkR01Ys
         S+gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Z+2tFNovZUcDgEPPmQYv2lYlE9Duihn50lxuJ1yOCWQ=;
        b=WVfM/TTi4HdjPdNdh7d7piFhRa4FgbCY4B7CRuZrjsGN3qCYMOo39ndSMXKxcfObb6
         1gIE2OBtacEVNq8ELUVQLWGe0bkoZbKbtr3msqoID1DPZEYhgx/4ouZg+No9BX+5Aa6a
         jQmyLC+HmxVb/N5ODUuaEgGKGIvN7TzanEJw0mAF7APJ0C0Kwiv6q7Yjpf0ZcX+qgyX+
         r8lGtQLyD9p3fQHfofO3+zrcgDS1uIZFubcjELQlieojV9ettwUXIEdQtA7wivcxqCzk
         wOblSBfXF17ET26l+WNSPok5evYo/ChjZepfttZpHd5zl4FzuXfkuR0jq5Cia/hqw1nl
         YFyQ==
X-Gm-Message-State: AOAM531fPJe3cy7mYcPDO9HX2DDE0lABVjIpqMLhtr2f0QPK9HU71kJZ
        3hw+SJXm/X4GxpfTVzpm6WxVRZk8WqA3/h/1a43olkkNRiA=
X-Google-Smtp-Source: ABdhPJytx2Ma0JJmf+z8DC+uACG6GOimDVEGBico4qHJLO1COURF9YCesedmqBiEjti+TEHg7vH6tjvjomo87/9obp0=
X-Received: by 2002:aca:4887:: with SMTP id v129mr22547971oia.137.1620760021914;
 Tue, 11 May 2021 12:07:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210511044253.469034-1-yuri.benditovich@daynix.com>
 <20210511044253.469034-5-yuri.benditovich@daynix.com> <eb8c4984-f0cc-74ee-537f-fc60deaaaa73@redhat.com>
 <CAOEp5OdrCDPx4ijLcEOm=Wxma6hc=nyqw4Xm6bggBxvgtR0tbg@mail.gmail.com>
In-Reply-To: <CAOEp5OdrCDPx4ijLcEOm=Wxma6hc=nyqw4Xm6bggBxvgtR0tbg@mail.gmail.com>
From:   Yuri Benditovich <yuri.benditovich@daynix.com>
Date:   Tue, 11 May 2021 22:06:50 +0300
Message-ID: <CAOEp5Of78_c7bGJNSCN7i+xw_N5q=MMGgr8EjnSR9moR+ugExg@mail.gmail.com>
Subject: Re: [PATCH 4/4] tun: indicate support for USO feature
To:     Jason Wang <jasowang@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Yan Vugenfirer <yan@daynix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 11, 2021 at 11:33 AM Yuri Benditovich
<yuri.benditovich@daynix.com> wrote:
>
> On Tue, May 11, 2021 at 9:50 AM Jason Wang <jasowang@redhat.com> wrote:
> >
> >
> > =E5=9C=A8 2021/5/11 =E4=B8=8B=E5=8D=8812:42, Yuri Benditovich =E5=86=99=
=E9=81=93:
> > > Signed-off-by: Yuri Benditovich <yuri.benditovich@daynix.com>
> > > ---
> > >   drivers/net/tun.c | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> > > index 84f832806313..a35054f9d941 100644
> > > --- a/drivers/net/tun.c
> > > +++ b/drivers/net/tun.c
> > > @@ -2812,7 +2812,7 @@ static int set_offload(struct tun_struct *tun, =
unsigned long arg)
> > >                       arg &=3D ~(TUN_F_TSO4|TUN_F_TSO6);
> > >               }
> > >
> > > -             arg &=3D ~TUN_F_UFO;
> > > +             arg &=3D ~(TUN_F_UFO|TUN_F_USO);
> >
> >
> > It looks to me kernel doesn't use "USO", so TUN_F_UDP_GSO_L4 is a bette=
r
> > name for this
>
> No problem, I can change it in v2
>
>  and I guess we should toggle NETIF_F_UDP_GSO_l4 here?
>
> No, we do not, because this indicates only the fact that the guest can
> send large UDP packets and have them splitted to UDP segments.
>
> >
> > And how about macvtap?
>
> We will check how to do that for macvtap. We will send a separate
> patch for macvtap or ask for advice.
>

I'll add this feature to the tap.c also (AFAIU this will enable the
USO for macvtap).
Please correct me if I'm mistaken.

> >
> > Thanks
> >
> >
> > >       }
> > >
> > >       /* This gives the user a way to test for new features in future=
 by
> >
