Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47EBB280F2C
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 10:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbgJBIqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 04:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbgJBIqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 04:46:19 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85C70C0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 01:46:19 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id z13so730960iom.8
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 01:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mV5oCrjYgsy7pP7Rmnz0HCmw3gV3dLtGa7yao12dilE=;
        b=JLD+jfRM4dTkAx3HEHA2TiFMi90Dib9A39laSWzDbOzq6G6zFq9T77aWilezKLO0Y1
         ihENGOQtx13JSPnX/COCBnBmIXtew+F5DYomKD8J5PEAXTUuiKz/DKFl6F/6S7jChmvU
         MA81H7fgpw30L81R37RpOgl9WNKhVMogmbRoIaSrO4CQYbJYOPQMI9QWLceokA17bg2d
         wSEbo1baXE66Ul0wvf7vBGqtis0/KBVx/lwuunNoDkXKRMb0Vgia/JKxLQDxE8RIQj5t
         viOQ7FNgFFYRbjz28UelLsjQFbGTlb7Wc+1mvYY6PL0KeY1hSbh+yDQbB4DspY4JZFsQ
         5+ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mV5oCrjYgsy7pP7Rmnz0HCmw3gV3dLtGa7yao12dilE=;
        b=g8zYmzGH37mrM4X520G43pTRsIXJOWQVZYuy0vemVdaTesBWFVRrKvS0280wNobOjL
         YAOe++2XyhV9Aienrdx9/Dt3jKbXD86NN03jeioEL/n5pWJU1GgtbGvvbcwOHNvKumzQ
         h1Fc6wR9OTROHGpMFv+L0RAUCLPvl3BltTNO0X0MxZpXqynqpOm8g8vXGXd6mXHQI77E
         uYzsM7o7joZS/cIsAs4LUkPhRxgklpvA7aVly+IY0M1ik6uZPmXniAGA0uE9ZBDzmzPh
         fRLaAaLFJv+Ek+E5O4pw3WLa2055V//4Q4ZR1UtUcLjdtvhvPhQmCCg3ydf6EoFlmkHs
         LvVg==
X-Gm-Message-State: AOAM531gSylerQUyyCyqMe+B85HnsU46aAuElVqevk3tQ8+8OywtAiOP
        vMrAg0LOEJJ98WhU4MH0tpf5/ePW1DzDYTcWLHii3Q==
X-Google-Smtp-Source: ABdhPJwgdMY0W3oRHWIN1ixB++Ic6G+bdJjBN2YsGP+mEHCllE2yE2h2+XCvSOc2Z7S9Dq/1FiR/gEf2+LjBN5P10RE=
X-Received: by 2002:a05:6602:2d0c:: with SMTP id c12mr1175621iow.117.1601628378603;
 Fri, 02 Oct 2020 01:46:18 -0700 (PDT)
MIME-Version: 1.0
References: <bug-209423-201211-atteo0d1ZY@https.bugzilla.kernel.org/>
 <80adc922-f667-a1ab-35a6-02bf1acfd5a1@gmail.com> <CANn89i+ZC5y_n_kQTm4WCWZsYaph4E2vtC9k_caE6dkuQrXdPQ@mail.gmail.com>
 <733a6e54-f03c-0076-1bdc-9b0d4ec1038c@gmail.com>
In-Reply-To: <733a6e54-f03c-0076-1bdc-9b0d4ec1038c@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 2 Oct 2020 10:46:07 +0200
Message-ID: <CANn89iJ2zqH=_fvJQ8dhG4nBVnKNB7SjHnHDLv+0iR7UwgxTsw@mail.gmail.com>
Subject: Re: [Bug 209423] WARN_ON_ONCE() at rtl8169_tso_csum_v2()
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 2, 2020 at 10:32 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 10/2/20 10:26 AM, Eric Dumazet wrote:
> > On Thu, Oct 1, 2020 at 10:34 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
> >>
> >> I have a problem with the following code in ndo_start_xmit() of
> >> the r8169 driver. A user reported the WARN being triggered due
> >> to gso_size > 0 and gso_type = 0. The chip supports TSO(6).
> >> The driver is widely used, therefore I'd expect much more such
> >> reports if it should be a common problem. Not sure what's special.
> >> My primary question: Is it a valid use case that gso_size is
> >> greater than 0, and no SKB_GSO_ flag is set?
> >> Any hint would be appreciated.
> >>
> >>
> >
> > Maybe this is not a TCP packet ? But in this case GSO should have taken place.
> >
> > You might add a
> > pr_err_once("gso_type=%x\n", shinfo->gso_type);
> >

>
> Ah, sorry I see you already printed gso_type
>
> Must then be a bug somewhere :/


napi_reuse_skb() does :

skb_shinfo(skb)->gso_type = 0;

It does _not_ clear gso_size.

I wonder if in some cases we could reuse an skb while gso_size is not zero.

Normally, we set it only from dev_gro_receive() when the skb is queued
into GRO engine (status being GRO_HELD)
