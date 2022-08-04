Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 456CC589550
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 02:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238379AbiHDA13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 20:27:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238301AbiHDA10 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 20:27:26 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB2A44B4A3
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 17:27:25 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id q6-20020a05683033c600b0061d2f64df5dso11743298ott.13
        for <netdev@vger.kernel.org>; Wed, 03 Aug 2022 17:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=wAxTGG2z5uPbKc8r/D1X93SfdtCWLytjF7BL3/nlYA4=;
        b=Vntdz8+B+JaSfFgoi3UYyQn+pGWRu0BUu6JkO2Qyo0srR26BX7aT7NdWIYit8POIyT
         btdkaxIgwIHiB3+3cl4nHzXVK5C4py+EZxJXvMpY8VHZkhW4JpwP7sr3WIdu+vnm866F
         94Gu0mqhxAjdUDMiOBuVbb2uz/icDe7bqeasE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=wAxTGG2z5uPbKc8r/D1X93SfdtCWLytjF7BL3/nlYA4=;
        b=yMeUX14yQhCYZB7kUMSKBuKW6HH4FyYun239kAuh4JNDmy8Dmuvrvrf+LWVY5cfQ9W
         ZCToiyuI0wbiDmvpxkWb0MSpdU9EKYE6/eUoNJb5muIIxlizLW5N6/EprId+g2rNf8SK
         Qup1h7mPZkG+zm4MaR4VWvQwYQ2sFhY6w65TmGzcnIce8Py4NY9Bda1AHjy8Q2H71+cD
         +i0uubAercbMpdqwMFjeJaRLx3KpUHyVYgYyHEUQoUdf0rywc5I9+Ww0PoKOaUSEPaKH
         X2TUHmlcWLWYQlA+RcXU7ZPEGUH7cO8vm/nU+J+qeu9+FqhnbXJ+dtcqx2siZQCZuXxk
         Hc2w==
X-Gm-Message-State: AJIora+sTs9DF2SfW6zoDgVgyj7bZQFql2a0cCbj8wgku8NHgbfNd+ex
        XuiiNd97B4znQ8EjpUWcesQSnb5l120o/bpICeg=
X-Google-Smtp-Source: AGRyM1uCnybtNPDlnIYrvuJnA94o8cWmI1PwH5RTcy12bKnyT83CGih09Q55gn0u9+TUgqodve6D1A==
X-Received: by 2002:a05:6830:280c:b0:61c:ae90:2ae8 with SMTP id w12-20020a056830280c00b0061cae902ae8mr10104380otu.251.1659572845025;
        Wed, 03 Aug 2022 17:27:25 -0700 (PDT)
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com. [209.85.210.54])
        by smtp.gmail.com with ESMTPSA id cd1-20020a056830620100b0061c24cd628bsm4269431otb.7.2022.08.03.17.27.23
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Aug 2022 17:27:24 -0700 (PDT)
Received: by mail-ot1-f54.google.com with SMTP id x1-20020a056830278100b00636774b0e54so3283533otu.4
        for <netdev@vger.kernel.org>; Wed, 03 Aug 2022 17:27:23 -0700 (PDT)
X-Received: by 2002:a9d:61c4:0:b0:61d:17b2:59d4 with SMTP id
 h4-20020a9d61c4000000b0061d17b259d4mr10080432otk.284.1659572843301; Wed, 03
 Aug 2022 17:27:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220803101438.24327-1-pabeni@redhat.com> <CAHk-=widn7iZozvVZ37cDPK26BdOegGAX_JxR+v62sCv-5=eZg@mail.gmail.com>
 <YusOpd6IuLB29LHs@salvia>
In-Reply-To: <YusOpd6IuLB29LHs@salvia>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 3 Aug 2022 17:27:07 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj59jR+pxYHmtf+OJvThEpYLNYLb9P5YkgCcBWDWzhdPQ@mail.gmail.com>
Message-ID: <CAHk-=wj59jR+pxYHmtf+OJvThEpYLNYLb9P5YkgCcBWDWzhdPQ@mail.gmail.com>
Subject: Re: [GIT PULL] Networking for 6.0
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Paolo Abeni <pabeni@redhat.com>, Vlad Buslov <vladbu@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 3, 2022 at 5:11 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> For these two questions, this new Kconfig toggle was copied from:
>
>  config NF_CONNTRACK_PROCFS
>         bool "Supply CT list in procfs (OBSOLETE)"
>         default y
>         depends on PROC_FS
>
> which is under:
>
>  if NF_CONNTRACK
>
> but the copy and paste was missing this.

Note that there's two problems with that

 (1) the NF_CONNTRACK_PROCFS thing is 'default y' because it *USED* to
be unconditional, and was split up as a config option back in 2011.

See commit 54b07dca6855 ("netfilter: provide config option to disable
ancient procfs parts").

IOW, that NF_CONNTRACK_PROCFS exists and defaults to on, not because
people added new code and wanted to make it default, but because the
code used to always be enabled if NF_CONNTRACK was enabled, and people
wanted the option to *disable* it.

That's when you do 'default y' - you take existing code that didn't
originally have a question at all, and you make it optional. Then you
use 'default y' so that people who used it don't get screwed in the
process.

 (2) it didn't do the proper conditional on the feature it depended on.

So let's not do copy-and-paste programming. The old Kconfig snippet
had completely different rules, had completely different history, and
completely different default values as a result.

I realize that it's very easy to think of Kconfig as some
not-very-important detail to just hook things up. But because it's
front-facing to users, I do want people to think about it more than
perhaps people otherwise would.

                Linus
