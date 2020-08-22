Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12F2924E508
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 06:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbgHVEST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 00:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgHVESS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 00:18:18 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B0ACC061573
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 21:18:18 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id a34so2126786ybj.9
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 21:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VLp8Jcq/vprEqj8g0OOPq9h7GkvUXrUXnFvCa+dH7b0=;
        b=bEMzi8cqw3E2NHk0kgyJ+lfHkhLqOiasg52uQSMbIUQhEwCASSm7rZ8xgbXq3tGVTx
         8CvW0b680V/XJO4uE2kxJAmSL96o9ygIG2xFyi5H9HimnPIIMzPbTm+YnUzNpFZpXwnp
         YElt7/JRgw+N0BDWTWwGuy5kgKX31sC/quOD29P3VldJGqaGy+D9WeANK9xM2Z9gempS
         Q7NyMOru8NqrrdML0A+Un5T9y7JptlVz6s1EkBcsdBO+N0mRMFfu5h4h6BrL+svH9yNo
         YN7q7V8wdvSwcnUUwKszTw/loGAbDtHeb9IqSXsoWd5Dp8HBtW712w2jHPdtd4Wz3E2N
         SwVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VLp8Jcq/vprEqj8g0OOPq9h7GkvUXrUXnFvCa+dH7b0=;
        b=hrIOBtJIklAonOWPUunJ/dsH5Agd/Di+8uKnxXMBJZq+roqYHzMAe60ahI8phtCty+
         HXF6jGIPfdJBhxPrVHxu+fK8WGOqEX359zmFD/7BO4RBMpIAOOGxoKQ89xSrBnrmrG0j
         ttn3cZeD8oOsQDiZ8PUMbx57kGtcoBaS6ejID984tw3RzroGB1IVoYuMbb26PbWBhju4
         vB0Naee3/AAja+TvSxV31/+hpH6SxnARQ+uO6Z00XIqcGRODpuF+SVVtccA+8Cocvhja
         UzPK6vrUiF2aRs7AavNOiCgdcQJMeh3RTfaNdyEQXsXeA7/pe0MowuTMA9Heo1MSJVQP
         h7/Q==
X-Gm-Message-State: AOAM532NmzoDEfuVNmmc12twfuvsEHuI8gYt3z2S8p3HnOZmVsBdJ7A/
        HgNd2AHQM7uOv7B3pFXPtrhDgSCFpcXusBHA3NqyOg==
X-Google-Smtp-Source: ABdhPJyuwR50vilahgYm7Juf0bbVJ1ut+37SBhr4w1ZTSRa44HSLNDbWahwV6mfp0OyoISR7kb1g47jDoJeqY+eOLtY=
X-Received: by 2002:a25:d285:: with SMTP id j127mr7683725ybg.505.1598069897160;
 Fri, 21 Aug 2020 21:18:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200819005123.1867051-1-maheshb@google.com> <20200821.140323.1479263590085016926.davem@davemloft.net>
 <CANP3RGc+N4O-eUAHr+mOsQ740aExW7zzbmh8V7Wb54d3teB+hQ@mail.gmail.com> <20200821.143553.1454267475258459257.davem@davemloft.net>
In-Reply-To: <20200821.143553.1454267475258459257.davem@davemloft.net>
From:   =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Date:   Fri, 21 Aug 2020 21:18:01 -0700
Message-ID: <CAF2d9jj-ZPCP+7QmTVs4ueo1NUqa7ejoN2Ey2hFuhTgnzYTYeQ@mail.gmail.com>
Subject: Re: [PATCH next] net: add option to not create fall-back tunnels in
 root-ns as well
To:     David Miller <davem@davemloft.net>
Cc:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        linux-netdev <netdev@vger.kernel.org>, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>, mahesh@bandewar.net,
        Jian Yang <jianyang@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 21, 2020 at 2:35 PM David Miller <davem@davemloft.net> wrote:
>
> From: Maciej =C5=BBenczykowski <maze@google.com>
> Date: Fri, 21 Aug 2020 14:25:20 -0700
>
> > If no kernel command line option is specified, should the default
> > be to maintain compatibility, or do you think it's okay to make
> > the default be no extra interfaces?  They can AFAICT always be added
> > manually via 'ip link add' netlink commands.
>
> You can't change current default behavior, so the answer should be
> obvious right?
Yes, I don't want to change the default behavior that's why I kept the
default value =3D 0, but yes this config-option would force one to
rebuild the kernel.

OK, I'll respin it with kcmdline option instead of config option
maintaining the default behavior. thanks.
