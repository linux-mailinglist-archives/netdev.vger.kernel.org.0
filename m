Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 828A52F1906
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 16:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732256AbhAKO7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 09:59:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729688AbhAKO7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 09:59:31 -0500
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F102C061794
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 06:58:51 -0800 (PST)
Received: by mail-ua1-x931.google.com with SMTP id s23so6002749uaq.10
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 06:58:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HCNTiunazZYLzBElVvBsIq1txvjnJLCjiClRs9NWjxM=;
        b=YTVMNzf3e2QLEPvy1z+h+zOAWVuLqvcH9ukx2eVAT0DG39fwZQckZcdCQ6osLjvyqB
         W1Eok+rzydNg3x/ySgAS9J8GmnZj3T5ZFiXIpjlMQkfJ4QxtakPIIHeDDo5RhL3X4hYD
         BuruiWbOHSMJR1i99IwafVXZr28lq7wJOBDqF0LVqYIdF6HJKbk4UZYHshu1RYbpqUdN
         vx2u01UDuDZ0d7MOzQ8H+s+j9ooK/Xs8HQthOVRyvVWDnf61LUyOUaOuvI4JQhGHdqUj
         CFVWKljg59zWuINxFaakP2l3XJSxanVnzr1WyM4xwPQBd4gBJ2IcYI8uDYIDCGbIVI6j
         0q6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HCNTiunazZYLzBElVvBsIq1txvjnJLCjiClRs9NWjxM=;
        b=CnW7YBp+YX81M8RwCId7fOxLWWZBw9xxN8uzFnVqdf3/Lbk7/5SfUPEQL8Z1iAMk9R
         G7Gw+7/XV4MHEmFq8NakPc0Pd1PK8Dc2VmGYqdxRniEdY6thmztDqefdL6vacGy5ibsZ
         X6mdtA2GbtyAyI12EU4EHTFQW0E0PBko+blMjS1tPNSFrJzHlzBpcDvFI0pWwX+9+2+k
         QoP5WbLOINWMJnRqYgZyV/G21/S7SCR80QA6Ox2L7VSh/CtQkBVKaLOIdYsH+0N1YFbZ
         0EG/zSv65t/67viOAuO3NpI9EcC7p2P5F5kdejvvU2yDoIZRhIb1OZycgiBexHlrAvbq
         hX7A==
X-Gm-Message-State: AOAM533eCalTe+AI86z7i0USaWLb+EeQECkvI81RbSydzOYwTp7bBNg0
        7HveDZtvZtam+7fF4d7UMsAtqgxn1sNrVi2QA5erEg==
X-Google-Smtp-Source: ABdhPJwJv5F6kb/IyvwHdQiLOnyG9BpA/BeaFV9eQQPU+tZlda6yHltHXnoTG1+5XGfPdzPrUrieOdTfXn72+CojqXw=
X-Received: by 2002:ab0:634c:: with SMTP id f12mr13032319uap.63.1610377130152;
 Mon, 11 Jan 2021 06:58:50 -0800 (PST)
MIME-Version: 1.0
References: <20210109043808.GA3694@localhost.localdomain>
In-Reply-To: <20210109043808.GA3694@localhost.localdomain>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Mon, 11 Jan 2021 09:58:33 -0500
Message-ID: <CADVnQymUn1aKoA4nW8dhEi-fUXNCbr2--vDEmmMtHHXGp2AFNQ@mail.gmail.com>
Subject: Re: [PATCH] Revert "tcp: simplify window probe aborting on USER_TIMEOUT"
To:     Enke Chen <enkechen2020@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jonathan Maxwell <jmaxwell37@gmail.com>,
        William McCall <william.mccall@gmail.com>, enchen2020@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 8, 2021 at 11:38 PM Enke Chen <enkechen2020@gmail.com> wrote:
>
> From: Enke Chen <enchen@paloaltonetworks.com>
>
> This reverts commit 9721e709fa68ef9b860c322b474cfbd1f8285b0f.
>
> With the commit 9721e709fa68 ("tcp: simplify window probe aborting
> on USER_TIMEOUT"), the TCP session does not terminate with
> TCP_USER_TIMEOUT when data remain untransmitted due to zero window.
>
> The number of unanswered zero-window probes (tcp_probes_out) is
> reset to zero with incoming acks irrespective of the window size,
> as described in tcp_probe_timer():
>
>     RFC 1122 4.2.2.17 requires the sender to stay open indefinitely
>     as long as the receiver continues to respond probes. We support
>     this by default and reset icsk_probes_out with incoming ACKs.
>
> This counter, however, is the wrong one to be used in calculating the
> duration that the window remains closed and data remain untransmitted.
> Thanks to Jonathan Maxwell <jmaxwell37@gmail.com> for diagnosing the
> actual issue.
>
> Cc: stable@vger.kernel.org
> Fixes: 9721e709fa68 ("tcp: simplify window probe aborting on USER_TIMEOUT")
> Reported-by: William McCall <william.mccall@gmail.com>
> Signed-off-by: Enke Chen <enchen@paloaltonetworks.com>
> ---

I ran this revert commit through our packetdrill TCP tests, and it's
causing failures in a ZWP/USER_TIMEOUT test due to interactions with
this Jan 2019 patch:

    7f12422c4873e9b274bc151ea59cb0cdf9415cf1
    tcp: always timestamp on every skb transmission

The issue seems to be that after 7f12422c4873 the skb->skb_mstamp_ns
is set on every transmit attempt. That means that even skbs that are
not successfully transmitted have a non-zero skb_mstamp_ns. That means
that if ZWPs are repeatedly failing to be sent due to severe local
qdisc congestion, then at this point in the code the start_ts is
always only 500ms in the past (from TCP_RESOURCE_PROBE_INTERVAL =
500ms). That means that if there is severe local qdisc congestion a
USER_TIMEOUT above 500ms is a NOP, and the socket can live far past
the USER_TIMEOUT.

It seems we need a slightly different approach than the revert in this commit.

neal
