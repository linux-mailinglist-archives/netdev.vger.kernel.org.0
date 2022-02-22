Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF1E4BF5CA
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 11:28:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbiBVK2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 05:28:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbiBVK2C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 05:28:02 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC3E315A20C
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 02:27:36 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id v186so40094873ybg.1
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 02:27:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AKKXek7RCfaobHDpt0HNCVvATjnUdXM9V4Xbja5sBms=;
        b=YnN5WSSmaKxcyxodZfyF+j8sZat8HGTqpEkLddgMk/5OnggDOSHfdAk7xFgBfvWGCK
         f+d6OxjedS7EvIFClgx96Lj4oOKDKozA+1ZvlQOPJE9T5I15pKU9OzWpujd6vktTPuT4
         QcaPssR0t5OBlhPXWw+39u73bMkM959A3eHBR7U13Ivmr/KMsfjjJK3w0LRCwAXw5hwW
         iIz0nkLAKFC4fHR0CHg3Uz+2L4BlYr7q5LsDL/6QZ7fq403renO1nxs9SNSbcuSxEQ4m
         pBNP5YFLcj7o9PxMqumIpHTAZpITS6p5rC+AjM21GNu+4vhTIQDcu3NrAWwdq0Jo1PG5
         NmSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AKKXek7RCfaobHDpt0HNCVvATjnUdXM9V4Xbja5sBms=;
        b=rRkNgspKOT5muyzb/rKe7v1apfvEoOxElYC1kLx6U+FkRNfDPvLZUhpXioTltuc9bk
         vs3zXe6G7ea1F+DFa+uRSL7Ezeubck5G/WnxHBHfcrjc4hlWscqWNobaN7UXXrELam2r
         +HKL4Ff4TWrgER9YjwcSacaWzQWwZv6UGJCbvDYmUk6xH80dQQFjggyZ0bOvOCVsvnZw
         UPcJ1BnvVwnMz7erDCpl79NPwee/mqmOL6j4/PWUgiRTDG+I/x+2/kpcWS0t4a7rQ+Cb
         VJBU6wKn72jI9fMeTFjr6I7ceqJLrIvx5e1Q/J6FZvNTco4CmzAh4cAQVVbv3l05kXlh
         tepQ==
X-Gm-Message-State: AOAM533CLYYyCoR5TDV0inq86Oee7I1NZwCcAQXfO5zPqnhjhyzQb2q2
        +Y6Da2HllYVi8pnNdjGX41VevQQyOgSy2N3a7TQ=
X-Google-Smtp-Source: ABdhPJzipRh0v0heCsPgMc1K43stQ4WhoXcHrOSjwwJ4W2TTIDPu/4wPSmOPLVN9BOKPsmCH9tGFpluXnjR4qgzqSXo=
X-Received: by 2002:a25:d341:0:b0:624:3ec2:b7bf with SMTP id
 e62-20020a25d341000000b006243ec2b7bfmr19590046ybf.518.1645525655928; Tue, 22
 Feb 2022 02:27:35 -0800 (PST)
MIME-Version: 1.0
References: <20220220153250.5285-1-claudiajkang@gmail.com> <20220221204731.1229f987@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220221204731.1229f987@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Juhee Kang <claudiajkang@gmail.com>
Date:   Tue, 22 Feb 2022 19:27:00 +0900
Message-ID: <CAK+SQuSpKPr7vMjms-uAf3DJ-0hUQCeSmKhbpUbE1nYps5z3xw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: hsr: fix hsr build error when lockdep is
 not enabled
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Networking <netdev@vger.kernel.org>, davem@davemloft.net,
        Eric Dumazet <eric.dumazet@gmail.com>, ennoerlangen@gmail.com,
        george.mccollister@gmail.com, Vladimir Oltean <olteanv@gmail.com>,
        marco.wenzel@a-eberle.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 1:47 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sun, 20 Feb 2022 15:32:50 +0000 Juhee Kang wrote:
> > In hsr, lockdep_is_held() is needed for rcu_dereference_bh_check().
> > But if lockdep is not enabled, lockdep_is_held() causes a build error:
> >
> >     ERROR: modpost: "lockdep_is_held" [net/hsr/hsr.ko] undefined!
> >
> > Thus, this patch solved by adding lockdep_hsr_is_held(). This helper
> > function calls the lockdep_is_held() when lockdep is enabled, and returns 1
> > if not defined.
> >
> > Fixes: e7f27420681f ("net: hsr: fix suspicious RCU usage warning in hsr_node_get_first()")
> > Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
> > Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
> > ---
> >  net/hsr/hsr_framereg.c | 25 +++++++++++++++----------
> >  net/hsr/hsr_framereg.h |  8 +++++++-
> >  2 files changed, 22 insertions(+), 11 deletions(-)
> >
> > diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
> > index 62272d76545c..584e21788799 100644
> > --- a/net/hsr/hsr_framereg.c
> > +++ b/net/hsr/hsr_framereg.c
> > @@ -20,6 +20,13 @@
> >  #include "hsr_framereg.h"
> >  #include "hsr_netlink.h"
> >
> > +#ifdef CONFIG_LOCKDEP
> > +int lockdep_hsr_is_held(spinlock_t *lock)
> > +{
> > +     return lockdep_is_held(lock);
> > +}
> > +#endif
>
> Let me apply the patch, so that people don't hit this problem,
> but please investigate if this helper is needed..
>
> >  u32 hsr_mac_hash(struct hsr_priv *hsr, const unsigned char *addr)
> >  {
> >       u32 hash = jhash(addr, ETH_ALEN, hsr->hash_seed);
> > @@ -27,11 +34,12 @@ u32 hsr_mac_hash(struct hsr_priv *hsr, const unsigned char *addr)
> >       return reciprocal_scale(hash, hsr->hash_buckets);
> >  }
> >
> > -struct hsr_node *hsr_node_get_first(struct hlist_head *head, int cond)
> > +struct hsr_node *hsr_node_get_first(struct hlist_head *head, spinlock_t *lock)
> >  {
> >       struct hlist_node *first;
> >
> > -     first = rcu_dereference_bh_check(hlist_first_rcu(head), cond);
> > +     first = rcu_dereference_bh_check(hlist_first_rcu(head),
> > +                                      lockdep_hsr_is_held(lock));
>
> .. since you moved the lockdep check inside rcu_dereference() I think
> the build problem should go away. rcu_deref..() will only execute the
> last argument if PROVE_LOCKING is set, so it should be safe to pass
> lockdep_is_held(lock) in directly there.
>
> Please double check and send another follow up if I'm correct, thanks!

Hi Jakub,
Sorry for the noise. I keep that in mind.

And thank you so much for the review.
I will apply for your review and send a new patch after some tests.

Thanks a lot

-- 

Best regards,
Juhee Kang
