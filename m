Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07F3352A6BE
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 17:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350114AbiEQPdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 11:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348307AbiEQPdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 11:33:36 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF7140E54;
        Tue, 17 May 2022 08:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=sBxOdf5zzlugJkhZHabZzTAtpXD19gBRD4MewoqTr3w=; b=NsQp7JvDHeiG0InrgCzgj6qEMn
        +0HDDirskWRJUwtuX9QZNgVpRKlGO/3aNrbmen6tXlKUhuV0+BbQy2aMCyUUGcetLiuWPChDYhZG2
        uActfFtkCGU4c6w7jw5eo3KbRLxEWlPGvaIXcW9KuVcgcDuIdvQJ7CUukGXL9th36+kW270UNj6cp
        KwfiG//V+ceMXkXz56bGppHfbEL7x2Yf8p2OfzRzA+P3gciDRGzrJlW3tYAmf8L72SPmNmKgXgiQH
        oN/Ktah8yVYeK7YuYx/7jPfAZeKiiCyehjDs7pB9vGbI0WRx7KI28Glco3R/cH3PEM9mA0rVYqkMG
        3w57FnRw==;
Received: from 200-161-159-120.dsl.telesp.net.br ([200.161.159.120] helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1nqzCM-008c9O-8K; Tue, 17 May 2022 17:33:22 +0200
Message-ID: <007af382-dcf5-b06d-acad-08f8d6ec7f8b@igalia.com>
Date:   Tue, 17 May 2022 12:32:39 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 15/30] bus: brcmstb_gisb: Clean-up panic/die notifiers
Content-Language: en-US
To:     Petr Mladek <pmladek@suse.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     akpm@linux-foundation.org, bhe@redhat.com,
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
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de, keescook@chromium.org,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        will@kernel.org, Brian Norris <computersforpeace@gmail.com>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-16-gpiccoli@igalia.com> <YnqEqDnMfUgC4dM6@alley>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <YnqEqDnMfUgC4dM6@alley>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/05/2022 12:28, Petr Mladek wrote:
> [...]
> IMHO, the check of the @self parameter was the proper solution.
> 
> "gisb_die_notifier" list uses @val from enum die_val.
> "gisb_panic_notifier" list uses @val from enum panic_notifier_val.
> 
> These are unrelated types. It might easily break when
> someone defines the same constant also in enum die_val.
> 
> Best Regards,
> Petr

OK Petr, I'll drop this idea for V2 - will just remove the useless
header / prototype then. (CC Florian)


Cheers,


Guilherme
