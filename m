Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF2E325A9F
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 01:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbhBZARW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 19:17:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbhBZARN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 19:17:13 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB1FC061574
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 16:16:33 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id f4so7216117ybk.11
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 16:16:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GMjXnbMyTo34eaRY8BuU6PC05P+RpgViUO6Y/CpH8f0=;
        b=JGsnhiKixOrveZlCcQXxXEBYmuY+zjnXlTFJEhjdyyWFsK0Z23RuhHOxsYcsHWmciM
         sEMdBI0WKyVO358eRU/WaC/SdxoVSpj+Q6buFT8mk0ps5J/dtMAp0LFzvaZXBBI7RGCF
         HfggpcWJVFD3D/K4McK1V6wPSjNLBrmLOLqjrJy798Vr3P+IvOS0CmfLhG/hQq8v8VN2
         HSZ3d/FNrUHFjD2ygr3qz/wTIjuDSiMn++s50Nq/OuK40WmQODDUOYhZWAs9DL3tBz7W
         qZHrMbocPBlogVBRM7l34oW81PneuUzUUTMAXGTUHQ7IhP/XUDuBFYIfZeXtW8n2kXw/
         GXGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GMjXnbMyTo34eaRY8BuU6PC05P+RpgViUO6Y/CpH8f0=;
        b=Lx3YNFFq+dEh0BU44m8c0PagFGGoJnSn3qhXuXK1JE8uDAI9ZsHgohK2RgdyL1pXCO
         72QS17zFaOy7G3DH/zo9w4OPFtsEI3z0tHfeaTrdakGhmPEcdHV2SKxHCR7NGDBNAbG6
         AFt6mWcYwwNgXQCY6g7C77rEtvN8JFqhhasuVKW+ygvp4zRz3vqRqU8rrFCxoyH2235h
         2SeLuh3OMowTiLd9MZBWNyhFtgCQAyEKp+DymgM2i8JcKP6awue1kcfxtMatu45dEy1G
         NmaO1LqMGD+mmcngaSyj4BvtgHj8W0qQPfMQBgTetHA1pLCnrAT/wzNYa9cwxdR+CKB9
         xqpg==
X-Gm-Message-State: AOAM531m7HhQlyClhPFtlNeJXM6ODjk85CVX2b307B5hf8onZvUIpTh1
        YdXYxP3xmxJazCTVcHzBr5H0JLpvzLhWTb46YFWSNg==
X-Google-Smtp-Source: ABdhPJx6bv/RQIZptNDfje2xxGwfrX75blZo6s/RiBet2MU/Jd1P7iCP95pw0IbaC5NOF7MMxRN2inNF5L69nSAzjEA=
X-Received: by 2002:a25:3b92:: with SMTP id i140mr712341yba.187.1614298592139;
 Thu, 25 Feb 2021 16:16:32 -0800 (PST)
MIME-Version: 1.0
References: <20210223234130.437831-1-weiwan@google.com> <20210224133032.4227a60c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89i+xGsMpRfPwZK281jyfum_1fhTNFXq7Z8HOww9H1BHmiw@mail.gmail.com>
 <20210224155237.221dd0c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89iKYLTbQB7K8bFouaGFfeiVo00-TEqsdM10t7Tr94O_tuA@mail.gmail.com>
 <20210224160723.4786a256@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BN8PR15MB2787694425A1369CA563FCFFBD9E9@BN8PR15MB2787.namprd15.prod.outlook.com>
 <20210224162059.7949b4e1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BN8PR15MB27873FF52B109480173366B8BD9E9@BN8PR15MB2787.namprd15.prod.outlook.com>
 <20210224180329.306b2207@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAEA6p_CEz-CaK_rCyGzRA8=WNspu2Uia5UasJ266f=p5uiqYkw@mail.gmail.com>
 <20210225002115.5f6215d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAEA6p_DdccvmymRWEtggHgqb9dQ6NjK8rsrA03HH+r7mzt=5uw@mail.gmail.com> <20210225150048.23ed87c9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210225150048.23ed87c9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Wei Wang <weiwan@google.com>
Date:   Thu, 25 Feb 2021 16:16:20 -0800
Message-ID: <CAEA6p_DnoQ8OLm731burXB58d9PfSPNU7_MvbeX_Ly1Grk2XbA@mail.gmail.com>
Subject: Re: [PATCH net] net: fix race between napi kthread mode and busy poll
To:     Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Martin Zaharinov <micron10@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 25, 2021 at 3:00 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 25 Feb 2021 10:29:47 -0800 Wei Wang wrote:
> > Hmm... I don't think the above patch would work. Consider a situation that:
> > 1. At first, the kthread is in sleep mode.
> > 2. Then someone calls napi_schedule() to schedule work on this napi.
> > So ____napi_schedule() is called. But at this moment, the kthread is
> > not yet in RUNNING state. So this function does not set SCHED_THREAD
> > bit.
> > 3. Then wake_up_process() is called to wake up the thread.
> > 4. Then napi_threaded_poll() calls napi_thread_wait().
>
> But how is the task not in running state outside of napi_thread_wait()?
>
> My scheduler knowledge is rudimentary, but AFAIU off CPU tasks which
> were not put to sleep are still in RUNNING state, so unless we set
> INTERRUPTIBLE the task will be running, even if it's stuck in cond_resched().
>

I think the thread is only in RUNNING state after wake_up_process() is
called on the thread in ____napi_schedule(). Before that, it should be
in INTERRUPTIBLE state. napi_thread_wait() explicitly calls
set_current_state(TASK_INTERRUPTIBLE) when it finishes 1 round of
polling.

> > woken is false
> > and SCHED_THREAD bit is not set. So the kthread will go to sleep again
> > (in INTERRUPTIBLE mode) when schedule() is called, and waits to be
> > woken up by the next napi_schedule().
> > That will introduce arbitrary delay for the napi->poll() to be called.
> > Isn't it? Please enlighten me if I did not understand it correctly.
>
> Probably just me not understanding the scheduler :)
>
> > I personally prefer to directly set SCHED_THREAD bit in ____napi_schedule().
> > Or stick with SCHED_BUSY_POLL solution and replace kthread_run() with
> > kthread_create().
>
> Well, I'm fine with that too, no point arguing further if I'm not
> convincing anyone. But we need a fix which fixes the issue completely,
> not just one of three incarnations.

Alexander and Eric,
Do you guys have preference on which approach to take?
If we keep the current SCHED_BUSY_POLL patch, I think we need to
change kthread_run() to kthread_create() to address the warning Martin
reported.
Or if we choose to set SCHED_THREADED, we could keep kthread_run().
But there is 1 extra set_bit() operation.

Thanks.
Wei
