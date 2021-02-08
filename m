Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72BD2314328
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 23:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbhBHWq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 17:46:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbhBHWqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 17:46:24 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27F4FC061786
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 14:45:44 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id y17so14331160ili.12
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 14:45:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hGIOQY5y7KNyFv1PNJbwyNB1EPolE5acE8vlR5pmD0s=;
        b=ZH6VWeoaO8fFryVEZAzChdS13fKAfJVU75L79OaUdwzyJsFIqrm7KP1OUN/iYa70az
         LASO96p8I+xoNkttF+t6bEuJpJyvJg3w56Xw7K7uwEg4xGWAosYO4/QVaR0WVledLGBv
         K9OPGKDGfKpSBWs7fXcNjsuXtVKc/VdR1d1MPyc4tSa94UuAhJllp+Ih2D1YdAM2m5ur
         YstVhq6h18SI1pCgySLuv0bN7ADmQ579iTpBObAmon+ncFcm5w243wus4YzNyOXJHxi4
         USJ6J1y+mKoCXs6B0U7aPHVY0RvCX6lnUHpdfaj2V+PGRNSvxB/1tqlZ7e5ExYInoN51
         f9bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hGIOQY5y7KNyFv1PNJbwyNB1EPolE5acE8vlR5pmD0s=;
        b=TQN6evYttYjOD9Xi1I62SQNTmi0ZTN4HwTBTZgFbukqsFWcnxJc0fiPHzORtgS/kw2
         xA/mNUjCDEM1PVxTK25at8HJQBSm4+TlI2LDctrbG2HIGyDvEwHnHlY1Wiy6/aolO7VS
         Cb4jp5xTsiAeItHulNE8mUuz/hoZd8HuBjnQ5Wc3ZfLgAZBx4GJrBZqWdug6t3YgMdll
         lYMTLoVwvN4tI9lxXMZglgpksfslfAaX/PshiOmkKBqODO/JwR1AUZ7C98Oj+Dz1pcr1
         bIm1s2ZujoP4K37eS2QyoMCrE/2iMiDDTVI6XBOtAPJaMa+Eo0Fb9ehWDRzZXzfBxGfL
         +3RA==
X-Gm-Message-State: AOAM533gRe60Feq7xqDnnng2yCQmuT8lh1Ar7cDkd2mk6z4npjj/92t3
        lcLlaP3RzmPsj+8KtFTMNILsIXuy7FjHm+2WXJU=
X-Google-Smtp-Source: ABdhPJwgN2IHteRHKmmpVF6bc1zpOemdET5oGvUzvEqxKqO+rekzxWxOTE45p7h/DBtsgNmRDwwlu8r7/3JNpHojv2Y=
X-Received: by 2002:a05:6e02:1185:: with SMTP id y5mr18016990ili.237.1612824343433;
 Mon, 08 Feb 2021 14:45:43 -0800 (PST)
MIME-Version: 1.0
References: <20210208171917.1088230-1-atenart@kernel.org> <20210208171917.1088230-13-atenart@kernel.org>
In-Reply-To: <20210208171917.1088230-13-atenart@kernel.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 8 Feb 2021 14:45:32 -0800
Message-ID: <CAKgT0UdP+1giTCzyfZ5x8q51otv2+KiPUN8djF=8XGcMOEZgEQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 12/12] net-sysfs: move the xps cpus/rxqs
 retrieval in a common function
To:     Antoine Tenart <atenart@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 8, 2021 at 9:19 AM Antoine Tenart <atenart@kernel.org> wrote:
>
> Most of the xps_cpus_show and xps_rxqs_show functions share the same
> logic. Having it in two different functions does not help maintenance.
> This patch moves their common logic into a new function, xps_queue_show,
> to improve this.
>
> Signed-off-by: Antoine Tenart <atenart@kernel.org>
> ---
>  net/core/net-sysfs.c | 98 ++++++++++++++------------------------------
>  1 file changed, 31 insertions(+), 67 deletions(-)
>
> diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
> index 6ce5772e799e..984c15248483 100644
> --- a/net/core/net-sysfs.c
> +++ b/net/core/net-sysfs.c
> @@ -1314,35 +1314,31 @@ static const struct attribute_group dql_group = {
>  #endif /* CONFIG_BQL */
>
>  #ifdef CONFIG_XPS
> -static ssize_t xps_cpus_show(struct netdev_queue *queue,
> -                            char *buf)
> +static ssize_t xps_queue_show(struct net_device *dev, unsigned int index,
> +                             char *buf, enum xps_map_type type)
>  {
> -       struct net_device *dev = queue->dev;
>         struct xps_dev_maps *dev_maps;
> -       unsigned int index, nr_ids;
> -       int j, len, ret, tc = 0;
>         unsigned long *mask;
> -
> -       if (!netif_is_multiqueue(dev))
> -               return -ENOENT;
> -
> -       index = get_netdev_queue_index(queue);
> -
> -       /* If queue belongs to subordinate dev use its map */
> -       dev = netdev_get_tx_queue(dev, index)->sb_dev ? : dev;
> +       unsigned int nr_ids;
> +       int j, len, tc = 0;
>
>         tc = netdev_txq_to_tc(dev, index);
>         if (tc < 0)
>                 return -EINVAL;
>
>         rcu_read_lock();
> -       dev_maps = rcu_dereference(dev->xps_maps[XPS_CPUS]);
> -       nr_ids = dev_maps ? dev_maps->nr_ids : nr_cpu_ids;
> +       dev_maps = rcu_dereference(dev->xps_maps[type]);
> +
> +       /* Default to nr_cpu_ids/dev->num_rx_queues and do not just return 0
> +        * when dev_maps hasn't been allocated yet, to be backward compatible.
> +        */
> +       nr_ids = dev_maps ? dev_maps->nr_ids :
> +                (type == XPS_CPUS ? nr_cpu_ids : dev->num_rx_queues);
>
>         mask = bitmap_zalloc(nr_ids, GFP_KERNEL);
>         if (!mask) {
> -               ret = -ENOMEM;
> -               goto err_rcu_unlock;
> +               rcu_read_unlock();
> +               return -ENOMEM;
>         }
>
>         if (!dev_maps || tc >= dev_maps->num_tc)
> @@ -1368,11 +1364,24 @@ static ssize_t xps_cpus_show(struct netdev_queue *queue,
>
>         len = bitmap_print_to_pagebuf(false, buf, mask, nr_ids);
>         bitmap_free(mask);
> +
>         return len < PAGE_SIZE ? len : -EINVAL;
> +}
>
> -err_rcu_unlock:
> -       rcu_read_unlock();
> -       return ret;
> +static ssize_t xps_cpus_show(struct netdev_queue *queue, char *buf)
> +{
> +       struct net_device *dev = queue->dev;
> +       unsigned int index;
> +
> +       if (!netif_is_multiqueue(dev))
> +               return -ENOENT;
> +
> +       index = get_netdev_queue_index(queue);
> +
> +       /* If queue belongs to subordinate dev use its map */
> +       dev = netdev_get_tx_queue(dev, index)->sb_dev ? : dev;
> +
> +       return xps_queue_show(dev, index, buf, XPS_CPUS);
>  }
>
>  static ssize_t xps_cpus_store(struct netdev_queue *queue,

So this patch has the same issue as the one that was removing the
rtnl_lock. Basically the sb_dev needs to still be protected by the
rtnl_lock. We might need to take the rtnl_lock and maybe make use of
the get_device/put_device logic to make certain the device cannot be
freed while you are passing it to xps_queue_show.
