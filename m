Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC113561242
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 08:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232319AbiF3GIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 02:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiF3GII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 02:08:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 05B022E2
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 23:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656569285;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Huizft4b5megN+LHZsenyqxTACpN6BbdhFtJNkNbRWk=;
        b=NRVkQzMspbimpDQq1yeamJPQyYnQEnl6uDSEF1aEIaTNuoubkSOzqo0TLdk2Ro0dQy1omv
        zrtTRAuZe8M5kQyEKh0yPIhwASzaNq7OFtwmr782/2cCiBF7SHRQly8fuTmdbPJdTiAnY+
        VjBHZnHDbwKALlt6w0jpOBr/B34+QjU=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-523-SiSnPq8sObiWxyKTi0zwzg-1; Thu, 30 Jun 2022 02:08:02 -0400
X-MC-Unique: SiSnPq8sObiWxyKTi0zwzg-1
Received: by mail-lj1-f199.google.com with SMTP id i23-20020a2e9417000000b0025a739223d1so2809830ljh.4
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 23:08:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Huizft4b5megN+LHZsenyqxTACpN6BbdhFtJNkNbRWk=;
        b=b+RRV8Ke1UW5XGx9w169Lf6TyQo5PPILwaPB2nw0s1CiCkgqh+44XR5KfW3qRx+qzQ
         96QcSioXd6Mfsa5FI1b0RXOQZ/Yw9Hl7CvLzBqqnghGRsF7OvXt0T3BAoT0P6I+uknxT
         eqcvoUryHmQGcc5Ey1qmGsTEg9cWuPhT2hci2vK+6QunXiD3MXZyq9tnCrG6bA8hA4Be
         LUsHkN9HayyWm36eACznwfbSOJEira4GdrwDYTmYhXpWMNwRJhvUkiLUZKLPD1sCNitG
         h6IEdB+P+laLSGvf0+m0WjoqPNmtSFg7DD6xPQMuYzOgRcHcMYvjgfadnoGme1iBeMjB
         Cbyg==
X-Gm-Message-State: AJIora/yk3MlyYjrclzS89mPVl7V/Cv9RWdwMitY/sLC2mR4HakHKEUN
        n66/Ri1P4Oz3pmrvHh8CQqqUkST/cgz62qc8wgrsgLWHEq3R6obv1rCm+Ge3Kp0dMalqMgJvvSV
        NKDPSFlwdxaj8cFsboaOKzsNj6XnTj0sw
X-Received: by 2002:ac2:51a5:0:b0:47f:79a1:5c02 with SMTP id f5-20020ac251a5000000b0047f79a15c02mr4454348lfk.575.1656569281328;
        Wed, 29 Jun 2022 23:08:01 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uSvw4QQdRBK/4iZ/CcyTLMfOSwTOHod2+FXhilsKg5Tz+kGG+P8P47yjnOyH8kpypV5rbVce7k78pE5S9GJ6I=
X-Received: by 2002:ac2:51a5:0:b0:47f:79a1:5c02 with SMTP id
 f5-20020ac251a5000000b0047f79a15c02mr4454336lfk.575.1656569281122; Wed, 29
 Jun 2022 23:08:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220630020805.74658-1-jasowang@redhat.com> <20220629195123.610eed9f@kernel.org>
In-Reply-To: <20220629195123.610eed9f@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 30 Jun 2022 14:07:50 +0800
Message-ID: <CACGkMEs216-WJCSE7mwSHx+zmaNDJa9HCjhnRMWOpZrhJcauNg@mail.gmail.com>
Subject: Re: [PATCH V2] virtio-net: fix the race between refill work and close
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     mst <mst@redhat.com>, davem <davem@davemloft.net>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 30, 2022 at 10:51 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 30 Jun 2022 10:08:04 +0800 Jason Wang wrote:
> > +static void enable_refill_work(struct virtnet_info *vi)
> > +{
> > +     spin_lock(&vi->refill_lock);
> > +     vi->refill_work_enabled = true;
> > +     spin_unlock(&vi->refill_lock);
> > +}
> > +
> > +static void disable_refill_work(struct virtnet_info *vi)
> > +{
> > +     spin_lock(&vi->refill_lock);
> > +     vi->refill_work_enabled = false;
> > +     spin_unlock(&vi->refill_lock);
> > +}
> > +
> >  static void virtqueue_napi_schedule(struct napi_struct *napi,
> >                                   struct virtqueue *vq)
> >  {
> > @@ -1527,8 +1547,12 @@ static int virtnet_receive(struct receive_queue *rq, int budget,
> >       }
> >
> >       if (rq->vq->num_free > min((unsigned int)budget, virtqueue_get_vring_size(rq->vq)) / 2) {
> > -             if (!try_fill_recv(vi, rq, GFP_ATOMIC))
> > -                     schedule_delayed_work(&vi->refill, 0);
> > +             if (!try_fill_recv(vi, rq, GFP_ATOMIC)) {
> > +                     spin_lock(&vi->refill_lock);
> > +                     if (vi->refill_work_enabled)
> > +                             schedule_delayed_work(&vi->refill, 0);
> > +                     spin_unlock(&vi->refill_lock);
>
> Are you sure you can use the basic spin_lock() flavor in all cases?
> Isn't the disable/enable called from a different context than this
> thing here?

This function will only be called in bh so it's safe.

>
> The entire delayed work construct seems a little risky because the work
> may go to sleep after disabling napi, causing large latency spikes.

Yes, but it only happens on OOM.

> I guess you must have a good reason no to simply reschedule the NAPI
> and keep retrying with GFP_ATOMIC...

Less pressure on the memory allocator on OOM probably, but it looks
like an independent issue that might be optimized in the future.

>
> Please add the target tree name to the subject.

Ok

Thanks

>

