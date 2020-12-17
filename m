Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C53512DD751
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 19:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731062AbgLQSJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 13:09:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730772AbgLQSJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 13:09:15 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF99EC061A00
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 10:08:08 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id p5so26653533iln.8
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 10:08:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ptc3Wzx1g7fTtkT8R5ZlGTo158ECcktGXEFzGt4DL/U=;
        b=gpNjy+kSJG/FJadQ+heihBH/z5JfUkw0sfctv89CuGaJGBaRlGs3VT0bDGntzMrz1k
         ncQqnUo1QwdQGa1P1UxJxMniQ49uvvpGP/UkJnIi78GHVlaeEdAi7R2pgpwO+14KXBCO
         A8JXi+mLylSAAv1DbsI9yHrbV1OBMpMUGHe3JhI0HWoI22/rXY2JEKXmqOGARqlz34te
         tZJn9P76YQwpWIwcCUPZa6k1ryjTpY4xSpJnFjPhbV0qH/iC3OmXuwmdkYxx5ioNkK9h
         y3/EyL+wjX6D2CDYns3fVQPg//Fq8kQK3u92owVhW3mYizw32cv4WADbUt5KLdTMEq3P
         xgbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ptc3Wzx1g7fTtkT8R5ZlGTo158ECcktGXEFzGt4DL/U=;
        b=ZLxrbF41CLD/qDK66SAfTuzPn2/7+tiM+uQO21VTv/MtceUvha1kQQ6TIW1ZHM4krL
         HYFtkejlA1JFrbtP9WUMg7MMq79/uVmkatK4ha17/GZIRXRl77t9/KJjVnJpf0XZkF2z
         V0QF3z+CE/q8AU6/aIxEo5uHksk0HH0xf6S49Wi5Vqiq4X7rkYreutYYD7ofXAgzn8wB
         k6/iW7cRbeVmW6quxFmxwSmHbQ0LBHY+0BXIxeprJ8EcHsIT8sSYr/fnJHyjwTU+hSbu
         nzxG6x9cZbSPUHpRALVgJ95EtFZgiSLpQtQkveHamCayCyOCF4wqthiqzgwo8cU2xsl2
         3h6g==
X-Gm-Message-State: AOAM531Iu6VnVIiYRleuVq6AFNf/H7CyhHhuNA6NMW69Ho/oh+9/Q6c4
        DaxvGOpWnAHpuUC7D29aZzKfPKyGSUop4zDsUBrrUbvj78SSlM23
X-Google-Smtp-Source: ABdhPJzB0sv2Y2Peim16ItZYo2mrWqDYd9sBmaBtiIjT3MHWzbWpj7rDkvMIS1AH+69buYprzaLJ95FAt6dx4NUZH08=
X-Received: by 2002:a92:9f59:: with SMTP id u86mr48050ili.205.1608228487898;
 Thu, 17 Dec 2020 10:08:07 -0800 (PST)
MIME-Version: 1.0
References: <5664fa0f-aef2-c336-651a-093c9eed23ab@candelatech.com>
 <765f370d-ce2d-b75a-2dde-87f69ae7c185@candelatech.com> <CANn89iKpa1y2SKJuR9kRi=AZs94sj+-tzRs+2D0vmxh+ahEcGA@mail.gmail.com>
 <adbee2ec-c6ba-7a17-eb98-1c53365fa911@candelatech.com>
In-Reply-To: <adbee2ec-c6ba-7a17-eb98-1c53365fa911@candelatech.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 17 Dec 2020 19:07:56 +0100
Message-ID: <CANn89iJQnSVZFp2XDgREN1QMtU4exOsnJq=5VzJ6tqTCJ7MH-g@mail.gmail.com>
Subject: Re: net: tso: add UDP segmentation support: adds regression for ax200 upload
To:     Ben Greear <greearb@candelatech.com>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 17, 2020 at 6:56 PM Ben Greear <greearb@candelatech.com> wrote:
>
> On 12/17/20 2:11 AM, Eric Dumazet wrote:
> > On Thu, Dec 17, 2020 at 12:59 AM Ben Greear <greearb@candelatech.com> wrote:
> >>
> >> On 12/16/20 3:09 PM, Ben Greear wrote:
> >>> Hello Eric,
> >>>
> >>> The patch below evidently causes TCP throughput to be about 50Mbps instead of 700Mbps
> >>> when using ax200 to upload tcp traffic.
> >>>
> >>> When I disable TSO, performance goes back up to around 700Mbps.
> >>
> >> As a followup, when I revert the patch, upload speed goes to ~900Mbps,
> >> so even better than just disabling TSO (I left TSO enabled after reverting the patch).
> >>
> >> Thanks,
> >> Ben
> >>
> >
> > Thanks for the report !
> >
> > It seems drivers/net/wireless/intel/iwlwifi/pcie/tx.c:iwl_fill_data_tbs_amsdu()
> > calls tso_build_hdr() with extra bytes (SNAP header),
> > it is not yet clear to me what is broken :/
>
> Your patch is guessing tcp vs udp by looking at header length
> from what I could tell.  So if something uses a different size,
> it probably gets confused?

I do not think so, my patch selects TCP vs UDP by using standard GSO
helper skb_is_gso_tcp(skb)

tso->tlen is initialized from tso_start() :

int tlen = skb_is_gso_tcp(skb) ? tcp_hdrlen(skb) : sizeof(struct udphdr);

tso->tlen = tlen;

Maybe for some reason skb_is_gso_tcp(skb) returns false in your case,
some debugging would help.

>
> >
> > Can you confirm which driver is used for ax200 ?
> >
> > I see tso_build_hdr() also being used from
> > drivers/net/wireless/intel/iwlwifi/queue/tx.c
>
> I tested against the un-modified ax200 5.10.0 kernel driver, and it has the issue.
>
> The ax200 backports release/core56 driver acts a bit different (poorer performance over all than
> in-kernel driver), but has similar upstream issues that are mitigated by
> disabling TSO.

Sorry, I can not find ax200 driver.

>
> Thanks,
> Ben
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
