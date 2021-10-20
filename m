Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEE4A4354D3
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 22:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbhJTU7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 16:59:02 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:56246
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229695AbhJTU7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 16:59:01 -0400
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com [209.85.167.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id BBB4A3FFE7
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 20:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1634763404;
        bh=ej3tolcgPxSkmZKxTFzlEV+yeFLAQSjDBgYwepQ5Y2A=;
        h=To:Cc:References:From:Subject:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=E4jWBuQcHPNGhupYX3qlsuIbG9SCZpbb5knizIWG+id5bnvEy/123OF9WSWAAVv/3
         4Na9dTUvQlpdyI7lJ3p9gkURDJVtXTlIqchgm0SUGRKSHqo89L54kYs/YYm1yHOUH+
         iwW1mpwuum5mmLSq85vdVfD/twAQHnrBdvpw3sDV0F2E/rRBw+AlcrVbN/jJdFjDMt
         pN4OiSdw/3iPVDOVuyrmFqka35TQ91IoIJD4JbqlrVzGUEFAbwYesKPx8iJKef+tsK
         7sEEwBBGEAQ4bgBOL/OrR3/sdhCAhxzK+usK/k8+jZF7YB/PN3zmx0FYCe5HfhtobU
         tNECw/uCHZRiQ==
Received: by mail-lf1-f69.google.com with SMTP id i1-20020a056512340100b003fdd5b951e0so3524968lfr.22
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 13:56:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ej3tolcgPxSkmZKxTFzlEV+yeFLAQSjDBgYwepQ5Y2A=;
        b=A8KydCm8u0lV/v1hek0GML21pZLjqSwmh+T1cHRuNJJ1ErpRynsEa+89WYczarWgqb
         ECeUuIRswxAu8wEUicHkP0+ePKH7YfmY1dZV8dJb3laFvDpruslLBz7IJnkD0UJxAlv7
         sMGwLCvUlUetUGIK6tXREHYIl5XtNAomXW0Z5+e2rPnQWX1es0IsKd0E4eTJCgerMnkB
         wPFcmAi1glR5eftuB9h+m6WlIDhEic1pW4aFAh4ZqNQnjoM/nMkBuJyYrs40Jt+QBVrR
         Oi/z2t7nM+b3pqY6iPp3K4Ib0CI57YosspSeHnTMWsL0KXSpE2itIXff50DLL72iSddk
         kw7w==
X-Gm-Message-State: AOAM533GHIjHKR5k+smJ8QFQ9Od1sOZtw+yHJqO44gujA5icJ1I+WGam
        EihJ/wMxL7TRr8irjxKRJP12ZFK7jKSPsUQLPItq6ONsVAqb0lC/EVQpfogLjGGWYEkiBFGIcDu
        ULZSFU7cXlL3kqT32M4NciwIzcKG3JmouhQ==
X-Received: by 2002:a05:6512:398d:: with SMTP id j13mr1475185lfu.292.1634763404025;
        Wed, 20 Oct 2021 13:56:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz2tKOF/ci/DGkUHWFKDCZAXymlCX1AGqtT/RSExx/aAtmHW/6GJnmDVixSy1cftLmb9dc03A==
X-Received: by 2002:a05:6512:398d:: with SMTP id j13mr1475160lfu.292.1634763403744;
        Wed, 20 Oct 2021 13:56:43 -0700 (PDT)
Received: from [192.168.3.161] (89-77-68-124.dynamic.chello.pl. [89.77.68.124])
        by smtp.gmail.com with ESMTPSA id a11sm276538lfl.157.2021.10.20.13.56.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 13:56:43 -0700 (PDT)
To:     Alan Stern <stern@rowland.harvard.edu>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     syzbot <syzbot+abd2e0dafb481b621869@syzkaller.appspotmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        Pavel Skripkin <paskripkin@gmail.com>,
        Thierry Escande <thierry.escande@collabora.com>,
        Andrey Konovalov <andreyknvl@gmail.com>
References: <000000000000c644cd05c55ca652@google.com>
 <9e06e977-9a06-f411-ab76-7a44116e883b@canonical.com>
 <20210722144721.GA6592@rowland.harvard.edu>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: Re: [syzbot] INFO: task hung in port100_probe
Message-ID: <b9695fc8-51b5-c61e-0a2f-fec9c2f0bae0@canonical.com>
Date:   Wed, 20 Oct 2021 22:56:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210722144721.GA6592@rowland.harvard.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/07/2021 16:47, Alan Stern wrote:
> On Thu, Jul 22, 2021 at 04:20:10PM +0200, Krzysztof Kozlowski wrote:
>> On 22/06/2021 17:43, syzbot wrote:
>>> Hello,
>>>
>>> syzbot found the following issue on:
>>>
>>> HEAD commit:    fd0aa1a4 Merge tag 'for-linus' of git://git.kernel.org/pub..
>>> git tree:       upstream
>>> console output: https://syzkaller.appspot.com/x/log.txt?x=13e1500c300000
>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=7ca96a2d153c74b0
>>> dashboard link: https://syzkaller.appspot.com/bug?extid=abd2e0dafb481b621869
>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1792e284300000
>>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13ad9d48300000
>>>
>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>> Reported-by: syzbot+abd2e0dafb481b621869@syzkaller.appspotmail.com
>>>
>>> INFO: task kworker/0:1:7 blocked for more than 143 seconds.
>>>       Not tainted 5.13.0-rc6-syzkaller #0
>>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>> task:kworker/0:1     state:D stack:25584 pid:    7 ppid:     2 flags:0x00004000
>>> Workqueue: usb_hub_wq hub_event
>>> Call Trace:
>>>  context_switch kernel/sched/core.c:4339 [inline]
>>>  __schedule+0x916/0x23e0 kernel/sched/core.c:5147
>>>  schedule+0xcf/0x270 kernel/sched/core.c:5226
>>>  schedule_timeout+0x1db/0x250 kernel/time/timer.c:1868
>>>  do_wait_for_common kernel/sched/completion.c:85 [inline]
>>>  __wait_for_common kernel/sched/completion.c:106 [inline]
>>>  wait_for_common kernel/sched/completion.c:117 [inline]
>>>  wait_for_completion+0x168/0x270 kernel/sched/completion.c:138
>>>  port100_send_cmd_sync drivers/nfc/port100.c:923 [inline]
>>>  port100_get_command_type_mask drivers/nfc/port100.c:1008 [inline]
>>>  port100_probe+0x9e4/0x1340 drivers/nfc/port100.c:1554
>>>  usb_probe_interface+0x315/0x7f0 drivers/usb/core/driver.c:396
> ...
> 
>> Cc: Thierry, Alan, Andrey,
>>
>> The issue is reproducible immediately on QEMU instance with
>> USB_DUMMY_HCD and USB_RAW_GADGET. I don't know about real port100 NFC
>> device.
>>
>> I spent some time looking into this and have no clue, except that it
>> looks like an effect of a race condition.
>>
>> 1. When using syskaller reproducer against one USB device (In the C
>> reproducer change the loop in main() to use procid=0) - issue does not
>> happen.
>>
>> 2. With two threads or more talking to separate Dummy USB devices, the
>> issue appears. The more of them, the better...
>>
>> 3. The reported problem is in missing complete. The correct flow is like:
>> port100_probe()
>> port100_get_command_type_mask()
>> port100_send_cmd_sync()
>> port100_send_cmd_async()
>> port100_submit_urb_for_ack()
>> port100_send_complete()
>> [   63.363863] port100 2-1:0.0: NFC: Urb failure (status -71)
>> port100_recv_ack()
>> [   63.369942] port100 2-1:0.0: NFC: Urb failure (status -71)
>>
>> and schedule_work() which completes and unblocks port100_send_cmd_sync
>>
>> However in the failing case (hung task) the port100_recv_ack() is never
>> called. It looks like USB core / HCD / gadget does not send the Ack/URB
>> complete.
>>
>> I don't know why. The port100 NFC driver code looks OK, except it is not
>> prepared for missing ack/urb so it waits indefinitely. I could try to
>> convert it to wait_for_completion_timeout() but it won't be trivial and
>> more important - I am not sure if this is the problem. Somehow the ACK
>> with Urb failure is not sent back to the port100 device. Therefore I am
>> guessing that the race condition is somwhere in USB stack, not in
>> port100 driver.
>>
>> The lockdep and other testing tools did not find anything here.
>>
>> Anyone hints where the issue could be?
> 
> Here's what I wrote earlier: "It looks like the problem stems from the fact 
> that port100_send_frame_async() submits two URBs, but 
> port100_send_cmd_sync() only waits for one of them to complete.  The other 
> URB may then still be active when the driver tries to reuse it."
> 
> Of course, there may be more than one problem, so we may not be talking 
> about the same thing.

Hi Alan, Felipe, Greg and others,

This is an old issue reported by syzkaller for NFC port100 driver [1].
There is something similar for pn533 [2].

I was looking at it some time ago, took a break and now I am trying to
fix it again. Without success.

The issue is reproducible via USB gadget on QEMU, not on real HW. I
looked and debugged the code and I think previously mentioned
double-URB-submit is not the reason here. Or I miss how the USB works
(which is quite probable...).

1. The port100 driver calls port100_send_cmd_sync() which eventually
goes to port100_send_frame_async(). After it, it waits for "sync"
completion.

2. In port100_send_frame_async(), driver indeed first submits "out_urb"
which quite fast is being processed by dummy_hcd with "no ep configured"
and -EPROTO.

3. Then (or sometimes before -EPROTO response from (2) above) the
port100_send_frame_async() submits "in_urb" via
port100_submit_urb_for_ack() and waits for its completion. Completion of
"in_urb" (or the "ack") in port100_recv_ack() would schedule work to
complete the (1) above - the sync completion.

4. Usually, when reproducer works fine (does not trigger issue), the
dummy_timer() from gadget responds with the same "no ep configured for
urb" for this "in_urb" (3). This completes "in_urb", which eventually
completes (1) and probe finishes with error. Error is expected, because
it's random junk-gadget...

The syzkaller reproducer fails if >1 of threads are running these usb
gadgets.  When this happens, no "in_urb" completion happens. No this
"ack" port100_recv_ack().

I added some debugs and simply dummy_hcd dummy_timer() is woken up on
enqueuing in_urb and then is looping crazy on a previous URB (some older
URB, coming from before port100 driver probe started). The dummy_timer()
loop never reaches the second "in_urb" to process it, I think.

The pn533 NFC driver has similar design, but I have now really doubts it
is a NFC driver issue. Instead an issue in dummy gadget HCD is somehow
triggered by the reproducer.

Reproduction - just follow [1] or [2]. Eventually I slightly tweaked the
code and put here:
https://github.com/krzk/tools/tree/master/tests-var/nfc/port100_probe
$ make
$ sudo ./port100_probe


[1] https://syzkaller.appspot.com/bug?extid=abd2e0dafb481b621869
[2] https://syzkaller.appspot.com/bug?extid=1dc8b460d6d48d7ef9ca


Best regards,
Krzysztof
