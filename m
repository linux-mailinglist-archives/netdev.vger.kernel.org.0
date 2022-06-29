Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5F3560575
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 18:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232027AbiF2QJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 12:09:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232959AbiF2QJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 12:09:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F007822B0A;
        Wed, 29 Jun 2022 09:09:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C41A61BD6;
        Wed, 29 Jun 2022 16:09:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E8D2C34114;
        Wed, 29 Jun 2022 16:09:32 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="pUHci5uX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1656518970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ulgicCSwAYHtgZTUtITAxwZdp4jV/NBvkJ1S3ys4pvs=;
        b=pUHci5uXb9l405fL8FD2wM/Xr8vP+OkOGimAV+9AWYLO6eTRGFk57+3ZykBS/RtrcrOCul
        +XfDgJ1rvZtR4QCuYxlv8tFOlV+QTfMl5aImwN0xYvu8A6G6V/9++ByQTmF52mdzRIs99r
        f+1hTkVgPTNYEGoMVtvF05tQC9H5M7M=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 766dd221 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 29 Jun 2022 16:09:29 +0000 (UTC)
Date:   Wed, 29 Jun 2022 18:09:18 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
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
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
        rcu@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] remove CONFIG_ANDROID
Message-ID: <Yrx5Lt7jrk5BiHXx@zx2c4.com>
References: <20220629150102.1582425-1-hch@lst.de>
 <20220629150102.1582425-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220629150102.1582425-2-hch@lst.de>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christoph,

On Wed, Jun 29, 2022 at 05:01:02PM +0200, Christoph Hellwig wrote:
> diff --git a/drivers/char/random.c b/drivers/char/random.c
> index e3dd1dd3dd226..f35ad1a9dff3e 100644
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -755,8 +755,7 @@ static int random_pm_notification(struct notifier_block *nb, unsigned long actio
>  	spin_unlock_irqrestore(&input_pool.lock, flags);
>  
>  	if (crng_ready() && (action == PM_RESTORE_PREPARE ||
> -	    (action == PM_POST_SUSPEND &&
> -	     !IS_ENABLED(CONFIG_PM_AUTOSLEEP) && !IS_ENABLED(CONFIG_ANDROID)))) {
> +	    (action == PM_POST_SUSPEND && !IS_ENABLED(CONFIG_PM_AUTOSLEEP)))) {
>  		crng_reseed();
>  		pr_notice("crng reseeded on system resumption\n");
>  	}
> diff --git a/drivers/net/wireguard/device.c b/drivers/net/wireguard/device.c
> index aa9a7a5970fda..de1cc03f7ee86 100644
> --- a/drivers/net/wireguard/device.c
> +++ b/drivers/net/wireguard/device.c
> @@ -69,7 +69,7 @@ static int wg_pm_notification(struct notifier_block *nb, unsigned long action, v
>  	 * its normal operation rather than as a somewhat rare event, then we
>  	 * don't actually want to clear keys.
>  	 */
> -	if (IS_ENABLED(CONFIG_PM_AUTOSLEEP) || IS_ENABLED(CONFIG_ANDROID))
> +	if (IS_ENABLED(CONFIG_PM_AUTOSLEEP))
>  		return 0;
>  
>  	if (action != PM_HIBERNATION_PREPARE && action != PM_SUSPEND_PREPARE)
 
CONFIG_ANDROID is used here for a reason. As somebody suggested in
another thread of which you were a participant, it acts as a proxy for
"probably running on Android hardware", which in turn is a proxy for,
"suspend happens all the time on this machine, so don't do fancy key
clearing stuff every time the user clicks the power button."

You can see the history of that in these two commits here:
https://git.zx2c4.com/wireguard-linux-compat/commit/?id=36f81c83674e0fd7c18e5b15499d1a275b6d4d7f
https://git.zx2c4.com/wireguard-linux-compat/commit/?id=a89d53098dbde43f56e4d1e16ba5e24ef807c03b

The former commit was done when I first got this running on an Android
device (a Oneplus 3T, IIRC) and I encountered this problem. The latter
was a refinement after suggestions on LKML during WireGuard's
upstreaming.

So there *is* a reason to have that kind of conditionalization in the
code. The question is: does CONFIG_ANDROID actually represent something
interesting here? Is this already taken care of by CONFIG_PM_AUTOSLEEP
on all CONFIG_ANDROID devices? That is, do the base Android configs set
CONFIG_PM_AUTOSLEEP already so this isn't necessary? Or is there some
*other* proxy config value that should be used? Or is there a different
solution entirely that should be considered?

I don't know the answers to these questions, because I haven't done a
recent analysis. Obviously at one point in time I did, and that's why
the code is how it is. It sounds like you'd now like to revisit that
original decision. That's fine with me. But you need to conduct a new
analysis and write down your findings inside of a commit message. I must
see that you've at least thought about the problem and looked into it
substantially enough that making this change is safe. Your "let's delete
it; it's not doing much" alone seems more expedient than thorough.

Jason
