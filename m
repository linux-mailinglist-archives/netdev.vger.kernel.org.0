Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47C9E5605F3
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 18:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiF2QhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 12:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiF2QhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 12:37:06 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02C4031237;
        Wed, 29 Jun 2022 09:37:06 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5B0DE68AA6; Wed, 29 Jun 2022 18:37:01 +0200 (CEST)
Date:   Wed, 29 Jun 2022 18:37:01 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
Message-ID: <20220629163701.GA25519@lst.de>
References: <20220629150102.1582425-1-hch@lst.de> <20220629150102.1582425-2-hch@lst.de> <Yrx5Lt7jrk5BiHXx@zx2c4.com> <20220629161020.GA24891@lst.de> <Yrx6EVHtroXeEZGp@zx2c4.com> <20220629161527.GA24978@lst.de> <20220629163444.GG1790663@paulmck-ThinkPad-P17-Gen-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220629163444.GG1790663@paulmck-ThinkPad-P17-Gen-1>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 29, 2022 at 09:34:44AM -0700, Paul E. McKenney wrote:
> So you are OK if your patch is accepted, and then CONFIG_ANDROID is
> re-introduced but used only for building kernels intended to run on
> Android systems?

I don't think that is a good config.  In general you want APIs
to express behavior, and in that case that is goes to sleep and
wakes all the time.  So we need go figure out what causes this in
Android systems - I don't think it can be the hardware, so it must
be a policy set somewhere either in the kernel or fed into the kernel
by userspace.  Then we can key it off that, and I suspect it is
probably going to be a runtime variable and not a config option.
