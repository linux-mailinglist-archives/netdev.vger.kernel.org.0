Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5675F439970
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 16:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233665AbhJYO7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 10:59:52 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:38128
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233327AbhJYO7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 10:59:48 -0400
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com [209.85.208.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 4C67740019
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 14:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1635173845;
        bh=XEEjbbf43TVhSZTAS8/8FyfDDE32FaOk0qv1/zEV4vE=;
        h=To:Cc:References:From:Subject:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=SRnq/lnLmHfRU5bTQmByhzEtRpZq/XZwkLAojaHKrI1KdGwht1dAouebmZ4Dqsq3x
         tYfweSjbRCxuKQip8UPrUtY/Ux4fV8ZmbWfakN1maYwYf90jnlCHFhNtpEzWq9obAa
         /HPKAf6cCRxbaBAsxgT+fv3zZrO0yVqsGL4fcahdu/JKXCtUdO/zG27TrEG5QznuOB
         pyxaqeFTP6yX1VKHCKquoEqyPRxRcqxIX4/UtW33zy1EqZTFkR8LQcwPeSSyem0pxW
         3GpJiqsDV3hzCuhUk60SsAVy2p09lZAEITeYoMSSRP7cczdJGRYzGWu1K+m5NkA9J8
         ENTt7v+K6RXcg==
Received: by mail-lj1-f197.google.com with SMTP id z20-20020a05651c023400b0021162ead40fso1970633ljn.10
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 07:57:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XEEjbbf43TVhSZTAS8/8FyfDDE32FaOk0qv1/zEV4vE=;
        b=Zpd9pCBe4SOKMADj3fm+xIEmFaP30wVkAmJOv9L1UGKDvu4bLlH4yyx9FE6c010ROs
         3qj7SJ8YcV4LmaG4Vdaj8OgfSnlVnOzXkHGTfAZRUNPl9/xC3ZU8fiNthUYQlHua0wPN
         q3y+p99L6Qe0XDqaCJFtq+3qS6/GIcUbRXvgLgQ2DUMl1rDlDHpC1+jfLWDEFhMn3Ulh
         bZWPzYQdJpW1qxQdONN3Id51ie7R4sVZY+VQvrYNb2NrABSbriFmmXBS16jzdD0W9Yoo
         nhP25/aiOf3LfQDf89SV/N1FnEL3p7HnjV1UJksGVGHAIG6HiO3QYfk4EgaGoK1GITdn
         ob9w==
X-Gm-Message-State: AOAM5326VjacVjreOH8cqEATl+ncj/aQ0vzlK/DlAuYgoWrrsgPXPyCm
        AuHRn1G4kfOz2YMtj4xOBMtNGMpyCbakRD02gqdspo/ezIpdOTI+xV+SYmUhUMP0h+xKQMShWlC
        yglZMVyIo4W08IEPa6BXIc/D03BiE72dvAA==
X-Received: by 2002:a2e:b748:: with SMTP id k8mr19746547ljo.358.1635173844750;
        Mon, 25 Oct 2021 07:57:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyPV1iXk6ZPy6JDSA7CspXLCnSKn2gUvovFsT/UVPNQJTEld8PZuIm3yagDI5m5bjqhQRCirQ==
X-Received: by 2002:a2e:b748:: with SMTP id k8mr19746530ljo.358.1635173844593;
        Mon, 25 Oct 2021 07:57:24 -0700 (PDT)
Received: from [192.168.3.161] (89-77-68-124.dynamic.chello.pl. [89.77.68.124])
        by smtp.gmail.com with ESMTPSA id t21sm1671143lfe.202.2021.10.25.07.57.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 07:57:24 -0700 (PDT)
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
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: Re: [syzbot] INFO: task hung in port100_probe
Message-ID: <7d26fa0f-3a45-cefc-fd83-e8979ba6107c@canonical.com>
Date:   Mon, 25 Oct 2021 16:57:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211020220503.GB1140001@rowland.harvard.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/10/2021 00:05, Alan Stern wrote:
>>
>> The syzkaller reproducer fails if >1 of threads are running these usb
>> gadgets.  When this happens, no "in_urb" completion happens. No this
>> "ack" port100_recv_ack().
>>
>> I added some debugs and simply dummy_hcd dummy_timer() is woken up on
>> enqueuing in_urb and then is looping crazy on a previous URB (some older
>> URB, coming from before port100 driver probe started). The dummy_timer()
>> loop never reaches the second "in_urb" to process it, I think.
> 
> Is there any way you can track down what's happening in that crazy loop?  
> That is, what driver was responsible for the previous URB?
> 
> We have seen this sort of thing before, where a driver submits an URB 
> for a gadget which has disconnected.  The URB fails with -EPROTO status 
> but the URB's completion handler does an automatic resubmit.  That can 
> lead to a very tight loop with dummy-hcd, and it could easily prevent 
> some other important processing from occurring.  The simple solution is 
> to prevent the driver from resubmitting when the completion status is 
> -EPROTO.

Hi Alan,

Thanks for the reply.

The URB which causes crazy loop is the port100 driver second URB, the
one called ack or in_urb.

The flow is:
1. probe()
2. port100_get_command_type_mask()
3. port100_send_cmd_async()
4. port100_send_frame_async()
5. usb_submit_urb(dev->out_urb)
   The call succeeds, the dummy_hcd picks it up and immediately ends the
timer-loop with -EPROTO

The completion here does not resubmit another/same URB. I checked this
carefully and I hope I did not miss anything.

6. port100_submit_urb_for_ack() which sends the in_urb:
   usb_submit_urb(dev->in_urb)
... wait for completion
... dummy_hcd loops on this URB around line 2000:
if (status == -EINPROGRESS)
  continue

Best regards,
Krzysztof
