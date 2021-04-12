Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF82735C587
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 13:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240534AbhDLLpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 07:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240443AbhDLLpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 07:45:42 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F5FC061574;
        Mon, 12 Apr 2021 04:45:24 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id j24so2252089oii.11;
        Mon, 12 Apr 2021 04:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=niGasz/eM06qJhxp3ZsE78K6CaXcyr8llf9XfXoWBB4=;
        b=be9hqs6tJwPTar0irxWF/DI/+9HLjjKUwK0l0jubFznBmiW49NOUUujRVH8OxyRIx3
         N8Z2MtKJibI3zVZISj+RaJU6nsLTA3alxV4+87UsaJvl6fgltx0+jFroOKUKkgz7VY1T
         VrYYh2ZnBzp9l/8iI7y/J3qFjb5u4lh7Y3NqXkryFwD598Y3voa2KzDi46HoAK985ouZ
         X8gMdAIT9OX0ZTipIsSrBbcUxuesMXz21IoOLgVZ6SX1XfGTnJ2ceACSP0APD1j2/LVp
         zU4JmvMFU9sPb1uH4fV1tVXxgKIjhgAZ7EhQq9E0w7Cg8UQs5bN2qS0O72I5oZtHVEmi
         SdWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=niGasz/eM06qJhxp3ZsE78K6CaXcyr8llf9XfXoWBB4=;
        b=e9kUoGCoG8CH01QiKqF0dh0igrMewNEPBQPMFFTQi4aIuowIAT9Qwe0VW90SYVFMBq
         lUb0I1GcQ49M3B9EFIGr/o/ZH4LM3TQqlW3n+bjU7AZsdcxdWB96VjbmYEj04YZZJAro
         m7wBmpzPqiTCIKxjKqwNN9si5VG5XKoH0ZSkEZzQAb+ddPZB2Tg7XfZWO05u1RsJHsOB
         YK0FxKreAxInNyPg4QXHNkL++HWVgwb/rm5DdfUyF58H3l3rVhHHh/4n7jrUbOz5bObu
         ASG+9gSbpcghHZih20l1s46Gv0VTRAV4W1s8kaQvtswxZoLO72IwYQJeSby8MuLmwgyJ
         XMMg==
X-Gm-Message-State: AOAM532xXhXnbsuWKUOxTXKP8VhK5LVSrILBJ9IVAOI796rcyu0zenyK
        fY38mrIRbqRYtkEZZMtNqa9pNfO2WXCJy1mXSjw=
X-Google-Smtp-Source: ABdhPJwpjjqdRkKRPJbXzQI8gmplSs+qcHcyWFIq54t7MDNipgZpLxiF3C7y3T8++CGQAJWLKFae3KQs9yHM+Ni0vTw=
X-Received: by 2002:aca:4187:: with SMTP id o129mr19005405oia.10.1618227923653;
 Mon, 12 Apr 2021 04:45:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210412105851.24809-1-paskripkin@gmail.com>
In-Reply-To: <20210412105851.24809-1-paskripkin@gmail.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Mon, 12 Apr 2021 07:45:12 -0400
Message-ID: <CAB_54W7R6ZmMQQPscc04PhJsGu_uoaVqVx=PAiLrqb4nZqTWzw@mail.gmail.com>
Subject: Re: [PATCH] net: mac802154: fix WARNING in ieee802154_del_device
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        syzbot+bf8b5834b7ec229487ce@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, 12 Apr 2021 at 06:58, Pavel Skripkin <paskripkin@gmail.com> wrote:
>
> syzbot reported WARNING in ieee802154_del_device. The problem
> was in uninitialized mutex. In case of NL802154_IFTYPE_MONITOR
> mutex won't be initialized, but ieee802154_del_device() accessing it.
>
> Reported-by: syzbot+bf8b5834b7ec229487ce@syzkaller.appspotmail.com
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> ---
>  net/mac802154/iface.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/net/mac802154/iface.c b/net/mac802154/iface.c
> index 1cf5ac09edcb..be8d2a02c882 100644
> --- a/net/mac802154/iface.c
> +++ b/net/mac802154/iface.c
> @@ -599,6 +599,7 @@ ieee802154_setup_sdata(struct ieee802154_sub_if_data *sdata,
>
>                 break;
>         case NL802154_IFTYPE_MONITOR:
> +               mutex_init(&sdata->sec_mtx);
>                 sdata->dev->needs_free_netdev = true;
>                 sdata->dev->netdev_ops = &mac802154_monitor_ops;
>                 wpan_dev->promiscuous_mode = true;

yes that will fix the issue, but will let the user notify that setting
any security setting is supported by monitors which is not the case.
There are patches around which should return -EOPNOTSUPP for monitors.
However we might support it in future to let the kernel encrypt air
frames, but this isn't supported yet and the user should be aware that
it isn't.

- Alex
