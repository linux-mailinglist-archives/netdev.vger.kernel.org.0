Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63A9350CAC9
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 15:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235821AbiDWNsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 09:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbiDWNsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 09:48:19 -0400
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE7ECB86C
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 06:45:20 -0700 (PDT)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-2ebf4b91212so110517827b3.8
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 06:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VovehHN+6Utg7b66G9oS/wmqcTe/gDNl7Lw5jU5ytRw=;
        b=iQcXaNZ1DEfQyqnbu3v0qF6clefp57iLwSVA6BrQ6Bf2byk/1p2uVfLxAXzLEo4g43
         b3N1o3iOfIKtloOHM1C4kv1VaKivM++AlLV5Ncx2V1tqpMUqviiXrBKS04sN+UuzhsHW
         fSBZTGlCv4CuIMq1LGqgMX28z9qCeq9vbE37fqYdxJO52cu+ZJyZIXkWotPjUajRipL6
         Sc18xSJP+8rEOEvDOmUD1Dn86A7PRu1bF48VkJv4alkFvQpN0DSxZj5DvC5FVICm0Mjr
         nVJ12SHsYZW5g8hZk5AVEFQWqDZoleqciC4pTciXwfmq/Lxfbnwp4ymxTVZDiV78mfg4
         U21w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VovehHN+6Utg7b66G9oS/wmqcTe/gDNl7Lw5jU5ytRw=;
        b=1KNKURd9Ve6ubGscA0EOeevq+WH8rVvuag+33f7rvbGl1gNiwdblNGLZTZvoQVlsHF
         yZa44Dz/1/qYgs+v16scZAwp0a25GMhIbVfOStGW+gaKe6LR+Li+hGZb0ViNSW6KE9LP
         ZezAR2OeHs6oJkWZab6dPN8oc/SrQYt7RIfLnFkYU1eZT9ZbaeMuqWPLEPVEKIat5vAz
         k8wRmw1rYP/eyTRJqupz8wCsvTLDymJ7Z86UFrWe0EX6hYqVJNIC1Q03Bb/W/sAy1WX8
         JZo6BZgW8b8DcYxbmj2EL9FVQf7Gxn0W9KK0NGXWDticVp2riQIteZrvz27NUPr0Qztw
         5WIw==
X-Gm-Message-State: AOAM530tzt9jx9ZbWMOY1MeX4HMkuHShQHMiEpfW+ygMTAgT5Gpq06Vv
        auorHBafmpG2p/NNmy+Tr92eG/V7sZ1A0apnx+JUF5KDDYt2UZ8u
X-Google-Smtp-Source: ABdhPJzLJj4kYYrsCyxQDLuRFLueS5ash5sfs0RNmwHj1YGfkyNcDq/daEWNzi/C4cfQW6bCRdUx85J4LAmAMZiQyMk=
X-Received: by 2002:a0d:d80b:0:b0:2f7:c74f:7ca5 with SMTP id
 a11-20020a0dd80b000000b002f7c74f7ca5mr2937811ywe.489.1650721519836; Sat, 23
 Apr 2022 06:45:19 -0700 (PDT)
MIME-Version: 1.0
References: <YmFjdOp+R5gVGZ7p@linutronix.de> <CANn89iKjSmnTSzzHdnP-HEYMajrz+MOrjFooaMFop4Vo43kLdg@mail.gmail.com>
 <YmGLkz+dIBb5JjFF@linutronix.de> <20220423092439.GY2731@worktop.programming.kicks-ass.net>
In-Reply-To: <20220423092439.GY2731@worktop.programming.kicks-ass.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 23 Apr 2022 06:45:08 -0700
Message-ID: <CANn89iL3+7eVUao_g+d7vtHGdt1PKhh963fGFwqw=2gM8GjjXw@mail.gmail.com>
Subject: Re: [PATCH net] net: Use this_cpu_inc() to increment net->core_stats
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 23, 2022 at 2:24 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Thu, Apr 21, 2022 at 06:51:31PM +0200, Sebastian Andrzej Siewior wrote:
> > On 2022-04-21 09:06:05 [-0700], Eric Dumazet wrote:
> > > On Thu, Apr 21, 2022 at 7:00 AM Sebastian Andrzej Siewior
> > > <bigeasy@linutronix.de> wrote:
> > > >
> > >
> > > >                 for_each_possible_cpu(i) {
> > > >                         core_stats = per_cpu_ptr(p, i);
> > > > -                       storage->rx_dropped += local_read(&core_stats->rx_dropped);
> > > > -                       storage->tx_dropped += local_read(&core_stats->tx_dropped);
> > > > -                       storage->rx_nohandler += local_read(&core_stats->rx_nohandler);
> > > > +                       storage->rx_dropped += core_stats->rx_dropped;
> > > > +                       storage->tx_dropped += core_stats->tx_dropped;
> > > > +                       storage->rx_nohandler += core_stats->rx_nohandler;
> > >
> > > I think that one of the reasons for me to use  local_read() was that
> > > it provided what was needed to avoid future syzbot reports.
> >
> > syzbot report due a plain read of a per-CPU variable which might be
> > modified?
> >
> > > Perhaps use READ_ONCE() here ?
> > >
> > > Yes, we have many similar folding loops that are  simply assuming
> > > compiler won't do stupid things.
> >
> > I wasn't sure about that and added PeterZ to do some yelling here just
> > in case. And yes, we have other sites doing exactly that. In
> >    Documentation/core-api/this_cpu_ops.rst
> > there is nothing about remote-READ-access (only that there should be no
> > writes (due to parallel this_cpu_inc() on the local CPU)). I know that a
> > 32bit write can be optimized in two 16bit writes in certain cases but a
> > read is a read.
> > PeterZ? :)
>
> Eric is right. READ_ONCE() is 'required' to ensure the compiler doesn't
> split the load and KCSAN konws about these things.

More details can be found in https://lwn.net/Articles/793253/

Thanks !
