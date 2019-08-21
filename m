Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F076498122
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 19:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728161AbfHURVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 13:21:04 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:45484 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727211AbfHURVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 13:21:03 -0400
Received: by mail-lj1-f194.google.com with SMTP id l1so2863948lji.12
        for <netdev@vger.kernel.org>; Wed, 21 Aug 2019 10:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Loebk7nqt8jK3yo5T1SFNGvSf6Q2eyzrKOALthSTcXw=;
        b=DMioMD5Ob1w4wHbO0g2uiESupxvczUSyfR6jn0FI/CZwyPmJTTjh5qIaWOuqIkaQoZ
         0h5Fkr7KqZk3fQT4xGtMSvoEdaDEshLo09GH/bznvSQCoyWabSjFzaaoX80kaz5MJLDT
         ACxoScmvQH/ybg2Yft/rMs8ZJKo95bx8LX95+LZCLqqY1TLPyktPGOuPrrYKjaAczJo8
         gI8y2mCoL3RT3iZaTJc02BDcBoEQyx1f1SurScPMpZGnXqAQfINtNmHtgABc2MpKX4Gh
         KttrxbtE9MX58thM25Z7C7Mfkv8fsYxvnywC3cwoqvUWdMH2GKHMoANL/+qQbD/ObFB+
         kcJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Loebk7nqt8jK3yo5T1SFNGvSf6Q2eyzrKOALthSTcXw=;
        b=GqlJMZle4VlfNqJL4d4XQ0HVNZd/o+s5sb/CKDXi/ewbQxzU8u1APA77JgfT76enJK
         Co0u84DoOJMHvuGDkAT5uVwslkWvJDTPJcAHDCrKJEJBEzfFM9eUVtB/qqAh8HdiN2rP
         hLUVpPJP8sy7ufrleJFCDzRbPGTjW5QctBloNV9gENcbKvFwy6/rpzFMzXIDc/uBJpYX
         lXF9Nn0GcexNTgIV+3au94QQG29tOESuHpqtFuTl+mWQWQ/oN4jEYq3MrFe6sy/2L+CJ
         kPaclMQOR/K71NTC36BVKmby6hRjTPJCcYTl1L5gZL4AyXkyuuwJUjZdLKjqkS33Blo3
         bXqA==
X-Gm-Message-State: APjAAAUg8WAAIFbEUVspyMSQ4vaJhCg1rd5rp3ph8wgXw/R1bgkWDscU
        x4SHEQNIYaT7xWSnvFe2rVH6VIVSONzbtpDKER8pPg==
X-Google-Smtp-Source: APXvYqx5M24c8sINRTlzgATS4qA/ds9IPq+ERLVZAAfQJ/lik7iqiyTL6BphcuJ/IPBtmfbVm6glR58ddoLhipq86h8=
X-Received: by 2002:a2e:a202:: with SMTP id h2mr19383861ljm.146.1566408061332;
 Wed, 21 Aug 2019 10:21:01 -0700 (PDT)
MIME-Version: 1.0
References: <20190820090053.GA24410@mwanda> <20190820090739.GB1845@kadam>
In-Reply-To: <20190820090739.GB1845@kadam>
From:   Catherine Sullivan <csully@google.com>
Date:   Wed, 21 Aug 2019 10:20:25 -0700
Message-ID: <CAH_-1qxhH70xNLd+q4TjzVeT7OoHMfWUJGtBQEPru8xFVnHGsg@mail.gmail.com>
Subject: Re: [PATCH v2 net] gve: Copy and paste bug in gve_get_stats()
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Sagi Shahar <sagis@google.com>, Jon Olson <jonolson@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Luigi Rizzo <lrizzo@google.com>,
        Chuhong Yuan <hslester96@gmail.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 20, 2019 at 2:11 AM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> There is a copy and paste error so we have "rx" where "tx" was intended
> in the priv->tx[] array.
>
> Fixes: f5cedc84a30d ("gve: Add transmit and receive support")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> v2: fix a typo in the subject: buy -> bug (Thanks Walter Harms)
>
>  drivers/net/ethernet/google/gve/gve_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
> index 497298752381..aca95f64bde8 100644
> --- a/drivers/net/ethernet/google/gve/gve_main.c
> +++ b/drivers/net/ethernet/google/gve/gve_main.c
> @@ -50,7 +50,7 @@ static void gve_get_stats(struct net_device *dev, struct rtnl_link_stats64 *s)
>                                   u64_stats_fetch_begin(&priv->tx[ring].statss);
>                                 s->tx_packets += priv->tx[ring].pkt_done;
>                                 s->tx_bytes += priv->tx[ring].bytes_done;
> -                       } while (u64_stats_fetch_retry(&priv->rx[ring].statss,
> +                       } while (u64_stats_fetch_retry(&priv->tx[ring].statss,
>                                                        start));
>                 }
>         }
> --
> 2.20.1

Thanks!

Reviewed-by: Catherine Sullivan <csully@google.com>
