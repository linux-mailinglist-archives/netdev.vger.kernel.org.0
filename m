Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2A25606CE
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 18:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbiF2Q45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 12:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbiF2Q4z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 12:56:55 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4209D25588;
        Wed, 29 Jun 2022 09:56:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9EB7DCE25C4;
        Wed, 29 Jun 2022 16:56:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13837C341CB;
        Wed, 29 Jun 2022 16:56:45 +0000 (UTC)
Date:   Wed, 29 Jun 2022 12:56:43 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        Todd Kjos <tkjos@android.com>,
        Martijn Coenen <maco@android.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Christian Brauner <brauner@kernel.org>,
        Hridya Valsaraju <hridya@google.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Theodore Ts'o <tytso@mit.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Alex Xu (Hello71)" <alex_y_xu@yahoo.ca>,
        Paolo Abeni <pabeni@redhat.com>, Rob Herring <robh@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Neeraj Upadhyay <quic_neeraju@quicinc.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
        rcu@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] remove CONFIG_ANDROID
Message-ID: <20220629125643.393df70d@gandalf.local.home>
In-Reply-To: <20220629164543.GA25672@lst.de>
References: <20220629150102.1582425-1-hch@lst.de>
        <20220629150102.1582425-2-hch@lst.de>
        <Yrx5Lt7jrk5BiHXx@zx2c4.com>
        <20220629161020.GA24891@lst.de>
        <Yrx6EVHtroXeEZGp@zx2c4.com>
        <20220629161527.GA24978@lst.de>
        <Yrx8/Fyx15CTi2zq@zx2c4.com>
        <20220629163007.GA25279@lst.de>
        <Yrx/8UOY+J8Ao3Bd@zx2c4.com>
        <20220629164543.GA25672@lst.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


[ Note, I'm not on the Android team and my response has nothing to do with
  my employer. I would say the same thing with my previous employer. ]

On Wed, 29 Jun 2022 18:45:43 +0200
Christoph Hellwig <hch@lst.de> wrote:

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

Should there then be a CONFIG_FREQUENT_SUSPENDS ?

That is, if you have system where you know that there will be a lot of
frequent suspends coming from user space, then you would enable it.

I agree, calling this ANDROID is not related to the functionality change.
But if there was a config that was related, would that be acceptable?

Then it would not just be Android that could enabled this change, but any
other system that is doing frequent suspends?

-- Steve
