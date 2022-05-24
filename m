Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5C535324DE
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 10:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbiEXIFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 04:05:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbiEXIE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 04:04:58 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39D849A982;
        Tue, 24 May 2022 01:04:54 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id C6A001F8B8;
        Tue, 24 May 2022 08:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1653379492; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+HrTVIvXJDgrzNQFl8Mhx0wGW/HWHO1IHY/NT0Ch0wc=;
        b=cmANZ9kaIvAGzRMHaeCxB0LLBkrlXozlKGlr2MQNHSGuBkVg9GZ4ULppK80AYEMbn3sHQ3
        SRCkpAxtJlotC4dIBTUf4LWabWRfn+CV2iXTLVzyyBDKp8B9onijAa8QBBUxy4R2DAxIkT
        C3aqZP5pWFL7HdTOLlEm50sKDepVyxc=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id A47272C141;
        Tue, 24 May 2022 08:04:51 +0000 (UTC)
Date:   Tue, 24 May 2022 10:04:51 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc:     Scott Branden <scott.branden@broadcom.com>,
        Sebastian Reichel <sre@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Desmond yan <desmond.yan@broadcom.com>,
        David Gow <davidgow@google.com>,
        Evan Green <evgreen@chromium.org>,
        Julius Werner <jwerner@chromium.org>,
        bcm-kernel-feedback-list@broadcom.com, linux-pm@vger.kernel.org,
        akpm@linux-foundation.org, bhe@redhat.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-alpha@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-um@lists.infradead.org,
        linux-xtensa@linux-xtensa.org, netdev@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net, rcu@vger.kernel.org,
        sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org,
        x86@kernel.org, kernel-dev@igalia.com, kernel@gpiccoli.net,
        halves@canonical.com, fabiomirmar@gmail.com,
        alejandro.j.jimenez@oracle.com, andriy.shevchenko@linux.intel.com,
        arnd@arndb.de, bp@alien8.de, corbet@lwn.net,
        d.hatayama@jp.fujitsu.com, dave.hansen@linux.intel.com,
        dyoung@redhat.com, feng.tang@intel.com, gregkh@linuxfoundation.org,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de, keescook@chromium.org,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        will@kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
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
        zhenwei pi <pizhenwei@bytedance.com>
Subject: Re: [PATCH 19/30] panic: Add the panic hypervisor notifier list
Message-ID: <YoyRo6gJrr4lsFpD@alley>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-20-gpiccoli@igalia.com>
 <YoJZVZl/MH0KiE/J@alley>
 <ad082ce7-db50-13bb-3dbb-9b595dfa78be@igalia.com>
 <YoOpyW1+q+Z5as78@alley>
 <d72b9aab-675c-ac89-b73a-b1de4a0b722d@igalia.com>
 <81878a67-21f1-fee8-1add-f381bc8b05df@broadcom.com>
 <edbaa4fa-561c-6f5e-f2ab-43ae68acaede@igalia.com>
 <d1cc0bee-2a98-0c2e-8796-6fb7fae6b803@broadcom.com>
 <0fac8c71-6f18-d15c-23f5-075dbc45f3f9@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0fac8c71-6f18-d15c-23f5-075dbc45f3f9@igalia.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 2022-05-23 11:56:12, Guilherme G. Piccoli wrote:
> On 19/05/2022 16:20, Scott Branden wrote:
> > [...] 
> >> Hi Scott / Desmond, thanks for the detailed answer! Is this adapter
> >> designed to run in x86 only or you have other architectures' use cases?
> > The adapter may be used in any PCIe design that supports DMA.
> > So it may be possible to run in arm64 servers.
> >>
> >> [...]
> >> With that said, and given this is a lightweight notifier that ideally
> >> should run ASAP, I'd keep this one in the hypervisor list. We can
> >> "adjust" the semantic of this list to include lightweight notifiers that
> >> reset adapters.
> > Sounds the best to keep system operating as tested today.
> >>
> >> With that said, Petr has a point - not always such list is going to be
> >> called before kdump. So, that makes me think in another idea: what if we
> >> have another list, but not on panic path, but instead in the custom
> >> crash_shutdown()? Drivers could add callbacks there that must execute
> >> before kexec/kdump, no matter what.
> > It may be beneficial for some other drivers but for our use we would 
> > then need to register for the panic path and the crash_shutdown path. 
> > We notify the VK card for 2 purposes: one to stop DMA so memory stop 
> > changing during a kdump.  And also to get the card into a good state so 
> > resets happen cleanly.
> 
> Thanks Scott! With that, I guess it's really better to keep this
> notifier in this hypervisor/early list - I'm planning to do that for V2.
> Unless Petr or somebody has strong feelings against that, of course.

I am fine with it because we do not have a better solution at the
moment.

It might be a good candidate for the 5th notifier list mentioned
in the thread https://lore.kernel.org/r/YoyQyHHfhIIXSX0U@alley .
But I am not sure if the 5th list is worth the complexity.

Best Regards,
Petr
