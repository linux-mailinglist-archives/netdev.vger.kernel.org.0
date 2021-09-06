Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26554401523
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 05:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239200AbhIFDEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 23:04:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239093AbhIFDEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Sep 2021 23:04:09 -0400
Received: from mail-ua1-x934.google.com (mail-ua1-x934.google.com [IPv6:2607:f8b0:4864:20::934])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55531C061575
        for <netdev@vger.kernel.org>; Sun,  5 Sep 2021 20:03:05 -0700 (PDT)
Received: by mail-ua1-x934.google.com with SMTP id 37so3012252uau.13
        for <netdev@vger.kernel.org>; Sun, 05 Sep 2021 20:03:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mji+1y7L1MkEN37tIM2nuhz7tiNiDM26f5ZzumLwjjA=;
        b=YEubqKPUsQCSZ7ORa7JFR33ft0cJgFFE1mnxJ8zoz25HpdpZv1OrzMF8uRTiz0Osrd
         dgYjwEndDVVL47wP1WmznApSgXm7I7wzwJpZ/CdtczV9E95D9ttFH5ANhGaGXzHsOzKo
         meDxUDiHAuAQJViorcHO7Fs3DH21MyGLERMAgVcJTaxGIrFsQXJwPB9O7etQo+RO7tGQ
         awHLBdwGSnjv+8WTPR3SawN3gv47Wu7cw5ksQ0c6TY1xCnLG1Jb110AsEb8lqhEFIdSe
         2e6obC4WkRjAiuK5CP8HcS7pRKHdn/TucjOZH3OPjMvHg0qL2Oi8uxrXe49UXRZ6vRXm
         3/aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mji+1y7L1MkEN37tIM2nuhz7tiNiDM26f5ZzumLwjjA=;
        b=pnTZHYI3qNOD0w/G0rNrxU03U9Qr03PSDo0r/J4dM71sEa9eI7mpo/0DfRAI+0Qmhu
         BYLv+unP37erI8Ln3Tq9kXrQSp/4PoUwoFn4p/hTd01WazUnxIWGqo0kRgzfVmFmr1Rx
         QUW+9XL2h7jzzRUfnqKqD1j7pY0l1J2T63stsXohbPSC+qWqRiTJsK9JeBZ5e1U/eKKi
         vfBnv1BuLpTyXtWZpXdBVLTayNtMPxISGRYSOfDtb8MFJsn1olw1cmr1ebh0zTFvwGKA
         AxJ+//Lxmss+78F1Axfl1GA7qZd/g7EMN/pR+YYLihrG17rzcdAk47HCmPGhzY0cXNIS
         azTA==
X-Gm-Message-State: AOAM532XHsyNs2L2upDjfIGeZO0MY1bMYDu1FKph4G0Rzt8WhZQ+XA7a
        kB6mOrJr0YIPPJXQFHWAyt0Nh7MJJ3c=
X-Google-Smtp-Source: ABdhPJwd5dqu4gcPbATqjUUoLEzBpS56qjBfaufdzj/zXQ7FC3EggNFzbscMqv3IPjv9SfXB0SPX/Q==
X-Received: by 2002:ab0:413:: with SMTP id 19mr4596419uav.38.1630897383635;
        Sun, 05 Sep 2021 20:03:03 -0700 (PDT)
Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com. [209.85.217.47])
        by smtp.gmail.com with ESMTPSA id 128sm939305vkw.51.2021.09.05.20.03.01
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Sep 2021 20:03:01 -0700 (PDT)
Received: by mail-vs1-f47.google.com with SMTP id a25so4403817vso.5
        for <netdev@vger.kernel.org>; Sun, 05 Sep 2021 20:03:01 -0700 (PDT)
