Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D22F515739
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 23:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239211AbiD2VtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 17:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239040AbiD2VtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 17:49:19 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5EE7814B2;
        Fri, 29 Apr 2022 14:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=cwWnO80Ui/d685UGUuBb6P6W/VqQxrK3NU0KyxunMME=; b=NuAZTGtLYYcfk4IaGz8kBTT5Di
        0khQT6RBBrfoMfADRQoh55tLUZAAxvGzbf+CHwsG5aHW/I0aPMt9IcQreT+TXN6tVft3fhHxppW6e
        0gRrhT6oZwWHTdNRt+hsETMwNeSqJUbKiJvdYcPS0Tel4JSlQtazcO1PKvgS3i7ssm2Wvg6CHs/7o
        pj47XlfT3VRnDJ1t48UzNo9OiptPRH+9FkqQXagZ6uncBzcJGMl/PQwNLpM91GK25wc70TaaRl3MI
        17OaYSYBFRj1A/+iiCNfQT0GNRF/9G3lza+liz2omEugL6i4QHflxUFmrjvLEVlv51bSj77G0/dOg
        tubfbwug==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58452)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nkYQk-0004ZT-FQ; Fri, 29 Apr 2022 22:45:38 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nkYQM-0002I9-Ul; Fri, 29 Apr 2022 22:45:14 +0100
Date:   Fri, 29 Apr 2022 22:45:14 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        akpm@linux-foundation.org, bhe@redhat.com, pmladek@suse.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
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
        hidehiro.kawai.ez@hitachi.com, jgross@suse.com,
        john.ogness@linutronix.de, keescook@chromium.org, luto@kernel.org,
        mhiramat@kernel.org, mingo@redhat.com, paulmck@kernel.org,
        peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        will@kernel.org
Subject: Re: [PATCH 02/30] ARM: kexec: Disable IRQs/FIQs also on crash CPUs
 shutdown path
Message-ID: <Ymxcaqy6DwhoQrZT@shell.armlinux.org.uk>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-3-gpiccoli@igalia.com>
 <87mtg392fm.wl-maz@kernel.org>
 <71d829c4-b280-7d6e-647d-79a1baf9408b@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71d829c4-b280-7d6e-647d-79a1baf9408b@igalia.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 29, 2022 at 06:38:19PM -0300, Guilherme G. Piccoli wrote:
> Thanks Marc and Michael for the review/discussion.
> 
> On 29/04/2022 15:20, Marc Zyngier wrote:
> > [...]
> 
> > My expectations would be that, since we're getting here using an IPI,
> > interrupts are already masked. So what reenabled them the first place?
> > 
> > Thanks,
> > 
> > 	M.
> > 
> 
> Marc, I did some investigation in the code (and tried/failed in the ARM
> documentation as well heh), but this is still not 100% clear for me.
> 
> You're saying IPI calls disable IRQs/FIQs by default in the the target
> CPUs? Where does it happen? I'm a bit confused if this a processor
> mechanism, or it's in code.

When we taken an IRQ, IRQs will be masked, FIQs will not. IPIs are
themselves interrupts, so IRQs will be masked while the IPI is being
processed. Therefore, there should be no need to re-disable the
already disabled interrupts.

> But crash_smp_send_stop() is different, it seems to IPI the other CPUs
> with the flag IPI_CALL_FUNC, which leads to calling
> generic_smp_call_function_interrupt() - does it disable interrupts/FIQs
> as well? I couldn't find it.

It's buried in the architecture behaviour. When the CPU takes an
interrupt and jumps to the interrupt vector in the vectors page, it is
architecturally defined that interrupts will be disabled. If they
weren't architecturally disabled at this point, then as soon as the
first instruction is processed (at the interrupt vector, likely a
branch) the CPU would immediately take another jump to the interrupt
vector, and this process would continue indefinitely, making interrupt
handling utterly useless.

So, you won't find an explicit instruction in the code path from the
vectors to the IPI handler that disables interrupts - because it's
written into the architecture that this is what must happen.

IRQs are a lower priority than FIQs, so FIQs remain unmasked.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
