Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0702E560569
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 18:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbiF2QH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 12:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiF2QH5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 12:07:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A1F0F46;
        Wed, 29 Jun 2022 09:07:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91DF0B82567;
        Wed, 29 Jun 2022 16:07:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9B59C34114;
        Wed, 29 Jun 2022 16:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656518873;
        bh=Lm6CUaZIH8JvfgITPcL/dkrUMXZH0oRURSUBr2YgLgk=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=CSgi0oG3+JdttLszw8ZyEnYpeVES69JAlKUWmUzp/8WF3y5ze5fuuJGuP4XDZjWZL
         rWgWX+ssvIfPx9P4KDn3eP8uwNH5qxa6OLk+aIOkhiKQtbXNNF0mEWt9XzpiQoajF4
         ELNbiS8yiU0bo54oPuAeipD3ipo5xQONwIjaItB1WXt3WOZobx80hy6IAWFAath78B
         xGBxkP+gbwtCH4j/kOozHCgF/OOvmVtu8mjRmEf8/YsDu2ulfhAWFVLYIEpCIxHFmt
         hK1Sli1dOEFWlTUgmBNbGU5XzXxv0c6zk5z25S90hzCi1qAZvnIWUo0C7eAm9SkTFV
         P8bKccTWXoYuQ==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 8F3F15C0921; Wed, 29 Jun 2022 09:07:52 -0700 (PDT)
Date:   Wed, 29 Jun 2022 09:07:52 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
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
Message-ID: <20220629160752.GE1790663@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
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
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

And I got confirmation from the Android folks that they have other ways
of getting their 20-millisecond expedited RCU CPU stall warnings, so:

Acked-by: Paul E. McKenney <paulmck@kernel.org>

> ---
>  drivers/Makefile                                    | 2 +-
>  drivers/android/Kconfig                             | 9 ---------
>  drivers/char/random.c                               | 3 +--
>  drivers/net/wireguard/device.c                      | 2 +-
>  kernel/configs/android-base.config                  | 1 -
>  kernel/rcu/Kconfig.debug                            | 3 +--
>  tools/testing/selftests/filesystems/binderfs/config | 1 -
>  tools/testing/selftests/sync/config                 | 1 -
>  8 files changed, 4 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/Makefile b/drivers/Makefile
> index 9a30842b22c54..123dce2867583 100644
> --- a/drivers/Makefile
> +++ b/drivers/Makefile
> @@ -176,7 +176,7 @@ obj-$(CONFIG_USB4)		+= thunderbolt/
>  obj-$(CONFIG_CORESIGHT)		+= hwtracing/coresight/
>  obj-y				+= hwtracing/intel_th/
>  obj-$(CONFIG_STM)		+= hwtracing/stm/
> -obj-$(CONFIG_ANDROID)		+= android/
> +obj-y				+= android/
>  obj-$(CONFIG_NVMEM)		+= nvmem/
>  obj-$(CONFIG_FPGA)		+= fpga/
>  obj-$(CONFIG_FSI)		+= fsi/
> diff --git a/drivers/android/Kconfig b/drivers/android/Kconfig
> index 53b22e26266c3..07aa8ae0a058c 100644
> --- a/drivers/android/Kconfig
> +++ b/drivers/android/Kconfig
> @@ -1,13 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0
>  menu "Android"
>  
> -config ANDROID
> -	bool "Android Drivers"
> -	help
> -	  Enable support for various drivers needed on the Android platform
> -
> -if ANDROID
> -
>  config ANDROID_BINDER_IPC
>  	bool "Android Binder IPC Driver"
>  	depends on MMU
> @@ -54,6 +47,4 @@ config ANDROID_BINDER_IPC_SELFTEST
>  	  exhaustively with combinations of various buffer sizes and
>  	  alignments.
>  
> -endif # if ANDROID
> -
>  endmenu
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
> diff --git a/kernel/configs/android-base.config b/kernel/configs/android-base.config
> index eb701b2ac72ff..44b0f0146a3fc 100644
> --- a/kernel/configs/android-base.config
> +++ b/kernel/configs/android-base.config
> @@ -7,7 +7,6 @@
>  # CONFIG_OABI_COMPAT is not set
>  # CONFIG_SYSVIPC is not set
>  # CONFIG_USELIB is not set
> -CONFIG_ANDROID=y
>  CONFIG_ANDROID_BINDER_IPC=y
>  CONFIG_ANDROID_BINDER_DEVICES=binder,hwbinder,vndbinder
>  CONFIG_ANDROID_LOW_MEMORY_KILLER=y
> diff --git a/kernel/rcu/Kconfig.debug b/kernel/rcu/Kconfig.debug
> index 9b64e55d4f615..e875f4f889656 100644
> --- a/kernel/rcu/Kconfig.debug
> +++ b/kernel/rcu/Kconfig.debug
> @@ -86,8 +86,7 @@ config RCU_EXP_CPU_STALL_TIMEOUT
>  	int "Expedited RCU CPU stall timeout in milliseconds"
>  	depends on RCU_STALL_COMMON
>  	range 0 21000
> -	default 20 if ANDROID
> -	default 0 if !ANDROID
> +	default 0
>  	help
>  	  If a given expedited RCU grace period extends more than the
>  	  specified number of milliseconds, a CPU stall warning is printed.
> diff --git a/tools/testing/selftests/filesystems/binderfs/config b/tools/testing/selftests/filesystems/binderfs/config
> index 02dd6cc9cf992..7b4fc6ee62057 100644
> --- a/tools/testing/selftests/filesystems/binderfs/config
> +++ b/tools/testing/selftests/filesystems/binderfs/config
> @@ -1,3 +1,2 @@
> -CONFIG_ANDROID=y
>  CONFIG_ANDROID_BINDERFS=y
>  CONFIG_ANDROID_BINDER_IPC=y
> diff --git a/tools/testing/selftests/sync/config b/tools/testing/selftests/sync/config
> index 47ff5afc37271..64c60f38b4464 100644
> --- a/tools/testing/selftests/sync/config
> +++ b/tools/testing/selftests/sync/config
> @@ -1,3 +1,2 @@
>  CONFIG_STAGING=y
> -CONFIG_ANDROID=y
>  CONFIG_SW_SYNC=y
> -- 
> 2.30.2
> 
