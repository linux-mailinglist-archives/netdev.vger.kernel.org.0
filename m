Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F357229166A
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 10:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbgJRIU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 04:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725287AbgJRIUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Oct 2020 04:20:50 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E76FC061755;
        Sun, 18 Oct 2020 01:20:50 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id v19so7095452edx.9;
        Sun, 18 Oct 2020 01:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pnoN37y74vI+l7td6UtNnddAfGU0MfrZAXH4fSbr8qQ=;
        b=jFi+YppWjc4EBw7LmQYanJchQnc+SeSrIrNi6HQeUSRqMm06vtB2Rh53kqoSWSUN4D
         50mCoU9L6f97Zz+DPBPtPmpSMc05K3mJO5CvnOJOO2N9fJmC7ZAodOx6IF1NyDC/n4PY
         x/P77moJ8aqYYfD5vC20K3ZnBFQh5aKG2IsHTsFz3ENJMSksCtx57XMvZMVR1ETMzwZx
         My1cwT7f8bLyzdf/bxxe4gNtXTBnHp2WSdtExfnnMC7Xxjw9LRJzv/wEDsf/dukUCeCC
         Y8EU69k78mWS470HGNWGpkfhgYEKW76oVGH81cL3pKpkNQ5uQsRfTS7ZX++mOXnA5F9Y
         UAlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pnoN37y74vI+l7td6UtNnddAfGU0MfrZAXH4fSbr8qQ=;
        b=XMDhlknVZ8jYiAn+D+3cYb8Rsxyk34QmrwOZZnIxJ3q0l8Yi8mZOsB+JVQRqdMWwaM
         PjFr1K1Ltinf8dWhPQngA0GUp6q0y4s31oXa6g5xVBbwZSzJE05c3+yQtFxJ2jpqAQM5
         Gi0f3HMT1/xsDDHkEtFXA+wYGOvdCy8NL9clhmuOsqFmTTZTkEZdhx1COz2Te5mVUizZ
         PFsH1e8FAfKNClT2DL9//uAUMJI+4LxRPU2mZqBU3wcR4QKfrH09fjPvkladumclS2Yn
         c3h1KB77D34h/hiq5Vhs9hPD3HbgI3NQRfVmLLZQvDXKfII8s3+za5+R3a24S90yEFVY
         wZyw==
X-Gm-Message-State: AOAM533/EvAfsHfoqGWwIRyjgUTEkyo2OJc0qpmoPufqvTPphyAF4cKn
        80/++ZAx3Cdjt1dX1UpbCd9K/c2efxk=
X-Google-Smtp-Source: ABdhPJx3r2Ij3b1lcOBljxh7oOBy446ITWZfXziqtq5mO9yM3fq41K7Lfmm7ucIJJl0UE4Z/PPGlDw==
X-Received: by 2002:a05:6402:2214:: with SMTP id cq20mr12286914edb.311.1603009247167;
        Sun, 18 Oct 2020 01:20:47 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:2800:8821:97f2:24b4:2f18? (p200300ea8f232800882197f224b42f18.dip0.t-ipconnect.de. [2003:ea:8f23:2800:8821:97f2:24b4:2f18])
        by smtp.googlemail.com with ESMTPSA id i5sm6757414ejs.121.2020.10.18.01.20.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Oct 2020 01:20:46 -0700 (PDT)
Subject: Re: Remove __napi_schedule_irqoff?
To:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <01af7f4f-bd05-b93e-57ad-c2e9b8726e90@gmail.com>
 <20201017162949.0a6dd37a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89i+q=q_LNDzE23y74Codh5EY0HHi_tROsEL2yJAdRjh-vQ@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <668a1291-e7f0-ef71-c921-e173d4767a14@gmail.com>
Date:   Sun, 18 Oct 2020 10:20:41 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <CANn89i+q=q_LNDzE23y74Codh5EY0HHi_tROsEL2yJAdRjh-vQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.10.2020 10:02, Eric Dumazet wrote:
> On Sun, Oct 18, 2020 at 1:29 AM Jakub Kicinski <kuba@kernel.org> wrote:
>>
>> On Sat, 17 Oct 2020 15:45:57 +0200 Heiner Kallweit wrote:
>>> When __napi_schedule_irqoff was added with bc9ad166e38a
>>> ("net: introduce napi_schedule_irqoff()") the commit message stated:
>>> "Many NIC drivers can use it from their hard IRQ handler instead of
>>> generic variant."
>>
>> Eric, do you think it still matters? Does it matter on x86?
>>
>>> It turned out that this most of the time isn't safe in certain
>>> configurations:
>>> - if CONFIG_PREEMPT_RT is set
>>> - if command line parameter threadirqs is set
>>>
>>> Having said that drivers are being switched back to __napi_schedule(),
>>> see e.g. patch in [0] and related discussion. I thought about a
>>> __napi_schedule version checking dynamically whether interrupts are
>>> disabled. But checking e.g. variable force_irqthreads also comes at
>>> a cost, so that we may not see a benefit compared to calling
>>> local_irq_save/local_irq_restore.
>>>
>>> If more or less all users have to switch back, then the question is
>>> whether we should remove __napi_schedule_irqoff.
>>> Instead of touching all users we could make  __napi_schedule_irqoff
>>> an alias for __napi_schedule for now.
>>>
>>> [0] https://lkml.org/lkml/2020/10/8/706
>>
>> We're effectively calling raise_softirq_irqoff() from IRQ handlers,
>> with force_irqthreads == true that's no longer legal.
>>
>> Thomas - is the expectation that IRQ handlers never assume they have
>> IRQs disabled going forward? We don't have any performance numbers
>> but if I'm reading Agner's tables right POPF is 18 cycles on Broadwell.
>> Is PUSHF/POPF too cheap to bother?
>>
>> Otherwise a non-solution could be to make IRQ_FORCED_THREADING
>> configurable.
> 
> I have to say I do not understand why we want to defer to a thread the
> hard IRQ that we use in NAPI model.
> 
Seems like the current forced threading comes with the big hammer and
thread-ifies all hard irq's. To avoid this all NAPI network drivers
would have to request the interrupt with IRQF_NO_THREAD.

> Whole point of NAPI was to keep hard irq handler very short.
> 
> We should focus on transferring the NAPI work (potentially disrupting
> ) to a thread context, instead of the very minor hard irq trigger.
> 

