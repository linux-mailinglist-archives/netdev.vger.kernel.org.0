Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8BD93248D7
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 03:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236858AbhBYCRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 21:17:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236842AbhBYCQ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 21:16:56 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8973CC061574
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 18:16:16 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id 133so3907451ybd.5
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 18:16:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=udv0zK3DfQUqKAw2B10PCi4/XYYWnwmH/85OHx9yuP0=;
        b=g5GWppK8M4zpXjHBjisTVPPPQkR7oJmf3U2Gknvw7A5i74pgV4PifzqbPy/MH9lcy4
         bIFDNCHy9ePCizE3RLnVfApdSCIa4cL4gUCTLslRp2oGZUWyAE9oyH1HQsBv8oGTp594
         fqjQaLOLUOUECiPsKCQLSWtDAlvDiuAMzOW7xHA1RiiVu4NiKL275J7Vm+2DnTg0hmm5
         rlw042+23KTbFVA9pJvSFzA1QhfihBW5ejN93Jywpz6i3f6h+rVyRKVcnSZiTbJ1Xepi
         GfQk/0Qr2vW7ynTwzl2XoMEkZTihPrfveW0ZeD+57EMph9dnPyiWZJUQD4c94jtBEUzX
         5X6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=udv0zK3DfQUqKAw2B10PCi4/XYYWnwmH/85OHx9yuP0=;
        b=DsEIZD9c8UwiN5OlsoE0tiJ3Y6HRMPc3UMhzsBOm/PtBsbPeHfLXi5+r0xRAo3yHQl
         H6znwF6jaMRPnlY6avSJHEk26c97wLt9xCxA9kSWkNIA+MgaaKjhFQ1cZ3p66+G9nIdC
         G8/XaKMAT0UzWcJaS7CusnUWtQKmUUoxKuDSHStDjWSwN+zWPJwWuuTibMe/RpXHwYBw
         EsHKJyxAwkC/s8kknfhN70QnTc2LtFqrPQ9AM6yjBPlCQXOJzEYQaHMeNtdZGFF2NNOl
         P8lp48pJFRNQXR1zINrZcdIlDTxzSF0ZO6QXicsIlTudcKvE4dLYzwTkAb5x4J/qSr2R
         WPMg==
X-Gm-Message-State: AOAM530L2aY8UMP8HYwQ7AiNLozJGCKUnqkCIgnSl8RsupLL2EKLK6/A
        TtuXmFLGFfc/ECtWCHCaHGf8nJ5p0x0voy55hr5hYw==
X-Google-Smtp-Source: ABdhPJwtlyWwB3MStlNVaNXgqb/i2UuFpPLDPQ/fARQwxjsBZt6K1nieu5tqTohO9dllRaRBWbpkIvZn5Bq8BgTIIxs=
X-Received: by 2002:a25:d016:: with SMTP id h22mr886025ybg.278.1614219375561;
 Wed, 24 Feb 2021 18:16:15 -0800 (PST)
MIME-Version: 1.0
References: <20210223234130.437831-1-weiwan@google.com> <20210224114851.436d0065@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89i+jO-ym4kpLD3NaeCKZL_sUiub=2VP574YgC-aVvVyTMw@mail.gmail.com>
 <20210224133032.4227a60c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89i+xGsMpRfPwZK281jyfum_1fhTNFXq7Z8HOww9H1BHmiw@mail.gmail.com>
 <20210224155237.221dd0c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89iKYLTbQB7K8bFouaGFfeiVo00-TEqsdM10t7Tr94O_tuA@mail.gmail.com>
 <20210224160723.4786a256@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BN8PR15MB2787694425A1369CA563FCFFBD9E9@BN8PR15MB2787.namprd15.prod.outlook.com>
 <CAEA6p_BGgazFPRf-wMkBukwk4nzXiXoDVEwWp+Fp7A5OtuMjQA@mail.gmail.com>
 <20210224163257.7c96fb74@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAEA6p_Cp-Q4BRr_Ohd7ee7NchQBB37+vgBrauZQJLtGzgcqZWw@mail.gmail.com>
 <20210224164946.2822585d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAEA6p_CN9UzGvLKoX8Y=D49p4N+rgWPWtg0haXJ3T0HP+gJvxA@mail.gmail.com> <20210224174045.77b970cb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210224174045.77b970cb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Wei Wang <weiwan@google.com>
Date:   Wed, 24 Feb 2021 18:16:04 -0800
Message-ID: <CAEA6p_CbHS3xRZaArjxJX0WYZrd_4gfNK01Le4e87NQWc6vy8A@mail.gmail.com>
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

On Wed, Feb 24, 2021 at 5:40 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 24 Feb 2021 17:06:13 -0800 Wei Wang wrote:
> > I really have a hard time reproducing the warning Martin was seeing in
> > his setup. The difference between my setup and his is that mine uses
> > mlx4 driver, while Martin is using ixgbe driver.
> >
> > To keep everyone up to date with Martin's previous email, with this
> > patch applied to 5.11.1, the following warning is triggered when
> > enabling threaded mode without enabling busy poll:
> > echo 1 > /sys/class/net/eth0/threaded
> > echo 1 > /sys/class/net/eth1/threaded
> > echo 1 > /sys/class/net/eth2/threaded
> > echo 1 > /sys/class/net/eth3/threaded
> >
> > Warning message:
> > [...]
> >
> > This is the line in net/core/dev.c:6993
> >  WARN_ON(!list_empty(&napi->poll_list));
> > in napi_threaded wait()
> >
> > Martin, do you think the driver version you are using could be at fault here?
>
> We do kthread_run() meaning the thread gets immediately woken up, even
> when sirq is polling the NAPI and owns it. Right?

Indeed. Good catch! Changing it to kthread_create() should solve the
issue I think. We were using kthread_run() because kthread_create()
messes up certain thread stats if I remember it correctly.
