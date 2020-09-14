Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97149268D29
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 16:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbgINOQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 10:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726667AbgINNoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 09:44:34 -0400
Received: from mail-ua1-x943.google.com (mail-ua1-x943.google.com [IPv6:2607:f8b0:4864:20::943])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E0D0C06174A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 06:44:07 -0700 (PDT)
Received: by mail-ua1-x943.google.com with SMTP id 77so1063736uaj.2
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 06:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2b03matSSVJEICpGKDD0oZOKhtU5J1X4hlenwnPzKYc=;
        b=SJDtQBzm+KweHbWTFAS5fn6WyskPRPxCj5Xp6Ch70iXgVhiVto85XwPhtr7eALbcsA
         qLuR94+HRn1u4MBMvSceYM3DrauehZYz43H8O+0OMGlyAJf2eKCAy40BjSLcUDWVAUfS
         QZ47SEYG2d6c+aDN83q5AWvXiUmrMIw2jdnbYEB/uoK2Excp81O8/0y7st4az0RivKTN
         DC3aN32TEpcU7MCPbXfuxPc+voWRCq4+t9TfXKTwvYUckWzbb0UTjkezHdeKNuw6ohsc
         cc5sRwcyNadLTRui59etAJOxawMmL5k4J45kiKrUG0nFknVZQC98k1adkE8dyyM9ThkA
         kzlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2b03matSSVJEICpGKDD0oZOKhtU5J1X4hlenwnPzKYc=;
        b=HHTlkrOG5/BGKj5s31e3FA/Jx/epMiXYJzs++4SfJOCsnEZMcB/TNVCs7OpliNTijU
         50xkU4dVFMPTzsFJBjzw7FYNKwYSFaB+O3B6Dmt6KfuY4OGLYrjITilrGzvvGYAK9iDO
         00BLaq34HdmYd8bg7bxj7ptEvWD+ok0ht0E9M++4DijcD9DKQ1kISaurUW1cMHyjyBGi
         y1K+EyFRKe2JlT+1Hm7Fgv0e5Mm/fKgZuPUCI09FFYhcJpAROiUjJhNBxEmt0aWyVlyB
         +jCujL/Nr/g9wbchruXX1iKuiv4i9EYsPhyko9anYRJpFlp2eFUkN7LEiV8LtYLqkirO
         dz/g==
X-Gm-Message-State: AOAM531uGeEmD/uWnKFVbLeZ1OB+Z+NKPPU5jr5ix0t3MttbHg99Fk6C
        qcpqYFxSM700rmz+Akdn9+lqAl/udPAUPOhvDdAT7Q==
X-Google-Smtp-Source: ABdhPJycHL+jNJYZE2Zy0jwjO7GJxVI7EoIScjnOpjgMFU1uN3Y+RnInKVWmt5NGG2wHcFDySLzQONzJSMxLnazA2kc=
X-Received: by 2002:ab0:ef:: with SMTP id 102mr6657920uaj.142.1600091046398;
 Mon, 14 Sep 2020 06:44:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200914102027.3746717-1-edumazet@google.com>
In-Reply-To: <20200914102027.3746717-1-edumazet@google.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Mon, 14 Sep 2020 09:43:49 -0400
Message-ID: <CADVnQymGOHwMYAxWVvzrNx1+Fk4Au7VndxtDY5vLB-Qo2L1qZw@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: remove SOCK_QUEUE_SHRUNK
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 6:20 AM Eric Dumazet <edumazet@google.com> wrote:
>
> SOCK_QUEUE_SHRUNK is currently used by TCP as a temporary state
> that remembers if some room has been made in the rtx queue
> by an incoming ACK packet.
>
> This is later used from tcp_check_space() before
> considering to send EPOLLOUT.
>
> Problem is: If we receive SACK packets, and no packet
> is removed from RTX queue, we can send fresh packets, thus
> moving them from write queue to rtx queue and eventually
> empty the write queue.
>
> This stall can happen if TCP_NOTSENT_LOWAT is used.
>
> With this fix, we no longer risk stalling sends while holes
> are repaired, and we can fully use socket sndbuf.
>
> This also removes a cache line dirtying for typical RPC
> workloads.
>
> Fixes: c9bee3b7fdec ("tcp: TCP_NOTSENT_LOWAT socket option")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Soheil Hassas Yeganeh <soheil@google.com>
> ---

Nice. It's beautiful when a fix is also a simplification...

Acked-by: Neal Cardwell <ncardwell@google.com>

neal
