Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1041D5606B9
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 18:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbiF2Qwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 12:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231533AbiF2Qwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 12:52:32 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79ED4BF4B;
        Wed, 29 Jun 2022 09:52:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D4628CE28AE;
        Wed, 29 Jun 2022 16:52:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC481C341CB;
        Wed, 29 Jun 2022 16:52:27 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="QiOL2Qug"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1656521543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=s9yQuP8dZlIefMwCtE/LZH80/r0SB1Bpmqz3sW7F0As=;
        b=QiOL2Quggjmg25RNTA9yJnjRwRJ0O0z8dtQzJbJUqtKUGjHEHa/zJ9CCLH+2WfUvOj6jfG
        Vcm8SvC9bb+vafFcBkjec7m3BIzDDzANavS7zSSrCgfPrRi+YDGCBGBJgmWH77+vmY5b+A
        Iyd2dbHNjNAdbq38fmK7CqCcdqKECVI=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id b655dbf0 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 29 Jun 2022 16:52:22 +0000 (UTC)
Received: by mail-io1-f46.google.com with SMTP id z191so16575027iof.6;
        Wed, 29 Jun 2022 09:52:22 -0700 (PDT)
X-Gm-Message-State: AJIora8BK0qQ/ILb/UFGJKOlttv1/zAJz/iJ3xaNuTVOhog5Ir8xTpo3
        4Syspf1Vj3cq0umN205ayPs/njQGJVLud0UJaB0=
X-Google-Smtp-Source: AGRyM1tEuvoeECCx/bx2m7scUVXWPupT5PUetPXh1d7o9fBuPNfa8DVhmIomMMIebUacCysCKoZGZxBEY4pNRnKB0hI=
X-Received: by 2002:a02:9709:0:b0:339:ef87:c30b with SMTP id
 x9-20020a029709000000b00339ef87c30bmr2526540jai.214.1656521539436; Wed, 29
 Jun 2022 09:52:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220629150102.1582425-1-hch@lst.de> <20220629150102.1582425-2-hch@lst.de>
 <Yrx5Lt7jrk5BiHXx@zx2c4.com> <20220629161020.GA24891@lst.de>
 <Yrx6EVHtroXeEZGp@zx2c4.com> <20220629161527.GA24978@lst.de>
 <Yrx8/Fyx15CTi2zq@zx2c4.com> <20220629163007.GA25279@lst.de>
 <Yrx/8UOY+J8Ao3Bd@zx2c4.com> <20220629164543.GA25672@lst.de>
In-Reply-To: <20220629164543.GA25672@lst.de>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 29 Jun 2022 18:52:08 +0200
X-Gmail-Original-Message-ID: <CAHmME9rwKmEQcn84GfTrCPzaK3g6vh6rpQ=YcgyTo_PWpJ5VcA@mail.gmail.com>
Message-ID: <CAHmME9rwKmEQcn84GfTrCPzaK3g6vh6rpQ=YcgyTo_PWpJ5VcA@mail.gmail.com>
Subject: Re: [PATCH] remove CONFIG_ANDROID
To:     Christoph Hellwig <hch@lst.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        Todd Kjos <tkjos@android.com>,
        Martijn Coenen <maco@android.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Christian Brauner <brauner@kernel.org>,
        Hridya Valsaraju <hridya@google.com>,
        Suren Baghdasaryan <surenb@google.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Alex Xu (Hello71)" <alex_y_xu@yahoo.ca>,
        Paolo Abeni <pabeni@redhat.com>, Rob Herring <robh@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Neeraj Upadhyay <quic_neeraju@quicinc.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Netdev <netdev@vger.kernel.org>, rcu@vger.kernel.org,
        linux-kselftest@vger.kernel.org
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

On Wed, Jun 29, 2022 at 6:45 PM Christoph Hellwig <hch@lst.de> wrote:
>
> On Wed, Jun 29, 2022 at 06:38:09PM +0200, Jason A. Donenfeld wrote:
> > On the technical topic, an Android developer friend following this
> > thread just pointed out to me that Android doesn't use PM_AUTOSLEEP and
> > just has userspace causing suspend frequently. So by his rough
> > estimation your patch actually *will* break Android devices. Zoinks.
> > Maybe he's right, maybe he's not -- I don't know -- but you should
> > probably look into this if you want this patch to land without breakage.
>
> And it will also "break" anyone else doing frequent suspends from
> userspace, as that behavior is still in no way related to
> CONFIG_ANDROID.

I don't know of any actual systems that do this for which
CONFIG_PM_AUTOSLEEP and CONFIG_ANDROID are both disabled. At least
that was what I concluded back in 2017-2018 when I looked at this
last. And so far, no other-handset-users have reported bugs.

But of course I agree that this all could be improved with something
more granular somehow, somewhere. I don't really have any developed
opinions on what that looks like or what form that should take.

However, the thing I do have a strong opinion on is that the change
you're proposing shouldn't break things. And that's what your patch
currently might do (or not!).

In other words, instead of making the current situation worse,
justified by your observation that in theory the current mechanism is
imperfect, please make the situation better. Or conclude that it
doesn't make the situation worse, and put the reason why inside your
commit message, which is the first thing I asked.

Jason
