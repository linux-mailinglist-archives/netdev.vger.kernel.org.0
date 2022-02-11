Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD734B1DF6
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 06:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234272AbiBKFk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 00:40:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234217AbiBKFk6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 00:40:58 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82541264F
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 21:40:57 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id y17so3807327plg.7
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 21:40:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j0dCN06UtIvvo0LKZgjVcQl8BpTQYXX0PdZxGcDR1jM=;
        b=D14kD3+Odpgdjkg/ho4bBJRDLBBqzwk6G57wcT5bWNZujMD8hjG/FkdUNYyx0zG0jS
         p8ZbtRHzAFUl/4qw1EVxdggjRStdfYPKgL/PmI8EfbXYlu7fjmV+bjM2PgQXYSgKMzwd
         kD6ufOedvie/ByHydXaqS0SIGmfjDFQFtmzloiqgcqjthvXVSTLOnJhhQ9kW/9L4vymr
         H6vpGrBdeGCsNEg3FMvpsYNy7yYToAulga+XuzefcMbwKKVrl8dlX6ysJXiKYHHVs0ks
         mZd7vVv/L3J/4QBZbJepOMI68mcjbriDHX+ZKFpYNaE2gfH4F5S5EynabizJcgMUz3KC
         Vscg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j0dCN06UtIvvo0LKZgjVcQl8BpTQYXX0PdZxGcDR1jM=;
        b=MDhG5sIMpZmBWrDjQ2T9hNs+DnPlZ1QxfWo5ZOaAxkLJVP+RK1EFX9jQRX4nSaiqA6
         9VtsafKUYNtZg+xsCN/TG9H4bBsAFViq45PSBYs2YPlFhuxictJxMO2skyiDxYyMdqjH
         /k4YsYpKmu72aQaQTItt/ipC0hYyC/YMZ8vCOqcKN6jqE75kAeVgovTe63cAaSqXqP6X
         MmM0udhmfRW50IgHeWKi+y49iSjVkS8xZgr6VfvooDD+0869dLr5g0tDeaviihKFtOCt
         +LlHR1O1lsFTPzFco5qDpZymEy9lHVXKVUEza82XvvpnWp6NtD871ky5vtmhYIfTgkYi
         /l8A==
X-Gm-Message-State: AOAM5321zCPOHrd8Tx2LF6kNq4f0scM9CTHeeWGzPY1TX14LXJuw5O51
        uN1ILHhFIuQcacbetygosGnLfDbmQrxktcNt3WE2YAHVMdMZ7fMp
X-Google-Smtp-Source: ABdhPJz0u0o/BjtLpAIXw+pzSg1ZCBCgdSeDgY1vXpnKKU9ndhyTCnFVTnYwuSmHma6KJPcPUURupEogkGtMIzSh4os=
X-Received: by 2002:a17:902:cec5:: with SMTP id d5mr153832plg.143.1644558056896;
 Thu, 10 Feb 2022 21:40:56 -0800 (PST)
MIME-Version: 1.0
References: <CAJq09z5FCgG-+jVT7uxh1a-0CiiFsoKoHYsAWJtiKwv7LXKofQ@mail.gmail.com>
 <878rukib4f.fsf@bang-olufsen.dk> <CAJq09z71Fi8rLkQUPR=Ov6e_99jDujjKBfvBSZW0M+gTWK-ToA@mail.gmail.com>
 <CAJq09z6W+yYAaDcNC1BQEYKdQUuHvp4=vmhyW0hqbbQUzo516w@mail.gmail.com>
 <87h797gmv9.fsf@bang-olufsen.dk> <87o83eg170.fsf@bang-olufsen.dk>
In-Reply-To: <87o83eg170.fsf@bang-olufsen.dk>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Fri, 11 Feb 2022 02:40:45 -0300
Message-ID: <CAJq09z5g+LfUPRJOoCXfdY89yZpH_4X=A0r1CPXd3Sihp7Sivw@mail.gmail.com>
Subject: Re: net: dsa: realtek: silent indirect reg read failures on SMP
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi again Luiz,

Hello,

