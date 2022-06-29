Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B22B56073E
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 19:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231491AbiF2RTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 13:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbiF2RTp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 13:19:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E74822289;
        Wed, 29 Jun 2022 10:19:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A13DF61E6B;
        Wed, 29 Jun 2022 17:19:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D9E1C341C8;
        Wed, 29 Jun 2022 17:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656523184;
        bh=7SEzehmTNiedxnN/WyWz5hw+VLLOK+1tiViOeyV+LwU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nTB2P46GglBZYH8eYlOmT0yhVsC0SdQpx2SlanJHUQqipHLAZHXfbNFgBiQ0FQM/F
         cD+JTc+uDNS6UJ9YPZzL8dsW2GbUU5yf8dl5N9O/jtPNDW7Zui8HY9idCsKDfXZd8W
         46gApD0MR22xzwtQEPeLhQJLah20KDBiKC3GVi7Y=
Date:   Wed, 29 Jun 2022 19:19:36 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
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
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Netdev <netdev@vger.kernel.org>, rcu@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] remove CONFIG_ANDROID
Message-ID: <YryJqI/ppVfMhRhI@kroah.com>
References: <20220629161020.GA24891@lst.de>
 <Yrx6EVHtroXeEZGp@zx2c4.com>
 <20220629161527.GA24978@lst.de>
 <Yrx8/Fyx15CTi2zq@zx2c4.com>
 <20220629163007.GA25279@lst.de>
 <Yrx/8UOY+J8Ao3Bd@zx2c4.com>
 <20220629164543.GA25672@lst.de>
 <CAHmME9rwKmEQcn84GfTrCPzaK3g6vh6rpQ=YcgyTo_PWpJ5VcA@mail.gmail.com>
 <YryFKXsx/Bgv/oBE@kroah.com>
 <YryHk06Ye/12dMEN@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YryHk06Ye/12dMEN@zx2c4.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 29, 2022 at 07:10:43PM +0200, Jason A. Donenfeld wrote:
> On Wed, Jun 29, 2022 at 07:00:25PM +0200, Greg Kroah-Hartman wrote:
> > I think that by the time the next kernel release comes out, and
> > percolates to a real Android device, the years gone by will have caused
> > those who care about this to fix it.
> 
> You assume that there aren't Android devices using kernels outside of
> the ones you're referring to. That's a rather Google-centric
> perspective. It's still breakage, even if Google has the ability to fix
> it locally after "years gone by". If you want Android things to be
> upstream, this is the way you must think about it; otherwise, what's the
> point? By your logic, upstream should probably remove the Android code
> everywhere and let Google handle it downstream. Except nobody wants
> that; we want Android upstream. So let's keep it working upstream, not
> intentionally break it.

I would be totally and completly amazed if there are any Android kernels
in real devices in the world that are not at the very least, based on
LTS releases.  But maybe there is, this patch series isn't going to land
until 5.20, and by then, I think the "define behavior, not hardware" fix
for random and wg will be properly resolved :)

> > In the meantime, this might actually fix issues in desktop distros that
> > were enabling this option, thinking it only affected the building of a
> > driver
> 
> That sounds like a false dichotomy. It's not about "fix Android" vs "fix
> distros". What I'm suggesting is fixing Android AND fixing distros, by
> looking at the problem holistically. Trading a bad problem on Android
> (wg connections are broken) for a manageable problem on distros (something
> something theoretical warm boot attack something) doesn't sound like a
> nice trade off. Let's instead get this all fixed at the same time.

Agreed, so what should we use instead in the wg code?  What userspace
functionality are you trying to trigger off of here in the current
CONFIG_ANDROID check?

The RCU stuff is already handled as Paul has stated, so that's not an
issue.

thanks,

greg k-h
