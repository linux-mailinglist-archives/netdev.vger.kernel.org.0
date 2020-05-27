Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2D91E4C64
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 19:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403796AbgE0Rv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 13:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388206AbgE0Rv0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 13:51:26 -0400
Received: from mail-ua1-x944.google.com (mail-ua1-x944.google.com [IPv6:2607:f8b0:4864:20::944])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F9D2C03E97D
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 10:51:26 -0700 (PDT)
Received: by mail-ua1-x944.google.com with SMTP id g7so8728090uap.7
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 10:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bkIj2D7y+7LzC0zYtznWx5zADKLTBorVCWESBdx0dr4=;
        b=IREJ1mIZAx7JXAV1q732A7zvgpEqj4jP6jl7X6spM7ptRLfFJeO5tGNs5ZpkmLQWo3
         n3HLoO0DjicGcvYMzT4ftwtLvVNqkDYk5ClPYoKXry0La+9ZYpvnx+K5CmcF4eiIx0Pf
         otI9aguw4iNwESsKq/dPzxw/acvS0XL3L5dyDcG/iLkOKhgD+A0UC31bWayQrW/4a3sv
         8XlBMoZMoAuS7YM7nJQb+NNpWbIsVsld3+x7RMWafWxbJBa2hY0111RrXCEZmmrDWxmN
         +IOzRVWnJMbHRYsYvlOAO0PxLwoLChGlmW6Qd/ANhPVJ7VIiYGK2VUl82YqGQx3SOfMK
         YhFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bkIj2D7y+7LzC0zYtznWx5zADKLTBorVCWESBdx0dr4=;
        b=ZBzo8+BjZyO6Hlrgz6KjNOUqhR0cx1gBeEyJu56bon+EX6VacLS7S0yJtQrb13HP6g
         ihRqkNtqZaSZ5tYLvEHNrbLk5Vs52cS4Ijogu5EboaAO5o1gIwZQ0zbewU++WaFx9RCT
         +sJ0jBj+X5+rdHQhlVfympyFe2yiS1+3CtI3iMqtg0valBUOmOE/dVf9OLM5LUAIGme5
         3D+yomKL2GwBSCSMM8HWdwJhAsNAXhdT33q6LnqeIK8QaAl6g4r4vFH0qpGADuymZHu0
         95T00Bq67PUAr8RZVFKRth0H86s1jB24qvn7+acHm9p3RzJjeW7M0yt3BAokquFzl5bS
         euVw==
X-Gm-Message-State: AOAM532JK/RzS/0vbdUcxnT5iswz8bqs9c6brdWrkRL7b6cGZbpHXKRI
        eyXkrt7JvJ1efx58x9SXZGs6nV17dpPAZJSGSKc6Eg==
X-Google-Smtp-Source: ABdhPJzYXzB2n/WS357mmxVZxTpm0nh8Xm4wrESvstxi49dmoaB/iVxz6IAV8lpmVSbRhrBEdQgj6dbPH/yHmteFPHA=
X-Received: by 2002:a9f:318b:: with SMTP id v11mr6180233uad.46.1590601885009;
 Wed, 27 May 2020 10:51:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200527024850.81404-1-edumazet@google.com> <20200527024850.81404-2-edumazet@google.com>
In-Reply-To: <20200527024850.81404-2-edumazet@google.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Wed, 27 May 2020 13:51:07 -0400
Message-ID: <CADVnQy=-0noN4ApLX3pG55_1JVuLa5XKyUJpr0gqNiue6CcCWA@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] tcp: add tcp_ld_RTO_revert() helper
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 26, 2020 at 10:49 PM Eric Dumazet <edumazet@google.com> wrote:
>
> RFC 6069 logic has been implemented for IPv4 only so far,
> right in the middle of tcp_v4_err() and was error prone.
>
> Move this code to one helper, to make tcp_v4_err() more
> readable and to eventually expand RFC 6069 to IPv6 in
> the future.
>
> Also perform sock_owned_by_user() check a bit sooner.
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---

Acked-by: Neal Cardwell <ncardwell@google.com>
Tested-by: Neal Cardwell <ncardwell@google.com>

Nice clean-up. Thanks, Eric! It will be great to have IPv6 RFC 6069
support as well.

thanks,
neal

ps: Tested with the packetdrill script below earlier this morning to
verify that IPv4 RFC 6069 works before and after Eric's patch. Eric
independently wrote a nicer test this morning.

// Establish a connection.
    0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
   +0 setsockopt(3, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
   +0 bind(3, ..., ...) = 0
   +0 listen(3, 1) = 0

   +0 < S 0:0(0) win 32792 <mss 1460,nop,wscale 7>
   +0 > S. 0:0(0) ack 1 <mss 1460,nop,wscale 8>
+.010 < . 1:1(0) ack 1 win 257
   +0 accept(3, ..., ...) = 4

// Send 10 data segments.
   +0 write(4, ..., 14600) = 14600
   +0 > P. 1:14601(14600) ack 1

// ICMP says that the network is unreachable
+.010 < icmp unreachable net_unreachable [1:1461(1460)]

// RTO retransmit.
+.216 > . 1:1461(1460) ack 1
+.010 < icmp unreachable net_unreachable [1:1461(1460)]

// RTO retransmit, without exponential backoff.
+.216 > . 1:1461(1460) ack 1
+.010 < icmp unreachable net_unreachable [1:1461(1460)]

// RTO retransmit, without exponential backoff.
+.216 > . 1:1461(1460) ack 1
+.010 < icmp unreachable net_unreachable [1:1461(1460)]
