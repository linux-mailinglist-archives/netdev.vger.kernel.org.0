Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9FB54CA407
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 12:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241564AbiCBLn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 06:43:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235218AbiCBLn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 06:43:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC4EC41;
        Wed,  2 Mar 2022 03:43:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48C61B81F8D;
        Wed,  2 Mar 2022 11:43:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A32C340F1;
        Wed,  2 Mar 2022 11:43:11 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="C95LBaGB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1646221389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=USGcDy4w3TZ7LgAk31pw0D1MtgBRHHVT0BJsNUeVVbw=;
        b=C95LBaGBLixaG/A7Zi3cNn1lIN+nl0iiYswsYbJNhJhztuTCsyarCYsp3vrhkYZpUgBXjc
        SiguryOXLvM2NjOvgpnF5zpzs63KxDPJZbvtQ2jJCaYcL9UldDoQgR997ZDZ2TWXn8QH22
        1w8qQjcoxHVubUatcTgkGtEZuKh+k2U=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 049a7fc6 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 2 Mar 2022 11:43:09 +0000 (UTC)
Received: by mail-yb1-f172.google.com with SMTP id u3so2756801ybh.5;
        Wed, 02 Mar 2022 03:43:08 -0800 (PST)
X-Gm-Message-State: AOAM530axWYnbtfgS/caymn9tfhP+xcCOO0rMgvMCcH7+xrrhjxYQdp/
        efBVOV66MBNdNVn0GKAHfj1Z2vYZqHJUpIQwzRQ=
X-Google-Smtp-Source: ABdhPJzFIO9KLB/vM1BBjlP25MTWZNtMEvsRHE+m99kvA0ufEgLFS+BFdzqkv+9sKx2PuD5luegjn0ddZsSgVsq7t8w=
X-Received: by 2002:a25:e204:0:b0:610:cb53:b753 with SMTP id
 h4-20020a25e204000000b00610cb53b753mr27109900ybe.267.1646221387488; Wed, 02
 Mar 2022 03:43:07 -0800 (PST)
MIME-Version: 1.0
References: <20220301231038.530897-1-Jason@zx2c4.com> <20220301231038.530897-2-Jason@zx2c4.com>
 <Yh8Bsk9RSm22Yr8d@owl.dominikbrodowski.net>
In-Reply-To: <Yh8Bsk9RSm22Yr8d@owl.dominikbrodowski.net>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 2 Mar 2022 12:42:56 +0100
X-Gmail-Original-Message-ID: <CAHmME9rSz-GqvQf9S9fPLUvSwP0iky90bipGj-o94tkAU1QP1g@mail.gmail.com>
Message-ID: <CAHmME9rSz-GqvQf9S9fPLUvSwP0iky90bipGj-o94tkAU1QP1g@mail.gmail.com>
Subject: Re: [PATCH 1/3] random: replace custom notifier chain with standard one
To:     Dominik Brodowski <linux@dominikbrodowski.net>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Alexander Graf <graf@amazon.com>, Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dominik,

On Wed, Mar 2, 2022 at 6:35 AM Dominik Brodowski
<linux@dominikbrodowski.net> wrote:
>
> Am Wed, Mar 02, 2022 at 12:10:36AM +0100 schrieb Jason A. Donenfeld:
> >  /*
> >   * Delete a previously registered readiness callback function.
> >   */
> > -void del_random_ready_callback(struct random_ready_callback *rdy)
> > +int unregister_random_ready_notifier(struct notifier_block *nb)
> >  {
> >       unsigned long flags;
> > -     struct module *owner = NULL;
> > -
> > -     spin_lock_irqsave(&random_ready_list_lock, flags);
> > -     if (!list_empty(&rdy->list)) {
> > -             list_del_init(&rdy->list);
> > -             owner = rdy->owner;
> > -     }
> > -     spin_unlock_irqrestore(&random_ready_list_lock, flags);
> > +     int ret;
> >
> > -     module_put(owner);
> > +     spin_lock_irqsave(&random_ready_chain_lock, flags);
> > +     ret = raw_notifier_chain_unregister(&random_ready_chain, nb);
> > +     spin_unlock_irqrestore(&random_ready_chain_lock, flags);
> > +     return ret;
> >  }
> > -EXPORT_SYMBOL(del_random_ready_callback);
>
> That doesn't seem to be used anywhere, so I'd suggest removing this function
> altogether.

I thought about this, but it feels weird to have a registration
function without an unregistration function... No other notifier is
unbalanced like that.

Jason
