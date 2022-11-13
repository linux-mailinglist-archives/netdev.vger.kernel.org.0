Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC76626E81
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 09:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235225AbiKMIYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 03:24:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbiKMIYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 03:24:31 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 223C9C77C
        for <netdev@vger.kernel.org>; Sun, 13 Nov 2022 00:24:27 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id n20so975437ejh.0
        for <netdev@vger.kernel.org>; Sun, 13 Nov 2022 00:24:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BI9JbOCpuEbBmn9B+EpkLVjudzHQm7JEX1J1MnwlriY=;
        b=F3quGL0Mm0a9bpiwWOalTGSAKk8AGIhS2fvdnNoNRIGU1Hph4XofM5Dieovt/yKzte
         61KaHg8TrIbxuPOQZNgtm1juId2TxAAgHDEWlz9Os33WIqjO1PXFqYkQaIM8lhRVdrjG
         UOoJIepIqyfNQsnSX6JIpZ0hQOKClpOGkgkgfHk2wilcZJ0vxAuvdZzBnb7LcOVXlDaE
         O/7B/FYLrQOyUTOn4s8FQ2nIuY8LgI/YhpYOh2NZOcYQhvkK0a19P8+4pxm8Ug4wXuoV
         AYWpOjMi/neUzTfrvtg5/EaAZxJfQ0H/bH13uMExHWZLAFMj2n+7e5sdfR1bhsB8wKJ5
         WG4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BI9JbOCpuEbBmn9B+EpkLVjudzHQm7JEX1J1MnwlriY=;
        b=MYBezCnjsO7+5tUYZ7bfl20wniIX2nlUKKdJrvMNUlzSCcazA7tIHZ5bpAnPN2Btva
         7Y3KUFiXThG3g5CX+O4IOQjeIYNYBbuZ4DX/p1MuJD1N5adtrinNZa4vxoHJM4XgNzFd
         SfP3Aagqog22lPcBbUz2PVzkxLuulliXzoZUa65mYuHwli70pzb9uDLJnrE9W84d0mDZ
         P4tyiDDDVANAnlozwDrJljhlZU/rTnACYSYytJVuLoF0vlq15iij5QEuyERhgxX7TZ/v
         ledrStt+DVnaW2qr7ZzojahtyqdmKUc0s6TC+YLBN0f3femjcHyoUsc1QwpJPg5LwfoG
         xI7w==
X-Gm-Message-State: ANoB5pkZknPAKfkV+NeHq568YwKQbZ270oWxnrKGmCVYhUowdVuMAVQG
        QtS94SmRodcOhVIJmM9pR286Z5PAhjLFLmFG
X-Google-Smtp-Source: AA0mqf7uz4bxdJi5xmTYqX4VILkqEl98IsthFqhX/hwgwb8PJxYSgQUZfxdqQa+obDAFIhzXoB9f1Q==
X-Received: by 2002:a17:906:3a12:b0:781:b7f2:bce9 with SMTP id z18-20020a1709063a1200b00781b7f2bce9mr7231983eje.269.1668327865384;
        Sun, 13 Nov 2022 00:24:25 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id fj17-20020a1709069c9100b0072a881b21d8sm2746079ejc.119.2022.11.13.00.24.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Nov 2022 00:24:24 -0800 (PST)
Date:   Sun, 13 Nov 2022 09:24:23 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     John Ousterhout <ouster@cs.stanford.edu>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Subject: Re: Upstream Homa?
Message-ID: <Y3Cpt4qB5jMoVDDh@nanopsycho>
References: <CAGXJAmzTGiURc7+Xcr5A09jX3O=VzrnUQMp0K09kkh9GMaDy4A@mail.gmail.com>
 <20221110132540.44c9463c@hermes.local>
 <Y22IDLhefwvjRnGX@lunn.ch>
 <CAGXJAmw=NY17=6TnDh0oV9WTmNkQCe9Q9F3Z=uGjG9x5NKn7TQ@mail.gmail.com>
 <Y26huGkf50zPPCmf@lunn.ch>
 <CAGXJAmzrjKUUDNk0GEvqCNk0SUgtdh=rkDhYSDBogoDyUmr9Tg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXJAmzrjKUUDNk0GEvqCNk0SUgtdh=rkDhYSDBogoDyUmr9Tg@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Nov 13, 2022 at 07:09:48AM CET, ouster@cs.stanford.edu wrote:
>On Fri, Nov 11, 2022 at 11:25 AM Andrew Lunn <andrew@lunn.ch> wrote:
>>
>> On Fri, Nov 11, 2022 at 10:59:58AM -0800, John Ousterhout wrote:
>> > The netlink and 32-bit kernel issues are new for me; I've done some digging to
>> > learn more, but still have some questions.
>> >
>>
>> > * Is the intent that netlink replaces *all* uses of /proc and ioctl? Homa
>> > currently uses ioctls on sockets for I/O (its APIs aren't sockets-compatible).
>> > It looks like switching to netlink would double the number of system calls that
>> > have to be invoked, which would be unfortunate given Homa's goal of getting the
>> > lowest possible latency. It also looks like netlink might be awkward for
>> > dumping large volumes of kernel data to user space (potential for buffer
>> > overflow?).
>>
>> I've not looked at the actually code, i'm making general comments.
>>
>> netlink, like ioctl, is meant for the control plain, not the data
>> plain. Your statistics should be reported via netlink, for
>> example. netlink is used to configure routes, setup bonding, bridges
>> etc. netlink can also dump large volumes of data, it has no problems
>> dumping the full Internet routing table for example.
>>
>> How you get real packet data between the userspace and kernel space is
>> a different question. You say it is not BSD socket compatible. But
>> maybe there is another existing kernel API which will work? Maybe post
>> what your ideal API looks like and why sockets don't work. Eric
>> Dumazet could give you some ideas about what the kernel has which
>> might do what you need. This is the uAPI point that Stephen raised.
>
>OK, will do. I'm in the middle of a major API refactor, so I'll wait
>until that is
>resolved before pursing this issue more.
>
>> > * By "32 bit kernel problems" are you referring to the lack of atomic 64-bit
>> > operations and using the facilities of u64_stats_sync.h, or is there a more
>> > general issue with 64-bit operations?
>>
>> Those helpers do the real work, and should optimise to pretty much
>> nothing on an 64 bit kernel, but do the right thing on 32 bit kernels.
>>
>> But you are right, the general point is that they are not atomic, so
>> you need to be careful with threads, and any access to a 64 bit values
>> needs to be protected somehow, hopefully in a way that is optimised
>> out on 64bit systems.
>
>Is it acceptable to have features that are only supported on 64-bit kernels?

I don't think so. There are plenty 32bit platforms supported, all should
work there.


>This would be my first choice, since I don't think there will be much interest
>in Homa on 32-bit platforms.
>
>If that's not OK, are there any mechanisms available for helping people
>test on 32-bit platforms? For example, is it possible to configure Linux to
>compile in 32-bit mode so I could test that even on a 64-bit machine
>(I don't have access to a 32-bit machine)?

You can do it easily in emulated environment, like qemu.


>
>-John-
