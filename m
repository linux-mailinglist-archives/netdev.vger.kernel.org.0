Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 523E8514F29
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 17:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378336AbiD2PXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 11:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378305AbiD2PXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 11:23:09 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 984A4D4CBB;
        Fri, 29 Apr 2022 08:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=PkGMRtr7ZOpuAUYdkK5YcnBWQgNByIkM+TF/PhPSt00=; b=McsgIEmWszU/NtZ864aphbd05/
        AA+Hs7uyIJtJtMr4867fKRnrcDZ/B0ve7meILjRDqPYrpj2SCcZq87R4becMzN/EmmpSkGxa2bXfq
        pUhMsFJRA7hiMl/hulL8uwaQ3NgTviAzyrP9F3cuPytnlSXUcQgJY1SVDx/EfT4PyEI3blubrtgBl
        Y/qFy6eJFuUH765RC4uiwWYgWdDuIIe2xttNarhTtSLeO0f5vFGPmxPe8sb1rSPH9MLQ8MhCgLKVk
        8Yh9XWbluokYf/vW7/yQXLp3HdC2BoK3CBL6+DlGPNeddie6sMCK3FiVbeA/PpCZCA2PeX8k9qatt
        P0Tqe4Tg==;
Received: from [179.113.53.197] (helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1nkSOj-000BaQ-FP; Fri, 29 Apr 2022 17:19:09 +0200
Message-ID: <31248811-d3ed-63dd-e255-c3be07fb1434@igalia.com>
Date:   Fri, 29 Apr 2022 12:18:29 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 21/30] panic: Introduce the panic pre-reboot notifier list
Content-Language: en-US
To:     minyard@acm.org, elder@ieee.org, Alex Elder <elder@kernel.org>,
        cminyard@mvista.com
Cc:     akpm@linux-foundation.org, bhe@redhat.com, pmladek@suse.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linuxppc-dev@lists.ozlabs.org, linux-alpha@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-pm@vger.kernel.org,
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
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Chris Zankel <chris@zankel.net>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Dexuan Cui <decui@microsoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Helge Deller <deller@gmx.de>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        James Morse <james.morse@arm.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Matt Turner <mattst88@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>, Pavel Machek <pavel@ucw.cz>,
        Richard Henderson <rth@twiddle.net>,
        Richard Weinberger <richard@nod.at>,
        Robert Richter <rric@kernel.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Tony Luck <tony.luck@intel.com>,
        Vasily Gorbik <gor@linux.ibm.com>, Wei Liu <wei.liu@kernel.org>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-22-gpiccoli@igalia.com>
 <20220428162616.GE442787@minyard.net>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <20220428162616.GE442787@minyard.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/04/2022 13:26, Corey Minyard wrote:
> [...]
> 
> For the IPMI portion:
> 
> Acked-by: Corey Minyard <cminyard@mvista.com>

Thanks Alex and Corey for the ACKs!

> 
> Note that the IPMI panic_event() should always return, but it may take
> some time, especially if the IPMI controller is no longer functional.
> So the risk of a long delay is there and it makes sense to move it very
> late.
> 

Thanks, I agree - the patch moves it to the (latest - 1) position, since
some arch code might run as the latest and effectively stops the machine.
Cheers,


Guilherme
