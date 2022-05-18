Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 945B352B39A
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 09:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232236AbiERHeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 03:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232127AbiERHeH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 03:34:07 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D294CC5E55;
        Wed, 18 May 2022 00:34:04 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 8990E1F9A4;
        Wed, 18 May 2022 07:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1652859243; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YR5rOhmSURb4d/IKXy5VZg8z1ImD01Us4xBpVFtyoqU=;
        b=apiSUoAwUbqeAccPNQ19K+RPeAfjpiC+Kw09kP9gYD08Bjqn9sy6l8W4iwyq6IQeI6Aplp
        +YIfJeRJqbcdQptzveOcUb8Q0R7nuJcbMiyUrGxQWxZdDf/W1Ubmr612J8Zmj7lPwrkx5l
        wG1cTFsW35nAwzkY9hs+1GgrMVmINpw=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id AA6042C142;
        Wed, 18 May 2022 07:33:59 +0000 (UTC)
Date:   Wed, 18 May 2022 09:33:57 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc:     Evan Green <evgreen@chromium.org>, David Gow <davidgow@google.com>,
        Julius Werner <jwerner@chromium.org>,
        Scott Branden <scott.branden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Sebastian Reichel <sre@kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, bhe@redhat.com,
        kexec@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org, linux-alpha@vger.kernel.org,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-um@lists.infradead.org, linux-xtensa@linux-xtensa.org,
        netdev@vger.kernel.org, openipmi-developer@lists.sourceforge.net,
        rcu@vger.kernel.org, sparclinux@vger.kernel.org,
        xen-devel@lists.xenproject.org, x86@kernel.org,
        kernel-dev@igalia.com, kernel@gpiccoli.net, halves@canonical.com,
        fabiomirmar@gmail.com, alejandro.j.jimenez@oracle.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>,
        Jonathan Corbet <corbet@lwn.net>, d.hatayama@jp.fujitsu.com,
        dave.hansen@linux.intel.com, dyoung@redhat.com,
        feng.tang@intel.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de,
        Kees Cook <keescook@chromium.org>, luto@kernel.org,
        mhiramat@kernel.org, mingo@redhat.com, paulmck@kernel.org,
        peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, Alan Stern <stern@rowland.harvard.edu>,
        Thomas Gleixner <tglx@linutronix.de>, vgoyal@redhat.com,
        vkuznets@redhat.com, Will Deacon <will@kernel.org>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Andrea Parri <parri.andrea@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Dexuan Cui <decui@microsoft.com>,
        Doug Berger <opendmb@gmail.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hari Bathini <hbathini@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Justin Chen <justinpopo6@gmail.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Lee Jones <lee.jones@linaro.org>,
        Markus Mayer <mmayer@broadcom.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mihai Carabas <mihai.carabas@oracle.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Pavel Machek <pavel@ucw.cz>,
        Shile Zhang <shile.zhang@linux.alibaba.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Wang ShaoBo <bobo.shaobowang@huawei.com>,
        Wei Liu <wei.liu@kernel.org>,
        zhenwei pi <pizhenwei@bytedance.com>,
        Stephen Boyd <swboyd@chromium.org>
Subject: Re: [PATCH 19/30] panic: Add the panic hypervisor notifier list
Message-ID: <YoShZVYNAdvvjb7z@alley>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-20-gpiccoli@igalia.com>
 <YoJZVZl/MH0KiE/J@alley>
 <ad082ce7-db50-13bb-3dbb-9b595dfa78be@igalia.com>
 <CAE=gft7ds+dHfEkRz8rnSH1EbTpGTpKbi5Wxj9DW0Jr5mX_j4w@mail.gmail.com>
 <YoOi9PFK/JnNwH+D@alley>
 <b9ec2fc8-216f-f261-8417-77b6dd95e25c@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9ec2fc8-216f-f261-8417-77b6dd95e25c@igalia.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 2022-05-17 13:37:58, Guilherme G. Piccoli wrote:
> On 17/05/2022 10:28, Petr Mladek wrote:
> > [...]
> >>> Disagree here. I'm looping Google maintainers, so they can comment.
> >>> (CCed Evan, David, Julius)
> >>>
> >>> This notifier is clearly a hypervisor notification mechanism. I've fixed
> >>> a locking stuff there (in previous patch), I feel it's low-risk but even
> >>> if it's mid-risk, the class of such callback remains a perfect fit with
> >>> the hypervisor list IMHO.
> >>
> >> This logs a panic to our "eventlog", a tiny logging area in SPI flash
> >> for critical and power-related events. In some cases this ends up
 > >> being the only clue we get in a Chromebook feedback report that a
> >> panic occurred, so from my perspective moving it to the front of the
> >> line seems like a good idea.
> > 
> > IMHO, this would really better fit into the pre-reboot notifier list:
> > 
> >    + the callback stores the log so it is similar to kmsg_dump()
> >      or console_flush_on_panic()
> > 
> >    + the callback should be proceed after "info" notifiers
> >      that might add some other useful information.
> > 
> > Honestly, I am not sure what exactly hypervisor callbacks do. But I
> > think that they do not try to extract the kernel log because they
> > would need to handle the internal format.
> > 
> 
> I guess the main point in your response is : "I am not sure what exactly
> hypervisor callbacks do". We need to be sure about the semantics of such
> list, and agree on that.
> 
> So, my opinion about this first list, that we call "hypervisor list",
> is: it contains callbacks that
> 
> (1) should run early, preferably before kdump (or even if kdump isn't
> set, should run ASAP);
> 
> (2) these callbacks perform some communication with an abstraction that
> runs "below" the kernel, like a firmware or hypervisor. Classic example:
> pvpanic, that communicates with VMM (usually qemu) and allow such VMM to
> snapshot the full guest memory, for example.
> 
> (3) Should be low-risk. What defines risk is the level of reliability of
> subsequent operations - if the callback have 50% of chance of "bricking"
> the system totally and prevent kdump / kmsg_dump() / reboot , this is
> high risk one for example.
> 
> Some good fits IMO: pvpanic, sstate_panic_event() [sparc], fadump in
> powerpc, etc.
> 
> So, this is a good case for the Google notifier as well - it's not
> collecting data like the dmesg (hence your second bullet seems to not
> apply here, info notifiers won't add info to be collected by gsmi). It
> is a firmware/hypervisor/whatever-gsmi-is notification mechanism, that
> tells such "lower" abstraction a panic occurred. It seems low risk and
> we want it to run ASAP, if possible.

" 
> >> This logs a panic to our "eventlog", a tiny logging area in SPI flash
> >> for critical and power-related events. In some cases this ends up

I see. I somehow assumed that it was about the kernel log because
Evans wrote:

  "This logs a panic to our "eventlog", a tiny logging area in SPI flash
   for critical and power-related events. In some cases this ends up"


Anyway, I would distinguish it the following way.

  + If the notifier is preserving kernel log then it should be ideally
    treated as kmsg_dump().

  + It the notifier is saving another debugging data then it better
    fits into the "hypervisor" notifier list.


Regarding the reliability. From my POV, any panic notifier enabled
in a generic kernel should be reliable with more than 99,9%.
Otherwise, they should not be in the notifier list at all.

An exception would be a platform-specific notifier that is
called only on some specific platform and developers maintaining
this platform agree on this.

The value "99,9%" is arbitrary. I am not sure if it is realistic
even in the other code, for example, console_flush_on_panic()
or emergency_restart(). I just want to point out that the border
should be rather high. Otherwise we would back in the situation
where people would want to disable particular notifiers.

Best Regards,
Petr
