Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D18556048A
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 17:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234100AbiF2P1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 11:27:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234199AbiF2P12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 11:27:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B062E9FB;
        Wed, 29 Jun 2022 08:27:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8318360B27;
        Wed, 29 Jun 2022 15:27:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C40D8C34114;
        Wed, 29 Jun 2022 15:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656516446;
        bh=C7+n2xJegL9gjAWfn0gYV9ETANtGcmZOAauecDXXpMw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aVw2/8ykosIBTI15WhKjsfTHLa4ELBMBAvMHusrYnbWqsGUNPq8/vue9Obr7k+OM8
         Z03VBpUkdJ7I1gr3zda5pP9qLy1TMznbkAdEhlbV6odBTWoBQwdYxktyo7b5PaqqiM
         rura0NjwXFAj8QrHwXNjNOllKwxPlM5m6o4pk3R8=
Date:   Wed, 29 Jun 2022 17:27:21 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Todd Kjos <tkjos@android.com>,
        Martijn Coenen <maco@android.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Christian Brauner <brauner@kernel.org>,
        Hridya Valsaraju <hridya@google.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Theodore Ts'o <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
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
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
        rcu@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] remove CONFIG_ANDROID
Message-ID: <YrxvWT/aeQnwEv52@kroah.com>
References: <20220629150102.1582425-1-hch@lst.de>
 <20220629150102.1582425-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220629150102.1582425-2-hch@lst.de>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 29, 2022 at 05:01:02PM +0200, Christoph Hellwig wrote:
> The ANDROID config symbol is only used to guard the binder config
> symbol and to inject completely random config changes.  Remove it
> as it is obviously a bad idea.

Ick, rcu and random driver changes?  That's not ok, I'll go queue this
up, if Android devices need to make these core changes, they can do that
in their kernel or submit a patch that makes sense for everyone.

Also, one meta-comment:

>  kernel/configs/android-base.config                  | 1 -

This whole file can be deleted now, with the way Android kernels are now
being managed it makes no sense anymore.  I'll write up a patch to do
that later tonight.

thanks,

greg k-h
