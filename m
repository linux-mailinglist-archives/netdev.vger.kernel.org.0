Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7D931F129
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 21:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbhBRUjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 15:39:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbhBRUiP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 15:38:15 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BAF2C06178B
        for <netdev@vger.kernel.org>; Thu, 18 Feb 2021 12:37:35 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id t11so7862934ejx.6
        for <netdev@vger.kernel.org>; Thu, 18 Feb 2021 12:37:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v/6W1zKT4gnZ5zi+vYmdi/TPSo6ug+DWeXTKDfidQTY=;
        b=GhDyZlCZnqBU4i35ABOeBNvip4Wjg4st9b1ZmsAZdUcOYx94fKKkNCu08jQQWKMeDO
         5dMIgrUuefaupkg3ypnMhNX28gzfGVF+eAk2qJ8AqDjrPX0ZX0r2F3+5dg9FXqd+J88I
         VvE2ugEzIBIFmNTJTDhyF80xkIW5IPbbxvq/5fHkyNW8FXdfRfxFdAZ7WDEdb+o9iiKy
         71p1Mtav4JAQtEaKUS35xxuJ/CdpGR+B9IL3etCdp1MdkiUT8SypMP63XSRIMkVICGmq
         RUz9HxOAU37u0JhRdy2TCqdXieGgGOav/oIk41cDMo2h/2paflYAJTcdCuEfovDV2VIh
         Axpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v/6W1zKT4gnZ5zi+vYmdi/TPSo6ug+DWeXTKDfidQTY=;
        b=qLdM5roYLRYOP7iqykSafHGAtr7NO+UEqVPhJLGObQ38p151lcB8wINvhvXppf/Wz1
         tlux6ZAFQ5ysklhIs6cmoEvFr7h6xn9k3GxzyXIZg2HCgN64xr1WPWkTnFf+vNlYY4j8
         KKsHtInteq8Zwh7FUXPjcx26229cN2OT0KJo2X2JFVfeLHFumSacibhmPsEXV4c2edwJ
         OeSPQsJJ7m6q+webe111jzs3e6FB50sfxwuNCFerXFJNvRf+fKkHJCEHzPgGkL1+Wx9V
         kS/R5oarSiWpyDlFHrstbxCNBD5QeZTb4jb/0O/LgYSJmmKg+UIl7WwLPXGjVnk+nJ0v
         pHgg==
X-Gm-Message-State: AOAM531n170K/BsqIyY3pYtm1HBk3REo+tm2rripmaLfkco5Jpxig5Mw
        Haj4rtUS9AL+k02MnTQdKg0jy2XrfHFzpxIJ84Y=
X-Google-Smtp-Source: ABdhPJyKVss5mnqTO7FmLVDRt1qBaBxyDEzQk5NNpTyXjLQZzre+TnYO62e2I4pjb/MqDUvKXoxtJJXU82B6R3iONK4=
X-Received: by 2002:a17:906:b813:: with SMTP id dv19mr3201239ejb.11.1613680653642;
 Thu, 18 Feb 2021 12:37:33 -0800 (PST)
MIME-Version: 1.0
References: <CAHmME9o-N5wamS0YbQCHUfFwo3tPD8D3UH=AZpU61oohEtvOKg@mail.gmail.com>
 <20210218160745.2343501-1-Jason@zx2c4.com> <CA+FuTSeyYti3TMUd2EgQqTAjHjV=EXVZtmY9HUdOP0=U8WRyJA@mail.gmail.com>
 <CAHmME9rVuw5tAHUpnsXrLh-WAMXmvqSNFdOUh1XaKZ8bLOow9g@mail.gmail.com>
 <CA+FuTSdiuPK-V5oJOMC7fQsjQKRLt95oP7OAOtR3S5mfUJreKg@mail.gmail.com> <CAHmME9oyv+nWk2r3mcVrfdXW_aiex67nSvGiiqLmPOv=RHnhfQ@mail.gmail.com>
In-Reply-To: <CAHmME9oyv+nWk2r3mcVrfdXW_aiex67nSvGiiqLmPOv=RHnhfQ@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 18 Feb 2021 15:36:56 -0500
Message-ID: <CAF=yD-K3wA5yTRSr7kas9xkKZwB2OcYOmqeOx4mpGoQfYCf7ZQ@mail.gmail.com>
Subject: Re: [PATCH net v2] net: icmp: pass zeroed opts from
 icmp{,v6}_ndo_send before sending
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        SinYu <liuxyon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 18, 2021 at 3:25 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Thu, Feb 18, 2021 at 9:16 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > On Thu, Feb 18, 2021 at 12:58 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > >
> > > On Thu, Feb 18, 2021 at 5:34 PM Willem de Bruijn
> > > <willemdebruijn.kernel@gmail.com> wrote:
> > > > Thanks for respinning.
> > > >
> > > > Making ipv4 and ipv6 more aligned is a good goal, but more for
> > > > net-next than bug fixes that need to be backported to many stable
> > > > branches.
> > > >
> > > > Beyond that, I'm not sure this fixes additional cases vs the previous
> > > > patch? It uses new on-stack variables instead of skb->cb, which again
> > > > is probably good in general, but adds more change than is needed for
> > > > the stable fix.
> > >
> > > It doesn't appear to be problematic for applying to stable. I think
> > > this v2 is the "right way" to handle it. Zeroing out skb->cb is
> > > unexpected and weird anyway. What if the caller was expecting to use
> > > their skb->cb after calling icmp_ndo_send? Did they think it'd get
> > > wiped out like that? This v2 prevents that weird behavior from
> > > happening.
> > >
> > > > My comment on fixing all callers of  icmp{,v6}_send was wrong, in
> > > > hindsight. In most cases IPCB is set correctly before calling those,
> > > > so we cannot just zero inside those. If we can only address the case
> > > > for icmp{,v6}_ndo_send I think the previous patch introduced less
> > > > churn, so is preferable. Unless I'm missing something.
> > >
> > > As mentioned above it's weird and unexpected.
> > >
> > > > Reminder of two main comments: sufficient to zero sizeof(IPCB..) and
> > > > if respinning, please explicitly mention the path that leads to a
> > > > stack overflow, as it is not immediately obvious (even from reading
> > > > the fix code?).
> > >
> > > I don't intend to respin v1, as I think v2 is more correct, and I
> > > don't think only zeroing IPCB is a smart idea, as in the future that
> > > code is bound to break when somebody forgets to update it. This v2
> > > does away with the zeroing all together, though, so that the right
> > > bytes to be zeroed are properly enforced all the time by the type
> > > system.
> >
> > I'm afraid this latest version seems to have build issues, as per the
> > patchwork bot.
>
> Hmm I didn't get those bot emails. Either way, I'll do a bit of build
> testing with different config knobs now and send a v3. Thanks for
> letting me know.

Different bot :)

You might get emails from the other later. These can be found through
patchwork at

https://patchwork.kernel.org/project/netdevbpf/patch/20210218160745.2343501-1-Jason@zx2c4.com/
