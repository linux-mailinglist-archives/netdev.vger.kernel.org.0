Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6ECD3D3759
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 11:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234600AbhGWIYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 04:24:45 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:33406
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233339AbhGWIYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 04:24:45 -0400
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPS id 5ACD23F22B
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 09:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627031116;
        bh=dlHmqHPdcdPu0WXRAu7v4Eey7TFbIILD148MiNpcSTI=;
        h=To:Cc:References:From:Subject:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=Gb2m59iqkwVfhq72qA7TbQGFGedrjwRIXffjWy53mwmfGaklRQ3+ztxZUKK5+F3nK
         oVCc+LxGZY6oKAeQE71XGU0lPMNfrKYwykAm9rQJ6fnHHE+xyM2ZjIkomw4VeQUyaE
         3sls5Ma23uwkmdptC1SEqERzLvK6P9Rj8TD3TFC0qM6/YA9aygWeiGJBY87RvBG1Kl
         xfQNKXRCuJtRDsQaV7LFHWWCyhjfzXjx4KiXXMdfKJyvVNfqISCtmollucQvif/ZwK
         CAX6U+sqdaaQdigtfzbvCjOe89ZgNe2TqR+UM7UeFifT0b42TN3YtH9IxzRngCn35n
         YatMEDRYoHy+Q==
Received: by mail-ed1-f70.google.com with SMTP id e1-20020a50ec810000b029039c88110440so382471edr.15
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 02:05:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dlHmqHPdcdPu0WXRAu7v4Eey7TFbIILD148MiNpcSTI=;
        b=kJagIStnBz+Zpxw1eCoCU4pVXkl48QKH+tGhiIdTFx1vjMtKog52W3McndHqDBRxx8
         5Xb+tsYltagveQ/ZTWKguPvbpk+GmKukaJ/CEKl/c0vJBHgjE0JO1Ty1YG4qL7v+sMOM
         fFC8aNj/HH4CyiU7JHRq1fsIjawzhOerns8PIClBM+VVAb5Ndgq3RjeYdl1RfbPz4nYX
         q7X/GhY7HuplVbGlbbI9Xv41P5BIhz11vcdBXDVMkBEKbFJyBv1eqgG22uCVCZZa/z06
         bBteYalAi3xCsB7ArlrutWZPxTbcxKi1wL8CxN0H+XZeg8Xy27bO9p9dfAzDy53dUfDD
         Md/Q==
X-Gm-Message-State: AOAM530M0c+A1F+b76nJJ/Q7DpL7JRQr27HnC9JgcObVjdmKK5kdlF/h
        Jp7IKdvG+FE6RLfEMmGip/yomK/Wn1NUwQkvLY824GcOVQ5hW7PwfmyLfIEh3MPxnWTd7Cd83tQ
        Mxvlj0/jS16mIYxH0Xo8j4BZGa+1bC8DBWQ==
X-Received: by 2002:a05:6402:2789:: with SMTP id b9mr4317735ede.201.1627031111342;
        Fri, 23 Jul 2021 02:05:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwKjx3o7L2U2zrWp7thsR9EOn4YDgBNWX+4Bn/t0jtaRyK4v+HYacCr26T/a1r8TmnHdXh8IQ==
X-Received: by 2002:a05:6402:2789:: with SMTP id b9mr4317722ede.201.1627031111217;
        Fri, 23 Jul 2021 02:05:11 -0700 (PDT)
Received: from [192.168.8.102] ([86.32.47.9])
        by smtp.gmail.com with ESMTPSA id s11sm4794976edx.30.2021.07.23.02.05.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jul 2021 02:05:10 -0700 (PDT)
To:     Alan Stern <stern@rowland.harvard.edu>
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
Message-ID: <b007e1e5-6978-3b7a-8d7f-3d8f3a448436@canonical.com>
Date:   Fri, 23 Jul 2021 11:05:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
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

I see now you replied this to earlier syzbot report about "URB submitted
while active". Here is a slightly different issue - hung task on waiting
for completion coming from device ack.

However maybe these are both similar or at least come from similar root
cause in the driver.

> 
> Of course, there may be more than one problem, so we may not be talking 
> about the same thing.
> 
> Does that help at all?

Thanks, it gives me some ideas to look into although I spent already too
much time on this old driver. I doubt it has any users so maybe better
to mark it as BROKEN...


Best regards,
Krzysztof
