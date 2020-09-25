Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 029022790FE
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 20:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729741AbgIYSnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 14:43:12 -0400
Received: from mout.kundenserver.de ([217.72.192.75]:45403 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726401AbgIYSnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 14:43:12 -0400
Received: from mail-qt1-f173.google.com ([209.85.160.173]) by
 mrelayeu.kundenserver.de (mreue107 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1Mg6uW-1kvk802eT8-00hd38; Fri, 25 Sep 2020 20:43:10 +0200
Received: by mail-qt1-f173.google.com with SMTP id b2so2779322qtp.8;
        Fri, 25 Sep 2020 11:43:10 -0700 (PDT)
X-Gm-Message-State: AOAM532o+L7Mb4uL/JSLLaQ8Wb8e2gOvXUSPa8qDfBBYOCIETQNtJtbu
        OGZLL2/UJ2nH+i8r3KinS+WPt47GwPsC5KPFMBE=
X-Google-Smtp-Source: ABdhPJznPyzhYwuux+BthxpNuMrUe2I5Rfkhf/t2FbB44iCpFkSn8WqpsjOfIjdo1kNhkQFYN+TvhoVRJnZgTystfms=
X-Received: by 2002:aed:2ce5:: with SMTP id g92mr1049652qtd.204.1601059389412;
 Fri, 25 Sep 2020 11:43:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200925132237.2748992-1-arnd@arndb.de>
In-Reply-To: <20200925132237.2748992-1-arnd@arndb.de>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 25 Sep 2020 20:42:53 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1zBgFbx8ZeqFUXok2WsOha+72zXpFZ60Sv+9=wwaqe4w@mail.gmail.com>
Message-ID: <CAK8P3a1zBgFbx8ZeqFUXok2WsOha+72zXpFZ60Sv+9=wwaqe4w@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/2] ethtool: improve compat ioctl handling
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:UGeDIC9Ve8/SQxcTVPMfaaKeQQHqZHycgVFm6Byx+nIV7cQu/OK
 yJiY2UG6YWbgdhiqnhLWZzKo5pvFAly47/wnoEpr8PfZoHYYQ4oitxNlZfGngF3jloiOMtY
 d2IR96b6Xv2pVlTYWSJncUeMvHxlpaMqJTcslug5vfdjQiZkxNIMI9GYJIaKzy77Zm354KO
 W+s2pSWjo/65Nj9nxtGTQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:LEPOD2Jfl/k=:2P4vTXkVtzM77b/6pEj8iE
 fAd7VttGxihOFWiPBNdPFS9B/yDDxFhH393zDU4qp1r4GmvASyajREKMFVjaVwDFMtqb+ugwy
 YZMaLjQj2S0E7/xkTpblp8AAlzRFrr9S+iRqwNWnsWwrIjiweV0F3ZIZjaIjGT83xvJ6LG8Vx
 AFlXh417vtouL6OuyAHgb1EyRnQ/Um6BqiuIm1QF8vz6vkFjmByx/I87Zf/QbG4+QWN+PtWdb
 QMYHs1o0XciFjgxFwxZrhalJ+Ll9GoJp+tyLcjODhuyRKIPlYMCh3JkRsdpc/pfqgyNfabrOz
 BEz1k4zAlFFlBSKoxEIVMYJHIFQwlrAv6kefBIN8crBuJURnsLDGW/Wrl+yO8VEvsruNy+O7j
 onQO6jWSHrKrEgs7n7LM9h6gAp/zqEzz9z2GdLvVQR76xqtaHLI1kaXSPXX1xYFZADKYqoRNQ
 iSw1MZ4cINyagyTH3j068cDD3ExCQPNjWIoi1mGpUZJCIbn53/fNdygM3ys28i1QsR/pUvPzh
 hnpKWuhEROzRkl7lzro1LldFDBkQY4Dswq6rPlZCnGAwLOtgbMKPVhXWCBUaJomAtMBbXrvgH
 nF6B9IwmPf4VmENZSwR+8kX3AfktKzrs+Nmh6fwGENDvA5MEEYKm6ZkPJIfFut/EkmrtaNLnf
 JyPV7O1j0O7v32H8AxY345ALNxZKvd/CjD8XcwedB4eFSLeEftmy/ecHcQMXhl3VDY7IDNN09
 1KsDLzSMJR91DR6tyo1QOibIx3A56M0c2gFmHkTza5E7MmYR82DPLXDip8ThS6qNGZKXt9+JS
 G9f67Jcn3lu3+aKA3iA0Z4M7++H4U5LmNFMbt4EYwMd9e5s4gyLHin6MpUl7Y47f3ZAbpi3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 25, 2020 at 3:22 PM Arnd Bergmann <arnd@arndb.de> wrote:
>
> The ethtool compat ioctl handling is hidden away in net/socket.c,
> which introduces a couple of minor oddities:
>
> - The implementation may end up diverging, as seen in the RXNFC
>   extension in commit 84a1d9c48200 ("net: ethtool: extend RXNFC
>   API to support RSS spreading of filter matches") that does not work
>   in compat mode.
>
> - Most architectures do not need the compat handling at all
>   because u64 and compat_u64 have the same alignment.
>
> - On x86, the conversion is done for both x32 and i386 user space,
>   but it's actually wrong to do it for x32 and cannot work there.
>
> - On 32-bit Arm, it never worked for compat oabi user space, since
>   that needs to do the same conversion but does not.
>
> - It would be nice to get rid of both compat_alloc_user_space()
>   and copy_in_user() throughout the kernel.
>
> None of these actually seems to be a serious problem that real
> users are likely to encounter, but fixing all of them actually
> leads to code that is both shorter and more readable.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

The kbuild bot found another dependency on a patch that I had in my
testing tree (moving compat_u64). Let's drop both patches for now, I'll
resend once that has been merged.

      Arnd
