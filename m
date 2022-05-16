Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2A3D52872E
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 16:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244589AbiEPOdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 10:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231847AbiEPOdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 10:33:44 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B2482AF8;
        Mon, 16 May 2022 07:33:43 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id C33171F9F3;
        Mon, 16 May 2022 14:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1652711621; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fVjlG4/dfH2RJ8QOIc+qrGCmgCcjOpZB+KPjtLQbhUo=;
        b=g7zXCdiW66+ZORh6/+b42qlwXs71YIm78eBo2DkB+6yci0VblhfjN32vYqq5tvyFP+a35V
        4IQbZk+eZ8m4N7dIzfRZvRcjGflhdk2pzgpwxTPHHTNBIE+W9GZV3Zj3ggNIRkQibkb0ZX
        yDFspItfCnZ03JfIlqNkkDR8LZU/GbA=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 5E6F32C141;
        Mon, 16 May 2022 14:33:41 +0000 (UTC)
Date:   Mon, 16 May 2022 16:33:41 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc:     akpm@linux-foundation.org, bhe@redhat.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, coresight@lists.linaro.org,
        linuxppc-dev@lists.ozlabs.org, linux-alpha@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-um@lists.infradead.org, linux-xtensa@linux-xtensa.org,
        netdev@vger.kernel.org, openipmi-developer@lists.sourceforge.net,
        rcu@vger.kernel.org, sparclinux@vger.kernel.org,
        xen-devel@lists.xenproject.org, x86@kernel.org,
        kernel-dev@igalia.com, kernel@gpiccoli.net, halves@canonical.com,
        fabiomirmar@gmail.com, alejandro.j.jimenez@oracle.com,
        andriy.shevchenko@linux.intel.com, arnd@arndb.de, bp@alien8.de,
        corbet@lwn.net, d.hatayama@jp.fujitsu.com,
        dave.hansen@linux.intel.com, dyoung@redhat.com,
        feng.tang@intel.com, gregkh@linuxfoundation.org,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de, keescook@chromium.org,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        will@kernel.org, Alex Elder <elder@kernel.org>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Chris Zankel <chris@zankel.net>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Corey Minyard <minyard@acm.org>,
        Dexuan Cui <decui@microsoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Helge Deller <deller@gmx.de>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        James Morse <james.morse@arm.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Matt Turner <mattst88@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>, Pavel Machek <pavel@ucw.cz>,
        Richard Weinberger <richard@nod.at>,
        Robert Richter <rric@kernel.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Tony Luck <tony.luck@intel.com>,
        Vasily Gorbik <gor@linux.ibm.com>, Wei Liu <wei.liu@kernel.org>
Subject: Re: [PATCH 21/30] panic: Introduce the panic pre-reboot notifier list
Message-ID: <YoJgcC8c6LaKADZV@alley>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-22-gpiccoli@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427224924.592546-22-gpiccoli@igalia.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 2022-04-27 19:49:15, Guilherme G. Piccoli wrote:
> This patch renames the panic_notifier_list to panic_pre_reboot_list;
> the idea is that a subsequent patch will refactor the panic path
> in order to better split the notifiers, running some of them very
> early, some of them not so early [but still before kmsg_dump()] and
> finally, the rest should execute late, after kdump. The latter ones
> are now in the panic pre-reboot list - the name comes from the idea
> that these notifiers execute before panic() attempts rebooting the
> machine (if that option is set).
> 
> We also took the opportunity to clean-up useless header inclusions,
> improve some notifier block declarations (e.g. in ibmasm/heartbeat.c)
> and more important, change some priorities - we hereby set 2 notifiers
> to run late in the list [iss_panic_event() and the IPMI panic_event()]
> due to the risks they offer (may not return, for example).
> Proper documentation is going to be provided in a subsequent patch,
> that effectively refactors the panic path.
> 
> --- a/drivers/edac/altera_edac.c
> +++ b/drivers/edac/altera_edac.c
> @@ -2163,7 +2162,7 @@ static int altr_edac_a10_probe(struct platform_device *pdev)
>  		int dberror, err_addr;
>  
>  		edac->panic_notifier.notifier_call = s10_edac_dberr_handler;
> -		atomic_notifier_chain_register(&panic_notifier_list,
> +		atomic_notifier_chain_register(&panic_pre_reboot_list,

My understanding is that this notifier first prints info about ECC
errors and then triggers reboot. It might make sense to split it
into two notifiers.


>  					       &edac->panic_notifier);
>  
>  		/* Printout a message if uncorrectable error previously. */
> --- a/drivers/leds/trigger/ledtrig-panic.c
> +++ b/drivers/leds/trigger/ledtrig-panic.c
> @@ -64,7 +63,7 @@ static long led_panic_blink(int state)
>  
>  static int __init ledtrig_panic_init(void)
>  {
> -	atomic_notifier_chain_register(&panic_notifier_list,
> +	atomic_notifier_chain_register(&panic_pre_reboot_list,
>  				       &led_trigger_panic_nb);

Blinking => should go to the last "post_reboot/loop" list.


>  
>  	led_trigger_register_simple("panic", &trigger);
> --- a/drivers/misc/ibmasm/heartbeat.c
> +++ b/drivers/misc/ibmasm/heartbeat.c
> @@ -32,20 +31,23 @@ static int suspend_heartbeats = 0;
>  static int panic_happened(struct notifier_block *n, unsigned long val, void *v)
>  {
>  	suspend_heartbeats = 1;
> -	return 0;
> +	return NOTIFY_DONE;
>  }
>  
> -static struct notifier_block panic_notifier = { panic_happened, NULL, 1 };
> +static struct notifier_block panic_notifier = {
> +	.notifier_call = panic_happened,
> +};
>  
>  void ibmasm_register_panic_notifier(void)
>  {
> -	atomic_notifier_chain_register(&panic_notifier_list, &panic_notifier);
> +	atomic_notifier_chain_register(&panic_pre_reboot_list,
> +					&panic_notifier);

Same here. Blinking => should go to the last "post_reboot/loop" list.


>  }
>  
>  void ibmasm_unregister_panic_notifier(void)
>  {
> -	atomic_notifier_chain_unregister(&panic_notifier_list,
> -			&panic_notifier);
> +	atomic_notifier_chain_unregister(&panic_pre_reboot_list,
> +					&panic_notifier);
>  }


The rest of the moved notifiers seem to fit well this "pre_reboot"
list.

Best Regards,
Petr
