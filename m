Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1674C5606D7
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 19:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbiF2RAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 13:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbiF2RAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 13:00:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C54CF36165;
        Wed, 29 Jun 2022 10:00:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81584B824F3;
        Wed, 29 Jun 2022 17:00:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CD3CC341C8;
        Wed, 29 Jun 2022 17:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656522028;
        bh=aX6BCoyP074w+Ec32Bjgq5Qkv6gXDTg4rIpA4hIZ24A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R/8KZZghPox1N6AUR6ZBSE/xv+dAqlVuAlzzf1S3mFLPeMy9gjW81Qyqgj5hKtmh0
         gOq8T3dJN9HtFzu4y60WkiX/h+42A8rz4ss6j7sQqCOugsHjUjiiA0TCDfIx5GZwcg
         zjgxIcHxyzUujwVKft4QczxAtQNI2V1YozgZ1JTI=
Date:   Wed, 29 Jun 2022 19:00:25 +0200
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
Message-ID: <YryFKXsx/Bgv/oBE@kroah.com>
References: <20220629150102.1582425-2-hch@lst.de>
 <Yrx5Lt7jrk5BiHXx@zx2c4.com>
 <20220629161020.GA24891@lst.de>
 <Yrx6EVHtroXeEZGp@zx2c4.com>
 <20220629161527.GA24978@lst.de>
 <Yrx8/Fyx15CTi2zq@zx2c4.com>
 <20220629163007.GA25279@lst.de>
 <Yrx/8UOY+J8Ao3Bd@zx2c4.com>
 <20220629164543.GA25672@lst.de>
 <CAHmME9rwKmEQcn84GfTrCPzaK3g6vh6rpQ=YcgyTo_PWpJ5VcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9rwKmEQcn84GfTrCPzaK3g6vh6rpQ=YcgyTo_PWpJ5VcA@mail.gmail.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 29, 2022 at 06:52:08PM +0200, Jason A. Donenfeld wrote:
> On Wed, Jun 29, 2022 at 6:45 PM Christoph Hellwig <hch@lst.de> wrote:
> >
> > On Wed, Jun 29, 2022 at 06:38:09PM +0200, Jason A. Donenfeld wrote:
> > > On the technical topic, an Android developer friend following this
> > > thread just pointed out to me that Android doesn't use PM_AUTOSLEEP and
> > > just has userspace causing suspend frequently. So by his rough
> > > estimation your patch actually *will* break Android devices. Zoinks.
> > > Maybe he's right, maybe he's not -- I don't know -- but you should
> > > probably look into this if you want this patch to land without breakage.
> >
> > And it will also "break" anyone else doing frequent suspends from
> > userspace, as that behavior is still in no way related to
> > CONFIG_ANDROID.
> 
> I don't know of any actual systems that do this for which
> CONFIG_PM_AUTOSLEEP and CONFIG_ANDROID are both disabled. At least
> that was what I concluded back in 2017-2018 when I looked at this
> last. And so far, no other-handset-users have reported bugs.
> 
> But of course I agree that this all could be improved with something
> more granular somehow, somewhere. I don't really have any developed
> opinions on what that looks like or what form that should take.
> 
> However, the thing I do have a strong opinion on is that the change
> you're proposing shouldn't break things. And that's what your patch
> currently might do (or not!).

I think that by the time the next kernel release comes out, and
percolates to a real Android device, the years gone by will have caused
those who care about this to fix it.

In the meantime, this might actually fix issues in desktop distros that
were enabling this option, thinking it only affected the building of a
driver, not core power management functionality.

So it's nothing to worry about now, I agree with Christoph, this config
option should not be used for power management policy decisions like
this.  This should be controlled by userspace properly in the Android
userspace framework, like all other Linux distros/systems do this.

And worst case, Android kernels sometimes _do_ have a not-upstream
config option that you can use to trigger off of horrible hacks like
this.  I'll leave the answer to what that is as an exercise for the
reader :)

thanks,

greg k-h
