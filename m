Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9F8541A083
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 22:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236929AbhI0Utf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 16:49:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236390AbhI0Utd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 16:49:33 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B4FC061575
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 13:47:55 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id w19so24191938ybs.3
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 13:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qlWbjGxhbYGI6aPovE04MfJwkVfFMUYH/V34f3oOVnQ=;
        b=SjCgp4wrt5kSPUeas8UpdhjsSOrHlPPCvG0sb+b4BlMQcAsF9JmkXJewZ+KY45MYiU
         msKfXRPzGNS27Csp6gieTQBsroIwEXK3P1HCcV2otx0HW2IltWp62ZPgFBXL5Mp2vq7V
         0UXgjdrGSkc+63s179XkzBC/SrOyf6tPgVOJvn/vXM+1dSbFIfSBrye1ZyjyqcwI+8n0
         oacYarYFFCdjXqP0u4KCNrWJCElcgCwKP5MnQZUOq8aS3BdU7tVw25Za8y3YGiTAIsbT
         QKhoK9pyQuU4b9VDl1wRl44WpGUeFs0Omo+cbYWwDeKSIfIslOEg/Q5m7piy/Yv+d4vJ
         quBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qlWbjGxhbYGI6aPovE04MfJwkVfFMUYH/V34f3oOVnQ=;
        b=y+4zM3MjvrN4WoWudXiSIzWYi3Lzu8tt8Bf7fzxaUXoMsiQ5ya3S04cO8o51zJ62FD
         xVUyx38WdaOgTSoBs4AHj5CCIUF/g+JOCAqpfjyyrVJnJjTbs2HRZGL9VNtaaAoLQ0oT
         yI6CclGshGuaq1e0mcZQhKYpJ6n0tXaRBfMiGyGF0aJD3MN/LkcUaw7k7I5cutJXFBAf
         dRxo98dOlL+OYDP28Vs360UGkX3Br9UiqRRZTRZ8lyap/8aYUTkUdZeq5+4m8iPV9wdV
         FcKz9DY87jKVrLTkOTkdXVxEHvZN6sU895xdzz80pvmZ8XOjES3VRLLht6zE29kOR+hL
         ngqw==
X-Gm-Message-State: AOAM533OLc4zccD2L8JI6c/9RQ1mQZ4/bDii0bccLL4InDfZUYp7VPS5
        NuX+AdEjamvoF5u6CA+9wGlRSpn4ZvpJf1BUoV6k0Q==
X-Google-Smtp-Source: ABdhPJwqcxg4MtDog6ZYOa5r1p+JBx8DeiZvPof5BqvjxC1KLLJUROLJZaIBtcUMdNntZGBW8QpAHCh9lmRWVuY6qIA=
X-Received: by 2002:a25:d258:: with SMTP id j85mr2355281ybg.398.1632775674567;
 Mon, 27 Sep 2021 13:47:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210927202923.7360-1-jlundberg@llnw.com>
In-Reply-To: <20210927202923.7360-1-jlundberg@llnw.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 27 Sep 2021 13:47:43 -0700
Message-ID: <CANn89iJP7xpVnw6UnZwnixaAh=2+5f571CiqepYi2sy3-1MXmQ@mail.gmail.com>
Subject: Re: [PATCH] fs: eventpoll: add empty event
To:     Johannes Lundberg <jlundberg@llnw.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        Alexander Aring <aahringo@redhat.com>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        netdev <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 27, 2021 at 1:30 PM Johannes Lundberg <jlundberg@llnw.com> wrote:
>
> The EPOLLEMPTY event will trigger when the TCP write buffer becomes
> empty, i.e., when all outgoing data have been ACKed.
>
> The need for this functionality comes from a business requirement
> of measuring with higher precision how much time is spent
> transmitting data to a client. For reference, similar functionality
> was previously added to FreeBSD as the kqueue event EVFILT_EMPTY.


Adding yet another indirect call [1] in TCP fast path, for something
(measuring with higher precision..)
which is already implemented differently in TCP stack [2] is not desirable.

Our timestamping infrastructure should be ported to FreeBSD instead :)

[1] CONFIG_RETPOLINE=y

[2] Refs :
   commit e1c8a607b28190cd09a271508aa3025d3c2f312e
      net-timestamp: ACK timestamp for bytestreams
    tools/testing/selftests/net/txtimestamp.c
