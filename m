Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE7B242957
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 14:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727971AbgHLMcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 08:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726846AbgHLMcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 08:32:09 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18BF6C06174A;
        Wed, 12 Aug 2020 05:32:09 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id l204so1651127oib.3;
        Wed, 12 Aug 2020 05:32:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rVoACvL3vbhn7Hy+rg7NvJC/rRz4OGAEG/IOuYVfJLk=;
        b=YkqGfxOvN96eGolDSvt0iCWOvbZZeKLlCAGi8BAH/XmoiSQNEa5synSoNNTH3X5sLJ
         J0XSC09qP/ds7a/R4Q0SSHomSPcp0o15AVV2+lMvLnTd0vBV6RrhGJjKX/x/0SkqiKwV
         0A06fOqNelj9etWPOTYb+YgdV2enu7Fu10STP5iSBmXYnoCAcjjN9WoirJjjmeTuYc3n
         nbzkPOmaEZpF2jhtGMP8FxV8952FOiOMh2n1AUuK375GNKqppbaAbdxZ1DWWt48ETdQL
         u7QVCoEWkBLGQ3/N4TpSYorKV9FXu36SK0GdrESPraE01ZXd8Fjq2XFQXHvDOrZrjyq5
         8LeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rVoACvL3vbhn7Hy+rg7NvJC/rRz4OGAEG/IOuYVfJLk=;
        b=r/p3muA5t+/bqbt39pc1i2xMmpB+2ZkGjm6DzvOlcULL6KPh71FB78Twv/A3aEvKle
         hL4Nok67+mMGFIHa11ltVOJTQOTla3agqr4J9x5RVRJfTQb/YKQukP1fzJvsFEfu+en1
         60o6jLStDdbPAID/QP77KBRsqNkh8l3ZBzrfKDWkwI43SQOtywolwSHFuc5rNgKKIX0e
         T5T0/IJuT8MVZo/s98wWkwLBTBn8soCkLvsvQF/Y3IX3Pa/sU0u8LCp7b2ZbLKCOFJ8L
         AKqUfAHQAYRSuE9ySCEMxHA6Wlvf8B31m8rOEFIWbmIxcM6jFvVXBts17XRSvdSBl3ZR
         u1bw==
X-Gm-Message-State: AOAM533xH2bhmtYBpb8l5r3722b0g1SrE+UjyWwY4TSAN4gCBK4yPIxs
        nuQUN98cak95E2ZNNjctFf1pd545WjuAVCGO5Aw=
X-Google-Smtp-Source: ABdhPJypHP+8lAnojHqsj+HMjv2Kx5qQD1vR1U48FukFJAYIMQIqPx17kRoJyhSS4FcPT0MB5slRlnJYgqYSUKBAAmw=
X-Received: by 2002:a05:6808:4c5:: with SMTP id a5mr7370620oie.175.1597235526662;
 Wed, 12 Aug 2020 05:32:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200716030847.1564131-1-keescook@chromium.org>
 <87h7tpa3hg.fsf@nanos.tec.linutronix.de> <202007301113.45D24C9D@keescook>
 <CAOMdWSJQKHAWY1P297b9koOLd8sVtezEYEyWGtymN1YeY27M6A@mail.gmail.com> <202008111427.D00FCCF@keescook>
In-Reply-To: <202008111427.D00FCCF@keescook>
From:   Allen <allen.lkml@gmail.com>
Date:   Wed, 12 Aug 2020 18:01:55 +0530
Message-ID: <CAOMdWS+nJr+g1c0Kb99Z=HwQjHtH_-NCC9hW-o6xFs4huGKsqQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] Modernize tasklet callback API
To:     Kees Cook <keescook@chromium.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oscar Carter <oscar.carter@gmx.com>,
        Romain Perier <romain.perier@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-usb@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        alsa-devel@alsa-project.org,
        Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kees,

> Was a Coccinelle script used for any of these conversions? I wonder if
> it'd be easier to do a single treewide patch for the more mechanical
> changes.

No, I should have written one. Will do it.

> And, actually, I still think the "prepare" patches should just be
> collapsed into the actual "covert" patches -- there are only a few.

Okay. It's been done and pushed to:
https://github.com/allenpais/tasklets/tree/V4

> After those, yeah, I think getting these sent to their respective
> maintainers is the next step.

 Please look at the above branch, if it looks fine, let me know
if I can add your ACK on the patches.
>
> Sure! I will add it to the tracker. Here's for the refactoring:
> https://github.com/KSPP/linux/issues/30
>
> and here's for the removal:
> https://github.com/KSPP/linux/issues/94
>
> if you can added details/examples of how they should be removed, that'd
> help other folks too, if they wanted to jump in. :)

Sure, Thank you.

- Allen
