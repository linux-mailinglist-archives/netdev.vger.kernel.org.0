Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7B268C9D8
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 23:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjBFW4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 17:56:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjBFW4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 17:56:08 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 716DF279B1
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 14:56:04 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id cr11so9518940pfb.1
        for <netdev@vger.kernel.org>; Mon, 06 Feb 2023 14:56:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9t4NU594cNajFbcn/vwZWjR2ZQ3GUkpZaMLOeIVW+g8=;
        b=XUQ0Nf7uWVrYXRo3U/RhLapG4L50FFy0SV9lMz38aXubWeIAwUjYI0FQstvGGlnSUH
         L7FEz2jb3mfi4pHgicuXWW4uoeocqTzsIIyf1Sl8oYhhCiNK9f64tfhC+ZdD5ZU1iJ1D
         1WDI1vVWX/Qa1rc21A3wIitU9On07p40b5ZR2qPEHjdeorfw8IFxWs2tPPY22rNmVC9l
         lqQnHX1dVCNy9oFozCi6O0jci3jizqm7VMDscCUu6jV+K0W/dWOLP0XkDd/FR2VlJaCh
         kI/KwWRaN3XReJeOsvwRQjy9nOw1RiV3ws9uLJUK+GDNV/aNt9adaQ+QKEz9rqk4B17e
         7eKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9t4NU594cNajFbcn/vwZWjR2ZQ3GUkpZaMLOeIVW+g8=;
        b=mkMI3C1aq4vzKwyhIGKSGw1DUHv8DlKYEJls1o+NpuamGV8cWFxtRIG8kKoDU314r3
         QIghqGM7Ujk+TyI0fnBbFS1nC0Pma53NqaZhHprC2cLvSZufRdzQcs5Bl6s3B1qDJVmW
         GwEUEM8nQD5T0Njwt+GodYA0R037v4HJIEX8XClg30bRz3N5LNisctRVnZb0wo5w6KBB
         kREurNUHzRcj8X1inuENmVfN8rZQsKgbRhhE+O0U59RQ8ntr3qnHYxkQHyreSo69STYL
         Y6bxKKJ0/GN7mXx8AgdlfwGMcueSXw6lsRdg+tdHGgIgen2R/NigYlJ/K4R+Cj6EU6HQ
         fb0g==
X-Gm-Message-State: AO0yUKUYIh+7Cf3ogXpn1uDS4iI2EtsRBnpJgXhTHIgILZ8ut8qD/IOv
        vsp23Ch23f2I1KCwxx8BJGynOQ==
X-Google-Smtp-Source: AK7set8lFLUIT5ufp8fOYPvR+ZqwS40zEqoP+gKFln+6rEIvvsaed17aXXBLUqT5dT1im3/x4tvihQ==
X-Received: by 2002:a62:8288:0:b0:582:d97d:debc with SMTP id w130-20020a628288000000b00582d97ddebcmr1107208pfd.3.1675724163392;
        Mon, 06 Feb 2023 14:56:03 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id j14-20020aa783ce000000b0059250c374cesm196239pfn.115.2023.02.06.14.56.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Feb 2023 14:56:02 -0800 (PST)
Message-ID: <68954e9a-00fc-8313-b76a-e1d336c84909@kernel.dk>
Date:   Mon, 6 Feb 2023 15:56:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2] 9p/client: don't assume signal_pending() clears on
 recalc_sigpending()
Content-Language: en-US
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Christian Schoenebeck <linux_oss@crudebyte.com>,
        Eric Van Hensbergen <ericvh@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Pengfei Xu <pengfei.xu@intel.com>,
        v9fs-developer@lists.sourceforge.net
References: <9422b998-5bab-85cc-5416-3bb5cf6dd853@kernel.dk>
 <Y99+yzngN/8tJKUq@codewreck.org>
 <ad133b58-9bc1-4da9-73a2-957512e3e162@kernel.dk>
 <Y+F0KrAmOuoJcVt/@codewreck.org>
 <00a0809e-7b47-c43c-3a13-a84cd692f514@kernel.dk>
 <Y+F/YSjhcQax1bMm@codewreck.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Y+F/YSjhcQax1bMm@codewreck.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/6/23 3:29?PM, Dominique Martinet wrote:
>>> Hm, schedule_delayed_work on the last fput, ok.
>>> I was wondering what it had to do with the current 9p thread, but since
>>> it's not scheduled on a particular cpu it can pick another cpu to wake
>>> up, that makes sense -- although conceptually it feels rather bad to
>>> interrupt a remote IO because of a local task that can be done later;
>>> e.g. between having the fput wait a bit, or cancel a slow operation like
>>> a 1MB write, I'd rather make the fput wait.
>>> Do you know why that signal/interrupt is needed in the first place?
>>
>> It's needed if the task is currently sleeping in the kernel, to abort a
>> sleeping loop. The task_work may contain actions that will result in the
>> sleep loop being satisfied and hence ending, which means it needs to be
>> processed. That's my worry with the check-and-clear, then reset state
>> solution.
> 
> I see, sleeping loop might not wake up until the signal is handled, but
> it won't handle it if we don't get out.

Exactly

> Not bailing out on sigkill is bad enough but that's possibly much worse
> indeed... And that also means the busy loop isn't any better, I was
> wondering how it was noticed if it was just a few busy checks but in
> that case just temporarily clearing the flag won't get out either,
> that's not even a workaround.
> 
> I assume that also explains why it wants that task, and cannot just run
> from the idle context-- it's not just any worker task, it's in the
> process context? (sorry for using you as a rubber duck...)

Right, it needs to run in the context of the right task. So we can't
just punt it out-of-line to something else, whihc would obviously also
solve that dependency loop.

>>> I'll setup some uring IO on 9p and see if I can produce these.
>>
>> I'm attaching a test case. I don't think it's particularly useful, but
>> it does nicely demonstrate the infinite loop that 9p gets into if
>> there's task_work pending.
> 
> Thanks, that helps!
> I might not have time until weekend but I'll definitely look at it.

Sounds good, thanks! I'll consider my patch abandoned and wait for what
you have.

-- 
Jens Axboe

