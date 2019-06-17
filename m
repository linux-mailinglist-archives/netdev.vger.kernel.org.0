Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4BDA47EF4
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 11:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727990AbfFQJ6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 05:58:51 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:33339 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727518AbfFQJ6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 05:58:51 -0400
Received: by mail-lj1-f193.google.com with SMTP id h10so8686781ljg.0
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 02:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:cc
         :content-transfer-encoding;
        bh=iKqfthJLs1khkBsV+9UVzZvxk7yU7AKPa89YLxvDkt8=;
        b=a0kldUnvCzKXA0fC7dVwmGOliSB+fCQqJBomISMdL+7z7eXfU/C6p7XF6xdLk7EPX0
         H7tNMTneARolfMaUFdZscMu9rEbV+6psTYYJox+ZkcF5sFgo8+TASmCB9RrwXhw7+QGg
         /4hWtWE22KHRVq1BQ0XW00zQniaOnOO2Kn83pdpoCmgmhvlOsVwSAKPGUrIQxjQs75rm
         3BAqjxkxHlQUg7AnIu1p/Us3tvhat1nRcYBzHjhK8tJ5Yy+Xjvby3DHd9WoS95Bo6RgD
         6T5wNIyWCV+C9u7zfbKL8Zc0zmHZxf46Xeg93K4AlDHUh7iMYnx/xR+pF0MGLsEnda9F
         BYWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:cc:content-transfer-encoding;
        bh=iKqfthJLs1khkBsV+9UVzZvxk7yU7AKPa89YLxvDkt8=;
        b=bD1pQzbp6Nhc2nvKamUvl/Ff8Q/ENTIRjMHntCuOsZolaNKYz2CUXc20ac0lw4+6Gs
         uex2fEjrY703yD0WIhAwkBBiXwSHnadKBVvy5UiJjmAp9mTHycTrU/WbJQyTI8hvgVqa
         qNeGavSAehbwn06PiBNFDDsz2EGT7aXuELQFrgd2euPftWGA01pa669b0NTBJY45Gx2A
         DvvFjYglgCD7HVYTPt7oTlvRcLZ3iAzLyLK5usEslv3+vT5FjzQD8sbAA4w9RleLzD6c
         0hwSCE8HOrSG8PxiAXt5I1oC4qcKPrS87mMDcx834YAdUHIXuL9uRJPrRqR0S478xION
         dBUw==
X-Gm-Message-State: APjAAAVBdBpH/4Gjafaq59GVzj9THn3EVQMgUnLm9wlDJZqWY415jTz/
        rakTjPpc4C21SGpX7xkDlTUeldfQjXiRVl+DHN3nSvqGrtS20Q==
X-Received: by 2002:a2e:8847:: with SMTP id z7mt10098340ljj.51.1560765529616;
 Mon, 17 Jun 2019 02:58:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190617073320.69015-1-lifei.shirley@bytedance.com>
 <28bef625-ce70-20a1-7d8b-296cd43015c4@redhat.com> <2d05dce3-e19a-2f0f-8b74-8defae38640d@redhat.com>
In-Reply-To: <2d05dce3-e19a-2f0f-8b74-8defae38640d@redhat.com>
From:   =?UTF-8?B?5p2O6I+y?= <lifei.shirley@bytedance.com>
Date:   Mon, 17 Jun 2019 17:58:38 +0800
Message-ID: <CA+=e4K6G0apU2psFYDtFDbpE14nfBB_sD_Y2rK-v3=nYPO8B3Q@mail.gmail.com>
Subject: Re: [External Email] Re: [PATCH] Fix tun: wake up waitqueues after
 IFF_UP is set
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ok, thanks for the detail suggestion! :)


On Mon, Jun 17, 2019 at 4:16 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2019/6/17 =E4=B8=8B=E5=8D=884:10, Jason Wang wrote:
> >
> > On 2019/6/17 =E4=B8=8B=E5=8D=883:33, Fei Li wrote:
> >> Currently after setting tap0 link up, the tun code wakes tx/rx waited
> >> queues up in tun_net_open() when .ndo_open() is called, however the
> >> IFF_UP flag has not been set yet. If there's already a wait queue, it
> >> would fail to transmit when checking the IFF_UP flag in tun_sendmsg().
> >> Then the saving vhost_poll_start() will add the wq into wqh until it
> >> is waken up again. Although this works when IFF_UP flag has been set
> >> when tun_chr_poll detects; this is not true if IFF_UP flag has not
> >> been set at that time. Sadly the latter case is a fatal error, as
> >> the wq will never be waken up in future unless later manually
> >> setting link up on purpose.
> >>
> >> Fix this by moving the wakeup process into the NETDEV_UP event
> >> notifying process, this makes sure IFF_UP has been set before all
> >> waited queues been waken up.
>
>
> Btw, the title needs some tweak. E.g you need use "net" as prefix since
> it's a fix for net.git and "Fix" could be removed like:
>
> [PATCH net] tun: wake up waitqueues after IFF_UP is set.
>
> Thanks
>
>
> >>
> >> Signed-off-by: Fei Li <lifei.shirley@bytedance.com>
> >> ---
> >>   drivers/net/tun.c | 17 +++++++++--------
> >>   1 file changed, 9 insertions(+), 8 deletions(-)
> >>
> >> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> >> index c452d6d831dd..a3c9cab5a4d0 100644
> >> --- a/drivers/net/tun.c
> >> +++ b/drivers/net/tun.c
> >> @@ -1015,17 +1015,9 @@ static void tun_net_uninit(struct net_device
> >> *dev)
> >>   static int tun_net_open(struct net_device *dev)
> >>   {
> >>       struct tun_struct *tun =3D netdev_priv(dev);
> >> -    int i;
> >>         netif_tx_start_all_queues(dev);
> >>   -    for (i =3D 0; i < tun->numqueues; i++) {
> >> -        struct tun_file *tfile;
> >> -
> >> -        tfile =3D rtnl_dereference(tun->tfiles[i]);
> >> - tfile->socket.sk->sk_write_space(tfile->socket.sk);
> >> -    }
> >> -
> >>       return 0;
> >>   }
> >>   @@ -3634,6 +3626,7 @@ static int tun_device_event(struct
> >> notifier_block *unused,
> >>   {
> >>       struct net_device *dev =3D netdev_notifier_info_to_dev(ptr);
> >>       struct tun_struct *tun =3D netdev_priv(dev);
> >> +    int i;
> >>         if (dev->rtnl_link_ops !=3D &tun_link_ops)
> >>           return NOTIFY_DONE;
> >> @@ -3643,6 +3636,14 @@ static int tun_device_event(struct
> >> notifier_block *unused,
> >>           if (tun_queue_resize(tun))
> >>               return NOTIFY_BAD;
> >>           break;
> >> +    case NETDEV_UP:
> >> +        for (i =3D 0; i < tun->numqueues; i++) {
> >> +            struct tun_file *tfile;
> >> +
> >> +            tfile =3D rtnl_dereference(tun->tfiles[i]);
> >> + tfile->socket.sk->sk_write_space(tfile->socket.sk);
> >> +        }
> >> +        break;
> >>       default:
> >>           break;
> >>       }
> >
> >
> > Acked-by: Jason Wang <jasowang@redhat.com)
> >
