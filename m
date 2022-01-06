Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDA43486D4B
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 23:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245156AbiAFWkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 17:40:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245131AbiAFWki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 17:40:38 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 547CAC061201
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 14:40:38 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id m6so1322612ybc.9
        for <netdev@vger.kernel.org>; Thu, 06 Jan 2022 14:40:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T8Bm7CygjTGgEMVBB1B2E0cRX2/Il9msHfdFW1Y79Qo=;
        b=Ed3YAPdj2nEu2JSblAiHXE40vi8mPab8V38uoKlGV4epD1GRW4ahXjGV2ARZmS6X8X
         h2GpNqHMCwf+evEyqQLsxtD6sWAp996J5TIgYQJ6pBLL98ma7DR0epaK/angcOr84A7E
         yXRqDfoE85RA65SfNaR/1o3bNvg7YBEwB3cpk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T8Bm7CygjTGgEMVBB1B2E0cRX2/Il9msHfdFW1Y79Qo=;
        b=VOw4axV7Wm9OoNaglNLYXBRwwndUy3mjtRROpuQ9JeyR8FnK+nst4tPDbRPS3EvqRa
         I83QnBbiq8TAeIJSOtqwJo28Y0EYay2QKGUjVjxQMv9BlXgRIhgG76kQZ5Hb0uuhzGa+
         nOQLkHtu7QzFy7UPyGO0EXj2Zr9uN/QAkwnUDoMQE9BtLwgaPmb/wjUv9zThXRBwcEy7
         s5eCeP3AlW/TUr9qThycF9otsq00nWa7r0VUI1exVKOHvskRP7Q9E5oBefd7VBtZ7Xon
         feTvW6ryf6Y0sRpYzJbi+yIR8fy3T1LlwQWw9Op2kYZf8XbJMYkW4gQPSTrkLEEUhSA+
         a+rw==
X-Gm-Message-State: AOAM531pLqRdCNOeLMBQQs8EQyi2HoqtEemuUNmLosUBHp1hMFym/BoO
        rm9HnkP+ei/5OzKQuFPCCKFOa6g7FPLcdccPXHRr0Fm6GaX8pA==
X-Google-Smtp-Source: ABdhPJzSEl5VqGPLI20K6ZFBSbCucyxCYfEgZbLdx1+62/yvopTctlFRbLUENR9CEa+JBi7GNo2U3ZCfoCaO3xFe6pY=
X-Received: by 2002:a25:4d46:: with SMTP id a67mr72261904ybb.217.1641508837347;
 Thu, 06 Jan 2022 14:40:37 -0800 (PST)
MIME-Version: 1.0
References: <20220104003722.73982-1-ivan@cloudflare.com> <20220103164443.53b7b8d5@hermes.local>
 <CANn89i+bLN4=mHxQoWg88_MTaFRkn9FAeCy9dn3b9W+x=jowRQ@mail.gmail.com>
 <CABWYdi2oapjDMSJb+8T7BXMM6h+ftCQCSpPPePXaS3MyS4hD+w@mail.gmail.com> <CANn89i+9cOC4Ftnh2q7SZ+iP7-qe2jkFW3NtvFGzXLxoGUOsiA@mail.gmail.com>
In-Reply-To: <CANn89i+9cOC4Ftnh2q7SZ+iP7-qe2jkFW3NtvFGzXLxoGUOsiA@mail.gmail.com>
From:   Ivan Babrou <ivan@cloudflare.com>
Date:   Thu, 6 Jan 2022 14:40:26 -0800
Message-ID: <CABWYdi26jxzzYPJoN3mrPaXny7FKAmZ61oitSYwuvauGCo+4NA@mail.gmail.com>
Subject: Re: [PATCH net] tcp: note that tcp_rmem[1] has a limited range
To:     Eric Dumazet <edumazet@google.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 6, 2022 at 12:25 AM Eric Dumazet <edumazet@google.com> wrote:

> Just to clarify, normal TCP 3WHS has a final ACK packet, where window
> scaling is enabled.

Correct, yet this final ACK packet won't signal the initial scaled
window above 64k. That's what I'm trying to document, as it seems like
a useful thing to keep in mind. If this statement is incorrect, then
I'm definitely missing something very basic. Let me know if that's the
case.

> You describe a possible issue of passive connections.
> Most of the time, servers want some kind of control before allowing a
> remote peer to send MB of payload in the first round trip.

Let's focus purely on the client side of it. The client is willing to
receive the large payload (let's say 250K), yet it cannot signal this
fact to the server.

> However, a typical connection starts with IW10 (rfc 6928), and
> standard TCP congestion
> control would implement Slow Start, doubling the payload at every round trip,
> so this is not an issue.

It's not an issue on a low latency link, but when a latency sensitive
client is trying to retrieve something across a 300ms RTT link, extra
round trips to stretch the window add a lot of latency.

> If you want to enable bigger than 65535 RWIN for passive connections,
> this would violate standards and should be discussed first at IETF.

I understand this and I don't intend to do this.

> If you want to enable bigger than 65535 RWIN for passive connections
> in a controlled environment, I suggest using an eBPF program to do so.

Right, ebpf was your suggestion: https://lkml.org/lkml/2021/12/22/668

The intention of this patch is to say that you can't achieve this even
for active connections with the client that is willing to advertise a
larger window in the first non-SYN ACK. Currently even with ebpf you
cannot do this, but I'm happy to add the support.
