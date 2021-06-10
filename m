Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 231973A28FB
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 12:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbhFJKGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 06:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbhFJKGp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 06:06:45 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36FB8C061760
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 03:04:49 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id c14so10904909ybk.3
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 03:04:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y1t1gThwqk4P3CmoGImUqahvI/YhwYgwDOhTQsQgvaA=;
        b=Fo5PxKwzHWbMPPS1iiWO2GC+MRsiSG+6qXKY/mJ/8+7ab/qIWgpJGQVg99FSMR59zt
         L+z+SMHv4atQvkUU+725zAvAEtaDTy9Yh0HZGmPZkqEve5SDUZFOBscTmtgsyMenyG8S
         IAi76+d89mduQPDfXVeeIyAVTDccEEn+imq2ABlI57gwY5WGv1pXTZaqp/BRpHisTPPS
         GfaHjkwECD96YVgA8t1W0kmiioSEfBzKDGXtbuEV7jmAInCnH7zyVxf0GHB8pyzJZZiO
         4EAZOM+pokM+kdAIbQR6JsQkllDWaMu7mFrz1GoNVlfNvBL4u4BlbvA7PYQ6pp0ynTax
         zLNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y1t1gThwqk4P3CmoGImUqahvI/YhwYgwDOhTQsQgvaA=;
        b=QrEoKY4UbtJ9OXJWxcEuBJsWpXynBQF31cR0tmsmZ225FokecXClbmpBFPosye4IBu
         t9xde8cZxD/rufK4Uu4jPyn8zDHi3ZtuXhAUGC91qdtwLbe5xCcGtNQ4yF/RACuu8Pw4
         IztyAkGxhcSlN6sUJBvyR080/m7kubN6Yy3LuWC3hGlKptfUlL0VbA1BQ0xMr/q0AicN
         HTRN1OeDqkR+fqMIC+f1cE8Y9OLxJeFDANEx7CvgHdjEmSe4/xHqA2VRtw9Y65exMGbJ
         VZKTyRjujCyhyIwWgrX6yW0JSA2dAgnivGXtA3+cpMUrY1joxeqfWDnCQkb8XX9XXt5Y
         lzLQ==
X-Gm-Message-State: AOAM5313ZDqnOXKYz+pWpw9czP/G9pF39z19Oc2r5qe2uvxpYb9abilB
        Fmqh8Nwg2ZU0q7bA9mh2UWN5dYwli1a32/cmxxrOfA==
X-Google-Smtp-Source: ABdhPJw8FlL5flBN8UKGv2Ytl7fRld47EDaX0RjIibn23UBr+CVj3m34UcaHSCn4L0eFgSgFRwvJl6oK4wC2nEgDyQ4=
X-Received: by 2002:a05:6902:4b2:: with SMTP id r18mr6636440ybs.446.1623319488149;
 Thu, 10 Jun 2021 03:04:48 -0700 (PDT)
MIME-Version: 1.0
References: <1623058534-78782-1-git-send-email-chengshuyi@linux.alibaba.com>
 <CANn89iLNf+73MsPH7O7wX3PrN26FVLcjw_SmsN6jNwnjrYg4KQ@mail.gmail.com>
 <0e938649-986d-ce79-e3c4-1f29bdcb64e0@linux.alibaba.com> <CANn89iKnT5Ebk5vovFJKHY4Fe7ERkN3ak_Nkqyc=vXL=VWvyPg@mail.gmail.com>
 <258e3c94-f479-509c-a4b0-5a881779dd14@linux.alibaba.com>
In-Reply-To: <258e3c94-f479-509c-a4b0-5a881779dd14@linux.alibaba.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 10 Jun 2021 12:04:37 +0200
Message-ID: <CANn89iL8bkiJdDH110U5uD4mSJM7v9fU8xFa9BXAu4wCf+y13Q@mail.gmail.com>
Subject: Re: [PATCH net-next] net: tcp: Updating MSS, when the sending window
 is smaller than MSS.
To:     Shuyi Cheng <chengshuyi@linux.alibaba.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Mao Wenan <wenan.mao@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 8:00 AM Shuyi Cheng
<chengshuyi@linux.alibaba.com> wrote:

> Thank you very much for your reply!
>
> Maybe it's not clear enough that I described it. The scenario where the
> above problem occurs is precisely because the tcp server sets the size
> of RCVBUFF to be smaller after the connection is established. Here is a
> sample code that caused the problem.
>
> # default tcp_rmem is 87380

Except that this value is overridden at connection establishment.

tcp_rmem[1] is only a floor value, say if you want a reasonable value
even if MSS == 100

> tcpServerSocket= socket.socket(socket.AF_INET, socket.SOCK_STREAM)
> tcpServerSocket.bind(server_addr)
> tcpServerSocket.listen()
> while True:
>      connection,client_addr = tcpServerSocket.accept()
>      # Shrink rmem
>      connection.setsockopt(socket.SOL_SOCKET, socket.SO_RCVBUF, 16*1024)
>
> Therefore, when the developer calls the sock_setsockopt function to
> reset RCVBUF, we can use sock to determine the TCP state. When in the
> connected state, it is not allowed to set RCVBUF smaller than mss.
>

Sure, but the application can _also_ set SO_RCVBUF before listen() or connect()

We can not have assumptions about SO_RCVBUF values and socket states.
Otherwise we would have to add some sk_rcvbuf adjustments every time
the socket state is changed.
