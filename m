Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB5D62399F
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 03:12:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232385AbiKJCMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 21:12:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231571AbiKJCM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 21:12:27 -0500
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10F151114A;
        Wed,  9 Nov 2022 18:12:27 -0800 (PST)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-367b8adf788so3674227b3.2;
        Wed, 09 Nov 2022 18:12:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ynkdyHO9kNDgrMbUwYVxUanNmrJAAZIOnD1jKJ0SDB4=;
        b=XVwVdE9C7IXuK9mEROqxay6qwoKuyzyc4NkMLeNdYI+Eybx5HnKpwj71/j6iElosEh
         V1bwDKB4ws8zq4yCX9qfs0Q3db2KqLbVO88CeVxS/bzxpW6Rx7dtvxxn/JL0s7qbDS7e
         umXyNwuYCl62bAsFO74yvoKq1qJBTocUQhck7qGFATJ5EOPLJ50PMJ5HTReowqAvdvg7
         GTdTY0KvhSPUbn0ZwOWZVjh442FtGpuh/krLE1B2lsKuEZfTjDTqNgHmw7tNqSGiiNM3
         Ei4KIr1UJdkHsazA06FQ4Vuc05j8ENeo0e/bFYoZ1Tpaa2cJYkb0BM2IH5KO9DD6d2dX
         Ym1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ynkdyHO9kNDgrMbUwYVxUanNmrJAAZIOnD1jKJ0SDB4=;
        b=ruX9W+VIATgMYluD76QsU7ip7dLmjKw6/qf4WNCJI+fHRJ9R/6/cMREX3HAod/PLth
         5M4ujlOttmNT/32r5j0ClQw+S34TKAkeXgfI34BXuYEAzyUQkdQAEETK5YWzJD3IE+lM
         bo2AxuVli/AxCQyJIBPjaIJCCJC4XgyLc/u3TWQ6Vltn6Vm7GdvP4dBuOaDyWuAHrZcp
         qf+xuP7pDNynvQeIgW4RExCD5RvxDzR+U3Z8YQ1qcN8686YEpskitKaQAOG+4SfreJae
         XgLg24GVGaXDgaBk4YZaV0KpOEJHRzYC8JrIVmCSgIpXKLJNZBioxecGUICOe67vmo+k
         oVCQ==
X-Gm-Message-State: ACrzQf1ap1cro2938cgyfLm3g+cXoMe8J7EwUm7AaQeRwa8OdLBwnnZM
        CzqnWhCUUX6dOBMsBrBgibNp8D6l/i2DqO4rJsE=
X-Google-Smtp-Source: AMsMyM7qSy+AVeKvhprJ/L3ayV8Pzq+lwtJpi8RRDbRwUE/cVVo2js5e29hGH6uLfsz0eD6hFiV2LA3cPjOIWGF0/YE=
X-Received: by 2002:a0d:ed44:0:b0:370:5d4f:b96d with SMTP id
 w65-20020a0ded44000000b003705d4fb96dmr53576042ywe.143.1668046346259; Wed, 09
 Nov 2022 18:12:26 -0800 (PST)
MIME-Version: 1.0
References: <20221107090940.686229-1-nashuiliang@gmail.com> <20221109175908.593df5da@kernel.org>
In-Reply-To: <20221109175908.593df5da@kernel.org>
From:   Chuang W <nashuiliang@gmail.com>
Date:   Thu, 10 Nov 2022 10:12:15 +0800
Message-ID: <CACueBy4U-MBZx0JwTc0Z5G2iFjBu4wPtdW+bs0aZOr9_QQFv2w@mail.gmail.com>
Subject: Re: [PATCH v1] net: tun: rebuild error handling in tun_get_user
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks, I will fix these issues and submit again.

On Thu, Nov 10, 2022 at 9:59 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon,  7 Nov 2022 17:09:40 +0800 Chuang Wang wrote:
> > The error handling in tun_get_user is very scattered.
> > This patch unifies error handling, reduces duplication of code, and
> > makes the logic clearer.
>
> You're also making some functional changes tho, they at the very least
> need to be enumerated or preferably separate patches.
>
> > diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> > index 4bf2b268df4a..5ceec73baf98 100644
> > --- a/drivers/net/tun.c
> > +++ b/drivers/net/tun.c
> > @@ -1742,11 +1742,11 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
> >       int good_linear;
> >       int copylen;
> >       bool zerocopy = false;
> > -     int err;
> > +     int err = 0;
>
> Don't zero-init the variables like this, instead...
>
> >       u32 rxhash = 0;
> >       int skb_xdp = 1;
> >       bool frags = tun_napi_frags_enabled(tfile);
> > -     enum skb_drop_reason drop_reason;
> > +     enum skb_drop_reason drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
> >
> >       if (!(tun->flags & IFF_NO_PI)) {
> >               if (len < sizeof(pi))
> > @@ -1808,11 +1808,11 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
> >                */
> >               skb = tun_build_skb(tun, tfile, from, &gso, len, &skb_xdp);
>
> ... use
>
>         err = PTR_ERR_OR_ZERO(skb);
>
> close to the jumps. It's safer to always init err before jumping.
>
> >               if (IS_ERR(skb)) {
> > -                     dev_core_stats_rx_dropped_inc(tun->dev);
> > -                     return PTR_ERR(skb);
> > +                     err = PTR_ERR(skb);
> > +                     goto drop;
> >               }
> >               if (!skb)
> > -                     return total_len;
> > +                     goto out;
>
> >       if (virtio_net_hdr_to_skb(skb, &gso, tun_is_little_endian(tun))) {
> >               atomic_long_inc(&tun->rx_frame_errors);
> > -             kfree_skb(skb);
>
> now we'll increment error and drop counters, that's not right.
>
> > -             if (frags) {
> > -                     tfile->napi.skb = NULL;
> > -                     mutex_unlock(&tfile->napi_mutex);
> > -             }
> > -
> > -             return -EINVAL;
> > +             err = -EINVAL;
> > +             goto drop;
> >       }
>
> > @@ -1952,8 +1932,8 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
> >
> >       rcu_read_lock();
> >       if (unlikely(!(tun->dev->flags & IFF_UP))) {
> > -             err = -EIO;
> >               rcu_read_unlock();
> > +             err = -EIO;
>
> this change is unnecessary, please refrain from making it
>
> >               drop_reason = SKB_DROP_REASON_DEV_READY;
> >               goto drop;
> >       }
> > @@ -2007,7 +1987,23 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
> >       if (rxhash)
> >               tun_flow_update(tun, rxhash, tfile);
> >
> > -     return total_len;
> > +     goto out;
>
> keep
>
>         return total_len;
>
> that's much easier to read, and there's no concern of err being
> uninitialized.
>
> > +
> > +drop:
> > +     if (err != -EAGAIN)
> > +             dev_core_stats_rx_dropped_inc(tun->dev);
> > +
> > +     if (!IS_ERR_OR_NULL(skb))
> > +             kfree_skb_reason(skb, drop_reason);
> > +
> > +unlock_frags:
> > +     if (frags) {
> > +             tfile->napi.skb = NULL;
> > +             mutex_unlock(&tfile->napi_mutex);
> > +     }
> > +
> > +out:
> > +     return err ?: total_len;
> >  }
> >
> >  static ssize_t tun_chr_write_iter(struct kiocb *iocb, struct iov_iter *from)
>
