Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD57D439D31
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 19:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbhJYRQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 13:16:32 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:58136
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230183AbhJYRQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 13:16:30 -0400
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com [209.85.208.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 95AB33FFEE
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 17:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1635182041;
        bh=Hk4lOwz4f7wTCRGYtvRC48wy0ThJFDVetY4MJ8P3wC4=;
        h=To:Cc:References:From:Subject:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=IZRYw9DkLzHS20dcu21cxwzIfOpoWENoeMXfGToADOcMukF1gTFbR05i1wqMATOPs
         On9G4Q4ZeqmQ1N1x/nFhVpFgJs0EkaJS6jN4UYvq5m3RGQzX6tLO2EMFKgSUZQBIFV
         evzKAkLOD1Yz7eGMACxS2yE3a3KMIq9ysacOo7uveftBvMpPRpriGiS3ckGzmvngl+
         pGQzG4PvuYkPtmLAaQsVy+wxkbUxuX9KaQDnUgDpBm1JC1dW+1wxpFAspw5hS9I/pb
         ZJ3Dlvvdljvy2flj6LTJgXbhK3s71ZWYCLv2w1XJBsCeSb8yizBYPVCWD9Oc5+52vP
         zqBuhjnZjg63w==
Received: by mail-lj1-f197.google.com with SMTP id d13-20020a2e810d000000b002117419160cso1258957ljg.18
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 10:14:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Hk4lOwz4f7wTCRGYtvRC48wy0ThJFDVetY4MJ8P3wC4=;
        b=2tP5MLcm3FKxZNEhas2jA+sGu++mqlUD4vXY8optRK5tKgtI0RO+fEHvdW6CYMyErs
         hd3pRuN/ehguDoY0FJ5iZ1Yqa2K+hBUj0AifVhpePuByeKbXOtNreB0gSLzzexcrNSgA
         aQjnkvWIIp6zBgXq6qsiAJ7S+mAd8QHymzaF9DvbIm1TRpbdDB126KEzRQM+e/m11dTP
         45kIkyK4cipCAzFvO8GXRQjiJI6Y26WKjxowpsVU/rwiyJcfg3HD21w8RAQ5tpSOaZoM
         HPHKIKZuT2oDffL5pTD4u9YLH30SAn2fpvq0XvVnjWIh9Ek+tvtiZJKmy+FMAsR3wwWU
         F2jQ==
X-Gm-Message-State: AOAM532FNaRwn8S3/pS6E0IBvUnFHs55y1NdcQboR57iuTIuji+tqUvp
        k5ZNttppA910PmGCejetk6TvJUPIeICU/Xj3QWDwujFMFPczZzaSWpEdCJSXYz3/aER+nr5ku6c
        Di3BU80vJO9GhlY229zfPoLbJpYUhzP8fOw==
X-Received: by 2002:a05:6512:a8b:: with SMTP id m11mr18243188lfu.220.1635182040976;
        Mon, 25 Oct 2021 10:14:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzYoERLcQJ9Xo3eL7nVeEMLZOJkMn00zTSr1p+6RuUJ4YRUUT+0bdoruptwB7i2KGokoxuQpA==
X-Received: by 2002:a05:6512:a8b:: with SMTP id m11mr18243162lfu.220.1635182040719;
        Mon, 25 Oct 2021 10:14:00 -0700 (PDT)
Received: from [192.168.3.161] (89-77-68-124.dynamic.chello.pl. [89.77.68.124])
        by smtp.gmail.com with ESMTPSA id m13sm77929lji.132.2021.10.25.10.13.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 10:14:00 -0700 (PDT)
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        syzbot <syzbot+abd2e0dafb481b621869@syzkaller.appspotmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        Pavel Skripkin <paskripkin@gmail.com>,
        Thierry Escande <thierry.escande@collabora.com>,
        Andrey Konovalov <andreyknvl@gmail.com>
References: <000000000000c644cd05c55ca652@google.com>
 <9e06e977-9a06-f411-ab76-7a44116e883b@canonical.com>
 <20210722144721.GA6592@rowland.harvard.edu>
 <b9695fc8-51b5-c61e-0a2f-fec9c2f0bae0@canonical.com>
 <20211020220503.GB1140001@rowland.harvard.edu>
 <7d26fa0f-3a45-cefc-fd83-e8979ba6107c@canonical.com>
 <20211025162200.GC1258186@rowland.harvard.edu>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: Re: [syzbot] INFO: task hung in port100_probe
Message-ID: <1927ec9b-d1d0-9c70-992b-925ddfbba79a@canonical.com>
Date:   Mon, 25 Oct 2021 19:13:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211025162200.GC1258186@rowland.harvard.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/10/2021 18:22, Alan Stern wrote:
> On Mon, Oct 25, 2021 at 04:57:23PM +0200, Krzysztof Kozlowski wrote:
>> On 21/10/2021 00:05, Alan Stern wrote:
>>>>
>>>> The syzkaller reproducer fails if >1 of threads are running these usb
>>>> gadgets.  When this happens, no "in_urb" completion happens. No this
>>>> "ack" port100_recv_ack().
>>>>
>>>> I added some debugs and simply dummy_hcd dummy_timer() is woken up on
>>>> enqueuing in_urb and then is looping crazy on a previous URB (some older
>>>> URB, coming from before port100 driver probe started). The dummy_timer()
>>>> loop never reaches the second "in_urb" to process it, I think.
>>>
>>> Is there any way you can track down what's happening in that crazy loop?  
>>> That is, what driver was responsible for the previous URB?
>>>
>>> We have seen this sort of thing before, where a driver submits an URB 
>>> for a gadget which has disconnected.  The URB fails with -EPROTO status 
>>> but the URB's completion handler does an automatic resubmit.  That can 
>>> lead to a very tight loop with dummy-hcd, and it could easily prevent 
>>> some other important processing from occurring.  The simple solution is 
>>> to prevent the driver from resubmitting when the completion status is 
>>> -EPROTO.
>>
>> Hi Alan,
>>
>> Thanks for the reply.
>>
>> The URB which causes crazy loop is the port100 driver second URB, the
>> one called ack or in_urb.
>>
>> The flow is:
>> 1. probe()
>> 2. port100_get_command_type_mask()
>> 3. port100_send_cmd_async()
>> 4. port100_send_frame_async()
>> 5. usb_submit_urb(dev->out_urb)
>>    The call succeeds, the dummy_hcd picks it up and immediately ends the
>> timer-loop with -EPROTO
> 
> So that URB completes immediately.
> 
>> The completion here does not resubmit another/same URB. I checked this
>> carefully and I hope I did not miss anything.
> 
> Yeah, I see the same thing.
> 
>> 6. port100_submit_urb_for_ack() which sends the in_urb:
>>    usb_submit_urb(dev->in_urb)
>> ... wait for completion
>> ... dummy_hcd loops on this URB around line 2000:
>> if (status == -EINPROGRESS)
>>   continue
> 
> Do I understand this correctly?  You're saying that dummy-hcd executes 
> the following jump at line 1975:
> 
> 		/* incomplete transfer? */
> 		if (status == -EINPROGRESS)
> 			continue;
> 
> which goes back up to the loop head on line 1831:
> 
> 	list_for_each_entry_safe(urbp, tmp, &dum_hcd->urbp_list, urbp_list) {
> 
> Is that right?

Yes, exactly. The loop continues, iterating over list finishes thus the
loops and dummy timer function exits. Then immediately it is being
rescheduled by something (I don't know by what yet).

To remind - the syzbot reproducer must run at least two threads
(spawning USB gadgets so creating separate dummy devices) at the same
time. However only one of dummy HCD devices seems to timer-loop
endlessly... but this might not be important, e.g. maybe it's how syzbot
reproducer works.

>  I don't see why this should cause any problem.  It won't 
> loop back to the same URB; it will make its way through the list.  
> (Unless the list has somehow gotten corrupted...)  dum_hcd->urbp_list 
> should be short (perhaps 32 entries at most), so the loop should reach 
> the end of the list fairly quickly.

The list has actually only one element - only this one URB coming from
port100 device (which I was always calling second URB/ack, in_urb).

> Now, doing all this 1000 times per second could use up a significant 
> portion of the available time.  Do you think that's the reason for the 
> problem?  It seems pretty unlikely.

No, this timer-looping itself is not a problem. Problem is that this URB
never reaches some final state, e.g. -EPROTO.

In normal operation, e.g. when reproducer did not hit the issue, both
URBs from port100 (the first out_urb and second in_urb) complete with
-EPROTO. In the case leading to hang ("task kworker/0:0:5 blocked for
more than 143 seconds"), the in_urb does not complete therefore the
port100 driver waits.

Whether this intensive timer-loop is important (processing the same URB
and continuing), I don't know.

Best regards,
Krzysztof