X-Received: by 2002:a05:6102:483:: with SMTP id n3mr4819073vsa.42.1630897380678;
 Sun, 05 Sep 2021 20:03:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210902193447.94039-1-willemdebruijn.kernel@gmail.com>
 <20210902193447.94039-2-willemdebruijn.kernel@gmail.com> <CAKgT0UdhaUp0jcNZSzMu=_OezwqKNHP47u0n_XUkpO_SbSV8hA@mail.gmail.com>
 <CA+FuTSfaN-wLzVq1UQhwiPgH=PKdcW+kz1PDxgfrLAnjWf8CKA@mail.gmail.com>
 <CAKgT0UdtqJ+ECyDs1dv7ha4Bq12XaGiOQ6uvja5cy06dDR5ziw@mail.gmail.com>
 <CA+FuTSfpmGHC76GAVVS2qazfLykVZ=mM+33pRHpj-yyM3nqhXA@mail.gmail.com>
 <CAKgT0UdiYRHrSUGb9qDJ-GGMBj53P1L4KHSV7tv+omA5FjRZNQ@mail.gmail.com>
 <CA+FuTSf-83bDVzmB757ha99DS=O-KjSFVSn15Y6Vq5Yh9yx2wA@mail.gmail.com>
 <CAKgT0Uf6YrDtvEfL02-P7A3Q_V32MWZ-tV7B=xtkY0ZzxEo9yg@mail.gmail.com>
 <CA+FuTSeHAd4ouwYd9tL2FHa1YdB3aLznOTnAJt+PShnr+Zd7yw@mail.gmail.com>
 <CAKgT0Ucx+i6prW5n95dYRF=+7hz2pzNDpQfwwUY607MyQh1gGg@mail.gmail.com>
 <CA+FuTSdwF7h5S7TZAwujPWhPqar6_q-37nT_syWHA+pmYm68aw@mail.gmail.com>
 <CAKgT0Ud5ZFQ3Jv4DAFftf6OkhJe5UxEcuVTJs-9HYk8ptCt9Uw@mail.gmail.com>
 <CA+FuTScCp7EB4bLfrTADia5pOfDwsLNxN0pkWjLN_+CefYNTkg@mail.gmail.com>
 <CAKgT0UecD+EmPRyWEghf8M_qrv8JN4iojqv2eZc-VD_OZDzB-g@mail.gmail.com>
 <CA+FuTSdTjtgTZj6n9QtCEYWwip7M7kgKS=ybNOjiE3mzuCzsew@mail.gmail.com>
 <CAKgT0UeSpzLTkzDQh-zX9fcW9059NeKNbkJBJL1PD9ztdpSGVA@mail.gmail.com>
 <CA+FuTSfO6OWv1_gfdNub9UXfkpx=gjg0KBg7mibxj8nkpERc1g@mail.gmail.com> <CAKgT0UeH3aTnMKqzmtqfWrtmkW6cB=Mk6OSJi0FvmDEbmNAd+Q@mail.gmail.com>
In-Reply-To: <CAKgT0UeH3aTnMKqzmtqfWrtmkW6cB=Mk6OSJi0FvmDEbmNAd+Q@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 5 Sep 2021 23:02:23 -0400
X-Gmail-Original-Message-ID: <CA+FuTSe+vJgTVLc9SojGuN-f9YQ+xWLPKE_S4f=f+w+_P2hgUg@mail.gmail.com>
Message-ID: <CA+FuTSe+vJgTVLc9SojGuN-f9YQ+xWLPKE_S4f=f+w+_P2hgUg@mail.gmail.com>
Subject: Re: [PATCH net] ip_gre: validate csum_start only if CHECKSUM_PARTIAL
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@idosch.org>,
        chouhan.shreyansh630@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 5, 2021 at 11:53 AM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Sun, Sep 5, 2021 at 8:24 AM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > On Sat, Sep 4, 2021 at 7:47 PM Alexander Duyck
> > <alexander.duyck@gmail.com> wrote:
>
> <snip>
>
> > > You can do it since you have essentially already written half the code.. :)
> >
> > Sent, but only the ipv4 patch.
> >
> > I actually do not see an equivalent skb_pull path in ip6_gre.c. Will
> > take a closer look later, but don't have time for that now.
> >
> > https://patchwork.kernel.org/project/netdevbpf/patch/20210905152109.1805619-1-willemdebruijn.kernel@gmail.com/
>
> So does that mean that commit 9cf448c200ba ("ip6_gre: add validation
> for csum_start") is adding overhead that doesn't really address
> anything, and is introducing false positives? If so, should we just
> revert it?

I agree.

I didn't immediately understand how there can be an ip6gre_header
analogous to ipgre_header (for headers_ops.create), but no skb_pull
in ip6gre_tunnel_xmit equivalent to the one in ipgre_xmit.

One difference between the two of them is the return value, which
returns an offset: ip6gre_header returns t->hlen. ipgre_header returns
t->hlen + sizeof(*iph). This extra offset was introduced in commit
77a482bdb2e6 ("ip_gre: fix ipgre_header to return correct offset") as
a fix to previous commit c544193214 ("GRE: Refactor GRE tunneling
code."). Before the latter commit the IPv4 header was included in
t->hlen, similar to IPv6. After that commit it is no longer. The latter
patch is also the one that introduces the skb_pull in ipgre_xmit.

I can't say that I fully understand how this works for IPv6.

But I think that is sufficient to understand that this skb_pull issue
does not affect the ip6_gre path and we best just revert that commit.
