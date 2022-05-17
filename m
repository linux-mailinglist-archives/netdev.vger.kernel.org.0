Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A019752A865
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 18:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351140AbiEQQnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 12:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350063AbiEQQnB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 12:43:01 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C073B3FDAD;
        Tue, 17 May 2022 09:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=scD/9Z9PP3JtS/QbR0S82HRrb/qzzKD7mmsgRlJKv48=; b=A0Wed33QPDatmI/wU05BORZ9n1
        0hhJk6U25fx6bbbZAsMcq0PkUqYkw6doFXVO3lE2gRlx4mNP2Gg+o2qX5D1iIed/eOGnpU07MiS7v
        johrL8ZXBr9bRs4m6YspjNjUrp3CRZWOwFXObkbK34aTXOqWVxjbnj+S21xz3SW3iyyzLS8il/lBE
        YgblTLXs216LyG4XvwA74bc/PHj8Q4o7WtYFZIjzCamKnOfAXbs0CZLburXLM75F/4BH78OE9Feno
        1CTSSOT/QCKGLXFRsMSKXpMjqSuNKxrbhetupOiCZ9xDYHRTskdd6CLiaYJY53xEUzZgCM24bzp0B
        WqYqJCVA==;
Received: from 200-161-159-120.dsl.telesp.net.br ([200.161.159.120] helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1nr0Hb-008gzd-4h; Tue, 17 May 2022 18:42:51 +0200
Message-ID: <d72b9aab-675c-ac89-b73a-b1de4a0b722d@igalia.com>
Date:   Tue, 17 May 2022 13:42:06 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 19/30] panic: Add the panic hypervisor notifier list
Content-Language: en-US
To:     Petr Mladek <pmladek@suse.com>,
        Scott Branden <scott.branden@broadcom.com>,
        Sebastian Reichel <sre@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     David Gow <davidgow@google.com>, Evan Green <evgreen@chromium.org>,
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
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-20-gpiccoli@igalia.com> <YoJZVZl/MH0KiE/J@alley>
 <ad082ce7-db50-13bb-3dbb-9b595dfa78be@igalia.com> <YoOpyW1+q+Z5as78@alley>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <YoOpyW1+q+Z5as78@alley>
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

On 17/05/2022 10:57, Petr Mladek wrote:
> [...]
>>>> --- a/drivers/misc/bcm-vk/bcm_vk_dev.c
>>>> +++ b/drivers/misc/bcm-vk/bcm_vk_dev.c
>>>> @@ -1446,7 +1446,7 @@ static int bcm_vk_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>>> [... snip ...]
>>> It seems to reset some hardware or so. IMHO, it should go into the
>>> pre-reboot list.
>>
>> Mixed feelings here, I'm looping Broadcom maintainers to comment.
>> (CC Scott and Broadcom list)
>>
>> I'm afraid it breaks kdump if this device is not reset beforehand - it's
>> a doorbell write, so not high risk I think...
>>
>> But in case the not-reset device can be probed normally in kdump kernel,
>> then I'm fine in moving this to the reboot list! I don't have the HW to
>> test myself.
> 
> Good question. Well, it if has to be called before kdump then
> even "hypervisor" list is a wrong place because is not always
> called before kdump.

Agreed! I'll defer that to Scott and Broadcom folks to comment.
If it's not strictly necessary, I'll happily move it to the reboot list.

If necessary, we could use the machine_crash_kexec() approach, but we'll
fall into the case arm64 doesn't support it and I'm not sure if this
device is available for arm - again a question for the maintainers.


>  [...]
>>>> --- a/drivers/power/reset/ltc2952-poweroff.c
>>>> +++ b/drivers/power/reset/ltc2952-poweroff.c
>> [...]
>> This is setting a variable only, and once it's set (data->kernel_panic
>> is the bool's name), it just bails out the IRQ handler and a timer
>> setting - this timer seems kinda tricky, so bailing out ASAP makes sense
>> IMHO.
> 
> IMHO, the timer informs the hardware that the system is still alive
> in the middle of panic(). If the timer is not working then the
> hardware (chip) will think that the system frozen in panic()
> and will power off the system. See the comments in
> drivers/power/reset/ltc2952-poweroff.c:
> [.... snip ...]
> IMHO, we really have to keep it alive until we reach the reboot stage.
> 
> Another question is how it actually works when the interrupts are
> disabled during panic() and the timer callbacks are not handled.

Agreed here! Guess I can move this one the reboot list, fine by me.
Unless PM folks think otherwise.


> [...]
>> Disagree here, I'm CCing Florian for information.
>>
>> This notifier preserves RAM so it's *very interesting* if we have
>> kmsg_dump() for example, but maybe might be also relevant in case kdump
>> kernel is configured to store something in a persistent RAM (then,
>> without this notifier, after kdump reboots the system data would be lost).
> 
> I see. It is actually similar problem as with
> drivers/firmware/google/gsmi.c.
> 
> I does similar things like kmsg_dump() so it should be called in
> the same location (after info notifier list and before kdump).
> 
> A solution might be to put it at these notifiers at the very
> end of the "info" list or make extra "dump" notifier list.

Here I still disagree. I've commented in the other response thread
(about Google gsmi) about the semantics of the hypervisor list, but
again: this list should contain callbacks that

(a) Should run early, _by default_ before a kdump;
(b) Communicate with the firmware/hypervisor in a "low-risk" way;

Imagine a scenario where users configure kdump kernel to save something
in a persistent form in DRAM - it'd be like a late pstore, in the next
kernel. This callback enables that, it's meant to inform FW "hey, panic
happened, please from now on don't clear the RAM in the next FW-reboot".
I don't see a reason to postpone that - let's see if the maintainers
have an opinion.

Cheers,


Guilherme
