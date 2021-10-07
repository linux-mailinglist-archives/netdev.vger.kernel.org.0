Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7EC3425E3D
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 22:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232977AbhJGU6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 16:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232797AbhJGU57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 16:57:59 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE288C061570
        for <netdev@vger.kernel.org>; Thu,  7 Oct 2021 13:56:05 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id s64so16275541yba.11
        for <netdev@vger.kernel.org>; Thu, 07 Oct 2021 13:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OAwhoQ8WnPjiR05kpnMMYY2kjXq1+16g/k5+6wSGx6g=;
        b=JOOJ48o9O8li5/RVr1K91U3pJsEcml3OhD2uhsKlydGuE9Dnvcj6fqA5qrn0QIzp26
         jpI04Ob9Vs3glArfc7zc+dJmCn4+0B6pHYoSOYedU9A+uPrRun2+hX4hqzSUanG0tCil
         p23NiCVSvt4CG+HrfOny84BXBMAEDvBj/uNbB8X1mYhqlvsm5tNeumKC9xCgb/n/E+JI
         K7yCwS0u08MD1Cxwq8wVQpZliHkOO67LkdTYW4zFcMOcQ6mMsVQo77n8jUld+El/NIkN
         feBXz3F28ZmLz6aKFSIRqfBFKIdUSU8myLSaOIOqBdrmbm6bC1he5fuVcqXeuZWBit8B
         qZLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OAwhoQ8WnPjiR05kpnMMYY2kjXq1+16g/k5+6wSGx6g=;
        b=KWZnsCYn1aZZhJIxUJHRf55sXsGtrvz/Ew5VVkcnk4ZAE+ipgmrgAfQWE7iPsMa5A0
         RT89g0tSLmQ07J0sRR0tSX1NDgoCp6xVw38lyoE5goclhyqrLHgPJTCctVecLnZloH/G
         GWvadEz+22JrGEyPfBfi2FcE1zToNP/LP2XchkcLDPTsjABDnUHHeXL96HebxqJOj24T
         aPQCa2hNJ9lSjlD73pe+UoDX4rCTfuC5EfUZbxAY0gyHiS1Ebe32S7GB/QIDCZpQVXPA
         CPsjzfwvwBCnCkxTZ/PHu+mW/c/N/41XrzcOaDo6nN7yO7+aW0Ltlk81I7Id3YGflWi8
         7Jew==
X-Gm-Message-State: AOAM533VpqdSrdRyeEq6fmTkV7x3wSKD/lMe5F24OikwcbKgjYqLlIrk
        SbR2HimW5Sf9DDIYgp6iFgxN/CBhtm0IFUQDXLC0d25U
X-Google-Smtp-Source: ABdhPJzGsVJVt21objpdGhNHBHCI7Jy0qwSEx4beX4m1GCqBTDIC+pOXICVrv7MXHOlyEkD3/h0Hb/R39nshNdumIUI=
X-Received: by 2002:a25:bb0b:: with SMTP id z11mr7234921ybg.108.1633640165017;
 Thu, 07 Oct 2021 13:56:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210928031938.17902-1-xiyou.wangcong@gmail.com>
 <CAHmME9rbfBHUnoifdQV6pOp8MHwowEp7ooOhV-JSJmanRzksLA@mail.gmail.com> <CAM_iQpV-JKrk8vaHDeD0pXaheN0APUxH5Lp+mGCM=_yZQ1hd4w@mail.gmail.com>
In-Reply-To: <CAM_iQpV-JKrk8vaHDeD0pXaheN0APUxH5Lp+mGCM=_yZQ1hd4w@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 7 Oct 2021 13:55:54 -0700
Message-ID: <CAM_iQpVNP2+7F59-6NDhXfE7qxU6APNdBu5UxcWKMaow05kytA@mail.gmail.com>
Subject: Re: [Patch net] wireguard: preserve skb->mark on ingress side
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Peilin Ye <peilin.ye@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Jason

On Mon, Sep 27, 2021 at 8:27 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Mon, Sep 27, 2021 at 8:22 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > Hi Cong,
> >
> > I'm not so sure this makes sense, as the inner packet is in fact
> > totally different. If you want to distinguish the ingress interface,
>
> The contents are definitely different, but skb itself is the same.
>
> Please also take a look at other tunnels, they all preserve this
> in similar ways, that is, comparing net namespaces. Any reason
> why wireguard is so different from other tunnels?

Any response?

Thanks.