> >>
> >> Sorry but I believe my non-SMP device is not "affected enough" to help
> >> debug this issue. Is your device SMP?
> >
> > Yes, it's SMP and also with PREEMPT_RT ;-)
> >
> > But no problem, I will look into this and get back to you in this thread
> > if I need any more feedback. Thanks for your help.
>
> So I had a closer look this afternoon. First some general statements.
>
> 1. Generally the switch driver is not accessing registers unless an
>    administrator is reconfiguring the interfaces
> 2. The exception to the above rule is the delayed_work for stats64,
>    which you can see in the code is there because get_stats64 runs in
>    atomic context. This runs every 3 seconds.
> 3. Without the interrupt from the switch enabled, the PHY subsystem
>    resorts to polling the PHY registers (every 1 second I think you
>    said).
>
> As a result of (2) and (3) above, you are bound at some point to have
> both the stats work and the PHY register read callbacks executing in
> parallel. As I mentioned in my last email, a simple busy loop with
> phytool would return some nonsense pretty quickly. On my SMP/PREEMPT_RT
> system this happens every 3 seconds while everything else is idle.
>
> I tried to disable the stats delayed_work just to see, and in this case
> I did not observe any PHY read issues. The PHY register value was always
> as expected.
>
> In that setup I then tried to provoke the error again, this time by
> reading a single register with dd via regmap debugfs. And while it's
> unlikely for a single such read to interfere with my busy phytool loop,
> putting the dd read in a tight loop almost immediately provokes the same
> bug. This time I noticed that the value returned by phytool is the same
> value that I read out with dd from the other non-PHY-related register.
>
> In general what I found is that if we read from an arbitrary register A
> and this read coincides with the multi-register access in
> rtl8365mb_phy_ocp_read, then the final read from
> RTL8365MB_INDIRECT_ACCESS_READ_DATA_REG will always return the value in
> register A. It is quite reliably the case in all my testing, and it
> explains the nonsense values we sometimes happened to see during PHY
> register access, because of the stats work going on in the
> background. Probably we got some MIB counter data and this corrupted the
> PHY register value held in the INDIRECT_ACCESS_READ_DATA_REG register.

It makes sense. That explains why a simple lock over indirect access
did not solve the issue.

> I am not sure why this happens - likely some peculiarity of the ASIC
> hardware - but I wanted to check if this is also the case for the MIB
> register access, because we also have a kind of indirect lookup
> algorithm there. But in that case I did not see any corruption of the
> data in the MIB counter data registers (RTL8365MB_MIB_COUNTER_REG(_x)).
>
> So my conclusion is that this problem is unique to the indirect PHY
> register access pattern. It should be pointed out that the regmap is
> already protected by a lock, so I don't expect to see any weird data
> races for non-PHY register access.
>
>
> One more thing I wanted to point out: you mentioned that on your system
> you conducted multiple phytool read loops and did not observe any
> issues. I think this is easily explained by some higher-level locking
> in the kernel which prevents concurrent PHY register reads.
>
> ****
>
> With all of that said, I think the solution here is simply to guard
> against stray register access while we are in the indirect PHY register
> access callbacks. You also posted a patch to forego the whole indirect
> access method for MDIO-connected switches, and I think that is also a
> good thing. My reply to that patch was just taking issue with your
> explanation, both because the diagnosis of the bug was rather nebulous,
> and also because it did not actually fix the bug - it just worked around
> it.
>
> I will take it upon myself to fix this issue of indirect PHY register
> access yielding corrupt values and post a patch to the list next week.
> I already have a quick-n-dirty change which ensures proper locking and
> now I cannot reproduce the issue for several hours.

I tried to find a way to lock regmap while permitting it to be used
only by the indirect reg access.
However, I failed to find a clean solution. It's great you got a proper fix.

> In the mean time, could you resend your MDIO direct-PHY-register-access
> patch and I will give it one more review. Please do not suggest that it
> is a fix for this bug (because it's not) -- better yet, just add a Link:
> to this thread and explain why you bothered implementing it to begin
> with. You can mention that the issue is not seen with direct-access
> (which also corroborates our findings here). Then I will base my changes
> on your patch.
>
> Alternatively you can drop the patch and we can just fix the indirect
> access wholesale - both for SMI and MDIO. That would mean adding less
> code (since MDIO with indirect access also works), albeit at the expense
> of some technically unnecessary gymnastics in the driver (since MDIO
> direct access is simpler). But I'll leave that up to you :-)
>
> What do you think?
>

I would prefer to drop it if we get a shared fix. There is an ongoing
discussion that might allow us to drop the realtek-smi internal mdio
and share phy_read/write between both interfaces. In that case, that
different mdio code path will fit much better as an "if" inside those
functions.

> Kind regards,
> Alvin

Regards,
Luiz
