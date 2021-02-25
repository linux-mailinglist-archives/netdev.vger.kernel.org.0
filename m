Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC36324801
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 01:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235871AbhBYApt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 19:45:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234294AbhBYApr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 19:45:47 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F20FC061574
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 16:45:07 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id m9so3730610ybk.8
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 16:45:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GbKeEzz4lVWERO2vPbTbjokE6+q5AP/TQ05munt+HIM=;
        b=n60Cr3rtgqXWyArVzD46+wJJu6FMwwwxHOIDpFhENqq+vQmKfWnIAQSrcNj0RtQcX1
         FYq0Jdl1v6FUEKNZKOSlIy/y+by11L8xpuESTUHWj8YNYdy97y7xxMz1U/AewuNm/bLo
         zzZ5Y4nDeXAcOPiG989lCQ7vhMDfMY0ILR9wxzm5f2JkxwcLHR0LmwJzVX05MxPBqmsZ
         W6Ib99TSpT5VzbJu2b5IV3wTX2Aa1wThoWscSvU/0fW/a005quUxON3lL0sN01GPbLeP
         Q5S0g51omLLpFRcy4bnlCMXyeV4nh44SKavNzlj8qE0dkpskS9nAkiCrc5pWnQC/gS32
         /2fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GbKeEzz4lVWERO2vPbTbjokE6+q5AP/TQ05munt+HIM=;
        b=CrOphG2anjCdmeEMxPXBQHolfceTxtckge9Zh62yeLUhz/8PHqbqfRe4gYCMYhkFdG
         RL0cAcSjAEdY1LNcguRHjb5BR8LckyslKrcC7egMFbf15n6SyJZxFS1PtaghrA95DDoZ
         9xkSb87mvMkbzJSYZ4kBDJNLV6cmArBLKKBfk1M+diyExBnS9aVwt53t61dZExyuvscj
         OE0/SH/Qf8oUF6YbJHaCqhuSc5aXdNDTVOkgtT1FZtubRKKBEo66KebR+c89sUXH8ItD
         APkGgc4r5huHSInz1UAwcQ46H1kieX6PUXqA6vx4+UmDhyu/zmtmFforBIjCy7KcWWT3
         fW2g==
X-Gm-Message-State: AOAM531wW20gDnp+jI/zWYYybsYNUi/6QY//F2FhRwDGDWHBMQvebuCT
        iPb3MD7jnhNPMFA8q/nz2Ca1YxrTSNCT355WyaiXTw==
X-Google-Smtp-Source: ABdhPJzUG3LgFrttofPm13/YMjZ4fkdU98e16+Wvj3JkwUPkfJMfgXpKFbv7hV6kPEuY2Wd5tHg/2G9h+uZa4401xu0=
X-Received: by 2002:a25:d016:: with SMTP id h22mr470698ybg.278.1614213906288;
 Wed, 24 Feb 2021 16:45:06 -0800 (PST)
MIME-Version: 1.0
References: <20210223234130.437831-1-weiwan@google.com> <20210224114851.436d0065@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89i+jO-ym4kpLD3NaeCKZL_sUiub=2VP574YgC-aVvVyTMw@mail.gmail.com>
 <20210224133032.4227a60c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89i+xGsMpRfPwZK281jyfum_1fhTNFXq7Z8HOww9H1BHmiw@mail.gmail.com>
 <20210224155237.221dd0c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89iKYLTbQB7K8bFouaGFfeiVo00-TEqsdM10t7Tr94O_tuA@mail.gmail.com>
 <20210224160723.4786a256@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BN8PR15MB2787694425A1369CA563FCFFBD9E9@BN8PR15MB2787.namprd15.prod.outlook.com>
 <CAEA6p_BGgazFPRf-wMkBukwk4nzXiXoDVEwWp+Fp7A5OtuMjQA@mail.gmail.com> <20210224163257.7c96fb74@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210224163257.7c96fb74@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Wei Wang <weiwan@google.com>
Date:   Wed, 24 Feb 2021 16:44:55 -0800
Message-ID: <CAEA6p_Cp-Q4BRr_Ohd7ee7NchQBB37+vgBrauZQJLtGzgcqZWw@mail.gmail.com>
Subject: Re: [PATCH net] net: fix race between napi kthread mode and busy poll
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Duyck <alexanderduyck@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Martin Zaharinov <micron10@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 24, 2021 at 4:33 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 24 Feb 2021 16:16:58 -0800 Wei Wang wrote:
> > On Wed, Feb 24, 2021 at 4:11 PM Alexander Duyck <alexanderduyck@fb.com> wrote:
> > >
> > > The problem with adding a bit for SCHED_THREADED is that you would
> > > have to heavily modify napi_schedule_prep so that it would add the
> > > bit. That is the reason for going with adding the bit to the busy
> > > poll logic because it added no additional overhead. Adding another
> > > atomic bit setting operation or heavily modifying the existing one
> > > would add considerable overhead as it is either adding a
> > > complicated conditional check to all NAPI calls, or adding an
> > > atomic operation to the path for the threaded NAPI.
> >
> > Please help hold on to the patch for now. I think Martin is still
> > seeing issues on his setup even with this patch applied. I have not
> > yet figured out why. But I think we should not merge this patch until
> > the issue is cleared. Will update this thread with progress.
>
> If I'm looking right __busy_poll_stop() is only called if the last
> napi poll used to re-enable IRQs consumed full budget. You need to
> clear your new bit in busy_poll_stop(), not in __busy_poll_stop().
> That will fix the case when hand off back to the normal poller (sirq,
> or thread) happens without going thru __napi_schedule().

If the budget is not fully consumed, napi_complete_done() should have
been called by the driver which will clear SCHED_BUSY_POLL bit.
