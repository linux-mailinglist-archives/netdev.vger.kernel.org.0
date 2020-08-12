Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF976242444
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 05:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgHLD10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 23:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726457AbgHLD1Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 23:27:25 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C99C06174A
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 20:27:25 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id b17so1132942ion.7
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 20:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Cv6To1xNei0LLSRiva8c4SLTVO9JByqhYIOzxANOVmM=;
        b=vo/NYDf5EO76pUdtg/nXluMxyZJR7eqK6UO8w5L4u4VDSsNdWTUWrScRabn/oXg7Ub
         gX5Su+JInfI4G+tFrGd+FMa7kyfuAQHVo/r1SQDotiGnKu8zrtT7BpYZXaAQMdodtDkm
         MEUy9xgCvKCWI6C1hJb34+CaaMEU+kGPSIo+ZsHAt0n2BqbJgSKRSp/mDCgAZjpPCORQ
         u4+wWsllmOFlaIy8T+l9i6B/WtkMHjXpin21BmcBrr0gdpDPXqKQYAevzFB6XJUUKowX
         OpOR0DlqdttORw0QT1ApK2mlGFK/bXnWyGmmRGF3BG7NGWeW8VJTr3s7PVvl4LEQecxf
         KjZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Cv6To1xNei0LLSRiva8c4SLTVO9JByqhYIOzxANOVmM=;
        b=b7bi8/qGkaoaE9g4K0NqT83narFDyMkIJ1GicxiFk9PVD0CVl4qwCftss7V20sZGtN
         qEgQVaJQRhsE3PtPk41NBuO3YsqiBzigd9SEzPhpd24v4CQZzZtztgVv199Z9DebRxe9
         z0g6oocijNU880yxdaLD0gkNJpGYIm42Kk1Esnxo8HQUbOPLqsAvPnbwKNihfhi8ExHB
         5f3gkrXWq7cXaXkiAqGR0JFq2rFU1E7FITdVB9bXzWFWNHb+AWFY2SPfdwmdauEYQFbO
         XRfgvFzSMY674oXDqTesO9Z91WC5Er7+TPxXcZt8kRJNcPBch3y2inBZGz1j00+2nWA+
         rINA==
X-Gm-Message-State: AOAM533u/xUW5VSMFqQ16LL4erEc3s+429BjSHr6Av4Hxv7Tojj2mbUq
        nO2UYJ/iEsu8DMDIVnGch01NY5J+kX0l6NsyDN/lEA==
X-Google-Smtp-Source: ABdhPJzPTBOXHr56a6SrA6qfDjHF2POSJq8d6hpPREAN9oE9FoOZnS8qftZUA6VdsdmLJfW+z2H0i3IZkpmIJH54NMU=
X-Received: by 2002:a6b:b356:: with SMTP id c83mr23217222iof.99.1597202844404;
 Tue, 11 Aug 2020 20:27:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200812013440.851707-1-edumazet@google.com> <5b61d241-fedb-f694-c0a1-e46b0dedab66@gmail.com>
 <CANP3RGevbWwJ-oEmSjoC6wi1sUNtt6fqvE=sS8mTLnknNVMxJQ@mail.gmail.com> <c75f6c00-47ce-4557-151d-f65609b5525c@gmail.com>
In-Reply-To: <c75f6c00-47ce-4557-151d-f65609b5525c@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 11 Aug 2020 20:27:13 -0700
Message-ID: <CANn89i+xLvs+Szs5PAMHuhiLUNgXif1KE+Dsb=28=W88YUDp3Q@mail.gmail.com>
Subject: Re: [PATCH net] net: accept an empty mask in /sys/class/net/*/queues/rx-*/rps_cpus
To:     David Ahern <dsahern@gmail.com>
Cc:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Alex Belits <abelits@marvell.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 11, 2020 at 8:22 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 8/11/20 9:19 PM, Maciej =C5=BBenczykowski wrote:
> > Before breakage, post fix:
> >
> > sfp6:~# echo 0 > /sys/class/net/lo/queues/rx-0/rps_cpus
> >
> > With breakage:
> > lpk17:~# echo 0 > /sys/class/net/lo/queues/rx-0/rps_cpus
> > -bash: echo: write error: Invalid argument
> >
>
> ah, so this is recent breakage with 5.9. I had not hit before hence the
> question. thanks for clarifying.

Yup, 07bbecb34106 ("net: Restrict receive packets queuing to
housekeeping CPUs") has been merged only recently.

(This was not in David net-next tree btw, this is why it took us so
long to come to this issue)
