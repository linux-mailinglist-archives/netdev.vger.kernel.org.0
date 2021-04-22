Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22A4D3679F3
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 08:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234885AbhDVGbU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 22 Apr 2021 02:31:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52692 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbhDVGbT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 02:31:19 -0400
Received: from mail-wr1-f71.google.com ([209.85.221.71])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <chia-lin.kao@canonical.com>)
        id 1lZSrM-0004dL-2M
        for netdev@vger.kernel.org; Thu, 22 Apr 2021 06:30:44 +0000
Received: by mail-wr1-f71.google.com with SMTP id 88-20020adf95610000b029010758d8d7e2so1760250wrs.19
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 23:30:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3kzgVjAjXqA0gwr2eY96/OSAGqGr3gZ/6NHtH93TvQg=;
        b=E6nspCrvsE5Z2K0VxCT313DVFTnIsfITLcBasuljX306/GEIGnvlMtlrMbnqko0/Ai
         wK8NHsu463YbqLPP1ddqciy2ZF/L1aYVi2TehQyKQ4p+eBVYCb93gNfjdoZj7oAMCP0Q
         xt/fhYp7uABm2H0YJNWVVIAneb+VcIyP2dAG3+MalF0K0r9NHEcq7Tx/nuHWonqYJtbr
         heff9i1ER1XCd64EaGl3azYfrDU6ASXickCGn+PGlT14c0H/oFzUBqoiFnQC5dT+imx6
         xXxR0VgqM/otpxONbXYjulR+l7itaghty3XqCBB9OKkYx0LMzJcA2Ez9ySaALudLF9Uh
         P29A==
X-Gm-Message-State: AOAM532fWr8QntygiwPKzzCW1L8DugsIa1Na2bRWv8Tawm9otSix65lz
        9jJiQT0p4LNiczFMbqv+cTUPK9zkh4F2+QbaHxcuMO6jD3xL8FsJaKDmCnByQWuwY0Z/eDDbBt4
        0uWVLqot3Z+BqZ5WeSEuyKmM+1bYw39Z5KXKZkCC13wVvRxzViw==
X-Received: by 2002:a05:6000:362:: with SMTP id f2mr2040248wrf.141.1619073043680;
        Wed, 21 Apr 2021 23:30:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzMm37YQsQ4/hlEwqWuIlwD6IKPHsqmYKLABs/OQviK9ixplQD7thz/dQSRJv43omgMMbMvDLU5phYp3mqNLTg=
X-Received: by 2002:a05:6000:362:: with SMTP id f2mr2040231wrf.141.1619073043512;
 Wed, 21 Apr 2021 23:30:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210420075406.64105-1-acelan.kao@canonical.com>
 <CANn89iJLSmtBNoDo8QJ6a0MzsHjdLB0Pf=cs9e4g8Y6-KuFiMQ@mail.gmail.com> <20210420122715.2066b537@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210420122715.2066b537@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   AceLan Kao <acelan.kao@canonical.com>
Date:   Thu, 22 Apr 2021 14:30:32 +0800
Message-ID: <CAFv23Q=ywiuZp7Y=bj=SAZmDdAnanAXA954hdO3GpkjmDo=RpQ@mail.gmail.com>
Subject: Re: [PATCH] net: called rtnl_unlock() before runpm resumes devices
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yes, should add

Fixes: 9474933caf21 ("igb: close/suspend race in netif_device_detach")
and also
Fixes: 9513d2a5dc7f ("igc: Add legacy power management support")

Jakub Kicinski <kuba@kernel.org> 於 2021年4月21日 週三 上午3:27寫道：
>
> On Tue, 20 Apr 2021 10:34:17 +0200 Eric Dumazet wrote:
> > On Tue, Apr 20, 2021 at 9:54 AM AceLan Kao <acelan.kao@canonical.com> wrote:
> > >
> > > From: "Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>
> > >
> > > The rtnl_lock() has been called in rtnetlink_rcv_msg(), and then in
> > > __dev_open() it calls pm_runtime_resume() to resume devices, and in
> > > some devices' resume function(igb_resum,igc_resume) they calls rtnl_lock()
> > > again. That leads to a recursive lock.
> > >
> > > It should leave the devices' resume function to decide if they need to
> > > call rtnl_lock()/rtnl_unlock(), so call rtnl_unlock() before calling
> > > pm_runtime_resume() and then call rtnl_lock() after it in __dev_open().
> > >
> > >
> >
> > Hi Acelan
> >
> > When was the bugg added ?
> > Please add a Fixes: tag
>
> For immediate cause probably:
>
> Fixes: 9474933caf21 ("igb: close/suspend race in netif_device_detach")
>
> > By doing so, you give more chances for reviewers to understand why the
> > fix is not risky,
> > and help stable teams work.
>
> IMO the driver lacks internal locking. Taking rtnl from resume is just
> one example, git history shows many more places that lacked locking and
> got papered over with rtnl here.
