Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E455650A6BD
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 19:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379727AbiDUROy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 13:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231312AbiDUROw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 13:14:52 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA16749F11
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 10:12:01 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id f17so9886014ybj.10
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 10:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8aEMpiZGOXmeB2CFVTFuSH5RooCSvnIcYdJjnbFo7rE=;
        b=cTsWg3heneuqOY72WzV9rOndGGRZPe+hEOuQ1qwe0jCuiTxQko365rucvnAAQ+WEie
         UEnfA8xFjeVM3ukq+1taT7W3cFtkP1BoaBhynC/SjuSEWdE2otvr8ZUrOgL9rdzd5gpk
         ZLUNyB541AT9TmbVNNmIKwmSJDkpr9be31oS4UESrlVNGY0vAOcWtspPZCfjuzIVtC1U
         232Cv8vOBlZvHEC9PYs1/KNBUPFSvwWEPcVstUEa61MdPA7lMdXVKsb9HBvTVSsvWsLy
         VV+Ru3GCaRf/L+fWxKP+Ns+iBeEb2xoMzreJNAGYJxG0YkyYH5d1teZOwPSFb8UG/7Nt
         dV4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8aEMpiZGOXmeB2CFVTFuSH5RooCSvnIcYdJjnbFo7rE=;
        b=dV10OTXCtSjmsqnX0hTb9Uj7/Bh2EzoPkLX3EfaWu+NBR1lgkynWapOj4BQ8yxhzcc
         UI0xMHecjMFSRGdN7cpcguhi5gxXS0n1K5BkmAILx7xGw9tZ7aiiro/KKRvRL2r7f91q
         sfmpqZ5CE2JHlDWMl4Mx+tr8eol0JUlCCWDRwhnWX/Gw2lqeAuSOHMXvoavlVjyEkhWF
         SUjo8PlFmAQdUF2YEpKsgu/KavOOgOrLSOt6Aehw2n22qaEawN9BKSDoUYfGcP0QEk6W
         BheDl8d68Spl/YcF8357cw5oTyJM296ecEfsVX00IghgimsElJOKNX8cQmV5FJOsV9f9
         n//w==
X-Gm-Message-State: AOAM530ks+BaQIVYJfbYbKVBJGDmdvOPTeeZiXAeGcdppthHulEtrQto
        F6kLmcCCaawNNWL1doFrWX3k5DeYSTYOG3SVYFsA7l4dfGmoiabT
X-Google-Smtp-Source: ABdhPJzH66htgfIdwGZ3aWHpJYb31hlgsRyymJrG0rJf0n09xmRA4twN9JmrGPAg7yJaslMzkZfp3sWLyb5fZKWaMPY=
X-Received: by 2002:a05:6902:c9:b0:641:1998:9764 with SMTP id
 i9-20020a05690200c900b0064119989764mr666692ybs.427.1650561120773; Thu, 21 Apr
 2022 10:12:00 -0700 (PDT)
MIME-Version: 1.0
References: <YmFjdOp+R5gVGZ7p@linutronix.de> <CANn89iKjSmnTSzzHdnP-HEYMajrz+MOrjFooaMFop4Vo43kLdg@mail.gmail.com>
 <YmGLkz+dIBb5JjFF@linutronix.de>
In-Reply-To: <YmGLkz+dIBb5JjFF@linutronix.de>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 21 Apr 2022 10:11:49 -0700
Message-ID: <CANn89iJ0B8O6q686T-B_ShRZTnxqfcTxXmCzJRUvBmOnvid85w@mail.gmail.com>
Subject: Re: [PATCH net] net: Use this_cpu_inc() to increment net->core_stats
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 21, 2022 at 9:51 AM Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
>
> On 2022-04-21 09:06:05 [-0700], Eric Dumazet wrote:
> > On Thu, Apr 21, 2022 at 7:00 AM Sebastian Andrzej Siewior
> > <bigeasy@linutronix.de> wrote:
> > >
> >
> > >                 for_each_possible_cpu(i) {
> > >                         core_stats = per_cpu_ptr(p, i);
> > > -                       storage->rx_dropped += local_read(&core_stats->rx_dropped);
> > > -                       storage->tx_dropped += local_read(&core_stats->tx_dropped);
> > > -                       storage->rx_nohandler += local_read(&core_stats->rx_nohandler);
> > > +                       storage->rx_dropped += core_stats->rx_dropped;
> > > +                       storage->tx_dropped += core_stats->tx_dropped;
> > > +                       storage->rx_nohandler += core_stats->rx_nohandler;
> >
> > I think that one of the reasons for me to use  local_read() was that
> > it provided what was needed to avoid future syzbot reports.
>
> syzbot report due a plain read of a per-CPU variable which might be
> modified?

Yes, this is KCSAN  (
https://www.kernel.org/doc/html/latest/dev-tools/kcsan.html )

>
> > Perhaps use READ_ONCE() here ?
> >
> > Yes, we have many similar folding loops that are  simply assuming
> > compiler won't do stupid things.
>
> I wasn't sure about that and added PeterZ to do some yelling here just
> in case. And yes, we have other sites doing exactly that. In
>    Documentation/core-api/this_cpu_ops.rst
> there is nothing about remote-READ-access (only that there should be no
> writes (due to parallel this_cpu_inc() on the local CPU)). I know that a
> 32bit write can be optimized in two 16bit writes in certain cases but a
> read is a read.
> PeterZ? :)
>
> Sebastian
