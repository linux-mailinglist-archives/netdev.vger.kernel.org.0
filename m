Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 693984A919A
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 01:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243615AbiBDA1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 19:27:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233251AbiBDA1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 19:27:54 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69262C061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 16:27:54 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id g14so14028576ybs.8
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 16:27:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nQKr+Ck+sZo803cnA2KM7V1QYN76Aea9LHlVDTklP5Q=;
        b=tHlGyIea8Xr8i31zNODuikOFAJqe/QmWa9Yg1Hw0MJ2mXK7pZhtUA+ls2qQIYmHWO/
         /otwCBsNH4TP5f2xWCr/pS6PC+B/hrbNyPDFiBYymCPSYzKaC5WMPqvWJDq/B4kZA5HF
         i9bOl64Tas+CU3jDeemneOu08mMid0pr7BykUz0PGzCF26fcrctVQFYXKqebrwbmPgo2
         WH68j8be+HrkSM0RHi0+9L1CtqTE8Isi+vqdhSTVo/qOFXldOhLx1nCsXZtLY8qLRc25
         QZqakwg0QRJI7R4RXmZUGax43yIr4OI1ztZKNlrzf4Vgccq5okOILMe2/np7fwDbuRDw
         YgWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nQKr+Ck+sZo803cnA2KM7V1QYN76Aea9LHlVDTklP5Q=;
        b=LjrPyud8LDGiZpfQAur5WekwMMe7L8SO5Oo33lqCx1tFt+Fdi3ChtWJveKtgeeijD7
         bEoU7gdS0x807JK9vaSluOdwMUW1sw9oAeM6Ddxlt7n3w9fkuG8/AdqDjSpeCdla8rAw
         RNOSiiqR5+G5EuWaNPiwEOtIuDWrzr9jOh7j0zkvn8Sr2Hez5tDkZJh+S5dDsPrz4QrC
         FoxxjvK77LTK3HRdRYFEzVvDWnz5KoNe0yOF4/YBi04YPWT2KsteCsRMxrAgX6jCW4Da
         1CNjbD9PqiUDtxbxd46Hkbw303zQOeFDTbyWBox2FgmOL26Bk0EWwzbW8LMBfYgv5/2E
         AeiQ==
X-Gm-Message-State: AOAM531FFnhusLlNflWSbig1kWsL4wMIeLhaIq0w4aX52JIuSbUtJSsX
        LRlQLKx4yfHKZnFKooJ9x4XKiV0mMORyhU4fGa5SBA==
X-Google-Smtp-Source: ABdhPJz0aoogAn564qMqtBxPsLOdRzxJU+U71nK2bz9nXJmthxZQy9HebPah93g6DprR1y+cTPlPcq22JQx8H3oj5YI=
X-Received: by 2002:a25:d2cb:: with SMTP id j194mr667197ybg.277.1643934473274;
 Thu, 03 Feb 2022 16:27:53 -0800 (PST)
MIME-Version: 1.0
References: <20220203015140.3022854-1-eric.dumazet@gmail.com>
 <20220203015140.3022854-6-eric.dumazet@gmail.com> <0d3cbdeee93fe7b72f3cdfc07fd364244d3f4f47.camel@gmail.com>
 <CANn89iK7snFJ2GQ6cuDc2t4LC-Ufzki5TaQrLwDOWE8qDyYATQ@mail.gmail.com>
 <CAKgT0UfWd2PyOhVht8ZMpRf1wpVwnJbXxxT68M-hYK9QRZuz2w@mail.gmail.com>
 <CANn89iKzDxLHTVTcu=y_DZgdTHk5w1tv7uycL27aK1joPYbasA@mail.gmail.com>
 <802be507c28b9c1815e6431e604964b79070cd40.camel@gmail.com>
 <CANn89iLLgF6f6YQkd26OxL0Fy3hUEx2KQ+PBQ7p6w8zRUpaC_w@mail.gmail.com> <CAKgT0UcGoqJ5426JrKeOAhdm5izSAB1_9+X_bbB23Ws34PKASA@mail.gmail.com>
In-Reply-To: <CAKgT0UcGoqJ5426JrKeOAhdm5izSAB1_9+X_bbB23Ws34PKASA@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 3 Feb 2022 16:27:42 -0800
Message-ID: <CANn89iLkx34cnAJboMdRSbQz63OnD7ttxnEX6gMacjWdEL+7Eg@mail.gmail.com>
Subject: Re: [PATCH net-next 05/15] ipv6/gso: remove temporary HBH/jumbo header
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 3, 2022 at 4:05 PM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>

> I get that. What I was getting at was that we might be able to process
> it in ipv6_gso_segment before we hand it off to either TCP or UDP gso
> handlers to segment.
>
> The general idea being we keep the IPv6 specific bits in the IPv6
> specific code instead of having the skb_segment function now have to
> understand IPv6 packets. So what we would end up doing is having to do
> an skb_cow to replace the skb->head if any clones might be holding on
> it, and then just chop off the HBH jumbo header before we start the
> segmenting.
>
> The risk would be that we waste cycles removing the HBH header for a
> frame that is going to fail, but I am not sure how likely a scenario
> that is or if we need to optimize for that.

I guess I can try this for the next version, thanks.
