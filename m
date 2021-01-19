Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 376452FBBAB
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 16:53:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391396AbhASPwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 10:52:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391587AbhASPvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 10:51:03 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B573C061574
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 07:50:23 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id q2so38827077iow.13
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 07:50:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PsALiCYJElwVafz8K+td/NostMLavFJCXJZeAHAP/uY=;
        b=Ag8sZH/nhG29GmxbkBx+lPftNwIusNdtNs0z4mgRU7cJRemrRbQbnNbyrPLzaNMuRM
         b0LFURSzFmJsRSLmH+hThAwF8Mdu/JCTJSKN8CGRrqE9uTYuze1EbOBZsjkX9LKif2bA
         wa1OmHTE0wmim1h5fm5F1Eos7hym7aLWJXtz+08T+N8bnx56MyMdFwPHMb/a77N56ATa
         dKYiT1SaS60YIFIqzm8k52AtSZv/jjPNtsa8hwPKFf8rVlLznjyrZcZSPNLPjqJOCDU+
         IWaf4Rh5aR0KWaJQ7vFxYudoeRvtYcrRcNk+LwWPS+vWHGo8O00DE9PWmP4BOaOddZ/T
         B4/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PsALiCYJElwVafz8K+td/NostMLavFJCXJZeAHAP/uY=;
        b=auPCeBY0rCAvg8XcCe5ERUhm7mmNhmRUZKZNaySzPReCZZI8qV620jr+08baUZ9WXT
         Ichr+4UCgp5vxhdCk9f0JbJEriieHHTdZJri7cDH+GNibS2hpvxpGapS+lzUu7/WhnA1
         z249o3GSjUNEdzpkM43kfaLrGLZoOZfDYRQ/9dj4M4y0e3w+dCh74aD3v/1bIBjFBdf2
         h68LXcD9C9Jz5aqIXR3zaj4HEoNBML9O78rcS0/51slW9pbWWo75NAlgJ7nYTCx3yKTK
         d52clEsg7l6oEzzSrbFA7XMsZ0hcD7n5LhrZaORwv7Y7tbUlFmYYZcWTdFOlZJdBKC8x
         Z7Kg==
X-Gm-Message-State: AOAM532TX6mr45cz4qhLbA5zBFCjsVZVD0elyha1OHumO/7Ec941HI6V
        6iUFEXS9yzCPyHGMtV0TMaANgZRLuhm2/dTnxhQJiA==
X-Google-Smtp-Source: ABdhPJzhpIKznNfCTXcVEVVZ+fk5sxtsfxUU5UPSBXqtYliFRrnkkKsT0s+fmDceKP225XtWMr8efZ6m/msV4FUqFIA=
X-Received: by 2002:a92:9f59:: with SMTP id u86mr3931639ili.205.1611071422158;
 Tue, 19 Jan 2021 07:50:22 -0800 (PST)
MIME-Version: 1.0
References: <bug-209423-201211-atteo0d1ZY@https.bugzilla.kernel.org/>
 <80adc922-f667-a1ab-35a6-02bf1acfd5a1@gmail.com> <CANn89i+ZC5y_n_kQTm4WCWZsYaph4E2vtC9k_caE6dkuQrXdPQ@mail.gmail.com>
 <733a6e54-f03c-0076-1bdc-9b0d4ec1038c@gmail.com> <CANn89iJ2zqH=_fvJQ8dhG4nBVnKNB7SjHnHDLv+0iR7UwgxTsw@mail.gmail.com>
 <b6ff841a-320c-5592-1c2b-650e18dfe3e0@gmail.com> <CANn89iJ2KxQKZmT2ShVZRTjdgyYkF_2ZWBraTZE4TJVtUKh--Q@mail.gmail.com>
 <9e4b2b1f-c2d9-dbd0-c7ce-49007ddd7af2@gmail.com> <CANn89iJwwDCkdmFFAkXav+HNJQEEKZsp8PKvEuHc4gNJ=4iCoQ@mail.gmail.com>
 <77541223-8eaf-512c-1930-558e8d23eb33@gmail.com> <CANn89i+dtetSScxtSRWX8BEgcW_uJ7vzvb+8sW57b7DJ3r=fXQ@mail.gmail.com>
 <20210119134023.082577ca@gollum> <CANn89iJOK2ZznurYCnP4y8xjkocm6t+AZG1DaSnpe-ZDFUfdaA@mail.gmail.com>
 <20210119163800.4859912e@gollum>
In-Reply-To: <20210119163800.4859912e@gollum>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 19 Jan 2021 16:50:10 +0100
Message-ID: <CANn89i+bQSdos=LKyk=BQdthx1NBXOBVvDBdQQQRAHWL5xc1pQ@mail.gmail.com>
Subject: Re: [Bug 209423] WARN_ON_ONCE() at rtl8169_tso_csum_v2()
To:     Juerg Haefliger <juerg.haefliger@canonical.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 19, 2021 at 4:39 PM Juerg Haefliger
<juerg.haefliger@canonical.com> wrote:
>
> On Tue, 19 Jan 2021 14:54:31 +0100
> Eric Dumazet <edumazet@google.com> wrote:
>

> >
> > Oops. Very nice detective work :)
> >
> > It is true that the skb_clone() done in lan78xx (and some other usb
> > drivers) is probably triggering this issue.
> > (lan78xx is also lying about skb->truesize)
> >
> > skb_try_coalesce() bails if the target  skb is cloned, but not if the source is.
> >
> >
> > Can you try the following patch ?
>
> Works. Nice :-)
>

Excellent !

> If you submit this and care you can add:
>
> Tested-by: Juerg Haefliger <juergh@canonical.com>

Sure, I will also add a :

Bisected-by: Juerg Haefliger <juergh@canonical.com>

Because you did quite a lot of work narrowing the problem !

>
> Thanks a lot for the quick turnaround!
>
> ...Juerg
>
>
